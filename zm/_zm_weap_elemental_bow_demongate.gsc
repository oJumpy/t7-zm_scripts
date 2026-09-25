#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
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
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weapons;

#namespace namespace_efd1ef23;

/*
	Name: __init__sytem__
	Namespace: namespace_efd1ef23
	Checksum: 0x4F5F348B
	Offset: 0x5A0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_demongate", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_efd1ef23
	Checksum: 0x4C9C1D0A
	Offset: 0x5E8
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_edf1e590 = GetWeapon("elemental_bow_demongate");
	level.var_e106fba5 = GetWeapon("elemental_bow_demongate4");
	level.var_ecd0c077 = [];
	clientfield::register("toplayer", "elemental_bow_demongate" + "_ambient_bow_fx", 5000, 1, "int");
	clientfield::register("missile", "elemental_bow_demongate" + "_arrow_impact_fx", 5000, 1, "int");
	clientfield::register("missile", "elemental_bow_demongate4" + "_arrow_impact_fx", 5000, 1, "int");
	clientfield::register("scriptmover", "demongate_portal_fx", 5000, 1, "int");
	clientfield::register("toplayer", "demongate_portal_rumble", 1, 1, "int");
	clientfield::register("scriptmover", "demongate_wander_locomotion_anim", 5000, 1, "int");
	clientfield::register("scriptmover", "demongate_attack_locomotion_anim", 5000, 1, "int");
	clientfield::register("scriptmover", "demongate_chomper_fx", 5000, 1, "int");
	clientfield::register("scriptmover", "demongate_chomper_bite_fx", 5000, 1, "counter");
}

/*
	Name: __main__
	Namespace: namespace_efd1ef23
	Checksum: 0xC5337F97
	Offset: 0x810
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __main__()
{
	callback::on_connect(&function_71c07c9d);
}

/*
	Name: function_71c07c9d
	Namespace: namespace_efd1ef23
	Checksum: 0x215A5E0C
	Offset: 0x840
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_71c07c9d()
{
	self thread zm_weap_elemental_bow::function_982419bb("elemental_bow_demongate");
	self thread zm_weap_elemental_bow::function_ececa597("elemental_bow_demongate", "elemental_bow_demongate4");
	self thread zm_weap_elemental_bow::function_7bc6b9d("elemental_bow_demongate", "elemental_bow_demongate4", &function_7e0efd7);
}

/*
	Name: function_7e0efd7
	Namespace: namespace_efd1ef23
	Checksum: 0x265B0D8
	Offset: 0x8C8
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function function_7e0efd7(weapon, position, radius, attacker, normal)
{
	if(weapon.name == "elemental_bow_demongate4")
	{
		self thread function_19575106(weapon, position, attacker, normal);
	}
	else
	{
		attacker clientfield::set("elemental_bow_demongate" + "_arrow_impact_fx", 1);
		self thread function_ee626351(position, attacker);
	}
}

/*
	Name: function_95ad1040
	Namespace: namespace_efd1ef23
	Checksum: 0x1328B127
	Offset: 0x990
	Size: 0x16B
	Parameters: 2
	Flags: None
*/
function function_95ad1040(var_be00572f, var_c211b5bb)
{
	if(Abs(var_c211b5bb[2]) < 0.2)
	{
		var_be00572f = var_be00572f + var_c211b5bb * 16;
		a_trace = bullettrace(var_be00572f, var_be00572f + VectorScale((0, 0, 1), 64), 0, undefined);
		if(a_trace["fraction"] < 1)
		{
			var_be00572f = a_trace["position"] - VectorScale((0, 0, 1), 64);
		}
		a_trace = bullettrace(var_be00572f, var_be00572f - VectorScale((0, 0, 1), 64), 0, undefined);
		if(a_trace["fraction"] < 1)
		{
			var_be00572f = a_trace["position"] + VectorScale((0, 0, 1), 64);
		}
	}
	else
	{
		var_85a9344d = var_c211b5bb[2] * 64;
		var_be00572f = var_be00572f + (0, 0, var_85a9344d);
	}
	return var_be00572f;
}

/*
	Name: function_19575106
	Namespace: namespace_efd1ef23
	Checksum: 0x75A0AA85
	Offset: 0xB08
	Size: 0x3C3
	Parameters: 4
	Flags: None
*/
function function_19575106(weapon, position, attacker, normal)
{
	position = function_95ad1040(position, normal);
	var_884470ed = VectorToAngles(normal);
	var_884470ed = var_884470ed + VectorScale((0, 1, 0), 90);
	var_884470ed = var_884470ed * (0, 1, 0);
	var_e1784c2b = util::spawn_model("tag_origin", position, var_884470ed);
	var_e1784c2b clientfield::set("demongate_portal_fx", 1);
	var_e1784c2b.var_a5e3922a = 1;
	RadiusDamage(position, 96, level.zombie_health, level.zombie_health, self, "MOD_UNKNOWN", level.var_e106fba5);
	wait(0.25);
	var_e1784c2b thread function_292e5297();
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		var_76d7100b = 4 * level.zombie_health;
	}
	else
	{
		var_76d7100b = 2 * level.zombie_health;
	}
	if(level.var_ecd0c077.size > 12)
	{
		var_33efb6fa = 2;
	}
	else
	{
		var_33efb6fa = Int(zombie_utility::get_current_zombie_count() + level.zombie_total * level.zombie_health / var_76d7100b);
		if(GetDvarInt("splitscreen_playerCount") > 2)
		{
			var_33efb6fa = math::clamp(var_33efb6fa, 4, 4);
		}
		else
		{
			var_33efb6fa = math::clamp(var_33efb6fa, 4, 6);
		}
	}
	var_c93049d7 = 0;
	for(i = 0; i < var_33efb6fa; i++)
	{
		var_963441bd[i] = function_a9eddc64(position, var_884470ed - VectorScale((0, 1, 0), 90), i);
		var_963441bd[i] thread function_a3e439a5(self, position);
		n_wait_time = 0.1;
		var_c93049d7 = var_c93049d7 + n_wait_time;
		wait(n_wait_time);
	}
	if(var_c93049d7 < 2)
	{
		wait(2 - var_c93049d7);
	}
	wait(2.5);
	var_e1784c2b clientfield::set("demongate_portal_fx", 0);
	wait(2);
	var_e1784c2b notify("hash_d6e52217");
	var_e1784c2b.var_a5e3922a = 0;
	wait(1.6);
	var_e1784c2b delete();
}

/*
	Name: function_292e5297
	Namespace: namespace_efd1ef23
	Checksum: 0x1EADFA4C
	Offset: 0xED8
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function function_292e5297()
{
	self endon("hash_d6e52217");
	while(1)
	{
		foreach(e_player in level.activePlayers)
		{
			if(isdefined(e_player) && (!isdefined(e_player.var_fbdab725) && e_player.var_fbdab725))
			{
				if(DistanceSquared(e_player.origin, self.origin) < 9216)
				{
					e_player thread function_3f55c7ab(self);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_3f55c7ab
	Namespace: namespace_efd1ef23
	Checksum: 0xB6E29C02
	Offset: 0xFF0
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_3f55c7ab(var_e1784c2b)
{
	self endon("disconnect");
	self endon("bled_out");
	self.var_fbdab725 = 1;
	self clientfield::set_to_player("demongate_portal_rumble", 1);
	while(DistanceSquared(self.origin, var_e1784c2b.origin) < 9216 && (isdefined(var_e1784c2b.var_a5e3922a) && var_e1784c2b.var_a5e3922a))
	{
		wait(0.05);
	}
	self.var_fbdab725 = 0;
	self clientfield::set_to_player("demongate_portal_rumble", 0);
}

/*
	Name: function_ee626351
	Namespace: namespace_efd1ef23
	Checksum: 0x1F897BFF
	Offset: 0x10E0
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function function_ee626351(position, attacker)
{
	v_angles = AnglesToForward(attacker.angles) * -1;
	var_7119a95d = function_a9eddc64(position, v_angles);
	wait(0.1);
	var_7119a95d thread function_ab77890b(self);
}

/*
	Name: function_a9eddc64
	Namespace: namespace_efd1ef23
	Checksum: 0xBEDA3C73
	Offset: 0x1180
	Size: 0x2E5
	Parameters: 3
	Flags: None
*/
function function_a9eddc64(position, v_angles, n_count)
{
	if(!isdefined(n_count))
	{
		n_count = 1;
	}
	var_7119a95d = util::spawn_model("c_zom_chomper", position, v_angles);
	var_7119a95d clientfield::set("demongate_chomper_fx", 1);
	var_7119a95d flag::init("chomper_attacking");
	var_7119a95d flag::init("demongate_chomper_despawning");
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		var_76d7100b = 4 * level.zombie_health;
	}
	else
	{
		var_76d7100b = 2 * level.zombie_health;
	}
	var_7119a95d.var_fcd07456 = var_76d7100b;
	var_7119a95d.var_603f1f19 = 1;
	var_7119a95d thread function_1d3c583d();
	var_b194ff34 = 0;
	var_5f2cce52 = level.var_ecd0c077.size - 12;
	if(var_5f2cce52 > 0)
	{
		foreach(var_c7cc4fbd in level.var_ecd0c077)
		{
			if(!var_c7cc4fbd flag::get("chomper_attacking") && (!isdefined(var_c7cc4fbd.var_e3146903) && var_c7cc4fbd.var_e3146903))
			{
				var_c7cc4fbd.n_timer = 3;
				var_b194ff34++;
				if(var_b194ff34 > var_5f2cce52)
				{
					break;
				}
			}
		}
	}
	else if(!isdefined(level.var_ecd0c077))
	{
		level.var_ecd0c077 = [];
	}
	else if(!IsArray(level.var_ecd0c077))
	{
		level.var_ecd0c077 = Array(level.var_ecd0c077);
	}
	level.var_ecd0c077[level.var_ecd0c077.size] = var_7119a95d;
	return var_7119a95d;
}

/*
	Name: function_308e6c6f
	Namespace: namespace_efd1ef23
	Checksum: 0x76ED9161
	Offset: 0x1470
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function function_308e6c6f()
{
	self flag::set("demongate_chomper_despawning");
	if(!(isdefined(self.var_dd49270d) && self.var_dd49270d))
	{
		self.var_dd49270d = 1;
		if(!isdefined(level.var_a9ac7b97))
		{
			level.var_a9ac7b97 = GetTime();
		}
		else if(level.var_a9ac7b97 == GetTime())
		{
			wait(RandomFloatRange(0.1, 0.2));
		}
		level.var_a9ac7b97 = GetTime();
		self moveto(self.origin + VectorScale((0, 0, 1), 96), 1.4);
		self RotatePitch(-90, 0.4);
		wait(1.4);
		self moveto(self.origin, 0.1);
		self clientfield::set("demongate_chomper_fx", 0);
		wait(3);
		self notify("hash_16664ab4");
		level.var_ecd0c077 = Array::exclude(level.var_ecd0c077, self);
		self delete();
	}
}

/*
	Name: function_1d3c583d
	Namespace: namespace_efd1ef23
	Checksum: 0x2752D0B1
	Offset: 0x1610
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_1d3c583d()
{
	self endon("hash_72391651");
	self.n_timer = 0;
	while(self.n_timer < 3)
	{
		if(!self flag::get("chomper_attacking") && (!isdefined(self.var_e3146903) && self.var_e3146903))
		{
			self.n_timer = self.n_timer + 0.05;
		}
		wait(0.05);
	}
	while(self flag::get("chomper_attacking"))
	{
		wait(0.1);
	}
	self thread function_308e6c6f();
}

/*
	Name: function_a3e439a5
	Namespace: namespace_efd1ef23
	Checksum: 0x6CDC63A6
	Offset: 0x16F0
	Size: 0x17B
	Parameters: 2
	Flags: None
*/
function function_a3e439a5(e_player, var_67eb721b)
{
	self.var_e3146903 = 1;
	self.origin = self.origin + (0, 0, randomIntRange(Int(-51.2), Int(51.2)));
	self.angles = (self.angles[0] + randomIntRange(-30, 30), self.angles[1] + randomIntRange(-45, 45), self.angles[2]);
	var_69a783ad = self.origin + AnglesToForward(self.angles) * 96;
	self.angles = (0, self.angles[1], 0);
	self moveto(var_69a783ad, 0.4);
	wait(0.4);
	self.var_e3146903 = 0;
	self function_ab77890b(e_player);
}

/*
	Name: function_ab77890b
	Namespace: namespace_efd1ef23
	Checksum: 0xE7335538
	Offset: 0x1878
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_ab77890b(e_player)
{
	self function_99d2c8aa(e_player);
	if(isdefined(self.var_4288770f))
	{
		self function_b6e7ec91(e_player);
	}
	else
	{
		self thread function_9fcea3e8(e_player);
	}
}

/*
	Name: function_9fcea3e8
	Namespace: namespace_efd1ef23
	Checksum: 0xF57A9E45
	Offset: 0x18F0
	Size: 0x4D3
	Parameters: 1
	Flags: None
*/
function function_9fcea3e8(e_player)
{
	self endon("hash_72391651");
	self endon("death");
	if(!isdefined(self))
	{
		return;
	}
	if(self flag::get("demongate_chomper_despawning"))
	{
		return;
	}
	self flag::clear("chomper_attacking");
	self clientfield::set("demongate_wander_locomotion_anim", 1);
	var_13fe538c = RandomFloatRange(5, 15);
	var_3a00cdf5 = RandomFloatRange(15, 45);
	var_6003485e = RandomFloatRange(15, 45);
	if(RandomInt(100) < 50)
	{
	}
	else
	{
	}
	var_13fe538c = var_13fe538c * -1;
	if(RandomInt(100) < 50)
	{
	}
	else
	{
	}
	var_3a00cdf5 = var_3a00cdf5 * -1;
	if(RandomInt(100) < 50)
	{
	}
	else
	{
	}
	var_6003485e = var_6003485e * -1;
	if(zm_utility::is_player_valid(e_player))
	{
		var_6073ac1c = e_player.angles;
		var_150aaea = e_player GetEye();
	}
	else
	{
		var_6073ac1c = self.angles;
		var_150aaea = self.origin;
	}
	var_9ef67615 = (var_6073ac1c[0] + var_13fe538c, var_6073ac1c[1] + var_3a00cdf5, var_6073ac1c[2] + var_6003485e);
	var_962558f1 = VectorNormalize(AnglesToForward(var_9ef67615));
	a_trace = PhysicsTraceEx(var_150aaea, var_150aaea + var_962558f1 * 512, VectorScale((-1, -1, -1), 16), VectorScale((1, 1, 1), 16));
	var_69a783ad = a_trace["position"] + var_962558f1 * -32;
	n_dist = Distance(self.origin, var_69a783ad);
	n_time = n_dist / 48;
	var_d1979001 = var_69a783ad - self.origin;
	var_d1979001 = (0, var_d1979001[1], 0);
	if(!isdefined(level.var_a9ac7b97))
	{
		level.var_a9ac7b97 = GetTime();
	}
	else if(level.var_a9ac7b97 == GetTime())
	{
		wait(RandomFloatRange(0.1, 0.2));
	}
	level.var_a9ac7b97 = GetTime();
	self moveto(var_69a783ad, n_time);
	self RotateTo(VectorToAngles(var_d1979001), n_time * 0.5);
	self thread function_f9dd2ee2(e_player);
	self util::waittill_any_timeout(n_time * 2, "movedone", "demongate_chomper_found_target", "demongate_chomper_despawning", "death");
	if(isdefined(self.var_4288770f))
	{
		self clientfield::set("demongate_wander_locomotion_anim", 0);
		self function_b6e7ec91(e_player);
	}
	else
	{
		self thread function_9fcea3e8(e_player);
	}
}

/*
	Name: function_f9dd2ee2
	Namespace: namespace_efd1ef23
	Checksum: 0x26065A57
	Offset: 0x1DD0
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function function_f9dd2ee2(e_player)
{
	self endon("hash_72391651");
	self endon("hash_7b23407");
	self endon("movedone");
	self endon("death");
	while(!isdefined(self.var_4288770f))
	{
		wait(0.2);
		self thread function_99d2c8aa(e_player);
	}
}

/*
	Name: function_b6e7ec91
	Namespace: namespace_efd1ef23
	Checksum: 0xE3E2A7AF
	Offset: 0x1E48
	Size: 0x2CB
	Parameters: 1
	Flags: None
*/
function function_b6e7ec91(e_player)
{
	var_c32fcb8f = self.var_4288770f.health;
	self function_5dee133f();
	if(zm_weap_elemental_bow::function_5aec3adc(self.var_4288770f))
	{
		var_aad66aa4 = randomIntRange(1, 7);
		var_7364b0dd = self.var_4288770f.missingLegs;
		self.var_4288770f.var_98056717 = 1;
		self.var_603f1f19 = 0;
		self.var_fcd07456 = self.var_fcd07456 - var_c32fcb8f;
		self thread function_3c03253d(var_aad66aa4, var_7364b0dd);
		self thread function_3a5a56c7();
		self thread function_67903a83(e_player);
		if(isdefined(self.var_4288770f.isdog) && self.var_4288770f.isdog || isVehicle(self.var_4288770f))
		{
			n_wait_time = 0.8;
		}
		else if(self.var_4288770f.archetype === "mechz")
		{
			n_wait_time = 2.6;
			self.var_fcd07456 = 0;
		}
		else
		{
			n_wait_time = RandomFloatRange(2, 3);
			self.var_4288770f SetPlayerCollision(0);
		}
		self.var_4288770f util::waittill_notify_or_timeout("death", n_wait_time);
		self notify("hash_368634cd");
		self function_43415734(var_aad66aa4, var_7364b0dd);
		if(self.var_fcd07456 < 1)
		{
			self thread function_308e6c6f();
			return;
		}
	}
	else if(isdefined(self.var_4288770f))
	{
		self.var_4288770f.var_bc9b5fbd = 0;
	}
	self flag::clear("chomper_attacking");
	self thread function_ab77890b(e_player);
}

/*
	Name: function_3a5a56c7
	Namespace: namespace_efd1ef23
	Checksum: 0x796CFB4A
	Offset: 0x2120
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function function_3a5a56c7()
{
	self endon("death");
	self endon("hash_368634cd");
	if(self.var_4288770f.archetype === "mechz")
	{
		while(1)
		{
			self clientfield::increment("demongate_chomper_bite_fx", 1);
			wait(1);
		}
		break;
	}
	while(1)
	{
		self waittill("hash_48e4a902");
		self clientfield::increment("demongate_chomper_bite_fx", 1);
	}
}

/*
	Name: function_3c03253d
	Namespace: namespace_efd1ef23
	Checksum: 0x1C1D96A4
	Offset: 0x21D8
	Size: 0x1A3
	Parameters: 2
	Flags: None
*/
function function_3c03253d(var_aad66aa4, var_7364b0dd)
{
	self.var_4288770f endon("death");
	if(isdefined(self.var_4288770f.isdog) && self.var_4288770f.isdog)
	{
		self.var_4288770f ai::set_ignoreall(1);
	}
	else if(self.var_4288770f.archetype === "mechz")
	{
		self thread function_c5e710f7();
	}
	else if(isVehicle(self.var_4288770f))
	{
		self.var_4288770f.ignoreall = 1;
	}
	else if(isdefined(var_7364b0dd) && var_7364b0dd)
	{
		self.var_4288770f scene::Play("ai_zm_dlc1_zombie_demongate_chomper_attack_crawler", Array(self.var_4288770f, self));
	}
	else
	{
		self.var_4288770f scene::init("ai_zm_dlc1_zombie_demongate_chomper_attack_0" + var_aad66aa4, Array(self.var_4288770f, self));
		self.var_4288770f scene::Play("ai_zm_dlc1_zombie_demongate_chomper_attack_0" + var_aad66aa4, Array(self.var_4288770f, self));
	}
}

/*
	Name: function_c5e710f7
	Namespace: namespace_efd1ef23
	Checksum: 0x53A05BD1
	Offset: 0x2388
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function function_c5e710f7()
{
	var_f1d8a1fc = self.var_4288770f;
	self endon("death");
	self endon("hash_368634cd");
	var_f1d8a1fc endon("death");
	while(1)
	{
		if(isdefined(var_f1d8a1fc.has_faceplate) && var_f1d8a1fc.has_faceplate)
		{
		}
		else
		{
		}
		var_e388672 = 1;
		var_85b50675 = AnglesToForward(self.var_4288770f.angles) * var_e388672;
		self.origin = self.var_4288770f GetTagOrigin("j_faceplate") + var_85b50675;
		self.angles = VectorToAngles(var_85b50675 * -1);
		wait(0.05);
	}
}

/*
	Name: function_43415734
	Namespace: namespace_efd1ef23
	Checksum: 0x4A8273ED
	Offset: 0x24A0
	Size: 0x13B
	Parameters: 2
	Flags: None
*/
function function_43415734(var_aad66aa4, var_7364b0dd)
{
	if(isdefined(self.var_4288770f) && self.var_4288770f.archetype === "mechz")
	{
		self.var_4288770f thread function_aa5b14d0();
		return;
	}
	if(isdefined(self.var_4288770f) && (!isdefined(self.var_4288770f.isdog) && self.var_4288770f.isdog))
	{
		if(isdefined(var_7364b0dd) && var_7364b0dd)
		{
			self.var_4288770f thread scene::stop("ai_zm_dlc1_zombie_demongate_chomper_attack_crawler");
		}
		else
		{
			self.var_4288770f thread scene::stop("ai_zm_dlc1_zombie_demongate_chomper_attack_0" + var_aad66aa4);
		}
	}
	if(isdefined(var_7364b0dd) && var_7364b0dd)
	{
		self thread scene::stop("ai_zm_dlc1_zombie_demongate_chomper_attack_crawler");
	}
	else
	{
		self thread scene::stop("ai_zm_dlc1_zombie_demongate_chomper_attack_0" + var_aad66aa4);
	}
}

/*
	Name: function_aa5b14d0
	Namespace: namespace_efd1ef23
	Checksum: 0xECE8C5D3
	Offset: 0x25E8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_aa5b14d0()
{
	self endon("death");
	self.var_d3c478a0 = 1;
	wait(16);
	self.var_d3c478a0 = 0;
}

/*
	Name: function_5dee133f
	Namespace: namespace_efd1ef23
	Checksum: 0x48C081CD
	Offset: 0x2620
	Size: 0x393
	Parameters: 0
	Flags: None
*/
function function_5dee133f()
{
	self flag::set("chomper_attacking");
	var_b710c4e5 = self.var_4288770f GetEye();
	n_dist = Distance(self.origin, var_b710c4e5);
	var_e5e24312 = 1;
	if(math::cointoss())
	{
	}
	else
	{
	}
	var_4e26e12a = -1;
	self clientfield::set("demongate_attack_locomotion_anim", 1);
	while(n_dist > 32 && isdefined(self.var_4288770f) && isalive(self.var_4288770f))
	{
		var_b710c4e5 = self.var_4288770f GetEye();
		n_time = n_dist / 640;
		var_5d76b65c = 1 / var_e5e24312;
		var_ef096040 = VectorScale((0, 0, 1), 160) * var_5d76b65c;
		var_c5a0d28e = AnglesToRight(VectorToAngles(var_b710c4e5 - self.origin)) * 256;
		var_c5a0d28e = var_c5a0d28e * var_5d76b65c;
		var_c5a0d28e = var_c5a0d28e * var_4e26e12a;
		var_74490e48 = var_b710c4e5 + var_c5a0d28e + var_ef096040;
		var_d1979001 = var_74490e48 - self.origin;
		var_d1979001 = (0, var_d1979001[1], 0);
		if(!isdefined(level.var_a9ac7b97))
		{
			level.var_a9ac7b97 = GetTime();
		}
		else if(level.var_a9ac7b97 == GetTime())
		{
			wait(RandomFloatRange(0.1, 0.2));
		}
		level.var_a9ac7b97 = GetTime();
		self moveto(var_74490e48, n_time);
		self RotateTo(VectorToAngles(var_d1979001), n_time * 0.5);
		n_time = n_time * 0.3;
		if(n_time < 0.1)
		{
		}
		else
		{
		}
		n_time = n_time;
		wait(n_time);
		var_e5e24312++;
		n_dist = Distance(self.origin, var_b710c4e5);
	}
	self clientfield::set("demongate_attack_locomotion_anim", 0);
	if(isdefined(self.var_4288770f) && isalive(self.var_4288770f))
	{
		self.origin = var_b710c4e5;
	}
}

/*
	Name: function_67903a83
	Namespace: namespace_efd1ef23
	Checksum: 0x5ECA0A60
	Offset: 0x29C0
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function function_67903a83(e_player)
{
	e_target = self.var_4288770f;
	e_target endon("death");
	if(e_target.archetype === "mechz")
	{
		self thread function_3f57ba41(e_player);
		return;
	}
	n_damage = e_target.health;
	self waittill("hash_368634cd");
	e_target SetPlayerCollision(1);
	e_target.var_bc9b5fbd = 0;
	e_target.var_98056717 = 0;
	if(zm_utility::is_player_valid(e_player))
	{
		var_38fe557 = e_player;
	}
	else
	{
		var_38fe557 = undefined;
	}
	e_target DoDamage(n_damage, e_target.origin, var_38fe557, var_38fe557, undefined, "MOD_UNKNOWN", 0, level.var_edf1e590);
	GibServerUtils::GibHead(e_target);
}

/*
	Name: function_3f57ba41
	Namespace: namespace_efd1ef23
	Checksum: 0x8318453
	Offset: 0x2B20
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function function_3f57ba41(e_player)
{
	e_target = self.var_4288770f;
	e_target endon("death");
	var_3bb42832 = level.mechz_health;
	if(isdefined(level.var_f4dc2834))
	{
		var_3bb42832 = math::clamp(var_3bb42832, 0, level.var_f4dc2834);
	}
	n_damage = var_3bb42832 * 0.2 / 0.2;
	if(zm_utility::is_player_valid(e_player))
	{
		var_38fe557 = e_player;
	}
	else
	{
		var_38fe557 = undefined;
	}
	e_target DoDamage(n_damage, e_target.origin, var_38fe557, var_38fe557, undefined, "MOD_PROJECTILE_SPLASH", 0, level.var_edf1e590);
	self waittill("hash_368634cd");
	e_target.var_bc9b5fbd = 0;
	e_target.var_98056717 = 0;
}

/*
	Name: function_99d2c8aa
	Namespace: namespace_efd1ef23
	Checksum: 0xDF7B7992
	Offset: 0x2C60
	Size: 0x1B5
	Parameters: 1
	Flags: None
*/
function function_99d2c8aa(e_player)
{
	if(self flag::get("demongate_chomper_despawning"))
	{
		return;
	}
	self.var_4288770f = undefined;
	var_51b6a540 = self.origin;
	var_6f3820ea = 1024;
	if(isdefined(self.var_603f1f19) && self.var_603f1f19)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			var_51b6a540 = e_player.origin;
		}
		var_6f3820ea = 1024;
	}
	a_ai_enemies = GetAITeamArray(level.zombie_team);
	var_237d778f = ArraySortClosest(a_ai_enemies, var_51b6a540, a_ai_enemies.size, 0, var_6f3820ea);
	var_237d778f = Array::filter(var_237d778f, 0, &zm_weap_elemental_bow::function_5aec3adc);
	var_237d778f = Array::filter(var_237d778f, 0, &function_c994aef0, self);
	if(var_237d778f.size)
	{
		var_9183256c = var_237d778f[0];
		var_9183256c.var_bc9b5fbd = 1;
		self.var_4288770f = var_9183256c;
		self notify("hash_7b23407");
	}
}

/*
	Name: function_c994aef0
	Namespace: namespace_efd1ef23
	Checksum: 0x74397D99
	Offset: 0x2E20
	Size: 0x109
	Parameters: 2
	Flags: None
*/
function function_c994aef0(var_9183256c, var_7119a95d)
{
	return !isdefined(var_9183256c.var_bc9b5fbd) && var_9183256c.var_bc9b5fbd && (isdefined(var_9183256c.completed_emerging_into_playable_area) && var_9183256c.completed_emerging_into_playable_area || !isdefined(var_9183256c.completed_emerging_into_playable_area)) && (var_9183256c.archetype === "zombie" && (isdefined(var_9183256c.completed_emerging_into_playable_area) && var_9183256c.completed_emerging_into_playable_area) || var_9183256c.archetype !== "zombie") && BulletTracePassed(var_9183256c GetEye(), var_7119a95d.origin, 0, var_7119a95d);
}

