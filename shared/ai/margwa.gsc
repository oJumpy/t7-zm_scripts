#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
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

#namespace MargwaBehavior;

/*
	Name: init
	Namespace: MargwaBehavior
	Checksum: 0xA965E697
	Offset: 0xBA8
	Size: 0x373
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitMargwaBehaviorsAndASM();
	spawner::add_archetype_spawn_function("margwa", &ArchetypeMargwaBlackboardInit);
	spawner::add_archetype_spawn_function("margwa", &MargwaServerUtils::margwaSpawnSetup);
	clientfield::register("actor", "margwa_head_left", 1, 2, "int");
	clientfield::register("actor", "margwa_head_mid", 1, 2, "int");
	clientfield::register("actor", "margwa_head_right", 1, 2, "int");
	clientfield::register("actor", "margwa_fx_in", 1, 1, "counter");
	clientfield::register("actor", "margwa_fx_out", 1, 1, "counter");
	clientfield::register("actor", "margwa_fx_spawn", 1, 1, "counter");
	clientfield::register("actor", "margwa_smash", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_left_hit", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_mid_hit", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_right_hit", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_killed", 1, 2, "int");
	clientfield::register("actor", "margwa_jaw", 1, 6, "int");
	clientfield::register("toplayer", "margwa_head_explosion", 1, 1, "counter");
	clientfield::register("scriptmover", "margwa_fx_travel", 1, 1, "int");
	clientfield::register("scriptmover", "margwa_fx_travel_tell", 1, 1, "int");
	clientfield::register("actor", "supermargwa", 1, 1, "int");
	InitDirectHitWeapons();
}

/*
	Name: InitDirectHitWeapons
	Namespace: MargwaBehavior
	Checksum: 0xC4888C0D
	Offset: 0xF28
	Size: 0xDD
	Parameters: 0
	Flags: Private
*/
function private InitDirectHitWeapons()
{
	if(!isdefined(level.dhWeapons))
	{
		level.dhWeapons = [];
	}
	level.dhWeapons[level.dhWeapons.size] = "ray_gun";
	level.dhWeapons[level.dhWeapons.size] = "ray_gun_upgraded";
	level.dhWeapons[level.dhWeapons.size] = "pistol_standard_upgraded";
	level.dhWeapons[level.dhWeapons.size] = "pistol_revolver38_upgraded";
	level.dhWeapons[level.dhWeapons.size] = "pistol_revolver38lh_upgraded";
	level.dhWeapons[level.dhWeapons.size] = "launcher_standard";
	level.dhWeapons[level.dhWeapons.size] = "launcher_standard_upgraded";
}

/*
	Name: AddDirectHitWeapon
	Namespace: MargwaBehavior
	Checksum: 0x8767BE64
	Offset: 0x1010
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function AddDirectHitWeapon(weaponName)
{
	foreach(weapon in level.dhWeapons)
	{
		if(weapon == weaponName)
		{
			return;
		}
	}
	level.dhWeapons[level.dhWeapons.size] = weaponName;
}

/*
	Name: InitMargwaBehaviorsAndASM
	Namespace: MargwaBehavior
	Checksum: 0xA7B6071C
	Offset: 0x10C0
	Size: 0x653
	Parameters: 0
	Flags: Private
*/
function private InitMargwaBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTargetService", &margwaTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSmashAttack", &margwaShouldSmashAttack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSwipeAttack", &margwaShouldSwipeAttack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldShowPain", &margwaShouldShowPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReactStun", &margwaShouldReactStun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReactIDGun", &margwaShouldReactIDGun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReactSword", &margwaShouldReactSword);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSpawn", &margwaShouldSpawn);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldFreeze", &margwaShouldFreeze);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldTeleportIn", &margwaShouldTeleportIn);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldTeleportOut", &margwaShouldTeleportOut);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldWait", &margwaShouldWait);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReset", &margwaShouldReset);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("margwaReactStunAction", &margwaReactStunAction, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("margwaSwipeAttackAction", &margwaSwipeAttackAction, &margwaSwipeAttackActionUpdate, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaIdleStart", &margwaIdleStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaMoveStart", &margwaMoveStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTraverseActionStart", &margwaTraverseActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportInStart", &margwaTeleportInStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportInTerminate", &margwaTeleportInTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportOutStart", &margwaTeleportOutStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportOutTerminate", &margwaTeleportOutTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaPainStart", &margwaPainStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaPainTerminate", &margwaPainTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactStunStart", &margwaReactStunStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactStunTerminate", &margwaReactStunTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactIDGunStart", &margwaReactIDGunStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactIDGunTerminate", &margwaReactIDGunTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactSwordStart", &margwaReactSwordStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactSwordTerminate", &margwaReactSwordTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSpawnStart", &margwaSpawnStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSmashAttackStart", &margwaSmashAttackStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSmashAttackTerminate", &margwaSmashAttackTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSwipeAttackStart", &margwaSwipeAttackStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSwipeAttackTerminate", &margwaSwipeAttackTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@margwa", &mocompMargwaTeleportTraversalInit, &mocompMargwaTeleportTraversalUpdate, &mocompMargwaTeleportTraversalTerminate);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("margwa_smash_attack", &margwaNotetrackSmashAttack);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("margwa_bodyfall large", &margwaNotetrackBodyfall);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("margwa_melee_fire", &margwaNotetrackPainMelee);
}

/*
	Name: ArchetypeMargwaBlackboardInit
	Namespace: MargwaBehavior
	Checksum: 0xFA165BD7
	Offset: 0x1720
	Size: 0x1E3
	Parameters: 0
	Flags: Private
*/
function private ArchetypeMargwaBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", undefined);
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
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_should_turn", "should_not_turn", &BB_GetShouldTurn);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_zombie_damageweapon_type", "regular", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeMargwaOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeMargwaOnAnimscriptedCallback
	Namespace: MargwaBehavior
	Checksum: 0x8CF5C123
	Offset: 0x1910
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeMargwaOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeMargwaBlackboardInit();
}

/*
	Name: BB_GetShouldTurn
	Namespace: MargwaBehavior
	Checksum: 0x4CEB83C0
	Offset: 0x1950
	Size: 0x29
	Parameters: 0
	Flags: Private
*/
function private BB_GetShouldTurn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: margwaNotetrackSmashAttack
	Namespace: MargwaBehavior
	Checksum: 0xA780BA6F
	Offset: 0x1988
	Size: 0x32F
	Parameters: 1
	Flags: Private
*/
function private margwaNotetrackSmashAttack(entity)
{
	players = GetPlayers();
	foreach(player in players)
	{
		smashPos = entity.origin + VectorScale(AnglesToForward(self.angles), 60);
		distSq = DistanceSquared(smashPos, player.origin);
		if(distSq < 20736)
		{
			if(!IsGodMode(player))
			{
				if(isdefined(player.hasRiotShield) && player.hasRiotShield)
				{
					damageShield = 0;
					attackDir = player.origin - self.origin;
					if(isdefined(player.hasRiotShieldEquipped) && player.hasRiotShieldEquipped)
					{
						if(player MargwaServerUtils::shieldFacing(attackDir, 0.2))
						{
							damageShield = 1;
						}
					}
					else if(player MargwaServerUtils::shieldFacing(attackDir, 0.2, 0))
					{
						damageShield = 1;
					}
					if(damageShield)
					{
						self clientfield::increment("margwa_smash");
						shield_damage = level.weaponRiotshield.weaponstarthitpoints;
						if(isdefined(player.weaponRiotshield))
						{
							shield_damage = player.weaponRiotshield.weaponstarthitpoints;
						}
						player [[player.player_shield_apply_damage]](shield_damage, 0);
						continue;
					}
				}
				if(isdefined(level.margwa_smash_damage_callback) && IsFunctionPtr(level.margwa_smash_damage_callback))
				{
					if(player [[level.margwa_smash_damage_callback]](self))
					{
						continue;
					}
				}
				self clientfield::increment("margwa_smash");
				player DoDamage(166, self.origin, self);
			}
		}
	}
	if(isdefined(self.smashAttackCB))
	{
		self [[self.smashAttackCB]]();
	}
}

/*
	Name: margwaNotetrackBodyfall
	Namespace: MargwaBehavior
	Checksum: 0xCC2FF858
	Offset: 0x1CC0
	Size: 0x4F
	Parameters: 1
	Flags: Private
*/
function private margwaNotetrackBodyfall(entity)
{
	if(self.archetype == "margwa")
	{
		entity ghost();
		if(isdefined(self.bodyfallCB))
		{
			self [[self.bodyfallCB]]();
		}
	}
}

/*
	Name: margwaNotetrackPainMelee
	Namespace: MargwaBehavior
	Checksum: 0x3D30E629
	Offset: 0x1D18
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private margwaNotetrackPainMelee(entity)
{
	entity melee();
}

/*
	Name: margwaTargetService
	Namespace: MargwaBehavior
	Checksum: 0xD35CFD3F
	Offset: 0x1D48
	Size: 0x157
	Parameters: 1
	Flags: Private
*/
function private margwaTargetService(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
	if(!isdefined(player))
	{
		if(isdefined(self.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			self.ignore_player = [];
		}
		self SetGoal(self.origin);
		return 0;
	}
	else
	{
		targetPos = GetClosestPointOnNavMesh(player.origin, 64, 30);
		if(isdefined(targetPos))
		{
			entity SetGoal(targetPos);
			return 1;
		}
		else
		{
			entity SetGoal(entity.origin);
			return 0;
		}
	}
}

/*
	Name: margwaShouldSmashAttack
	Namespace: MargwaBehavior
	Checksum: 0x55FEA848
	Offset: 0x1EA8
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function margwaShouldSmashAttack(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(!entity MargwaServerUtils::inSmashAttackRange(entity.enemy))
	{
		return 0;
	}
	yaw = Abs(zombie_utility::getYawToEnemy());
	if(yaw > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: margwaShouldSwipeAttack
	Namespace: MargwaBehavior
	Checksum: 0xAA61328B
	Offset: 0x1F40
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function margwaShouldSwipeAttack(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.enemy.origin) > 16384)
	{
		return 0;
	}
	yaw = Abs(zombie_utility::getYawToEnemy());
	if(yaw > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: margwaShouldShowPain
	Namespace: MargwaBehavior
	Checksum: 0x55B8C89E
	Offset: 0x1FF0
	Size: 0xFD
	Parameters: 1
	Flags: Private
*/
function private margwaShouldShowPain(entity)
{
	if(isdefined(entity.headDestroyed))
	{
		headInfo = entity.head[entity.headDestroyed];
		switch(headInfo.cf)
		{
			case "margwa_head_left":
			{
				blackboard::SetBlackBoardAttribute(self, "_margwa_head", "left");
				break;
			}
			case "margwa_head_mid":
			{
				blackboard::SetBlackBoardAttribute(self, "_margwa_head", "middle");
				break;
			}
			case "margwa_head_right":
			{
				blackboard::SetBlackBoardAttribute(self, "_margwa_head", "right");
				break;
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldReactStun
	Namespace: MargwaBehavior
	Checksum: 0x6F008555
	Offset: 0x20F8
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldReactStun(entity)
{
	if(isdefined(entity.reactStun) && entity.reactStun)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldReactIDGun
	Namespace: MargwaBehavior
	Checksum: 0x99E54D21
	Offset: 0x2140
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldReactIDGun(entity)
{
	if(isdefined(entity.reactIDGun) && entity.reactIDGun)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldReactSword
	Namespace: MargwaBehavior
	Checksum: 0x5502ADC7
	Offset: 0x2188
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldReactSword(entity)
{
	if(isdefined(entity.reactSword) && entity.reactSword)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldSpawn
	Namespace: MargwaBehavior
	Checksum: 0x16151AD8
	Offset: 0x21D0
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldSpawn(entity)
{
	if(isdefined(entity.needSpawn) && entity.needSpawn)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldFreeze
	Namespace: MargwaBehavior
	Checksum: 0xC130F05
	Offset: 0x2218
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldFreeze(entity)
{
	if(isdefined(entity.isFrozen) && entity.isFrozen)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldTeleportIn
	Namespace: MargwaBehavior
	Checksum: 0x3BCAEDEB
	Offset: 0x2260
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldTeleportIn(entity)
{
	if(isdefined(entity.needTeleportIn) && entity.needTeleportIn)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldTeleportOut
	Namespace: MargwaBehavior
	Checksum: 0x244FF5FB
	Offset: 0x22A8
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldTeleportOut(entity)
{
	if(isdefined(entity.needTeleportOut) && entity.needTeleportOut)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldWait
	Namespace: MargwaBehavior
	Checksum: 0x87DA610
	Offset: 0x22F0
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private margwaShouldWait(entity)
{
	if(isdefined(entity.waiting) && entity.waiting)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaShouldReset
	Namespace: MargwaBehavior
	Checksum: 0xBE201424
	Offset: 0x2338
	Size: 0xA9
	Parameters: 1
	Flags: Private
*/
function private margwaShouldReset(entity)
{
	if(isdefined(entity.headDestroyed))
	{
		return 1;
	}
	if(isdefined(entity.reactIDGun) && entity.reactIDGun)
	{
		return 1;
	}
	if(isdefined(entity.reactSword) && entity.reactSword)
	{
		return 1;
	}
	if(isdefined(entity.reactStun) && entity.reactStun)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaReactStunAction
	Namespace: MargwaBehavior
	Checksum: 0xB4B5902E
	Offset: 0x23F0
	Size: 0xEF
	Parameters: 2
	Flags: Private
*/
function private margwaReactStunAction(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	stunActionAST = entity ASTSearch(istring(asmStateName));
	stunActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(entity, stunActionAST["animation"]);
	closeTime = getanimlength(stunActionAnimation) * 1000;
	entity MargwaServerUtils::margwaCloseAllHeads(closeTime);
	margwaReactStunStart(entity);
	return 5;
}

/*
	Name: margwaSwipeAttackAction
	Namespace: MargwaBehavior
	Checksum: 0xD06E7FC6
	Offset: 0x24E8
	Size: 0xE7
	Parameters: 2
	Flags: Private
*/
function private margwaSwipeAttackAction(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	if(!isdefined(entity.swipe_end_time))
	{
		swipeActionAST = entity ASTSearch(istring(asmStateName));
		swipeActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(entity, swipeActionAST["animation"]);
		swipeActionTime = getanimlength(swipeActionAnimation) * 1000;
		entity.swipe_end_time = GetTime() + swipeActionTime;
	}
	return 5;
}

/*
	Name: margwaSwipeAttackActionUpdate
	Namespace: MargwaBehavior
	Checksum: 0xC27867E9
	Offset: 0x25D8
	Size: 0x45
	Parameters: 2
	Flags: Private
*/
function private margwaSwipeAttackActionUpdate(entity, asmStateName)
{
	if(isdefined(entity.swipe_end_time) && GetTime() > entity.swipe_end_time)
	{
		return 4;
	}
	return 5;
}

/*
	Name: margwaIdleStart
	Namespace: MargwaBehavior
	Checksum: 0x40D5DCA6
	Offset: 0x2628
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private margwaIdleStart(entity)
{
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 1);
	}
}

/*
	Name: margwaMoveStart
	Namespace: MargwaBehavior
	Checksum: 0x5DEEBAD0
	Offset: 0x2678
	Size: 0x8B
	Parameters: 1
	Flags: Private
*/
function private margwaMoveStart(entity)
{
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		if(entity.zombie_move_speed == "run")
		{
			entity clientfield::set("margwa_jaw", 13);
		}
		else
		{
			entity clientfield::set("margwa_jaw", 7);
		}
	}
}

/*
	Name: margwaDeathAction
	Namespace: MargwaBehavior
	Checksum: 0x57CEAD69
	Offset: 0x2710
	Size: 0xB
	Parameters: 1
	Flags: Private
*/
function private margwaDeathAction(entity)
{
}

/*
	Name: margwaTraverseActionStart
	Namespace: MargwaBehavior
	Checksum: 0xDD88BF83
	Offset: 0x2728
	Size: 0x14D
	Parameters: 1
	Flags: Private
*/
function private margwaTraverseActionStart(entity)
{
	blackboard::SetBlackBoardAttribute(entity, "_traversal_type", entity.traverseStartNode.animscript);
	if(isdefined(entity.traverseStartNode.animscript))
	{
		if(entity MargwaServerUtils::shouldUpdateJaw())
		{
			switch(entity.traverseStartNode.animscript)
			{
				case "jump_down_36":
				{
					entity clientfield::set("margwa_jaw", 21);
					break;
				}
				case "jump_down_96":
				{
					entity clientfield::set("margwa_jaw", 22);
					break;
				}
				case "jump_up_36":
				{
					entity clientfield::set("margwa_jaw", 24);
					break;
				}
				case "jump_up_96":
				{
					entity clientfield::set("margwa_jaw", 25);
					break;
				}
			}
		}
	}
}

/*
	Name: margwaTeleportInStart
	Namespace: MargwaBehavior
	Checksum: 0x84B64EC8
	Offset: 0x2880
	Size: 0x153
	Parameters: 1
	Flags: Private
*/
function private margwaTeleportInStart(entity)
{
	entity Unlink();
	if(isdefined(entity.teleportPos))
	{
		entity ForceTeleport(entity.teleportPos);
	}
	entity show();
	entity PathMode("move allowed");
	entity.needTeleportIn = 0;
	blackboard::SetBlackBoardAttribute(self, "_margwa_teleport", "in");
	if(isdefined(self.traveler))
	{
		self.traveler clientfield::set("margwa_fx_travel", 0);
	}
	self clientfield::increment("margwa_fx_in", 1);
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 17);
	}
}

/*
	Name: margwaTeleportInTerminate
	Namespace: MargwaBehavior
	Checksum: 0xB1CFCFC2
	Offset: 0x29E0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function margwaTeleportInTerminate(entity)
{
	if(isdefined(self.traveler))
	{
		self.traveler clientfield::set("margwa_fx_travel", 0);
	}
	entity.isTeleporting = 0;
}

/*
	Name: margwaTeleportOutStart
	Namespace: MargwaBehavior
	Checksum: 0x646D917E
	Offset: 0x2A38
	Size: 0xCB
	Parameters: 1
	Flags: Private
*/
function private margwaTeleportOutStart(entity)
{
	entity.needTeleportOut = 0;
	entity.isTeleporting = 1;
	entity.teleportStart = entity.origin;
	blackboard::SetBlackBoardAttribute(self, "_margwa_teleport", "out");
	self clientfield::increment("margwa_fx_out", 1);
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 18);
	}
}

/*
	Name: margwaTeleportOutTerminate
	Namespace: MargwaBehavior
	Checksum: 0x70776916
	Offset: 0x2B10
	Size: 0x133
	Parameters: 1
	Flags: Private
*/
function private margwaTeleportOutTerminate(entity)
{
	if(isdefined(entity.traveler))
	{
		entity.traveler.origin = entity GetTagOrigin("j_spine_1");
		entity.traveler clientfield::set("margwa_fx_travel", 1);
	}
	entity ghost();
	entity PathMode("dont move");
	if(isdefined(entity.traveler))
	{
		entity LinkTo(entity.traveler);
	}
	if(isdefined(entity.margwaWait))
	{
		entity thread [[entity.margwaWait]]();
	}
	else
	{
		entity thread MargwaServerUtils::margwaWait();
	}
}

/*
	Name: margwaPainStart
	Namespace: MargwaBehavior
	Checksum: 0x1DD691BE
	Offset: 0x2C50
	Size: 0x12B
	Parameters: 1
	Flags: Private
*/
function private margwaPainStart(entity)
{
	entity notify("stop_head_update");
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		head = blackboard::GetBlackBoardAttribute(self, "_margwa_head");
		switch(head)
		{
			case "left":
			{
				entity clientfield::set("margwa_jaw", 3);
				break;
			}
			case "middle":
			{
				entity clientfield::set("margwa_jaw", 4);
				break;
			}
			case "right":
			{
				entity clientfield::set("margwa_jaw", 5);
				break;
			}
		}
	}
	entity.headDestroyed = undefined;
	entity.canStun = 0;
	entity.canDamage = 0;
}

/*
	Name: margwaPainTerminate
	Namespace: MargwaBehavior
	Checksum: 0x13FC1942
	Offset: 0x2D88
	Size: 0x9F
	Parameters: 1
	Flags: Private
*/
function private margwaPainTerminate(entity)
{
	entity.headDestroyed = undefined;
	entity.canStun = 1;
	entity.canDamage = 1;
	entity MargwaServerUtils::margwaCloseAllHeads(5000);
	entity clearPath();
	if(isdefined(entity.margwaPainTerminateCB))
	{
		entity [[entity.margwaPainTerminateCB]]();
	}
}

/*
	Name: margwaReactStunStart
	Namespace: MargwaBehavior
	Checksum: 0xE29ED658
	Offset: 0x2E30
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private margwaReactStunStart(entity)
{
	entity.reactStun = undefined;
	entity.canStun = 0;
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 6);
	}
}

/*
	Name: margwaReactStunTerminate
	Namespace: MargwaBehavior
	Checksum: 0x567ED9E2
	Offset: 0x2EA0
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function margwaReactStunTerminate(entity)
{
	entity.canStun = 1;
}

/*
	Name: margwaReactIDGunStart
	Namespace: MargwaBehavior
	Checksum: 0x6EA2D157
	Offset: 0x2EC8
	Size: 0x13B
	Parameters: 1
	Flags: Private
*/
function private margwaReactIDGunStart(entity)
{
	entity.reactIDGun = undefined;
	entity.canStun = 0;
	isPacked = 0;
	if(blackboard::GetBlackBoardAttribute(entity, "_zombie_damageweapon_type") == "regular")
	{
		if(entity MargwaServerUtils::shouldUpdateJaw())
		{
			entity clientfield::set("margwa_jaw", 8);
		}
		entity MargwaServerUtils::margwaCloseAllHeads(5000);
	}
	else if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 9);
	}
	entity MargwaServerUtils::margwaCloseAllHeads(10000);
	isPacked = 1;
	if(isdefined(entity.idgun_damage))
	{
		entity [[entity.idgun_damage]](isPacked);
	}
}

/*
	Name: margwaReactIDGunTerminate
	Namespace: MargwaBehavior
	Checksum: 0x417F8CEF
	Offset: 0x3010
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function margwaReactIDGunTerminate(entity)
{
	entity.canStun = 1;
	blackboard::SetBlackBoardAttribute(entity, "_zombie_damageweapon_type", "regular");
}

/*
	Name: margwaReactSwordStart
	Namespace: MargwaBehavior
	Checksum: 0xB22073AE
	Offset: 0x3060
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private margwaReactSwordStart(entity)
{
	entity.reactSword = undefined;
	entity.canStun = 0;
	if(isdefined(entity.head_chopper))
	{
		entity.head_chopper notify("react_sword");
	}
}

/*
	Name: margwaReactSwordTerminate
	Namespace: MargwaBehavior
	Checksum: 0xFF73C378
	Offset: 0x30C0
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private margwaReactSwordTerminate(entity)
{
	entity.canStun = 1;
}

/*
	Name: margwaSpawnStart
	Namespace: MargwaBehavior
	Checksum: 0x38AD1A57
	Offset: 0x30E8
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private margwaSpawnStart(entity)
{
	entity.needSpawn = 0;
}

/*
	Name: margwaSmashAttackStart
	Namespace: MargwaBehavior
	Checksum: 0xF8F02AF9
	Offset: 0x3110
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private margwaSmashAttackStart(entity)
{
	entity MargwaServerUtils::margwaHeadSmash();
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 14);
	}
}

/*
	Name: margwaSmashAttackTerminate
	Namespace: MargwaBehavior
	Checksum: 0xD562EA55
	Offset: 0x3178
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function margwaSmashAttackTerminate(entity)
{
	entity MargwaServerUtils::margwaCloseAllHeads();
}

/*
	Name: margwaSwipeAttackStart
	Namespace: MargwaBehavior
	Checksum: 0x37DE952B
	Offset: 0x31A8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function margwaSwipeAttackStart(entity)
{
	if(entity MargwaServerUtils::shouldUpdateJaw())
	{
		entity clientfield::set("margwa_jaw", 16);
	}
}

/*
	Name: margwaSwipeAttackTerminate
	Namespace: MargwaBehavior
	Checksum: 0xFA0A0930
	Offset: 0x31F8
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private margwaSwipeAttackTerminate(entity)
{
	entity MargwaServerUtils::margwaCloseAllHeads();
}

/*
	Name: mocompMargwaTeleportTraversalInit
	Namespace: MargwaBehavior
	Checksum: 0x1C7A55F3
	Offset: 0x3228
	Size: 0x143
	Parameters: 5
	Flags: Private
*/
function private mocompMargwaTeleportTraversalInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("normal");
	if(isdefined(entity.traverseEndNode))
	{
		entity.teleportStart = entity.origin;
		entity.teleportPos = entity.traverseEndNode.origin;
		self clientfield::increment("margwa_fx_out", 1);
		if(isdefined(entity.traverseStartNode))
		{
			if(isdefined(entity.traverseStartNode.speed))
			{
				self.margwa_teleport_speed = entity.traverseStartNode.speed;
			}
		}
	}
}

/*
	Name: mocompMargwaTeleportTraversalUpdate
	Namespace: MargwaBehavior
	Checksum: 0x44041490
	Offset: 0x3378
	Size: 0x2B
	Parameters: 5
	Flags: Private
*/
function private mocompMargwaTeleportTraversalUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
}

/*
	Name: mocompMargwaTeleportTraversalTerminate
	Namespace: MargwaBehavior
	Checksum: 0x897D052C
	Offset: 0x33B0
	Size: 0x43
	Parameters: 5
	Flags: Private
*/
function private mocompMargwaTeleportTraversalTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	margwaTeleportOutTerminate(entity);
}

#namespace MargwaServerUtils;

/*
	Name: margwaSpawnSetup
	Namespace: MargwaServerUtils
	Checksum: 0x99D9DEB3
	Offset: 0x3400
	Size: 0x223
	Parameters: 0
	Flags: Private
*/
function private margwaSpawnSetup()
{
	self DisableAimAssist();
	self.disableAmmoDrop = 1;
	self.no_gib = 1;
	self.ignore_nuke = 1;
	self.ignore_enemy_count = 1;
	self.ignore_round_robbin_death = 1;
	self.zombie_move_speed = "walk";
	self.overrideActorDamage = &margwaDamage;
	self.canDamage = 1;
	self.headAttached = 3;
	self.headOpen = 0;
	self margwaInitHead("c_zom_margwa_chunks_le", "j_chunk_head_bone_le");
	self margwaInitHead("c_zom_margwa_chunks_mid", "j_chunk_head_bone");
	self margwaInitHead("c_zom_margwa_chunks_ri", "j_chunk_head_bone_ri");
	self.headHealthMax = 600;
	self margwaDisableStun();
	self.traveler = spawn("script_model", self.origin);
	self.traveler SetModel("tag_origin");
	self.traveler notsolid();
	self.travelerTell = spawn("script_model", self.origin);
	self.travelerTell SetModel("tag_origin");
	self.travelerTell notsolid();
	self thread margwaDeath();
	self.updateSight = 0;
	self.ignorerunAndgundist = 1;
}

/*
	Name: margwaDeath
	Namespace: MargwaServerUtils
	Checksum: 0x10D7870E
	Offset: 0x3630
	Size: 0x7B
	Parameters: 0
	Flags: Private
*/
function private margwaDeath()
{
	self waittill("death");
	if(isdefined(self.e_head_attacker))
	{
		self.e_head_attacker notify("margwa_kill");
	}
	if(isdefined(self.traveler))
	{
		self.traveler delete();
	}
	if(isdefined(self.travelerTell))
	{
		self.travelerTell delete();
	}
}

/*
	Name: margwaEnableStun
	Namespace: MargwaServerUtils
	Checksum: 0x7BFCD1CF
	Offset: 0x36B8
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function margwaEnableStun()
{
	self.canStun = 1;
}

/*
	Name: margwaDisableStun
	Namespace: MargwaServerUtils
	Checksum: 0xE1852A59
	Offset: 0x36D0
	Size: 0xF
	Parameters: 0
	Flags: Private
*/
function private margwaDisableStun()
{
	self.canStun = 0;
}

/*
	Name: margwaInitHead
	Namespace: MargwaServerUtils
	Checksum: 0x4F6311E4
	Offset: 0x36E8
	Size: 0x453
	Parameters: 2
	Flags: Private
*/
function private margwaInitHead(Headmodel, headTag)
{
	model = Headmodel;
	model_gore = undefined;
	switch(Headmodel)
	{
		case "c_zom_margwa_chunks_le":
		{
			if(isdefined(level.margwa_head_left_model_override))
			{
				model = level.margwa_head_left_model_override;
				model_gore = level.margwa_gore_left_model_override;
			}
			break;
		}
		case "c_zom_margwa_chunks_mid":
		{
			if(isdefined(level.margwa_head_mid_model_override))
			{
				model = level.margwa_head_mid_model_override;
				model_gore = level.margwa_gore_mid_model_override;
			}
			break;
		}
		case "c_zom_margwa_chunks_ri":
		{
			if(isdefined(level.margwa_head_right_model_override))
			{
				model = level.margwa_head_right_model_override;
				model_gore = level.margwa_gore_right_model_override;
			}
			break;
		}
	}
	self Attach(model);
	if(!isdefined(self.head))
	{
		self.head = [];
	}
	self.head[model] = spawnstruct();
	self.head[model].model = model;
	self.head[model].tag = headTag;
	self.head[model].health = 600;
	self.head[model].canDamage = 0;
	self.head[model].open = 1;
	self.head[model].closed = 2;
	self.head[model].smash = 3;
	switch(Headmodel)
	{
		case "c_zom_margwa_chunks_le":
		{
			self.head[model].cf = "margwa_head_left";
			self.head[model].impactCF = "margwa_head_left_hit";
			self.head[model].gore = "c_zom_margwa_gore_le";
			if(isdefined(model_gore))
			{
				self.head[model].gore = model_gore;
			}
			self.head[model].killIndex = 1;
			self.head_left_model = model;
			break;
		}
		case "c_zom_margwa_chunks_mid":
		{
			self.head[model].cf = "margwa_head_mid";
			self.head[model].impactCF = "margwa_head_mid_hit";
			self.head[model].gore = "c_zom_margwa_gore_mid";
			if(isdefined(model_gore))
			{
				self.head[model].gore = model_gore;
			}
			self.head[model].killIndex = 2;
			self.head_mid_model = model;
			break;
		}
		case "c_zom_margwa_chunks_ri":
		{
			self.head[model].cf = "margwa_head_right";
			self.head[model].impactCF = "margwa_head_right_hit";
			self.head[model].gore = "c_zom_margwa_gore_ri";
			if(isdefined(model_gore))
			{
				self.head[model].gore = model_gore;
			}
			self.head[model].killIndex = 3;
			self.head_right_model = model;
			break;
		}
	}
	self thread margwaHeadUpdate(self.head[model]);
}

/*
	Name: margwaSetHeadHealth
	Namespace: MargwaServerUtils
	Checksum: 0x91582E3A
	Offset: 0x3B48
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function margwaSetHeadHealth(health)
{
	self.headHealthMax = health;
	foreach(head in self.head)
	{
		head.health = health;
	}
}

/*
	Name: margwaResetHeadTime
	Namespace: MargwaServerUtils
	Checksum: 0xEE2C76D4
	Offset: 0x3BF0
	Size: 0x45
	Parameters: 2
	Flags: Private
*/
function private margwaResetHeadTime(min, max)
{
	time = GetTime() + randomIntRange(min, max);
	return time;
}

/*
	Name: margwaHeadCanOpen
	Namespace: MargwaServerUtils
	Checksum: 0xA2C54F6B
	Offset: 0x3C40
	Size: 0x3F
	Parameters: 0
	Flags: Private
*/
function private margwaHeadCanOpen()
{
	if(self.headAttached > 1)
	{
		if(self.headOpen < self.headAttached - 1)
		{
			return 1;
		}
	}
	else
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaHeadUpdate
	Namespace: MargwaServerUtils
	Checksum: 0x81D78407
	Offset: 0x3C88
	Size: 0x297
	Parameters: 1
	Flags: Private
*/
function private margwaHeadUpdate(headInfo)
{
	self endon("death");
	self endon("stop_head_update");
	headInfo notify("stop_head_update");
	headInfo endon("stop_head_update");
	while(1)
	{
		if(self IsPaused())
		{
			util::wait_network_frame();
			continue;
		}
		if(!isdefined(headInfo.closeTime))
		{
			if(self.headAttached == 1)
			{
				headInfo.closeTime = margwaResetHeadTime(500, 1000);
			}
			else
			{
				headInfo.closeTime = margwaResetHeadTime(1500, 3500);
			}
		}
		if(GetTime() > headInfo.closeTime && self margwaHeadCanOpen())
		{
			self.headOpen++;
			headInfo.closeTime = undefined;
		}
		else
		{
			util::wait_network_frame();
			continue;
		}
		self margwaHeadDamageDelay(headInfo, 1);
		self clientfield::set(headInfo.cf, headInfo.open);
		self PlaySoundOnTag("zmb_vocals_margwa_ambient", headInfo.tag);
		while(1)
		{
			if(!isdefined(headInfo.openTime))
			{
				headInfo.openTime = margwaResetHeadTime(3000, 5000);
			}
			if(GetTime() > headInfo.openTime)
			{
				self.headOpen--;
				headInfo.openTime = undefined;
				break;
			}
			else
			{
				util::wait_network_frame();
				continue;
			}
		}
		self margwaHeadDamageDelay(headInfo, 0);
		self clientfield::set(headInfo.cf, headInfo.closed);
	}
}

/*
	Name: margwaHeadDamageDelay
	Namespace: MargwaServerUtils
	Checksum: 0xCB063EC9
	Offset: 0x3F28
	Size: 0x3B
	Parameters: 2
	Flags: Private
*/
function private margwaHeadDamageDelay(headInfo, canDamage)
{
	self endon("death");
	wait(0.1);
	headInfo.canDamage = canDamage;
}

/*
	Name: margwaHeadSmash
	Namespace: MargwaServerUtils
	Checksum: 0x94918C5C
	Offset: 0x3F70
	Size: 0x1C1
	Parameters: 0
	Flags: Private
*/
function private margwaHeadSmash()
{
	self notify("stop_head_update");
	headAlive = [];
	foreach(head in self.head)
	{
		if(head.health > 0)
		{
			headAlive[headAlive.size] = head;
		}
	}
	headAlive = Array::randomize(headAlive);
	open = 0;
	foreach(head in headAlive)
	{
		if(!open)
		{
			head.canDamage = 1;
			self clientfield::set(head.cf, head.smash);
			open = 1;
			continue;
		}
		self margwaCloseHead(head);
	}
}

/*
	Name: margwaCloseHead
	Namespace: MargwaServerUtils
	Checksum: 0xEBA348FD
	Offset: 0x4140
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private margwaCloseHead(headInfo)
{
	headInfo.canDamage = 0;
	self clientfield::set(headInfo.cf, headInfo.closed);
}

/*
	Name: margwaCloseAllHeads
	Namespace: MargwaServerUtils
	Checksum: 0x51F32313
	Offset: 0x4198
	Size: 0x121
	Parameters: 1
	Flags: Private
*/
function private margwaCloseAllHeads(closeTime)
{
	if(self IsPaused())
	{
		return;
	}
	foreach(head in self.head)
	{
		if(head.health > 0)
		{
			head.closeTime = undefined;
			head.openTime = undefined;
			if(isdefined(closeTime))
			{
				head.closeTime = GetTime() + closeTime;
			}
			self.headOpen = 0;
			self margwaCloseHead(head);
			self thread margwaHeadUpdate(head);
		}
	}
}

/*
	Name: margwaKillHead
	Namespace: MargwaServerUtils
	Checksum: 0xB02E33BE
	Offset: 0x42C8
	Size: 0x179
	Parameters: 2
	Flags: None
*/
function margwaKillHead(modelHit, attacker)
{
	headInfo = self.head[modelHit];
	headInfo.health = 0;
	headInfo notify("stop_head_update");
	if(isdefined(headInfo.canDamage) && headInfo.canDamage)
	{
		self margwaCloseHead(headInfo);
		self.headOpen--;
	}
	self margwaUpdateMoveSpeed();
	if(isdefined(self.destroyHeadCB))
	{
		self thread [[self.destroyHeadCB]](modelHit, attacker);
	}
	self clientfield::set("margwa_head_killed", headInfo.killIndex);
	self Detach(headInfo.model);
	self Attach(headInfo.gore);
	self.headAttached--;
	if(self.headAttached <= 0)
	{
		self.e_head_attacker = attacker;
		return 1;
	}
	else
	{
		self.headDestroyed = modelHit;
	}
	return 0;
}

/*
	Name: margwaCanDamageAnyHead
	Namespace: MargwaServerUtils
	Checksum: 0x43563241
	Offset: 0x4450
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function margwaCanDamageAnyHead()
{
	foreach(head in self.head)
	{
		if(isdefined(head) && head.health > 0 && (isdefined(head.canDamage) && head.canDamage))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: margwaCanDamageHead
	Namespace: MargwaServerUtils
	Checksum: 0x2167A7ED
	Offset: 0x4518
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function margwaCanDamageHead()
{
	if(isdefined(self) && self.health > 0 && (isdefined(self.canDamage) && self.canDamage))
	{
		return 1;
	}
	return 0;
}

/*
	Name: show_hit_marker
	Namespace: MargwaServerUtils
	Checksum: 0x7D7D2633
	Offset: 0x4560
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: isDirectHitWeapon
	Namespace: MargwaServerUtils
	Checksum: 0x9E36F596
	Offset: 0x45F0
	Size: 0xED
	Parameters: 1
	Flags: Private
*/
function private isDirectHitWeapon(weapon)
{
	foreach(dhWeapon in level.dhWeapons)
	{
		if(weapon.name == dhWeapon)
		{
			return 1;
		}
		if(isdefined(weapon.rootweapon) && isdefined(weapon.rootweapon.name) && weapon.rootweapon.name == dhWeapon)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: margwaDamage
	Namespace: MargwaServerUtils
	Checksum: 0xD0E1889D
	Offset: 0x46E8
	Size: 0x67B
	Parameters: 12
	Flags: None
*/
function margwaDamage(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(isdefined(self.is_kill) && self.is_kill)
	{
		return damage;
	}
	if(isdefined(attacker) && isdefined(attacker.n_margwa_head_damage_scale))
	{
		damage = damage * attacker.n_margwa_head_damage_scale;
	}
	if(isdefined(level._margwa_damage_cb))
	{
		n_result = [[level._margwa_damage_cb]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		if(isdefined(n_result))
		{
			return n_result;
		}
	}
	damageOpen = 0;
	if(!(isdefined(self.canDamage) && self.canDamage))
	{
		self.health = self.health + 1;
		return 1;
	}
	if(isDirectHitWeapon(weapon))
	{
		headAlive = [];
		foreach(head in self.head)
		{
			if(head margwaCanDamageHead())
			{
				headAlive[headAlive.size] = head;
			}
		}
		if(headAlive.size > 0)
		{
			max = 100000;
			headClosest = undefined;
			foreach(head in headAlive)
			{
				distSq = DistanceSquared(point, self GetTagOrigin(head.tag));
				if(distSq < max)
				{
					max = distSq;
					headClosest = head;
				}
			}
			if(isdefined(headClosest))
			{
				if(max < 576)
				{
					if(isdefined(level.margwa_damage_override_callback) && IsFunctionPtr(level.margwa_damage_override_callback))
					{
						damage = attacker [[level.margwa_damage_override_callback]](damage);
					}
					headClosest.health = headClosest.health - damage;
					damageOpen = 1;
					self clientfield::increment(headClosest.impactCF);
					attacker show_hit_marker();
					if(headClosest.health <= 0)
					{
						if(isdefined(level.margwa_head_kill_weapon_check))
						{
							[[level.margwa_head_kill_weapon_check]](self, weapon);
						}
						if(self margwaKillHead(headClosest.model, attacker))
						{
							return self.health;
						}
					}
				}
			}
		}
	}
	partName = GetPartName(self.model, boneIndex);
	if(isdefined(partName))
	{
		/#
			if(isdefined(self.debugHitLoc) && self.debugHitLoc)
			{
				PrintTopRightln(partName + "Dev Block strings are not supported" + damage);
			}
		#/
		modelHit = self margwaHeadHit(self, partName);
		if(isdefined(modelHit))
		{
			headInfo = self.head[modelHit];
			if(headInfo margwaCanDamageHead())
			{
				if(isdefined(level.margwa_damage_override_callback) && IsFunctionPtr(level.margwa_damage_override_callback))
				{
					damage = attacker [[level.margwa_damage_override_callback]](damage);
				}
				if(isdefined(attacker))
				{
					attacker notify("margwa_headshot", self);
				}
				headInfo.health = headInfo.health - damage;
				damageOpen = 1;
				self clientfield::increment(headInfo.impactCF);
				attacker show_hit_marker();
				if(headInfo.health <= 0)
				{
					if(isdefined(level.margwa_head_kill_weapon_check))
					{
						[[level.margwa_head_kill_weapon_check]](self, weapon);
					}
					if(self margwaKillHead(modelHit, attacker))
					{
						return self.health;
					}
				}
			}
		}
	}
	if(damageOpen)
	{
		return 0;
	}
	self.health = self.health + 1;
	return 1;
}

/*
	Name: margwaHeadHit
	Namespace: MargwaServerUtils
	Checksum: 0x5A7E92A6
	Offset: 0x4D70
	Size: 0x6F
	Parameters: 2
	Flags: Private
*/
function private margwaHeadHit(entity, partName)
{
	switch(partName)
	{
		case "j_chunk_head_bone_le":
		case "j_jaw_lower_1_le":
		{
			return self.head_left_model;
		}
		case "j_chunk_head_bone":
		case "j_jaw_lower_1":
		{
			return self.head_mid_model;
		}
		case "j_chunk_head_bone_ri":
		case "j_jaw_lower_1_ri":
		{
			return self.head_right_model;
		}
	}
	return undefined;
}

/*
	Name: margwaUpdateMoveSpeed
	Namespace: MargwaServerUtils
	Checksum: 0x5C02A521
	Offset: 0x4DE8
	Size: 0x9B
	Parameters: 0
	Flags: Private
*/
function private margwaUpdateMoveSpeed()
{
	if(self.zombie_move_speed == "walk")
	{
		self.zombie_move_speed = "run";
		blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run");
	}
	else if(self.zombie_move_speed == "run")
	{
		self.zombie_move_speed = "sprint";
		blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

/*
	Name: margwaForceSprint
	Namespace: MargwaServerUtils
	Checksum: 0x98CBB6AB
	Offset: 0x4E90
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function margwaForceSprint()
{
	self.zombie_move_speed = "sprint";
	blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_sprint");
}

/*
	Name: margwaDestroyHead
	Namespace: MargwaServerUtils
	Checksum: 0xA69A2999
	Offset: 0x4ED8
	Size: 0xB
	Parameters: 1
	Flags: Private
*/
function private margwaDestroyHead(modelHit)
{
}

/*
	Name: shouldUpdateJaw
	Namespace: MargwaServerUtils
	Checksum: 0x2EAC2FC5
	Offset: 0x4EF0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function shouldUpdateJaw()
{
	if(!(isdefined(self.jawAnimEnabled) && self.jawAnimEnabled))
	{
		return 0;
	}
	if(self.headAttached < 3)
	{
		return 1;
	}
	return 0;
}

/*
	Name: margwaSetGoal
	Namespace: MargwaServerUtils
	Checksum: 0x47B9066C
	Offset: 0x4F30
	Size: 0x8D
	Parameters: 3
	Flags: None
*/
function margwaSetGoal(origin, radius, boundaryDist)
{
	pos = GetClosestPointOnNavMesh(origin, 64, 30);
	if(isdefined(pos))
	{
		self SetGoal(pos);
		return 1;
	}
	self SetGoal(self.origin);
	return 0;
}

/*
	Name: margwaWait
	Namespace: MargwaServerUtils
	Checksum: 0x35D62B4D
	Offset: 0x4FC8
	Size: 0x189
	Parameters: 0
	Flags: Private
*/
function private margwaWait()
{
	self endon("death");
	self.waiting = 1;
	self.needTeleportIn = 1;
	destPos = self.teleportPos + VectorScale((0, 0, 1), 60);
	dist = Distance(self.teleportStart, destPos);
	time = dist / 600;
	if(isdefined(self.margwa_teleport_speed))
	{
		if(self.margwa_teleport_speed > 0)
		{
			time = dist / self.margwa_teleport_speed;
		}
	}
	if(isdefined(self.traveler))
	{
		self thread margwaTell();
		self.traveler moveto(destPos, time);
		self.traveler util::waittill_any_ex(time + 0.1, "movedone", self, "death");
		self.travelerTell clientfield::set("margwa_fx_travel_tell", 0);
	}
	self.waiting = 0;
	self.needTeleportOut = 0;
	if(isdefined(self.margwa_teleport_speed))
	{
		self.margwa_teleport_speed = undefined;
	}
}

/*
	Name: margwaTell
	Namespace: MargwaServerUtils
	Checksum: 0x7FEB04F2
	Offset: 0x5160
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function margwaTell()
{
	self endon("death");
	self.travelerTell.origin = self.teleportPos;
	util::wait_network_frame();
	self.travelerTell clientfield::set("margwa_fx_travel_tell", 1);
}

/*
	Name: shieldFacing
	Namespace: MargwaServerUtils
	Checksum: 0x241B8C09
	Offset: 0x51D0
	Size: 0x161
	Parameters: 3
	Flags: Private
*/
function private shieldFacing(vDir, limit, front)
{
	if(!isdefined(front))
	{
		front = 1;
	}
	orientation = self getPlayerAngles();
	forwardVec = AnglesToForward(orientation);
	if(!front)
	{
		forwardVec = forwardVec * -1;
	}
	forwardVec2D = (forwardVec[0], forwardVec[1], 0);
	unitForwardVec2D = VectorNormalize(forwardVec2D);
	toFaceeVec = vDir * -1;
	toFaceeVec2D = (toFaceeVec[0], toFaceeVec[1], 0);
	unitToFaceeVec2D = VectorNormalize(toFaceeVec2D);
	dotProduct = VectorDot(unitForwardVec2D, unitToFaceeVec2D);
	return dotProduct > limit;
}

/*
	Name: inSmashAttackRange
	Namespace: MargwaServerUtils
	Checksum: 0x63151C0A
	Offset: 0x5340
	Size: 0xC7
	Parameters: 1
	Flags: Private
*/
function private inSmashAttackRange(enemy)
{
	smashPos = self.origin;
	heightOffset = Abs(self.origin[2] - enemy.origin[2]);
	if(heightOffset > 48)
	{
		return 0;
	}
	distSq = DistanceSquared(smashPos, enemy.origin);
	range = 25600;
	if(distSq < range)
	{
		return 1;
	}
	return 0;
}

