#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace wasp;

/*
	Name: __init__sytem__
	Namespace: wasp
	Checksum: 0x9FF9F541
	Offset: 0x328
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("wasp", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: wasp
	Checksum: 0x52D2787B
	Offset: 0x368
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("wasp", &wasp_initialize);
	clientfield::register("vehicle", "rocket_wasp_hijacked", 1, 1, "int");
}

/*
	Name: wasp_initialize
	Namespace: wasp
	Checksum: 0xF1ECB962
	Offset: 0x3D0
	Size: 0x273
	Parameters: 0
	Flags: None
*/
function wasp_initialize()
{
	self useanimtree(-1);
	Target_Set(self, (0, 0, 0));
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist(40);
	self SetHoverParams(50, 100, 100);
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.vehAirCraftCollisionEnabled = 1;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.variant = "mg";
	if(IsSubStr(self.vehicleType, "rocket"))
	{
		self.variant = "rocket";
	}
	self.overrideVehicleDamage = &drone_callback_damage;
	self.allowFriendlyFireDamageOverride = &drone_AllowFriendlyFireDamage;
	self thread vehicle_ai::nudge_collision();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	if(self.variant === "rocket")
	{
		self.ignoreFireFly = 1;
		self vehicle_ai::InitThreatBias();
	}
	init_guard_points();
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: wasp
	Checksum: 0x139C82BC
	Offset: 0x650
	Size: 0x28B
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::get_state_callbacks("driving").update_func = &wasp_driving;
	self vehicle_ai::get_state_callbacks("emped").update_func = &state_emped_update;
	self vehicle_ai::add_state("guard", &state_guard_enter, &state_guard_update, &state_guard_exit);
	vehicle_ai::add_utility_connection("combat", "guard", &state_guard_can_enter);
	vehicle_ai::add_utility_connection("guard", "combat");
	vehicle_ai::add_interrupt_connection("guard", "emped", "emped");
	vehicle_ai::add_interrupt_connection("guard", "surge", "surge");
	vehicle_ai::add_interrupt_connection("guard", "off", "shut_off");
	vehicle_ai::add_interrupt_connection("guard", "pain", "pain");
	vehicle_ai::add_interrupt_connection("guard", "driving", "enter_vehicle");
	vehicle_ai::StartInitialState("combat");
}

/*
	Name: state_death_update
	Namespace: wasp
	Checksum: 0x5C6874C7
	Offset: 0x8E8
	Size: 0x3B3
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	if(IsArray(self.followers))
	{
		foreach(follower in self.followers)
		{
			if(isdefined(follower))
			{
				follower.leader = undefined;
			}
		}
	}
	death_type = vehicle_ai::get_death_type(params);
	if(!isdefined(death_type) && isdefined(params))
	{
		if(isdefined(params.weapon))
		{
			if(params.weapon.doannihilate)
			{
				death_type = "gibbed";
			}
			else if(params.weapon.dogibbing && isdefined(params.attacker))
			{
				dist = Distance(self.origin, params.attacker.origin);
				if(dist < params.weapon.maxGibDistance)
				{
					gib_chance = 1 - dist / params.weapon.maxGibDistance;
					if(RandomFloatRange(0, 2) < gib_chance)
					{
						death_type = "gibbed";
					}
				}
			}
		}
		if(isdefined(params.meansOfDeath))
		{
			meansOfDeath = params.meansOfDeath;
			if(meansOfDeath === "MOD_EXPLOSIVE" || meansOfDeath === "MOD_GRENADE_SPLASH" || meansOfDeath === "MOD_PROJECTILE_SPLASH" || meansOfDeath === "MOD_PROJECTILE")
			{
				death_type = "gibbed";
			}
		}
	}
	if(!isdefined(death_type))
	{
		crash_style = RandomInt(3);
		switch(crash_style)
		{
			case 0:
			{
				if(self.hijacked === 1)
				{
					params.death_type = "gibbed";
					vehicle_ai::defaultstate_death_update(params);
				}
				else
				{
					vehicle_death::barrel_rolling_crash();
				}
				break;
			}
			case 1:
			{
				vehicle_death::plane_crash();
				break;
			}
			case default:
			{
				vehicle_death::random_crash(params.vDir);
			}
		}
		self vehicle_death::DeleteWhenSafe();
	}
	else
	{
		params.death_type = death_type;
		vehicle_ai::defaultstate_death_update(params);
	}
}

/*
	Name: state_emped_update
	Namespace: wasp
	Checksum: 0x3A8A53DE
	Offset: 0xCA8
	Size: 0x68B
	Parameters: 1
	Flags: None
*/
function state_emped_update(params)
{
	self endon("death");
	self endon("change_state");
	wait(0.05);
	gravity = 400;
	self notify("end_nudge_collision");
	empdowntime = params.notify_param[0];
	/#
		Assert(isdefined(empdowntime));
	#/
	vehicle_ai::Cooldown("emped_timer", empdowntime);
	wait(RandomFloat(0.2));
	ang_vel = self GetAngularVelocity();
	pitch_vel = math::randomSign() * RandomFloatRange(200, 250);
	yaw_vel = math::randomSign() * RandomFloatRange(200, 250);
	roll_vel = math::randomSign() * RandomFloatRange(200, 250);
	ang_vel = ang_vel + (pitch_vel, yaw_vel, roll_vel);
	self SetAngularVelocity(ang_vel);
	if(IsPointInNavvolume(self.origin, "navvolume_small"))
	{
		self.position_before_fall = self.origin;
	}
	self CancelAIMove();
	self SetPhysAcceleration((0, 0, gravity * -1));
	killonimpact_speed = self.settings.killonimpact_speed;
	if(self.health <= 20)
	{
		killonimpact_speed = 1;
	}
	self fall_and_bounce(killonimpact_speed, self.settings.killonimpact_time);
	self notify("landed");
	self SetVehVelocity((0, 0, 0));
	self SetPhysAcceleration((0, 0, gravity * -1 * 0.1));
	self SetAngularVelocity((0, 0, 0));
	while(!vehicle_ai::IsCooldownReady("emped_timer"))
	{
		timeLeft = max(vehicle_ai::GetCooldownLeft("emped_timer"), 0.5);
		wait(timeLeft);
	}
	self.abnormal_status.emped = 0;
	self vehicle::toggle_emp_fx(0);
	self vehicle_ai::emp_startup_fx();
	for(bootup_timer = 1.6; bootup_timer > 0;  = 1.6)
	{
		self vehicle::lights_on();
		wait(0.4);
		self vehicle::lights_off();
		wait(0.4);
	}
	self vehicle::lights_on();
	if(isdefined(self.position_before_fall))
	{
		originoffset = VectorScale((0, 0, 1), 5);
		goalPoint = self GetClosestPointOnNavVolume(self.origin + originoffset, 50);
		if(isdefined(goalPoint) && SightTracePassed(self.origin + originoffset, goalPoint, 0, self))
		{
			self SetVehGoalPos(goalPoint, 0, 0);
			self util::waittill_any_timeout(0.3, "near_goal", "goal", "change_state", "death");
			if(isdefined(self.enemy))
			{
				self SetLookAtEnt(self.enemy);
			}
			startTime = GetTime();
			self.current_pathto_pos = self.position_before_fall;
			foundGoal = self SetVehGoalPos(self.current_pathto_pos, 1, 1);
			while(!foundGoal && vehicle_ai::TimeSince(startTime) < 3)
			{
				foundGoal = self SetVehGoalPos(self.current_pathto_pos, 1, 1);
				wait(0.3);
			}
			if(foundGoal)
			{
				self util::waittill_any_timeout(1, "near_goal", "goal", "change_state", "death");
			}
			else
			{
				self SetVehGoalPos(self.origin, 1, 0);
			}
			wait(1);
			self.position_before_fall = undefined;
			self vehicle_ai::evaluate_connections();
		}
	}
	self vehicle::lights_off();
}

/*
	Name: fall_and_bounce
	Namespace: wasp
	Checksum: 0x182A344
	Offset: 0x1340
	Size: 0x585
	Parameters: 2
	Flags: None
*/
function fall_and_bounce(killonimpact_speed, killonimpact_time)
{
	self endon("death");
	self endon("change_state");
	maxBounceTime = 3;
	bounceScale = 0.3;
	velocityLoss = 0.3;
	maxAngle = 12;
	bouncedTime = 0;
	angularVelStablizeParams = (0.3, 0.5, 0.2);
	anglesStablizeInitialScale = 0.6;
	anglesStablizeIncrement = 0.2;
	fallStart = GetTime();
	while(bouncedTime < maxBounceTime && LengthSquared(self.velocity) > 10 * 10)
	{
		self waittill("veh_collision", impact_vel, normal);
		if(LengthSquared(impact_vel) > killonimpact_speed * killonimpact_speed || (vehicle_ai::TimeSince(fallStart) > killonimpact_time && LengthSquared(impact_vel) > killonimpact_speed * 0.8 * killonimpact_speed * 0.8))
		{
			self kill();
		}
		else if(!isdefined(self.position_before_fall))
		{
			self kill();
		}
		else
		{
			fallStart = GetTime();
		}
		oldvelocity = self.velocity;
		vel_hitDir = VectorProjection(impact_vel, normal) * -1;
		vel_hitDirUp = VectorProjection(vel_hitDir, (0, 0, 1));
		velscale = min(bounceScale * bouncedTime + 1, 0.9);
		newVelocity = oldvelocity - VectorProjection(oldvelocity, vel_hitDir) * 1 - velocityLoss;
		newVelocity = newVelocity + vel_hitDir * velscale;
		shouldBounce = VectorDot(normal, (0, 0, 1)) > 0.76;
		if(shouldBounce)
		{
			velocityLengthSqr = LengthSquared(newVelocity);
			stablizeScale = mapfloat(5 * 5, 60 * 60, 0.1, 1, velocityLengthSqr);
			ang_vel = self GetAngularVelocity();
			ang_vel = ang_vel * angularVelStablizeParams * stablizeScale;
			self SetAngularVelocity(ang_vel);
			angles = self.angles;
			anglesStablizeScale = min(anglesStablizeInitialScale - bouncedTime * anglesStablizeIncrement, 0.1);
			pitch = angles[0];
			yaw = angles[1];
			roll = angles[2];
			surfaceAngles = VectorToAngles(normal);
			surfaceRoll = surfaceAngles[2];
			if(pitch < maxAngle * -1 || pitch > maxAngle)
			{
				pitch = pitch * anglesStablizeScale;
			}
			if(roll < surfaceRoll - maxAngle || roll > surfaceRoll + maxAngle)
			{
				roll = LerpFloat(surfaceRoll, roll, anglesStablizeScale);
			}
			self.angles = (pitch, yaw, roll);
		}
		self SetVehVelocity(newVelocity);
		self vehicle_ai::collision_fx(normal);
		if(shouldBounce)
		{
			bouncedTime++;
		}
	}
}

/*
	Name: init_guard_points
	Namespace: wasp
	Checksum: 0xBF402367
	Offset: 0x18D0
	Size: 0x261
	Parameters: 0
	Flags: None
*/
function init_guard_points()
{
	self._guard_points = [];
	if(!isdefined(self._guard_points))
	{
		self._guard_points = [];
	}
	else if(!IsArray(self._guard_points))
	{
		self._guard_points = Array(self._guard_points);
	}
	self._guard_points[self._guard_points.size] = (150, -110, 110);
	if(!isdefined(self._guard_points))
	{
		self._guard_points = [];
	}
	else if(!IsArray(self._guard_points))
	{
		self._guard_points = Array(self._guard_points);
	}
	self._guard_points[self._guard_points.size] = (150, 110, 110);
	if(!isdefined(self._guard_points))
	{
		self._guard_points = [];
	}
	else if(!IsArray(self._guard_points))
	{
		self._guard_points = Array(self._guard_points);
	}
	self._guard_points[self._guard_points.size] = (120, -110, 80);
	if(!isdefined(self._guard_points))
	{
		self._guard_points = [];
	}
	else if(!IsArray(self._guard_points))
	{
		self._guard_points = Array(self._guard_points);
	}
	self._guard_points[self._guard_points.size] = (120, 110, 80);
	if(!isdefined(self._guard_points))
	{
		self._guard_points = [];
	}
	else if(!IsArray(self._guard_points))
	{
		self._guard_points = Array(self._guard_points);
	}
	self._guard_points[self._guard_points.size] = (180, 0, 140);
}

/*
	Name: guard_points_debug
	Namespace: wasp
	Checksum: 0x16B6976F
	Offset: 0x1B40
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function guard_points_debug()
{
	/#
		self endon("death");
		if(self.isdebugdrawing === 1)
		{
			return;
		}
		self.isdebugdrawing = 1;
		while(1)
		{
			foreach(point in self.debugpointsarray)
			{
				color = (1, 0, 0);
				if(IsPointInNavvolume(point, "Dev Block strings are not supported"))
				{
					color = (0, 1, 0);
				}
				debugstar(point, 5, color);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: get_guard_points
	Namespace: wasp
	Checksum: 0x78CC2892
	Offset: 0x1C58
	Size: 0x38D
	Parameters: 1
	Flags: None
*/
function get_guard_points(owner)
{
	/#
		Assert(self._guard_points.size > 0, "Dev Block strings are not supported");
	#/
	points_array = [];
	foreach(point in self._guard_points)
	{
		offset = RotatePoint(point, owner.angles);
		worldPoint = offset + owner.origin + owner GetVelocity() * 0.5;
		if(IsPointInNavvolume(worldPoint, "navvolume_small"))
		{
			if(!isdefined(points_array))
			{
				points_array = [];
			}
			else if(!IsArray(points_array))
			{
				points_array = Array(points_array);
			}
			points_array[points_array.size] = worldPoint;
		}
	}
	if(points_array.size < 1)
	{
		queryResult = PositionQuery_Source_Navigation(owner.origin + VectorScale((0, 0, 1), 50), 25, 200, 100, 1.2 * self.radius, self);
		PositionQuery_Filter_Sight(queryResult, owner.origin + VectorScale((0, 0, 1), 10), (0, 0, 0), self, 3);
		foreach(point in queryResult.data)
		{
			if(point.visibility === 1 && BulletTracePassed(owner.origin + VectorScale((0, 0, 1), 10), point.origin, 0, self, self, 0, 1))
			{
				if(!isdefined(points_array))
				{
					points_array = [];
				}
				else if(!IsArray(points_array))
				{
					points_array = Array(points_array);
				}
				points_array[points_array.size] = point.origin;
			}
		}
	}
	return points_array;
}

/*
	Name: state_guard_can_enter
	Namespace: wasp
	Checksum: 0x8D69533C
	Offset: 0x1FF0
	Size: 0x11D
	Parameters: 3
	Flags: None
*/
function state_guard_can_enter(from_state, to_state, connection)
{
	if(self.enable_guard !== 1 || !isdefined(self.owner))
	{
		return 0;
	}
	if(!isdefined(self.enemy) || !self vehseenrecently(self.enemy, 3))
	{
		return 1;
	}
	if(DistanceSquared(self.owner.origin, self.enemy.origin) > 1200 * 1200 && DistanceSquared(self.origin, self.enemy.origin) > 300 * 300)
	{
		return 1;
	}
	if(!IsPointInNavvolume(self.origin, "navvolume_small"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: state_guard_enter
	Namespace: wasp
	Checksum: 0x6B8368A2
	Offset: 0x2118
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function state_guard_enter(params)
{
	if(self.enable_target_laser === 1)
	{
		self LaserOff();
	}
	self update_main_guard();
}

/*
	Name: update_main_guard
	Namespace: wasp
	Checksum: 0x37FED2C6
	Offset: 0x2170
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function update_main_guard()
{
	if(isdefined(self.owner) && !isalive(self.owner.main_guard) || self.owner.main_guard.owner !== self.owner)
	{
		self.owner.main_guard = self;
	}
}

/*
	Name: state_guard_exit
	Namespace: wasp
	Checksum: 0x5DA0A7FC
	Offset: 0x21E8
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function state_guard_exit(params)
{
	if(isdefined(self.owner) && self.owner.main_guard === self)
	{
		self.owner.main_guard = undefined;
	}
}

/*
	Name: test_get_back_point
	Namespace: wasp
	Checksum: 0xE34254
	Offset: 0x2230
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function test_get_back_point(point)
{
	if(SightTracePassed(self.origin, point, 0, self))
	{
		if(BulletTracePassed(self.origin, point, 0, self, self, 0, 1))
		{
			return 1;
		}
		return 0;
	}
	return -1;
}

/*
	Name: test_get_back_queryresult
	Namespace: wasp
	Checksum: 0xEDFB84BE
	Offset: 0x22A0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function test_get_back_queryresult(queryResult)
{
	getbackPoint = undefined;
	foreach(point in queryResult.data)
	{
		testresult = test_get_back_point(point.origin);
		if(testresult == 1)
		{
			return point.origin;
			continue;
		}
		if(testresult == 0)
		{
			wait(0.05);
		}
	}
	return undefined;
}

/*
	Name: state_guard_update
	Namespace: wasp
	Checksum: 0xF5F51A0B
	Offset: 0x23A0
	Size: 0x8A7
	Parameters: 1
	Flags: None
*/
function state_guard_update(params)
{
	self endon("death");
	self endon("change_state");
	self SetHoverParams(20, 40, 30);
	timeNotAtGoal = GetTime();
	pointIndex = 0;
	stuckCount = 0;
	while(1)
	{
		if(isdefined(self.enemy) && DistanceSquared(self.owner.origin, self.enemy.origin) < 1000 * 1000 && self vehseenrecently(self.enemy, 1) && IsPointInNavvolume(self.origin, "navvolume_small"))
		{
			self vehicle_ai::evaluate_connections();
			wait(1);
		}
		else
		{
			owner = self.owner;
			if(!isdefined(owner))
			{
				wait(1);
				continue;
			}
			usePathfinding = 1;
			onNavVolume = IsPointInNavvolume(self.origin, "navvolume_small");
			if(!onNavVolume)
			{
				getbackPoint = undefined;
				pointOnNavVolume = self GetClosestPointOnNavVolume(self.origin, 500);
				if(isdefined(pointOnNavVolume))
				{
					if(test_get_back_point(pointOnNavVolume) == 1)
					{
						getbackPoint = pointOnNavVolume;
					}
				}
				if(!isdefined(getbackPoint))
				{
					queryResult = PositionQuery_Source_Navigation(self.origin, 0, 1500, 200, 80, self);
					getbackPoint = test_get_back_queryresult(queryResult);
				}
				if(!isdefined(getbackPoint))
				{
					queryResult = PositionQuery_Source_Navigation(self.origin, 0, 300, 700, 30, self);
					getbackPoint = test_get_back_queryresult(queryResult);
				}
				if(isdefined(getbackPoint))
				{
					if(DistanceSquared(getbackPoint, self.origin) > 20 * 20)
					{
						self.current_pathto_pos = getbackPoint;
						usePathfinding = 0;
						self.vehAirCraftCollisionEnabled = 0;
					}
					else
					{
						onNavVolume = 1;
					}
				}
				else
				{
					stuckCount++;
					if(stuckCount == 1)
					{
						stuckLocation = self.origin;
					}
					else if(stuckCount > 10)
					{
						/#
							/#
								Assert(0, "Dev Block strings are not supported" + self.origin);
							#/
							v_box_min = (self.radius * -1, self.radius * -1, self.radius * -1);
							v_box_max = (self.radius, self.radius, self.radius);
							box(self.origin, v_box_min, v_box_max, self.angles[1], (1, 0, 0), 1, 0, 1000000);
							if(isdefined(stuckLocation))
							{
								line(stuckLocation, self.origin, (1, 0, 0), 1, 1, 1000000);
							}
						#/
						self kill();
					}
				}
			}
			if(onNavVolume)
			{
				self update_main_guard();
				if(owner.main_guard === self)
				{
					guardPoints = get_guard_points(owner);
					if(guardPoints.size < 1)
					{
						wait(1);
						continue;
					}
					stuckCount = 0;
					self.vehAirCraftCollisionEnabled = 1;
					if(guardPoints.size <= pointIndex)
					{
						pointIndex = RandomInt(Int(min(self._guard_points.size, guardPoints.size)));
						timeNotAtGoal = GetTime();
					}
					self.current_pathto_pos = guardPoints[pointIndex];
				}
				else
				{
					main_guard = owner.main_guard;
					if(isalive(main_guard) && isdefined(main_guard.current_pathto_pos))
					{
						query_position = main_guard.current_pathto_pos;
						queryResult = PositionQuery_Source_Navigation(query_position, 20, 140, 100, 20, self, 15);
						if(queryResult.data.size > 0)
						{
							self.current_pathto_pos = queryResult.data[queryResult.data.size - 1].origin;
						}
					}
				}
			}
			if(isdefined(self.current_pathto_pos))
			{
				distanceToGoalSq = DistanceSquared(self.current_pathto_pos, self.origin);
				if(!onNavVolume || distanceToGoalSq > 60 * 60)
				{
					if(distanceToGoalSq > 600 * 600)
					{
						self SetSpeed(self.settings.defaultMoveSpeed * 2);
					}
					else if(distanceToGoalSq < 100 * 100)
					{
						self SetSpeed(self.settings.defaultMoveSpeed * 0.3);
					}
					else
					{
						self SetSpeed(self.settings.defaultMoveSpeed);
					}
					timeNotAtGoal = GetTime();
				}
				else if(vehicle_ai::TimeSince(timeNotAtGoal) > 4)
				{
					pointIndex = RandomInt(self._guard_points.size);
					timeNotAtGoal = GetTime();
				}
				wait(0.2);
				continue;
				if(self SetVehGoalPos(self.current_pathto_pos, 1, usePathfinding))
				{
					self playsound("veh_wasp_direction");
					self ClearLookAtEnt();
					self notify("fire_stop");
					self thread path_update_interrupt();
					if(onNavVolume)
					{
						self vehicle_ai::waittill_pathing_done(1);
					}
					else
					{
						self vehicle_ai::waittill_pathing_done();
					}
				}
				else
				{
					wait(0.5);
				}
			}
			else
			{
				wait(0.5);
			}
		}
	}
}

/*
	Name: state_combat_enter
	Namespace: wasp
	Checksum: 0xD19A91FA
	Offset: 0x2C50
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function state_combat_enter(params)
{
	if(self.enable_target_laser === 1)
	{
		self LaserOn();
	}
	if(isdefined(self.owner) && isdefined(self.owner.enemy))
	{
		self.favoriteenemy = self.owner.enemy;
	}
	self thread turretFireUpdate();
}

/*
	Name: turretFireUpdate
	Namespace: wasp
	Checksum: 0x9463690C
	Offset: 0x2CE0
	Size: 0x4AB
	Parameters: 0
	Flags: None
*/
function turretFireUpdate()
{
	self endon("death");
	self endon("change_state");
	isRocketType = self.variant === "rocket";
	while(1)
	{
		if(isdefined(self.enemy) && self VehCanSee(self.enemy))
		{
			if(DistanceSquared(self.enemy.origin, self.origin) < 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 3 * 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 3)
			{
				self SetLookAtEnt(self.enemy);
				if(isRocketType)
				{
					self SetTurretTargetEnt(self.enemy, self.enemy GetVelocity() * 0.3 - vehicle_ai::GetTargetEyeOffset(self.enemy) * 0.3);
				}
				else
				{
					self SetTurretTargetEnt(self.enemy, vehicle_ai::GetTargetEyeOffset(self.enemy) * -1 * 0.3);
				}
				startAim = GetTime();
				while(!self.turretontarget && vehicle_ai::TimeSince(startAim) < 3)
				{
					wait(0.2);
				}
				if(isdefined(self.enemy) && self.turretontarget && self.noshoot !== 1)
				{
					if(isRocketType)
					{
						for(i = 0; i < 2 && isdefined(self.enemy); i++)
						{
							self FireWeapon(0, self.enemy);
							fired = 1;
							wait(0.25);
						}
					}
					else
					{
						self vehicle_ai::fire_for_time(RandomFloatRange(self.settings.turret_fire_burst_min, self.settings.turret_fire_burst_max), 0, self.enemy);
					}
					if(isdefined(self.settings.turret_cooldown_max))
					{
						if(!isdefined(self.settings.turret_cooldown_min))
						{
							self.settings.turret_cooldown_min = 0;
						}
						wait(RandomFloatRange(self.settings.turret_cooldown_min, self.settings.turret_cooldown_max));
					}
				}
				else if(isdefined(self.settings.turret_enemy_detect_freq))
				{
					wait(self.settings.turret_enemy_detect_freq);
				}
				self SetTurretTargetRelativeAngles(VectorScale((1, 0, 0), 15), 0);
			}
			if(isRocketType)
			{
				if(isdefined(self.enemy) && isai(self.enemy))
				{
					wait(RandomFloatRange(4, 7));
				}
				else
				{
					wait(RandomFloatRange(3, 5));
				}
			}
			else if(isdefined(self.enemy) && isai(self.enemy))
			{
				wait(RandomFloatRange(2, 2.5));
			}
			else
			{
				wait(RandomFloatRange(0.5, 1.5));
			}
		}
		else
		{
			wait(0.4);
		}
	}
}

/*
	Name: path_update_interrupt
	Namespace: wasp
	Checksum: 0xCD682AB0
	Offset: 0x3198
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function path_update_interrupt()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	old_enemy = self.enemy;
	wait(1);
	while(1)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(Distance2DSquared(self.current_pathto_pos, self.goalpos) > self.goalRadius * self.goalRadius)
			{
				wait(0.2);
				self notify("near_goal");
			}
		}
		if(isdefined(self.enemy))
		{
			if(self.noshoot !== 1 && self VehCanSee(self.enemy))
			{
				self SetTurretTargetEnt(self.enemy);
				self SetLookAtEnt(self.enemy);
			}
			if(!isdefined(old_enemy))
			{
				self notify("near_goal");
			}
			else if(self.enemy != old_enemy)
			{
				self notify("near_goal");
			}
			if(self VehCanSee(self.enemy) && Distance2DSquared(self.origin, self.enemy.origin) < 250 * 250)
			{
				self notify("near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: wait_till_something_happens
	Namespace: wasp
	Checksum: 0x4556863A
	Offset: 0x3378
	Size: 0x2D5
	Parameters: 1
	Flags: None
*/
function wait_till_something_happens(timeout)
{
	self endon("change_state");
	self endon("death");
	wait(0.1);
	time = timeout;
	cant_see_count = 0;
	while(time > 0)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(DistanceSquared(self.current_pathto_pos, self.goalpos) > self.goalRadius * self.goalRadius)
			{
				break;
			}
		}
		if(isdefined(self.enemy))
		{
			if(!self VehCanSee(self.enemy))
			{
				cant_see_count++;
				if(cant_see_count >= 3)
				{
					break;
				}
			}
			else
			{
				cant_see_count = 0;
			}
			if(Distance2DSquared(self.origin, self.enemy.origin) < 250 * 250)
			{
				break;
			}
			goalHeight = self.enemy.origin[2] + 0.5 * self.settings.engagementHeightMin + self.settings.engagementHeightMax;
			distFromPreferredHeight = Abs(self.origin[2] - goalHeight);
			if(distFromPreferredHeight > 100)
			{
				break;
			}
			if(isPlayer(self.enemy) && self.enemy islookingat(self))
			{
				if(math::cointoss())
				{
					wait(RandomFloatRange(0.1, 0.5));
				}
				self drop_leader();
				break;
			}
		}
		if(isdefined(self.leader) && isdefined(self.leader.current_pathto_pos))
		{
			if(DistanceSquared(self.origin, self.leader.current_pathto_pos) > 165 * 165)
			{
				break;
			}
		}
		wait(0.3);
		time = time - 0.3;
	}
}

/*
	Name: drop_leader
	Namespace: wasp
	Checksum: 0x522BB99C
	Offset: 0x3658
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function drop_leader()
{
	if(isdefined(self.leader))
	{
		ArrayRemoveValue(self.leader.followers, self);
		self.leader = undefined;
	}
}

/*
	Name: update_leader
	Namespace: wasp
	Checksum: 0xB1E74F7F
	Offset: 0x36A0
	Size: 0x209
	Parameters: 0
	Flags: None
*/
function update_leader()
{
	if(isdefined(self.no_group) && self.no_group == 1)
	{
		return;
	}
	if(isdefined(self.leader))
	{
		return;
	}
	if(isdefined(self.followers))
	{
		self.followers = Array::remove_dead(self.followers, 0);
		if(self.followers.size > 0)
		{
			return;
		}
	}
	team_mates = GetAITeamArray(self.team);
	foreach(guy in team_mates)
	{
		if(isdefined(guy.archetype) && guy.archetype == "wasp")
		{
			if(isdefined(guy.leader))
			{
				continue;
			}
			if(guy == self)
			{
				continue;
			}
			if(DistanceSquared(self.origin, guy.origin) > 700 * 700)
			{
				continue;
			}
			if(!isdefined(guy.followers))
			{
				guy.followers = [];
			}
			if(guy.followers.size >= 2)
			{
				continue;
			}
			guy.followers[guy.followers.size] = self;
			self.leader = guy;
			break;
		}
	}
}

/*
	Name: should_fly_forward
	Namespace: wasp
	Checksum: 0x47EE73D4
	Offset: 0x38B8
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function should_fly_forward(distanceToGoalSq)
{
	if(self.always_face_enemy === 1)
	{
		return 0;
	}
	if(distanceToGoalSq < 250 * 250)
	{
		return 0;
	}
	if(isdefined(self.enemy))
	{
		to_goal = VectorNormalize(self.current_pathto_pos - self.origin);
		to_enemy = VectorNormalize(self.enemy.origin - self.origin);
		dot = VectorDot(to_goal, to_enemy);
		if(Abs(dot) > 0.7)
		{
			return 0;
		}
	}
	if(distanceToGoalSq > 400 * 400)
	{
		return RandomInt(100) > 25;
	}
	return RandomInt(100) > 50;
}

/*
	Name: state_combat_update
	Namespace: wasp
	Checksum: 0x63C0D4CB
	Offset: 0x3A08
	Size: 0x8A9
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	wait(0.1);
	stuckCount = 0;
	for(;;)
	{
		self SetSpeed(self.settings.defaultMoveSpeed);
		self update_leader();
		if(isdefined(self.inpain) && self.inpain)
		{
			wait(0.1);
			continue;
		}
		if(self.enable_guard === 1)
		{
			self vehicle_ai::evaluate_connections();
		}
		if(isdefined(self.enemy))
		{
			self SetTurretTargetEnt(self.enemy);
			self SetLookAtEnt(self.enemy);
			self wait_till_something_happens(RandomFloatRange(2, 5));
		}
		if(!isdefined(self.enemy))
		{
			self ClearLookAtEnt();
			aiArray = GetAITeamArray("all");
			foreach(ai in aiArray)
			{
				self GetPerfectInfo(ai);
			}
			players = GetPlayers("all");
			foreach(player in players)
			{
				self GetPerfectInfo(player);
			}
			wait(1);
		}
		usePathfinding = 1;
		onNavVolume = IsPointInNavvolume(self.origin, "navvolume_small");
		if(!onNavVolume)
		{
			getbackPoint = undefined;
			if(self.aggresive_navvolume_recover === 1)
			{
				self vehicle_ai::evaluate_connections();
			}
			pointOnNavVolume = self GetClosestPointOnNavVolume(self.origin, 100);
			if(isdefined(pointOnNavVolume))
			{
				if(SightTracePassed(self.origin, pointOnNavVolume, 0, self))
				{
					getbackPoint = pointOnNavVolume;
				}
			}
			if(!isdefined(getbackPoint))
			{
				queryResult = PositionQuery_Source_Navigation(self.origin, 0, 200, 100, 2 * self.radius, self);
				PositionQuery_Filter_Sight(queryResult, self.origin, (0, 0, 0), self, 1);
				getbackPoint = undefined;
				foreach(point in queryResult.data)
				{
					if(point.visibility === 1)
					{
						getbackPoint = point.origin;
						break;
					}
				}
			}
			else if(isdefined(getbackPoint))
			{
				self.current_pathto_pos = getbackPoint;
				usePathfinding = 0;
			}
			else
			{
				stuckCount++;
				if(stuckCount == 1)
				{
					stuckLocation = self.origin;
				}
				else if(stuckCount > 10)
				{
					/#
						/#
							Assert(0, "Dev Block strings are not supported" + self.origin);
						#/
						v_box_min = (self.radius * -1, self.radius * -1, self.radius * -1);
						v_box_max = (self.radius, self.radius, self.radius);
						box(self.origin, v_box_min, v_box_max, self.angles[1], (1, 0, 0), 1, 0, 1000000);
						if(isdefined(stuckLocation))
						{
							line(stuckLocation, self.origin, (1, 0, 0), 1, 1, 1000000);
						}
					#/
					self kill();
				}
			}
		}
		else
		{
			stuckCount = 0;
			if(self.goalforced)
			{
				goalpos = self GetClosestPointOnNavVolume(self.goalpos, 100);
				if(isdefined(goalpos))
				{
					self.current_pathto_pos = goalpos;
					usePathfinding = 1;
				}
				else
				{
					self.current_pathto_pos = self.goalpos;
					usePathfinding = 0;
				}
			}
			else if(isdefined(self.enemy))
			{
				self.current_pathto_pos = GetNextMovePosition_tactical();
				usePathfinding = 1;
			}
			else
			{
				self.current_pathto_pos = GetNextMovePosition_wander();
				usePathfinding = 1;
			}
		}
		if(isdefined(self.current_pathto_pos))
		{
			distanceToGoalSq = DistanceSquared(self.current_pathto_pos, self.origin);
			if(!onNavVolume || distanceToGoalSq > 75 * 75)
			{
				if(distanceToGoalSq > 2000 * 2000)
				{
					self SetSpeed(self.settings.defaultMoveSpeed * 2);
				}
				if(self SetVehGoalPos(self.current_pathto_pos, 1, usePathfinding))
				{
					if(isdefined(self.enemy))
					{
						self playsound("veh_wasp_direction");
					}
					else
					{
						self playsound("veh_wasp_vox");
					}
					if(should_fly_forward(distanceToGoalSq))
					{
						self ClearLookAtEnt();
						self notify("fire_stop");
						self.noshoot = 1;
					}
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
					self.noshoot = undefined;
				}
			}
		}
	}
}

/*
	Name: GetNextMovePosition_wander
	Namespace: wasp
	Checksum: 0x115BE87E
	Offset: 0x42C0
	Size: 0x295
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_wander()
{
	queryMultiplier = 1;
	queryResult = PositionQuery_Source_Navigation(self.origin, 80, 500 * queryMultiplier, 130, 3 * self.radius * queryMultiplier, self, self.radius * queryMultiplier);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	self.isOnNav = queryResult.centerOnNav;
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryResult.data)
	{
		randomScore = RandomFloatRange(0, 100);
		distToOriginScore = point.distToOrigin2D * 0.2;
		point.score = point.score + randomScore + distToOriginScore;
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = distToOriginScore;
		#/
		point.score = point.score + distToOriginScore;
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	if(!isdefined(best_point))
	{
		return undefined;
	}
	return best_point.origin;
}

/*
	Name: GetNextMovePosition_tactical
	Namespace: wasp
	Checksum: 0xC1A8D307
	Offset: 0x4560
	Size: 0xCB1
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_tactical()
{
	if(!isdefined(self.enemy))
	{
		return self GetNextMovePosition_wander();
	}
	selfDistToTarget = Distance2D(self.origin, self.enemy.origin);
	goodDist = 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedHeightRange = 35;
	randomness = 30;
	avoid_locations = [];
	avoid_radius = 50;
	if(isalive(self.leader) && isdefined(self.leader.current_pathto_pos))
	{
		query_position = self.leader.current_pathto_pos;
		queryResult = PositionQuery_Source_Navigation(query_position, 0, 140, 100, 35, self, 25);
		break;
	}
	if(isalive(self.owner) && self.enable_guard === 1)
	{
		ownerOrigin = self GetClosestPointOnNavVolume(self.owner.origin + VectorScale((0, 0, 1), 40), 50);
		if(isdefined(ownerOrigin))
		{
			queryResult = PositionQuery_Source_Navigation(ownerOrigin, 0, 500 * min(queryMultiplier, 1.5), 130, 3 * self.radius, self);
			if(isdefined(queryResult) && isdefined(queryResult.data))
			{
				PositionQuery_Filter_Sight(queryResult, self.owner GetEye(), (0, 0, 0), self, 5, self, "visowner");
				PositionQuery_Filter_Sight(queryResult, self.enemy GetEye(), (0, 0, 0), self, 5, self, "visenemy");
				foreach(point in queryResult.data)
				{
					if(point.visowner === 1)
					{
						/#
							if(!isdefined(point._scoreDebug))
							{
								point._scoreDebug = [];
							}
							point._scoreDebug["Dev Block strings are not supported"] = 300;
						#/
						point.score = point.score + 300;
					}
					if(point.visenemy === 1)
					{
						/#
							if(!isdefined(point._scoreDebug))
							{
								point._scoreDebug = [];
							}
							point._scoreDebug["Dev Block strings are not supported"] = 300;
						#/
						point.score = point.score + 300;
					}
				}
			}
		}
		break;
	}
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, 500 * min(queryMultiplier, 2), 130, 3 * self.radius * queryMultiplier, self, 2.2 * self.radius * queryMultiplier);
	team_mates = GetAITeamArray(self.team);
	avoid_radius = 140;
	foreach(guy in team_mates)
	{
		if(isdefined(guy.archetype) && guy.archetype == "wasp")
		{
			if(isdefined(guy.followers) && guy.followers.size > 0 && guy != self)
			{
				if(isdefined(guy.current_pathto_pos))
				{
					avoid_locations[avoid_locations.size] = guy.current_pathto_pos;
				}
			}
		}
	}
	if(!isdefined(queryResult) || !isdefined(queryResult.data) || queryResult.data.size == 0)
	{
		return undefined;
	}
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	PositionQuery_Filter_InClaimedLocation(queryResult, self);
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, self.enemy, self.settings.engagementDistMin, self.settings.engagementDistMax);
	self vehicle_ai::PositionQuery_Filter_EngagementHeight(queryResult, self.enemy, self.settings.engagementHeightMin, self.settings.engagementHeightMax);
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryResult.data)
	{
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
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = point.distEngagementHeight * -1 * 1.4;
		#/
		point.score = point.score + point.distEngagementHeight * -1 * 1.4;
		if(point.distToOrigin2D < 120)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = 120 - point.distToOrigin2D * -1.5;
			#/
			point.score = point.score + 120 - point.distToOrigin2D * -1.5;
		}
		foreach(location in avoid_locations)
		{
			if(DistanceSquared(point.origin, location) < avoid_radius * avoid_radius)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = avoid_radius * -1;
				#/
				point.score = point.score + avoid_radius * -1;
			}
		}
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
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	if(!isdefined(best_point))
	{
		return undefined;
	}
	/#
		if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
		{
			recordLine(self.origin, best_point.origin, (0.3, 1, 0));
			recordLine(self.origin, self.enemy.origin, (1, 0, 0.4));
		}
	#/
	return best_point.origin;
}

/*
	Name: drone_callback_damage
	Namespace: wasp
	Checksum: 0xA77CB908
	Offset: 0x5220
	Size: 0xD3
	Parameters: 15
	Flags: None
*/
function drone_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	iDamage = vehicle_ai::shared_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
	return iDamage;
}

/*
	Name: drone_AllowFriendlyFireDamage
	Namespace: wasp
	Checksum: 0xDF24CA8A
	Offset: 0x5300
	Size: 0x7B
	Parameters: 4
	Flags: None
*/
function drone_AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon)
{
	if(isdefined(eAttacker) && isdefined(eAttacker.archetype) && isdefined(sMeansOfDeath) && eAttacker.archetype == "wasp" && sMeansOfDeath == "MOD_EXPLOSIVE")
	{
		return 1;
	}
	return 0;
}

/*
	Name: wasp_driving
	Namespace: wasp
	Checksum: 0x1010E945
	Offset: 0x5388
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function wasp_driving(params)
{
	self endon("change_state");
	driver = self GetSeatOccupant(0);
	if(isPlayer(driver))
	{
		clientfield::set("rocket_wasp_hijacked", 1);
	}
	if(isPlayer(driver) && isdefined(self.PlayerDrivenVersion))
	{
		self thread wasp_manage_camera_swaps();
	}
}

/*
	Name: wasp_manage_camera_swaps
	Namespace: wasp
	Checksum: 0x756E94F1
	Offset: 0x5440
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function wasp_manage_camera_swaps()
{
	self endon("death");
	self endon("change_state");
	driver = self GetSeatOccupant(0);
	driver endon("disconnect");
	cam_low_type = self.vehicleType;
	cam_high_type = self.PlayerDrivenVersion;
}

