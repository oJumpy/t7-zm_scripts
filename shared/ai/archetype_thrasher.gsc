#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_thrasher_interface;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace ThrasherBehavior;

/*
	Name: __init__sytem__
	Namespace: ThrasherBehavior
	Checksum: 0x29456890
	Offset: 0x9A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("thrasher", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ThrasherBehavior
	Checksum: 0xE5A1DC12
	Offset: 0x9E0
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_info("visionset", "zm_isl_thrasher_stomach_visionset", 9000, 30, 16, 1, &visionset_mgr::ramp_in_thread_per_player, 0);
	InitThrasherBehaviorsAndASM();
	spawner::add_archetype_spawn_function("thrasher", &ArchetypeThrasherBlackboardInit);
	spawner::add_archetype_spawn_function("thrasher", &thrasherSpawnSetup);
	if(ai::shouldRegisterClientFieldForArchetype("thrasher"))
	{
		clientfield::register("actor", "thrasher_spore_state", 5000, 3, "int");
		clientfield::register("actor", "thrasher_berserk_state", 5000, 1, "int");
		clientfield::register("actor", "thrasher_player_hide", 8000, 4, "int");
		clientfield::register("toplayer", "sndPlayerConsumed", 10000, 1, "int");
		foreach(spore in Array(1, 2, 4))
		{
			clientfield::register("actor", "thrasher_spore_impact" + spore, 8000, 1, "counter");
		}
	}
	ThrasherInterface::RegisterThrasherInterfaceAttributes();
}

/*
	Name: InitThrasherBehaviorsAndASM
	Namespace: ThrasherBehavior
	Checksum: 0xD3F9FA18
	Offset: 0xC38
	Size: 0x373
	Parameters: 0
	Flags: Private
*/
function private InitThrasherBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherRageService", &thrasherRageService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherTargetService", &thrasherTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherKnockdownService", &thrasherKnockdownService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherAttackableObjectService", &thrasherAttackableObjectService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldBeStunned", &thrasherShouldBeStunned);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldMelee", &thrasherShouldMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldShowPain", &thrasherShouldShowPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldTurnBerserk", &thrasherShouldTurnBerserk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldTeleport", &thrasherShouldTeleport);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldConsumePlayer", &thrasherShouldConsumePlayer);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherShouldConsumeZombie", &thrasherShouldConsumeZombie);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherConsumePlayer", &thrasherConsumePlayer);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherConsumeZombie", &thrasherConsumeZombie);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherPlayedBerserkIntro", &ThrasherServerUtils::thrasherPlayedBerserkIntro);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherTeleport", &ThrasherServerUtils::thrasherTeleport);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherTeleportOut", &ThrasherServerUtils::thrasherTeleportOut);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherDeath", &thrasherDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherStartTraverse", &ThrasherServerUtils::thrasherStartTraverse);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherTerminateTraverse", &ThrasherServerUtils::thrasherTerminateTraverse);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherStunInitialize", &ThrasherServerUtils::thrasherStunInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("thrasherStunUpdate", &ThrasherServerUtils::thrasherStunUpdate);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("thrasher_melee", &thrasherNotetrackMelee);
}

/*
	Name: ArchetypeThrasherBlackboardInit
	Namespace: ThrasherBehavior
	Checksum: 0x678177C
	Offset: 0xFB8
	Size: 0x1EB
	Parameters: 0
	Flags: Private
*/
function private ArchetypeThrasherBlackboardInit()
{
	entity = self;
	blackboard::CreateBlackBoardForEntity(entity);
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(entity);
	thrasher_speed = "locomotion_speed_walk";
	if(entity.thrasherHasTurnedBerserk === 1)
	{
		thrasher_speed = "locomotion_speed_run";
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", thrasher_speed, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_should_turn", "should_not_turn", &BB_GetShouldTurn);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_zombie_damageweapon_type", "regular", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	entity.___ArchetypeOnAnimscriptedCallback = &ArchetypeThrasherOnAnimscriptedCallback;
	/#
		entity function_89398c57();
	#/
}

/*
	Name: ArchetypeThrasherOnAnimscriptedCallback
	Namespace: ThrasherBehavior
	Checksum: 0x87E960E4
	Offset: 0x11B0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeThrasherOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeThrasherBlackboardInit();
}

/*
	Name: thrasherSpawnSetup
	Namespace: ThrasherBehavior
	Checksum: 0xF825EA8
	Offset: 0x11F0
	Size: 0x163
	Parameters: 0
	Flags: Private
*/
function private thrasherSpawnSetup()
{
	entity = self;
	entity.health = 1000;
	entity.maxhealth = entity.health;
	entity.thrasherConsumedPlayer = 0;
	entity.thrasherIsBerserk = 0;
	entity.thrasherHasTurnedBerserk = 0;
	entity.thrasherHeadHealth = 10;
	entity.thrasherLastConsume = GetTime();
	entity.thrasherConsumeCooldown = 3000;
	entity.thrasherConsumeCount = 0;
	entity.thrasherConsumeMax = 2;
	entity.thrasherLastTeleportTime = GetTime();
	entity.thrasherStunHealth = 3000;
	entity.thrasherRageCount = 0;
	entity.thrasherRageLevel = 1;
	thrasherInitSpores();
	ThrasherServerUtils::thrasherHideSpikes(entity, 1);
	AiUtility::AddAIOverrideDamageCallback(entity, &ThrasherServerUtils::thrasherDamageCallback);
}

/*
	Name: BB_GetShouldTurn
	Namespace: ThrasherBehavior
	Checksum: 0xE46124EF
	Offset: 0x1360
	Size: 0x49
	Parameters: 0
	Flags: Private
*/
function private BB_GetShouldTurn()
{
	entity = self;
	if(isdefined(entity.should_turn) && entity.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: thrasherInitSpores
	Namespace: ThrasherBehavior
	Checksum: 0x8127BA64
	Offset: 0x13B8
	Size: 0x217
	Parameters: 0
	Flags: Private
*/
function private thrasherInitSpores()
{
	entity = self;
	/#
		Assert(Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported").size == Array(1, 2, 4).size);
	#/
	thrasherSpores = Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg");
	thrasherSporeDamageDists = Array(12, 18, 12);
	thrasherClientfields = Array(1, 2, 4);
	entity.thrasherSpores = [];
	for(index = 0; index < Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size; index++)
	{
		sporeStruct = spawnstruct();
		sporeStruct.dist = thrasherSporeDamageDists[index];
		sporeStruct.health = 100;
		sporeStruct.maxhealth = sporeStruct.health;
		sporeStruct.State = "state_healthly";
		sporeStruct.tag = thrasherSpores[index];
		sporeStruct.clientfield = thrasherClientfields[index];
		entity.thrasherSpores[index] = sporeStruct;
	}
}

/*
	Name: thrasherNotetrackMelee
	Namespace: ThrasherBehavior
	Checksum: 0xE71FAD1
	Offset: 0x15D8
	Size: 0xD3
	Parameters: 1
	Flags: Private
*/
function private thrasherNotetrackMelee(entity)
{
	if(isdefined(entity.thrasher_melee_knockdown_function))
	{
		entity thread [[entity.thrasher_melee_knockdown_function]]();
	}
	hitEntity = entity melee();
	if(isdefined(hitEntity) && isdefined(entity.thrasherMeleeHitCallback))
	{
		entity thread [[entity.thrasherMeleeHitCallback]](hitEntity);
	}
	if(AiUtility::shouldAttackObject(entity))
	{
		if(isdefined(level.attackableCallback))
		{
			entity.attackable [[level.attackableCallback]](entity);
		}
	}
}

/*
	Name: thrasherGetClosestLaststandPlayer
	Namespace: ThrasherBehavior
	Checksum: 0xF48C2413
	Offset: 0x16B8
	Size: 0x211
	Parameters: 1
	Flags: Private
*/
function private thrasherGetClosestLaststandPlayer(entity)
{
	if(entity.thrasherConsumedPlayer)
	{
		return;
	}
	maxConsumeDistanceSq = 2400 * 2400;
	targets = GetPlayers();
	if(targets.size == 1)
	{
		return;
	}
	laststandTargets = [];
	foreach(target in targets)
	{
		if(!isdefined(target.lastStandStartTime) || target.lastStandStartTime + 5000 > GetTime())
		{
			continue;
		}
		if(isdefined(target.thrasherFreedTime) && target.thrasherFreedTime + 10000 > GetTime())
		{
			continue;
		}
		if(target laststand::player_is_in_laststand() && (!isdefined(target.thrasherConsumed) && target.thrasherConsumed) && DistanceSquared(target.origin, entity.origin) <= maxConsumeDistanceSq)
		{
			laststandTargets[laststandTargets.size] = target;
		}
	}
	if(laststandTargets.size > 0)
	{
		sortedPotentialTargets = ArraySortClosest(laststandTargets, entity.origin);
		return sortedPotentialTargets[0];
	}
}

/*
	Name: thrasherRageService
	Namespace: ThrasherBehavior
	Checksum: 0xDF486965
	Offset: 0x18D8
	Size: 0x73
	Parameters: 1
	Flags: Private
*/
function private thrasherRageService(entity)
{
	entity.thrasherRageCount = entity.thrasherRageCount + entity.thrasherRageLevel * 1 + 1;
	if(entity.thrasherRageCount >= 200)
	{
		ThrasherServerUtils::thrasherGoBerserk(entity);
	}
}

/*
	Name: thrasherTargetService
	Namespace: ThrasherBehavior
	Checksum: 0x1302C530
	Offset: 0x1958
	Size: 0x427
	Parameters: 1
	Flags: Private
*/
function private thrasherTargetService(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(entity ai::get_behavior_attribute("move_mode") == "friendly")
	{
		if(isdefined(entity.thrasherMoveModeFriendlyCallback))
		{
			entity [[entity.thrasherMoveModeFriendlyCallback]]();
		}
		return 1;
	}
	laststandPlayer = thrasherGetClosestLaststandPlayer(entity);
	if(isdefined(laststandPlayer))
	{
		entity.favoriteenemy = laststandPlayer;
		entity SetGoal(entity.favoriteenemy.origin);
		return 1;
	}
	entity.ignore_player = [];
	players = GetPlayers();
	foreach(player in players)
	{
		if(player IsNoTarget() || player.ignoreme || player laststand::player_is_in_laststand() || (isdefined(player.thrasherConsumed) && player.thrasherConsumed))
		{
			entity.ignore_player[entity.ignore_player.size] = player;
		}
	}
	player = undefined;
	if(isdefined(entity.thrasherClosestValidPlayer))
	{
		player = [[entity.thrasherClosestValidPlayer]](entity.origin, entity.ignore_player);
	}
	else
	{
		player = zombie_utility::get_closest_valid_player(entity.origin, entity.ignore_player);
	}
	entity.favoriteenemy = player;
	if(!isdefined(player) || player IsNoTarget())
	{
		if(isdefined(entity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			entity.ignore_player = [];
		}
		entity SetGoal(entity.origin);
		return 0;
	}
	else if(isdefined(entity.attackable))
	{
		if(isdefined(entity.attackable_slot))
		{
			entity SetGoal(entity.attackable_slot.origin, 1);
		}
	}
	else
	{
		targetPos = GetClosestPointOnNavMesh(player.origin, 128, 30);
		if(isdefined(targetPos))
		{
			entity SetGoal(targetPos);
			return 1;
		}
		else
		{
			entity SetGoal(entity.origin);
			return 0;
		}
	}
}

/*
	Name: thrasherAttackableObjectService
	Namespace: ThrasherBehavior
	Checksum: 0x4CC09F9
	Offset: 0x1D88
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private thrasherAttackableObjectService(entity)
{
	if(isdefined(entity.thrasherAttackableObjectCallback))
	{
		return [[entity.thrasherAttackableObjectCallback]](entity);
	}
	return 0;
}

/*
	Name: thrasherKnockdownService
	Namespace: ThrasherBehavior
	Checksum: 0xF8674B3F
	Offset: 0x1DD0
	Size: 0x1B9
	Parameters: 1
	Flags: Private
*/
function private thrasherKnockdownService(entity)
{
	velocity = entity GetVelocity();
	predict_time = 0.3;
	predicted_pos = entity.origin + velocity * predict_time;
	move_dist_sq = DistanceSquared(predicted_pos, entity.origin);
	speed = move_dist_sq / predict_time;
	if(speed >= 10)
	{
		a_zombies = GetAIArchetypeArray("zombie");
		a_filtered_zombies = Array::filter(a_zombies, 0, &thrasherZombieEligibleForKnockdown, entity, predicted_pos);
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				ThrasherServerUtils::thrasherKnockdownZombie(entity, zombie);
			}
		}
	}
}

/*
	Name: thrasherZombieEligibleForKnockdown
	Namespace: ThrasherBehavior
	Checksum: 0x1FF6C4D4
	Offset: 0x1F98
	Size: 0x1AB
	Parameters: 3
	Flags: Private
*/
function private thrasherZombieEligibleForKnockdown(zombie, thrasher, predicted_pos)
{
	if(zombie.KNOCKDOWN === 1)
	{
		return 0;
	}
	knockdown_dist_sq = 2304;
	dist_sq = DistanceSquared(predicted_pos, zombie.origin);
	if(dist_sq > knockdown_dist_sq)
	{
		return 0;
	}
	origin = thrasher.origin;
	facing_vec = AnglesToForward(thrasher.angles);
	enemy_vec = zombie.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: thrasherShouldMelee
	Namespace: ThrasherBehavior
	Checksum: 0x4693D96A
	Offset: 0x2150
	Size: 0xED
	Parameters: 1
	Flags: None
*/
function thrasherShouldMelee(entity)
{
	if(!isdefined(entity.favoriteenemy))
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.favoriteenemy.origin) > 9216)
	{
		return 0;
	}
	if(entity.favoriteenemy IsNoTarget())
	{
		return 0;
	}
	yaw = Abs(zombie_utility::getYawToEnemy());
	if(yaw > 60)
	{
		return 0;
	}
	if(entity.favoriteenemy laststand::player_is_in_laststand())
	{
		return 0;
	}
	return 1;
}

/*
	Name: thrasherShouldShowPain
	Namespace: ThrasherBehavior
	Checksum: 0x231B7965
	Offset: 0x2248
	Size: 0xD
	Parameters: 1
	Flags: Private
*/
function private thrasherShouldShowPain(entity)
{
	return 0;
}

/*
	Name: thrasherShouldTurnBerserk
	Namespace: ThrasherBehavior
	Checksum: 0xC3065116
	Offset: 0x2260
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private thrasherShouldTurnBerserk(entity)
{
	return entity.thrasherIsBerserk && !entity.thrasherHasTurnedBerserk;
}

/*
	Name: thrasherShouldTeleport
	Namespace: ThrasherBehavior
	Checksum: 0xFC1B23E8
	Offset: 0x2298
	Size: 0xEB
	Parameters: 1
	Flags: Private
*/
function private thrasherShouldTeleport(entity)
{
	if(!isdefined(entity.favoriteenemy))
	{
		return 0;
	}
	if(entity.thrasherLastTeleportTime + 10000 > GetTime())
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.favoriteenemy.origin) >= 1440000)
	{
		if(isdefined(entity.thrasherShouldTeleportCallback))
		{
			return [[entity.thrasherShouldTeleportCallback]](entity.origin) && [[entity.thrasherShouldTeleportCallback]](entity.favoriteenemy.origin);
		}
		else
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: thrasherShouldConsumePlayer
	Namespace: ThrasherBehavior
	Checksum: 0xBCD705A9
	Offset: 0x2390
	Size: 0x123
	Parameters: 1
	Flags: Private
*/
function private thrasherShouldConsumePlayer(entity)
{
	if(!isdefined(entity.favoriteenemy))
	{
		return 0;
	}
	targets = GetPlayers();
	if(targets.size == 1)
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.favoriteenemy.origin) > 2304)
	{
		return 0;
	}
	if(!entity.favoriteenemy laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(isdefined(entity.favoriteenemy.thrasherConsumed) && entity.favoriteenemy.thrasherConsumed)
	{
		return 0;
	}
	if(isdefined(entity.thrasherCanConsumePlayerCallback) && !entity [[entity.thrasherCanConsumePlayerCallback]](entity))
	{
		return 0;
	}
	return 1;
}

/*
	Name: thrasherShouldConsumeZombie
	Namespace: ThrasherBehavior
	Checksum: 0xD09001F7
	Offset: 0x24C0
	Size: 0x129
	Parameters: 1
	Flags: Private
*/
function private thrasherShouldConsumeZombie(entity)
{
	if(entity.thrasherConsumeCount >= entity.thrasherConsumeMax)
	{
		return 0;
	}
	if(entity.thrasherLastConsume + entity.thrasherConsumeCooldown >= GetTime())
	{
		return 0;
	}
	hasPoppedPustule = 0;
	for(index = 0; index < Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size; index++)
	{
		sporeStruct = entity.thrasherSpores[index];
		if(sporeStruct.health <= 0)
		{
			hasPoppedPustule = 1;
			break;
		}
	}
	if(hasPoppedPustule)
	{
		if(isdefined(entity.thrasherCanConsumeCallback))
		{
			return [[entity.thrasherCanConsumeCallback]](entity);
		}
	}
	return 0;
}

/*
	Name: thrasherConsumePlayer
	Namespace: ThrasherBehavior
	Checksum: 0x11DC2B78
	Offset: 0x25F8
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private thrasherConsumePlayer(entity)
{
	if(isPlayer(entity.favoriteenemy))
	{
		entity thread ThrasherServerUtils::thrasherConsumePlayerUtil(entity, entity.favoriteenemy);
	}
}

/*
	Name: thrasherDeath
	Namespace: ThrasherBehavior
	Checksum: 0x1720B8F9
	Offset: 0x2658
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private thrasherDeath(entity)
{
	GibServerUtils::Annihilate(entity);
}

/*
	Name: thrasherConsumeZombie
	Namespace: ThrasherBehavior
	Checksum: 0xB2B27CF3
	Offset: 0x2688
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private thrasherConsumeZombie(entity)
{
	if(isdefined(entity.thrasherConsumeZombieCallback))
	{
		if([[entity.thrasherConsumeZombieCallback]](entity))
		{
			entity.thrasherConsumeCount++;
			entity.thrasherLastConsume = GetTime();
		}
	}
}

/*
	Name: thrasherShouldBeStunned
	Namespace: ThrasherBehavior
	Checksum: 0xE89546DC
	Offset: 0x26E8
	Size: 0x29
	Parameters: 1
	Flags: Private
*/
function private thrasherShouldBeStunned(entity)
{
	return entity ai::get_behavior_attribute("stunned");
}

#namespace ThrasherServerUtils;

/*
	Name: thrasherKnockdownZombie
	Namespace: ThrasherServerUtils
	Checksum: 0x99D29B4D
	Offset: 0x2720
	Size: 0x2B3
	Parameters: 2
	Flags: None
*/
function thrasherKnockdownZombie(entity, zombie)
{
	zombie.KNOCKDOWN = 1;
	zombie.knockdown_type = "knockdown_shoved";
	zombie_to_thrasher = entity.origin - zombie.origin;
	zombie_to_thrasher_2d = VectorNormalize((zombie_to_thrasher[0], zombie_to_thrasher[1], 0));
	zombie_forward = AnglesToForward(zombie.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(zombie.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(zombie_to_thrasher_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		zombie.knockdown_direction = "front";
		zombie.getup_direction = "getup_back";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(zombie_to_thrasher_2d, zombie_right_2d);
		if(dot > 0)
		{
			zombie.knockdown_direction = "right";
			if(math::cointoss())
			{
				zombie.getup_direction = "getup_back";
			}
			else
			{
				zombie.getup_direction = "getup_belly";
			}
		}
		else
		{
			zombie.knockdown_direction = "left";
			zombie.getup_direction = "getup_belly";
		}
	}
	else
	{
		zombie.knockdown_direction = "back";
		zombie.getup_direction = "getup_belly";
	}
}

/*
	Name: thrasherGoBerserk
	Namespace: ThrasherServerUtils
	Checksum: 0x6826BA18
	Offset: 0x29E0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function thrasherGoBerserk(entity)
{
	if(!entity.thrasherIsBerserk)
	{
		entity thread thrasherInvulnerability(2.5);
		entity.thrasherIsBerserk = 1;
		entity.health = entity.health + 1500;
		entity clientfield::set("thrasher_berserk_state", 1);
		thrasherHideSpikes(entity, 0);
	}
}

/*
	Name: thrasherPlayedBerserkIntro
	Namespace: ThrasherServerUtils
	Checksum: 0x1FB02543
	Offset: 0x2A98
	Size: 0xC3
	Parameters: 1
	Flags: Private
*/
function private thrasherPlayedBerserkIntro(entity)
{
	entity.thrasherHasTurnedBerserk = 1;
	meleeWeapon = GetWeapon("thrasher_melee_enraged");
	entity.meleeWeapon = GetWeapon("thrasher_melee_enraged");
	entity ai::set_behavior_attribute("stunned", 0);
	entity.thrasherStunHealth = 3000;
	blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run");
}

/*
	Name: thrasherDamageCallback
	Namespace: ThrasherServerUtils
	Checksum: 0x2A04F810
	Offset: 0x2B68
	Size: 0x2B3
	Parameters: 12
	Flags: None
*/
function thrasherDamageCallback(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(hitLoc == "head" && !GibServerUtils::IsGibbed(entity, 8))
	{
		entity.thrasherRageCount = entity.thrasherRageCount + 200;
		entity.thrasherHeadHealth = entity.thrasherHeadHealth - damage;
		if(entity.thrasherHeadHealth <= 0)
		{
			if(isdefined(attacker))
			{
				attacker notify("destroyed_thrasher_head");
			}
			GibServerUtils::GibHead(entity);
			thrasherHidePoppedPustules(entity);
		}
	}
	else
	{
		entity.thrasherRageCount = entity.thrasherRageCount + 10;
		entity.thrasherStunHealth = entity.thrasherStunHealth - damage;
		if(entity.thrasherStunHealth <= 0)
		{
			entity ai::set_behavior_attribute("stunned", 1);
			if(isdefined(attacker))
			{
				attacker notify("player_stunned_thrasher");
			}
		}
	}
	damage = thrasherSporeDamageCallback(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
	if(entity.thrasherRageCount >= 200)
	{
		thrasherGoBerserk(entity);
		if(isdefined(attacker))
		{
			attacker notify("player_enraged_thrasher");
		}
	}
	if(isdefined(entity.b_thrasher_temp_invulnerable) && entity.b_thrasher_temp_invulnerable)
	{
		damage = 1;
	}
	damage = Int(damage);
	return damage;
}

/*
	Name: thrasherInvulnerability
	Namespace: ThrasherServerUtils
	Checksum: 0x87EC0DE0
	Offset: 0x2E28
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private thrasherInvulnerability(n_time)
{
	entity = self;
	entity endon("death");
	entity notify("end_invulnerability");
	entity.b_thrasher_temp_invulnerable = 1;
	entity util::waittill_notify_or_timeout("end_invulnerability", n_time);
	entity.b_thrasher_temp_invulnerable = 0;
}

/*
	Name: thrasherSporeDamageCallback
	Namespace: ThrasherServerUtils
	Checksum: 0x5D463412
	Offset: 0x2EB0
	Size: 0x403
	Parameters: 12
	Flags: None
*/
function thrasherSporeDamageCallback(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	/#
		Assert(isdefined(entity.thrasherSpores));
	#/
	if(!isdefined(point))
	{
		return damage;
	}
	healthySpores = 0;
	for(index = 0; index < Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size; index++)
	{
		sporeStruct = entity.thrasherSpores[index];
		/#
			Assert(isdefined(sporeStruct));
		#/
		if(sporeStruct.health < 0)
		{
			continue;
		}
		tagOrigin = entity GetTagOrigin(sporeStruct.tag);
		if(isdefined(tagOrigin) && DistanceSquared(tagOrigin, point) < sporeStruct.dist * sporeStruct.dist)
		{
			entity.thrasherRageCount = entity.thrasherRageCount + 10;
			sporeStruct.health = sporeStruct.health - damage;
			entity clientfield::increment("thrasher_spore_impact" + sporeStruct.clientfield);
			if(sporeStruct.health <= 0)
			{
				entity HidePart(sporeStruct.tag);
				sporeStruct.State = "state_destroyed";
				destroyedSpores = entity clientfield::get("thrasher_spore_state");
				destroyedSpores = destroyedSpores | sporeStruct.clientfield;
				entity clientfield::set("thrasher_spore_state", destroyedSpores);
				if(isdefined(entity.thrasherPustulePopCallback))
				{
					entity thread [[entity.thrasherPustulePopCallback]](tagOrigin, weapon, attacker);
				}
				entity ai::set_behavior_attribute("stunned", 1);
				damage = entity.maxhealth / Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size;
			}
			/#
				RecordSphere(tagOrigin, sporeStruct.dist, (1, 1, 0), "Dev Block strings are not supported", entity);
			#/
		}
		if(sporeStruct.health > 0)
		{
			healthySpores++;
		}
	}
	if(healthySpores == 0)
	{
		damage = entity.maxhealth;
	}
	return damage;
}

/*
	Name: thrasherTeleportOut
	Namespace: ThrasherServerUtils
	Checksum: 0x2935C7B9
	Offset: 0x32C0
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private thrasherTeleportOut(entity)
{
	if(isdefined(entity.thrasherTeleportCallback))
	{
		entity thread [[entity.thrasherTeleportCallback]](entity);
	}
}

/*
	Name: thrasherStartTraverse
	Namespace: ThrasherServerUtils
	Checksum: 0xC024D678
	Offset: 0x3308
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function thrasherStartTraverse(entity)
{
	AiUtility::traverseSetup(entity);
	if(isdefined(entity.thrasherStartTraverseCallback))
	{
		entity [[entity.thrasherStartTraverseCallback]](entity);
	}
}

/*
	Name: thrasherTerminateTraverse
	Namespace: ThrasherServerUtils
	Checksum: 0xF8B7153
	Offset: 0x3368
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function thrasherTerminateTraverse(entity)
{
	if(isdefined(entity.thrasherTerminateTraverseCallback))
	{
		entity [[entity.thrasherTerminateTraverseCallback]](entity);
	}
}

/*
	Name: thrasherTeleport
	Namespace: ThrasherServerUtils
	Checksum: 0x5043328D
	Offset: 0x33B0
	Size: 0x32B
	Parameters: 1
	Flags: None
*/
function thrasherTeleport(entity)
{
	if(!isdefined(entity.favoriteenemy))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	points = util::PositionQuery_PointArray(entity.favoriteenemy.origin, 128, 256, 32, 64, entity);
	filteredPoints = [];
	thrashers = GetAIArchetypeArray("thrasher");
	overlapSqr = 240 * 240;
	foreach(point in points)
	{
		valid = 1;
		foreach(thrasher in thrashers)
		{
			if(DistanceSquared(point, thrasher.origin) <= overlapSqr)
			{
				valid = 0;
				break;
			}
		}
		if(valid)
		{
			filteredPoints[filteredPoints.size] = point;
		}
	}
	if(isdefined(entity.thrasher_teleport_dest_func))
	{
		filteredPoints = entity [[entity.thrasher_teleport_dest_func]](filteredPoints);
	}
	sortedPoints = ArraySortClosest(filteredPoints, entity.origin);
	teleport_point = sortedPoints[0];
	if(isdefined(teleport_point))
	{
		v_dir = entity.favoriteenemy.origin - teleport_point;
		v_dir = VectorNormalize(v_dir);
		v_angles = VectorToAngles(v_dir);
		entity ForceTeleport(teleport_point, v_angles);
	}
	entity.thrasherLastTeleportTime = GetTime();
}

/*
	Name: thrasherStunInitialize
	Namespace: ThrasherServerUtils
	Checksum: 0x4E326DAD
	Offset: 0x36E8
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private thrasherStunInitialize(entity)
{
	entity.thrasherStunStartTime = GetTime();
}

/*
	Name: thrasherStunUpdate
	Namespace: ThrasherServerUtils
	Checksum: 0x666E896E
	Offset: 0x3710
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private thrasherStunUpdate(entity)
{
	if(entity.thrasherStunStartTime + 1000 < GetTime())
	{
		entity ai::set_behavior_attribute("stunned", 0);
		entity.thrasherStunHealth = 3000;
	}
}

/*
	Name: thrasherHideSpikes
	Namespace: ThrasherServerUtils
	Checksum: 0x8C74BC8
	Offset: 0x3770
	Size: 0xDD
	Parameters: 2
	Flags: Private
*/
function private thrasherHideSpikes(entity, Hide)
{
	for(index = 1; index <= 24; index++)
	{
		tag = "j_spike";
		if(index < 10)
		{
			tag = tag + "0";
		}
		tag = tag + index + "_root";
		if(Hide)
		{
			entity HidePart(tag, "", 1);
			continue;
		}
		entity ShowPart(tag, "", 1);
	}
}

/*
	Name: thrasherHideFromPlayer
	Namespace: ThrasherServerUtils
	Checksum: 0x9E5E9434
	Offset: 0x3858
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function thrasherHideFromPlayer(thrasher, player, Hide)
{
	entityNumber = player GetEntityNumber();
	entityBit = 1 << entityNumber;
	currentHidden = clientfield::get("thrasher_player_hide");
	hiddenPlayers = currentHidden;
	if(Hide)
	{
		hiddenPlayers = currentHidden | entityBit;
	}
	else
	{
		~hiddenPlayers;
		hiddenPlayers = currentHidden & entityBit;
	}
	thrasher clientfield::set("thrasher_player_hide", hiddenPlayers);
}

/*
	Name: thrasherHidePoppedPustules
	Namespace: ThrasherServerUtils
	Checksum: 0x27B6A563
	Offset: 0x3948
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function thrasherHidePoppedPustules(entity)
{
	for(index = 0; index < Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size; index++)
	{
		sporeStruct = entity.thrasherSpores[index];
		if(sporeStruct.health <= 0)
		{
			entity HidePart(sporeStruct.tag);
			continue;
		}
		entity ShowPart(sporeStruct.tag);
	}
}

/*
	Name: thrasherRestorePustule
	Namespace: ThrasherServerUtils
	Checksum: 0x4D0617A0
	Offset: 0x3A30
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function thrasherRestorePustule(entity)
{
	for(index = 0; index < Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size; index++)
	{
		sporeStruct = entity.thrasherSpores[index];
		if(sporeStruct.health <= 0)
		{
			sporeStruct.health = sporeStruct.maxhealth;
			entity.health = entity.health + Int(entity.maxhealth / Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size);
			destroyedSpores = entity clientfield::get("thrasher_spore_state");
			~destroyedSpores;
			destroyedSpores = destroyedSpores & sporeStruct.clientfield;
			entity clientfield::set("thrasher_spore_state", destroyedSpores);
			break;
		}
	}
	thrasherHidePoppedPustules(entity);
}

/*
	Name: thrasherCreatePlayerClone
	Namespace: ThrasherServerUtils
	Checksum: 0xDED70FAE
	Offset: 0x3BD0
	Size: 0x18F
	Parameters: 1
	Flags: None
*/
function thrasherCreatePlayerClone(player)
{
	clone = spawn("script_model", player.origin);
	clone.angles = player.angles;
	bodyModel = player GetCharacterBodyModel();
	if(isdefined(bodyModel))
	{
		clone SetModel(bodyModel);
	}
	Headmodel = player GetCharacterHeadModel();
	if(isdefined(Headmodel) && Headmodel != "tag_origin")
	{
		if(isdefined(clone.head))
		{
			clone Detach(clone.head);
		}
		clone Attach(Headmodel);
	}
	helmetModel = player GetCharacterHelmetModel();
	if(isdefined(helmetModel) && Headmodel != "tag_origin")
	{
		clone Attach(helmetModel);
	}
	return clone;
}

/*
	Name: thrasherHidePlayerBody
	Namespace: ThrasherServerUtils
	Checksum: 0x95733BBD
	Offset: 0x3D68
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function thrasherHidePlayerBody(thrasher, player)
{
	player endon("death");
	player waittill("hide_body");
	player Hide();
}

/*
	Name: thrasherCanBeRevived
	Namespace: ThrasherServerUtils
	Checksum: 0xD3EA8F13
	Offset: 0x3DB8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function thrasherCanBeRevived(revivee)
{
	if(isdefined(revivee.thrasherConsumed) && revivee.thrasherConsumed)
	{
		return 0;
	}
	return 1;
}

/*
	Name: thrasherStopConsumePlayerScene
	Namespace: ThrasherServerUtils
	Checksum: 0xF65DAAF4
	Offset: 0x3E00
	Size: 0x73
	Parameters: 2
	Flags: Private
*/
function private thrasherStopConsumePlayerScene(thrasher, playerClone)
{
	thrasher endon("consume_scene_end");
	thrasher waittill("death");
	if(isdefined(thrasher))
	{
		thrasher scene::stop("scene_zm_dlc2_thrasher_eat_player");
	}
	if(isdefined(playerClone))
	{
		playerClone delete();
	}
}

/*
	Name: thrasherConsumePlayerScene
	Namespace: ThrasherServerUtils
	Checksum: 0x581A335C
	Offset: 0x3E80
	Size: 0xDB
	Parameters: 2
	Flags: Private
*/
function private thrasherConsumePlayerScene(thrasher, playerClone)
{
	thrasher endon("death");
	thrasher thread thrasherStopConsumePlayerScene(thrasher, playerClone);
	thrasher scene::Play("scene_zm_dlc2_thrasher_eat_player", Array(thrasher, playerClone));
	thrasher notify("consume_scene_end");
	targetPos = GetClosestPointOnNavMesh(thrasher.origin, 1024, 18);
	if(isdefined(targetPos))
	{
		thrasher ForceTeleport(targetPos);
	}
}

/*
	Name: thrasherConsumePlayerUtil
	Namespace: ThrasherServerUtils
	Checksum: 0x187AC39E
	Offset: 0x3F68
	Size: 0x5D3
	Parameters: 2
	Flags: None
*/
function thrasherConsumePlayerUtil(thrasher, player)
{
	/#
		Assert(IsActor(thrasher));
	#/
	/#
		Assert(thrasher.archetype == "Dev Block strings are not supported");
	#/
	/#
		Assert(isPlayer(player));
	#/
	thrasher endon("kill_consume_player");
	if(isdefined(player.thrasherConsumed) && player.thrasherConsumed)
	{
		return;
	}
	playerClone = thrasherCreatePlayerClone(player);
	playerClone.origin = player.origin;
	playerClone.angles = player.angles;
	playerClone Hide();
	thrasher.offsetModel = spawn("script_model", thrasher.origin);
	util::wait_network_frame();
	if(!isdefined(thrasher) || (isdefined(player.thrasherConsumed) && player.thrasherConsumed))
	{
		playerClone destroy();
		return;
	}
	thrasherHideFromPlayer(thrasher, player, 1);
	if(isdefined(thrasher.thrasherConsumedCallback))
	{
		[[thrasher.thrasherConsumedCallback]](thrasher, player);
	}
	if(isdefined(player.reviveTrigger))
	{
		player.reviveTrigger SetInvisibleToAll();
		player.reviveTrigger TriggerEnable(0);
	}
	player setClientUIVisibilityFlag("hud_visible", 0);
	player setClientUIVisibilityFlag("weapon_hud_visible", 0);
	player.thrasherConsumed = 1;
	player.thrasher = thrasher;
	player SetPlayerCollision(0);
	player WalkUnderwater(1);
	player.ignoreme = 1;
	player HideViewModel();
	player FreezeControls(0);
	player FreezeControlsAllowLook(1);
	player thread LUI::screen_fade_in(10);
	player clientfield::set_to_player("sndPlayerConsumed", 1);
	visionset_mgr::activate("visionset", "zm_isl_thrasher_stomach_visionset", player, 2);
	player thread thrasherKillThrasherOnAutoRevive(thrasher, player);
	eyePosition = player GetTagOrigin("tag_eye");
	eyeOffset = Abs(eyePosition[2] - player.origin[2]) + 10;
	thrasher.offsetModel LinkTo(thrasher, "tag_camera_thrasher", (0, 0, eyeOffset * -1 + 27));
	player playerLinkTo(thrasher.offsetModel, undefined, 1, 0, 0, 0, 0, 1);
	thrasher thread thrasherPlayerDeath(thrasher, player);
	thrasher.thrasherConsumedPlayer = 1;
	thrasher.thrasherPlayer = player;
	thrasher.thrasherLastTeleportTime = GetTime();
	player ghost();
	playerClone show();
	if(isdefined(playerClone))
	{
		thrasher thread thrasherConsumePlayerScene(thrasher, playerClone);
		playerClone thread thrasherHidePlayerBody(thrasher, playerClone);
		player notify("player_eaten_by_thrasher");
	}
	thrasher waittill("death");
	thrasherReleasePlayer(thrasher, player);
}

/*
	Name: thrasherKillThrasherOnAutoRevive
	Namespace: ThrasherServerUtils
	Checksum: 0x82132D62
	Offset: 0x4548
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function thrasherKillThrasherOnAutoRevive(thrasher, player)
{
	player endon("death");
	player endon("kill_thrasher_on_auto_revive");
	player waittill("bgb_revive");
	if(isdefined(player.thrasher))
	{
		player.thrasher kill();
	}
}

/*
	Name: thrasherReleasePlayer
	Namespace: ThrasherServerUtils
	Checksum: 0x6698408E
	Offset: 0x45C0
	Size: 0x4B3
	Parameters: 2
	Flags: None
*/
function thrasherReleasePlayer(thrasher, player)
{
	if(!isalive(player))
	{
		return;
	}
	if(isdefined(thrasher.offsetModel))
	{
		thrasher.offsetModel Unlink();
		thrasher.offsetModel delete();
	}
	if(isdefined(player.reviveTrigger))
	{
		player.reviveTrigger SetVisibleToAll();
		player.reviveTrigger TriggerEnable(1);
	}
	if(isdefined(thrasher.thrasherReleaseConsumedCallback))
	{
		[[thrasher.thrasherReleaseConsumedCallback]](thrasher, player);
	}
	thrasher.thrasherPlayer = undefined;
	player setClientUIVisibilityFlag("hud_visible", 1);
	player setClientUIVisibilityFlag("weapon_hud_visible", 1);
	player.thrasherFreedTime = GetTime();
	player SetStance("prone");
	player notify("kill_thrasher_on_auto_revive");
	player.thrasherConsumed = undefined;
	player.thrasher = undefined;
	player WalkUnderwater(0);
	player Unlink();
	player SetPlayerCollision(1);
	player show();
	player.ignoreme = 0;
	player ShowViewModel();
	player FreezeControlsAllowLook(0);
	player thread LUI::screen_fade_in(2);
	player clientfield::set_to_player("sndPlayerConsumed", 0);
	visionset_mgr::deactivate("visionset", "zm_isl_thrasher_stomach_visionset", player);
	player thread check_revive_after_consumed();
	targetPos = GetClosestPointOnNavMesh(player.origin, 1024, 18);
	if(isdefined(targetPos))
	{
		newPosition = player.origin;
		groundPosition = bullettrace(targetPos + VectorScale((0, 0, -1), 128), targetPos + VectorScale((0, 0, 1), 128), 0, player);
		if(isdefined(groundPosition["position"]))
		{
			newPosition = groundPosition["position"];
		}
		else
		{
			groundPosition = bullettrace(targetPos + VectorScale((0, 0, -1), 256), targetPos + VectorScale((0, 0, 1), 256), 0, player);
			if(isdefined(groundPosition["position"]))
			{
				newPosition = groundPosition["position"];
			}
			else
			{
				groundPosition = bullettrace(targetPos + VectorScale((0, 0, -1), 512), targetPos + VectorScale((0, 0, 1), 512), 0, player);
				if(isdefined(groundPosition["position"]))
				{
					newPosition = groundPosition["position"];
				}
			}
		}
		if(newPosition[2] > player.origin[2])
		{
			player.origin = newPosition;
		}
	}
	thrasher notify("kill_consume_player");
}

/*
	Name: check_revive_after_consumed
	Namespace: ThrasherServerUtils
	Checksum: 0x3501FE8
	Offset: 0x4A80
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function check_revive_after_consumed()
{
	self endon("death");
	self waittill("player_revived");
	self notify("achievement_ZM_ISLAND_THRASHER_RESCUE");
}

/*
	Name: thrasherPlayerDeath
	Namespace: ThrasherServerUtils
	Checksum: 0x1F92872F
	Offset: 0x4AB8
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function thrasherPlayerDeath(thrasher, player)
{
	thrasher endon("kill_consume_player");
	thrasher.thrasherPlayer = undefined;
	characterindex = player.characterindex;
	if(!isdefined(characterindex))
	{
		return;
	}
	level waittill("bleed_out", characterindex);
	if(isdefined(thrasher.thrasherReleaseConsumedCallback))
	{
		[[thrasher.thrasherReleaseConsumedCallback]](thrasher, player);
	}
	if(isdefined(thrasher) && isdefined(player))
	{
		thrasherHideFromPlayer(thrasher, player, 0);
	}
	if(isdefined(player))
	{
		player ShowViewModel();
		player clientfield::set_to_player("sndPlayerConsumed", 0);
		visionset_mgr::deactivate("visionset", "zm_isl_thrasher_stomach_visionset", player);
	}
}

/*
	Name: thrasherMoveModeAttributeCallback
	Namespace: ThrasherServerUtils
	Checksum: 0x10A803AF
	Offset: 0x4BF0
	Size: 0x6F
	Parameters: 4
	Flags: None
*/
function thrasherMoveModeAttributeCallback(entity, attribute, oldValue, value)
{
	if(value == "normal")
	{
		entity.team = "axis";
	}
	else if(value == "friendly")
	{
		entity.team = "allies";
	}
}

