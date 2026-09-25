#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_equipment;

/*
	Name: __init__sytem__
	Namespace: zm_equipment
	Checksum: 0x59B48D85
	Offset: 0x3B0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equipment", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_equipment
	Checksum: 0x69A7E10D
	Offset: 0x3F8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.buildable_piece_count = 24;
	level._equipment_disappear_fx = "_t6/maps/zombie/fx_zmb_tranzit_electrap_explo";
	level.placeable_equipment_destroy_fn = [];
	if(!(isdefined(level._no_equipment_activated_clientfield) && level._no_equipment_activated_clientfield))
	{
		clientfield::register("scriptmover", "equipment_activated", 1, 4, "int");
	}
	/#
		level thread function_f30ee99e();
	#/
}

/*
	Name: __main__
	Namespace: zm_equipment
	Checksum: 0xB8D7699D
	Offset: 0x490
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __main__()
{
	init_upgrade();
}

/*
	Name: signal_activated
	Namespace: zm_equipment
	Checksum: 0x8A45E980
	Offset: 0x4B0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function signal_activated(VAL)
{
	if(!isdefined(VAL))
	{
		VAL = 1;
	}
	if(isdefined(level._no_equipment_activated_clientfield) && level._no_equipment_activated_clientfield)
	{
		return;
	}
	self endon("death");
	self clientfield::set("equipment_activated", VAL);
	for(i = 0; i < 2; i++)
	{
		util::wait_network_frame();
	}
	self clientfield::set("equipment_activated", 0);
}

/*
	Name: register
	Namespace: zm_equipment
	Checksum: 0xF5DD2E73
	Offset: 0x578
	Size: 0x213
	Parameters: 5
	Flags: None
*/
function register(equipment_name, hint, howto_hint, hint_icon, equipmentVO)
{
	equipment = GetWeapon(equipment_name);
	struct = spawnstruct();
	if(!isdefined(level.zombie_equipment))
	{
		level.zombie_equipment = [];
	}
	struct.equipment = equipment;
	struct.hint = hint;
	struct.howto_hint = howto_hint;
	struct.hint_icon = hint_icon;
	struct.vox = equipmentVO;
	struct.triggers = [];
	struct.models = [];
	struct.notify_strings = spawnstruct();
	struct.notify_strings.activate = equipment.name + "_activate";
	struct.notify_strings.deactivate = equipment.name + "_deactivate";
	struct.notify_strings.taken = equipment.name + "_taken";
	struct.notify_strings.pickup = equipment.name + "_pickup";
	level.zombie_equipment[equipment] = struct;
	/#
		level thread function_de79cac6(equipment);
	#/
}

/*
	Name: register_slot_watcher_override
	Namespace: zm_equipment
	Checksum: 0xC4BE46F9
	Offset: 0x798
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function register_slot_watcher_override(str_equipment, func_slot_watcher_override)
{
	level.a_func_equipment_slot_watcher_override[str_equipment] = func_slot_watcher_override;
}

/*
	Name: is_included
	Namespace: zm_equipment
	Checksum: 0x810281D
	Offset: 0x7C8
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function is_included(equipment)
{
	if(!isdefined(level.zombie_include_equipment))
	{
		return 0;
	}
	if(IsString(equipment))
	{
		equipment = GetWeapon(equipment);
	}
	return isdefined(level.zombie_include_equipment[equipment.rootweapon]);
}

/*
	Name: Include
	Namespace: zm_equipment
	Checksum: 0x3408EE79
	Offset: 0x840
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function Include(equipment_name)
{
	if(!isdefined(level.zombie_include_equipment))
	{
		level.zombie_include_equipment = [];
	}
	level.zombie_include_equipment[GetWeapon(equipment_name)] = 1;
}

/*
	Name: set_ammo_driven
	Namespace: zm_equipment
	Checksum: 0x3A45C4A9
	Offset: 0x890
	Size: 0xBF
	Parameters: 3
	Flags: None
*/
function set_ammo_driven(equipment_name, start, refill_max_ammo)
{
	if(!isdefined(refill_max_ammo))
	{
		refill_max_ammo = 0;
	}
	level.zombie_equipment[GetWeapon(equipment_name)].notake = 1;
	level.zombie_equipment[GetWeapon(equipment_name)].start_ammo = start;
	level.zombie_equipment[GetWeapon(equipment_name)].refill_max_ammo = refill_max_ammo;
}

/*
	Name: limit
	Namespace: zm_equipment
	Checksum: 0x9FA324D9
	Offset: 0x958
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function limit(equipment_name, limited)
{
	if(!isdefined(level._limited_equipment))
	{
		level._limited_equipment = [];
	}
	if(limited)
	{
		level._limited_equipment[level._limited_equipment.size] = GetWeapon(equipment_name);
	}
	else
	{
		ArrayRemoveValue(level._limited_equipment, GetWeapon(equipment_name), 0);
	}
}

/*
	Name: init_upgrade
	Namespace: zm_equipment
	Checksum: 0xF1184D38
	Offset: 0x9F8
	Size: 0x185
	Parameters: 0
	Flags: None
*/
function init_upgrade()
{
	equipment_spawns = [];
	equipment_spawns = GetEntArray("zombie_equipment_upgrade", "targetname");
	for(i = 0; i < equipment_spawns.size; i++)
	{
		equipment_spawns[i].equipment = GetWeapon(equipment_spawns[i].zombie_equipment_upgrade);
		hint_string = get_hint(equipment_spawns[i].equipment);
		equipment_spawns[i] setHintString(hint_string);
		equipment_spawns[i] setcursorhint("HINT_NOICON");
		equipment_spawns[i] UseTriggerRequireLookAt();
		equipment_spawns[i] add_to_trigger_list(equipment_spawns[i].equipment);
		equipment_spawns[i] thread equipment_spawn_think();
	}
}

/*
	Name: get_hint
	Namespace: zm_equipment
	Checksum: 0x8E1F0D08
	Offset: 0xB88
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_hint(equipment)
{
	/#
		Assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "Dev Block strings are not supported");
	#/
	return level.zombie_equipment[equipment].hint;
}

/*
	Name: get_howto_hint
	Namespace: zm_equipment
	Checksum: 0x940ED5F8
	Offset: 0xBF0
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_howto_hint(equipment)
{
	/#
		Assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "Dev Block strings are not supported");
	#/
	return level.zombie_equipment[equipment].howto_hint;
}

/*
	Name: get_icon
	Namespace: zm_equipment
	Checksum: 0x5484AC22
	Offset: 0xC58
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_icon(equipment)
{
	/#
		Assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "Dev Block strings are not supported");
	#/
	return level.zombie_equipment[equipment].hint_icon;
}

/*
	Name: get_notify_strings
	Namespace: zm_equipment
	Checksum: 0x5A59121D
	Offset: 0xCC0
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_notify_strings(equipment)
{
	/#
		Assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "Dev Block strings are not supported");
	#/
	return level.zombie_equipment[equipment].notify_strings;
}

/*
	Name: add_to_trigger_list
	Namespace: zm_equipment
	Checksum: 0x59EBEB44
	Offset: 0xD28
	Size: 0xCD
	Parameters: 1
	Flags: None
*/
function add_to_trigger_list(equipment)
{
	/#
		Assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "Dev Block strings are not supported");
	#/
	level.zombie_equipment[equipment].triggers[level.zombie_equipment[equipment].triggers.size] = self;
	level.zombie_equipment[equipment].models[level.zombie_equipment[equipment].models.size] = GetEnt(self.target, "targetname");
}

/*
	Name: equipment_spawn_think
	Namespace: zm_equipment
	Checksum: 0xED756491
	Offset: 0xE00
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function equipment_spawn_think()
{
	for(;;)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger() || player.IS_DRINKING > 0)
		{
			wait(0.1);
			continue;
		}
		if(!is_limited(self.equipment) || !limited_in_use(self.equipment))
		{
			if(is_limited(self.equipment))
			{
				player setup_limited(self.equipment);
				if(isdefined(level.hacker_tool_positions))
				{
					new_pos = Array::random(level.hacker_tool_positions);
					self.origin = new_pos.trigger_org;
					model = GetEnt(self.target, "targetname");
					model.origin = new_pos.model_org;
					model.angles = new_pos.model_ang;
				}
			}
			player give(self.equipment);
			continue;
		}
		wait(0.1);
	}
}

/*
	Name: set_equipment_invisibility_to_player
	Namespace: zm_equipment
	Checksum: 0x1554C7F1
	Offset: 0xFC0
	Size: 0x10D
	Parameters: 2
	Flags: None
*/
function set_equipment_invisibility_to_player(equipment, invisible)
{
	triggers = level.zombie_equipment[equipment].triggers;
	for(i = 0; i < triggers.size; i++)
	{
		if(isdefined(triggers[i]))
		{
			triggers[i] SetInvisibleToPlayer(self, invisible);
		}
	}
	models = level.zombie_equipment[equipment].models;
	for(i = 0; i < models.size; i++)
	{
		if(isdefined(models[i]))
		{
			models[i] SetInvisibleToPlayer(self, invisible);
		}
	}
}

/*
	Name: take
	Namespace: zm_equipment
	Checksum: 0x28CC6DCF
	Offset: 0x10D8
	Size: 0x2C3
	Parameters: 1
	Flags: None
*/
function take(equipment)
{
	if(!isdefined(equipment))
	{
		equipment = self get_player_equipment();
	}
	if(!isdefined(equipment))
	{
		return;
	}
	if(equipment == level.weaponNone)
	{
		return;
	}
	if(!self has_player_equipment(equipment))
	{
		return;
	}
	current = 0;
	current_weapon = 0;
	if(isdefined(self get_player_equipment()) && equipment == self get_player_equipment())
	{
		current = 1;
	}
	if(equipment == self GetCurrentWeapon())
	{
		current_weapon = 1;
	}
	/#
		println("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + equipment.name + "Dev Block strings are not supported");
	#/
	notify_strings = get_notify_strings(equipment);
	if(isdefined(self.current_equipment_active[equipment]) && self.current_equipment_active[equipment])
	{
		self.current_equipment_active[equipment] = 0;
		self notify(notify_strings.deactivate);
	}
	self notify(notify_strings.taken);
	self TakeWeapon(equipment);
	if(!is_limited(equipment) || (is_limited(equipment) && !limited_in_use(equipment)))
	{
		self set_equipment_invisibility_to_player(equipment, 0);
	}
	if(current)
	{
		self set_player_equipment(level.weaponNone);
		self SetActionSlot(2, "");
	}
	else
	{
		ArrayRemoveValue(self.deployed_equipment, equipment);
	}
	if(current_weapon)
	{
		self zm_weapons::switch_back_primary_weapon();
	}
}

/*
	Name: give
	Namespace: zm_equipment
	Checksum: 0xAACB9B56
	Offset: 0x13A8
	Size: 0x1FD
	Parameters: 1
	Flags: None
*/
function give(equipment)
{
	if(!isdefined(equipment))
	{
		return;
	}
	if(!isdefined(level.zombie_equipment[equipment]))
	{
		return;
	}
	if(self has_player_equipment(equipment))
	{
		return;
	}
	/#
		println("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + equipment.name + "Dev Block strings are not supported");
	#/
	curr_weapon = self GetCurrentWeapon();
	curr_weapon_was_curr_equipment = self is_player_equipment(curr_weapon);
	self take();
	self set_player_equipment(equipment);
	self GiveWeapon(equipment);
	self start_ammo(equipment);
	self thread show_hint(equipment);
	self set_equipment_invisibility_to_player(equipment, 1);
	self SetActionSlot(2, "weapon", equipment);
	self thread slot_watcher(equipment);
	self zm_audio::create_and_play_dialog("weapon_pickup", level.zombie_equipment[equipment].vox);
	self notify("player_given", equipment);
}

/*
	Name: buy
	Namespace: zm_equipment
	Checksum: 0xB057E5FC
	Offset: 0x15B0
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function buy(equipment)
{
	if(IsString(equipment))
	{
		equipment = GetWeapon(equipment);
	}
	/#
		println("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + equipment.name + "Dev Block strings are not supported");
	#/
	if(isdefined(self.current_equipment) && equipment != self.current_equipment && self.current_equipment != level.weaponNone)
	{
		self take(self.current_equipment);
	}
	self notify("player_bought", equipment);
	self give(equipment);
	if(equipment.isRiotShield && isdefined(self.player_shield_reset_health))
	{
		self [[self.player_shield_reset_health]]();
	}
}

/*
	Name: slot_watcher
	Namespace: zm_equipment
	Checksum: 0x4E3E4753
	Offset: 0x16F0
	Size: 0x1FD
	Parameters: 1
	Flags: None
*/
function slot_watcher(equipment)
{
	self notify("kill_equipment_slot_watcher");
	self endon("kill_equipment_slot_watcher");
	self endon("disconnect");
	notify_strings = get_notify_strings(equipment);
	while(1)
	{
		self waittill("weapon_change", curr_weapon, prev_weapon);
		if(self.sessionstate != "spectator")
		{
			self.prev_weapon_before_equipment_change = undefined;
			if(isdefined(prev_weapon) && level.weaponNone != prev_weapon)
			{
				prev_weapon_type = prev_weapon.inventoryType;
				if("primary" == prev_weapon_type || "altmode" == prev_weapon_type)
				{
					self.prev_weapon_before_equipment_change = prev_weapon;
				}
			}
			if(!isdefined(level.a_func_equipment_slot_watcher_override))
			{
				level.a_func_equipment_slot_watcher_override = [];
			}
			if(isdefined(level.a_func_equipment_slot_watcher_override[equipment.name]))
			{
				self [[level.a_func_equipment_slot_watcher_override[equipment.name]]](equipment, curr_weapon, prev_weapon, notify_strings);
			}
			else if(curr_weapon == equipment && !self.current_equipment_active[equipment])
			{
				self notify(notify_strings.activate);
				self.current_equipment_active[equipment] = 1;
			}
			else if(curr_weapon != equipment && self.current_equipment_active[equipment])
			{
				self notify(notify_strings.deactivate);
				self.current_equipment_active[equipment] = 0;
			}
		}
	}
}

/*
	Name: is_limited
	Namespace: zm_equipment
	Checksum: 0x5C64FE1A
	Offset: 0x18F8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function is_limited(equipment)
{
	if(isdefined(level._limited_equipment))
	{
		for(i = 0; i < level._limited_equipment.size; i++)
		{
			if(level._limited_equipment[i] == equipment)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: limited_in_use
	Namespace: zm_equipment
	Checksum: 0x80407886
	Offset: 0x1968
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function limited_in_use(equipment)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		current_equipment = players[i] get_player_equipment();
		if(isdefined(current_equipment) && current_equipment == equipment)
		{
			return 1;
		}
	}
	if(isdefined(level.dropped_equipment) && isdefined(level.dropped_equipment[equipment]))
	{
		return 1;
	}
	return 0;
}

/*
	Name: setup_limited
	Namespace: zm_equipment
	Checksum: 0xBF106B9F
	Offset: 0x1A30
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function setup_limited(equipment)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] set_equipment_invisibility_to_player(equipment, 1);
	}
	self thread release_limited_on_disconnect(equipment);
	self thread release_limited_on_taken(equipment);
}

/*
	Name: release_limited_on_taken
	Namespace: zm_equipment
	Checksum: 0x6025489A
	Offset: 0x1AE0
	Size: 0xCD
	Parameters: 1
	Flags: None
*/
function release_limited_on_taken(equipment)
{
	self endon("disconnect");
	notify_strings = get_notify_strings(equipment);
	self util::waittill_either(notify_strings.taken, "spawned_spectator");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] set_equipment_invisibility_to_player(equipment, 0);
	}
}

/*
	Name: release_limited_on_disconnect
	Namespace: zm_equipment
	Checksum: 0xE822426D
	Offset: 0x1BB8
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function release_limited_on_disconnect(equipment)
{
	notify_strings = get_notify_strings(equipment);
	self endon(notify_strings.taken);
	self waittill("disconnect");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]))
		{
			players[i] set_equipment_invisibility_to_player(equipment, 0);
		}
	}
}

/*
	Name: is_active
	Namespace: zm_equipment
	Checksum: 0xA213C068
	Offset: 0x1CA0
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function is_active(equipment)
{
	if(!isdefined(self.current_equipment_active) || !isdefined(self.current_equipment_active[equipment]))
	{
		return 0;
	}
	return self.current_equipment_active[equipment];
}

/*
	Name: init_hint_hudelem
	Namespace: zm_equipment
	Checksum: 0x6208E859
	Offset: 0x1CE8
	Size: 0x87
	Parameters: 6
	Flags: None
*/
function init_hint_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontscale = fontscale;
	self.alpha = alpha;
	self.sort = 20;
}

/*
	Name: setup_client_hintelem
	Namespace: zm_equipment
	Checksum: 0x330CCD4E
	Offset: 0x1D78
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function setup_client_hintelem(ypos, font_scale)
{
	if(!isdefined(ypos))
	{
		ypos = 220;
	}
	if(!isdefined(font_scale))
	{
		font_scale = 1.25;
	}
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.hintelem))
	{
		self.hintelem = newClientHudElem(self);
	}
	if(self IsSplitscreen())
	{
		if(GetDvarInt("splitscreen_playerCount") >= 3)
		{
			self.hintelem init_hint_hudelem(160, 90, "center", "middle", font_scale * 0.8, 1);
		}
		else
		{
			self.hintelem init_hint_hudelem(160, 90, "center", "middle", font_scale, 1);
		}
	}
	else
	{
		self.hintelem init_hint_hudelem(320, ypos, "center", "bottom", font_scale, 1);
	}
}

/*
	Name: show_hint
	Namespace: zm_equipment
	Checksum: 0x802E970A
	Offset: 0x1F08
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function show_hint(equipment)
{
	self notify("kill_previous_show_equipment_hint_thread");
	self endon("kill_previous_show_equipment_hint_thread");
	self endon("death");
	self endon("disconnect");
	if(isdefined(self.do_not_display_equipment_pickup_hint) && self.do_not_display_equipment_pickup_hint)
	{
		return;
	}
	wait(0.5);
	text = get_howto_hint(equipment);
	self show_hint_text(text);
}

/*
	Name: show_hint_text
	Namespace: zm_equipment
	Checksum: 0xC37718B9
	Offset: 0x1FB0
	Size: 0x203
	Parameters: 4
	Flags: None
*/
function show_hint_text(text, show_for_time, font_scale, ypos)
{
	if(!isdefined(show_for_time))
	{
		show_for_time = 3.2;
	}
	if(!isdefined(font_scale))
	{
		font_scale = 1.25;
	}
	if(!isdefined(ypos))
	{
		ypos = 220;
	}
	self notify("hide_equipment_hint_text");
	wait(0.05);
	self setup_client_hintelem(ypos, font_scale);
	self.hintelem setText(text);
	self.hintelem.alpha = 1;
	self.hintelem.font = "small";
	self.hintelem.hidewheninmenu = 1;
	time = self util::waittill_any_timeout(show_for_time, "hide_equipment_hint_text", "death", "disconnect");
	if(isdefined(time) && isdefined(self) && isdefined(self.hintelem))
	{
		self.hintelem fadeOverTime(0.25);
		self.hintelem.alpha = 0;
		self util::waittill_any_timeout(0.25, "hide_equipment_hint_text");
	}
	if(isdefined(self) && isdefined(self.hintelem))
	{
		self.hintelem setText("");
		self.hintelem destroy();
	}
}

/*
	Name: start_ammo
	Namespace: zm_equipment
	Checksum: 0x1E644DA1
	Offset: 0x21C0
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function start_ammo(equipment)
{
	if(self HasWeapon(equipment))
	{
		maxAmmo = 1;
		if(isdefined(level.zombie_equipment[equipment].notake) && level.zombie_equipment[equipment].notake)
		{
			maxAmmo = level.zombie_equipment[equipment].start_ammo;
		}
		self SetWeaponAmmoClip(equipment, maxAmmo);
		self notify("equipment_ammo_changed", equipment);
		return maxAmmo;
	}
	return 0;
}

/*
	Name: change_ammo
	Namespace: zm_equipment
	Checksum: 0x259F0B05
	Offset: 0x2290
	Size: 0x13D
	Parameters: 2
	Flags: None
*/
function change_ammo(equipment, change)
{
	if(self HasWeapon(equipment))
	{
		oldammo = self GetWeaponAmmoClip(equipment);
		maxAmmo = 1;
		if(isdefined(level.zombie_equipment[equipment].notake) && level.zombie_equipment[equipment].notake)
		{
			maxAmmo = level.zombie_equipment[equipment].start_ammo;
		}
		newAmmo = Int(min(maxAmmo, max(0, oldammo + change)));
		self SetWeaponAmmoClip(equipment, newAmmo);
		self notify("equipment_ammo_changed", equipment);
		return newAmmo;
	}
	return 0;
}

/*
	Name: disappear_fx
	Namespace: zm_equipment
	Checksum: 0x72D1DB37
	Offset: 0x23D8
	Size: 0xA3
	Parameters: 3
	Flags: None
*/
function disappear_fx(origin, FX, angles)
{
	effect = level._equipment_disappear_fx;
	if(isdefined(FX))
	{
		effect = FX;
	}
	if(isdefined(angles))
	{
		playFX(effect, origin, AnglesToForward(angles));
	}
	else
	{
		playFX(effect, origin);
	}
	wait(1.1);
}

/*
	Name: register_for_level
	Namespace: zm_equipment
	Checksum: 0x9F63B46A
	Offset: 0x2488
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function register_for_level(weaponName)
{
	weapon = GetWeapon(weaponName);
	if(is_equipment(weapon))
	{
		return;
	}
	if(!isdefined(level.zombie_equipment_list))
	{
		level.zombie_equipment_list = [];
	}
	level.zombie_equipment_list[weapon] = weapon;
}

/*
	Name: is_equipment
	Namespace: zm_equipment
	Checksum: 0x5FA83105
	Offset: 0x2508
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function is_equipment(weapon)
{
	if(!isdefined(weapon) || !isdefined(level.zombie_equipment_list))
	{
		return 0;
	}
	return isdefined(level.zombie_equipment_list[weapon]);
}

/*
	Name: is_equipment_that_blocks_purchase
	Namespace: zm_equipment
	Checksum: 0x1457048A
	Offset: 0x2550
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function is_equipment_that_blocks_purchase(weapon)
{
	return is_equipment(weapon);
}

/*
	Name: is_player_equipment
	Namespace: zm_equipment
	Checksum: 0xA5F65DD1
	Offset: 0x2580
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function is_player_equipment(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_equipment))
	{
		return 0;
	}
	return self.current_equipment == weapon;
}

/*
	Name: has_deployed_equipment
	Namespace: zm_equipment
	Checksum: 0xEF940F56
	Offset: 0x25C0
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function has_deployed_equipment(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.deployed_equipment) || self.deployed_equipment.size < 1)
	{
		return 0;
	}
	for(i = 0; i < self.deployed_equipment.size; i++)
	{
		if(self.deployed_equipment[i] == weapon)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: has_player_equipment
	Namespace: zm_equipment
	Checksum: 0xC142B145
	Offset: 0x2658
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function has_player_equipment(weapon)
{
	return self is_player_equipment(weapon) || self has_deployed_equipment(weapon);
}

/*
	Name: get_player_equipment
	Namespace: zm_equipment
	Checksum: 0x2E468E0E
	Offset: 0x26A0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function get_player_equipment()
{
	equipment = level.weaponNone;
	if(isdefined(self.current_equipment))
	{
		equipment = self.current_equipment;
	}
	return equipment;
}

/*
	Name: hacker_active
	Namespace: zm_equipment
	Checksum: 0x4F7D3DE2
	Offset: 0x26E0
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function hacker_active()
{
	return self is_active(GetWeapon("equip_hacker"));
}

/*
	Name: set_player_equipment
	Namespace: zm_equipment
	Checksum: 0xEC523A7E
	Offset: 0x2718
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function set_player_equipment(weapon)
{
	if(!isdefined(self.current_equipment_active))
	{
		self.current_equipment_active = [];
	}
	if(isdefined(weapon))
	{
		self.current_equipment_active[weapon] = 0;
	}
	if(!isdefined(self.equipment_got_in_round))
	{
		self.equipment_got_in_round = [];
	}
	if(isdefined(weapon))
	{
		self.equipment_got_in_round[weapon] = level.round_number;
	}
	self notify("new_equipment", weapon);
	self.current_equipment = weapon;
}

/*
	Name: init_player_equipment
	Namespace: zm_equipment
	Checksum: 0x9DB95F43
	Offset: 0x27B8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function init_player_equipment()
{
	self set_player_equipment(level.zombie_equipment_player_init);
}

/*
	Name: function_f30ee99e
	Namespace: zm_equipment
	Checksum: 0x43D090F1
	Offset: 0x27E8
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function function_f30ee99e()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		wait(0.05);
		level flag::wait_till("Dev Block strings are not supported");
		wait(0.05);
		str_cmd = "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		while(1)
		{
			var_f86eaea5 = GetDvarString("Dev Block strings are not supported");
			if(var_f86eaea5 != "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					if(var_f86eaea5 == "Dev Block strings are not supported")
					{
						player take();
						continue;
					}
					if(is_included(var_f86eaea5))
					{
						player buy(var_f86eaea5);
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_de79cac6
	Namespace: zm_equipment
	Checksum: 0x373F622D
	Offset: 0x29D0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_de79cac6(equipment)
{
	/#
		wait(0.05);
		level flag::wait_till("Dev Block strings are not supported");
		wait(0.05);
		if(isdefined(equipment))
		{
			var_f86eaea5 = equipment.name;
			str_cmd = "Dev Block strings are not supported" + var_f86eaea5 + "Dev Block strings are not supported" + var_f86eaea5 + "Dev Block strings are not supported";
			AddDebugCommand(str_cmd);
		}
	#/
}

