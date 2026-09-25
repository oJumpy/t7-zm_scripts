#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\loadout_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_empgrenade;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\shared\weapons\_tabun;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons_shared;

#namespace weapons;

/*
	Name: init_shared
	Namespace: weapons
	Checksum: 0x67F617A7
	Offset: 0x838
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.weaponNone = GetWeapon("none");
	level.weaponNull = GetWeapon("weapon_null");
	level.weaponBaseMelee = GetWeapon("knife");
	level.weaponBaseMeleeHeld = GetWeapon("knife_held");
	level.weaponBallisticKnife = GetWeapon("knife_ballistic");
	level.weaponRiotshield = GetWeapon("riotshield");
	level.weaponFlashGrenade = GetWeapon("flash_grenade");
	level.weaponSatchelCharge = GetWeapon("satchel_charge");
	if(!isdefined(level.trackWeaponStats))
	{
		level.trackWeaponStats = 1;
	}
	level._effect["flashNineBang"] = "_t6/misc/fx_equip_tac_insert_exp";
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: weapons
	Checksum: 0x1B7AC9B
	Offset: 0x998
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function init()
{
	level.MissileEntities = [];
	level.hackerToolTargets = [];
	level.missileDudDeleteDelay = GetDvarInt("scr_missileDudDeleteDelay", 3);
	if(!isdefined(level.roundStartExplosiveDelay))
	{
		level.roundStartExplosiveDelay = 0;
	}
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_connect
	Namespace: weapons
	Checksum: 0x841AA62A
	Offset: 0xA40
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.usedWeapons = 0;
	self.lastFireTime = 0;
	self.hits = 0;
	self scavenger_hud_create();
}

/*
	Name: on_player_spawned
	Namespace: weapons
	Checksum: 0xA35ECFDC
	Offset: 0xA88
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self.concussionEndTime = 0;
	self.scavenged = 0;
	self.hasDoneCombat = 0;
	self.shieldDamageBlocked = 0;
	self thread watch_usage();
	self thread watch_grenade_usage();
	self thread watch_missile_usage();
	self thread watch_weapon_change();
	if(level.trackWeaponStats)
	{
		self thread track();
	}
	self.droppedDeathWeapon = undefined;
	self.tookWeaponFrom = [];
	self.pickedUpWeaponKills = [];
	self thread update_stowed_weapon();
}

/*
	Name: watch_weapon_change
	Namespace: weapons
	Checksum: 0x29B51C90
	Offset: 0xB80
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function watch_weapon_change()
{
	self endon("death");
	self endon("disconnect");
	self.lastdroppableweapon = self GetCurrentWeapon();
	self.lastWeaponChange = 0;
	while(1)
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill("weapon_change", newWeapon);
		if(may_drop(newWeapon))
		{
			self.lastdroppableweapon = newWeapon;
			self.lastWeaponChange = GetTime();
		}
		if(DoesWeaponReplaceSpawnWeapon(self.spawnWeapon, newWeapon))
		{
			self.spawnWeapon = newWeapon;
			self.pers["spawnWeapon"] = newWeapon;
		}
	}
}

/*
	Name: update_last_held_weapon_timings
	Namespace: weapons
	Checksum: 0xCF883187
	Offset: 0xC80
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function update_last_held_weapon_timings(newTime)
{
	if(isdefined(self.currentWeapon) && isdefined(self.currentWeaponStartTime))
	{
		totalTime = Int(newTime - self.currentWeaponStartTime / 1000);
		if(totalTime > 0)
		{
			weaponPickedUp = 0;
			if(isdefined(self.pickedUpWeapons) && isdefined(self.pickedUpWeapons[self.currentWeapon]))
			{
				weaponPickedUp = 1;
			}
			if(isdefined(self.class_num))
			{
				self addweaponstat(self.currentWeapon, "timeUsed", totalTime, self.class_num, weaponPickedUp);
				self.currentWeaponStartTime = newTime;
			}
		}
	}
}

/*
	Name: update_timings
	Namespace: weapons
	Checksum: 0x43065E59
	Offset: 0xD78
	Size: 0x39D
	Parameters: 1
	Flags: None
*/
function update_timings(newTime)
{
	if(self util::is_bot())
	{
		return;
	}
	update_last_held_weapon_timings(newTime);
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
			self addweaponstat(self.weapon_array_grenade[i], "timeUsed", totalTime, self.class_num);
		}
	}
	else if(isdefined(self.weapon_array_inventory))
	{
		for(i = 0; i < self.weapon_array_inventory.size; i++)
		{
			self addweaponstat(self.weapon_array_inventory[i], "timeUsed", totalTime, self.class_num);
		}
	}
	else if(isdefined(self.killstreak))
	{
		for(i = 0; i < self.killstreak.size; i++)
		{
			killstreakType = level.menuReferenceForKillStreak[self.killstreak[i]];
			if(isdefined(killstreakType))
			{
				killstreakWeapon = killstreaks::get_killstreak_weapon(killstreakType);
				self addweaponstat(killstreakWeapon, "timeUsed", totalTime, self.class_num);
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
	Name: track
	Namespace: weapons
	Checksum: 0x8B04BA21
	Offset: 0x1120
	Size: 0x1B9
	Parameters: 0
	Flags: None
*/
function track()
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
				update_last_held_weapon_timings(newTime);
				self loadout::initWeaponAttachments(newWeapon);
				currentWeapon = newWeapon;
				currentTime = newTime;
			}
		}
		else if(event != "disconnect" && isdefined(self))
		{
			self bb::commit_weapon_data(spawnid, currentWeapon, currentTime);
			update_timings(newTime);
		}
		return;
	}
}

/*
	Name: may_drop
	Namespace: weapons
	Checksum: 0xBD01174B
	Offset: 0x12E8
	Size: 0xA7
	Parameters: 1
	Flags: None
*/
function may_drop(weapon)
{
	if(level.disableWeaponDrop == 1)
	{
		return 0;
	}
	if(weapon == level.weaponNone)
	{
		return 0;
	}
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		return 0;
	}
	if(weapon.isGameplayWeapon)
	{
		return 0;
	}
	if(!weapon.isPrimary)
	{
		return 0;
	}
	if(isdefined(level.mayDropWeapon) && ![[level.mayDropWeapon]](weapon))
	{
		return 0;
	}
	return 1;
}

/*
	Name: drop_for_death
	Namespace: weapons
	Checksum: 0x1BE08F36
	Offset: 0x1398
	Size: 0x4CB
	Parameters: 3
	Flags: None
*/
function drop_for_death(attacker, sWeapon, sMeansOfDeath)
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
	if(!should_drop_limited_weapon(weapon, self))
	{
		return;
	}
	if(weapon.isCarriedKillstreak)
	{
		return;
	}
	clipAmmo = self GetWeaponAmmoClip(weapon);
	stockAmmo = self GetWeaponAmmoStock(weapon);
	clip_and_stock_ammo = clipAmmo + stockAmmo;
	if(!clip_and_stock_ammo && (!isdefined(weapon.unlimitedammo) && weapon.unlimitedammo))
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported");
			}
		#/
		return;
	}
	if(isdefined(weapon.isnotdroppable) && weapon.isnotdroppable)
	{
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
	drop_limited_weapon(weapon, self, item);
	self.droppedDeathWeapon = 1;
	item ItemWeaponSetAmmo(clipAmmo, stockAmmo);
	if(isdefined(level.var_ad0ac054))
	{
		self [[level.var_ad0ac054]](item);
	}
	item.owner = self;
	item.ownersattacker = attacker;
	item.sWeapon = sWeapon;
	item.sMeansOfDeath = sMeansOfDeath;
	item thread watch_pickup();
	item thread delete_pickup_after_aWhile();
}

/*
	Name: delete_pickup_after_aWhile
	Namespace: weapons
	Checksum: 0xCD0354C9
	Offset: 0x1870
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function delete_pickup_after_aWhile()
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
	Name: watch_pickup
	Namespace: weapons
	Checksum: 0x465EE9CC
	Offset: 0x18B0
	Size: 0x3BB
	Parameters: 0
	Flags: None
*/
function watch_pickup()
{
	self endon("death");
	weapon = self.item;
	self waittill("trigger", player, droppedItem, pickedUpOnTouch);
	if(1)
	{
		if(isdefined(player) && isPlayer(player))
		{
			if(isdefined(player.weaponPickupsCount))
			{
				player.weaponPickupsCount++;
			}
			else
			{
				player.weaponPickupsCount = 1;
			}
			player incrementSpecificWeaponPickedUpCount(weapon);
			if(!isdefined(player.pickedUpWeapons))
			{
				player.pickedUpWeapons = [];
			}
			player.pickedUpWeapons[weapon] = 1;
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
			droppedItem[i] thread watch_pickup();
		}
	}
	else if(!isdefined(pickedUpOnTouch) || !pickedUpOnTouch)
	{
		if(isdefined(self.ownersattacker) && self.ownersattacker == player)
		{
			player.tookWeaponFrom[weapon] = spawnstruct();
			player.tookWeaponFrom[weapon].previousOwner = self.owner;
			player.tookWeaponFrom[weapon].sWeapon = self.sWeapon;
			player.tookWeaponFrom[weapon].sMeansOfDeath = self.sMeansOfDeath;
			player.pickedUpWeaponKills[weapon] = 0;
		}
		else
		{
			player.tookWeaponFrom[weapon] = undefined;
			player.pickedUpWeaponKills[weapon] = undefined;
		}
	}
}

/*
	Name: watch_usage
	Namespace: weapons
	Checksum: 0x5B6443B6
	Offset: 0x1C78
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function watch_usage()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("weapon_fired", curWeapon);
		self.lastFireTime = GetTime();
		self.hasDoneCombat = 1;
		switch(curWeapon.weapClass)
		{
			case "mg":
			case "pistol":
			case "pistol spread":
			case "rifle":
			case "smg":
			case "spread":
			{
				self track_fire(curWeapon);
				level.globalShotsFired++;
				break;
			}
			case "grenade":
			case "rocketlauncher":
			{
				self addweaponstat(curWeapon, "shots", 1, self.class_num, 0);
				break;
			}
			case default:
			{
				break;
			}
		}
		if(isdefined(curWeapon.gadget_type) && curWeapon.gadget_type == 14)
		{
			if(isdefined(self.heroweaponShots))
			{
				self.heroweaponShots++;
			}
		}
		if(curWeapon.isCarriedKillstreak)
		{
			if(isdefined(self.pers["held_killstreak_ammo_count"][curWeapon]))
			{
				self.pers["held_killstreak_ammo_count"][curWeapon]--;
			}
		}
	}
}

/*
	Name: track_fire
	Namespace: weapons
	Checksum: 0xB04E0E19
	Offset: 0x1E20
	Size: 0x1F3
	Parameters: 1
	Flags: None
*/
function track_fire(curWeapon)
{
	if(isdefined(level.var_64783fef) && level.var_64783fef)
	{
		return;
	}
	PixBeginEvent("trackWeaponFire");
	weaponPickedUp = 0;
	if(isdefined(self.pickedUpWeapons) && isdefined(self.pickedUpWeapons[curWeapon]))
	{
		weaponPickedUp = 1;
	}
	self TrackWeaponFireNative(curWeapon, 1, self.hits, 1, self.class_num, weaponPickedUp, self.primaryLoadoutGunSmithVariantIndex, self.secondaryLoadoutGunSmithVariantIndex);
	if(isdefined(self.totalMatchShots))
	{
		self.totalMatchShots++;
	}
	self bb::add_to_stat("shots", 1);
	self bb::add_to_stat("hits", self.hits);
	if(level.mpCustomMatch === 1)
	{
		self.pers["shotsfired"]++;
		self.shotsfired = self.pers["shotsfired"];
		self.pers["shotshit"] = self.pers["shotshit"] + self.hits;
		self.shotshit = self.pers["shotshit"];
		self.pers["shotsmissed"] = self.shotsfired - self.shotshit;
		self.shotsmissed = self.pers["shotsmissed"];
	}
	self.hits = 0;
	PixEndEvent();
}

/*
	Name: watch_grenade_usage
	Namespace: weapons
	Checksum: 0xDE5E77F8
	Offset: 0x2020
	Size: 0x157
	Parameters: 0
	Flags: None
*/
function watch_grenade_usage()
{
	self endon("death");
	self endon("disconnect");
	self.throwingGrenade = 0;
	self.gotPullbackNotify = 0;
	self thread begin_other_grenade_tracking();
	self thread watch_for_throwbacks();
	self thread watch_for_grenade_duds();
	self thread watch_for_grenade_launcher_duds();
	for(;;)
	{
		self waittill("grenade_pullback", weapon);
		self addweaponstat(weapon, "shots", 1, self.class_num);
		self.hasDoneCombat = 1;
		self.throwingGrenade = 1;
		self.gotPullbackNotify = 1;
		if(weapon.drawOffhandModelInHand)
		{
			self SetOffhandVisible(1);
			self thread watch_offhand_end();
		}
		self thread begin_grenade_tracking();
	}
}

/*
	Name: watch_missile_usage
	Namespace: weapons
	Checksum: 0x3989661D
	Offset: 0x2180
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function watch_missile_usage()
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
		missile thread watch_missile_death();
	}
}

/*
	Name: watch_missile_death
	Namespace: weapons
	Checksum: 0xAF60BCBB
	Offset: 0x2248
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function watch_missile_death()
{
	self waittill("death");
	ArrayRemoveValue(level.MissileEntities, self);
}

/*
	Name: drop_all_to_ground
	Namespace: weapons
	Checksum: 0xE02B04BA
	Offset: 0x2280
	Size: 0x111
	Parameters: 2
	Flags: None
*/
function drop_all_to_ground(origin, radius)
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
	Name: drop_grenades_to_ground
	Namespace: weapons
	Checksum: 0x2186506A
	Offset: 0x23A0
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function drop_grenades_to_ground(origin, radius)
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
	Name: watch_grenade_cancel
	Namespace: weapons
	Checksum: 0xF7BE0457
	Offset: 0x2478
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function watch_grenade_cancel()
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
	self notify("grenade_throw_cancelled");
}

/*
	Name: watch_offhand_end
	Namespace: weapons
	Checksum: 0x5FDA6EDD
	Offset: 0x2528
	Size: 0xC3
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
	if(isdefined(self))
	{
		self SetOffhandVisible(0);
	}
}

/*
	Name: is_using_offhand_equipment
	Namespace: weapons
	Checksum: 0xFB180180
	Offset: 0x25F8
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
	Name: begin_grenade_tracking
	Namespace: weapons
	Checksum: 0x5E39C0EE
	Offset: 0x2660
	Size: 0x3A3
	Parameters: 0
	Flags: None
*/
function begin_grenade_tracking()
{
	self endon("death");
	self endon("disconnect");
	self endon("grenade_throw_cancelled");
	startTime = GetTime();
	self thread watch_grenade_cancel();
	self waittill("grenade_fire", grenade, weapon, cookTime);
	/#
		/#
			Assert(isdefined(grenade));
		#/
	#/
	level.MissileEntities[level.MissileEntities.size] = grenade;
	grenade.weapon = weapon;
	grenade thread watch_missile_death();
	if(SessionModeIsCampaignZombiesGame() || (isdefined(level.projectiles_should_ignore_world_pause) && level.projectiles_should_ignore_world_pause))
	{
		grenade SetIgnorePauseWorld(1);
	}
	if(grenade util::isHacked())
	{
		return;
	}
	blackBoxEventName = "mpequipmentuses";
	if(SessionModeIsCampaignGame())
	{
		blackBoxEventName = "cpequipmentuses";
	}
	else if(SessionModeIsZombiesGame())
	{
		blackBoxEventName = "zmequipmentuses";
	}
	bbPrint(blackBoxEventName, "gametime %d spawnid %d weaponname %s", GetTime(), getplayerspawnid(self), weapon.name);
	cookedTime = GetTime() - startTime;
	if(cookedTime > 1000)
	{
		grenade.isCooked = 1;
	}
	if(isdefined(self.grenadesUsed))
	{
		self.grenadesUsed++;
	}
	switch(weapon.rootweapon.name)
	{
		case "frag_grenade":
		{
			level.globalFragGrenadesFired++;
		}
		case "sticky_grenade":
		{
			self addweaponstat(weapon, "used", 1);
			grenade SetTeam(self.pers["team"]);
			grenade SetOwner(self);
		}
		case "explosive_bolt":
		{
			grenade.originalowner = self;
			break;
		}
		case "satchel_charge":
		{
			level.globalSatchelChargeFired++;
			break;
		}
		case "concussion_grenade":
		case "flash_grenade":
		{
			self addweaponstat(weapon, "used", 1);
			break;
		}
	}
	self.throwingGrenade = 0;
	if(weapon.cookOffHoldTime > 0)
	{
		grenade thread track_cooked_detonation(self, weapon, cookTime);
	}
	else if(weapon.multiDetonation > 0)
	{
		grenade thread track_multi_detonation(self, weapon, cookTime);
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: weapons
	Checksum: 0x83E9E592
	Offset: 0x2A10
	Size: 0x1C5
	Parameters: 0
	Flags: None
*/
function begin_other_grenade_tracking()
{
	self notify("otherGrenadeTrackingStart");
	self endon("otherGrenadeTrackingStart");
	self endon("disconnect");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(grenade util::isHacked())
		{
			break;
		}
		switch(weapon.rootweapon.name)
		{
			case "tabun_gas":
			{
				grenade thread tabun::watchTabunGrenadeDetonation(self);
				break;
			}
			case "sticky_grenade":
			{
				grenade thread check_stuck_to_player(1, 1, weapon);
				grenade thread riotshield::check_stuck_to_shield();
				break;
			}
			case "c4":
			case "satchel_charge":
			{
				grenade thread check_stuck_to_player(1, 0, weapon);
				break;
			}
			case "hatchet":
			{
				grenade.lastWeaponBeforeToss = self util::getLastWeapon();
				grenade thread check_hatchet_bounce();
				grenade thread check_stuck_to_player(0, 0, weapon);
				self addweaponstat(weapon, "used", 1);
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
	Name: check_stuck_to_player
	Namespace: weapons
	Checksum: 0xC8B7655B
	Offset: 0x2BE0
	Size: 0xCF
	Parameters: 3
	Flags: None
*/
function check_stuck_to_player(deleteOnTeamChange, awardScoreEvent, weapon)
{
	self endon("death");
	self waittill("stuck_to_player", player);
	if(isdefined(player))
	{
		if(deleteOnTeamChange)
		{
			self thread stuck_to_player_team_change(player);
		}
		if(awardScoreEvent && isdefined(self.originalowner))
		{
			if(self.originalowner util::IsEnemyPlayer(player))
			{
				scoreevents::processScoreEvent("stick_explosive_kill", self.originalowner, player, weapon);
			}
		}
		self.stuckToPlayer = player;
	}
}

/*
	Name: check_hatchet_bounce
	Namespace: weapons
	Checksum: 0x1D0FA64C
	Offset: 0x2CB8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function check_hatchet_bounce()
{
	self endon("stuck_to_player");
	self endon("death");
	self waittill("grenade_bounce");
	self.bounced = 1;
}

/*
	Name: stuck_to_player_team_change
	Namespace: weapons
	Checksum: 0x5A84F380
	Offset: 0x2CF8
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function stuck_to_player_team_change(player)
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
	Name: watch_for_throwbacks
	Namespace: weapons
	Checksum: 0xCD8A9FF1
	Offset: 0x2DA0
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function watch_for_throwbacks()
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
	Name: function_d4feb304
	Namespace: weapons
	Checksum: 0xBD6A0922
	Offset: 0x2E50
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_d4feb304(waitTime)
{
	self endon("death");
	wait(waitTime);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: getTimeFromLevelStart
	Namespace: weapons
	Checksum: 0xE56CCB7F
	Offset: 0x2E98
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function getTimeFromLevelStart()
{
	if(!isdefined(level.startTime))
	{
		return 0;
	}
	return GetTime() - level.startTime;
}

/*
	Name: turn_grenade_into_a_dud
	Namespace: weapons
	Checksum: 0xA95F8633
	Offset: 0x2EC0
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function turn_grenade_into_a_dud(weapon, isThrownGrenade, player)
{
	time = getTimeFromLevelStart() / 1000;
	if(level.roundStartExplosiveDelay >= time)
	{
		if(weapon.disallowatmatchstart || WeaponHasAttachment(weapon, "gl"))
		{
			timeLeft = Int(level.roundStartExplosiveDelay - time);
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
	Name: watch_for_grenade_duds
	Namespace: weapons
	Checksum: 0x78A51E6C
	Offset: 0x3020
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function watch_for_grenade_duds()
{
	self endon("spawned_player");
	self endon("disconnect");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		grenade turn_grenade_into_a_dud(weapon, 1, self);
	}
}

/*
	Name: watch_for_grenade_launcher_duds
	Namespace: weapons
	Checksum: 0x5967A361
	Offset: 0x3098
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function watch_for_grenade_launcher_duds()
{
	self endon("spawned_player");
	self endon("disconnect");
	while(1)
	{
		self waittill("grenade_launcher_fire", grenade, weapon);
		grenade turn_grenade_into_a_dud(weapon, 0, self);
		/#
			/#
				Assert(isdefined(grenade));
			#/
		#/
		level.MissileEntities[level.MissileEntities.size] = grenade;
		grenade.weapon = weapon;
		grenade thread watch_missile_death();
	}
}

/*
	Name: get_damageable_ents
	Namespace: weapons
	Checksum: 0x3F7153ED
	Offset: 0x3168
	Size: 0x817
	Parameters: 4
	Flags: None
*/
function get_damageable_ents(pos, radius, doLOS, startRadius)
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
		if(distSq < radius * radius && (!doLOS || damage_trace_passed(pos, playerpos, startRadius, undefined)))
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
		if(distSq < radius * radius && (!doLOS || damage_trace_passed(pos, entPos, startRadius, grenades[i])))
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
		if(distSq < radius * radius && (!doLOS || damage_trace_passed(pos, entPos, startRadius, destructibles[i])))
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
		if(distSq < radius * radius && (!doLOS || damage_trace_passed(pos, entPos, startRadius, destructables[i])))
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
	dogs = [[level.dogManagerOnGetDogs]]();
	if(isdefined(dogs))
	{
		foreach(dog in dogs)
		{
			if(!isalive(dog))
			{
				continue;
			}
			entPos = dog.origin;
			distSq = DistanceSquared(pos, entPos);
			if(distSq < radius * radius && (!doLOS || damage_trace_passed(pos, entPos, startRadius, dog)))
			{
				newent = spawnstruct();
				newent.isPlayer = 0;
				newent.isADestructable = 0;
				newent.isADestructible = 0;
				newent.IsActor = 1;
				newent.entity = dog;
				newent.damageCenter = entPos;
				ents[ents.size] = newent;
			}
		}
	}
	return ents;
}

/*
	Name: damage_trace_passed
	Namespace: weapons
	Checksum: 0x2B576490
	Offset: 0x3988
	Size: 0x61
	Parameters: 4
	Flags: None
*/
function damage_trace_passed(from, to, startRadius, Ignore)
{
	trace = damage_trace(from, to, startRadius, Ignore);
	return trace["fraction"] == 1;
}

/*
	Name: damage_trace
	Namespace: weapons
	Checksum: 0xC65B159B
	Offset: 0x39F8
	Size: 0x1DF
	Parameters: 4
	Flags: None
*/
function damage_trace(from, to, startRadius, Ignore)
{
	midpos = undefined;
	diff = to - from;
	if(LengthSquared(diff) < startRadius * startRadius)
	{
		midpos = to;
	}
	dir = VectorNormalize(diff);
	midpos = from + (dir[0] * startRadius, dir[1] * startRadius, dir[2] * startRadius);
	trace = bullettrace(midpos, to, 0, Ignore);
	if(GetDvarInt("scr_damage_debug") != 0)
	{
		if(trace["fraction"] == 1)
		{
			thread debugLine(midpos, to, (1, 1, 1));
		}
		else
		{
			thread debugLine(midpos, trace["position"], (1, 0.9, 0.8));
			thread debugLine(trace["position"], to, (1, 0.4, 0.3));
		}
	}
	return trace;
}

/*
	Name: damage_ent
	Namespace: weapons
	Checksum: 0x36889EC1
	Offset: 0x3BE0
	Size: 0x19B
	Parameters: 7
	Flags: None
*/
function damage_ent(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, damagepos, damagedir)
{
	if(self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, 0, sMeansOfDeath, weapon, damagepos, damagedir, "none", damagepos, 0, 0, undefined);
	}
	else if(self.IsActor)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackActorDamage]](eInflictor, eAttacker, iDamage, 0, sMeansOfDeath, weapon, damagepos, damagedir, "none", damagepos, 0, 0, 0, 0, (1, 0, 0));
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
	Checksum: 0xF09ABCD7
	Offset: 0x3D88
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
	Name: on_damage
	Namespace: weapons
	Checksum: 0xF272A1A7
	Offset: 0x3E00
	Size: 0x27D
	Parameters: 5
	Flags: None
*/
function on_damage(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	self endon("death");
	self endon("disconnect");
	if(isdefined(level._custom_weapon_damage_func))
	{
		is_weapon_registered = self [[level._custom_weapon_damage_func]](eAttacker, eInflictor, weapon, meansOfDeath, damage);
		if(is_weapon_registered)
		{
			return;
		}
	}
	switch(weapon.rootweapon.name)
	{
		case "concussion_grenade":
		{
			if(isdefined(self.var_68539036) && self.var_68539036)
			{
				return;
			}
			radius = weapon.explosionRadius;
			if(self == eAttacker)
			{
				radius = radius * 0.5;
			}
			scale = 1 - Distance(self.origin, eInflictor.origin) / radius;
			if(scale < 0)
			{
				scale = 0;
			}
			time = 0.25 + 4 * scale;
			wait(0.05);
			if(meansOfDeath != "MOD_IMPACT")
			{
				if(self hasPerk("specialty_stunprotection"))
				{
					time = time * 0.1;
				}
				else if(self util::mayApplyScreenEffect())
				{
					self shellshock("concussion_grenade_mp", time, 0);
				}
				self thread play_concussion_sound(time);
				self.concussionEndTime = GetTime() + time * 1000;
				self.lastConcussedBy = eAttacker;
			}
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
	Name: play_concussion_sound
	Namespace: weapons
	Checksum: 0x1B40F140
	Offset: 0x4088
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function play_concussion_sound(duration)
{
	self endon("death");
	self endon("disconnect");
	concussionSound = spawn("script_origin", (0, 0, 1));
	concussionSound.origin = self.origin;
	concussionSound LinkTo(self);
	concussionSound thread delete_ent_on_owner_death(self);
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
	Name: delete_ent_on_owner_death
	Namespace: weapons
	Checksum: 0x9C673764
	Offset: 0x41E8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function delete_ent_on_owner_death(owner)
{
	self endon("delete");
	owner waittill("death");
	self delete();
}

/*
	Name: update_stowed_weapon
	Namespace: weapons
	Checksum: 0xF2D68EBF
	Offset: 0x4230
	Size: 0x357
	Parameters: 0
	Flags: None
*/
function update_stowed_weapon()
{
	self endon("spawned");
	self endon("killed_player");
	self endon("disconnect");
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	team = self.pers["team"];
	playerclass = self.pers["class"];
	while(1)
	{
		self waittill("weapon_change", newWeapon);
		if(self isMantling())
		{
			continue;
		}
		currentStowed = self GetStowedWeapon();
		hasStowed = 0;
		self.weapon_array_primary = [];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory = [];
		weaponsList = self GetWeaponsList();
		for(idx = 0; idx < weaponsList.size; idx++)
		{
			switch(weaponsList[idx].name)
			{
				case "m32":
				case "minigun":
				{
					continue;
				}
				case default:
				{
					break;
				}
			}
			if(!hasStowed || currentStowed == weaponsList[idx])
			{
				currentStowed = weaponsList[idx];
				hasStowed = 1;
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
		if(newWeapon != level.weaponNone || !hasStowed)
		{
			detach_all_weapons();
			stow_on_back();
			stow_on_hip();
		}
	}
}

/*
	Name: loadout_get_offhand_weapon
	Namespace: weapons
	Checksum: 0xAA51B53
	Offset: 0x4590
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function loadout_get_offhand_weapon(stat)
{
	if(isdefined(level.giveCustomLoadout))
	{
		return level.weaponNone;
	}
	/#
		Assert(isdefined(self.class_num));
	#/
	if(isdefined(self.class_num))
	{
		index = self loadout::getLoadoutItemFromDDLStats(self.class_num, stat);
		if(isdefined(level.tbl_weaponIDs[index]) && isdefined(level.tbl_weaponIDs[index]["reference"]))
		{
			return GetWeapon(level.tbl_weaponIDs[index]["reference"]);
		}
	}
	return level.weaponNone;
}

/*
	Name: loadout_get_offhand_count
	Namespace: weapons
	Checksum: 0xB4F6C83A
	Offset: 0x4680
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function loadout_get_offhand_count(stat)
{
	count = 0;
	if(isdefined(level.giveCustomLoadout))
	{
		return 0;
	}
	/#
		Assert(isdefined(self.class_num));
	#/
	if(isdefined(self.class_num))
	{
		count = self loadout::getLoadoutItemFromDDLStats(self.class_num, stat);
	}
	return count;
}

/*
	Name: flash_scavenger_icon
	Namespace: weapons
	Checksum: 0x5869C852
	Offset: 0x4710
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function flash_scavenger_icon()
{
	self.scavenger_icon.alpha = 1;
	self.scavenger_icon fadeOverTime(1);
	self.scavenger_icon.alpha = 0;
}

/*
	Name: scavenger_think
	Namespace: weapons
	Checksum: 0x95FC46E8
	Offset: 0x4768
	Size: 0x589
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
	offhand_weapons_and_alts = Array::reverse(offhand_weapons_and_alts);
	player playsound("wpn_ammo_pickup");
	player playlocalsound("wpn_ammo_pickup");
	player flash_scavenger_icon();
	for(i = 0; i < offhand_weapons_and_alts.size; i++)
	{
		weapon = offhand_weapons_and_alts[i];
		if(!weapon.isScavengable || killstreaks::is_killstreak_weapon(weapon))
		{
			continue;
		}
		maxAmmo = 0;
		if(weapon == player.grenadeTypePrimary && isdefined(player.grenadeTypePrimaryCount) && player.grenadeTypePrimaryCount > 0)
		{
			maxAmmo = player.grenadeTypePrimaryCount;
		}
		else if(weapon == player.grenadeTypeSecondary && isdefined(player.grenadeTypeSecondaryCount) && player.grenadeTypeSecondaryCount > 0)
		{
			maxAmmo = player.grenadeTypeSecondaryCount;
		}
		if(isdefined(level.var_859df572))
		{
			maxAmmo = player [[level.var_859df572]](weapon, maxAmmo);
		}
		if(maxAmmo == 0)
		{
			continue;
		}
		if(weapon.rootweapon == level.weaponSatchelCharge)
		{
			if(player weaponobjects::anyObjectsInWorld(weapon.rootweapon))
			{
				continue;
			}
		}
		stock = player GetWeaponAmmoStock(weapon);
		if(stock < maxAmmo)
		{
			ammo = stock + 1;
			if(ammo > maxAmmo)
			{
				ammo = maxAmmo;
			}
			player SetWeaponAmmoStock(weapon, ammo);
			player.scavenged = 1;
			player thread challenges::scavengedGrenade();
			continue;
		}
		if(weapon.rootweapon == GetWeapon("trophy_system"))
		{
			player trophy_system::ammo_scavenger(weapon);
		}
	}
	for(i = 0; i < primary_weapons.size; i++)
	{
		weapon = primary_weapons[i];
		if(!weapon.isScavengable || killstreaks::is_killstreak_weapon(weapon))
		{
			continue;
		}
		stock = player GetWeaponAmmoStock(weapon);
		start = player GetFractionStartAmmo(weapon);
		clip = weapon.clipSize;
		clip = clip * GetDvarFloat("scavenger_clip_multiplier", 1);
		clip = Int(clip);
		if(isdefined(level.weaponLauncherEx41) && weapon.statIndex == level.weaponLauncherEx41.statIndex)
		{
			clip = 1;
		}
		maxAmmo = weapon.maxAmmo;
		if(stock < maxAmmo - clip)
		{
			ammo = stock + clip;
			player SetWeaponAmmoStock(weapon, ammo);
			player.scavenged = 1;
			continue;
		}
		player SetWeaponAmmoStock(weapon, maxAmmo);
		player.scavenged = 1;
	}
}

/*
	Name: scavenger_hud_destroyOnDisconnect
	Namespace: weapons
	Checksum: 0x291B7DF8
	Offset: 0x4D00
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function scavenger_hud_destroyOnDisconnect()
{
	self waittill("disconnect");
	if(isdefined(self.scavenger_icon))
	{
		self.scavenger_icon destroy();
	}
}

/*
	Name: scavenger_hud_create
	Namespace: weapons
	Checksum: 0xF56D679B
	Offset: 0x4D40
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function scavenger_hud_create()
{
	if(level.wagerMatch)
	{
		return;
	}
	if(isdefined(level.noScavenger) && level.noScavenger)
	{
		return;
	}
	self.scavenger_icon = newClientHudElem(self);
	if(isdefined(self.scavenger_icon))
	{
		self thread scavenger_hud_destroyOnDisconnect();
		self.scavenger_icon.horzAlign = "center";
		self.scavenger_icon.vertAlign = "middle";
		self.scavenger_icon.alpha = 0;
		width = 64;
		height = 64;
		if(level.Splitscreen)
		{
			width = Int(width * 0.5);
			height = Int(height * 0.5);
		}
		self.scavenger_icon.x = width * -1 / 2;
		self.scavenger_icon.y = 16;
		self.scavenger_icon SetShader("hud_scavenger_pickup", width, height);
	}
}

/*
	Name: drop_scavenger_for_death
	Namespace: weapons
	Checksum: 0xC489457
	Offset: 0x4EC8
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function drop_scavenger_for_death(attacker)
{
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
	else if(isPlayer(attacker))
	{
		item = self dropScavengerItem(GetWeapon("scavenger_item"));
	}
	else
	{
		return;
	}
	item thread scavenger_think();
}

/*
	Name: add_limited_weapon
	Namespace: weapons
	Checksum: 0x6B27D1B4
	Offset: 0x4FC0
	Size: 0x73
	Parameters: 3
	Flags: None
*/
function add_limited_weapon(weapon, owner, num_drops)
{
	limited_info = spawnstruct();
	limited_info.weapon = weapon;
	limited_info.drops = num_drops;
	owner.limited_info = limited_info;
}

/*
	Name: should_drop_limited_weapon
	Namespace: weapons
	Checksum: 0xFF173157
	Offset: 0x5040
	Size: 0x79
	Parameters: 2
	Flags: None
*/
function should_drop_limited_weapon(weapon, owner)
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
	Name: drop_limited_weapon
	Namespace: weapons
	Checksum: 0x6E0524D
	Offset: 0x50C8
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function drop_limited_weapon(weapon, owner, item)
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
	item thread limited_pickup(limited_info);
}

/*
	Name: limited_pickup
	Namespace: weapons
	Checksum: 0x522E4688
	Offset: 0x5180
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function limited_pickup(limited_info)
{
	self endon("death");
	self waittill("trigger", player, item);
	if(!isdefined(item))
	{
		return;
	}
	player.limited_info = limited_info;
}

/*
	Name: track_cooked_detonation
	Namespace: weapons
	Checksum: 0xA05EE6F5
	Offset: 0x51E8
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function track_cooked_detonation(attacker, weapon, cookTime)
{
	self endon("trophy_destroyed");
	self waittill("explode", origin, surface);
	if(weapon.rootweapon == level.weaponFlashGrenade)
	{
		level thread nineBang_doNineBang(attacker, weapon, origin, cookTime);
	}
}

/*
	Name: nineBang_doNineBang
	Namespace: weapons
	Checksum: 0xCD8D71A9
	Offset: 0x5280
	Size: 0x4A5
	Parameters: 4
	Flags: None
*/
function nineBang_doNineBang(attacker, weapon, pos, cookTime)
{
	level endon("game_ended");
	maxStages = 4;
	maxRadius = 20;
	minDelay = 0.15;
	maxdelay = 0.3;
	explosionRadiusSq = weapon.explosionRadius * weapon.explosionRadius;
	explosionRadiusMinSq = weapon.explosionInnerRadius * weapon.explosionInnerRadius;
	cookStages = cookTime / weapon.cookOffHoldTime * maxStages + 1;
	detonations = 0;
	if(cookStages < 2)
	{
		return;
	}
	else if(cookStages < 3)
	{
		detonations = 3;
	}
	else if(cookStages < 4)
	{
		detonations = 6;
	}
	else
	{
		detonations = 9;
	}
	wait(RandomFloatRange(minDelay, maxdelay));
	for(i = 1; i < detonations; i++)
	{
		newpos = level nineBang_getSubExplosionPos(pos, maxRadius);
		playsoundatposition("wpn_flash_grenade_explode", newpos);
		playFX(level._effect["flashNineBang"], newpos);
		closestPlayers = ArraySort(level.players, newpos, 1);
		foreach(player in closestPlayers)
		{
			if(!isdefined(player) || !isalive(player))
			{
				continue;
			}
			if(player.sessionstate != "playing")
			{
				continue;
			}
			viewOrigin = player GetEye();
			dist = DistanceSquared(pos, viewOrigin);
			if(dist > explosionRadiusSq)
			{
				break;
			}
			if(!BulletTracePassed(pos, viewOrigin, 0, player))
			{
				continue;
			}
			if(dist <= explosionRadiusMinSq)
			{
				percent_distance = 1;
			}
			else
			{
				percent_distance = 1 - dist - explosionRadiusMinSq / explosionRadiusSq - explosionRadiusMinSq;
			}
			FORWARD = AnglesToForward(player getPlayerAngles());
			toBlast = pos - viewOrigin;
			toBlast = VectorNormalize(toBlast);
			percent_angle = 0.5 * 1 + VectorDot(FORWARD, toBlast);
			player notify("flashbang", percent_distance, percent_angle, attacker);
		}
		wait(RandomFloatRange(minDelay, maxdelay));
	}
}

/*
	Name: nineBang_getSubExplosionPos
	Namespace: weapons
	Checksum: 0xFFC45F1D
	Offset: 0x5730
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function nineBang_getSubExplosionPos(startPos, range)
{
	offset = (RandomFloatRange(-1 * range, range), RandomFloatRange(-1 * range, range), 0);
	newpos = startPos + offset;
	if(BulletTracePassed(startPos, newpos, 0, undefined))
	{
		return newpos;
	}
	return startPos;
}

/*
	Name: nineBang_DoEmpDamage
	Namespace: weapons
	Checksum: 0x3217CA5F
	Offset: 0x57E8
	Size: 0x135
	Parameters: 3
	Flags: None
*/
function nineBang_DoEmpDamage(player, weapon, position)
{
	kNineBangEmpRadius = 512;
	radiusSq = kNineBangEmpRadius * kNineBangEmpRadius;
	playsoundatposition("wpn_emp_explode", position);
	level empgrenade::empExplosionDamageEnts(player, weapon, position, kNineBangEmpRadius, 0);
	foreach(targetEnt in level.players)
	{
		if(nineBang_empCanDamage(targetEnt, position, radiusSq, 0, 0))
		{
			targetEnt notify("emp_grenaded", player);
		}
	}
}

/*
	Name: nineBang_empCanDamage
	Namespace: weapons
	Checksum: 0xA6E55A88
	Offset: 0x5928
	Size: 0xA9
	Parameters: 5
	Flags: None
*/
function nineBang_empCanDamage(ent, pos, radiusSq, doLOS, startRadius)
{
	entPos = ent.origin;
	distSq = DistanceSquared(pos, entPos);
	return distSq < radiusSq && (!doLOS || weaponDamageTracePassed(pos, entPos, startRadius, ent));
}

/*
	Name: track_multi_detonation
	Namespace: weapons
	Checksum: 0xB7DAF205
	Offset: 0x59E0
	Size: 0x195
	Parameters: 3
	Flags: None
*/
function track_multi_detonation(ownerEnt, weapon, cookTime)
{
	self endon("trophy_destroyed");
	self waittill("explode", origin, surface);
	if(weapon.rootweapon == GetWeapon("frag_grenade_grenade"))
	{
		for(i = 0; i < weapon.multiDetonation; i++)
		{
			if(!isdefined(ownerEnt))
			{
				return;
			}
			multiblastWeapon = GetWeapon("frag_multi_blast");
			dir = level multi_detonation_get_cluster_launch_dir(i, weapon.multiDetonation);
			vel = dir * multiblastWeapon.multiDetonationFragmentSpeed;
			fusetime = multiblastWeapon.fusetime / 1000;
			grenade = ownerEnt MagicGrenadeType(multiblastWeapon, origin, vel, fusetime);
			util::wait_network_frame();
		}
	}
}

/*
	Name: multi_detonation_get_cluster_launch_dir
	Namespace: weapons
	Checksum: 0xB813BC3C
	Offset: 0x5B80
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function multi_detonation_get_cluster_launch_dir(index, multiVal)
{
	pitch = 45;
	yaw = -180 + 360 / multiVal * index;
	angles = (pitch, yaw, 45);
	dir = AnglesToForward(angles);
	return dir;
}

/*
	Name: should_suppress_damage
	Namespace: weapons
	Checksum: 0x73C8F2EE
	Offset: 0x5C18
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function should_suppress_damage(weapon, inflictor)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(!isdefined(self))
	{
		return 0;
	}
	if(isdefined(level.weaponSpecialDiscGun) && weapon.statIndex == level.weaponSpecialDiscGun.statIndex)
	{
		if(isdefined(inflictor))
		{
			if(!isdefined(inflictor.hit_info))
			{
				inflictor.hit_info = [];
			}
			victimEntNum = self GetEntityNumber();
			if(isdefined(inflictor.hit_info[victimEntNum]))
			{
				return 1;
			}
			inflictor.hit_info[victimEntNum] = 1;
		}
	}
	return 0;
}

