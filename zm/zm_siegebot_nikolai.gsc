#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_siegebot;
#using scripts\shared\weapons\_spike_charge_siegebot;
#using scripts\zm\_util;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_util;

#namespace namespace_48757881;

/*
	Name: __init__sytem__
	Namespace: namespace_48757881
	Checksum: 0xFE793309
	Offset: 0x9E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_siegebot_nikolai", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_48757881
	Checksum: 0x5659DF15
	Offset: 0xA28
	Size: 0x3EB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("siegebot_nikolai", &siegebot_initialize);
	clientfield::register("vehicle", "nikolai_destroyed_r_arm", 12000, 1, "int");
	clientfield::register("vehicle", "nikolai_destroyed_l_arm", 12000, 1, "int");
	clientfield::register("vehicle", "nikolai_destroyed_r_chest", 12000, 1, "int");
	clientfield::register("vehicle", "nikolai_destroyed_l_chest", 12000, 1, "int");
	clientfield::register("vehicle", "nikolai_weakpoint_l_fx", 12000, 1, "int");
	clientfield::register("vehicle", "nikolai_weakpoint_r_fx", 12000, 1, "int");
	clientfield::register("vehicle", "nikolai_gatling_tell", 12000, 1, "int");
	clientfield::register("missile", "harpoon_impact", 12000, 1, "int");
	clientfield::register("vehicle", "play_raps_trail_fx", 12000, 1, "int");
	clientfield::register("vehicle", "raps_landing", 12000, 1, "int");
	level thread AAT::register_immunity("zm_aat_blast_furnace", "siegebot", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "siegebot", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "siegebot", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "siegebot", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "siegebot", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_blast_furnace", "raps", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "raps", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "raps", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "raps", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "raps", 1, 1, 1);
}

/*
	Name: siegebot_initialize
	Namespace: namespace_48757881
	Checksum: 0xFC5FE919
	Offset: 0xE20
	Size: 0x3F3
	Parameters: 0
	Flags: None
*/
function siegebot_initialize()
{
	self flag::init("halt_thread_gun");
	level.raps_spawners = GetEntArray("zombie_raps_spawner", "targetname");
	self useanimtree(-1);
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self.health = self.healthdefault;
	self.var_65850094 = [];
	self.var_65850094[1] = 7500;
	self.var_65850094[2] = 7500;
	self.var_65850094[3] = 8000;
	self.var_65850094[4] = 8000;
	self.var_65850094[5] = 11000;
	foreach(player in level.activePlayers)
	{
		player.var_b3a9099 = 0;
	}
	self.b_override_explosive_damage_cap = 1;
	self.var_a0e2dfff = 1;
	self vehicle::friendly_fire_shield();
	self SetNearGoalNotifyDist(self.radius * 1.2);
	Target_Set(self, VectorScale((0, 0, 1), 150));
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.maxsightdistsqrd = 10000 * 10000;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 9999999;
	self.goalHeight = 5000;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.overrideVehicleDamage = &function_b9b039e0;
	self pain_toggle(1);
	self initJumpStruct();
	self SetGunnerTurretOnTargetRange(0, self.settings.gunner_turret_on_target_range);
	self locomotion_start();
	self.damageLevel = 0;
	self.newDamageLevel = self.damageLevel;
	if(!isdefined(self.height))
	{
		self.height = self.radius;
	}
	self.bgbIgnoreFearInHeadlights = 1;
	self.noCybercom = 1;
	self.ignoreFireFly = 1;
	self.ignoreDecoy = 1;
	self.ignoreme = 1;
	self vehicle_ai::InitThreatBias();
	defaultRole();
}

/*
	Name: init_clientfields
	Namespace: namespace_48757881
	Checksum: 0xF4BF2298
	Offset: 0x1220
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	self vehicle::lights_on();
	self vehicle::toggle_lights_group(1, 1);
	self vehicle::toggle_lights_group(2, 1);
	self vehicle::toggle_lights_group(3, 1);
}

/*
	Name: defaultRole
	Namespace: namespace_48757881
	Checksum: 0x3EE2A51B
	Offset: 0x12A8
	Size: 0x1DB
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role();
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_groundCombat_update;
	self vehicle_ai::get_state_callbacks("combat").exit_func = &state_groundCombat_exit;
	self vehicle_ai::get_state_callbacks("pain").enter_func = &pain_enter;
	self vehicle_ai::get_state_callbacks("pain").update_func = &pain_update;
	self vehicle_ai::get_state_callbacks("pain").exit_func = &pain_exit;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::add_state("special_attack", undefined, undefined, undefined);
	self vehicle_ai::add_state("jump", &state_jump_enter, &state_jump_update, &state_jump_exit);
	vehicle_ai::add_utility_connection("jump", "combat");
	vehicle_ai::StartInitialState("combat");
}

/*
	Name: function_f7035c2f
	Namespace: namespace_48757881
	Checksum: 0x92195D1C
	Offset: 0x1490
	Size: 0x131
	Parameters: 1
	Flags: None
*/
function function_f7035c2f(var_b58fd987)
{
	self endon("death");
	var_b58fd987 endon("death");
	self.var_b58fd987 = var_b58fd987;
	self EnableLinkTo();
	var_b58fd987.origin = self GetTagOrigin("tag_driver");
	var_b58fd987.angles = self GetTagAngles("tag_driver");
	var_b58fd987.targetname = "nikolai_driver";
	var_b58fd987 LinkTo(self, "tag_driver");
	while(1)
	{
		var_b58fd987 scene::Play("cin_zm_stalingrad_nikolai_cockpit_drink");
		var_b58fd987 thread scene::Play("cin_zm_stalingrad_nikolai_cockpit_idle");
		wait(10 + RandomFloat(10));
	}
}

/*
	Name: state_death_update
	Namespace: namespace_48757881
	Checksum: 0x118B434D
	Offset: 0x15D0
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	self endon("nodeath_thread");
	StreamerModelHint(self.deathmodel, 6);
	self SetTurretSpinning(0);
	self clean_up_spawned();
	self stopMovementAndSetBrake();
	self vehicle::set_damage_fx_level(0);
	self.turretRotScale = 3;
	self SetTurretTargetRelativeAngles((0, 0, 0), 0);
	self SetTurretTargetRelativeAngles((0, 0, 0), 1);
	self SetTurretTargetRelativeAngles((0, 0, 0), 2);
	level flag::set("nikolai_complete");
	self ASMRequestSubstate("death@stationary");
	self.var_b58fd987 thread scene::Play("cin_zm_stalingrad_nikolai_cockpit_death");
	self waittill("model_swap");
	self vehicle_death::death_fx();
	wait(10);
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self playsound("veh_quadtank_sparks");
	self vehicle_death::FreeWhenSafe(150);
}

/*
	Name: clean_up_spawned
	Namespace: namespace_48757881
	Checksum: 0x8DC6C62F
	Offset: 0x17C0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function clean_up_spawned()
{
	if(isdefined(self.jump))
	{
		self.jump.linkEnt delete();
	}
}

/*
	Name: pain_toggle
	Namespace: namespace_48757881
	Checksum: 0xBF97604D
	Offset: 0x1800
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function pain_toggle(enabled)
{
	self._enablePain = enabled;
}

/*
	Name: pain_canenter
	Namespace: namespace_48757881
	Checksum: 0x28255848
	Offset: 0x1820
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function pain_canenter()
{
	State = vehicle_ai::get_current_state();
	return isdefined(State) && State != "pain" && self._enablePain;
}

/*
	Name: pain_enter
	Namespace: namespace_48757881
	Checksum: 0xC8255081
	Offset: 0x1870
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function pain_enter(params)
{
	self stopMovementAndSetBrake();
}

/*
	Name: pain_exit
	Namespace: namespace_48757881
	Checksum: 0x91CBF7DF
	Offset: 0x18A0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function pain_exit(params)
{
	self SetBrake(0);
}

/*
	Name: pain_update
	Namespace: namespace_48757881
	Checksum: 0x92AD65FC
	Offset: 0x18D0
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function pain_update(params)
{
	self endon("death");
	if(1 <= self.damageLevel && self.damageLevel <= 4)
	{
		asmState = "damage_" + self.damageLevel + "@pain";
	}
	else
	{
		asmState = "normal@pain";
	}
	self ASMRequestSubstate(asmState);
	self vehicle_ai::waittill_asm_complete(asmState, 5);
	previous_state = vehicle_ai::get_previous_state();
	self vehicle_ai::set_state(previous_state);
	self vehicle_ai::evaluate_connections();
}

/*
	Name: jump_to
	Namespace: namespace_48757881
	Checksum: 0x5512E890
	Offset: 0x19D8
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function jump_to(target)
{
	if(self vehicle_ai::get_current_state() === "jump")
	{
		return 0;
	}
	if(!vehicle_ai::IsCooldownReady("jump_cooldown"))
	{
		return 0;
	}
	if(IsVec(target))
	{
		self.jump.var_e8ce546f = target;
	}
	else if(isdefined(target.origin) && IsVec(target.origin))
	{
		self.jump.var_e8ce546f = target.origin;
	}
	distSqr = Distance2DSquared(self.origin, self.jump.var_e8ce546f);
	if(isdefined(self.jump.var_e8ce546f) && 600 * 600 < distSqr && distSqr < 1800 * 1800)
	{
		self vehicle_ai::set_state("jump");
		return 1;
	}
	return 0;
}

/*
	Name: initJumpStruct
	Namespace: namespace_48757881
	Checksum: 0xFBB79D4A
	Offset: 0x1B58
	Size: 0x103
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
	self.jump.in_air = 0;
	self.arena_center = struct::get("boss_arena_center").origin;
	/#
		Assert(isdefined(self.arena_center));
	#/
}

/*
	Name: state_jump_enter
	Namespace: namespace_48757881
	Checksum: 0xE62CD6B0
	Offset: 0x1C68
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function state_jump_enter(params)
{
	goal = self.jump.var_e8ce546f;
	trace = PhysicsTrace(goal + VectorScale((0, 0, 1), 500), goal - VectorScale((0, 0, 1), 10000), VectorScale((-1, -1, -1), 10), VectorScale((1, 1, 1), 10), self, 2);
	if(trace["fraction"] < 1)
	{
		goal = trace["position"];
	}
	self.jump.lowground_history = goal;
	self.jump.goal = goal;
	params.scaleForward = 70;
	params.gravityForce = VectorScale((0, 0, -1), 5);
	params.upByHeight = -5;
	self pain_toggle(0);
	self stopMovementAndSetBrake();
}

/*
	Name: state_jump_exit
	Namespace: namespace_48757881
	Checksum: 0xD560C746
	Offset: 0x1DC0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function state_jump_exit(params)
{
	self pain_toggle(1);
}

/*
	Name: state_jump_update
	Namespace: namespace_48757881
	Checksum: 0x890A2369
	Offset: 0x1DF0
	Size: 0xB5B
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
	totalDistance = Distance2D(goal, self.jump.linkEnt.origin);
	FORWARD = (goal - self.jump.linkEnt.origin / totalDistance[0], goal - self.jump.linkEnt.origin / totalDistance[1], 0);
	upByDistance = mapfloat(500, 2000, 46, 52, totalDistance);
	antiGravityByDistance = mapfloat(500, 2000, 0, 0.5, totalDistance);
	initVelocityUp = (0, 0, 1) * upByDistance + params.upByHeight;
	initVelocityForward = FORWARD * params.scaleForward * mapfloat(500, 2000, 0.8, 1, totalDistance);
	velocity = initVelocityUp + initVelocityForward;
	self ASMRequestSubstate("inair@jump");
	self.jump.var_865af05c = "engine_startup";
	self util::waittill_notify_or_timeout("start_engine", 0.5);
	self vehicle::impact_fx(self.settings.startupfx1);
	self.jump.var_865af05c = "leave_ground";
	self util::waittill_notify_or_timeout("start_engine", 1);
	self vehicle::impact_fx(self.settings.takeofffx1);
	params.landingState = "land@jump";
	jumpStart = GetTime();
	while(1)
	{
		distanceToGoal = Distance2D(self.jump.linkEnt.origin, goal);
		antiGravityScaleUp = mapfloat(0, 0.5, 0.6, 0, Abs(0.5 - distanceToGoal / totalDistance));
		antiGravityScale = mapfloat(self.radius * 1, self.radius * 3, 0, 1, distanceToGoal);
		antiGravity = antiGravityScale * antiGravityScaleUp * params.gravityForce * -1 + (0, 0, antiGravityByDistance);
		velocityForwardScale = mapfloat(self.radius * 1, self.radius * 4, 0.2, 1, distanceToGoal);
		velocityForward = initVelocityForward * velocityForwardScale;
		oldVerticleSpeed = velocity[2];
		velocity = (0, 0, velocity[2]);
		velocity = velocity + velocityForward + params.gravityForce + antiGravity;
		if(oldVerticleSpeed > 0 && velocity[2] <= 0)
		{
			self ASMRequestSubstate("fall@jump");
		}
		if(velocity[2] <= 0 && self.jump.linkEnt.origin[2] + velocity[2] <= goal[2] || vehicle_ai::TimeSince(jumpStart) > 10)
		{
			break;
		}
		heightThreshold = goal[2] + 110;
		oldHeight = self.jump.linkEnt.origin[2];
		self.jump.linkEnt.origin = self.jump.linkEnt.origin + velocity;
		if(self.jump.linkEnt.origin[2] < heightThreshold && (oldHeight > heightThreshold || (oldVerticleSpeed > 0 && velocity[2] < 0)))
		{
			self notify("start_landing");
			if(isdefined(self.enemy))
			{
				FORWARD = AnglesToForward(self.angles);
				dir = VectorNormalize(self.enemy.origin - self.origin);
				dot = VectorDot(dir, FORWARD);
				if(dot < -0.7)
				{
					params.landingState = "land_turn@jump";
				}
			}
			self ASMRequestSubstate(params.landingState);
		}
		wait(0.05);
	}
	self.jump.linkEnt.origin = (self.jump.linkEnt.origin[0], self.jump.linkEnt.origin[1], 0) + (0, 0, goal[2]);
	self notify("land_crush");
	foreach(player in level.players)
	{
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
			player DoDamage(50, self.origin, self);
		}
	}
	self vehicle::impact_fx(self.settings.landingfx1);
	self stopMovementAndSetBrake();
	PlayRumbleOnPosition("nikolai_siegebot_land", self.origin);
	wait(0.3);
	self Unlink();
	wait(0.05);
	self.jump.in_air = 0;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self vehicle_ai::waittill_asm_complete(params.landingState, 3);
	self vehicle_ai::Cooldown("jump_cooldown", 3);
	self notify("jump_finished");
	self locomotion_start();
	self vehicle_ai::evaluate_connections();
}

/*
	Name: function_f9508f9e
	Namespace: namespace_48757881
	Checksum: 0xF64C9088
	Offset: 0x2958
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_f9508f9e()
{
	self vehicle_ai::ClearAllLookingAndTargeting();
	self SetTurretTargetRelativeAngles((0, 0, 0), 0);
	self SetTurretTargetRelativeAngles((0, 0, 0), 1);
	self SetTurretTargetRelativeAngles((0, 0, 0), 2);
	self SetTurretTargetRelativeAngles((0, 0, 0), 3);
	self SetTurretTargetRelativeAngles((0, 0, 0), 4);
}

/*
	Name: side_step
	Namespace: namespace_48757881
	Checksum: 0x9400D642
	Offset: 0x2A18
	Size: 0x273
	Parameters: 0
	Flags: None
*/
function side_step()
{
	step_size = 180;
	right_dir = AnglesToRight(self.angles);
	start = self.origin + VectorScale((0, 0, 1), 10);
	traceDir = right_dir;
	jukeState = "juke_r@movement";
	oppositeJukeState = "juke_l@movement";
	if(math::cointoss())
	{
		traceDir = traceDir * -1;
		jukeState = "juke_l@movement";
		oppositeJukeState = "juke_r@movement";
	}
	trace = PhysicsTrace(start, start + traceDir * step_size, 0.8 * (self.radius * -1, self.radius * -1, 0), 0.8 * (self.radius, self.radius, self.height), self, 2);
	if(trace["fraction"] < 1)
	{
		traceDir = traceDir * -1;
		trace = PhysicsTrace(start, start + traceDir * step_size, 0.8 * (self.radius * -1, self.radius * -1, 0), 0.8 * (self.radius, self.radius, self.height), self, 2);
		jukeState = oppositeJukeState;
	}
	if(trace["fraction"] >= 1)
	{
		self ASMRequestSubstate(jukeState);
		self vehicle_ai::waittill_asm_complete(jukeState, 3);
		self locomotion_start();
		return 1;
	}
	return 0;
}

/*
	Name: state_groundCombat_update
	Namespace: namespace_48757881
	Checksum: 0x96A3FA7C
	Offset: 0x2C98
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function state_groundCombat_update(params)
{
	self endon("death");
	self endon("change_state");
	self thread Attack_Thread_Gun();
	self thread Movement_Thread();
	self thread footstep_left_monitor();
	self thread footstep_right_monitor();
	while(1)
	{
		self vehicle_ai::evaluate_connections();
		wait(1);
	}
}

/*
	Name: footstep_damage
	Namespace: namespace_48757881
	Checksum: 0x57A3F432
	Offset: 0x2D48
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function footstep_damage(tag_name)
{
	origin = self GetTagOrigin(tag_name);
	self function_75775e52(origin, 80);
}

/*
	Name: footstep_left_monitor
	Namespace: namespace_48757881
	Checksum: 0xF85F7F4E
	Offset: 0x2DA0
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function footstep_left_monitor()
{
	self endon("death");
	self endon("change_state");
	self notify("stop_left_footstep_damage");
	self endon("stop_left_footstep_damage");
	while(1)
	{
		self waittill("footstep_left_large_theia");
		footstep_damage("tag_leg_left_foot_animate");
	}
}

/*
	Name: footstep_right_monitor
	Namespace: namespace_48757881
	Checksum: 0x8D74778B
	Offset: 0x2E10
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function footstep_right_monitor()
{
	self endon("death");
	self endon("change_state");
	self notify("stop_right_footstep_damage");
	self endon("stop_right_footstep_damage");
	while(1)
	{
		self waittill("footstep_right_large_theia");
		footstep_damage("tag_leg_right_foot_animate");
	}
}

/*
	Name: Movement_Thread
	Namespace: namespace_48757881
	Checksum: 0x6FB04AAC
	Offset: 0x2E80
	Size: 0x1EF
	Parameters: 0
	Flags: None
*/
function Movement_Thread()
{
	self endon("death");
	self endon("change_state");
	self notify("end_movement_thread");
	self endon("end_movement_thread");
	self.current_pathto_pos = self.origin;
	while(1)
	{
		self SetSpeed(self.settings.defaultMoveSpeed);
		e_enemy = self.enemy;
		if(isdefined(self.goalpos) && DistanceSquared(self.current_pathto_pos, self.goalpos) > self.radius * 0.8 * self.radius * 0.8)
		{
			self.current_pathto_pos = self.goalpos;
			self SetVehGoalPos(self.current_pathto_pos, 0, 1);
			foundpath = self vehicle_ai::waittill_pathresult();
			if(foundpath)
			{
				if(isdefined(e_enemy))
				{
					self SetLookAtEnt(e_enemy);
				}
				self SetBrake(0);
				locomotion_start();
				self vehicle_ai::waittill_pathing_done();
				self CancelAIMove();
				self ClearVehGoalPos();
				self SetBrake(1);
			}
		}
		wait(0.05);
	}
}

/*
	Name: state_groundCombat_exit
	Namespace: namespace_48757881
	Checksum: 0x2DFE1B7C
	Offset: 0x3078
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function state_groundCombat_exit(params)
{
	self notify("end_attack_thread");
	self notify("end_movement_thread");
	self ClearTurretTarget();
}

/*
	Name: Attack_Thread_Gun
	Namespace: namespace_48757881
	Checksum: 0x56A75AB2
	Offset: 0x30C0
	Size: 0x25F
	Parameters: 0
	Flags: None
*/
function Attack_Thread_Gun()
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	self notify("end_attack_thread_gun");
	self endon("end_attack_thread_gun");
	while(1)
	{
		e_enemy = self.enemy;
		if(!isdefined(e_enemy) || self.var_a7cd606 === 1)
		{
			self SetTurretTargetRelativeAngles((0, 0, 0));
			wait(0.4);
			continue;
		}
		self vehicle_ai::SetTurretTarget(e_enemy, 0);
		self vehicle_ai::SetTurretTarget(e_enemy, 1);
		var_eb3cc6f2 = GetTime();
		while(isdefined(e_enemy) && !self.gunner1ontarget && vehicle_ai::TimeSince(var_eb3cc6f2) < 2)
		{
			wait(0.4);
		}
		if(!isdefined(e_enemy))
		{
			continue;
		}
		var_9e93cc65 = GetTime();
		while(isdefined(e_enemy) && e_enemy === self.enemy && self vehseenrecently(e_enemy, 1) && vehicle_ai::TimeSince(var_9e93cc65) < 5)
		{
			if(self flag::get("halt_thread_gun"))
			{
				break;
			}
			self vehicle_ai::fire_for_time(1 + RandomFloat(0.4), 1);
			if(isdefined(e_enemy) && isPlayer(e_enemy))
			{
				wait(0.6 + RandomFloat(0.2));
			}
			wait(0.1);
		}
		wait(0.1);
	}
}

/*
	Name: locomotion_start
	Namespace: namespace_48757881
	Checksum: 0x252A44AF
	Offset: 0x3328
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function locomotion_start()
{
	locomotion = "locomotion@movement";
	self ASMRequestSubstate(locomotion);
}

/*
	Name: function_7fcc2a80
	Namespace: namespace_48757881
	Checksum: 0xD853847D
	Offset: 0x3368
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function function_7fcc2a80()
{
	self notify("near_goal");
}

/*
	Name: _sort_by_distance2d
	Namespace: namespace_48757881
	Checksum: 0x26FFB85A
	Offset: 0x3388
	Size: 0x81
	Parameters: 3
	Flags: None
*/
function _sort_by_distance2d(left, right, point)
{
	distanceSqrToLeft = Distance2DSquared(left.origin, point);
	distanceSqrToRight = Distance2DSquared(right.origin, point);
	return distanceSqrToLeft > distanceSqrToRight;
}

/*
	Name: stopMovementAndSetBrake
	Namespace: namespace_48757881
	Checksum: 0xB91CA6E3
	Offset: 0x3418
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
	Namespace: namespace_48757881
	Checksum: 0x1F13FB41
	Offset: 0x34B8
	Size: 0x23B
	Parameters: 3
	Flags: None
*/
function face_target(position, targetAngleDiff, var_a39fa3d8)
{
	if(!isdefined(var_a39fa3d8))
	{
		var_a39fa3d8 = 1;
	}
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
	if(var_a39fa3d8)
	{
		self SetTurretTargetVec(position);
	}
	self locomotion_start();
	angleAdjustingStart = GetTime();
	while(angleDiff > targetAngleDiff && vehicle_ai::TimeSince(angleAdjustingStart) < 4)
	{
		angleDiff = AbsAngleClamp180(self.angles[1] - goalAngles[1]);
		wait(0.05);
	}
	self ClearVehGoalPos();
	self ClearLookAtEnt();
	if(var_a39fa3d8)
	{
		self ClearTurretTarget();
	}
	self CancelAIMove();
}

/*
	Name: function_75775e52
	Namespace: namespace_48757881
	Checksum: 0x4B48CB19
	Offset: 0x3700
	Size: 0x169
	Parameters: 2
	Flags: None
*/
function function_75775e52(point, range)
{
	a_zombies = GetAIArchetypeArray("zombie");
	foreach(zombie in a_zombies)
	{
		if(isalive(zombie) && zombie.KNOCKDOWN !== 1 && Distance2DSquared(point, zombie.origin) < range * range && point[2] - zombie.origin[2] * point[2] - zombie.origin[2] < 100 * 100)
		{
			zombie zombie_utility::setup_zombie_knockdown(self);
		}
	}
}

/*
	Name: function_86cc3c11
	Namespace: namespace_48757881
	Checksum: 0x7EB1B075
	Offset: 0x3878
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_86cc3c11()
{
	count = 0;
	for(i = 1; i < 5; i++)
	{
		if(self.var_65850094[i] <= 0)
		{
			count++;
		}
	}
	return count;
}

/*
	Name: function_b9b039e0
	Namespace: namespace_48757881
	Checksum: 0xD8764E20
	Offset: 0x38E0
	Size: 0x583
	Parameters: 15
	Flags: None
*/
function function_b9b039e0(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(!isPlayer(eAttacker))
	{
		return 0;
	}
	if(level flag::get("world_is_paused"))
	{
		return 0;
	}
	if(sMeansOfDeath === "MOD_MELEE")
	{
		return 0;
	}
	if(isdefined(weapon))
	{
		var_cf9744cb = StrTok(weapon.name, "_");
		if(var_cf9744cb[0] === "shotgun")
		{
			iDamage = Int(float(iDamage) / float(weapon.shotCount));
		}
	}
	iDamage = Int(float(iDamage) / float(level.players.size));
	if(iDamage < 1)
	{
		iDamage = 1;
	}
	var_7e43f478 = StrTok(partName, "_");
	if(var_7e43f478[1] == "heat" && var_7e43f478[2] == "vent")
	{
		n_index = Int(var_7e43f478[3]);
		if(self.var_65850094[n_index] <= 0)
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}
	str_partname = partName;
	switch(n_index)
	{
		case 1:
		{
			str_partname = "tag_heat_vent_01_d0";
			break;
		}
		case 2:
		{
			str_partname = "tag_heat_vent_02_d0";
			break;
		}
		case 4:
		{
			break;
		}
		case 3:
		{
			break;
		}
		case 5:
		{
			str_partname = "tag_heat_vent_05_d1";
			break;
		}
		case default:
		{
			return 0;
		}
	}
	if(n_index == 5 && function_86cc3c11() < 4)
	{
		return 0;
	}
	var_cf402baf = self.var_65850094[n_index] > 0 && self.var_65850094[n_index] - iDamage <= 0;
	self.var_65850094[n_index] = self.var_65850094[n_index] - iDamage;
	eAttacker.var_b3a9099 = eAttacker.var_b3a9099 + iDamage;
	eAttacker show_hit_marker();
	if(var_cf402baf)
	{
		self notify("hash_d4ba4cd");
		if(n_index == 1)
		{
			self HidePart("tag_heat_vent_01_d0_col");
			self notify("hash_5eb926b6");
		}
		else if(n_index == 2)
		{
			self HidePart("tag_heat_vent_02_d0_col");
			self notify("hash_ae5c218");
		}
		mod = "MOD_MELEE";
		if(n_index == 5)
		{
			self.allowdeath = 1;
			mod = "MOD_IMPACT";
		}
		self finishVehicleDamage(eInflictor, eAttacker, 10000 * 10000, iDFlags, mod, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, str_partname, 1);
		if(n_index != 5)
		{
			self function_37a64cff(n_index);
		}
		if(function_86cc3c11() >= 4)
		{
			self finishVehicleDamage(eInflictor, eAttacker, 4000, iDFlags, "MOD_IMPACT", weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, "tag_heat_vent_05_d0", 1);
			level notify("hash_f6982dc3");
		}
	}
	return 0;
}

/*
	Name: show_hit_marker
	Namespace: namespace_48757881
	Checksum: 0x9F774E71
	Offset: 0x3E70
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: function_efdfbbf7
	Namespace: namespace_48757881
	Checksum: 0x968FA3B8
	Offset: 0x3F00
	Size: 0x193
	Parameters: 2
	Flags: None
*/
function function_efdfbbf7(var_9d838914, var_e7f2a029)
{
	if(var_e7f2a029 == 2)
	{
		var_e6a3fdd7 = "tag_heat_vent_02_d0_col";
		str_partname = "ai_zm_dlc3_russian_mech_heat_vent_l";
		var_7ae256a = 1;
		str_clientfield = "nikolai_weakpoint_l_fx";
	}
	else
	{
		var_e6a3fdd7 = "tag_heat_vent_01_d0_col";
		str_partname = "ai_zm_dlc3_russian_mech_heat_vent_r";
		var_7ae256a = 2;
		str_clientfield = "nikolai_weakpoint_r_fx";
	}
	if(var_9d838914)
	{
		self ShowPart(var_e6a3fdd7);
		self SetAnim(str_partname);
		self vehicle::toggle_ambient_anim_group(var_7ae256a, 1);
		self clientfield::set(str_clientfield, 1);
	}
	else
	{
		self HidePart(var_e6a3fdd7);
		self ClearAnim(str_partname, 0.1);
		self vehicle::toggle_ambient_anim_group(var_7ae256a, 0);
		self clientfield::set(str_clientfield, 0);
	}
}

/*
	Name: function_37a64cff
	Namespace: namespace_48757881
	Checksum: 0x8899A5A5
	Offset: 0x40A0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_37a64cff(var_ce1b5a05)
{
	switch(var_ce1b5a05)
	{
		case 1:
		{
			str_clientfield = "nikolai_destroyed_r_arm";
			break;
		}
		case 2:
		{
			str_clientfield = "nikolai_destroyed_l_arm";
			break;
		}
		case 3:
		{
			str_clientfield = "nikolai_destroyed_r_chest";
			break;
		}
		case 4:
		{
			str_clientfield = "nikolai_destroyed_l_chest";
			break;
		}
	}
	self clientfield::set(str_clientfield, 1);
}

/*
	Name: function_a3258c2a
	Namespace: namespace_48757881
	Checksum: 0x7A8A2E53
	Offset: 0x4150
	Size: 0x3FB
	Parameters: 1
	Flags: None
*/
function function_a3258c2a(var_f8b7c9a1)
{
	if(!isalive(self))
	{
		return 0;
	}
	self endon("death");
	self vehicle_ai::set_state("special_attack");
	self endon("change_state");
	foreach(player in level.activePlayers)
	{
		self GetPerfectInfo(player, 0);
	}
	self locomotion_start();
	self clientfield::set("nikolai_gatling_tell", 1);
	if(isdefined(self.enemy))
	{
		self vehicle_ai::SetTurretTarget(self.enemy, 0);
		self vehicle_ai::SetTurretTarget(self.enemy, 1);
	}
	if(self.var_65850094[2] > 0)
	{
		self function_efdfbbf7(1, 2);
	}
	var_a3f49a09 = 137.5;
	weapon = self SeatGetWeapon(1);
	var_82d8b276 = weapon.fireTime * 0.5;
	var_9e93cc65 = GetTime();
	while(isdefined(self.enemy) && vehicle_ai::TimeSince(var_9e93cc65) < var_f8b7c9a1)
	{
		self SetLookAtEnt(self.enemy);
		self vehicle_ai::SetTurretTarget(self.enemy, 0);
		var_4842b473 = AnglesToForward((0, RandomInt(100) * var_a3f49a09, 0)) * 100;
		var_8a7bdf21 = self.enemy GetVelocity() * -0.3;
		var_1c83c677 = self.enemy.origin + var_4842b473 + var_8a7bdf21;
		self vehicle_ai::SetTurretTarget(var_1c83c677, 1);
		wait(var_82d8b276);
		self FireWeapon(1, undefined, var_4842b473 + var_8a7bdf21, self);
	}
	self notify("fire_stop");
	self clientfield::set("nikolai_gatling_tell", 0);
	if(self.var_65850094[2] > 0)
	{
		self function_efdfbbf7(0, 2);
	}
	else
	{
		self clientfield::set("nikolai_weakpoint_l_fx", 0);
	}
	self vehicle_ai::set_state("combat");
}

/*
	Name: function_59fe8c9c
	Namespace: namespace_48757881
	Checksum: 0x7E69090D
	Offset: 0x4558
	Size: 0x5EB
	Parameters: 1
	Flags: None
*/
function function_59fe8c9c(var_1c83c677)
{
	if(!isalive(self))
	{
		return 0;
	}
	self endon("death");
	self vehicle_ai::set_state("special_attack");
	self endon("change_state");
	self SetTurretTargetRelativeAngles((0, 0, 0), 0);
	self SetTurretTargetRelativeAngles((0, 0, 0), 1);
	self SetTurretTargetRelativeAngles((0, 0, 0), 2);
	self face_target(var_1c83c677, 30);
	self notify("hash_c72aec1e");
	if(self.var_65850094[1] > 0)
	{
		self function_efdfbbf7(1, 1);
	}
	if(self.var_65850094[2] > 0)
	{
		self function_efdfbbf7(1, 2);
	}
	self ASMRequestSubstate("javelin@stationary");
	var_a3f49a09 = 137.5;
	for(i = 0; i < 6; i++)
	{
		if(i % 2 == 0)
		{
			self util::waittill_notify_or_timeout("fire_raps", 0.5);
		}
		var_3e32f05a = undefined;
		while(!isdefined(var_3e32f05a))
		{
			if(level flag::get("world_is_paused"))
			{
				level flag::wait_till_clear("world_is_paused");
			}
			spawnTag = self GetTagOrigin("tag_flash");
			tagAngles = self GetTagAngles("tag_flash");
			var_5d7a8c53 = anglesToUp(tagAngles);
			var_3e32f05a = SpawnVehicle("spawner_zm_dlc3_vehicle_raps_nikolai", spawnTag, self.angles);
			if(!isdefined(var_3e32f05a))
			{
				wait(0.1);
			}
		}
		var_3e32f05a.exclude_cleanup_adding_to_total = 1;
		var_3e32f05a.b_ignore_cleanup = 1;
		var_3e32f05a.no_eye_glow = 1;
		PlayFXOnTag("dlc3/stalingrad/fx_mech_wpn_raps_launcher_muz", self, "tag_flash");
		var_3e32f05a Hide();
		var_3e32f05a.takedamage = 0;
		wait(0.05);
		var_3e32f05a.origin = spawnTag + var_5d7a8c53 * 40;
		wait(0.05);
		var_3e32f05a show();
		wait(0.05);
		if(!isdefined(level.var_c3c3ffc5))
		{
			level.var_c3c3ffc5 = [];
		}
		else if(!IsArray(level.var_c3c3ffc5))
		{
			level.var_c3c3ffc5 = Array(level.var_c3c3ffc5);
		}
		level.var_c3c3ffc5[level.var_c3c3ffc5.size] = var_3e32f05a;
		level.var_6d27427c++;
		var_3e32f05a namespace_48c05c81::function_d48ad6b4();
		var_3e32f05a thread function_6deb3e8d();
		var_3e32f05a.takedamage = 1;
		var_3e32f05a thread function_3b145bbb();
		offset = AnglesToForward((0, i * var_a3f49a09, 0));
		launchForce = var_5d7a8c53 * 300 + offset * 40;
		var_3e32f05a thread function_853d3b2b(var_1c83c677 + offset * 60, launchForce);
		wait(0.1);
	}
	if(self.var_65850094[1] > 0)
	{
		self function_efdfbbf7(0, 1);
	}
	else
	{
		self clientfield::set("nikolai_weakpoint_r_fx", 0);
	}
	if(self.var_65850094[2] > 0)
	{
		self function_efdfbbf7(0, 2);
	}
	else
	{
		self clientfield::set("nikolai_weakpoint_l_fx", 0);
	}
	self vehicle_ai::waittill_asm_complete("javelin@stationary", 4);
	self vehicle_ai::set_state("combat");
}

/*
	Name: function_853d3b2b
	Namespace: namespace_48757881
	Checksum: 0xBF633414
	Offset: 0x4B50
	Size: 0x1DB
	Parameters: 2
	Flags: None
*/
function function_853d3b2b(var_ff72f147, launchForce)
{
	self endon("death");
	self clientfield::set("play_raps_trail_fx", 1);
	self vehicle_ai::set_state("scripted");
	self vehicle::toggle_sounds(0);
	var_87f1eda4 = GetTime();
	self LaunchVehicle(launchForce);
	wait(0.5);
	self function_10215c6f(var_ff72f147);
	self show();
	while(!isdefined(GetClosestPointOnNavMesh(self.origin, 200)) && vehicle_ai::TimeSince(var_87f1eda4) < 4)
	{
		wait(0.1);
	}
	self clientfield::set("play_raps_trail_fx", 0);
	self vehicle_ai::set_state("combat");
	self util::waittill_notify_or_timeout("veh_collision", 1);
	self vehicle::toggle_sounds(1);
	self clientfield::set("raps_landing", 1);
	self.test_failed_path = 1;
	self thread function_902a2c47();
}

/*
	Name: function_902a2c47
	Namespace: namespace_48757881
	Checksum: 0xBEB2A4C
	Offset: 0x4D38
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_902a2c47()
{
	wait(10);
	while(level flag::get("world_is_paused"))
	{
		wait(1);
	}
	if(isdefined(self) && (!isdefined(self zm_zonemgr::entity_in_zone("boss_arena_zone", 0)) && self zm_zonemgr::entity_in_zone("boss_arena_zone", 0)))
	{
		self kill();
	}
}

/*
	Name: function_6deb3e8d
	Namespace: namespace_48757881
	Checksum: 0xBCC39E64
	Offset: 0x4DD8
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function function_6deb3e8d()
{
	self endon("death");
	while(isalive(self))
	{
		self waittill("veh_predictedcollision", otherEnt);
		if(isalive(otherEnt) && otherEnt.archetype === "zombie" && otherEnt.KNOCKDOWN !== 1)
		{
			otherEnt zombie_utility::setup_zombie_knockdown(self);
		}
	}
}

/*
	Name: function_3b145bbb
	Namespace: namespace_48757881
	Checksum: 0x595A59E2
	Offset: 0x4E88
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function function_3b145bbb()
{
	self waittill("death");
	level.var_6d27427c--;
	if(level.var_6d27427c < 1)
	{
		level.var_5fe02c5a = undefined;
	}
}

/*
	Name: pin_spike_to_ground
	Namespace: namespace_48757881
	Checksum: 0x3FBADC8F
	Offset: 0x4EC8
	Size: 0x2E7
	Parameters: 2
	Flags: None
*/
function pin_spike_to_ground(spike, targetOrigin)
{
	spike endon("death");
	targetDist = Distance2D(spike.origin, targetOrigin) - 400 + RandomFloat(60);
	startOrigin = spike.origin;
	while(Distance2DSquared(spike.origin, startOrigin) < targetDist * 0.4 * targetDist * 0.4)
	{
		wait(0.05);
	}
	var_5f13f183 = 1;
	maxPitch = 10;
	while(Distance2DSquared(spike.origin, startOrigin) < max(targetDist * targetDist, 150 * 150))
	{
		pitch = AngleClamp180(spike.angles[0]);
		if(pitch < maxPitch)
		{
			pitch = pitch + min(var_5f13f183, maxPitch - pitch);
			spike.angles = (pitch, spike.angles[1], spike.angles[2]);
		}
		wait(0.05);
	}
	var_5f13f183 = 16;
	maxPitch = 76;
	while(spike.angles[0] < maxPitch)
	{
		pitch = AngleClamp180(spike.angles[0]);
		pitch = pitch + var_5f13f183;
		if(pitch > maxPitch)
		{
			pitch = RandomFloatRange(maxPitch, min(pitch, 90));
		}
		spike.angles = (pitch, spike.angles[1], spike.angles[2]);
		wait(0.05);
	}
}

/*
	Name: function_db9ecada
	Namespace: namespace_48757881
	Checksum: 0xFE739314
	Offset: 0x51B8
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function function_db9ecada()
{
	self notify("hash_f7204730");
	self endon("hash_f7204730");
	self endon("change_state");
	while(1)
	{
		self waittill("grenade_stuck", var_8e857deb, origin, normal);
		var_8e857deb thread function_d7ef4d80();
		self function_75775e52(var_8e857deb.origin, 120);
		var_8e857deb clientfield::set("harpoon_impact", 1);
	}
}

/*
	Name: function_d7ef4d80
	Namespace: namespace_48757881
	Checksum: 0x48CBA058
	Offset: 0x5288
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function function_d7ef4d80()
{
	self endon("death");
	while(1)
	{
		a_ai_zombies = GetAIArchetypeArray("zombie");
		a_ai_zombies = ArraySortClosest(a_ai_zombies, self.origin, undefined, undefined, 200);
		foreach(ai_zombie in a_ai_zombies)
		{
			if(!isdefined(ai_zombie.is_elemental_zombie))
			{
				ai_zombie.var_bb98125f = 1;
				ai_zombie thread namespace_57695b4d::function_1b1bb1b();
			}
		}
		wait(0.25);
	}
}

/*
	Name: function_dfc5ede1
	Namespace: namespace_48757881
	Checksum: 0x5BD40020
	Offset: 0x53A8
	Size: 0x39B
	Parameters: 1
	Flags: None
*/
function function_dfc5ede1(targetEnt)
{
	if(!isalive(self))
	{
		return 0;
	}
	self endon("death");
	/#
		Assert(isalive(targetEnt));
	#/
	target = targetEnt.origin;
	vecToTarget = (target - self.origin[0], target - self.origin[1], 0);
	if(LengthSquared(vecToTarget) < 0.01 * 0.01)
	{
		return 0;
	}
	self vehicle_ai::set_state("special_attack");
	self endon("change_state");
	spikeCoverRadius = 600;
	randomScale = 40;
	self SetTurretTargetRelativeAngles((0, 0, 0), 0);
	self SetTurretTargetRelativeAngles((0, 0, 0), 1);
	self SetTurretTargetRelativeAngles((0, 0, 0), 2);
	self vehicle_ai::SetTurretTarget(targetEnt, 0);
	self face_target(target, 30, 0);
	self notify("hash_2eb273f0", target);
	if(self.var_65850094[1] > 0)
	{
		self function_efdfbbf7(1, 1);
	}
	self ASMRequestSubstate("arm_rocket@stationary");
	self thread function_db9ecada();
	for(i = 0; i < 3; i++)
	{
		self waittill("hash_685ef1dd");
		spike = self FireWeapon(2);
		self ClearTurretTarget();
		if(isdefined(spike))
		{
			self thread pin_spike_to_ground(spike, target);
		}
	}
	self cleargunnertarget(1);
	self ClearTurretTarget();
	if(self.var_65850094[1] > 0)
	{
		self function_efdfbbf7(0, 1);
	}
	else
	{
		self clientfield::set("nikolai_weakpoint_r_fx", 0);
	}
	self vehicle_ai::waittill_asm_complete("arm_rocket@stationary", 2);
	self vehicle_ai::set_state("combat");
}

/*
	Name: is_valid_target
	Namespace: namespace_48757881
	Checksum: 0x913EEF54
	Offset: 0x5750
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function is_valid_target(target)
{
	if(isdefined(target.ignoreme) && target.ignoreme || target.health <= 0)
	{
		return 0;
	}
	else if(isPlayer(target) && target laststand::player_is_in_laststand())
	{
		return 0;
	}
	else if(IsSentient(target) && (target IsNoTarget() || !isalive(target)))
	{
		return 0;
	}
	return 1;
}

