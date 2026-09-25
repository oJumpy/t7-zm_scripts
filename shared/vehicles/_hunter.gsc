#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_attack_drone;

#namespace hunter;

/*
	Name: __init__sytem__
	Namespace: hunter
	Checksum: 0xE96A82B8
	Offset: 0x598
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hunter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hunter
	Checksum: 0x6D1E5FA9
	Offset: 0x5D8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	RegisterInterfaceAttributes("hunter");
	vehicle::add_main_callback("hunter", &hunter_initialize);
}

/*
	Name: RegisterInterfaceAttributes
	Namespace: hunter
	Checksum: 0x254F2268
	Offset: 0x628
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function RegisterInterfaceAttributes(archetype)
{
	vehicle_ai::RegisterSharedInterfaceAttributes(archetype);
	ai::RegisterNumericInterface(archetype, "strafe_speed", 0, 0, 100);
	ai::RegisterNumericInterface(archetype, "strafe_distance", 0, 0, 10000);
}

/*
	Name: hunter_initTagArrays
	Namespace: hunter
	Checksum: 0x882ABC09
	Offset: 0x6A8
	Size: 0x3BD
	Parameters: 0
	Flags: None
*/
function hunter_initTagArrays()
{
	self.weakSpotTags = [];
	if(0)
	{
		if(!isdefined(self.weakSpotTags))
		{
			self.weakSpotTags = [];
		}
		else if(!IsArray(self.weakSpotTags))
		{
			self.weakSpotTags = Array(self.weakSpotTags);
		}
		self.weakSpotTags[self.weakSpotTags.size] = "tag_target_l";
		if(!isdefined(self.weakSpotTags))
		{
			self.weakSpotTags = [];
		}
		else if(!IsArray(self.weakSpotTags))
		{
			self.weakSpotTags = Array(self.weakSpotTags);
		}
		self.weakSpotTags[self.weakSpotTags.size] = "tag_target_r";
	}
	self.explosiveWeakSpotTags = [];
	if(0)
	{
		if(!isdefined(self.explosiveWeakSpotTags))
		{
			self.explosiveWeakSpotTags = [];
		}
		else if(!IsArray(self.explosiveWeakSpotTags))
		{
			self.explosiveWeakSpotTags = Array(self.explosiveWeakSpotTags);
		}
		self.explosiveWeakSpotTags[self.explosiveWeakSpotTags.size] = "tag_fan_base_l";
		if(!isdefined(self.explosiveWeakSpotTags))
		{
			self.explosiveWeakSpotTags = [];
		}
		else if(!IsArray(self.explosiveWeakSpotTags))
		{
			self.explosiveWeakSpotTags = Array(self.explosiveWeakSpotTags);
		}
		self.explosiveWeakSpotTags[self.explosiveWeakSpotTags.size] = "tag_fan_base_r";
	}
	self.missileTags = [];
	if(!isdefined(self.missileTags))
	{
		self.missileTags = [];
	}
	else if(!IsArray(self.missileTags))
	{
		self.missileTags = Array(self.missileTags);
	}
	self.missileTags[self.missileTags.size] = "tag_rocket1";
	if(!isdefined(self.missileTags))
	{
		self.missileTags = [];
	}
	else if(!IsArray(self.missileTags))
	{
		self.missileTags = Array(self.missileTags);
	}
	self.missileTags[self.missileTags.size] = "tag_rocket2";
	self.droneAttachTags = [];
	if(0)
	{
		if(!isdefined(self.droneAttachTags))
		{
			self.droneAttachTags = [];
		}
		else if(!IsArray(self.droneAttachTags))
		{
			self.droneAttachTags = Array(self.droneAttachTags);
		}
		self.droneAttachTags[self.droneAttachTags.size] = "tag_drone_attach_l";
		if(!isdefined(self.droneAttachTags))
		{
			self.droneAttachTags = [];
		}
		else if(!IsArray(self.droneAttachTags))
		{
			self.droneAttachTags = Array(self.droneAttachTags);
		}
		self.droneAttachTags[self.droneAttachTags.size] = "tag_drone_attach_r";
	}
}

/*
	Name: hunter_SpawnDrones
	Namespace: hunter
	Checksum: 0x2CE814D
	Offset: 0xA70
	Size: 0x1A7
	Parameters: 0
	Flags: None
*/
function hunter_SpawnDrones()
{
	self.dronesOwned = [];
	if(0)
	{
		foreach(droneTag in self.droneAttachTags)
		{
			origin = self GetTagOrigin(droneTag);
			angles = self GetTagAngles(droneTag);
			drone = SpawnVehicle("spawner_bo3_attack_drone_enemy", origin, angles);
			drone.owner = self;
			drone.attachTag = droneTag;
			drone.team = self.team;
			if(!isdefined(self.dronesOwned))
			{
				self.dronesOwned = [];
			}
			else if(!IsArray(self.dronesOwned))
			{
				self.dronesOwned = Array(self.dronesOwned);
			}
			self.dronesOwned[self.dronesOwned.size] = drone;
		}
	}
}

/*
	Name: hunter_initialize
	Namespace: hunter
	Checksum: 0xCCB19683
	Offset: 0xC20
	Size: 0x383
	Parameters: 0
	Flags: None
*/
function hunter_initialize()
{
	self endon("death");
	self useanimtree(-1);
	Target_Set(self, VectorScale((0, 0, 1), 90));
	ai::CreateInterfaceForEntity(self);
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self SetNearGoalNotifyDist(50);
	self SetHoverParams(15, 100, 40);
	self.flyHeight = GetDvarFloat("g_quadrotorFlyHeight");
	self.fovcosine = 0;
	self.fovcosinebusy = 0.574;
	self.vehAirCraftCollisionEnabled = 1;
	self.original_vehicle_type = self.vehicleType;
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self hunter_initTagArrays();
	self.overrideVehicleDamage = &HunterCallback_VehicleDamage;
	self thread vehicle_ai::nudge_collision();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	self.ignoreFireFly = 1;
	self.ignoreDecoy = 1;
	self vehicle_ai::InitThreatBias();
	self turret::_init_turret(1);
	self turret::_init_turret(2);
	self turret::set_best_target_func(&side_turret_get_best_target, 1);
	self turret::set_best_target_func(&side_turret_get_best_target, 2);
	self turret::set_burst_parameters(1, 2, 1, 2, 1);
	self turret::set_burst_parameters(1, 2, 1, 2, 2);
	self turret::set_target_flags(3, 1);
	self turret::set_target_flags(3, 2);
	self side_turrets_forward();
	self PathVariableOffset((10, 10, -30), 1);
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: hunter
	Checksum: 0x36B16C4B
	Offset: 0xFB0
	Size: 0x41B
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role();
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("combat").exit_func = &state_combat_exit;
	self vehicle_ai::get_state_callbacks("driving").enter_func = &hunter_scripted;
	self vehicle_ai::get_state_callbacks("scripted").enter_func = &hunter_scripted;
	self vehicle_ai::get_state_callbacks("death").enter_func = &state_death_enter;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::get_state_callbacks("emped").update_func = &hunter_emped;
	self vehicle_ai::add_state("unaware", undefined, &state_unaware_update, &state_unaware_exit);
	vehicle_ai::add_interrupt_connection("unaware", "scripted", "enter_scripted");
	vehicle_ai::add_interrupt_connection("unaware", "emped", "emped");
	vehicle_ai::add_interrupt_connection("unaware", "off", "shut_off");
	vehicle_ai::add_interrupt_connection("unaware", "driving", "enter_vehicle");
	vehicle_ai::add_interrupt_connection("unaware", "pain", "pain");
	self vehicle_ai::add_state("strafe", &state_strafe_enter, &state_strafe_update, &state_strafe_exit);
	vehicle_ai::add_interrupt_connection("strafe", "scripted", "enter_scripted");
	vehicle_ai::add_interrupt_connection("strafe", "emped", "emped");
	vehicle_ai::add_interrupt_connection("strafe", "off", "shut_off");
	vehicle_ai::add_interrupt_connection("strafe", "driving", "enter_vehicle");
	vehicle_ai::add_interrupt_connection("strafe", "pain", "pain");
	vehicle_ai::add_utility_connection("strafe", "combat");
	vehicle_ai::add_utility_connection("emped", "strafe");
	vehicle_ai::add_utility_connection("pain", "strafe");
	vehicle_ai::StartInitialState();
}

/*
	Name: shut_off_fx
	Namespace: hunter
	Checksum: 0x79798C
	Offset: 0x13D8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function shut_off_fx()
{
	self endon("death");
	self notify("death_shut_off");
	if(isdefined(self.frontScanner))
	{
		self.frontScanner.sndScanningEnt delete();
		self.frontScanner delete();
	}
}

/*
	Name: kill_drones
	Namespace: hunter
	Checksum: 0x96B642AC
	Offset: 0x1448
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function kill_drones()
{
	self endon("death");
	foreach(drone in self.dronesOwned)
	{
		if(isalive(drone) && Distance2DSquared(self.origin, drone.origin) < 80 * 80)
		{
			damageOrigin = self.origin + (0, 0, 1);
			drone finishVehicleRadiusDamage(self.death_info.attacker, self.death_info.attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", level.weaponNone, damageOrigin, 400, -1, (0, 0, 1), 0);
		}
	}
}

/*
	Name: state_death_enter
	Namespace: hunter
	Checksum: 0x3D61D9D4
	Offset: 0x15A8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function state_death_enter(params)
{
	self endon("death");
	if(isdefined(self.fakeTargetEnt))
	{
		self.fakeTargetEnt delete();
	}
	vehicle_ai::defaultstate_death_enter();
	self.inpain = 1;
	self thread shut_off_fx();
}

/*
	Name: state_death_update
	Namespace: hunter
	Checksum: 0x9C03E0DD
	Offset: 0x1620
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	death_type = vehicle_ai::get_death_type(params);
	if(!isdefined(death_type))
	{
		params.death_type = "gibbed";
		death_type = params.death_type;
	}
	self vehicle_ai::ClearAllLookingAndTargeting();
	self vehicle_ai::ClearAllMovement();
	self CancelAIMove();
	self SetSpeedImmediate(0);
	self SetVehVelocity((0, 0, 0));
	self SetPhysAcceleration((0, 0, 0));
	self SetAngularVelocity((0, 0, 0));
	self vehicle_ai::defaultstate_death_update(params);
}

/*
	Name: state_unaware_enter
	Namespace: hunter
	Checksum: 0xC1DE2D5E
	Offset: 0x1758
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function state_unaware_enter(params)
{
	Ratio = 0.5;
	Accel = self GetDefaultAcceleration();
	self SetSpeed(Ratio * self.settings.defaultMoveSpeed, Ratio * Accel, Ratio * Accel);
}

/*
	Name: state_unaware_update
	Namespace: hunter
	Checksum: 0x6B20D791
	Offset: 0x17E0
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function state_unaware_update(params)
{
	self endon("change_state");
	self endon("death");
	if(isdefined(self.enemy))
	{
		self vehicle_ai::set_state("combat");
	}
	self ClearLookAtEnt();
	self disable_turrets();
	self thread Movement_Thread_Wander();
	while(1)
	{
		self waittill("enemy");
		self vehicle_ai::set_state("combat");
	}
}

/*
	Name: state_unaware_exit
	Namespace: hunter
	Checksum: 0x5828622E
	Offset: 0x18B0
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function state_unaware_exit(params)
{
	self notify("end_movement_thread");
}

/*
	Name: Movement_Thread_Wander
	Namespace: hunter
	Checksum: 0x47831FAF
	Offset: 0x18D8
	Size: 0x309
	Parameters: 0
	Flags: None
*/
function Movement_Thread_Wander()
{
	self endon("death");
	self notify("end_movement_thread");
	self endon("end_movement_thread");
	constMinSearchRadius = 120;
	constMaxSearchRadius = 800;
	minSearchRadius = math::clamp(constMinSearchRadius, 0, self.goalRadius);
	maxSearchRadius = math::clamp(constMaxSearchRadius, constMinSearchRadius, self.goalRadius);
	halfHeight = 400;
	innerSpacing = 80;
	outerSpacing = 50;
	maxGoalTimeout = 15;
	timeAtSamePosition = 2.5 + RandomFloat(1);
	while(1)
	{
		queryResult = PositionQuery_Source_Navigation(self.origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing);
		PositionQuery_Filter_DistanceToGoal(queryResult, self);
		vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
		vehicle_ai::PositionQuery_Filter_Random(queryResult, 0, 10);
		vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
		stayAtGoal = timeAtSamePosition > 0.2;
		foundpath = 0;
		for(i = 0; i < queryResult.data.size && !foundpath; i++)
		{
			goalpos = queryResult.data[i].origin;
			foundpath = self SetVehGoalPos(goalpos, stayAtGoal, 1);
		}
		if(foundpath)
		{
			msg = self util::waittill_any_timeout(maxGoalTimeout, "near_goal", "force_goal", "reached_end_node", "goal");
			if(stayAtGoal)
			{
				wait(RandomFloatRange(0.5 * timeAtSamePosition, timeAtSamePosition));
			}
		}
		else
		{
			wait(1);
		}
	}
}

/*
	Name: enable_turrets
	Namespace: hunter
	Checksum: 0xBC2692DC
	Offset: 0x1BF0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function enable_turrets()
{
	self turret::enable(1, 0);
	self turret::enable(2, 0);
}

/*
	Name: disable_turrets
	Namespace: hunter
	Checksum: 0x70A988A6
	Offset: 0x1C30
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function disable_turrets()
{
	self turret::disable(1);
	self turret::disable(2);
	self side_turrets_forward();
}

/*
	Name: side_turrets_forward
	Namespace: hunter
	Checksum: 0x1B974C69
	Offset: 0x1C88
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function side_turrets_forward()
{
	self SetTurretTargetRelativeAngles((10, -90, 0), 1);
	self SetTurretTargetRelativeAngles((10, 90, 0), 2);
}

/*
	Name: state_combat_enter
	Namespace: hunter
	Checksum: 0x3C3C6000
	Offset: 0x1CE8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function state_combat_enter(params)
{
	Ratio = 1;
	Accel = self GetDefaultAcceleration();
	self SetSpeed(Ratio * self.settings.defaultMoveSpeed, Ratio * Accel, Ratio * Accel);
	self hunter_lockon_fx();
	self enable_turrets();
}

/*
	Name: state_combat_update
	Namespace: hunter
	Checksum: 0xB1CAB2D2
	Offset: 0x1DA0
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	if(!isdefined(self.enemy))
	{
		self vehicle_ai::set_state("unaware");
	}
	self thread Movement_Thread_StayInDistance();
	self thread Attack_Thread_MainTurret();
	self thread Attack_Thread_rocket();
	while(1)
	{
		self waittill("NO_ENEMY");
		self vehicle_ai::set_state("unaware");
	}
}

/*
	Name: state_combat_exit
	Namespace: hunter
	Checksum: 0x30B50306
	Offset: 0x1E70
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function state_combat_exit(params)
{
	self notify("end_attack_thread");
	self notify("end_movement_thread");
	self ClearTurretTarget();
}

/*
	Name: state_strafe_enter
	Namespace: hunter
	Checksum: 0x2C2C8A7
	Offset: 0x1EB8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function state_strafe_enter(params)
{
	Ratio = 2;
	Accel = Ratio * self GetDefaultAcceleration();
	speed = Ratio * self.settings.defaultMoveSpeed;
	strafe_speed_attribute = ai::get_behavior_attribute("strafe_speed");
	if(strafe_speed_attribute > 0)
	{
		speed = strafe_speed_attribute;
	}
	self SetSpeed(speed, Accel, Accel);
}

/*
	Name: state_strafe_update
	Namespace: hunter
	Checksum: 0xE06314F3
	Offset: 0x1F88
	Size: 0x7EB
	Parameters: 1
	Flags: None
*/
function state_strafe_update(params)
{
	self endon("change_state");
	self endon("death");
	self ClearVehGoalPos();
	distanceToTarget = 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	target = self.origin + AnglesToForward(self.angles) * distanceToTarget;
	if(isdefined(self.enemy))
	{
		distanceToTarget = Distance(self.origin, self.enemy.origin);
	}
	distanceThreshold = 500 + distanceToTarget * 0.08;
	strafe_distance_attribute = ai::get_behavior_attribute("strafe_distance");
	if(strafe_distance_attribute > 0)
	{
		distanceThreshold = strafe_distance_attribute;
	}
	maxSearchRadius = distanceThreshold * 1.5;
	halfHeight = 300;
	outerSpacing = maxSearchRadius * 0.05;
	innerSpacing = outerSpacing * 2;
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing);
	PositionQuery_Filter_Directness(queryResult, self.origin, target);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	PositionQuery_Filter_InClaimedLocation(queryResult, self);
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult, 200);
	foreach(point in queryResult.data)
	{
		distanceToPointSqr = DistanceSquared(point.origin, self.origin);
		if(distanceToPointSqr < distanceThreshold * 0.5)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = distanceThreshold * -1;
			#/
			point.score = point.score + distanceThreshold * -1;
		}
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = sqrt(distanceToPointSqr);
		#/
		point.score = point.score + sqrt(distanceToPointSqr);
		diffToPreferedDirectness = Abs(point.directness - 0);
		directnessScore = mapfloat(0, 1, 1000, 0, diffToPreferedDirectness);
		if(diffToPreferedDirectness > 0.1)
		{
			directnessScore = directnessScore - 500;
		}
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = point.directness;
		#/
		point.score = point.score + point.directness;
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = directnessScore;
		#/
		point.score = point.score + directnessScore;
		if(point.directionChange < 0.6)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -2000;
			#/
			point.score = point.score + -2000;
		}
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = point.directionChange;
		#/
		point.score = point.score + point.directionChange;
	}
	vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	foreach(point in queryResult.data)
	{
		self.current_pathto_pos = point.origin;
		foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 1);
		if(foundpath)
		{
			msg = self util::waittill_any_timeout(5, "near_goal", "force_goal", "goal", "enemy_visible");
			break;
		}
	}
	previous_state = self vehicle_ai::get_previous_state();
	if(!isdefined(previous_state) || previous_state == "strafe")
	{
		previous_state = "combat";
	}
	self vehicle_ai::set_state(previous_state);
}

/*
	Name: state_strafe_exit
	Namespace: hunter
	Checksum: 0x371A2020
	Offset: 0x2780
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function state_strafe_exit(params)
{
	vehicle_ai::Cooldown("strafe_again", 2);
}

/*
	Name: GetNextMovePosition_tactical
	Namespace: hunter
	Checksum: 0x448EE6B6
	Offset: 0x27B8
	Size: 0x6D9
	Parameters: 1
	Flags: None
*/
function GetNextMovePosition_tactical(enemy)
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	selfDistToEnemy = Distance2D(self.origin, enemy.origin);
	goodDist = 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	tooCloseDist = 0.8 * goodDist;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToEnemy);
	preferedDistAwayFromOrigin = 150;
	maxSearchRadius = 1000 * queryMultiplier;
	halfHeight = 300 * queryMultiplier;
	innerSpacing = 80 * queryMultiplier;
	outerSpacing = 80 * queryMultiplier;
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	PositionQuery_Filter_InClaimedLocation(queryResult, self);
	PositionQuery_Filter_Sight(queryResult, enemy.origin, self GetEye() - self.origin, self, 0, enemy);
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult, 200);
	self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, enemy, self.settings.engagementDistMin, self.settings.engagementDistMax);
	self vehicle_ai::PositionQuery_Filter_Random(queryResult, 0, 30);
	goalHeight = enemy.origin[2] + 0.5 * self.settings.engagementHeightMin + self.settings.engagementHeightMax;
	foreach(point in queryResult.data)
	{
		if(!point.visibility)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -600;
			#/
			point.score = point.score + -600;
		}
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
			point._scoreDebug["Dev Block strings are not supported"] = mapfloat(0, preferedDistAwayFromOrigin, 0, 600, point.distToOrigin2D);
		#/
		point.score = point.score + mapfloat(0, preferedDistAwayFromOrigin, 0, 600, point.distToOrigin2D);
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
		preferedHeightRange = 75;
		distFromPreferredHeight = Abs(point.origin[2] - goalHeight);
		if(distFromPreferredHeight > preferedHeightRange)
		{
			heightScore = mapfloat(preferedHeightRange, 5000, 0, 9000, distFromPreferredHeight) * -1;
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = heightScore;
			#/
			point.score = point.score + heightScore;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
	if(queryResult.data.size)
	{
		return queryResult.data[0].origin;
	}
	return self.origin;
}

/*
	Name: Movement_Thread_StayInDistance
	Namespace: hunter
	Checksum: 0x7232B6B0
	Offset: 0x2EA0
	Size: 0x88B
	Parameters: 0
	Flags: None
*/
function Movement_Thread_StayInDistance()
{
	self endon("death");
	self notify("end_movement_thread");
	self endon("end_movement_thread");
	maxGoalTimeout = 10;
	stuckCount = 0;
	while(1)
	{
		enemy = self.enemy;
		if(!isdefined(enemy))
		{
			wait(1);
			continue;
		}
		usePathfinding = 1;
		onNavVolume = IsPointInNavvolume(self.origin, "navvolume_big");
		if(!onNavVolume)
		{
			getbackPoint = undefined;
			pointOnNavVolume = self GetClosestPointOnNavVolume(self.origin, 500);
			if(isdefined(pointOnNavVolume))
			{
				if(SightTracePassed(self.origin, pointOnNavVolume, 0, self))
				{
					getbackPoint = pointOnNavVolume;
				}
			}
			if(!isdefined(getbackPoint))
			{
				queryResult = PositionQuery_Source_Navigation(self.origin, 0, 800, 400, 1.5 * self.radius);
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
				goalpos = self GetClosestPointOnNavVolume(self.goalpos, 200);
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
			else
			{
				self.current_pathto_pos = GetNextMovePosition_tactical(enemy);
				usePathfinding = 1;
			}
		}
		if(!isdefined(self.current_pathto_pos))
		{
			wait(0.5);
			continue;
		}
		distanceToGoalSq = DistanceSquared(self.current_pathto_pos, self.origin);
		if(distanceToGoalSq > 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax * 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax)
		{
			self SetSpeed(self.settings.defaultMoveSpeed * 2);
		}
		else
		{
			self SetSpeed(self.settings.defaultMoveSpeed);
		}
		self SetLookAtEnt(enemy);
		foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, usePathfinding);
		if(foundpath)
		{
			/#
				if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
				{
					recordLine(self.origin, self.current_pathto_pos, (0.3, 1, 0));
					recordLine(self.origin, enemy.origin, (1, 0, 0.4));
				}
			#/
			msg = self util::waittill_any_timeout(maxGoalTimeout, "near_goal", "force_goal", "goal");
		}
		else
		{
			wait(0.5);
		}
		enemy = self.enemy;
		if(isdefined(enemy))
		{
			goalHeight = enemy.origin[2] + 0.5 * self.settings.engagementHeightMin + self.settings.engagementHeightMax;
			distFromPreferredHeight = Abs(self.origin[2] - goalHeight);
			farDist = self.settings.engagementDistMax;
			nearDist = self.settings.engagementDistMin;
			selfDistToEnemy = Distance2D(self.origin, enemy.origin);
			if(self VehCanSee(enemy) && selfDistToEnemy < farDist && selfDistToEnemy > nearDist && distFromPreferredHeight < 230)
			{
				msg = self util::waittill_any_timeout(RandomFloatRange(2, 4), "enemy_not_visible");
				if(msg == "enemy_not_visible")
				{
					msg = self util::waittill_any_timeout(1, "enemy_visible");
					if(msg != "timeout")
					{
						wait(1);
					}
				}
			}
		}
		else
		{
			wait(1);
		}
	}
}

/*
	Name: Delay_Target_ToEnemy_Thread
	Namespace: hunter
	Checksum: 0x6B660E09
	Offset: 0x3738
	Size: 0x203
	Parameters: 3
	Flags: None
*/
function Delay_Target_ToEnemy_Thread(point, enemy, timeToHit)
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	self endon("faketarget_stop_moving");
	enemy endon("death");
	if(!isdefined(self.fakeTargetEnt))
	{
		self.fakeTargetEnt = spawn("script_origin", point);
	}
	self.fakeTargetEnt Unlink();
	self.fakeTargetEnt.origin = point;
	self SetTurretTargetEnt(self.fakeTargetEnt);
	self waittill("turret_on_target");
	timeStart = GetTime();
	offset = (0, 0, 0);
	if(IsSentient(enemy))
	{
		offset = enemy GetEye() - enemy.origin;
	}
	while(GetTime() < timeStart + timeToHit * 1000)
	{
		self.fakeTargetEnt.origin = LerpVector(point, enemy.origin + offset, GetTime() - timeStart / timeToHit * 1000);
		wait(0.05);
	}
	self.fakeTargetEnt.origin = enemy.origin + offset;
	wait(0.05);
	self.fakeTargetEnt LinkTo(enemy);
}

/*
	Name: Attack_Thread_MainTurret
	Namespace: hunter
	Checksum: 0x2EA057ED
	Offset: 0x3948
	Size: 0x237
	Parameters: 0
	Flags: None
*/
function Attack_Thread_MainTurret()
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	while(1)
	{
		enemy = self.enemy;
		if(isdefined(enemy))
		{
			self SetLookAtEnt(enemy);
			if(self VehCanSee(enemy))
			{
				vectorFromEnemy = VectorNormalize((self.origin - enemy.origin[0], self.origin - enemy.origin[1], 0));
				self thread Delay_Target_ToEnemy_Thread(enemy.origin + vectorFromEnemy * 300, enemy, 1.5);
				self waittill("turret_on_target");
				self vehicle_ai::fire_for_time(2 + RandomFloat(0.8));
				self ClearTurretTarget();
				self SetTurretTargetRelativeAngles(VectorScale((1, 0, 0), 15), 0);
				if(isdefined(enemy) && isai(enemy))
				{
					wait(2.5 + RandomFloat(0.5));
				}
				else
				{
					wait(2 + RandomFloat(0.4));
				}
			}
			else
			{
				wait(0.4);
			}
		}
		else
		{
			self ClearTurretTarget();
			self ClearLookAtEnt();
			wait(0.4);
		}
	}
}

/*
	Name: Attack_Thread_rocket
	Namespace: hunter
	Checksum: 0xF4557ED0
	Offset: 0x3B88
	Size: 0x4B7
	Parameters: 0
	Flags: None
*/
function Attack_Thread_rocket()
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	while(1)
	{
		enemy = self.enemy;
		if(!isdefined(enemy))
		{
			wait(1);
			continue;
		}
		if(isdefined(enemy) && self VehCanSee(enemy) && vehicle_ai::IsCooldownReady("rocket_launcher"))
		{
			vehicle_ai::Cooldown("rocket_launcher", 8);
			self notify("end_movement_thread");
			self ClearVehGoalPos();
			self SetVehGoalPos(self.origin, 1, 0);
			target = enemy.origin;
			self SetLookAtEnt(enemy);
			self hunter_lockon_fx();
			wait(1.5);
			eye = self GetTagOrigin("tag_eye");
			if(isdefined(enemy))
			{
				anglesToTarget = VectorToAngles(enemy.origin - eye);
				angles = anglesToTarget - self.angles;
				if(-30 < angles[0] && angles[0] < 60 && -70 < angles[1] && angles[1] < 70)
				{
					target = enemy.origin;
				}
				else
				{
					anglesToTarget = VectorToAngles(target - eye);
				}
			}
			else
			{
				anglesToTarget = VectorToAngles(target - eye);
			}
			rightDir = AnglesToRight(anglesToTarget);
			randomRange = 30;
			offset = [];
			offset[0] = rightDir * -1 * randomRange * 2 + (RandomFloatRange(randomRange * -1, randomRange), RandomFloatRange(randomRange * -1, randomRange), 0);
			offset[1] = rightDir * randomRange * 2 + (RandomFloatRange(randomRange * -1, randomRange), RandomFloatRange(randomRange * -1, randomRange), 0);
			self hunter_fire_one_missile(0, target, offset[0]);
			wait(0.5);
			if(isdefined(enemy))
			{
				eye = self GetTagOrigin("tag_eye");
				angles = VectorToAngles(enemy.origin - eye) - self.angles;
				if(-30 < angles[0] && angles[0] < 60 && -70 < angles[1] && angles[1] < 70)
				{
					target = enemy.origin;
				}
			}
			self hunter_fire_one_missile(1, target, offset[1]);
			wait(1);
			self thread Movement_Thread_StayInDistance();
		}
		wait(0.5);
	}
}

/*
	Name: side_turret_get_best_target
	Namespace: hunter
	Checksum: 0xB9CE47C9
	Offset: 0x4048
	Size: 0x16B
	Parameters: 2
	Flags: None
*/
function side_turret_get_best_target(a_potential_targets, n_index)
{
	if(self.ignoreall === 1)
	{
		return undefined;
	}
	shouldYield = 1 && level.gameskill < 3;
	main_turret_target = self.enemy;
	if(n_index === 2)
	{
		other_turret_target = turret::get_target(1);
	}
	if(shouldYield)
	{
		ArrayRemoveValue(a_potential_targets, main_turret_target);
		ArrayRemoveValue(a_potential_targets, other_turret_target);
	}
	e_best_target = undefined;
	while(!isdefined(e_best_target) && a_potential_targets.size > 0)
	{
		e_closest_target = ArrayGetClosest(self.origin, a_potential_targets);
		if(self turret::can_hit_target(e_closest_target, n_index))
		{
			e_best_target = e_closest_target;
		}
		else
		{
			ArrayRemoveValue(a_potential_targets, e_closest_target);
		}
	}
	return e_best_target;
}

/*
	Name: hunter_fire_one_missile
	Namespace: hunter
	Checksum: 0xE2B50B79
	Offset: 0x41C0
	Size: 0x247
	Parameters: 5
	Flags: None
*/
function hunter_fire_one_missile(launcher_index, target, offset, blinkLights, waittimeAfterBlinkLights)
{
	self endon("death");
	if(isdefined(blinkLights) && blinkLights)
	{
		self vehicle_ai::blink_lights_for_time(1);
		if(isdefined(waittimeAfterBlinkLights) && waittimeAfterBlinkLights > 0)
		{
			wait(waittimeAfterBlinkLights);
		}
	}
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	spawnTag = self.missileTags[launcher_index];
	origin = self GetTagOrigin(spawnTag);
	angles = self GetTagAngles(spawnTag);
	FORWARD = AnglesToForward(angles);
	up = anglesToUp(angles);
	if(isdefined(spawnTag) && isdefined(target))
	{
		weapon = GetWeapon("hunter_rocket_turret");
		if(IsEntity(target))
		{
			missile = MagicBullet(weapon, origin, target.origin + offset, self, target, offset);
		}
		else if(IsVec(target))
		{
			missile = MagicBullet(weapon, origin, target + offset, self);
		}
		else
		{
			missile = MagicBullet(weapon, origin, target.origin + offset, self);
		}
	}
}

/*
	Name: remote_missile_life
	Namespace: hunter
	Checksum: 0xCAD06E6B
	Offset: 0x4410
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function remote_missile_life()
{
	self endon("death");
	hostmigration::waitLongDurationWithHostMigrationPause(10);
	playFX(level.remote_mortar_fx["missileExplode"], self.origin);
	self playlocalsound("mpl_ks_reaper_explosion");
	self delete();
}

/*
	Name: hunter_lockon_fx
	Namespace: hunter
	Checksum: 0x1A4BB596
	Offset: 0x44A8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function hunter_lockon_fx()
{
	self thread vehicle_ai::blink_lights_for_time(1.5);
	self playsound("veh_hunter_alarm_target");
}

/*
	Name: getEnemyArray
	Namespace: hunter
	Checksum: 0xD1E5E1D6
	Offset: 0x44F8
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function getEnemyArray(include_ai, include_player)
{
	enemyArray = [];
	enemy_team = "allies";
	if(isdefined(include_ai) && include_ai)
	{
		aiArray = GetAITeamArray(enemy_team);
		enemyArray = ArrayCombine(enemyArray, aiArray, 0, 0);
	}
	if(isdefined(include_player) && include_player)
	{
		playerArray = GetPlayers(enemy_team);
		enemyArray = ArrayCombine(enemyArray, playerArray, 0, 0);
	}
	return enemyArray;
}

/*
	Name: is_point_in_view
	Namespace: hunter
	Checksum: 0xC9A47357
	Offset: 0x45F0
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function is_point_in_view(point, do_trace)
{
	if(!isdefined(point))
	{
		return 0;
	}
	scanner = self.frontScanner;
	vector_to_point = point - scanner.origin;
	in_view = LengthSquared(vector_to_point) <= 10000 * 10000;
	if(in_view)
	{
		in_view = util::within_fov(scanner.origin, scanner.angles, point, cos(190));
	}
	if(in_view && (isdefined(do_trace) && do_trace) && isdefined(self.enemy))
	{
		in_view = SightTracePassed(scanner.origin, point, 0, self.enemy);
	}
	return in_view;
}

/*
	Name: is_valid_target
	Namespace: hunter
	Checksum: 0xA11F8B2
	Offset: 0x4730
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function is_valid_target(target, do_trace)
{
	target_is_valid = 1;
	if(isdefined(target.ignoreme) && target.ignoreme || target.health <= 0)
	{
		target_is_valid = 0;
	}
	else if(IsSentient(target) && (target IsNoTarget() || target ai::is_dead_sentient()))
	{
		target_is_valid = 0;
	}
	else if(isdefined(target.origin) && !is_point_in_view(target.origin, do_trace))
	{
		target_is_valid = 0;
	}
	return target_is_valid;
}

/*
	Name: get_enemies_in_view
	Namespace: hunter
	Checksum: 0x28C2DAC3
	Offset: 0x4840
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function get_enemies_in_view(do_trace)
{
	validEnemyArray = [];
	enemyArray = getEnemyArray(1, 1);
	foreach(enemy in enemyArray)
	{
		if(is_valid_target(enemy, do_trace))
		{
			if(!isdefined(validEnemyArray))
			{
				validEnemyArray = [];
			}
			else if(!IsArray(validEnemyArray))
			{
				validEnemyArray = Array(validEnemyArray);
			}
			validEnemyArray[validEnemyArray.size] = enemy;
		}
	}
	return validEnemyArray;
}

/*
	Name: hunter_scanner_init
	Namespace: hunter
	Checksum: 0xCB503EA2
	Offset: 0x4978
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function hunter_scanner_init()
{
	self.frontScanner = spawn("script_model", self GetTagOrigin("tag_gunner_flash3"));
	self.frontScanner SetModel("tag_origin");
	self.frontScanner.angles = self GetTagAngles("tag_gunner_flash3");
	self.frontScanner LinkTo(self, "tag_gunner_flash3");
	self.frontScanner.owner = self;
	self.frontScanner.hasTargetEnt = 0;
	self.frontScanner.sndScanningEnt = spawn("script_origin", self.frontScanner.origin + AnglesToForward(self.angles) * 1000);
	self.frontScanner.sndScanningEnt LinkTo(self.frontScanner);
	wait(0.25);
	if(0)
	{
		PlayFXOnTag(self.settings.spotlightfx, self.frontScanner, "tag_origin");
	}
}

/*
	Name: hunter_scanner_SetTargetEntity
	Namespace: hunter
	Checksum: 0x108D492F
	Offset: 0x4B20
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function hunter_scanner_SetTargetEntity(targetEnt, offset)
{
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	if(isdefined(targetEnt))
	{
		self.frontScanner.targetEnt = targetEnt;
		self.frontScanner.hasTargetEnt = 1;
		self setGunnerTargetEnt(self.frontScanner.targetEnt, offset, 2);
	}
}

/*
	Name: hunter_scanner_ClearLookTarget
	Namespace: hunter
	Checksum: 0x1590370B
	Offset: 0x4BB8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function hunter_scanner_ClearLookTarget()
{
	self.frontScanner.hasTargetEnt = 0;
	self cleargunnertarget(2);
}

/*
	Name: hunter_scanner_SetTargetPosition
	Namespace: hunter
	Checksum: 0xFF2AE343
	Offset: 0x4BF8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function hunter_scanner_SetTargetPosition(targetPos)
{
	if(isdefined(targetPos))
	{
		self.frontScanner.targetPos = targetPos;
		self SetGunnerTargetVec(self.frontScanner.targetPos, 2);
	}
}

/*
	Name: hunter_frontScanning
	Namespace: hunter
	Checksum: 0xA20ECEA
	Offset: 0x4C58
	Size: 0x42F
	Parameters: 0
	Flags: None
*/
function hunter_frontScanning()
{
	self endon("death_shut_off");
	self endon("crash_done");
	self endon("death");
	hunter_scanner_init();
	offsetFactorPitch = 0;
	offsetFactorYaw = 0;
	pitchStep = 2.236068;
	yawStep = 3.141593;
	pitchRange = 20;
	yawRange = 45;
	scannerDirection = undefined;
	while(1)
	{
		scannerOrigin = self.frontScanner.origin;
		if(isdefined(self.inpain) && self.inpain)
		{
			wait(0.3);
			offset = VectorScale((1, 0, 0), 50) + (math::randomSign() * RandomFloatRange(1, 2) * pitchRange, math::randomSign() * RandomFloatRange(1, 2) * yawRange, 0);
			scannerDirection = AnglesToForward(self.angles + offset);
		}
		else if(!isdefined(self.enemy))
		{
			if(0)
			{
				self.frontScanner.sndScanningEnt PlayLoopSound("veh_hunter_scanner_loop", 1);
			}
			offsetFactorPitch = offsetFactorPitch + pitchStep;
			offsetFactorYaw = offsetFactorYaw + yawStep;
			offset = VectorScale((1, 0, 0), 50) + (sin(offsetFactorPitch) * pitchRange, cos(offsetFactorYaw) * yawRange, 0);
			scannerDirection = AnglesToForward(self.angles + offset);
			enemies = get_enemies_in_view(1);
			if(enemies.size > 0)
			{
				closest_enemy = ArrayGetClosest(self.origin, enemies);
				self.favoriteenemy = closest_enemy;
				/#
					line(scannerOrigin, closest_enemy.origin, (0, 1, 0), 1, 3);
				#/
			}
		}
		else if(self is_point_in_view(self.enemy.origin, 1))
		{
			self notify("hunter_lockOnTargetInSight");
		}
		else
		{
			self notify("hunter_lockOnTargetOutSight");
		}
		scannerDirection = VectorNormalize(self.enemy.origin - scannerOrigin);
		if(0)
		{
			self.frontScanner.sndScanningEnt StopLoopSound(1);
		}
		targetLocation = scannerOrigin + scannerDirection * 1000;
		self hunter_scanner_SetTargetPosition(targetLocation);
		/#
			line(scannerOrigin, self.frontScanner.targetPos, (0, 1, 0), 1, 1000);
		#/
		wait(0.1);
	}
}

/*
	Name: hunter_exit_vehicle
	Namespace: hunter
	Checksum: 0x31EF45A4
	Offset: 0x5090
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function hunter_exit_vehicle()
{
	self waittill("exit_vehicle", player);
	player.ignoreme = 0;
	player DisableInvulnerability();
	self SetHeliHeightLock(0);
	self EnableAimAssist();
	self SetVehicleType(self.original_vehicle_type);
	self.attachedpath = undefined;
	self SetGoal(self.origin, 0, 4096, 512);
}

/*
	Name: hunter_scripted
	Namespace: hunter
	Checksum: 0x28342E1A
	Offset: 0x5160
	Size: 0x20B
	Parameters: 1
	Flags: None
*/
function hunter_scripted(params)
{
	params.driver = self GetSeatOccupant(0);
	if(isdefined(params.driver))
	{
		self DisableAimAssist();
		self thread vehicle_death::vehicle_damage_filter("firestorm_turret");
		params.driver.ignoreme = 1;
		params.driver EnableInvulnerability();
		if(isdefined(self.vehicle_weapon_override))
		{
			self SetVehWeapon(self.vehicle_weapon_override);
		}
		self thread hunter_exit_vehicle();
		self thread hunter_collision_player();
		self thread player_fire_update_side_turret_1();
		self thread player_fire_update_side_turret_2();
		self thread player_fire_update_rocket();
	}
	if(isdefined(self.goal_node) && isdefined(self.goal_node.hunter_claimed))
	{
		self.goal_node.hunter_claimed = undefined;
	}
	self ClearTargetEntity();
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	self ClearLookAtEnt();
	self ResumeSpeed();
}

/*
	Name: player_fire_update_side_turret_1
	Namespace: hunter
	Checksum: 0x9C2A8D07
	Offset: 0x5378
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function player_fire_update_side_turret_1()
{
	self endon("death");
	self endon("exit_vehicle");
	weapon = self SeatGetWeapon(1);
	fireTime = weapon.fireTime;
	while(1)
	{
		self SetGunnerTargetVec(self GetTurretTargetVec(0), 0);
		if(self IsDriverFiring())
		{
			self FireWeapon(1);
		}
		wait(fireTime);
	}
}

/*
	Name: player_fire_update_side_turret_2
	Namespace: hunter
	Checksum: 0x91BF6139
	Offset: 0x5448
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function player_fire_update_side_turret_2()
{
	self endon("death");
	self endon("exit_vehicle");
	weapon = self SeatGetWeapon(2);
	fireTime = weapon.fireTime;
	while(1)
	{
		self SetGunnerTargetVec(self GetTurretTargetVec(0), 1);
		if(self IsDriverFiring())
		{
			self FireWeapon(2);
		}
		wait(fireTime);
	}
}

/*
	Name: player_fire_update_rocket
	Namespace: hunter
	Checksum: 0x63AF35C
	Offset: 0x5520
	Size: 0x197
	Parameters: 0
	Flags: None
*/
function player_fire_update_rocket()
{
	self endon("death");
	self endon("exit_vehicle");
	weapon = GetWeapon("hunter_rocket_turret_player");
	fireTime = weapon.fireTime;
	driver = self GetSeatOccupant(0);
	while(1)
	{
		if(driver buttonpressed("BUTTON_A"))
		{
			spawnTag0 = self.missileTags[0];
			spawnTag1 = self.missileTags[1];
			origin0 = self GetTagOrigin(spawnTag0);
			origin1 = self GetTagOrigin(spawnTag1);
			target = self GetTurretTargetVec(0);
			MagicBullet(weapon, origin0, target);
			MagicBullet(weapon, origin1, target);
			wait(fireTime);
		}
		wait(0.05);
	}
}

/*
	Name: hunter_collision_player
	Namespace: hunter
	Checksum: 0xAF53D3C4
	Offset: 0x56C0
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function hunter_collision_player()
{
	self endon("change_state");
	self endon("crash_done");
	self endon("death");
	while(1)
	{
		self waittill("veh_collision", velocity, normal);
		driver = self GetSeatOccupant(0);
		if(isdefined(driver) && LengthSquared(velocity) > 4900)
		{
			Earthquake(0.25, 0.25, driver.origin, 50);
			driver PlayRumbleOnEntity("damage_heavy");
		}
	}
}

/*
	Name: hunter_update_rumble
	Namespace: hunter
	Checksum: 0xF342B0FF
	Offset: 0x57C0
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function hunter_update_rumble()
{
	self endon("death");
	self endon("exit_vehicle");
	while(1)
	{
		vr = Abs(self getspeed() / self GetMaxSpeed());
		if(vr < 0.1)
		{
			level.player PlayRumbleOnEntity("hunter_fly");
			wait(0.35);
		}
		else
		{
			time = RandomFloatRange(0.1, 0.2);
			Earthquake(RandomFloatRange(0.1, 0.15), time, self.origin, 200);
			level.player PlayRumbleOnEntity("hunter_fly");
			wait(time);
		}
	}
}

/*
	Name: hunter_self_destruct
	Namespace: hunter
	Checksum: 0x10F5C715
	Offset: 0x5910
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function hunter_self_destruct()
{
	self endon("death");
	self endon("exit_vehicle");
	self_destruct = 0;
	self_destruct_time = 0;
	while(1)
	{
		if(!self_destruct)
		{
			if(level.player meleeButtonPressed())
			{
				self_destruct = 1;
				self_destruct_time = 5;
			}
			wait(0.05);
			continue;
		}
		else
		{
			IPrintLnBold(self_destruct_time);
			wait(1);
			self_destruct_time = self_destruct_time - 1;
			if(self_destruct_time == 0)
			{
				driver = self GetSeatOccupant(0);
				if(isdefined(driver))
				{
					driver DisableInvulnerability();
				}
				Earthquake(3, 1, self.origin, 256);
				RadiusDamage(self.origin, 1000, 15000, 15000, level.player, "MOD_EXPLOSIVE");
				self DoDamage(self.health + 1000, self.origin);
			}
			continue;
		}
	}
}

/*
	Name: hunter_level_out_for_landing
	Namespace: hunter
	Checksum: 0x12A28AA9
	Offset: 0x5AC0
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function hunter_level_out_for_landing()
{
	self endon("death");
	self endon("emped");
	self endon("landed");
	while(isdefined(self.emped))
	{
		velocity = self.velocity;
		self.angles = (self.angles[0] * 0.85, self.angles[1], self.angles[2] * 0.85);
		ang_vel = self GetAngularVelocity() * 0.85;
		self SetAngularVelocity(ang_vel);
		self SetVehVelocity(velocity);
		wait(0.05);
	}
}

/*
	Name: hunter_emped
	Namespace: hunter
	Checksum: 0xB78645A1
	Offset: 0x5BB8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function hunter_emped(params)
{
	self endon("death");
	self endon("emped");
	self.emped = 1;
	wait(RandomFloatRange(4, 7));
	self vehicle_ai::evaluate_connections();
}

/*
	Name: hunter_pain_for_time
	Namespace: hunter
	Checksum: 0x885364E1
	Offset: 0x5C28
	Size: 0x1C7
	Parameters: 4
	Flags: None
*/
function hunter_pain_for_time(time, velocityStablizeParam, rotationStablizeParam, restoreLookPoint)
{
	self endon("death");
	self.painStartTime = GetTime();
	if(!(isdefined(self.inpain) && self.inpain))
	{
		self.inpain = 1;
		while(GetTime() < self.painStartTime + time * 1000)
		{
			self SetVehVelocity(self.velocity * velocityStablizeParam);
			self SetAngularVelocity(self GetAngularVelocity() * rotationStablizeParam);
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
	Name: hunter_pain_small
	Namespace: hunter
	Checksum: 0x5972B480
	Offset: 0x5DF8
	Size: 0x1EB
	Parameters: 6
	Flags: None
*/
function hunter_pain_small(eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName)
{
	if(!isdefined(hitPoint) || !isdefined(hitDirection))
	{
		return;
	}
	self SetVehVelocity(self.velocity + VectorNormalize(hitDirection) * 20);
	if(!(isdefined(self.inpain) && self.inpain))
	{
		vecRight = AnglesToRight(self.angles);
		sign = math::sign(VectorDot(vecRight, hitDirection));
		yaw_vel = sign * RandomFloatRange(100, 140);
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + (RandomFloatRange(-120, -100), yaw_vel, RandomFloatRange(-100, 100));
		self SetAngularVelocity(ang_vel);
		self thread hunter_pain_for_time(1.5, 1, 0.8);
	}
	self vehicle_ai::set_state("strafe");
}

/*
	Name: HunterCallback_VehicleDamage
	Namespace: hunter
	Checksum: 0x28A9F65A
	Offset: 0x5FF0
	Size: 0x28F
	Parameters: 15
	Flags: None
*/
function HunterCallback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	driver = self GetSeatOccupant(0);
	if(isdefined(eAttacker) && eAttacker.team == self.team)
	{
		return 0;
	}
	num_players = GetPlayers().size;
	maxDamage = self.healthdefault * 0.35 - 0.025 * num_players;
	if(sMeansOfDeath !== "MOD_UNKNOWN" && iDamage > maxDamage)
	{
		iDamage = maxDamage;
	}
	if(!isdefined(self.damageLevel))
	{
		self.damageLevel = 0;
		self.newDamageLevel = self.damageLevel;
	}
	newDamageLevel = vehicle::should_update_damage_fx_level(self.health, iDamage, self.healthdefault);
	if(newDamageLevel > self.damageLevel)
	{
		self.newDamageLevel = newDamageLevel;
	}
	if(self.newDamageLevel > self.damageLevel)
	{
		self.damageLevel = self.newDamageLevel;
		if(self.pain_when_damagelevel_change === 1)
		{
			hunter_pain_small(eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName);
		}
		vehicle::set_damage_fx_level(self.damageLevel);
	}
	if(vehicle_ai::should_emp(self, weapon, sMeansOfDeath, eInflictor, eAttacker))
	{
		hunter_pain_small(eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName);
	}
	return iDamage;
}

