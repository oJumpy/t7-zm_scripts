#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace empgrenade;

/*
	Name: __init__sytem__
	Namespace: empgrenade
	Checksum: 0x25CE774F
	Offset: 0x1E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("empgrenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: empgrenade
	Checksum: 0xFED6FE21
	Offset: 0x228
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "empd", 1, 1, "int");
	clientfield::register("toplayer", "empd_monitor_distance", 1, 1, "int");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: empgrenade
	Checksum: 0x81639193
	Offset: 0x2B8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	self thread monitorEMPGrenade();
	self thread begin_other_grenade_tracking();
}

/*
	Name: monitorEMPGrenade
	Namespace: empgrenade
	Checksum: 0xADC8CA9D
	Offset: 0x300
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function monitorEMPGrenade()
{
	self endon("disconnect");
	self endon("death");
	self endon("killEMPMonitor");
	self.empEndTime = 0;
	while(1)
	{
		self waittill("emp_grenaded", attacker, explosionPoint);
		if(!isalive(self) || self hasPerk("specialty_immuneemp"))
		{
			continue;
		}
		hurtVictim = 1;
		hurtAttacker = 0;
		/#
			Assert(isdefined(self.team));
		#/
		if(level.teambased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
		{
			friendlyfire = [[level.figure_out_friendly_fire]](self);
			if(friendlyfire == 0)
			{
				continue;
			}
			else if(friendlyfire == 1)
			{
				hurtAttacker = 0;
				hurtVictim = 1;
			}
			else if(friendlyfire == 2)
			{
				hurtVictim = 0;
				hurtAttacker = 1;
			}
			else if(friendlyfire == 3)
			{
				hurtAttacker = 1;
				hurtVictim = 1;
			}
		}
		if(hurtVictim && isdefined(self))
		{
			self thread applyEMP(attacker, explosionPoint);
		}
		if(hurtAttacker && isdefined(attacker))
		{
			attacker thread applyEMP(attacker, explosionPoint);
		}
	}
}

/*
	Name: applyEMP
	Namespace: empgrenade
	Checksum: 0x4D8B6D58
	Offset: 0x530
	Size: 0x333
	Parameters: 2
	Flags: None
*/
function applyEMP(attacker, explosionPoint)
{
	self notify("applyEMP");
	self endon("applyEMP");
	self endon("disconnect");
	self endon("death");
	wait(0.05);
	if(!(isdefined(self) && isalive(self)))
	{
		return;
	}
	if(self == attacker)
	{
		currentEmpDuration = 1;
	}
	else
	{
		distanceToExplosion = Distance(self.origin, explosionPoint);
		Ratio = 1 - distanceToExplosion / 425;
		currentEmpDuration = 3 + 3 * Ratio;
	}
	if(isdefined(self.empEndTime))
	{
		emp_time_left_ms = self.empEndTime - GetTime();
		if(emp_time_left_ms > currentEmpDuration * 1000)
		{
			self.empDuration = emp_time_left_ms / 1000;
		}
		else
		{
			self.empDuration = currentEmpDuration;
		}
	}
	else
	{
		self.empDuration = currentEmpDuration;
	}
	self.empGrenaded = 1;
	self shellshock("emp_shock", 1);
	self clientfield::set_to_player("empd", 1);
	self.empStartTime = GetTime();
	self.empEndTime = self.empStartTime + self.empDuration * 1000;
	self.empedBy = attacker;
	ShutdownEmpRebootIndicatorMenu();
	empRebootMenu = self OpenLUIMenu("EmpRebootIndicator");
	self SetLUIMenuData(empRebootMenu, "endTime", Int(self.empEndTime));
	self SetLUIMenuData(empRebootMenu, "startTime", Int(self.empStartTime));
	self thread empRumbleLoop(0.75);
	self setEMPJammed(1);
	self thread empGrenadeDeathWaiter();
	self thread empGrenadeCleanseWaiter();
	if(self.empDuration > 0)
	{
		wait(self.empDuration);
	}
	if(isdefined(self))
	{
		self notify("empGrenadeTimedOut");
		self checkToTurnOffEmp();
	}
}

/*
	Name: empGrenadeDeathWaiter
	Namespace: empgrenade
	Checksum: 0x2543D7C5
	Offset: 0x870
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function empGrenadeDeathWaiter()
{
	self notify("empGrenadeDeathWaiter");
	self endon("empGrenadeDeathWaiter");
	self endon("empGrenadeTimedOut");
	self waittill("death");
	if(isdefined(self))
	{
		self checkToTurnOffEmp();
	}
}

/*
	Name: empGrenadeCleanseWaiter
	Namespace: empgrenade
	Checksum: 0x5157EF
	Offset: 0x8D0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function empGrenadeCleanseWaiter()
{
	self notify("empGrenadeCleanseWaiter");
	self endon("empGrenadeCleanseWaiter");
	self endon("empGrenadeTimedOut");
	self waittill("gadget_cleanse_on");
	if(isdefined(self))
	{
		self checkToTurnOffEmp();
	}
}

/*
	Name: checkToTurnOffEmp
	Namespace: empgrenade
	Checksum: 0x2B0A4B1B
	Offset: 0x930
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function checkToTurnOffEmp()
{
	if(isdefined(self))
	{
		self.empGrenaded = 0;
		ShutdownEmpRebootIndicatorMenu();
		if(self killstreaks::EMP_IsEMPd())
		{
			return;
		}
		self setEMPJammed(0);
		self clientfield::set_to_player("empd", 0);
	}
}

/*
	Name: ShutdownEmpRebootIndicatorMenu
	Namespace: empgrenade
	Checksum: 0x191FB63
	Offset: 0x9B8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function ShutdownEmpRebootIndicatorMenu()
{
	empRebootMenu = self GetLuiMenu("EmpRebootIndicator");
	if(isdefined(empRebootMenu))
	{
		self CloseLUIMenu(empRebootMenu);
	}
}

/*
	Name: empRumbleLoop
	Namespace: empgrenade
	Checksum: 0x76D92163
	Offset: 0xA18
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function empRumbleLoop(duration)
{
	self endon("emp_rumble_loop");
	self notify("emp_rumble_loop");
	goalTime = GetTime() + duration * 1000;
	while(GetTime() < goalTime)
	{
		self PlayRumbleOnEntity("damage_heavy");
		wait(0.05);
	}
}

/*
	Name: watchEMPExplosion
	Namespace: empgrenade
	Checksum: 0x17D960F1
	Offset: 0xA90
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function watchEMPExplosion(owner, weapon)
{
	owner endon("disconnect");
	owner endon("team_changed");
	self endon("trophy_destroyed");
	owner addweaponstat(weapon, "used", 1);
	self waittill("explode", origin, surface);
	level empExplosionDamageEnts(owner, weapon, origin, 425, 1);
}

/*
	Name: empExplosionDamageEnts
	Namespace: empgrenade
	Checksum: 0x7FBABB98
	Offset: 0xB48
	Size: 0x131
	Parameters: 5
	Flags: None
*/
function empExplosionDamageEnts(owner, weapon, origin, radius, damagePlayers)
{
	ents = GetDamageableEntArray(origin, radius);
	if(!isdefined(damagePlayers))
	{
		damagePlayers = 1;
	}
	foreach(ent in ents)
	{
		if(!damagePlayers && isPlayer(ent))
		{
			continue;
		}
		ent DoDamage(1, origin, owner, owner, "none", "MOD_GRENADE_SPLASH", 0, weapon);
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: empgrenade
	Checksum: 0x37E9F679
	Offset: 0xC88
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function begin_other_grenade_tracking()
{
	self endon("death");
	self endon("disconnect");
	self notify("empTrackingStart");
	self endon("empTrackingStart");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon, cookTime);
		if(grenade util::isHacked())
		{
			continue;
		}
		if(weapon.isEmp)
		{
			grenade thread watchEMPExplosion(self, weapon);
		}
	}
}

