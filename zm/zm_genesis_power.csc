#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_power;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_power
	Checksum: 0x63B9D68C
	Offset: 0x4F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_power", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_power
	Checksum: 0xE1133CC0
	Offset: 0x530
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "power_zombie_soul", 15000, 1, "int", &function_cb47574e, 0, 0);
	clientfield::register("scriptmover", "power_cables_shader", 15000, 1, "int", &power_cables_shader, 0, 0);
	for(i = 1; i <= 4; i++)
	{
		str_name = "corruption_tower" + i;
		clientfield::register("world", str_name, 15000, 7, "float", &corruption_tower, 0, 0);
	}
}

/*
	Name: function_cb47574e
	Namespace: zm_genesis_power
	Checksum: 0x45D99C80
	Offset: 0x650
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_cb47574e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["corruption_engine_soul"], self, "tag_origin");
		self playsound(0, "zmb_ee_soul_start");
		self.sndlooper = self PlayLoopSound("zmb_ee_soul_lp");
	}
}

/*
	Name: power_cables_shader
	Namespace: zm_genesis_power
	Checksum: 0x34E936A2
	Offset: 0x718
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function power_cables_shader(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, 0, 0);
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: corruption_tower
	Namespace: zm_genesis_power
	Checksum: 0xD3048BF4
	Offset: 0x7C8
	Size: 0x5FB
	Parameters: 7
	Flags: None
*/
function corruption_tower(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	mdl_columns = GetEnt(n_local_client, str_field, "targetname");
	mdl_columns util::waittill_dobj(n_local_client);
	if(!isdefined(mdl_columns.a_fx))
	{
		mdl_columns.a_fx = [];
	}
	if(!mdl_columns HasAnimTree())
	{
		mdl_columns useanimtree(-1);
	}
	if(n_new <= 0)
	{
		mdl_columns tower_fx(n_local_client, 2, "tag_fx_main", "corruption_tower_active_top_ember", "tag_fx_main_ember");
	}
	else if(n_new >= 1)
	{
		mdl_columns ClearAnim("p7_fxanim_zm_gen_apoth_corpt_engine_pillar_rise_anim", 0.2);
		mdl_columns SetAnim("p7_fxanim_zm_gen_apoth_corpt_engine_pillar_rise_idle_anim", 1, 0.2);
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_btm_01", "corruption_tower_complete");
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_btm_02", "corruption_tower_complete");
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_top_01", "corruption_tower_complete");
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_top_02", "corruption_tower_complete");
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_cnt", "corruption_tower_complete");
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_main", "corruption_tower_complete_top");
		mdl_columns tower_fx(n_local_client, 3, "tag_fx_main", "corruption_tower_active_top_ember", "tag_fx_main_ember");
	}
	else
	{
		mdl_columns SetAnim("p7_fxanim_zm_gen_apoth_corpt_engine_pillar_rise_anim", n_new, 0.2);
		mdl_columns SetAnim("p7_fxanim_zm_gen_apoth_corpt_engine_pillar_reverse_anim", 1 - n_new, 0.2);
		if(n_new > n_old)
		{
			if(n_new > 0)
			{
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_main", "corruption_tower_active", "tag_fx_main_ember");
			}
			if(n_new > 0.03)
			{
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_btm_01", "corruption_tower_active");
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_btm_02", "corruption_tower_active");
			}
			if(n_new > 0.44)
			{
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_top_01", "corruption_tower_active");
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_top_02", "corruption_tower_active");
			}
			if(n_new > 0.76)
			{
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_cnt", "corruption_tower_active");
				mdl_columns tower_fx(n_local_client, 1, "tag_fx_main", "corruption_tower_active_top");
			}
		}
		else if(n_new < 0.03)
		{
			mdl_columns tower_fx(n_local_client, 2, "tag_fx_btm_01");
			mdl_columns tower_fx(n_local_client, 2, "tag_fx_btm_02");
		}
		if(n_new < 0.44)
		{
			mdl_columns tower_fx(n_local_client, 2, "tag_fx_top_01");
			mdl_columns tower_fx(n_local_client, 2, "tag_fx_top_02");
		}
		if(n_new > 0.76)
		{
			mdl_columns tower_fx(n_local_client, 2, "tag_fx_cnt");
			mdl_columns tower_fx(n_local_client, 2, "tag_fx_main");
		}
	}
}

/*
	Name: tower_fx
	Namespace: zm_genesis_power
	Checksum: 0x253433EA
	Offset: 0xDD0
	Size: 0x2E3
	Parameters: 5
	Flags: None
*/
function tower_fx(n_local_client, var_47d9b5f4, str_tag, str_fx, str_alias)
{
	if(var_47d9b5f4 == 2 || var_47d9b5f4 == 3)
	{
		if(isdefined(str_alias))
		{
			for(i = 1; i <= 4; i++)
			{
				var_3805981f = "pillar_0" + i + "_" + str_alias;
				if(isdefined(self.a_fx[var_3805981f]))
				{
					stopfx(n_local_client, self.a_fx[var_3805981f]);
					self.a_fx[var_3805981f] = undefined;
				}
			}
			break;
		}
		for(i = 1; i <= 4; i++)
		{
			var_da7eab4b = "pillar_0" + i + "_" + str_tag;
			if(isdefined(self.a_fx[var_da7eab4b]))
			{
				stopfx(n_local_client, self.a_fx[var_da7eab4b]);
				self.a_fx[var_da7eab4b] = undefined;
			}
		}
	}
	else if(var_47d9b5f4 == 1 || var_47d9b5f4 == 3)
	{
		if(isdefined(str_alias))
		{
			for(i = 1; i <= 4; i++)
			{
				var_da7eab4b = "pillar_0" + i + "_" + str_tag;
				var_3805981f = "pillar_0" + i + "_" + str_alias;
				if(!isdefined(self.a_fx[var_3805981f]))
				{
					self.a_fx[var_3805981f] = PlayFXOnTag(n_local_client, level._effect[str_fx], self, var_da7eab4b);
				}
			}
			break;
		}
		for(i = 1; i <= 4; i++)
		{
			var_da7eab4b = "pillar_0" + i + "_" + str_tag;
			if(!isdefined(self.a_fx[var_da7eab4b]))
			{
				self.a_fx[var_da7eab4b] = PlayFXOnTag(n_local_client, level._effect[str_fx], self, var_da7eab4b);
			}
		}
	}
}

