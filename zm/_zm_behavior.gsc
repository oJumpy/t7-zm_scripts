#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_behavior_utility;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_behavior;

/*
	Name: init
	Namespace: zm_behavior
	Checksum: 0xB790CCAE
	Offset: 0xAF0
	Size: 0x4F
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitZmBehaviorsAndASM();
	level.zigzag_activation_distance = 240;
	level.zigzag_distance_min = 240;
	level.zigzag_distance_max = 480;
	level.inner_zigzag_radius = 0;
	level.outer_zigzag_radius = 96;
}

/*
	Name: InitZmBehaviorsAndASM
	Namespace: zm_behavior
	Checksum: 0xCFA1274F
	Offset: 0xB48
	Size: 0xA1B
	Parameters: 0
	Flags: Private
*/
function private InitZmBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieFindFleshService", &zombieFindFlesh);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieEnteredPlayableService", &zombieEnteredPlayable);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMove", &shouldMoveCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldTear", &zombieShouldTearCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldAttackThroughBoards", &zombieShouldAttackThroughBoardsCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldTaunt", &zombieShouldTauntCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGotToEntrance", &zombieGotToEntranceCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGotToAttackSpot", &zombieGotToAttackSpotCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieHasAttackSpotAlready", &zombieHasAttackSpotAlreadyCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldEnterPlayable", &zombieShouldEnterPlayableCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isChunkValid", &isChunkValidCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("inPlayableArea", &InPlayableArea);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldSkipTeardown", &shouldSkipTeardown);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsThinkDone", &zombieIsThinkDone);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsAtGoal", &zombieIsAtGoal);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsAtEntrance", &zombieIsAtEntrance);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMoveAway", &zombieShouldMoveAwayCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByTesla", &wasKilledByTeslaCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldStun", &zombieShouldStun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsBeingGrappled", &zombieIsBeingGrappled);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldKnockdown", &zombieShouldKnockdown);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsPushed", &zombieIsPushed);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieKilledWhileGettingPulled", &zombieKilledWhileGettingPulled);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieKilledByBlackHoleBombCondition", &zombieKilledByBlackHoleBombCondition);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("disablePowerups", &disablePowerups);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("enablePowerups", &enablePowerups);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveToEntranceAction", &zombieMoveToEntranceAction, undefined, &zombieMoveToEntranceActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveToAttackSpotAction", &zombieMoveToAttackSpotAction, undefined, &zombieMoveToAttackSpotActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieIdleAction", undefined, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveAway", &zombieMoveAway, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieTraverseAction", &zombieTraverseAction, undefined, &zombieTraverseActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("holdBoardAction", &zombieHoldBoardAction, undefined, &zombieHoldBoardActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("grabBoardAction", &zombieGrabBoardAction, undefined, &zombieGrabBoardActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("pullBoardAction", &zombiePullBoardAction, undefined, &zombiePullBoardActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieAttackThroughBoardsAction", &zombieAttackThroughBoardsAction, undefined, &zombieAttackThroughBoardsActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieTauntAction", &zombieTauntAction, undefined, &zombieTauntActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMantleAction", &zombieMantleAction, undefined, &zombieMantleActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStunActionStart", &zombieStunActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStunActionEnd", &zombieStunActionEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGrappleActionStart", &zombieGrappleActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieKnockdownActionStart", &zombieKnockdownActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGetupActionTerminate", &zombieGetupActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombiePushedActionStart", &zombiePushedActionStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombiePushedActionTerminate", &zombiePushedActionTerminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieBlackHoleBombPullAction", &zombieBlackHoleBombPullStart, &zombieBlackHoleBombPullUpdate, &zombieBlackHoleBombPullEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieBlackHoleBombDeathAction", &zombieKilledByBlackHoleBombStart, undefined, &zombieKilledByBlackHoleBombEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("getChunkService", &getChunkService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("updateChunkService", &updateChunkService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("updateAttackSpotService", &updateAttackSpotService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("findNodesService", &findNodesService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieAttackableObjectService", &zombieAttackableObjectService);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_board_tear@zombie", &boardTearMocompStart, &boardTearMocompUpdate, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_barricade_enter@zombie", &barricadeEnterMocompStart, &barricadeEnterMocompUpdate, &barricadeEnterMocompTerminate);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_barricade_enter_no_z@zombie", &barricadeEnterMocompNoZStart, &barricadeEnterMocompNoZUpdate, &barricadeEnterMocompNoZTerminate);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("destroy_piece", &notetrackBoardTear);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("zombie_window_melee", &notetrackBoardMelee);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("bhb_burst", &zombieBHBBurst);
	SetDvar("scr_zm_use_code_enemy_selection", 1);
}

/*
	Name: zombieFindFlesh
	Namespace: zm_behavior
	Checksum: 0x5A6B6CA9
	Offset: 0x1570
	Size: 0x9F5
	Parameters: 1
	Flags: None
*/
function zombieFindFlesh(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.enablePushTime))
	{
		if(GetTime() >= behaviorTreeEntity.enablePushTime)
		{
			behaviorTreeEntity PushActors(1);
			behaviorTreeEntity.enablePushTime = undefined;
		}
	}
	if(GetDvarInt("scr_zm_use_code_enemy_selection", 0))
	{
		zombieFindFleshCode(behaviorTreeEntity);
		return;
	}
	if(level.intermission)
	{
		return;
	}
	if(behaviorTreeEntity GetPathMode() == "dont move")
	{
		return;
	}
	behaviorTreeEntity.ignoreme = 0;
	behaviorTreeEntity.ignore_player = [];
	behaviorTreeEntity.goalRadius = 30;
	if(isdefined(behaviorTreeEntity.ignore_find_flesh) && behaviorTreeEntity.ignore_find_flesh)
	{
		return;
	}
	if(behaviorTreeEntity.team == "allies")
	{
		behaviorTreeEntity findZombieEnemy();
		return;
	}
	if(zombieShouldMoveAwayCondition(behaviorTreeEntity))
	{
		return;
	}
	zombie_poi = behaviorTreeEntity zm_utility::get_zombie_point_of_interest(behaviorTreeEntity.origin);
	behaviorTreeEntity.zombie_poi = zombie_poi;
	players = GetPlayers();
	if(!isdefined(behaviorTreeEntity.ignore_player) || players.size == 1)
	{
		behaviorTreeEntity.ignore_player = [];
		break;
	}
	if(!isdefined(level._should_skip_ignore_player_logic) || ![[level._should_skip_ignore_player_logic]]())
	{
		i = 0;
		while(i < behaviorTreeEntity.ignore_player.size)
		{
			if(isdefined(behaviorTreeEntity.ignore_player[i]) && isdefined(behaviorTreeEntity.ignore_player[i].ignore_counter) && behaviorTreeEntity.ignore_player[i].ignore_counter > 3)
			{
				behaviorTreeEntity.ignore_player[i].ignore_counter = 0;
				behaviorTreeEntity.ignore_player = ArrayRemoveValue(behaviorTreeEntity.ignore_player, behaviorTreeEntity.ignore_player[i]);
				if(!isdefined(behaviorTreeEntity.ignore_player))
				{
					behaviorTreeEntity.ignore_player = [];
				}
				i = 0;
				continue;
			}
			i++;
		}
	}
	behaviorTreeEntity zombie_utility::run_ignore_player_handler();
	player = zm_utility::get_closest_valid_player(behaviorTreeEntity.origin, behaviorTreeEntity.ignore_player);
	designated_target = 0;
	if(isdefined(player) && (isdefined(player.b_is_designated_target) && player.b_is_designated_target))
	{
		designated_target = 1;
	}
	if(!isdefined(player) && !isdefined(zombie_poi) && !isdefined(behaviorTreeEntity.attackable))
	{
		if(isdefined(behaviorTreeEntity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			behaviorTreeEntity.ignore_player = [];
		}
		/#
			if(isdefined(behaviorTreeEntity.isPuppet) && behaviorTreeEntity.isPuppet)
			{
				return;
			}
		#/
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](behaviorTreeEntity);
		}
		else
		{
			behaviorTreeEntity SetGoal(behaviorTreeEntity.origin);
		}
		return;
	}
	if(!isdefined(level.check_for_alternate_poi) || ![[level.check_for_alternate_poi]]())
	{
		behaviorTreeEntity.enemyoverride = zombie_poi;
		behaviorTreeEntity.favoriteenemy = player;
	}
	if(isdefined(behaviorTreeEntity.v_zombie_custom_goal_pos))
	{
		goalpos = behaviorTreeEntity.v_zombie_custom_goal_pos;
		if(isdefined(behaviorTreeEntity.n_zombie_custom_goal_radius))
		{
			behaviorTreeEntity.goalRadius = behaviorTreeEntity.n_zombie_custom_goal_radius;
		}
		behaviorTreeEntity SetGoal(goalpos);
	}
	else if(isdefined(behaviorTreeEntity.enemyoverride) && isdefined(behaviorTreeEntity.enemyoverride[1]))
	{
		behaviorTreeEntity.has_exit_point = undefined;
		goalpos = behaviorTreeEntity.enemyoverride[0];
		if(!isdefined(zombie_poi))
		{
			AIProfile_BeginEntry("zombiefindflesh-enemyoverride");
			queryResult = PositionQuery_Source_Navigation(goalpos, 0, 48, 36, 4);
			AIProfile_EndEntry();
			foreach(point in queryResult.data)
			{
				goalpos = point.origin;
				break;
			}
		}
		behaviorTreeEntity SetGoal(goalpos);
	}
	else if(isdefined(behaviorTreeEntity.attackable) && !designated_target)
	{
		if(isdefined(behaviorTreeEntity.attackable_slot))
		{
			if(isdefined(behaviorTreeEntity.attackable_goal_radius))
			{
				behaviorTreeEntity.goalRadius = behaviorTreeEntity.attackable_goal_radius;
			}
			nav_mesh = GetClosestPointOnNavMesh(behaviorTreeEntity.attackable_slot.origin, 64);
			if(isdefined(nav_mesh))
			{
				behaviorTreeEntity SetGoal(nav_mesh);
			}
			else
			{
				behaviorTreeEntity SetGoal(behaviorTreeEntity.attackable_slot.origin);
			}
		}
	}
	else if(isdefined(behaviorTreeEntity.favoriteenemy))
	{
		behaviorTreeEntity.has_exit_point = undefined;
		behaviorTreeEntity.ignoreall = 0;
		if(isdefined(level.enemy_location_override_func))
		{
			goalpos = [[level.enemy_location_override_func]](behaviorTreeEntity, behaviorTreeEntity.favoriteenemy);
			if(isdefined(goalpos))
			{
				behaviorTreeEntity SetGoal(goalpos);
			}
			else
			{
				behaviorTreeEntity zombieUpdateGoal();
			}
		}
		else if(isdefined(behaviorTreeEntity.is_rat_test) && behaviorTreeEntity.is_rat_test)
		{
		}
		else if(zombieShouldMoveAwayCondition(behaviorTreeEntity))
		{
		}
		else if(isdefined(behaviorTreeEntity.favoriteenemy.last_valid_position))
		{
			behaviorTreeEntity zombieUpdateGoal();
		}
	}
	if(players.size > 1)
	{
		for(i = 0; i < behaviorTreeEntity.ignore_player.size; i++)
		{
			if(isdefined(behaviorTreeEntity.ignore_player[i]))
			{
				if(!isdefined(behaviorTreeEntity.ignore_player[i].ignore_counter))
				{
					behaviorTreeEntity.ignore_player[i].ignore_counter = 0;
					continue;
				}
				behaviorTreeEntity.ignore_player[i].ignore_counter = behaviorTreeEntity.ignore_player[i].ignore_counter + 1;
			}
		}
	}
}

/*
	Name: zombieFindFleshCode
	Namespace: zm_behavior
	Checksum: 0xA24FD650
	Offset: 0x1F70
	Size: 0x46B
	Parameters: 1
	Flags: None
*/
function zombieFindFleshCode(behaviorTreeEntity)
{
	AIProfile_BeginEntry("zombieFindFleshCode");
	if(level.intermission)
	{
		AIProfile_EndEntry();
		return;
	}
	behaviorTreeEntity.ignore_player = [];
	behaviorTreeEntity.goalRadius = 30;
	if(behaviorTreeEntity.team == "allies")
	{
		behaviorTreeEntity findZombieEnemy();
		AIProfile_EndEntry();
		return;
	}
	if(level.wait_and_revive)
	{
		AIProfile_EndEntry();
		return;
	}
	if(level.zombie_poi_array.size > 0)
	{
		zombie_poi = behaviorTreeEntity zm_utility::get_zombie_point_of_interest(behaviorTreeEntity.origin);
	}
	behaviorTreeEntity zombie_utility::run_ignore_player_handler();
	zm_utility::update_valid_players(behaviorTreeEntity.origin, behaviorTreeEntity.ignore_player);
	if(!isdefined(behaviorTreeEntity.enemy) && !isdefined(zombie_poi))
	{
		/#
			if(isdefined(behaviorTreeEntity.isPuppet) && behaviorTreeEntity.isPuppet)
			{
				AIProfile_EndEntry();
				return;
			}
		#/
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](behaviorTreeEntity);
		}
		else
		{
			behaviorTreeEntity SetGoal(behaviorTreeEntity.origin);
		}
		AIProfile_EndEntry();
		return;
	}
	behaviorTreeEntity.enemyoverride = zombie_poi;
	if(isdefined(behaviorTreeEntity.enemyoverride) && isdefined(behaviorTreeEntity.enemyoverride[1]))
	{
		behaviorTreeEntity.has_exit_point = undefined;
		goalpos = behaviorTreeEntity.enemyoverride[0];
		queryResult = PositionQuery_Source_Navigation(goalpos, 0, 48, 36, 4);
		foreach(point in queryResult.data)
		{
			goalpos = point.origin;
			break;
		}
		behaviorTreeEntity SetGoal(goalpos);
	}
	else if(isdefined(behaviorTreeEntity.enemy))
	{
		behaviorTreeEntity.has_exit_point = undefined;
		/#
			if(isdefined(behaviorTreeEntity.is_rat_test) && behaviorTreeEntity.is_rat_test)
			{
				AIProfile_EndEntry();
				return;
			}
		#/
		if(isdefined(level.enemy_location_override_func))
		{
			goalpos = [[level.enemy_location_override_func]](behaviorTreeEntity, behaviorTreeEntity.enemy);
			if(isdefined(goalpos))
			{
				behaviorTreeEntity SetGoal(goalpos);
			}
			else
			{
				behaviorTreeEntity zombieUpdateGoalCode();
			}
		}
		else if(isdefined(behaviorTreeEntity.enemy.last_valid_position))
		{
			behaviorTreeEntity zombieUpdateGoalCode();
		}
	}
	AIProfile_EndEntry();
}

/*
	Name: zombieUpdateGoal
	Namespace: zm_behavior
	Checksum: 0x601E002A
	Offset: 0x23E8
	Size: 0x603
	Parameters: 0
	Flags: None
*/
function zombieUpdateGoal()
{
	AIProfile_BeginEntry("zombieUpdateGoal");
	shouldRepath = 0;
	if(!shouldRepath && isdefined(self.favoriteenemy))
	{
		if(!isdefined(self.nextGoalUpdate) || self.nextGoalUpdate <= GetTime())
		{
			shouldRepath = 1;
		}
		else if(DistanceSquared(self.origin, self.favoriteenemy.origin) <= level.zigzag_activation_distance * level.zigzag_activation_distance)
		{
			shouldRepath = 1;
		}
		else if(isdefined(self.pathGoalPos))
		{
			distanceToGoalSqr = DistanceSquared(self.origin, self.pathGoalPos);
			shouldRepath = distanceToGoalSqr < 72 * 72;
		}
	}
	if(isdefined(level.validate_on_navmesh) && level.validate_on_navmesh)
	{
		if(!IsPointOnNavMesh(self.origin, self))
		{
			shouldRepath = 0;
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
		should_zigzag = 1;
		if(isdefined(level.should_zigzag))
		{
			should_zigzag = self [[level.should_zigzag]]();
		}
		if(isdefined(level.do_randomized_zigzag_path) && level.do_randomized_zigzag_path && should_zigzag)
		{
			if(DistanceSquared(self.origin, goalpos) > level.zigzag_activation_distance * level.zigzag_activation_distance)
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
				deviationDistance = randomIntRange(level.zigzag_distance_min, level.zigzag_distance_max);
				if(isdefined(self.zigzag_distance_min) && isdefined(self.zigzag_distance_max))
				{
					deviationDistance = randomIntRange(self.zigzag_distance_min, self.zigzag_distance_max);
				}
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
						innerZigZagRadius = level.inner_zigzag_radius;
						outerZigZagRadius = level.outer_zigzag_radius;
						queryResult = PositionQuery_Source_Navigation(seedPosition, innerZigZagRadius, outerZigZagRadius, 36, 16, self, 16);
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
		}
		self.nextGoalUpdate = GetTime() + randomIntRange(500, 1000);
	}
	AIProfile_EndEntry();
}

/*
	Name: zombieUpdateGoalCode
	Namespace: zm_behavior
	Checksum: 0x3F20B860
	Offset: 0x29F8
	Size: 0x54B
	Parameters: 0
	Flags: None
*/
function zombieUpdateGoalCode()
{
	AIProfile_BeginEntry("zombieUpdateGoalCode");
	shouldRepath = 0;
	if(!shouldRepath && isdefined(self.enemy))
	{
		if(!isdefined(self.nextGoalUpdate) || self.nextGoalUpdate <= GetTime())
		{
			shouldRepath = 1;
		}
		else if(DistanceSquared(self.origin, self.enemy.origin) <= 200 * 200)
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
		goalpos = self.enemy.origin;
		if(isdefined(self.enemy.last_valid_position))
		{
			goalpos = self.enemy.last_valid_position;
		}
		if(isdefined(level.do_randomized_zigzag_path) && level.do_randomized_zigzag_path)
		{
			if(DistanceSquared(self.origin, goalpos) > 240 * 240)
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
				deviationDistance = randomIntRange(240, 480);
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
						innerZigZagRadius = level.inner_zigzag_radius;
						outerZigZagRadius = level.outer_zigzag_radius;
						queryResult = PositionQuery_Source_Navigation(seedPosition, innerZigZagRadius, outerZigZagRadius, 36, 16, self, 16);
						PositionQuery_Filter_InClaimedLocation(queryResult, self);
						if(queryResult.data.size > 0)
						{
							point = queryResult.data[RandomInt(queryResult.data.size)];
							if(TracePassedOnNavMesh(seedPosition, point.origin, 16))
							{
								goalpos = point.origin;
							}
						}
						break;
					}
					segmentLength = segmentLength + currentSegLength;
				}
			}
		}
		self SetGoal(goalpos);
		self.nextGoalUpdate = GetTime() + randomIntRange(500, 1000);
	}
	AIProfile_EndEntry();
}

/*
	Name: zombieEnteredPlayable
	Namespace: zm_behavior
	Checksum: 0x7F76BCED
	Offset: 0x2F50
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function zombieEnteredPlayable(behaviorTreeEntity)
{
	if(!isdefined(level.playable_areas))
	{
		level.playable_areas = GetEntArray("player_volume", "script_noteworthy");
	}
	foreach(area in level.playable_areas)
	{
		if(behaviorTreeEntity istouching(area))
		{
			behaviorTreeEntity zm_spawner::zombie_complete_emerging_into_playable_area();
			return 1;
		}
	}
	return 0;
}

/*
	Name: shouldMoveCondition
	Namespace: zm_behavior
	Checksum: 0xF2629051
	Offset: 0x3050
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function shouldMoveCondition(behaviorTreeEntity)
{
	if(behaviorTreeEntity HasPath())
	{
		return 1;
	}
	if(isdefined(behaviorTreeEntity.keep_moving) && behaviorTreeEntity.keep_moving)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieShouldMoveAwayCondition
	Namespace: zm_behavior
	Checksum: 0xA201B4F1
	Offset: 0x30B8
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function zombieShouldMoveAwayCondition(behaviorTreeEntity)
{
	return level.wait_and_revive;
}

/*
	Name: wasKilledByTeslaCondition
	Namespace: zm_behavior
	Checksum: 0xBE9FE714
	Offset: 0x30D8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function wasKilledByTeslaCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.tesla_death) && behaviorTreeEntity.tesla_death)
	{
		return 1;
	}
	return 0;
}

/*
	Name: disablePowerups
	Namespace: zm_behavior
	Checksum: 0x74A0F634
	Offset: 0x3120
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function disablePowerups(behaviorTreeEntity)
{
	behaviorTreeEntity.no_powerups = 1;
}

/*
	Name: enablePowerups
	Namespace: zm_behavior
	Checksum: 0x178F55F4
	Offset: 0x3148
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function enablePowerups(behaviorTreeEntity)
{
	behaviorTreeEntity.no_powerups = 0;
}

/*
	Name: zombieMoveAway
	Namespace: zm_behavior
	Checksum: 0x650B76C7
	Offset: 0x3170
	Size: 0x315
	Parameters: 2
	Flags: None
*/
function zombieMoveAway(behaviorTreeEntity, asmStateName)
{
	player = util::getHostPlayer();
	queryResult = level.move_away_points;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	if(!isdefined(queryResult))
	{
		return 5;
	}
	for(i = 0; i < queryResult.data.size; i++)
	{
		if(!zm_utility::check_point_in_playable_area(queryResult.data[i].origin))
		{
			continue;
		}
		isBehind = VectorDot(player.origin - behaviorTreeEntity.origin, queryResult.data[i].origin - behaviorTreeEntity.origin);
		if(isBehind < 0)
		{
			behaviorTreeEntity SetGoal(queryResult.data[i].origin);
			ArrayRemoveIndex(level.move_away_points.data, i, 0);
			i--;
			return 5;
		}
	}
	for(i = 0; i < queryResult.data.size; i++)
	{
		if(!zm_utility::check_point_in_playable_area(queryResult.data[i].origin))
		{
			continue;
		}
		dist_zombie = DistanceSquared(queryResult.data[i].origin, behaviorTreeEntity.origin);
		dist_player = DistanceSquared(queryResult.data[i].origin, player.origin);
		if(dist_zombie < dist_player)
		{
			behaviorTreeEntity SetGoal(queryResult.data[i].origin);
			ArrayRemoveIndex(level.move_away_points.data, i, 0);
			i--;
			return 5;
		}
	}
	return 5;
}

/*
	Name: zombieIsBeingGrappled
	Namespace: zm_behavior
	Checksum: 0x192B5BCA
	Offset: 0x3490
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zombieIsBeingGrappled(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.grapple_is_fatal) && behaviorTreeEntity.grapple_is_fatal)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieShouldKnockdown
	Namespace: zm_behavior
	Checksum: 0x644E3673
	Offset: 0x34D8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zombieShouldKnockdown(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.KNOCKDOWN) && behaviorTreeEntity.KNOCKDOWN)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieIsPushed
	Namespace: zm_behavior
	Checksum: 0xC1D32458
	Offset: 0x3520
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zombieIsPushed(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.pushed) && behaviorTreeEntity.pushed)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieGrappleActionStart
	Namespace: zm_behavior
	Checksum: 0x4B9473D4
	Offset: 0x3568
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function zombieGrappleActionStart(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_grapple_direction", self.GRAPPLE_DIRECTION);
}

/*
	Name: zombieKnockdownActionStart
	Namespace: zm_behavior
	Checksum: 0x7E7CCF1B
	Offset: 0x35A8
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private zombieKnockdownActionStart(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_knockdown_direction", behaviorTreeEntity.knockdown_direction);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_knockdown_type", behaviorTreeEntity.knockdown_type);
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_getup_direction", behaviorTreeEntity.getup_direction);
}

/*
	Name: zombieGetupActionTerminate
	Namespace: zm_behavior
	Checksum: 0xA8D5D019
	Offset: 0x3638
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private zombieGetupActionTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity.KNOCKDOWN = 0;
}

/*
	Name: zombiePushedActionStart
	Namespace: zm_behavior
	Checksum: 0x5BE79C35
	Offset: 0x3660
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private zombiePushedActionStart(behaviorTreeEntity)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_push_direction", behaviorTreeEntity.PUSH_DIRECTION);
}

/*
	Name: zombiePushedActionTerminate
	Namespace: zm_behavior
	Checksum: 0x73DD2705
	Offset: 0x36A0
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private zombiePushedActionTerminate(behaviorTreeEntity)
{
	behaviorTreeEntity.pushed = 0;
}

/*
	Name: zombieShouldStun
	Namespace: zm_behavior
	Checksum: 0x91982099
	Offset: 0x36C8
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function zombieShouldStun(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.zombie_tesla_hit) && behaviorTreeEntity.zombie_tesla_hit && (!isdefined(behaviorTreeEntity.tesla_death) && behaviorTreeEntity.tesla_death))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieStunActionStart
	Namespace: zm_behavior
	Checksum: 0x39BB1468
	Offset: 0x3730
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function zombieStunActionStart(behaviorTreeEntity)
{
}

/*
	Name: zombieStunActionEnd
	Namespace: zm_behavior
	Checksum: 0x15F20E20
	Offset: 0x3748
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function zombieStunActionEnd(behaviorTreeEntity)
{
	behaviorTreeEntity.zombie_tesla_hit = 0;
}

/*
	Name: zombieTraverseAction
	Namespace: zm_behavior
	Checksum: 0xC396708F
	Offset: 0x3770
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function zombieTraverseAction(behaviorTreeEntity, asmStateName)
{
	AiUtility::traverseActionStart(behaviorTreeEntity, asmStateName);
	behaviorTreeEntity.old_powerups = behaviorTreeEntity.no_powerups;
	disablePowerups(behaviorTreeEntity);
	return 5;
}

/*
	Name: zombieTraverseActionTerminate
	Namespace: zm_behavior
	Checksum: 0xFA7F2EF4
	Offset: 0x37D8
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function zombieTraverseActionTerminate(behaviorTreeEntity, asmStateName)
{
	if(behaviorTreeEntity ASMGetStatus() == "asm_status_complete")
	{
		behaviorTreeEntity.no_powerups = behaviorTreeEntity.old_powerups;
		if(!(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs))
		{
			behaviorTreeEntity PushActors(0);
			behaviorTreeEntity.enablePushTime = GetTime() + 1000;
		}
	}
	return 4;
}

/*
	Name: zombieGotToEntranceCondition
	Namespace: zm_behavior
	Checksum: 0x467618B7
	Offset: 0x3890
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zombieGotToEntranceCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.got_to_entrance) && behaviorTreeEntity.got_to_entrance)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieGotToAttackSpotCondition
	Namespace: zm_behavior
	Checksum: 0x82A00
	Offset: 0x38D8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zombieGotToAttackSpotCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.at_entrance_tear_spot) && behaviorTreeEntity.at_entrance_tear_spot)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieHasAttackSpotAlreadyCondition
	Namespace: zm_behavior
	Checksum: 0x9F0B1708
	Offset: 0x3920
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function zombieHasAttackSpotAlreadyCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.attacking_spot_index) && behaviorTreeEntity.attacking_spot_index >= 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieShouldTearCondition
	Namespace: zm_behavior
	Checksum: 0xD55D1D5A
	Offset: 0x3968
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function zombieShouldTearCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.first_node) && isdefined(behaviorTreeEntity.first_node.barrier_chunks))
	{
		if(!zm_utility::all_chunks_destroyed(behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: zombieShouldAttackThroughBoardsCondition
	Namespace: zm_behavior
	Checksum: 0x91D34010
	Offset: 0x39E8
	Size: 0x317
	Parameters: 1
	Flags: None
*/
function zombieShouldAttackThroughBoardsCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs)
	{
		return 0;
	}
	if(isdefined(behaviorTreeEntity.first_node.zbarrier))
	{
		if(!behaviorTreeEntity.first_node.zbarrier ZBarrierSupportsZombieReachThroughAttacks())
		{
			chunks = undefined;
			if(isdefined(behaviorTreeEntity.first_node))
			{
				chunks = zm_utility::get_non_destroyed_chunks(behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks);
			}
			if(isdefined(chunks) && chunks.size > 0)
			{
				return 0;
			}
		}
	}
	if(GetDvarString("zombie_reachin_freq") == "")
	{
		SetDvar("zombie_reachin_freq", "50");
	}
	freq = GetDvarInt("zombie_reachin_freq");
	players = GetPlayers();
	attack = 0;
	behaviorTreeEntity.player_targets = [];
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]) && !isdefined(players[i].reviveTrigger) && Distance2D(behaviorTreeEntity.origin, players[i].origin) <= 109.8 && (!isdefined(players[i].zombie_vars["zombie_powerup_zombie_blood_on"]) && players[i].zombie_vars["zombie_powerup_zombie_blood_on"]) && (!isdefined(players[i].ignoreme) && players[i].ignoreme))
		{
			behaviorTreeEntity.player_targets[behaviorTreeEntity.player_targets.size] = players[i];
			attack = 1;
		}
	}
	if(!attack || freq < RandomInt(100))
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombieShouldTauntCondition
	Namespace: zm_behavior
	Checksum: 0xBB73BDD6
	Offset: 0x3D08
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function zombieShouldTauntCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.first_node.zbarrier))
	{
		return 0;
	}
	if(!behaviorTreeEntity.first_node.zbarrier ZBarrierSupportsZombieTaunts())
	{
		return 0;
	}
	if(GetDvarString("zombie_taunt_freq") == "")
	{
		SetDvar("zombie_taunt_freq", "5");
	}
	freq = GetDvarInt("zombie_taunt_freq");
	if(freq >= RandomInt(100))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieShouldEnterPlayableCondition
	Namespace: zm_behavior
	Checksum: 0xAA7C11FA
	Offset: 0x3E28
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function zombieShouldEnterPlayableCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.first_node) && isdefined(behaviorTreeEntity.first_node.barrier_chunks))
	{
		if(zm_utility::all_chunks_destroyed(behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks))
		{
			if(isdefined(behaviorTreeEntity.at_entrance_tear_spot) && behaviorTreeEntity.at_entrance_tear_spot && (!isdefined(behaviorTreeEntity.completed_emerging_into_playable_area) && behaviorTreeEntity.completed_emerging_into_playable_area))
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: isChunkValidCondition
	Namespace: zm_behavior
	Checksum: 0xF0A95612
	Offset: 0x3EF0
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function isChunkValidCondition(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.chunk))
	{
		return 1;
	}
	return 0;
}

/*
	Name: InPlayableArea
	Namespace: zm_behavior
	Checksum: 0xD6A5567
	Offset: 0x3F20
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function InPlayableArea(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.completed_emerging_into_playable_area) && behaviorTreeEntity.completed_emerging_into_playable_area)
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldSkipTeardown
	Namespace: zm_behavior
	Checksum: 0x708AC40B
	Offset: 0x3F68
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function shouldSkipTeardown(behaviorTreeEntity)
{
	if(behaviorTreeEntity zm_spawner::should_skip_teardown(behaviorTreeEntity.find_flesh_struct_string))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieIsThinkDone
	Namespace: zm_behavior
	Checksum: 0xAF3CA78C
	Offset: 0x3FA8
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function zombieIsThinkDone(behaviorTreeEntity)
{
	/#
		if(isdefined(behaviorTreeEntity.is_rat_test) && behaviorTreeEntity.is_rat_test)
		{
			return 0;
		}
	#/
	if(isdefined(behaviorTreeEntity.zombie_think_done) && behaviorTreeEntity.zombie_think_done)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieIsAtGoal
	Namespace: zm_behavior
	Checksum: 0xFD7EDCC0
	Offset: 0x4018
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function zombieIsAtGoal(behaviorTreeEntity)
{
	isAtScriptGoal = behaviorTreeEntity IsAtGoal();
	return isAtScriptGoal;
}

/*
	Name: zombieIsAtEntrance
	Namespace: zm_behavior
	Checksum: 0xBA1D2BCB
	Offset: 0x4058
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function zombieIsAtEntrance(behaviorTreeEntity)
{
	isAtScriptGoal = behaviorTreeEntity IsAtGoal();
	isAtEntrance = isdefined(behaviorTreeEntity.first_node) && isAtScriptGoal;
	return isAtEntrance;
}

/*
	Name: getChunkService
	Namespace: zm_behavior
	Checksum: 0xCDE610FC
	Offset: 0x40C0
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function getChunkService(behaviorTreeEntity)
{
	behaviorTreeEntity.chunk = zm_utility::get_closest_non_destroyed_chunk(behaviorTreeEntity.origin, behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks);
	if(isdefined(behaviorTreeEntity.chunk))
	{
		behaviorTreeEntity.first_node.zbarrier SetZBarrierPieceState(behaviorTreeEntity.chunk, "targetted_by_zombie");
		behaviorTreeEntity.first_node thread zm_spawner::check_zbarrier_piece_for_zombie_death(behaviorTreeEntity.chunk, behaviorTreeEntity.first_node.zbarrier, behaviorTreeEntity);
	}
}

/*
	Name: updateChunkService
	Namespace: zm_behavior
	Checksum: 0xE5F528BC
	Offset: 0x41B0
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function updateChunkService(behaviorTreeEntity)
{
	while(0 < behaviorTreeEntity.first_node.zbarrier.chunk_health[behaviorTreeEntity.chunk])
	{
		behaviorTreeEntity.first_node.zbarrier.chunk_health[behaviorTreeEntity.chunk]--;
	}
	behaviorTreeEntity.lastchunk_destroy_time = GetTime();
}

/*
	Name: updateAttackSpotService
	Namespace: zm_behavior
	Checksum: 0x783C6D47
	Offset: 0x4238
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function updateAttackSpotService(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.marked_for_death) && behaviorTreeEntity.marked_for_death || behaviorTreeEntity.health < 0)
	{
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.attacking_spot))
	{
		if(!behaviorTreeEntity zm_spawner::get_attack_spot(behaviorTreeEntity.first_node))
		{
			return 0;
		}
	}
	if(isdefined(behaviorTreeEntity.attacking_spot))
	{
		behaviorTreeEntity.goalRadius = 8;
		behaviorTreeEntity SetGoal(behaviorTreeEntity.attacking_spot);
		if(behaviorTreeEntity IsAtGoal())
		{
			behaviorTreeEntity.at_entrance_tear_spot = 1;
		}
		return 1;
	}
	return 0;
}

/*
	Name: findNodesService
	Namespace: zm_behavior
	Checksum: 0x778F4413
	Offset: 0x4340
	Size: 0x1BD
	Parameters: 1
	Flags: None
*/
function findNodesService(behaviorTreeEntity)
{
	node = undefined;
	behaviorTreeEntity.entrance_nodes = [];
	if(isdefined(behaviorTreeEntity.find_flesh_struct_string))
	{
		if(behaviorTreeEntity.find_flesh_struct_string == "find_flesh")
		{
			return 0;
		}
		for(i = 0; i < level.exterior_goals.size; i++)
		{
			if(isdefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == behaviorTreeEntity.find_flesh_struct_string)
			{
				node = level.exterior_goals[i];
				break;
			}
		}
		behaviorTreeEntity.entrance_nodes[behaviorTreeEntity.entrance_nodes.size] = node;
		/#
			Assert(isdefined(node), "Dev Block strings are not supported" + behaviorTreeEntity.find_flesh_struct_string + "Dev Block strings are not supported");
		#/
		behaviorTreeEntity.first_node = node;
		behaviorTreeEntity.goalRadius = 128;
		behaviorTreeEntity SetGoal(node.origin);
		if(zombieIsAtEntrance(behaviorTreeEntity))
		{
			behaviorTreeEntity.got_to_entrance = 1;
		}
		return 1;
	}
}

/*
	Name: zombieAttackableObjectService
	Namespace: zm_behavior
	Checksum: 0x9F8F4BE6
	Offset: 0x4508
	Size: 0x13D
	Parameters: 1
	Flags: None
*/
function zombieAttackableObjectService(behaviorTreeEntity)
{
	if(!behaviorTreeEntity ai::has_behavior_attribute("use_attackable") || !behaviorTreeEntity ai::get_behavior_attribute("use_attackable"))
	{
		behaviorTreeEntity.attackable = undefined;
		return 0;
	}
	if(isdefined(behaviorTreeEntity.missingLegs) && behaviorTreeEntity.missingLegs)
	{
		behaviorTreeEntity.attackable = undefined;
		return 0;
	}
	if(isdefined(behaviorTreeEntity.aat_turned) && behaviorTreeEntity.aat_turned)
	{
		behaviorTreeEntity.attackable = undefined;
		return 0;
	}
	if(!isdefined(behaviorTreeEntity.attackable))
	{
		behaviorTreeEntity.attackable = zm_attackables::get_attackable();
	}
	else if(!(isdefined(behaviorTreeEntity.attackable.is_active) && behaviorTreeEntity.attackable.is_active))
	{
		behaviorTreeEntity.attackable = undefined;
	}
}

/*
	Name: zombieMoveToEntranceAction
	Namespace: zm_behavior
	Checksum: 0x8AFC9819
	Offset: 0x4650
	Size: 0x3F
	Parameters: 2
	Flags: None
*/
function zombieMoveToEntranceAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.got_to_entrance = 0;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieMoveToEntranceActionTerminate
	Namespace: zm_behavior
	Checksum: 0x75B055A5
	Offset: 0x4698
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function zombieMoveToEntranceActionTerminate(behaviorTreeEntity, asmStateName)
{
	if(zombieIsAtEntrance(behaviorTreeEntity))
	{
		behaviorTreeEntity.got_to_entrance = 1;
	}
	return 4;
}

/*
	Name: zombieMoveToAttackSpotAction
	Namespace: zm_behavior
	Checksum: 0x1F82E0B4
	Offset: 0x46E8
	Size: 0x3F
	Parameters: 2
	Flags: None
*/
function zombieMoveToAttackSpotAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.at_entrance_tear_spot = 0;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieMoveToAttackSpotActionTerminate
	Namespace: zm_behavior
	Checksum: 0xF92A0A96
	Offset: 0x4730
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function zombieMoveToAttackSpotActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.at_entrance_tear_spot = 1;
	return 4;
}

/*
	Name: zombieHoldBoardAction
	Namespace: zm_behavior
	Checksum: 0x41BB5012
	Offset: 0x4768
	Size: 0x11F
	Parameters: 2
	Flags: None
*/
function zombieHoldBoardAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 1;
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_which_board_pull", Int(behaviorTreeEntity.chunk));
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_board_attack_spot", float(behaviorTreeEntity.attacking_spot_index));
	boardActionAST = behaviorTreeEntity ASTSearch(istring(asmStateName));
	boardActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(behaviorTreeEntity, boardActionAST["animation"]);
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieHoldBoardActionTerminate
	Namespace: zm_behavior
	Checksum: 0xAB24CB44
	Offset: 0x4890
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function zombieHoldBoardActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 0;
	return 4;
}

/*
	Name: zombieGrabBoardAction
	Namespace: zm_behavior
	Checksum: 0x923D69E9
	Offset: 0x48C0
	Size: 0x11F
	Parameters: 2
	Flags: None
*/
function zombieGrabBoardAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 1;
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_which_board_pull", Int(behaviorTreeEntity.chunk));
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_board_attack_spot", float(behaviorTreeEntity.attacking_spot_index));
	boardActionAST = behaviorTreeEntity ASTSearch(istring(asmStateName));
	boardActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(behaviorTreeEntity, boardActionAST["animation"]);
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieGrabBoardActionTerminate
	Namespace: zm_behavior
	Checksum: 0x64E7B453
	Offset: 0x49E8
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function zombieGrabBoardActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 0;
	return 4;
}

/*
	Name: zombiePullBoardAction
	Namespace: zm_behavior
	Checksum: 0xFBF18931
	Offset: 0x4A18
	Size: 0x11F
	Parameters: 2
	Flags: None
*/
function zombiePullBoardAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 1;
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_which_board_pull", Int(behaviorTreeEntity.chunk));
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_board_attack_spot", float(behaviorTreeEntity.attacking_spot_index));
	boardActionAST = behaviorTreeEntity ASTSearch(istring(asmStateName));
	boardActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(behaviorTreeEntity, boardActionAST["animation"]);
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombiePullBoardActionTerminate
	Namespace: zm_behavior
	Checksum: 0x736701
	Offset: 0x4B40
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function zombiePullBoardActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 0;
	self.lastchunk_destroy_time = GetTime();
	return 4;
}

/*
	Name: zombieAttackThroughBoardsAction
	Namespace: zm_behavior
	Checksum: 0x58E79F43
	Offset: 0x4B80
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function zombieAttackThroughBoardsAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 1;
	behaviorTreeEntity.boardAttack = 1;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieAttackThroughBoardsActionTerminate
	Namespace: zm_behavior
	Checksum: 0x8A6207E6
	Offset: 0x4BE0
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function zombieAttackThroughBoardsActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 0;
	behaviorTreeEntity.boardAttack = 0;
	return 4;
}

/*
	Name: zombieTauntAction
	Namespace: zm_behavior
	Checksum: 0x3ABC6F11
	Offset: 0x4C20
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function zombieTauntAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 1;
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieTauntActionTerminate
	Namespace: zm_behavior
	Checksum: 0x59D094B0
	Offset: 0x4C70
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function zombieTauntActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.keepClaimedNode = 0;
	return 4;
}

/*
	Name: zombieMantleAction
	Namespace: zm_behavior
	Checksum: 0xBE001776
	Offset: 0x4CA0
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function zombieMantleAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.clampToNavMesh = 0;
	if(isdefined(behaviorTreeEntity.attacking_spot_index))
	{
		behaviorTreeEntity.saved_attacking_spot_index = behaviorTreeEntity.attacking_spot_index;
		blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_board_attack_spot", float(behaviorTreeEntity.attacking_spot_index));
	}
	behaviorTreeEntity.isInMantleAction = 1;
	behaviorTreeEntity zombie_utility::reset_attack_spot();
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieMantleActionTerminate
	Namespace: zm_behavior
	Checksum: 0xB1760FF1
	Offset: 0x4D78
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function zombieMantleActionTerminate(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity.clampToNavMesh = 1;
	behaviorTreeEntity.isInMantleAction = undefined;
	behaviorTreeEntity zm_behavior_utility::enteredPlayableArea();
	return 4;
}

/*
	Name: boardTearMocompStart
	Namespace: zm_behavior
	Checksum: 0x8711E137
	Offset: 0x4DD0
	Size: 0x173
	Parameters: 5
	Flags: None
*/
function boardTearMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	origin = GetStartOrigin(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim);
	angles = GetStartAngles(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim);
	entity ForceTeleport(origin, angles, 1);
	entity.pushable = 0;
	entity.blockingPain = 1;
	entity animMode("noclip", 1);
	entity OrientMode("face angle", angles[1]);
}

/*
	Name: boardTearMocompUpdate
	Namespace: zm_behavior
	Checksum: 0x612AB632
	Offset: 0x4F50
	Size: 0x6F
	Parameters: 5
	Flags: None
*/
function boardTearMocompUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("noclip", 0);
	entity.pushable = 0;
	entity.blockingPain = 1;
}

/*
	Name: barricadeEnterMocompStart
	Namespace: zm_behavior
	Checksum: 0xD25CFFE7
	Offset: 0x4FC8
	Size: 0x1DF
	Parameters: 5
	Flags: None
*/
function barricadeEnterMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	origin = GetStartOrigin(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim);
	angles = GetStartAngles(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim);
	if(isdefined(entity.mocomp_barricade_offset))
	{
		origin = origin + AnglesToForward(angles) * entity.mocomp_barricade_offset;
	}
	entity ForceTeleport(origin, angles, 1);
	entity animMode("noclip", 0);
	entity OrientMode("face angle", angles[1]);
	entity.pushable = 0;
	entity.blockingPain = 1;
	entity PathMode("dont move");
	entity.useGoalAnimWeight = 1;
}

/*
	Name: barricadeEnterMocompUpdate
	Namespace: zm_behavior
	Checksum: 0x10BF7C6C
	Offset: 0x51B0
	Size: 0x5B
	Parameters: 5
	Flags: None
*/
function barricadeEnterMocompUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("noclip", 0);
	entity.pushable = 0;
}

/*
	Name: barricadeEnterMocompTerminate
	Namespace: zm_behavior
	Checksum: 0x381E8F52
	Offset: 0x5218
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function barricadeEnterMocompTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.pushable = 1;
	entity.blockingPain = 0;
	entity PathMode("move allowed");
	entity.useGoalAnimWeight = 0;
	entity animMode("normal", 0);
	entity OrientMode("face motion");
}

/*
	Name: barricadeEnterMocompNoZStart
	Namespace: zm_behavior
	Checksum: 0xBB5320A
	Offset: 0x52E0
	Size: 0x217
	Parameters: 5
	Flags: None
*/
function barricadeEnterMocompNoZStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	zbarrier_origin = (entity.first_node.zbarrier.origin[0], entity.first_node.zbarrier.origin[1], entity.origin[2]);
	origin = GetStartOrigin(zbarrier_origin, entity.first_node.zbarrier.angles, mocompAnim);
	angles = GetStartAngles(zbarrier_origin, entity.first_node.zbarrier.angles, mocompAnim);
	if(isdefined(entity.mocomp_barricade_offset))
	{
		origin = origin + AnglesToForward(angles) * entity.mocomp_barricade_offset;
	}
	entity ForceTeleport(origin, angles, 1);
	entity animMode("noclip", 0);
	entity OrientMode("face angle", angles[1]);
	entity.pushable = 0;
	entity.blockingPain = 1;
	entity PathMode("dont move");
	entity.useGoalAnimWeight = 1;
}

/*
	Name: barricadeEnterMocompNoZUpdate
	Namespace: zm_behavior
	Checksum: 0xDCC5821C
	Offset: 0x5500
	Size: 0x5B
	Parameters: 5
	Flags: None
*/
function barricadeEnterMocompNoZUpdate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("noclip", 0);
	entity.pushable = 0;
}

/*
	Name: barricadeEnterMocompNoZTerminate
	Namespace: zm_behavior
	Checksum: 0x1B7D2016
	Offset: 0x5568
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function barricadeEnterMocompNoZTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.pushable = 1;
	entity.blockingPain = 0;
	entity PathMode("move allowed");
	entity.useGoalAnimWeight = 0;
	entity animMode("normal", 0);
	entity OrientMode("face motion");
}

/*
	Name: notetrackBoardTear
	Namespace: zm_behavior
	Checksum: 0x361F1351
	Offset: 0x5630
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function notetrackBoardTear(animationEntity)
{
	if(isdefined(animationEntity.chunk))
	{
		animationEntity.first_node.zbarrier SetZBarrierPieceState(animationEntity.chunk, "opening");
	}
}

/*
	Name: notetrackBoardMelee
	Namespace: zm_behavior
	Checksum: 0xE96DD3C0
	Offset: 0x5698
	Size: 0x2E3
	Parameters: 1
	Flags: None
*/
function notetrackBoardMelee(animationEntity)
{
	/#
		Assert(animationEntity.meleeWeapon != level.weaponNone, "Dev Block strings are not supported");
	#/
	if(isdefined(animationEntity.first_node))
	{
		meleeDistSq = 8100;
		if(isdefined(level.attack_player_thru_boards_range))
		{
			meleeDistSq = level.attack_player_thru_boards_range * level.attack_player_thru_boards_range;
		}
		triggerDistSq = 2601;
		for(i = 0; i < animationEntity.player_targets.size; i++)
		{
			playerDistSq = Distance2DSquared(animationEntity.player_targets[i].origin, animationEntity.origin);
			heightDiff = Abs(animationEntity.player_targets[i].origin[2] - animationEntity.origin[2]);
			if(playerDistSq < meleeDistSq && heightDiff * heightDiff < meleeDistSq)
			{
				playerTriggerDistSq = Distance2DSquared(animationEntity.player_targets[i].origin, animationEntity.first_node.trigger_location.origin);
				heightDiff = Abs(animationEntity.player_targets[i].origin[2] - animationEntity.first_node.trigger_location.origin[2]);
				if(playerTriggerDistSq < triggerDistSq && heightDiff * heightDiff < triggerDistSq)
				{
					animationEntity.player_targets[i] DoDamage(animationEntity.meleeWeapon.meleeDamage, animationEntity.origin, self, self, "none", "MOD_MELEE");
					break;
				}
			}
		}
	}
	else
	{
		animationEntity melee();
	}
}

/*
	Name: findZombieEnemy
	Namespace: zm_behavior
	Checksum: 0xB18B4352
	Offset: 0x5988
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function findZombieEnemy()
{
	zombies = GetAISpeciesArray(level.zombie_team, "all");
	zombie_enemy = undefined;
	closest_dist = undefined;
	foreach(zombie in zombies)
	{
		if(isalive(zombie) && (isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area) && !zm_utility::is_magic_bullet_shield_enabled(zombie) && (zombie.archetype == "zombie" || (isdefined(zombie.canBeTargetedByTurnedZombies) && zombie.canBeTargetedByTurnedZombies)))
		{
			dist = DistanceSquared(self.origin, zombie.origin);
			if(!isdefined(closest_dist) || dist < closest_dist)
			{
				closest_dist = dist;
				zombie_enemy = zombie;
			}
		}
	}
	self.favoriteenemy = zombie_enemy;
	if(isdefined(self.favoriteenemy))
	{
		self SetGoal(self.favoriteenemy.origin);
	}
	else
	{
		self SetGoal(self.origin);
	}
}

/*
	Name: zombieBlackHoleBombPullStart
	Namespace: zm_behavior
	Checksum: 0xEB2F342B
	Offset: 0x5BB0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function zombieBlackHoleBombPullStart(entity, asmStateName)
{
	entity.pullTime = GetTime();
	entity.pullOrigin = entity.origin;
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	zombieUpdateBlackHoleBombPullState(entity);
	if(isdefined(entity.damageOrigin))
	{
		entity.n_zombie_custom_goal_radius = 8;
		entity.v_zombie_custom_goal_pos = entity.damageOrigin;
	}
	return 5;
}

/*
	Name: zombieUpdateBlackHoleBombPullState
	Namespace: zm_behavior
	Checksum: 0x996AD1D3
	Offset: 0x5C78
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function zombieUpdateBlackHoleBombPullState(entity)
{
	dist_to_bomb = DistanceSquared(entity.origin, entity.damageOrigin);
	if(dist_to_bomb < 16384)
	{
		entity._black_hole_bomb_collapse_death = 1;
	}
	else if(dist_to_bomb < 1048576)
	{
		blackboard::SetBlackBoardAttribute(entity, "_zombie_blackholebomb_pull_state", "bhb_pull_fast");
	}
	else if(dist_to_bomb < 4227136)
	{
		blackboard::SetBlackBoardAttribute(entity, "_zombie_blackholebomb_pull_state", "bhb_pull_slow");
	}
}

/*
	Name: zombieBlackHoleBombPullUpdate
	Namespace: zm_behavior
	Checksum: 0x2D538B78
	Offset: 0x5D58
	Size: 0x253
	Parameters: 2
	Flags: None
*/
function zombieBlackHoleBombPullUpdate(entity, asmStateName)
{
	if(!isdefined(entity.interdimensional_gun_kill))
	{
		return 4;
	}
	zombieUpdateBlackHoleBombPullState(entity);
	if(isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death)
	{
		entity.skipAutoRagdoll = 1;
		entity DoDamage(entity.health + 666, entity.origin + VectorScale((0, 0, 1), 50), entity.interdimensional_gun_attacker, undefined, undefined, "MOD_CRUSH");
		return 4;
	}
	if(isdefined(entity.damageOrigin))
	{
		entity.v_zombie_custom_goal_pos = entity.damageOrigin;
	}
	if(!isdefined(entity.missingLegs) && entity.missingLegs && GetTime() - entity.pullTime > 1000)
	{
		distSq = Distance2DSquared(entity.origin, entity.pullOrigin);
		if(distSq < 144)
		{
			entity SetAvoidanceMask("avoid all");
			entity.cant_move = 1;
			if(isdefined(entity.cant_move_cb))
			{
				entity [[entity.cant_move_cb]]();
			}
		}
		else
		{
			entity SetAvoidanceMask("avoid none");
			entity.cant_move = 0;
		}
		entity.pullTime = GetTime();
		entity.pullOrigin = entity.origin;
	}
	return 5;
}

/*
	Name: zombieBlackHoleBombPullEnd
	Namespace: zm_behavior
	Checksum: 0x8D024D9C
	Offset: 0x5FB8
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function zombieBlackHoleBombPullEnd(entity, asmStateName)
{
	entity.v_zombie_custom_goal_pos = undefined;
	entity.n_zombie_custom_goal_radius = undefined;
	entity.pullTime = undefined;
	entity.pullOrigin = undefined;
	return 4;
}

/*
	Name: zombieKilledWhileGettingPulled
	Namespace: zm_behavior
	Checksum: 0xEF6E5CCD
	Offset: 0x6010
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function zombieKilledWhileGettingPulled(entity)
{
	if(!isdefined(self.missingLegs) && self.missingLegs && (isdefined(entity.interdimensional_gun_kill) && entity.interdimensional_gun_kill) && (!isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieKilledByBlackHoleBombCondition
	Namespace: zm_behavior
	Checksum: 0x2D8D7F2E
	Offset: 0x6090
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zombieKilledByBlackHoleBombCondition(entity)
{
	if(isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death)
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieKilledByBlackHoleBombStart
	Namespace: zm_behavior
	Checksum: 0x52260EFF
	Offset: 0x60D8
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function zombieKilledByBlackHoleBombStart(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	if(isdefined(level.black_hole_bomb_death_start_func))
	{
		entity thread [[level.black_hole_bomb_death_start_func]](entity.damageOrigin, entity.interdimensional_gun_projectile);
	}
	return 5;
}

/*
	Name: zombieKilledByBlackHoleBombEnd
	Namespace: zm_behavior
	Checksum: 0xD775C87C
	Offset: 0x6148
	Size: 0xD7
	Parameters: 2
	Flags: None
*/
function zombieKilledByBlackHoleBombEnd(entity, asmStateName)
{
	if(isdefined(level._effect) && isdefined(level._effect["black_hole_bomb_zombie_gib"]))
	{
		fxOrigin = entity GetTagOrigin("tag_origin");
		FORWARD = AnglesToForward(entity.angles);
		playFX(level._effect["black_hole_bomb_zombie_gib"], fxOrigin, FORWARD, (0, 0, 1));
	}
	entity Hide();
	return 4;
}

/*
	Name: zombieBHBBurst
	Namespace: zm_behavior
	Checksum: 0xBA70F331
	Offset: 0x6228
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function zombieBHBBurst(entity)
{
	if(isdefined(level._effect) && isdefined(level._effect["black_hole_bomb_zombie_destroy"]))
	{
		fxOrigin = entity GetTagOrigin("tag_origin");
		playFX(level._effect["black_hole_bomb_zombie_destroy"], fxOrigin);
	}
	if(isdefined(entity.interdimensional_gun_projectile))
	{
		entity.interdimensional_gun_projectile notify("black_hole_bomb_kill");
	}
}

