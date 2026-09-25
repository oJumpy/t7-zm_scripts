#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_weapons;

#namespace globallogic_vehicle;

/*
	Name: Callback_VehicleSpawned
	Namespace: globallogic_vehicle
	Checksum: 0xC7E5A907
	Offset: 0x288
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function Callback_VehicleSpawned(spawner)
{
	if(isdefined(level.vehicle_main_callback))
	{
		if(isdefined(level.vehicle_main_callback[self.vehicleType]))
		{
			self thread [[level.vehicle_main_callback[self.vehicleType]]]();
		}
		else if(isdefined(self.scriptvehicletype) && isdefined(level.vehicle_main_callback[self.scriptvehicletype]))
		{
			self thread [[level.vehicle_main_callback[self.scriptvehicletype]]]();
		}
	}
	if(IsSentient(self))
	{
		self spawner::spawn_think(spawner);
	}
}

/*
	Name: Callback_VehicleDamage
	Namespace: globallogic_vehicle
	Checksum: 0x986E2BDD
	Offset: 0x350
	Size: 0xD4B
	Parameters: 15
	Flags: None
*/
function Callback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	self.iDFlags = iDFlags;
	self.iDFlagsTime = GetTime();
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isdefined(eAttacker) && isPlayer(eAttacker) && isdefined(eAttacker.canDoCombat) && !eAttacker.canDoCombat)
	{
		return;
	}
	if(!isdefined(vDir))
	{
		iDFlags = iDFlags | level.IDFLAGS_NO_KNOCKBACK;
	}
	friendly = 0;
	if(isdefined(self.maxhealth) && self.health == self.maxhealth || !isdefined(self.Attackers))
	{
		self.Attackers = [];
		self.attackerData = [];
		self.attackerDamage = [];
	}
	if(weapon == level.weaponNone && isdefined(eInflictor))
	{
		if(isdefined(eInflictor.targetname) && eInflictor.targetname == "explodable_barrel")
		{
			weapon = GetWeapon("explodable_barrel");
		}
		else if(isdefined(eInflictor.destructible_type) && IsSubStr(eInflictor.destructible_type, "vehicle_"))
		{
			weapon = GetWeapon("destructible_car");
		}
	}
	if(!iDFlags & level.IDFLAGS_NO_PROTECTION)
	{
		if(self IsVehicleImmuneToDamage(iDFlags, sMeansOfDeath, weapon))
		{
			if(isdefined(self.overrideVehicleDamage))
			{
				iDamage = self [[self.overrideVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
			}
			else if(isdefined(level.overrideVehicleDamage))
			{
				iDamage = self [[level.overrideVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
			}
			return;
		}
		if(sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_GRENADE")
		{
			iDamage = iDamage * weapon.vehicleProjectileDamageScalar;
			iDamage = Int(iDamage);
			if(iDamage == 0)
			{
				return;
			}
		}
		else if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
		{
			iDamage = iDamage * GetVehicleUnderneathSplashScalar(weapon);
			iDamage = Int(iDamage);
			if(iDamage == 0)
			{
				return;
			}
		}
		iDamage = iDamage * level.vehicleDamageScalar;
		iDamage = iDamage * self GetVehDamageMultiplier(sMeansOfDeath);
		iDamage = Int(iDamage);
		if(isPlayer(eAttacker))
		{
			eAttacker.pers["participation"]++;
		}
		if(!isdefined(self.maxhealth))
		{
			self.maxhealth = self.healthdefault;
		}
		if(isdefined(self.overrideVehicleDamage))
		{
			iDamage = self [[self.overrideVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
		}
		else if(isdefined(level.overrideVehicleDamage))
		{
			iDamage = self [[level.overrideVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
		}
		prevHealthRatio = self.health / self.maxhealth;
		if(isdefined(self.owner) && isPlayer(self.owner))
		{
			team = self.owner.pers["team"];
		}
		else
		{
			team = self vehicle::vehicle_get_occupant_team();
		}
		if(level.teambased && isPlayer(eAttacker) && team == eAttacker.pers["team"])
		{
			if(level.friendlyfire == 0)
			{
				if(!AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon))
				{
					return;
				}
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, 1);
			}
			else if(level.friendlyfire == 1)
			{
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, 0);
			}
			else if(level.friendlyfire == 2)
			{
				if(!AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon))
				{
					return;
				}
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, 1);
			}
			else if(level.friendlyfire == 3)
			{
				iDamage = Int(iDamage * 0.5);
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, 0);
			}
			friendly = 1;
		}
		else if(!level.teambased && isdefined(self.targetname) && self.targetname == "rcbomb")
		{
		}
		else if(isdefined(self.owner) && isdefined(eAttacker) && self.owner == eAttacker)
		{
			return;
		}
		if(iDamage < 1 && (!isdefined(level.bzm_worldPaused) && level.bzm_worldPaused))
		{
			iDamage = 1;
		}
		if(IsSubStr(sMeansOfDeath, "MOD_GRENADE") && isdefined(eInflictor) && isdefined(eInflictor.isCooked))
		{
			self.wasCooked = GetTime();
		}
		else
		{
			self.wasCooked = undefined;
		}
		attacker_seat = undefined;
		if(isdefined(eAttacker))
		{
			attacker_seat = self GetOccupantSeat(eAttacker);
		}
		self.lastDamageWasFromEnemy = isdefined(eAttacker) && !isdefined(attacker_seat);
		self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, 0);
		if(level.gametype == "hack" && !weapon.isEmp)
		{
			iDamage = 0;
		}
		if(isdefined(eAttacker) && eAttacker != self)
		{
			if(damagefeedback::doDamageFeedback(weapon, eInflictor))
			{
				if(iDamage > 0)
				{
					eAttacker thread damagefeedback::update(sMeansOfDeath, eInflictor);
				}
			}
		}
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			println("Dev Block strings are not supported" + self GetEntityNumber() + "Dev Block strings are not supported" + self.health + "Dev Block strings are not supported" + eAttacker.clientid + "Dev Block strings are not supported" + isPlayer(eInflictor) + "Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported" + sHitLoc);
		}
	#/
	if(1)
	{
		lpselfnum = self GetEntityNumber();
		lpselfteam = "";
		lpattackerteam = "";
		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker GetEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}
		logPrint("VD;" + lpselfnum + ";" + lpselfteam + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "
");
	}
}

/*
	Name: Callback_VehicleRadiusDamage
	Namespace: globallogic_vehicle
	Checksum: 0xF7C4AEBC
	Offset: 0x10A8
	Size: 0x5DB
	Parameters: 13
	Flags: None
*/
function Callback_VehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime)
{
	self.iDFlags = iDFlags;
	self.iDFlagsTime = GetTime();
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isdefined(eAttacker) && isPlayer(eAttacker) && isdefined(eAttacker.canDoCombat) && !eAttacker.canDoCombat)
	{
		return;
	}
	friendly = 0;
	if(!iDFlags & level.IDFLAGS_NO_PROTECTION)
	{
		if(self IsVehicleImmuneToDamage(iDFlags, sMeansOfDeath, weapon))
		{
			return;
		}
		if(isdefined(self.overrideVehicleRadiusDamage))
		{
			iDamage = self [[self.overrideVehicleRadiusDamage]](eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
		}
		else if(isdefined(level.overrideVehicleRadiusDamage))
		{
			iDamage = self [[level.overrideVehicleRadiusDamage]](eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
		}
		if(sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE")
		{
			scalar = weapon.vehicleProjectileSplashDamageScalar;
			iDamage = Int(iDamage * scalar);
			fInnerDamage = fInnerDamage * scalar;
			fOuterDamage = fOuterDamage * scalar;
			if(fInnerDamage == 0)
			{
				return;
			}
			if(iDamage < 1)
			{
				iDamage = 1;
			}
		}
		occupant_team = self vehicle::vehicle_get_occupant_team();
		if(level.teambased && isPlayer(eAttacker) && occupant_team == eAttacker.pers["team"])
		{
			if(level.friendlyfire == 0)
			{
				if(!AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon))
				{
					return;
				}
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			else if(level.friendlyfire == 1)
			{
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			else if(level.friendlyfire == 2)
			{
				if(!AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon))
				{
					return;
				}
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			else if(level.friendlyfire == 3)
			{
				iDamage = Int(iDamage * 0.5);
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			friendly = 1;
		}
		else if(iDamage < 1)
		{
			iDamage = 1;
		}
		self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
	}
}

/*
	Name: Callback_VehicleKilled
	Namespace: globallogic_vehicle
	Checksum: 0x971E7C9F
	Offset: 0x1690
	Size: 0x247
	Parameters: 8
	Flags: None
*/
function Callback_VehicleKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	params = spawnstruct();
	params.eInflictor = eInflictor;
	params.eAttacker = eAttacker;
	params.iDamage = iDamage;
	params.sMeansOfDeath = sMeansOfDeath;
	params.weapon = weapon;
	params.vDir = vDir;
	params.sHitLoc = sHitLoc;
	params.psOffsetTime = psOffsetTime;
	self.str_damagemod = sMeansOfDeath;
	self.w_damage = weapon;
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isai(eAttacker) && isdefined(eAttacker.script_owner))
	{
		if(eAttacker.script_owner.team != self.team)
		{
			eAttacker = eAttacker.script_owner;
		}
	}
	if(isdefined(eAttacker) && isdefined(eAttacker.onKill))
	{
		eAttacker [[eAttacker.onKill]](self);
	}
	if(isdefined(eInflictor))
	{
		self.damageInflictor = eInflictor;
	}
	self callback::callback("hash_acb66515", params);
	if(isdefined(self.overrideVehicleKilled))
	{
		self [[self.overrideVehicleKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
	}
}

/*
	Name: vehicleCrush
	Namespace: globallogic_vehicle
	Checksum: 0x4804548D
	Offset: 0x18E0
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function vehicleCrush()
{
	self endon("disconnect");
	if(isdefined(level._effect) && isdefined(level._effect["tanksquish"]))
	{
		playFX(level._effect["tanksquish"], self.origin + VectorScale((0, 0, 1), 30));
	}
	self playsound("chr_crunch");
}

/*
	Name: GetVehicleUnderneathSplashScalar
	Namespace: globallogic_vehicle
	Checksum: 0xC22F7914
	Offset: 0x1978
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function GetVehicleUnderneathSplashScalar(weapon)
{
	if(weapon.name == "satchel_charge")
	{
		scale = 10;
		scale = scale * 3;
	}
	else
	{
		scale = 1;
	}
	return scale;
}

/*
	Name: AllowFriendlyFireDamage
	Namespace: globallogic_vehicle
	Checksum: 0x65DB527E
	Offset: 0x19E8
	Size: 0x51
	Parameters: 4
	Flags: None
*/
function AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon)
{
	if(isdefined(self.allowFriendlyFireDamageOverride))
	{
		return [[self.allowFriendlyFireDamageOverride]](eInflictor, eAttacker, sMeansOfDeath, weapon);
	}
	return 0;
}

