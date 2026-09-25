#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_warlord_interface;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace warlord;

/*
	Name: __init__sytem__
	Namespace: warlord
	Checksum: 0x297F0D08
	Offset: 0x728
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("warlord", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: warlord
	Checksum: 0x4CC9924B
	Offset: 0x768
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	spawner::add_archetype_spawn_function("warlord", &WarlordBehavior::ArchetypeWarlordBlackboardInit);
	spawner::add_archetype_spawn_function("warlord", &WarlordServerUtils::warlordSpawnSetup);
	if(ai::shouldRegisterClientFieldForArchetype("warlord"))
	{
		clientfield::register("actor", "warlord_damage_state", 1, 2, "int");
		clientfield::register("actor", "warlord_thruster_direction", 1, 3, "int");
		clientfield::register("actor", "warlord_type", 1, 2, "int");
		clientfield::register("actor", "warlord_lights_state", 1, 1, "int");
	}
	WarlordInterface::RegisterWarlordInterfaceAttributes();
}

#namespace WarlordBehavior;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: WarlordBehavior
	Checksum: 0x8B1E11DC
	Offset: 0x8B0
	Size: 0x1AB
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanJukeCondition", &canJukeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanTacticalJukeCondition", &canTacticalJukeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordShouldBeAngryCondition", &shouldBeAngryCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordShouldNormalMelee", &warlordShouldNormalMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanTakePainCondition", &canTakePainCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordExposedPainActionStart", &exposedPainActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordDeathAction", &deathAction, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordJukeAction", &jukeAction, undefined, &jukeActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBetterPositionService", &chooseBetterPositionService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("WarlordAngryAttack", &WarlordAngryAttack);
}

/*
	Name: ArchetypeWarlordBlackboardInit
	Namespace: WarlordBehavior
	Checksum: 0x66861B70
	Offset: 0xA68
	Size: 0x7B
	Parameters: 0
	Flags: Private
*/
function private ArchetypeWarlordBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	ai::CreateInterfaceForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeWarlordOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeWarlordOnAnimscriptedCallback
	Namespace: WarlordBehavior
	Checksum: 0x725E3DA9
	Offset: 0xAF0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeWarlordOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeWarlordBlackboardInit();
}

/*
	Name: shouldHuntEnemyPlayer
	Namespace: WarlordBehavior
	Checksum: 0x6819054A
	Offset: 0xB30
	Size: 0x4F
	Parameters: 1
	Flags: Private
*/
function private shouldHuntEnemyPlayer(entity)
{
	if(isdefined(entity.enemy) && isdefined(entity.var_ce767dbd) && GetTime() < entity.var_ce767dbd)
	{
		return 1;
	}
	return 0;
}

/*
	Name: _warlordHuntEnemy
	Namespace: WarlordBehavior
	Checksum: 0x310DC509
	Offset: 0xB88
	Size: 0x3AB
	Parameters: 1
	Flags: Private
*/
function private _warlordHuntEnemy(entity)
{
	/#
		namespace_e585b400::function_3f561bff(entity, 3, 1);
	#/
	if(Distance2DSquared(entity.origin, self lastKnownPos(self.enemy)) <= 250 * 250)
	{
		return 0;
	}
	if(isdefined(entity.var_c9cd0861) && GetTime() < entity.var_c9cd0861)
	{
		return 0;
	}
	if(entity.var_b654f978)
	{
		/#
			namespace_e585b400::function_3d68d6d1(3, (1, 0, 1), "Dev Block strings are not supported");
		#/
		return 0;
	}
	positionOnNavMesh = GetClosestPointOnNavMesh(self lastKnownPos(self.enemy), 200);
	if(!isdefined(positionOnNavMesh))
	{
		positionOnNavMesh = self lastKnownPos(self.enemy);
	}
	queryResult = PositionQuery_Source_Navigation(positionOnNavMesh, 150, 250, 45, 36, entity, 36);
	PositionQuery_Filter_InClaimedLocation(queryResult, entity);
	PositionQuery_Filter_DistanceToGoal(queryResult, entity);
	if(queryResult.data.size > 0)
	{
		closestPoint = undefined;
		closestDistance = undefined;
		foreach(point in queryResult.data)
		{
			if(!point.inclaimedlocation && point.distToGoal == 0)
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
			/#
				namespace_e585b400::function_4160d34d(entity, 3, 1);
			#/
			entity UsePosition(closestPoint);
			entity.var_c9cd0861 = GetTime() + randomIntRange(500, 1500);
			return 1;
		}
	}
	/#
		namespace_e585b400::function_c2db5ca5(entity, 3);
	#/
	entity.var_ce767dbd = undefined;
	return 0;
}

/*
	Name: chooseBetterPositionService
	Namespace: WarlordBehavior
	Checksum: 0xB162A48F
	Offset: 0xF40
	Size: 0x1283
	Parameters: 1
	Flags: None
*/
function chooseBetterPositionService(entity)
{
	if(entity ASMIsTransitionRunning() || entity GetBehaviortreeStatus() != 5 || entity ASMIsSubStatePending() || entity AsmIsTransDecRunning())
	{
		return 0;
	}
	shouldRepath = 0;
	var_cb05c034 = 0;
	searchOrigin = undefined;
	var_976ace1e = entity function_553f87a();
	if(!var_976ace1e)
	{
		WarlordServerUtils::ClearPreferedPoint(entity);
		/#
			namespace_e585b400::function_4160d34d(entity, 6);
		#/
		if(isdefined(entity.goalent) || entity.goalRadius < 72)
		{
			var_e972a672 = GetClosestPointOnNavMesh(self.goalpos, 200);
			if(!isdefined(var_e972a672))
			{
				var_e972a672 = self.goalpos;
			}
			entity UsePosition(var_e972a672);
			return 1;
		}
	}
	if(var_976ace1e && shouldHuntEnemyPlayer(entity))
	{
		return _warlordHuntEnemy(entity);
	}
	else if(var_976ace1e && WarlordServerUtils::UpdatePreferedPoint(entity))
	{
		return 1;
	}
	else if(isdefined(entity.lastEnemySightPos) && !WarlordServerUtils::HaveTooLowToAttackEnemy(entity))
	{
		searchOrigin = entity.lastEnemySightPos;
	}
	else
	{
		entity namespace_e585b400::function_3d68d6d1(undefined, (1, 0, 0), "Dev Block strings are not supported");
		searchOrigin = entity.goalpos;
	}
	/#
	#/
	if(isdefined(searchOrigin))
	{
		searchOrigin = GetClosestPointOnNavMesh(searchOrigin, 200);
	}
	if(!isdefined(searchOrigin))
	{
		return 0;
	}
	if(!var_976ace1e || !isdefined(entity.var_26ca18bb) || GetTime() > entity.var_26ca18bb)
	{
		shouldRepath = 1;
	}
	if(isdefined(entity.enemy) && !entity SeeRecently(entity.enemy, 2) && isdefined(entity.lastEnemySightPos))
	{
		/#
			entity namespace_e585b400::function_3d68d6d1(undefined, (1, 1, 1), "Dev Block strings are not supported");
		#/
		var_cb05c034 = 1;
		if(isdefined(entity.pathGoalPos))
		{
			distanceToGoalSqr = DistanceSquared(searchOrigin, entity.pathGoalPos);
			if(distanceToGoalSqr < 200 * 200)
			{
				shouldRepath = 0;
			}
		}
		else
		{
			shouldRepath = 1;
		}
	}
	if(!shouldRepath)
	{
		if(isdefined(entity.var_ecf7b5b1))
		{
			entity.var_ecf7b5b1 = undefined;
			shouldRepath = 1;
		}
	}
	if(shouldRepath)
	{
		queryResult = PositionQuery_Source_Navigation(searchOrigin, 0, entity.engageMaxDist, 45, 72, entity, 72);
		PositionQuery_Filter_InClaimedLocation(queryResult, entity);
		PositionQuery_Filter_DistanceToGoal(queryResult, entity);
		if(isdefined(entity.enemy) && var_cb05c034 && (isdefined(entity.var_568222a9) && entity.var_568222a9))
		{
			PositionQuery_Filter_Sight(queryResult, self lastKnownPos(self.enemy), self GetEye() - self.origin, self, 20);
		}
		var_e84d15a1 = [];
		var_6d0cf0d = [];
		var_20e1d4f5 = 0;
		var_8259f71c = 0;
		var_1d39aec2 = 0;
		var_c713e0ba = 36;
		foreach(point in queryResult.data)
		{
			if(point.inclaimedlocation)
			{
				continue;
			}
			var_20e1d4f5++;
			if(point.distToGoal > 0)
			{
				continue;
			}
			var_8259f71c++;
			if(isdefined(point.visibility) && !point.visibility)
			{
				continue;
			}
			var_1d39aec2++;
			if(point.distToOrigin2D < var_c713e0ba)
			{
				continue;
			}
			var_6d0cf0d[var_6d0cf0d.size] = point.origin;
		}
		if(!(isdefined(entity.enemy) && var_cb05c034 && (isdefined(entity.var_568222a9) && entity.var_568222a9)))
		{
			var_e84d15a1 = WarlordServerUtils::GetPreferedValidPoints(entity);
		}
		if(var_6d0cf0d.size == 0 && var_e84d15a1.size == 0)
		{
			if(var_20e1d4f5 == 0)
			{
				return 0;
				break;
			}
			if(var_8259f71c == 0)
			{
				var_fe3237cf = entity.goalpos + VectorNormalize(searchOrigin - entity.goalpos) * entity.goalRadius;
				queryResult = PositionQuery_Source_Navigation(var_fe3237cf, 0, entity.engageMaxDist, 45, 72, entity, 108);
				PositionQuery_Filter_InClaimedLocation(queryResult, entity);
				PositionQuery_Filter_DistanceToGoal(queryResult, entity);
				var_20e1d4f5 = 0;
				var_8259f71c = 0;
				var_1d39aec2 = 0;
				foreach(point in queryResult.data)
				{
					if(point.inclaimedlocation)
					{
						continue;
					}
					var_20e1d4f5++;
					if(point.distToGoal > 0)
					{
						continue;
					}
					var_8259f71c++;
					if(isdefined(point.visibility) && !point.visibility)
					{
						continue;
					}
					var_1d39aec2++;
					if(point.distToOrigin2D < var_c713e0ba)
					{
						continue;
					}
					var_6d0cf0d[var_6d0cf0d.size] = point.origin;
				}
				if(var_6d0cf0d.size == 0)
				{
					foreach(point in queryResult.data)
					{
						if(point.inclaimedlocation)
						{
							continue;
						}
						if(point.distToGoal > 0)
						{
							continue;
						}
						if(var_1d39aec2 > 0 && isdefined(point.visibility) && !point.visibility)
						{
							continue;
						}
						var_6d0cf0d[var_6d0cf0d.size] = point.origin;
					}
				}
				break;
			}
			foreach(point in queryResult.data)
			{
				if(point.inclaimedlocation)
				{
					continue;
				}
				if(point.distToGoal > 0)
				{
					continue;
				}
				if(var_1d39aec2 > 0 && isdefined(point.visibility) && !point.visibility)
				{
					continue;
				}
				var_6d0cf0d[var_6d0cf0d.size] = point.origin;
			}
			if(var_6d0cf0d.size == 0)
			{
				if(!var_976ace1e)
				{
					if(!isdefined(var_6d0cf0d))
					{
						var_6d0cf0d = [];
					}
					else if(!IsArray(var_6d0cf0d))
					{
						var_6d0cf0d = Array(var_6d0cf0d);
					}
					var_6d0cf0d[var_6d0cf0d.size] = entity.goalpos;
				}
				else
				{
					namespace_e585b400::function_c2db5ca5(entity, 5);
					return 0;
				}
				/#
				#/
			}
		}
		goalweight = -10000;
		var_c3fc0358 = entity.engageminfalloffdist * entity.engageminfalloffdist;
		var_4b54d64a = entity.engageMinDist * entity.engageMinDist;
		var_c9068104 = entity.engageMaxDist * entity.engageMaxDist;
		var_a3945c26 = entity.engagemaxfalloffdist * entity.engagemaxfalloffdist;
		if(isdefined(entity.enemy) && IsSentient(entity.enemy))
		{
			enemyForward = VectorNormalize(AnglesToForward(entity.enemy.angles));
		}
		for(index = 0; index < var_6d0cf0d.size; index++)
		{
			var_ec0332d3 = Distance2DSquared(var_6d0cf0d[index], searchOrigin);
			var_6c2b207a = 1;
			if(isdefined(var_cb05c034) || (isdefined(entity.var_568222a9) && entity.var_568222a9))
			{
				var_6c2b207a = -1;
			}
			var_1fe6d199 = 0;
			if(var_ec0332d3 < var_c3fc0358)
			{
				var_1fe6d199 = -1 * var_6c2b207a;
			}
			else if(var_ec0332d3 < var_4b54d64a)
			{
				var_1fe6d199 = -0.5 * var_6c2b207a;
			}
			else if(var_ec0332d3 > var_a3945c26)
			{
				var_1fe6d199 = 1 * var_6c2b207a;
			}
			else if(var_ec0332d3 > var_c9068104)
			{
				var_1fe6d199 = 1 * var_6c2b207a;
			}
			if(isdefined(enemyForward))
			{
				var_f8b1c22d = ACos(math::clamp(VectorDot(VectorNormalize(var_1fe6d199 - entity.enemy.origin), enemyForward), -1, 1));
				if(var_f8b1c22d > 80)
				{
					var_1fe6d199 = var_1fe6d199 + -0.5;
				}
			}
			var_1fe6d199 = var_1fe6d199 + RandomFloatRange(-0.25, 0.25);
			if(goalweight < var_1fe6d199)
			{
				goalweight = var_1fe6d199;
				goalPosition = var_6d0cf0d[index];
			}
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0 && isdefined(GetEntByNum(GetDvarInt("Dev Block strings are not supported"))) && entity == GetEntByNum(GetDvarInt("Dev Block strings are not supported")))
				{
					as_debug::function_700f290f(entity, var_6d0cf0d[index], var_1fe6d199, -1.25, 1.75);
				}
			#/
		}
		var_cfb305f0 = goalweight;
		foreach(point in var_e84d15a1)
		{
			if(point === entity.var_541cb3cf)
			{
				continue;
			}
			var_1fe6d199 = RandomFloatRange(var_cfb305f0 - 0.25, var_cfb305f0 + 0.5);
			if(goalweight < var_1fe6d199)
			{
				goalweight = var_1fe6d199;
				goalPosition = point.origin;
				var_34862dbe = point;
			}
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0 && isdefined(GetEntByNum(GetDvarInt("Dev Block strings are not supported"))) && entity == GetEntByNum(GetDvarInt("Dev Block strings are not supported")))
				{
					as_debug::function_700f290f(entity, point.origin, var_1fe6d199, -1.25, 1.75);
				}
			#/
		}
		if(isdefined(goalPosition))
		{
			if(entity FindPath(entity.origin, goalPosition, 1, 0))
			{
				entity UsePosition(goalPosition);
				entity.var_26ca18bb = GetTime() + entity.coverSearchInterval;
				if(isdefined(var_34862dbe))
				{
					/#
						namespace_e585b400::function_4160d34d(entity, 4);
					#/
					WarlordServerUtils::SetPreferedPoint(entity, var_34862dbe);
				}
				/#
					if(!isdefined(var_34862dbe))
					{
						namespace_e585b400::function_4160d34d(entity, 5);
					}
				#/
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: canJukeCondition
	Namespace: WarlordBehavior
	Checksum: 0xE169C2F2
	Offset: 0x21D0
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function canJukeCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.nextJukeTime) && GetTime() < behaviorTreeEntity.nextJukeTime)
	{
		return 0;
	}
	return WarlordServerUtils::warlordCanJuke(behaviorTreeEntity);
}

/*
	Name: canTacticalJukeCondition
	Namespace: WarlordBehavior
	Checksum: 0x4E3031FE
	Offset: 0x2228
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function canTacticalJukeCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.nextJukeTime) && GetTime() < behaviorTreeEntity.nextJukeTime)
	{
		return 0;
	}
	return WarlordServerUtils::warlordCanTacticalJuke(behaviorTreeEntity);
}

/*
	Name: warlordShouldNormalMelee
	Namespace: WarlordBehavior
	Checksum: 0xAC318479
	Offset: 0x2280
	Size: 0x297
	Parameters: 1
	Flags: None
*/
function warlordShouldNormalMelee(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enemy) && (!isdefined(behaviorTreeEntity.enemy.allowdeath) && behaviorTreeEntity.enemy.allowdeath))
	{
		return 0;
	}
	if(AiUtility::hasEnemy(behaviorTreeEntity) && !isalive(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(!IsSentient(behaviorTreeEntity.enemy))
	{
		return 0;
	}
	if(isVehicle(behaviorTreeEntity.enemy) && (!isdefined(behaviorTreeEntity.enemy.good_melee_target) && behaviorTreeEntity.enemy.good_melee_target))
	{
		return 0;
	}
	if(!AiUtility::shouldMutexMelee(behaviorTreeEntity))
	{
		return 0;
	}
	if(behaviorTreeEntity ai::has_behavior_attribute("can_melee") && !behaviorTreeEntity ai::get_behavior_attribute("can_melee"))
	{
		return 0;
	}
	if(behaviorTreeEntity.enemy ai::has_behavior_attribute("can_be_meleed") && !behaviorTreeEntity.enemy ai::get_behavior_attribute("can_be_meleed"))
	{
		return 0;
	}
	if(!isPlayer(behaviorTreeEntity.enemy) && (!isdefined(behaviorTreeEntity.enemy.magic_bullet_shield) && behaviorTreeEntity.enemy.magic_bullet_shield))
	{
		return 0;
	}
	if(AiUtility::function_925333fb(behaviorTreeEntity, 100 * 100))
	{
		if(WarlordServerUtils::IsEnemyTooLowToAttack(behaviorTreeEntity.enemy))
		{
			WarlordServerUtils::SetEnemyTooLowToAttack(behaviorTreeEntity);
			return 0;
		}
		return 1;
	}
	return 0;
}

/*
	Name: canTakePainCondition
	Namespace: WarlordBehavior
	Checksum: 0x4E15C437
	Offset: 0x2520
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function canTakePainCondition(behaviorTreeEntity)
{
	return GetTime() >= behaviorTreeEntity.var_2ac908f2;
}

/*
	Name: jukeAction
	Namespace: WarlordBehavior
	Checksum: 0x5C456C57
	Offset: 0x2548
	Size: 0x1BF
	Parameters: 2
	Flags: None
*/
function jukeAction(behaviorTreeEntity, asmStateName)
{
	if(WarlordServerUtils::HaveTooLowToAttackEnemy(behaviorTreeEntity))
	{
		nextJukeTime = 1000;
	}
	else
	{
		nextJukeTime = 3000;
	}
	behaviorTreeEntity.nextJukeTime = GetTime() + nextJukeTime;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	jukeDirection = blackboard::GetBlackBoardAttribute(behaviorTreeEntity, "_juke_direction");
	switch(jukeDirection)
	{
		case "left":
		{
			clientfield::set("warlord_thruster_direction", 4);
			break;
		}
		case "right":
		{
			clientfield::set("warlord_thruster_direction", 3);
			break;
		}
	}
	behaviorTreeEntity clearPath();
	jukeInfo = spawnstruct();
	jukeInfo.origin = behaviorTreeEntity.origin;
	jukeInfo.entity = behaviorTreeEntity;
	blackboard::AddBlackboardEvent("actor_juke", jukeInfo, 2000);
	jukeInfo.entity playsound("fly_jetpack_juke_warlord");
	return 5;
}

/*
	Name: jukeActionTerminate
	Namespace: WarlordBehavior
	Checksum: 0xFDCC7FFA
	Offset: 0x2710
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function jukeActionTerminate(behaviorTreeEntity, asmStateName)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_juke_direction", undefined);
	clientfield::set("warlord_thruster_direction", 0);
	positionOnNavMesh = GetClosestPointOnNavMesh(behaviorTreeEntity.origin, 200);
	if(!isdefined(positionOnNavMesh))
	{
		positionOnNavMesh = behaviorTreeEntity.origin;
	}
	behaviorTreeEntity UsePosition(positionOnNavMesh);
	return 4;
}

/*
	Name: deathAction
	Namespace: WarlordBehavior
	Checksum: 0x5E96BEC8
	Offset: 0x27C8
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function deathAction(behaviorTreeEntity, asmStateName)
{
	clientfield::set("warlord_damage_state", 3);
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: exposedPainActionStart
	Namespace: WarlordBehavior
	Checksum: 0xFA8D1E45
	Offset: 0x2820
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function exposedPainActionStart(behaviorTreeEntity)
{
	behaviorTreeEntity.var_2ac908f2 = GetTime() + randomIntRange(500, 2500);
	AiUtility::keepClaimNode(behaviorTreeEntity);
}

/*
	Name: shouldBeAngryCondition
	Namespace: WarlordBehavior
	Checksum: 0xF09D1CAA
	Offset: 0x2880
	Size: 0x129
	Parameters: 1
	Flags: None
*/
function shouldBeAngryCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.var_1fe9366e) && GetTime() < behaviorTreeEntity.var_1fe9366e)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.var_84bdb4be) || behaviorTreeEntity.var_84bdb4be.size == 0)
	{
		return 0;
	}
	else if(behaviorTreeEntity.var_84bdb4be.size == 1 && isdefined(behaviorTreeEntity.enemy) && behaviorTreeEntity.var_84bdb4be[0].attacker == behaviorTreeEntity.enemy)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.var_9366282a) && behaviorTreeEntity.var_9366282a > WarlordServerUtils::GetScaledForPlayers(200, 1.5, 2, 2.5))
	{
		return 1;
	}
	return behaviorTreeEntity.var_b654f978;
}

/*
	Name: WarlordAngryAttack
	Namespace: WarlordBehavior
	Checksum: 0xF2D3E11F
	Offset: 0x29B8
	Size: 0x2DF
	Parameters: 1
	Flags: None
*/
function WarlordAngryAttack(entity)
{
	/#
		namespace_e585b400::function_3d68d6d1(1, (0, 1, 0), "Dev Block strings are not supported");
	#/
	entity.var_b654f978 = 1;
	entity.var_b3ecf9da = 1;
	entity.var_9366282a = 0;
	entity.var_1fe9366e = GetTime() + 13000;
	WarlordServerUtils::UpdateAttackersList(entity);
	attackersArray = [];
	for(i = 0; i < entity.var_84bdb4be.size; i++)
	{
		for(j = i + 1; j < entity.var_84bdb4be.size; j++)
		{
			if(entity.var_84bdb4be[i].threat < entity.var_84bdb4be[j].threat)
			{
				tmp = entity.var_84bdb4be[j].threat;
				entity.var_84bdb4be[j].threat = entity.var_84bdb4be[i].threat;
				entity.var_84bdb4be[i].threat = tmp;
			}
		}
	}
	foreach(data in entity.var_84bdb4be)
	{
		if(!isdefined(attackersArray))
		{
			attackersArray = [];
		}
		else if(!IsArray(attackersArray))
		{
			attackersArray = Array(attackersArray);
		}
		attackersArray[attackersArray.size] = data.attacker;
	}
	thread WarlordAngryAttack_ShootThemAll(entity, attackersArray);
	return 1;
}

/*
	Name: WarlordAngryAttack_ShootThemAll
	Namespace: WarlordBehavior
	Checksum: 0xC6CC73FA
	Offset: 0x2CA0
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function WarlordAngryAttack_ShootThemAll(entity, attackersArray)
{
	entity endon("disconnect");
	entity endon("death");
	entity notify("hash_b160390f");
	shoottime = GetDvarFloat("warlordangryattack", 3);
	foreach(attacker in attackersArray)
	{
		if(isdefined(attacker))
		{
			entity ai::shoot_at_target("normal", attacker, undefined, shoottime, undefined, 1);
		}
	}
	/#
		namespace_e585b400::function_3d68d6d1(1, (0, 0, 1), "Dev Block strings are not supported");
	#/
	entity.var_b3ecf9da = 0;
	entity.var_b654f978 = 0;
}

#namespace WarlordServerUtils;

/*
	Name: GetAlivePlayersCount
	Namespace: WarlordServerUtils
	Checksum: 0xCAD3D077
	Offset: 0x2DF8
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function GetAlivePlayersCount(entity)
{
	if(entity.team == "allies")
	{
		return level.aliveCount["axis"];
	}
	else
	{
		return level.aliveCount["allies"];
	}
}

/*
	Name: SetWarlordAggressiveMode
	Namespace: WarlordServerUtils
	Checksum: 0x3AA3D7C8
	Offset: 0x2E58
	Size: 0x159
	Parameters: 2
	Flags: None
*/
function SetWarlordAggressiveMode(entity, b_aggressive_mode)
{
	entity.var_568222a9 = b_aggressive_mode;
	if(isdefined(b_aggressive_mode) && b_aggressive_mode)
	{
		foreach(player in level.players)
		{
			entity SetPersonalThreatBias(player, 1000);
		}
		break;
	}
	foreach(player in level.players)
	{
		entity SetPersonalThreatBias(player, 0, 1);
	}
}

/*
	Name: AddPreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0xE8D220CF
	Offset: 0x2FC0
	Size: 0x1D5
	Parameters: 5
	Flags: None
*/
function AddPreferedPoint(entity, position, min_duration, max_duration, name)
{
	positionOnNavMesh = GetClosestPointOnNavMesh(position, 200, 25);
	if(!isdefined(positionOnNavMesh))
	{
		/#
			println("Dev Block strings are not supported" + position);
		#/
		return;
	}
	else
	{
		position = positionOnNavMesh;
	}
	if(!entity IsPosAtGoal(position))
	{
		/#
			println("Dev Block strings are not supported" + position);
		#/
	}
	point = spawnstruct();
	point.origin = position;
	point.min_duration = min_duration;
	point.max_duration = max_duration;
	point.name = name;
	if(!isdefined(entity.var_a3fbe34e))
	{
		entity.var_a3fbe34e = [];
	}
	else if(!IsArray(entity.var_a3fbe34e))
	{
		entity.var_a3fbe34e = Array(entity.var_a3fbe34e);
	}
	entity.var_a3fbe34e[entity.var_a3fbe34e.size] = point;
}

/*
	Name: DeletePreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0x1F35D680
	Offset: 0x31A0
	Size: 0x1C1
	Parameters: 2
	Flags: None
*/
function DeletePreferedPoint(entity, name)
{
	if(isdefined(entity.var_a3fbe34e))
	{
		var_18648ef7 = [];
		foreach(point in entity.var_a3fbe34e)
		{
			if(point.name === name)
			{
				if(!isdefined(var_18648ef7))
				{
					var_18648ef7 = [];
				}
				else if(!IsArray(var_18648ef7))
				{
					var_18648ef7 = Array(var_18648ef7);
				}
				var_18648ef7[var_18648ef7.size] = point;
			}
		}
		if(var_18648ef7.size > 0)
		{
			foreach(point in var_18648ef7)
			{
				ArrayRemoveValue(entity.var_a3fbe34e, point);
			}
			return 1;
		}
	}
	return 0;
}

/*
	Name: ClearAllPreferedPoints
	Namespace: WarlordServerUtils
	Checksum: 0x9836F391
	Offset: 0x3370
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function ClearAllPreferedPoints(entity)
{
	ClearPreferedPoint(entity);
	entity.var_a3fbe34e = [];
}

/*
	Name: ClearPreferedPointsOutsideGoal
	Namespace: WarlordServerUtils
	Checksum: 0xEA480D72
	Offset: 0x33B0
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function ClearPreferedPointsOutsideGoal(entity)
{
	var_18648ef7 = [];
	foreach(point in entity.var_a3fbe34e)
	{
		if(!entity IsPosAtGoal(point.origin))
		{
			if(!isdefined(var_18648ef7))
			{
				var_18648ef7 = [];
			}
			else if(!IsArray(var_18648ef7))
			{
				var_18648ef7 = Array(var_18648ef7);
			}
			var_18648ef7[var_18648ef7.size] = point;
		}
	}
	foreach(point in var_18648ef7)
	{
		ArrayRemoveValue(entity.var_a3fbe34e, point);
	}
}

/*
	Name: SetPreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0xDBFFF006
	Offset: 0x3560
	Size: 0x43
	Parameters: 2
	Flags: Private
*/
function private SetPreferedPoint(entity, point)
{
	entity.var_541cb3cf = entity.var_4a9d2541;
	entity.var_4a9d2541 = point;
}

/*
	Name: ClearPreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0x7FA14ED5
	Offset: 0x35B0
	Size: 0x51
	Parameters: 1
	Flags: Private
*/
function private ClearPreferedPoint(entity)
{
	/#
		namespace_e585b400::function_4160d34d(entity, undefined);
	#/
	entity.var_7e5dd3e4 = undefined;
	entity.var_a2230d1b = undefined;
	entity.var_4a9d2541 = undefined;
}

/*
	Name: AtPreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0x884EF31C
	Offset: 0x3610
	Size: 0xAF
	Parameters: 1
	Flags: Private
*/
function private AtPreferedPoint(entity)
{
	if(isdefined(entity.var_4a9d2541) && (DistanceSquared(entity.var_4a9d2541.origin, entity.origin) < 36 * 36 && Abs(self.var_4a9d2541.origin[2] - entity.origin[2]) < 45))
	{
		return 1;
	}
	return 0;
}

/*
	Name: ReachingPreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0x9A2E3624
	Offset: 0x36C8
	Size: 0x87
	Parameters: 1
	Flags: Private
*/
function private ReachingPreferedPoint(entity)
{
	if(!isdefined(entity.var_4a9d2541))
	{
		return 0;
	}
	if(AtPreferedPoint(entity))
	{
		return 1;
	}
	if(isdefined(entity.pathGoalPos) && entity.pathGoalPos == entity.var_4a9d2541.origin)
	{
		return 1;
	}
	return 0;
}

/*
	Name: UpdatePreferedPoint
	Namespace: WarlordServerUtils
	Checksum: 0xF0F30C96
	Offset: 0x3758
	Size: 0x203
	Parameters: 1
	Flags: Private
*/
function private UpdatePreferedPoint(entity)
{
	if(isdefined(entity.var_4a9d2541))
	{
		if(AtPreferedPoint(entity))
		{
			if(isdefined(entity.var_a2230d1b))
			{
				if(GetTime() > entity.var_a2230d1b)
				{
					ClearPreferedPoint(entity);
					return 0;
				}
				return 1;
			}
			else if(isdefined(entity.var_4a9d2541.min_duration))
			{
				entity.var_7e5dd3e4 = GetTime();
				if(!isdefined(entity.var_4a9d2541.max_duration) || entity.var_4a9d2541.max_duration == entity.var_4a9d2541.min_duration)
				{
					entity.var_a2230d1b = GetTime() + entity.var_4a9d2541.min_duration;
				}
				else
				{
					duration = randomIntRange(entity.var_4a9d2541.min_duration, entity.var_4a9d2541.max_duration);
					entity.var_a2230d1b = GetTime() + duration;
				}
				return 1;
			}
			else
			{
				ClearPreferedPoint(entity);
				return 0;
			}
			return 1;
		}
		else if(!ReachingPreferedPoint(entity))
		{
			entity UsePosition(entity.var_4a9d2541.origin);
		}
		return 1;
	}
	return 0;
}

/*
	Name: GetPreferedValidPoints
	Namespace: WarlordServerUtils
	Checksum: 0xB5364E33
	Offset: 0x3968
	Size: 0x243
	Parameters: 1
	Flags: Private
*/
function private GetPreferedValidPoints(entity)
{
	var_3a993b10 = [];
	if(isdefined(entity.var_a3fbe34e))
	{
		foreach(point in entity.var_a3fbe34e)
		{
			if(!entity IsPosAtGoal(point.origin))
			{
				Distance = Distance2DSquared(entity.origin, point.origin);
				Distance = sqrt(Distance);
				continue;
			}
			if(entity IsPosInClaimedLocation(point.origin))
			{
				continue;
			}
			if(isdefined(entity.enemy) && (isdefined(entity.var_568222a9) && entity.var_568222a9))
			{
				if(!BulletTracePassed(entity GetEye(), entity.enemy.origin + VectorScale((0, 0, 1), 50), 0, entity, entity.enemy))
				{
					continue;
				}
			}
			if(!isdefined(var_3a993b10))
			{
				var_3a993b10 = [];
			}
			else if(!IsArray(var_3a993b10))
			{
				var_3a993b10 = Array(var_3a993b10);
			}
			var_3a993b10[var_3a993b10.size] = point;
		}
	}
	return var_3a993b10;
}

/*
	Name: GetScaledForPlayers
	Namespace: WarlordServerUtils
	Checksum: 0xA539659F
	Offset: 0x3BB8
	Size: 0xA7
	Parameters: 4
	Flags: None
*/
function GetScaledForPlayers(VAL, scale2, scale3, scale4)
{
	if(!isdefined(level.players))
	{
		return VAL;
	}
	if(level.players.size == 2)
	{
		return VAL * scale2;
	}
	else if(level.players.size == 3)
	{
		return VAL * scale3;
	}
	else if(level.players.size == 4)
	{
		return VAL * scale4;
	}
	else
	{
		return VAL;
	}
}

/*
	Name: warlordCanJuke
	Namespace: WarlordServerUtils
	Checksum: 0x52DEA568
	Offset: 0x3C68
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function warlordCanJuke(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	distanceSqr = DistanceSquared(entity.enemy.origin, entity.origin);
	if(distanceSqr < 300 * 300)
	{
		jukeDistance = 72.5;
	}
	else
	{
		jukeDistance = 145;
	}
	jukeDirection = AiUtility::calculateJukeDirection(entity, 18, jukeDistance);
	if(jukeDirection != "forward")
	{
		blackboard::SetBlackBoardAttribute(entity, "_juke_direction", jukeDirection);
		if(jukeDistance == 145)
		{
			blackboard::SetBlackBoardAttribute(entity, "_juke_distance", "long");
		}
		else
		{
			blackboard::SetBlackBoardAttribute(entity, "_juke_distance", "short");
		}
		return 1;
	}
	return 0;
}

/*
	Name: warlordCanTacticalJuke
	Namespace: WarlordServerUtils
	Checksum: 0xDCAACE65
	Offset: 0x3DC8
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function warlordCanTacticalJuke(entity)
{
	if(entity HasPath())
	{
		var_26383879 = AiUtility::BB_GetLocomotionFaceEnemyQuadrant();
		if(var_26383879 == "locomotion_face_enemy_front" || var_26383879 == "locomotion_face_enemy_back")
		{
			jukeDirection = AiUtility::calculateJukeDirection(entity, 50, 145);
			if(jukeDirection != "forward")
			{
				blackboard::SetBlackBoardAttribute(entity, "_juke_direction", jukeDirection);
				blackboard::SetBlackBoardAttribute(entity, "_juke_distance", "long");
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: IsEnemyTooLowToAttack
	Namespace: WarlordServerUtils
	Checksum: 0xEE04B64
	Offset: 0x3EC8
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function IsEnemyTooLowToAttack(enemy)
{
	if(isPlayer(enemy))
	{
		if(isdefined(enemy.laststand) && enemy.laststand)
		{
			return 1;
		}
		PlayerStance = enemy GetStance();
		if(isdefined(PlayerStance) && (PlayerStance == "prone" || PlayerStance == "crouch"))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: HaveTooLowToAttackEnemy
	Namespace: WarlordServerUtils
	Checksum: 0xD70C1A6C
	Offset: 0x3F78
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function HaveTooLowToAttackEnemy(entity)
{
	if(!isdefined(entity.var_db9be359))
	{
		return 0;
	}
	if(GetTime() - entity.var_db9be359 <= 4000)
	{
		return 1;
	}
	entity.var_db9be359 = undefined;
	return 0;
}

/*
	Name: SetEnemyTooLowToAttack
	Namespace: WarlordServerUtils
	Checksum: 0xE8FC266E
	Offset: 0x3FD8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function SetEnemyTooLowToAttack(entity)
{
	if(HaveTooLowToAttackEnemy(entity))
	{
		return;
	}
	entity.var_db9be359 = GetTime();
	entity.var_ecf7b5b1 = 1;
}

/*
	Name: ComputeAttackerThreat
	Namespace: WarlordServerUtils
	Checksum: 0xDB8C660C
	Offset: 0x4030
	Size: 0x1C3
	Parameters: 2
	Flags: None
*/
function ComputeAttackerThreat(entity, attackerInfo)
{
	if(attackerInfo.damage < 250)
	{
		return 0;
	}
	threat = 1;
	var_600fee07 = isPlayer(attackerInfo.attacker);
	if(var_600fee07)
	{
		threat = threat * 10;
	}
	var_bfbf28f9 = Distance2DSquared(entity.origin, attackerInfo.attacker.origin);
	var_1742c12e = 0;
	if(var_600fee07)
	{
		if(var_bfbf28f9 <= 100 * 100)
		{
			threat = threat * 1000;
		}
		else
		{
			var_1742c12e = var_bfbf28f9 / entity.engagemaxfalloffdist * entity.engagemaxfalloffdist;
			if(var_1742c12e > 1)
			{
				var_1742c12e = 1;
			}
			var_1742c12e = 1 - var_1742c12e;
		}
	}
	var_e864ad90 = attackerInfo.damage / 1000;
	if(var_e864ad90 > 1)
	{
		var_e864ad90 = 1;
	}
	threat = threat * var_1742c12e * 0.65 + var_e864ad90 * 0.35 * 100;
	return threat;
}

/*
	Name: ShouldSwitchToNewThreat
	Namespace: WarlordServerUtils
	Checksum: 0xFA89E166
	Offset: 0x4200
	Size: 0xB1
	Parameters: 3
	Flags: None
*/
function ShouldSwitchToNewThreat(entity, attacker, threat)
{
	if(entity.enemy === attacker)
	{
		return 0;
	}
	if(!isdefined(entity.var_f8d4f481))
	{
		return 1;
	}
	if(entity.var_f8d4f481.health <= 0)
	{
		return 1;
	}
	if(entity.var_f8d4f481 == attacker)
	{
		return 0;
	}
	if(GetTime() - entity.var_8af76ae5 < 1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: UpdateAttackersList
	Namespace: WarlordServerUtils
	Checksum: 0x23F4B590
	Offset: 0x42C0
	Size: 0x49B
	Parameters: 3
	Flags: None
*/
function UpdateAttackersList(entity, newAttacker, damage)
{
	if(!isdefined(entity.var_84bdb4be))
	{
		entity.var_84bdb4be = [];
	}
	var_1cc53b35 = 0;
	var_a75ea562 = 0;
	for(i = 0; i < entity.var_84bdb4be.size; i++)
	{
		attacker = entity.var_84bdb4be[i].attacker;
		if(!isdefined(attacker) || !IsEntity(attacker) || attacker.health <= 0 || GetTime() - entity.var_84bdb4be[i].var_b50a7522 > 5000)
		{
			ArrayRemoveIndex(entity.var_84bdb4be, i);
			i--;
			continue;
		}
		entity.var_84bdb4be[i].threat = ComputeAttackerThreat(entity, entity.var_84bdb4be[i]);
		if(entity.var_84bdb4be[i].threat > var_1cc53b35)
		{
			var_1cc53b35 = entity.var_84bdb4be[i].threat;
			var_64e4a88a = entity.var_84bdb4be[i];
		}
	}
	if(isdefined(newAttacker))
	{
		for(i = 0; i < entity.var_84bdb4be.size; i++)
		{
			if(entity.var_84bdb4be[i].attacker == newAttacker)
			{
				var_5b90059d = entity.var_84bdb4be[i];
				var_5b90059d.var_b50a7522 = GetTime();
				var_5b90059d.damage = var_5b90059d.damage + damage;
				break;
			}
		}
		if(!isdefined(var_5b90059d))
		{
			var_5b90059d = spawnstruct();
			var_5b90059d.attacker = newAttacker;
			var_5b90059d.var_b50a7522 = GetTime();
			var_5b90059d.damage = damage;
			var_5b90059d.threat = 0;
			if(!isdefined(entity.var_84bdb4be))
			{
				entity.var_84bdb4be = [];
			}
			else if(!IsArray(entity.var_84bdb4be))
			{
				entity.var_84bdb4be = Array(entity.var_84bdb4be);
			}
			entity.var_84bdb4be[entity.var_84bdb4be.size] = var_5b90059d;
		}
		var_5b90059d.threat = ComputeAttackerThreat(entity, var_5b90059d);
		if(var_5b90059d.threat > var_1cc53b35)
		{
			var_1cc53b35 = var_5b90059d.threat;
			var_64e4a88a = var_5b90059d;
		}
	}
	if(isdefined(var_64e4a88a) && var_1cc53b35 > 0)
	{
		if(ShouldSwitchToNewThreat(entity, var_64e4a88a.attacker, var_1cc53b35))
		{
			thread WarlordDangerousEnemyAttack(entity, var_64e4a88a.attacker, var_1cc53b35);
		}
	}
	CheckifWeShouldMove(entity);
}

/*
	Name: CheckifWeShouldMove
	Namespace: WarlordServerUtils
	Checksum: 0xBC7908AA
	Offset: 0x4768
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function CheckifWeShouldMove(entity)
{
	if(!isdefined(entity.var_84bdb4be) || entity.var_84bdb4be.size <= 1)
	{
		return;
	}
	var_a8e832eb = 0;
	if(AtPreferedPoint(entity))
	{
		if(!isdefined(entity.var_7e5dd3e4) || GetTime() - entity.var_7e5dd3e4 < 1)
		{
			return;
		}
		var_a8e832eb = 1;
	}
	if(!var_a8e832eb)
	{
		if(isdefined(entity.pathGoalPos))
		{
			if(Distance2DSquared(entity.pathGoalPos, entity.origin) < 36 * 36 && Abs(entity.pathGoalPos[2] - entity.origin[2]) < 45)
			{
				var_a8e832eb = 1;
			}
		}
	}
	if(var_a8e832eb)
	{
		if(HaveTooLowToAttackEnemy(entity))
		{
			var_a94cf21a = 1;
			break;
		}
		var_a94cf21a = 0;
		foreach(attackerInfo in entity.var_84bdb4be)
		{
			if(attackerInfo.damage > 200)
			{
				var_a94cf21a++;
			}
		}
		if(var_a94cf21a > 1)
		{
			ClearPreferedPoint(entity);
			entity.var_26ca18bb = 0;
		}
	}
}

/*
	Name: WarlordDangerousEnemyAttack
	Namespace: WarlordServerUtils
	Checksum: 0xB8E19204
	Offset: 0x49C0
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function WarlordDangerousEnemyAttack(entity, attacker, threat)
{
	entity endon("disconnect");
	entity endon("death");
	attacker endon("death");
	entity endon("hash_b160390f");
	entity notify("hash_beb03d5e");
	entity endon("hash_beb03d5e");
	entity.var_8af76ae5 = GetTime();
	entity.var_f8d4f481 = attacker;
	entity.var_3968f41e = threat;
	/#
		namespace_e585b400::function_3d68d6d1(0, (0, 1, 0), "Dev Block strings are not supported");
	#/
	shoottime = GetDvarFloat("warlordangryattack", 3);
	entity ai::shoot_at_target("normal", attacker, undefined, shoottime, undefined, 1);
	entity.var_f8d4f481 = undefined;
	/#
		namespace_e585b400::function_3d68d6d1(0, (0, 0, 1), "Dev Block strings are not supported");
	#/
}

/*
	Name: warlordDamageOverride
	Namespace: WarlordServerUtils
	Checksum: 0x81AB499E
	Offset: 0x4B18
	Size: 0x2F3
	Parameters: 15
	Flags: None
*/
function warlordDamageOverride(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal)
{
	entity = self;
	if(!isPlayer(eAttacker))
	{
		iDamage = Int(iDamage * 0.05);
	}
	if(isdefined(sMeansOfDeath) && (sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_GRENADE"))
	{
		iDamage = Int(iDamage * 0.25);
	}
	UpdateAttackersList(entity, eAttacker, iDamage);
	if(entity.health <= entity.var_538edf9c)
	{
		clientfield::set("warlord_damage_state", 2);
	}
	else if(entity.health <= entity.var_3f5986f)
	{
		clientfield::set("warlord_damage_state", 1);
	}
	else
	{
		clientfield::set("warlord_damage_state", 0);
	}
	if(!isdefined(entity.lastDamageTime))
	{
		entity.lastDamageTime = 0;
	}
	if(GetTime() - entity.lastDamageTime > 1500)
	{
		entity.var_9366282a = iDamage;
	}
	else
	{
		entity.var_9366282a = entity.var_9366282a + iDamage;
	}
	var_9dcbd3e = GetDvarInt("warlordhuntdamage", 350);
	if(entity.var_9366282a > GetScaledForPlayers(var_9dcbd3e, 1.5, 2, 2.5))
	{
		self.var_ce767dbd = GetTime() + 15000;
	}
	entity.lastDamageTime = GetTime();
	return iDamage;
}

/*
	Name: warlordSpawnSetup
	Namespace: WarlordServerUtils
	Checksum: 0x70401228
	Offset: 0x4E18
	Size: 0x235
	Parameters: 0
	Flags: None
*/
function warlordSpawnSetup()
{
	entity = self;
	entity.var_568222a9 = 0;
	entity.var_b654f978 = 0;
	entity.var_2ac908f2 = 0;
	entity.var_8af76ae5 = 0;
	entity.var_3968f41e = 0;
	entity.ignorerunAndgundist = 1;
	entity.combatmode = "no_cover";
	AiUtility::AddAIOverrideDamageCallback(entity, &warlordDamageOverride);
	entity.health = Int(GetScaledForPlayers(entity.health, 2, 2.5, 3));
	entity.fullHealth = entity.health;
	entity.var_3f5986f = Int(entity.fullHealth * 0.5);
	entity.var_538edf9c = Int(entity.fullHealth * 0.25);
	entity warlord_projectile_watcher();
	clientfield::set("warlord_damage_state", 0);
	clientfield::set("warlord_lights_state", 1);
	switch(entity.classname)
	{
		case "actor_spawner_bo3_warlord_enemy_hvt":
		{
			clientfield::set("warlord_type", 2);
			break;
		}
		case default:
		{
			clientfield::set("warlord_type", 1);
			break;
		}
	}
}

/*
	Name: warlord_projectile_watcher
	Namespace: WarlordServerUtils
	Checksum: 0xEFBFE8FE
	Offset: 0x5058
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function warlord_projectile_watcher()
{
	if(!isdefined(self.missile_repulsor))
	{
		self.missile_repulsor = missile_createrepulsorent(self, 40000, 256, 1);
	}
	self thread repulsor_fx();
}

/*
	Name: remove_repulsor
	Namespace: WarlordServerUtils
	Checksum: 0xBA2D75E4
	Offset: 0x50B8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function remove_repulsor()
{
	self endon("death");
	if(isdefined(self.missile_repulsor))
	{
		missile_deleteattractor(self.missile_repulsor);
		self.missile_repulsor = undefined;
	}
	wait(0.5);
	if(isdefined(self))
	{
		self warlord_projectile_watcher();
	}
}

/*
	Name: repulsor_fx
	Namespace: WarlordServerUtils
	Checksum: 0x9B179A14
	Offset: 0x5128
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function repulsor_fx()
{
	self endon("death");
	self endon("hash_85c65e4");
	while(1)
	{
		self util::waittill_any("projectile_applyattractor", "play_meleefx");
		PlayFXOnTag("vehicle/fx_quadtank_airburst", self, "tag_origin");
		PlayFXOnTag("vehicle/fx_quadtank_airburst_ground", self, "tag_origin");
		self playsound("wpn_trophy_alert");
		self thread remove_repulsor();
		self notify("hash_85c65e4");
	}
}

/*
	Name: trigger_player_shock_fx
	Namespace: WarlordServerUtils
	Checksum: 0xCA21C26E
	Offset: 0x5200
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function trigger_player_shock_fx()
{
	if(!isdefined(self._player_shock_fx_quadtank_melee))
	{
		self._player_shock_fx_quadtank_melee = 0;
	}
	self._player_shock_fx_quadtank_melee = !self._player_shock_fx_quadtank_melee;
	self clientfield::set_to_player("player_shock_fx", self._player_shock_fx_quadtank_melee);
}

#namespace namespace_e585b400;

/*
	Name: function_3d68d6d1
	Namespace: namespace_e585b400
	Checksum: 0x90CAF4EC
	Offset: 0x5260
	Size: 0x273
	Parameters: 3
	Flags: None
*/
function function_3d68d6d1(State, color, string)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(!isdefined(string))
			{
				string = "Dev Block strings are not supported";
			}
			if(!isdefined(State))
			{
				if(!isdefined(self) || !isdefined(self.var_dd97082a) || self.var_dd97082a != string)
				{
					self.var_dd97082a = string;
					PrintTopRightln(string + GetTime(), color, -1);
				}
				return;
			}
			if(State == 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
			else if(State == 1)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
			else if(State == 2)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
			else if(State == 3)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
			else if(State == 4)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
			else if(State == 5)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
			else if(State == 6)
			{
				PrintTopRightln("Dev Block strings are not supported" + string + GetTime(), color, -1);
			}
		}
	#/
}

/*
	Name: function_3f561bff
	Namespace: namespace_e585b400
	Checksum: 0x656E1237
	Offset: 0x54E0
	Size: 0x93
	Parameters: 3
	Flags: None
*/
function function_3f561bff(entity, State, var_db3a489f)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(!(isdefined(var_db3a489f) && function_ee4f0cdc(entity, State)))
			{
				color = (1, 1, 1);
				entity function_3d68d6d1(State, color);
			}
		}
	#/
}

/*
	Name: function_4160d34d
	Namespace: namespace_e585b400
	Checksum: 0x51C59591
	Offset: 0x5580
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function function_4160d34d(entity, State, var_4b0cc01e)
{
	if(!isdefined(var_4b0cc01e))
	{
		var_4b0cc01e = 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(!isdefined(var_4b0cc01e) || function_ee4f0cdc(entity, State))
			{
				color = (0, 1, 0);
			}
			else
			{
				color = (0, 1, 1);
			}
			if(!isdefined(State))
			{
				color = (0, 0, 1);
				entity function_3d68d6d1(entity.currentState, color, "Dev Block strings are not supported");
			}
			entity function_3d68d6d1(State, color);
		}
	#/
	entity.currentState = State;
}

/*
	Name: function_c2db5ca5
	Namespace: namespace_e585b400
	Checksum: 0x5896E1E2
	Offset: 0x56A0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function function_c2db5ca5(entity, State)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			color = (1, 1, 0);
			entity function_3d68d6d1(State, color);
		}
	#/
}

/*
	Name: function_ee4f0cdc
	Namespace: namespace_e585b400
	Checksum: 0xDB5AA654
	Offset: 0x5718
	Size: 0x7D
	Parameters: 2
	Flags: None
*/
function function_ee4f0cdc(entity, State)
{
	var_42b6f508 = 0;
	if(!isdefined(entity.currentState))
	{
		var_42b6f508 = 1;
	}
	else if(!isdefined(State))
	{
		return 0;
	}
	else if(entity.currentState != State)
	{
		var_42b6f508 = 1;
	}
	return var_42b6f508;
}

