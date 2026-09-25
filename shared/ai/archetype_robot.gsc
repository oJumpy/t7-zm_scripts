#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_robot_interface;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\ai_squads;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_raps;

#namespace archetype_robot;

/*
	Name: __init__sytem__
	Namespace: archetype_robot
	Checksum: 0x21F84E4A
	Offset: 0x14B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("robot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: archetype_robot
	Checksum: 0x216DE72D
	Offset: 0x14F8
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	spawner::add_archetype_spawn_function("robot", &RobotSoldierBehavior::ArchetypeRobotBlackboardInit);
	spawner::add_archetype_spawn_function("robot", &RobotSoldierServerUtils::robotSoldierSpawnSetup);
	if(ai::shouldRegisterClientFieldForArchetype("robot"))
	{
		clientfield::register("actor", "robot_mind_control", 1, 2, "int");
		clientfield::register("actor", "robot_mind_control_explosion", 1, 1, "int");
		clientfield::register("actor", "robot_lights", 1, 3, "int");
		clientfield::register("actor", "robot_EMP", 1, 1, "int");
	}
	RobotInterface::RegisterRobotInterfaceAttributes();
	RobotSoldierBehavior::RegisterBehaviorScriptFunctions();
}

#namespace RobotSoldierBehavior;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: RobotSoldierBehavior
	Checksum: 0x55DED62F
	Offset: 0x1650
	Size: 0x105B
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotStepIntoAction", &stepIntoInitialize, undefined, &stepIntoTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotStepOutAction", &stepOutInitialize, undefined, &stepOutTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotTakeOverAction", &takeOverInitialize, undefined, &takeOverTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotEmpIdleAction", &robotEmpIdleInitialize, &robotEmpIdleUpdate, &robotEmpIdleTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotBecomeCrawler", &robotBecomeCrawler);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDropStartingWeapon", &robotDropStartingWeapon);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDontTakeCover", &robotDontTakeCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverOverInitialize", &robotCoverOverInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverOverTerminate", &robotCoverOverTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotExplode", &robotExplode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotExplodeTerminate", &robotExplodeTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDeployMiniRaps", &robotDeployMiniRaps);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotMoveToPlayer", &moveToPlayerUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotStartSprint", &robotStartSprint);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("robotStartSprint", &robotStartSprint);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotStartSuperSprint", &robotStartSuperSprint);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTacticalWalkActionStart", &robotTacticalWalkActionStart);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("robotTacticalWalkActionStart", &robotTacticalWalkActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDie", &robotDie);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCleanupChargeMeleeAttack", &robotCleanupChargeMeleeAttack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsMoving", &robotIsMoving);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotAbleToShoot", &robotAbleToShootCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCrawlerCanShootEnemy", &robotCrawlerCanShootEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canMoveToEnemy", &canMoveToEnemyCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canMoveCloseToEnemy", &canMoveCloseToEnemyCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasMiniRaps", &hasMiniRaps);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsAtCover", &robotIsAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldTacticalWalk", &robotShouldTacticalWalk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotHasCloseEnemyToMelee", &robotHasCloseEnemyToMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotHasEnemyToMelee", &robotHasEnemyToMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRogueHasCloseEnemyToMelee", &robotRogueHasCloseEnemyToMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRogueHasEnemyToMelee", &robotRogueHasEnemyToMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsCrawler", &robotIsCrawler);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsMarching", &robotIsMarching);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotPrepareForAdjustToCover", &robotPrepareForAdjustToCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldAdjustToCover", &robotShouldAdjustToCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldBecomeCrawler", &robotShouldBecomeCrawler);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldReactAtCover", &robotShouldReactAtCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldExplode", &robotShouldExplode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldShutdown", &robotShouldShutdown);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotSupportsOverCover", &robotSupportsOverCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStepIn", &shouldStepInCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldTakeOver", &shouldTakeOverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsStepOut", &supportsStepOutCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setDesiredStanceToStand", &setDesiredStanceToStand);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setDesiredStanceToCrouch", &setDesiredStanceToCrouch);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("toggleDesiredStance", &toggleDesiredStance);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotMovement", &robotMovement);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDelayMovement", &robotDelayMovement);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotInvalidateCover", &robotInvalidateCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldChargeMelee", &robotShouldChargeMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldMelee", &robotShouldMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotScriptRequiresToSprint", &scriptRequiresToSprintCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotScanExposedPainTerminate", &robotScanExposedPainTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTookEmpDamage", &robotTookEmpDamage);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotNoCloseEnemyService", &robotNoCloseEnemyService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWithinSprintRange", &robotWithinSprintRange);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWithinSuperSprintRange", &robotWithinSuperSprintRange);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("robotWithinSuperSprintRange", &robotWithinSuperSprintRange);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotOutsideTacticalWalkRange", &robotOutsideTacticalWalkRange);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotOutsideSprintRange", &robotOutsideSprintRange);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotOutsideSuperSprintRange", &robotOutsideSuperSprintRange);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("robotOutsideSuperSprintRange", &robotOutsideSuperSprintRange);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotLightsOff", &robotLightsOff);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotLightsFlicker", &robotLightsFlicker);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotLightsOn", &robotLightsOn);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldGibDeath", &robotShouldGibDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotProceduralTraversal", &robotTraverseStart, &robotProceduralTraversalUpdate, &robotTraverseRagdollOnDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCalcProceduralTraversal", &robotCalcProceduralTraversal);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotProceduralLanding", &robotProceduralLandingUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTraverseEnd", &robotTraverseEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTraverseRagdollOnDeath", &robotTraverseRagdollOnDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldProceduralTraverse", &robotShouldProceduralTraverse);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWallrunTraverse", &robotWallrunTraverse);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldWallrun", &robotShouldWallrun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotSetupWallRunJump", &robotSetupWallRunJump);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotSetupWallRunLand", &robotSetupWallRunLand);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWallrunStart", &robotWallrunStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWallrunEnd", &robotWallrunEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCanJuke", &robotCanJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCanTacticalJuke", &robotCanTacticalJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCanPreemptiveJuke", &robotCanPreemptiveJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotJukeInitialize", &robotJukeInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotPreemptiveJukeTerminate", &robotPreemptiveJukeTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverScanInitialize", &robotCoverScanInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverScanTerminate", &robotCoverScanTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsAtCoverModeScan", &robotIsAtCoverModeScan);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotExposedCoverService", &robotExposedCoverService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotPositionService", &robotPositionService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTargetService", &robotTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTryReacquireService", &robotTryReacquireService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRushEnemyService", &robotRushEnemyService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRushNeighborService", &robotRushNeighborService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCrawlerService", &robotCrawlerService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotMoveToPlayerService", &moveToPlayerUpdate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_ignore_pain_face_enemy", &mocompIgnorePainFaceEnemyInit, &mocompIgnorePainFaceEnemyUpdate, &mocompIgnorePainFaceEnemyTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("robot_procedural_traversal", &mocompRobotProceduralTraversalInit, &mocompRobotProceduralTraversalUpdate, &mocompRobotProceduralTraversalTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("robot_start_traversal", &mocompRobotStartTraversalInit, undefined, &mocompRobotStartTraversalTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("robot_start_wallrun", &mocompRobotStartWallrunInit, &mocompRobotStartWallrunUpdate, &mocompRobotStartWallrunTerminate);
}

/*
	Name: robotCleanupChargeMeleeAttack
	Namespace: RobotSoldierBehavior
	Checksum: 0x3F5A3671
	Offset: 0x26B8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function robotCleanupChargeMeleeAttack(behaviorTreeEntity)
{
	AiUtility::meleeReleaseMutex(behaviorTreeEntity);
	AiUtility::releaseClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_melee_enemy_type", undefined);
}

/*
	Name: robotLightsOff
	Namespace: RobotSoldierBehavior
	Checksum: 0x2FDF2C1D
	Offset: 0x2720
	Size: 0x57
	Parameters: 2
	Flags: Private
*/
function private robotLightsOff(entity, asmStateName)
{
	entity ai::set_behavior_attribute("robot_lights", 2);
	clientfield::set("robot_EMP", 1);
	return 4;
}

/*
	Name: robotLightsFlicker
	Namespace: RobotSoldierBehavior
	Checksum: 0x9A9989AF
	Offset: 0x2780
	Size: 0x67
	Parameters: 2
	Flags: Private
*/
function private robotLightsFlicker(entity, asmStateName)
{
	entity ai::set_behavior_attribute("robot_lights", 1);
	clientfield::set("robot_EMP", 1);
	entity notify("emp_fx_start");
	return 4;
}

/*
	Name: robotLightsOn
	Namespace: RobotSoldierBehavior
	Checksum: 0xA13D03C4
	Offset: 0x27F0
	Size: 0x4F
	Parameters: 2
	Flags: Private
*/
function private robotLightsOn(entity, asmStateName)
{
	entity ai::set_behavior_attribute("robot_lights", 0);
	clientfield::set("robot_EMP", 0);
	return 4;
}

/*
	Name: robotShouldGibDeath
	Namespace: RobotSoldierBehavior
	Checksum: 0x3BF60785
	Offset: 0x2848
	Size: 0x21
	Parameters: 2
	Flags: Private
*/
function private robotShouldGibDeath(entity, asmStateName)
{
	return entity.gibDeath;
}

/*
	Name: robotEmpIdleInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0xAA4FA4C6
	Offset: 0x2878
	Size: 0x5F
	Parameters: 2
	Flags: Private
*/
function private robotEmpIdleInitialize(entity, asmStateName)
{
	entity.empStopTime = GetTime() + entity.empShutdownTime;
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	entity notify("emp_shutdown_start");
	return 5;
}

/*
	Name: robotEmpIdleUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0x4F438208
	Offset: 0x28E0
	Size: 0x8D
	Parameters: 2
	Flags: Private
*/
function private robotEmpIdleUpdate(entity, asmStateName)
{
	if(GetTime() < entity.empStopTime || entity ai::get_behavior_attribute("shutdown"))
	{
		if(entity ASMGetStatus() == "asm_status_complete")
		{
			AnimationStateNetworkUtility::RequestState(entity, asmStateName);
		}
		return 5;
	}
	return 4;
}

/*
	Name: robotEmpIdleTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0xED902163
	Offset: 0x2978
	Size: 0x27
	Parameters: 2
	Flags: Private
*/
function private robotEmpIdleTerminate(entity, asmStateName)
{
	entity notify("emp_shutdown_end");
	return 4;
}

/*
	Name: robotProceduralTraversalUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0x5C7F5B2A
	Offset: 0x29A8
	Size: 0xFD
	Parameters: 2
	Flags: None
*/
function robotProceduralTraversalUpdate(entity, asmStateName)
{
	/#
		Assert(isdefined(entity.traversal));
	#/
	traversal = entity.traversal;
	t = min(GetTime() - traversal.startTime / traversal.totalTime, 1);
	curveRemaining = traversal.curveLength * 1 - t;
	if(curveRemaining < traversal.landingDistance)
	{
		traversal.landing = 1;
		return 4;
	}
	return 5;
}

/*
	Name: robotProceduralLandingUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0xF272CFCD
	Offset: 0x2AB0
	Size: 0x3F
	Parameters: 2
	Flags: None
*/
function robotProceduralLandingUpdate(entity, asmStateName)
{
	if(isdefined(entity.traversal))
	{
		entity finishtraversal();
	}
	return 5;
}

/*
	Name: robotCalcProceduralTraversal
	Namespace: RobotSoldierBehavior
	Checksum: 0x26170401
	Offset: 0x2AF8
	Size: 0xB57
	Parameters: 2
	Flags: None
*/
function robotCalcProceduralTraversal(entity, asmStateName)
{
	if(!isdefined(entity.traverseStartNode) || !isdefined(entity.traverseEndNode))
	{
		return 1;
	}
	entity.traversal = spawnstruct();
	traversal = entity.traversal;
	traversal.landingDistance = 24;
	traversal.minimumSpeed = 18;
	traversal.startnode = entity.traverseStartNode;
	traversal.endNode = entity.traverseEndNode;
	startIsWallrun = traversal.startnode.SPAWNFLAGS & 2048;
	endIsWallrun = traversal.endNode.SPAWNFLAGS & 2048;
	traversal.startPoint1 = entity.origin;
	traversal.endPoint1 = traversal.endNode.origin;
	if(endIsWallrun)
	{
		faceNormal = GetNavMeshFaceNormal(traversal.endPoint1, 30);
		traversal.endPoint1 = traversal.endPoint1 + faceNormal * 30 / 2;
	}
	if(!isdefined(traversal.endPoint1))
	{
		traversal.endPoint1 = traversal.endNode.origin;
	}
	traversal.distanceToEnd = Distance(traversal.startPoint1, traversal.endPoint1);
	traversal.absHeightToEnd = Abs(traversal.startPoint1[2] - traversal.endPoint1[2]);
	traversal.absLengthToEnd = Distance2D(traversal.startPoint1, traversal.endPoint1);
	speedBoost = 0;
	if(traversal.absLengthToEnd > 200)
	{
		speedBoost = 16;
	}
	else if(traversal.absLengthToEnd > 120)
	{
		speedBoost = 8;
	}
	else if(traversal.absLengthToEnd > 80 || traversal.absHeightToEnd > 80)
	{
		speedBoost = 4;
	}
	if(isdefined(entity.traversalSpeedBoost))
	{
		speedBoost = entity [[entity.traversalSpeedBoost]]();
	}
	traversal.speedOnCurve = traversal.minimumSpeed + speedBoost * 12;
	heightOffset = max(traversal.absHeightToEnd * 0.8, min(traversal.absLengthToEnd, 96));
	traversal.startPoint2 = entity.origin + (0, 0, heightOffset);
	traversal.endPoint2 = traversal.endPoint1 + (0, 0, heightOffset);
	if(traversal.startPoint1[2] < traversal.endPoint1[2])
	{
		traversal.startPoint2 = traversal.startPoint2 + (0, 0, traversal.absHeightToEnd);
	}
	else
	{
		traversal.endPoint2 = traversal.endPoint2 + (0, 0, traversal.absHeightToEnd);
	}
	if(startIsWallrun || endIsWallrun)
	{
		startDirection = robotStartJumpDirection();
		endDirection = robotEndJumpDirection();
		if(startDirection == "out")
		{
			point2Scale = 0.5;
			towardEnd = traversal.endNode.origin - entity.origin * point2Scale;
			traversal.startPoint2 = entity.origin + (towardEnd[0], towardEnd[1], 0);
			traversal.endPoint2 = traversal.endPoint1 + (0, 0, traversal.absHeightToEnd * point2Scale);
			traversal.angles = entity.angles;
		}
		if(endDirection == "in")
		{
			point2Scale = 0.5;
			towardStart = entity.origin - traversal.endNode.origin * point2Scale;
			traversal.startPoint2 = entity.origin + (0, 0, traversal.absHeightToEnd * point2Scale);
			traversal.endPoint2 = traversal.endNode.origin + (towardStart[0], towardStart[1], 0);
			faceNormal = GetNavMeshFaceNormal(traversal.endNode.origin, 30);
			direction = _CalculateWallrunDirection(traversal.startnode.origin, traversal.endNode.origin);
			moveDirection = VectorCross(faceNormal, (0, 0, 1));
			if(direction == "right")
			{
				moveDirection = moveDirection * -1;
			}
			traversal.angles = VectorToAngles(moveDirection);
		}
		if(endIsWallrun)
		{
			traversal.landingDistance = 110;
		}
		else
		{
			traversal.landingDistance = 60;
		}
		traversal.speedOnCurve = traversal.speedOnCurve * 1.2;
	}
	/#
		recordLine(traversal.startPoint1, traversal.startPoint2, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		recordLine(traversal.startPoint1, traversal.endPoint1, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		recordLine(traversal.endPoint1, traversal.endPoint2, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		recordLine(traversal.startPoint2, traversal.endPoint2, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		Record3DText(traversal.absLengthToEnd, traversal.endPoint1 + VectorScale((0, 0, 1), 12), (1, 0.5, 0), "Dev Block strings are not supported", entity);
	#/
	segments = 10;
	previousPoint = traversal.startPoint1;
	traversal.curveLength = 0;
	for(index = 1; index <= segments; index++)
	{
		t = index / segments;
		nextPoint = CalculateCubicBezier(t, traversal.startPoint1, traversal.startPoint2, traversal.endPoint2, traversal.endPoint1);
		/#
			recordLine(previousPoint, nextPoint, (0, 1, 0), "Dev Block strings are not supported", entity);
		#/
		traversal.curveLength = traversal.curveLength + Distance(previousPoint, nextPoint);
		previousPoint = nextPoint;
	}
	traversal.startTime = GetTime();
	traversal.endTime = traversal.startTime + traversal.curveLength * 1000 / traversal.speedOnCurve;
	traversal.totalTime = traversal.endTime - traversal.startTime;
	traversal.landing = 0;
	return 1;
}

/*
	Name: robotTraverseStart
	Namespace: RobotSoldierBehavior
	Checksum: 0x87FB7673
	Offset: 0x3658
	Size: 0xDF
	Parameters: 2
	Flags: None
*/
function robotTraverseStart(entity, asmStateName)
{
	entity.skipdeath = 1;
	traversal = entity.traversal;
	traversal.startTime = GetTime();
	traversal.endTime = traversal.startTime + traversal.curveLength * 1000 / traversal.speedOnCurve;
	traversal.totalTime = traversal.endTime - traversal.startTime;
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: robotTraverseEnd
	Namespace: RobotSoldierBehavior
	Checksum: 0xC3C5FF11
	Offset: 0x3740
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function robotTraverseEnd(entity)
{
	robotTraverseRagdollOnDeath(entity);
	entity.skipdeath = 0;
	entity.traversal = undefined;
	entity notify("traverse_end");
	return 4;
}

/*
	Name: robotTraverseRagdollOnDeath
	Namespace: RobotSoldierBehavior
	Checksum: 0x8908868A
	Offset: 0x37A0
	Size: 0x47
	Parameters: 2
	Flags: Private
*/
function private robotTraverseRagdollOnDeath(entity, asmStateName)
{
	if(!isalive(entity))
	{
		entity StartRagdoll();
	}
	return 4;
}

/*
	Name: robotShouldProceduralTraverse
	Namespace: RobotSoldierBehavior
	Checksum: 0xA809D124
	Offset: 0x37F0
	Size: 0xB1
	Parameters: 1
	Flags: Private
*/
function private robotShouldProceduralTraverse(entity)
{
	if(isdefined(entity.traverseStartNode) && isdefined(entity.traverseEndNode))
	{
		isProcedural = entity ai::get_behavior_attribute("traversals") == "procedural" || entity.traverseStartNode.SPAWNFLAGS & 1024 || entity.traverseEndNode.SPAWNFLAGS & 1024;
		return isProcedural;
	}
	return 0;
}

/*
	Name: robotWallrunTraverse
	Namespace: RobotSoldierBehavior
	Checksum: 0xA2C18BFB
	Offset: 0x38B0
	Size: 0xBD
	Parameters: 1
	Flags: Private
*/
function private robotWallrunTraverse(entity)
{
	startnode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	if(isdefined(startnode) && isdefined(endNode) && entity ShouldStartTraversal())
	{
		startIsWallrun = startnode.SPAWNFLAGS & 2048;
		endIsWallrun = endNode.SPAWNFLAGS & 2048;
		return startIsWallrun || endIsWallrun;
	}
	return 0;
}

/*
	Name: robotShouldWallrun
	Namespace: RobotSoldierBehavior
	Checksum: 0x732BD2E0
	Offset: 0x3978
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private robotShouldWallrun(entity)
{
	return blackboard::GetBlackBoardAttribute(entity, "_robot_traversal_type") == "wall";
}

/*
	Name: mocompRobotStartWallrunInit
	Namespace: RobotSoldierBehavior
	Checksum: 0xA457A717
	Offset: 0x39B8
	Size: 0xD3
	Parameters: 5
	Flags: Private
*/
function private mocompRobotStartWallrunInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity SetRepairPaths(0);
	entity OrientMode("face angle", entity.angles[1]);
	entity.blockingPain = 1;
	entity.clampToNavMesh = 0;
	entity animMode("normal_nogravity", 0);
	entity SetAvoidanceMask("avoid none");
}

/*
	Name: mocompRobotStartWallrunUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0x5E42EA20
	Offset: 0x3A98
	Size: 0x1F3
	Parameters: 5
	Flags: Private
*/
function private mocompRobotStartWallrunUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	faceNormal = GetNavMeshFaceNormal(entity.origin, 30);
	positionOnWall = GetClosestPointOnNavMesh(entity.origin, 30, 0);
	direction = blackboard::GetBlackBoardAttribute(entity, "_robot_wallrun_direction");
	if(isdefined(faceNormal) && isdefined(positionOnWall))
	{
		faceNormal = (faceNormal[0], faceNormal[1], 0);
		faceNormal = VectorNormalize(faceNormal);
		moveDirection = VectorCross(faceNormal, (0, 0, 1));
		if(direction == "right")
		{
			moveDirection = moveDirection * -1;
		}
		forwardPositionOnWall = GetClosestPointOnNavMesh(positionOnWall + moveDirection * 12, 30, 0);
		anglesToEnd = VectorToAngles(forwardPositionOnWall - positionOnWall);
		/#
			recordLine(positionOnWall, forwardPositionOnWall, (1, 0, 0), "Dev Block strings are not supported", entity);
		#/
		entity OrientMode("face angle", anglesToEnd[1]);
	}
}

/*
	Name: mocompRobotStartWallrunTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x4E48D9BD
	Offset: 0x3C98
	Size: 0x87
	Parameters: 5
	Flags: Private
*/
function private mocompRobotStartWallrunTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity SetRepairPaths(1);
	entity SetAvoidanceMask("avoid all");
	entity.blockingPain = 0;
	entity.clampToNavMesh = 1;
}

/*
	Name: CalculateCubicBezier
	Namespace: RobotSoldierBehavior
	Checksum: 0x14CABEDE
	Offset: 0x3D28
	Size: 0xD1
	Parameters: 5
	Flags: Private
*/
function private CalculateCubicBezier(t, p1, p2, p3, p4)
{
	return pow(1 - t, 3) * p1 + 3 * pow(1 - t, 2) * t * p2 + 3 * 1 - t * pow(t, 2) * p3 + pow(t, 3) * p4;
}

/*
	Name: mocompRobotStartTraversalInit
	Namespace: RobotSoldierBehavior
	Checksum: 0xBEB34710
	Offset: 0x3E08
	Size: 0x393
	Parameters: 5
	Flags: Private
*/
function private mocompRobotStartTraversalInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	startnode = entity.traverseStartNode;
	startIsWallrun = startnode.SPAWNFLAGS & 2048;
	endNode = entity.traverseEndNode;
	endIsWallrun = endNode.SPAWNFLAGS & 2048;
	if(!endIsWallrun)
	{
		angleToEnd = VectorToAngles(entity.traverseEndNode.origin - entity.traverseStartNode.origin);
		entity OrientMode("face angle", angleToEnd[1]);
		if(startIsWallrun)
		{
			entity animMode("normal_nogravity", 0);
		}
		else
		{
			entity animMode("gravity", 0);
		}
	}
	else
	{
		faceNormal = GetNavMeshFaceNormal(endNode.origin, 30);
		direction = _CalculateWallrunDirection(startnode.origin, endNode.origin);
		moveDirection = VectorCross(faceNormal, (0, 0, 1));
		if(direction == "right")
		{
			moveDirection = moveDirection * -1;
		}
		/#
			recordLine(endNode.origin, endNode.origin + faceNormal * 20, (1, 0, 0), "Dev Block strings are not supported", entity);
		#/
		/#
			recordLine(endNode.origin, endNode.origin + moveDirection * 20, (1, 0, 0), "Dev Block strings are not supported", entity);
		#/
		angles = VectorToAngles(moveDirection);
		entity OrientMode("face angle", angles[1]);
		if(startIsWallrun)
		{
			entity animMode("normal_nogravity", 0);
		}
		else
		{
			entity animMode("gravity", 0);
		}
	}
	entity SetRepairPaths(0);
	entity.blockingPain = 1;
	entity.clampToNavMesh = 0;
	entity PathMode("dont move");
}

/*
	Name: mocompRobotStartTraversalTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0xAE69CDB5
	Offset: 0x41A8
	Size: 0x2B
	Parameters: 5
	Flags: Private
*/
function private mocompRobotStartTraversalTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
}

/*
	Name: mocompRobotProceduralTraversalInit
	Namespace: RobotSoldierBehavior
	Checksum: 0x55C2AF72
	Offset: 0x41E0
	Size: 0x12B
	Parameters: 5
	Flags: Private
*/
function private mocompRobotProceduralTraversalInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	traversal = entity.traversal;
	entity SetAvoidanceMask("avoid none");
	entity OrientMode("face angle", entity.angles[1]);
	entity SetRepairPaths(0);
	entity animMode("noclip", 0);
	entity.blockingPain = 1;
	entity.clampToNavMesh = 0;
	if(isdefined(traversal) && traversal.landing)
	{
		entity animMode("angle deltas", 0);
	}
}

/*
	Name: mocompRobotProceduralTraversalUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0x52E22152
	Offset: 0x4318
	Size: 0x21B
	Parameters: 5
	Flags: Private
*/
function private mocompRobotProceduralTraversalUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	traversal = entity.traversal;
	if(isdefined(traversal))
	{
		if(entity IsPaused())
		{
			traversal.startTime = traversal.startTime + 50;
			return;
		}
		endIsWallrun = traversal.endNode.SPAWNFLAGS & 2048;
		realT = GetTime() - traversal.startTime / traversal.totalTime;
		t = min(realT, 1);
		if(t < 1 || realT == 1 || !endIsWallrun)
		{
			currentPos = CalculateCubicBezier(t, traversal.startPoint1, traversal.startPoint2, traversal.endPoint2, traversal.endPoint1);
			angles = entity.angles;
			if(isdefined(traversal.angles))
			{
				angles = traversal.angles;
			}
			entity ForceTeleport(currentPos, angles, 0);
		}
		else
		{
			entity animMode("normal_nogravity", 0);
		}
	}
}

/*
	Name: mocompRobotProceduralTraversalTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x715B485C
	Offset: 0x4540
	Size: 0x113
	Parameters: 5
	Flags: Private
*/
function private mocompRobotProceduralTraversalTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	traversal = entity.traversal;
	if(isdefined(traversal) && GetTime() >= traversal.endTime)
	{
		endIsWallrun = traversal.endNode.SPAWNFLAGS & 2048;
		if(!endIsWallrun)
		{
			entity PathMode("move allowed");
		}
	}
	entity.clampToNavMesh = 1;
	entity.blockingPain = 0;
	entity SetRepairPaths(1);
	entity SetAvoidanceMask("avoid all");
}

/*
	Name: mocompIgnorePainFaceEnemyInit
	Namespace: RobotSoldierBehavior
	Checksum: 0xC6F197CF
	Offset: 0x4660
	Size: 0xC3
	Parameters: 5
	Flags: Private
*/
function private mocompIgnorePainFaceEnemyInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 1;
	if(isdefined(entity.enemy))
	{
		entity OrientMode("face enemy");
	}
	else
	{
		entity OrientMode("face angle", entity.angles[1]);
	}
	entity animMode("pos deltas");
}

/*
	Name: mocompIgnorePainFaceEnemyUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0x537BA79B
	Offset: 0x4730
	Size: 0xB3
	Parameters: 5
	Flags: Private
*/
function private mocompIgnorePainFaceEnemyUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(isdefined(entity.enemy) && entity GetAnimTime(mocompAnim) < 0.5)
	{
		entity OrientMode("face enemy");
	}
	else
	{
		entity OrientMode("face angle", entity.angles[1]);
	}
}

/*
	Name: mocompIgnorePainFaceEnemyTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x3DC4535E
	Offset: 0x47F0
	Size: 0x3B
	Parameters: 5
	Flags: Private
*/
function private mocompIgnorePainFaceEnemyTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 0;
}

/*
	Name: _CalculateWallrunDirection
	Namespace: RobotSoldierBehavior
	Checksum: 0xDE67D908
	Offset: 0x4838
	Size: 0x185
	Parameters: 2
	Flags: Private
*/
function private _CalculateWallrunDirection(startPosition, endPosition)
{
	entity = self;
	faceNormal = GetNavMeshFaceNormal(endPosition, 30);
	/#
		recordLine(startPosition, endPosition, (1, 0.5, 0), "Dev Block strings are not supported", entity);
	#/
	if(isdefined(faceNormal))
	{
		/#
			recordLine(endPosition, endPosition + faceNormal * 12, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		#/
		angles = VectorToAngles(faceNormal);
		right = AnglesToRight(angles);
		d = VectorDot(right, endPosition) * -1;
		if(VectorDot(right, startPosition) + d > 0)
		{
			return "right";
		}
		return "left";
	}
	return "unknown";
}

/*
	Name: robotWallrunStart
	Namespace: RobotSoldierBehavior
	Checksum: 0x996B3036
	Offset: 0x49C8
	Size: 0x6B
	Parameters: 0
	Flags: Private
*/
function private robotWallrunStart()
{
	entity = self;
	entity.skipdeath = 1;
	entity PushActors(0);
	entity PushPlayer(1);
	entity.pushable = 0;
}

/*
	Name: robotWallrunEnd
	Namespace: RobotSoldierBehavior
	Checksum: 0xBE61E437
	Offset: 0x4A40
	Size: 0x7F
	Parameters: 0
	Flags: Private
*/
function private robotWallrunEnd()
{
	entity = self;
	robotTraverseRagdollOnDeath(entity);
	entity.skipdeath = 0;
	entity PushActors(1);
	entity PushPlayer(0);
	entity.pushable = 1;
}

/*
	Name: robotSetupWallRunJump
	Namespace: RobotSoldierBehavior
	Checksum: 0x429C844
	Offset: 0x4AC8
	Size: 0x21F
	Parameters: 0
	Flags: Private
*/
function private robotSetupWallRunJump()
{
	entity = self;
	startnode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	direction = "unknown";
	jumpDirection = "unknown";
	traversalType = "unknown";
	if(isdefined(startnode) && isdefined(endNode))
	{
		startIsWallrun = startnode.SPAWNFLAGS & 2048;
		endIsWallrun = endNode.SPAWNFLAGS & 2048;
		if(endIsWallrun)
		{
			direction = _CalculateWallrunDirection(startnode.origin, endNode.origin);
		}
		else
		{
			direction = _CalculateWallrunDirection(endNode.origin, startnode.origin);
			if(direction == "right")
			{
				direction = "left";
			}
			else
			{
				direction = "right";
			}
		}
		jumpDirection = robotStartJumpDirection();
		traversalType = robotTraversalType(startnode);
	}
	blackboard::SetBlackBoardAttribute(entity, "_robot_jump_direction", jumpDirection);
	blackboard::SetBlackBoardAttribute(entity, "_robot_wallrun_direction", direction);
	blackboard::SetBlackBoardAttribute(entity, "_robot_traversal_type", traversalType);
	robotCalcProceduralTraversal(entity, undefined);
	return 5;
}

/*
	Name: robotSetupWallRunLand
	Namespace: RobotSoldierBehavior
	Checksum: 0x1C65B6C6
	Offset: 0x4CF0
	Size: 0xFF
	Parameters: 0
	Flags: Private
*/
function private robotSetupWallRunLand()
{
	entity = self;
	startnode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	landDirection = "unknown";
	traversalType = "unknown";
	if(isdefined(startnode) && isdefined(endNode))
	{
		landDirection = robotEndJumpDirection();
		traversalType = robotTraversalType(endNode);
	}
	blackboard::SetBlackBoardAttribute(entity, "_robot_jump_direction", landDirection);
	blackboard::SetBlackBoardAttribute(entity, "_robot_traversal_type", traversalType);
	return 5;
}

/*
	Name: robotStartJumpDirection
	Namespace: RobotSoldierBehavior
	Checksum: 0x7340AAE4
	Offset: 0x4DF8
	Size: 0x139
	Parameters: 0
	Flags: Private
*/
function private robotStartJumpDirection()
{
	entity = self;
	startnode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	if(isdefined(startnode) && isdefined(endNode))
	{
		startIsWallrun = startnode.SPAWNFLAGS & 2048;
		endIsWallrun = endNode.SPAWNFLAGS & 2048;
		if(startIsWallrun)
		{
			absLengthToEnd = Distance2D(startnode.origin, endNode.origin);
			if(startnode.origin[2] - endNode.origin[2] > 48 && absLengthToEnd < 250)
			{
				return "out";
			}
		}
		return "up";
	}
	return "unknown";
}

/*
	Name: robotEndJumpDirection
	Namespace: RobotSoldierBehavior
	Checksum: 0x64AC1EE3
	Offset: 0x4F40
	Size: 0x139
	Parameters: 0
	Flags: Private
*/
function private robotEndJumpDirection()
{
	entity = self;
	startnode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	if(isdefined(startnode) && isdefined(endNode))
	{
		startIsWallrun = startnode.SPAWNFLAGS & 2048;
		endIsWallrun = endNode.SPAWNFLAGS & 2048;
		if(endIsWallrun)
		{
			absLengthToEnd = Distance2D(startnode.origin, endNode.origin);
			if(endNode.origin[2] - startnode.origin[2] > 48 && absLengthToEnd < 250)
			{
				return "in";
			}
		}
		return "down";
	}
	return "unknown";
}

/*
	Name: robotTraversalType
	Namespace: RobotSoldierBehavior
	Checksum: 0xAAC419B3
	Offset: 0x5088
	Size: 0x41
	Parameters: 1
	Flags: Private
*/
function private robotTraversalType(node)
{
	if(isdefined(node))
	{
		if(node.SPAWNFLAGS & 2048)
		{
			return "wall";
		}
		return "ground";
	}
	return "unknown";
}

/*
	Name: ArchetypeRobotBlackboardInit
	Namespace: RobotSoldierBehavior
	Checksum: 0x3F77DBFD
	Offset: 0x50D8
	Size: 0x453
	Parameters: 0
	Flags: Private
*/
function private ArchetypeRobotBlackboardInit()
{
	entity = self;
	blackboard::CreateBlackBoardForEntity(entity);
	ai::CreateInterfaceForEntity(entity);
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_sprint", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_mind_control", "normal", &robotIsMindControlled);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_move_mode", "normal", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_gibbed_limbs", undefined, &robotGetGibbedLimbs);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_robot_jump_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_robot_locomotion_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_robot_traversal_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_robot_wallrun_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_robot_mode", "normal", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	entity.___ArchetypeOnAnimscriptedCallback = &ArchetypeRobotOnAnimScriptedCallback;
	/#
		entity function_89398c57();
	#/
	if(SessionModeIsCampaignGame() || SessionModeIsZombiesGame())
	{
		self thread gameskill::accuracy_buildup_before_fire(self);
	}
	if(self.accurateFire)
	{
		self thread AiUtility::preShootLaserAndGlintOn(self);
		self thread AiUtility::postShootLaserAndGlintOff(self);
	}
}

/*
	Name: robotCrawlerCanShootEnemy
	Namespace: RobotSoldierBehavior
	Checksum: 0x88FD0AD2
	Offset: 0x5538
	Size: 0x117
	Parameters: 1
	Flags: Private
*/
function private robotCrawlerCanShootEnemy(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	aimLimits = entity GetAimLimitsFromEntry("robot_crawler");
	yawToEnemy = AngleClamp180(VectorToAngles(entity lastKnownPos(entity.enemy) - entity.origin)[1] - entity.angles[1]);
	angleEpsilon = 10;
	return yawToEnemy <= aimLimits["aim_left"] + angleEpsilon && yawToEnemy >= aimLimits["aim_right"] + angleEpsilon;
}

/*
	Name: ArchetypeRobotOnAnimScriptedCallback
	Namespace: RobotSoldierBehavior
	Checksum: 0xD8FE3E94
	Offset: 0x5658
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeRobotOnAnimScriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeRobotBlackboardInit();
}

/*
	Name: robotGetGibbedLimbs
	Namespace: RobotSoldierBehavior
	Checksum: 0xB2237CDC
	Offset: 0x5698
	Size: 0xA5
	Parameters: 0
	Flags: Private
*/
function private robotGetGibbedLimbs()
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
	Name: robotInvalidateCover
	Namespace: RobotSoldierBehavior
	Checksum: 0xFE09B0F4
	Offset: 0x5748
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private robotInvalidateCover(entity)
{
	entity.steppedOutOfCover = 0;
	entity PathMode("move allowed");
}

/*
	Name: robotDelayMovement
	Namespace: RobotSoldierBehavior
	Checksum: 0x70589C81
	Offset: 0x5790
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private robotDelayMovement(entity)
{
	entity PathMode("move delayed", 0, RandomFloatRange(1, 2));
}

/*
	Name: robotMovement
	Namespace: RobotSoldierBehavior
	Checksum: 0x69377831
	Offset: 0x57E0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private robotMovement(entity)
{
	if(blackboard::GetBlackBoardAttribute(entity, "_stance") != "stand")
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	}
}

/*
	Name: robotCoverScanInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0x56F5016F
	Offset: 0x5848
	Size: 0xCF
	Parameters: 1
	Flags: Private
*/
function private robotCoverScanInitialize(entity)
{
	blackboard::SetBlackBoardAttribute(entity, "_cover_mode", "cover_scan");
	blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	blackboard::SetBlackBoardAttribute(entity, "_robot_step_in", "slow");
	AiUtility::keepClaimNode(entity);
	AiUtility::chooseCoverDirection(entity, 1);
	entity.steppedOutOfCoverNode = entity.node;
}

/*
	Name: robotCoverScanTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0xD2A1F12D
	Offset: 0x5920
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private robotCoverScanTerminate(entity)
{
	AiUtility::cleanupCoverMode(entity);
	entity.steppedOutOfCover = 1;
	entity.steppedOutTime = GetTime() - 8000;
	AiUtility::releaseClaimNode(entity);
	entity PathMode("dont move");
}

/*
	Name: robotCanJuke
	Namespace: RobotSoldierBehavior
	Checksum: 0xE1F5860B
	Offset: 0x59B0
	Size: 0x155
	Parameters: 1
	Flags: None
*/
function robotCanJuke(entity)
{
	if(!entity ai::get_behavior_attribute("phalanx") && (!isdefined(entity.steppedOutOfCover) && entity.steppedOutOfCover) && AiUtility::canJuke(entity))
	{
		jukeEvents = blackboard::GetBlackboardEvents("actor_juke");
		tooCloseJukeDistanceSqr = 57600;
		foreach(event in jukeEvents)
		{
			if(Distance2DSquared(entity.origin, event.data.origin) <= tooCloseJukeDistanceSqr)
			{
				return 0;
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: robotCanTacticalJuke
	Namespace: RobotSoldierBehavior
	Checksum: 0xB5DE2B0F
	Offset: 0x5B10
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function robotCanTacticalJuke(entity)
{
	if(entity HasPath() && AiUtility::BB_GetLocomotionFaceEnemyQuadrant() == "locomotion_face_enemy_front")
	{
		jukeDirection = AiUtility::calculateJukeDirection(entity, 50, entity.jukeDistance);
		return jukeDirection != "forward";
	}
	return 0;
}

/*
	Name: robotCanPreemptiveJuke
	Namespace: RobotSoldierBehavior
	Checksum: 0xB5498ACB
	Offset: 0x5BA0
	Size: 0x3DD
	Parameters: 1
	Flags: None
*/
function robotCanPreemptiveJuke(entity)
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
	jukeMaxDistance = 600;
	if(IsWeapon(entity.enemy.currentWeapon) && isdefined(entity.enemy.currentWeapon.enemycrosshairrange) && entity.enemy.currentWeapon.enemycrosshairrange > 0)
	{
		jukeMaxDistance = entity.enemy.currentWeapon.enemycrosshairrange;
		if(jukeMaxDistance > 1200)
		{
			jukeMaxDistance = 1200;
		}
	}
	if(DistanceSquared(entity.origin, entity.enemy.origin) < jukeMaxDistance * jukeMaxDistance)
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
				return robotCanJuke(entity);
			}
		}
	}
	return 0;
}

/*
	Name: robotIsAtCoverModeScan
	Namespace: RobotSoldierBehavior
	Checksum: 0x3E07442F
	Offset: 0x5F88
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function robotIsAtCoverModeScan(entity)
{
	coverMode = blackboard::GetBlackBoardAttribute(entity, "_cover_mode");
	return coverMode == "cover_scan";
}

/*
	Name: robotPrepareForAdjustToCover
	Namespace: RobotSoldierBehavior
	Checksum: 0xB83B04C6
	Offset: 0x5FD8
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private robotPrepareForAdjustToCover(entity)
{
	AiUtility::keepClaimNode(entity);
	blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "crouch");
}

/*
	Name: robotCrawlerService
	Namespace: RobotSoldierBehavior
	Checksum: 0x861E448C
	Offset: 0x6030
	Size: 0x67
	Parameters: 1
	Flags: Private
*/
function private robotCrawlerService(entity)
{
	if(isdefined(entity.crawlerLifeTime) && entity.crawlerLifeTime <= GetTime() && entity.health > 0)
	{
		entity kill();
	}
	return 1;
}

/*
	Name: robotIsCrawler
	Namespace: RobotSoldierBehavior
	Checksum: 0x389DDE9D
	Offset: 0x60A0
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function robotIsCrawler(entity)
{
	return entity.isCrawler;
}

/*
	Name: robotBecomeCrawler
	Namespace: RobotSoldierBehavior
	Checksum: 0x1DE27696
	Offset: 0x60C8
	Size: 0xCB
	Parameters: 1
	Flags: Private
*/
function private robotBecomeCrawler(entity)
{
	if(!entity ai::get_behavior_attribute("can_become_crawler"))
	{
		return;
	}
	entity.isCrawler = 1;
	entity.becomeCrawler = 0;
	entity AllowPitchAngle(1);
	entity SetPitchOrient();
	entity.crawlerLifeTime = GetTime() + randomIntRange(10000, 20000);
	entity notify("bhtn_action_notify", "rbCrawler");
}

/*
	Name: robotShouldBecomeCrawler
	Namespace: RobotSoldierBehavior
	Checksum: 0x8ED1E249
	Offset: 0x61A0
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function robotShouldBecomeCrawler(entity)
{
	return entity.becomeCrawler;
}

/*
	Name: robotIsMarching
	Namespace: RobotSoldierBehavior
	Checksum: 0x11AEC71
	Offset: 0x61C8
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private robotIsMarching(entity)
{
	return blackboard::GetBlackBoardAttribute(entity, "_move_mode") == "marching";
}

/*
	Name: robotLocomotionSpeed
	Namespace: RobotSoldierBehavior
	Checksum: 0xAB9B95EC
	Offset: 0x6208
	Size: 0xBD
	Parameters: 0
	Flags: Private
*/
function private robotLocomotionSpeed()
{
	entity = self;
	if(robotIsMindControlled() == "mind_controlled")
	{
		switch(ai::GetAiAttribute(entity, "rogue_control_speed"))
		{
			case "walk":
			{
				return "locomotion_speed_walk";
			}
			case "run":
			{
				return "locomotion_speed_run";
			}
			case "sprint":
			{
				return "locomotion_speed_sprint";
			}
		}
	}
	else if(ai::GetAiAttribute(entity, "sprint"))
	{
		return "locomotion_speed_sprint";
	}
	return "locomotion_speed_walk";
}

/*
	Name: robotCoverOverInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0x9C69A9CD
	Offset: 0x62D0
	Size: 0x8B
	Parameters: 1
	Flags: Private
*/
function private robotCoverOverInitialize(behaviorTreeEntity)
{
	AiUtility::setCoverShootStartTime(behaviorTreeEntity);
	AiUtility::keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_over");
}

/*
	Name: robotCoverOverTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0xBF2C9C8B
	Offset: 0x6368
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private robotCoverOverTerminate(behaviorTreeEntity)
{
	AiUtility::cleanupCoverMode(behaviorTreeEntity);
	AiUtility::clearCoverShootStartTime(behaviorTreeEntity);
}

/*
	Name: robotIsMindControlled
	Namespace: RobotSoldierBehavior
	Checksum: 0xDF72676D
	Offset: 0x63B0
	Size: 0x39
	Parameters: 0
	Flags: Private
*/
function private robotIsMindControlled()
{
	entity = self;
	if(entity.controlLevel > 1)
	{
		return "mind_controlled";
	}
	return "normal";
}

/*
	Name: robotDontTakeCover
	Namespace: RobotSoldierBehavior
	Checksum: 0xCE5EA347
	Offset: 0x63F8
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private robotDontTakeCover(entity)
{
	entity.combatmode = "no_cover";
	entity.resumeCover = GetTime() + 4000;
}

/*
	Name: _IsValidPlayer
	Namespace: RobotSoldierBehavior
	Checksum: 0x47E979B0
	Offset: 0x6438
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
	Name: robotRushEnemyService
	Namespace: RobotSoldierBehavior
	Checksum: 0x5C2D94AF
	Offset: 0x64F0
	Size: 0xF3
	Parameters: 1
	Flags: Private
*/
function private robotRushEnemyService(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	distanceToEnemy = Distance2DSquared(entity.origin, entity.enemy.origin);
	if(distanceToEnemy >= 360000 && distanceToEnemy <= 1440000)
	{
		findPathResult = entity FindPath(entity.origin, entity.enemy.origin, 1, 0);
		if(findPathResult)
		{
			entity ai::set_behavior_attribute("move_mode", "rusher");
		}
	}
}

/*
	Name: _IsValidRusher
	Namespace: RobotSoldierBehavior
	Checksum: 0x371F6B9F
	Offset: 0x65F0
	Size: 0x183
	Parameters: 2
	Flags: Private
*/
function private _IsValidRusher(entity, neighbor)
{
	return isdefined(neighbor) && isdefined(neighbor.archetype) && neighbor.archetype == "robot" && isdefined(neighbor.team) && entity.team == neighbor.team && entity != neighbor && isdefined(neighbor.enemy) && neighbor ai::get_behavior_attribute("move_mode") == "normal" && !neighbor ai::get_behavior_attribute("phalanx") && neighbor ai::get_behavior_attribute("rogue_control") == "level_0" && DistanceSquared(entity.origin, neighbor.origin) < 160000 && DistanceSquared(neighbor.origin, neighbor.enemy.origin) < 1440000;
}

/*
	Name: robotRushNeighborService
	Namespace: RobotSoldierBehavior
	Checksum: 0x34225F58
	Offset: 0x6780
	Size: 0x1BB
	Parameters: 1
	Flags: Private
*/
function private robotRushNeighborService(entity)
{
	actors = GetAIArray();
	closestEnemy = undefined;
	closestEnemyDistance = undefined;
	foreach(ai in actors)
	{
		if(_IsValidRusher(entity, ai))
		{
			enemyDistance = DistanceSquared(entity.origin, ai.origin);
			if(!isdefined(closestEnemyDistance) || enemyDistance < closestEnemyDistance)
			{
				closestEnemyDistance = enemyDistance;
				closestEnemy = ai;
			}
		}
	}
	if(isdefined(closestEnemy))
	{
		findPathResult = entity FindPath(closestEnemy.origin, closestEnemy.enemy.origin, 1, 0);
		if(findPathResult)
		{
			closestEnemy ai::set_behavior_attribute("move_mode", "rusher");
		}
	}
}

/*
	Name: _FindClosest
	Namespace: RobotSoldierBehavior
	Checksum: 0x64B28D47
	Offset: 0x6948
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
	Name: robotTargetService
	Namespace: RobotSoldierBehavior
	Checksum: 0x4A07A9B9
	Offset: 0x6A98
	Size: 0x5EB
	Parameters: 1
	Flags: Private
*/
function private robotTargetService(entity)
{
	if(robotAbleToShootCondition(entity))
	{
		return 0;
	}
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(isdefined(entity.nextTargetServiceUpdate) && entity.nextTargetServiceUpdate > GetTime() && isalive(entity.favoriteenemy))
	{
		return 0;
	}
	positionOnNavMesh = GetClosestPointOnNavMesh(entity.origin, 200);
	if(!isdefined(positionOnNavMesh))
	{
		return;
	}
	if(isdefined(entity.favoriteenemy) && isdefined(entity.favoriteenemy._currentRogueRobot) && entity.favoriteenemy._currentRogueRobot == entity)
	{
		entity.favoriteenemy._currentRogueRobot = undefined;
	}
	aiEnemies = [];
	playerEnemies = [];
	ai = GetAIArray();
	players = GetPlayers();
	foreach(value in ai)
	{
		if(IsSentient(value) && entity GetIgnoreEnt(value))
		{
			continue;
		}
		if(value.team != entity.team && IsActor(value) && !isdefined(entity.favoriteenemy))
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh(value.origin, 200, 30);
			if(isdefined(enemyPositionOnNavMesh) && entity FindPath(positionOnNavMesh, enemyPositionOnNavMesh, 1, 0))
			{
				aiEnemies[aiEnemies.size] = value;
			}
		}
	}
	foreach(value in players)
	{
		if(_IsValidPlayer(value) && value.team != entity.team)
		{
			if(IsSentient(value) && entity GetIgnoreEnt(value))
			{
				continue;
			}
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh(value.origin, 200, 30);
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
		entity.favoriteenemy._currentRogueRobot = entity;
	}
	else if(closestAI.DistanceSquared < closestPlayer.DistanceSquared)
	{
		entity.favoriteenemy = closestAI.entity;
		entity.favoriteenemy._currentRogueRobot = entity;
	}
	else
	{
		entity.favoriteenemy = closestPlayer.entity;
	}
	entity.nextTargetServiceUpdate = GetTime() + randomIntRange(2500, 3500);
}

/*
	Name: setDesiredStanceToStand
	Namespace: RobotSoldierBehavior
	Checksum: 0x74627B3
	Offset: 0x7090
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private setDesiredStanceToStand(behaviorTreeEntity)
{
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(currentStance == "crouch")
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	}
}

/*
	Name: setDesiredStanceToCrouch
	Namespace: RobotSoldierBehavior
	Checksum: 0x56950DC8
	Offset: 0x7108
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private setDesiredStanceToCrouch(behaviorTreeEntity)
{
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(currentStance == "stand")
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "crouch");
	}
}

/*
	Name: toggleDesiredStance
	Namespace: RobotSoldierBehavior
	Checksum: 0xA4925103
	Offset: 0x7180
	Size: 0x93
	Parameters: 1
	Flags: Private
*/
function private toggleDesiredStance(entity)
{
	currentStance = blackboard::GetBlackBoardAttribute(entity, "_stance");
	if(currentStance == "stand")
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "crouch");
	}
	else
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	}
}

/*
	Name: robotShouldShutdown
	Namespace: RobotSoldierBehavior
	Checksum: 0x7A400745
	Offset: 0x7220
	Size: 0x29
	Parameters: 1
	Flags: Private
*/
function private robotShouldShutdown(entity)
{
	return entity ai::get_behavior_attribute("shutdown");
}

/*
	Name: robotShouldExplode
	Namespace: RobotSoldierBehavior
	Checksum: 0x1E0228F1
	Offset: 0x7258
	Size: 0xAD
	Parameters: 1
	Flags: Private
*/
function private robotShouldExplode(entity)
{
	if(entity.controlLevel >= 3)
	{
		if(entity ai::get_behavior_attribute("rogue_force_explosion"))
		{
			return 1;
		}
		else if(isdefined(entity.enemy))
		{
			enemyDistSq = DistanceSquared(entity.origin, entity.enemy.origin);
			return enemyDistSq < 3600;
		}
	}
	return 0;
}

/*
	Name: robotShouldAdjustToCover
	Namespace: RobotSoldierBehavior
	Checksum: 0x987AF481
	Offset: 0x7310
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private robotShouldAdjustToCover(entity)
{
	if(!isdefined(entity.node))
	{
		return 0;
	}
	return blackboard::GetBlackBoardAttribute(entity, "_stance") != "crouch";
}

/*
	Name: robotShouldReactAtCover
	Namespace: RobotSoldierBehavior
	Checksum: 0x74655515
	Offset: 0x7368
	Size: 0x93
	Parameters: 1
	Flags: Private
*/
function private robotShouldReactAtCover(behaviorTreeEntity)
{
	return blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance") == "crouch" && AiUtility::canBeFlanked(behaviorTreeEntity) && behaviorTreeEntity IsAtCoverNodeStrict() && behaviorTreeEntity IsFlankedAtCoverNode() && !behaviorTreeEntity HasPath();
}

/*
	Name: robotExplode
	Namespace: RobotSoldierBehavior
	Checksum: 0x1055F9B6
	Offset: 0x7408
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private robotExplode(entity)
{
	entity.allowdeath = 0;
	entity.noCybercom = 1;
}

/*
	Name: robotExplodeTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x3BD8284D
	Offset: 0x7440
	Size: 0x163
	Parameters: 1
	Flags: Private
*/
function private robotExplodeTerminate(entity)
{
	blackboard::SetBlackBoardAttribute(entity, "_gib_location", "legs");
	entity RadiusDamage(entity.origin + VectorScale((0, 0, 1), 36), 60, 100, 50, entity, "MOD_EXPLOSIVE");
	if(math::cointoss())
	{
		GibServerUtils::GibLeftArm(entity);
	}
	else
	{
		GibServerUtils::GibRightArm(entity);
	}
	GibServerUtils::GibLegs(entity);
	GibServerUtils::GibHead(entity);
	clientfield::set("robot_mind_control_explosion", 1);
	if(isalive(entity))
	{
		entity.allowdeath = 1;
		entity kill();
	}
	entity StartRagdoll();
}

/*
	Name: robotExposedCoverService
	Namespace: RobotSoldierBehavior
	Checksum: 0x7BB93282
	Offset: 0x75B0
	Size: 0xFD
	Parameters: 1
	Flags: Private
*/
function private robotExposedCoverService(entity)
{
	if(isdefined(entity.steppedOutOfCover) && isdefined(entity.steppedOutOfCoverNode) && (!entity IsCoverValid(entity.steppedOutOfCoverNode) || entity HasPath() || !entity IsSafeFromGrenade()))
	{
		entity.steppedOutOfCover = 0;
		entity PathMode("move allowed");
	}
	if(isdefined(entity.resumeCover) && GetTime() > entity.resumeCover)
	{
		entity.combatmode = "cover";
		entity.resumeCover = undefined;
	}
}

/*
	Name: robotIsAtCoverCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0xFBB5E771
	Offset: 0x76B8
	Size: 0x133
	Parameters: 1
	Flags: Private
*/
function private robotIsAtCoverCondition(entity)
{
	enemyTooClose = 0;
	if(isdefined(entity.enemy))
	{
		lastKnownEnemyPos = entity lastKnownPos(entity.enemy);
		distanceToEnemySqr = Distance2DSquared(entity.origin, lastKnownEnemyPos);
		enemyTooClose = distanceToEnemySqr <= 57600;
	}
	return !enemyTooClose && !entity.steppedOutOfCover && entity IsAtCoverNodeStrict() && entity ShouldUseCoverNode() && !entity HasPath() && entity IsSafeFromGrenade() && entity.combatmode != "no_cover";
}

/*
	Name: robotSupportsOverCover
	Namespace: RobotSoldierBehavior
	Checksum: 0x1B6E4D05
	Offset: 0x77F8
	Size: 0x157
	Parameters: 1
	Flags: Private
*/
function private robotSupportsOverCover(entity)
{
	if(isdefined(entity.node))
	{
		if(isdefined(entity.node.SPAWNFLAGS) && entity.node.SPAWNFLAGS & 4 == 4)
		{
			return entity.node.type == "Cover Stand" || entity.node.type == "Conceal Stand";
		}
		return entity.node.type == "Cover Left" || entity.node.type == "Cover Right" || (entity.node.type == "Cover Crouch" || entity.node.type == "Cover Crouch Window" || entity.node.type == "Conceal Crouch");
	}
	return 0;
}

/*
	Name: canMoveToEnemyCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0xEF59239D
	Offset: 0x7958
	Size: 0x17F
	Parameters: 1
	Flags: Private
*/
function private canMoveToEnemyCondition(entity)
{
	if(!isdefined(entity.enemy) || entity.enemy.health <= 0)
	{
		return 0;
	}
	positionOnNavMesh = GetClosestPointOnNavMesh(entity.origin, 200);
	enemyPositionOnNavMesh = GetClosestPointOnNavMesh(entity.enemy.origin, 200, 30);
	if(!isdefined(positionOnNavMesh) || !isdefined(enemyPositionOnNavMesh))
	{
		return 0;
	}
	findPathResult = entity FindPath(positionOnNavMesh, enemyPositionOnNavMesh, 1, 0);
	/#
		if(!findPathResult)
		{
			Record3DText("Dev Block strings are not supported", enemyPositionOnNavMesh + VectorScale((0, 0, 1), 5), (1, 0.5, 0), "Dev Block strings are not supported");
			recordLine(positionOnNavMesh, enemyPositionOnNavMesh, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		}
	#/
	return findPathResult;
}

/*
	Name: canMoveCloseToEnemyCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0xD21F67B1
	Offset: 0x7AE0
	Size: 0xB7
	Parameters: 1
	Flags: Private
*/
function private canMoveCloseToEnemyCondition(entity)
{
	if(!isdefined(entity.enemy) || entity.enemy.health <= 0)
	{
		return 0;
	}
	queryResult = PositionQuery_Source_Navigation(entity.enemy.origin, 0, 120, 120, 20, entity);
	PositionQuery_Filter_InClaimedLocation(queryResult, entity);
	return queryResult.data.size > 0;
}

/*
	Name: robotStartSprint
	Namespace: RobotSoldierBehavior
	Checksum: 0x42E423F0
	Offset: 0x7BA0
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private robotStartSprint(entity)
{
	blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	return 1;
}

/*
	Name: robotStartSuperSprint
	Namespace: RobotSoldierBehavior
	Checksum: 0xF24FDFE5
	Offset: 0x7BE0
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private robotStartSuperSprint(entity)
{
	blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_super_sprint");
	return 1;
}

/*
	Name: robotTacticalWalkActionStart
	Namespace: RobotSoldierBehavior
	Checksum: 0xEBCA12B9
	Offset: 0x7C20
	Size: 0x8F
	Parameters: 1
	Flags: Private
*/
function private robotTacticalWalkActionStart(entity)
{
	AiUtility::resetCoverParameters(entity);
	AiUtility::setCanBeFlanked(entity, 0);
	blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_walk");
	blackboard::SetBlackBoardAttribute(entity, "_stance", "stand");
	return 1;
}

/*
	Name: robotDie
	Namespace: RobotSoldierBehavior
	Checksum: 0xF69D8C31
	Offset: 0x7CB8
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private robotDie(entity)
{
	if(isalive(entity))
	{
		entity kill();
	}
}

/*
	Name: moveToPlayerUpdate
	Namespace: RobotSoldierBehavior
	Checksum: 0xD20766A9
	Offset: 0x7D00
	Size: 0x7C7
	Parameters: 2
	Flags: Private
*/
function private moveToPlayerUpdate(entity, asmStateName)
{
	entity.keepClaimedNode = 0;
	positionOnNavMesh = GetClosestPointOnNavMesh(entity.origin, 200);
	if(!isdefined(positionOnNavMesh))
	{
		return 4;
	}
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		entity ClearUsePosition();
		return 4;
	}
	if(!isdefined(entity.enemy))
	{
		return 4;
	}
	if(robotRogueHasCloseEnemyToMelee(entity))
	{
		return 4;
	}
	if(entity.allowPushActors)
	{
		if(isdefined(entity.enemy) && DistanceSquared(entity.origin, entity.enemy.origin) > 300 * 300)
		{
			entity PushActors(0);
		}
		else
		{
			entity PushActors(1);
		}
	}
	if(entity AsmIsTransDecRunning() || entity ASMIsTransitionRunning())
	{
		return 4;
	}
	if(!isdefined(entity.lastKnownEnemyPos))
	{
		entity.lastKnownEnemyPos = entity.enemy.origin;
	}
	shouldRepath = !isdefined(entity.lastValidEnemyPos);
	if(!shouldRepath && isdefined(entity.enemy))
	{
		if(isdefined(entity.nextMoveToPlayerUpdate) && entity.nextMoveToPlayerUpdate <= GetTime())
		{
			shouldRepath = 1;
		}
		else if(DistanceSquared(entity.lastKnownEnemyPos, entity.enemy.origin) > 72 * 72)
		{
			shouldRepath = 1;
		}
		else if(DistanceSquared(entity.origin, entity.enemy.origin) <= 120 * 120)
		{
			shouldRepath = 1;
		}
		else if(isdefined(entity.pathGoalPos))
		{
			distanceToGoalSqr = DistanceSquared(entity.origin, entity.pathGoalPos);
			shouldRepath = distanceToGoalSqr < 72 * 72;
		}
	}
	if(shouldRepath)
	{
		entity.lastKnownEnemyPos = entity.enemy.origin;
		queryResult = PositionQuery_Source_Navigation(entity.lastKnownEnemyPos, 0, 120, 120, 20, entity);
		PositionQuery_Filter_InClaimedLocation(queryResult, entity);
		if(queryResult.data.size > 0)
		{
			entity.lastValidEnemyPos = queryResult.data[0].origin;
		}
		if(isdefined(entity.lastValidEnemyPos))
		{
			entity UsePosition(entity.lastValidEnemyPos);
			if(DistanceSquared(entity.origin, entity.lastValidEnemyPos) > 240 * 240)
			{
				path = entity CalcApproximatePathToPosition(entity.lastValidEnemyPos, 0);
				/#
					if(GetDvarInt("Dev Block strings are not supported"))
					{
						for(index = 1; index < path.size; index++)
						{
							recordLine(path[index - 1], path[index], (1, 0.5, 0), "Dev Block strings are not supported", entity);
						}
					}
				#/
				deviationDistance = randomIntRange(240, 480);
				segmentLength = 0;
				for(index = 1; index < path.size; index++)
				{
					currentSegLength = Distance(path[index - 1], path[index]);
					if(segmentLength + currentSegLength > deviationDistance)
					{
						remainingLength = deviationDistance - segmentLength;
						seedPosition = path[index - 1] + VectorNormalize(path[index] - path[index - 1]) * remainingLength;
						/#
							RecordCircle(seedPosition, 2, (1, 0.5, 0), "Dev Block strings are not supported", entity);
						#/
						innerZigZagRadius = 0;
						outerZigZagRadius = 64;
						queryResult = PositionQuery_Source_Navigation(seedPosition, innerZigZagRadius, outerZigZagRadius, 36, 16, entity, 16);
						PositionQuery_Filter_InClaimedLocation(queryResult, entity);
						if(queryResult.data.size > 0)
						{
							point = queryResult.data[RandomInt(queryResult.data.size)];
							entity UsePosition(point.origin);
						}
						break;
					}
					segmentLength = segmentLength + currentSegLength;
				}
			}
		}
		entity.nextMoveToPlayerUpdate = GetTime() + randomIntRange(2000, 3000);
	}
	return 5;
}

/*
	Name: robotShouldChargeMelee
	Namespace: RobotSoldierBehavior
	Checksum: 0xE5675B53
	Offset: 0x84D0
	Size: 0x45
	Parameters: 1
	Flags: Private
*/
function private robotShouldChargeMelee(entity)
{
	if(AiUtility::shouldMutexMelee(entity) && robotHasEnemyToMelee(entity))
	{
		return 1;
	}
	return 0;
}

/*
	Name: robotHasEnemyToMelee
	Namespace: RobotSoldierBehavior
	Checksum: 0xDE2B1C99
	Offset: 0x8520
	Size: 0x193
	Parameters: 1
	Flags: Private
*/
function private robotHasEnemyToMelee(entity)
{
	if(isdefined(entity.enemy) && IsSentient(entity.enemy) && entity.enemy.health > 0)
	{
		enemyDistSq = DistanceSquared(entity.origin, entity.enemy.origin);
		if(enemyDistSq < entity.chargeMeleeDistance * entity.chargeMeleeDistance && Abs(entity.enemy.origin[2] - entity.origin[2]) < 24)
		{
			yawToEnemy = AngleClamp180(entity.angles[1] - VectorToAngles(entity.enemy.origin - entity.origin)[1]);
			return Abs(yawToEnemy) <= 80;
		}
	}
	return 0;
}

/*
	Name: robotRogueHasEnemyToMelee
	Namespace: RobotSoldierBehavior
	Checksum: 0x82106044
	Offset: 0x86C0
	Size: 0xE9
	Parameters: 1
	Flags: Private
*/
function private robotRogueHasEnemyToMelee(entity)
{
	if(isdefined(entity.enemy) && IsSentient(entity.enemy) && entity.enemy.health > 0 && entity ai::get_behavior_attribute("rogue_control") != "level_3")
	{
		if(!entity cansee(entity.enemy))
		{
			return 0;
		}
		return DistanceSquared(entity.origin, entity.enemy.origin) < 132 * 132;
	}
	return 0;
}

/*
	Name: robotShouldMelee
	Namespace: RobotSoldierBehavior
	Checksum: 0xA7EA7A0
	Offset: 0x87B8
	Size: 0x45
	Parameters: 1
	Flags: Private
*/
function private robotShouldMelee(entity)
{
	if(AiUtility::shouldMutexMelee(entity) && robotHasCloseEnemyToMelee(entity))
	{
		return 1;
	}
	return 0;
}

/*
	Name: robotHasCloseEnemyToMelee
	Namespace: RobotSoldierBehavior
	Checksum: 0x82162DE5
	Offset: 0x8808
	Size: 0x15B
	Parameters: 1
	Flags: Private
*/
function private robotHasCloseEnemyToMelee(entity)
{
	if(isdefined(entity.enemy) && IsSentient(entity.enemy) && entity.enemy.health > 0)
	{
		if(!entity cansee(entity.enemy))
		{
			return 0;
		}
		enemyDistSq = DistanceSquared(entity.origin, entity.enemy.origin);
		if(enemyDistSq < 64 * 64)
		{
			yawToEnemy = AngleClamp180(entity.angles[1] - VectorToAngles(entity.enemy.origin - entity.origin)[1]);
			return Abs(yawToEnemy) <= 80;
		}
	}
	return 0;
}

/*
	Name: robotRogueHasCloseEnemyToMelee
	Namespace: RobotSoldierBehavior
	Checksum: 0xCFB35B13
	Offset: 0x8970
	Size: 0xC1
	Parameters: 1
	Flags: Private
*/
function private robotRogueHasCloseEnemyToMelee(entity)
{
	if(isdefined(entity.enemy) && IsSentient(entity.enemy) && entity.enemy.health > 0 && entity ai::get_behavior_attribute("rogue_control") != "level_3")
	{
		return DistanceSquared(entity.origin, entity.enemy.origin) < 64 * 64;
	}
	return 0;
}

/*
	Name: scriptRequiresToSprintCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0x3BF63F69
	Offset: 0x8A40
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private scriptRequiresToSprintCondition(entity)
{
	return entity ai::get_behavior_attribute("sprint") && !entity ai::get_behavior_attribute("disablesprint");
}

/*
	Name: robotScanExposedPainTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x5B428F6A
	Offset: 0x8A98
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private robotScanExposedPainTerminate(entity)
{
	AiUtility::cleanupCoverMode(entity);
	blackboard::SetBlackBoardAttribute(entity, "_robot_step_in", "fast");
}

/*
	Name: robotTookEmpDamage
	Namespace: RobotSoldierBehavior
	Checksum: 0xEA7C44CB
	Offset: 0x8AF0
	Size: 0xAD
	Parameters: 1
	Flags: Private
*/
function private robotTookEmpDamage(entity)
{
	if(isdefined(entity.damageWeapon) && isdefined(entity.damageMod))
	{
		weapon = entity.damageWeapon;
		return entity.damageMod == "MOD_GRENADE_SPLASH" && isdefined(weapon.rootweapon) && IsSubStr(weapon.rootweapon.name, "emp_grenade");
	}
	return 0;
}

/*
	Name: robotNoCloseEnemyService
	Namespace: RobotSoldierBehavior
	Checksum: 0xA5CAEE9C
	Offset: 0x8BA8
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private robotNoCloseEnemyService(entity)
{
	if(isdefined(entity.enemy) && AiUtility::shouldMelee(entity))
	{
		entity clearPath();
		return 1;
	}
	return 0;
}

/*
	Name: _robotOutsideMovementRange
	Namespace: RobotSoldierBehavior
	Checksum: 0xB23C0E25
	Offset: 0x8C08
	Size: 0x11F
	Parameters: 3
	Flags: Private
*/
function private _robotOutsideMovementRange(entity, range, useEnemyPos)
{
	/#
		Assert(isdefined(range));
	#/
	if(!isdefined(entity.enemy) && !entity HasPath())
	{
		return 0;
	}
	goalpos = entity.pathGoalPos;
	if(isdefined(entity.enemy) && useEnemyPos)
	{
		goalpos = entity lastKnownPos(entity.enemy);
	}
	if(!isdefined(goalpos))
	{
		return 0;
	}
	outsideRange = DistanceSquared(entity.origin, goalpos) > range * range;
	return outsideRange;
}

/*
	Name: robotOutsideSuperSprintRange
	Namespace: RobotSoldierBehavior
	Checksum: 0x18AAA216
	Offset: 0x8D30
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private robotOutsideSuperSprintRange(entity)
{
	return !robotWithinSuperSprintRange(entity);
}

/*
	Name: robotWithinSuperSprintRange
	Namespace: RobotSoldierBehavior
	Checksum: 0xC9767F8
	Offset: 0x8D60
	Size: 0x75
	Parameters: 1
	Flags: Private
*/
function private robotWithinSuperSprintRange(entity)
{
	if(entity ai::get_behavior_attribute("supports_super_sprint") && !entity ai::get_behavior_attribute("disablesprint"))
	{
		return _robotOutsideMovementRange(entity, entity.superSprintDistance, 0);
	}
	return 0;
}

/*
	Name: robotOutsideSprintRange
	Namespace: RobotSoldierBehavior
	Checksum: 0x7852671C
	Offset: 0x8DE0
	Size: 0x85
	Parameters: 1
	Flags: Private
*/
function private robotOutsideSprintRange(entity)
{
	if(entity ai::get_behavior_attribute("supports_super_sprint") && !entity ai::get_behavior_attribute("disablesprint"))
	{
		return _robotOutsideMovementRange(entity, entity.superSprintDistance * 1.15, 0);
	}
	return 0;
}

/*
	Name: robotOutsideTacticalWalkRange
	Namespace: RobotSoldierBehavior
	Checksum: 0xFE05F237
	Offset: 0x8E70
	Size: 0xC1
	Parameters: 1
	Flags: Private
*/
function private robotOutsideTacticalWalkRange(entity)
{
	if(entity ai::get_behavior_attribute("disablesprint"))
	{
		return 0;
	}
	if(isdefined(entity.enemy) && DistanceSquared(entity.origin, entity.goalpos) < entity.minWalkDistance * entity.minWalkDistance)
	{
		return 0;
	}
	return _robotOutsideMovementRange(entity, entity.runAndGunDist * 1.15, 1);
}

/*
	Name: robotWithinSprintRange
	Namespace: RobotSoldierBehavior
	Checksum: 0xEC87FFDB
	Offset: 0x8F40
	Size: 0xB1
	Parameters: 1
	Flags: Private
*/
function private robotWithinSprintRange(entity)
{
	if(entity ai::get_behavior_attribute("disablesprint"))
	{
		return 0;
	}
	if(isdefined(entity.enemy) && DistanceSquared(entity.origin, entity.goalpos) < entity.minWalkDistance * entity.minWalkDistance)
	{
		return 0;
	}
	return _robotOutsideMovementRange(entity, entity.runAndGunDist, 1);
}

/*
	Name: shouldTakeOverCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0xE943A261
	Offset: 0x9000
	Size: 0x117
	Parameters: 1
	Flags: Private
*/
function private shouldTakeOverCondition(entity)
{
	switch(entity.controlLevel)
	{
		case 0:
		{
			return IsInArray(Array("level_1", "level_2", "level_3"), entity ai::get_behavior_attribute("rogue_control"));
		}
		case 1:
		{
			return IsInArray(Array("level_2", "level_3"), entity ai::get_behavior_attribute("rogue_control"));
		}
		case 2:
		{
			return entity ai::get_behavior_attribute("rogue_control") == "level_3";
		}
	}
	return 0;
}

/*
	Name: hasMiniRaps
	Namespace: RobotSoldierBehavior
	Checksum: 0xEE8F2833
	Offset: 0x9120
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private hasMiniRaps(entity)
{
	return isdefined(entity.miniRaps);
}

/*
	Name: robotIsMoving
	Namespace: RobotSoldierBehavior
	Checksum: 0xC8D5EFDC
	Offset: 0x9148
	Size: 0x7F
	Parameters: 1
	Flags: Private
*/
function private robotIsMoving(entity)
{
	velocity = entity GetVelocity();
	velocity = (velocity[0], 0, velocity[1]);
	velocitySqr = LengthSquared(velocity);
	return velocitySqr > 24 * 24;
}

/*
	Name: robotAbleToShootCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0x83CD6A80
	Offset: 0x91D0
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private robotAbleToShootCondition(entity)
{
	return entity.controlLevel <= 1;
}

/*
	Name: robotShouldTacticalWalk
	Namespace: RobotSoldierBehavior
	Checksum: 0x679E3D16
	Offset: 0x91F8
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private robotShouldTacticalWalk(entity)
{
	if(!entity HasPath())
	{
		return 0;
	}
	return !robotIsMarching(entity);
}

/*
	Name: _robotCoverPosition
	Namespace: RobotSoldierBehavior
	Checksum: 0xE03BB6A8
	Offset: 0x9248
	Size: 0x64B
	Parameters: 1
	Flags: Private
*/
function private _robotCoverPosition(entity)
{
	if(entity IsFlankedAtCoverNode())
	{
		return 0;
	}
	if(entity ShouldHoldGroundAgainstEnemy())
	{
		return 0;
	}
	ShouldUseCoverNode = undefined;
	itsBeenAWhile = GetTime() > entity.nextFindBestCoverTime;
	isAtScriptGoal = undefined;
	if(isdefined(entity.robotNode))
	{
		isAtScriptGoal = entity IsPosAtGoal(entity.robotNode.origin);
		ShouldUseCoverNode = entity IsCoverValid(entity.robotNode);
	}
	else
	{
		isAtScriptGoal = entity IsAtGoal();
		ShouldUseCoverNode = entity ShouldUseCoverNode();
	}
	shouldLookForBetterCover = !ShouldUseCoverNode || itsBeenAWhile || !isAtScriptGoal;
	/#
		if(shouldLookForBetterCover)
		{
		}
		else
		{
		}
		recordEntText("Dev Block strings are not supported" + ShouldUseCoverNode + "Dev Block strings are not supported" + itsBeenAWhile + "Dev Block strings are not supported" + isAtScriptGoal, entity, (1, 0, 0), (0, 1, 0));
	#/
	if(shouldLookForBetterCover && isdefined(entity.enemy) && !entity.keepClaimedNode)
	{
		transitionRunning = entity ASMIsTransitionRunning();
		subStatePending = entity ASMIsSubStatePending();
		transDecRunning = entity AsmIsTransDecRunning();
		isBehaviorTreeInRunningState = entity GetBehaviortreeStatus() == 5;
		if(!transitionRunning && !subStatePending && !transDecRunning && isBehaviorTreeInRunningState)
		{
			nodes = entity FindBestCoverNodes(entity.goalRadius, entity.goalpos);
			node = undefined;
			for(nodeIndex = 0; nodeIndex < nodes.size; nodeIndex++)
			{
				if(entity.robotNode === nodes[nodeIndex] || !isdefined(nodes[nodeIndex].robotClaimed))
				{
					node = nodes[nodeIndex];
					break;
				}
			}
			if(IsEntity(entity.node) && (!isdefined(entity.robotNode) || entity.robotNode != entity.node))
			{
				entity.robotNode = entity.node;
				entity.robotNode.robotClaimed = 1;
			}
			goingToDifferentNode = isdefined(node) && (!isdefined(entity.robotNode) || node != entity.robotNode) && (!isdefined(entity.steppedOutOfCoverNode) || entity.steppedOutOfCoverNode != node);
			AiUtility::setNextFindBestCoverTime(entity, node);
			if(goingToDifferentNode)
			{
				if(RandomFloat(1) <= 0.75 || entity ai::get_behavior_attribute("force_cover"))
				{
					AiUtility::useCoverNodeWrapper(entity, node);
				}
				else
				{
					searchRadius = entity.goalRadius;
					if(searchRadius > 200)
					{
						searchRadius = 200;
					}
					coverNodePoints = util::PositionQuery_PointArray(node.origin, 30, searchRadius, 72, 30);
					if(coverNodePoints.size > 0)
					{
						entity UsePosition(coverNodePoints[RandomInt(coverNodePoints.size)]);
					}
					else
					{
						entity UsePosition(entity GetNodeOffsetPosition(node));
					}
				}
				if(isdefined(entity.robotNode))
				{
					entity.robotNode.robotClaimed = undefined;
				}
				entity.robotNode = node;
				entity.robotNode.robotClaimed = 1;
				entity PathMode("move delayed", 0, RandomFloatRange(0.25, 2));
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: _robotEscortPosition
	Namespace: RobotSoldierBehavior
	Checksum: 0xBA260F09
	Offset: 0x98A0
	Size: 0x31B
	Parameters: 1
	Flags: Private
*/
function private _robotEscortPosition(entity)
{
	if(entity ai::get_behavior_attribute("move_mode") == "escort")
	{
		escortPosition = entity ai::get_behavior_attribute("escort_position");
		if(!isdefined(escortPosition))
		{
			return 1;
		}
		if(Distance2DSquared(entity.origin, escortPosition) <= 22500)
		{
			return 1;
		}
		if(isdefined(entity.escortNextTime) && GetTime() < entity.escortNextTime)
		{
			return 1;
		}
		if(entity GetPathMode() == "dont move")
		{
			return 1;
		}
		positionOnNavMesh = GetClosestPointOnNavMesh(escortPosition, 200);
		if(!isdefined(positionOnNavMesh))
		{
			positionOnNavMesh = escortPosition;
		}
		queryResult = PositionQuery_Source_Navigation(positionOnNavMesh, 75, 150, 36, 16, entity, 16);
		PositionQuery_Filter_InClaimedLocation(queryResult, entity);
		if(queryResult.data.size > 0)
		{
			closestPoint = undefined;
			closestDistance = undefined;
			foreach(point in queryResult.data)
			{
				if(!point.inclaimedlocation)
				{
					newClosestDistance = Distance2DSquared(entity.origin, point.origin);
					if(!isdefined(closestPoint) || newClosestDistance < closestDistance)
					{
						closestPoint = point.origin;
						closestDistance = newClosestDistance;
					}
				}
			}
			if(isdefined(closestPoint))
			{
				entity UsePosition(closestPoint);
				entity.escortNextTime = GetTime() + randomIntRange(200, 300);
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: _robotRusherPosition
	Namespace: RobotSoldierBehavior
	Checksum: 0xA5A07A52
	Offset: 0x9BC8
	Size: 0x403
	Parameters: 1
	Flags: Private
*/
function private _robotRusherPosition(entity)
{
	if(entity ai::get_behavior_attribute("move_mode") == "rusher")
	{
		entity PathMode("move allowed");
		if(!isdefined(entity.enemy))
		{
			return 1;
		}
		distToEnemySqr = Distance2DSquared(entity.origin, entity.enemy.origin);
		if(distToEnemySqr <= entity.robotRusherMaxRadius * entity.robotRusherMaxRadius && distToEnemySqr >= entity.robotRusherMinRadius * entity.robotRusherMinRadius)
		{
			return 1;
		}
		if(isdefined(entity.rusherNextTime) && GetTime() < entity.rusherNextTime)
		{
			return 1;
		}
		positionOnNavMesh = GetClosestPointOnNavMesh(entity.enemy.origin, 200);
		if(!isdefined(positionOnNavMesh))
		{
			positionOnNavMesh = entity.enemy.origin;
		}
		queryResult = PositionQuery_Source_Navigation(positionOnNavMesh, entity.robotRusherMinRadius, entity.robotRusherMaxRadius, 36, 16, entity, 16);
		PositionQuery_Filter_InClaimedLocation(queryResult, entity);
		PositionQuery_Filter_Sight(queryResult, entity.enemy.origin, entity GetEye() - entity.origin, entity, 2, entity.enemy);
		if(queryResult.data.size > 0)
		{
			closestPoint = undefined;
			closestDistance = undefined;
			foreach(point in queryResult.data)
			{
				if(!point.inclaimedlocation && point.visibility === 1)
				{
					newClosestDistance = Distance2DSquared(entity.origin, point.origin);
					if(!isdefined(closestPoint) || newClosestDistance < closestDistance)
					{
						closestPoint = point.origin;
						closestDistance = newClosestDistance;
					}
				}
			}
			if(isdefined(closestPoint))
			{
				entity UsePosition(closestPoint);
				entity.rusherNextTime = GetTime() + randomIntRange(500, 1500);
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: _robotGuardPosition
	Namespace: RobotSoldierBehavior
	Checksum: 0xA1481FFC
	Offset: 0x9FD8
	Size: 0x417
	Parameters: 1
	Flags: Private
*/
function private _robotGuardPosition(entity)
{
	if(entity ai::get_behavior_attribute("move_mode") == "guard")
	{
		if(entity GetPathMode() == "dont move")
		{
			return 1;
		}
		if(!isdefined(entity.guardPosition) || DistanceSquared(entity.origin, entity.guardPosition) < 60 * 60)
		{
			entity PathMode("move delayed", 1, RandomFloatRange(1, 1.5));
			queryResult = PositionQuery_Source_Navigation(entity.goalpos, 0, entity.goalRadius / 2, 36, 36, entity, 72);
			PositionQuery_Filter_InClaimedLocation(queryResult, entity);
			if(queryResult.data.size > 0)
			{
				minimumDistanceSq = entity.goalRadius * 0.2;
				minimumDistanceSq = minimumDistanceSq * minimumDistanceSq;
				distantPoints = [];
				foreach(point in queryResult.data)
				{
					if(DistanceSquared(entity.origin, point.origin) > minimumDistanceSq)
					{
						distantPoints[distantPoints.size] = point;
					}
				}
				if(distantPoints.size > 0)
				{
					randomPosition = distantPoints[RandomInt(distantPoints.size)];
					entity.guardPosition = randomPosition.origin;
					entity.intermediateGuardPosition = undefined;
					entity.intermediateGuardTime = undefined;
				}
			}
		}
		currentTime = GetTime();
		if(!isdefined(entity.intermediateGuardTime) || entity.intermediateGuardTime < currentTime)
		{
			if(isdefined(entity.intermediateGuardPosition) && DistanceSquared(entity.intermediateGuardPosition, entity.origin) < 24 * 24)
			{
				entity.guardPosition = entity.origin;
			}
			entity.intermediateGuardPosition = entity.origin;
			entity.intermediateGuardTime = currentTime + 3000;
		}
		if(isdefined(entity.guardPosition))
		{
			entity UsePosition(entity.guardPosition);
			return 1;
		}
	}
	entity.guardPosition = undefined;
	entity.intermediateGuardPosition = undefined;
	entity.intermediateGuardTime = undefined;
	return 0;
}

/*
	Name: robotPositionService
	Namespace: RobotSoldierBehavior
	Checksum: 0x2E9595C9
	Offset: 0xA3F8
	Size: 0x28D
	Parameters: 1
	Flags: Private
*/
function private robotPositionService(entity)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") && isdefined(entity.enemy))
		{
			lastKnownPos = entity lastKnownPos(entity.enemy);
			recordLine(entity.origin, lastKnownPos, (1, 0.5, 0), "Dev Block strings are not supported", entity);
			Record3DText("Dev Block strings are not supported", lastKnownPos + VectorScale((0, 0, 1), 5), (1, 0.5, 0), "Dev Block strings are not supported");
		}
	#/
	if(!isalive(entity))
	{
		if(isdefined(entity.robotNode))
		{
			AiUtility::releaseClaimNode(entity);
			entity.robotNode.robotClaimed = undefined;
			entity.robotNode = undefined;
		}
		return 0;
	}
	if(entity.disableRepath)
	{
		return 0;
	}
	if(!robotAbleToShootCondition(entity))
	{
		return 0;
	}
	if(entity ai::get_behavior_attribute("phalanx"))
	{
		return 0;
	}
	if(AiSquads::isFollowingSquadLeader(entity))
	{
		return 0;
	}
	if(_robotRusherPosition(entity))
	{
		return 1;
	}
	if(_robotGuardPosition(entity))
	{
		return 1;
	}
	if(_robotEscortPosition(entity))
	{
		return 1;
	}
	if(!AiUtility::isSafeFromGrenades(entity))
	{
		AiUtility::releaseClaimNode(entity);
		AiUtility::chooseBestCoverNodeASAP(entity);
	}
	if(_robotCoverPosition(entity))
	{
		return 1;
	}
	return 0;
}

/*
	Name: robotDropStartingWeapon
	Namespace: RobotSoldierBehavior
	Checksum: 0x43E905EC
	Offset: 0xA690
	Size: 0x83
	Parameters: 2
	Flags: Private
*/
function private robotDropStartingWeapon(entity, asmStateName)
{
	if(entity.weapon.name == level.weaponNone.name)
	{
		entity shared::placeWeaponOn(entity.startingWeapon, "right");
		entity thread shared::DropAIWeapon();
	}
}

/*
	Name: robotJukeInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0xBD5F0289
	Offset: 0xA720
	Size: 0xC3
	Parameters: 1
	Flags: Private
*/
function private robotJukeInitialize(entity)
{
	AiUtility::chooseJukeDirection(entity);
	entity clearPath();
	entity notify("bhtn_action_notify", "rbJuke");
	jukeInfo = spawnstruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;
	blackboard::AddBlackboardEvent("actor_juke", jukeInfo, 3000);
}

/*
	Name: robotPreemptiveJukeTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x7AEFF500
	Offset: 0xA7F0
	Size: 0x67
	Parameters: 1
	Flags: Private
*/
function private robotPreemptiveJukeTerminate(entity)
{
	entity.nextPreemptiveJuke = GetTime() + randomIntRange(4000, 6000);
	entity.nextPreemptiveJukeAds = RandomFloatRange(0.5, 0.95);
}

/*
	Name: robotTryReacquireService
	Namespace: RobotSoldierBehavior
	Checksum: 0x407A6089
	Offset: 0xA860
	Size: 0x371
	Parameters: 1
	Flags: Private
*/
function private robotTryReacquireService(entity)
{
	moveMode = entity ai::get_behavior_attribute("move_mode");
	if(moveMode == "rusher" || moveMode == "escort" || moveMode == "guard")
	{
		return 0;
	}
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
	if(!robotAbleToShootCondition(entity))
	{
		return 0;
	}
	if(entity ai::get_behavior_attribute("force_cover"))
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
	Name: takeOverInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0xB0A829E8
	Offset: 0xABE0
	Size: 0xC7
	Parameters: 2
	Flags: Private
*/
function private takeOverInitialize(entity, asmStateName)
{
	switch(entity ai::get_behavior_attribute("rogue_control"))
	{
		case "level_1":
		{
			entity RobotSoldierServerUtils::forceRobotSoldierMindControlLevel1();
			break;
		}
		case "level_2":
		{
			entity RobotSoldierServerUtils::forceRobotSoldierMindControlLevel2();
			break;
		}
		case "level_3":
		{
			entity RobotSoldierServerUtils::forceRobotSoldierMindControlLevel3();
			break;
		}
	}
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: takeOverTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0x41CB79FE
	Offset: 0xACB0
	Size: 0x71
	Parameters: 2
	Flags: Private
*/
function private takeOverTerminate(entity, asmStateName)
{
	switch(entity ai::get_behavior_attribute("rogue_control"))
	{
		case "level_2":
		case "level_3":
		{
			entity thread shared::DropAIWeapon();
			break;
		}
	}
	return 4;
}

/*
	Name: stepIntoInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0xF386F477
	Offset: 0xAD30
	Size: 0xB7
	Parameters: 2
	Flags: Private
*/
function private stepIntoInitialize(entity, asmStateName)
{
	AiUtility::releaseClaimNode(entity);
	AiUtility::useCoverNodeWrapper(entity, entity.steppedOutOfCoverNode);
	blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "crouch");
	AiUtility::keepClaimNode(entity);
	entity.steppedOutOfCoverNode = undefined;
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: stepIntoTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0xF5DC206
	Offset: 0xADF0
	Size: 0x5F
	Parameters: 2
	Flags: Private
*/
function private stepIntoTerminate(entity, asmStateName)
{
	entity.steppedOutOfCover = 0;
	AiUtility::releaseClaimNode(entity);
	entity PathMode("move allowed");
	return 4;
}

/*
	Name: stepOutInitialize
	Namespace: RobotSoldierBehavior
	Checksum: 0xBE2BFC47
	Offset: 0xAE58
	Size: 0xFF
	Parameters: 2
	Flags: Private
*/
function private stepOutInitialize(entity, asmStateName)
{
	entity.steppedOutOfCoverNode = entity.node;
	AiUtility::keepClaimNode(entity);
	if(math::cointoss())
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	}
	else
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "crouch");
	}
	blackboard::SetBlackBoardAttribute(entity, "_robot_step_in", "fast");
	AiUtility::chooseCoverDirection(entity, 1);
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: stepOutTerminate
	Namespace: RobotSoldierBehavior
	Checksum: 0xA7A33179
	Offset: 0xAF60
	Size: 0x6F
	Parameters: 2
	Flags: Private
*/
function private stepOutTerminate(entity, asmStateName)
{
	entity.steppedOutOfCover = 1;
	entity.steppedOutTime = GetTime();
	AiUtility::releaseClaimNode(entity);
	entity PathMode("dont move");
	return 4;
}

/*
	Name: supportsStepOutCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0x11C62BC1
	Offset: 0xAFD8
	Size: 0x73
	Parameters: 1
	Flags: Private
*/
function private supportsStepOutCondition(entity)
{
	return entity.node.type == "Cover Left" || entity.node.type == "Cover Right" || entity.node.type == "Cover Pillar";
}

/*
	Name: shouldStepInCondition
	Namespace: RobotSoldierBehavior
	Checksum: 0xDBA8877B
	Offset: 0xB058
	Size: 0xE5
	Parameters: 1
	Flags: Private
*/
function private shouldStepInCondition(entity)
{
	if(!isdefined(entity.steppedOutOfCover) || !entity.steppedOutOfCover || !isdefined(entity.steppedOutTime) || !entity.steppedOutOfCover)
	{
		return 0;
	}
	exposedTimeInSeconds = GetTime() - entity.steppedOutTime / 1000;
	exceededTime = exposedTimeInSeconds >= 4 || exposedTimeInSeconds >= 8;
	suppressed = entity.suppressionMeter > entity.suppressionThreshold;
	return exceededTime || (exceededTime && suppressed);
}

/*
	Name: robotDeployMiniRaps
	Namespace: RobotSoldierBehavior
	Checksum: 0xE6A24FF8
	Offset: 0xB148
	Size: 0xD1
	Parameters: 0
	Flags: Private
*/
function private robotDeployMiniRaps()
{
	entity = self;
	if(isdefined(entity) && isdefined(entity.miniRaps))
	{
		positionOnNavMesh = GetClosestPointOnNavMesh(entity.origin, 200);
		raps = SpawnVehicle("spawner_bo3_mini_raps", positionOnNavMesh, (0, 0, 0));
		raps.team = entity.team;
		raps thread RobotSoldierServerUtils::RapsDetonateCountdown(raps);
		entity.miniRaps = undefined;
	}
}

#namespace RobotSoldierServerUtils;

/*
	Name: _tryGibbingHead
	Namespace: RobotSoldierServerUtils
	Checksum: 0x464E3A
	Offset: 0xB228
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
	Namespace: RobotSoldierServerUtils
	Checksum: 0xCED0797C
	Offset: 0xB368
	Size: 0x28B
	Parameters: 5
	Flags: Private
*/
function private _tryGibbingLimb(entity, damage, hitLoc, isExplosive, onDeath)
{
	if(GibServerUtils::IsGibbed(entity, 32) || GibServerUtils::IsGibbed(entity, 16))
	{
		return;
	}
	if(isExplosive && RandomFloatRange(0, 1) <= 0.25)
	{
		if(onDeath && math::cointoss())
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
	else if(onDeath && IsInArray(Array("right_hand", "right_arm_lower", "right_arm_upper"), hitLoc))
	{
		GibServerUtils::GibRightArm(entity);
	}
	else if(RobotSoldierBehavior::robotIsMindControlled() == "mind_controlled" && IsInArray(Array("right_hand", "right_arm_lower", "right_arm_upper"), hitLoc))
	{
		GibServerUtils::GibRightArm(entity);
	}
	else if(onDeath && RandomFloatRange(0, 1) <= 0.25)
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
	Namespace: RobotSoldierServerUtils
	Checksum: 0x89AB4CD8
	Offset: 0xB600
	Size: 0x403
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
	if(entity ai::get_behavior_attribute("can_become_crawler"))
	{
		canGibLegs = canGibLegs || (entity.health - damage / entity.maxhealth <= 0.25 && DistanceSquared(entity.origin, attacker.origin) <= 360000 && !RobotSoldierBehavior::robotIsAtCoverCondition(entity) && entity.allowdeath);
	}
	if(entity.gibDeath && entity.health - damage <= 0 && entity.allowdeath && !RobotSoldierBehavior::robotIsCrawler(entity))
	{
		return;
	}
	if(entity.health - damage <= 0 && entity.allowdeath && isExplosive && RandomFloatRange(0, 1) <= 0.5)
	{
		GibServerUtils::GibLegs(entity);
		entity StartRagdoll();
	}
	else if(canGibLegs && IsInArray(Array("left_leg_upper", "left_leg_lower", "left_foot"), hitLoc) && RandomFloatRange(0, 1) <= 1)
	{
		if(entity.health - damage > 0)
		{
			becomeCrawler(entity);
		}
		GibServerUtils::GibLeftLeg(entity);
	}
	else if(canGibLegs && IsInArray(Array("right_leg_upper", "right_leg_lower", "right_foot"), hitLoc) && RandomFloatRange(0, 1) <= 1)
	{
		if(entity.health - damage > 0)
		{
			becomeCrawler(entity);
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
	Name: robotGibDamageOverride
	Namespace: RobotSoldierServerUtils
	Checksum: 0xEE873AD5
	Offset: 0xBA10
	Size: 0x207
	Parameters: 12
	Flags: Private
*/
function private robotGibDamageOverride(inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(isdefined(attacker) && attacker.team == entity.team)
	{
		return damage;
	}
	if(!entity ai::get_behavior_attribute("can_gib"))
	{
		return damage;
	}
	if(entity.health - damage / entity.maxhealth > 0.75)
	{
		return damage;
	}
	GibServerUtils::ToggleSpawnGibs(entity, 1);
	DestructServerUtils::ToggleSpawnGibs(entity, 1);
	isExplosive = IsInArray(Array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
	_tryGibbingHead(entity, damage, hitLoc, isExplosive);
	_tryGibbingLimb(entity, damage, hitLoc, isExplosive, 0);
	_tryGibbingLegs(entity, damage, hitLoc, isExplosive, attacker);
	return damage;
}

/*
	Name: robotDeathOverride
	Namespace: RobotSoldierServerUtils
	Checksum: 0x5E889BF3
	Offset: 0xBC20
	Size: 0x77
	Parameters: 8
	Flags: Private
*/
function private robotDeathOverride(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime)
{
	entity = self;
	entity ai::set_behavior_attribute("robot_lights", 4);
	return damage;
}

/*
	Name: robotGibDeathOverride
	Namespace: RobotSoldierServerUtils
	Checksum: 0x40B66BAB
	Offset: 0xBCA0
	Size: 0x30F
	Parameters: 8
	Flags: Private
*/
function private robotGibDeathOverride(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime)
{
	entity = self;
	if(!entity ai::get_behavior_attribute("can_gib") || entity.skipdeath)
	{
		return damage;
	}
	GibServerUtils::ToggleSpawnGibs(entity, 1);
	DestructServerUtils::ToggleSpawnGibs(entity, 1);
	isExplosive = 0;
	if(entity.controlLevel >= 3)
	{
		clientfield::set("robot_mind_control_explosion", 1);
		DestructServerUtils::DestructNumberRandomPieces(entity);
		GibServerUtils::GibHead(entity);
		if(math::cointoss())
		{
			GibServerUtils::GibLeftArm(entity);
		}
		else
		{
			GibServerUtils::GibRightArm(entity);
		}
		GibServerUtils::GibLegs(entity);
		velocity = entity GetVelocity() / 9;
		entity StartRagdoll();
		entity LaunchRagdoll((velocity[0] + RandomFloatRange(-10, 10), velocity[1] + RandomFloatRange(-10, 10), RandomFloatRange(40, 50)), "j_mainroot");
		PhysicsExplosionSphere(entity.origin + VectorScale((0, 0, 1), 36), 120, 32, 1);
	}
	else
	{
		isExplosive = IsInArray(Array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
		_tryGibbingLimb(entity, damage, hitLoc, isExplosive, 1);
	}
	return damage;
}

/*
	Name: robotDestructDeathOverride
	Namespace: RobotSoldierServerUtils
	Checksum: 0x4FE93A46
	Offset: 0xBFB8
	Size: 0x207
	Parameters: 8
	Flags: Private
*/
function private robotDestructDeathOverride(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime)
{
	entity = self;
	if(entity.skipdeath)
	{
		return damage;
	}
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
	return damage;
}

/*
	Name: robotDamageOverride
	Namespace: RobotSoldierServerUtils
	Checksum: 0x95695E22
	Offset: 0xC1C8
	Size: 0x395
	Parameters: 12
	Flags: Private
*/
function private robotDamageOverride(inflictor, attacker, damage, flags, meansOfDamage, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(hitLoc != "helmet" || hitLoc != "head" || hitLoc != "neck")
	{
		if(isdefined(attacker) && !isPlayer(attacker) && !isVehicle(attacker))
		{
			dist = DistanceSquared(entity.origin, attacker.origin);
			if(dist < 65536)
			{
				damage = Int(damage * 10);
			}
			else
			{
				damage = Int(damage * 1.5);
			}
		}
	}
	if(hitLoc == "helmet" || hitLoc == "head" || hitLoc == "neck")
	{
		damage = Int(damage * 0.5);
	}
	if(isdefined(dir) && isdefined(meansOfDamage) && isdefined(hitLoc) && VectorDot(AnglesToForward(entity.angles), dir) > 0)
	{
		isBullet = IsInArray(Array("MOD_RIFLE_BULLET", "MOD_PISTOL_BULLET"), meansOfDamage);
		isTorsoShot = IsInArray(Array("torso_upper", "torso_lower"), hitLoc);
		if(isBullet && isTorsoShot)
		{
			damage = Int(damage * 2);
		}
	}
	if(weapon.name == "sticky_grenade")
	{
		switch(meansOfDamage)
		{
			case "MOD_IMPACT":
			{
				entity.stuckWithStickyGrenade = 1;
				break;
			}
			case "MOD_GRENADE_SPLASH":
			{
				if(isdefined(entity.stuckWithStickyGrenade) && entity.stuckWithStickyGrenade)
				{
					damage = entity.health;
				}
				break;
			}
		}
	}
	if(meansOfDamage == "MOD_TRIGGER_HURT" && entity.ignoreTriggerDamage)
	{
		damage = 0;
	}
	return damage;
}

/*
	Name: robotDestructRandomPieces
	Namespace: RobotSoldierServerUtils
	Checksum: 0xDE7D49A2
	Offset: 0xC568
	Size: 0xF7
	Parameters: 12
	Flags: Private
*/
function private robotDestructRandomPieces(inflictor, attacker, damage, flags, meansOfDamage, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	isExplosive = IsInArray(Array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDamage);
	if(isExplosive)
	{
		DestructServerUtils::DestructRandomPieces(entity);
	}
	return damage;
}

/*
	Name: findClosestNavMeshPositionToEnemy
	Namespace: RobotSoldierServerUtils
	Checksum: 0x140A47AC
	Offset: 0xC668
	Size: 0x8B
	Parameters: 1
	Flags: Private
*/
function private findClosestNavMeshPositionToEnemy(enemy)
{
	enemyPositionOnNavMesh = undefined;
	for(toleranceLevel = 1; toleranceLevel <= 4; toleranceLevel++)
	{
		enemyPositionOnNavMesh = GetClosestPointOnNavMesh(enemy.origin, 200 * toleranceLevel, 30);
		if(isdefined(enemyPositionOnNavMesh))
		{
			break;
		}
	}
	return enemyPositionOnNavMesh;
}

/*
	Name: robotChooseCoverDirection
	Namespace: RobotSoldierServerUtils
	Checksum: 0xD150017E
	Offset: 0xC700
	Size: 0xAB
	Parameters: 2
	Flags: Private
*/
function private robotChooseCoverDirection(entity, stepOut)
{
	if(!isdefined(entity.node))
	{
		return;
	}
	coverDirection = blackboard::GetBlackBoardAttribute(entity, "_cover_direction");
	blackboard::SetBlackBoardAttribute(entity, "_previous_cover_direction", coverDirection);
	blackboard::SetBlackBoardAttribute(entity, "_cover_direction", AiUtility::calculateCoverDirection(entity, stepOut));
}

/*
	Name: robotSoldierSpawnSetup
	Namespace: RobotSoldierServerUtils
	Checksum: 0xC1EF79DD
	Offset: 0xC7B8
	Size: 0x643
	Parameters: 0
	Flags: Private
*/
function private robotSoldierSpawnSetup()
{
	entity = self;
	entity.isCrawler = 0;
	entity.becomeCrawler = 0;
	entity.combatmode = "cover";
	entity.fullHealth = entity.health;
	entity.controlLevel = 0;
	entity.steppedOutOfCover = 0;
	entity.ignoreTriggerDamage = 0;
	entity.startingWeapon = entity.weapon;
	entity.jukeDistance = 90;
	entity.jukeMaxDistance = 1200;
	entity.entityRadius = 15;
	entity.empShutdownTime = 2000;
	entity.NoFriendlyfire = 1;
	entity.ignorerunAndgundist = 1;
	entity.disableRepath = 0;
	entity.robotRusherMaxRadius = 250;
	entity.robotRusherMinRadius = 150;
	entity.gibDeath = math::cointoss();
	entity.minWalkDistance = 240;
	entity.superSprintDistance = 300;
	entity.treatAllCoversAsGeneric = 1;
	entity.onlyCrouchArrivals = 1;
	entity.chargeMeleeDistance = 125;
	entity.allowPushActors = 1;
	entity.nextPreemptiveJukeAds = RandomFloatRange(0.5, 0.95);
	entity.shouldPreemptiveJuke = math::cointoss();
	DestructServerUtils::ToggleSpawnGibs(entity, 1);
	GibServerUtils::ToggleSpawnGibs(entity, 1);
	clientfield::set("robot_mind_control", 0);
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
	entity thread CleanUpEquipment(entity);
	AiUtility::AddAIOverrideDamageCallback(entity, &DestructServerUtils::handleDamage);
	AiUtility::AddAIOverrideDamageCallback(entity, &robotDamageOverride);
	AiUtility::AddAIOverrideDamageCallback(entity, &robotDestructRandomPieces);
	AiUtility::AddAIOverrideDamageCallback(entity, &robotGibDamageOverride);
	AiUtility::AddAIOverrideKilledCallback(entity, &robotDeathOverride);
	AiUtility::AddAIOverrideKilledCallback(entity, &robotGibDeathOverride);
	AiUtility::AddAIOverrideKilledCallback(entity, &robotDestructDeathOverride);
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else if(GetDvarInt("Dev Block strings are not supported") == 2)
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else if(GetDvarInt("Dev Block strings are not supported") == 3)
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else if(GetDvarInt("Dev Block strings are not supported") == 2)
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else if(GetDvarInt("Dev Block strings are not supported") == 3)
		{
			entity ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
	if(GetDvarInt("ai_robotForceCrawler") == 1)
	{
		entity ai::set_behavior_attribute("force_crawler", "gib_legs");
	}
	else if(GetDvarInt("ai_robotForceCrawler") == 2)
	{
		entity ai::set_behavior_attribute("force_crawler", "remove_legs");
	}
}

/*
	Name: robotGiveWasp
	Namespace: RobotSoldierServerUtils
	Checksum: 0x62BCA8E2
	Offset: 0xCE08
	Size: 0xD7
	Parameters: 1
	Flags: Private
*/
function private robotGiveWasp(entity)
{
	if(isdefined(entity) && !isdefined(entity.wasp))
	{
		wasp = spawn("script_model", (0, 0, 0));
		wasp SetModel("veh_t7_drone_attack_red");
		wasp SetScale(0.75);
		wasp LinkTo(entity, "j_spine4", (5, -15, 0), VectorScale((0, 0, 1), 90));
		entity.wasp = wasp;
	}
}

/*
	Name: robotDeployWasp
	Namespace: RobotSoldierServerUtils
	Checksum: 0x72DAC310
	Offset: 0xCEE8
	Size: 0x131
	Parameters: 1
	Flags: Private
*/
function private robotDeployWasp(entity)
{
	entity endon("death");
	wait(RandomFloatRange(7, 10));
	if(isdefined(entity) && isdefined(entity.wasp))
	{
		spawnOffset = (5, -15, 0);
		while(!IsPointInNavvolume(entity.wasp.origin + spawnOffset, "small volume"))
		{
			wait(1);
		}
		entity.wasp Unlink();
		wasp = SpawnVehicle("spawner_bo3_wasp_enemy", entity.wasp.origin + spawnOffset, (0, 0, 0));
		entity.wasp delete();
	}
	entity.wasp = undefined;
}

/*
	Name: RapsDetonateCountdown
	Namespace: RobotSoldierServerUtils
	Checksum: 0x937BB8DF
	Offset: 0xD028
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private RapsDetonateCountdown(entity)
{
	entity endon("death");
	wait(RandomFloatRange(20, 30));
	raps::detonate();
}

/*
	Name: becomeCrawler
	Namespace: RobotSoldierServerUtils
	Checksum: 0xC93AA75E
	Offset: 0xD078
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private becomeCrawler(entity)
{
	if(!RobotSoldierBehavior::robotIsCrawler(entity) && entity ai::get_behavior_attribute("can_become_crawler"))
	{
		entity.becomeCrawler = 1;
	}
}

/*
	Name: CleanUpEquipment
	Namespace: RobotSoldierServerUtils
	Checksum: 0x441C4FA7
	Offset: 0xD0D8
	Size: 0x81
	Parameters: 1
	Flags: Private
*/
function private CleanUpEquipment(entity)
{
	entity waittill("death");
	if(!isdefined(entity))
	{
		return;
	}
	if(isdefined(entity.miniRaps))
	{
		entity.miniRaps = undefined;
	}
	if(isdefined(entity.wasp))
	{
		entity.wasp delete();
		entity.wasp = undefined;
	}
}

/*
	Name: forceRobotSoldierMindControlLevel1
	Namespace: RobotSoldierServerUtils
	Checksum: 0xE4268612
	Offset: 0xD168
	Size: 0x9B
	Parameters: 0
	Flags: Private
*/
function private forceRobotSoldierMindControlLevel1()
{
	entity = self;
	if(entity.controlLevel >= 1)
	{
		return;
	}
	entity.team = "team3";
	entity.controlLevel = 1;
	clientfield::set("robot_mind_control", 1);
	entity ai::set_behavior_attribute("rogue_control", "level_1");
}

/*
	Name: forceRobotSoldierMindControlLevel2
	Namespace: RobotSoldierServerUtils
	Checksum: 0x9C933B01
	Offset: 0xD210
	Size: 0x2C3
	Parameters: 0
	Flags: Private
*/
function private forceRobotSoldierMindControlLevel2()
{
	entity = self;
	if(entity.controlLevel >= 2)
	{
		return;
	}
	rogue_melee_weapon = GetWeapon("rogue_robot_melee");
	locomotionTypes = Array("alt1", "alt2", "alt3", "alt4", "alt5");
	blackboard::SetBlackBoardAttribute(entity, "_robot_locomotion_type", locomotionTypes[RandomInt(locomotionTypes.size)]);
	entity ASMSetAnimationRate(RandomFloatRange(0.95, 1.05));
	entity forceRobotSoldierMindControlLevel1();
	entity.combatmode = "no_cover";
	entity SetAvoidanceMask("avoid none");
	entity.controlLevel = 2;
	entity shared::placeWeaponOn(entity.weapon, "none");
	entity.meleeWeapon = rogue_melee_weapon;
	entity.dontDropWeapon = 1;
	entity.ignorepathenemyfightdist = 1;
	if(entity ai::get_behavior_attribute("rogue_allow_predestruct"))
	{
		DestructServerUtils::DestructRandomPieces(entity);
	}
	if(entity.health > entity.maxhealth * 0.6)
	{
		entity.health = Int(entity.maxhealth * 0.6);
	}
	clientfield::set("robot_mind_control", 2);
	entity ai::set_behavior_attribute("rogue_control", "level_2");
	entity ai::set_behavior_attribute("can_become_crawler", 0);
}

/*
	Name: forceRobotSoldierMindControlLevel3
	Namespace: RobotSoldierServerUtils
	Checksum: 0xD92E82F4
	Offset: 0xD4E0
	Size: 0x9B
	Parameters: 0
	Flags: Private
*/
function private forceRobotSoldierMindControlLevel3()
{
	entity = self;
	if(entity.controlLevel >= 3)
	{
		return;
	}
	forceRobotSoldierMindControlLevel2();
	entity.controlLevel = 3;
	clientfield::set("robot_mind_control", 3);
	entity ai::set_behavior_attribute("rogue_control", "level_3");
}

/*
	Name: robotEquipMiniRaps
	Namespace: RobotSoldierServerUtils
	Checksum: 0x1CBDF600
	Offset: 0xD588
	Size: 0x37
	Parameters: 4
	Flags: None
*/
function robotEquipMiniRaps(entity, attribute, oldValue, value)
{
	entity.miniRaps = value;
}

/*
	Name: robotLights
	Namespace: RobotSoldierServerUtils
	Checksum: 0x77EBD5C5
	Offset: 0xD5C8
	Size: 0x103
	Parameters: 4
	Flags: None
*/
function robotLights(entity, attribute, oldValue, value)
{
	if(value == 3)
	{
		clientfield::set("robot_lights", 3);
	}
	else if(value == 0)
	{
		clientfield::set("robot_lights", 0);
	}
	else if(value == 1)
	{
		clientfield::set("robot_lights", 1);
	}
	else if(value == 2)
	{
		clientfield::set("robot_lights", 2);
	}
	else if(value == 4)
	{
		clientfield::set("robot_lights", 4);
	}
}

/*
	Name: RandomGibRogueRobot
	Namespace: RobotSoldierServerUtils
	Checksum: 0xE2BE951B
	Offset: 0xD6D8
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function RandomGibRogueRobot(entity)
{
	GibServerUtils::ToggleSpawnGibs(entity, 0);
	if(math::cointoss())
	{
		if(math::cointoss())
		{
			GibServerUtils::GibRightArm(entity);
		}
		else if(math::cointoss())
		{
			GibServerUtils::GibLeftArm(entity);
		}
	}
	else if(math::cointoss())
	{
		GibServerUtils::GibLeftArm(entity);
	}
	else if(math::cointoss())
	{
		GibServerUtils::GibRightArm(entity);
	}
}

/*
	Name: rogueControlAttributeCallback
	Namespace: RobotSoldierServerUtils
	Checksum: 0x58C2CA
	Offset: 0xD7D8
	Size: 0x175
	Parameters: 4
	Flags: None
*/
function rogueControlAttributeCallback(entity, attribute, oldValue, value)
{
	switch(value)
	{
		case "forced_level_1":
		{
			if(entity.controlLevel <= 0)
			{
				forceRobotSoldierMindControlLevel1();
			}
			break;
		}
		case "forced_level_2":
		{
			if(entity.controlLevel <= 1)
			{
				forceRobotSoldierMindControlLevel2();
				DestructServerUtils::ToggleSpawnGibs(entity, 0);
				if(entity ai::get_behavior_attribute("rogue_allow_pregib"))
				{
					RandomGibRogueRobot(entity);
				}
			}
			break;
		}
		case "forced_level_3":
		{
			if(entity.controlLevel <= 2)
			{
				forceRobotSoldierMindControlLevel3();
				DestructServerUtils::ToggleSpawnGibs(entity, 0);
				if(entity ai::get_behavior_attribute("rogue_allow_pregib"))
				{
					RandomGibRogueRobot(entity);
				}
			}
			break;
		}
	}
}

/*
	Name: robotMoveModeAttributeCallback
	Namespace: RobotSoldierServerUtils
	Checksum: 0xCBB6752B
	Offset: 0xD958
	Size: 0x145
	Parameters: 4
	Flags: None
*/
function robotMoveModeAttributeCallback(entity, attribute, oldValue, value)
{
	entity.ignorepathenemyfightdist = 0;
	blackboard::SetBlackBoardAttribute(entity, "_move_mode", "normal");
	if(value != "guard")
	{
		entity.guardPosition = undefined;
	}
	switch(value)
	{
		case "normal":
		{
			break;
		}
		case "rambo":
		{
			entity.ignorepathenemyfightdist = 1;
			break;
		}
		case "marching":
		{
			entity.ignorepathenemyfightdist = 1;
			blackboard::SetBlackBoardAttribute(entity, "_move_mode", "marching");
			break;
		}
		case "rusher":
		{
			if(!entity ai::get_behavior_attribute("can_become_rusher"))
			{
				entity ai::set_behavior_attribute("move_mode", oldValue);
			}
			break;
		}
	}
}

/*
	Name: robotForceCrawler
	Namespace: RobotSoldierServerUtils
	Checksum: 0x66A94C3B
	Offset: 0xDAA8
	Size: 0x24B
	Parameters: 4
	Flags: None
*/
function robotForceCrawler(entity, attribute, oldValue, value)
{
	if(RobotSoldierBehavior::robotIsCrawler(entity))
	{
		return;
	}
	if(!entity ai::get_behavior_attribute("can_become_crawler"))
	{
		return;
	}
	switch(value)
	{
		case "normal":
		{
			return;
			break;
		}
		case "gib_legs":
		{
			GibServerUtils::ToggleSpawnGibs(entity, 1);
			DestructServerUtils::ToggleSpawnGibs(entity, 1);
			break;
		}
		case "remove_legs":
		{
			GibServerUtils::ToggleSpawnGibs(entity, 0);
			DestructServerUtils::ToggleSpawnGibs(entity, 0);
			break;
		}
	}
	if(value == "gib_legs" || value == "remove_legs")
	{
		if(math::cointoss())
		{
			if(math::cointoss())
			{
				GibServerUtils::GibRightLeg(entity);
			}
			else
			{
				GibServerUtils::GibLeftLeg(entity);
			}
		}
		else
		{
			GibServerUtils::GibLegs(entity);
		}
		if(entity.health > entity.maxhealth * 0.25)
		{
			entity.health = Int(entity.maxhealth * 0.25);
		}
		DestructServerUtils::DestructRandomPieces(entity);
		if(value == "gib_legs")
		{
			becomeCrawler(entity);
		}
		else
		{
			RobotSoldierBehavior::robotBecomeCrawler(entity);
		}
	}
}

/*
	Name: rogueControlForceGoalAttributeCallback
	Namespace: RobotSoldierServerUtils
	Checksum: 0xC2811623
	Offset: 0xDD00
	Size: 0x113
	Parameters: 4
	Flags: None
*/
function rogueControlForceGoalAttributeCallback(entity, attribute, oldValue, value)
{
	if(!IsVec(value))
	{
		return;
	}
	rogueControlled = IsInArray(Array("level_2", "level_3"), entity ai::get_behavior_attribute("rogue_control"));
	if(!rogueControlled)
	{
		entity ai::set_behavior_attribute("rogue_control_force_goal", undefined);
	}
	else
	{
		entity.favoriteenemy = undefined;
		entity clearPath();
		entity UsePosition(entity ai::get_behavior_attribute("rogue_control_force_goal"));
	}
}

/*
	Name: rogueControlSpeedAttributeCallback
	Namespace: RobotSoldierServerUtils
	Checksum: 0xBE56418
	Offset: 0xDE20
	Size: 0xC5
	Parameters: 4
	Flags: None
*/
function rogueControlSpeedAttributeCallback(entity, attribute, oldValue, value)
{
	switch(value)
	{
		case "walk":
		{
			blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_walk");
			break;
		}
		case "run":
		{
			blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_run");
			break;
		}
		case "sprint":
		{
			blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
			break;
		}
	}
}

/*
	Name: robotTraversalAttributeCallback
	Namespace: RobotSoldierServerUtils
	Checksum: 0xBB04ACC1
	Offset: 0xDEF0
	Size: 0x71
	Parameters: 4
	Flags: None
*/
function robotTraversalAttributeCallback(entity, attribute, oldValue, value)
{
	switch(value)
	{
		case "normal":
		{
			entity.manualTraverseMode = 0;
			break;
		}
		case "procedural":
		{
			entity.manualTraverseMode = 1;
			break;
		}
	}
}

