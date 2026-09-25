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

#namespace namespace_331b1e91;

/*
	Name: __init__sytem__
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
		level thread function_e4f74672();
	#/
}

/*
	Name: on_player_connect
	Namespace: namespace_331b1e91
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
	Name: function_12e7164a
	Namespace: namespace_331b1e91
	Checksum: 0x1894B472
	Offset: 0xB00
	Size: 0x1C3
	Parameters: 4
	Flags: None
*/
function function_12e7164a(var_5b35973a, var_d250bd20, var_b7791b4b, var_32a5629a)
{
	if(!isdefined(var_5b35973a))
	{
		var_5b35973a = 1;
	}
	if(!isdefined(var_d250bd20))
	{
		var_d250bd20 = 0;
	}
	if(!isdefined(var_b7791b4b))
	{
		var_b7791b4b = 0;
	}
	if(!isdefined(var_32a5629a))
	{
		var_32a5629a = 0;
	}
	self.var_93dad597 = util::spawn_model("c_zom_zod_shadowman_fb", self.origin, self.angles);
	self.var_93dad597 useanimtree(-1);
	if(!var_b7791b4b)
	{
		self.var_93dad597 clientfield::set("shadowman_fx", 1);
	}
	self.var_93dad597 playsound("zmb_shadowman_tele_in");
	self.var_93dad597.health = 1000000;
	if(var_d250bd20)
	{
		if(var_32a5629a)
		{
			self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop");
		}
		else
		{
			self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_human_stand_idle_loop");
		}
	}
	if(var_5b35973a)
	{
		self.var_93dad597 SetCanDamage(1);
	}
	else
	{
		self.var_93dad597 SetCanDamage(0);
	}
}

/*
	Name: function_8888a532
	Namespace: namespace_331b1e91
	Checksum: 0x8B8C22C0
	Offset: 0xCD0
	Size: 0x223
	Parameters: 4
	Flags: None
*/
function function_8888a532(var_5b35973a, var_d250bd20, var_2c1a0d8f, var_32a5629a)
{
	if(!isdefined(var_5b35973a))
	{
		var_5b35973a = 1;
	}
	if(!isdefined(var_d250bd20))
	{
		var_d250bd20 = 0;
	}
	if(!isdefined(var_2c1a0d8f))
	{
		var_2c1a0d8f = 0;
	}
	if(!isdefined(var_32a5629a))
	{
		var_32a5629a = 0;
	}
	self.var_5afdc7fe = util::spawn_model("c_zom_zod_shadowman_tentacles_fb", self.origin, self.angles);
	self.var_5afdc7fe useanimtree(-1);
	self.var_5afdc7fe.health = 1000000;
	self.var_5afdc7fe clientfield::set("shadowman_fx", 1);
	if(var_d250bd20)
	{
		if(var_32a5629a)
		{
			self.var_5afdc7fe thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop");
		}
		else
		{
			self.var_5afdc7fe thread animation::Play("ai_zombie_zod_shadowman_stand_idle_loop");
		}
	}
	if(var_5b35973a)
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
	Namespace: namespace_331b1e91
	Checksum: 0xA623EA10
	Offset: 0xF00
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_f25f7ff3()
{
	self.var_93dad597 clientfield::set("shadowman_fx", 2);
	self.var_93dad597 playsound("zmb_shadowman_tele_out");
	wait(0.5);
	self.var_93dad597 delete();
}

/*
	Name: function_57b6041b
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
	Checksum: 0x7EEE5CFB
	Offset: 0xFA0
	Size: 0x3C9
	Parameters: 5
	Flags: None
*/
function function_f3805c8a(var_8f0a8b6a, str_script_noteworthy, var_a21704fb, var_e033b3aa, var_f5525b44)
{
	if(!isdefined(level.var_1a2a51eb))
	{
		level.var_1a2a51eb = spawnstruct();
	}
	level.var_1a2a51eb.var_8f0a8b6a = var_8f0a8b6a;
	var_ac33ad59 = struct::get_array(var_8f0a8b6a, "targetname");
	if(level clientfield::get("ee_quest_state") === 1)
	{
		var_ac33ad59 = Array::filter(var_ac33ad59, 0, &function_726d4cc4, 0);
	}
	if(isdefined(str_script_noteworthy))
	{
		var_ac33ad59 = Array::filter(var_ac33ad59, 0, &function_69330ce7, str_script_noteworthy);
	}
	else
	{
		var_ac33ad59 = Array::randomize(var_ac33ad59);
	}
	level.var_1a2a51eb.var_7aeac9c6 = var_ac33ad59[var_ac33ad59.size - 1];
	var_2e456dd1 = level.var_1a2a51eb.var_7aeac9c6.origin;
	var_7e1ba25f = level.var_1a2a51eb.var_7aeac9c6.angles;
	level.var_1a2a51eb.var_93dad597 = spawn("script_model", var_2e456dd1);
	level.var_1a2a51eb.var_93dad597.angles = var_7e1ba25f;
	level.var_1a2a51eb.var_93dad597 SetModel("c_zom_zod_shadowman_tentacles_fb");
	level.var_1a2a51eb.var_93dad597 useanimtree(-1);
	level.var_1a2a51eb.var_93dad597 SetCanDamage(1);
	level.var_1a2a51eb.var_93dad597 clientfield::set("shadowman_fx", 1);
	level.var_1a2a51eb.var_93dad597 playsound("zmb_shadowman_tele_in");
	level.var_1a2a51eb.var_93dad597 Attach("p7_fxanim_zm_zod_redemption_key_ritual_mod", "tag_weapon_right");
	level.var_1a2a51eb.n_script_int = 0;
	level.var_1a2a51eb.str_script_noteworthy = str_script_noteworthy;
	level.var_1a2a51eb thread function_b6c7fd80();
	level.var_1a2a51eb.var_e033b3aa = var_e033b3aa;
	level.var_1a2a51eb.var_f5525b44 = var_f5525b44;
	level.var_1a2a51eb.var_a21704fb = var_a21704fb;
	level.var_1a2a51eb thread function_43eea1de();
	level.var_1a2a51eb.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, 1);
	return level.var_1a2a51eb;
}

/*
	Name: function_d04f45cf
	Namespace: namespace_331b1e91
	Checksum: 0xB394DE33
	Offset: 0x1378
	Size: 0x87
	Parameters: 3
	Flags: None
*/
function function_d04f45cf(var_a21704fb, var_e033b3aa, var_f5525b44)
{
	if(!isdefined(level.var_1a2a51eb))
	{
		return;
	}
	if(isdefined(var_e033b3aa))
	{
		level.var_1a2a51eb.var_e033b3aa = var_e033b3aa;
	}
	if(isdefined(var_f5525b44))
	{
		level.var_1a2a51eb.var_f5525b44 = var_f5525b44;
	}
	if(isdefined(var_a21704fb))
	{
		level.var_1a2a51eb.var_a21704fb = var_a21704fb;
	}
}

/*
	Name: function_e48af0db
	Namespace: namespace_331b1e91
	Checksum: 0xD062C1ED
	Offset: 0x1408
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_e48af0db()
{
	if(!isdefined(level.var_1a2a51eb))
	{
		return;
	}
	level notify("hash_a881e3fa");
	if(!isdefined(level.var_1a2a51eb.var_93dad597))
	{
		return;
	}
	var_93dad597 = level.var_1a2a51eb.var_93dad597;
	if(isdefined(var_93dad597))
	{
		var_93dad597 clientfield::set("shadowman_fx", 2);
		var_93dad597 playsound("zmb_shadowman_tele_out");
	}
	wait(0.5);
	if(isdefined(var_93dad597))
	{
		var_93dad597 delete();
	}
}

/*
	Name: function_43eea1de
	Namespace: namespace_331b1e91
	Checksum: 0x428DF4F8
	Offset: 0x14D8
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function function_43eea1de()
{
	level endon("hash_a881e3fa");
	while(1)
	{
		var_47364533 = RandomFloatRange(self.var_e033b3aa, self.var_f5525b44);
		wait(var_47364533);
		n_roll = RandomFloatRange(0, 1);
		var_6ab32645 = 0;
		foreach(var_d7d9d1b0 in self.var_a21704fb)
		{
			var_6ab32645 = var_6ab32645 + var_d7d9d1b0.probability;
			if(n_roll <= var_6ab32645)
			{
				if(!(isdefined(self.var_8abfb076) && self.var_8abfb076))
				{
					self [[var_d7d9d1b0.func]](var_d7d9d1b0.var_572b6f62);
				}
				break;
			}
		}
		self.var_a21704fb = Array::randomize(self.var_a21704fb);
	}
}

/*
	Name: function_b6c7fd80
	Namespace: namespace_331b1e91
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
	level endon("hash_a881e3fa");
	var_ac33ad59 = struct::get_array(self.var_8f0a8b6a, "targetname");
	if(isdefined(self.str_script_noteworthy))
	{
		var_ac33ad59 = Array::filter(var_ac33ad59, 0, &function_69330ce7, self.str_script_noteworthy);
	}
	else
	{
		var_ac33ad59 = Array::randomize(var_ac33ad59);
	}
	var_bac4e70 = 0;
	var_90530d3 = 0;
	self.var_8abfb076 = 0;
	while(1)
	{
		self.var_93dad597.health = 1000000;
		self.var_93dad597 waittill("damage", amount, attacker, direction_vec, point, type, tagName, modelName, partName, weapon);
		playFX(level._effect["shadowman_impact_fx"], point);
		var_90530d3 = var_90530d3 + amount;
		var_6b401aad = 0;
		for(i = 0; i < 2; i++)
		{
			var_566556d8 = GetWeapon(level.idgun[i].var_e4be281f);
			/#
				Assert(isdefined(var_566556d8));
			#/
			if(weapon === var_566556d8)
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
		self.var_8abfb076 = 1;
		level notify("hash_82a23c03");
		if(level flag::get("ee_boss_started"))
		{
			if(self.n_script_int < 8)
			{
				self.n_script_int++;
				self.var_7aeac9c6 = function_293235e9(self.var_8f0a8b6a, self.var_7aeac9c6, self.n_script_int);
			}
			var_685eb707 = 0.1;
			function_284b1884(self, self.var_7aeac9c6, var_685eb707, undefined);
			self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_captured_intro", undefined, undefined, 1);
		}
		else
		{
			var_bac4e70++;
			if(var_bac4e70 == var_ac33ad59.size)
			{
				var_ac33ad59 = Array::randomize(var_ac33ad59);
				var_bac4e70 = 0;
			}
			self.var_7aeac9c6 = var_ac33ad59[var_bac4e70];
			var_685eb707 = RandomFloatRange(5, 10);
			self.var_8abfb076 = 0;
			var_5d186a94 = level.var_6e3c8a77.origin;
			v_dir = VectorNormalize(var_5d186a94 - self.var_7aeac9c6.origin);
			v_angles = VectorToAngles(v_dir);
			function_284b1884(self, self.var_7aeac9c6, var_685eb707, v_angles);
			self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, 1);
		}
	}
}

/*
	Name: function_284b1884
	Namespace: namespace_331b1e91
	Checksum: 0x54A76C1D
	Offset: 0x1BF0
	Size: 0x17B
	Parameters: 4
	Flags: None
*/
function function_284b1884(var_dbc3a0ef, s_target, var_685eb707, v_angles)
{
	var_dbc3a0ef.var_93dad597 animation::stop();
	var_dbc3a0ef.var_93dad597 clientfield::set("shadowman_fx", 2);
	var_dbc3a0ef.var_93dad597 playsound("zmb_shadowman_tele_out");
	var_dbc3a0ef.var_93dad597 Hide();
	var_dbc3a0ef.var_93dad597.origin = s_target.origin;
	if(isdefined(v_angles))
	{
		var_dbc3a0ef.var_93dad597.angles = v_angles;
	}
	if(isdefined(var_685eb707))
	{
		wait(var_685eb707);
	}
	var_dbc3a0ef.var_93dad597 clientfield::set("shadowman_fx", 1);
	var_dbc3a0ef.var_93dad597 playsound("zmb_shadowman_tele_in");
	var_dbc3a0ef.var_93dad597 show();
}

/*
	Name: function_293235e9
	Namespace: namespace_331b1e91
	Checksum: 0xA235AD81
	Offset: 0x1D78
	Size: 0xEF
	Parameters: 3
	Flags: None
*/
function function_293235e9(var_8f0a8b6a, var_1e5c1571, n_script_int)
{
	var_ac33ad59 = struct::get_array(var_8f0a8b6a, "targetname");
	if(isdefined(var_1e5c1571))
	{
		ArrayRemoveValue(var_ac33ad59, var_1e5c1571);
	}
	if(isdefined(n_script_int))
	{
		var_ac33ad59 = Array::filter(var_ac33ad59, 0, &function_726d4cc4, n_script_int);
	}
	/#
		Assert(var_ac33ad59.size > 0);
	#/
	var_ac33ad59 = Array::randomize(var_ac33ad59);
	return var_ac33ad59[0];
}

/*
	Name: function_726d4cc4
	Namespace: namespace_331b1e91
	Checksum: 0x8C0AD48C
	Offset: 0x1E70
	Size: 0x6D
	Parameters: 2
	Flags: None
*/
function function_726d4cc4(s_loc, n_script_int)
{
	if(!isdefined(s_loc) || !isdefined(s_loc.script_int) || (!isdefined(s_loc.script_int === n_script_int) && s_loc.script_int === n_script_int))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_69330ce7
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
	Checksum: 0xA5FCE3FA
	Offset: 0x1F60
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_1c6bcf90(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8cf7b520 = "buffed_zombie_spawn_point_" + self.n_location_index;
	n_spawn_count = randomIntRange(1, 3);
	self function_52243341(var_8cf7b520, var_572b6f62, 0, n_spawn_count, 0.25, 0.5);
}

/*
	Name: function_58a299d8
	Namespace: namespace_331b1e91
	Checksum: 0x6D5CF8FE
	Offset: 0x2008
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_58a299d8(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8cf7b520 = "buffed_zombie_spawn_point_" + self.n_location_index;
	n_spawn_count = randomIntRange(3, 6);
	self function_52243341(var_8cf7b520, var_572b6f62, 0, n_spawn_count, 0.1, 0.2);
}

/*
	Name: function_8e16c7ef
	Namespace: namespace_331b1e91
	Checksum: 0x72AA8485
	Offset: 0x20B0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_8e16c7ef(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8cf7b520 = "buffed_elemental_spawn_point_" + self.n_location_index;
	self function_52243341(var_8cf7b520, var_572b6f62, 2, 1, 0.25, 0.5);
}

/*
	Name: function_801629a7
	Namespace: namespace_331b1e91
	Checksum: 0xE0C9A8AB
	Offset: 0x2130
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_801629a7(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8cf7b520 = "buffed_elemental_spawn_point_" + self.n_location_index;
	self function_52243341(var_8cf7b520, var_572b6f62, 2, 3, 0.1, 0.2);
}

/*
	Name: function_2c57b431
	Namespace: namespace_331b1e91
	Checksum: 0xD08F4F4E
	Offset: 0x21B0
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_2c57b431(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8cf7b520 = "buffed_elemental_spawn_point";
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 0)
	{
		var_8388cfbb = level.var_6e3c8a77.origin;
	}
	else
	{
	}
	self function_52243341(var_8cf7b520, var_572b6f62, 2, 1, 0.25, 0.5, var_8388cfbb);
}

/*
	Name: function_6e618ab9
	Namespace: namespace_331b1e91
	Checksum: 0xD643ABBF
	Offset: 0x2290
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_6e618ab9(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8cf7b520 = "buffed_elemental_spawn_point";
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 0)
	{
		var_8388cfbb = level.var_6e3c8a77.origin;
	}
	else
	{
	}
	self function_52243341(var_8cf7b520, var_572b6f62, 2, 3, 0.1, 0.2, var_8388cfbb);
}

/*
	Name: function_4a41b207
	Namespace: namespace_331b1e91
	Checksum: 0x1E5B4926
	Offset: 0x2370
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function function_4a41b207(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_8388cfbb = level.var_6e3c8a77.origin;
	self function_a3821eb5(var_572b6f62);
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
	Namespace: namespace_331b1e91
	Checksum: 0x5638B6AB
	Offset: 0x24B0
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function function_c073c1e6(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_32cbfe17 = [];
	var_10284ef9 = namespace_8e578893::function_15166300(4);
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
		var_b37e00f9 = Array::random(var_32cbfe17);
		self [[var_b37e00f9]](var_572b6f62);
	}
}

/*
	Name: function_b4b792ef
	Namespace: namespace_331b1e91
	Checksum: 0x394CF1DF
	Offset: 0x25C8
	Size: 0x261
	Parameters: 1
	Flags: None
*/
function function_b4b792ef(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_2c563e77 = namespace_8e578893::function_15166300(1);
	var_57689abe = namespace_8e578893::function_15166300(3);
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
	var_b37e00f9 = Array::random(var_32cbfe17);
	self [[var_b37e00f9]](var_572b6f62);
}

/*
	Name: function_c94f30a2
	Namespace: namespace_331b1e91
	Checksum: 0x4E43E85C
	Offset: 0x2838
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_c94f30a2(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_2c563e77 = namespace_8e578893::function_15166300(1);
	n_spawn_count = min(var_2c563e77, 8);
	self function_52243341("spawn_point_boss_fight", var_572b6f62, 0, n_spawn_count, 5, 8);
}

/*
	Name: function_45c7d9eb
	Namespace: namespace_331b1e91
	Checksum: 0x457AC59F
	Offset: 0x28E8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_45c7d9eb(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_57689abe = namespace_8e578893::function_15166300(3);
	n_spawn_count = min(var_57689abe, 5);
	self function_52243341("spawn_point_boss_fight", var_572b6f62, 2, n_spawn_count, 5, 8);
}

/*
	Name: function_32e7f676
	Namespace: namespace_331b1e91
	Checksum: 0xD09B5665
	Offset: 0x29A0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_32e7f676(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	var_10284ef9 = namespace_8e578893::function_15166300(4);
	n_spawn_count = min(var_10284ef9, 1);
	self function_52243341("spawn_point_boss_fight", var_572b6f62, 3, n_spawn_count, 5, 8);
}

/*
	Name: function_fcd226a8
	Namespace: namespace_331b1e91
	Checksum: 0xA17C21E7
	Offset: 0x2A58
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function function_fcd226a8(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	self function_a3821eb5(var_572b6f62);
	var_9eb45ed3 = Array("boxer", "detective", "femme", "magician");
	var_d7e2a718 = Array::random(var_9eb45ed3);
	level clientfield::set("ee_keeper_" + var_d7e2a718 + "_state", 6);
	wait(var_572b6f62);
}

/*
	Name: function_e44c4f1b
	Namespace: namespace_331b1e91
	Checksum: 0x73F4303C
	Offset: 0x2B30
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function function_e44c4f1b(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	self function_a3821eb5(var_572b6f62);
	var_9eb45ed3 = Array("boxer", "detective", "femme", "magician");
	foreach(var_d7e2a718 in var_9eb45ed3)
	{
		level clientfield::set("ee_keeper_" + var_d7e2a718 + "_state", 6);
	}
	wait(var_572b6f62);
}

/*
	Name: function_52243341
	Namespace: namespace_331b1e91
	Checksum: 0x3B8CFA68
	Offset: 0x2C50
	Size: 0xB3
	Parameters: 8
	Flags: None
*/
function function_52243341(var_8cf7b520, var_572b6f62, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb, s_target)
{
	if(!isdefined(var_cbdd21c0))
	{
		var_cbdd21c0 = 0;
	}
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	self function_a3821eb5(var_572b6f62);
	self function_1bd7a0f4(var_8cf7b520, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb);
}

/*
	Name: function_a3821eb5
	Namespace: namespace_331b1e91
	Checksum: 0x9DECCC24
	Offset: 0x2D10
	Size: 0x35B
	Parameters: 2
	Flags: None
*/
function function_a3821eb5(var_572b6f62, var_8fc8c481)
{
	if(!isdefined(var_8fc8c481))
	{
		var_8fc8c481 = 1;
	}
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	self.var_93dad597 animation::stop();
	self.var_93dad597 clientfield::set("shadowman_fx", 3);
	self.var_93dad597 playsound("zmb_shadowman_spell_start");
	self.var_93dad597 PlayLoopSound("zmb_shadowman_spell_loop", 0.75);
	self.var_93dad597 ClearAnim("ai_zombie_zod_shadowman_float_idle_loop", 0);
	self.var_93dad597 animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_intro", undefined, undefined, var_8fc8c481);
	player = level.activePlayers[0];
	self.var_93dad597 animation::stop();
	self.var_93dad597 clientfield::set("shadowman_fx", 4);
	self.var_93dad597 ClearAnim("ai_zombie_zod_shadowman_float_attack_aoe_charge_intro", 0);
	self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_loop", undefined, undefined, var_8fc8c481);
	level thread namespace_8e578893::function_3a7a7013(5, 1024, self.var_93dad597.origin, var_572b6f62);
	wait(var_572b6f62);
	self.var_93dad597 animation::stop();
	self.var_93dad597 clientfield::set("shadowman_fx", 5);
	self.var_93dad597 StopLoopSound(0.1);
	self.var_93dad597 playsound("zmb_shadowman_spell_cast");
	self.var_93dad597 ClearAnim("ai_zombie_zod_shadowman_float_attack_aoe_charge_loop", 0);
	self.var_93dad597 animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_deploy", undefined, undefined, var_8fc8c481);
	level thread namespace_8e578893::function_3a7a7013(6, 1024, self.var_93dad597.origin, 1);
	self.var_93dad597 clientfield::set("shadowman_fx", 6);
	self.var_93dad597 ClearAnim("ai_zombie_zod_shadowman_float_attack_aoe_deploy", 0);
	self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, var_8fc8c481);
}

/*
	Name: function_bd35f3d6
	Namespace: namespace_331b1e91
	Checksum: 0x154F9793
	Offset: 0x3078
	Size: 0x293
	Parameters: 1
	Flags: None
*/
function function_bd35f3d6(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	self.var_93dad597 clientfield::set("shadowman_fx", 3);
	self.var_93dad597 playsound("zmb_shadowman_spell_start");
	self.var_93dad597 PlayLoopSound("zmb_shadowman_spell_loop", 0.75);
	self.var_93dad597 animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_intro", undefined, undefined);
	player = level.activePlayers[0];
	self.var_93dad597 animation::stop();
	self.var_93dad597 clientfield::set("shadowman_fx", 4);
	self.var_93dad597 thread animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_charge_loop", undefined, undefined);
	level thread namespace_8e578893::function_3a7a7013(5, 1024, self.var_93dad597.origin, var_572b6f62);
	wait(var_572b6f62);
	self.var_93dad597 animation::stop();
	self.var_93dad597 clientfield::set("shadowman_fx", 5);
	self.var_93dad597 StopLoopSound(0.1);
	self.var_93dad597 playsound("zmb_shadowman_spell_cast");
	self.var_93dad597 animation::Play("ai_zombie_zod_shadowman_float_attack_aoe_deploy", undefined, undefined);
	level thread namespace_8e578893::function_3a7a7013(6, 1024, self.var_93dad597.origin, 1);
	self.var_93dad597 clientfield::set("shadowman_fx", 6);
	self function_80fd208e(self.n_location_index);
}

/*
	Name: function_3803c75b
	Namespace: namespace_331b1e91
	Checksum: 0xD51C5B7B
	Offset: 0x3318
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_3803c75b(var_572b6f62)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
	self.var_93dad597 thread animation::Play("ai_zombie_zod_keeper_give_me_sword_intro", undefined, undefined, var_572b6f62);
	wait(var_572b6f62);
	player = GetPlayers()[0];
	v_origin = player GetOrigin();
	function_ada13668(v_origin, undefined, 0);
}

/*
	Name: function_1bd7a0f4
	Namespace: namespace_331b1e91
	Checksum: 0x9C6FCB6E
	Offset: 0x33D8
	Size: 0x1CF
	Parameters: 6
	Flags: None
*/
function function_1bd7a0f4(var_8cf7b520, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb)
{
	var_ac33ad59 = struct::get_array(var_8cf7b520, "targetname");
	var_ac33ad59 = Array::randomize(var_ac33ad59);
	v_origin = self.var_93dad597.origin;
	for(i = 0; i < n_spawn_count; i++)
	{
		v_target = var_ac33ad59[i].origin;
		switch(var_cbdd21c0)
		{
			case 0:
			{
				self thread function_1063429a(var_ac33ad59[i]);
				break;
			}
			case 1:
			{
				self thread function_4ef376eb(var_ac33ad59[i]);
				break;
			}
			case 2:
			{
				self thread function_7a4cf63(var_ac33ad59[i], var_8388cfbb);
				break;
			}
			case 3:
			{
				self thread namespace_d17e1da0::function_8bcb72e9(0, var_ac33ad59[i]);
				break;
			}
		}
		var_dc7b7a0f = RandomFloatRange(var_58655a9e, var_ab3cc960);
		wait(var_dc7b7a0f);
	}
}

/*
	Name: function_1063429a
	Namespace: namespace_331b1e91
	Checksum: 0xBD2883FF
	Offset: 0x35B0
	Size: 0x1D3
	Parameters: 1
	Flags: None
*/
function function_1063429a(var_7aeac9c6)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	var_7a88c258 = spawn("script_model", var_7aeac9c6.origin);
	var_7a88c258 SetModel("tag_origin");
	var_7a88c258 clientfield::set("darkportal_fx", 1);
	var_7a88c258 playsound("evt_keeper_portal_start");
	var_7a88c258 PlayLoopSound("evt_keeper_portal_loop", 1.2);
	self thread function_82fc1cb2(var_7a88c258);
	wait(0.5);
	ai = zombie_utility::spawn_zombie(var_42513f6e, "buffed_zombie", var_7aeac9c6);
	ai thread function_27bb9b3b();
	ai thread function_827ad6f();
	ai.n_location_index = self.n_location_index;
	wait(3);
	var_7a88c258 clientfield::set("darkportal_fx", 0);
	var_7a88c258 playsound("evt_keeper_portal_end");
	var_7a88c258 delete();
}

/*
	Name: function_4ef376eb
	Namespace: namespace_331b1e91
	Checksum: 0xC1C972E0
	Offset: 0x3790
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function function_4ef376eb(var_7aeac9c6)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	var_aaefedf3 = zombie_utility::spawn_zombie(level.wasp_spawners[0], "buffed_parasite", var_7aeac9c6);
	if(isdefined(var_aaefedf3))
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
		level.var_27fa160f[level.var_27fa160f.size] = var_aaefedf3;
		var_aaefedf3.favoriteenemy = Array::random(level.activePlayers);
		level thread zm_ai_wasp::wasp_spawn_init(var_aaefedf3, var_7aeac9c6.origin);
	}
}

/*
	Name: function_33ddc9ed
	Namespace: namespace_331b1e91
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
		var_15b740f0 = undefined;
		while(!isdefined(var_15b740f0))
		{
			var_15b740f0 = function_479785a0(n_location_index);
			wait(0.1);
		}
		var_15b740f0.var_70ac16f8 = 1;
		wait(5);
		self vehicle_ai::set_state("scripted");
		goal = self GetClosestPointOnNavVolume(var_15b740f0.origin + VectorScale((0, 0, 1), 32), 50);
		self SetVehGoalPos(goal, 0, 1);
		self waittill("goal");
		if(isdefined(var_15b740f0.var_9a8117f3) && var_15b740f0.var_9a8117f3)
		{
			var_15b740f0.buff = 1;
			var_15b740f0.var_7a88c258 = spawn("script_model", var_15b740f0.origin);
			var_15b740f0.var_7a88c258 SetModel("tag_origin");
			var_15b740f0.var_7a88c258 clientfield::set("curse_tell_fx", 1);
		}
	}
}

/*
	Name: function_80fd208e
	Namespace: namespace_331b1e91
	Checksum: 0xDBCB2A09
	Offset: 0x3AA8
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_80fd208e(n_location_index)
{
	var_15b740f0 = function_479785a0(n_location_index);
	if(!isdefined(var_15b740f0))
	{
		return;
	}
	var_15b740f0.buff = 1;
	var_15b740f0.var_7a88c258 = spawn("script_model", var_15b740f0.origin);
	var_15b740f0.var_7a88c258 SetModel("tag_origin");
	var_15b740f0.var_7a88c258 PlayLoopSound("evt_pod_plague_magic_lp", 1);
	var_15b740f0.var_7a88c258 clientfield::set("curse_tell_fx", 1);
}

/*
	Name: function_479785a0
	Namespace: namespace_331b1e91
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
	var_15b740f0 = Array::random(var_c0eb23cc);
	return var_15b740f0;
}

/*
	Name: function_9edae260
	Namespace: namespace_331b1e91
	Checksum: 0x49F55BE3
	Offset: 0x3C80
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_9edae260(var_15b740f0)
{
	if(!isdefined(var_15b740f0) || (isdefined(var_15b740f0.var_70ac16f8) && var_15b740f0.var_70ac16f8) || (isdefined(var_15b740f0.buff) && var_15b740f0.buff) || (!isdefined(var_15b740f0.growing) && var_15b740f0.growing))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_7a4cf63
	Namespace: namespace_331b1e91
	Checksum: 0x66DFF0A7
	Offset: 0x3D18
	Size: 0x193
	Parameters: 2
	Flags: None
*/
function function_7a4cf63(var_7aeac9c6, var_8388cfbb)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	var_3e32f05a = zombie_utility::spawn_zombie(level.raps_spawners[0], "buffed_elemental", var_7aeac9c6);
	if(isdefined(var_3e32f05a))
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
		level.var_35fcee79[level.var_35fcee79.size] = var_3e32f05a;
		var_3e32f05a clientfield::set("veh_status_fx", 2);
		var_3e32f05a.favoriteenemy = Array::random(level.activePlayers);
		var_7aeac9c6 thread zm_ai_raps::raps_spawn_fx(var_3e32f05a, var_7aeac9c6);
		if(isdefined(var_8388cfbb))
		{
			var_3e32f05a thread function_4a3d00d6(var_8388cfbb);
		}
	}
}

/*
	Name: function_4a3d00d6
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
	Checksum: 0x21D8AC33
	Offset: 0x4010
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_82fc1cb2(var_7a88c258)
{
	level endon("hash_a881e3fa");
	level waittill("hash_82a23c03");
	if(isdefined(var_7a88c258))
	{
		var_7a88c258 clientfield::set("darkportal_fx", 0);
		var_7a88c258 playsound("evt_keeper_portal_end");
		var_7a88c258 delete();
	}
}

/*
	Name: function_27bb9b3b
	Namespace: namespace_331b1e91
	Checksum: 0xC78576EA
	Offset: 0x40A0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function function_27bb9b3b()
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
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
	var_bc0b7719 = var_8661a082 - var_e1b2953e;
	var_4162cc72 = Abs(var_bc0b7719);
	for(i = 0; i < var_4162cc72; i++)
	{
		if(var_bc0b7719 > 0)
		{
			var_5543272f[i].active = 1;
			continue;
		}
		if(var_bc0b7719 < 0)
		{
			var_9e546be[i].active = 0;
		}
	}
}

/*
	Name: function_6ceb834f
	Namespace: namespace_331b1e91
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
				if(!isdefined(var_c2099ecc.var_7a88c258))
				{
					var_c2099ecc thread function_ada13668(var_c2099ecc.origin, undefined, 1, 1);
				}
				continue;
			}
			if(isdefined(var_c2099ecc.var_7a88c258))
			{
				if(isdefined(var_c2099ecc.var_7a88c258.trigger))
				{
					var_c2099ecc.var_7a88c258.trigger delete();
				}
				var_c2099ecc.var_7a88c258 delete();
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_ab84e253
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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
		self.var_7a88c258 = spawn("script_model", v_origin);
		self.var_7a88c258.angles = VectorScale((-1, 0, 0), 90);
		self.var_7a88c258 SetModel("tag_origin");
		self.var_7a88c258 clientfield::set("cursetrap_fx", 1);
		self.var_7a88c258 thread function_48fccb59(self);
	}
	else if(!isdefined(n_duration))
	{
		n_duration = RandomFloatRange(2, 5);
	}
	var_7a88c258 = spawn("script_model", v_origin);
	var_7a88c258.angles = VectorScale((-1, 0, 0), 90);
	var_7a88c258 SetModel("tag_origin");
	var_7a88c258 clientfield::set("mini_cursetrap_fx", 1);
	var_7a88c258 thread function_57b55fe1(n_duration);
	var_7a88c258 thread function_48fccb59();
	return var_7a88c258;
}

/*
	Name: function_57b55fe1
	Namespace: namespace_331b1e91
	Checksum: 0x12EB2AC
	Offset: 0x4A80
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private function_57b55fe1(n_duration)
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
	Namespace: namespace_331b1e91
	Checksum: 0x664FE7C0
	Offset: 0x4AE8
	Size: 0xCB
	Parameters: 1
	Flags: Private
*/
function private function_d5ce1233(player)
{
	level endon("hash_a881e3fa");
	level endon("hash_82a23c03");
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
	Name: function_48fccb59
	Namespace: namespace_331b1e91
	Checksum: 0x5F3725F6
	Offset: 0x4BC0
	Size: 0x1A1
	Parameters: 1
	Flags: Private
*/
function private function_48fccb59(var_7478a6b4)
{
	if(!isdefined(var_7478a6b4))
	{
		var_7478a6b4 = undefined;
	}
	if(isdefined(var_7478a6b4))
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
			if(isdefined(var_7478a6b4))
			{
				var_7478a6b4.active = 0;
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
	Namespace: namespace_331b1e91
	Checksum: 0x2BE6CB65
	Offset: 0x4D70
	Size: 0xCB
	Parameters: 2
	Flags: Private
*/
function private function_9cfe9b22(v_origin, v_target)
{
	e_fx = namespace_8e578893::function_6c995606(v_origin, (0, 0, 0));
	e_fx clientfield::set("zod_egg_soul", 1);
	e_fx moveto(v_target, 1);
	e_fx waittill("movedone");
	wait(0.25);
	e_fx clientfield::set("zod_egg_soul", 0);
	e_fx namespace_8e578893::function_44a841();
}

/*
	Name: function_e4f74672
	Namespace: namespace_331b1e91
	Checksum: 0xB559A73F
	Offset: 0x4E48
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_e4f74672()
{
	/#
		level thread namespace_8e578893::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_7b5a1720);
		level thread namespace_8e578893::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_b5732f4d);
	#/
}

/*
	Name: function_7b5a1720
	Namespace: namespace_331b1e91
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
	Namespace: namespace_331b1e91
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

