#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_traps;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;

#namespace namespace_8215525;

/*
	Name: __init__sytem__
	Namespace: namespace_8215525
	Checksum: 0x88D4C809
	Offset: 0x958
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragonshield", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8215525
	Checksum: 0xDED349F0
	Offset: 0x9A0
	Size: 0x49B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_craft_shield::init("craft_shield_zm", "dragonshield", "wpn_t7_zmb_dlc3_dragon_shield_dmg0_world", &"ZOMBIE_DRAGON_SHIELD_CRAFT", &"ZOMBIE_DRAGON_SHIELD_TAKEN", &"ZOMBIE_DRAGON_SHIELD_PICKUP");
	clientfield::register("allplayers", "ds_ammo", 12000, 1, "int");
	clientfield::register("allplayers", "burninate", 12000, 1, "counter");
	clientfield::register("allplayers", "burninate_upgraded", 12000, 1, "counter");
	clientfield::register("actor", "dragonshield_snd_projectile_impact", 12000, 1, "counter");
	clientfield::register("vehicle", "dragonshield_snd_projectile_impact", 12000, 1, "counter");
	clientfield::register("actor", "dragonshield_snd_zombie_knockdown", 12000, 1, "counter");
	clientfield::register("vehicle", "dragonshield_snd_zombie_knockdown", 12000, 1, "counter");
	level flag::init("dragon_shield_used");
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.weaponRiotshield = GetWeapon("dragonshield");
	zm_equipment::register("dragonshield", &"ZOMBIE_DRAGON_SHIELD_PICKUP", &"ZOMBIE_DRAGON_SHIELD_HINT", undefined, "riotshield");
	level.weaponRiotshieldUpgraded = GetWeapon("dragonshield_upgraded");
	zm_equipment::register("dragonshield_upgraded", &"ZOMBIE_DRAGON_SHIELD_UPGRADE_PICKUP", &"ZOMBIE_DRAGON_SHIELD_HINT", undefined, "riotshield");
	level.var_7ba638ea = GetWeapon("dragonshield_projectile");
	level.var_855a12ba = GetWeapon("dragonshield_projectile_upgraded");
	level.riotshield_melee_power = &function_71d88f26;
	level.should_shield_absorb_damage = &should_shield_absorb_damage;
	zombie_utility::set_zombie_var("dragonshield_proximity_fling_radius", 96);
	zombie_utility::set_zombie_var("dragonshield_proximity_knockdown_radius", 128);
	zombie_utility::set_zombie_var("dragonshield_cylinder_radius", 180);
	zombie_utility::set_zombie_var("dragonshield_fling_range", 480);
	zombie_utility::set_zombie_var("dragonshield_gib_range", 900);
	zombie_utility::set_zombie_var("dragonshield_gib_damage", 75);
	zombie_utility::set_zombie_var("dragonshield_knockdown_range", 1200);
	zombie_utility::set_zombie_var("dragonshield_knockdown_damage", 15);
	zombie_utility::set_zombie_var("dragonshield_projectile_lifetime", 1.1);
	level.var_d73afd29 = [];
	level.var_d73afd29[level.var_d73afd29.size] = "guts";
	level.var_d73afd29[level.var_d73afd29.size] = "right_arm";
	level.var_d73afd29[level.var_d73afd29.size] = "left_arm";
	level.var_337d1ed2 = &zombie_knockdown;
}

/*
	Name: __main__
	Namespace: namespace_8215525
	Checksum: 0xFF136AA5
	Offset: 0xE48
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	zm_equipment::register_for_level("dragonshield");
	zm_equipment::Include("dragonshield");
	zm_equipment::set_ammo_driven("dragonshield", level.weaponRiotshield.startammo, 1);
	zm_equipment::register_for_level("dragonshield_upgraded");
	zm_equipment::Include("dragonshield_upgraded");
	zm_equipment::set_ammo_driven("dragonshield_upgraded", level.weaponRiotshieldUpgraded.startammo, 1);
	zombie_utility::set_zombie_var("riotshield_fling_damage_shield", 100);
	zombie_utility::set_zombie_var("riotshield_knockdown_damage_shield", 15);
	zombie_utility::set_zombie_var("riotshield_fling_range", 120);
	zombie_utility::set_zombie_var("riotshield_gib_range", 120);
	zombie_utility::set_zombie_var("riotshield_knockdown_range", 120);
	/#
		level thread function_a3a9c2dc();
	#/
}

/*
	Name: on_player_connect
	Namespace: namespace_8215525
	Checksum: 0xD74ED34A
	Offset: 0xFD0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread watchFirstUse();
}

/*
	Name: watchFirstUse
	Namespace: namespace_8215525
	Checksum: 0x2BDD36E6
	Offset: 0xFF8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function watchFirstUse()
{
	self endon("disconnect");
	while(isdefined(self))
	{
		self waittill("weapon_change", newWeapon);
		if(newWeapon.isRiotShield)
		{
			break;
		}
	}
	self notify("hide_equipment_hint_text");
	level flag::set("dragon_shield_used");
	util::wait_network_frame();
	self.rocket_shield_hint_shown = 1;
	zm_equipment::show_hint_text(&"ZOMBIE_DRAGON_SHIELD_HINT", 5);
}

/*
	Name: on_player_spawned
	Namespace: namespace_8215525
	Checksum: 0x5F865FD2
	Offset: 0x10B0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread function_98962bde();
	self thread player_watch_ammo_change();
	self thread player_watch_max_ammo();
	self.player_shield_apply_damage = &function_247d568b;
	self.riotshield_damage_absorb_callback = &riotshield_damage_absorb_callback;
}

/*
	Name: function_98962bde
	Namespace: namespace_8215525
	Checksum: 0xF9520209
	Offset: 0x1138
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_98962bde()
{
	self notify("hash_34db92fa");
	self endon("hash_34db92fa");
	self endon("disconnect");
	while(isdefined(self))
	{
		level waittill("start_of_round");
		if(isdefined(self) && (isdefined(self.hasRiotShield) && self.hasRiotShield))
		{
			self zm_equipment::change_ammo(self.weaponRiotshield, 1);
			self thread check_weapon_ammo(self.weaponRiotshield);
		}
	}
}

/*
	Name: player_watch_ammo_change
	Namespace: namespace_8215525
	Checksum: 0xE1F05A13
	Offset: 0x11E0
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function player_watch_ammo_change()
{
	self notify("player_watch_ammo_change");
	self endon("player_watch_ammo_change");
	for(;;)
	{
		self waittill("equipment_ammo_changed", equipment);
		if(IsString(equipment))
		{
			equipment = GetWeapon(equipment);
		}
		if(equipment == GetWeapon("dragonshield") || equipment == GetWeapon("dragonshield_upgraded"))
		{
			self thread check_weapon_ammo(equipment);
		}
	}
}

/*
	Name: player_watch_max_ammo
	Namespace: namespace_8215525
	Checksum: 0x7819E21A
	Offset: 0x12B0
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function player_watch_max_ammo()
{
	self notify("player_watch_max_ammo");
	self endon("player_watch_max_ammo");
	for(;;)
	{
		self waittill("zmb_max_ammo");
		wait(0.05);
		if(isdefined(self.hasRiotShield) && self.hasRiotShield)
		{
			self thread check_weapon_ammo(self.weaponRiotshield);
		}
	}
}

/*
	Name: check_weapon_ammo
	Namespace: namespace_8215525
	Checksum: 0x7A1738AE
	Offset: 0x1320
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function check_weapon_ammo(weapon)
{
	wait(0.05);
	if(isdefined(self))
	{
		ammo = self GetWeaponAmmoClip(weapon);
		self clientfield::set("ds_ammo", ammo);
	}
}

/*
	Name: should_shield_absorb_damage
	Namespace: namespace_8215525
	Checksum: 0x3F026E8B
	Offset: 0x1390
	Size: 0x149
	Parameters: 10
	Flags: None
*/
function should_shield_absorb_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(self.hasRiotShield) && self.hasRiotShield)
	{
		if(isdefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped && sMeansOfDeath == "MOD_EXPLOSIVE" && isdefined(eAttacker) && (isdefined(eAttacker.is_elemental_zombie) && eAttacker.is_elemental_zombie) && eAttacker.var_9a02a614 === "napalm")
		{
			return 1;
		}
		if(isdefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped && sMeansOfDeath == "MOD_BURNED")
		{
			return 1;
		}
	}
	return riotshield::should_shield_absorb_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

/*
	Name: function_247d568b
	Namespace: namespace_8215525
	Checksum: 0x8B78A4DF
	Offset: 0x14E8
	Size: 0x7B
	Parameters: 4
	Flags: None
*/
function function_247d568b(iDamage, bHeld, fromCode, smod)
{
	if(!isdefined(fromCode))
	{
		fromCode = 0;
	}
	if(!isdefined(smod))
	{
		smod = "MOD_UNKNOWN";
	}
	if(smod != "MOD_BURNED")
	{
		riotshield::player_damage_shield(iDamage, bHeld, fromCode, smod);
	}
}

/*
	Name: riotshield_damage_absorb_callback
	Namespace: namespace_8215525
	Checksum: 0x4798668F
	Offset: 0x1570
	Size: 0x23
	Parameters: 4
	Flags: None
*/
function riotshield_damage_absorb_callback(eAttacker, iDamage, sHitLoc, sMeansOfDeath)
{
}

/*
	Name: function_71d88f26
	Namespace: namespace_8215525
	Checksum: 0x4C466E01
	Offset: 0x15A0
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_71d88f26(weapon)
{
	ammo = self getammocount(weapon);
	disabled = isdefined(self.var_a0a9409e) && self.var_a0a9409e;
	if(ammo > 0 && !disabled)
	{
		self zm_equipment::change_ammo(weapon, -1);
		self thread function_f894ad3e();
		self thread function_d7451ef9(weapon);
		self thread check_weapon_ammo(weapon);
	}
	else
	{
		riotshield::riotshield_melee(weapon);
	}
}

/*
	Name: function_f894ad3e
	Namespace: namespace_8215525
	Checksum: 0x9794B1E0
	Offset: 0x1690
	Size: 0x157
	Parameters: 0
	Flags: None
*/
function function_f894ad3e()
{
	self PlayRumbleOnEntity("zod_shield_juke");
	if(self zm_equipment::get_player_equipment() == GetWeapon("dragonshield"))
	{
		var_e93a0115 = "burninate";
		var_c3937998 = level.var_7ba638ea;
	}
	else
	{
		var_e93a0115 = "burninate_upgraded";
		var_c3937998 = level.var_855a12ba;
	}
	self clientfield::increment(var_e93a0115);
	range = level.zombie_vars["dragonshield_knockdown_range"];
	view_pos = self GetWeaponMuzzlePoint();
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + range * forward_view_angles;
	var_aa911866 = MagicBullet(var_c3937998, view_pos, end_pos, self);
}

/*
	Name: function_c9b3ba45
	Namespace: namespace_8215525
	Checksum: 0x92627D0
	Offset: 0x17F0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_c9b3ba45(e_attacker)
{
	self.marked_for_death = 1;
	if(isdefined(self))
	{
		self DoDamage(self.health + 666, e_attacker.origin, e_attacker);
	}
}

/*
	Name: function_3f5e8a65
	Namespace: namespace_8215525
	Checksum: 0x2970F0F7
	Offset: 0x1850
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_3f5e8a65()
{
	level.var_9e674825++;
	if(!level.var_9e674825 % 10)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}

/*
	Name: function_d7451ef9
	Namespace: namespace_8215525
	Checksum: 0x454D0BC0
	Offset: 0x18A8
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function function_d7451ef9(w_weapon)
{
	PhysicsExplosionCylinder(self.origin, 600, 240, 1);
	if(w_weapon == GetWeapon("dragonshield_upgraded"))
	{
		n_clientfield = 2;
	}
	else
	{
		n_clientfield = 1;
	}
	self thread function_8b8bd269(n_clientfield);
	self notify("hash_10fa975d", w_weapon);
}

/*
	Name: function_8b8bd269
	Namespace: namespace_8215525
	Checksum: 0xD64C0CFB
	Offset: 0x1958
	Size: 0x237
	Parameters: 1
	Flags: None
*/
function function_8b8bd269(n_clientfield)
{
	if(!isdefined(level.var_2f79fc7))
	{
		level.var_2f79fc7 = [];
		level.var_490f6a0d = [];
		level.var_e4a96ed9 = [];
		level.var_1c1b4cce = [];
	}
	self function_459dacdd();
	self.var_3a6322f2 = 0;
	level.var_9e674825 = 0;
	for(i = 0; i < level.var_e4a96ed9.size; i++)
	{
		if(level.var_e4a96ed9[i].archetype === "zombie")
		{
			level.var_e4a96ed9[i] clientfield::set("dragon_strike_zombie_fire", n_clientfield);
		}
		level.var_e4a96ed9[i] thread function_64bd9bf5(self, level.var_1c1b4cce[i], i);
		function_3f5e8a65();
	}
	for(i = 0; i < level.var_2f79fc7.size; i++)
	{
		if(level.var_2f79fc7[i].archetype === "zombie")
		{
			level.var_2f79fc7[i] clientfield::set("dragon_strike_zombie_fire", n_clientfield);
		}
		level.var_2f79fc7[i] thread function_c25e3d4b(self, level.var_490f6a0d[i]);
		function_3f5e8a65();
	}
	self notify("hash_8c80a390", self.var_3a6322f2);
	level.var_2f79fc7 = [];
	level.var_490f6a0d = [];
	level.var_e4a96ed9 = [];
	level.var_1c1b4cce = [];
}

/*
	Name: function_459dacdd
	Namespace: namespace_8215525
	Checksum: 0xC56DC6D3
	Offset: 0x1B98
	Size: 0x975
	Parameters: 0
	Flags: None
*/
function function_459dacdd()
{
	view_pos = self GetWeaponMuzzlePoint();
	zombies = Array::get_all_closest(view_pos, GetAITeamArray(level.zombie_team), undefined, undefined, level.zombie_vars["dragonshield_knockdown_range"]);
	if(!isdefined(zombies))
	{
		return;
	}
	knockdown_range_squared = level.zombie_vars["dragonshield_knockdown_range"] * level.zombie_vars["dragonshield_knockdown_range"];
	gib_range_squared = level.zombie_vars["dragonshield_gib_range"] * level.zombie_vars["dragonshield_gib_range"];
	fling_range_squared = level.zombie_vars["dragonshield_fling_range"] * level.zombie_vars["dragonshield_fling_range"];
	cylinder_radius_squared = level.zombie_vars["dragonshield_cylinder_radius"] * level.zombie_vars["dragonshield_cylinder_radius"];
	var_26ce68e3 = level.zombie_vars["dragonshield_proximity_knockdown_radius"] * level.zombie_vars["dragonshield_proximity_knockdown_radius"];
	var_36f73bb5 = level.zombie_vars["dragonshield_proximity_fling_radius"] * level.zombie_vars["dragonshield_proximity_fling_radius"];
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale(forward_view_angles, level.zombie_vars["dragonshield_knockdown_range"]);
	/#
		if(2 == GetDvarInt("Dev Block strings are not supported"))
		{
			near_circle_pos = view_pos + VectorScale(forward_view_angles, 2);
			circle(near_circle_pos, level.zombie_vars["Dev Block strings are not supported"], (1, 0, 0), 0, 0, 100);
			line(near_circle_pos, end_pos, (0, 0, 1), 1, 0, 100);
			circle(end_pos, level.zombie_vars["Dev Block strings are not supported"], (1, 0, 0), 0, 0, 100);
		}
	#/
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(view_pos, test_origin);
		if(test_range_squared > knockdown_range_squared)
		{
			zombies[i] function_8e9a1613("range", (1, 0, 0));
			return;
		}
		normal = VectorNormalize(test_origin - view_pos);
		dot = VectorDot(forward_view_angles, normal);
		if(test_range_squared < var_36f73bb5)
		{
			level.var_e4a96ed9[level.var_e4a96ed9.size] = zombies[i];
			dist_mult = 1;
			fling_vec = VectorNormalize(test_origin - view_pos);
			fling_vec = (fling_vec[0], fling_vec[1], Abs(fling_vec[2]));
			fling_vec = VectorScale(fling_vec, 50 + 50 * dist_mult);
			level.var_1c1b4cce[level.var_1c1b4cce.size] = fling_vec;
			zombies[i] thread function_41f7c503(self, 1, 0, 0);
			continue;
		}
		else if(test_range_squared < var_26ce68e3 && 0 > dot)
		{
			if(!isdefined(zombies[i].var_e1dbd63))
			{
				zombies[i].var_e1dbd63 = level.var_337d1ed2;
			}
			level.var_2f79fc7[level.var_2f79fc7.size] = zombies[i];
			level.var_490f6a0d[level.var_490f6a0d.size] = 0;
			zombies[i] thread function_41f7c503(self, 0, 0, 1);
			continue;
		}
		if(0 > dot)
		{
			zombies[i] function_8e9a1613("dot", (1, 0, 0));
			continue;
		}
		radial_origin = PointOnSegmentNearestToPoint(view_pos, end_pos, test_origin);
		if(DistanceSquared(test_origin, radial_origin) > cylinder_radius_squared)
		{
			zombies[i] function_8e9a1613("cylinder", (1, 0, 0));
			continue;
		}
		if(0 == zombies[i] damageConeTrace(view_pos, self))
		{
			zombies[i] function_8e9a1613("cone", (1, 0, 0));
			continue;
		}
		var_6ce0bf79 = level.zombie_vars["dragonshield_projectile_lifetime"];
		zombies[i].var_d8486721 = var_6ce0bf79 * sqrt(test_range_squared) / level.zombie_vars["dragonshield_knockdown_range"];
		if(test_range_squared < fling_range_squared)
		{
			level.var_e4a96ed9[level.var_e4a96ed9.size] = zombies[i];
			dist_mult = fling_range_squared - test_range_squared / fling_range_squared;
			fling_vec = VectorNormalize(test_origin - view_pos);
			if(5000 < test_range_squared)
			{
				fling_vec = fling_vec + VectorNormalize(test_origin - radial_origin);
			}
			fling_vec = (fling_vec[0], fling_vec[1], Abs(fling_vec[2]));
			fling_vec = VectorScale(fling_vec, 50 + 50 * dist_mult);
			level.var_1c1b4cce[level.var_1c1b4cce.size] = fling_vec;
			zombies[i] thread function_41f7c503(self, 1, 0, 0);
			continue;
		}
		if(test_range_squared < gib_range_squared)
		{
			if(!isdefined(zombies[i].var_e1dbd63))
			{
				zombies[i].var_e1dbd63 = level.var_337d1ed2;
			}
			level.var_2f79fc7[level.var_2f79fc7.size] = zombies[i];
			level.var_490f6a0d[level.var_490f6a0d.size] = 1;
			zombies[i] thread function_41f7c503(self, 0, 1, 0);
			continue;
		}
		if(!isdefined(zombies[i].var_e1dbd63))
		{
			zombies[i].var_e1dbd63 = level.var_337d1ed2;
		}
		level.var_2f79fc7[level.var_2f79fc7.size] = zombies[i];
		level.var_490f6a0d[level.var_490f6a0d.size] = 0;
		zombies[i] thread function_41f7c503(self, 0, 0, 1);
	}
}

/*
	Name: function_8e9a1613
	Namespace: namespace_8215525
	Checksum: 0x3B641B81
	Offset: 0x2518
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function function_8e9a1613(msg, color)
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + VectorScale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: function_64bd9bf5
	Namespace: namespace_8215525
	Checksum: 0xFECE0A27
	Offset: 0x25B0
	Size: 0x18F
	Parameters: 3
	Flags: None
*/
function function_64bd9bf5(player, fling_vec, index)
{
	delay = self.var_d8486721;
	if(isdefined(delay) && delay > 0.05)
	{
		wait(delay);
	}
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.var_23340a5d))
	{
		self [[self.var_23340a5d]](player);
		return;
	}
	self function_c9b3ba45(player);
	if(self.health <= 0)
	{
		if(!(isdefined(self.no_damage_points) && self.no_damage_points))
		{
			points = 10;
			if(!index)
			{
				points = zm_score::get_zombie_death_player_points();
			}
			else if(1 == index)
			{
				points = 30;
			}
			player zm_score::player_add_points("riotshield_fling", points);
		}
		self StartRagdoll();
		self LaunchRagdoll(fling_vec);
		self.var_5eeaffc8 = 1;
		player.var_3a6322f2++;
	}
}

/*
	Name: zombie_knockdown
	Namespace: namespace_8215525
	Checksum: 0x1434C65
	Offset: 0x2748
	Size: 0x1FF
	Parameters: 2
	Flags: None
*/
function zombie_knockdown(player, gib)
{
	delay = self.var_d8486721;
	if(isdefined(delay) && delay > 0.05)
	{
		wait(delay);
	}
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(!isVehicle(self))
	{
		if(gib && (!isdefined(self.gibbed) && self.gibbed))
		{
			self.a.gib_ref = Array::random(level.var_d73afd29);
			self thread zombie_death::do_gib();
		}
		else
		{
			self zombie_utility::setup_zombie_knockdown(player);
		}
	}
	if(isdefined(level.var_d532d63))
	{
		self [[level.var_d532d63]](player, gib);
	}
	else
	{
		damage = level.zombie_vars["dragonshield_knockdown_damage"];
		self clientfield::increment("dragonshield_snd_zombie_knockdown");
		self.var_2a2a6dce = &function_21b74baa;
		self DoDamage(damage, player.origin, player);
		if(!isVehicle(self))
		{
			self animcustom(&function_2d1a5562);
		}
		if(self.health <= 0)
		{
			player.var_3a6322f2++;
		}
	}
}

/*
	Name: function_2d1a5562
	Namespace: namespace_8215525
	Checksum: 0xDDF66692
	Offset: 0x2950
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function function_2d1a5562()
{
	self notify("hash_21776edb");
	self endon("killanimscript");
	self endon("death");
	self endon("hash_21776edb");
	if(isdefined(self.marked_for_death) && self.marked_for_death)
	{
		return;
	}
	if(self.damageyaw <= -135 || self.damageyaw >= 135)
	{
		if(self.missingLegs)
		{
			fallAnim = "zm_dragonshield_fall_front_crawl";
		}
		else
		{
			fallAnim = "zm_dragonshield_fall_front";
		}
		getupAnim = "zm_dragonshield_getup_belly_early";
	}
	else if(self.damageyaw > -135 && self.damageyaw < -45)
	{
		fallAnim = "zm_dragonshield_fall_left";
		getupAnim = "zm_dragonshield_getup_belly_early";
	}
	else if(self.damageyaw > 45 && self.damageyaw < 135)
	{
		fallAnim = "zm_dragonshield_fall_right";
		getupAnim = "zm_dragonshield_getup_belly_early";
	}
	else
	{
		fallAnim = "zm_dragonshield_fall_back";
		if(RandomInt(100) < 50)
		{
			getupAnim = "zm_dragonshield_getup_back_early";
		}
		else
		{
			getupAnim = "zm_dragonshield_getup_back_late";
		}
	}
	self SetAnimStateFromASD(fallAnim);
	self zombie_shared::DoNoteTracks("dragonshield_fall_anim", self.var_2a2a6dce);
	if(!isdefined(self) || !isalive(self) || self.missingLegs || (isdefined(self.marked_for_death) && self.marked_for_death))
	{
		return;
	}
	self SetAnimStateFromASD(getupAnim);
	self zombie_shared::DoNoteTracks("dragonshield_getup_anim");
}

/*
	Name: function_c25e3d4b
	Namespace: namespace_8215525
	Checksum: 0x70E869A4
	Offset: 0x2B98
	Size: 0x87
	Parameters: 2
	Flags: None
*/
function function_c25e3d4b(player, gib)
{
	self endon("death");
	self clientfield::increment("dragonshield_snd_projectile_impact");
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.var_e1dbd63))
	{
		self [[self.var_e1dbd63]](player, gib);
	}
}

/*
	Name: function_21b74baa
	Namespace: namespace_8215525
	Checksum: 0x9A1EA5BB
	Offset: 0x2C28
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_21b74baa(note)
{
	if(note == "zombie_knockdown_ground_impact")
	{
		playFX(level._effect["dragonshield_knockdown_ground"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
		self clientfield::increment("dragonshield_snd_zombie_knockdown");
	}
}

/*
	Name: function_41f7c503
	Namespace: namespace_8215525
	Checksum: 0x327520DD
	Offset: 0x2CC8
	Size: 0xD3
	Parameters: 4
	Flags: None
*/
function function_41f7c503(player, fling, gib, KNOCKDOWN)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(!fling && (gib || KNOCKDOWN))
	{
	}
	if(fling)
	{
		if(30 > randomIntRange(1, 100))
		{
			player zm_audio::create_and_play_dialog("kill", "rocketshield");
		}
	}
}

/*
	Name: function_a3a9c2dc
	Namespace: namespace_8215525
	Checksum: 0xD4AC19C9
	Offset: 0x2DA8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_a3a9c2dc()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_6f901616);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			AddDebugCommand("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_6f901616
	Namespace: namespace_8215525
	Checksum: 0xFE4FB03F
	Offset: 0x2E80
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function function_6f901616(cmd)
{
	/#
		players = GetPlayers();
		retval = 0;
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &zm_devgui::zombie_devgui_equipment_give, "Dev Block strings are not supported");
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &zm_devgui::zombie_devgui_equipment_give, "Dev Block strings are not supported");
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &function_f685a6db);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &function_eeac5a22);
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: function_2449723c
	Namespace: namespace_8215525
	Checksum: 0x4C8619CA
	Offset: 0x2FD0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_2449723c()
{
	/#
		if(isdefined(self.var_9dc82bca))
		{
			if(self.var_9dc82bca == GetTime())
			{
				return 1;
			}
		}
		self.var_9dc82bca = GetTime();
		return 0;
	#/
}

/*
	Name: function_f685a6db
	Namespace: namespace_8215525
	Checksum: 0x20DE0634
	Offset: 0x3010
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function function_f685a6db()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		self notify("hash_f685a6db");
		self endon("hash_f685a6db");
		level flagsys::wait_till("Dev Block strings are not supported");
		self.var_f685a6db = !isdefined(self.var_f685a6db) && self.var_f685a6db;
		if(self.var_f685a6db)
		{
			while(isdefined(self))
			{
				damageMax = level.weaponRiotshield.weaponstarthitpoints;
				if(isdefined(self.weaponRiotshield))
				{
					damageMax = self.weaponRiotshield.weaponstarthitpoints;
				}
				shieldHealth = self DamageRiotShield(0);
				if(shieldHealth == 0)
				{
					shieldHealth = self DamageRiotShield(damageMax * -1);
				}
				else
				{
					shieldHealth = self DamageRiotShield(Int(damageMax / 10));
				}
				wait(0.5);
			}
		}
	#/
}

/*
	Name: function_eeac5a22
	Namespace: namespace_8215525
	Checksum: 0x637E728C
	Offset: 0x3170
	Size: 0xE5
	Parameters: 0
	Flags: None
*/
function function_eeac5a22()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		self notify("hash_eeac5a22");
		self endon("hash_eeac5a22");
		level flagsys::wait_till("Dev Block strings are not supported");
		self.var_eeac5a22 = !isdefined(self.var_eeac5a22) && self.var_eeac5a22;
		if(self.var_eeac5a22)
		{
			while(isdefined(self))
			{
				if(isdefined(self.hasRiotShield) && self.hasRiotShield)
				{
					self zm_equipment::change_ammo(self.weaponRiotshield, 1);
					self thread check_weapon_ammo(self.weaponRiotshield);
				}
				wait(1);
			}
		}
	#/
}

