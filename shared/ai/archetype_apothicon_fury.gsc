#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_apothicon_fury_interface;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_selector_table;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie;
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

#namespace apothiconFuryBehavior;

/*
	Name: init
	Namespace: apothiconFuryBehavior
	Checksum: 0xEAE8CB7B
	Offset: 0xB08
	Size: 0x1B3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitApothiconFuryBehaviorsAndASM();
	ApothiconFuryInterface::RegisterApothiconFuryInterfaceAttributes();
	spawner::add_archetype_spawn_function("apothicon_fury", &ApothiconFuryBlackboardInit);
	spawner::add_archetype_spawn_function("apothicon_fury", &zombie_utility::zombieSpawnSetup);
	spawner::add_archetype_spawn_function("apothicon_fury", &ApothiconFurySpawnSetup);
	if(ai::shouldRegisterClientFieldForArchetype("apothicon_fury"))
	{
		clientfield::register("actor", "fury_fire_damage", 15000, GetMinBitCountForNum(7), "counter");
		clientfield::register("actor", "furious_level", 15000, 1, "int");
		clientfield::register("actor", "bamf_land", 15000, 1, "counter");
		clientfield::register("actor", "apothicon_fury_death", 15000, 2, "int");
		clientfield::register("actor", "juke_active", 15000, 1, "int");
	}
}

/*
	Name: InitApothiconFuryBehaviorsAndASM
	Namespace: apothiconFuryBehavior
	Checksum: 0xD5FDB009
	Offset: 0xCC8
	Size: 0x463
	Parameters: 0
	Flags: Private
*/
function private InitApothiconFuryBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconCanJuke", &apothiconCanJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconJukeInit", &apothiconJukeInit);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconPreemptiveJukeService", &apothiconPreemptiveJukeService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconPreemptiveJukePending", &apothiconPreemptiveJukePending);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconPreemptiveJukeDone", &apothiconPreemptiveJukeDone);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconMoveStart", &apothiconMoveStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconMoveUpdate", &apothiconMoveUpdate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconCanMeleeAttack", &apothiconCanMeleeAttack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconShouldMeleeCondition", &apothiconShouldMeleeCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconCanBamf", &apothiconCanBamf);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconCanBamfAfterJuke", &apothiconCanBamfAfterJuke);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconBamfInit", &apothiconBamfInit);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconShouldTauntAtPlayer", &apothiconShouldTauntAtPlayer);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconTauntAtPlayerEvent", &apothiconTauntAtPlayerEvent);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconFuriousModeInit", &apothiconFuriousModeInit);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconKnockdownService", &apothiconKnockdownService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconDeathStart", &apothiconDeathStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("apothiconDeathTerminate", &apothiconDeathTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport@apothicon_fury", &mocompApothiconFuryTeleportInit, undefined, &mocompApothiconFuryTeleportTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_juke@apothicon_fury", &mocompApothiconFuryJukeInit, &mocompApothiconFuryJukeUpdate, &mocompApothiconFuryJukeTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_bamf@apothicon_fury", &mocompApothiconFuryBamfInit, &mocompApothiconFuryBamfUpdate, &mocompApothiconFuryBamfTerminate);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("start_effect", &apothiconBamfOut);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("end_effect", &apothiconBamfIn);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("bamf_land", &apothiconBamfLand);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("start_dissolve", &apothiconDeathDissolve);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("dissolved", &apothiconDeathDissolved);
}

/*
	Name: ApothiconFuryBlackboardInit
	Namespace: apothiconFuryBehavior
	Checksum: 0xBA9F0669
	Offset: 0x1138
	Size: 0x1FB
	Parameters: 0
	Flags: Private
*/
function private ApothiconFuryBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run", undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_apothicon_bamf_distance", undefined, &getBamfMeleeDistance);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_idgun_damage_direction", "back", &BB_IDGunGetDamageDirection);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_variant_type", 0, undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	self AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(self);
	self.___ArchetypeOnAnimscriptedCallback = &ApothiconFuryOnAnimscriptedCallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: ApothiconFurySpawnSetup
	Namespace: apothiconFuryBehavior
	Checksum: 0x3C5AFC7B
	Offset: 0x1340
	Size: 0x163
	Parameters: 0
	Flags: Private
*/
function private ApothiconFurySpawnSetup()
{
	self.entityRadius = 30;
	self.jukeMaxDistance = 1500;
	self.updateSight = 0;
	self AllowPitchAngle(1);
	self SetPitchOrient();
	self PushActors(1);
	self.skipAutoRagdoll = 1;
	AiUtility::AddAIOverrideDamageCallback(self, &apothiconDamageCallback);
	AiUtility::AddAIOverrideKilledCallback(self, &apothiconOnDeath);
	self.zigzag_distance_min = 300;
	self.zigzag_distance_max = 700;
	self.isFurious = 0;
	self.furiousLevel = 0;
	self.nextBamfMeleeTime = GetTime();
	self.nextJukeTime = GetTime();
	self.nextPreemptiveJukeAds = RandomFloatRange(0.7, 0.95);
	blackboard::SetBlackBoardAttribute(self, "_variant_type", randomIntRange(0, 3));
}

/*
	Name: ApothiconFuryOnAnimscriptedCallback
	Namespace: apothiconFuryBehavior
	Checksum: 0x989FEC2E
	Offset: 0x14B0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ApothiconFuryOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ApothiconFuryBlackboardInit();
}

/*
	Name: apothiconDeathDissolve
	Namespace: apothiconFuryBehavior
	Checksum: 0x64760EC8
	Offset: 0x14F0
	Size: 0x131
	Parameters: 1
	Flags: None
*/
function apothiconDeathDissolve(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	a_zombies = GetAIArchetypeArray("zombie");
	a_filtered_zombies = Array::filter(a_zombies, 0, &apothiconZombieEligibleForKnockdown, entity, entity.origin);
	if(a_filtered_zombies.size > 0)
	{
		foreach(zombie in a_filtered_zombies)
		{
			apothiconKnockdownZombie(entity, zombie);
		}
	}
}

/*
	Name: apothiconDeathDissolved
	Namespace: apothiconFuryBehavior
	Checksum: 0xE4AAA393
	Offset: 0x1630
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function apothiconDeathDissolved(entity)
{
}

/*
	Name: mocompApothiconFuryTeleportInit
	Namespace: apothiconFuryBehavior
	Checksum: 0xE9349E80
	Offset: 0x1648
	Size: 0x187
	Parameters: 5
	Flags: Private
*/
function private mocompApothiconFuryTeleportInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity SetRepairPaths(0);
	locomotionSpeed = blackboard::GetBlackBoardAttribute(entity, "_locomotion_speed");
	if(locomotionSpeed == "locomotion_speed_walk")
	{
		rate = 1.6;
	}
	else
	{
		rate = 2;
	}
	entity ASMSetAnimationRate(rate);
	/#
		Assert(isdefined(entity.traverseEndNode));
	#/
	entity animMode("noclip", 0);
	entity notsolid();
	entity.blockingPain = 1;
	entity.useGoalAnimWeight = 1;
	entity.bgbIgnoreFearInHeadlights = 1;
}

/*
	Name: mocompApothiconFuryTeleportTerminate
	Namespace: apothiconFuryBehavior
	Checksum: 0x13A9B20A
	Offset: 0x17D8
	Size: 0xF3
	Parameters: 5
	Flags: Private
*/
function private mocompApothiconFuryTeleportTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(!isdefined(entity.traverseEndNode))
	{
		return;
	}
	entity ForceTeleport(entity.traverseEndNode.origin, entity.angles);
	entity ASMSetAnimationRate(1);
	entity show();
	entity solid();
	entity.blockingPain = 0;
	entity.useGoalAnimWeight = 0;
	entity.bgbIgnoreFearInHeadlights = 0;
}

#namespace AnimationAdjustmentInfoZ;

/*
	Name: __constructor
	Namespace: AnimationAdjustmentInfoZ
	Checksum: 0xBC354E48
	Offset: 0x18D8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.adjustMentStarted = 0;
	self.reAdjustmentStarted = 0;
}

/*
	Name: __destructor
	Namespace: AnimationAdjustmentInfoZ
	Checksum: 0x99EC1590
	Offset: 0x1900
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace apothiconFuryBehavior;

/*
	Name: AnimationAdjustmentInfoZ
	Namespace: apothiconFuryBehavior
	Checksum: 0x8F6A434F
	Offset: 0x1910
	Size: 0x85
	Parameters: 0
	Flags: 6
*/
function private autoexec AnimationAdjustmentInfoZ()
{
	classes.AnimationAdjustmentInfoZ[0] = spawnstruct();
	classes.AnimationAdjustmentInfoZ[0].__vtable[1606033458] = &AnimationAdjustmentInfoZ::__destructor;
	classes.AnimationAdjustmentInfoZ[0].__vtable[-1690805083] = &AnimationAdjustmentInfoZ::__constructor;
}

#namespace AnimationAdjustmentInfoXY;

/*
	Name: __constructor
	Namespace: AnimationAdjustmentInfoXY
	Checksum: 0xAF212837
	Offset: 0x19A0
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.adjustMentStarted = 0;
}

/*
	Name: __destructor
	Namespace: AnimationAdjustmentInfoXY
	Checksum: 0x99EC1590
	Offset: 0x19B8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace apothiconFuryBehavior;

/*
	Name: AnimationAdjustmentInfoXY
	Namespace: apothiconFuryBehavior
	Checksum: 0x6716C03E
	Offset: 0x19C8
	Size: 0x85
	Parameters: 0
	Flags: 6
*/
function private autoexec AnimationAdjustmentInfoXY()
{
	classes.AnimationAdjustmentInfoXY[0] = spawnstruct();
	classes.AnimationAdjustmentInfoXY[0].__vtable[1606033458] = &AnimationAdjustmentInfoXY::__destructor;
	classes.AnimationAdjustmentInfoXY[0].__vtable[-1690805083] = &AnimationAdjustmentInfoXY::__constructor;
}

/*
	Name: mocompApothiconFuryJukeInit
	Namespace: apothiconFuryBehavior
	Checksum: 0x9589D02B
	Offset: 0x1A58
	Size: 0x823
	Parameters: 5
	Flags: None
*/
function mocompApothiconFuryJukeInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.isJuking = 1;
	if(isdefined(entity.jukeInfo))
	{
		entity OrientMode("face angle", entity.jukeInfo.jukeStartAngles);
	}
	else
	{
		entity OrientMode("face angle", entity.angles[1]);
	}
	entity animMode("noclip", 1);
	entity.useGoalAnimWeight = 1;
	entity.blockingPain = 1;
	entity PushActors(0);
	entity.pushable = 0;
	moveDeltaVector = GetMoveDelta(mocompAnim, 0, 1, entity);
	landPos = entity LocalToWorldCoords(moveDeltaVector);
	velocity = entity GetVelocity();
	predictedPos = entity.origin + velocity * 0.1;
	/#
		RecordCircle(landPos, 8, (0, 0, 1), "Dev Block strings are not supported", entity);
		Record3DText("Dev Block strings are not supported" + Distance(predictedPos, landPos), landPos, (0, 0, 1), "Dev Block strings are not supported");
	#/
	landPosOnGround = entity.jukeInfo.landPosOnGround;
	heightDiff = landPosOnGround[2] - landPos[2];
	/#
		RecordCircle(landPosOnGround, 8, (0, 1, 0), "Dev Block strings are not supported", entity);
		recordLine(landPos, landPosOnGround, (0, 1, 0), "Dev Block strings are not supported", entity);
	#/
	/#
		Assert(animhasnotetrack(mocompAnim, "Dev Block strings are not supported"));
	#/
	startTime = getnotetracktimes(mocompAnim, "start_effect")[0];
	vectorToStartTime = GetMoveDelta(mocompAnim, 0, startTime, entity);
	startPos = entity LocalToWorldCoords(vectorToStartTime);
	/#
		Assert(animhasnotetrack(mocompAnim, "Dev Block strings are not supported"));
	#/
	stopTime = getnotetracktimes(mocompAnim, "end_effect")[0];
	vectorToStopTime = GetMoveDelta(mocompAnim, 0, stopTime, entity);
	stopPos = entity LocalToWorldCoords(vectorToStopTime);
	/#
		RecordSphere(startPos, 3, (0, 0, 1), "Dev Block strings are not supported", entity);
		RecordSphere(stopPos, 3, (0, 0, 1), "Dev Block strings are not supported", entity);
		recordLine(predictedPos, startPos, (0, 0, 1), "Dev Block strings are not supported", entity);
		recordLine(startPos, stopPos, (0, 0, 1), "Dev Block strings are not supported", entity);
		recordLine(stopPos, landPos, (0, 0, 1), "Dev Block strings are not supported", entity);
	#/
	newStopPos = stopPos + (0, 0, heightDiff);
	/#
		recordLine(startPos, newStopPos, (1, 1, 0), "Dev Block strings are not supported", entity);
		recordLine(newStopPos, landPosOnGround, (1, 1, 0), "Dev Block strings are not supported", entity);
		RecordSphere(newStopPos, 3, (1, 1, 0), "Dev Block strings are not supported", entity);
	#/
	entity.AnimationAdjustmentInfoZ = undefined;
	__constructor();
	entity.AnimationAdjustmentInfoZ = AnimationAdjustmentInfoZ;
	entity.AnimationAdjustmentInfoZ.startTime = startTime;
	entity.AnimationAdjustmentInfoZ.stopTime = stopTime;
	entity.AnimationAdjustmentInfoZ.enemy = entity.enemy;
	animlength = getanimlength(mocompAnim) * 1000;
	startTime = startTime * animlength;
	stopTime = stopTime * animlength;
	startTime = floor(startTime / 50);
	stopTime = floor(stopTime / 50);
	adjustDuration = stopTime - startTime;
	entity.AnimationAdjustmentInfoZ.stepSize = heightDiff / adjustDuration;
	entity.AnimationAdjustmentInfoZ.landPosOnGround = landPosOnGround;
	/#
		if(heightDiff < 0)
		{
			Record3DText("Dev Block strings are not supported" + Distance(landPos, landPosOnGround) + "Dev Block strings are not supported" + entity.AnimationAdjustmentInfoZ.stepSize + "Dev Block strings are not supported" + adjustDuration, landPosOnGround, (1, 0.5, 0), "Dev Block strings are not supported");
		}
		else
		{
			Record3DText("Dev Block strings are not supported" + Distance(landPos, landPosOnGround) + "Dev Block strings are not supported" + entity.AnimationAdjustmentInfoZ.stepSize + "Dev Block strings are not supported" + adjustDuration, landPosOnGround, (1, 0.5, 0), "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: mocompApothiconFuryJukeUpdate
	Namespace: apothiconFuryBehavior
	Checksum: 0x867838A
	Offset: 0x2288
	Size: 0x223
	Parameters: 5
	Flags: None
*/
function mocompApothiconFuryJukeUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	times = getnotetracktimes(mocompAnim, "end_effect");
	if(times.size)
	{
		time = times[0];
	}
	animtime = entity GetAnimTime(mocompAnim);
	if(!entity.AnimationAdjustmentInfoZ.adjustMentStarted)
	{
		if(animtime >= entity.AnimationAdjustmentInfoZ.startTime)
		{
			entity.AnimationAdjustmentInfoZ.adjustMentStarted = 1;
		}
	}
	if(entity.AnimationAdjustmentInfoZ.adjustMentStarted && animtime < entity.AnimationAdjustmentInfoZ.stopTime)
	{
		adjustedOrigin = entity.origin + (0, 0, entity.AnimationAdjustmentInfoZ.stepSize);
		entity ForceTeleport(adjustedOrigin, entity.angles);
	}
	else if(isdefined(entity.enemy))
	{
		entity OrientMode("face direction", entity.enemy.origin - entity.origin);
	}
	/#
		RecordCircle(entity.AnimationAdjustmentInfoZ.landPosOnGround, 8, (0, 1, 0), "Dev Block strings are not supported", entity);
	#/
}

/*
	Name: mocompApothiconFuryJukeTerminate
	Namespace: apothiconFuryBehavior
	Checksum: 0xA17E420B
	Offset: 0x24B8
	Size: 0x13B
	Parameters: 5
	Flags: None
*/
function mocompApothiconFuryJukeTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 0;
	entity solid();
	entity PushActors(1);
	entity.isJuking = 0;
	entity.useGoalAnimWeight = 0;
	entity.pushable = 1;
	entity.jukeInfo = undefined;
	/#
		RecordCircle(entity.AnimationAdjustmentInfoZ.landPosOnGround, 8, (0, 1, 0), "Dev Block strings are not supported", entity);
	#/
	if(isdefined(entity.enemy))
	{
		entity OrientMode("face direction", entity.enemy.origin - entity.origin);
	}
}

/*
	Name: RunBamfReAdjustmentAnalysis
	Namespace: apothiconFuryBehavior
	Checksum: 0x7CD58A24
	Offset: 0x2600
	Size: 0x9BF
	Parameters: 5
	Flags: Private
*/
function private RunBamfReAdjustmentAnalysis(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	/#
		Assert(isdefined(entity.AnimationAdjustmentInfoZ.adjustMentStarted) && entity.AnimationAdjustmentInfoZ.adjustMentStarted);
	#/
	if(isdefined(entity.AnimationAdjustmentInfoZ.reAdjustmentStarted) && entity.AnimationAdjustmentInfoZ.reAdjustmentStarted)
	{
		return;
	}
	reAdjustMentAnimTime = 0.45;
	animtime = entity GetAnimTime(mocompAnim);
	if(animtime >= reAdjustMentAnimTime && entity.enemy === entity.AnimationAdjustmentInfoZ.enemy)
	{
		meleeStartPosition = entity.AnimationAdjustmentInfoZ.landPosOnGround;
		if(isdefined(entity.enemy.last_valid_position))
		{
			meleeEndPosition = entity.enemy.last_valid_position;
		}
		else
		{
			meleeEndPosition = entity.enemy.origin;
			enemyForwardDir = AnglesToForward(entity.enemy.angles);
			newMeleeEndPosition = meleeEndPosition + enemyForwardDir * randomIntRange(30, 50);
			newMeleeEndPosition = GetClosestPointOnNavMesh(newMeleeEndPosition, 20, 50);
			if(isdefined(newMeleeEndPosition))
			{
				meleeEndPosition = newMeleeEndPosition;
			}
		}
		if(DistanceSquared(meleeStartPosition, meleeEndPosition) < 1024)
		{
			return;
		}
		if(!util::within_fov(meleeEndPosition, entity.enemy.angles, entity.origin, 0.642))
		{
			return;
		}
		if(!util::within_fov(meleeStartPosition, entity.angles, meleeEndPosition, 0.642))
		{
			return;
		}
		if(!IsPointOnNavMesh(meleeStartPosition, entity))
		{
			return;
		}
		if(!IsPointOnNavMesh(meleeEndPosition, entity))
		{
			return;
		}
		if(!TracePassedOnNavMesh(meleeStartPosition, meleeEndPosition, entity.entityRadius))
		{
			return;
		}
		if(!entity FindPath(meleeStartPosition, meleeEndPosition))
		{
			return;
		}
		landPos = entity.AnimationAdjustmentInfoZ.landPosOnGround;
		/#
			RecordCircle(meleeEndPosition, 8, (0, 1, 1), "Dev Block strings are not supported", entity);
			RecordCircle(landPos, 8, (0, 0, 1), "Dev Block strings are not supported", entity);
		#/
		zDiff = landPos[2] - meleeEndPosition[2];
		traceStart = undefined;
		traceEnd = undefined;
		if(zDiff < 0)
		{
			traceOffsetAbove = zDiff * -1 + 30;
			traceStart = meleeEndPosition + (0, 0, traceOffsetAbove);
			traceEnd = meleeEndPosition + VectorScale((0, 0, -1), 70);
		}
		else
		{
			traceOffsetBelow = zDiff * -1 - 30;
			traceStart = meleeEndPosition + VectorScale((0, 0, 1), 70);
			traceEnd = meleeEndPosition + (0, 0, traceOffsetBelow);
		}
		trace = GroundTrace(traceStart, traceEnd, 0, entity, 1, 1);
		landPosOnGround = trace["position"];
		landPosOnGround = GetClosestPointOnNavMesh(landPosOnGround, 100, 50);
		if(!isdefined(landPosOnGround))
		{
			return;
		}
		/#
			RecordCircle(landPosOnGround, 8, (0, 1, 0), "Dev Block strings are not supported", entity);
			recordLine(landPos, landPosOnGround, (0, 1, 0), "Dev Block strings are not supported", entity);
		#/
		/#
			Assert(isdefined(entity.AnimationAdjustmentInfoZ));
		#/
		startTime = reAdjustMentAnimTime;
		stopTime = entity.AnimationAdjustmentInfoZ.stopTime;
		__constructor();
		entity.AnimationAdjustmentInfoZ2 = AnimationAdjustmentInfoZ;
		entity.AnimationAdjustmentInfoZ2.startTime = reAdjustMentAnimTime;
		entity.AnimationAdjustmentInfoZ2.stopTime = stopTime;
		entity.AnimationAdjustmentInfoZ2.landPosOnGround = landPosOnGround;
		animlength = getanimlength(mocompAnim) * 1000;
		startTime = startTime * animlength;
		stopTime = stopTime * animlength;
		startTime = floor(startTime / 50);
		stopTime = floor(stopTime / 50);
		adjustDuration = stopTime - startTime;
		heightDiff = landPosOnGround[2] - landPos[2];
		entity.AnimationAdjustmentInfoZ2.stepSize = heightDiff / adjustDuration;
		/#
			if(heightDiff < 0)
			{
				Record3DText("Dev Block strings are not supported" + entity.AnimationAdjustmentInfoZ2.stepSize + "Dev Block strings are not supported" + adjustDuration, landPosOnGround, (1, 0.5, 0), "Dev Block strings are not supported");
			}
			else
			{
				Record3DText("Dev Block strings are not supported" + entity.AnimationAdjustmentInfoZ2.stepSize + "Dev Block strings are not supported" + adjustDuration, landPosOnGround, (1, 0.5, 0), "Dev Block strings are not supported");
			}
		#/
		meleeEndPosition = (meleeEndPosition[0], meleeEndPosition[1], landPos[2]);
		xyDirection = VectorNormalize(meleeEndPosition - landPos);
		xyDistance = Distance(meleeEndPosition, landPos);
		__constructor();
		entity.AnimationAdjustmentInfoXY = AnimationAdjustmentInfoXY;
		entity.AnimationAdjustmentInfoXY.startTime = startTime;
		entity.AnimationAdjustmentInfoXY.stopTime = stopTime;
		entity.AnimationAdjustmentInfoXY.stepSize = xyDistance / adjustDuration;
		entity.AnimationAdjustmentInfoXY.xyDirection = xyDirection;
		entity.AnimationAdjustmentInfoXY.adjustMentStarted = 1;
		/#
			Record3DText("Dev Block strings are not supported" + xyDistance + "Dev Block strings are not supported" + entity.AnimationAdjustmentInfoXY.stepSize + "Dev Block strings are not supported", meleeEndPosition, (0, 0, 1), "Dev Block strings are not supported");
		#/
		entity.AnimationAdjustmentInfoZ.reAdjustmentStarted = 1;
	}
}

/*
	Name: mocompApothiconFuryBamfInit
	Namespace: apothiconFuryBehavior
	Checksum: 0x52BD3B23
	Offset: 0x2FC8
	Size: 0xA83
	Parameters: 5
	Flags: None
*/
function mocompApothiconFuryBamfInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	/#
		Assert(isdefined(entity.enemy));
	#/
	entity.AnimationAdjustmentInfoZ = undefined;
	entity.AnimationAdjustmentInfoZ2 = undefined;
	entity.AnimationAdjustmentInfoXY = undefined;
	entity clearPath();
	entity PathMode("dont move");
	entity.blockingPain = 1;
	entity.useGoalAnimWeight = 1;
	self PushActors(0);
	entity.isBamfing = 1;
	entity.pushable = 0;
	anglesToEnemy = (0, VectorToAngles(entity.enemy.origin - entity.origin)[1], 0);
	entity ForceTeleport(entity.origin, anglesToEnemy);
	entity OrientMode("face angle", anglesToEnemy[1]);
	entity animMode("noclip", 1);
	moveDeltaVector = GetMoveDelta(mocompAnim, 0, 1, entity);
	landPos = entity LocalToWorldCoords(moveDeltaVector);
	/#
		RecordCircle(entity.enemy.origin, 8, (0, 1, 1), "Dev Block strings are not supported", entity);
		recordLine(landPos, entity.enemy.origin, (0, 1, 1), "Dev Block strings are not supported", entity);
		RecordCircle(landPos, 8, (0, 0, 1), "Dev Block strings are not supported", entity);
		Record3DText("Dev Block strings are not supported" + Distance(entity.origin, landPos), landPos, (0, 0, 1), "Dev Block strings are not supported");
	#/
	zDiff = entity.origin[2] - entity.enemy.origin[2];
	traceStart = undefined;
	traceEnd = undefined;
	if(zDiff < 0)
	{
		traceOffsetAbove = zDiff * -1 + 30;
		traceStart = landPos + (0, 0, traceOffsetAbove);
		traceEnd = landPos + VectorScale((0, 0, -1), 70);
	}
	else
	{
		traceOffsetBelow = zDiff * -1 - 30;
		traceStart = landPos + VectorScale((0, 0, 1), 70);
		traceEnd = landPos + (0, 0, traceOffsetBelow);
	}
	trace = GroundTrace(traceStart, traceEnd, 0, entity, 1, 1);
	landPosOnGround = trace["position"];
	landPosOnGround = GetClosestPointOnNavMesh(landPosOnGround, 100, 25);
	if(!isdefined(landPosOnGround))
	{
		landPosOnGround = entity.enemy.origin;
	}
	/#
		RecordCircle(landPosOnGround, 8, (0, 1, 0), "Dev Block strings are not supported", entity);
		recordLine(landPos, landPosOnGround, (0, 1, 0), "Dev Block strings are not supported", entity);
	#/
	heightDiff = landPosOnGround[2] - landPos[2];
	/#
		Assert(animhasnotetrack(mocompAnim, "Dev Block strings are not supported"));
	#/
	startTime = getnotetracktimes(mocompAnim, "start_effect")[0];
	vectorToStartTime = GetMoveDelta(mocompAnim, 0, startTime, entity);
	startPos = entity LocalToWorldCoords(vectorToStartTime);
	/#
		Assert(animhasnotetrack(mocompAnim, "Dev Block strings are not supported"));
	#/
	stopTime = getnotetracktimes(mocompAnim, "end_effect")[0];
	vectorToStopTime = GetMoveDelta(mocompAnim, 0, stopTime, entity);
	stopPos = entity LocalToWorldCoords(vectorToStopTime);
	/#
		RecordSphere(startPos, 3, (0, 0, 1), "Dev Block strings are not supported", entity);
		RecordSphere(stopPos, 3, (0, 0, 1), "Dev Block strings are not supported", entity);
		recordLine(entity.origin, startPos, (0, 0, 1), "Dev Block strings are not supported", entity);
		recordLine(startPos, stopPos, (0, 0, 1), "Dev Block strings are not supported", entity);
		recordLine(stopPos, landPos, (0, 0, 1), "Dev Block strings are not supported", entity);
	#/
	newStopPos = stopPos + (0, 0, heightDiff);
	/#
		recordLine(startPos, newStopPos, (0, 1, 0), "Dev Block strings are not supported", entity);
		recordLine(newStopPos, landPosOnGround, (0, 1, 0), "Dev Block strings are not supported", entity);
		RecordSphere(newStopPos, 3, (0, 1, 0), "Dev Block strings are not supported", entity);
	#/
	__constructor();
	entity.AnimationAdjustmentInfoZ = AnimationAdjustmentInfoZ;
	entity.AnimationAdjustmentInfoZ.startTime = startTime;
	entity.AnimationAdjustmentInfoZ.stopTime = stopTime;
	entity.AnimationAdjustmentInfoZ.enemy = entity.enemy;
	animlength = getanimlength(mocompAnim) * 1000;
	startTime = startTime * animlength;
	stopTime = stopTime * animlength;
	startTime = floor(startTime / 50);
	stopTime = floor(stopTime / 50);
	adjustDuration = stopTime - startTime;
	entity.AnimationAdjustmentInfoZ.stepSize = heightDiff / adjustDuration;
	entity.AnimationAdjustmentInfoZ.landPosOnGround = landPosOnGround;
	/#
		if(heightDiff < 0)
		{
			Record3DText("Dev Block strings are not supported" + Distance(landPos, landPosOnGround) + "Dev Block strings are not supported" + entity.AnimationAdjustmentInfoZ.stepSize + "Dev Block strings are not supported" + adjustDuration, landPosOnGround, (1, 0.5, 0), "Dev Block strings are not supported");
		}
		else
		{
			Record3DText("Dev Block strings are not supported" + Distance(landPos, landPosOnGround) + "Dev Block strings are not supported" + entity.AnimationAdjustmentInfoZ.stepSize + "Dev Block strings are not supported" + adjustDuration, landPosOnGround, (1, 0.5, 0), "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: mocompApothiconFuryBamfUpdate
	Namespace: apothiconFuryBehavior
	Checksum: 0x40A8A313
	Offset: 0x3A58
	Size: 0x2B3
	Parameters: 5
	Flags: None
*/
function mocompApothiconFuryBamfUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	/#
		Assert(isdefined(entity.AnimationAdjustmentInfoZ));
	#/
	if(!isdefined(entity.enemy))
	{
		return;
	}
	animtime = entity GetAnimTime(mocompAnim);
	if(!entity.AnimationAdjustmentInfoZ.adjustMentStarted)
	{
		if(animtime >= entity.AnimationAdjustmentInfoZ.startTime)
		{
			entity.AnimationAdjustmentInfoZ.adjustMentStarted = 1;
		}
	}
	if(entity.AnimationAdjustmentInfoZ.adjustMentStarted && animtime < entity.AnimationAdjustmentInfoZ.stopTime)
	{
		adjustedOrigin = entity.origin + (0, 0, entity.AnimationAdjustmentInfoZ.stepSize);
		RunBamfReAdjustmentAnalysis(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration);
		if(isdefined(entity.AnimationAdjustmentInfoZ.reAdjustmentStarted) && entity.AnimationAdjustmentInfoZ.reAdjustmentStarted)
		{
			if(isdefined(entity.AnimationAdjustmentInfoZ2))
			{
				adjustedOrigin = adjustedOrigin + (0, 0, entity.AnimationAdjustmentInfoZ2.stepSize);
			}
			if(isdefined(entity.AnimationAdjustmentInfoXY))
			{
				adjustedOrigin = adjustedOrigin + entity.AnimationAdjustmentInfoXY.xyDirection * entity.AnimationAdjustmentInfoXY.stepSize;
			}
		}
		entity ForceTeleport(adjustedOrigin, entity.angles);
	}
	else if(isdefined(entity.enemy))
	{
		entity OrientMode("face direction", entity.enemy.origin - entity.origin);
	}
}

/*
	Name: mocompApothiconFuryBamfTerminate
	Namespace: apothiconFuryBehavior
	Checksum: 0x2B9201A7
	Offset: 0x3D18
	Size: 0x1B3
	Parameters: 5
	Flags: None
*/
function mocompApothiconFuryBamfTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity PathMode("move allowed");
	entity solid();
	entity show();
	entity.blockingPain = 0;
	entity.useGoalAnimWeight = 0;
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("gravity");
	entity.isBamfing = 0;
	entity.pushable = 1;
	self PushActors(1);
	entity.jukeInfo = undefined;
	if(!IsPointOnNavMesh(entity.origin))
	{
		clampToNavmeshLocation = GetClosestPointOnNavMesh(entity.origin, 100, 25);
		if(isdefined(clampToNavmeshLocation))
		{
			entity ForceTeleport(clampToNavmeshLocation);
		}
	}
}

/*
	Name: apothiconCanMeleeAttack
	Namespace: apothiconFuryBehavior
	Checksum: 0x2BB21308
	Offset: 0x3ED8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function apothiconCanMeleeAttack(entity)
{
	return apothiconCanBamf(entity) || apothiconShouldMeleeCondition(entity);
}

/*
	Name: apothiconShouldMeleeCondition
	Namespace: apothiconFuryBehavior
	Checksum: 0xA2BBA148
	Offset: 0x3F20
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function apothiconShouldMeleeCondition(behaviorTreeEntity)
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
	if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin) > 10000)
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
	Name: apothiconCanBamfAfterJuke
	Namespace: apothiconFuryBehavior
	Checksum: 0xAD513294
	Offset: 0x4090
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function apothiconCanBamfAfterJuke(entity)
{
	return apothiconCanBamfInternal(entity);
}

/*
	Name: apothiconCanBamf
	Namespace: apothiconFuryBehavior
	Checksum: 0x1FEA1B65
	Offset: 0x40C0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function apothiconCanBamf(entity)
{
	return apothiconCanBamfInternal(entity);
}

/*
	Name: apothiconCanBamfInternal
	Namespace: apothiconFuryBehavior
	Checksum: 0x4EEF90DF
	Offset: 0x40F0
	Size: 0x4D9
	Parameters: 2
	Flags: None
*/
function apothiconCanBamfInternal(entity, bamfAfterJuke)
{
	if(!isdefined(bamfAfterJuke))
	{
		bamfAfterJuke = 0;
	}
	if(!ai::GetAiAttribute(entity, "can_bamf"))
	{
		return 0;
	}
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(!isPlayer(entity.enemy))
	{
		return 0;
	}
	if(isdefined(entity.juking) && entity.juking)
	{
		return 0;
	}
	if(isdefined(entity.isBamfing) && entity.isBamfing)
	{
		return 0;
	}
	if(!bamfAfterJuke)
	{
		if(GetTime() < entity.nextBamfMeleeTime)
		{
			return 0;
		}
		jukeEvents = blackboard::GetBlackboardEvents("apothicon_fury_bamf");
		tooCloseJukeDistanceSqr = 400 * 400;
		foreach(event in jukeEvents)
		{
			if(Distance2DSquared(entity.origin, event.data.origin) <= tooCloseJukeDistanceSqr)
			{
				return 0;
			}
		}
	}
	/#
		Assert(isdefined(entity.enemy));
	#/
	enemyOrigin = entity.enemy.origin;
	apothiconFurys = GetAIArchetypeArray("apothicon_fury");
	furiesNearPlayer = 0;
	foreach(apothiconFury in apothiconFurys)
	{
		if(DistanceSquared(enemyOrigin, apothiconFury.origin) <= 6400)
		{
			furiesNearPlayer++;
		}
	}
	if(furiesNearPlayer >= 4)
	{
		return 0;
	}
	distanceToEnemySq = DistanceSquared(enemyOrigin, entity.origin);
	distanceMinThresholdSq = 400 * 400;
	if(bamfAfterJuke)
	{
		distanceMinThresholdSq = 250 * 250;
	}
	if(distanceToEnemySq > distanceMinThresholdSq && distanceToEnemySq < 750 * 750)
	{
		if(!util::within_fov(enemyOrigin, entity.enemy.angles, entity.origin, 0.642))
		{
			return 0;
		}
		if(!util::within_fov(entity.origin, entity.angles, enemyOrigin, 0.642))
		{
			return 0;
		}
		meleeStartPosition = entity.origin;
		meleeEndPosition = enemyOrigin;
		if(!IsPointOnNavMesh(meleeStartPosition, entity))
		{
			return 0;
		}
		if(!IsPointOnNavMesh(meleeEndPosition, entity))
		{
			return 0;
		}
		if(!TracePassedOnNavMesh(meleeStartPosition, meleeEndPosition, entity.entityRadius))
		{
			return 0;
		}
		if(!entity FindPath(meleeStartPosition, meleeEndPosition))
		{
			return 0;
		}
		return 1;
	}
	return 0;
}

/*
	Name: getBamfMeleeDistance
	Namespace: apothiconFuryBehavior
	Checksum: 0xC0E1F14E
	Offset: 0x45D8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function getBamfMeleeDistance(entity)
{
	distanceToEnemy = Distance(self.enemy.origin, self.origin);
	return distanceToEnemy;
}

/*
	Name: apothiconBamfInit
	Namespace: apothiconFuryBehavior
	Checksum: 0x95FA6968
	Offset: 0x4628
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function apothiconBamfInit(entity)
{
	jukeInfo = spawnstruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;
	blackboard::AddBlackboardEvent("apothicon_fury_bamf", jukeInfo, 4500);
	if(isdefined(level.nextBamfMeleeTimeMin) && isdefined(level.nextBamfMeleeTimeMax))
	{
		entity.nextBamfMeleeTime = GetTime() + RandomFloatRange(level.nextBamfMeleeTimeMin, level.nextBamfMeleeTimeMax);
	}
	else
	{
		entity.nextBamfMeleeTime = GetTime() + RandomFloatRange(4500, 6000);
	}
}

/*
	Name: apothiconShouldTauntAtPlayer
	Namespace: apothiconFuryBehavior
	Checksum: 0x37F2EEAD
	Offset: 0x4728
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function apothiconShouldTauntAtPlayer(entity)
{
	tauntEvents = blackboard::GetBlackboardEvents("apothicon_fury_taunt");
	if(isdefined(tauntEvents) && tauntEvents.size)
	{
		return 0;
	}
	return 1;
}

/*
	Name: apothiconTauntAtPlayerEvent
	Namespace: apothiconFuryBehavior
	Checksum: 0xE69994ED
	Offset: 0x4780
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function apothiconTauntAtPlayerEvent(entity)
{
	jukeInfo = spawnstruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;
	blackboard::AddBlackboardEvent("apothicon_fury_taunt", jukeInfo, 9500);
}

/*
	Name: BB_IDGunGetDamageDirection
	Namespace: apothiconFuryBehavior
	Checksum: 0x5D2BE2CC
	Offset: 0x4808
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
	Name: apothiconBamfLand
	Namespace: apothiconFuryBehavior
	Checksum: 0xC391199C
	Offset: 0x4840
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function apothiconBamfLand(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	if(isdefined(entity.enemy))
	{
		entity OrientMode("face direction", entity.enemy.origin - entity.origin);
	}
	entity clientfield::increment("bamf_land");
	if(isdefined(entity.enemy) && isPlayer(entity.enemy) && DistanceSquared(entity.enemy.origin, entity.origin) <= 250 * 250)
	{
		entity.enemy DoDamage(25, entity.origin, entity, entity, undefined, "MOD_MELEE");
	}
	PhysicsExplosionSphere(entity.origin, 100, 15, 10);
}

/*
	Name: apothiconMoveStart
	Namespace: apothiconFuryBehavior
	Checksum: 0x15902495
	Offset: 0x49C8
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function apothiconMoveStart(entity)
{
	entity.moveTime = GetTime();
	entity.moveOrigin = entity.origin;
}

/*
	Name: apothiconMoveUpdate
	Namespace: apothiconFuryBehavior
	Checksum: 0xDCF170D
	Offset: 0x4A08
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function apothiconMoveUpdate(entity)
{
	if(isdefined(entity.move_anim_end_time) && GetTime() >= entity.move_anim_end_time)
	{
		entity.move_anim_end_time = undefined;
		return;
	}
	if(!isdefined(entity.missingLegs) && entity.missingLegs && GetTime() - entity.moveTime > 1000)
	{
		distSq = Distance2DSquared(entity.origin, entity.moveOrigin);
		if(distSq < 144)
		{
			if(isdefined(entity.cant_move_cb))
			{
				entity [[entity.cant_move_cb]]();
			}
		}
		else
		{
			entity.cant_move = 0;
		}
		entity.moveTime = GetTime();
		entity.moveOrigin = entity.origin;
	}
}

/*
	Name: apothiconKnockdownService
	Namespace: apothiconFuryBehavior
	Checksum: 0xE5457C01
	Offset: 0x4B48
	Size: 0x209
	Parameters: 1
	Flags: None
*/
function apothiconKnockdownService(entity)
{
	if(isdefined(entity.isJuking) && entity.isJuking)
	{
		return;
	}
	if(isdefined(entity.isBamfing) && entity.isBamfing)
	{
		return;
	}
	velocity = entity GetVelocity();
	predict_time = 0.5;
	predicted_pos = entity.origin + velocity * predict_time;
	move_dist_sq = DistanceSquared(predicted_pos, entity.origin);
	speed = move_dist_sq / predict_time;
	if(speed >= 10)
	{
		a_zombies = GetAIArchetypeArray("zombie");
		a_filtered_zombies = Array::filter(a_zombies, 0, &apothiconZombieEligibleForKnockdown, entity, predicted_pos);
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				apothiconKnockdownZombie(entity, zombie);
			}
		}
	}
}

/*
	Name: apothiconZombieEligibleForKnockdown
	Namespace: apothiconFuryBehavior
	Checksum: 0x529E817E
	Offset: 0x4D60
	Size: 0x1D3
	Parameters: 3
	Flags: Private
*/
function private apothiconZombieEligibleForKnockdown(zombie, thrasher, predicted_pos)
{
	if(zombie.KNOCKDOWN === 1)
	{
		return 0;
	}
	if(isdefined(zombie.missingLegs) && zombie.missingLegs)
	{
		return 0;
	}
	knockdown_dist_sq = 2304;
	dist_sq = DistanceSquared(predicted_pos, zombie.origin);
	if(dist_sq > knockdown_dist_sq)
	{
		return 0;
	}
	origin = thrasher.origin;
	facing_vec = AnglesToForward(thrasher.angles);
	enemy_vec = zombie.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: apothiconKnockdownZombie
	Namespace: apothiconFuryBehavior
	Checksum: 0x9A05AA64
	Offset: 0x4F40
	Size: 0x2B3
	Parameters: 2
	Flags: None
*/
function apothiconKnockdownZombie(entity, zombie)
{
	zombie.KNOCKDOWN = 1;
	zombie.knockdown_type = "knockdown_shoved";
	zombie_to_thrasher = entity.origin - zombie.origin;
	zombie_to_thrasher_2d = VectorNormalize((zombie_to_thrasher[0], zombie_to_thrasher[1], 0));
	zombie_forward = AnglesToForward(zombie.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(zombie.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(zombie_to_thrasher_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		zombie.knockdown_direction = "front";
		zombie.getup_direction = "getup_back";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(zombie_to_thrasher_2d, zombie_right_2d);
		if(dot > 0)
		{
			zombie.knockdown_direction = "right";
			if(math::cointoss())
			{
				zombie.getup_direction = "getup_back";
			}
			else
			{
				zombie.getup_direction = "getup_belly";
			}
		}
		else
		{
			zombie.knockdown_direction = "left";
			zombie.getup_direction = "getup_belly";
		}
	}
	else
	{
		zombie.knockdown_direction = "back";
		zombie.getup_direction = "getup_belly";
	}
}

/*
	Name: apothiconShouldSwitchToFuriousMode
	Namespace: apothiconFuryBehavior
	Checksum: 0x2F7A1DA2
	Offset: 0x5200
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function apothiconShouldSwitchToFuriousMode(entity)
{
	if(!ai::GetAiAttribute(entity, "can_be_furious"))
	{
		return 0;
	}
	if(isdefined(entity.isFurious) && entity.isFurious)
	{
		return 0;
	}
	apothiconFurys = GetAIArchetypeArray("apothicon_fury");
	count = 0;
	foreach(apothiconFury in apothiconFurys)
	{
		if(isdefined(apothiconFury.isFurious) && apothiconFury.isFurious)
		{
			count++;
		}
	}
	if(count >= 1)
	{
		return 0;
	}
	furiousEvents = blackboard::GetBlackboardEvents("apothicon_furious_mode");
	if(!furiousEvents.size && entity.furiousLevel >= 3)
	{
		return 1;
	}
	return 0;
}

/*
	Name: apothiconFuriousModeInit
	Namespace: apothiconFuryBehavior
	Checksum: 0xA45E8CB6
	Offset: 0x5398
	Size: 0x13F
	Parameters: 1
	Flags: None
*/
function apothiconFuriousModeInit(entity)
{
	if(!apothiconShouldSwitchToFuriousMode(entity))
	{
		return;
	}
	furiousInfo = spawnstruct();
	furiousInfo.origin = entity.origin;
	furiousInfo.entity = entity;
	blackboard::AddBlackboardEvent("apothicon_furious_mode", furiousInfo, randomIntRange(5000, 7000));
	entity PushActors(0);
	entity.isFurious = 1;
	blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_super_sprint");
	entity clientfield::set("furious_level", 1);
	entity.health = entity.health * 2;
}

#namespace jukeInfo;

/*
	Name: __constructor
	Namespace: jukeInfo
	Checksum: 0x99EC1590
	Offset: 0x54E0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: jukeInfo
	Checksum: 0x99EC1590
	Offset: 0x54F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace apothiconFuryBehavior;

/*
	Name: jukeInfo
	Namespace: apothiconFuryBehavior
	Checksum: 0x1439F2D3
	Offset: 0x5500
	Size: 0x85
	Parameters: 0
	Flags: 6
*/
function private autoexec jukeInfo()
{
	classes.jukeInfo[0] = spawnstruct();
	classes.jukeInfo[0].__vtable[1606033458] = &jukeInfo::__destructor;
	classes.jukeInfo[0].__vtable[-1690805083] = &jukeInfo::__constructor;
}

/*
	Name: apothiconPreemptiveJukeService
	Namespace: apothiconFuryBehavior
	Checksum: 0x7B68C4DF
	Offset: 0x5590
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function apothiconPreemptiveJukeService(entity)
{
	if(!(isdefined(entity.isFurious) && entity.isFurious))
	{
		return 0;
	}
	if(isdefined(entity.nextJukeTime) && entity.nextJukeTime > GetTime())
	{
		return 0;
	}
	if(isdefined(entity.enemy))
	{
		if(!isPlayer(entity.enemy))
		{
			return 0;
		}
		if(entity.enemy PlayerAds() < entity.nextPreemptiveJukeAds)
		{
			return 0;
		}
	}
	if(apothiconCanJuke(entity))
	{
		entity.apothiconPreemptiveJuke = 1;
	}
}

/*
	Name: apothiconPreemptiveJukePending
	Namespace: apothiconFuryBehavior
	Checksum: 0xAF69401
	Offset: 0x5690
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function apothiconPreemptiveJukePending(entity)
{
	return isdefined(entity.apothiconPreemptiveJuke) && entity.apothiconPreemptiveJuke;
}

/*
	Name: apothiconPreemptiveJukeDone
	Namespace: apothiconFuryBehavior
	Checksum: 0x4DCF272B
	Offset: 0x56C8
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function apothiconPreemptiveJukeDone(entity)
{
	entity.apothiconPreemptiveJuke = 0;
}

/*
	Name: apothiconCanJuke
	Namespace: apothiconFuryBehavior
	Checksum: 0x2052786D
	Offset: 0x56F0
	Size: 0x379
	Parameters: 1
	Flags: None
*/
function apothiconCanJuke(entity)
{
	if(!ai::GetAiAttribute(entity, "can_juke"))
	{
		return 0;
	}
	if(!isdefined(entity.enemy) || !isPlayer(entity.enemy))
	{
		return 0;
	}
	if(isdefined(entity.isJuking) && entity.isJuking)
	{
		return 0;
	}
	if(isdefined(entity.apothiconPreemptiveJuke) && entity.apothiconPreemptiveJuke)
	{
		return 1;
	}
	if(isdefined(entity.nextJukeTime) && GetTime() < entity.nextJukeTime)
	{
		return 0;
	}
	jukeEvents = blackboard::GetBlackboardEvents("apothicon_fury_juke");
	tooCloseJukeDistanceSqr = 250 * 250;
	foreach(event in jukeEvents)
	{
		if(Distance2DSquared(entity.origin, event.data.origin) <= tooCloseJukeDistanceSqr)
		{
			return 0;
		}
	}
	if(Distance2DSquared(entity.origin, entity.enemy.origin) < 250 * 250)
	{
		return 0;
	}
	if(!util::within_fov(entity.enemy.origin, entity.enemy.angles, entity.origin, 0.642))
	{
		return 0;
	}
	if(!util::within_fov(entity.origin, entity.angles, entity.enemy.origin, 0.642))
	{
		return 0;
	}
	if(isdefined(entity.jukeMaxDistance) && isdefined(entity.enemy))
	{
		maxDistSquared = entity.jukeMaxDistance * entity.jukeMaxDistance;
		if(Distance2DSquared(entity.origin, entity.enemy.origin) > maxDistSquared)
		{
			return 0;
		}
	}
	jukeInfo = calculateJukeInfo(entity);
	if(isdefined(jukeInfo))
	{
		return 1;
	}
	return 0;
}

/*
	Name: apothiconJukeInit
	Namespace: apothiconFuryBehavior
	Checksum: 0x49F6C65E
	Offset: 0x5A78
	Size: 0x1DB
	Parameters: 1
	Flags: None
*/
function apothiconJukeInit(entity)
{
	jukeInfo = calculateJukeInfo(entity);
	/#
		Assert(isdefined(jukeInfo));
	#/
	blackboard::SetBlackBoardAttribute(entity, "_juke_distance", jukeInfo.jukeDistance);
	blackboard::SetBlackBoardAttribute(entity, "_juke_direction", jukeInfo.jukeDirection);
	entity clearPath();
	entity notify("bhtn_action_notify", "apothicon_fury_juke");
	jukeInfo = spawnstruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;
	blackboard::AddBlackboardEvent("apothicon_fury_juke", jukeInfo, 6000);
	entity.nextPreemptiveJukeAds = RandomFloatRange(0.6, 0.8);
	if(isdefined(level.nextjukeMeleeTimeMin) && isdefined(level.nextjukeMeleeTimeMax))
	{
		entity.nextjukeMeleeTime = GetTime() + RandomFloatRange(level.nextjukeMeleeTimeMin, level.nextjukeMeleeTimeMax);
	}
	else
	{
		entity.nextJukeTime = GetTime() + RandomFloatRange(7000, 10000);
	}
}

/*
	Name: validateJuke
	Namespace: apothiconFuryBehavior
	Checksum: 0x263B8263
	Offset: 0x5C60
	Size: 0x2E3
	Parameters: 3
	Flags: None
*/
function validateJuke(entity, entityRadius, jukeVector)
{
	velocity = entity GetVelocity();
	predictedPos = entity.origin + velocity * 0.1;
	jukeLandPos = predictedPos + jukeVector;
	if(!isdefined(jukeLandPos))
	{
		return undefined;
	}
	traceStart = jukeLandPos + VectorScale((0, 0, 1), 70);
	traceEnd = jukeLandPos + VectorScale((0, 0, -1), 70);
	trace = GroundTrace(traceStart, traceEnd, 0, entity, 1, 1);
	landPosOnGround = trace["position"];
	if(!isdefined(landPosOnGround))
	{
		return undefined;
	}
	if(!IsPointOnNavMesh(landPosOnGround))
	{
		return undefined;
	}
	/#
		recordLine(entity.origin, predictedPos, (0, 1, 0), "Dev Block strings are not supported", entity);
	#/
	/#
		RecordSphere(jukeLandPos, 2, (1, 0, 0), "Dev Block strings are not supported", entity);
	#/
	/#
		recordLine(predictedPos, jukeLandPos, (1, 0, 0), "Dev Block strings are not supported", entity);
	#/
	if(IsPointOnNavMesh(landPosOnGround, entity.entityRadius * 2.5) && TracePassedOnNavMesh(predictedPos, landPosOnGround, entity.entityRadius))
	{
		if(!entity IsPosInClaimedLocation(landPosOnGround) && entity MayMoveFromPointToPoint(predictedPos, landPosOnGround, 0, 0))
		{
			/#
				RecordSphere(landPosOnGround, 2, (0, 1, 0), "Dev Block strings are not supported", entity);
			#/
			/#
				recordLine(predictedPos, landPosOnGround, (0, 1, 0), "Dev Block strings are not supported", entity);
			#/
			return landPosOnGround;
		}
	}
	return undefined;
}

/*
	Name: getJukeVector
	Namespace: apothiconFuryBehavior
	Checksum: 0x5C33436
	Offset: 0x5F50
	Size: 0xB3
	Parameters: 2
	Flags: Private
*/
function private getJukeVector(entity, jukeAnimAlias)
{
	jukeAnim = entity AnimMappingSearch(istring(jukeAnimAlias));
	localDeltaVector = GetMoveDelta(jukeAnim, 0, 1, entity);
	endPoint = entity LocalToWorldCoords(localDeltaVector);
	return endPoint - entity.origin;
}

/*
	Name: calculateJukeInfo
	Namespace: apothiconFuryBehavior
	Checksum: 0x26F833FA
	Offset: 0x6010
	Size: 0x53F
	Parameters: 1
	Flags: Private
*/
function private calculateJukeInfo(entity)
{
	if(isdefined(entity.jukeInfo))
	{
		return entity.jukeInfo;
	}
	directionToEnemy = VectorNormalize(entity.enemy.origin - entity.origin);
	forwardDir = AnglesToForward(entity.angles);
	possibleJukes = [];
	jukeValidDistanceType = [];
	entityRadius = entity.entityRadius;
	jukeVector = getJukeVector(entity, "anim_zombie_juke_left_long");
	landPosOnGround = validateJuke(entity, entityRadius, jukeVector);
	if(isdefined(landPosOnGround))
	{
		__constructor();
		jukeInfo = jukeInfo;
		jukeInfo.jukeDirection = "left";
		jukeInfo.jukeDistance = "long";
		jukeInfo.landPosOnGround = landPosOnGround;
		if(!isdefined(possibleJukes))
		{
			possibleJukes = [];
		}
		else if(!IsArray(possibleJukes))
		{
			possibleJukes = Array(possibleJukes);
		}
		possibleJukes[possibleJukes.size] = jukeInfo;
	}
	jukeVector = getJukeVector(entity, "anim_zombie_juke_right_long");
	landPosOnGround = validateJuke(entity, entityRadius, jukeVector);
	if(isdefined(landPosOnGround))
	{
		__constructor();
		jukeInfo = jukeInfo;
		jukeInfo.jukeDirection = "right";
		jukeInfo.jukeDistance = "long";
		jukeInfo.landPosOnGround = landPosOnGround;
		if(!isdefined(possibleJukes))
		{
			possibleJukes = [];
		}
		else if(!IsArray(possibleJukes))
		{
			possibleJukes = Array(possibleJukes);
		}
		possibleJukes[possibleJukes.size] = jukeInfo;
	}
	jukeVector = getJukeVector(entity, "anim_zombie_juke_left_front_long");
	landPosOnGround = validateJuke(entity, entityRadius, jukeVector);
	if(isdefined(landPosOnGround))
	{
		__constructor();
		jukeInfo = jukeInfo;
		jukeInfo.jukeDirection = "left_front";
		jukeInfo.jukeDistance = "long";
		jukeInfo.landPosOnGround = landPosOnGround;
		if(!isdefined(possibleJukes))
		{
			possibleJukes = [];
		}
		else if(!IsArray(possibleJukes))
		{
			possibleJukes = Array(possibleJukes);
		}
		possibleJukes[possibleJukes.size] = jukeInfo;
	}
	jukeVector = getJukeVector(entity, "anim_zombie_juke_right_front_long");
	landPosOnGround = validateJuke(entity, entityRadius, jukeVector);
	if(isdefined(landPosOnGround))
	{
		__constructor();
		jukeInfo = jukeInfo;
		jukeInfo.jukeDirection = "right_front";
		jukeInfo.jukeDistance = "long";
		jukeInfo.landPosOnGround = landPosOnGround;
		if(!isdefined(possibleJukes))
		{
			possibleJukes = [];
		}
		else if(!IsArray(possibleJukes))
		{
			possibleJukes = Array(possibleJukes);
		}
		possibleJukes[possibleJukes.size] = jukeInfo;
	}
	if(possibleJukes.size)
	{
		jukeInfo = Array::random(possibleJukes);
		jukeInfo.jukeStartAngles = entity.angles;
		entity.lastJukeInfoUpdateTime = GetTime();
		entity.jukeInfo = jukeInfo;
		return jukeInfo;
	}
	return undefined;
}

/*
	Name: apothiconBamfOut
	Namespace: apothiconFuryBehavior
	Checksum: 0xA0A94412
	Offset: 0x6558
	Size: 0x181
	Parameters: 1
	Flags: None
*/
function apothiconBamfOut(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	entity ghost();
	entity notsolid();
	self clientfield::set("juke_active", 0);
	a_zombies = GetAIArchetypeArray("zombie");
	a_filtered_zombies = Array::filter(a_zombies, 0, &apothiconZombieEligibleForKnockdown, entity, entity.origin);
	if(a_filtered_zombies.size > 0)
	{
		foreach(zombie in a_filtered_zombies)
		{
			apothiconKnockdownZombie(entity, zombie);
		}
	}
}

/*
	Name: apothiconBamfIn
	Namespace: apothiconFuryBehavior
	Checksum: 0xFE1494FB
	Offset: 0x66E8
	Size: 0x299
	Parameters: 1
	Flags: None
*/
function apothiconBamfIn(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	if(isdefined(entity.traverseEndNode))
	{
		entity ForceTeleport(entity.traverseEndNode.origin, entity.angles);
		entity Unlink();
		entity.isTraveling = 0;
		entity notify("travel_complete");
		entity SetRepairPaths(1);
		entity.blockingPain = 0;
		entity.useGoalAnimWeight = 0;
		entity.bgbIgnoreFearInHeadlights = 0;
		entity ASMSetAnimationRate(1);
		entity finishtraversal();
		entity animMode("gravity", 1);
	}
	entity show();
	entity solid();
	self clientfield::set("juke_active", 1);
	a_zombies = GetAIArchetypeArray("zombie");
	a_filtered_zombies = Array::filter(a_zombies, 0, &apothiconZombieEligibleForKnockdown, entity, entity.origin);
	if(a_filtered_zombies.size > 0)
	{
		foreach(zombie in a_filtered_zombies)
		{
			apothiconKnockdownZombie(entity, zombie);
		}
	}
}

/*
	Name: apothiconDeathStart
	Namespace: apothiconFuryBehavior
	Checksum: 0xA5C82BB0
	Offset: 0x6990
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function apothiconDeathStart(entity)
{
	entity SetModel("c_zom_dlc4_apothicon_fury_dissolve");
	entity clientfield::set("apothicon_fury_death", 2);
	entity notsolid();
}

/*
	Name: apothiconDeathTerminate
	Namespace: apothiconFuryBehavior
	Checksum: 0xF2A9C16
	Offset: 0x6A00
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function apothiconDeathTerminate(entity)
{
}

/*
	Name: apothiconDamageClientFieldUpdate
	Namespace: apothiconFuryBehavior
	Checksum: 0x9C467609
	Offset: 0x6A18
	Size: 0x21B
	Parameters: 2
	Flags: None
*/
function apothiconDamageClientFieldUpdate(entity, sHitLoc)
{
	increment = 0;
	if(IsInArray(Array("helmet", "head", "neck"), sHitLoc))
	{
		increment = 1;
	}
	else if(IsInArray(Array("torso_upper", "torso_mid"), sHitLoc))
	{
		increment = 2;
	}
	else if(IsInArray(Array("torso_lower"), sHitLoc))
	{
		increment = 3;
	}
	else if(IsInArray(Array("right_arm_upper", "right_arm_lower", "right_hand", "gun"), sHitLoc))
	{
		increment = 4;
	}
	else if(IsInArray(Array("left_arm_upper", "left_arm_lower", "left_hand"), sHitLoc))
	{
		increment = 5;
	}
	else if(IsInArray(Array("left_leg_upper", "left_leg_lower", "left_foot"), sHitLoc))
	{
		increment = 7;
	}
	else
	{
		increment = 6;
	}
	entity clientfield::increment("fury_fire_damage", increment);
}

/*
	Name: apothiconDamageCallback
	Namespace: apothiconFuryBehavior
	Checksum: 0xC3C3E5FA
	Offset: 0x6C40
	Size: 0x11F
	Parameters: 13
	Flags: None
*/
function apothiconDamageCallback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName)
{
	if(!(isdefined(self.zombie_think_done) && self.zombie_think_done))
	{
		return 0;
	}
	if(isdefined(eAttacker) && isPlayer(eAttacker) && isdefined(sHitLoc))
	{
		apothiconDamageClientFieldUpdate(self, sHitLoc);
	}
	if(isdefined(sHitLoc))
	{
		if(!(isdefined(self.isFurious) && self.isFurious))
		{
			self.furiousLevel = self.furiousLevel + 1;
		}
	}
	eAttacker zombie_utility::show_hit_marker();
	return iDamage;
}

/*
	Name: apothiconOnDeath
	Namespace: apothiconFuryBehavior
	Checksum: 0xC2EE274F
	Offset: 0x6D68
	Size: 0x7F
	Parameters: 8
	Flags: None
*/
function apothiconOnDeath(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTimes)
{
	self clientfield::set("apothicon_fury_death", 1);
	self notsolid();
	return damage;
}

#namespace ApothiconFuryBehaviorInterface;

/*
	Name: moveSpeedAttributeCallback
	Namespace: ApothiconFuryBehaviorInterface
	Checksum: 0xA8A8F42D
	Offset: 0x6DF0
	Size: 0x129
	Parameters: 4
	Flags: None
*/
function moveSpeedAttributeCallback(entity, attribute, oldValue, value)
{
	if(isdefined(entity.isFurious) && entity.isFurious)
	{
		return;
	}
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
		case "super_sprint":
		{
			blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_super_sprint");
			break;
		}
		case default:
		{
			break;
		}
	}
}

