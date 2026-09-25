#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_craftables;

/*
	Name: __init__sytem__
	Namespace: zm_craftables
	Checksum: 0x66117B17
	Offset: 0x850
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_craftables", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_craftables
	Checksum: 0xB68C2118
	Offset: 0x898
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_finalize_initialization(&set_craftable_clientfield);
}

/*
	Name: init
	Namespace: zm_craftables
	Checksum: 0x8162AB00
	Offset: 0x8C8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(level.craftable_piece_swap_allowed))
	{
		level.craftable_piece_swap_allowed = 1;
	}
	zombie_craftables_callbacks = [];
	level.craftablePickUps = [];
	level.craftables_crafted = [];
	level.a_uts_craftables = [];
	if(!isdefined(level.craftable_piece_count))
	{
		level.craftable_piece_count = 0;
	}
	level._effect["building_dust"] = "zombie/fx_crafting_dust_zmb";
	if(isdefined(level.init_craftables))
	{
		[[level.init_craftables]]();
	}
	open_table = spawnstruct();
	open_table.name = "open_table";
	open_table.triggerThink = &openTableCraftable;
	open_table.custom_craftablestub_update_prompt = &open_craftablestub_update_prompt;
	include_zombie_craftable(open_table);
	add_zombie_craftable("open_table", &"");
	if(isdefined(level.use_swipe_protection))
	{
		callback::on_connect(&craftables_watch_swipes);
	}
}

/*
	Name: __main__
	Namespace: zm_craftables
	Checksum: 0x29762D24
	Offset: 0xA40
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread think_craftables();
	/#
		level thread run_craftables_devgui();
	#/
}

/*
	Name: set_craftable_clientfield
	Namespace: zm_craftables
	Checksum: 0x1F4C0898
	Offset: 0xA80
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function set_craftable_clientfield()
{
	set_piece_count(level.zombie_craftableStubs.size);
}

/*
	Name: anystub_update_prompt
	Namespace: zm_craftables
	Checksum: 0xE2226FA
	Offset: 0xAB0
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function anystub_update_prompt(player)
{
	if(player laststand::player_is_in_laststand() || player zm_utility::in_revive_trigger())
	{
		self.hint_string = "";
		return 0;
	}
	if(isdefined(player.IS_DRINKING) && player.IS_DRINKING > 0)
	{
		self.hint_string = "";
		return 0;
	}
	if(isdefined(player.screecher_weapon))
	{
		self.hint_string = "";
		return 0;
	}
	initial_current_weapon = player GetCurrentWeapon();
	current_weapon = zm_weapons::get_nonalternate_weapon(initial_current_weapon);
	if(zm_equipment::is_equipment(current_weapon))
	{
		self.hint_string = "";
		return 0;
	}
	return 1;
}

/*
	Name: anystub_get_unitrigger_origin
	Namespace: zm_craftables
	Checksum: 0x1B30CEAC
	Offset: 0xBE8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function anystub_get_unitrigger_origin()
{
	if(isdefined(self.origin_parent))
	{
		return self.origin_parent.origin;
	}
	return self.origin;
}

/*
	Name: anystub_on_spawn_trigger
	Namespace: zm_craftables
	Checksum: 0x64B823F8
	Offset: 0xC18
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function anystub_on_spawn_trigger(trigger)
{
	if(isdefined(self.link_parent))
	{
		trigger EnableLinkTo();
		trigger LinkTo(self.link_parent);
		trigger SetMovingPlatformEnabled(1);
	}
}

/*
	Name: craftables_watch_swipes
	Namespace: zm_craftables
	Checksum: 0x944DC059
	Offset: 0xC88
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function craftables_watch_swipes()
{
	self endon("disconnect");
	self notify("craftables_watch_swipes");
	self endon("craftables_watch_swipes");
	while(1)
	{
		self waittill("melee_swipe", zombie);
		if(DistanceSquared(zombie.origin, self.origin) > zombie.meleeAttackDist * zombie.meleeAttackDist)
		{
			continue;
		}
		trigger = level._unitriggers.trigger_pool[self GetEntityNumber()];
		if(isdefined(trigger) && isdefined(trigger.stub.piece))
		{
			piece = trigger.stub.piece;
			if(!isdefined(piece.damage))
			{
				piece.damage = 0;
			}
			piece.damage++;
			if(piece.damage > 12)
			{
				thread zm_equipment::disappear_fx(trigger.stub zm_unitrigger::unitrigger_origin());
				piece piece_unspawn();
				self zm_stats::increment_client_stat("cheat_total", 0);
				if(isalive(self))
				{
					self playlocalsound(level.zmb_laugh_alias);
				}
			}
		}
	}
}

/*
	Name: ExplosionDamage
	Namespace: zm_craftables
	Checksum: 0x1D645E4
	Offset: 0xE90
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function ExplosionDamage(damage, pos)
{
	/#
		println("Dev Block strings are not supported" + damage + "Dev Block strings are not supported" + self.name + "Dev Block strings are not supported");
	#/
	self DoDamage(damage, pos);
}

/*
	Name: make_zombie_craftable_open
	Namespace: zm_craftables
	Checksum: 0x341B1E35
	Offset: 0xF10
	Size: 0xC3
	Parameters: 4
	Flags: None
*/
function make_zombie_craftable_open(str_craftable, STR_MODEL, v_angle_offset, v_origin_offset)
{
	/#
		Assert(isdefined(level.zombie_craftableStubs[str_craftable]), "Dev Block strings are not supported" + str_craftable + "Dev Block strings are not supported");
	#/
	s_craftable = level.zombie_craftableStubs[str_craftable];
	s_craftable.is_open_table = 1;
	s_craftable.STR_MODEL = STR_MODEL;
	s_craftable.v_angle_offset = v_angle_offset;
	s_craftable.v_origin_offset = v_origin_offset;
}

/*
	Name: add_zombie_craftable
	Namespace: zm_craftables
	Checksum: 0x37C6798D
	Offset: 0xFE0
	Size: 0x169
	Parameters: 6
	Flags: None
*/
function add_zombie_craftable(craftable_name, str_to_craft, str_crafting, str_taken, onFullyCrafted, need_all_pieces)
{
	if(!isdefined(level.zombie_include_craftables))
	{
		level.zombie_include_craftables = [];
	}
	if(isdefined(level.zombie_include_craftables) && !isdefined(level.zombie_include_craftables[craftable_name]))
	{
		return;
	}
	craftable_struct = level.zombie_include_craftables[craftable_name];
	if(!isdefined(level.zombie_craftableStubs))
	{
		level.zombie_craftableStubs = [];
	}
	craftable_struct.str_to_craft = str_to_craft;
	craftable_struct.str_crafting = str_crafting;
	craftable_struct.str_taken = str_taken;
	craftable_struct.onFullyCrafted = onFullyCrafted;
	craftable_struct.need_all_pieces = need_all_pieces;
	/#
		println("Dev Block strings are not supported" + craftable_struct.name);
	#/
	level.zombie_craftableStubs[craftable_struct.name] = craftable_struct;
}

/*
	Name: set_hide_model_if_unavailable
	Namespace: zm_craftables
	Checksum: 0xD2CA9B18
	Offset: 0x1158
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function set_hide_model_if_unavailable(craftable_name, hide_when_unavailable)
{
	if(isdefined(level.zombie_craftableStubs[craftable_name]))
	{
		level.zombie_craftableStubs[craftable_name].hide_when_unavailable = hide_when_unavailable;
	}
}

/*
	Name: get_hide_model_if_unavailable
	Namespace: zm_craftables
	Checksum: 0xC078AC9
	Offset: 0x11A8
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function get_hide_model_if_unavailable(craftable_name)
{
	if(isdefined(level.zombie_craftableStubs[craftable_name]))
	{
		return isdefined(level.zombie_craftableStubs[craftable_name].hide_when_unavailable) && level.zombie_craftableStubs[craftable_name].hide_when_unavailable;
	}
	return 0;
}

/*
	Name: set_build_time
	Namespace: zm_craftables
	Checksum: 0xD0A73503
	Offset: 0x1208
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function set_build_time(craftable_name, build_time)
{
	if(isdefined(level.zombie_craftableStubs[craftable_name]))
	{
		level.zombie_craftableStubs[craftable_name].useTime = build_time;
	}
}

/*
	Name: set_piece_count
	Namespace: zm_craftables
	Checksum: 0x3CEFED7
	Offset: 0x1258
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function set_piece_count(n_count)
{
	bits = GetMinBitCountForNum(n_count);
	RegisterClientField("toplayer", "craftable", 1, bits, "int");
}

/*
	Name: add_zombie_craftable_vox_category
	Namespace: zm_craftables
	Checksum: 0xAF93C7E3
	Offset: 0x12C8
	Size: 0x3F
	Parameters: 2
	Flags: None
*/
function add_zombie_craftable_vox_category(craftable_name, vox_id)
{
	craftable_struct = level.zombie_include_craftables[craftable_name];
	craftable_struct.vox_id = vox_id;
}

/*
	Name: include_zombie_craftable
	Namespace: zm_craftables
	Checksum: 0x3799BDB7
	Offset: 0x1310
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function include_zombie_craftable(craftableStub)
{
	if(!isdefined(level.zombie_include_craftables))
	{
		level.zombie_include_craftables = [];
	}
	if(!isdefined(level.craftableIndex))
	{
		level.craftableIndex = 0;
	}
	/#
		println("Dev Block strings are not supported" + craftableStub.name);
	#/
	level.zombie_include_craftables[craftableStub.name] = craftableStub;
	craftableStub.hash_id = HashString(craftableStub.name);
	/#
		level thread add_craftable_cheat(craftableStub);
	#/
}

/*
	Name: generate_zombie_craftable_piece
	Namespace: zm_craftables
	Checksum: 0x9B3C5D7
	Offset: 0x13F0
	Size: 0x46B
	Parameters: 18
	Flags: None
*/
function generate_zombie_craftable_piece(craftablename, pieceName, radius, height, drop_offset, hud_icon, onPickup, onDrop, onCrafted, use_spawn_num, tag_name, can_reuse, client_field_value, is_shared, vox_id, b_one_time_vo, hint_string, slot)
{
	if(!isdefined(is_shared))
	{
		is_shared = 0;
	}
	if(!isdefined(b_one_time_vo))
	{
		b_one_time_vo = 0;
	}
	if(!isdefined(slot))
	{
		slot = 0;
	}
	pieceStub = spawnstruct();
	craftable_pieces = [];
	if(!isdefined(pieceName))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
	}
	craftable_pieces_structs = struct::get_array(craftablename + "_" + pieceName, "targetname");
	if(!isdefined(level.craftablePieceIndex))
	{
		level.craftablePieceIndex = 0;
	}
	foreach(struct in craftable_pieces_structs)
	{
		craftable_pieces[index] = struct;
		craftable_pieces[index].hasSpawned = 0;
	}
	pieceStub.spawns = craftable_pieces;
	pieceStub.craftablename = craftablename;
	pieceStub.pieceName = pieceName;
	if(craftable_pieces.size)
	{
		pieceStub.modelName = craftable_pieces[0].model;
	}
	pieceStub.hud_icon = hud_icon;
	pieceStub.radius = radius;
	pieceStub.height = height;
	pieceStub.tag_name = tag_name;
	pieceStub.can_reuse = can_reuse;
	pieceStub.drop_offset = drop_offset;
	pieceStub.max_instances = 256;
	pieceStub.onPickup = onPickup;
	pieceStub.onDrop = onDrop;
	pieceStub.onCrafted = onCrafted;
	pieceStub.use_spawn_num = use_spawn_num;
	pieceStub.is_shared = is_shared;
	pieceStub.vox_id = vox_id;
	pieceStub.hint_string = hint_string;
	pieceStub.inventory_slot = slot;
	pieceStub.hash_id = HashString(pieceName);
	if(isdefined(b_one_time_vo) && b_one_time_vo)
	{
		pieceStub.b_one_time_vo = b_one_time_vo;
	}
	if(isdefined(client_field_value))
	{
		if(isdefined(is_shared) && is_shared)
		{
			/#
				Assert(IsString(client_field_value), "Dev Block strings are not supported" + pieceName + "Dev Block strings are not supported");
			#/
			pieceStub.client_field_id = client_field_value;
		}
		else
		{
			pieceStub.client_field_state = client_field_value;
		}
	}
	return pieceStub;
}

/*
	Name: manage_multiple_pieces
	Namespace: zm_craftables
	Checksum: 0xA9017466
	Offset: 0x1868
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function manage_multiple_pieces(max_instances)
{
	self.max_instances = max_instances;
	self.managing_pieces = 1;
	self.piece_allocated = [];
}

/*
	Name: combine_craftable_pieces
	Namespace: zm_craftables
	Checksum: 0x2730D066
	Offset: 0x18A0
	Size: 0x137
	Parameters: 3
	Flags: None
*/
function combine_craftable_pieces(piece1, piece2, piece3)
{
	spawns1 = piece1.spawns;
	spawns2 = piece2.spawns;
	spawns = ArrayCombine(spawns1, spawns2, 1, 0);
	if(isdefined(piece3))
	{
		spawns3 = piece3.spawns;
		spawns = ArrayCombine(spawns, spawns3, 1, 0);
		spawns = Array::randomize(spawns);
		piece3.spawns = spawns;
	}
	else
	{
		spawns = Array::randomize(spawns);
	}
	piece1.spawns = spawns;
	piece2.spawns = spawns;
}

/*
	Name: add_craftable_piece
	Namespace: zm_craftables
	Checksum: 0xE6CDC6A1
	Offset: 0x19E0
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function add_craftable_piece(pieceStub, tag_name, can_reuse)
{
	if(!isdefined(self.a_piecestubs))
	{
		self.a_piecestubs = [];
	}
	if(isdefined(tag_name))
	{
		pieceStub.tag_name = tag_name;
	}
	if(isdefined(can_reuse))
	{
		pieceStub.can_reuse = can_reuse;
	}
	self.a_piecestubs[self.a_piecestubs.size] = pieceStub;
	if(!isdefined(self.inventory_slot))
	{
		self.inventory_slot = pieceStub.inventory_slot;
	}
	/#
		/#
			Assert(self.inventory_slot == pieceStub.inventory_slot, "Dev Block strings are not supported");
		#/
	#/
}

/*
	Name: player_drop_piece_on_downed
	Namespace: zm_craftables
	Checksum: 0x1D4E0CAC
	Offset: 0x1AD0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function player_drop_piece_on_downed(slot)
{
	self endon("craftable_piece_released" + slot);
	self waittill("bled_out");
	onPlayerLastStand();
}

/*
	Name: onPlayerLastStand
	Namespace: zm_craftables
	Checksum: 0x82446E2D
	Offset: 0x1B18
	Size: 0x199
	Parameters: 0
	Flags: None
*/
function onPlayerLastStand()
{
	if(!isdefined(self.current_craftable_pieces))
	{
		self.current_craftable_pieces = [];
	}
	foreach(piece in self.current_craftable_pieces)
	{
		if(isdefined(piece))
		{
			return_to_start_pos = 0;
			if(isdefined(level.safe_place_for_craftable_piece))
			{
				if(!self [[level.safe_place_for_craftable_piece]](piece))
				{
					return_to_start_pos = 1;
				}
			}
			if(return_to_start_pos)
			{
				piece piece_spawn_at();
			}
			else
			{
				piece piece_spawn_at(self.origin + VectorScale((1, 1, 0), 5), self.angles);
			}
			if(isdefined(piece.onDrop))
			{
				piece [[piece.onDrop]](self);
			}
			self clientfield::set_to_player("craftable", 0);
		}
		self.current_craftable_pieces[index] = undefined;
		self notify("craftable_piece_released" + index);
	}
}

/*
	Name: piecestub_get_unitrigger_origin
	Namespace: zm_craftables
	Checksum: 0xE1EC01DD
	Offset: 0x1CC0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function piecestub_get_unitrigger_origin()
{
	if(isdefined(self.origin_parent))
	{
		return self.origin_parent.origin + VectorScale((0, 0, 1), 12);
	}
	return self.origin;
}

/*
	Name: generate_piece_unitrigger
	Namespace: zm_craftables
	Checksum: 0x2B49F85C
	Offset: 0x1D00
	Size: 0x3CF
	Parameters: 9
	Flags: None
*/
function generate_piece_unitrigger(classname, origin, angles, flags, radius, script_height, hint_string, moving, b_nolook)
{
	if(!isdefined(radius))
	{
		radius = 64;
	}
	if(!isdefined(script_height))
	{
		script_height = 64;
	}
	script_width = script_height;
	if(!isdefined(script_width))
	{
		script_width = 64;
	}
	script_length = script_height;
	if(!isdefined(script_length))
	{
		script_length = 64;
	}
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = origin;
	if(isdefined(script_length))
	{
		unitrigger_stub.script_length = script_length;
	}
	else
	{
		unitrigger_stub.script_length = 13.5;
	}
	if(isdefined(script_width))
	{
		unitrigger_stub.script_width = script_width;
	}
	else
	{
		unitrigger_stub.script_width = 27.5;
	}
	if(isdefined(script_height))
	{
		unitrigger_stub.script_height = script_height;
	}
	else
	{
		unitrigger_stub.script_height = 24;
	}
	unitrigger_stub.radius = radius;
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	if(isdefined(hint_string))
	{
		unitrigger_stub.hint_string_override = hint_string;
		unitrigger_stub.hint_string = unitrigger_stub.hint_string_override;
	}
	else
	{
		unitrigger_stub.hint_string = &"ZOMBIE_BUILD_PIECE_GRAB";
	}
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	if(isdefined(b_nolook) && (isdefined(Int(b_nolook)) && Int(b_nolook)))
	{
		unitrigger_stub.require_look_toward = 0;
	}
	unitrigger_stub.require_look_at = 0;
	switch(classname)
	{
		case "trigger_radius":
		{
			unitrigger_stub.script_unitrigger_type = "unitrigger_radius";
			break;
		}
		case "trigger_radius_use":
		{
			unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
			break;
		}
		case "trigger_box":
		{
			unitrigger_stub.script_unitrigger_type = "unitrigger_box";
			break;
		}
		case "trigger_box_use":
		{
			unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
			break;
		}
	}
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &piecetrigger_update_prompt;
	unitrigger_stub.originFunc = &piecestub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;
	if(isdefined(moving) && moving)
	{
		zm_unitrigger::register_unitrigger(unitrigger_stub, &piece_unitrigger_think);
	}
	else
	{
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &piece_unitrigger_think);
	}
	return unitrigger_stub;
}

/*
	Name: piecetrigger_update_prompt
	Namespace: zm_craftables
	Checksum: 0x5092700A
	Offset: 0x20D8
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function piecetrigger_update_prompt(player)
{
	if(!isdefined(player.current_craftable_pieces))
	{
		player.current_craftable_pieces = [];
	}
	can_use = self.stub piecestub_update_prompt(player);
	self SetInvisibleToPlayer(player, !can_use);
	self setHintString(self.stub.hint_string);
	return can_use;
}

/*
	Name: piecestub_update_prompt
	Namespace: zm_craftables
	Checksum: 0xCD12DF50
	Offset: 0x2180
	Size: 0x1A3
	Parameters: 2
	Flags: None
*/
function piecestub_update_prompt(player, slot)
{
	if(!isdefined(slot))
	{
		slot = self.piece.inventory_slot;
	}
	if(!self anystub_update_prompt(player))
	{
		return 0;
	}
	if(isdefined(player.current_craftable_pieces[slot]) && (!isdefined(self.piece.is_shared) && self.piece.is_shared))
	{
		if(!level.craftable_piece_swap_allowed)
		{
			self.hint_string = &"ZOMBIE_CRAFTABLE_NO_SWITCH";
		}
		else
		{
			spiece = self.piece;
			cpiece = player.current_craftable_pieces[slot];
			if(spiece.pieceName == cpiece.pieceName && spiece.craftablename == cpiece.craftablename)
			{
				self.hint_string = "";
				return 0;
			}
			if(isdefined(self.hint_string_override))
			{
				self.hint_string = self.hint_string_override;
			}
			else
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_SWITCH";
			}
		}
	}
	else if(isdefined(self.hint_string_override))
	{
		self.hint_string = self.hint_string_override;
	}
	else
	{
		self.hint_string = &"ZOMBIE_BUILD_PIECE_GRAB";
	}
	return 1;
}

/*
	Name: piece_unitrigger_think
	Namespace: zm_craftables
	Checksum: 0xF3C80829
	Offset: 0x2330
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function piece_unitrigger_think()
{
	self endon("kill_trigger");
	slot = self.stub.piece.inventory_slot;
	while(1)
	{
		self waittill("trigger", player);
		self.stub notify("trigger", player);
		if(player != self.parent_player)
		{
			continue;
		}
		if(isdefined(player.screecher_weapon))
		{
			continue;
		}
		if(!level.craftable_piece_swap_allowed && isdefined(player.current_craftable_pieces[slot]) && (!isdefined(self.stub.piece.is_shared) && self.stub.piece.is_shared))
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			player thread zm_utility::ignore_triggers(0.5);
			continue;
		}
		status = player player_can_take_piece(self.stub.piece);
		if(!status)
		{
			self.stub.hint_string = "";
			self setHintString(self.stub.hint_string);
		}
		else
		{
			player thread player_take_piece(self.stub.piece);
		}
	}
}

/*
	Name: player_can_take_piece
	Namespace: zm_craftables
	Checksum: 0xECEF8BFB
	Offset: 0x2510
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function player_can_take_piece(piece)
{
	if(!isdefined(piece))
	{
		return 0;
	}
	return 1;
}

/*
	Name: DBLine
	Namespace: zm_craftables
	Checksum: 0xDA0D3809
	Offset: 0x2538
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function DBLine(from, to)
{
	/#
		time = 20;
		while(time > 0)
		{
			line(from, to, (0, 0, 1), 0, 1);
			time = time - 0.05;
			wait(0.05);
		}
	#/
}

/*
	Name: player_throw_piece
	Namespace: zm_craftables
	Checksum: 0xEB918051
	Offset: 0x25C0
	Size: 0x393
	Parameters: 6
	Flags: None
*/
function player_throw_piece(piece, origin, dir, return_to_spawn, return_time, endAngles)
{
	/#
		Assert(isdefined(piece));
	#/
	if(isdefined(piece))
	{
		/#
			thread DBLine(origin, origin + dir);
		#/
		pass = 0;
		done = 0;
		altmodel = undefined;
		while(pass < 2 && !done)
		{
			grenade = self MagicGrenadeType("buildable_piece", origin, dir, 30000);
			grenade thread watch_hit_players();
			grenade ghost();
			if(!isdefined(altmodel))
			{
				altmodel = spawn("script_model", grenade.origin);
				altmodel SetModel(piece.modelName);
			}
			altmodel.origin = grenade.angles;
			altmodel.angles = grenade.angles;
			altmodel LinkTo(grenade, "", (0, 0, 0), (0, 0, 0));
			grenade.altmodel = altmodel;
			grenade waittill("stationary");
			grenade_origin = grenade.origin;
			grenade_angles = grenade.angles;
			landed_on = grenade GetGroundEnt();
			grenade delete();
			if(isdefined(landed_on) && landed_on == level)
			{
				done = 1;
			}
			else
			{
				origin = grenade_origin;
				dir = (dir[0] * -1 / 10, dir[1] * -1 / 10, -1);
				pass++;
			}
		}
		if(!isdefined(endAngles))
		{
			endAngles = grenade_angles;
		}
		piece piece_spawn_at(grenade_origin, endAngles);
		if(isdefined(altmodel))
		{
			altmodel delete();
		}
		if(isdefined(piece.onDrop))
		{
			piece [[piece.onDrop]](self);
		}
		if(isdefined(return_to_spawn) && return_to_spawn)
		{
			piece piece_wait_and_return(return_time);
		}
	}
}

/*
	Name: watch_hit_players
	Namespace: zm_craftables
	Checksum: 0xCE2EC3FD
	Offset: 0x2960
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function watch_hit_players()
{
	self endon("death");
	self endon("stationary");
	while(isdefined(self))
	{
		self waittill("grenade_bounce", pos, normal, ent);
		if(isPlayer(ent))
		{
			ent ExplosionDamage(25, pos);
		}
	}
}

/*
	Name: piece_wait_and_return
	Namespace: zm_craftables
	Checksum: 0xBE217048
	Offset: 0x29F8
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function piece_wait_and_return(return_time)
{
	self endon("pickup");
	wait(0.15);
	if(isdefined(level.exploding_jetgun_fx))
	{
		PlayFXOnTag(level.exploding_jetgun_fx, self.model, "tag_origin");
	}
	else
	{
		PlayFXOnTag(level._effect["powerup_on"], self.model, "tag_origin");
	}
	wait(return_time - 6);
	self piece_hide();
	wait(1);
	self piece_show();
	wait(1);
	self piece_hide();
	wait(1);
	self piece_show();
	wait(1);
	self piece_hide();
	wait(1);
	self piece_show();
	wait(1);
	self notify("Respawn");
	self piece_unspawn();
	self piece_spawn_at();
}

/*
	Name: player_return_piece_to_original_spawn
	Namespace: zm_craftables
	Checksum: 0x78AC59A5
	Offset: 0x2B68
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function player_return_piece_to_original_spawn(slot)
{
	if(!isdefined(slot))
	{
		slot = 0;
	}
	self notify("craftable_piece_released" + slot);
	piece = self.current_craftable_pieces[slot];
	self.current_craftable_pieces[slot] = undefined;
	if(isdefined(piece))
	{
		piece piece_spawn_at();
		self clientfield::set_to_player("craftable", 0);
	}
}

/*
	Name: player_drop_piece_on_death
	Namespace: zm_craftables
	Checksum: 0x713090F2
	Offset: 0x2C10
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function player_drop_piece_on_death(slot)
{
	if(!isdefined(slot))
	{
		slot = 0;
	}
	self notify("craftable_piece_released" + slot);
	self endon("craftable_piece_released" + slot);
	self thread player_drop_piece_on_downed(slot);
	origin = self.origin;
	angles = self.angles;
	piece = self.current_craftable_pieces[slot];
	if(isdefined(piece) && isdefined(piece.start_origin))
	{
		origin = piece.start_origin;
		angles = piece.start_angles;
	}
	self waittill("disconnect");
	piece piece_spawn_at(origin, angles);
	if(isdefined(self))
	{
		self clientfield::set_to_player("craftable", 0);
	}
}

/*
	Name: player_drop_piece
	Namespace: zm_craftables
	Checksum: 0xA99DEB56
	Offset: 0x2D50
	Size: 0xE3
	Parameters: 2
	Flags: None
*/
function player_drop_piece(piece, slot)
{
	if(!isdefined(piece))
	{
		piece = self.current_craftable_pieces[slot];
	}
	if(isdefined(piece))
	{
		piece.damage = 0;
		piece piece_spawn_at(self.origin, self.angles);
		self clientfield::set_to_player("craftable", 0);
		if(isdefined(piece.onDrop))
		{
			piece [[piece.onDrop]](self);
		}
	}
	self.current_craftable_pieces[slot] = undefined;
	self notify("craftable_piece_released" + slot);
}

/*
	Name: player_take_piece
	Namespace: zm_craftables
	Checksum: 0x17D5F1B5
	Offset: 0x2E40
	Size: 0x2CB
	Parameters: 1
	Flags: None
*/
function player_take_piece(pieceSpawn)
{
	pieceStub = pieceSpawn.pieceStub;
	slot = pieceStub.inventory_slot;
	damage = pieceSpawn.damage;
	if(!isdefined(self.current_craftable_pieces))
	{
		self.current_craftable_pieces = [];
	}
	self notify("player_got_craftable_piece_for_" + pieceSpawn.craftablename);
	if(!isdefined(pieceStub.is_shared) && pieceStub.is_shared && isdefined(self.current_craftable_pieces[slot]))
	{
		other_piece = self.current_craftable_pieces[slot];
		self player_drop_piece(self.current_craftable_piece, slot);
		other_piece.damage = damage;
		self zm_utility::do_player_general_vox("general", "craft_swap");
	}
	if(isdefined(pieceStub.onPickup))
	{
		pieceSpawn [[pieceStub.onPickup]](self);
	}
	if(isdefined(pieceStub.is_shared) && pieceStub.is_shared)
	{
		if(isdefined(pieceStub.client_field_id))
		{
			level clientfield::set(pieceStub.client_field_id, 1);
		}
	}
	else if(isdefined(pieceStub.client_field_state))
	{
		self clientfield::set_to_player("craftable", pieceStub.client_field_state);
	}
	pieceSpawn piece_unspawn();
	pieceSpawn notify("pickup");
	if(isdefined(pieceStub.is_shared) && pieceStub.is_shared)
	{
		pieceSpawn.in_shared_inventory = 1;
	}
	else
	{
		slot = pieceSpawn.inventory_slot;
		self.current_craftable_pieces[slot] = pieceSpawn;
		self thread player_drop_piece_on_death(slot);
	}
	self track_craftable_piece_pickedup(pieceSpawn);
}

/*
	Name: player_destroy_piece
	Namespace: zm_craftables
	Checksum: 0x6C578A7
	Offset: 0x3118
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function player_destroy_piece(piece, slot)
{
	if(!isdefined(piece))
	{
		piece = self.current_craftable_pieces[slot];
	}
	if(isdefined(piece))
	{
		self clientfield::set_to_player("craftable", 0);
	}
	self.current_craftable_pieces[slot] = undefined;
	self notify("craftable_piece_released" + slot);
}

/*
	Name: claim_location
	Namespace: zm_craftables
	Checksum: 0x47112AA6
	Offset: 0x31A0
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function claim_location(location)
{
	if(!isdefined(level.craftable_claimed_locations))
	{
		level.craftable_claimed_locations = [];
	}
	if(!isdefined(level.craftable_claimed_locations[location]))
	{
		level.craftable_claimed_locations[location] = 1;
		return 1;
	}
	return 0;
}

/*
	Name: is_point_in_craft_trigger
	Namespace: zm_craftables
	Checksum: 0xBE93CABB
	Offset: 0x3200
	Size: 0x181
	Parameters: 1
	Flags: None
*/
function is_point_in_craft_trigger(point)
{
	candidate_list = [];
	foreach(zone in level.zones)
	{
		if(isdefined(zone.unitrigger_stubs))
		{
			candidate_list = ArrayCombine(candidate_list, zone.unitrigger_stubs, 1, 0);
		}
	}
	valid_range = 128;
	closest = zm_unitrigger::get_closest_unitriggers(point, candidate_list, valid_range);
	for(index = 0; index < closest.size; index++)
	{
		if(isdefined(closest[index].registered) && closest[index].registered && isdefined(closest[index].piece))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: piece_allocate_spawn
	Namespace: zm_craftables
	Checksum: 0x2008BE12
	Offset: 0x3390
	Size: 0x2CD
	Parameters: 1
	Flags: None
*/
function piece_allocate_spawn(pieceStub)
{
	self.current_spawn = 0;
	self.managed_spawn = 1;
	self.pieceStub = pieceStub;
	if(self.spawns.size >= 1 && self.spawns.size > 1)
	{
		any_good = 0;
		any_okay = 0;
		totalWeight = 0;
		spawnweights = [];
		for(i = 0; i < self.spawns.size; i++)
		{
			if(isdefined(pieceStub.piece_allocated[i]) && pieceStub.piece_allocated[i])
			{
				spawnweights[i] = 0;
			}
			else if(is_point_in_craft_trigger(self.spawns[i].origin))
			{
				any_okay = 1;
				spawnweights[i] = 0.01;
			}
			else
			{
				any_good = 1;
				spawnweights[i] = 1;
			}
			totalWeight = totalWeight + spawnweights[i];
		}
		/#
			/#
				Assert(any_good || any_okay, "Dev Block strings are not supported");
			#/
		#/
		if(any_good)
		{
			totalWeight = float(Int(totalWeight));
		}
		r = RandomFloat(totalWeight);
		for(i = 0; i < self.spawns.size; i++)
		{
			if(!any_good || spawnweights[i] >= 1)
			{
				r = r - spawnweights[i];
				if(r < 0)
				{
					self.current_spawn = i;
					pieceStub.piece_allocated[self.current_spawn] = 1;
					return;
				}
			}
		}
		self.current_spawn = RandomInt(self.spawns.size);
		pieceStub.piece_allocated[self.current_spawn] = 1;
	}
}

/*
	Name: piece_deallocate_spawn
	Namespace: zm_craftables
	Checksum: 0x89126B67
	Offset: 0x3668
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function piece_deallocate_spawn()
{
	if(isdefined(self.current_spawn))
	{
		self.pieceStub.piece_allocated[self.current_spawn] = 0;
		self.current_spawn = undefined;
	}
	self.start_origin = undefined;
}

/*
	Name: piece_pick_random_spawn
	Namespace: zm_craftables
	Checksum: 0x558FC31E
	Offset: 0x36B0
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function piece_pick_random_spawn()
{
	self.current_spawn = 0;
	if(self.spawns.size >= 1 && self.spawns.size > 1)
	{
		self.current_spawn = RandomInt(self.spawns.size);
		while(isdefined(self.spawns[self.current_spawn].claim_location) && !claim_location(self.spawns[self.current_spawn].claim_location))
		{
			ArrayRemoveIndex(self.spawns, self.current_spawn);
			if(self.spawns.size < 1)
			{
				self.current_spawn = 0;
				/#
					println("Dev Block strings are not supported");
				#/
				return;
			}
			self.current_spawn = RandomInt(self.spawns.size);
		}
	}
}

/*
	Name: piece_set_spawn
	Namespace: zm_craftables
	Checksum: 0x6B059A5E
	Offset: 0x37F0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function piece_set_spawn(num)
{
	self.current_spawn = 0;
	if(self.spawns.size >= 1 && self.spawns.size > 1)
	{
		self.current_spawn = Int(min(num, self.spawns.size - 1));
	}
}

/*
	Name: piece_spawn_in
	Namespace: zm_craftables
	Checksum: 0xD2FC450E
	Offset: 0x3878
	Size: 0x367
	Parameters: 1
	Flags: None
*/
function piece_spawn_in(pieceStub)
{
	if(self.spawns.size < 1)
	{
		return;
	}
	if(isdefined(self.managed_spawn) && self.managed_spawn)
	{
		if(!isdefined(self.current_spawn))
		{
			self piece_allocate_spawn(self.pieceStub);
		}
	}
	if(!isdefined(self.current_spawn))
	{
		self.current_spawn = 0;
	}
	spawndef = self.spawns[self.current_spawn];
	self.unitrigger = generate_piece_unitrigger("trigger_radius_use", spawndef.origin + VectorScale((0, 0, 1), 12), spawndef.angles, 0, pieceStub.radius, pieceStub.height, pieceStub.hint_string, 0, spawndef.script_string);
	self.unitrigger.piece = self;
	self.radius = pieceStub.radius;
	self.height = pieceStub.height;
	self.craftablename = pieceStub.craftablename;
	self.pieceName = pieceStub.pieceName;
	self.modelName = pieceStub.modelName;
	self.hud_icon = pieceStub.hud_icon;
	self.tag_name = pieceStub.tag_name;
	self.drop_offset = pieceStub.drop_offset;
	self.start_origin = spawndef.origin;
	self.start_angles = spawndef.angles;
	self.client_field_state = pieceStub.client_field_state;
	self.is_shared = pieceStub.is_shared;
	self.inventory_slot = pieceStub.inventory_slot;
	self.model = spawn("script_model", self.start_origin);
	if(isdefined(self.start_angles))
	{
		self.model.angles = self.start_angles;
	}
	self.model SetModel(pieceStub.modelName);
	if(isdefined(pieceStub.onSpawn))
	{
		self [[pieceStub.onSpawn]]();
	}
	self.model GhostInDemo();
	self.model.hud_icon = pieceStub.hud_icon;
	self.pieceStub = pieceStub;
	self.unitrigger.origin_parent = self.model;
}

/*
	Name: piece_spawn_at
	Namespace: zm_craftables
	Checksum: 0x89086E18
	Offset: 0x3BE8
	Size: 0x3E7
	Parameters: 3
	Flags: None
*/
function piece_spawn_at(origin, angles, use_random_start)
{
	if(self.spawns.size < 1)
	{
		return;
	}
	if(isdefined(self.managed_spawn) && self.managed_spawn)
	{
		if(!isdefined(self.current_spawn) && !isdefined(origin))
		{
			self piece_allocate_spawn(self.pieceStub);
			spawndef = self.spawns[self.current_spawn];
			self.start_origin = spawndef.origin;
			self.start_angles = spawndef.angles;
		}
	}
	else if(!isdefined(self.current_spawn))
	{
		self.current_spawn = 0;
	}
	unitrigger_offset = VectorScale((0, 0, 1), 12);
	if(isdefined(use_random_start) && use_random_start)
	{
		self piece_pick_random_spawn();
		spawndef = self.spawns[self.current_spawn];
		self.start_origin = spawndef.origin;
		self.start_angles = spawndef.angles;
		origin = spawndef.origin;
		angles = spawndef.angles;
	}
	else if(!isdefined(origin))
	{
		origin = self.start_origin;
	}
	else
	{
		origin = origin + (0, 0, self.drop_offset);
		unitrigger_offset = unitrigger_offset - (0, 0, self.drop_offset);
	}
	if(!isdefined(angles))
	{
		angles = self.start_angles;
	}
	/#
		if(!isdefined(level.drop_offset))
		{
			level.drop_offset = 0;
		}
		origin = origin + (0, 0, level.drop_offset);
		unitrigger_offset = unitrigger_offset - (0, 0, level.drop_offset);
	#/
	self.model = spawn("script_model", origin);
	if(isdefined(angles))
	{
		self.model.angles = angles;
	}
	self.model SetModel(self.modelName);
	if(isdefined(level.equipment_safe_to_drop))
	{
		if(![[level.equipment_safe_to_drop]](self.model))
		{
			origin = self.start_origin;
			angles = self.start_angles;
			self.model.origin = origin;
			self.model.angles = angles;
		}
	}
	if(isdefined(self.onSpawn))
	{
		self [[self.onSpawn]]();
	}
	self.unitrigger = generate_piece_unitrigger("trigger_radius_use", origin + unitrigger_offset, angles, 0, self.radius, self.height, self.pieceStub.hint_string, isdefined(self.model.canMove) && self.model.canMove);
	self.unitrigger.piece = self;
	self.model.hud_icon = self.hud_icon;
	self.unitrigger.origin_parent = self.model;
}

/*
	Name: piece_unspawn
	Namespace: zm_craftables
	Checksum: 0x647030C0
	Offset: 0x3FD8
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function piece_unspawn()
{
	if(isdefined(self.managed_spawn) && self.managed_spawn)
	{
		self piece_deallocate_spawn();
	}
	if(isdefined(self.model))
	{
		self.model delete();
	}
	self.model = undefined;
	if(isdefined(self.unitrigger))
	{
		thread zm_unitrigger::unregister_unitrigger(self.unitrigger);
	}
	self.unitrigger = undefined;
}

/*
	Name: piece_hide
	Namespace: zm_craftables
	Checksum: 0x880D7B83
	Offset: 0x4070
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function piece_hide()
{
	if(isdefined(self.model))
	{
		self.model ghost();
	}
}

/*
	Name: piece_show
	Namespace: zm_craftables
	Checksum: 0x6F0D7FEC
	Offset: 0x40A8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function piece_show()
{
	if(isdefined(self.model))
	{
		self.model show();
	}
}

/*
	Name: generate_piece
	Namespace: zm_craftables
	Checksum: 0xBEC06037
	Offset: 0x40E0
	Size: 0x22B
	Parameters: 1
	Flags: None
*/
function generate_piece(pieceStub)
{
	pieceSpawn = spawnstruct();
	pieceSpawn.spawns = pieceStub.spawns;
	if(isdefined(pieceStub.managing_pieces) && pieceStub.managing_pieces)
	{
		pieceSpawn piece_allocate_spawn(pieceStub);
	}
	else if(isdefined(pieceStub.use_spawn_num))
	{
		pieceSpawn piece_set_spawn(pieceStub.use_spawn_num);
	}
	else
	{
		pieceSpawn piece_pick_random_spawn();
	}
	if(isdefined(pieceStub.special_spawn_func))
	{
		pieceSpawn [[pieceStub.special_spawn_func]](pieceStub);
	}
	else
	{
		pieceSpawn piece_spawn_in(pieceStub);
	}
	if(pieceSpawn.spawns.size >= 1)
	{
		pieceSpawn.hud_icon = pieceStub.hud_icon;
	}
	if(isdefined(pieceStub.onPickup))
	{
		pieceSpawn.onPickup = pieceStub.onPickup;
	}
	else
	{
		pieceSpawn.onPickup = &onPickupUTS;
	}
	if(isdefined(pieceStub.onDrop))
	{
		pieceSpawn.onDrop = pieceStub.onDrop;
	}
	else
	{
		pieceSpawn.onDrop = &onDropUTS;
	}
	if(isdefined(pieceStub.onCrafted))
	{
		pieceSpawn.onCrafted = pieceStub.onCrafted;
	}
	return pieceSpawn;
}

/*
	Name: craftable_piece_unitriggers
	Namespace: zm_craftables
	Checksum: 0xA183902E
	Offset: 0x4318
	Size: 0x32B
	Parameters: 2
	Flags: None
*/
function craftable_piece_unitriggers(craftable_name, origin)
{
	/#
		Assert(isdefined(craftable_name));
	#/
	/#
		Assert(isdefined(level.zombie_craftableStubs[craftable_name]), "Dev Block strings are not supported" + craftable_name);
	#/
	craftable = level.zombie_craftableStubs[craftable_name];
	if(!isdefined(craftable.a_piecestubs))
	{
		craftable.a_piecestubs = [];
	}
	level flag::wait_till("start_zombie_round_logic");
	craftableSpawn = spawnstruct();
	craftableSpawn.craftable_name = craftable_name;
	if(!isdefined(craftableSpawn.a_pieceSpawns))
	{
		craftableSpawn.a_pieceSpawns = [];
	}
	craftablePickUps = [];
	foreach(pieceStub in craftable.a_piecestubs)
	{
		if(!isdefined(craftableSpawn.inventory_slot))
		{
			craftableSpawn.inventory_slot = pieceStub.inventory_slot;
		}
		/#
			/#
				Assert(craftableSpawn.inventory_slot == pieceStub.inventory_slot, "Dev Block strings are not supported");
			#/
		#/
		if(!isdefined(pieceStub.generated_instances))
		{
			pieceStub.generated_instances = 0;
		}
		if(isdefined(pieceStub.pieceSpawn) && (isdefined(pieceStub.can_reuse) && pieceStub.can_reuse))
		{
			piece = pieceStub.pieceSpawn;
		}
		else if(pieceStub.generated_instances >= pieceStub.max_instances)
		{
			piece = pieceStub.pieceSpawn;
		}
		else
		{
			piece = generate_piece(pieceStub);
			pieceStub.pieceSpawn = piece;
			pieceStub.generated_instances++;
		}
		craftableSpawn.a_pieceSpawns[craftableSpawn.a_pieceSpawns.size] = piece;
	}
	craftableSpawn.stub = self;
	return craftableSpawn;
}

/*
	Name: hide_craftable_table_model
	Namespace: zm_craftables
	Checksum: 0xE23E7E74
	Offset: 0x4650
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function hide_craftable_table_model(trigger_targetname)
{
	trig = GetEnt(trigger_targetname, "targetname");
	if(!isdefined(trig))
	{
		return;
	}
	if(isdefined(trig.target))
	{
		model = GetEnt(trig.target, "targetname");
		if(isdefined(model))
		{
			model ghost();
			model notsolid();
		}
	}
}

/*
	Name: setup_unitrigger_craftable
	Namespace: zm_craftables
	Checksum: 0x3EDB7E66
	Offset: 0x4720
	Size: 0x91
	Parameters: 6
	Flags: None
*/
function setup_unitrigger_craftable(trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	trig = GetEnt(trigger_targetname, "targetname");
	if(!isdefined(trig))
	{
		return;
	}
	return setup_unitrigger_craftable_internal(trig, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent);
}

/*
	Name: setup_unitrigger_craftable_array
	Namespace: zm_craftables
	Checksum: 0xE0EDC495
	Offset: 0x47C0
	Size: 0x119
	Parameters: 6
	Flags: None
*/
function setup_unitrigger_craftable_array(trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	triggers = GetEntArray(trigger_targetname, "targetname");
	stubs = [];
	foreach(trig in triggers)
	{
		stubs[stubs.size] = setup_unitrigger_craftable_internal(trig, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent);
	}
	return stubs;
}

/*
	Name: setup_unitrigger_craftable_internal
	Namespace: zm_craftables
	Checksum: 0xE534B9B
	Offset: 0x48E8
	Size: 0x9BD
	Parameters: 6
	Flags: None
*/
function setup_unitrigger_craftable_internal(trig, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	if(!isdefined(trig))
	{
		return;
	}
	unitrigger_stub = spawnstruct();
	unitrigger_stub.craftableStub = level.zombie_include_craftables[equipname];
	angles = trig.script_angles;
	if(!isdefined(angles))
	{
		angles = (0, 0, 0);
	}
	unitrigger_stub.origin = trig.origin + AnglesToRight(angles) * -6;
	unitrigger_stub.angles = trig.angles;
	if(isdefined(trig.script_angles))
	{
		unitrigger_stub.angles = trig.script_angles;
	}
	unitrigger_stub.equipname = equipname;
	unitrigger_stub.weaponName = GetWeapon(weaponName);
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.DELETE_TRIGGER = DELETE_TRIGGER;
	unitrigger_stub.crafted = 0;
	unitrigger_stub.Persistent = Persistent;
	unitrigger_stub.useTime = Int(3000);
	if(isdefined(self.useTime))
	{
		unitrigger_stub.useTime = self.useTime;
	}
	else if(isdefined(trig.useTime))
	{
		unitrigger_stub.useTime = trig.useTime;
	}
	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;
	tmins = trig GetMins();
	tmaxs = trig GetMaxs();
	tsize = tmaxs - tmins;
	if(isdefined(trig.script_depth))
	{
		unitrigger_stub.script_length = trig.script_depth;
	}
	else
	{
		unitrigger_stub.script_length = tsize[1];
	}
	if(isdefined(trig.script_width))
	{
		unitrigger_stub.script_width = trig.script_width;
	}
	else
	{
		unitrigger_stub.script_width = tsize[0];
	}
	if(isdefined(trig.script_height))
	{
		unitrigger_stub.script_height = trig.script_height;
	}
	else
	{
		unitrigger_stub.script_height = tsize[2];
	}
	unitrigger_stub.target = trig.target;
	unitrigger_stub.targetname = trig.targetname;
	unitrigger_stub.script_noteworthy = trig.script_noteworthy;
	unitrigger_stub.script_parameters = trig.script_parameters;
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	if(isdefined(level.zombie_craftableStubs[equipname].str_to_craft))
	{
		unitrigger_stub.hint_string = level.zombie_craftableStubs[equipname].str_to_craft;
	}
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = 1;
	unitrigger_stub.require_look_toward = 0;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	if(isdefined(unitrigger_stub.craftableStub.custom_craftablestub_update_prompt))
	{
		unitrigger_stub.custom_craftablestub_update_prompt = unitrigger_stub.craftableStub.custom_craftablestub_update_prompt;
	}
	unitrigger_stub.prompt_and_visibility_func = &craftabletrigger_update_prompt;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &craftable_place_think);
	unitrigger_stub.piece_trigger = trig;
	trig.trigger_stub = unitrigger_stub;
	if(isdefined(trig.zombie_weapon_upgrade))
	{
		unitrigger_stub.zombie_weapon_upgrade = GetWeapon(trig.zombie_weapon_upgrade);
	}
	if(isdefined(unitrigger_stub.target))
	{
		unitrigger_stub.model = GetEnt(unitrigger_stub.target, "targetname");
		if(isdefined(unitrigger_stub.model))
		{
			if(isdefined(unitrigger_stub.zombie_weapon_upgrade))
			{
				unitrigger_stub.model UseWeaponHideTags(unitrigger_stub.zombie_weapon_upgrade);
			}
			if(isdefined(unitrigger_stub.model.script_parameters))
			{
				a_utm_params = StrTok(unitrigger_stub.model.script_parameters, " ");
				foreach(Param in a_utm_params)
				{
					if(Param == "starts_visible")
					{
						b_start_visible = 1;
						continue;
						continue;
					}
					if(Param == "starts_empty")
					{
						b_start_empty = 1;
					}
				}
			}
			else if(b_start_visible !== 1)
			{
				unitrigger_stub.model ghost();
				unitrigger_stub.model notsolid();
			}
		}
	}
	if(unitrigger_stub.equipname == "open_table")
	{
		unitrigger_stub.a_uts_open_craftables_available = [];
		unitrigger_stub.n_open_craftable_choice = -1;
		unitrigger_stub.b_open_craftable_checking_input = 0;
	}
	unitrigger_stub.craftableSpawn = unitrigger_stub craftable_piece_unitriggers(equipname, unitrigger_stub.origin);
	if(isdefined(unitrigger_stub.model) && b_start_empty === 1)
	{
		for(i = 0; i < unitrigger_stub.craftableSpawn.a_pieceSpawns.size; i++)
		{
			if(isdefined(unitrigger_stub.craftableSpawn.a_pieceSpawns[i].tag_name))
			{
				if(unitrigger_stub.craftableSpawn.a_pieceSpawns[i].crafted !== 1)
				{
					unitrigger_stub.model HidePart(unitrigger_stub.craftableSpawn.a_pieceSpawns[i].tag_name);
					continue;
				}
				unitrigger_stub.model ShowPart(unitrigger_stub.craftableSpawn.a_pieceSpawns[i].tag_name);
			}
		}
	}
	else if(DELETE_TRIGGER)
	{
		trig delete();
	}
	level.a_uts_craftables[level.a_uts_craftables.size] = unitrigger_stub;
	return unitrigger_stub;
}

/*
	Name: setup_craftable_pieces
	Namespace: zm_craftables
	Checksum: 0xD6F38731
	Offset: 0x52B0
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function setup_craftable_pieces()
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.craftableStub = level.zombie_include_craftables[self.name];
	unitrigger_stub.equipname = self.name;
	unitrigger_stub.craftableSpawn = unitrigger_stub craftable_piece_unitriggers(self.name, unitrigger_stub.origin);
	level.a_uts_craftables[level.a_uts_craftables.size] = unitrigger_stub;
	return unitrigger_stub;
}

/*
	Name: craftable_has_piece
	Namespace: zm_craftables
	Checksum: 0x45D6A19F
	Offset: 0x5360
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function craftable_has_piece(piece)
{
	for(i = 0; i < self.a_pieceSpawns.size; i++)
	{
		if(self.a_pieceSpawns[i].pieceName == piece.pieceName && self.a_pieceSpawns[i].craftablename == piece.craftablename)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: get_actual_uts_craftable
	Namespace: zm_craftables
	Checksum: 0xECB2808
	Offset: 0x5400
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function get_actual_uts_craftable()
{
	if(self.craftable_name == "open_table" && self.n_open_craftable_choice != -1)
	{
		return self.stub.a_uts_open_craftables_available[self.n_open_craftable_choice];
	}
	else
	{
		return self.stub;
	}
}

/*
	Name: get_actual_craftableSpawn
	Namespace: zm_craftables
	Checksum: 0xD68BD4CF
	Offset: 0x5458
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function get_actual_craftableSpawn()
{
	if(self.craftable_name == "open_table" && self.stub.n_open_craftable_choice != -1 && isdefined(self.stub.a_uts_open_craftables_available[self.stub.n_open_craftable_choice].craftableSpawn))
	{
		return self.stub.a_uts_open_craftables_available[self.stub.n_open_craftable_choice].craftableSpawn;
	}
	else
	{
		return self;
	}
}

/*
	Name: craftable_can_use_shared_piece
	Namespace: zm_craftables
	Checksum: 0xE4BC0BF7
	Offset: 0x54F8
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function craftable_can_use_shared_piece()
{
	uts_craftable = self.stub;
	if(isdefined(uts_craftable.n_open_craftable_choice) && uts_craftable.n_open_craftable_choice != -1 && isdefined(uts_craftable.a_uts_open_craftables_available[uts_craftable.n_open_craftable_choice]))
	{
		return 1;
	}
	if(isdefined(uts_craftable.craftableStub.need_all_pieces) && uts_craftable.craftableStub.need_all_pieces)
	{
		foreach(piece in self.a_pieceSpawns)
		{
			if(!(isdefined(piece.in_shared_inventory) && piece.in_shared_inventory))
			{
				return 0;
			}
		}
		return 1;
		break;
	}
	foreach(piece in self.a_pieceSpawns)
	{
		if(!isdefined(piece.crafted) && piece.crafted && (isdefined(piece.in_shared_inventory) && piece.in_shared_inventory))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: craftable_set_piece_crafted
	Namespace: zm_craftables
	Checksum: 0xC590AAB8
	Offset: 0x5708
	Size: 0x1D5
	Parameters: 2
	Flags: None
*/
function craftable_set_piece_crafted(pieceSpawn_check, player)
{
	craftableSpawn_check = get_actual_craftableSpawn();
	foreach(pieceSpawn in craftableSpawn_check.a_pieceSpawns)
	{
		if(isdefined(pieceSpawn_check))
		{
			if(pieceSpawn.pieceName == pieceSpawn_check.pieceName && pieceSpawn.craftablename == pieceSpawn_check.craftablename)
			{
				pieceSpawn.crafted = 1;
				if(isdefined(pieceSpawn.onCrafted))
				{
					pieceSpawn thread [[pieceSpawn.onCrafted]](player);
				}
				continue;
			}
		}
		if(isdefined(pieceSpawn.is_shared) && pieceSpawn.is_shared && (isdefined(pieceSpawn.in_shared_inventory) && pieceSpawn.in_shared_inventory))
		{
			pieceSpawn.crafted = 1;
			if(isdefined(pieceSpawn.onCrafted))
			{
				pieceSpawn thread [[pieceSpawn.onCrafted]](player);
			}
			pieceSpawn.in_shared_inventory = 0;
		}
	}
}

/*
	Name: craftable_set_piece_crafting
	Namespace: zm_craftables
	Checksum: 0xE90ECE25
	Offset: 0x58E8
	Size: 0x159
	Parameters: 1
	Flags: None
*/
function craftable_set_piece_crafting(pieceSpawn_check)
{
	craftableSpawn_check = get_actual_craftableSpawn();
	foreach(pieceSpawn in craftableSpawn_check.a_pieceSpawns)
	{
		if(isdefined(pieceSpawn_check))
		{
			if(pieceSpawn.pieceName == pieceSpawn_check.pieceName && pieceSpawn.craftablename == pieceSpawn_check.craftablename)
			{
				pieceSpawn.crafting = 1;
			}
		}
		if(isdefined(pieceSpawn.is_shared) && pieceSpawn.is_shared && (isdefined(pieceSpawn.in_shared_inventory) && pieceSpawn.in_shared_inventory))
		{
			pieceSpawn.crafting = 1;
		}
	}
}

/*
	Name: craftable_clear_piece_crafting
	Namespace: zm_craftables
	Checksum: 0x9946D06
	Offset: 0x5A50
	Size: 0x119
	Parameters: 1
	Flags: None
*/
function craftable_clear_piece_crafting(pieceSpawn_check)
{
	if(isdefined(pieceSpawn_check))
	{
		pieceSpawn_check.crafting = 0;
	}
	craftableSpawn_check = get_actual_craftableSpawn();
	foreach(pieceSpawn in craftableSpawn_check.a_pieceSpawns)
	{
		if(isdefined(pieceSpawn.is_shared) && pieceSpawn.is_shared && (isdefined(pieceSpawn.in_shared_inventory) && pieceSpawn.in_shared_inventory))
		{
			pieceSpawn.crafting = 0;
		}
	}
}

/*
	Name: craftable_is_piece_crafted
	Namespace: zm_craftables
	Checksum: 0x80E9D9F7
	Offset: 0x5B78
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function craftable_is_piece_crafted(piece)
{
	for(i = 0; i < self.a_pieceSpawns.size; i++)
	{
		if(self.a_pieceSpawns[i].pieceName == piece.pieceName && self.a_pieceSpawns[i].craftablename == piece.craftablename)
		{
			return isdefined(self.a_pieceSpawns[i].crafted) && self.a_pieceSpawns[i].crafted;
		}
	}
	return 0;
}

/*
	Name: start_crafting_shared_piece
	Namespace: zm_craftables
	Checksum: 0xFC47811
	Offset: 0x5C40
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function start_crafting_shared_piece()
{
	if(!isdefined(level.shared_crafting_in_progress))
	{
		level.shared_crafting_in_progress = self;
	}
}

/*
	Name: finish_crafting_shared_piece
	Namespace: zm_craftables
	Checksum: 0xA5B0C9A1
	Offset: 0x5C68
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function finish_crafting_shared_piece()
{
	if(self === level.shared_crafting_in_progress)
	{
		level.shared_crafting_in_progress = undefined;
	}
}

/*
	Name: can_craft_shared_piece
	Namespace: zm_craftables
	Checksum: 0x99067D5A
	Offset: 0x5C90
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function can_craft_shared_piece(continuing)
{
	if(continuing)
	{
		return self === level.shared_crafting_in_progress;
	}
	return !isdefined(level.shared_crafting_in_progress);
}

/*
	Name: craftable_is_piece_crafting
	Namespace: zm_craftables
	Checksum: 0xE3639BB7
	Offset: 0x5CC8
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function craftable_is_piece_crafting(pieceSpawn_check)
{
	craftableSpawn_check = get_actual_craftableSpawn();
	foreach(pieceSpawn in craftableSpawn_check.a_pieceSpawns)
	{
		if(isdefined(pieceSpawn_check))
		{
			if(pieceSpawn.pieceName == pieceSpawn_check.pieceName && pieceSpawn.craftablename == pieceSpawn_check.craftablename)
			{
				return pieceSpawn.crafting;
			}
		}
		if(isdefined(pieceSpawn.is_shared) && pieceSpawn.is_shared && (isdefined(pieceSpawn.in_shared_inventory) && pieceSpawn.in_shared_inventory) && (isdefined(pieceSpawn.crafting) && pieceSpawn.crafting))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: craftable_is_piece_crafted_or_crafting
	Namespace: zm_craftables
	Checksum: 0xBD7B27C9
	Offset: 0x5E40
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function craftable_is_piece_crafted_or_crafting(piece)
{
	for(i = 0; i < self.a_pieceSpawns.size; i++)
	{
		if(self.a_pieceSpawns[i].pieceName == piece.pieceName && self.a_pieceSpawns[i].craftablename == piece.craftablename)
		{
			return isdefined(self.a_pieceSpawns[i].crafted) && self.a_pieceSpawns[i].crafted || (isdefined(self.a_pieceSpawns[i].crafting) && self.a_pieceSpawns[i].crafting);
		}
	}
	return 0;
}

/*
	Name: craftable_all_crafted
	Namespace: zm_craftables
	Checksum: 0x38B3DA8B
	Offset: 0x5F40
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function craftable_all_crafted()
{
	if(isdefined(self.stub.craftableStub.need_all_pieces) && self.stub.craftableStub.need_all_pieces)
	{
		foreach(piece in self.a_pieceSpawns)
		{
			if(!isdefined(piece.in_shared_inventory) && piece.in_shared_inventory && !piece.crafted)
			{
				return 0;
			}
		}
		return 1;
	}
	for(i = 0; i < self.a_pieceSpawns.size; i++)
	{
		if(!(isdefined(self.a_pieceSpawns[i].crafted) && self.a_pieceSpawns[i].crafted))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: waittill_crafted
	Namespace: zm_craftables
	Checksum: 0x4308DEC7
	Offset: 0x60A8
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function waittill_crafted(craftable_name)
{
	level waittill(craftable_name + "_crafted", player);
	return player;
}

/*
	Name: player_can_craft
	Namespace: zm_craftables
	Checksum: 0x2278B21C
	Offset: 0x60E0
	Size: 0x28F
	Parameters: 3
	Flags: None
*/
function player_can_craft(craftableSpawn, continuing, slot)
{
	if(!isdefined(craftableSpawn))
	{
		return 0;
	}
	if(!isdefined(slot))
	{
		slot = craftableSpawn.inventory_slot;
	}
	if(!craftableSpawn craftable_can_use_shared_piece())
	{
		if(!isdefined(slot))
		{
			return 0;
		}
		if(!isdefined(self.current_craftable_pieces[slot]))
		{
			return 0;
		}
		if(!craftableSpawn craftable_has_piece(self.current_craftable_pieces[slot]))
		{
			return 0;
		}
		if(isdefined(continuing) && continuing)
		{
			if(craftableSpawn craftable_is_piece_crafted(self.current_craftable_pieces[slot]))
			{
				return 0;
			}
		}
		else if(craftableSpawn craftable_is_piece_crafted_or_crafting(self.current_craftable_pieces[slot]))
		{
			return 0;
		}
	}
	else if(isdefined(craftableSpawn.stub.crafted) && craftableSpawn.stub.crafted && !continuing)
	{
		return 0;
	}
	if(craftableSpawn.stub.useTime > 0 && !self can_craft_shared_piece(continuing))
	{
		return 0;
	}
	if(isdefined(craftableSpawn.stub) && isdefined(craftableSpawn.stub.custom_craftablestub_update_prompt) && isdefined(craftableSpawn.stub.playertrigger[0]) && isdefined(craftableSpawn.stub.playertrigger[0].stub) && !craftableSpawn.stub.playertrigger[0].stub [[craftableSpawn.stub.custom_craftablestub_update_prompt]](self, 1, craftableSpawn.stub.playertrigger[self GetEntityNumber()]))
	{
		return 0;
	}
	return 1;
}

/*
	Name: craftable_transfer_data
	Namespace: zm_craftables
	Checksum: 0x32CD6E7
	Offset: 0x6378
	Size: 0x22F
	Parameters: 0
	Flags: None
*/
function craftable_transfer_data()
{
	uts_craftable = self.stub;
	if(uts_craftable.n_open_craftable_choice == -1 || !isdefined(uts_craftable.a_uts_open_craftables_available[uts_craftable.n_open_craftable_choice]))
	{
		return;
	}
	uts_source = uts_craftable.a_uts_open_craftables_available[uts_craftable.n_open_craftable_choice];
	uts_target = uts_craftable;
	uts_target.craftableStub = uts_source.craftableStub;
	uts_target.craftableSpawn = uts_source.craftableSpawn;
	uts_target.crafted = uts_source.crafted;
	uts_target.cursor_hint = uts_source.cursor_hint;
	uts_target.custom_craftable_update_prompt = uts_source.custom_craftable_update_prompt;
	uts_target.equipname = uts_source.equipname;
	uts_target.hint_string = uts_source.hint_string;
	uts_target.Persistent = uts_source.Persistent;
	uts_target.prompt_and_visibility_func = uts_source.prompt_and_visibility_func;
	uts_target.trigger_func = uts_source.trigger_func;
	uts_target.trigger_hintstring = uts_source.trigger_hintstring;
	uts_target.weaponName = uts_source.weaponName;
	uts_target.craftableSpawn.stub = uts_target;
	thread zm_unitrigger::unregister_unitrigger(uts_source);
	uts_source craftablestub_remove();
	return uts_target;
}

/*
	Name: player_craft
	Namespace: zm_craftables
	Checksum: 0xD3B3B040
	Offset: 0x65B0
	Size: 0x585
	Parameters: 2
	Flags: None
*/
function player_craft(craftableSpawn, slot)
{
	if(!isdefined(slot))
	{
		slot = craftableSpawn.inventory_slot;
	}
	if(!isdefined(self.current_craftable_pieces))
	{
		self.current_craftable_pieces = [];
	}
	if(isdefined(slot))
	{
		craftableSpawn craftable_set_piece_crafted(self.current_craftable_pieces[slot], self);
	}
	if(isdefined(slot) && isdefined(self.current_craftable_pieces[slot]) && (isdefined(self.current_craftable_pieces[slot].crafted) && self.current_craftable_pieces[slot].crafted))
	{
		player_destroy_piece(self.current_craftable_pieces[slot], slot);
	}
	if(isdefined(craftableSpawn.stub.n_open_craftable_choice))
	{
		uts_craftable = craftableSpawn craftable_transfer_data();
		craftableSpawn = uts_craftable.craftableSpawn;
		update_open_table_status();
	}
	else
	{
		uts_craftable = craftableSpawn.stub;
	}
	if(!isdefined(uts_craftable.model) && isdefined(uts_craftable.craftableStub.STR_MODEL))
	{
		craftableStub = uts_craftable.craftableStub;
		s_model = struct::get(uts_craftable.target, "targetname");
		if(isdefined(s_model))
		{
			m_spawn = spawn("script_model", s_model.origin);
			if(isdefined(craftableStub.v_origin_offset))
			{
				m_spawn.origin = m_spawn.origin + craftableStub.v_origin_offset;
			}
			m_spawn.angles = s_model.angles;
			if(isdefined(craftableStub.v_angle_offset))
			{
				m_spawn.angles = m_spawn.angles + craftableStub.v_angle_offset;
			}
			m_spawn SetModel(craftableStub.STR_MODEL);
			uts_craftable.model = m_spawn;
		}
	}
	if(isdefined(uts_craftable.model))
	{
		for(i = 0; i < craftableSpawn.a_pieceSpawns.size; i++)
		{
			if(isdefined(craftableSpawn.a_pieceSpawns[i].tag_name))
			{
				uts_craftable.model notsolid();
				if(!(isdefined(craftableSpawn.a_pieceSpawns[i].crafted) && craftableSpawn.a_pieceSpawns[i].crafted))
				{
					uts_craftable.model HidePart(craftableSpawn.a_pieceSpawns[i].tag_name);
					continue;
				}
				uts_craftable.model show();
				uts_craftable.model ShowPart(craftableSpawn.a_pieceSpawns[i].tag_name);
			}
		}
	}
	self track_craftable_pieces_crafted(craftableSpawn);
	if(craftableSpawn craftable_all_crafted())
	{
		self player_finish_craftable(craftableSpawn);
		self track_craftables_crafted(craftableSpawn);
		if(isdefined(level.craftable_crafted_custom_func))
		{
			self thread [[level.craftable_crafted_custom_func]](craftableSpawn);
		}
	}
	else
	{
		self playsound("zmb_buildable_piece_add");
		/#
			Assert(isdefined(level.zombie_craftableStubs[craftableSpawn.craftable_name].str_crafting), "Dev Block strings are not supported");
		#/
		if(isdefined(level.zombie_craftableStubs[craftableSpawn.craftable_name].str_crafting))
		{
			return level.zombie_craftableStubs[craftableSpawn.craftable_name].str_crafting;
		}
	}
	return "";
}

/*
	Name: update_open_table_status
	Namespace: zm_craftables
	Checksum: 0x8EB8702B
	Offset: 0x6B40
	Size: 0x261
	Parameters: 0
	Flags: None
*/
function update_open_table_status()
{
	b_open_craftables_remaining = 0;
	foreach(uts_craftable in level.a_uts_craftables)
	{
		if(isdefined(level.zombie_include_craftables[uts_craftable.equipname]) && (isdefined(level.zombie_include_craftables[uts_craftable.equipname].is_open_table) && level.zombie_include_craftables[uts_craftable.equipname].is_open_table))
		{
			b_piece_crafted = 0;
			foreach(pieceSpawn in uts_craftable.craftableSpawn.a_pieceSpawns)
			{
				if(isdefined(pieceSpawn.crafted) && pieceSpawn.crafted)
				{
					b_piece_crafted = 1;
					break;
				}
			}
			if(!b_piece_crafted)
			{
				b_open_craftables_remaining = 1;
			}
		}
	}
	if(!b_open_craftables_remaining)
	{
		foreach(uts_craftable in level.a_uts_craftables)
		{
			if(uts_craftable.equipname == "open_table")
			{
				thread zm_unitrigger::unregister_unitrigger(uts_craftable);
			}
		}
	}
}

/*
	Name: player_finish_craftable
	Namespace: zm_craftables
	Checksum: 0x1FC6217B
	Offset: 0x6DB0
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function player_finish_craftable(craftableSpawn)
{
	craftableSpawn.crafted = 1;
	craftableSpawn.stub.crafted = 1;
	craftableSpawn notify("crafted", self);
	level.craftables_crafted[craftableSpawn.craftable_name] = 1;
	level notify(craftableSpawn.craftable_name + "_crafted", self);
}

/*
	Name: complete_craftable
	Namespace: zm_craftables
	Checksum: 0x65302734
	Offset: 0x6E40
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function complete_craftable(str_craftable_name)
{
	foreach(uts_craftable in level.a_uts_craftables)
	{
		if(uts_craftable.craftableStub.name == str_craftable_name)
		{
			player = GetPlayers()[0];
			player player_finish_craftable(uts_craftable.craftableSpawn);
			thread zm_unitrigger::unregister_unitrigger(uts_craftable);
			if(isdefined(uts_craftable.craftableStub.onFullyCrafted))
			{
				uts_craftable [[uts_craftable.craftableStub.onFullyCrafted]]();
			}
			return;
		}
	}
}

/*
	Name: craftablestub_remove
	Namespace: zm_craftables
	Checksum: 0x3DD06D3D
	Offset: 0x6F80
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function craftablestub_remove()
{
	ArrayRemoveValue(level.a_uts_craftables, self);
}

/*
	Name: craftabletrigger_update_prompt
	Namespace: zm_craftables
	Checksum: 0x705F636E
	Offset: 0x6FA8
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function craftabletrigger_update_prompt(player)
{
	can_use = self.stub craftablestub_update_prompt(player);
	self setHintString(self.stub.hint_string);
	return can_use;
}

/*
	Name: craftablestub_update_prompt
	Namespace: zm_craftables
	Checksum: 0x328B9CB3
	Offset: 0x7010
	Size: 0x3D7
	Parameters: 3
	Flags: None
*/
function craftablestub_update_prompt(player, unitrigger, slot)
{
	if(!isdefined(slot))
	{
		slot = self.craftableStub.inventory_slot;
	}
	if(!isdefined(player.current_craftable_pieces))
	{
		player.current_craftable_pieces = [];
	}
	if(!self anystub_update_prompt(player))
	{
		return 0;
	}
	if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self.hint_string = "";
		return 0;
	}
	if(isdefined(self.is_locked) && self.is_locked)
	{
		return 1;
	}
	can_use = 1;
	if(isdefined(self.custom_craftablestub_update_prompt) && !self [[self.custom_craftablestub_update_prompt]](player))
	{
		return 0;
	}
	initial_current_weapon = player GetCurrentWeapon();
	current_weapon = zm_weapons::get_nonalternate_weapon(initial_current_weapon);
	if(current_weapon.isHeroWeapon || current_weapon.isgadget)
	{
		self.hint_string = "";
		return 0;
	}
	if(!(isdefined(self.crafted) && self.crafted))
	{
		if(!self.craftableSpawn craftable_can_use_shared_piece())
		{
			if(!isdefined(player.current_craftable_pieces[slot]))
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
				return 0;
			}
			else if(!self.craftableSpawn craftable_has_piece(player.current_craftable_pieces[slot]))
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				return 0;
			}
		}
		/#
			Assert(isdefined(level.zombie_craftableStubs[self.equipname].str_to_craft), "Dev Block strings are not supported");
		#/
		self.hint_string = level.zombie_craftableStubs[self.equipname].str_to_craft;
	}
	else if(self.Persistent == 1)
	{
		if(zm_equipment::is_limited(self.weaponName) && zm_equipment::limited_in_use(self.weaponName))
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
			return 0;
		}
		if(player zm_equipment::has_player_equipment(self.weaponName))
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
			return 0;
		}
		self.hint_string = self.trigger_hintstring;
	}
	else if(self.Persistent == 2)
	{
		if(!zm_weapons::limited_weapon_below_quota(self.weaponName, undefined))
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			return 0;
		}
		else if(isdefined(self.str_taken) && self.str_taken)
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			return 0;
		}
		self.hint_string = self.trigger_hintstring;
	}
	else
	{
		self.hint_string = "";
		return 0;
	}
	return 1;
}

/*
	Name: choose_open_craftable
	Namespace: zm_craftables
	Checksum: 0x7C266BC1
	Offset: 0x73F0
	Size: 0x3C7
	Parameters: 1
	Flags: None
*/
function choose_open_craftable(player)
{
	self endon("kill_choose_open_craftable");
	n_playernum = player GetEntityNumber();
	self.b_open_craftable_checking_input = 1;
	b_got_input = 1;
	hintTextHudElem = newClientHudElem(player);
	hintTextHudElem.alignX = "center";
	hintTextHudElem.alignY = "middle";
	hintTextHudElem.horzAlign = "center";
	hintTextHudElem.vertAlign = "middle";
	hintTextHudElem.y = 95;
	if(player IsSplitscreen())
	{
		hintTextHudElem.y = -50;
	}
	hintTextHudElem.foreground = 1;
	hintTextHudElem.font = "default";
	hintTextHudElem.fontscale = 1.1;
	hintTextHudElem.alpha = 1;
	hintTextHudElem.color = (1, 1, 1);
	hintTextHudElem setText(&"ZOMBIE_CRAFTABLE_CHANGE_BUILD");
	if(!isdefined(self.openCraftableHudElem))
	{
		self.openCraftableHudElem = [];
	}
	self.openCraftableHudElem[n_playernum] = hintTextHudElem;
	while(isdefined(self.playertrigger[n_playernum]) && !self.crafted)
	{
		if(player ActionSlotOneButtonPressed())
		{
			self.n_open_craftable_choice++;
			b_got_input = 1;
		}
		else if(player ActionSlotTwoButtonPressed())
		{
			self.n_open_craftable_choice--;
			b_got_input = 1;
		}
		if(self.n_open_craftable_choice >= self.a_uts_open_craftables_available.size)
		{
			self.n_open_craftable_choice = 0;
		}
		else if(self.n_open_craftable_choice < 0)
		{
			self.n_open_craftable_choice = self.a_uts_open_craftables_available.size - 1;
		}
		if(b_got_input)
		{
			self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
			self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
			self.playertrigger[n_playernum] setHintString(self.hint_string);
			b_got_input = 0;
			wait(0.5);
		}
		if(player util::is_player_looking_at(self.playertrigger[n_playernum].origin, 0.76))
		{
			self.openCraftableHudElem[n_playernum].alpha = 1;
		}
		else
		{
			self.openCraftableHudElem[n_playernum].alpha = 0;
		}
		wait(0.05);
	}
	self.b_open_craftable_checking_input = 0;
	self.openCraftableHudElem[n_playernum] destroy();
	self.openCraftableHudElem[n_playernum] = undefined;
}

/*
	Name: open_craftablestub_update_prompt
	Namespace: zm_craftables
	Checksum: 0xA993313A
	Offset: 0x77C0
	Size: 0x3A7
	Parameters: 2
	Flags: None
*/
function open_craftablestub_update_prompt(player, slot)
{
	if(!isdefined(slot))
	{
		slot = 0;
	}
	if(!(isdefined(self.crafted) && self.crafted))
	{
		self.a_uts_open_craftables_available = [];
		foreach(uts_craftable in level.a_uts_craftables)
		{
			if(isdefined(uts_craftable.craftableStub.is_open_table) && uts_craftable.craftableStub.is_open_table && (!isdefined(uts_craftable.crafted) && uts_craftable.crafted) && uts_craftable.craftableSpawn.craftable_name != "open_table" && uts_craftable.craftableSpawn craftable_can_use_shared_piece())
			{
				self.a_uts_open_craftables_available[self.a_uts_open_craftables_available.size] = uts_craftable;
			}
		}
		if(self.a_uts_open_craftables_available.size < 2)
		{
			self notify("kill_choose_open_craftable");
			self.b_open_craftable_checking_input = 0;
			n_entitynum = player GetEntityNumber();
			if(isdefined(self.openCraftableHudElem) && isdefined(self.openCraftableHudElem[n_entitynum]))
			{
				self.openCraftableHudElem[n_entitynum] destroy();
				self.openCraftableHudElem[n_entitynum] = undefined;
			}
		}
		switch(self.a_uts_open_craftables_available.size)
		{
			case 0:
			{
				if(!isdefined(player.current_craftable_pieces[slot]))
				{
					self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
					self.n_open_craftable_choice = -1;
					return 0;
				}
				break;
			}
			case 1:
			{
				self.n_open_craftable_choice = 0;
				self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
				return 1;
			}
			case default:
			{
				if(!self.b_open_craftable_checking_input)
				{
					thread choose_open_craftable(player);
				}
				return 1;
			}
		}
	}
	else if(self.Persistent == 2)
	{
		if(!zm_weapons::limited_weapon_below_quota(self.weaponName, undefined))
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			return 0;
		}
		else if(isdefined(self.bought) && self.bought)
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			return 0;
		}
		else if(isdefined(self.str_taken) && self.str_taken)
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			return 0;
		}
		self.hint_string = self.trigger_hintstring;
		return 1;
	}
	else if(self.Persistent == 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: player_continue_crafting
	Namespace: zm_craftables
	Checksum: 0xCD0EBCE4
	Offset: 0x7B70
	Size: 0x28F
	Parameters: 2
	Flags: None
*/
function player_continue_crafting(craftableSpawn, slot)
{
	if(self laststand::player_is_in_laststand() || self zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(!self player_can_craft(craftableSpawn, 1))
	{
		return 0;
	}
	if(isdefined(self.screecher))
	{
		return 0;
	}
	if(!self useButtonPressed())
	{
		return 0;
	}
	if(craftableSpawn.stub.useTime > 0 && isdefined(slot) && !craftableSpawn craftable_is_piece_crafting(self.current_craftable_pieces[slot]))
	{
		return 0;
	}
	trigger = craftableSpawn.stub zm_unitrigger::unitrigger_trigger(self);
	if(craftableSpawn.stub.script_unitrigger_type == "unitrigger_radius_use")
	{
		torigin = craftableSpawn.stub zm_unitrigger::unitrigger_origin();
		porigin = self GetEye();
		radius_sq = 2.25 * craftableSpawn.stub.radius * craftableSpawn.stub.radius;
		if(Distance2DSquared(torigin, porigin) > radius_sq)
		{
			return 0;
		}
	}
	else if(!isdefined(trigger) || !trigger istouching(self))
	{
		return 0;
	}
	if(isdefined(craftableSpawn.stub.require_look_at) && craftableSpawn.stub.require_look_at && !self util::is_player_looking_at(trigger.origin, 0.76))
	{
		return 0;
	}
	return 1;
}

/*
	Name: player_progress_bar_update
	Namespace: zm_craftables
	Checksum: 0xBC6D386A
	Offset: 0x7E08
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function player_progress_bar_update(start_time, craft_time)
{
	self endon("entering_last_stand");
	self endon("death");
	self endon("disconnect");
	self endon("craftable_progress_end");
	while(isdefined(self) && GetTime() - start_time < craft_time)
	{
		progress = GetTime() - start_time / craft_time;
		if(progress < 0)
		{
			progress = 0;
		}
		if(progress > 1)
		{
			progress = 1;
		}
		self.useBar hud::updateBar(progress);
		wait(0.05);
	}
}

/*
	Name: player_progress_bar
	Namespace: zm_craftables
	Checksum: 0x22AB11F8
	Offset: 0x7EE0
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function player_progress_bar(start_time, craft_time)
{
	self.useBar = self hud::createPrimaryProgressBar();
	self.useBarText = self hud::createPrimaryProgressBarText();
	self.useBarText setText(&"ZOMBIE_BUILDING");
	if(isdefined(self) && isdefined(start_time) && isdefined(craft_time))
	{
		self player_progress_bar_update(start_time, craft_time);
	}
	self.useBarText hud::destroyElem();
	self.useBar hud::destroyElem();
}

/*
	Name: craftable_use_hold_think_internal
	Namespace: zm_craftables
	Checksum: 0xA74417EE
	Offset: 0x7FC8
	Size: 0x4D1
	Parameters: 2
	Flags: None
*/
function craftable_use_hold_think_internal(player, slot)
{
	if(!isdefined(slot))
	{
		slot = self.stub.craftableSpawn.inventory_slot;
	}
	wait(0.01);
	if(!isdefined(self))
	{
		if(isdefined(player.craftableAudio))
		{
			player.craftableAudio delete();
			player.craftableAudio = undefined;
		}
		return;
	}
	if(self.stub.craftableSpawn craftable_can_use_shared_piece())
	{
		slot = undefined;
	}
	if(!isdefined(self.useTime))
	{
		self.useTime = Int(3000);
	}
	self.craft_time = self.useTime;
	self.craft_start_time = GetTime();
	craft_time = self.craft_time;
	craft_start_time = self.craft_start_time;
	if(craft_time > 0)
	{
		player zm_utility::disable_player_move_states(1);
		player zm_utility::increment_is_drinking();
		orgweapon = player GetCurrentWeapon();
		build_weapon = GetWeapon("zombie_builder");
		player GiveWeapon(build_weapon);
		player SwitchToWeapon(build_weapon);
		if(isdefined(slot))
		{
			self.stub.craftableSpawn craftable_set_piece_crafting(player.current_craftable_pieces[slot]);
		}
		else
		{
			player start_crafting_shared_piece();
		}
		player thread player_progress_bar(craft_start_time, craft_time);
		if(isdefined(level.craftable_craft_custom_func))
		{
			player thread [[level.craftable_craft_custom_func]](self.stub);
		}
		while(isdefined(self) && player player_continue_crafting(self.stub.craftableSpawn, slot) && GetTime() - self.craft_start_time < self.craft_time)
		{
			wait(0.05);
		}
		player notify("craftable_progress_end");
		player zm_weapons::switch_back_primary_weapon(orgweapon);
		player TakeWeapon(build_weapon);
		if(isdefined(player.IS_DRINKING) && player.IS_DRINKING)
		{
			player zm_utility::decrement_is_drinking();
		}
		player zm_utility::enable_player_move_states();
	}
	if(isdefined(self) && player player_continue_crafting(self.stub.craftableSpawn, slot) && (self.craft_time <= 0 || GetTime() - self.craft_start_time >= self.craft_time))
	{
		if(isdefined(slot))
		{
			self.stub.craftableSpawn craftable_clear_piece_crafting(player.current_craftable_pieces[slot]);
		}
		else
		{
			player finish_crafting_shared_piece();
		}
		self notify("craft_succeed");
	}
	else if(isdefined(player.craftableAudio))
	{
		player.craftableAudio delete();
		player.craftableAudio = undefined;
	}
	if(isdefined(slot))
	{
		self.stub.craftableSpawn craftable_clear_piece_crafting(player.current_craftable_pieces[slot]);
	}
	else
	{
		player finish_crafting_shared_piece();
	}
	self notify("craft_failed");
}

/*
	Name: craftable_play_craft_fx
	Namespace: zm_craftables
	Checksum: 0xA3E970FB
	Offset: 0x84A8
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function craftable_play_craft_fx(player)
{
	self endon("kill_trigger");
	self endon("craft_succeed");
	self endon("craft_failed");
	while(1)
	{
		playFX(level._effect["building_dust"], player GetPlayerCameraPos(), player.angles);
		wait(0.5);
	}
}

/*
	Name: craftable_use_hold_think
	Namespace: zm_craftables
	Checksum: 0xF875BDFB
	Offset: 0x8538
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function craftable_use_hold_think(player)
{
	self thread craftable_play_craft_fx(player);
	self thread craftable_use_hold_think_internal(player);
	retval = self util::waittill_any_return("craft_succeed", "craft_failed");
	if(retval == "craft_succeed")
	{
		return 1;
	}
	return 0;
}

/*
	Name: craftable_place_think
	Namespace: zm_craftables
	Checksum: 0x974E3AE3
	Offset: 0x85C8
	Size: 0xEA7
	Parameters: 0
	Flags: None
*/
function craftable_place_think()
{
	self notify("craftable_place_think");
	self endon("craftable_place_think");
	self endon("kill_trigger");
	player_crafted = undefined;
	while(!(isdefined(self.stub.crafted) && self.stub.crafted))
	{
		self waittill("trigger", player);
		if(isdefined(level.custom_craftable_validation))
		{
			valid = self [[level.custom_craftable_validation]](player);
			if(!valid)
			{
				continue;
			}
		}
		if(player != self.parent_player)
		{
			continue;
		}
		if(isdefined(player.screecher_weapon))
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			player thread zm_utility::ignore_triggers(0.5);
			continue;
		}
		status = player player_can_craft(self.stub.craftableSpawn, 0);
		if(!status)
		{
			self.stub.hint_string = "";
			self setHintString(self.stub.hint_string);
			if(isdefined(self.stub.onCantUse))
			{
				self.stub [[self.stub.onCantUse]](player);
			}
		}
		else if(isdefined(self.stub.onBeginUse))
		{
			self.stub [[self.stub.onBeginUse]](player);
		}
		result = self craftable_use_hold_think(player);
		team = player.pers["team"];
		if(isdefined(self.stub.onEndUse))
		{
			self.stub [[self.stub.onEndUse]](team, player, result);
		}
		if(!result)
		{
			continue;
		}
		if(isdefined(self.stub.onUse))
		{
			self.stub [[self.stub.onUse]](player);
		}
		prompt = player player_craft(self.stub.craftableSpawn);
		player_crafted = player;
		self.stub.hint_string = prompt;
		self setHintString(self.stub.hint_string);
	}
	if(isdefined(self.stub.craftableStub.onFullyCrafted))
	{
		b_result = self.stub [[self.stub.craftableStub.onFullyCrafted]]();
		if(!b_result)
		{
			return;
		}
	}
	if(isdefined(player_crafted))
	{
		player_crafted playsound("zmb_craftable_complete");
	}
	if(self.stub.Persistent == 0)
	{
		self.stub craftablestub_remove();
		thread zm_unitrigger::unregister_unitrigger(self.stub);
		return;
	}
	if(self.stub.Persistent == 3)
	{
		stub_uncraft_craftable(self.stub, 1);
		return;
	}
	if(self.stub.Persistent == 2)
	{
		if(isdefined(player_crafted))
		{
			self craftabletrigger_update_prompt(player_crafted);
		}
		if(!zm_weapons::limited_weapon_below_quota(self.stub.weaponName, undefined))
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self setHintString(self.stub.hint_string);
			return;
		}
		if(isdefined(self.stub.str_taken) && self.stub.str_taken)
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			self setHintString(self.stub.hint_string);
			return;
		}
		if(isdefined(self.stub.model))
		{
			self.stub.model notsolid();
			self.stub.model show();
		}
		while(self.stub.Persistent == 2)
		{
			self waittill("trigger", player);
			if(isdefined(self.stub.bought) && self.stub.bought == 1)
			{
				continue;
			}
			if(isdefined(player.screecher_weapon))
			{
				continue;
			}
			current_weapon = player GetCurrentWeapon();
			if(zm_utility::is_placeable_mine(current_weapon) || zm_equipment::is_equipment_that_blocks_purchase(current_weapon))
			{
				continue;
			}
			if(current_weapon.isHeroWeapon || current_weapon.isgadget)
			{
				continue;
			}
			if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
			{
				continue;
			}
			if(isdefined(level.custom_craftable_validation))
			{
				valid = self [[level.custom_craftable_validation]](player);
				if(!valid)
				{
					continue;
				}
			}
			if(!(isdefined(self.stub.crafted) && self.stub.crafted))
			{
				self.stub.hint_string = "";
				self setHintString(self.stub.hint_string);
				return;
			}
			if(player != self.parent_player)
			{
				continue;
			}
			if(!zm_utility::is_player_valid(player))
			{
				player thread zm_utility::ignore_triggers(0.5);
				continue;
			}
			self.stub.bought = 1;
			if(isdefined(self.stub.model))
			{
				self.stub.model thread model_fly_away(self);
			}
			if(zm_weapons::limited_weapon_below_quota(self.stub.weaponName, undefined))
			{
				player zm_weapons::weapon_give(self.stub.weaponName);
				if(isdefined(level.zombie_include_craftables[self.stub.equipname].onBuyWeapon))
				{
					self [[level.zombie_include_craftables[self.stub.equipname].onBuyWeapon]](player);
				}
			}
			if(!zm_weapons::limited_weapon_below_quota(self.stub.weaponName, undefined))
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			}
			else
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			}
			self setHintString(self.stub.hint_string);
			player track_craftables_pickedup(self.stub.craftableSpawn);
		}
		break;
	}
	if(!isdefined(player_crafted) || self craftabletrigger_update_prompt(player_crafted))
	{
		visible = 1;
		Hide = get_hide_model_if_unavailable(self.stub.equipname);
		if(Hide && isdefined(level.custom_craftable_validation))
		{
			visible = self [[level.custom_craftable_validation]](player);
		}
		if(visible && isdefined(self.stub.model))
		{
			self.stub.model notsolid();
			self.stub.model show();
		}
		while(self.stub.Persistent == 1)
		{
			self waittill("trigger", player);
			if(isdefined(player.screecher_weapon))
			{
				continue;
			}
			if(isdefined(level.custom_craftable_validation))
			{
				valid = self [[level.custom_craftable_validation]](player);
				if(!valid)
				{
					continue;
				}
			}
			if(!(isdefined(self.stub.crafted) && self.stub.crafted))
			{
				self.stub.hint_string = "";
				self setHintString(self.stub.hint_string);
				return;
			}
			if(player != self.parent_player)
			{
				continue;
			}
			if(!zm_utility::is_player_valid(player))
			{
				player thread zm_utility::ignore_triggers(0.5);
				continue;
			}
			if(player zm_equipment::has_player_equipment(self.stub.weaponName))
			{
				continue;
			}
			if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
			{
				continue;
			}
			if(isdefined(level.zombie_craftable_persistent_weapon))
			{
				if(self [[level.zombie_craftable_persistent_weapon]](player))
				{
					continue;
				}
			}
			if(isdefined(level.zombie_custom_equipment_setup))
			{
				if(self [[level.zombie_custom_equipment_setup]](player))
				{
					continue;
				}
			}
			if(!zm_equipment::is_limited(self.stub.weaponName) || !zm_equipment::limited_in_use(self.stub.weaponName))
			{
				player zm_equipment::buy(self.stub.weaponName);
				player GiveWeapon(self.stub.weaponName);
				player zm_equipment::start_ammo(self.stub.weaponName);
				player notify(self.stub.weaponName.name + "_pickup_from_table");
				if(isdefined(level.zombie_include_craftables[self.stub.equipname].onBuyWeapon))
				{
					self [[level.zombie_include_craftables[self.stub.equipname].onBuyWeapon]](player);
				}
				else if(self.stub.weaponName != "keys_zm")
				{
					player SetActionSlot(1, "weapon", self.stub.weaponName);
				}
				if(isdefined(level.zombie_craftableStubs[self.stub.equipname].str_taken))
				{
					self.stub.hint_string = level.zombie_craftableStubs[self.stub.equipname].str_taken;
				}
				else
				{
					self.stub.hint_string = "";
				}
				self setHintString(self.stub.hint_string);
				player track_craftables_pickedup(self.stub.craftableSpawn);
			}
			else
			{
				self.stub.hint_string = "";
				self setHintString(self.stub.hint_string);
			}
		}
	}
}

/*
	Name: model_fly_away
	Namespace: zm_craftables
	Checksum: 0x516F77C0
	Offset: 0x9478
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function model_fly_away(unitrigger)
{
	self moveto(self.origin + VectorScale((0, 0, 1), 40), 3);
	direction = self.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	self vibrate(direction, 10, 0.5, 4);
	self waittill("movedone");
	self ghost();
	playFX(level._effect["poltergeist"], self.origin);
}

/*
	Name: find_craftable_stub
	Namespace: zm_craftables
	Checksum: 0xF3555EF9
	Offset: 0x95F8
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function find_craftable_stub(equipname)
{
	foreach(stub in level.a_uts_craftables)
	{
		if(stub.equipname == equipname)
		{
			return stub;
		}
	}
	return undefined;
}

/*
	Name: uncraft_craftable
	Namespace: zm_craftables
	Checksum: 0x3E88A6C0
	Offset: 0x96A0
	Size: 0x6B
	Parameters: 4
	Flags: None
*/
function uncraft_craftable(equipname, return_pieces, origin, angles)
{
	stub = find_craftable_stub(equipname);
	stub_uncraft_craftable(stub, return_pieces, origin, angles);
}

/*
	Name: stub_uncraft_craftable
	Namespace: zm_craftables
	Checksum: 0xEBC374E4
	Offset: 0x9718
	Size: 0x2D3
	Parameters: 5
	Flags: None
*/
function stub_uncraft_craftable(stub, return_pieces, origin, angles, use_random_start)
{
	if(isdefined(stub))
	{
		craftable = stub.craftableSpawn;
		craftable.crafted = 0;
		craftable.stub.crafted = 0;
		craftable notify("uncrafted");
		level.craftables_crafted[craftable.craftable_name] = 0;
		level notify(craftable.craftable_name + "_uncrafted");
		for(i = 0; i < craftable.a_pieceSpawns.size; i++)
		{
			craftable.a_pieceSpawns[i].crafted = 0;
			if(isdefined(craftable.a_pieceSpawns[i].tag_name))
			{
				craftable.stub.model notsolid();
				if(!(isdefined(craftable.a_pieceSpawns[i].crafted) && craftable.a_pieceSpawns[i].crafted))
				{
					craftable.stub.model HidePart(craftable.a_pieceSpawns[i].tag_name);
				}
				else
				{
					craftable.stub.model show();
					craftable.stub.model ShowPart(craftable.a_pieceSpawns[i].tag_name);
				}
			}
			if(isdefined(return_pieces) && return_pieces)
			{
				craftable.a_pieceSpawns[i] piece_spawn_at(origin, angles, use_random_start);
			}
		}
		if(isdefined(craftable.stub.model))
		{
			craftable.stub.model ghost();
		}
	}
}

/*
	Name: player_explode_craftable
	Namespace: zm_craftables
	Checksum: 0x847C7F83
	Offset: 0x99F8
	Size: 0x383
	Parameters: 5
	Flags: None
*/
function player_explode_craftable(equipname, origin, speed, return_to_spawn, return_time)
{
	self ExplosionDamage(50, origin);
	stub = find_craftable_stub(equipname);
	if(isdefined(stub))
	{
		craftable = stub.craftableSpawn;
		craftable.crafted = 0;
		craftable.stub.crafted = 0;
		craftable notify("uncrafted");
		level.craftables_crafted[craftable.craftable_name] = 0;
		level notify(craftable.craftable_name + "_uncrafted");
		for(i = 0; i < craftable.a_pieceSpawns.size; i++)
		{
			craftable.a_pieceSpawns[i].crafted = 0;
			if(isdefined(craftable.a_pieceSpawns[i].tag_name))
			{
				craftable.stub.model notsolid();
				if(!(isdefined(craftable.a_pieceSpawns[i].crafted) && craftable.a_pieceSpawns[i].crafted))
				{
					craftable.stub.model HidePart(craftable.a_pieceSpawns[i].tag_name);
				}
				else
				{
					craftable.stub.model show();
					craftable.stub.model ShowPart(craftable.a_pieceSpawns[i].tag_name);
				}
			}
			ang = RandomFloat(360);
			h = 0.25 + RandomFloat(0.5);
			dir = (sin(ang), cos(ang), h);
			self thread player_throw_piece(craftable.a_pieceSpawns[i], origin, speed * dir, return_to_spawn, return_time);
		}
		craftable.stub.model ghost();
	}
}

/*
	Name: think_craftables
	Namespace: zm_craftables
	Checksum: 0x3617A9FE
	Offset: 0x9D88
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function think_craftables()
{
	foreach(craftable in level.zombie_include_craftables)
	{
		if(isdefined(craftable.triggerThink))
		{
			craftable [[craftable.triggerThink]]();
		}
	}
}

/*
	Name: openTableCraftable
	Namespace: zm_craftables
	Checksum: 0xC6B1DC27
	Offset: 0x9E30
	Size: 0x101
	Parameters: 0
	Flags: None
*/
function openTableCraftable()
{
	a_trigs = GetEntArray("open_craftable_trigger", "targetname");
	foreach(trig in a_trigs)
	{
		unitrigger_stub = setup_unitrigger_craftable_internal(trig, "open_table", "", "OPEN_CRAFTABLE", 1, 0);
		unitrigger_stub.require_look_at = 0;
		unitrigger_stub.require_look_toward = 1;
	}
}

/*
	Name: craftable_trigger_think
	Namespace: zm_craftables
	Checksum: 0xC17A637C
	Offset: 0x9F40
	Size: 0x59
	Parameters: 6
	Flags: None
*/
function craftable_trigger_think(trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	return setup_unitrigger_craftable(trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent);
}

/*
	Name: craftable_trigger_think_array
	Namespace: zm_craftables
	Checksum: 0xE47D182F
	Offset: 0x9FA8
	Size: 0x59
	Parameters: 6
	Flags: None
*/
function craftable_trigger_think_array(trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	return setup_unitrigger_craftable_array(trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent);
}

/*
	Name: setup_vehicle_unitrigger_craftable
	Namespace: zm_craftables
	Checksum: 0x3333C6BB
	Offset: 0xA010
	Size: 0x5AD
	Parameters: 7
	Flags: None
*/
function setup_vehicle_unitrigger_craftable(parent, trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	trig = GetEnt(trigger_targetname, "targetname");
	if(!isdefined(trig))
	{
		return;
	}
	unitrigger_stub = spawnstruct();
	unitrigger_stub.craftableStub = level.zombie_include_craftables[equipname];
	unitrigger_stub.link_parent = parent;
	unitrigger_stub.origin_parent = trig;
	unitrigger_stub.trigger_targetname = trigger_targetname;
	unitrigger_stub.originFunc = &anystub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;
	unitrigger_stub.origin = trig.origin;
	unitrigger_stub.angles = trig.angles;
	unitrigger_stub.equipname = equipname;
	unitrigger_stub.weaponName = weaponName;
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.DELETE_TRIGGER = DELETE_TRIGGER;
	unitrigger_stub.crafted = 0;
	unitrigger_stub.Persistent = Persistent;
	unitrigger_stub.useTime = Int(3000);
	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;
	tmins = trig GetMins();
	tmaxs = trig GetMaxs();
	tsize = tmaxs - tmins;
	if(isdefined(trig.script_length))
	{
		unitrigger_stub.script_length = trig.script_length;
	}
	else
	{
		unitrigger_stub.script_length = tsize[1];
	}
	if(isdefined(trig.script_width))
	{
		unitrigger_stub.script_width = trig.script_width;
	}
	else
	{
		unitrigger_stub.script_width = tsize[0];
	}
	if(isdefined(trig.script_height))
	{
		unitrigger_stub.script_height = trig.script_height;
	}
	else
	{
		unitrigger_stub.script_height = tsize[2];
	}
	if(isdefined(trig.radius))
	{
		unitrigger_stub.radius = trig.radius;
	}
	else
	{
		unitrigger_stub.radius = 64;
	}
	unitrigger_stub.target = trig.target;
	unitrigger_stub.targetname = trig.targetname + "_trigger";
	unitrigger_stub.script_noteworthy = trig.script_noteworthy;
	unitrigger_stub.script_parameters = trig.script_parameters;
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	if(isdefined(level.zombie_craftableStubs[equipname].str_to_craft))
	{
		unitrigger_stub.hint_string = level.zombie_craftableStubs[equipname].str_to_craft;
	}
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.require_look_at = 1;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &craftabletrigger_update_prompt;
	zm_unitrigger::register_unitrigger(unitrigger_stub, &craftable_place_think);
	unitrigger_stub.piece_trigger = trig;
	trig.trigger_stub = unitrigger_stub;
	unitrigger_stub.craftableSpawn = unitrigger_stub craftable_piece_unitriggers(equipname, unitrigger_stub.origin);
	if(DELETE_TRIGGER)
	{
		trig delete();
	}
	level.a_uts_craftables[level.a_uts_craftables.size] = unitrigger_stub;
	return unitrigger_stub;
}

/*
	Name: vehicle_craftable_trigger_think
	Namespace: zm_craftables
	Checksum: 0x66270AF2
	Offset: 0xA5C8
	Size: 0x69
	Parameters: 7
	Flags: None
*/
function vehicle_craftable_trigger_think(vehicle, trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent)
{
	return setup_vehicle_unitrigger_craftable(vehicle, trigger_targetname, equipname, weaponName, trigger_hintstring, DELETE_TRIGGER, Persistent);
}

/*
	Name: onPickupUTS
	Namespace: zm_craftables
	Checksum: 0x735D70AB
	Offset: 0xA640
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function onPickupUTS(player)
{
	/#
		if(isdefined(player) && isdefined(player.name))
		{
			println("Dev Block strings are not supported" + player.name);
		}
	#/
}

/*
	Name: onDropUTS
	Namespace: zm_craftables
	Checksum: 0x585285AD
	Offset: 0xA6A0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function onDropUTS(player)
{
	/#
		if(isdefined(player) && isdefined(player.name))
		{
			println("Dev Block strings are not supported" + player.name);
		}
	#/
	player notify("event_ended");
}

/*
	Name: onBeginUseUTS
	Namespace: zm_craftables
	Checksum: 0x852101E4
	Offset: 0xA710
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function onBeginUseUTS(player)
{
	/#
		if(isdefined(player) && isdefined(player.name))
		{
			println("Dev Block strings are not supported" + player.name);
		}
	#/
	if(isdefined(self.craftableStub.onBeginUse))
	{
		self [[self.craftableStub.onBeginUse]](player);
	}
	if(isdefined(player) && !isdefined(player.craftableAudio))
	{
		player.craftableAudio = spawn("script_origin", player.origin);
		player.craftableAudio PlayLoopSound("zmb_craftable_loop");
	}
}

/*
	Name: onEndUseUTS
	Namespace: zm_craftables
	Checksum: 0xAE84FC62
	Offset: 0xA818
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function onEndUseUTS(team, player, result)
{
	/#
		if(isdefined(player) && isdefined(player.name))
		{
			println("Dev Block strings are not supported" + player.name);
		}
	#/
	if(!isdefined(player))
	{
		return;
	}
	if(isdefined(player.craftableAudio))
	{
		player.craftableAudio delete();
		player.craftableAudio = undefined;
	}
	if(isdefined(self.craftableStub.onEndUse))
	{
		self [[self.craftableStub.onEndUse]](team, player, result);
	}
	player notify("event_ended");
}

/*
	Name: onCantUseUTS
	Namespace: zm_craftables
	Checksum: 0x742EE2E0
	Offset: 0xA920
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function onCantUseUTS(player)
{
	/#
		if(isdefined(player) && isdefined(player.name))
		{
			println("Dev Block strings are not supported" + player.name);
		}
	#/
	if(isdefined(self.craftableStub.onCantUse))
	{
		self [[self.craftableStub.onCantUse]](player);
	}
}

/*
	Name: onUsePlantObjectUTS
	Namespace: zm_craftables
	Checksum: 0xB2BEFB09
	Offset: 0xA9B0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function onUsePlantObjectUTS(player)
{
	/#
		if(isdefined(player) && isdefined(player.name))
		{
			println("Dev Block strings are not supported" + player.name);
		}
	#/
	if(isdefined(self.craftableStub.onUsePlantObject))
	{
		self [[self.craftableStub.onUsePlantObject]](player);
	}
	player notify("bomb_planted");
}

/*
	Name: is_craftable
	Namespace: zm_craftables
	Checksum: 0xA01AF2FF
	Offset: 0xAA50
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function is_craftable()
{
	if(!isdefined(level.zombie_craftableStubs))
	{
		return 0;
	}
	if(isdefined(self.zombie_weapon_upgrade) && isdefined(level.zombie_craftableStubs[self.zombie_weapon_upgrade]))
	{
		return 1;
	}
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "specialty_weapupgrade")
	{
		if(isdefined(level.craftables_crafted["pap"]) && level.craftables_crafted["pap"])
		{
			return 0;
		}
		return 1;
	}
	return 0;
}

/*
	Name: craftable_crafted
	Namespace: zm_craftables
	Checksum: 0x943DD9F2
	Offset: 0xAAF0
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function craftable_crafted()
{
	self.a_pieceSpawns--;
}

/*
	Name: craftable_complete
	Namespace: zm_craftables
	Checksum: 0x8F0FB65E
	Offset: 0xAB08
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function craftable_complete()
{
	if(self.a_pieceSpawns <= 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_craftable_hint
	Namespace: zm_craftables
	Checksum: 0x3028736C
	Offset: 0xAB30
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function get_craftable_hint(craftable_name)
{
	/#
		Assert(isdefined(level.zombie_craftableStubs[craftable_name]), craftable_name + "Dev Block strings are not supported");
	#/
	return level.zombie_craftableStubs[craftable_name].str_to_craft;
}

/*
	Name: delete_on_disconnect
	Namespace: zm_craftables
	Checksum: 0x3C39DE07
	Offset: 0xAB90
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function delete_on_disconnect(craftable, self_notify, skip_delete)
{
	craftable endon("death");
	self waittill("disconnect");
	if(isdefined(self_notify))
	{
		self notify(self_notify);
	}
	if(!(isdefined(skip_delete) && skip_delete))
	{
		if(isdefined(craftable.stub))
		{
			thread zm_unitrigger::unregister_unitrigger(craftable.stub);
			craftable.stub = undefined;
		}
		if(isdefined(craftable))
		{
			craftable delete();
		}
	}
}

/*
	Name: is_holding_part
	Namespace: zm_craftables
	Checksum: 0x81DABABE
	Offset: 0xAC58
	Size: 0x1F5
	Parameters: 3
	Flags: None
*/
function is_holding_part(craftable_name, piece_name, slot)
{
	if(!isdefined(slot))
	{
		slot = 0;
	}
	if(isdefined(self.current_craftable_pieces) && isdefined(self.current_craftable_pieces[slot]))
	{
		if(self.current_craftable_pieces[slot].craftablename == craftable_name && self.current_craftable_pieces[slot].modelName == piece_name)
		{
			return 1;
		}
	}
	if(isdefined(level.a_uts_craftables))
	{
		foreach(craftable_stub in level.a_uts_craftables)
		{
			if(craftable_stub.craftableStub.name == craftable_name)
			{
				foreach(piece in craftable_stub.craftableSpawn.a_pieceSpawns)
				{
					if(piece.pieceName == piece_name)
					{
						if(isdefined(piece.in_shared_inventory) && piece.in_shared_inventory)
						{
							return 1;
						}
					}
				}
			}
		}
	}
	return 0;
}

/*
	Name: is_part_crafted
	Namespace: zm_craftables
	Checksum: 0xD928CDE1
	Offset: 0xAE58
	Size: 0x19D
	Parameters: 2
	Flags: None
*/
function is_part_crafted(craftable_name, piece_name)
{
	if(isdefined(level.a_uts_craftables))
	{
		foreach(craftable_stub in level.a_uts_craftables)
		{
			if(craftable_stub.craftableStub.name == craftable_name)
			{
				if(isdefined(craftable_stub.crafted) && craftable_stub.crafted)
				{
					return 1;
				}
				foreach(piece in craftable_stub.craftableSpawn.a_pieceSpawns)
				{
					if(piece.pieceName == piece_name)
					{
						if(isdefined(piece.crafted) && piece.crafted)
						{
							return 1;
						}
					}
				}
			}
		}
	}
	return 0;
}

/*
	Name: track_craftable_piece_pickedup
	Namespace: zm_craftables
	Checksum: 0x99087D1E
	Offset: 0xB000
	Size: 0x22B
	Parameters: 1
	Flags: None
*/
function track_craftable_piece_pickedup(piece)
{
	if(!isdefined(piece) || !isdefined(piece.craftablename))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	self add_map_craftable_stat(piece.craftablename, "pieces_pickedup", 1);
	if(isdefined(piece.pieceStub) && isdefined(piece.pieceStub.hash_id))
	{
		self RecordMapEvent(13, GetTime(), self.origin, level.round_number, piece.pieceStub.hash_id);
	}
	if(isdefined(piece.pieceStub.vox_id))
	{
		if(isdefined(piece.pieceStub.b_one_time_vo) && piece.pieceStub.b_one_time_vo)
		{
			if(!isdefined(self.a_one_time_piece_pickup_vo))
			{
				self.a_one_time_piece_pickup_vo = [];
			}
			if(isdefined(self.dontspeak) && self.dontspeak)
			{
				return;
			}
			if(IsInArray(self.a_one_time_piece_pickup_vo, piece.pieceStub.vox_id))
			{
				return;
			}
			self.a_one_time_piece_pickup_vo[self.a_one_time_piece_pickup_vo.size] = piece.pieceStub.vox_id;
		}
		self thread zm_utility::do_player_general_vox("general", piece.pieceStub.vox_id + "_pickup");
	}
	else
	{
		self thread zm_utility::do_player_general_vox("general", "build_pickup");
	}
}

/*
	Name: track_craftable_pieces_crafted
	Namespace: zm_craftables
	Checksum: 0x42FB257D
	Offset: 0xB238
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function track_craftable_pieces_crafted(craftable)
{
	if(!isdefined(craftable) || !isdefined(craftable.craftable_name))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	bname = craftable.craftable_name;
	if(isdefined(craftable.stat_name))
	{
		bname = craftable.stat_name;
	}
	self add_map_craftable_stat(bname, "pieces_built", 1);
	if(!craftable craftable_all_crafted())
	{
		self thread zm_utility::do_player_general_vox("general", "build_add");
	}
	level notify(bname + "_crafted", self);
}

/*
	Name: track_craftables_crafted
	Namespace: zm_craftables
	Checksum: 0xDDD1C39C
	Offset: 0xB348
	Size: 0x283
	Parameters: 1
	Flags: None
*/
function track_craftables_crafted(craftable)
{
	if(!isdefined(craftable) || !isdefined(craftable.craftable_name))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	bname = craftable.craftable_name;
	if(isdefined(craftable.stat_name))
	{
		bname = craftable.stat_name;
	}
	self add_map_craftable_stat(bname, "buildable_built", 1);
	self zm_stats::increment_client_stat("buildables_built", 0);
	self zm_stats::increment_player_stat("buildables_built");
	if(isdefined(craftable.stub) && isdefined(craftable.stub.craftableStub) && isdefined(craftable.stub.craftableStub.hash_id))
	{
		self RecordMapEvent(14, GetTime(), self.origin, level.round_number, craftable.stub.craftableStub.hash_id);
	}
	if(!isdefined(craftable.stub.craftableStub.no_challenge_stat) || craftable.stub.craftableStub.no_challenge_stat == 0)
	{
		self zm_stats::increment_challenge_stat("SURVIVALIST_CRAFTABLE");
	}
	if(isdefined(craftable.stub.craftableStub.vox_id))
	{
		if(isdefined(level.zombie_custom_craftable_built_vo))
		{
			self thread [[level.zombie_custom_craftable_built_vo]](craftable.stub);
		}
		self thread zm_utility::do_player_general_vox("general", craftable.stub.craftableStub.vox_id + "_final");
	}
}

/*
	Name: track_craftables_pickedup
	Namespace: zm_craftables
	Checksum: 0x7721C666
	Offset: 0xB5D8
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function track_craftables_pickedup(craftable)
{
	if(!isdefined(craftable))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	stat_name = get_craftable_stat_name(craftable.craftable_name);
	if(isdefined(craftable.stub) && isdefined(craftable.stub.craftableStub) && isdefined(craftable.stub.craftableStub.hash_id))
	{
		self RecordMapEvent(16, GetTime(), self.origin, level.round_number, craftable.stub.craftableStub.hash_id);
	}
	if(!isdefined(stat_name))
	{
		/#
			println("Dev Block strings are not supported" + craftable.craftable_name + "Dev Block strings are not supported");
		#/
		return;
	}
	self add_map_craftable_stat(stat_name, "buildable_pickedup", 1);
	if(isdefined(craftable.stub.craftableStub.vox_id))
	{
		self thread zm_utility::do_player_general_vox("general", craftable.stub.craftableStub.vox_id + "_plc");
	}
	self say_pickup_craftable_vo(craftable, 0);
}

/*
	Name: track_craftables_planted
	Namespace: zm_craftables
	Checksum: 0xF9D9EAB7
	Offset: 0xB7C8
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function track_craftables_planted(equipment)
{
	if(!isdefined(equipment))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	craftable_name = undefined;
	if(isdefined(equipment.name))
	{
		craftable_name = get_craftable_stat_name(equipment.name);
	}
	if(!isdefined(craftable_name))
	{
		/#
			println("Dev Block strings are not supported" + equipment.name + "Dev Block strings are not supported");
		#/
		return;
	}
	demo::bookmark("zm_player_buildable_placed", GetTime(), self);
	self add_map_craftable_stat(craftable_name, "buildable_placed", 1);
	if(isdefined(equipment.stub) && isdefined(equipment.stub.craftableStub) && isdefined(equipment.stub.craftableStub.hash_id))
	{
		self RecordMapEvent(15, GetTime(), self.origin, level.round_number, equipment.stub.craftableStub.hash_id);
	}
}

/*
	Name: placed_craftable_vo_timer
	Namespace: zm_craftables
	Checksum: 0x1DB32CB9
	Offset: 0xB968
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function placed_craftable_vo_timer()
{
	self endon("disconnect");
	self.craftable_timer = 1;
	wait(60);
	self.craftable_timer = 0;
}

/*
	Name: craftable_pickedup_timer
	Namespace: zm_craftables
	Checksum: 0x56AD8C25
	Offset: 0xB9A0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function craftable_pickedup_timer()
{
	self endon("disconnect");
	self.craftable_pickedup_timer = 1;
	wait(60);
	self.craftable_pickedup_timer = 0;
}

/*
	Name: track_planted_craftables_pickedup
	Namespace: zm_craftables
	Checksum: 0x92C2B420
	Offset: 0xB9D8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function track_planted_craftables_pickedup(equipment)
{
	if(!isdefined(equipment))
	{
		return;
	}
	if(equipment == "equip_turbine_zm" || equipment == "equip_turret_zm" || equipment == "equip_electrictrap_zm" || equipment == "riotshield_zm" || equipment == "alcatraz_shield_zm" || equipment == "tomb_shield_zm")
	{
		self zm_stats::increment_client_stat("planted_buildables_pickedup", 0);
		self zm_stats::increment_player_stat("planted_buildables_pickedup");
	}
	if(!(isdefined(self.craftable_pickedup_timer) && self.craftable_pickedup_timer))
	{
		self say_pickup_craftable_vo(equipment, 1);
		self thread craftable_pickedup_timer();
	}
}

/*
	Name: track_placed_craftables
	Namespace: zm_craftables
	Checksum: 0x615EE513
	Offset: 0xBAE0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function track_placed_craftables(craftable_name)
{
	if(!isdefined(craftable_name))
	{
		return;
	}
	self add_map_craftable_stat(craftable_name, "buildable_placed", 1);
	vo_name = undefined;
	if(craftable_name == level.riotshield_name)
	{
		vo_name = "craft_plc_shield";
	}
	if(!isdefined(vo_name))
	{
		return;
	}
	self thread zm_utility::do_player_general_vox("general", vo_name);
}

/*
	Name: zombie_craftable_set_record_stats
	Namespace: zm_craftables
	Checksum: 0x21FD27DA
	Offset: 0xBB80
	Size: 0x3D
	Parameters: 2
	Flags: None
*/
function zombie_craftable_set_record_stats(str_craftable, b_record)
{
	if(!isdefined(level.craftables_stats_recorded))
	{
		level.craftables_stats_recorded = [];
	}
	level.craftables_stats_recorded[str_craftable] = b_record;
}

/*
	Name: add_map_craftable_stat
	Namespace: zm_craftables
	Checksum: 0xD6127199
	Offset: 0xBBC8
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function add_map_craftable_stat(piece_name, stat_name, value)
{
	if(!isdefined(piece_name) || piece_name == "sq_common" || piece_name == "keys_zm")
	{
		return;
	}
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats || (isdefined(level.zm_disable_recording_buildable_stats) && level.zm_disable_recording_buildable_stats))
	{
		return;
	}
	if(!isdefined(level.craftables_stats_recorded))
	{
		level.craftables_stats_recorded = [];
	}
	if(!(isdefined(level.craftables_stats_recorded[piece_name]) && level.craftables_stats_recorded[piece_name]))
	{
		return;
	}
	self AddDStat("buildables", piece_name, stat_name, value);
}

/*
	Name: say_pickup_craftable_vo
	Namespace: zm_craftables
	Checksum: 0x4F3C501B
	Offset: 0xBCB8
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function say_pickup_craftable_vo(craftable_name, b_world)
{
}

/*
	Name: get_craftable_vo_name
	Namespace: zm_craftables
	Checksum: 0x4471472E
	Offset: 0xBCD8
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function get_craftable_vo_name(craftable_name)
{
}

/*
	Name: get_craftable_stat_name
	Namespace: zm_craftables
	Checksum: 0x1A069358
	Offset: 0xBCF0
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function get_craftable_stat_name(craftable_name)
{
	if(isdefined(craftable_name))
	{
		switch(craftable_name)
		{
			case "equip_riotshield_zm":
			{
				return "riotshield_zm";
			}
			case "equip_turbine_zm":
			{
				return "turbine";
			}
			case "equip_turret_zm":
			{
				return "turret";
			}
			case "equip_electrictrap_zm":
			{
				return "electric_trap";
			}
			case "equip_springpad_zm":
			{
				return "springpad_zm";
			}
			case "equip_slipgun_zm":
			{
				return "slipgun_zm";
			}
		}
	}
	return craftable_name;
}

/*
	Name: get_craftable_model
	Namespace: zm_craftables
	Checksum: 0x862BC075
	Offset: 0xBD88
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function get_craftable_model(str_craftable)
{
	foreach(uts_craftable in level.a_uts_craftables)
	{
		if(uts_craftable.craftableStub.name == str_craftable)
		{
			if(isdefined(uts_craftable.model))
			{
				return uts_craftable.model;
			}
			break;
		}
	}
	return undefined;
}

/*
	Name: get_craftable_piece
	Namespace: zm_craftables
	Checksum: 0x517378EE
	Offset: 0xBE58
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function get_craftable_piece(str_craftable, str_piece)
{
	foreach(uts_craftable in level.a_uts_craftables)
	{
		if(uts_craftable.craftableStub.name == str_craftable)
		{
			foreach(pieceSpawn in uts_craftable.craftableSpawn.a_pieceSpawns)
			{
				if(pieceSpawn.pieceName == str_piece)
				{
					return pieceSpawn;
				}
			}
			break;
		}
	}
	return undefined;
}

/*
	Name: player_get_craftable_piece
	Namespace: zm_craftables
	Checksum: 0x85032513
	Offset: 0xBFA8
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function player_get_craftable_piece(str_craftable, str_piece)
{
	pieceSpawn = get_craftable_piece(str_craftable, str_piece);
	if(isdefined(pieceSpawn))
	{
		self player_take_piece(pieceSpawn);
	}
}

/*
	Name: player_remove_craftable_piece
	Namespace: zm_craftables
	Checksum: 0xC7399E7A
	Offset: 0xC010
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function player_remove_craftable_piece(str_craftable, str_piece)
{
	pieceSpawn = get_craftable_piece(str_craftable, str_piece);
	if(isdefined(pieceSpawn))
	{
		self player_remove_piece(pieceSpawn);
	}
}

/*
	Name: player_remove_piece
	Namespace: zm_craftables
	Checksum: 0xDCE7BB22
	Offset: 0xC078
	Size: 0x111
	Parameters: 1
	Flags: None
*/
function player_remove_piece(piece_to_remove)
{
	if(!isdefined(self.current_craftable_pieces))
	{
		self.current_craftable_pieces = [];
	}
	foreach(self_piece in self.current_craftable_pieces)
	{
		if(piece_to_remove.pieceName === self_piece.pieceName && piece_to_remove.craftablename === self_piece.craftablename)
		{
			self clientfield::set_to_player("craftable", 0);
			self.current_craftable_pieces[slot] = undefined;
			self notify("craftable_piece_released" + slot);
		}
	}
}

/*
	Name: get_craftable_piece_model
	Namespace: zm_craftables
	Checksum: 0xBD666105
	Offset: 0xC198
	Size: 0x161
	Parameters: 2
	Flags: None
*/
function get_craftable_piece_model(str_craftable, str_piece)
{
	foreach(uts_craftable in level.a_uts_craftables)
	{
		if(uts_craftable.craftableStub.name == str_craftable)
		{
			foreach(pieceSpawn in uts_craftable.craftableSpawn.a_pieceSpawns)
			{
				if(pieceSpawn.pieceName == str_piece && isdefined(pieceSpawn.model))
				{
					return pieceSpawn.model;
				}
			}
			break;
		}
	}
	return undefined;
}

/*
	Name: player_show_craftable_parts_ui
	Namespace: zm_craftables
	Checksum: 0x1B867162
	Offset: 0xC308
	Size: 0xA3
	Parameters: 3
	Flags: None
*/
function player_show_craftable_parts_ui(str_crafted_clientuimodel, str_widget_clientuimodel, b_is_crafted)
{
	self notify("player_show_craftable_parts_ui");
	self endon("player_show_craftable_parts_ui");
	if(b_is_crafted)
	{
		if(isdefined(str_crafted_clientuimodel))
		{
			self thread clientfield::set_player_uimodel(str_crafted_clientuimodel, 1);
		}
		n_show_ui_duration = 3.5;
	}
	else
	{
		n_show_ui_duration = 3.5;
	}
	self thread player_hide_craftable_parts_ui_after_duration(str_widget_clientuimodel, n_show_ui_duration);
}

/*
	Name: player_hide_craftable_parts_ui_after_duration
	Namespace: zm_craftables
	Checksum: 0x3215A17B
	Offset: 0xC3B8
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function player_hide_craftable_parts_ui_after_duration(str_widget_clientuimodel, n_show_ui_duration)
{
	self endon("disconnect");
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 1);
	wait(n_show_ui_duration);
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: run_craftables_devgui
	Namespace: zm_craftables
	Checksum: 0xECDC2DBE
	Offset: 0xC420
	Size: 0x707
	Parameters: 0
	Flags: None
*/
function run_craftables_devgui()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		while(1)
		{
			craftable_id = GetDvarString("Dev Block strings are not supported");
			if(craftable_id != "Dev Block strings are not supported")
			{
				a_toks = StrTok(craftable_id, "Dev Block strings are not supported");
				craftable_id = a_toks[0];
				if(isdefined(a_toks[1]))
				{
				}
				else
				{
				}
				n_player = 0;
				piece_spawn = level.cheat_craftables[craftable_id].pieceSpawn;
				if(isdefined(piece_spawn))
				{
					player = level.players[n_player];
					if(isdefined(player))
					{
						player thread player_take_piece(piece_spawn);
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_f86eaea5 = GetDvarString("Dev Block strings are not supported");
			if(var_f86eaea5 != "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					if(zm_equipment::is_included(var_f86eaea5))
					{
						player zm_equipment::buy(var_f86eaea5);
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			craftable_id = GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported");
			if(craftable_id != "Dev Block strings are not supported")
			{
				piece_spawn = level.cheat_craftables[craftable_id].pieceSpawn;
				if(isdefined(piece_spawn.model))
				{
					v_pos = piece_spawn.model.origin;
				}
				else
				{
					v_pos = piece_spawn.start_origin;
				}
				queryResult = PositionQuery_Source_Navigation(v_pos, 100, 200, 200, 15);
				if(queryResult.data.size)
				{
					point = ArrayGetClosest(v_pos, queryResult.data);
					level.players[0] SetOrigin(point.origin);
					level.players[0] SetPlayerAngles(VectorToAngles(v_pos - point.origin));
				}
				else
				{
					IPrintLnBold("Dev Block strings are not supported");
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			craftable_id = GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported");
			if(craftable_id != "Dev Block strings are not supported")
			{
				var_f53fd362 = [];
				foreach(unitrigger_stub in level.a_uts_craftables)
				{
					if(unitrigger_stub.equipname === craftable_id)
					{
						if(!isdefined(var_f53fd362))
						{
							var_f53fd362 = [];
						}
						else if(!IsArray(var_f53fd362))
						{
							var_f53fd362 = Array(var_f53fd362);
						}
						var_f53fd362[var_f53fd362.size] = unitrigger_stub;
					}
				}
				if(var_f53fd362.size)
				{
					v_pos = ArrayGetClosest(level.players[0].origin, var_f53fd362).origin;
					queryResult = PositionQuery_Source_Navigation(v_pos, 100, 200, 200, 15);
					if(queryResult.data.size)
					{
						point = ArrayGetClosest(v_pos, queryResult.data);
						level.players[0] SetOrigin(point.origin);
						level.players[0] SetPlayerAngles(VectorToAngles(v_pos - point.origin));
					}
					else
					{
						IPrintLnBold("Dev Block strings are not supported");
					}
					SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: add_craftable_cheat
	Namespace: zm_craftables
	Checksum: 0x6F91D6FC
	Offset: 0xCB30
	Size: 0x54D
	Parameters: 1
	Flags: None
*/
function add_craftable_cheat(craftable)
{
	/#
		wait(0.05);
		level flag::wait_till("Dev Block strings are not supported");
		wait(0.05);
		if(!isdefined(level.cheat_craftables))
		{
			level.cheat_craftables = [];
		}
		if(isdefined(craftable.weaponName))
		{
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + craftable.weaponName + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
		}
		if(!isdefined(craftable.a_piecestubs))
		{
			return;
		}
		foreach(s_piece in craftable.a_piecestubs)
		{
			id_string = undefined;
			client_field_val = undefined;
			if(isdefined(s_piece.client_field_id))
			{
				id_string = s_piece.client_field_id;
				client_field_val = id_string;
			}
			else if(isdefined(s_piece.pieceName))
			{
				id_string = s_piece.pieceName;
				client_field_val = s_piece.pieceName;
			}
			else if(isdefined(s_piece.client_field_state))
			{
				id_string = "Dev Block strings are not supported";
				client_field_val = s_piece.client_field_state;
			}
			else
			{
				continue;
			}
			tokens = StrTok(id_string, "Dev Block strings are not supported");
			display_string = "Dev Block strings are not supported";
			foreach(token in tokens)
			{
				if(token != "Dev Block strings are not supported" && token != "Dev Block strings are not supported")
				{
					display_string = display_string + "Dev Block strings are not supported" + token;
				}
			}
			level.cheat_craftables["Dev Block strings are not supported" + client_field_val] = s_piece;
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + client_field_val + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + client_field_val + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + client_field_val + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + client_field_val + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + client_field_val + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
			str_cmd = "Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + s_piece.craftablename + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
			s_piece.waste = "Dev Block strings are not supported";
		}
	#/
}

