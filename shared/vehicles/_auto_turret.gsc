#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace auto_turret;

/*
	Name: __init__sytem__
	Namespace: auto_turret
	Checksum: 0xB99D1DAF
	Offset: 0x380
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("auto_turret", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: auto_turret
	Checksum: 0x52836A5
	Offset: 0x3C0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("auto_turret", &turret_initialze);
}

/*
	Name: turret_initialze
	Namespace: auto_turret
	Checksum: 0x2E56BA89
	Offset: 0x3F8
	Size: 0x25B
	Parameters: 0
	Flags: None
*/
function turret_initialze()
{
	self.health = self.healthdefault;
	if(isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	else
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", "artillerysettings");
	}
	sightfov = self.settings.sightfov;
	if(!isdefined(sightfov))
	{
		sightfov = 0;
	}
	self.fovcosine = cos(sightfov - 0.1);
	self.fovcosinebusy = cos(sightfov - 0.1);
	if(self.settings.disconnectpaths === 1)
	{
		self disconnectpaths();
	}
	if(self.settings.ignoreme === 1)
	{
		self.ignoreme = 1;
	}
	if(self.settings.LaserOn === 1)
	{
		self LaserOn();
	}
	if(self.settings.disablefiring !== 1)
	{
		self EnableAimAssist();
	}
	else
	{
		self.noCybercom = 1;
	}
	self thread turret::track_lens_flare();
	self.overrideVehicleDamage = &turretCallback_VehicleDamage;
	self.allowFriendlyFireDamageOverride = &turretAllowFriendlyFireDamage;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	self.ignoreFireFly = 1;
	self.ignoreDecoy = 1;
	self vehicle_ai::InitThreatBias();
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: auto_turret
	Checksum: 0x86CA40F3
	Offset: 0x660
	Size: 0x30B
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("combat").exit_func = &state_combat_exit;
	self vehicle_ai::get_state_callbacks("off").enter_func = &state_off_enter;
	self vehicle_ai::get_state_callbacks("off").exit_func = &state_off_exit;
	self vehicle_ai::get_state_callbacks("emped").enter_func = &state_emped_enter;
	self vehicle_ai::get_state_callbacks("emped").update_func = &state_emped_update;
	self vehicle_ai::get_state_callbacks("emped").exit_func = &state_emped_exit;
	self vehicle_ai::add_state("unaware", undefined, &state_unaware_update, undefined);
	vehicle_ai::add_interrupt_connection("unaware", "scripted", "enter_scripted");
	vehicle_ai::add_interrupt_connection("unaware", "emped", "emped");
	vehicle_ai::add_interrupt_connection("unaware", "off", "shut_off");
	vehicle_ai::add_interrupt_connection("unaware", "driving", "enter_vehicle");
	vehicle_ai::add_interrupt_connection("unaware", "pain", "pain");
	vehicle_ai::add_utility_connection("unaware", "combat", &should_switch_to_combat);
	vehicle_ai::add_utility_connection("combat", "unaware", &should_switch_to_unaware);
	vehicle_ai::StartInitialState("unaware");
}

/*
	Name: state_death_update
	Namespace: auto_turret
	Checksum: 0xB45631D2
	Offset: 0x978
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	owner = self GetVehicleOwner();
	if(isdefined(owner))
	{
		self waittill("exit_vehicle");
	}
	self SetTurretSpinning(0);
	self turret::toggle_lensflare(0);
	params.death_type = "default";
	self thread turret_idle_sound_stop();
	self playsound("veh_sentry_turret_dmg_hit");
	self.turretRotScale = 2;
	self rest_turret(params.resting_pitch);
	self vehicle_ai::defaultstate_death_update(params);
}

/*
	Name: should_switch_to_unaware
	Namespace: auto_turret
	Checksum: 0x6731B2CF
	Offset: 0xA90
	Size: 0x57
	Parameters: 3
	Flags: None
*/
function should_switch_to_unaware(current_state, to_state, connection)
{
	if(!isdefined(self.enemy) || !self vehseenrecently(self.enemy, 1.5))
	{
		return 100;
	}
	return 0;
}

/*
	Name: state_unaware_update
	Namespace: auto_turret
	Checksum: 0xCF7C0E7A
	Offset: 0xAF0
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function state_unaware_update(params)
{
	self endon("death");
	self endon("change_state");
	turret_left = 1;
	relativeAngle = 0;
	self thread turret_idle_sound();
	self playsound("mpl_turret_startup");
	self ClearTargetEntity();
	while(1)
	{
		rotScale = self.settings.scanning_speedscale;
		if(!isdefined(rotScale))
		{
			rotScale = 0.01;
		}
		self.turretRotScale = rotScale;
		scanning_arc = self.settings.scanning_arc;
		if(!isdefined(scanning_arc))
		{
			scanning_arc = 0;
		}
		limits = self GetTurretLimitsYaw();
		scanning_arc = min(scanning_arc, limits[0] - 0.1);
		scanning_arc = min(scanning_arc, limits[1] - 0.1);
		if(scanning_arc > 179)
		{
			if(self.turretontarget)
			{
				relativeAngle = relativeAngle + 90;
				if(relativeAngle > 180)
				{
					relativeAngle = relativeAngle - 360;
				}
			}
			scanning_arc = relativeAngle;
		}
		else if(self.turretontarget)
		{
			turret_left = !turret_left;
		}
		if(!turret_left)
		{
			scanning_arc = scanning_arc * -1;
		}
		scanning_pitch = self.settings.scanning_pitch;
		if(!isdefined(scanning_pitch))
		{
			scanning_pitch = 0;
		}
		self SetTurretTargetRelativeAngles((scanning_pitch, scanning_arc, 0));
		self vehicle_ai::evaluate_connections();
		wait(0.5);
	}
}

/*
	Name: should_switch_to_combat
	Namespace: auto_turret
	Checksum: 0x525F8355
	Offset: 0xD78
	Size: 0x6D
	Parameters: 3
	Flags: None
*/
function should_switch_to_combat(current_state, to_state, connection)
{
	if(isdefined(self.enemy) && isalive(self.enemy) && self VehCanSee(self.enemy))
	{
		return 100;
	}
	return 0;
}

/*
	Name: state_combat_update
	Namespace: auto_turret
	Checksum: 0x74DD4153
	Offset: 0xDF0
	Size: 0x357
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("death");
	self endon("change_state");
	if(isdefined(self.enemy))
	{
		sentry_turret_alert_sound();
		wait(0.5);
	}
	while(1)
	{
		if(isdefined(self.enemy) && self VehCanSee(self.enemy))
		{
			self.turretRotScale = 1;
			if(isdefined(self.enemy) && self HasPart("tag_minigun_spin"))
			{
				self SetTurretTargetEnt(self.enemy);
				self SetTurretSpinning(1);
				wait(0.5);
			}
			for(i = 0; i < 3; i++)
			{
				if(isdefined(self.enemy) && isalive(self.enemy) && self VehCanSee(self.enemy))
				{
					self SetTurretTargetEnt(self.enemy);
					wait(0.1);
					waitTime = RandomFloatRange(0.4, 1.5);
					if(self.settings.disablefiring !== 1)
					{
						self sentry_turret_fire_for_time(waitTime, self.enemy);
					}
					else
					{
						wait(waitTime);
					}
				}
				if(isdefined(self.enemy) && isPlayer(self.enemy))
				{
					wait(RandomFloatRange(0.3, 0.6));
					continue;
				}
				wait(RandomFloatRange(0.3, 0.6) * 2);
			}
			self SetTurretSpinning(0);
			if(isdefined(self.enemy) && isalive(self.enemy) && self VehCanSee(self.enemy))
			{
				if(isPlayer(self.enemy))
				{
					wait(RandomFloatRange(0.5, 1.3));
				}
				else
				{
					wait(RandomFloatRange(0.5, 1.3) * 2);
				}
			}
		}
		self vehicle_ai::evaluate_connections();
		wait(0.5);
	}
}

/*
	Name: state_combat_exit
	Namespace: auto_turret
	Checksum: 0x327F244
	Offset: 0x1150
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function state_combat_exit(params)
{
	self SetTurretSpinning(0);
}

/*
	Name: sentry_turret_fire_for_time
	Namespace: auto_turret
	Checksum: 0xB8A1785B
	Offset: 0x1180
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function sentry_turret_fire_for_time(totalFireTime, enemy)
{
	self endon("death");
	self endon("change_state");
	sentry_turret_alert_sound();
	wait(0.1);
	weapon = self SeatGetWeapon(0);
	fireTime = weapon.fireTime;
	time = 0;
	is_minigun = 0;
	if(IsSubStr(weapon.name, "minigun"))
	{
		is_minigun = 1;
		self SetTurretSpinning(1);
		wait(0.5);
	}
	while(time < totalFireTime)
	{
		self FireWeapon(0, enemy);
		wait(fireTime);
		time = time + fireTime;
	}
	if(is_minigun)
	{
		self SetTurretSpinning(0);
	}
}

/*
	Name: state_off_enter
	Namespace: auto_turret
	Checksum: 0x20072808
	Offset: 0x12E8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function state_off_enter(params)
{
	self vehicle_ai::defaultstate_off_enter(params);
	self.turretRotScale = 0.5;
	self rest_turret(params.resting_pitch);
}

/*
	Name: state_off_exit
	Namespace: auto_turret
	Checksum: 0xF7DE4D69
	Offset: 0x1348
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function state_off_exit(params)
{
	self vehicle_ai::defaultstate_off_exit(params);
	self.turretRotScale = 1;
	self playsound("mpl_turret_startup");
}

/*
	Name: rest_turret
	Namespace: auto_turret
	Checksum: 0xF80E3876
	Offset: 0x13A8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function rest_turret(resting_pitch)
{
	if(!isdefined(resting_pitch))
	{
		resting_pitch = self.settings.resting_pitch;
	}
	if(!isdefined(resting_pitch))
	{
		resting_pitch = 0;
	}
	angles = self GetTagAngles("tag_turret") - self.angles;
	self SetTurretTargetRelativeAngles((resting_pitch, angles[1], 0));
}

/*
	Name: state_emped_enter
	Namespace: auto_turret
	Checksum: 0xF16681BC
	Offset: 0x1450
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function state_emped_enter(params)
{
	self vehicle_ai::defaultstate_emped_enter(params);
	playsoundatposition("veh_sentry_turret_emp_down", self.origin);
	self.turretRotScale = 0.5;
	self rest_turret(params.resting_pitch);
	params.LaserOn = IsLaserOn(self);
	self LaserOff();
	self vehicle::lights_off();
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
	Name: state_emped_update
	Namespace: auto_turret
	Checksum: 0x6FB30BBB
	Offset: 0x15C0
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function state_emped_update(params)
{
	self endon("death");
	self endon("change_state");
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
	self.abnormal_status.emped = 0;
	self vehicle::toggle_emp_fx(0);
	self vehicle_ai::emp_startup_fx();
	self rest_turret(0);
	wait(1);
	self vehicle_ai::evaluate_connections();
}

/*
	Name: state_emped_exit
	Namespace: auto_turret
	Checksum: 0x37681F44
	Offset: 0x1718
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function state_emped_exit(params)
{
	self vehicle_ai::defaultstate_emped_exit(params);
	self.turretRotScale = 1;
	self playsound("mpl_turret_startup");
}

/*
	Name: state_scripted_update
	Namespace: auto_turret
	Checksum: 0x675D70FD
	Offset: 0x1778
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function state_scripted_update(params)
{
	self.turretRotScale = 1;
}

/*
	Name: turretAllowFriendlyFireDamage
	Namespace: auto_turret
	Checksum: 0x50CD8A70
	Offset: 0x1798
	Size: 0x4F
	Parameters: 4
	Flags: None
*/
function turretAllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon)
{
	if(isdefined(eAttacker) && isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_EXPLOSIVE")
	{
		return 1;
	}
	return 0;
}

/*
	Name: turretCallback_VehicleDamage
	Namespace: auto_turret
	Checksum: 0xCF0B9240
	Offset: 0x17F0
	Size: 0xD3
	Parameters: 15
	Flags: None
*/
function turretCallback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	iDamage = vehicle_ai::shared_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
	return iDamage;
}

/*
	Name: sentry_turret_alert_sound
	Namespace: auto_turret
	Checksum: 0x783AB026
	Offset: 0x18D0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function sentry_turret_alert_sound()
{
	self playsound("veh_turret_alert");
}

/*
	Name: turret_idle_sound
	Namespace: auto_turret
	Checksum: 0x447553A
	Offset: 0x1900
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function turret_idle_sound()
{
	if(!isdefined(self.sndloop_ent))
	{
		self.sndloop_ent = spawn("script_origin", self.origin);
		self.sndloop_ent LinkTo(self);
		self.sndloop_ent PlayLoopSound("veh_turret_idle");
	}
}

/*
	Name: turret_idle_sound_stop
	Namespace: auto_turret
	Checksum: 0xD66F029D
	Offset: 0x1980
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function turret_idle_sound_stop()
{
	self endon("death");
	if(isdefined(self.sndloop_ent))
	{
		self.sndloop_ent StopLoopSound(0.5);
		wait(2);
		self.sndloop_ent delete();
	}
}

