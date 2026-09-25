#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;

#namespace AiUtility;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: AiUtility
	Checksum: 0x993AEE67
	Offset: 0x618
	Size: 0x55B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionBehaviorCondition", &locomotionBehaviorCondition);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionBehaviorCondition", &locomotionBehaviorCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("nonCombatLocomotionCondition", &nonCombatLocomotionCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setDesiredStanceForMovement", &setDesiredStanceForMovement);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("clearPathFromScript", &clearPathFromScript);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionShouldPatrol", &locomotionShouldPatrol);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldPatrol", &locomotionShouldPatrol);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldTacticalWalk", &shouldTacticalWalk);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldTacticalWalk", &shouldTacticalWalk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAdjustStanceAtTacticalWalk", &shouldAdjustStanceAtTacticalWalk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("adjustStanceToFaceEnemyInitialize", &adjustStanceToFaceEnemyInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("adjustStanceToFaceEnemyTerminate", &adjustStanceToFaceEnemyTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tacticalWalkActionStart", &tacticalWalkActionStart);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("tacticalWalkActionStart", &tacticalWalkActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("clearArrivalPos", &clearArrivalPos);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("clearArrivalPos", &clearArrivalPos);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStartArrival", &shouldStartArrivalCondition);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldStartArrival", &shouldStartArrivalCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionShouldTraverse", &locomotionShouldTraverse);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldTraverse", &locomotionShouldTraverse);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("traverseActionStart", &traverseActionStart, undefined, undefined);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("traverseSetup", &traverseSetup);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("disableRepath", &disableRepath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("enableRepath", &enableRepath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canJuke", &canJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseJukeDirection", &chooseJukeDirection);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionPainBehaviorCondition", &locomotionPainBehaviorCondition);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionIsOnStairs", &locomotionIsOnStairs);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldLoopOnStairs", &locomotionShouldLoopOnStairs);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldSkipStairs", &locomotionShouldSkipStairs);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionStairsStart", &locomotionStairsStart);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionStairsEnd", &locomotionStairsEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("delayMovement", &delayMovement);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("delayMovement", &delayMovement);
}

/*
	Name: locomotionIsOnStairs
	Namespace: AiUtility
	Checksum: 0x5E696457
	Offset: 0xB80
	Size: 0xA5
	Parameters: 1
	Flags: Private
*/
function private locomotionIsOnStairs(behaviorTreeEntity)
{
	startnode = behaviorTreeEntity.traverseStartNode;
	if(isdefined(startnode) && behaviorTreeEntity ShouldStartTraversal())
	{
		if(isdefined(startnode.animscript) && IsSubStr(ToLower(startnode.animscript), "stairs"))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: locomotionShouldSkipStairs
	Namespace: AiUtility
	Checksum: 0x4CDD98FA
	Offset: 0xC30
	Size: 0x159
	Parameters: 1
	Flags: Private
*/
function private locomotionShouldSkipStairs(behaviorTreeEntity)
{
	/#
		Assert(isdefined(behaviorTreeEntity._stairsStartNode) && isdefined(behaviorTreeEntity._stairsEndNode));
	#/
	numTotalSteps = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_num_total_steps");
	stepsSoFar = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_num_steps");
	direction = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_direction");
	if(direction != "staircase_up")
	{
		return 0;
	}
	numOutSteps = 2;
	totalStepsWithoutOut = numTotalSteps - numOutSteps;
	if(stepsSoFar >= totalStepsWithoutOut)
	{
		return 0;
	}
	remainingSteps = totalStepsWithoutOut - stepsSoFar;
	if(remainingSteps >= 3 || remainingSteps >= 6 || remainingSteps >= 8)
	{
		return 1;
	}
	return 0;
}

/*
	Name: locomotionShouldLoopOnStairs
	Namespace: AiUtility
	Checksum: 0x31E6D82D
	Offset: 0xD98
	Size: 0x18B
	Parameters: 1
	Flags: Private
*/
function private locomotionShouldLoopOnStairs(behaviorTreeEntity)
{
	/#
		Assert(isdefined(behaviorTreeEntity._stairsStartNode) && isdefined(behaviorTreeEntity._stairsEndNode));
	#/
	numTotalSteps = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_num_total_steps");
	stepsSoFar = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_num_steps");
	exittype = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_exit_type");
	direction = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_staircase_direction");
	numOutSteps = 2;
	if(direction == "staircase_up")
	{
		switch(exittype)
		{
			case "staircase_up_exit_l_3_stairs":
			case "staircase_up_exit_r_3_stairs":
			{
				numOutSteps = 3;
				break;
			}
			case "staircase_up_exit_l_4_stairs":
			case "staircase_up_exit_r_4_stairs":
			{
				numOutSteps = 4;
				break;
			}
		}
	}
	if(stepsSoFar >= numTotalSteps - numOutSteps)
	{
		behaviorTreeEntity SetStairsExitTransform();
		return 0;
	}
	return 1;
}

/*
	Name: locomotionStairsStart
	Namespace: AiUtility
	Checksum: 0x17CADFE5
	Offset: 0xF30
	Size: 0x38F
	Parameters: 1
	Flags: Private
*/
function private locomotionStairsStart(behaviorTreeEntity)
{
	startnode = behaviorTreeEntity.traverseStartNode;
	endNode = behaviorTreeEntity.traverseEndNode;
	/#
		Assert(isdefined(startnode) && isdefined(endNode));
	#/
	behaviorTreeEntity._stairsStartNode = startnode;
	behaviorTreeEntity._stairsEndNode = endNode;
	if(startnode.type == "Begin")
	{
		direction = "staircase_down";
	}
	else
	{
		direction = "staircase_up";
	}
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_type", behaviorTreeEntity._stairsStartNode.animscript);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_state", "staircase_start");
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_direction", direction);
	numTotalSteps = undefined;
	if(isdefined(startnode.script_int))
	{
		numTotalSteps = Int(endNode.script_int);
	}
	else if(isdefined(endNode.script_int))
	{
		numTotalSteps = Int(endNode.script_int);
	}
	/#
		Assert(isdefined(numTotalSteps) && IsInt(numTotalSteps) && numTotalSteps > 0);
	#/
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_num_total_steps", numTotalSteps);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_num_steps", 0);
	exittype = undefined;
	if(direction == "staircase_up")
	{
		switch(Int(behaviorTreeEntity._stairsStartNode.script_int) % 4)
		{
			case 0:
			{
				exittype = "staircase_up_exit_r_3_stairs";
				break;
			}
			case 1:
			{
				exittype = "staircase_up_exit_r_4_stairs";
				break;
			}
			case 2:
			{
				exittype = "staircase_up_exit_l_3_stairs";
				break;
			}
			case 3:
			{
				exittype = "staircase_up_exit_l_4_stairs";
				break;
			}
		}
		break;
	}
	switch(Int(behaviorTreeEntity._stairsStartNode.script_int) % 2)
	{
		case 0:
		{
			exittype = "staircase_down_exit_l_2_stairs";
			break;
		}
		case 1:
		{
			exittype = "staircase_down_exit_r_2_stairs";
			break;
		}
	}
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_exit_type", exittype);
	return 1;
}

/*
	Name: locomotionStairLoopStart
	Namespace: AiUtility
	Checksum: 0xC865E4BB
	Offset: 0x12C8
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private locomotionStairLoopStart(behaviorTreeEntity)
{
	/#
		Assert(isdefined(behaviorTreeEntity._stairsStartNode) && isdefined(behaviorTreeEntity._stairsEndNode));
	#/
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_state", "staircase_loop");
}

/*
	Name: locomotionStairsEnd
	Namespace: AiUtility
	Checksum: 0x40084F0D
	Offset: 0x1340
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private locomotionStairsEnd(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_state", undefined);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_staircase_direction", undefined);
}

/*
	Name: locomotionPainBehaviorCondition
	Namespace: AiUtility
	Checksum: 0xDED5D031
	Offset: 0x1398
	Size: 0x41
	Parameters: 1
	Flags: Private
*/
function private locomotionPainBehaviorCondition(entity)
{
	return entity HasPath() && entity HasValidInterrupt("pain");
}

/*
	Name: clearPathFromScript
	Namespace: AiUtility
	Checksum: 0x8733D9C1
	Offset: 0x13E8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function clearPathFromScript(behaviorTreeEntity)
{
	behaviorTreeEntity clearPath();
}

/*
	Name: nonCombatLocomotionCondition
	Namespace: AiUtility
	Checksum: 0x40C8CC88
	Offset: 0x1418
	Size: 0x6F
	Parameters: 1
	Flags: Private
*/
function private nonCombatLocomotionCondition(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.accurateFire) && behaviorTreeEntity.accurateFire)
	{
		return 1;
	}
	if(isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	return 1;
}

/*
	Name: combatLocomotionCondition
	Namespace: AiUtility
	Checksum: 0x7E130122
	Offset: 0x1490
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private combatLocomotionCondition(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.accurateFire) && behaviorTreeEntity.accurateFire)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.enemy))
	{
		return 1;
	}
	return 0;
}

/*
	Name: locomotionBehaviorCondition
	Namespace: AiUtility
	Checksum: 0x95D61DDA
	Offset: 0x1508
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function locomotionBehaviorCondition(behaviorTreeEntity)
{
	return behaviorTreeEntity HasPath();
}

/*
	Name: setDesiredStanceForMovement
	Namespace: AiUtility
	Checksum: 0x35CE5FB6
	Offset: 0x1538
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private setDesiredStanceForMovement(behaviorTreeEntity)
{
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance") != "stand")
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	}
}

/*
	Name: locomotionShouldTraverse
	Namespace: AiUtility
	Checksum: 0x82F37E3F
	Offset: 0x15A0
	Size: 0x55
	Parameters: 1
	Flags: Private
*/
function private locomotionShouldTraverse(behaviorTreeEntity)
{
	startnode = behaviorTreeEntity.traverseStartNode;
	if(isdefined(startnode) && behaviorTreeEntity ShouldStartTraversal())
	{
		return 1;
	}
	return 0;
}

/*
	Name: traverseSetup
	Namespace: AiUtility
	Checksum: 0x30C97292
	Offset: 0x1600
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function traverseSetup(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_traversal_type", behaviorTreeEntity.traverseStartNode.animscript);
	return 1;
}

/*
	Name: traverseActionStart
	Namespace: AiUtility
	Checksum: 0x9DA120ED
	Offset: 0x1670
	Size: 0xFF
	Parameters: 2
	Flags: None
*/
function traverseActionStart(behaviorTreeEntity, asmStateName)
{
	traverseSetup(behaviorTreeEntity);
	/#
		animationResults = behaviorTreeEntity ASTSearch(istring(asmStateName));
		/#
			Assert(isdefined(animationResults["Dev Block strings are not supported"]), behaviorTreeEntity.archetype + "Dev Block strings are not supported" + behaviorTreeEntity.traverseStartNode.animscript + "Dev Block strings are not supported" + behaviorTreeEntity.traverseStartNode.origin + "Dev Block strings are not supported");
		#/
	#/
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: disableRepath
	Namespace: AiUtility
	Checksum: 0x87E3AA3F
	Offset: 0x1778
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private disableRepath(entity)
{
	entity.disableRepath = 1;
}

/*
	Name: enableRepath
	Namespace: AiUtility
	Checksum: 0x52D28EE
	Offset: 0x17A0
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private enableRepath(entity)
{
	entity.disableRepath = 0;
}

/*
	Name: shouldStartArrivalCondition
	Namespace: AiUtility
	Checksum: 0xEAE52FE1
	Offset: 0x17C8
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function shouldStartArrivalCondition(behaviorTreeEntity)
{
	if(behaviorTreeEntity ShouldStartArrival())
	{
		return 1;
	}
	return 0;
}

/*
	Name: clearArrivalPos
	Namespace: AiUtility
	Checksum: 0x1D818F77
	Offset: 0x1800
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function clearArrivalPos(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.isarrivalpending) || (isdefined(behaviorTreeEntity.isarrivalpending) && behaviorTreeEntity.isarrivalpending))
	{
		self ClearUsePosition();
	}
	return 1;
}

/*
	Name: delayMovement
	Namespace: AiUtility
	Checksum: 0xE3DA1A7F
	Offset: 0x1868
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function delayMovement(entity)
{
	entity PathMode("move delayed", 0, RandomFloatRange(1, 2));
	return 1;
}

/*
	Name: shouldAdjustStanceAtTacticalWalk
	Namespace: AiUtility
	Checksum: 0x18005F1C
	Offset: 0x18B8
	Size: 0x4F
	Parameters: 1
	Flags: Private
*/
function private shouldAdjustStanceAtTacticalWalk(behaviorTreeEntity)
{
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(stance != "stand")
	{
		return 1;
	}
	return 0;
}

/*
	Name: adjustStanceToFaceEnemyInitialize
	Namespace: AiUtility
	Checksum: 0x7B3442D
	Offset: 0x1910
	Size: 0x67
	Parameters: 1
	Flags: Private
*/
function private adjustStanceToFaceEnemyInitialize(behaviorTreeEntity)
{
	behaviorTreeEntity.newEnemyReaction = 0;
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	behaviorTreeEntity OrientMode("face enemy");
	return 1;
}

/*
	Name: adjustStanceToFaceEnemyTerminate
	Namespace: AiUtility
	Checksum: 0x5B09BFAC
	Offset: 0x1980
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private adjustStanceToFaceEnemyTerminate(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
}

/*
	Name: tacticalWalkActionStart
	Namespace: AiUtility
	Checksum: 0x1F79EA79
	Offset: 0x19C0
	Size: 0x9F
	Parameters: 1
	Flags: Private
*/
function private tacticalWalkActionStart(behaviorTreeEntity)
{
	clearArrivalPos(behaviorTreeEntity);
	resetCoverParameters(behaviorTreeEntity);
	setCanBeFlanked(behaviorTreeEntity, 0);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
	behaviorTreeEntity OrientMode("face enemy");
	return 1;
}

/*
	Name: validJukeDirection
	Namespace: AiUtility
	Checksum: 0xDA2B73A9
	Offset: 0x1A68
	Size: 0x14D
	Parameters: 4
	Flags: Private
*/
function private validJukeDirection(entity, entityNavMeshPosition, forwardOffset, lateralOffset)
{
	jukeNavmeshThreshold = 6;
	forwardPosition = entity.origin + lateralOffset + forwardOffset;
	backwardPosition = entity.origin + lateralOffset - forwardOffset;
	forwardPositionValid = IsPointOnNavMesh(forwardPosition, entity) && TracePassedOnNavMesh(entity.origin, forwardPosition);
	backwardPositionValid = IsPointOnNavMesh(backwardPosition, entity) && TracePassedOnNavMesh(entity.origin, backwardPosition);
	if(!isdefined(entity.ignoreBackwardPosition))
	{
		return forwardPositionValid && backwardPositionValid;
	}
	else
	{
		return forwardPositionValid;
	}
	return 0;
}

/*
	Name: calculateJukeDirection
	Namespace: AiUtility
	Checksum: 0x260240EA
	Offset: 0x1BC0
	Size: 0x31B
	Parameters: 3
	Flags: None
*/
function calculateJukeDirection(entity, entityRadius, jukeDistance)
{
	jukeNavmeshThreshold = 6;
	defaultDirection = "forward";
	if(isdefined(entity.defaultJukeDirection))
	{
		defaultDirection = entity.defaultJukeDirection;
	}
	if(isdefined(entity.enemy))
	{
		navmeshPosition = GetClosestPointOnNavMesh(entity.origin, jukeNavmeshThreshold);
		if(!IsVec(navmeshPosition))
		{
			return defaultDirection;
		}
		vectorToEnemy = entity.enemy.origin - entity.origin;
		vectorToEnemyAngles = VectorToAngles(vectorToEnemy);
		forwardDistance = AnglesToForward(vectorToEnemyAngles) * entityRadius;
		rightJukeDistance = AnglesToRight(vectorToEnemyAngles) * jukeDistance;
		preferLeft = undefined;
		if(entity HasPath())
		{
			rightPosition = entity.origin + rightJukeDistance;
			leftPosition = entity.origin - rightJukeDistance;
			preferLeft = DistanceSquared(leftPosition, entity.pathGoalPos) <= DistanceSquared(rightPosition, entity.pathGoalPos);
		}
		else
		{
			preferLeft = math::cointoss();
		}
		if(preferLeft)
		{
			if(validJukeDirection(entity, navmeshPosition, forwardDistance, rightJukeDistance * -1))
			{
				return "left";
			}
			else if(validJukeDirection(entity, navmeshPosition, forwardDistance, rightJukeDistance))
			{
				return "right";
			}
		}
		else if(validJukeDirection(entity, navmeshPosition, forwardDistance, rightJukeDistance))
		{
			return "right";
		}
		else if(validJukeDirection(entity, navmeshPosition, forwardDistance, rightJukeDistance * -1))
		{
			return "left";
		}
	}
	return defaultDirection;
}

/*
	Name: calculateDefaultJukeDirection
	Namespace: AiUtility
	Checksum: 0xBF77357
	Offset: 0x1EE8
	Size: 0x99
	Parameters: 1
	Flags: Private
*/
function private calculateDefaultJukeDirection(entity)
{
	jukeDistance = 30;
	entityRadius = 15;
	if(isdefined(entity.jukeDistance))
	{
		jukeDistance = entity.jukeDistance;
	}
	if(isdefined(entity.entityRadius))
	{
		entityRadius = entity.entityRadius;
	}
	return calculateJukeDirection(entity, entityRadius, jukeDistance);
}

/*
	Name: canJuke
	Namespace: AiUtility
	Checksum: 0xABDAAFF4
	Offset: 0x1F90
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function canJuke(entity)
{
	if(isdefined(self.is_disabled) && self.is_disabled)
	{
		return 0;
	}
	if(isdefined(entity.jukeMaxDistance) && isdefined(entity.enemy))
	{
		maxDistSquared = entity.jukeMaxDistance * entity.jukeMaxDistance;
		if(Distance2DSquared(entity.origin, entity.enemy.origin) > maxDistSquared)
		{
			return 0;
		}
	}
	jukeDirection = calculateDefaultJukeDirection(entity);
	return jukeDirection != "forward";
}

/*
	Name: chooseJukeDirection
	Namespace: AiUtility
	Checksum: 0xA9C71271
	Offset: 0x2080
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function chooseJukeDirection(entity)
{
	jukeDirection = calculateDefaultJukeDirection(entity);
	blackboard::SetBlackBoardAttribute(entity, "_juke_direction", jukeDirection);
}

