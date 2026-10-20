#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm;
#using scripts\zm\_zm_elemental_zombies;

#namespace electroball_grenade;

/*
	Name: __init__sytem__
	Namespace: electroball_grenade
	Checksum: 0xEF440EA4
	Offset: 0x460
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("electroball_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: electroball_grenade
	Checksum: 0xD082B3C6
	Offset: 0x4A0
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.proximityGrenadeDetectionRadius = GetDvarInt("scr_proximityGrenadeDetectionRadius", 180);
	level.proximityGrenadeGracePeriod = GetDvarFloat("scr_proximityGrenadeGracePeriod", 0.05);
	level.proximityGrenadeDOTDamageAmount = GetDvarInt("scr_proximityGrenadeDOTDamageAmount", 1);
	level.proximityGrenadeDOTDamageAmountHardcore = GetDvarInt("scr_proximityGrenadeDOTDamageAmountHardcore", 1);
	level.proximityGrenadeDOTDamageTime = GetDvarFloat("scr_proximityGrenadeDOTDamageTime", 0.2);
	level.proximityGrenadeDOTDamageInstances = GetDvarInt("scr_proximityGrenadeDOTDamageInstances", 4);
	level.proximityGrenadeActivationTime = GetDvarFloat("scr_proximityGrenadeActivationTime", 0.1);
	level.proximityGrenadeProtectedTime = GetDvarFloat("scr_proximityGrenadeProtectedTime", 0.45);
	level thread register();
	if(!isdefined(level.spawnProtectionTimeMS))
	{
		level.spawnProtectionTimeMS = 0;
	}
	callback::on_spawned(&on_player_spawned);
	callback::on_ai_spawned(&on_ai_spawned);
	zm::register_actor_damage_callback(&function_f338543f);
}

/*
	Name: register
	Namespace: electroball_grenade
	Checksum: 0xA069323F
	Offset: 0x680
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("toplayer", "tazered", 1, 1, "int");
	clientfield::register("actor", "electroball_make_sparky", 1, 1, "int");
	clientfield::register("missile", "electroball_stop_trail", 1, 1, "int");
	clientfield::register("missile", "electroball_play_landed_fx", 1, 1, "int");
	clientfield::register("allplayers", "electroball_shock", 1, 1, "int");
}

/*
	Name: createelectroballgrenadewatcher
	Namespace: electroball_grenade
	Checksum: 0xEB7E7A82
	Offset: 0x780
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function createelectroballgrenadewatcher()
{
	if(isPlayer(self))
	{
		watcher = self weaponobjects::createProximityWeaponObjectWatcher("electroball_grenade", self.team);
	}
	else
	{
		watcher = self weaponobjects::createProximityWeaponObjectWatcher("electroball_grenade", level.zombie_team);
	}
	watcher.watchForFire = 1;
	watcher.hackable = 0;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headicon = 0;
	watcher.activateFx = 1;
	watcher.ownerGetsAssist = 1;
	watcher.ignoreDirection = 1;
	watcher.immediateDetonation = 1;
	watcher.detectionGracePeriod = 0.05;
	watcher.detonateRadius = 64;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.onDetonateCallback = &proximityDetonate;
	watcher.activationDelay = 0.05;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.immunespecialty = "specialty_immunetriggershock";
	watcher.onSpawn = &onspawnelectroballgrenadeweaponobject;
}

/*
	Name: onspawnelectroballgrenadeweaponobject
	Namespace: electroball_grenade
	Checksum: 0x1DC745D6
	Offset: 0x980
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function onspawnelectroballgrenadeweaponobject(watcher, owner)
{
	self thread setupKillCamEnt();
	if(isPlayer(owner))
	{
		owner addweaponstat(self.weapon, "used", 1);
	}
	if(isdefined(self.weapon) && self.weapon.proximityDetonation > 0)
	{
		watcher.detonateRadius = self.weapon.proximityDetonation;
	}
	weaponobjects::onSpawnProximityWeaponObject(watcher, owner);
	self thread function_cb55123a();
	self thread function_658aacad();
}

/*
	Name: setupKillCamEnt
	Namespace: electroball_grenade
	Checksum: 0x6F9FA867
	Offset: 0xA80
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function setupKillCamEnt()
{
	self endon("death");
	self util::waitTillNotMoving();
	self.killCamEnt = spawn("script_model", self.origin + VectorScale((0, 0, 1), 8));
	self thread cleanupKillCamEntOnDeath();
}

/*
	Name: cleanupKillCamEntOnDeath
	Namespace: electroball_grenade
	Checksum: 0x2920A750
	Offset: 0xB00
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function cleanupKillCamEntOnDeath()
{
	self waittill("death");
	self.killCamEnt util::deleteAfterTime(4 + level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances);
}

/*
	Name: proximityDetonate
	Namespace: electroball_grenade
	Checksum: 0xD6755CE1
	Offset: 0xB50
	Size: 0x33
	Parameters: 3
	Flags: None
*/
function proximityDetonate(attacker, weapon, target)
{
	weaponobjects::weaponDetonate(attacker, weapon);
}

/*
	Name: watchProximityGrenadeHitPlayer
	Namespace: electroball_grenade
	Checksum: 0x1B01F084
	Offset: 0xB90
	Size: 0x111
	Parameters: 1
	Flags: None
*/
function watchProximityGrenadeHitPlayer(owner)
{
	self endon("death");
	self SetTeam(owner.team);
	while(1)
	{
		self waittill("grenade_bounce", pos, normal, ent, surface);
		if(isdefined(ent) && isPlayer(ent) && surface != "riotshield")
		{
			if(level.teambased && ent.team == self.owner.team)
			{
				continue;
			}
			self proximityDetonate(self.owner, self.weapon);
			return;
		}
	}
}

/*
	Name: performHudEffects
	Namespace: electroball_grenade
	Checksum: 0x798E4938
	Offset: 0xCB0
	Size: 0x13F
	Parameters: 2
	Flags: None
*/
function performHudEffects(position, distanceToGrenade)
{
	forwardVec = VectorNormalize(AnglesToForward(self.angles));
	rightVec = VectorNormalize(AnglesToRight(self.angles));
	explosionVec = VectorNormalize(position - self.origin);
	fDot = VectorDot(explosionVec, forwardVec);
	rDot = VectorDot(explosionVec, rightVec);
	fAngle = ACos(fDot);
	rAngle = ACos(rDot);
}

/*
	Name: function_62ffcc2c
	Namespace: electroball_grenade
	Checksum: 0xC5C80DF8
	Offset: 0xDF8
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_62ffcc2c()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("damage", damage, eAttacker, dir, point, type, model, tag, part, weapon, flags);
		if(weapon.name == "electroball_grenade")
		{
			self damagePlayerInRadius(eAttacker);
		}
		wait(0.05);
	}
}

/*
	Name: damagePlayerInRadius
	Namespace: electroball_grenade
	Checksum: 0xD6E50DDB
	Offset: 0xEE8
	Size: 0x1F3
	Parameters: 1
	Flags: None
*/
function damagePlayerInRadius(eAttacker)
{
	self notify("proximityGrenadeDamageStart");
	self endon("proximityGrenadeDamageStart");
	self endon("disconnect");
	self endon("death");
	eAttacker endon("disconnect");
	self clientfield::set("electroball_shock", 1);
	g_time = GetTime();
	if(self util::mayApplyScreenEffect())
	{
		self.lastShockedBy = eAttacker;
		self.shockEndTime = GetTime() + 100;
		self shellshock("electrocution", 0.1);
		self clientfield::set_to_player("tazered", 1);
	}
	self PlayRumbleOnEntity("proximity_grenade");
	self playsound("wpn_taser_mine_zap");
	if(!self hasPerk("specialty_proximityprotection"))
	{
		self thread watch_death();
		self util::show_hud(0);
		if(GetTime() - g_time < 100)
		{
			wait(GetTime() - g_time / 1000);
		}
		self util::show_hud(1);
	}
	else
	{
		wait(level.proximityGrenadeProtectedTime);
	}
	self clientfield::set_to_player("tazered", 0);
}

/*
	Name: proximityDeathWait
	Namespace: electroball_grenade
	Checksum: 0x85A5BE4B
	Offset: 0x10E8
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function proximityDeathWait(owner)
{
	self waittill("death");
	self notify("deleteSound");
}

/*
	Name: deleteEntOnOwnerDeath
	Namespace: electroball_grenade
	Checksum: 0xB00FE670
	Offset: 0x1118
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function deleteEntOnOwnerDeath(owner)
{
	self thread deleteEntOnTimeout();
	self thread deleteEntAfterTime();
	self endon("delete");
	owner waittill("death");
	self notify("deleteSound");
}

/*
	Name: deleteEntAfterTime
	Namespace: electroball_grenade
	Checksum: 0xA0B40048
	Offset: 0x1188
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function deleteEntAfterTime()
{
	self endon("delete");
	wait(10);
	self notify("deleteSound");
}

/*
	Name: deleteEntOnTimeout
	Namespace: electroball_grenade
	Checksum: 0xB723F0C8
	Offset: 0x11B8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function deleteEntOnTimeout()
{
	self endon("delete");
	self waittill("deleteSound");
	self delete();
}

/*
	Name: watch_death
	Namespace: electroball_grenade
	Checksum: 0x61DE7695
	Offset: 0x11F8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function watch_death()
{
	self endon("disconnect");
	self notify("proximity_cleanup");
	self endon("proximity_cleanup");
	self waittill("death");
	self StopRumble("proximity_grenade");
	self setblur(0, 0);
	self util::show_hud(1);
	self clientfield::set_to_player("tazered", 0);
}

/*
	Name: on_player_spawned
	Namespace: electroball_grenade
	Checksum: 0x7B03D475
	Offset: 0x12A8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	if(isPlayer(self))
	{
		self thread createelectroballgrenadewatcher();
		self thread begin_other_grenade_tracking();
		self thread function_62ffcc2c();
	}
}

/*
	Name: on_ai_spawned
	Namespace: electroball_grenade
	Checksum: 0x31FEE244
	Offset: 0x1318
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function on_ai_spawned()
{
	if(self.archetype === "mechz")
	{
		self thread createelectroballgrenadewatcher();
		self thread begin_other_grenade_tracking();
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: electroball_grenade
	Checksum: 0x220AD969
	Offset: 0x1368
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function begin_other_grenade_tracking()
{
	self endon("death");
	self endon("disconnect");
	self notify("proximityTrackingStart");
	self endon("proximityTrackingStart");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon, cookTime);
		if(weapon.rootweapon.name == "electroball_grenade")
		{
			grenade thread watchProximityGrenadeHitPlayer(self);
		}
	}
}

/*
	Name: function_cb55123a
	Namespace: electroball_grenade
	Checksum: 0x381721A4
	Offset: 0x1418
	Size: 0x217
	Parameters: 0
	Flags: None
*/
function function_cb55123a()
{
	self endon("death");
	self endon("disconnect");
	self endon("delete");
	self waittill("grenade_bounce");
	while(1)
	{
		var_82aacc64 = zm_elemental_zombie::function_d41418b8();
		var_82aacc64 = ArraySortClosest(var_82aacc64, self.origin);
		var_199ecc3a = zm_elemental_zombie::function_4aeed0a5("sparky");
		if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
		{
			if(!isdefined(level.var_a9284ac8) || GetTime() - level.var_a9284ac8 >= 0.5)
			{
				foreach(ai_zombie in var_82aacc64)
				{
					dist_sq = DistanceSquared(self.origin, ai_zombie.origin);
					if(dist_sq <= 9216 && ai_zombie.is_elemental_zombie !== 1 && ai_zombie.var_3531cf2b !== 1)
					{
						ai_zombie clientfield::set("electroball_make_sparky", 1);
						ai_zombie zm_elemental_zombie::function_1b1bb1b();
						level.var_a9284ac8 = GetTime();
						break;
					}
				}
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_658aacad
	Namespace: electroball_grenade
	Checksum: 0x8AE465E
	Offset: 0x1638
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_658aacad()
{
	self endon("death");
	self endon("disconnect");
	self endon("delete");
	self waittill("grenade_bounce");
	self clientfield::set("electroball_stop_trail", 1);
	self SetModel("tag_origin");
	self clientfield::set("electroball_play_landed_fx", 1);
	if(!isdefined(level.a_electroball_grenades))
	{
		level.a_electroball_grenades = [];
	}
	Array::add(level.a_electroball_grenades, self);
}

/*
	Name: function_f338543f
	Namespace: electroball_grenade
	Checksum: 0x35FDC775
	Offset: 0x1708
	Size: 0xCF
	Parameters: 12
	Flags: None
*/
function function_f338543f(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(isdefined(weapon) && weapon.rootweapon.name === "electroball_grenade")
	{
		if(isdefined(attacker) && self.team === attacker.team)
		{
			return 0;
		}
		if(self.var_3531cf2b === 1)
		{
			return 0;
		}
	}
	return -1;
}

