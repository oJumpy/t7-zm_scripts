#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\array_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_spike_charge_siegebot;

#namespace siegebot;

/*
	Name: __init__sytem__
	Namespace: siegebot
	Checksum: 0xE902DE76
	Offset: 0x498
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("siegebot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: siegebot
	Checksum: 0xE10F2703
	Offset: 0x4D8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("siegebot", &siegebot_initialize);
}

/*
	Name: siegebot_initialize
	Namespace: siegebot
	Checksum: 0x34518660
	Offset: 0x510
	Size: 0x3D3
	Parameters: 0
	Flags: None
*/
function siegebot_initialize()
{
	self useanimtree(-1);
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	Target_Set(self, VectorScale((0, 0, 1), 84));
	self EnableAimAssist();
	self SetNearGoalNotifyDist(40);
	self.fovcosine = 0.5;
	self.fovcosinebusy = 0.5;
	self.maxsightdistsqrd = 10000 * 10000;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 9999999;
	self.goalHeight = 5000;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.overrideVehicleDamage = &siegebot_callback_damage;
	self siegebot_update_difficulty();
	self SetGunnerTurretOnTargetRange(0, self.settings.gunner_turret_on_target_range);
	self ASMRequestSubstate("locomotion@movement");
	if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
	{
		self ASMSetAnimationRate(0.5);
		self HidePart("tag_turret_canopy_animate");
		self HidePart("tag_turret_panel_01_d0");
		self HidePart("tag_turret_panel_02_d0");
		self HidePart("tag_turret_panel_03_d0");
		self HidePart("tag_turret_panel_04_d0");
		self HidePart("tag_turret_panel_05_d0");
	}
	else if(self.vehicleType == "zombietron_veh_siegebot")
	{
		self ASMSetAnimationRate(1.429);
	}
	self initJumpStruct();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	self.ignoreFireFly = 1;
	self.ignoreDecoy = 1;
	self vehicle_ai::InitThreatBias();
	self thread vehicle_ai::target_hijackers();
	if(!SessionModeIsMultiplayerGame())
	{
		defaultRole();
	}
}

/*
	Name: siegebot_update_difficulty
	Namespace: siegebot
	Checksum: 0x1D50B3CE
	Offset: 0x8F0
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function siegebot_update_difficulty()
{
	value = gameskill::get_general_difficulty_level();
	scale_up = mapfloat(0, 9, 0.8, 2, value);
	scale_down = mapfloat(0, 9, 1, 0.5, value);
	self.difficulty_scale_up = scale_up;
	self.difficulty_scale_down = scale_down;
}

/*
	Name: defaultRole
	Namespace: siegebot
	Checksum: 0x77726EE1
	Offset: 0x9A0
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("combat").exit_func = &state_combat_exit;
	self vehicle_ai::get_state_callbacks("driving").update_func = &siegebot_driving;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::get_state_callbacks("pain").update_func = &pain_update;
	self vehicle_ai::get_state_callbacks("emped").enter_func = &emped_enter;
	self vehicle_ai::get_state_callbacks("emped").update_func = &emped_update;
	self vehicle_ai::get_state_callbacks("emped").exit_func = &emped_exit;
	self vehicle_ai::get_state_callbacks("emped").reenter_func = &emped_reenter;
	self vehicle_ai::add_state("jump", &state_jump_enter, &state_jump_update, &state_jump_exit);
	vehicle_ai::add_utility_connection("combat", "jump", &state_jump_can_enter);
	vehicle_ai::add_utility_connection("jump", "combat");
	self vehicle_ai::add_state("unaware", undefined, &state_unaware_update, undefined);
	vehicle_ai::StartInitialState("combat");
}

/*
	Name: state_death_update
	Namespace: siegebot
	Checksum: 0x6A12456F
	Offset: 0xC58
	Size: 0x2D3
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	self endon("nodeath_thread");
	StreamerModelHint(self.deathmodel, 6);
	death_type = vehicle_ai::get_death_type(params);
	if(!isdefined(death_type))
	{
		params.death_type = "gibbed";
		death_type = params.death_type;
	}
	self clean_up_spawned();
	self SetTurretSpinning(0);
	self stopMovementAndSetBrake();
	self vehicle::set_damage_fx_level(0);
	self playsound("veh_quadtank_sparks");
	if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
	{
		self ASMSetAnimationRate(1);
	}
	self.turretRotScale = 3;
	self SetTurretTargetRelativeAngles((0, 0, 0), 0);
	self SetTurretTargetRelativeAngles((0, 0, 0), 1);
	self SetTurretTargetRelativeAngles((0, 0, 0), 2);
	self ASMRequestSubstate("death@stationary");
	self waittill("model_swap");
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents();
	self vehicle_death::death_radius_damage();
	self waittill("bodyfall large");
	self RadiusDamage(self.origin + VectorScale((0, 0, 1), 10), self.radius * 0.8, 150, 60, self, "MOD_CRUSH");
	vehicle_ai::waittill_asm_complete("death@stationary", 3);
	self thread vehicle_death::CleanUp();
	self vehicle_death::FreeWhenSafe();
}

/*
	Name: siegebot_driving
	Namespace: siegebot
	Checksum: 0x6CA3460
	Offset: 0xF38
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function siegebot_driving(params)
{
	self thread siegebot_player_fireupdate();
	self thread siegebot_kill_on_tilting();
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
}

/*
	Name: siegebot_kill_on_tilting
	Namespace: siegebot
	Checksum: 0x5FCD1474
	Offset: 0xFC8
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function siegebot_kill_on_tilting()
{
	self endon("death");
	self endon("exit_vehicle");
	tileCount = 0;
	while(1)
	{
		selfup = anglesToUp(self.angles);
		worldup = (0, 0, 1);
		if(VectorDot(selfup, worldup) < 0.64)
		{
			tileCount = tileCount + 1;
		}
		else
		{
			tileCount = 0;
		}
		if(tileCount > 20)
		{
			driver = self GetSeatOccupant(0);
			self kill(self.origin);
		}
		wait(0.05);
	}
}

/*
	Name: siegebot_player_fireupdate
	Namespace: siegebot
	Checksum: 0x284D4062
	Offset: 0x10D8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function siegebot_player_fireupdate()
{
	self endon("death");
	self endon("exit_vehicle");
	weapon = self SeatGetWeapon(2);
	fireTime = weapon.fireTime;
	driver = self GetSeatOccupant(0);
	self thread siegebot_player_aimUpdate();
	while(1)
	{
		if(driver AttackButtonPressed())
		{
			self FireWeapon(2);
			wait(fireTime);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: siegebot_player_aimUpdate
	Namespace: siegebot
	Checksum: 0x72912557
	Offset: 0x11C8
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function siegebot_player_aimUpdate()
{
	self endon("death");
	self endon("exit_vehicle");
	while(1)
	{
		self SetGunnerTargetVec(self GetGunnerTargetVec(0), 1);
		wait(0.05);
	}
}

/*
	Name: emped_enter
	Namespace: siegebot
	Checksum: 0x2289F8FD
	Offset: 0x1228
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function emped_enter(params)
{
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	self.abnormal_status.emped = 1;
	self.abnormal_status.attacker = params.notify_param[1];
	self.abnormal_status.inflictor = params.notify_param[2];
	self vehicle::toggle_emp_fx(1);
}

/*
	Name: emped_update
	Namespace: siegebot
	Checksum: 0x9CA8B7EA
	Offset: 0x12E0
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function emped_update(params)
{
	self endon("death");
	self endon("change_state");
	self stopMovementAndSetBrake();
	if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
	{
		self ASMSetAnimationRate(1);
	}
	asmState = "damage_2@pain";
	self ASMRequestSubstate(asmState);
	self vehicle_ai::waittill_asm_complete(asmState, 3);
	self SetBrake(0);
	self vehicle_ai::evaluate_connections();
}

/*
	Name: emped_exit
	Namespace: siegebot
	Checksum: 0x5EF0A3FF
	Offset: 0x13D0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function emped_exit(params)
{
}

/*
	Name: emped_reenter
	Namespace: siegebot
	Checksum: 0xE3E19777
	Offset: 0x13E8
	Size: 0xD
	Parameters: 1
	Flags: None
*/
function emped_reenter(params)
{
	return 0;
}

/*
	Name: pain_toggle
	Namespace: siegebot
	Checksum: 0xEAB8827D
	Offset: 0x1400
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function pain_toggle(enabled)
{
	self._enablePain = enabled;
}

/*
	Name: pain_update
	Namespace: siegebot
	Checksum: 0x2E78ED7E
	Offset: 0x1420
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function pain_update(params)
{
	self endon("death");
	self endon("change_state");
	self stopMovementAndSetBrake();
	if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
	{
		self ASMSetAnimationRate(1);
	}
	if(self.newDamageLevel == 3)
	{
		asmState = "damage_2@pain";
	}
	else
	{
		asmState = "damage_1@pain";
	}
	self ASMRequestSubstate(asmState);
	self vehicle_ai::waittill_asm_complete(asmState, 1.5);
	self SetBrake(0);
	self vehicle_ai::evaluate_connections();
}

/*
	Name: state_unaware_update
	Namespace: siegebot
	Checksum: 0x5093B5DF
	Offset: 0x1530
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function state_unaware_update(params)
{
	self endon("death");
	self endon("change_state");
	self SetTurretTargetRelativeAngles(VectorScale((0, 1, 0), 90), 1);
	self SetTurretTargetRelativeAngles(VectorScale((0, 1, 0), 90), 2);
	self thread Movement_Thread_Unaware();
	while(1)
	{
		self vehicle_ai::evaluate_connections();
		wait(1);
	}
}

/*
	Name: Movement_Thread_Unaware
	Namespace: siegebot
	Checksum: 0x67100BC3
	Offset: 0x15E8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function Movement_Thread_Unaware()
{
	self endon("death");
	self endon("change_state");
	self notify("end_movement_thread");
	self endon("end_movement_thread");
	while(1)
	{
		self.current_pathto_pos = self GetNextMovePosition_unaware();
		foundpath = self SetVehGoalPos(self.current_pathto_pos, 0, 1);
		if(foundpath)
		{
			locomotion_start();
			self thread path_update_interrupt();
			self vehicle_ai::waittill_pathing_done();
			self notify("near_goal");
			self CancelAIMove();
			self ClearVehGoalPos();
			scan();
		}
		else
		{
			wait(1);
		}
		wait(0.05);
	}
}

/*
	Name: GetNextMovePosition_unaware
	Namespace: siegebot
	Checksum: 0x58DB2D59
	Offset: 0x1720
	Size: 0x47D
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_unaware()
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	minSearchRadius = 500;
	maxSearchRadius = 1500;
	halfHeight = 400;
	spacing = 80;
	queryResult = PositionQuery_Source_Navigation(self.origin, minSearchRadius, maxSearchRadius, halfHeight, spacing, self, spacing);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	FORWARD = AnglesToForward(self.angles);
	foreach(point in queryResult.data)
	{
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = RandomFloatRange(0, 30);
		#/
		point.score = point.score + RandomFloatRange(0, 30);
		pointDirection = VectorNormalize(point.origin - self.origin);
		factor = VectorDot(pointDirection, FORWARD);
		if(factor > 0.7)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = 600;
			#/
			point.score = point.score + 600;
			continue;
		}
		if(factor > 0)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = 0;
			#/
			point.score = point.score + 0;
			continue;
		}
		if(factor > -0.5)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -600;
			#/
			point.score = point.score + -600;
			continue;
		}
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = -1200;
		#/
		point.score = point.score + -1200;
	}
	vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	if(queryResult.data.size == 0)
	{
		return self.origin;
	}
	return queryResult.data[0].origin;
}

/*
	Name: clean_up_spawned
	Namespace: siegebot
	Checksum: 0x1868AEEE
	Offset: 0x1BA8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function clean_up_spawned()
{
	if(isdefined(self.jump) && isdefined(self.jump.linkEnt))
	{
		self.jump.linkEnt delete();
	}
}

/*
	Name: clean_up_spawnedOnDeath
	Namespace: siegebot
	Checksum: 0xA8BE59E0
	Offset: 0x1BF8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function clean_up_spawnedOnDeath(entToWatch)
{
	self endon("death");
	entToWatch waittill("death");
	self delete();
}

/*
	Name: initJumpStruct
	Namespace: siegebot
	Checksum: 0x682D8D45
	Offset: 0x1C40
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function initJumpStruct()
{
	if(isdefined(self.jump))
	{
		self Unlink();
		self.jump.linkEnt delete();
		self.jump delete();
	}
	self.jump = spawnstruct();
	self.jump.linkEnt = spawn("script_origin", self.origin);
	self.jump.linkEnt thread clean_up_spawnedOnDeath(self);
	self.jump.in_air = 0;
	self.jump.highgrounds = struct::get_array("balcony_point");
	self.jump.groundpoints = struct::get_array("ground_point");
}

/*
	Name: state_jump_can_enter
	Namespace: siegebot
	Checksum: 0xF5BC848E
	Offset: 0x1D78
	Size: 0x47
	Parameters: 3
	Flags: None
*/
function state_jump_can_enter(from_state, to_state, connection)
{
	if(isdefined(self.noJumping) && self.noJumping)
	{
		return 0;
	}
	return self.vehicleType === "spawner_enemy_boss_siegebot_zombietron";
}

/*
	Name: state_jump_enter
	Namespace: siegebot
	Checksum: 0xB1D23F0B
	Offset: 0x1DC8
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function state_jump_enter(params)
{
	goal = params.jumpgoal;
	trace = PhysicsTrace(goal + VectorScale((0, 0, 1), 500), goal - VectorScale((0, 0, 1), 10000), VectorScale((-1, -1, -1), 10), VectorScale((1, 1, 1), 10), self, 2);
	if(0)
	{
		/#
			debugstar(goal, 60000, (0, 1, 0));
		#/
		/#
			debugstar(trace["Dev Block strings are not supported"], 60000, (0, 1, 0));
		#/
		/#
			line(goal, trace["Dev Block strings are not supported"], (0, 1, 0), 1, 0, 60000);
		#/
	}
	if(trace["fraction"] < 1)
	{
		goal = trace["position"];
	}
	self.jump.goal = goal;
	params.scaleForward = 40;
	params.gravityForce = VectorScale((0, 0, -1), 6);
	params.upByHeight = 50;
	params.landingState = "land@jump";
	self pain_toggle(0);
	self stopMovementAndSetBrake();
}

/*
	Name: state_jump_update
	Namespace: siegebot
	Checksum: 0xACEA8215
	Offset: 0x1FB8
	Size: 0xBFB
	Parameters: 1
	Flags: None
*/
function state_jump_update(params)
{
	self endon("change_state");
	self endon("death");
	goal = self.jump.goal;
	self face_target(goal);
	self.jump.linkEnt.origin = self.origin;
	self.jump.linkEnt.angles = self.angles;
	wait(0.05);
	self LinkTo(self.jump.linkEnt);
	self.jump.in_air = 1;
	if(0)
	{
		/#
			debugstar(goal, 60000, (0, 1, 0));
		#/
		/#
			debugstar(goal + VectorScale((0, 0, 1), 100), 60000, (0, 1, 0));
		#/
		/#
			line(goal, goal + VectorScale((0, 0, 1), 100), (0, 1, 0), 1, 0, 60000);
		#/
	}
	totalDistance = Distance2D(goal, self.jump.linkEnt.origin);
	FORWARD = (goal - self.jump.linkEnt.origin / totalDistance[0], goal - self.jump.linkEnt.origin / totalDistance[1], 0);
	upByDistance = mapfloat(500, 2000, 46, 52, totalDistance);
	antiGravityByDistance = 0;
	initVelocityUp = (0, 0, 1) * upByDistance + params.upByHeight;
	initVelocityForward = FORWARD * params.scaleForward * mapfloat(500, 2000, 0.8, 1, totalDistance);
	velocity = initVelocityUp + initVelocityForward;
	if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
	{
		self ASMSetAnimationRate(1);
	}
	self ASMRequestSubstate("inair@jump");
	self waittill("engine_startup");
	self vehicle::impact_fx(self.settings.startupfx1);
	self waittill("leave_ground");
	self vehicle::impact_fx(self.settings.takeofffx1);
	while(1)
	{
		distanceToGoal = Distance2D(self.jump.linkEnt.origin, goal);
		antiGravityScaleUp = 1;
		antiGravityScale = 1;
		antiGravity = (0, 0, 0);
		if(0)
		{
			/#
				line(self.jump.linkEnt.origin, self.jump.linkEnt.origin + antiGravity, (0, 1, 0), 1, 0, 60000);
			#/
		}
		velocityForwardScale = mapfloat(self.radius * 1, self.radius * 4, 0.2, 1, distanceToGoal);
		velocityForward = initVelocityForward * velocityForwardScale;
		if(0)
		{
			/#
				line(self.jump.linkEnt.origin, self.jump.linkEnt.origin + velocityForward, (0, 1, 0), 1, 0, 60000);
			#/
		}
		oldVerticleSpeed = velocity[2];
		velocity = (0, 0, velocity[2]);
		velocity = velocity + velocityForward + params.gravityForce + antiGravity;
		if(oldVerticleSpeed > 0 && velocity[2] < 0)
		{
			self ASMRequestSubstate("fall@jump");
		}
		if(velocity[2] < 0 && self.jump.linkEnt.origin[2] + velocity[2] < goal[2])
		{
			break;
		}
		heightThreshold = goal[2] + 110;
		oldHeight = self.jump.linkEnt.origin[2];
		self.jump.linkEnt.origin = self.jump.linkEnt.origin + velocity;
		if(self.jump.linkEnt.origin[2] < heightThreshold && (oldHeight > heightThreshold || (oldVerticleSpeed > 0 && velocity[2] < 0)))
		{
			self notify("start_landing");
			self ASMRequestSubstate(params.landingState);
		}
		if(0)
		{
			/#
				debugstar(self.jump.linkEnt.origin, 60000, (1, 0, 0));
			#/
		}
		wait(0.05);
	}
	self.jump.linkEnt.origin = (self.jump.linkEnt.origin[0], self.jump.linkEnt.origin[1], 0) + (0, 0, goal[2]);
	self notify("land_crush");
	foreach(player in level.players)
	{
		player._takedamage_old = player.takedamage;
		player.takedamage = 0;
	}
	self RadiusDamage(self.origin + VectorScale((0, 0, 1), 15), self.radiusdamageradius, self.radiusdamagemax, self.radiusdamagemin, self, "MOD_EXPLOSIVE");
	foreach(player in level.players)
	{
		player.takedamage = player._takedamage_old;
		player._takedamage_old = undefined;
		if(Distance2DSquared(self.origin, player.origin) < 200 * 200)
		{
			direction = (player.origin - self.origin[0], player.origin - self.origin[1], 0);
			if(Abs(direction[0]) < 0.01 && Abs(direction[1]) < 0.01)
			{
				direction = (RandomFloatRange(1, 2), RandomFloatRange(1, 2), 0);
			}
			direction = VectorNormalize(direction);
			strength = 700;
			player SetVelocity(player GetVelocity() + direction * strength);
			if(player.health > 80)
			{
				player DoDamage(player.health - 70, self.origin, self);
			}
		}
	}
	self vehicle::impact_fx(self.settings.landingfx1);
	self stopMovementAndSetBrake();
	wait(0.3);
	self Unlink();
	wait(0.05);
	self.jump.in_air = 0;
	self notify("jump_finished");
	vehicle_ai::Cooldown("jump", 7);
	self vehicle_ai::waittill_asm_complete(params.landingState, 3);
	self vehicle_ai::evaluate_connections();
}

/*
	Name: state_jump_exit
	Namespace: siegebot
	Checksum: 0x8CF8834
	Offset: 0x2BC0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function state_jump_exit(params)
{
}

/*
	Name: state_combat_update
	Namespace: siegebot
	Checksum: 0xA13A50B5
	Offset: 0x2BD8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("death");
	self endon("change_state");
	self thread Movement_Thread();
	self thread Attack_Thread_machinegun();
	self thread Attack_Thread_rocket();
}

/*
	Name: state_combat_exit
	Namespace: siegebot
	Checksum: 0x203A2C7B
	Offset: 0x2C48
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function state_combat_exit(params)
{
	self ClearTurretTarget();
	self SetTurretSpinning(0);
}

/*
	Name: locomotion_start
	Namespace: siegebot
	Checksum: 0xCB502C73
	Offset: 0x2C90
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function locomotion_start()
{
	if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
	{
		self ASMSetAnimationRate(0.5);
	}
	self ASMRequestSubstate("locomotion@movement");
}

/*
	Name: GetNextMovePosition_tactical
	Namespace: siegebot
	Checksum: 0xEE2D92D1
	Offset: 0x2CF0
	Size: 0x475
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_tactical()
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	maxSearchRadius = 800;
	halfHeight = 400;
	innerSpacing = 50;
	outerSpacing = 60;
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	if(isdefined(self.enemy))
	{
		PositionQuery_Filter_Sight(queryResult, self.enemy.origin, self GetEye() - self.origin, self, 0, self.enemy);
		self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, self.enemy, self.settings.engagementDistMin, self.settings.engagementDistMax);
	}
	foreach(point in queryResult.data)
	{
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = RandomFloatRange(0, 30);
		#/
		point.score = point.score + RandomFloatRange(0, 30);
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
		if(isdefined(self.enemy))
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = point.distAwayFromEngagementArea * -1;
			#/
			point.score = point.score + point.distAwayFromEngagementArea * -1;
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
		}
	}
	vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	if(queryResult.data.size == 0)
	{
		return self.origin;
	}
	return queryResult.data[0].origin;
}

/*
	Name: path_update_interrupt
	Namespace: siegebot
	Checksum: 0xC9255D43
	Offset: 0x3170
	Size: 0x483
	Parameters: 0
	Flags: None
*/
function path_update_interrupt()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	canSeeEnemyCount = 0;
	old_enemy = self.enemy;
	StartPath = GetTime();
	old_origin = self.origin;
	move_dist = 300;
	wait(1.5);
	while(1)
	{
		self SetMaxSpeedScale(1);
		self SetMaxAccelerationScale(1);
		self SetSpeed(self.settings.defaultMoveSpeed);
		if(isdefined(self.enemy))
		{
			selfDistToTarget = Distance2D(self.origin, self.enemy.origin);
			farEngagementDist = self.settings.engagementDistMax + 150;
			closeEngagementDist = self.settings.engagementDistMin - 150;
			if(self VehCanSee(self.enemy))
			{
				self SetLookAtEnt(self.enemy);
				self SetTurretTargetEnt(self.enemy);
				if(selfDistToTarget < farEngagementDist && selfDistToTarget > closeEngagementDist)
				{
					canSeeEnemyCount++;
					if(canSeeEnemyCount > 3 && (vehicle_ai::TimeSince(StartPath) > 5 || Distance2DSquared(old_origin, self.origin) > move_dist * move_dist))
					{
						self notify("near_goal");
					}
				}
				else
				{
					self SetMaxSpeedScale(2.5);
					self SetMaxAccelerationScale(3);
					self SetSpeed(self.settings.defaultMoveSpeed * 2);
				}
			}
			else if(!self vehseenrecently(self.enemy, 1.5) && self vehseenrecently(self.enemy, 15) || selfDistToTarget > farEngagementDist)
			{
				self SetMaxSpeedScale(1.8);
				self SetMaxAccelerationScale(2);
				self SetSpeed(self.settings.defaultMoveSpeed * 1.5);
			}
		}
		else
		{
			canSeeEnemyCount = 0;
		}
		if(isdefined(self.enemy))
		{
			if(!isdefined(old_enemy))
			{
				self notify("near_goal");
			}
			else if(self.enemy != old_enemy)
			{
				self notify("near_goal");
			}
			if(self VehCanSee(self.enemy) && Distance2DSquared(self.origin, self.enemy.origin) < 150 * 150 && Distance2DSquared(old_origin, self.enemy.origin) > 151 * 151)
			{
				self notify("near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: weapon_doors_state
	Namespace: siegebot
	Checksum: 0xF578375E
	Offset: 0x3600
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function weapon_doors_state(isOpen, waitTime)
{
	if(!isdefined(waitTime))
	{
		waitTime = 0;
	}
	self endon("death");
	self notify("weapon_doors_state");
	self endon("weapon_doors_state");
	if(isdefined(waitTime) && waitTime > 0)
	{
		wait(waitTime);
	}
	self vehicle::toggle_ambient_anim_group(1, isOpen);
}

/*
	Name: Movement_Thread
	Namespace: siegebot
	Checksum: 0x30D20917
	Offset: 0x3690
	Size: 0x2D7
	Parameters: 0
	Flags: None
*/
function Movement_Thread()
{
	self endon("death");
	self endon("change_state");
	self notify("end_movement_thread");
	self endon("end_movement_thread");
	while(1)
	{
		self.current_pathto_pos = self GetNextMovePosition_tactical();
		if(self.vehicleType === "spawner_enemy_boss_siegebot_zombietron")
		{
			if(vehicle_ai::IsCooldownReady("jump"))
			{
				params = spawnstruct();
				params.jumpgoal = self.current_pathto_pos;
				locomotion_start();
				wait(0.5);
				self vehicle_ai::evaluate_connections(undefined, params);
				wait(0.5);
			}
		}
		foundpath = self SetVehGoalPos(self.current_pathto_pos, 0, 1);
		if(foundpath)
		{
			if(isdefined(self.enemy) && self vehseenrecently(self.enemy, 1))
			{
				self SetLookAtEnt(self.enemy);
				self SetTurretTargetEnt(self.enemy);
			}
			locomotion_start();
			self thread path_update_interrupt();
			self vehicle_ai::waittill_pathing_done();
			self notify("near_goal");
			self CancelAIMove();
			self ClearVehGoalPos();
			if(isdefined(self.enemy) && self vehseenrecently(self.enemy, 2))
			{
				self face_target(self.enemy.origin);
			}
		}
		wait(1);
		startAdditionalWaiting = GetTime();
		while(isdefined(self.enemy) && self VehCanSee(self.enemy) && vehicle_ai::TimeSince(startAdditionalWaiting) < 1.5)
		{
			wait(0.4);
		}
	}
}

/*
	Name: stopMovementAndSetBrake
	Namespace: siegebot
	Checksum: 0x44F81CAC
	Offset: 0x3970
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function stopMovementAndSetBrake()
{
	self notify("end_movement_thread");
	self notify("near_goal");
	self CancelAIMove();
	self ClearVehGoalPos();
	self ClearTurretTarget();
	self ClearLookAtEnt();
	self SetBrake(1);
}

/*
	Name: face_target
	Namespace: siegebot
	Checksum: 0x1AE049A9
	Offset: 0x3A10
	Size: 0x20B
	Parameters: 2
	Flags: None
*/
function face_target(position, targetAngleDiff)
{
	if(!isdefined(targetAngleDiff))
	{
		targetAngleDiff = 30;
	}
	v_to_enemy = (position - self.origin[0], position - self.origin[1], 0);
	v_to_enemy = VectorNormalize(v_to_enemy);
	goalAngles = VectorToAngles(v_to_enemy);
	angleDiff = AbsAngleClamp180(self.angles[1] - goalAngles[1]);
	if(angleDiff <= targetAngleDiff)
	{
		return;
	}
	self SetLookAtOrigin(position);
	self SetTurretTargetVec(position);
	self locomotion_start();
	angleAdjustingStart = GetTime();
	while(angleDiff > targetAngleDiff && vehicle_ai::TimeSince(angleAdjustingStart) < 4)
	{
		angleDiff = AbsAngleClamp180(self.angles[1] - goalAngles[1]);
		wait(0.05);
	}
	self ClearVehGoalPos();
	self ClearLookAtEnt();
	self ClearTurretTarget();
	self CancelAIMove();
}

/*
	Name: scan
	Namespace: siegebot
	Checksum: 0xE863CBD8
	Offset: 0x3C28
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function scan()
{
	angles = self GetTagAngles("tag_barrel");
	angles = (0, angles[1], 0);
	rotate = 360;
	while(rotate > 0)
	{
		angles = angles + VectorScale((0, 1, 0), 30);
		rotate = rotate - 30;
		FORWARD = AnglesToForward(angles);
		aimpos = self.origin + FORWARD * 1000;
		self SetTurretTargetVec(aimpos);
		msg = self util::waittill_any_timeout(0.5, "turret_on_target");
		wait(0.1);
		if(isdefined(self.enemy) && self VehCanSee(self.enemy))
		{
			self SetTurretTargetEnt(self.enemy);
			self SetLookAtEnt(self.enemy);
			self face_target(self.enemy);
			return;
		}
	}
	FORWARD = AnglesToForward(self.angles);
	aimpos = self.origin + FORWARD * 1000;
	self SetTurretTargetVec(aimpos);
	msg = self util::waittill_any_timeout(3, "turret_on_target");
	self ClearTurretTarget();
}

/*
	Name: Attack_Thread_machinegun
	Namespace: siegebot
	Checksum: 0xF813AA42
	Offset: 0x3E80
	Size: 0x26F
	Parameters: 0
	Flags: None
*/
function Attack_Thread_machinegun()
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	self notify("end_machinegun_attack_thread");
	self endon("end_machinegun_attack_thread");
	self.turretRotScale = 1 * self.difficulty_scale_up;
	spinning = 0;
	while(1)
	{
		if(isdefined(self.enemy) && self VehCanSee(self.enemy))
		{
			self SetLookAtEnt(self.enemy);
			self SetTurretTargetEnt(self.enemy);
			if(!spinning)
			{
				spinning = 1;
				self SetTurretSpinning(1);
				wait(0.5);
				continue;
			}
			self setGunnerTargetEnt(self.enemy, (0, 0, 0), 0);
			self setGunnerTargetEnt(self.enemy, (0, 0, 0), 1);
			self vehicle_ai::fire_for_time(RandomFloatRange(0.75, 1.5) * self.difficulty_scale_up, 1);
			if(isdefined(self.enemy) && isai(self.enemy))
			{
				wait(RandomFloatRange(0.1, 0.2));
			}
			else
			{
				wait(RandomFloatRange(0.2, 0.3) * self.difficulty_scale_down);
			}
		}
		else
		{
			spinning = 0;
			self SetTurretSpinning(0);
			self cleargunnertarget(0);
			self cleargunnertarget(1);
			wait(0.4);
		}
	}
}

/*
	Name: Attack_Rocket
	Namespace: siegebot
	Checksum: 0x9AC79408
	Offset: 0x40F8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function Attack_Rocket(target)
{
	if(isdefined(target))
	{
		self SetTurretTargetEnt(target);
		self setGunnerTargetEnt(target, VectorScale((0, 0, -1), 10), 2);
		msg = self util::waittill_any_timeout(1, "turret_on_target");
		self FireWeapon(2, target, VectorScale((0, 0, -1), 10));
		self cleargunnertarget(1);
	}
}

/*
	Name: Attack_Thread_rocket
	Namespace: siegebot
	Checksum: 0xA6F411CE
	Offset: 0x41C8
	Size: 0x22F
	Parameters: 0
	Flags: None
*/
function Attack_Thread_rocket()
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	self notify("end_rocket_attack_thread");
	self endon("end_rocket_attack_thread");
	vehicle_ai::Cooldown("rocket", 3);
	while(1)
	{
		if(isdefined(self.enemy) && self vehseenrecently(self.enemy, 3) && vehicle_ai::IsCooldownReady("rocket", 1.5))
		{
			self setGunnerTargetEnt(self.enemy, (0, 0, 0), 0);
			self setGunnerTargetEnt(self.enemy, VectorScale((0, 0, -1), 10), 2);
			self thread weapon_doors_state(1);
			wait(1.5);
			if(isdefined(self.enemy) && self vehseenrecently(self.enemy, 1))
			{
				vehicle_ai::Cooldown("rocket", 5);
				Attack_Rocket(self.enemy);
				wait(1);
				if(isdefined(self.enemy))
				{
					Attack_Rocket(self.enemy);
				}
				self thread weapon_doors_state(0, 1);
			}
			else
			{
				self thread weapon_doors_state(0);
			}
		}
		else
		{
			self cleargunnertarget(0);
			self cleargunnertarget(1);
			wait(0.4);
		}
	}
}

/*
	Name: siegebot_callback_damage
	Namespace: siegebot
	Checksum: 0x5F9F6681
	Offset: 0x4400
	Size: 0x287
	Parameters: 15
	Flags: None
*/
function siegebot_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	num_players = GetPlayers().size;
	maxDamage = self.healthdefault * 0.4 - 0.02 * num_players;
	if(sMeansOfDeath !== "MOD_UNKNOWN" && iDamage > maxDamage)
	{
		iDamage = maxDamage;
	}
	if(vehicle_ai::should_emp(self, weapon, sMeansOfDeath, eInflictor, eAttacker))
	{
		minEmpDownTime = 0.8 * self.settings.empdowntime;
		maxEmpDownTime = 1.2 * self.settings.empdowntime;
		self notify("emped", RandomFloatRange(minEmpDownTime, maxEmpDownTime), eAttacker, eInflictor);
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
		driver = self GetSeatOccupant(0);
		if(!isdefined(driver))
		{
			self notify("pain");
		}
		vehicle::set_damage_fx_level(self.damageLevel);
	}
	return iDamage;
}

