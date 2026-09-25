#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weapons;

#namespace namespace_2d73d751;

/*
	Name: __init__sytem__
	Namespace: namespace_2d73d751
	Checksum: 0xD8499016
	Offset: 0x580
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_rune_prison", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_2d73d751
	Checksum: 0xB1D54156
	Offset: 0x5C8
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_fb620116 = GetWeapon("elemental_bow_rune_prison");
	level.var_791ba87b = GetWeapon("elemental_bow_rune_prison4");
	clientfield::register("toplayer", "elemental_bow_rune_prison" + "_ambient_bow_fx", 5000, 1, "int");
	clientfield::register("missile", "elemental_bow_rune_prison" + "_arrow_impact_fx", 5000, 1, "int");
	clientfield::register("missile", "elemental_bow_rune_prison4" + "_arrow_impact_fx", 5000, 1, "int");
	clientfield::register("scriptmover", "runeprison_rock_fx", 5000, 1, "int");
	clientfield::register("scriptmover", "runeprison_explode_fx", 5000, 1, "int");
	clientfield::register("scriptmover", "runeprison_lava_geyser_fx", 5000, 1, "int");
	clientfield::register("actor", "runeprison_lava_geyser_dot_fx", 5000, 1, "int");
	clientfield::register("actor", "runeprison_zombie_charring", 5000, 1, "int");
	clientfield::register("actor", "runeprison_zombie_death_skull", 5000, 1, "int");
	callback::on_connect(&function_4d344d97);
}

/*
	Name: __main__
	Namespace: namespace_2d73d751
	Checksum: 0x99EC1590
	Offset: 0x800
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: function_4d344d97
	Namespace: namespace_2d73d751
	Checksum: 0x32A563FB
	Offset: 0x810
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_4d344d97()
{
	self thread zm_weap_elemental_bow::function_982419bb("elemental_bow_rune_prison");
	self thread zm_weap_elemental_bow::function_ececa597("elemental_bow_rune_prison", "elemental_bow_rune_prison4");
	self thread zm_weap_elemental_bow::function_7bc6b9d("elemental_bow_rune_prison", "elemental_bow_rune_prison4", &function_c8b11b89);
}

/*
	Name: function_c8b11b89
	Namespace: namespace_2d73d751
	Checksum: 0x9726569D
	Offset: 0x898
	Size: 0xB3
	Parameters: 5
	Flags: None
*/
function function_c8b11b89(weapon, position, radius, attacker, normal)
{
	if(IsSubStr(weapon.name, "elemental_bow_rune_prison4"))
	{
		level thread function_94ba3a15(self, position, weapon.name, attacker, 1, 0);
	}
	else
	{
		level thread function_48899f7(self, position, weapon.name, attacker);
	}
}

/*
	Name: function_94ba3a15
	Namespace: namespace_2d73d751
	Checksum: 0xC35E50AC
	Offset: 0x958
	Size: 0x8B3
	Parameters: 6
	Flags: None
*/
function function_94ba3a15(e_player, v_hit_origin, str_weapon_name, var_3fee16b8, var_df033097, var_8b30ffd9)
{
	if(var_df033097)
	{
		e_player.var_d96b65c1 = &function_1ed3d96d;
		v_spawn_pos = e_player zm_weap_elemental_bow::function_866906f(v_hit_origin, str_weapon_name, var_3fee16b8, 48, e_player.var_d96b65c1);
		if(var_df033097)
		{
			if(isdefined(v_spawn_pos))
			{
			}
			else
			{
			}
			var_289e02fc = v_hit_origin;
			var_852420bf = Array::get_all_closest(var_289e02fc, GetAITeamArray(level.zombie_team), undefined, undefined, 256);
			var_852420bf = Array::filter(var_852420bf, 0, &zm_weap_elemental_bow::function_5aec3adc);
			var_852420bf = Array::filter(var_852420bf, 0, &function_71c4b12e, var_289e02fc);
			if(GetDvarInt("splitscreen_playerCount") > 2)
			{
				var_852420bf = Array::clamp_size(var_852420bf, 6);
			}
			else
			{
				var_852420bf = Array::clamp_size(var_852420bf, 12);
			}
			foreach(ai_enemy in var_852420bf)
			{
				ai_enemy thread function_94ba3a15(e_player, v_hit_origin, str_weapon_name, var_3fee16b8, 0, n_index);
			}
			if(var_852420bf.size)
			{
				return;
			}
		}
	}
	else
	{
		v_spawn_pos = function_46a00a8e(self);
	}
	if(!isdefined(v_spawn_pos))
	{
		/#
			IPrintLnBold("Dev Block strings are not supported");
		#/
		return;
	}
	if(isdefined(v_spawn_pos))
	{
		var_c8bd3127 = util::spawn_model("tag_origin", v_spawn_pos, (0, randomIntRange(0, 360), 0));
		if(isai(self) && isalive(self))
		{
			self.var_a320d911 = 1;
			self.var_98056717 = 1;
			self LinkTo(var_c8bd3127);
			self SetPlayerCollision(0);
			self thread function_5c74632();
		}
	}
	var_c8bd3127 clientfield::set("runeprison_rock_fx", 1);
	self thread function_378db90d(v_spawn_pos);
	if(isdefined(self) && isalive(self))
	{
		if(isdefined(self.isdog) && self.isdog || (isdefined(self.missingLegs) && self.missingLegs))
		{
			self DoDamage(self.health, var_c8bd3127.origin, e_player, e_player, undefined, "MOD_BURNED", 0, level.var_791ba87b);
		}
	}
	wait(1.8 + 0.07 * var_8b30ffd9);
	var_c8bd3127 clientfield::set("runeprison_explode_fx", 1);
	if(isdefined(self) && isalive(self) && self.archetype === "zombie")
	{
		self notify("hash_9d9f16be", v_spawn_pos);
		self clientfield::set("runeprison_zombie_charring", 1);
	}
	wait(2);
	if(isdefined(self) && isai(self) && isalive(self))
	{
		if(self.archetype === "mechz")
		{
			var_3bb42832 = level.mechz_health;
			if(isdefined(level.var_f4dc2834))
			{
				var_3bb42832 = math::clamp(var_3bb42832, 0, level.var_f4dc2834);
			}
			var_40955aed = var_3bb42832 * 0.2 / 0.2;
			self.var_a320d911 = 0;
			self.var_98056717 = 0;
			self scene::stop("ai_zm_dlc1_soldat_runeprison_struggle_loop");
			self DoDamage(var_40955aed, var_c8bd3127.origin, e_player, e_player, undefined, "MOD_PROJECTILE_SPLASH", 0, level.var_791ba87b);
			self thread function_62837b3a();
		}
		else if(self.archetype === "zombie")
		{
			if(math::cointoss())
			{
				GibServerUtils::GibHead(self);
				self clientfield::set("runeprison_zombie_death_skull", 1);
			}
			self DoDamage(self.health, var_c8bd3127.origin, e_player, e_player, undefined, "MOD_BURNED", 0, level.var_791ba87b);
		}
		self SetPlayerCollision(1);
		self Unlink();
	}
	var_852420bf = Array::get_all_closest(var_c8bd3127.origin, GetAITeamArray(level.zombie_team), undefined, undefined, 96);
	var_852420bf = Array::filter(var_852420bf, 0, &zm_weap_elemental_bow::function_5aec3adc);
	var_852420bf = Array::filter(var_852420bf, 0, &function_e381ab3a);
	foreach(var_b4aadf6b in var_852420bf)
	{
		var_b4aadf6b DoDamage(var_b4aadf6b.health, var_c8bd3127.origin, e_player, e_player, undefined, "MOD_BURNED", 0, level.var_791ba87b);
	}
	var_c8bd3127 clientfield::set("runeprison_rock_fx", 0);
	wait(6);
	var_c8bd3127 delete();
}

/*
	Name: function_378db90d
	Namespace: namespace_2d73d751
	Checksum: 0xBF9E88A6
	Offset: 0x1218
	Size: 0x159
	Parameters: 1
	Flags: None
*/
function function_378db90d(v_pos)
{
	wait(0.1);
	var_852420bf = Array::get_all_closest(v_pos, GetAITeamArray(level.zombie_team), undefined, undefined, 96);
	var_852420bf = Array::filter(var_852420bf, 0, &zm_weap_elemental_bow::function_5aec3adc);
	var_852420bf = Array::filter(var_852420bf, 0, &function_cece5ffb);
	var_852420bf = Array::clamp_size(var_852420bf, 2);
	foreach(var_b4aadf6b in var_852420bf)
	{
		var_b4aadf6b thread zm_weap_elemental_bow::function_d1e69389(v_pos);
	}
}

/*
	Name: function_62837b3a
	Namespace: namespace_2d73d751
	Checksum: 0xE7A48D4F
	Offset: 0x1380
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_62837b3a()
{
	self endon("death");
	self.var_d3c478a0 = 1;
	wait(16);
	self.var_d3c478a0 = 0;
}

/*
	Name: function_71c4b12e
	Namespace: namespace_2d73d751
	Checksum: 0x7EA1A1B9
	Offset: 0x13B8
	Size: 0xA9
	Parameters: 2
	Flags: None
*/
function function_71c4b12e(ai_enemy, var_289e02fc)
{
	return !isdefined(ai_enemy.var_a320d911) && ai_enemy.var_a320d911 && (BulletTracePassed(ai_enemy GetCentroid(), var_289e02fc, 0, undefined) || BulletTracePassed(ai_enemy GetCentroid(), var_289e02fc + VectorScale((0, 0, 1), 48), 0, undefined));
}

/*
	Name: function_cece5ffb
	Namespace: namespace_2d73d751
	Checksum: 0x5C3FBD6A
	Offset: 0x1470
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_cece5ffb(ai_enemy)
{
	return !isdefined(ai_enemy.var_a320d911) && ai_enemy.var_a320d911 && (!isdefined(ai_enemy.KNOCKDOWN) && ai_enemy.KNOCKDOWN) && (!isdefined(ai_enemy.missingLegs) && ai_enemy.missingLegs);
}

/*
	Name: function_e381ab3a
	Namespace: namespace_2d73d751
	Checksum: 0x56896156
	Offset: 0x14F8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_e381ab3a(ai_enemy)
{
	return !isdefined(ai_enemy.var_a320d911) && ai_enemy.var_a320d911;
}

/*
	Name: function_5c74632
	Namespace: namespace_2d73d751
	Checksum: 0xCF2A4F25
	Offset: 0x1530
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_5c74632()
{
	self endon("death");
	wait(0.1);
	if(self.archetype === "zombie")
	{
		var_5606e343 = randomIntRange(1, 5);
		self thread scene::Play("ai_zm_dlc1_zombie_runeprison_locked_struggle_0" + var_5606e343, self);
		self waittill("hash_9d9f16be");
		wait(0.5);
		self scene::Play("ai_zm_dlc1_zombie_runeprison_death_loop_0" + randomIntRange(1, 5), self);
	}
	else if(self.archetype === "mechz")
	{
		self scene::Play("ai_zm_dlc1_soldat_runeprison_struggle_loop", self);
	}
}

/*
	Name: function_48899f7
	Namespace: namespace_2d73d751
	Checksum: 0x14517AA7
	Offset: 0x1630
	Size: 0x1F3
	Parameters: 4
	Flags: None
*/
function function_48899f7(e_player, v_hit_origin, str_weapon_name, var_3fee16b8)
{
	v_spawn_pos = e_player zm_weap_elemental_bow::function_866906f(v_hit_origin, str_weapon_name, var_3fee16b8, 32);
	if(!isdefined(v_spawn_pos))
	{
		return;
	}
	var_3c817f0d = util::spawn_model("tag_origin", v_spawn_pos);
	var_3c817f0d clientfield::set("runeprison_lava_geyser_fx", 1);
	n_timer = 0;
	var_4275176f = [];
	while(n_timer < 3)
	{
		var_852420bf = Array::get_all_closest(var_3c817f0d.origin, GetAITeamArray(level.zombie_team), undefined, undefined, 48);
		var_852420bf = Array::filter(var_852420bf, 0, &zm_weap_elemental_bow::function_5aec3adc);
		var_852420bf = Array::filter(var_852420bf, 0, &function_6a1a0b32, var_3c817f0d);
		Array::thread_all(var_852420bf, &function_e7abbbb8, var_3c817f0d, e_player);
		wait(0.05);
		n_timer = n_timer + 0.05;
	}
	wait(6);
	var_3c817f0d delete();
}

/*
	Name: function_6a1a0b32
	Namespace: namespace_2d73d751
	Checksum: 0x98CA8260
	Offset: 0x1830
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function function_6a1a0b32(ai_enemy, var_3c817f0d)
{
	return !isdefined(ai_enemy.var_ca25d40c) && ai_enemy.var_ca25d40c;
}

/*
	Name: function_e7abbbb8
	Namespace: namespace_2d73d751
	Checksum: 0xE323869C
	Offset: 0x1870
	Size: 0x25F
	Parameters: 2
	Flags: None
*/
function function_e7abbbb8(var_3c817f0d, e_player)
{
	self endon("death");
	self.var_ca25d40c = 1;
	n_timer = 0;
	if(self.archetype === "mechz")
	{
		var_3bb42832 = level.mechz_health;
		if(isdefined(level.var_f4dc2834))
		{
			var_3bb42832 = math::clamp(var_3bb42832, 0, level.var_f4dc2834);
		}
		N_MAX_DAMAGE = var_3bb42832 * 0.05 / 0.2;
		str_mod = "MOD_PROJECTILE_SPLASH";
	}
	else if(level.zombie_health > 2482)
	{
	}
	else
	{
	}
	N_MAX_DAMAGE = level.zombie_health;
	str_mod = "MOD_UNKNOWN";
	self clientfield::set("runeprison_lava_geyser_dot_fx", 1);
	var_2a8dacd1 = N_MAX_DAMAGE * 0.3;
	self DoDamage(var_2a8dacd1, self.origin, e_player, e_player, undefined, str_mod, 0, level.var_fb620116);
	var_c18df445 = N_MAX_DAMAGE * 0.1;
	while(n_timer < 6 && var_2a8dacd1 < N_MAX_DAMAGE)
	{
		var_e1fd6746 = RandomFloatRange(0.4, 1);
		wait(var_e1fd6746);
		n_timer = n_timer + var_e1fd6746;
		self DoDamage(var_c18df445, self.origin, e_player, e_player, undefined, str_mod, 0, level.var_fb620116);
		var_2a8dacd1 = var_2a8dacd1 + var_c18df445;
	}
	self clientfield::set("runeprison_lava_geyser_dot_fx", 0);
	self.var_ca25d40c = 0;
}

/*
	Name: function_46a00a8e
	Namespace: namespace_2d73d751
	Checksum: 0x55141CBB
	Offset: 0x1AD8
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_46a00a8e(ai_enemy)
{
	n_z_diff = 12 * 2;
	while(isdefined(ai_enemy) && isalive(ai_enemy) && (!isdefined(ai_enemy.var_98056717) && ai_enemy.var_98056717) && n_z_diff > 12)
	{
		var_c6f6381a = bullettrace(ai_enemy.origin, ai_enemy.origin - VectorScale((0, 0, 1), 1000), 0, undefined);
		n_z_diff = ai_enemy.origin[2] - var_c6f6381a["position"][2];
		wait(0.1);
	}
	if(isdefined(ai_enemy) && isalive(ai_enemy) && (!isdefined(ai_enemy.var_98056717) && ai_enemy.var_98056717))
	{
		return ai_enemy.origin;
	}
	else
	{
		return undefined;
	}
}

/*
	Name: function_1ed3d96d
	Namespace: namespace_2d73d751
	Checksum: 0x843AB344
	Offset: 0x1C50
	Size: 0x7B
	Parameters: 3
	Flags: None
*/
function function_1ed3d96d(str_weapon_name, v_source, v_destination)
{
	wait(0.1);
	if(str_weapon_name == "elemental_bow_rune_prison4")
	{
	}
	else
	{
	}
	str_weapon_name = "elemental_bow_rune_prison_ricochet";
	MagicBullet(GetWeapon(str_weapon_name), v_source, v_destination, self);
}

