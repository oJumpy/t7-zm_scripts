#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace namespace_1f61c67f;

/*
	Name: __init__sytem__
	Namespace: namespace_1f61c67f
	Checksum: 0xE167504
	Offset: 0x1340
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1f61c67f
	Checksum: 0x1619D77B
	Offset: 0x1380
	Size: 0xDEB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.var_b3c23ec9))
	{
		level.var_b3c23ec9 = [];
	}
	level._effect["keeper_spawn"] = "zombie/fx_portal_keeper_spawn_zod_zmb";
	level._effect["keeper_glow"] = "zombie/fx_keeper_ambient_torso_zod_zmb";
	level._effect["keeper_death"] = "zombie/fx_keeper_death_zod_zmb";
	level._effect["keeper_mouth"] = "zombie/fx_keeper_glow_mouth_zod_zmb";
	level._effect["keeper_trail"] = "zombie/fx_keeper_mist_trail_zod_zmb";
	level._effect["ritual_key_glow"] = "zombie/fx_ritual_glow_key_zod_zmb";
	level._effect["relic_glow"] = "zombie/fx_ritual_glow_relic_zod_zmb";
	level._effect["memento_glow"] = "zombie/fx_ritual_glow_memento_zod_zmb";
	level._effect["fuse_glow"] = "zombie/fx_fuse_glow_blue_zod_zmb";
	level._effect["ritual_key_open_glow"] = "zombie/fx_ritual_glow_key_open_zod_zmb";
	level._effect["totem_hover"] = "zombie/fx_totem_mist_zod_zmb";
	level._effect["totem_ready"] = "zombie/fx_totem_leyline_zod_zmb";
	level._effect["totem_charging"] = "zombie/fx_totem_charging_zod_zmb";
	level._effect["totem_charged"] = "zombie/fx_totem_charged_zod_zmb";
	level._effect["totem_break"] = "zombie/fx_totem_break_zod_zmb";
	level._effect["shadowman_hover"] = "zombie/fx_shdw_glow_hover_zod_zmb";
	level._effect["shadowman_teleport"] = "zombie/fx_shdw_teleport_zod_zmb";
	level._effect["shadowman_hover_charge"] = "zombie/fx_shdw_glow_hover_charge_zod_zmb";
	level._effect["shadowman_energy_ball_charge"] = "zombie/fx_shdw_spell_charge_zod_zmb";
	level._effect["shadowman_energy_ball_explosion"] = "zombie/fx_shdw_spell_exp_zod_zmb";
	level._effect["shadowman_energy_ball"] = "zombie/fx_shdw_spell_zod_zmb";
	level._effect["shadowman_shield"] = "zombie/fx_ee_shadowman_shield_loop_zod";
	level._effect["shadowman_sword_impact_shield"] = "zombie/fx_ee_shadowman_shield_impact_zod_zmb";
	level._effect["shadowman_shield_explosion"] = "zombie/fx_ee_shadowman_shield_explo_zod_zmb";
	level._effect["shadowman_shield_regeneration"] = "zombie/fx_ee_shadowman_shield_regeneration_zod_zmb";
	level._effect["shadowman_light"] = "light/fx_light_zod_shadowman_appear";
	level._effect["shadowman_smoke"] = "zombie/fx_shdw_floating_smk_zod_zmb";
	level._effect["footprint_l"] = "player/fx_plyr_footstep_tracker_lf_zmb";
	level._effect["footprint_r"] = "player/fx_plyr_footstep_tracker_rf_zmb";
	clientfield::register("toplayer", "ZM_ZOD_UI_SUMMONING_KEY_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_RITUAL_BUSY", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("world", "quest_key", 1, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	clientfield::register("world", "ritual_progress", 1, 7, "float", &function_91f9842, 0, 0);
	clientfield::register("world", "ritual_current", 1, 3, "int", undefined, 0, 0);
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("world", "ritual_state_boxer", 1, n_bits, "int", &function_9b761da1, 0, 1);
	clientfield::register("world", "ritual_state_detective", 1, n_bits, "int", &function_7f6e0cbe, 0, 1);
	clientfield::register("world", "ritual_state_femme", 1, n_bits, "int", &function_2ae7c9d9, 0, 1);
	clientfield::register("world", "ritual_state_magician", 1, n_bits, "int", &function_77f45902, 0, 1);
	clientfield::register("world", "ritual_state_pap", 1, n_bits, "int", &function_42e9f1c0, 0, 1);
	clientfield::register("world", "keeper_spawn_portals", 1, 4, "int", &function_a17c1f53, 0, 0);
	clientfield::register("world", "keeper_subway_fx", 1, 1, "int", &function_af8eff6d, 0, 0);
	clientfield::register("scriptmover", "cursetrap_fx", 1, 1, "int", &function_a3ec6769, 0, 0);
	clientfield::register("scriptmover", "mini_cursetrap_fx", 1, 1, "int", &function_33a0658b, 0, 0);
	clientfield::register("scriptmover", "curse_tell_fx", 1, 1, "int", &function_3f11ade6, 0, 0);
	clientfield::register("scriptmover", "darkportal_fx", 1, 1, "int", &function_9d5f158, 0, 0);
	clientfield::register("scriptmover", "boss_shield_fx", 1, 1, "int", &function_9e956563, 0, 0);
	clientfield::register("scriptmover", "keeper_symbol_fx", 1, 1, "int", &function_358b09c3, 0, 0);
	n_bits = GetMinBitCountForNum(6);
	clientfield::register("scriptmover", "totem_state_fx", 1, n_bits, "int", &function_586ff5f, 0, 0);
	clientfield::register("scriptmover", "totem_damage_fx", 1, 3, "int", &function_e9388f49, 0, 0);
	clientfield::register("scriptmover", "set_fade_material", 1, 1, "int", &function_4ff90290, 0, 0);
	clientfield::register("scriptmover", "set_subway_wall_dissolve", 1, 1, "int", &function_2e3f1dfe, 0, 0);
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("actor", "status_fx", 1, n_bits, "int", &function_b99efa04, 0, 0);
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("vehicle", "veh_status_fx", 1, n_bits, "int", &function_c05af858, 0, 0);
	clientfield::register("actor", "keeper_fx", 1, 1, "int", &function_4b50c64, 0, 0);
	clientfield::register("scriptmover", "item_glow_fx", 1, 3, "int", &function_8cc6432d, 0, 0);
	n_bits = GetMinBitCountForNum(7);
	clientfield::register("scriptmover", "shadowman_fx", 1, n_bits, "int", &function_97a44b14, 0, 0);
	clientfield::register("world", "devgui_gateworm", 1, 1, "int", undefined, 0, 0);
	clientfield::register("scriptmover", "gateworm_basin_fx", 1, 2, "int", &function_ae26528c, 0, 0);
	clientfield::register("world", "wallrun_footprints", 1, 2, "int", &function_1fea37a4, 0, 0);
	a_str_names = Array("boxer", "detective", "femme", "magician");
	for(i = 0; i < 4; i++)
	{
		clientfield::register("toplayer", "check_" + a_str_names[i] + "_memento", 1, 1, "int", &zm_utility::setInventoryUIModels, 0, 0);
	}
	n_bits = GetMinBitCountForNum(6);
	clientfield::register("toplayer", "used_quest_key", 1, n_bits, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "used_quest_key_location", 1, n_bits, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	visionset_mgr::register_visionset_info("zod_ritual_dim", 1, 15, "zm_zod", "zod_ritual_dim");
	flag::init("set_ritual_finished_flag");
	flag::init("set_ritual_key_closed_flag");
	flag::init("set_ritual_key_vanish_flag");
}

/*
	Name: function_7b05c37c
	Namespace: namespace_1f61c67f
	Checksum: 0xEAC280A8
	Offset: 0x2178
	Size: 0x843
	Parameters: 2
	Flags: None
*/
function function_7b05c37c(localClientNum, var_67a8b57)
{
	var_d7e2a718 = function_12955cc8(var_67a8b57);
	s_position = struct::get("defend_area_" + var_d7e2a718, "targetname");
	level.var_b3c23ec9[localClientNum][var_67a8b57] = s_position;
	if(!isdefined(level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd))
	{
		level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd = [];
	}
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] = spawn(localClientNum, s_position.origin, "script_model");
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum].angles = s_position.angles;
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] SetModel("p7_fxanim_zm_zod_redemption_key_ritual_mod");
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum].var_476820c9 = [];
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] util::waittill_dobj(localClientNum);
	v_origin = level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] GetTagOrigin("tag_ritual_drop");
	v_angles = level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] GetTagAngles("tag_ritual_drop");
	if(!isdefined(level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea))
	{
		level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea = [];
	}
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea[localClientNum] = spawn(localClientNum, v_origin, "script_model");
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea[localClientNum].angles = v_angles;
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea[localClientNum] SetModel("p7_zm_zod_memento_" + var_d7e2a718);
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea[localClientNum] LinkTo(level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum], "tag_ritual_drop");
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea[localClientNum] function_ae5b7493(localClientNum, 0, 0.025, 1, 1);
	v_tag_origin = level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] GetTagOrigin("tag_ritual_drop");
	v_tag_angles = level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] GetTagAngles("tag_ritual_drop");
	if(!isdefined(level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea))
	{
		level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea = [];
	}
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea[localClientNum] = spawn(localClientNum, v_tag_origin, "script_model");
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea[localClientNum] SetModel("p7_zm_zod_relic_" + var_d7e2a718);
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea[localClientNum].angles = v_tag_angles;
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea[localClientNum] LinkTo(level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum], "tag_ritual_drop");
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_77504307 = function_9118f74a(localClientNum, var_67a8b57, 1);
	level.var_b3c23ec9[localClientNum][var_67a8b57].var_b1ece640 = function_9118f74a(localClientNum, var_67a8b57, 0);
	v_tag_origin = level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum] GetTagOrigin("tag_char_jnt");
	if(!isdefined(level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim))
	{
		level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim = [];
	}
	level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim[localClientNum] = spawn(localClientNum, v_tag_origin, "script_model");
	switch(var_d7e2a718)
	{
		case "boxer":
		{
			var_30040f63 = "c_zom_zod_promoter_reveal_fb";
			break;
		}
		case "detective":
		{
			var_30040f63 = "c_zom_zod_partner_reveal_fb";
			break;
		}
		case "femme":
		{
			var_30040f63 = "c_zom_zod_producer_reveal_fb";
			break;
		}
		case "magician":
		{
			var_30040f63 = "c_zom_zod_lawyer_reveal_fb";
			break;
		}
	}
	level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim[localClientNum] SetModel(var_30040f63);
	level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim[localClientNum] useanimtree(-1);
}

/*
	Name: function_9118f74a
	Namespace: namespace_1f61c67f
	Checksum: 0x4E35CBF1
	Offset: 0x29C8
	Size: 0x13D
	Parameters: 3
	Flags: None
*/
function function_9118f74a(localClientNum, var_67a8b57, var_85dc52da)
{
	if(var_85dc52da)
	{
		var_3c32cd48 = GetEntArray(localClientNum, "quest_ritual_magic_circle_on", "targetname");
	}
	else
	{
		var_3c32cd48 = GetEntArray(localClientNum, "quest_ritual_magic_circle_off", "targetname");
	}
	str_name = function_12955cc8(var_67a8b57);
	foreach(var_fb62adc1 in var_3c32cd48)
	{
		if(var_fb62adc1.script_string === "ritual_" + str_name)
		{
			return var_fb62adc1;
		}
	}
}

/*
	Name: function_60f1115e
	Namespace: namespace_1f61c67f
	Checksum: 0x2F7F4B39
	Offset: 0x2B10
	Size: 0x225
	Parameters: 4
	Flags: None
*/
function function_60f1115e(localClientNum, var_67a8b57, n_state, var_abf03d83)
{
	if(!isdefined(var_abf03d83))
	{
		var_abf03d83 = 0;
	}
	switch(n_state)
	{
		case 0:
		{
			var_b05b3457 = 0.01;
			level.var_b3c23ec9[localClientNum][var_67a8b57].var_77504307 function_ae5b7493(localClientNum, 2, var_b05b3457, 0, var_abf03d83, 1);
			level.var_b3c23ec9[localClientNum][var_67a8b57].var_b1ece640 function_ae5b7493(localClientNum, 0, var_b05b3457, 0, var_abf03d83, 1);
			break;
		}
		case 1:
		{
			var_b05b3457 = 0.1;
			level.var_b3c23ec9[localClientNum][var_67a8b57].var_77504307 function_ae5b7493(localClientNum, 2, var_b05b3457, 0, var_abf03d83, 1);
			level.var_b3c23ec9[localClientNum][var_67a8b57].var_b1ece640 function_ae5b7493(localClientNum, 0, var_b05b3457, 1, var_abf03d83, 1);
			break;
		}
		case 2:
		{
			var_b05b3457 = 0.1;
			level.var_b3c23ec9[localClientNum][var_67a8b57].var_77504307 function_ae5b7493(localClientNum, 2, var_b05b3457, 1, var_abf03d83, 1);
			level.var_b3c23ec9[localClientNum][var_67a8b57].var_b1ece640 function_ae5b7493(localClientNum, 0, var_b05b3457, 0, var_abf03d83, 1);
			break;
		}
	}
}

/*
	Name: function_ae5b7493
	Namespace: namespace_1f61c67f
	Checksum: 0x4443B764
	Offset: 0x2D40
	Size: 0x29B
	Parameters: 6
	Flags: None
*/
function function_ae5b7493(localClientNum, var_afc7cc94, var_b05b3457, b_on, var_abf03d83, var_c0ce8db2)
{
	if(!isdefined(var_abf03d83))
	{
		var_abf03d83 = 0;
	}
	if(!isdefined(var_c0ce8db2))
	{
		var_c0ce8db2 = 0;
	}
	self notify("hash_ae5b7493");
	self endon("hash_ae5b7493");
	if(self.b_on === b_on)
	{
		return;
	}
	else
	{
		self.b_on = b_on;
	}
	if(var_abf03d83)
	{
		if(b_on)
		{
			self function_487ce26(localClientNum, 1, var_afc7cc94);
		}
		else
		{
			self function_487ce26(localClientNum, 0, var_afc7cc94);
		}
		return;
	}
	if(b_on)
	{
		var_24fbb6c6 = 0;
		i = 0;
		while(var_24fbb6c6 <= 1)
		{
			self function_487ce26(localClientNum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i + var_b05b3457;
		}
		self function_487ce26(localClientNum, 1, var_afc7cc94);
	}
	else
	{
		var_24fbb6c6 = 1;
		i = 1;
		while(var_24fbb6c6 >= 0)
		{
			self function_487ce26(localClientNum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i - var_b05b3457;
		}
		self function_487ce26(localClientNum, 0, var_afc7cc94);
	}
}

/*
	Name: function_487ce26
	Namespace: namespace_1f61c67f
	Checksum: 0xA3E906EF
	Offset: 0x2FE8
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function function_487ce26(localClientNum, n_value, var_afc7cc94)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector" + var_afc7cc94, n_value, n_value, 0, 0);
}

/*
	Name: function_4ff90290
	Namespace: namespace_1f61c67f
	Checksum: 0x31354AE9
	Offset: 0x3048
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_4ff90290(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector0", newVal, 0, 0, 0);
}

/*
	Name: function_2e3f1dfe
	Namespace: namespace_1f61c67f
	Checksum: 0xA581FF91
	Offset: 0x30B8
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_2e3f1dfe(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector0", newVal, 0, 0, 0);
	}
	else
	{
		self thread function_6d34f463(localClientNum, 2);
		self playsound(0, "zmb_zod_wall_dissolve");
	}
}

/*
	Name: function_6d34f463
	Namespace: namespace_1f61c67f
	Checksum: 0x5D7C5AC0
	Offset: 0x3180
	Size: 0xD5
	Parameters: 2
	Flags: None
*/
function function_6d34f463(localClientNum, n_total_time)
{
	self endon("death");
	self endon("entityshutdown");
	var_1baf89ac = n_total_time / 0.016;
	exploder::exploder("lgt_sword_altar_underground");
	for(i = 0; i <= var_1baf89ac; i++)
	{
		var_6740490 = 1 - i / var_1baf89ac;
		self SetShaderConstant(localClientNum, 0, var_6740490, 0, 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_12955cc8
	Namespace: namespace_1f61c67f
	Checksum: 0x5B061C79
	Offset: 0x3260
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function function_12955cc8(var_3e756bce)
{
	switch(var_3e756bce)
	{
		case 1:
		{
			return "boxer";
		}
		case 2:
		{
			return "detective";
		}
		case 3:
		{
			return "femme";
		}
		case 4:
		{
			return "magician";
		}
		case 5:
		{
			return "pap";
		}
	}
}

/*
	Name: function_15aa913e
	Namespace: namespace_1f61c67f
	Checksum: 0x8AFA6C69
	Offset: 0x32D8
	Size: 0xB65
	Parameters: 3
	Flags: None
*/
function function_15aa913e(localClientNum, newVal, var_67a8b57)
{
	level notify("ritual_state_internal" + localClientNum);
	level endon("ritual_state_internal" + localClientNum);
	str_name = function_12955cc8(var_67a8b57);
	if(!isdefined(level.var_b3c23ec9))
	{
		level.var_b3c23ec9 = [];
	}
	if(!isdefined(level.var_b3c23ec9[localClientNum]))
	{
		level.var_b3c23ec9[localClientNum] = [];
	}
	if(!isdefined(level.var_b3c23ec9[localClientNum][var_67a8b57]))
	{
		function_7b05c37c(localClientNum, var_67a8b57);
	}
	var_5283b18c = level.var_b3c23ec9[localClientNum][var_67a8b57].var_cc38f8bd[localClientNum];
	var_5283b18c util::waittill_dobj(localClientNum);
	if(!var_5283b18c HasAnimTree())
	{
		var_5283b18c useanimtree(-1);
	}
	var_b899f06a = level.var_b3c23ec9[localClientNum][var_67a8b57].var_91a482ea[localClientNum];
	var_3671a26a = level.var_b3c23ec9[localClientNum][var_67a8b57].var_82fc50ea[localClientNum];
	if(!var_3671a26a HasAnimTree())
	{
		var_3671a26a useanimtree(-1);
	}
	var_f1148651 = level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim[localClientNum];
	switch(newVal)
	{
		case 0:
		{
			var_5283b18c Hide();
			var_b899f06a Hide();
			var_3671a26a Hide();
			var_f1148651 Hide();
			level thread function_60f1115e(localClientNum, var_67a8b57, 1, 1);
			if(isdefined(var_5283b18c.var_958bf245))
			{
				stopfx(localClientNum, var_5283b18c.var_958bf245);
			}
			level thread function_f7d8d98b(0, var_5283b18c);
			break;
		}
		case 1:
		{
			level notify("hash_67427114");
			var_5283b18c Hide();
			var_b899f06a show();
			var_b899f06a function_ae5b7493(localClientNum, 0, 0.025, 1, 1);
			var_3671a26a Hide();
			var_f1148651 Hide();
			level thread function_60f1115e(localClientNum, var_67a8b57, 1);
			if(isdefined(var_5283b18c.var_958bf245))
			{
				stopfx(localClientNum, var_5283b18c.var_958bf245);
			}
			var_5283b18c ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_start_anim", 0);
			var_5283b18c ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0);
			var_5283b18c ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0);
			level thread function_f7d8d98b(1, var_5283b18c);
			level thread exploder::stop_exploder("ritual_light_" + str_name);
			function_fdbf1ed5(localClientNum, str_name, 0);
			function_46df8306(localClientNum, "defend_area_spawn_point_" + str_name, 0);
			break;
		}
		case 2:
		{
			var_5283b18c show();
			var_3671a26a Hide();
			var_f1148651 Hide();
			level thread function_60f1115e(localClientNum, var_67a8b57, 2);
			for(i = 0; i < 4; i++)
			{
				var_5283b18c.var_476820c9[i] = PlayFXOnTag(localClientNum, level._effect["ritual_trail"], var_5283b18c, "disc" + i + 1 + "_blade_body_jnt");
			}
			var_5283b18c.var_958bf245 = PlayFXOnTag(localClientNum, level._effect["ritual_key_open_glow"], var_5283b18c, "key_outer_rot_jnt");
			level thread function_f7d8d98b(2, var_5283b18c);
			level thread exploder::exploder("ritual_light_" + str_name);
			function_fdbf1ed5(localClientNum, str_name, 1);
			function_46df8306(localClientNum, "defend_area_spawn_point_" + str_name, 1);
			var_b899f06a show();
			var_b899f06a function_ae5b7493(localClientNum, 0, 0.025, 1, 1);
			var_5283b18c animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_start_anim", undefined, undefined, 1, 0, 0);
			level thread function_eb1d9e29(localClientNum, var_5283b18c, var_b899f06a, var_f1148651);
			var_5283b18c animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", undefined, undefined, 1, 0, 0);
			var_5283b18c ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0);
			var_5283b18c animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", undefined, undefined, 1, 0, 0);
			break;
		}
		case 3:
		{
			level notify("hash_67427114");
			var_3671a26a SetAnim("ai_zombie_zod_gateworm_idle_loop", 1, 0, 1);
			var_5283b18c show();
			var_b899f06a Hide();
			var_3671a26a Hide();
			var_f1148651 show();
			var_f1148651 = level.var_b3c23ec9[localClientNum][var_67a8b57].e_victim[localClientNum];
			var_f1148651.var_d981f405 = PlayFXOnTag(localClientNum, level._effect["ritual_glow_chest"], var_f1148651, "j_spineupper");
			var_f1148651.var_cde8f060 = PlayFXOnTag(localClientNum, level._effect["ritual_glow_head"], var_f1148651, "tag_eye");
			var_5283b18c ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0);
			if(isdefined(var_5283b18c.var_476820c9))
			{
				foreach(var_2d3cc156 in var_5283b18c.var_476820c9)
				{
					stopfx(localClientNum, var_2d3cc156);
				}
			}
			var_f1148651 thread animation::Play("ai_zombie_zod_ritual_sacrifice_outro", undefined, undefined, 1, 0.4, 0.25);
			level thread function_dd358b4e(localClientNum, var_5283b18c, var_3671a26a, var_f1148651, str_name);
			level thread function_ed53c8d4(localClientNum, var_5283b18c);
			level thread function_1088ce1d(localClientNum, var_5283b18c);
			var_5283b18c animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_end_anim");
			var_5283b18c ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_end_anim", 0);
			var_5283b18c thread animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_end_idle_anim");
			level thread function_60f1115e(localClientNum, var_67a8b57, 0);
			var_f1148651 Hide();
			break;
		}
		case 4:
		{
			var_3671a26a Hide();
			var_3671a26a playsound(0, "zmb_zod_ritual_worm_pickup");
			var_3671a26a StopAllLoopSounds(0.5);
			break;
		}
	}
}

/*
	Name: function_eb1d9e29
	Namespace: namespace_1f61c67f
	Checksum: 0x58A07EFC
	Offset: 0x3E48
	Size: 0x8B
	Parameters: 4
	Flags: None
*/
function function_eb1d9e29(localClientNum, var_5283b18c, var_b899f06a, var_f1148651)
{
	var_b899f06a thread function_ae5b7493(localClientNum, 0, 0.025, 0, 0, 0);
	wait(0.15);
	var_f1148651 show();
	level thread function_67427114(localClientNum, var_5283b18c, var_f1148651);
}

/*
	Name: function_67427114
	Namespace: namespace_1f61c67f
	Checksum: 0x395D113E
	Offset: 0x3EE0
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function function_67427114(localClientNum, var_5283b18c, var_f1148651)
{
	level notify("ritual_victim_animation" + localClientNum);
	level endon("ritual_victim_animation" + localClientNum);
	var_f1148651 ClearAnim("ai_zombie_zod_ritual_sacrifice_intro", 0);
	var_f1148651 ClearAnim("ai_zombie_zod_ritual_sacrifice_loop", 0);
	var_f1148651 ClearAnim("ai_zombie_zod_ritual_sacrifice_outro", 0);
	var_f1148651 LinkTo(var_f1148651, "tag_char_jnt", (0, 0, 0), (0, 0, 0));
	var_f1148651 thread function_ae5b7493(localClientNum, 0, 0.025, 1);
	var_f1148651 animation::Play("ai_zombie_zod_ritual_sacrifice_intro", undefined, undefined, 1, 0, 0.2);
	var_f1148651 thread animation::Play("ai_zombie_zod_ritual_sacrifice_loop", undefined, undefined, 1, 0.2, 0.4);
}

/*
	Name: function_dd358b4e
	Namespace: namespace_1f61c67f
	Checksum: 0xEE957936
	Offset: 0x4040
	Size: 0x24B
	Parameters: 5
	Flags: None
*/
function function_dd358b4e(localClientNum, var_5283b18c, var_3671a26a, var_f1148651, str_name)
{
	flag::wait_till("set_ritual_finished_flag");
	v_origin = var_5283b18c GetTagOrigin("tag_fx_chest");
	v_angles = var_5283b18c GetTagAngles("tag_fx_chest");
	v_angles = v_angles - VectorScale((1, 0, 0), 90);
	v_fwd = AnglesToForward(v_angles);
	playFX(localClientNum, level._effect["ritual_bloodsplosion"], v_origin, v_fwd);
	level thread function_3a9a1b46(var_3671a26a);
	if(str_name === "pap")
	{
		var_f1148651 Hide();
	}
	else
	{
		var_f1148651 thread function_ae5b7493(localClientNum, 0, 0.05, 0, 0, 1);
	}
	stopfx(localClientNum, var_f1148651.var_d981f405);
	stopfx(localClientNum, var_f1148651.var_cde8f060);
	level thread function_f7d8d98b(3, var_5283b18c);
	level thread function_4a1fb717(str_name);
	function_fdbf1ed5(localClientNum, str_name, 0);
	function_46df8306(localClientNum, "defend_area_spawn_point_" + str_name, 0);
	flag::clear("set_ritual_finished_flag");
}

/*
	Name: function_3a9a1b46
	Namespace: namespace_1f61c67f
	Checksum: 0xBA83D42D
	Offset: 0x4298
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_3a9a1b46(var_3671a26a)
{
	if(isdefined(var_3671a26a))
	{
		var_69146d00 = level clientfield::get("devgui_gateworm");
		if(!(isdefined(var_69146d00) && var_69146d00))
		{
			wait(0.25);
			var_3671a26a show();
			var_3671a26a PlayLoopSound("zmb_zod_ritual_worm_lp", 1);
		}
	}
}

/*
	Name: function_ed53c8d4
	Namespace: namespace_1f61c67f
	Checksum: 0xB11B9D6E
	Offset: 0x4338
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function function_ed53c8d4(localClientNum, var_5283b18c)
{
	flag::wait_till("set_ritual_key_closed_flag");
	if(isdefined(var_5283b18c.var_958bf245))
	{
		stopfx(localClientNum, var_5283b18c.var_958bf245);
	}
	flag::clear("set_ritual_key_closed_flag");
}

/*
	Name: function_1088ce1d
	Namespace: namespace_1f61c67f
	Checksum: 0x2AE6B08F
	Offset: 0x43C0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function function_1088ce1d(localClientNum, var_5283b18c)
{
	flag::wait_till("set_ritual_key_vanish_flag");
	var_5283b18c Hide();
	flag::clear("set_ritual_key_vanish_flag");
}

/*
	Name: function_4a1fb717
	Namespace: namespace_1f61c67f
	Checksum: 0x6CF5B77D
	Offset: 0x4428
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_4a1fb717(str_name)
{
	level thread exploder::stop_exploder("ritual_light_" + str_name);
	level thread exploder::exploder("ritual_light_" + str_name + "_fin");
}

/*
	Name: function_fdbf1ed5
	Namespace: namespace_1f61c67f
	Checksum: 0x9612D8DF
	Offset: 0x4488
	Size: 0x1AD
	Parameters: 3
	Flags: None
*/
function function_fdbf1ed5(localClientNum, str_name, b_on)
{
	var_fc4d2f71 = GetEntArray(localClientNum, "ritual_pedestal", "targetname");
	foreach(var_576f557d in var_fc4d2f71)
	{
		if(!isdefined(var_576f557d.var_478e6ed9))
		{
			var_576f557d.var_478e6ed9 = [];
		}
		if(b_on && var_576f557d.script_string == "ritual_" + str_name)
		{
			var_576f557d.var_478e6ed9[localClientNum] = playFX(localClientNum, level._effect["ritual_altar"], var_576f557d.origin);
			continue;
		}
		if(isdefined(var_576f557d.var_478e6ed9[localClientNum]))
		{
			stopfx(localClientNum, var_576f557d.var_478e6ed9[localClientNum]);
			var_576f557d.var_478e6ed9[localClientNum] = undefined;
		}
	}
}

/*
	Name: function_46df8306
	Namespace: namespace_1f61c67f
	Checksum: 0xFE590E93
	Offset: 0x4640
	Size: 0x251
	Parameters: 3
	Flags: None
*/
function function_46df8306(localClientNum, str_name, b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	a_s_spawn_points = struct::get_array(str_name, "targetname");
	foreach(s_spawn_point in a_s_spawn_points)
	{
		s_spawn_point function_267f859f(localClientNum, level._effect["keeper_spawn"], b_on);
		if(!isdefined(s_spawn_point.var_d52fc488))
		{
			s_spawn_point.var_d52fc488 = 0;
		}
		if(isdefined(b_on) && b_on)
		{
			if(!(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488))
			{
				s_spawn_point.var_d52fc488 = 1;
				playsound(0, "evt_keeper_portal_start", s_spawn_point.origin);
				audio::playloopat("evt_keeper_portal_loop", s_spawn_point.origin);
			}
		}
		else if(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488)
		{
			s_spawn_point.var_d52fc488 = 0;
			playsound(0, "evt_keeper_portal_end", s_spawn_point.origin);
			audio::stoploopat("evt_keeper_portal_loop", s_spawn_point.origin);
		}
		wait(0.2);
	}
}

/*
	Name: function_267f859f
	Namespace: namespace_1f61c67f
	Checksum: 0x1BA33036
	Offset: 0x48A0
	Size: 0x18F
	Parameters: 5
	Flags: None
*/
function function_267f859f(localClientNum, fx_id, b_on, var_afcc5d76, str_tag)
{
	if(!isdefined(fx_id))
	{
		fx_id = undefined;
	}
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	if(!isdefined(var_afcc5d76))
	{
		var_afcc5d76 = 0;
	}
	if(!isdefined(str_tag))
	{
		str_tag = "tag_origin";
	}
	if(!isdefined(self.var_270913b5))
	{
		self.var_270913b5 = [];
	}
	if(b_on)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(self.var_270913b5[localClientNum]))
		{
			stopfx(localClientNum, self.var_270913b5[localClientNum]);
		}
		if(var_afcc5d76)
		{
			self.var_270913b5[localClientNum] = PlayFXOnTag(localClientNum, fx_id, self, str_tag);
		}
		else
		{
			self.var_270913b5[localClientNum] = playFX(localClientNum, fx_id, self.origin, self.angles);
		}
	}
	else if(isdefined(self.var_270913b5[localClientNum]))
	{
		stopfx(localClientNum, self.var_270913b5[localClientNum]);
		self.var_270913b5[localClientNum] = undefined;
	}
}

/*
	Name: function_f7d8d98b
	Namespace: namespace_1f61c67f
	Checksum: 0x4734B674
	Offset: 0x4A38
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function function_f7d8d98b(State, e_model)
{
	level notify("hash_f7d8d98b");
	level endon("hash_f7d8d98b");
	switch(State)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			e_model playsound(0, "zmb_zod_ritual_piece_place");
			break;
		}
		case 2:
		{
			e_model playsound(0, "zmb_zod_ritual_key_flame");
			break;
		}
		case 3:
		{
			break;
		}
	}
}

/*
	Name: function_9b761da1
	Namespace: namespace_1f61c67f
	Checksum: 0xEB849CCF
	Offset: 0x4AF8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_9b761da1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_15aa913e(localClientNum, newVal, 1);
}

/*
	Name: function_7f6e0cbe
	Namespace: namespace_1f61c67f
	Checksum: 0x61415650
	Offset: 0x4B60
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_7f6e0cbe(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_15aa913e(localClientNum, newVal, 2);
}

/*
	Name: function_2ae7c9d9
	Namespace: namespace_1f61c67f
	Checksum: 0xC46EB148
	Offset: 0x4BC8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_2ae7c9d9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_15aa913e(localClientNum, newVal, 3);
}

/*
	Name: function_77f45902
	Namespace: namespace_1f61c67f
	Checksum: 0x5B4BD691
	Offset: 0x4C30
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_77f45902(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_15aa913e(localClientNum, newVal, 4);
}

/*
	Name: function_b8553178
	Namespace: namespace_1f61c67f
	Checksum: 0x1EEBCFC4
	Offset: 0x4C98
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_b8553178(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	zm_utility::setSharedInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

/*
	Name: function_42da8b5f
	Namespace: namespace_1f61c67f
	Checksum: 0x56EC2D32
	Offset: 0x4D10
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_42da8b5f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	zm_utility::setSharedInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

/*
	Name: function_6fa910ac
	Namespace: namespace_1f61c67f
	Checksum: 0x75936A2A
	Offset: 0x4D88
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_6fa910ac(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	zm_utility::setSharedInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

/*
	Name: function_2c62c721
	Namespace: namespace_1f61c67f
	Checksum: 0xCEDE4CD
	Offset: 0x4E00
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_2c62c721(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	zm_utility::setSharedInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

/*
	Name: function_42e9f1c0
	Namespace: namespace_1f61c67f
	Checksum: 0xB0C030A
	Offset: 0x4E78
	Size: 0x5BD
	Parameters: 7
	Flags: None
*/
function function_42e9f1c0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_c6f3f6c3 = GetEnt(localClientNum, "pap_portal", "targetname");
	var_c6f3f6c3 util::waittill_dobj(localClientNum);
	if(!var_c6f3f6c3 HasAnimTree())
	{
		var_c6f3f6c3 useanimtree(-1);
	}
	str_name = function_12955cc8(5);
	if(newVal == 2)
	{
		level thread exploder::exploder("ritual_light_pap");
		function_46df8306(localClientNum, "defend_area_spawn_point_" + str_name, 1);
		var_fc4d2f71 = GetEntArray(localClientNum, "ritual_pedestal", "targetname");
		foreach(var_576f557d in var_fc4d2f71)
		{
			if(!isdefined(var_576f557d.var_478e6ed9))
			{
				var_576f557d.var_478e6ed9 = [];
			}
			if(var_576f557d.script_string == "ritual_pap")
			{
				var_576f557d.var_478e6ed9[localClientNum] = playFX(localClientNum, level._effect["pap_altar_glow"], var_576f557d.origin);
			}
		}
		break;
	}
	if(newVal == 3)
	{
		var_c6f3f6c3 show();
		var_c6f3f6c3 thread animation::Play("p7_fxanim_zm_zod_gatestone_anim", undefined, undefined, 1);
		level thread exploder::stop_exploder("ritual_light_pap");
		level thread function_b2aa47f0();
		function_46df8306(localClientNum, "defend_area_spawn_point_" + str_name, 0);
		var_fc4d2f71 = GetEntArray(localClientNum, "ritual_pedestal", "targetname");
		foreach(var_576f557d in var_fc4d2f71)
		{
			if(!isdefined(var_576f557d.var_478e6ed9))
			{
				var_576f557d.var_478e6ed9 = [];
			}
			if(isdefined(var_576f557d.var_478e6ed9[localClientNum]))
			{
				stopfx(localClientNum, var_576f557d.var_478e6ed9[localClientNum]);
				var_576f557d.var_478e6ed9[localClientNum] = undefined;
			}
		}
		break;
	}
	if(newVal == 1)
	{
		var_c6f3f6c3 Hide();
		level thread exploder::stop_exploder("ritual_light_pap");
		level thread function_b2aa47f0();
		function_46df8306(localClientNum, "defend_area_spawn_point_" + str_name, 0);
		var_fc4d2f71 = GetEntArray(localClientNum, "ritual_pedestal", "targetname");
		foreach(var_576f557d in var_fc4d2f71)
		{
			if(!isdefined(var_576f557d.var_478e6ed9))
			{
				var_576f557d.var_478e6ed9 = [];
			}
			if(isdefined(var_576f557d.var_478e6ed9[localClientNum]))
			{
				stopfx(localClientNum, var_576f557d.var_478e6ed9[localClientNum]);
				var_576f557d.var_478e6ed9[localClientNum] = undefined;
			}
		}
	}
}

/*
	Name: function_b2aa47f0
	Namespace: namespace_1f61c67f
	Checksum: 0x614EECB9
	Offset: 0x5440
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_b2aa47f0()
{
	soundLineEmitter("zmb_zod_pap_portal_lp_dist", (2613, -2239, -258), (2608, -3045, -275));
	soundloopemitter("zmb_zod_pap_portal_lp", (2613, -2239, -258));
}

/*
	Name: function_91f9842
	Namespace: namespace_1f61c67f
	Checksum: 0x137181CB
	Offset: 0x54B0
	Size: 0x95
	Parameters: 7
	Flags: None
*/
function function_91f9842(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_b3c23ec9[localClientNum]))
	{
		return;
	}
	var_80c01a3e = level clientfield::get("ritual_current");
	if(var_80c01a3e != 5 && var_80c01a3e != 0)
	{
	}
}

/*
	Name: function_4b50c64
	Namespace: namespace_1f61c67f
	Checksum: 0xDBBE6F32
	Offset: 0x5550
	Size: 0x27B
	Parameters: 7
	Flags: None
*/
function function_4b50c64(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal === 1)
	{
		self.var_341f7209 = PlayFXOnTag(localClientNum, level._effect["keeper_glow"], self, "j_spineupper");
		self.var_c5e3cf4b = PlayFXOnTag(localClientNum, level._effect["keeper_mouth"], self, "j_head");
		self.var_2d3cc156 = PlayFXOnTag(localClientNum, level._effect["keeper_trail"], self, "j_robe_front_03");
		if(!isdefined(self.var_78ca62e9))
		{
			self.var_78ca62e9 = self PlayLoopSound("zmb_keeper_looper");
		}
	}
	else if(isdefined(self.var_341f7209))
	{
		stopfx(localClientNum, self.var_341f7209);
	}
	self.var_341f7209 = undefined;
	if(isdefined(self.var_c5e3cf4b))
	{
		stopfx(localClientNum, self.var_c5e3cf4b);
	}
	self.var_c5e3cf4b = undefined;
	if(isdefined(self.var_2d3cc156))
	{
		stopfx(localClientNum, self.var_2d3cc156);
	}
	self.var_2d3cc156 = undefined;
	v_origin = self GetTagOrigin("j_spineupper");
	v_angles = self GetTagAngles("j_spineupper");
	if(isdefined(v_origin) && isdefined(v_angles))
	{
		playFX(localClientNum, level._effect["keeper_death"], v_origin, v_angles);
	}
	self StopAllLoopSounds(1);
}

/*
	Name: function_358b09c3
	Namespace: namespace_1f61c67f
	Checksum: 0x848BFE9F
	Offset: 0x57D8
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_358b09c3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_267f859f(localClientNum, level._effect["keeper_glow"], newVal, 1);
}

/*
	Name: function_8cc6432d
	Namespace: namespace_1f61c67f
	Checksum: 0x60724998
	Offset: 0x5850
	Size: 0x1DD
	Parameters: 7
	Flags: None
*/
function function_8cc6432d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("hash_8cc6432d");
	self endon("hash_8cc6432d");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.var_8cc6432d))
	{
		stopfx(localClientNum, self.var_8cc6432d);
		self.var_8cc6432d = undefined;
	}
	switch(newVal)
	{
		case 1:
		{
			self.var_8cc6432d = PlayFXOnTag(localClientNum, level._effect["ritual_key_glow"], self, "key_body_jnt");
			break;
		}
		case 2:
		{
			self.var_8cc6432d = PlayFXOnTag(localClientNum, level._effect["relic_glow"], self, "tag_origin");
			break;
		}
		case 3:
		{
			self.var_8cc6432d = PlayFXOnTag(localClientNum, level._effect["memento_glow"], self, "tag_origin");
			break;
		}
		case 4:
		{
			self.var_8cc6432d = PlayFXOnTag(localClientNum, level._effect["fuse_glow"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: function_a17c1f53
	Namespace: namespace_1f61c67f
	Checksum: 0x685D9FBA
	Offset: 0x5A38
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function function_a17c1f53(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	for(i = 0; i < 4; i++)
	{
		b_on = newVal >> i & 1;
		str_name = function_12955cc8(i + 1);
		function_46df8306(localClientNum, "memento_spawn_point_" + str_name, b_on);
	}
}

/*
	Name: function_af8eff6d
	Namespace: namespace_1f61c67f
	Checksum: 0x5B75085
	Offset: 0x5B18
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_af8eff6d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_46df8306(localClientNum, "keeper_spawn_point_subway", newVal);
}

/*
	Name: function_a3ec6769
	Namespace: namespace_1f61c67f
	Checksum: 0x3FBE0D6C
	Offset: 0x5B80
	Size: 0x113
	Parameters: 7
	Flags: None
*/
function function_a3ec6769(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_78ca62e9))
	{
		self StopLoopSound(self.var_78ca62e9, 0.5);
		self.var_78ca62e9 = undefined;
		self playsound(0, "zmb_zod_cursed_landmine_end");
	}
	if(newVal)
	{
		self.var_78ca62e9 = self PlayLoopSound("zmb_zod_cursed_landmine_lp", 1);
		self playsound(0, "zmb_zod_cursed_landmine_start");
	}
	self function_267f859f(localClientNum, level._effect["curse_circle"], newVal, 1);
}

/*
	Name: function_33a0658b
	Namespace: namespace_1f61c67f
	Checksum: 0xA386AC60
	Offset: 0x5CA0
	Size: 0x113
	Parameters: 7
	Flags: None
*/
function function_33a0658b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_78ca62e9))
	{
		self StopLoopSound(self.var_78ca62e9, 0.5);
		self.var_78ca62e9 = undefined;
		self playsound(0, "zmb_zod_cursed_landmine_end");
	}
	if(newVal)
	{
		self.var_78ca62e9 = self PlayLoopSound("zmb_zod_cursed_landmine_lp", 1);
		self playsound(0, "zmb_zod_cursed_landmine_start");
	}
	self function_267f859f(localClientNum, level._effect["mini_curse_circle"], newVal, 1);
}

/*
	Name: function_3f11ade6
	Namespace: namespace_1f61c67f
	Checksum: 0x84643177
	Offset: 0x5DC0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_3f11ade6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_267f859f(localClientNum, level._effect["curse_tell"], newVal, 1);
}

/*
	Name: function_9e956563
	Namespace: namespace_1f61c67f
	Checksum: 0x903C65C8
	Offset: 0x5E38
	Size: 0x263
	Parameters: 7
	Flags: None
*/
function function_9e956563(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_53c5edf0 = self GetTagOrigin("j_spinelower");
	if(isdefined(self.var_78ca62e9))
	{
		self StopLoopSound(self.var_78ca62e9, 1);
		self.var_78ca62e9 = undefined;
	}
	if(newVal)
	{
		var_caece670 = playFX(localClientNum, level._effect["shadowman_shield_regeneration"], var_53c5edf0);
		wait(1);
		stopfx(localClientNum, var_caece670);
		if(isdefined(self))
		{
			self function_267f859f(localClientNum, level._effect["shadowman_shield"], 1, 1, "j_spinelower");
			self.var_78ca62e9 = self PlayLoopSound("zmb_zod_shadfight_shield_lp", 2);
		}
	}
	else
	{
		var_2f708c86 = playFX(localClientNum, level._effect["shadowman_sword_impact_shield"], var_53c5edf0);
		wait(1);
		stopfx(localClientNum, var_2f708c86);
		playFX(localClientNum, level._effect["shadowman_shield_explosion"], var_53c5edf0);
		if(isdefined(self))
		{
			self function_267f859f(localClientNum, level._effect["shadowman_hover"], 1, 1, "j_spinelower");
			self.var_78ca62e9 = self PlayLoopSound("zmb_zod_shadfight_shield_down_lp", 2);
		}
	}
}

/*
	Name: function_b99efa04
	Namespace: namespace_1f61c67f
	Checksum: 0x5E86FFBC
	Offset: 0x60A8
	Size: 0x11D
	Parameters: 7
	Flags: None
*/
function function_b99efa04(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 0 && isdefined(self.var_a77e68b9))
	{
		stopfx(localClientNum, self.var_a77e68b9);
		break;
	}
	if(!isdefined(self.var_a77e68b9))
	{
		switch(newVal)
		{
			case 1:
			{
				self.var_a77e68b9 = PlayFXOnTag(localClientNum, level._effect["darkfire_buff"], self, "j_head");
				break;
			}
			case 2:
			{
				self.var_a77e68b9 = PlayFXOnTag(localClientNum, level._effect["margwa_buff"], self, "j_head");
				break;
			}
		}
	}
}

/*
	Name: function_c05af858
	Namespace: namespace_1f61c67f
	Checksum: 0x505E9771
	Offset: 0x61D0
	Size: 0x11D
	Parameters: 7
	Flags: None
*/
function function_c05af858(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 0 && isdefined(self.var_a77e68b9))
	{
		stopfx(localClientNum, self.var_a77e68b9);
		break;
	}
	if(!isdefined(self.var_a77e68b9))
	{
		switch(newVal)
		{
			case 1:
			{
				self.var_a77e68b9 = PlayFXOnTag(localClientNum, level._effect["parasite_buff"], self, "j_head");
				break;
			}
			case 2:
			{
				self.var_a77e68b9 = PlayFXOnTag(localClientNum, level._effect["meatball_buff"], self, "tag_body");
				break;
			}
		}
	}
}

/*
	Name: function_97a44b14
	Namespace: namespace_1f61c67f
	Checksum: 0xC32A64A9
	Offset: 0x62F8
	Size: 0x391
	Parameters: 7
	Flags: None
*/
function function_97a44b14(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_6067fcbe))
	{
		stopfx(localClientNum, self.var_6067fcbe);
	}
	if(isdefined(self.var_8eb9fdc0))
	{
		stopfx(localClientNum, self.var_8eb9fdc0);
	}
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newVal)
	{
		case 1:
		{
			PlayFXOnTag(localClientNum, level._effect["shadowman_teleport"], self, "j_spinelower");
			self.var_8741354e = PlayFXOnTag(localClientNum, level._effect["shadowman_light"], self, "j_spineupper");
			self.var_bac79b3d = PlayFXOnTag(localClientNum, level._effect["shadowman_smoke"], self, "tag_origin");
			break;
		}
		case 2:
		{
			if(isdefined(self.var_8741354e))
			{
				stopfx(localClientNum, self.var_8741354e);
			}
			if(isdefined(self.var_bac79b3d))
			{
				stopfx(localClientNum, self.var_bac79b3d);
			}
			v_origin = self GetTagOrigin("j_spinelower");
			if(!isdefined(v_origin))
			{
				v_origin = self.origin;
			}
			level thread function_705b696b(localClientNum, level._effect["shadowman_teleport"], v_origin, 2);
			level thread function_705b696b(localClientNum, level._effect["shadowman_smoke"], v_origin, 2);
			break;
		}
		case 3:
		{
			self.var_6067fcbe = PlayFXOnTag(localClientNum, level._effect["shadowman_hover_charge"], self, "j_spinelower");
			self.var_8eb9fdc0 = PlayFXOnTag(localClientNum, level._effect["shadowman_energy_ball_charge"], self, "tag_weapon_right");
			break;
		}
		case 4:
		{
			self.var_8eb9fdc0 = PlayFXOnTag(localClientNum, level._effect["shadowman_energy_ball"], self, "tag_weapon_right");
			break;
		}
		case 5:
		{
			self.var_8eb9fdc0 = PlayFXOnTag(localClientNum, level._effect["shadowman_energy_ball_explosion"], self, "tag_weapon_right");
			break;
		}
		case 6:
		{
			break;
		}
	}
}

/*
	Name: function_705b696b
	Namespace: namespace_1f61c67f
	Checksum: 0xFC8011A0
	Offset: 0x6698
	Size: 0x73
	Parameters: 4
	Flags: None
*/
function function_705b696b(localClientNum, str_fx, v_origin, var_aa6d31db)
{
	fx_id = playFX(localClientNum, str_fx, v_origin);
	wait(var_aa6d31db);
	stopfx(localClientNum, fx_id);
}

/*
	Name: function_9d5f158
	Namespace: namespace_1f61c67f
	Checksum: 0x6874AE89
	Offset: 0x6718
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_9d5f158(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_267f859f(localClientNum, level._effect["darkfire_portal"], newVal, 1);
}

/*
	Name: function_586ff5f
	Namespace: namespace_1f61c67f
	Checksum: 0x1AE26DC4
	Offset: 0x6790
	Size: 0x2AD
	Parameters: 7
	Flags: None
*/
function function_586ff5f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.sndLoopID))
	{
		self StopLoopSound(self.sndLoopID, 0.25);
	}
	switch(newVal)
	{
		case 0:
		{
			self function_267f859f(localClientNum, undefined, 0);
			break;
		}
		case 1:
		{
			self function_267f859f(localClientNum, level._effect["totem_hover"], 1, 1, "j_totem");
			break;
		}
		case 2:
		{
			self function_267f859f(localClientNum, level._effect["totem_ready"], 1, 1);
			self.sndLoopID = self PlayLoopSound("zmb_zod_totem_chargearea_glow_lp", 2);
			break;
		}
		case 3:
		{
			self function_267f859f(localClientNum, level._effect["totem_charging"], 1, 1, "j_head");
			self.sndLoopID = self PlayLoopSound("zmb_zod_totem_charging_lp", 2);
			break;
		}
		case 4:
		{
			self function_267f859f(localClientNum, level._effect["totem_charged"], 1, 1, "j_head");
			self playsound(0, "zmb_zod_totem_charged");
			self.sndLoopID = self PlayLoopSound("zmb_zod_totem_charged_lp", 2);
			break;
		}
		case 5:
		{
			self function_267f859f(localClientNum, undefined, 0);
			playFX(localClientNum, level._effect["totem_break"], self.origin);
			break;
		}
	}
}

/*
	Name: function_e9388f49
	Namespace: namespace_1f61c67f
	Checksum: 0xB1A1C679
	Offset: 0x6A48
	Size: 0x145
	Parameters: 7
	Flags: None
*/
function function_e9388f49(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_da89d643))
	{
		level.var_de6a5ba3 = [];
	}
	if(!isdefined(level.var_de6a5ba3[newVal - 1]))
	{
		level.var_de6a5ba3[newVal - 1] = [];
	}
	if(newVal > 0)
	{
		level.var_de6a5ba3[newVal - 1][localClientNum] = playFX(localClientNum, level._effect["keeper_death"], self.origin + (0, 0, 16 * newVal));
		break;
	}
	for(i = 0; i < level.var_de6a5ba3.size; i++)
	{
		stopfx(localClientNum, level.var_de6a5ba3[i][localClientNum]);
	}
}

/*
	Name: function_1fea37a4
	Namespace: namespace_1f61c67f
	Checksum: 0xD6ADFB45
	Offset: 0x6B98
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_1fea37a4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		level thread footsteps(localClientNum, "s_left_wallrun");
	}
	else if(newVal == 2)
	{
		level thread footsteps(localClientNum, "s_right_wallrun");
	}
}

/*
	Name: function_ae26528c
	Namespace: namespace_1f61c67f
	Checksum: 0x8C050197
	Offset: 0x6C40
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_ae26528c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.fx_id = PlayFXOnTag(localClientNum, level._effect["gateworm_basin_placed"], self, "tag_origin");
	}
	else if(newVal == 2)
	{
		if(isdefined(self.fx_id))
		{
			stopfx(localClientNum, self.fx_id);
		}
		self.fx_id = PlayFXOnTag(localClientNum, level._effect["gateworm_basin_quest_complete"], self, "tag_origin");
	}
}

/*
	Name: footsteps
	Namespace: namespace_1f61c67f
	Checksum: 0x3C824622
	Offset: 0x6D48
	Size: 0x309
	Parameters: 2
	Flags: None
*/
function footsteps(localClientNum, str_name)
{
	a_struct = [];
	var_8f19a67f = 10;
	for(i = 0; i < var_8f19a67f; i++)
	{
		str_struct = str_name + "_" + i;
		a_struct[a_struct.size] = struct::get(str_struct, "targetname");
	}
	for(num_loops = 0; num_loops < 10; num_loops++)
	{
		for(i = 0; i < a_struct.size; i++)
		{
			s_inst = a_struct[i];
			if(!isdefined(s_inst.m_model))
			{
				s_inst.m_model = [];
			}
			if(!isdefined(s_inst.m_model[localClientNum]))
			{
				s_inst.m_model[localClientNum] = spawn(localClientNum, s_inst.origin, "script_model");
			}
			s_inst.m_model[localClientNum] SetModel("tag_origin");
			s_inst.m_model[localClientNum].angles = s_inst.angles;
			if(i & 1)
			{
				PlayFXOnTag(localClientNum, level._effect["footprint_r"], s_inst.m_model[localClientNum], "tag_origin");
			}
			else
			{
				PlayFXOnTag(localClientNum, level._effect["footprint_l"], s_inst.m_model[localClientNum], "tag_origin");
			}
			wait(0.1);
		}
		wait(4);
		for(i = 0; i < a_struct.size; i++)
		{
			s_inst = a_struct[i];
			if(isdefined(s_inst.m_model[localClientNum]))
			{
				s_inst.m_model[localClientNum] delete();
				s_inst.m_model[localClientNum] = undefined;
			}
		}
		wait(1);
	}
}

