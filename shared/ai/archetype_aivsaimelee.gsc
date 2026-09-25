#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;

#namespace archetype_aivsaimelee;

/*
	Name: main
	Namespace: archetype_aivsaimelee
	Checksum: 0xC7F9612D
	Offset: 0x3A0
	Size: 0x221
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	meleeBundles = struct::get_script_bundles("aiassassination");
	level._aivsai_meleeBundles = [];
	foreach(meleeBundle in meleeBundles)
	{
		attacker_archetype = meleeBundle.attackerArchetype;
		defender_archetype = meleeBundle.defenderArchetype;
		attacker_variant = meleeBundle.attackerVariant;
		defender_variant = meleeBundle.defenderVariant;
		if(!isdefined(level._aivsai_meleeBundles[attacker_archetype]))
		{
			level._aivsai_meleeBundles[attacker_archetype] = [];
			level._aivsai_meleeBundles[attacker_archetype][defender_archetype] = [];
			level._aivsai_meleeBundles[attacker_archetype][defender_archetype][attacker_variant] = [];
		}
		else if(!isdefined(level._aivsai_meleeBundles[attacker_archetype][defender_archetype]))
		{
			level._aivsai_meleeBundles[attacker_archetype][defender_archetype] = [];
			level._aivsai_meleeBundles[attacker_archetype][defender_archetype][attacker_variant] = [];
		}
		else if(!isdefined(level._aivsai_meleeBundles[attacker_archetype][defender_archetype][attacker_variant]))
		{
			level._aivsai_meleeBundles[attacker_archetype][defender_archetype][attacker_variant] = [];
		}
		level._aivsai_meleeBundles[attacker_archetype][defender_archetype][attacker_variant][defender_variant] = meleeBundle;
	}
}

/*
	Name: RegisterAIvsAIMeleeBehaviorFunctions
	Namespace: archetype_aivsaimelee
	Checksum: 0x99C3745
	Offset: 0x5D0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function RegisterAIvsAIMeleeBehaviorFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasAIvsAIEnemy", &hasAIvsAIEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("decideInitiator", &decideInitiator);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isInitiator", &isInitiator);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasCloseAIvsAIEnemy", &hasCloseAIvsAIEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseAIvsAIMeleeAnimations", &chooseAIvsAIMeleeAnimations);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isCloseEnoughForAIvsAIMelee", &isCloseEnoughForAIvsAIMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasPotentalAIvsAIMeleeEnemy", &hasPotentalAIvsAIMeleeEnemy);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("AIvsAIMeleeAction", &AIvsAIMeleeInitialize, undefined, undefined);
}

/*
	Name: hasPotentalAIvsAIMeleeEnemy
	Namespace: archetype_aivsaimelee
	Checksum: 0x32248689
	Offset: 0x728
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function hasPotentalAIvsAIMeleeEnemy(behaviorTreeEntity)
{
	if(!hasAIvsAIEnemy(behaviorTreeEntity))
	{
		return 0;
	}
	if(!chooseAIvsAIMeleeAnimations(behaviorTreeEntity))
	{
		return 0;
	}
	if(!hasCloseAIvsAIEnemy(behaviorTreeEntity))
	{
		return 1;
	}
	return 0;
}

/*
	Name: isCloseEnoughForAIvsAIMelee
	Namespace: archetype_aivsaimelee
	Checksum: 0x716572B
	Offset: 0x7A0
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function isCloseEnoughForAIvsAIMelee(behaviorTreeEntity)
{
	if(!hasAIvsAIEnemy(behaviorTreeEntity))
	{
		return 0;
	}
	if(!chooseAIvsAIMeleeAnimations(behaviorTreeEntity))
	{
		return 0;
	}
	if(!hasCloseAIvsAIEnemy(behaviorTreeEntity))
	{
		return 0;
	}
	return 1;
}

/*
	Name: shouldAquireMutexOnEnemyForAIvsAIMelee
	Namespace: archetype_aivsaimelee
	Checksum: 0x74863FED
	Offset: 0x818
	Size: 0x113
	Parameters: 1
	Flags: Private
*/
function private shouldAquireMutexOnEnemyForAIvsAIMelee(behaviorTreeEntity)
{
	if(isPlayer(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.melee))
	{
		if(isdefined(behaviorTreeEntity.melee.enemy) && behaviorTreeEntity.melee.enemy == behaviorTreeEntity.enemy)
		{
			return 1;
		}
	}
	if(isdefined(behaviorTreeEntity.enemy.melee))
	{
		if(isdefined(behaviorTreeEntity.enemy.melee.enemy) && behaviorTreeEntity.enemy.melee.enemy != behaviorTreeEntity)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: hasAIvsAIEnemy
	Namespace: archetype_aivsaimelee
	Checksum: 0xD30D861C
	Offset: 0x938
	Size: 0xCAD
	Parameters: 1
	Flags: Private
*/
function private hasAIvsAIEnemy(behaviorTreeEntity)
{
	enemy = behaviorTreeEntity.enemy;
	if(GetDvarInt("disable_aivsai_melee", 0))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(!isdefined(enemy))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(!(isalive(behaviorTreeEntity) && isalive(enemy)))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(!isai(enemy) || !IsActor(enemy))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(isdefined(enemy.archetype))
	{
		if(SessionModeIsCampaignZombiesGame())
		{
			if(enemy.archetype != "human" && enemy.archetype != "human_riotshield" && enemy.archetype != "robot" && enemy.archetype != "zombie")
			{
				/#
					Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
				#/
				return 0;
			}
		}
		else if(enemy.archetype != "human" && enemy.archetype != "human_riotshield" && enemy.archetype != "robot")
		{
			/#
				Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
			#/
			return 0;
		}
	}
	if(enemy.team == behaviorTreeEntity.team)
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(enemy IsRagdoll())
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(isdefined(enemy.ignoreme) && enemy.ignoreme)
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(isdefined(enemy._ai_melee_markedDead) && enemy._ai_melee_markedDead)
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(behaviorTreeEntity ai::has_behavior_attribute("can_initiateaivsaimelee") && !behaviorTreeEntity ai::get_behavior_attribute("can_initiateaivsaimelee"))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(behaviorTreeEntity ai::has_behavior_attribute("can_melee") && !behaviorTreeEntity ai::get_behavior_attribute("can_melee"))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(enemy ai::has_behavior_attribute("can_be_meleed") && !enemy ai::get_behavior_attribute("can_be_meleed"))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(Distance2DSquared(behaviorTreeEntity.origin, enemy.origin) > 22500)
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		behaviorTreeEntity._ai_melee_initiator = undefined;
		return 0;
	}
	forwardVec = VectorNormalize(AnglesToForward(behaviorTreeEntity.angles));
	rightVec = VectorNormalize(AnglesToRight(behaviorTreeEntity.angles));
	toEnemyVec = VectorNormalize(enemy.origin - behaviorTreeEntity.origin);
	fDot = VectorDot(toEnemyVec, forwardVec);
	if(fDot < 0)
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(enemy isInScriptedState())
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	currentStance = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_stance");
	enemyStance = blackboard::GetBlackBoardAttribute(enemy, "_stance");
	if(currentStance != "stand" || enemyStance != "stand")
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(!shouldAquireMutexOnEnemyForAIvsAIMelee(behaviorTreeEntity))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(Abs(behaviorTreeEntity.origin[2] - behaviorTreeEntity.enemy.origin[2]) > 16)
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	raisedEnemyEntOrigin = (behaviorTreeEntity.enemy.origin[0], behaviorTreeEntity.enemy.origin[1], behaviorTreeEntity.enemy.origin[2] + 8);
	if(!behaviorTreeEntity MayMoveToPoint(raisedEnemyEntOrigin, 0, 1, behaviorTreeEntity.enemy))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	if(isdefined(enemy.allowdeath) && !enemy.allowdeath)
	{
		if(isdefined(behaviorTreeEntity.allowdeath) && !behaviorTreeEntity.allowdeath)
		{
			/#
				Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
			#/
			self notify("failed_melee_mbs", enemy);
			return 0;
		}
		behaviorTreeEntity._ai_melee_attacker_loser = 1;
		return 1;
	}
	return 1;
}

/*
	Name: decideInitiator
	Namespace: archetype_aivsaimelee
	Checksum: 0x6E2B8799
	Offset: 0x15F0
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private decideInitiator(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity._ai_melee_initiator))
	{
		if(!isdefined(behaviorTreeEntity.enemy._ai_melee_initiator))
		{
			behaviorTreeEntity._ai_melee_initiator = 1;
			return 1;
		}
	}
	return 0;
}

/*
	Name: isInitiator
	Namespace: archetype_aivsaimelee
	Checksum: 0x5DB14E7
	Offset: 0x1650
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private isInitiator(behaviorTreeEntity)
{
	if(!(isdefined(behaviorTreeEntity._ai_melee_initiator) && behaviorTreeEntity._ai_melee_initiator))
	{
		return 0;
	}
	return 1;
}

/*
	Name: hasCloseAIvsAIEnemy
	Namespace: archetype_aivsaimelee
	Checksum: 0xB0798A2E
	Offset: 0x1698
	Size: 0x40B
	Parameters: 1
	Flags: Private
*/
function private hasCloseAIvsAIEnemy(behaviorTreeEntity)
{
	if(!(isdefined(behaviorTreeEntity._ai_melee_animname) && isdefined(behaviorTreeEntity.enemy._ai_melee_animname)))
	{
		/#
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	animationStartOrigin = GetStartOrigin(behaviorTreeEntity.enemy GetTagOrigin("tag_sync"), behaviorTreeEntity.enemy GetTagAngles("tag_sync"), behaviorTreeEntity._ai_melee_animname);
	/#
		Record3DText("Dev Block strings are not supported" + sqrt(900), behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		Record3DText("Dev Block strings are not supported" + Distance(animationStartOrigin, behaviorTreeEntity.origin), behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		RecordCircle(behaviorTreeEntity.enemy GetTagOrigin("Dev Block strings are not supported"), 8, (1, 0, 0), "Dev Block strings are not supported", behaviorTreeEntity);
		RecordCircle(animationStartOrigin, 8, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity);
		recordLine(animationStartOrigin, behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity);
	#/
	if(Distance2DSquared(behaviorTreeEntity.origin, animationStartOrigin) <= 900)
	{
		return 1;
	}
	if(behaviorTreeEntity HasPath())
	{
		selfPredictedPos = behaviorTreeEntity.origin;
		moveAngle = behaviorTreeEntity.angles[1] + behaviorTreeEntity getMotionAngle();
		selfPredictedPos = selfPredictedPos + (cos(moveAngle), sin(moveAngle), 0) * 200 * 0.2;
		/#
			Record3DText("Dev Block strings are not supported" + Distance(selfPredictedPos, animationStartOrigin), behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		if(Distance2DSquared(selfPredictedPos, animationStartOrigin) <= 900)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: chooseAIvsAIMeleeAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0x35D2FE1
	Offset: 0x1AB0
	Size: 0x583
	Parameters: 1
	Flags: Private
*/
function private chooseAIvsAIMeleeAnimations(behaviorTreeEntity)
{
	anglesToEnemy = VectorToAngles(behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin);
	yawToEnemy = AngleClamp180(behaviorTreeEntity.enemy.angles[1] - anglesToEnemy[1]);
	/#
		Record3DText("Dev Block strings are not supported" + Abs(yawToEnemy), behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
	#/
	behaviorTreeEntity._ai_melee_animname = undefined;
	behaviorTreeEntity.enemy._ai_melee_animname = undefined;
	attacker_variant = chooseArchetypeVariant(behaviorTreeEntity);
	defender_variant = chooseArchetypeVariant(behaviorTreeEntity.enemy);
	if(!AIvsAIMeleeBundleExists(behaviorTreeEntity, attacker_variant, defender_variant))
	{
		/#
			Record3DText("Dev Block strings are not supported" + behaviorTreeEntity.archetype + "Dev Block strings are not supported" + behaviorTreeEntity.enemy.archetype + "Dev Block strings are not supported" + attacker_variant + "Dev Block strings are not supported" + defender_variant, behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		#/
		return 0;
	}
	animBundle = level._aivsai_meleeBundles[behaviorTreeEntity.archetype][behaviorTreeEntity.enemy.archetype][attacker_variant][defender_variant];
	/#
		if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
		{
			Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		}
	#/
	foundAnims = 0;
	possibleMelees = [];
	if(Abs(yawToEnemy) > 120)
	{
		if(isdefined(behaviorTreeEntity.__forceAIFlipMelee))
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontFlipAnimations;
		}
		else if(isdefined(behaviorTreeEntity.__forceAIWrestleMelee))
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontWrestleAnimations;
		}
		else
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontFlipAnimations;
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontWrestleAnimations;
		}
	}
	else if(Abs(yawToEnemy) < 60)
	{
		possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeBackAnimations;
	}
	else
	{
		rightVec = VectorNormalize(AnglesToRight(behaviorTreeEntity.enemy.angles));
		toAttackerVec = VectorNormalize(behaviorTreeEntity.origin - behaviorTreeEntity.enemy.origin);
		rDot = VectorDot(toAttackerVec, rightVec);
		if(rDot > 0)
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeRightAnimations;
		}
		else
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeLeftAnimations;
		}
	}
	if(possibleMelees.size > 0)
	{
		[[possibleMelees[getArrayKeys(possibleMelees)[RandomInt(getArrayKeys(possibleMelees).size)]]]](behaviorTreeEntity, animBundle);
	}
	if(isdefined(behaviorTreeEntity._ai_melee_animname))
	{
		Debug_ChosenMeleeAnimations(behaviorTreeEntity);
		return 1;
	}
	return 0;
}

/*
	Name: chooseArchetypeVariant
	Namespace: archetype_aivsaimelee
	Checksum: 0x72193FA9
	Offset: 0x2040
	Size: 0xED
	Parameters: 1
	Flags: Private
*/
function private chooseArchetypeVariant(entity)
{
	if(entity.archetype == "robot")
	{
		robot_state = entity ai::get_behavior_attribute("rogue_control");
		if(IsInArray(Array("forced_level_1", "level_1", "level_0"), robot_state))
		{
			return "regular";
		}
		if(IsInArray(Array("forced_level_2", "level_2", "level_3", "forced_level_3"), robot_state))
		{
			return "melee";
		}
	}
	return "regular";
}

/*
	Name: AIvsAIMeleeBundleExists
	Namespace: archetype_aivsaimelee
	Checksum: 0xF96D9184
	Offset: 0x2138
	Size: 0x103
	Parameters: 3
	Flags: Private
*/
function private AIvsAIMeleeBundleExists(behaviorTreeEntity, attacker_variant, defender_variant)
{
	if(!isdefined(level._aivsai_meleeBundles[behaviorTreeEntity.archetype]))
	{
		return 0;
	}
	else if(!isdefined(level._aivsai_meleeBundles[behaviorTreeEntity.archetype][behaviorTreeEntity.enemy.archetype]))
	{
		return 0;
	}
	else if(!isdefined(level._aivsai_meleeBundles[behaviorTreeEntity.archetype][behaviorTreeEntity.enemy.archetype][attacker_variant]))
	{
		return 0;
	}
	else if(!isdefined(level._aivsai_meleeBundles[behaviorTreeEntity.archetype][behaviorTreeEntity.enemy.archetype][attacker_variant][defender_variant]))
	{
		return 0;
	}
	return 1;
}

/*
	Name: AIvsAIMeleeInitialize
	Namespace: archetype_aivsaimelee
	Checksum: 0x3260C6FB
	Offset: 0x2248
	Size: 0x127
	Parameters: 2
	Flags: None
*/
function AIvsAIMeleeInitialize(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.blockingPain = 1;
	behaviorTreeEntity.enemy.blockingPain = 1;
	AiUtility::meleeAcquireMutex(behaviorTreeEntity);
	behaviorTreeEntity._ai_melee_opponent = behaviorTreeEntity.enemy;
	behaviorTreeEntity.enemy._ai_melee_opponent = behaviorTreeEntity;
	if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
	{
		behaviorTreeEntity._ai_melee_markedDead = 1;
		behaviorTreeEntity.enemy thread playScriptedMeleeAnimations();
	}
	else
	{
		behaviorTreeEntity.enemy._ai_melee_markedDead = 1;
		behaviorTreeEntity thread playScriptedMeleeAnimations();
	}
	return 5;
}

/*
	Name: playScriptedMeleeAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0x600F4C53
	Offset: 0x2378
	Size: 0x563
	Parameters: 0
	Flags: None
*/
function playScriptedMeleeAnimations()
{
	self endon("death");
	/#
		Assert(isdefined(self._ai_melee_opponent));
	#/
	opponent = self._ai_melee_opponent;
	if(!(isalive(self) && isalive(opponent)))
	{
		/#
			Record3DText("Dev Block strings are not supported", self.origin, (1, 0.5, 0), "Dev Block strings are not supported", self, 0.4);
		#/
		return 0;
	}
	if(isdefined(opponent._ai_melee_attacker_loser) && opponent._ai_melee_attacker_loser)
	{
		opponent AnimScripted("aivsaimeleeloser", self GetTagOrigin("tag_sync"), self GetTagAngles("tag_sync"), opponent._ai_melee_animname, "normal", undefined, 1, 0.2, 0.3);
		self AnimScripted("aivsaimeleewinner", self GetTagOrigin("tag_sync"), self GetTagAngles("tag_sync"), self._ai_melee_animname, "normal", undefined, 1, 0.2, 0.3);
		/#
			RecordCircle(self GetTagOrigin("Dev Block strings are not supported"), 2, (1, 0.5, 0), "Dev Block strings are not supported");
			recordLine(self GetTagOrigin("Dev Block strings are not supported"), opponent.origin, (1, 0.5, 0), "Dev Block strings are not supported");
		#/
	}
	else
	{
		self AnimScripted("aivsaimeleewinner", opponent GetTagOrigin("tag_sync"), opponent GetTagAngles("tag_sync"), self._ai_melee_animname, "normal", undefined, 1, 0.2, 0.3);
		opponent AnimScripted("aivsaimeleeloser", opponent GetTagOrigin("tag_sync"), opponent GetTagAngles("tag_sync"), opponent._ai_melee_animname, "normal", undefined, 1, 0.2, 0.3);
		/#
			RecordCircle(opponent GetTagOrigin("Dev Block strings are not supported"), 2, (1, 0.5, 0), "Dev Block strings are not supported");
			recordLine(opponent GetTagOrigin("Dev Block strings are not supported"), self.origin, (1, 0.5, 0), "Dev Block strings are not supported");
		#/
	}
	opponent thread handleDeath(opponent._ai_melee_animname, self);
	if(GetDvarInt("tu1_aivsaiMeleeDisableGib", 1))
	{
		if(opponent ai::has_behavior_attribute("can_gib"))
		{
			opponent ai::set_behavior_attribute("can_gib", 0);
		}
	}
	self thread processInterruptedDeath();
	opponent thread processInterruptedDeath();
	self waittillmatch("hash_20b9df71");
	self.fixedLinkYawOnly = 0;
	AiUtility::cleanupChargeMeleeAttack(self);
	if(isdefined(self._ai_melee_attachedKnife) && self._ai_melee_attachedKnife)
	{
		self Detach("t6_wpn_knife_melee", "TAG_WEAPON_LEFT");
		self._ai_melee_attachedKnife = 0;
	}
	self.blockingPain = 0;
	self._ai_melee_initiator = undefined;
	self notify("meleeCompleted", "end");
	self PathMode("move delayed", 1, 3);
}

/*
	Name: chooseAIVsAIMeleeFrontFlipAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0x141DF37E
	Offset: 0x28E8
	Size: 0x15B
	Parameters: 2
	Flags: Private
*/
function private chooseAIVsAIMeleeFrontFlipAnimations(behaviorTreeEntity, animBundle)
{
	/#
		Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
	#/
	/#
		Assert(isdefined(animBundle));
	#/
	if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerFrontAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimFrontAnim;
	}
	behaviorTreeEntity._ai_melee_animtype = 1;
	behaviorTreeEntity.enemy._ai_melee_animtype = 1;
}

/*
	Name: chooseAIVsAIMeleeFrontWrestleAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0xB584CD90
	Offset: 0x2A50
	Size: 0x153
	Parameters: 2
	Flags: Private
*/
function private chooseAIVsAIMeleeFrontWrestleAnimations(behaviorTreeEntity, animBundle)
{
	/#
		Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
	#/
	/#
		Assert(isdefined(animBundle));
	#/
	if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserAlternateFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerAlternateFrontAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerAlternateFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimAlternateFrontAnim;
	}
	behaviorTreeEntity._ai_melee_animtype = 0;
	behaviorTreeEntity.enemy._ai_melee_animtype = 0;
}

/*
	Name: chooseAIVsAIMeleeBackAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0x6D6F2A6C
	Offset: 0x2BB0
	Size: 0x15B
	Parameters: 2
	Flags: Private
*/
function private chooseAIVsAIMeleeBackAnimations(behaviorTreeEntity, animBundle)
{
	/#
		Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
	#/
	/#
		Assert(isdefined(animBundle));
	#/
	if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserBackAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerBackAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerBackAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimBackAnim;
	}
	behaviorTreeEntity._ai_melee_animtype = 2;
	behaviorTreeEntity.enemy._ai_melee_animtype = 2;
}

/*
	Name: chooseAIVsAIMeleeRightAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0x6009560D
	Offset: 0x2D18
	Size: 0x15B
	Parameters: 2
	Flags: Private
*/
function private chooseAIVsAIMeleeRightAnimations(behaviorTreeEntity, animBundle)
{
	/#
		Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
	#/
	/#
		Assert(isdefined(animBundle));
	#/
	if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserRightAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerRightAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerRightAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimRightAnim;
	}
	behaviorTreeEntity._ai_melee_animtype = 3;
	behaviorTreeEntity.enemy._ai_melee_animtype = 3;
}

/*
	Name: chooseAIVsAIMeleeLeftAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0xA4B31D2A
	Offset: 0x2E80
	Size: 0x15B
	Parameters: 2
	Flags: Private
*/
function private chooseAIVsAIMeleeLeftAnimations(behaviorTreeEntity, animBundle)
{
	/#
		Record3DText("Dev Block strings are not supported", behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
	#/
	/#
		Assert(isdefined(animBundle));
	#/
	if(isdefined(behaviorTreeEntity._ai_melee_attacker_loser) && behaviorTreeEntity._ai_melee_attacker_loser)
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserLeftAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerLeftAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLeftAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimLeftAnim;
	}
	behaviorTreeEntity._ai_melee_animtype = 4;
	behaviorTreeEntity.enemy._ai_melee_animtype = 4;
}

/*
	Name: Debug_ChosenMeleeAnimations
	Namespace: archetype_aivsaimelee
	Checksum: 0x6428B321
	Offset: 0x2FE8
	Size: 0xFB
	Parameters: 1
	Flags: Private
*/
function private Debug_ChosenMeleeAnimations(behaviorTreeEntity)
{
	/#
		if(isdefined(behaviorTreeEntity._ai_melee_animname) && isdefined(behaviorTreeEntity.enemy._ai_melee_animname))
		{
			Record3DText("Dev Block strings are not supported" + behaviorTreeEntity._ai_melee_animname, behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
			Record3DText("Dev Block strings are not supported" + behaviorTreeEntity.enemy._ai_melee_animname, behaviorTreeEntity.origin, (1, 0.5, 0), "Dev Block strings are not supported", behaviorTreeEntity, 0.4);
		}
	#/
}

/*
	Name: handleDeath
	Namespace: archetype_aivsaimelee
	Checksum: 0x53BF8115
	Offset: 0x30F0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function handleDeath(animationName, attacker)
{
	self endon("death");
	self endon("interruptedDeath");
	self.skipdeath = 1;
	self.diedInScriptedAnim = 1;
	totalTime = getanimlength(animationName);
	wait(totalTime - 0.2);
	self killWrapper(attacker);
}

/*
	Name: processInterruptedDeath
	Namespace: archetype_aivsaimelee
	Checksum: 0x7A3EC122
	Offset: 0x3188
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function processInterruptedDeath()
{
	self endon("meleeCompleted");
	/#
		Assert(isdefined(self._ai_melee_opponent));
	#/
	opponent = self._ai_melee_opponent;
	if(!(isdefined(self.allowdeath) && self.allowdeath))
	{
		return;
	}
	self waittill("death");
	if(isdefined(self) && (isdefined(self._ai_melee_attachedKnife) && self._ai_melee_attachedKnife))
	{
		self Detach("t6_wpn_knife_melee", "TAG_WEAPON_LEFT");
	}
	if(isalive(opponent))
	{
		if(isdefined(opponent._ai_melee_markedDead) && opponent._ai_melee_markedDead)
		{
			opponent.diedInScriptedAnim = 1;
			opponent.skipdeath = 1;
			opponent notify("interruptedDeath");
			opponent notify("meleeCompleted");
			opponent StopAnimScripted();
			opponent killWrapper();
			opponent StartRagdoll();
		}
		else
		{
			opponent._ai_melee_initiator = undefined;
			opponent.blockingPain = 0;
			opponent._ai_melee_markedDead = undefined;
			opponent.skipdeath = 0;
			opponent.diedInScriptedAnim = 0;
			AiUtility::cleanupChargeMeleeAttack(opponent);
			opponent notify("interruptedDeath");
			opponent notify("meleeCompleted");
			opponent StopAnimScripted();
		}
	}
	if(isdefined(self))
	{
		self.diedInScriptedAnim = 1;
		self.skipdeath = 1;
		self notify("interruptedDeath");
		self StopAnimScripted();
		self killWrapper();
		self StartRagdoll();
	}
}

/*
	Name: killWrapper
	Namespace: archetype_aivsaimelee
	Checksum: 0xF9896A69
	Offset: 0x3410
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function killWrapper(attacker)
{
	if(isdefined(self.overrideActorDamage))
	{
		self.overrideActorDamage = undefined;
	}
	self.TokubetsuKogekita = undefined;
	if(isdefined(attacker) && self.team != attacker.team)
	{
		self kill(self.origin, attacker);
	}
	else
	{
		self kill();
	}
}

