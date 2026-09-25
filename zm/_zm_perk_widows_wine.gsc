#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_powerup_ww_grenade;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_perk_widows_wine;

/*
	Name: __init__sytem__
	Namespace: zm_perk_widows_wine
	Checksum: 0x5BA4D10F
	Offset: 0x680
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_widows_wine", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_widows_wine
	Checksum: 0xA3F493AA
	Offset: 0x6C0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_widows_wine_perk_for_level();
}

/*
	Name: enable_widows_wine_perk_for_level
	Namespace: zm_perk_widows_wine
	Checksum: 0xD716AED5
	Offset: 0x6E0
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function enable_widows_wine_perk_for_level()
{
	zm_perks::register_perk_basic_info("specialty_widowswine", "widows_wine", 4000, &"ZOMBIE_PERK_WIDOWSWINE", GetWeapon("zombie_perk_bottle_widows_wine"));
	zm_perks::register_perk_precache_func("specialty_widowswine", &widows_wine_precache);
	zm_perks::register_perk_clientfields("specialty_widowswine", &widows_wine_register_clientfield, &widows_wine_set_clientfield);
	zm_perks::register_perk_machine("specialty_widowswine", &widows_wine_perk_machine_setup);
	zm_perks::register_perk_host_migration_params("specialty_widowswine", "vending_widowswine", "widow_light");
	zm_perks::register_perk_threads("specialty_widowswine", &widows_wine_perk_activate, &widows_wine_perk_lost);
	if(isdefined(level.custom_widows_wine_perk_threads) && level.custom_widows_wine_perk_threads)
	{
		level thread [[level.custom_widows_wine_perk_threads]]();
	}
	clientfield::register("toplayer", "widows_wine_1p_contact_explosion", 1, 1, "counter");
	init_widows_wine();
}

/*
	Name: widows_wine_precache
	Namespace: zm_perk_widows_wine
	Checksum: 0x772FD362
	Offset: 0x880
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function widows_wine_precache()
{
	if(isdefined(level.widows_wine_precache_override_func))
	{
		[[level.widows_wine_precache_override_func]]();
		return;
	}
	level._effect["widow_light"] = "zombie/fx_perk_widows_wine_zmb";
	level._effect["widows_wine_wrap"] = "zombie/fx_widows_wrap_torso_zmb";
	level.machine_assets["specialty_widowswine"] = spawnstruct();
	level.machine_assets["specialty_widowswine"].weapon = GetWeapon("zombie_perk_bottle_widows_wine");
	level.machine_assets["specialty_widowswine"].off_model = "p7_zm_vending_widows_wine";
	level.machine_assets["specialty_widowswine"].on_model = "p7_zm_vending_widows_wine";
}

/*
	Name: widows_wine_register_clientfield
	Namespace: zm_perk_widows_wine
	Checksum: 0x41D50848
	Offset: 0x980
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function widows_wine_register_clientfield()
{
	clientfield::register("clientuimodel", "hudItems.perks.widows_wine", 1, 2, "int");
	clientfield::register("actor", "widows_wine_wrapping", 1, 1, "int");
	clientfield::register("vehicle", "widows_wine_wrapping", 1, 1, "int");
}

/*
	Name: widows_wine_set_clientfield
	Namespace: zm_perk_widows_wine
	Checksum: 0x28255F82
	Offset: 0xA20
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function widows_wine_set_clientfield(State)
{
	self clientfield::set_player_uimodel("hudItems.perks.widows_wine", State);
}

/*
	Name: widows_wine_perk_machine_setup
	Namespace: zm_perk_widows_wine
	Checksum: 0x1F6A9D8C
	Offset: 0xA58
	Size: 0xBB
	Parameters: 4
	Flags: None
*/
function widows_wine_perk_machine_setup(use_trigger, perk_machine, bump_trigger, collision)
{
	use_trigger.script_sound = "mus_perks_widow_jingle";
	use_trigger.script_string = "widowswine_perk";
	use_trigger.script_label = "mus_perks_widow_sting";
	use_trigger.target = "vending_widowswine";
	perk_machine.script_string = "widowswine_perk";
	perk_machine.targetname = "vending_widowswine";
	if(isdefined(bump_trigger))
	{
		bump_trigger.script_string = "widowswine_perk";
	}
}

/*
	Name: init_widows_wine
	Namespace: zm_perk_widows_wine
	Checksum: 0x832F7AB
	Offset: 0xB20
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function init_widows_wine()
{
	zm_utility::register_lethal_grenade_for_level("sticky_grenade_widows_wine");
	zm_spawner::register_zombie_damage_callback(&widows_wine_zombie_damage_response);
	zm_spawner::register_zombie_death_event_callback(&widows_wine_zombie_death_watch);
	zm::register_vehicle_damage_callback(&widows_wine_vehicle_damage_response);
	zm_perks::register_perk_damage_override_func(&widows_wine_damage_callback);
	level.w_widows_wine_grenade = GetWeapon("sticky_grenade_widows_wine");
	zm_utility::register_melee_weapon_for_level("knife_widows_wine");
	level.w_widows_wine_knife = GetWeapon("knife_widows_wine");
	zm_utility::register_melee_weapon_for_level("bowie_knife_widows_wine");
	level.w_widows_wine_bowie_knife = GetWeapon("bowie_knife_widows_wine");
	zm_utility::register_melee_weapon_for_level("sickle_knife_widows_wine");
	level.w_widows_wine_sickle_knife = GetWeapon("sickle_knife_widows_wine");
}

/*
	Name: widows_wine_perk_activate
	Namespace: zm_perk_widows_wine
	Checksum: 0x78727F82
	Offset: 0xC90
	Size: 0x2BB
	Parameters: 0
	Flags: None
*/
function widows_wine_perk_activate()
{
	if(level.w_widows_wine_grenade == self zm_utility::get_player_lethal_grenade())
	{
		return;
	}
	self.w_widows_wine_prev_grenade = self zm_utility::get_player_lethal_grenade();
	self TakeWeapon(self.w_widows_wine_prev_grenade);
	self GiveWeapon(level.w_widows_wine_grenade);
	self zm_utility::set_player_lethal_grenade(level.w_widows_wine_grenade);
	self.w_widows_wine_prev_knife = self zm_utility::get_player_melee_weapon();
	if(isdefined(self.widows_wine_knife_override))
	{
		self [[self.widows_wine_knife_override]]();
	}
	else
	{
		self TakeWeapon(self.w_widows_wine_prev_knife);
		if(self.w_widows_wine_prev_knife.name == "bowie_knife")
		{
			self GiveWeapon(level.w_widows_wine_bowie_knife);
			self zm_utility::set_player_melee_weapon(level.w_widows_wine_bowie_knife);
		}
		else if(self.w_widows_wine_prev_knife.name == "sickle_knife")
		{
			self GiveWeapon(level.w_widows_wine_sickle_knife);
			self zm_utility::set_player_melee_weapon(level.w_widows_wine_sickle_knife);
		}
		else
		{
			self GiveWeapon(level.w_widows_wine_knife);
			self zm_utility::set_player_melee_weapon(level.w_widows_wine_knife);
		}
	}
	/#
		Assert(!isdefined(self.check_override_wallbuy_purchase) || self.check_override_wallbuy_purchase == &widows_wine_override_wallbuy_purchase);
	#/
	/#
		Assert(!isdefined(self.check_override_melee_wallbuy_purchase) || self.check_override_melee_wallbuy_purchase == &widows_wine_override_melee_wallbuy_purchase);
	#/
	self.check_override_wallbuy_purchase = &widows_wine_override_wallbuy_purchase;
	self.check_override_melee_wallbuy_purchase = &widows_wine_override_melee_wallbuy_purchase;
	self thread grenade_bounce_monitor();
}

/*
	Name: widows_wine_contact_explosion
	Namespace: zm_perk_widows_wine
	Checksum: 0xC808322
	Offset: 0xF58
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function widows_wine_contact_explosion()
{
	self MagicGrenadeType(self.current_lethal_grenade, self.origin + VectorScale((0, 0, 1), 48), (0, 0, 0), 0);
	self SetWeaponAmmoClip(self.current_lethal_grenade, self GetWeaponAmmoClip(self.current_lethal_grenade) - 1);
	self clientfield::increment_to_player("widows_wine_1p_contact_explosion", 1);
}

/*
	Name: widows_wine_zombie_damage_response
	Namespace: zm_perk_widows_wine
	Checksum: 0x563D7EA2
	Offset: 0x1008
	Size: 0x20B
	Parameters: 13
	Flags: None
*/
function widows_wine_zombie_damage_response(str_mod, str_hit_location, v_hit_origin, e_player, n_amount, w_weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(isdefined(self.damageWeapon) && self.damageWeapon == level.w_widows_wine_grenade || (str_mod === "MOD_MELEE" && isdefined(e_player) && isPlayer(e_player) && e_player hasPerk("specialty_widowswine") && RandomFloat(1) <= 0.5))
	{
		if(!(isdefined(self.no_widows_wine) && self.no_widows_wine))
		{
			self thread zm_powerups::check_for_instakill(e_player, str_mod, str_hit_location);
			n_dist_sq = DistanceSquared(self.origin, v_hit_origin);
			if(n_dist_sq <= 10000)
			{
				self thread widows_wine_cocoon_zombie(e_player);
			}
			else
			{
				self thread widows_wine_slow_zombie(e_player);
			}
			if(!isdefined(self.no_damage_points) && self.no_damage_points && isdefined(e_player))
			{
				damage_type = "damage";
				e_player zm_score::player_add_points(damage_type, str_mod, str_hit_location, 0, undefined, w_weapon);
			}
			return 1;
		}
	}
	return 0;
}

/*
	Name: widows_wine_vehicle_damage_response
	Namespace: zm_perk_widows_wine
	Checksum: 0x9566775F
	Offset: 0x1220
	Size: 0x163
	Parameters: 15
	Flags: None
*/
function widows_wine_vehicle_damage_response(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(isdefined(weapon) && weapon == level.w_widows_wine_grenade && (!isdefined(self.b_widows_wine_cocoon) && self.b_widows_wine_cocoon))
	{
		if(self.archetype === "parasite")
		{
			self thread vehicle_stuck_grenade_monitor();
		}
		self thread widows_wine_vehicle_behavior(eAttacker, weapon);
		if(!isdefined(self.no_damage_points) && self.no_damage_points && isdefined(eAttacker))
		{
			damage_type = "damage";
			eAttacker zm_score::player_add_points(damage_type, sMeansOfDeath, sHitLoc, 0, undefined, weapon);
		}
		return 0;
	}
	return iDamage;
}

/*
	Name: widows_wine_damage_callback
	Namespace: zm_perk_widows_wine
	Checksum: 0x7B715809
	Offset: 0x1390
	Size: 0x129
	Parameters: 10
	Flags: None
*/
function widows_wine_damage_callback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(sWeapon == level.w_widows_wine_grenade)
	{
		return 0;
	}
	if(self.current_lethal_grenade == level.w_widows_wine_grenade && self GetWeaponAmmoClip(self.current_lethal_grenade) > 0 && !self bgb::is_enabled("zm_bgb_burned_out"))
	{
		if(sMeansOfDeath == "MOD_MELEE" && isai(eAttacker) || (sMeansOfDeath == "MOD_EXPLOSIVE" && isVehicle(eAttacker)))
		{
			self thread widows_wine_contact_explosion();
			return iDamage;
		}
	}
}

/*
	Name: widows_wine_zombie_death_watch
	Namespace: zm_perk_widows_wine
	Checksum: 0x4789DAE1
	Offset: 0x14C8
	Size: 0x1B5
	Parameters: 1
	Flags: None
*/
function widows_wine_zombie_death_watch(attacker)
{
	if(isdefined(self.b_widows_wine_cocoon) && self.b_widows_wine_cocoon || (isdefined(self.b_widows_wine_slow) && self.b_widows_wine_slow) && (!isdefined(self.b_widows_wine_no_powerup) && self.b_widows_wine_no_powerup))
	{
		if(isdefined(self.attacker) && isPlayer(self.attacker) && self.attacker hasPerk("specialty_widowswine"))
		{
			chance = 0.2;
			if(isdefined(self.damageWeapon) && self.damageWeapon == level.w_widows_wine_grenade)
			{
				chance = 0.15;
			}
			else if(isdefined(self.damageWeapon) && (self.damageWeapon == level.w_widows_wine_knife || self.damageWeapon == level.w_widows_wine_bowie_knife || self.damageWeapon == level.w_widows_wine_sickle_knife))
			{
				chance = 0.25;
			}
			if(RandomFloat(1) <= chance)
			{
				self.no_powerups = 1;
				level._powerup_timeout_override = &powerup_widows_wine_timeout;
				level thread zm_powerups::specific_powerup_drop("ww_grenade", self.origin, undefined, undefined, undefined, self.attacker);
				level._powerup_timeout_override = undefined;
			}
		}
	}
}

/*
	Name: powerup_widows_wine_timeout
	Namespace: zm_perk_widows_wine
	Checksum: 0x46F072A5
	Offset: 0x1688
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function powerup_widows_wine_timeout()
{
	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self zm_powerups::powerup_show(1);
	wait_time = 1;
	if(isdefined(level._powerup_timeout_custom_time))
	{
		time = [[level._powerup_timeout_custom_time]](self);
		if(time == 0)
		{
			return;
		}
		wait_time = time;
	}
	wait(wait_time);
	for(i = 20; i > 0; i--)
	{
		if(i % 2)
		{
			self zm_powerups::powerup_show(0);
		}
		else
		{
			self zm_powerups::powerup_show(1);
		}
		if(i > 15)
		{
			wait(0.3);
		}
		if(i > 10)
		{
			wait(0.25);
			continue;
		}
		if(i > 5)
		{
			wait(0.15);
			continue;
		}
		wait(0.1);
	}
	self notify("powerup_timedout");
	self zm_powerups::powerup_delete();
}

/*
	Name: widows_wine_cocoon_zombie_score
	Namespace: zm_perk_widows_wine
	Checksum: 0x9B857FC4
	Offset: 0x1810
	Size: 0xD3
	Parameters: 3
	Flags: None
*/
function widows_wine_cocoon_zombie_score(e_player, duration, max_score)
{
	self notify("widows_wine_cocoon_zombie_score");
	self endon("widows_wine_cocoon_zombie_score");
	self endon("death");
	if(!isdefined(self.ww_points_given))
	{
		self.ww_points_given = 0;
	}
	start_time = GetTime();
	end_time = start_time + duration * 1000;
	while(GetTime() < end_time && self.ww_points_given < max_score)
	{
		e_player zm_score::add_to_player_score(10);
		wait(duration / max_score);
	}
}

/*
	Name: widows_wine_cocoon_zombie
	Namespace: zm_perk_widows_wine
	Checksum: 0x2CC2B6EB
	Offset: 0x18F0
	Size: 0x1B7
	Parameters: 1
	Flags: None
*/
function widows_wine_cocoon_zombie(e_player)
{
	self notify("widows_wine_cocoon");
	self endon("widows_wine_cocoon");
	if(isdefined(self.kill_on_wine_coccon) && self.kill_on_wine_coccon)
	{
		self kill();
	}
	if(!(isdefined(self.b_widows_wine_cocoon) && self.b_widows_wine_cocoon))
	{
		self.b_widows_wine_cocoon = 1;
		self.e_widows_wine_player = e_player;
		if(isdefined(self.widows_wine_cocoon_fraction_rate))
		{
			widows_wine_cocoon_fraction_rate = self.widows_wine_cocoon_fraction_rate;
		}
		else
		{
			widows_wine_cocoon_fraction_rate = 0.1;
		}
		self ASMSetAnimationRate(widows_wine_cocoon_fraction_rate);
		self clientfield::set("widows_wine_wrapping", 1);
	}
	if(isdefined(e_player))
	{
		self thread widows_wine_cocoon_zombie_score(e_player, 16, 10);
	}
	self util::waittill_any_timeout(16, "death", "widows_wine_cocoon");
	if(!isdefined(self))
	{
		return;
	}
	self ASMSetAnimationRate(1);
	self clientfield::set("widows_wine_wrapping", 0);
	if(isalive(self))
	{
		self.b_widows_wine_cocoon = 0;
	}
}

/*
	Name: widows_wine_slow_zombie
	Namespace: zm_perk_widows_wine
	Checksum: 0xA0E74523
	Offset: 0x1AB0
	Size: 0x1AF
	Parameters: 1
	Flags: None
*/
function widows_wine_slow_zombie(e_player)
{
	self notify("widows_wine_slow");
	self endon("widows_wine_slow");
	if(isdefined(self.b_widows_wine_cocoon) && self.b_widows_wine_cocoon)
	{
		self thread widows_wine_cocoon_zombie(e_player);
		return;
	}
	if(isdefined(e_player))
	{
		self thread widows_wine_cocoon_zombie_score(e_player, 12, 6);
	}
	if(!(isdefined(self.b_widows_wine_slow) && self.b_widows_wine_slow))
	{
		if(isdefined(self.widows_wine_slow_fraction_rate))
		{
			widows_wine_slow_fraction_rate = self.widows_wine_slow_fraction_rate;
		}
		else
		{
			widows_wine_slow_fraction_rate = 0.7;
		}
		self.b_widows_wine_slow = 1;
		self ASMSetAnimationRate(widows_wine_slow_fraction_rate);
		self clientfield::set("widows_wine_wrapping", 1);
	}
	self util::waittill_any_timeout(12, "death", "widows_wine_slow");
	if(!isdefined(self))
	{
		return;
	}
	self ASMSetAnimationRate(1);
	self clientfield::set("widows_wine_wrapping", 0);
	if(isalive(self))
	{
		self.b_widows_wine_slow = 0;
	}
}

/*
	Name: vehicle_stuck_grenade_monitor
	Namespace: zm_perk_widows_wine
	Checksum: 0x31177FF2
	Offset: 0x1C68
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function vehicle_stuck_grenade_monitor()
{
	self endon("death");
	self waittill("grenade_stuck", e_grenade);
	e_grenade detonate();
}

/*
	Name: grenade_bounce_monitor
	Namespace: zm_perk_widows_wine
	Checksum: 0x7462C44E
	Offset: 0x1CB0
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function grenade_bounce_monitor()
{
	self endon("disconnect");
	self endon("stop_widows_wine");
	while(1)
	{
		self waittill("grenade_fire", e_grenade);
		e_grenade thread grenade_bounces();
	}
}

/*
	Name: grenade_bounces
	Namespace: zm_perk_widows_wine
	Checksum: 0xEB500D49
	Offset: 0x1D10
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function grenade_bounces()
{
	self endon("explode");
	self waittill("grenade_bounce", pos, normal, e_target);
	if(isdefined(e_target))
	{
		if(e_target.archetype === "parasite" || e_target.archetype === "raps")
		{
			self detonate();
		}
	}
}

/*
	Name: widows_wine_vehicle_behavior
	Namespace: zm_perk_widows_wine
	Checksum: 0x66246D5E
	Offset: 0x1DB0
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function widows_wine_vehicle_behavior(attacker, weapon)
{
	self endon("death");
	self.b_widows_wine_cocoon = 1;
	if(isdefined(self.archetype))
	{
		if(self.archetype == "raps")
		{
			self clientfield::set("widows_wine_wrapping", 1);
			self._override_raps_combat_speed = 5;
			wait(6);
			self DoDamage(self.health + 1000, self.origin, attacker, undefined, "none", "MOD_EXPLOSIVE", 0, weapon);
		}
		else if(self.archetype == "parasite")
		{
			wait(0.05);
			self DoDamage(self.maxhealth, self.origin);
		}
	}
}

/*
	Name: widows_wine_perk_lost
	Namespace: zm_perk_widows_wine
	Checksum: 0xDD26221D
	Offset: 0x1EC8
	Size: 0x29B
	Parameters: 3
	Flags: None
*/
function widows_wine_perk_lost(b_pause, str_perk, str_result)
{
	self notify("stop_widows_wine");
	self endon("death");
	if(self laststand::player_is_in_laststand())
	{
		self waittill("player_revived");
		if(self hasPerk("specialty_widowswine"))
		{
			return;
		}
	}
	self.check_override_wallbuy_purchase = undefined;
	self TakeWeapon(level.w_widows_wine_grenade);
	if(isdefined(self.w_widows_wine_prev_grenade))
	{
		self.lsgsar_lethal = self.w_widows_wine_prev_grenade;
		self GiveWeapon(self.w_widows_wine_prev_grenade);
		self zm_utility::set_player_lethal_grenade(self.w_widows_wine_prev_grenade);
	}
	else
	{
		self zm_utility::init_player_lethal_grenade();
	}
	grenade = self zm_utility::get_player_lethal_grenade();
	self GiveStartAmmo(grenade);
	if(isdefined(self.current_melee_weapon) && !IsSubStr(self.current_melee_weapon.name, "widows_wine"))
	{
		self.w_widows_wine_prev_knife = self.current_melee_weapon;
	}
	else if(self.w_widows_wine_prev_knife.name == "bowie_knife")
	{
		self TakeWeapon(level.w_widows_wine_bowie_knife);
	}
	else if(self.w_widows_wine_prev_knife.name == "sickle_knife")
	{
		self TakeWeapon(level.w_widows_wine_sickle_knife);
	}
	else
	{
		self TakeWeapon(level.w_widows_wine_knife);
	}
	if(isdefined(self.w_widows_wine_prev_knife))
	{
		self GiveWeapon(self.w_widows_wine_prev_knife);
		self zm_utility::set_player_melee_weapon(self.w_widows_wine_prev_knife);
	}
	else
	{
		self zm_utility::init_player_melee_weapon();
	}
}

/*
	Name: widows_wine_override_wallbuy_purchase
	Namespace: zm_perk_widows_wine
	Checksum: 0x4F1D1247
	Offset: 0x2170
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function widows_wine_override_wallbuy_purchase(weapon, wallbuy)
{
	if(zm_utility::is_lethal_grenade(weapon))
	{
		wallbuy zm_utility::play_sound_on_ent("no_purchase");
		if(isdefined(level.custom_generic_deny_vo_func))
		{
			self [[level.custom_generic_deny_vo_func]]();
		}
		else
		{
			self zm_audio::create_and_play_dialog("general", "sigh");
		}
		return 1;
	}
	return 0;
}

/*
	Name: widows_wine_override_melee_wallbuy_purchase
	Namespace: zm_perk_widows_wine
	Checksum: 0x95130EBF
	Offset: 0x2218
	Size: 0x2EB
	Parameters: 7
	Flags: None
*/
function widows_wine_override_melee_wallbuy_purchase(vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, wallbuy)
{
	if(zm_utility::is_melee_weapon(weapon))
	{
		if(self.w_widows_wine_prev_knife != weapon)
		{
			cost = wallbuy.stub.cost;
			if(self zm_score::can_player_purchase(cost))
			{
				if(wallbuy.first_time_triggered == 0)
				{
					model = GetEnt(wallbuy.target, "targetname");
					if(isdefined(model))
					{
						model thread zm_melee_weapon::melee_weapon_show(self);
					}
					else if(isdefined(wallbuy.clientFieldName))
					{
						level clientfield::set(wallbuy.clientFieldName, 1);
					}
					wallbuy.first_time_triggered = 1;
					if(isdefined(wallbuy.stub))
					{
						wallbuy.stub.first_time_triggered = 1;
					}
				}
				self zm_score::minus_to_player_score(cost);
				/#
					Assert(weapon.name == "Dev Block strings are not supported" || weapon.name == "Dev Block strings are not supported");
				#/
				self.w_widows_wine_prev_knife = weapon;
				if(self.w_widows_wine_prev_knife.name == "bowie_knife")
				{
					self thread zm_melee_weapon::give_melee_weapon(vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, wallbuy);
				}
				else if(self.w_widows_wine_prev_knife.name == "sickle_knife")
				{
					self thread zm_melee_weapon::give_melee_weapon(vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, wallbuy);
				}
			}
			else
			{
				zm_utility::play_sound_on_ent("no_purchase");
				self zm_audio::create_and_play_dialog("general", "outofmoney", 1);
			}
		}
		return 1;
	}
	return 0;
}

