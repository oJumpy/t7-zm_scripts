#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\ai_squads;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\archetype_zod_companion_interface;

#namespace ARCHETYPE_ZOD_COMPANION;

/*
	Name: main
	Namespace: ARCHETYPE_ZOD_COMPANION
	Checksum: 0x17284B84
	Offset: 0xA08
	Size: 0xA3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("allplayers", "being_robot_revived", 1, 1, "int");
	spawner::add_archetype_spawn_function("zod_companion", &zodcompanionbehavior::archetypezodcompanionblackboardinit);
	spawner::add_archetype_spawn_function("zod_companion", &zodcompanionserverutils::zodcompanionsoldierspawnsetup);
	zodcompanioninterface::registerzodcompanioninterfaceattributes();
	zodcompanionbehavior::RegisterBehaviorScriptFunctions();
}

#namespace zodcompanionbehavior;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: zodcompanionbehavior
	Checksum: 0x436CEF15
	Offset: 0xAB8
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionTacticalWalkActionStart", &function_e2fa3648);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionAbleToShoot", &zodcompanionabletoshootcondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionShouldTacticalWalk", &function_d7405ceb);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionMovement", &function_522ee3d);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionDelayMovement", &function_2cb38d2c);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionSetDesiredStanceToStand", &function_f7d72d81);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionFinishedSprintTransition", &function_580c8f2d);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionSprintTransitioning", &function_27f60e31);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionKeepsCurrentMovementMode", &function_9ff1641);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionCanJuke", &function_92d6d6ff);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionCanPreemptiveJuke", &function_56b88d0a);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionJukeInitialize", &function_f6c0cf0f);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionPreemptiveJukeTerminate", &function_89bf89b5);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionTargetService", &function_c7372836);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionTryReacquireService", &function_ac06a0e7);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("manage_companion_movement", &function_e3a7ef95);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionCollisionService", &function_13a0d6ef);
}

/*
	Name: mocompIgnorePainFaceEnemyInit
	Namespace: zodcompanionbehavior
	Checksum: 0x555DE963
	Offset: 0xD70
	Size: 0x7B
	Parameters: 5
	Flags: Private
*/
function private mocompIgnorePainFaceEnemyInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 1;
	entity OrientMode("face enemy");
	entity animMode("pos deltas");
}

/*
	Name: mocompIgnorePainFaceEnemyTerminate
	Namespace: zodcompanionbehavior
	Checksum: 0x483B0F5B
	Offset: 0xDF8
	Size: 0x3B
	Parameters: 5
	Flags: Private
*/
function private mocompIgnorePainFaceEnemyTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 0;
}

/*
	Name: archetypezodcompanionblackboardinit
	Namespace: zodcompanionbehavior
	Checksum: 0x2BECAACE
	Offset: 0xE40
	Size: 0x1A3
	Parameters: 0
	Flags: Private
*/
function private archetypezodcompanionblackboardinit()
{
	entity = self;
	entity.pushable = 1;
	blackboard::CreateBlackBoardForEntity(entity);
	ai::CreateInterfaceForEntity(entity);
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_sprint", undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_move_mode", "normal", undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_gibbed_limbs", undefined, &zodcompaniongetgibbedlimbs);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	/#
		entity finalizetrackedblackboardattributes();
	#/
}

/*
	Name: zodcompaniongetgibbedlimbs
	Namespace: zodcompanionbehavior
	Checksum: 0x592AF342
	Offset: 0xFF0
	Size: 0xA5
	Parameters: 0
	Flags: Private
*/
function private zodcompaniongetgibbedlimbs()
{
	entity = self;
	rightArmGibbed = GibServerUtils::IsGibbed(entity, 16);
	leftArmGibbed = GibServerUtils::IsGibbed(entity, 32);
	if(rightArmGibbed && leftArmGibbed)
	{
		return "both_arms";
	}
	else if(rightArmGibbed)
	{
		return "right_arm";
	}
	else if(leftArmGibbed)
	{
		return "left_arm";
	}
	return "none";
}

/*
	Name: function_2cb38d2c
	Namespace: zodcompanionbehavior
	Checksum: 0x81C474F3
	Offset: 0x10A0
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_2cb38d2c(entity)
{
	entity PathMode("move delayed", 0, RandomFloatRange(1, 2));
}

/*
	Name: function_522ee3d
	Namespace: zodcompanionbehavior
	Checksum: 0x97FFAD11
	Offset: 0x10F0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private function_522ee3d(entity)
{
	if(blackboard::GetBlackBoardAttribute(entity, "_stance") != "stand")
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	}
}

/*
	Name: function_92d6d6ff
	Namespace: zodcompanionbehavior
	Checksum: 0x4D3CA24A
	Offset: 0x1158
	Size: 0x155
	Parameters: 1
	Flags: None
*/
function function_92d6d6ff(entity)
{
	if(!isdefined(entity.steppedOutOfCover) && entity.steppedOutOfCover && AiUtility::canJuke(entity))
	{
		jukeEvents = blackboard::GetBlackboardEvents("robot_juke");
		tooCloseJukeDistanceSqr = 57600;
		foreach(event in jukeEvents)
		{
			if(event.data.entity != entity && Distance2DSquared(entity.origin, event.data.origin) <= tooCloseJukeDistanceSqr)
			{
				return 0;
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: function_56b88d0a
	Namespace: zodcompanionbehavior
	Checksum: 0x18865039
	Offset: 0x12B8
	Size: 0x31D
	Parameters: 1
	Flags: None
*/
function function_56b88d0a(entity)
{
	if(!isdefined(entity.enemy) || !isPlayer(entity.enemy))
	{
		return 0;
	}
	if(blackboard::GetBlackBoardAttribute(entity, "_stance") == "crouch")
	{
		return 0;
	}
	if(!entity.shouldPreemptiveJuke)
	{
		return 0;
	}
	if(isdefined(entity.nextPreemptiveJuke) && entity.nextPreemptiveJuke > GetTime())
	{
		return 0;
	}
	if(entity.enemy PlayerAds() < entity.nextPreemptiveJukeAds)
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.enemy.origin) < 360000)
	{
		angleDifference = AbsAngleClamp180(entity.angles[1] - entity.enemy.angles[1]);
		/#
			Record3DText(angleDifference, entity.origin + VectorScale((0, 0, 1), 5), (0, 1, 0), "Dev Block strings are not supported");
		#/
		if(angleDifference > 135)
		{
			enemyAngles = entity.enemy GetGunAngles();
			toEnemy = entity.enemy.origin - entity.origin;
			FORWARD = AnglesToForward(enemyAngles);
			dotProduct = Abs(VectorDot(VectorNormalize(toEnemy), FORWARD));
			/#
				Record3DText(ACos(dotProduct), entity.origin + VectorScale((0, 0, 1), 10), (0, 1, 0), "Dev Block strings are not supported");
			#/
			if(dotProduct > 0.9848)
			{
				return function_92d6d6ff(entity);
			}
		}
	}
	return 0;
}

/*
	Name: _IsValidPlayer
	Namespace: zodcompanionbehavior
	Checksum: 0xE9BBCB3D
	Offset: 0x15E0
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
	Name: _FindClosest
	Namespace: zodcompanionbehavior
	Checksum: 0x84D9CF2A
	Offset: 0x1698
	Size: 0x141
	Parameters: 2
	Flags: Private
*/
function private _FindClosest(entity, entities)
{
	closest = spawnstruct();
	if(entities.size > 0)
	{
		closest.entity = entities[0];
		closest.DistanceSquared = DistanceSquared(entity.origin, closest.entity.origin);
		for(index = 1; index < entities.size; index++)
		{
			DistanceSquared = DistanceSquared(entity.origin, entities[index].origin);
			if(DistanceSquared < closest.DistanceSquared)
			{
				closest.DistanceSquared = DistanceSquared;
				closest.entity = entities[index];
			}
		}
	}
	return closest;
}

/*
	Name: function_c7372836
	Namespace: zodcompanionbehavior
	Checksum: 0x12B9842D
	Offset: 0x17E8
	Size: 0x433
	Parameters: 1
	Flags: Private
*/
function private function_c7372836(entity)
{
	if(zodcompanionabletoshootcondition(entity))
	{
		return 0;
	}
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	aiEnemies = [];
	playerEnemies = [];
	ai = GetAIArray();
	players = GetPlayers();
	positionOnNavMesh = GetClosestPointOnNavMesh(entity.origin, 200);
	if(!isdefined(positionOnNavMesh))
	{
		return;
	}
	foreach(value in ai)
	{
		if(value.team != entity.team && IsActor(value) && !isdefined(entity.favoriteenemy))
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh(value.origin, 200);
			if(isdefined(enemyPositionOnNavMesh) && entity FindPath(positionOnNavMesh, enemyPositionOnNavMesh, 1, 0))
			{
				aiEnemies[aiEnemies.size] = value;
			}
		}
	}
	foreach(value in players)
	{
		if(_IsValidPlayer(value))
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh(value.origin, 200);
			if(isdefined(enemyPositionOnNavMesh) && entity FindPath(positionOnNavMesh, enemyPositionOnNavMesh, 1, 0))
			{
				playerEnemies[playerEnemies.size] = value;
			}
		}
	}
	closestPlayer = _FindClosest(entity, playerEnemies);
	closestAI = _FindClosest(entity, aiEnemies);
	if(!isdefined(closestPlayer.entity) && !isdefined(closestAI.entity))
	{
		return;
	}
	else if(!isdefined(closestAI.entity))
	{
		entity.favoriteenemy = closestPlayer.entity;
	}
	else if(!isdefined(closestPlayer.entity))
	{
		entity.favoriteenemy = closestAI.entity;
	}
	else if(closestAI.DistanceSquared < closestPlayer.DistanceSquared)
	{
		entity.favoriteenemy = closestAI.entity;
	}
	else
	{
		entity.favoriteenemy = closestPlayer.entity;
	}
}

/*
	Name: function_e2fa3648
	Namespace: zodcompanionbehavior
	Checksum: 0xFD51892B
	Offset: 0x1C28
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private function_e2fa3648(entity)
{
	entity OrientMode("face enemy");
}

/*
	Name: zodcompanionabletoshootcondition
	Namespace: zodcompanionbehavior
	Checksum: 0xEBFC955B
	Offset: 0x1C60
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private zodcompanionabletoshootcondition(entity)
{
	return entity.weapon.name != level.weaponNone.name && !GibServerUtils::IsGibbed(entity, 16);
}

/*
	Name: function_d7405ceb
	Namespace: zodcompanionbehavior
	Checksum: 0xE4B8C005
	Offset: 0x1CC0
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private function_d7405ceb(entity)
{
	if(!entity HasPath())
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_f6c0cf0f
	Namespace: zodcompanionbehavior
	Checksum: 0xFC2FB338
	Offset: 0x1CF8
	Size: 0xAB
	Parameters: 1
	Flags: Private
*/
function private function_f6c0cf0f(entity)
{
	AiUtility::chooseJukeDirection(entity);
	entity clearPath();
	jukeInfo = spawnstruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;
	blackboard::AddBlackboardEvent("robot_juke", jukeInfo, 2000);
}

/*
	Name: function_89bf89b5
	Namespace: zodcompanionbehavior
	Checksum: 0xCE04FBD1
	Offset: 0x1DB0
	Size: 0x67
	Parameters: 1
	Flags: Private
*/
function private function_89bf89b5(entity)
{
	entity.nextPreemptiveJuke = GetTime() + randomIntRange(4000, 6000);
	entity.nextPreemptiveJukeAds = RandomFloatRange(0.5, 0.95);
}

/*
	Name: function_ac06a0e7
	Namespace: zodcompanionbehavior
	Checksum: 0x913AD5F5
	Offset: 0x1E20
	Size: 0x2F1
	Parameters: 1
	Flags: Private
*/
function private function_ac06a0e7(entity)
{
	if(!isdefined(entity.reacquire_state))
	{
		entity.reacquire_state = 0;
	}
	if(!isdefined(entity.enemy))
	{
		entity.reacquire_state = 0;
		return 0;
	}
	if(entity HasPath())
	{
		return 0;
	}
	if(!zodcompanionabletoshootcondition(entity))
	{
		return 0;
	}
	if(entity cansee(entity.enemy) && entity CanShootEnemy())
	{
		entity.reacquire_state = 0;
		return 0;
	}
	dirToEnemy = VectorNormalize(entity.enemy.origin - entity.origin);
	FORWARD = AnglesToForward(entity.angles);
	if(VectorDot(dirToEnemy, FORWARD) < 0.5)
	{
		entity.reacquire_state = 0;
		return 0;
	}
	switch(entity.reacquire_state)
	{
		case 0:
		case 1:
		case 2:
		{
			step_size = 32 + entity.reacquire_state * 32;
			reacquirePos = entity ReacquireStep(step_size);
			break;
		}
		case 4:
		{
			if(!entity cansee(entity.enemy) || !entity CanShootEnemy())
			{
				entity FlagEnemyUnattackable();
			}
			break;
		}
		case default:
		{
			if(entity.reacquire_state > 15)
			{
				entity.reacquire_state = 0;
				return 0;
			}
			break;
		}
	}
	if(IsVec(reacquirePos))
	{
		entity UsePosition(reacquirePos);
		return 1;
	}
	entity.reacquire_state++;
	return 0;
}

/*
	Name: function_e3a7ef95
	Namespace: zodcompanionbehavior
	Checksum: 0x34C7F7BF
	Offset: 0x2120
	Size: 0x7A3
	Parameters: 1
	Flags: Private
*/
function private function_e3a7ef95(entity)
{
	self endon("death");
	if(isdefined(level.companion_leader) && level.companion_leader.eligible_leader)
	{
		self.leader = level.companion_leader;
	}
	if(!isdefined(entity.var_57e708f6))
	{
		entity.var_57e708f6 = 0;
	}
	if(entity.bulletsInClip < entity.weapon.clipSize)
	{
		entity.bulletsInClip = entity.weapon.clipSize;
	}
	if(entity.reviving_a_player === 1)
	{
		return;
	}
	if(entity.time_expired === 1)
	{
		return;
	}
	if(entity.var_53ce2a4e === 1 || entity.teleporting === 1)
	{
		return;
	}
	if(entity.leader.teleporting === 1)
	{
		entity thread function_34117adf(entity.leader.teleport_location);
		return;
	}
	if(entity.var_c0e8df41 === 1)
	{
		return;
	}
	if(entity.leader.is_flung === 1)
	{
		entity thread take_flinger(entity.leader.var_fa1ecd39);
	}
	foreach(player in level.players)
	{
		if(player laststand::player_is_in_laststand() && entity.reviving_a_player === 0 && player.reviveTrigger.beingRevived !== 1)
		{
			time = GetTime();
			if(DistanceSquared(entity.origin, player.origin) <= 1024 * 1024 && time >= entity.var_57e708f6)
			{
				entity.reviving_a_player = 1;
				entity zod_companion_revive_player(player);
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
	if(isdefined(entity.pathGoalPos))
	{
		dist_check_start_point = entity.pathGoalPos;
	}
	else
	{
		dist_check_start_point = entity.origin;
	}
	if(isdefined(entity.enemy) && entity.enemy.archetype == "parasite")
	{
		height_difference = Abs(entity.origin[2] - entity.enemy.origin[2]);
		var_3b804002 = 1.5 * height_difference * 1.5 * height_difference;
		if(DistanceSquared(dist_check_start_point, entity.enemy.origin) < var_3b804002)
		{
			entity pick_new_movement_point();
		}
	}
	if(DistanceSquared(dist_check_start_point, entity.companion_anchor_point) > follow_radius_squared || DistanceSquared(dist_check_start_point, entity.companion_anchor_point) < 4096)
	{
		entity pick_new_movement_point();
	}
	if(GetTime() >= entity.next_move_time)
	{
		entity pick_new_movement_point();
	}
}

/*
	Name: function_13a0d6ef
	Namespace: zodcompanionbehavior
	Checksum: 0xF33E182
	Offset: 0x28D0
	Size: 0x1D5
	Parameters: 1
	Flags: Private
*/
function private function_13a0d6ef(entity)
{
	if(isdefined(entity.dontPushTime))
	{
		if(GetTime() < entity.dontPushTime)
		{
			return 1;
		}
	}
	var_5558b624 = 0;
	zombies = GetAITeamArray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie == entity)
		{
			continue;
		}
		dist_sq = DistanceSquared(entity.origin, zombie.origin);
		if(dist_sq < 14400)
		{
			if(isdefined(zombie.cant_move) && zombie.cant_move)
			{
				zombie thread function_d04291cf();
				var_5558b624 = 1;
			}
		}
	}
	if(var_5558b624)
	{
		entity PushActors(0);
		entity.dontPushTime = GetTime() + 2000;
		return 1;
	}
	entity PushActors(1);
	return 0;
}

/*
	Name: function_d04291cf
	Namespace: zodcompanionbehavior
	Checksum: 0xF5317EE6
	Offset: 0x2AB0
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private function_d04291cf()
{
	self endon("death");
	self PushActors(0);
	wait(2);
	self PushActors(1);
}

/*
	Name: function_f62bd05c
	Namespace: zodcompanionbehavior
	Checksum: 0x80851C4
	Offset: 0x2B00
	Size: 0x13D
	Parameters: 2
	Flags: Private
*/
function private function_f62bd05c(target_entity, max_distance)
{
	entity = self;
	target_location = target_entity.origin;
	if(DistanceSquared(entity.origin, target_location) > max_distance * max_distance)
	{
		return 0;
	}
	path = entity CalcApproximatePathToPosition(target_location);
	segmentLength = 0;
	for(index = 1; index < path.size; index++)
	{
		currentSegLength = Distance(path[index - 1], path[index]);
		if(currentSegLength + segmentLength > max_distance)
		{
			return 0;
		}
		segmentLength = segmentLength + currentSegLength;
	}
	return 1;
}

/*
	Name: function_34117adf
	Namespace: zodcompanionbehavior
	Checksum: 0x4509F5F1
	Offset: 0x2C48
	Size: 0x4F
	Parameters: 1
	Flags: Private
*/
function private function_34117adf(var_5935e1b9)
{
	self.var_53ce2a4e = 1;
	self SetGoal(var_5935e1b9, 1);
	self waittill("goal");
	wait(1);
	self.var_53ce2a4e = 0;
}

/*
	Name: take_flinger
	Namespace: zodcompanionbehavior
	Checksum: 0x9B0A229
	Offset: 0x2CA0
	Size: 0xAF
	Parameters: 1
	Flags: Private
*/
function private take_flinger(var_ee6ad78e)
{
	self.var_c0e8df41 = 1;
	var_c9277d64 = GetNodeArray("flinger_traversal", "script_noteworthy");
	var_292fba5b = ArrayGetClosest(var_ee6ad78e, var_c9277d64);
	self SetGoal(var_292fba5b.origin, 1);
	self waittill("goal");
	wait(1);
	self.var_c0e8df41 = 0;
}

/*
	Name: pick_new_movement_point
	Namespace: zodcompanionbehavior
	Checksum: 0x55FF1AE9
	Offset: 0x2D58
	Size: 0x1CB
	Parameters: 0
	Flags: Private
*/
function private pick_new_movement_point()
{
	queryResult = PositionQuery_Source_Navigation(self.companion_anchor_point, 96, 256, 256, 20, self);
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
	self SetGoal(self.companion_destination, 1);
	self.next_move_time = GetTime() + randomIntRange(20000, 30000);
}

/*
	Name: function_ab299a53
	Namespace: zodcompanionbehavior
	Checksum: 0x9511E5C1
	Offset: 0x2F30
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
	Name: function_f7d72d81
	Namespace: zodcompanionbehavior
	Checksum: 0xAF0D314
	Offset: 0x2FF0
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private function_f7d72d81(behaviorTreeEntity)
{
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(currentStance == "crouch")
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	}
}

/*
	Name: zod_companion_revive_player
	Namespace: zodcompanionbehavior
	Checksum: 0x22D4E3C4
	Offset: 0x3068
	Size: 0x3E3
	Parameters: 1
	Flags: None
*/
function zod_companion_revive_player(player)
{
	self endon("revive_terminated");
	self endon("end_game");
	if(!(isdefined(self.reviving_a_player) && self.reviving_a_player))
	{
		self.reviving_a_player = 1;
	}
	player.being_revived_by_robot = 0;
	self thread zod_companion_monitor_revive_attempt(player);
	self.ignoreall = 1;
	queryResult = PositionQuery_Source_Navigation(player.origin, 64, 96, 48, 18, self);
	if(queryResult.data.size)
	{
		point = queryResult.data[RandomInt(queryResult.data.size)];
		self.companion_destination = point.origin;
	}
	self SetGoal(self.companion_destination, 1);
	self waittill("goal");
	level.var_46040f3e = 1;
	player.reviveTrigger.beingRevived = 1;
	player.being_revived_by_robot = 1;
	vector = VectorNormalize(player.origin - self.origin);
	angles = VectorToAngles(vector);
	self teleport(self.origin, angles);
	self thread animation::Play("ai_robot_base_stn_exposed_revive", self, angles, 1.5);
	wait(0.67);
	player clientfield::set("being_robot_revived", 1);
	self waittill("robot_revive_complete");
	if(level.players.size == 1 && level flag::get("solo_game"))
	{
		self.var_57e708f6 = GetTime() + 10000;
	}
	else
	{
		self.var_57e708f6 = GetTime() + 5000;
	}
	player notify("stop_revive_trigger");
	if(isPlayer(player))
	{
		player AllowJump(1);
	}
	player.laststand = undefined;
	player thread zm_laststand::revive_success(self, 0);
	level.var_46040f3e = 0;
	players = GetPlayers();
	if(players.size == 1 && level flag::get("solo_game") && (isdefined(player.waiting_to_revive) && player.waiting_to_revive))
	{
		level.solo_game_free_player_quickrevive = 1;
		player thread zm_perks::give_perk("specialty_quickrevive", 0);
	}
	self zod_companion_revive_cleanup(player);
}

/*
	Name: zod_companion_monitor_revive_attempt
	Namespace: zodcompanionbehavior
	Checksum: 0xDE5AFC7A
	Offset: 0x3458
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function zod_companion_monitor_revive_attempt(player)
{
	self endon("revive_terminated");
	while(1)
	{
		if(isdefined(player.reviveTrigger) && player.reviveTrigger.beingRevived === 1 && player.being_revived_by_robot !== 1)
		{
			self zod_companion_revive_cleanup(player);
		}
		if(!(isdefined(player laststand::player_is_in_laststand()) && player laststand::player_is_in_laststand()))
		{
			self zod_companion_revive_cleanup(player);
		}
		wait(0.05);
	}
}

/*
	Name: zod_companion_revive_cleanup
	Namespace: zodcompanionbehavior
	Checksum: 0xEE5C154B
	Offset: 0x3538
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function zod_companion_revive_cleanup(player)
{
	self.ignoreall = 0;
	self.reviving_a_player = 0;
	if(isdefined(player))
	{
		if(player.being_revived_by_robot == 1)
		{
			player.being_revived_by_robot = 0;
		}
		player clientfield::set("being_robot_revived", 0);
	}
	self notify("revive_terminated");
}

/*
	Name: function_580c8f2d
	Namespace: zodcompanionbehavior
	Checksum: 0x9EB06BE3
	Offset: 0x35C8
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private function_580c8f2d(behaviorTreeEntity)
{
	behaviorTreeEntity.sprint_transition_happening = 0;
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_locomotion_speed") == "locomotion_speed_walk")
	{
		behaviorTreeEntity ai::set_behavior_attribute("sprint", 1);
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_locomotion_speed", "locomotion_speed_sprint");
	}
	else
	{
		behaviorTreeEntity ai::set_behavior_attribute("sprint", 0);
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_locomotion_speed", "locomotion_speed_walk");
	}
}

/*
	Name: function_9ff1641
	Namespace: zodcompanionbehavior
	Checksum: 0x587D468E
	Offset: 0x36B0
	Size: 0xDF
	Parameters: 1
	Flags: Private
*/
function private function_9ff1641(behaviorTreeEntity)
{
	var_ef42515b = 262144;
	var_1be8672c = 147456;
	dist = DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.companion_anchor_point);
	if(dist > var_ef42515b && blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_locomotion_speed") == "locomotion_speed_walk")
	{
		return 0;
	}
	if(dist < var_1be8672c && blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_locomotion_speed") == "locomotion_speed_sprint")
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_27f60e31
	Namespace: zodcompanionbehavior
	Checksum: 0x5188172F
	Offset: 0x3798
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private function_27f60e31(behaviorTreeEntity)
{
	if(behaviorTreeEntity.sprint_transition_happening === 1)
	{
		return 1;
	}
	return 0;
}

#namespace zodcompanionserverutils;

/*
	Name: _tryGibbingHead
	Namespace: zodcompanionserverutils
	Checksum: 0x22882D2E
	Offset: 0x37D0
	Size: 0x133
	Parameters: 4
	Flags: Private
*/
function private _tryGibbingHead(entity, damage, hitLoc, isExplosive)
{
	if(isExplosive && RandomFloatRange(0, 1) <= 0.5)
	{
		GibServerUtils::GibHead(entity);
	}
	else if(IsInArray(Array("head", "neck", "helmet"), hitLoc) && RandomFloatRange(0, 1) <= 1)
	{
		GibServerUtils::GibHead(entity);
	}
	else if(entity.health - damage <= 0 && RandomFloatRange(0, 1) <= 0.25)
	{
		GibServerUtils::GibHead(entity);
	}
}

/*
	Name: _tryGibbingLimb
	Namespace: zodcompanionserverutils
	Checksum: 0xD648E8BF
	Offset: 0x3910
	Size: 0x27B
	Parameters: 4
	Flags: Private
*/
function private _tryGibbingLimb(entity, damage, hitLoc, isExplosive)
{
	if(GibServerUtils::IsGibbed(entity, 32) || GibServerUtils::IsGibbed(entity, 16))
	{
		return;
	}
	if(isExplosive && RandomFloatRange(0, 1) <= 0.25)
	{
		if(entity.health - damage <= 0 && entity.allowdeath && math::cointoss())
		{
			GibServerUtils::GibRightArm(entity);
		}
		else
		{
			GibServerUtils::GibLeftArm(entity);
		}
	}
	else if(IsInArray(Array("left_hand", "left_arm_lower", "left_arm_upper"), hitLoc))
	{
		GibServerUtils::GibLeftArm(entity);
	}
	else if(entity.health - damage <= 0 && entity.allowdeath && IsInArray(Array("right_hand", "right_arm_lower", "right_arm_upper"), hitLoc))
	{
		GibServerUtils::GibRightArm(entity);
	}
	else if(entity.health - damage <= 0 && entity.allowdeath && RandomFloatRange(0, 1) <= 0.25)
	{
		if(math::cointoss())
		{
			GibServerUtils::GibLeftArm(entity);
		}
		else
		{
			GibServerUtils::GibRightArm(entity);
		}
	}
}

/*
	Name: _tryGibbingLegs
	Namespace: zodcompanionserverutils
	Checksum: 0xF06301E
	Offset: 0x3B98
	Size: 0x37B
	Parameters: 5
	Flags: Private
*/
function private _tryGibbingLegs(entity, damage, hitLoc, isExplosive, attacker)
{
	if(!isdefined(attacker))
	{
		attacker = entity;
	}
	canGibLegs = entity.health - damage <= 0 && entity.allowdeath;
	canGibLegs = canGibLegs || (entity.health - damage / entity.maxhealth <= 0.25 && DistanceSquared(entity.origin, attacker.origin) <= 360000 && entity.allowdeath);
	if(entity.health - damage <= 0 && entity.allowdeath && isExplosive && RandomFloatRange(0, 1) <= 0.5)
	{
		GibServerUtils::GibLegs(entity);
		entity StartRagdoll();
	}
	else if(canGibLegs && IsInArray(Array("left_leg_upper", "left_leg_lower", "left_foot"), hitLoc) && RandomFloatRange(0, 1) <= 1)
	{
		if(entity.health - damage > 0)
		{
			entity.becomeCrawler = 1;
		}
		GibServerUtils::GibLeftLeg(entity);
	}
	else if(canGibLegs && IsInArray(Array("right_leg_upper", "right_leg_lower", "right_foot"), hitLoc) && RandomFloatRange(0, 1) <= 1)
	{
		if(entity.health - damage > 0)
		{
			entity.becomeCrawler = 1;
		}
		GibServerUtils::GibRightLeg(entity);
	}
	else if(entity.health - damage <= 0 && entity.allowdeath && RandomFloatRange(0, 1) <= 0.25)
	{
		if(math::cointoss())
		{
			GibServerUtils::GibLeftLeg(entity);
		}
		else
		{
			GibServerUtils::GibRightLeg(entity);
		}
	}
}

/*
	Name: zodcompaniongibdamageoverride
	Namespace: zodcompanionserverutils
	Checksum: 0xB8358657
	Offset: 0x3F20
	Size: 0x18F
	Parameters: 12
	Flags: Private
*/
function private zodcompaniongibdamageoverride(inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(entity.health - damage / entity.maxhealth > 0.75)
	{
		return damage;
	}
	GibServerUtils::ToggleSpawnGibs(entity, 1);
	isExplosive = IsInArray(Array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTIVLE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
	_tryGibbingHead(entity, damage, hitLoc, isExplosive);
	_tryGibbingLimb(entity, damage, hitLoc, isExplosive);
	_tryGibbingLegs(entity, damage, hitLoc, isExplosive, attacker);
	return damage;
}

/*
	Name: zodcompaniondestructdeathoverride
	Namespace: zodcompanionserverutils
	Checksum: 0x75DCA24C
	Offset: 0x40B8
	Size: 0x22F
	Parameters: 12
	Flags: Private
*/
function private zodcompaniondestructdeathoverride(inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(entity.health - damage <= 0)
	{
		DestructServerUtils::ToggleSpawnGibs(entity, 1);
		pieceCount = DestructServerUtils::GetPieceCount(entity);
		possiblePieces = [];
		for(index = 1; index <= pieceCount; index++)
		{
			if(!DestructServerUtils::IsDestructed(entity, index) && RandomFloatRange(0, 1) <= 0.2)
			{
				possiblePieces[possiblePieces.size] = index;
			}
		}
		gibbedPieces = 0;
		for(index = 0; index < possiblePieces.size && possiblePieces.size > 1 && gibbedPieces < 2; index++)
		{
			randomPiece = randomIntRange(0, possiblePieces.size - 1);
			if(!DestructServerUtils::IsDestructed(entity, possiblePieces[randomPiece]))
			{
				DestructServerUtils::DestructPiece(entity, possiblePieces[randomPiece]);
				gibbedPieces++;
			}
		}
	}
	return damage;
}

/*
	Name: zodcompaniondamageoverride
	Namespace: zodcompanionserverutils
	Checksum: 0xFD7B7316
	Offset: 0x42F0
	Size: 0xCB
	Parameters: 12
	Flags: Private
*/
function private zodcompaniondamageoverride(inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(hitLoc == "helmet" || hitLoc == "head" || hitLoc == "neck")
	{
		damage = Int(damage * 0.5);
	}
	return damage;
}

/*
	Name: findClosestNavMeshPositionToEnemy
	Namespace: zodcompanionserverutils
	Checksum: 0xB8EF9671
	Offset: 0x43C8
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private findClosestNavMeshPositionToEnemy(enemy)
{
	enemyPositionOnNavMesh = undefined;
	for(toleranceLevel = 1; toleranceLevel <= 4; toleranceLevel++)
	{
		enemyPositionOnNavMesh = GetClosestPointOnNavMesh(enemy.origin, 200 * toleranceLevel);
		if(isdefined(enemyPositionOnNavMesh))
		{
			break;
		}
	}
	return enemyPositionOnNavMesh;
}

/*
	Name: zodcompanionsoldierspawnsetup
	Namespace: zodcompanionserverutils
	Checksum: 0xDC58D726
	Offset: 0x4458
	Size: 0x253
	Parameters: 0
	Flags: Private
*/
function private zodcompanionsoldierspawnsetup()
{
	entity = self;
	entity.combatmode = "cover";
	entity.fullHealth = entity.health;
	entity.controlLevel = 0;
	entity.steppedOutOfCover = 0;
	entity.startingWeapon = entity.weapon;
	entity.jukeDistance = 90;
	entity.jukeMaxDistance = 600;
	entity.entityRadius = 15;
	entity.base_accuracy = entity.accuracy;
	entity.highlyawareradius = 256;
	entity.treatAllCoversAsGeneric = 1;
	entity.onlyCrouchArrivals = 1;
	entity.nextPreemptiveJukeAds = RandomFloatRange(0.5, 0.95);
	entity.shouldPreemptiveJuke = math::cointoss();
	entity.reviving_a_player = 0;
	AiUtility::AddAIOverrideDamageCallback(entity, &DestructServerUtils::handleDamage);
	AiUtility::AddAIOverrideDamageCallback(entity, &zodcompaniondamageoverride);
	AiUtility::AddAIOverrideDamageCallback(entity, &zodcompaniongibdamageoverride);
	entity.companion_anchor_point = entity.origin;
	entity.next_move_time = GetTime();
	entity.allow_zombie_to_target_ai = 1;
	entity.ignoreme = 1;
	entity thread zodcompanionutility::function_cbe73e3d();
	entity thread zodcompanionutility::manage_companion();
}

#namespace zodcompanionutility;

/*
	Name: manage_companion
	Namespace: zodcompanionutility
	Checksum: 0xABE66E86
	Offset: 0x46B8
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function manage_companion()
{
	self endon("death");
	while(1)
	{
		if(!self.reviving_a_player)
		{
			if(!isdefined(self.leader) || !self.leader.eligible_leader)
			{
				self define_new_leader();
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_cbe73e3d
	Namespace: zodcompanionutility
	Checksum: 0x61D92885
	Offset: 0x4728
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_cbe73e3d()
{
	self.var_fb400bf7 = [];
	self.var_fb400bf7[0] = "double_points";
	self.var_fb400bf7[1] = "fire_sale";
	self.var_fb400bf7[2] = "insta_kill";
	self.var_fb400bf7[3] = "nuke";
	self.var_fb400bf7[4] = "full_ammo";
	self.var_fb400bf7[5] = "insta_kill_ug";
}

/*
	Name: define_new_leader
	Namespace: zodcompanionutility
	Checksum: 0x957CFC4B
	Offset: 0x47D0
	Size: 0x165
	Parameters: 0
	Flags: None
*/
function define_new_leader()
{
	if(isdefined(level.companion_leader) && level.companion_leader.eligible_leader)
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
	Namespace: zodcompanionutility
	Checksum: 0x148DC9BA
	Offset: 0x4940
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function get_potential_leaders(companion)
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

