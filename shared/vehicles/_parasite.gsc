#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace parasite;

/*
	Name: __init__sytem__
	Namespace: parasite
	Checksum: 0x5E487077
	Offset: 0x480
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("parasite", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: parasite
	Checksum: 0x68CC67BE
	Offset: 0x4C0
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("parasite", &parasite_initialize);
	clientfield::register("vehicle", "parasite_tell_fx", 1, 1, "int");
	clientfield::register("vehicle", "parasite_secondary_deathfx", 1, 1, "int");
	clientfield::register("toplayer", "parasite_damage", 1, 1, "counter");
	callback::on_spawned(&parasite_damage);
	ai::RegisterMatchedInterface("parasite", "firing_rate", "slow", Array("slow", "medium", "fast"));
}

/*
	Name: parasite_damage
	Namespace: parasite
	Checksum: 0x9B4FF9FC
	Offset: 0x5F8
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function parasite_damage()
{
	self notify("parasite_damage_thread");
	self endon("parasite_damage_thread");
	self endon("death");
	while(1)
	{
		self waittill("damage", n_ammount, e_attacker);
		if(isdefined(e_attacker) && (isdefined(e_attacker.is_parasite) && e_attacker.is_parasite) && (!isdefined(e_attacker.squelch_damage_overlay) && e_attacker.squelch_damage_overlay))
		{
			self clientfield::increment_to_player("parasite_damage");
		}
	}
}

/*
	Name: is_target_valid
	Namespace: parasite
	Checksum: 0xA9E4AAC1
	Offset: 0x6D0
	Size: 0x117
	Parameters: 1
	Flags: Private
*/
function private is_target_valid(target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(isPlayer(target) && target.sessionstate == "spectator")
	{
		return 0;
	}
	if(isPlayer(target) && target.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return 0;
	}
	if(target IsNoTarget())
	{
		return 0;
	}
	if(isdefined(self.is_target_valid_cb))
	{
		return self [[self.is_target_valid_cb]](target);
	}
	return 1;
}

/*
	Name: get_parasite_enemy
	Namespace: parasite
	Checksum: 0xE03E2B16
	Offset: 0x7F0
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function get_parasite_enemy()
{
	parasite_targets = GetPlayers();
	least_hunted = parasite_targets[0];
	for(i = 0; i < parasite_targets.size; i++)
	{
		if(!isdefined(parasite_targets[i].hunted_by))
		{
			parasite_targets[i].hunted_by = 0;
		}
		if(!is_target_valid(parasite_targets[i]))
		{
			continue;
		}
		if(!is_target_valid(least_hunted))
		{
			least_hunted = parasite_targets[i];
		}
		if(parasite_targets[i].hunted_by < least_hunted.hunted_by)
		{
			least_hunted = parasite_targets[i];
		}
	}
	if(!is_target_valid(least_hunted))
	{
		return undefined;
	}
	else
	{
		return least_hunted;
	}
}

/*
	Name: set_parasite_enemy
	Namespace: parasite
	Checksum: 0x65ED600E
	Offset: 0x938
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function set_parasite_enemy(enemy)
{
	if(!is_target_valid(enemy))
	{
		return;
	}
	if(isdefined(self.parasiteEnemy))
	{
		if(!isdefined(self.parasiteEnemy.hunted_by))
		{
			self.parasiteEnemy.hunted_by = 0;
		}
		if(self.parasiteEnemy.hunted_by > 0)
		{
			self.parasiteEnemy.hunted_by--;
		}
	}
	self.parasiteEnemy = enemy;
	if(!isdefined(self.parasiteEnemy.hunted_by))
	{
		self.parasiteEnemy.hunted_by = 0;
	}
	self.parasiteEnemy.hunted_by++;
	self SetLookAtEnt(self.parasiteEnemy);
	self SetTurretTargetEnt(self.parasiteEnemy);
}

/*
	Name: parasite_target_selection
	Namespace: parasite
	Checksum: 0x30175CB4
	Offset: 0xA48
	Size: 0x117
	Parameters: 0
	Flags: Private
*/
function private parasite_target_selection()
{
	self endon("change_state");
	self endon("death");
	while(isdefined(self.ignoreall) && self.ignoreall)
	{
		wait(0.5);
		continue;
		if(is_target_valid(self.parasiteEnemy))
		{
			wait(0.5);
		}
		else
		{
			target = get_parasite_enemy();
			if(!isdefined(target))
			{
				self.parasiteEnemy = undefined;
			}
			else
			{
				self.parasiteEnemy = target;
				self.parasiteEnemy.hunted_by = self.parasiteEnemy.hunted_by + 1;
				self SetLookAtEnt(self.parasiteEnemy);
				self SetTurretTargetEnt(self.parasiteEnemy);
			}
			wait(0.5);
		}
	}
}

/*
	Name: parasite_initialize
	Namespace: parasite
	Checksum: 0x7AA832E2
	Offset: 0xB68
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function parasite_initialize()
{
	self useanimtree(-1);
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	ai::CreateInterfaceForEntity(self);
	blackboard::RegisterBlackBoardAttribute(self, "_parasite_firing_rate", "slow", &getParasiteFiringRate);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist(25);
	self SetDrawInfrared(1);
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.vehAirCraftCollisionEnabled = 1;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 999999;
	self.goalHeight = 4000;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.is_parasite = 1;
	self thread vehicle_ai::nudge_collision();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: parasite
	Checksum: 0x62C42A9D
	Offset: 0xDC0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::call_custom_add_state_callbacks();
	vehicle_ai::StartInitialState("combat");
}

/*
	Name: getParasiteFiringRate
	Namespace: parasite
	Checksum: 0xBD541FA4
	Offset: 0xEB0
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function getParasiteFiringRate()
{
	return self ai::get_behavior_attribute("firing_rate");
}

/*
	Name: state_death_update
	Namespace: parasite
	Checksum: 0x6284F85C
	Offset: 0xEE0
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	self ASMRequestSubstate("death@stationary");
	if(isdefined(self.parasiteEnemy) && isdefined(self.parasiteEnemy.hunted_by))
	{
		self.parasiteEnemy.hunted_by--;
	}
	self SetPhysAcceleration(VectorScale((0, 0, -1), 300));
	self.vehcheckforpredictedcrash = 1;
	self thread vehicle_death::death_fx();
	self playsound("zmb_parasite_explo");
	self util::waittill_notify_or_timeout("veh_predictedcollision", 4);
	self clientfield::set("parasite_secondary_deathfx", 1);
	wait(0.2);
	self delete();
}

/*
	Name: state_combat_enter
	Namespace: parasite
	Checksum: 0x5DD13A44
	Offset: 0x1018
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function state_combat_enter(params)
{
	if(isdefined(self.owner) && isdefined(self.owner.enemy))
	{
		self.parasiteEnemy = self.owner.enemy;
	}
	self thread parasite_target_selection();
}

/*
	Name: state_combat_update
	Namespace: parasite
	Checksum: 0x3E2505C
	Offset: 0x1080
	Size: 0x47F
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	lastTimeChangePosition = 0;
	self.shouldGotoNewPosition = 0;
	self.lastTimeTargetInSight = 0;
	self.lastTimeJuked = 0;
	self ASMRequestSubstate("locomotion@movement");
	while(isdefined(self._override_parasite_combat_speed))
	{
		self SetSpeed(self._override_parasite_combat_speed);
		continue;
		self SetSpeed(self.settings.defaultMoveSpeed);
		if(isdefined(self.inpain) && self.inpain)
		{
			wait(0.1);
		}
		else if(!isdefined(self.parasiteEnemy))
		{
			wait(0.25);
		}
		else if(self.goalforced)
		{
			returnData = [];
			returnData["origin"] = self GetClosestPointOnNavVolume(self.goalpos, 100);
			returnData["centerOnNav"] = IsPointInNavvolume(self.origin, "navvolume_small");
		}
		else if(RandomInt(100) < self.settings.jukeprobability && (!isdefined(self.lastTimeJuked) && self.lastTimeJuked) || (isdefined(self._override_juke) && self._override_juke))
		{
			returnData = GetNextMovePosition_forwardjuke();
			self.lastTimeJuked = 1;
			self._override_juke = undefined;
		}
		else
		{
			returnData = GetNextMovePosition_tactical();
			self.lastTimeJuked = 0;
		}
		self.current_pathto_pos = returnData["origin"];
		if(isdefined(self.current_pathto_pos))
		{
			if(isdefined(self.stuckTime))
			{
				self.stuckTime = undefined;
			}
			if(self SetVehGoalPos(self.current_pathto_pos, 1, returnData["centerOnNav"]))
			{
				self thread path_update_interrupt();
				self playsound("zmb_vocals_parasite_juke");
				self vehicle_ai::waittill_pathing_done(5);
			}
			else
			{
				wait(0.1);
			}
		}
		else if(!(isdefined(returnData["centerOnNav"]) && returnData["centerOnNav"]))
		{
			if(!isdefined(self.stuckTime))
			{
				self.stuckTime = GetTime();
			}
			if(GetTime() - self.stuckTime > 10000)
			{
				self DoDamage(self.health + 100, self.origin);
			}
		}
		if(isdefined(self.lastTimeJuked) && self.lastTimeJuked)
		{
			if(RandomInt(100) < 50 && isdefined(self.parasiteEnemy) && Distance2DSquared(self.origin, self.parasiteEnemy.origin) < 64 * 64)
			{
				self.parasiteEnemy DoDamage(self.settings.meleeDamage, self.parasiteEnemy.origin, self);
			}
			else
			{
				self fire_pod_logic(self.lastTimeJuked);
			}
		}
		else if(RandomInt(100) < 30)
		{
			self fire_pod_logic(self.lastTimeJuked);
		}
	}
}

/*
	Name: fire_pod_logic
	Namespace: parasite
	Checksum: 0x6D287E87
	Offset: 0x1508
	Size: 0x2CB
	Parameters: 1
	Flags: None
*/
function fire_pod_logic(choseToJuke)
{
	if(isdefined(self.parasiteEnemy) && self VehCanSee(self.parasiteEnemy) && Distance2DSquared(self.parasiteEnemy.origin, self.origin) < 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 3 * 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 3)
	{
		self ASMRequestSubstate("fire@stationary");
		self playsound("zmb_vocals_parasite_preattack");
		self clientfield::set("parasite_tell_fx", 1);
		self waittill("pre_fire");
		if(isdefined(self.parasiteEnemy) && self VehCanSee(self.parasiteEnemy) && Distance2DSquared(self.parasiteEnemy.origin, self.origin) < 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 3 * 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 3)
		{
			self SetTurretTargetEnt(self.parasiteEnemy, self.parasiteEnemy GetVelocity() * 0.3);
		}
		self vehicle_ai::waittill_asm_complete("fire@stationary", 5);
		self ASMRequestSubstate("locomotion@movement");
		self clientfield::set("parasite_tell_fx", 0);
		if(!choseToJuke)
		{
			wait(RandomFloatRange(0.25, 0.5));
		}
	}
	else
	{
		wait(RandomFloatRange(1, 2));
	}
}

/*
	Name: GetNextMovePosition_tactical
	Namespace: parasite
	Checksum: 0x943DFA33
	Offset: 0x17E0
	Size: 0x72D
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_tactical()
{
	self endon("change_state");
	self endon("death");
	selfDistToTarget = Distance2D(self.origin, self.parasiteEnemy.origin);
	goodDist = 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedHeightRange = 0.5 * self.settings.engagementHeightMax - self.settings.engagementHeightMin;
	randomness = 30;
	queryResult = PositionQuery_Source_Navigation(self.origin, 75, 225 * queryMultiplier, 75, 20 * queryMultiplier, self, 20 * queryMultiplier);
	if(!(isdefined(queryResult.centerOnNav) && queryResult.centerOnNav))
	{
		self.vehAirCraftCollisionEnabled = 0;
	}
	else
	{
		self.vehAirCraftCollisionEnabled = 1;
	}
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, self.parasiteEnemy, self.settings.engagementDistMin, self.settings.engagementDistMax);
	goalHeight = self.parasiteEnemy.origin[2] + 0.5 * self.settings.engagementHeightMin + self.settings.engagementHeightMax;
	best_point = undefined;
	best_score = -999999;
	trace_count = 0;
	foreach(point in queryResult.data)
	{
		if(!(isdefined(queryResult.centerOnNav) && queryResult.centerOnNav))
		{
			if(SightTracePassed(self.origin, point.origin, 0, undefined))
			{
				trace_count++;
				if(trace_count > 3)
				{
					wait(0.05);
					trace_count = 0;
				}
				if(!BulletTracePassed(self.origin, point.origin, 0, self))
				{
					continue;
				}
			}
			else
			{
				continue;
			}
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
		distFromPreferredHeight = Abs(point.origin[2] - goalHeight);
		if(distFromPreferredHeight > preferedHeightRange)
		{
			heightScore = mapfloat(0, 500, 0, 2000, distFromPreferredHeight);
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = heightScore * -1;
			#/
			point.score = point.score + heightScore * -1;
		}
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	/#
		if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
		{
			recordLine(self.origin, best_point.origin, (0.3, 1, 0));
			recordLine(self.origin, self.parasiteEnemy.origin, (1, 0, 0.4));
		}
	#/
	returnData = [];
	if(isdefined(best_point))
	{
	}
	else
	{
	}
	returnData["origin"] = undefined;
	returnData["centerOnNav"] = queryResult.centerOnNav;
	return returnData;
}

/*
	Name: GetNextMovePosition_forwardjuke
	Namespace: parasite
	Checksum: 0x6E44752
	Offset: 0x1F18
	Size: 0x72D
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_forwardjuke()
{
	self endon("change_state");
	self endon("death");
	selfDistToTarget = Distance2D(self.origin, self.parasiteEnemy.origin);
	goodDist = 0.5 * self.settings.forwardJukeEngagementDistMin + self.settings.forwardJukeEngagementDistMax;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedHeightRange = 0.5 * self.settings.forwardJukeEngagementHeightMax - self.settings.forwardJukeEngagementHeightMin;
	randomness = 30;
	queryResult = PositionQuery_Source_Navigation(self.origin, 75, 300 * queryMultiplier, 75, 20 * queryMultiplier, self, 20 * queryMultiplier);
	if(!(isdefined(queryResult.centerOnNav) && queryResult.centerOnNav))
	{
		self.vehAirCraftCollisionEnabled = 0;
	}
	else
	{
		self.vehAirCraftCollisionEnabled = 1;
	}
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, self.parasiteEnemy, self.settings.forwardJukeEngagementDistMin, self.settings.forwardJukeEngagementDistMax);
	goalHeight = self.parasiteEnemy.origin[2] + 0.5 * self.settings.forwardJukeEngagementHeightMin + self.settings.forwardJukeEngagementHeightMax;
	best_point = undefined;
	best_score = -999999;
	trace_count = 0;
	foreach(point in queryResult.data)
	{
		if(!(isdefined(queryResult.centerOnNav) && queryResult.centerOnNav))
		{
			if(SightTracePassed(self.origin, point.origin, 0, undefined))
			{
				trace_count++;
				if(trace_count > 3)
				{
					wait(0.05);
					trace_count = 0;
				}
				if(!BulletTracePassed(self.origin, point.origin, 0, self))
				{
					continue;
				}
			}
			else
			{
				continue;
			}
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
		distFromPreferredHeight = Abs(point.origin[2] - goalHeight);
		if(distFromPreferredHeight > preferedHeightRange)
		{
			heightScore = mapfloat(0, 500, 0, 2000, distFromPreferredHeight);
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = heightScore * -1;
			#/
			point.score = point.score + heightScore * -1;
		}
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	/#
		if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
		{
			recordLine(self.origin, best_point.origin, (0.3, 1, 0));
			recordLine(self.origin, self.parasiteEnemy.origin, (1, 0, 0.4));
		}
	#/
	returnData = [];
	if(isdefined(best_point))
	{
	}
	else
	{
	}
	returnData["origin"] = undefined;
	returnData["centerOnNav"] = queryResult.centerOnNav;
	return returnData;
}

/*
	Name: path_update_interrupt
	Namespace: parasite
	Checksum: 0xFA8D0FA8
	Offset: 0x2650
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function path_update_interrupt()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	wait(1);
	while(1)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(Distance2DSquared(self.current_pathto_pos, self.goalpos) > self.goalRadius * self.goalRadius)
			{
				wait(0.2);
				self._override_juke = 1;
				self notify("near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: drone_pain_for_time
	Namespace: parasite
	Checksum: 0xD13122F6
	Offset: 0x2710
	Size: 0x1DF
	Parameters: 3
	Flags: None
*/
function drone_pain_for_time(time, stablizeParam, restoreLookPoint)
{
	self endon("death");
	self.painStartTime = GetTime();
	if(!(isdefined(self.inpain) && self.inpain))
	{
		self.inpain = 1;
		self playsound("zmb_vocals_parasite_pain");
		while(GetTime() < self.painStartTime + time * 1000)
		{
			self SetVehVelocity(self.velocity * stablizeParam);
			self SetAngularVelocity(self GetAngularVelocity() * stablizeParam);
			wait(0.1);
		}
		if(isdefined(restoreLookPoint))
		{
			restoreLookEnt = spawn("script_model", restoreLookPoint);
			restoreLookEnt SetModel("tag_origin");
			self ClearLookAtEnt();
			self SetLookAtEnt(restoreLookEnt);
			self SetTurretTargetEnt(restoreLookEnt);
			wait(1.5);
			self ClearLookAtEnt();
			self ClearTurretTarget();
			restoreLookEnt delete();
		}
		self.inpain = 0;
	}
}

/*
	Name: drone_pain
	Namespace: parasite
	Checksum: 0x3B977153
	Offset: 0x28F8
	Size: 0x123
	Parameters: 6
	Flags: None
*/
function drone_pain(eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName)
{
	if(!(isdefined(self.inpain) && self.inpain))
	{
		yaw_vel = math::randomSign() * RandomFloatRange(280, 320);
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + (RandomFloatRange(-120, -100), yaw_vel, RandomFloatRange(-200, 200));
		self SetAngularVelocity(ang_vel);
		self thread drone_pain_for_time(0.8, 0.7);
	}
}

