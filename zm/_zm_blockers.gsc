#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_daily_challenges;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_blockers;

/*
	Name: __init__sytem__
	Namespace: zm_blockers
	Checksum: 0xD7FDD2D3
	Offset: 0xA08
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_blockers", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_blockers
	Checksum: 0xD2FCFDC7
	Offset: 0xA50
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_utility::add_zombie_hint("default_buy_debris", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_COST");
	zm_utility::add_zombie_hint("default_buy_door", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_COST");
	zm_utility::add_zombie_hint("default_buy_door_close", &"ZOMBIE_BUTTON_BUY_CLOSE_DOOR");
	init_blockers();
}

/*
	Name: __main__
	Namespace: zm_blockers
	Checksum: 0x1A41C6DB
	Offset: 0xAD0
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(isdefined(level.quantum_bomb_register_result_func))
	{
		[[level.quantum_bomb_register_result_func]]("open_nearest_door", &quantum_bomb_open_nearest_door_result, 35, &quantum_bomb_open_nearest_door_validation);
	}
}

/*
	Name: init_blockers
	Namespace: zm_blockers
	Checksum: 0xD8B74B61
	Offset: 0xB20
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function init_blockers()
{
	level.exterior_goals = struct::get_array("exterior_goal", "targetname");
	Array::thread_all(level.exterior_goals, &blocker_init);
	zombie_doors = GetEntArray("zombie_door", "targetname");
	if(isdefined(zombie_doors))
	{
		level flag::init("door_can_close");
		Array::thread_all(zombie_doors, &door_init);
	}
	zombie_debris = GetEntArray("zombie_debris", "targetname");
	Array::thread_all(zombie_debris, &debris_init);
	flag_blockers = GetEntArray("flag_blocker", "targetname");
	Array::thread_all(flag_blockers, &flag_blocker);
}

/*
	Name: door_init
	Namespace: zm_blockers
	Checksum: 0xA27CF78
	Offset: 0xC90
	Size: 0x433
	Parameters: 0
	Flags: None
*/
function door_init()
{
	self.type = undefined;
	self.purchaser = undefined;
	self._door_open = 0;
	ent_targets = GetEntArray(self.target, "targetname");
	node_targets = GetNodeArray(self.target, "targetname");
	targets = ArrayCombine(ent_targets, node_targets, 0, 1);
	if(isdefined(self.script_flag) && !isdefined(level.flag[self.script_flag]))
	{
		if(isdefined(self.script_flag))
		{
			tokens = StrTok(self.script_flag, ",");
			for(i = 0; i < tokens.size; i++)
			{
				level flag::init(self.script_flag);
			}
		}
	}
	else if(!isdefined(self.script_noteworthy))
	{
		self.script_noteworthy = "default";
	}
	self.doors = [];
	for(i = 0; i < targets.size; i++)
	{
		targets[i] door_classify(self);
		if(!isdefined(targets[i].og_origin))
		{
			targets[i].og_origin = targets[i].origin;
			targets[i].og_angles = targets[i].angles;
		}
	}
	cost = 1000;
	if(isdefined(self.zombie_cost))
	{
		cost = self.zombie_cost;
	}
	self setcursorhint("HINT_NOICON");
	self thread blocker_update_prompt_visibility();
	self thread door_think();
	if(isdefined(self.script_noteworthy))
	{
		if(self.script_noteworthy == "electric_door" || self.script_noteworthy == "electric_buyable_door")
		{
			if(GetDvarString("ui_gametype") == "zgrief")
			{
				self SetInvisibleToAll();
				return;
			}
			self setHintString(&"ZOMBIE_NEED_POWER");
			if(isdefined(level.door_dialog_function))
			{
				self thread [[level.door_dialog_function]]();
			}
			return;
		}
		else if(self.script_noteworthy == "local_electric_door")
		{
			if(GetDvarString("ui_gametype") == "zgrief")
			{
				self SetInvisibleToAll();
				return;
			}
			self setHintString(&"ZOMBIE_NEED_LOCAL_POWER");
			if(isdefined(level.door_dialog_function))
			{
				self thread [[level.door_dialog_function]]();
			}
			return;
		}
		else if(self.script_noteworthy == "kill_counter_door")
		{
			self setHintString(&"ZOMBIE_DOOR_ACTIVATE_COUNTER", cost);
			return;
		}
	}
	self zm_utility::set_hint_string(self, "default_buy_door", cost);
}

/*
	Name: door_classify
	Namespace: zm_blockers
	Checksum: 0x6AD24CE6
	Offset: 0x10D0
	Size: 0x2B5
	Parameters: 1
	Flags: None
*/
function door_classify(parent_trig)
{
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "air_buy_gate")
	{
		UnlinkTraversal(self);
		parent_trig.doors[parent_trig.doors.size] = self;
		return;
	}
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "clip")
	{
		parent_trig.clip = self;
		parent_trig.script_string = "clip";
		break;
	}
	if(!isdefined(self.script_string))
	{
		if(isdefined(self.script_angles))
		{
			self.script_string = "rotate";
		}
		else if(isdefined(self.script_vector))
		{
			self.script_string = "move";
		}
		break;
	}
	if(!isdefined(self.script_string))
	{
		self.script_string = "";
	}
	switch(self.script_string)
	{
		case "anim":
		{
			/#
				Assert(isdefined(self.script_animname), "Dev Block strings are not supported" + self.targetname);
			#/
			/#
				Assert(isdefined(level.scr_anim[self.script_animname]), "Dev Block strings are not supported" + self.script_animname);
			#/
			/#
				Assert(isdefined(level.blocker_anim_func), "Dev Block strings are not supported");
			#/
			break;
		}
		case "counter_1s":
		{
			parent_trig.counter_1s = self;
			return;
		}
		case "counter_10s":
		{
			parent_trig.counter_10s = self;
			return;
		}
		case "counter_100s":
		{
			parent_trig.counter_100s = self;
			return;
		}
		case "explosives":
		{
			if(!isdefined(parent_trig.explosives))
			{
				parent_trig.explosives = [];
			}
			parent_trig.explosives[parent_trig.explosives.size] = self;
			return;
		}
	}
	if(self.classname == "script_brushmodel")
	{
		self disconnectpaths();
	}
	parent_trig.doors[parent_trig.doors.size] = self;
}

/*
	Name: door_buy
	Namespace: zm_blockers
	Checksum: 0xE0D2AE10
	Offset: 0x1390
	Size: 0x3E7
	Parameters: 0
	Flags: None
*/
function door_buy()
{
	self waittill("trigger", who, force);
	if(isdefined(level.custom_door_buy_check))
	{
		if(!who [[level.custom_door_buy_check]](self))
		{
			return 0;
		}
	}
	if(GetDvarInt("zombie_unlock_all") > 0 || (isdefined(force) && force))
	{
		return 1;
	}
	if(!who useButtonPressed())
	{
		return 0;
	}
	if(who zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(who.IS_DRINKING > 0)
	{
		return 0;
	}
	cost = 0;
	upgraded = 0;
	if(zm_utility::is_player_valid(who))
	{
		players = GetPlayers();
		cost = self.zombie_cost;
		if(who zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			cost = who zm_pers_upgrades_functions::pers_upgrade_double_points_cost(cost);
			upgraded = 1;
		}
		if(self._door_open == 1)
		{
			self.purchaser = undefined;
		}
		else if(who zm_score::can_player_purchase(cost))
		{
			who zm_score::minus_to_player_score(cost);
			scoreevents::processScoreEvent("open_door", who);
			demo::bookmark("zm_player_door", GetTime(), who);
			who zm_stats::increment_client_stat("doors_purchased");
			who zm_stats::increment_player_stat("doors_purchased");
			who zm_stats::increment_challenge_stat("SURVIVALIST_BUY_DOOR");
			self.purchaser = who;
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.doors[0].origin);
			if(isdefined(level.custom_door_deny_vo_func))
			{
				who thread [[level.custom_door_deny_vo_func]]();
			}
			else if(isdefined(level.custom_generic_deny_vo_func))
			{
				who thread [[level.custom_generic_deny_vo_func]](1);
			}
			else
			{
				who zm_audio::create_and_play_dialog("general", "outofmoney");
			}
			return 0;
		}
	}
	if(isdefined(level._door_open_rumble_func))
	{
		who thread [[level._door_open_rumble_func]]();
	}
	who RecordMapEvent(5, GetTime(), who.origin, level.round_number, cost);
	bb::function_91f32a58(who, self, cost, self.target, upgraded, "_door", "_purchase");
	who zm_stats::increment_challenge_stat("ZM_DAILY_PURCHASE_DOORS");
	return 1;
}

/*
	Name: blocker_update_prompt_visibility
	Namespace: zm_blockers
	Checksum: 0x6BA2A4C7
	Offset: 0x1780
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function blocker_update_prompt_visibility()
{
	self endon("kill_door_think");
	self endon("kill_debris_prompt_thread");
	self endon("death");
	dist = 16384;
	while(1)
	{
		players = level.players;
		if(isdefined(players))
		{
			for(i = 0; i < players.size; i++)
			{
				if(DistanceSquared(players[i].origin, self.origin) < dist)
				{
					if(players[i].IS_DRINKING > 0)
					{
						self SetInvisibleToPlayer(players[i], 1);
						continue;
					}
					self SetInvisibleToPlayer(players[i], 0);
				}
			}
		}
		wait(0.25);
	}
}

/*
	Name: door_delay
	Namespace: zm_blockers
	Checksum: 0xA7930561
	Offset: 0x18C0
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function door_delay()
{
	if(isdefined(self.explosives))
	{
		for(i = 0; i < self.explosives.size; i++)
		{
			self.explosives[i] show();
		}
	}
	else if(!isdefined(self.script_int))
	{
		self.script_int = 5;
	}
	all_trigs = GetEntArray(self.target, "target");
	for(i = 0; i < all_trigs.size; i++)
	{
		all_trigs[i] TriggerEnable(0);
	}
	wait(self.script_int);
	for(i = 0; i < self.script_int; i++)
	{
		/#
			iprintln(self.script_int - i);
		#/
		wait(1);
	}
	if(isdefined(self.explosives))
	{
		for(i = 0; i < self.explosives.size; i++)
		{
			playFX(level._effect["def_explosion"], self.explosives[i].origin, AnglesToForward(self.explosives[i].angles));
			self.explosives[i] Hide();
		}
	}
}

/*
	Name: door_activate
	Namespace: zm_blockers
	Checksum: 0x95213B43
	Offset: 0x1AB8
	Size: 0x59B
	Parameters: 4
	Flags: None
*/
function door_activate(time, open, quick, use_blocker_clip_for_pathing)
{
	if(!isdefined(open))
	{
		open = 1;
	}
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "air_buy_gate")
	{
		if(open)
		{
			LinkTraversal(self);
		}
		else
		{
			UnlinkTraversal(self);
		}
		return;
	}
	if(!isdefined(time))
	{
		time = 1;
		if(isdefined(self.script_transition_time))
		{
			time = self.script_transition_time;
		}
	}
	if(isdefined(self.door_moving))
	{
		if(isdefined(self.script_noteworthy) && self.script_noteworthy == "clip" || (isdefined(self.script_string) && self.script_string == "clip"))
		{
			if(!(isdefined(use_blocker_clip_for_pathing) && use_blocker_clip_for_pathing))
			{
				if(!open)
				{
					return;
				}
			}
		}
		else
		{
			return;
		}
	}
	self.door_moving = 1;
	level notify("sndDoorOpening");
	if(open || (!isdefined(quick) && quick))
	{
		self notsolid();
	}
	if(self.classname == "script_brushmodel" || self.classname == "script_model")
	{
		if(open)
		{
			self connectpaths();
		}
	}
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "clip" || (isdefined(self.script_string) && self.script_string == "clip"))
	{
		if(!open)
		{
			self util::delay(time, undefined, &self_disconnectpaths);
			wait(0.1);
			self solid();
		}
		return;
	}
	if(isdefined(self.script_sound))
	{
		if(open)
		{
			playsoundatposition(self.script_sound, self.origin);
		}
		else
		{
			playsoundatposition(self.script_sound + "_close", self.origin);
		}
	}
	else
	{
		zm_utility::play_sound_at_pos("zmb_heavy_door_open", self.origin);
	}
	scale = 1;
	if(!open)
	{
		scale = -1;
	}
	switch(self.script_string)
	{
		case "rotate":
		{
			if(isdefined(self.script_angles))
			{
				rot_angle = self.script_angles;
				if(!open)
				{
					rot_angle = self.og_angles;
				}
				self RotateTo(rot_angle, time, 0, 0);
				self thread door_solid_thread();
				if(!open)
				{
					self thread disconnect_paths_when_done();
				}
			}
			wait(RandomFloat(0.15));
			break;
		}
		case "move":
		case "slide_apart":
		{
			if(isdefined(self.script_vector))
			{
				vector = VectorScale(self.script_vector, scale);
				if(time >= 0.5)
				{
					self moveto(self.origin + vector, time, time * 0.25, time * 0.25);
				}
				else
				{
					self moveto(self.origin + vector, time);
				}
				self thread door_solid_thread();
				if(!open)
				{
					self thread disconnect_paths_when_done();
				}
			}
			wait(RandomFloat(0.15));
			break;
		}
		case "anim":
		{
			self [[level.blocker_anim_func]](self.script_animname);
			self thread door_solid_thread_anim();
			wait(RandomFloat(0.15));
			break;
		}
		case "physics":
		{
			self thread physics_launch_door(self);
			wait(0.1);
			break;
		}
		case "zbarrier":
		{
			self thread door_zbarrier_move();
			break;
		}
	}
	if(isdefined(self.script_firefx))
	{
		playFX(level._effect[self.script_firefx], self.origin);
	}
}

/*
	Name: kill_trapped_zombies
	Namespace: zm_blockers
	Checksum: 0x76F97894
	Offset: 0x2060
	Size: 0x155
	Parameters: 1
	Flags: None
*/
function kill_trapped_zombies(trigger)
{
	zombies = GetAITeamArray(level.zombie_team);
	if(!isdefined(zombies))
	{
		return;
	}
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]))
		{
			continue;
		}
		if(zombies[i] istouching(trigger))
		{
			zombies[i].marked_for_recycle = 1;
			zombies[i] DoDamage(zombies[i].health + 666, trigger.origin, self);
			wait(RandomFloat(0.15));
			continue;
		}
		if(isdefined(level.custom_trapped_zombies))
		{
			zombies[i] thread [[level.custom_trapped_zombies]]();
			wait(RandomFloat(0.15));
		}
	}
}

/*
	Name: any_player_touching
	Namespace: zm_blockers
	Checksum: 0x45679D15
	Offset: 0x21C0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function any_player_touching(trigger)
{
	foreach(player in GetPlayers())
	{
		if(player istouching(trigger))
		{
			return 1;
		}
		wait(0.01);
	}
	return 0;
}

/*
	Name: any_player_touching_any
	Namespace: zm_blockers
	Checksum: 0x79B60412
	Offset: 0x2280
	Size: 0x191
	Parameters: 2
	Flags: None
*/
function any_player_touching_any(trigger, more_triggers)
{
	foreach(player in GetPlayers())
	{
		if(zm_utility::is_player_valid(player, 0, 1))
		{
			if(isdefined(trigger) && player istouching(trigger))
			{
				return 1;
			}
			if(isdefined(more_triggers) && more_triggers.size > 0)
			{
				foreach(trig in more_triggers)
				{
					if(isdefined(trig) && player istouching(trig))
					{
						return 1;
					}
				}
			}
		}
	}
	return 0;
}

/*
	Name: any_zombie_touching_any
	Namespace: zm_blockers
	Checksum: 0xE1EF82AB
	Offset: 0x2420
	Size: 0x189
	Parameters: 2
	Flags: None
*/
function any_zombie_touching_any(trigger, more_triggers)
{
	zombies = GetAITeamArray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(isdefined(trigger) && zombie istouching(trigger))
		{
			return 1;
		}
		if(isdefined(more_triggers) && more_triggers.size > 0)
		{
			foreach(trig in more_triggers)
			{
				if(isdefined(trig) && zombie istouching(trig))
				{
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: wait_trigger_clear
	Namespace: zm_blockers
	Checksum: 0xB2BA2388
	Offset: 0x25B8
	Size: 0x91
	Parameters: 3
	Flags: None
*/
function wait_trigger_clear(trigger, more_triggers, end_on)
{
	self endon(end_on);
	while(any_player_touching_any(trigger, more_triggers) || any_zombie_touching_any(trigger, more_triggers))
	{
		wait(1);
	}
	/#
		println("Dev Block strings are not supported");
	#/
	self notify("trigger_clear");
}

/*
	Name: waittill_door_trigger_clear_local_power_off
	Namespace: zm_blockers
	Checksum: 0xE8BE0C79
	Offset: 0x2658
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function waittill_door_trigger_clear_local_power_off(trigger, all_trigs)
{
	self endon("trigger_clear");
	while(1)
	{
		if(isdefined(self.local_power_on) && self.local_power_on)
		{
			self waittill("local_power_off");
		}
		/#
			println("Dev Block strings are not supported");
		#/
		self wait_trigger_clear(trigger, all_trigs, "local_power_on");
	}
}

/*
	Name: waittill_door_trigger_clear_global_power_off
	Namespace: zm_blockers
	Checksum: 0xC89A3D75
	Offset: 0x26F8
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function waittill_door_trigger_clear_global_power_off(trigger, all_trigs)
{
	self endon("trigger_clear");
	while(1)
	{
		if(isdefined(self.power_on) && self.power_on)
		{
			self waittill("power_off");
		}
		/#
			println("Dev Block strings are not supported");
		#/
		self wait_trigger_clear(trigger, all_trigs, "power_on");
	}
}

/*
	Name: waittill_door_can_close
	Namespace: zm_blockers
	Checksum: 0x696E1D2E
	Offset: 0x2798
	Size: 0x185
	Parameters: 0
	Flags: None
*/
function waittill_door_can_close()
{
	trigger = undefined;
	if(isdefined(self.door_hold_trigger))
	{
		trigger = GetEnt(self.door_hold_trigger, "targetname");
	}
	all_trigs = GetEntArray(self.target, "target");
	switch(self.script_noteworthy)
	{
		case "local_electric_door":
		{
			if(isdefined(trigger) || isdefined(all_trigs))
			{
				self waittill_door_trigger_clear_local_power_off(trigger, all_trigs);
				self thread kill_trapped_zombies(trigger);
			}
			else if(isdefined(self.local_power_on) && self.local_power_on)
			{
				self waittill("local_power_off");
			}
			return;
		}
		case "electric_door":
		{
			if(isdefined(trigger) || isdefined(all_trigs))
			{
				self waittill_door_trigger_clear_global_power_off(trigger, all_trigs);
				if(isdefined(trigger))
				{
					self thread kill_trapped_zombies(trigger);
				}
			}
			else if(isdefined(self.power_on) && self.power_on)
			{
				self waittill("power_off");
			}
			return;
		}
	}
}

/*
	Name: door_think
	Namespace: zm_blockers
	Checksum: 0x87119AA0
	Offset: 0x2928
	Size: 0x4B5
	Parameters: 0
	Flags: None
*/
function door_think()
{
	self endon("kill_door_think");
	cost = 1000;
	if(isdefined(self.zombie_cost))
	{
		cost = self.zombie_cost;
	}
	self SetHintLowPriority(1);
	while(1)
	{
		switch(self.script_noteworthy)
		{
			case "local_electric_door":
			{
				if(!(isdefined(self.local_power_on) && self.local_power_on))
				{
					self waittill("local_power_on");
				}
				if(!(isdefined(self._door_open) && self._door_open))
				{
					/#
						println("Dev Block strings are not supported");
					#/
					self door_opened(cost, 1);
					if(!isdefined(self.power_cost))
					{
						self.power_cost = 0;
					}
					self.power_cost = self.power_cost + 200;
				}
				self setHintString("");
				if(isdefined(level.local_doors_stay_open) && level.local_doors_stay_open)
				{
					return;
				}
				wait(3);
				self waittill_door_can_close();
				self door_block();
				if(isdefined(self._door_open) && self._door_open)
				{
					/#
						println("Dev Block strings are not supported");
					#/
					self door_opened(cost, 1);
				}
				self setHintString(&"ZOMBIE_NEED_LOCAL_POWER");
				wait(3);
				continue;
			}
			case "electric_door":
			{
				if(!(isdefined(self.power_on) && self.power_on))
				{
					self waittill("power_on");
				}
				if(!(isdefined(self._door_open) && self._door_open))
				{
					/#
						println("Dev Block strings are not supported");
					#/
					self door_opened(cost, 1);
					if(!isdefined(self.power_cost))
					{
						self.power_cost = 0;
					}
					self.power_cost = self.power_cost + 200;
				}
				self setHintString("");
				if(isdefined(level.local_doors_stay_open) && level.local_doors_stay_open)
				{
					return;
				}
				wait(3);
				self waittill_door_can_close();
				self door_block();
				if(isdefined(self._door_open) && self._door_open)
				{
					/#
						println("Dev Block strings are not supported");
					#/
					self door_opened(cost, 1);
				}
				self setHintString(&"ZOMBIE_NEED_POWER");
				wait(3);
				continue;
			}
			case "electric_buyable_door":
			{
				if(!(isdefined(self.power_on) && self.power_on))
				{
					self waittill("power_on");
				}
				self zm_utility::set_hint_string(self, "default_buy_door", cost);
				if(!self door_buy())
				{
					continue;
				}
				break;
			}
			case "delay_door":
			{
				if(!self door_buy())
				{
					continue;
				}
				self door_delay();
				break;
			}
			case default:
			{
				if(isdefined(level._default_door_custom_logic))
				{
					self [[level._default_door_custom_logic]]();
					break;
				}
				if(!self door_buy())
				{
					continue;
				}
				break;
			}
		}
		self door_opened(cost);
		if(!level flag::get("door_can_close"))
		{
			break;
		}
	}
}

/*
	Name: self_and_flag_wait
	Namespace: zm_blockers
	Checksum: 0x6FDBF3FB
	Offset: 0x2DE8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function self_and_flag_wait(msg)
{
	self endon(msg);
	if(isdefined(self.power_door_ignore_flag_wait) && self.power_door_ignore_flag_wait)
	{
		level waittill("forever");
	}
	else
	{
		level flag::wait_till(msg);
	}
}

/*
	Name: door_block
	Namespace: zm_blockers
	Checksum: 0xF066EAF7
	Offset: 0x2E48
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function door_block()
{
	if(isdefined(self.doors))
	{
		for(i = 0; i < self.doors.size; i++)
		{
			if(isdefined(self.doors[i].script_noteworthy) && self.doors[i].script_noteworthy == "clip" || (isdefined(self.doors[i].script_string) && self.doors[i].script_string == "clip"))
			{
				self.doors[i] solid();
			}
		}
	}
}

/*
	Name: door_opened
	Namespace: zm_blockers
	Checksum: 0x398BD78B
	Offset: 0x2F30
	Size: 0x75D
	Parameters: 2
	Flags: None
*/
function door_opened(cost, quick_close)
{
	if(isdefined(self.door_is_moving) && self.door_is_moving)
	{
		return;
	}
	self.has_been_opened = 1;
	all_trigs = GetEntArray(self.target, "target");
	self.door_is_moving = 1;
	foreach(trig in all_trigs)
	{
		trig.door_is_moving = 1;
		trig TriggerEnable(0);
		trig.has_been_opened = 1;
		if(!isdefined(trig._door_open) || trig._door_open == 0)
		{
			trig._door_open = 1;
			trig notify("door_opened");
		}
		else
		{
			trig._door_open = 0;
		}
		if(isdefined(trig.script_flag) && trig._door_open == 1)
		{
			tokens = StrTok(trig.script_flag, ",");
			for(i = 0; i < tokens.size; i++)
			{
				level flag::set(tokens[i]);
			}
			break;
		}
		if(isdefined(trig.script_flag) && trig._door_open == 0)
		{
			tokens = StrTok(trig.script_flag, ",");
			for(i = 0; i < tokens.size; i++)
			{
				level flag::clear(tokens[i]);
			}
		}
		else if(isdefined(quick_close) && quick_close)
		{
			trig zm_utility::set_hint_string(trig, "");
			continue;
		}
		if(trig._door_open == 1 && level flag::get("door_can_close"))
		{
			trig zm_utility::set_hint_string(trig, "default_buy_door_close");
			continue;
		}
		if(trig._door_open == 0)
		{
			trig zm_utility::set_hint_string(trig, "default_buy_door", cost);
		}
	}
	level notify("door_opened");
	if(isdefined(self.doors))
	{
		is_script_model_door = 0;
		have_moving_clip_for_door = 0;
		use_blocker_clip_for_pathing = 0;
		foreach(door in self.doors)
		{
			if(isdefined(door.ignore_use_blocker_clip_for_pathing_check) && door.ignore_use_blocker_clip_for_pathing_check)
			{
				continue;
			}
			if(isdefined(door.script_noteworthy) && door.script_noteworthy == "air_buy_gate")
			{
				continue;
			}
			if(door.classname == "script_model")
			{
				is_script_model_door = 1;
				continue;
			}
			if(door.classname == "script_brushmodel" && (!isdefined(door.script_noteworthy) || door.script_noteworthy != "clip") && (!isdefined(door.script_string) || door.script_string != "clip"))
			{
				have_moving_clip_for_door = 1;
			}
		}
		use_blocker_clip_for_pathing = is_script_model_door && !have_moving_clip_for_door;
		for(i = 0; i < self.doors.size; i++)
		{
			self.doors[i] thread door_activate(self.doors[i].script_transition_time, self._door_open, quick_close, use_blocker_clip_for_pathing);
		}
		if(self.doors.size)
		{
			zm_utility::play_sound_at_pos("purchase", self.origin);
		}
	}
	level.active_zone_names = zm_zonemgr::get_active_zone_names();
	wait(1);
	self.door_is_moving = 0;
	foreach(trig in all_trigs)
	{
		trig.door_is_moving = 0;
	}
	if(isdefined(quick_close) && quick_close)
	{
		for(i = 0; i < all_trigs.size; i++)
		{
			all_trigs[i] TriggerEnable(1);
		}
		return;
	}
	if(level flag::get("door_can_close"))
	{
		wait(2);
		for(i = 0; i < all_trigs.size; i++)
		{
			all_trigs[i] TriggerEnable(1);
		}
	}
}

/*
	Name: physics_launch_door
	Namespace: zm_blockers
	Checksum: 0xDE11CE2
	Offset: 0x3698
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function physics_launch_door(door_trig)
{
	vec = VectorScale(VectorNormalize(self.script_vector), 10);
	self RotateRoll(5, 0.05);
	wait(0.05);
	self moveto(self.origin + vec, 0.1);
	self waittill("movedone");
	self PhysicsLaunch(self.origin, self.script_vector * 300);
	wait(60);
	self delete();
}

/*
	Name: door_solid_thread
	Namespace: zm_blockers
	Checksum: 0x6D57AA36
	Offset: 0x3780
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function door_solid_thread()
{
	self util::waittill_either("rotatedone", "movedone");
	self.door_moving = undefined;
	while(1)
	{
		players = GetPlayers();
		player_touching = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i] istouching(self))
			{
				player_touching = 1;
				break;
			}
		}
		if(!player_touching)
		{
			self solid();
			return;
		}
		wait(1);
	}
}

/*
	Name: door_solid_thread_anim
	Namespace: zm_blockers
	Checksum: 0x7FC7E268
	Offset: 0x3878
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function door_solid_thread_anim()
{
	self waittillmatch("hash_27e6c447");
	self.door_moving = undefined;
	while(1)
	{
		players = GetPlayers();
		player_touching = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i] istouching(self))
			{
				player_touching = 1;
				break;
			}
		}
		if(!player_touching)
		{
			self solid();
			return;
		}
		wait(1);
	}
}

/*
	Name: disconnect_paths_when_done
	Namespace: zm_blockers
	Checksum: 0xBDAA4C72
	Offset: 0x3958
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function disconnect_paths_when_done()
{
	self util::waittill_either("rotatedone", "movedone");
	self disconnectpaths();
}

/*
	Name: self_disconnectpaths
	Namespace: zm_blockers
	Checksum: 0xA72FBA7B
	Offset: 0x39A8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function self_disconnectpaths()
{
	self disconnectpaths();
}

/*
	Name: debris_init
	Namespace: zm_blockers
	Checksum: 0x3B25E710
	Offset: 0x39D0
	Size: 0x2DB
	Parameters: 0
	Flags: None
*/
function debris_init()
{
	cost = 1000;
	if(isdefined(self.zombie_cost))
	{
		cost = self.zombie_cost;
	}
	self zm_utility::set_hint_string(self, "default_buy_debris", cost);
	self setcursorhint("HINT_NOICON");
	if(isdefined(self.script_flag) && !isdefined(level.flag[self.script_flag]))
	{
		level flag::init(self.script_flag);
	}
	if(isdefined(self.target))
	{
		targets = GetEntArray(self.target, "targetname");
		foreach(target in targets)
		{
			if(target IsZBarrier())
			{
				for(i = 0; i < target GetNumZBarrierPieces(); i++)
				{
					target SetZBarrierPieceState(i, "closed");
				}
			}
		}
		a_nd_targets = GetNodeArray(self.target, "targetname");
		foreach(nd_target in a_nd_targets)
		{
			if(isdefined(nd_target.script_noteworthy) && nd_target.script_noteworthy == "air_buy_gate")
			{
				UnlinkTraversal(nd_target);
			}
		}
	}
	self thread blocker_update_prompt_visibility();
	self thread debris_think();
}

/*
	Name: debris_think
	Namespace: zm_blockers
	Checksum: 0x851E8E17
	Offset: 0x3CB8
	Size: 0x80D
	Parameters: 0
	Flags: None
*/
function debris_think()
{
	if(isdefined(level.custom_debris_function))
	{
		self [[level.custom_debris_function]]();
	}
	junk = GetEntArray(self.target, "targetname");
	for(i = 0; i < junk.size; i++)
	{
		if(isdefined(junk[i].script_noteworthy))
		{
			if(junk[i].script_noteworthy == "clip")
			{
				junk[i] disconnectpaths();
			}
		}
	}
	while(1)
	{
		self waittill("trigger", who, force);
		if(GetDvarInt("zombie_unlock_all") > 0 || (isdefined(force) && force))
		{
		}
		else if(!who useButtonPressed())
		{
			break;
		}
		if(who.IS_DRINKING > 0)
		{
			break;
		}
		if(who zm_utility::in_revive_trigger())
		{
			break;
		}
		if(zm_utility::is_player_valid(who))
		{
			players = GetPlayers();
			if(GetDvarInt("zombie_unlock_all") > 0)
			{
			}
			else if(who zm_score::can_player_purchase(self.zombie_cost))
			{
				who zm_score::minus_to_player_score(self.zombie_cost);
				scoreevents::processScoreEvent("open_door", who);
				demo::bookmark("zm_player_door", GetTime(), who);
				who zm_stats::increment_client_stat("doors_purchased");
				who zm_stats::increment_player_stat("doors_purchased");
				who zm_stats::increment_challenge_stat("SURVIVALIST_BUY_DOOR");
			}
			else
			{
				zm_utility::play_sound_at_pos("no_purchase", self.origin);
				who zm_audio::create_and_play_dialog("general", "outofmoney");
				break;
			}
			self notify("kill_debris_prompt_thread");
			junk = GetEntArray(self.target, "targetname");
			if(isdefined(self.script_flag))
			{
				tokens = StrTok(self.script_flag, ",");
				for(i = 0; i < tokens.size; i++)
				{
					level flag::set(tokens[i]);
				}
			}
			zm_utility::play_sound_at_pos("purchase", self.origin);
			level notify("junk purchased");
			move_ent = undefined;
			a_clip = [];
			for(i = 0; i < junk.size; i++)
			{
				junk[i] connectpaths();
				if(isdefined(junk[i].script_noteworthy))
				{
					if(junk[i].script_noteworthy == "clip")
					{
						a_clip[a_clip.size] = junk[i];
						continue;
					}
				}
				struct = undefined;
				if(junk[i] IsZBarrier())
				{
					move_ent = junk[i];
					junk[i] thread debris_zbarrier_move();
					continue;
				}
				if(isdefined(junk[i].script_linkto))
				{
					struct = struct::get(junk[i].script_linkto, "script_linkname");
					if(isdefined(struct))
					{
						move_ent = junk[i];
						junk[i] thread debris_move(struct);
					}
					else
					{
						junk[i] delete();
					}
					continue;
				}
				if(isdefined(junk[i].target))
				{
					struct = struct::get(junk[i].target, "targetname");
					if(isdefined(struct))
					{
						move_ent = junk[i];
						junk[i] thread debris_move(struct);
					}
					else
					{
						junk[i] delete();
					}
					continue;
				}
				junk[i] delete();
			}
			a_nd_targets = GetNodeArray(self.target, "targetname");
			foreach(nd_target in a_nd_targets)
			{
				if(isdefined(nd_target.script_noteworthy) && nd_target.script_noteworthy == "air_buy_gate")
				{
					LinkTraversal(nd_target);
				}
			}
			all_trigs = GetEntArray(self.target, "target");
			for(i = 0; i < all_trigs.size; i++)
			{
				all_trigs[i] delete();
			}
			for(i = 0; i < a_clip.size; i++)
			{
				a_clip[i] delete();
			}
			if(isdefined(move_ent))
			{
				move_ent waittill("movedone");
			}
			break;
		}
	}
}

/*
	Name: debris_zbarrier_move
	Namespace: zm_blockers
	Checksum: 0xC3054619
	Offset: 0x44D0
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function debris_zbarrier_move()
{
	playsoundatposition("zmb_lightning_l", self.origin);
	playFX(level._effect["poltergeist"], self.origin);
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self thread move_chunk(i, 1);
	}
}

/*
	Name: door_zbarrier_move
	Namespace: zm_blockers
	Checksum: 0x7314B695
	Offset: 0x4580
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function door_zbarrier_move()
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self thread move_chunk(i, 0);
	}
}

/*
	Name: move_chunk
	Namespace: zm_blockers
	Checksum: 0x11261679
	Offset: 0x45E0
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function move_chunk(index, b_hide)
{
	self SetZBarrierPieceState(index, "opening");
	while(self GetZBarrierPieceState(index) == "opening")
	{
		wait(0.1);
	}
	self notify("movedone");
	if(b_hide)
	{
		self HideZBarrierPiece(index);
	}
}

/*
	Name: debris_move
	Namespace: zm_blockers
	Checksum: 0x2CC9DD33
	Offset: 0x4680
	Size: 0x2F3
	Parameters: 1
	Flags: None
*/
function debris_move(struct)
{
	self util::script_delay();
	self notsolid();
	self zm_utility::play_sound_on_ent("debris_move");
	playsoundatposition("zmb_lightning_l", self.origin);
	if(isdefined(self.script_firefx))
	{
		playFX(level._effect[self.script_firefx], self.origin);
	}
	if(isdefined(self.script_noteworthy))
	{
		if(self.script_noteworthy == "jiggle")
		{
			num = randomIntRange(3, 5);
			og_angles = self.angles;
			for(i = 0; i < num; i++)
			{
				angles = og_angles + (-5 + RandomFloat(10), -5 + RandomFloat(10), -5 + RandomFloat(10));
				time = RandomFloatRange(0.1, 0.4);
				self RotateTo(angles, time);
				wait(time - 0.05);
			}
		}
	}
	time = 0.5;
	if(isdefined(self.script_transition_time))
	{
		time = self.script_transition_time;
	}
	self moveto(struct.origin, time, time * 0.5);
	self RotateTo(struct.angles, time * 0.75);
	self waittill("movedone");
	if(isdefined(self.script_fxid))
	{
		playFX(level._effect[self.script_fxid], self.origin);
		playsoundatposition("zmb_zombie_spawn", self.origin);
	}
	self delete();
}

/*
	Name: blocker_disconnect_paths
	Namespace: zm_blockers
	Checksum: 0x8D9DA19
	Offset: 0x4980
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function blocker_disconnect_paths(start_node, end_node, two_way)
{
}

/*
	Name: blocker_connect_paths
	Namespace: zm_blockers
	Checksum: 0x7045C17A
	Offset: 0x49A8
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function blocker_connect_paths(start_node, end_node, two_way)
{
}

/*
	Name: blocker_init
	Namespace: zm_blockers
	Checksum: 0xA1169536
	Offset: 0x49D0
	Size: 0x87B
	Parameters: 0
	Flags: None
*/
function blocker_init()
{
	if(!isdefined(self.target))
	{
		return;
	}
	pos = zm_utility::GROUNDPOS(self.origin) + VectorScale((0, 0, 1), 8);
	if(isdefined(pos))
	{
		self.origin = pos;
	}
	targets = GetEntArray(self.target, "targetname");
	self.barrier_chunks = [];
	for(j = 0; j < targets.size; j++)
	{
		if(targets[j] IsZBarrier())
		{
			if(isdefined(level.zbarrier_override))
			{
				self thread [[level.zbarrier_override]](targets[j]);
				continue;
			}
			self.zbarrier = targets[j];
			self.zbarrier.chunk_health = [];
			for(i = 0; i < self.zbarrier GetNumZBarrierPieces(); i++)
			{
				self.zbarrier.chunk_health[i] = 0;
			}
			continue;
		}
		if(isdefined(targets[j].script_string) && targets[j].script_string == "rock")
		{
			targets[j].material = "rock";
		}
		if(isdefined(targets[j].script_parameters))
		{
			if(targets[j].script_parameters == "grate")
			{
				if(isdefined(targets[j].script_noteworthy))
				{
					if(targets[j].script_noteworthy == "2" || targets[j].script_noteworthy == "3" || targets[j].script_noteworthy == "4" || targets[j].script_noteworthy == "5" || targets[j].script_noteworthy == "6")
					{
						targets[j] Hide();
						/#
							IPrintLnBold("Dev Block strings are not supported");
						#/
					}
				}
			}
			else if(targets[j].script_parameters == "repair_board")
			{
				targets[j].unbroken_section = GetEnt(targets[j].target, "targetname");
				if(isdefined(targets[j].unbroken_section))
				{
					targets[j].unbroken_section LinkTo(targets[j]);
					targets[j] Hide();
					targets[j] notsolid();
					targets[j].unbroken = 1;
					if(isdefined(targets[j].unbroken_section.script_noteworthy) && targets[j].unbroken_section.script_noteworthy == "glass")
					{
						targets[j].material = "glass";
						targets[j] thread destructible_glass_barricade(targets[j].unbroken_section, self);
					}
					else if(isdefined(targets[j].unbroken_section.script_noteworthy) && targets[j].unbroken_section.script_noteworthy == "metal")
					{
						targets[j].material = "metal";
					}
				}
			}
			else if(targets[j].script_parameters == "barricade_vents")
			{
				targets[j].material = "metal_vent";
			}
		}
		if(isdefined(targets[j].targetname))
		{
		}
		targets[j] update_states("repaired");
		targets[j].destroyed = 0;
		targets[j] show();
		targets[j].claimed = 0;
		targets[j].anim_grate_index = 0;
		targets[j].og_origin = targets[j].origin;
		targets[j].og_angles = targets[j].angles;
		self.barrier_chunks[self.barrier_chunks.size] = targets[j];
	}
	target_nodes = GetNodeArray(self.target, "targetname");
	for(j = 0; j < target_nodes.size; j++)
	{
		if(target_nodes[j].type == "Begin")
		{
			self.neg_start = target_nodes[j];
			if(isdefined(self.neg_start.target))
			{
				self.neg_end = GetNode(self.neg_start.target, "targetname");
			}
			blocker_disconnect_paths(self.neg_start, self.neg_end);
		}
	}
	if(isdefined(self.zbarrier))
	{
		if(isdefined(self.barrier_chunks))
		{
			for(i = 0; i < self.barrier_chunks.size; i++)
			{
				self.barrier_chunks[i] delete();
			}
			self.barrier_chunks = [];
		}
	}
	if(isdefined(self.zbarrier) && should_delete_zbarriers())
	{
		self.zbarrier delete();
		self.zbarrier = undefined;
		return;
	}
	self blocker_attack_spots();
	self.trigger_location = struct::get(self.target, "targetname");
	self thread blocker_think();
}

/*
	Name: should_delete_zbarriers
	Namespace: zm_blockers
	Checksum: 0xCF2AA762
	Offset: 0x5258
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function should_delete_zbarriers()
{
	gametype = GetDvarString("ui_gametype");
	if(!zm_utility::is_Classic() && !zm_utility::is_Standard() && gametype != "zgrief")
	{
		return 1;
	}
	return 0;
}

/*
	Name: destructible_glass_barricade
	Namespace: zm_blockers
	Checksum: 0x840A7D05
	Offset: 0x52D0
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function destructible_glass_barricade(unbroken_section, node)
{
	unbroken_section SetCanDamage(1);
	unbroken_section.health = 99999;
	unbroken_section waittill("damage", amount, who);
	if(zm_utility::is_player_valid(who) || who laststand::player_is_in_laststand())
	{
		self thread zm_spawner::zombie_boardtear_offset_fx_horizontle(self, node);
		level thread remove_chunk(self, node, 1);
		self update_states("destroyed");
		self notify("destroyed");
		self.unbroken = 0;
	}
}

/*
	Name: blocker_attack_spots
	Namespace: zm_blockers
	Checksum: 0xE0BA3F46
	Offset: 0x53E8
	Size: 0x28B
	Parameters: 0
	Flags: None
*/
function blocker_attack_spots()
{
	spots = [];
	numSlots = self.zbarrier GetZBarrierNumAttackSlots();
	numSlots = Int(max(numSlots, 1));
	if(numSlots % 2)
	{
		spots[spots.size] = zm_utility::groundpos_ignore_water_new(self.zbarrier.origin + VectorScale((0, 0, 1), 60));
	}
	if(numSlots > 1)
	{
		reps = floor(numSlots / 2);
		slot = 1;
		for(i = 0; i < reps; i++)
		{
			offset = self.zbarrier GetZBarrierAttackSlotHorzOffset() * i + 1;
			spots[spots.size] = zm_utility::groundpos_ignore_water_new(spots[0] + AnglesToRight(self.angles) * offset + VectorScale((0, 0, 1), 60));
			slot++;
			if(slot < numSlots)
			{
				spots[spots.size] = zm_utility::groundpos_ignore_water_new(spots[0] + AnglesToRight(self.angles) * offset * -1 + VectorScale((0, 0, 1), 60));
				slot++;
			}
		}
	}
	taken = [];
	for(i = 0; i < spots.size; i++)
	{
		taken[i] = 0;
	}
	self.attack_spots_taken = taken;
	self.attack_spots = spots;
	/#
		self thread zm_utility::debug_attack_spots_taken();
	#/
}

/*
	Name: blocker_choke
	Namespace: zm_blockers
	Checksum: 0x8988BA94
	Offset: 0x5680
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function blocker_choke()
{
	level._blocker_choke = 0;
	level endon("stop_blocker_think");
	while(1)
	{
		wait(0.05);
		level._blocker_choke = 0;
	}
}

/*
	Name: blocker_think
	Namespace: zm_blockers
	Checksum: 0xC078E8D9
	Offset: 0x56C8
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function blocker_think()
{
	level endon("stop_blocker_think");
	if(!isdefined(level._blocker_choke))
	{
		level thread blocker_choke();
	}
	use_choke = 0;
	if(isdefined(level._use_choke_blockers) && level._use_choke_blockers == 1)
	{
		use_choke = 1;
	}
	while(1)
	{
		wait(0.5);
		if(use_choke)
		{
			if(level._blocker_choke > 3)
			{
				wait(0.05);
			}
		}
		level._blocker_choke++;
		if(zm_utility::all_chunks_intact(self, self.barrier_chunks))
		{
			continue;
		}
		if(zm_utility::no_valid_repairable_boards(self, self.barrier_chunks))
		{
			continue;
		}
		self blocker_trigger_think();
	}
}

/*
	Name: player_fails_blocker_repair_trigger_preamble
	Namespace: zm_blockers
	Checksum: 0x62993391
	Offset: 0x57D0
	Size: 0x129
	Parameters: 4
	Flags: None
*/
function player_fails_blocker_repair_trigger_preamble(player, players, trigger, hold_required)
{
	if(!isdefined(trigger))
	{
		return 1;
	}
	if(!zm_utility::is_player_valid(player))
	{
		return 1;
	}
	if(players.size == 1 && isdefined(players[0].intermission) && players[0].intermission == 1)
	{
		return 1;
	}
	if(hold_required && !player useButtonPressed())
	{
		return 1;
	}
	if(!hold_required && !player util::use_button_held())
	{
		return 1;
	}
	if(player zm_utility::in_revive_trigger())
	{
		return 1;
	}
	if(player.IS_DRINKING > 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: has_blocker_affecting_perk
	Namespace: zm_blockers
	Checksum: 0xF0CC700E
	Offset: 0x5908
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function has_blocker_affecting_perk()
{
	has_perk = undefined;
	if(self hasPerk("specialty_fastreload"))
	{
		has_perk = "specialty_fastreload";
	}
	return has_perk;
}

/*
	Name: do_post_chunk_repair_delay
	Namespace: zm_blockers
	Checksum: 0x9308B040
	Offset: 0x5958
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function do_post_chunk_repair_delay(has_perk)
{
	if(!self util::script_delay())
	{
		wait(1);
	}
}

/*
	Name: handle_post_board_repair_rewards
	Namespace: zm_blockers
	Checksum: 0xD7519D7C
	Offset: 0x5990
	Size: 0x153
	Parameters: 2
	Flags: None
*/
function handle_post_board_repair_rewards(cost, zbarrier)
{
	self zm_stats::increment_client_stat("boards");
	self zm_stats::increment_player_stat("boards");
	if(isdefined(self.pers["boards"]) && self.pers["boards"] % 10 == 0)
	{
		self zm_audio::create_and_play_dialog("general", "rebuild_boards");
	}
	self zm_pers_upgrades_functions::pers_boards_updated(zbarrier);
	self.rebuild_barrier_reward = self.rebuild_barrier_reward + cost;
	if(self.rebuild_barrier_reward < level.zombie_vars["rebuild_barrier_cap_per_round"])
	{
		self zm_score::player_add_points("rebuild_board", cost);
		self zm_utility::play_sound_on_ent("purchase");
	}
	if(isdefined(self.board_repair))
	{
		self.board_repair = self.board_repair + 1;
	}
}

/*
	Name: blocker_unitrigger_think
	Namespace: zm_blockers
	Checksum: 0xDBB0B0DE
	Offset: 0x5AF0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function blocker_unitrigger_think()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", player);
		self.stub.trigger_target notify("trigger", player);
	}
}

/*
	Name: blocker_trigger_think
	Namespace: zm_blockers
	Checksum: 0x7A7C8DA2
	Offset: 0x5B50
	Size: 0xA3D
	Parameters: 0
	Flags: None
*/
function blocker_trigger_think()
{
	self endon("blocker_hacked");
	if(isdefined(level.no_board_repair) && level.no_board_repair)
	{
		return;
	}
	/#
		println("Dev Block strings are not supported");
	#/
	level endon("stop_blocker_think");
	cost = 10;
	if(isdefined(self.zombie_cost))
	{
		cost = self.zombie_cost;
	}
	original_cost = cost;
	if(!isdefined(self.unitrigger_stub))
	{
		radius = 94.21;
		height = 94.21;
		if(isdefined(self.trigger_location))
		{
			trigger_location = self.trigger_location;
		}
		else
		{
			trigger_location = self;
		}
		if(isdefined(trigger_location.radius))
		{
			radius = trigger_location.radius;
		}
		if(isdefined(trigger_location.height))
		{
			height = trigger_location.height;
		}
		trigger_pos = zm_utility::GROUNDPOS(trigger_location.origin) + VectorScale((0, 0, 1), 4);
		self.unitrigger_stub = spawnstruct();
		self.unitrigger_stub.origin = trigger_pos;
		self.unitrigger_stub.radius = radius;
		self.unitrigger_stub.height = height;
		self.unitrigger_stub.script_unitrigger_type = "unitrigger_radius";
		self.unitrigger_stub.hint_string = zm_utility::get_hint_string(self, "default_reward_barrier_piece");
		self.unitrigger_stub.cursor_hint = "HINT_NOICON";
		self.unitrigger_stub.trigger_target = self;
		zm_unitrigger::unitrigger_force_per_player_triggers(self.unitrigger_stub, 1);
		self.unitrigger_stub.prompt_and_visibility_func = &blockertrigger_update_prompt;
		zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &blocker_unitrigger_think);
		zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
		if(!isdefined(trigger_location.angles))
		{
			trigger_location.angles = (0, 0, 0);
		}
		self.unitrigger_stub.origin = zm_utility::GROUNDPOS(trigger_location.origin) + VectorScale((0, 0, 1), 4) + AnglesToForward(trigger_location.angles) * -11;
	}
	self thread trigger_delete_on_repair();
	thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &blocker_unitrigger_think);
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			thread zm_utility::debug_blocker(trigger_pos, radius, height);
		}
	#/
	while(1)
	{
		self waittill("trigger", player);
		has_perk = player has_blocker_affecting_perk();
		if(zm_utility::all_chunks_intact(self, self.barrier_chunks))
		{
			self notify("all_boards_repaired");
			return;
		}
		if(zm_utility::no_valid_repairable_boards(self, self.barrier_chunks))
		{
			self notify("no valid boards");
			return;
		}
		if(isdefined(level._zm_blocker_trigger_think_return_override))
		{
			if(self [[level._zm_blocker_trigger_think_return_override]](player))
			{
				return;
			}
		}
		while(1)
		{
			players = GetPlayers();
			trigger = self.unitrigger_stub zm_unitrigger::unitrigger_trigger(player);
			if(player_fails_blocker_repair_trigger_preamble(player, players, trigger, 0))
			{
				break;
			}
			player notify("boarding_window", self);
			if(isdefined(self.zbarrier))
			{
				chunk = zm_utility::get_random_destroyed_chunk(self, self.barrier_chunks);
				self thread replace_chunk(self, chunk, has_perk, isdefined(player.pers_upgrades_awarded["board"]) && player.pers_upgrades_awarded["board"]);
			}
			else
			{
				chunk = zm_utility::get_random_destroyed_chunk(self, self.barrier_chunks);
				if(isdefined(chunk.script_parameter) && chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
				{
					if(isdefined(chunk.unbroken_section))
					{
						chunk show();
						chunk solid();
						chunk.unbroken_section zm_utility::self_delete();
					}
				}
				else
				{
					chunk show();
				}
				if(!isdefined(chunk.script_parameters) || chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
				{
					if(!(isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx))
					{
						if(!isdefined(chunk.material) || (isdefined(chunk.material) && chunk.material != "rock"))
						{
							chunk zm_utility::play_sound_on_ent("rebuild_barrier_piece");
						}
						playsoundatposition("zmb_cha_ching", (0, 0, 0));
					}
				}
				if(chunk.script_parameters == "bar")
				{
					chunk zm_utility::play_sound_on_ent("rebuild_barrier_piece");
					playsoundatposition("zmb_cha_ching", (0, 0, 0));
				}
				if(isdefined(chunk.script_parameters))
				{
					if(chunk.script_parameters == "bar")
					{
						if(isdefined(chunk.script_noteworthy))
						{
							if(chunk.script_noteworthy == "5")
							{
								chunk Hide();
							}
							else if(chunk.script_noteworthy == "3")
							{
								chunk Hide();
							}
						}
					}
				}
				self thread replace_chunk(self, chunk, has_perk, isdefined(player.pers_upgrades_awarded["board"]) && player.pers_upgrades_awarded["board"]);
			}
			if(isdefined(self.clip))
			{
				self.clip TriggerEnable(1);
				self.clip disconnectpaths();
			}
			else
			{
				blocker_disconnect_paths(self.neg_start, self.neg_end);
			}
			self do_post_chunk_repair_delay(has_perk);
			if(!zm_utility::is_player_valid(player))
			{
				break;
			}
			player handle_post_board_repair_rewards(cost, self);
			if(zm_utility::all_chunks_intact(self, self.barrier_chunks))
			{
				self notify("all_boards_repaired");
				player increment_window_repaired();
				return;
			}
			if(zm_utility::no_valid_repairable_boards(self, self.barrier_chunks))
			{
				self notify("no valid boards");
				player increment_window_repaired(self);
				return;
			}
		}
	}
}

/*
	Name: increment_window_repaired
	Namespace: zm_blockers
	Checksum: 0xCD92605E
	Offset: 0x6598
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function increment_window_repaired(s_barrier)
{
	self zm_stats::increment_challenge_stat("SURVIVALIST_BOARD");
	self IncrementPlayerStat("windowsBoarded", 1);
	self thread zm_daily_challenges::increment_windows_repaired(s_barrier);
}

/*
	Name: blockertrigger_update_prompt
	Namespace: zm_blockers
	Checksum: 0x6FA21FCE
	Offset: 0x6608
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function blockertrigger_update_prompt(player)
{
	can_use = self.stub blockerstub_update_prompt(player);
	self SetInvisibleToPlayer(player, !can_use);
	self setHintString(self.stub.hint_string);
	return can_use;
}

/*
	Name: blockerstub_update_prompt
	Namespace: zm_blockers
	Checksum: 0x756338F2
	Offset: 0x6690
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function blockerstub_update_prompt(player)
{
	if(!zm_utility::is_player_valid(player))
	{
		return 0;
	}
	if(player zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(player.IS_DRINKING > 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: random_destroyed_chunk_show
	Namespace: zm_blockers
	Checksum: 0x3403525F
	Offset: 0x6700
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function random_destroyed_chunk_show()
{
	wait(0.5);
	self show();
}

/*
	Name: door_repaired_rumble_n_sound
	Namespace: zm_blockers
	Checksum: 0x717675B5
	Offset: 0x6730
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function door_repaired_rumble_n_sound()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(Distance(players[i].origin, self.origin) < 150)
		{
			if(isalive(players[i]))
			{
				players[i] thread board_completion();
			}
		}
	}
}

/*
	Name: board_completion
	Namespace: zm_blockers
	Checksum: 0xD6EB5FF4
	Offset: 0x67F8
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function board_completion()
{
	self endon("disconnect");
}

/*
	Name: trigger_delete_on_repair
	Namespace: zm_blockers
	Checksum: 0x22C65212
	Offset: 0x6810
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function trigger_delete_on_repair()
{
	while(1)
	{
		self util::waittill_either("all_boards_repaired", "no valid boards");
		zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
		break;
	}
}

/*
	Name: rebuild_barrier_reward_reset
	Namespace: zm_blockers
	Checksum: 0x42F8C4C9
	Offset: 0x6870
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function rebuild_barrier_reward_reset()
{
	self.rebuild_barrier_reward = 0;
}

/*
	Name: remove_chunk
	Namespace: zm_blockers
	Checksum: 0x1E03388F
	Offset: 0x6888
	Size: 0xE9B
	Parameters: 4
	Flags: None
*/
function remove_chunk(chunk, node, destroy_immediately, zomb)
{
	chunk update_states("mid_tear");
	if(isdefined(chunk.script_parameters))
	{
		if(chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
		{
			chunk thread zombie_boardtear_audio_offset(chunk);
		}
	}
	if(isdefined(chunk.script_parameters))
	{
		if(chunk.script_parameters == "bar")
		{
			chunk thread zombie_bartear_audio_offset(chunk);
		}
	}
	chunk notsolid();
	FX = "wood_chunk_destory";
	if(isdefined(self.script_fxid))
	{
		FX = self.script_fxid;
	}
	if(isdefined(chunk.script_moveoverride) && chunk.script_moveoverride)
	{
		chunk Hide();
	}
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "bar")
	{
		if(isdefined(chunk.script_noteworthy) && chunk.script_noteworthy == "4")
		{
			ent = spawn("script_origin", chunk.origin);
			ent.angles = node.angles + VectorScale((0, 1, 0), 180);
			dist = 100;
			if(isdefined(chunk.script_move_dist))
			{
				dist_max = chunk.script_move_dist - 100;
				dist = 100 + RandomInt(dist_max);
			}
			else
			{
				dist = 100 + RandomInt(100);
			}
			dest = ent.origin + AnglesToForward(ent.angles) * dist;
			trace = bullettrace(dest + VectorScale((0, 0, 1), 16), dest + VectorScale((0, 0, -1), 200), 0, undefined);
			if(trace["fraction"] == 1)
			{
				dest = dest + VectorScale((0, 0, -1), 200);
			}
			else
			{
				dest = trace["position"];
			}
			chunk LinkTo(ent);
			time = ent zm_utility::fake_physicslaunch(dest, 300 + RandomInt(100));
			if(RandomInt(100) > 40)
			{
				ent RotatePitch(180, time * 0.5);
			}
			else
			{
				ent RotatePitch(90, time, time * 0.5);
			}
			wait(time);
			chunk Hide();
			wait(0.1);
			ent delete();
		}
		else
		{
			ent = spawn("script_origin", chunk.origin);
			ent.angles = node.angles + VectorScale((0, 1, 0), 180);
			dist = 100;
			if(isdefined(chunk.script_move_dist))
			{
				dist_max = chunk.script_move_dist - 100;
				dist = 100 + RandomInt(dist_max);
			}
			else
			{
				dist = 100 + RandomInt(100);
			}
			dest = ent.origin + AnglesToForward(ent.angles) * dist;
			trace = bullettrace(dest + VectorScale((0, 0, 1), 16), dest + VectorScale((0, 0, -1), 200), 0, undefined);
			if(trace["fraction"] == 1)
			{
				dest = dest + VectorScale((0, 0, -1), 200);
			}
			else
			{
				dest = trace["position"];
			}
			chunk LinkTo(ent);
			time = ent zm_utility::fake_physicslaunch(dest, 260 + RandomInt(100));
			if(RandomInt(100) > 40)
			{
				ent RotatePitch(180, time * 0.5);
			}
			else
			{
				ent RotatePitch(90, time, time * 0.5);
			}
			wait(time);
			chunk Hide();
			wait(0.1);
			ent delete();
		}
		chunk update_states("destroyed");
		chunk notify("destroyed");
	}
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
	{
		ent = spawn("script_origin", chunk.origin);
		ent.angles = node.angles + VectorScale((0, 1, 0), 180);
		dist = 100;
		if(isdefined(chunk.script_move_dist))
		{
			dist_max = chunk.script_move_dist - 100;
			dist = 100 + RandomInt(dist_max);
		}
		else
		{
			dist = 100 + RandomInt(100);
		}
		dest = ent.origin + AnglesToForward(ent.angles) * dist;
		trace = bullettrace(dest + VectorScale((0, 0, 1), 16), dest + VectorScale((0, 0, -1), 200), 0, undefined);
		if(trace["fraction"] == 1)
		{
			dest = dest + VectorScale((0, 0, -1), 200);
		}
		else
		{
			dest = trace["position"];
		}
		chunk LinkTo(ent);
		time = ent zm_utility::fake_physicslaunch(dest, 200 + RandomInt(100));
		if(isdefined(chunk.unbroken_section))
		{
			if(!isdefined(chunk.material) || chunk.material != "metal")
			{
				chunk.unbroken_section zm_utility::self_delete();
			}
		}
		if(RandomInt(100) > 40)
		{
			ent RotatePitch(180, time * 0.5);
		}
		else
		{
			ent RotatePitch(90, time, time * 0.5);
		}
		wait(time);
		if(isdefined(chunk.unbroken_section))
		{
			if(isdefined(chunk.material) && chunk.material == "metal")
			{
				chunk.unbroken_section zm_utility::self_delete();
			}
		}
		chunk Hide();
		wait(0.1);
		ent delete();
		chunk update_states("destroyed");
		chunk notify("destroyed");
	}
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "grate")
	{
		if(isdefined(chunk.script_noteworthy) && chunk.script_noteworthy == "6")
		{
			ent = spawn("script_origin", chunk.origin);
			ent.angles = node.angles + VectorScale((0, 1, 0), 180);
			dist = 100 + RandomInt(100);
			dest = ent.origin + AnglesToForward(ent.angles) * dist;
			trace = bullettrace(dest + VectorScale((0, 0, 1), 16), dest + VectorScale((0, 0, -1), 200), 0, undefined);
			if(trace["fraction"] == 1)
			{
				dest = dest + VectorScale((0, 0, -1), 200);
			}
			else
			{
				dest = trace["position"];
			}
			chunk LinkTo(ent);
			time = ent zm_utility::fake_physicslaunch(dest, 200 + RandomInt(100));
			if(RandomInt(100) > 40)
			{
				ent RotatePitch(180, time * 0.5);
			}
			else
			{
				ent RotatePitch(90, time, time * 0.5);
			}
			wait(time);
			chunk Hide();
			ent delete();
			chunk update_states("destroyed");
			chunk notify("destroyed");
		}
		else
		{
			chunk Hide();
			chunk update_states("destroyed");
			chunk notify("destroyed");
		}
	}
}

/*
	Name: remove_chunk_rotate_grate
	Namespace: zm_blockers
	Checksum: 0x7EFB958D
	Offset: 0x7730
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function remove_chunk_rotate_grate(chunk)
{
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "grate")
	{
		chunk vibrate(VectorScale((0, 1, 0), 270), 0.2, 0.4, 0.4);
		return;
	}
}

/*
	Name: zombie_boardtear_audio_offset
	Namespace: zm_blockers
	Checksum: 0x131296AE
	Offset: 0x77B8
	Size: 0x35F
	Parameters: 1
	Flags: None
*/
function zombie_boardtear_audio_offset(chunk)
{
	if(isdefined(chunk.material) && !isdefined(chunk.already_broken))
	{
		chunk.already_broken = 0;
	}
	if(isdefined(chunk.material) && chunk.material == "glass" && chunk.already_broken == 0)
	{
		chunk playsound("zmb_break_glass_barrier");
		wait(RandomFloatRange(0.3, 0.6));
		chunk playsound("zmb_break_glass_barrier");
		chunk.already_broken = 1;
	}
	else if(isdefined(chunk.material) && chunk.material == "metal" && chunk.already_broken == 0)
	{
		chunk playsound("grab_metal_bar");
		wait(RandomFloatRange(0.3, 0.6));
		chunk playsound("break_metal_bar");
		chunk.already_broken = 1;
	}
	else if(isdefined(chunk.material) && chunk.material == "rock")
	{
		if(!(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx))
		{
			chunk playsound("zmb_break_rock_barrier");
			wait(RandomFloatRange(0.3, 0.6));
			chunk playsound("zmb_break_rock_barrier");
		}
		chunk.already_broken = 1;
	}
	else if(isdefined(chunk.material) && chunk.material == "metal_vent")
	{
		if(!(isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx))
		{
			chunk playsound("evt_vent_slat_remove");
		}
	}
	else if(!(isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx))
	{
		chunk zm_utility::play_sound_on_ent("break_barrier_piece");
		wait(RandomFloatRange(0.3, 0.6));
		chunk zm_utility::play_sound_on_ent("break_barrier_piece");
	}
	chunk.already_broken = 1;
}

/*
	Name: zombie_bartear_audio_offset
	Namespace: zm_blockers
	Checksum: 0xA816D188
	Offset: 0x7B20
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function zombie_bartear_audio_offset(chunk)
{
	chunk zm_utility::play_sound_on_ent("grab_metal_bar");
	wait(RandomFloatRange(0.3, 0.6));
	chunk zm_utility::play_sound_on_ent("break_metal_bar");
	wait(RandomFloatRange(1, 1.3));
	chunk zm_utility::play_sound_on_ent("drop_metal_bar");
}

/*
	Name: ensure_chunk_is_back_to_origin
	Namespace: zm_blockers
	Checksum: 0x1AFBE53D
	Offset: 0x7BD8
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function ensure_chunk_is_back_to_origin(chunk)
{
	if(chunk.origin != chunk.og_origin)
	{
		chunk notsolid();
		chunk waittill("movedone");
	}
}

/*
	Name: replace_chunk
	Namespace: zm_blockers
	Checksum: 0xC09A985A
	Offset: 0x7C38
	Size: 0x2B5
	Parameters: 5
	Flags: None
*/
function replace_chunk(barrier, chunk, perk, upgrade, via_powerup)
{
	if(!isdefined(barrier.zbarrier))
	{
		chunk update_states("mid_repair");
		/#
			Assert(isdefined(chunk.og_origin));
		#/
		/#
			Assert(isdefined(chunk.og_angles));
		#/
		sound = "rebuild_barrier_hover";
		if(isdefined(chunk.script_presound))
		{
			sound = chunk.script_presound;
		}
	}
	has_perk = 0;
	if(isdefined(perk))
	{
		has_perk = 1;
	}
	if(!isdefined(via_powerup) && isdefined(sound))
	{
		zm_utility::play_sound_at_pos(sound, chunk.origin);
	}
	if(upgrade)
	{
		barrier.zbarrier ZBarrierPieceUseUpgradedModel(chunk);
		barrier.zbarrier.chunk_health[chunk] = barrier.zbarrier GetUpgradedPieceNumLives(chunk);
	}
	else
	{
		barrier.zbarrier ZBarrierPieceUseDefaultModel(chunk);
		barrier.zbarrier.chunk_health[chunk] = 0;
	}
	scalar = 1;
	if(has_perk)
	{
		if("specialty_fastreload" == perk)
		{
			scalar = 0.31;
		}
	}
	barrier.zbarrier ShowZBarrierPiece(chunk);
	barrier.zbarrier SetZBarrierPieceState(chunk, "closing", scalar);
	waitDuration = barrier.zbarrier GetZBarrierPieceAnimLengthForState(chunk, "closing", scalar);
	wait(waitDuration);
}

/*
	Name: open_all_zbarriers
	Namespace: zm_blockers
	Checksum: 0x3B39FFD2
	Offset: 0x7EF8
	Size: 0x179
	Parameters: 0
	Flags: None
*/
function open_all_zbarriers()
{
	foreach(barrier in level.exterior_goals)
	{
		if(isdefined(barrier.zbarrier))
		{
			for(x = 0; x < barrier.zbarrier GetNumZBarrierPieces(); x++)
			{
				barrier.zbarrier SetZBarrierPieceState(x, "opening");
			}
		}
		else if(isdefined(barrier.clip))
		{
			barrier.clip TriggerEnable(0);
			barrier.clip connectpaths();
			continue;
		}
		blocker_connect_paths(barrier.neg_start, barrier.neg_end);
	}
}

/*
	Name: zombie_boardtear_audio_plus_fx_offset_repair_horizontal
	Namespace: zm_blockers
	Checksum: 0x112829A9
	Offset: 0x8080
	Size: 0x1FB
	Parameters: 1
	Flags: None
*/
function zombie_boardtear_audio_plus_fx_offset_repair_horizontal(chunk)
{
	if(isdefined(chunk.material) && chunk.material == "rock")
	{
		if(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
		{
			chunk clientfield::set("tearin_rock_fx", 0);
		}
		else
		{
			Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
			wait(RandomFloatRange(0.3, 0.6));
			chunk zm_utility::play_sound_on_ent("break_barrier_piece");
		}
	}
	else if(isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
	{
		chunk clientfield::set("tearin_board_vertical_fx", 0);
	}
	else
	{
		Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
		wait(RandomFloatRange(0.3, 0.6));
		chunk zm_utility::play_sound_on_ent("break_barrier_piece");
	}
}

/*
	Name: zombie_boardtear_audio_plus_fx_offset_repair_verticle
	Namespace: zm_blockers
	Checksum: 0xCB16809C
	Offset: 0x8288
	Size: 0x1FB
	Parameters: 1
	Flags: None
*/
function zombie_boardtear_audio_plus_fx_offset_repair_verticle(chunk)
{
	if(isdefined(chunk.material) && chunk.material == "rock")
	{
		if(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
		{
			chunk clientfield::set("tearin_rock_fx", 0);
		}
		else
		{
			Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
			wait(RandomFloatRange(0.3, 0.6));
			chunk zm_utility::play_sound_on_ent("break_barrier_piece");
		}
	}
	else if(isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
	{
		chunk clientfield::set("tearin_board_horizontal_fx", 0);
	}
	else
	{
		Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
		wait(RandomFloatRange(0.3, 0.6));
		chunk zm_utility::play_sound_on_ent("break_barrier_piece");
	}
}

/*
	Name: zombie_gratetear_audio_plus_fx_offset_repair_horizontal
	Namespace: zm_blockers
	Checksum: 0xB4A7D4BB
	Offset: 0x8490
	Size: 0x55D
	Parameters: 1
	Flags: None
*/
function zombie_gratetear_audio_plus_fx_offset_repair_horizontal(chunk)
{
	Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
	chunk zm_utility::play_sound_on_ent("bar_rebuild_slam");
	switch(RandomInt(9))
	{
		case 0:
		{
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			wait(RandomFloatRange(0, 0.3));
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 1:
		{
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			wait(RandomFloatRange(0, 0.3));
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 2:
		{
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			wait(RandomFloatRange(0, 0.3));
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 3:
		{
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			wait(RandomFloatRange(0, 0.3));
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 4:
		{
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			wait(RandomFloatRange(0, 0.3));
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 5:
		{
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 6:
		{
			playFX(level._effect["fx_zombie_bar_break_lite"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 7:
		{
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
		case 8:
		{
			playFX(level._effect["fx_zombie_bar_break"], chunk.origin + VectorScale((-1, 0, 0), 30));
			break;
		}
	}
}

/*
	Name: zombie_bartear_audio_plus_fx_offset_repair_horizontal
	Namespace: zm_blockers
	Checksum: 0xC2F0FB78
	Offset: 0x89F8
	Size: 0x47D
	Parameters: 1
	Flags: None
*/
function zombie_bartear_audio_plus_fx_offset_repair_horizontal(chunk)
{
	Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
	chunk zm_utility::play_sound_on_ent("bar_rebuild_slam");
	switch(RandomInt(9))
	{
		case 0:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
			break;
		}
		case 1:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
			break;
		}
		case 2:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
			break;
		}
		case 3:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
			break;
		}
		case 4:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
			break;
		}
		case 5:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
			break;
		}
		case 6:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
			break;
		}
		case 7:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left");
			break;
		}
		case 8:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
			break;
		}
	}
}

/*
	Name: zombie_bartear_audio_plus_fx_offset_repair_verticle
	Namespace: zm_blockers
	Checksum: 0x3C7FE774
	Offset: 0x8E80
	Size: 0x47D
	Parameters: 1
	Flags: None
*/
function zombie_bartear_audio_plus_fx_offset_repair_verticle(chunk)
{
	Earthquake(RandomFloatRange(0.3, 0.4), RandomFloatRange(0.2, 0.4), chunk.origin, 150);
	chunk zm_utility::play_sound_on_ent("bar_rebuild_slam");
	switch(RandomInt(9))
	{
		case 0:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
			break;
		}
		case 1:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom");
			break;
		}
		case 2:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom");
			break;
		}
		case 3:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
			break;
		}
		case 4:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
			wait(RandomFloatRange(0, 0.3));
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
			break;
		}
		case 5:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
			break;
		}
		case 6:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
			break;
		}
		case 7:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top");
			break;
		}
		case 8:
		{
			PlayFXOnTag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom");
			break;
		}
	}
}

/*
	Name: flag_blocker
	Namespace: zm_blockers
	Checksum: 0xF795BB75
	Offset: 0x9308
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function flag_blocker()
{
	if(!isdefined(self.script_flag_wait))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
		#/
		return;
	}
	if(!isdefined(level.flag[self.script_flag_wait]))
	{
		level flag::init(self.script_flag_wait);
	}
	type = "connectpaths";
	if(isdefined(self.script_noteworthy))
	{
		type = self.script_noteworthy;
	}
	level flag::wait_till(self.script_flag_wait);
	self util::script_delay();
	if(type == "connectpaths")
	{
		self connectpaths();
		self TriggerEnable(0);
		return;
	}
	if(type == "disconnectpaths")
	{
		self disconnectpaths();
		self TriggerEnable(0);
		return;
	}
	/#
		ASSERTMSG("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported" + type + "Dev Block strings are not supported");
	#/
}

/*
	Name: update_states
	Namespace: zm_blockers
	Checksum: 0x813A9A6A
	Offset: 0x94B0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function update_states(states)
{
	/#
		Assert(isdefined(states));
	#/
	self.State = states;
}

/*
	Name: quantum_bomb_open_nearest_door_validation
	Namespace: zm_blockers
	Checksum: 0x145BD163
	Offset: 0x94F0
	Size: 0x1BD
	Parameters: 1
	Flags: None
*/
function quantum_bomb_open_nearest_door_validation(position)
{
	range_squared = 32400;
	zombie_doors = GetEntArray("zombie_door", "targetname");
	for(i = 0; i < zombie_doors.size; i++)
	{
		if(DistanceSquared(zombie_doors[i].origin, position) < range_squared)
		{
			return 1;
		}
	}
	zombie_airlock_doors = GetEntArray("zombie_airlock_buy", "targetname");
	for(i = 0; i < zombie_airlock_doors.size; i++)
	{
		if(DistanceSquared(zombie_airlock_doors[i].origin, position) < range_squared)
		{
			return 1;
		}
	}
	zombie_debris = GetEntArray("zombie_debris", "targetname");
	for(i = 0; i < zombie_debris.size; i++)
	{
		if(DistanceSquared(zombie_debris[i].origin, position) < range_squared)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: quantum_bomb_open_nearest_door_result
	Namespace: zm_blockers
	Checksum: 0x582C6EA
	Offset: 0x96B8
	Size: 0x2AB
	Parameters: 1
	Flags: None
*/
function quantum_bomb_open_nearest_door_result(position)
{
	range_squared = 32400;
	zombie_doors = GetEntArray("zombie_door", "targetname");
	for(i = 0; i < zombie_doors.size; i++)
	{
		if(DistanceSquared(zombie_doors[i].origin, position) < range_squared)
		{
			self thread zm_audio::create_and_play_dialog("kill", "quant_good");
			zombie_doors[i] notify("trigger", self, 1);
			[[level.quantum_bomb_play_area_effect_func]](position);
			return;
		}
	}
	zombie_airlock_doors = GetEntArray("zombie_airlock_buy", "targetname");
	for(i = 0; i < zombie_airlock_doors.size; i++)
	{
		if(DistanceSquared(zombie_airlock_doors[i].origin, position) < range_squared)
		{
			self thread zm_audio::create_and_play_dialog("kill", "quant_good");
			zombie_airlock_doors[i] notify("trigger", self, 1);
			[[level.quantum_bomb_play_area_effect_func]](position);
			return;
		}
	}
	zombie_debris = GetEntArray("zombie_debris", "targetname");
	for(i = 0; i < zombie_debris.size; i++)
	{
		if(DistanceSquared(zombie_debris[i].origin, position) < range_squared)
		{
			self thread zm_audio::create_and_play_dialog("kill", "quant_good");
			zombie_debris[i] notify("trigger", self, 1);
			[[level.quantum_bomb_play_area_effect_func]](position);
			return;
		}
	}
}

