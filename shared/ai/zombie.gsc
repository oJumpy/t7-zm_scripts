#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_zombie_interface;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace ZombieBehavior;

/*
	Name: init
	Namespace: ZombieBehavior
	Checksum: 0xEABD0F58
	Offset: 0xD08
	Size: 0x123
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitZombieBehaviorsAndASM();
	spawner::add_archetype_spawn_function("zombie", &ArchetypeZombieBlackboardInit);
	spawner::add_archetype_spawn_function("zombie", &ArchetypeZombieDeathOverrideInit);
	spawner::add_archetype_spawn_function("zombie", &ArchetypeZombieSpecialEffectsInit);
	spawner::add_archetype_spawn_function("zombie", &zombie_utility::zombieSpawnSetup);
	clientfield::register("actor", "zombie", 1, 1, "int");
	clientfield::register("actor", "zombie_special_day", 6001, 1, "counter");
	ZombieInterface::RegisterZombieInterfaceAttributes();
}

/*
	Name: InitZombieBehaviorsAndASM
	Namespace: ZombieBehavior
	Checksum: 0xAAE773BD
	Offset: 0xE38
	Size: 0x6F3
	Parameters: 0
	Flags: Private
*/
function private InitZombieBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveAction", &zombieMoveAction, &zombieMoveActionUpdate, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieTargetService", &zombieTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieCrawlerCollisionService", &zombieCrawlerCollision);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieTraversalService", &zombieTraversalService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsAtAttackObject", &zombieIsAtAttackObject);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldAttackObject", &zombieShouldAttackObject);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMelee", &zombieShouldMeleeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldJumpMelee", &zombieShouldJumpMeleeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldJumpUnderwaterMelee", &zombieShouldJumpUnderwaterMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGibLegsCondition", &zombieGibLegsCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldDisplayPain", &zombieShouldDisplayPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isZombieWalking", &isZombieWalking);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMeleeSuicide", &zombieShouldMeleeSuicide);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieMeleeSuicideStart", &zombieMeleeSuicideStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieMeleeSuicideUpdate", &zombieMeleeSuicideUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieMeleeSuicideTerminate", &zombieMeleeSuicideTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldJuke", &zombieShouldJukeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeActionStart", &zombieJukeActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeActionTerminate", &zombieJukeActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDeathAction", &zombieDeathAction);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeService", &zombieJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStumbleService", &zombieStumble);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStumbleCondition", &zombieShouldStumbleCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStumbleActionStart", &zombieStumbleActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieAttackObjectStart", &zombieAttackObjectStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieAttackObjectTerminate", &zombieAttackObjectTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByInterdimensionalGun", &wasKilledByInterdimensionalGunCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasCrushedByInterdimensionalGunBlackhole", &wasCrushedByInterdimensionalGunBlackholeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIDGunDeathUpdate", &zombieIDGunDeathUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieVortexPullUpdate", &zombieIDGunDeathUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieHasLegs", &zombieHasLegs);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldProceduralTraverse", &zombieShouldProceduralTraverse);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("zombie_melee", &zombieNotetrackMeleeFire);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("crushed", &zombieNotetrackCrushFire);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_death_idgun@zombie", &zombieIDGunDeathMocompStart, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_vortex_pull@zombie", &zombieIDGunDeathMocompStart, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_death_idgun_hole@zombie", &zombieIDGunHoleDeathMocompStart, undefined, &zombieIDGunHoleDeathMocompTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_turn@zombie", &zombieTurnMocompStart, &zombieTurnMocompUpdate, &zombieTurnMocompTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_melee_jump@zombie", &zombieMeleeJumpMocompStart, &zombieMeleeJumpMocompUpdate, &zombieMeleeJumpMocompTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_zombie_idle@zombie", &zombieZombieIdleMocompStart, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_attack_object@zombie", &zombieAttackObjectMocompStart, &zombieAttackObjectMocompUpdate, undefined);
}

/*
	Name: ArchetypeZombieBlackboardInit
	Namespace: ZombieBehavior
	Checksum: 0x474E1C3A
	Offset: 0x1538
	Size: 0x5B3
	Parameters: 0
	Flags: None
*/
function ArchetypeZombieBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(self);
	blackboard::RegisterBlackBoardAttribute(self, "_arms_position", "arms_up", &BB_GetArmsPosition);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", &BB_GetLocomotionSpeedType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_has_legs", "has_legs_yes", &BB_GetHasLegsStatus);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_variant_type", 0, &BB_GetVariantType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_which_board_pull", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_board_attack_spot", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_grapple_direction", undefined, undefined);
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
	blackboard::RegisterBlackBoardAttribute(self, "_idgun_damage_direction", "back", &BB_IDGunGetDamageDirection);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_low_gravity_variant", 0, &BB_GetLowGravityVariant);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_knockdown_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_knockdown_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_whirlwind_speed", "whirlwind_normal", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_zombie_blackholebomb_pull_state", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeZombieOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeZombieOnAnimscriptedCallback
	Namespace: ZombieBehavior
	Checksum: 0xBCDF9E74
	Offset: 0x1AF8
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeZombieOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeZombieBlackboardInit();
}

/*
	Name: ArchetypeZombieSpecialEffectsInit
	Namespace: ZombieBehavior
	Checksum: 0xEDF73A18
	Offset: 0x1B38
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function ArchetypeZombieSpecialEffectsInit()
{
	AiUtility::AddAIOverrideDamageCallback(self, &ArchetypeZombieSpecialEffectsCallback);
}

/*
	Name: ArchetypeZombieSpecialEffectsCallback
	Namespace: ZombieBehavior
	Checksum: 0x844B21F7
	Offset: 0x1B68
	Size: 0xF7
	Parameters: 13
	Flags: Private
*/
function private ArchetypeZombieSpecialEffectsCallback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName)
{
	specialDayEffectChance = GetDvarInt("tu6_ffotd_zombieSpecialDayEffectsChance", 0);
	if(specialDayEffectChance && RandomInt(100) < specialDayEffectChance)
	{
		if(isdefined(eAttacker) && isPlayer(eAttacker))
		{
			self clientfield::increment("zombie_special_day");
		}
	}
	return iDamage;
}

/*
	Name: BB_GetArmsPosition
	Namespace: ZombieBehavior
	Checksum: 0xEFC1A862
	Offset: 0x1C68
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function BB_GetArmsPosition()
{
	if(isdefined(self.zombie_arms_position))
	{
		if(self.zombie_arms_position == "up")
		{
			return "arms_up";
		}
		return "arms_down";
	}
	return "arms_up";
}

/*
	Name: BB_GetLocomotionSpeedType
	Namespace: ZombieBehavior
	Checksum: 0x3CE7253E
	Offset: 0x1CB0
	Size: 0xF1
	Parameters: 0
	Flags: None
*/
function BB_GetLocomotionSpeedType()
{
	if(isdefined(self.zombie_move_speed))
	{
		if(self.zombie_move_speed == "walk")
		{
			return "locomotion_speed_walk";
		}
		else if(self.zombie_move_speed == "run")
		{
			return "locomotion_speed_run";
		}
		else if(self.zombie_move_speed == "sprint")
		{
			return "locomotion_speed_sprint";
		}
		else if(self.zombie_move_speed == "super_sprint")
		{
			return "locomotion_speed_super_sprint";
		}
		else if(self.zombie_move_speed == "jump_pad_super_sprint")
		{
			return "locomotion_speed_jump_pad_super_sprint";
		}
		else if(self.zombie_move_speed == "burned")
		{
			return "locomotion_speed_burned";
		}
		else if(self.zombie_move_speed == "slide")
		{
			return "locomotion_speed_slide";
		}
	}
	return "locomotion_speed_walk";
}

/*
	Name: BB_GetVariantType
	Namespace: ZombieBehavior
	Checksum: 0x90CFFC3C
	Offset: 0x1DB0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function BB_GetVariantType()
{
	if(isdefined(self.variant_type))
	{
		return self.variant_type;
	}
	return 0;
}

/*
	Name: BB_GetHasLegsStatus
	Namespace: ZombieBehavior
	Checksum: 0x1D2BC77F
	Offset: 0x1DD8
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function BB_GetHasLegsStatus()
{
	if(self.missingLegs)
	{
		return "has_legs_no";
	}
	return "has_legs_yes";
}

/*
	Name: BB_GetShouldTurn
	Namespace: ZombieBehavior
	Checksum: 0x58256513
	Offset: 0x1E00
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function BB_GetShouldTurn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: BB_IDGunGetDamageDirection
	Namespace: ZombieBehavior
	Checksum: 0x61257325
	Offset: 0x1E38
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function BB_IDGunGetDamageDirection()
{
	if(isdefined(self.damage_direction))
	{
		return self.damage_direction;
	}
	return self AiUtility::BB_GetDamageDirection();
}

/*
	Name: BB_GetLowGravityVariant
	Namespace: ZombieBehavior
	Checksum: 0x5FBF48FE
	Offset: 0x1E70
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function BB_GetLowGravityVariant()
{
	if(isdefined(self.LOW_GRAVITY_VARIANT))
	{
		return self.LOW_GRAVITY_VARIANT;
	}
	return 0;
}

/*
	Name: isZombieWalking
	Namespace: ZombieBehavior
	Checksum: 0xC6CC2638
	Offset: 0x1E98
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function isZombieWalking(behaviorTreeEntity)
{
	return !isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs;
}

/*
	Name: zombieShouldDisplayPain
	Namespace: ZombieBehavior
	Checksum: 0x9A38B6A1
	Offset: 0x1ED0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function zombieShouldDisplayPain(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.suicidalDeath) && behaviorTreeEntity.suicidalDeath)
	{
		return 0;
	}
	return !isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs;
}

/*
	Name: zombieShouldJukeCondition
	Namespace: ZombieBehavior
	Checksum: 0x4B04AD93
	Offset: 0x1F30
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function zombieShouldJukeCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.JUKE) && (behaviorTreeEntity.JUKE == "left" || behaviorTreeEntity.JUKE == "right"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieShouldStumbleCondition
	Namespace: ZombieBehavior
	Checksum: 0xAE83B099
	Offset: 0x1F98
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function zombieShouldStumbleCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.stumble))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieJukeActionStart
	Namespace: ZombieBehavior
	Checksum: 0x9D6F04C9
	Offset: 0x1FC8
	Size: 0xB5
	Parameters: 1
	Flags: Private
*/
function private zombieJukeActionStart(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_juke_direction", behaviorTreeEntity.JUKE);
	if(isdefined(behaviorTreeEntity.jukeDistance))
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_juke_distance", behaviorTreeEntity.jukeDistance);
	}
	else
	{
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_juke_distance", "short");
	}
	behaviorTreeEntity.jukeDistance = undefined;
	behaviorTreeEntity.JUKE = undefined;
}

/*
	Name: zombieJukeActionTerminate
	Namespace: ZombieBehavior
	Checksum: 0x34258B7F
	Offset: 0x2088
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private zombieJukeActionTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity clearPath();
}

/*
	Name: zombieStumbleActionStart
	Namespace: ZombieBehavior
	Checksum: 0x34C6476B
	Offset: 0x20B8
	Size: 0x19
	Parameters: 1
	Flags: Private
*/
function private zombieStumbleActionStart(behaviorTreeEntity)
{
	behaviorTreeEntity.stumble = undefined;
}

/*
	Name: zombieAttackObjectStart
	Namespace: ZombieBehavior
	Checksum: 0xCEFCFBFC
	Offset: 0x20E0
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private zombieAttackObjectStart(behaviorTreeEntity)
{
	behaviorTreeEntity.is_inert = 1;
}

/*
	Name: zombieAttackObjectTerminate
	Namespace: ZombieBehavior
	Checksum: 0x750CD3AA
	Offset: 0x2108
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private zombieAttackObjectTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity.is_inert = 0;
}

/*
	Name: zombieGibLegsCondition
	Namespace: ZombieBehavior
	Checksum: 0x1114B66C
	Offset: 0x2130
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function zombieGibLegsCondition(behaviorTreeEntity)
{
	return GibServerUtils::IsGibbed(behaviorTreeEntity, 256) || GibServerUtils::IsGibbed(behaviorTreeEntity, 128);
}

/*
	Name: zombieNotetrackMeleeFire
	Namespace: ZombieBehavior
	Checksum: 0xF87AB082
	Offset: 0x2180
	Size: 0x40B
	Parameters: 1
	Flags: None
*/
function zombieNotetrackMeleeFire(entity)
{
	if(isdefined(entity.aat_turned) && entity.aat_turned)
	{
		if(isdefined(entity.enemy) && !isPlayer(entity.enemy))
		{
			if(entity.enemy.archetype == "zombie" && (isdefined(entity.enemy.allowdeath) && entity.enemy.allowdeath))
			{
				GibServerUtils::GibHead(entity.enemy);
				entity.enemy zombie_utility::gib_random_parts();
				entity.enemy kill();
				entity.n_aat_turned_zombie_kills++;
			}
			else if(entity.enemy.archetype == "zombie_quad" || entity.enemy.archetype == "spider" && (isdefined(entity.enemy.allowdeath) && entity.enemy.allowdeath))
			{
				entity.enemy kill();
				entity.n_aat_turned_zombie_kills++;
			}
			else if(isdefined(entity.enemy.canBeTargetedByTurnedZombies) && entity.enemy.canBeTargetedByTurnedZombies)
			{
				entity melee();
			}
		}
	}
	else if(isdefined(entity.enemy) && (isdefined(entity.enemy.bgb_in_plain_sight_active) && entity.enemy.bgb_in_plain_sight_active || (isdefined(entity.enemy.bgb_idle_eyes_active) && entity.enemy.bgb_idle_eyes_active)))
	{
		return;
	}
	if(isdefined(entity.enemy) && (isdefined(entity.enemy.allow_zombie_to_target_ai) && entity.enemy.allow_zombie_to_target_ai))
	{
		if(entity.enemy.health > 0)
		{
			entity.enemy DoDamage(entity.meleeWeapon.meleeDamage, entity.origin, entity, entity, "none", "MOD_MELEE");
		}
		return;
	}
	entity melee();
	/#
		Record3DText("Dev Block strings are not supported", self.origin, (1, 0, 0), "Dev Block strings are not supported", entity);
	#/
	if(zombieShouldAttackObject(entity))
	{
		if(isdefined(level.attackableCallback))
		{
			entity.attackable [[level.attackableCallback]](entity);
		}
	}
}

/*
	Name: zombieNotetrackCrushFire
	Namespace: ZombieBehavior
	Checksum: 0xED32202C
	Offset: 0x2598
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function zombieNotetrackCrushFire(behaviorTreeEntity)
{
	behaviorTreeEntity delete();
}

/*
	Name: zombieTargetService
	Namespace: ZombieBehavior
	Checksum: 0xD1A39E1F
	Offset: 0x25C8
	Size: 0x2F7
	Parameters: 1
	Flags: None
*/
function zombieTargetService(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enablePushTime))
	{
		if(GetTime() >= behaviorTreeEntity.enablePushTime)
		{
			behaviorTreeEntity PushActors(1);
			behaviorTreeEntity.enablePushTime = undefined;
		}
	}
	if(isdefined(behaviorTreeEntity.disableTargetService) && behaviorTreeEntity.disableTargetService)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.ignoreall) && behaviorTreeEntity.ignoreall)
	{
		return 0;
	}
	specificTarget = undefined;
	if(isdefined(level.zombieLevelSpecificTargetCallback))
	{
		specificTarget = [[level.zombieLevelSpecificTargetCallback]]();
	}
	if(isdefined(specificTarget))
	{
		behaviorTreeEntity SetGoal(specificTarget.origin);
	}
	else if(isdefined(behaviorTreeEntity.v_zombie_custom_goal_pos))
	{
		goalpos = behaviorTreeEntity.v_zombie_custom_goal_pos;
		if(isdefined(behaviorTreeEntity.n_zombie_custom_goal_radius))
		{
			behaviorTreeEntity.goalRadius = behaviorTreeEntity.n_zombie_custom_goal_radius;
		}
		behaviorTreeEntity SetGoal(goalpos);
	}
	else
	{
		player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
		if(!isdefined(player))
		{
			if(isdefined(self.ignore_player))
			{
				if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
				{
					return 0;
				}
				self.ignore_player = [];
			}
			self SetGoal(self.origin);
			return 0;
		}
		else if(isdefined(player.last_valid_position))
		{
			if(!(isdefined(self.zombie_do_not_update_goal) && self.zombie_do_not_update_goal))
			{
				if(isdefined(level.zombie_use_zigzag_path) && level.zombie_use_zigzag_path)
				{
					behaviorTreeEntity zombieUpdateZigZagGoal();
				}
				else
				{
					behaviorTreeEntity SetGoal(player.last_valid_position);
				}
			}
			return 1;
		}
		else if(!(isdefined(self.zombie_do_not_update_goal) && self.zombie_do_not_update_goal))
		{
			behaviorTreeEntity SetGoal(behaviorTreeEntity.origin);
		}
		return 0;
	}
}

/*
	Name: zombieUpdateZigZagGoal
	Namespace: ZombieBehavior
	Checksum: 0x1665C52F
	Offset: 0x28C8
	Size: 0x5F3
	Parameters: 0
	Flags: None
*/
function zombieUpdateZigZagGoal()
{
	AIProfile_BeginEntry("zombieUpdateZigZagGoal");
	shouldRepath = 0;
	if(!shouldRepath && isdefined(self.favoriteenemy))
	{
		if(!isdefined(self.nextGoalUpdate) || self.nextGoalUpdate <= GetTime())
		{
			shouldRepath = 1;
		}
		else if(DistanceSquared(self.origin, self.favoriteenemy.origin) <= 250 * 250)
		{
			shouldRepath = 1;
		}
		else if(isdefined(self.pathGoalPos))
		{
			distanceToGoalSqr = DistanceSquared(self.origin, self.pathGoalPos);
			shouldRepath = distanceToGoalSqr < 72 * 72;
		}
	}
	if(isdefined(self.keep_moving) && self.keep_moving)
	{
		if(GetTime() > self.keep_moving_time)
		{
			self.keep_moving = 0;
		}
	}
	if(shouldRepath)
	{
		goalpos = self.favoriteenemy.origin;
		if(isdefined(self.favoriteenemy.last_valid_position))
		{
			goalpos = self.favoriteenemy.last_valid_position;
		}
		self SetGoal(goalpos);
		if(DistanceSquared(self.origin, goalpos) > 250 * 250)
		{
			self.keep_moving = 1;
			self.keep_moving_time = GetTime() + 250;
			path = self CalcApproximatePathToPosition(goalpos, 0);
			/#
				if(GetDvarInt("Dev Block strings are not supported"))
				{
					for(index = 1; index < path.size; index++)
					{
						recordLine(path[index - 1], path[index], (1, 0.5, 0), "Dev Block strings are not supported", self);
					}
				}
			#/
			else if(isdefined(level._zombieZigZagDistanceMin) && isdefined(level._zombieZigZagDistanceMax))
			{
				min = level._zombieZigZagDistanceMin;
				max = level._zombieZigZagDistanceMax;
			}
			else
			{
				min = 240;
				max = 600;
			}
			deviationDistance = randomIntRange(min, max);
			segmentLength = 0;
			for(index = 1; index < path.size; index++)
			{
				currentSegLength = Distance(path[index - 1], path[index]);
				if(segmentLength + currentSegLength > deviationDistance)
				{
					remainingLength = deviationDistance - segmentLength;
					seedPosition = path[index - 1] + VectorNormalize(path[index] - path[index - 1]) * remainingLength;
					/#
						RecordCircle(seedPosition, 2, (1, 0.5, 0), "Dev Block strings are not supported", self);
					#/
					innerZigZagRadius = 0;
					outerZigZagRadius = 96;
					queryResult = PositionQuery_Source_Navigation(seedPosition, innerZigZagRadius, outerZigZagRadius, 0.5 * 72, 16, self, 16);
					PositionQuery_Filter_InClaimedLocation(queryResult, self);
					if(queryResult.data.size > 0)
					{
						point = queryResult.data[RandomInt(queryResult.data.size)];
						self SetGoal(point.origin);
					}
					break;
				}
				segmentLength = segmentLength + currentSegLength;
			}
		}
		else if(isdefined(level._zombieZigZagTimeMin) && isdefined(level._zombieZigZagTimeMax))
		{
			minTime = level._zombieZigZagTimeMin;
			maxTime = level._zombieZigZagTimeMax;
		}
		else
		{
			minTime = 2500;
			maxTime = 3500;
		}
		self.nextGoalUpdate = GetTime() + randomIntRange(minTime, maxTime);
	}
	AIProfile_EndEntry();
}

/*
	Name: zombieCrawlerCollision
	Namespace: ZombieBehavior
	Checksum: 0x69BDCE3B
	Offset: 0x2EC8
	Size: 0x215
	Parameters: 1
	Flags: None
*/
function zombieCrawlerCollision(behaviorTreeEntity)
{
	if(!isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs && (!isdefined(behaviorTreeEntity.KNOCKDOWN) && behaviorTreeEntity.KNOCKDOWN))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.dontPushTime))
	{
		if(GetTime() < behaviorTreeEntity.dontPushTime)
		{
			return 1;
		}
	}
	zombies = GetAITeamArray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie == behaviorTreeEntity)
		{
			continue;
		}
		if(isdefined(zombie.missingLegs) && zombie.missingLegs || (isdefined(zombie.KNOCKDOWN) && zombie.KNOCKDOWN))
		{
			continue;
		}
		dist_sq = DistanceSquared(behaviorTreeEntity.origin, zombie.origin);
		if(dist_sq < 14400)
		{
			behaviorTreeEntity PushActors(0);
			behaviorTreeEntity.dontPushTime = GetTime() + 2000;
			return 1;
		}
	}
	behaviorTreeEntity PushActors(1);
	return 0;
}

/*
	Name: zombieTraversalService
	Namespace: ZombieBehavior
	Checksum: 0x8D3CE993
	Offset: 0x30E8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function zombieTraversalService(entity)
{
	if(isdefined(entity.traverseStartNode))
	{
		entity PushActors(0);
		return 1;
	}
	return 0;
}

/*
	Name: zombieIsAtAttackObject
	Namespace: ZombieBehavior
	Checksum: 0xE903DB5E
	Offset: 0x3138
	Size: 0x1FF
	Parameters: 1
	Flags: None
*/
function zombieIsAtAttackObject(entity)
{
	if(isdefined(entity.missingLegs) && entity.missingLegs)
	{
		return 0;
	}
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return 0;
	}
	if(isdefined(entity.favoriteenemy) && (isdefined(entity.favoriteenemy.b_is_designated_target) && entity.favoriteenemy.b_is_designated_target))
	{
		return 0;
	}
	if(isdefined(entity.aat_turned) && entity.aat_turned)
	{
		return 0;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(!isdefined(entity.attackable_slot))
		{
			return 0;
		}
		dist = Distance2DSquared(entity.origin, entity.attackable_slot.origin);
		if(dist < 256)
		{
			height_offset = Abs(entity.origin[2] - entity.attackable_slot.origin[2]);
			if(height_offset < 32)
			{
				entity.is_at_attackable = 1;
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: zombieShouldAttackObject
	Namespace: ZombieBehavior
	Checksum: 0xF0A619F9
	Offset: 0x3340
	Size: 0x14D
	Parameters: 1
	Flags: None
*/
function zombieShouldAttackObject(entity)
{
	if(isdefined(entity.missingLegs) && entity.missingLegs)
	{
		return 0;
	}
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return 0;
	}
	if(isdefined(entity.favoriteenemy) && (isdefined(entity.favoriteenemy.b_is_designated_target) && entity.favoriteenemy.b_is_designated_target))
	{
		return 0;
	}
	if(isdefined(entity.aat_turned) && entity.aat_turned)
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

/*
	Name: zombieShouldMeleeCondition
	Namespace: ZombieBehavior
	Checksum: 0x7C3AA022
	Offset: 0x3498
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function zombieShouldMeleeCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemyoverride) && isdefined(behaviorTreeEntity.enemyoverride[1]))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.marked_for_death))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.ignoreMelee) && behaviorTreeEntity.ignoreMelee)
	{
		return 0;
	}
	if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) > 4096)
	{
		return 0;
	}
	yawToEnemy = AngleClamp180(behaviorTreeEntity.angles[1] - VectorToAngles(behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin)[1]);
	if(Abs(yawToEnemy) > 60)
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombieShouldJumpMeleeCondition
	Namespace: ZombieBehavior
	Checksum: 0xE20E0B6C
	Offset: 0x3608
	Size: 0x2F7
	Parameters: 1
	Flags: None
*/
function zombieShouldJumpMeleeCondition(behaviorTreeEntity)
{
	if(!(isdefined(behaviorTreeEntity.LOW_GRAVITY) && behaviorTreeEntity.LOW_GRAVITY))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.enemyoverride) && isdefined(behaviorTreeEntity.enemyoverride[1]))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.marked_for_death))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.ignoreMelee) && behaviorTreeEntity.ignoreMelee)
	{
		return 0;
	}
	if(behaviorTreeEntity.enemy IsOnGround())
	{
		return 0;
	}
	jumpChance = GetDvarFloat("zmMeleeJumpChance", 0.5);
	if(behaviorTreeEntity GetEntityNumber() % 10 / 10 > jumpChance)
	{
		return 0;
	}
	predictedPosition = behaviorTreeEntity.enemy.origin + behaviorTreeEntity.enemy GetVelocity() * 0.05 * 2;
	jumpDistanceSq = pow(GetDvarInt("zmMeleeJumpDistance", 180), 2);
	if(Distance2DSquared(behaviorTreeEntity.origin, predictedPosition) > jumpDistanceSq)
	{
		return 0;
	}
	yawToEnemy = AngleClamp180(behaviorTreeEntity.angles[1] - VectorToAngles(behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin)[1]);
	if(Abs(yawToEnemy) > 60)
	{
		return 0;
	}
	heightToEnemy = behaviorTreeEntity.enemy.origin[2] - behaviorTreeEntity.origin[2];
	if(heightToEnemy <= GetDvarInt("zmMeleeJumpHeightDifference", 60))
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombieShouldJumpUnderwaterMelee
	Namespace: ZombieBehavior
	Checksum: 0x8D53E452
	Offset: 0x3908
	Size: 0x257
	Parameters: 1
	Flags: None
*/
function zombieShouldJumpUnderwaterMelee(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemyoverride) && isdefined(behaviorTreeEntity.enemyoverride[1]))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.marked_for_death))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.ignoreMelee) && behaviorTreeEntity.ignoreMelee)
	{
		return 0;
	}
	if(behaviorTreeEntity.enemy IsOnGround())
	{
		return 0;
	}
	if(behaviorTreeEntity DepthInWater() < 48)
	{
		return 0;
	}
	jumpDistanceSq = pow(GetDvarInt("zmMeleeWaterJumpDistance", 64), 2);
	if(Distance2DSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) > jumpDistanceSq)
	{
		return 0;
	}
	yawToEnemy = AngleClamp180(behaviorTreeEntity.angles[1] - VectorToAngles(behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin)[1]);
	if(Abs(yawToEnemy) > 60)
	{
		return 0;
	}
	heightToEnemy = behaviorTreeEntity.enemy.origin[2] - behaviorTreeEntity.origin[2];
	if(heightToEnemy <= GetDvarInt("zmMeleeJumpUnderwaterHeightDifference", 48))
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombieStumble
	Namespace: ZombieBehavior
	Checksum: 0x12859AE1
	Offset: 0x3B68
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function zombieStumble(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs)
	{
		return 0;
	}
	if(!(isdefined(behaviorTreeEntity.canStumble) && behaviorTreeEntity.canStumble))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.zombie_move_speed) || behaviorTreeEntity.zombie_move_speed != "sprint")
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.stumble))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.next_stumble_time))
	{
		behaviorTreeEntity.next_stumble_time = GetTime() + randomIntRange(9000, 12000);
	}
	if(GetTime() > behaviorTreeEntity.next_stumble_time)
	{
		if(RandomInt(100) < 5)
		{
			closestPlayer = ArrayGetClosest(behaviorTreeEntity.origin, level.players);
			if(DistanceSquared(closestPlayer.origin, behaviorTreeEntity.origin) > 50000)
			{
				if(isdefined(behaviorTreeEntity.next_juke_time))
				{
					behaviorTreeEntity.next_juke_time = undefined;
				}
				behaviorTreeEntity.next_stumble_time = undefined;
				behaviorTreeEntity.stumble = 1;
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: zombieJuke
	Namespace: ZombieBehavior
	Checksum: 0x4E3E8D48
	Offset: 0x3D40
	Size: 0x3C9
	Parameters: 1
	Flags: None
*/
function zombieJuke(behaviorTreeEntity)
{
	if(!behaviorTreeEntity ai::has_behavior_attribute("can_juke"))
	{
		return 0;
	}
	if(!behaviorTreeEntity ai::get_behavior_attribute("can_juke"))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs)
	{
		return 0;
	}
	if(behaviorTreeEntity BB_GetLocomotionSpeedType() != "locomotion_speed_walk")
	{
		if(behaviorTreeEntity ai::has_behavior_attribute("spark_behavior") && !behaviorTreeEntity ai::get_behavior_attribute("spark_behavior"))
		{
			return 0;
		}
	}
	if(isdefined(behaviorTreeEntity.JUKE))
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.next_juke_time))
	{
		behaviorTreeEntity.next_juke_time = GetTime() + randomIntRange(7500, 9500);
	}
	if(GetTime() > behaviorTreeEntity.next_juke_time)
	{
		behaviorTreeEntity.next_juke_time = undefined;
		if(RandomInt(100) < 25 || (behaviorTreeEntity ai::has_behavior_attribute("spark_behavior") && behaviorTreeEntity ai::get_behavior_attribute("spark_behavior")))
		{
			if(isdefined(behaviorTreeEntity.next_stumble_time))
			{
				behaviorTreeEntity.next_stumble_time = undefined;
			}
			forwardOffset = 15;
			behaviorTreeEntity.ignoreBackwardPosition = 1;
			if(math::cointoss())
			{
				jukeDistance = 101;
				behaviorTreeEntity.jukeDistance = "long";
				switch(behaviorTreeEntity BB_GetLocomotionSpeedType())
				{
					case "locomotion_speed_run":
					case "locomotion_speed_walk":
					{
						forwardOffset = 122;
						break;
					}
					case "locomotion_speed_sprint":
					{
						forwardOffset = 129;
						break;
					}
				}
				behaviorTreeEntity.JUKE = AiUtility::calculateJukeDirection(behaviorTreeEntity, forwardOffset, jukeDistance);
			}
			if(!isdefined(behaviorTreeEntity.JUKE) || behaviorTreeEntity.JUKE == "forward")
			{
				jukeDistance = 69;
				behaviorTreeEntity.jukeDistance = "short";
				switch(behaviorTreeEntity BB_GetLocomotionSpeedType())
				{
					case "locomotion_speed_run":
					case "locomotion_speed_walk":
					{
						forwardOffset = 127;
						break;
					}
					case "locomotion_speed_sprint":
					{
						forwardOffset = 148;
						break;
					}
				}
				behaviorTreeEntity.JUKE = AiUtility::calculateJukeDirection(behaviorTreeEntity, forwardOffset, jukeDistance);
				if(behaviorTreeEntity.JUKE == "forward")
				{
					behaviorTreeEntity.JUKE = undefined;
					behaviorTreeEntity.jukeDistance = undefined;
					return 0;
				}
			}
		}
	}
}

/*
	Name: zombieDeathAction
	Namespace: ZombieBehavior
	Checksum: 0x86CE86FC
	Offset: 0x4118
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function zombieDeathAction(behaviorTreeEntity)
{
}

/*
	Name: wasKilledByInterdimensionalGunCondition
	Namespace: ZombieBehavior
	Checksum: 0x4F7A2ABF
	Offset: 0x4130
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function wasKilledByInterdimensionalGunCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.interdimensional_gun_kill) && !isdefined(behaviorTreeEntity.killby_interdimensional_gun_hole) && isalive(behaviorTreeEntity))
	{
		return 1;
	}
	return 0;
}

/*
	Name: wasCrushedByInterdimensionalGunBlackholeCondition
	Namespace: ZombieBehavior
	Checksum: 0xA729D1FB
	Offset: 0x4190
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function wasCrushedByInterdimensionalGunBlackholeCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.killby_interdimensional_gun_hole))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieIDGunDeathMocompStart
	Namespace: ZombieBehavior
	Checksum: 0x800F8EC9
	Offset: 0x41C0
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function zombieIDGunDeathMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("noclip");
	entity.pushable = 0;
	entity.blockingPain = 1;
	entity PathMode("dont move");
	entity.hole_pull_speed = 0;
}

/*
	Name: zombieMeleeJumpMocompStart
	Namespace: ZombieBehavior
	Checksum: 0xD022258E
	Offset: 0x4298
	Size: 0xD7
	Parameters: 5
	Flags: None
*/
function zombieMeleeJumpMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face enemy");
	entity animMode("noclip", 0);
	entity.pushable = 0;
	entity.blockingPain = 1;
	entity.clampToNavMesh = 0;
	entity PushActors(0);
	entity.jumpStartPosition = entity.origin;
}

/*
	Name: zombieMeleeJumpMocompUpdate
	Namespace: ZombieBehavior
	Checksum: 0x7B03A47C
	Offset: 0x4378
	Size: 0x2B3
	Parameters: 5
	Flags: None
*/
function zombieMeleeJumpMocompUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	normalizedTime = entity GetAnimTime(mocompAnim) * getanimlength(mocompAnim) + mocompAnimBlendOutTime / mocompDuration;
	if(normalizedTime > 0.5)
	{
		entity OrientMode("face angle", entity.angles[1]);
	}
	speed = 5;
	if(isdefined(entity.zombie_move_speed))
	{
		switch(entity.zombie_move_speed)
		{
			case "walk":
			{
				speed = 5;
				break;
			}
			case "run":
			{
				speed = 6;
				break;
			}
			case "sprint":
			{
				speed = 7;
				break;
			}
		}
	}
	newPosition = entity.origin + AnglesToForward(entity.angles) * speed;
	newTestPosition = (newPosition[0], newPosition[1], entity.jumpStartPosition[2]);
	newValidPosition = GetClosestPointOnNavMesh(newTestPosition, 12, 20);
	if(isdefined(newValidPosition))
	{
		newValidPosition = (newValidPosition[0], newValidPosition[1], entity.origin[2]);
	}
	else
	{
		newValidPosition = entity.origin;
	}
	groundPoint = GetClosestPointOnNavMesh(newValidPosition, 12, 20);
	if(isdefined(groundPoint) && groundPoint[2] > newValidPosition[2])
	{
		newValidPosition = (newValidPosition[0], newValidPosition[1], groundPoint[2]);
	}
	entity ForceTeleport(newValidPosition);
}

/*
	Name: zombieMeleeJumpMocompTerminate
	Namespace: ZombieBehavior
	Checksum: 0x59F7C3C8
	Offset: 0x4638
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function zombieMeleeJumpMocompTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.pushable = 1;
	entity.blockingPain = 0;
	entity.clampToNavMesh = 1;
	entity PushActors(1);
	groundPoint = GetClosestPointOnNavMesh(entity.origin, 12);
	if(isdefined(groundPoint))
	{
		entity ForceTeleport(groundPoint);
	}
}

/*
	Name: zombieIDGunDeathUpdate
	Namespace: ZombieBehavior
	Checksum: 0x65BB6823
	Offset: 0x4710
	Size: 0x3CB
	Parameters: 5
	Flags: None
*/
function zombieIDGunDeathUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(!isdefined(entity.killby_interdimensional_gun_hole))
	{
		entity_eye = entity GetEye();
		if(entity IsPaused())
		{
			entity SetIgnorePauseWorld(1);
			entity SetEntityPaused(0);
		}
		if(entity.b_vortex_repositioned !== 1)
		{
			entity.b_vortex_repositioned = 1;
			v_nearest_navmesh_point = GetClosestPointOnNavMesh(entity.damageOrigin, 36, 15);
			if(isdefined(v_nearest_navmesh_point))
			{
				f_distance = Distance(entity.damageOrigin, v_nearest_navmesh_point);
				if(f_distance < 41)
				{
					entity.damageOrigin = entity.damageOrigin + VectorScale((0, 0, 1), 36);
				}
			}
		}
		entity_center = entity.origin + entity_eye - entity.origin / 2;
		flyingDir = entity.damageOrigin - entity_center;
		lengthFromHole = length(flyingDir);
		if(lengthFromHole < entity.hole_pull_speed)
		{
			entity.killby_interdimensional_gun_hole = 1;
			entity.allowdeath = 1;
			entity.takedamage = 1;
			entity.aiOverrideDamage = undefined;
			entity.magic_bullet_shield = 0;
			level notify("interdimensional_kill", entity);
			if(isdefined(entity.interdimensional_gun_weapon) && isdefined(entity.interdimensional_gun_attacker))
			{
				entity kill(entity.origin, entity.interdimensional_gun_attacker, entity.interdimensional_gun_attacker, entity.interdimensional_gun_weapon);
			}
			else
			{
				entity kill(entity.origin);
			}
		}
		else if(entity.hole_pull_speed < 12)
		{
			entity.hole_pull_speed = entity.hole_pull_speed + 0.5;
			if(entity.hole_pull_speed > 12)
			{
				entity.hole_pull_speed = 12;
			}
		}
		flyingDir = VectorNormalize(flyingDir);
		entity ForceTeleport(entity.origin + flyingDir * entity.hole_pull_speed);
	}
}

/*
	Name: zombieIDGunHoleDeathMocompStart
	Namespace: ZombieBehavior
	Checksum: 0x5DDB645B
	Offset: 0x4AE8
	Size: 0x8B
	Parameters: 5
	Flags: None
*/
function zombieIDGunHoleDeathMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("noclip");
	entity.pushable = 0;
}

/*
	Name: zombieIDGunHoleDeathMocompTerminate
	Namespace: ZombieBehavior
	Checksum: 0xC34BAAEE
	Offset: 0x4B80
	Size: 0x6B
	Parameters: 5
	Flags: None
*/
function zombieIDGunHoleDeathMocompTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(!(isdefined(entity.interdimensional_gun_kill_vortex_explosion) && entity.interdimensional_gun_kill_vortex_explosion))
	{
		entity Hide();
	}
}

/*
	Name: zombieTurnMocompStart
	Namespace: ZombieBehavior
	Checksum: 0x853E9A67
	Offset: 0x4BF8
	Size: 0x7B
	Parameters: 5
	Flags: Private
*/
function private zombieTurnMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("angle deltas", 0);
}

/*
	Name: zombieTurnMocompUpdate
	Namespace: ZombieBehavior
	Checksum: 0xDC3F97F7
	Offset: 0x4C80
	Size: 0xAB
	Parameters: 5
	Flags: Private
*/
function private zombieTurnMocompUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	normalizedTime = entity GetAnimTime(mocompAnim) + mocompAnimBlendOutTime / mocompDuration;
	if(normalizedTime > 0.25)
	{
		entity OrientMode("face motion");
		entity animMode("normal", 0);
	}
}

/*
	Name: zombieTurnMocompTerminate
	Namespace: ZombieBehavior
	Checksum: 0x1F398383
	Offset: 0x4D38
	Size: 0x6B
	Parameters: 5
	Flags: Private
*/
function private zombieTurnMocompTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face motion");
	entity animMode("normal", 0);
}

/*
	Name: zombieHasLegs
	Namespace: ZombieBehavior
	Checksum: 0xC2BB20E3
	Offset: 0x4DB0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function zombieHasLegs(behaviorTreeEntity)
{
	if(behaviorTreeEntity.missingLegs === 1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombieShouldProceduralTraverse
	Namespace: ZombieBehavior
	Checksum: 0x6F91D8F6
	Offset: 0x4DE8
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function zombieShouldProceduralTraverse(entity)
{
	return isdefined(entity.traverseStartNode) && isdefined(entity.traverseEndNode) && entity.traverseStartNode.SPAWNFLAGS & 1024 && entity.traverseEndNode.SPAWNFLAGS & 1024;
}

/*
	Name: zombieShouldMeleeSuicide
	Namespace: ZombieBehavior
	Checksum: 0x35E021FF
	Offset: 0x4E60
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function zombieShouldMeleeSuicide(behaviorTreeEntity)
{
	if(!behaviorTreeEntity ai::get_behavior_attribute("suicidal_behavior"))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.magic_bullet_shield) && behaviorTreeEntity.magic_bullet_shield)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.marked_for_death))
	{
		return 0;
	}
	if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) > 40000)
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombieMeleeSuicideStart
	Namespace: ZombieBehavior
	Checksum: 0x7B333AA4
	Offset: 0x4F38
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function zombieMeleeSuicideStart(behaviorTreeEntity)
{
	behaviorTreeEntity.blockingPain = 1;
	if(isdefined(level.zombieMeleeSuicideCallback))
	{
		behaviorTreeEntity thread [[level.zombieMeleeSuicideCallback]](behaviorTreeEntity);
	}
}

/*
	Name: zombieMeleeSuicideUpdate
	Namespace: ZombieBehavior
	Checksum: 0x5F0D1E1
	Offset: 0x4F88
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function zombieMeleeSuicideUpdate(behaviorTreeEntity)
{
}

/*
	Name: zombieMeleeSuicideTerminate
	Namespace: ZombieBehavior
	Checksum: 0xBA45091
	Offset: 0x4FA0
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function zombieMeleeSuicideTerminate(behaviorTreeEntity)
{
	if(isalive(behaviorTreeEntity) && zombieShouldMeleeSuicide(behaviorTreeEntity))
	{
		behaviorTreeEntity.takedamage = 1;
		behaviorTreeEntity.allowdeath = 1;
		if(isdefined(level.zombieMeleeSuicideDoneCallback))
		{
			behaviorTreeEntity thread [[level.zombieMeleeSuicideDoneCallback]](behaviorTreeEntity);
		}
	}
}

/*
	Name: zombieMoveAction
	Namespace: ZombieBehavior
	Checksum: 0xAD33B3B7
	Offset: 0x5030
	Size: 0x14F
	Parameters: 2
	Flags: None
*/
function zombieMoveAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.moveTime = GetTime();
	behaviorTreeEntity.moveOrigin = behaviorTreeEntity.origin;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	if(isdefined(behaviorTreeEntity.stumble) && !isdefined(behaviorTreeEntity.move_anim_end_time))
	{
		stumbleActionResult = behaviorTreeEntity ASTSearch(istring(asmStateName));
		stumbleActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(behaviorTreeEntity, stumbleActionResult["animation"]);
		behaviorTreeEntity.move_anim_end_time = behaviorTreeEntity.moveTime + getanimlength(stumbleActionAnimation);
	}
	if(isdefined(behaviorTreeEntity.zombieMoveActionCallback))
	{
		behaviorTreeEntity [[behaviorTreeEntity.zombieMoveActionCallback]](behaviorTreeEntity);
	}
	return 5;
}

/*
	Name: zombieMoveActionUpdate
	Namespace: ZombieBehavior
	Checksum: 0x37B8D985
	Offset: 0x5188
	Size: 0x1F1
	Parameters: 2
	Flags: None
*/
function zombieMoveActionUpdate(behaviorTreeEntity, asmStateName)
{
	if(isdefined(behaviorTreeEntity.move_anim_end_time) && GetTime() >= behaviorTreeEntity.move_anim_end_time)
	{
		behaviorTreeEntity.move_anim_end_time = undefined;
		return 4;
	}
	if(!isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs && GetTime() - behaviorTreeEntity.moveTime > 1000)
	{
		distSq = Distance2DSquared(behaviorTreeEntity.origin, behaviorTreeEntity.moveOrigin);
		if(distSq < 144)
		{
			behaviorTreeEntity SetAvoidanceMask("avoid all");
			behaviorTreeEntity.cant_move = 1;
			if(isdefined(behaviorTreeEntity.cant_move_cb))
			{
				behaviorTreeEntity [[behaviorTreeEntity.cant_move_cb]]();
			}
		}
		else
		{
			behaviorTreeEntity SetAvoidanceMask("avoid none");
			behaviorTreeEntity.cant_move = 0;
		}
		behaviorTreeEntity.moveTime = GetTime();
		behaviorTreeEntity.moveOrigin = behaviorTreeEntity.origin;
	}
	if(behaviorTreeEntity ASMGetStatus() == "asm_status_complete")
	{
		if(behaviorTreeEntity IsCurrentBTActionLooping())
		{
			zombieMoveAction(behaviorTreeEntity, asmStateName);
		}
		else
		{
			return 4;
		}
	}
	return 5;
}

/*
	Name: zombieMoveActionTerminate
	Namespace: ZombieBehavior
	Checksum: 0xA0A7B5AD
	Offset: 0x5388
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function zombieMoveActionTerminate(behaviorTreeEntity, asmStateName)
{
	if(!(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs))
	{
		behaviorTreeEntity SetAvoidanceMask("avoid none");
	}
	return 4;
}

/*
	Name: ArchetypeZombieDeathOverrideInit
	Namespace: ZombieBehavior
	Checksum: 0x91AE16F3
	Offset: 0x53E8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function ArchetypeZombieDeathOverrideInit()
{
	AiUtility::AddAIOverrideKilledCallback(self, &ZombieGibKilledAnhilateOverride);
}

/*
	Name: ZombieGibKilledAnhilateOverride
	Namespace: ZombieBehavior
	Checksum: 0x5088DB3E
	Offset: 0x5418
	Size: 0x2F7
	Parameters: 8
	Flags: Private
*/
function private ZombieGibKilledAnhilateOverride(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime)
{
	if(!(isdefined(level.zombieAnhilationEnabled) && level.zombieAnhilationEnabled))
	{
		return damage;
	}
	if(isdefined(self.forceAnhilateOnDeath) && self.forceAnhilateOnDeath)
	{
		self zombie_utility::gib_random_parts();
		GibServerUtils::Annihilate(self);
		return damage;
	}
	if(isdefined(attacker) && isPlayer(attacker) && (isdefined(attacker.forceAnhilateOnDeath) && attacker.forceAnhilateOnDeath || (isdefined(level.forceAnhilateOnDeath) && level.forceAnhilateOnDeath)))
	{
		self zombie_utility::gib_random_parts();
		GibServerUtils::Annihilate(self);
		return damage;
	}
	attackerDistance = 0;
	if(isdefined(attacker))
	{
		attackerDistance = DistanceSquared(attacker.origin, self.origin);
	}
	isExplosive = IsInArray(Array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
	if(isdefined(weapon.weapClass) && weapon.weapClass == "turret")
	{
		if(isdefined(inflictor))
		{
			isDirectExplosive = IsInArray(Array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
			isCloseExplosive = DistanceSquared(inflictor.origin, self.origin) <= 60 * 60;
			if(isDirectExplosive && isCloseExplosive)
			{
				self zombie_utility::gib_random_parts();
				GibServerUtils::Annihilate(self);
			}
		}
	}
	return damage;
}

/*
	Name: zombieZombieIdleMocompStart
	Namespace: ZombieBehavior
	Checksum: 0x7F9AEEA8
	Offset: 0x5718
	Size: 0x11B
	Parameters: 5
	Flags: Private
*/
function private zombieZombieIdleMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]) && entity != entity.enemyoverride[1])
	{
		entity OrientMode("face direction", entity.enemyoverride[1].origin - entity.origin);
		entity animMode("zonly_physics", 0);
	}
	else
	{
		entity OrientMode("face current");
		entity animMode("zonly_physics", 0);
	}
}

/*
	Name: zombieAttackObjectMocompStart
	Namespace: ZombieBehavior
	Checksum: 0x6788C382
	Offset: 0x5840
	Size: 0xD3
	Parameters: 5
	Flags: Private
*/
function private zombieAttackObjectMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(isdefined(entity.attackable_slot))
	{
		entity OrientMode("face angle", entity.attackable_slot.angles[1]);
		entity animMode("zonly_physics", 0);
	}
	else
	{
		entity OrientMode("face current");
		entity animMode("zonly_physics", 0);
	}
}

/*
	Name: zombieAttackObjectMocompUpdate
	Namespace: ZombieBehavior
	Checksum: 0x383C4C0F
	Offset: 0x5920
	Size: 0x6B
	Parameters: 5
	Flags: Private
*/
function private zombieAttackObjectMocompUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(isdefined(entity.attackable_slot))
	{
		entity ForceTeleport(entity.attackable_slot.origin);
	}
}

