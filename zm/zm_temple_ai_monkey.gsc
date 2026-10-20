#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_shrink_ray;

#namespace zm_temple_ai_monkey;

/*
	Name: function_dafa313c
	Namespace: zm_temple_ai_monkey
	Checksum: 0x2F097DF8
	Offset: 0xAC0
	Size: 0x43
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_dafa313c()
{
	clientfield::register("scriptmover", "monkey_ragdoll", 21000, 1, "int");
	initmonkeybehaviorsandasm();
}

/*
	Name: initmonkeybehaviorsandasm
	Namespace: zm_temple_ai_monkey
	Checksum: 0xC8165D87
	Offset: 0xB10
	Size: 0x53
	Parameters: 0
	Flags: Private
*/
function private initmonkeybehaviorsandasm()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("templeMonkeyTargetService", &templemonkeytargetservice);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("templeMonkeyDeathStart", &templemonkeydeathstart);
}

/*
	Name: templemonkeytargetservice
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD19AAC9E
	Offset: 0xB70
	Size: 0xF
	Parameters: 1
	Flags: Private
*/
function private templemonkeytargetservice(entity)
{
	return 1;
}

/*
	Name: templemonkeydeathstart
	Namespace: zm_temple_ai_monkey
	Checksum: 0x83574584
	Offset: 0xB88
	Size: 0x51
	Parameters: 1
	Flags: Private
*/
function private templemonkeydeathstart(entity)
{
	if(isdefined(entity.powerup_to_grab))
	{
		entity.powerup_to_grab.claimed = 0;
		level notify("powerup_dropped", entity.powerup_to_grab);
	}
}

/*
	Name: init
	Namespace: zm_temple_ai_monkey
	Checksum: 0xB406CA32
	Offset: 0xBE8
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function init()
{
	precache_ambient_monkey_anims();
	level._effect["monkey_death"] = "maps/zombie/fx_zmb_monkey_death";
	level._effect["monkey_spawn"] = "maps/zombie/fx_zombie_ape_spawn_dust";
	level._effect["monkey_eye_glow"] = "maps/zombie/fx_zmb_monkey_eyes";
	level._effect["monkey_gib"] = "maps/zombie_temple/fx_ztem_zombie_mini_squish";
	level._effect["monkey_gib_no_gore"] = "dlc5/temple/fx_ztem_monkey_shrink";
	level._effect["monkey_launch"] = "weapon/fx_trail_rpg";
	level.monkey_zombie_spawners = GetEntArray("monkey_zombie_spawner", "targetname");
	level.nextMonkeyStealRound = 1;
	level.monkey_zombie_health = level.zombie_vars["zombie_health_start"];
	level.stealer_monkey_spawns = struct::get_array("stealer_monkey_spawn", "targetname");
	level.stealer_monkey_exits = struct::get_array("stealer_monkey_exit", "targetname");
	/#
		cheat = GetDvarInt("Dev Block strings are not supported");
		if(cheat)
		{
			level.nextMonkeyStealRound = 1;
		}
	#/
	level thread _setup_zone_info();
	level thread _watch_for_powerups();
	monkey_ambient_init();
	level thread monkey_grenade_watcher_temple();
}

/*
	Name: monkey_grenade_watcher_temple
	Namespace: zm_temple_ai_monkey
	Checksum: 0x47E93861
	Offset: 0xDE8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function monkey_grenade_watcher_temple()
{
	level flag::wait_till("initial_players_connected");
	level thread zm_ai_monkey::monkey_grenade_watcher();
}

/*
	Name: monkey_templeThink
	Namespace: zm_temple_ai_monkey
	Checksum: 0x2143C89D
	Offset: 0xE30
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function monkey_templeThink(spawner)
{
	self thread _monkey_TempleThinkInternal(spawner);
}

/*
	Name: monkey_GetMonkeySpawnLocation
	Namespace: zm_temple_ai_monkey
	Checksum: 0xF0943F5F
	Offset: 0xE60
	Size: 0x303
	Parameters: 3
	Flags: None
*/
function monkey_GetMonkeySpawnLocation(mindist, checkVisible, skipStartArea)
{
	visitedZones = [];
	needToVisit = [];
	startZone = self _ent_GetZoneName();
	needToVisit[0] = startZone;
	zoneCounter = 0;
	while(needToVisit.size > 0)
	{
		zoneCounter++;
		visitName = needToVisit[0];
		zone = level.zones[visitName];
		if(isdefined(zone.barriers) && (!skipStartArea || startZone != visitName))
		{
			barriers = array_randomize_knuth(zone.barriers);
			for(i = 0; i < barriers.size; i++)
			{
				text = "Zone: " + zoneCounter + " Barrier: " + i;
				if(barriers[i] barrier_test(zone, self, mindist, checkVisible))
				{
					location = getBarrierAttackLocation(barriers[i]);
					return location;
				}
			}
		}
		visitedZones[visitedZones.size] = visitName;
		ArrayRemoveIndex(needToVisit, 0);
		azkeys = getArrayKeys(zone.adjacent_zones);
		azkeys = array_randomize_knuth(azkeys);
		for(i = 0; i < azkeys.size; i++)
		{
			name = azkeys[i];
			if(!IsInArray(visitedZones, name))
			{
				adjZone = zone.adjacent_zones[name];
				globalZone = level.zones[name];
				if(adjZone.is_connected && globalZone.is_enabled)
				{
					needToVisit[needToVisit.size] = name;
				}
			}
		}
	}
	return undefined;
}

/*
	Name: barrier_test
	Namespace: zm_temple_ai_monkey
	Checksum: 0x6B4A293A
	Offset: 0x1170
	Size: 0x18F
	Parameters: 4
	Flags: None
*/
function barrier_test(zone, ent, mindist, checkVisible)
{
	if(!zone.is_active)
	{
		return 1;
	}
	minDist2 = mindist * mindist;
	distToBarrier = DistanceSquared(ent.origin, self.origin);
	if(distToBarrier < minDist2)
	{
		return 0;
	}
	if(checkVisible)
	{
		PlayerVisDist = 1800;
		playerVisDist2 = PlayerVisDist * PlayerVisDist;
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			distToPlayer2 = DistanceSquared(player.origin, self.origin);
			if(distToPlayer2 < playerVisDist2)
			{
				if(self player_can_see_me(player))
				{
					return 0;
				}
			}
		}
	}
	return 1;
}

/*
	Name: ent_GatherValidBarriers
	Namespace: zm_temple_ai_monkey
	Checksum: 0xBE00DFDE
	Offset: 0x1308
	Size: 0x1FD
	Parameters: 3
	Flags: None
*/
function ent_GatherValidBarriers(zoneOverride, ignoreOccupied, ignoreVisible)
{
	valid_barriers = [];
	monkeyZone = zoneOverride;
	if(!isdefined(monkeyZone))
	{
		monkeyZone = self _ent_GetZoneName();
	}
	if(isdefined(monkeyZone))
	{
		s = spawnstruct();
		zoneNames = _getConnectedZoneNames(monkeyZone, s);
		players = GetPlayers();
		for(i = 0; i < zoneNames.size; i++)
		{
			name = zoneNames[i];
			zone = level.zones[name];
			if(isdefined(ignoreOccupied) && ignoreOccupied && zone.is_occupied)
			{
				continue;
			}
			barriers = [];
			if(isdefined(ignoreVisible) && ignoreVisible)
			{
				barriers = _get_non_visible_barriers(zone.barriers);
			}
			else if(isdefined(zone.barriers))
			{
				barriers = zone.barriers;
			}
			if(barriers.size > 0)
			{
				valid_barriers = ArrayCombine(valid_barriers, barriers, 0, 0);
			}
		}
	}
	return valid_barriers;
}

/*
	Name: printText
	Namespace: zm_temple_ai_monkey
	Checksum: 0x1E5D3ABB
	Offset: 0x1510
	Size: 0x187
	Parameters: 2
	Flags: None
*/
function printText(text, red)
{
	level endon("stopPrints");
	if(!isdefined(level.printOffsets))
	{
		level.printOffsets = [];
	}
	originStr = "(" + self.origin[0] + "," + self.origin[1] + "," + self.origin[2] + ")";
	if(!isdefined(level.printOffsets[originStr]))
	{
		level.printOffsets[originStr] = (0, 0, 0);
	}
	else
	{
		level.printOffsets[originStr] = level.printOffsets[originStr] + VectorScale((0, 0, 1), 20);
	}
	offset = VectorScale((0, 0, 1), 45) + level.printOffsets[originStr];
	color = (0, 1, 0);
	if(isdefined(red) && red)
	{
		color = (1, 0, 0);
	}
	while(1)
	{
		/#
			print3d(self.origin + offset, text, color, 0.85);
		#/
		wait(0.05);
	}
}

/*
	Name: printTextStop
	Namespace: zm_temple_ai_monkey
	Checksum: 0x995768AB
	Offset: 0x16A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function printTextStop()
{
	level notify("stopPrints");
	level.printOffsets = [];
}

/*
	Name: _get_non_visible_barriers
	Namespace: zm_temple_ai_monkey
	Checksum: 0xE30AD362
	Offset: 0x16C8
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function _get_non_visible_barriers(barriers)
{
	returnBarriers = [];
	if(isdefined(barriers))
	{
		players = GetPlayers();
		for(i = 0; i < barriers.size; i++)
		{
			cansee = 0;
			for(j = 0; j < players.size; j++)
			{
				if(Abs(barriers[i].origin[2] - players[j].origin[2]) < 200)
				{
					if(barriers[i] player_can_see_me(players[j]))
					{
						cansee = 1;
						break;
					}
				}
			}
			if(!cansee)
			{
				returnBarriers[returnBarriers.size] = barriers[i];
			}
		}
	}
	return returnBarriers;
}

/*
	Name: player_can_see_me
	Namespace: zm_temple_ai_monkey
	Checksum: 0xE24E9C6D
	Offset: 0x1828
	Size: 0x1BF
	Parameters: 1
	Flags: None
*/
function player_can_see_me(player)
{
	playerAngles = player getPlayerAngles();
	playerForwardVec = AnglesToForward(playerAngles);
	playerUnitForwardVec = VectorNormalize(playerForwardVec);
	banzaiPos = self.origin;
	playerpos = player geteyeapprox();
	playerToBanzaiVec = banzaiPos - playerpos;
	playerToBanzaiUnitVec = VectorNormalize(playerToBanzaiVec);
	forwardDotBanzai = VectorDot(playerUnitForwardVec, playerToBanzaiUnitVec);
	angleFromCenter = ACos(forwardDotBanzai);
	playerFOV = GetDvarFloat("cg_fov");
	banzaiVsPlayerFOVBuffer = GetDvarFloat("g_banzai_player_fov_buffer");
	if(banzaiVsPlayerFOVBuffer <= 0)
	{
		banzaiVsPlayerFOVBuffer = 0.2;
	}
	playerCanSeeMe = angleFromCenter <= playerFOV * 0.5 * 1 - banzaiVsPlayerFOVBuffer;
	return playerCanSeeMe;
}

/*
	Name: function_16882cf8
	Namespace: zm_temple_ai_monkey
	Checksum: 0xDF42307C
	Offset: 0x19F0
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function function_16882cf8(loc, color)
{
	while(1)
	{
		/#
			circle(loc, 16, color, 0, 1, 800);
		#/
		wait(0.05);
	}
}

/*
	Name: getBarrierAttackLocation
	Namespace: zm_temple_ai_monkey
	Checksum: 0xA514484
	Offset: 0x1A50
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function getBarrierAttackLocation(barrier)
{
	FORWARD = AnglesToForward(barrier.angles);
	attack_location = barrier.origin + FORWARD * 80;
	attack_location = GetClosestPointOnNavMesh(attack_location, 200);
	return attack_location;
}

/*
	Name: _ent_GetZone
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD321CACC
	Offset: 0x1AE0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function _ent_GetZone()
{
	zoneName = self _ent_GetZoneName();
	if(isdefined(zoneName))
	{
		return level.zones[zoneName];
	}
	return undefined;
}

/*
	Name: _ent_GetZoneName
	Namespace: zm_temple_ai_monkey
	Checksum: 0xC8B17919
	Offset: 0x1B30
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function _ent_GetZoneName()
{
	zkeys = getArrayKeys(level.zones);
	for(z = 0; z < zkeys.size; z++)
	{
		zoneName = zkeys[z];
		zone = level.zones[zoneName];
		for(V = 0; V < zone.Volumes.size; V++)
		{
			touching = self istouching(zone.Volumes[V]);
			if(touching)
			{
				return zoneName;
			}
		}
	}
	return undefined;
}

/*
	Name: _setup_zone_info
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD0DBAC82
	Offset: 0x1C38
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function _setup_zone_info()
{
	wait(1);
	checkEnt = spawn("script_origin", (0, 0, 0));
	for(i = 0; i < level.exterior_goals.size; i++)
	{
		goal = level.exterior_goals[i];
		FORWARD = AnglesToForward(goal.angles);
		checkEnt.origin = goal.origin + FORWARD * 100;
		zoneName = checkEnt _ent_GetZoneName();
		valid = isdefined(zoneName) && isdefined(level.zones[zoneName]);
		if(!valid)
		{
			/#
				iprintln("Dev Block strings are not supported" + checkEnt.origin);
			#/
			continue;
		}
		goal.zoneName = zoneName;
		zone = level.zones[zoneName];
		if(!isdefined(zone.barriers))
		{
			zone.barriers = [];
		}
		zone.barriers[zone.barriers.size] = goal;
	}
	checkEnt delete();
}

/*
	Name: _monkey_TempleThinkInternal
	Namespace: zm_temple_ai_monkey
	Checksum: 0x20B6862C
	Offset: 0x1E28
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function _monkey_TempleThinkInternal(spawner)
{
	self endon("death");
	spawner.count = 100;
	spawner.last_spawn_time = GetTime();
	playFX(level._effect["monkey_death"], self.origin);
	playsoundatposition("zmb_bolt", self.origin);
	self.deathFunction = &_monkey_zombieTempleDeathCallback;
	self.spawnZone = spawner.script_noteworthy;
	self.shrink_ray_fling = &_monkey_TempleFling;
	self thread monkey_zombie_choose_sprint_temple();
	self thread _monkey_GotoBoards();
}

/*
	Name: monkey_zombie_choose_run_temple
	Namespace: zm_temple_ai_monkey
	Checksum: 0x8E70BC11
	Offset: 0x1F30
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function monkey_zombie_choose_run_temple(moveplaybackrate)
{
	self.zombie_move_speed = "run";
	self zombie_utility::set_zombie_run_cycle("run");
}

/*
	Name: monkey_zombie_choose_sprint_temple
	Namespace: zm_temple_ai_monkey
	Checksum: 0x2F967968
	Offset: 0x1F78
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function monkey_zombie_choose_sprint_temple(moveplaybackrate)
{
	self.zombie_move_speed = "sprint";
	self zombie_utility::set_zombie_run_cycle("sprint");
}

/*
	Name: _monkey_zombieTempleDeathCallback
	Namespace: zm_temple_ai_monkey
	Checksum: 0x3D4F36FC
	Offset: 0x1FC0
	Size: 0x125
	Parameters: 8
	Flags: None
*/
function _monkey_zombieTempleDeathCallback(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	self zombie_utility::reset_attack_spot();
	self.grenadeAmmo = 0;
	self thread zombie_utility::zombie_eye_glow_stop();
	playFX(level._effect["monkey_death"], self.origin);
	if(isdefined(self.attacker) && isPlayer(self.attacker))
	{
		self.attacker zm_audio::create_and_play_dialog("kill", "thief");
	}
	if(self.damageMod == "MOD_BURNED")
	{
		self thread zombie_death::flame_death_fx();
	}
	return 0;
}

/*
	Name: _monkey_GotoBoards
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD277B31E
	Offset: 0x20F0
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function _monkey_GotoBoards()
{
	self endon("death");
	self endon("shrink");
	barriers = level.zones[self.spawnZone].barriers;
	if(!isdefined(barriers))
	{
		barriers = [];
	}
	barriers = _sort_by_num_boards(barriers);
	for(i = 0; i < barriers.size; i++)
	{
		barrier = barriers[i];
		location = getBarrierAttackLocation(barrier);
		self.goalRadius = 32;
		self setgoalpos(location);
		self waittill("goal");
		self setgoalpos(self.origin);
		while(1)
		{
			chunk = _find_chunk(barrier.barrier_chunks);
			if(!isdefined(chunk))
			{
				break;
			}
			self _monkey_DestroyBoards(barrier, chunk, location);
		}
	}
	self _monkey_remove();
}

/*
	Name: _find_chunk
	Namespace: zm_temple_ai_monkey
	Checksum: 0x1E9DCD37
	Offset: 0x2290
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function _find_chunk(barrier_chunks)
{
	/#
		Assert(isdefined(barrier_chunks), "Dev Block strings are not supported");
	#/
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(barrier_chunks[i] zm_utility::get_chunk_state() == "repaired")
		{
			return barrier_chunks[i];
		}
	}
	return undefined;
}

/*
	Name: _monkey_DestroyBoards
	Namespace: zm_temple_ai_monkey
	Checksum: 0x7D74EF5A
	Offset: 0x2330
	Size: 0x1B9
	Parameters: 3
	Flags: None
*/
function _monkey_DestroyBoards(barrier, chunk, location)
{
	chunk zm_blockers::update_states("target_by_zombie");
	self teleport(location, self.angles);
	time = self GetAnimLengthFromASD("zm_attack_perks_front", 0);
	self thread zm_ai_monkey::play_attack_impacts(time);
	zombie_shared::DoNoteTracks("attack_perks_front");
	playFX(level._effect["wood_chunk_destory"], chunk.origin);
	if(chunk.script_noteworthy == "4" || chunk.script_noteworthy == "6")
	{
		chunk thread zm_spawner::zombie_boardtear_offset_fx_horizontle(chunk, barrier);
	}
	else
	{
		chunk thread zm_spawner::zombie_boardtear_offset_fx_verticle(chunk, barrier);
	}
	level thread zm_blockers::remove_chunk(chunk, barrier, 1, self);
	chunk zm_blockers::update_states("destroyed");
	chunk notify("destroyed");
	wait(time);
}

/*
	Name: _sort_by_num_boards
	Namespace: zm_temple_ai_monkey
	Checksum: 0x542D9B90
	Offset: 0x24F8
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function _sort_by_num_boards(barriers)
{
	return barriers;
}

/*
	Name: _watch_for_powerups
	Namespace: zm_temple_ai_monkey
	Checksum: 0x18DC800C
	Offset: 0x2510
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function _watch_for_powerups()
{
	if(!isdefined(level.monkey_zombie_spawners) || level.monkey_zombie_spawners.size == 0)
	{
		return;
	}
	while(1)
	{
		level waittill("powerup_dropped", powerup);
		if(!isdefined(powerup))
		{
			continue;
		}
		if(level.round_number < level.nextMonkeyStealRound)
		{
			continue;
		}
		wait(RandomFloatRange(0, 1));
		if(_canGrabPowerup(powerup))
		{
			_grab_powerup(powerup);
		}
	}
}

/*
	Name: _canGrabPowerup
	Namespace: zm_temple_ai_monkey
	Checksum: 0xEB0AAC2
	Offset: 0x25E0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function _canGrabPowerup(powerup)
{
	return isdefined(powerup) && (!isdefined(powerup.claimed) || !powerup.claimed);
}

/*
	Name: _grab_powerup
	Namespace: zm_temple_ai_monkey
	Checksum: 0x7CC7DDBA
	Offset: 0x2620
	Size: 0x257
	Parameters: 1
	Flags: None
*/
function _grab_powerup(powerup)
{
	spawner = level.monkey_zombie_spawners[0];
	monkey = zombie_utility::spawn_zombie(spawner);
	if(!isdefined(monkey))
	{
		return;
	}
	level.nextMonkeyStealRound = 1;
	/#
		cheat = GetDvarInt("Dev Block strings are not supported");
		if(cheat)
		{
			level.nextMonkeyStealRound = 1;
		}
	#/
	monkey.ignore_enemy_count = 1;
	monkey.meleeDamage = 10;
	monkey.custom_damage_func = &monkey_temple_custom_damage;
	location = monkey _monkey_GetSpawnLocation(powerup);
	monkey ForceTeleport(location, monkey.angles);
	monkey.deathFunction = &_monkey_zombieTempleEscapeDeathCallback;
	monkey.shrink_ray_fling = &_monkey_TempleFling;
	monkey.zombie_sliding = &_monkey_TempleSliding;
	monkey.no_shrink = 0;
	monkey.ignore_solo_last_stand = 1;
	spawner.count = 100;
	spawner.last_spawn_time = GetTime();
	monkey thread monkey_zombie_choose_sprint_temple();
	monkey.powerup_to_grab = powerup;
	monkey thread _monkey_zombie_grenade_watcher();
	monkey thread _monkey_CheckPlayableArea();
	monkey thread _monkey_timeout();
	monkey thread _monkey_StealPowerup();
	monkey.zombie_think_done = 1;
}

/*
	Name: _monkey_play_stolen_loop
	Namespace: zm_temple_ai_monkey
	Checksum: 0x176B5B85
	Offset: 0x2880
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function _monkey_play_stolen_loop()
{
	self endon("death");
	self endon("powerup_dropped");
	while(1)
	{
		playsoundatposition("zmb_stealer_stolen", self.origin);
		wait(0.845);
	}
}

/*
	Name: _monkey_GetSpawnLocation
	Namespace: zm_temple_ai_monkey
	Checksum: 0xEACAB488
	Offset: 0x28D8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function _monkey_GetSpawnLocation(e_powerup)
{
	v_best = self monkey_GetMonkeySpawnLocation(700, 0, 1);
	if(!isdefined(v_best))
	{
		v_best = self monkey_GetMonkeySpawnLocation(700, 1, 0);
	}
	if(!isdefined(v_best))
	{
		v_best = self monkey_GetMonkeySpawnLocation(0, 0, 0);
	}
	if(!isdefined(v_best) && isdefined(e_powerup))
	{
		v_best = getBarrierAttackLocation(e_powerup);
	}
	return v_best;
}

/*
	Name: _monkey_StealPowerup
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD66C5F06
	Offset: 0x29A8
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function _monkey_StealPowerup()
{
	self endon("death");
	self endon("end_monkey_steal");
	self _monkey_GrabPowerup();
	if(!isdefined(self.powerup) && (!isdefined(self.attack_player) && self.attack_player))
	{
		self monkey_attack_player();
	}
	self thread _monkey_PathCheck();
	self _monkey_Escape();
}

/*
	Name: _monkey_PathCheck
	Namespace: zm_temple_ai_monkey
	Checksum: 0x176E26C9
	Offset: 0x2A50
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function _monkey_PathCheck()
{
	self notify("end_pathcheck");
	self endon("end_pathcheck");
	self endon("escape_goal");
	self endon("death");
	self waittill("bad_path");
	self notify("end_monkey_steal");
	self.melee_count = 0;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(zombie_utility::is_player_valid(players[i]))
		{
			self.player_stole_power_up = players[i];
		}
	}
	self monkey_attack_player();
	self thread _monkey_StealPowerup();
}

/*
	Name: _monkey_GrabPowerup
	Namespace: zm_temple_ai_monkey
	Checksum: 0x11E9F4DB
	Offset: 0x2B58
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function _monkey_GrabPowerup()
{
	if(isdefined(self.powerup_to_grab))
	{
		self.goalRadius = 16;
		powerup_pos = GetClosestPointOnNavMesh(self.powerup_to_grab.origin, 200);
		self setgoalpos(powerup_pos);
		self _monkey_Grap_powerup_wait();
	}
	if(_canGrabPowerup(self.powerup_to_grab))
	{
		self monkey_zombie_choose_run_temple();
		self.powerup_to_grab show();
		self _monkey_BindPowerup(self.powerup_to_grab);
		self.powerup = self.powerup_to_grab;
		self.powerup_to_grab = undefined;
		if(isdefined(self.powerup.grab_count))
		{
			self.powerup.grab_count++;
		}
		else
		{
			self.powerup.grab_count = 1;
		}
		self.powerup thread powerup_red(self);
		self.powerup thread _powerup_Randomize(self);
		self thread _monkey_play_stolen_loop();
		self.powerup.stolen = 1;
		self.powerup notify("powerup_grabbed");
		self thread player_random_response_to_theft();
	}
}

/*
	Name: player_random_response_to_theft
	Namespace: zm_temple_ai_monkey
	Checksum: 0x9947F194
	Offset: 0x2D30
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function player_random_response_to_theft()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(DistanceSquared(self.origin, players[i].origin) <= 250000)
		{
			players[i] thread zm_audio::create_and_play_dialog("general", "thief_steal");
			return;
		}
	}
}

/*
	Name: _monkey_Grap_powerup_wait
	Namespace: zm_temple_ai_monkey
	Checksum: 0x561FCE2E
	Offset: 0x2DE8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function _monkey_Grap_powerup_wait()
{
	self endon("goal");
	self.powerup_to_grab waittill("death");
	self.player_stole_power_up = self.powerup_to_grab.power_up_grab_player;
}

/*
	Name: powerup_red
	Namespace: zm_temple_ai_monkey
	Checksum: 0xB2673D07
	Offset: 0x2E30
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function powerup_red(monkey)
{
	monkey endon("death");
	self.fx_red = zm_net::network_safe_spawn("monkey_red_powerup", 2, "script_model", self.origin);
	self.fx_red SetModel("tag_origin");
	self.fx_red LinkTo(self);
	PlayFXOnTag(level._effect["powerup_on_red"], self.fx_red, "tag_origin");
	self clientfield::set("powerup_fx", 3);
}

/*
	Name: _monkey_Escape
	Namespace: zm_temple_ai_monkey
	Checksum: 0x423E6B8A
	Offset: 0x2F18
	Size: 0x323
	Parameters: 0
	Flags: None
*/
function _monkey_Escape()
{
	self endon("death");
	self endon("end_monkey_steal");
	self notify("stop_find_flesh");
	self.escaping = 1;
	self _monkey_add_time();
	location = (0, 0, 0);
	angles = (0, 0, 0);
	playExitAnim = 0;
	if(level.stealer_monkey_exits.size > 0)
	{
		playExitAnim = 1;
		randStruct = Array::random(level.stealer_monkey_exits);
		location = randStruct.origin;
		angles = randStruct.angles;
	}
	else
	{
		valid_escapes = self ent_GatherValidBarriers();
		maxdist = 0;
		bestBarrier = undefined;
		for(i = 0; i < valid_escapes.size; i++)
		{
			dist2 = DistanceSquared(self.origin, valid_escapes[i].origin);
			if(dist2 > maxdist)
			{
				maxdist = dist2;
				bestBarrier = valid_escapes[i];
			}
		}
		location = getBarrierAttackLocation(bestBarrier);
	}
	self.goalRadius = 8;
	location = GetClosestPointOnNavMesh(location, 200);
	self setgoalpos(location);
	self waittill("goal");
	self notify("escape_goal");
	if(playExitAnim)
	{
		if(!isdefined(angles))
		{
			angles = (0, 0, 0);
		}
		escape_anim = "rtrg_ai_zm_dlc5_monkey_pap_escape";
		time = getanimlength(escape_anim);
		self AnimScripted("escape_anim", self.origin, self.angles, escape_anim);
		wait(time);
	}
	hasPowerUp = isdefined(self.powerup);
	if(hasPowerUp)
	{
		level notify("monkey_powerup_escape");
	}
	level thread escape_monkey_counter(hasPowerUp);
	self _monkey_remove();
}

/*
	Name: escape_monkey_counter
	Namespace: zm_temple_ai_monkey
	Checksum: 0xDF23E1C6
	Offset: 0x3248
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function escape_monkey_counter(hasPowerUp)
{
	if(!isdefined(level.monkey_escape_count))
	{
		level.monkey_escape_count = 0;
		level.monkey_escape_with_powerup_count = 0;
	}
	level.monkey_escape_count++;
	if(hasPowerUp)
	{
		level.monkey_escape_with_powerup_count++;
	}
	if(level.monkey_escape_with_powerup_count % 5 == 0)
	{
		level thread launch_monkey();
	}
}

/*
	Name: launch_monkey
	Namespace: zm_temple_ai_monkey
	Checksum: 0xA9EE6BD7
	Offset: 0x32C8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function launch_monkey()
{
	effectEnt = spawn("script_model", (-24, 1448, 1000));
	if(isdefined(effectEnt))
	{
		effectEnt endon("death");
		effectEnt SetModel("tag_origin");
		effectEnt.angles = VectorScale((1, 0, 0), 90);
		PlayFXOnTag(level._effect["monkey_launch"], effectEnt, "tag_origin");
		launchTime = 6;
		effectEnt moveto(effectEnt.origin + VectorScale((0, 0, 1), 2500), launchTime, 3);
		wait(launchTime);
		effectEnt delete();
	}
}

/*
	Name: _monkey_CheckPlayableArea
	Namespace: zm_temple_ai_monkey
	Checksum: 0xA9D6105D
	Offset: 0x3400
	Size: 0x16F
	Parameters: 0
	Flags: None
*/
function _monkey_CheckPlayableArea()
{
	self endon("death");
	canDamage = 1;
	areas = GetEntArray("player_volume", "script_noteworthy");
	while(1)
	{
		inArea = 0;
		for(i = 0; i < areas.size && !inArea; i++)
		{
			inArea = self istouching(areas[i]);
		}
		if(canDamage && !inArea)
		{
			/#
				println("Dev Block strings are not supported");
			#/
			canDamage = 0;
			self util::magic_bullet_shield();
		}
		else if(!canDamage && inArea)
		{
			/#
				println("Dev Block strings are not supported");
			#/
			canDamage = 1;
			self util::stop_magic_bullet_shield();
		}
		wait(0.2);
	}
}

/*
	Name: _monkey_timeout
	Namespace: zm_temple_ai_monkey
	Checksum: 0x91A5A15E
	Offset: 0x3578
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function _monkey_timeout()
{
	self endon("death");
	if(!isdefined(self.endTime))
	{
		self.endTime = GetTime() + 60000;
	}
	while(self.endTime > GetTime())
	{
		wait(0.5);
	}
	self _monkey_remove();
}

/*
	Name: _monkey_add_time
	Namespace: zm_temple_ai_monkey
	Checksum: 0xCDF54B17
	Offset: 0x35E8
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function _monkey_add_time()
{
	self.endTime = GetTime() + 60000;
}

/*
	Name: _monkey_zombieTempleEscapeDeathCallback
	Namespace: zm_temple_ai_monkey
	Checksum: 0x15B32224
	Offset: 0x3608
	Size: 0x285
	Parameters: 8
	Flags: None
*/
function _monkey_zombieTempleEscapeDeathCallback(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	self.grenadeAmmo = 0;
	playsoundatposition("zmb_stealer_death", self.origin);
	self thread zombie_utility::zombie_eye_glow_stop();
	if(isdefined(self.attacker) && isPlayer(self.attacker))
	{
		self.attacker zm_audio::create_and_play_dialog("kill", "thief");
		isFavoriteEnemy = isdefined(self.favoriteenemy) && self.favoriteenemy == self.attacker;
		noMeleeHits = !isdefined(self.melee_count) || self.melee_count == 0;
		if(isdefined(self.attacking_player) && self.attacking_player && noMeleeHits && isFavoriteEnemy)
		{
			self.attacker zm_score::player_add_points("thundergun_fling", 500, (0, 0, 0), 0);
		}
	}
	if(isdefined(self.attacker) && isPlayer(self.attacker))
	{
		self.attacker zm_score::player_add_points("damage");
	}
	if(isdefined(self.powerup))
	{
		self _monkey_dropStolenPowerUp();
	}
	if("rottweil72_upgraded_zm" == self.damageWeapon.name && "MOD_RIFLE_BULLET" == self.damageMod)
	{
		self thread _monkey_temple_dragons_breath_flame_death_fx();
	}
	if(isdefined(self.do_gib_death) && self.do_gib_death)
	{
		self thread _monkey_gib();
		self util::delay(0.05, undefined, &zm_utility::self_delete);
	}
	return 0;
}

/*
	Name: _monkey_temple_dragons_breath_flame_death_fx
	Namespace: zm_temple_ai_monkey
	Checksum: 0xF9AA0D5D
	Offset: 0x3898
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function _monkey_temple_dragons_breath_flame_death_fx()
{
	if(self.isdog)
	{
		return;
	}
	if(!isdefined(level._effect) || !isdefined(level._effect["character_fire_death_sm"]))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	PlayFXOnTag(level._effect["character_fire_death_sm"], self, "J_SpineLower");
	tagArray = [];
	if(!isdefined(self.a.gib_ref) || self.a.gib_ref != "left_arm")
	{
		tagArray[tagArray.size] = "J_Elbow_LE";
		tagArray[tagArray.size] = "J_Wrist_LE";
	}
	if(!isdefined(self.a.gib_ref) || self.a.gib_ref != "right_arm")
	{
		tagArray[tagArray.size] = "J_Elbow_RI";
		tagArray[tagArray.size] = "J_Wrist_RI";
	}
	if(!isdefined(self.a.gib_ref) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "left_leg"))
	{
		tagArray[tagArray.size] = "J_Knee_LE";
		tagArray[tagArray.size] = "J_Ankle_LE";
	}
	if(!isdefined(self.a.gib_ref) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "right_leg"))
	{
		tagArray[tagArray.size] = "J_Knee_RI";
		tagArray[tagArray.size] = "J_Ankle_RI";
	}
	tagArray = Array::randomize(tagArray);
	PlayFXOnTag(level._effect["character_fire_death_sm"], self, tagArray[0]);
}

/*
	Name: _monkey_dropStolenPowerUp
	Namespace: zm_temple_ai_monkey
	Checksum: 0x3705B379
	Offset: 0x3B28
	Size: 0x1C1
	Parameters: 0
	Flags: None
*/
function _monkey_dropStolenPowerUp()
{
	returnPowerUp = self.powerup;
	if(isdefined(self.powerup))
	{
		self notify("powerup_dropped");
		self.powerup notify("stop_randomize");
		if(isdefined(self.powerup.fx_red))
		{
			self.powerup.fx_red util::delay(0.1, undefined, &zm_utility::self_delete);
			self.powerup.fx_red = undefined;
		}
		self.powerup.claimed = 0;
		level notify("powerup_dropped", self.powerup);
		origin = self.origin;
		if(isdefined(self.is_traversing) && self.is_traversing)
		{
			origin = zm_utility::GROUNDPOS(self.origin + VectorScale((0, 0, 1), 10));
		}
		origin = origin + VectorScale((0, 0, 1), 40);
		self.powerup Unlink();
		self.powerup.origin = origin;
		self.powerup thread zm_powerups::powerup_timeout();
		self.powerup thread zm_powerups::powerup_wobble();
		self.powerup thread zm_powerups::powerup_grab();
		self.powerup = undefined;
	}
	return returnPowerUp;
}

/*
	Name: _monkey_remove
	Namespace: zm_temple_ai_monkey
	Checksum: 0x22CBE561
	Offset: 0x3CF8
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function _monkey_remove(playFX)
{
	self notify("remove");
	if(!isdefined(playFX))
	{
		playFX = 1;
	}
	if(isdefined(self.powerup))
	{
		if(isdefined(self.powerup.fx_red))
		{
			self.powerup.fx_red delete();
			self.powerup.fx_red = undefined;
		}
		self.powerup zm_powerups::powerup_delete();
	}
	self thread zombie_utility::zombie_eye_glow_stop();
	self delete();
}

/*
	Name: _getConnectedZoneNames
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD688FA7F
	Offset: 0x3DD0
	Size: 0x1BD
	Parameters: 2
	Flags: None
*/
function _getConnectedZoneNames(zoneName, params)
{
	if(!isdefined(params.tested))
	{
		params.tested = [];
	}
	ret = [];
	if(!isdefined(params.tested[zoneName]))
	{
		ret[0] = zoneName;
		params.tested[zoneName] = 1;
		zone = level.zones[zoneName];
		azkeys = getArrayKeys(zone.adjacent_zones);
		for(i = 0; i < azkeys.size; i++)
		{
			name = azkeys[i];
			adjZone = zone.adjacent_zones[name];
			globalZone = level.zones[name];
			if(adjZone.is_connected && globalZone.is_enabled)
			{
				zoneNames = _getConnectedZoneNames(name, params);
				ret = ArrayCombine(ret, zoneNames, 0, 0);
			}
		}
	}
	return ret;
}

/*
	Name: _powerup_Randomize
	Namespace: zm_temple_ai_monkey
	Checksum: 0x4BE5AE30
	Offset: 0x3F98
	Size: 0x311
	Parameters: 1
	Flags: None
*/
function _powerup_Randomize(monkey)
{
	self endon("stop_randomize");
	monkey endon("remove");
	powerup_cycle = Array("carpenter", "fire_sale", "nuke", "double_points", "insta_kill");
	powerup_cycle = array_randomize_knuth(powerup_cycle);
	powerup_cycle[powerup_cycle.size] = "full_ammo";
	if(level.chest_moves < 1)
	{
		ArrayRemoveValue(powerup_cycle, "fire_sale");
	}
	if(level.round_number <= 1)
	{
		ArrayRemoveValue(powerup_cycle, "nuke");
	}
	currentPowerUp = undefined;
	keys = getArrayKeys(level.zombie_powerups);
	for(i = 0; i < keys.size; i++)
	{
		if(level.zombie_powerups[keys[i]].model_name == self.model)
		{
			currentPowerUp = keys[i];
			break;
		}
	}
	if(isdefined(currentPowerUp))
	{
		ArrayRemoveValue(powerup_cycle, currentPowerUp);
		ArrayInsert(powerup_cycle, currentPowerUp, 0);
	}
	if(currentPowerUp == "full_ammo" && self.grab_count == 1)
	{
		index = randomIntRange(1, powerup_cycle.size - 1);
		ArrayInsert(powerup_cycle, "free_perk", index);
	}
	wait(1);
	index = 1;
	while(1)
	{
		powerupName = powerup_cycle[index];
		index++;
		if(index >= powerup_cycle.size)
		{
			index = 0;
		}
		self zm_powerups::powerup_setup(powerupName, undefined, undefined, undefined, 0);
		self playsound("zmb_temple_powerup_switch");
		monkey _monkey_BindPowerup(self);
		if(powerupName == "free_perk")
		{
			wait(0.25);
		}
		else
		{
			wait(1);
		}
	}
}

/*
	Name: array_randomize_knuth
	Namespace: zm_temple_ai_monkey
	Checksum: 0x74814C20
	Offset: 0x42B8
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function array_randomize_knuth(Array)
{
	n = Array.size;
	while(n > 0)
	{
		index = RandomInt(n);
		n = n - 1;
		temp = Array[index];
		Array[index] = Array[n];
		Array[n] = temp;
	}
	return Array;
}

/*
	Name: _monkey_BindPowerup
	Namespace: zm_temple_ai_monkey
	Checksum: 0x549D06DC
	Offset: 0x4368
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function _monkey_BindPowerup(powerup)
{
	powerup Unlink();
	powerup.angles = self.angles;
	powerup.origin = self.origin;
	offset = VectorScale((0, 0, 1), 40);
	angles = (0, 0, 0);
	powerup LinkTo(self, "tag_origin", offset, angles);
}

/*
	Name: _monkey_gib
	Namespace: zm_temple_ai_monkey
	Checksum: 0x6E8D74E3
	Offset: 0x4418
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function _monkey_gib()
{
	playFX(level._effect["monkey_gib_no_gore"], self.origin);
	self ghost();
}

/*
	Name: _monkey_TempleFling
	Namespace: zm_temple_ai_monkey
	Checksum: 0x8A6CCE18
	Offset: 0x4470
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function _monkey_TempleFling(player)
{
	self.do_gib_death = 1;
	self DoDamage(self.health + 666, self.origin, player);
}

/*
	Name: _monkey_TempleSliding
	Namespace: zm_temple_ai_monkey
	Checksum: 0x2BA3AB1F
	Offset: 0x44C0
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function _monkey_TempleSliding(slide_node)
{
	self endon("death");
	level endon("intermission");
	if(isdefined(self.sliding) && self.sliding)
	{
		return;
	}
	self notify("end_monkey_steal");
	self.is_traversing = 1;
	self notify("zombie_start_traverse");
	self.sliding = 1;
	self.ignoreall = 1;
	self thread set_monkey_slide_anim();
	self setgoalnode(slide_node);
	check_dist_squared = 3600;
	while(DistanceSquared(self.origin, slide_node.origin) > check_dist_squared)
	{
		wait(0.01);
	}
	self thread monkey_zombie_choose_sprint_temple();
	self notify("water_slide_exit");
	self.sliding = 0;
	self.is_traversing = 0;
	self notify("zombie_end_traverse");
	self thread _monkey_StealPowerup();
}

/*
	Name: set_monkey_slide_anim
	Namespace: zm_temple_ai_monkey
	Checksum: 0xBD9D26
	Offset: 0x4620
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function set_monkey_slide_anim()
{
	self zombie_utility::set_zombie_run_cycle("sprint_slide");
}

/*
	Name: precache_ambient_monkey_anims
	Namespace: zm_temple_ai_monkey
	Checksum: 0x99EC1590
	Offset: 0x4650
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precache_ambient_monkey_anims()
{
}

/*
	Name: monkey_ambient_init
	Namespace: zm_temple_ai_monkey
	Checksum: 0x4B8AF38A
	Offset: 0x4660
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function monkey_ambient_init()
{
	level flag::init("monkey_ambient_excited");
	monkey_ambient_level_set_next_sound();
	level.ambient_monkey_locations = struct::get_array("monkey_ambient", "targetname");
	level thread monkey_crowd_noise();
	level thread monkey_ambient_drops_add_array();
	level thread manage_ambient_monkeys(4);
}

/*
	Name: monkey_crowd_noise
	Namespace: zm_temple_ai_monkey
	Checksum: 0x14E98D43
	Offset: 0x4710
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function monkey_crowd_noise()
{
	origin1 = GetEnt("evt_monkey_crowd01_origin", "targetname");
	origin2 = GetEnt("evt_monkey_crowd02_origin", "targetname");
	if(!isdefined(origin1) || !isdefined(origin2))
	{
		return;
	}
	while(1)
	{
		level flag::wait_till("monkey_ambient_excited");
		origin1 PlayLoopSound("evt_monkey_crowd01", 2);
		origin2 PlayLoopSound("evt_monkey_crowd02", 2);
		while(level flag::get("monkey_ambient_excited"))
		{
			wait(0.1);
		}
		origin1 StopLoopSound(3);
		origin2 StopLoopSound(3);
	}
}

/*
	Name: manage_ambient_monkeys
	Namespace: zm_temple_ai_monkey
	Checksum: 0xFB7E8522
	Offset: 0x4858
	Size: 0x1BF
	Parameters: 1
	Flags: None
*/
function manage_ambient_monkeys(max_monkeys)
{
	checkZone = "temple_start_zone";
	level.active_monkeys = [];
	playerInZone = 0;
	hackToFixStart = 1;
	while(1)
	{
		if(!hackToFixStart)
		{
			util::wait_network_frame();
		}
		if(zone_is_active(checkZone) || hackToFixStart)
		{
			if(level.active_monkeys.size == 0 && !playerInZone)
			{
				level.ambient_monkey_locations = array_randomize_knuth(level.ambient_monkey_locations);
				if(level.ambient_monkey_locations.size > 0)
				{
					for(i = 0; i < max_monkeys; i++)
					{
						level.ambient_monkey_locations[i] monkey_ambient_spawn();
						if(!hackToFixStart)
						{
							util::wait_network_frame();
						}
						util::wait_network_frame();
					}
				}
			}
			else if(hackToFixStart)
			{
				while(!zone_is_active(checkZone))
				{
					wait(0.1);
				}
			}
			hackToFixStart = 0;
			playerInZone = 1;
		}
		else
		{
			playerInZone = 0;
			Array::remove_undefined(level.active_monkeys);
		}
	}
}

/*
	Name: zone_is_active
	Namespace: zm_temple_ai_monkey
	Checksum: 0xA3957FF8
	Offset: 0x4A20
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function zone_is_active(zone_name)
{
	if(!isdefined(level.zones) || !isdefined(level.zones[zone_name]) || !level.zones[zone_name].is_active)
	{
		return 0;
	}
	return 1;
}

/*
	Name: monkey_ambient_spawn
	Namespace: zm_temple_ai_monkey
	Checksum: 0xC16BE99D
	Offset: 0x4A80
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function monkey_ambient_spawn()
{
	self.monkey = util::spawn_model("c_zom_dlchd_shangrila_monkey", self.origin, self.angles);
	self.monkey.animName = "monkey";
	self.monkey SetCanDamage(1);
	self.monkey.v_starting_origin = self.origin;
	self.monkey.var_2e8d47d3 = self.angles;
	self.health = 9999;
	zm_weap_shrink_ray::add_shrinkable_object(self.monkey);
	self.monkey.location = self;
	self.monkey.anim_spot = util::spawn_model("tag_origin", self.origin, self.angles);
	if(!isdefined(level.active_monkeys))
	{
		level.active_monkeys = [];
	}
	else if(!IsArray(level.active_monkeys))
	{
		level.active_monkeys = Array(level.active_monkeys);
	}
	level.active_monkeys[level.active_monkeys.size] = self.monkey;
	self.monkey monkey_ambient_set_next_sound();
	self.monkey thread monkey_ambient_noise();
	self.monkey thread monkey_ambient_watch_for_power_up();
	self.monkey thread monkey_ambient_wait_to_be_shot();
	self.monkey thread monkey_ambient_idle();
	self.monkey thread monkey_ambient_shrink();
	self.monkey clientfield::set("monkey_ragdoll", 1);
}

/*
	Name: monkey_ambient_idle
	Namespace: zm_temple_ai_monkey
	Checksum: 0x9BEC44D0
	Offset: 0x4CC8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function monkey_ambient_idle()
{
	self endon("monkey_killed");
	self endon("monkey_cleanup");
	level flag::wait_till("zm_temple_connected");
	self.anim_spot notify("monkey_stop_loop");
	self useanimtree(-1);
	self animation::stop(0.2);
	self animation::Play("rtrg_ai_zm_dlc5_monkey_calm_idle_loop_03", self.v_starting_origin, self.var_2e8d47d3);
}

/*
	Name: monkey_ambient_wait_to_be_shot
	Namespace: zm_temple_ai_monkey
	Checksum: 0xA93299E7
	Offset: 0x4D88
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function monkey_ambient_wait_to_be_shot()
{
	self endon("monkey_cleanup");
	self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags);
	self.alive = 0;
	self notify("monkey_killed");
	playsoundatposition("zmb_stealer_death", self.origin);
	self animation::stop();
	self StartRagdoll();
}

/*
	Name: monkey_ambient_wait_for_remove
	Namespace: zm_temple_ai_monkey
	Checksum: 0x24C39BBE
	Offset: 0x4E88
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function monkey_ambient_wait_for_remove()
{
	self endon("monkey_cleanup");
	self endon("monkey_killed");
	wait(10);
}

/*
	Name: monkey_ambient_drops_add_array
	Namespace: zm_temple_ai_monkey
	Checksum: 0xBCBDF10F
	Offset: 0x4EB0
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function monkey_ambient_drops_add_array()
{
	self endon("monkey_cleanup");
	self endon("monkey_killed");
	while(1)
	{
		level waittill("powerup_dropped", powerup);
		level flag::set("monkey_ambient_excited");
		do
		{
			wait(0.3);
			level.monkey_drops = zm_powerups::get_powerups();
			level.monkey_drops = Array::remove_undefined(level.monkey_drops);
		}
		while(!level.monkey_drops.size != 0);
		level flag::clear("monkey_ambient_excited");
	}
}

/*
	Name: monkey_ambient_watch_for_power_up
	Namespace: zm_temple_ai_monkey
	Checksum: 0x17F02A14
	Offset: 0x4F88
	Size: 0x367
	Parameters: 0
	Flags: None
*/
function monkey_ambient_watch_for_power_up()
{
	self endon("monkey_killed");
	self endon("monkey_cleanup");
	if(!isdefined(self.var_188503aa))
	{
		self.var_188503aa = [];
		if(!isdefined(self.var_188503aa))
		{
			self.var_188503aa = [];
		}
		else if(!IsArray(self.var_188503aa))
		{
			self.var_188503aa = Array(self.var_188503aa);
		}
		self.var_188503aa[self.var_188503aa.size] = "rtrg_ai_zm_dlc5_monkey_freaked_01";
		if(!isdefined(self.var_188503aa))
		{
			self.var_188503aa = [];
		}
		else if(!IsArray(self.var_188503aa))
		{
			self.var_188503aa = Array(self.var_188503aa);
		}
		self.var_188503aa[self.var_188503aa.size] = "rtrg_ai_zm_dlc5_monkey_freaked_01a";
		if(!isdefined(self.var_188503aa))
		{
			self.var_188503aa = [];
		}
		else if(!IsArray(self.var_188503aa))
		{
			self.var_188503aa = Array(self.var_188503aa);
		}
		self.var_188503aa[self.var_188503aa.size] = "rtrg_ai_zm_dlc5_monkey_freaked_01b";
		if(!isdefined(self.var_188503aa))
		{
			self.var_188503aa = [];
		}
		else if(!IsArray(self.var_188503aa))
		{
			self.var_188503aa = Array(self.var_188503aa);
		}
		self.var_188503aa[self.var_188503aa.size] = "rtrg_ai_zm_dlc5_monkey_freaked_01c";
	}
	while(1)
	{
		self.var_188503aa = Array::randomize(self.var_188503aa);
		level flag::wait_till("monkey_ambient_excited");
		wait(RandomFloatRange(0, 1));
		self.excited = 1;
		self thread monkey_ambient_excited_noise();
		self.anim_spot notify("monkey_stop_loop");
		n_index = 0;
		while(1)
		{
			self animation::stop(0.2);
			self animation::Play(self.var_188503aa[n_index], self.v_starting_origin, self.var_2e8d47d3);
			if(!level flag::get("monkey_ambient_excited"))
			{
				break;
			}
			if(n_index < self.var_188503aa.size - 2)
			{
				n_index++;
			}
			else
			{
				n_index = 0;
			}
		}
		self.excited = 0;
		self thread monkey_ambient_idle();
	}
}

/*
	Name: monkey_ambient_level_set_next_sound
	Namespace: zm_temple_ai_monkey
	Checksum: 0x5AAA6460
	Offset: 0x52F8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function monkey_ambient_level_set_next_sound()
{
	level.ambient_monkey_next_sound_time = GetTime() + RandomFloatRange(3, 6) * 1000;
}

/*
	Name: monkey_ambient_set_next_sound
	Namespace: zm_temple_ai_monkey
	Checksum: 0x4C53A161
	Offset: 0x5338
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function monkey_ambient_set_next_sound()
{
	self.next_sound_time = GetTime() + RandomFloatRange(6, 12) * 1000;
}

/*
	Name: monkey_ambient_can_make_sound
	Namespace: zm_temple_ai_monkey
	Checksum: 0xAE7CAE88
	Offset: 0x5378
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function monkey_ambient_can_make_sound()
{
	if(GetTime() < level.ambient_monkey_next_sound_time)
	{
		return 0;
	}
	if(GetTime() < self.next_sound_time)
	{
		return 0;
	}
	return 1;
}

/*
	Name: monkey_ambient_noise
	Namespace: zm_temple_ai_monkey
	Checksum: 0x2111173F
	Offset: 0x53B0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function monkey_ambient_noise()
{
	self endon("monkey_killed");
	self endon("monkey_cleanup");
	while(1)
	{
		if(self monkey_ambient_can_make_sound())
		{
			self thread monkey_ambient_play_sound("zmb_stealer_ambient");
			self monkey_ambient_set_next_sound();
			monkey_ambient_level_set_next_sound();
		}
		wait(0.1);
	}
}

/*
	Name: monkey_ambient_excited_noise
	Namespace: zm_temple_ai_monkey
	Checksum: 0x623475EB
	Offset: 0x5440
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function monkey_ambient_excited_noise()
{
	self endon("monkey_killed");
	self endon("monkey_cleanup");
	while(self.excited)
	{
		self thread monkey_ambient_play_sound("zmb_stealer_excited");
		wait(RandomFloatRange(1.5, 3));
	}
}

/*
	Name: monkey_ambient_play_sound
	Namespace: zm_temple_ai_monkey
	Checksum: 0x38765847
	Offset: 0x54B0
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function monkey_ambient_play_sound(soundName)
{
	while(isdefined(level.monkey_ambient_sound_choke) && level.monkey_ambient_sound_choke)
	{
		util::wait_network_frame();
	}
	level.monkey_ambient_sound_choke = 1;
	self playsound(soundName);
	util::wait_network_frame();
	level.monkey_ambient_sound_choke = 0;
}

/*
	Name: monkey_ambient_shrink
	Namespace: zm_temple_ai_monkey
	Checksum: 0xF07CB6DC
	Offset: 0x5530
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function monkey_ambient_shrink()
{
	waitStr = self util::waittill_any_return("shrunk", "death", "monkey_killed", "monkey_cleanup");
	zm_weap_shrink_ray::remove_shrinkable_object(self);
	if(waitStr == "shrunk")
	{
		self thread _monkey_gib();
	}
}

/*
	Name: monkey_ambient_gib_all
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD16A3D68
	Offset: 0x55C0
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function monkey_ambient_gib_all()
{
	for(i = level.active_monkeys.size - 1; i >= 0; i--)
	{
		monkey = level.active_monkeys[i];
		monkey thread _monkey_gib();
	}
}

/*
	Name: _monkey_zombie_grenade_watcher
	Namespace: zm_temple_ai_monkey
	Checksum: 0x3CF77C40
	Offset: 0x5630
	Size: 0x19F
	Parameters: 0
	Flags: None
*/
function _monkey_zombie_grenade_watcher()
{
	self endon("death");
	grenade_respond_dist_sq = 14400;
	while(1)
	{
		if(isdefined(self.monkey_grenade) && self.monkey_grenade)
		{
			util::wait_network_frame();
			continue;
		}
		if(isdefined(level.monkey_grenades) && level.monkey_grenades.size > 0)
		{
			for(i = 0; i < level.monkey_grenades.size; i++)
			{
				grenade = level.monkey_grenades[i];
				if(!isdefined(grenade) || isdefined(grenade.monkey))
				{
					util::wait_network_frame();
					continue;
				}
				if(isdefined(self.powerup))
				{
					util::wait_network_frame();
					continue;
				}
				grenade_dist_sq = DistanceSquared(self.origin, grenade.origin);
				if(grenade_dist_sq <= grenade_respond_dist_sq)
				{
					grenade.monkey = self;
					self.monkey_grenade = grenade;
					self monkey_zombie_grenade_response();
					break;
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: monkey_zombie_grenade_response
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD652B634
	Offset: 0x57D8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function monkey_zombie_grenade_response()
{
	self endon("death");
	self notify("end_monkey_steal");
	self monkey_zombie_grenade_pickup();
	self thread _monkey_StealPowerup();
}

/*
	Name: monkey_zombie_grenade_pickup
	Namespace: zm_temple_ai_monkey
	Checksum: 0xE7C9D3C4
	Offset: 0x5828
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function monkey_zombie_grenade_pickup()
{
	self endon("death");
	pickup_dist_sq = 1024;
	picked_up = 0;
	while(isdefined(self.monkey_grenade))
	{
		self setgoalpos(self.monkey_grenade.origin);
		grenade_dist_sq = DistanceSquared(self.origin, self.monkey_grenade.origin);
		if(grenade_dist_sq <= pickup_dist_sq)
		{
			self.monkey_thrower = self.monkey_grenade.thrower;
			self.monkey_grenade delete();
			self.monkey_grenade = undefined;
			picked_up = 1;
		}
		util::wait_network_frame();
	}
	if(picked_up)
	{
		while(1)
		{
			self setgoalpos(self.monkey_thrower.origin);
			target_dir = self.monkey_thrower.origin - self.origin;
			monkey_dir = AnglesToForward(self.angles);
			dot = VectorDot(VectorNormalize(target_dir), VectorNormalize(monkey_dir));
			if(dot >= 0.5)
			{
				break;
			}
			util::wait_network_frame();
		}
		self thread monkey_zombie_grenade_throw(self.monkey_thrower);
		self waittill("throw_done");
	}
}

/*
	Name: monkey_zombie_grenade_throw_watcher
	Namespace: zm_temple_ai_monkey
	Checksum: 0x5F4C4640
	Offset: 0x5A58
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function monkey_zombie_grenade_throw_watcher(target, animName)
{
	self endon("death");
	self waittillmatch(animName);
	throw_angle = randomIntRange(20, 30);
	dir = VectorToAngles(target.origin - self.origin);
	dir = (dir[0] - throw_angle, dir[1], dir[2]);
	dir = AnglesToForward(dir);
	velocity = dir * 550;
	fuse = RandomFloatRange(1, 2);
	hand_pos = self GetTagOrigin("J_Thumb_RI_1");
	grenade_type = target zm_utility::get_player_lethal_grenade();
	self MagicGrenadeType(grenade_type, hand_pos, velocity, fuse);
}

/*
	Name: monkey_zombie_grenade_throw
	Namespace: zm_temple_ai_monkey
	Checksum: 0x5254A107
	Offset: 0x5BE8
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function monkey_zombie_grenade_throw(target)
{
	self notify("throw_done");
}

/*
	Name: monkey_attack_player
	Namespace: zm_temple_ai_monkey
	Checksum: 0x732BDB57
	Offset: 0x5C10
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function monkey_attack_player()
{
	self endon("death");
	self.attack_player = 1;
	self.attacking_player = 1;
	players = GetPlayers();
	self.ignore_player = [];
	player = undefined;
	if(isdefined(self.player_stole_power_up) && zombie_utility::is_player_valid(self.player_stole_power_up))
	{
		player = self.player_stole_power_up;
	}
	if(isdefined(player))
	{
		self.favoriteenemy = player;
		self thread monkey_obvious_vox();
		self _monkey_add_time();
		self thread monkey_pathing();
		self thread monkey_attack_player_wait_wrapper(self.favoriteenemy);
		self waittill("end_monkey_attacks");
	}
}

/*
	Name: monkey_attack_player_wait_wrapper
	Namespace: zm_temple_ai_monkey
	Checksum: 0xCF93EBE0
	Offset: 0x5D40
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function monkey_attack_player_wait_wrapper(player)
{
	self monkey_attack_player_wait(player);
	self monkey_stop_attck_player();
}

/*
	Name: monkey_attack_player_wait
	Namespace: zm_temple_ai_monkey
	Checksum: 0xCD0124A7
	Offset: 0x5D88
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function monkey_attack_player_wait(player)
{
	self endon("death");
	self endon("end_monkey_steal");
	attackTimeEnd = GetTime() + 20000;
	while(attackTimeEnd > GetTime())
	{
		if(!zombie_utility::is_player_valid(player))
		{
			break;
		}
		if(isdefined(self.melee_count) && self.melee_count >= 1)
		{
			break;
		}
		wait(0.1);
	}
}

/*
	Name: monkey_stop_attck_player
	Namespace: zm_temple_ai_monkey
	Checksum: 0xDDCE5699
	Offset: 0x5E20
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function monkey_stop_attck_player()
{
	self notify("end_monkey_attacks");
	self.ignoreall = 1;
	if(isalive(self))
	{
		self.favoriteenemy = undefined;
		self.attacking_player = 0;
	}
}

/*
	Name: monkey_pathing
	Namespace: zm_temple_ai_monkey
	Checksum: 0xBEA096FC
	Offset: 0x5E70
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function monkey_pathing()
{
	self endon("death");
	self endon("end_monkey_attacks");
	self.ignoreall = 0;
	self.meleeAttackDist = 64;
	while(isdefined(self.favoriteenemy))
	{
		self.goalRadius = 32;
		self OrientMode("face default");
		self setgoalpos(self.favoriteenemy.origin);
		util::wait_network_frame();
	}
}

/*
	Name: monkey_temple_custom_damage
	Namespace: zm_temple_ai_monkey
	Checksum: 0x9B540E7B
	Offset: 0x5F18
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function monkey_temple_custom_damage(player)
{
	self endon("death");
	damage = self.meleeDamage;
	if(!isdefined(self.melee_count))
	{
		self.melee_count = 0;
	}
	self.melee_count++;
	if(isdefined(player) && player.score > 0)
	{
		pointsToSteal = Int(min(player.score, 50));
		player zm_score::minus_to_player_score(pointsToSteal);
	}
	return damage;
}

/*
	Name: monkey_obvious_vox
	Namespace: zm_temple_ai_monkey
	Checksum: 0xD071502C
	Offset: 0x5FE8
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function monkey_obvious_vox()
{
	self endon("death");
	self endon("end_monkey_attacks");
	while(1)
	{
		self playsound("zmb_stealer_attack");
		wait(RandomFloatRange(2, 4));
	}
}

