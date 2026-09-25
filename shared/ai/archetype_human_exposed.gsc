#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;

#namespace archetype_human_exposed;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: archetype_human_exposed
	Checksum: 0x9C49652D
	Offset: 0x238
	Size: 0x143
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasCloseEnemy", &hasCloseEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("noCloseEnemyService", &noCloseEnemyService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryReacquireService", &tryReacquireService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToReactToEnemy", &prepareToReactToEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("resetReactionToEnemy", &resetReactionToEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("exposedSetDesiredStanceToStand", &exposedSetDesiredStanceToStand);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setPathMoveDelayedRandom", &setPathMoveDelayedRandom);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("vengeanceService", &vengeanceService);
}

/*
	Name: prepareToReactToEnemy
	Namespace: archetype_human_exposed
	Checksum: 0xD6DD1C1
	Offset: 0x388
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private prepareToReactToEnemy(behaviorTreeEntity)
{
	behaviorTreeEntity.newEnemyReaction = 0;
	behaviorTreeEntity.malFunctionReaction = 0;
	behaviorTreeEntity PathMode("move delayed", 1, 3);
}

/*
	Name: resetReactionToEnemy
	Namespace: archetype_human_exposed
	Checksum: 0xD030FF30
	Offset: 0x3E8
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private resetReactionToEnemy(behaviorTreeEntity)
{
	behaviorTreeEntity.newEnemyReaction = 0;
	behaviorTreeEntity.malFunctionReaction = 0;
}

/*
	Name: noCloseEnemyService
	Namespace: archetype_human_exposed
	Checksum: 0x67EA8F08
	Offset: 0x420
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private noCloseEnemyService(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy) && AiUtility::hasCloseEnemyToMelee(behaviorTreeEntity))
	{
		behaviorTreeEntity clearPath();
		return 1;
	}
	return 0;
}

/*
	Name: hasCloseEnemy
	Namespace: archetype_human_exposed
	Checksum: 0x8B3129D4
	Offset: 0x480
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private hasCloseEnemy(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) < 22500)
	{
		return 1;
	}
	return 0;
}

/*
	Name: _IsValidNeighbor
	Namespace: archetype_human_exposed
	Checksum: 0x6BF7E00B
	Offset: 0x4F0
	Size: 0x37
	Parameters: 2
	Flags: Private
*/
function private _IsValidNeighbor(entity, neighbor)
{
	return isdefined(neighbor) && entity.team === neighbor.team;
}

/*
	Name: vengeanceService
	Namespace: archetype_human_exposed
	Checksum: 0xE945A739
	Offset: 0x530
	Size: 0x151
	Parameters: 1
	Flags: Private
*/
function private vengeanceService(entity)
{
	actors = GetAIArray();
	if(!isdefined(entity.attacker))
	{
		return;
	}
	foreach(ai in actors)
	{
		if(_IsValidNeighbor(entity, ai) && DistanceSquared(entity.origin, ai.origin) <= 360 * 360 && RandomFloat(1) >= 0.5)
		{
			ai GetPerfectInfo(entity.attacker, 1);
		}
	}
}

/*
	Name: setPathMoveDelayedRandom
	Namespace: archetype_human_exposed
	Checksum: 0x49FFB7C3
	Offset: 0x690
	Size: 0x4B
	Parameters: 2
	Flags: Private
*/
function private setPathMoveDelayedRandom(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity PathMode("move delayed", 0, RandomFloatRange(1, 3));
}

/*
	Name: exposedSetDesiredStanceToStand
	Namespace: archetype_human_exposed
	Checksum: 0x5500C47A
	Offset: 0x6E8
	Size: 0x7B
	Parameters: 2
	Flags: Private
*/
function private exposedSetDesiredStanceToStand(behaviorTreeEntity, asmStateName)
{
	AiUtility::keepClaimNode(behaviorTreeEntity);
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
}

/*
	Name: tryReacquireService
	Namespace: archetype_human_exposed
	Checksum: 0xA0542659
	Offset: 0x770
	Size: 0x2D1
	Parameters: 1
	Flags: Private
*/
function private tryReacquireService(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.reacquire_state))
	{
		behaviorTreeEntity.reacquire_state = 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		behaviorTreeEntity.reacquire_state = 0;
		return 0;
	}
	if(behaviorTreeEntity HasPath())
	{
		behaviorTreeEntity.reacquire_state = 0;
		return 0;
	}
	if(behaviorTreeEntity SeeRecently(behaviorTreeEntity.enemy, 4))
	{
		behaviorTreeEntity.reacquire_state = 0;
		return 0;
	}
	dirToEnemy = VectorNormalize(behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin);
	FORWARD = AnglesToForward(behaviorTreeEntity.angles);
	if(VectorDot(dirToEnemy, FORWARD) < 0.5)
	{
		behaviorTreeEntity.reacquire_state = 0;
		return 0;
	}
	switch(behaviorTreeEntity.reacquire_state)
	{
		case 0:
		case 1:
		case 2:
		{
			step_size = 32 + behaviorTreeEntity.reacquire_state * 32;
			reacquirePos = behaviorTreeEntity ReacquireStep(step_size);
			break;
		}
		case 4:
		{
			if(!behaviorTreeEntity cansee(behaviorTreeEntity.enemy) || !behaviorTreeEntity CanShootEnemy())
			{
				behaviorTreeEntity FlagEnemyUnattackable();
			}
			break;
		}
		case default:
		{
			if(behaviorTreeEntity.reacquire_state > 15)
			{
				behaviorTreeEntity.reacquire_state = 0;
				return 0;
			}
			break;
		}
	}
	if(IsVec(reacquirePos))
	{
		behaviorTreeEntity UsePosition(reacquirePos);
		return 1;
	}
	behaviorTreeEntity.reacquire_state++;
	return 0;
}

