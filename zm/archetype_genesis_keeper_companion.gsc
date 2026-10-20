#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\ai_squads;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\archetype_genesis_keeper_companion_interface;

#namespace keepercompanionbehavior;

/*
	Name: main
	Namespace: keepercompanionbehavior
	Checksum: 0x72B60B40
	Offset: 0xBD8
	Size: 0x233
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("allplayers", "being_keeper_revived", 15000, 1, "int");
	clientfield::register("actor", "keeper_reviving", 15000, 1, "int");
	clientfield::register("actor", "kc_effects", 15000, 1, "int");
	clientfield::register("world", "kc_callbox_lights", 15000, 2, "int");
	clientfield::register("actor", "keeper_thunderwall", 15000, 1, "counter");
	clientfield::register("actor", "keeper_ai_death_effect", 15000, 1, "int");
	clientfield::register("vehicle", "keeper_ai_death_effect", 15000, 1, "int");
	clientfield::register("scriptmover", "keeper_ai_spawn_tell", 15000, 1, "int");
	clientfield::register("scriptmover", "keeper_thunderwall_360", 15000, 1, "counter");
	InitZombieBehaviorsAndASM();
	spawner::add_archetype_spawn_function("keeper_companion", &function_8c4e826e);
	spawner::add_archetype_spawn_function("keeper_companion", &keepercompanionspawnsetup);
	keepercompanioninterface::function_e7b6b58c();
	RegisterBehaviorScriptFunctions();
}

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: keepercompanionbehavior
	Checksum: 0x6287AC41
	Offset: 0xE18
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperCompanionShouldmove", &keepercompanionshouldmove);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperCompanionDelayMovement", &keepercompaniondelaymovement);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperCompanionShouldTraverse", &keepercompanionshouldtraverse);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperCompanionKeepsUpdateMovementMode", &keepercompanionkeepsupdatemovementmode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperUpdatethunderwallAttackParams", &keeperupdatethunderwallattackparams);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperCompanionUpdateLeader", &keepercompanionupdateleader);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keeperCompanionMovementService", &keepercompanionmovementservice);
}

/*
	Name: InitZombieBehaviorsAndASM
	Namespace: keepercompanionbehavior
	Checksum: 0x3FCFA396
	Offset: 0xF40
	Size: 0x233
	Parameters: 0
	Flags: Private
*/
function private InitZombieBehaviorsAndASM()
{
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_out_traversal@keeper_companion", &function_3ff0b3e, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_in_traversal@keeper_companion", &function_f1efe0ab, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_keeper_companion_idle@keeper_companion", &function_7cf81f38, &function_7cf81f38, &function_7cf81f38);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_keeper_tactical_walk@keeper_companion", &function_8c2af335, &function_8c2af335, &function_8d3c82f6);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("thunder", &function_7cbb0165);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("attack_left", &function_c6326468);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("attack_right", &function_ec3b8737);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("attack_up", &function_86b6a4a8);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("keeper_teleport_out", &function_cd4d7e12);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("keeper_teleport_in", &function_d938ace7);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("keeper_spawn_in", &function_10c1bf1);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("keeper_spawn_out", &function_26729028);
}

/*
	Name: function_3ff0b3e
	Namespace: keepercompanionbehavior
	Checksum: 0x24F08C7E
	Offset: 0x1180
	Size: 0xD7
	Parameters: 5
	Flags: None
*/
function function_3ff0b3e(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("normal", 0);
	entity SetRepairPaths(0);
	entity.blockingPain = 1;
	entity.useGoalAnimWeight = 1;
	entity.var_63288fb8 = entity.traverseEndNode;
}

/*
	Name: function_f1efe0ab
	Namespace: keepercompanionbehavior
	Checksum: 0x2E24DE20
	Offset: 0x1260
	Size: 0x1DB
	Parameters: 5
	Flags: None
*/
function function_f1efe0ab(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(isdefined(entity.var_63288fb8))
	{
		/#
			print3d(entity.origin, "Dev Block strings are not supported", (1, 0, 0), 1, 1, 60);
			print3d(entity.var_63288fb8.origin, "Dev Block strings are not supported", (0, 1, 0), 1, 1, 60);
			line(entity.origin, entity.var_63288fb8.origin, (0, 1, 0), 1, 0, 60);
		#/
		var_99523a0 = entity.var_63288fb8.origin - entity.origin;
		var_6aa21bd5 = VectorToAngles(var_99523a0);
		entity ForceTeleport(entity.var_63288fb8.origin, (0, var_6aa21bd5[1], 0), 0);
	}
	entity finishtraversal();
	entity SetRepairPaths(1);
	entity.blockingPain = 0;
	entity.useGoalAnimWeight = 0;
}

/*
	Name: function_7cf81f38
	Namespace: keepercompanionbehavior
	Checksum: 0xA5DEA8C0
	Offset: 0x1448
	Size: 0x1E3
	Parameters: 5
	Flags: None
*/
function function_7cf81f38(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("normal", 0);
	if(isdefined(self.reviving_a_player) && self.reviving_a_player && (isdefined(self.var_1a5b8ffb) && self.var_1a5b8ffb))
	{
		entity OrientMode("face direction", VectorNormalize(self.reviving_player.origin - entity.origin));
	}
	else if(isdefined(entity.var_92aa697) && entity.var_92aa697 && isdefined(entity.var_8cf1ff79))
	{
		entity OrientMode("face direction", VectorNormalize(entity.var_8cf1ff79 - entity.origin));
	}
	else if(isdefined(entity.leader))
	{
		entity OrientMode("face direction", VectorNormalize(entity.leader.origin - entity.origin));
	}
	else
	{
		entity OrientMode("face angle", entity.angles[1]);
	}
}

/*
	Name: function_8c2af335
	Namespace: keepercompanionbehavior
	Checksum: 0xB5199791
	Offset: 0x1638
	Size: 0x2A3
	Parameters: 5
	Flags: None
*/
function function_8c2af335(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("normal", 0);
	entity OrientMode("face motion");
	if(isdefined(self.reviving_a_player) && self.reviving_a_player && (isdefined(self.var_1a5b8ffb) && self.var_1a5b8ffb))
	{
		entity OrientMode("face direction", VectorNormalize(self.reviving_player.origin - entity.origin));
	}
	else if(isdefined(entity.var_92aa697) && entity.var_92aa697 && isdefined(entity.var_8cf1ff79))
	{
		entity OrientMode("face direction", VectorNormalize(entity.var_8cf1ff79 - entity.origin));
	}
	else if(isdefined(entity.leader))
	{
		entity OrientMode("face direction", VectorNormalize(entity.leader.origin - entity.origin));
	}
	else
	{
		entity OrientMode("face angle", entity.angles[1]);
	}
	if(!entity.manualTraverseMode && isdefined(entity.traversalstartdist) && entity.traversalstartdist >= 0)
	{
		entity.blockingPain = 1;
		entity.useGoalAnimWeight = 1;
		entity animMode("pre_traversal", 0);
		entity OrientMode("face current");
	}
}

/*
	Name: function_8d3c82f6
	Namespace: keepercompanionbehavior
	Checksum: 0x12D60B53
	Offset: 0x18E8
	Size: 0x4B
	Parameters: 5
	Flags: None
*/
function function_8d3c82f6(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 0;
	entity.useGoalAnimWeight = 0;
}

/*
	Name: function_cd4d7e12
	Namespace: keepercompanionbehavior
	Checksum: 0xC7AE30DB
	Offset: 0x1940
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_cd4d7e12(entity)
{
	entity clientfield::set("kc_effects", 0);
	entity ghost();
}

/*
	Name: function_d938ace7
	Namespace: keepercompanionbehavior
	Checksum: 0x53F76973
	Offset: 0x1990
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_d938ace7(entity)
{
	entity clientfield::set("kc_effects", 1);
	entity show();
}

/*
	Name: function_10c1bf1
	Namespace: keepercompanionbehavior
	Checksum: 0xF83C9504
	Offset: 0x19E0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_10c1bf1(entity)
{
	entity clientfield::set("kc_effects", 1);
	entity show();
}

/*
	Name: function_26729028
	Namespace: keepercompanionbehavior
	Checksum: 0xC2C70711
	Offset: 0x1A30
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_26729028(entity)
{
	entity clientfield::set("kc_effects", 0);
	entity ghost();
	entity thread function_8a22bf01(entity);
}

/*
	Name: function_8a22bf01
	Namespace: keepercompanionbehavior
	Checksum: 0x49022FAD
	Offset: 0x1A98
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_8a22bf01(entity)
{
	entity endon("death");
	util::wait_network_frame();
	entity.var_2c553c41 delete();
	entity delete();
}

/*
	Name: function_8c4e826e
	Namespace: keepercompanionbehavior
	Checksum: 0x368D6748
	Offset: 0x1B08
	Size: 0x123
	Parameters: 0
	Flags: Private
*/
function private function_8c4e826e()
{
	blackboard::CreateBlackBoardForEntity(self);
	ai::CreateInterfaceForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_sprint", undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_keeper_protector_attack", "inactive", undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: keepercompanionspawnsetup
	Namespace: keepercompanionbehavior
	Checksum: 0x4F791437
	Offset: 0x1C38
	Size: 0x24B
	Parameters: 0
	Flags: Private
*/
function private keepercompanionspawnsetup()
{
	self.fullHealth = self.health;
	self.highlyawareradius = 350;
	self.reviving_a_player = 0;
	self.companion_anchor_point = self.origin;
	self.next_move_time = GetTime();
	self.allow_zombie_to_target_ai = 1;
	self.ignoreme = 1;
	self.fovcosine = 0;
	self.fovcosinebusy = self.fovcosine;
	self.maxVisibleDist = 900;
	self.goalRadius = 16;
	self SetAvoidanceMask("avoid none");
	self notsolid();
	self ghost();
	self.var_fb400bf7 = [];
	self.var_fb400bf7[0] = "double_points";
	self.var_fb400bf7[1] = "fire_sale";
	self.var_fb400bf7[2] = "insta_kill";
	self.var_fb400bf7[3] = "nuke";
	self.var_fb400bf7[4] = "full_ammo";
	self.var_fb400bf7[5] = "insta_kill_ug";
	self.var_3e807a19 = GetTime();
	self.var_733ed347 = GetTime();
	self thread function_98f178fc(self);
	self.var_2c553c41 = spawn("script_model", self.origin);
	self.var_2c553c41 SetModel("tag_origin");
	self.var_2c553c41 notsolid();
	self.var_2c553c41 LinkTo(self, "tag_origin", (0, 0, 0), VectorScale((-1, 0, 0), 90));
	self thread function_5250c5dd();
}

/*
	Name: function_98f178fc
	Namespace: keepercompanionbehavior
	Checksum: 0xA4E9E21A
	Offset: 0x1E90
	Size: 0xDF
	Parameters: 1
	Flags: Private
*/
function private function_98f178fc(entity)
{
	entity endon("death");
	while(1)
	{
		/#
			RecordCircle(entity.origin, 700, (1, 0, 0), "Dev Block strings are not supported", entity);
			if(isdefined(entity.var_8cf1ff79))
			{
				recordLine(entity.origin, entity.var_8cf1ff79, (0, 0, 1), "Dev Block strings are not supported", entity);
				RecordSphere(entity.var_8cf1ff79, 8, (0, 0, 1), "Dev Block strings are not supported", entity);
			}
		#/
		wait(0.05);
	}
}

/*
	Name: keepercompaniondelaymovement
	Namespace: keepercompanionbehavior
	Checksum: 0x264D6D31
	Offset: 0x1F78
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private keepercompaniondelaymovement(entity)
{
	entity PathMode("move delayed", 0, RandomFloatRange(1, 2));
}

/*
	Name: _IsValidPlayer
	Namespace: keepercompanionbehavior
	Checksum: 0xD818C886
	Offset: 0x1FC8
	Size: 0xAD
	Parameters: 1
	Flags: Private
*/
function private _IsValidPlayer(player)
{
	if(!isdefined(player) || !isalive(player) || !isPlayer(player) || player.sessionstate == "spectator" || player.sessionstate == "intermission" || player laststand::player_is_in_laststand() || player.ignoreme)
	{
		return 0;
	}
	return 1;
}

/*
	Name: keepercompanionshouldtraverse
	Namespace: keepercompanionbehavior
	Checksum: 0x8719B416
	Offset: 0x2080
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function keepercompanionshouldtraverse(entity)
{
	if(isdefined(entity.traverseStartNode))
	{
		return 1;
	}
	return 0;
}

/*
	Name: keepercompanionshouldmove
	Namespace: keepercompanionbehavior
	Checksum: 0x99305865
	Offset: 0x20B0
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private keepercompanionshouldmove(entity)
{
	if(!entity HasPath())
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_469c9511
	Namespace: keepercompanionbehavior
	Checksum: 0x9FE8A9B3
	Offset: 0x20E8
	Size: 0x1DB
	Parameters: 1
	Flags: Private
*/
function private function_469c9511(entity)
{
	entity endon("death");
	entity endon("outro");
	if(isdefined(entity.forcefire) && entity.forcefire)
	{
		return;
	}
	entity.var_539a912c = GetTime() + 2500;
	entity.var_f1e0aeaf = 1;
	wait(3);
	if(!isdefined(entity) || !isdefined(entity.leader))
	{
		entity.var_f1e0aeaf = 0;
		return;
	}
	position = entity.leader.origin;
	queryResult = PositionQuery_Source_Navigation(entity.leader.origin, 96, 256, 48, 20, entity);
	if(queryResult.data.size)
	{
		result = queryResult.data[RandomInt(queryResult.data.size)];
		position = result.origin;
	}
	angles = VectorToAngles(position - entity.leader.origin);
	entity teleport_to_location(position, angles);
	entity.var_f1e0aeaf = 0;
}

/*
	Name: keepercompanionmovementservice
	Namespace: keepercompanionbehavior
	Checksum: 0x735727BB
	Offset: 0x22D0
	Size: 0xA1B
	Parameters: 1
	Flags: Private
*/
function private keepercompanionmovementservice(entity)
{
	if(isdefined(level.companion_leader) && (isdefined(level.companion_leader.eligible_leader) && level.companion_leader.eligible_leader))
	{
		entity.leader = level.companion_leader;
	}
	if(isdefined(entity.outro) && entity.outro)
	{
		return;
	}
	if(entity.var_2fd11bbd === 1)
	{
		return;
	}
	if(!isdefined(entity.var_57e708f6))
	{
		entity.var_57e708f6 = 0;
	}
	if(entity.reviving_a_player === 1)
	{
		return;
	}
	if(entity.var_53ce2a4e === 1 || entity.b_teleporting === 1)
	{
		return;
	}
	if(entity.var_c0e8df41 === 1)
	{
		return;
	}
	if(entity.var_f1e0aeaf === 1)
	{
		return;
	}
	if(isdefined(entity.leader))
	{
		if(isdefined(entity.leader.b_teleporting === 1) && entity.leader.b_teleporting === 1)
		{
			entity thread function_34117adf(entity.leader.teleport_location);
			return;
		}
		if(entity.leader.is_flung === 1)
		{
			if(isdefined(entity.leader.var_fa1ecd39))
			{
				entity thread take_flinger(entity.leader.var_fa1ecd39);
			}
			return;
		}
		if(DistanceSquared(entity.leader.origin, entity.origin) > 490000)
		{
			if(!isdefined(entity.var_539a912c) || GetTime() > entity.var_539a912c)
			{
				entity thread function_469c9511(entity);
			}
		}
	}
	foreach(player in level.players)
	{
		if(player laststand::player_is_in_laststand() && entity.reviving_a_player === 0 && player.reviveTrigger.beingRevived !== 1)
		{
			time = GetTime();
			if(DistanceSquared(entity.origin, player.origin) <= 1024 * 1024 && time >= entity.var_57e708f6)
			{
				entity.reviving_a_player = 1;
				entity function_95adf61c(player);
				return;
			}
		}
	}
	if(!isdefined(entity.var_a0c5deb2))
	{
		entity.var_a0c5deb2 = GetTime();
	}
	if(GetTime() >= entity.var_a0c5deb2 && isdefined(level.active_powerups) && level.active_powerups.size > 0)
	{
		if(!isdefined(entity.var_34a9f1ad))
		{
			entity.var_34a9f1ad = 0;
		}
		foreach(powerup in level.active_powerups)
		{
			if(IsInArray(entity.var_fb400bf7, powerup.powerup_name))
			{
				dist = DistanceSquared(entity.origin, powerup.origin);
				if(dist <= 147456 && RandomInt(100) < 50 + 10 * entity.var_34a9f1ad)
				{
					entity SetGoal(powerup.origin, 1);
					entity.var_a0c5deb2 = GetTime() + randomIntRange(2500, 3500);
					entity.next_move_time = GetTime() + randomIntRange(2500, 3500);
					entity.var_34a9f1ad = 0;
					return;
				}
				entity.var_34a9f1ad = entity.var_34a9f1ad + 1;
			}
		}
		entity.var_a0c5deb2 = GetTime() + randomIntRange(333, 666);
	}
	follow_radius_squared = 256 * 256;
	if(isdefined(entity.leader))
	{
		entity.companion_anchor_point = entity.leader.origin;
	}
	dist_check_start_point = entity.origin;
	if(isdefined(entity.pathGoalPos))
	{
		dist_check_start_point = entity.pathGoalPos;
	}
	if(DistanceSquared(dist_check_start_point, entity.companion_anchor_point) > follow_radius_squared)
	{
		if(isdefined(entity.leader) && entity.companion_anchor_point == entity.leader.origin)
		{
			enemies = GetAITeamArray(level.zombie_team);
			validEnemies = [];
			foreach(enemy in enemies)
			{
				if(isdefined(enemy.completed_emerging_into_playable_area) && enemy.completed_emerging_into_playable_area && entity cansee(entity.leader, 3000) && util::within_fov(entity.leader.origin, entity.leader.angles, enemy.origin, cos(70)))
				{
					validEnemies[validEnemies.size] = enemy;
				}
			}
			if(isdefined(validEnemies) && validEnemies.size)
			{
				averagepoint = get_average_origin(validEnemies, entity.leader.origin[2]);
				var_be4a51b9 = VectorNormalize(averagepoint - entity.leader.origin);
				point = entity.leader.origin + VectorScale(var_be4a51b9, 179.2);
				entity.companion_anchor_point = point + VectorScale(AnglesToRight(entity.leader.angles), 30);
			}
		}
		entity pick_new_movement_point();
	}
	if(GetTime() >= entity.next_move_time && (!isdefined(entity.var_92aa697) && entity.var_92aa697))
	{
		entity pick_new_movement_point();
	}
}

/*
	Name: get_average_origin
	Namespace: keepercompanionbehavior
	Checksum: 0x894FE74D
	Offset: 0x2CF8
	Size: 0x113
	Parameters: 2
	Flags: Private
*/
function private get_average_origin(entities, var_d4653ed3)
{
	/#
		Assert(IsArray(entities));
	#/
	/#
		Assert(entities.size > 0);
	#/
	totalx = 0;
	totaly = 0;
	for(i = 0; i < entities.size; i++)
	{
		totalx = totalx + entities[i].origin[0];
		totaly = totaly + entities[i].origin[1];
	}
	return (totalx / entities.size, totaly / entities.size, var_d4653ed3);
}

/*
	Name: function_34117adf
	Namespace: keepercompanionbehavior
	Checksum: 0xEC0765FC
	Offset: 0x2E18
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private function_34117adf(var_5935e1b9)
{
	self endon("death");
	self.var_53ce2a4e = 1;
	self SetGoal(var_5935e1b9, 1);
	self waittill("goal");
	wait(1);
	self.var_53ce2a4e = 0;
}

/*
	Name: teleport_to_location
	Namespace: keepercompanionbehavior
	Checksum: 0xF89FB7BC
	Offset: 0x2E80
	Size: 0x127
	Parameters: 2
	Flags: Private
*/
function private teleport_to_location(position, angles)
{
	self endon("death");
	self endon("outro");
	self notify("teleport_to_location");
	self endon("teleport_to_location");
	self.var_641791df = 1;
	self clearPath();
	self PathMode("dont move");
	self scene::Play("cin_zm_dlc4_keeper_prtctr_teleport_out", self);
	self ForceTeleport(position, angles);
	self scene::Play("cin_zm_dlc4_keeper_prtctr_teleport_in", self);
	self PathMode("move allowed");
	self SetGoal(position);
	self.var_641791df = 0;
}

/*
	Name: take_flinger
	Namespace: keepercompanionbehavior
	Checksum: 0xADE354E2
	Offset: 0x2FB0
	Size: 0x173
	Parameters: 1
	Flags: Private
*/
function private take_flinger(var_ee6ad78e)
{
	self endon("death");
	self endon("outro");
	self.var_c0e8df41 = 1;
	var_c9277d64 = GetNodeArray("flinger_traversal", "script_noteworthy");
	var_292fba5b = ArrayGetClosest(var_ee6ad78e, var_c9277d64);
	var_577ef8dd = GetNode(var_292fba5b.target, "targetname");
	self teleport_to_location(var_577ef8dd.origin, var_577ef8dd.angles);
	while(!isdefined(self.leader) || !isalive(self.leader) || (isdefined(self.leader.is_flung) && self.leader.is_flung))
	{
		self SetGoal(var_577ef8dd.origin);
		wait(0.05);
	}
	self.var_c0e8df41 = 0;
}

/*
	Name: pick_new_movement_point
	Namespace: keepercompanionbehavior
	Checksum: 0x6DA9A7B7
	Offset: 0x3130
	Size: 0x1DB
	Parameters: 0
	Flags: Private
*/
function private pick_new_movement_point()
{
	queryResult = PositionQuery_Source_Navigation(self.companion_anchor_point, 96, 256, 48, 20, self);
	if(queryResult.data.size)
	{
		if(isdefined(self.enemy) && self.enemy.archetype == "parasite")
		{
			Array::filter(queryResult.data, 0, &function_ab299a53, self.enemy);
		}
	}
	if(queryResult.data.size)
	{
		point = queryResult.data[RandomInt(queryResult.data.size)];
		pathSuccess = self FindPath(self.origin, point.origin, 1, 0);
		if(pathSuccess)
		{
			self.companion_destination = point.origin;
		}
		else
		{
			self.next_move_time = GetTime() + randomIntRange(500, 1500);
			return;
		}
	}
	if(isdefined(self.companion_destination))
	{
		self SetGoal(self.companion_destination, 1);
	}
	self.next_move_time = GetTime() + randomIntRange(6000, 9000);
}

/*
	Name: function_ab299a53
	Namespace: keepercompanionbehavior
	Checksum: 0xC61FF39C
	Offset: 0x3318
	Size: 0xB7
	Parameters: 1
	Flags: Private
*/
function private function_ab299a53(parasite)
{
	point = self;
	height_difference = Abs(point.origin[2] - parasite.origin[2]);
	var_3b804002 = 1.5 * height_difference * 1.5 * height_difference;
	return DistanceSquared(point.origin, parasite.origin) > var_3b804002;
}

/*
	Name: function_95adf61c
	Namespace: keepercompanionbehavior
	Checksum: 0x189D5488
	Offset: 0x33D8
	Size: 0x4EB
	Parameters: 1
	Flags: None
*/
function function_95adf61c(player)
{
	self endon("outro");
	self endon("revive_terminated");
	self endon("end_game");
	player endon("end_game");
	if(!(isdefined(self.reviving_a_player) && self.reviving_a_player))
	{
		self.reviving_a_player = 1;
	}
	player.var_c35d3027 = 0;
	self thread function_f95febaf(player);
	queryResult = PositionQuery_Source_Navigation(player.origin, 64, 96, 48, 18, self);
	if(queryResult.data.size)
	{
		point = queryResult.data[RandomInt(queryResult.data.size)];
		self.companion_destination = point.origin;
	}
	else
	{
		self.companion_destination = player.origin;
	}
	if(DistanceSquared(self.companion_destination, self.origin) <= 450 * 450)
	{
		self ForceTeleport(self.origin, self.angles, 1);
		wait(0.05);
		self SetGoal(self.companion_destination, 1);
		self waittill("goal");
		self.var_1a5b8ffb = 1;
		self.reviving_player = player;
		wait(2);
	}
	else
	{
		angles = VectorToAngles(player.origin - self.companion_destination);
		self teleport_to_location(self.companion_destination, angles);
	}
	level.var_46040f3e = 1;
	player.reviveTrigger.beingRevived = 1;
	player.var_c35d3027 = 1;
	self scene::Play("cin_zm_dlc4_keeper_prtctr_revive_intro", self);
	player clientfield::set("being_keeper_revived", 1);
	self clientfield::set("keeper_reviving", 1);
	self scene::Play("cin_zm_dlc4_keeper_prtctr_revive_loop", self);
	self clientfield::set("keeper_reviving", 0);
	self scene::Play("cin_zm_dlc4_keeper_prtctr_revive_outtro", self);
	if(level.players.size == 1 && level flag::get("solo_game"))
	{
		self.var_57e708f6 = GetTime() + 8000;
	}
	else
	{
		self.var_57e708f6 = GetTime() + 5000;
	}
	if(player laststand::player_is_in_laststand())
	{
		player notify("stop_revive_trigger");
		if(isPlayer(player))
		{
			player AllowJump(1);
		}
		player.laststand = undefined;
		player thread zm_laststand::revive_success(self, 0);
	}
	level.var_46040f3e = 0;
	players = GetPlayers();
	if(players.size == 1 && level flag::get("solo_game") && (isdefined(player.waiting_to_revive) && player.waiting_to_revive))
	{
		level.solo_game_free_player_quickrevive = 1;
		player thread zm_perks::give_perk("specialty_quickrevive", 0);
	}
	self function_703fda6d(player);
}

/*
	Name: function_f95febaf
	Namespace: keepercompanionbehavior
	Checksum: 0x77DCBF4
	Offset: 0x38D0
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function function_f95febaf(player)
{
	self endon("revive_terminated");
	while(1)
	{
		if(isdefined(player.reviveTrigger) && player.reviveTrigger.beingRevived === 1 && player.var_c35d3027 !== 1)
		{
			self function_703fda6d(player);
		}
		if(!(isdefined(player laststand::player_is_in_laststand()) && player laststand::player_is_in_laststand()))
		{
			self function_703fda6d(player);
		}
		wait(0.05);
	}
}

/*
	Name: function_703fda6d
	Namespace: keepercompanionbehavior
	Checksum: 0x69A9E703
	Offset: 0x39B0
	Size: 0x129
	Parameters: 1
	Flags: None
*/
function function_703fda6d(player)
{
	self.reviving_a_player = 0;
	self.var_1a5b8ffb = 0;
	self.reviving_player = undefined;
	if(!isdefined(player))
	{
		foreach(player in level.players)
		{
			player.var_c35d3027 = 0;
			player clientfield::set("being_keeper_revived", 0);
		}
	}
	else if(player.var_c35d3027 == 1)
	{
		player.var_c35d3027 = 0;
		player clientfield::set("being_keeper_revived", 0);
	}
	self notify("revive_terminated");
}

/*
	Name: keepercompanionkeepsupdatemovementmode
	Namespace: keepercompanionbehavior
	Checksum: 0x4A842122
	Offset: 0x3AE8
	Size: 0xC3
	Parameters: 1
	Flags: Private
*/
function private keepercompanionkeepsupdatemovementmode(entity)
{
	var_ef42515b = 90000;
	var_1be8672c = 90000;
	dist = DistanceSquared(entity.origin, entity.companion_anchor_point);
	if(dist >= var_ef42515b)
	{
		blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
	else
	{
		blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_walk");
	}
}

/*
	Name: function_36af0313
	Namespace: keepercompanionbehavior
	Checksum: 0x82EE78BD
	Offset: 0x3BB8
	Size: 0x323
	Parameters: 2
	Flags: Private
*/
function private function_36af0313(entity, var_109b8552)
{
	entity endon("death");
	entity notify("hash_36af0313");
	entity endon("hash_36af0313");
	entity.var_92aa697 = 1;
	while(1)
	{
		if(!isdefined(entity.var_8cf1ff79))
		{
			break;
		}
		else if(!util::within_fov(entity.origin, entity.angles, entity.var_8cf1ff79, cos(70)))
		{
			wait(0.1);
			continue;
		}
		entity.holdFire = 0;
		entity.forcefire = 1;
		blackboard::SetBlackBoardAttribute(entity, "_keeper_protector_attack", "active");
		fireanimlength = undefined;
		if(var_109b8552 == "single")
		{
			if(math::cointoss())
			{
				blackboard::SetBlackBoardAttribute(entity, "_keeper_protector_attack_type", "left");
				fireanimlength = getanimlength("ai_zm_dlc4_keeper_prtctr_idle_attack_left");
			}
			else
			{
				blackboard::SetBlackBoardAttribute(entity, "_keeper_protector_attack_type", "right");
				fireanimlength = getanimlength("ai_zm_dlc4_keeper_prtctr_idle_attack_right");
			}
		}
		else
		{
			blackboard::SetBlackBoardAttribute(entity, "_keeper_protector_attack_type", "combo");
			fireanimlength = getanimlength("ai_zm_dlc4_keeper_prtctr_idle_attack_combo");
		}
		/#
			if(isdefined(level.var_c3eaadba) && level.var_c3eaadba)
			{
				blackboard::SetBlackBoardAttribute(entity, "Dev Block strings are not supported", "Dev Block strings are not supported");
				fireanimlength = getanimlength("Dev Block strings are not supported");
			}
		#/
		entity.var_285f7306 = GetTime() + fireanimlength * 1000;
		/#
			recordEntText("Dev Block strings are not supported", self, (0, 1, 0), "Dev Block strings are not supported");
		#/
		wait(fireanimlength);
		/#
			recordEntText("Dev Block strings are not supported", self, (0, 1, 0), "Dev Block strings are not supported");
		#/
		blackboard::SetBlackBoardAttribute(entity, "_keeper_protector_attack", "inactive");
		entity.var_92aa697 = 0;
		break;
	}
}

/*
	Name: function_5d2ab113
	Namespace: keepercompanionbehavior
	Checksum: 0xA8AAAE53
	Offset: 0x3EE8
	Size: 0x8F
	Parameters: 1
	Flags: Private
*/
function private function_5d2ab113(entity)
{
	/#
		recordEntText("Dev Block strings are not supported", self, (1, 0, 0), "Dev Block strings are not supported");
	#/
	blackboard::SetBlackBoardAttribute(entity, "_keeper_protector_attack", "inactive");
	entity.var_92aa697 = 0;
	entity.holdFire = 1;
	entity.forcefire = 0;
}

/*
	Name: function_87727b5b
	Namespace: keepercompanionbehavior
	Checksum: 0x2F436FD2
	Offset: 0x3F80
	Size: 0x27D
	Parameters: 1
	Flags: Private
*/
function private function_87727b5b(entity)
{
	enemies = GetAIArray();
	validEnemies = [];
	foreach(enemy in enemies)
	{
		if(enemy.team != entity.team && (entity cansee(enemy) || DistanceSquared(entity.origin, enemy.origin) <= 350 * 350))
		{
			if(enemy.archetype === "zombie" && (!isdefined(enemy.completed_emerging_into_playable_area) && enemy.completed_emerging_into_playable_area))
			{
				continue;
			}
			if(enemy ishidden())
			{
				continue;
			}
			if(!isalive(enemy))
			{
				continue;
			}
			if(isdefined(enemy.isTeleporting) && enemy.isTeleporting)
			{
				continue;
			}
			validEnemies[validEnemies.size] = enemy;
		}
	}
	/#
		foreach(enemy in validEnemies)
		{
			recordLine(entity.origin, enemy.origin, (0, 1, 0), "Dev Block strings are not supported", entity);
		}
	#/
	return validEnemies;
}

/*
	Name: keeperupdatethunderwallattackparams
	Namespace: keepercompanionbehavior
	Checksum: 0xF8CFC967
	Offset: 0x4208
	Size: 0x3A5
	Parameters: 1
	Flags: Private
*/
function private keeperupdatethunderwallattackparams(entity)
{
	var_9540bf56 = 1;
	if(isdefined(entity.var_92aa697) && entity.var_92aa697)
	{
		if(isdefined(entity.var_285f7306))
		{
			var_9540bf56 = GetTime() >= entity.var_285f7306;
		}
	}
	if(isdefined(self.var_641791df) && self.var_641791df)
	{
		return;
	}
	shouldfire = 0;
	validEnemies = [];
	enemygroup = [];
	validEnemies = function_87727b5b(entity);
	closestEnemy = ArrayGetClosest(entity.origin, validEnemies, 700);
	if(!isdefined(closestEnemy))
	{
		entity.var_8cf1ff79 = undefined;
	}
	else
	{
		enemygroup = Array::get_all_closest(closestEnemy.origin, validEnemies, undefined, undefined, 700);
		if(!isdefined(enemygroup) || !enemygroup.size)
		{
			entity.var_8cf1ff79 = undefined;
		}
		else if(GetTime() >= entity.var_3e807a19)
		{
			if(enemygroup.size)
			{
				entity.var_8cf1ff79 = get_average_origin(enemygroup, entity.origin[2]);
				shouldfire = 1;
			}
		}
		else
		{
			entity.var_8cf1ff79 = get_average_origin(enemygroup, entity.origin[2]);
		}
	}
	if(!var_9540bf56)
	{
		return;
	}
	if(!shouldfire)
	{
		function_5d2ab113(entity);
	}
	else if(shouldfire && (!isdefined(entity.var_92aa697) && entity.var_92aa697) && isdefined(entity.var_8cf1ff79))
	{
		if(enemygroup.size <= 3 && DistanceSquared(entity.var_8cf1ff79, entity.origin) < 500 * 500)
		{
			if(RandomInt(100) < 10)
			{
				var_109b8552 = "combo";
				cooldowntime = entity.var_733ed347;
			}
			else
			{
				var_109b8552 = "single";
				cooldowntime = entity.var_3e807a19;
			}
		}
		else if(enemygroup.size >= 3)
		{
			var_109b8552 = "combo";
			cooldowntime = entity.var_733ed347;
		}
		else
		{
			return 0;
		}
		if(GetTime() >= cooldowntime)
		{
			function_36af0313(entity, var_109b8552);
		}
	}
	return 0;
}

/*
	Name: keepercompanionupdateleader
	Namespace: keepercompanionbehavior
	Checksum: 0x7E623F34
	Offset: 0x45B8
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private keepercompanionupdateleader(entity)
{
	if(!entity.reviving_a_player)
	{
		if(!isdefined(entity.leader) || (!isdefined(entity.leader.eligible_leader) && entity.leader.eligible_leader))
		{
			entity define_new_leader();
		}
	}
}

/*
	Name: define_new_leader
	Namespace: keepercompanionbehavior
	Checksum: 0x1A58401A
	Offset: 0x4640
	Size: 0x17D
	Parameters: 0
	Flags: Private
*/
function private define_new_leader()
{
	if(isdefined(level.companion_leader) && (isdefined(level.companion_leader.eligible_leader) && level.companion_leader.eligible_leader))
	{
		self.leader = level.companion_leader;
		break;
	}
	a_potential_leaders = get_potential_leaders(self);
	closest_leader = undefined;
	closest_distance = 1000000;
	if(a_potential_leaders.size == 0)
	{
		self.leader = undefined;
		break;
	}
	foreach(potential_leader in a_potential_leaders)
	{
		dist = PathDistance(self.origin, potential_leader.origin);
		if(isdefined(dist) && dist < closest_distance)
		{
			closest_distance = dist;
			self.leader = potential_leader;
		}
	}
}

/*
	Name: get_potential_leaders
	Namespace: keepercompanionbehavior
	Checksum: 0xA7237BE6
	Offset: 0x47C8
	Size: 0x121
	Parameters: 1
	Flags: Private
*/
function private get_potential_leaders(companion)
{
	a_potential_leaders = [];
	foreach(player in level.players)
	{
		if(!isdefined(player.eligible_leader))
		{
			player.eligible_leader = 1;
		}
		if(isdefined(player.eligible_leader) && player.eligible_leader && companion FindPath(companion.origin, player.origin))
		{
			a_potential_leaders[a_potential_leaders.size] = player;
		}
	}
	return a_potential_leaders;
}

/*
	Name: function_7cbb0165
	Namespace: keepercompanionbehavior
	Checksum: 0x6495F33C
	Offset: 0x48F8
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_7cbb0165(entity)
{
}

/*
	Name: function_c6326468
	Namespace: keepercompanionbehavior
	Checksum: 0x57B7DC2D
	Offset: 0x4910
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_c6326468(entity)
{
	function_68cd1247(entity, "attack_left");
}

/*
	Name: function_ec3b8737
	Namespace: keepercompanionbehavior
	Checksum: 0x7DB7B7C5
	Offset: 0x4948
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_ec3b8737(entity)
{
	function_68cd1247(entity, "attack_right");
}

/*
	Name: function_86b6a4a8
	Namespace: keepercompanionbehavior
	Checksum: 0x97F03172
	Offset: 0x4980
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_86b6a4a8(entity)
{
	function_68cd1247(entity, "attack_up");
}

/*
	Name: function_68cd1247
	Namespace: keepercompanionbehavior
	Checksum: 0x2418A580
	Offset: 0x49B8
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function function_68cd1247(entity, var_e54db1ed)
{
	var_4fd6352b = entity GetTagOrigin("tag_weapon_right");
	entity thread function_cd2f0f8a(entity, var_4fd6352b, var_e54db1ed);
	if(var_e54db1ed == "attack_up")
	{
		entity.var_2c553c41 clientfield::increment("keeper_thunderwall_360");
		entity.var_733ed347 = randomIntRange(1200, 2100);
		entity.var_733ed347 = GetTime() + entity.var_733ed347;
	}
	else
	{
		entity clientfield::increment("keeper_thunderwall");
		entity.var_3e807a19 = randomIntRange(1200, 2100);
		entity.var_3e807a19 = GetTime() + entity.var_3e807a19;
	}
}

/*
	Name: function_5c472d67
	Namespace: keepercompanionbehavior
	Checksum: 0x1E4C371C
	Offset: 0x4B08
	Size: 0x46B
	Parameters: 3
	Flags: Private
*/
function private function_5c472d67(entity, var_4fd6352b, var_e54db1ed)
{
	var_9b627b75 = blackboard::GetBlackBoardAttribute(self, "_keeper_protector_attack_type");
	var_9357f4f4 = 500;
	if(var_9b627b75 == "combo")
	{
		var_9357f4f4 = 250;
	}
	var_13bc5a88 = 700 * 700;
	if(var_e54db1ed == "attack_left" || var_e54db1ed == "attack_right")
	{
		zombies = Array::get_all_closest(var_4fd6352b, GetAITeamArray(level.zombie_team), undefined, Int(5), var_9357f4f4);
		var_13bc5a88 = var_9357f4f4 * var_9357f4f4;
	}
	else
	{
		zombies = Array::get_all_closest(var_4fd6352b, GetAITeamArray(level.zombie_team), undefined, 15, 300);
		var_13bc5a88 = 300 * 300;
	}
	if(!isdefined(zombies))
	{
		return;
	}
	if(!zombies.size)
	{
		return;
	}
	fov = cos(70);
	if(var_e54db1ed == "attack_left" || var_e54db1ed == "attack_right")
	{
		fov = cos(60);
	}
	entity.var_13833827 = [];
	foreach(zombie in zombies)
	{
		if(!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}
		if(var_e54db1ed != "attack_up")
		{
			tooClose = DistanceSquared(var_4fd6352b, zombie.origin) <= 64 * 64;
			if(!tooClose && !util::within_fov(var_4fd6352b, entity.angles, zombie.origin, fov))
			{
				continue;
			}
		}
		var_ce2c8115 = DistanceSquared(var_4fd6352b, zombie GetCentroid());
		level.var_fb631584[level.var_fb631584.size] = zombie;
		distmultiplier = var_13bc5a88 - var_ce2c8115 / var_13bc5a88;
		if(var_e54db1ed == "attack_up")
		{
			var_94f0027d = VectorNormalize(zombie.origin - entity.origin + VectorScale((0, 0, 1), 200));
		}
		else
		{
			var_94f0027d = VectorNormalize(zombie.origin - entity.origin);
		}
		var_94f0027d = (var_94f0027d[0], var_94f0027d[1], Abs(var_94f0027d[2]));
		var_94f0027d = VectorScale(var_94f0027d, 75 + 75 * distmultiplier);
		level.var_90c9a476[level.var_90c9a476.size] = var_94f0027d;
	}
}

#namespace namespace_78f8bb8;

/*
	Name: __constructor
	Namespace: namespace_78f8bb8
	Checksum: 0xE30EEFD5
	Offset: 0x4F80
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.var_2db009f1 = GetTime();
	self.var_8e6eac66 = 0;
	self.var_54c7425 = GetTime();
}

/*
	Name: __destructor
	Namespace: namespace_78f8bb8
	Checksum: 0x99EC1590
	Offset: 0x4FB0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace keepercompanionbehavior;

/*
	Name: function_78f8bb8
	Namespace: keepercompanionbehavior
	Checksum: 0x38421D92
	Offset: 0x4FC0
	Size: 0x85
	Parameters: 0
	Flags: 6
*/
function private autoexec function_78f8bb8()
{
	classes.var_78f8bb8[0] = spawnstruct();
	classes.var_78f8bb8[0].__vtable[1606033458] = &namespace_78f8bb8::__destructor;
	classes.var_78f8bb8[0].__vtable[-1690805083] = &namespace_78f8bb8::__constructor;
}

/*
	Name: function_84e1787e
	Namespace: keepercompanionbehavior
	Checksum: 0xCF5D120D
	Offset: 0x5050
	Size: 0x11B
	Parameters: 2
	Flags: Private
*/
function private function_84e1787e(entity, ai)
{
	if(!isdefined(ai.var_78f8bb8))
	{
		__constructor();
		ai.var_78f8bb8 = var_78f8bb8;
	}
	/#
		Assert(isdefined(ai.var_78f8bb8));
	#/
	if(GetTime() > ai.var_78f8bb8.var_2db009f1)
	{
		ai.var_78f8bb8.var_8e6eac66 = ai.var_78f8bb8.var_8e6eac66 + 100;
		ai.var_78f8bb8.var_2db009f1 = GetTime() + randomIntRange(2500, 3500);
	}
	if(ai.var_78f8bb8.var_8e6eac66 >= 200)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_e620963b
	Namespace: keepercompanionbehavior
	Checksum: 0x66AD8144
	Offset: 0x5178
	Size: 0x4E3
	Parameters: 5
	Flags: Private
*/
function private function_e620963b(entity, ai, var_4fd6352b, var_94f0027d, var_e54db1ed)
{
	if(!isdefined(ai) || !isalive(ai))
	{
		return;
	}
	if(ai.archetype == "margwa")
	{
		if(function_84e1787e(entity, ai))
		{
			if(isdefined(ai.thundergun_fling_func))
			{
				ai thread [[ai.thundergun_fling_func]](entity);
			}
		}
		else
		{
			Assert(isdefined(ai.var_78f8bb8));
			if(isdefined(ai.canStun) && ai.canStun && GetTime() >= ai.var_78f8bb8.var_54c7425)
			{
				ai.reactStun = 1;
				ai.var_78f8bb8.var_54c7425 = GetTime() + randomIntRange(3000, 5000);
			}
		}
		/#
		#/
	}
	else if(ai.archetype == "mechz")
	{
		if(function_84e1787e(entity, ai))
		{
			if(isdefined(ai.thundergun_fling_func))
			{
				ai thread [[ai.thundergun_fling_func]](entity);
			}
		}
		else
		{
			Assert(isdefined(ai.var_78f8bb8));
			if(isdefined(ai.canStun) && ai.canStun && GetTime() >= ai.var_78f8bb8.var_54c7425)
			{
				ai.reactStun = 1;
				ai.var_78f8bb8.var_54c7425 = GetTime() + randomIntRange(3000, 5000);
			}
		}
		/#
		#/
	}
	else if(var_e54db1ed == "attack_up")
	{
		ai DoDamage(20000, var_4fd6352b, entity);
	}
	else
	{
		ai DoDamage(17000, var_4fd6352b, entity);
	}
	if(!isalive(ai))
	{
		ai clientfield::set("keeper_ai_death_effect", 1);
		level notify("hash_1fe79fb5", ai);
		if(isdefined(entity.leader.var_71148446) && IsInArray(entity.leader.var_71148446, self.archetype))
		{
			ArrayRemoveValue(entity.leader.var_71148446, ai.archetype);
			entity.leader notify("hash_af442f7c");
		}
		foreach(player in level.players)
		{
			if(player laststand::player_is_in_laststand())
			{
				player notify("hash_935cc366");
			}
		}
		if(ai.archetype === "zombie")
		{
			if(RandomInt(100) < 30)
			{
				ai zombie_utility::gib_random_parts();
			}
			ai StartRagdoll();
			ai LaunchRagdoll(var_94f0027d);
		}
	}
}

/*
	Name: function_cd2f0f8a
	Namespace: keepercompanionbehavior
	Checksum: 0x3E1C2840
	Offset: 0x5668
	Size: 0xFB
	Parameters: 3
	Flags: Private
*/
function private function_cd2f0f8a(entity, var_4fd6352b, var_e54db1ed)
{
	if(!isdefined(level.var_fb631584))
	{
		level.var_fb631584 = [];
		level.var_90c9a476 = [];
	}
	entity function_5c472d67(entity, var_4fd6352b, var_e54db1ed);
	for(i = 0; i < level.var_fb631584.size; i++)
	{
		ai = level.var_fb631584[i];
		ai thread function_e620963b(entity, ai, var_4fd6352b, level.var_90c9a476[i], var_e54db1ed);
		wait(0.05);
	}
	level.var_fb631584 = [];
	level.var_90c9a476 = [];
}

/*
	Name: function_5250c5dd
	Namespace: keepercompanionbehavior
	Checksum: 0xD8E9E6E8
	Offset: 0x5770
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private function_5250c5dd()
{
	level waittill("intermission");
	wait(5.25);
	self.allowdeath = 1;
	self kill();
}

