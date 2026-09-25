#using scripts\shared\ai\systems\animation_selector_table;
#using scripts\shared\array_shared;

#namespace animation_selector_table_evaluators;

/*
	Name: RegisterASTScriptFunctions
	Namespace: animation_selector_table_evaluators
	Checksum: 0xC33DB53E
	Offset: 0x1C8
	Size: 0xA3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterASTScriptFunctions()
{
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("testFunction", &testFunction);
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("evaluateBlockedAnimations", &evaluateBlockedAnimations);
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("evaluateHumanTurnAnimations", &evaluateHumanTurnAnimations);
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("evaluateHumanExposedArrivalAnimations", &evaluateHumanExposedArrivalAnimations);
}

/*
	Name: testFunction
	Namespace: animation_selector_table_evaluators
	Checksum: 0xA47604A4
	Offset: 0x278
	Size: 0x45
	Parameters: 2
	Flags: None
*/
function testFunction(entity, animations)
{
	if(IsArray(animations) && animations.size > 0)
	{
		return animations[0];
	}
}

/*
	Name: Evaluator_CheckAnimationAgainstGeo
	Namespace: animation_selector_table_evaluators
	Checksum: 0xDC0858
	Offset: 0x2C8
	Size: 0x255
	Parameters: 2
	Flags: Private
*/
function private Evaluator_CheckAnimationAgainstGeo(entity, animation)
{
	PixBeginEvent("Evaluator_CheckAnimationAgainstGeo");
	/#
		Assert(IsActor(entity));
	#/
	localDeltaHalfVector = GetMoveDelta(animation, 0, 0.5, entity);
	midpoint = entity LocalToWorldCoords(localDeltaHalfVector);
	midpoint = (midpoint[0], midpoint[1], entity.origin[2]);
	/#
		recordLine(entity.origin, midpoint, (1, 0.5, 0), "Dev Block strings are not supported", entity);
	#/
	if(entity MayMoveToPoint(midpoint, 1, 1))
	{
		localDeltaVector = GetMoveDelta(animation, 0, 1, entity);
		endPoint = entity LocalToWorldCoords(localDeltaVector);
		endPoint = (endPoint[0], endPoint[1], entity.origin[2]);
		/#
			recordLine(midpoint, endPoint, (1, 0.5, 0), "Dev Block strings are not supported", entity);
		#/
		if(entity MayMoveFromPointToPoint(midpoint, endPoint, 1, 1))
		{
			PixEndEvent();
			return 1;
		}
	}
	PixEndEvent();
	return 0;
}

/*
	Name: Evaluator_CheckAnimationEndPointAgainstGeo
	Namespace: animation_selector_table_evaluators
	Checksum: 0x2FCB299B
	Offset: 0x528
	Size: 0x12D
	Parameters: 2
	Flags: Private
*/
function private Evaluator_CheckAnimationEndPointAgainstGeo(entity, animation)
{
	PixBeginEvent("Evaluator_CheckAnimationEndPointAgainstGeo");
	/#
		Assert(IsActor(entity));
	#/
	localDeltaVector = GetMoveDelta(animation, 0, 1, entity);
	endPoint = entity LocalToWorldCoords(localDeltaVector);
	endPoint = (endPoint[0], endPoint[1], entity.origin[2]);
	if(entity MayMoveToPoint(endPoint, 0, 0))
	{
		PixEndEvent();
		return 1;
	}
	PixEndEvent();
	return 0;
}

/*
	Name: Evaluator_CheckAnimationForOverShootingGoal
	Namespace: animation_selector_table_evaluators
	Checksum: 0x6A17F2A2
	Offset: 0x660
	Size: 0x19D
	Parameters: 2
	Flags: Private
*/
function private Evaluator_CheckAnimationForOverShootingGoal(entity, animation)
{
	PixBeginEvent("Evaluator_CheckAnimationForOverShootingGoal");
	/#
		Assert(IsActor(entity));
	#/
	localDeltaVector = GetMoveDelta(animation, 0, 1, entity);
	endPoint = entity LocalToWorldCoords(localDeltaVector);
	animDistSq = LengthSquared(localDeltaVector);
	if(entity HasPath())
	{
		startPos = entity.origin;
		goalpos = entity.pathGoalPos;
		/#
			Assert(isdefined(goalpos));
		#/
		distToGoalSq = DistanceSquared(startPos, goalpos);
		if(animDistSq < distToGoalSq)
		{
			PixEndEvent();
			return 1;
		}
	}
	PixEndEvent();
	return 0;
}

/*
	Name: Evaluator_CheckAnimationAgainstNavmesh
	Namespace: animation_selector_table_evaluators
	Checksum: 0x60939DB6
	Offset: 0x808
	Size: 0xBD
	Parameters: 2
	Flags: Private
*/
function private Evaluator_CheckAnimationAgainstNavmesh(entity, animation)
{
	/#
		Assert(IsActor(entity));
	#/
	localDeltaVector = GetMoveDelta(animation, 0, 1, entity);
	endPoint = entity LocalToWorldCoords(localDeltaVector);
	if(IsPointOnNavMesh(endPoint, entity))
	{
		return 1;
	}
	return 0;
}

/*
	Name: Evaluator_CheckAnimationArrivalPosition
	Namespace: animation_selector_table_evaluators
	Checksum: 0x29C22AF3
	Offset: 0x8D0
	Size: 0x111
	Parameters: 2
	Flags: Private
*/
function private Evaluator_CheckAnimationArrivalPosition(entity, animation)
{
	localDeltaVector = GetMoveDelta(animation, 0, 1, entity);
	endPoint = entity LocalToWorldCoords(localDeltaVector);
	animDistSq = LengthSquared(localDeltaVector);
	startPos = entity.origin;
	goalpos = entity.pathGoalPos;
	distToGoalSq = DistanceSquared(startPos, goalpos);
	return distToGoalSq < animDistSq && entity IsPosAtGoal(endPoint);
}

/*
	Name: Evaluator_FindFirstValidAnimation
	Namespace: animation_selector_table_evaluators
	Checksum: 0xDBFA0DEF
	Offset: 0x9F0
	Size: 0x1CD
	Parameters: 3
	Flags: Private
*/
function private Evaluator_FindFirstValidAnimation(entity, animations, tests)
{
	/#
		Assert(IsArray(animations), "Dev Block strings are not supported");
	#/
	/#
		Assert(IsArray(tests), "Dev Block strings are not supported");
	#/
	foreach(aliasAnimations in animations)
	{
		if(aliasAnimations.size > 0)
		{
			valid = 1;
			animation = aliasAnimations[0];
			foreach(test in tests)
			{
				if(![[test]](entity, animation))
				{
					valid = 0;
					break;
				}
			}
			if(valid)
			{
				return animation;
			}
		}
	}
}

/*
	Name: evaluateBlockedAnimations
	Namespace: animation_selector_table_evaluators
	Checksum: 0x50CC3FA2
	Offset: 0xBC8
	Size: 0x6D
	Parameters: 2
	Flags: Private
*/
function private evaluateBlockedAnimations(entity, animations)
{
	if(animations.size > 0)
	{
		return Evaluator_FindFirstValidAnimation(entity, animations, Array(&Evaluator_CheckAnimationAgainstGeo, &Evaluator_CheckAnimationForOverShootingGoal));
	}
	return undefined;
}

/*
	Name: evaluateHumanTurnAnimations
	Namespace: animation_selector_table_evaluators
	Checksum: 0xAA2165C4
	Offset: 0xC40
	Size: 0xED
	Parameters: 2
	Flags: Private
*/
function private evaluateHumanTurnAnimations(entity, animations)
{
	/#
		if(isdefined(level.ai_dontTurn) && level.ai_dontTurn)
		{
			return undefined;
		}
	#/
	/#
		Record3DText("Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported", entity.origin, (1, 0.5, 0), "Dev Block strings are not supported", entity);
	#/
	if(animations.size > 0)
	{
		return Evaluator_FindFirstValidAnimation(entity, animations, Array(&Evaluator_CheckAnimationForOverShootingGoal, &Evaluator_CheckAnimationAgainstGeo, &Evaluator_CheckAnimationAgainstNavmesh));
	}
	return undefined;
}

/*
	Name: evaluateHumanExposedArrivalAnimations
	Namespace: animation_selector_table_evaluators
	Checksum: 0x696DD51B
	Offset: 0xD38
	Size: 0x75
	Parameters: 2
	Flags: Private
*/
function private evaluateHumanExposedArrivalAnimations(entity, animations)
{
	if(!isdefined(entity.pathGoalPos))
	{
		return undefined;
	}
	if(animations.size > 0)
	{
		return Evaluator_FindFirstValidAnimation(entity, animations, Array(&Evaluator_CheckAnimationArrivalPosition));
	}
	return undefined;
}

