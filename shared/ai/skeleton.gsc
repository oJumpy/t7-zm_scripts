#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace SkeletonBehavior;

/*
	Name: __init__sytem__
	Namespace: SkeletonBehavior
	Checksum: 0x96D46297
	Offset: 0x530
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("skeleton", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: SkeletonBehavior
	Checksum: 0x458A2A71
	Offset: 0x570
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	InitSkeletonBehaviorsAndASM();
	spawner::add_archetype_spawn_function("skeleton", &ArchetypeSkeletonBlackboardInit);
	spawner::add_archetype_spawn_function("skeleton", &skeletonSpawnSetup);
	if(ai::shouldRegisterClientFieldForArchetype("skeleton"))
	{
		clientfield::register("actor", "skeleton", 1, 1, "int");
	}
}

/*
	Name: skeletonSpawnSetup
	Namespace: SkeletonBehavior
	Checksum: 0xAFCDB836
	Offset: 0x628
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function skeletonSpawnSetup()
{
	self.zombie_move_speed = "walk";
	if(RandomInt(2) == 0)
	{
		self.zombie_arms_position = "up";
	}
	else
	{
		self.zombie_arms_position = "down";
	}
	self.missingLegs = 0;
	self SetAvoidanceMask("avoid none");
	self PushActors(1);
	clientfield::set("skeleton", 1);
}

/*
	Name: InitSkeletonBehaviorsAndASM
	Namespace: SkeletonBehavior
	Checksum: 0xCA7EE6FC
	Offset: 0x6F0
	Size: 0xF3
	Parameters: 0
	Flags: Private
*/
function private InitSkeletonBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("skeletonTargetService", &skeletonTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("skeletonShouldMelee", &skeletonShouldMeleeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("skeletonGibLegsCondition", &skeletonGibLegsCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isSkeletonWalking", &isSkeletonWalking);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("skeletonDeathAction", &skeletonDeathAction);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("contact", &skeletonNotetrackMeleeFire);
}

/*
	Name: ArchetypeSkeletonBlackboardInit
	Namespace: SkeletonBehavior
	Checksum: 0xE6F828D0
	Offset: 0x7F0
	Size: 0x24B
	Parameters: 0
	Flags: Private
*/
function private ArchetypeSkeletonBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_arms_position", "arms_up", &BB_GetArmsPosition);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", &BB_GetLocomotionSpeedType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_has_legs", "has_legs_yes", &BB_GetHasLegsStatus);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_which_board_pull", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_board_attack_spot", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeSkeletonOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeSkeletonOnAnimscriptedCallback
	Namespace: SkeletonBehavior
	Checksum: 0x8F26919B
	Offset: 0xA48
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeSkeletonOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeSkeletonBlackboardInit();
}

/*
	Name: BB_GetArmsPosition
	Namespace: SkeletonBehavior
	Checksum: 0x3EB6F2A6
	Offset: 0xA88
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function BB_GetArmsPosition()
{
	if(isdefined(self.skeleton_arms_position))
	{
		if(self.zombie_arms_position == "up")
		{
			return "arms_up";
		}
		return "arms_down";
	}
	return "arms_up";
}

/*
	Name: BB_GetLocomotionSpeedType
	Namespace: SkeletonBehavior
	Checksum: 0x7DB12759
	Offset: 0xAD0
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function BB_GetLocomotionSpeedType()
{
	if(isdefined(self.zombie_move_speed))
	{
		if(self.zombie_move_speed == "walk")
		{
			return "locomotion_speed_walk";
		}
		else if(self.zombie_move_speed == "run")
		{
			return "locomotion_speed_run";
		}
		else if(self.zombie_move_speed == "sprint")
		{
			return "locomotion_speed_sprint";
		}
		else if(self.zombie_move_speed == "super_sprint")
		{
			return "locomotion_speed_super_sprint";
		}
	}
	return "locomotion_speed_walk";
}

/*
	Name: BB_GetHasLegsStatus
	Namespace: SkeletonBehavior
	Checksum: 0x928F481D
	Offset: 0xB70
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function BB_GetHasLegsStatus()
{
	if(self.missingLegs)
	{
		return "has_legs_no";
	}
	return "has_legs_yes";
}

/*
	Name: isSkeletonWalking
	Namespace: SkeletonBehavior
	Checksum: 0xA13D6678
	Offset: 0xB98
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function isSkeletonWalking(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.zombie_move_speed))
	{
		return 1;
	}
	return behaviorTreeEntity.zombie_move_speed == "walk" && (!isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs) && behaviorTreeEntity.zombie_arms_position == "up";
}

/*
	Name: skeletonGibLegsCondition
	Namespace: SkeletonBehavior
	Checksum: 0x2F256BB4
	Offset: 0xC20
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function skeletonGibLegsCondition(behaviorTreeEntity)
{
	return GibServerUtils::IsGibbed(behaviorTreeEntity, 256) || GibServerUtils::IsGibbed(behaviorTreeEntity, 128);
}

/*
	Name: skeletonNotetrackMeleeFire
	Namespace: SkeletonBehavior
	Checksum: 0xE809DB28
	Offset: 0xC70
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function skeletonNotetrackMeleeFire(animationEntity)
{
	hitEnt = animationEntity melee();
	if(isdefined(hitEnt) && isdefined(animationEntity.aux_melee_damage) && self.team != hitEnt.team)
	{
		animationEntity [[animationEntity.aux_melee_damage]](hitEnt);
	}
}

/*
	Name: is_within_fov
	Namespace: SkeletonBehavior
	Checksum: 0xA5A69F62
	Offset: 0xCF8
	Size: 0xA1
	Parameters: 4
	Flags: None
*/
function is_within_fov(start_origin, start_angles, end_origin, fov)
{
	normal = VectorNormalize(end_origin - start_origin);
	FORWARD = AnglesToForward(start_angles);
	dot = VectorDot(FORWARD, normal);
	return dot >= fov;
}

/*
	Name: skeletonCanSeePlayer
	Namespace: SkeletonBehavior
	Checksum: 0x9D5917CF
	Offset: 0xDA8
	Size: 0x1ED
	Parameters: 1
	Flags: None
*/
function skeletonCanSeePlayer(player)
{
	self endon("death");
	if(!isdefined(self.players_visCache))
	{
		self.players_visCache = [];
	}
	entnum = player GetEntityNumber();
	if(!isdefined(self.players_visCache[entnum]))
	{
		self.players_visCache[entnum] = 0;
	}
	if(self.players_visCache[entnum] > GetTime())
	{
		return 1;
	}
	zombie_eye = self.origin + VectorScale((0, 0, 1), 40);
	player_pos = player.origin + VectorScale((0, 0, 1), 40);
	distanceSq = DistanceSquared(zombie_eye, player_pos);
	if(distanceSq < 4096)
	{
		self.players_visCache[entnum] = GetTime() + 3000;
		return 1;
	}
	else if(distanceSq > 1048576)
	{
		return 0;
	}
	if(is_within_fov(zombie_eye, self.angles, player_pos, cos(60)))
	{
		trace = GroundTrace(zombie_eye, player_pos, 0, undefined);
		if(trace["fraction"] < 1)
		{
			return 0;
		}
		else
		{
			self.players_visCache[entnum] = GetTime() + 3000;
			return 1;
		}
	}
	return 0;
}

/*
	Name: is_player_valid
	Namespace: SkeletonBehavior
	Checksum: 0x70D1EDCF
	Offset: 0xFA0
	Size: 0x16F
	Parameters: 3
	Flags: None
*/
function is_player_valid(player, checkIgnoreMeFlag, ignore_laststand_players)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isPlayer(player))
	{
		return 0;
	}
	if(isdefined(player.is_zombie) && player.is_zombie == 1)
	{
		return 0;
	}
	if(player.sessionstate == "spectator")
	{
		return 0;
	}
	if(player.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		return 0;
	}
	if(!(isdefined(ignore_laststand_players) && ignore_laststand_players))
	{
		if(player laststand::player_is_in_laststand())
		{
			return 0;
		}
	}
	if(isdefined(checkIgnoreMeFlag) && checkIgnoreMeFlag && player.ignoreme)
	{
		return 0;
	}
	if(isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](player);
	}
	return 1;
}

/*
	Name: get_closest_valid_player
	Namespace: SkeletonBehavior
	Checksum: 0x318714E4
	Offset: 0x1118
	Size: 0x253
	Parameters: 2
	Flags: None
*/
function get_closest_valid_player(origin, ignore_player)
{
	valid_player_found = 0;
	players = GetPlayers();
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			ArrayRemoveValue(players, ignore_player[i]);
		}
	}
	done = 0;
	while(players.size && !done)
	{
		done = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!is_player_valid(player, 1))
			{
				ArrayRemoveValue(players, player);
				done = 0;
				break;
			}
		}
	}
	if(players.size == 0)
	{
		return undefined;
	}
	while(!valid_player_found)
	{
		if(isdefined(self.closest_player_override))
		{
			player = [[self.closest_player_override]](origin, players);
		}
		else if(isdefined(level.closest_player_override))
		{
			player = [[level.closest_player_override]](origin, players);
		}
		else
		{
			player = ArrayGetClosest(origin, players);
		}
		if(!isdefined(player) || players.size == 0)
		{
			return undefined;
		}
		if(!is_player_valid(player, 1))
		{
			ArrayRemoveValue(players, player);
			if(players.size == 0)
			{
				return undefined;
			}
			continue;
		}
		return player;
	}
}

/*
	Name: skeletonSetGoal
	Namespace: SkeletonBehavior
	Checksum: 0x320D3F74
	Offset: 0x1378
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function skeletonSetGoal(goal)
{
	if(isdefined(self.setGoalOverrideCB))
	{
		return [[self.setGoalOverrideCB]](goal);
	}
	else
	{
		self SetGoal(goal);
	}
}

/*
	Name: skeletonTargetService
	Namespace: SkeletonBehavior
	Checksum: 0x2B5A36DD
	Offset: 0x13D0
	Size: 0x3AF
	Parameters: 1
	Flags: None
*/
function skeletonTargetService(behaviorTreeEntity)
{
	self endon("death");
	if(isdefined(behaviorTreeEntity.ignoreall) && behaviorTreeEntity.ignoreall)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.enemy) && behaviorTreeEntity.enemy.team == behaviorTreeEntity.team)
	{
		behaviorTreeEntity clearentitytarget();
	}
	if(behaviorTreeEntity.team == "allies")
	{
		if(isdefined(behaviorTreeEntity.favoriteenemy))
		{
			behaviorTreeEntity skeletonSetGoal(behaviorTreeEntity.favoriteenemy.origin);
			return 1;
		}
		if(isdefined(behaviorTreeEntity.enemy))
		{
			behaviorTreeEntity skeletonSetGoal(behaviorTreeEntity.enemy.origin);
			return 1;
		}
		target = getClosestToMe(GetAITeamArray("axis"));
		if(isdefined(target))
		{
			behaviorTreeEntity skeletonSetGoal(target.origin);
			return 1;
		}
		else
		{
			behaviorTreeEntity skeletonSetGoal(behaviorTreeEntity.origin);
			return 0;
		}
	}
	else
	{
		player = get_closest_valid_player(behaviorTreeEntity.origin, behaviorTreeEntity.ignore_player);
		if(!isdefined(player))
		{
			if(isdefined(behaviorTreeEntity.ignore_player))
			{
				if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
				{
					return;
				}
				behaviorTreeEntity.ignore_player = [];
			}
			behaviorTreeEntity skeletonSetGoal(behaviorTreeEntity.origin);
			return 0;
		}
		else if(isdefined(player.last_valid_position))
		{
			cansee = self skeletonCanSeePlayer(player);
			if(cansee)
			{
				behaviorTreeEntity skeletonSetGoal(player.last_valid_position);
				return 1;
			}
			else
			{
				influencePos = undefined;
				if(isdefined(influencePos))
				{
					if(DistanceSquared(influencePos, behaviorTreeEntity.origin) > 1024)
					{
						behaviorTreeEntity skeletonSetGoal(influencePos);
						return 1;
					}
					behaviorTreeEntity clearPath();
					return 0;
				}
				else
				{
					behaviorTreeEntity clearPath();
					return 0;
				}
			}
			return 1;
		}
		else
		{
			behaviorTreeEntity skeletonSetGoal(behaviorTreeEntity.origin);
			return 0;
		}
	}
}

/*
	Name: isValidEnemy
	Namespace: SkeletonBehavior
	Checksum: 0xCB115589
	Offset: 0x1788
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function isValidEnemy(enemy)
{
	if(!isdefined(enemy))
	{
		return 0;
	}
	return 1;
}

/*
	Name: GetYaw
	Namespace: SkeletonBehavior
	Checksum: 0x514FEE29
	Offset: 0x17B0
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function GetYaw(org)
{
	angles = VectorToAngles(org - self.origin);
	return angles[1];
}

/*
	Name: getYawToEnemy
	Namespace: SkeletonBehavior
	Checksum: 0x7643419D
	Offset: 0x1800
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function getYawToEnemy()
{
	pos = undefined;
	if(isValidEnemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		FORWARD = AnglesToForward(self.angles);
		FORWARD = VectorScale(FORWARD, 150);
		pos = self.origin + FORWARD;
	}
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: skeletonShouldMeleeCondition
	Namespace: SkeletonBehavior
	Checksum: 0x6EC76839
	Offset: 0x18F0
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function skeletonShouldMeleeCondition(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.marked_for_death))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.stunned) && behaviorTreeEntity.stunned)
	{
		return 0;
	}
	yaw = Abs(getYawToEnemy());
	if(yaw > 45)
	{
		return 0;
	}
	if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) < 4096)
	{
		return 1;
	}
	return 0;
}

/*
	Name: skeletonDeathAction
	Namespace: SkeletonBehavior
	Checksum: 0xE713A185
	Offset: 0x19E8
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function skeletonDeathAction(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.deathFunction))
	{
		behaviorTreeEntity [[behaviorTreeEntity.deathFunction]]();
	}
}

/*
	Name: getClosestTo
	Namespace: SkeletonBehavior
	Checksum: 0x1C79AF1C
	Offset: 0x1A28
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function getClosestTo(origin, entArray)
{
	if(!isdefined(entArray))
	{
		return;
	}
	if(entArray.size == 0)
	{
		return;
	}
	return ArrayGetClosest(origin, entArray);
}

/*
	Name: getClosestToMe
	Namespace: SkeletonBehavior
	Checksum: 0x33AE1253
	Offset: 0x1A80
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function getClosestToMe(entArray)
{
	return getClosestTo(self.origin, entArray);
}

