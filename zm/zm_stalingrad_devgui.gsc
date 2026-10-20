#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_dragon;
#using scripts\zm\zm_stalingrad_dragon_strike;
#using scripts\zm\zm_stalingrad_drop_pods;
#using scripts\zm\zm_stalingrad_ee_main;
#using scripts\zm\zm_stalingrad_finger_trap;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_util;

#namespace namespace_bde177cb;

/*
	Name: function_91912a79
	Namespace: namespace_bde177cb
	Checksum: 0xA3B3488F
	Offset: 0x338
	Size: 0x433
	Parameters: 0
	Flags: None
*/
function function_91912a79()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_17d8768b);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level thread function_867cb8b1();
		}
	#/
}

/*
	Name: function_867cb8b1
	Namespace: namespace_bde177cb
	Checksum: 0xB8C147CA
	Offset: 0x778
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function function_867cb8b1()
{
	/#
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_17d8768b
	Namespace: namespace_bde177cb
	Checksum: 0xE0E6B68
	Offset: 0x910
	Size: 0x7AD
	Parameters: 1
	Flags: None
*/
function function_17d8768b(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level thread function_2b22d1f9();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_a7e8b47b();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_31f1d173(0);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_31f1d173(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_31f1d173(2);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_31f1d173(3);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_cc40b263();
				return 1;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				level.var_8cc024f2 = level.var_583e4a97.var_5d8406ed[cmd];
				level thread zm_stalingrad_drop_pod::function_d1a91c4f(level.var_8cc024f2);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::dragon_hazard_start();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_e7982921();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_cfe0d523();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_5f0cb06e();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_84bd37c8();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::dragon_hazard_library();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_7977857();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_b8de630a();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_941c2339();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_ef4a09c3();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_c09859f();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_372d0868();
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_21b70393();
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_482eea0f(1);
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_482eea0f(2);
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_482eea0f(3);
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread dragon::function_482eea0f(4);
				break;
			}
			case "Dev Block strings are not supported":
			{
				level notify("hash_2b2c1420");
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_4b210fe6();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_4b210fe6("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_4b210fe6("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_4b210fe6("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_a5a0adb4();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_bf490b3c();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_1b0d61c5();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_fd68eee0();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread zm_stalingrad_finger_trap::function_ddb9991b();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread zm_stalingrad_finger_trap::function_fc99caf5();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				util::wait_network_frame();
				level notify("hash_68bf9f79");
				util::wait_network_frame();
				level notify("hash_b227a45b");
				util::wait_network_frame();
				level notify("hash_9b46a273");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level notify("hash_b7bed0ed");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_c072d3dc();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_4be43f4d();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_354ff582();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_f0aaa402();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				zombie_takeoff_power_off();
				return 1;
			}
			case default:
			{
				return 0;
			}
		}
	#/
}

/*
	Name: function_2b22d1f9
	Namespace: namespace_bde177cb
	Checksum: 0x39A2B7B6
	Offset: 0x10C8
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function function_2b22d1f9()
{
	/#
		level flag::set("Dev Block strings are not supported");
		s_pavlov_player = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
		var_9544a498 = 0;
		foreach(player in level.activePlayers)
		{
			player SetOrigin(s_pavlov_player[var_9544a498].origin);
			player SetPlayerAngles(s_pavlov_player[var_9544a498].angles);
		}
		level flag::set("Dev Block strings are not supported");
	#/
}

/*
	Name: function_cc40b263
	Namespace: namespace_bde177cb
	Checksum: 0xCF7324AB
	Offset: 0x1210
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_cc40b263()
{
	/#
		if(isdefined(level.var_8cc024f2))
		{
			IPrintLnBold("Dev Block strings are not supported");
			return 0;
		}
		level zm_stalingrad_pap::function_809fbbff();
	#/
}

/*
	Name: function_a7e8b47b
	Namespace: namespace_bde177cb
	Checksum: 0x794C1EE5
	Offset: 0x1260
	Size: 0x7D9
	Parameters: 0
	Flags: None
*/
function function_a7e8b47b()
{
	/#
		var_1a0a3da9 = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		var_ff1b68c0 = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
		a_e_collision = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		a_e_gates = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		a_e_hatches = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		var_6f3f4356 = GetNodeArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(level.var_de98e3ce.gates_open)
		{
			level.var_de98e3ce.gates_open = 0;
			foreach(e_collision in a_e_collision)
			{
				e_collision MoveZ(600, 0.1);
				e_collision disconnectpaths();
			}
			foreach(e_gate in a_e_gates)
			{
				e_gate MoveZ(600, 0.25);
			}
			foreach(e_door in var_1a0a3da9)
			{
				e_door MoveX(114, 1);
				e_door disconnectpaths();
			}
			foreach(e_hatch in a_e_hatches)
			{
				e_hatch RotateRoll(-90, 1);
			}
			foreach(nd_traverse in var_6f3f4356)
			{
				UnlinkTraversal(nd_traverse);
			}
			var_ff1b68c0 MoveY(-84, 1);
			level thread scene::Play("Dev Block strings are not supported");
		}
		else
		{
			level.var_de98e3ce.gates_open = 1;
			foreach(e_collision in a_e_collision)
			{
				e_collision connectpaths();
				e_collision MoveZ(-600, 0.1);
			}
			foreach(e_gate in a_e_gates)
			{
				e_gate MoveZ(-600, 0.25);
			}
			foreach(e_door in var_1a0a3da9)
			{
				e_door MoveX(-114, 1);
				e_door connectpaths();
			}
			foreach(e_hatch in a_e_hatches)
			{
				e_hatch RotateRoll(90, 1);
			}
			foreach(nd_traverse in var_6f3f4356)
			{
				LinkTraversal(nd_traverse);
			}
			var_ff1b68c0 MoveY(84, 1);
			var_21ce8765 = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
			var_21ce8765 thread scene::Play("Dev Block strings are not supported");
		}
		return 1;
	#/
}

/*
	Name: function_31f1d173
	Namespace: namespace_bde177cb
	Checksum: 0xC241E14C
	Offset: 0x1A48
	Size: 0x233
	Parameters: 1
	Flags: None
*/
function function_31f1d173(n_direction)
{
	/#
		level notify("hash_31f1d173");
		wait(1);
		switch(n_direction)
		{
			case 0:
			{
				var_e0320b0b = 1;
				var_6e2a9bd0 = 2;
				n_exploder = 1;
				break;
			}
			case 1:
			{
				var_e0320b0b = 0;
				var_6e2a9bd0 = 2;
				n_exploder = 2;
				break;
			}
			case 2:
			{
				var_e0320b0b = 0;
				var_6e2a9bd0 = 1;
				n_exploder = 3;
				break;
			}
			case 3:
			{
				var_e0320b0b = 0;
				var_6e2a9bd0 = 1;
				var_942d1639 = 2;
				n_exploder = 4;
				break;
			}
		}
		level thread zm_stalingrad_pap::function_187a933f(var_e0320b0b);
		level thread zm_stalingrad_pap::function_187a933f(var_6e2a9bd0);
		if(isdefined(var_942d1639))
		{
			level thread zm_stalingrad_pap::function_187a933f(var_942d1639);
		}
		exploder::exploder("Dev Block strings are not supported");
		exploder::exploder("Dev Block strings are not supported" + n_exploder);
		level util::waittill_any_timeout(20, "Dev Block strings are not supported");
		level thread zm_stalingrad_pap::function_a71517e1(var_e0320b0b);
		level thread zm_stalingrad_pap::function_a71517e1(var_6e2a9bd0);
		if(isdefined(var_942d1639))
		{
			level thread zm_stalingrad_pap::function_a71517e1(var_942d1639);
		}
		exploder::kill_exploder("Dev Block strings are not supported" + n_exploder);
		exploder::kill_exploder("Dev Block strings are not supported");
	#/
}

/*
	Name: function_4b210fe6
	Namespace: namespace_bde177cb
	Checksum: 0xBA4A5A60
	Offset: 0x1C88
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function function_4b210fe6(var_b87a2184)
{
	/#
		dragon::dragon_boss_stop();
		dragon::dragon_boss_cleanup();
		level flag::set("Dev Block strings are not supported");
		level namespace_48c05c81::function_3804dbf1();
		namespace_48c05c81::function_adf4d1d0();
		if(isdefined(level.var_ef9c43d7))
		{
			if(isdefined(level.var_ef9c43d7.var_fa4643fb))
			{
				level.var_ef9c43d7.var_fa4643fb delete();
			}
			level.var_ef9c43d7 delete();
			level.var_ef9c43d7 = undefined;
		}
		level zm_zonemgr::enable_zone("Dev Block strings are not supported");
		if(isdefined(var_b87a2184))
		{
			level flag::init("Dev Block strings are not supported");
			level flag::init(var_b87a2184, 1);
		}
	#/
}

/*
	Name: function_a5a0adb4
	Namespace: namespace_bde177cb
	Checksum: 0x63B0C4F2
	Offset: 0x1DD8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_a5a0adb4()
{
	/#
		if(level flag::get("Dev Block strings are not supported"))
		{
			level zm_ai_raps::special_raps_spawn(6);
		}
		else
		{
			IPrintLnBold("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_bf490b3c
	Namespace: namespace_bde177cb
	Checksum: 0x1EF3FC2C
	Offset: 0x1E40
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_bf490b3c()
{
	/#
		level endon("_zombie_game_over");
		level flag::wait_till("Dev Block strings are not supported");
		while(!isdefined(level.var_cf6e9729))
		{
			wait(0.05);
		}
		level.var_cf6e9729.var_65850094[1] = 1;
		level.var_cf6e9729.var_65850094[2] = 1;
		level.var_cf6e9729.var_65850094[3] = 1;
		level.var_cf6e9729.var_65850094[4] = 1;
		level.var_cf6e9729.var_65850094[5] = 1;
		level.var_cf6e9729.var_dad3d9bd = 9999999;
	#/
}

/*
	Name: function_1b0d61c5
	Namespace: namespace_bde177cb
	Checksum: 0xF200CBC8
	Offset: 0x1F30
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function function_1b0d61c5()
{
	/#
		level flag::clear("Dev Block strings are not supported");
		foreach(e_player in level.players)
		{
			e_player stalingrad_dragon_strike::function_8258d71c();
		}
	#/
}

/*
	Name: function_fd68eee0
	Namespace: namespace_bde177cb
	Checksum: 0x3CBDE1E7
	Offset: 0x1FE8
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function function_fd68eee0()
{
	/#
		level flag::set("Dev Block strings are not supported");
		foreach(e_player in level.players)
		{
			e_player stalingrad_dragon_strike::function_8258d71c();
		}
	#/
}

/*
	Name: function_c072d3dc
	Namespace: namespace_bde177cb
	Checksum: 0xCE313653
	Offset: 0x20A0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_c072d3dc()
{
	/#
		LUINotifyEvent(&"Dev Block strings are not supported", 1, 1);
	#/
}

/*
	Name: function_4be43f4d
	Namespace: namespace_bde177cb
	Checksum: 0x9F30D1CD
	Offset: 0x20D8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_4be43f4d()
{
	/#
		LUINotifyEvent(&"Dev Block strings are not supported", 1, 0);
	#/
}

/*
	Name: function_354ff582
	Namespace: namespace_bde177cb
	Checksum: 0xACB0A3F5
	Offset: 0x2108
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_354ff582()
{
	/#
		level clientfield::set("Dev Block strings are not supported", Int(level.time - level.n_gameplay_start_time + 500 / 1000));
		level clientfield::set("Dev Block strings are not supported", level.round_number);
	#/
}

/*
	Name: function_f0aaa402
	Namespace: namespace_bde177cb
	Checksum: 0xCBAAFD63
	Offset: 0x2190
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_f0aaa402()
{
	/#
		level clientfield::set("Dev Block strings are not supported", Int(level.time - level.n_gameplay_start_time + 500 / 1000));
	#/
}

/*
	Name: zombie_takeoff_power_off
	Namespace: namespace_bde177cb
	Checksum: 0x27E7B5A8
	Offset: 0x21F0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function zombie_takeoff_power_off()
{
	/#
		level clientfield::set("Dev Block strings are not supported", Int(level.time - level.n_gameplay_start_time + 500 / 1000));
	#/
}

