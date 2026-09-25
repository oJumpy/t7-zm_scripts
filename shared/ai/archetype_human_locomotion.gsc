#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;

#namespace archetype_human_locomotion;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: archetype_human_locomotion
	Checksum: 0x40CF54E3
	Offset: 0x558
	Size: 0x39B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareForMovement", &prepareForMovement);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("prepareForMovement", &prepareForMovement);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldTacticalArrive", &shouldTacticalArriveCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("humanShouldSprint", &humanShouldSprint);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("planHumanArrivalAtCover", &planHumanArrivalAtCover);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldPlanArrivalIntoCover", &shouldPlanArrivalIntoCover);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldArriveExposed", &shouldArriveExposed);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("nonCombatLocomotionUpdate", &nonCombatLocomotionUpdate);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("combatLocomotionStart", &combatLocomotionStart);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("combatLocomotionUpdate", &combatLocomotionUpdate);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("humanNonCombatLocomotionCondition", &humanNonCombatLocomotionCondition);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("humanCombatLocomotionCondition", &humanCombatLocomotionCondition);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldSwitchToTacticalWalkFromRun", &shouldSwitchToTacticalWalkFromRun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToStopNearEnemy", &prepareToStopNearEnemy);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("prepareToStopNearEnemy", &prepareToStopNearEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToMoveAwayFromNearByEnemy", &prepareToMoveAwayFromNearByEnemy);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldTacticalWalkPain", &shouldTacticalWalkPain);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("beginTacticalWalkPain", &beginTacticalWalkPain);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldContinueTacticalWalkPain", &shouldContinueTacticalWalkPain);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldTacticalWalkScan", &shouldTacticalWalkScan);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("continueTacticalWalkScan", &continueTacticalWalkScan);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("tacticalWalkScanTerminate", &tacticalWalkScanTerminate);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("BSMLocomotionHasValidPainInterrupt", &BSMLocomotionHasValidPainInterrupt);
}

/*
	Name: tacticalWalkScanTerminate
	Namespace: archetype_human_locomotion
	Checksum: 0x221BBFA9
	Offset: 0x900
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private tacticalWalkScanTerminate(entity)
{
	entity.lastTacticalScanTime = GetTime();
	return 1;
}

/*
	Name: shouldTacticalWalkScan
	Namespace: archetype_human_locomotion
	Checksum: 0x6E9EBED3
	Offset: 0x928
	Size: 0x12F
	Parameters: 1
	Flags: Private
*/
function private shouldTacticalWalkScan(entity)
{
	if(isdefined(entity.lastTacticalScanTime) && entity.lastTacticalScanTime + 2000 > GetTime())
	{
		return 0;
	}
	if(!entity HasPath())
	{
		return 0;
	}
	if(isdefined(entity.enemy))
	{
		return 0;
	}
	if(entity ShouldFaceMotion())
	{
		if(ai::HasAiAttribute(entity, "forceTacticalWalk") && !ai::GetAiAttribute(entity, "forceTacticalWalk"))
		{
			return 0;
		}
	}
	animation = entity AsmGetCurrentDeltaAnimation();
	if(isdefined(animation))
	{
		animtime = entity GetAnimTime(animation);
		return animtime <= 0.05;
	}
	return 0;
}

/*
	Name: continueTacticalWalkScan
	Namespace: archetype_human_locomotion
	Checksum: 0x724E8970
	Offset: 0xA60
	Size: 0x14F
	Parameters: 1
	Flags: Private
*/
function private continueTacticalWalkScan(entity)
{
	if(!entity HasPath())
	{
		return 0;
	}
	if(isdefined(entity.enemy))
	{
		return 0;
	}
	if(entity ShouldFaceMotion())
	{
		if(ai::HasAiAttribute(entity, "forceTacticalWalk") && !ai::GetAiAttribute(entity, "forceTacticalWalk"))
		{
			return 0;
		}
	}
	animation = entity AsmGetCurrentDeltaAnimation();
	if(isdefined(animation))
	{
		animlength = getanimlength(animation);
		animtime = entity GetAnimTime(animation) * animlength;
		normalizedTime = animtime + 0.2 / animlength;
		return normalizedTime < 1;
	}
	return 0;
}

/*
	Name: shouldTacticalWalkPain
	Namespace: archetype_human_locomotion
	Checksum: 0xAE808487
	Offset: 0xBB8
	Size: 0x75
	Parameters: 1
	Flags: Private
*/
function private shouldTacticalWalkPain(entity)
{
	if(!isdefined(entity.startPainTime) || entity.startPainTime + 3000 < GetTime() && RandomFloat(1) > 0.25)
	{
		return BSMLocomotionHasValidPainInterrupt(entity);
	}
	return 0;
}

/*
	Name: beginTacticalWalkPain
	Namespace: archetype_human_locomotion
	Checksum: 0x31754BAB
	Offset: 0xC38
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private beginTacticalWalkPain(entity)
{
	entity.startPainTime = GetTime();
	return 1;
}

/*
	Name: shouldContinueTacticalWalkPain
	Namespace: archetype_human_locomotion
	Checksum: 0xD50DB974
	Offset: 0xC60
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private shouldContinueTacticalWalkPain(entity)
{
	return entity.startPainTime + 100 >= GetTime();
}

/*
	Name: BSMLocomotionHasValidPainInterrupt
	Namespace: archetype_human_locomotion
	Checksum: 0xEF2852B0
	Offset: 0xC90
	Size: 0x29
	Parameters: 1
	Flags: Private
*/
function private BSMLocomotionHasValidPainInterrupt(entity)
{
	return entity HasValidInterrupt("pain");
}

/*
	Name: shouldArriveExposed
	Namespace: archetype_human_locomotion
	Checksum: 0xDC6BA5AC
	Offset: 0xCC8
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private shouldArriveExposed(behaviorTreeEntity)
{
	if(behaviorTreeEntity ai::get_behavior_attribute("disablearrivals"))
	{
		return 0;
	}
	if(behaviorTreeEntity HasPath())
	{
		if(isdefined(behaviorTreeEntity.node) && IsCoverNode(behaviorTreeEntity.node) && isdefined(behaviorTreeEntity.pathGoalPos) && DistanceSquared(behaviorTreeEntity.pathGoalPos, behaviorTreeEntity GetNodeOffsetPosition(behaviorTreeEntity.node)) < 8)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: prepareToStopNearEnemy
	Namespace: archetype_human_locomotion
	Checksum: 0x2AB3796A
	Offset: 0xDB0
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private prepareToStopNearEnemy(behaviorTreeEntity)
{
	behaviorTreeEntity clearPath();
	behaviorTreeEntity.keepClaimedNode = 1;
}

/*
	Name: prepareToMoveAwayFromNearByEnemy
	Namespace: archetype_human_locomotion
	Checksum: 0x4F1F9820
	Offset: 0xDF0
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private prepareToMoveAwayFromNearByEnemy(behaviorTreeEntity)
{
	behaviorTreeEntity clearPath();
	behaviorTreeEntity.keepClaimedNode = 1;
}

/*
	Name: shouldPlanArrivalIntoCover
	Namespace: archetype_human_locomotion
	Checksum: 0xD9D4D520
	Offset: 0xE30
	Size: 0x1B7
	Parameters: 1
	Flags: Private
*/
function private shouldPlanArrivalIntoCover(behaviorTreeEntity)
{
	goingToCoverNode = isdefined(behaviorTreeEntity.node) && IsCoverNode(behaviorTreeEntity.node);
	if(!goingToCoverNode)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.pathGoalPos))
	{
		if(isdefined(behaviorTreeEntity.arrivalfinalpos))
		{
			if(behaviorTreeEntity.arrivalfinalpos != behaviorTreeEntity.pathGoalPos)
			{
				return 1;
			}
			else if(behaviorTreeEntity.replannedCoverArrival === 0 && isdefined(behaviorTreeEntity.exitPos) && isdefined(behaviorTreeEntity.predictedExitPos))
			{
				behaviorTreeEntity.replannedCoverArrival = 1;
				exitDir = VectorNormalize(behaviorTreeEntity.predictedExitPos - behaviorTreeEntity.exitPos);
				currentDir = VectorNormalize(behaviorTreeEntity.origin - behaviorTreeEntity.exitPos);
				if(VectorDot(exitDir, currentDir) < cos(30))
				{
					behaviorTreeEntity.predictedArrivalDirectionValid = 0;
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: shouldSwitchToTacticalWalkFromRun
	Namespace: archetype_human_locomotion
	Checksum: 0xFE6A6802
	Offset: 0xFF0
	Size: 0x145
	Parameters: 1
	Flags: Private
*/
function private shouldSwitchToTacticalWalkFromRun(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(ai::HasAiAttribute(behaviorTreeEntity, "forceTacticalWalk") && ai::GetAiAttribute(behaviorTreeEntity, "forceTacticalWalk"))
	{
		return 1;
	}
	goalpos = undefined;
	if(isdefined(behaviorTreeEntity.arrivalfinalpos))
	{
		goalpos = behaviorTreeEntity.arrivalfinalpos;
	}
	else
	{
		goalpos = behaviorTreeEntity.pathGoalPos;
	}
	if(isdefined(behaviorTreeEntity.pathStartPos) && isdefined(goalpos))
	{
		pathDist = DistanceSquared(behaviorTreeEntity.pathStartPos, goalpos);
		if(pathDist < 250 * 250)
		{
			return 1;
		}
	}
	if(!behaviorTreeEntity ShouldFaceMotion())
	{
		return 1;
	}
	return 0;
}

/*
	Name: humanNonCombatLocomotionCondition
	Namespace: archetype_human_locomotion
	Checksum: 0x4F255D2F
	Offset: 0x1140
	Size: 0x8F
	Parameters: 1
	Flags: Private
*/
function private humanNonCombatLocomotionCondition(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.accurateFire) && behaviorTreeEntity.accurateFire)
	{
		return 1;
	}
	if(behaviorTreeEntity humanShouldSprint())
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
	Name: humanCombatLocomotionCondition
	Namespace: archetype_human_locomotion
	Checksum: 0xB2EB04DA
	Offset: 0x11D8
	Size: 0x8B
	Parameters: 1
	Flags: Private
*/
function private humanCombatLocomotionCondition(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.accurateFire) && behaviorTreeEntity.accurateFire)
	{
		return 0;
	}
	if(behaviorTreeEntity humanShouldSprint())
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
	Name: combatLocomotionStart
	Namespace: archetype_human_locomotion
	Checksum: 0xACDA02EF
	Offset: 0x1270
	Size: 0xC7
	Parameters: 1
	Flags: Private
*/
function private combatLocomotionStart(behaviorTreeEntity)
{
	randomChance = RandomInt(100);
	if(randomChance > 50)
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_run_n_gun_variation", "variation_forward");
		return 1;
	}
	if(randomChance > 25)
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_run_n_gun_variation", "variation_strafe_1");
		return 1;
	}
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_run_n_gun_variation", "variation_strafe_2");
	return 1;
}

/*
	Name: nonCombatLocomotionUpdate
	Namespace: archetype_human_locomotion
	Checksum: 0xB1B0623C
	Offset: 0x1340
	Size: 0xFD
	Parameters: 1
	Flags: Private
*/
function private nonCombatLocomotionUpdate(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.enemy) && (!isdefined(behaviorTreeEntity.accurateFire) && behaviorTreeEntity.accurateFire && !behaviorTreeEntity humanShouldSprint()))
	{
		return 0;
	}
	if(!behaviorTreeEntity ASMIsTransitionRunning())
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
		if(!isdefined(behaviorTreeEntity.replannedCoverArrival))
		{
			behaviorTreeEntity.replannedCoverArrival = 0;
		}
	}
	else
	{
		behaviorTreeEntity.replannedCoverArrival = undefined;
	}
	return 1;
}

/*
	Name: combatLocomotionUpdate
	Namespace: archetype_human_locomotion
	Checksum: 0x77C81A0A
	Offset: 0x1448
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private combatLocomotionUpdate(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(behaviorTreeEntity humanShouldSprint())
	{
		return 0;
	}
	if(!behaviorTreeEntity ASMIsTransitionRunning())
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
		if(!isdefined(behaviorTreeEntity.replannedCoverArrival))
		{
			behaviorTreeEntity.replannedCoverArrival = 0;
		}
	}
	else
	{
		behaviorTreeEntity.replannedCoverArrival = undefined;
	}
	if(isdefined(behaviorTreeEntity.enemy))
	{
		return 1;
	}
	return 0;
}

/*
	Name: prepareForMovement
	Namespace: archetype_human_locomotion
	Checksum: 0xDE44EABB
	Offset: 0x1530
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private prepareForMovement(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_stance", "stand");
	return 1;
}

/*
	Name: isArrivingFour
	Namespace: archetype_human_locomotion
	Checksum: 0x991C0B9C
	Offset: 0x1570
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isArrivingFour(arrivalAngle)
{
	if(arrivalAngle >= 45 && arrivalAngle <= 120)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isArrivingOne
	Namespace: archetype_human_locomotion
	Checksum: 0x562A9B33
	Offset: 0x15A8
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isArrivingOne(arrivalAngle)
{
	if(arrivalAngle >= 120 && arrivalAngle <= 165)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isArrivingTwo
	Namespace: archetype_human_locomotion
	Checksum: 0x77E6A1A3
	Offset: 0x15E0
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isArrivingTwo(arrivalAngle)
{
	if(arrivalAngle >= 165 && arrivalAngle <= 195)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isArrivingThree
	Namespace: archetype_human_locomotion
	Checksum: 0x11597442
	Offset: 0x1618
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isArrivingThree(arrivalAngle)
{
	if(arrivalAngle >= 195 && arrivalAngle <= 240)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isArrivingSix
	Namespace: archetype_human_locomotion
	Checksum: 0x2DA9B06C
	Offset: 0x1650
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isArrivingSix(arrivalAngle)
{
	if(arrivalAngle >= 240 && arrivalAngle <= 315)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFacingFour
	Namespace: archetype_human_locomotion
	Checksum: 0xDFA41AEA
	Offset: 0x1688
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isFacingFour(facingAngle)
{
	if(facingAngle >= 45 && facingAngle <= 135)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFacingEight
	Namespace: archetype_human_locomotion
	Checksum: 0x364207B9
	Offset: 0x16C0
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isFacingEight(facingAngle)
{
	if(facingAngle >= -45 && facingAngle <= 45)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFacingSeven
	Namespace: archetype_human_locomotion
	Checksum: 0xD3A84200
	Offset: 0x16F8
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private isFacingSeven(facingAngle)
{
	if(facingAngle >= 0 && facingAngle <= 90)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFacingSix
	Namespace: archetype_human_locomotion
	Checksum: 0x7E65C9CB
	Offset: 0x1730
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private isFacingSix(facingAngle)
{
	if(facingAngle >= -135 && facingAngle <= -45)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFacingNine
	Namespace: archetype_human_locomotion
	Checksum: 0x8FC3CFEB
	Offset: 0x1768
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private isFacingNine(facingAngle)
{
	if(facingAngle >= -90 && facingAngle <= 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldTacticalArriveCondition
	Namespace: archetype_human_locomotion
	Checksum: 0xC6224FEB
	Offset: 0x17A0
	Size: 0x3FF
	Parameters: 1
	Flags: Private
*/
function private shouldTacticalArriveCondition(behaviorTreeEntity)
{
	if(GetDvarInt("enableTacticalArrival") != 1)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.node))
	{
		return 0;
	}
	if(!behaviorTreeEntity.node.type == "Cover Left")
	{
		return 0;
	}
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_arrival_stance");
	if(stance != "stand")
	{
		return 0;
	}
	arrivalDistance = 35;
	/#
		arrivalDvar = GetDvarInt("Dev Block strings are not supported");
		if(arrivalDvar != 0)
		{
			arrivalDistance = arrivalDvar;
		}
	#/
	nodeOffsetPosition = behaviorTreeEntity GetNodeOffsetPosition(behaviorTreeEntity.node);
	if(Distance(nodeOffsetPosition, behaviorTreeEntity.origin) > arrivalDistance || Distance(nodeOffsetPosition, behaviorTreeEntity.origin) < 25)
	{
		return 0;
	}
	entityAngles = VectorToAngles(behaviorTreeEntity.origin - nodeOffsetPosition);
	if(Abs(behaviorTreeEntity.node.angles[1] - entityAngles[1]) < 60)
	{
		return 0;
	}
	tacticalFaceAngle = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_tactical_arrival_facing_yaw");
	arrivalAngle = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_locomotion_arrival_yaw");
	if(isArrivingFour(arrivalAngle))
	{
		if(!isFacingSix(tacticalFaceAngle) && !isFacingEight(tacticalFaceAngle) && !isFacingFour(tacticalFaceAngle))
		{
			return 0;
		}
	}
	else if(isArrivingOne(arrivalAngle))
	{
		if(!isFacingNine(tacticalFaceAngle) && !isFacingSeven(tacticalFaceAngle))
		{
			return 0;
		}
	}
	else if(isArrivingTwo(arrivalAngle))
	{
		if(!isFacingEight(tacticalFaceAngle))
		{
			return 0;
		}
	}
	else if(isArrivingThree(arrivalAngle))
	{
		if(!isFacingSeven(tacticalFaceAngle) && !isFacingNine(tacticalFaceAngle))
		{
			return 0;
		}
	}
	else if(isArrivingSix(arrivalAngle))
	{
		if(!isFacingFour(tacticalFaceAngle) && !isFacingEight(tacticalFaceAngle) && !isFacingSix(tacticalFaceAngle))
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}
	return 1;
}

/*
	Name: humanShouldSprint
	Namespace: archetype_human_locomotion
	Checksum: 0xA6B2A3B8
	Offset: 0x1BA8
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private humanShouldSprint()
{
	currentLocoMovementType = blackboard::GetBlackBoardAttribute(self, "_human_locomotion_movement_type");
	return currentLocoMovementType == "human_locomotion_movement_sprint";
}

/*
	Name: planHumanArrivalAtCover
	Namespace: archetype_human_locomotion
	Checksum: 0xB7B2B442
	Offset: 0x1BF0
	Size: 0x57B
	Parameters: 2
	Flags: Private
*/
function private planHumanArrivalAtCover(behaviorTreeEntity, arrivalAnim)
{
	if(behaviorTreeEntity ai::get_behavior_attribute("disablearrivals"))
	{
		return 0;
	}
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	if(!isdefined(arrivalAnim))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.node) && isdefined(behaviorTreeEntity.pathGoalPos))
	{
		if(!IsCoverNode(behaviorTreeEntity.node))
		{
			return 0;
		}
		nodeOffsetPosition = behaviorTreeEntity GetNodeOffsetPosition(behaviorTreeEntity.node);
		if(nodeOffsetPosition != behaviorTreeEntity.pathGoalPos)
		{
			return 0;
		}
		if(isdefined(arrivalAnim))
		{
			isRight = behaviorTreeEntity.node.type == "Cover Right";
			splitTime = GetArrivalSplitTime(arrivalAnim, isRight);
			isSplitArrival = splitTime < 1;
			nodeApproachYaw = behaviorTreeEntity GetNodeOffsetAngles(behaviorTreeEntity.node)[1];
			angle = (0, nodeApproachYaw - GetAngleDelta(arrivalAnim), 0);
			if(isSplitArrival)
			{
				forwardDir = AnglesToForward(angle);
				rightDir = AnglesToRight(angle);
				animlength = getanimlength(arrivalAnim);
				moveDelta = GetMoveDelta(arrivalAnim, 0, animlength - 0.2 / animlength);
				preMoveDelta = GetMoveDelta(arrivalAnim, 0, splitTime);
				postMoveDelta = moveDelta - preMoveDelta;
				FORWARD = VectorScale(forwardDir, postMoveDelta[0]);
				right = VectorScale(rightDir, postMoveDelta[1]);
				coverEnterPos = nodeOffsetPosition - FORWARD + right;
				postEnterPos = coverEnterPos;
				FORWARD = VectorScale(forwardDir, preMoveDelta[0]);
				right = VectorScale(rightDir, preMoveDelta[1]);
				coverEnterPos = coverEnterPos - FORWARD + right;
				/#
					recordLine(postEnterPos, nodeOffsetPosition, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity);
					recordLine(coverEnterPos, postEnterPos, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity);
				#/
				if(!behaviorTreeEntity MayMoveFromPointToPoint(postEnterPos, nodeOffsetPosition, 1, 0))
				{
					return 0;
				}
				if(!behaviorTreeEntity MayMoveFromPointToPoint(coverEnterPos, postEnterPos, 1, 0))
				{
					return 0;
				}
			}
			else
			{
				forwardDir = AnglesToForward(angle);
				rightDir = AnglesToRight(angle);
				moveDeltaArray = GetMoveDelta(arrivalAnim);
				FORWARD = VectorScale(forwardDir, moveDeltaArray[0]);
				right = VectorScale(rightDir, moveDeltaArray[1]);
				coverEnterPos = nodeOffsetPosition - FORWARD + right;
				if(!behaviorTreeEntity MayMoveFromPointToPoint(coverEnterPos, nodeOffsetPosition, 1, 1))
				{
					return 0;
				}
			}
			if(!checkCoverArrivalConditions(coverEnterPos, nodeOffsetPosition))
			{
				return 0;
			}
			if(IsPointOnNavMesh(coverEnterPos, behaviorTreeEntity))
			{
				/#
					RecordCircle(coverEnterPos, 2, (1, 0, 0), "Dev Block strings are not supported", behaviorTreeEntity);
				#/
				behaviorTreeEntity UsePosition(coverEnterPos, behaviorTreeEntity.pathGoalPos);
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: checkCoverArrivalConditions
	Namespace: archetype_human_locomotion
	Checksum: 0x686DF052
	Offset: 0x2178
	Size: 0x2DB
	Parameters: 2
	Flags: Private
*/
function private checkCoverArrivalConditions(coverEnterPos, coverPos)
{
	distSqToNode = DistanceSquared(self.origin, coverPos);
	distSqFromNodeToEnterPos = DistanceSquared(coverPos, coverEnterPos);
	awayFromEnterPos = distSqToNode >= distSqFromNodeToEnterPos + 150;
	if(!awayFromEnterPos)
	{
		return 0;
	}
	trace = GroundTrace(coverEnterPos + VectorScale((0, 0, 1), 72), coverEnterPos + VectorScale((0, 0, -1), 72), 0, 0, 0);
	if(isdefined(trace["position"]) && Abs(trace["position"][2] - coverPos[2]) > 30)
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				RecordCircle(coverEnterPos, 1, (1, 0, 0), "Dev Block strings are not supported");
				Record3DText("Dev Block strings are not supported", coverEnterPos, (1, 0, 0), "Dev Block strings are not supported", undefined, 0.4);
				RecordCircle(trace["Dev Block strings are not supported"], 1, (1, 0, 0), "Dev Block strings are not supported");
				Record3DText("Dev Block strings are not supported" + Int(Abs(trace["Dev Block strings are not supported"][2] - coverPos[2])), trace["Dev Block strings are not supported"] + VectorScale((0, 0, 1), 5), (1, 0, 0), "Dev Block strings are not supported", undefined, 0.4);
				Record3DText("Dev Block strings are not supported" + 30, trace["Dev Block strings are not supported"], (1, 0, 0), "Dev Block strings are not supported", undefined, 0.4);
				recordLine(coverEnterPos, trace["Dev Block strings are not supported"], (1, 0, 0), "Dev Block strings are not supported");
			}
		#/
		return 0;
	}
	return 1;
}

/*
	Name: GetArrivalSplitTime
	Namespace: archetype_human_locomotion
	Checksum: 0xE2BF33C2
	Offset: 0x2460
	Size: 0x2D5
	Parameters: 2
	Flags: Private
*/
function private GetArrivalSplitTime(arrivalAnim, isRight)
{
	if(!isdefined(level.animArrivalSplitTimes))
	{
		level.animArrivalSplitTimes = [];
	}
	if(isdefined(level.animArrivalSplitTimes[arrivalAnim]))
	{
		return level.animArrivalSplitTimes[arrivalAnim];
	}
	bestsplit = -1;
	if(animhasnotetrack(arrivalAnim, "cover_split"))
	{
		times = getnotetracktimes(arrivalAnim, "cover_split");
		/#
			Assert(times.size > 0);
		#/
		bestsplit = times[0];
		break;
	}
	animlength = getanimlength(arrivalAnim);
	normalizedLength = animlength - 0.2 / animlength;
	angleDelta = GetAngleDelta(arrivalAnim, 0, normalizedLength);
	fullDelta = GetMoveDelta(arrivalAnim, 0, normalizedLength);
	bestvalue = -100000000;
	for(i = 0; i < 100; i++)
	{
		splitTime = 1 * i / 100 - 1;
		delta = GetMoveDelta(arrivalAnim, 0, splitTime);
		delta = DeltaRotate(fullDelta - delta, 180 - angleDelta);
		if(isRight)
		{
			delta = (delta[0], 0 - delta[1], delta[2]);
		}
		VAL = min(delta[0] - 32, delta[1]);
		if(VAL > bestvalue || bestsplit < 0)
		{
			bestvalue = VAL;
			bestsplit = splitTime;
		}
	}
	level.animArrivalSplitTimes[arrivalAnim] = bestsplit;
	return bestsplit;
}

/*
	Name: DeltaRotate
	Namespace: archetype_human_locomotion
	Checksum: 0x2D89B03D
	Offset: 0x2740
	Size: 0x9B
	Parameters: 2
	Flags: Private
*/
function private DeltaRotate(delta, yaw)
{
	cosine = cos(yaw);
	sine = sin(yaw);
	return (delta[0] * cosine - delta[1] * sine, delta[1] * cosine + delta[0] * sine, 0);
}

