#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_perk_quick_revive;

/*
	Name: __init__sytem__
	Namespace: zm_perk_quick_revive
	Checksum: 0x1E116145
	Offset: 0x490
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_quick_revive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_quick_revive
	Checksum: 0x16F0358B
	Offset: 0x4D0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_quick_revive_perk_for_level();
	level.check_quickrevive_hotjoin = &check_quickrevive_for_hotjoin;
}

/*
	Name: enable_quick_revive_perk_for_level
	Namespace: zm_perk_quick_revive
	Checksum: 0x133EEAA5
	Offset: 0x508
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function enable_quick_revive_perk_for_level()
{
	zm_perks::register_perk_basic_info("specialty_quickrevive", "revive", &revive_cost_override, &"ZOMBIE_PERK_QUICKREVIVE", GetWeapon("zombie_perk_bottle_revive"));
	zm_perks::register_perk_precache_func("specialty_quickrevive", &quick_revive_precache);
	zm_perks::register_perk_clientfields("specialty_quickrevive", &quick_revive_register_clientfield, &quick_revive_set_clientfield);
	zm_perks::register_perk_machine("specialty_quickrevive", &quick_revive_perk_machine_setup);
	zm_perks::register_perk_threads("specialty_quickrevive", &give_quick_revive_perk, &take_quick_revive_perk);
	zm_perks::register_perk_host_migration_params("specialty_quickrevive", "vending_revive", "revive_light");
	zm_perks::register_perk_machine_power_override("specialty_quickrevive", &turn_revive_on);
	level flag::init("solo_revive");
}

/*
	Name: quick_revive_precache
	Namespace: zm_perk_quick_revive
	Checksum: 0x6586F077
	Offset: 0x698
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function quick_revive_precache()
{
	if(isdefined(level.quick_revive_precache_override_func))
	{
		[[level.quick_revive_precache_override_func]]();
		return;
	}
	level._effect["revive_light"] = "zombie/fx_perk_quick_revive_zmb";
	level.machine_assets["specialty_quickrevive"] = spawnstruct();
	level.machine_assets["specialty_quickrevive"].weapon = GetWeapon("zombie_perk_bottle_revive");
	level.machine_assets["specialty_quickrevive"].off_model = "p7_zm_vending_revive";
	level.machine_assets["specialty_quickrevive"].on_model = "p7_zm_vending_revive";
}

/*
	Name: quick_revive_register_clientfield
	Namespace: zm_perk_quick_revive
	Checksum: 0x3C04F5EF
	Offset: 0x780
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function quick_revive_register_clientfield()
{
	clientfield::register("clientuimodel", "hudItems.perks.quick_revive", 1, 2, "int");
}

/*
	Name: quick_revive_set_clientfield
	Namespace: zm_perk_quick_revive
	Checksum: 0x48400063
	Offset: 0x7C0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function quick_revive_set_clientfield(State)
{
	self clientfield::set_player_uimodel("hudItems.perks.quick_revive", State);
}

/*
	Name: quick_revive_perk_machine_setup
	Namespace: zm_perk_quick_revive
	Checksum: 0x3E456EB2
	Offset: 0x7F8
	Size: 0xBB
	Parameters: 4
	Flags: None
*/
function quick_revive_perk_machine_setup(use_trigger, perk_machine, bump_trigger, collision)
{
	use_trigger.script_sound = "mus_perks_revive_jingle";
	use_trigger.script_string = "revive_perk";
	use_trigger.script_label = "mus_perks_revive_sting";
	use_trigger.target = "vending_revive";
	perk_machine.script_string = "revive_perk";
	perk_machine.targetname = "vending_revive";
	if(isdefined(bump_trigger))
	{
		bump_trigger.script_string = "revive_perk";
	}
}

/*
	Name: revive_cost_override
	Namespace: zm_perk_quick_revive
	Checksum: 0x8646F89D
	Offset: 0x8C0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function revive_cost_override()
{
	Solo = zm_perks::use_solo_revive();
	if(Solo)
	{
		return 500;
	}
	else
	{
		return 1500;
	}
}

/*
	Name: turn_revive_on
	Namespace: zm_perk_quick_revive
	Checksum: 0x3FF297DB
	Offset: 0x900
	Size: 0x749
	Parameters: 0
	Flags: None
*/
function turn_revive_on()
{
	level endon("stop_quickrevive_logic");
	level flag::wait_till("start_zombie_round_logic");
	solo_mode = 0;
	if(zm_perks::use_solo_revive())
	{
		solo_mode = 1;
	}
	if(solo_mode && (!isdefined(level.solo_revive_init) && level.solo_revive_init))
	{
		level.solo_revive_init = 1;
	}
	while(1)
	{
		machine = GetEntArray("vending_revive", "targetname");
		machine_triggers = GetEntArray("vending_revive", "target");
		for(i = 0; i < machine.size; i++)
		{
			if(level flag::exists("solo_game") && level flag::exists("solo_revive") && level flag::get("solo_game") && level flag::get("solo_revive"))
			{
				machine[i] ghost();
				machine[i] notsolid();
			}
			machine[i] SetModel(level.machine_assets["specialty_quickrevive"].off_model);
			if(isdefined(level.quick_revive_final_pos))
			{
				level.quick_revive_default_origin = level.quick_revive_final_pos;
			}
			if(!isdefined(level.quick_revive_default_origin))
			{
				level.quick_revive_default_origin = machine[i].origin;
				level.quick_revive_default_angles = machine[i].angles;
			}
			level.quick_revive_machine = machine[i];
		}
		Array::thread_all(machine_triggers, &zm_perks::set_power_on, 0);
		if(isdefined(level.initial_quick_revive_power_off) && level.initial_quick_revive_power_off)
		{
			level waittill("revive_on");
		}
		else if(!solo_mode)
		{
			level waittill("revive_on");
		}
		for(i = 0; i < machine.size; i++)
		{
			if(isdefined(machine[i].classname) && machine[i].classname == "script_model")
			{
				if(isdefined(machine[i].script_noteworthy) && machine[i].script_noteworthy == "clip")
				{
					machine_clip = machine[i];
					continue;
				}
				machine[i] SetModel(level.machine_assets["specialty_quickrevive"].on_model);
				machine[i] playsound("zmb_perks_power_on");
				machine[i] vibrate(VectorScale((0, -1, 0), 100), 0.3, 0.4, 3);
				machine_model = machine[i];
				machine[i] thread zm_perks::perk_fx("revive_light");
				exploder::exploder("quick_revive_lgts");
				machine[i] notify("stop_loopsound");
				machine[i] thread zm_perks::play_loop_on_machine();
				if(isdefined(machine_triggers[i]))
				{
					machine_clip = machine_triggers[i].clip;
				}
				if(isdefined(machine_triggers[i]))
				{
					blocker_model = machine_triggers[i].blocker_model;
				}
			}
		}
		util::wait_network_frame();
		if(solo_mode && isdefined(machine_model) && (!isdefined(machine_model.ishidden) && machine_model.ishidden))
		{
			machine_model thread revive_solo_fx(machine_clip, blocker_model);
		}
		Array::thread_all(machine_triggers, &zm_perks::set_power_on, 1);
		if(isdefined(level.machine_assets["specialty_quickrevive"].power_on_callback))
		{
			Array::thread_all(machine, level.machine_assets["specialty_quickrevive"].power_on_callback);
		}
		level notify("specialty_quickrevive_power_on");
		if(isdefined(machine_model))
		{
			machine_model.ishidden = 0;
		}
		notify_str = level util::waittill_any_return("revive_off", "revive_hide", "stop_quickrevive_logic");
		should_hide = 0;
		if(notify_str == "revive_hide")
		{
			should_hide = 1;
		}
		if(isdefined(level.machine_assets["specialty_quickrevive"].power_off_callback))
		{
			Array::thread_all(machine, level.machine_assets["specialty_quickrevive"].power_off_callback);
		}
		for(i = 0; i < machine.size; i++)
		{
			if(isdefined(machine[i].classname) && machine[i].classname == "script_model")
			{
				machine[i] zm_perks::turn_perk_off(should_hide);
			}
		}
	}
}

/*
	Name: reenable_quickrevive
	Namespace: zm_perk_quick_revive
	Checksum: 0x3FE3AD35
	Offset: 0x1058
	Size: 0x663
	Parameters: 2
	Flags: None
*/
function reenable_quickrevive(machine_clip, solo_mode)
{
	if(isdefined(level.revive_machine_spawned) && (!isdefined(level.revive_machine_spawned) && level.revive_machine_spawned))
	{
		return;
	}
	wait(0.1);
	power_state = 0;
	if(isdefined(solo_mode) && solo_mode)
	{
		power_state = 1;
		should_pause = 1;
		players = GetPlayers();
		foreach(player in players)
		{
			if(isdefined(player.lives) && player.lives > 0 && power_state)
			{
				should_pause = 0;
				continue;
			}
			if(isdefined(player.lives) && player.lives < 1)
			{
				should_pause = 1;
			}
		}
		if(should_pause)
		{
			zm_perks::perk_pause("specialty_quickrevive");
		}
		else
		{
			zm_perks::perk_unpause("specialty_quickrevive");
		}
		if(isdefined(level.solo_revive_init) && level.solo_revive_init && level flag::get("solo_revive"))
		{
			disable_quickrevive(machine_clip);
			return;
		}
		update_quickrevive_power_state(1);
		unhide_quickrevive();
		restart_quickrevive();
		level notify("revive_off");
		wait(0.1);
		level notify("stop_quickrevive_logic");
	}
	else if(!(isdefined(level._dont_unhide_quickervive_on_hotjoin) && level._dont_unhide_quickervive_on_hotjoin))
	{
		unhide_quickrevive();
		level notify("revive_off");
		wait(0.1);
	}
	level notify("revive_hide");
	level notify("stop_quickrevive_logic");
	restart_quickrevive();
	triggers = GetEntArray("zombie_vending", "targetname");
	foreach(trigger in triggers)
	{
		if(!isdefined(trigger.script_noteworthy))
		{
			continue;
		}
		if(trigger.script_noteworthy == "specialty_quickrevive")
		{
			if(isdefined(trigger.script_int))
			{
				if(level flag::get("power_on" + trigger.script_int))
				{
					power_state = 1;
				}
				continue;
			}
			if(level flag::get("power_on"))
			{
				power_state = 1;
			}
		}
	}
	update_quickrevive_power_state(power_state);
	level thread turn_revive_on();
	if(power_state)
	{
		zm_perks::perk_unpause("specialty_quickrevive");
		level notify("revive_on");
		wait(0.1);
		level notify("specialty_quickrevive_power_on");
	}
	else
	{
		zm_perks::perk_pause("specialty_quickrevive");
	}
	if(!(isdefined(solo_mode) && solo_mode))
	{
		return;
	}
	should_pause = 1;
	players = GetPlayers();
	foreach(player in players)
	{
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		if(player hasPerk("specialty_quickrevive"))
		{
			if(!isdefined(player.lives))
			{
				player.lives = 0;
			}
			if(!isdefined(level.solo_lives_given))
			{
				level.solo_lives_given = 0;
			}
			level.solo_lives_given++;
			player.lives++;
			if(isdefined(player.lives) && player.lives > 0 && power_state)
			{
				should_pause = 0;
				continue;
			}
			should_pause = 1;
		}
	}
	if(should_pause)
	{
		zm_perks::perk_pause("specialty_quickrevive");
	}
	else
	{
		zm_perks::perk_unpause("specialty_quickrevive");
	}
}

/*
	Name: update_quick_revive
	Namespace: zm_perk_quick_revive
	Checksum: 0x54963E60
	Offset: 0x16C8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function update_quick_revive(solo_mode)
{
	if(!isdefined(solo_mode))
	{
		solo_mode = 0;
	}
	clip = undefined;
	if(isdefined(level.quick_revive_machine_clip))
	{
		clip = level.quick_revive_machine_clip;
	}
	level._custom_perks["specialty_quickrevive"].cost = revive_cost_override();
	level.quick_revive_machine thread reenable_quickrevive(clip, solo_mode);
}

/*
	Name: check_quickrevive_for_hotjoin
	Namespace: zm_perk_quick_revive
	Checksum: 0x3D572EC1
	Offset: 0x1770
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function check_quickrevive_for_hotjoin()
{
	level notify("notify_check_quickrevive_for_hotjoin");
	level endon("notify_check_quickrevive_for_hotjoin");
	solo_mode = 0;
	should_update = 0;
	wait(0.05);
	players = GetPlayers();
	if(players.size == 1 || (isdefined(level.force_solo_quick_revive) && level.force_solo_quick_revive))
	{
		solo_mode = 1;
		if(!level flag::get("solo_game"))
		{
			should_update = 1;
		}
		level flag::set("solo_game");
	}
	else if(level flag::get("solo_game"))
	{
		should_update = 1;
	}
	level flag::clear("solo_game");
	level.using_solo_revive = solo_mode;
	level.revive_machine_is_solo = solo_mode;
	zm::set_default_laststand_pistol(solo_mode);
	if(should_update && isdefined(level.quick_revive_machine))
	{
		update_quick_revive(solo_mode);
	}
}

/*
	Name: revive_solo_fx
	Namespace: zm_perk_quick_revive
	Checksum: 0x61A2B1A8
	Offset: 0x18F8
	Size: 0x389
	Parameters: 2
	Flags: None
*/
function revive_solo_fx(machine_clip, blocker_model)
{
	if(level flag::exists("solo_revive") && level flag::get("solo_revive") && !level flag::get("solo_game"))
	{
		return;
	}
	if(isdefined(machine_clip))
	{
		level.quick_revive_machine_clip = machine_clip;
	}
	level notify("revive_solo_fx");
	level endon("revive_solo_fx");
	self endon("death");
	level flag::wait_till("solo_revive");
	if(isdefined(level.revive_solo_fx_func))
	{
		level thread [[level.revive_solo_fx_func]]();
	}
	wait(2);
	self playsound("zmb_box_move");
	playsoundatposition("zmb_whoosh", self.origin);
	if(isdefined(self._linked_ent))
	{
		self Unlink();
	}
	self moveto(self.origin + VectorScale((0, 0, 1), 40), 3);
	if(isdefined(level.custom_vibrate_func))
	{
		[[level.custom_vibrate_func]](self);
	}
	else
	{
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
		self vibrate(direction, 10, 0.5, 5);
	}
	self waittill("movedone");
	playFX(level._effect["poltergeist"], self.origin);
	playsoundatposition("zmb_box_poof", self.origin);
	if(isdefined(self.FX))
	{
		self.FX Unlink();
		self.FX delete();
	}
	if(isdefined(machine_clip))
	{
		machine_clip Hide();
		machine_clip connectpaths();
	}
	if(isdefined(blocker_model))
	{
		blocker_model show();
	}
	level notify("revive_hide");
}

/*
	Name: disable_quickrevive
	Namespace: zm_perk_quick_revive
	Checksum: 0xF0A8FF9D
	Offset: 0x1C90
	Size: 0x4E9
	Parameters: 1
	Flags: None
*/
function disable_quickrevive(machine_clip)
{
	if(isdefined(level.solo_revive_init) && level.solo_revive_init && level flag::get("solo_revive") && isdefined(level.quick_revive_machine))
	{
		triggers = GetEntArray("zombie_vending", "targetname");
		foreach(trigger in triggers)
		{
			if(!isdefined(trigger.script_noteworthy))
			{
				continue;
			}
			if(trigger.script_noteworthy == "specialty_quickrevive")
			{
				trigger TriggerEnable(0);
			}
		}
		foreach(item in level.powered_items)
		{
			if(isdefined(item.target) && isdefined(item.target.script_noteworthy) && item.target.script_noteworthy == "specialty_quickrevive")
			{
				item.power = 1;
				item.self_powered = 1;
			}
		}
		if(isdefined(level.quick_revive_machine.original_pos))
		{
			level.quick_revive_default_origin = level.quick_revive_machine.original_pos;
			level.quick_revive_default_angles = level.quick_revive_machine.original_angles;
		}
		move_org = level.quick_revive_default_origin;
		if(isdefined(level.quick_revive_linked_ent))
		{
			move_org = level.quick_revive_linked_ent.origin;
			if(isdefined(level.quick_revive_linked_ent_offset))
			{
				move_org = move_org + level.quick_revive_linked_ent_offset;
			}
			level.quick_revive_machine Unlink();
		}
		level.quick_revive_machine moveto(move_org + VectorScale((0, 0, 1), 40), 3);
		direction = level.quick_revive_machine.origin;
		direction = (direction[1], direction[0], 0);
		if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
		{
			direction = (direction[0], direction[1] * -1, 0);
		}
		else if(direction[0] < 0)
		{
			direction = (direction[0] * -1, direction[1], 0);
		}
		level.quick_revive_machine vibrate(direction, 10, 0.5, 4);
		level.quick_revive_machine waittill("movedone");
		level.quick_revive_machine Hide();
		level.quick_revive_machine.ishidden = 1;
		if(isdefined(level.quick_revive_machine_clip))
		{
			level.quick_revive_machine_clip Hide();
			level.quick_revive_machine_clip connectpaths();
		}
		playFX(level._effect["poltergeist"], level.quick_revive_machine.origin);
		if(isdefined(level.quick_revive_trigger) && isdefined(level.quick_revive_trigger.blocker_model))
		{
			level.quick_revive_trigger.blocker_model show();
		}
		level notify("revive_hide");
	}
}

/*
	Name: unhide_quickrevive
	Namespace: zm_perk_quick_revive
	Checksum: 0xF68599E6
	Offset: 0x2188
	Size: 0x417
	Parameters: 0
	Flags: None
*/
function unhide_quickrevive()
{
	while(zm_perks::players_are_in_perk_area(level.quick_revive_machine))
	{
		wait(0.1);
	}
	if(isdefined(level.quick_revive_machine_clip))
	{
		level.quick_revive_machine_clip show();
		level.quick_revive_machine_clip disconnectpaths();
	}
	if(isdefined(level.quick_revive_final_pos))
	{
		level.quick_revive_machine.origin = level.quick_revive_final_pos;
	}
	playFX(level._effect["poltergeist"], level.quick_revive_machine.origin);
	if(isdefined(level.quick_revive_trigger) && isdefined(level.quick_revive_trigger.blocker_model))
	{
		level.quick_revive_trigger.blocker_model Hide();
	}
	level.quick_revive_machine show();
	level.quick_revive_machine solid();
	if(isdefined(level.quick_revive_machine.original_pos))
	{
		level.quick_revive_default_origin = level.quick_revive_machine.original_pos;
		level.quick_revive_default_angles = level.quick_revive_machine.original_angles;
	}
	direction = level.quick_revive_machine.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	org = level.quick_revive_default_origin;
	if(isdefined(level.quick_revive_linked_ent))
	{
		org = level.quick_revive_linked_ent.origin;
		if(isdefined(level.quick_revive_linked_ent_offset))
		{
			org = org + level.quick_revive_linked_ent_offset;
		}
	}
	if(!isdefined(level.quick_revive_linked_ent_moves) && level.quick_revive_linked_ent_moves && level.quick_revive_machine.origin != org)
	{
		level.quick_revive_machine moveto(org, 3);
		level.quick_revive_machine vibrate(direction, 10, 0.5, 2.9);
		level.quick_revive_machine waittill("movedone");
		level.quick_revive_machine.angles = level.quick_revive_default_angles;
	}
	else if(isdefined(level.quick_revive_linked_ent))
	{
		org = level.quick_revive_linked_ent.origin;
		if(isdefined(level.quick_revive_linked_ent_offset))
		{
			org = org + level.quick_revive_linked_ent_offset;
		}
		level.quick_revive_machine.origin = org;
	}
	level.quick_revive_machine vibrate(VectorScale((0, -1, 0), 100), 0.3, 0.4, 3);
	if(isdefined(level.quick_revive_linked_ent))
	{
		level.quick_revive_machine LinkTo(level.quick_revive_linked_ent);
	}
	level.quick_revive_machine.ishidden = 0;
}

/*
	Name: restart_quickrevive
	Namespace: zm_perk_quick_revive
	Checksum: 0x8D9D3190
	Offset: 0x25A8
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function restart_quickrevive()
{
	triggers = GetEntArray("zombie_vending", "targetname");
	foreach(trigger in triggers)
	{
		if(!isdefined(trigger.script_noteworthy))
		{
			continue;
		}
		if(trigger.script_noteworthy == "specialty_quickrevive")
		{
			trigger notify("stop_quickrevive_logic");
			trigger thread zm_perks::vending_trigger_think();
			trigger TriggerEnable(1);
		}
	}
}

/*
	Name: update_quickrevive_power_state
	Namespace: zm_perk_quick_revive
	Checksum: 0x41721125
	Offset: 0x26C8
	Size: 0x1C1
	Parameters: 1
	Flags: None
*/
function update_quickrevive_power_state(poweron)
{
	foreach(item in level.powered_items)
	{
		if(isdefined(item.target) && isdefined(item.target.script_noteworthy) && item.target.script_noteworthy == "specialty_quickrevive")
		{
			if(item.power && !poweron)
			{
				if(!isdefined(item.powered_count))
				{
					item.powered_count = 0;
				}
				else if(item.powered_count > 0)
				{
					item.powered_count--;
				}
			}
			else if(!item.power && poweron)
			{
				if(!isdefined(item.powered_count))
				{
					item.powered_count = 0;
				}
				item.powered_count++;
			}
			if(!isdefined(item.depowered_count))
			{
				item.depowered_count = 0;
			}
			item.power = poweron;
		}
	}
}

/*
	Name: solo_revive_buy_trigger_move
	Namespace: zm_perk_quick_revive
	Checksum: 0x382B9450
	Offset: 0x2898
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function solo_revive_buy_trigger_move(revive_trigger_noteworthy)
{
	self endon("death");
	revive_perk_triggers = GetEntArray(revive_trigger_noteworthy, "script_noteworthy");
	foreach(revive_perk_trigger in revive_perk_triggers)
	{
		self thread solo_revive_buy_trigger_move_trigger(revive_perk_trigger);
	}
}

/*
	Name: solo_revive_buy_trigger_move_trigger
	Namespace: zm_perk_quick_revive
	Checksum: 0x9BCDB899
	Offset: 0x2970
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function solo_revive_buy_trigger_move_trigger(revive_perk_trigger)
{
	self endon("death");
	revive_perk_trigger SetInvisibleToPlayer(self);
	if(level.solo_lives_given >= 3)
	{
		revive_perk_trigger TriggerEnable(0);
		exploder::stop_exploder("quick_revive_lgts");
		if(isdefined(level._solo_revive_machine_expire_func))
		{
			revive_perk_trigger [[level._solo_revive_machine_expire_func]]();
		}
		return;
	}
	while(self.lives > 0)
	{
		wait(0.1);
	}
	revive_perk_trigger SetVisibleToPlayer(self);
}

/*
	Name: give_quick_revive_perk
	Namespace: zm_perk_quick_revive
	Checksum: 0xB9DA72B1
	Offset: 0x2A40
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function give_quick_revive_perk()
{
	if(zm_perks::use_solo_revive())
	{
		self.lives = 1;
		if(!isdefined(level.solo_lives_given))
		{
			level.solo_lives_given = 0;
		}
		if(isdefined(level.solo_game_free_player_quickrevive))
		{
			level.solo_game_free_player_quickrevive = undefined;
		}
		else
		{
			level.solo_lives_given++;
		}
		if(level.solo_lives_given >= 3)
		{
			level flag::set("solo_revive");
		}
		self thread solo_revive_buy_trigger_move("specialty_quickrevive");
	}
}

/*
	Name: take_quick_revive_perk
	Namespace: zm_perk_quick_revive
	Checksum: 0xE7D08E2B
	Offset: 0x2AF8
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function take_quick_revive_perk(b_pause, str_perk, str_result)
{
}

