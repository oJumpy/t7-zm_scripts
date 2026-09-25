#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace namespace_8bc21961;

/*
	Name: __init__sytem__
	Namespace: namespace_8bc21961
	Checksum: 0x4D561638
	Offset: 0x500
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_sentinel_drone", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8bc21961
	Checksum: 0xE80B5843
	Offset: 0x548
	Size: 0x69D
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__()
{
	clientfield::register("world", "sentinel_round_fog", 12000, 1, "int", &function_6161cd1, 0, 0);
	clientfield::register("toplayer", "sentinel_round_fx", 12000, 1, "int", &function_9a46f975, 0, 0);
	clientfield::register("vehicle", "sentinel_spawn_fx", 12000, 1, "int", &function_11f14e16, 0, 0);
	clientfield::register("vehicle", "necro_sentinel_fx", 12000, 1, "int", &function_af7e8dd4, 0, 0);
	clientfield::register("actor", "sentinel_zombie_spawn_fx", 12000, 1, "int", &function_bc95cac0, 0, 0);
	level._effect["sentinel_round"] = "zombie/fx_meatball_round_tell_zod_zmb";
	level._effect["sentinel_spawn_in"] = "dlc3/stalingrad/fx_sentinel_drone_spawn_trail";
	level._effect["sentinel_spawn_impact"] = "dlc3/stalingrad/fx_mech_wpn_harpoon_explo";
	level._effect["sentinel_ground_radiation"] = "dlc3/stalingrad/fx_sentinel_drone_ground_elec";
	level._effect["rezzed_skeleton_eye_glow"] = "zombie/fx_glow_eye_blue_stalingrad";
	level._effect["rezzed_skeleton_sparky"] = "dlc3/stalingrad/fx_elec_sparky_chest";
	level._effect["rezzed_skeleton_spark_light"] = "dlc3/stalingrad/fx_light_sparky_chest";
	level.var_4d7b6b0 = [];
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!IsArray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = Array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_0";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!IsArray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = Array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_1";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!IsArray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = Array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_2";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!IsArray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = Array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_3";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!IsArray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = Array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_4";
	level.var_266194a = [];
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!IsArray(level.var_266194a))
	{
		level.var_266194a = Array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_0";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!IsArray(level.var_266194a))
	{
		level.var_266194a = Array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_1";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!IsArray(level.var_266194a))
	{
		level.var_266194a = Array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_2";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!IsArray(level.var_266194a))
	{
		level.var_266194a = Array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_3";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!IsArray(level.var_266194a))
	{
		level.var_266194a = Array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_4";
}

/*
	Name: __main__
	Namespace: namespace_8bc21961
	Checksum: 0x7DEF5F1D
	Offset: 0xBF0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	visionset_mgr::register_visionset_info("zm_sentinel_round_visionset", 12000, 31, undefined, "zm_sentinel_round_visionset");
}

/*
	Name: function_6161cd1
	Namespace: namespace_8bc21961
	Checksum: 0x468BA76D
	Offset: 0xC28
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_6161cd1(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		SetLitFogBank(n_local_client, -1, 1, -1);
		SetWorldFogActiveBank(n_local_client, 2);
	}
	else
	{
		SetLitFogBank(n_local_client, -1, 0, -1);
		SetWorldFogActiveBank(n_local_client, 1);
	}
}

/*
	Name: function_9a46f975
	Namespace: namespace_8bc21961
	Checksum: 0xB624283D
	Offset: 0xCF0
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_9a46f975(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon("death");
	if(n_val_new)
	{
		if(IsSpectating(n_local_client))
		{
			return;
		}
		self thread postfx::playPostfxBundle("pstfx_stalingrad_sentinel");
		self.var_8ffc609a = PlayFXOnCamera(n_local_client, level._effect["sentinel_round"]);
		wait(3.5);
		if(isdefined(self))
		{
			deletefx(n_local_client, self.var_8ffc609a);
		}
	}
}

/*
	Name: function_11f14e16
	Namespace: namespace_8bc21961
	Checksum: 0xA970AF4A
	Offset: 0xDE0
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function function_11f14e16(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		self.var_e43aab07 = PlayFXOnTag(n_local_client, level._effect["sentinel_spawn_in"], self, "tag_origin");
		SetFXIgnorePause(n_local_client, self.var_e43aab07, 1);
	}
	else if(isdefined(self.var_e43aab07))
	{
		stopfx(n_local_client, self.var_e43aab07);
	}
	PlayFXOnTag(n_local_client, level._effect["sentinel_spawn_impact"], self, "tag_origin");
	wait(1);
	if(isdefined(self))
	{
		sentinel_play_taunt(n_local_client, level.var_266194a);
	}
}

/*
	Name: function_af7e8dd4
	Namespace: namespace_8bc21961
	Checksum: 0x477474FD
	Offset: 0xF10
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_af7e8dd4(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		self.var_5ec69ff1 = PlayFXOnTag(n_local_client, level._effect["sentinel_ground_radiation"], self, "tag_origin");
		SetFXIgnorePause(n_local_client, self.var_5ec69ff1, 1);
		sentinel_play_taunt(n_local_client, level.var_4d7b6b0);
	}
	else if(isdefined(self.var_5ec69ff1))
	{
		stopfx(n_local_client, self.var_5ec69ff1);
	}
}

/*
	Name: function_bc95cac0
	Namespace: namespace_8bc21961
	Checksum: 0xFCBDA34C
	Offset: 0x1008
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_bc95cac0(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self._eyeglow_fx_override = level._effect["rezzed_skeleton_eye_glow"];
	self.var_46d9c2ee = "J_Spine4";
	self.var_7abb4217 = level._effect["rezzed_skeleton_sparky"];
	self.var_e22d3880 = level._effect["rezzed_skeleton_spark_light"];
}

/*
	Name: sentinel_play_taunt
	Namespace: namespace_8bc21961
	Checksum: 0x6F9D589A
	Offset: 0x10A8
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function sentinel_play_taunt(localClientNum, taunt_Arr)
{
	if(isdefined(level._lastplayed_drone_taunt) && GetTime() - level._lastplayed_drone_taunt < 6000)
	{
		return;
	}
	if(isdefined(level.voxAIdeactivate) && level.voxAIdeactivate)
	{
		return;
	}
	level._lastplayed_drone_taunt = GetTime();
	taunt = RandomInt(taunt_Arr.size);
	self playsound(localClientNum, taunt_Arr[taunt]);
}

