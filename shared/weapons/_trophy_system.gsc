#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

#namespace trophy_system;

/*
	Name: init_shared
	Namespace: trophy_system
	Checksum: 0x534F85DF
	Offset: 0x3F0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.trophyLongFlashFX = "weapon/fx_trophy_flash";
	level.trophydetonationfx = "weapon/fx_trophy_detonation";
	level.fx_trophy_radius_indicator = "weapon/fx_trophy_radius_indicator";
	trophyDeployAnim = %o_trophy_deploy;
	trophySpinAnim = %o_trophy_spin;
	level thread register();
	callback::on_spawned(&createTrophySystemWatcher);
}

/*
	Name: register
	Namespace: trophy_system
	Checksum: 0xC0DB9C85
	Offset: 0x498
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("missile", "trophy_system_state", 1, 2, "int");
	clientfield::register("scriptmover", "trophy_system_state", 1, 2, "int");
}

/*
	Name: createTrophySystemWatcher
	Namespace: trophy_system
	Checksum: 0x28C00D1D
	Offset: 0x508
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function createTrophySystemWatcher()
{
	if(level.gametype == "infect" && self.team == game["attackers"])
	{
		return;
	}
	watcher = self weaponobjects::createUseWeaponObjectWatcher("trophy_system", self.team);
	watcher.onDetonateCallback = &trophySystemDetonate;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.ownerGetsAssist = 1;
	watcher.ignoreDirection = 1;
	watcher.activationDelay = 0.1;
	watcher.headicon = 0;
	watcher.enemyDestroy = 1;
	watcher.onSpawn = &onTrophySystemSpawn;
	watcher.onDamage = &watchTrophySystemDamage;
	watcher.onDestroyed = &onTrophySystemSmashed;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
}

/*
	Name: onTrophySystemSpawn
	Namespace: trophy_system
	Checksum: 0x7607893B
	Offset: 0x6B0
	Size: 0x27B
	Parameters: 2
	Flags: None
*/
function onTrophySystemSpawn(watcher, player)
{
	player endon("death");
	player endon("disconnect");
	level endon("game_ended");
	self endon("death");
	self useanimtree(-1);
	self weaponobjects::onSpawnUseWeaponObject(watcher, player);
	self.trophySystemStationary = 0;
	moveState = self util::waitTillRollingOrNotMoving();
	if(moveState == "rolling")
	{
		self SetAnim(%o_trophy_deploy, 1);
		self clientfield::set("trophy_system_state", 1);
		self util::waitTillNotMoving();
	}
	self.trophySystemStationary = 1;
	player addweaponstat(self.weapon, "used", 1);
	self.ammo = player ammo_get(self.weapon);
	self thread trophyActive(player);
	self thread trophyWatchHack();
	self SetAnim(%o_trophy_deploy, 0);
	self SetAnim(%o_trophy_spin, 1);
	self clientfield::set("trophy_system_state", 2);
	self playsound("wpn_trophy_deploy_start");
	self PlayLoopSound("wpn_trophy_spin", 0.25);
	self setReconModelDeployed();
}

/*
	Name: setReconModelDeployed
	Namespace: trophy_system
	Checksum: 0xB05C3F98
	Offset: 0x938
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function setReconModelDeployed()
{
	if(isdefined(self.reconModelEntity))
	{
		self.reconModelEntity clientfield::set("trophy_system_state", 2);
	}
}

/*
	Name: trophyWatchHack
	Namespace: trophy_system
	Checksum: 0x17509010
	Offset: 0x978
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function trophyWatchHack()
{
	self endon("death");
	self waittill("hacked", player);
	self clientfield::set("trophy_system_state", 0);
}

/*
	Name: onTrophySystemSmashed
	Namespace: trophy_system
	Checksum: 0xFCBD519B
	Offset: 0x9C8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function onTrophySystemSmashed(attacker)
{
	playFX(level._effect["tacticalInsertionFizzle"], self.origin);
	self playsound("dst_trophy_smash");
	if(isdefined(level.playEquipmentDestroyedOnPlayer))
	{
		self.owner [[level.playEquipmentDestroyedOnPlayer]]();
	}
	if(isdefined(attacker) && self.owner util::IsEnemyPlayer(attacker))
	{
		attacker challenges::destroyedEquipment();
		scoreevents::processScoreEvent("destroyed_trophy_system", attacker, self.owner);
	}
	self delete();
}

/*
	Name: trophyActive
	Namespace: trophy_system
	Checksum: 0xE6CCF268
	Offset: 0xAD0
	Size: 0x379
	Parameters: 1
	Flags: None
*/
function trophyActive(owner)
{
	owner endon("disconnect");
	self endon("death");
	self endon("hacked");
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(level.MissileEntities.size < 1 || isdefined(self.disabled))
		{
			wait(0.05);
			continue;
		}
		for(index = 0; index < level.MissileEntities.size; index++)
		{
			wait(0.05);
			if(!isdefined(self))
			{
				return;
			}
			grenade = level.MissileEntities[index];
			if(!isdefined(grenade))
			{
				continue;
			}
			if(grenade == self)
			{
				continue;
			}
			if(!grenade.weapon.destroyableByTrophySystem)
			{
				continue;
			}
			switch(grenade.model)
			{
				case "t6_wpn_grenade_supply_projectile":
				{
					continue;
				}
			}
			if(grenade.weapon == self.weapon)
			{
				if(self.trophySystemStationary == 0 && grenade.trophySystemStationary == 1)
				{
					continue;
				}
			}
			if(!isdefined(grenade.owner))
			{
				grenade.owner = GetMissileOwner(grenade);
			}
			if(isdefined(grenade.owner))
			{
				if(level.teambased)
				{
					if(grenade.owner.team == owner.team)
					{
						continue;
					}
				}
				else if(grenade.owner == owner)
				{
					continue;
				}
				grenadeDistanceSquared = DistanceSquared(grenade.origin, self.origin);
				if(grenadeDistanceSquared < 262144)
				{
					if(BulletTracePassed(grenade.origin, self.origin + VectorScale((0, 0, 1), 29), 0, self, grenade, 0, 1))
					{
						playFX(level.trophyLongFlashFX, self.origin + VectorScale((0, 0, 1), 15), grenade.origin - self.origin, anglesToUp(self.angles));
						owner thread projectileExplode(grenade, self);
						index--;
						self playsound("wpn_trophy_alert");
						if(GetDvarInt("player_sustainAmmo") == 0)
						{
							self.ammo--;
							if(self.ammo <= 0)
							{
								self thread trophySystemDetonate();
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: projectileExplode
	Namespace: trophy_system
	Checksum: 0xCB25FEB4
	Offset: 0xE58
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function projectileExplode(projectile, trophy)
{
	self endon("death");
	projPosition = projectile.origin;
	playFX(level.trophydetonationfx, projPosition);
	projectile notify("trophy_destroyed");
	trophy RadiusDamage(projPosition, 128, 105, 10, self);
	scoreevents::processScoreEvent("trophy_defense", self);
	self challenges::trophy_defense(projPosition, 512);
	if(self util::is_item_purchased("trophy_system"))
	{
		self AddPlayerStat("destroy_explosive_with_trophy", 1);
	}
	self addweaponstat(trophy.weapon, "CombatRecordStat", 1);
	projectile delete();
}

/*
	Name: trophyDestroyTacInsert
	Namespace: trophy_system
	Checksum: 0x63381435
	Offset: 0xFB0
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function trophyDestroyTacInsert(tacInsert, trophy)
{
	self endon("death");
	tacPos = tacInsert.origin;
	playFX(level.trophydetonationfx, tacInsert.origin);
	tacInsert thread tacticalinsertion::tacticalInsertionDestroyedByTrophySystem(self, trophy);
	trophy RadiusDamage(tacPos, 128, 105, 10, self);
	scoreevents::processScoreEvent("trophy_defense", self);
	if(self util::is_item_purchased("trophy_system"))
	{
		self AddPlayerStat("destroy_explosive_with_trophy", 1);
	}
	self addweaponstat(trophy.weapon, "CombatRecordStat", 1);
}

/*
	Name: trophySystemDetonate
	Namespace: trophy_system
	Checksum: 0x507A48CF
	Offset: 0x10E8
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function trophySystemDetonate(attacker, weapon, target)
{
	if(!isdefined(weapon) || !weapon.isEmp)
	{
		playFX(level._equipment_explode_fx_lg, self.origin);
	}
	if(isdefined(attacker) && self.owner util::IsEnemyPlayer(attacker))
	{
		attacker challenges::destroyedEquipment(weapon);
		scoreevents::processScoreEvent("destroyed_trophy_system", attacker, self.owner, weapon);
	}
	playsoundatposition("exp_trophy_system", self.origin);
	self delete();
}

/*
	Name: watchTrophySystemDamage
	Namespace: trophy_system
	Checksum: 0xEF86E522
	Offset: 0x11F8
	Size: 0x371
	Parameters: 1
	Flags: None
*/
function watchTrophySystemDamage(watcher)
{
	self endon("death");
	self endon("hacked");
	self SetCanDamage(1);
	damageMax = 20;
	if(!self util::isHacked())
	{
		self.damageTaken = 0;
	}
	self.maxhealth = 10000;
	self.health = self.maxhealth;
	self setmaxhealth(self.maxhealth);
	attacker = undefined;
	while(1)
	{
		self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags);
		attacker = self [[level.figure_out_attacker]](attacker);
		if(!isPlayer(attacker))
		{
			continue;
		}
		if(level.teambased)
		{
			if(!level.hardcoreMode && self.owner.team == attacker.pers["team"] && self.owner != attacker)
			{
				continue;
			}
		}
		if(watcher.stunTime > 0 && weapon.doStun)
		{
			self thread weaponobjects::stunStart(watcher, watcher.stunTime);
		}
		if(weapon.doDamageFeedback)
		{
			if(level.teambased && self.owner.team != attacker.team)
			{
				if(damagefeedback::doDamageFeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
			else if(!level.teambased && self.owner != attacker)
			{
				if(damagefeedback::doDamageFeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
		}
		if(type == "MOD_MELEE" || weapon.isEmp || weapon.destroysEquipment)
		{
			self.damageTaken = damageMax;
		}
		else
		{
			self.damageTaken = self.damageTaken + damage;
		}
		if(self.damageTaken >= damageMax)
		{
			watcher thread weaponobjects::waitAndDetonate(self, 0.05, attacker, weapon);
			return;
		}
	}
}

/*
	Name: ammo_scavenger
	Namespace: trophy_system
	Checksum: 0x4BFD03AD
	Offset: 0x1578
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function ammo_scavenger(weapon)
{
	self ammo_reset();
}

/*
	Name: ammo_reset
	Namespace: trophy_system
	Checksum: 0x8690777A
	Offset: 0x15A8
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function ammo_reset()
{
	self._trophy_system_ammo1 = undefined;
	self._trophy_system_ammo2 = undefined;
}

/*
	Name: ammo_get
	Namespace: trophy_system
	Checksum: 0x8CC2A621
	Offset: 0x15C8
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function ammo_get(weapon)
{
	totalAmmo = weapon.ammoCountEquipment;
	if(isdefined(self._trophy_system_ammo1) && !self util::isHacked())
	{
		totalAmmo = self._trophy_system_ammo1;
		self._trophy_system_ammo1 = undefined;
		if(isdefined(self._trophy_system_ammo2))
		{
			self._trophy_system_ammo1 = self._trophy_system_ammo2;
			self._trophy_system_ammo2 = undefined;
		}
	}
	return totalAmmo;
}

/*
	Name: ammo_weapon_pickup
	Namespace: trophy_system
	Checksum: 0x93AA7869
	Offset: 0x1668
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function ammo_weapon_pickup(ammo)
{
	if(isdefined(ammo))
	{
		if(isdefined(self._trophy_system_ammo1))
		{
			self._trophy_system_ammo2 = self._trophy_system_ammo1;
			self._trophy_system_ammo1 = ammo;
		}
		else
		{
			self._trophy_system_ammo1 = ammo;
		}
	}
}

/*
	Name: ammo_weapon_hacked
	Namespace: trophy_system
	Checksum: 0x3FA6DE87
	Offset: 0x16C0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function ammo_weapon_hacked(ammo)
{
	self ammo_weapon_pickup(ammo);
}

