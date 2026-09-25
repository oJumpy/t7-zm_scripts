#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons_shared;

#namespace weaponobjects;

/*
	Name: init_shared
	Namespace: weaponobjects
	Checksum: 0xF8BC256E
	Offset: 0xB48
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::on_start_gametype(&start_gametype);
	clientfield::register("toplayer", "proximity_alarm", 1, 2, "int");
	clientfield::register("clientuimodel", "hudItems.proximityAlarm", 1, 2, "int");
	clientfield::register("missile", "retrievable", 1, 1, "int");
	clientfield::register("scriptmover", "retrievable", 1, 1, "int");
	clientfield::register("missile", "enemyequip", 1, 2, "int");
	clientfield::register("scriptmover", "enemyequip", 1, 2, "int");
	clientfield::register("missile", "teamequip", 1, 1, "int");
	level.weaponObjectDebug = GetDvarInt("scr_weaponobject_debug", 0);
	level.supplementalWatcherObjects = [];
	/#
		level thread updateDvars();
	#/
}

/*
	Name: updateDvars
	Namespace: weaponobjects
	Checksum: 0xC3469F96
	Offset: 0xD10
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	while(1)
	{
		level.weaponObjectDebug = GetDvarInt("scr_weaponobject_debug", 0);
		wait(1);
	}
}

/*
	Name: start_gametype
	Namespace: weaponobjects
	Checksum: 0xDEEF9EEF
	Offset: 0xD50
	Size: 0x25B
	Parameters: 0
	Flags: None
*/
function start_gametype()
{
	coneangle = GetDvarInt("scr_weaponobject_coneangle", 70);
	mindist = GetDvarInt("scr_weaponobject_mindist", 20);
	gracePeriod = GetDvarFloat("scr_weaponobject_graceperiod", 0.6);
	radius = GetDvarInt("scr_weaponobject_radius", 192);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.watcherWeapons = [];
	level.watcherWeapons = getWatcherWeapons();
	level.retrievableWeapons = [];
	level.retrievableWeapons = getRetrievableWeapons();
	level.weaponobjectexplodethisframe = 0;
	if(GetDvarString("scr_deleteexplosivesonspawn") == "")
	{
		SetDvar("scr_deleteexplosivesonspawn", 1);
	}
	level.deleteExplosivesOnSpawn = GetDvarInt("scr_deleteexplosivesonspawn");
	level.claymoreFXid = "_t6/weapon/claymore/fx_claymore_laser";
	level._equipment_spark_fx = "explosions/fx_exp_equipment_lg";
	level._equipment_fizzleout_fx = "explosions/fx_exp_equipment_lg";
	level._equipment_emp_destroy_fx = "killstreaks/fx_emp_explosion_equip";
	level._equipment_explode_fx = "_t6/explosions/fx_exp_equipment";
	level._equipment_explode_fx_lg = "explosions/fx_exp_equipment_lg";
	level._effect["powerLight"] = "weapon/fx_equip_light_os";
	setUpRetrievableHintStrings();
	level.weaponobjects_hacker_trigger_width = 32;
	level.weaponobjects_hacker_trigger_height = 32;
}

/*
	Name: setUpRetrievableHintStrings
	Namespace: weaponobjects
	Checksum: 0xC7729429
	Offset: 0xFB8
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function setUpRetrievableHintStrings()
{
	createRetrievableHint("hatchet", &"MP_HATCHET_PICKUP");
	createRetrievableHint("claymore", &"MP_CLAYMORE_PICKUP");
	createRetrievableHint("bouncingbetty", &"MP_BOUNCINGBETTY_PICKUP");
	createRetrievableHint("trophy_system", &"MP_TROPHY_SYSTEM_PICKUP");
	createRetrievableHint("acoustic_sensor", &"MP_ACOUSTIC_SENSOR_PICKUP");
	createRetrievableHint("camera_spike", &"MP_CAMERA_SPIKE_PICKUP");
	createRetrievableHint("satchel_charge", &"MP_SATCHEL_CHARGE_PICKUP");
	createRetrievableHint("scrambler", &"MP_SCRAMBLER_PICKUP");
	createRetrievableHint("proximity_grenade", &"MP_SHOCK_CHARGE_PICKUP");
	createDestroyHint("trophy_system", &"MP_TROPHY_SYSTEM_DESTROY");
	createDestroyHint("sensor_grenade", &"MP_SENSOR_GRENADE_DESTROY");
	createHackerHint("claymore", &"MP_CLAYMORE_HACKING");
	createHackerHint("bouncingbetty", &"MP_BOUNCINGBETTY_HACKING");
	createHackerHint("trophy_system", &"MP_TROPHY_SYSTEM_HACKING");
	createHackerHint("acoustic_sensor", &"MP_ACOUSTIC_SENSOR_HACKING");
	createHackerHint("camera_spike", &"MP_CAMERA_SPIKE_HACKING");
	createHackerHint("satchel_charge", &"MP_SATCHEL_CHARGE_HACKING");
	createHackerHint("scrambler", &"MP_SCRAMBLER_HACKING");
}

/*
	Name: on_player_connect
	Namespace: weaponobjects
	Checksum: 0x48BC741F
	Offset: 0x1208
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	if(isdefined(level._weaponobjects_on_player_connect_override))
	{
		level thread [[level._weaponobjects_on_player_connect_override]]();
		return;
	}
	self.usedWeapons = 0;
	self.hits = 0;
}

/*
	Name: on_player_spawned
	Namespace: weaponobjects
	Checksum: 0xF39A0617
	Offset: 0x1248
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	PixBeginEvent("onPlayerSpawned");
	if(!isdefined(self.watchersInitialized))
	{
		self createBaseWatchers();
		self callback::callback_weapon_watcher();
		self createClaymoreWatcher();
		self createRCBombWatcher();
		self createQRDroneWatcher();
		self createPlayerHelicopterWatcher();
		self createHatchetWatcher();
		self createSpecialCrossbowWatcher();
		self createTactInsertWatcher();
		self hive_gun::createFireflyPodWatcher();
		self setupRetrievableWatcher();
		self thread watchWeaponObjectUsage();
		self.watchersInitialized = 1;
	}
	self resetWatchers();
	self trophy_system::ammo_reset();
	PixEndEvent();
}

/*
	Name: resetWatchers
	Namespace: weaponobjects
	Checksum: 0xF1A3AB03
	Offset: 0x13E8
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function resetWatchers()
{
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		return undefined;
	}
	team = self.team;
	foreach(watcher in self.weaponObjectWatcherArray)
	{
		resetWeaponObjectWatcher(watcher, team);
	}
}

/*
	Name: createBaseWatchers
	Namespace: weaponobjects
	Checksum: 0xDBAB33AF
	Offset: 0x14A8
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function createBaseWatchers()
{
	foreach(weapon in level.watcherWeapons)
	{
		self createWeaponObjectWatcher(weapon.name, self.team);
	}
	foreach(weapon in level.retrievableWeapons)
	{
		self createWeaponObjectWatcher(weapon.name, self.team);
	}
}

/*
	Name: setupRetrievableWatcher
	Namespace: weaponobjects
	Checksum: 0x515730F8
	Offset: 0x15D0
	Size: 0xF1
	Parameters: 0
	Flags: None
*/
function setupRetrievableWatcher()
{
	for(i = 0; i < level.retrievableWeapons.size; i++)
	{
		watcher = getWeaponObjectWatcherByWeapon(level.retrievableWeapons[i]);
		if(isdefined(watcher))
		{
			if(!isdefined(watcher.onSpawnRetrieveTriggers))
			{
				watcher.onSpawnRetrieveTriggers = &onSpawnRetrievableWeaponObject;
			}
			if(!isdefined(watcher.onDestroyed))
			{
				watcher.onDestroyed = &onDestroyed;
			}
			if(!isdefined(watcher.pickup))
			{
				watcher.pickup = &pickup;
			}
		}
	}
}

/*
	Name: createSpecialCrossbowWatcherTypes
	Namespace: weaponobjects
	Checksum: 0x5A03682
	Offset: 0x16D0
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function createSpecialCrossbowWatcherTypes(weaponName)
{
	watcher = self createUseWeaponObjectWatcher(weaponName, self.team);
	watcher.onDetonateCallback = &deleteEnt;
	watcher.onDamage = &voidOnDamage;
	if(isdefined(level.b_crossbow_bolt_destroy_on_impact) && level.b_crossbow_bolt_destroy_on_impact)
	{
		watcher.onSpawn = &onSpawnCrossbowBoltImpact;
		watcher.onSpawnRetrieveTriggers = &voidOnSpawnRetrieveTriggers;
		watcher.pickup = &voidPickUp;
	}
	else
	{
		watcher.onSpawn = &onSpawnCrossbowBolt;
		watcher.onSpawnRetrieveTriggers = &onSpawnSpecialCrossbowTrigger;
		watcher.pickup = &pickUpCrossbowBolt;
	}
}

/*
	Name: createSpecialCrossbowWatcher
	Namespace: weaponobjects
	Checksum: 0x357583BF
	Offset: 0x17F0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function createSpecialCrossbowWatcher()
{
	createSpecialCrossbowWatcherTypes("special_crossbow");
	createSpecialCrossbowWatcherTypes("special_crossbowlh");
	createSpecialCrossbowWatcherTypes("special_crossbow_dw");
	if(isdefined(level.b_create_upgraded_crossbow_watchers) && level.b_create_upgraded_crossbow_watchers)
	{
		createSpecialCrossbowWatcherTypes("special_crossbowlh_upgraded");
		createSpecialCrossbowWatcherTypes("special_crossbow_dw_upgraded");
	}
}

/*
	Name: createHatchetWatcher
	Namespace: weaponobjects
	Checksum: 0x370D4DB8
	Offset: 0x1890
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function createHatchetWatcher()
{
	watcher = self createUseWeaponObjectWatcher("hatchet", self.team);
	watcher.onDetonateCallback = &deleteEnt;
	watcher.onSpawn = &onSpawnHatchet;
	watcher.onDamage = &voidOnDamage;
	watcher.onSpawnRetrieveTriggers = &onSpawnHatchetTrigger;
}

/*
	Name: createTactInsertWatcher
	Namespace: weaponobjects
	Checksum: 0x6D17FB88
	Offset: 0x1930
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function createTactInsertWatcher()
{
	watcher = self createUseWeaponObjectWatcher("tactical_insertion", self.team);
	watcher.playDestroyedDialog = 0;
}

/*
	Name: createRCBombWatcher
	Namespace: weaponobjects
	Checksum: 0x12C9DBB2
	Offset: 0x1980
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function createRCBombWatcher()
{
	watcher = self createUseWeaponObjectWatcher("rcbomb", self.team);
	watcher.altDetonate = 0;
	watcher.headicon = 0;
	watcher.isMovable = 1;
	watcher.ownerGetsAssist = 1;
	watcher.playDestroyedDialog = 0;
	watcher.deleteOnKillbrush = 0;
	watcher.onDetonateCallback = level.rcbombOnBlowUp;
	watcher.stunTime = 1;
	watcher.notEquipment = 1;
}

/*
	Name: createQRDroneWatcher
	Namespace: weaponobjects
	Checksum: 0xD0B96BBF
	Offset: 0x1A68
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function createQRDroneWatcher()
{
	watcher = self createUseWeaponObjectWatcher("qrdrone", self.team);
	watcher.altDetonate = 0;
	watcher.headicon = 0;
	watcher.isMovable = 1;
	watcher.ownerGetsAssist = 1;
	watcher.playDestroyedDialog = 0;
	watcher.deleteOnKillbrush = 0;
	watcher.onDetonateCallback = level.qrdroneOnBlowUp;
	watcher.onDamage = level.qrdroneOnDamage;
	watcher.stunTime = 5;
	watcher.notEquipment = 1;
}

/*
	Name: getSpikeLauncherActiveSpikeCount
	Namespace: weaponobjects
	Checksum: 0x4E57AE7A
	Offset: 0x1B60
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function getSpikeLauncherActiveSpikeCount(watcher)
{
	currentItemCount = 0;
	foreach(obj in watcher.objectArray)
	{
		if(isdefined(obj) && obj.item !== watcher.weapon)
		{
			currentItemCount++;
		}
	}
	return currentItemCount;
}

/*
	Name: watchSpikeLauncherItemCountChanged
	Namespace: weaponobjects
	Checksum: 0x41CDC0FC
	Offset: 0x1C30
	Size: 0xE7
	Parameters: 1
	Flags: None
*/
function watchSpikeLauncherItemCountChanged(watcher)
{
	self endon("death");
	lastItemCount = undefined;
	while(1)
	{
		self waittill("weapon_change", weapon);
		while(weapon.name == "spike_launcher")
		{
			currentItemCount = getSpikeLauncherActiveSpikeCount(watcher);
			if(currentItemCount !== lastItemCount)
			{
				self SetControllerUIModelValue("spikeLauncherCounter.spikesReady", currentItemCount);
				lastItemCount = currentItemCount;
			}
			wait(0.1);
			weapon = self GetCurrentWeapon();
		}
	}
}

/*
	Name: spikesDetonating
	Namespace: weaponobjects
	Checksum: 0xAA9A0BE5
	Offset: 0x1D20
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function spikesDetonating(watcher)
{
	spikeCount = getSpikeLauncherActiveSpikeCount(watcher);
	if(spikeCount > 0)
	{
		self SetControllerUIModelValue("spikeLauncherCounter.blasting", 1);
		wait(2);
		self SetControllerUIModelValue("spikeLauncherCounter.blasting", 0);
	}
}

/*
	Name: createSpikeLauncherWatcher
	Namespace: weaponobjects
	Checksum: 0x16A0479B
	Offset: 0x1DB0
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function createSpikeLauncherWatcher(weapon)
{
	watcher = self createUseWeaponObjectWatcher(weapon, self.team);
	watcher.altName = "spike_charge";
	watcher.altweapon = GetWeapon("spike_charge");
	watcher.altDetonate = 0;
	watcher.watchForFire = 1;
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headicon = 0;
	watcher.onDetonateCallback = &spikeDetonate;
	watcher.onStun = &weaponStun;
	watcher.stunTime = 1;
	watcher.ownerGetsAssist = 1;
	watcher.detonateStationary = 0;
	watcher.detonationDelay = 0;
	watcher.detonationSound = "wpn_claymore_alert";
	watcher.onDetonationHandle = &spikesDetonating;
	self thread watchSpikeLauncherItemCountChanged(watcher);
}

/*
	Name: createPlayerHelicopterWatcher
	Namespace: weaponobjects
	Checksum: 0x9086791E
	Offset: 0x1F60
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function createPlayerHelicopterWatcher()
{
	watcher = self createUseWeaponObjectWatcher("helicopter_player", self.team);
	watcher.altDetonate = 1;
	watcher.headicon = 0;
	watcher.notEquipment = 1;
}

/*
	Name: createClaymoreWatcher
	Namespace: weaponobjects
	Checksum: 0x992402CA
	Offset: 0x1FD8
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function createClaymoreWatcher()
{
	watcher = self createProximityWeaponObjectWatcher("claymore", self.team);
	watcher.watchForFire = 1;
	watcher.onDetonateCallback = &claymoreDetonate;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.ownerGetsAssist = 1;
	detectionConeAngle = GetDvarInt("scr_weaponobject_coneangle");
	watcher.detectionDot = cos(detectionConeAngle);
	watcher.detectionMinDist = GetDvarInt("scr_weaponobject_mindist");
	watcher.detectionGracePeriod = GetDvarFloat("scr_weaponobject_graceperiod");
	watcher.detonateRadius = GetDvarInt("scr_weaponobject_radius");
	watcher.onStun = &weaponStun;
	watcher.stunTime = 1;
}

/*
	Name: voidOnSpawn
	Namespace: weaponobjects
	Checksum: 0xA524D68C
	Offset: 0x2198
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function voidOnSpawn(unused0, unused1)
{
}

/*
	Name: voidOnDamage
	Namespace: weaponobjects
	Checksum: 0x19B3433
	Offset: 0x21B8
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function voidOnDamage(unused0)
{
}

/*
	Name: voidOnSpawnRetrieveTriggers
	Namespace: weaponobjects
	Checksum: 0x7B1CE4C3
	Offset: 0x21D0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function voidOnSpawnRetrieveTriggers(unused0, unused1)
{
}

/*
	Name: voidPickUp
	Namespace: weaponobjects
	Checksum: 0x34BFC36B
	Offset: 0x21F0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function voidPickUp(unused0, unused1)
{
}

/*
	Name: deleteEnt
	Namespace: weaponobjects
	Checksum: 0x9A595374
	Offset: 0x2210
	Size: 0x33
	Parameters: 3
	Flags: None
*/
function deleteEnt(attacker, emp, target)
{
	self delete();
}

/*
	Name: clearFXOnDeath
	Namespace: weaponobjects
	Checksum: 0xC1C380A3
	Offset: 0x2250
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function clearFXOnDeath(FX)
{
	FX endon("death");
	self util::waittill_any("death", "hacked");
	FX delete();
}

/*
	Name: deleteWeaponObjectInstance
	Namespace: weaponobjects
	Checksum: 0x17E34678
	Offset: 0x22B0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function deleteWeaponObjectInstance()
{
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.mineMover))
	{
		if(isdefined(self.mineMover.killCamEnt))
		{
			self.mineMover.killCamEnt delete();
		}
		self.mineMover delete();
	}
	self delete();
}

/*
	Name: deleteWeaponObjectArray
	Namespace: weaponobjects
	Checksum: 0xDFF5D9AB
	Offset: 0x2340
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function deleteWeaponObjectArray()
{
	if(isdefined(self.objectArray))
	{
		foreach(weaponObject in self.objectArray)
		{
			weaponObject deleteWeaponObjectInstance();
		}
	}
	self.objectArray = [];
}

/*
	Name: delayedSpikeDetonation
	Namespace: weaponobjects
	Checksum: 0xECAD4261
	Offset: 0x23F0
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function delayedSpikeDetonation(attacker, weapon)
{
	if(!isdefined(self.owner.spikeDelay))
	{
		self.owner.spikeDelay = 0;
	}
	delayTime = self.owner.spikeDelay;
	owner = self.owner;
	self.owner.spikeDelay = self.owner.spikeDelay + 0.3;
	waittillframeend;
	wait(delayTime);
	owner.spikeDelay = owner.spikeDelay - 0.3;
	if(isdefined(self))
	{
		self weaponDetonate(attacker, weapon);
	}
}

/*
	Name: spikeDetonate
	Namespace: weaponobjects
	Checksum: 0x2FBE828
	Offset: 0x24F0
	Size: 0x7B
	Parameters: 3
	Flags: None
*/
function spikeDetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isValid)
	{
		if(isdefined(attacker))
		{
		}
	}
	thread delayedSpikeDetonation(attacker, weapon);
}

/*
	Name: claymoreDetonate
	Namespace: weaponobjects
	Checksum: 0xCB87575E
	Offset: 0x2578
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function claymoreDetonate(attacker, weapon, target)
{
	if(isdefined(attacker) && self.owner util::IsEnemyPlayer(attacker))
	{
		attacker challenges::destroyedExplosive(weapon);
		scoreevents::processScoreEvent("destroyed_claymore", attacker, self.owner, weapon);
	}
	weaponDetonate(attacker, weapon);
}

/*
	Name: weaponDetonate
	Namespace: weaponobjects
	Checksum: 0x160CD586
	Offset: 0x2648
	Size: 0x123
	Parameters: 2
	Flags: None
*/
function weaponDetonate(attacker, weapon)
{
	if(isdefined(weapon) && weapon.isEmp)
	{
		self delete();
		return;
	}
	if(isdefined(attacker))
	{
		if(isdefined(self.owner) && attacker != self.owner)
		{
			self.playDialog = 1;
		}
		if(isPlayer(attacker))
		{
			self detonate(attacker);
		}
		else
		{
			self detonate();
		}
	}
	else if(isdefined(self.owner) && isPlayer(self.owner))
	{
		self.playDialog = 0;
		self detonate(self.owner);
	}
	else
	{
		self detonate();
	}
}

/*
	Name: detonateWhenStationary
	Namespace: weaponobjects
	Checksum: 0x1657E892
	Offset: 0x2778
	Size: 0xA3
	Parameters: 4
	Flags: None
*/
function detonateWhenStationary(object, delay, attacker, weapon)
{
	level endon("game_ended");
	object endon("death");
	object endon("hacked");
	object endon("detonating");
	if(object IsOnGround() == 0)
	{
		object waittill("stationary");
	}
	self thread waitAndDetonate(object, delay, attacker, weapon);
}

/*
	Name: waitAndDetonate
	Namespace: weaponobjects
	Checksum: 0x4D81C32D
	Offset: 0x2828
	Size: 0x397
	Parameters: 4
	Flags: None
*/
function waitAndDetonate(object, delay, attacker, weapon)
{
	object endon("death");
	object endon("hacked");
	if(!isdefined(attacker) && !isdefined(weapon) && object.weapon.proximityalarmactivationdelay > 0)
	{
		if(isdefined(object.armed_detonation_wait) && object.armed_detonation_wait)
		{
			return;
		}
		object.armed_detonation_wait = 1;
		while(!(isdefined(object.proximity_deployed) && object.proximity_deployed))
		{
			wait(0.05);
		}
	}
	if(isdefined(object.detonated) && object.detonated)
	{
		return;
	}
	object.detonated = 1;
	object notify("detonating");
	isEmpDetonated = isdefined(weapon) && weapon.isEmp;
	if(isEmpDetonated && object.weapon.doEmpDestroyFx)
	{
		object.stun_fx = 1;
		playFX(level._equipment_emp_destroy_fx, object.origin + VectorScale((0, 0, 1), 5), (0, RandomFloat(360), 0));
		empFxDelay = 1.1;
	}
	if(!isdefined(self.onDetonateCallback))
	{
		return;
	}
	if(!isEmpDetonated && !isdefined(weapon))
	{
		if(isdefined(self.detonationDelay) && self.detonationDelay > 0)
		{
			if(isdefined(self.detonationSound))
			{
				object playsound(self.detonationSound);
			}
			delay = self.detonationDelay;
		}
	}
	else if(isdefined(empFxDelay))
	{
		delay = empFxDelay;
	}
	if(delay > 0)
	{
		wait(delay);
	}
	if(isdefined(attacker) && isPlayer(attacker) && isdefined(attacker.pers["team"]) && isdefined(object.owner) && isdefined(object.owner.pers["team"]))
	{
		if(level.teambased)
		{
			if(attacker.pers["team"] != object.owner.pers["team"])
			{
				attacker notify("destroyed_explosive");
			}
		}
		else if(attacker != object.owner)
		{
			attacker notify("destroyed_explosive");
		}
	}
	object [[self.onDetonateCallback]](attacker, weapon, undefined);
}

/*
	Name: waitAndFizzleOut
	Namespace: weaponobjects
	Checksum: 0xF7C2224A
	Offset: 0x2BC8
	Size: 0xC7
	Parameters: 2
	Flags: None
*/
function waitAndFizzleOut(object, delay)
{
	object endon("death");
	object endon("hacked");
	if(isdefined(object.detonated) && object.detonated == 1)
	{
		return;
	}
	object.detonated = 1;
	object notify("fizzleout");
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(self.onFizzleOut))
	{
		self deleteEnt();
		return;
	}
	object [[self.onFizzleOut]]();
}

/*
	Name: detonateWeaponObjectArray
	Namespace: weaponobjects
	Checksum: 0xC5992079
	Offset: 0x2C98
	Size: 0x23B
	Parameters: 2
	Flags: None
*/
function detonateWeaponObjectArray(forceDetonation, weapon)
{
	undetonated = [];
	if(isdefined(self.objectArray))
	{
		for(i = 0; i < self.objectArray.size; i++)
		{
			if(isdefined(self.objectArray[i]))
			{
				if(self.objectArray[i] isStunned() && forceDetonation == 0)
				{
					undetonated[undetonated.size] = self.objectArray[i];
					continue;
				}
				if(isdefined(weapon))
				{
					if(weapon util::isHacked() && weapon.name != self.objectArray[i].weapon.name)
					{
						undetonated[undetonated.size] = self.objectArray[i];
						continue;
					}
					else if(self.objectArray[i] util::isHacked() && weapon.name != self.objectArray[i].weapon.name)
					{
						undetonated[undetonated.size] = self.objectArray[i];
						continue;
					}
				}
				if(isdefined(self.detonateStationary) && self.detonateStationary && forceDetonation == 0)
				{
					self thread detonateWhenStationary(self.objectArray[i], 0, undefined, weapon);
					continue;
				}
				self thread waitAndDetonate(self.objectArray[i], 0, undefined, weapon);
			}
		}
	}
	self.objectArray = undetonated;
}

/*
	Name: addWeaponObjectToWatcher
	Namespace: weaponobjects
	Checksum: 0xADA34BBE
	Offset: 0x2EE0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function addWeaponObjectToWatcher(watcherName, weapon_instance)
{
	watcher = getWeaponObjectWatcher(watcherName);
	/#
		Assert(isdefined(watcher), "Dev Block strings are not supported" + watcherName + "Dev Block strings are not supported");
	#/
	self addWeaponObject(watcher, weapon_instance);
}

/*
	Name: addWeaponObject
	Namespace: weaponobjects
	Checksum: 0x4D2EE354
	Offset: 0x2F78
	Size: 0x333
	Parameters: 3
	Flags: None
*/
function addWeaponObject(watcher, weapon_instance, weapon)
{
	if(!isdefined(watcher.storeDifferentObject))
	{
		watcher.objectArray[watcher.objectArray.size] = weapon_instance;
	}
	if(!isdefined(weapon))
	{
		weapon = watcher.weapon;
	}
	weapon_instance.owner = self;
	weapon_instance.detonated = 0;
	weapon_instance.weapon = weapon;
	if(isdefined(watcher.onDamage))
	{
		weapon_instance thread [[watcher.onDamage]](watcher);
	}
	else
	{
		weapon_instance thread weaponObjectDamage(watcher);
	}
	weapon_instance.ownerGetsAssist = watcher.ownerGetsAssist;
	weapon_instance.destroyedByEmp = watcher.destroyedByEmp;
	if(isdefined(watcher.onSpawn))
	{
		weapon_instance thread [[watcher.onSpawn]](watcher, self);
	}
	if(isdefined(watcher.onSpawnFX))
	{
		weapon_instance thread [[watcher.onSpawnFX]]();
	}
	weapon_instance thread setupReconEffect();
	if(isdefined(watcher.onSpawnRetrieveTriggers))
	{
		weapon_instance thread [[watcher.onSpawnRetrieveTriggers]](watcher, self);
	}
	if(watcher.hackable)
	{
		weapon_instance thread hackerInit(watcher);
	}
	if(watcher.playDestroyedDialog)
	{
		weapon_instance thread playDialogOnDeath(self);
		weapon_instance thread watchObjectDamage(self);
	}
	if(watcher.deleteOnKillbrush)
	{
		if(isdefined(level.deleteOnKillbrushOverride))
		{
			weapon_instance thread [[level.deleteOnKillbrushOverride]](self, watcher);
		}
		else
		{
			weapon_instance thread deleteOnKillbrush(self);
		}
	}
	if(weapon_instance useTeamEquipmentClientField(watcher))
	{
		weapon_instance clientfield::set("teamequip", 1);
	}
	if(watcher.timeout)
	{
		weapon_instance thread weapon_object_timeout(watcher);
	}
	weapon_instance thread delete_on_notify(self);
	weapon_instance thread cleanUpWatcherOnDeath(watcher);
}

/*
	Name: cleanUpWatcherOnDeath
	Namespace: weaponobjects
	Checksum: 0xAC44725A
	Offset: 0x32B8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function cleanUpWatcherOnDeath(watcher)
{
	self waittill("death");
	if(isdefined(watcher) && isdefined(watcher.objectArray))
	{
		removeWeaponObject(watcher, self);
	}
	if(isdefined(self) && self.delete_on_death === 1)
	{
		self deleteWeaponObjectInstance();
	}
}

/*
	Name: weapon_object_timeout
	Namespace: weaponobjects
	Checksum: 0x5939E650
	Offset: 0x3340
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function weapon_object_timeout(watcher)
{
	self endon("death");
	wait(watcher.timeout);
	self deleteEnt();
}

/*
	Name: delete_on_notify
	Namespace: weaponobjects
	Checksum: 0x52B8BC2A
	Offset: 0x3388
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function delete_on_notify(e_player)
{
	e_player endon("disconnect");
	self endon("death");
	e_player waittill("delete_weapon_objects");
	self delete();
}

/*
	Name: deleteWeaponObjectHelper
	Namespace: weaponobjects
	Checksum: 0x21AC3DA4
	Offset: 0x33D8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function deleteWeaponObjectHelper(weapon_ent)
{
	watcher = self getWeaponObjectWatcherByWeapon(weapon_ent.weapon);
	if(!isdefined(watcher))
	{
		return;
	}
	removeWeaponObject(watcher, weapon_ent);
}

/*
	Name: removeWeaponObject
	Namespace: weaponobjects
	Checksum: 0xC6D68181
	Offset: 0x3440
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function removeWeaponObject(watcher, weapon_ent)
{
	watcher.objectArray = Array::remove_undefined(watcher.objectArray);
	ArrayRemoveValue(watcher.objectArray, weapon_ent);
}

/*
	Name: cleanWeaponObjectArray
	Namespace: weaponobjects
	Checksum: 0x9E9C53A9
	Offset: 0x34B0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function cleanWeaponObjectArray(watcher)
{
	watcher.objectArray = Array::remove_undefined(watcher.objectArray);
}

/*
	Name: weapon_object_do_DamageFeedBack
	Namespace: weaponobjects
	Checksum: 0x7F8B26E6
	Offset: 0x34F0
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function weapon_object_do_DamageFeedBack(weapon, attacker)
{
	if(isdefined(weapon) && isdefined(attacker))
	{
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
	}
}

/*
	Name: weaponObjectDamage
	Namespace: weaponobjects
	Checksum: 0xDBC64138
	Offset: 0x35E8
	Size: 0x42B
	Parameters: 1
	Flags: None
*/
function weaponObjectDamage(watcher)
{
	self endon("death");
	self endon("hacked");
	self endon("detonating");
	self SetCanDamage(1);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	self.damageTaken = 0;
	attacker = undefined;
	while(1)
	{
		self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags);
		self.damageTaken = self.damageTaken + damage;
		if(!isPlayer(attacker) && isdefined(attacker.owner))
		{
			attacker = attacker.owner;
		}
		if(isdefined(weapon))
		{
			self weapon_object_do_DamageFeedBack(weapon, attacker);
			if(watcher.stunTime > 0 && weapon.doStun)
			{
				self thread stunStart(watcher, watcher.stunTime);
				continue;
			}
		}
		if(level.teambased && isPlayer(attacker) && isdefined(self.owner))
		{
			if(!level.hardcoreMode && self.owner.team == attacker.pers["team"] && self.owner != attacker)
			{
				continue;
			}
		}
		if(isdefined(watcher.shouldDamage) && !self [[watcher.shouldDamage]](watcher, attacker, weapon, damage))
		{
			continue;
		}
		if(!isVehicle(self) && !friendlyFireCheck(self.owner, attacker))
		{
			continue;
		}
		break;
	}
	if(level.weaponobjectexplodethisframe)
	{
		wait(0.1 + RandomFloat(0.4));
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	level.weaponobjectexplodethisframe = 1;
	thread resetWeaponObjectExplodeThisFrame();
	self entityheadicons::setEntityHeadIcon("none");
	if(isdefined(type) && (IsSubStr(type, "MOD_GRENADE_SPLASH") || IsSubStr(type, "MOD_GRENADE") || IsSubStr(type, "MOD_EXPLOSIVE")))
	{
		self.wasChained = 1;
	}
	if(isdefined(iDFlags) && iDFlags & 8)
	{
		self.wasDamagedFromBulletPenetration = 1;
	}
	self.wasDamaged = 1;
	watcher thread waitAndDetonate(self, 0, attacker, weapon);
}

/*
	Name: playDialogOnDeath
	Namespace: weaponobjects
	Checksum: 0x4DB3CF1C
	Offset: 0x3A20
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function playDialogOnDeath(owner)
{
	owner endon("death");
	owner endon("disconnect");
	self endon("hacked");
	self waittill("death");
	if(isdefined(self.playDialog) && self.playDialog)
	{
		if(isdefined(level.playEquipmentDestroyedOnPlayer))
		{
			owner [[level.playEquipmentDestroyedOnPlayer]]();
		}
	}
}

/*
	Name: watchObjectDamage
	Namespace: weaponobjects
	Checksum: 0x32130B58
	Offset: 0x3AA0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function watchObjectDamage(owner)
{
	owner endon("death");
	owner endon("disconnect");
	self endon("hacked");
	self endon("death");
	while(1)
	{
		self waittill("damage", damage, attacker);
		if(isdefined(attacker) && isPlayer(attacker) && attacker != owner)
		{
			self.playDialog = 1;
		}
		else
		{
			self.playDialog = 0;
		}
	}
}

/*
	Name: stunStart
	Namespace: weaponobjects
	Checksum: 0xD6C5131C
	Offset: 0x3B68
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function stunStart(watcher, time)
{
	self endon("death");
	if(self isStunned())
	{
		return;
	}
	if(isdefined(watcher.onStun))
	{
		self thread [[watcher.onStun]]();
	}
	if(watcher.name == "rcbomb")
	{
		self.owner util::freeze_player_controls(1);
	}
	if(isdefined(time))
	{
		wait(time);
	}
	else
	{
		return;
	}
	if(watcher.name == "rcbomb")
	{
		self.owner util::freeze_player_controls(0);
	}
	self stunStop();
}

/*
	Name: stunStop
	Namespace: weaponobjects
	Checksum: 0x529CEAA0
	Offset: 0x3C80
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function stunStop()
{
	self notify("not_stunned");
}

/*
	Name: weaponStun
	Namespace: weaponobjects
	Checksum: 0xFFA07B51
	Offset: 0x3CA8
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function weaponStun()
{
	self endon("death");
	self endon("not_stunned");
	origin = self GetTagOrigin("tag_fx");
	if(!isdefined(origin))
	{
		origin = self.origin + VectorScale((0, 0, 1), 10);
	}
	self.stun_fx = spawn("script_model", origin);
	self.stun_fx SetModel("tag_origin");
	self thread stunFxThink(self.stun_fx);
	wait(0.1);
	PlayFXOnTag(level._equipment_spark_fx, self.stun_fx, "tag_origin");
}

/*
	Name: stunFxThink
	Namespace: weaponobjects
	Checksum: 0x4AEB7DC2
	Offset: 0x3DB0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function stunFxThink(FX)
{
	FX endon("death");
	self util::waittill_any("death", "not_stunned");
	FX delete();
}

/*
	Name: isStunned
	Namespace: weaponobjects
	Checksum: 0xE4FA26A
	Offset: 0x3E10
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function isStunned()
{
	return isdefined(self.stun_fx);
}

/*
	Name: weaponObjectFizzleOut
	Namespace: weaponobjects
	Checksum: 0xABD20804
	Offset: 0x3E28
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function weaponObjectFizzleOut()
{
	self endon("death");
	playFX(level._equipment_fizzleout_fx, self.origin);
	deleteEnt();
}

/*
	Name: resetWeaponObjectExplodeThisFrame
	Namespace: weaponobjects
	Checksum: 0x1AE0EB89
	Offset: 0x3E70
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function resetWeaponObjectExplodeThisFrame()
{
	wait(0.05);
	level.weaponobjectexplodethisframe = 0;
}

/*
	Name: getWeaponObjectWatcher
	Namespace: weaponobjects
	Checksum: 0x5EB43710
	Offset: 0x3E90
	Size: 0xB5
	Parameters: 1
	Flags: None
*/
function getWeaponObjectWatcher(name)
{
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		return undefined;
	}
	for(watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++)
	{
		if(self.weaponObjectWatcherArray[watcher].name == name || (isdefined(self.weaponObjectWatcherArray[watcher].altName) && self.weaponObjectWatcherArray[watcher].altName == name))
		{
			return self.weaponObjectWatcherArray[watcher];
		}
	}
	return undefined;
}

/*
	Name: getWeaponObjectWatcherByWeapon
	Namespace: weaponobjects
	Checksum: 0xAD5B758B
	Offset: 0x3F50
	Size: 0x135
	Parameters: 1
	Flags: None
*/
function getWeaponObjectWatcherByWeapon(weapon)
{
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		return undefined;
	}
	if(!isdefined(weapon))
	{
		return undefined;
	}
	for(watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++)
	{
		if(isdefined(self.weaponObjectWatcherArray[watcher].weapon) && (self.weaponObjectWatcherArray[watcher].weapon == weapon || self.weaponObjectWatcherArray[watcher].weapon == weapon.rootweapon))
		{
			return self.weaponObjectWatcherArray[watcher];
		}
		if(isdefined(self.weaponObjectWatcherArray[watcher].weapon) && isdefined(self.weaponObjectWatcherArray[watcher].altweapon) && self.weaponObjectWatcherArray[watcher].altweapon == weapon)
		{
			return self.weaponObjectWatcherArray[watcher];
		}
	}
	return undefined;
}

/*
	Name: resetWeaponObjectWatcher
	Namespace: weaponobjects
	Checksum: 0xBDE01247
	Offset: 0x4090
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function resetWeaponObjectWatcher(watcher, ownerTeam)
{
	if(watcher.deleteOnPlayerSpawn == 1 || (isdefined(watcher.ownerTeam) && watcher.ownerTeam != ownerTeam))
	{
		self notify("weapon_object_destroyed");
		watcher deleteWeaponObjectArray();
	}
	watcher.ownerTeam = ownerTeam;
}

/*
	Name: createWeaponObjectWatcher
	Namespace: weaponobjects
	Checksum: 0x30C9CC52
	Offset: 0x4128
	Size: 0x397
	Parameters: 2
	Flags: None
*/
function createWeaponObjectWatcher(weaponName, ownerTeam)
{
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		self.weaponObjectWatcherArray = [];
	}
	weaponObjectWatcher = getWeaponObjectWatcher(weaponName);
	if(!isdefined(weaponObjectWatcher))
	{
		weaponObjectWatcher = spawnstruct();
		self.weaponObjectWatcherArray[self.weaponObjectWatcherArray.size] = weaponObjectWatcher;
		weaponObjectWatcher.name = weaponName;
		weaponObjectWatcher.type = "use";
		weaponObjectWatcher.weapon = GetWeapon(weaponName);
		weaponObjectWatcher.watchForFire = 0;
		weaponObjectWatcher.hackable = 0;
		weaponObjectWatcher.altDetonate = 0;
		weaponObjectWatcher.detectable = 1;
		weaponObjectWatcher.headicon = 0;
		weaponObjectWatcher.stunTime = 0;
		weaponObjectWatcher.timeout = 0;
		weaponObjectWatcher.destroyedByEmp = 1;
		weaponObjectWatcher.activateSound = undefined;
		weaponObjectWatcher.ignoreDirection = undefined;
		weaponObjectWatcher.immediateDetonation = undefined;
		weaponObjectWatcher.deploySound = weaponObjectWatcher.weapon.fireSound;
		weaponObjectWatcher.deploySoundPlayer = weaponObjectWatcher.weapon.firesoundplayer;
		weaponObjectWatcher.pickUpSound = weaponObjectWatcher.weapon.pickUpSound;
		weaponObjectWatcher.pickUpSoundPlayer = weaponObjectWatcher.weapon.pickUpSoundPlayer;
		weaponObjectWatcher.altweapon = weaponObjectWatcher.weapon.altweapon;
		weaponObjectWatcher.ownerGetsAssist = 0;
		weaponObjectWatcher.playDestroyedDialog = 1;
		weaponObjectWatcher.deleteOnKillbrush = 1;
		weaponObjectWatcher.deleteOnDifferentObjectSpawn = 1;
		weaponObjectWatcher.enemyDestroy = 0;
		weaponObjectWatcher.deleteOnPlayerSpawn = level.deleteExplosivesOnSpawn;
		weaponObjectWatcher.ignoreVehicles = 0;
		weaponObjectWatcher.ignoreAI = 0;
		weaponObjectWatcher.activationDelay = 0;
		weaponObjectWatcher.onSpawn = undefined;
		weaponObjectWatcher.onSpawnFX = undefined;
		weaponObjectWatcher.onSpawnRetrieveTriggers = undefined;
		weaponObjectWatcher.onDetonateCallback = undefined;
		weaponObjectWatcher.onStun = undefined;
		weaponObjectWatcher.onStunFinished = undefined;
		weaponObjectWatcher.onDestroyed = undefined;
		weaponObjectWatcher.onFizzleOut = &weaponObjectFizzleOut;
		weaponObjectWatcher.shouldDamage = undefined;
		weaponObjectWatcher.onSupplementalDetonateCallback = undefined;
		if(!isdefined(weaponObjectWatcher.objectArray))
		{
			weaponObjectWatcher.objectArray = [];
		}
	}
	resetWeaponObjectWatcher(weaponObjectWatcher, ownerTeam);
	return weaponObjectWatcher;
}

/*
	Name: createUseWeaponObjectWatcher
	Namespace: weaponobjects
	Checksum: 0x919BFA09
	Offset: 0x44C8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function createUseWeaponObjectWatcher(weaponName, ownerTeam)
{
	weaponObjectWatcher = createWeaponObjectWatcher(weaponName, ownerTeam);
	weaponObjectWatcher.type = "use";
	weaponObjectWatcher.onSpawn = &onSpawnUseWeaponObject;
	return weaponObjectWatcher;
}

/*
	Name: createProximityWeaponObjectWatcher
	Namespace: weaponobjects
	Checksum: 0x4CDF0E6E
	Offset: 0x4540
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function createProximityWeaponObjectWatcher(weaponName, ownerTeam)
{
	weaponObjectWatcher = createWeaponObjectWatcher(weaponName, ownerTeam);
	weaponObjectWatcher.type = "proximity";
	weaponObjectWatcher.onSpawn = &onSpawnProximityWeaponObject;
	detectionConeAngle = GetDvarInt("scr_weaponobject_coneangle");
	weaponObjectWatcher.detectionDot = cos(detectionConeAngle);
	weaponObjectWatcher.detectionMinDist = GetDvarInt("scr_weaponobject_mindist");
	weaponObjectWatcher.detectionGracePeriod = GetDvarFloat("scr_weaponobject_graceperiod");
	weaponObjectWatcher.detonateRadius = GetDvarInt("scr_weaponobject_radius");
	return weaponObjectWatcher;
}

/*
	Name: commonOnSpawnUseWeaponObject
	Namespace: weaponobjects
	Checksum: 0x43D14E9F
	Offset: 0x4678
	Size: 0x23B
	Parameters: 2
	Flags: None
*/
function commonOnSpawnUseWeaponObject(watcher, owner)
{
	level endon("game_ended");
	self endon("death");
	self endon("hacked");
	if(watcher.detectable)
	{
		if(watcher.headicon && level.teambased)
		{
			self util::waitTillNotMoving();
			if(isdefined(self))
			{
				offset = self.weapon.weaponHeadObjectiveHeight;
				v_up = anglesToUp(self.angles);
				x_offset = Abs(v_up[0]);
				y_offset = Abs(v_up[1]);
				z_offset = Abs(v_up[2]);
				if(x_offset > y_offset && x_offset > z_offset)
				{
				}
				else if(y_offset > x_offset && y_offset > z_offset)
				{
				}
				else if(z_offset > x_offset && z_offset > y_offset)
				{
					v_up = v_up * (0, 0, 1);
				}
				up_offset_modified = v_up * offset;
				up_offset = anglesToUp(self.angles) * offset;
				objective = GetEquipmentHeadObjective(self.weapon);
				self entityheadicons::setEntityHeadIcon(owner.pers["team"], owner, up_offset, objective);
			}
		}
	}
}

/*
	Name: WasProximityAlarmActivatedBySelf
	Namespace: weaponobjects
	Checksum: 0xFEDE9AD4
	Offset: 0x48C0
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function WasProximityAlarmActivatedBySelf()
{
	return isdefined(self.owner.ProximityAmlarmEnt) && self.owner.ProximityAmlarmEnt == self;
}

/*
	Name: ProximityAlarmActivate
	Namespace: weaponobjects
	Checksum: 0x39972161
	Offset: 0x48F8
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function ProximityAlarmActivate(active, watcher)
{
	if(!isdefined(self.owner) || !isPlayer(self.owner))
	{
		return;
	}
	if(active && !isdefined(self.owner.ProximityAmlarmEnt))
	{
		self.owner.ProximityAmlarmEnt = self;
		self.owner clientfield::set_to_player("proximity_alarm", 2);
		self.owner clientfield::set_player_uimodel("hudItems.proximityAlarm", 2);
	}
	else if(!isdefined(self) || self WasProximityAlarmActivatedBySelf() || self.owner clientfield::get_to_player("proximity_alarm") == 1)
	{
		self.owner.ProximityAmlarmEnt = undefined;
		self.owner clientfield::set_to_player("proximity_alarm", 0);
		self.owner clientfield::set_player_uimodel("hudItems.proximityAlarm", 0);
	}
}

/*
	Name: ProximityAlarmLoop
	Namespace: weaponobjects
	Checksum: 0xF08BFA33
	Offset: 0x4A60
	Size: 0x695
	Parameters: 2
	Flags: None
*/
function ProximityAlarmLoop(watcher, owner)
{
	level endon("game_ended");
	self endon("death");
	self endon("hacked");
	self endon("detonating");
	if(self.weapon.proximityalarminnerradius <= 0)
	{
		return;
	}
	self util::waitTillNotMoving();
	delayTimeSec = self.weapon.proximityalarmactivationdelay / 1000;
	if(delayTimeSec > 0)
	{
		wait(delayTimeSec);
		if(!isdefined(self))
		{
			return;
		}
	}
	if(!(isdefined(self.owner._disable_proximity_alarms) && self.owner._disable_proximity_alarms))
	{
		self.owner clientfield::set_to_player("proximity_alarm", 1);
		self.owner clientfield::set_player_uimodel("hudItems.proximityAlarm", 1);
	}
	self.proximity_deployed = 1;
	alarmStatusOld = "notify";
	alarmStatus = "off";
	while(1)
	{
		wait(0.05);
		if(!isdefined(self.owner) || !isPlayer(self.owner))
		{
			return;
		}
		if(isalive(self.owner) == 0 && self.owner util::isUsingRemote() == 0)
		{
			self ProximityAlarmActivate(0, watcher);
			return;
		}
		if(isdefined(self.owner._disable_proximity_alarms) && self.owner._disable_proximity_alarms)
		{
			self ProximityAlarmActivate(0, watcher);
		}
		else if(alarmStatus != alarmStatusOld || (alarmStatus == "on" && !isdefined(self.owner.ProximityAmlarmEnt)))
		{
			if(alarmStatus == "on")
			{
				if(alarmStatusOld == "off" && isdefined(watcher) && isdefined(watcher.proximityAlarmActivateSound))
				{
					playsoundatposition(watcher.proximityAlarmActivateSound, self.origin + VectorScale((0, 0, 1), 32));
				}
				self ProximityAlarmActivate(1, watcher);
			}
			else
			{
				self ProximityAlarmActivate(0, watcher);
			}
			alarmStatusOld = alarmStatus;
		}
		alarmStatus = "off";
		actors = GetActorArray();
		players = GetPlayers();
		detectEntities = ArrayCombine(players, actors, 0, 0);
		foreach(entity in detectEntities)
		{
			wait(0.05);
			if(!isdefined(entity))
			{
				continue;
			}
			owner = entity;
			if(IsActor(entity) && (!isdefined(entity.isaiclone) || !entity.isaiclone))
			{
				continue;
			}
			else if(IsActor(entity))
			{
				owner = entity.owner;
			}
			if(entity.team == "spectator")
			{
				continue;
			}
			if(level.weaponObjectDebug != 1)
			{
				if(owner hasPerk("specialty_detectexplosive"))
				{
					continue;
				}
				if(isdefined(self.owner) && owner == self.owner)
				{
					continue;
				}
				if(!friendlyFireCheck(self.owner, owner, 0))
				{
					continue;
				}
			}
			if(self isStunned())
			{
				continue;
			}
			if(!isalive(entity))
			{
				continue;
			}
			if(isdefined(watcher.immunespecialty) && owner hasPerk(watcher.immunespecialty))
			{
				continue;
			}
			radius = self.weapon.proximityalarmouterradius;
			distanceSqr = DistanceSquared(self.origin, entity.origin);
			if(radius * radius < distanceSqr)
			{
				continue;
			}
			if(entity damageConeTrace(self.origin, self) == 0)
			{
				continue;
			}
			if(alarmStatusOld == "on")
			{
				alarmStatus = "on";
				break;
			}
			radius = self.weapon.proximityalarminnerradius;
			if(radius * radius < distanceSqr)
			{
				continue;
			}
			alarmStatus = "on";
			break;
		}
	}
}

/*
	Name: commonOnSpawnUseWeaponObjectProximityAlarm
	Namespace: weaponobjects
	Checksum: 0x6ED92634
	Offset: 0x5100
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function commonOnSpawnUseWeaponObjectProximityAlarm(watcher, owner)
{
	/#
		if(level.weaponObjectDebug == 1)
		{
			self thread proximityAlarmWeaponObjectDebug(watcher);
		}
	#/
	self ProximityAlarmLoop(watcher, owner);
	self ProximityAlarmActivate(0, watcher);
}

/*
	Name: onSpawnUseWeaponObject
	Namespace: weaponobjects
	Checksum: 0x331DD17A
	Offset: 0x5188
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function onSpawnUseWeaponObject(watcher, owner)
{
	self thread commonOnSpawnUseWeaponObject(watcher, owner);
	self thread commonOnSpawnUseWeaponObjectProximityAlarm(watcher, owner);
}

/*
	Name: onSpawnProximityWeaponObject
	Namespace: weaponobjects
	Checksum: 0x82672BCF
	Offset: 0x51E8
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function onSpawnProximityWeaponObject(watcher, owner)
{
	self.protected_entities = [];
	self thread commonOnSpawnUseWeaponObject(watcher, owner);
	if(isdefined(level._proximityWeaponObjectDetonation_override))
	{
		self thread [[level._proximityWeaponObjectDetonation_override]](watcher);
	}
	else
	{
		self thread proximityWeaponObjectDetonation(watcher);
	}
	/#
		if(level.weaponObjectDebug == 1)
		{
			self thread proximityWeaponObjectDebug(watcher);
		}
	#/
}

/*
	Name: watchWeaponObjectUsage
	Namespace: weaponobjects
	Checksum: 0xC401BCFD
	Offset: 0x52A0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function watchWeaponObjectUsage()
{
	self endon("disconnect");
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		self.weaponObjectWatcherArray = [];
	}
	self thread watchWeaponObjectSpawn("grenade_fire");
	self thread watchWeaponObjectSpawn("grenade_launcher_fire");
	self thread watchWeaponObjectSpawn("missile_fire");
	self thread watchWeaponObjectDetonation();
	self thread watchWeaponObjectAltDetonation();
	self thread watchWeaponObjectAltDetonate();
	self thread deleteWeaponObjectsOn();
}

/*
	Name: watchWeaponObjectSpawn
	Namespace: weaponobjects
	Checksum: 0x606225FE
	Offset: 0x5390
	Size: 0x1FF
	Parameters: 1
	Flags: None
*/
function watchWeaponObjectSpawn(notify_type)
{
	self notify("watchWeaponObjectSpawn_" + notify_type);
	self endon("watchWeaponObjectSpawn_" + notify_type);
	self endon("disconnect");
	while(1)
	{
		self waittill(notify_type, weapon_instance, weapon);
		if(SessionModeIsCampaignZombiesGame() || (isdefined(level.projectiles_should_ignore_world_pause) && level.projectiles_should_ignore_world_pause) && isdefined(weapon_instance))
		{
			weapon_instance SetIgnorePauseWorld(1);
		}
		if(weapon.setUsedStat && !self util::isHacked())
		{
			self addweaponstat(weapon, "used", 1);
		}
		watcher = getWeaponObjectWatcherByWeapon(weapon);
		if(isdefined(watcher))
		{
			cleanWeaponObjectArray(watcher);
			if(weapon.maxinstancesallowed)
			{
				if(watcher.objectArray.size > weapon.maxinstancesallowed - 1)
				{
					watcher thread waitAndFizzleOut(watcher.objectArray[0], 0.1);
					watcher.objectArray[0] = undefined;
					cleanWeaponObjectArray(watcher);
				}
			}
			self addWeaponObject(watcher, weapon_instance);
		}
	}
}

/*
	Name: anyObjectsInWorld
	Namespace: weaponobjects
	Checksum: 0x8DD940B4
	Offset: 0x5598
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function anyObjectsInWorld(weapon)
{
	objectsInWorld = 0;
	for(i = 0; i < self.weaponObjectWatcherArray.size; i++)
	{
		if(self.weaponObjectWatcherArray[i].weapon != weapon)
		{
			continue;
		}
		if(isdefined(self.weaponObjectWatcherArray[i].onDetonateCallback) && self.weaponObjectWatcherArray[i].objectArray.size > 0)
		{
			objectsInWorld = 1;
			break;
		}
	}
	return objectsInWorld;
}

/*
	Name: proximitySphere
	Namespace: weaponobjects
	Checksum: 0xB3372E19
	Offset: 0x5660
	Size: 0xAF
	Parameters: 5
	Flags: None
*/
function proximitySphere(origin, innerRadius, inColor, outerRadius, outColor)
{
	/#
		self endon("death");
		while(1)
		{
			if(isdefined(innerRadius))
			{
				dev::debug_sphere(origin, innerRadius, inColor, 0.25, 1);
			}
			if(isdefined(outerRadius))
			{
				dev::debug_sphere(origin, outerRadius, outColor, 0.25, 1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: proximityAlarmWeaponObjectDebug
	Namespace: weaponobjects
	Checksum: 0x60D4C255
	Offset: 0x5718
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function proximityAlarmWeaponObjectDebug(watcher)
{
	/#
		self endon("death");
		self util::waitTillNotMoving();
		if(!isdefined(self))
		{
			return;
		}
		self thread proximitySphere(self.origin, self.weapon.proximityalarminnerradius, VectorScale((0, 1, 0), 0.75), self.weapon.proximityalarmouterradius, VectorScale((0, 1, 0), 0.75));
	#/
}

/*
	Name: proximityWeaponObjectDebug
	Namespace: weaponobjects
	Checksum: 0x5897BAAC
	Offset: 0x57B0
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function proximityWeaponObjectDebug(watcher)
{
	/#
		self endon("death");
		self util::waitTillNotMoving();
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(watcher.ignoreDirection))
		{
			self thread proximitySphere(self.origin, watcher.detonateRadius, (1, 0.85, 0), self.weapon.explosionRadius, (1, 0, 0));
		}
		else
		{
			self thread showCone(ACos(watcher.detectionDot), watcher.detonateRadius, (1, 0.85, 0));
			self thread showCone(60, 256, (1, 0, 0));
		}
	#/
}

/*
	Name: showCone
	Namespace: weaponobjects
	Checksum: 0x8456960E
	Offset: 0x58C0
	Size: 0x22B
	Parameters: 3
	Flags: None
*/
function showCone(angle, range, color)
{
	/#
		self endon("death");
		start = self.origin;
		FORWARD = AnglesToForward(self.angles);
		right = VectorCross(FORWARD, (0, 0, 1));
		up = VectorCross(FORWARD, right);
		fullforward = FORWARD * range * cos(angle);
		sideamnt = range * sin(angle);
		while(1)
		{
			prevpoint = (0, 0, 0);
			for(i = 0; i <= 20; i++)
			{
				coneangle = i / 20 * 360;
				point = start + fullforward + sideamnt * right * cos(coneangle) + up * sin(coneangle);
				if(i > 0)
				{
					line(start, point, color);
					line(prevpoint, point, color);
				}
				prevpoint = point;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: weaponObjectDetectionMovable
	Namespace: weaponobjects
	Checksum: 0xBE03BCBF
	Offset: 0x5AF8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function weaponObjectDetectionMovable(ownerTeam)
{
	self endon("end_detection");
	level endon("game_ended");
	self endon("death");
	self endon("hacked");
	if(!level.teambased)
	{
		return;
	}
	self.detectId = "rcBomb" + GetTime() + RandomInt(1000000);
}

/*
	Name: setIconPos
	Namespace: weaponobjects
	Checksum: 0x48ED7D4F
	Offset: 0x5B78
	Size: 0x87
	Parameters: 3
	Flags: None
*/
function setIconPos(item, icon, heightIncrease)
{
	icon.x = item.origin[0];
	icon.y = item.origin[1];
	icon.z = item.origin[2] + heightIncrease;
}

/*
	Name: weaponObjectDetectionTrigger_wait
	Namespace: weaponobjects
	Checksum: 0xA7C358E
	Offset: 0x5C08
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function weaponObjectDetectionTrigger_wait(ownerTeam)
{
	self endon("death");
	self endon("hacked");
	self endon("detonating");
	util::waitTillNotMoving();
	self thread weaponObjectDetectionTrigger(ownerTeam);
}

/*
	Name: weaponObjectDetectionTrigger
	Namespace: weaponobjects
	Checksum: 0x5EBCCCB4
	Offset: 0x5C70
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function weaponObjectDetectionTrigger(ownerTeam)
{
	trigger = spawn("trigger_radius", self.origin - VectorScale((0, 0, 1), 128), 0, 512, 256);
	trigger.detectId = "trigger" + GetTime() + RandomInt(1000000);
	trigger SetHintLowPriority(1);
	self util::waittill_any("death", "hacked", "detonating");
	trigger notify("end_detection");
	if(isdefined(trigger.bombSquadIcon))
	{
		trigger.bombSquadIcon destroy();
	}
	trigger delete();
}

/*
	Name: hackerTriggerSetVisibility
	Namespace: weaponobjects
	Checksum: 0x955B1FF5
	Offset: 0x5DA0
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function hackerTriggerSetVisibility(owner)
{
	self endon("death");
	/#
		Assert(isPlayer(owner));
	#/
	ownerTeam = owner.pers["team"];
	while(level.teambased && isdefined(ownerTeam))
	{
		self SetVisibleToAllExceptTeam(ownerTeam);
		self SetExcludeTeamForTrigger(ownerTeam);
		continue;
		self SetVisibleToAll();
		self SetTeamForTrigger("none");
		if(isdefined(owner))
		{
			self SetInvisibleToPlayer(owner);
		}
		level util::waittill_any("player_spawned", "joined_team");
	}
}

/*
	Name: hackerNotMoving
	Namespace: weaponobjects
	Checksum: 0x3E4AA773
	Offset: 0x5ED8
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function hackerNotMoving()
{
	self endon("death");
	self util::waitTillNotMoving();
	self notify("landed");
}

/*
	Name: hackerInit
	Namespace: weaponobjects
	Checksum: 0x6C253D37
	Offset: 0x5F18
	Size: 0x263
	Parameters: 1
	Flags: None
*/
function hackerInit(watcher)
{
	self thread hackerNotMoving();
	event = self util::waittill_any_return("death", "landed");
	if(event == "death")
	{
		return;
	}
	triggerOrigin = self.origin;
	if("" != self.weapon.hackerTriggerOriginTag)
	{
		triggerOrigin = self GetTagOrigin(self.weapon.hackerTriggerOriginTag);
	}
	self.hackertrigger = spawn("trigger_radius_use", triggerOrigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height);
	/#
	#/
	self.hackertrigger SetHintLowPriority(1);
	self.hackertrigger setcursorhint("HINT_NOICON", self);
	self.hackertrigger SetIgnoreEntForTrigger(self);
	self.hackertrigger EnableLinkTo();
	self.hackertrigger LinkTo(self);
	if(isdefined(level.hackerHints[self.weapon.name]))
	{
		self.hackertrigger setHintString(level.hackerHints[self.weapon.name].hint);
	}
	else
	{
		self.hackertrigger setHintString(&"MP_GENERIC_HACKING");
	}
	self.hackertrigger SetPerkForTrigger("specialty_disarmexplosive");
	self.hackertrigger thread hackerTriggerSetVisibility(self.owner);
	self thread hackerThink(self.hackertrigger, watcher);
}

/*
	Name: hackerThink
	Namespace: weaponobjects
	Checksum: 0x4ACC328D
	Offset: 0x6188
	Size: 0xA1
	Parameters: 2
	Flags: None
*/
function hackerThink(trigger, watcher)
{
	self endon("death");
	for(;;)
	{
		trigger waittill("trigger", player, instant);
		if(!isdefined(instant) && !trigger hackerResult(player, self.owner))
		{
			continue;
		}
		self ItemHacked(watcher, player);
		return;
	}
}

/*
	Name: ItemHacked
	Namespace: weaponobjects
	Checksum: 0x1D78C87B
	Offset: 0x6238
	Size: 0x353
	Parameters: 2
	Flags: None
*/
function ItemHacked(watcher, player)
{
	self ProximityAlarmActivate(0, watcher);
	self.owner hackerRemoveWeapon(self);
	if(isdefined(level.playEquipmentHackedOnPlayer))
	{
		self.owner [[level.playEquipmentHackedOnPlayer]]();
	}
	if(self.weapon.ammoCountEquipment > 0 && isdefined(self.ammo))
	{
		ammoLeftEquipment = self.ammo;
		if(self.weapon.rootweapon == GetWeapon("trophy_system"))
		{
			player trophy_system::ammo_weapon_hacked(ammoLeftEquipment);
		}
	}
	self.hacked = 1;
	self SetMissileOwner(player);
	self SetTeam(player.pers["team"]);
	self.owner = player;
	self clientfield::set("retrievable", 0);
	if(self.weapon.doHackedStats)
	{
		scoreevents::processScoreEvent("hacked", player);
		player addweaponstat(GetWeapon("pda_hack"), "CombatRecordStat", 1);
		player challenges::hackedOrDestroyedEquipment();
	}
	if(self.weapon.rootweapon == level.weaponSatchelCharge && isdefined(player.lowerMessage))
	{
		player.lowerMessage setText(&"PLATFORM_SATCHEL_CHARGE_DOUBLE_TAP");
		player.lowerMessage.alpha = 1;
		player.lowerMessage fadeOverTime(2);
		player.lowerMessage.alpha = 0;
	}
	self notify("hacked", player);
	level notify("hacked", self, player);
	if(isdefined(self.cameraHead))
	{
		self.cameraHead notify("hacked", player);
	}
	/#
	#/
	wait(0.05);
	if(isdefined(player) && player.sessionstate == "playing")
	{
		player notify("grenade_fire", self, self.weapon, 1);
	}
	else
	{
		watcher thread waitAndDetonate(self, 0, undefined, self.weapon);
	}
}

/*
	Name: hackerUnfreezePlayer
	Namespace: weaponobjects
	Checksum: 0xCC5D4AE
	Offset: 0x6598
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function hackerUnfreezePlayer(player)
{
	self endon("hack_done");
	self waittill("death");
	if(isdefined(player))
	{
		player util::freeze_player_controls(0);
		player enableWeapons();
	}
}

/*
	Name: hackerResult
	Namespace: weaponobjects
	Checksum: 0x2AB3D6E2
	Offset: 0x6600
	Size: 0x2E5
	Parameters: 2
	Flags: None
*/
function hackerResult(player, owner)
{
	success = 1;
	time = GetTime();
	hackTime = GetDvarFloat("perk_disarmExplosiveTime");
	if(!canHack(player, owner, 1))
	{
		return 0;
	}
	self thread hackerUnfreezePlayer(player);
	while(time + hackTime * 1000 > GetTime())
	{
		if(!canHack(player, owner, 0))
		{
			success = 0;
			break;
		}
		if(!player useButtonPressed())
		{
			success = 0;
			break;
		}
		if(!isdefined(self))
		{
			success = 0;
			break;
		}
		player util::freeze_player_controls(1);
		player DisableWeapons();
		if(!isdefined(self.progressbar))
		{
			self.progressbar = player hud::createPrimaryProgressBar();
			self.progressbar.lastUseRate = -1;
			self.progressbar hud::showElem();
			self.progressbar hud::updateBar(0.01, 1 / hackTime);
			self.progressText = player hud::createPrimaryProgressBarText();
			self.progressText setText(&"MP_HACKING");
			self.progressText hud::showElem();
			player playlocalsound("evt_hacker_hacking");
		}
		wait(0.05);
	}
	if(isdefined(player))
	{
		player util::freeze_player_controls(0);
		player enableWeapons();
	}
	if(isdefined(self.progressbar))
	{
		self.progressbar hud::destroyElem();
		self.progressText hud::destroyElem();
	}
	if(isdefined(self))
	{
		self notify("hack_done");
	}
	return success;
}

/*
	Name: canHack
	Namespace: weaponobjects
	Checksum: 0xAD90914F
	Offset: 0x68F0
	Size: 0x329
	Parameters: 3
	Flags: None
*/
function canHack(player, owner, weapon_check)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isPlayer(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isdefined(owner))
	{
		return 0;
	}
	if(owner == player)
	{
		return 0;
	}
	if(level.teambased && player.team == owner.team)
	{
		return 0;
	}
	if(isdefined(player.isDefusing) && player.isDefusing)
	{
		return 0;
	}
	if(isdefined(player.isPlanting) && player.isPlanting)
	{
		return 0;
	}
	if(isdefined(player.proxBar) && !player.proxBar.hidden)
	{
		return 0;
	}
	if(isdefined(player.revivingTeammate) && player.revivingTeammate == 1)
	{
		return 0;
	}
	if(!player IsOnGround())
	{
		return 0;
	}
	if(player IsInVehicle())
	{
		return 0;
	}
	if(player IsWeaponViewOnlyLinked())
	{
		return 0;
	}
	if(!player hasPerk("specialty_disarmexplosive"))
	{
		return 0;
	}
	if(player IsEmpJammed())
	{
		return 0;
	}
	if(isdefined(player.laststand) && player.laststand)
	{
		return 0;
	}
	if(weapon_check)
	{
		if(player IsThrowingGrenade())
		{
			return 0;
		}
		if(player IsSwitchingWeapons())
		{
			return 0;
		}
		if(player IsMeleeing())
		{
			return 0;
		}
		weapon = player GetCurrentWeapon();
		if(!isdefined(weapon))
		{
			return 0;
		}
		if(weapon == level.weaponNone)
		{
			return 0;
		}
		if(weapon.isEquipment && player isFiring())
		{
			return 0;
		}
		if(weapon.isSpecificUse)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: hackerRemoveWeapon
	Namespace: weaponobjects
	Checksum: 0xB1186F91
	Offset: 0x6C28
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function hackerRemoveWeapon(weapon_instance)
{
	for(i = 0; i < self.weaponObjectWatcherArray.size; i++)
	{
		if(self.weaponObjectWatcherArray[i].weapon != weapon_instance.weapon.rootweapon)
		{
			continue;
		}
		removeWeaponObject(self.weaponObjectWatcherArray[i], weapon_instance);
		return;
	}
}

/*
	Name: proximityWeaponObject_CreateDamageArea
	Namespace: weaponobjects
	Checksum: 0x3A3CEC37
	Offset: 0x6CC8
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function proximityWeaponObject_CreateDamageArea(watcher)
{
	damagearea = spawn("trigger_radius", self.origin + (0, 0, 0 - watcher.detonateRadius), level.aiTriggerSpawnFlags | level.vehicleTriggerSpawnFlags, watcher.detonateRadius, watcher.detonateRadius * 2);
	damagearea EnableLinkTo();
	damagearea LinkTo(self);
	self thread deleteOnDeath(damagearea);
	return damagearea;
}

/*
	Name: proximityWeaponObject_ValidTriggerEntity
	Namespace: weaponobjects
	Checksum: 0xD69C2206
	Offset: 0x6D98
	Size: 0x205
	Parameters: 2
	Flags: None
*/
function proximityWeaponObject_ValidTriggerEntity(watcher, ent)
{
	if(level.weaponObjectDebug != 1)
	{
		if(isdefined(self.owner) && ent == self.owner)
		{
			return 0;
		}
		if(isVehicle(ent))
		{
			if(watcher.ignoreVehicles)
			{
				return 0;
			}
			if(self.owner === ent.owner)
			{
				return 0;
			}
		}
		if(!friendlyFireCheck(self.owner, ent, 0))
		{
			return 0;
		}
		if(watcher.ignoreVehicles && isai(ent) && (!isdefined(ent.isaiclone) && ent.isaiclone))
		{
			return 0;
		}
	}
	if(LengthSquared(ent GetVelocity()) < 10 && !isdefined(watcher.immediateDetonation))
	{
		return 0;
	}
	if(!ent shouldAffectWeaponObject(self, watcher))
	{
		return 0;
	}
	if(self isStunned())
	{
		return 0;
	}
	if(isPlayer(ent))
	{
		if(!isalive(ent))
		{
			return 0;
		}
		if(isdefined(watcher.immunespecialty) && ent hasPerk(watcher.immunespecialty))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: proximityWeaponObject_RemoveSpawnProtectOnDeath
	Namespace: weaponobjects
	Checksum: 0x74ED0825
	Offset: 0x6FA8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function proximityWeaponObject_RemoveSpawnProtectOnDeath(ent)
{
	self endon("death");
	ent util::waittill_any("death", "disconnected");
	ArrayRemoveValue(self.protected_entities, ent);
}

/*
	Name: proximityWeaponObject_SpawnProtect
	Namespace: weaponobjects
	Checksum: 0x3FFB7002
	Offset: 0x7010
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function proximityWeaponObject_SpawnProtect(watcher, ent)
{
	self endon("death");
	ent endon("death");
	ent endon("disconnect");
	self.protected_entities[self.protected_entities.size] = ent;
	self thread proximityWeaponObject_RemoveSpawnProtectOnDeath(ent);
	radius_sqr = watcher.detonateRadius * watcher.detonateRadius;
	while(1)
	{
		if(DistanceSquared(ent.origin, self.origin) > radius_sqr)
		{
			ArrayRemoveValue(self.protected_entities, ent);
			return;
		}
		wait(0.5);
	}
}

/*
	Name: proximityWeaponObject_IsSpawnProtected
	Namespace: weaponobjects
	Checksum: 0xACDAF6D1
	Offset: 0x7110
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function proximityWeaponObject_IsSpawnProtected(watcher, ent)
{
	if(!isPlayer(ent))
	{
		return 0;
	}
	foreach(protected_ent in self.protected_entities)
	{
		if(protected_ent == ent)
		{
			return 1;
		}
	}
	linked_to = self GetLinkedEnt();
	if(linked_to === ent)
	{
		return 0;
	}
	if(ent player::is_spawn_protected())
	{
		self thread proximityWeaponObject_SpawnProtect(watcher, ent);
		return 1;
	}
	return 0;
}

/*
	Name: proximityWeaponObject_DoDetonation
	Namespace: weaponobjects
	Checksum: 0x23FFA9B9
	Offset: 0x7248
	Size: 0x16F
	Parameters: 3
	Flags: None
*/
function proximityWeaponObject_DoDetonation(watcher, ent, traceOrigin)
{
	self endon("death");
	self endon("hacked");
	self notify("kill_target_detection");
	if(isdefined(watcher.activateSound))
	{
		self playsound(watcher.activateSound);
	}
	wait(watcher.detectionGracePeriod);
	if(isPlayer(ent) && ent hasPerk("specialty_delayexplosive"))
	{
		wait(GetDvarFloat("perk_delayExplosiveTime"));
	}
	self entityheadicons::setEntityHeadIcon("none");
	self.origin = traceOrigin;
	if(isdefined(self.owner) && isPlayer(self.owner))
	{
		self [[watcher.onDetonateCallback]](self.owner, undefined, ent);
	}
	else
	{
		self [[watcher.onDetonateCallback]](undefined, undefined, ent);
	}
}

/*
	Name: proximityWeaponObject_ActivationDelay
	Namespace: weaponobjects
	Checksum: 0x5DC6E7AE
	Offset: 0x73C0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function proximityWeaponObject_ActivationDelay(watcher)
{
	self util::waitTillNotMoving();
	if(watcher.activationDelay)
	{
		wait(watcher.activationDelay);
	}
}

/*
	Name: proximityWeaponObject_WaitTillFrameEndAndDoDetonation
	Namespace: weaponobjects
	Checksum: 0xA415E575
	Offset: 0x7410
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function proximityWeaponObject_WaitTillFrameEndAndDoDetonation(watcher, ent, traceOrigin)
{
	self endon("death");
	dist = Distance(ent.origin, self.origin);
	if(isdefined(self.activated_entity_distance))
	{
		if(dist < self.activated_entity_distance)
		{
			self notify("better_target");
		}
		else
		{
			return;
		}
	}
	self endon("better_target");
	self.activated_entity_distance = dist;
	wait(0.05);
	proximityWeaponObject_DoDetonation(watcher, ent, traceOrigin);
}

/*
	Name: proximityWeaponObjectDetonation
	Namespace: weaponobjects
	Checksum: 0xE488DEE
	Offset: 0x74E0
	Size: 0x157
	Parameters: 1
	Flags: None
*/
function proximityWeaponObjectDetonation(watcher)
{
	self endon("death");
	self endon("hacked");
	self endon("kill_target_detection");
	proximityWeaponObject_ActivationDelay(watcher);
	damagearea = proximityWeaponObject_CreateDamageArea(watcher);
	up = anglesToUp(self.angles);
	traceOrigin = self.origin + up;
	while(1)
	{
		damagearea waittill("trigger", ent);
		if(!proximityWeaponObject_ValidTriggerEntity(watcher, ent))
		{
			continue;
		}
		if(proximityWeaponObject_IsSpawnProtected(watcher, ent))
		{
			continue;
		}
		if(ent damageConeTrace(traceOrigin, self) > 0)
		{
			thread proximityWeaponObject_WaitTillFrameEndAndDoDetonation(watcher, ent, traceOrigin);
		}
	}
}

/*
	Name: shouldAffectWeaponObject
	Namespace: weaponobjects
	Checksum: 0x496DB00E
	Offset: 0x7640
	Size: 0x1A3
	Parameters: 2
	Flags: None
*/
function shouldAffectWeaponObject(object, watcher)
{
	radius = object.weapon.explosionRadius;
	distanceSqr = DistanceSquared(self.origin, object.origin);
	if(radius * radius < distanceSqr)
	{
		return 0;
	}
	pos = self.origin + VectorScale((0, 0, 1), 32);
	if(isdefined(watcher.ignoreDirection))
	{
		return 1;
	}
	dirToPos = pos - object.origin;
	objectForward = AnglesToForward(object.angles);
	dist = VectorDot(dirToPos, objectForward);
	if(dist < watcher.detectionMinDist)
	{
		return 0;
	}
	dirToPos = VectorNormalize(dirToPos);
	dot = VectorDot(dirToPos, objectForward);
	return dot > watcher.detectionDot;
}

/*
	Name: deleteOnDeath
	Namespace: weaponobjects
	Checksum: 0xECD05237
	Offset: 0x77F0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function deleteOnDeath(ent)
{
	self util::waittill_any("death", "hacked");
	wait(0.05);
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: testKillbrushOnStationary
	Namespace: weaponobjects
	Checksum: 0xB3F708D7
	Offset: 0x7858
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function testKillbrushOnStationary(a_killbrushes, player)
{
	player endon("disconnect");
	self endon("death");
	self waittill("stationary");
	foreach(trig in a_killbrushes)
	{
		if(isdefined(trig) && self istouching(trig))
		{
			if(!trig IsTriggerEnabled())
			{
				continue;
			}
			if(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 2 == 2)
			{
				continue;
			}
			if(self.origin[2] > player.origin[2])
			{
				break;
			}
			if(isdefined(self))
			{
				self delete();
			}
			return;
		}
	}
}

/*
	Name: deleteOnKillbrush
	Namespace: weaponobjects
	Checksum: 0xBCF66354
	Offset: 0x79C0
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function deleteOnKillbrush(player)
{
	player endon("disconnect");
	self endon("death");
	self endon("stationary");
	a_killbrushes = GetEntArray("trigger_hurt", "classname");
	self thread testKillbrushOnStationary(a_killbrushes, player);
	while(1)
	{
		a_killbrushes = GetEntArray("trigger_hurt", "classname");
		for(i = 0; i < a_killbrushes.size; i++)
		{
			if(self istouching(a_killbrushes[i]))
			{
				if(!a_killbrushes[i] IsTriggerEnabled())
				{
					continue;
				}
				if(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 2 == 2)
				{
					continue;
				}
				if(self.origin[2] > player.origin[2])
				{
					break;
				}
				if(isdefined(self))
				{
					self delete();
				}
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: watchWeaponObjectAltDetonation
	Namespace: weaponobjects
	Checksum: 0x5CA1C7BF
	Offset: 0x7B58
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function watchWeaponObjectAltDetonation()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("alt_detonate");
		if(!isalive(self) || self util::isUsingRemote())
		{
			continue;
		}
		for(watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++)
		{
			if(self.weaponObjectWatcherArray[watcher].altDetonate)
			{
				self.weaponObjectWatcherArray[watcher] detonateWeaponObjectArray(0);
			}
		}
	}
}

/*
	Name: watchWeaponObjectAltDetonate
	Namespace: weaponobjects
	Checksum: 0xCED61C76
	Offset: 0x7C30
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function watchWeaponObjectAltDetonate()
{
	self endon("disconnect");
	level endon("game_ended");
	buttonTime = 0;
	for(;;)
	{
		self waittill("doubletap_detonate");
		if(!isalive(self) && !self util::isUsingRemote())
		{
			continue;
		}
		self notify("alt_detonate");
		wait(0.05);
	}
}

/*
	Name: watchWeaponObjectDetonation
	Namespace: weaponobjects
	Checksum: 0x4B4CB0EA
	Offset: 0x7CC0
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function watchWeaponObjectDetonation()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("detonate");
		if(self isUsingOffhand())
		{
			weap = self getCurrentOffhand();
		}
		else
		{
			weap = self GetCurrentWeapon();
		}
		watcher = getWeaponObjectWatcherByWeapon(weap);
		if(isdefined(watcher))
		{
			if(isdefined(watcher.onDetonationHandle))
			{
				self thread [[watcher.onDetonationHandle]](watcher);
			}
			watcher detonateWeaponObjectArray(0);
		}
	}
}

/*
	Name: cleanUpWatchers
	Namespace: weaponobjects
	Checksum: 0xD7C6DB4D
	Offset: 0x7DC0
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function cleanUpWatchers()
{
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		/#
			Assert("Dev Block strings are not supported");
		#/
		return;
	}
	watchers = [];
	for(watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++)
	{
		weaponObjectWatcher = spawnstruct();
		watchers[watchers.size] = weaponObjectWatcher;
		weaponObjectWatcher.objectArray = [];
		if(isdefined(self.weaponObjectWatcherArray[watcher].objectArray))
		{
			weaponObjectWatcher.objectArray = self.weaponObjectWatcherArray[watcher].objectArray;
		}
	}
	wait(0.05);
	for(watcher = 0; watcher < watchers.size; watcher++)
	{
		watchers[watcher] deleteWeaponObjectArray();
	}
}

/*
	Name: watchForDisconnectCleanUp
	Namespace: weaponobjects
	Checksum: 0x9003A486
	Offset: 0x7F00
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function watchForDisconnectCleanUp()
{
	self waittill("disconnect");
	cleanUpWatchers();
}

/*
	Name: deleteWeaponObjectsOn
	Namespace: weaponobjects
	Checksum: 0x221BDA1B
	Offset: 0x7F30
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function deleteWeaponObjectsOn()
{
	self thread watchForDisconnectCleanUp();
	self endon("disconnect");
	if(!isPlayer(self))
	{
		return;
	}
	while(1)
	{
		msg = self util::waittill_any_return("joined_team", "joined_spectators", "death", "disconnect");
		if(msg == "death")
		{
			continue;
		}
		cleanUpWatchers();
	}
}

/*
	Name: saydamaged
	Namespace: weaponobjects
	Checksum: 0x199C0A4D
	Offset: 0x7FE8
	Size: 0x6D
	Parameters: 2
	Flags: None
*/
function saydamaged(orig, amount)
{
	/#
		for(i = 0; i < 60; i++)
		{
			print3d(orig, "Dev Block strings are not supported" + amount);
			wait(0.05);
		}
	#/
}

/*
	Name: showHeadIcon
	Namespace: weaponobjects
	Checksum: 0xB75D0F50
	Offset: 0x8060
	Size: 0x29B
	Parameters: 1
	Flags: None
*/
function showHeadIcon(trigger)
{
	triggerDetectId = trigger.detectId;
	useId = -1;
	for(index = 0; index < 4; index++)
	{
		detectId = self.bombSquadIcons[index].detectId;
		if(detectId == triggerDetectId)
		{
			return;
		}
		if(detectId == "")
		{
			useId = index;
		}
	}
	if(useId < 0)
	{
		return;
	}
	self.bombSquadIds[triggerDetectId] = 1;
	self.bombSquadIcons[useId].x = trigger.origin[0];
	self.bombSquadIcons[useId].y = trigger.origin[1];
	self.bombSquadIcons[useId].z = trigger.origin[2] + 24 + 128;
	self.bombSquadIcons[useId] fadeOverTime(0.25);
	self.bombSquadIcons[useId].alpha = 1;
	self.bombSquadIcons[useId].detectId = trigger.detectId;
	while(isalive(self) && isdefined(trigger) && self istouching(trigger))
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	self.bombSquadIcons[useId].detectId = "";
	self.bombSquadIcons[useId] fadeOverTime(0.25);
	self.bombSquadIcons[useId].alpha = 0;
	self.bombSquadIds[triggerDetectId] = undefined;
}

/*
	Name: friendlyFireCheck
	Namespace: weaponobjects
	Checksum: 0x6D5D4A21
	Offset: 0x8308
	Size: 0x22F
	Parameters: 3
	Flags: None
*/
function friendlyFireCheck(owner, attacker, forcedFriendlyFireRule)
{
	if(!isdefined(owner))
	{
		return 1;
	}
	if(!level.teambased)
	{
		return 1;
	}
	friendlyFireRule = [[level.figure_out_friendly_fire]](undefined);
	if(isdefined(forcedFriendlyFireRule))
	{
		friendlyFireRule = forcedFriendlyFireRule;
	}
	if(friendlyFireRule != 0)
	{
		return 1;
	}
	if(attacker == owner)
	{
		return 1;
	}
	if(isPlayer(attacker))
	{
		if(!isdefined(attacker.pers["team"]))
		{
			return 1;
		}
		if(attacker.pers["team"] != owner.pers["team"])
		{
			return 1;
		}
	}
	else if(IsActor(attacker))
	{
		if(attacker.team != owner.pers["team"])
		{
			return 1;
		}
	}
	else if(isVehicle(attacker))
	{
		if(isdefined(attacker.owner) && isPlayer(attacker.owner))
		{
			if(attacker.owner.pers["team"] != owner.pers["team"])
			{
				return 1;
			}
		}
		else
		{
			occupant_team = attacker vehicle::vehicle_get_occupant_team();
			if(occupant_team != owner.pers["team"] && occupant_team != "spectator")
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: onSpawnHatchet
	Namespace: weaponobjects
	Checksum: 0x8F34F670
	Offset: 0x8540
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function onSpawnHatchet(watcher, player)
{
	if(isdefined(level.playThrowHatchet))
	{
		player [[level.playThrowHatchet]]();
	}
}

/*
	Name: onSpawnCrossbowBolt
	Namespace: weaponobjects
	Checksum: 0x1EB4F530
	Offset: 0x8580
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function onSpawnCrossbowBolt(watcher, player)
{
	self.delete_on_death = 1;
	self thread onSpawnCrossbowBolt_internal(watcher, player);
}

/*
	Name: onSpawnCrossbowBolt_internal
	Namespace: weaponobjects
	Checksum: 0x9F901473
	Offset: 0x85C8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function onSpawnCrossbowBolt_internal(watcher, player)
{
	player endon("disconnect");
	self endon("death");
	wait(0.25);
	linkedEnt = self GetLinkedEnt();
	if(!isdefined(linkedEnt) || !isVehicle(linkedEnt))
	{
		self.takedamage = 0;
	}
	else
	{
		self.takedamage = 1;
		if(isVehicle(linkedEnt))
		{
			self thread dieOnEntityDeath(linkedEnt, player);
		}
	}
}

/*
	Name: dieOnEntityDeath
	Namespace: weaponobjects
	Checksum: 0xC3E90E6
	Offset: 0x86A8
	Size: 0x95
	Parameters: 2
	Flags: None
*/
function dieOnEntityDeath(entity, player)
{
	player endon("disconnect");
	self endon("death");
	alreadyDead = entity.dead === 1 || (isdefined(entity.health) && entity.health < 0);
	if(!alreadyDead)
	{
		entity waittill("death");
	}
	self notify("death");
}

/*
	Name: onSpawnCrossbowBoltImpact
	Namespace: weaponobjects
	Checksum: 0x20A3C85E
	Offset: 0x8748
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function onSpawnCrossbowBoltImpact(s_watcher, e_player)
{
	self.delete_on_death = 1;
	self thread onSpawnCrossbowBoltImpact_internal(s_watcher, e_player);
}

/*
	Name: onSpawnCrossbowBoltImpact_internal
	Namespace: weaponobjects
	Checksum: 0x7ADE11B
	Offset: 0x8790
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function onSpawnCrossbowBoltImpact_internal(s_watcher, e_player)
{
	self endon("death");
	e_player endon("disconnect");
	self waittill("stationary");
	s_watcher thread waitAndFizzleOut(self, 0);
	foreach(e_object in s_watcher.objectArray)
	{
		if(self == e_object)
		{
			s_watcher.objectArray[n_index] = undefined;
		}
	}
	cleanWeaponObjectArray(s_watcher);
}

/*
	Name: onSpawnSpecialCrossbowTrigger
	Namespace: weaponobjects
	Checksum: 0xC5177EB5
	Offset: 0x88A0
	Size: 0x31B
	Parameters: 2
	Flags: None
*/
function onSpawnSpecialCrossbowTrigger(watcher, player)
{
	self endon("death");
	self SetOwner(player);
	self SetTeam(player.pers["team"]);
	self.owner = player;
	self.oldAngles = self.angles;
	self util::waitTillNotMoving();
	waittillframeend;
	if(player.pers["team"] == "spectator")
	{
		return;
	}
	triggerOrigin = self.origin;
	triggerParentEnt = undefined;
	if(isdefined(self.stuckToPlayer))
	{
		if(isalive(self.stuckToPlayer) || !isdefined(self.stuckToPlayer.body))
		{
			if(isalive(self.stuckToPlayer))
			{
				triggerParentEnt = self;
				self Unlink();
				self.angles = self.oldAngles;
				self launch(VectorScale((1, 1, 1), 5));
				self util::waitTillNotMoving();
				waittillframeend;
			}
			else
			{
				triggerParentEnt = self.stuckToPlayer;
			}
		}
		else
		{
			triggerParentEnt = self.stuckToPlayer.body;
		}
	}
	if(isdefined(triggerParentEnt))
	{
		triggerOrigin = triggerParentEnt.origin + VectorScale((0, 0, 1), 10);
	}
	if(self.weapon.ShownRetrievable)
	{
		self clientfield::set("retrievable", 1);
	}
	self.hatchetPickUpTrigger = spawn("trigger_radius", triggerOrigin, 0, 50, 50);
	self.hatchetPickUpTrigger EnableLinkTo();
	self.hatchetPickUpTrigger LinkTo(self);
	if(isdefined(triggerParentEnt))
	{
		self.hatchetPickUpTrigger LinkTo(triggerParentEnt);
	}
	self thread watchSpecialCrossbowTrigger(self.hatchetPickUpTrigger, watcher.pickup, watcher.pickUpSoundPlayer, watcher.pickUpSound);
	/#
		thread switch_team(self, watcher, player);
	#/
	self thread WatchShutdown(player);
}

/*
	Name: watchSpecialCrossbowTrigger
	Namespace: weaponobjects
	Checksum: 0x3E871BE9
	Offset: 0x8BC8
	Size: 0x185
	Parameters: 4
	Flags: None
*/
function watchSpecialCrossbowTrigger(trigger, callback, playerSoundOnUse, npcSoundOnUse)
{
	self endon("delete");
	self endon("hacked");
	while(1)
	{
		trigger waittill("trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(isdefined(trigger.ClaimedBy) && player != trigger.ClaimedBy)
		{
			continue;
		}
		crossbow_weapon = player get_player_crossbow_weapon();
		if(!isdefined(crossbow_weapon))
		{
			continue;
		}
		stock_ammo = player GetWeaponAmmoStock(crossbow_weapon);
		if(stock_ammo >= crossbow_weapon.maxAmmo)
		{
			continue;
		}
		if(isdefined(playerSoundOnUse))
		{
			player playlocalsound(playerSoundOnUse);
		}
		if(isdefined(npcSoundOnUse))
		{
			player playsound(npcSoundOnUse);
		}
		self thread [[callback]](player, crossbow_weapon);
	}
}

/*
	Name: onSpawnHatchetTrigger
	Namespace: weaponobjects
	Checksum: 0x13227FC
	Offset: 0x8D58
	Size: 0x31B
	Parameters: 2
	Flags: None
*/
function onSpawnHatchetTrigger(watcher, player)
{
	self endon("death");
	self SetOwner(player);
	self SetTeam(player.pers["team"]);
	self.owner = player;
	self.oldAngles = self.angles;
	self util::waitTillNotMoving();
	waittillframeend;
	if(player.pers["team"] == "spectator")
	{
		return;
	}
	triggerOrigin = self.origin;
	triggerParentEnt = undefined;
	if(isdefined(self.stuckToPlayer))
	{
		if(isalive(self.stuckToPlayer) || !isdefined(self.stuckToPlayer.body))
		{
			if(isalive(self.stuckToPlayer))
			{
				triggerParentEnt = self;
				self Unlink();
				self.angles = self.oldAngles;
				self launch(VectorScale((1, 1, 1), 5));
				self util::waitTillNotMoving();
				waittillframeend;
			}
			else
			{
				triggerParentEnt = self.stuckToPlayer;
			}
		}
		else
		{
			triggerParentEnt = self.stuckToPlayer.body;
		}
	}
	if(isdefined(triggerParentEnt))
	{
		triggerOrigin = triggerParentEnt.origin + VectorScale((0, 0, 1), 10);
	}
	if(self.weapon.ShownRetrievable)
	{
		self clientfield::set("retrievable", 1);
	}
	self.hatchetPickUpTrigger = spawn("trigger_radius", triggerOrigin, 0, 50, 50);
	self.hatchetPickUpTrigger EnableLinkTo();
	self.hatchetPickUpTrigger LinkTo(self);
	if(isdefined(triggerParentEnt))
	{
		self.hatchetPickUpTrigger LinkTo(triggerParentEnt);
	}
	self thread watchHatchetTrigger(self.hatchetPickUpTrigger, watcher.pickup, watcher.pickUpSoundPlayer, watcher.pickUpSound);
	/#
		thread switch_team(self, watcher, player);
	#/
	self thread WatchShutdown(player);
}

/*
	Name: watchHatchetTrigger
	Namespace: weaponobjects
	Checksum: 0x4317A9B4
	Offset: 0x9080
	Size: 0x281
	Parameters: 4
	Flags: None
*/
function watchHatchetTrigger(trigger, callback, playerSoundOnUse, npcSoundOnUse)
{
	self endon("delete");
	self endon("hacked");
	while(1)
	{
		trigger waittill("trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player IsOnGround() && !player IsPlayerSwimming())
		{
			continue;
		}
		if(isdefined(trigger.ClaimedBy) && player != trigger.ClaimedBy)
		{
			continue;
		}
		heldWeapon = player get_held_weapon_match_or_root_match(self.weapon);
		if(!isdefined(heldWeapon))
		{
			continue;
		}
		maxAmmo = 0;
		if(heldWeapon == player.grenadeTypePrimary && isdefined(player.grenadeTypePrimaryCount) && player.grenadeTypePrimaryCount > 0)
		{
			maxAmmo = player.grenadeTypePrimaryCount;
		}
		else if(heldWeapon == player.grenadeTypeSecondary && isdefined(player.grenadeTypeSecondaryCount) && player.grenadeTypeSecondaryCount > 0)
		{
			maxAmmo = player.grenadeTypeSecondaryCount;
		}
		if(maxAmmo == 0)
		{
			continue;
		}
		clip_ammo = player GetWeaponAmmoClip(heldWeapon);
		if(clip_ammo >= maxAmmo)
		{
			continue;
		}
		if(isdefined(playerSoundOnUse))
		{
			player playlocalsound(playerSoundOnUse);
		}
		if(isdefined(npcSoundOnUse))
		{
			player playsound(npcSoundOnUse);
		}
		self thread [[callback]](player);
	}
}

/*
	Name: get_held_weapon_match_or_root_match
	Namespace: weaponobjects
	Checksum: 0x77A9C063
	Offset: 0x9310
	Size: 0x13D
	Parameters: 1
	Flags: None
*/
function get_held_weapon_match_or_root_match(weapon)
{
	pweapons = self GetWeaponsList(1);
	foreach(pweapon in pweapons)
	{
		if(pweapon == weapon)
		{
			return pweapon;
		}
	}
	foreach(pweapon in pweapons)
	{
		if(pweapon.rootweapon == weapon.rootweapon)
		{
			return pweapon;
		}
	}
	return undefined;
}

/*
	Name: get_player_crossbow_weapon
	Namespace: weaponobjects
	Checksum: 0xDB9CA7D
	Offset: 0x9458
	Size: 0x11D
	Parameters: 0
	Flags: None
*/
function get_player_crossbow_weapon()
{
	pweapons = self GetWeaponsList(1);
	crossbow = GetWeapon("special_crossbow");
	crossbow_dw = GetWeapon("special_crossbow_dw");
	foreach(pweapon in pweapons)
	{
		if(pweapon.rootweapon == crossbow || pweapon.rootweapon == crossbow_dw)
		{
			return pweapon;
		}
	}
	return undefined;
}

/*
	Name: onSpawnRetrievableWeaponObject
	Namespace: weaponobjects
	Checksum: 0x48C8AD67
	Offset: 0x9580
	Size: 0x60B
	Parameters: 2
	Flags: None
*/
function onSpawnRetrievableWeaponObject(watcher, player)
{
	self endon("death");
	self endon("hacked");
	self SetOwner(player);
	self SetTeam(player.pers["team"]);
	self.owner = player;
	self.oldAngles = self.angles;
	self util::waitTillNotMoving();
	if(watcher.activationDelay)
	{
		wait(watcher.activationDelay);
	}
	waittillframeend;
	if(player.pers["team"] == "spectator")
	{
		return;
	}
	triggerOrigin = self.origin;
	triggerParentEnt = undefined;
	if(isdefined(self.stuckToPlayer))
	{
		if(isalive(self.stuckToPlayer) || !isdefined(self.stuckToPlayer.body))
		{
			triggerParentEnt = self.stuckToPlayer;
		}
		else
		{
			triggerParentEnt = self.stuckToPlayer.body;
		}
	}
	if(isdefined(triggerParentEnt))
	{
		triggerOrigin = triggerParentEnt.origin + VectorScale((0, 0, 1), 10);
	}
	else
	{
		up = anglesToUp(self.angles);
		triggerOrigin = self.origin + up;
	}
	if(!self util::isHacked())
	{
		if(self.weapon.ShownRetrievable)
		{
			self clientfield::set("retrievable", 1);
		}
		self.pickupTrigger = spawn("trigger_radius_use", triggerOrigin);
		self.pickupTrigger SetHintLowPriority(1);
		self.pickupTrigger setcursorhint("HINT_NOICON", self);
		self.pickupTrigger EnableLinkTo();
		self.pickupTrigger LinkTo(self);
		self.pickupTrigger SetInvisibleToAll();
		self.pickupTrigger SetVisibleToPlayer(player);
		if(isdefined(level.retrieveHints[watcher.name]))
		{
			self.pickupTrigger setHintString(level.retrieveHints[watcher.name].hint);
		}
		else
		{
			self.pickupTrigger setHintString(&"MP_GENERIC_PICKUP");
		}
		self.pickupTrigger SetTeamForTrigger(player.pers["team"]);
		if(isdefined(triggerParentEnt))
		{
			self.pickupTrigger LinkTo(triggerParentEnt);
		}
		self thread watchUseTrigger(self.pickupTrigger, watcher.pickup, watcher.pickUpSoundPlayer, watcher.pickUpSound);
		if(isdefined(watcher.pickup_trigger_listener))
		{
			self thread [[watcher.pickup_trigger_listener]](self.pickupTrigger, player);
		}
	}
	if(watcher.enemyDestroy)
	{
		self.enemyTrigger = spawn("trigger_radius_use", triggerOrigin);
		self.enemyTrigger setcursorhint("HINT_NOICON", self);
		self.enemyTrigger EnableLinkTo();
		self.enemyTrigger LinkTo(self);
		self.enemyTrigger SetInvisibleToPlayer(player);
		if(level.teambased)
		{
			self.enemyTrigger SetExcludeTeamForTrigger(player.team);
			self.enemyTrigger.triggerTeamIgnore = self.team;
		}
		if(isdefined(level.destroyHints[watcher.name]))
		{
			self.enemyTrigger setHintString(level.destroyHints[watcher.name].hint);
		}
		else
		{
			self.enemyTrigger setHintString(&"MP_GENERIC_DESTROY");
		}
		self thread watchUseTrigger(self.enemyTrigger, watcher.onDestroyed);
	}
	/#
		thread switch_team(self, watcher, player);
	#/
	self thread WatchShutdown(player);
}

/*
	Name: destroyEnt
	Namespace: weaponobjects
	Checksum: 0x1B3A93A8
	Offset: 0x9B98
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function destroyEnt()
{
	self delete();
}

/*
	Name: pickup
	Namespace: weaponobjects
	Checksum: 0xE8FC221D
	Offset: 0x9BC0
	Size: 0x26B
	Parameters: 1
	Flags: None
*/
function pickup(player)
{
	if(!self.weapon.anyPlayerCanRetrieve && isdefined(self.owner) && self.owner != player)
	{
		return;
	}
	pikedWeapon = self.weapon;
	if(self.weapon.ammoCountEquipment > 0 && isdefined(self.ammo))
	{
		ammoLeftEquipment = self.ammo;
	}
	self notify("picked_up");
	self.playDialog = 0;
	self destroyEnt();
	heldWeapon = player get_held_weapon_match_or_root_match(self.weapon);
	if(!isdefined(heldWeapon))
	{
		return;
	}
	maxAmmo = 0;
	if(heldWeapon == player.grenadeTypePrimary && isdefined(player.grenadeTypePrimaryCount) && player.grenadeTypePrimaryCount > 0)
	{
		maxAmmo = player.grenadeTypePrimaryCount;
	}
	else if(heldWeapon == player.grenadeTypeSecondary && isdefined(player.grenadeTypeSecondaryCount) && player.grenadeTypeSecondaryCount > 0)
	{
		maxAmmo = player.grenadeTypeSecondaryCount;
	}
	if(maxAmmo == 0)
	{
		return;
	}
	clip_ammo = player GetWeaponAmmoClip(heldWeapon);
	if(clip_ammo < maxAmmo)
	{
		clip_ammo++;
	}
	if(isdefined(ammoLeftEquipment))
	{
		if(pikedWeapon.rootweapon == GetWeapon("trophy_system"))
		{
			player trophy_system::ammo_weapon_pickup(ammoLeftEquipment);
		}
	}
	player SetWeaponAmmoClip(heldWeapon, clip_ammo);
}

/*
	Name: pickUpCrossbowBolt
	Namespace: weaponobjects
	Checksum: 0xAC2F0E17
	Offset: 0x9E38
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function pickUpCrossbowBolt(player, heldWeapon)
{
	self notify("picked_up");
	self.playDialog = 0;
	self destroyEnt();
	stock_ammo = player GetWeaponAmmoStock(heldWeapon);
	stock_ammo++;
	player SetWeaponAmmoStock(heldWeapon, stock_ammo);
}

/*
	Name: onDestroyed
	Namespace: weaponobjects
	Checksum: 0x55B06FB1
	Offset: 0x9ED0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function onDestroyed(attacker)
{
	playFX(level._effect["tacticalInsertionFizzle"], self.origin);
	self playsound("dst_tac_insert_break");
	if(isdefined(level.playEquipmentDestroyedOnPlayer))
	{
		self.owner [[level.playEquipmentDestroyedOnPlayer]]();
	}
	self delete();
}

/*
	Name: WatchShutdown
	Namespace: weaponobjects
	Checksum: 0x4C7878EE
	Offset: 0x9F70
	Size: 0x15B
	Parameters: 1
	Flags: None
*/
function WatchShutdown(player)
{
	self util::waittill_any("death", "hacked", "detonating");
	pickupTrigger = self.pickupTrigger;
	hackertrigger = self.hackertrigger;
	hatchetPickUpTrigger = self.hatchetPickUpTrigger;
	enemyTrigger = self.enemyTrigger;
	if(isdefined(pickupTrigger))
	{
		pickupTrigger delete();
	}
	if(isdefined(hackertrigger))
	{
		if(isdefined(hackertrigger.progressbar))
		{
			hackertrigger.progressbar hud::destroyElem();
			hackertrigger.progressText hud::destroyElem();
		}
		hackertrigger delete();
	}
	if(isdefined(hatchetPickUpTrigger))
	{
		hatchetPickUpTrigger delete();
	}
	if(isdefined(enemyTrigger))
	{
		enemyTrigger delete();
	}
}

/*
	Name: watchUseTrigger
	Namespace: weaponobjects
	Checksum: 0xA88D1CBE
	Offset: 0xA0D8
	Size: 0x259
	Parameters: 4
	Flags: None
*/
function watchUseTrigger(trigger, callback, playerSoundOnUse, npcSoundOnUse)
{
	self endon("delete");
	self endon("hacked");
	while(1)
	{
		trigger waittill("trigger", player);
		if(isdefined(self.detonated) && self.detonated == 1)
		{
			if(isdefined(trigger))
			{
				trigger delete();
			}
			return;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(isdefined(trigger.triggerTeam) && player.pers["team"] != trigger.triggerTeam)
		{
			continue;
		}
		if(isdefined(trigger.triggerTeamIgnore) && player.team == trigger.triggerTeamIgnore)
		{
			continue;
		}
		if(isdefined(trigger.ClaimedBy) && player != trigger.ClaimedBy)
		{
			continue;
		}
		grenade = player.throwingGrenade;
		weapon = player GetCurrentWeapon();
		if(weapon.isEquipment)
		{
			grenade = 0;
		}
		if(player useButtonPressed() && !grenade && !player meleeButtonPressed())
		{
			if(isdefined(playerSoundOnUse))
			{
				player playlocalsound(playerSoundOnUse);
			}
			if(isdefined(npcSoundOnUse))
			{
				player playsound(npcSoundOnUse);
			}
			self thread [[callback]](player);
		}
	}
}

/*
	Name: createRetrievableHint
	Namespace: weaponobjects
	Checksum: 0xE8D3B64E
	Offset: 0xA340
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function createRetrievableHint(name, hint)
{
	retrieveHint = spawnstruct();
	retrieveHint.name = name;
	retrieveHint.hint = hint;
	level.retrieveHints[name] = retrieveHint;
}

/*
	Name: createHackerHint
	Namespace: weaponobjects
	Checksum: 0xEE07352A
	Offset: 0xA3B8
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function createHackerHint(name, hint)
{
	hackerHint = spawnstruct();
	hackerHint.name = name;
	hackerHint.hint = hint;
	level.hackerHints[name] = hackerHint;
}

/*
	Name: createDestroyHint
	Namespace: weaponobjects
	Checksum: 0xE0EB667B
	Offset: 0xA430
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function createDestroyHint(name, hint)
{
	destroyHint = spawnstruct();
	destroyHint.name = name;
	destroyHint.hint = hint;
	level.destroyHints[name] = destroyHint;
}

/*
	Name: setupReconEffect
	Namespace: weaponobjects
	Checksum: 0x10424D35
	Offset: 0xA4A8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function setupReconEffect()
{
	if(!isdefined(self))
	{
		return;
	}
	if(self.weapon.ShownEnemyExplo || self.weapon.ShownEnemyEquip)
	{
		if(isdefined(self.hacked) && self.hacked)
		{
			self clientfield::set("enemyequip", 2);
		}
		else
		{
			self clientfield::set("enemyequip", 1);
		}
	}
}

/*
	Name: useTeamEquipmentClientField
	Namespace: weaponobjects
	Checksum: 0x7667216F
	Offset: 0xA548
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function useTeamEquipmentClientField(watcher)
{
	if(isdefined(watcher))
	{
		if(!isdefined(watcher.notEquipment))
		{
			if(isdefined(self))
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: getWatcherForWeapon
	Namespace: weaponobjects
	Checksum: 0x56F47BA6
	Offset: 0xA588
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function getWatcherForWeapon(weapon)
{
	if(!isdefined(self))
	{
		return undefined;
	}
	if(!isPlayer(self))
	{
		return undefined;
	}
	for(i = 0; i < self.weaponObjectWatcherArray.size; i++)
	{
		if(self.weaponObjectWatcherArray[i].weapon != weapon)
		{
			continue;
		}
		return self.weaponObjectWatcherArray[i];
	}
	return undefined;
}

/*
	Name: destroy_other_teams_supplemental_watcher_objects
	Namespace: weaponobjects
	Checksum: 0xD4A3D6CE
	Offset: 0xA628
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function destroy_other_teams_supplemental_watcher_objects(attacker, weapon)
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(team == attacker.team)
			{
				continue;
			}
			destroy_supplemental_watcher_objects(attacker, team, weapon);
		}
	}
	destroy_supplemental_watcher_objects(attacker, "free", weapon);
}

/*
	Name: destroy_supplemental_watcher_objects
	Namespace: weaponobjects
	Checksum: 0x99C5D786
	Offset: 0xA720
	Size: 0x17D
	Parameters: 3
	Flags: None
*/
function destroy_supplemental_watcher_objects(attacker, team, weapon)
{
	foreach(item in level.supplementalWatcherObjects)
	{
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
		watcher = item.owner getWatcherForWeapon(item.weapon);
		if(!isdefined(watcher) || !isdefined(watcher.onSupplementalDetonateCallback))
		{
			continue;
		}
		item thread [[watcher.onSupplementalDetonateCallback]]();
	}
}

/*
	Name: add_supplemental_object
	Namespace: weaponobjects
	Checksum: 0x54675ACA
	Offset: 0xA8A8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function add_supplemental_object(object)
{
	level.supplementalWatcherObjects[level.supplementalWatcherObjects.size] = object;
	object thread watch_supplemental_object_death();
}

/*
	Name: watch_supplemental_object_death
	Namespace: weaponobjects
	Checksum: 0x52B5CA6C
	Offset: 0xA8F0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function watch_supplemental_object_death()
{
	self waittill("death");
	ArrayRemoveValue(level.supplementalWatcherObjects, self);
}

/*
	Name: switch_team
	Namespace: weaponobjects
	Checksum: 0x7B0A97FC
	Offset: 0xA928
	Size: 0x197
	Parameters: 3
	Flags: None
*/
function switch_team(entity, watcher, owner)
{
	/#
		self notify("stop_disarmthink");
		self endon("stop_disarmthink");
		self endon("death");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		while(1)
		{
			wait(0.5);
			devgui_int = GetDvarInt("Dev Block strings are not supported");
			if(devgui_int != 0)
			{
				team = "Dev Block strings are not supported";
				if(isdefined(level.getEnemyTeam) && isdefined(owner) && isdefined(owner.team))
				{
					team = [[level.getEnemyTeam]](owner.team);
				}
				if(isdefined(level.devOnGetOrMakeBot))
				{
					player = [[level.devOnGetOrMakeBot]](team);
				}
				if(!isdefined(player))
				{
					println("Dev Block strings are not supported");
					wait(1);
					continue;
				}
				entity ItemHacked(watcher, player);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
		}
	#/
}

