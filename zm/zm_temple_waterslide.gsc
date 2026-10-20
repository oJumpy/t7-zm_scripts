#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;

#namespace zm_temple_waterslide;

/*
	Name: precache_assets
	Namespace: zm_temple_waterslide
	Checksum: 0xF2A5FDE1
	Offset: 0x480
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function precache_assets()
{
	level._effect["fx_slide_wake"] = "bio/player/fx_player_water_swim_wake";
	level._effect["fx_slide_splash"] = "bio/player/fx_player_water_splash";
	level._effect["fx_slide_splash_2"] = "env/water/fx_water_splash_fountain_lg";
	level._effect["fx_slide_splash_3"] = "maps/pow/fx_pow_cave_water_splash";
	level._effect["fx_slide_water_fall"] = "maps/pow/fx_pow_cave_water_fall";
}

/*
	Name: waterslide_main
	Namespace: zm_temple_waterslide
	Checksum: 0x9D672953
	Offset: 0x518
	Size: 0x29D
	Parameters: 0
	Flags: None
*/
function waterslide_main()
{
	level flag::init("waterslide_open");
	zombie_cave_slide_init();
	messagetrigger = GetEnt("waterslide_message_trigger", "targetname");
	if(isdefined(messagetrigger))
	{
		messagetrigger setcursorhint("HINT_NOICON");
	}
	cheat = 0;
	/#
		cheat = GetDvarInt("Dev Block strings are not supported") > 0;
	#/
	if(!cheat)
	{
		if(isdefined(messagetrigger))
		{
			messagetrigger setHintString(&"ZOMBIE_NEED_POWER");
		}
		level flag::wait_till("power_on");
		if(isdefined(messagetrigger))
		{
			messagetrigger setHintString(&"ZM_TEMPLE_DESTINATION_NOT_OPEN");
		}
		level flag::wait_till_any(Array("cave01_to_cave02", "pressure_to_cave01"));
	}
	level flag::set("waterslide_open");
	if(isdefined(messagetrigger))
	{
		messagetrigger setHintString("");
	}
	var_144a9b89 = GetEntArray("water_slide_blocker", "targetname");
	if(isdefined(var_144a9b89) && var_144a9b89.size > 0)
	{
		foreach(e_blocker in var_144a9b89)
		{
			e_blocker connectpaths();
			e_blocker MoveZ(128, 1);
		}
	}
	level notify("slide_open");
}

/*
	Name: zombie_cave_slide_init
	Namespace: zm_temple_waterslide
	Checksum: 0x9C1CF1B0
	Offset: 0x7C0
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function zombie_cave_slide_init()
{
	level flag::init("slide_anim_change_allowed");
	level.zombies_slide_anim_change = [];
	level thread slide_anim_change_throttle();
	level flag::set("slide_anim_change_allowed");
	slide_trigs = GetEntArray("zombie_cave_slide", "targetname");
	Array::thread_all(slide_trigs, &slide_trig_watch);
	level thread slide_player_enter_watch();
	level thread slide_player_exit_watch();
	level thread zombie_caveslide_anim_failsafe();
}

/*
	Name: zombie_caveslide_anim_failsafe
	Namespace: zm_temple_waterslide
	Checksum: 0x67FA6AF1
	Offset: 0x8C8
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function zombie_caveslide_anim_failsafe()
{
	trig = GetEnt("zombie_cave_slide_failsafe", "targetname");
	if(isdefined(trig))
	{
		while(1)
		{
			trig waittill("trigger", who);
			if(isdefined(who.sliding) && who.sliding)
			{
				who.sliding = 0;
				who thread reset_zombie_anim();
			}
		}
	}
}

/*
	Name: slide_trig_watch
	Namespace: zm_temple_waterslide
	Checksum: 0xB3C808BC
	Offset: 0x980
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function slide_trig_watch()
{
	slide_node = GetNode(self.target, "targetname");
	if(!isdefined(slide_node))
	{
		return;
	}
	self TriggerEnable(0);
	level waittill("slide_open");
	self TriggerEnable(1);
	while(1)
	{
		self waittill("trigger", who);
		if(who.animName == "zombie" || who.animName == "sonic_zombie" || who.animName == "napalm_zombie")
		{
			if(isdefined(who.sliding) && who.sliding == 1)
			{
				continue;
			}
			else
			{
				who thread zombie_sliding(slide_node);
			}
		}
		else if(isdefined(who.zombie_sliding))
		{
			who thread [[who.zombie_sliding]](slide_node);
		}
	}
}

/*
	Name: zombie_sliding
	Namespace: zm_temple_waterslide
	Checksum: 0xC1FC8D61
	Offset: 0xB00
	Size: 0x26F
	Parameters: 1
	Flags: None
*/
function zombie_sliding(slide_node)
{
	self endon("death");
	level endon("intermission");
	if(!isdefined(self.cave_slide_flag_init))
	{
		self flag::init("slide_anim_change");
		self.cave_slide_flag_init = 1;
	}
	self.is_traversing = 1;
	self notify("zombie_start_traverse");
	self thread zombie_slide_watch();
	self thread play_zombie_slide_looper();
	self.ignore_find_flesh = 1;
	self.sliding = 1;
	self.ignoreall = 1;
	self.b_ignore_cleanup = 1;
	self thread gibbed_while_sliding();
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self.var_9c5ae704 = self.zombie_move_speed;
	self thread set_zombie_slide_anim();
	if(!(isdefined(self.missingLegs) && self.missingLegs))
	{
		self setPhysParams(15, 0, 24);
	}
	self setgoalnode(slide_node);
	check_dist_squared = 3600;
	while(DistanceSquared(self.origin, slide_node.origin) > check_dist_squared)
	{
		wait(0.01);
	}
	self thread reset_zombie_anim();
	if(!(isdefined(self.missingLegs) && self.missingLegs))
	{
		self setPhysParams(15, 0, 72);
	}
	self notify("water_slide_exit");
	self.ignore_find_flesh = 0;
	self.sliding = 0;
	self.is_traversing = 0;
	self notify("zombie_end_traverse");
	self.ignoreall = 0;
	self.b_ignore_cleanup = 0;
	self.ai_state = "find_flesh";
}

/*
	Name: play_zombie_slide_looper
	Namespace: zm_temple_waterslide
	Checksum: 0xC88B4C7F
	Offset: 0xD78
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function play_zombie_slide_looper()
{
	self endon("death");
	level endon("intermission");
	self PlayLoopSound("fly_dtp_slide_loop_npc_snow", 0.5);
	self util::waittill_any("zombie_end_traverse", "death");
	self StopLoopSound(0.5);
}

/*
	Name: set_zombie_slide_anim
	Namespace: zm_temple_waterslide
	Checksum: 0xEFD43C05
	Offset: 0xE08
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function set_zombie_slide_anim()
{
	self.zombie_move_speed = "slide";
}

/*
	Name: reset_zombie_anim
	Namespace: zm_temple_waterslide
	Checksum: 0xE08F3DDC
	Offset: 0xE28
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function reset_zombie_anim()
{
	if(isdefined(self.var_9c5ae704))
	{
		self.zombie_move_speed = self.var_9c5ae704;
	}
}

/*
	Name: death_while_sliding
	Namespace: zm_temple_waterslide
	Checksum: 0xA466B9F
	Offset: 0xE50
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function death_while_sliding()
{
	self endon("death");
	if(self.animName == "sonic_zombie" || self.animName == "napalm_zombie")
	{
		return self.deathAnim;
	}
	death_animation = undefined;
	rand = randomIntRange(1, 5);
	if(!self.missingLegs)
	{
		death_animation = level.scr_anim[self.animName]["attracted_death_" + rand];
	}
	return death_animation;
}

/*
	Name: gibbed_while_sliding
	Namespace: zm_temple_waterslide
	Checksum: 0xB367D0DA
	Offset: 0xF08
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function gibbed_while_sliding()
{
	self endon("death");
	if(self.animName == "sonic_zombie" || self.animName == "napalm_zombie")
	{
		return;
	}
	if(self.missingLegs)
	{
		return;
	}
	while(self.sliding)
	{
		if(self.missingLegs && self._had_legs == 1)
		{
			self thread set_zombie_slide_anim();
			return;
		}
		wait(0.1);
	}
}

/*
	Name: slide_anim_change_throttle
	Namespace: zm_temple_waterslide
	Checksum: 0xD0AC906F
	Offset: 0xFA8
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function slide_anim_change_throttle()
{
	if(!isdefined(level.zombies_slide_anim_change))
	{
		level.zombies_slide_anim_change = [];
	}
	int_max_num_zombies_per_frame = 7;
	array_zombies_allowed_to_switch = [];
	while(isdefined(level.zombies_slide_anim_change))
	{
		if(level.zombies_slide_anim_change.size == 0)
		{
			wait(0.1);
			continue;
		}
		array_zombies_allowed_to_switch = level.zombies_slide_anim_change;
		for(i = 0; i < array_zombies_allowed_to_switch.size; i++)
		{
			if(isdefined(array_zombies_allowed_to_switch[i]) && isalive(array_zombies_allowed_to_switch[i]))
			{
				array_zombies_allowed_to_switch[i] flag::set("slide_anim_change");
			}
			if(i >= int_max_num_zombies_per_frame)
			{
				break;
			}
		}
		level flag::clear("slide_anim_change_allowed");
		for(i = 0; i < array_zombies_allowed_to_switch.size; i++)
		{
			if(array_zombies_allowed_to_switch[i] flag::get("slide_anim_change"))
			{
				level.zombies_slide_anim_change = ArrayRemoveValue(level.zombies_slide_anim_change, array_zombies_allowed_to_switch[i]);
			}
		}
		level.zombies_slide_anim_change = Array::remove_dead(level.zombies_slide_anim_change);
		level flag::set("slide_anim_change_allowed");
		util::wait_network_frame();
		wait(0.1);
	}
}

/*
	Name: array_remove
	Namespace: zm_temple_waterslide
	Checksum: 0xE2DBF2ED
	Offset: 0x11A8
	Size: 0x11B
	Parameters: 2
	Flags: None
*/
function array_remove(Array, object)
{
	if(!isdefined(Array) && !isdefined(object))
	{
		return;
	}
	new_array = [];
	foreach(item in Array)
	{
		if(item != object)
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!IsArray(new_array))
			{
				new_array = Array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: slide_player_enter_watch
	Namespace: zm_temple_waterslide
	Checksum: 0x4CB62C4B
	Offset: 0x12D0
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function slide_player_enter_watch()
{
	level endon("fake_death");
	trig = GetEnt("cave_slide_force_crouch", "targetname");
	while(1)
	{
		trig waittill("trigger", who);
		if(isdefined(who) && isPlayer(who) && who.sessionstate != "spectator" && (!isdefined(who.on_slide) && who.on_slide))
		{
			who.on_slide = 1;
			who thread player_slide_watch();
			who thread zm_audio::create_and_play_dialog("general", "slide");
		}
	}
}

/*
	Name: slide_player_exit_watch
	Namespace: zm_temple_waterslide
	Checksum: 0x37932D7C
	Offset: 0x13F0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function slide_player_exit_watch()
{
	trig = GetEnt("cave_slide_force_stand", "targetname");
	while(1)
	{
		trig waittill("trigger", who);
		if(isdefined(who) && isPlayer(who) && who.sessionstate != "spectator" && (isdefined(who.on_slide) && who.on_slide))
		{
			who.on_slide = 0;
			who notify("water_slide_exit");
		}
	}
}

/*
	Name: player_slide_watch
	Namespace: zm_temple_waterslide
	Checksum: 0x33F89F59
	Offset: 0x14D8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function player_slide_watch()
{
	self thread on_player_enter_slide();
	self thread player_slide_fake_death_watch();
	self util::waittill_any("water_slide_exit", "death", "disconnect");
	if(isdefined(self))
	{
		self thread on_player_exit_slide();
	}
}

/*
	Name: player_slide_fake_death_watch
	Namespace: zm_temple_waterslide
	Checksum: 0x702F4FBB
	Offset: 0x1568
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function player_slide_fake_death_watch()
{
	self endon("death");
	self endon("disconnect");
	self endon("water_slide_exit");
	self waittill("fake_death");
	self AllowStand(1);
	self AllowProne(1);
}

/*
	Name: on_player_enter_slide
	Namespace: zm_temple_waterslide
	Checksum: 0xE46E171E
	Offset: 0x15D8
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function on_player_enter_slide()
{
	self endon("death");
	self endon("disconnect");
	self endon("water_slide_exit");
	self PlayLoopSound("evt_slideloop");
	while(self laststand::player_is_in_laststand())
	{
		self.bleedout_time = 0;
		self playlocalsound(level.zmb_laugh_alias);
		self.on_slide = 0;
		return;
	}
	while(isdefined(self.divetoprone) && self.divetoprone)
	{
		wait(0.1);
	}
	self AllowStand(0);
	self AllowProne(0);
	self SetStance("crouch");
}

/*
	Name: on_player_exit_slide
	Namespace: zm_temple_waterslide
	Checksum: 0x5E2C5038
	Offset: 0x16F0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function on_player_exit_slide()
{
	self endon("death");
	self endon("disconnect");
	self AllowStand(1);
	self AllowProne(1);
	if(!self laststand::player_is_in_laststand())
	{
		self SetStance("stand");
	}
	self StopLoopSound();
}

/*
	Name: zombie_slide_watch
	Namespace: zm_temple_waterslide
	Checksum: 0x5B1E63EC
	Offset: 0x1798
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function zombie_slide_watch()
{
	self thread on_zombie_enter_slide();
	self util::waittill_any("water_slide_exit", "death");
	self thread on_zombie_exit_slide();
}

/*
	Name: on_zombie_enter_slide
	Namespace: zm_temple_waterslide
	Checksum: 0xF73001CC
	Offset: 0x1800
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_zombie_enter_slide()
{
	self PlayLoopSound("evt_slideloop");
}

/*
	Name: on_zombie_exit_slide
	Namespace: zm_temple_waterslide
	Checksum: 0xAF09E203
	Offset: 0x1830
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_zombie_exit_slide()
{
	self StopLoopSound();
}

