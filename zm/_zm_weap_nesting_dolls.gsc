#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_utility;

#namespace namespace_d2920ea5;

/*
	Name: __init__sytem__
	Namespace: namespace_d2920ea5
	Checksum: 0x96BDBFE8
	Offset: 0x380
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_nesting_dolls", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_d2920ea5
	Checksum: 0x93BC3F30
	Offset: 0x3C0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_21ae0b78 = GetWeapon("nesting_dolls");
	level.var_3a1d655b = GetWeapon("nesting_dolls_single");
	level.var_4cd1cc40 = 500;
	level.var_6e0ba488 = 45;
	level.var_f483f127 = 10000;
	level.var_a2b87344 = 0.25;
	level.var_c7ce5820 = cos(22.5);
	level.var_58ffdf1b = 180;
	gravity = GetDvarFloat("bg_gravity");
	level.var_ea1cfe92 = level.var_4cd1cc40 * sin(level.var_6e0ba488) / Abs(gravity) * 0.5;
	level.var_db1bba6e = 10;
	/#
		level.zombiemode_devgui_nesting_dolls_give = &player_give_nesting_dolls;
	#/
	function_51c28247();
}

/*
	Name: function_51c28247
	Namespace: namespace_d2920ea5
	Checksum: 0xABC3154B
	Offset: 0x518
	Size: 0x2AF
	Parameters: 0
	Flags: None
*/
function function_51c28247()
{
	if(isdefined(level.var_fd27be9f))
	{
		[[level.var_fd27be9f]]();
		return;
	}
	level._effect["nesting_doll_trail_blue"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_blue";
	level._effect["nesting_doll_trail_green"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_green";
	level._effect["nesting_doll_trail_red"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_red";
	level._effect["nesting_doll_trail_yellow"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_yellow";
	level.var_7379c29d = [];
	level.var_7379c29d[0] = spawnstruct();
	level.var_7379c29d[0].name = "dempsey";
	level.var_7379c29d[0].id = 127;
	level.var_7379c29d[0].trailfx = level._effect["nesting_doll_trail_blue"];
	level.var_7379c29d[1] = spawnstruct();
	level.var_7379c29d[1].name = "nikolai";
	level.var_7379c29d[1].id = 128;
	level.var_7379c29d[1].trailfx = level._effect["nesting_doll_trail_red"];
	level.var_7379c29d[2] = spawnstruct();
	level.var_7379c29d[2].name = "takeo";
	level.var_7379c29d[2].id = 130;
	level.var_7379c29d[2].trailfx = level._effect["nesting_doll_trail_green"];
	level.var_7379c29d[3] = spawnstruct();
	level.var_7379c29d[3].name = "richtofen";
	level.var_7379c29d[3].id = 129;
	level.var_7379c29d[3].trailfx = level._effect["nesting_doll_trail_yellow"];
}

/*
	Name: function_c025a1a5
	Namespace: namespace_d2920ea5
	Checksum: 0x14483B93
	Offset: 0x7D0
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function function_c025a1a5()
{
	return isdefined(level.zombie_weapons["nesting_dolls"]);
}

/*
	Name: player_give_nesting_dolls
	Namespace: namespace_d2920ea5
	Checksum: 0x22DA1DCA
	Offset: 0x7F0
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function player_give_nesting_dolls()
{
	self function_f4b4582d(0);
	var_1c3c9c82 = level.var_7379c29d[self.var_295a50c4[0][0]].id;
	weapon_options = self CalcWeaponOptions(var_1c3c9c82, 0, 0);
	if(self HasWeapon(level.var_21ae0b78))
	{
		self function_c8540b60(level.var_21ae0b78, weapon_options);
	}
	else
	{
		self GiveWeapon(level.var_21ae0b78, weapon_options);
	}
	self zm_utility::set_player_tactical_grenade(level.var_21ae0b78);
	self thread function_6831d7();
}

/*
	Name: function_6831d7
	Namespace: namespace_d2920ea5
	Checksum: 0x2AC1D21
	Offset: 0x910
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function function_6831d7()
{
	self notify("hash_c3d84139");
	self endon("disconnect");
	self endon("hash_c3d84139");
	while(1)
	{
		grenade = function_cf5a6be4();
		if(isdefined(grenade))
		{
			if(self laststand::player_is_in_laststand())
			{
				grenade delete();
				continue;
			}
			self thread function_8bfa63a0(grenade);
		}
		wait(0.05);
	}
}

/*
	Name: function_7c8b687
	Namespace: namespace_d2920ea5
	Checksum: 0x10DCD8A3
	Offset: 0x9C8
	Size: 0x1CD
	Parameters: 1
	Flags: None
*/
function function_7c8b687(var_b8d1d71c)
{
	self endon("disconnect");
	self endon("death");
	var_cf19c9e8 = 1;
	var_523515f2 = 4;
	self function_38be5ec1();
	self thread function_92b451d9();
	if(isdefined(var_b8d1d71c))
	{
		var_b8d1d71c function_1499b9a4(self.var_b1cb3746, 0, self);
		var_b8d1d71c thread function_88994d32(self, self.var_b1cb3746, 0);
	}
	while(var_cf19c9e8 < var_523515f2)
	{
		self waittill("hash_e78f395e", origin, angles);
		var_f77662c1 = self function_d263a0d7(origin, 2000);
		if(var_f77662c1 == (0, 0, 0))
		{
			var_f77662c1 = self function_e20585d3(origin, angles);
		}
		grenade = self MagicGrenadeType(level.var_3a1d655b, origin, var_f77662c1);
		grenade function_1499b9a4(self.var_b1cb3746, var_cf19c9e8, self);
		grenade thread function_88994d32(self, self.var_b1cb3746, var_cf19c9e8);
		var_cf19c9e8++;
	}
}

/*
	Name: function_8bfa63a0
	Namespace: namespace_d2920ea5
	Checksum: 0xB452BE0A
	Offset: 0xBA0
	Size: 0x207
	Parameters: 1
	Flags: None
*/
function function_8bfa63a0(var_b8d1d71c)
{
	self endon("disconnect");
	self endon("death");
	var_cf19c9e8 = 1;
	var_523515f2 = 4;
	self function_38be5ec1();
	self thread function_92b451d9();
	self thread function_f1cbce42(self.var_b1cb3746);
	self thread function_553c8cdb(self.var_b1cb3746);
	if(isdefined(var_b8d1d71c))
	{
		var_b8d1d71c function_1499b9a4(self.var_b1cb3746, 0, self);
		var_b8d1d71c thread function_88994d32(self, self.var_b1cb3746, 0);
	}
	self waittill("hash_e78f395e", origin, angles);
	while(var_cf19c9e8 < var_523515f2)
	{
		var_f77662c1 = self function_58267558(angles, var_cf19c9e8);
		grenade = self MagicGrenadeType(level.var_3a1d655b, origin, var_f77662c1);
		grenade function_1499b9a4(self.var_b1cb3746, var_cf19c9e8, self);
		grenade playsound("wpn_nesting_pop_npc");
		grenade thread function_88994d32(self, self.var_b1cb3746, var_cf19c9e8);
		var_cf19c9e8++;
		wait(0.25);
	}
}

/*
	Name: function_e29d07ea
	Namespace: namespace_d2920ea5
	Checksum: 0x3DF22E63
	Offset: 0xDB0
	Size: 0x183
	Parameters: 4
	Flags: None
*/
function function_e29d07ea(origin, owner, id, index)
{
	self waittill("explode");
	zombies = zombie_utility::get_round_enemy_array();
	if(zombies.size == 0)
	{
		return;
	}
	var_45e7db0a = util::get_array_of_closest(origin, zombies, undefined, undefined, level.var_58ffdf1b);
	for(i = 0; i < var_45e7db0a.size; i++)
	{
		if(isalive(var_45e7db0a[i]))
		{
			if(var_45e7db0a[i] damageConeTrace(origin, owner) == 1)
			{
				owner.var_2f6526f3[id][index] = owner.var_2f6526f3[id][index] + 1;
			}
		}
	}
	RadiusDamage(origin, level.var_58ffdf1b, 95000, 95000, owner, "MOD_GRENADE_SPLASH", level.var_3a1d655b);
}

/*
	Name: function_2d17c595
	Namespace: namespace_d2920ea5
	Checksum: 0x2D9219B1
	Offset: 0xF40
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function function_2d17c595(angles)
{
	random_yaw = randomIntRange(-45, 45);
	random_pitch = randomIntRange(-45, -35);
	random = (random_pitch, random_yaw, 0);
	var_4de4242e = angles + random;
	return var_4de4242e;
}

/*
	Name: function_e20585d3
	Namespace: namespace_d2920ea5
	Checksum: 0x6993EAE4
	Offset: 0xFD8
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function function_e20585d3(var_af0b25f3, angles)
{
	angles = function_2d17c595(angles);
	trace_dist = level.var_4cd1cc40 * level.var_ea1cfe92;
	for(i = 0; i < 4; i++)
	{
		dir = AnglesToForward(angles);
		if(BulletTracePassed(var_af0b25f3, var_af0b25f3 + dir * trace_dist, 0, undefined))
		{
			var_f77662c1 = dir * level.var_4cd1cc40;
			return var_f77662c1;
			continue;
		}
		angles = angles + VectorScale((0, 1, 0), 90);
	}
	return (0, 0, level.var_4cd1cc40);
}

/*
	Name: function_58267558
	Namespace: namespace_d2920ea5
	Checksum: 0x84F2CDEA
	Offset: 0x10F8
	Size: 0xC5
	Parameters: 2
	Flags: None
*/
function function_58267558(angles, index)
{
	random_pitch = randomIntRange(-45, -35);
	offsets = Array(45, 0, -45);
	angles = angles + (random_pitch, offsets[index - 1], 0);
	dir = AnglesToForward(angles);
	var_f77662c1 = dir * level.var_4cd1cc40;
	return var_f77662c1;
}

/*
	Name: function_d263a0d7
	Namespace: namespace_d2920ea5
	Checksum: 0x4F696A79
	Offset: 0x11C8
	Size: 0x105
	Parameters: 2
	Flags: None
*/
function function_d263a0d7(var_af0b25f3, range)
{
	velocity = (0, 0, 0);
	target = function_11d2fdaa(var_af0b25f3, range);
	if(isdefined(target))
	{
		target_origin = target function_df2f3669();
		dir = VectorToAngles(target_origin - var_af0b25f3);
		dir = (dir[0] - level.var_6e0ba488, dir[1], dir[2]);
		dir = AnglesToForward(dir);
		velocity = dir * level.var_4cd1cc40;
	}
	return velocity;
}

/*
	Name: function_df2f3669
	Namespace: namespace_d2920ea5
	Checksum: 0x470943D5
	Offset: 0x12D8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_df2f3669()
{
	position = self.origin;
	return position;
}

/*
	Name: function_1499b9a4
	Namespace: namespace_d2920ea5
	Checksum: 0x82D293DF
	Offset: 0x1300
	Size: 0x1B3
	Parameters: 3
	Flags: None
*/
function function_1499b9a4(id, index, parent)
{
	self Hide();
	self.var_96967264 = spawn("script_model", self.origin);
	var_7bdf50dc = parent.var_295a50c4[id][index];
	name = level.var_7379c29d[var_7bdf50dc].name;
	model_index = index + 1;
	model_name = "wpn_t7_zmb_hd_nesting_dolls_" + name + "_doll" + model_index + "_world";
	self.var_96967264 SetModel(model_name);
	self.var_96967264 useanimtree(-1);
	self.var_96967264 LinkTo(self);
	self.var_96967264.angles = self.angles;
	self.var_96967264 thread function_23b41a73(self);
	wait(0.1);
	PlayFXOnTag(level.var_7379c29d[var_7bdf50dc].trailfx, self.var_96967264, "tag_origin");
}

/*
	Name: function_88994d32
	Namespace: namespace_d2920ea5
	Checksum: 0xDEE34D19
	Offset: 0x14C0
	Size: 0x183
	Parameters: 3
	Flags: None
*/
function function_88994d32(parent, var_b1cb3746, index)
{
	velocitySq = 100000000;
	oldpos = self.origin;
	while(velocitySq != 0)
	{
		wait(0.1);
		if(!isdefined(self))
		{
			break;
		}
		velocitySq = DistanceSquared(self.origin, oldpos);
		oldpos = self.origin;
	}
	if(isdefined(self))
	{
		self.var_96967264 Unlink();
		self.var_96967264.origin = self.origin;
		self.var_96967264.angles = self.angles;
		parent notify("hash_e78f395e", self.origin, self.angles);
		self thread function_e29d07ea(self.origin, parent, var_b1cb3746, index);
		self ResetMissileDetonationTime(level.var_a2b87344);
		if(isdefined(index) && index == 3)
		{
			parent thread function_49591ea0(var_b1cb3746);
		}
	}
}

/*
	Name: function_49591ea0
	Namespace: namespace_d2920ea5
	Checksum: 0x836615AA
	Offset: 0x1650
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_49591ea0(var_b1cb3746)
{
	wait(level.var_a2b87344 + 0.1);
	self notify("end_achievement_tracker" + var_b1cb3746);
}

/*
	Name: function_6485d610
	Namespace: namespace_d2920ea5
	Checksum: 0x72DCC9C7
	Offset: 0x1688
	Size: 0x295
	Parameters: 1
	Flags: None
*/
function function_6485d610(range)
{
	view_pos = self GetWeaponMuzzlePoint();
	zombies = util::get_array_of_closest(view_pos, zombie_utility::get_round_enemy_array(), undefined, undefined, range * 1.1);
	if(!isdefined(zombies))
	{
		return;
	}
	range_squared = range * range;
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale(forward_view_angles, range);
	var_388e0ae3 = -999;
	best_target = undefined;
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(view_pos, test_origin);
		if(test_range_squared > range_squared)
		{
			return;
		}
		normal = VectorNormalize(test_origin - view_pos);
		dot = VectorDot(forward_view_angles, normal);
		if(dot < 0)
		{
			continue;
		}
		if(dot < level.var_c7ce5820)
		{
			continue;
		}
		if(0 == zombies[i] damageConeTrace(view_pos, self))
		{
			continue;
		}
		if(dot > var_388e0ae3)
		{
			var_388e0ae3 = dot;
			best_target = zombies[i];
		}
	}
	/#
	#/
	return best_target;
}

/*
	Name: function_11d2fdaa
	Namespace: namespace_d2920ea5
	Checksum: 0x8E42A65
	Offset: 0x1928
	Size: 0x125
	Parameters: 2
	Flags: None
*/
function function_11d2fdaa(origin, range)
{
	zombies = GetAIArray(level.zombie_team);
	if(zombies.size > 0)
	{
		var_45e7db0a = util::get_array_of_closest(origin, zombies, undefined, undefined, range);
		for(i = 0; i < var_45e7db0a.size; i++)
		{
			if(isdefined(var_45e7db0a[i]) && isalive(var_45e7db0a[i]))
			{
				centroid = var_45e7db0a[i] GetCentroid();
				if(BulletTracePassed(origin, centroid, 0, undefined))
				{
					return var_45e7db0a[i];
				}
			}
		}
	}
	return undefined;
}

/*
	Name: function_23b41a73
	Namespace: namespace_d2920ea5
	Checksum: 0x1AD87A5C
	Offset: 0x1A58
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_23b41a73(parent)
{
	while(1)
	{
		if(!isdefined(parent))
		{
			zm_utility::self_delete();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_aa44140a
	Namespace: namespace_d2920ea5
	Checksum: 0x74312B56
	Offset: 0x1AA8
	Size: 0x7D
	Parameters: 2
	Flags: None
*/
function function_aa44140a(model, info)
{
	monk_scream_vox = 0;
	if(level.music_override == 0)
	{
		monk_scream_vox = 0;
		self playsound("zmb_monkey_song");
	}
	self waittill("explode", position);
}

/*
	Name: function_cf5a6be4
	Namespace: namespace_d2920ea5
	Checksum: 0x1772A031
	Offset: 0x1B30
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_cf5a6be4()
{
	self endon("disconnect");
	self endon("hash_c3d84139");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(weapon == level.var_21ae0b78)
		{
			return grenade;
		}
		wait(0.05);
	}
}

/*
	Name: function_ed6a01ce
	Namespace: namespace_d2920ea5
	Checksum: 0xAC58E4B0
	Offset: 0x1BA8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function function_ed6a01ce(msg, color)
{
	/#
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + VectorScale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: function_38be5ec1
	Namespace: namespace_d2920ea5
	Checksum: 0x2CCBA0BD
	Offset: 0x1C20
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_38be5ec1()
{
	if(!isdefined(self.var_b1cb3746))
	{
		self.var_b1cb3746 = 0;
		return;
	}
	self.var_b1cb3746 = self.var_b1cb3746 + 1;
	if(self.var_b1cb3746 >= level.var_db1bba6e)
	{
		self.var_b1cb3746 = 0;
	}
}

/*
	Name: function_f1cbce42
	Namespace: namespace_d2920ea5
	Checksum: 0x85970470
	Offset: 0x1C80
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function function_f1cbce42(var_b1cb3746)
{
	self endon("end_achievement_tracker" + var_b1cb3746);
	if(!isdefined(self.var_2f6526f3))
	{
		self.var_2f6526f3 = [];
		for(i = 0; i < level.var_db1bba6e; i++)
		{
			self.var_2f6526f3[i] = [];
		}
	}
	for(i = 0; i < 4; i++)
	{
		self.var_2f6526f3[var_b1cb3746][i] = 0;
	}
}

/*
	Name: function_553c8cdb
	Namespace: namespace_d2920ea5
	Checksum: 0x145525F6
	Offset: 0x1D30
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function function_553c8cdb(var_b1cb3746)
{
	self waittill("end_achievement_tracker" + var_b1cb3746);
	var_d704b2c3 = 1;
	for(i = 0; i < 4; i++)
	{
		if(self.var_2f6526f3[var_b1cb3746][i] < var_d704b2c3)
		{
			return;
		}
	}
}

/*
	Name: function_f4b4582d
	Namespace: namespace_d2920ea5
	Checksum: 0x1396AB39
	Offset: 0x1DB0
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function function_f4b4582d(id)
{
	if(!isdefined(self.var_295a50c4))
	{
		self.var_295a50c4 = [];
	}
	var_7b2bee5c = Array(0, 1, 2, 3);
	self.var_295a50c4[id] = Array::randomize(var_7b2bee5c);
}

/*
	Name: function_92b451d9
	Namespace: namespace_d2920ea5
	Checksum: 0xC0252611
	Offset: 0x1E30
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_92b451d9()
{
	self endon("death");
	self endon("disconnect");
	wait(0.5);
	var_10601dca = self.var_b1cb3746 + 1;
	if(var_10601dca >= level.var_db1bba6e)
	{
		var_10601dca = 0;
	}
	self function_f4b4582d(var_10601dca);
	if(self HasWeapon(level.var_21ae0b78))
	{
		cammo = level.var_7379c29d[self.var_295a50c4[var_10601dca][0]].id;
		self function_c8540b60(level.var_21ae0b78, self CalcWeaponOptions(cammo, 0, 0));
	}
}

