#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_castle_ee;
#using scripts\zm\zm_castle_teleporter;
#using scripts\zm\zm_castle_util;

#namespace namespace_61c0be00;

/*
	Name: __init__sytem__
	Namespace: namespace_61c0be00
	Checksum: 0xFF5BC96E
	Offset: 0xCD8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee_side", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_61c0be00
	Checksum: 0x4C371D8F
	Offset: 0xD18
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["def_explode"] = "explosions/fx_exp_grenade_default";
	level._effect["mechz_rocket_punch"] = "dlc1/castle/fx_mech_jump_booster_loop";
	clientfield::register("world", "clocktower_flash", 5000, 1, "counter");
	clientfield::register("world", "sndUEB", 5000, 1, "int");
	clientfield::register("actor", "plunger_exploding_ai", 5000, 1, "int");
	clientfield::register("toplayer", "plunger_charged_strike", 5000, 1, "counter");
	zm::register_player_damage_callback(&function_b98927d4);
	zm::register_actor_damage_callback(&function_f10f1879);
}

/*
	Name: main
	Namespace: namespace_61c0be00
	Checksum: 0x98420F2A
	Offset: 0xE60
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function main()
{
	level.gravity_trap_spike_watcher = &gravity_trap_spike_watcher;
	level thread function_e437a08f();
	init_flags();
	level waittill("start_zombie_round_logic");
	level thread function_452b0b5a();
	function_70b74a2d();
	function_b8645c20();
	function_fd2e0e37();
	function_769b2ff();
	function_7998107();
	function_9e325d85();
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level thread function_d6026710();
		}
	#/
}

/*
	Name: init_flags
	Namespace: namespace_61c0be00
	Checksum: 0xCA197EF6
	Offset: 0xF68
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function init_flags()
{
	level flag::init("play_vocals");
	level flag::init("ee_power_clocktower");
	level flag::init("ee_claw_hat");
	level flag::init("ee_disco_inferno");
	level flag::init("ee_power_wallrun_teleport");
	level flag::init("ee_music_box_turning");
	level flag::init("plunger_teleport_on");
}

/*
	Name: function_452b0b5a
	Namespace: namespace_61c0be00
	Checksum: 0x53763BA3
	Offset: 0x1058
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function function_452b0b5a()
{
	function_9b385ca5();
	level.var_818b7815 = var_66e46dd;
	init();
	level thread function_e3163325();
	function_9b385ca5();
	level.var_9f94326b = var_d7100ae3;
	init();
	function_ec1f5e9(level.var_9f94326b, 1);
	level flag::wait_till("ee_power_clocktower");
	start();
}

/*
	Name: function_70b74a2d
	Namespace: namespace_61c0be00
	Checksum: 0xB5A0AEA7
	Offset: 0x1120
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_70b74a2d()
{
	level thread function_5c600852();
	level thread function_553b8e23();
	level thread spare_change();
	level thread function_7c237ecb();
	level thread function_52c08eab();
	level thread function_4eb3851();
	level thread function_c691b60();
}

/*
	Name: function_e3163325
	Namespace: namespace_61c0be00
	Checksum: 0x2D50199C
	Offset: 0x11D8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_e3163325()
{
	level flag::wait_till("power_on");
	start();
}

/*
	Name: function_c691b60
	Namespace: namespace_61c0be00
	Checksum: 0xDED9D366
	Offset: 0x1218
	Size: 0x18D
	Parameters: 0
	Flags: None
*/
function function_c691b60()
{
	for(i = 0; i < 5; i++)
	{
		var_2de8cf5e = struct::get_array("ee_groph_reels_" + i, "targetname");
		foreach(var_7b352087 in var_2de8cf5e)
		{
			var_df5776d8 = util::spawn_model(var_7b352087.model, var_7b352087.origin, var_7b352087.angles);
			var_7b352087.var_df5776d8 = var_df5776d8;
			var_7b352087.var_df5776d8 thread function_2db2bf79();
		}
		if(i == 0)
		{
			level thread function_374ac18c(var_2de8cf5e, i);
			continue;
		}
		level thread function_6bf381de(var_2de8cf5e, i);
	}
}

/*
	Name: function_6bf381de
	Namespace: namespace_61c0be00
	Checksum: 0xE6EF533
	Offset: 0x13B0
	Size: 0xA7
	Parameters: 2
	Flags: None
*/
function function_6bf381de(var_2de8cf5e, var_bee8e45)
{
	while(1)
	{
		var_2de8cf5e[0] namespace_744abc1c::create_unitrigger();
		var_2de8cf5e[0] waittill("trigger_activated");
		function_972992c4(var_2de8cf5e, 1);
		var_2de8cf5e[0].var_df5776d8 function_ffa9011b(var_bee8e45);
		function_972992c4(var_2de8cf5e, 0);
	}
}

/*
	Name: function_374ac18c
	Namespace: namespace_61c0be00
	Checksum: 0x1390ECB1
	Offset: 0x1460
	Size: 0x17F
	Parameters: 2
	Flags: None
*/
function function_374ac18c(var_2de8cf5e, var_bee8e45)
{
	var_2de8cf5e[0].var_df5776d8 SetCanDamage(1);
	while(1)
	{
		var_2de8cf5e[0].var_df5776d8.health = 1000000;
		var_2de8cf5e[0].var_df5776d8 waittill("damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			continue;
		}
		function_972992c4(var_2de8cf5e, 1);
		var_2de8cf5e[0].var_df5776d8 function_ffa9011b(var_bee8e45);
		function_972992c4(var_2de8cf5e, 0);
	}
}

/*
	Name: function_ffa9011b
	Namespace: namespace_61c0be00
	Checksum: 0x4B3C2788
	Offset: 0x15E8
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_ffa9011b(var_bee8e45)
{
	self PlaySoundWithNotify("vox_grop_groph_radio_stem_" + var_bee8e45 + 1, "sounddone");
	self waittill("sounddone");
}

/*
	Name: function_972992c4
	Namespace: namespace_61c0be00
	Checksum: 0xC73B926E
	Offset: 0x1638
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function function_972992c4(var_2de8cf5e, b_on)
{
	foreach(var_7b352087 in var_2de8cf5e)
	{
		if(isdefined(var_7b352087.var_df5776d8))
		{
			var_7b352087.var_df5776d8.var_a02b0d5a = b_on;
		}
	}
}

/*
	Name: function_2db2bf79
	Namespace: namespace_61c0be00
	Checksum: 0xE95EA75C
	Offset: 0x16F8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_2db2bf79()
{
	while(1)
	{
		if(isdefined(self.var_a02b0d5a) && self.var_a02b0d5a)
		{
			self RotateRoll(-30, 0.2);
		}
		wait(0.2);
	}
}

/*
	Name: function_e437a08f
	Namespace: namespace_61c0be00
	Checksum: 0x22706CC0
	Offset: 0x1750
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_e437a08f()
{
	var_2c4303b6 = struct::get("ee_music_box");
	level.var_6d5fd229 = util::spawn_model("p7_fxanim_zm_castle_music_box_mod", var_2c4303b6.origin, var_2c4303b6.angles);
	level.var_6d5fd229 useanimtree(-1);
}

/*
	Name: function_4eb3851
	Namespace: namespace_61c0be00
	Checksum: 0x2F39159C
	Offset: 0x17E0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_4eb3851()
{
	level thread function_4e9df779();
	while(1)
	{
		level.var_6d5fd229 namespace_744abc1c::create_unitrigger();
		level.var_6d5fd229 waittill("trigger_activated");
		level flag::set("ee_music_box_turning");
		zm_unitrigger::unregister_unitrigger(level.var_6d5fd229.s_unitrigger);
		level.var_6d5fd229 playsound("mus_samantha_musicbox");
		wait(36);
		level flag::clear("ee_music_box_turning");
		level waittill("hash_22c84c8b");
	}
}

/*
	Name: function_4e9df779
	Namespace: namespace_61c0be00
	Checksum: 0x9E51227F
	Offset: 0x18C8
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function function_4e9df779()
{
	while(1)
	{
		level.var_6d5fd229 animation::first_frame("p7_fxanim_zm_castle_music_box_anim");
		level flag::wait_till("ee_music_box_turning");
		while(level flag::get("ee_music_box_turning"))
		{
			level.var_6d5fd229 animation::Play("p7_fxanim_zm_castle_music_box_anim");
		}
		level notify("hash_22c84c8b");
	}
}

/*
	Name: function_7998107
	Namespace: namespace_61c0be00
	Checksum: 0xF2F35ABC
	Offset: 0x1978
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function function_7998107()
{
	level.var_37c0c840 = [];
	for(i = 0; i < 3; i++)
	{
		var_d5409ac0 = struct::get("ee_flying_skull_" + i);
		level.var_37c0c840[i] = util::spawn_model("rune_prison_death_skull", var_d5409ac0.origin, var_d5409ac0.angles);
		level.var_37c0c840[i] flag::init("skull_revealed");
		level.var_37c0c840[i] SetCanDamage(1);
		level.var_37c0c840[i] thread function_e26b6053();
		level.var_37c0c840[i] thread function_27da29cb();
		level.var_37c0c840[i] SetInvisibleToAll();
	}
	players = level.activePlayers;
	foreach(player in players)
	{
		player thread function_5c351802();
	}
	callback::on_spawned(&function_5c351802);
}

/*
	Name: function_5c351802
	Namespace: namespace_61c0be00
	Checksum: 0xC07DDFFD
	Offset: 0x1B98
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_5c351802()
{
	for(i = 0; i < 3; i++)
	{
		self thread function_2f183e13(i);
	}
}

/*
	Name: function_2f183e13
	Namespace: namespace_61c0be00
	Checksum: 0x6397B2D1
	Offset: 0x1BE8
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function function_2f183e13(n_index)
{
	level.var_37c0c840[n_index] endon("hash_7a2f636b");
	if(!isdefined(level.var_37c0c840[n_index]))
	{
		return;
	}
	if(level.var_37c0c840[n_index] flag::get("skull_revealed"))
	{
		return;
	}
	while(1)
	{
		self waittill("hash_95b677dc");
		if(self bgb::is_active("zm_bgb_in_plain_sight"))
		{
			level.var_37c0c840[n_index] SetVisibleToPlayer(self);
			self waittill("hash_1565b2f5");
			level.var_37c0c840[n_index] SetInvisibleToPlayer(self);
		}
	}
}

/*
	Name: function_e26b6053
	Namespace: namespace_61c0be00
	Checksum: 0x8B9C5715
	Offset: 0x1CE8
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function function_e26b6053()
{
	var_7b63bfc8 = 0;
	while(!var_7b63bfc8)
	{
		self.health = 1000000;
		self waittill("damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(isdefined(attacker) && isPlayer(attacker) && attacker bgb::is_active("zm_bgb_in_plain_sight"))
		{
			if(function_ab61ab31(weapon))
			{
				var_7b63bfc8 = 1;
			}
		}
	}
	function_44ea752c();
	self flag::set("skull_revealed");
	playFX(level._effect["def_explode"], self.origin);
	self delete();
}

/*
	Name: function_ab61ab31
	Namespace: namespace_61c0be00
	Checksum: 0xB23CBD68
	Offset: 0x1E88
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function function_ab61ab31(weapon)
{
	return IsSubStr(weapon.name, "elemental_bow");
}

/*
	Name: function_44ea752c
	Namespace: namespace_61c0be00
	Checksum: 0xAE669535
	Offset: 0x1EC8
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_44ea752c()
{
	if(!isdefined(level.var_a0554b26))
	{
		level.var_a0554b26 = 0;
	}
	function_dbc1fb93(level.var_a0554b26);
	level.var_a0554b26++;
	playsoundatposition("zmb_ee_skpower_" + level.var_a0554b26, (0, 0, 0));
	if(level.var_a0554b26 == 3)
	{
		level.var_9bf9e084 = 1;
	}
}

/*
	Name: function_dbc1fb93
	Namespace: namespace_61c0be00
	Checksum: 0xEC4A9F21
	Offset: 0x1F50
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_dbc1fb93(var_d237c2be)
{
	if(!isdefined(level.var_478986c0))
	{
		level.var_478986c0 = [];
	}
	var_fff40961 = struct::get("ee_skull_pile_" + var_d237c2be);
	level.var_478986c0[var_d237c2be] = util::spawn_model("rune_prison_death_skull", var_fff40961.origin, var_fff40961.angles);
	if(var_d237c2be == 2)
	{
		level.var_478986c0[var_d237c2be] thread function_67a47b1c();
	}
}

/*
	Name: function_67a47b1c
	Namespace: namespace_61c0be00
	Checksum: 0x4330D5EA
	Offset: 0x2020
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_67a47b1c()
{
	self namespace_744abc1c::create_unitrigger();
	self waittill("trigger_activated");
	if(level.var_9bf9e084 == 0)
	{
		return;
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	level.var_9bf9e084 = 0;
	playsoundatposition("zmb_ee_skpower_deactivate", (0, 0, 0));
	for(i = 0; i < 3; i++)
	{
		if(isdefined(level.var_478986c0[i]))
		{
			playFX(level._effect["def_explode"], level.var_478986c0[i].origin);
			level.var_478986c0[i] delete();
		}
		wait(0.5);
	}
	level thread function_3c992a71();
}

/*
	Name: function_3c992a71
	Namespace: namespace_61c0be00
	Checksum: 0x95B80BE4
	Offset: 0x2160
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_3c992a71()
{
	level.var_a0554b26 = 0;
	level.var_478986c0 = [];
	level thread function_7998107();
}

/*
	Name: function_27da29cb
	Namespace: namespace_61c0be00
	Checksum: 0xA1D4FCA8
	Offset: 0x21A0
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function function_27da29cb()
{
	self endon("hash_7a2f636b");
	var_43af6ca7 = self.origin[2];
	while(1)
	{
		n_current_time = GetTime();
		n_offset = sin(n_current_time * 0.1) * 16;
		v_origin = self.origin;
		self.origin = (v_origin[0], v_origin[1], var_43af6ca7 + n_offset);
		wait(0.05);
	}
}

#namespace namespace_66e46dd;

/*
	Name: init
	Namespace: namespace_66e46dd
	Checksum: 0x9B45F11E
	Offset: 0x2268
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function init()
{
	self.var_41660b94 = 1;
	self.var_11a8191e = 1;
	self.var_a802d3d9 = 1;
	self.var_c86771bb = GetEnt("ee_disco_earth", "targetname");
	self.var_d502c153 = GetEnt("ee_disco_arm_moon", "targetname");
	self.var_16cc14d0 = GetEnt("ee_disco_arm_rocket", "targetname");
	self.var_2eb50ca2 = GetEnt("ee_disco_moon", "targetname");
	self.var_d6478e9 = GetEnt("ee_disco_moon_rocket", "targetname");
	self.var_2eb50ca2 LinkTo(self.var_d502c153, "tag_moon");
	self.var_d6478e9 LinkTo(self.var_d502c153, "tag_moon");
	self.var_b548cd69 = 5;
	self.var_f35c15fb = 1;
	self.var_95126c9c = -3;
	self.var_9abb59c4 = 2;
	self.var_90e84049 = 3;
}

/*
	Name: start
	Namespace: namespace_66e46dd
	Checksum: 0xC0211716
	Offset: 0x23F0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function start()
{
	self thread function_290563e9();
	self thread function_1a856336();
	self thread function_4217f0a1();
}

/*
	Name: function_290563e9
	Namespace: namespace_66e46dd
	Checksum: 0x2F030FCA
	Offset: 0x2448
	Size: 0x38F
	Parameters: 0
	Flags: None
*/
function function_290563e9()
{
	while(1)
	{
		if(!function_755ccf7d())
		{
			wait(0.5);
			continue;
		}
		if(level flag::get("ee_disco_inferno") == 1)
		{
			self.var_5ae81506 = 4;
		}
		else
		{
			self.var_5ae81506 = 1;
		}
		self.var_c86771bb RotateYaw(self.var_b548cd69 * self.var_f35c15fb * self.var_5ae81506, 0.5);
		self.var_d6478e9 RotateYaw(self.var_b548cd69 * self.var_9abb59c4 * self.var_90e84049 * self.var_5ae81506, 0.5);
		if(self.var_11a8191e)
		{
			self.var_d502c153 RotateYaw(self.var_b548cd69 * self.var_9abb59c4 * self.var_5ae81506, 0.5);
			self.var_2eb50ca2 RotateYaw(self.var_b548cd69 * self.var_9abb59c4 * self.var_5ae81506, 0.5);
		}
		if(self.var_a802d3d9)
		{
			self.var_16cc14d0 RotateYaw(self.var_b548cd69 * self.var_f35c15fb * self.var_95126c9c * self.var_5ae81506, 0.5);
		}
		if(!self.var_11a8191e && !self.var_a802d3d9)
		{
			var_d536dea5 = self.var_d502c153.angles;
			var_74c90acc = self.var_16cc14d0.angles;
			var_5375e06e = Abs(Int(var_d536dea5[1] + 142) % 360);
			var_7b4ccc8b = Int(Abs(var_74c90acc[1])) % 360;
			if(var_74c90acc[1] < 0)
			{
				var_15a04435 = 360 - var_7b4ccc8b;
			}
			else
			{
				var_15a04435 = var_7b4ccc8b;
			}
			var_a0dd62e5 = Abs(var_5375e06e - var_15a04435);
			if(var_a0dd62e5 > 180)
			{
				var_a0dd62e5 = 360 - var_a0dd62e5;
			}
			/#
				IPrintLnBold("Dev Block strings are not supported" + var_5375e06e + "Dev Block strings are not supported" + var_15a04435 + "Dev Block strings are not supported" + var_a0dd62e5);
			#/
			if(var_a0dd62e5 <= 45)
			{
				level flag::set("ee_disco_inferno");
				self.var_11a8191e = 1;
				self.var_a802d3d9 = 1;
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_755ccf7d
	Namespace: namespace_66e46dd
	Checksum: 0xBB7F0504
	Offset: 0x27E0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_755ccf7d()
{
	var_8b79520 = Array("zone_great_hall", "zone_great_hall_upper", "zone_great_hall_upper_left", "zone_armory", "zone_undercroft_chapel", "zone_courtyard", "zone_courtyard_edge");
	foreach(var_348ee409 in var_8b79520)
	{
		if(zm_zonemgr::any_player_in_zone(var_348ee409))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_1401a672
	Namespace: namespace_66e46dd
	Checksum: 0xD8F70D5
	Offset: 0x28D0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function function_1401a672(var_fc7b760)
{
	self.var_41660b94 = var_fc7b760;
}

/*
	Name: function_1a856336
	Namespace: namespace_66e46dd
	Checksum: 0xEFBEE88A
	Offset: 0x28F0
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_1a856336()
{
	self.var_2eb50ca2 SetCanDamage(1);
	while(1)
	{
		self.var_2eb50ca2.health = 1000000;
		self.var_2eb50ca2 waittill("damage", damage, attacker);
		if(!self.var_41660b94)
		{
			continue;
		}
		self.var_11a8191e = 0;
		wait(3);
		self.var_11a8191e = 1;
	}
}

/*
	Name: function_4217f0a1
	Namespace: namespace_66e46dd
	Checksum: 0x387BEDB3
	Offset: 0x2998
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_4217f0a1()
{
	self.var_16cc14d0 SetCanDamage(1);
	while(1)
	{
		self.var_16cc14d0.health = 1000000;
		self.var_16cc14d0 waittill("damage", damage, attacker);
		if(!self.var_41660b94)
		{
			continue;
		}
		self.var_a802d3d9 = 0;
		wait(3);
		self.var_a802d3d9 = 1;
	}
}

/*
	Name: function_9b385ca5
	Namespace: namespace_66e46dd
	Checksum: 0x99EC1590
	Offset: 0x2A40
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_66e46dd
	Checksum: 0x99EC1590
	Offset: 0x2A50
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_61c0be00;

/*
	Name: function_66e46dd
	Namespace: namespace_61c0be00
	Checksum: 0x6DDAF861
	Offset: 0x2A60
	Size: 0x1D5
	Parameters: 0
	Flags: 6
*/
function private autoexec function_66e46dd()
{
	classes.var_66e46dd[0] = spawnstruct();
	classes.var_66e46dd[0].__vtable[1606033458] = &namespace_66e46dd::function_5fba2032;
	classes.var_66e46dd[0].__vtable[-1690805083] = &namespace_66e46dd::function_9b385ca5;
	classes.var_66e46dd[0].__vtable[1108865185] = &namespace_66e46dd::function_4217f0a1;
	classes.var_66e46dd[0].__vtable[444949302] = &namespace_66e46dd::function_1a856336;
	classes.var_66e46dd[0].__vtable[335652466] = &namespace_66e46dd::function_1401a672;
	classes.var_66e46dd[0].__vtable[1969016701] = &namespace_66e46dd::function_755ccf7d;
	classes.var_66e46dd[0].__vtable[688219113] = &namespace_66e46dd::function_290563e9;
	classes.var_66e46dd[0].__vtable[55554463] = &namespace_66e46dd::start;
	classes.var_66e46dd[0].__vtable[-1017222485] = &namespace_66e46dd::init;
}

/*
	Name: function_769b2ff
	Namespace: namespace_61c0be00
	Checksum: 0xAE1AFFDF
	Offset: 0x2C40
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function function_769b2ff()
{
	level.var_23825200 = [];
	for(i = 0; i < 3; i++)
	{
		var_95164560 = struct::get("ee_claw_" + i + "_start");
		level.var_23825200[i] = util::spawn_model("c_t6_zom_mech_claw", var_95164560.origin, var_95164560.angles);
		level.var_23825200[i] flag::init("mechz_claw_revealed");
		level.var_23825200[i] SetCanDamage(1);
		level.var_23825200[i] thread function_e249cd7(i);
	}
}

/*
	Name: function_5d2ff09a
	Namespace: namespace_61c0be00
	Checksum: 0x500AA027
	Offset: 0x2D70
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_5d2ff09a()
{
	for(i = 0; i < 3; i++)
	{
		function_c02b51fb(i);
	}
}

/*
	Name: function_c02b51fb
	Namespace: namespace_61c0be00
	Checksum: 0x4C39FAC6
	Offset: 0x2DC0
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function function_c02b51fb(n_index)
{
	level.var_23825200[n_index] endon("hash_8a2ede71");
	if(level.var_23825200[n_index] flag::get("mechz_claw_revealed"))
	{
		return;
	}
	while(1)
	{
		self waittill("hash_95b677dc");
		if(self bgb::is_active("zm_bgb_in_plain_sight"))
		{
			level.var_23825200[n_index] SetVisibleToPlayer(self);
			self waittill("hash_1565b2f5");
			level.var_23825200[n_index] SetInvisibleToPlayer(self);
		}
	}
}

/*
	Name: function_e249cd7
	Namespace: namespace_61c0be00
	Checksum: 0xCC789A3E
	Offset: 0x2EA8
	Size: 0x32B
	Parameters: 1
	Flags: None
*/
function function_e249cd7(n_index)
{
	var_8b9b7897 = 0;
	while(!var_8b9b7897)
	{
		self.health = 1000000;
		var_354439b5 = self function_64e6de56();
		if(!var_354439b5)
		{
			continue;
		}
		var_8b9b7897 = 1;
		self playsound("zmb_ee_mechz_imp");
		self SetCanDamage(0);
	}
	self flag::set("mechz_claw_revealed");
	self SetVisibleToAll();
	var_7ddcf23 = struct::get("ee_claw_" + n_index + "_fell");
	self moveto(var_7ddcf23.origin, 0.333);
	self thread function_4767e6ca();
	wait(0.333);
	self SetCanDamage(1);
	var_f9f3d790 = 0;
	while(!var_f9f3d790)
	{
		self.health = 1000000;
		var_354439b5 = self function_64e6de56();
		if(!var_354439b5)
		{
			continue;
		}
		var_f9f3d790 = 1;
		self playsound("zmb_ee_mechz_activate");
		self PlayLoopSound("zmb_ee_mechz_fire_lp", 0.1);
	}
	var_197d929 = struct::get("ee_claw_" + n_index + "_shot");
	self thread function_d23efff2();
	PlayFXOnTag(level._effect["mechz_rocket_punch"], self, "fx_rocket");
	self moveto(var_197d929.origin, 1);
	wait(1);
	self playsound("zmb_ee_mechz_explode");
	playFX(level._effect["def_explode"], self.origin);
	self notify("hash_d23efff2");
	self delete();
}

/*
	Name: function_4767e6ca
	Namespace: namespace_61c0be00
	Checksum: 0xD82E44B2
	Offset: 0x31E0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_4767e6ca()
{
	self waittill("movedone");
	self playsound("zmb_ee_mechz_fallimp");
}

/*
	Name: function_64e6de56
	Namespace: namespace_61c0be00
	Checksum: 0x7840601E
	Offset: 0x3218
	Size: 0x187
	Parameters: 0
	Flags: None
*/
function function_64e6de56()
{
	self waittill("damage", damage, attacker, direction_vec, point, type, tagName, modelName, partName, weapon, inflictor);
	if(type === "MOD_GRENADE" || type === "MOD_GRENADE_SPLASH" || type === "MOD_EXPLOSIVE" || type === "MOD_EXPLOSIVE_SPLASH")
	{
		return 0;
	}
	if(function_ab61ab31(weapon))
	{
		var_64deb4b = spawn("script_origin", point);
		if(!var_64deb4b istouching(self))
		{
			var_64deb4b delete();
			return 0;
		}
		var_64deb4b delete();
	}
	if(!isdefined(attacker) || !isPlayer(attacker))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_d23efff2
	Namespace: namespace_61c0be00
	Checksum: 0x484E73D4
	Offset: 0x33A8
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function function_d23efff2()
{
	self endon("hash_d23efff2");
	while(1)
	{
		a_enemies = function_846256f4("axis");
		foreach(e_enemy in a_enemies)
		{
			dist2 = DistanceSquared(self.origin, e_enemy.origin);
			if(dist2 < 16384)
			{
				if(isdefined(e_enemy) && isalive(e_enemy))
				{
					if(isdefined(e_enemy.archetype) && e_enemy.archetype == "mechz")
					{
						e_enemy DoDamage(self.health * 777, e_enemy.origin);
						if(!isdefined(level.var_708b5a49))
						{
							level.var_708b5a49 = 1;
						}
						else
						{
							level.var_708b5a49++;
						}
						if(level.var_708b5a49 == 3)
						{
							function_90b13c3d();
						}
						continue;
					}
					if(isdefined(e_enemy.archetype) && e_enemy.archetype == "zombie")
					{
						e_enemy thread zombie_death::do_gib();
					}
				}
			}
		}
		wait(0.2);
	}
}

/*
	Name: function_d249c76c
	Namespace: namespace_61c0be00
	Checksum: 0xCCB5559C
	Offset: 0x35B0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_d249c76c()
{
	self Attach("c_t6_zom_mech_claw_hat", "j_head");
}

/*
	Name: function_90b13c3d
	Namespace: namespace_61c0be00
	Checksum: 0xA2FF3FA6
	Offset: 0x35E8
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_90b13c3d()
{
	players = level.activePlayers;
	foreach(player in players)
	{
		player function_d249c76c();
	}
	level flag::set("ee_claw_hat");
	callback::on_spawned(&function_d249c76c);
}

/*
	Name: function_b8645c20
	Namespace: namespace_61c0be00
	Checksum: 0x9E344412
	Offset: 0x36C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_b8645c20()
{
	level.var_91b525ed = 0;
	function_79e1bd74(0);
}

/*
	Name: function_79e1bd74
	Namespace: namespace_61c0be00
	Checksum: 0x5D134458
	Offset: 0x36F8
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function function_79e1bd74(n_level)
{
	var_5824233 = Array("p7_zm_ctl_newspaper_01_parade", "p7_zm_ctl_newspaper_01_attacks", "p7_zm_ctl_newspaper_01_outbreak");
	STR_MODEL = var_5824233[n_level];
	if(!isdefined(level.var_31e6a027))
	{
		var_21231084 = struct::get("ee_newspaper");
		level.var_31e6a027 = util::spawn_model(STR_MODEL, var_21231084.origin, var_21231084.angles);
	}
	else
	{
		level.var_31e6a027 SetModel(STR_MODEL);
	}
}

/*
	Name: function_fd2e0e37
	Namespace: namespace_61c0be00
	Checksum: 0x21CE5A87
	Offset: 0x37E0
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_fd2e0e37()
{
	level.var_f4166c4f = 0;
	s_loc = struct::get("ee_plunger_pickup");
	level.var_163864b7 = util::spawn_model("wpn_t7_zmb_dlc1_plunger_world", s_loc.origin, s_loc.angles);
	level thread function_4811d22b();
	function_56e07512(s_loc);
}

/*
	Name: function_4811d22b
	Namespace: namespace_61c0be00
	Checksum: 0x825CDAD9
	Offset: 0x3890
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_4811d22b()
{
	level endon("hash_4811d22b");
	level.var_163864b7 SetInvisibleToAll();
	while(1)
	{
		level flag::wait_till("plunger_teleport_on");
		level.var_163864b7 SetVisibleToAll();
		level flag::wait_till_clear("plunger_teleport_on");
		level.var_163864b7 SetInvisibleToAll();
	}
}

/*
	Name: function_b98927d4
	Namespace: namespace_61c0be00
	Checksum: 0x5D0E4394
	Offset: 0x3938
	Size: 0x129
	Parameters: 10
	Flags: None
*/
function function_b98927d4(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(level flag::get("ee_claw_hat") && eAttacker.archetype == "mechz")
	{
		switch(sMeansOfDeath)
		{
			case "MOD_MELEE":
			{
				iDamage = iDamage * 0.5;
				break;
			}
			case "MOD_BURNED":
			{
				iDamage = iDamage * 0.5;
				break;
			}
			case "MOD_PROJECTILE_SPLASH":
			{
				iDamage = iDamage * 0.5;
				break;
			}
		}
		iDamage = Int(iDamage);
		return iDamage;
	}
	return -1;
}

/*
	Name: function_52c08eab
	Namespace: namespace_61c0be00
	Checksum: 0x76EE9B6E
	Offset: 0x3A70
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function function_52c08eab()
{
	while(1)
	{
		level flag::wait_till("ee_disco_inferno");
		function_1401a672(level.var_818b7815);
		level.var_818b7815.var_c86771bb playsound("mus_ee_disco");
		level thread LUI::screen_flash(0.15, 0.1, 0.5, 1, "white");
		wait(0.15);
		exploder::exploder("disco_lgt");
		wait(52);
		exploder::exploder_stop("disco_lgt");
		level flag::clear("ee_disco_inferno");
		function_1401a672(level.var_818b7815);
	}
}

/*
	Name: function_7c237ecb
	Namespace: namespace_61c0be00
	Checksum: 0xF1FF9847
	Offset: 0x3BA0
	Size: 0x313
	Parameters: 1
	Flags: None
*/
function function_7c237ecb(var_f00386ff)
{
	if(!isdefined(var_f00386ff))
	{
		var_f00386ff = 0;
	}
	if(!SessionModeIsOnlineGame() && !var_f00386ff)
	{
		return;
	}
	var_c27c9236 = struct::get("ee_plant_present");
	var_15cfdc94 = util::spawn_model("p7_zm_ctl_plant_decor_sprout", var_c27c9236.origin, var_c27c9236.angles);
	var_15cfdc94 namespace_744abc1c::create_unitrigger();
	var_15cfdc94 waittill("trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_15cfdc94.s_unitrigger);
	var_15cfdc94 Hide();
	var_1f6712bd = struct::get("ee_plant_past");
	var_4bb0e877 = util::spawn_model("p7_zm_ctl_plant_decor_sprout", var_1f6712bd.origin, var_1f6712bd.angles);
	var_4bb0e877 Hide();
	var_1f6712bd namespace_744abc1c::create_unitrigger();
	var_1f6712bd waittill("trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_1f6712bd.s_unitrigger);
	var_4bb0e877 show();
	var_f6cbed0f = struct::get("ee_plant_gobblegum");
	var_15cfdc94 SetModel("p7_zm_ctl_plant_decor_grown");
	var_15cfdc94 show();
	var_acadbb15 = util::spawn_model("p7_zm_zod_bubblegum_machine_gumball_white", var_f6cbed0f.origin, var_f6cbed0f.angles);
	var_15cfdc94 namespace_744abc1c::create_unitrigger();
	var_15cfdc94 waittill("trigger_activated", player);
	zm_unitrigger::unregister_unitrigger(var_15cfdc94.s_unitrigger);
	var_acadbb15 delete();
	player.var_b287be = bgb::function_d51db887();
	player thread bgb::function_b107a7f3(player.var_b287be, 0);
}

/*
	Name: gravity_trap_spike_watcher
	Namespace: namespace_61c0be00
	Checksum: 0xFCD423D3
	Offset: 0x3EC0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function gravity_trap_spike_watcher(var_eea11f9d)
{
	if(isdefined(level.var_714fae39) && level.var_714fae39 && level flag::get("ee_power_clocktower") == 0)
	{
		var_3d98ac09 = GetEnt("clocktower_power_trig", "targetname");
		if(var_eea11f9d istouching(var_3d98ac09))
		{
			level flag::set("ee_power_clocktower");
		}
	}
}

#namespace namespace_d7100ae3;

/*
	Name: init
	Namespace: namespace_d7100ae3
	Checksum: 0xDE192AD0
	Offset: 0x3F78
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function init()
{
	self.var_5c546253 = GetEnt("ee_clocktower_minute_hand", "targetname");
	self.var_1ed02f45 = GetEnt("ee_clocktower_hour_hand", "targetname");
	self.var_8b97288d = GetEnt("ee_clocktower_activation_switch", "targetname");
	self.var_f3c3ca5a = 0;
	self.var_246b41b3 = 0;
	self.var_a117a15d = 0;
	self.var_23036e82 = 0;
	self.var_f3797cc9 = 0;
	self.var_2ed6212f = 0;
}

/*
	Name: start
	Namespace: namespace_d7100ae3
	Checksum: 0x30C25BE8
	Offset: 0x4048
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function start()
{
	self thread function_719601e4();
	while(1)
	{
		if(self.var_f3c3ca5a)
		{
			function_614407e2();
		}
		if(!self.var_f3c3ca5a)
		{
			if(!self.var_23036e82)
			{
				self thread function_da8088ad();
			}
		}
		wait(0.4);
	}
}

/*
	Name: function_ec1f5e9
	Namespace: namespace_d7100ae3
	Checksum: 0xFB054445
	Offset: 0x40C8
	Size: 0x1FB
	Parameters: 3
	Flags: None
*/
function function_ec1f5e9(var_8deda1b1, var_a00b65f, var_1133e63b)
{
	if(!isdefined(var_1133e63b))
	{
		var_1133e63b = 20;
	}
	var_3e7e6c38 = self.var_f3c3ca5a;
	self function_9b5dc008(0);
	self.var_2ed6212f = 1;
	var_16c3da4f = var_a00b65f - self.var_246b41b3;
	if(var_16c3da4f < 0)
	{
		var_16c3da4f = 60 + var_16c3da4f;
	}
	var_2dc617a1 = var_8deda1b1 - self.var_a117a15d;
	if(var_2dc617a1 < 0)
	{
		var_2dc617a1 = 12 + var_2dc617a1;
	}
	/#
		iprintln("Dev Block strings are not supported" + var_2dc617a1 + "Dev Block strings are not supported" + var_16c3da4f);
	#/
	self.var_5c546253 RotatePitch(-6 * var_16c3da4f, 0.05 * var_16c3da4f * 1 / var_1133e63b);
	self.var_1ed02f45 RotatePitch(-30 * var_2dc617a1, 0.05 * var_2dc617a1 * 1 / var_1133e63b);
	self.var_246b41b3 = var_a00b65f;
	self.var_a117a15d = var_8deda1b1;
	/#
		iprintln("Dev Block strings are not supported" + self.var_a117a15d + "Dev Block strings are not supported" + self.var_246b41b3);
	#/
	self.var_2ed6212f = 0;
	self function_9b5dc008(var_3e7e6c38);
}

/*
	Name: function_614407e2
	Namespace: namespace_d7100ae3
	Checksum: 0x3B3523D
	Offset: 0x42D0
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_614407e2()
{
	self.var_246b41b3++;
	if(self.var_246b41b3 == 60)
	{
		self.var_246b41b3 = 0;
		self.var_a117a15d++;
	}
	if(self.var_a117a15d == 12)
	{
		self.var_a117a15d = 0;
	}
	self.var_5c546253 RotatePitch(-6, 0.05);
	self.var_5c546253 playsound("evt_min_hand");
	if(self.var_246b41b3 % 12 == 0)
	{
		self.var_1ed02f45 RotatePitch(-6, 0.05);
		self.var_1ed02f45 playsound("evt_hour_hand");
	}
	if(self.var_f3797cc9 && function_1f5408aa())
	{
		self function_9b5dc008(0);
	}
}

/*
	Name: function_da8088ad
	Namespace: namespace_d7100ae3
	Checksum: 0xA71F706E
	Offset: 0x4400
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_da8088ad()
{
	self notify("hash_da8088ad");
	self endon("hash_da8088ad");
	self.var_23036e82 = 1;
	while(1)
	{
		var_6443dac9 = RandomFloatRange(5, 15);
		wait(var_6443dac9);
		level clientfield::increment("clocktower_flash");
		if(function_1f5408aa())
		{
			namespace_61c0be00::function_779bfe1e();
			self.var_1ed02f45 playsound("evt_clock_comp");
			function_614407e2();
		}
	}
}

/*
	Name: function_1f5408aa
	Namespace: namespace_d7100ae3
	Checksum: 0xAA89D86A
	Offset: 0x44E0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_1f5408aa()
{
	if(self.var_a117a15d == 9 && self.var_246b41b3 == 35)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_719601e4
	Namespace: namespace_d7100ae3
	Checksum: 0xE06F50EB
	Offset: 0x4518
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function function_719601e4()
{
	self.var_8b97288d namespace_744abc1c::create_unitrigger();
	while(1)
	{
		self.var_8b97288d waittill("trigger_activated");
		self function_aa7c5ce2();
		self.var_8b97288d playsound("evt_lever");
		if(self.var_f3c3ca5a)
		{
			self notify("hash_da8088ad");
			self.var_23036e82 = 0;
		}
		self.var_8b97288d RotatePitch(60, 0.333);
		wait(0.333);
		self.var_8b97288d RotatePitch(-60, 0.2);
		wait(0.2);
	}
}

/*
	Name: function_9b5dc008
	Namespace: namespace_d7100ae3
	Checksum: 0xB5DBCF55
	Offset: 0x4610
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_9b5dc008(b_on)
{
	if(self.var_2ed6212f)
	{
		return;
	}
	self.var_f3c3ca5a = b_on;
}

/*
	Name: function_aa7c5ce2
	Namespace: namespace_d7100ae3
	Checksum: 0xE49F8012
	Offset: 0x4640
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_aa7c5ce2()
{
	self.var_f3c3ca5a = !self.var_f3c3ca5a;
}

/*
	Name: function_4db73fa1
	Namespace: namespace_d7100ae3
	Checksum: 0x4E5FF5A
	Offset: 0x4660
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_4db73fa1()
{
	self.var_f3797cc9 = !self.var_f3797cc9;
	/#
		if(self.var_f3797cc9)
		{
			IPrintLnBold("Dev Block strings are not supported");
		}
		else
		{
			IPrintLnBold("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_9b385ca5
	Namespace: namespace_d7100ae3
	Checksum: 0x99EC1590
	Offset: 0x46C8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_d7100ae3
	Checksum: 0x99EC1590
	Offset: 0x46D8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_61c0be00;

/*
	Name: function_d7100ae3
	Namespace: namespace_61c0be00
	Checksum: 0x26448C44
	Offset: 0x46E8
	Size: 0x265
	Parameters: 0
	Flags: 6
*/
function private autoexec function_d7100ae3()
{
	classes.var_d7100ae3[0] = spawnstruct();
	classes.var_d7100ae3[0].__vtable[1606033458] = &namespace_d7100ae3::function_5fba2032;
	classes.var_d7100ae3[0].__vtable[-1690805083] = &namespace_d7100ae3::function_9b385ca5;
	classes.var_d7100ae3[0].__vtable[1303855009] = &namespace_d7100ae3::function_4db73fa1;
	classes.var_d7100ae3[0].__vtable[-1434690334] = &namespace_d7100ae3::function_aa7c5ce2;
	classes.var_d7100ae3[0].__vtable[-1688354808] = &namespace_d7100ae3::function_9b5dc008;
	classes.var_d7100ae3[0].__vtable[1905656292] = &namespace_d7100ae3::function_719601e4;
	classes.var_d7100ae3[0].__vtable[525600938] = &namespace_d7100ae3::function_1f5408aa;
	classes.var_d7100ae3[0].__vtable[-629110611] = &namespace_d7100ae3::function_da8088ad;
	classes.var_d7100ae3[0].__vtable[1631848418] = &namespace_d7100ae3::function_614407e2;
	classes.var_d7100ae3[0].__vtable[247592425] = &namespace_d7100ae3::function_ec1f5e9;
	classes.var_d7100ae3[0].__vtable[55554463] = &namespace_d7100ae3::start;
	classes.var_d7100ae3[0].__vtable[-1017222485] = &namespace_d7100ae3::init;
}

/*
	Name: function_9e325d85
	Namespace: namespace_61c0be00
	Checksum: 0xB7E8C520
	Offset: 0x4958
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_9e325d85()
{
	for(i = 0; i < 4; i++)
	{
		var_634fac89 = GetEnt("ee_undercroft_wallrun_" + i, "targetname");
		var_634fac89 thread function_81d41eb8(i);
	}
	var_3294f1d9 = GetEnt("ee_undercroft_wallrun_reset", "targetname");
	var_3294f1d9 thread function_8d508e48();
}

/*
	Name: function_779bfe1e
	Namespace: namespace_61c0be00
	Checksum: 0xB37DED2F
	Offset: 0x4A20
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_779bfe1e()
{
	exploder::exploder("fxexp_600");
	level flag::set("ee_power_wallrun_teleport");
	level clientfield::set("sndUEB", 1);
}

/*
	Name: function_421bb7db
	Namespace: namespace_61c0be00
	Checksum: 0xCB055D2A
	Offset: 0x4A88
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_421bb7db()
{
	exploder::stop_exploder("fxexp_600");
	level flag::clear("ee_power_wallrun_teleport");
	level clientfield::set("sndUEB", 0);
}

/*
	Name: function_81d41eb8
	Namespace: namespace_61c0be00
	Checksum: 0x54721A85
	Offset: 0x4AF0
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_81d41eb8(var_7f701981)
{
	while(1)
	{
		self waittill("trigger", player);
		if(level flag::get("ee_power_wallrun_teleport") == 0)
		{
			continue;
		}
		if(isdefined(player.var_48391945) && var_7f701981 != player.var_48391945)
		{
			var_32ceceb2 = function_6ad38393(player, var_7f701981);
			if(isdefined(player.var_6670513f) && player.var_6670513f == var_32ceceb2)
			{
				player.var_130b9781++;
			}
			else if(!isdefined(player.var_6670513f))
			{
				player.var_130b9781 = 1;
			}
			player.var_6670513f = var_32ceceb2;
		}
		if(player.var_130b9781 === 8)
		{
			function_27b3a99c(player);
		}
		player.var_48391945 = var_7f701981;
	}
}

/*
	Name: function_8d508e48
	Namespace: namespace_61c0be00
	Checksum: 0x651F1ACA
	Offset: 0x4C68
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_8d508e48()
{
	while(1)
	{
		self waittill("trigger", player);
		player.var_130b9781 = 0;
		player.var_48391945 = undefined;
	}
}

/*
	Name: function_6ad38393
	Namespace: namespace_61c0be00
	Checksum: 0x38191CCD
	Offset: 0x4CB8
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function function_6ad38393(player, var_7f701981)
{
	if(player.var_48391945 > var_7f701981 || (player.var_48391945 == 0 && var_7f701981 == 3))
	{
		return 1;
	}
	else if(player.var_48391945 < var_7f701981 || (var_7f701981 == 0 && player.var_48391945 == 3))
	{
		return 0;
	}
}

/*
	Name: function_27b3a99c
	Namespace: namespace_61c0be00
	Checksum: 0x17951D21
	Offset: 0x4D58
	Size: 0x223
	Parameters: 1
	Flags: None
*/
function function_27b3a99c(player)
{
	level.var_f4166c4f++;
	level flag::set("plunger_teleport_on");
	zm_zonemgr::enable_zone("zone_past_laboratory");
	visionset_mgr::activate("overlay", "zm_factory_teleport", player, level.n_teleport_delay, level.n_teleport_delay);
	s_dest = struct::get("ee_teleport_to_plunger_" + player.characterindex, "targetname");
	function_aaacffb2(player, s_dest);
	wait(0.05);
	player clientfield::set_to_player("ee_quest_back_in_time_postfx", 1);
	var_f9d5e23a = player HasWeapon(GetWeapon("knife_plunger"));
	wait(10);
	s_return = struct::get("ee_teleport_return_from_plunger_" + player.characterindex, "targetname");
	player clientfield::set_to_player("ee_quest_back_in_time_postfx", 0);
	visionset_mgr::activate("overlay", "zm_factory_teleport", player, level.n_teleport_delay, level.n_teleport_delay);
	function_aaacffb2(player, s_return);
	level.var_f4166c4f--;
	if(level.var_f4166c4f == 0)
	{
		level flag::clear("plunger_teleport_on");
	}
	function_421bb7db();
}

/*
	Name: function_aaacffb2
	Namespace: namespace_61c0be00
	Checksum: 0x9DA8FF6F
	Offset: 0x4F88
	Size: 0x4D3
	Parameters: 2
	Flags: None
*/
function function_aaacffb2(player, s_dest)
{
	var_daad3c3c = VectorScale((0, 0, 1), 49);
	var_6b55b1c4 = VectorScale((0, 0, 1), 20);
	var_3abe10e2 = (0, 0, 0);
	var_d3263bfe = GetEnt("teleport_room_" + player.characterindex, "targetname");
	player zm_utility::create_streamer_hint(s_dest.origin, s_dest.angles, 0.25);
	if(isdefined(var_d3263bfe))
	{
		visionset_mgr::deactivate("overlay", "zm_trap_electric", player);
		visionset_mgr::activate("overlay", "zm_factory_teleport", player);
		player disableOffhandWeapons();
		player DisableWeapons();
		if(player GetStance() == "prone")
		{
			desired_origin = var_d3263bfe.origin + var_daad3c3c;
		}
		else if(player GetStance() == "crouch")
		{
			desired_origin = var_d3263bfe.origin + var_6b55b1c4;
		}
		else
		{
			desired_origin = var_d3263bfe.origin + var_3abe10e2;
		}
		player.var_39386de = spawn("script_origin", player.origin);
		player.var_39386de.angles = player.angles;
		player LinkTo(player.var_39386de);
		player.var_39386de.origin = desired_origin;
		player FreezeControls(1);
		util::wait_network_frame();
		if(isdefined(player))
		{
			util::setClientSysState("levelNotify", "black_box_start", player);
			player.var_39386de.angles = var_d3263bfe.angles;
		}
	}
	wait(2);
	s_dest thread namespace_fa1b0620::teleport_nuke(undefined, 300);
	for(i = 0; i < level.activePlayers.size; i++)
	{
		util::setClientSysState("levelNotify", "black_box_end", level.activePlayers[i]);
	}
	util::wait_network_frame();
	if(!isdefined(player))
	{
		return;
	}
	player Unlink();
	if(isdefined(player.var_39386de))
	{
		player.var_39386de delete();
		player.var_39386de = undefined;
	}
	visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
	player enableWeapons();
	player EnableOffhandWeapons();
	player SetOrigin(s_dest.origin);
	player SetPlayerAngles(s_dest.angles);
	player FreezeControls(0);
	player thread namespace_fa1b0620::teleport_aftereffects();
	player zm_utility::clear_streamer_hint();
}

/*
	Name: function_56e07512
	Namespace: namespace_61c0be00
	Checksum: 0xB2CA3B4A
	Offset: 0x5468
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function function_56e07512(s_loc)
{
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = 128;
	s_loc.unitrigger_stub.script_height = 128;
	s_loc.unitrigger_stub.script_length = 128;
	s_loc.unitrigger_stub.require_look_at = 1;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_dbab79d5;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_6527501a);
}

/*
	Name: function_dbab79d5
	Namespace: namespace_61c0be00
	Checksum: 0x18475529
	Offset: 0x55F0
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function function_dbab79d5(player)
{
	b_is_invis = 0;
	var_f9d5e23a = player HasWeapon(GetWeapon("knife_plunger"));
	if(var_f9d5e23a)
	{
		b_is_invis = 1;
	}
	if(level.var_f4166c4f == 0)
	{
		b_is_invis = 1;
	}
	self SetInvisibleToPlayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_6527501a
	Namespace: namespace_61c0be00
	Checksum: 0x76852C8D
	Offset: 0x56A0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_6527501a()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		var_f9d5e23a = player HasWeapon(GetWeapon("knife_plunger"));
		if(var_f9d5e23a)
		{
			continue;
		}
		if(level.var_f4166c4f == 0)
		{
			continue;
		}
		level thread function_b7365949(self.stub, player);
		break;
	}
}

/*
	Name: function_b7365949
	Namespace: namespace_61c0be00
	Checksum: 0x41B461DF
	Offset: 0x57A0
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function function_b7365949(trig_stub, player)
{
	level notify("hash_4811d22b");
	level.var_163864b7 delete();
	function_421bb7db();
	zm_spawner::register_zombie_death_event_callback(&function_8d95ec46);
	players = level.activePlayers;
	foreach(player in level.activePlayers)
	{
		if(isdefined(player) && isalive(player))
		{
			player thread function_45b9eba4();
		}
	}
	callback::on_spawned(&function_45b9eba4);
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_45b9eba4
	Namespace: namespace_61c0be00
	Checksum: 0xE1993545
	Offset: 0x5908
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_45b9eba4()
{
	self.widows_wine_knife_override = &function_9ce92341;
	self zm_melee_weapon::award_melee_weapon("knife_plunger");
	self thread function_9daec9e3();
	self thread function_1fcb04d7();
}

/*
	Name: function_9ce92341
	Namespace: namespace_61c0be00
	Checksum: 0x99EC1590
	Offset: 0x5980
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9ce92341()
{
}

/*
	Name: function_1fcb04d7
	Namespace: namespace_61c0be00
	Checksum: 0xA7186F86
	Offset: 0x5990
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function function_1fcb04d7()
{
	self endon("disconnect");
	self waittill("bled_out");
	self.widows_wine_knife_override = undefined;
}

/*
	Name: function_9daec9e3
	Namespace: namespace_61c0be00
	Checksum: 0xD78FFA30
	Offset: 0x59C0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function function_9daec9e3()
{
	self endon("disconnect");
	var_7c4fe278 = GetWeapon("knife_plunger");
	while(1)
	{
		self waittill("weapon_melee", weapon);
		if(weapon == var_7c4fe278 && isdefined(self.var_ea5424ae) && self.var_ea5424ae > 0)
		{
			self clientfield::increment_to_player("plunger_charged_strike");
		}
	}
}

/*
	Name: function_c7bb86e5
	Namespace: namespace_61c0be00
	Checksum: 0x51532645
	Offset: 0x5A60
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_c7bb86e5(attacker)
{
	if(!isdefined(attacker.var_ea5424ae))
	{
		attacker.var_ea5424ae = 0;
	}
	attacker.var_ea5424ae++;
	/#
		iprintln("Dev Block strings are not supported" + attacker.var_ea5424ae);
	#/
	wait(60);
	attacker.var_ea5424ae--;
	/#
		iprintln("Dev Block strings are not supported" + attacker.var_ea5424ae);
	#/
}

/*
	Name: function_8d95ec46
	Namespace: namespace_61c0be00
	Checksum: 0x671EA8A3
	Offset: 0x5B18
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_8d95ec46(e_attacker)
{
	var_7c4fe278 = GetWeapon("knife_plunger");
	if(var_7c4fe278 == self.damageWeapon)
	{
		self zombie_utility::zombie_head_gib();
		return 1;
	}
	return 0;
}

/*
	Name: function_f10f1879
	Namespace: namespace_61c0be00
	Checksum: 0x6770BACD
	Offset: 0x5B80
	Size: 0x16D
	Parameters: 12
	Flags: None
*/
function function_f10f1879(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	var_7c4fe278 = GetWeapon("knife_plunger");
	if(weapon == var_7c4fe278 && isdefined(attacker) && isPlayer(attacker) && isdefined(attacker.var_ea5424ae) && attacker.var_ea5424ae > 0)
	{
		damage = 777 * self.health;
		if(isdefined(self))
		{
			self thread function_beeeab78();
		}
		level.var_91b525ed++;
		if(level.var_91b525ed >= 16)
		{
			function_79e1bd74(2);
		}
		else if(level.var_91b525ed >= 4)
		{
			function_79e1bd74(1);
		}
		return damage;
	}
	return -1;
}

/*
	Name: function_beeeab78
	Namespace: namespace_61c0be00
	Checksum: 0x5FE2D3ED
	Offset: 0x5CF8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_beeeab78()
{
	self clientfield::set("plunger_exploding_ai", 1);
	self zombie_utility::zombie_eye_glow_stop();
	wait(0.15);
	self ghost();
	self util::delay(0.15, undefined, &zm_utility::self_delete);
}

/*
	Name: function_5c600852
	Namespace: namespace_61c0be00
	Checksum: 0x74117F31
	Offset: 0x5D88
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_5c600852()
{
	level.var_89ad28cd = 0;
	var_d959ac05 = GetEntArray("hs_gramophone", "targetname");
	Array::thread_all(var_d959ac05, &function_db46cccd);
	while(1)
	{
		level waittill("hash_9c9fb305");
		if(level.var_89ad28cd == var_d959ac05.size)
		{
			break;
		}
	}
	level thread zm_audio::sndMusicSystem_PlayState("requiem");
}

/*
	Name: function_db46cccd
	Namespace: namespace_61c0be00
	Checksum: 0xAADA0F17
	Offset: 0x5E40
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_db46cccd()
{
	self namespace_744abc1c::create_unitrigger();
	self PlayLoopSound("zmb_ee_gramophone_lp", 1);
	/#
		self thread namespace_744abc1c::function_8faf1d24(VectorScale((0, 0, 1), 255), "Dev Block strings are not supported");
	#/
	while(!(isdefined(self.b_activated) && self.b_activated))
	{
		self waittill("trigger_activated");
		if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || (isdefined(level.musicSystemOverride) && level.musicSystemOverride))
		{
			continue;
		}
		if(!(isdefined(self.b_activated) && self.b_activated))
		{
			self.b_activated = 1;
			level.var_89ad28cd++;
			level notify("hash_9c9fb305");
			self StopLoopSound(0.2);
		}
		self playsound("zmb_ee_gramophone_activate");
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_553b8e23
	Namespace: namespace_61c0be00
	Checksum: 0xCBF24F7A
	Offset: 0x5FB8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_553b8e23()
{
	level.var_51d5c50c = 0;
	var_c911c0a2 = struct::get_array("hs_bear", "targetname");
	Array::thread_all(var_c911c0a2, &function_4b02c768);
	while(1)
	{
		level waittill("hash_c3f82290");
		if(level.var_51d5c50c == var_c911c0a2.size)
		{
			break;
		}
	}
	level thread zm_audio::sndMusicSystem_PlayState("dead_again");
	level thread audio::unlockFrontendMusic("mus_dead_again_intro");
}

/*
	Name: function_4b02c768
	Namespace: namespace_61c0be00
	Checksum: 0xD3BAD858
	Offset: 0x6090
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function function_4b02c768()
{
	e_origin = spawn("script_origin", self.origin);
	e_origin namespace_744abc1c::create_unitrigger();
	e_origin PlayLoopSound("zmb_ee_bear_lp", 1);
	/#
		e_origin thread namespace_744abc1c::function_8faf1d24(VectorScale((0, 0, 1), 255), "Dev Block strings are not supported");
	#/
	while(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
	{
		e_origin waittill("trigger_activated");
		if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || (isdefined(level.musicSystemOverride) && level.musicSystemOverride))
		{
			continue;
		}
		if(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
		{
			e_origin.b_activated = 1;
			level.var_51d5c50c++;
			level notify("hash_c3f82290");
			e_origin StopLoopSound(0.2);
		}
		e_origin playsound("zmb_ee_bear_activate");
	}
	zm_unitrigger::unregister_unitrigger(e_origin.s_unitrigger);
}

/*
	Name: spare_change
	Namespace: namespace_61c0be00
	Checksum: 0xFE7F2D97
	Offset: 0x6258
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function spare_change()
{
	a_triggers = GetEntArray("audio_bump_trigger", "targetname");
	foreach(t_audio_bump in a_triggers)
	{
		if(t_audio_bump.script_sound === "zmb_perks_bump_bottle")
		{
			t_audio_bump thread check_for_change();
		}
	}
}

/*
	Name: check_for_change
	Namespace: namespace_61c0be00
	Checksum: 0x7E6CF6A0
	Offset: 0x6338
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function check_for_change()
{
	while(1)
	{
		self waittill("trigger", e_player);
		if(e_player GetStance() == "prone")
		{
			e_player zm_score::add_to_player_score(100);
			zm_utility::play_sound_at_pos("purchase", e_player.origin);
			break;
		}
		wait(0.15);
	}
}

/*
	Name: function_d6026710
	Namespace: namespace_61c0be00
	Checksum: 0x7DD7519A
	Offset: 0x63E0
	Size: 0x3BB
	Parameters: 0
	Flags: None
*/
function function_d6026710()
{
	/#
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_3d627178);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_f0dc1bf3);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 0, &function_3388f3a3);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_3388f3a3);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 2, &function_3388f3a3);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_239f31ac);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_8f84cfff);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_e6679107);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_71626c1a);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_c8b68402);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_14004ce0);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_5b000c75);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_4e8ebeb2);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_d40e8eab);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_ce8b131c);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_71bd024b);
		level thread namespace_744abc1c::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_ad9da95f);
	#/
}

/*
	Name: function_f0dc1bf3
	Namespace: namespace_61c0be00
	Checksum: 0xB21BB1DB
	Offset: 0x67A8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_f0dc1bf3(n_val)
{
	/#
		level flag::set("Dev Block strings are not supported");
	#/
}

/*
	Name: function_3d627178
	Namespace: namespace_61c0be00
	Checksum: 0xC1D2CE0F
	Offset: 0x67E0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_3d627178(n_val)
{
	/#
		function_90b13c3d();
	#/
}

/*
	Name: function_ce8b131c
	Namespace: namespace_61c0be00
	Checksum: 0xE52DE3C4
	Offset: 0x6810
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function function_ce8b131c(n_val)
{
	/#
		zm_spawner::register_zombie_death_event_callback(&function_8d95ec46);
		players = level.activePlayers;
		foreach(player in players)
		{
			player thread function_45b9eba4();
		}
	#/
}

/*
	Name: function_3388f3a3
	Namespace: namespace_61c0be00
	Checksum: 0x352C00E0
	Offset: 0x68E8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_3388f3a3(n_val)
{
	/#
		function_79e1bd74(n_val);
	#/
}

/*
	Name: function_14004ce0
	Namespace: namespace_61c0be00
	Checksum: 0x154CF854
	Offset: 0x6918
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_14004ce0(n_val)
{
	/#
		function_779bfe1e();
	#/
}

/*
	Name: function_5b000c75
	Namespace: namespace_61c0be00
	Checksum: 0xE7B76203
	Offset: 0x6948
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_5b000c75(n_val)
{
	/#
		function_421bb7db();
	#/
}

/*
	Name: function_ad9da95f
	Namespace: namespace_61c0be00
	Checksum: 0x92D0E1DE
	Offset: 0x6978
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_ad9da95f(n_val)
{
	/#
		zm_zonemgr::enable_zone("Dev Block strings are not supported");
	#/
}

/*
	Name: function_4e8ebeb2
	Namespace: namespace_61c0be00
	Checksum: 0x6A12EBDD
	Offset: 0x69B0
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function function_4e8ebeb2(n_val)
{
	/#
		players = level.activePlayers;
		foreach(player in players)
		{
			level thread function_27b3a99c(player);
		}
	#/
}

/*
	Name: function_d40e8eab
	Namespace: namespace_61c0be00
	Checksum: 0x249B36F8
	Offset: 0x6A68
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function function_d40e8eab(n_val)
{
	/#
		players = level.activePlayers;
		foreach(player in players)
		{
			level thread function_c7bb86e5(player);
		}
	#/
}

/*
	Name: function_71bd024b
	Namespace: namespace_61c0be00
	Checksum: 0x2F8A9BBA
	Offset: 0x6B20
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_71bd024b(n_val)
{
	/#
		level thread function_7c237ecb(1);
	#/
}

/*
	Name: function_239f31ac
	Namespace: namespace_61c0be00
	Checksum: 0xABDEC8A7
	Offset: 0x6B58
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_239f31ac(n_val)
{
	/#
		level flag::set("Dev Block strings are not supported");
	#/
}

/*
	Name: function_8f84cfff
	Namespace: namespace_61c0be00
	Checksum: 0x9241B1AE
	Offset: 0x6B90
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_8f84cfff(n_val)
{
	/#
		function_aa7c5ce2();
	#/
}

/*
	Name: function_e6679107
	Namespace: namespace_61c0be00
	Checksum: 0xE3690858
	Offset: 0x6BC0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_e6679107(n_val)
{
	/#
		function_4db73fa1();
	#/
}

/*
	Name: function_71626c1a
	Namespace: namespace_61c0be00
	Checksum: 0xC2A0917F
	Offset: 0x6BF0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_71626c1a(n_val)
{
	/#
		function_ec1f5e9(level.var_9f94326b, 1);
	#/
}

/*
	Name: function_c8b68402
	Namespace: namespace_61c0be00
	Checksum: 0xC689DB41
	Offset: 0x6C28
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_c8b68402(n_val)
{
	/#
		function_ec1f5e9(level.var_9f94326b, 9);
	#/
}

