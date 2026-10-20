#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_defend_areas;
#using scripts\zm\zm_zod_ee;
#using scripts\zm\zm_zod_margwa;
#using scripts\zm\zm_zod_pods;
#using scripts\zm\zm_zod_quest_vo;
#using scripts\zm\zm_zod_util;

#namespace zm_zod_shadowman;

/*
	Name: __init__sytem__
	Namespace: zm_zod_shadowman
	Checksum: 0xCC01B180
	Offset: 0x9F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_shadowman", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_shadowman
	Checksum: 0x30FB7582
	Offset: 0xA38
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	level._effect["shadowman_ground_tell"] = "zombie/fx_shdw_spell_tell_zod_zmb";
	level._effect["cursetrap_explosion"] = "zombie/fx_ee_explo_ritual_zod_zmb";
	level._effect["shadowman_impact_fx"] = "zombie/fx_shdw_impact_zod_zmb";
	level flag::init("shadowman_first_seen");
	/#
		level thread devgui_shadowman();
	#/
}

/*
	Name: on_player_connect
	Namespace: zm_zod_shadowman
	Checksum: 0x99EC1590
	Offset: 0xAF0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
}

/*
	Name: shadowman_spawns
	Namespace: zm_zod_shadowman
	Checksum: 0x1894B472
	Offset: 0xB00
	Size: 0x1C3
	Parameters: 4
	Flags: None
*/
function shadowman_spawns(b_can_damage, var_d250bd20, var_b7791b4b, b_floating)
{
	if(!isdefined(b_can_damage))
	{
		b_can_damage = 1;
	}
	if(!isdefined(var_d250bd20))
	{
		var_d250bd20 = 0;
	}
	if(!isdefined(var_b7791b4b))
	{
		var_b7791b4b = 0;
	}
	if(!isdefined(b_floating))
	{
		b_floating = 0;
	}
	self.mdl_shadowman = util::spawn_model("c_zom_zod_shadowman_fb", self.origin, self.angles);
	self.mdl_shadowman useanimtree(-1);
	if(!var_b7791b4b)
	{
		self.mdl_shadowman clientfield::set("shadowman_fx", 1);
	}
	self.mdl_shadowman playsound("zmb_shadowman_tele_in");
	self.mdl_shadowman.health = 1000000;
	if(var_d250bd20)
	{
		if(b_floating)
		{
			self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop");
		}
		else
		{
			self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_human_stand_idle_loop");
		}
	}
	if(b_can_damage)
	{
		self.mdl_shadowman SetCanDamage(1);
	}
	else
	{
		self.mdl_shadowman SetCanDamage(0);
	}
}

/*
	Name: function_8888a532
	Namespace: zm_zod_shadowman
	Checksum: 0x8B8C22C0
	Offset: 0xCD0
	Size: 0x223
	Parameters: 4
	Flags: None
*/
function function_8888a532(b_can_damage, var_d250bd20, var_2c1a0d8f, b_floating)
{
	if(!isdefined(b_can_damage))
	{
		b_can_damage = 1;
	}
	if(!isdefined(var_d250bd20))
	{
		var_d250bd20 = 0;
	}
	if(!isdefined(var_2c1a0d8f))
	{
		var_2c1a0d8f = 0;
	}
	if(!isdefined(b_floating))
	{
		b_floating = 0;
	}
	self.var_5afdc7fe = util::spawn_model("c_zom_zod_shadowman_tentacles_fb", self.origin, self.angles);
	self.var_5afdc7fe useanimtree(-1);
	self.var_5afdc7fe.health = 1000000;
	self.var_5afdc7fe clientfield::set("shadowman_fx", 1);
	if(var_d250bd20)
	{
		if(b_floating)
		{
			self.var_5afdc7fe thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop");
		}
		else
		{
			self.var_5afdc7fe thread animation::Play("ai_zombie_zod_shadowman_stand_idle_loop");
		}
	}
	if(b_can_damage)
	{
		self.var_5afdc7fe SetCanDamage(1);
	}
	else
	{
		self.var_5afdc7fe SetCanDamage(0);
	}
	if(var_2c1a0d8f)
	{
		self.var_5afdc7fe SetInvisibleToAll();
	}
	else
	{
		self.var_5afdc7fe Attach("p7_fxanim_zm_zod_redemption_key_ritual_mod", "tag_weapon_right");
		PlayFXOnTag(level._effect["ritual_key_glow"], self.var_5afdc7fe, "tag_weapon_right");
	}
}

/*
	Name: function_f25f7ff3
	Namespace: zm_zod_shadowman
	Checksum: 0xA623EA10
	Offset: 0xF00
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_f25f7ff3()
{
	self.mdl_shadowman clientfield::set("shadowman_fx", 2);
	self.mdl_shadowman playsound("zmb_shadowman_tele_out");
	wait(0.5);
	self.mdl_shadowman delete();
}

/*
	Name: function_57b6041b
	Namespace: zm_zod_shadowman
	Checksum: 0x4A21FBC4
	Offset: 0xF78
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_57b6041b()
{
	self.var_5afdc7fe delete();
}

/*
	Name: function_f3805c8a
	Namespace: zm_zod_shadowman
	Checksum: 0x7EEE5CFB
	Offset: 0xFA0
	Size: 0x3C9
	Parameters: 5
	Flags: None
*/
function function_f3805c8a(var_8f0a8b6a, str_script_noteworthy, a_s_moves, var_e033b3aa, var_f5525b44)
{
	if(!isdefined(level.shadowman))
	{
		level.shadowman = spawnstruct();
	}
	level.shadowman.var_8f0a8b6a = var_8f0a8b6a;
	a_s_spawnpoints = struct::get_array(var_8f0a8b6a, "targetname");
	if(level clientfield::get("ee_quest_state") === 1)
	{
		a_s_spawnpoints = Array::filter(a_s_spawnpoints, 0, &condition_inability, 0);
	}
	if(isdefined(str_script_noteworthy))
	{
		a_s_spawnpoints = Array::filter(a_s_spawnpoints, 0, &function_69330ce7, str_script_noteworthy);
	}
	else
	{
		a_s_spawnpoints = Array::randomize(a_s_spawnpoints);
	}
	level.shadowman.s_spawnpoint = a_s_spawnpoints[a_s_spawnpoints.size - 1];
	var_2e456dd1 = level.shadowman.s_spawnpoint.origin;
	var_7e1ba25f = level.shadowman.s_spawnpoint.angles;
	level.shadowman.mdl_shadowman = spawn("script_model", var_2e456dd1);
	level.shadowman.mdl_shadowman.angles = var_7e1ba25f;
	level.shadowman.mdl_shadowman SetModel("c_zom_zod_shadowman_tentacles_fb");
	level.shadowman.mdl_shadowman useanimtree(-1);
	level.shadowman.mdl_shadowman SetCanDamage(1);
	level.shadowman.mdl_shadowman clientfield::set("shadowman_fx", 1);
	level.shadowman.mdl_shadowman playsound("zmb_shadowman_tele_in");
	level.shadowman.mdl_shadowman Attach("p7_fxanim_zm_zod_redemption_key_ritual_mod", "tag_weapon_right");
	level.shadowman.n_script_int = 0;
	level.shadowman.str_script_noteworthy = str_script_noteworthy;
	level.shadowman thread function_b6c7fd80();
	level.shadowman.var_e033b3aa = var_e033b3aa;
	level.shadowman.var_f5525b44 = var_f5525b44;
	level.shadowman.a_s_moves = a_s_moves;
	level.shadowman thread function_43eea1de();
	level.shadowman.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, 1);
	return level.shadowman;
}

/*
	Name: function_d04f45cf
	Namespace: zm_zod_shadowman
	Checksum: 0xB394DE33
	Offset: 0x1378
	Size: 0x87
	Parameters: 3
	Flags: None
*/
function function_d04f45cf(a_s_moves, var_e033b3aa, var_f5525b44)
{
	if(!isdefined(level.shadowman))
	{
		return;
	}
	if(isdefined(var_e033b3aa))
	{
		level.shadowman.var_e033b3aa = var_e033b3aa;
	}
	if(isdefined(var_f5525b44))
	{
		level.shadowman.var_f5525b44 = var_f5525b44;
	}
	if(isdefined(a_s_moves))
	{
		level.shadowman.a_s_moves = a_s_moves;
	}
}

/*
	Name: shadowman_leave
	Namespace: zm_zod_shadowman
	Checksum: 0xD062C1ED
	Offset: 0x1408
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function shadowman_leave()
{
	if(!isdefined(level.shadowman))
	{
		return;
	}
	level notify("shadowman_leaves");
	if(!isdefined(level.shadowman.mdl_shadowman))
	{
		return;
	}
	mdl_shadowman = level.shadowman.mdl_shadowman;
	if(isdefined(mdl_shadowman))
	{
		mdl_shadowman clientfield::set("shadowman_fx", 2);
		mdl_shadowman playsound("zmb_shadowman_tele_out");
	}
	wait(0.5);
	if(isdefined(mdl_shadowman))
	{
		mdl_shadowman delete();
	}
}

/*
	Name: function_43eea1de
	Namespace: zm_zod_shadowman
	Checksum: 0x428DF4F8
	Offset: 0x14D8
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function function_43eea1de()
{
	level endon("shadowman_leaves");
	while(1)
	{
		var_47364533 = RandomFloatRange(self.var_e033b3aa, self.var_f5525b44);
		wait(var_47364533);
		n_roll = RandomFloatRange(0, 1);
		var_6ab32645 = 0;
		foreach(s_move in self.a_s_moves)
		{
			var_6ab32645 = var_6ab32645 + s_move.probability;
			if(n_roll <= var_6ab32645)
			{
				if(!(isdefined(self.b_away) && self.b_away))
				{
					self [[s_move.func]](s_move.n_move_duration);
				}
				break;
			}
		}
		self.a_s_moves = Array::randomize(self.a_s_moves);
	}
}

/*
	Name: function_b6c7fd80
	Namespace: zm_zod_shadowman
	Checksum: 0xBD1710BB
	Offset: 0x1658
	Size: 0x58F
	Parameters: 0
	Flags: None
*/
function function_b6c7fd80()
{
	level notify("hash_b6c7fd80");
	level endon("hash_b6c7fd80");
	level endon("shadowman_leaves");
	a_s_spawnpoints = struct::get_array(self.var_8f0a8b6a, "targetname");
	if(isdefined(self.str_script_noteworthy))
	{
		a_s_spawnpoints = Array::filter(a_s_spawnpoints, 0, &function_69330ce7, self.str_script_noteworthy);
	}
	else
	{
		a_s_spawnpoints = Array::randomize(a_s_spawnpoints);
	}
	var_bac4e70 = 0;
	var_90530d3 = 0;
	self.b_away = 0;
	while(1)
	{
		self.mdl_shadowman.health = 1000000;
		self.mdl_shadowman waittill("damage", amount, attacker, direction_vec, point, type, tagName, modelName, partName, weapon);
		playFX(level._effect["shadowman_impact_fx"], point);
		var_90530d3 = var_90530d3 + amount;
		var_6b401aad = 0;
		for(i = 0; i < 2; i++)
		{
			wpn_idgun = GetWeapon(level.idgun[i].str_wpnname);
			/#
				Assert(isdefined(wpn_idgun));
			#/
			if(weapon === wpn_idgun)
			{
				var_6b401aad = 1;
			}
		}
		n_player_count = level.activePlayers.size;
		var_d6a1b83c = 0.5 + 0.5 * n_player_count - 1 / 3;
		var_9bd75db5 = 1000 * var_d6a1b83c;
		var_e3b39dfc = 0;
		if(var_90530d3 >= var_9bd75db5)
		{
			var_e3b39dfc = 1;
		}
		if(!var_e3b39dfc && !var_6b401aad)
		{
			continue;
		}
		var_90530d3 = 0;
		if(level clientfield::get("ee_quest_state") === 1 && level flag::get("ee_boss_vulnerable") === 0)
		{
			continue;
		}
		self.b_away = 1;
		level notify("shadowman_damaged");
		if(level flag::get("ee_boss_started"))
		{
			if(self.n_script_int < 8)
			{
				self.n_script_int++;
				self.s_spawnpoint = function_293235e9(self.var_8f0a8b6a, self.s_spawnpoint, self.n_script_int);
			}
			var_685eb707 = 0.1;
			function_284b1884(self, self.s_spawnpoint, var_685eb707, undefined);
			self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_captured_intro", undefined, undefined, 1);
		}
		else
		{
			var_bac4e70++;
			if(var_bac4e70 == a_s_spawnpoints.size)
			{
				a_s_spawnpoints = Array::randomize(a_s_spawnpoints);
				var_bac4e70 = 0;
			}
			self.s_spawnpoint = a_s_spawnpoints[var_bac4e70];
			var_685eb707 = RandomFloatRange(5, 10);
			self.b_away = 0;
			var_5d186a94 = level.var_6e3c8a77.origin;
			v_dir = VectorNormalize(var_5d186a94 - self.s_spawnpoint.origin);
			v_angles = VectorToAngles(v_dir);
			function_284b1884(self, self.s_spawnpoint, var_685eb707, v_angles);
			self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, 1);
		}
	}
}

/*
	Name: function_284b1884
	Namespace: zm_zod_shadowman
	Checksum: 0x54A76C1D
	Offset: 0x1BF0
	Size: 0x17B
	Parameters: 4
	Flags: None
*/
function function_284b1884(var_dbc3a0ef, s_target, var_685eb707, v_angles)
{
	var_dbc3a0ef.mdl_shadowman animation::stop();
	var_dbc3a0ef.mdl_shadowman clientfield::set("shadowman_fx", 2);
	var_dbc3a0ef.mdl_shadowman playsound("zmb_shadowman_tele_out");
	var_dbc3a0ef.mdl_shadowman Hide();
	var_dbc3a0ef.mdl_shadowman.origin = s_target.origin;
	if(isdefined(v_angles))
	{
		var_dbc3a0ef.mdl_shadowman.angles = v_angles;
	}
	if(isdefined(var_685eb707))
	{
		wait(var_685eb707);
	}
	var_dbc3a0ef.mdl_shadowman clientfield::set("shadowman_fx", 1);
	var_dbc3a0ef.mdl_shadowman playsound("zmb_shadowman_tele_in");
	var_dbc3a0ef.mdl_shadowman show();
}

/*
	Name: function_293235e9
	Namespace: zm_zod_shadowman
	Checksum: 0xA235AD81
	Offset: 0x1D78
	Size: 0xEF
	Parameters: 3
	Flags: None
*/
function function_293235e9(var_8f0a8b6a, var_1e5c1571, n_script_int)
{
	a_s_spawnpoints = struct::get_array(var_8f0a8b6a, "targetname");
	if(isdefined(var_1e5c1571))
	{
		ArrayRemoveValue(a_s_spawnpoints, var_1e5c1571);
	}
	if(isdefined(n_script_int))
	{
		a_s_spawnpoints = Array::filter(a_s_spawnpoints, 0, &condition_inability, n_script_int);
	}
	/#
		Assert(a_s_spawnpoints.size > 0);
	#/
	a_s_spawnpoints = Array::randomize(a_s_spawnpoints);
	return a_s_spawnpoints[0];
}

/*
	Name: condition_inability
	Namespace: zm_zod_shadowman
	Checksum: 0x8C0AD48C
	Offset: 0x1E70
	Size: 0x6D
	Parameters: 2
	Flags: None
*/
function condition_inability(s_loc, n_script_int)
{
	if(!isdefined(s_loc) || !isdefined(s_loc.script_int) || (!isdefined(s_loc.script_int === n_script_int) && s_loc.script_int === n_script_int))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_69330ce7
	Namespace: zm_zod_shadowman
	Checksum: 0x674EAA59
	Offset: 0x1EE8
	Size: 0x6D
	Parameters: 2
	Flags: None
*/
function function_69330ce7(s_loc, str_script_noteworthy)
{
	if(!isdefined(s_loc) || !isdefined(s_loc.script_noteworthy) || (!isdefined(s_loc.script_noteworthy === str_script_noteworthy) && s_loc.script_noteworthy === str_script_noteworthy))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_1c6bcf90
	Namespace: zm_zod_shadowman
	Checksum: 0xA5FCE3FA
	Offset: 0x1F60
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_1c6bcf90(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8cf7b520 = "buffed_zombie_spawn_point_" + self.n_location_index;
	n_spawn_count = randomIntRange(1, 3);
	self function_52243341(var_8cf7b520, n_move_duration, 0, n_spawn_count, 0.25, 0.5);
}

/*
	Name: function_58a299d8
	Namespace: zm_zod_shadowman
	Checksum: 0x6D5CF8FE
	Offset: 0x2008
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_58a299d8(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8cf7b520 = "buffed_zombie_spawn_point_" + self.n_location_index;
	n_spawn_count = randomIntRange(3, 6);
	self function_52243341(var_8cf7b520, n_move_duration, 0, n_spawn_count, 0.1, 0.2);
}

/*
	Name: function_8e16c7ef
	Namespace: zm_zod_shadowman
	Checksum: 0x72AA8485
	Offset: 0x20B0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_8e16c7ef(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8cf7b520 = "buffed_elemental_spawn_point_" + self.n_location_index;
	self function_52243341(var_8cf7b520, n_move_duration, 2, 1, 0.25, 0.5);
}

/*
	Name: function_801629a7
	Namespace: zm_zod_shadowman
	Checksum: 0xE0C9A8AB
	Offset: 0x2130
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_801629a7(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8cf7b520 = "buffed_elemental_spawn_point_" + self.n_location_index;
	self function_52243341(var_8cf7b520, n_move_duration, 2, 3, 0.1, 0.2);
}

/*
	Name: function_2c57b431
	Namespace: zm_zod_shadowman
	Checksum: 0xD08F4F4E
	Offset: 0x21B0
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_2c57b431(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8cf7b520 = "buffed_elemental_spawn_point";
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 0)
	{
		var_8388cfbb = level.var_6e3c8a77.origin;
	}
	else
	{
	}
	self function_52243341(var_8cf7b520, n_move_duration, 2, 1, 0.25, 0.5, var_8388cfbb);
}

/*
	Name: function_6e618ab9
	Namespace: zm_zod_shadowman
	Checksum: 0xD643ABBF
	Offset: 0x2290
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_6e618ab9(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8cf7b520 = "buffed_elemental_spawn_point";
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 0)
	{
		var_8388cfbb = level.var_6e3c8a77.origin;
	}
	else
	{
	}
	self function_52243341(var_8cf7b520, n_move_duration, 2, 3, 0.1, 0.2, var_8388cfbb);
}

/*
	Name: function_4a41b207
	Namespace: zm_zod_shadowman
	Checksum: 0x1E5B4926
	Offset: 0x2370
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function function_4a41b207(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_8388cfbb = level.var_6e3c8a77.origin;
	self function_a3821eb5(n_move_duration);
	n_spawn_count = randomIntRange(5, 9);
	favorite_enemy = zm_ai_wasp::get_favorite_enemy();
	for(i = 0; i < n_spawn_count; i++)
	{
		spawn_point = zm_ai_wasp::wasp_spawn_logic(favorite_enemy);
		self thread function_4ef376eb(spawn_point);
		n_wait = RandomFloatRange(0.1, 0.3);
		wait(n_wait);
	}
}

/*
	Name: function_c073c1e6
	Namespace: zm_zod_shadowman
	Checksum: 0x5638B6AB
	Offset: 0x24B0
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function function_c073c1e6(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_32cbfe17 = [];
	var_10284ef9 = zm_zod_util::function_15166300(4);
	if(var_10284ef9 >= 1)
	{
		if(!isdefined(var_32cbfe17))
		{
			var_32cbfe17 = [];
		}
		else if(!IsArray(var_32cbfe17))
		{
			var_32cbfe17 = Array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = &function_32e7f676;
	}
	if(var_32cbfe17.size > 0)
	{
		func_move = Array::random(var_32cbfe17);
		self [[func_move]](n_move_duration);
	}
}

/*
	Name: function_b4b792ef
	Namespace: zm_zod_shadowman
	Checksum: 0x394CF1DF
	Offset: 0x25C8
	Size: 0x261
	Parameters: 1
	Flags: None
*/
function function_b4b792ef(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_2c563e77 = zm_zod_util::function_15166300(1);
	var_57689abe = zm_zod_util::function_15166300(3);
	var_32cbfe17 = [];
	if(var_2c563e77 >= 4)
	{
		if(!isdefined(var_32cbfe17))
		{
			var_32cbfe17 = [];
		}
		else if(!IsArray(var_32cbfe17))
		{
			var_32cbfe17 = Array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = &function_c94f30a2;
	}
	if(var_57689abe >= 3)
	{
		if(!isdefined(var_32cbfe17))
		{
			var_32cbfe17 = [];
		}
		else if(!IsArray(var_32cbfe17))
		{
			var_32cbfe17 = Array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = &function_45c7d9eb;
	}
	if(var_32cbfe17.size === 0)
	{
		if(!isdefined(var_32cbfe17))
		{
			var_32cbfe17 = [];
		}
		else if(!IsArray(var_32cbfe17))
		{
			var_32cbfe17 = Array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = &function_e44c4f1b;
	}
	else if(!isdefined(var_32cbfe17))
	{
		var_32cbfe17 = [];
	}
	else if(!IsArray(var_32cbfe17))
	{
		var_32cbfe17 = Array(var_32cbfe17);
	}
	var_32cbfe17[var_32cbfe17.size] = &function_fcd226a8;
	func_move = Array::random(var_32cbfe17);
	self [[func_move]](n_move_duration);
}

/*
	Name: function_c94f30a2
	Namespace: zm_zod_shadowman
	Checksum: 0x4E43E85C
	Offset: 0x2838
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_c94f30a2(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_2c563e77 = zm_zod_util::function_15166300(1);
	n_spawn_count = min(var_2c563e77, 8);
	self function_52243341("spawn_point_boss_fight", n_move_duration, 0, n_spawn_count, 5, 8);
}

/*
	Name: function_45c7d9eb
	Namespace: zm_zod_shadowman
	Checksum: 0x457AC59F
	Offset: 0x28E8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_45c7d9eb(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_57689abe = zm_zod_util::function_15166300(3);
	n_spawn_count = min(var_57689abe, 5);
	self function_52243341("spawn_point_boss_fight", n_move_duration, 2, n_spawn_count, 5, 8);
}

/*
	Name: function_32e7f676
	Namespace: zm_zod_shadowman
	Checksum: 0xD09B5665
	Offset: 0x29A0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_32e7f676(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	var_10284ef9 = zm_zod_util::function_15166300(4);
	n_spawn_count = min(var_10284ef9, 1);
	self function_52243341("spawn_point_boss_fight", n_move_duration, 3, n_spawn_count, 5, 8);
}

/*
	Name: function_fcd226a8
	Namespace: zm_zod_shadowman
	Checksum: 0xA17C21E7
	Offset: 0x2A58
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function function_fcd226a8(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self function_a3821eb5(n_move_duration);
	a_str_charnames = Array("boxer", "detective", "femme", "magician");
	str_charname = Array::random(a_str_charnames);
	level clientfield::set("ee_keeper_" + str_charname + "_state", 6);
	wait(n_move_duration);
}

/*
	Name: function_e44c4f1b
	Namespace: zm_zod_shadowman
	Checksum: 0x73F4303C
	Offset: 0x2B30
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function function_e44c4f1b(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self function_a3821eb5(n_move_duration);
	a_str_charnames = Array("boxer", "detective", "femme", "magician");
	foreach(str_charname in a_str_charnames)
	{
		level clientfield::set("ee_keeper_" + str_charname + "_state", 6);
	}
	wait(n_move_duration);
}

/*
	Name: function_52243341
	Namespace: zm_zod_shadowman
	Checksum: 0x3B8CFA68
	Offset: 0x2C50
	Size: 0xB3
	Parameters: 8
	Flags: None
*/
function function_52243341(var_8cf7b520, n_move_duration, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb, s_target)
{
	if(!isdefined(var_cbdd21c0))
	{
		var_cbdd21c0 = 0;
	}
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self function_a3821eb5(n_move_duration);
	self function_1bd7a0f4(var_8cf7b520, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb);
}

/*
	Name: function_a3821eb5
	Namespace: zm_zod_shadowman
	Checksum: 0x9DECCC24
	Offset: 0x2D10
	Size: 0x35B
	Parameters: 2
	Flags: None
*/
function function_a3821eb5(n_move_duration, var_8fc8c481)
{
	if(!isdefined(var_8fc8c481))
	{
		var_8fc8c481 = 1;
	}
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self.mdl_shadowman animation::stop();
	self.mdl_shadowman clientfield::set("shadowman_fx", 3);
	self.mdl_shadowman playsound("zmb_shadowman_spell_start");
	self.mdl_shadowman PlayLoopSound("zmb_shadowman_spell_loop", 0.75);
	self.mdl_shadowman ClearAnim("ai_zombie_zod_shadowman_float_idle_loop", 0);
	self.mdl_shadowman animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_intro", undefined, undefined, var_8fc8c481);
	player = level.activePlayers[0];
	self.mdl_shadowman animation::stop();
	self.mdl_shadowman clientfield::set("shadowman_fx", 4);
	self.mdl_shadowman ClearAnim("ai_zombie_zod_shadowman_float_attack_aoe_charge_intro", 0);
	self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_loop", undefined, undefined, var_8fc8c481);
	level thread zm_zod_util::function_3a7a7013(5, 1024, self.mdl_shadowman.origin, n_move_duration);
	wait(n_move_duration);
	self.mdl_shadowman animation::stop();
	self.mdl_shadowman clientfield::set("shadowman_fx", 5);
	self.mdl_shadowman StopLoopSound(0.1);
	self.mdl_shadowman playsound("zmb_shadowman_spell_cast");
	self.mdl_shadowman ClearAnim("ai_zombie_zod_shadowman_float_attack_aoe_charge_loop", 0);
	self.mdl_shadowman animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_deploy", undefined, undefined, var_8fc8c481);
	level thread zm_zod_util::function_3a7a7013(6, 1024, self.mdl_shadowman.origin, 1);
	self.mdl_shadowman clientfield::set("shadowman_fx", 6);
	self.mdl_shadowman ClearAnim("ai_zombie_zod_shadowman_float_attack_aoe_deploy", 0);
	self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, var_8fc8c481);
}

/*
	Name: function_bd35f3d6
	Namespace: zm_zod_shadowman
	Checksum: 0x154F9793
	Offset: 0x3078
	Size: 0x293
	Parameters: 1
	Flags: None
*/
function function_bd35f3d6(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self.mdl_shadowman clientfield::set("shadowman_fx", 3);
	self.mdl_shadowman playsound("zmb_shadowman_spell_start");
	self.mdl_shadowman PlayLoopSound("zmb_shadowman_spell_loop", 0.75);
	self.mdl_shadowman animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_intro", undefined, undefined);
	player = level.activePlayers[0];
	self.mdl_shadowman animation::stop();
	self.mdl_shadowman clientfield::set("shadowman_fx", 4);
	self.mdl_shadowman thread animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_loop", undefined, undefined);
	level thread zm_zod_util::function_3a7a7013(5, 1024, self.mdl_shadowman.origin, n_move_duration);
	wait(n_move_duration);
	self.mdl_shadowman animation::stop();
	self.mdl_shadowman clientfield::set("shadowman_fx", 5);
	self.mdl_shadowman StopLoopSound(0.1);
	self.mdl_shadowman playsound("zmb_shadowman_spell_cast");
	self.mdl_shadowman animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_deploy", undefined, undefined);
	level thread zm_zod_util::function_3a7a7013(6, 1024, self.mdl_shadowman.origin, 1);
	self.mdl_shadowman clientfield::set("shadowman_fx", 6);
	self function_80fd208e(self.n_location_index);
}

/*
	Name: function_3803c75b
	Namespace: zm_zod_shadowman
	Checksum: 0xD51C5B7B
	Offset: 0x3318
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_3803c75b(n_move_duration)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self.mdl_shadowman thread animation::Play("ai_zombie_zod_keeper_give_me_sword_intro", undefined, undefined, n_move_duration);
	wait(n_move_duration);
	player = GetPlayers()[0];
	v_origin = player GetOrigin();
	function_ada13668(v_origin, undefined, 0);
}

/*
	Name: function_1bd7a0f4
	Namespace: zm_zod_shadowman
	Checksum: 0x9C6FCB6E
	Offset: 0x33D8
	Size: 0x1CF
	Parameters: 6
	Flags: None
*/
function function_1bd7a0f4(var_8cf7b520, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb)
{
	a_s_spawnpoints = struct::get_array(var_8cf7b520, "targetname");
	a_s_spawnpoints = Array::randomize(a_s_spawnpoints);
	v_origin = self.mdl_shadowman.origin;
	for(i = 0; i < n_spawn_count; i++)
	{
		v_target = a_s_spawnpoints[i].origin;
		switch(var_cbdd21c0)
		{
			case 0:
			{
				self thread function_1063429a(a_s_spawnpoints[i]);
				break;
			}
			case 1:
			{
				self thread function_4ef376eb(a_s_spawnpoints[i]);
				break;
			}
			case 2:
			{
				self thread function_7a4cf63(a_s_spawnpoints[i], var_8388cfbb);
				break;
			}
			case 3:
			{
				self thread namespace_d17e1da0::function_8bcb72e9(0, a_s_spawnpoints[i]);
				break;
			}
		}
		var_dc7b7a0f = RandomFloatRange(var_58655a9e, var_ab3cc960);
		wait(var_dc7b7a0f);
	}
}

/*
	Name: function_1063429a
	Namespace: zm_zod_shadowman
	Checksum: 0xBD2883FF
	Offset: 0x35B0
	Size: 0x1D3
	Parameters: 1
	Flags: None
*/
function function_1063429a(s_spawnpoint)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	e_fx_origin = spawn("script_model", s_spawnpoint.origin);
	e_fx_origin SetModel("tag_origin");
	e_fx_origin clientfield::set("darkportal_fx", 1);
	e_fx_origin playsound("evt_keeper_portal_start");
	e_fx_origin PlayLoopSound("evt_keeper_portal_loop", 1.2);
	self thread function_82fc1cb2(e_fx_origin);
	wait(0.5);
	ai = zombie_utility::spawn_zombie(var_42513f6e, "buffed_zombie", s_spawnpoint);
	ai thread init_buffed_zombie();
	ai thread function_827ad6f();
	ai.n_location_index = self.n_location_index;
	wait(3);
	e_fx_origin clientfield::set("darkportal_fx", 0);
	e_fx_origin playsound("evt_keeper_portal_end");
	e_fx_origin delete();
}

/*
	Name: function_4ef376eb
	Namespace: zm_zod_shadowman
	Checksum: 0xC1C972E0
	Offset: 0x3790
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function function_4ef376eb(s_spawnpoint)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	ai_wasp = zombie_utility::spawn_zombie(level.wasp_spawners[0], "buffed_parasite", s_spawnpoint);
	if(isdefined(ai_wasp))
	{
		if(!isdefined(level.var_27fa160f))
		{
			level.var_27fa160f = [];
		}
		if(!isdefined(level.var_27fa160f))
		{
			level.var_27fa160f = [];
		}
		else if(!IsArray(level.var_27fa160f))
		{
			level.var_27fa160f = Array(level.var_27fa160f);
		}
		level.var_27fa160f[level.var_27fa160f.size] = ai_wasp;
		ai_wasp.favoriteenemy = Array::random(level.activePlayers);
		level thread zm_ai_wasp::wasp_spawn_init(ai_wasp, s_spawnpoint.origin);
	}
}

/*
	Name: function_33ddc9ed
	Namespace: zm_zod_shadowman
	Checksum: 0x2370721
	Offset: 0x38E8
	Size: 0x1B7
	Parameters: 1
	Flags: None
*/
function function_33ddc9ed(n_location_index)
{
	self endon("death");
	while(1)
	{
		s_pod = undefined;
		while(!isdefined(s_pod))
		{
			s_pod = function_479785a0(n_location_index);
			wait(0.1);
		}
		s_pod.var_70ac16f8 = 1;
		wait(5);
		self vehicle_ai::set_state("scripted");
		goal = self GetClosestPointOnNavVolume(s_pod.origin + VectorScale((0, 0, 1), 32), 50);
		self SetVehGoalPos(goal, 0, 1);
		self waittill("goal");
		if(isdefined(s_pod.var_9a8117f3) && s_pod.var_9a8117f3)
		{
			s_pod.buff = 1;
			s_pod.e_fx_origin = spawn("script_model", s_pod.origin);
			s_pod.e_fx_origin SetModel("tag_origin");
			s_pod.e_fx_origin clientfield::set("curse_tell_fx", 1);
		}
	}
}

/*
	Name: function_80fd208e
	Namespace: zm_zod_shadowman
	Checksum: 0xDBCB2A09
	Offset: 0x3AA8
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_80fd208e(n_location_index)
{
	s_pod = function_479785a0(n_location_index);
	if(!isdefined(s_pod))
	{
		return;
	}
	s_pod.buff = 1;
	s_pod.e_fx_origin = spawn("script_model", s_pod.origin);
	s_pod.e_fx_origin SetModel("tag_origin");
	s_pod.e_fx_origin PlayLoopSound("evt_pod_plague_magic_lp", 1);
	s_pod.e_fx_origin clientfield::set("curse_tell_fx", 1);
}

/*
	Name: function_479785a0
	Namespace: zm_zod_shadowman
	Checksum: 0x21923889
	Offset: 0x3BA8
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function function_479785a0(var_e28c6e5d)
{
	var_d7afb638 = "ee_plague_pods_" + var_e28c6e5d;
	if(!isdefined(level.var_c0f45612[var_d7afb638].spawned))
	{
		return undefined;
	}
	var_c0eb23cc = Array::filter(level.var_c0f45612[var_d7afb638].spawned, 0, &function_9edae260);
	if(var_c0eb23cc.size === 0)
	{
		return undefined;
	}
	s_pod = Array::random(var_c0eb23cc);
	return s_pod;
}

/*
	Name: function_9edae260
	Namespace: zm_zod_shadowman
	Checksum: 0x49F55BE3
	Offset: 0x3C80
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_9edae260(s_pod)
{
	if(!isdefined(s_pod) || (isdefined(s_pod.var_70ac16f8) && s_pod.var_70ac16f8) || (isdefined(s_pod.buff) && s_pod.buff) || (!isdefined(s_pod.growing) && s_pod.growing))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_7a4cf63
	Namespace: zm_zod_shadowman
	Checksum: 0x66DFF0A7
	Offset: 0x3D18
	Size: 0x193
	Parameters: 2
	Flags: None
*/
function function_7a4cf63(s_spawnpoint, var_8388cfbb)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	ai_raps = zombie_utility::spawn_zombie(level.raps_spawners[0], "buffed_elemental", s_spawnpoint);
	if(isdefined(ai_raps))
	{
		if(!isdefined(level.var_35fcee79))
		{
			level.var_35fcee79 = [];
		}
		if(!isdefined(level.var_35fcee79))
		{
			level.var_35fcee79 = [];
		}
		else if(!IsArray(level.var_35fcee79))
		{
			level.var_35fcee79 = Array(level.var_35fcee79);
		}
		level.var_35fcee79[level.var_35fcee79.size] = ai_raps;
		ai_raps clientfield::set("veh_status_fx", 2);
		ai_raps.favoriteenemy = Array::random(level.activePlayers);
		s_spawnpoint thread zm_ai_raps::raps_spawn_fx(ai_raps, s_spawnpoint);
		if(isdefined(var_8388cfbb))
		{
			ai_raps thread function_4a3d00d6(var_8388cfbb);
		}
	}
}

/*
	Name: function_4a3d00d6
	Namespace: zm_zod_shadowman
	Checksum: 0x294C3FF1
	Offset: 0x3EB8
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_4a3d00d6(goal)
{
	self endon("death");
	wait(5);
	self vehicle_ai::set_state("scripted");
	goal = GetClosestPointOnNavMesh(goal, 50);
	self SetVehGoalPos(goal, 0, 1);
	self thread function_75c9aad2(goal, 64);
}

/*
	Name: function_75c9aad2
	Namespace: zm_zod_shadowman
	Checksum: 0xDC056F30
	Offset: 0x3F58
	Size: 0xAF
	Parameters: 3
	Flags: None
*/
function function_75c9aad2(var_8388cfbb, n_radius, var_9c795730)
{
	if(!isdefined(var_9c795730))
	{
		var_9c795730 = 0;
	}
	self endon("death");
	var_699d80d5 = n_radius * n_radius;
	while(1)
	{
		if(Distance2DSquared(self.origin, var_8388cfbb) <= var_699d80d5)
		{
			if(var_9c795730)
			{
				level notify("hash_d103204");
			}
			self kill();
		}
		wait(0.1);
	}
}

/*
	Name: function_82fc1cb2
	Namespace: zm_zod_shadowman
	Checksum: 0x21D8AC33
	Offset: 0x4010
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_82fc1cb2(e_fx_origin)
{
	level endon("shadowman_leaves");
	level waittill("shadowman_damaged");
	if(isdefined(e_fx_origin))
	{
		e_fx_origin clientfield::set("darkportal_fx", 0);
		e_fx_origin playsound("evt_keeper_portal_end");
		e_fx_origin delete();
	}
}

/*
	Name: init_buffed_zombie
	Namespace: zm_zod_shadowman
	Checksum: 0xC78576EA
	Offset: 0x40A0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function init_buffed_zombie()
{
	self endon("death");
	self.script_string = "find_flesh";
	self setPhysParams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.no_powerups = 1;
	self.deathpoints_already_given = 1;
	self.exclude_distance_cleanup_adding_to_total = 1;
	self.exclude_cleanup_adding_to_total = 1;
	util::wait_network_frame();
	self clientfield::set("status_fx", 1);
	find_flesh_struct_string = "find_flesh";
	self notify("zombie_custom_think_done", find_flesh_struct_string);
}

/*
	Name: function_827ad6f
	Namespace: zm_zod_shadowman
	Checksum: 0x8E7B9A93
	Offset: 0x4180
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_827ad6f()
{
	self waittill("death", attacker, mod, weapon, point);
	if(!isdefined(self))
	{
		return;
	}
	self clientfield::set("status_fx", 0);
	v_origin = self.origin;
	v_origin = v_origin + VectorScale((0, 0, 1), 2);
	level thread function_ada13668(v_origin, undefined, 0);
}

/*
	Name: function_d74385f9
	Namespace: zm_zod_shadowman
	Checksum: 0x99EC1590
	Offset: 0x4240
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_d74385f9()
{
}

/*
	Name: function_ed1e1c78
	Namespace: zm_zod_shadowman
	Checksum: 0x99EC1590
	Offset: 0x4250
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_ed1e1c78()
{
}

/*
	Name: function_6c24da7d
	Namespace: zm_zod_shadowman
	Checksum: 0x99EC1590
	Offset: 0x4260
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_6c24da7d()
{
}

/*
	Name: function_21fc375
	Namespace: zm_zod_shadowman
	Checksum: 0xFFBF48A0
	Offset: 0x4270
	Size: 0xD7
	Parameters: 5
	Flags: None
*/
function function_21fc375(v_origin, var_71f5107e, var_c4cc7f40, var_975b0849, var_4071777f)
{
	if(!isdefined(var_975b0849))
	{
		var_975b0849 = 64;
	}
	if(!isdefined(var_4071777f))
	{
		var_4071777f = 256;
	}
	var_feed8b5b = 0;
	var_1c445caf = randomIntRange(var_71f5107e, var_c4cc7f40);
	var_1e7e1004 = 360 / var_1c445caf;
	for(i = 0; i < var_1c445caf; i++)
	{
		var_feed8b5b = var_feed8b5b + var_1e7e1004;
	}
}

/*
	Name: function_f38a6a2a
	Namespace: zm_zod_shadowman
	Checksum: 0x5CA2D656
	Offset: 0x4350
	Size: 0x24D
	Parameters: 1
	Flags: None
*/
function function_f38a6a2a(var_8661a082)
{
	var_c9a88def = struct::get_array("cursetrap_point", "targetname");
	var_c9a88def = Array::randomize(var_c9a88def);
	var_9e546be = [];
	var_5543272f = [];
	for(i = 0; i < var_c9a88def.size; i++)
	{
		if(isdefined(var_c9a88def[i].active) && var_c9a88def[i].active)
		{
			if(!isdefined(var_9e546be))
			{
				var_9e546be = [];
			}
			else if(!IsArray(var_9e546be))
			{
				var_9e546be = Array(var_9e546be);
			}
			var_9e546be[var_9e546be.size] = var_c9a88def[i];
			continue;
		}
		if(!isdefined(var_5543272f))
		{
			var_5543272f = [];
		}
		else if(!IsArray(var_5543272f))
		{
			var_5543272f = Array(var_5543272f);
		}
		var_5543272f[var_5543272f.size] = var_c9a88def[i];
	}
	var_e1b2953e = var_9e546be.size;
	n_diff = var_8661a082 - var_e1b2953e;
	var_4162cc72 = Abs(n_diff);
	for(i = 0; i < var_4162cc72; i++)
	{
		if(n_diff > 0)
		{
			var_5543272f[i].active = 1;
			continue;
		}
		if(n_diff < 0)
		{
			var_9e546be[i].active = 0;
		}
	}
}

/*
	Name: function_6ceb834f
	Namespace: zm_zod_shadowman
	Checksum: 0xAABAF6A
	Offset: 0x45A8
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function function_6ceb834f()
{
	level notify("hash_6ceb834f");
	level endon("hash_6ceb834f");
	var_c9a88def = struct::get_array("cursetrap_point", "targetname");
	while(1)
	{
		foreach(var_c2099ecc in var_c9a88def)
		{
			if(isdefined(var_c2099ecc.active) && var_c2099ecc.active && function_ab84e253(var_c2099ecc.origin, 1024))
			{
				if(!isdefined(var_c2099ecc.e_fx_origin))
				{
					var_c2099ecc thread function_ada13668(var_c2099ecc.origin, undefined, 1, 1);
				}
				continue;
			}
			if(isdefined(var_c2099ecc.e_fx_origin))
			{
				if(isdefined(var_c2099ecc.e_fx_origin.trigger))
				{
					var_c2099ecc.e_fx_origin.trigger delete();
				}
				var_c2099ecc.e_fx_origin delete();
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_ab84e253
	Namespace: zm_zod_shadowman
	Checksum: 0x6B5C245
	Offset: 0x4780
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function function_ab84e253(v_origin, n_radius)
{
	var_5a3ad5d6 = n_radius * n_radius;
	foreach(player in level.activePlayers)
	{
		if(isdefined(player) && Distance2DSquared(player.origin, v_origin) <= var_5a3ad5d6)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_ada13668
	Namespace: zm_zod_shadowman
	Checksum: 0xAA58C142
	Offset: 0x4868
	Size: 0x209
	Parameters: 4
	Flags: None
*/
function function_ada13668(v_origin, n_duration, var_23217d90, var_526fc172)
{
	if(!isdefined(var_526fc172))
	{
		var_526fc172 = 0;
	}
	if(var_526fc172)
	{
		while(function_ab84e253(v_origin, 64))
		{
			wait(1);
		}
	}
	if(var_23217d90)
	{
		self.e_fx_origin = spawn("script_model", v_origin);
		self.e_fx_origin.angles = VectorScale((-1, 0, 0), 90);
		self.e_fx_origin SetModel("tag_origin");
		self.e_fx_origin clientfield::set("cursetrap_fx", 1);
		self.e_fx_origin thread cursetrap_trigger(self);
	}
	else if(!isdefined(n_duration))
	{
		n_duration = RandomFloatRange(2, 5);
	}
	e_fx_origin = spawn("script_model", v_origin);
	e_fx_origin.angles = VectorScale((-1, 0, 0), 90);
	e_fx_origin SetModel("tag_origin");
	e_fx_origin clientfield::set("mini_cursetrap_fx", 1);
	e_fx_origin thread cursetrap_think(n_duration);
	e_fx_origin thread cursetrap_trigger();
	return e_fx_origin;
}

/*
	Name: cursetrap_think
	Namespace: zm_zod_shadowman
	Checksum: 0x12EB2AC
	Offset: 0x4A80
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private cursetrap_think(n_duration)
{
	wait(n_duration);
	if(isdefined(self))
	{
		if(isdefined(self.trigger))
		{
			self.trigger delete();
		}
		self delete();
	}
}

/*
	Name: function_d5ce1233
	Namespace: zm_zod_shadowman
	Checksum: 0x664FE7C0
	Offset: 0x4AE8
	Size: 0xCB
	Parameters: 1
	Flags: Private
*/
function private function_d5ce1233(player)
{
	level endon("shadowman_leaves");
	level endon("shadowman_damaged");
	self endon("hash_37a7e986");
	v_origin = self.origin;
	while(isdefined(player))
	{
		angles = VectorToAngles(player.origin - v_origin);
		n_yaw = angles[1];
		self.angles = (self.angles[0], n_yaw, self.angles[2]);
		wait(0.1);
	}
}

/*
	Name: cursetrap_trigger
	Namespace: zm_zod_shadowman
	Checksum: 0x5F3725F6
	Offset: 0x4BC0
	Size: 0x1A1
	Parameters: 1
	Flags: Private
*/
function private cursetrap_trigger(struct_ref)
{
	if(!isdefined(struct_ref))
	{
		struct_ref = undefined;
	}
	if(isdefined(struct_ref))
	{
		self.trigger = spawn("trigger_radius", self.origin, 2, 40, 50);
		continue;
	}
	self.trigger = spawn("trigger_radius", self.origin, 2, 20, 25);
	while(isdefined(self))
	{
		self.trigger waittill("trigger", guy);
		if(isdefined(self))
		{
			playFX(level._effect["cursetrap_explosion"], self.origin);
			guy playsound("zmb_zod_cursed_landmine_explode");
			guy DoDamage(guy.health / 2, guy.origin, self, self);
			if(isdefined(struct_ref))
			{
				struct_ref.active = 0;
			}
			if(isdefined(self.trigger))
			{
				self.trigger delete();
			}
			self delete();
			return;
		}
	}
}

/*
	Name: function_9cfe9b22
	Namespace: zm_zod_shadowman
	Checksum: 0x2BE6CB65
	Offset: 0x4D70
	Size: 0xCB
	Parameters: 2
	Flags: Private
*/
function private function_9cfe9b22(v_origin, v_target)
{
	e_fx = zm_zod_util::tag_origin_allocate(v_origin, (0, 0, 0));
	e_fx clientfield::set("zod_egg_soul", 1);
	e_fx moveto(v_target, 1);
	e_fx waittill("movedone");
	wait(0.25);
	e_fx clientfield::set("zod_egg_soul", 0);
	e_fx zm_zod_util::tag_origin_free();
}

/*
	Name: devgui_shadowman
	Namespace: zm_zod_shadowman
	Checksum: 0xB559A73F
	Offset: 0x4E48
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function devgui_shadowman()
{
	/#
		level thread zm_zod_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_7b5a1720);
		level thread zm_zod_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_b5732f4d);
	#/
}

/*
	Name: function_7b5a1720
	Namespace: zm_zod_shadowman
	Checksum: 0x67C08855
	Offset: 0x4ED0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_7b5a1720(n_val)
{
}

/*
	Name: function_b5732f4d
	Namespace: zm_zod_shadowman
	Checksum: 0x908703DC
	Offset: 0x4EE8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_b5732f4d(n_val)
{
	player = GetPlayers()[0];
	v_origin = player GetOrigin();
	function_ada13668(v_origin, undefined, 0);
}

