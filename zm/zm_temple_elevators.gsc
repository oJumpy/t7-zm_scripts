#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_blockers;
#using scripts\zm\zm_temple;
#using scripts\zm\zm_temple_pack_a_punch;

#namespace zm_temple_elevators;

/*
	Name: init_elevator
	Namespace: zm_temple_elevators
	Checksum: 0x55A9ECBA
	Offset: 0x438
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function init_elevator()
{
	level flag::wait_till("initial_players_connected");
	init_temple_geyser();
}

/*
	Name: init_temple_geyser
	Namespace: zm_temple_elevators
	Checksum: 0x9A7D2048
	Offset: 0x478
	Size: 0x4BD
	Parameters: 0
	Flags: None
*/
function init_temple_geyser()
{
	level.geysers = GetEntArray("temple_geyser", "targetname");
	for(i = 0; i < level.geysers.size; i++)
	{
		level.geysers[i].enabled = 0;
		level.geysers[i].line_emitter = i;
		geyserTrigger = level.geysers[i];
		parms = StrTok(geyserTrigger.script_parameters, ",");
		geyserTrigger.push_x = float(parms[0]);
		geyserTrigger.push_y = float(parms[1]);
		geyserTrigger.push_z = float(parms[2]);
		geyserTrigger.push_time = float(parms[3]);
		geyserTrigger.lift = GetEnt(geyserTrigger.target, "targetname");
		geyserTrigger.bottom = struct::get(geyserTrigger.target, "targetname");
		if(!isdefined(geyserTrigger.bottom.angles))
		{
			geyserTrigger.bottom.angles = (0, 0, 0);
		}
		geyserTrigger.top = struct::get(geyserTrigger.bottom.target, "targetname");
		if(!isdefined(geyserTrigger.top.angles))
		{
			geyserTrigger.top.angles = (0, 0, 0);
		}
		geyserTrigger.trigger_dust = GetEnt("trigger_" + geyserTrigger.script_noteworthy + "_dust", "targetname");
		if(isdefined(geyserTrigger.trigger_dust))
		{
			geyserTrigger.trigger_dust thread geyser_trigger_dust_think();
		}
		if(isdefined(geyserTrigger.script_noteworthy))
		{
			level flag::init(geyserTrigger.script_noteworthy + "_active");
			blocker = GetEnt(geyserTrigger.script_noteworthy + "_blocker", "targetname");
			if(isdefined(blocker))
			{
				geyserTrigger thread geyser_blocker_think(blocker);
			}
			geyserTrigger.jump_down_start = GetNode(geyserTrigger.script_noteworthy + "_jump_down", "targetname");
			if(isdefined(geyserTrigger.jump_down_start))
			{
				SetEnableNode(geyserTrigger.jump_down_start, 0);
				geyserTrigger.jump_down_end = GetNode(geyserTrigger.jump_down_start.target, "targetname");
			}
			geyserTrigger.var_5a14c16 = GetNode(geyserTrigger.script_noteworthy + "_jump_up", "targetname");
			if(isdefined(geyserTrigger.var_5a14c16))
			{
				SetEnableNode(geyserTrigger.var_5a14c16, 0);
			}
		}
	}
}

/*
	Name: alternate_geysers
	Namespace: zm_temple_elevators
	Checksum: 0x8CA64C25
	Offset: 0x940
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function alternate_geysers()
{
	currentGeyser = undefined;
	level waittill("geyser_enabled");
	while(1)
	{
		geysers = [];
		for(i = 0; i < level.geysers.size; i++)
		{
			g = level.geysers[i];
			if(!isdefined(currentGeyser) || g != currentGeyser && g.enabled)
			{
				geysers[geysers.size] = g;
			}
		}
		if(isdefined(currentGeyser))
		{
			currentGeyser notify("geyser_end");
			currentGeyser = undefined;
		}
		if(geysers.size > 0)
		{
			currentGeyser = Array::random(geysers);
			currentGeyser thread geyser_start();
		}
		level waittill("between_round_over");
	}
}

/*
	Name: geyser_start
	Namespace: zm_temple_elevators
	Checksum: 0xC1AC263A
	Offset: 0xA78
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function geyser_start()
{
	self.geyser_active = 0;
	var_f3e27be7 = GetNode(self.script_noteworthy + "_jump_up", "targetname");
	if(isdefined(var_f3e27be7))
	{
		SetEnableNode(var_f3e27be7, 1);
	}
	var_2ba76614 = GetNode(self.script_noteworthy + "_jump_down", "targetname");
	if(isdefined(var_2ba76614))
	{
		SetEnableNode(var_2ba76614, 1);
	}
	self thread geyser_watch_for_player();
}

/*
	Name: geyser_watch_for_zombies
	Namespace: zm_temple_elevators
	Checksum: 0x99FC5013
	Offset: 0xB68
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function geyser_watch_for_zombies()
{
	self endon("geyser_end");
	while(1)
	{
		self waittill("trigger", who);
		if(!self.geyser_active)
		{
			continue;
		}
		if(isai(who))
		{
			who zombie_geyser_kill();
		}
	}
}

/*
	Name: geyser_watch_for_player
	Namespace: zm_temple_elevators
	Checksum: 0xDCC63D98
	Offset: 0xBE0
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function geyser_watch_for_player()
{
	self endon("geyser_end");
	level endon("intermission");
	level endon("fake_death");
	while(1)
	{
		self waittill("trigger", who);
		if(!isPlayer(who))
		{
			continue;
		}
		if(who.sessionstate == "spectator")
		{
			continue;
		}
		if(!self.geyser_active)
		{
			if(who.origin[2] - self.bottom.origin[2] > 70)
			{
				continue;
			}
		}
		if(self.geyser_active)
		{
			who thread player_geyser_move(self);
			continue;
		}
		self playsound("evt_geyser_buildup");
		startTime = GetTime();
		players = GetPlayers();
		while(1)
		{
			playersTouching = [];
			for(i = 0; i < players.size; i++)
			{
				if(players[i] istouching(self))
				{
					playersTouching[playersTouching.size] = players[i];
				}
			}
			if(playersTouching.size == 0)
			{
				break;
			}
			Earthquake(0.2, 0.1, self.bottom.origin, 100);
			if(GetTime() - startTime > 1800)
			{
				self thread geyser_activate(playersTouching);
				break;
			}
			wait(0.1);
		}
	}
}

/*
	Name: geyser_activate
	Namespace: zm_temple_elevators
	Checksum: 0x7A11DFC8
	Offset: 0xE10
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function geyser_activate(playersTouching)
{
	self geyser_erupt(playersTouching);
	wait(5);
}

/*
	Name: geyser_erupt
	Namespace: zm_temple_elevators
	Checksum: 0x39207FB6
	Offset: 0xE48
	Size: 0x1DF
	Parameters: 1
	Flags: None
*/
function geyser_erupt(playersTouching)
{
	self.geyser_active = 1;
	if(isdefined(self.trigger_dust))
	{
		self.trigger_dust thread geyser_trigger_dust_activate();
	}
	self thread geyser_fx();
	if(isdefined(self.line_emitter))
	{
		util::clientNotify("ge" + self.line_emitter);
	}
	for(i = 0; i < playersTouching.size; i++)
	{
		playersTouching[i] thread player_geyser_move(self);
		playersTouching[i] thread zm_audio::create_and_play_dialog("general", "geyser");
	}
	if(isdefined(self.jump_down_start) && isdefined(self.jump_down_end))
	{
		UnlinkNodes(self.jump_down_start, self.jump_down_end);
	}
	level flag::set(self.script_noteworthy + "_active");
	wait(10);
	self notify("stop_geyser_fx");
	level flag::clear(self.script_noteworthy + "_active");
	if(isdefined(self.jump_down_start) && isdefined(self.jump_down_end))
	{
		LinkNodes(self.jump_down_start, self.jump_down_end);
	}
	self.geyser_active = 0;
}

/*
	Name: player_geyser_move
	Namespace: zm_temple_elevators
	Checksum: 0x6F61622B
	Offset: 0x1030
	Size: 0x427
	Parameters: 1
	Flags: None
*/
function player_geyser_move(geyser)
{
	self endon("death");
	self endon("disconnect");
	self endon("spawned_spectator");
	if(isdefined(self.riding_geyser) && self.riding_geyser || (isdefined(self.intermission) && self.intermission))
	{
		return;
	}
	self.riding_geyser = 1;
	if(self laststand::player_is_in_laststand())
	{
		self.geyser_anim = "geyserfakeprone";
	}
	else if(self GetStance() == "prone")
	{
		self clientfield::set("geyserfakeprone", 1);
		self.geyser_anim = "geyserfakeprone";
	}
	else
	{
		self clientfield::set("geyserfakestand", 1);
		self.geyser_anim = "geyserfakestand";
	}
	if(!self laststand::player_is_in_laststand())
	{
		self ghost();
	}
	self.geyser_dust_time = GetTime() + 2000;
	scale = geyser.top.origin[2] - self.origin[2] / geyser.top.origin[2] - geyser.bottom.origin[2];
	scale = math::clamp(scale, 0.4, 1);
	mover = spawn("script_origin", self.origin);
	self playerLinkTo(mover);
	x = geyser.push_x;
	y = geyser.push_y;
	z = geyser.push_z * scale;
	time = geyser.push_time * scale;
	mover MoveGravity((x, y, z), time);
	self player_geyser_move_wait(time);
	vel = self GetVelocity();
	if(isdefined(self))
	{
		self clientfield::set(self.geyser_anim, 0);
		util::wait_network_frame();
		self show();
	}
	self Unlink();
	mover delete();
	if(y > 0)
	{
		self SetVelocity(vel + VectorScale((0, 1, 0), 175));
	}
	else
	{
		self SetVelocity(vel + VectorScale((0, -1, 0), 175));
	}
	wait(0.1);
	self.riding_geyser = 0;
}

/*
	Name: player_geyser_move_wait
	Namespace: zm_temple_elevators
	Checksum: 0x5D188C1F
	Offset: 0x1460
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function player_geyser_move_wait(waitTime)
{
	self endon("death");
	self endon("player_downed");
	wait(waitTime);
}

/*
	Name: geyser_erupt_old
	Namespace: zm_temple_elevators
	Checksum: 0x4A973DD5
	Offset: 0x1490
	Size: 0x2CF
	Parameters: 1
	Flags: None
*/
function geyser_erupt_old(playersTouching)
{
	self.geyser_active = 1;
	self thread geyser_fx();
	moveUpTime = 0.5;
	moveDownTime = 0.1;
	moveDist = 500;
	lift = GetEnt("geyser_lift", "targetname");
	wait(0.1);
	start_origin = self.lift.origin;
	start_angles = self.lift.angles;
	for(i = 0; i < playersTouching.size; i++)
	{
		playersTouching[i] SetPlayerAngles(self.bottom.angles);
	}
	self.lift MoveZ(moveDist, moveUpTime, 0.1, 0.3);
	wait(moveUpTime);
	bounceTime = 0.3;
	bounceDist = 20;
	for(i = 0; i < 2; i++)
	{
		self.lift MoveZ(bounceDist, bounceTime, bounceTime / 2, bounceTime / 2);
		wait(bounceTime);
		self.lift MoveZ(-1 * bounceDist, bounceTime, bounceTime / 2, bounceTime / 2);
		wait(bounceTime);
	}
	self.lift MoveZ(-250, 3, 0.2, 0.2);
	wait(3);
	self.lift notsolid();
	self.lift.angles = start_angles;
	self.lift.origin = start_origin;
	wait(0.1);
	self.lift solid();
	wait(5);
	self notify("stop_geyser_fx");
	self.geyser_active = 0;
}

/*
	Name: geyser_fx
	Namespace: zm_temple_elevators
	Checksum: 0xCD5D42AE
	Offset: 0x1768
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function geyser_fx()
{
	self thread geyser_earthquake();
	fxObj = spawnFx(level._effect["fx_ztem_geyser"], self.bottom.origin);
	triggerFx(fxObj);
	self waittill("stop_geyser_fx");
	wait(5);
	fxObj delete();
}

/*
	Name: geyser_earthquake
	Namespace: zm_temple_elevators
	Checksum: 0x9CA8988C
	Offset: 0x1810
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function geyser_earthquake()
{
	self endon("stop_geyser_fx");
	while(1)
	{
		Earthquake(0.2, 0.1, self.origin, 100);
		wait(0.1);
	}
}

/*
	Name: zombie_geyser_kill
	Namespace: zm_temple_elevators
	Checksum: 0x96B2C951
	Offset: 0x1868
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function zombie_geyser_kill()
{
	self StartRagdoll();
	self LaunchRagdoll((0, 0, 1) * 300);
	util::wait_network_frame();
	self DoDamage(self.health + 666, self.origin);
}

/*
	Name: geyser_blocker_think
	Namespace: zm_temple_elevators
	Checksum: 0xCCF0FC9E
	Offset: 0x18E8
	Size: 0x1B5
	Parameters: 1
	Flags: None
*/
function geyser_blocker_think(blocker)
{
	switch(self.script_noteworthy)
	{
		case "start_geyser":
		{
			level flag::wait_till_any(Array("cave02_to_cave_water", "cave_water_to_power", "cave_water_to_waterfall"));
			exploder::exploder("fxexp_8");
			geyser_sounds("geyser02", "evt_water_spout02", "evt_geyser_amb", 1);
			break;
		}
		case "minecart_geyser":
		{
			level flag::wait_till_any(Array("start_to_pressure", "pressure_to_cave01"));
			level flag::wait_till_any(Array("cave01_to_cave02", "pressure_to_cave01"));
			exploder::exploder("fxexp_9");
			geyser_sounds("geyser01", "evt_water_spout01", "evt_geyser_amb", 1);
		}
		case default:
		{
			break;
		}
	}
	blocker thread geyser_blocker_remove();
	self thread geyser_start();
	self.enabled = 1;
	level notify("geyser_enabled", self);
}

/*
	Name: geyser_sounds
	Namespace: zm_temple_elevators
	Checksum: 0xBDAB0B65
	Offset: 0x1AA8
	Size: 0x10B
	Parameters: 4
	Flags: None
*/
function geyser_sounds(struct_name, sfx_start, sfx_loop, sfx_loop_delay)
{
	sound_struct = struct::get(struct_name, "targetname");
	if(isdefined(sound_struct))
	{
		level thread sound::play_in_space(sfx_start, sound_struct.origin);
		if(isdefined(sfx_loop_delay) && sfx_loop_delay > 0)
		{
			wait(sfx_loop_delay);
		}
		ambient_ent = spawn("script_origin", (0, 0, 1));
		if(isdefined(ambient_ent))
		{
			ambient_ent.origin = sound_struct.origin;
			ambient_ent PlayLoopSound(sfx_loop);
		}
	}
}

/*
	Name: geyser_blocker_remove
	Namespace: zm_temple_elevators
	Checksum: 0x2E58C912
	Offset: 0x1BC0
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function geyser_blocker_remove()
{
	clip = GetEnt(self.target, "targetname");
	clip notsolid();
	clip connectpaths();
	struct = spawnstruct();
	struct.origin = self.origin + VectorScale((0, 0, 1), 500);
	struct.angles = self.angles + VectorScale((0, 1, 0), 180);
	self.script_noteworthy = "jiggle";
	self.script_firefx = "poltergeist";
	self.script_fxid = "large_ceiling_dust";
	self zm_blockers::debris_move(struct);
}

/*
	Name: geyser_trigger_dust_activate
	Namespace: zm_temple_elevators
	Checksum: 0x8F9732DA
	Offset: 0x1CD8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function geyser_trigger_dust_activate()
{
	self TriggerEnable(1);
	wait(3);
	self TriggerEnable(0);
}

/*
	Name: geyser_trigger_dust_think
	Namespace: zm_temple_elevators
	Checksum: 0xF16E40DA
	Offset: 0x1D20
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function geyser_trigger_dust_think()
{
	while(1)
	{
		self waittill("trigger", player);
		if(isdefined(player) && isdefined(player.geyser_dust_time) && player.geyser_dust_time > GetTime())
		{
			playFX(level._effect["player_land_dust"], player.origin);
			player playsound("fly_bodyfall_large_dirt");
			player.geyser_dust_time = 0;
		}
	}
}

/*
	Name: init_geyser_anims
	Namespace: zm_temple_elevators
	Checksum: 0xC1EDE475
	Offset: 0x1DE8
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function init_geyser_anims()
{
	level.geyser_anims = [];
	level.geyser_animtree = -1;
}

/*
	Name: init_animtree
	Namespace: zm_temple_elevators
	Checksum: 0x99EC1590
	Offset: 0x1E10
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_animtree()
{
}

