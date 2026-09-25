#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_bb;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_ballistic_knife;
#using scripts\zm\gametypes\_weapons;

#namespace zm_weapons;

/*
	Name: init
	Namespace: zm_weapons
	Checksum: 0xD9CB0822
	Offset: 0x8E8
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(level.pack_a_punch_camo_index))
	{
		level.pack_a_punch_camo_index = 42;
	}
	if(!isdefined(level.weapon_cost_client_filled))
	{
		level.weapon_cost_client_filled = 1;
	}
	if(!isdefined(level.obsolete_prompt_format_needed))
	{
		level.obsolete_prompt_format_needed = 0;
	}
	init_weapons();
	init_weapon_upgrade();
	level._weaponobjects_on_player_connect_override = &weaponobjects_on_player_connect_override;
	level._zombiemode_check_firesale_loc_valid_func = &default_check_firesale_loc_valid_func;
	level.MissileEntities = [];
	level thread onPlayerConnect();
}

/*
	Name: onPlayerConnect
	Namespace: zm_weapons
	Checksum: 0x61E8C6A
	Offset: 0x9B0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}

/*
	Name: onPlayerSpawned
	Namespace: zm_weapons
	Checksum: 0x52B9E73A
	Offset: 0x9F0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread watchForGrenadeDuds();
		self thread watchForGrenadeLauncherDuds();
		self.staticWeaponsStartTime = GetTime();
	}
}

/*
	Name: watchForGrenadeDuds
	Namespace: zm_weapons
	Checksum: 0xA914751D
	Offset: 0xA58
	Size: 0xBF
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
		if(!zm_equipment::is_equipment(weapon) && !zm_utility::is_placeable_mine(weapon))
		{
			grenade thread checkGrenadeForDud(weapon, 1, self);
			grenade thread watchForScriptExplosion(weapon, 1, self);
		}
	}
}

/*
	Name: watchForGrenadeLauncherDuds
	Namespace: zm_weapons
	Checksum: 0x5BD0B4CA
	Offset: 0xB20
	Size: 0x87
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
		grenade thread checkGrenadeForDud(weapon, 0, self);
		grenade thread watchForScriptExplosion(weapon, 0, self);
	}
}

/*
	Name: grenade_safe_to_throw
	Namespace: zm_weapons
	Checksum: 0x26B6066D
	Offset: 0xBB0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function grenade_safe_to_throw(player, weapon)
{
	if(isdefined(level.grenade_safe_to_throw))
	{
		return self [[level.grenade_safe_to_throw]](player, weapon);
	}
	return 1;
}

/*
	Name: grenade_safe_to_bounce
	Namespace: zm_weapons
	Checksum: 0xD9BCDEED
	Offset: 0xBF8
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function grenade_safe_to_bounce(player, weapon)
{
	if(isdefined(level.grenade_safe_to_bounce))
	{
		return self [[level.grenade_safe_to_bounce]](player, weapon);
	}
	return 1;
}

/*
	Name: makeGrenadeDudAndDestroy
	Namespace: zm_weapons
	Checksum: 0x10F24109
	Offset: 0xC40
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function makeGrenadeDudAndDestroy()
{
	self endon("death");
	self notify("grenade_dud");
	self makeGrenadeDud();
	wait(3);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: checkGrenadeForDud
	Namespace: zm_weapons
	Checksum: 0x7D49CB78
	Offset: 0xC98
	Size: 0xF1
	Parameters: 3
	Flags: None
*/
function checkGrenadeForDud(weapon, isThrownGrenade, player)
{
	self endon("death");
	player endon("zombify");
	if(!isdefined(self))
	{
		return;
	}
	if(!self grenade_safe_to_throw(player, weapon))
	{
		self thread makeGrenadeDudAndDestroy();
		return;
	}
	for(;;)
	{
		self util::waittill_any_ex(0.25, "grenade_bounce", "stationary", "death", player, "zombify");
		if(!self grenade_safe_to_bounce(player, weapon))
		{
			self thread makeGrenadeDudAndDestroy();
			return;
		}
	}
}

/*
	Name: wait_explode
	Namespace: zm_weapons
	Checksum: 0x6A662672
	Offset: 0xD98
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function wait_explode()
{
	self endon("grenade_dud");
	self endon("done");
	self waittill("explode", position);
	level.explode_position = position;
	level.explode_position_valid = 1;
	self notify("done");
}

/*
	Name: wait_timeout
	Namespace: zm_weapons
	Checksum: 0x37623555
	Offset: 0xE00
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function wait_timeout(time)
{
	self endon("grenade_dud");
	self endon("done");
	self endon("explode");
	wait(time);
	if(isdefined(self))
	{
		self notify("done");
	}
}

/*
	Name: wait_for_explosion
	Namespace: zm_weapons
	Checksum: 0xF5140818
	Offset: 0xE58
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function wait_for_explosion(time)
{
	level.explode_position = (0, 0, 0);
	level.explode_position_valid = 0;
	self thread wait_explode();
	self thread wait_timeout(time);
	self waittill("done");
	self notify("death_or_explode", level.explode_position_valid, level.explode_position);
}

/*
	Name: watchForScriptExplosion
	Namespace: zm_weapons
	Checksum: 0x3FE36E4B
	Offset: 0xEE0
	Size: 0xAD
	Parameters: 3
	Flags: None
*/
function watchForScriptExplosion(weapon, isThrownGrenade, player)
{
	self endon("grenade_dud");
	if(zm_utility::is_lethal_grenade(weapon) || weapon.isLauncher)
	{
		self thread wait_for_explosion(20);
		self waittill("death_or_explode", exploded, position);
		if(exploded)
		{
			level notify("grenade_exploded", position, 256, 300, 75);
		}
	}
}

/*
	Name: get_nonalternate_weapon
	Namespace: zm_weapons
	Checksum: 0xE5A5ABEA
	Offset: 0xF98
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function get_nonalternate_weapon(weapon)
{
	if(weapon.isAltMode)
	{
		return weapon.altweapon;
	}
	return weapon;
}

/*
	Name: switch_from_alt_weapon
	Namespace: zm_weapons
	Checksum: 0x51A046B9
	Offset: 0xFD0
	Size: 0xB5
	Parameters: 1
	Flags: None
*/
function switch_from_alt_weapon(weapon)
{
	if(weapon.ischargeshot)
	{
		return weapon;
	}
	alt = get_nonalternate_weapon(weapon);
	if(alt != weapon)
	{
		if(!WeaponHasAttachment(weapon, "dualoptic"))
		{
			self SwitchToWeaponImmediate(alt);
			self util::waittill_any_timeout(1, "weapon_change_complete");
		}
		return alt;
	}
	return weapon;
}

/*
	Name: give_start_weapons
	Namespace: zm_weapons
	Checksum: 0x7BEEC2E7
	Offset: 0x1090
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function give_start_weapons(TakeAllWeapons, alreadySpawned)
{
	self GiveWeapon(level.weaponBaseMelee);
	self zm_utility::give_start_weapon(1);
}

/*
	Name: give_fallback_weapon
	Namespace: zm_weapons
	Checksum: 0x1FF0A4E6
	Offset: 0x10E8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function give_fallback_weapon(immediate)
{
	if(!isdefined(immediate))
	{
		immediate = 0;
	}
	zm_melee_weapon::give_fallback_weapon(immediate);
}

/*
	Name: take_fallback_weapon
	Namespace: zm_weapons
	Checksum: 0x1405E12E
	Offset: 0x1128
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function take_fallback_weapon()
{
	zm_melee_weapon::take_fallback_weapon();
}

/*
	Name: switch_back_primary_weapon
	Namespace: zm_weapons
	Checksum: 0x67F8E602
	Offset: 0x1148
	Size: 0x223
	Parameters: 2
	Flags: None
*/
function switch_back_primary_weapon(oldprimary, immediate)
{
	if(!isdefined(immediate))
	{
		immediate = 0;
	}
	if(isdefined(self.laststand) && self.laststand)
	{
		return;
	}
	if(!isdefined(oldprimary) || oldprimary == level.weaponNone || oldprimary.isFlourishWeapon || zm_utility::is_melee_weapon(oldprimary) || zm_utility::is_placeable_mine(oldprimary) || zm_utility::is_lethal_grenade(oldprimary) || zm_utility::is_tactical_grenade(oldprimary) || !self HasWeapon(oldprimary))
	{
		oldprimary = undefined;
	}
	else if(oldprimary.isHeroWeapon || oldprimary.isgadget && (!isdefined(self.hero_power) || self.hero_power <= 0))
	{
		oldprimary = undefined;
	}
	primaryWeapons = self GetWeaponsListPrimaries();
	if(isdefined(oldprimary) && IsInArray(primaryWeapons, oldprimary))
	{
		if(immediate)
		{
			self SwitchToWeaponImmediate(oldprimary);
		}
		else
		{
			self SwitchToWeapon(oldprimary);
		}
	}
	else if(primaryWeapons.size > 0)
	{
		if(immediate)
		{
			self SwitchToWeaponImmediate();
		}
		else
		{
			self SwitchToWeapon();
		}
	}
	else
	{
		give_fallback_weapon(immediate);
	}
}

/*
	Name: add_retrievable_knife_init_name
	Namespace: zm_weapons
	Checksum: 0x2C01A14C
	Offset: 0x1378
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function add_retrievable_knife_init_name(name)
{
	if(!isdefined(level.retrievable_knife_init_names))
	{
		level.retrievable_knife_init_names = [];
	}
	level.retrievable_knife_init_names[level.retrievable_knife_init_names.size] = name;
}

/*
	Name: watchWeaponUsageZM
	Namespace: zm_weapons
	Checksum: 0x4B17D5CC
	Offset: 0x13C0
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function watchWeaponUsageZM()
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
			case "pistolspread":
			case "rifle":
			case "smg":
			case "spread":
			{
				self weapons::trackWeaponFire(curWeapon);
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
	Name: trackWeaponZM
	Namespace: zm_weapons
	Checksum: 0x365BFD
	Offset: 0x14E0
	Size: 0x161
	Parameters: 0
	Flags: None
*/
function trackWeaponZM()
{
	self.currentWeapon = self GetCurrentWeapon();
	self.currentTime = GetTime();
	spawnid = getplayerspawnid(self);
	while(1)
	{
		event = self util::waittill_any_return("weapon_change", "death", "disconnect", "bled_out");
		newTime = GetTime();
		if(event == "weapon_change")
		{
			newWeapon = self GetCurrentWeapon();
			if(newWeapon != level.weaponNone && newWeapon != self.currentWeapon)
			{
				updateLastHeldWeaponTimingsZM(newTime);
				self.currentWeapon = newWeapon;
				self.currentTime = newTime;
			}
		}
		else if(event != "death" && event != "disconnect")
		{
			updateWeaponTimingsZM(newTime);
		}
		return;
	}
}

/*
	Name: updateLastHeldWeaponTimingsZM
	Namespace: zm_weapons
	Checksum: 0xD1030997
	Offset: 0x1650
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function updateLastHeldWeaponTimingsZM(newTime)
{
	if(isdefined(self.currentWeapon) && isdefined(self.currentTime))
	{
		curWeapon = self.currentWeapon;
		totalTime = Int(newTime - self.currentTime / 1000);
		if(totalTime > 0)
		{
			self addweaponstat(curWeapon, "timeUsed", totalTime);
		}
	}
}

/*
	Name: updateWeaponTimingsZM
	Namespace: zm_weapons
	Checksum: 0xFE622A7A
	Offset: 0x16F8
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function updateWeaponTimingsZM(newTime)
{
	if(self util::is_bot())
	{
		return;
	}
	updateLastHeldWeaponTimingsZM(newTime);
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
}

/*
	Name: watchWeaponChangeZM
	Namespace: zm_weapons
	Checksum: 0x1A59B42F
	Offset: 0x1798
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function watchWeaponChangeZM()
{
	self endon("death");
	self endon("disconnect");
	self.lastdroppableweapon = self GetCurrentWeapon();
	self.hitsThisMag = [];
	weapon = self GetCurrentWeapon();
	while(1)
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill("weapon_change", newWeapon);
		if(weapons::mayDropWeapon(newWeapon))
		{
			self.lastdroppableweapon = newWeapon;
		}
	}
}

/*
	Name: weaponobjects_on_player_connect_override_internal
	Namespace: zm_weapons
	Checksum: 0x910AC24
	Offset: 0x1868
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function weaponobjects_on_player_connect_override_internal()
{
	self weaponobjects::createBaseWatchers();
	self zm_placeable_mine::setup_watchers();
	for(i = 0; i < level.retrievable_knife_init_names.size; i++)
	{
		self createBallisticKnifeWatcher_zm(level.retrievable_knife_init_names[i]);
	}
	self weaponobjects::setupRetrievableWatcher();
	if(!isdefined(self.weaponObjectWatcherArray))
	{
		self.weaponObjectWatcherArray = [];
	}
	self.concussionEndTime = 0;
	self.hasDoneCombat = 0;
	self.lastFireTime = 0;
	self thread watchWeaponUsageZM();
	self thread weapons::watchGrenadeUsage();
	self thread weapons::watchMissileUsage();
	self thread watchWeaponChangeZM();
	self thread trackWeaponZM();
	self notify("weapon_watchers_created");
}

/*
	Name: weaponobjects_on_player_connect_override
	Namespace: zm_weapons
	Checksum: 0x2669961D
	Offset: 0x19C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function weaponobjects_on_player_connect_override()
{
	add_retrievable_knife_init_name("knife_ballistic");
	add_retrievable_knife_init_name("knife_ballistic_upgraded");
	callback::on_connect(&weaponobjects_on_player_connect_override_internal);
}

/*
	Name: createBallisticKnifeWatcher_zm
	Namespace: zm_weapons
	Checksum: 0x393E9191
	Offset: 0x1A28
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function createBallisticKnifeWatcher_zm(weaponName)
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher(weaponName, self.team);
	watcher.onSpawn = &_zm_weap_ballistic_knife::on_spawn;
	watcher.onSpawnRetrieveTriggers = &_zm_weap_ballistic_knife::on_spawn_retrieve_trigger;
	watcher.storeDifferentObject = 1;
	watcher.headicon = 0;
}

/*
	Name: default_check_firesale_loc_valid_func
	Namespace: zm_weapons
	Checksum: 0xC5A2A25F
	Offset: 0x1AC0
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function default_check_firesale_loc_valid_func()
{
	return 1;
}

/*
	Name: add_zombie_weapon
	Namespace: zm_weapons
	Checksum: 0x9E2FDFB7
	Offset: 0x1AD0
	Size: 0x4C7
	Parameters: 10
	Flags: None
*/
function add_zombie_weapon(weapon_name, upgrade_name, hint, cost, weaponVO, weaponVOresp, ammo_cost, create_vox, is_wonder_weapon, force_attachments)
{
	weapon = GetWeapon(weapon_name);
	upgrade = undefined;
	if(isdefined(upgrade_name))
	{
		upgrade = GetWeapon(upgrade_name);
	}
	if(isdefined(level.zombie_include_weapons) && !isdefined(level.zombie_include_weapons[weapon]))
	{
		return;
	}
	struct = spawnstruct();
	if(!isdefined(level.zombie_weapons))
	{
		level.zombie_weapons = [];
	}
	if(!isdefined(level.zombie_weapons_upgraded))
	{
		level.zombie_weapons_upgraded = [];
	}
	if(isdefined(upgrade_name))
	{
		level.zombie_weapons_upgraded[upgrade] = weapon;
	}
	struct.weapon = weapon;
	struct.upgrade = upgrade;
	struct.weapon_classname = "weapon_" + weapon_name + "_zm";
	if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
	{
		struct.hint = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
	}
	else
	{
		struct.hint = &"ZOMBIE_WEAPONCOSTONLYFILL";
	}
	struct.cost = cost;
	struct.vox = weaponVO;
	struct.vox_response = weaponVOresp;
	struct.is_wonder_weapon = is_wonder_weapon;
	struct.force_attachments = [];
	if("" != force_attachments)
	{
		force_attachments_list = StrTok(force_attachments, " ");
		/#
			Assert(6 >= force_attachments_list.size, weapon_name + "Dev Block strings are not supported");
		#/
		foreach(attachment in force_attachments_list)
		{
			struct.force_attachments[struct.force_attachments.size] = attachment;
		}
	}
	/#
		println("Dev Block strings are not supported" + weapon_name);
	#/
	struct.is_in_box = level.zombie_include_weapons[weapon];
	if(!isdefined(ammo_cost))
	{
		ammo_cost = zm_utility::round_up_to_ten(Int(cost * 0.5));
	}
	struct.ammo_cost = ammo_cost;
	if(weapon.isEmp || (isdefined(upgrade) && upgrade.isEmp))
	{
		level.should_watch_for_emp = 1;
	}
	level.zombie_weapons[weapon] = struct;
	if(zm_pap_util::can_swap_attachments() && isdefined(upgrade_name))
	{
		add_attachments(weapon_name, upgrade_name);
	}
	if(isdefined(create_vox))
	{
		level.vox zm_audio::zmbVoxAdd("player", "weapon_pickup", weapon, weaponVO, undefined);
	}
	/#
		if(isdefined(level.devgui_add_weapon))
		{
			[[level.devgui_add_weapon]](weapon, upgrade, hint, cost, weaponVO, weaponVOresp, ammo_cost);
		}
	#/
}

/*
	Name: add_attachments
	Namespace: zm_weapons
	Checksum: 0x39882FC8
	Offset: 0x1FA0
	Size: 0x1A3
	Parameters: 2
	Flags: None
*/
function add_attachments(weapon, upgrade)
{
	table = "gamedata/weapons/zm/pap_attach.csv";
	if(isdefined(level.weapon_attachment_table))
	{
		table = level.weapon_attachment_table;
	}
	row = TableLookupRowNum(table, 0, upgrade);
	if(row > -1)
	{
		level.zombie_weapons[weapon].default_attachment = tableLookup(table, 0, upgrade.name, 1);
		level.zombie_weapons[weapon].addon_attachments = [];
		index = 2;
		for(next_addon = tableLookup(table, 0, upgrade.name, index); isdefined(next_addon) && next_addon.size > 0;  = tableLookup(table, 0, upgrade.name, index))
		{
			level.zombie_weapons[weapon].addon_attachments[level.zombie_weapons[weapon].addon_attachments.size] = next_addon;
			index++;
		}
	}
}

/*
	Name: is_weapon_included
	Namespace: zm_weapons
	Checksum: 0x833E67C3
	Offset: 0x2150
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function is_weapon_included(weapon)
{
	if(!isdefined(level.zombie_weapons))
	{
		return 0;
	}
	weapon = get_nonalternate_weapon(weapon);
	return isdefined(level.zombie_weapons[weapon.rootweapon]);
}

/*
	Name: is_weapon_or_base_included
	Namespace: zm_weapons
	Checksum: 0x12DCE875
	Offset: 0x21B0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function is_weapon_or_base_included(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	return isdefined(level.zombie_weapons[weapon.rootweapon]) || isdefined(level.zombie_weapons[get_base_weapon(weapon)]);
}

/*
	Name: include_zombie_weapon
	Namespace: zm_weapons
	Checksum: 0xEC4FDE8D
	Offset: 0x2220
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function include_zombie_weapon(weapon_name, in_box)
{
	if(!isdefined(level.zombie_include_weapons))
	{
		level.zombie_include_weapons = [];
	}
	if(!isdefined(in_box))
	{
		in_box = 1;
	}
	/#
		println("Dev Block strings are not supported" + weapon_name);
	#/
	level.zombie_include_weapons[GetWeapon(weapon_name)] = in_box;
}

/*
	Name: init_weapons
	Namespace: zm_weapons
	Checksum: 0x21CE456A
	Offset: 0x22B0
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function init_weapons()
{
	if(isdefined(level._zombie_custom_add_weapons))
	{
		[[level._zombie_custom_add_weapons]]();
	}
}

/*
	Name: add_limited_weapon
	Namespace: zm_weapons
	Checksum: 0x8702E701
	Offset: 0x22D8
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function add_limited_weapon(weapon_name, amount)
{
	if(!isdefined(level.limited_weapons))
	{
		level.limited_weapons = [];
	}
	level.limited_weapons[GetWeapon(weapon_name)] = amount;
}

/*
	Name: limited_weapon_below_quota
	Namespace: zm_weapons
	Checksum: 0x40171222
	Offset: 0x2330
	Size: 0x3F1
	Parameters: 3
	Flags: None
*/
function limited_weapon_below_quota(weapon, ignore_player, pap_triggers)
{
	if(isdefined(level.limited_weapons[weapon]))
	{
		if(!isdefined(pap_triggers))
		{
			pap_triggers = zm_pap_util::get_triggers();
		}
		if(isdefined(level.no_limited_weapons) && level.no_limited_weapons)
		{
			return 0;
		}
		upgradedweapon = weapon;
		if(isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade))
		{
			upgradedweapon = level.zombie_weapons[weapon].upgrade;
		}
		players = GetPlayers();
		count = 0;
		limit = level.limited_weapons[weapon];
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(ignore_player) && ignore_player == players[i])
			{
				continue;
			}
			if(players[i] has_weapon_or_upgrade(weapon))
			{
				count++;
				if(count >= limit)
				{
					return 0;
				}
			}
		}
		for(K = 0; K < pap_triggers.size; K++)
		{
			if(isdefined(pap_triggers[K].current_weapon) && (pap_triggers[K].current_weapon == weapon || pap_triggers[K].current_weapon == upgradedweapon))
			{
				count++;
				if(count >= limit)
				{
					return 0;
				}
			}
		}
		for(chestIndex = 0; chestIndex < level.chests.size; chestIndex++)
		{
			if(isdefined(level.chests[chestIndex].zbarrier.weapon) && level.chests[chestIndex].zbarrier.weapon == weapon)
			{
				count++;
				if(count >= limit)
				{
					return 0;
				}
			}
		}
		if(isdefined(level.custom_limited_weapon_checks))
		{
			foreach(Check in level.custom_limited_weapon_checks)
			{
				count = count + [[Check]](weapon);
			}
			if(count >= limit)
			{
				return 0;
			}
		}
		if(isdefined(level.random_weapon_powerups))
		{
			for(powerupIndex = 0; powerupIndex < level.random_weapon_powerups.size; powerupIndex++)
			{
				if(isdefined(level.random_weapon_powerups[powerupIndex]) && level.random_weapon_powerups[powerupIndex].base_weapon == weapon)
				{
					count++;
					if(count >= limit)
					{
						return 0;
					}
				}
			}
		}
	}
	return 1;
}

/*
	Name: add_custom_limited_weapon_check
	Namespace: zm_weapons
	Checksum: 0x855AE8A0
	Offset: 0x2730
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function add_custom_limited_weapon_check(callback)
{
	if(!isdefined(level.custom_limited_weapon_checks))
	{
		level.custom_limited_weapon_checks = [];
	}
	level.custom_limited_weapon_checks[level.custom_limited_weapon_checks.size] = callback;
}

/*
	Name: add_weapon_to_content
	Namespace: zm_weapons
	Checksum: 0x9C10F4E4
	Offset: 0x2778
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function add_weapon_to_content(weapon_name, package)
{
	if(!isdefined(level.content_weapons))
	{
		level.content_weapons = [];
	}
	level.content_weapons[GetWeapon(weapon_name)] = package;
}

/*
	Name: player_can_use_content
	Namespace: zm_weapons
	Checksum: 0x83859D78
	Offset: 0x27D0
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function player_can_use_content(weapon)
{
	if(isdefined(level.content_weapons))
	{
		if(isdefined(level.content_weapons[weapon]))
		{
			return self HasDLCAvailable(level.content_weapons[weapon]);
		}
	}
	return 1;
}

/*
	Name: init_spawnable_weapon_upgrade
	Namespace: zm_weapons
	Checksum: 0x7CC187AF
	Offset: 0x2828
	Size: 0xC33
	Parameters: 0
	Flags: None
*/
function init_spawnable_weapon_upgrade()
{
	spawn_list = [];
	spawnable_weapon_spawns = struct::get_array("weapon_upgrade", "targetname");
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, struct::get_array("bowie_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, struct::get_array("sickle_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, struct::get_array("tazer_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, struct::get_array("buildable_wallbuy", "targetname"), 1, 0);
	if(isdefined(level.use_autofill_wallbuy) && level.use_autofill_wallbuy)
	{
		spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, level.active_autofill_wallbuys, 1, 0);
	}
	if(!(isdefined(level.headshots_only) && level.headshots_only))
	{
		spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, struct::get_array("claymore_purchase", "targetname"), 1, 0);
	}
	location = level.scr_zm_map_start_location;
	if(location == "default" || location == "" && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}
	match_string = level.scr_zm_ui_gametype;
	if("" != location)
	{
		match_string = match_string + "_" + location;
	}
	match_string_plus_space = " " + match_string;
	for(i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		spawnable_weapon = spawnable_weapon_spawns[i];
		spawnable_weapon.weapon = GetWeapon(spawnable_weapon.zombie_weapon_upgrade);
		if(isdefined(spawnable_weapon.zombie_weapon_upgrade) && spawnable_weapon.weapon.isgrenadeweapon && (isdefined(level.headshots_only) && level.headshots_only))
		{
			break;
		}
		if(!isdefined(spawnable_weapon.script_noteworthy) || spawnable_weapon.script_noteworthy == "")
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
			break;
		}
		matches = StrTok(spawnable_weapon.script_noteworthy, ",");
		for(j = 0; j < matches.size; j++)
		{
			if(matches[j] == match_string || matches[j] == match_string_plus_space)
			{
				spawn_list[spawn_list.size] = spawnable_weapon;
			}
		}
	}
	tempModel = spawn("script_model", (0, 0, 0));
	for(i = 0; i < spawn_list.size; i++)
	{
		clientFieldName = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;
		numBits = 2;
		if(isdefined(level._wallbuy_override_num_bits))
		{
			numBits = level._wallbuy_override_num_bits;
		}
		clientfield::register("world", clientFieldName, 1, numBits, "int");
		target_struct = struct::get(spawn_list[i].target, "targetname");
		if(spawn_list[i].targetname == "buildable_wallbuy")
		{
			bits = 4;
			if(isdefined(level.buildable_wallbuy_weapons))
			{
				bits = GetMinBitCountForNum(level.buildable_wallbuy_weapons.size + 1);
			}
			clientfield::register("world", clientFieldName + "_idx", 1, bits, "int");
			spawn_list[i].clientFieldName = clientFieldName;
			continue;
		}
		unitrigger_stub = spawnstruct();
		unitrigger_stub.origin = spawn_list[i].origin;
		unitrigger_stub.angles = spawn_list[i].angles;
		tempModel.origin = spawn_list[i].origin;
		tempModel.angles = spawn_list[i].angles;
		mins = undefined;
		maxs = undefined;
		absmins = undefined;
		absmaxs = undefined;
		tempModel SetModel(target_struct.model);
		tempModel UseWeaponHideTags(spawn_list[i].weapon);
		mins = tempModel GetMins();
		maxs = tempModel GetMaxs();
		absmins = tempModel GetAbsMins();
		absmaxs = tempModel GetAbsMaxs();
		bounds = absmaxs - absmins;
		unitrigger_stub.script_length = bounds[0] * 0.25;
		unitrigger_stub.script_width = bounds[1];
		unitrigger_stub.script_height = bounds[2];
		unitrigger_stub.origin = unitrigger_stub.origin - AnglesToRight(unitrigger_stub.angles) * unitrigger_stub.script_length * 0.4;
		unitrigger_stub.target = spawn_list[i].target;
		unitrigger_stub.targetname = spawn_list[i].targetname;
		unitrigger_stub.cursor_hint = "HINT_NOICON";
		if(spawn_list[i].targetname == "weapon_upgrade")
		{
			unitrigger_stub.cost = get_weapon_cost(spawn_list[i].weapon);
			unitrigger_stub.hint_string = get_weapon_hint(spawn_list[i].weapon);
			if(!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled))
			{
				unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
			}
			unitrigger_stub.cursor_hint = "HINT_WEAPON";
			unitrigger_stub.cursor_hint_weapon = spawn_list[i].weapon;
		}
		unitrigger_stub.weapon = spawn_list[i].weapon;
		unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		if(isdefined(spawn_list[i].script_string) && (isdefined(Int(spawn_list[i].script_string)) && Int(spawn_list[i].script_string)))
		{
			unitrigger_stub.require_look_toward = 0;
			unitrigger_stub.require_look_at = 0;
			unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
			unitrigger_stub.script_length = bounds[0] * 0.4;
			unitrigger_stub.script_width = bounds[1] * 2;
			unitrigger_stub.script_height = bounds[2];
		}
		else
		{
			unitrigger_stub.require_look_at = 1;
		}
		if(isdefined(spawn_list[i].require_look_from) && spawn_list[i].require_look_from)
		{
			unitrigger_stub.require_look_from = 1;
		}
		unitrigger_stub.clientFieldName = clientFieldName;
		zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
		if(unitrigger_stub.weapon.isMeleeWeapon || unitrigger_stub.weapon.isgrenadeweapon)
		{
			if(unitrigger_stub.weapon.name == "tazer_knuckles" && isdefined(level.taser_trig_adjustment))
			{
				unitrigger_stub.origin = unitrigger_stub.origin + level.taser_trig_adjustment;
			}
			zm_unitrigger::register_static_unitrigger(unitrigger_stub, &weapon_spawn_think);
		}
		else
		{
			unitrigger_stub.prompt_and_visibility_func = &wall_weapon_update_prompt;
			zm_unitrigger::register_static_unitrigger(unitrigger_stub, &weapon_spawn_think);
		}
		spawn_list[i].trigger_stub = unitrigger_stub;
	}
	level._spawned_wallbuys = spawn_list;
	tempModel delete();
}

/*
	Name: add_dynamic_wallbuy
	Namespace: zm_weapons
	Checksum: 0xA392A838
	Offset: 0x3468
	Size: 0x73B
	Parameters: 3
	Flags: None
*/
function add_dynamic_wallbuy(weapon, wallbuy, pristine)
{
	spawned_wallbuy = undefined;
	for(i = 0; i < level._spawned_wallbuys.size; i++)
	{
		if(level._spawned_wallbuys[i].target == wallbuy)
		{
			spawned_wallbuy = level._spawned_wallbuys[i];
			break;
		}
	}
	if(!isdefined(spawned_wallbuy))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	if(isdefined(spawned_wallbuy.trigger_stub))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	target_struct = struct::get(wallbuy, "targetname");
	wallModel = zm_utility::spawn_weapon_model(weapon, undefined, target_struct.origin, target_struct.angles, undefined);
	clientFieldName = spawned_wallbuy.clientFieldName;
	model = weapon.worldmodel;
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = target_struct.origin;
	unitrigger_stub.angles = target_struct.angles;
	wallModel.origin = target_struct.origin;
	wallModel.angles = target_struct.angles;
	mins = undefined;
	maxs = undefined;
	absmins = undefined;
	absmaxs = undefined;
	wallModel SetModel(model);
	wallModel UseWeaponHideTags(weapon);
	mins = wallModel GetMins();
	maxs = wallModel GetMaxs();
	absmins = wallModel GetAbsMins();
	absmaxs = wallModel GetAbsMaxs();
	bounds = absmaxs - absmins;
	unitrigger_stub.script_length = bounds[0] * 0.25;
	unitrigger_stub.script_width = bounds[1];
	unitrigger_stub.script_height = bounds[2];
	unitrigger_stub.origin = unitrigger_stub.origin - AnglesToRight(unitrigger_stub.angles) * unitrigger_stub.script_length * 0.4;
	unitrigger_stub.target = spawned_wallbuy.target;
	unitrigger_stub.targetname = "weapon_upgrade";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.first_time_triggered = !pristine;
	if(!weapon.isMeleeWeapon)
	{
		if(pristine || zm_utility::is_placeable_mine(weapon))
		{
			unitrigger_stub.hint_string = get_weapon_hint(weapon);
		}
		else
		{
			unitrigger_stub.hint_string = get_weapon_hint_ammo();
		}
		unitrigger_stub.cost = get_weapon_cost(weapon);
		if(!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled))
		{
			unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
		}
	}
	unitrigger_stub.weapon = weapon;
	unitrigger_stub.weapon_upgrade = weapon;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = 1;
	unitrigger_stub.clientFieldName = clientFieldName;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	if(weapon.isMeleeWeapon)
	{
		if(weapon == "tazer_knuckles" && isdefined(level.taser_trig_adjustment))
		{
			unitrigger_stub.origin = unitrigger_stub.origin + level.taser_trig_adjustment;
		}
		zm_melee_weapon::add_stub(unitrigger_stub, weapon);
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &zm_melee_weapon::melee_weapon_think);
	}
	else
	{
		unitrigger_stub.prompt_and_visibility_func = &wall_weapon_update_prompt;
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &weapon_spawn_think);
	}
	spawned_wallbuy.trigger_stub = unitrigger_stub;
	weaponIdx = undefined;
	if(isdefined(level.buildable_wallbuy_weapons))
	{
		for(i = 0; i < level.buildable_wallbuy_weapons.size; i++)
		{
			if(weapon == level.buildable_wallbuy_weapons[i])
			{
				weaponIdx = i;
				break;
			}
		}
	}
	else if(isdefined(weaponIdx))
	{
		level clientfield::set(clientFieldName + "_idx", weaponIdx + 1);
		wallModel delete();
		if(!pristine)
		{
			level clientfield::set(clientFieldName, 1);
		}
	}
	else
	{
		level clientfield::set(clientFieldName, 1);
		wallModel show();
	}
}

/*
	Name: wall_weapon_update_prompt
	Namespace: zm_weapons
	Checksum: 0x1E5461AB
	Offset: 0x3BB0
	Size: 0x737
	Parameters: 1
	Flags: None
*/
function wall_weapon_update_prompt(player)
{
	weapon = self.stub.weapon;
	player_has_weapon = player has_weapon_or_upgrade(weapon);
	if(!player_has_weapon && (isdefined(level.weapons_using_ammo_sharing) && level.weapons_using_ammo_sharing))
	{
		shared_ammo_weapon = player get_shared_ammo_weapon(self.zombie_weapon_upgrade);
		if(isdefined(shared_ammo_weapon))
		{
			weapon = shared_ammo_weapon;
			player_has_weapon = 1;
		}
	}
	if(isdefined(level.func_override_wallbuy_prompt))
	{
		if(!self [[level.func_override_wallbuy_prompt]](player))
		{
			return 0;
		}
	}
	if(!player_has_weapon)
	{
		self.stub.cursor_hint = "HINT_WEAPON";
		cost = get_weapon_cost(weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			if(player bgb::is_enabled("zm_bgb_secret_shopper") && !is_wonder_weapon(player.currentWeapon) && player.currentWeapon.type !== "melee")
			{
				self.stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL_BGB_SECRET_SHOPPER";
				self setHintString(self.stub.hint_string);
			}
			else
			{
				self.stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
				self setHintString(self.stub.hint_string);
			}
		}
		else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !is_wonder_weapon(player.currentWeapon) && player.currentWeapon.type !== "melee")
		{
			self.stub.hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL_BGB_SECRET_SHOPPER";
			n_bgb_cost = player get_ammo_cost_for_weapon(player.currentWeapon);
			self setHintString(self.stub.hint_string, cost, n_bgb_cost);
		}
		else
		{
			self.stub.hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL";
			self setHintString(self.stub.hint_string, cost);
		}
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !is_wonder_weapon(player.currentWeapon) && player.currentWeapon.type !== "melee")
	{
		ammo_cost = player get_ammo_cost_for_weapon(weapon);
	}
	else if(player has_upgrade(weapon) && self.stub.hacked !== 1)
	{
		ammo_cost = get_upgraded_ammo_cost(weapon);
	}
	else
	{
		ammo_cost = get_ammo_cost(weapon);
	}
	if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
	{
		if(player bgb::is_enabled("zm_bgb_secret_shopper") && !is_wonder_weapon(player.currentWeapon) && player.currentWeapon.type !== "melee")
		{
			if(isdefined(self.stub.hacked) && self.stub.hacked)
			{
				self.stub.hint_string = &"ZOMBIE_WEAPONAMMOHACKED_CFILL_BGB_SECRET_SHOPPER";
			}
			else
			{
				self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL_BGB_SECRET_SHOPPER";
			}
			self setHintString(self.stub.hint_string);
		}
		else if(isdefined(self.stub.hacked) && self.stub.hacked)
		{
			self.stub.hint_string = &"ZOMBIE_WEAPONAMMOHACKED_CFILL";
		}
		else
		{
			self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL";
		}
		self setHintString(self.stub.hint_string);
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !is_wonder_weapon(player.currentWeapon) && player.currentWeapon.type !== "melee")
	{
		self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY_BGB_SECRET_SHOPPER";
		n_bgb_cost = player get_ammo_cost_for_weapon(player.currentWeapon);
		self setHintString(self.stub.hint_string, ammo_cost, n_bgb_cost);
	}
	else
	{
		self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY";
		self setHintString(self.stub.hint_string, ammo_cost);
	}
	self.stub.cursor_hint = "HINT_WEAPON";
	self.stub.cursor_hint_weapon = weapon;
	self setcursorhint(self.stub.cursor_hint, self.stub.cursor_hint_weapon);
	return 1;
}

/*
	Name: reset_wallbuy_internal
	Namespace: zm_weapons
	Checksum: 0x6CF46906
	Offset: 0x42F0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function reset_wallbuy_internal(set_hint_string)
{
	if(isdefined(self.first_time_triggered) && self.first_time_triggered)
	{
		self.first_time_triggered = 0;
		if(isdefined(self.clientFieldName))
		{
			level clientfield::set(self.clientFieldName, 0);
		}
		if(set_hint_string)
		{
			hint_string = get_weapon_hint(self.weapon);
			cost = get_weapon_cost(self.weapon);
			if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
			{
				self setHintString(hint_string);
			}
			else
			{
				self setHintString(hint_string, cost);
			}
		}
	}
}

/*
	Name: reset_wallbuys
	Namespace: zm_weapons
	Checksum: 0xDD7564C9
	Offset: 0x43F0
	Size: 0x3F1
	Parameters: 0
	Flags: None
*/
function reset_wallbuys()
{
	weapon_spawns = [];
	weapon_spawns = GetEntArray("weapon_upgrade", "targetname");
	melee_and_grenade_spawns = [];
	melee_and_grenade_spawns = GetEntArray("bowie_upgrade", "targetname");
	melee_and_grenade_spawns = ArrayCombine(melee_and_grenade_spawns, GetEntArray("sickle_upgrade", "targetname"), 1, 0);
	melee_and_grenade_spawns = ArrayCombine(melee_and_grenade_spawns, GetEntArray("tazer_upgrade", "targetname"), 1, 0);
	if(!(isdefined(level.headshots_only) && level.headshots_only))
	{
		melee_and_grenade_spawns = ArrayCombine(melee_and_grenade_spawns, GetEntArray("claymore_purchase", "targetname"), 1, 0);
	}
	for(i = 0; i < weapon_spawns.size; i++)
	{
		weapon_spawns[i].weapon = GetWeapon(weapon_spawns[i].zombie_weapon_upgrade);
		weapon_spawns[i] reset_wallbuy_internal(1);
	}
	for(i = 0; i < melee_and_grenade_spawns.size; i++)
	{
		melee_and_grenade_spawns[i].weapon = GetWeapon(melee_and_grenade_spawns[i].zombie_weapon_upgrade);
		melee_and_grenade_spawns[i] reset_wallbuy_internal(0);
	}
	if(isdefined(level._unitriggers))
	{
		candidates = [];
		for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
		{
			stub = level._unitriggers.trigger_stubs[i];
			tn = stub.targetname;
			if(tn == "weapon_upgrade" || tn == "bowie_upgrade" || tn == "sickle_upgrade" || tn == "tazer_upgrade" || tn == "claymore_purchase")
			{
				stub.first_time_triggered = 0;
				if(isdefined(stub.clientFieldName))
				{
					level clientfield::set(stub.clientFieldName, 0);
				}
				if(tn == "weapon_upgrade")
				{
					stub.hint_string = get_weapon_hint(stub.weapon);
					stub.cost = get_weapon_cost(stub.weapon);
					if(!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled))
					{
						stub.hint_parm1 = stub.cost;
					}
				}
			}
		}
	}
}

/*
	Name: init_weapon_upgrade
	Namespace: zm_weapons
	Checksum: 0x91FB393D
	Offset: 0x47F0
	Size: 0x255
	Parameters: 0
	Flags: None
*/
function init_weapon_upgrade()
{
	init_spawnable_weapon_upgrade();
	weapon_spawns = [];
	weapon_spawns = GetEntArray("weapon_upgrade", "targetname");
	for(i = 0; i < weapon_spawns.size; i++)
	{
		weapon_spawns[i].weapon = GetWeapon(weapon_spawns[i].zombie_weapon_upgrade);
		hint_string = get_weapon_hint(weapon_spawns[i].weapon);
		cost = get_weapon_cost(weapon_spawns[i].weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			weapon_spawns[i] setHintString(hint_string);
		}
		else
		{
			weapon_spawns[i] setHintString(hint_string, cost);
		}
		weapon_spawns[i] setcursorhint("HINT_NOICON");
		weapon_spawns[i] UseTriggerRequireLookAt();
		weapon_spawns[i] thread weapon_spawn_think();
		model = GetEnt(weapon_spawns[i].target, "targetname");
		if(isdefined(model))
		{
			model UseWeaponHideTags(weapon_spawns[i].weapon);
			model Hide();
		}
	}
}

/*
	Name: get_weapon_hint
	Namespace: zm_weapons
	Checksum: 0xC5D047A7
	Offset: 0x4A50
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_weapon_hint(weapon)
{
	/#
		Assert(isdefined(level.zombie_weapons[weapon]), weapon.name + "Dev Block strings are not supported");
	#/
	return level.zombie_weapons[weapon].hint;
}

/*
	Name: get_weapon_cost
	Namespace: zm_weapons
	Checksum: 0xDFF295FF
	Offset: 0x4AB8
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_weapon_cost(weapon)
{
	/#
		Assert(isdefined(level.zombie_weapons[weapon]), weapon.name + "Dev Block strings are not supported");
	#/
	return level.zombie_weapons[weapon].cost;
}

/*
	Name: get_ammo_cost
	Namespace: zm_weapons
	Checksum: 0xEBBF3F4F
	Offset: 0x4B20
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_ammo_cost(weapon)
{
	/#
		Assert(isdefined(level.zombie_weapons[weapon]), weapon.name + "Dev Block strings are not supported");
	#/
	return level.zombie_weapons[weapon].ammo_cost;
}

/*
	Name: get_upgraded_ammo_cost
	Namespace: zm_weapons
	Checksum: 0x7049BA4
	Offset: 0x4B88
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function get_upgraded_ammo_cost(weapon)
{
	/#
		Assert(isdefined(level.zombie_weapons[weapon]), weapon.name + "Dev Block strings are not supported");
	#/
	if(isdefined(level.zombie_weapons[weapon].upgraded_ammo_cost))
	{
		return level.zombie_weapons[weapon].upgraded_ammo_cost;
	}
	return 4500;
}

/*
	Name: get_ammo_cost_for_weapon
	Namespace: zm_weapons
	Checksum: 0x120A26BC
	Offset: 0x4C10
	Size: 0x151
	Parameters: 3
	Flags: None
*/
function get_ammo_cost_for_weapon(w_current, n_base_non_wallbuy_cost, n_upgraded_non_wallbuy_cost)
{
	if(!isdefined(n_base_non_wallbuy_cost))
	{
		n_base_non_wallbuy_cost = 750;
	}
	if(!isdefined(n_upgraded_non_wallbuy_cost))
	{
		n_upgraded_non_wallbuy_cost = 5000;
	}
	w_root = w_current.rootweapon;
	if(is_weapon_upgraded(w_root))
	{
		w_root = get_base_weapon(w_root);
	}
	if(self has_upgrade(w_root))
	{
		if(is_wallbuy(w_root))
		{
			n_ammo_cost = 4000;
		}
		else
		{
			n_ammo_cost = n_upgraded_non_wallbuy_cost;
		}
	}
	else if(is_wallbuy(w_root))
	{
		n_ammo_cost = get_ammo_cost(w_root);
		n_ammo_cost = zm_utility::halve_score(n_ammo_cost);
	}
	else
	{
		n_ammo_cost = n_base_non_wallbuy_cost;
	}
	return n_ammo_cost;
}

/*
	Name: get_is_in_box
	Namespace: zm_weapons
	Checksum: 0xB857A559
	Offset: 0x4D70
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_is_in_box(weapon)
{
	/#
		Assert(isdefined(level.zombie_weapons[weapon]), weapon.name + "Dev Block strings are not supported");
	#/
	return level.zombie_weapons[weapon].is_in_box;
}

/*
	Name: get_force_attachments
	Namespace: zm_weapons
	Checksum: 0xE92B5690
	Offset: 0x4DD8
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_force_attachments(weapon)
{
	/#
		Assert(isdefined(level.zombie_weapons[weapon]), weapon.name + "Dev Block strings are not supported");
	#/
	return level.zombie_weapons[weapon].force_attachments;
}

/*
	Name: weapon_supports_default_attachment
	Namespace: zm_weapons
	Checksum: 0xF61A9121
	Offset: 0x4E40
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function weapon_supports_default_attachment(weapon)
{
	weapon = get_base_weapon(weapon);
	attachment = level.zombie_weapons[weapon].default_attachment;
	return isdefined(attachment);
}

/*
	Name: default_attachment
	Namespace: zm_weapons
	Checksum: 0xB9967D75
	Offset: 0x4EA0
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function default_attachment(weapon)
{
	weapon = get_base_weapon(weapon);
	attachment = level.zombie_weapons[weapon].default_attachment;
	if(isdefined(attachment))
	{
		return attachment;
	}
	else
	{
		return "none";
	}
}

/*
	Name: weapon_supports_attachments
	Namespace: zm_weapons
	Checksum: 0x60D456B6
	Offset: 0x4F10
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function weapon_supports_attachments(weapon)
{
	weapon = get_base_weapon(weapon);
	attachments = level.zombie_weapons[weapon].addon_attachments;
	return isdefined(attachments) && attachments.size > 1;
}

/*
	Name: random_attachment
	Namespace: zm_weapons
	Checksum: 0x9C48358D
	Offset: 0x4F80
	Size: 0x165
	Parameters: 2
	Flags: None
*/
function random_attachment(weapon, exclude)
{
	lo = 0;
	if(isdefined(level.zombie_weapons[weapon].addon_attachments) && level.zombie_weapons[weapon].addon_attachments.size > 0)
	{
		attachments = level.zombie_weapons[weapon].addon_attachments;
	}
	else
	{
		attachments = weapon.supportedAttachments;
		lo = 1;
	}
	minatt = lo;
	if(isdefined(exclude) && exclude != "none")
	{
		minatt = lo + 1;
	}
	if(attachments.size > minatt)
	{
		while(1)
		{
			idx = RandomInt(attachments.size - lo) + lo;
			if(!isdefined(exclude) || attachments[idx] != exclude)
			{
				return attachments[idx];
			}
		}
	}
	return "none";
}

/*
	Name: get_attachment_index
	Namespace: zm_weapons
	Checksum: 0xCDC17296
	Offset: 0x50F0
	Size: 0x157
	Parameters: 1
	Flags: None
*/
function get_attachment_index(weapon)
{
	attachments = weapon.attachments;
	if(!attachments.size)
	{
		return -1;
	}
	weapon = get_nonalternate_weapon(weapon);
	base = weapon.rootweapon;
	if(attachments[0] == level.zombie_weapons[base].default_attachment)
	{
		return 0;
	}
	if(isdefined(level.zombie_weapons[base].addon_attachments))
	{
		for(i = 0; i < level.zombie_weapons[base].addon_attachments.size; i++)
		{
			if(level.zombie_weapons[base].addon_attachments[i] == attachments[0])
			{
				return i + 1;
			}
		}
	}
	/#
		println("Dev Block strings are not supported" + weapon.name);
	#/
	return -1;
}

/*
	Name: weapon_supports_this_attachment
	Namespace: zm_weapons
	Checksum: 0xDCB3587E
	Offset: 0x5250
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function weapon_supports_this_attachment(weapon, att)
{
	weapon = get_nonalternate_weapon(weapon);
	base = weapon.rootweapon;
	if(att == level.zombie_weapons[base].default_attachment)
	{
		return 1;
	}
	if(isdefined(level.zombie_weapons[base].addon_attachments))
	{
		for(i = 0; i < level.zombie_weapons[base].addon_attachments.size; i++)
		{
			if(level.zombie_weapons[base].addon_attachments[i] == att)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: get_base_weapon
	Namespace: zm_weapons
	Checksum: 0xB299AED7
	Offset: 0x5358
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function get_base_weapon(upgradedweapon)
{
	upgradedweapon = get_nonalternate_weapon(upgradedweapon);
	upgradedweapon = upgradedweapon.rootweapon;
	if(isdefined(level.zombie_weapons_upgraded[upgradedweapon]))
	{
		return level.zombie_weapons_upgraded[upgradedweapon];
	}
	return upgradedweapon;
}

/*
	Name: get_upgrade_weapon
	Namespace: zm_weapons
	Checksum: 0xD2ADE535
	Offset: 0x53C8
	Size: 0x1EB
	Parameters: 2
	Flags: None
*/
function get_upgrade_weapon(weapon, add_attachment)
{
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	newWeapon = rootweapon;
	baseWeapon = get_base_weapon(weapon);
	if(!is_weapon_upgraded(rootweapon))
	{
		newWeapon = level.zombie_weapons[rootweapon].upgrade;
	}
	if(isdefined(add_attachment) && add_attachment && zm_pap_util::can_swap_attachments())
	{
		oldatt = "none";
		if(weapon.attachments.size)
		{
			oldatt = weapon.attachments[0];
		}
		att = random_attachment(baseWeapon, oldatt);
		newWeapon = GetWeapon(newWeapon.name, att);
	}
	else if(isdefined(level.zombie_weapons[rootweapon]) && isdefined(level.zombie_weapons[rootweapon].default_attachment))
	{
		att = level.zombie_weapons[rootweapon].default_attachment;
		newWeapon = GetWeapon(newWeapon.name, att);
	}
	return newWeapon;
}

/*
	Name: can_upgrade_weapon
	Namespace: zm_weapons
	Checksum: 0x98305B82
	Offset: 0x55C0
	Size: 0xED
	Parameters: 1
	Flags: None
*/
function can_upgrade_weapon(weapon)
{
	if(weapon == level.weaponNone || weapon == level.weaponZMFists || !is_weapon_included(weapon))
	{
		return 0;
	}
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	if(!is_weapon_upgraded(rootweapon))
	{
		return isdefined(level.zombie_weapons[rootweapon].upgrade);
	}
	if(zm_pap_util::can_swap_attachments() && weapon_supports_attachments(rootweapon))
	{
		return 1;
	}
	return 0;
}

/*
	Name: weapon_supports_aat
	Namespace: zm_weapons
	Checksum: 0xC916A679
	Offset: 0x56B8
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function weapon_supports_aat(weapon)
{
	if(weapon == level.weaponNone || weapon == level.weaponZMFists)
	{
		return 0;
	}
	weaponToPack = get_nonalternate_weapon(weapon);
	rootweapon = weaponToPack.rootweapon;
	if(!is_weapon_upgraded(rootweapon))
	{
		return 0;
	}
	if(!AAT::is_exempt_weapon(weaponToPack))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_weapon_upgraded
	Namespace: zm_weapons
	Checksum: 0x242DAD3F
	Offset: 0x5770
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function is_weapon_upgraded(weapon)
{
	if(weapon == level.weaponNone || weapon == level.weaponZMFists)
	{
		return 0;
	}
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	if(isdefined(level.zombie_weapons_upgraded[rootweapon]))
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_weapon_with_attachments
	Namespace: zm_weapons
	Checksum: 0x9DD5B888
	Offset: 0x57F8
	Size: 0x1D5
	Parameters: 1
	Flags: None
*/
function get_weapon_with_attachments(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	if(self HasWeapon(weapon.rootweapon, 1))
	{
		upgraded = is_weapon_upgraded(weapon);
		if(is_weapon_included(weapon) || upgraded)
		{
			if(upgraded)
			{
				base_weapon = get_base_weapon(weapon);
				force_attachments = get_force_attachments(base_weapon.rootweapon);
			}
			else
			{
				force_attachments = get_force_attachments(weapon.rootweapon);
			}
		}
		if(isdefined(force_attachments) && force_attachments.size)
		{
			if(upgraded)
			{
				packed_attachments = [];
				packed_attachments[packed_attachments.size] = "extclip";
				packed_attachments[packed_attachments.size] = "fmj";
				force_attachments = ArrayCombine(force_attachments, packed_attachments, 0, 0);
			}
			return GetWeapon(weapon.rootweapon.name, force_attachments);
		}
		else
		{
			return self GetBuildKitWeapon(weapon.rootweapon, upgraded);
		}
	}
	return undefined;
}

/*
	Name: has_weapon_or_attachments
	Namespace: zm_weapons
	Checksum: 0x39F29A94
	Offset: 0x59D8
	Size: 0x115
	Parameters: 1
	Flags: None
*/
function has_weapon_or_attachments(weapon)
{
	if(self HasWeapon(weapon, 1))
	{
		return 1;
	}
	if(zm_pap_util::can_swap_attachments())
	{
		rootweapon = weapon.rootweapon;
		weapons = self GetWeaponsList(1);
		foreach(w in weapons)
		{
			if(rootweapon == w.rootweapon)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: has_upgrade
	Namespace: zm_weapons
	Checksum: 0xE88737DD
	Offset: 0x5AF8
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function has_upgrade(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	has_upgrade = 0;
	if(isdefined(level.zombie_weapons[rootweapon]) && isdefined(level.zombie_weapons[rootweapon].upgrade))
	{
		has_upgrade = self has_weapon_or_attachments(level.zombie_weapons[rootweapon].upgrade);
	}
	if(!has_upgrade && rootweapon.isBallisticKnife)
	{
		has_weapon = self zm_melee_weapon::has_upgraded_ballistic_knife();
	}
	return has_upgrade;
}

/*
	Name: has_weapon_or_upgrade
	Namespace: zm_weapons
	Checksum: 0x9C58DBF8
	Offset: 0x5BF8
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function has_weapon_or_upgrade(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	upgradedweaponname = rootweapon;
	if(isdefined(level.zombie_weapons[rootweapon]) && isdefined(level.zombie_weapons[rootweapon].upgrade))
	{
		upgradedweaponname = level.zombie_weapons[rootweapon].upgrade;
	}
	has_weapon = 0;
	if(isdefined(level.zombie_weapons[rootweapon]))
	{
		has_weapon = self has_weapon_or_attachments(rootweapon) || self has_upgrade(rootweapon);
	}
	if(!has_weapon && level.weaponBallisticKnife == rootweapon)
	{
		has_weapon = self zm_melee_weapon::has_any_ballistic_knife();
	}
	if(!has_weapon && zm_equipment::is_equipment(rootweapon))
	{
		has_weapon = self zm_equipment::is_active(rootweapon);
	}
	return has_weapon;
}

/*
	Name: add_shared_ammo_weapon
	Namespace: zm_weapons
	Checksum: 0x740C9D6B
	Offset: 0x5D78
	Size: 0x2F
	Parameters: 2
	Flags: None
*/
function add_shared_ammo_weapon(weapon, base_weapon)
{
	level.zombie_weapons[weapon].shared_ammo_weapon = base_weapon;
}

/*
	Name: get_shared_ammo_weapon
	Namespace: zm_weapons
	Checksum: 0xBB7D5
	Offset: 0x5DB0
	Size: 0x17D
	Parameters: 1
	Flags: None
*/
function get_shared_ammo_weapon(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	weapons = self GetWeaponsList(1);
	foreach(w in weapons)
	{
		w = w.rootweapon;
		if(!isdefined(level.zombie_weapons[w]) && isdefined(level.zombie_weapons_upgraded[w]))
		{
			w = level.zombie_weapons_upgraded[w];
		}
		if(isdefined(level.zombie_weapons[w]) && isdefined(level.zombie_weapons[w].shared_ammo_weapon) && level.zombie_weapons[w].shared_ammo_weapon == rootweapon)
		{
			return w;
		}
	}
	return undefined;
}

/*
	Name: get_player_weapon_with_same_base
	Namespace: zm_weapons
	Checksum: 0xAF4640D2
	Offset: 0x5F38
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function get_player_weapon_with_same_base(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	rootweapon = weapon.rootweapon;
	retweapon = self get_weapon_with_attachments(rootweapon);
	if(!isdefined(retweapon))
	{
		if(isdefined(level.zombie_weapons[rootweapon]))
		{
			if(isdefined(level.zombie_weapons[rootweapon].upgrade))
			{
				retweapon = self get_weapon_with_attachments(level.zombie_weapons[rootweapon].upgrade);
			}
		}
		else if(isdefined(level.zombie_weapons_upgraded[rootweapon]))
		{
			retweapon = self get_weapon_with_attachments(level.zombie_weapons_upgraded[rootweapon]);
		}
	}
	return retweapon;
}

/*
	Name: get_weapon_hint_ammo
	Namespace: zm_weapons
	Checksum: 0x2FA0EEF7
	Offset: 0x6058
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function get_weapon_hint_ammo()
{
	if(!(isdefined(level.obsolete_prompt_format_needed) && level.obsolete_prompt_format_needed))
	{
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			return &"ZOMBIE_WEAPONCOSTONLY_CFILL";
		}
		else
		{
			return &"ZOMBIE_WEAPONCOSTONLYFILL";
		}
	}
	else if(isdefined(level.has_pack_a_punch) && !level.has_pack_a_punch)
	{
		return &"ZOMBIE_WEAPONCOSTAMMO";
	}
	else
	{
		return &"ZOMBIE_WEAPONCOSTAMMO_UPGRADE";
	}
}

/*
	Name: weapon_set_first_time_hint
	Namespace: zm_weapons
	Checksum: 0x70E6F096
	Offset: 0x60D8
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function weapon_set_first_time_hint(cost, ammo_cost)
{
	if(!(isdefined(level.obsolete_prompt_format_needed) && level.obsolete_prompt_format_needed))
	{
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			self setHintString(get_weapon_hint_ammo());
		}
		else
		{
			self setHintString(get_weapon_hint_ammo(), cost, ammo_cost);
		}
	}
	else
	{
		self setHintString(get_weapon_hint_ammo(), cost, ammo_cost);
	}
}

/*
	Name: placeable_mine_can_buy_weapon_extra_check_func
	Namespace: zm_weapons
	Checksum: 0x64212DDA
	Offset: 0x61A8
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function placeable_mine_can_buy_weapon_extra_check_func(w_weapon)
{
	if(isdefined(w_weapon) && w_weapon == self zm_utility::get_player_placeable_mine())
	{
		return 0;
	}
	return 1;
}

/*
	Name: weapon_spawn_think
	Namespace: zm_weapons
	Checksum: 0xF9E81E95
	Offset: 0x61E8
	Size: 0xE43
	Parameters: 0
	Flags: None
*/
function weapon_spawn_think()
{
	cost = get_weapon_cost(self.weapon);
	ammo_cost = get_ammo_cost(self.weapon);
	is_grenade = self.weapon.isgrenadeweapon;
	shared_ammo_weapon = undefined;
	if(isdefined(self.parent_player) && !is_grenade)
	{
		self.parent_player notify("zm_bgb_secret_shopper", self);
	}
	second_endon = undefined;
	if(isdefined(self.stub))
	{
		second_endon = "kill_trigger";
		self.first_time_triggered = self.stub.first_time_triggered;
	}
	onlyplayer = undefined;
	can_buy_weapon_extra_check_func = undefined;
	if(isdefined(self.stub) && (isdefined(self.stub.trigger_per_player) && self.stub.trigger_per_player))
	{
		onlyplayer = self.parent_player;
		if(zm_utility::is_placeable_mine(self.weapon))
		{
			can_buy_weapon_extra_check_func = &placeable_mine_can_buy_weapon_extra_check_func;
		}
	}
	self thread zm_magicbox::decide_hide_show_hint("stop_hint_logic", second_endon, onlyplayer, can_buy_weapon_extra_check_func);
	if(is_grenade || zm_utility::is_melee_weapon(self.weapon))
	{
		self.first_time_triggered = 0;
		hint = get_weapon_hint(self.weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			self setHintString(hint);
		}
		else
		{
			self setHintString(hint, cost);
		}
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = self.weapon;
		self setcursorhint(cursor_hint, cursor_hint_weapon);
	}
	else if(!isdefined(self.first_time_triggered))
	{
		self.first_time_triggered = 0;
		if(isdefined(self.stub))
		{
			self.stub.first_time_triggered = 0;
		}
	}
	for(;;)
	{
		self waittill("trigger", player);
		if(!zm_utility::is_player_valid(player))
		{
			player thread zm_utility::ignore_triggers(0.5);
			continue;
		}
		if(!player zm_magicbox::can_buy_weapon())
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.stub) && (isdefined(self.stub.require_look_from) && self.stub.require_look_from))
		{
			toplayer = player util::get_eye() - self.origin;
			FORWARD = -1 * AnglesToRight(self.angles);
			dot = VectorDot(toplayer, FORWARD);
			if(dot < 0)
			{
				continue;
			}
		}
		if(player zm_utility::has_powerup_weapon())
		{
			wait(0.1);
			continue;
		}
		player_has_weapon = player has_weapon_or_upgrade(self.weapon);
		if(!player_has_weapon && (isdefined(level.weapons_using_ammo_sharing) && level.weapons_using_ammo_sharing))
		{
			shared_ammo_weapon = player get_shared_ammo_weapon(self.weapon);
			if(isdefined(shared_ammo_weapon))
			{
				player_has_weapon = 1;
			}
		}
		if(isdefined(level.pers_upgrade_nube) && level.pers_upgrade_nube)
		{
			player_has_weapon = zm_pers_upgrades_functions::pers_nube_should_we_give_raygun(player_has_weapon, player, self.weapon);
		}
		cost = get_weapon_cost(self.weapon);
		if(player zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			cost = Int(cost / 2);
		}
		if(isdefined(player.check_override_wallbuy_purchase))
		{
			if(player [[player.check_override_wallbuy_purchase]](self.weapon, self))
			{
				continue;
			}
		}
		if(!player_has_weapon)
		{
			if(player zm_score::can_player_purchase(cost))
			{
				if(self.first_time_triggered == 0)
				{
					self show_all_weapon_buys(player, cost, ammo_cost, is_grenade);
				}
				player zm_score::minus_to_player_score(cost);
				level notify("weapon_bought", player, self.weapon);
				player zm_stats::increment_challenge_stat("SURVIVALIST_BUY_WALLBUY");
				if(self.weapon.isRiotShield)
				{
					player zm_equipment::give(self.weapon);
					if(isdefined(player.player_shield_reset_health))
					{
						player [[player.player_shield_reset_health]]();
					}
				}
				else if(zm_utility::is_lethal_grenade(self.weapon))
				{
					player weapon_take(player zm_utility::get_player_lethal_grenade());
					player zm_utility::set_player_lethal_grenade(self.weapon);
				}
				weapon = self.weapon;
				if(isdefined(level.pers_upgrade_nube) && level.pers_upgrade_nube)
				{
					weapon = zm_pers_upgrades_functions::pers_nube_weapon_upgrade_check(player, weapon);
				}
				if(should_upgrade_weapon(player))
				{
					if(player can_upgrade_weapon(weapon))
					{
						weapon = get_upgrade_weapon(weapon);
						player notify("zm_bgb_wall_power_used");
					}
				}
				weapon = player weapon_give(weapon);
				if(isdefined(weapon))
				{
					player thread AAT::remove(weapon);
				}
				if(isdefined(weapon))
				{
					player zm_stats::increment_client_stat("wallbuy_weapons_purchased");
					player zm_stats::increment_player_stat("wallbuy_weapons_purchased");
					bb::function_91f32a58(player, self, cost, weapon.name, player has_upgrade(weapon), "_weapon", "_purchase");
					weaponIndex = undefined;
					if(isdefined(weaponIndex))
					{
						weaponIndex = MatchRecordGetWeaponIndex(weapon);
					}
					if(isdefined(weaponIndex))
					{
						player RecordMapEvent(6, GetTime(), player.origin, level.round_number, weaponIndex, cost);
					}
				}
			}
			else
			{
				zm_utility::play_sound_on_ent("no_purchase");
				player zm_audio::create_and_play_dialog("general", "outofmoney");
			}
		}
		else
		{
			weapon = self.weapon;
			if(isdefined(shared_ammo_weapon))
			{
				weapon = shared_ammo_weapon;
			}
			if(isdefined(level.pers_upgrade_nube) && level.pers_upgrade_nube)
			{
				weapon = zm_pers_upgrades_functions::pers_nube_weapon_ammo_check(player, weapon);
			}
			if(isdefined(self.stub.hacked) && self.stub.hacked)
			{
				if(!player has_upgrade(weapon))
				{
					ammo_cost = 4500;
				}
				else
				{
					ammo_cost = get_ammo_cost(weapon);
				}
			}
			else if(player has_upgrade(weapon))
			{
				ammo_cost = 4500;
			}
			else
			{
				ammo_cost = get_ammo_cost(weapon);
			}
			if(isdefined(player.pers_upgrades_awarded["nube"]) && player.pers_upgrades_awarded["nube"])
			{
				ammo_cost = zm_pers_upgrades_functions::pers_nube_override_ammo_cost(player, self.weapon, ammo_cost);
			}
			if(player zm_pers_upgrades_functions::is_pers_double_points_active())
			{
				ammo_cost = Int(ammo_cost / 2);
			}
			if(player bgb::is_enabled("zm_bgb_secret_shopper") && !is_wonder_weapon(weapon))
			{
				ammo_cost = player get_ammo_cost_for_weapon(weapon);
			}
			if(weapon.isRiotShield)
			{
				zm_utility::play_sound_on_ent("no_purchase");
			}
			else if(player zm_score::can_player_purchase(ammo_cost))
			{
				if(self.first_time_triggered == 0)
				{
					self show_all_weapon_buys(player, cost, ammo_cost, is_grenade);
				}
				if(player has_upgrade(weapon))
				{
					player zm_stats::increment_client_stat("upgraded_ammo_purchased");
					player zm_stats::increment_player_stat("upgraded_ammo_purchased");
				}
				else
				{
					player zm_stats::increment_client_stat("ammo_purchased");
					player zm_stats::increment_player_stat("ammo_purchased");
				}
				if(player has_upgrade(weapon))
				{
					ammo_given = player ammo_give(level.zombie_weapons[weapon].upgrade);
				}
				else
				{
					ammo_given = player ammo_give(weapon);
				}
				if(ammo_given)
				{
					player zm_score::minus_to_player_score(ammo_cost);
				}
				bb::function_91f32a58(player, self, ammo_cost, weapon.name, player has_upgrade(weapon), "_ammo", "_purchase");
				weaponIndex = undefined;
				if(isdefined(weapon))
				{
					weaponIndex = MatchRecordGetWeaponIndex(weapon);
				}
				if(isdefined(weaponIndex))
				{
					player RecordMapEvent(7, GetTime(), player.origin, level.round_number, weaponIndex, cost);
				}
			}
			else
			{
				zm_utility::play_sound_on_ent("no_purchase");
				if(isdefined(level.custom_generic_deny_vo_func))
				{
					player [[level.custom_generic_deny_vo_func]]();
				}
				else
				{
					player zm_audio::create_and_play_dialog("general", "outofmoney");
				}
			}
		}
		if(isdefined(self.stub) && isdefined(self.stub.prompt_and_visibility_func))
		{
			self [[self.stub.prompt_and_visibility_func]](player);
		}
	}
}

/*
	Name: should_upgrade_weapon
	Namespace: zm_weapons
	Checksum: 0x24CA17D4
	Offset: 0x7038
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function should_upgrade_weapon(player)
{
	if(isdefined(level.wallbuy_should_upgrade_weapon_override))
	{
		return [[level.wallbuy_should_upgrade_weapon_override]]();
	}
	if(player bgb::is_enabled("zm_bgb_wall_power"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: show_all_weapon_buys
	Namespace: zm_weapons
	Checksum: 0xF00FE3C4
	Offset: 0x7090
	Size: 0x3AD
	Parameters: 4
	Flags: None
*/
function show_all_weapon_buys(player, cost, ammo_cost, is_grenade)
{
	model = GetEnt(self.target, "targetname");
	is_melee = zm_utility::is_melee_weapon(self.weapon);
	if(isdefined(model))
	{
		model thread weapon_show(player);
	}
	else if(isdefined(self.clientFieldName))
	{
		level clientfield::set(self.clientFieldName, 1);
	}
	self.first_time_triggered = 1;
	if(isdefined(self.stub))
	{
		self.stub.first_time_triggered = 1;
	}
	if(!is_grenade && !is_melee)
	{
		self weapon_set_first_time_hint(cost, ammo_cost);
	}
	if(!isdefined(level.dont_link_common_wallbuys) && level.dont_link_common_wallbuys && isdefined(level._spawned_wallbuys))
	{
		for(i = 0; i < level._spawned_wallbuys.size; i++)
		{
			wallbuy = level._spawned_wallbuys[i];
			if(isdefined(self.stub) && isdefined(wallbuy.trigger_stub) && self.stub.clientFieldName == wallbuy.trigger_stub.clientFieldName)
			{
				continue;
			}
			if(self.weapon == wallbuy.weapon)
			{
				if(isdefined(wallbuy.trigger_stub) && isdefined(wallbuy.trigger_stub.clientFieldName))
				{
					level clientfield::set(wallbuy.trigger_stub.clientFieldName, 1);
				}
				else if(isdefined(wallbuy.target))
				{
					model = GetEnt(wallbuy.target, "targetname");
					if(isdefined(model))
					{
						model thread weapon_show(player);
					}
				}
				if(isdefined(wallbuy.trigger_stub))
				{
					wallbuy.trigger_stub.first_time_triggered = 1;
					if(isdefined(wallbuy.trigger_stub.trigger))
					{
						wallbuy.trigger_stub.trigger.first_time_triggered = 1;
						if(!is_grenade && !is_melee)
						{
							wallbuy.trigger_stub.trigger weapon_set_first_time_hint(cost, ammo_cost);
						}
					}
					continue;
				}
				if(!is_grenade && !is_melee)
				{
					wallbuy weapon_set_first_time_hint(cost, ammo_cost);
				}
			}
		}
	}
}

/*
	Name: weapon_show
	Namespace: zm_weapons
	Checksum: 0xAAEB59D1
	Offset: 0x7448
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function weapon_show(player)
{
	player_angles = VectorToAngles(player.origin - self.origin);
	player_yaw = player_angles[1];
	weapon_yaw = self.angles[1];
	if(isdefined(self.script_int))
	{
		weapon_yaw = weapon_yaw - self.script_int;
	}
	yaw_diff = AngleClamp180(player_yaw - weapon_yaw);
	if(yaw_diff > 0)
	{
		yaw = weapon_yaw - 90;
	}
	else
	{
		yaw = weapon_yaw + 90;
	}
	self.og_origin = self.origin;
	self.origin = self.origin + AnglesToForward((0, yaw, 0)) * 8;
	wait(0.05);
	self show();
	zm_utility::play_sound_at_pos("weapon_show", self.origin, self);
	time = 1;
	if(!isdefined(self._linked_ent))
	{
		self moveto(self.og_origin, time);
	}
}

/*
	Name: get_pack_a_punch_camo_index
	Namespace: zm_weapons
	Checksum: 0xFBD26071
	Offset: 0x7608
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function get_pack_a_punch_camo_index(prev_pap_index)
{
	if(isdefined(level.pack_a_punch_camo_index_number_variants))
	{
		if(isdefined(prev_pap_index))
		{
			camo_variant = prev_pap_index + 1;
			if(camo_variant >= level.pack_a_punch_camo_index + level.pack_a_punch_camo_index_number_variants)
			{
				camo_variant = level.pack_a_punch_camo_index;
			}
			return camo_variant;
		}
		else
		{
			camo_variant = randomIntRange(0, level.pack_a_punch_camo_index_number_variants);
			return level.pack_a_punch_camo_index + camo_variant;
		}
	}
	else
	{
		return level.pack_a_punch_camo_index;
	}
}

/*
	Name: get_pack_a_punch_weapon_options
	Namespace: zm_weapons
	Checksum: 0xC1DC143D
	Offset: 0x76C0
	Size: 0x2DF
	Parameters: 1
	Flags: None
*/
function get_pack_a_punch_weapon_options(weapon)
{
	if(!isdefined(self.pack_a_punch_weapon_options))
	{
		self.pack_a_punch_weapon_options = [];
	}
	if(!is_weapon_upgraded(weapon))
	{
		return self CalcWeaponOptions(0, 0, 0, 0, 0);
	}
	if(isdefined(self.pack_a_punch_weapon_options[weapon]))
	{
		return self.pack_a_punch_weapon_options[weapon];
	}
	smiley_face_reticle_index = 1;
	camo_index = get_pack_a_punch_camo_index(undefined);
	lens_index = randomIntRange(0, 6);
	reticle_index = randomIntRange(0, 16);
	reticle_color_index = randomIntRange(0, 6);
	plain_reticle_index = 16;
	use_plain = RandomInt(10) < 1;
	if("saritch_upgraded" == weapon.rootweapon.name)
	{
		reticle_index = smiley_face_reticle_index;
	}
	else if(use_plain)
	{
		reticle_index = plain_reticle_index;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") >= 0)
		{
			reticle_index = GetDvarInt("Dev Block strings are not supported");
		}
	#/
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if(reticle_index == scary_eyes_reticle_index)
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if(reticle_index == letter_a_reticle_index)
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if(reticle_index == letter_e_reticle_index)
	{
		reticle_color_index = green_reticle_color_index;
	}
	self.pack_a_punch_weapon_options[weapon] = self CalcWeaponOptions(camo_index, lens_index, reticle_index, reticle_color_index);
	return self.pack_a_punch_weapon_options[weapon];
}

/*
	Name: give_build_kit_weapon
	Namespace: zm_weapons
	Checksum: 0x72B78483
	Offset: 0x79A8
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function give_build_kit_weapon(weapon)
{
	upgraded = 0;
	camo = undefined;
	base_weapon = weapon;
	if(is_weapon_upgraded(weapon))
	{
		if(isdefined(weapon.pap_camo_to_use))
		{
			camo = weapon.pap_camo_to_use;
		}
		else
		{
			camo = get_pack_a_punch_camo_index(undefined);
		}
		upgraded = 1;
		base_weapon = get_base_weapon(weapon);
	}
	if(is_weapon_included(base_weapon))
	{
		force_attachments = get_force_attachments(base_weapon.rootweapon);
	}
	if(isdefined(force_attachments) && force_attachments.size)
	{
		if(upgraded)
		{
			packed_attachments = [];
			packed_attachments[packed_attachments.size] = "extclip";
			packed_attachments[packed_attachments.size] = "fmj";
			force_attachments = ArrayCombine(force_attachments, packed_attachments, 0, 0);
		}
		weapon = GetWeapon(weapon.rootweapon.name, force_attachments);
		if(!isdefined(camo))
		{
			camo = 0;
		}
		weapon_options = self CalcWeaponOptions(camo, 0, 0);
		acvi = 0;
	}
	else
	{
		weapon = self GetBuildKitWeapon(weapon, upgraded);
		weapon_options = self GetBuildKitWeaponOptions(weapon, camo);
		acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, upgraded);
	}
	self GiveWeapon(weapon, weapon_options, acvi);
	return weapon;
}

/*
	Name: weapon_give
	Namespace: zm_weapons
	Checksum: 0xEF0866D1
	Offset: 0x7C30
	Size: 0xA47
	Parameters: 5
	Flags: None
*/
function weapon_give(weapon, is_upgrade, magic_box, nosound, b_switch_weapon)
{
	if(!isdefined(is_upgrade))
	{
		is_upgrade = 0;
	}
	if(!isdefined(magic_box))
	{
		magic_box = 0;
	}
	if(!isdefined(nosound))
	{
		nosound = 0;
	}
	if(!isdefined(b_switch_weapon))
	{
		b_switch_weapon = 1;
	}
	primaryWeapons = self GetWeaponsListPrimaries();
	initial_current_weapon = self GetCurrentWeapon();
	current_weapon = self switch_from_alt_weapon(initial_current_weapon);
	/#
		Assert(self player_can_use_content(weapon));
	#/
	if(!isdefined(is_upgrade))
	{
		is_upgrade = 0;
	}
	weapon_limit = zm_utility::get_player_weapon_limit(self);
	if(zm_equipment::is_equipment(weapon))
	{
		self zm_equipment::give(weapon);
	}
	if(weapon.isRiotShield)
	{
		if(isdefined(self.player_shield_reset_health))
		{
			self [[self.player_shield_reset_health]]();
		}
	}
	if(self HasWeapon(weapon))
	{
		if(weapon.isBallisticKnife)
		{
			self notify("zmb_lost_knife");
		}
		self GiveStartAmmo(weapon);
		if(!zm_utility::is_offhand_weapon(weapon))
		{
			self SwitchToWeapon(weapon);
		}
		self notify("weapon_give", weapon);
		return weapon;
	}
	if(weapon.name == "ray_gun" || weapon.name == "raygun_mark2")
	{
		if(self has_weapon_or_upgrade(GetWeapon("raygun_mark2")) && weapon.name == "ray_gun")
		{
			for(i = 0; i < primaryWeapons.size; i++)
			{
				if(IsSubStr(primaryWeapons[i].name, "raygun_mark2"))
				{
					self GiveStartAmmo(primaryWeapons[i]);
					break;
				}
			}
			self notify("weapon_give", weapon);
			return weapon;
		}
		else if(self has_weapon_or_upgrade(GetWeapon("ray_gun")) && weapon.name == "raygun_mark2")
		{
			for(i = 0; i < primaryWeapons.size; i++)
			{
				if(IsSubStr(primaryWeapons[i].name, "ray_gun"))
				{
					self weapon_take(primaryWeapons[i]);
					break;
				}
			}
			weapon = self give_build_kit_weapon(weapon);
			self notify("weapon_give", weapon);
			self GiveStartAmmo(weapon);
			self SwitchToWeapon(weapon);
			return weapon;
		}
	}
	if(zm_utility::is_melee_weapon(weapon))
	{
		current_weapon = zm_melee_weapon::change_melee_weapon(weapon, current_weapon);
	}
	else if(zm_utility::is_hero_weapon(weapon))
	{
		old_hero = self zm_utility::get_player_hero_weapon();
		if(old_hero != level.weaponNone)
		{
			self weapon_take(old_hero);
		}
		self zm_utility::set_player_hero_weapon(weapon);
	}
	else if(zm_utility::is_lethal_grenade(weapon))
	{
		old_lethal = self zm_utility::get_player_lethal_grenade();
		if(old_lethal != level.weaponNone)
		{
			self weapon_take(old_lethal);
		}
		self zm_utility::set_player_lethal_grenade(weapon);
	}
	else if(zm_utility::is_tactical_grenade(weapon))
	{
		old_tactical = self zm_utility::get_player_tactical_grenade();
		if(old_tactical != level.weaponNone)
		{
			self weapon_take(old_tactical);
		}
		self zm_utility::set_player_tactical_grenade(weapon);
	}
	else if(zm_utility::is_placeable_mine(weapon))
	{
		old_mine = self zm_utility::get_player_placeable_mine();
		if(old_mine != level.weaponNone)
		{
			self weapon_take(old_mine);
		}
		self zm_utility::set_player_placeable_mine(weapon);
	}
	if(!zm_utility::is_offhand_weapon(weapon))
	{
		self take_fallback_weapon();
	}
	if(primaryWeapons.size >= weapon_limit)
	{
		if(zm_utility::is_placeable_mine(current_weapon) || zm_equipment::is_equipment(current_weapon))
		{
			current_weapon = undefined;
		}
		if(isdefined(current_weapon))
		{
			if(!zm_utility::is_offhand_weapon(weapon))
			{
				if(current_weapon.isBallisticKnife)
				{
					self notify("zmb_lost_knife");
				}
				self weapon_take(current_weapon);
				if(isdefined(initial_current_weapon) && IsSubStr(initial_current_weapon.name, "dualoptic"))
				{
					self weapon_take(initial_current_weapon);
				}
			}
		}
	}
	if(isdefined(level.zombiemode_offhand_weapon_give_override))
	{
		if(self [[level.zombiemode_offhand_weapon_give_override]](weapon))
		{
			self notify("weapon_give", weapon);
			self zm_utility::play_sound_on_ent("purchase");
			return weapon;
		}
	}
	if(weapon.isBallisticKnife)
	{
		weapon = self zm_melee_weapon::give_ballistic_knife(weapon, is_weapon_upgraded(weapon));
	}
	else if(zm_utility::is_placeable_mine(weapon))
	{
		self thread zm_placeable_mine::setup_for_player(weapon);
		self play_weapon_vo(weapon, magic_box);
		self notify("weapon_give", weapon);
		return weapon;
	}
	if(isdefined(level.zombie_weapons_callbacks) && isdefined(level.zombie_weapons_callbacks[weapon]))
	{
		self thread [[level.zombie_weapons_callbacks[weapon]]]();
		play_weapon_vo(weapon, magic_box);
		self notify("weapon_give", weapon);
		return weapon;
	}
	if(!(isdefined(nosound) && nosound))
	{
		self zm_utility::play_sound_on_ent("purchase");
	}
	weapon = self give_build_kit_weapon(weapon);
	self notify("weapon_give", weapon);
	self GiveStartAmmo(weapon);
	if(b_switch_weapon && !zm_utility::is_offhand_weapon(weapon))
	{
		if(!zm_utility::is_melee_weapon(weapon))
		{
			self SwitchToWeapon(weapon);
		}
		else
		{
			self SwitchToWeapon(current_weapon);
		}
	}
	if(!(isdefined(nosound) && nosound))
	{
		self play_weapon_vo(weapon, magic_box);
	}
	return weapon;
}

/*
	Name: weapon_take
	Namespace: zm_weapons
	Checksum: 0xC0D61261
	Offset: 0x8680
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function weapon_take(weapon)
{
	self notify("weapon_take", weapon);
	if(self HasWeapon(weapon))
	{
		self TakeWeapon(weapon);
	}
}

/*
	Name: play_weapon_vo
	Namespace: zm_weapons
	Checksum: 0x2970475E
	Offset: 0x86D8
	Size: 0x203
	Parameters: 2
	Flags: None
*/
function play_weapon_vo(weapon, magic_box)
{
	if(isdefined(level._audio_custom_weapon_check))
	{
		type = self [[level._audio_custom_weapon_check]](weapon, magic_box);
	}
	else
	{
		type = self weapon_type_check(weapon);
	}
	if(!isdefined(type))
	{
		return;
	}
	if(isdefined(level.sndWeaponPickupOverride))
	{
		foreach(override in level.sndWeaponPickupOverride)
		{
			if(weapon.name === override)
			{
				self zm_audio::create_and_play_dialog("weapon_pickup", override);
				return;
			}
		}
	}
	else if(isdefined(magic_box) && magic_box)
	{
		self zm_audio::create_and_play_dialog("box_pickup", type);
	}
	else if(type == "upgrade")
	{
		self zm_audio::create_and_play_dialog("weapon_pickup", "upgrade");
	}
	else if(randomIntRange(0, 100) <= 50)
	{
		self zm_audio::create_and_play_dialog("weapon_pickup", type);
	}
	else
	{
		self zm_audio::create_and_play_dialog("weapon_pickup", "generic");
	}
}

/*
	Name: weapon_type_check
	Namespace: zm_weapons
	Checksum: 0x3F740074
	Offset: 0x88E8
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function weapon_type_check(weapon)
{
	if(weapon.name == "zombie_beast_grapple_dwr" || weapon.name == "zombie_beast_lightning_dwl" || weapon.name == "zombie_beast_lightning_dwl2" || weapon.name == "zombie_beast_lightning_dwl3")
	{
		return undefined;
	}
	if(!isdefined(self.entity_num))
	{
		return "crappy";
	}
	weapon = get_nonalternate_weapon(weapon);
	weapon = weapon.rootweapon;
	if(is_weapon_upgraded(weapon))
	{
		return "upgrade";
	}
	else if(isdefined(level.zombie_weapons[weapon]))
	{
		return level.zombie_weapons[weapon].vox;
	}
	return "crappy";
}

/*
	Name: ammo_give
	Namespace: zm_weapons
	Checksum: 0xD6C98B8
	Offset: 0x8A10
	Size: 0x20D
	Parameters: 1
	Flags: None
*/
function ammo_give(weapon)
{
	give_ammo = 0;
	if(!zm_utility::is_offhand_weapon(weapon))
	{
		weapon = self get_weapon_with_attachments(weapon);
		if(isdefined(weapon))
		{
			stockMax = 0;
			stockMax = weapon.maxAmmo;
			clipCount = self GetWeaponAmmoClip(weapon);
			dw_clipcount = self GetWeaponAmmoClip(weapon.dualWieldWeapon);
			currStock = self getammocount(weapon);
			if(currStock - clipCount + dw_clipcount >= stockMax)
			{
				give_ammo = 0;
			}
			else
			{
				give_ammo = 1;
			}
		}
	}
	else if(self has_weapon_or_upgrade(weapon))
	{
		if(self getammocount(weapon) < weapon.maxAmmo)
		{
			give_ammo = 1;
		}
	}
	if(give_ammo)
	{
		self zm_utility::play_sound_on_ent("purchase");
		self giveMaxAmmo(weapon);
		alt_weap = weapon.altweapon;
		if(level.weaponNone != alt_weap)
		{
			self giveMaxAmmo(alt_weap);
		}
		return 1;
	}
	if(!give_ammo)
	{
		return 0;
	}
}

/*
	Name: get_default_weapondata
	Namespace: zm_weapons
	Checksum: 0x58F21B8E
	Offset: 0x8C28
	Size: 0x1D1
	Parameters: 1
	Flags: None
*/
function get_default_weapondata(weapon)
{
	weapondata = [];
	weapondata["weapon"] = weapon;
	dw_weapon = weapon.dualWieldWeapon;
	alt_weapon = weapon.altweapon;
	weaponNone = GetWeapon("none");
	if(isdefined(level.weaponNone))
	{
		weaponNone = level.weaponNone;
	}
	if(weapon != weaponNone)
	{
		weapondata["clip"] = weapon.clipSize;
		weapondata["stock"] = weapon.maxAmmo;
		weapondata["fuel"] = weapon.fuelLife;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}
	if(dw_weapon != weaponNone)
	{
		weapondata["lh_clip"] = dw_weapon.clipSize;
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}
	if(alt_weapon != weaponNone)
	{
		weapondata["alt_clip"] = alt_weapon.clipSize;
		weapondata["alt_stock"] = alt_weapon.maxAmmo;
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}
	return weapondata;
}

/*
	Name: get_player_weapondata
	Namespace: zm_weapons
	Checksum: 0x105BE506
	Offset: 0x8E08
	Size: 0x2A1
	Parameters: 2
	Flags: None
*/
function get_player_weapondata(player, weapon)
{
	weapondata = [];
	if(!isdefined(weapon))
	{
		weapon = player GetCurrentWeapon();
	}
	weapondata["weapon"] = weapon;
	if(weapondata["weapon"] != level.weaponNone)
	{
		weapondata["clip"] = player GetWeaponAmmoClip(weapon);
		weapondata["stock"] = player GetWeaponAmmoStock(weapon);
		weapondata["fuel"] = player GetWeaponAmmoFuel(weapon);
		weapondata["heat"] = player IsWeaponOverheating(1, weapon);
		weapondata["overheat"] = player IsWeaponOverheating(0, weapon);
	}
	else
	{
		weapondata["clip"] = 0;
		weapondata["stock"] = 0;
		weapondata["fuel"] = 0;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}
	dw_weapon = weapon.dualWieldWeapon;
	if(dw_weapon != level.weaponNone)
	{
		weapondata["lh_clip"] = player GetWeaponAmmoClip(dw_weapon);
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}
	alt_weapon = weapon.altweapon;
	if(alt_weapon != level.weaponNone)
	{
		weapondata["alt_clip"] = player GetWeaponAmmoClip(alt_weapon);
		weapondata["alt_stock"] = player GetWeaponAmmoStock(alt_weapon);
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}
	return weapondata;
}

/*
	Name: weapon_is_better
	Namespace: zm_weapons
	Checksum: 0x22B38581
	Offset: 0x90B8
	Size: 0xD7
	Parameters: 2
	Flags: None
*/
function weapon_is_better(left, right)
{
	if(left != right)
	{
		left_upgraded = !isdefined(level.zombie_weapons[left]);
		right_upgraded = !isdefined(level.zombie_weapons[right]);
		if(left_upgraded && right_upgraded)
		{
			leftatt = get_attachment_index(left);
			rightatt = get_attachment_index(right);
			return leftatt > rightatt;
		}
		else if(left_upgraded)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: merge_weapons
	Namespace: zm_weapons
	Checksum: 0x6CB8DCE3
	Offset: 0x9198
	Size: 0x485
	Parameters: 2
	Flags: None
*/
function merge_weapons(oldweapondata, newweapondata)
{
	weapondata = [];
	if(weapon_is_better(oldweapondata["weapon"], newweapondata["weapon"]))
	{
		weapondata["weapon"] = oldweapondata["weapon"];
	}
	else
	{
		weapondata["weapon"] = newweapondata["weapon"];
	}
	weapon = weapondata["weapon"];
	dw_weapon = weapon.dualWieldWeapon;
	alt_weapon = weapon.altweapon;
	if(weapon != level.weaponNone)
	{
		weapondata["clip"] = newweapondata["clip"] + oldweapondata["clip"];
		weapondata["clip"] = Int(min(weapondata["clip"], weapon.clipSize));
		weapondata["stock"] = newweapondata["stock"] + oldweapondata["stock"];
		weapondata["stock"] = Int(min(weapondata["stock"], weapon.maxAmmo));
		weapondata["fuel"] = newweapondata["fuel"] + oldweapondata["fuel"];
		weapondata["fuel"] = Int(min(weapondata["fuel"], weapon.fuelLife));
		weapondata["heat"] = Int(min(newweapondata["heat"], oldweapondata["heat"]));
		weapondata["overheat"] = Int(min(newweapondata["overheat"], oldweapondata["overheat"]));
	}
	if(dw_weapon != level.weaponNone)
	{
		weapondata["lh_clip"] = newweapondata["lh_clip"] + oldweapondata["lh_clip"];
		weapondata["lh_clip"] = Int(min(weapondata["lh_clip"], dw_weapon.clipSize));
	}
	if(alt_weapon != level.weaponNone)
	{
		weapondata["alt_clip"] = newweapondata["alt_clip"] + oldweapondata["alt_clip"];
		weapondata["alt_clip"] = Int(min(weapondata["alt_clip"], alt_weapon.clipSize));
		weapondata["alt_stock"] = newweapondata["alt_stock"] + oldweapondata["alt_stock"];
		weapondata["alt_stock"] = Int(min(weapondata["alt_stock"], alt_weapon.maxAmmo));
	}
	return weapondata;
}

/*
	Name: weapondata_give
	Namespace: zm_weapons
	Checksum: 0xB78B0AD2
	Offset: 0x9628
	Size: 0x31B
	Parameters: 1
	Flags: None
*/
function weapondata_give(weapondata)
{
	current = self get_player_weapon_with_same_base(weapondata["weapon"]);
	if(isdefined(current))
	{
		curweapondata = get_player_weapondata(self, current);
		self weapon_take(current);
		weapondata = merge_weapons(curweapondata, weapondata);
	}
	weapon = weapondata["weapon"];
	weapon_give(weapon, undefined, undefined, 1);
	if(weapon != level.weaponNone)
	{
		self SetWeaponAmmoClip(weapon, weapondata["clip"]);
		self SetWeaponAmmoStock(weapon, weapondata["stock"]);
		if(isdefined(weapondata["fuel"]))
		{
			self SetWeaponAmmoFuel(weapon, weapondata["fuel"]);
		}
		if(isdefined(weapondata["heat"]) && isdefined(weapondata["overheat"]))
		{
			self SetWeaponOverheating(weapondata["overheat"], weapondata["heat"], weapon);
		}
	}
	dw_weapon = weapon.dualWieldWeapon;
	if(dw_weapon != level.weaponNone)
	{
		if(!self HasWeapon(dw_weapon))
		{
			self GiveWeapon(dw_weapon);
		}
		self SetWeaponAmmoClip(dw_weapon, weapondata["lh_clip"]);
	}
	alt_weapon = weapon.altweapon;
	if(alt_weapon != level.weaponNone && alt_weapon.altweapon == weapon)
	{
		if(!self HasWeapon(alt_weapon))
		{
			self GiveWeapon(alt_weapon);
		}
		self SetWeaponAmmoClip(alt_weapon, weapondata["alt_clip"]);
		self SetWeaponAmmoStock(alt_weapon, weapondata["alt_stock"]);
	}
}

/*
	Name: weapondata_take
	Namespace: zm_weapons
	Checksum: 0x1FDC094A
	Offset: 0x9950
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function weapondata_take(weapondata)
{
	weapon = weapondata["weapon"];
	if(weapon != level.weaponNone)
	{
		if(self HasWeapon(weapon))
		{
			self weapon_take(weapon);
		}
	}
	dw_weapon = weapon.dualWieldWeapon;
	if(dw_weapon != level.weaponNone)
	{
		if(self HasWeapon(dw_weapon))
		{
			self weapon_take(dw_weapon);
		}
	}
	for(alt_weapon = weapon.altweapon; alt_weapon != level.weaponNone;  = weapon.altweapon)
	{
		if(self HasWeapon(alt_weapon))
		{
			self weapon_take(alt_weapon);
		}
	}
}

/*
	Name: create_loadout
	Namespace: zm_weapons
	Checksum: 0x7E6772E1
	Offset: 0x9AA0
	Size: 0x1AD
	Parameters: 1
	Flags: None
*/
function create_loadout(weapons)
{
	weaponNone = GetWeapon("none");
	if(isdefined(level.weaponNone))
	{
		weaponNone = level.weaponNone;
	}
	loadout = spawnstruct();
	loadout.weapons = [];
	foreach(weapon in weapons)
	{
		if(IsString(weapon))
		{
			weapon = GetWeapon(weapon);
		}
		if(weapon == weaponNone)
		{
			/#
				println("Dev Block strings are not supported" + weapon.name);
			#/
		}
		loadout.weapons[weapon.name] = get_default_weapondata(weapon);
		if(!isdefined(loadout.current))
		{
			loadout.current = weapon;
		}
	}
	return loadout;
}

/*
	Name: player_get_loadout
	Namespace: zm_weapons
	Checksum: 0xC25F2BB0
	Offset: 0x9C58
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function player_get_loadout()
{
	loadout = spawnstruct();
	loadout.current = self GetCurrentWeapon();
	loadout.stowed = self GetStowedWeapon();
	loadout.weapons = [];
	foreach(weapon in self GetWeaponsList())
	{
		loadout.weapons[weapon.name] = get_player_weapondata(self, weapon);
	}
	return loadout;
}

/*
	Name: player_give_loadout
	Namespace: zm_weapons
	Checksum: 0xF6710B16
	Offset: 0x9D80
	Size: 0x1E3
	Parameters: 3
	Flags: None
*/
function player_give_loadout(loadout, replace_existing, immediate_switch)
{
	if(!isdefined(replace_existing))
	{
		replace_existing = 1;
	}
	if(!isdefined(immediate_switch))
	{
		immediate_switch = 0;
	}
	if(isdefined(replace_existing) && replace_existing)
	{
		self TakeAllWeapons();
	}
	foreach(weapondata in loadout.weapons)
	{
		self weapondata_give(weapondata);
	}
	if(!zm_utility::is_offhand_weapon(loadout.current))
	{
		if(immediate_switch)
		{
			self SwitchToWeaponImmediate(loadout.current);
		}
		else
		{
			self SwitchToWeapon(loadout.current);
		}
	}
	else if(immediate_switch)
	{
		self SwitchToWeaponImmediate();
	}
	else
	{
		self SwitchToWeapon();
	}
	if(isdefined(loadout.stowed))
	{
		self SetStowedWeapon(loadout.stowed);
	}
}

/*
	Name: player_take_loadout
	Namespace: zm_weapons
	Checksum: 0x3ED37BBA
	Offset: 0x9F70
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function player_take_loadout(loadout)
{
	foreach(weapondata in loadout.weapons)
	{
		self weapondata_take(weapondata);
	}
}

/*
	Name: register_zombie_weapon_callback
	Namespace: zm_weapons
	Checksum: 0x2AE33781
	Offset: 0xA018
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function register_zombie_weapon_callback(weapon, func)
{
	if(!isdefined(level.zombie_weapons_callbacks))
	{
		level.zombie_weapons_callbacks = [];
	}
	if(!isdefined(level.zombie_weapons_callbacks[weapon]))
	{
		level.zombie_weapons_callbacks[weapon] = func;
	}
}

/*
	Name: set_stowed_weapon
	Namespace: zm_weapons
	Checksum: 0xC8FA7BBF
	Offset: 0xA078
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function set_stowed_weapon(weapon)
{
	self.weapon_stowed = weapon;
	if(!(isdefined(self.stowed_weapon_suppressed) && self.stowed_weapon_suppressed))
	{
		self SetStowedWeapon(self.weapon_stowed);
	}
}

/*
	Name: clear_stowed_weapon
	Namespace: zm_weapons
	Checksum: 0x549A831A
	Offset: 0xA0D0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function clear_stowed_weapon()
{
	self.weapon_stowed = undefined;
	self ClearStowedWeapon();
}

/*
	Name: suppress_stowed_weapon
	Namespace: zm_weapons
	Checksum: 0x39FB5D74
	Offset: 0xA100
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function suppress_stowed_weapon(onOff)
{
	self.stowed_weapon_suppressed = onOff;
	if(onOff || !isdefined(self.weapon_stowed))
	{
		self ClearStowedWeapon();
	}
	else
	{
		self SetStowedWeapon(self.weapon_stowed);
	}
}

/*
	Name: checkStringValid
	Namespace: zm_weapons
	Checksum: 0x93E2AB52
	Offset: 0xA170
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function checkStringValid(STR)
{
	if(STR != "")
	{
		return STR;
	}
	return undefined;
}

/*
	Name: load_weapon_spec_from_table
	Namespace: zm_weapons
	Checksum: 0x69E8AA05
	Offset: 0xA1A0
	Size: 0x51B
	Parameters: 2
	Flags: None
*/
function load_weapon_spec_from_table(table, first_row)
{
	gametype = GetDvarString("ui_gametype");
	index = 1;
	for(row = TableLookupRow(table, index); isdefined(row);  = TableLookupRow(table, index))
	{
		weapon_name = checkStringValid(row[0]);
		upgrade_name = checkStringValid(row[1]);
		hint = checkStringValid(row[2]);
		cost = Int(row[3]);
		weaponVO = checkStringValid(row[4]);
		weaponVOresp = checkStringValid(row[5]);
		ammo_cost = undefined;
		if("" != row[6])
		{
			ammo_cost = Int(row[6]);
		}
		create_vox = checkStringValid(row[7]);
		is_zcleansed = ToLower(row[8]) == "true";
		in_box = ToLower(row[9]) == "true";
		upgrade_in_box = ToLower(row[10]) == "true";
		is_limited = ToLower(row[11]) == "true";
		is_aat_exempt = ToLower(row[17]) == "true";
		limit = Int(row[12]);
		upgrade_limit = Int(row[13]);
		content_restrict = row[14];
		wallbuy_autospawn = ToLower(row[15]) == "true";
		WEAPON_CLASS = checkStringValid(row[16]);
		is_wonder_weapon = ToLower(row[18]) == "true";
		force_attachments = ToLower(row[19]);
		zm_utility::include_weapon(weapon_name, in_box);
		if(isdefined(upgrade_name))
		{
			zm_utility::include_weapon(upgrade_name, upgrade_in_box);
		}
		add_zombie_weapon(weapon_name, upgrade_name, hint, cost, weaponVO, weaponVOresp, ammo_cost, create_vox, is_wonder_weapon, force_attachments);
		if(is_limited)
		{
			if(isdefined(limit))
			{
				add_limited_weapon(weapon_name, limit);
			}
			if(isdefined(upgrade_limit) && isdefined(upgrade_name))
			{
				add_limited_weapon(upgrade_name, upgrade_limit);
			}
		}
		if(is_aat_exempt && isdefined(upgrade_name))
		{
			AAT::register_aat_exemption(GetWeapon(upgrade_name));
		}
		index++;
	}
}

/*
	Name: autofill_wallbuys_init
	Namespace: zm_weapons
	Checksum: 0xA7F3D169
	Offset: 0xA6C8
	Size: 0x695
	Parameters: 0
	Flags: None
*/
function autofill_wallbuys_init()
{
	Wallbuys = struct::get_array("wallbuy_autofill", "targetname");
	if(!isdefined(Wallbuys) || Wallbuys.size == 0 || !isdefined(level.wallbuy_autofill_weapons) || level.wallbuy_autofill_weapons.size == 0)
	{
		return;
	}
	level.use_autofill_wallbuy = 1;
	level.active_autofill_wallbuys = [];
	array_keys["all"] = getArrayKeys(level.wallbuy_autofill_weapons["all"]);
	class_all = [];
	index = 0;
	foreach(wallbuy in Wallbuys)
	{
		WEAPON_CLASS = wallbuy.script_string;
		weapon = undefined;
		if(isdefined(WEAPON_CLASS) && WEAPON_CLASS != "")
		{
			if(!isdefined(array_keys[WEAPON_CLASS]) && isdefined(level.wallbuy_autofill_weapons[WEAPON_CLASS]))
			{
				array_keys[WEAPON_CLASS] = getArrayKeys(level.wallbuy_autofill_weapons[WEAPON_CLASS]);
			}
			if(isdefined(array_keys[WEAPON_CLASS]))
			{
				for(i = 0; i < array_keys[WEAPON_CLASS].size; i++)
				{
					if(level.wallbuy_autofill_weapons["all"][array_keys[WEAPON_CLASS][i]])
					{
						weapon = array_keys[WEAPON_CLASS][i];
						level.wallbuy_autofill_weapons["all"][weapon] = 0;
						break;
					}
				}
			}
			else
			{
				continue;
			}
		}
		else
		{
			class_all[class_all.size] = wallbuy;
			continue;
		}
		if(!isdefined(weapon))
		{
			continue;
		}
		wallbuy.zombie_weapon_upgrade = weapon.name;
		wallbuy.weapon = weapon;
		right = AnglesToRight(wallbuy.angles);
		wallbuy.origin = wallbuy.origin - right * 2;
		wallbuy.target = "autofill_wallbuy_" + index;
		target_struct = spawnstruct();
		target_struct.targetname = wallbuy.target;
		target_struct.angles = wallbuy.angles;
		target_struct.origin = wallbuy.origin;
		model = wallbuy.weapon.worldmodel;
		target_struct.model = model;
		target_struct struct::init();
		level.active_autofill_wallbuys[level.active_autofill_wallbuys.size] = wallbuy;
		index++;
	}
	foreach(wallbuy in class_all)
	{
		weapon = undefined;
		for(i = 0; i < array_keys["all"].size; i++)
		{
			if(level.wallbuy_autofill_weapons["all"][array_keys["all"][i]])
			{
				weapon = array_keys["all"][i];
				level.wallbuy_autofill_weapons["all"][weapon] = 0;
				break;
			}
		}
		if(!isdefined(weapon))
		{
			break;
		}
		wallbuy.zombie_weapon_upgrade = weapon.name;
		wallbuy.weapon = weapon;
		right = AnglesToRight(wallbuy.angles);
		wallbuy.origin = wallbuy.origin - right * 2;
		wallbuy.target = "autofill_wallbuy_" + index;
		target_struct = spawnstruct();
		target_struct.targetname = wallbuy.target;
		target_struct.angles = wallbuy.angles;
		target_struct.origin = wallbuy.origin;
		model = wallbuy.weapon.worldmodel;
		target_struct.model = model;
		target_struct struct::init();
		level.active_autofill_wallbuys[level.active_autofill_wallbuys.size] = wallbuy;
		index++;
	}
}

/*
	Name: is_wallbuy
	Namespace: zm_weapons
	Checksum: 0xF7745372
	Offset: 0xAD68
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function is_wallbuy(w_to_check)
{
	w_base = get_base_weapon(w_to_check);
	foreach(s_wallbuy in level._spawned_wallbuys)
	{
		if(s_wallbuy.weapon == w_base)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: is_wonder_weapon
	Namespace: zm_weapons
	Checksum: 0x9164F3BF
	Offset: 0xAE30
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function is_wonder_weapon(w_to_check)
{
	w_base = get_base_weapon(w_to_check);
	if(isdefined(level.zombie_weapons[w_base]) && level.zombie_weapons[w_base].is_wonder_weapon)
	{
		return 1;
	}
	return 0;
}

