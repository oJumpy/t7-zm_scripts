#using scripts\codescripts\struct;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace quadtank;

/*
	Name: __init__sytem__
	Namespace: quadtank
	Checksum: 0x3BB21369
	Offset: 0x8E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("quadtank", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: quadtank
	Checksum: 0x58DD96E9
	Offset: 0x920
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("quadtank", &quadtank_initialize);
	clientfield::register("toplayer", "player_shock_fx", 1, 1, "int");
	clientfield::register("vehicle", "quadtank_trophy_state", 1, 1, "int");
}

/*
	Name: quadtank_initialize
	Namespace: quadtank
	Checksum: 0x24B7E787
	Offset: 0x9B8
	Size: 0x3DB
	Parameters: 0
	Flags: None
*/
function quadtank_initialize()
{
	self useanimtree(-1);
	self EnableAimAssist();
	self SetNearGoalNotifyDist(50);
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self.turret_state = 1;
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.maxsightdistsqrd = 10000 * 10000;
	self.weakpointobjective = 0;
	self.combatactive = 1;
	self.damage_during_trophy_down = 0;
	self.spike_hits_during_trophy_down = 0;
	self.trophy_disables = 0;
	self.allow_movement = 1;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	objectives::set("cp_quadtank_rocket_icon", self);
	objectives::hide_for_target("cp_quadtank_rocket_icon", self);
	self.variant = "cannon";
	if(IsSubStr(self.vehicleType, "mlrs"))
	{
		self.variant = "rocketpod";
	}
	self.goalRadius = 9999999;
	self.goalHeight = 512;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self SetSpeed(self.settings.defaultMoveSpeed, 10, 10);
	self SetMinDesiredTurnYaw(45);
	self show_weak_spots(0);
	turret::_init_turret(1);
	turret::_init_turret(2);
	turret::set_best_target_func(&_get_best_target_quadtank_side_turret, 1);
	turret::set_best_target_func(&_get_best_target_quadtank_side_turret, 2);
	self quadtank_update_difficulty();
	self quadtank_side_turrets_forward();
	self.overrideVehicleDamage = &QuadtankCallback_VehicleDamage;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	self.ignoreFireFly = 1;
	self.ignoreDecoy = 1;
	self vehicle_ai::InitThreatBias();
	self.disableElectroDamage = 1;
	self.disableBurnDamage = 1;
	self thread vehicle_ai::target_hijackers();
	self HidePart("tag_defense_active");
	defaultRole();
}

/*
	Name: quadtank_update_difficulty
	Namespace: quadtank
	Checksum: 0x515EA16
	Offset: 0xDA0
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function quadtank_update_difficulty()
{
	if(isdefined(level.players))
	{
		value = level.players.size;
	}
	else
	{
		value = 1;
	}
	scale_up = mapfloat(1, 4, 1, 1.5, value);
	scale_down = mapfloat(1, 4, 1, 0.75, value);
	turret::set_burst_parameters(1.5, 2.5 * scale_up, 0.25 * scale_down, 0.75 * scale_down, 1);
	turret::set_burst_parameters(1.5, 2.5 * scale_up, 0.25 * scale_down, 0.75 * scale_down, 2);
	self.difficulty_scale_up = scale_up;
	self.difficulty_scale_down = scale_down;
}

/*
	Name: defaultRole
	Namespace: quadtank
	Checksum: 0xA7EA5204
	Offset: 0xEE8
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self.state_machine = self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("pain").update_func = &pain_update;
	self vehicle_ai::get_state_callbacks("emped").update_func = &quadtank_emped;
	self vehicle_ai::get_state_callbacks("off").enter_func = &state_off_enter;
	self vehicle_ai::get_state_callbacks("off").exit_func = &state_off_exit;
	self vehicle_ai::get_state_callbacks("scripted").update_func = &state_scripted_update;
	self vehicle_ai::get_state_callbacks("driving").update_func = &state_driving_update;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("combat").exit_func = &state_combat_exit;
	self vehicle_ai::get_state_callbacks("death").update_func = &quadtank_death;
	self vehicle_ai::call_custom_add_state_callbacks();
	self vehicle_ai::StartInitialState();
}

/*
	Name: quadtank_off
	Namespace: quadtank
	Checksum: 0xAF1A9DD7
	Offset: 0x1100
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function quadtank_off()
{
	self vehicle_ai::set_state("off");
	self.combatactive = 0;
}

/*
	Name: quadtank_on
	Namespace: quadtank
	Checksum: 0xC2BEC379
	Offset: 0x1138
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function quadtank_on()
{
	self vehicle_ai::set_state("combat");
	self.combatactive = 1;
}

/*
	Name: state_off_enter
	Namespace: quadtank
	Checksum: 0xB0A2E301
	Offset: 0x1170
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function state_off_enter(params)
{
	self playsound("veh_quadtank_power_down");
	self LaserOff();
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
	vehicle_ai::TurnOffAllLightsAndLaser();
	vehicle_ai::TurnOffAllAmbientAnims();
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_sounds(0);
	self vehicle::toggle_exhaust_fx(0);
	angles = self GetTagAngles("tag_flash");
	target_vec = self.origin + AnglesToForward((0, angles[1], 0)) * 1000;
	target_vec = target_vec + VectorScale((0, 0, -1), 500);
	self SetTargetOrigin(target_vec);
	self set_side_turrets_enabled(0);
	self thread quadtank_disabletrophy();
	if(!isdefined(self.emped))
	{
		self DisableAimAssist();
	}
}

/*
	Name: state_off_exit
	Namespace: quadtank
	Checksum: 0xAECE5E52
	Offset: 0x1360
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function state_off_exit(params)
{
	self vehicle::lights_on();
	self vehicle::toggle_tread_fx(1);
	self vehicle::toggle_sounds(1);
	self thread bootup();
	self vehicle::toggle_exhaust_fx(1);
	self EnableAimAssist();
}

/*
	Name: bootup
	Namespace: quadtank
	Checksum: 0x6BD57B2C
	Offset: 0x1408
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function bootup()
{
	self endon("death");
	self playsound("veh_quadtank_power_up");
	self vehicle_ai::blink_lights_for_time(1.5);
	angles = self GetTagAngles("tag_flash");
	target_vec = self.origin + AnglesToForward((0, angles[1], 0)) * 1000;
	self.turretRotScale = 0.3;
	driver = self GetSeatOccupant(0);
	if(!isdefined(driver))
	{
		self SetTargetOrigin(target_vec);
	}
	wait(1);
	self.turretRotScale = 1 * self.difficulty_scale_up;
}

/*
	Name: pain_update
	Namespace: quadtank
	Checksum: 0x8403ABF0
	Offset: 0x1538
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function pain_update(params)
{
	self endon("change_state");
	self endon("death");
	isTrophyDownPain = params.notify_param[0];
	if(isTrophyDownPain === 1)
	{
		asmState = "trophy_disabled@stationary";
	}
	else
	{
		asmState = "pain@stationary";
	}
	self ASMRequestSubstate(asmState);
	playsoundatposition("prj_quad_impact", self.origin);
	self CancelAIMove();
	self ClearVehGoalPos();
	self ClearTurretTarget();
	self SetBrake(1);
	self vehicle_ai::waittill_asm_complete(asmState, 6);
	self SetBrake(0);
	self ASMRequestSubstate("locomotion@movement");
	driver = self GetSeatOccupant(0);
	if(!isdefined(driver))
	{
		self vehicle_ai::set_state("combat");
	}
	else
	{
		self vehicle_ai::set_state("driving");
	}
}

/*
	Name: state_scripted_update
	Namespace: quadtank
	Checksum: 0xBE84BAD3
	Offset: 0x1710
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function state_scripted_update(params)
{
	self endon("death");
	self endon("change_state");
	self set_side_turrets_enabled(0);
	self LaserOff();
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
	self vehicle::toggle_ambient_anim_group(2, 1);
}

/*
	Name: state_driving_update
	Namespace: quadtank
	Checksum: 0xD65FA606
	Offset: 0x17D8
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function state_driving_update(params)
{
	self endon("death");
	self endon("change_state");
	self set_side_turrets_enabled(0);
	self LaserOff();
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
	self vehicle::toggle_ambient_anim_group(2, 1);
	objectives::hide_for_target("cp_quadtank_rocket_icon", self);
	driver = self GetSeatOccupant(0);
	if(isdefined(driver))
	{
		self.turretRotScale = 1;
		self DisableAimAssist();
		self thread quadtank_set_team(driver.team);
		self SetBrake(0);
		self ASMRequestSubstate("locomotion@movement");
		self thread quadtank_player_fireupdate();
		self thread footstep_handler();
		self.trophy_disables = 3;
		self thread quadtank_disabletrophy();
	}
}

/*
	Name: quadtank_exit_vehicle
	Namespace: quadtank
	Checksum: 0x1B9D90C7
	Offset: 0x19B0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function quadtank_exit_vehicle()
{
	self SetGoal(self.origin);
}

/*
	Name: state_combat_update
	Namespace: quadtank
	Checksum: 0xD0489819
	Offset: 0x19E0
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("death");
	self endon("change_state");
	if(isalive(self) && !trophy_disabled())
	{
		self thread quadtank_enabletrophy();
	}
	if(self.allow_movement)
	{
		self thread quadtank_movementupdate();
	}
	else
	{
		self SetBrake(1);
	}
	switch(self.variant)
	{
		case "cannon":
		{
			vehicle_ai::Cooldown("main_cannon", 4);
			self thread quadtank_weapon_think_cannon();
			break;
		}
		case "rocketpod":
		{
			self thread Attack_Thread_rocket();
			break;
		}
	}
}

/*
	Name: state_combat_exit
	Namespace: quadtank
	Checksum: 0xA900C375
	Offset: 0x1B18
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function state_combat_exit(params)
{
	self notify("end_attack_thread");
	self notify("end_movement_thread");
	self ClearTurretTarget();
	self ClearLookAtEnt();
}

/*
	Name: quadtank_death
	Namespace: quadtank
	Checksum: 0x74C7BDDC
	Offset: 0x1B78
	Size: 0x28B
	Parameters: 1
	Flags: None
*/
function quadtank_death(params)
{
	self endon("death");
	self endon("nodeath_thread");
	self set_trophy_state(0);
	self quadtank_weakpoint_display(0);
	objectives::hide_for_target("cp_quadtank_rocket_icon", self);
	self remove_repulsor();
	self HidePart("tag_lidar_null", "", 1);
	self vehicle::set_damage_fx_level(0);
	StreamerModelHint(self.deathmodel, 6);
	if(!isdefined(self.custom_death_sequence))
	{
		playsoundatposition("prj_quad_impact", self.origin);
		self playsound("veh_quadtank_power_down");
		self playsound("veh_quadtank_sparks");
		self ASMRequestSubstate("death@stationary");
		self waittill("explosion_c");
	}
	else
	{
		self [[self.custom_death_sequence]]();
	}
	if(isdefined(level.disable_thermal))
	{
		[[level.disable_thermal]]();
	}
	if(isdefined(self.stun_fx))
	{
		self.stun_fx delete();
	}
	BadPlace_Box("", 0, self.origin, 90, "neutral");
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle_death::death_radius_damage();
	vehicle_ai::waittill_asm_complete("death@stationary", 5);
	self thread vehicle_death::CleanUp();
	vehicle_death::FreeWhenSafe();
}

/*
	Name: quadtank_emped
	Namespace: quadtank
	Checksum: 0x2A37805B
	Offset: 0x1E10
	Size: 0x20B
	Parameters: 1
	Flags: None
*/
function quadtank_emped(params)
{
	self endon("death");
	self endon("change_state");
	self endon("emped");
	if(isdefined(self.emped))
	{
		return;
	}
	self.emped = 1;
	playsoundatposition("veh_quadtankemp_down", self.origin);
	self.turretRotScale = 0.2;
	if(!isdefined(self.stun_fx))
	{
		self.stun_fx = spawn("script_model", self.origin);
		self.stun_fx SetModel("tag_origin");
		self.stun_fx LinkTo(self, "tag_turret", (0, 0, 0), (0, 0, 0));
	}
	time = params.notify_param[0];
	/#
		Assert(isdefined(time));
	#/
	vehicle_ai::Cooldown("emped_timer", time);
	while(!vehicle_ai::IsCooldownReady("emped_timer"))
	{
		timeLeft = max(vehicle_ai::GetCooldownLeft("emped_timer"), 0.5);
		wait(timeLeft);
	}
	self.stun_fx delete();
	self.emped = undefined;
	self playsound("veh_boot_quadtank");
	self vehicle_ai::evaluate_connections();
}

/*
	Name: trophy_disabled
	Namespace: quadtank
	Checksum: 0x240566E0
	Offset: 0x2028
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function trophy_disabled()
{
	if(self.trophy_down === 1)
	{
		return 1;
	}
	if(trophy_destroyed())
	{
		return 1;
	}
	return 0;
}

/*
	Name: trophy_destroyed
	Namespace: quadtank
	Checksum: 0x985FC96B
	Offset: 0x2068
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function trophy_destroyed()
{
	if(self.trophy_disables >= 4)
	{
		return 1;
	}
	return 0;
}

/*
	Name: set_trophy_state
	Namespace: quadtank
	Checksum: 0xAA72DC4B
	Offset: 0x2090
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function set_trophy_state(isOn)
{
	self clientfield::set("quadtank_trophy_state", isOn);
}

/*
	Name: quadtank_disabletrophy
	Namespace: quadtank
	Checksum: 0xF48FC13F
	Offset: 0x20C8
	Size: 0x4A3
	Parameters: 0
	Flags: None
*/
function quadtank_disabletrophy()
{
	self endon("death");
	self notify("stop_disabletrophy");
	self endon("stop_disabletrophy");
	self notify("stop_enabletrophy");
	set_trophy_state(0);
	if(trophy_disabled())
	{
		return;
	}
	self.trophy_down = 1;
	driver = self GetSeatOccupant(0);
	if(!isdefined(driver) && self vehicle_ai::get_current_state() != "off" && self vehicle_ai::get_next_state() !== "off")
	{
		self notify("pain", 1);
	}
	Target_Set(self, VectorScale((0, 0, 1), 60));
	self HidePart("tag_defense_active");
	self.attackerAccuracy = 0.5;
	self.damage_during_trophy_down = 0;
	self.spike_hits_during_trophy_down = 0;
	self.trophy_disables = self.trophy_disables + 1;
	self quadtank_weakpoint_display(0);
	self remove_repulsor();
	driver = self GetSeatOccupant(0);
	if(!isdefined(driver) && self vehicle_ai::get_current_state() != "off" && self vehicle_ai::get_next_state() !== "off")
	{
		objectives::show_for_target("cp_quadtank_rocket_icon", self);
	}
	else
	{
		objectives::hide_for_target("cp_quadtank_rocket_icon", self);
	}
	self set_side_turrets_enabled(0);
	if(isdefined(level.vehicle_defense_cb))
	{
		[[level.vehicle_defense_cb]](self, 0);
	}
	if(trophy_destroyed())
	{
		self notify("trophy_system_destroyed");
		level notify("trophy_system_destroyed", self);
		self playsound("wpn_trophy_disable");
		PlayFXOnTag(self.settings.trophydetonationfx, self, "tag_target_lower");
		self HidePart("tag_lidar_null", "", 1);
		return;
	}
	self notify("trophy_system_disabled");
	level notify("trophy_system_disabled", self);
	self playsound("wpn_trophy_disable");
	self vehicle_ai::Cooldown("trophy_down", self.settings.trophySystemDownTime);
	while(!self vehicle_ai::IsCooldownReady("trophy_down") || self vehicle_ai::get_current_state() === "off")
	{
		if(vehicle_ai::GetCooldownLeft("trophy_down") < 0.5 * self.settings.trophySystemDownTime && (self.damage_during_trophy_down >= self.settings.trophysystemdisablethreshold || self.spike_hits_during_trophy_down >= 5))
		{
			self vehicle_ai::ClearCooldown("trophy_down");
		}
		wait(1);
	}
	driver = self GetSeatOccupant(0);
	if(isdefined(driver))
	{
		self.trophy_disables = 4;
	}
	if(!trophy_destroyed())
	{
		self thread quadtank_enabletrophy();
	}
}

/*
	Name: quadtank_enabletrophy
	Namespace: quadtank
	Checksum: 0xC2BD8FBF
	Offset: 0x2578
	Size: 0x299
	Parameters: 0
	Flags: None
*/
function quadtank_enabletrophy()
{
	self endon("death");
	self notify("stop_enabletrophy");
	self endon("stop_enabletrophy");
	set_trophy_state(1);
	if(isdefined(self.settings.trophywarmup))
	{
	}
	else
	{
	}
	time = 0.1;
	wait(time);
	driver = self GetSeatOccupant(0);
	self.trophy_down = 0;
	self.attackerAccuracy = 1;
	self ShowPart("tag_defense_active");
	objectives::hide_for_target("cp_quadtank_rocket_icon", self);
	self quadtank_projectile_watcher();
	self thread quadtank_automelee_update();
	if(!isdefined(driver))
	{
		self quadtank_weakpoint_display(1);
	}
	else
	{
		self quadtank_weakpoint_display(0);
	}
	if(Target_IsTarget(self))
	{
		Target_remove(self);
	}
	if(!isdefined(driver))
	{
		self set_side_turrets_enabled(1);
	}
	self.trophy_system_health = self.settings.trophySystemHealth;
	if(isdefined(level.players) && level.players.size > 0)
	{
		num_players_trophy_health_modifier = 0.75;
		if(level.players.size == 2)
		{
			num_players_trophy_health_modifier = 1;
		}
		if(level.players.size == 3)
		{
			num_players_trophy_health_modifier = 1.25;
		}
		if(level.players.size >= 4)
		{
			num_players_trophy_health_modifier = 1.5;
		}
		self.trophy_system_health = self.trophy_system_health * num_players_trophy_health_modifier;
	}
	if(isdefined(level.vehicle_defense_cb))
	{
		[[level.vehicle_defense_cb]](self, 1);
	}
	self notify("trophy_system_enabled", self.settings.trophywarmup);
	level notify("trophy_system_enabled", self);
}

/*
	Name: quadtank_side_turrets_forward
	Namespace: quadtank
	Checksum: 0xE3312B7A
	Offset: 0x2820
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function quadtank_side_turrets_forward()
{
	self SetTurretTargetRelativeAngles((10, -90, 0), 1);
	self SetTurretTargetRelativeAngles((10, 90, 0), 2);
	self.turretRotScale = 1 * self.difficulty_scale_up;
}

/*
	Name: quadtank_turret_scan
	Namespace: quadtank
	Checksum: 0xB6B66A13
	Offset: 0x2890
	Size: 0x2BF
	Parameters: 1
	Flags: None
*/
function quadtank_turret_scan(scan_forever)
{
	self endon("death");
	self endon("change_state");
	self.turretRotScale = 0.3;
	while(scan_forever || (!isdefined(self.enemy) || !self VehCanSee(self.enemy)))
	{
		if(self.turretontarget && self.turret_state != 0)
		{
			self.turret_state++;
			if(self.turret_state >= 5)
			{
				self.turret_state = 1;
			}
		}
		switch(self.turret_state)
		{
			case 0:
			{
				if(isdefined(self.enemy))
				{
					self SetLookAtEnt(self.enemy);
					target_vec = self.enemy.origin + VectorScale((0, 0, 1), 40);
					self SetTargetOrigin(target_vec);
					wait(1);
					self ClearLookAtEnt();
					self.turret_state++;
				}
			}
			case 1:
			{
				target_vec = self.origin + AnglesToForward((0, self.angles[1], 0)) * 1000;
				break;
			}
			case 2:
			{
				target_vec = self.origin + AnglesToForward((0, self.angles[1] + 30, 0)) * 1000;
				break;
			}
			case 3:
			{
				target_vec = self.origin + AnglesToForward((0, self.angles[1], 0)) * 1000;
				break;
			}
			case 4:
			{
				target_vec = self.origin + AnglesToForward((0, self.angles[1] - 30, 0)) * 1000;
				break;
			}
		}
		target_vec = target_vec + VectorScale((0, 0, 1), 40);
		self SetTargetOrigin(target_vec);
		wait(0.2);
	}
}

/*
	Name: set_side_turrets_enabled
	Namespace: quadtank
	Checksum: 0x499AB7CF
	Offset: 0x2B58
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function set_side_turrets_enabled(on)
{
	if(on)
	{
		turret::enable(1, 0);
		turret::enable(2, 0);
	}
	else
	{
		turret::disable(1);
		turret::disable(2);
	}
}

/*
	Name: show_weak_spots
	Namespace: quadtank
	Checksum: 0x908FA68
	Offset: 0x2BD8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function show_weak_spots(show)
{
	if(show)
	{
		self vehicle::toggle_exhaust_fx(1);
	}
	else
	{
		self vehicle::toggle_exhaust_fx(0);
	}
}

/*
	Name: set_detonation_time
	Namespace: quadtank
	Checksum: 0xD37057ED
	Offset: 0x2C28
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function set_detonation_time(target)
{
	self endon("change_state");
	self playsound("veh_quadtank_cannon_charge");
	self waittill("weapon_fired", proj);
	self thread railgun_sound(proj);
	if(isdefined(target) && isdefined(proj))
	{
		vel = proj GetVelocity();
		proj_speed = length(vel);
		dist = Distance(proj.origin, target.origin) + RandomFloatRange(0, 40);
		time_to_enemy = dist / proj_speed;
		proj ResetMissileDetonationTime(time_to_enemy);
	}
}

/*
	Name: quadtank_weapon_think_cannon
	Namespace: quadtank
	Checksum: 0xC2115316
	Offset: 0x2D70
	Size: 0x61F
	Parameters: 0
	Flags: None
*/
function quadtank_weapon_think_cannon()
{
	self endon("death");
	self endon("change_state");
	cant_see_enemy_count = 0;
	self set_side_turrets_enabled(1);
	self SetOnTargetAngle(10);
	self.getreadytofire = undefined;
	while(1)
	{
		if(self.hold_cannon === 1 || !vehicle_ai::IsCooldownReady("main_cannon"))
		{
			if(isdefined(self.enemy) && self VehCanSee(self.enemy))
			{
				self SetTurretTargetEnt(self.enemy);
				self SetLookAtEnt(self.enemy);
			}
			wait(0.2);
			continue;
		}
		if(isdefined(self.enemy) && self VehCanSee(self.enemy))
		{
			self.turretRotScale = 1 * self.difficulty_scale_up;
			self SetTurretTargetEnt(self.enemy);
			self SetLookAtEnt(self.enemy);
			if(cant_see_enemy_count >= 2)
			{
				wait(0.1);
				self CancelAIMove();
				self ClearVehGoalPos();
				self notify("near_goal");
			}
			cant_see_enemy_count = 0;
			fired = 0;
			if(isdefined(self.enemy) && self VehCanSee(self.enemy))
			{
				if(DistanceSquared(self.origin, self.enemy.origin) > 72900 && self.turretontarget)
				{
					v_my_forward = AnglesToForward(self.angles);
					v_to_enemy = self.enemy.origin - self.origin;
					v_to_enemy = VectorNormalize(v_to_enemy);
					dot = VectorDot(v_to_enemy, v_my_forward);
					if(dot > 0.707)
					{
						self ASMRequestSubstate("fire@stationary");
						self SetTurretTargetEnt(self.enemy);
						self thread set_detonation_time(self.enemy);
						if(isdefined(level.players) && level.players.size < 3)
						{
							self set_side_turrets_enabled(0);
						}
						self show_weak_spots(1);
						self.getreadytofire = 1;
						fired = 1;
						self CancelAIMove();
						self ClearVehGoalPos();
						self notify("near_goal");
						self.turretRotScale = 0.7;
						wait(1);
						level notify("sndStopCountdown");
						self vehicle_ai::waittill_asm_complete("fire@stationary", 6);
						self set_side_turrets_enabled(1);
						self.turretRotScale = 1;
					}
				}
			}
			self.getreadytofire = undefined;
			if(isdefined(self.enemy))
			{
				self SetTurretTargetEnt(self.enemy);
				self SetLookAtEnt(self.enemy);
			}
			if(fired)
			{
				self show_weak_spots(0);
				vehicle_ai::Cooldown("main_cannon", RandomFloatRange(5, 7.5));
			}
			else
			{
				wait(0.25);
			}
		}
		else
		{
			cant_see_enemy_count++;
			wait(0.5);
			if(cant_see_enemy_count > 40)
			{
				self quadtank_turret_scan(0);
			}
			else if(cant_see_enemy_count > 30)
			{
				self ClearLookAtEnt();
				self ClearTargetEntity();
			}
			else if(isdefined(self.enemy))
			{
				self SetTurretTargetEnt(self.enemy);
				self ClearLookAtEnt();
			}
			else
			{
				self ClearLookAtEnt();
				self quadtank_turret_scan(0);
			}
		}
	}
}

/*
	Name: Attack_Thread_rocket
	Namespace: quadtank
	Checksum: 0x79B1937F
	Offset: 0x3398
	Size: 0x565
	Parameters: 0
	Flags: None
*/
function Attack_Thread_rocket()
{
	self endon("death");
	self endon("end_attack_thread");
	self vehicle::toggle_ambient_anim_group(2, 0);
	while(1)
	{
		useJavelin = 0;
		if(isdefined(self.enemy))
		{
			self SetTurretTargetEnt(self.enemy);
			self SetLookAtEnt(self.enemy);
		}
		if(isdefined(self.enemy) && vehicle_ai::IsCooldownReady("javelin_rocket_launcher", 0.5))
		{
			if(isVehicle(self.enemy) || Distance2DSquared(self.origin, self.enemy.origin) >= 800 * 800)
			{
				useJavelin = !self vehseenrecently(self.enemy, 3) || RandomInt(100) < 3;
			}
		}
		if(isdefined(self.enemy) && vehicle_ai::IsCooldownReady("rocket_launcher", 0.5))
		{
			if(isdefined(level.players) && level.players.size < 3)
			{
				self set_side_turrets_enabled(0);
			}
			self ClearVehGoalPos();
			self notify("near_goal");
			self show_weak_spots(1);
			self vehicle::toggle_ambient_anim_group(2, 1);
			if(!useJavelin)
			{
				self SetVehWeapon(GetWeapon("quadtank_main_turret_rocketpods_straight"));
				offset = VectorScale((0, 0, -1), 50);
				if(isPlayer(self.enemy))
				{
					origin = self.enemy.origin;
					eye = self.enemy GetEye();
					offset = (0, 0, origin[2] - eye[2] - 5);
				}
				vehicle_ai::SetTurretTarget(self.enemy, 0, offset);
			}
			else
			{
				self playsound("veh_quadtank_mlrs_plant_start");
				self SetVehWeapon(GetWeapon("quadtank_main_turret_rocketpods_javelin"));
				vehicle_ai::SetTurretTarget(self.enemy, 0, VectorScale((0, 0, 1), 300));
			}
			wait(1);
			msg = self util::waittill_any_timeout(2, "turret_on_target");
			if(isdefined(self.enemy) && Distance2DSquared(self.origin, self.enemy.origin) > 350 * 350)
			{
				fired = 0;
				for(i = 0; i < 4 && isdefined(self.enemy); i++)
				{
					if(useJavelin)
					{
						if(isPlayer(self.enemy))
						{
							self thread vehicle_ai::Javelin_LoseTargetAtRightTime(self.enemy);
						}
						self thread javeline_incoming(GetWeapon("quadtank_main_turret_rocketpods_javelin"));
					}
					self FireWeapon(0, self.enemy);
					fired = 1;
					wait(0.8);
				}
				if(fired)
				{
					vehicle_ai::Cooldown("rocket_launcher", RandomFloatRange(8, 10));
					if(useJavelin)
					{
						vehicle_ai::Cooldown("javelin_rocket_launcher", 20);
					}
				}
			}
			self set_side_turrets_enabled(1);
			self vehicle::toggle_ambient_anim_group(2, 0);
		}
		wait(1);
	}
}

/*
	Name: trigger_player_shock_fx
	Namespace: quadtank
	Checksum: 0x7838D4DD
	Offset: 0x3908
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function trigger_player_shock_fx()
{
	if(!isdefined(self._player_shock_fx_quadtank_melee))
	{
		self._player_shock_fx_quadtank_melee = 0;
	}
	self._player_shock_fx_quadtank_melee = !self._player_shock_fx_quadtank_melee;
	self clientfield::set_to_player("player_shock_fx", self._player_shock_fx_quadtank_melee);
}

/*
	Name: path_update_interrupt
	Namespace: quadtank
	Checksum: 0xDDFC8E6A
	Offset: 0x3968
	Size: 0x18F
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
	cantSeeEnemyCount = 0;
	while(1)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(isdefined(self.enemy))
			{
				if(Distance2DSquared(self.enemy.origin, self.current_pathto_pos) < 62500)
				{
					self.move_now = 1;
					self notify("near_goal");
				}
				if(!self VehCanSee(self.enemy))
				{
					if(!self vehicle_ai::CanSeeEnemyFromPosition(self.current_pathto_pos, self.enemy, 80))
					{
						cantSeeEnemyCount++;
						if(cantSeeEnemyCount > 5)
						{
							self.move_now = 1;
							self notify("near_goal");
						}
					}
				}
			}
			if(Distance2DSquared(self.current_pathto_pos, self.goalpos) > self.goalRadius * self.goalRadius)
			{
				wait(1);
				self.move_now = 1;
				self notify("near_goal");
			}
		}
		wait(0.3);
	}
}

/*
	Name: Movement_Thread_Wander
	Namespace: quadtank
	Checksum: 0x9987BF0F
	Offset: 0x3B00
	Size: 0x509
	Parameters: 0
	Flags: None
*/
function Movement_Thread_Wander()
{
	self endon("death");
	self endon("change_state");
	self notify("end_movement_thread");
	self endon("end_movement_thread");
	if(self.goalforced)
	{
		return self.goalpos;
	}
	minSearchRadius = 0;
	maxSearchRadius = 2000;
	halfHeight = 300;
	innerSpacing = 90;
	outerSpacing = innerSpacing * 2;
	maxGoalTimeout = 15;
	self ASMRequestSubstate("locomotion@movement");
	wait(0.5);
	self SetBrake(0);
	while(1)
	{
		self SetSpeed(self.settings.defaultMoveSpeed, 5, 5);
		PixBeginEvent("_quadtank::Movement_Thread_Wander");
		queryResult = PositionQuery_Source_Navigation(self.origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing);
		PixEndEvent();
		PositionQuery_Filter_DistanceToGoal(queryResult, self);
		vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
		vehicle_ai::PositionQuery_Filter_Random(queryResult, 200, 250);
		foreach(point in queryResult.data)
		{
			if(Distance2DSquared(self.origin, point.origin) < 28900)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = -100;
				#/
				point.score = point.score + -100;
			}
		}
		self vehicle_ai::PositionQuery_DebugScores(queryResult);
		vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
		foundpath = 0;
		goalpos = self.origin;
		count = queryResult.data.size;
		if(count > 3)
		{
			count = 3;
		}
		for(i = 0; i < count && !foundpath; i++)
		{
			goalpos = queryResult.data[i].origin;
			foundpath = self SetVehGoalPos(goalpos, 0, 1);
		}
		if(foundpath)
		{
			self.current_pathto_pos = goalpos;
			self thread path_update_interrupt();
			self ASMRequestSubstate("locomotion@movement");
			msg = self util::waittill_any_timeout(maxGoalTimeout, "near_goal", "force_goal", "reached_end_node", "goal");
			self CancelAIMove();
			self ClearVehGoalPos();
			if(isdefined(self.move_now))
			{
				self.move_now = undefined;
				wait(0.1);
			}
			else
			{
				wait(0.5);
			}
		}
		else
		{
			self.current_pathto_pos = undefined;
			goalYaw = self GetGoalYaw();
			wait(1);
		}
	}
}

/*
	Name: quadtank_movementupdate
	Namespace: quadtank
	Checksum: 0x37C5C0AF
	Offset: 0x4018
	Size: 0x247
	Parameters: 0
	Flags: None
*/
function quadtank_movementupdate()
{
	self endon("death");
	self endon("change_state");
	self ASMRequestSubstate("locomotion@movement");
	wait(0.5);
	self SetBrake(0);
	while(self.allow_movement)
	{
		if(self.getreadytofire !== 1)
		{
			goalpos = vehicle_ai::FindNewPosition(80);
			if(isdefined(goalpos) && (Distance2DSquared(goalpos, self.origin) > 50 * 50 || Abs(goalpos[2] - self.origin[2]) > self.height))
			{
				self SetSpeed(self.settings.defaultMoveSpeed, 5, 5);
				self SetVehGoalPos(goalpos, 0, 1);
				self.current_pathto_pos = goalpos;
				self thread path_update_interrupt();
				self ASMRequestSubstate("locomotion@movement");
				result = self util::waittill_any_return("near_goal", "reached_end_node", "force_goal");
			}
			else
			{
				self notify("goal");
			}
			self CancelAIMove();
			self ClearVehGoalPos();
			if(isdefined(self.move_now))
			{
				self.move_now = undefined;
				wait(0.1);
			}
			else
			{
				wait(0.5);
			}
			break;
		}
		while(isdefined(self.getreadytofire))
		{
			wait(0.2);
		}
	}
}

/*
	Name: quadtank_player_fireupdate
	Namespace: quadtank
	Checksum: 0xC79E01F7
	Offset: 0x4268
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function quadtank_player_fireupdate()
{
	self endon("death");
	self endon("exit_vehicle");
	weapon = self SeatGetWeapon(1);
	fireTime = weapon.fireTime;
	while(1)
	{
		self SetGunnerTargetVec(self GetGunnerTargetVec(0), 1);
		if(self IsGunnerFiring(0))
		{
			self FireWeapon(2);
		}
		wait(fireTime);
	}
}

/*
	Name: do_melee
	Namespace: quadtank
	Checksum: 0x7F972227
	Offset: 0x4340
	Size: 0x437
	Parameters: 2
	Flags: None
*/
function do_melee(shouldDoDamage, enemy)
{
	if(!isalive(enemy) || DistanceSquared(enemy.origin, self.origin) > 270 * 270)
	{
		return 0;
	}
	if(vehicle_ai::EntityIsArchetype(enemy, "quadtank") || vehicle_ai::EntityIsArchetype(enemy, "raps"))
	{
		return 0;
	}
	if(isPlayer(enemy) && enemy laststand::player_is_in_laststand())
	{
		return 0;
	}
	self notify("play_meleefx");
	if(shouldDoDamage)
	{
		players = GetPlayers();
		foreach(player in players)
		{
			player._takedamage_old = player.takedamage;
			player.takedamage = 0;
		}
		RadiusDamage(self.origin + VectorScale((0, 0, 1), 40), 270, 400, 400, self);
		foreach(player in players)
		{
			player.takedamage = player._takedamage_old;
			player._takedamage_old = undefined;
		}
	}
	else if(isdefined(enemy) && isPlayer(enemy))
	{
		direction = (enemy.origin - self.origin[0], enemy.origin - self.origin[1], 0);
		if(Abs(direction[0]) < 0.01 && Abs(direction[1]) < 0.01)
		{
			direction = (RandomFloatRange(1, 2), RandomFloatRange(1, 2), 0);
		}
		direction = VectorNormalize(direction);
		strength = 1000;
		enemy SetVelocity(enemy GetVelocity() + direction * strength);
		enemy trigger_player_shock_fx();
		enemy DoDamage(15, self.origin, self);
	}
	self playsound("veh_quadtank_emp");
	return 1;
}

/*
	Name: quadtank_automelee_update
	Namespace: quadtank
	Checksum: 0x1CFE72E2
	Offset: 0x4780
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function quadtank_automelee_update()
{
	self endon("death");
	/#
		Assert(isdefined(self.team));
	#/
	while(!trophy_disabled())
	{
		enemies = self GetEnemies();
		meleed = 0;
		foreach(enemy in enemies)
		{
			if(enemy IsNoTarget())
			{
				continue;
			}
			meleed = meleed || self do_melee(!meleed, enemy);
			if(meleed)
			{
				break;
			}
		}
		wait(0.3);
	}
}

/*
	Name: quadtank_destroyturret
	Namespace: quadtank
	Checksum: 0xC32E6EB5
	Offset: 0x48C8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function quadtank_destroyturret(index)
{
	turret::disable(index);
	if(index == 1)
	{
		self HidePart("tag_gunner_barrel1");
		self HidePart("tag_gunner_turret1");
	}
	else if(index == 2)
	{
		self HidePart("tag_gunner_barrel2");
		self HidePart("tag_gunner_turret2");
	}
}

/*
	Name: QuadtankCallback_VehicleDamage
	Namespace: quadtank
	Checksum: 0xEDCE8C5C
	Offset: 0x4990
	Size: 0x6DB
	Parameters: 15
	Flags: None
*/
function QuadtankCallback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	is_damaged_by_grenade = weapon.weapClass == "grenade";
	if(IsSubStr(weapon.name, "spike"))
	{
		if(eAttacker.team !== self.team)
		{
			self.spike_hits_during_trophy_down = self.spike_hits_during_trophy_down + 1;
		}
		is_damaged_by_grenade = 0;
	}
	if(isdefined(eAttacker) && (eAttacker == self || (isPlayer(eAttacker) && eAttacker.usingvehicle && eAttacker.viewlockedentity === self)))
	{
		return 0;
	}
	if(sMeansOfDeath === "MOD_MELEE" || sMeansOfDeath === "MOD_MELEE_WEAPON_BUTT" || sMeansOfDeath === "MOD_MELEE_ASSASSINATE" || sMeansOfDeath === "MOD_ELECTROCUTED" || sMeansOfDeath === "MOD_CRUSH" || weapon.isEmp)
	{
		return 0;
	}
	if(vehicle_ai::EntityIsArchetype(eAttacker, "raps") && !trophy_disabled())
	{
		self.trophy_system_health = 0;
		self.trophy_disables = 3;
		self thread quadtank_disabletrophy();
		if(isPlayer(eAttacker) && damagefeedback::doDamageFeedback(weapon, eInflictor))
		{
			eAttacker thread damagefeedback::update(sMeansOfDeath, eInflictor);
		}
	}
	if(partName == "tag_target_lower" || partName == "tag_target_upper" || partName == "tag_defense_active" || partName == "tag_body_animate")
	{
		if(isdefined(eAttacker) && isPlayer(eAttacker) && eAttacker.team != self.team)
		{
			if(!isdefined(self.trophy_system_health))
			{
				self.trophy_system_health = self.settings.trophySystemHealth;
			}
			if(!trophy_disabled())
			{
				self.trophy_system_health = self.trophy_system_health - iDamage;
				quadtank_weakpoint_trigger();
				if(self.trophy_system_health <= 0)
				{
					self thread quadtank_disabletrophy();
				}
				if(isPlayer(eAttacker) && damagefeedback::doDamageFeedback(weapon, eInflictor))
				{
					if(iDamage > 0)
					{
						eAttacker thread damagefeedback::update(sMeansOfDeath, eInflictor);
					}
				}
			}
		}
	}
	else if(is_damaged_by_grenade)
	{
		iDamage = Int(iDamage * 3);
	}
	self.turret_state = 0;
	self.turretRotScale = 1 * self.difficulty_scale_up;
	self.turret_on_target = 1;
	if(sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_PISTOL_BULLET")
	{
		return iDamage;
	}
	if(IsActor(eAttacker) && iDamage > 250)
	{
		iDamage = 250;
	}
	num_players = GetPlayers().size;
	maxDamage = self.healthdefault * 0.2 - 0.025 * num_players;
	if(sMeansOfDeath !== "MOD_UNKNOWN" && iDamage > maxDamage)
	{
		iDamage = maxDamage;
	}
	damageLevelChanged = vehicle::update_damage_fx_level(self.health, iDamage, self.healthdefault);
	driver = self GetSeatOccupant(0);
	if(sMeansOfDeath != "MOD_UNKNOWN" && !vehicle_ai::EntityIsArchetype(eAttacker, "quadtank"))
	{
		if(self.damage_during_trophy_down + iDamage > self.settings.trophysystemdisablethreshold && self.trophy_disables < 4 && !isdefined(driver))
		{
			iDamage = max(1, self.settings.trophysystemdisablethreshold - self.damage_during_trophy_down);
		}
		self.damage_during_trophy_down = self.damage_during_trophy_down + iDamage;
	}
	if(damageLevelChanged && sMeansOfDeath != "MOD_MELEE_ASSASSINATE" && (!isdefined(eAttacker) || eAttacker.team !== self.team) && !isdefined(driver))
	{
		playsoundatposition("prj_quad_impact", self.origin);
	}
	iDamage = vehicle_ai::shared_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
	return iDamage;
}

/*
	Name: quadtank_set_team
	Namespace: quadtank
	Checksum: 0x88F3F29F
	Offset: 0x5078
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function quadtank_set_team(team)
{
	self.team = team;
	if(!self vehicle_ai::is_instate("off"))
	{
		self vehicle_ai::blink_lights_for_time(0.5);
	}
}

/*
	Name: remove_repulsor
	Namespace: quadtank
	Checksum: 0xFDA320DF
	Offset: 0x50D8
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function remove_repulsor()
{
	if(isdefined(self.missile_repulsor))
	{
		missile_deleteattractor(self.missile_repulsor);
		self.missile_repulsor = undefined;
	}
	self notify("end_repulsor_fx");
}

/*
	Name: repulsor_fx
	Namespace: quadtank
	Checksum: 0xC9CD5A6E
	Offset: 0x5128
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function repulsor_fx()
{
	self notify("end_repulsor_fx");
	self endon("end_repulsor_fx");
	self endon("death");
	self endon("change_state");
	while(1)
	{
		self util::waittill_any("projectile_applyattractor", "play_meleefx");
		if(vehicle_ai::IsCooldownReady("repulsorfx_interval"))
		{
			PlayFXOnTag(self.settings.trophyrepulsefx, self, "tag_body");
			self vehicle::impact_fx(self.settings.trophyrepulsefx_ground);
			vehicle_ai::Cooldown("repulsorfx_interval", 0.5);
			self playsound("wpn_quadtank_shield_impact");
			quadtank_weakpoint_trigger();
		}
	}
}

/*
	Name: quadtank_projectile_watcher
	Namespace: quadtank
	Checksum: 0x6F0864C8
	Offset: 0x5250
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function quadtank_projectile_watcher()
{
	if(!isdefined(self.missile_repulsor))
	{
		self.missile_repulsor = missile_createrepulsorent(self, 40000, self.settings.trophysystemrange, 1);
	}
	self thread repulsor_fx();
}

/*
	Name: turn_off_laser_after
	Namespace: quadtank
	Checksum: 0xC333D3F7
	Offset: 0x52C0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function turn_off_laser_after(time)
{
	self notify("turn_off_laser_thread");
	self endon("turn_off_laser_thread");
	self endon("death");
	wait(time);
	self LaserOff();
}

/*
	Name: side_turret_is_target_in_view_score
	Namespace: quadtank
	Checksum: 0x455084D8
	Offset: 0x5318
	Size: 0x245
	Parameters: 2
	Flags: None
*/
function side_turret_is_target_in_view_score(v_target, n_index)
{
	s_turret = turret::_get_turret_data(n_index);
	v_pivot_pos = self GetTagOrigin(s_turret.str_tag_pivot);
	v_angles_to_target = VectorToAngles(v_target - v_pivot_pos);
	n_rest_angle_pitch = s_turret.n_rest_angle_pitch + self.angles[0];
	n_rest_angle_yaw = s_turret.n_rest_angle_yaw + self.angles[1];
	n_ang_pitch = AngleClamp180(v_angles_to_target[0] - n_rest_angle_pitch);
	n_ang_yaw = AngleClamp180(v_angles_to_target[1] - n_rest_angle_yaw);
	b_out_of_range = 0;
	if(n_ang_pitch > 0)
	{
		if(n_ang_pitch > s_turret.bottomarc)
		{
			b_out_of_range = 1;
		}
	}
	else if(Abs(n_ang_pitch) > s_turret.toparc)
	{
		b_out_of_range = 1;
	}
	if(n_ang_yaw > 0)
	{
		if(n_ang_yaw > s_turret.leftarc)
		{
			b_out_of_range = 1;
		}
	}
	else if(Abs(n_ang_yaw) > s_turret.rightarc)
	{
		b_out_of_range = 1;
	}
	if(b_out_of_range)
	{
		return 0;
	}
	return Abs(n_ang_yaw) / 90 * 800;
}

/*
	Name: _get_best_target_quadtank_side_turret
	Namespace: quadtank
	Checksum: 0x33D44F02
	Offset: 0x5568
	Size: 0x3E3
	Parameters: 2
	Flags: None
*/
function _get_best_target_quadtank_side_turret(a_potential_targets, n_index)
{
	takeEasyOnOneTarget = mapfloat(0, 4, 800, 0, level.gameskill);
	if(n_index === 1)
	{
		other_turret_target = turret::get_target(2);
	}
	else if(n_index === 2)
	{
		other_turret_target = turret::get_target(1);
	}
	e_best_target = undefined;
	f_best_score = 100000;
	s_turret = turret::_get_turret_data(n_index);
	foreach(e_target in a_potential_targets)
	{
		f_score = Distance(self.origin, e_target.origin);
		b_current_target = turret::is_target(e_target, n_index);
		if(b_current_target)
		{
			f_score = f_score - 100;
		}
		if(e_target === self.enemy)
		{
			f_score = f_score + 300;
		}
		if(e_target === other_turret_target)
		{
			f_score = f_score + 100 + takeEasyOnOneTarget;
		}
		if(IsSentient(e_target) && e_target AttackedRecently(self, 2))
		{
			f_score = f_score - 200;
		}
		if(isalive(self.lockon_owner) && e_target === self.lockon_owner)
		{
			f_score = f_score - 1000;
		}
		v_offset = turret::_get_default_target_offset(e_target, n_index);
		view_score = side_turret_is_target_in_view_score(e_target.origin + v_offset, n_index);
		if(view_score != 0)
		{
			f_score = f_score + view_score;
			b_trace_passed = turret::trace_test(e_target, v_offset, n_index);
			if(b_current_target && !b_trace_passed && !isdefined(s_turret.n_time_lose_sight))
			{
				s_turret.n_time_lose_sight = GetTime();
			}
			if(b_trace_passed)
			{
				f_score = f_score - 500;
			}
		}
		else if(b_current_target)
		{
			s_turret.b_target_out_of_range = 1;
			f_score = f_score + 5000;
		}
		if(f_score < f_best_score)
		{
			f_best_score = f_score;
			e_best_target = e_target;
		}
	}
	return e_best_target;
}

/*
	Name: quadtank_weakpoint_trigger
	Namespace: quadtank
	Checksum: 0x6D2B8381
	Offset: 0x5958
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function quadtank_weakpoint_trigger()
{
	if(isdefined(self.displayweakpoint) && self.displayweakpoint)
	{
		self globallogic_ui::triggerWeakpointDamage(&"tag_target_lower");
	}
}

/*
	Name: quadtank_weakpoint_display
	Namespace: quadtank
	Checksum: 0xAC007AE0
	Offset: 0x5998
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function quadtank_weakpoint_display(State)
{
	if(self.displayweakpoint !== State)
	{
		self.displayweakpoint = State;
		if(!self.displayweakpoint && self.weakpointobjective === 1)
		{
			self.weakpointobjective = 0;
			self globallogic_ui::destroyWeakpointWidget(&"tag_target_lower");
		}
		player = level.players[0];
		if(self.displayweakpoint && self.combatactive && self.weakpointobjective !== 1 && (!isdefined(player) || player.team !== self.team))
		{
			self.weakpointobjective = 1;
			self globallogic_ui::createWeakpointWidget(&"tag_target_lower");
		}
	}
}

/*
	Name: footstep_handler
	Namespace: quadtank
	Checksum: 0xC1DFC1DF
	Offset: 0x5AA8
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function footstep_handler()
{
	self endon("death");
	self endon("exit_vehicle");
	while(1)
	{
		note = self util::waittill_any_return("footstep_front_left", "footstep_front_right", "footstep_rear_left", "footstep_rear_right");
		switch(note)
		{
			case "footstep_front_left":
			{
				bone = "tag_foot_fx_left_front";
				break;
			}
			case "footstep_front_right":
			{
				bone = "tag_foot_fx_right_front";
				break;
			}
			case "footstep_rear_left":
			{
				bone = "tag_foot_fx_left_back";
				break;
			}
			case "footstep_rear_right":
			{
				bone = "tag_foot_fx_right_back";
				break;
			}
		}
		position = self GetTagOrigin(bone) + VectorScale((0, 0, 1), 15);
		self RadiusDamage(position, 60, 50, 50, self, "MOD_CRUSH");
	}
}

/*
	Name: javeline_incoming
	Namespace: quadtank
	Checksum: 0xD7799EFB
	Offset: 0x5BF0
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function javeline_incoming(projectile)
{
	self endon("entityshutdown");
	self endon("death");
	self waittill("weapon_fired", projectile);
	Distance = 1400;
	alias = "prj_quadtank_javelin_incoming";
	wait(5);
	if(!isdefined(projectile))
	{
		return;
	}
	while(isdefined(projectile) && isdefined(projectile.origin))
	{
		if(isdefined(self.enemy) && isdefined(self.enemy.origin))
		{
			projectileDistance = DistanceSquared(projectile.origin, self.enemy.origin);
			if(projectileDistance <= Distance * Distance)
			{
				projectile playsound(alias);
				return;
			}
		}
		wait(0.2);
	}
}

/*
	Name: railgun_sound
	Namespace: quadtank
	Checksum: 0x687B9220
	Offset: 0x5D20
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function railgun_sound(projectile)
{
	self endon("entityshutdown");
	self endon("death");
	self waittill("weapon_fired", projectile);
	Distance = 900;
	alais = "wpn_quadtank_railgun_fire_rocket_flux";
	players = level.players;
	while(isdefined(projectile) && isdefined(projectile.origin))
	{
		if(isdefined(players[0]) && isdefined(players[0].origin))
		{
			projectileDistance = DistanceSquared(projectile.origin, players[0].origin);
			if(projectileDistance <= Distance * Distance)
			{
				projectile playsound(alais);
				return;
			}
		}
		wait(0.2);
	}
}

