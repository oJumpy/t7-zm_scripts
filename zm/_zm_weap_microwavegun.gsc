#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_1a0051d2;

/*
	Name: __init__sytem__
	Namespace: namespace_1a0051d2
	Checksum: 0x85F96191
	Offset: 0x650
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_microwavegun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1a0051d2
	Checksum: 0x908C6F5
	Offset: 0x690
	Size: 0x303
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "toggle_microwavegun_hit_response", 21000, 1, "int");
	clientfield::register("actor", "toggle_microwavegun_expand_response", 21000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadLeft_WaveGun", 21000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.dpadLeftAmmo", 21000, 5, "int");
	zm_spawner::register_zombie_damage_callback(&microwavegun_zombie_damage_response);
	zm_spawner::register_zombie_death_animscript_callback(&microwavegun_zombie_death_response);
	zombie_utility::set_zombie_var("microwavegun_cylinder_radius", 180);
	zombie_utility::set_zombie_var("microwavegun_sizzle_range", 480);
	level._effect["microwavegun_zap_shock_dw"] = "dlc5/zmb_weapon/fx_zap_shock_dw";
	level._effect["microwavegun_zap_shock_eyes_dw"] = "dlc5/zmb_weapon/fx_zap_shock_eyes_dw";
	level._effect["microwavegun_zap_shock_lh"] = "dlc5/zmb_weapon/fx_zap_shock_lh";
	level._effect["microwavegun_zap_shock_eyes_lh"] = "dlc5/zmb_weapon/fx_zap_shock_eyes_lh";
	level._effect["microwavegun_zap_shock_ug"] = "dlc5/zmb_weapon/fx_zap_shock_ug";
	level._effect["microwavegun_zap_shock_eyes_ug"] = "dlc5/zmb_weapon/fx_zap_shock_eyes_ug";
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("expand", &function_5c6b11a6);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("explode", &function_f8d8850f);
	level thread microwavegun_on_player_connect();
	level._microwaveable_objects = [];
	level.var_12fcda98 = GetWeapon("microwavegun");
	level.var_6ae86bb = GetWeapon("microwavegun_upgraded");
	level.var_9c43352b = GetWeapon("microwavegundw");
	level.var_5736548e = GetWeapon("microwavegundw_upgraded");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: namespace_1a0051d2
	Checksum: 0xC3E82734
	Offset: 0x9A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread function_8f95fde5();
}

/*
	Name: function_8f95fde5
	Namespace: namespace_1a0051d2
	Checksum: 0x6A5FFFE7
	Offset: 0x9C8
	Size: 0x15D
	Parameters: 0
	Flags: None
*/
function function_8f95fde5()
{
	self notify("hash_8f95fde5");
	self endon("hash_8f95fde5");
	self endon("disconnect");
	while(1)
	{
		self waittill("weapon_give", weapon);
		weapon = zm_weapons::get_nonalternate_weapon(weapon);
		if(weapon == level.var_9c43352b || weapon == level.var_5736548e)
		{
			self clientfield::set_player_uimodel("hudItems.showDpadLeft_WaveGun", 1);
			self.var_59dcbbd4 = zm_weapons::is_weapon_upgraded(weapon);
			self thread function_1402f75f();
		}
		else if(!self zm_weapons::has_weapon_or_upgrade(level.var_9c43352b))
		{
			self clientfield::set_player_uimodel("hudItems.showDpadLeft_WaveGun", 0);
			self clientfield::set_player_uimodel("hudItems.dpadLeftAmmo", 0);
			self notify("hash_e3517683");
			self.var_59dcbbd4 = undefined;
		}
	}
}

/*
	Name: function_1402f75f
	Namespace: namespace_1a0051d2
	Checksum: 0xC0A7A079
	Offset: 0xB30
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function function_1402f75f()
{
	self notify("hash_1402f75f");
	self endon("hash_1402f75f");
	self endon("hash_e3517683");
	self endon("disconnect");
	self.var_db2418ce = 1;
	while(1)
	{
		if(isdefined(self.var_59dcbbd4))
		{
			if(self.var_59dcbbd4)
			{
				ammoCount = self getammocount(level.var_6ae86bb);
			}
			else
			{
				ammoCount = self getammocount(level.var_12fcda98);
			}
			self clientfield::set_player_uimodel("hudItems.dpadLeftAmmo", ammoCount);
		}
		else
		{
			self clientfield::set_player_uimodel("hudItems.dpadLeftAmmo", 0);
		}
		wait(0.05);
	}
}

/*
	Name: add_microwaveable_object
	Namespace: namespace_1a0051d2
	Checksum: 0xB021D907
	Offset: 0xC38
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function add_microwaveable_object(ent)
{
	Array::add(level._microwaveable_objects, ent, 0);
}

/*
	Name: remove_microwaveable_object
	Namespace: namespace_1a0051d2
	Checksum: 0xBF5EB938
	Offset: 0xC70
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function remove_microwaveable_object(ent)
{
	ArrayRemoveValue(level._microwaveable_objects, ent);
}

/*
	Name: microwavegun_on_player_connect
	Namespace: namespace_1a0051d2
	Checksum: 0xA4222416
	Offset: 0xCA8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function microwavegun_on_player_connect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread wait_for_microwavegun_fired();
	}
}

/*
	Name: wait_for_microwavegun_fired
	Namespace: namespace_1a0051d2
	Checksum: 0x3BF57649
	Offset: 0xCE8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function wait_for_microwavegun_fired()
{
	self endon("disconnect");
	self waittill("spawned_player");
	for(;;)
	{
		self waittill("weapon_fired");
		currentWeapon = self GetCurrentWeapon();
		if(currentWeapon == level.var_12fcda98 || currentWeapon == level.var_6ae86bb)
		{
			self thread microwavegun_fired(currentWeapon == level.var_6ae86bb);
		}
	}
}

/*
	Name: microwavegun_network_choke
	Namespace: namespace_1a0051d2
	Checksum: 0x7C31E53D
	Offset: 0xD80
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function microwavegun_network_choke()
{
	level.microwavegun_network_choke_count++;
	if(!level.microwavegun_network_choke_count % 10)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}

/*
	Name: microwavegun_fired
	Namespace: namespace_1a0051d2
	Checksum: 0x7368DE20
	Offset: 0xDD8
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function microwavegun_fired(upgraded)
{
	if(!isdefined(level.microwavegun_sizzle_enemies))
	{
		level.microwavegun_sizzle_enemies = [];
		level.microwavegun_sizzle_vecs = [];
	}
	self microwavegun_get_enemies_in_range(upgraded, 0);
	self microwavegun_get_enemies_in_range(upgraded, 1);
	level.microwavegun_network_choke_count = 0;
	for(i = 0; i < level.microwavegun_sizzle_enemies.size; i++)
	{
		microwavegun_network_choke();
		level.microwavegun_sizzle_enemies[i] thread microwavegun_sizzle_zombie(self, level.microwavegun_sizzle_vecs[i], i);
	}
	level.microwavegun_sizzle_enemies = [];
	level.microwavegun_sizzle_vecs = [];
}

/*
	Name: microwavegun_get_enemies_in_range
	Namespace: namespace_1a0051d2
	Checksum: 0x2F821297
	Offset: 0xEE8
	Size: 0x5D3
	Parameters: 2
	Flags: None
*/
function microwavegun_get_enemies_in_range(upgraded, microwaveable_objects)
{
	view_pos = self GetWeaponMuzzlePoint();
	test_list = [];
	range = level.zombie_vars["microwavegun_sizzle_range"];
	cylinder_radius = level.zombie_vars["microwavegun_cylinder_radius"];
	if(microwaveable_objects)
	{
		test_list = level._microwaveable_objects;
		range = range * 10;
		cylinder_radius = cylinder_radius * 10;
	}
	else
	{
		test_list = zombie_utility::get_round_enemy_array();
	}
	zombies = util::get_array_of_closest(view_pos, test_list, undefined, undefined, range);
	if(!isdefined(zombies))
	{
		return;
	}
	sizzle_range_squared = range * range;
	cylinder_radius_squared = cylinder_radius * cylinder_radius;
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale(forward_view_angles, range);
	/#
		if(2 == GetDvarInt("Dev Block strings are not supported"))
		{
			near_circle_pos = view_pos + VectorScale(forward_view_angles, 2);
			circle(near_circle_pos, cylinder_radius, (1, 0, 0), 0, 0, 100);
			line(near_circle_pos, end_pos, (0, 0, 1), 1, 0, 100);
			circle(end_pos, cylinder_radius, (1, 0, 0), 0, 0, 100);
		}
	#/
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || (isai(zombies[i]) && !isalive(zombies[i])))
		{
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(view_pos, test_origin);
		if(test_range_squared > sizzle_range_squared)
		{
			zombies[i] microwavegun_debug_print("range", (1, 0, 0));
			return;
		}
		normal = VectorNormalize(test_origin - view_pos);
		dot = VectorDot(forward_view_angles, normal);
		if(0 > dot)
		{
			zombies[i] microwavegun_debug_print("dot", (1, 0, 0));
			continue;
		}
		radial_origin = PointOnSegmentNearestToPoint(view_pos, end_pos, test_origin);
		if(DistanceSquared(test_origin, radial_origin) > cylinder_radius_squared)
		{
			zombies[i] microwavegun_debug_print("cylinder", (1, 0, 0));
			continue;
		}
		if(0 == zombies[i] damageConeTrace(view_pos, self))
		{
			zombies[i] microwavegun_debug_print("cone", (1, 0, 0));
			continue;
		}
		if(isai(zombies[i]))
		{
			level.microwavegun_sizzle_enemies[level.microwavegun_sizzle_enemies.size] = zombies[i];
			dist_mult = sizzle_range_squared - test_range_squared / sizzle_range_squared;
			sizzle_vec = VectorNormalize(test_origin - view_pos);
			if(5000 < test_range_squared)
			{
				sizzle_vec = sizzle_vec + VectorNormalize(test_origin - radial_origin);
			}
			sizzle_vec = (sizzle_vec[0], sizzle_vec[1], Abs(sizzle_vec[2]));
			sizzle_vec = VectorScale(sizzle_vec, 100 + 100 * dist_mult);
			level.microwavegun_sizzle_vecs[level.microwavegun_sizzle_vecs.size] = sizzle_vec;
			continue;
		}
		zombies[i] notify("microwaved", self);
	}
}

/*
	Name: microwavegun_debug_print
	Namespace: namespace_1a0051d2
	Checksum: 0xBD766163
	Offset: 0x14C8
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function microwavegun_debug_print(msg, color)
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
	Name: microwavegun_sizzle_zombie
	Namespace: namespace_1a0051d2
	Checksum: 0x83D8D031
	Offset: 0x1560
	Size: 0x2B3
	Parameters: 3
	Flags: None
*/
function microwavegun_sizzle_zombie(player, sizzle_vec, index)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.microwavegun_sizzle_func))
	{
		self [[self.microwavegun_sizzle_func]](player);
		return;
	}
	self.no_gib = 1;
	self.gibbed = 1;
	self.skipAutoRagdoll = 1;
	self.microwavegun_death = 1;
	self DoDamage(self.health + 666, player.origin, player);
	if(self.health <= 0)
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
		player zm_score::player_add_points("thundergun_fling", points);
		instant_explode = 0;
		if(self.isdog)
		{
			self.a.nodeath = undefined;
			instant_explode = 1;
		}
		if(isdefined(self.is_traversing) && self.is_traversing || (isdefined(self.in_the_ceiling) && self.in_the_ceiling))
		{
			self.deathAnim = undefined;
			instant_explode = 1;
		}
		if(instant_explode)
		{
			if(isdefined(self.animName) && self.animName != "astro_zombie")
			{
				self thread setup_microwavegun_vox(player);
			}
			self clientfield::set("toggle_microwavegun_expand_response", 1);
			self thread microwavegun_sizzle_death_ending();
		}
		else if(isdefined(self.animName) && self.animName != "astro_zombie")
		{
			self thread setup_microwavegun_vox(player, 6);
		}
		self clientfield::set("toggle_microwavegun_hit_response", 1);
		self.nodeathragdoll = 1;
		self.handle_death_notetracks = &microwavegun_handle_death_notetracks;
	}
}

/*
	Name: microwavegun_handle_death_notetracks
	Namespace: namespace_1a0051d2
	Checksum: 0x6B8CC7FB
	Offset: 0x1820
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function microwavegun_handle_death_notetracks(note)
{
	if(note == "expand")
	{
		self clientfield::set("toggle_microwavegun_expand_response", 1);
	}
	else if(note == "explode")
	{
		self clientfield::set("toggle_microwavegun_expand_response", 0);
		self thread microwavegun_sizzle_death_ending();
	}
}

/*
	Name: microwavegun_sizzle_death_ending
	Namespace: namespace_1a0051d2
	Checksum: 0x5F0D0FE8
	Offset: 0x18B0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function microwavegun_sizzle_death_ending()
{
	if(!isdefined(self))
	{
		return;
	}
	self ghost();
	wait(0.1);
	self zm_utility::self_delete();
}

/*
	Name: microwavegun_dw_zombie_hit_response_internal
	Namespace: namespace_1a0051d2
	Checksum: 0xE1161BE3
	Offset: 0x1900
	Size: 0x183
	Parameters: 3
	Flags: None
*/
function microwavegun_dw_zombie_hit_response_internal(mod, damageWeapon, player)
{
	player endon("disconnect");
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(self.isdog)
	{
		self.a.nodeath = undefined;
	}
	if(isdefined(self.is_traversing) && self.is_traversing)
	{
		self.deathAnim = undefined;
	}
	self.skipAutoRagdoll = 1;
	self.microwavegun_dw_death = 1;
	self thread microwavegun_zap_death_fx(damageWeapon);
	if(isdefined(self.microwavegun_zap_damage_func))
	{
		self [[self.microwavegun_zap_damage_func]](player);
		return;
	}
	else
	{
		self DoDamage(self.health + 666, self.origin, player);
	}
	player zm_score::player_add_points("death", "", "");
	if(randomIntRange(0, 101) >= 75)
	{
		player thread zm_audio::create_and_play_dialog("kill", "micro_dual");
	}
}

/*
	Name: microwavegun_zap_get_shock_fx
	Namespace: namespace_1a0051d2
	Checksum: 0xE3157613
	Offset: 0x1A90
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function microwavegun_zap_get_shock_fx(weapon)
{
	if(weapon == GetWeapon("microwavegundw"))
	{
		return level._effect["microwavegun_zap_shock_dw"];
	}
	else if(weapon == GetWeapon("microwavegunlh"))
	{
		return level._effect["microwavegun_zap_shock_lh"];
	}
	else
	{
		return level._effect["microwavegun_zap_shock_ug"];
	}
}

/*
	Name: microwavegun_zap_get_shock_eyes_fx
	Namespace: namespace_1a0051d2
	Checksum: 0xC9AE30FF
	Offset: 0x1B30
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function microwavegun_zap_get_shock_eyes_fx(weapon)
{
	if(weapon == GetWeapon("microwavegundw"))
	{
		return level._effect["microwavegun_zap_shock_eyes_dw"];
	}
	else if(weapon == GetWeapon("microwavegunlh"))
	{
		return level._effect["microwavegun_zap_shock_eyes_lh"];
	}
	else
	{
		return level._effect["microwavegun_zap_shock_eyes_ug"];
	}
}

/*
	Name: microwavegun_zap_head_gib
	Namespace: namespace_1a0051d2
	Checksum: 0x3D5487C7
	Offset: 0x1BD0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function microwavegun_zap_head_gib(weapon)
{
	self endon("death");
	zm_net::network_safe_play_fx_on_tag("microwavegun_zap_death_fx", 2, microwavegun_zap_get_shock_eyes_fx(weapon), self, "J_Eyeball_LE");
}

/*
	Name: microwavegun_zap_death_fx
	Namespace: namespace_1a0051d2
	Checksum: 0xACD041FA
	Offset: 0x1C28
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function microwavegun_zap_death_fx(weapon)
{
	tag = "J_SpineUpper";
	if(self.isdog)
	{
		tag = "J_Spine1";
	}
	zm_net::network_safe_play_fx_on_tag("microwavegun_zap_death_fx", 2, microwavegun_zap_get_shock_fx(weapon), self, tag);
	self playsound("wpn_imp_tesla");
	if(isdefined(self.head_gibbed) && self.head_gibbed)
	{
		return;
	}
	if(isdefined(self.microwavegun_zap_head_gib_func))
	{
		self thread [[self.microwavegun_zap_head_gib_func]](weapon);
	}
	else if("quad_zombie" != self.animName)
	{
		self thread microwavegun_zap_head_gib(weapon);
	}
}

/*
	Name: microwavegun_zombie_damage_response
	Namespace: namespace_1a0051d2
	Checksum: 0x6B7E186
	Offset: 0x1D28
	Size: 0xB3
	Parameters: 13
	Flags: None
*/
function microwavegun_zombie_damage_response(str_mod, str_hit_location, v_hit_origin, e_attacker, n_amount, w_weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(self is_microwavegun_dw_damage())
	{
		self thread microwavegun_dw_zombie_hit_response_internal(str_mod, self.damageWeapon, e_attacker);
		return 1;
	}
	return 0;
}

/*
	Name: microwavegun_zombie_death_response
	Namespace: namespace_1a0051d2
	Checksum: 0x88726FCA
	Offset: 0x1DE8
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function microwavegun_zombie_death_response()
{
	if(self enemy_killed_by_dw_microwavegun())
	{
		if(isdefined(self.attacker) && isdefined(level.hero_power_update))
		{
			level thread [[level.hero_power_update]](self.attacker, self);
		}
		return 1;
	}
	else if(self enemy_killed_by_microwavegun())
	{
		if(isdefined(self.attacker) && isdefined(level.hero_power_update))
		{
			level thread [[level.hero_power_update]](self.attacker, self);
		}
		return 1;
	}
	return 0;
}

/*
	Name: is_microwavegun_dw_damage
	Namespace: namespace_1a0051d2
	Checksum: 0x853F8321
	Offset: 0x1E98
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function is_microwavegun_dw_damage()
{
	return isdefined(self.damageWeapon) && (self.damageWeapon == GetWeapon("microwavegundw") || self.damageWeapon == GetWeapon("microwavegundw_upgraded") || self.damageWeapon == GetWeapon("microwavegunlh") || self.damageWeapon == GetWeapon("microwavegunlh_upgraded")) && self.damageMod == "MOD_IMPACT";
}

/*
	Name: enemy_killed_by_dw_microwavegun
	Namespace: namespace_1a0051d2
	Checksum: 0xA7AC0D97
	Offset: 0x1F40
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function enemy_killed_by_dw_microwavegun()
{
	return isdefined(self.microwavegun_dw_death) && self.microwavegun_dw_death;
}

/*
	Name: is_microwavegun_damage
	Namespace: namespace_1a0051d2
	Checksum: 0xF1972CEE
	Offset: 0x1F60
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function is_microwavegun_damage()
{
	return isdefined(self.damageWeapon) && (self.damageWeapon == level.var_12fcda98 || self.damageWeapon == level.var_6ae86bb) && (self.damageMod != "MOD_GRENADE" && self.damageMod != "MOD_GRENADE_SPLASH");
}

/*
	Name: enemy_killed_by_microwavegun
	Namespace: namespace_1a0051d2
	Checksum: 0x5124E6F8
	Offset: 0x1FC8
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function enemy_killed_by_microwavegun()
{
	return isdefined(self.microwavegun_death) && self.microwavegun_death;
}

/*
	Name: microwavegun_sound_thread
	Namespace: namespace_1a0051d2
	Checksum: 0xBC2B4748
	Offset: 0x1FE8
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function microwavegun_sound_thread()
{
	self endon("disconnect");
	self waittill("spawned_player");
	for(;;)
	{
		result = self util::waittill_any_return("grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback");
		if(!isdefined(result))
		{
			continue;
		}
		if(result == "weapon_change" || result == "grenade_fire" && self GetCurrentWeapon() == level.var_12fcda98)
		{
			self PlayLoopSound("tesla_idle", 0.25);
			continue;
		}
		self notify("weap_away");
		self StopLoopSound(0.25);
	}
}

/*
	Name: setup_microwavegun_vox
	Namespace: namespace_1a0051d2
	Checksum: 0x83826AE9
	Offset: 0x2100
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function setup_microwavegun_vox(player, waitTime)
{
	level notify("force_end_microwave_vox");
	level endon("force_end_microwave_vox");
	if(!isdefined(waitTime))
	{
		waitTime = 0.05;
	}
	wait(waitTime);
	if(50 > randomIntRange(1, 100) && isdefined(player))
	{
		player thread zm_audio::create_and_play_dialog("kill", "micro_single");
	}
}

/*
	Name: function_5c6b11a6
	Namespace: namespace_1a0051d2
	Checksum: 0xBA4713C1
	Offset: 0x21A8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_5c6b11a6(entity)
{
	self clientfield::set("toggle_microwavegun_expand_response", 1);
}

/*
	Name: function_f8d8850f
	Namespace: namespace_1a0051d2
	Checksum: 0xBCF33DC7
	Offset: 0x21E0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_f8d8850f(entity)
{
	self clientfield::set("toggle_microwavegun_expand_response", 0);
	self thread microwavegun_sizzle_death_ending();
}

