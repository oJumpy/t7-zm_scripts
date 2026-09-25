#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_spawner;

#namespace zm_weap_elemental_bow;

/*
	Name: __init__sytem__
	Namespace: zm_weap_elemental_bow
	Checksum: 0x3B284FF
	Offset: 0x550
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_elemental_bow
	Checksum: 0x87FF24D9
	Offset: 0x598
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_be94cdb = GetWeapon("elemental_bow");
	level.var_1a828a16 = GetWeapon("elemental_bow4");
	clientfield::register("toplayer", "elemental_bow" + "_ambient_bow_fx", 5000, 1, "int");
	clientfield::register("missile", "elemental_bow" + "_arrow_impact_fx", 5000, 1, "int");
	clientfield::register("missile", "elemental_bow4" + "_arrow_impact_fx", 5000, 1, "int");
	callback::on_connect(&function_c45ac6ae);
	SetDvar("bg_chargeShotUseOneAmmoForMultipleBullets", 0);
	SetDvar("bg_zm_dlc1_chargeShotMultipleBulletsForFullCharge", 2);
	function_9b385ca5();
	level.var_d6de2706 = Throttle;
	Initialize(level.var_d6de2706, 6);
}

/*
	Name: __main__
	Namespace: zm_weap_elemental_bow
	Checksum: 0x99EC1590
	Offset: 0x720
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: function_c45ac6ae
	Namespace: zm_weap_elemental_bow
	Checksum: 0xC7508D6E
	Offset: 0x730
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_c45ac6ae()
{
	self thread function_982419bb("elemental_bow");
	self thread function_ececa597("elemental_bow", "elemental_bow4");
	self thread function_7bc6b9d("elemental_bow", "elemental_bow4", &function_65347b70);
}

/*
	Name: function_65347b70
	Namespace: zm_weap_elemental_bow
	Checksum: 0xBAC48C00
	Offset: 0x7B8
	Size: 0x15B
	Parameters: 5
	Flags: None
*/
function function_65347b70(weapon, v_position, radius, attacker, normal)
{
	var_2679aa6b = function_1796e73(weapon.name);
	if(weapon.name == "elemental_bow4")
	{
		attacker clientfield::set(var_2679aa6b + "_arrow_impact_fx", 1);
		var_852420bf = Array::get_all_closest(v_position, GetAITeamArray(level.zombie_team), undefined, undefined, 128);
		var_852420bf = Array::filter(var_852420bf, 0, &function_83f44f5, v_position);
		Array::thread_all(var_852420bf, &function_7fba300, self, v_position);
	}
	else
	{
		attacker clientfield::set(var_2679aa6b + "_arrow_impact_fx", 1);
	}
}

/*
	Name: function_83f44f5
	Namespace: zm_weap_elemental_bow
	Checksum: 0x1CE6489D
	Offset: 0x920
	Size: 0x91
	Parameters: 2
	Flags: None
*/
function function_83f44f5(ai_enemy, var_289e02fc)
{
	return isalive(ai_enemy) && (!isdefined(ai_enemy.var_98056717) && ai_enemy.var_98056717) && BulletTracePassed(ai_enemy GetCentroid(), var_289e02fc + VectorScale((0, 0, 1), 48), 0, undefined);
}

/*
	Name: function_7fba300
	Namespace: zm_weap_elemental_bow
	Checksum: 0x565DEB3C
	Offset: 0x9C0
	Size: 0x207
	Parameters: 2
	Flags: None
*/
function function_7fba300(e_player, var_289e02fc)
{
	self endon("death");
	if(self.archetype === "mechz")
	{
		return;
	}
	self.var_98056717 = 1;
	n_damage = 2233;
	if(self.health > 2233)
	{
		self thread function_d1e69389(var_289e02fc);
	}
	else
	{
		self StartRagdoll();
		n_dist = Distance2D(self.origin, var_289e02fc);
		var_37f1fb21 = 128 - n_dist / 128;
		var_9450d281 = VectorNormalize(self GetCentroid() - var_289e02fc);
		if(var_9450d281[2] < 0.8)
		{
			var_9450d281 = (var_9450d281[0], var_9450d281[1], 0.8);
		}
		self LaunchRagdoll(var_9450d281 * 96 * var_37f1fb21);
		wait(0.1);
		self zm_spawner::zombie_explodes_intopieces(0);
	}
	if(isdefined(self))
	{
		WaitInQueue(level.var_d6de2706);
		if(isdefined(self))
		{
			self DoDamage(n_damage, self.origin, e_player, e_player, undefined, "MOD_PROJECTILE_SPLASH", 0, level.var_1a828a16);
			self.var_98056717 = 0;
		}
	}
}

/*
	Name: function_982419bb
	Namespace: zm_weap_elemental_bow
	Checksum: 0x66B5A099
	Offset: 0xBD0
	Size: 0x20F
	Parameters: 1
	Flags: None
*/
function function_982419bb(var_6ab83514)
{
	self endon("death");
	var_e1041201 = GetWeapon(var_6ab83514);
	while(1)
	{
		self waittill("weapon_change", var_9f85aad5, var_6de65145);
		if(var_9f85aad5 === var_e1041201)
		{
			if(!(isdefined(self.var_8b65be8c) && self.var_8b65be8c))
			{
				if(isdefined(self.hintelem))
				{
					self.hintelem setText("");
					self.hintelem destroy();
				}
				if(self IsSplitscreen())
				{
					self thread zm_equipment::show_hint_text(&"ZM_CASTLE_BOW_INSTRUCTIONS", 8, 1, 150);
				}
				else
				{
					self thread zm_equipment::show_hint_text(&"ZM_CASTLE_BOW_INSTRUCTIONS", 8);
				}
				self.var_8b65be8c = 1;
			}
			if(isdefined(level.var_2edb42da))
			{
				self thread [[level.var_2edb42da]]();
			}
			self util::waittill_any_timeout(1, "weapon_change_complete", "death");
			self clientfield::set_to_player(var_6ab83514 + "_ambient_bow_fx", 1);
		}
		else if(var_6de65145 === var_e1041201)
		{
			self clientfield::set_to_player(var_6ab83514 + "_ambient_bow_fx", 0);
			self StopRumble("bow_draw_loop");
		}
	}
}

/*
	Name: function_ececa597
	Namespace: zm_weap_elemental_bow
	Checksum: 0x66D4E32F
	Offset: 0xDE8
	Size: 0xAF
	Parameters: 3
	Flags: None
*/
function function_ececa597(var_6ab83514, var_8f9bdf29, var_5759faa5)
{
	if(!isdefined(var_5759faa5))
	{
		var_5759faa5 = undefined;
	}
	self endon("death");
	if(!isdefined(var_5759faa5))
	{
		return;
	}
	while(1)
	{
		self waittill("missile_fire", projectile, weapon);
		if(IsSubStr(weapon.name, var_6ab83514))
		{
			self thread [[var_5759faa5]](projectile, weapon);
		}
	}
}

/*
	Name: function_67b18bd9
	Namespace: zm_weap_elemental_bow
	Checksum: 0xE5DDC2FA
	Offset: 0xEA0
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_67b18bd9(str_weapon_name)
{
	if(!isdefined(str_weapon_name))
	{
		return 0;
	}
	if(str_weapon_name == "elemental_bow" || str_weapon_name == "elemental_bow2" || str_weapon_name == "elemental_bow3" || str_weapon_name == "elemental_bow4" || str_weapon_name == "elemental_bow_demongate" || str_weapon_name == "elemental_bow_demongate2" || str_weapon_name == "elemental_bow_demongate3" || str_weapon_name == "elemental_bow_demongate4" || str_weapon_name == "elemental_bow_rune_prison" || str_weapon_name == "elemental_bow_rune_prison_ricochet" || str_weapon_name == "elemental_bow_rune_prison2" || str_weapon_name == "elemental_bow_rune_prison3" || str_weapon_name == "elemental_bow_rune_prison4" || str_weapon_name == "elemental_bow_rune_prison4_ricochet" || str_weapon_name == "elemental_bow_storm" || str_weapon_name == "elemental_bow_storm_ricochet" || str_weapon_name == "elemental_bow_storm2" || str_weapon_name == "elemental_bow_storm3" || str_weapon_name == "elemental_bow_storm4" || str_weapon_name == "elemental_bow_storm4_ricochet" || str_weapon_name == "elemental_bow_wolf_howl" || str_weapon_name == "elemental_bow_wolf_howl2" || str_weapon_name == "elemental_bow_wolf_howl3" || str_weapon_name == "elemental_bow_wolf_howl4")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_db107e59
	Namespace: zm_weap_elemental_bow
	Checksum: 0x8A308293
	Offset: 0x1050
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_db107e59(str_weapon_name)
{
	if(!isdefined(str_weapon_name))
	{
		return 0;
	}
	if(str_weapon_name == "elemental_bow4" || str_weapon_name == "elemental_bow_demongate4" || str_weapon_name == "elemental_bow_rune_prison4" || str_weapon_name == "elemental_bow_rune_prison4_ricochet" || str_weapon_name == "elemental_bow_storm4" || str_weapon_name == "elemental_bow_storm4_ricochet" || str_weapon_name == "elemental_bow_wolf_howl4")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_b252290e
	Namespace: zm_weap_elemental_bow
	Checksum: 0x9BC1B69E
	Offset: 0x10F0
	Size: 0x247
	Parameters: 2
	Flags: None
*/
function function_b252290e(str_weapon_name, var_93fff756)
{
	if(!isdefined(str_weapon_name))
	{
		return 0;
	}
	switch(var_93fff756)
	{
		case "elemental_bow":
		{
			if(str_weapon_name == "elemental_bow" || str_weapon_name == "elemental_bow2" || str_weapon_name == "elemental_bow3" || str_weapon_name == "elemental_bow4")
			{
				return 1;
			}
			break;
		}
		case "elemental_bow_demongate":
		{
			if(str_weapon_name == "elemental_bow_demongate" || str_weapon_name == "elemental_bow_demongate2" || str_weapon_name == "elemental_bow_demongate3" || str_weapon_name == "elemental_bow_demongate4")
			{
				return 1;
			}
			break;
		}
		case "elemental_bow_rune_prison":
		{
			if(str_weapon_name == "elemental_bow_rune_prison" || str_weapon_name == "elemental_bow_rune_prison_ricochet" || str_weapon_name == "elemental_bow_rune_prison2" || str_weapon_name == "elemental_bow_rune_prison3" || str_weapon_name == "elemental_bow_rune_prison4" || str_weapon_name == "elemental_bow_rune_prison4_ricochet")
			{
				return 1;
			}
			break;
		}
		case "elemental_bow_storm":
		{
			if(str_weapon_name == "elemental_bow_storm" || str_weapon_name == "elemental_bow_storm_ricochet" || str_weapon_name == "elemental_bow_storm2" || str_weapon_name == "elemental_bow_storm3" || str_weapon_name == "elemental_bow_storm4" || str_weapon_name == "elemental_bow_storm4_ricochet")
			{
				return 1;
			}
			break;
		}
		case "elemental_bow_wolf_howl":
		{
			if(str_weapon_name == "elemental_bow_wolf_howl" || str_weapon_name == "elemental_bow_wolf_howl2" || str_weapon_name == "elemental_bow_wolf_howl3" || str_weapon_name == "elemental_bow_wolf_howl4")
			{
				return 1;
			}
			break;
		}
		case default:
		{
			/#
				Assert(0, "Dev Block strings are not supported");
			#/
			break;
		}
	}
	return 0;
}

/*
	Name: function_ea37b2fe
	Namespace: zm_weap_elemental_bow
	Checksum: 0x23EB5AE4
	Offset: 0x1340
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function function_ea37b2fe(str_weapon_name)
{
	if(!isdefined(str_weapon_name))
	{
		return 0;
	}
	if(str_weapon_name == "elemental_bow_demongate" || str_weapon_name == "elemental_bow_demongate2" || str_weapon_name == "elemental_bow_demongate3" || str_weapon_name == "elemental_bow_demongate4" || str_weapon_name == "elemental_bow_rune_prison" || str_weapon_name == "elemental_bow_rune_prison_ricochet" || str_weapon_name == "elemental_bow_rune_prison2" || str_weapon_name == "elemental_bow_rune_prison3" || str_weapon_name == "elemental_bow_rune_prison4" || str_weapon_name == "elemental_bow_rune_prison4_ricochet" || str_weapon_name == "elemental_bow_storm" || str_weapon_name == "elemental_bow_storm_ricochet" || str_weapon_name == "elemental_bow_storm2" || str_weapon_name == "elemental_bow_storm3" || str_weapon_name == "elemental_bow_storm4" || str_weapon_name == "elemental_bow_storm4_ricochet" || str_weapon_name == "elemental_bow_wolf_howl" || str_weapon_name == "elemental_bow_wolf_howl2" || str_weapon_name == "elemental_bow_wolf_howl3" || str_weapon_name == "elemental_bow_wolf_howl4")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_7bc6b9d
	Namespace: zm_weap_elemental_bow
	Checksum: 0xD10C3DC9
	Offset: 0x14B0
	Size: 0x1CF
	Parameters: 3
	Flags: None
*/
function function_7bc6b9d(var_6ab83514, var_8f9bdf29, var_332bb697)
{
	if(!isdefined(var_332bb697))
	{
		var_332bb697 = undefined;
	}
	self endon("death");
	while(1)
	{
		self waittill("projectile_impact", weapon, v_position, radius, e_projectile, normal);
		var_48369d98 = function_1796e73(weapon.name);
		if(var_48369d98 == var_6ab83514 || var_48369d98 == var_8f9bdf29)
		{
			if(var_48369d98 != "elemental_bow" && var_48369d98 != "elemental_bow_wolf_howl4" && isdefined(e_projectile.birthtime))
			{
				if(GetTime() - e_projectile.birthtime <= 150)
				{
					RadiusDamage(v_position, 32, level.zombie_health, level.zombie_health, self, "MOD_UNKNOWN", weapon);
				}
			}
			self thread function_d2e32ed2(var_48369d98, v_position);
			if(isdefined(var_332bb697))
			{
				self thread [[var_332bb697]](weapon, v_position, radius, e_projectile, normal);
			}
			self thread function_9c5946ba(weapon, v_position);
		}
	}
}

/*
	Name: function_d2e32ed2
	Namespace: zm_weap_elemental_bow
	Checksum: 0x41D3EAE0
	Offset: 0x1688
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function function_d2e32ed2(var_48369d98, v_position)
{
	if(var_48369d98 === "elemental_bow_wolf_howl4")
	{
		return;
	}
	Array::thread_all(GetAIArchetypeArray("mechz"), &function_b78fcfc7, self, var_48369d98, v_position);
}

/*
	Name: function_b78fcfc7
	Namespace: zm_weap_elemental_bow
	Checksum: 0xD7B6423A
	Offset: 0x1700
	Size: 0x3F3
	Parameters: 3
	Flags: None
*/
function function_b78fcfc7(e_player, var_48369d98, v_position)
{
	var_2017780d = 0;
	var_c36342f3 = 0;
	var_377b9896 = 0;
	if(!IsSubStr(var_48369d98, "4"))
	{
		var_377b9896 = 1;
		var_3fa1565a = 9216;
		var_6594cbc3 = 96;
		var_f419b406 = 0.25;
	}
	else if(var_48369d98 == "elemental_bow4")
	{
		var_377b9896 = 1;
		var_3fa1565a = 20736;
		var_6594cbc3 = 144;
		var_f419b406 = 0.1;
	}
	var_7486069a = DistanceSquared(v_position, self.origin);
	var_7d984cf2 = DistanceSquared(v_position, self GetTagOrigin("j_neck"));
	if(var_7486069a < 1600 || var_7d984cf2 < 2304)
	{
		var_2017780d = 1;
		var_c36342f3 = 1;
	}
	else if(var_377b9896 && (var_7486069a < var_3fa1565a || var_7d984cf2 < var_3fa1565a))
	{
		var_2017780d = 1;
		var_c36342f3 = 1 - var_f419b406;
		if(var_7486069a < var_7d984cf2)
		{
		}
		else
		{
		}
		var_c36342f3 = var_7486069a * sqrt(var_7d984cf2) / var_6594cbc3;
		var_c36342f3 = 1 - var_c36342f3;
	}
	if(var_2017780d)
	{
		var_3bb42832 = level.mechz_health;
		if(isdefined(level.var_f4dc2834))
		{
			var_3bb42832 = math::clamp(var_3bb42832, 0, level.var_f4dc2834);
		}
		if(var_48369d98 == "elemental_bow")
		{
			var_26680fd5 = function_dc4f8831(0.15, 0.03);
		}
		else if(var_48369d98 == "elemental_bow4")
		{
			var_26680fd5 = function_dc4f8831(0.25, 0.12);
		}
		else if(!IsSubStr(var_48369d98, "4"))
		{
			var_26680fd5 = 0.1;
		}
		else
		{
			var_26680fd5 = 0.35;
		}
		var_40955aed = var_3bb42832 * var_26680fd5 / 0.2;
		var_40955aed = var_40955aed * var_c36342f3;
		self DoDamage(var_40955aed, self.origin, e_player, e_player, undefined, "MOD_PROJECTILE_SPLASH", 0, level.var_be94cdb);
	}
}

/*
	Name: function_dc4f8831
	Namespace: zm_weap_elemental_bow
	Checksum: 0x8E4A7EFE
	Offset: 0x1B00
	Size: 0xBD
	Parameters: 2
	Flags: None
*/
function function_dc4f8831(var_eaae98a2, var_c01c8d5c)
{
	if(level.mechz_health < level.var_c1f907b2)
	{
		var_26680fd5 = var_eaae98a2;
	}
	else if(level.mechz_health > level.var_42fd61f0)
	{
		var_26680fd5 = var_c01c8d5c;
	}
	else
	{
		var_d82dde4a = level.mechz_health - level.var_c1f907b2;
		var_caabb734 = var_d82dde4a / level.var_42ee1b54;
		var_26680fd5 = var_eaae98a2 - var_eaae98a2 - var_c01c8d5c * var_caabb734;
	}
	return var_26680fd5;
}

/*
	Name: function_9c5946ba
	Namespace: zm_weap_elemental_bow
	Checksum: 0x6807D103
	Offset: 0x1BC8
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function function_9c5946ba(weapon, v_position)
{
	util::wait_network_frame();
	RadiusDamage(v_position, 24, 1, 1, self, undefined, weapon);
}

/*
	Name: function_5aec3adc
	Namespace: zm_weap_elemental_bow
	Checksum: 0xFB081E1E
	Offset: 0x1C20
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_5aec3adc(ai_enemy)
{
	b_callback_result = 1;
	if(isdefined(level.var_4e84030d))
	{
		b_callback_result = [[level.var_4e84030d]](ai_enemy);
	}
	return isdefined(ai_enemy) && isalive(ai_enemy) && !ai_enemy IsRagdoll() && (!isdefined(ai_enemy.var_98056717) && ai_enemy.var_98056717) && (!isdefined(ai_enemy.var_d3c478a0) && ai_enemy.var_d3c478a0) && b_callback_result;
}

/*
	Name: function_d1e69389
	Namespace: zm_weap_elemental_bow
	Checksum: 0xFF0A46EC
	Offset: 0x1D00
	Size: 0x2C7
	Parameters: 1
	Flags: None
*/
function function_d1e69389(var_63f884ec)
{
	self endon("death");
	if(!isdefined(self.KNOCKDOWN) && self.KNOCKDOWN && (!isdefined(self.missingLegs) && self.missingLegs))
	{
		self.KNOCKDOWN = 1;
		self SetPlayerCollision(0);
		var_25cdb267 = var_63f884ec - self.origin;
		var_a87a26a1 = VectorNormalize((var_25cdb267[0], var_25cdb267[1], 0));
		v_zombie_forward = VectorNormalize((AnglesToForward(self.angles)[0], AnglesToForward(self.angles)[1], 0));
		v_zombie_right = VectorNormalize((AnglesToRight(self.angles)[0], AnglesToRight(self.angles)[1], 0));
		v_dot = VectorDot(var_a87a26a1, v_zombie_forward);
		if(v_dot >= 0.5)
		{
			self.knockdown_direction = "front";
			self.getup_direction = "getup_back";
		}
		else if(v_dot < 0.5 && v_dot > -0.5)
		{
			v_dot = VectorDot(var_a87a26a1, v_zombie_right);
			if(v_dot > 0)
			{
				self.knockdown_direction = "right";
				if(math::cointoss())
				{
					self.getup_direction = "getup_back";
				}
				else
				{
					self.getup_direction = "getup_belly";
				}
			}
			else
			{
				self.knockdown_direction = "left";
				self.getup_direction = "getup_belly";
			}
		}
		else
		{
			self.knockdown_direction = "back";
			self.getup_direction = "getup_belly";
		}
		wait(2.5);
		self SetPlayerCollision(1);
		self.KNOCKDOWN = 0;
	}
}

/*
	Name: function_866906f
	Namespace: zm_weap_elemental_bow
	Checksum: 0xB12E88CA
	Offset: 0x1FD0
	Size: 0x261
	Parameters: 5
	Flags: None
*/
function function_866906f(v_hit_origin, str_weapon_name, var_3fee16b8, var_a5018155, var_83c68ee2)
{
	if(!isdefined(var_83c68ee2))
	{
		var_83c68ee2 = undefined;
	}
	var_980aeb4e = AnglesToForward(var_3fee16b8.angles);
	if(var_980aeb4e[2] != -1)
	{
		var_3e878400 = VectorNormalize(var_980aeb4e * -1);
		var_75181c09 = v_hit_origin + var_3e878400 * var_a5018155;
	}
	else
	{
		var_75181c09 = v_hit_origin + (0, 0, 1);
	}
	var_c6f6381a = bullettrace(var_75181c09, var_75181c09 - VectorScale((0, 0, 1), 1000), 0, undefined);
	var_58c16abb = var_75181c09[2] - var_c6f6381a["position"][2];
	var_2679aa6b = function_1796e73(str_weapon_name);
	if(!IsPointOnNavMesh(var_c6f6381a["position"]))
	{
		var_3fee16b8 clientfield::set(var_2679aa6b + "_arrow_impact_fx", 1);
		return undefined;
	}
	else if(var_58c16abb > 72)
	{
		if(isdefined(var_83c68ee2))
		{
			self thread [[var_83c68ee2]](str_weapon_name, var_75181c09, var_c6f6381a["position"]);
		}
		else
		{
			self thread function_99de7ff2(str_weapon_name, var_75181c09, var_c6f6381a["position"]);
		}
		return undefined;
	}
	else
	{
		var_3fee16b8 clientfield::set(var_2679aa6b + "_arrow_impact_fx", 1);
		return var_c6f6381a["position"];
	}
}

/*
	Name: function_99de7ff2
	Namespace: zm_weap_elemental_bow
	Checksum: 0x467BA268
	Offset: 0x2240
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function function_99de7ff2(str_weapon_name, v_source, v_destination)
{
	wait(0.1);
	MagicBullet(GetWeapon(str_weapon_name), v_source, v_destination, self);
}

/*
	Name: function_1796e73
	Namespace: zm_weap_elemental_bow
	Checksum: 0x78A5427A
	Offset: 0x22A0
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function function_1796e73(str_weapon_name)
{
	var_48369d98 = str_weapon_name;
	if(IsSubStr(var_48369d98, "ricochet"))
	{
		var_ae485cc2 = function_4d1b4da2(var_48369d98, "_ricochet");
		var_48369d98 = var_ae485cc2[0];
	}
	if(IsSubStr(var_48369d98, "2"))
	{
		var_48369d98 = StrTok(var_48369d98, "2")[0];
	}
	if(IsSubStr(var_48369d98, "3"))
	{
		var_48369d98 = StrTok(var_48369d98, "3")[0];
	}
	return var_48369d98;
}

