#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_decoy;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

#namespace sensor_grenade;

/*
	Name: init_shared
	Namespace: sensor_grenade
	Checksum: 0x2411EF02
	Offset: 0x2D8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.isplayerTrackedFunc = &isPlayerTracked;
	callback::add_weapon_watcher(&createSensorGrenadeWatcher);
}

/*
	Name: createSensorGrenadeWatcher
	Namespace: sensor_grenade
	Checksum: 0x18F9A9E5
	Offset: 0x320
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function createSensorGrenadeWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher("sensor_grenade", self.team);
	watcher.headicon = 0;
	watcher.onSpawn = &onSpawnSensorGrenade;
	watcher.onDetonateCallback = &sensorGrenadeDestroyed;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 0;
	watcher.onDamage = &watchsensorGrenadeDamage;
	watcher.enemyDestroy = 1;
}

/*
	Name: onSpawnSensorGrenade
	Namespace: sensor_grenade
	Checksum: 0x2E9313F0
	Offset: 0x3F8
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function onSpawnSensorGrenade(watcher, player)
{
	self endon("death");
	self thread weaponobjects::onSpawnUseWeaponObject(watcher, player);
	self SetOwner(player);
	self SetTeam(player.team);
	self.owner = player;
	self PlayLoopSound("wpn_sensor_nade_lp");
	self hacker_tool::registerWithHackerTool(level.equipmentHackerToolRadius, level.equipmentHackerToolTimeMs);
	player addweaponstat(self.weapon, "used", 1);
	self thread watchForStationary(player);
	self thread watchForExplode(player);
	self thread watch_for_decoys(player);
}

/*
	Name: watchForStationary
	Namespace: sensor_grenade
	Checksum: 0x8D1C2086
	Offset: 0x538
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function watchForStationary(owner)
{
	self endon("death");
	self endon("hacked");
	self endon("explode");
	owner endon("death");
	owner endon("disconnect");
	self waittill("stationary");
	checkForTracking(self.origin);
}

/*
	Name: watchForExplode
	Namespace: sensor_grenade
	Checksum: 0x2EA8088D
	Offset: 0x5B0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function watchForExplode(owner)
{
	self endon("hacked");
	self endon("delete");
	owner endon("death");
	owner endon("disconnect");
	self waittill("explode", origin);
	checkForTracking(origin + (0, 0, 1));
}

/*
	Name: checkForTracking
	Namespace: sensor_grenade
	Checksum: 0x5B0E9354
	Offset: 0x630
	Size: 0x1D1
	Parameters: 1
	Flags: None
*/
function checkForTracking(origin)
{
	if(isdefined(self.owner) == 0)
	{
		return;
	}
	players = level.players;
	foreach(player in level.players)
	{
		if(player util::IsEnemyPlayer(self.owner))
		{
			if(!player hasPerk("specialty_nomotionsensor") && (!player hasPerk("specialty_sengrenjammer") && player clientfield::get("sg_jammer_active")))
			{
				if(DistanceSquared(player.origin, origin) < 562500)
				{
					trace = bullettrace(origin, player.origin + VectorScale((0, 0, 1), 12), 0, player);
					if(trace["fraction"] == 1)
					{
						self.owner trackSensorGrenadeVictim(player);
					}
				}
			}
		}
	}
}

/*
	Name: trackSensorGrenadeVictim
	Namespace: sensor_grenade
	Checksum: 0x8C6709B6
	Offset: 0x810
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function trackSensorGrenadeVictim(victim)
{
	if(!isdefined(self.sensorGrenadeData))
	{
		self.sensorGrenadeData = [];
	}
	if(!isdefined(self.sensorGrenadeData[victim.clientid]))
	{
		self.sensorGrenadeData[victim.clientid] = GetTime();
	}
}

/*
	Name: isPlayerTracked
	Namespace: sensor_grenade
	Checksum: 0x398E9F90
	Offset: 0x878
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function isPlayerTracked(player, time)
{
	playerTracked = 0;
	if(isdefined(self.sensorGrenadeData) && isdefined(self.sensorGrenadeData[player.clientid]))
	{
		if(self.sensorGrenadeData[player.clientid] + 10000 > time)
		{
			playerTracked = 1;
		}
	}
	return playerTracked;
}

/*
	Name: sensorGrenadeDestroyed
	Namespace: sensor_grenade
	Checksum: 0x28FF607B
	Offset: 0x908
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function sensorGrenadeDestroyed(attacker, weapon, target)
{
	if(!isdefined(weapon) || !weapon.isEmp)
	{
		playFX(level._equipment_explode_fx, self.origin);
	}
	if(isdefined(attacker))
	{
		if(self.owner util::IsEnemyPlayer(attacker))
		{
			attacker challenges::destroyedEquipment(weapon);
			scoreevents::processScoreEvent("destroyed_motion_sensor", attacker, self.owner, weapon);
		}
	}
	playsoundatposition("wpn_sensor_nade_explo", self.origin);
	self delete();
}

/*
	Name: watchsensorGrenadeDamage
	Namespace: sensor_grenade
	Checksum: 0xD2D17739
	Offset: 0xA18
	Size: 0x359
	Parameters: 1
	Flags: None
*/
function watchsensorGrenadeDamage(watcher)
{
	self endon("death");
	self endon("hacked");
	self SetCanDamage(1);
	damageMax = 1;
	if(!self util::isHacked())
	{
		self.damageTaken = 0;
	}
	while(1)
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;
		self waittill("damage", damage, attacker, direction, point, type, tagName, modelName, partName, weapon, iDFlags);
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			continue;
		}
		if(level.teambased && isPlayer(attacker))
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
			watcher thread weaponobjects::waitAndDetonate(self, 0, attacker, weapon);
			return;
		}
	}
}

/*
	Name: watch_for_decoys
	Namespace: sensor_grenade
	Checksum: 0x1D7938FD
	Offset: 0xD80
	Size: 0x141
	Parameters: 1
	Flags: None
*/
function watch_for_decoys(owner)
{
	self waittill("stationary");
	players = level.players;
	foreach(player in level.players)
	{
		if(player util::IsEnemyPlayer(self.owner))
		{
			if(isalive(player) && player hasPerk("specialty_decoy"))
			{
				if(DistanceSquared(player.origin, self.origin) < 57600)
				{
					player thread watch_decoy(self);
				}
			}
		}
	}
}

/*
	Name: get_decoy_spawn_loc
	Namespace: sensor_grenade
	Checksum: 0x3A67BFA
	Offset: 0xED0
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function get_decoy_spawn_loc()
{
	return self.origin - 240 * AnglesToForward(self.angles);
}

/*
	Name: watch_decoy
	Namespace: sensor_grenade
	Checksum: 0x2B8DA758
	Offset: 0xF00
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function watch_decoy(sensor_grenade)
{
	origin = self get_decoy_spawn_loc();
	decoy_grenade = sys::spawn("script_model", origin);
	decoy_grenade.angles = -1 * self.angles;
	wait(0.05);
	decoy_grenade.initial_velocity = -1 * self GetVelocity();
	decoy_grenade thread decoy::simulate_weapon_fire(self);
	wait(15);
	decoy_grenade notify("done");
	decoy_grenade notify("death_before_explode");
	decoy_grenade delete();
}

