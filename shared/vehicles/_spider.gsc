#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace Spider;

/*
	Name: __init__sytem__
	Namespace: Spider
	Checksum: 0xFB465612
	Offset: 0x350
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spider", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: Spider
	Checksum: 0xAA565A33
	Offset: 0x390
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("spider", &spider_initialize);
	/#
		SetDvar("Dev Block strings are not supported", 0);
	#/
}

/*
	Name: NO_SWITCH_ON
	Namespace: Spider
	Checksum: 0x32AB2CBD
	Offset: 0x3E8
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function NO_SWITCH_ON()
{
	return GetDvarInt("debug_spider_noswitch", 0) === 1;
}

/*
	Name: spider_initialize
	Namespace: Spider
	Checksum: 0x1952E919
	Offset: 0x410
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function spider_initialize()
{
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.delete_on_death = 1;
	self.health = self.healthdefault;
	self useanimtree(-1);
	self vehicle::friendly_fire_shield();
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self EnableAimAssist();
	self SetDrawInfrared(1);
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self SetNearGoalNotifyDist(40);
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self SetOnTargetAngle(3);
	self.overrideVehicleDamage = &spider_callback_damage;
	self thread vehicle_ai::nudge_collision();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	self ASMRequestSubstate("locomotion@movement");
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: Spider
	Checksum: 0x9B5F24ED
	Offset: 0x628
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_range_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::get_state_callbacks("driving").update_func = &state_driving_update;
	self vehicle_ai::add_state("meleeCombat", undefined, &state_melee_combat_update, undefined);
	vehicle_ai::add_utility_connection("combat", "meleeCombat", &should_switch_to_melee);
	vehicle_ai::add_utility_connection("meleeCombat", "combat", &should_switch_to_range);
	self vehicle_ai::call_custom_add_state_callbacks();
	vehicle_ai::StartInitialState("combat");
}

/*
	Name: state_death_update
	Namespace: Spider
	Checksum: 0x61AFD353
	Offset: 0x7A0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	self ASMRequestSubstate("death@stationary");
	vehicle_ai::waittill_asm_complete("death@stationary", 2);
	self vehicle_death::death_fx();
	vehicle_death::DeleteWhenSafe(10);
}

/*
	Name: state_driving_update
	Namespace: Spider
	Checksum: 0xDC28D17D
	Offset: 0x830
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function state_driving_update(params)
{
	self endon("change_state");
	self endon("death");
	self ASMRequestSubstate("locomotion@aggressive");
}

/*
	Name: GetNextMovePosition_ranged
	Namespace: Spider
	Checksum: 0x69692A0
	Offset: 0x878
	Size: 0x651
	Parameters: 1
	Flags: None
*/
function GetNextMovePosition_ranged(enemy)
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	selfDistToTarget = Distance2D(self.origin, enemy.origin);
	goodDist = 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	tooCloseDist = 150;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedDistAwayFromOrigin = 300;
	randomness = 30;
	queryResult = PositionQuery_Source_Navigation(self.origin, 80, 300 * queryMultiplier, 150, 2 * self.radius * queryMultiplier, self, 1 * self.radius * queryMultiplier);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	PositionQuery_Filter_InClaimedLocation(queryResult, self);
	vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, enemy, self.settings.engagementDistMin, self.settings.engagementDistMax);
	if(isdefined(self.avoidEntities) && isdefined(self.avoidEntitiesDistance))
	{
		vehicle_ai::PositionQuery_Filter_DistAwayFromTarget(queryResult, self.avoidEntities, self.avoidEntitiesDistance, -500);
	}
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryResult.data)
	{
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = mapfloat(0, preferedDistAwayFromOrigin, 0, 300, point.distToOrigin2D);
		#/
		point.score = point.score + mapfloat(0, preferedDistAwayFromOrigin, 0, 300, point.distToOrigin2D);
		if(point.inclaimedlocation)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -500;
			#/
			point.score = point.score + -500;
		}
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = RandomFloatRange(0, randomness);
		#/
		point.score = point.score + RandomFloatRange(0, randomness);
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = point.distAwayFromEngagementArea * -1;
		#/
		point.score = point.score + point.distAwayFromEngagementArea * -1;
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	/#
		self.debug_ai_move_to_points_considered = queryResult.data;
	#/
	if(!isdefined(best_point))
	{
		return undefined;
	}
	/#
		if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
		{
			recordLine(self.origin, best_point.origin, (0.3, 1, 0));
			recordLine(self.origin, enemy.origin, (1, 0, 0.4));
		}
	#/
	return best_point.origin;
}

/*
	Name: state_range_combat_update
	Namespace: Spider
	Checksum: 0xE0FACE9A
	Offset: 0xED8
	Size: 0x2A7
	Parameters: 1
	Flags: None
*/
function state_range_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	self.pathfailcount = 0;
	self.foundpath = 1;
	if(params.playTransition === 1)
	{
		self vehicle_ai::ClearAllMovement(1);
		self ASMRequestSubstate("exit@aggressive");
		self vehicle_ai::waittill_asm_complete("exit@aggressive", 1.6);
	}
	self vehicle_ai::Cooldown("state_change", 15);
	self thread prevent_stuck();
	self thread nudge_collision();
	self thread state_range_combat_attack();
	self SetSpeed(self.settings.defaultMoveSpeed);
	self ASMRequestSubstate("locomotion@movement");
	self.dont_move = undefined;
	while(!isdefined(self.enemy))
	{
		self force_get_enemies();
		wait(0.1);
		continue;
		continue;
		if(self.dont_move === 1)
		{
			wait(0.1);
		}
		else if(isdefined(self.can_reach_enemy))
		{
			if(!self [[self.can_reach_enemy]]())
			{
				wait(0.1);
			}
		}
		else
		{
			self.current_pathto_pos = spider_get_target_position();
			else
			{
				self.current_pathto_pos = GetNextMovePosition_ranged(self.enemy);
			}
			if(isdefined(self.current_pathto_pos))
			{
				if(self SetVehGoalPos(self.current_pathto_pos, 0, 1))
				{
					self vehicle_ai::waittill_pathing_done();
				}
			}
			wait(0.05);
		}
		else if(!self vehseenrecently(self.enemy, 5))
		{
		}
	}
}

/*
	Name: state_range_combat_attack
	Namespace: Spider
	Checksum: 0xD6EFBA40
	Offset: 0x1188
	Size: 0x2C7
	Parameters: 0
	Flags: None
*/
function state_range_combat_attack()
{
	self endon("change_state");
	self endon("death");
	while(!isdefined(self.enemy))
	{
		wait(0.1);
		continue;
		state_params = spawnstruct();
		state_params.playTransition = 1;
		self vehicle_ai::evaluate_connections(undefined, state_params);
		can_attack = 1;
		foreach(player in level.players)
		{
			self GetPerfectInfo(player, 0);
			if(player.b_is_designated_target === 1 && self.enemy.b_is_designated_target !== 1)
			{
				self GetPerfectInfo(player, 1);
				self SetPersonalThreatBias(player, 100000, 2);
				can_attack = 0;
			}
		}
		if(can_attack)
		{
			if(self VehCanSee(self.enemy))
			{
				self SetLookAtEnt(self.enemy);
				self SetTurretTargetEnt(self.enemy);
			}
			if(Distance2DSquared(self.origin, self.enemy.origin) < self.settings.engagementDistMax * 1.5 * self.settings.engagementDistMax * 1.5 && vehicle_ai::IsCooldownReady("rocket") && self VehCanSee(self.enemy))
			{
				self do_ranged_attack(self.enemy);
				wait(0.5);
			}
		}
		wait(0.1);
	}
}

/*
	Name: do_ranged_attack
	Namespace: Spider
	Checksum: 0x35ACDA79
	Offset: 0x1458
	Size: 0x2CD
	Parameters: 1
	Flags: None
*/
function do_ranged_attack(enemy)
{
	self notify("near_goal");
	self vehicle_ai::ClearAllMovement(1);
	self.dont_move = 1;
	self SetLookAtEnt(enemy);
	self SetTurretTargetEnt(enemy);
	self SetVehGoalPos(enemy.origin, 0, 0);
	targetAngleDiff = 30;
	v_to_enemy = (enemy.origin - self.origin[0], enemy.origin - self.origin[1], 0);
	goalAngles = VectorToAngles(v_to_enemy);
	angleDiff = AbsAngleClamp180(self.angles[1] - goalAngles[1]);
	angleAdjustingStart = GetTime();
	while(angleDiff > targetAngleDiff && vehicle_ai::TimeSince(angleAdjustingStart) < 0.8)
	{
		angleDiff = AbsAngleClamp180(self.angles[1] - goalAngles[1]);
		wait(0.05);
	}
	self vehicle_ai::ClearAllMovement(1);
	if(angleDiff <= targetAngleDiff)
	{
		self ASMRequestSubstate("fire@stationary");
		timedOut = self util::waittill_notify_or_timeout("spider_fire", 5);
		if(timedOut !== 1)
		{
			self FireWeapon();
			self vehicle_ai::Cooldown("rocket", 3);
			self vehicle_ai::waittill_asm_complete("fire@stationary", 5);
		}
	}
	self ASMRequestSubstate("locomotion@movement");
	self.dont_move = undefined;
}

/*
	Name: switch_to_melee
	Namespace: Spider
	Checksum: 0xD491A878
	Offset: 0x1730
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function switch_to_melee()
{
	self.switch_to_melee = 1;
}

/*
	Name: should_switch_to_melee
	Namespace: Spider
	Checksum: 0xEEF46B8B
	Offset: 0x1748
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function should_switch_to_melee(from_state, to_state, connection)
{
	/#
		if(NO_SWITCH_ON())
		{
			return 0;
		}
	#/
	if(!vehicle_ai::IsCooldownReady("state_change"))
	{
		return 0;
	}
	if(!isdefined(self.enemy))
	{
		return 0;
	}
	if(self.switch_to_melee === 1 || (Distance2DSquared(self.origin, self.enemy.origin) < self.settings.meleeDist * self.settings.meleeDist && Abs(self.origin[2] - self.enemy.origin[2]) < self.settings.meleeDist))
	{
		return 1;
	}
	return 0;
}

/*
	Name: state_melee_combat_update
	Namespace: Spider
	Checksum: 0x3983F88B
	Offset: 0x1868
	Size: 0x8FB
	Parameters: 1
	Flags: None
*/
function state_melee_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	if(params.playTransition === 1)
	{
		self vehicle_ai::ClearAllMovement(1);
		self ASMRequestSubstate("enter@aggressive");
		self vehicle_ai::waittill_asm_complete("enter@aggressive", 1.6);
	}
	self vehicle_ai::Cooldown("state_change", 8);
	self thread prevent_stuck();
	self thread nudge_collision();
	self thread state_melee_combat_attack();
	self.pathfailcount = 0;
	self.switch_to_melee = undefined;
	self SetSpeed(self.settings.defaultMoveSpeed * 1.5);
	self ASMRequestSubstate("locomotion@aggressive");
	self.dont_move = undefined;
	wait(0.5);
	for(;;)
	{
		foreach(player in level.players)
		{
			self GetPerfectInfo(player, 1);
			if(player.b_is_designated_target === 1)
			{
				self SetPersonalThreatBias(player, 100000, 3);
			}
		}
		if(!isdefined(self.enemy))
		{
			self force_get_enemies();
			wait(0.1);
			continue;
		}
		else if(self.dont_move === 1)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.can_reach_enemy))
		{
			if(!self [[self.can_reach_enemy]]())
			{
				wait(0.1);
				continue;
			}
		}
		self.foundpath = 0;
		targetPos = spider_get_target_position();
		if(isdefined(targetPos))
		{
			if(DistanceSquared(self.origin, targetPos) > 1000 * 1000 && self IsPosInClaimedLocation(targetPos))
			{
				queryResult = PositionQuery_Source_Navigation(targetPos, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self);
				PositionQuery_Filter_InClaimedLocation(queryResult, self.enemy);
				best_point = undefined;
				best_score = -999999;
				foreach(point in queryResult.data)
				{
					/#
						if(!isdefined(point._scoreDebug))
						{
							point._scoreDebug = [];
						}
						point._scoreDebug["Dev Block strings are not supported"] = mapfloat(0, 200, 0, -200, Distance(point.origin, queryResult.origin));
					#/
					point.score = point.score + mapfloat(0, 200, 0, -200, Distance(point.origin, queryResult.origin));
					/#
						if(!isdefined(point._scoreDebug))
						{
							point._scoreDebug = [];
						}
						point._scoreDebug["Dev Block strings are not supported"] = mapfloat(50, 200, 0, -200, Abs(point.origin[2] - queryResult.origin[2]));
					#/
					point.score = point.score + mapfloat(50, 200, 0, -200, Abs(point.origin[2] - queryResult.origin[2]));
					if(point.inclaimedlocation === 1)
					{
						/#
							if(!isdefined(point._scoreDebug))
							{
								point._scoreDebug = [];
							}
							point._scoreDebug["Dev Block strings are not supported"] = -500;
						#/
						point.score = point.score + -500;
					}
					if(point.score > best_score)
					{
						best_score = point.score;
						best_point = point;
					}
				}
				self vehicle_ai::PositionQuery_DebugScores(queryResult);
				if(isdefined(best_point))
				{
					targetPos = best_point.origin;
				}
			}
			self SetVehGoalPos(targetPos, 0, 1);
			self.foundpath = self vehicle_ai::waittill_pathresult();
			if(self.foundpath)
			{
				self.current_pathto_pos = targetPos;
				self thread path_update_interrupt_melee();
				self.pathfailcount = 0;
				self vehicle_ai::waittill_pathing_done();
			}
		}
		if(!self.foundpath)
		{
			self.pathfailcount++;
			if(self.pathfailcount > 2)
			{
				if(isdefined(self.enemy))
				{
					self SetPersonalThreatBias(self.enemy, -2000, 5);
				}
			}
			wait(0.1);
			queryResult = PositionQuery_Source_Navigation(self.origin, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self);
			if(queryResult.data.size)
			{
				point = queryResult.data[RandomInt(queryResult.data.size)];
				self SetVehGoalPos(point.origin, 0, 0);
				self.current_pathto_pos = undefined;
				self thread path_update_interrupt_melee();
				wait(2);
				self notify("near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: state_melee_combat_attack
	Namespace: Spider
	Checksum: 0xADCEEDE5
	Offset: 0x2170
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function state_melee_combat_attack()
{
	self endon("change_state");
	self endon("death");
	for(;;)
	{
		state_params = spawnstruct();
		state_params.playTransition = 1;
		if(!isdefined(self.enemy))
		{
			wait(0.1);
			self vehicle_ai::evaluate_connections(undefined, state_params);
			continue;
		}
		self vehicle_ai::evaluate_connections(undefined, state_params);
		if(self VehCanSee(self.enemy))
		{
			self SetLookAtEnt(self.enemy);
			self SetTurretTargetEnt(self.enemy);
		}
		if(Distance2DSquared(self.origin, self.enemy.origin) < self.settings.meleereach * self.settings.meleereach && self VehCanSee(self.enemy))
		{
			if(BulletTracePassed(self.origin + VectorScale((0, 0, 1), 10), self.enemy.origin + VectorScale((0, 0, 1), 20), 0, self, self.enemy, 0, 1))
			{
				self do_melee_attack(self.enemy);
				wait(0.5);
			}
		}
		wait(0.1);
	}
}

/*
	Name: do_melee_attack
	Namespace: Spider
	Checksum: 0xEC940C78
	Offset: 0x2370
	Size: 0x185
	Parameters: 1
	Flags: None
*/
function do_melee_attack(enemy)
{
	self notify("near_goal");
	self vehicle_ai::ClearAllMovement(1);
	self.dont_move = 1;
	self ASMRequestSubstate("melee@stationary");
	timedOut = self util::waittill_notify_or_timeout("spider_melee", 3);
	if(timedOut !== 1)
	{
		if(isalive(enemy) && Distance2DSquared(self.origin, enemy.origin) < self.settings.meleereach * 1.2 * self.settings.meleereach * 1.2)
		{
			enemy DoDamage(self.settings.meleeDamage, self.origin, self, self);
		}
		self vehicle_ai::waittill_asm_complete("melee@stationary", 2);
	}
	self ASMRequestSubstate("locomotion@aggressive");
	self.dont_move = undefined;
}

/*
	Name: should_switch_to_range
	Namespace: Spider
	Checksum: 0x923EA3B9
	Offset: 0x2500
	Size: 0xFF
	Parameters: 3
	Flags: None
*/
function should_switch_to_range(from_state, to_state, connection)
{
	/#
		if(NO_SWITCH_ON())
		{
			return 0;
		}
	#/
	if(self.pathfailcount > 4)
	{
		return 1;
	}
	if(!vehicle_ai::IsCooldownReady("state_change"))
	{
		return 0;
	}
	if(isalive(self.enemy) && Distance2DSquared(self.origin, self.enemy.origin) > self.settings.meleeDist * 4 * self.settings.meleeDist * 4)
	{
		return 1;
	}
	if(!isdefined(self.enemy))
	{
		return 1;
	}
	return 0;
}

/*
	Name: prevent_stuck
	Namespace: Spider
	Checksum: 0xCFA6C105
	Offset: 0x2608
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function prevent_stuck()
{
	self endon("change_state");
	self endon("death");
	self notify("end_prevent_stuck");
	self endon("end_prevent_stuck");
	wait(2);
	count = 0;
	previous_origin = undefined;
	while(1)
	{
		if(isdefined(previous_origin) && DistanceSquared(previous_origin, self.origin) < 0.1 * 0.1 && (!isdefined(level.bzm_worldPaused) && level.bzm_worldPaused))
		{
			count++;
		}
		else
		{
			previous_origin = self.origin;
			count = 0;
		}
		if(count > 10)
		{
			self.pathfailcount = 10;
		}
		wait(1);
	}
}

/*
	Name: spider_get_target_position
	Namespace: Spider
	Checksum: 0xB8164971
	Offset: 0x2710
	Size: 0x375
	Parameters: 0
	Flags: None
*/
function spider_get_target_position()
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	if(isdefined(self.settings.all_knowing))
	{
		if(isdefined(self.enemy))
		{
			target_pos = self.enemy.origin;
		}
	}
	else
	{
		target_pos = vehicle_ai::GetTargetPos(vehicle_ai::GetEnemyTarget());
	}
	enemy = self.enemy;
	if(isdefined(target_pos))
	{
		target_pos_onnavmesh = GetClosestPointOnNavMesh(target_pos, self.settings.detonation_distance * 1.5, self.radius, 16777183);
	}
	if(!isdefined(target_pos_onnavmesh))
	{
		if(isdefined(self.enemy))
		{
			self SetPersonalThreatBias(self.enemy, -2000, 5);
		}
		if(isdefined(self.current_pathto_pos) && DistanceSquared(self.origin, self.current_pathto_pos) > self.settings.meleereach * self.settings.meleereach)
		{
			return self.current_pathto_pos;
		}
		else
		{
			return undefined;
		}
	}
	else if(isdefined(self.enemy))
	{
		if(DistanceSquared(target_pos, target_pos_onnavmesh) > self.settings.detonation_distance * 0.9 * self.settings.detonation_distance * 0.9)
		{
			self SetPersonalThreatBias(self.enemy, -2000, 5);
		}
	}
	if(isdefined(enemy) && isPlayer(enemy))
	{
		enemy_vel_offset = enemy GetVelocity() * 0.5;
		enemy_look_dir_offset = AnglesToForward(enemy.angles);
		if(Distance2DSquared(self.origin, enemy.origin) > 500 * 500)
		{
			enemy_look_dir_offset = enemy_look_dir_offset * 110;
		}
		else
		{
			enemy_look_dir_offset = enemy_look_dir_offset * 35;
		}
		offset = enemy_vel_offset + enemy_look_dir_offset;
		offset = (offset[0], offset[1], 0);
		if(TracePassedOnNavMesh(target_pos_onnavmesh, target_pos + offset))
		{
			target_pos = target_pos + offset;
		}
		else
		{
			target_pos = target_pos_onnavmesh;
		}
	}
	else
	{
		target_pos = target_pos_onnavmesh;
	}
	return target_pos;
}

/*
	Name: path_update_interrupt_melee
	Namespace: Spider
	Checksum: 0x18AF3342
	Offset: 0x2A90
	Size: 0x2E3
	Parameters: 0
	Flags: None
*/
function path_update_interrupt_melee()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	self notify("clear_interrupt_threads");
	self endon("clear_interrupt_threads");
	wait(0.1);
	while(1)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(Distance2DSquared(self.current_pathto_pos, self.goalpos) > self.goalRadius * self.goalRadius)
			{
				wait(0.5);
				self notify("near_goal");
			}
			targetPos = spider_get_target_position();
			if(isdefined(targetPos))
			{
				if(DistanceSquared(self.origin, targetPos) > 1000 * 1000)
				{
					repath_range = self.settings.repath_range * 2;
					wait(0.1);
				}
				else
				{
					repath_range = self.settings.repath_range;
				}
				if(Distance2DSquared(self.current_pathto_pos, targetPos) > repath_range * repath_range)
				{
					self notify("near_goal");
				}
			}
			if(isdefined(self.enemy) && isPlayer(self.enemy))
			{
				FORWARD = AnglesToForward(self.enemy getPlayerAngles());
				dir_to_raps = self.origin - self.enemy.origin;
				speedToUse = self.settings.defaultMoveSpeed * 2;
				if(VectorDot(FORWARD, dir_to_raps) > 0)
				{
					self SetSpeed(speedToUse);
				}
				else
				{
					self SetSpeed(speedToUse * 0.75);
				}
			}
			else
			{
				speedToUse = self.settings.defaultMoveSpeed * 2;
				self SetSpeed(speedToUse);
			}
			wait(0.2);
		}
		else
		{
			wait(0.4);
		}
	}
}

/*
	Name: nudge_collision
	Namespace: Spider
	Checksum: 0xB9B69B7C
	Offset: 0x2D80
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function nudge_collision()
{
	self endon("death");
	self endon("change_state");
	self notify("end_nudge_collision");
	self endon("end_nudge_collision");
	while(1)
	{
		self waittill("veh_collision", velocity, normal);
		ang_vel = self GetAngularVelocity() * 0.8;
		self SetAngularVelocity(ang_vel);
		if(isalive(self) && VectorDot(normal, (0, 0, 1)) < 0.5)
		{
			self SetVehVelocity(self.velocity + normal * 400);
		}
	}
}

/*
	Name: force_get_enemies
	Namespace: Spider
	Checksum: 0xB66F8F33
	Offset: 0x2EA0
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function force_get_enemies()
{
	foreach(player in level.players)
	{
		if(self util::IsEnemyPlayer(player) && !player.ignoreme)
		{
			self GetPerfectInfo(player, 1);
			return;
		}
	}
}

/*
	Name: spider_callback_damage
	Namespace: Spider
	Checksum: 0xCA469211
	Offset: 0x2F68
	Size: 0xB7
	Parameters: 15
	Flags: None
*/
function spider_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(isalive(eAttacker) && eAttacker.team === self.team)
	{
		return 0;
	}
	return iDamage;
}

