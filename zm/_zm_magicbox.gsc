#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_daily_challenges;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_magicbox;

/*
	Name: __init__sytem__
	Namespace: zm_magicbox
	Checksum: 0x1C582414
	Offset: 0x7C0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_magicbox", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_magicbox
	Checksum: 0x5D65CA71
	Offset: 0x808
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.start_chest_name = "start_chest";
	level._effect["lght_marker"] = "zombie/fx_weapon_box_marker_zmb";
	level._effect["lght_marker_flare"] = "zombie/fx_weapon_box_marker_fl_zmb";
	level._effect["poltergeist"] = "zombie/fx_barrier_buy_zmb";
	clientfield::register("zbarrier", "magicbox_open_glow", 1, 1, "int");
	clientfield::register("zbarrier", "magicbox_closed_glow", 1, 1, "int");
	clientfield::register("zbarrier", "zbarrier_show_sounds", 1, 1, "counter");
	clientfield::register("zbarrier", "zbarrier_leave_sounds", 1, 1, "counter");
	clientfield::register("scriptmover", "force_stream", 7000, 1, "int");
	level thread magicbox_host_migration();
}

/*
	Name: __main__
	Namespace: zm_magicbox
	Checksum: 0x616753F4
	Offset: 0x980
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(!isdefined(level.chest_joker_model))
	{
		level.chest_joker_model = "p7_zm_teddybear";
	}
	if(!isdefined(level.magic_box_zbarrier_state_func))
	{
		level.magic_box_zbarrier_state_func = &process_magic_box_zbarrier_state;
	}
	if(!isdefined(level.magic_box_check_equipment))
	{
		level.magic_box_check_equipment = &default_magic_box_check_equipment;
	}
	wait(0.05);
	if(zm_utility::is_Classic())
	{
		level.chests = struct::get_array("treasure_chest_use", "targetname");
		treasure_chest_init(level.start_chest_name);
	}
}

/*
	Name: treasure_chest_init
	Namespace: zm_magicbox
	Checksum: 0xC6A45F99
	Offset: 0xA48
	Size: 0x2F3
	Parameters: 1
	Flags: None
*/
function treasure_chest_init(start_chest_name)
{
	level flag::init("moving_chest_enabled");
	level flag::init("moving_chest_now");
	level flag::init("chest_has_been_used");
	level.chest_moves = 0;
	level.chest_level = 0;
	if(level.chests.size == 0)
	{
		return;
	}
	for(i = 0; i < level.chests.size; i++)
	{
		level.chests[i].box_hacks = [];
		level.chests[i].orig_origin = level.chests[i].origin;
		level.chests[i] get_chest_pieces();
		if(isdefined(level.chests[i].zombie_cost))
		{
			level.chests[i].old_cost = level.chests[i].zombie_cost;
			continue;
		}
		level.chests[i].old_cost = 950;
	}
	if(!level.enable_magic)
	{
		foreach(Chest in level.chests)
		{
			Chest hide_chest();
		}
		return;
	}
	level.chest_accessed = 0;
	if(level.chests.size > 1)
	{
		level flag::set("moving_chest_enabled");
		level.chests = Array::randomize(level.chests);
	}
	else
	{
		level.chest_index = 0;
		level.chests[0].no_fly_away = 1;
	}
	init_starting_chest_location(start_chest_name);
	Array::thread_all(level.chests, &treasure_chest_think);
}

/*
	Name: init_starting_chest_location
	Namespace: zm_magicbox
	Checksum: 0x9BD6CC7F
	Offset: 0xD48
	Size: 0x3CB
	Parameters: 1
	Flags: None
*/
function init_starting_chest_location(start_chest_name)
{
	level.chest_index = 0;
	start_chest_found = 0;
	if(level.chests.size == 1)
	{
		start_chest_found = 1;
		if(isdefined(level.chests[level.chest_index].zbarrier))
		{
			level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state("initial");
			level.chests[level.chest_index] thread box_encounter_vo();
		}
		break;
	}
	for(i = 0; i < level.chests.size; i++)
	{
		if(isdefined(level.random_pandora_box_start) && level.random_pandora_box_start == 1)
		{
			if(start_chest_found || (isdefined(level.chests[i].start_exclude) && level.chests[i].start_exclude == 1))
			{
				level.chests[i] hide_chest();
			}
			else
			{
				level.chest_index = i;
				level.chests[level.chest_index].hidden = 0;
				if(isdefined(level.chests[level.chest_index].zbarrier))
				{
					level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state("initial");
					level.chests[level.chest_index] thread box_encounter_vo();
				}
				start_chest_found = 1;
			}
			continue;
		}
		if(start_chest_found || !isdefined(level.chests[i].script_noteworthy) || !IsSubStr(level.chests[i].script_noteworthy, start_chest_name))
		{
			level.chests[i] hide_chest();
			continue;
		}
		level.chest_index = i;
		level.chests[level.chest_index].hidden = 0;
		if(isdefined(level.chests[level.chest_index].zbarrier))
		{
			level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state("initial");
			level.chests[level.chest_index] thread box_encounter_vo();
		}
		start_chest_found = 1;
	}
	if(!isdefined(level.pandora_show_func))
	{
		if(isdefined(level.custom_pandora_show_func))
		{
			level.pandora_show_func = level.custom_pandora_show_func;
		}
		else
		{
			level.pandora_show_func = &default_pandora_show_func;
		}
	}
	level.chests[level.chest_index] thread [[level.pandora_show_func]]();
}

/*
	Name: set_treasure_chest_cost
	Namespace: zm_magicbox
	Checksum: 0x4B961495
	Offset: 0x1120
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function set_treasure_chest_cost(cost)
{
	level.zombie_treasure_chest_cost = cost;
}

/*
	Name: get_chest_pieces
	Namespace: zm_magicbox
	Checksum: 0x96CEED19
	Offset: 0x1140
	Size: 0x29F
	Parameters: 0
	Flags: None
*/
function get_chest_pieces()
{
	self.chest_box = GetEnt(self.script_noteworthy + "_zbarrier", "script_noteworthy");
	self.chest_rubble = [];
	rubble = GetEntArray(self.script_noteworthy + "_rubble", "script_noteworthy");
	for(i = 0; i < rubble.size; i++)
	{
		if(DistanceSquared(self.origin, rubble[i].origin) < 10000)
		{
			self.chest_rubble[self.chest_rubble.size] = rubble[i];
		}
	}
	self.zbarrier = GetEnt(self.script_noteworthy + "_zbarrier", "script_noteworthy");
	if(isdefined(self.zbarrier))
	{
		self.zbarrier ZBarrierPieceUseBoxRiseLogic(3);
		self.zbarrier ZBarrierPieceUseBoxRiseLogic(4);
	}
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin = self.origin + AnglesToRight(self.angles) * -22.5;
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 45;
	self.unitrigger_stub.trigger_target = self;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.unitrigger_stub, 1);
	self.unitrigger_stub.prompt_and_visibility_func = &boxtrigger_update_prompt;
	self.zbarrier.owner = self;
}

/*
	Name: boxtrigger_update_prompt
	Namespace: zm_magicbox
	Checksum: 0xCB44A37E
	Offset: 0x13E8
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function boxtrigger_update_prompt(player)
{
	can_use = self boxstub_update_prompt(player);
	if(isdefined(self.hint_string))
	{
		if(isdefined(self.hint_parm1))
		{
			self setHintString(self.hint_string, self.hint_parm1);
		}
		else
		{
			self setHintString(self.hint_string);
		}
	}
	return can_use;
}

/*
	Name: boxstub_update_prompt
	Namespace: zm_magicbox
	Checksum: 0xE988B015
	Offset: 0x1480
	Size: 0x197
	Parameters: 1
	Flags: None
*/
function boxstub_update_prompt(player)
{
	if(!self trigger_visible_to_player(player))
	{
		return 0;
	}
	if(isdefined(level.func_magicbox_update_prompt_use_override))
	{
		if([[level.func_magicbox_update_prompt_use_override]]())
		{
			return 0;
		}
	}
	self.hint_parm1 = undefined;
	if(isdefined(self.stub.trigger_target.grab_weapon_hint) && self.stub.trigger_target.grab_weapon_hint)
	{
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = self.stub.trigger_target.grab_weapon;
		self setcursorhint(cursor_hint, cursor_hint_weapon);
		if(isdefined(level.magic_box_check_equipment) && [[level.magic_box_check_equipment]](cursor_hint_weapon))
		{
			self.hint_string = &"ZOMBIE_TRADE_EQUIP_FILL";
		}
		else
		{
			self.hint_string = &"ZOMBIE_TRADE_WEAPON_FILL";
		}
	}
	else
	{
		self setcursorhint("HINT_NOICON");
		self.hint_parm1 = self.stub.trigger_target.zombie_cost;
		self.hint_string = zm_utility::get_hint_string(self, "default_treasure_chest");
	}
	return 1;
}

/*
	Name: default_magic_box_check_equipment
	Namespace: zm_magicbox
	Checksum: 0x6100DBF1
	Offset: 0x1620
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function default_magic_box_check_equipment(weapon)
{
	return zm_utility::is_offhand_weapon(weapon);
}

/*
	Name: trigger_visible_to_player
	Namespace: zm_magicbox
	Checksum: 0xB6066895
	Offset: 0x1650
	Size: 0x177
	Parameters: 1
	Flags: None
*/
function trigger_visible_to_player(player)
{
	self SetInvisibleToPlayer(player);
	visible = 1;
	if(isdefined(self.stub.trigger_target.chest_user) && !isdefined(self.stub.trigger_target.box_rerespun))
	{
		if(player != self.stub.trigger_target.chest_user || zm_utility::is_placeable_mine(self.stub.trigger_target.chest_user GetCurrentWeapon()) || self.stub.trigger_target.chest_user zm_equipment::hacker_active())
		{
			visible = 0;
		}
	}
	else if(!player can_buy_weapon())
	{
		visible = 0;
	}
	if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		visible = 0;
	}
	if(!visible)
	{
		return 0;
	}
	self SetVisibleToPlayer(player);
	return 1;
}

/*
	Name: magicbox_unitrigger_think
	Namespace: zm_magicbox
	Checksum: 0x7B81AF1D
	Offset: 0x17D0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function magicbox_unitrigger_think()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", player);
		self.stub.trigger_target notify("trigger", player);
	}
}

/*
	Name: play_crazi_sound
	Namespace: zm_magicbox
	Checksum: 0x6031FB69
	Offset: 0x1830
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function play_crazi_sound()
{
	self playlocalsound(level.zmb_laugh_alias);
}

/*
	Name: show_chest
	Namespace: zm_magicbox
	Checksum: 0xBC3B882C
	Offset: 0x1860
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function show_chest()
{
	self.zbarrier set_magic_box_zbarrier_state("arriving");
	self.zbarrier util::waittill_any_timeout(5, "arrived");
	self thread [[level.pandora_show_func]]();
	self.zbarrier clientfield::set("magicbox_closed_glow", 1);
	thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);
	self.zbarrier clientfield::increment("zbarrier_show_sounds");
	self.hidden = 0;
	if(isdefined(self.box_hacks["summon_box"]))
	{
		self [[self.box_hacks["summon_box"]]](0);
	}
}

/*
	Name: hide_chest
	Namespace: zm_magicbox
	Checksum: 0xC39F2666
	Offset: 0x1978
	Size: 0x21B
	Parameters: 1
	Flags: None
*/
function hide_chest(doBoxLeave)
{
	if(isdefined(self.unitrigger_stub))
	{
		thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	}
	if(isdefined(self.pandora_light))
	{
		self.pandora_light delete();
	}
	self.zbarrier clientfield::set("magicbox_closed_glow", 0);
	self.hidden = 1;
	if(isdefined(self.box_hacks) && isdefined(self.box_hacks["summon_box"]))
	{
		self [[self.box_hacks["summon_box"]]](1);
	}
	if(isdefined(self.zbarrier))
	{
		if(isdefined(doBoxLeave) && doBoxLeave)
		{
			self.zbarrier clientfield::increment("zbarrier_leave_sounds");
			level thread zm_audio::sndAnnouncerPlayVox("boxmove");
			self.zbarrier thread magic_box_zbarrier_leave();
			self.zbarrier waittill("left");
			playFX(level._effect["poltergeist"], self.zbarrier.origin, anglesToUp(self.zbarrier.angles), AnglesToForward(self.zbarrier.angles));
			playsoundatposition("zmb_box_poof", self.zbarrier.origin);
		}
		else
		{
			self.zbarrier thread set_magic_box_zbarrier_state("away");
		}
	}
}

/*
	Name: magic_box_zbarrier_leave
	Namespace: zm_magicbox
	Checksum: 0x7DAD4EE4
	Offset: 0x1BA0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function magic_box_zbarrier_leave()
{
	self set_magic_box_zbarrier_state("leaving");
	self waittill("left");
	self set_magic_box_zbarrier_state("away");
}

/*
	Name: default_pandora_fx_func
	Namespace: zm_magicbox
	Checksum: 0x2121959C
	Offset: 0x1BF8
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function default_pandora_fx_func()
{
	self endon("death");
	self.pandora_light = spawn("script_model", self.zbarrier.origin);
	self.pandora_light.angles = self.zbarrier.angles + VectorScale((-1, 0, -1), 90);
	self.pandora_light SetModel("tag_origin");
	if(!(isdefined(level._box_initialized) && level._box_initialized))
	{
		level flag::wait_till("start_zombie_round_logic");
		level._box_initialized = 1;
	}
	wait(1);
	if(isdefined(self) && isdefined(self.pandora_light))
	{
		PlayFXOnTag(level._effect["lght_marker"], self.pandora_light, "tag_origin");
	}
}

/*
	Name: default_pandora_show_func
	Namespace: zm_magicbox
	Checksum: 0x2F60E6A9
	Offset: 0x1D20
	Size: 0x93
	Parameters: 3
	Flags: None
*/
function default_pandora_show_func(anchor, anchorTarget, pieces)
{
	if(!isdefined(self.pandora_light))
	{
		if(!isdefined(level.pandora_fx_func))
		{
			level.pandora_fx_func = &default_pandora_fx_func;
		}
		self thread [[level.pandora_fx_func]]();
	}
	playFX(level._effect["lght_marker_flare"], self.pandora_light.origin);
}

/*
	Name: unregister_unitrigger_on_kill_think
	Namespace: zm_magicbox
	Checksum: 0xD7B871BE
	Offset: 0x1DC0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function unregister_unitrigger_on_kill_think()
{
	self notify("unregister_unitrigger_on_kill_think");
	self endon("unregister_unitrigger_on_kill_think");
	self waittill("kill_chest_think");
	thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
}

/*
	Name: treasure_chest_think
	Namespace: zm_magicbox
	Checksum: 0x154FA84C
	Offset: 0x1E10
	Size: 0xF03
	Parameters: 0
	Flags: None
*/
function treasure_chest_think()
{
	self endon("kill_chest_think");
	User = undefined;
	user_cost = undefined;
	self.box_rerespun = undefined;
	self.weapon_out = undefined;
	self thread unregister_unitrigger_on_kill_think();
	while(1)
	{
		if(!isdefined(self.forced_user))
		{
			self waittill("trigger", User);
			if(User == level)
			{
				continue;
			}
		}
		else
		{
			User = self.forced_user;
		}
		if(User zm_utility::in_revive_trigger())
		{
			wait(0.1);
			continue;
		}
		if(User.IS_DRINKING > 0)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.disabled) && self.disabled)
		{
			wait(0.1);
			continue;
		}
		if(User GetCurrentWeapon() == level.weaponNone)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.being_removed) && self.being_removed)
		{
			wait(0.1);
			continue;
		}
		reduced_cost = undefined;
		if(zm_utility::is_player_valid(User) && User zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			reduced_cost = Int(self.zombie_cost / 2);
		}
		if(isdefined(self.auto_open) && zm_utility::is_player_valid(User))
		{
			if(!isdefined(self.no_charge))
			{
				User zm_score::minus_to_player_score(self.zombie_cost);
				user_cost = self.zombie_cost;
			}
			else
			{
				user_cost = 0;
			}
			self.chest_user = User;
			break;
		}
		else if(zm_utility::is_player_valid(User) && User zm_score::can_player_purchase(self.zombie_cost))
		{
			User zm_score::minus_to_player_score(self.zombie_cost);
			user_cost = self.zombie_cost;
			self.chest_user = User;
			break;
		}
		else if(isdefined(reduced_cost) && User zm_score::can_player_purchase(reduced_cost))
		{
			User zm_score::minus_to_player_score(reduced_cost);
			user_cost = reduced_cost;
			self.chest_user = User;
			break;
		}
		else if(!User zm_score::can_player_purchase(self.zombie_cost))
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			User zm_audio::create_and_play_dialog("general", "outofmoney");
			continue;
		}
		wait(0.05);
	}
	level flag::set("chest_has_been_used");
	demo::bookmark("zm_player_use_magicbox", GetTime(), User);
	User zm_stats::increment_client_stat("use_magicbox");
	User zm_stats::increment_player_stat("use_magicbox");
	User zm_stats::increment_challenge_stat("SURVIVALIST_BUY_MAGIC_BOX");
	User zm_daily_challenges::increment_magic_box();
	if(isdefined(level._magic_box_used_VO))
	{
		User thread [[level._magic_box_used_VO]]();
	}
	self thread watch_for_emp_close();
	self._box_open = 1;
	self._box_opened_by_fire_sale = 0;
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"] && !isdefined(self.auto_open) && self [[level._zombiemode_check_firesale_loc_valid_func]]())
	{
		self._box_opened_by_fire_sale = 1;
	}
	if(isdefined(self.chest_lid))
	{
		self.chest_lid thread treasure_chest_lid_open();
	}
	if(isdefined(self.zbarrier))
	{
		zm_utility::play_sound_at_pos("open_chest", self.origin);
		zm_utility::play_sound_at_pos("music_chest", self.origin);
		self.zbarrier set_magic_box_zbarrier_state("open");
	}
	self.timedOut = 0;
	self.weapon_out = 1;
	self.zbarrier thread treasure_chest_weapon_spawn(self, User);
	if(isdefined(level.custom_treasure_chest_glowfx))
	{
		self.zbarrier thread [[level.custom_treasure_chest_glowfx]]();
	}
	else
	{
		self.zbarrier thread treasure_chest_glowfx();
	}
	thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.zbarrier util::waittill_any("randomization_done", "box_hacked_respin");
	if(level flag::get("moving_chest_now") && !self._box_opened_by_fire_sale && isdefined(user_cost))
	{
		User zm_score::add_to_player_score(user_cost, 0, "magicbox_bear");
	}
	if(level flag::get("moving_chest_now") && !level.zombie_vars["zombie_powerup_fire_sale_on"] && !self._box_opened_by_fire_sale)
	{
		self thread treasure_chest_move(self.chest_user);
	}
	else if(!(isdefined(self.unbearable_respin) && self.unbearable_respin))
	{
		self.grab_weapon_hint = 1;
		self.grab_weapon = self.zbarrier.weapon;
		self.chest_user = User;
		bb::function_91f32a58(User, self, user_cost, self.grab_weapon, 0, "_magicbox", "_offered");
		weaponIdx = undefined;
		if(isdefined(self.grab_weapon))
		{
			weaponIdx = MatchRecordGetWeaponIndex(self.grab_weapon);
		}
		if(isdefined(weaponIdx))
		{
			User RecordMapEvent(10, GetTime(), User.origin, level.round_number, weaponIdx);
		}
		thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);
		if(isdefined(self.zbarrier) && (!isdefined(self.zbarrier.closed_by_emp) && self.zbarrier.closed_by_emp))
		{
			self thread treasure_chest_timeout();
		}
	}
	while(!(isdefined(self.closed_by_emp) && self.closed_by_emp))
	{
		self waittill("trigger", grabber);
		self.weapon_out = undefined;
		if(isdefined(level.magic_box_grab_by_anyone) && level.magic_box_grab_by_anyone)
		{
			if(isPlayer(grabber))
			{
				User = grabber;
			}
		}
		if(isdefined(level.pers_upgrade_box_weapon) && level.pers_upgrade_box_weapon)
		{
			self zm_pers_upgrades_functions::pers_upgrade_box_weapon_used(User, grabber);
		}
		if(isdefined(grabber.IS_DRINKING) && grabber.IS_DRINKING > 0)
		{
			wait(0.1);
			continue;
		}
		if(grabber == User && User GetCurrentWeapon() == level.weaponNone)
		{
			wait(0.1);
			continue;
		}
		if(grabber != level && (isdefined(self.box_rerespun) && self.box_rerespun))
		{
			User = grabber;
		}
		if(grabber == User || grabber == level)
		{
			self.box_rerespun = undefined;
			current_weapon = level.weaponNone;
			if(zm_utility::is_player_valid(User))
			{
				current_weapon = User GetCurrentWeapon();
			}
			if(grabber == User && zm_utility::is_player_valid(User) && !User.IS_DRINKING > 0 && !zm_utility::is_placeable_mine(current_weapon) && !zm_equipment::is_equipment(current_weapon) && !User zm_utility::is_player_revive_tool(current_weapon) && !current_weapon.isHeroWeapon && !current_weapon.isgadget)
			{
				bb::function_91f32a58(User, self, user_cost, self.zbarrier.weapon, 0, "_magicbox", "_grabbed");
				weaponIdx = undefined;
				if(isdefined(self.zbarrier) && isdefined(self.zbarrier.weapon))
				{
					weaponIdx = MatchRecordGetWeaponIndex(self.zbarrier.weapon);
				}
				if(isdefined(weaponIdx))
				{
					User RecordMapEvent(11, GetTime(), User.origin, level.round_number, weaponIdx);
				}
				self notify("user_grabbed_weapon");
				User notify("user_grabbed_weapon");
				User thread treasure_chest_give_weapon(self.zbarrier.weapon);
				demo::bookmark("zm_player_grabbed_magicbox", GetTime(), User);
				User zm_stats::increment_client_stat("grabbed_from_magicbox");
				User zm_stats::increment_player_stat("grabbed_from_magicbox");
				break;
			}
			else if(grabber == level)
			{
				self.timedOut = 1;
				bb::function_91f32a58(User, self, user_cost, self.zbarrier.weapon, 0, "_magicbox", "_returned");
				weaponIdx = undefined;
				if(isdefined(self.zbarrier) && isdefined(self.zbarrier.weapon))
				{
					weaponIdx = MatchRecordGetWeaponIndex(self.zbarrier.weapon);
				}
				if(isdefined(weaponIdx))
				{
					User RecordMapEvent(12, GetTime(), User.origin, level.round_number, weaponIdx);
				}
				break;
			}
		}
		wait(0.05);
	}
	self.grab_weapon_hint = 0;
	self.zbarrier notify("weapon_grabbed");
	if(!(isdefined(self._box_opened_by_fire_sale) && self._box_opened_by_fire_sale))
	{
		level.chest_accessed = level.chest_accessed + 1;
	}
	thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	if(isdefined(self.chest_lid))
	{
		self.chest_lid thread treasure_chest_lid_close(self.timedOut);
	}
	if(isdefined(self.zbarrier))
	{
		self.zbarrier set_magic_box_zbarrier_state("close");
		zm_utility::play_sound_at_pos("close_chest", self.origin);
		self.zbarrier waittill("closed");
		wait(1);
	}
	else
	{
		wait(3);
	}
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[level._zombiemode_check_firesale_loc_valid_func]]() || self == level.chests[level.chest_index])
	{
		thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);
	}
	self._box_open = 0;
	self._box_opened_by_fire_sale = 0;
	self.unbearable_respin = undefined;
	self.chest_user = undefined;
	self notify("chest_accessed");
	self thread treasure_chest_think();
}

/*
	Name: watch_for_emp_close
	Namespace: zm_magicbox
	Checksum: 0x58C22F9B
	Offset: 0x2D20
	Size: 0x185
	Parameters: 0
	Flags: None
*/
function watch_for_emp_close()
{
	self endon("chest_accessed");
	self.closed_by_emp = 0;
	if(!zm_utility::should_watch_for_emp())
	{
		return;
	}
	if(isdefined(self.zbarrier))
	{
		self.zbarrier.closed_by_emp = 0;
	}
	while(1)
	{
		level waittill("emp_detonate", origin, radius);
		if(DistanceSquared(origin, self.origin) < radius * radius)
		{
			break;
		}
	}
	if(level flag::get("moving_chest_now"))
	{
		return;
	}
	self.closed_by_emp = 1;
	if(isdefined(self.zbarrier))
	{
		self.zbarrier.closed_by_emp = 1;
		self.zbarrier notify("box_hacked_respin");
		if(isdefined(self.zbarrier.weapon_model))
		{
			self.zbarrier.weapon_model notify("kill_weapon_movement");
		}
		if(isdefined(self.zbarrier.weapon_model_dw))
		{
			self.zbarrier.weapon_model_dw notify("kill_weapon_movement");
		}
	}
	wait(0.1);
	self notify("trigger", level);
}

/*
	Name: can_buy_weapon
	Namespace: zm_magicbox
	Checksum: 0x46C5BF59
	Offset: 0x2EB0
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function can_buy_weapon()
{
	if(isdefined(self.IS_DRINKING) && self.IS_DRINKING > 0)
	{
		return 0;
	}
	if(self zm_equipment::hacker_active())
	{
		return 0;
	}
	current_weapon = self GetCurrentWeapon();
	if(zm_utility::is_placeable_mine(current_weapon) || zm_equipment::is_equipment_that_blocks_purchase(current_weapon))
	{
		return 0;
	}
	if(self zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(current_weapon == level.weaponNone)
	{
		return 0;
	}
	if(current_weapon.isHeroWeapon || current_weapon.isgadget)
	{
		return 0;
	}
	return 1;
}

/*
	Name: default_box_move_logic
	Namespace: zm_magicbox
	Checksum: 0x26A26B03
	Offset: 0x2FA0
	Size: 0x16F
	Parameters: 0
	Flags: None
*/
function default_box_move_logic()
{
	index = -1;
	for(i = 0; i < level.chests.size; i++)
	{
		if(IsSubStr(level.chests[i].script_noteworthy, "move" + level.chest_moves + 1) && i != level.chest_index)
		{
			index = i;
			break;
		}
	}
	if(index != -1)
	{
		level.chest_index = index;
	}
	else
	{
		level.chest_index++;
	}
	if(level.chest_index >= level.chests.size)
	{
		temp_chest_name = level.chests[level.chest_index - 1].script_noteworthy;
		level.chest_index = 0;
		level.chests = Array::randomize(level.chests);
		if(temp_chest_name == level.chests[level.chest_index].script_noteworthy)
		{
			level.chest_index++;
		}
	}
}

/*
	Name: treasure_chest_move
	Namespace: zm_magicbox
	Checksum: 0xC6A2ED1C
	Offset: 0x3118
	Size: 0x37F
	Parameters: 1
	Flags: None
*/
function treasure_chest_move(player_vox)
{
	level waittill("weapon_fly_away_start");
	players = GetPlayers();
	Array::thread_all(players, &play_crazi_sound);
	if(isdefined(player_vox))
	{
		player_vox util::delay(randomIntRange(2, 7), undefined, &zm_audio::create_and_play_dialog, "general", "box_move");
	}
	level waittill("weapon_fly_away_end");
	if(isdefined(self.zbarrier))
	{
		self hide_chest(1);
	}
	wait(0.1);
	post_selection_wait_duration = 7;
	if(level.zombie_vars["zombie_powerup_fire_sale_on"] == 1 && self [[level._zombiemode_check_firesale_loc_valid_func]]())
	{
		current_sale_time = level.zombie_vars["zombie_powerup_fire_sale_time"];
		util::wait_network_frame();
		self thread fire_sale_fix();
		level.zombie_vars["zombie_powerup_fire_sale_time"] = current_sale_time;
		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}
	}
	else
	{
		post_selection_wait_duration = post_selection_wait_duration + 5;
	}
	level.verify_chest = 0;
	if(isdefined(level._zombiemode_custom_box_move_logic))
	{
		[[level._zombiemode_custom_box_move_logic]]();
	}
	else
	{
		default_box_move_logic();
	}
	if(isdefined(level.chests[level.chest_index].box_hacks["summon_box"]))
	{
		level.chests[level.chest_index] [[level.chests[level.chest_index].box_hacks["summon_box"]]](0);
	}
	wait(post_selection_wait_duration);
	playFX(level._effect["poltergeist"], level.chests[level.chest_index].zbarrier.origin, anglesToUp(level.chests[level.chest_index].zbarrier.angles), AnglesToForward(level.chests[level.chest_index].zbarrier.angles));
	level.chests[level.chest_index] show_chest();
	level flag::clear("moving_chest_now");
	self.zbarrier.chest_moving = 0;
}

/*
	Name: fire_sale_fix
	Namespace: zm_magicbox
	Checksum: 0x4ECC27B
	Offset: 0x34A0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function fire_sale_fix()
{
	if(!isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]))
	{
		return;
	}
	if(level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.old_cost = 950;
		self thread show_chest();
		self.zombie_cost = 10;
		self.unitrigger_stub zm_utility::unitrigger_set_hint_string(self, "default_treasure_chest", self.zombie_cost);
		util::wait_network_frame();
		level waittill("fire_sale_off");
		while(isdefined(self._box_open) && self._box_open)
		{
			wait(0.1);
		}
		self hide_chest(1);
		self.zombie_cost = self.old_cost;
	}
}

/*
	Name: check_for_desirable_chest_location
	Namespace: zm_magicbox
	Checksum: 0xBE42826C
	Offset: 0x35A0
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function check_for_desirable_chest_location()
{
	if(!isdefined(level.desirable_chest_location))
	{
		return level.chest_index;
	}
	if(level.chests[level.chest_index].script_noteworthy == level.desirable_chest_location)
	{
		level.desirable_chest_location = undefined;
		return level.chest_index;
	}
	for(i = 0; i < level.chests.size; i++)
	{
		if(level.chests[i].script_noteworthy == level.desirable_chest_location)
		{
			level.desirable_chest_location = undefined;
			return i;
		}
	}
	/#
		iprintln(level.desirable_chest_location + "Dev Block strings are not supported");
	#/
	level.desirable_chest_location = undefined;
	return level.chest_index;
}

/*
	Name: rotateroll_box
	Namespace: zm_magicbox
	Checksum: 0x90E2EC1B
	Offset: 0x3698
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function rotateroll_box()
{
	angles = 40;
	angles2 = 0;
	while(isdefined(self))
	{
		self RotateRoll(angles + angles2, 0.5);
		wait(0.7);
		angles2 = 40;
		self RotateRoll(angles * -2, 0.5);
		wait(0.7);
	}
}

/*
	Name: verify_chest_is_open
	Namespace: zm_magicbox
	Checksum: 0xA88E682F
	Offset: 0x3738
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function verify_chest_is_open()
{
	for(i = 0; i < level.open_chest_location.size; i++)
	{
		if(isdefined(level.open_chest_location[i]))
		{
			if(level.open_chest_location[i] == level.chests[level.chest_index].script_noteworthy)
			{
				level.verify_chest = 1;
				return;
			}
		}
	}
	level.verify_chest = 0;
}

/*
	Name: treasure_chest_timeout
	Namespace: zm_magicbox
	Checksum: 0x26656A14
	Offset: 0x37D0
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function treasure_chest_timeout()
{
	self endon("user_grabbed_weapon");
	self.zbarrier endon("box_hacked_respin");
	self.zbarrier endon("box_hacked_rerespin");
	wait(12);
	self notify("trigger", level);
}

/*
	Name: treasure_chest_lid_open
	Namespace: zm_magicbox
	Checksum: 0x8FA3814C
	Offset: 0x3820
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function treasure_chest_lid_open()
{
	openRoll = 105;
	openTime = 0.5;
	self RotateRoll(105, openTime, openTime * 0.5);
	zm_utility::play_sound_at_pos("open_chest", self.origin);
	zm_utility::play_sound_at_pos("music_chest", self.origin);
}

/*
	Name: treasure_chest_lid_close
	Namespace: zm_magicbox
	Checksum: 0x6C36411C
	Offset: 0x38C0
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function treasure_chest_lid_close(timedOut)
{
	closeRoll = -105;
	closeTime = 0.5;
	self RotateRoll(closeRoll, closeTime, closeTime * 0.5);
	zm_utility::play_sound_at_pos("close_chest", self.origin);
	self notify("lid_closed");
}

/*
	Name: treasure_chest_CanPlayerReceiveWeapon
	Namespace: zm_magicbox
	Checksum: 0xB2CF9613
	Offset: 0x3958
	Size: 0x19B
	Parameters: 3
	Flags: None
*/
function treasure_chest_CanPlayerReceiveWeapon(player, weapon, pap_triggers)
{
	if(!zm_weapons::get_is_in_box(weapon))
	{
		return 0;
	}
	if(isdefined(player) && player zm_weapons::has_weapon_or_upgrade(weapon))
	{
		return 0;
	}
	if(!zm_weapons::limited_weapon_below_quota(weapon, player, pap_triggers))
	{
		return 0;
	}
	if(!player zm_weapons::player_can_use_content(weapon))
	{
		return 0;
	}
	if(isdefined(level.custom_magic_box_selection_logic))
	{
		if(![[level.custom_magic_box_selection_logic]](weapon, player, pap_triggers))
		{
			return 0;
		}
	}
	if(weapon.name == "ray_gun")
	{
		if(player zm_weapons::has_weapon_or_upgrade(GetWeapon("raygun_mark2")))
		{
			return 0;
		}
	}
	if(weapon.name == "raygun_mark2")
	{
		if(player zm_weapons::has_weapon_or_upgrade(GetWeapon("ray_gun")))
		{
			return 0;
		}
	}
	if(isdefined(player) && isdefined(level.special_weapon_magicbox_check))
	{
		return player [[level.special_weapon_magicbox_check]](weapon);
	}
	return 1;
}

/*
	Name: treasure_chest_ChooseWeightedRandomWeapon
	Namespace: zm_magicbox
	Checksum: 0x6616B999
	Offset: 0x3B00
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function treasure_chest_ChooseWeightedRandomWeapon(player)
{
	keys = Array::randomize(getArrayKeys(level.zombie_weapons));
	if(isdefined(level.CustomRandomWeaponWeights))
	{
		keys = player [[level.CustomRandomWeaponWeights]](keys);
	}
	/#
		var_397dd859 = GetDvarString("Dev Block strings are not supported");
		forced_weapon = GetWeapon(var_397dd859);
		if(var_397dd859 != "Dev Block strings are not supported" && isdefined(level.zombie_weapons[forced_weapon]))
		{
			ArrayInsert(keys, forced_weapon, 0);
		}
	#/
	pap_triggers = zm_pap_util::get_triggers();
	for(i = 0; i < keys.size; i++)
	{
		if(treasure_chest_CanPlayerReceiveWeapon(player, keys[i], pap_triggers))
		{
			return keys[i];
		}
	}
	return keys[0];
}

/*
	Name: weapon_show_hint_choke
	Namespace: zm_magicbox
	Checksum: 0xE98311E6
	Offset: 0x3C78
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function weapon_show_hint_choke()
{
	level._weapon_show_hint_choke = 0;
	while(1)
	{
		wait(0.05);
		level._weapon_show_hint_choke = 0;
	}
}

/*
	Name: decide_hide_show_hint
	Namespace: zm_magicbox
	Checksum: 0x58E3825E
	Offset: 0x3CB0
	Size: 0x367
	Parameters: 4
	Flags: None
*/
function decide_hide_show_hint(endon_notify, second_endon_notify, onlyplayer, can_buy_weapon_extra_check_func)
{
	self endon("death");
	if(isdefined(endon_notify))
	{
		self endon(endon_notify);
	}
	if(isdefined(second_endon_notify))
	{
		self endon(second_endon_notify);
	}
	if(!isdefined(level._weapon_show_hint_choke))
	{
		level thread weapon_show_hint_choke();
	}
	use_choke = 0;
	if(isdefined(level._use_choke_weapon_hints) && level._use_choke_weapon_hints == 1)
	{
		use_choke = 1;
	}
	while(1)
	{
		last_update = GetTime();
		if(isdefined(self.chest_user) && !isdefined(self.box_rerespun))
		{
			if(zm_utility::is_placeable_mine(self.chest_user GetCurrentWeapon()) || self.chest_user zm_equipment::hacker_active())
			{
				self SetInvisibleToPlayer(self.chest_user);
			}
			else
			{
				self SetVisibleToPlayer(self.chest_user);
			}
			break;
		}
		if(isdefined(onlyplayer))
		{
			if(onlyplayer can_buy_weapon() && (!isdefined(can_buy_weapon_extra_check_func) || onlyplayer [[can_buy_weapon_extra_check_func]](self.weapon)) && !onlyplayer bgb::is_enabled("zm_bgb_disorderly_combat"))
			{
				self SetInvisibleToPlayer(onlyplayer, 0);
			}
			else
			{
				self SetInvisibleToPlayer(onlyplayer, 1);
			}
			break;
		}
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] can_buy_weapon() && (!isdefined(can_buy_weapon_extra_check_func) || players[i] [[can_buy_weapon_extra_check_func]](self.weapon)) && !players[i] bgb::is_enabled("zm_bgb_disorderly_combat"))
			{
				self SetInvisibleToPlayer(players[i], 0);
				continue;
			}
			self SetInvisibleToPlayer(players[i], 1);
		}
		if(use_choke)
		{
			while(level._weapon_show_hint_choke > 4 && GetTime() < last_update + 150)
			{
				wait(0.05);
			}
		}
		else
		{
			wait(0.1);
		}
		level._weapon_show_hint_choke++;
	}
}

/*
	Name: get_left_hand_weapon_model_name
	Namespace: zm_magicbox
	Checksum: 0xBEA68F5D
	Offset: 0x4020
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function get_left_hand_weapon_model_name(weapon)
{
	dw_weapon = weapon.dualWieldWeapon;
	if(dw_weapon != level.weaponNone)
	{
		return dw_weapon.worldmodel;
	}
	return weapon.worldmodel;
}

/*
	Name: clean_up_hacked_box
	Namespace: zm_magicbox
	Checksum: 0x5ABD3B85
	Offset: 0x4080
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function clean_up_hacked_box()
{
	self waittill("box_hacked_respin");
	self endon("box_spin_done");
	if(isdefined(self.weapon_model))
	{
		self.weapon_model delete();
		self.weapon_model = undefined;
	}
	if(isdefined(self.weapon_model_dw))
	{
		self.weapon_model_dw delete();
		self.weapon_model_dw = undefined;
	}
	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
}

/*
	Name: treasure_chest_firesale_active
	Namespace: zm_magicbox
	Checksum: 0x572FDD08
	Offset: 0x4178
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function treasure_chest_firesale_active()
{
	return isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"];
}

/*
	Name: treasure_chest_should_move
	Namespace: zm_magicbox
	Checksum: 0xC2F050A9
	Offset: 0x41B0
	Size: 0x261
	Parameters: 2
	Flags: None
*/
function treasure_chest_should_move(Chest, player)
{
	if(GetDvarString("magic_chest_movable") == "1" && (!isdefined(Chest._box_opened_by_fire_sale) && Chest._box_opened_by_fire_sale) && !treasure_chest_firesale_active() && self [[level._zombiemode_check_firesale_loc_valid_func]]())
	{
		random = RandomInt(100);
		if(!isdefined(level.chest_min_move_usage))
		{
			level.chest_min_move_usage = 4;
		}
		if(level.chest_accessed < level.chest_min_move_usage)
		{
			chance_of_joker = -1;
		}
		else
		{
			chance_of_joker = level.chest_accessed + 20;
			if(level.chest_moves == 0 && level.chest_accessed >= 8)
			{
				chance_of_joker = 100;
			}
			if(level.chest_accessed >= 4 && level.chest_accessed < 8)
			{
				if(random < 15)
				{
					chance_of_joker = 100;
				}
				else
				{
					chance_of_joker = -1;
				}
			}
			if(level.chest_moves > 0)
			{
				if(level.chest_accessed >= 8 && level.chest_accessed < 13)
				{
					if(random < 30)
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
				if(level.chest_accessed >= 13)
				{
					if(random < 50)
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
			}
		}
		if(isdefined(Chest.no_fly_away))
		{
			chance_of_joker = -1;
		}
		if(isdefined(level._zombiemode_chest_joker_chance_override_func))
		{
			chance_of_joker = [[level._zombiemode_chest_joker_chance_override_func]](chance_of_joker);
		}
		if(chance_of_joker > random)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: spawn_joker_weapon_model
	Namespace: zm_magicbox
	Checksum: 0x5C7FDA98
	Offset: 0x4420
	Size: 0x87
	Parameters: 4
	Flags: None
*/
function spawn_joker_weapon_model(player, model, origin, angles)
{
	weapon_model = spawn("script_model", origin);
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	weapon_model SetModel(model);
	return weapon_model;
}

/*
	Name: treasure_chest_weapon_locking
	Namespace: zm_magicbox
	Checksum: 0xAD84792A
	Offset: 0x44B0
	Size: 0x113
	Parameters: 3
	Flags: None
*/
function treasure_chest_weapon_locking(player, weapon, onOff)
{
	if(isdefined(self.locked_model))
	{
		self.locked_model delete();
		self.locked_model = undefined;
	}
	if(onOff)
	{
		if(weapon == level.weaponNone)
		{
			self.locked_model = spawn_joker_weapon_model(player, level.chest_joker_model, self.origin, (0, 0, 0));
		}
		else
		{
			self.locked_model = zm_utility::spawn_buildkit_weapon_model(player, weapon, undefined, self.origin, (0, 0, 0));
		}
		self.locked_model ghost();
		self.locked_model clientfield::set("force_stream", 1);
	}
}

/*
	Name: treasure_chest_weapon_spawn
	Namespace: zm_magicbox
	Checksum: 0xDC57B80
	Offset: 0x45D0
	Size: 0xA39
	Parameters: 3
	Flags: None
*/
function treasure_chest_weapon_spawn(Chest, player, respin)
{
	self endon("box_hacked_respin");
	self thread clean_up_hacked_box();
	/#
		Assert(isdefined(player));
	#/
	self.chest_moving = 0;
	move_the_box = treasure_chest_should_move(Chest, player);
	preferred_weapon = undefined;
	if(move_the_box)
	{
		preferred_weapon = level.weaponNone;
	}
	else
	{
		preferred_weapon = treasure_chest_ChooseWeightedRandomWeapon(player);
	}
	Chest treasure_chest_weapon_locking(player, preferred_weapon, 1);
	self.weapon = level.weaponNone;
	modelName = undefined;
	rand = undefined;
	number_cycles = 40;
	if(isdefined(Chest.zbarrier))
	{
		if(isdefined(level.custom_magic_box_do_weapon_rise))
		{
			Chest.zbarrier thread [[level.custom_magic_box_do_weapon_rise]]();
		}
		else
		{
			Chest.zbarrier thread magic_box_do_weapon_rise();
		}
	}
	for(i = 0; i < number_cycles; i++)
	{
		if(i < 20)
		{
			wait(0.05);
			continue;
		}
		if(i < 30)
		{
			wait(0.1);
			continue;
		}
		if(i < 35)
		{
			wait(0.2);
			continue;
		}
		if(i < 38)
		{
			wait(0.3);
		}
	}
	if(isdefined(level.custom_magic_box_weapon_wait))
	{
		[[level.custom_magic_box_weapon_wait]]();
	}
	new_firesale = move_the_box && treasure_chest_firesale_active();
	if(new_firesale)
	{
		move_the_box = 0;
		preferred_weapon = treasure_chest_ChooseWeightedRandomWeapon(player);
	}
	if(!move_the_box && treasure_chest_CanPlayerReceiveWeapon(player, preferred_weapon, zm_pap_util::get_triggers()))
	{
		rand = preferred_weapon;
	}
	else
	{
		rand = treasure_chest_ChooseWeightedRandomWeapon(player);
	}
	self.weapon = rand;
	if(isdefined(level.func_magicbox_weapon_spawned))
	{
		self thread [[level.func_magicbox_weapon_spawned]](self.weapon);
	}
	wait(0.1);
	if(isdefined(level.custom_magicbox_float_height))
	{
		v_float = anglesToUp(self.angles) * level.custom_magicbox_float_height;
	}
	else
	{
		v_float = anglesToUp(self.angles) * 40;
	}
	self.model_dw = undefined;
	self.weapon_model = zm_utility::spawn_buildkit_weapon_model(player, rand, undefined, self.origin + v_float, (self.angles[0] * -1, self.angles[1] + 180, self.angles[2] * -1));
	if(rand.isDualWield)
	{
		dweapon = rand;
		if(isdefined(rand.dualWieldWeapon) && rand.dualWieldWeapon != level.weaponNone)
		{
			dweapon = rand.dualWieldWeapon;
		}
		self.weapon_model_dw = zm_utility::spawn_buildkit_weapon_model(player, dweapon, undefined, self.weapon_model.origin - VectorScale((1, 1, 1), 3), self.weapon_model.angles);
	}
	if(move_the_box && (!level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[level._zombiemode_check_firesale_loc_valid_func]]()))
	{
		self.weapon_model SetModel(level.chest_joker_model);
		if(isdefined(self.weapon_model_dw))
		{
			self.weapon_model_dw delete();
			self.weapon_model_dw = undefined;
		}
		if(isPlayer(Chest.chest_user) && Chest.chest_user bgb::is_enabled("zm_bgb_unbearable"))
		{
			level.chest_accessed = 0;
			Chest.unbearable_respin = 1;
			Chest.chest_user notify("zm_bgb_unbearable", Chest);
			Chest waittill("forever");
		}
		self.chest_moving = 1;
		level flag::set("moving_chest_now");
		level.chest_accessed = 0;
		level.chest_moves++;
	}
	self notify("randomization_done");
	if(isdefined(self.chest_moving) && self.chest_moving)
	{
		if(isdefined(level.chest_joker_custom_movement))
		{
			self [[level.chest_joker_custom_movement]]();
		}
		else
		{
			v_origin = self.weapon_model.origin;
			self.weapon_model delete();
			self.weapon_model = spawn("script_model", v_origin);
			self.weapon_model SetModel(level.chest_joker_model);
			self.weapon_model.angles = self.angles + VectorScale((0, 1, 0), 180);
			wait(0.5);
			level notify("weapon_fly_away_start");
			wait(2);
			if(isdefined(self.weapon_model))
			{
				v_fly_away = self.origin + anglesToUp(self.angles) * 500;
				self.weapon_model moveto(v_fly_away, 4, 3);
			}
			if(isdefined(self.weapon_model_dw))
			{
				v_fly_away = self.origin + anglesToUp(self.angles) * 500;
				self.weapon_model_dw moveto(v_fly_away, 4, 3);
			}
			self.weapon_model waittill("movedone");
			self.weapon_model delete();
			if(isdefined(self.weapon_model_dw))
			{
				self.weapon_model_dw delete();
				self.weapon_model_dw = undefined;
			}
			self notify("box_moving");
			level notify("weapon_fly_away_end");
		}
	}
	else if(!isdefined(respin))
	{
		if(isdefined(Chest.box_hacks["respin"]))
		{
			self [[Chest.box_hacks["respin"]]](Chest, player);
		}
	}
	else if(isdefined(Chest.box_hacks["respin_respin"]))
	{
		self [[Chest.box_hacks["respin_respin"]]](Chest, player);
	}
	if(isdefined(level.custom_magic_box_timer_til_despawn))
	{
		self.weapon_model thread [[level.custom_magic_box_timer_til_despawn]](self);
	}
	else
	{
		self.weapon_model thread timer_til_despawn(v_float);
	}
	if(isdefined(self.weapon_model_dw))
	{
		if(isdefined(level.custom_magic_box_timer_til_despawn))
		{
			self.weapon_model_dw thread [[level.custom_magic_box_timer_til_despawn]](self);
		}
		else
		{
			self.weapon_model_dw thread timer_til_despawn(v_float);
		}
	}
	self waittill("weapon_grabbed");
	if(!Chest.timedOut)
	{
		if(isdefined(self.weapon_model))
		{
			self.weapon_model delete();
		}
		if(isdefined(self.weapon_model_dw))
		{
			self.weapon_model_dw delete();
		}
	}
	Chest treasure_chest_weapon_locking(player, preferred_weapon, 0);
	self.weapon = level.weaponNone;
	self notify("box_spin_done");
}

/*
	Name: chest_get_min_usage
	Namespace: zm_magicbox
	Checksum: 0x6C3E8EC3
	Offset: 0x5018
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function chest_get_min_usage()
{
	min_usage = 4;
	return min_usage;
}

/*
	Name: chest_get_max_usage
	Namespace: zm_magicbox
	Checksum: 0xFF98BCC9
	Offset: 0x5040
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function chest_get_max_usage()
{
	max_usage = 6;
	players = GetPlayers();
	if(level.chest_moves == 0)
	{
		if(players.size == 1)
		{
			max_usage = 3;
		}
		else if(players.size == 2)
		{
			max_usage = 4;
		}
		else if(players.size == 3)
		{
			max_usage = 5;
		}
		else
		{
			max_usage = 6;
		}
	}
	else if(players.size == 1)
	{
		max_usage = 4;
	}
	else if(players.size == 2)
	{
		max_usage = 4;
	}
	else if(players.size == 3)
	{
		max_usage = 5;
	}
	else
	{
		max_usage = 7;
	}
	return max_usage;
}

/*
	Name: timer_til_despawn
	Namespace: zm_magicbox
	Checksum: 0x502942CE
	Offset: 0x5160
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function timer_til_despawn(v_float)
{
	self endon("kill_weapon_movement");
	putBackTime = 12;
	self moveto(self.origin - v_float * 0.85, putBackTime, putBackTime * 0.5);
	wait(putBackTime);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: treasure_chest_glowfx
	Namespace: zm_magicbox
	Checksum: 0x73CD7680
	Offset: 0x51F0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function treasure_chest_glowfx()
{
	self clientfield::set("magicbox_open_glow", 1);
	self clientfield::set("magicbox_closed_glow", 0);
	ret_val = self util::waittill_any_return("weapon_grabbed", "box_moving");
	self clientfield::set("magicbox_open_glow", 0);
	if("box_moving" != ret_val)
	{
		self clientfield::set("magicbox_closed_glow", 1);
	}
}

/*
	Name: treasure_chest_give_weapon
	Namespace: zm_magicbox
	Checksum: 0xA62CFEB7
	Offset: 0x52C0
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function treasure_chest_give_weapon(weapon)
{
	self.last_box_weapon = GetTime();
	if(weapon.name == "ray_gun" || weapon.name == "raygun_mark2")
	{
		playsoundatposition("mus_raygun_stinger", (0, 0, 0));
	}
	if(should_upgrade_weapon(self, weapon))
	{
		if(self zm_weapons::can_upgrade_weapon(weapon))
		{
			weapon = zm_weapons::get_upgrade_weapon(weapon);
			self notify("zm_bgb_crate_power_used");
		}
	}
	if(zm_utility::is_hero_weapon(weapon) && !self HasWeapon(weapon))
	{
		self give_hero_weapon(weapon);
	}
	else
	{
		w_give = self zm_weapons::weapon_give(weapon, 0, 1);
		if(isdefined(weapon))
		{
			self thread AAT::remove(w_give);
		}
	}
}

/*
	Name: give_hero_weapon
	Namespace: zm_magicbox
	Checksum: 0x2606B205
	Offset: 0x5430
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function give_hero_weapon(weapon)
{
	w_previous = self GetCurrentWeapon();
	self zm_weapons::weapon_give(weapon);
	self GadgetPowerSet(0, 99);
	self SwitchToWeapon(weapon);
	self waittill("weapon_change_complete");
	self SetLowReady(1);
	self SwitchToWeapon(w_previous);
	self util::waittill_any_timeout(1, "weapon_change_complete");
	self SetLowReady(0);
	self GadgetPowerSet(0, 100);
}

/*
	Name: should_upgrade_weapon
	Namespace: zm_magicbox
	Checksum: 0x7EB156D3
	Offset: 0x5550
	Size: 0x5D
	Parameters: 2
	Flags: None
*/
function should_upgrade_weapon(player, weapon)
{
	if(isdefined(level.magicbox_should_upgrade_weapon_override))
	{
		return [[level.magicbox_should_upgrade_weapon_override]](player, weapon);
	}
	if(player bgb::is_enabled("zm_bgb_crate_power"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: magic_box_teddy_twitches
	Namespace: zm_magicbox
	Checksum: 0x57FDA026
	Offset: 0x55B8
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function magic_box_teddy_twitches()
{
	self endon("zbarrier_state_change");
	self SetZBarrierPieceState(0, "closed");
	while(1)
	{
		wait(RandomFloatRange(180, 1800));
		self SetZBarrierPieceState(0, "opening");
		wait(RandomFloatRange(180, 1800));
		self SetZBarrierPieceState(0, "closing");
	}
}

/*
	Name: magic_box_initial
	Namespace: zm_magicbox
	Checksum: 0x92B7DD7E
	Offset: 0x5668
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function magic_box_initial()
{
	self SetZBarrierPieceState(1, "open");
	self clientfield::set("magicbox_closed_glow", 1);
}

/*
	Name: magic_box_arrives
	Namespace: zm_magicbox
	Checksum: 0x8D61D350
	Offset: 0x56B8
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function magic_box_arrives()
{
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait(0.05);
	}
	self notify("arrived");
}

/*
	Name: magic_box_leaves
	Namespace: zm_magicbox
	Checksum: 0x8C582CB6
	Offset: 0x5728
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function magic_box_leaves()
{
	self SetZBarrierPieceState(1, "closing");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait(0.1);
	}
	self notify("left");
}

/*
	Name: magic_box_opens
	Namespace: zm_magicbox
	Checksum: 0x33913978
	Offset: 0x5798
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function magic_box_opens()
{
	self SetZBarrierPieceState(2, "opening");
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait(0.1);
	}
	self notify("opened");
}

/*
	Name: magic_box_closes
	Namespace: zm_magicbox
	Checksum: 0xCAA92EA8
	Offset: 0x5808
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function magic_box_closes()
{
	self SetZBarrierPieceState(2, "closing");
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait(0.1);
	}
	self notify("closed");
}

/*
	Name: magic_box_do_weapon_rise
	Namespace: zm_magicbox
	Checksum: 0x901BFA4E
	Offset: 0x5878
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function magic_box_do_weapon_rise()
{
	self endon("box_hacked_respin");
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
	util::wait_network_frame();
	self ZBarrierPieceUseBoxRiseLogic(3);
	self ZBarrierPieceUseBoxRiseLogic(4);
	self ShowZBarrierPiece(3);
	self ShowZBarrierPiece(4);
	self SetZBarrierPieceState(3, "opening");
	self SetZBarrierPieceState(4, "opening");
	while(self GetZBarrierPieceState(3) != "open")
	{
		wait(0.5);
	}
	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
}

/*
	Name: magic_box_do_teddy_flyaway
	Namespace: zm_magicbox
	Checksum: 0xA93DCF1
	Offset: 0x59E0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function magic_box_do_teddy_flyaway()
{
	self ShowZBarrierPiece(3);
	self SetZBarrierPieceState(3, "closing");
}

/*
	Name: is_chest_active
	Namespace: zm_magicbox
	Checksum: 0x1569FC17
	Offset: 0x5A28
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function is_chest_active()
{
	curr_state = self.zbarrier get_magic_box_zbarrier_state();
	if(level flag::get("moving_chest_now"))
	{
		return 0;
	}
	if(curr_state == "open" || curr_state == "close")
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_magic_box_zbarrier_state
	Namespace: zm_magicbox
	Checksum: 0xB6046605
	Offset: 0x5AA8
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_magic_box_zbarrier_state()
{
	return self.State;
}

/*
	Name: set_magic_box_zbarrier_state
	Namespace: zm_magicbox
	Checksum: 0x615F83E1
	Offset: 0x5AC0
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function set_magic_box_zbarrier_state(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	self [[level.magic_box_zbarrier_state_func]](State);
}

/*
	Name: process_magic_box_zbarrier_state
	Namespace: zm_magicbox
	Checksum: 0xA0B17943
	Offset: 0x5B48
	Size: 0x251
	Parameters: 1
	Flags: None
*/
function process_magic_box_zbarrier_state(State)
{
	switch(State)
	{
		case "away":
		{
			self ShowZBarrierPiece(0);
			self thread magic_box_teddy_twitches();
			self.State = "away";
			break;
		}
		case "arriving":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_arrives();
			self.State = "arriving";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_initial();
			thread zm_unitrigger::register_static_unitrigger(self.owner.unitrigger_stub, &magicbox_unitrigger_think);
			self.State = "initial";
			break;
		}
		case "open":
		{
			self ShowZBarrierPiece(2);
			self thread magic_box_opens();
			self.State = "open";
			break;
		}
		case "close":
		{
			self ShowZBarrierPiece(2);
			self thread magic_box_closes();
			self.State = "close";
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_leaves();
			self.State = "leaving";
			break;
		}
		case default:
		{
			if(isdefined(level.custom_magicbox_state_handler))
			{
				self [[level.custom_magicbox_state_handler]](State);
			}
			break;
		}
	}
}

/*
	Name: magicbox_host_migration
	Namespace: zm_magicbox
	Checksum: 0xC8C46AA7
	Offset: 0x5DA8
	Size: 0x14D
	Parameters: 0
	Flags: None
*/
function magicbox_host_migration()
{
	level endon("end_game");
	level notify("mb_hostmigration");
	level endon("mb_hostmigration");
	while(1)
	{
		level waittill("host_migration_end");
		if(!isdefined(level.chests))
		{
			continue;
		}
		foreach(Chest in level.chests)
		{
			if(!(isdefined(Chest.hidden) && Chest.hidden))
			{
				if(isdefined(Chest) && isdefined(Chest.pandora_light))
				{
					PlayFXOnTag(level._effect["lght_marker"], Chest.pandora_light, "tag_origin");
				}
			}
			util::wait_network_frame();
		}
	}
}

/*
	Name: box_encounter_vo
	Namespace: zm_magicbox
	Checksum: 0xCD7C724B
	Offset: 0x5F00
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function box_encounter_vo()
{
	level flag::wait_till("initial_blackscreen_passed");
	self endon("left");
	while(1)
	{
		foreach(player in GetPlayers())
		{
			distanceFromPlayerToBox = Distance(player.origin, self.origin);
			if(distanceFromPlayerToBox < 400 && player zm_utility::is_player_looking_at(self.origin))
			{
				player zm_audio::create_and_play_dialog("box", "encounter");
				return;
			}
		}
		wait(0.5);
	}
}

