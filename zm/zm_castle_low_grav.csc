#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

#namespace namespace_8e89abe3;

/*
	Name: main
	Namespace: namespace_8e89abe3
	Checksum: 0x7987337
	Offset: 0x330
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function main()
{
	register_clientfields();
	level.var_51541120 = [];
	level._effect["low_grav_player_jump"] = "dlc1/castle/fx_plyr_115_liquid_trail";
	level._effect["low_grav_screen_fx"] = "dlc1/castle/fx_plyr_screen_115_liquid";
	level._effect["wall_dust"] = "dlc1/castle/fx_zombie_spawn_wallrun_castle";
	level thread function_554db684();
}

/*
	Name: register_clientfields
	Namespace: namespace_8e89abe3
	Checksum: 0xDECA780D
	Offset: 0x3C0
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "low_grav_powerup_triggered", 5000, 1, "counter", &function_69e96b4d, 0, 0);
	clientfield::register("scriptmover", "zombie_wall_dust", 5000, 1, "counter", &function_c9ee5588, 0, 0);
	clientfield::register("toplayer", "player_postfx", 5000, 1, "int", &function_df81c23d, 0, 0);
	clientfield::register("toplayer", "player_screen_fx", 5000, 1, "int", &function_e6fd161a, 0, 1);
	clientfield::register("scriptmover", "undercroft_emissives", 5000, 1, "int", &function_9a8a19ab, 0, 0);
	clientfield::register("scriptmover", "undercroft_wall_panel_shutdown", 5000, 1, "counter", &function_a3279a5, 0, 0);
	clientfield::register("scriptmover", "floor_panel_emissives_glow", 5000, 1, "int", &function_23861dfe, 0, 0);
}

/*
	Name: function_554db684
	Namespace: namespace_8e89abe3
	Checksum: 0x1D968C68
	Offset: 0x5C8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_554db684()
{
	SetDvar("wallrun_enabled", 1);
	SetDvar("doublejump_enabled", 1);
	SetDvar("playerEnergy_enabled", 1);
	SetDvar("bg_lowGravity", 300);
	SetDvar("wallRun_maxTimeMs_zm", 10000);
	SetDvar("playerEnergy_maxReserve_zm", 200);
	SetDvar("wallRun_peakTest_zm", 0);
}

/*
	Name: function_69e96b4d
	Namespace: namespace_8e89abe3
	Checksum: 0xCBABF263
	Offset: 0x6B0
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_69e96b4d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playsound(0, "zmb_cha_ching", self.origin);
}

/*
	Name: function_c9ee5588
	Namespace: namespace_8e89abe3
	Checksum: 0xA74DD69C
	Offset: 0x720
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_c9ee5588(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, level._effect["wall_dust"], self.origin);
}

/*
	Name: function_e6fd161a
	Namespace: namespace_8e89abe3
	Checksum: 0x411C80D6
	Offset: 0x798
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_e6fd161a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(isdefined(level.var_51541120[localClientNum]))
		{
			deletefx(localClientNum, level.var_51541120[localClientNum], 1);
		}
		level.var_51541120[localClientNum] = PlayFXOnCamera(localClientNum, level._effect["low_grav_screen_fx"]);
	}
	else if(isdefined(level.var_51541120[localClientNum]))
	{
		deletefx(localClientNum, level.var_51541120[localClientNum], 1);
	}
}

/*
	Name: function_df81c23d
	Namespace: namespace_8e89abe3
	Checksum: 0xEE657748
	Offset: 0x8A0
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_df81c23d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		function_4c5bfec4(localClientNum, 2);
		self thread postfx::playPostfxBundle("pstfx_115_castle_loop");
	}
	else
	{
		function_4c5bfec4(localClientNum, 1);
		self thread postfx::exitPostfxBundle();
	}
}

/*
	Name: function_9a8a19ab
	Namespace: namespace_8e89abe3
	Checksum: 0xC106EC90
	Offset: 0x968
	Size: 0x277
	Parameters: 7
	Flags: None
*/
function function_9a8a19ab(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("hash_67a9e087");
	self endon("hash_67a9e087");
	if(newVal == 1)
	{
		n_start_time = GetTime();
		n_end_time = n_start_time + 1 * 1000;
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = GetTime();
			if(n_time >= n_end_time)
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_end_time);
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
		break;
	}
	n_start_time = GetTime();
	n_end_time = n_start_time + 2 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_a3279a5
	Namespace: namespace_8e89abe3
	Checksum: 0x1B95A9C8
	Offset: 0xBE8
	Size: 0x187
	Parameters: 7
	Flags: None
*/
function function_a3279a5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("hash_67a9e087");
	self endon("hash_67a9e087");
	n_start_time = GetTime();
	n_end_time = n_start_time + 1 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_23861dfe
	Namespace: namespace_8e89abe3
	Checksum: 0x95EFA40
	Offset: 0xD78
	Size: 0x287
	Parameters: 7
	Flags: None
*/
function function_23861dfe(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("hash_67a9e087");
	self endon("hash_67a9e087");
	if(newVal == 1)
	{
		n_start_time = GetTime();
		n_end_time = n_start_time + 1 * 1000;
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = GetTime();
			if(n_time >= n_end_time)
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0.3, 1, n_end_time);
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0.3, 1, n_time);
			}
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
		break;
	}
	n_start_time = GetTime();
	n_end_time = n_start_time + 2 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0.3, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0.3, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_a81107fc
	Namespace: namespace_8e89abe3
	Checksum: 0x8B05507F
	Offset: 0x1008
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_a81107fc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(newVal)
	{
		fxObj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
		fxObj thread function_10dcbf51(localClientNum, fxObj);
	}
}

/*
	Name: function_10dcbf51
	Namespace: namespace_8e89abe3
	Checksum: 0x76AC8A47
	Offset: 0x10B8
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private function_10dcbf51(localClientNum, fxObj)
{
	fxObj playsound(localClientNum, "evt_ai_explode");
	wait(1);
	fxObj delete();
}

