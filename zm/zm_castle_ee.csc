#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;

#namespace zm_castle_ee;

/*
	Name: main
	Namespace: zm_castle_ee
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
	Namespace: zm_castle_ee
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
	clientfield::register("actor", "ghost_actor", 1, 1, "int", &ghost_actor, 0, 0);
	clientfield::register("scriptmover", "channeling_stone_glow", 5000, 2, "int", &channeling_stone_glow, 0, 0);
	clientfield::register("world", "flip_skybox", 5000, 1, "int", &flip_skybox, 0, 0);
	clientfield::register("scriptmover", "pod_monitor_enable", 5000, 1, "int", &pod_monitor_disable, 0, 0);
	clientfield::register("world", "sndDeathRayToMoon", 5000, 1, "int", &snddeathraytomoon, 0, 0);
	clientfield::register("toplayer", "outro_lighting_banks", 5000, 1, "int", &outro_lighting_banks, 0, 0);
	clientfield::register("toplayer", "moon_explosion_bank", 5000, 1, "int", &moon_explosion_bank, 0, 0);
}

/*
	Name: ghost_actor
	Namespace: zm_castle_ee
	Checksum: 0xFF6CA0C8
	Offset: 0x638
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function ghost_actor(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self duplicate_render::set_dr_flag("zod_ghost", newVal);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: function_2a1f20f9
	Namespace: zm_castle_ee
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
	Name: channeling_stone_glow
	Namespace: zm_castle_ee
	Checksum: 0xDCF41DCB
	Offset: 0x870
	Size: 0x23B
	Parameters: 7
	Flags: None
*/
function channeling_stone_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Name: pod_monitor_disable
	Namespace: zm_castle_ee
	Checksum: 0x3386FE12
	Offset: 0xAB8
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function pod_monitor_disable(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, newVal, 0);
}

/*
	Name: flip_skybox
	Namespace: zm_castle_ee
	Checksum: 0xAD443D69
	Offset: 0xB28
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function flip_skybox(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		SetDvar("r_skyTransition", 1);
	}
}

/*
	Name: snddeathraytomoon
	Namespace: zm_castle_ee
	Checksum: 0x72FDFAD2
	Offset: 0xB98
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function snddeathraytomoon(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Name: outro_lighting_banks
	Namespace: zm_castle_ee
	Checksum: 0x9518B936
	Offset: 0xCA0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function outro_lighting_banks(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		setpbgactivebank(localClientNum, 2);
		setexposureactivebank(localClientNum, 2);
	}
	else
	{
		setpbgactivebank(localClientNum, 1);
		setexposureactivebank(localClientNum, 1);
	}
}

/*
	Name: moon_explosion_bank
	Namespace: zm_castle_ee
	Checksum: 0xDA5E6685
	Offset: 0xD60
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function moon_explosion_bank(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		setexposureactivebank(localClientNum, 4);
	}
	else
	{
		setexposureactivebank(localClientNum, 1);
	}
}

