#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_bb;
#using scripts\zm\_challenges;
#using scripts\zm\_sticky_grenade;
#using scripts\zm\_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_shellshock;
#using scripts\zm\gametypes\_weapon_utils;
#using scripts\zm\gametypes\_weaponobjects;

#namespace weapons;

/*
	Name: init
	Namespace: weapons
	Checksum: 0xD96E02AF
	Offset: 0x678
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function init()
{
	level.MissileEntities = [];
	level.hackerToolTargets = [];
	if(!isdefined(level.grenadeLauncherDudTime))
	{
		level.grenadeLauncherDudTime = 0;
	}
	if(!isdefined(level.thrownGrenadeDudTime))
	{
		level.thrownGrenadeDudTime = 0;
	}
	level thread onPlayerConnect();
	if(level._uses_sticky_grenades)
	{
		_sticky_grenade::init();
	}
}

/*
	Name: onPlayerConnect
	Namespace: weapons
	Checksum: 0x7961BAA
	Offset: 0x708
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player.usedWeapons = 0;
		player.lastFireTime = 0;
		player.hits = 0;
		player scavenger_hud_create();
		player thread onPlayerSpawned();
	}
}

/*
	Name: onPlayerSpawned
	Namespace: weapons
	Checksum: 0xFB4E9F26
	Offset: 0x790
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self.concussionEndTime = 0;
		self.hasDoneCombat = 0;
		self.shieldDamageBlocked = 0;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		self thread watchMissileUsage();
		self thread watchWeaponChange();
		self thread watchRiotShieldUse();
		self thread trackWeapon();
		self.droppedDeathWeapon = undefined;
		self.tookWeaponFrom = [];
		self.pickedUpWeaponKills = [];
		self thread updateStowedWeapon();
	}
}

/*
	Name: watchWeaponChange
	Namespace: weapons
	Checksum: 0x19A8905E
	Offset: 0x8A0
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function watchWeaponChange()
{
	self endon("death");
	self endon("disconnect");
	self.lastdroppableweapon = self GetCurrentWeapon();
	while(1)
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill("weapon_change", newWeapon);
		if(mayDropWeapon(newWeapon))
		{
			self.lastdroppableweapon = newWeapon;
		}
	}
}

/*
	Name: watchRiotShieldUse
	Namespace: weapons
	Checksum: 0x99EC1590
	Offset: 0x948
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function watchRiotShieldUse()
{
}

/*
	Name: updateLastHeldWeaponTimings
	Namespace: weapons
	Checksum: 0xD45EAD11
	Offset: 0x958
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function updateLastHeldWeaponTimings(newTime)
{
	if(isdefined(self.currentWeapon) && isdefined(self.currentWeaponStartTime))
	{
		totalTime = Int(newTime - self.currentWeaponStartTime / 1000);
		if(totalTime > 0)
		{
			self addweaponstat(self.currentWeapon, "timeUsed", totalTime);
			self.currentWeaponStartTime = newTime;
		}
	}
}

/*
	Name: updateWeaponTimings
	Namespace: weapons
	Checksum: 0xEB5CAB41
	Offset: 0x9F8
	Size: 0x365
	Parameters: 1
	Flags: None
*/
function updateWeaponTimings(newTime)
{
	if(self util::is_bot())
	{
		return;
	}
	updateLastHeldWeaponTimings(newTime);
	if(!isdefined(self.staticWeaponsStartTime))
	{
		return;
	}
	totalTime = Int(newTime - self.staticWeaponsStartTime / 1000);
	if(totalTime < 0)
	{
		return;
	}
	self.staticWeaponsStartTime = newTime;
	if(isdefined(self.weapon_array_grenade))
	{
		for(i = 0; i < self.weapon_array_grenade.size; i++)
		{
			self addweaponstat(self.weapon_array_grenade[i], "timeUsed", totalTime);
		}
	}
	else if(isdefined(self.weapon_array_inventory))
	{
		for(i = 0; i < self.weapon_array_inventory.size; i++)
		{
			self addweaponstat(self.weapon_array_inventory[i], "timeUsed", totalTime);
		}
	}
	else if(isdefined(self.killstreak))
	{
		for(i = 0; i < self.killstreak.size; i++)
		{
			killstreakWeapon = level.menuReferenceForKillStreak[self.killstreak[i]];
			if(isdefined(killstreakWeapon))
			{
				self addweaponstat(killstreakWeapon, "timeUsed", totalTime);
			}
		}
	}
	else if(level.rankedMatch && level.perksEnabled)
	{
		perksIndexArray = [];
		specialtys = self.specialty;
		if(!isdefined(specialtys))
		{
			return;
		}
		if(!isdefined(self.curClass))
		{
			return;
		}
		if(isdefined(self.class_num))
		{
			for(numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++)
			{
				perk = self GetLoadoutItem(self.class_num, "specialty" + numSpecialties + 1);
				if(perk != 0)
				{
					perksIndexArray[perk] = 1;
				}
			}
			perkIndexArrayKeys = getArrayKeys(perksIndexArray);
			for(i = 0; i < perkIndexArrayKeys.size; i++)
			{
				if(perksIndexArray[perkIndexArrayKeys[i]] == 1)
				{
					self AddDStat("itemStats", perkIndexArrayKeys[i], "stats", "timeUsed", "statValue", totalTime);
				}
			}
		}
	}
}

/*
	Name: trackWeapon
	Namespace: weapons
	Checksum: 0xA71B6BA8
	Offset: 0xD68
	Size: 0x199
	Parameters: 0
	Flags: None
*/
function trackWeapon()
{
	currentWeapon = self GetCurrentWeapon();
	currentTime = GetTime();
	spawnid = getplayerspawnid(self);
	while(1)
	{
		event = self util::waittill_any_return("weapon_change", "death", "disconnect");
		newTime = GetTime();
		if(event == "weapon_change")
		{
			self bb::commit_weapon_data(spawnid, currentWeapon, currentTime);
			newWeapon = self GetCurrentWeapon();
			if(newWeapon != level.weaponNone && newWeapon != currentWeapon)
			{
				updateLastHeldWeaponTimings(newTime);
				currentWeapon = newWeapon;
				currentTime = newTime;
			}
		}
		else if(event != "disconnect")
		{
			self bb::commit_weapon_data(spawnid, currentWeapon, currentTime);
			updateWeaponTimings(newTime);
		}
		return;
	}
}

/*
	Name: mayDropWeapon
	Namespace: weapons
	Checksum: 0xC01DE2F7
	Offset: 0xF10
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function mayDropWeapon(weapon)
{
	if(level.disableWeaponDrop == 1)
	{
		return 0;
	}
	if(weapon == level.weaponNone)
	{
		return 0;
	}
	if(!weapon.isPrimary)
	{
		return 0;
	}
	return 1;
}

/*
	Name: dropWeaponForDeath
	Namespace: weapons
	Checksum: 0x173D27EB
	Offset: 0xF68
	Size: 0x413
	Parameters: 1
	Flags: None
*/
function dropWeaponForDeath(attacker)
{
	if(level.disableWeaponDrop == 1)
	{
		return;
	}
	weapon = self.lastdroppableweapon;
	if(isdefined(self.droppedDeathWeapon))
	{
		return;
	}
	if(!isdefined(weapon))
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported");
			}
		#/
		return;
	}
	if(weapon == level.weaponNone)
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported");
			}
		#/
		return;
	}
	if(!self HasWeapon(weapon))
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported");
			}
		#/
		return;
	}
	if(!self AnyAmmoForWeaponModes(weapon))
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported");
			}
		#/
		return;
	}
	if(!shouldDropLimitedWeapon(weapon, self))
	{
		return;
	}
	clipAmmo = self GetWeaponAmmoClip(weapon);
	stockAmmo = self GetWeaponAmmoStock(weapon);
	clip_and_stock_ammo = clipAmmo + stockAmmo;
	if(!clip_and_stock_ammo)
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported");
			}
		#/
		return;
	}
	stockMax = weapon.maxAmmo;
	if(stockAmmo > stockMax)
	{
		stockAmmo = stockMax;
	}
	item = self dropItem(weapon);
	if(!isdefined(item))
	{
		/#
			IPrintLnBold("Dev Block strings are not supported" + weapon.name);
		#/
		return;
	}
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported" + weapon.name);
		}
	#/
	dropLimitedWeapon(weapon, self, item);
	self.droppedDeathWeapon = 1;
	item ItemWeaponSetAmmo(clipAmmo, stockAmmo);
	item.owner = self;
	item.ownersattacker = attacker;
	item thread WatchPickup();
	item thread deletePickupAfterAWhile();
}

/*
	Name: deletePickupAfterAWhile
	Namespace: weapons
	Checksum: 0x1A924208
	Offset: 0x1388
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function deletePickupAfterAWhile()
{
	self endon("death");
	wait(60);
	if(!isdefined(self))
	{
		return;
	}
	self delete();
}

/*
	Name: WatchPickup
	Namespace: weapons
	Checksum: 0xB39150D
	Offset: 0x13C8
	Size: 0x27F
	Parameters: 0
	Flags: None
*/
function WatchPickup()
{
	self endon("death");
	weapon = self.item;
	while(1)
	{
		self waittill("trigger", player, droppedItem);
		if(isdefined(droppedItem))
		{
			break;
		}
	}
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported" + isdefined(self.ownersattacker));
		}
	#/
	/#
		Assert(isdefined(player.tookWeaponFrom));
	#/
	/#
		Assert(isdefined(player.pickedUpWeaponKills));
	#/
	if(isdefined(droppedItem))
	{
		for(i = 0; i < droppedItem.size; i++)
		{
			if(!isdefined(droppedItem[i]))
			{
				continue;
			}
			droppedWeapon = droppedItem[i].item;
			if(isdefined(player.tookWeaponFrom[droppedWeapon]))
			{
				droppedItem[i].owner = player.tookWeaponFrom[droppedWeapon];
				droppedItem[i].ownersattacker = player;
				player.tookWeaponFrom[droppedWeapon] = undefined;
			}
			droppedItem[i] thread WatchPickup();
		}
	}
	else if(isdefined(self.ownersattacker) && self.ownersattacker == player)
	{
		player.tookWeaponFrom[weapon] = self.owner;
		player.pickedUpWeaponKills[weapon] = 0;
	}
	else
	{
		player.tookWeaponFrom[weapon] = undefined;
		player.pickedUpWeaponKills[weapon] = undefined;
	}
}

/*
	Name: watchWeaponUsage
	Namespace: weapons
	Checksum: 0xAD16D980
	Offset: 0x1650
	Size: 0x20D
	Parameters: 0
	Flags: None
*/
function watchWeaponUsage()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self.usedKillstreakWeapon = [];
	self.usedKillstreakWeapon["minigun"] = 0;
	self.usedKillstreakWeapon["m32"] = 0;
	self.usedKillstreakWeapon["m202_flash"] = 0;
	self.usedKillstreakWeapon["m220_tow"] = 0;
	self.usedKillstreakWeapon["mp40_blinged"] = 0;
	self.killstreakType = [];
	self.killstreakType["minigun"] = "minigun";
	self.killstreakType["m32"] = "m32";
	self.killstreakType["m202_flash"] = "m202_flash";
	self.killstreakType["m220_tow"] = "m220_tow";
	self.killstreakType["mp40_blinged"] = "mp40_blinged_drop";
	for(;;)
	{
		self waittill("weapon_fired", curWeapon);
		self.lastFireTime = GetTime();
		self.hasDoneCombat = 1;
		switch(curWeapon.weapClass)
		{
			case "mg":
			case "pistol":
			case "rifle":
			case "smg":
			case "spread":
			{
				self trackWeaponFire(curWeapon);
				level.globalShotsFired++;
				break;
			}
			case "grenade":
			case "rocketlauncher":
			{
				self addweaponstat(curWeapon, "shots", 1);
				break;
			}
			case default:
			{
				break;
			}
		}
	}
}

/*
	Name: trackWeaponFire
	Namespace: weapons
	Checksum: 0xBC14F341
	Offset: 0x1868
	Size: 0x2D3
	Parameters: 1
	Flags: None
*/
function trackWeaponFire(curWeapon)
{
	shotsfired = 1;
	if(isdefined(self.lastStandParams) && self.lastStandParams.lastStandStartTime == GetTime())
	{
		self.hits = 0;
		return;
	}
	PixBeginEvent("trackWeaponFire");
	misses = Int(max(0, shotsfired - self.hits));
	self addweaponstat(curWeapon, "shots", shotsfired);
	self addweaponstat(curWeapon, "hits", self.hits);
	self addweaponstat(curWeapon, "misses", misses);
	if(isdefined(level.add_client_stat))
	{
		self [[level.add_client_stat]]("total_shots", shotsfired);
		self [[level.add_client_stat]]("hits", self.hits);
		self [[level.add_client_stat]]("misses", misses);
	}
	else
	{
		self AddPlayerStat("total_shots", shotsfired);
		self AddPlayerStat("hits", self.hits);
		self AddPlayerStat("misses", misses);
	}
	self IncrementPlayerStat("total_shots", shotsfired);
	self IncrementPlayerStat("hits", self.hits);
	self IncrementPlayerStat("misses", misses);
	self bb::add_to_stat("shots", shotsfired);
	self bb::add_to_stat("hits", self.hits);
	self bb::add_to_stat("misses", misses);
	self.hits = 0;
	PixEndEvent();
}

/*
	Name: watchGrenadeUsage
	Namespace: weapons
	Checksum: 0x93EA0A08
	Offset: 0x1B48
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function watchGrenadeUsage()
{
	self endon("death");
	self endon("disconnect");
	self.throwingGrenade = 0;
	self.gotPullbackNotify = 0;
	self thread beginOtherGrenadeTracking();
	self thread watchForThrowbacks();
	self thread watchForGrenadeDuds();
	self thread watchForGrenadeLauncherDuds();
	for(;;)
	{
		self waittill("grenade_pullback", weapon);
		self addweaponstat(weapon, "shots", 1);
		self.hasDoneCombat = 1;
		self.throwingGrenade = 1;
		self.gotPullbackNotify = 1;
		if(weapon.drawOffhandModelInHand)
		{
			self SetOffhandVisible(1);
			self thread watch_offhand_end();
		}
		self thread beginGrenadeTracking();
	}
}

/*
	Name: watchMissileUsage
	Namespace: weapons
	Checksum: 0x6A6353D5
	Offset: 0x1CA0
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function watchMissileUsage()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("missile_fire", missile, weapon);
		self.hasDoneCombat = 1;
		/#
			/#
				Assert(isdefined(missile));
			#/
		#/
		level.MissileEntities[level.MissileEntities.size] = missile;
		missile.weapon = weapon;
		missile thread watchMissileDeath();
	}
}

/*
	Name: watchMissileDeath
	Namespace: weapons
	Checksum: 0xC25B5985
	Offset: 0x1D68
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function watchMissileDeath()
{
	self waittill("death");
	ArrayRemoveValue(level.MissileEntities, self);
}

/*
	Name: dropWeaponsToGround
	Namespace: weapons
	Checksum: 0x763D29B0
	Offset: 0x1DA0
	Size: 0x111
	Parameters: 2
	Flags: None
*/
function dropWeaponsToGround(origin, radius)
{
	weapons = GetDroppedWeapons();
	for(i = 0; i < weapons.size; i++)
	{
		if(DistanceSquared(origin, weapons[i].origin) < radius * radius)
		{
			trace = bullettrace(weapons[i].origin, weapons[i].origin + VectorScale((0, 0, -1), 2000), 0, weapons[i]);
			weapons[i].origin = trace["position"];
		}
	}
}

/*
	Name: dropGrenadesToGround
	Namespace: weapons
	Checksum: 0x3E415C7F
	Offset: 0x1EC0
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function dropGrenadesToGround(origin, radius)
{
	grenades = GetEntArray("grenade", "classname");
	for(i = 0; i < grenades.size; i++)
	{
		if(DistanceSquared(origin, grenades[i].origin) < radius * radius)
		{
			grenades[i] launch(VectorScale((1, 1, 1), 5));
		}
	}
}

/*
	Name: watchGrenadeCancel
	Namespace: weapons
	Checksum: 0xAB70A74B
	Offset: 0x1F98
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function watchGrenadeCancel()
{
	self endon("death");
	self endon("disconnect");
	self endon("grenade_fire");
	waittillframeend;
	weapon = level.weaponNone;
	while(self IsThrowingGrenade() && weapon == level.weaponNone)
	{
		self waittill("weapon_change", weapon);
	}
	self.throwingGrenade = 0;
	self.gotPullbackNotify = 0;
}

/*
	Name: watch_offhand_end
	Namespace: weapons
	Checksum: 0x31529B14
	Offset: 0x2038
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function watch_offhand_end()
{
	self notify("watchOffhandEnd");
	self endon("watchOffhandEnd");
	while(self is_using_offhand_equipment())
	{
		msg = self util::waittill_any_return("death", "disconnect", "grenade_fire", "weapon_change", "watchOffhandEnd");
		if(msg == "death" || msg == "disconnect")
		{
			break;
		}
	}
	self SetOffhandVisible(0);
}

/*
	Name: is_using_offhand_equipment
	Namespace: weapons
	Checksum: 0x7B54B542
	Offset: 0x2100
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function is_using_offhand_equipment()
{
	if(self isUsingOffhand())
	{
		weapon = self getCurrentOffhand();
		if(weapon.isEquipment)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: beginGrenadeTracking
	Namespace: weapons
	Checksum: 0x656BA655
	Offset: 0x2168
	Size: 0x15F
	Parameters: 0
	Flags: None
*/
function beginGrenadeTracking()
{
	self endon("death");
	self endon("disconnect");
	startTime = GetTime();
	self thread watchGrenadeCancel();
	self waittill("grenade_fire", grenade, weapon);
	if(!isdefined(grenade))
	{
		return;
	}
	level.MissileEntities[level.MissileEntities.size] = grenade;
	grenade.weapon = weapon;
	grenade thread watchMissileDeath();
	if(grenade util::isHacked())
	{
		return;
	}
	if(GetTime() - startTime > 1000)
	{
		grenade.isCooked = 1;
	}
	switch(weapon.name)
	{
		case "frag_grenade":
		case "sticky_grenade":
		{
			self addweaponstat(weapon, "used", 1);
		}
		case "explosive_bolt":
		{
			grenade.originalowner = self;
			break;
		}
	}
	self.throwingGrenade = 0;
}

/*
	Name: beginOtherGrenadeTracking
	Namespace: weapons
	Checksum: 0x99EC1590
	Offset: 0x22D0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function beginOtherGrenadeTracking()
{
}

/*
	Name: checkStuckToPlayer
	Namespace: weapons
	Checksum: 0xD2E200B8
	Offset: 0x22E0
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function checkStuckToPlayer(deleteOnTeamChange, awardScoreEvent, weapon)
{
	self endon("death");
	self waittill("stuck_to_player", player);
	if(isdefined(player))
	{
		if(deleteOnTeamChange)
		{
			self thread stuckToPlayerTeamChange(player);
		}
		if(awardScoreEvent && isdefined(self.originalowner))
		{
		}
		self.stuckToPlayer = player;
	}
}

/*
	Name: checkHatchetBounce
	Namespace: weapons
	Checksum: 0x1F721B2E
	Offset: 0x2398
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function checkHatchetBounce()
{
	self endon("stuck_to_player");
	self endon("death");
	self waittill("grenade_bounce");
	self.bounced = 1;
}

/*
	Name: stuckToPlayerTeamChange
	Namespace: weapons
	Checksum: 0xD6A97969
	Offset: 0x23D8
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function stuckToPlayerTeamChange(player)
{
	self endon("death");
	player endon("disconnect");
	originalteam = player.pers["team"];
	while(1)
	{
		player waittill("joined_team");
		if(player.pers["team"] != originalteam)
		{
			self detonate();
			return;
		}
	}
}

/*
	Name: watchForThrowbacks
	Namespace: weapons
	Checksum: 0xCE5F43D4
	Offset: 0x2480
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function watchForThrowbacks()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(self.gotPullbackNotify)
		{
			self.gotPullbackNotify = 0;
			continue;
		}
		if(!IsSubStr(weapon.name, "frag_"))
		{
			continue;
		}
		grenade.threwBack = 1;
		grenade.originalowner = self;
	}
}

/*
	Name: registerGrenadeLauncherDudDvar
	Namespace: weapons
	Checksum: 0xDB3C89C
	Offset: 0x2530
	Size: 0x133
	Parameters: 4
	Flags: None
*/
function registerGrenadeLauncherDudDvar(dvarString, defaultValue, minValue, maxValue)
{
	dvarString = "scr_" + dvarString + "_grenadeLauncherDudTime";
	if(GetDvarString(dvarString) == "")
	{
		SetDvar(dvarString, defaultValue);
	}
	if(GetDvarInt(dvarString) > maxValue)
	{
		SetDvar(dvarString, maxValue);
	}
	else if(GetDvarInt(dvarString) < minValue)
	{
		SetDvar(dvarString, minValue);
	}
	level.grenadeLauncherDudTimeDvar = dvarString;
	level.grenadeLauncherDudTimeMin = minValue;
	level.grenadeLauncherDudTimeMax = maxValue;
	level.grenadeLauncherDudTime = GetDvarInt(level.grenadeLauncherDudTimeDvar);
}

/*
	Name: registerThrownGrenadeDudDvar
	Namespace: weapons
	Checksum: 0xC6DF581E
	Offset: 0x2670
	Size: 0x133
	Parameters: 4
	Flags: None
*/
function registerThrownGrenadeDudDvar(dvarString, defaultValue, minValue, maxValue)
{
	dvarString = "scr_" + dvarString + "_thrownGrenadeDudTime";
	if(GetDvarString(dvarString) == "")
	{
		SetDvar(dvarString, defaultValue);
	}
	if(GetDvarInt(dvarString) > maxValue)
	{
		SetDvar(dvarString, maxValue);
	}
	else if(GetDvarInt(dvarString) < minValue)
	{
		SetDvar(dvarString, minValue);
	}
	level.thrownGrenadeDudTimeDvar = dvarString;
	level.thrownGrenadeDudTimeMin = minValue;
	level.thrownGrenadeDudTimeMax = maxValue;
	level.thrownGrenadeDudTime = GetDvarInt(level.thrownGrenadeDudTimeDvar);
}

/*
	Name: registerKillstreakDelay
	Namespace: weapons
	Checksum: 0x3DF6DE2
	Offset: 0x27B0
	Size: 0x10B
	Parameters: 4
	Flags: None
*/
function registerKillstreakDelay(dvarString, defaultValue, minValue, maxValue)
{
	dvarString = "scr_" + dvarString + "_killstreakDelayTime";
	if(GetDvarString(dvarString) == "")
	{
		SetDvar(dvarString, defaultValue);
	}
	if(GetDvarInt(dvarString) > maxValue)
	{
		SetDvar(dvarString, maxValue);
	}
	else if(GetDvarInt(dvarString) < minValue)
	{
		SetDvar(dvarString, minValue);
	}
	level.killstreakRoundDelay = GetDvarInt(dvarString);
}

/*
	Name: turnGrenadeIntoADud
	Namespace: weapons
	Checksum: 0xD6353515
	Offset: 0x28C8
	Size: 0x15B
	Parameters: 3
	Flags: None
*/
function turnGrenadeIntoADud(weapon, isThrownGrenade, player)
{
	if(level.roundStartExplosiveDelay >= globallogic_utils::getTimePassed() / 1000)
	{
		if(weapon.disallowatmatchstart || WeaponHasAttachment(weapon, "gl"))
		{
			timeLeft = Int(level.roundStartExplosiveDelay - globallogic_utils::getTimePassed() / 1000);
			if(!timeLeft)
			{
				timeLeft = 1;
			}
			if(isThrownGrenade)
			{
				player IPrintLnBold(&"MP_GRENADE_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS");
			}
			else
			{
				player IPrintLnBold(&"MP_LAUNCHER_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS");
			}
			self makeGrenadeDud();
		}
	}
}

/*
	Name: watchForGrenadeDuds
	Namespace: weapons
	Checksum: 0x26D9D892
	Offset: 0x2A30
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function watchForGrenadeDuds()
{
	self endon("spawned_player");
	self endon("disconnect");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		grenade turnGrenadeIntoADud(weapon, 1, self);
	}
}

/*
	Name: watchForGrenadeLauncherDuds
	Namespace: weapons
	Checksum: 0xFAB2D8D0
	Offset: 0x2AA8
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function watchForGrenadeLauncherDuds()
{
	self endon("spawned_player");
	self endon("disconnect");
	while(1)
	{
		self waittill("grenade_launcher_fire", grenade, weapon);
		grenade turnGrenadeIntoADud(weapon, 0, self);
		/#
			/#
				Assert(isdefined(grenade));
			#/
		#/
		level.MissileEntities[level.MissileEntities.size] = grenade;
		grenade.weapon = weapon;
		grenade thread watchMissileDeath();
	}
}

/*
	Name: getDamageableEnts
	Namespace: weapons
	Checksum: 0xFE62F375
	Offset: 0x2B78
	Size: 0x657
	Parameters: 4
	Flags: None
*/
function getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	if(!isdefined(doLOS))
	{
		doLOS = 0;
	}
	if(!isdefined(startRadius))
	{
		startRadius = 0;
	}
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(!isalive(players[i]) || players[i].sessionstate != "playing")
		{
			continue;
		}
		playerpos = players[i].origin + VectorScale((0, 0, 1), 32);
		distSq = DistanceSquared(pos, playerpos);
		if(distSq < radius * radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = 1;
			newent.isADestructable = 0;
			newent.isADestructible = 0;
			newent.IsActor = 0;
			newent.entity = players[i];
			newent.damageCenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	grenades = GetEntArray("grenade", "classname");
	for(i = 0; i < grenades.size; i++)
	{
		entPos = grenades[i].origin;
		distSq = DistanceSquared(pos, entPos);
		if(distSq < radius * radius && (!doLOS || weaponDamageTracePassed(pos, entPos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = 0;
			newent.isADestructable = 0;
			newent.isADestructible = 0;
			newent.IsActor = 0;
			newent.entity = grenades[i];
			newent.damageCenter = entPos;
			ents[ents.size] = newent;
		}
	}
	destructibles = GetEntArray("destructible", "targetname");
	for(i = 0; i < destructibles.size; i++)
	{
		entPos = destructibles[i].origin;
		distSq = DistanceSquared(pos, entPos);
		if(distSq < radius * radius && (!doLOS || weaponDamageTracePassed(pos, entPos, startRadius, destructibles[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = 0;
			newent.isADestructable = 0;
			newent.isADestructible = 1;
			newent.IsActor = 0;
			newent.entity = destructibles[i];
			newent.damageCenter = entPos;
			ents[ents.size] = newent;
		}
	}
	destructables = GetEntArray("destructable", "targetname");
	for(i = 0; i < destructables.size; i++)
	{
		entPos = destructables[i].origin;
		distSq = DistanceSquared(pos, entPos);
		if(distSq < radius * radius && (!doLOS || weaponDamageTracePassed(pos, entPos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = 0;
			newent.isADestructable = 1;
			newent.isADestructible = 0;
			newent.IsActor = 0;
			newent.entity = destructables[i];
			newent.damageCenter = entPos;
			ents[ents.size] = newent;
		}
	}
	return ents;
}

/*
	Name: damageEnt
	Namespace: weapons
	Checksum: 0x6780BC4E
	Offset: 0x31D8
	Size: 0x19B
	Parameters: 7
	Flags: None
*/
function damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, damagepos, damagedir)
{
	if(self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, 0, sMeansOfDeath, weapon, damagepos, damagedir, "none", damagepos, 0, 0, (1, 0, 0));
	}
	else if(self.IsActor)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackActorDamage]](eInflictor, eAttacker, iDamage, 0, sMeansOfDeath, weapon, damagepos, damagedir, "none", damagepos, 0, 0, 0, (1, 0, 0));
	}
	else if(self.isADestructible)
	{
		self.damageOrigin = damagepos;
		self.entity DoDamage(iDamage, damagepos, eAttacker, eInflictor, 0, sMeansOfDeath, 0, weapon);
	}
	else
	{
		self.entity util::damage_notify_wrapper(iDamage, eAttacker, (0, 0, 0), (0, 0, 0), "mod_explosive", "", "");
	}
}

/*
	Name: debugLine
	Namespace: weapons
	Checksum: 0x74EA9136
	Offset: 0x3380
	Size: 0x6D
	Parameters: 3
	Flags: None
*/
function debugLine(a, b, color)
{
	/#
		for(i = 0; i < 600; i++)
		{
			line(a, b, color);
			wait(0.05);
		}
	#/
}

/*
	Name: onWeaponDamage
	Namespace: weapons
	Checksum: 0xEB3D34EC
	Offset: 0x33F8
	Size: 0x1F1
	Parameters: 5
	Flags: None
*/
function onWeaponDamage(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	self endon("death");
	self endon("disconnect");
	switch(weapon.name)
	{
		case "concussion_grenade":
		{
			radius = 512;
			if(self == eAttacker)
			{
				radius = radius * 0.5;
			}
			scale = 1 - Distance(self.origin, eInflictor.origin) / radius;
			if(scale < 0)
			{
				scale = 0;
			}
			time = 2 + 4 * scale;
			wait(0.05);
			if(self hasPerk("specialty_stunprotection"))
			{
				time = time * 0.1;
			}
			self thread playConcussionSound(time);
			if(self util::mayApplyScreenEffect())
			{
				self shellshock("concussion_grenade_mp", time, 0);
			}
			self.concussionEndTime = GetTime() + time * 1000;
			break;
		}
		case default:
		{
			if(isdefined(level.shellshockOnPlayerDamage))
			{
				[[level.shellshockOnPlayerDamage]](meansOfDeath, damage, weapon);
			}
			break;
		}
	}
}

/*
	Name: playConcussionSound
	Namespace: weapons
	Checksum: 0xE6198BD8
	Offset: 0x35F8
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function playConcussionSound(duration)
{
	self endon("death");
	self endon("disconnect");
	concussionSound = spawn("script_origin", (0, 0, 1));
	concussionSound.origin = self.origin;
	concussionSound LinkTo(self);
	concussionSound thread deleteEntOnOwnerDeath(self);
	concussionSound playsound("");
	concussionSound PlayLoopSound("");
	if(duration > 0.5)
	{
		wait(duration - 0.5);
	}
	concussionSound playsound("");
	concussionSound StopLoopSound(0.5);
	wait(0.5);
	concussionSound notify("delete");
	concussionSound delete();
}

/*
	Name: deleteEntOnOwnerDeath
	Namespace: weapons
	Checksum: 0x49A36EA3
	Offset: 0x3758
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function deleteEntOnOwnerDeath(owner)
{
	self endon("delete");
	owner waittill("death");
	self delete();
}

/*
	Name: updateStowedWeapon
	Namespace: weapons
	Checksum: 0xF56D828C
	Offset: 0x37A0
	Size: 0x2CF
	Parameters: 0
	Flags: None
*/
function updateStowedWeapon()
{
	self endon("spawned");
	self endon("killed_player");
	self endon("disconnect");
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	team = self.pers["team"];
	curClass = self.pers["class"];
	while(1)
	{
		self waittill("weapon_change", newWeapon);
		self.weapon_array_primary = [];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory = [];
		weaponsList = self GetWeaponsList();
		for(idx = 0; idx < weaponsList.size; idx++)
		{
			switch(weaponsList[idx])
			{
				case "m202_flash":
				case "m220_tow":
				case "m32":
				case "minigun":
				case "mp40_blinged":
				case "zipline":
				{
					continue;
				}
				case default:
				{
					break;
				}
			}
			if(is_primary_weapon(weaponsList[idx]))
			{
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
				continue;
			}
			if(is_side_arm(weaponsList[idx]))
			{
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponsList[idx];
				continue;
			}
			if(is_grenade(weaponsList[idx]))
			{
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponsList[idx];
				continue;
			}
			if(is_inventory(weaponsList[idx]))
			{
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponsList[idx];
				continue;
			}
			if(weaponsList[idx].isPrimary)
			{
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
			}
		}
		detach_all_weapons();
		stow_on_back();
		stow_on_hip();
	}
}

/*
	Name: loadout_get_class_num
	Namespace: weapons
	Checksum: 0x60A4E475
	Offset: 0x3A78
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function loadout_get_class_num()
{
	/#
		Assert(isPlayer(self));
	#/
	/#
		Assert(isdefined(self.curClass));
	#/
	if(isdefined(level.classToClassNum[self.curClass]))
	{
		return level.classToClassNum[self.curClass];
	}
	class_num = Int(self.curClass[self.curClass.size - 1]) - 1;
	if(-1 == class_num)
	{
		class_num = 9;
	}
	return class_num;
}

/*
	Name: loadout_get_offhand_weapon
	Namespace: weapons
	Checksum: 0xBA56357C
	Offset: 0x3B58
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function loadout_get_offhand_weapon(stat)
{
	if(isdefined(level.giveCustomLoadout))
	{
		return level.weaponNone;
	}
	class_num = self loadout_get_class_num();
	index = 0;
	if(isdefined(level.tbl_weaponIDs[index]) && isdefined(level.tbl_weaponIDs[index]["reference"]))
	{
		return GetWeapon(level.tbl_weaponIDs[index]["reference"]);
	}
	return level.weaponNone;
}

/*
	Name: loadout_get_offhand_count
	Namespace: weapons
	Checksum: 0x6403B9B7
	Offset: 0x3C18
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function loadout_get_offhand_count(stat)
{
	if(isdefined(level.giveCustomLoadout))
	{
		return 0;
	}
	class_num = self loadout_get_class_num();
	count = 0;
	return count;
}

/*
	Name: scavenger_think
	Namespace: weapons
	Checksum: 0x152F223C
	Offset: 0x3C78
	Size: 0x81D
	Parameters: 0
	Flags: None
*/
function scavenger_think()
{
	self endon("death");
	self waittill("scavenger", player);
	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons_and_alts = Array::exclude(player GetWeaponsList(1), primary_weapons);
	ArrayRemoveValue(offhand_weapons_and_alts, level.weaponBaseMelee);
	player playsound("wpn_ammo_pickup");
	player playlocalsound("wpn_ammo_pickup");
	player.scavenger_icon.alpha = 1;
	player.scavenger_icon fadeOverTime(2.5);
	player.scavenger_icon.alpha = 0;
	scavenger_lethal_proc = 1;
	scavenger_tactical_proc = 1;
	if(!isdefined(player.scavenger_lethal_proc))
	{
		player.scavenger_lethal_proc = 0;
		player.scavenger_tactical_proc = 0;
	}
	loadout_primary = player loadout_get_offhand_weapon("primarygrenade");
	loadout_primary_count = player loadout_get_offhand_count("primarygrenadecount");
	loadout_secondary = player loadout_get_offhand_weapon("specialgrenade");
	loadout_secondary_count = player loadout_get_offhand_count("specialgrenadeCount");
	for(i = 0; i < offhand_weapons_and_alts.size; i++)
	{
		weapon = offhand_weapons_and_alts[i];
		if(!weapon.isScavengable)
		{
			break;
		}
		switch(weapon.name)
		{
			case "bouncingbetty":
			case "claymore":
			case "frag_grenade":
			case "hatchet":
			case "satchel_charge":
			case "sticky_grenade":
			{
				if(isdefined(player.grenadeTypePrimaryCount) && player.grenadeTypePrimaryCount < 1)
				{
					break;
				}
				if(player GetWeaponAmmoStock(weapon) != loadout_primary_count)
				{
					if(player.scavenger_lethal_proc < scavenger_lethal_proc)
					{
						player.scavenger_lethal_proc++;
						break;
					}
					player.scavenger_lethal_proc = 0;
					player.scavenger_tactical_proc = 0;
				}
			}
			case "concussion_grenade":
			case "emp_grenade":
			case "flash_grenade":
			case "nightingale":
			case "pda_hack":
			case "proximity_grenade":
			case "sensor_grenade":
			case "tabun_gas":
			case "trophy_system":
			case "willy_pete":
			{
				if(isdefined(player.grenadeTypeSecondaryCount) && player.grenadeTypeSecondaryCount < 1)
				{
					break;
				}
				if(weapon == loadout_secondary && player GetWeaponAmmoStock(weapon) != loadout_secondary_count)
				{
					if(player.scavenger_tactical_proc < scavenger_tactical_proc)
					{
						player.scavenger_tactical_proc++;
						break;
					}
					player.scavenger_tactical_proc = 0;
					player.scavenger_lethal_proc = 0;
				}
				maxAmmo = weapon.maxAmmo;
				stock = player GetWeaponAmmoStock(weapon);
				if(isdefined(level.customLoadoutScavenge))
				{
					maxAmmo = self [[level.customLoadoutScavenge]](weapon);
				}
				else if(weapon == loadout_primary)
				{
					maxAmmo = loadout_primary_count;
				}
				else if(weapon == loadout_secondary)
				{
					maxAmmo = loadout_secondary_count;
				}
				if(stock < maxAmmo)
				{
					ammo = stock + 1;
					if(ammo > maxAmmo)
					{
						ammo = maxAmmo;
					}
					player SetWeaponAmmoStock(weapon, ammo);
					player thread challenges::scavengedGrenade();
				}
				break;
			}
			case default:
			{
				if(weapon.isLauncherWeapon)
				{
					stock = player GetWeaponAmmoStock(weapon);
					start = player GetFractionStartAmmo(weapon);
					clip = weapon.clipSize;
					clip = clip * GetDvarFloat("scavenger_clip_multiplier", 2);
					clip = Int(clip);
					maxAmmo = weapon.maxAmmo;
					if(stock < maxAmmo - clip)
					{
						ammo = stock + clip;
						player SetWeaponAmmoStock(weapon, ammo);
					}
					else
					{
						player SetWeaponAmmoStock(weapon, maxAmmo);
					}
				}
				break;
			}
		}
	}
	for(i = 0; i < primary_weapons.size; i++)
	{
		weapon = primary_weapons[i];
		if(!weapon.isScavengable)
		{
			continue;
		}
		stock = player GetWeaponAmmoStock(weapon);
		start = player GetFractionStartAmmo(weapon);
		clip = weapon.clipSize;
		clip = clip * GetDvarFloat("scavenger_clip_multiplier", 2);
		clip = Int(clip);
		maxAmmo = weapon.maxAmmo;
		if(stock < maxAmmo - clip)
		{
			ammo = stock + clip;
			player SetWeaponAmmoStock(weapon, ammo);
			continue;
		}
		player SetWeaponAmmoStock(weapon, maxAmmo);
	}
}

/*
	Name: scavenger_hud_create
	Namespace: weapons
	Checksum: 0xDCE600BA
	Offset: 0x44A0
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function scavenger_hud_create()
{
	if(level.wagerMatch)
	{
		return;
	}
	self.scavenger_icon = newClientHudElem(self);
	self.scavenger_icon.horzAlign = "center";
	self.scavenger_icon.vertAlign = "middle";
	self.scavenger_icon.x = -16;
	self.scavenger_icon.y = 16;
	self.scavenger_icon.alpha = 0;
	width = 32;
	height = 16;
	if(self IsSplitscreen())
	{
		width = Int(width * 0.5);
		height = Int(height * 0.5);
		self.scavenger_icon.x = -8;
	}
	self.scavenger_icon SetShader("hud_scavenger_pickup", width, height);
}

/*
	Name: dropScavengerForDeath
	Namespace: weapons
	Checksum: 0x9D59FCF1
	Offset: 0x4608
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function dropScavengerForDeath(attacker)
{
	if(SessionModeIsZombiesGame())
	{
		return;
	}
	if(level.wagerMatch)
	{
		return;
	}
	if(!isdefined(attacker))
	{
		return;
	}
	if(attacker == self)
	{
		return;
	}
	if(level.gametype == "hack")
	{
		item = self dropScavengerItem(GetWeapon("scavenger_item_hack"));
	}
	else
	{
		item = self dropScavengerItem(GetWeapon("scavenger_item"));
	}
	item thread scavenger_think();
}

/*
	Name: addLimitedWeapon
	Namespace: weapons
	Checksum: 0x81442634
	Offset: 0x46E8
	Size: 0x73
	Parameters: 3
	Flags: None
*/
function addLimitedWeapon(weapon, owner, num_drops)
{
	limited_info = spawnstruct();
	limited_info.weapon = weapon;
	limited_info.drops = num_drops;
	owner.limited_info = limited_info;
}

/*
	Name: shouldDropLimitedWeapon
	Namespace: weapons
	Checksum: 0x4F665679
	Offset: 0x4768
	Size: 0x79
	Parameters: 2
	Flags: None
*/
function shouldDropLimitedWeapon(weapon, owner)
{
	limited_info = owner.limited_info;
	if(!isdefined(limited_info))
	{
		return 1;
	}
	if(limited_info.weapon != weapon)
	{
		return 1;
	}
	if(limited_info.drops <= 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: dropLimitedWeapon
	Namespace: weapons
	Checksum: 0x35C86A04
	Offset: 0x47F0
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function dropLimitedWeapon(weapon, owner, item)
{
	limited_info = owner.limited_info;
	if(!isdefined(limited_info))
	{
		return;
	}
	if(limited_info.weapon != weapon)
	{
		return;
	}
	limited_info.drops = limited_info.drops - 1;
	owner.limited_info = undefined;
	item thread limitedPickup(limited_info);
}

/*
	Name: limitedPickup
	Namespace: weapons
	Checksum: 0xE3AB0BBA
	Offset: 0x48A8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function limitedPickup(limited_info)
{
	self endon("death");
	self waittill("trigger", player, item);
	if(!isdefined(item))
	{
		return;
	}
	player.limited_info = limited_info;
}

