#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;

#namespace namespace_c93e4c32;

/*
	Name: main
	Namespace: namespace_c93e4c32
	Checksum: 0x865B57D3
	Offset: 0x340
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function main()
{
	register_clientfields();
	duplicate_render::set_dr_filter_framebuffer("zod_ghost", 90, "zod_ghost", undefined, 0, "mc/hud_zod_ghost", 0);
	level._effect["plunger_charge_1p"] = "dlc1/zmb_weapon/fx_ee_plunger_trail_1p";
	level._effect["plunger_charge_3p"] = "dlc1/zmb_weapon/fx_ee_plunger_trail_3p";
}

/*
	Name: register_clientfields
	Namespace: namespace_c93e4c32
	Checksum: 0x12D87735
	Offset: 0x3C8
	Size: 0x263
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("toplayer", "player_ee_cs_circle", 5000, n_bits, "int", &function_2a1f20f9, 0, 0);
	clientfield::register("actor", "ghost_actor", 1, 1, "int", &function_b48f294, 0, 0);
	clientfield::register("scriptmover", "channeling_stone_glow", 5000, 2, "int", &function_e23bc630, 0, 0);
	clientfield::register("world", "flip_skybox", 5000, 1, "int", &function_3965d72d, 0, 0);
	clientfield::register("scriptmover", "pod_monitor_enable", 5000, 1, "int", &function_3c1114e8, 0, 0);
	clientfield::register("world", "sndDeathRayToMoon", 5000, 1, "int", &function_2145e814, 0, 0);
	clientfield::register("toplayer", "outro_lighting_banks", 5000, 1, "int", &function_12c888d5, 0, 0);
	clientfield::register("toplayer", "moon_explosion_bank", 5000, 1, "int", &function_890770df, 0, 0);
}

/*
	Name: function_b48f294
	Namespace: namespace_c93e4c32
	Checksum: 0xFF6CA0C8
	Offset: 0x638
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_b48f294(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self duplicate_render::set_dr_flag("zod_ghost", newVal);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: function_2a1f20f9
	Namespace: namespace_c93e4c32
	Checksum: 0x3C4C1426
	Offset: 0x6B8
	Size: 0x1AB
	Parameters: 7
	Flags: None
*/
function function_2a1f20f9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread postfx::playPostfxBundle("pstfx_arrow_demongate");
		playsound(0, "zmb_ee_resurrect_enter_circle", (0, 0, 0));
	}
	else if(newVal == 2)
	{
		self thread postfx::playPostfxBundle("pstfx_arrow_rune");
		playsound(0, "zmb_ee_resurrect_enter_circle", (0, 0, 0));
	}
	else if(newVal == 3)
	{
		self thread postfx::playPostfxBundle("pstfx_arrow_elemental");
		playsound(0, "zmb_ee_resurrect_enter_circle", (0, 0, 0));
	}
	else if(newVal == 4)
	{
		self thread postfx::playPostfxBundle("pstfx_arrow_wolf");
		playsound(0, "zmb_ee_resurrect_enter_circle", (0, 0, 0));
	}
	else
	{
		self thread postfx::StopPostfxBundle();
		playsound(0, "zmb_ee_resurrect_leave_circle", (0, 0, 0));
	}
}

/*
	Name: function_e23bc630
	Namespace: namespace_c93e4c32
	Checksum: 0xDCF41DCB
	Offset: 0x870
	Size: 0x23B
	Parameters: 7
	Flags: None
*/
function function_e23bc630(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("hash_a1e4f5f1");
	self endon("hash_a1e4f5f1");
	if(newVal == 1)
	{
		n_start_time = GetTime();
		var_b1382f05 = n_start_time + 0.85 * 1000;
		var_c8a6e70a = 0;
		var_2be3abbd = 1;
		n_shader_value = 0;
		while(1)
		{
			n_time = GetTime();
			if(n_time >= var_b1382f05)
			{
				n_start_time = GetTime();
				var_b1382f05 = n_start_time + 0.85 * 1000;
				var_c8a6e70a = n_shader_value;
				if(var_2be3abbd == 1)
				{
				}
				else
				{
				}
				var_2be3abbd = 1;
			}
			n_shader_value = mapfloat(n_start_time, var_b1382f05, var_c8a6e70a, var_2be3abbd, n_time);
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
	else if(newVal == 2)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, 0);
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0);
	}
}

/*
	Name: function_3c1114e8
	Namespace: namespace_c93e4c32
	Checksum: 0x3386FE12
	Offset: 0xAB8
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_3c1114e8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, newVal, 0);
}

/*
	Name: function_3965d72d
	Namespace: namespace_c93e4c32
	Checksum: 0xAD443D69
	Offset: 0xB28
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_3965d72d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		SetDvar("r_skyTransition", 1);
	}
}

/*
	Name: function_2145e814
	Namespace: namespace_c93e4c32
	Checksum: 0x72FDFAD2
	Offset: 0xB98
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_2145e814(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playsound(0, "zmb_ee_rocketcrash_ray_start", (-271, 2196, 1338));
		wait(0.05);
		playsound(0, "zmb_ee_rocketcrash_ray_start", (552, 2201, 1344));
	}
	else
	{
		playsound(0, "zmb_ee_rocketcrash_ray_end", (-271, 2196, 1348));
		wait(0.05);
		playsound(0, "zmb_ee_rocketcrash_ray_end", (552, 2201, 1344));
	}
}

/*
	Name: function_12c888d5
	Namespace: namespace_c93e4c32
	Checksum: 0x9518B936
	Offset: 0xCA0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_12c888d5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		function_4c5bfec4(localClientNum, 2);
		function_2f183a94(localClientNum, 2);
	}
	else
	{
		function_4c5bfec4(localClientNum, 1);
		function_2f183a94(localClientNum, 1);
	}
}

/*
	Name: function_890770df
	Namespace: namespace_c93e4c32
	Checksum: 0xDA5E6685
	Offset: 0xD60
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_890770df(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		function_2f183a94(localClientNum, 4);
	}
	else
	{
		function_2f183a94(localClientNum, 1);
	}
}

