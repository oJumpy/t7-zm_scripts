#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\challenges_shared;
#using scripts\shared\spawner_shared;
#using scripts\zm\_bb;
#using scripts\zm\_challenges;
#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_weapons;

#namespace globallogic_actor;

/*
	Name: Callback_ActorSpawned
	Namespace: globallogic_actor
	Checksum: 0x991275DA
	Offset: 0x2D8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function Callback_ActorSpawned(spawner)
{
	self thread spawner::run_spawn_functions();
	bb::function_a96d8fec(self, spawner);
}

/*
	Name: Callback_ActorDamage
	Namespace: globallogic_actor
	Checksum: 0x92AA45A9
	Offset: 0x320
	Size: 0xABB
	Parameters: 15
	Flags: None
*/
function Callback_ActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal)
{
	if(game["state"] == "postgame")
	{
		return;
	}
	if(self.team == "spectator")
	{
		return;
	}
	if(isdefined(eAttacker) && isPlayer(eAttacker) && isdefined(eAttacker.canDoCombat) && !eAttacker.canDoCombat)
	{
		return;
	}
	self.iDFlags = iDFlags;
	self.iDFlagsTime = GetTime();
	eAttacker = globallogic_player::figureOutAttacker(eAttacker);
	if(!isdefined(vDir))
	{
		iDFlags = iDFlags | level.IDFLAGS_NO_KNOCKBACK;
	}
	friendly = 0;
	if(self.health == self.maxhealth || !isdefined(self.Attackers))
	{
		self.Attackers = [];
		self.attackerData = [];
		self.attackerDamage = [];
	}
	if(globallogic_utils::isHeadShot(weapon, sHitLoc, sMeansOfDeath, eInflictor))
	{
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	if(level.onlyHeadShots)
	{
		if(sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET")
		{
			return;
		}
		else if(sMeansOfDeath == "MOD_HEAD_SHOT")
		{
			iDamage = 150;
		}
	}
	if(isdefined(self.aiOverrideDamage))
	{
		for(index = 0; index < self.aiOverrideDamage.size; index++)
		{
			damageCallback = self.aiOverrideDamage[index];
			iDamage = self [[damageCallback]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex);
		}
		if(iDamage < 1)
		{
			return;
		}
		iDamage = Int(iDamage + 0.5);
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
		if(isPlayer(eAttacker))
		{
			eAttacker.pers["participation"]++;
		}
		prevHealthRatio = self.health / self.maxhealth;
		if(level.teambased && isPlayer(eAttacker) && self != eAttacker && self.team == eAttacker.pers["team"])
		{
			if(level.friendlyfire == 0)
			{
				return;
			}
			else if(level.friendlyfire == 1)
			{
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self globallogic_player::giveAttackerAndInflictorOwnerAssist(eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon);
				self finishActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);
			}
			else if(level.friendlyfire == 2)
			{
				return;
			}
			else if(level.friendlyfire == 3)
			{
				iDamage = Int(iDamage * 0.5);
				if(iDamage < 1)
				{
					iDamage = 1;
				}
				self.lastDamageWasFromEnemy = 0;
				self globallogic_player::giveAttackerAndInflictorOwnerAssist(eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon);
				self finishActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);
			}
			friendly = 1;
		}
		else if(isdefined(eAttacker) && isdefined(self.script_owner) && eAttacker == self.script_owner && !level.hardcoreMode)
		{
			return;
		}
		if(isdefined(eAttacker) && isdefined(self.script_owner) && isdefined(eAttacker.script_owner) && eAttacker.script_owner == self.script_owner)
		{
			return;
		}
		if(iDamage < 1)
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
		self.lastDamageWasFromEnemy = isdefined(eAttacker) && eAttacker != self;
		self globallogic_player::giveAttackerAndInflictorOwnerAssist(eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon);
		self finishActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);
		if(isdefined(eAttacker) && eAttacker != self)
		{
			if(!isdefined(eInflictor) || !isai(eInflictor))
			{
				if(iDamage > 0 && sHitLoc !== "riotshield")
				{
					eAttacker thread damagefeedback::updateDamageFeedback(sMeansOfDeath, eInflictor);
				}
			}
		}
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			println("Dev Block strings are not supported" + self GetEntityNumber() + "Dev Block strings are not supported" + self.health + "Dev Block strings are not supported" + eAttacker.clientid + "Dev Block strings are not supported" + isPlayer(eInflictor) + "Dev Block strings are not supported" + iDamage + sHitLoc + "Dev Block strings are not supported" + boneIndex + "Dev Block strings are not supported");
		}
	#/
	if(1)
	{
		lpselfnum = self GetEntityNumber();
		lpselfteam = self.team;
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
		logPrint("AD;" + lpselfnum + ";" + lpselfteam + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "
");
	}
}

/*
	Name: Callback_ActorKilled
	Namespace: globallogic_actor
	Checksum: 0x538EBCB2
	Offset: 0xDE8
	Size: 0x1AB
	Parameters: 8
	Flags: None
*/
function Callback_ActorKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isai(attacker) && isdefined(attacker.script_owner))
	{
		if(attacker.script_owner.team != self.team)
		{
			attacker = attacker.script_owner;
		}
	}
	if(attacker.classname == "script_vehicle" && isdefined(attacker.owner))
	{
		attacker = attacker.owner;
	}
	if(isdefined(attacker) && isPlayer(attacker))
	{
		if(!level.teambased || self.team != attacker.pers["team"])
		{
			level.globalKillstreaksDestroyed++;
			attacker addweaponstat(GetWeapon("dogs"), "destroyed", 1);
			attacker challenges::killedDog();
		}
	}
}

/*
	Name: Callback_ActorCloned
	Namespace: globallogic_actor
	Checksum: 0x399F3FB7
	Offset: 0xFA0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function Callback_ActorCloned(original)
{
	DestructServerUtils::CopyDestructState(original, self);
	GibServerUtils::CopyGibState(original, self);
}

