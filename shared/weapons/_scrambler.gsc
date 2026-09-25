#using scripts\codescripts\struct;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace scrambler;

/*
	Name: init_shared
	Namespace: scrambler
	Checksum: 0xD02BA2A9
	Offset: 0x238
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["scrambler_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["scrambler_friendly_light"] = "_t6/misc/fx_equip_light_green";
	level.scramblerWeapon = GetWeapon("scrambler");
	level.scramblerLength = 30;
	level.scramblerOuterRadiusSq = 1000000;
	level.scramblerInnerRadiusSq = 360000;
	clientfield::register("missile", "scrambler", 1, 1, "int");
}

/*
	Name: createScramblerWatcher
	Namespace: scrambler
	Checksum: 0xD0A3E2AE
	Offset: 0x300
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function createScramblerWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher("scrambler", self.team);
	watcher.onSpawn = &onSpawnScrambler;
	watcher.onDetonateCallback = &scramblerDetonate;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.hackable = 1;
	watcher.onDamage = &watchScramblerDamage;
}

/*
	Name: onSpawnScrambler
	Namespace: scrambler
	Checksum: 0x9768AFF
	Offset: 0x3C8
	Size: 0x121
	Parameters: 2
	Flags: None
*/
function onSpawnScrambler(watcher, player)
{
	player endon("disconnect");
	self endon("death");
	self thread weaponobjects::onSpawnUseWeaponObject(watcher, player);
	player.scrambler = self;
	self SetOwner(player);
	self SetTeam(player.team);
	self.owner = player;
	self clientfield::set("scrambler", 1);
	if(!self util::isHacked())
	{
		player addweaponstat(self.weapon, "used", 1);
	}
	self thread WatchShutdown(player);
	level notify("scrambler_spawn");
}

/*
	Name: scramblerDetonate
	Namespace: scrambler
	Checksum: 0x51214DB5
	Offset: 0x4F8
	Size: 0xD3
	Parameters: 3
	Flags: None
*/
function scramblerDetonate(attacker, weapon, target)
{
	if(!isdefined(weapon) || !weapon.isEmp)
	{
		playFX(level._equipment_explode_fx, self.origin);
	}
	if(self.owner util::IsEnemyPlayer(attacker))
	{
		attacker challenges::destroyedEquipment(weapon);
	}
	playsoundatposition("dst_equipment_destroy", self.origin);
	self delete();
}

/*
	Name: WatchShutdown
	Namespace: scrambler
	Checksum: 0x9501B7BF
	Offset: 0x5D8
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function WatchShutdown(player)
{
	self util::waittill_any("death", "hacked");
	level notify("scrambler_death");
	if(isdefined(player))
	{
		player.scrambler = undefined;
	}
}

/*
	Name: destroyEnt
	Namespace: scrambler
	Checksum: 0xE212386
	Offset: 0x640
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function destroyEnt()
{
	self delete();
}

/*
	Name: watchScramblerDamage
	Namespace: scrambler
	Checksum: 0x30E8783D
	Offset: 0x668
	Size: 0x387
	Parameters: 1
	Flags: None
*/
function watchScramblerDamage(watcher)
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
		}
	}
}

/*
	Name: ownerSameTeam
	Namespace: scrambler
	Checksum: 0x5FC454E0
	Offset: 0x9F8
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function ownerSameTeam(owner1, owner2)
{
	if(!level.teambased)
	{
		return 0;
	}
	if(!isdefined(owner1) || !isdefined(owner2))
	{
		return 0;
	}
	if(!isdefined(owner1.team) || !isdefined(owner2.team))
	{
		return 0;
	}
	return owner1.team == owner2.team;
}

/*
	Name: checkScramblerStun
	Namespace: scrambler
	Checksum: 0xAC9554B3
	Offset: 0xA88
	Size: 0x1A1
	Parameters: 0
	Flags: None
*/
function checkScramblerStun()
{
	scramblers = GetEntArray("grenade", "classname");
	if(isdefined(self.name) && self.name == "scrambler")
	{
		return 0;
	}
	for(i = 0; i < scramblers.size; i++)
	{
		scrambler = scramblers[i];
		if(!isalive(scrambler))
		{
			continue;
		}
		if(!isdefined(scrambler.name))
		{
			continue;
		}
		if(scrambler.name != "scrambler")
		{
			continue;
		}
		if(ownerSameTeam(self.owner, scrambler.owner))
		{
			continue;
		}
		flattenedSelfOrigin = (self.origin[0], self.origin[1], 0);
		flattenedscramblerOrigin = (scrambler.origin[0], scrambler.origin[1], 0);
		if(DistanceSquared(flattenedSelfOrigin, flattenedscramblerOrigin) < level.scramblerOuterRadiusSq)
		{
			return 1;
		}
	}
	return 0;
}

