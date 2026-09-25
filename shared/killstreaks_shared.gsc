#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

#namespace killstreaks;

/*
	Name: is_killstreak_weapon
	Namespace: killstreaks
	Checksum: 0xFA6BB845
	Offset: 0x2F0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function is_killstreak_weapon(weapon)
{
	if(weapon == level.weaponNone || weapon.notKillstreak)
	{
		return 0;
	}
	if(weapon.isSpecificUse || is_weapon_associated_with_killstreak(weapon))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_weapon_associated_with_killstreak
	Namespace: killstreaks
	Checksum: 0x14A0DF0C
	Offset: 0x360
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function is_weapon_associated_with_killstreak(weapon)
{
	return isdefined(level.killstreakWeapons) && isdefined(level.killstreakWeapons[weapon]);
}

/*
	Name: switch_to_last_non_killstreak_weapon
	Namespace: killstreaks
	Checksum: 0x1556F46A
	Offset: 0x390
	Size: 0x387
	Parameters: 2
	Flags: None
*/
function switch_to_last_non_killstreak_weapon(immediate, awayfromBall)
{
	ball = GetWeapon("ball");
	if(isdefined(ball) && self HasWeapon(ball) && (!isdefined(awayfromBall) && awayfromBall))
	{
		self SwitchToWeaponImmediate(ball);
		self DisableWeaponCycling();
		self disableOffhandWeapons();
	}
	else if(isdefined(self.laststand) && self.laststand)
	{
		if(isdefined(self.laststandpistol) && self HasWeapon(self.laststandpistol))
		{
			self SwitchToWeapon(self.laststandpistol);
		}
	}
	else if(isdefined(self.lastNonKillstreakWeapon) && self HasWeapon(self.lastNonKillstreakWeapon))
	{
		if(self.lastNonKillstreakWeapon.isHeroWeapon)
		{
			if(self.lastNonKillstreakWeapon.gadget_heroversion_2_0)
			{
				if(self.lastNonKillstreakWeapon.isgadget && self getammocount(self.lastNonKillstreakWeapon) > 0)
				{
					slot = self GadgetGetSlot(self.lastNonKillstreakWeapon);
					if(self ability_player::gadget_is_in_use(slot))
					{
						return self SwitchToWeapon(self.lastNonKillstreakWeapon);
					}
					else
					{
						return 1;
					}
				}
			}
			else if(self getammocount(self.lastNonKillstreakWeapon) > 0)
			{
				return self SwitchToWeapon(self.lastNonKillstreakWeapon);
			}
			if(isdefined(awayfromBall) && awayfromBall && isdefined(self.lastdroppableweapon) && self HasWeapon(self.lastdroppableweapon))
			{
				self SwitchToWeapon(self.lastdroppableweapon);
			}
			else
			{
				self SwitchToWeapon();
			}
			return 1;
		}
		else if(isdefined(immediate) && immediate)
		{
			self SwitchToWeaponImmediate(self.lastNonKillstreakWeapon);
		}
		else
		{
			self SwitchToWeapon(self.lastNonKillstreakWeapon);
		}
	}
	else if(isdefined(self.lastdroppableweapon) && self HasWeapon(self.lastdroppableweapon))
	{
		self SwitchToWeapon(self.lastdroppableweapon);
	}
	else
	{
		return 0;
	}
	return 1;
}

/*
	Name: get_killstreak_weapon
	Namespace: killstreaks
	Checksum: 0x75EBAF3C
	Offset: 0x720
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_killstreak_weapon(killstreak)
{
	if(!isdefined(killstreak))
	{
		return level.weaponNone;
	}
	/#
		Assert(isdefined(level.killstreaks[killstreak]));
	#/
	return level.killstreaks[killstreak].weapon;
}

/*
	Name: isHeldInventoryKillstreakWeapon
	Namespace: killstreaks
	Checksum: 0x5DE9E384
	Offset: 0x788
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function isHeldInventoryKillstreakWeapon(killstreakWeapon)
{
	switch(killstreakWeapon.name)
	{
		case "inventory_m32":
		case "inventory_minigun":
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: WaitForTimecheck
	Namespace: killstreaks
	Checksum: 0xBD76A1DC
	Offset: 0x7D0
	Size: 0x9F
	Parameters: 5
	Flags: None
*/
function WaitForTimecheck(duration, callback, endCondition1, endCondition2, endCondition3)
{
	self endon("hacked");
	if(isdefined(endCondition1))
	{
		self endon(endCondition1);
	}
	if(isdefined(endCondition2))
	{
		self endon(endCondition2);
	}
	if(isdefined(endCondition3))
	{
		self endon(endCondition3);
	}
	hostmigration::MigrationAwareWait(duration);
	self notify("time_check");
	self [[callback]]();
}

/*
	Name: EMP_IsEMPd
	Namespace: killstreaks
	Checksum: 0xFA99EBE9
	Offset: 0x878
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function EMP_IsEMPd()
{
	if(isdefined(level.enemyEMPActiveFunc))
	{
		return self [[level.enemyEMPActiveFunc]]();
	}
	return 0;
}

/*
	Name: WaitTillEMP
	Namespace: killstreaks
	Checksum: 0xC745D97B
	Offset: 0x8A8
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function WaitTillEMP(onEmpdCallback, arg)
{
	self endon("death");
	self endon("delete");
	self waittill("emp_deployed", attacker);
	if(isdefined(onEmpdCallback))
	{
		[[onEmpdCallback]](attacker, arg);
	}
}

/*
	Name: HasUAV
	Namespace: killstreaks
	Checksum: 0x3049658
	Offset: 0x918
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function HasUAV(team_or_entnum)
{
	return level.activeUAVs[team_or_entnum] > 0;
}

/*
	Name: HasSatellite
	Namespace: killstreaks
	Checksum: 0xFCC02B24
	Offset: 0x940
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function HasSatellite(team_or_entnum)
{
	return level.activeSatellites[team_or_entnum] > 0;
}

/*
	Name: DestroyOtherTeamsEquipment
	Namespace: killstreaks
	Checksum: 0x41F4F010
	Offset: 0x968
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function DestroyOtherTeamsEquipment(attacker, weapon)
{
	foreach(team in level.teams)
	{
		if(team == attacker.team)
		{
			continue;
		}
		DestroyEquipment(attacker, team, weapon);
		DestroyTacticalInsertions(attacker, team);
	}
	DestroyEquipment(attacker, "free", weapon);
	DestroyTacticalInsertions(attacker, "free");
}

/*
	Name: DestroyEquipment
	Namespace: killstreaks
	Checksum: 0xE4EBF8E7
	Offset: 0xA88
	Size: 0x18D
	Parameters: 3
	Flags: None
*/
function DestroyEquipment(attacker, team, weapon)
{
	for(i = 0; i < level.MissileEntities.size; i++)
	{
		item = level.MissileEntities[i];
		if(!isdefined(item.weapon))
		{
			continue;
		}
		if(!isdefined(item.owner))
		{
			continue;
		}
		if(isdefined(team) && item.owner.team != team)
		{
			continue;
		}
		else if(item.owner == attacker)
		{
			continue;
		}
		if(!item.weapon.isEquipment && (!isdefined(item.destroyedByEmp) && item.destroyedByEmp))
		{
			continue;
		}
		watcher = item.owner weaponobjects::getWatcherForWeapon(item.weapon);
		if(!isdefined(watcher))
		{
			continue;
		}
		watcher thread weaponobjects::waitAndDetonate(item, 0, attacker, weapon);
	}
}

/*
	Name: DestroyTacticalInsertions
	Namespace: killstreaks
	Checksum: 0x6141162A
	Offset: 0xC20
	Size: 0xC5
	Parameters: 2
	Flags: None
*/
function DestroyTacticalInsertions(attacker, victimTeam)
{
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(!isdefined(player.tacticalinsertion))
		{
			continue;
		}
		if(level.teambased && player.team != victimTeam)
		{
			continue;
		}
		if(attacker == player)
		{
			continue;
		}
		player.tacticalinsertion thread tacticalinsertion::fizzle();
	}
}

/*
	Name: DestroyOtherTeamsActiveVehicles
	Namespace: killstreaks
	Checksum: 0xC960BA72
	Offset: 0xCF0
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function DestroyOtherTeamsActiveVehicles(attacker, weapon)
{
	foreach(team in level.teams)
	{
		if(team == attacker.team)
		{
			continue;
		}
		DestroyActiveVehicles(attacker, team, weapon);
	}
	DestroyNeutralGameplayVehicles(attacker, weapon);
}

/*
	Name: DestroyNeutralGameplayVehicles
	Namespace: killstreaks
	Checksum: 0xA41E5E06
	Offset: 0xDD0
	Size: 0x1D1
	Parameters: 2
	Flags: None
*/
function DestroyNeutralGameplayVehicles(attacker, weapon)
{
	script_vehicles = GetEntArray("script_vehicle", "classname");
	foreach(vehicle in script_vehicles)
	{
		if(isVehicle(vehicle) && (!isdefined(vehicle.team) || vehicle.team == "neutral"))
		{
			if(isdefined(vehicle.DetonateViaEMP) && (isdefined(weapon.isEmpKillstreak) && weapon.isEmpKillstreak))
			{
				vehicle [[vehicle.DetonateViaEMP]](attacker, weapon);
			}
			if(isdefined(vehicle.archetype))
			{
				if(vehicle.archetype == "siegebot")
				{
					vehicle DoDamage(vehicle.health + 1, vehicle.origin, attacker, attacker, "", "MOD_EXPLOSIVE", 0, weapon);
				}
			}
		}
	}
}

/*
	Name: DestroyActiveVehicles
	Namespace: killstreaks
	Checksum: 0x853A25CD
	Offset: 0xFB0
	Size: 0x983
	Parameters: 3
	Flags: None
*/
function DestroyActiveVehicles(attacker, team, weapon)
{
	targets = target_getArray();
	DestroyEntities(targets, attacker, team, weapon);
	ai_tanks = GetEntArray("talon", "targetname");
	DestroyEntities(ai_tanks, attacker, team, weapon);
	remoteMissiles = GetEntArray("remote_missile", "targetname");
	DestroyEntities(remoteMissiles, attacker, team, weapon);
	remoteDrone = GetEntArray("remote_drone", "targetname");
	DestroyEntities(remoteDrone, attacker, team, weapon);
	script_vehicles = GetEntArray("script_vehicle", "classname");
	foreach(vehicle in script_vehicles)
	{
		if(isdefined(team) && vehicle.team == team && isVehicle(vehicle))
		{
			if(isdefined(vehicle.DetonateViaEMP) && (isdefined(weapon.isEmpKillstreak) && weapon.isEmpKillstreak))
			{
				vehicle [[vehicle.DetonateViaEMP]](attacker, weapon);
			}
			if(isdefined(vehicle.archetype))
			{
				if(vehicle.archetype == "raps")
				{
					vehicle raps::detonate(attacker);
					continue;
				}
				if(vehicle.archetype == "turret" || vehicle.archetype == "rcbomb" || vehicle.archetype == "wasp" || vehicle.archetype == "siegebot")
				{
					vehicle DoDamage(vehicle.health + 1, vehicle.origin, attacker, attacker, "", "MOD_EXPLOSIVE", 0, weapon);
				}
			}
		}
	}
	planeMortars = GetEntArray("plane_mortar", "targetname");
	foreach(planemortar in planeMortars)
	{
		if(isdefined(team) && isdefined(planemortar.team))
		{
			if(planemortar.team != team)
			{
				continue;
			}
		}
		else if(planemortar.owner == attacker)
		{
			continue;
		}
		planemortar notify("emp_deployed", attacker);
	}
	droneStrikes = GetEntArray("drone_strike", "targetname");
	foreach(droneStrike in droneStrikes)
	{
		if(isdefined(team) && isdefined(droneStrike.team))
		{
			if(droneStrike.team != team)
			{
				continue;
			}
		}
		else if(droneStrike.owner == attacker)
		{
			continue;
		}
		droneStrike notify("emp_deployed", attacker);
	}
	counteruavs = GetEntArray("counteruav", "targetname");
	foreach(counteruav in counteruavs)
	{
		if(isdefined(team) && isdefined(counteruav.team))
		{
			if(counteruav.team != team)
			{
				continue;
			}
		}
		else if(counteruav.owner == attacker)
		{
			continue;
		}
		counteruav notify("emp_deployed", attacker);
	}
	satellites = GetEntArray("satellite", "targetname");
	foreach(satellite in satellites)
	{
		if(isdefined(team) && isdefined(satellite.team))
		{
			if(satellite.team != team)
			{
				continue;
			}
		}
		else if(satellite.owner == attacker)
		{
			continue;
		}
		satellite notify("emp_deployed", attacker);
	}
	robots = GetAIArchetypeArray("robot");
	foreach(robot in robots)
	{
		if(robot.allowdeath !== 0 && robot.magic_bullet_shield !== 1 && isdefined(team) && robot.team == team)
		{
			if(isdefined(attacker) && (!isdefined(robot.owner) || robot.owner util::IsEnemyPlayer(attacker)))
			{
				scoreevents::processScoreEvent("destroyed_combat_robot", attacker, robot.owner, weapon);
				LUINotifyEvent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_COMBAT_ROBOT", attacker.entnum);
			}
			robot kill();
		}
	}
	if(isdefined(level.missile_swarm_owner))
	{
		if(level.missile_swarm_owner util::IsEnemyPlayer(attacker))
		{
			level.missile_swarm_owner notify("emp_destroyed_missile_swarm", attacker);
		}
	}
}

/*
	Name: DestroyEntities
	Namespace: killstreaks
	Checksum: 0xEA6A148
	Offset: 0x1940
	Size: 0x1B9
	Parameters: 4
	Flags: None
*/
function DestroyEntities(entities, attacker, team, weapon)
{
	meansOfDeath = "MOD_EXPLOSIVE";
	damage = 5000;
	direction_vec = (0, 0, 0);
	point = (0, 0, 0);
	modelName = "";
	tagName = "";
	partName = "";
	foreach(entity in entities)
	{
		if(isdefined(team) && isdefined(entity.team))
		{
			if(entity.team != team)
			{
				continue;
			}
		}
		else if(isdefined(entity.owner) && entity.owner == attacker)
		{
			continue;
		}
		entity notify("damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partName, weapon);
	}
}

