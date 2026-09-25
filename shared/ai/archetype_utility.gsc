#using scripts\shared\ai\archetype_aivsaimelee;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#namespace AiUtility;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: AiUtility
	Checksum: 0x81C2CEDF
	Offset: 0x11F8
	Size: 0xBC3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("forceRagdoll", &forceRagdoll);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasAmmo", &hasAmmo);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasLowAmmo", &hasLowAmmo);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasEnemy", &hasEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isSafeFromGrenades", &isSafeFromGrenades);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("inGrenadeBlastRadius", &inGrenadeBlastRadius);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("recentlySawEnemy", &recentlySawEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldBeAggressive", &shouldBeAggressive);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldOnlyFireAccurately", &shouldOnlyFireAccurately);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldReactToNewEnemy", &shouldReactToNewEnemy);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldReactToNewEnemy", &shouldReactToNewEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasWeaponMalfunctioned", &hasWeaponMalfunctioned);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStopMoving", &shouldStopMoving);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldStopMoving", &shouldStopMoving);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBestCoverNodeASAP", &chooseBestCoverNodeASAP);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBetterCoverService", &chooseBetterCoverServiceCodeVersion);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("trackCoverParamsService", &trackCoverParamsService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("refillAmmoIfNeededService", &refillAmmo);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryStoppingService", &tryStoppingService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isFrustrated", &isFrustrated);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("updatefrustrationLevel", &updateFrustrationLevel);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isLastKnownEnemyPositionApproachable", &isLastKnownEnemyPositionApproachable);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryAdvancingOnLastKnownPositionBehavior", &tryAdvancingOnLastKnownPositionBehavior);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryGoingToClosestNodeToEnemyBehavior", &tryGoingToClosestNodeToEnemyBehavior);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryRunningDirectlyToEnemyBehavior", &tryRunningDirectlyToEnemyBehavior);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("flagEnemyUnAttackableService", &flagEnemyUnAttackableService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keepClaimNode", &keepClaimNode);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("keepClaimNode", &keepClaimNode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("releaseClaimNode", &releaseClaimNode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("startRagdoll", &scriptStartRagdoll);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("notStandingCondition", &notStandingCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("notCrouchingCondition", &notCrouchingCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("explosiveKilled", &explosiveKilled);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("electrifiedKilled", &electrifiedKilled);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("burnedKilled", &burnedKilled);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("rapsKilled", &rapsKilled);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("meleeAcquireMutex", &meleeAcquireMutex);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("meleeReleaseMutex", &meleeReleaseMutex);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldMutexMelee", &shouldMutexMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareForExposedMelee", &prepareForExposedMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupMelee", &cleanupMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldNormalMelee", &shouldNormalMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldMelee", &shouldMelee);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldMelee", &shouldMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasCloseEnemyMelee", &hasCloseEnemyToMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isBalconyDeath", &isBalconyDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("balconyDeath", &balconyDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("useCurrentPosition", &useCurrentPosition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isUnarmed", &isUnarmed);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChargeMelee", &shouldChargeMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAttackInChargeMelee", &shouldAttackInChargeMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupChargeMelee", &cleanupChargeMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupChargeMeleeAttack", &cleanupChargeMeleeAttack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setupChargeMeleeAttack", &setupChargeMeleeAttack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialPain", &shouldChooseSpecialPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialPronePain", &shouldChooseSpecialPronePain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialDeath", &shouldChooseSpecialDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialProneDeath", &shouldChooseSpecialProneDeath);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setupExplosionAnimScale", &setupExplosionAnimScale);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStealth", &shouldStealth);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthReactCondition", &stealthReactCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionShouldStealth", &locomotionShouldStealth);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStealthResume", &shouldStealthResume);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldStealth", &locomotionShouldStealth);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("stealthReactCondition", &stealthReactCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthReactStart", &stealthReactStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthReactTerminate", &stealthReactTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthIdleTerminate", &stealthIdleTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isInPhalanx", &isInPhalanx);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isInPhalanxStance", &isInPhalanxStance);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("togglePhalanxStance", &togglePhalanxStance);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tookFlashbangDamage", &tookFlashbangDamage);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtAttackObject", &isAtAttackObject);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAttackObject", &shouldAttackObject);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("defaultAction", undefined, undefined, undefined);
	archetype_aivsaimelee::RegisterAIvsAIMeleeBehaviorFunctions();
}

/*
	Name: RegisterUtilityBlackboardAttributes
	Namespace: AiUtility
	Checksum: 0xF7A30878
	Offset: 0x1DC8
	Size: 0x1473
	Parameters: 0
	Flags: None
*/
function RegisterUtilityBlackboardAttributes()
{
	blackboard::RegisterBlackBoardAttribute(self, "_arrival_stance", undefined, &BB_GetArrivalStance);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_context", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_context2", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_cover_concealed", undefined, &BB_GetCoverConcealed);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_cover_direction", "cover_front_direction", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_cover_mode", "cover_mode_none", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_cover_type", undefined, &BB_GetCurrentCoverNodeType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_current_location_cover_type", undefined, &BB_GetCurrentLocationCoverNodeType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_exposed_type", undefined, &BB_GetCurrentExposedType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_damage_direction", undefined, &BB_GetDamageDirection);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_damage_location", undefined, &BB_ActorGetDamageLocation);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_damage_weapon_class", undefined, &BB_GetDamageWeaponClass);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_damage_weapon", undefined, &BB_GetDamageWeapon);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_damage_mod", undefined, &BB_GetDamageMOD);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_damage_taken", undefined, &BB_GetDamageTaken);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_desired_stance", "stand", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_enemy", undefined, &BB_ActorHasEnemy);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_enemy_yaw", undefined, &BB_ActorGetEnemyYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_react_yaw", undefined, &BB_ActorGetReactYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_fatal_damage_location", undefined, &BB_ActorGetFatalDamageLocation);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_fire_mode", undefined, &GetFireMode);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_gib_location", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_juke_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_juke_distance", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_arrival_distance", undefined, &BB_GetLocomotionArrivalDistance);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_arrival_yaw", undefined, &BB_GetLocomotionArrivalYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_exit_yaw", undefined, &BB_GetLocomotionExitYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_face_enemy_quadrant", "locomotion_face_enemy_none", &BB_GetLocomotionFaceEnemyQuadrant);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_motion_angle", undefined, &BB_GetLocomotionMotionAngle);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_face_enemy_quadrant_previous", "locomotion_face_enemy_none", &BB_GetLocomotionFaceEnemyQuadrantPrevious);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_pain_type", undefined, &BB_GetLocomotionPainType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_turn_yaw", undefined, &BB_GetLocomotionTurnYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_lookahead_angle", undefined, &BB_GetLookaheadAngle);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_patrol", undefined, &BB_ActorIsPatroling);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_perfect_enemy_yaw", undefined, &BB_ActorGetPerfectEnemyYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_previous_cover_direction", "cover_front_direction", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_previous_cover_mode", "cover_mode_none", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_previous_cover_type", undefined, &BB_GetPreviousCoverNodeType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_stance", "stand", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_traversal_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_melee_distance", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_tracking_turn_yaw", undefined, &BB_ActorGetTrackingTurnYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_weapon_class", "rifle", &BB_GetWeaponClass);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_throw_distance", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_yaw_to_cover", undefined, &BB_GetYawToCoverNode);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_special_death", "none", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_awareness", "combat", &BB_GetAwareness);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_awareness_prev", "combat", &BB_GetAwarenessPrevious);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_melee_enemy_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_staircase_num_steps", 0, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_staircase_num_total_steps", 0, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_staircase_state", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_staircase_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_staircase_exit_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_staircase_skip_num", undefined, &BB_GetStairsNumSkipSteps);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	/#
		self function_89398c57();
	#/
}

/*
	Name: BB_GetStairsNumSkipSteps
	Namespace: AiUtility
	Checksum: 0xD13A6D5A
	Offset: 0x3248
	Size: 0x171
	Parameters: 0
	Flags: Private
*/
function private BB_GetStairsNumSkipSteps()
{
	/#
		Assert(isdefined(self._stairsStartNode) && isdefined(self._stairsEndNode));
	#/
	numTotalSteps = blackboard::GetBlackBoardAttribute(self, "_staircase_num_total_steps");
	stepsSoFar = blackboard::GetBlackBoardAttribute(self, "_staircase_num_steps");
	direction = blackboard::GetBlackBoardAttribute(self, "_staircase_direction");
	numOutSteps = 2;
	totalStepsWithoutOut = numTotalSteps - numOutSteps;
	/#
		Assert(stepsSoFar < totalStepsWithoutOut);
	#/
	remainingSteps = totalStepsWithoutOut - stepsSoFar;
	if(remainingSteps >= 8)
	{
		return "staircase_skip_8";
	}
	else if(remainingSteps >= 6)
	{
		return "staircase_skip_6";
	}
	/#
		Assert(remainingSteps >= 3);
	#/
	return "staircase_skip_3";
}

/*
	Name: BB_GetAwareness
	Namespace: AiUtility
	Checksum: 0x78059B88
	Offset: 0x33C8
	Size: 0x31
	Parameters: 0
	Flags: Private
*/
function private BB_GetAwareness()
{
	if(!isdefined(self.stealth) || !isdefined(self.awarenesslevelcurrent))
	{
		return "combat";
	}
	return self.awarenesslevelcurrent;
}

/*
	Name: BB_GetAwarenessPrevious
	Namespace: AiUtility
	Checksum: 0xB7C38009
	Offset: 0x3408
	Size: 0x31
	Parameters: 0
	Flags: Private
*/
function private BB_GetAwarenessPrevious()
{
	if(!isdefined(self.stealth) || !isdefined(self.awarenesslevelprevious))
	{
		return "combat";
	}
	return self.awarenesslevelprevious;
}

/*
	Name: BB_GetYawToCoverNode
	Namespace: AiUtility
	Checksum: 0xA809B14A
	Offset: 0x3448
	Size: 0x103
	Parameters: 0
	Flags: Private
*/
function private BB_GetYawToCoverNode()
{
	if(!isdefined(self.node))
	{
		return 0;
	}
	distToNodeSqr = Distance2DSquared(self GetNodeOffsetPosition(self.node), self.origin);
	if(isdefined(self.keepClaimedNode) && self.keepClaimedNode)
	{
		if(distToNodeSqr > 64 * 64)
		{
			return 0;
		}
	}
	else if(distToNodeSqr > 24 * 24)
	{
		return 0;
	}
	angleToNode = ceil(AngleClamp180(self.angles[1] - self GetNodeOffsetAngles(self.node)[1]));
	return angleToNode;
}

/*
	Name: BB_GetHighestStance
	Namespace: AiUtility
	Checksum: 0xE9E0E492
	Offset: 0x3558
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function BB_GetHighestStance()
{
	if(self IsAtCoverNodeStrict() && self ShouldUseCoverNode())
	{
		highestStance = getHighestNodeStance(self.node);
		return highestStance;
	}
	else
	{
		return blackboard::GetBlackBoardAttribute(self, "_stance");
	}
}

/*
	Name: BB_GetLocomotionFaceEnemyQuadrantPrevious
	Namespace: AiUtility
	Checksum: 0xA133A32A
	Offset: 0x35E0
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function BB_GetLocomotionFaceEnemyQuadrantPrevious()
{
	if(isdefined(self.prevrelativedir))
	{
		direction = self.prevrelativedir;
		switch(direction)
		{
			case 0:
			{
				return "locomotion_face_enemy_none";
			}
			case 1:
			{
				return "locomotion_face_enemy_front";
			}
			case 2:
			{
				return "locomotion_face_enemy_right";
			}
			case 3:
			{
				return "locomotion_face_enemy_left";
			}
			case 4:
			{
				return "locomotion_face_enemy_back";
			}
		}
	}
	return "locomotion_face_enemy_none";
}

/*
	Name: BB_GetCurrentCoverNodeType
	Namespace: AiUtility
	Checksum: 0x3873AA34
	Offset: 0x3678
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function BB_GetCurrentCoverNodeType()
{
	return getCoverType(self.node);
}

/*
	Name: BB_GetCoverConcealed
	Namespace: AiUtility
	Checksum: 0xCEF8CF82
	Offset: 0x36A0
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function BB_GetCoverConcealed()
{
	if(isCoverConcealed(self.node))
	{
		return "concealed";
	}
	return "unconcealed";
}

/*
	Name: BB_GetCurrentLocationCoverNodeType
	Namespace: AiUtility
	Checksum: 0xA330E2B
	Offset: 0x36D8
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function BB_GetCurrentLocationCoverNodeType()
{
	if(isdefined(self.node) && DistanceSquared(self.origin, self.node.origin) < 48 * 48)
	{
		return BB_GetCurrentCoverNodeType();
	}
	return BB_GetPreviousCoverNodeType();
}

/*
	Name: BB_GetDamageDirection
	Namespace: AiUtility
	Checksum: 0x9BFF02AA
	Offset: 0x3750
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function BB_GetDamageDirection()
{
	/#
		if(isdefined(level._debug_damage_direction))
		{
			return level._debug_damage_direction;
		}
	#/
	if(self.damageyaw > 135 || self.damageyaw <= -135)
	{
		self.damage_direction = "front";
		return "front";
	}
	if(self.damageyaw > 45 && self.damageyaw <= 135)
	{
		self.damage_direction = "right";
		return "right";
	}
	if(self.damageyaw > -45 && self.damageyaw <= 45)
	{
		self.damage_direction = "back";
		return "back";
	}
	self.damage_direction = "left";
	return "left";
}

/*
	Name: BB_ActorGetDamageLocation
	Namespace: AiUtility
	Checksum: 0x59120EC0
	Offset: 0x3838
	Size: 0x3AF
	Parameters: 0
	Flags: None
*/
function BB_ActorGetDamageLocation()
{
	/#
		if(isdefined(level._debug_damage_pain_location))
		{
			return level._debug_damage_pain_location;
		}
	#/
	sHitLoc = self.damagelocation;
	possibleHitLocations = Array();
	if(IsInArray(Array("helmet", "head", "neck"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "head";
	}
	if(IsInArray(Array("torso_upper", "torso_mid"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "chest";
	}
	if(IsInArray(Array("torso_lower"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "groin";
	}
	if(IsInArray(Array("torso_lower"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "legs";
	}
	if(IsInArray(Array("left_arm_upper", "left_arm_lower", "left_hand"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "left_arm";
	}
	if(IsInArray(Array("right_arm_upper", "right_arm_lower", "right_hand", "gun"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "right_arm";
	}
	if(IsInArray(Array("right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot"), sHitLoc))
	{
		possibleHitLocations[possibleHitLocations.size] = "legs";
	}
	if(isdefined(self.lastDamageTime) && GetTime() > self.lastDamageTime && GetTime() <= self.lastDamageTime + 1000)
	{
		if(isdefined(self.lastDamageLocation))
		{
			ArrayRemoveValue(possibleHitLocations, self.lastDamageLocation);
		}
	}
	if(possibleHitLocations.size == 0)
	{
		possibleHitLocations = undefined;
		possibleHitLocations = [];
		possibleHitLocations[0] = "chest";
		possibleHitLocations[1] = "groin";
	}
	/#
		Assert(possibleHitLocations.size > 0, possibleHitLocations.size);
	#/
	damagelocation = possibleHitLocations[RandomInt(possibleHitLocations.size)];
	self.lastDamageLocation = damagelocation;
	return damagelocation;
}

/*
	Name: BB_GetDamageWeaponClass
	Namespace: AiUtility
	Checksum: 0x9B9E2AD9
	Offset: 0x3BF0
	Size: 0x185
	Parameters: 0
	Flags: None
*/
function BB_GetDamageWeaponClass()
{
	if(isdefined(self.damageMod))
	{
		if(IsInArray(Array("mod_rifle_bullet"), ToLower(self.damageMod)))
		{
			return "rifle";
		}
		if(IsInArray(Array("mod_pistol_bullet"), ToLower(self.damageMod)))
		{
			return "pistol";
		}
		if(IsInArray(Array("mod_melee", "mod_melee_assassinate", "mod_melee_weapon_butt"), ToLower(self.damageMod)))
		{
			return "melee";
		}
		if(IsInArray(Array("mod_grenade", "mod_grenade_splash", "mod_projectile", "mod_projectile_splash", "mod_explosive"), ToLower(self.damageMod)))
		{
			return "explosive";
		}
	}
	return "rifle";
}

/*
	Name: BB_GetDamageWeapon
	Namespace: AiUtility
	Checksum: 0xAC418644
	Offset: 0x3D80
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function BB_GetDamageWeapon()
{
	if(isdefined(self.special_weapon) && isdefined(self.special_weapon.name))
	{
		return self.special_weapon.name;
	}
	if(isdefined(self.damageWeapon) && isdefined(self.damageWeapon.name))
	{
		return self.damageWeapon.name;
	}
	return "unknown";
}

/*
	Name: BB_GetDamageMOD
	Namespace: AiUtility
	Checksum: 0x651ACE7B
	Offset: 0x3DF8
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function BB_GetDamageMOD()
{
	if(isdefined(self.damageMod))
	{
		return ToLower(self.damageMod);
	}
	return "unknown";
}

/*
	Name: BB_GetDamageTaken
	Namespace: AiUtility
	Checksum: 0x639EFCA2
	Offset: 0x3E38
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function BB_GetDamageTaken()
{
	/#
		if(isdefined(level._debug_damage_intensity))
		{
			return level._debug_damage_intensity;
		}
	#/
	damageTaken = self.damageTaken;
	maxhealth = self.maxhealth;
	damageTakenType = "light";
	if(isalive(self))
	{
		Ratio = damageTaken / self.maxhealth;
		if(Ratio > 0.7)
		{
			damageTakenType = "heavy";
		}
		self.lastDamageTime = GetTime();
	}
	else
	{
		Ratio = damageTaken / self.maxhealth;
		if(Ratio > 0.7)
		{
			damageTakenType = "heavy";
		}
	}
	return damageTakenType;
}

/*
	Name: AddAIOverrideDamageCallback
	Namespace: AiUtility
	Checksum: 0x3C02B16F
	Offset: 0x3F30
	Size: 0x2A5
	Parameters: 3
	Flags: None
*/
function AddAIOverrideDamageCallback(entity, callback, addToFront)
{
	/#
		Assert(IsEntity(entity));
	#/
	/#
		Assert(IsFunctionPtr(callback));
	#/
	/#
		Assert(!isdefined(entity.aiOverrideDamage) || IsArray(entity.aiOverrideDamage));
	#/
	if(!isdefined(entity.aiOverrideDamage))
	{
		entity.aiOverrideDamage = [];
	}
	else if(!IsArray(entity.aiOverrideDamage))
	{
		entity.aiOverrideDamage = Array(entity.aiOverrideDamage);
	}
	if(isdefined(addToFront) && addToFront)
	{
		damageOverrides = [];
		damageOverrides[damageOverrides.size] = callback;
		foreach(override in entity.aiOverrideDamage)
		{
			damageOverrides[damageOverrides.size] = override;
		}
		entity.aiOverrideDamage = damageOverrides;
	}
	else if(!isdefined(entity.aiOverrideDamage))
	{
		entity.aiOverrideDamage = [];
	}
	else if(!IsArray(entity.aiOverrideDamage))
	{
		entity.aiOverrideDamage = Array(entity.aiOverrideDamage);
	}
	entity.aiOverrideDamage[entity.aiOverrideDamage.size] = callback;
}

/*
	Name: RemoveAIOverrideDamageCallback
	Namespace: AiUtility
	Checksum: 0x6242B1B
	Offset: 0x41E0
	Size: 0x177
	Parameters: 2
	Flags: None
*/
function RemoveAIOverrideDamageCallback(entity, callback)
{
	/#
		Assert(IsEntity(entity));
	#/
	/#
		Assert(IsFunctionPtr(callback));
	#/
	/#
		Assert(IsArray(entity.aiOverrideDamage));
	#/
	currentDamageCallbacks = entity.aiOverrideDamage;
	entity.aiOverrideDamage = [];
	foreach(value in currentDamageCallbacks)
	{
		if(value != callback)
		{
			entity.aiOverrideDamage[entity.aiOverrideDamage.size] = value;
		}
	}
}

/*
	Name: ClearAIOverrideDamageCallbacks
	Namespace: AiUtility
	Checksum: 0xEBE463BB
	Offset: 0x4360
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function ClearAIOverrideDamageCallbacks(entity)
{
	entity.aiOverrideDamage = [];
}

/*
	Name: AddAIOverrideKilledCallback
	Namespace: AiUtility
	Checksum: 0x91EE66FE
	Offset: 0x4388
	Size: 0x155
	Parameters: 2
	Flags: None
*/
function AddAIOverrideKilledCallback(entity, callback)
{
	/#
		Assert(IsEntity(entity));
	#/
	/#
		Assert(IsFunctionPtr(callback));
	#/
	/#
		Assert(!isdefined(entity.aiOverrideKilled) || IsArray(entity.aiOverrideKilled));
	#/
	if(!isdefined(entity.aiOverrideKilled))
	{
		entity.aiOverrideKilled = [];
	}
	else if(!IsArray(entity.aiOverrideKilled))
	{
		entity.aiOverrideKilled = Array(entity.aiOverrideKilled);
	}
	entity.aiOverrideKilled[entity.aiOverrideKilled.size] = callback;
}

/*
	Name: ActorGetPredictedYawToEnemy
	Namespace: AiUtility
	Checksum: 0xCFB8CFAC
	Offset: 0x44E8
	Size: 0x19F
	Parameters: 2
	Flags: None
*/
function ActorGetPredictedYawToEnemy(entity, lookAheadTime)
{
	if(isdefined(entity.predictedYawToEnemy) && isdefined(entity.predictedYawToEnemyTime) && entity.predictedYawToEnemyTime == GetTime())
	{
		return entity.predictedYawToEnemy;
	}
	selfPredictedPos = entity.origin;
	moveAngle = entity.angles[1] + entity getMotionAngle();
	selfPredictedPos = selfPredictedPos + (cos(moveAngle), sin(moveAngle), 0) * 200 * lookAheadTime;
	yaw = VectorToAngles(entity lastKnownPos(entity.enemy) - selfPredictedPos)[1] - entity.angles[1];
	yaw = AbsAngleClamp360(yaw);
	entity.predictedYawToEnemy = yaw;
	entity.predictedYawToEnemyTime = GetTime();
	return yaw;
}

/*
	Name: BB_ActorIsPatroling
	Namespace: AiUtility
	Checksum: 0x6B31EE94
	Offset: 0x4690
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function BB_ActorIsPatroling()
{
	entity = self;
	if(entity ai::has_behavior_attribute("patrol") && entity ai::get_behavior_attribute("patrol"))
	{
		return "patrol_enabled";
	}
	return "patrol_disabled";
}

/*
	Name: BB_ActorHasEnemy
	Namespace: AiUtility
	Checksum: 0xDD5DC8D1
	Offset: 0x4700
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function BB_ActorHasEnemy()
{
	entity = self;
	if(isdefined(entity.enemy))
	{
		return "has_enemy";
	}
	return "no_enemy";
}

/*
	Name: BB_ActorGetEnemyYaw
	Namespace: AiUtility
	Checksum: 0x60F0ABE7
	Offset: 0x4740
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function BB_ActorGetEnemyYaw()
{
	enemy = self.enemy;
	if(!isdefined(enemy))
	{
		return 0;
	}
	toEnemyYaw = ActorGetPredictedYawToEnemy(self, 0.2);
	return toEnemyYaw;
}

/*
	Name: BB_ActorGetPerfectEnemyYaw
	Namespace: AiUtility
	Checksum: 0x7BF7E136
	Offset: 0x47A0
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function BB_ActorGetPerfectEnemyYaw()
{
	enemy = self.enemy;
	if(!isdefined(enemy))
	{
		return 0;
	}
	toEnemyYaw = VectorToAngles(enemy.origin - self.origin)[1] - self.angles[1];
	toEnemyYaw = AbsAngleClamp360(toEnemyYaw);
	/#
		recordEntText("Dev Block strings are not supported" + toEnemyYaw, self, (1, 0, 0), "Dev Block strings are not supported");
	#/
	return toEnemyYaw;
}

/*
	Name: BB_ActorGetReactYaw
	Namespace: AiUtility
	Checksum: 0x5D1480D
	Offset: 0x4868
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function BB_ActorGetReactYaw()
{
	result = 0;
	if(isdefined(self.REACT_YAW))
	{
		result = self.REACT_YAW;
		self.REACT_YAW = undefined;
	}
	else
	{
		v_origin = self GetEventPointOfInterest();
		if(isdefined(v_origin))
		{
			str_typeName = self GetCurrentEventTypeName();
			e_originator = self GetCurrentEventOriginator();
			if(str_typeName == "bullet" && isdefined(e_originator))
			{
				v_origin = e_originator.origin;
			}
			deltaOrigin = v_origin - self.origin;
			deltaAngles = VectorToAngles(deltaOrigin);
			result = AbsAngleClamp360(self.angles[1] - deltaAngles[1]);
		}
	}
	return result;
}

/*
	Name: BB_ActorGetFatalDamageLocation
	Namespace: AiUtility
	Checksum: 0x2D79FA1B
	Offset: 0x49B0
	Size: 0x247
	Parameters: 0
	Flags: None
*/
function BB_ActorGetFatalDamageLocation()
{
	/#
		if(isdefined(level._debug_damage_location))
		{
			return level._debug_damage_location;
		}
	#/
	sHitLoc = self.damagelocation;
	if(isdefined(sHitLoc))
	{
		if(IsInArray(Array("helmet", "head", "neck"), sHitLoc))
		{
			return "head";
		}
		if(IsInArray(Array("torso_upper", "torso_mid"), sHitLoc))
		{
			return "chest";
		}
		if(IsInArray(Array("torso_lower"), sHitLoc))
		{
			return "hips";
		}
		if(IsInArray(Array("right_arm_upper", "right_arm_lower", "right_hand", "gun"), sHitLoc))
		{
			return "right_arm";
		}
		if(IsInArray(Array("left_arm_upper", "left_arm_lower", "left_hand"), sHitLoc))
		{
			return "left_arm";
		}
		if(IsInArray(Array("right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot"), sHitLoc))
		{
			return "legs";
		}
	}
	randomLocs = Array("chest", "hips");
	return randomLocs[RandomInt(randomLocs.size)];
}

/*
	Name: GetAngleUsingDirection
	Namespace: AiUtility
	Checksum: 0xF3FC01FD
	Offset: 0x4C00
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function GetAngleUsingDirection(direction)
{
	directionYaw = VectorToAngles(direction)[1];
	yawDiff = directionYaw - self.angles[1];
	yawDiff = yawDiff * 0.002777778;
	flooredYawDiff = floor(yawDiff + 0.5);
	turnAngle = yawDiff - flooredYawDiff * 360;
	return AbsAngleClamp360(turnAngle);
}

/*
	Name: wasAtCoverNode
	Namespace: AiUtility
	Checksum: 0xEF2633E8
	Offset: 0x4CD8
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function wasAtCoverNode()
{
	if(isdefined(self.prevnode))
	{
		if(self.prevnode.type == "Cover Left" || self.prevnode.type == "Cover Right" || self.prevnode.type == "Cover Pillar" || (self.prevnode.type == "Cover Stand" || self.prevnode.type == "Conceal Stand") || (self.prevnode.type == "Cover Crouch" || self.prevnode.type == "Cover Crouch Window" || self.prevnode.type == "Conceal Crouch"))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: BB_GetLocomotionExitYaw
	Namespace: AiUtility
	Checksum: 0x76AF89D3
	Offset: 0x4DD8
	Size: 0x4D7
	Parameters: 2
	Flags: None
*/
function BB_GetLocomotionExitYaw(blackboard, yaw)
{
	exitYaw = undefined;
	if(self HasPath())
	{
		predictedLookAheadInfo = self PredictExit();
		status = predictedLookAheadInfo["path_prediction_status"];
		if(!isdefined(self.pathGoalPos))
		{
			return -1;
		}
		if(DistanceSquared(self.origin, self.pathGoalPos) <= 4096)
		{
			return -1;
		}
		if(status == 3)
		{
			start = self.origin;
			end = start + VectorScale((0, predictedLookAheadInfo["path_prediction_travel_vector"][1], 0), 100);
			angleToExit = VectorToAngles(predictedLookAheadInfo["path_prediction_travel_vector"])[1];
			exitYaw = AbsAngleClamp360(angleToExit - self.prevnode.angles[1]);
		}
		else if(status == 4)
		{
			start = self.origin;
			end = start + VectorScale((0, predictedLookAheadInfo["path_prediction_travel_vector"][1], 0), 100);
			angleToExit = VectorToAngles(predictedLookAheadInfo["path_prediction_travel_vector"])[1];
			exitYaw = AbsAngleClamp360(angleToExit - self.angles[1]);
		}
		else if(status == 0)
		{
			if(wasAtCoverNode() && DistanceSquared(self.prevnode.origin, self.origin) < 25)
			{
				end = self.pathGoalPos;
				angleToDestination = VectorToAngles(end - self.origin)[1];
				angleDifference = AbsAngleClamp360(angleToDestination - self.prevnode.angles[1]);
				return angleDifference;
			}
			start = predictedLookAheadInfo["path_prediction_start_point"];
			end = start + predictedLookAheadInfo["path_prediction_travel_vector"];
			exitYaw = GetAngleUsingDirection(predictedLookAheadInfo["path_prediction_travel_vector"]);
		}
		else if(status == 2)
		{
			if(DistanceSquared(self.origin, self.pathGoalPos) <= 4096)
			{
				return undefined;
			}
			if(wasAtCoverNode() && DistanceSquared(self.prevnode.origin, self.origin) < 25)
			{
				end = self.pathGoalPos;
				angleToDestination = VectorToAngles(end - self.origin)[1];
				angleDifference = AbsAngleClamp360(angleToDestination - self.prevnode.angles[1]);
				return angleDifference;
			}
			start = self.origin;
			end = self.pathGoalPos;
			exitYaw = GetAngleUsingDirection(VectorNormalize(end - start));
		}
	}
	/#
		if(isdefined(exitYaw))
		{
			Record3DText("Dev Block strings are not supported" + Int(exitYaw), self.origin - VectorScale((0, 0, 1), 5), (1, 0, 0), "Dev Block strings are not supported", undefined, 0.4);
		}
	#/
	return exitYaw;
}

/*
	Name: BB_GetLocomotionFaceEnemyQuadrant
	Namespace: AiUtility
	Checksum: 0x2AD31C48
	Offset: 0x52B8
	Size: 0xFD
	Parameters: 0
	Flags: None
*/
function BB_GetLocomotionFaceEnemyQuadrant()
{
	/#
		walkString = GetDvarString("Dev Block strings are not supported");
		switch(walkString)
		{
			case "Dev Block strings are not supported":
			{
				return "Dev Block strings are not supported";
			}
			case "Dev Block strings are not supported":
			{
				return "Dev Block strings are not supported";
			}
			case "Dev Block strings are not supported":
			{
				return "Dev Block strings are not supported";
			}
		}
	#/
	if(isdefined(self.relativedir))
	{
		direction = self.relativedir;
		switch(direction)
		{
			case 0:
			{
				return "locomotion_face_enemy_front";
			}
			case 1:
			{
				return "locomotion_face_enemy_front";
			}
			case 2:
			{
				return "locomotion_face_enemy_right";
			}
			case 3:
			{
				return "locomotion_face_enemy_left";
			}
			case 4:
			{
				return "locomotion_face_enemy_back";
			}
		}
	}
	return "locomotion_face_enemy_front";
}

/*
	Name: BB_GetLocomotionPainType
	Namespace: AiUtility
	Checksum: 0xAD389B7D
	Offset: 0x53C0
	Size: 0x291
	Parameters: 0
	Flags: None
*/
function BB_GetLocomotionPainType()
{
	if(self HasPath())
	{
		predictedLookAheadInfo = self PredictPath();
		status = predictedLookAheadInfo["path_prediction_status"];
		startPos = self.origin;
		furthestPointTowardsGoalClear = 1;
		if(status == 2)
		{
			furthestPointAlongTowardsGoal = startPos + VectorScale(self.lookaheaddir, 300);
			furthestPointTowardsGoalClear = self FindPath(startPos, furthestPointAlongTowardsGoal, 0, 0) && self MayMoveToPoint(furthestPointAlongTowardsGoal);
		}
		if(furthestPointTowardsGoalClear)
		{
			forwardDir = AnglesToForward(self.angles);
			possiblePainTypes = [];
			endPos = startPos + VectorScale(forwardDir, 300);
			if(self MayMoveToPoint(endPos) && self FindPath(startPos, endPos, 0, 0))
			{
				possiblePainTypes[possiblePainTypes.size] = "locomotion_moving_pain_long";
			}
			endPos = startPos + VectorScale(forwardDir, 200);
			if(self MayMoveToPoint(endPos) && self FindPath(startPos, endPos, 0, 0))
			{
				possiblePainTypes[possiblePainTypes.size] = "locomotion_moving_pain_med";
			}
			endPos = startPos + VectorScale(forwardDir, 150);
			if(self MayMoveToPoint(endPos) && self FindPath(startPos, endPos, 0, 0))
			{
				possiblePainTypes[possiblePainTypes.size] = "locomotion_moving_pain_short";
			}
			if(possiblePainTypes.size)
			{
				return Array::random(possiblePainTypes);
			}
		}
	}
	return "locomotion_inplace_pain";
}

/*
	Name: BB_GetLookaheadAngle
	Namespace: AiUtility
	Checksum: 0x6A3DEA29
	Offset: 0x5660
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function BB_GetLookaheadAngle()
{
	return AbsAngleClamp360(VectorToAngles(self.lookaheaddir)[1] - self.angles[1]);
}

/*
	Name: BB_GetPreviousCoverNodeType
	Namespace: AiUtility
	Checksum: 0x82698B53
	Offset: 0x56B0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function BB_GetPreviousCoverNodeType()
{
	return getCoverType(self.prevnode);
}

/*
	Name: BB_ActorGetTrackingTurnYaw
	Namespace: AiUtility
	Checksum: 0x8407ABE8
	Offset: 0x56D8
	Size: 0x185
	Parameters: 0
	Flags: None
*/
function BB_ActorGetTrackingTurnYaw()
{
	PixBeginEvent("BB_ActorGetTrackingTurnYaw");
	if(isdefined(self.enemy))
	{
		predictedPos = undefined;
		if(Distance2DSquared(self.enemy.origin, self.origin) < 180 * 180)
		{
			predictedPos = self.enemy.origin;
			self.newEnemyReaction = 0;
		}
		else if(!IsSentient(self.enemy) || self LastKnownTime(self.enemy) + 5000 >= GetTime())
		{
			predictedPos = self lastKnownPos(self.enemy);
		}
		if(isdefined(predictedPos))
		{
			turnYaw = AbsAngleClamp360(self.angles[1] - VectorToAngles(predictedPos - self.origin)[1]);
			PixEndEvent();
			return turnYaw;
		}
	}
	PixEndEvent();
	return undefined;
}

/*
	Name: BB_GetWeaponClass
	Namespace: AiUtility
	Checksum: 0x64665720
	Offset: 0x5868
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function BB_GetWeaponClass()
{
	return "rifle";
}

/*
	Name: notStandingCondition
	Namespace: AiUtility
	Checksum: 0xAEA3E2B8
	Offset: 0x5880
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function notStandingCondition(behaviorTreeEntity)
{
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance") != "stand")
	{
		return 1;
	}
	return 0;
}

/*
	Name: notCrouchingCondition
	Namespace: AiUtility
	Checksum: 0x4A7E164
	Offset: 0x58C8
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function notCrouchingCondition(behaviorTreeEntity)
{
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance") != "crouch")
	{
		return 1;
	}
	return 0;
}

/*
	Name: scriptStartRagdoll
	Namespace: AiUtility
	Checksum: 0xC476784
	Offset: 0x5910
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function scriptStartRagdoll(behaviorTreeEntity)
{
	behaviorTreeEntity StartRagdoll();
}

/*
	Name: prepareForExposedMelee
	Namespace: AiUtility
	Checksum: 0x74F6C3F2
	Offset: 0x5940
	Size: 0x123
	Parameters: 1
	Flags: Private
*/
function private prepareForExposedMelee(behaviorTreeEntity)
{
	keepClaimNode(behaviorTreeEntity);
	meleeAcquireMutex(behaviorTreeEntity);
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(isdefined(behaviorTreeEntity.enemy) && isdefined(behaviorTreeEntity.enemy.vehicleType) && IsSubStr(behaviorTreeEntity.enemy.vehicleType, "firefly"))
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_melee_enemy_type", "fireflyswarm");
	}
	if(currentStance == "crouch")
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
	}
}

/*
	Name: isFrustrated
	Namespace: AiUtility
	Checksum: 0x34E788
	Offset: 0x5A70
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function isFrustrated(behaviorTreeEntity)
{
	return isdefined(behaviorTreeEntity.frustrationLevel) && behaviorTreeEntity.frustrationLevel > 0;
}

/*
	Name: clampFrustration
	Namespace: AiUtility
	Checksum: 0xC5EEEE0B
	Offset: 0x5AB0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function clampFrustration(frustrationLevel)
{
	if(frustrationLevel > 4)
	{
		return 4;
	}
	else if(frustrationLevel < 0)
	{
		return 0;
	}
	return frustrationLevel;
}

/*
	Name: updateFrustrationLevel
	Namespace: AiUtility
	Checksum: 0x12C279A4
	Offset: 0x5AF0
	Size: 0x3C7
	Parameters: 1
	Flags: None
*/
function updateFrustrationLevel(entity)
{
	if(!entity isBadGuy())
	{
		return 0;
	}
	if(!isdefined(entity.frustrationLevel))
	{
		entity.frustrationLevel = 0;
	}
	if(!isdefined(entity.enemy))
	{
		entity.frustrationLevel = 0;
		return 0;
	}
	/#
		Record3DText("Dev Block strings are not supported" + entity.frustrationLevel, entity.origin, (1, 0.5, 0), "Dev Block strings are not supported");
	#/
	if(IsActor(entity.enemy) || isPlayer(entity.enemy))
	{
		if(entity.aggressiveMode)
		{
			if(!isdefined(entity.var_533cea8f))
			{
				entity.var_533cea8f = GetTime();
			}
			if(entity.var_533cea8f + 5000 < GetTime())
			{
				entity.frustrationLevel++;
				entity.var_533cea8f = GetTime();
				entity.frustrationLevel = clampFrustration(entity.frustrationLevel);
			}
		}
		var_bdd60ef6 = GetTime() - entity LastKnownTime(entity.enemy) < 10000;
		if(entity.frustrationLevel == 4)
		{
			var_e44b5d2a = entity SeeRecently(entity.enemy, 2);
		}
		else
		{
			var_e44b5d2a = entity SeeRecently(entity.enemy, 5);
		}
		var_5f85fccc = entity AttackedRecently(entity.enemy, 5);
		if(!var_bdd60ef6 || IsActor(entity.enemy))
		{
			if(!var_e44b5d2a)
			{
				entity.frustrationLevel++;
			}
			else if(!var_5f85fccc)
			{
				entity.frustrationLevel = entity.frustrationLevel + 2;
			}
			entity.frustrationLevel = clampFrustration(entity.frustrationLevel);
			return 1;
		}
		if(var_5f85fccc)
		{
			entity.frustrationLevel = entity.frustrationLevel - 2;
			entity.frustrationLevel = clampFrustration(entity.frustrationLevel);
			return 1;
		}
		else if(var_e44b5d2a)
		{
			entity.frustrationLevel--;
			entity.frustrationLevel = clampFrustration(entity.frustrationLevel);
			return 1;
		}
	}
	return 0;
}

/*
	Name: flagEnemyUnAttackableService
	Namespace: AiUtility
	Checksum: 0x4763758C
	Offset: 0x5EC0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function flagEnemyUnAttackableService(behaviorTreeEntity)
{
	behaviorTreeEntity FlagEnemyUnattackable();
}

/*
	Name: isLastKnownEnemyPositionApproachable
	Namespace: AiUtility
	Checksum: 0x173546C
	Offset: 0x5EF0
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function isLastKnownEnemyPositionApproachable(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		var_d24ee4b0 = behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy);
		if(behaviorTreeEntity isInGoal(var_d24ee4b0) && behaviorTreeEntity FindPath(behaviorTreeEntity.origin, var_d24ee4b0, 1, 0))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: tryAdvancingOnLastKnownPositionBehavior
	Namespace: AiUtility
	Checksum: 0x7CA6E48F
	Offset: 0x5FA0
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function tryAdvancingOnLastKnownPositionBehavior(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		if(isdefined(behaviorTreeEntity.aggressiveMode) && behaviorTreeEntity.aggressiveMode)
		{
			var_d24ee4b0 = behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy);
			if(behaviorTreeEntity isInGoal(var_d24ee4b0) && behaviorTreeEntity FindPath(behaviorTreeEntity.origin, var_d24ee4b0, 1, 0))
			{
				behaviorTreeEntity UsePosition(var_d24ee4b0, var_d24ee4b0);
				setNextFindBestCoverTime(behaviorTreeEntity, undefined);
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: tryGoingToClosestNodeToEnemyBehavior
	Namespace: AiUtility
	Checksum: 0x85BC35A6
	Offset: 0x60B0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function tryGoingToClosestNodeToEnemyBehavior(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		closestRandomNode = behaviorTreeEntity FindBestCoverNodes(behaviorTreeEntity.engageMaxDist, behaviorTreeEntity.enemy.origin)[0];
		if(isdefined(closestRandomNode) && behaviorTreeEntity isInGoal(closestRandomNode.origin) && behaviorTreeEntity FindPath(behaviorTreeEntity.origin, closestRandomNode.origin, 1, 0))
		{
			useCoverNodeWrapper(behaviorTreeEntity, closestRandomNode);
			return 1;
		}
	}
	return 0;
}

/*
	Name: tryRunningDirectlyToEnemyBehavior
	Namespace: AiUtility
	Checksum: 0xA78B0691
	Offset: 0x61B0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function tryRunningDirectlyToEnemyBehavior(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy) && (isdefined(behaviorTreeEntity.aggressiveMode) && behaviorTreeEntity.aggressiveMode))
	{
		origin = behaviorTreeEntity.enemy.origin;
		if(behaviorTreeEntity isInGoal(origin) && behaviorTreeEntity FindPath(behaviorTreeEntity.origin, origin, 1, 0))
		{
			behaviorTreeEntity UsePosition(origin, origin);
			setNextFindBestCoverTime(behaviorTreeEntity, undefined);
			return 1;
		}
	}
	return 0;
}

/*
	Name: shouldReactToNewEnemy
	Namespace: AiUtility
	Checksum: 0x9691D3C2
	Offset: 0x62B0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function shouldReactToNewEnemy(behaviorTreeEntity)
{
	return 0;
	if(isdefined(behaviorTreeEntity.newEnemyReaction) && behaviorTreeEntity.newEnemyReaction)
	{
		return 1;
	}
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	return stance == "stand" && behaviorTreeEntity.newEnemyReaction && !behaviorTreeEntity IsAtCoverNodeStrict();
}

/*
	Name: hasWeaponMalfunctioned
	Namespace: AiUtility
	Checksum: 0xD77D1244
	Offset: 0x6360
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function hasWeaponMalfunctioned(behaviorTreeEntity)
{
	return isdefined(behaviorTreeEntity.malFunctionReaction) && behaviorTreeEntity.malFunctionReaction;
}

/*
	Name: isSafeFromGrenades
	Namespace: AiUtility
	Checksum: 0xFA60EBB0
	Offset: 0x6398
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function isSafeFromGrenades(entity)
{
	if(isdefined(entity.grenade) && isdefined(entity.grenade.weapon) && entity.grenade !== entity.var_861b5edc && !entity IsSafeFromGrenade())
	{
		if(isdefined(entity.node))
		{
			offsetOrigin = entity GetNodeOffsetPosition(entity.node);
			var_c02c396e = Distance(entity.grenade.origin, offsetOrigin);
			if(entity.grenadeawareness >= var_c02c396e)
			{
				return 1;
			}
		}
		else
		{
			var_c02c396e = Distance(entity.grenade.origin, entity.origin) / entity.grenade.weapon.explosionRadius;
			if(entity.grenadeawareness >= var_c02c396e)
			{
				return 1;
			}
		}
		entity.var_861b5edc = entity.grenade;
		return 0;
	}
	return 1;
}

/*
	Name: inGrenadeBlastRadius
	Namespace: AiUtility
	Checksum: 0x80CD33D0
	Offset: 0x6548
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function inGrenadeBlastRadius(entity)
{
	return !entity IsSafeFromGrenade();
}

/*
	Name: recentlySawEnemy
	Namespace: AiUtility
	Checksum: 0x57588595
	Offset: 0x6578
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function recentlySawEnemy(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy) && behaviorTreeEntity SeeRecently(behaviorTreeEntity.enemy, 6))
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldOnlyFireAccurately
	Namespace: AiUtility
	Checksum: 0x212C6E87
	Offset: 0x65D8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function shouldOnlyFireAccurately(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.accurateFire) && behaviorTreeEntity.accurateFire)
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldBeAggressive
	Namespace: AiUtility
	Checksum: 0xDCF501BB
	Offset: 0x6620
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function shouldBeAggressive(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.aggressiveMode) && behaviorTreeEntity.aggressiveMode)
	{
		return 1;
	}
	return 0;
}

/*
	Name: useCoverNodeWrapper
	Namespace: AiUtility
	Checksum: 0x4F334D66
	Offset: 0x6668
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function useCoverNodeWrapper(behaviorTreeEntity, node)
{
	var_7bd2c713 = behaviorTreeEntity.node === node;
	behaviorTreeEntity UseCOverNode(node);
	if(!var_7bd2c713)
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_mode_none");
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_previous_cover_mode", "cover_mode_none");
	}
	setNextFindBestCoverTime(behaviorTreeEntity, node);
}

/*
	Name: setNextFindBestCoverTime
	Namespace: AiUtility
	Checksum: 0xEE85B986
	Offset: 0x6738
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function setNextFindBestCoverTime(behaviorTreeEntity, node)
{
	behaviorTreeEntity.nextFindBestCoverTime = behaviorTreeEntity function_b29fbebf(behaviorTreeEntity.engageMinDist, behaviorTreeEntity.engageMaxDist, behaviorTreeEntity.coverSearchInterval);
}

/*
	Name: trackCoverParamsService
	Namespace: AiUtility
	Checksum: 0xDABE682A
	Offset: 0x6798
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function trackCoverParamsService(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.node) && behaviorTreeEntity IsAtCoverNodeStrict() && behaviorTreeEntity ShouldUseCoverNode())
	{
		if(!isdefined(behaviorTreeEntity.coverNode))
		{
			behaviorTreeEntity.coverNode = behaviorTreeEntity.node;
			setNextFindBestCoverTime(behaviorTreeEntity, behaviorTreeEntity.node);
		}
		return;
	}
	behaviorTreeEntity.coverNode = undefined;
}

/*
	Name: chooseBestCoverNodeASAP
	Namespace: AiUtility
	Checksum: 0xD207E5BB
	Offset: 0x6850
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function chooseBestCoverNodeASAP(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	node = getBestCoverNodeIfAvailable(behaviorTreeEntity);
	if(isdefined(node))
	{
		useCoverNodeWrapper(behaviorTreeEntity, node);
	}
}

/*
	Name: shouldChooseBetterCover
	Namespace: AiUtility
	Checksum: 0x84E4A07F
	Offset: 0x68C8
	Size: 0x459
	Parameters: 1
	Flags: None
*/
function shouldChooseBetterCover(behaviorTreeEntity)
{
	if(behaviorTreeEntity ai::has_behavior_attribute("stealth") && behaviorTreeEntity ai::get_behavior_attribute("stealth"))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.var_bbd5dba4) && behaviorTreeEntity.var_bbd5dba4)
	{
		return 0;
	}
	if(behaviorTreeEntity function_52e4091c())
	{
		return 1;
	}
	if(isdefined(behaviorTreeEntity.enemy))
	{
		var_946d4fc9 = 0;
		var_9461d840 = 0;
		var_c202f796 = 0;
		var_a171a23a = 0;
		var_77d48ea8 = 0;
		if(behaviorTreeEntity ShouldHoldGroundAgainstEnemy())
		{
			return 0;
		}
		if(behaviorTreeEntity HasPath() && isdefined(behaviorTreeEntity.arrivalfinalpos) && isdefined(behaviorTreeEntity.pathGoalPos) && self.pathGoalPos == behaviorTreeEntity.arrivalfinalpos)
		{
			if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.arrivalfinalpos) < 4096)
			{
				var_c202f796 = 1;
			}
		}
		var_946d4fc9 = behaviorTreeEntity ShouldUseCoverNode();
		if(self IsAtGoal())
		{
			if(var_946d4fc9 && isdefined(behaviorTreeEntity.node) && self IsAtGoal())
			{
				lastKnownPos = behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy);
				dist = Distance2D(behaviorTreeEntity.origin, lastKnownPos);
				if(dist > behaviorTreeEntity.engageminfalloffdist && dist <= behaviorTreeEntity.engagemaxfalloffdist)
				{
					var_a171a23a = 1;
				}
			}
			var_9461d840 = !var_a171a23a && behaviorTreeEntity function_839d99d7() && GetTime() > self.nextFindBestCoverTime;
			if(!var_946d4fc9)
			{
				if(isdefined(behaviorTreeEntity.frustrationLevel) && behaviorTreeEntity.frustrationLevel > 0 && behaviorTreeEntity HasPath())
				{
					var_77d48ea8 = 1;
				}
			}
		}
		shouldLookForBetterCover = !var_77d48ea8 && !var_c202f796 && !var_a171a23a && (!var_946d4fc9 || var_9461d840 || !self IsAtGoal());
		/#
			if(shouldLookForBetterCover)
			{
				color = (0, 1, 0);
			}
			else
			{
				color = (1, 0, 0);
			}
			recordEntText("Dev Block strings are not supported" + var_946d4fc9 + "Dev Block strings are not supported" + var_77d48ea8 + "Dev Block strings are not supported" + var_c202f796 + "Dev Block strings are not supported" + var_a171a23a + "Dev Block strings are not supported" + var_9461d840, behaviorTreeEntity, color, "Dev Block strings are not supported");
		#/
	}
	else
	{
		return !behaviorTreeEntity ShouldUseCoverNode() && behaviorTreeEntity function_553f87a();
	}
	return shouldLookForBetterCover;
}

/*
	Name: chooseBetterCoverServiceCodeVersion
	Namespace: AiUtility
	Checksum: 0x962EBA02
	Offset: 0x6D30
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function chooseBetterCoverServiceCodeVersion(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.stealth) && behaviorTreeEntity ai::get_behavior_attribute("stealth"))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.var_bbd5dba4) && behaviorTreeEntity.var_bbd5dba4)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.var_861b5edc))
	{
		return 0;
	}
	if(!isSafeFromGrenades(behaviorTreeEntity))
	{
		behaviorTreeEntity.nextFindBestCoverTime = 0;
	}
	newnode = behaviorTreeEntity function_162a81c5();
	if(isdefined(newnode))
	{
		useCoverNodeWrapper(behaviorTreeEntity, newnode);
		return 1;
	}
	setNextFindBestCoverTime(behaviorTreeEntity, undefined);
	return 0;
}

/*
	Name: chooseBetterCoverService
	Namespace: AiUtility
	Checksum: 0xDF22936E
	Offset: 0x6E48
	Size: 0x1A5
	Parameters: 1
	Flags: Private
*/
function private chooseBetterCoverService(behaviorTreeEntity)
{
	var_446c3775 = shouldChooseBetterCover(behaviorTreeEntity);
	if(var_446c3775 && !behaviorTreeEntity.keepClaimedNode)
	{
		transitionRunning = behaviorTreeEntity ASMIsTransitionRunning();
		subStatePending = behaviorTreeEntity ASMIsSubStatePending();
		transDecRunning = behaviorTreeEntity AsmIsTransDecRunning();
		isBehaviorTreeInRunningState = behaviorTreeEntity GetBehaviortreeStatus() == 5;
		if(!transitionRunning && !subStatePending && !transDecRunning && isBehaviorTreeInRunningState)
		{
			node = getBestCoverNodeIfAvailable(behaviorTreeEntity);
			goingToDifferentNode = isdefined(node) && (!isdefined(behaviorTreeEntity.node) || node != behaviorTreeEntity.node);
			if(goingToDifferentNode)
			{
				useCoverNodeWrapper(behaviorTreeEntity, node);
				return 1;
			}
			setNextFindBestCoverTime(behaviorTreeEntity, undefined);
		}
	}
	return 0;
}

/*
	Name: refillAmmo
	Namespace: AiUtility
	Checksum: 0xF244AB0E
	Offset: 0x6FF8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function refillAmmo(behaviorTreeEntity)
{
	if(behaviorTreeEntity.weapon != level.weaponNone)
	{
		behaviorTreeEntity.bulletsInClip = behaviorTreeEntity.weapon.clipSize;
	}
}

/*
	Name: hasAmmo
	Namespace: AiUtility
	Checksum: 0xD093CAC0
	Offset: 0x7050
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function hasAmmo(behaviorTreeEntity)
{
	if(behaviorTreeEntity.bulletsInClip > 0)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: hasLowAmmo
	Namespace: AiUtility
	Checksum: 0xB9BC8DDD
	Offset: 0x7088
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function hasLowAmmo(behaviorTreeEntity)
{
	if(behaviorTreeEntity.weapon != level.weaponNone)
	{
		return behaviorTreeEntity.bulletsInClip < behaviorTreeEntity.weapon.clipSize * 0.2;
	}
	return 0;
}

/*
	Name: hasEnemy
	Namespace: AiUtility
	Checksum: 0x174D6034
	Offset: 0x70F0
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function hasEnemy(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		return 1;
	}
	return 0;
}

/*
	Name: getBestCoverNodeIfAvailable
	Namespace: AiUtility
	Checksum: 0x979847B9
	Offset: 0x7120
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function getBestCoverNodeIfAvailable(behaviorTreeEntity)
{
	node = behaviorTreeEntity FindBestCoverNode();
	if(!isdefined(node))
	{
		return undefined;
	}
	if(behaviorTreeEntity function_b6d4cde9())
	{
		currentNode = self.node;
	}
	if(isdefined(currentNode) && node == currentNode)
	{
		return undefined;
	}
	if(isdefined(behaviorTreeEntity.coverNode) && node == behaviorTreeEntity.coverNode)
	{
		return undefined;
	}
	return node;
}

/*
	Name: function_77621db4
	Namespace: AiUtility
	Checksum: 0x7C5C7EEF
	Offset: 0x71E8
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function function_77621db4(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.fixedNode) && behaviorTreeEntity.fixedNode)
	{
		return undefined;
	}
	nodes = behaviorTreeEntity FindBestCoverNodes(behaviorTreeEntity.goalRadius, behaviorTreeEntity.origin);
	if(nodes.size > 1)
	{
		node = nodes[1];
	}
	if(!isdefined(node))
	{
		return undefined;
	}
	if(behaviorTreeEntity function_b6d4cde9())
	{
		currentNode = self.node;
	}
	if(isdefined(currentNode) && node == currentNode)
	{
		return undefined;
	}
	if(isdefined(behaviorTreeEntity.coverNode) && node == behaviorTreeEntity.coverNode)
	{
		return undefined;
	}
	return node;
}

/*
	Name: getCoverType
	Namespace: AiUtility
	Checksum: 0xBD32B4C8
	Offset: 0x7318
	Size: 0x175
	Parameters: 1
	Flags: None
*/
function getCoverType(node)
{
	if(isdefined(node))
	{
		if(node.type == "Cover Pillar")
		{
			return "cover_pillar";
		}
		else if(node.type == "Cover Left")
		{
			return "cover_left";
		}
		else if(node.type == "Cover Right")
		{
			return "cover_right";
		}
		else if(node.type == "Cover Stand" || node.type == "Conceal Stand")
		{
			return "cover_stand";
		}
		else if(node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch")
		{
			return "cover_crouch";
		}
		else if(node.type == "Exposed" || node.type == "Guard")
		{
			return "cover_exposed";
		}
	}
	return "cover_none";
}

/*
	Name: isCoverConcealed
	Namespace: AiUtility
	Checksum: 0x9515EE2F
	Offset: 0x7498
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function isCoverConcealed(node)
{
	if(isdefined(node))
	{
		return node.type == "Conceal Crouch" || node.type == "Conceal Stand";
	}
	return 0;
}

/*
	Name: canSeeEnemyWrapper
	Namespace: AiUtility
	Checksum: 0x3DAE964
	Offset: 0x74F0
	Size: 0x4BB
	Parameters: 0
	Flags: None
*/
function canSeeEnemyWrapper()
{
	if(!isdefined(self.enemy))
	{
		return 0;
	}
	if(!isdefined(self.node))
	{
		return self cansee(self.enemy);
	}
	else
	{
		node = self.node;
		enemyEye = self.enemy GetEye();
		yawToEnemy = AngleClamp180(node.angles[1] - VectorToAngles(enemyEye - node.origin)[1]);
		if(node.type == "Cover Left" || node.type == "Cover Right")
		{
			if(yawToEnemy > 60 || yawToEnemy < -60)
			{
				return 0;
			}
			if(isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 4 == 4)
			{
				if(node.type == "Cover Left" && yawToEnemy > 10)
				{
					return 0;
				}
				if(node.type == "Cover Right" && yawToEnemy < -10)
				{
					return 0;
				}
			}
		}
		nodeOffset = (0, 0, 0);
		if(node.type == "Cover Pillar")
		{
			/#
				Assert(!isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 2048 == 2048 || (!isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 1024 == 1024));
			#/
			var_d98babd5 = 1;
			var_8f53d138 = 1;
			nodeOffset = (-32, 3.7, 60);
			lookFromPoint = function_ae9a5c37(node, nodeOffset);
			var_d98babd5 = SightTracePassed(lookFromPoint, enemyEye, 0, undefined);
			nodeOffset = (32, 3.7, 60);
			lookFromPoint = function_ae9a5c37(node, nodeOffset);
			var_8f53d138 = SightTracePassed(lookFromPoint, enemyEye, 0, undefined);
			return var_8f53d138 || var_d98babd5;
		}
		else if(node.type == "Cover Left")
		{
			nodeOffset = (-36, 7, 63);
		}
		else if(node.type == "Cover Right")
		{
			nodeOffset = (36, 7, 63);
		}
		else if(node.type == "Cover Stand" || node.type == "Conceal Stand")
		{
			nodeOffset = (-3.7, -22, 63);
		}
		else if(node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch")
		{
			nodeOffset = (3.5, -12.5, 45);
		}
		lookFromPoint = function_ae9a5c37(node, nodeOffset);
		if(SightTracePassed(lookFromPoint, enemyEye, 0, undefined))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}

/*
	Name: function_ae9a5c37
	Namespace: AiUtility
	Checksum: 0x4617AB94
	Offset: 0x79B8
	Size: 0xA9
	Parameters: 2
	Flags: None
*/
function function_ae9a5c37(node, nodeOffset)
{
	right = AnglesToRight(node.angles);
	FORWARD = AnglesToForward(node.angles);
	return node.origin + VectorScale(right, nodeOffset[0]) + VectorScale(FORWARD, nodeOffset[1]) + (0, 0, nodeOffset[2]);
}

/*
	Name: getHighestNodeStance
	Namespace: AiUtility
	Checksum: 0xF815C3D0
	Offset: 0x7A70
	Size: 0x185
	Parameters: 1
	Flags: None
*/
function getHighestNodeStance(node)
{
	/#
		Assert(isdefined(node));
	#/
	if(isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 4 == 4)
	{
		return "stand";
	}
	if(isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 8 == 8)
	{
		return "crouch";
	}
	if(isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 16 == 16)
	{
		return "prone";
	}
	/#
		errormsg(node.type + "Dev Block strings are not supported" + node.origin + "Dev Block strings are not supported");
	#/
	if(node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch")
	{
		return "crouch";
	}
	return "stand";
}

/*
	Name: isStanceAllowedAtNode
	Namespace: AiUtility
	Checksum: 0xD904A1
	Offset: 0x7C00
	Size: 0x12D
	Parameters: 2
	Flags: None
*/
function isStanceAllowedAtNode(stance, node)
{
	/#
		Assert(isdefined(stance));
	#/
	/#
		Assert(isdefined(node));
	#/
	if(stance == "stand" && (isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 4 == 4))
	{
		return 1;
	}
	if(stance == "crouch" && (isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 8 == 8))
	{
		return 1;
	}
	if(stance == "prone" && (isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 16 == 16))
	{
		return 1;
	}
	return 0;
}

/*
	Name: tryStoppingService
	Namespace: AiUtility
	Checksum: 0x25BFE1D2
	Offset: 0x7D38
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function tryStoppingService(behaviorTreeEntity)
{
	if(behaviorTreeEntity ShouldHoldGroundAgainstEnemy())
	{
		behaviorTreeEntity clearPath();
		behaviorTreeEntity.keepClaimedNode = 1;
		return 1;
	}
	behaviorTreeEntity.keepClaimedNode = 0;
	return 0;
}

/*
	Name: shouldStopMoving
	Namespace: AiUtility
	Checksum: 0x8227F0CF
	Offset: 0x7DB0
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function shouldStopMoving(behaviorTreeEntity)
{
	if(behaviorTreeEntity ShouldHoldGroundAgainstEnemy())
	{
		return 1;
	}
	return 0;
}

/*
	Name: setCurrentWeapon
	Namespace: AiUtility
	Checksum: 0xE3057E89
	Offset: 0x7DE8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function setCurrentWeapon(weapon)
{
	self.weapon = weapon;
	self.weaponClass = weapon.weapClass;
	if(weapon != level.weaponNone)
	{
		/#
			Assert(isdefined(weapon.worldmodel), "Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported");
		#/
	}
	self.weaponModel = weapon.worldmodel;
}

/*
	Name: setPrimaryWeapon
	Namespace: AiUtility
	Checksum: 0x93F55E66
	Offset: 0x7E90
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function setPrimaryWeapon(weapon)
{
	self.primaryWeapon = weapon;
	self.primaryweaponclass = weapon.weapClass;
	if(weapon != level.weaponNone)
	{
		/#
			Assert(isdefined(weapon.worldmodel), "Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported");
		#/
	}
}

/*
	Name: setSecondaryWeapon
	Namespace: AiUtility
	Checksum: 0x7DCA4AD1
	Offset: 0x7F20
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function setSecondaryWeapon(weapon)
{
	self.secondaryWeapon = weapon;
	self.secondaryweaponclass = weapon.weapClass;
	if(weapon != level.weaponNone)
	{
		/#
			Assert(isdefined(weapon.worldmodel), "Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported");
		#/
	}
}

/*
	Name: keepClaimNode
	Namespace: AiUtility
	Checksum: 0xB3CADD44
	Offset: 0x7FB0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function keepClaimNode(behaviorTreeEntity)
{
	behaviorTreeEntity.keepClaimedNode = 1;
	return 1;
}

/*
	Name: releaseClaimNode
	Namespace: AiUtility
	Checksum: 0xC0CDB3F
	Offset: 0x7FE0
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function releaseClaimNode(behaviorTreeEntity)
{
	behaviorTreeEntity.keepClaimedNode = 0;
	return 1;
}

/*
	Name: GetAimYawToEnemyFromNode
	Namespace: AiUtility
	Checksum: 0x97E0A87D
	Offset: 0x8008
	Size: 0x89
	Parameters: 3
	Flags: None
*/
function GetAimYawToEnemyFromNode(behaviorTreeEntity, node, enemy)
{
	return AngleClamp180(VectorToAngles(behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy) - node.origin)[1] - node.angles[1]);
}

/*
	Name: GetAimPitchToEnemyFromNode
	Namespace: AiUtility
	Checksum: 0xA36C0A17
	Offset: 0x80A0
	Size: 0x81
	Parameters: 3
	Flags: None
*/
function GetAimPitchToEnemyFromNode(behaviorTreeEntity, node, enemy)
{
	return AngleClamp180(VectorToAngles(behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy) - node.origin)[0] - node.angles[0]);
}

/*
	Name: chooseFrontCoverDirection
	Namespace: AiUtility
	Checksum: 0x5D933FC0
	Offset: 0x8130
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function chooseFrontCoverDirection(behaviorTreeEntity)
{
	coverDirection = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_direction");
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_previous_cover_direction", coverDirection);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_direction", "cover_front_direction");
}

/*
	Name: shouldTacticalWalk
	Namespace: AiUtility
	Checksum: 0x1E201153
	Offset: 0x81C0
	Size: 0x1E5
	Parameters: 1
	Flags: None
*/
function shouldTacticalWalk(behaviorTreeEntity)
{
	if(!behaviorTreeEntity HasPath())
	{
		return 0;
	}
	if(ai::HasAiAttribute(behaviorTreeEntity, "forceTacticalWalk") && ai::GetAiAttribute(behaviorTreeEntity, "forceTacticalWalk"))
	{
		return 1;
	}
	if(ai::HasAiAttribute(behaviorTreeEntity, "disablesprint") && !ai::GetAiAttribute(behaviorTreeEntity, "disablesprint"))
	{
		if(ai::HasAiAttribute(behaviorTreeEntity, "sprint") && ai::GetAiAttribute(behaviorTreeEntity, "sprint"))
		{
			return 0;
		}
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
		if(pathDist < 9216)
		{
			return 1;
		}
	}
	if(behaviorTreeEntity ShouldFaceMotion())
	{
		return 0;
	}
	if(!behaviorTreeEntity IsSafeFromGrenade())
	{
		return 0;
	}
	return 1;
}

/*
	Name: shouldStealth
	Namespace: AiUtility
	Checksum: 0xF7D29263
	Offset: 0x83B0
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function shouldStealth(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.stealth))
	{
		now = GetTime();
		if(behaviorTreeEntity isInScriptedState())
		{
			return 0;
		}
		if(behaviorTreeEntity HasValidInterrupt("react"))
		{
			behaviorTreeEntity.var_7c966299 = now;
			return 1;
		}
		if(isdefined(behaviorTreeEntity.var_eddc2d46) && behaviorTreeEntity.var_eddc2d46 || (isdefined(behaviorTreeEntity.var_7c966299) && now - behaviorTreeEntity.var_7c966299 < 250))
		{
			return 1;
		}
		if(behaviorTreeEntity ai::has_behavior_attribute("stealth") && behaviorTreeEntity ai::get_behavior_attribute("stealth"))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: locomotionShouldStealth
	Namespace: AiUtility
	Checksum: 0xF981C168
	Offset: 0x84D8
	Size: 0x1D5
	Parameters: 1
	Flags: None
*/
function locomotionShouldStealth(behaviorTreeEntity)
{
	if(!shouldStealth(behaviorTreeEntity))
	{
		return 0;
	}
	if(behaviorTreeEntity HasPath())
	{
		if(isdefined(behaviorTreeEntity.arrivalfinalpos) || isdefined(behaviorTreeEntity.pathGoalPos))
		{
			var_905ca688 = isdefined(self.currentgoal) && isdefined(self.currentgoal.script_wait_min) && isdefined(self.currentgoal.script_wait_max);
			if(var_905ca688)
			{
				var_905ca688 = self.currentgoal.script_wait_min > 0 || self.currentgoal.script_wait_max > 0;
			}
			if(var_905ca688 || !isdefined(self.currentgoal) || (isdefined(self.currentgoal) && isdefined(self.currentgoal.scriptbundlename)))
			{
				goalpos = undefined;
				if(isdefined(behaviorTreeEntity.arrivalfinalpos))
				{
					goalpos = behaviorTreeEntity.arrivalfinalpos;
				}
				else
				{
					goalpos = behaviorTreeEntity.pathGoalPos;
				}
				var_8f6e8718 = DistanceSquared(behaviorTreeEntity.origin, goalpos);
				if(var_8f6e8718 <= 1936 && var_8f6e8718 <= behaviorTreeEntity.goalRadius * behaviorTreeEntity.goalRadius)
				{
					return 0;
				}
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: shouldStealthResume
	Namespace: AiUtility
	Checksum: 0x4EDD2E40
	Offset: 0x86B8
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function shouldStealthResume(behaviorTreeEntity)
{
	if(!shouldStealth(behaviorTreeEntity))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.var_a3ac1998) && behaviorTreeEntity.var_a3ac1998)
	{
		behaviorTreeEntity.var_a3ac1998 = undefined;
		return 1;
	}
	return 0;
}

/*
	Name: stealthReactCondition
	Namespace: AiUtility
	Checksum: 0xA46A95C1
	Offset: 0x8728
	Size: 0x9B
	Parameters: 1
	Flags: Private
*/
function private stealthReactCondition(entity)
{
	var_5313ee44 = isdefined(self._o_scene) && isdefined(self._o_scene._str_state) && self._o_scene._str_state == "play";
	return !isdefined(entity.var_eddc2d46) && entity.var_eddc2d46 && entity HasValidInterrupt("react") && !var_5313ee44;
}

/*
	Name: stealthReactStart
	Namespace: AiUtility
	Checksum: 0x5ACE4537
	Offset: 0x87D0
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private stealthReactStart(behaviorTreeEntity)
{
	behaviorTreeEntity.var_eddc2d46 = 1;
}

/*
	Name: stealthReactTerminate
	Namespace: AiUtility
	Checksum: 0x1D064623
	Offset: 0x87F8
	Size: 0x19
	Parameters: 1
	Flags: Private
*/
function private stealthReactTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity.var_eddc2d46 = undefined;
}

/*
	Name: stealthIdleTerminate
	Namespace: AiUtility
	Checksum: 0xDBA3404C
	Offset: 0x8820
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private stealthIdleTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity notify("stealthIdleTerminate");
	if(isdefined(behaviorTreeEntity.var_f706c2c) && behaviorTreeEntity.var_f706c2c)
	{
		behaviorTreeEntity.var_f706c2c = undefined;
		behaviorTreeEntity.var_a3ac1998 = 1;
	}
}

/*
	Name: locomotionShouldPatrol
	Namespace: AiUtility
	Checksum: 0xBF0EE21D
	Offset: 0x8888
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function locomotionShouldPatrol(behaviorTreeEntity)
{
	if(shouldStealth(behaviorTreeEntity))
	{
		return 0;
	}
	if(behaviorTreeEntity HasPath() && behaviorTreeEntity ai::has_behavior_attribute("patrol") && behaviorTreeEntity ai::get_behavior_attribute("patrol"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: explosiveKilled
	Namespace: AiUtility
	Checksum: 0x7CDE30C5
	Offset: 0x8920
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function explosiveKilled(behaviorTreeEntity)
{
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_damage_weapon_class") == "explosive")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_a1b8d442
	Namespace: AiUtility
	Checksum: 0xC541EC5B
	Offset: 0x8968
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private function_a1b8d442(var_e1e600a8)
{
	entity = self;
	entity shared::ThrowWeapon(var_e1e600a8.weapon, var_e1e600a8.tag, 0);
	if(isdefined(entity))
	{
		entity Detach(var_e1e600a8.model, var_e1e600a8.tag);
	}
}

/*
	Name: attachRiotshield
	Namespace: AiUtility
	Checksum: 0x7EECC596
	Offset: 0x89F8
	Size: 0xB7
	Parameters: 4
	Flags: None
*/
function attachRiotshield(entity, var_530c40f8, var_f99d8f03, var_ac00d684)
{
	riotshield = spawnstruct();
	riotshield.weapon = var_530c40f8;
	riotshield.tag = var_ac00d684;
	riotshield.model = var_f99d8f03;
	entity Attach(var_f99d8f03, riotshield.tag);
	entity.riotshield = riotshield;
}

/*
	Name: dropRiotshield
	Namespace: AiUtility
	Checksum: 0xBCE0508B
	Offset: 0x8AB8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function dropRiotshield(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.riotshield))
	{
		var_e1e600a8 = behaviorTreeEntity.riotshield;
		behaviorTreeEntity.riotshield = undefined;
		behaviorTreeEntity thread function_a1b8d442(var_e1e600a8);
	}
}

/*
	Name: electrifiedKilled
	Namespace: AiUtility
	Checksum: 0x595DE238
	Offset: 0x8B28
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function electrifiedKilled(behaviorTreeEntity)
{
	if(behaviorTreeEntity.damageWeapon.rootweapon.name == "shotgun_pump_taser")
	{
		return 1;
	}
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_damage_mod") == "mod_electrocuted")
	{
		return 1;
	}
	return 0;
}

/*
	Name: burnedKilled
	Namespace: AiUtility
	Checksum: 0x5F01CDCF
	Offset: 0x8BA0
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function burnedKilled(behaviorTreeEntity)
{
	if(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_damage_mod") == "mod_burned")
	{
		return 1;
	}
	return 0;
}

/*
	Name: rapsKilled
	Namespace: AiUtility
	Checksum: 0xDA17B8B3
	Offset: 0x8BE8
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function rapsKilled(behaviorTreeEntity)
{
	if(isdefined(self.attacker) && isdefined(self.attacker.archetype) && self.attacker.archetype == "raps")
	{
		return 1;
	}
	return 0;
}

/*
	Name: meleeAcquireMutex
	Namespace: AiUtility
	Checksum: 0x7793B9AF
	Offset: 0x8C40
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function meleeAcquireMutex(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity) && isdefined(behaviorTreeEntity.enemy))
	{
		behaviorTreeEntity.melee = spawnstruct();
		behaviorTreeEntity.melee.enemy = behaviorTreeEntity.enemy;
		if(isPlayer(behaviorTreeEntity.melee.enemy))
		{
			if(!isdefined(behaviorTreeEntity.melee.enemy.meleeAttackers))
			{
				behaviorTreeEntity.melee.enemy.meleeAttackers = 0;
			}
			behaviorTreeEntity.melee.enemy.meleeAttackers++;
		}
	}
}

/*
	Name: meleeReleaseMutex
	Namespace: AiUtility
	Checksum: 0x6F2F1142
	Offset: 0x8D40
	Size: 0x119
	Parameters: 1
	Flags: None
*/
function meleeReleaseMutex(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.melee))
	{
		if(isdefined(behaviorTreeEntity.melee.enemy))
		{
			if(isPlayer(behaviorTreeEntity.melee.enemy))
			{
				if(isdefined(behaviorTreeEntity.melee.enemy.meleeAttackers))
				{
					behaviorTreeEntity.melee.enemy.meleeAttackers = behaviorTreeEntity.melee.enemy.meleeAttackers - 1;
					if(behaviorTreeEntity.melee.enemy.meleeAttackers <= 0)
					{
						behaviorTreeEntity.melee.enemy.meleeAttackers = undefined;
					}
				}
			}
		}
		behaviorTreeEntity.melee = undefined;
	}
}

/*
	Name: shouldMutexMelee
	Namespace: AiUtility
	Checksum: 0x12405F23
	Offset: 0x8E68
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function shouldMutexMelee(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.melee))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.enemy))
	{
		if(!isPlayer(behaviorTreeEntity.enemy))
		{
			if(isdefined(behaviorTreeEntity.enemy.melee))
			{
				return 0;
			}
		}
		else if(!SessionModeIsCampaignGame())
		{
			return 1;
		}
		if(!isdefined(behaviorTreeEntity.enemy.meleeAttackers))
		{
			behaviorTreeEntity.enemy.meleeAttackers = 0;
		}
		return behaviorTreeEntity.enemy.meleeAttackers < 1;
	}
	return 1;
}

/*
	Name: shouldNormalMelee
	Namespace: AiUtility
	Checksum: 0x425658F2
	Offset: 0x8F60
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function shouldNormalMelee(behaviorTreeEntity)
{
	return hasCloseEnemyToMelee(behaviorTreeEntity);
}

/*
	Name: shouldMelee
	Namespace: AiUtility
	Checksum: 0xB7E6D289
	Offset: 0x8F90
	Size: 0x31F
	Parameters: 1
	Flags: None
*/
function shouldMelee(entity)
{
	if(isdefined(entity.var_d05e7313) && !entity.var_d05e7313 && entity.var_35f1841b + 50 >= GetTime())
	{
		return 0;
	}
	entity.var_35f1841b = GetTime();
	entity.var_d05e7313 = 0;
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(!entity.enemy.allowdeath)
	{
		return 0;
	}
	if(!isalive(entity.enemy))
	{
		return 0;
	}
	if(!IsSentient(entity.enemy))
	{
		return 0;
	}
	if(isVehicle(entity.enemy) && (!isdefined(entity.enemy.good_melee_target) && entity.enemy.good_melee_target))
	{
		return 0;
	}
	if(isPlayer(entity.enemy) && entity.enemy GetStance() == "prone")
	{
		return 0;
	}
	if(isdefined(entity.var_31da95f4))
	{
	}
	else
	{
	}
	chargeDistSq = 140 * 140;
	if(DistanceSquared(entity.origin, entity.enemy.origin) > chargeDistSq)
	{
		return 0;
	}
	if(!shouldMutexMelee(entity))
	{
		return 0;
	}
	if(ai::HasAiAttribute(entity, "can_melee") && !ai::GetAiAttribute(entity, "can_melee"))
	{
		return 0;
	}
	if(ai::HasAiAttribute(entity.enemy, "can_be_meleed") && !ai::GetAiAttribute(entity.enemy, "can_be_meleed"))
	{
		return 0;
	}
	if(shouldNormalMelee(entity) || shouldChargeMelee(entity))
	{
		entity.var_d05e7313 = 1;
		return 1;
	}
	return 0;
}

/*
	Name: hasCloseEnemyToMelee
	Namespace: AiUtility
	Checksum: 0xBCADD7D9
	Offset: 0x92B8
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function hasCloseEnemyToMelee(entity)
{
	return function_925333fb(entity, 64 * 64);
}

/*
	Name: function_925333fb
	Namespace: AiUtility
	Checksum: 0x8FA7A46B
	Offset: 0x92F0
	Size: 0x1C3
	Parameters: 2
	Flags: None
*/
function function_925333fb(entity, MELEE_RANGE_SQ)
{
	/#
		Assert(isdefined(entity.enemy));
	#/
	if(!entity cansee(entity.enemy))
	{
		return 0;
	}
	predicitedPosition = entity.enemy.origin + VectorScale(entity function_73a5ea40(), 0.25);
	distSq = DistanceSquared(entity.origin, predicitedPosition);
	yawToEnemy = AngleClamp180(entity.angles[1] - VectorToAngles(entity.enemy.origin - entity.origin)[1]);
	if(distSq <= 36 * 36)
	{
		return Abs(yawToEnemy) <= 40;
	}
	if(distSq <= MELEE_RANGE_SQ && entity MayMoveToPoint(entity.enemy.origin))
	{
		return Abs(yawToEnemy) <= 80;
	}
	return 0;
}

/*
	Name: shouldChargeMelee
	Namespace: AiUtility
	Checksum: 0xC0CC81F8
	Offset: 0x94C0
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function shouldChargeMelee(entity)
{
	/#
		Assert(isdefined(entity.enemy));
	#/
	currentStance = blackboard::GetBlackBoardAttribute(entity, "_stance");
	if(currentStance != "stand")
	{
		return 0;
	}
	if(isdefined(entity.var_a0991f3d))
	{
		if(GetTime() < entity.var_a0991f3d)
		{
			return 0;
		}
	}
	enemyDistSq = DistanceSquared(entity.origin, entity.enemy.origin);
	if(enemyDistSq < 64 * 64)
	{
		return 0;
	}
	offset = entity.enemy.origin - VectorNormalize(entity.enemy.origin - entity.origin) * 36;
	if(isdefined(entity.var_31da95f4))
	{
	}
	else
	{
	}
	chargeDistSq = 140 * 140;
	if(enemyDistSq < chargeDistSq && entity MayMoveToPoint(offset, 1, 1))
	{
		yawToEnemy = AngleClamp180(entity.angles[1] - VectorToAngles(entity.enemy.origin - entity.origin)[1]);
		return Abs(yawToEnemy) <= 80;
	}
	return 0;
}

/*
	Name: shouldAttackInChargeMelee
	Namespace: AiUtility
	Checksum: 0x8DEAB18
	Offset: 0x9718
	Size: 0xF5
	Parameters: 1
	Flags: Private
*/
function private shouldAttackInChargeMelee(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) < 74 * 74)
		{
			yawToEnemy = AngleClamp180(behaviorTreeEntity.angles[1] - VectorToAngles(behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin)[1]);
			if(Abs(yawToEnemy) > 80)
			{
				return 0;
			}
			return 1;
		}
	}
}

/*
	Name: setupChargeMeleeAttack
	Namespace: AiUtility
	Checksum: 0xAF37EC01
	Offset: 0x9818
	Size: 0xC3
	Parameters: 1
	Flags: Private
*/
function private setupChargeMeleeAttack(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy) && isdefined(behaviorTreeEntity.enemy.vehicleType) && IsSubStr(behaviorTreeEntity.enemy.vehicleType, "firefly"))
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_melee_enemy_type", "fireflyswarm");
	}
	meleeAcquireMutex(behaviorTreeEntity);
	keepClaimNode(behaviorTreeEntity);
}

/*
	Name: cleanupMelee
	Namespace: AiUtility
	Checksum: 0xFD8D084B
	Offset: 0x98E8
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private cleanupMelee(behaviorTreeEntity)
{
	meleeReleaseMutex(behaviorTreeEntity);
	releaseClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_melee_enemy_type", undefined);
}

/*
	Name: cleanupChargeMelee
	Namespace: AiUtility
	Checksum: 0x75CAA300
	Offset: 0x9950
	Size: 0xB3
	Parameters: 1
	Flags: Private
*/
function private cleanupChargeMelee(behaviorTreeEntity)
{
	behaviorTreeEntity.var_a0991f3d = GetTime() + 2000;
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_melee_enemy_type", undefined);
	meleeReleaseMutex(behaviorTreeEntity);
	releaseClaimNode(behaviorTreeEntity);
	behaviorTreeEntity PathMode("move delayed", 1, RandomFloatRange(0.75, 1.5));
}

/*
	Name: cleanupChargeMeleeAttack
	Namespace: AiUtility
	Checksum: 0x53E02229
	Offset: 0x9A10
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function cleanupChargeMeleeAttack(behaviorTreeEntity)
{
	meleeReleaseMutex(behaviorTreeEntity);
	releaseClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_melee_enemy_type", undefined);
	behaviorTreeEntity PathMode("move delayed", 1, RandomFloatRange(0.5, 1));
}

/*
	Name: shouldChooseSpecialPronePain
	Namespace: AiUtility
	Checksum: 0xC2F3DB4A
	Offset: 0x9AB8
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private shouldChooseSpecialPronePain(behaviorTreeEntity)
{
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	return stance == "prone_back" || stance == "prone_front";
}

/*
	Name: shouldChooseSpecialPain
	Namespace: AiUtility
	Checksum: 0xABDE30A1
	Offset: 0x9B18
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private shouldChooseSpecialPain(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.damageWeapon))
	{
		return behaviorTreeEntity.damageWeapon.specialpain || isdefined(behaviorTreeEntity.special_weapon);
	}
	return 0;
}

/*
	Name: shouldChooseSpecialDeath
	Namespace: AiUtility
	Checksum: 0xCD9C3040
	Offset: 0x9B70
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private shouldChooseSpecialDeath(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.damageWeapon))
	{
		return behaviorTreeEntity.damageWeapon.specialpain;
	}
	return 0;
}

/*
	Name: shouldChooseSpecialProneDeath
	Namespace: AiUtility
	Checksum: 0x22A3B7E5
	Offset: 0x9BB8
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private shouldChooseSpecialProneDeath(behaviorTreeEntity)
{
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	return stance == "prone_back" || stance == "prone_front";
}

/*
	Name: setupExplosionAnimScale
	Namespace: AiUtility
	Checksum: 0x92EC95F1
	Offset: 0x9C18
	Size: 0x47
	Parameters: 2
	Flags: Private
*/
function private setupExplosionAnimScale(entity, asmStateName)
{
	self.animTranslationScale = 2;
	self ASMSetAnimationRate(0.7);
	return 4;
}

/*
	Name: isBalconyDeath
	Namespace: AiUtility
	Checksum: 0x12DE9861
	Offset: 0x9C68
	Size: 0x26F
	Parameters: 1
	Flags: None
*/
function isBalconyDeath(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.node))
	{
		return 0;
	}
	if(!(behaviorTreeEntity.node.SPAWNFLAGS & 1024 || behaviorTreeEntity.node.SPAWNFLAGS & 2048))
	{
		return 0;
	}
	coverMode = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode");
	if(coverMode == "cover_alert" || coverMode == "cover_mode_none")
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.node.script_balconydeathchance) && RandomInt(100) > Int(100 * behaviorTreeEntity.node.script_balconydeathchance))
	{
		return 0;
	}
	distSq = DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.node.origin);
	if(distSq > 16 * 16)
	{
		return 0;
	}
	if(isdefined(level.players) && level.players.size > 0)
	{
		closest_player = util::get_closest_player(behaviorTreeEntity.origin, level.players[0].team);
		if(isdefined(closest_player))
		{
			if(Abs(closest_player.origin[2] - behaviorTreeEntity.origin[2]) < 100)
			{
				var_9eabeb39 = Distance2DSquared(closest_player.origin, behaviorTreeEntity.origin);
				if(var_9eabeb39 < 600 * 600)
				{
					return 0;
				}
			}
		}
	}
	self.var_d78410bf = 1;
	return 1;
}

/*
	Name: balconyDeath
	Namespace: AiUtility
	Checksum: 0x70B58874
	Offset: 0x9EE0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function balconyDeath(behaviorTreeEntity)
{
	behaviorTreeEntity.clampToNavMesh = 0;
	if(behaviorTreeEntity.node.SPAWNFLAGS & 1024)
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_special_death", "balcony");
	}
	else if(behaviorTreeEntity.node.SPAWNFLAGS & 2048)
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_special_death", "balcony_norail");
	}
}

/*
	Name: useCurrentPosition
	Namespace: AiUtility
	Checksum: 0xABDB06E6
	Offset: 0x9F98
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function useCurrentPosition(entity)
{
	entity UsePosition(entity.origin);
}

/*
	Name: isUnarmed
	Namespace: AiUtility
	Checksum: 0xE3507CD
	Offset: 0x9FD0
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function isUnarmed(behaviorTreeEntity)
{
	if(behaviorTreeEntity.weapon == level.weaponNone)
	{
		return 1;
	}
	return 0;
}

/*
	Name: forceRagdoll
	Namespace: AiUtility
	Checksum: 0x4351A17B
	Offset: 0xA008
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function forceRagdoll(entity)
{
	entity StartRagdoll();
}

/*
	Name: preShootLaserAndGlintOn
	Namespace: AiUtility
	Checksum: 0x9E5A27A2
	Offset: 0xA038
	Size: 0x1A7
	Parameters: 1
	Flags: None
*/
function preShootLaserAndGlintOn(ai)
{
	self endon("death");
	if(!isdefined(ai.var_e912860c))
	{
		ai.var_e912860c = 0;
	}
	var_66bc84f9 = "lensflares/fx_lensflare_sniper_glint";
	while(1)
	{
		self waittill("hash_b9a2e2cb");
		if(ai.var_e912860c !== 1)
		{
			ai LaserOn();
			ai.var_e912860c = 1;
			if(ai.team != "allies")
			{
				tag = ai GetTagOrigin("tag_glint");
				if(isdefined(tag))
				{
					PlayFXOnTag(var_66bc84f9, ai, "tag_glint");
				}
				else if(isdefined(ai.classname))
				{
				}
				else
				{
				}
				type = "";
				/#
					println("Dev Block strings are not supported" + type + "Dev Block strings are not supported");
				#/
				PlayFXOnTag(var_66bc84f9, ai, "tag_eye");
			}
		}
	}
}

/*
	Name: postShootLaserAndGlintOff
	Namespace: AiUtility
	Checksum: 0x89933B5C
	Offset: 0xA1E8
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function postShootLaserAndGlintOff(ai)
{
	self endon("death");
	while(1)
	{
		self waittill("hash_dec53302");
		if(ai.var_e912860c === 1)
		{
			ai LaserOff();
			ai.var_e912860c = 0;
		}
	}
}

/*
	Name: isInPhalanx
	Namespace: AiUtility
	Checksum: 0xF795B6DB
	Offset: 0xA260
	Size: 0x29
	Parameters: 1
	Flags: Private
*/
function private isInPhalanx(entity)
{
	return entity ai::get_behavior_attribute("phalanx");
}

/*
	Name: isInPhalanxStance
	Namespace: AiUtility
	Checksum: 0x761035C
	Offset: 0xA298
	Size: 0xA5
	Parameters: 1
	Flags: Private
*/
function private isInPhalanxStance(entity)
{
	var_d9c35cf9 = entity ai::get_behavior_attribute("phalanx_force_stance");
	currentStance = blackboard::GetBlackBoardAttribute(entity, "_stance");
	switch(var_d9c35cf9)
	{
		case "stand":
		{
			return currentStance == "stand";
		}
		case "crouch":
		{
			return currentStance == "crouch";
		}
	}
	return 1;
}

/*
	Name: togglePhalanxStance
	Namespace: AiUtility
	Checksum: 0xBAF8AA62
	Offset: 0xA348
	Size: 0xA5
	Parameters: 1
	Flags: Private
*/
function private togglePhalanxStance(entity)
{
	var_d9c35cf9 = entity ai::get_behavior_attribute("phalanx_force_stance");
	switch(var_d9c35cf9)
	{
		case "stand":
		{
			blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
			break;
		}
		case "crouch":
		{
			blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "crouch");
			break;
		}
	}
}

/*
	Name: tookFlashbangDamage
	Namespace: AiUtility
	Checksum: 0xD9CB97CA
	Offset: 0xA3F8
	Size: 0x10D
	Parameters: 1
	Flags: Private
*/
function private tookFlashbangDamage(entity)
{
	if(isdefined(entity.damageWeapon) && isdefined(entity.damageMod))
	{
		weapon = entity.damageWeapon;
		return entity.damageMod == "MOD_GRENADE_SPLASH" && isdefined(weapon.rootweapon) && (IsSubStr(weapon.rootweapon.name, "flash_grenade") || IsSubStr(weapon.rootweapon.name, "concussion_grenade") || IsSubStr(weapon.rootweapon.name, "proximity_grenade"));
	}
	return 0;
}

/*
	Name: isAtAttackObject
	Namespace: AiUtility
	Checksum: 0x69A26EF
	Offset: 0xA510
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function isAtAttackObject(entity)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return 0;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(!isdefined(entity.attackable_slot))
		{
			return 0;
		}
		if(entity IsAtGoal())
		{
			entity.is_at_attackable = 1;
			return 1;
		}
	}
	return 0;
}

/*
	Name: shouldAttackObject
	Namespace: AiUtility
	Checksum: 0xA0661012
	Offset: 0xA5E8
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function shouldAttackObject(entity)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return 0;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(isdefined(entity.is_at_attackable) && entity.is_at_attackable)
		{
			return 1;
		}
	}
	return 0;
}

