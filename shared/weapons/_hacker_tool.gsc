#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

#namespace hacker_tool;

/*
	Name: init_shared
	Namespace: hacker_tool
	Checksum: 0xC0B73156
	Offset: 0x380
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.weaponHackerTool = GetWeapon("pda_hack");
	level.hackerToolLostSightLimitMs = 1000;
	level.hackerToolLockOnRadius = 25;
	level.hackerToolLockOnFOV = 65;
	level.hackerToolHackTimeMs = 0.4;
	level.equipmentHackerToolRadius = 20;
	level.equipmentHackerToolTimeMs = 100;
	level.carePackageHackerToolRadius = 60;
	level.carePackageHackerToolTimeMs = GetGametypeSetting("crateCaptureTime") * 500;
	level.carePackageFriendlyHackerToolTimeMs = GetGametypeSetting("crateCaptureTime") * 2000;
	level.carePackageOwnerHackerToolTimeMs = 250;
	level.vehicleHackerToolRadius = 80;
	level.vehicleHackerToolTimeMs = 5000;
	clientfield::register("toplayer", "hacker_tool", 1, 2, "int");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: hacker_tool
	Checksum: 0xB3632EE1
	Offset: 0x4C8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	self clearHackerTarget(undefined, 0, 1);
	self thread watchHackerToolUse();
	self thread watchHackerToolFired();
}

/*
	Name: clearHackerTarget
	Namespace: hacker_tool
	Checksum: 0x24382585
	Offset: 0x530
	Size: 0x243
	Parameters: 3
	Flags: None
*/
function clearHackerTarget(weapon, successfulHack, spawned)
{
	self notify("stop_lockon_sound");
	self notify("stop_locked_sound");
	self notify("clearHackerTarget");
	self.stingerlocksound = undefined;
	self StopRumble("stinger_lock_rumble");
	self.hackerToolLockStartTime = 0;
	self.hackerToolLockStarted = 0;
	self.hackerToolLockFinalized = 0;
	self.hackerToolLockTimeElapsed = 0;
	if(isdefined(weapon))
	{
		if(weapon.isHackToolWeapon)
		{
			self SetWeaponHackPercent(weapon, 0);
		}
		if(isdefined(self.hackerToolTarget))
		{
			heatseekingmissile::setFriendlyFlags(weapon, self.hackerToolTarget);
		}
	}
	if(successfulHack == 0)
	{
		if(spawned == 0)
		{
			if(isdefined(self.hackerToolTarget))
			{
				self playsoundtoplayer("evt_hacker_hack_lost", self);
			}
		}
		self clientfield::set_to_player("hacker_tool", 0);
		self stopHackerToolSoundLoop();
	}
	if(isdefined(self.hackerToolTarget))
	{
		heatseekingmissile::TargetingHacking(self.hackerToolTarget, 0);
	}
	self.hackerToolTarget = undefined;
	self WeaponLockFree();
	self weaponlocktargettooclose(0);
	self WeaponLockNoClearance(0);
	self StopLocalSound(game["locking_on_sound"]);
	self StopLocalSound(game["locked_on_sound"]);
	self heatseekingmissile::DestroyLockOnCanceledMessage();
}

/*
	Name: watchHackerToolFired
	Namespace: hacker_tool
	Checksum: 0xC00149A3
	Offset: 0x780
	Size: 0x68F
	Parameters: 0
	Flags: None
*/
function watchHackerToolFired()
{
	self endon("disconnect");
	self endon("death");
	self endon("killHackerMonitor");
	while(1)
	{
		self waittill("hacker_tool_fired", hackerToolTarget, weapon);
		if(isdefined(hackerToolTarget))
		{
			if(isEntityHackableCarePackage(hackerToolTarget))
			{
				scoreevents::giveCrateCaptureMedal(hackerToolTarget, self);
				hackerToolTarget notify("captured", self, 1);
				if(isdefined(hackerToolTarget.owner) && isPlayer(hackerToolTarget.owner) && hackerToolTarget.owner.team != self.team && isdefined(level.play_killstreak_hacked_dialog))
				{
					hackerToolTarget.owner [[level.play_killstreak_hacked_dialog]](hackerToolTarget.killstreakType, hackerToolTarget.killstreakid, self);
				}
			}
			else if(isEntityHackableWeaponObject(hackerToolTarget) && isdefined(hackerToolTarget.hackertrigger))
			{
				hackerToolTarget.hackertrigger notify("trigger", self, 1);
				hackerToolTarget.previouslyHacked = 1;
				self.throwingGrenade = 0;
			}
			else if(isdefined(hackerToolTarget.killstreak_hackedCallback) && (!isdefined(hackerToolTarget.killstreakTimedOut) || hackerToolTarget.killstreakTimedOut == 0))
			{
				if(hackerToolTarget.killstreak_hackedProtection == 0)
				{
					if(isdefined(hackerToolTarget.owner) && isPlayer(hackerToolTarget.owner))
					{
						if(isdefined(level.play_killstreak_hacked_dialog))
						{
							hackerToolTarget.owner [[level.play_killstreak_hacked_dialog]](hackerToolTarget.killstreakType, hackerToolTarget.killstreakid, self);
						}
					}
					self playsoundtoplayer("evt_hacker_fw_success", self);
					hackerToolTarget notify("killstreak_hacked", self);
					hackerToolTarget.previouslyHacked = 1;
					hackerToolTarget [[hackerToolTarget.killstreak_hackedCallback]](self);
					if(self util::has_blind_eye_perk_purchased_and_equipped() || self util::has_hacker_perk_purchased_and_equipped())
					{
						self AddPlayerStat("hack_streak_with_blindeye_or_engineer", 1);
					}
				}
				else if(isdefined(hackerToolTarget.owner) && isPlayer(hackerToolTarget.owner))
				{
					if(isdefined(level.play_killstreak_firewall_hacked_dialog))
					{
						self.hackerToolTarget.owner [[level.play_killstreak_firewall_hacked_dialog]](self.hackerToolTarget.killstreakType, self.hackerToolTarget.killstreakid);
					}
				}
				self playsoundtoplayer("evt_hacker_ks_success", self);
				scoreevents::processScoreEvent("hacked_killstreak_protection", self, hackerToolTarget, level.weaponHackerTool);
				hackerToolTarget.killstreak_hackedProtection = 0;
			}
			else if(isdefined(hackerToolTarget.classname) && hackerToolTarget.classname == "grenade")
			{
				damage = 1;
			}
			else if(isdefined(hackerToolTarget.hackerToolDamage))
			{
				damage = hackerToolTarget.hackerToolDamage;
			}
			else if(isdefined(hackerToolTarget.maxhealth))
			{
				damage = hackerToolTarget.maxhealth + 1;
			}
			else
			{
				damage = 999999;
			}
			if(isdefined(hackerToolTarget.numFlares) && hackerToolTarget.numFlares > 0)
			{
				damage = 1;
				hackerToolTarget.numFlares--;
				hackerToolTarget heatseekingmissile::MissileTarget_PlayFlareFx();
			}
			hackerToolTarget DoDamage(damage, self.origin, self, self, 0, "MOD_UNKNOWN", 0, weapon);
			if(self util::is_item_purchased("pda_hack"))
			{
				self AddPlayerStat("hack_enemy_target", 1);
			}
			self addweaponstat(weapon, "used", 1);
		}
		clearHackerTarget(weapon, 1, 0);
		self forceoffhandend();
		if(GetDvarInt("player_sustainAmmo") == 0)
		{
			clip_ammo = self GetWeaponAmmoClip(weapon);
			clip_ammo--;
			/#
				/#
					Assert(clip_ammo >= 0);
				#/
			#/
			self SetWeaponAmmoClip(weapon, clip_ammo);
		}
		self killstreaks::switch_to_last_non_killstreak_weapon();
	}
}

/*
	Name: watchHackerToolUse
	Namespace: hacker_tool
	Checksum: 0x4B21A8E6
	Offset: 0xE18
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function watchHackerToolUse()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		self waittill("grenade_pullback", weapon);
		if(weapon.rootweapon == level.weaponHackerTool)
		{
			wait(0.05);
			currentOffhand = self getCurrentOffhand();
			if(self isUsingOffhand() && currentOffhand.rootweapon == level.weaponHackerTool)
			{
				self thread hackerToolTargetLoop(weapon);
				self thread watchHackerToolEnd(weapon);
				self thread watchForGrenadeFire(weapon);
				self thread watchHackerToolInterrupt(weapon);
			}
		}
	}
}

/*
	Name: watchHackerToolInterrupt
	Namespace: hacker_tool
	Checksum: 0xAC2D202D
	Offset: 0xF30
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function watchHackerToolInterrupt(weapon)
{
	self endon("disconnect");
	self endon("hacker_tool_fired");
	self endon("death");
	self endon("weapon_change");
	self endon("grenade_fire");
	while(1)
	{
		level waittill("use_interrupt", interruptTarget);
		if(self.hackerToolTarget == interruptTarget)
		{
			clearHackerTarget(weapon, 0, 0);
		}
		wait(0.05);
	}
}

/*
	Name: watchHackerToolEnd
	Namespace: hacker_tool
	Checksum: 0x3969A75F
	Offset: 0xFD8
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function watchHackerToolEnd(weapon)
{
	self endon("disconnect");
	self endon("hacker_tool_fired");
	msg = self util::waittill_any_return("weapon_change", "death", "hacker_tool_fired", "disconnect");
	clearHackerTarget(weapon, 0, 0);
	self clientfield::set_to_player("hacker_tool", 0);
	self stopHackerToolSoundLoop();
}

/*
	Name: watchForGrenadeFire
	Namespace: hacker_tool
	Checksum: 0x65EBE9F8
	Offset: 0x1098
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function watchForGrenadeFire(weapon)
{
	self endon("disconnect");
	self endon("hacker_tool_fired");
	self endon("weapon_change");
	self endon("death");
	while(1)
	{
		self waittill("grenade_fire", grenade_instance, grenade_weapon, respawnFromHack);
		if(isdefined(respawnFromHack) && respawnFromHack)
		{
			continue;
		}
		clearHackerTarget(grenade_weapon, 0, 0);
		clip_ammo = self GetWeaponAmmoClip(grenade_weapon);
		clip_max_ammo = grenade_weapon.clipSize;
		if(clip_ammo < clip_max_ammo)
		{
			clip_ammo++;
		}
		self SetWeaponAmmoClip(grenade_weapon, clip_ammo);
		break;
	}
}

/*
	Name: playHackerToolSoundLoop
	Namespace: hacker_tool
	Checksum: 0xD1882420
	Offset: 0x11C0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function playHackerToolSoundLoop()
{
	if(!isdefined(self.hacker_sound_ent) || (isdefined(self.hacker_alreadyhacked) && self.hacker_alreadyhacked == 1))
	{
		self PlayLoopSound("evt_hacker_device_loop");
		self.hacker_sound_ent = 1;
		self.hacker_alreadyhacked = 0;
	}
}

/*
	Name: stopHackerToolSoundLoop
	Namespace: hacker_tool
	Checksum: 0x3F039FC7
	Offset: 0x1230
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function stopHackerToolSoundLoop()
{
	self StopLoopSound(0.5);
	self.hacker_sound_ent = undefined;
	self.hacker_alreadyhacked = undefined;
}

/*
	Name: hackerToolTargetLoop
	Namespace: hacker_tool
	Checksum: 0x30B7C789
	Offset: 0x1270
	Size: 0x98F
	Parameters: 1
	Flags: None
*/
function hackerToolTargetLoop(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("weapon_change");
	self endon("grenade_fire");
	self clientfield::set_to_player("hacker_tool", 1);
	self playHackerToolSoundLoop();
	while(1)
	{
		wait(0.05);
		wait(0.05);
		if(self.hackerToolLockFinalized)
		{
			if(!self isValidHackerToolTarget(self.hackerToolTarget, weapon, 0))
			{
				self clearHackerTarget(weapon, 0, 0);
				continue;
			}
			passed = self hackerSoftSightTest(weapon);
			if(!passed)
			{
				continue;
			}
			self clientfield::set_to_player("hacker_tool", 0);
			self stopHackerToolSoundLoop();
			heatseekingmissile::TargetingHacking(self.hackerToolTarget, 0);
			heatseekingmissile::setFriendlyFlags(weapon, self.hackerToolTarget);
			thread heatseekingmissile::LoopLocalLockSound(game["locked_on_sound"], 0.75);
			self notify("hacker_tool_fired", self.hackerToolTarget, weapon);
			return;
		}
		if(self.hackerToolLockStarted)
		{
			if(!self isValidHackerToolTarget(self.hackerToolTarget, weapon, 0))
			{
				self clearHackerTarget(weapon, 0, 0);
				continue;
			}
			lockOnTime = self getLockOnTime(self.hackerToolTarget, weapon);
			if(lockOnTime == 0)
			{
				self clearHackerTarget(weapon, 0, 0);
				continue;
			}
			if(self.hackerToolLockTimeElapsed == 0)
			{
				self playlocalsound("evt_hacker_hacking");
				if(isdefined(self.hackerToolTarget.owner) && isPlayer(self.hackerToolTarget.owner))
				{
					if(isdefined(self.hackerToolTarget.killstreak_hackedCallback) && (!isdefined(self.hackerToolTarget.killstreakTimedOut) || self.hackerToolTarget.killstreakTimedOut == 0))
					{
						if(self.hackerToolTarget.killstreak_hackedProtection == 0)
						{
							if(isdefined(level.play_killstreak_being_hacked_dialog))
							{
								self.hackerToolTarget.owner [[level.play_killstreak_being_hacked_dialog]](self.hackerToolTarget.killstreakType, self.hackerToolTarget.killstreakid);
							}
						}
						else if(isdefined(level.play_killstreak_firewall_being_hacked_dialog))
						{
							self.hackerToolTarget.owner [[level.play_killstreak_firewall_being_hacked_dialog]](self.hackerToolTarget.killstreakType, self.hackerToolTarget.killstreakid);
						}
					}
				}
			}
			self WeaponLockStart(self.hackerToolTarget);
			self playHackerToolSoundLoop();
			if(isdefined(self.hackerToolTarget.killstreak_hackedProtection) && self.hackerToolTarget.killstreak_hackedProtection == 1)
			{
				self clientfield::set_to_player("hacker_tool", 3);
			}
			else
			{
				self clientfield::set_to_player("hacker_tool", 2);
			}
			heatseekingmissile::TargetingHacking(self.hackerToolTarget, 1);
			heatseekingmissile::setFriendlyFlags(weapon, self.hackerToolTarget);
			passed = self hackerSoftSightTest(weapon);
			if(!passed)
			{
				continue;
			}
			if(self.hackerToolLostSightlineTime == 0)
			{
				self.hackerToolLockTimeElapsed = self.hackerToolLockTimeElapsed + 0.1 * hackingTimeScale(self.hackerToolTarget);
				hackPercentage = self.hackerToolLockTimeElapsed / lockOnTime * 100;
				self SetWeaponHackPercent(weapon, hackPercentage);
				heatseekingmissile::setFriendlyFlags(weapon, self.hackerToolTarget);
			}
			else
			{
				self.hackerToolLockTimeElapsed = self.hackerToolLockTimeElapsed - 0.1 * hackingTimeNoLineOfSightScale(self.hackerToolTarget);
				if(self.hackerToolLockTimeElapsed < 0)
				{
					self.hackerToolLockTimeElapsed = 0;
					self clearHackerTarget(weapon, 0, 0);
					continue;
				}
				hackPercentage = self.hackerToolLockTimeElapsed / lockOnTime * 100;
				self SetWeaponHackPercent(weapon, hackPercentage);
				heatseekingmissile::setFriendlyFlags(weapon, self.hackerToolTarget);
			}
			if(self.hackerToolLockTimeElapsed < lockOnTime)
			{
				continue;
			}
			/#
				Assert(isdefined(self.hackerToolTarget));
			#/
			self notify("stop_lockon_sound");
			self.hackerToolLockFinalized = 1;
			self WeaponLockFinalize(self.hackerToolTarget);
			continue;
		}
		if(self IsEmpJammed())
		{
			self heatseekingmissile::DestroyLockOnCanceledMessage();
			continue;
		}
		bestTarget = self getBestHackerToolTarget(weapon);
		if(!isdefined(bestTarget))
		{
			self stopHackerToolSoundLoop();
			self heatseekingmissile::DestroyLockOnCanceledMessage();
			continue;
		}
		if(!self heatseekingmissile::LockSightTest(bestTarget))
		{
			self stopHackerToolSoundLoop();
			self heatseekingmissile::DestroyLockOnCanceledMessage();
			continue;
		}
		if(self heatseekingmissile::LockSightTest(bestTarget) && isdefined(bestTarget.lockOnDelay) && bestTarget.lockOnDelay)
		{
			self stopHackerToolSoundLoop();
			self heatseekingmissile::DisplayLockOnCanceledMessage();
			continue;
		}
		self heatseekingmissile::DestroyLockOnCanceledMessage();
		if(isEntityPreviouslyHacked(bestTarget))
		{
			if(!isdefined(self.hacker_sound_ent) || (isdefined(self.hacker_alreadyhacked) && self.hacker_alreadyhacked == 0))
			{
				self.hacker_sound_ent = 1;
				self.hacker_alreadyhacked = 1;
				self PlayLoopSound("evt_hacker_unhackable_loop");
			}
			continue;
		}
		else
		{
			self stopHackerToolSoundLoop();
		}
		heatseekingmissile::InitLockField(bestTarget);
		self.hackerToolTarget = bestTarget;
		self thread watchTargetEntityUpdate(bestTarget);
		self.hackerToolLockStartTime = GetTime();
		self.hackerToolLockStarted = 1;
		self.hackerToolLostSightlineTime = 0;
		self.hackerToolLockTimeElapsed = 0;
		self SetWeaponHackPercent(weapon, 0);
		if(isdefined(self.hackerToolTarget))
		{
			heatseekingmissile::setFriendlyFlags(weapon, self.hackerToolTarget);
		}
	}
}

/*
	Name: watchTargetEntityUpdate
	Namespace: hacker_tool
	Checksum: 0xA9AD2C72
	Offset: 0x1C08
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function watchTargetEntityUpdate(bestTarget)
{
	self endon("death");
	self endon("disconnect");
	self notify("watchTargetEntityUpdate");
	self endon("watchTargetEntityUpdate");
	self endon("clearHackerTarget");
	bestTarget endon("death");
	bestTarget waittill("hackertool_update_ent", newEntity);
	heatseekingmissile::InitLockField(newEntity);
	self.hackerToolTarget = newEntity;
}

/*
	Name: getBestHackerToolTarget
	Namespace: hacker_tool
	Checksum: 0xD5A06B74
	Offset: 0x1CA0
	Size: 0x399
	Parameters: 1
	Flags: None
*/
function getBestHackerToolTarget(weapon)
{
	targetsValid = [];
	targetsAll = ArrayCombine(target_getArray(), level.MissileEntities, 0, 0);
	targetsAll = ArrayCombine(targetsAll, level.hackerToolTargets, 0, 0);
	for(idx = 0; idx < targetsAll.size; idx++)
	{
		target_ent = targetsAll[idx];
		if(!isdefined(target_ent) || !isdefined(target_ent.owner))
		{
			continue;
		}
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				if(self isWithinHackerToolReticle(targetsAll[idx], weapon))
				{
					targetsValid[targetsValid.size] = targetsAll[idx];
				}
				continue;
			}
		#/
		if(level.teambased || level.use_team_based_logic_for_locking_on === 1)
		{
			if(isEntityHackableCarePackage(target_ent))
			{
				if(self canTargetEntity(target_ent, weapon))
				{
					targetsValid[targetsValid.size] = target_ent;
				}
			}
			else if(isdefined(target_ent.team))
			{
				if(target_ent.team != self.team)
				{
					if(self canTargetEntity(target_ent, weapon))
					{
						targetsValid[targetsValid.size] = target_ent;
					}
				}
			}
			else if(isdefined(target_ent.owner.team))
			{
				if(target_ent.owner.team != self.team)
				{
					if(self canTargetEntity(target_ent, weapon))
					{
						targetsValid[targetsValid.size] = target_ent;
					}
				}
			}
			continue;
		}
		if(self isWithinHackerToolReticle(target_ent, weapon))
		{
			if(isEntityHackableCarePackage(target_ent))
			{
				if(self canTargetEntity(target_ent, weapon))
				{
					targetsValid[targetsValid.size] = target_ent;
				}
				continue;
			}
			if(isdefined(target_ent.owner) && self != target_ent.owner)
			{
				if(self canTargetEntity(target_ent, weapon))
				{
					targetsValid[targetsValid.size] = target_ent;
				}
			}
		}
	}
	chosenEnt = undefined;
	if(targetsValid.size != 0)
	{
		chosenEnt = targetsValid[0];
	}
	return chosenEnt;
}

/*
	Name: canTargetEntity
	Namespace: hacker_tool
	Checksum: 0x7F0CAB
	Offset: 0x2048
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function canTargetEntity(target, weapon)
{
	if(!self isWithinHackerToolReticle(target, weapon))
	{
		return 0;
	}
	if(!isValidHackerToolTarget(target, weapon, 1))
	{
		return 0;
	}
	return 1;
}

/*
	Name: isWithinHackerToolReticle
	Namespace: hacker_tool
	Checksum: 0xD900A690
	Offset: 0x20B8
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function isWithinHackerToolReticle(target, weapon)
{
	radiusInner = getHackerToolInnerRadius(target);
	radiusOuter = getHackerToolOuterRadius(target);
	if(Target_ScaleMinMaxRadius(target, self, level.hackerToolLockOnFOV, radiusInner, radiusOuter) > 0)
	{
		return 1;
	}
	return Target_BoundingIsUnderReticle(self, target, weapon.lockOnMaxRange);
}

/*
	Name: hackingTimeScale
	Namespace: hacker_tool
	Checksum: 0x97DCCD21
	Offset: 0x2180
	Size: 0x1F5
	Parameters: 1
	Flags: None
*/
function hackingTimeScale(target)
{
	hackRatio = 1;
	radiusInner = getHackerToolInnerRadius(target);
	radiusOuter = getHackerToolOuterRadius(target);
	if(radiusInner != radiusOuter)
	{
		scale = Target_ScaleMinMaxRadius(target, self, level.hackerToolLockOnFOV, radiusInner, radiusOuter);
		scale = scale * scale * scale * scale;
		hackTime = LerpFloat(getHackOuterTime(target), getHackTime(target), scale);
		/#
			hackerToolDebugText = GetDvarInt("Dev Block strings are not supported", 0);
			if(hackerToolDebugText)
			{
				print3d(target.origin, "Dev Block strings are not supported" + scale + "Dev Block strings are not supported" + radiusInner + "Dev Block strings are not supported" + radiusOuter, (0, 0, 0), 1, hackerToolDebugText, 2);
			}
			/#
				Assert(hackTime > 0);
			#/
		#/
		hackRatio = getHackTime(target) / hackTime;
		if(!isdefined(hackRatio))
		{
			hackRatio = 1;
		}
	}
	return hackRatio;
}

/*
	Name: hackingTimeNoLineOfSightScale
	Namespace: hacker_tool
	Checksum: 0x69E6E6C7
	Offset: 0x2380
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function hackingTimeNoLineOfSightScale(target)
{
	hackRatio = 1;
	if(isdefined(target.killstreakHackLostLineOfSightTimeMs) && target.killstreakHackLostLineOfSightTimeMs > 0)
	{
		/#
			/#
				Assert(target.killstreakHackLostLineOfSightTimeMs > 0);
			#/
		#/
		hackRatio = 1000 / target.killstreakHackLostLineOfSightTimeMs;
	}
	return hackRatio;
}

/*
	Name: isEntityHackableWeaponObject
	Namespace: hacker_tool
	Checksum: 0x6328526B
	Offset: 0x2420
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function isEntityHackableWeaponObject(entity)
{
	if(isdefined(entity.classname) && entity.classname == "grenade")
	{
		if(isdefined(entity.weapon))
		{
			watcher = weaponobjects::getWeaponObjectWatcherByWeapon(entity.weapon);
			if(isdefined(watcher))
			{
				if(watcher.hackable)
				{
					/#
						/#
							Assert(isdefined(watcher.hackerToolRadius));
						#/
						/#
							Assert(isdefined(watcher.hackerToolTimeMs));
						#/
					#/
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: getWeaponObjectHackerRadius
	Namespace: hacker_tool
	Checksum: 0x60700721
	Offset: 0x2518
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function getWeaponObjectHackerRadius(entity)
{
	/#
		/#
			Assert(isdefined(entity.classname));
		#/
		/#
			Assert(isdefined(entity.weapon));
		#/
	#/
	watcher = weaponobjects::getWeaponObjectWatcherByWeapon(entity.weapon);
	/#
		/#
			Assert(watcher.hackable);
		#/
		/#
			Assert(isdefined(watcher.hackerToolRadius));
		#/
	#/
	return watcher.hackerToolRadius;
}

/*
	Name: getWeaponObjectHackTimeMs
	Namespace: hacker_tool
	Checksum: 0x3C257CD8
	Offset: 0x2608
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function getWeaponObjectHackTimeMs(entity)
{
	/#
		/#
			Assert(isdefined(entity.classname));
		#/
		/#
			Assert(isdefined(entity.weapon));
		#/
	#/
	watcher = weaponobjects::getWeaponObjectWatcherByWeapon(entity.weapon);
	/#
		/#
			Assert(watcher.hackable);
		#/
		/#
			Assert(isdefined(watcher.hackerToolTimeMs));
		#/
	#/
	return watcher.hackerToolTimeMs;
}

/*
	Name: isEntityHackableCarePackage
	Namespace: hacker_tool
	Checksum: 0x7FA0D92D
	Offset: 0x26F8
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function isEntityHackableCarePackage(entity)
{
	if(isdefined(entity.model))
	{
		return entity.model == "wpn_t7_care_package_world";
	}
	else
	{
		return 0;
	}
}

/*
	Name: isValidHackerToolTarget
	Namespace: hacker_tool
	Checksum: 0x8536CD75
	Offset: 0x2748
	Size: 0x175
	Parameters: 3
	Flags: None
*/
function isValidHackerToolTarget(ent, weapon, allowHacked)
{
	if(!isdefined(ent))
	{
		return 0;
	}
	if(self util::isUsingRemote())
	{
		return 0;
	}
	if(self IsEmpJammed())
	{
		return 0;
	}
	if(!Target_IsTarget(ent) || (isdefined(ent.allowHackingAfterCloak) && ent.allowHackingAfterCloak == 1) && !isEntityHackableWeaponObject(ent) && !IsInArray(level.hackerToolTargets, ent))
	{
		return 0;
	}
	if(isEntityHackableWeaponObject(ent))
	{
		if(DistanceSquared(self.origin, ent.origin) > weapon.lockOnMaxRange * weapon.lockOnMaxRange)
		{
			return 0;
		}
	}
	if(allowHacked == 0 && isEntityPreviouslyHacked(ent))
	{
		return 0;
	}
	return 1;
}

/*
	Name: isEntityPreviouslyHacked
	Namespace: hacker_tool
	Checksum: 0x7BE46E6A
	Offset: 0x28C8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function isEntityPreviouslyHacked(entity)
{
	if(isdefined(entity.previouslyHacked) && entity.previouslyHacked)
	{
		return 1;
	}
	return 0;
}

/*
	Name: hackerSoftSightTest
	Namespace: hacker_tool
	Checksum: 0xA93FD6F3
	Offset: 0x2910
	Size: 0x19F
	Parameters: 1
	Flags: None
*/
function hackerSoftSightTest(weapon)
{
	passed = 1;
	lockOnTime = 0;
	if(isdefined(self.hackerToolTarget))
	{
		lockOnTime = self getLockOnTime(self.hackerToolTarget, weapon);
	}
	if(lockOnTime == 0 || self IsEmpJammed())
	{
		self clearHackerTarget(weapon, 0, 0);
		passed = 0;
	}
	else if(isWithinHackerToolReticle(self.hackerToolTarget, weapon) && self heatseekingmissile::LockSightTest(self.hackerToolTarget))
	{
		self.hackerToolLostSightlineTime = 0;
	}
	else if(self.hackerToolLostSightlineTime == 0)
	{
		self.hackerToolLostSightlineTime = GetTime();
	}
	timePassed = GetTime() - self.hackerToolLostSightlineTime;
	lostLineOfSightTimeLimitMsec = level.hackerToolLostSightLimitMs;
	if(isdefined(self.hackerToolTarget.killstreakHackLostLineOfSightLimitMs))
	{
		lostLineOfSightTimeLimitMsec = self.hackerToolTarget.killstreakHackLostLineOfSightLimitMs;
	}
	if(timePassed >= lostLineOfSightTimeLimitMsec)
	{
		self clearHackerTarget(weapon, 0, 0);
		passed = 0;
	}
	return passed;
}

/*
	Name: registerWithHackerTool
	Namespace: hacker_tool
	Checksum: 0xFC192F06
	Offset: 0x2AB8
	Size: 0xA1
	Parameters: 2
	Flags: None
*/
function registerWithHackerTool(radius, hackTimeMs)
{
	self endon("death");
	if(isdefined(radius))
	{
		self.hackerToolRadius = radius;
	}
	else
	{
		self.hackerToolRadius = level.hackerToolLockOnRadius;
	}
	if(isdefined(hackTimeMs))
	{
		self.hackerToolTimeMs = hackTimeMs;
	}
	else
	{
		self.hackerToolTimeMs = level.hackerToolHackTimeMs;
	}
	self thread watchHackableEntityDeath();
	level.hackerToolTargets[level.hackerToolTargets.size] = self;
}

/*
	Name: watchHackableEntityDeath
	Namespace: hacker_tool
	Checksum: 0x935FC665
	Offset: 0x2B68
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function watchHackableEntityDeath()
{
	self waittill("death");
	ArrayRemoveValue(level.hackerToolTargets, self);
}

/*
	Name: getHackerToolInnerRadius
	Namespace: hacker_tool
	Checksum: 0xF309D80B
	Offset: 0x2BA0
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function getHackerToolInnerRadius(target)
{
	radius = level.hackerToolLockOnRadius;
	if(isEntityHackableCarePackage(target))
	{
		/#
			/#
				Assert(isdefined(target.hackerToolRadius));
			#/
		#/
		radius = target.hackerToolRadius;
	}
	else if(isEntityHackableWeaponObject(target))
	{
		radius = getWeaponObjectHackerRadius(target);
	}
	else if(isdefined(target.hackerToolInnerRadius))
	{
		radius = target.hackerToolInnerRadius;
	}
	else if(isdefined(target.hackerToolRadius))
	{
		radius = target.hackerToolRadius;
	}
	return radius;
}

/*
	Name: getHackerToolOuterRadius
	Namespace: hacker_tool
	Checksum: 0x6A8A3C79
	Offset: 0x2CB8
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function getHackerToolOuterRadius(target)
{
	radius = level.hackerToolLockOnRadius;
	if(isEntityHackableCarePackage(target))
	{
		/#
			/#
				Assert(isdefined(target.hackerToolRadius));
			#/
		#/
		radius = target.hackerToolRadius;
	}
	else if(isEntityHackableWeaponObject(target))
	{
		radius = getWeaponObjectHackerRadius(target);
	}
	else if(isdefined(target.hackerToolOuterRadius))
	{
		radius = target.hackerToolOuterRadius;
	}
	else if(isdefined(target.hackerToolRadius))
	{
		radius = target.hackerToolRadius;
	}
	return radius;
}

/*
	Name: getHackTime
	Namespace: hacker_tool
	Checksum: 0x995590C0
	Offset: 0x2DD0
	Size: 0x167
	Parameters: 1
	Flags: None
*/
function getHackTime(target)
{
	time = 500;
	if(isEntityHackableCarePackage(target))
	{
		/#
			/#
				Assert(isdefined(target.hackerToolTimeMs));
			#/
		#/
		if(isdefined(target.owner) && target.owner == self)
		{
			time = level.carePackageOwnerHackerToolTimeMs;
		}
		else if(isdefined(target.owner) && target.owner.team == self.team)
		{
			time = level.carePackageFriendlyHackerToolTimeMs;
		}
		else
		{
			time = level.carePackageHackerToolTimeMs;
		}
	}
	else if(isEntityHackableWeaponObject(target))
	{
		time = getWeaponObjectHackTimeMs(target);
	}
	else if(isdefined(target.hackerToolInnerTimeMs))
	{
		time = target.hackerToolInnerTimeMs;
	}
	else
	{
		time = level.vehicleHackerToolTimeMs;
	}
	return time;
}

/*
	Name: getHackOuterTime
	Namespace: hacker_tool
	Checksum: 0x3F16001F
	Offset: 0x2F40
	Size: 0x167
	Parameters: 1
	Flags: None
*/
function getHackOuterTime(target)
{
	time = 500;
	if(isEntityHackableCarePackage(target))
	{
		/#
			/#
				Assert(isdefined(target.hackerToolTimeMs));
			#/
		#/
		if(isdefined(target.owner) && target.owner == self)
		{
			time = level.carePackageOwnerHackerToolTimeMs;
		}
		else if(isdefined(target.owner) && target.owner.team == self.team)
		{
			time = level.carePackageFriendlyHackerToolTimeMs;
		}
		else
		{
			time = level.carePackageHackerToolTimeMs;
		}
	}
	else if(isEntityHackableWeaponObject(target))
	{
		time = getWeaponObjectHackTimeMs(target);
	}
	else if(isdefined(target.hackerToolOuterTimeMs))
	{
		time = target.hackerToolOuterTimeMs;
	}
	else
	{
		time = level.vehicleHackerToolTimeMs;
	}
	return time;
}

/*
	Name: getLockOnTime
	Namespace: hacker_tool
	Checksum: 0x9E10EE08
	Offset: 0x30B0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function getLockOnTime(target, weapon)
{
	lockLengthMs = self getHackTime(self.hackerToolTarget);
	if(lockLengthMs == 0)
	{
		return 0;
	}
	lockOnSpeed = weapon.lockOnSpeed;
	if(lockOnSpeed <= 0)
	{
		lockOnSpeed = 1000;
	}
	return lockLengthMs / lockOnSpeed;
}

/*
	Name: TUNABLES
	Namespace: hacker_tool
	Checksum: 0xFB00F307
	Offset: 0x3148
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function TUNABLES()
{
	/#
		while(1)
		{
			level.hackerToolLostSightLimitMs = GetDvarInt("Dev Block strings are not supported", 1000);
			level.hackerToolLockOnRadius = GetDvarFloat("Dev Block strings are not supported", 20);
			level.hackerToolLockOnFOV = GetDvarInt("Dev Block strings are not supported", 65);
			wait(1);
		}
	#/
}

