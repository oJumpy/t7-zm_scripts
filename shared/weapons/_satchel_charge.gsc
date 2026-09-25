#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace satchel_charge;

/*
	Name: init_shared
	Namespace: satchel_charge
	Checksum: 0x6F420386
	Offset: 0x2A0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["satchel_charge_enemy_light"] = "weapon/fx_c4_light_orng";
	level._effect["satchel_charge_friendly_light"] = "weapon/fx_c4_light_blue";
	callback::add_weapon_watcher(&createSatchelWatcher);
}

/*
	Name: createSatchelWatcher
	Namespace: satchel_charge
	Checksum: 0x1165C958
	Offset: 0x308
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function createSatchelWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher("satchel_charge", self.team);
	watcher.altDetonate = 1;
	watcher.watchForFire = 1;
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headicon = 0;
	watcher.onDetonateCallback = &satchelDetonate;
	watcher.onSpawn = &satchelSpawn;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.altweapon = GetWeapon("satchel_charge_detonator");
	watcher.ownerGetsAssist = 1;
	watcher.detonateStationary = 1;
	watcher.detonationDelay = GetDvarFloat("scr_satchel_detonation_delay", 0);
	watcher.detonationSound = "wpn_claymore_alert";
	watcher.proximityAlarmActivateSound = "uin_c4_enemy_detection_alert";
	watcher.immunespecialty = "specialty_immunetriggerc4";
}

/*
	Name: satchelDetonate
	Namespace: satchel_charge
	Checksum: 0xBFCA25A
	Offset: 0x4D8
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function satchelDetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isValid)
	{
		if(isdefined(attacker))
		{
			if(self.owner util::IsEnemyPlayer(attacker))
			{
				attacker challenges::destroyedExplosive(weapon);
				scoreevents::processScoreEvent("destroyed_c4", attacker, self.owner, weapon);
			}
		}
	}
	weaponobjects::weaponDetonate(attacker, weapon);
}

/*
	Name: satchelSpawn
	Namespace: satchel_charge
	Checksum: 0xC228611F
	Offset: 0x5A0
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function satchelSpawn(watcher, owner)
{
	self endon("death");
	self thread weaponobjects::onSpawnUseWeaponObject(watcher, owner);
	if(!(isdefined(self.previouslyHacked) && self.previouslyHacked))
	{
		if(isdefined(owner))
		{
			owner addweaponstat(self.weapon, "used", 1);
		}
		self PlayLoopSound("uin_c4_air_alarm_loop");
		self util::waittill_notify_or_timeout("stationary", 10);
		delayTimeSec = self.weapon.proximityalarmactivationdelay / 1000;
		if(delayTimeSec > 0)
		{
			wait(delayTimeSec);
		}
		self StopLoopSound(0.1);
	}
}

