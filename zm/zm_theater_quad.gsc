#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_quad;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_quad;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_1e94246a;

/*
	Name: init
	Namespace: namespace_1e94246a
	Checksum: 0x5001F15A
	Offset: 0x650
	Size: 0x13
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_66da4eb0();
}

/*
	Name: function_66da4eb0
	Namespace: namespace_1e94246a
	Checksum: 0x7AE4CD28
	Offset: 0x670
	Size: 0x1A3
	Parameters: 0
	Flags: Private
*/
function private function_66da4eb0()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("traverseWallCrawlAction", &function_2b4dc5b6, &function_7d285db1, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldWallTraverse", &function_61ee6c82);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldWallCrawl", &function_36178109);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("traverseWallIntro", &function_df42db1b);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("traverseWallJumpOff", &function_631f2f0e);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("quadCollisionService", &function_f2b3a201);
	AnimationStateNetwork::RegisterAnimationMocomp("quad_wall_traversal", &function_dd3e35df, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("quad_wall_jump_off", &function_5d8b540c, undefined, &function_18650281);
	AnimationStateNetwork::RegisterAnimationMocomp("quad_move_strict_traversal", &function_9e9b3f8b, undefined, &function_2433815e);
}

/*
	Name: function_2b4dc5b6
	Namespace: namespace_1e94246a
	Checksum: 0x56FC6E99
	Offset: 0x820
	Size: 0x2F
	Parameters: 2
	Flags: None
*/
function function_2b4dc5b6(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: function_7d285db1
	Namespace: namespace_1e94246a
	Checksum: 0xF3A23C38
	Offset: 0x858
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function function_7d285db1(entity, asmStateName)
{
	if(!function_36178109(entity))
	{
		return 4;
	}
	return 5;
}

/*
	Name: function_61ee6c82
	Namespace: namespace_1e94246a
	Checksum: 0x35FF4FDE
	Offset: 0x898
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function function_61ee6c82(entity)
{
	if(isdefined(entity.traverseStartNode))
	{
		if(IsSubStr(entity.traverseStartNode.animscript, "zm_wall_crawl_drop"))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_36178109
	Namespace: namespace_1e94246a
	Checksum: 0x97E9290B
	Offset: 0x8F8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_36178109(entity)
{
	if(isdefined(self.var_2826ab5d))
	{
		if(GetTime() >= self.var_2826ab5d)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_df42db1b
	Namespace: namespace_1e94246a
	Checksum: 0x411A7AAB
	Offset: 0x930
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_df42db1b(entity)
{
	entity AllowPitchAngle(0);
	entity.clampToNavMesh = 0;
	if(isdefined(entity.traverseStartNode))
	{
		entity.var_1bb3c5d0 = entity.traverseStartNode;
		entity.var_7531a5e3 = entity.traverseEndNode;
		if(entity.traverseStartNode.animscript == "zm_wall_crawl_drop")
		{
			blackboard::SetBlackBoardAttribute(self, "_quad_wall_crawl", "quad_wall_crawl_theater");
		}
		else
		{
			blackboard::SetBlackBoardAttribute(self, "_quad_wall_crawl", "quad_wall_crawl_start");
		}
	}
}

/*
	Name: function_631f2f0e
	Namespace: namespace_1e94246a
	Checksum: 0xEF2F813A
	Offset: 0xA30
	Size: 0x15
	Parameters: 1
	Flags: None
*/
function function_631f2f0e(entity)
{
	self.var_2826ab5d = undefined;
}

/*
	Name: function_f2b3a201
	Namespace: namespace_1e94246a
	Checksum: 0x3334F975
	Offset: 0xA50
	Size: 0x1DD
	Parameters: 1
	Flags: None
*/
function function_f2b3a201(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.dontPushTime))
	{
		if(GetTime() < behaviorTreeEntity.dontPushTime)
		{
			return 1;
		}
	}
	zombies = GetAITeamArray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie == behaviorTreeEntity)
		{
			continue;
		}
		if(isdefined(zombie.missingLegs) && zombie.missingLegs || (isdefined(zombie.KNOCKDOWN) && zombie.KNOCKDOWN))
		{
			continue;
		}
		dist_sq = DistanceSquared(behaviorTreeEntity.origin, zombie.origin);
		if(dist_sq < 14400)
		{
			behaviorTreeEntity PushActors(0);
			behaviorTreeEntity.dontPushTime = GetTime() + 3000;
			zombie thread function_77876867();
			return 1;
		}
	}
	behaviorTreeEntity PushActors(1);
	return 0;
}

/*
	Name: function_77876867
	Namespace: namespace_1e94246a
	Checksum: 0x507E84AA
	Offset: 0xC38
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_77876867()
{
	self endon("death");
	self SetAvoidanceMask("avoid all");
	wait(3);
	self SetAvoidanceMask("avoid none");
}

/*
	Name: function_dd3e35df
	Namespace: namespace_1e94246a
	Checksum: 0x2B82FE84
	Offset: 0xC90
	Size: 0x157
	Parameters: 5
	Flags: Private
*/
function private function_dd3e35df(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	animDist = Abs(GetMoveDelta(mocompAnim, 0, 1)[2]);
	self.ground_pos = bullettrace(self.var_7531a5e3.origin, self.var_7531a5e3.origin + VectorScale((0, 0, -1), 100000), 0, self)["position"];
	physDist = Abs(self.origin[2] - self.ground_pos[2] - 60);
	cycles = physDist / animDist;
	time = cycles * getanimlength(mocompAnim);
	self.var_2826ab5d = GetTime() + time * 1000;
}

/*
	Name: function_5d8b540c
	Namespace: namespace_1e94246a
	Checksum: 0x226CBD3A
	Offset: 0xDF0
	Size: 0x4B
	Parameters: 5
	Flags: Private
*/
function private function_5d8b540c(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("noclip", 0);
}

/*
	Name: function_18650281
	Namespace: namespace_1e94246a
	Checksum: 0x96DD1E2E
	Offset: 0xE48
	Size: 0x57
	Parameters: 5
	Flags: Private
*/
function private function_18650281(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity AllowPitchAngle(1);
	entity.clampToNavMesh = 1;
}

/*
	Name: function_9e9b3f8b
	Namespace: namespace_1e94246a
	Checksum: 0xE7F116BC
	Offset: 0xEA8
	Size: 0x113
	Parameters: 5
	Flags: Private
*/
function private function_9e9b3f8b(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	/#
		Assert(isdefined(entity.traverseStartNode));
	#/
	entity.blockingPain = 1;
	entity.useGoalAnimWeight = 1;
	entity animMode("noclip", 0);
	entity ForceTeleport(entity.traverseStartNode.origin, entity.traverseStartNode.angles, 0);
	entity OrientMode("face angle", entity.traverseStartNode.angles[1]);
}

/*
	Name: function_2433815e
	Namespace: namespace_1e94246a
	Checksum: 0xA7A9829B
	Offset: 0xFC8
	Size: 0x63
	Parameters: 5
	Flags: Private
*/
function private function_2433815e(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity finishtraversal();
	entity.useGoalAnimWeight = 0;
	entity.blockingPain = 0;
}

/*
	Name: init_roofs
	Namespace: namespace_1e94246a
	Checksum: 0xE90EB5DF
	Offset: 0x1038
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function init_roofs()
{
	level flag::wait_till("curtains_done");
	level thread quad_stage_roof_break();
	level thread quad_lobby_roof_break();
	level thread quad_dining_roof_break();
	level thread function_79dea782();
}

/*
	Name: quad_roof_crumble_fx_play
	Namespace: namespace_1e94246a
	Checksum: 0xFD3E855
	Offset: 0x10C8
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function quad_roof_crumble_fx_play(n_index)
{
	play_quad_first_sounds();
	roof_parts = GetEntArray(self.target, "targetname");
	if(isdefined(roof_parts))
	{
		for(i = 0; i < roof_parts.size; i++)
		{
			roof_parts[i] delete();
		}
	}
	FX = struct::get(self.target, "targetname");
	if(isdefined(FX))
	{
		self function_b7b3e976(n_index);
		thread rumble_all_players("damage_heavy");
	}
	if(isdefined(self.script_noteworthy))
	{
		util::clientNotify(self.script_noteworthy);
	}
	if(isdefined(self.script_int))
	{
		exploder::exploder(self.script_int);
	}
}

/*
	Name: function_b7b3e976
	Namespace: namespace_1e94246a
	Checksum: 0xE3935FD4
	Offset: 0x1220
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function function_b7b3e976(n_index)
{
	switch(n_index)
	{
		case 0:
		{
			var_a58a7b24 = "fxexp_1012";
			break;
		}
		case 1:
		{
			var_a58a7b24 = "fxexp_1007";
			break;
		}
		case 2:
		{
			var_a58a7b24 = "fxexp_1008";
			break;
		}
		case 3:
		{
			var_a58a7b24 = "fxexp_1009";
			break;
		}
		case 4:
		{
			var_a58a7b24 = "fxexp_1010";
			break;
		}
		case 5:
		{
			var_a58a7b24 = "fxexp_1003";
			break;
		}
		case 6:
		{
			var_a58a7b24 = "fxexp_1004";
			break;
		}
		case 7:
		{
			var_a58a7b24 = "fxexp_1001";
			break;
		}
		case 8:
		{
			var_a58a7b24 = "fxexp_1002";
			break;
		}
		case 10:
		{
			var_a58a7b24 = "fxexp_1006";
			break;
		}
		case 12:
		{
			var_a58a7b24 = "fxexp_1014";
			break;
		}
		case 15:
		{
			var_a58a7b24 = "fxexp_1011";
			break;
		}
	}
	if(isdefined(var_a58a7b24))
	{
		exploder::exploder(var_a58a7b24);
	}
}

/*
	Name: play_quad_first_sounds
	Namespace: namespace_1e94246a
	Checksum: 0x5F003FA5
	Offset: 0x1390
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function play_quad_first_sounds()
{
	location = struct::get(self.target, "targetname");
	self PlaySoundWithNotify("zmb_vocals_quad_spawn", "sounddone");
	self waittill("sounddone");
	self playsound("zmb_quad_roof_hit");
	thread play_wood_land_sound(location.origin);
}

/*
	Name: play_wood_land_sound
	Namespace: namespace_1e94246a
	Checksum: 0x94223B28
	Offset: 0x1438
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function play_wood_land_sound(origin)
{
	wait(1);
	playsoundatposition("zmb_quad_roof_break_land", origin - VectorScale((0, 0, 1), 150));
}

/*
	Name: rumble_all_players
	Namespace: namespace_1e94246a
	Checksum: 0xA9679396
	Offset: 0x1480
	Size: 0x155
	Parameters: 5
	Flags: None
*/
function rumble_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(high_rumble_range) && isdefined(low_rumble_range) && isdefined(rumble_org))
		{
			if(Distance(players[i].origin, rumble_org) < high_rumble_range)
			{
				players[i] PlayRumbleOnEntity(high_rumble_string);
			}
			else if(Distance(players[i].origin, rumble_org) < low_rumble_range)
			{
				players[i] PlayRumbleOnEntity(low_rumble_string);
			}
			continue;
		}
		players[i] PlayRumbleOnEntity(high_rumble_string);
	}
}

/*
	Name: quad_traverse_death_fx
	Namespace: namespace_1e94246a
	Checksum: 0x26AF6178
	Offset: 0x15E0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function quad_traverse_death_fx()
{
	self endon("traverse_anim");
	self waittill("death");
	playFX(level._effect["quad_grnd_dust_spwnr"], self.origin);
}

/*
	Name: begin_quad_introduction
	Namespace: namespace_1e94246a
	Checksum: 0x964A7798
	Offset: 0x1638
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function begin_quad_introduction(quad_round_name)
{
	if(level flag::get("dog_round"))
	{
		level flag::clear("dog_round");
	}
	if(level.next_dog_round == level.round_number + 1)
	{
		level.next_dog_round++;
	}
	level.zombie_total = 0;
	level.quad_round_name = quad_round_name;
}

/*
	Name: Theater_Quad_Round
	Namespace: namespace_1e94246a
	Checksum: 0x4F2FD7A0
	Offset: 0x16C8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function Theater_Quad_Round()
{
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	old_round = zm::get_round_number();
	level.zombie_total = 0;
	level.zombie_health = 100 * old_round;
	kill_all_zombies();
	zm::set_round_number(old_round);
}

/*
	Name: spawn_second_wave_quads
	Namespace: namespace_1e94246a
	Checksum: 0xDEE4C526
	Offset: 0x1758
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function spawn_second_wave_quads(second_wave_targetname)
{
	second_wave_spawners = [];
	second_wave_spawners = GetEntArray(second_wave_targetname, "targetname");
	if(second_wave_spawners.size < 1)
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	for(i = 0; i < second_wave_spawners.size; i++)
	{
		ai = zombie_utility::spawn_zombie(second_wave_spawners[i]);
		if(isdefined(ai))
		{
			ai thread zombie_utility::round_spawn_failsafe();
			ai thread quad_traverse_death_fx();
		}
		wait(randomIntRange(10, 45));
	}
	util::wait_network_frame();
}

/*
	Name: spawn_a_quad_zombie
	Namespace: namespace_1e94246a
	Checksum: 0x80A24967
	Offset: 0x1890
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function spawn_a_quad_zombie(spawn_array)
{
	spawn_point = spawn_array[RandomInt(spawn_array.size)];
	ai = zombie_utility::spawn_zombie(spawn_point);
	if(isdefined(ai))
	{
		ai thread zombie_utility::round_spawn_failsafe();
		ai thread quad_traverse_death_fx();
	}
	wait(level.zombie_vars["zombie_spawn_delay"]);
	util::wait_network_frame();
}

/*
	Name: kill_all_zombies
	Namespace: namespace_1e94246a
	Checksum: 0x3C6C674D
	Offset: 0x1958
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function kill_all_zombies()
{
	zombies = GetAISpeciesArray("axis", "all");
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(!isdefined(zombies[i]))
			{
				continue;
			}
			zombies[i] DoDamage(zombies[i].health + 666, zombies[i].origin);
			util::wait_network_frame();
		}
	}
}

/*
	Name: prevent_round_ending
	Namespace: namespace_1e94246a
	Checksum: 0xDC5ABE72
	Offset: 0x1A30
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function prevent_round_ending()
{
	level endon("quad_round_can_end");
	while(1)
	{
		if(level.zombie_total < 1)
		{
			level.zombie_total = 1;
		}
		wait(0.5);
	}
}

/*
	Name: Intro_Quad_Spawn
	Namespace: namespace_1e94246a
	Checksum: 0x2243FC26
	Offset: 0x1A78
	Size: 0x375
	Parameters: 0
	Flags: None
*/
function Intro_Quad_Spawn()
{
	timer = GetTime();
	spawned = 0;
	previous_spawn_delay = level.zombie_vars["zombie_spawn_delay"];
	thread prevent_round_ending();
	initial_spawners = [];
	switch(level.quad_round_name)
	{
		case "initial_round":
		{
			initial_spawners = GetEntArray("initial_first_round_quad_spawner", "targetname");
			break;
		}
		case "theater_round":
		{
			initial_spawners = GetEntArray("initial_theater_round_quad_spawner", "targetname");
			break;
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
			return;
		}
	}
	if(initial_spawners.size < 1)
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	while(1)
	{
		if(isdefined(level.delay_spawners))
		{
			manage_zombie_spawn_delay(timer);
		}
		level.delay_spawners = 1;
		spawn_a_quad_zombie(initial_spawners);
		wait(0.2);
		spawned++;
		if(spawned > level.quads_per_round)
		{
			break;
		}
	}
	spawned = 0;
	second_spawners = [];
	switch(level.quad_round_name)
	{
		case "initial_round":
		{
			second_spawners = GetEntArray("initial_first_round_quad_spawner_second_wave", "targetname");
			break;
		}
		case "theater_round":
		{
			second_spawners = GetEntArray("theater_round_quad_spawner_second_wave", "targetname");
			break;
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
			return;
		}
	}
	if(second_spawners.size < 1)
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	while(1)
	{
		manage_zombie_spawn_delay(timer);
		spawn_a_quad_zombie(second_spawners);
		wait(0.2);
		spawned++;
		if(spawned > level.quads_per_round * 2)
		{
			break;
		}
	}
	level.zombie_vars["zombie_spawn_delay"] = previous_spawn_delay;
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	level.zombie_total = 0;
	level.round_spawn_func = &zm::round_spawning;
	level thread [[level.round_spawn_func]]();
	wait(2);
	level notify("quad_round_can_end");
	level.delay_spawners = undefined;
}

/*
	Name: manage_zombie_spawn_delay
	Namespace: namespace_1e94246a
	Checksum: 0xC295855A
	Offset: 0x1DF8
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function manage_zombie_spawn_delay(start_timer)
{
	if(GetTime() - start_timer < 15000)
	{
		level.zombie_vars["zombie_spawn_delay"] = randomIntRange(30, 45);
	}
	else if(GetTime() - start_timer < 25000)
	{
		level.zombie_vars["zombie_spawn_delay"] = randomIntRange(15, 30);
	}
	else if(GetTime() - start_timer < 35000)
	{
		level.zombie_vars["zombie_spawn_delay"] = randomIntRange(10, 15);
	}
	else if(GetTime() - start_timer < 50000)
	{
		level.zombie_vars["zombie_spawn_delay"] = randomIntRange(5, 10);
	}
}

/*
	Name: quad_lobby_roof_break
	Namespace: namespace_1e94246a
	Checksum: 0x7CD9E68D
	Offset: 0x1F20
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function quad_lobby_roof_break()
{
	zone = level.zones["foyer_zone"];
	while(1)
	{
		if(zone.is_occupied)
		{
			flag::set("lobby_occupied");
			break;
		}
		util::wait_network_frame();
	}
	quad_stage_roof_break_single(5);
	wait(0.4);
	quad_stage_roof_break_single(6);
	wait(2);
	quad_stage_roof_break_single(7);
	wait(1);
	quad_stage_roof_break_single(8);
}

/*
	Name: quad_dining_roof_break
	Namespace: namespace_1e94246a
	Checksum: 0x126DE1CE
	Offset: 0x2010
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function quad_dining_roof_break()
{
	level endon("hash_e1db2a20");
	zone = level.zones["dining_zone"];
	while(1)
	{
		if(zone.is_occupied)
		{
			flag::set("dining_occupied");
			break;
		}
		util::wait_network_frame();
	}
	quad_stage_roof_break_single(9);
	wait(1);
	quad_stage_roof_break_single(10);
}

/*
	Name: quad_stage_roof_break
	Namespace: namespace_1e94246a
	Checksum: 0x894E9259
	Offset: 0x20C8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function quad_stage_roof_break()
{
	quad_stage_roof_break_single(1);
	wait(2);
	quad_stage_roof_break_single(3);
	wait(0.33);
	quad_stage_roof_break_single(2);
	wait(1);
	quad_stage_roof_break_single(0);
	wait(0.45);
	quad_stage_roof_break_single(4);
	level thread play_quad_start_vo();
	wait(0.33);
	quad_stage_roof_break_single(15);
	wait(0.4);
	quad_stage_roof_break_single(11);
	wait(0.45);
	quad_stage_roof_break_single(12);
	wait(0.3);
	quad_stage_roof_break_single(13);
	wait(0.35);
	quad_stage_roof_break_single(14);
	namespace_1d58b607::function_5af423f4();
}

/*
	Name: quad_stage_roof_break_single
	Namespace: namespace_1e94246a
	Checksum: 0xD0E5AEB3
	Offset: 0x2230
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function quad_stage_roof_break_single(index)
{
	trigger = GetEnt("quad_roof_crumble_fx_origin_" + index, "target");
	trigger thread quad_roof_crumble_fx_play(index);
}

/*
	Name: play_quad_start_vo
	Namespace: namespace_1e94246a
	Checksum: 0xCE845C53
	Offset: 0x2298
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function play_quad_start_vo()
{
	players = GetPlayers();
	player = players[randomIntRange(0, players.size)];
	player zm_audio::create_and_play_dialog("general", "quad_spawn");
}

/*
	Name: function_79dea782
	Namespace: namespace_1e94246a
	Checksum: 0xFC971E39
	Offset: 0x2318
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function function_79dea782()
{
	trigger = GetEnt("quad_roof_crumble_fx_origin_10", "target");
	trigger waittill("trigger", who);
	level notify("hash_e1db2a20");
	roof_parts = GetEntArray(trigger.target, "targetname");
	if(isdefined(roof_parts))
	{
		for(i = 0; i < roof_parts.size; i++)
		{
			roof_parts[i] delete();
		}
	}
}

