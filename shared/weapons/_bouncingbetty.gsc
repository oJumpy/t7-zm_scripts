#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace bouncingbetty;

/*
	Name: init_shared
	Namespace: bouncingbetty
	Checksum: 0xC22A486C
	Offset: 0x468
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.bettyDestroyedFX = "weapon/fx_betty_exp_destroyed";
	level._effect["fx_betty_friendly_light"] = "weapon/fx_betty_light_blue";
	level._effect["fx_betty_enemy_light"] = "weapon/fx_betty_light_orng";
	level.bettyMinDist = 20;
	level.bettyStunTime = 1;
	bettyExplodeAnim = %o_spider_mine_detonate;
	bettyDeployAnim = %o_spider_mine_deploy;
	level.bettyRadius = GetDvarInt("betty_detect_radius", 180);
	level.bettyActivationDelay = GetDvarFloat("betty_activation_delay", 1);
	level.bettyGracePeriod = GetDvarFloat("betty_grace_period", 0);
	level.bettyDamageRadius = GetDvarInt("betty_damage_radius", 180);
	level.bettyDamageMax = GetDvarInt("betty_damage_max", 180);
	level.bettyDamageMin = GetDvarInt("betty_damage_min", 70);
	level.bettyDamageHeight = GetDvarInt("betty_damage_cylinder_height", 200);
	level.bettyJumpHeight = GetDvarInt("betty_jump_height_onground", 55);
	level.bettyJumpHeightWall = GetDvarInt("betty_jump_height_wall", 20);
	level.bettyJumpHeightWallAngle = GetDvarInt("betty_onground_angle_threshold", 30);
	level.bettyJumpHeightWallAngleCos = cos(level.bettyJumpHeightWallAngle);
	level.bettyJumpTime = GetDvarFloat("betty_jump_time", 0.7);
	level.bettyBombletSpawnDistance = 20;
	level.bettyBombletCount = 4;
	level thread register();
	/#
		level thread function_e889d2f4();
	#/
	callback::add_weapon_watcher(&createBouncingBettyWatcher);
}

/*
	Name: register
	Namespace: bouncingbetty
	Checksum: 0x68C82C49
	Offset: 0x748
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("missile", "bouncingbetty_state", 1, 2, "int");
	clientfield::register("scriptmover", "bouncingbetty_state", 1, 2, "int");
}

/*
	Name: function_e889d2f4
	Namespace: bouncingbetty
	Checksum: 0x69A91686
	Offset: 0x7B8
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function function_e889d2f4()
{
	/#
		for(;;)
		{
			level.bettyRadius = GetDvarInt("Dev Block strings are not supported", level.bettyRadius);
			level.bettyActivationDelay = GetDvarFloat("Dev Block strings are not supported", level.bettyActivationDelay);
			level.bettyGracePeriod = GetDvarFloat("Dev Block strings are not supported", level.bettyGracePeriod);
			level.bettyDamageRadius = GetDvarInt("Dev Block strings are not supported", level.bettyDamageRadius);
			level.bettyDamageMax = GetDvarInt("Dev Block strings are not supported", level.bettyDamageMax);
			level.bettyDamageMin = GetDvarInt("Dev Block strings are not supported", level.bettyDamageMin);
			level.bettyDamageHeight = GetDvarInt("Dev Block strings are not supported", level.bettyDamageHeight);
			level.bettyJumpHeight = GetDvarInt("Dev Block strings are not supported", level.bettyJumpHeight);
			level.bettyJumpHeightWall = GetDvarInt("Dev Block strings are not supported", level.bettyJumpHeightWall);
			level.bettyJumpHeightWallAngle = GetDvarInt("Dev Block strings are not supported", level.bettyJumpHeightWallAngle);
			level.bettyJumpHeightWallAngleCos = cos(level.bettyJumpHeightWallAngle);
			level.bettyJumpTime = GetDvarFloat("Dev Block strings are not supported", level.bettyJumpTime);
			wait(3);
		}
	#/
}

/*
	Name: createBouncingBettyWatcher
	Namespace: bouncingbetty
	Checksum: 0x21DBE58C
	Offset: 0x9B0
	Size: 0x1B7
	Parameters: 0
	Flags: None
*/
function createBouncingBettyWatcher()
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher("bouncingbetty", self.team);
	watcher.onSpawn = &onSpawnBouncingBetty;
	watcher.watchForFire = 1;
	watcher.onDetonateCallback = &bouncingBettyDetonate;
	watcher.activateSound = "wpn_betty_alert";
	watcher.hackable = 1;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.ownerGetsAssist = 1;
	watcher.ignoreDirection = 1;
	watcher.immediateDetonation = 1;
	watcher.immunespecialty = "specialty_immunetriggerbetty";
	watcher.detectionMinDist = level.bettyMinDist;
	watcher.detectionGracePeriod = level.bettyGracePeriod;
	watcher.detonateRadius = level.bettyRadius;
	watcher.onFizzleOut = &onBouncingBettyFizzleOut;
	watcher.stun = &weaponobjects::weaponStun;
	watcher.stunTime = level.bettyStunTime;
	watcher.activationDelay = level.bettyActivationDelay;
}

/*
	Name: onBouncingBettyFizzleOut
	Namespace: bouncingbetty
	Checksum: 0xEE4E0A1C
	Offset: 0xB70
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function onBouncingBettyFizzleOut()
{
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
	Name: onSpawnBouncingBetty
	Namespace: bouncingbetty
	Checksum: 0x956AE8B5
	Offset: 0xBF0
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function onSpawnBouncingBetty(watcher, owner)
{
	weaponobjects::onSpawnProximityWeaponObject(watcher, owner);
	self.originalowner = owner;
	self thread spawnMineMover();
	self trackOnOwner(owner);
	self thread trackUsedStatOnDeath();
	self thread doNoTrackUsedStatOnPickup();
	self thread trackUsedOnHack();
}

/*
	Name: trackUsedStatOnDeath
	Namespace: bouncingbetty
	Checksum: 0xAB87753B
	Offset: 0xCA8
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function trackUsedStatOnDeath()
{
	self endon("do_not_track_used");
	self waittill("death");
	waittillframeend;
	if(isdefined(self.owner))
	{
		self.owner trackBouncingBettyAsUsed();
	}
	self notify("end_doNoTrackUsedOnPickup");
	self notify("end_doNoTrackUsedOnHacked");
}

/*
	Name: doNoTrackUsedStatOnPickup
	Namespace: bouncingbetty
	Checksum: 0x57835688
	Offset: 0xD10
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function doNoTrackUsedStatOnPickup()
{
	self endon("end_doNoTrackUsedOnPickup");
	self waittill("picked_up");
	self notify("do_not_track_used");
}

/*
	Name: trackUsedOnHack
	Namespace: bouncingbetty
	Checksum: 0x70BB5F68
	Offset: 0xD48
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function trackUsedOnHack()
{
	self endon("end_doNoTrackUsedOnHacked");
	self waittill("hacked");
	self.originalowner trackBouncingBettyAsUsed();
	self notify("do_not_track_used");
}

/*
	Name: trackBouncingBettyAsUsed
	Namespace: bouncingbetty
	Checksum: 0xACE15D4B
	Offset: 0xD98
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function trackBouncingBettyAsUsed()
{
	if(isPlayer(self))
	{
		self addweaponstat(GetWeapon("bouncingbetty"), "used", 1);
	}
}

/*
	Name: trackOnOwner
	Namespace: bouncingbetty
	Checksum: 0xAF8469E2
	Offset: 0xDF8
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function trackOnOwner(owner)
{
	if(level.trackBouncingBettiesOnOwner === 1)
	{
		if(!isdefined(owner))
		{
			return;
		}
		if(!isdefined(owner.activeBouncingBetties))
		{
			owner.activeBouncingBetties = [];
		}
		else
		{
			ArrayRemoveValue(owner.activeBouncingBetties, undefined);
		}
		owner.activeBouncingBetties[owner.activeBouncingBetties.size] = self;
	}
}

/*
	Name: spawnMineMover
	Namespace: bouncingbetty
	Checksum: 0x95E6A23
	Offset: 0xE98
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function spawnMineMover()
{
	self endon("death");
	self util::waitTillNotMoving();
	self clientfield::set("bouncingbetty_state", 2);
	self useanimtree(-1);
	self SetAnim(%o_spider_mine_deploy, 1, 0, 1);
	mineMover = spawn("script_model", self.origin);
	mineMover.angles = self.angles;
	mineMover SetModel("tag_origin");
	mineMover.owner = self.owner;
	mineUp = anglesToUp(mineMover.angles);
	z_offset = GetDvarFloat("scr_bouncing_betty_killcam_offset", 18);
	mineMover EnableLinkTo();
	mineMover LinkTo(self);
	mineMover.killcamoffset = VectorScale(mineUp, z_offset);
	mineMover.weapon = self.weapon;
	mineMover playsound("wpn_betty_arm");
	killCamEnt = spawn("script_model", mineMover.origin + mineMover.killcamoffset);
	killCamEnt.angles = (0, 0, 0);
	killCamEnt SetModel("tag_origin");
	killCamEnt setWeapon(self.weapon);
	mineMover.killCamEnt = killCamEnt;
	self.mineMover = mineMover;
	self thread killMineMoverOnPickup();
}

/*
	Name: killMineMoverOnPickup
	Namespace: bouncingbetty
	Checksum: 0xE7F9B829
	Offset: 0x1148
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function killMineMoverOnPickup()
{
	self.mineMover endon("death");
	self util::waittill_any("picked_up", "hacked");
	self killMineMover();
}

/*
	Name: killMineMover
	Namespace: bouncingbetty
	Checksum: 0x6E34F188
	Offset: 0x11A8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function killMineMover()
{
	if(isdefined(self.mineMover))
	{
		if(isdefined(self.mineMover.killCamEnt))
		{
			self.mineMover.killCamEnt delete();
		}
		self.mineMover delete();
	}
}

/*
	Name: bouncingBettyDetonate
	Namespace: bouncingbetty
	Checksum: 0xBB0528B2
	Offset: 0x1210
	Size: 0x15B
	Parameters: 3
	Flags: None
*/
function bouncingBettyDetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isValid)
	{
		self.destroyedBy = attacker;
		if(isdefined(attacker))
		{
			if(self.owner util::IsEnemyPlayer(attacker))
			{
				attacker challenges::destroyedExplosive(weapon);
				scoreevents::processScoreEvent("destroyed_bouncingbetty", attacker, self.owner, weapon);
			}
		}
		self bouncingBettyDestroyed();
	}
	else if(isdefined(self.mineMover))
	{
		self.mineMover.ignore_team_kills = 1;
		self.mineMover SetModel(self.model);
		self.mineMover thread bouncingBettyJumpAndExplode();
		self delete();
	}
	else
	{
		self bouncingBettyDestroyed();
	}
}

/*
	Name: bouncingBettyDestroyed
	Namespace: bouncingbetty
	Checksum: 0x518785ED
	Offset: 0x1378
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function bouncingBettyDestroyed()
{
	playFX(level.bettyDestroyedFX, self.origin);
	playsoundatposition("dst_equipment_destroy", self.origin);
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	self killMineMover();
	self RadiusDamage(self.origin, 128, 110, 10, self.owner, "MOD_EXPLOSIVE", self.weapon);
	self delete();
}

/*
	Name: bouncingBettyJumpAndExplode
	Namespace: bouncingbetty
	Checksum: 0x58DEC02A
	Offset: 0x1460
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function bouncingBettyJumpAndExplode()
{
	jumpDir = VectorNormalize(anglesToUp(self.angles));
	if(jumpDir[2] > level.bettyJumpHeightWallAngleCos)
	{
		jumpHeight = level.bettyJumpHeight;
	}
	else
	{
		jumpHeight = level.bettyJumpHeightWall;
	}
	explodePos = self.origin + jumpDir * jumpHeight;
	self.killCamEnt moveto(explodePos + self.killcamoffset, level.bettyJumpTime, 0, level.bettyJumpTime);
	self clientfield::set("bouncingbetty_state", 1);
	wait(level.bettyJumpTime);
	self thread mineExplode(jumpDir, explodePos);
}

/*
	Name: mineExplode
	Namespace: bouncingbetty
	Checksum: 0x76EB6742
	Offset: 0x1580
	Size: 0x17B
	Parameters: 2
	Flags: None
*/
function mineExplode(explosionDir, explodePos)
{
	if(!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}
	self playsound("wpn_betty_explo");
	self clientfield::set("sndRattle", 1);
	wait(0.05);
	if(!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}
	self CylinderDamage(explosionDir * level.bettyDamageHeight, explodePos, level.bettyDamageRadius, level.bettyDamageRadius, level.bettyDamageMax, level.bettyDamageMin, self.owner, "MOD_EXPLOSIVE", self.weapon);
	self ghost();
	wait(0.1);
	if(!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	self.killCamEnt delete();
	self delete();
}

