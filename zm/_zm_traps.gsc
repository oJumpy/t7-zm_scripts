#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_traps;

/*
	Name: __init__sytem__
	Namespace: zm_traps
	Checksum: 0x6CC2B4BC
	Offset: 0x760
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_traps", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_traps
	Checksum: 0x1480EF36
	Offset: 0x7A8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.trap_kills = 0;
	level.burning_zombies = [];
	callback::on_finalize_initialization(&init);
}

/*
	Name: init
	Namespace: zm_traps
	Checksum: 0xC376937B
	Offset: 0x7F0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function init()
{
	traps = GetEntArray("zombie_trap", "targetname");
	Array::thread_all(traps, &trap_init);
}

/*
	Name: __main__
	Namespace: zm_traps
	Checksum: 0xC31006AC
	Offset: 0x850
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __main__()
{
	traps = GetEntArray("zombie_trap", "targetname");
	Array::thread_all(traps, &trap_main);
}

/*
	Name: trap_init
	Namespace: zm_traps
	Checksum: 0x1A55DCE6
	Offset: 0x8B0
	Size: 0x68B
	Parameters: 0
	Flags: None
*/
function trap_init()
{
	self flag::init("flag_active");
	self flag::init("flag_cooldown");
	self._trap_type = "";
	if(isdefined(self.script_noteworthy))
	{
		self._trap_type = self.script_noteworthy;
		if(isdefined(level._custom_traps) && isdefined(level._custom_traps[self.script_noteworthy]) && isdefined(level._custom_traps[self.script_noteworthy].activate))
		{
			self._trap_activate_func = level._custom_traps[self.script_noteworthy].activate;
			break;
		}
		switch(self.script_noteworthy)
		{
			case "rotating":
			{
				self._trap_activate_func = &trap_activate_rotating;
				break;
			}
			case "flipper":
			{
				self._trap_activate_func = &trap_activate_flipper;
				break;
			}
			case default:
			{
				self._trap_activate_func = &trap_activate_fire;
			}
		}
		if(isdefined(level._zombiemode_trap_use_funcs) && isdefined(level._zombiemode_trap_use_funcs[self._trap_type]))
		{
			self._trap_use_func = level._zombiemode_trap_use_funcs[self._trap_type];
		}
		else
		{
			self._trap_use_func = &trap_use_think;
		}
	}
	self trap_model_type_init();
	self._trap_use_trigs = [];
	self._trap_lights = [];
	self._trap_movers = [];
	self._trap_switches = [];
	components = GetEntArray(self.target, "targetname");
	for(i = 0; i < components.size; i++)
	{
		if(isdefined(components[i].script_noteworthy))
		{
			switch(components[i].script_noteworthy)
			{
				case "counter_1s":
				{
					self.counter_1s = components[i];
					break;
				}
				case "counter_10s":
				{
					self.counter_10s = components[i];
					break;
				}
				case "counter_100s":
				{
					self.counter_100s = components[i];
					break;
				}
				case "mover":
				{
					self._trap_movers[self._trap_movers.size] = components[i];
					break;
				}
				case "switch":
				{
					self._trap_switches[self._trap_switches.size] = components[i];
					break;
				}
				case "light":
				{
					self._trap_lights[self._trap_lights.size] = components[i];
					break;
				}
			}
		}
		if(isdefined(components[i].script_string))
		{
			switch(components[i].script_string)
			{
				case "flipper1":
				{
					self.flipper1 = components[i];
					break;
				}
				case "flipper2":
				{
					self.flipper2 = components[i];
					break;
				}
				case "flipper1_radius_check":
				{
					self.flipper1_radius_check = components[i];
					break;
				}
				case "flipper2_radius_check":
				{
					self.flipper2_radius_check = components[i];
					break;
				}
				case "target1":
				{
					self.target1 = components[i];
					break;
				}
				case "target2":
				{
					self.target2 = components[i];
					break;
				}
				case "target3":
				{
					self.target3 = components[i];
					break;
				}
			}
		}
		switch(components[i].classname)
		{
			case "trigger_use":
			{
				self._trap_use_trigs[self._trap_use_trigs.size] = components[i];
				break;
			}
			case "script_model":
			{
				if(components[i].model == self._trap_light_model_off)
				{
					self._trap_lights[self._trap_lights.size] = components[i];
				}
				else if(components[i].model == self._trap_switch_model)
				{
					self._trap_switches[self._trap_switches.size] = components[i];
				}
			}
		}
	}
	self._trap_fx_structs = [];
	components = struct::get_array(self.target, "targetname");
	for(i = 0; i < components.size; i++)
	{
		if(isdefined(components[i].script_string) && components[i].script_string == "use_this_angle")
		{
			self.use_this_angle = components[i];
			continue;
		}
		self._trap_fx_structs[self._trap_fx_structs.size] = components[i];
	}
	/#
		Assert(self._trap_use_trigs.size > 0, "Dev Block strings are not supported" + self.target);
	#/
	if(!isdefined(self.zombie_cost))
	{
		self.zombie_cost = 1000;
	}
	self._trap_in_use = 0;
	self._trap_cooling_down = 0;
	self thread trap_dialog();
}

/*
	Name: trap_main
	Namespace: zm_traps
	Checksum: 0x4E630E86
	Offset: 0xF48
	Size: 0x26D
	Parameters: 0
	Flags: None
*/
function trap_main()
{
	level flag::wait_till("start_zombie_round_logic");
	for(i = 0; i < self._trap_use_trigs.size; i++)
	{
		self._trap_use_trigs[i] setcursorhint("HINT_NOICON");
	}
	if(!isdefined(self.script_string) || "disable_wait_for_power" != self.script_string)
	{
		self trap_set_string(&"ZOMBIE_NEED_POWER");
		if(isdefined(self.script_int))
		{
			level flag::wait_till("power_on" + self.script_int);
		}
		else
		{
			level flag::wait_till("power_on");
		}
	}
	if(isdefined(self.script_flag_wait))
	{
		self trap_set_string("");
		self TriggerEnable(0);
		self trap_lights_red();
		if(!isdefined(level.flag[self.script_flag_wait]))
		{
			level flag::init(self.script_flag_wait);
		}
		level flag::wait_till(self.script_flag_wait);
		self TriggerEnable(1);
	}
	self trap_set_string(&"ZOMBIE_BUTTON_BUY_TRAP", self.zombie_cost);
	self trap_lights_green();
	for(i = 0; i < self._trap_use_trigs.size; i++)
	{
		self._trap_use_trigs[i] thread [[self._trap_use_func]](self);
		self._trap_use_trigs[i] thread update_trigger_visibility();
	}
}

/*
	Name: trap_use_think
	Namespace: zm_traps
	Checksum: 0xDF6AD76C
	Offset: 0x11C0
	Size: 0x39F
	Parameters: 1
	Flags: None
*/
function trap_use_think(trap)
{
	while(1)
	{
		self waittill("trigger", who);
		if(who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(who.IS_DRINKING > 0)
		{
			continue;
		}
		if(zm_utility::is_player_valid(who) && !trap._trap_in_use)
		{
			players = GetPlayers();
			if(who zm_score::can_player_purchase(trap.zombie_cost))
			{
				who zm_score::minus_to_player_score(trap.zombie_cost);
			}
			else
			{
				self playsound("zmb_trap_deny");
				who zm_audio::create_and_play_dialog("general", "outofmoney");
				continue;
			}
			trap.activated_by_player = who;
			trap._trap_in_use = 1;
			trap trap_set_string(&"ZOMBIE_TRAP_ACTIVE");
			zm_utility::play_sound_at_pos("purchase", who.origin);
			if(!(isdefined(level.b_trap_start_custom_vo) && level.b_trap_start_custom_vo))
			{
				who zm_audio::create_and_play_dialog("trap", "start");
			}
			if(trap._trap_switches.size)
			{
				trap thread trap_move_switches();
				trap waittill("switch_activated");
			}
			trap TriggerEnable(1);
			trap thread [[trap._trap_activate_func]]();
			trap waittill("trap_done");
			trap TriggerEnable(0);
			trap._trap_cooling_down = 1;
			trap trap_set_string(&"ZOMBIE_TRAP_COOLDOWN");
			/#
				if(GetDvarInt("Dev Block strings are not supported") >= 1)
				{
					trap._trap_cooldown_time = 5;
				}
			#/
			wait(trap._trap_cooldown_time);
			trap._trap_cooling_down = 0;
			playsoundatposition("zmb_trap_ready", trap.origin);
			if(isdefined(level.sndTrapFunc))
			{
				level thread [[level.sndTrapFunc]](trap, 0);
			}
			trap notify("available");
			trap._trap_in_use = 0;
			trap trap_set_string(&"ZOMBIE_BUTTON_BUY_TRAP", trap.zombie_cost);
		}
	}
}

/*
	Name: update_trigger_visibility
	Namespace: zm_traps
	Checksum: 0x5C77DF64
	Offset: 0x1568
	Size: 0xFB
	Parameters: 0
	Flags: Private
*/
function private update_trigger_visibility()
{
	self endon("death");
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			if(DistanceSquared(level.players[i].origin, self.origin) < 16384)
			{
				if(level.players[i].IS_DRINKING > 0)
				{
					self SetInvisibleToPlayer(level.players[i], 1);
					continue;
				}
				self SetInvisibleToPlayer(level.players[i], 0);
			}
		}
		wait(0.25);
	}
}

/*
	Name: trap_lights_red
	Namespace: zm_traps
	Checksum: 0xEA2504F2
	Offset: 0x1670
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function trap_lights_red()
{
	for(i = 0; i < self._trap_lights.size; i++)
	{
		light = self._trap_lights[i];
		str_light_red = light.targetname + "_red";
		str_light_green = light.targetname + "_green";
		exploder::stop_exploder(str_light_green);
		exploder::exploder(str_light_red);
	}
}

/*
	Name: trap_lights_green
	Namespace: zm_traps
	Checksum: 0xE0745F19
	Offset: 0x1740
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function trap_lights_green()
{
	for(i = 0; i < self._trap_lights.size; i++)
	{
		light = self._trap_lights[i];
		if(isdefined(light._switch_disabled))
		{
			continue;
		}
		str_light_red = light.targetname + "_red";
		str_light_green = light.targetname + "_green";
		exploder::stop_exploder(str_light_red);
		exploder::exploder(str_light_green);
	}
}

/*
	Name: trap_set_string
	Namespace: zm_traps
	Checksum: 0xC0630692
	Offset: 0x1828
	Size: 0xDD
	Parameters: 3
	Flags: None
*/
function trap_set_string(string, param1, param2)
{
	for(i = 0; i < self._trap_use_trigs.size; i++)
	{
		if(!isdefined(param1))
		{
			self._trap_use_trigs[i] setHintString(string);
			continue;
		}
		if(!isdefined(param2))
		{
			self._trap_use_trigs[i] setHintString(string, param1);
			continue;
		}
		self._trap_use_trigs[i] setHintString(string, param1, param2);
	}
}

/*
	Name: trap_move_switches
	Namespace: zm_traps
	Checksum: 0x995BA8C6
	Offset: 0x1910
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function trap_move_switches()
{
	self trap_lights_red();
	for(i = 0; i < self._trap_switches.size; i++)
	{
		self._trap_switches[i] RotatePitch(180, 0.5);
		if(isdefined(self._trap_type) && self._trap_type == "fire")
		{
			self._trap_switches[i] playsound("evt_switch_flip_trap_fire");
			continue;
		}
		self._trap_switches[i] playsound("evt_switch_flip_trap");
	}
	self._trap_switches[0] waittill("rotatedone");
	self notify("switch_activated");
	self waittill("available");
	for(i = 0; i < self._trap_switches.size; i++)
	{
		self._trap_switches[i] RotatePitch(-180, 0.5);
	}
	self._trap_switches[0] waittill("rotatedone");
	self trap_lights_green();
}

/*
	Name: trap_activate_fire
	Namespace: zm_traps
	Checksum: 0xE3033BBD
	Offset: 0x1AB8
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function trap_activate_fire()
{
	self._trap_duration = 40;
	self._trap_cooldown_time = 60;
	fx_points = struct::get_array(self.target, "targetname");
	for(i = 0; i < fx_points.size; i++)
	{
		util::wait_network_frame();
		fx_points[i] thread trap_audio_fx(self);
	}
	self thread trap_damage();
	wait(self._trap_duration);
	self notify("trap_done");
}

/*
	Name: trap_activate_rotating
	Namespace: zm_traps
	Checksum: 0x87D64582
	Offset: 0x1B98
	Size: 0x235
	Parameters: 0
	Flags: None
*/
function trap_activate_rotating()
{
	self endon("trap_done");
	self._trap_duration = 30;
	self._trap_cooldown_time = 60;
	self thread trap_damage();
	self thread trig_update(self._trap_movers[0]);
	old_angles = self._trap_movers[0].angles;
	for(i = 0; i < self._trap_movers.size; i++)
	{
		self._trap_movers[i] RotateYaw(360, 5, 4.5);
	}
	wait(5);
	step = 1.5;
	for(t = 0; t < self._trap_duration;  = 0)
	{
		for(i = 0; i < self._trap_movers.size; i++)
		{
			self._trap_movers[i] RotateYaw(360, step);
		}
		wait(step);
	}
	for(i = 0; i < self._trap_movers.size; i++)
	{
		self._trap_movers[i] RotateYaw(360, 5, 0, 4.5);
	}
	wait(5);
	for(i = 0; i < self._trap_movers.size; i++)
	{
		self._trap_movers[i].angles = old_angles;
	}
	self notify("trap_done", t + step);
}

/*
	Name: trap_activate_flipper
	Namespace: zm_traps
	Checksum: 0x99EC1590
	Offset: 0x1DD8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function trap_activate_flipper()
{
}

/*
	Name: trap_audio_fx
	Namespace: zm_traps
	Checksum: 0xA54858B7
	Offset: 0x1DE8
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function trap_audio_fx(trap)
{
	if(isdefined(level._custom_traps) && isdefined(level._custom_traps[trap.script_noteworthy]) && isdefined(level._custom_traps[trap.script_noteworthy].audio))
	{
		self [[level._custom_traps[trap.script_noteworthy].audio]](trap);
	}
	else
	{
		sound_origin = undefined;
		trap util::waittill_any_timeout(trap._trap_duration, "trap_done");
		if(isdefined(sound_origin))
		{
			playsoundatposition("wpn_zmb_electrap_stop", sound_origin.origin);
			sound_origin StopLoopSound();
			wait(0.05);
			sound_origin delete();
		}
	}
}

/*
	Name: trap_damage
	Namespace: zm_traps
	Checksum: 0xD0F94275
	Offset: 0x1F28
	Size: 0x2A9
	Parameters: 0
	Flags: None
*/
function trap_damage()
{
	self endon("trap_done");
	while(1)
	{
		self waittill("trigger", ent);
		if(isPlayer(ent))
		{
			if(isdefined(level._custom_traps) && isdefined(level._custom_traps[self._trap_type]) && isdefined(level._custom_traps[self._trap_type].player_damage))
			{
				ent thread [[level._custom_traps[self._trap_type].player_damage]]();
				break;
				break;
			}
			switch(self._trap_type)
			{
				case "rocket":
				{
					ent thread player_fire_damage();
					break;
				}
				case "rotating":
				{
					if(ent GetStance() == "stand")
					{
						ent DoDamage(50, ent.origin + VectorScale((0, 0, 1), 20));
						ent SetStance("crouch");
					}
					break;
				}
			}
			break;
		}
		if(!isdefined(ent.marked_for_death))
		{
			if(isdefined(level._custom_traps) && isdefined(level._custom_traps[self._trap_type]) && isdefined(level._custom_traps[self._trap_type].damage))
			{
				ent thread [[level._custom_traps[self._trap_type].damage]](self);
				break;
				break;
			}
			switch(self._trap_type)
			{
				case "rocket":
				{
					ent thread zombie_trap_death(self, 100);
					break;
				}
				case "rotating":
				{
					ent thread zombie_trap_death(self, 200);
					break;
				}
				case default:
				{
					ent thread zombie_trap_death(self, RandomInt(100));
					break;
				}
			}
		}
	}
}

/*
	Name: trig_update
	Namespace: zm_traps
	Checksum: 0xEF03CECE
	Offset: 0x21E0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function trig_update(parent)
{
	self endon("trap_done");
	start_angles = self.angles;
	while(1)
	{
		self.angles = parent.angles;
		wait(0.05);
	}
}

/*
	Name: player_elec_damage
	Namespace: zm_traps
	Checksum: 0x5662F0A
	Offset: 0x2240
	Size: 0x23D
	Parameters: 0
	Flags: None
*/
function player_elec_damage()
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(level.elec_loop))
	{
		level.elec_loop = 0;
	}
	if(!isdefined(self.is_burning) && self.is_burning && zm_utility::is_player_valid(self))
	{
		self.is_burning = 1;
		if(isdefined(level.trap_electric_visionset_registered) && level.trap_electric_visionset_registered)
		{
			visionset_mgr::activate("overlay", "zm_trap_electric", self, 1.25, 1.25);
		}
		else
		{
			self SetElectrified(1.25);
		}
		shocktime = 2.5;
		if(isdefined(level.str_elec_damage_shellshock_override))
		{
			str_elec_shellshock = level.str_elec_damage_shellshock_override;
		}
		else
		{
			str_elec_shellshock = "electrocution";
		}
		self shellshock(str_elec_shellshock, shocktime);
		self PlayRumbleOnEntity("damage_heavy");
		if(level.elec_loop == 0)
		{
			elec_loop = 1;
			self playsound("wpn_zmb_electrap_zap");
		}
		if(!self hasPerk("specialty_armorvest") || self.health - 100 < 1)
		{
			self DoDamage(self.health + 100, self.origin);
			self.is_burning = undefined;
		}
		else
		{
			self DoDamage(50, self.origin);
			wait(0.1);
			self.is_burning = undefined;
		}
	}
}

/*
	Name: player_fire_damage
	Namespace: zm_traps
	Checksum: 0x5BFC8BC9
	Offset: 0x2488
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function player_fire_damage()
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.is_burning) && self.is_burning && !self laststand::player_is_in_laststand())
	{
		self.is_burning = 1;
		if(isdefined(level.trap_fire_visionset_registered) && level.trap_fire_visionset_registered)
		{
			visionset_mgr::activate("overlay", "zm_trap_burn", self, 1.25, 1.25);
		}
		else
		{
			self setburn(1.25);
		}
		self notify("burned");
		if(!self hasPerk("specialty_armorvest") || self.health - 100 < 1)
		{
			RadiusDamage(self.origin, 10, self.health + 100, self.health + 100);
			self.is_burning = undefined;
		}
		else
		{
			self DoDamage(50, self.origin);
			wait(0.1);
			self.is_burning = undefined;
		}
	}
}

/*
	Name: zombie_trap_death
	Namespace: zm_traps
	Checksum: 0xC4D49547
	Offset: 0x2610
	Size: 0x433
	Parameters: 2
	Flags: None
*/
function zombie_trap_death(trap, Param)
{
	self endon("death");
	self.marked_for_death = 1;
	switch(trap._trap_type)
	{
		case "rocket":
		{
			if(isdefined(self.animName) && self.animName != "zombie_dog")
			{
				if(Param > 90 && level.burning_zombies.size < 6)
				{
					level.burning_zombies[level.burning_zombies.size] = self;
					self thread zombie_flame_watch();
					self playsound("zmb_ignite");
					self thread zombie_death::flame_death_fx();
					PlayFXOnTag(level._effect["character_fire_death_torso"], self, "J_SpineLower");
					wait(RandomFloat(1.25));
				}
				else
				{
					refs[0] = "guts";
					refs[1] = "right_arm";
					refs[2] = "left_arm";
					refs[3] = "right_leg";
					refs[4] = "left_leg";
					refs[5] = "no_legs";
					refs[6] = "head";
					self.a.gib_ref = refs[RandomInt(refs.size)];
					playsoundatposition("wpn_zmb_electrap_zap", self.origin);
					wait(RandomFloat(1.25));
					self playsound("wpn_zmb_electrap_zap");
				}
			}
			if(isdefined(self.fire_damage_func))
			{
				self [[self.fire_damage_func]](trap);
			}
			else
			{
				level notify("trap_kill", self, trap);
				self DoDamage(self.health + 666, self.origin, trap);
			}
			break;
		}
		case "centrifuge":
		case "rotating":
		{
			ang = VectorToAngles(trap.origin - self.origin);
			direction_vec = VectorScale(AnglesToRight(ang), Param);
			if(isdefined(self.trap_reaction_func))
			{
				self [[self.trap_reaction_func]](trap);
			}
			level notify("trap_kill", self, trap);
			self StartRagdoll();
			self LaunchRagdoll(direction_vec);
			util::wait_network_frame();
			self.a.gib_ref = "head";
			self DoDamage(self.health, self.origin, trap);
			break;
		}
	}
	if(isdefined(trap.activated_by_player) && isPlayer(trap.activated_by_player))
	{
		trap.activated_by_player zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
	}
}

/*
	Name: zombie_flame_watch
	Namespace: zm_traps
	Checksum: 0x35DA5586
	Offset: 0x2A50
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function zombie_flame_watch()
{
	self waittill("death");
	self StopLoopSound();
	ArrayRemoveValue(level.burning_zombies, self);
}

/*
	Name: play_elec_vocals
	Namespace: zm_traps
	Checksum: 0xA811D04
	Offset: 0x2A98
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function play_elec_vocals()
{
	if(isdefined(self))
	{
		org = self.origin;
		wait(0.15);
		playsoundatposition("zmb_elec_vocals", org);
		playsoundatposition("wpn_zmb_electrap_zap", org);
		playsoundatposition("zmb_exp_jib_zombie", org);
	}
}

/*
	Name: electroctute_death_fx
	Namespace: zm_traps
	Checksum: 0xB0735DA6
	Offset: 0x2B28
	Size: 0x2EB
	Parameters: 0
	Flags: None
*/
function electroctute_death_fx()
{
	self endon("death");
	if(isdefined(self.is_electrocuted) && self.is_electrocuted)
	{
		return;
	}
	self.is_electrocuted = 1;
	self thread electrocute_timeout();
	if(self.team == level.zombie_team)
	{
		level.bcOnFireTime = GetTime();
		level.bcOnFireOrg = self.origin;
	}
	if(isdefined(level._effect["elec_torso"]))
	{
		PlayFXOnTag(level._effect["elec_torso"], self, "J_SpineLower");
	}
	self playsound("zmb_elec_jib_zombie");
	wait(1);
	tagArray = [];
	tagArray[0] = "J_Elbow_LE";
	tagArray[1] = "J_Elbow_RI";
	tagArray[2] = "J_Knee_RI";
	tagArray[3] = "J_Knee_LE";
	tagArray = Array::randomize(tagArray);
	if(isdefined(level._effect["elec_md"]))
	{
		PlayFXOnTag(level._effect["elec_md"], self, tagArray[0]);
	}
	self playsound("zmb_elec_jib_zombie");
	wait(1);
	self playsound("zmb_elec_jib_zombie");
	tagArray[0] = "J_Wrist_RI";
	tagArray[1] = "J_Wrist_LE";
	if(!isdefined(self.a.gib_ref) || self.a.gib_ref != "no_legs")
	{
		tagArray[2] = "J_Ankle_RI";
		tagArray[3] = "J_Ankle_LE";
	}
	tagArray = Array::randomize(tagArray);
	if(isdefined(level._effect["elec_sm"]))
	{
		PlayFXOnTag(level._effect["elec_sm"], self, tagArray[0]);
		PlayFXOnTag(level._effect["elec_sm"], self, tagArray[1]);
	}
}

/*
	Name: electrocute_timeout
	Namespace: zm_traps
	Checksum: 0x28D588F2
	Offset: 0x2E20
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function electrocute_timeout()
{
	self endon("death");
	self PlayLoopSound("amb_fire_manager_0");
	wait(12);
	self StopLoopSound();
	if(isdefined(self) && isalive(self))
	{
		self.is_electrocuted = 0;
		self notify("stop_flame_damage");
	}
}

/*
	Name: trap_dialog
	Namespace: zm_traps
	Checksum: 0x18CA2B0D
	Offset: 0x2EA8
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function trap_dialog()
{
	self endon("warning_dialog");
	level endon("switch_flipped");
	timer = 0;
	while(1)
	{
		wait(0.5);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(!isdefined(players[i]))
			{
				continue;
			}
			dist = DistanceSquared(players[i].origin, self.origin);
			if(dist > 4900)
			{
				timer = 0;
				continue;
			}
			if(dist < 4900 && timer < 3)
			{
				wait(0.5);
				timer++;
			}
			if(dist < 4900 && timer == 3)
			{
				index = zm_utility::get_player_index(players[i]);
				plr = "plr_" + index + "_";
				wait(3);
				self notify("warning_dialog");
			}
		}
	}
}

/*
	Name: get_trap_array
	Namespace: zm_traps
	Checksum: 0xA8A36D08
	Offset: 0x3048
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function get_trap_array(trap_type)
{
	ents = GetEntArray("zombie_trap", "targetname");
	traps = [];
	for(i = 0; i < ents.size; i++)
	{
		if(ents[i].script_noteworthy == trap_type)
		{
			traps[traps.size] = ents[i];
		}
	}
	return traps;
}

/*
	Name: trap_disable
	Namespace: zm_traps
	Checksum: 0x26B078D5
	Offset: 0x3100
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function trap_disable()
{
	Cooldown = self._trap_cooldown_time;
	if(self._trap_in_use)
	{
		self notify("trap_done");
		self._trap_cooldown_time = 0.05;
		self waittill("available");
	}
	Array::thread_all(self._trap_use_trigs, &TriggerEnable, 0);
	self trap_lights_red();
	self._trap_cooldown_time = Cooldown;
}

/*
	Name: trap_enable
	Namespace: zm_traps
	Checksum: 0x9FDBA38B
	Offset: 0x31A0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function trap_enable()
{
	Array::thread_all(self._trap_use_trigs, &TriggerEnable, 1);
	self trap_lights_green();
}

/*
	Name: trap_model_type_init
	Namespace: zm_traps
	Checksum: 0xD7509302
	Offset: 0x31F8
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function trap_model_type_init()
{
	if(!isdefined(self.script_parameters))
	{
		self.script_parameters = "default";
	}
	switch(self.script_parameters)
	{
		case "pentagon_electric":
		{
			self._trap_light_model_off = "zombie_trap_switch_light";
			self._trap_light_model_green = "zombie_trap_switch_light_on_green";
			self._trap_light_model_red = "zombie_trap_switch_light_on_red";
			self._trap_switch_model = "zombie_trap_switch_handle";
			break;
		}
		case "default":
		case default:
		{
			self._trap_light_model_off = "zombie_zapper_cagelight";
			self._trap_light_model_green = "zombie_zapper_cagelight";
			self._trap_light_model_red = "zombie_zapper_cagelight";
			self._trap_switch_model = "zombie_zapper_handle";
			break;
		}
	}
}

/*
	Name: is_trap_registered
	Namespace: zm_traps
	Checksum: 0x374EDD94
	Offset: 0x32D8
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function is_trap_registered(a_registered_traps)
{
	return isdefined(a_registered_traps[self.script_noteworthy]);
}

/*
	Name: register_trap_basic_info
	Namespace: zm_traps
	Checksum: 0x697AD7F
	Offset: 0x3300
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function register_trap_basic_info(str_trap, func_activate, func_audio)
{
	/#
		Assert(isdefined(str_trap), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func_activate), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func_audio), "Dev Block strings are not supported");
	#/
	_register_undefined_trap(str_trap);
	level._custom_traps[str_trap].activate = func_activate;
	level._custom_traps[str_trap].audio = func_audio;
}

/*
	Name: _register_undefined_trap
	Namespace: zm_traps
	Checksum: 0x8EE7D68C
	Offset: 0x33F0
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function _register_undefined_trap(str_trap)
{
	if(!isdefined(level._custom_traps))
	{
		level._custom_traps = [];
	}
	if(!isdefined(level._custom_traps[str_trap]))
	{
		level._custom_traps[str_trap] = spawnstruct();
	}
}

/*
	Name: register_trap_damage
	Namespace: zm_traps
	Checksum: 0xC9FE2270
	Offset: 0x3458
	Size: 0x93
	Parameters: 3
	Flags: None
*/
function register_trap_damage(str_trap, func_player_damage, func_damage)
{
	/#
		Assert(isdefined(str_trap), "Dev Block strings are not supported");
	#/
	_register_undefined_trap(str_trap);
	level._custom_traps[str_trap].player_damage = func_player_damage;
	level._custom_traps[str_trap].damage = func_damage;
}

