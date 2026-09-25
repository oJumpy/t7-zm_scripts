#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace proximity_grenade;

/*
	Name: init_shared
	Namespace: proximity_grenade
	Checksum: 0x522A7D3E
	Offset: 0x5E0
	Size: 0x30B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["prox_grenade_friendly_default"] = "weapon/fx_prox_grenade_scan_blue";
	level._effect["prox_grenade_friendly_warning"] = "weapon/fx_prox_grenade_wrn_grn";
	level._effect["prox_grenade_enemy_default"] = "weapon/fx_prox_grenade_scan_orng";
	level._effect["prox_grenade_enemy_warning"] = "weapon/fx_prox_grenade_wrn_red";
	level._effect["prox_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	level._effect["prox_grenade_chain_bolt"] = "weapon/fx_prox_grenade_elec_jump";
	level.proximityGrenadeDetectionRadius = GetDvarInt("scr_proximityGrenadeDetectionRadius", 180);
	level.proximityGrenadeDuration = GetDvarFloat("scr_proximityGrenadeDuration", 1.2);
	level.proximityGrenadeGracePeriod = GetDvarFloat("scr_proximityGrenadeGracePeriod", 0.05);
	level.proximityGrenadeDOTDamageAmount = GetDvarInt("scr_proximityGrenadeDOTDamageAmount", 1);
	level.proximityGrenadeDOTDamageAmountHardcore = GetDvarInt("scr_proximityGrenadeDOTDamageAmountHardcore", 1);
	level.proximityGrenadeDOTDamageTime = GetDvarFloat("scr_proximityGrenadeDOTDamageTime", 0.2);
	level.proximityGrenadeDOTDamageInstances = GetDvarInt("scr_proximityGrenadeDOTDamageInstances", 4);
	level.proximityGrenadeActivationTime = GetDvarFloat("scr_proximityGrenadeActivationTime", 0.1);
	level.proximityChainDebug = GetDvarInt("scr_proximityChainDebug", 0);
	level.proximityChainGracePeriod = GetDvarInt("scr_proximityChainGracePeriod", 2500);
	level.proximityChainBoltSpeed = GetDvarFloat("scr_proximityChainBoltSpeed", 400);
	level.proximityGrenadeProtectedTime = GetDvarFloat("scr_proximityGrenadeProtectedTime", 0.45);
	level.poisonFXDuration = 6;
	level thread register();
	callback::on_spawned(&on_player_spawned);
	callback::add_weapon_damage(GetWeapon("proximity_grenade"), &on_damage);
	/#
		level thread updateDvars();
	#/
}

/*
	Name: register
	Namespace: proximity_grenade
	Checksum: 0xF014CEFA
	Offset: 0x8F8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("toplayer", "tazered", 1, 1, "int");
}

/*
	Name: updateDvars
	Namespace: proximity_grenade
	Checksum: 0xEE08D814
	Offset: 0x938
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	while(1)
	{
		level.proximityGrenadeDetectionRadius = GetDvarInt("scr_proximityGrenadeDetectionRadius", level.proximityGrenadeDetectionRadius);
		level.proximityGrenadeDuration = GetDvarFloat("scr_proximityGrenadeDuration", 1.5);
		level.proximityGrenadeGracePeriod = GetDvarFloat("scr_proximityGrenadeGracePeriod", level.proximityGrenadeGracePeriod);
		level.proximityGrenadeDOTDamageAmount = GetDvarInt("scr_proximityGrenadeDOTDamageAmount", level.proximityGrenadeDOTDamageAmount);
		level.proximityGrenadeDOTDamageAmountHardcore = GetDvarInt("scr_proximityGrenadeDOTDamageAmountHardcore", level.proximityGrenadeDOTDamageAmountHardcore);
		level.proximityGrenadeDOTDamageTime = GetDvarFloat("scr_proximityGrenadeDOTDamageTime", level.proximityGrenadeDOTDamageTime);
		level.proximityGrenadeDOTDamageInstances = GetDvarInt("scr_proximityGrenadeDOTDamageInstances", level.proximityGrenadeDOTDamageInstances);
		level.proximityGrenadeActivationTime = GetDvarFloat("scr_proximityGrenadeActivationTime", level.proximityGrenadeActivationTime);
		level.proximityChainDebug = GetDvarInt("scr_proximityChainDebug", level.proximityChainDebug);
		level.proximityChainGracePeriod = GetDvarInt("scr_proximityChainGracePeriod", level.proximityChainGracePeriod);
		level.proximityChainBoltSpeed = GetDvarFloat("scr_proximityChainBoltSpeed", level.proximityChainBoltSpeed);
		level.proximityGrenadeProtectedTime = GetDvarFloat("scr_proximityGrenadeProtectedTime", level.proximityGrenadeProtectedTime);
		wait(1);
	}
}

/*
	Name: createProximityGrenadeWatcher
	Namespace: proximity_grenade
	Checksum: 0x834E24B8
	Offset: 0xB38
	Size: 0x1AF
	Parameters: 0
	Flags: None
*/
function createProximityGrenadeWatcher()
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher("proximity_grenade", self.team);
	watcher.watchForFire = 1;
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headicon = 0;
	watcher.activateFx = 1;
	watcher.ownerGetsAssist = 1;
	watcher.ignoreDirection = 1;
	watcher.immediateDetonation = 1;
	watcher.detectionGracePeriod = level.proximityGrenadeGracePeriod;
	watcher.detonateRadius = level.proximityGrenadeDetectionRadius;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.onDetonateCallback = &proximityDetonate;
	watcher.activationDelay = level.proximityGrenadeActivationTime;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.immunespecialty = "specialty_immunetriggershock";
	watcher.onSpawn = &onSpawnProximityGrenadeWeaponObject;
}

/*
	Name: createGadgetProximityGrenadeWatcher
	Namespace: proximity_grenade
	Checksum: 0xF0F9537F
	Offset: 0xCF0
	Size: 0x197
	Parameters: 0
	Flags: None
*/
function createGadgetProximityGrenadeWatcher()
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher("gadget_sticky_proximity", self.team);
	watcher.watchForFire = 1;
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headicon = 0;
	watcher.activateFx = 1;
	watcher.ownerGetsAssist = 1;
	watcher.ignoreDirection = 1;
	watcher.immediateDetonation = 1;
	watcher.detectionGracePeriod = level.proximityGrenadeGracePeriod;
	watcher.detonateRadius = level.proximityGrenadeDetectionRadius;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.onDetonateCallback = &proximityDetonate;
	watcher.activationDelay = level.proximityGrenadeActivationTime;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.onSpawn = &onSpawnProximityGrenadeWeaponObject;
}

/*
	Name: onSpawnProximityGrenadeWeaponObject
	Namespace: proximity_grenade
	Checksum: 0xF649D748
	Offset: 0xE90
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function onSpawnProximityGrenadeWeaponObject(watcher, owner)
{
	self thread setupKillCamEnt();
	owner addweaponstat(self.weapon, "used", 1);
	if(isdefined(self.weapon) && self.weapon.proximityDetonation > 0)
	{
		watcher.detonateRadius = self.weapon.proximityDetonation;
	}
	weaponobjects::onSpawnProximityWeaponObject(watcher, owner);
	self trackOnOwner(self.owner);
}

/*
	Name: trackOnOwner
	Namespace: proximity_grenade
	Checksum: 0x2D73D5F6
	Offset: 0xF68
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function trackOnOwner(owner)
{
	if(level.trackProximityGrenadesOnOwner === 1)
	{
		if(!isdefined(owner))
		{
			return;
		}
		if(!isdefined(owner.activeProximityGrenades))
		{
			owner.activeProximityGrenades = [];
		}
		else
		{
			ArrayRemoveValue(owner.activeProximityGrenades, undefined);
		}
		owner.activeProximityGrenades[owner.activeProximityGrenades.size] = self;
	}
}

/*
	Name: setupKillCamEnt
	Namespace: proximity_grenade
	Checksum: 0xC1FAD299
	Offset: 0x1008
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
	Namespace: proximity_grenade
	Checksum: 0x52FAE0B4
	Offset: 0x1088
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
	Namespace: proximity_grenade
	Checksum: 0x498EA605
	Offset: 0x10D8
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function proximityDetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isValid)
	{
		if(isdefined(attacker))
		{
			if(self.owner util::IsEnemyPlayer(attacker))
			{
				attacker challenges::destroyedExplosive(weapon);
				scoreevents::processScoreEvent("destroyed_proxy", attacker, self.owner, weapon);
			}
		}
	}
	weaponobjects::weaponDetonate(attacker, weapon);
}

/*
	Name: proximityGrenadeDamagePlayer
	Namespace: proximity_grenade
	Checksum: 0xF33B8149
	Offset: 0x11A0
	Size: 0xCB
	Parameters: 7
	Flags: None
*/
function proximityGrenadeDamagePlayer(eAttacker, eInflictor, killCamEnt, weapon, meansOfDeath, damage, proximityChain)
{
	self thread damagePlayerInRadius(eInflictor.origin, eAttacker, killCamEnt);
	if(weapon.chainEventRadius > 0 && !self hasPerk("specialty_proximityprotection"))
	{
		self thread proximityGrenadeChain(eAttacker, eInflictor, killCamEnt, weapon, meansOfDeath, damage, proximityChain, 0);
	}
}

/*
	Name: getProximityChain
	Namespace: proximity_grenade
	Checksum: 0xA2264755
	Offset: 0x1278
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function getProximityChain()
{
	if(!isdefined(level.proximityChains))
	{
		level.proximityChains = [];
	}
	foreach(chain in level.proximityChains)
	{
		if(!chainIsActive(chain))
		{
			return chain;
		}
	}
	chain = spawnstruct();
	level.proximityChains[level.proximityChains.size] = chain;
	return chain;
}

/*
	Name: chainIsActive
	Namespace: proximity_grenade
	Checksum: 0xE50A9619
	Offset: 0x1360
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function chainIsActive(chain)
{
	if(isdefined(chain.activeEndTime) && chain.activeEndTime > GetTime())
	{
		return 1;
	}
	return 0;
}

/*
	Name: cleanUpProximityChainEnt
	Namespace: proximity_grenade
	Checksum: 0x32151E57
	Offset: 0x13A8
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function cleanUpProximityChainEnt()
{
	self.CleanUp = 1;
	any_active = 1;
	while(any_active)
	{
		wait(1);
		if(!isdefined(self))
		{
			return;
		}
		any_active = 0;
		foreach(proximityChain in self.chains)
		{
			if(proximityChain.activeEndTime > GetTime())
			{
				any_active = 1;
				break;
			}
		}
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: isInChain
	Namespace: proximity_grenade
	Checksum: 0x92EAEF7D
	Offset: 0x14A8
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function isInChain(player)
{
	player_num = player GetEntityNumber();
	return isdefined(self.chain_players[player_num]);
}

/*
	Name: addPlayerToChain
	Namespace: proximity_grenade
	Checksum: 0xC4929230
	Offset: 0x14F0
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function addPlayerToChain(player)
{
	player_num = player GetEntityNumber();
	self.chain_players[player_num] = player;
}

/*
	Name: proximityGrenadeChain
	Namespace: proximity_grenade
	Checksum: 0x25D5BD53
	Offset: 0x1540
	Size: 0x4BF
	Parameters: 8
	Flags: None
*/
function proximityGrenadeChain(eAttacker, eInflictor, killCamEnt, weapon, meansOfDeath, damage, proximityChain, delay)
{
	self endon("disconnect");
	self endon("death");
	eAttacker endon("disconnect");
	if(!isdefined(proximityChain))
	{
		proximityChain = getProximityChain();
		proximityChain.chainEventNum = 0;
		if(!isdefined(eInflictor.proximityChainEnt))
		{
			eInflictor.proximityChainEnt = spawn("script_origin", self.origin);
			eInflictor.proximityChainEnt.chains = [];
			eInflictor.proximityChainEnt.chain_players = [];
		}
		proximityChain.proximityChainEnt = eInflictor.proximityChainEnt;
		proximityChain.proximityChainEnt.chains[proximityChain.proximityChainEnt.chains.size] = proximityChain;
	}
	proximityChain.chainEventNum = proximityChain.chainEventNum + 1;
	if(proximityChain.chainEventNum >= weapon.chainEventMax)
	{
		return;
	}
	chainEventRadiusSq = weapon.chainEventRadius * weapon.chainEventRadius;
	endTime = GetTime() + weapon.chainEventTime;
	proximityChain.proximityChainEnt addPlayerToChain(self);
	proximityChain.activeEndTime = endTime + delay * 1000 + level.proximityChainGracePeriod;
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(proximityChain.proximityChainEnt.CleanUp))
	{
		proximityChain.proximityChainEnt thread cleanUpProximityChainEnt();
	}
	while(1)
	{
		currentTime = GetTime();
		if(endTime < currentTime)
		{
			return;
		}
		closestPlayers = ArraySort(level.players, self.origin, 1);
		foreach(player in closestPlayers)
		{
			wait(0.05);
			if(proximityChain.chainEventNum >= weapon.chainEventMax)
			{
				return;
			}
			if(!isdefined(player) || !isalive(player) || player == self)
			{
				continue;
			}
			if(player.sessionstate != "playing")
			{
				continue;
			}
			distanceSq = DistanceSquared(player.origin, self.origin);
			if(distanceSq > chainEventRadiusSq)
			{
				break;
			}
			if(proximityChain.proximityChainEnt isInChain(player))
			{
				continue;
			}
			if(level.proximityChainDebug || weaponobjects::friendlyFireCheck(eAttacker, player))
			{
				if(level.proximityChainDebug || !player hasPerk("specialty_proximityprotection"))
				{
					self thread chainPlayer(eAttacker, killCamEnt, weapon, meansOfDeath, damage, proximityChain, player, distanceSq);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: chainPlayer
	Namespace: proximity_grenade
	Checksum: 0xFEF483C0
	Offset: 0x1A08
	Size: 0x1CB
	Parameters: 8
	Flags: None
*/
function chainPlayer(eAttacker, killCamEnt, weapon, meansOfDeath, damage, proximityChain, player, distanceSq)
{
	waitTime = 0.25;
	speedsq = level.proximityChainBoltSpeed * level.proximityChainBoltSpeed;
	if(speedsq > 100 && distanceSq > 1)
	{
		waitTime = distanceSq / speedsq;
	}
	player thread proximityGrenadeChain(eAttacker, self, killCamEnt, weapon, meansOfDeath, damage, proximityChain, waitTime);
	wait(0.05);
	if(level.proximityChainDebug)
	{
		/#
			color = (1, 1, 1);
			alpha = 1;
			depth = 0;
			time = 200;
			util::debug_line(self.origin + VectorScale((0, 0, 1), 50), player.origin + VectorScale((0, 0, 1), 50), color, alpha, depth, time);
		#/
	}
	self tesla_play_arc_fx(player, waitTime);
	player thread damagePlayerInRadius(self.origin, eAttacker, killCamEnt);
}

/*
	Name: tesla_play_arc_fx
	Namespace: proximity_grenade
	Checksum: 0x1EC939AD
	Offset: 0x1BE0
	Size: 0x1C3
	Parameters: 2
	Flags: None
*/
function tesla_play_arc_fx(target, waitTime)
{
	if(!isdefined(self) || !isdefined(target))
	{
		return;
	}
	tag = "J_SpineUpper";
	target_tag = "J_SpineUpper";
	origin = self GetTagOrigin(tag);
	target_origin = target GetTagOrigin(target_tag);
	distance_squared = 16384;
	if(DistanceSquared(origin, target_origin) < distance_squared)
	{
		return;
	}
	fxOrg = spawn("script_model", origin);
	fxOrg SetModel("tag_origin");
	FX = PlayFXOnTag(level._effect["prox_grenade_chain_bolt"], fxOrg, "tag_origin");
	playsoundatposition("wpn_tesla_bounce", fxOrg.origin);
	fxOrg moveto(target_origin, waitTime);
	fxOrg waittill("movedone");
	fxOrg delete();
}

/*
	Name: debugChainSphere
	Namespace: proximity_grenade
	Checksum: 0x62421615
	Offset: 0x1DB0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function debugChainSphere()
{
	/#
		util::debug_sphere(self.origin + VectorScale((0, 0, 1), 50), 20, (1, 1, 1), 1, 0);
	#/
}

/*
	Name: watchProximityGrenadeHitPlayer
	Namespace: proximity_grenade
	Checksum: 0xF67451FF
	Offset: 0x1DF8
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function watchProximityGrenadeHitPlayer(owner)
{
	self endon("death");
	self SetOwner(owner);
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
	Namespace: proximity_grenade
	Checksum: 0x81DE685
	Offset: 0x1F28
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
	Name: damagePlayerInRadius
	Namespace: proximity_grenade
	Checksum: 0x22D131C8
	Offset: 0x2070
	Size: 0x40B
	Parameters: 3
	Flags: None
*/
function damagePlayerInRadius(position, eAttacker, killCamEnt)
{
	self notify("proximityGrenadeDamageStart");
	self endon("proximityGrenadeDamageStart");
	self endon("disconnect");
	self endon("death");
	eAttacker endon("disconnect");
	PlayFXOnTag(level._effect["prox_grenade_player_shock"], self, "J_SpineUpper");
	g_time = GetTime();
	if(self util::mayApplyScreenEffect())
	{
		if(!self hasPerk("specialty_proximityprotection"))
		{
			self.lastShockedBy = eAttacker;
			self.shockEndTime = GetTime() + level.proximityGrenadeDuration * 1000;
			self shellshock("proximity_grenade", level.proximityGrenadeDuration, 0);
		}
		self clientfield::set_to_player("tazered", 1);
	}
	self PlayRumbleOnEntity("proximity_grenade");
	self playsound("wpn_taser_mine_zap");
	if(!self hasPerk("specialty_proximityprotection"))
	{
		self thread watch_death();
		if(!isdefined(killCamEnt))
		{
			killCamEnt = spawn("script_model", position + VectorScale((0, 0, 1), 8));
		}
		killCamEnt.soundMod = "taser_spike";
		killCamEnt util::deleteAfterTime(3 + level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances);
		self util::show_hud(0);
		damage = level.proximityGrenadeDOTDamageAmount;
		if(level.hardcoreMode)
		{
			damage = level.proximityGrenadeDOTDamageAmountHardcore;
		}
		for(i = 0; i < level.proximityGrenadeDOTDamageInstances; i++)
		{
			/#
				Assert(isdefined(eAttacker));
			#/
			if(!isdefined(killCamEnt))
			{
				killCamEnt = spawn("script_model", position + VectorScale((0, 0, 1), 8));
				killCamEnt.soundMod = "taser_spike";
				killCamEnt util::deleteAfterTime(3 + level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances - i);
			}
			self DoDamage(damage, position, eAttacker, killCamEnt, "none", "MOD_GAS", 0, GetWeapon("proximity_grenade_aoe"));
			wait(level.proximityGrenadeDOTDamageTime);
		}
		if(GetTime() - g_time < level.proximityGrenadeDuration * 1000)
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
	Namespace: proximity_grenade
	Checksum: 0xAD26345A
	Offset: 0x2488
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
	Namespace: proximity_grenade
	Checksum: 0x75BE551B
	Offset: 0x24B8
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
	Namespace: proximity_grenade
	Checksum: 0xB38B49ED
	Offset: 0x2528
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
	Namespace: proximity_grenade
	Checksum: 0xC8753C0D
	Offset: 0x2558
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
	Namespace: proximity_grenade
	Checksum: 0x5F2AF52C
	Offset: 0x2598
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
	Namespace: proximity_grenade
	Checksum: 0xB2E384D7
	Offset: 0x2648
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread createProximityGrenadeWatcher();
	self thread createGadgetProximityGrenadeWatcher();
	self thread begin_other_grenade_tracking();
}

/*
	Name: begin_other_grenade_tracking
	Namespace: proximity_grenade
	Checksum: 0xFD1C6B69
	Offset: 0x26A0
	Size: 0xBF
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
		if(grenade util::isHacked())
		{
			continue;
		}
		if(weapon.rootweapon.name == "proximity_grenade")
		{
			grenade thread watchProximityGrenadeHitPlayer(self);
		}
	}
}

/*
	Name: on_damage
	Namespace: proximity_grenade
	Checksum: 0x9A9163A8
	Offset: 0x2768
	Size: 0x63
	Parameters: 5
	Flags: None
*/
function on_damage(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	self thread proximityGrenadeDamagePlayer(eAttacker, eInflictor, eInflictor.killCamEnt, weapon, meansOfDeath, damage, undefined);
}

