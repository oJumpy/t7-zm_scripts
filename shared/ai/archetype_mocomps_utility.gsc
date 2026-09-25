#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;

#namespace archetype_mocomps_utility;

/*
	Name: RegisterDefaultAnimationMocomps
	Namespace: archetype_mocomps_utility
	Checksum: 0x36894620
	Offset: 0x290
	Size: 0xAB
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterDefaultAnimationMocomps()
{
	AnimationStateNetwork::RegisterAnimationMocomp("adjust_to_cover", &mocompAdjustToCoverInit, &mocompAdjustToCoverUpdate, &mocompAdjustToCoverTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("locomotion_explosion_death", &mocompLocoExplosionInit, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_flank_stand", &mocompFlankStandInit, undefined, undefined);
}

/*
	Name: InitAdjustToCoverParams
	Namespace: archetype_mocomps_utility
	Checksum: 0x60266A62
	Offset: 0x348
	Size: 0x693
	Parameters: 0
	Flags: AutoExec
*/
function autoexec InitAdjustToCoverParams()
{
	_AddAdjustToCover("human", "cover_any", "stance_any", 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.9, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8);
	_AddAdjustToCover("human", "cover_stand", "stance_any", 0.4, 0.8, 0.6, 0.4, 0.6, 0.3, 0.3, 0.6, 0.9, 0.6, 0.3, 0.4, 0.7, 0.6, 0.6, 0.6);
	_AddAdjustToCover("human", "cover_crouch", "stance_any", 0.4, 0.4, 0.4, 0.4, 0.8, 0.5, 0.2, 0.7, 0.9, 0.4, 0.2, 0.4, 0.5, 0.5, 0.5, 0.5);
	_AddAdjustToCover("human", "cover_left", "stand", 0.8, 0.4, 0.4, 0.4, 0.4, 0.7, 0.3, 0.5, 0.8, 0.8, 0.8, 0.9, 0.6, 0.6, 0.4, 0.4);
	_AddAdjustToCover("human", "cover_left", "crouch", 0.8, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.8, 0.8, 0.7, 0.6, 0.6, 0.4, 0.4);
	_AddAdjustToCover("human", "cover_right", "stand", 0.8, 0.4, 0.3, 0.4, 0.6, 0.8, 0.4, 0.4, 0.4, 0.4, 0.3, 0.4, 0.6, 0.6, 0.5, 0.4);
	_AddAdjustToCover("human", "cover_right", "crouch", 0.8, 0.4, 0.2, 0.4, 0.4, 0.7, 0.2, 0.3, 0.3, 0.5, 0.5, 0.7, 0.6, 0.6, 0.5, 0.4);
	_AddAdjustToCover("human", "cover_pillar", "stance_any", 0.8, 0.7, 0.6, 0.7, 0.6, 0.5, 0.4, 0.4, 0.4, 0.6, 0.4, 0.3, 0.7, 0.5, 0.1, 0.7);
	_AddAdjustToCover("robot", "cover_any", "stance_any", 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.6, 0.7, 0.5, 0.5, 0.5, 0.5, 0.4, 0.4, 0.4);
	_AddAdjustToCover("robot", "cover_exposed", "stance_any", 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.9, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8);
}

/*
	Name: _AddAdjustToCover
	Namespace: archetype_mocomps_utility
	Checksum: 0x57FED533
	Offset: 0x9E8
	Size: 0x235
	Parameters: 19
	Flags: Private
*/
function private _AddAdjustToCover(archetype, node, stance, rot2, rot32, rot3, rot36, rot6, rot69, rot9, rot98, rot8, rot87, rot7, rot47, rot4, rot14, rot1, rot21)
{
	if(!isdefined(level.adjustToCover))
	{
		level.adjustToCover = [];
	}
	if(!isdefined(level.adjustToCover[archetype]))
	{
		level.adjustToCover[archetype] = [];
	}
	if(!isdefined(level.adjustToCover[archetype][node]))
	{
		level.adjustToCover[archetype][node] = [];
	}
	directions = [];
	directions[2] = rot2;
	directions[32] = rot32;
	directions[3] = rot3;
	directions[63] = rot36;
	directions[6] = rot6;
	directions[96] = rot69;
	directions[9] = rot9;
	directions[89] = rot98;
	directions[8] = rot8;
	directions[78] = rot87;
	directions[7] = rot7;
	directions[47] = rot47;
	directions[4] = rot4;
	directions[14] = rot14;
	directions[1] = rot1;
	directions[21] = rot21;
	level.adjustToCover[archetype][node][stance] = directions;
}

/*
	Name: _GetAdjustToCoverRotation
	Namespace: archetype_mocomps_utility
	Checksum: 0xF2DA7E91
	Offset: 0xC28
	Size: 0x3ED
	Parameters: 4
	Flags: Private
*/
function private _GetAdjustToCoverRotation(archetype, node, stance, angleToNode)
{
	/#
		Assert(IsArray(level.adjustToCover[archetype]));
	#/
	if(!isdefined(level.adjustToCover[archetype][node]))
	{
		node = "cover_any";
	}
	/#
		Assert(IsArray(level.adjustToCover[archetype][node]));
	#/
	if(!isdefined(level.adjustToCover[archetype][node][stance]))
	{
		stance = "stance_any";
	}
	/#
		Assert(IsArray(level.adjustToCover[archetype][node][stance]));
	#/
	/#
		Assert(angleToNode >= 0 && angleToNode < 360);
	#/
	direction = undefined;
	if(angleToNode < 11.25)
	{
		direction = 2;
	}
	else if(angleToNode < 33.75)
	{
		direction = 32;
	}
	else if(angleToNode < 56.25)
	{
		direction = 3;
	}
	else if(angleToNode < 78.75)
	{
		direction = 63;
	}
	else if(angleToNode < 101.25)
	{
		direction = 6;
	}
	else if(angleToNode < 123.75)
	{
		direction = 96;
	}
	else if(angleToNode < 146.25)
	{
		direction = 9;
	}
	else if(angleToNode < 168.75)
	{
		direction = 89;
	}
	else if(angleToNode < 191.25)
	{
		direction = 8;
	}
	else if(angleToNode < 213.75)
	{
		direction = 78;
	}
	else if(angleToNode < 236.25)
	{
		direction = 7;
	}
	else if(angleToNode < 258.75)
	{
		direction = 47;
	}
	else if(angleToNode < 281.25)
	{
		direction = 4;
	}
	else if(angleToNode < 303.75)
	{
		direction = 14;
	}
	else if(angleToNode < 326.25)
	{
		direction = 1;
	}
	else if(angleToNode < 348.75)
	{
		direction = 21;
	}
	else
	{
		direction = 2;
	}
	/#
		Assert(isdefined(level.adjustToCover[archetype][node][stance][direction]));
	#/
	adjustTime = level.adjustToCover[archetype][node][stance][direction];
	if(isdefined(adjustTime))
	{
		return adjustTime;
	}
	return 0.8;
}

/*
	Name: debugLocoExplosion
	Namespace: archetype_mocomps_utility
	Checksum: 0xD8DB1BE4
	Offset: 0x1020
	Size: 0x17F
	Parameters: 1
	Flags: Private
*/
function private debugLocoExplosion(entity)
{
	entity endon("death");
	/#
		startOrigin = entity.origin;
		startYawForward = AnglesToForward((0, entity.angles[1], 0));
		damageYawForward = AnglesToForward((0, entity.damageyaw - entity.angles[1], 0));
		startTime = GetTime();
		while(GetTime() - startTime < 10000)
		{
			RecordSphere(startOrigin, 5, (1, 0, 0), "Dev Block strings are not supported", entity);
			recordLine(startOrigin, startOrigin + startYawForward * 100, (0, 0, 1), "Dev Block strings are not supported", entity);
			recordLine(startOrigin, startOrigin + damageYawForward * 100, (1, 0, 0), "Dev Block strings are not supported", entity);
			wait(0.05);
		}
	#/
}

/*
	Name: mocompFlankStandInit
	Namespace: archetype_mocomps_utility
	Checksum: 0x5D486610
	Offset: 0x11A8
	Size: 0xFB
	Parameters: 5
	Flags: Private
*/
function private mocompFlankStandInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("nogravity", 0);
	entity OrientMode("face angle", entity.angles[1]);
	entity PathMode("move delayed", 0, RandomFloatRange(0.5, 1));
	if(isdefined(entity.enemy))
	{
		entity GetPerfectInfo(entity.enemy);
		entity.newEnemyReaction = 0;
	}
}

/*
	Name: mocompLocoExplosionInit
	Namespace: archetype_mocomps_utility
	Checksum: 0xDD0D7F58
	Offset: 0x12B0
	Size: 0xBB
	Parameters: 5
	Flags: Private
*/
function private mocompLocoExplosionInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("nogravity", 0);
	entity OrientMode("face angle", entity.angles[1]);
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			entity thread debugLocoExplosion(entity);
		}
	#/
}

/*
	Name: mocompAdjustToCoverInit
	Namespace: archetype_mocomps_utility
	Checksum: 0x87174EC9
	Offset: 0x1378
	Size: 0x2A7
	Parameters: 5
	Flags: Private
*/
function private mocompAdjustToCoverInit(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("angle deltas", 0);
	entity.blockingPain = 1;
	if(isdefined(entity.node))
	{
		entity.adjustNode = entity.node;
		entity.nodeOffsetOrigin = entity GetNodeOffsetPosition(entity.node);
		entity.nodeOffsetAngles = entity GetNodeOffsetAngles(entity.node);
		entity.nodeOffsetForward = AnglesToForward(entity.nodeOffsetAngles);
		entity.nodeForward = AnglesToForward(entity.node.angles);
		entity.nodeFinalStance = blackboard::GetBlackBoardAttribute(entity, "_desired_stance");
		coverType = blackboard::GetBlackBoardAttribute(entity, "_cover_type");
		if(!isdefined(entity.nodeFinalStance))
		{
			entity.nodeFinalStance = AiUtility::getHighestNodeStance(entity.adjustNode);
		}
		angleDifference = floor(AbsAngleClamp360(entity.angles[1] - entity.node.angles[1]));
		entity.mocompAngleStartTime = _GetAdjustToCoverRotation(entity.archetype, coverType, entity.nodeFinalStance, angleDifference);
	}
}

/*
	Name: mocompAdjustToCoverUpdate
	Namespace: archetype_mocomps_utility
	Checksum: 0xEAACED7D
	Offset: 0x1628
	Size: 0x38B
	Parameters: 5
	Flags: Private
*/
function private mocompAdjustToCoverUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(!isdefined(entity.adjustNode))
	{
		return;
	}
	moveVector = entity.nodeOffsetOrigin - entity.origin;
	if(LengthSquared(moveVector) > 1)
	{
		moveVector = VectorNormalize(moveVector) * 1;
	}
	entity ForceTeleport(entity.origin + moveVector, entity.angles, 0);
	normalizedTime = entity GetAnimTime(mocompAnim) * getanimlength(mocompAnim) + mocompAnimBlendOutTime / mocompDuration;
	if(normalizedTime > entity.mocompAngleStartTime)
	{
		entity OrientMode("face angle", entity.nodeOffsetAngles);
		entity animMode("normal", 0);
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			Record3DText(entity.mocompAngleStartTime, entity.origin + VectorScale((0, 0, 1), 5), (0, 1, 0), "Dev Block strings are not supported");
			hipTagOrigin = entity GetTagOrigin("Dev Block strings are not supported");
			recordLine(entity.nodeOffsetOrigin, entity.nodeOffsetOrigin + entity.nodeOffsetForward * 30, (1, 0.5, 0), "Dev Block strings are not supported", entity);
			recordLine(entity.adjustNode.origin, entity.adjustNode.origin + entity.nodeForward * 20, (0, 1, 0), "Dev Block strings are not supported", entity);
			recordLine(entity.origin, entity.origin + AnglesToForward(entity.angles) * 10, (1, 0, 0), "Dev Block strings are not supported", entity);
			recordLine(hipTagOrigin, (hipTagOrigin[0], hipTagOrigin[1], entity.origin[2]), (0, 0, 1), "Dev Block strings are not supported", entity);
		}
	#/
}

/*
	Name: mocompAdjustToCoverTerminate
	Namespace: archetype_mocomps_utility
	Checksum: 0xC5349406
	Offset: 0x19C0
	Size: 0x119
	Parameters: 5
	Flags: Private
*/
function private mocompAdjustToCoverTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.blockingPain = 0;
	entity.mocompAngleStartTime = undefined;
	entity.nodeOffsetAngle = undefined;
	entity.nodeOffsetForward = undefined;
	entity.nodeForward = undefined;
	entity.nodeFinalStance = undefined;
	if(entity.adjustNode !== entity.node)
	{
		entity.nodeOffsetOrigin = undefined;
		entity.nodeOffsetAngles = undefined;
		entity.adjustNode = undefined;
		return;
	}
	entity ForceTeleport(entity.nodeOffsetOrigin, entity.nodeOffsetAngles, 0);
	entity.nodeOffsetOrigin = undefined;
	entity.nodeOffsetAngles = undefined;
	entity.adjustNode = undefined;
}

