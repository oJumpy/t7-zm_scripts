#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_human_riotshield_interface;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace ARCHETYPE_HUMAN_RIOTSHIELD;

/*
	Name: main
	Namespace: ARCHETYPE_HUMAN_RIOTSHIELD
	Checksum: 0xA139F5F
	Offset: 0x560
	Size: 0x73
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	spawner::add_archetype_spawn_function("human_riotshield", &HumanRiotshieldBehavior::ArchetypeHumanRiotshieldBlackboardInit);
	spawner::add_archetype_spawn_function("human_riotshield", &HumanRiotshieldServerUtils::humanRiotshieldSpawnSetup);
	HumanRiotshieldBehavior::RegisterBehaviorScriptFunctions();
	HumanRiotshieldInterface::RegisterHumanRiotshieldInterfaceAttributes();
}

#namespace HumanRiotshieldBehavior;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x399F3948
	Offset: 0x5E0
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldShouldTacticalWalk", &riotshieldShouldTacticalWalk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldNonCombatLocomotionCondition", &riotshieldNonCombatLocomotionCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("unarmedWalkAction", &unarmedWalkActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldTacticalWalkStart", &riotshieldTacticalWalkStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldAdvanceOnEnemyService", &riotshieldAdvanceOnEnemyService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldShouldFlinch", &riotshieldShouldFlinch);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldIncrementFlinchCount", &riotshieldIncrementFlinchCount);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldClearFlinchCount", &riotshieldClearFlinchCount);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldUnarmedTargetService", &riotshieldUnarmedTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldUnarmedAdvanceOnEnemyService", &riotshieldUnarmedAdvanceOnEnemyService);
}

/*
	Name: ArchetypeHumanRiotshieldBlackboardInit
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xE0D85EDE
	Offset: 0x780
	Size: 0xF3
	Parameters: 0
	Flags: Private
*/
function private ArchetypeHumanRiotshieldBlackboardInit()
{
	entity = self;
	blackboard::CreateBlackBoardForEntity(entity);
	ai::CreateInterfaceForEntity(entity);
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeHumanRiotshieldOnAnimscriptedCallback;
	/#
		entity function_89398c57();
	#/
	blackboard::RegisterBlackBoardAttribute(self, "_move_mode", "normal", &riotshieldMoveMode);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
}

/*
	Name: ArchetypeHumanRiotshieldOnAnimscriptedCallback
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x5CB4A3A3
	Offset: 0x880
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeHumanRiotshieldOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeHumanRiotshieldBlackboardInit();
}

/*
	Name: riotshieldMoveMode
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xCA29D82
	Offset: 0x8C0
	Size: 0x45
	Parameters: 0
	Flags: Private
*/
function private riotshieldMoveMode()
{
	entity = self;
	if(entity ai::get_behavior_attribute("phalanx"))
	{
		return "marching";
	}
	return "normal";
}

/*
	Name: riotshieldShouldFlinch
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x2BB56F5A
	Offset: 0x910
	Size: 0xC3
	Parameters: 1
	Flags: Private
*/
function private riotshieldShouldFlinch(entity)
{
	if(entity HasPath() && entity ai::get_behavior_attribute("phalanx"))
	{
		return 1;
	}
	if(entity.damagelocation != "riotshield")
	{
		return 0;
	}
	if(entity.damagelocation == "riotshield" && entity.flinchCount >= 5 && entity.lastFlinchTime + 1500 >= GetTime())
	{
		return 0;
	}
	return 1;
}

/*
	Name: riotshieldIncrementFlinchCount
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xEB7EFA1C
	Offset: 0x9E0
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private riotshieldIncrementFlinchCount(entity)
{
	entity.flinchCount++;
	entity.lastFlinchTime = GetTime();
}

/*
	Name: riotshieldClearFlinchCount
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xE64DADAF
	Offset: 0xA18
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private riotshieldClearFlinchCount(entity)
{
	entity.lastFlinchTime = GetTime();
	entity.flinchCount = 0;
}

/*
	Name: riotshieldShouldTacticalWalk
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x5854FAAD
	Offset: 0xA50
	Size: 0xF
	Parameters: 1
	Flags: Private
*/
function private riotshieldShouldTacticalWalk(behaviorTreeEntity)
{
	return 1;
}

/*
	Name: riotshieldNonCombatLocomotionCondition
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x6D867AB7
	Offset: 0xA68
	Size: 0x6F
	Parameters: 1
	Flags: Private
*/
function private riotshieldNonCombatLocomotionCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy)) > 490000)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: riotshieldAdvanceOnEnemyService
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x279D9F40
	Offset: 0xAE0
	Size: 0x38D
	Parameters: 1
	Flags: Private
*/
function private riotshieldAdvanceOnEnemyService(behaviorTreeEntity)
{
	itsBeenAWhile = GetTime() > behaviorTreeEntity.nextFindBestCoverTime;
	isAtScriptGoal = behaviorTreeEntity IsAtGoal();
	tooLongAtNode = 0;
	if(behaviorTreeEntity ai::get_behavior_attribute("phalanx"))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.chosenNode))
	{
		dist_sq = DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.chosenNode.origin);
		if(dist_sq < 256)
		{
			if(!isdefined(behaviorTreeEntity.timeAtChosenNode))
			{
				behaviorTreeEntity.timeAtChosenNode = GetTime();
			}
		}
	}
	if(isdefined(behaviorTreeEntity.timeAtChosenNode))
	{
		if(GetTime() - behaviorTreeEntity.timeAtChosenNode > behaviorTreeEntity.timeAtNodeMax)
		{
			tooLongAtNode = 1;
			behaviorTreeEntity.timeAtChosenNode = undefined;
		}
	}
	shouldLookForBetterCover = itsBeenAWhile || !isAtScriptGoal || tooLongAtNode;
	if(shouldLookForBetterCover && isdefined(behaviorTreeEntity.enemy))
	{
		closestRandomNode = undefined;
		closestRandomNodes = behaviorTreeEntity FindBestCoverNodes(behaviorTreeEntity.goalRadius, behaviorTreeEntity.goalpos);
		foreach(node in closestRandomNodes)
		{
			if(isdefined(behaviorTreeEntity.chosenNode) && behaviorTreeEntity.chosenNode == node)
			{
				continue;
			}
			if(AiUtility::getCoverType(node) == "cover_exposed")
			{
				closestRandomNode = node;
				break;
			}
		}
		if(!isdefined(closestRandomNode))
		{
			closestRandomNode = closestRandomNodes[0];
		}
		if(isdefined(closestRandomNode) && behaviorTreeEntity FindPath(behaviorTreeEntity.origin, closestRandomNode.origin, 1, 0))
		{
			AiUtility::releaseClaimNode(behaviorTreeEntity);
			AiUtility::useCoverNodeWrapper(behaviorTreeEntity, closestRandomNode);
			behaviorTreeEntity.chosenNode = closestRandomNode;
			behaviorTreeEntity.timeAtNodeMax = randomIntRange(behaviorTreeEntity.moveDelayMin, behaviorTreeEntity.moveDelayMax);
			behaviorTreeEntity.timeAtChosenNode = undefined;
			return 1;
		}
	}
	return 0;
}

/*
	Name: riotshieldTacticalWalkStart
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xBD03AD94
	Offset: 0xE78
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private riotshieldTacticalWalkStart(behaviorTreeEntity)
{
	AiUtility::resetCoverParameters(behaviorTreeEntity);
	AiUtility::setCanBeFlanked(behaviorTreeEntity, 0);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
	behaviorTreeEntity OrientMode("face enemy");
}

/*
	Name: riotshieldUnarmedTargetService
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x82351F01
	Offset: 0xF08
	Size: 0x31B
	Parameters: 1
	Flags: Private
*/
function private riotshieldUnarmedTargetService(behaviorTreeEntity)
{
	if(!AiUtility::shouldMutexMelee(behaviorTreeEntity))
	{
		return 0;
	}
	enemies = [];
	ai = GetAIArray();
	foreach(value in ai)
	{
		if(value.team != behaviorTreeEntity.team && IsActor(value))
		{
			enemies[enemies.size] = value;
		}
	}
	if(enemies.size > 0)
	{
		closestEnemy = undefined;
		closestEnemyDistance = 0;
		for(index = 0; index < enemies.size; index++)
		{
			enemy = enemies[index];
			enemyDistance = DistanceSquared(behaviorTreeEntity.origin, enemy.origin);
			checkEnemy = 0;
			if(enemyDistance > behaviorTreeEntity.goalRadius * behaviorTreeEntity.goalRadius)
			{
				continue;
			}
			if(!isdefined(enemy.targeted_by) || enemy.targeted_by == behaviorTreeEntity)
			{
				checkEnemy = 1;
			}
			else
			{
				targetDistance = DistanceSquared(enemy.targeted_by.origin, enemy.origin);
				if(enemyDistance < targetDistance)
				{
					checkEnemy = 1;
				}
			}
			if(checkEnemy)
			{
				if(!isdefined(closestEnemy) || enemyDistance < closestEnemyDistance)
				{
					closestEnemyDistance = enemyDistance;
					closestEnemy = enemy;
				}
			}
		}
		if(isdefined(behaviorTreeEntity.favoriteenemy))
		{
			behaviorTreeEntity.favoriteenemy.targeted_by = undefined;
		}
		behaviorTreeEntity.favoriteenemy = closestEnemy;
		if(isdefined(behaviorTreeEntity.favoriteenemy))
		{
			behaviorTreeEntity.favoriteenemy.targeted_by = behaviorTreeEntity;
		}
		return 1;
	}
	return 0;
}

/*
	Name: riotshieldUnarmedAdvanceOnEnemyService
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x11BCFCC0
	Offset: 0x1230
	Size: 0x13D
	Parameters: 1
	Flags: Private
*/
function private riotshieldUnarmedAdvanceOnEnemyService(behaviorTreeEntity)
{
	if(GetTime() < behaviorTreeEntity.nextFindBestCoverTime)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.favoriteenemy))
	{
		/#
			recordLine(behaviorTreeEntity.favoriteenemy.origin, behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity);
		#/
		enemyDistance = DistanceSquared(behaviorTreeEntity.favoriteenemy.origin, behaviorTreeEntity.origin);
		if(enemyDistance < behaviorTreeEntity.goalRadius * behaviorTreeEntity.goalRadius)
		{
			behaviorTreeEntity UsePosition(behaviorTreeEntity.favoriteenemy.origin);
			return 1;
		}
	}
	behaviorTreeEntity ClearUsePosition();
	return 0;
}

/*
	Name: unarmedWalkActionStart
	Namespace: HumanRiotshieldBehavior
	Checksum: 0x273D3683
	Offset: 0x1378
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private unarmedWalkActionStart(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
	behaviorTreeEntity OrientMode("face enemy");
}

/*
	Name: riotshieldKilledOverride
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xCF029325
	Offset: 0x13D8
	Size: 0x6F
	Parameters: 8
	Flags: Private
*/
function private riotshieldKilledOverride(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime)
{
	entity = self;
	AiUtility::dropRiotshield(entity);
	return damage;
}

/*
	Name: riotshieldDamageOverride
	Namespace: HumanRiotshieldBehavior
	Checksum: 0xDC26B4E2
	Offset: 0x1450
	Size: 0xF7
	Parameters: 12
	Flags: Private
*/
function private riotshieldDamageOverride(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(sHitLoc == "riotshield")
	{
		riotshieldIncrementFlinchCount(entity);
		entity.health = entity.health + 1;
		return 1;
	}
	if(sWeapon.name == "incendiary_grenade")
	{
		iDamage = entity.health;
	}
	return iDamage;
}

#namespace HumanRiotshieldServerUtils;

/*
	Name: humanRiotshieldSpawnSetup
	Namespace: HumanRiotshieldServerUtils
	Checksum: 0x8C52BD32
	Offset: 0x1550
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function humanRiotshieldSpawnSetup()
{
	entity = self;
	AiUtility::attachRiotshield(entity, GetWeapon("riotshield"), "wpn_t7_shield_riot_world_lh", "tag_weapon_left");
	entity.moveDelayMin = 2500;
	entity.moveDelayMax = 5000;
	entity.ignorerunAndgundist = 1;
	AiUtility::AddAIOverrideDamageCallback(entity, &HumanRiotshieldBehavior::riotshieldDamageOverride);
	AiUtility::AddAIOverrideKilledCallback(entity, &HumanRiotshieldBehavior::riotshieldKilledOverride);
	HumanRiotshieldBehavior::riotshieldClearFlinchCount(entity);
}

