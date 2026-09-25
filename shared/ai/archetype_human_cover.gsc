#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\laststand_shared;

#namespace archetype_human_cover;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: archetype_human_cover
	Checksum: 0x11FD381E
	Offset: 0x568
	Size: 0x2D3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldReturnToCoverCondition", &shouldReturnToCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldReturnToSuppressedCover", &shouldReturnToSuppressedCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAdjustToCover", &shouldAdjustToCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareForAdjustToCover", &prepareForAdjustToCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverBlindfireShootStart", &coverBlindfireShootActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canChangeStanceAtCoverCondition", &canChangeStanceAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverChangeStanceActionStart", &coverChangeStanceActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToChangeStanceToStand", &prepareToChangeStanceToStand);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanUpChangeStanceToStand", &cleanUpChangeStanceToStand);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToChangeStanceToCrouch", &prepareToChangeStanceToCrouch);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanUpChangeStanceToCrouch", &cleanUpChangeStanceToCrouch);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldVantageAtCoverCondition", &shouldVantageAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsVantageCoverCondition", &supportsVantageCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverVantageInitialize", &coverVantageInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldThrowGrenadeAtCoverCondition", &shouldThrowGrenadeAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverPrepareToThrowGrenade", &coverPrepareToThrowGrenade);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverCleanUpToThrowGrenade", &coverCleanUpToThrowGrenade);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("senseNearbyPlayers", &senseNearbyPlayers);
}

/*
	Name: shouldThrowGrenadeAtCoverCondition
	Namespace: archetype_human_cover
	Checksum: 0x43557135
	Offset: 0x848
	Size: 0x881
	Parameters: 2
	Flags: None
*/
function shouldThrowGrenadeAtCoverCondition(behaviorTreeEntity, throwIfPossible)
{
	if(!isdefined(throwIfPossible))
	{
		throwIfPossible = 0;
	}
	if(isdefined(level.AIDisableGrenadeThrows) && level.AIDisableGrenadeThrows)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(!IsSentient(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isVehicle(behaviorTreeEntity.enemy) && behaviorTreeEntity.enemy.vehicleClass === "helicopter")
	{
		return 0;
	}
	if(ai::HasAiAttribute(behaviorTreeEntity, "useGrenades") && !ai::GetAiAttribute(behaviorTreeEntity, "useGrenades"))
	{
		return 0;
	}
	entityAngles = behaviorTreeEntity.angles;
	if(isdefined(behaviorTreeEntity.node) && (behaviorTreeEntity.node.type == "Cover Left" || behaviorTreeEntity.node.type == "Cover Right" || behaviorTreeEntity.node.type == "Cover Pillar" || (behaviorTreeEntity.node.type == "Cover Stand" || behaviorTreeEntity.node.type == "Conceal Stand") || (behaviorTreeEntity.node.type == "Cover Crouch" || behaviorTreeEntity.node.type == "Cover Crouch Window" || behaviorTreeEntity.node.type == "Conceal Crouch")) && behaviorTreeEntity IsAtCoverNodeStrict())
	{
		entityAngles = behaviorTreeEntity.node.angles;
	}
	toEnemy = behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin;
	toEnemy = VectorNormalize((toEnemy[0], toEnemy[1], 0));
	entityForward = AnglesToForward(entityAngles);
	entityForward = VectorNormalize((entityForward[0], entityForward[1], 0));
	if(VectorDot(toEnemy, entityForward) < 0.5)
	{
		return 0;
	}
	if(!throwIfPossible)
	{
		if(behaviorTreeEntity.team === "allies")
		{
			foreach(player in level.players)
			{
				if(DistanceSquared(behaviorTreeEntity.enemy.origin, player.origin) <= 250000)
				{
					return 0;
				}
			}
		}
		foreach(player in level.players)
		{
			if(player laststand::player_is_in_laststand() && DistanceSquared(behaviorTreeEntity.enemy.origin, player.origin) <= 250000)
			{
				return 0;
			}
		}
		grenadeThrowInfos = blackboard::GetBlackboardEvents("team_grenade_throw");
		foreach(grenadeThrowInfo in grenadeThrowInfos)
		{
			if(grenadeThrowInfo.data.grenadeThrowerTeam === behaviorTreeEntity.team)
			{
				return 0;
			}
		}
		grenadeThrowInfos = blackboard::GetBlackboardEvents("human_grenade_throw");
		foreach(grenadeThrowInfo in grenadeThrowInfos)
		{
			if(isdefined(grenadeThrowInfo.data.grenadeThrownAt) && isalive(grenadeThrowInfo.data.grenadeThrownAt))
			{
				if(grenadeThrowInfo.data.grenadeThrower == behaviorTreeEntity)
				{
					return 0;
				}
				if(isdefined(grenadeThrowInfo.data.grenadeThrownAt) && grenadeThrowInfo.data.grenadeThrownAt == behaviorTreeEntity.enemy)
				{
					return 0;
				}
				if(isdefined(grenadeThrowInfo.data.grenadeThrownPosition) && isdefined(behaviorTreeEntity.grenadeThrowPosition) && DistanceSquared(grenadeThrowInfo.data.grenadeThrownPosition, behaviorTreeEntity.grenadeThrowPosition) <= 360000)
				{
					return 0;
				}
			}
		}
	}
	throw_dist = Distance2DSquared(behaviorTreeEntity.origin, behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy));
	if(throw_dist < 500 * 500 || throw_dist > 1250 * 1250)
	{
		return 0;
	}
	arm_offset = TEMP_get_arm_offset(behaviorTreeEntity, behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy));
	throw_vel = behaviorTreeEntity CanThrowGrenadePos(arm_offset, behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy));
	if(!isdefined(throw_vel))
	{
		return 0;
	}
	return 1;
}

/*
	Name: senseNearbyPlayers
	Namespace: archetype_human_cover
	Checksum: 0x3A98B8D7
	Offset: 0x10D8
	Size: 0x159
	Parameters: 1
	Flags: Private
*/
function private senseNearbyPlayers(entity)
{
	players = GetPlayers();
	foreach(player in players)
	{
		distanceSq = DistanceSquared(player.origin, entity.origin);
		if(distanceSq <= 360 * 360)
		{
			distanceToPlayer = sqrt(distanceSq);
			chanceToDetect = RandomFloat(1);
			if(chanceToDetect < distanceToPlayer / 360)
			{
				entity GetPerfectInfo(player);
			}
		}
	}
}

/*
	Name: coverPrepareToThrowGrenade
	Namespace: archetype_human_cover
	Checksum: 0x6FD0DB0C
	Offset: 0x1240
	Size: 0x18F
	Parameters: 1
	Flags: Private
*/
function private coverPrepareToThrowGrenade(behaviorTreeEntity)
{
	AiUtility::keepClaimedNodeAndChooseCoverDirection(behaviorTreeEntity);
	if(isdefined(behaviorTreeEntity.enemy))
	{
		behaviorTreeEntity.grenadeThrowPosition = behaviorTreeEntity lastKnownPos(behaviorTreeEntity.enemy);
	}
	grenadeThrowInfo = spawnstruct();
	grenadeThrowInfo.grenadeThrower = behaviorTreeEntity;
	grenadeThrowInfo.grenadeThrownAt = behaviorTreeEntity.enemy;
	grenadeThrowInfo.grenadeThrownPosition = behaviorTreeEntity.grenadeThrowPosition;
	blackboard::AddBlackboardEvent("human_grenade_throw", grenadeThrowInfo, randomIntRange(15000, 20000));
	grenadeThrowInfo = spawnstruct();
	grenadeThrowInfo.grenadeThrowerTeam = behaviorTreeEntity.team;
	blackboard::AddBlackboardEvent("team_grenade_throw", grenadeThrowInfo, randomIntRange(1000, 2000));
	behaviorTreeEntity.prepareGrenadeAmmo = behaviorTreeEntity.grenadeAmmo;
}

/*
	Name: coverCleanUpToThrowGrenade
	Namespace: archetype_human_cover
	Checksum: 0x8D8A6813
	Offset: 0x13D8
	Size: 0x21B
	Parameters: 1
	Flags: Private
*/
function private coverCleanUpToThrowGrenade(behaviorTreeEntity)
{
	AiUtility::resetCoverParameters(behaviorTreeEntity);
	if(behaviorTreeEntity.prepareGrenadeAmmo == behaviorTreeEntity.grenadeAmmo)
	{
		if(behaviorTreeEntity.health <= 0)
		{
			grenade = undefined;
			if(IsActor(behaviorTreeEntity.enemy) && isdefined(behaviorTreeEntity.grenadeWeapon))
			{
				grenade = behaviorTreeEntity.enemy MagicGrenadeType(behaviorTreeEntity.grenadeWeapon, behaviorTreeEntity GetTagOrigin("j_wrist_ri"), (0, 0, 0), behaviorTreeEntity.grenadeWeapon.aifusetime / 1000);
			}
			else if(isPlayer(behaviorTreeEntity.enemy) && isdefined(behaviorTreeEntity.grenadeWeapon))
			{
				grenade = behaviorTreeEntity.enemy MagicGrenadePlayer(behaviorTreeEntity.grenadeWeapon, behaviorTreeEntity GetTagOrigin("j_wrist_ri"), (0, 0, 0));
			}
			if(isdefined(grenade))
			{
				grenade.owner = behaviorTreeEntity;
				grenade.team = behaviorTreeEntity.team;
				~grenade.team;
				grenade setContents(grenade setContents(0) & 32768 | 67108864 | 8388608 | 33554432);
			}
		}
	}
}

/*
	Name: canChangeStanceAtCoverCondition
	Namespace: archetype_human_cover
	Checksum: 0xB37ED1EB
	Offset: 0x1600
	Size: 0x9B
	Parameters: 1
	Flags: Private
*/
function private canChangeStanceAtCoverCondition(behaviorTreeEntity)
{
	switch(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance"))
	{
		case "stand":
		{
			return AiUtility::isStanceAllowedAtNode("crouch", behaviorTreeEntity.node);
		}
		case "crouch":
		{
			return AiUtility::isStanceAllowedAtNode("stand", behaviorTreeEntity.node);
		}
	}
	return 0;
}

/*
	Name: shouldReturnToSuppressedCover
	Namespace: archetype_human_cover
	Checksum: 0x4847EDE1
	Offset: 0x16A8
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private shouldReturnToSuppressedCover(entity)
{
	if(!entity IsAtGoal())
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldReturnToCoverCondition
	Namespace: archetype_human_cover
	Checksum: 0x584B1F1
	Offset: 0x16E0
	Size: 0x1A5
	Parameters: 1
	Flags: Private
*/
function private shouldReturnToCoverCondition(behaviorTreeEntity)
{
	if(behaviorTreeEntity ASMIsTransitionRunning())
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.coverShootStartTime))
	{
		if(GetTime() < behaviorTreeEntity.coverShootStartTime + 800)
		{
			return 0;
		}
		if(isdefined(behaviorTreeEntity.enemy) && isPlayer(behaviorTreeEntity.enemy) && behaviorTreeEntity.enemy.health < behaviorTreeEntity.enemy.maxhealth * 0.5)
		{
			if(GetTime() < behaviorTreeEntity.coverShootStartTime + 3000)
			{
				return 0;
			}
		}
	}
	if(AiUtility::isSuppressedAtCoverCondition(behaviorTreeEntity))
	{
		return 1;
	}
	if(!behaviorTreeEntity IsAtGoal())
	{
		if(isdefined(behaviorTreeEntity.node))
		{
			offsetOrigin = behaviorTreeEntity GetNodeOffsetPosition(behaviorTreeEntity.node);
			return !behaviorTreeEntity IsPosAtGoal(offsetOrigin);
		}
		return 1;
	}
	if(!behaviorTreeEntity IsSafeFromGrenade())
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldAdjustToCover
	Namespace: archetype_human_cover
	Checksum: 0x858E187C
	Offset: 0x1890
	Size: 0x155
	Parameters: 1
	Flags: Private
*/
function private shouldAdjustToCover(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.node))
	{
		return 0;
	}
	highestSupportedStance = AiUtility::getHighestNodeStance(behaviorTreeEntity.node);
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(currentStance == "crouch" && highestSupportedStance == "crouch")
	{
		return 0;
	}
	coverMode = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode");
	previousCoverMode = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_previous_cover_mode");
	if(coverMode != "cover_alert" && previousCoverMode != "cover_alert" && !behaviorTreeEntity.keepClaimedNode)
	{
		return 1;
	}
	if(!AiUtility::isStanceAllowedAtNode(currentStance, behaviorTreeEntity.node))
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldVantageAtCoverCondition
	Namespace: archetype_human_cover
	Checksum: 0xFF83653A
	Offset: 0x19F0
	Size: 0x1C1
	Parameters: 1
	Flags: Private
*/
function private shouldVantageAtCoverCondition(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.node) || !isdefined(behaviorTreeEntity.node.type) || !isdefined(behaviorTreeEntity.enemy) || !isdefined(behaviorTreeEntity.enemy.origin))
	{
		return 0;
	}
	yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode(behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy);
	pitchToEnemyPosition = AiUtility::GetAimPitchToEnemyFromNode(behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy);
	aimLimitsForCover = behaviorTreeEntity GetAimLimitsFromEntry("cover_vantage");
	legalAim = 0;
	if(yawToEnemyPosition < aimLimitsForCover["aim_left"] && yawToEnemyPosition > aimLimitsForCover["aim_right"] && pitchToEnemyPosition < 85 && pitchToEnemyPosition > 25 && behaviorTreeEntity.node.origin[2] - behaviorTreeEntity.enemy.origin[2] >= 36)
	{
		legalAim = 1;
	}
	return legalAim;
}

/*
	Name: supportsVantageCoverCondition
	Namespace: archetype_human_cover
	Checksum: 0x7623DBA2
	Offset: 0x1BC0
	Size: 0xD
	Parameters: 1
	Flags: Private
*/
function private supportsVantageCoverCondition(behaviorTreeEntity)
{
	return 0;
}

/*
	Name: coverVantageInitialize
	Namespace: archetype_human_cover
	Checksum: 0x1AF350A3
	Offset: 0x1BD8
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private coverVantageInitialize(behaviorTreeEntity, asmStateName)
{
	AiUtility::keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_vantage");
}

/*
	Name: coverBlindfireShootActionStart
	Namespace: archetype_human_cover
	Checksum: 0xA4C580A3
	Offset: 0x1C38
	Size: 0x6B
	Parameters: 2
	Flags: Private
*/
function private coverBlindfireShootActionStart(behaviorTreeEntity, asmStateName)
{
	AiUtility::keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_blind");
	AiUtility::chooseCoverDirection(behaviorTreeEntity);
}

/*
	Name: prepareToChangeStanceToStand
	Namespace: archetype_human_cover
	Checksum: 0x7E67CCB5
	Offset: 0x1CB0
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private prepareToChangeStanceToStand(behaviorTreeEntity, asmStateName)
{
	AiUtility::cleanupCoverMode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
}

/*
	Name: cleanUpChangeStanceToStand
	Namespace: archetype_human_cover
	Checksum: 0xB664F0D0
	Offset: 0x1D10
	Size: 0x3B
	Parameters: 2
	Flags: Private
*/
function private cleanUpChangeStanceToStand(behaviorTreeEntity, asmStateName)
{
	AiUtility::releaseClaimNode(behaviorTreeEntity);
	behaviorTreeEntity.newEnemyReaction = 0;
}

/*
	Name: prepareToChangeStanceToCrouch
	Namespace: archetype_human_cover
	Checksum: 0x1B2F02DA
	Offset: 0x1D58
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private prepareToChangeStanceToCrouch(behaviorTreeEntity, asmStateName)
{
	AiUtility::cleanupCoverMode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "crouch");
}

/*
	Name: cleanUpChangeStanceToCrouch
	Namespace: archetype_human_cover
	Checksum: 0x41C91CEE
	Offset: 0x1DB8
	Size: 0x3B
	Parameters: 2
	Flags: Private
*/
function private cleanUpChangeStanceToCrouch(behaviorTreeEntity, asmStateName)
{
	AiUtility::releaseClaimNode(behaviorTreeEntity);
	behaviorTreeEntity.newEnemyReaction = 0;
}

/*
	Name: prepareForAdjustToCover
	Namespace: archetype_human_cover
	Checksum: 0x67C54587
	Offset: 0x1E00
	Size: 0x7B
	Parameters: 2
	Flags: Private
*/
function private prepareForAdjustToCover(behaviorTreeEntity, asmStateName)
{
	AiUtility::keepClaimNode(behaviorTreeEntity);
	highestSupportedStance = AiUtility::getHighestNodeStance(behaviorTreeEntity.node);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", highestSupportedStance);
}

/*
	Name: coverChangeStanceActionStart
	Namespace: archetype_human_cover
	Checksum: 0x396022EA
	Offset: 0x1E88
	Size: 0xDD
	Parameters: 2
	Flags: Private
*/
function private coverChangeStanceActionStart(behaviorTreeEntity, asmStateName)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_alert");
	AiUtility::keepClaimNode(behaviorTreeEntity);
	switch(blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance"))
	{
		case "stand":
		{
			blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "crouch");
			break;
		}
		case "crouch":
		{
			blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
			break;
		}
	}
}

/*
	Name: TEMP_get_arm_offset
	Namespace: archetype_human_cover
	Checksum: 0xFB9EBCB6
	Offset: 0x1F70
	Size: 0x48D
	Parameters: 2
	Flags: None
*/
function TEMP_get_arm_offset(behaviorTreeEntity, throwPosition)
{
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	arm_offset = undefined;
	if(stance == "crouch")
	{
		arm_offset = (13, -1, 56);
	}
	else
	{
		arm_offset = (14, -3, 80);
	}
	if(isdefined(behaviorTreeEntity.node) && behaviorTreeEntity IsAtCoverNodeStrict())
	{
		if(behaviorTreeEntity.node.type == "Cover Left")
		{
			if(stance == "crouch")
			{
				arm_offset = (-38, 15, 23);
			}
			else
			{
				arm_offset = (-45, 0, 40);
			}
		}
		else if(behaviorTreeEntity.node.type == "Cover Right")
		{
			if(stance == "crouch")
			{
				arm_offset = (46, 12, 26);
			}
			else
			{
				arm_offset = (34, -21, 50);
			}
		}
		else if(behaviorTreeEntity.node.type == "Cover Stand" || behaviorTreeEntity.node.type == "Conceal Stand")
		{
			arm_offset = (10, 7, 77);
		}
		else if(behaviorTreeEntity.node.type == "Cover Crouch" || behaviorTreeEntity.node.type == "Cover Crouch Window" || behaviorTreeEntity.node.type == "Conceal Crouch")
		{
			arm_offset = (19, 5, 60);
		}
		else if(behaviorTreeEntity.node.type == "Cover Pillar")
		{
			leftOffset = undefined;
			rightOffset = undefined;
			if(stance == "crouch")
			{
				leftOffset = (-20, 0, 35);
				rightOffset = (34, 6, 50);
			}
			else
			{
				leftOffset = (-24, 0, 76);
				rightOffset = (24, 0, 76);
			}
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 1024 == 1024)
			{
				arm_offset = rightOffset;
			}
			else if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 2048 == 2048)
			{
				arm_offset = leftOffset;
			}
			else
			{
				yawToEnemyPosition = AngleClamp180(VectorToAngles(throwPosition - behaviorTreeEntity.node.origin)[1] - behaviorTreeEntity.node.angles[1]);
				aimLimitsForDirectionRight = behaviorTreeEntity GetAimLimitsFromEntry("pillar_right_lean");
				legalRightDirectionYaw = yawToEnemyPosition >= aimLimitsForDirectionRight["aim_right"] - 10 && yawToEnemyPosition <= 0;
				if(legalRightDirectionYaw)
				{
					arm_offset = rightOffset;
				}
				else
				{
					arm_offset = leftOffset;
				}
			}
		}
	}
	return arm_offset;
}

