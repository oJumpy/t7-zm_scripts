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
		self finalizetrackedblackboardattributes();
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
	if(isdefined(entity.enemy) && isdefined(entity.huntenemytime) && GetTime() < entity.huntenemytime)
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
		warlorddebughelpers::trystate(entity, 3, 1);
	#/
	if(Distance2DSquared(entity.origin, self lastKnownPos(self.enemy)) <= 250 * 250)
	{
		return 0;
	}
	if(isdefined(entity.huntupdatenexttime) && GetTime() < entity.huntupdatenexttime)
	{
		return 0;
	}
	if(entity.isangryattack)
	{
		/#
			warlorddebughelpers::printstate(3, (1, 0, 1), "Dev Block strings are not supported");
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
				warlorddebughelpers::setcurrentstate(entity, 3, 1);
			#/
			entity UsePosition(closestPoint);
			entity.huntupdatenexttime = GetTime() + randomIntRange(500, 1500);
			return 1;
		}
	}
	/#
		warlorddebughelpers::setstatefailed(entity, 3);
	#/
	entity.huntenemytime = undefined;
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
	istrackingenemylastpos = 0;
	searchOrigin = undefined;
	bapproachinggoal = entity function_553f87a();
	if(!bapproachinggoal)
	{
		WarlordServerUtils::ClearPreferedPoint(entity);
		/#
			warlorddebughelpers::setcurrentstate(entity, 6);
		#/
		if(isdefined(entity.goalent) || entity.goalRadius < 72)
		{
			goalposonmesh = GetClosestPointOnNavMesh(self.goalpos, 200);
			if(!isdefined(goalposonmesh))
			{
				goalposonmesh = self.goalpos;
			}
			entity UsePosition(goalposonmesh);
			return 1;
		}
	}
	if(bapproachinggoal && shouldHuntEnemyPlayer(entity))
	{
		return _warlordHuntEnemy(entity);
	}
	else if(bapproachinggoal && WarlordServerUtils::UpdatePreferedPoint(entity))
	{
		return 1;
	}
	else if(isdefined(entity.lastEnemySightPos) && !WarlordServerUtils::HaveTooLowToAttackEnemy(entity))
	{
		searchOrigin = entity.lastEnemySightPos;
	}
	else
	{
		entity warlorddebughelpers::printstate(undefined, (1, 0, 0), "Dev Block strings are not supported");
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
	if(!bapproachinggoal || !isdefined(entity.nextfindbetterpositiontime) || GetTime() > entity.nextfindbetterpositiontime)
	{
		shouldRepath = 1;
	}
	if(isdefined(entity.enemy) && !entity SeeRecently(entity.enemy, 2) && isdefined(entity.lastEnemySightPos))
	{
		/#
			entity warlorddebughelpers::printstate(undefined, (1, 1, 1), "Dev Block strings are not supported");
		#/
		istrackingenemylastpos = 1;
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
		if(isdefined(entity.hascrouchingenemy))
		{
			entity.hascrouchingenemy = undefined;
			shouldRepath = 1;
		}
	}
	if(shouldRepath)
	{
		queryResult = PositionQuery_Source_Navigation(searchOrigin, 0, entity.engageMaxDist, 45, 72, entity, 72);
		PositionQuery_Filter_InClaimedLocation(queryResult, entity);
		PositionQuery_Filter_DistanceToGoal(queryResult, entity);
		if(isdefined(entity.enemy) && istrackingenemylastpos && (isdefined(entity.warlordaggressivemode) && entity.warlordaggressivemode))
		{
			PositionQuery_Filter_Sight(queryResult, self lastKnownPos(self.enemy), self GetEye() - self.origin, self, 20);
		}
		preferedpoints = [];
		randompoints = [];
		bpointsavailable = 0;
		bpointsingoal = 0;
		bpointsvisible = 0;
		closepointdistance = 36;
		foreach(point in queryResult.data)
		{
			if(point.inclaimedlocation)
			{
				continue;
			}
			bpointsavailable++;
			if(point.distToGoal > 0)
			{
				continue;
			}
			bpointsingoal++;
			if(isdefined(point.visibility) && !point.visibility)
			{
				continue;
			}
			bpointsvisible++;
			if(point.distToOrigin2D < closepointdistance)
			{
				continue;
			}
			randompoints[randompoints.size] = point.origin;
		}
		if(!(isdefined(entity.enemy) && istrackingenemylastpos && (isdefined(entity.warlordaggressivemode) && entity.warlordaggressivemode)))
		{
			preferedpoints = WarlordServerUtils::GetPreferedValidPoints(entity);
		}
		if(randompoints.size == 0 && preferedpoints.size == 0)
		{
			if(bpointsavailable == 0)
			{
				return 0;
				break;
			}
			if(bpointsingoal == 0)
			{
				searchoriginongoalradius = entity.goalpos + VectorNormalize(searchOrigin - entity.goalpos) * entity.goalRadius;
				queryResult = PositionQuery_Source_Navigation(searchoriginongoalradius, 0, entity.engageMaxDist, 45, 72, entity, 108);
				PositionQuery_Filter_InClaimedLocation(queryResult, entity);
				PositionQuery_Filter_DistanceToGoal(queryResult, entity);
				bpointsavailable = 0;
				bpointsingoal = 0;
				bpointsvisible = 0;
				foreach(point in queryResult.data)
				{
					if(point.inclaimedlocation)
					{
						continue;
					}
					bpointsavailable++;
					if(point.distToGoal > 0)
					{
						continue;
					}
					bpointsingoal++;
					if(isdefined(point.visibility) && !point.visibility)
					{
						continue;
					}
					bpointsvisible++;
					if(point.distToOrigin2D < closepointdistance)
					{
						continue;
					}
					randompoints[randompoints.size] = point.origin;
				}
				if(randompoints.size == 0)
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
						if(bpointsvisible > 0 && isdefined(point.visibility) && !point.visibility)
						{
							continue;
						}
						randompoints[randompoints.size] = point.origin;
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
				if(bpointsvisible > 0 && isdefined(point.visibility) && !point.visibility)
				{
					continue;
				}
				randompoints[randompoints.size] = point.origin;
			}
			if(randompoints.size == 0)
			{
				if(!bapproachinggoal)
				{
					if(!isdefined(randompoints))
					{
						randompoints = [];
					}
					else if(!IsArray(randompoints))
					{
						randompoints = Array(randompoints);
					}
					randompoints[randompoints.size] = entity.goalpos;
				}
				else
				{
					warlorddebughelpers::setstatefailed(entity, 5);
					return 0;
				}
				/#
				#/
			}
		}
		goalweight = -10000;
		engageminfalloffdistsqrd = entity.engageminfalloffdist * entity.engageminfalloffdist;
		engagemindistsqrd = entity.engageMinDist * entity.engageMinDist;
		engagemaxdistsqrd = entity.engageMaxDist * entity.engageMaxDist;
		engagemaxfalloffdistsqrd = entity.engagemaxfalloffdist * entity.engagemaxfalloffdist;
		if(isdefined(entity.enemy) && IsSentient(entity.enemy))
		{
			enemyForward = VectorNormalize(AnglesToForward(entity.enemy.angles));
		}
		for(index = 0; index < randompoints.size; index++)
		{
			distancesqrdtoenemy = Distance2DSquared(randompoints[index], searchOrigin);
			bweightsign = 1;
			if(isdefined(istrackingenemylastpos) || (isdefined(entity.warlordaggressivemode) && entity.warlordaggressivemode))
			{
				bweightsign = -1;
			}
			pointweight = 0;
			if(distancesqrdtoenemy < engageminfalloffdistsqrd)
			{
				pointweight = -1 * bweightsign;
			}
			else if(distancesqrdtoenemy < engagemindistsqrd)
			{
				pointweight = -0.5 * bweightsign;
			}
			else if(distancesqrdtoenemy > engagemaxfalloffdistsqrd)
			{
				pointweight = 1 * bweightsign;
			}
			else if(distancesqrdtoenemy > engagemaxdistsqrd)
			{
				pointweight = 1 * bweightsign;
			}
			if(isdefined(enemyForward))
			{
				anglefromforward = ACos(math::clamp(VectorDot(VectorNormalize(pointweight - entity.enemy.origin), enemyForward), -1, 1));
				if(anglefromforward > 80)
				{
					pointweight = pointweight + -0.5;
				}
			}
			pointweight = pointweight + RandomFloatRange(-0.25, 0.25);
			if(goalweight < pointweight)
			{
				goalweight = pointweight;
				goalPosition = randompoints[index];
			}
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0 && isdefined(GetEntByNum(GetDvarInt("Dev Block strings are not supported"))) && entity == GetEntByNum(GetDvarInt("Dev Block strings are not supported")))
				{
					as_debug::debugdrawweightedpoint(entity, randompoints[index], pointweight, -1.25, 1.75);
				}
			#/
		}
		normalpointsmaxgoalweight = goalweight;
		foreach(point in preferedpoints)
		{
			if(point === entity.previous_prefered_point)
			{
				continue;
			}
			pointweight = RandomFloatRange(normalpointsmaxgoalweight - 0.25, normalpointsmaxgoalweight + 0.5);
			if(goalweight < pointweight)
			{
				goalweight = pointweight;
				goalPosition = point.origin;
				preferedpoint = point;
			}
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0 && isdefined(GetEntByNum(GetDvarInt("Dev Block strings are not supported"))) && entity == GetEntByNum(GetDvarInt("Dev Block strings are not supported")))
				{
					as_debug::debugdrawweightedpoint(entity, point.origin, pointweight, -1.25, 1.75);
				}
			#/
		}
		if(isdefined(goalPosition))
		{
			if(entity FindPath(entity.origin, goalPosition, 1, 0))
			{
				entity UsePosition(goalPosition);
				entity.nextfindbetterpositiontime = GetTime() + entity.coverSearchInterval;
				if(isdefined(preferedpoint))
				{
					/#
						warlorddebughelpers::setcurrentstate(entity, 4);
					#/
					WarlordServerUtils::SetPreferedPoint(entity, preferedpoint);
				}
				/#
					if(!isdefined(preferedpoint))
					{
						warlorddebughelpers::setcurrentstate(entity, 5);
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
	return GetTime() >= behaviorTreeEntity.nextexposedpain;
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
	behaviorTreeEntity.nextexposedpain = GetTime() + randomIntRange(500, 2500);
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
	if(isdefined(behaviorTreeEntity.nextangrytime) && GetTime() < behaviorTreeEntity.nextangrytime)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.knownattackers) || behaviorTreeEntity.knownattackers.size == 0)
	{
		return 0;
	}
	else if(behaviorTreeEntity.knownattackers.size == 1 && isdefined(behaviorTreeEntity.enemy) && behaviorTreeEntity.knownattackers[0].attacker == behaviorTreeEntity.enemy)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.accumilateddamage) && behaviorTreeEntity.accumilateddamage > WarlordServerUtils::GetScaledForPlayers(200, 1.5, 2, 2.5))
	{
		return 1;
	}
	return behaviorTreeEntity.isangryattack;
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
		warlorddebughelpers::printstate(1, (0, 1, 0), "Dev Block strings are not supported");
	#/
	entity.isangryattack = 1;
	entity.forcefire = 1;
	entity.accumilateddamage = 0;
	entity.nextangrytime = GetTime() + 13000;
	WarlordServerUtils::UpdateAttackersList(entity);
	attackersArray = [];
	for(i = 0; i < entity.knownattackers.size; i++)
	{
		for(j = i + 1; j < entity.knownattackers.size; j++)
		{
			if(entity.knownattackers[i].threat < entity.knownattackers[j].threat)
			{
				tmp = entity.knownattackers[j].threat;
				entity.knownattackers[j].threat = entity.knownattackers[i].threat;
				entity.knownattackers[i].threat = tmp;
			}
		}
	}
	foreach(data in entity.knownattackers)
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
	entity notify("angry_attack");
	shoottime = GetDvarFloat("warlordangryattack", 3);
	foreach(attacker in attackersArray)
	{
		if(isdefined(attacker))
		{
			entity ai::shoot_at_target("normal", attacker, undefined, shoottime, undefined, 1);
		}
	}
	/#
		warlorddebughelpers::printstate(1, (0, 0, 1), "Dev Block strings are not supported");
	#/
	entity.forcefire = 0;
	entity.isangryattack = 0;
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
	entity.warlordaggressivemode = b_aggressive_mode;
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
	if(!isdefined(entity.prefered_points))
	{
		entity.prefered_points = [];
	}
	else if(!IsArray(entity.prefered_points))
	{
		entity.prefered_points = Array(entity.prefered_points);
	}
	entity.prefered_points[entity.prefered_points.size] = point;
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
	if(isdefined(entity.prefered_points))
	{
		points_to_remove = [];
		foreach(point in entity.prefered_points)
		{
			if(point.name === name)
			{
				if(!isdefined(points_to_remove))
				{
					points_to_remove = [];
				}
				else if(!IsArray(points_to_remove))
				{
					points_to_remove = Array(points_to_remove);
				}
				points_to_remove[points_to_remove.size] = point;
			}
		}
		if(points_to_remove.size > 0)
		{
			foreach(point in points_to_remove)
			{
				ArrayRemoveValue(entity.prefered_points, point);
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
	entity.prefered_points = [];
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
	points_to_remove = [];
	foreach(point in entity.prefered_points)
	{
		if(!entity IsPosAtGoal(point.origin))
		{
			if(!isdefined(points_to_remove))
			{
				points_to_remove = [];
			}
			else if(!IsArray(points_to_remove))
			{
				points_to_remove = Array(points_to_remove);
			}
			points_to_remove[points_to_remove.size] = point;
		}
	}
	foreach(point in points_to_remove)
	{
		ArrayRemoveValue(entity.prefered_points, point);
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
	entity.previous_prefered_point = entity.current_prefered_point;
	entity.current_prefered_point = point;
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
		warlorddebughelpers::setcurrentstate(entity, undefined);
	#/
	entity.current_prefered_point_start_time = undefined;
	entity.current_prefered_point_expiration = undefined;
	entity.current_prefered_point = undefined;
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
	if(isdefined(entity.current_prefered_point) && (DistanceSquared(entity.current_prefered_point.origin, entity.origin) < 36 * 36 && Abs(self.current_prefered_point.origin[2] - entity.origin[2]) < 45))
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
	if(!isdefined(entity.current_prefered_point))
	{
		return 0;
	}
	if(AtPreferedPoint(entity))
	{
		return 1;
	}
	if(isdefined(entity.pathGoalPos) && entity.pathGoalPos == entity.current_prefered_point.origin)
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
	if(isdefined(entity.current_prefered_point))
	{
		if(AtPreferedPoint(entity))
		{
			if(isdefined(entity.current_prefered_point_expiration))
			{
				if(GetTime() > entity.current_prefered_point_expiration)
				{
					ClearPreferedPoint(entity);
					return 0;
				}
				return 1;
			}
			else if(isdefined(entity.current_prefered_point.min_duration))
			{
				entity.current_prefered_point_start_time = GetTime();
				if(!isdefined(entity.current_prefered_point.max_duration) || entity.current_prefered_point.max_duration == entity.current_prefered_point.min_duration)
				{
					entity.current_prefered_point_expiration = GetTime() + entity.current_prefered_point.min_duration;
				}
				else
				{
					duration = randomIntRange(entity.current_prefered_point.min_duration, entity.current_prefered_point.max_duration);
					entity.current_prefered_point_expiration = GetTime() + duration;
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
			entity UsePosition(entity.current_prefered_point.origin);
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
	validpoints = [];
	if(isdefined(entity.prefered_points))
	{
		foreach(point in entity.prefered_points)
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
			if(isdefined(entity.enemy) && (isdefined(entity.warlordaggressivemode) && entity.warlordaggressivemode))
			{
				if(!BulletTracePassed(entity GetEye(), entity.enemy.origin + VectorScale((0, 0, 1), 50), 0, entity, entity.enemy))
				{
					continue;
				}
			}
			if(!isdefined(validpoints))
			{
				validpoints = [];
			}
			else if(!IsArray(validpoints))
			{
				validpoints = Array(validpoints);
			}
			validpoints[validpoints.size] = point;
		}
	}
	return validpoints;
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
		locomotiondirection = AiUtility::BB_GetLocomotionFaceEnemyQuadrant();
		if(locomotiondirection == "locomotion_face_enemy_front" || locomotiondirection == "locomotion_face_enemy_back")
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
	if(!isdefined(entity.lasttimetohavecrouchingenemy))
	{
		return 0;
	}
	if(GetTime() - entity.lasttimetohavecrouchingenemy <= 4000)
	{
		return 1;
	}
	entity.lasttimetohavecrouchingenemy = undefined;
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
	entity.lasttimetohavecrouchingenemy = GetTime();
	entity.hascrouchingenemy = 1;
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
	isattackerplayer = isPlayer(attackerInfo.attacker);
	if(isattackerplayer)
	{
		threat = threat * 10;
	}
	distancefromattackersqr = Distance2DSquared(entity.origin, attackerInfo.attacker.origin);
	normalizeddistancefromattacker = 0;
	if(isattackerplayer)
	{
		if(distancefromattackersqr <= 100 * 100)
		{
			threat = threat * 1000;
		}
		else
		{
			normalizeddistancefromattacker = distancefromattackersqr / entity.engagemaxfalloffdist * entity.engagemaxfalloffdist;
			if(normalizeddistancefromattacker > 1)
			{
				normalizeddistancefromattacker = 1;
			}
			normalizeddistancefromattacker = 1 - normalizeddistancefromattacker;
		}
	}
	normalizeddamagefromattacker = attackerInfo.damage / 1000;
	if(normalizeddamagefromattacker > 1)
	{
		normalizeddamagefromattacker = 1;
	}
	threat = threat * normalizeddistancefromattacker * 0.65 + normalizeddamagefromattacker * 0.35 * 100;
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
	if(!isdefined(entity.currentdangerousattacker))
	{
		return 1;
	}
	if(entity.currentdangerousattacker.health <= 0)
	{
		return 1;
	}
	if(entity.currentdangerousattacker == attacker)
	{
		return 0;
	}
	if(GetTime() - entity.lastdangerousattackertime < 1)
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
	if(!isdefined(entity.knownattackers))
	{
		entity.knownattackers = [];
	}
	maxthreat = 0;
	threatcount = 0;
	for(i = 0; i < entity.knownattackers.size; i++)
	{
		attacker = entity.knownattackers[i].attacker;
		if(!isdefined(attacker) || !IsEntity(attacker) || attacker.health <= 0 || GetTime() - entity.knownattackers[i].lastattacktime > 5000)
		{
			ArrayRemoveIndex(entity.knownattackers, i);
			i--;
			continue;
		}
		entity.knownattackers[i].threat = ComputeAttackerThreat(entity, entity.knownattackers[i]);
		if(entity.knownattackers[i].threat > maxthreat)
		{
			maxthreat = entity.knownattackers[i].threat;
			dangerousattackerinfo = entity.knownattackers[i];
		}
	}
	if(isdefined(newAttacker))
	{
		for(i = 0; i < entity.knownattackers.size; i++)
		{
			if(entity.knownattackers[i].attacker == newAttacker)
			{
				attackdata = entity.knownattackers[i];
				attackdata.lastattacktime = GetTime();
				attackdata.damage = attackdata.damage + damage;
				break;
			}
		}
		if(!isdefined(attackdata))
		{
			attackdata = spawnstruct();
			attackdata.attacker = newAttacker;
			attackdata.lastattacktime = GetTime();
			attackdata.damage = damage;
			attackdata.threat = 0;
			if(!isdefined(entity.knownattackers))
			{
				entity.knownattackers = [];
			}
			else if(!IsArray(entity.knownattackers))
			{
				entity.knownattackers = Array(entity.knownattackers);
			}
			entity.knownattackers[entity.knownattackers.size] = attackdata;
		}
		attackdata.threat = ComputeAttackerThreat(entity, attackdata);
		if(attackdata.threat > maxthreat)
		{
			maxthreat = attackdata.threat;
			dangerousattackerinfo = attackdata;
		}
	}
	if(isdefined(dangerousattackerinfo) && maxthreat > 0)
	{
		if(ShouldSwitchToNewThreat(entity, dangerousattackerinfo.attacker, maxthreat))
		{
			thread WarlordDangerousEnemyAttack(entity, dangerousattackerinfo.attacker, maxthreat);
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
	if(!isdefined(entity.knownattackers) || entity.knownattackers.size <= 1)
	{
		return;
	}
	isstandstill = 0;
	if(AtPreferedPoint(entity))
	{
		if(!isdefined(entity.current_prefered_point_start_time) || GetTime() - entity.current_prefered_point_start_time < 1)
		{
			return;
		}
		isstandstill = 1;
	}
	if(!isstandstill)
	{
		if(isdefined(entity.pathGoalPos))
		{
			if(Distance2DSquared(entity.pathGoalPos, entity.origin) < 36 * 36 && Abs(entity.pathGoalPos[2] - entity.origin[2]) < 45)
			{
				isstandstill = 1;
			}
		}
	}
	if(isstandstill)
	{
		if(HaveTooLowToAttackEnemy(entity))
		{
			dangerousattackerscount = 1;
			break;
		}
		dangerousattackerscount = 0;
		foreach(attackerInfo in entity.knownattackers)
		{
			if(attackerInfo.damage > 200)
			{
				dangerousattackerscount++;
			}
		}
		if(dangerousattackerscount > 1)
		{
			ClearPreferedPoint(entity);
			entity.nextfindbetterpositiontime = 0;
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
	entity endon("angry_attack");
	entity notify("dangerous_attack");
	entity endon("dangerous_attack");
	entity.lastdangerousattackertime = GetTime();
	entity.currentdangerousattacker = attacker;
	entity.currentmaxthreat = threat;
	/#
		warlorddebughelpers::printstate(0, (0, 1, 0), "Dev Block strings are not supported");
	#/
	shoottime = GetDvarFloat("warlordangryattack", 3);
	entity ai::shoot_at_target("normal", attacker, undefined, shoottime, undefined, 1);
	entity.currentdangerousattacker = undefined;
	/#
		warlorddebughelpers::printstate(0, (0, 0, 1), "Dev Block strings are not supported");
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
	if(entity.health <= entity.damageheavystatehealth)
	{
		clientfield::set("warlord_damage_state", 2);
	}
	else if(entity.health <= entity.damagestatehealth)
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
		entity.accumilateddamage = iDamage;
	}
	else
	{
		entity.accumilateddamage = entity.accumilateddamage + iDamage;
	}
	warlord_hunt_max_accumilated_damage_var = GetDvarInt("warlordhuntdamage", 350);
	if(entity.accumilateddamage > GetScaledForPlayers(warlord_hunt_max_accumilated_damage_var, 1.5, 2, 2.5))
	{
		self.huntenemytime = GetTime() + 15000;
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
	entity.warlordaggressivemode = 0;
	entity.isangryattack = 0;
	entity.nextexposedpain = 0;
	entity.lastdangerousattackertime = 0;
	entity.currentmaxthreat = 0;
	entity.ignorerunAndgundist = 1;
	entity.combatmode = "no_cover";
	AiUtility::AddAIOverrideDamageCallback(entity, &warlordDamageOverride);
	entity.health = Int(GetScaledForPlayers(entity.health, 2, 2.5, 3));
	entity.fullHealth = entity.health;
	entity.damagestatehealth = Int(entity.fullHealth * 0.5);
	entity.damageheavystatehealth = Int(entity.fullHealth * 0.25);
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
	self endon("killing_repulsor");
	while(1)
	{
		self util::waittill_any("projectile_applyattractor", "play_meleefx");
		PlayFXOnTag("vehicle/fx_quadtank_airburst", self, "tag_origin");
		PlayFXOnTag("vehicle/fx_quadtank_airburst_ground", self, "tag_origin");
		self playsound("wpn_trophy_alert");
		self thread remove_repulsor();
		self notify("killing_repulsor");
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

#namespace warlorddebughelpers;

/*
	Name: printstate
	Namespace: warlorddebughelpers
	Checksum: 0x90CAF4EC
	Offset: 0x5260
	Size: 0x273
	Parameters: 3
	Flags: None
*/
function printstate(State, color, string)
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
				if(!isdefined(self) || !isdefined(self.lastmessage) || self.lastmessage != string)
				{
					self.lastmessage = string;
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
	Name: trystate
	Namespace: warlorddebughelpers
	Checksum: 0x656E1237
	Offset: 0x54E0
	Size: 0x93
	Parameters: 3
	Flags: None
*/
function trystate(entity, State, bchecknew)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(!(isdefined(bchecknew) && isnewstate(entity, State)))
			{
				color = (1, 1, 1);
				entity printstate(State, color);
			}
		}
	#/
}

/*
	Name: setcurrentstate
	Namespace: warlorddebughelpers
	Checksum: 0x51C59591
	Offset: 0x5580
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function setcurrentstate(entity, State, bcanupdate)
{
	if(!isdefined(bcanupdate))
	{
		bcanupdate = 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(!isdefined(bcanupdate) || isnewstate(entity, State))
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
				entity printstate(entity.currentState, color, "Dev Block strings are not supported");
			}
			entity printstate(State, color);
		}
	#/
	entity.currentState = State;
}

/*
	Name: setstatefailed
	Namespace: warlorddebughelpers
	Checksum: 0x5896E1E2
	Offset: 0x56A0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function setstatefailed(entity, State)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			color = (1, 1, 0);
			entity printstate(State, color);
		}
	#/
}

/*
	Name: isnewstate
	Namespace: warlorddebughelpers
	Checksum: 0xDB5AA654
	Offset: 0x5718
	Size: 0x7D
	Parameters: 2
	Flags: None
*/
function isnewstate(entity, State)
{
	bnewstate = 0;
	if(!isdefined(entity.currentState))
	{
		bnewstate = 1;
	}
	else if(!isdefined(State))
	{
		return 0;
	}
	else if(entity.currentState != State)
	{
		bnewstate = 1;
	}
	return bnewstate;
}

