#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_undercroft_low_grav;

/*
	Name: main
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x55165D48
	Offset: 0x3D0
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
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x9BD418CB
	Offset: 0x460
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "low_grav_powerup_triggered", 15000, 1, "counter", &function_69e96b4d, 0, 0);
	clientfield::register("toplayer", "player_postfx", 15000, 1, "int", &function_df81c23d, 0, 0);
	clientfield::register("toplayer", "player_screen_fx", 15000, 1, "int", &player_screen_fx, 0, 1);
	clientfield::register("scriptmover", "undercroft_emissives", 15000, 1, "int", &function_9a8a19ab, 0, 0);
	clientfield::register("scriptmover", "undercroft_wall_panel_shutdown", 15000, 1, "counter", &mm_katana_male_runjump_land_1f_l, 0, 0);
	clientfield::register("scriptmover", "floor_panel_emissives_glow", 15000, 1, "int", &function_23861dfe, 0, 0);
	clientfield::register("world", "snd_low_gravity_state", 15000, 2, "int", &snd_low_gravity_state, 0, 0);
}

/*
	Name: function_554db684
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xC34B220A
	Offset: 0x668
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
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA940C708
	Offset: 0x750
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_69e96b4d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playsound(0, "zmb_cha_ching", self.origin);
}

/*
	Name: wall_dust
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x382BDABA
	Offset: 0x7C0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function wall_dust(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, level._effect["wall_dust"], self.origin);
}

/*
	Name: player_screen_fx
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA4D3AC17
	Offset: 0x838
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function player_screen_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x98A634B3
	Offset: 0x940
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_df81c23d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		setpbgactivebank(localClientNum, 2);
		self thread postfx::playPostfxBundle("pstfx_115_castle_loop");
	}
	else
	{
		setpbgactivebank(localClientNum, 1);
		self thread postfx::exitPostfxBundle();
	}
}

/*
	Name: function_9a8a19ab
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x4676C72C
	Offset: 0xA08
	Size: 0x277
	Parameters: 7
	Flags: None
*/
function function_9a8a19ab(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("fade_interrupt");
	self endon("fade_interrupt");
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
	Name: mm_katana_male_runjump_land_1f_l
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x9D69E366
	Offset: 0xC88
	Size: 0x187
	Parameters: 7
	Flags: None
*/
function mm_katana_male_runjump_land_1f_l(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("fade_interrupt");
	self endon("fade_interrupt");
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
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xEEC7C234
	Offset: 0xE18
	Size: 0x287
	Parameters: 7
	Flags: None
*/
function function_23861dfe(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self notify("fade_interrupt");
	self endon("fade_interrupt");
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
	Name: zombie_instakill_fx_cb
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x883DCEA7
	Offset: 0x10A8
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function zombie_instakill_fx_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(newVal)
	{
		var_e6ddb5de = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
		var_e6ddb5de thread playesoundanddelete(localClientNum, var_e6ddb5de);
	}
}

/*
	Name: playesoundanddelete
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x8A9829E4
	Offset: 0x1158
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private playesoundanddelete(localClientNum, var_e6ddb5de)
{
	var_e6ddb5de playsound(localClientNum, "evt_ai_explode");
	wait(1);
	var_e6ddb5de delete();
}

/*
	Name: snd_low_gravity_state
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x80D3479
	Offset: 0x11B8
	Size: 0x14B
	Parameters: 7
	Flags: None
*/
function snd_low_gravity_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		audio::playloopat("zmb_low_grav_room_loop", (-44, -6680, -1228));
		audio::playloopat("zmb_low_grav_machine_loop", (-44, -6680, -1228));
		playsound(0, "zmb_low_grav_machine_start", (-44, -6680, -1228));
	}
	if(newVal == 2)
	{
		audio::stoploopat("zmb_low_grav_machine_loop", (-44, -6680, -1228));
		playsound(0, "zmb_low_grav_machine_stop", (-44, -6680, -1228));
	}
	else
	{
		audio::stoploopat("zmb_low_grav_room_loop", (-44, -6680, -1228));
	}
}

