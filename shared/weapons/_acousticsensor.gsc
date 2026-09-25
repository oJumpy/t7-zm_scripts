#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace acousticsensor;

/*
	Name: init_shared
	Namespace: acousticsensor
	Checksum: 0xEFFDB9B0
	Offset: 0x280
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["acousticsensor_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["acousticsensor_friendly_light"] = "_t6/misc/fx_equip_light_green";
	callback::add_weapon_watcher(&createAcousticSensorWatcher);
}

/*
	Name: createAcousticSensorWatcher
	Namespace: acousticsensor
	Checksum: 0xA24F1A71
	Offset: 0x2E8
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function createAcousticSensorWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher("acoustic_sensor", self.team);
	watcher.onSpawn = &onSpawnAcousticSensor;
	watcher.onDetonateCallback = &acousticSensorDetonate;
	watcher.stun = &weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.hackable = 1;
	watcher.onDamage = &watchAcousticSensorDamage;
}

/*
	Name: onSpawnAcousticSensor
	Namespace: acousticsensor
	Checksum: 0x8B5D3BD7
	Offset: 0x3B0
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function onSpawnAcousticSensor(watcher, player)
{
	self endon("death");
	self thread weaponobjects::onSpawnUseWeaponObject(watcher, player);
	player.acousticsensor = self;
	self SetOwner(player);
	self SetTeam(player.team);
	self.owner = player;
	self PlayLoopSound("fly_acoustic_sensor_lp");
	if(!self util::isHacked())
	{
		player addweaponstat(self.weapon, "used", 1);
	}
	self thread WatchShutdown(player, self.origin);
}

/*
	Name: acousticSensorDetonate
	Namespace: acousticsensor
	Checksum: 0xE3739FA
	Offset: 0x4C8
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function acousticSensorDetonate(attacker, weapon, target)
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
	playsoundatposition("dst_equipment_destroy", self.origin);
	self destroyEnt();
}

/*
	Name: destroyEnt
	Namespace: acousticsensor
	Checksum: 0x8135D255
	Offset: 0x5D8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function destroyEnt()
{
	self delete();
}

/*
	Name: WatchShutdown
	Namespace: acousticsensor
	Checksum: 0x9939EFBF
	Offset: 0x600
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function WatchShutdown(player, origin)
{
	self util::waittill_any("death", "hacked");
	if(isdefined(player))
	{
		player.acousticsensor = undefined;
	}
}

/*
	Name: watchAcousticSensorDamage
	Namespace: acousticsensor
	Checksum: 0x8499F6B3
	Offset: 0x660
	Size: 0x389
	Parameters: 1
	Flags: None
*/
function watchAcousticSensorDamage(watcher)
{
	self endon("death");
	self endon("hacked");
	self SetCanDamage(1);
	damageMax = 100;
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
		if(level.teambased && attacker.team == self.owner.team && attacker != self.owner)
		{
			continue;
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
		if(isPlayer(attacker) && level.teambased && isdefined(attacker.team) && self.owner.team == attacker.team && attacker != self.owner)
		{
			continue;
		}
		if(type == "MOD_MELEE" || weapon.isEmp)
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

