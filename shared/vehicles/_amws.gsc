#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_heatseekingmissile;

#namespace amws;

/*
	Name: __init__sytem__
	Namespace: amws
	Checksum: 0x8B599A3E
	Offset: 0x3D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("amws", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: amws
	Checksum: 0x2E17A590
	Offset: 0x418
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("amws", &amws_initialize);
}

/*
	Name: amws_initialize
	Namespace: amws
	Checksum: 0x376B90E4
	Offset: 0x450
	Size: 0x273
	Parameters: 0
	Flags: None
*/
function amws_initialize()
{
	self useanimtree(-1);
	Target_Set(self, (0, 0, 0));
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist(40);
	self.fovcosine = 0;
	self.fovcosinebusy = 0.574;
	self.vehAirCraftCollisionEnabled = 1;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 999999;
	self.goalHeight = 512;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.delete_on_death = 0;
	self.overrideVehicleDamage = &drone_callback_damage;
	self thread vehicle_ai::nudge_collision();
	self.Cobra = 0;
	self ASMRequestSubstate("locomotion@movement");
	self.variant = "light_weight";
	if(IsSubStr(self.vehicleType, "pamws"))
	{
		self.variant = "armored";
	}
	self vehicle_ai::Cooldown("cobra_up", 10);
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: amws
	Checksum: 0x53E6F4DF
	Offset: 0x6D0
	Size: 0x30B
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("driving").update_func = &state_driving_update;
	self vehicle_ai::get_state_callbacks("emped").update_func = &state_emped_update;
	self vehicle_ai::get_state_callbacks("surge").update_func = &state_surge_update;
	self vehicle_ai::get_state_callbacks("surge").exit_func = &state_surge_exit;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::add_state("stationary", &state_stationary_enter, &state_stationary_update, &state_stationary_exit);
	vehicle_ai::add_interrupt_connection("stationary", "scripted", "enter_scripted");
	vehicle_ai::add_interrupt_connection("stationary", "emped", "emped");
	vehicle_ai::add_interrupt_connection("stationary", "off", "shut_off");
	vehicle_ai::add_interrupt_connection("stationary", "driving", "enter_vehicle");
	vehicle_ai::add_interrupt_connection("stationary", "pain", "pain");
	vehicle_ai::add_interrupt_connection("stationary", "surge", "surge");
	vehicle_ai::add_utility_connection("stationary", "combat");
	vehicle_ai::add_utility_connection("combat", "stationary");
	self vehicle_ai::StartInitialState("combat");
}

/*
	Name: state_death_update
	Namespace: amws
	Checksum: 0xD370A46B
	Offset: 0x9E8
	Size: 0xAB
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
	if(death_type === "suicide_crash")
	{
		self death_suicide_crash(params);
	}
	self vehicle_ai::defaultstate_death_update(params);
}

/*
	Name: death_suicide_crash
	Namespace: amws
	Checksum: 0x37EEF556
	Offset: 0xAA0
	Size: 0x1DB
	Parameters: 1
	Flags: None
*/
function death_suicide_crash(params)
{
	self endon("death");
	goaldir = AnglesToForward(self.angles);
	goalDist = RandomFloatRange(300, 400);
	goalpos = self.origin + goaldir * goalDist;
	self SetMaxSpeedScale(880 / self GetMaxSpeed(1));
	self SetMaxAccelerationScale(50 / self GetDefaultAcceleration());
	self SetSpeed(self.settings.surgespeedmultiplier * self.settings.defaultMoveSpeed);
	self SetVehGoalPos(goalpos, 0);
	self util::waittill_any_timeout(3.5, "near_goal", "veh_collision");
	self SetMaxSpeedScale(0.1);
	self SetSpeed(0.1);
	self vehicle_ai::ClearAllMovement();
	self vehicle_ai::ClearAllLookingAndTargeting();
	self.death_type = "gibbed";
}

/*
	Name: state_driving_update
	Namespace: amws
	Checksum: 0x1C59F4B2
	Offset: 0xC88
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function state_driving_update(params)
{
	self endon("change_state");
	self endon("death");
	driver = self GetSeatOccupant(0);
	if(isPlayer(driver))
	{
		while(1)
		{
			driver endon("disconnect");
			driver util::waittill_vehicle_move_up_button_pressed();
			if(self.Cobra === 0)
			{
				self cobra_raise();
			}
			else
			{
				self cobra_retract();
			}
		}
	}
}

/*
	Name: cobra_raise
	Namespace: amws
	Checksum: 0xFB2BB9EE
	Offset: 0xD58
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function cobra_raise()
{
	self.Cobra = 1;
	if(isdefined(self.settings.cobra_fx_1) && isdefined(self.settings.cobra_tag_1))
	{
		PlayFXOnTag(self.settings.cobra_fx_1, self, self.settings.cobra_tag_1);
	}
	self ASMRequestSubstate("cobra@stationary");
	self vehicle_ai::waittill_asm_complete("cobra@stationary", 4);
	self LaserOn();
}

/*
	Name: cobra_retract
	Namespace: amws
	Checksum: 0xD09BB11B
	Offset: 0xE28
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function cobra_retract()
{
	self.Cobra = 0;
	self LaserOff();
	self notify("disable_lens_flare");
	self ASMRequestSubstate("locomotion@movement");
	self vehicle_ai::waittill_asm_complete("locomotion@movement", 4);
}

/*
	Name: state_emped_update
	Namespace: amws
	Checksum: 0x712CC0D1
	Offset: 0xEA0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function state_emped_update(params)
{
	self endon("death");
	self endon("change_state");
	angles = self GetTagAngles("tag_turret");
	self SetTurretTargetRelativeAngles((45, angles[1] - self.angles[1], 0), 0);
	angles = self GetTagAngles("tag_gunner_turret1");
	self SetTurretTargetRelativeAngles((45, angles[1] - self.angles[1], 0), 1);
	self vehicle_ai::defaultstate_emped_update(params);
}

/*
	Name: state_surge_update
	Namespace: amws
	Checksum: 0x5BBFEE9E
	Offset: 0xFA0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function state_surge_update(params)
{
	self endon("change_state");
	self endon("death");
	self SetMaxSpeedScale(880 / self GetMaxSpeed(1));
	self SetMaxAccelerationScale(50 / self GetDefaultAcceleration());
	self vehicle_ai::defaultstate_surge_update(params);
}

/*
	Name: state_surge_exit
	Namespace: amws
	Checksum: 0x7E2FC0E5
	Offset: 0x1040
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function state_surge_exit(params)
{
	self SetMaxSpeedScale(0.1);
	self SetSpeed(0.1);
	self vehicle_ai::ClearAllMovement();
	self vehicle_ai::ClearAllLookingAndTargeting();
}

/*
	Name: state_stationary_enter
	Namespace: amws
	Checksum: 0xA9D0AEC7
	Offset: 0x10C8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function state_stationary_enter(params)
{
	vehicle_ai::ClearAllLookingAndTargeting();
	vehicle_ai::ClearAllMovement();
	self SetBrake(1);
}

/*
	Name: state_stationary_update
	Namespace: amws
	Checksum: 0x3CF7ADEB
	Offset: 0x1118
	Size: 0x49B
	Parameters: 1
	Flags: None
*/
function state_stationary_update(params)
{
	self endon("death");
	self endon("change_state");
	self notify("stop_rocket_firing_thread");
	vehicle_ai::ClearAllLookingAndTargeting();
	vehicle_ai::ClearAllMovement();
	wait(1);
	self cobra_raise();
	minTime = 6;
	maxTime = 12;
	transformWhenEnemyClose = RandomInt(100) < 25;
	losePatientTime = 3 + RandomFloat(2);
	startTime = GetTime();
	vehicle_ai::Cooldown("rocket", 2);
	evade_now = 0;
	while(1)
	{
		evade_now = self.settings.evade_enemies_locked_on_me === 1 && self.locked_on || (self.settings.evade_enemies_locking_on_me === 1 && self.locking_on);
		if(vehicle_ai::TimeSince(startTime) > maxTime || evade_now)
		{
			break;
		}
		if(isdefined(self.enemy))
		{
			distSqr = DistanceSquared(self.enemy.origin, self.origin);
			if(vehicle_ai::TimeSince(startTime) > minTime)
			{
				if(transformWhenEnemyClose && distSqr < 200 * 200)
				{
					break;
				}
				if(!self vehseenrecently(self.enemy, losePatientTime))
				{
					break;
				}
			}
			if(self VehCanSee(self.enemy))
			{
				if(distSqr < self.settings.engagementDistMax * 3 * self.settings.engagementDistMax * 3)
				{
					self SetTurretTargetEnt(self.enemy, VectorScale((0, 0, -1), 5));
					self setGunnerTargetEnt(self.enemy, VectorScale((0, 0, -1), 5), 0);
					if(vehicle_ai::IsCooldownReady("rocket") && self.turretontarget && self.gib_rocket !== 1)
					{
						self thread FireRocketLauncher(self.enemy);
						vehicle_ai::Cooldown("rocket", self.settings.rocketcooldown);
					}
					weapon = self SeatGetWeapon(1);
					if(weapon.name == "none")
					{
						idx = 0;
					}
					else
					{
						idx = 1;
					}
					self vehicle_ai::fire_for_time(1, idx, self.enemy, 0.5);
				}
				else
				{
					break;
				}
			}
		}
		wait(0.1);
	}
	self notify("stop_rocket_firing_thread");
	vehicle_ai::ClearAllLookingAndTargeting();
	vehicle_ai::ClearAllMovement();
	if(evade_now)
	{
		self wait_evasion_reaction_time();
	}
	else
	{
		self state_stationary_update_wait(0.5);
	}
	self cobra_retract();
	self vehicle_ai::evaluate_connections();
}

/*
	Name: state_stationary_update_wait
	Namespace: amws
	Checksum: 0x8584797
	Offset: 0x15C0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function state_stationary_update_wait(wait_time)
{
	waittill_weapon_lock_or_timeout(wait_time);
}

/*
	Name: state_stationary_exit
	Namespace: amws
	Checksum: 0xCC1AF1CE
	Offset: 0x15F0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function state_stationary_exit(params)
{
	vehicle_ai::ClearAllLookingAndTargeting();
	vehicle_ai::ClearAllMovement();
	self SetBrake(0);
	self vehicle_ai::Cooldown("cobra_up", 10);
}

/*
	Name: state_combat_enter
	Namespace: amws
	Checksum: 0x87029BF
	Offset: 0x1660
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function state_combat_enter(params)
{
	self thread turretFireUpdate();
}

/*
	Name: is_ai_using_minigun
	Namespace: amws
	Checksum: 0x7D36AD10
	Offset: 0x1690
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function is_ai_using_minigun()
{
	if(isdefined(self.settings.ai_uses_minigun))
	{
	}
	else
	{
	}
	return 1;
}

/*
	Name: turretFireUpdate
	Namespace: amws
	Checksum: 0x4599F70C
	Offset: 0x16C8
	Size: 0x31F
	Parameters: 0
	Flags: None
*/
function turretFireUpdate()
{
	weapon = self SeatGetWeapon(1);
	if(weapon.name == "none")
	{
		return;
	}
	self endon("death");
	self endon("change_state");
	self SetOnTargetAngle(7);
	self SetOnTargetAngle(7, 0);
	while(1)
	{
		if(self.avoid_shooting_owner === 1 && isdefined(self.owner))
		{
			if(self vehicle_ai::owner_in_line_of_fire())
			{
				wait(0.5);
				continue;
			}
		}
		if(isdefined(self.enemy) && self VehCanSee(self.enemy) && DistanceSquared(self.enemy.origin, self.origin) < self.settings.engagementDistMax * 3 * self.settings.engagementDistMax * 3)
		{
			self setGunnerTargetEnt(self.enemy, (0, 0, 0), 0);
			if(self is_ai_using_minigun())
			{
				self SetTurretSpinning(1);
			}
			wait(0.05);
			if(!self.gunner1ontarget)
			{
				wait(0.5);
			}
			if(self.gunner1ontarget)
			{
				if(isdefined(self.enemy) && self VehCanSee(self.enemy))
				{
					self vehicle_ai::fire_for_time(RandomFloatRange(self.settings.burstFireDurationMin, self.settings.burstFireDurationMax), 1, self.enemy);
				}
				if(self is_ai_using_minigun())
				{
					self SetTurretSpinning(0);
				}
				if(isdefined(self.enemy) && isai(self.enemy))
				{
					wait(RandomFloatRange(self.settings.burstFireAIDelayMin, self.settings.burstFireAIDelayMax));
				}
				else
				{
					wait(RandomFloatRange(self.settings.burstFireDelayMin, self.settings.burstFireDelayMax));
				}
			}
			else
			{
				wait(0.5);
			}
		}
		else
		{
			wait(0.4);
		}
	}
}

/*
	Name: state_combat_update
	Namespace: amws
	Checksum: 0x92373BDE
	Offset: 0x19F0
	Size: 0x74F
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
	heatseekingmissile::InitLockField(self);
	self.lock_evading = 0;
	while(self.lock_evading == 0)
	{
		self SetSpeed(self.settings.defaultMoveSpeed);
		if(isdefined(self.settings.default_move_acceleration))
		{
		}
		else
		{
		}
		self SetAcceleration(10);
		if(RandomInt(100) < 3 && vehicle_ai::IsCooldownReady("cobra_up") && self.lock_evading == 0)
		{
			if(isdefined(self.enemy) && DistanceSquared(self.enemy.origin, self.origin) > 200 * 200)
			{
				if(DistanceSquared(self.enemy.origin, self.origin) < self.settings.engagementDistMax * 2 * self.settings.engagementDistMax * 2)
				{
					self vehicle_ai::evaluate_connections();
				}
			}
		}
		if(self.settings.engage_enemies_locked_on_me === 1 && self.locked_on)
		{
			if(isdefined(self.settings.enemies_locked_on_me_threat_bias_duration))
			{
			}
			else if(isdefined(self.settings.enemies_locked_on_me_threat_bias))
			{
			}
			else
			{
			}
			self vehicle_ai::UpdatePersonalThreatBias_AttackerLockedOnToMe(5000, self.settings.enemies_locked_on_me_threat_bias);
			self.shouldGotoNewPosition = 1;
		}
		else if(self.settings.engage_enemies_locking_on_me === 1 && self.locking_on)
		{
			if(isdefined(self.settings.enemies_locking_on_me_threat_bias_duration))
			{
			}
			else if(isdefined(self.settings.enemies_locking_on_me_threat_bias))
			{
			}
			else
			{
			}
			self vehicle_ai::UpdatePersonalThreatBias_AttackerLockingOnToMe(2000, self.settings.enemies_locking_on_me_threat_bias);
			self.shouldGotoNewPosition = 1;
		}
		self.lock_evading = 0;
		if(self.settings.evade_enemies_locked_on_me === 1)
		{
			self.lock_evading = self.lock_evading | self.locked_on;
		}
		if(self.settings.evade_enemies_locking_on_me === 1)
		{
			self.lock_evading = self.lock_evading | self.locking_on;
			self.lock_evading = self.lock_evading | self.locking_on_hacking;
		}
		if(isdefined(self.inpain) && self.inpain)
		{
			wait(0.1);
		}
		else if(!isdefined(self.enemy))
		{
			should_slow_down_at_goal = 1;
			if(self.lock_evading)
			{
				self.current_pathto_pos = GetNextMovePosition_evasive(self.lock_evading);
				should_slow_down_at_goal = 0;
			}
			else
			{
				self.current_pathto_pos = GetNextMovePosition_wander();
			}
			if(isdefined(self.current_pathto_pos))
			{
				if(self SetVehGoalPos(self.current_pathto_pos, should_slow_down_at_goal, 1))
				{
					self thread path_update_interrupt_by_attacker();
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
					self notify("amws_end_interrupt_watch", self.settings.enemies_locking_on_me_threat_bias_duration, self.settings.enemies_locked_on_me_threat_bias_duration, self.settings.default_move_acceleration);
					self playsound("veh_amws_scan");
				}
			}
			self state_combat_update_wait(0.5);
		}
		else
		{
			self SetTurretTargetEnt(self.enemy);
			if(self VehCanSee(self.enemy))
			{
				self.lastTimeTargetInSight = GetTime();
			}
			if(self.shouldGotoNewPosition == 0)
			{
				if(GetTime() > lastTimeChangePosition + 1000)
				{
					self.shouldGotoNewPosition = 1;
				}
				else if(GetTime() > self.lastTimeTargetInSight + 500)
				{
					self.shouldGotoNewPosition = 1;
				}
			}
			if(self.shouldGotoNewPosition)
			{
				should_slow_down_at_goal = 1;
				if(self.lock_evading)
				{
					self.current_pathto_pos = GetNextMovePosition_evasive(self.lock_evading);
					should_slow_down_at_goal = 0;
				}
				else
				{
					self.current_pathto_pos = GetNextMovePosition_tactical(self.enemy);
				}
				if(isdefined(self.current_pathto_pos))
				{
					if(self SetVehGoalPos(self.current_pathto_pos, should_slow_down_at_goal, 1))
					{
						self thread path_update_interrupt_by_attacker();
						self thread path_update_interrupt();
						self vehicle_ai::waittill_pathing_done();
						self notify("amws_end_interrupt_watch");
					}
					if(isdefined(self.enemy) && vehicle_ai::IsCooldownReady("rocket", 0.5) && self VehCanSee(self.enemy) && self.gib_rocket !== 1)
					{
						self thread aim_and_fire_rocket_launcher(0.4);
					}
					lastTimeChangePosition = GetTime();
					self.shouldGotoNewPosition = 0;
				}
			}
			self state_combat_update_wait(0.5);
		}
	}
}

/*
	Name: aim_and_fire_rocket_launcher
	Namespace: amws
	Checksum: 0x1B0F2D31
	Offset: 0x2148
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function aim_and_fire_rocket_launcher(aim_time)
{
	self endon("death");
	self endon("change_state");
	self notify("stop_rocket_firing_thread");
	self endon("stop_rocket_firing_thread");
	if(!self.turretontarget)
	{
		wait(aim_time);
	}
	if(isdefined(self.enemy) && self.turretontarget)
	{
		vehicle_ai::Cooldown("rocket", self.settings.rocketcooldown);
		self thread FireRocketLauncher(self.enemy);
	}
}

/*
	Name: state_combat_update_wait
	Namespace: amws
	Checksum: 0xC4B60E4C
	Offset: 0x2200
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function state_combat_update_wait(wait_time)
{
	self waittill_weapon_lock_or_timeout(wait_time);
}

/*
	Name: waittill_weapon_lock_or_timeout
	Namespace: amws
	Checksum: 0x9DAF4C59
	Offset: 0x2230
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function waittill_weapon_lock_or_timeout(wait_time)
{
	if(self.lock_evade_now === 1)
	{
		perform_evasion_reaction_wait = 1;
	}
	else
	{
		locked_on_notify = undefined;
		locking_on_notify = undefined;
		reacting_to_locks = self.settings.evade_enemies_locked_on_me === 1 || self.settings.engage_enemies_locked_on_me === 1;
		reacting_to_locking = self.settings.evade_enemies_locking_on_me === 1 || self.settings.engage_enemies_locking_on_me === 1;
		previous_locked_on_to_me = self.locked_on;
		previous_locking_on_to_me = self.locking_on;
		if(reacting_to_locks)
		{
			locked_on_notify = "missle_lock";
		}
		if(reacting_to_locking)
		{
			locking_on_notify = "locking on";
		}
		self util::waittill_any_timeout(wait_time, "damage", locking_on_notify, locked_on_notify);
		locked_on_to_me_just_changed = previous_locked_on_to_me != self.locked_on && self.locked_on;
		locking_on_to_me_just_changed = previous_locking_on_to_me != self.locking_on && self.locking_on;
		perform_evasion_reaction_wait = reacting_to_locks && locked_on_to_me_just_changed || (reacting_to_locking && locking_on_to_me_just_changed);
	}
	if(perform_evasion_reaction_wait)
	{
		self wait_evasion_reaction_time();
	}
}

/*
	Name: wait_evasion_reaction_time
	Namespace: amws
	Checksum: 0x9D8515ED
	Offset: 0x2408
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function wait_evasion_reaction_time()
{
	if(isdefined(self.settings.enemy_evasion_reaction_time_max))
	{
	}
	else if(isdefined(self.settings.enemy_evasion_reaction_time_min))
	{
	}
	else
	{
	}
	wait(RandomFloatRange(0.1, self.settings.enemy_evasion_reaction_time_min));
}

/*
	Name: FireRocketLauncher
	Namespace: amws
	Checksum: 0xD51F859E
	Offset: 0x2488
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function FireRocketLauncher(enemy)
{
	self endon("death");
	self endon("change_state");
	self notify("stop_rocket_firing_thread");
	self endon("stop_rocket_firing_thread");
	if(isdefined(enemy))
	{
		self SetTurretTargetEnt(enemy);
		self util::waittill_any_timeout(1, "turret_on_target");
		if(self.variant == "armored")
		{
			vehicle_ai::fire_for_rounds(1, 0, enemy);
		}
		else
		{
			vehicle_ai::fire_for_rounds(2, 0, enemy);
		}
	}
}

/*
	Name: GetNextMovePosition_wander
	Namespace: amws
	Checksum: 0xBE426544
	Offset: 0x2560
	Size: 0x349
	Parameters: 0
	Flags: None
*/
function GetNextMovePosition_wander()
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	queryMultiplier = 1.5;
	queryResult = PositionQuery_Source_Navigation(self.origin, 80, 500 * queryMultiplier, 250, 3 * self.radius * queryMultiplier, self, self.radius * queryMultiplier);
	if(queryResult.data.size == 0)
	{
		queryResult = PositionQuery_Source_Navigation(self.origin, 36, 120, 240, self.radius, self);
	}
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	PositionQuery_Filter_InClaimedLocation(queryResult, self);
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryResult.data)
	{
		randomScore = RandomFloatRange(0, 100);
		distToOriginScore = point.distToOrigin2D * 0.2;
		if(point.inclaimedlocation)
		{
			point.score = point.score - 500;
		}
		point.score = point.score + randomScore + distToOriginScore;
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	/#
		self.debug_ai_move_to_points_considered = queryResult.data;
	#/
	if(!isdefined(best_point))
	{
		/#
			self.debug_ai_movement_type = "Dev Block strings are not supported" + queryResult.data.size + "Dev Block strings are not supported";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		return undefined;
	}
	/#
		self.debug_ai_movement_type = "Dev Block strings are not supported" + queryResult.data.size;
	#/
	/#
		self.debug_ai_move_to_point = best_point.origin;
	#/
	return best_point.origin;
}

/*
	Name: GetNextMovePosition_evasive
	Namespace: amws
	Checksum: 0xFE62B7C5
	Offset: 0x28B8
	Size: 0x899
	Parameters: 1
	Flags: None
*/
function GetNextMovePosition_evasive(client_flags)
{
	/#
		Assert(isdefined(client_flags));
	#/
	if(isdefined(self.settings.lock_evade_speed_boost))
	{
	}
	else
	{
	}
	self SetSpeed(self.settings.lock_evade_speed_boost * 2);
	if(isdefined(self.settings.default_move_acceleration))
	{
	}
	else if(isdefined(self.settings.lock_evade_acceleration_boost))
	{
	}
	else
	{
	}
	self SetAcceleration(self.settings.lock_evade_acceleration_boost * 2);
	if(isdefined(self.settings.lock_evade_point_spacing_factor))
	{
	}
	else if(isdefined(self.settings.lock_evade_dist_half_height))
	{
	}
	else if(isdefined(self.settings.lock_evade_dist_max))
	{
	}
	else if(isdefined(self.settings.lock_evade_dist_min))
	{
	}
	else
	{
	}
	queryResult = PositionQuery_Source_Navigation(self.origin, 120, self.settings.lock_evade_dist_min, self.settings.lock_evade_dist_max, self.settings.lock_evade_dist_half_height, self.settings.lock_evade_point_spacing_factor);
	PositionQuery_Filter_InClaimedLocation(queryResult, self);
	foreach(point in queryResult.data)
	{
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
	}
	remaining_lock_threats_to_evaluate = 3;
	remaining_flags_to_process = client_flags;
	for(i = 0; remaining_flags_to_process && remaining_lock_threats_to_evaluate > 0 && i < level.players.size; i++)
	{
		attacker = level.players[i];
		if(isdefined(attacker))
		{
			client_flag = 1 << attacker GetEntityNumber();
			if(client_flag & remaining_flags_to_process)
			{
				PositionQuery_Filter_Directness(queryResult, self.origin, attacker.origin);
				foreach(point in queryResult.data)
				{
					abs_directness = Abs(point.directness);
					if(abs_directness < 0.2)
					{
						/#
							if(!isdefined(point._scoreDebug))
							{
								point._scoreDebug = [];
							}
							point._scoreDebug["Dev Block strings are not supported"] = 200;
						#/
						point.score = point.score + 200;
						continue;
					}
					if(isdefined(self.settings.lock_evade_enemy_line_of_sight_directness))
					{
					}
					else if(abs_directness > 0.9)
					{
						/#
							if(!isdefined(point._scoreDebug))
							{
								point._scoreDebug = [];
							}
							point._scoreDebug["Dev Block strings are not supported"] = -101;
						#/
						point.score = point.score + -101;
					}
				}
				~point.score;
				remaining_flags_to_process = remaining_flags_to_process & client_flag;
				remaining_lock_threats_to_evaluate--;
			}
		}
	}
	PositionQuery_Filter_Directness(queryResult, self.origin, self.origin + AnglesToForward(self.angles) * 360);
	foreach(point in queryResult.data)
	{
		if(point.directness > 0.5)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = 105;
			#/
			point.score = point.score + 105;
		}
	}
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryResult.data)
	{
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self.lock_evade_now = 0;
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	/#
		self.debug_ai_move_to_points_considered = queryResult.data;
	#/
	if(!isdefined(best_point))
	{
		/#
			self.debug_ai_movement_type = "Dev Block strings are not supported" + queryResult.data.size + "Dev Block strings are not supported";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		return undefined;
	}
	/#
		self.debug_ai_movement_type = "Dev Block strings are not supported" + queryResult.data.size;
	#/
	/#
		self.debug_ai_move_to_point = best_point.origin;
	#/
	return best_point.origin;
}

/*
	Name: GetNextMovePosition_tactical
	Namespace: amws
	Checksum: 0x55B81EF9
	Offset: 0x3160
	Size: 0x919
	Parameters: 1
	Flags: None
*/
function GetNextMovePosition_tactical(enemy)
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	selfDistToTarget = Distance2D(self.origin, enemy.origin);
	goodDist = 0.5 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	tooCloseDist = 0.4 * self.settings.engagementDistMin + self.settings.engagementDistMax;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedDirectness = 0;
	if(selfDistToTarget > goodDist)
	{
		preferedDirectness = mapfloat(closeDist, farDist, 0, 1, selfDistToTarget);
	}
	else
	{
		preferedDirectness = mapfloat(tooCloseDist * 0.4, tooCloseDist, -1, -0.6, selfDistToTarget);
	}
	preferedDistAwayFromOrigin = 300;
	randomness = 30;
	queryResult = PositionQuery_Source_Navigation(self.origin, 80, 500 * queryMultiplier, 250, 2 * self.radius * queryMultiplier, self, 1 * self.radius * queryMultiplier);
	PositionQuery_Filter_Directness(queryResult, self.origin, enemy.origin);
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
		diffToPreferedDirectness = Abs(point.directness - preferedDirectness);
		directnessScore = mapfloat(0, 1, 100, 0, diffToPreferedDirectness);
		if(diffToPreferedDirectness > 0.2)
		{
			directnessScore = directnessScore - 200;
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
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = mapfloat(0, preferedDistAwayFromOrigin, 0, 100, point.distToOrigin2D);
		#/
		point.score = point.score + mapfloat(0, preferedDistAwayFromOrigin, 0, 100, point.distToOrigin2D);
		targetDistScore = 0;
		if(point.targetDist < tooCloseDist)
		{
			targetDistScore = targetDistScore - 200;
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
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = targetDistScore;
		#/
		point.score = point.score + targetDistScore;
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = RandomFloatRange(0, randomness);
		#/
		point.score = point.score + RandomFloatRange(0, randomness);
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
		/#
			self.debug_ai_movement_type = "Dev Block strings are not supported" + queryResult.data.size + "Dev Block strings are not supported";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		return undefined;
	}
	/#
		if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
		{
			recordLine(self.origin, best_point.origin, (0.3, 1, 0));
			recordLine(self.origin, enemy.origin, (1, 0, 0.4));
		}
	#/
	/#
		self.debug_ai_movement_type = "Dev Block strings are not supported" + queryResult.data.size;
	#/
	/#
		self.debug_ai_move_to_point = best_point.origin;
	#/
	return best_point.origin;
}

/*
	Name: path_update_interrupt_by_attacker
	Namespace: amws
	Checksum: 0x6373A229
	Offset: 0x3A88
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function path_update_interrupt_by_attacker()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	self endon("amws_end_interrupt_watch");
	self util::waittill_any("locking on", "missile_lock", "damage");
	if(self.locked_on || self.locking_on)
	{
		/#
			self.debug_ai_move_to_points_considered = [];
		#/
		/#
			self.debug_ai_movement_type = "Dev Block strings are not supported";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		self ClearVehGoalPos();
		self.lock_evade_now = 1;
	}
	self notify("near_goal");
}

/*
	Name: path_update_interrupt
	Namespace: amws
	Checksum: 0x4CF3B255
	Offset: 0x3B70
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function path_update_interrupt()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	self endon("amws_end_interrupt_watch");
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
			if(self VehCanSee(self.enemy) && Distance2DSquared(self.origin, self.enemy.origin) < 0.4 * self.settings.engagementDistMin + self.settings.engagementDistMax * 0.4 * self.settings.engagementDistMin + self.settings.engagementDistMax)
			{
				self notify("near_goal");
			}
			if(vehicle_ai::IsCooldownReady("rocket") && vehicle_ai::IsCooldownReady("rocket_launcher_check"))
			{
				vehicle_ai::Cooldown("rocket_launcher_check", 2.5);
				self notify("near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: gib
	Namespace: amws
	Checksum: 0x17B123D9
	Offset: 0x3D48
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function gib(attacker)
{
	if(self.gibbed !== 1)
	{
		self vehicle::do_gib_dynents();
		self.gibbed = 1;
		self.death_type = "suicide_crash";
		self kill(self.origin + VectorScale((0, 0, 1), 10), attacker);
	}
}

/*
	Name: drone_callback_damage
	Namespace: amws
	Checksum: 0x65936A9B
	Offset: 0x3DD8
	Size: 0xD3
	Parameters: 15
	Flags: None
*/
function drone_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	iDamage = vehicle_ai::shared_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
	return iDamage;
}

