#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;

#namespace AiUtility;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: AiUtility
	Checksum: 0xAFB593FB
	Offset: 0x658
	Size: 0x503
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCrouchNode", &isAtCrouchNode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverCondition", &isAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverStrictCondition", &isAtCoverStrictCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverModeOver", &isAtCoverModeOver);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverModeNone", &isAtCoverModeNone);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isExposedAtCoverCondition", &isExposedAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keepClaimedNodeAndChooseCoverDirection", &keepClaimedNodeAndChooseCoverDirection);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("resetCoverParameters", &resetCoverParameters);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupCoverMode", &cleanupCoverMode);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canBeFlankedService", &canBeFlankedService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldCoverIdleOnly", &shouldCoverIdleOnly);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isSuppressedAtCoverCondition", &isSuppressedAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverIdleInitialize", &coverIdleInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverIdleUpdate", &coverIdleUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverIdleTerminate", &coverIdleTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isFlankedByEnemyAtCover", &isFlankedByEnemyAtCover);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverFlankedActionStart", &coverFlankedInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverFlankedActionTerminate", &coverFlankedActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsOverCoverCondition", &supportsOverCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldOverAtCoverCondition", &shouldOverAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverOverInitialize", &coverOverInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverOverTerminate", &coverOverTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsLeanCoverCondition", &supportsLeanCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldLeanAtCoverCondition", &shouldLeanAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("continueLeaningAtCoverCondition", &continueLeaningAtCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverLeanInitialize", &coverLeanInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverLeanTerminate", &coverLeanTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsPeekCoverCondition", &supportsPeekCoverCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverPeekInitialize", &coverPeekInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverPeekTerminate", &coverPeekTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverReloadInitialize", &coverReloadInitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("refillAmmoAndCleanupCoverMode", &refillAmmoAndCleanupCoverMode);
}

/*
	Name: coverReloadInitialize
	Namespace: AiUtility
	Checksum: 0x6A6FDD18
	Offset: 0xB68
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private coverReloadInitialize(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_alert");
	keepClaimNode(behaviorTreeEntity);
}

/*
	Name: refillAmmoAndCleanupCoverMode
	Namespace: AiUtility
	Checksum: 0x61DB8B36
	Offset: 0xBC0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function refillAmmoAndCleanupCoverMode(behaviorTreeEntity)
{
	if(isalive(behaviorTreeEntity))
	{
		refillAmmo(behaviorTreeEntity);
	}
	cleanupCoverMode(behaviorTreeEntity);
}

/*
	Name: supportsPeekCoverCondition
	Namespace: AiUtility
	Checksum: 0xFE942645
	Offset: 0xC20
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private supportsPeekCoverCondition(behaviorTreeEntity)
{
	return isdefined(behaviorTreeEntity.node);
}

/*
	Name: coverPeekInitialize
	Namespace: AiUtility
	Checksum: 0x64C072A5
	Offset: 0xC48
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private coverPeekInitialize(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_alert");
	keepClaimNode(behaviorTreeEntity);
	chooseCoverDirection(behaviorTreeEntity);
}

/*
	Name: coverPeekTerminate
	Namespace: AiUtility
	Checksum: 0xAE796100
	Offset: 0xCB8
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private coverPeekTerminate(behaviorTreeEntity)
{
	chooseFrontCoverDirection(behaviorTreeEntity);
	cleanupCoverMode(behaviorTreeEntity);
}

/*
	Name: supportsLeanCoverCondition
	Namespace: AiUtility
	Checksum: 0xE70EF4A6
	Offset: 0xD00
	Size: 0x123
	Parameters: 1
	Flags: Private
*/
function private supportsLeanCoverCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.node))
	{
		if(behaviorTreeEntity.node.type == "Cover Left" || behaviorTreeEntity.node.type == "Cover Right")
		{
			return 1;
		}
		else if(behaviorTreeEntity.node.type == "Cover Pillar")
		{
			if(!isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 1024 == 1024 || (!isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 2048 == 2048))
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: shouldLeanAtCoverCondition
	Namespace: AiUtility
	Checksum: 0xA1C27AEC
	Offset: 0xE30
	Size: 0x33F
	Parameters: 1
	Flags: Private
*/
function private shouldLeanAtCoverCondition(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.node) || !isdefined(behaviorTreeEntity.node.type) || !isdefined(behaviorTreeEntity.enemy) || !isdefined(behaviorTreeEntity.enemy.origin))
	{
		return 0;
	}
	yawToEnemyPosition = GetAimYawToEnemyFromNode(behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy);
	legalAimYaw = 0;
	if(behaviorTreeEntity.node.type == "Cover Left")
	{
		aimLimitsForCover = behaviorTreeEntity GetAimLimitsFromEntry("cover_left_lean");
		legalAimYaw = yawToEnemyPosition <= aimLimitsForCover["aim_left"] + 10 && yawToEnemyPosition >= -10;
	}
	else if(behaviorTreeEntity.node.type == "Cover Right")
	{
		aimLimitsForCover = behaviorTreeEntity GetAimLimitsFromEntry("cover_right_lean");
		legalAimYaw = yawToEnemyPosition >= aimLimitsForCover["aim_right"] - 10 && yawToEnemyPosition <= 10;
	}
	else if(behaviorTreeEntity.node.type == "Cover Pillar")
	{
		aimLimitsForCover = behaviorTreeEntity GetAimLimitsFromEntry("cover");
		supportsLeft = !isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 1024 == 1024;
		supportsRight = !isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 2048 == 2048;
		angleLeeway = 10;
		if(supportsRight && supportsLeft)
		{
			angleLeeway = 0;
		}
		if(supportsLeft)
		{
			legalAimYaw = yawToEnemyPosition <= aimLimitsForCover["aim_left"] + 10 && yawToEnemyPosition >= angleLeeway * -1;
		}
		if(!legalAimYaw && supportsRight)
		{
			legalAimYaw = yawToEnemyPosition >= aimLimitsForCover["aim_right"] - 10 && yawToEnemyPosition <= angleLeeway;
		}
	}
	return legalAimYaw;
}

/*
	Name: continueLeaningAtCoverCondition
	Namespace: AiUtility
	Checksum: 0xEC2360E2
	Offset: 0x1178
	Size: 0x41
	Parameters: 1
	Flags: Private
*/
function private continueLeaningAtCoverCondition(behaviorTreeEntity)
{
	if(behaviorTreeEntity ASMIsTransitionRunning())
	{
		return 1;
	}
	return shouldLeanAtCoverCondition(behaviorTreeEntity);
}

/*
	Name: coverLeanInitialize
	Namespace: AiUtility
	Checksum: 0x562801CD
	Offset: 0x11C8
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private coverLeanInitialize(behaviorTreeEntity)
{
	setCoverShootStartTime(behaviorTreeEntity);
	keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_lean");
	chooseCoverDirection(behaviorTreeEntity);
}

/*
	Name: coverLeanTerminate
	Namespace: AiUtility
	Checksum: 0x98EA0A0E
	Offset: 0x1250
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private coverLeanTerminate(behaviorTreeEntity)
{
	chooseFrontCoverDirection(behaviorTreeEntity);
	cleanupCoverMode(behaviorTreeEntity);
	clearCoverShootStartTime(behaviorTreeEntity);
}

/*
	Name: supportsOverCoverCondition
	Namespace: AiUtility
	Checksum: 0x2FEF1789
	Offset: 0x12B0
	Size: 0x1B3
	Parameters: 1
	Flags: Private
*/
function private supportsOverCoverCondition(behaviorTreeEntity)
{
	stance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	if(isdefined(behaviorTreeEntity.node))
	{
		if(!IsInArray(GetValidCoverPeekOuts(behaviorTreeEntity.node), "over"))
		{
			return 0;
		}
		if(behaviorTreeEntity.node.type == "Cover Left" || behaviorTreeEntity.node.type == "Cover Right" || (behaviorTreeEntity.node.type == "Cover Crouch" || behaviorTreeEntity.node.type == "Cover Crouch Window" || behaviorTreeEntity.node.type == "Conceal Crouch"))
		{
			if(stance == "crouch")
			{
				return 1;
			}
		}
		else if(behaviorTreeEntity.node.type == "Cover Stand" || behaviorTreeEntity.node.type == "Conceal Stand")
		{
			if(stance == "stand")
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: shouldOverAtCoverCondition
	Namespace: AiUtility
	Checksum: 0xF1209478
	Offset: 0x1470
	Size: 0x1F1
	Parameters: 1
	Flags: Private
*/
function private shouldOverAtCoverCondition(entity)
{
	if(!isdefined(entity.node) || !isdefined(entity.node.type) || !isdefined(entity.enemy) || !isdefined(entity.enemy.origin))
	{
		return 0;
	}
	if(isCoverConcealed(entity.node))
	{
	}
	else
	{
	}
	aimTable = "cover_over";
	aimLimitsForCover = entity GetAimLimitsFromEntry(aimTable);
	yawToEnemyPosition = GetAimYawToEnemyFromNode(entity, entity.node, entity.enemy);
	legalAimYaw = yawToEnemyPosition >= aimLimitsForCover["aim_right"] - 10 && yawToEnemyPosition <= aimLimitsForCover["aim_left"] + 10;
	if(!legalAimYaw)
	{
		return 0;
	}
	pitchToEnemyPosition = GetAimPitchToEnemyFromNode(entity, entity.node, entity.enemy);
	legalAimPitch = pitchToEnemyPosition >= aimLimitsForCover["aim_up"] + 10 && pitchToEnemyPosition <= aimLimitsForCover["aim_down"] + 10;
	if(!legalAimPitch)
	{
		return 0;
	}
	return 1;
}

/*
	Name: coverOverInitialize
	Namespace: AiUtility
	Checksum: 0x9F66328F
	Offset: 0x1670
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private coverOverInitialize(behaviorTreeEntity)
{
	setCoverShootStartTime(behaviorTreeEntity);
	keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_over");
}

/*
	Name: coverOverTerminate
	Namespace: AiUtility
	Checksum: 0x30598AD9
	Offset: 0x16E0
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private coverOverTerminate(behaviorTreeEntity)
{
	cleanupCoverMode(behaviorTreeEntity);
	clearCoverShootStartTime(behaviorTreeEntity);
}

/*
	Name: coverIdleInitialize
	Namespace: AiUtility
	Checksum: 0x317799C8
	Offset: 0x1728
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private coverIdleInitialize(behaviorTreeEntity)
{
	keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_alert");
}

/*
	Name: coverIdleUpdate
	Namespace: AiUtility
	Checksum: 0xD4CC29C4
	Offset: 0x1780
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private coverIdleUpdate(behaviorTreeEntity)
{
	if(!behaviorTreeEntity ASMIsTransitionRunning())
	{
		releaseClaimNode(behaviorTreeEntity);
	}
}

/*
	Name: coverIdleTerminate
	Namespace: AiUtility
	Checksum: 0x3CBAD582
	Offset: 0x17C8
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private coverIdleTerminate(behaviorTreeEntity)
{
	releaseClaimNode(behaviorTreeEntity);
	cleanupCoverMode(behaviorTreeEntity);
}

/*
	Name: isFlankedByEnemyAtCover
	Namespace: AiUtility
	Checksum: 0xF3337E03
	Offset: 0x1810
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private isFlankedByEnemyAtCover(behaviorTreeEntity)
{
	return canBeFlanked(behaviorTreeEntity) && behaviorTreeEntity IsAtCoverNodeStrict() && behaviorTreeEntity IsFlankedAtCoverNode() && !behaviorTreeEntity HasPath();
}

/*
	Name: canBeFlankedService
	Namespace: AiUtility
	Checksum: 0x43C9E4EA
	Offset: 0x1888
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private canBeFlankedService(behaviorTreeEntity)
{
	setCanBeFlanked(behaviorTreeEntity, 1);
}

/*
	Name: coverFlankedInitialize
	Namespace: AiUtility
	Checksum: 0x34B27321
	Offset: 0x18B8
	Size: 0xD3
	Parameters: 1
	Flags: Private
*/
function private coverFlankedInitialize(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy))
	{
		behaviorTreeEntity GetPerfectInfo(behaviorTreeEntity.enemy);
		behaviorTreeEntity PathMode("move delayed", 0, 2);
	}
	setCanBeFlanked(behaviorTreeEntity, 0);
	cleanupCoverMode(behaviorTreeEntity);
	keepClaimNode(behaviorTreeEntity);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_desired_stance", "stand");
}

/*
	Name: coverFlankedActionTerminate
	Namespace: AiUtility
	Checksum: 0xC476C8E3
	Offset: 0x1998
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private coverFlankedActionTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity.newEnemyReaction = 0;
	releaseClaimNode(behaviorTreeEntity);
}

/*
	Name: isAtCrouchNode
	Namespace: AiUtility
	Checksum: 0x40CE1BF0
	Offset: 0x19D8
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function isAtCrouchNode(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.node) && (behaviorTreeEntity.node.type == "Exposed" || behaviorTreeEntity.node.type == "Guard" || behaviorTreeEntity.node.type == "Path"))
	{
		if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.node.origin) <= 24 * 24)
		{
			return !isStanceAllowedAtNode("stand", behaviorTreeEntity.node) && isStanceAllowedAtNode("crouch", behaviorTreeEntity.node);
		}
	}
	return 0;
}

/*
	Name: isAtCoverCondition
	Namespace: AiUtility
	Checksum: 0xE95D1FCE
	Offset: 0x1B00
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function isAtCoverCondition(behaviorTreeEntity)
{
	return behaviorTreeEntity IsAtCoverNodeStrict() && behaviorTreeEntity ShouldUseCoverNode() && !behaviorTreeEntity HasPath();
}

/*
	Name: isAtCoverStrictCondition
	Namespace: AiUtility
	Checksum: 0xA8964D68
	Offset: 0x1B60
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function isAtCoverStrictCondition(behaviorTreeEntity)
{
	return behaviorTreeEntity IsAtCoverNodeStrict() && !behaviorTreeEntity HasPath();
}

/*
	Name: isAtCoverModeOver
	Namespace: AiUtility
	Checksum: 0x5ED99EA0
	Offset: 0x1BA8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function isAtCoverModeOver(behaviorTreeEntity)
{
	coverMode = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode");
	return coverMode == "cover_over";
}

/*
	Name: isAtCoverModeNone
	Namespace: AiUtility
	Checksum: 0x61592CAE
	Offset: 0x1BF8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function isAtCoverModeNone(behaviorTreeEntity)
{
	coverMode = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode");
	return coverMode == "cover_mode_none";
}

/*
	Name: isExposedAtCoverCondition
	Namespace: AiUtility
	Checksum: 0xED85490D
	Offset: 0x1C48
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function isExposedAtCoverCondition(behaviorTreeEntity)
{
	return behaviorTreeEntity IsAtCoverNodeStrict() && !behaviorTreeEntity ShouldUseCoverNode();
}

/*
	Name: shouldCoverIdleOnly
	Namespace: AiUtility
	Checksum: 0x80415F0E
	Offset: 0x1C90
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function shouldCoverIdleOnly(behaviorTreeEntity)
{
	if(behaviorTreeEntity ai::get_behavior_attribute("coverIdleOnly"))
	{
		return 1;
	}
	if(isdefined(behaviorTreeEntity.node.script_onlyidle) && behaviorTreeEntity.node.script_onlyidle)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isSuppressedAtCoverCondition
	Namespace: AiUtility
	Checksum: 0x6A05B019
	Offset: 0x1D10
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function isSuppressedAtCoverCondition(behaviorTreeEntity)
{
	return behaviorTreeEntity.suppressionMeter > behaviorTreeEntity.suppressionThreshold;
}

/*
	Name: keepClaimedNodeAndChooseCoverDirection
	Namespace: AiUtility
	Checksum: 0x5D1FF9D
	Offset: 0x1D40
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function keepClaimedNodeAndChooseCoverDirection(behaviorTreeEntity)
{
	keepClaimNode(behaviorTreeEntity);
	chooseCoverDirection(behaviorTreeEntity);
}

/*
	Name: resetCoverParameters
	Namespace: AiUtility
	Checksum: 0xD9A5C848
	Offset: 0x1D88
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function resetCoverParameters(behaviorTreeEntity)
{
	chooseFrontCoverDirection(behaviorTreeEntity);
	cleanupCoverMode(behaviorTreeEntity);
	clearCoverShootStartTime(behaviorTreeEntity);
}

/*
	Name: chooseCoverDirection
	Namespace: AiUtility
	Checksum: 0x34827DB8
	Offset: 0x1DE8
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function chooseCoverDirection(behaviorTreeEntity, stepOut)
{
	if(!isdefined(behaviorTreeEntity.node))
	{
		return;
	}
	coverDirection = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_direction");
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_previous_cover_direction", coverDirection);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_direction", calculateCoverDirection(behaviorTreeEntity, stepOut));
}

/*
	Name: calculateCoverDirection
	Namespace: AiUtility
	Checksum: 0x34D777BD
	Offset: 0x1EA0
	Size: 0x493
	Parameters: 2
	Flags: None
*/
function calculateCoverDirection(behaviorTreeEntity, stepOut)
{
	if(isdefined(behaviorTreeEntity.treatAllCoversAsGeneric))
	{
		if(!isdefined(stepOut))
		{
			stepOut = 0;
		}
		coverDirection = "cover_front_direction";
		if(behaviorTreeEntity.node.type == "Cover Left")
		{
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 4 == 4 || math::cointoss() || stepOut)
			{
				coverDirection = "cover_left_direction";
			}
		}
		else if(behaviorTreeEntity.node.type == "Cover Right")
		{
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 4 == 4 || math::cointoss() || stepOut)
			{
				coverDirection = "cover_right_direction";
			}
		}
		else if(behaviorTreeEntity.node.type == "Cover Pillar")
		{
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 1024 == 1024)
			{
				return "cover_right_direction";
			}
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 2048 == 2048)
			{
				return "cover_left_direction";
			}
			coverDirection = "cover_left_direction";
			if(isdefined(behaviorTreeEntity.enemy))
			{
				yawToEnemyPosition = GetAimYawToEnemyFromNode(behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy);
				aimLimitsForDirectionRight = behaviorTreeEntity GetAimLimitsFromEntry("pillar_right_lean");
				legalRightDirectionYaw = yawToEnemyPosition >= aimLimitsForDirectionRight["aim_right"] - 10 && yawToEnemyPosition <= 0;
				if(legalRightDirectionYaw)
				{
					coverDirection = "cover_right_direction";
				}
			}
		}
		return coverDirection;
	}
	else
	{
		coverDirection = "cover_front_direction";
		if(behaviorTreeEntity.node.type == "Cover Pillar")
		{
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 1024 == 1024)
			{
				return "cover_right_direction";
			}
			if(isdefined(behaviorTreeEntity.node.SPAWNFLAGS) && behaviorTreeEntity.node.SPAWNFLAGS & 2048 == 2048)
			{
				return "cover_left_direction";
			}
			coverDirection = "cover_left_direction";
			if(isdefined(behaviorTreeEntity.enemy))
			{
				yawToEnemyPosition = GetAimYawToEnemyFromNode(behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy);
				aimLimitsForDirectionRight = behaviorTreeEntity GetAimLimitsFromEntry("pillar_right_lean");
				legalRightDirectionYaw = yawToEnemyPosition >= aimLimitsForDirectionRight["aim_right"] - 10 && yawToEnemyPosition <= 0;
				if(legalRightDirectionYaw)
				{
					coverDirection = "cover_right_direction";
				}
			}
		}
	}
	return coverDirection;
}

/*
	Name: clearCoverShootStartTime
	Namespace: AiUtility
	Checksum: 0xBA8F02C
	Offset: 0x2340
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function clearCoverShootStartTime(behaviorTreeEntity)
{
	behaviorTreeEntity.coverShootStartTime = undefined;
}

/*
	Name: setCoverShootStartTime
	Namespace: AiUtility
	Checksum: 0x9AC73F53
	Offset: 0x2368
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function setCoverShootStartTime(behaviorTreeEntity)
{
	behaviorTreeEntity.coverShootStartTime = GetTime();
}

/*
	Name: canBeFlanked
	Namespace: AiUtility
	Checksum: 0x7902730E
	Offset: 0x2390
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function canBeFlanked(behaviorTreeEntity)
{
	return isdefined(behaviorTreeEntity.canBeFlanked) && behaviorTreeEntity.canBeFlanked;
}

/*
	Name: setCanBeFlanked
	Namespace: AiUtility
	Checksum: 0xFF7096CB
	Offset: 0x23C8
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function setCanBeFlanked(behaviorTreeEntity, canBeFlanked)
{
	behaviorTreeEntity.canBeFlanked = canBeFlanked;
}

/*
	Name: cleanupCoverMode
	Namespace: AiUtility
	Checksum: 0xB57632BD
	Offset: 0x23F8
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function cleanupCoverMode(behaviorTreeEntity)
{
	if(isAtCoverCondition(behaviorTreeEntity))
	{
		coverMode = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode");
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_previous_cover_mode", coverMode);
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_mode_none");
	}
	else
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_previous_cover_mode", "cover_mode_none");
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_cover_mode", "cover_mode_none");
	}
}

