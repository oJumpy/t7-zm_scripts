#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod;
#using scripts\zm\zm_zod_quest;

#namespace namespace_ba13c715;

/*
	Name: __init__sytem__
	Namespace: namespace_ba13c715
	Checksum: 0x1604008A
	Offset: 0x1168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_ba13c715
	Checksum: 0x46556135
	Offset: 0x11A8
	Size: 0x6D3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["player_cleanse"] = "zombie/fx_ee_player_cleanse_zod_zmb";
	level._effect["ee_quest_keeper_spirit_mist"] = "zombie/fx_ee_altar_mist_zod_zmb";
	level._effect["ee_quest_powerbox"] = "zombie/fx_bmode_dest_pwrbox_zod_zmb";
	level._effect["ee_superworm_death"] = "zombie/fx_ee_gateworm_lg_death_zod_zmb";
	level._effect["zombie/fx_ee_gateworm_lg_teleport_zod_zmb"] = "zombie/fx_ee_gateworm_lg_teleport_zod_zmb";
	level._effect["fx_ee_apothigod_beam_impact_zod_zmb"] = "fx_ee_apothigod_beam_impact_zod_zmb";
	level._effect["ee_totem_to_ghost"] = "zombie/fx_totem_beam_zod_zmb";
	level._effect["ee_ghost_charging"] = "zombie/fx_ee_ghost_charging_zod_zmb";
	level._effect["ee_ghost_charged"] = "zombie/fx_ee_ghost_full_charge_zod_zmb";
	level._effect["ee_quest_book_mist"] = "zombie/fx_ee_book_mist_zod_zmb";
	level._effect["zombie/fx_ee_keeper_beam_shield1_fail_zod_zmb"] = "zombie/fx_ee_keeper_beam_shield1_fail_zod_zmb";
	level._effect["zombie/fx_ee_keeper_beam_shield2_fail_zod_zmb"] = "zombie/fx_ee_keeper_beam_shield2_fail_zod_zmb";
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("world", "ee_quest_state", 1, n_bits, "int", &function_f2a0dbdc, 0, 0);
	n_bits = GetMinBitCountForNum(6);
	clientfield::register("world", "ee_totem_state", 1, n_bits, "int", undefined, 0, 0);
	n_bits = GetMinBitCountForNum(10);
	clientfield::register("world", "ee_keeper_boxer_state", 1, n_bits, "int", &function_c207ce05, 0, 0);
	clientfield::register("world", "ee_keeper_detective_state", 1, n_bits, "int", &function_2bf1935e, 0, 0);
	clientfield::register("world", "ee_keeper_femme_state", 1, n_bits, "int", &function_e0fb815d, 0, 0);
	clientfield::register("world", "ee_keeper_magician_state", 1, n_bits, "int", &function_ac2b60ba, 0, 0);
	clientfield::register("world", "ee_shadowman_battle_active", 1, 1, "int", &function_110e1004, 0, 0);
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("world", "ee_superworm_state", 1, n_bits, "int", &function_3d781ecc, 0, 0);
	clientfield::register("scriptmover", "near_apothigod_active", 1, 1, "int", &function_84bc32a6, 0, 0);
	clientfield::register("scriptmover", "far_apothigod_active", 1, 1, "int", &function_d74175b7, 0, 0);
	clientfield::register("scriptmover", "near_apothigod_roar", 1, 1, "counter", &function_84bc32a6, 0, 0);
	clientfield::register("scriptmover", "far_apothigod_roar", 1, 1, "counter", &function_d74175b7, 0, 0);
	clientfield::register("scriptmover", "apothigod_death", 1, 1, "counter", &function_cb68e14b, 0, 0);
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("world", "ee_keeper_beam_state", 1, n_bits, "int", &function_b6caaa24, 0, 0);
	clientfield::register("world", "ee_final_boss_shields", 1, 1, "int", &function_ef925b15, 0, 0);
	clientfield::register("toplayer", "ee_final_boss_attack_tell", 1, 1, "int", &function_803f7789, 0, 0);
	clientfield::register("scriptmover", "ee_rail_electricity_state", 1, 1, "int", &function_c87b138e, 0, 0);
	clientfield::register("world", "sndEndIGC", 1, 1, "int", &function_92650c00, 0, 0);
}

/*
	Name: function_92650c00
	Namespace: namespace_ba13c715
	Checksum: 0x6C2C3DB1
	Offset: 0x1888
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_92650c00(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		audio::snd_set_snapshot("zmb_zod_endigc");
	}
	else
	{
		audio::snd_set_snapshot("default");
	}
}

/*
	Name: function_110e1004
	Namespace: namespace_ba13c715
	Checksum: 0xCBC2C4F5
	Offset: 0x1910
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_110e1004(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		s_loc = struct::get("defend_area_pap", "targetname");
		level.var_65b446c1 = playFX(localClientNum, level._effect["portal_shortcut_closed_base"], s_loc.origin, (0, 0, 0));
	}
	else if(isdefined(level.var_65b446c1))
	{
		stopfx(localClientNum, level.var_65b446c1);
	}
}

/*
	Name: function_f2a0dbdc
	Namespace: namespace_ba13c715
	Checksum: 0x36C60824
	Offset: 0x1A00
	Size: 0x76B
	Parameters: 7
	Flags: None
*/
function function_f2a0dbdc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal !== 3 && newVal !== 2)
	{
		return;
	}
	if(newVal == 4)
	{
		return;
	}
	function_373d3423(localClientNum);
	mdl_ritual = level.var_b3c23ec9[localClientNum]["pap"].e_assembly;
	mdl_ritual util::waittill_dobj(localClientNum);
	if(!mdl_ritual HasAnimTree())
	{
		mdl_ritual useanimtree(-1);
	}
	mdl_victim = level.var_b3c23ec9[localClientNum]["pap"].e_victim;
	if(!mdl_victim HasAnimTree())
	{
		mdl_victim useanimtree(-1);
	}
	mdl_ritual show();
	mdl_victim show();
	for(i = 0; i < 4; i++)
	{
		mdl_ritual.vfx_trails[i] = PlayFXOnTag(localClientNum, level._effect["ritual_trail"], mdl_ritual, "key_pcs0" + i + 1 + "_jnt");
	}
	level thread namespace_1f61c67f::sndritual(2, mdl_ritual);
	level thread exploder::exploder("ritual_light_pap");
	playsound(0, "zmb_zod_shadfight_ending", (0, 0, 0));
	namespace_1f61c67f::toggle_altar_vfx(localClientNum, "pap", 1);
	mdl_victim thread animation::Play("ai_zombie_zod_shadowman_captured_intro");
	mdl_ritual animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_start_anim");
	mdl_victim ClearAnim("ai_zombie_zod_shadowman_captured_intro", 0);
	mdl_victim thread animation::Play("ai_zombie_zod_shadowman_captured_loop");
	mdl_ritual ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_start_anim", 0);
	mdl_ritual thread animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim");
	wait(1.5);
	mdl_victim playsound(0, "zmb_shadowman_die");
	mdl_victim ClearAnim("ai_zombie_zod_shadowman_captured_loop", 0);
	mdl_victim thread animation::Play("ai_zombie_zod_shadowman_captured_outro");
	mdl_ritual ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0);
	mdl_ritual thread animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim");
	wait(1.5);
	mdl_victim = level.var_b3c23ec9[localClientNum]["pap"].e_victim;
	mdl_victim.vfx_chest = PlayFXOnTag(localClientNum, level._effect["ritual_glow_chest"], mdl_victim, "j_spineupper");
	mdl_victim.vfx_head = PlayFXOnTag(localClientNum, level._effect["ritual_glow_head"], mdl_victim, "tag_eye");
	mdl_ritual ClearAnim("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0);
	if(isdefined(mdl_ritual.vfx_trails))
	{
		foreach(var_2d3cc156 in mdl_ritual.vfx_trails)
		{
			stopfx(localClientNum, var_2d3cc156);
		}
	}
	level thread namespace_1f61c67f::key_combines_notetrack_watcher(localClientNum, mdl_ritual, undefined, mdl_victim, "pap");
	if(newVal == 3)
	{
		level thread function_cf8ff04b(localClientNum);
		break;
	}
	if(newVal == 2)
	{
		for(i = 1; i <= 4; i++)
		{
			s_keeper = function_e1e53e16(localClientNum, i);
			s_keeper.model util::waittill_dobj(localClientNum);
			v_fwd = AnglesToForward(s_keeper.model.angles);
			level thread function_705b696b(localClientNum, level._effect["keeper_spawn"], s_keeper.model.origin, v_fwd, 2);
			s_keeper.model Hide();
		}
	}
	mdl_ritual animation::Play("p7_fxanim_zm_zod_redemption_key_ritual_end_anim");
	mdl_ritual Hide();
	s_loc = struct::get("defend_area_pap", "targetname");
	if(isdefined(s_loc.var_dda4503d))
	{
		stopfx(localClientNum, s_loc.var_dda4503d);
	}
}

/*
	Name: function_705b696b
	Namespace: namespace_ba13c715
	Checksum: 0x6DD815A
	Offset: 0x2178
	Size: 0x7B
	Parameters: 5
	Flags: None
*/
function function_705b696b(localClientNum, str_fx, v_origin, v_fwd, n_seconds)
{
	fx_id = playFX(localClientNum, str_fx, v_origin, v_fwd);
	wait(n_seconds);
	stopfx(localClientNum, fx_id);
}

/*
	Name: function_cf8ff04b
	Namespace: namespace_ba13c715
	Checksum: 0x30A76634
	Offset: 0x2200
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_cf8ff04b(localClientNum)
{
	flag::wait_till("set_ritual_finished_flag");
	function_3d781ecc(localClientNum, undefined, 1);
}

/*
	Name: function_373d3423
	Namespace: namespace_ba13c715
	Checksum: 0xA9C07A96
	Offset: 0x2250
	Size: 0x2D3
	Parameters: 1
	Flags: None
*/
function function_373d3423(localClientNum)
{
	s_position = struct::get("defend_area_pap", "targetname");
	level.var_b3c23ec9[localClientNum]["pap"] = s_position;
	level.var_b3c23ec9[localClientNum]["pap"].e_assembly = spawn(localClientNum, s_position.origin, "script_model");
	level.var_b3c23ec9[localClientNum]["pap"].e_assembly.angles = s_position.angles;
	level.var_b3c23ec9[localClientNum]["pap"].e_assembly SetModel("p7_fxanim_zm_zod_redemption_key_ritual_mod");
	level.var_b3c23ec9[localClientNum]["pap"].e_assembly.vfx_trails = [];
	v_tag_origin = level.var_b3c23ec9[localClientNum]["pap"].e_assembly GetTagOrigin("tag_char_jnt");
	v_tag_angles = level.var_b3c23ec9[localClientNum]["pap"].e_assembly GetTagAngles("tag_char_jnt");
	level.var_b3c23ec9[localClientNum]["pap"].e_victim = spawn(localClientNum, v_tag_origin, "script_model");
	level.var_b3c23ec9[localClientNum]["pap"].e_victim SetModel("c_zom_zod_shadowman_tentacles_fb");
	var_dd690641 = struct::get("shadowman_death_loc", "targetname");
	level.var_b3c23ec9[localClientNum]["pap"].e_victim.origin = var_dd690641.origin;
	level.var_b3c23ec9[localClientNum]["pap"].e_victim.angles = v_tag_angles;
}

/*
	Name: function_c207ce05
	Namespace: namespace_ba13c715
	Checksum: 0x6FDDC0B1
	Offset: 0x2530
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_c207ce05(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_a39c9866(localClientNum, newVal, oldVal, 1);
}

/*
	Name: function_2bf1935e
	Namespace: namespace_ba13c715
	Checksum: 0x1CEF5D46
	Offset: 0x2598
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_2bf1935e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_a39c9866(localClientNum, newVal, oldVal, 2);
}

/*
	Name: function_e0fb815d
	Namespace: namespace_ba13c715
	Checksum: 0x1CED8764
	Offset: 0x2600
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_e0fb815d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_a39c9866(localClientNum, newVal, oldVal, 3);
}

/*
	Name: function_ac2b60ba
	Namespace: namespace_ba13c715
	Checksum: 0xAA20489A
	Offset: 0x2668
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_ac2b60ba(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_a39c9866(localClientNum, newVal, oldVal, 4);
}

/*
	Name: function_a39c9866
	Namespace: namespace_ba13c715
	Checksum: 0x5F243027
	Offset: 0x26D0
	Size: 0x12B5
	Parameters: 4
	Flags: None
*/
function function_a39c9866(localClientNum, var_fe2fb4b9, var_f471914b, n_character_index)
{
	s_keeper = function_e1e53e16(localClientNum, n_character_index);
	mdl_target = function_2c557738(localClientNum, n_character_index);
	function_4d0c8ca8(s_keeper, var_fe2fb4b9, n_character_index);
	s_keeper.model util::waittill_dobj(localClientNum);
	if(!s_keeper.model HasAnimTree())
	{
		s_keeper.model useanimtree(-1);
	}
	if(isdefined(s_keeper.model.sndloop))
	{
		s_keeper.model StopLoopSound(s_keeper.model.sndloop, 2);
		s_keeper.model.sndloop = undefined;
	}
	switch(var_fe2fb4b9)
	{
		case 0:
		{
			s_keeper.model Hide();
			break;
		}
		case 1:
		{
			s_keeper.model show();
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_give_egg_intro", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_give_egg_loop", 0);
			s_keeper.var_c8ca4ded = playFX(localClientNum, level._effect["ee_quest_keeper_spirit_mist"], s_keeper.model.origin, s_keeper.model.angles);
			s_keeper.model.sndloop = s_keeper.model PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			s_keeper.model playsound(0, "zmb_ee_keeper_ghost_appear");
			s_keeper.model animation::Play("ai_zombie_zod_keeper_idle", undefined, undefined, 1);
			break;
		}
		case 2:
		{
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_idle", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_give_egg_intro", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_give_egg_loop", 0);
			s_keeper.model.sndloop = s_keeper.model PlayLoopSound("zmb_zod_totem_resurrecting_lp", 2);
			s_keeper.mdl_totem show();
			s_keeper.var_b0ff8d18 = PlayFXOnTag(localClientNum, level._effect["ee_totem_to_ghost"], s_keeper.mdl_totem, "j_head");
			s_keeper.var_a0b06f1c = PlayFXOnTag(localClientNum, level._effect["ee_ghost_charging"], s_keeper.model, "tag_origin");
			s_keeper.model animation::Play("ai_zombie_zod_keeper_give_egg_outro", undefined, undefined, 1);
			break;
		}
		case 3:
		{
			if(isdefined(s_keeper.var_b0ff8d18))
			{
				stopfx(localClientNum, s_keeper.var_b0ff8d18);
			}
			if(isdefined(s_keeper.var_a0b06f1c))
			{
				stopfx(localClientNum, s_keeper.var_a0b06f1c);
			}
			PlayFXOnTag(localClientNum, level._effect["ee_ghost_charged"], s_keeper.model, "tag_origin");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_give_egg_outro", 0);
			s_keeper.model zm_zod::function_b48f294(localClientNum, 1, 0);
			s_keeper.model namespace_1f61c67f::function_4b50c64(localClientNum, 0, 1);
			if(isdefined(s_keeper.var_c8ca4ded))
			{
				stopfx(localClientNum, s_keeper.var_c8ca4ded);
			}
			s_keeper.model playsound(0, "zmb_ee_keeper_resurrect");
			wait(3);
			s_keeper.var_f87c0436 = PlayFXOnTag(localClientNum, level._effect["keeper_spawn"], s_keeper.model, "tag_origin");
			s_keeper.var_6b0fc6a1 = PlayFXOnTag(localClientNum, level._effect["keeper_spawn"], s_keeper.mdl_totem, "tag_origin");
			s_keeper.model playsound(0, "evt_keeper_portal_end");
			s_keeper.mdl_totem playsound(0, "evt_keeper_portal_end");
			wait(1);
			s_keeper.model Hide();
			s_keeper.mdl_totem Hide();
			stopfx(localClientNum, s_keeper.var_f87c0436);
			stopfx(localClientNum, s_keeper.var_6b0fc6a1);
			str_targetname = "ee_keeper_8_" + n_character_index - 1;
			s_loc = struct::get(str_targetname, "targetname");
			s_keeper.model.origin = s_loc.origin;
			s_keeper.model.angles = s_loc.angles + VectorScale((0, 1, 0), 180);
			s_keeper.model show();
			s_keeper.model animation::Play("ai_zombie_zod_keeper_sword_quest_intro_idle", undefined, undefined, 1, 0, 0);
			break;
		}
		case 4:
		{
			function_6f29ee45(s_keeper);
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_intro_idle", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_injured_idle", 0);
			s_keeper.model.sndloop = s_keeper.model PlayLoopSound("zmb_zod_shadfight_keeper_up_lp", 2);
			s_loc = struct::get("defend_area_pap", "targetname");
			if(!isdefined(s_loc.var_dda4503d))
			{
				v_fwd = AnglesToForward(s_loc.angles);
				s_loc.var_dda4503d = playFX(localClientNum, level._effect["portal_shortcut_closed_base"], s_loc.origin, v_fwd);
			}
			str_targetname = "ee_keeper_8_" + n_character_index - 1;
			s_loc = struct::get(str_targetname, "targetname");
			if(var_f471914b === 6)
			{
				s_keeper.model playsound(0, "zmb_zod_shadfight_keeper_up");
				s_keeper.model.angles = s_loc.angles;
				s_keeper.model namespace_1f61c67f::function_4b50c64(localClientNum, 0, 1);
				s_keeper.model function_267f859f(localClientNum, level._effect["curse_tell"], 0, 1, "tag_origin");
				s_keeper.model animation::Play("ai_zombie_zod_keeper_sword_quest_revived", undefined, undefined, 1, 0, 0);
				s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_ready_idle", 1);
			}
			else
			{
				s_keeper.model.angles = s_loc.angles + VectorScale((0, 1, 0), 180);
				s_keeper.model animation::Play("ai_zombie_zod_keeper_sword_quest_take_sword", undefined, undefined, 1, 0, 0);
				s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_ready_idle", 1);
			}
			break;
		}
		case 5:
		{
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_revived", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_take_sword", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_ready_idle", 0);
			s_keeper.model playsound(0, "zmb_zod_shadfight_keeper_attack");
			s_keeper.model function_267f859f(localClientNum, level._effect["curse_tell"], 0, 1, "tag_origin");
			s_keeper.model animation::Play("ai_zombie_zod_keeper_sword_quest_attack_intro", undefined, undefined, 1, 0, 0);
			s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_attack_idle", 1);
			s_keeper function_a48022e(localClientNum, 1, n_character_index);
			wait(3);
			s_keeper function_a48022e(localClientNum, 0, n_character_index);
			break;
		}
		case 6:
		{
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_attack_intro", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_attack_idle", 0);
			s_keeper.model.sndloop = s_keeper.model PlayLoopSound("zmb_zod_shadfight_keeper_down_lp", 2);
			s_keeper.model playsound(0, "zmb_zod_shadfight_keeper_down");
			s_keeper.model namespace_1f61c67f::function_4b50c64(localClientNum, 1, 0);
			s_keeper.model function_267f859f(localClientNum, level._effect["curse_tell"], 1, 1, "tag_origin");
			s_keeper.model animation::Play("ai_zombie_zod_keeper_sword_quest_injured_intro", undefined, undefined, 1, 0, 0);
			s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_injured_idle", 1);
			break;
		}
		case 7:
		{
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_attack_intro", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_attack_idle", 0);
			str_targetname = "ee_apothigod_keeper_" + n_character_index - 1;
			s_loc = struct::get(str_targetname, "targetname");
			s_keeper.model.origin = s_loc.origin;
			s_keeper.model.angles = s_loc.angles;
			s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_ready_idle", 1);
			break;
		}
		case 8:
		{
			function_6f29ee45(s_keeper);
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_attack_intro", 0);
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_attack_idle", 0);
			str_targetname = "ee_apothigod_keeper_" + n_character_index - 1;
			s_loc = struct::get(str_targetname, "targetname");
			s_keeper.model.origin = s_loc.origin;
			s_keeper.model.angles = s_loc.angles;
			s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_ready_idle", 1);
			break;
		}
		case 9:
		{
			s_keeper.model notify("hash_274ba0e6");
			s_keeper.model ClearAnim("ai_zombie_zod_keeper_sword_quest_ready_idle", 0);
			s_keeper.model animation::Play("ai_zombie_zod_keeper_sword_quest_attack_intro", undefined, undefined, 1, 0, 0);
			s_keeper.model thread function_274ba0e6("ai_zombie_zod_keeper_sword_quest_attack_idle", 1);
			break;
		}
	}
}

/*
	Name: function_a48022e
	Namespace: namespace_ba13c715
	Checksum: 0x74B28FC4
	Offset: 0x3990
	Size: 0x143
	Parameters: 3
	Flags: None
*/
function function_a48022e(localClientNum, b_on, n_character_index)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	if(n_character_index == 1 || n_character_index == 4)
	{
		str_beam = level._effect["zombie/fx_ee_keeper_beam_shield1_fail_zod_zmb"];
	}
	else
	{
		str_beam = level._effect["zombie/fx_ee_keeper_beam_shield2_fail_zod_zmb"];
	}
	if(b_on)
	{
		s_loc = struct::get("keeper_vs_shadowman_beam_" + n_character_index);
		v_fwd = AnglesToForward(s_loc.angles);
		v_origin = s_loc.origin;
		self.var_f5366edb = playFX(localClientNum, str_beam, v_origin, v_fwd);
	}
	else
	{
		stopfx(localClientNum, self.var_f5366edb);
	}
}

/*
	Name: function_6f29ee45
	Namespace: namespace_ba13c715
	Checksum: 0x38EA5CBB
	Offset: 0x3AE0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_6f29ee45(s_keeper)
{
	if(s_keeper.model IsAttached("wpn_t7_zmb_zod_sword2_world", "tag_weapon_right"))
	{
		return;
	}
	s_keeper.model Attach("wpn_t7_zmb_zod_sword2_world", "tag_weapon_right");
}

/*
	Name: function_4d0c8ca8
	Namespace: namespace_ba13c715
	Checksum: 0xACD25163
	Offset: 0x3B58
	Size: 0x18B
	Parameters: 3
	Flags: None
*/
function function_4d0c8ca8(s_keeper, var_fe2fb4b9, n_character_index)
{
	if(var_fe2fb4b9 < 4)
	{
		var_64c74a6d = 0;
	}
	else if(var_fe2fb4b9 < 8)
	{
		var_64c74a6d = 1;
	}
	else
	{
		var_64c74a6d = 2;
	}
	if(s_keeper.var_64c74a6d === var_64c74a6d)
	{
		return;
	}
	switch(var_64c74a6d)
	{
		case 0:
		{
			str_targetname = "keeper_spirit_" + n_character_index - 1;
			break;
		}
		case 1:
		{
			str_targetname = "ee_keeper_8_" + n_character_index - 1;
			break;
		}
		case 2:
		{
			str_targetname = "ee_apothigod_keeper_" + n_character_index - 1;
			break;
		}
	}
	s_loc = struct::get(str_targetname, "targetname");
	s_keeper.model.origin = s_loc.origin;
	s_keeper.model.angles = s_loc.angles;
	s_keeper.var_64c74a6d = var_64c74a6d;
}

/*
	Name: function_e1e53e16
	Namespace: namespace_ba13c715
	Checksum: 0x79C34E13
	Offset: 0x3CF0
	Size: 0x247
	Parameters: 2
	Flags: None
*/
function function_e1e53e16(localClientNum, n_character_index)
{
	function_1461c206(localClientNum, n_character_index);
	s_loc = struct::get("keeper_spirit_" + n_character_index - 1, "targetname");
	s_keeper = level.ee_quest[localClientNum][n_character_index];
	if(!isdefined(s_keeper.model))
	{
		s_keeper.model = spawn(localClientNum, s_loc.origin, "script_model");
		s_keeper.model.angles = s_loc.angles;
		s_keeper.var_64c74a6d = 0;
		s_keeper.model SetModel("c_zom_zod_keeper_fb");
		s_keeper.model zm_zod::function_b48f294(localClientNum, 0, 1);
	}
	if(!isdefined(s_keeper.mdl_totem))
	{
		var_f4fc4f28 = struct::get("keeper_resurrection_totem_" + n_character_index - 1, "targetname");
		s_keeper.mdl_totem = spawn(localClientNum, var_f4fc4f28.origin, "script_model");
		s_keeper.mdl_totem.angles = var_f4fc4f28.angles;
		s_keeper.mdl_totem SetModel("t7_zm_zod_keepers_totem");
		s_keeper.mdl_totem Hide();
	}
	return s_keeper;
}

/*
	Name: function_2c557738
	Namespace: namespace_ba13c715
	Checksum: 0xC05A3FA9
	Offset: 0x3F40
	Size: 0x111
	Parameters: 2
	Flags: None
*/
function function_2c557738(localClientNum, n_character_index)
{
	function_1461c206(localClientNum, n_character_index);
	s_keeper = level.ee_quest[localClientNum][n_character_index];
	if(isdefined(s_keeper.var_f929ecf4))
	{
		return s_keeper.var_f929ecf4;
	}
	s_target = struct::get("ee_shadowman_beam_" + n_character_index, "targetname");
	s_keeper.var_f929ecf4 = spawn(localClientNum, s_target.origin, "script_model");
	s_keeper.var_f929ecf4 SetModel("tag_origin");
	return s_keeper.var_f929ecf4;
}

/*
	Name: function_27e2b2cc
	Namespace: namespace_ba13c715
	Checksum: 0x6ADBA04
	Offset: 0x4060
	Size: 0x21B
	Parameters: 1
	Flags: None
*/
function function_27e2b2cc(localClientNum)
{
	if(!isdefined(level.var_a9f994a9))
	{
		level.var_a9f994a9 = spawnstruct();
	}
	if(!isdefined(level.var_a9f994a9.mdl_reveal))
	{
		s_loc = struct::get("ee_apothigod_gateworm_reveal", "targetname");
		level.var_a9f994a9.mdl_reveal = spawn(localClientNum, s_loc.origin, "script_model");
		level.var_a9f994a9.mdl_reveal.angles = s_loc.angles;
		level.var_a9f994a9.mdl_reveal SetModel("p7_zm_zod_gateworm_large");
		level.var_a9f994a9.mdl_reveal useanimtree(-1);
	}
	if(!isdefined(level.var_a9f994a9.mdl_junction))
	{
		s_loc = struct::get("ee_apothigod_gateworm_junction", "targetname");
		level.var_a9f994a9.mdl_junction = spawn(localClientNum, s_loc.origin, "script_model");
		level.var_a9f994a9.mdl_junction.angles = s_loc.angles;
		level.var_a9f994a9.mdl_junction SetModel("p7_zm_zod_gateworm_large");
		level.var_a9f994a9.mdl_reveal useanimtree(-1);
	}
}

/*
	Name: function_3d781ecc
	Namespace: namespace_ba13c715
	Checksum: 0xE75F4482
	Offset: 0x4288
	Size: 0x535
	Parameters: 7
	Flags: None
*/
function function_3d781ecc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 4)
	{
		return;
	}
	function_27e2b2cc(localClientNum);
	level.var_a9f994a9.mdl_reveal util::waittill_dobj(localClientNum);
	if(!level.var_a9f994a9.mdl_reveal HasAnimTree())
	{
		level.var_a9f994a9.mdl_reveal useanimtree(-1);
	}
	level.var_a9f994a9.mdl_junction util::waittill_dobj(localClientNum);
	if(!level.var_a9f994a9.mdl_junction HasAnimTree())
	{
		level.var_a9f994a9.mdl_junction useanimtree(-1);
	}
	switch(newVal)
	{
		case 0:
		{
			level.var_a9f994a9.mdl_reveal Hide();
			level.var_a9f994a9.mdl_junction Hide();
			break;
		}
		case 1:
		{
			level.var_a9f994a9.mdl_reveal show();
			level.var_a9f994a9.mdl_junction Hide();
			level.var_a9f994a9.mdl_reveal function_bdd91321(localClientNum, 0, 0);
			level.var_a9f994a9.mdl_reveal thread animation::Play("ai_zombie_zod_gateworm_large_idle_loop_active", undefined, undefined, 1);
			wait(5);
			level.var_a9f994a9.mdl_reveal Hide();
			level.var_a9f994a9.mdl_reveal function_bdd91321(localClientNum, 0, 0);
			level.var_a9f994a9.mdl_junction show();
			level.var_a9f994a9.mdl_junction function_bdd91321(localClientNum, 1, 0);
			break;
		}
		case 2:
		{
			level.var_a9f994a9.mdl_reveal Hide();
			level.var_a9f994a9.mdl_junction show();
			level.var_a9f994a9.mdl_junction function_bdd91321(localClientNum, 1, 1);
			level.var_a9f994a9.mdl_junction Hide();
			break;
		}
		case 3:
		{
			level.var_a9f994a9.mdl_reveal Hide();
			level.var_a9f994a9.mdl_junction show();
			level.var_a9f994a9.mdl_junction function_bdd91321(localClientNum, 0, 0);
			level.var_a9f994a9.mdl_junction ClearAnim("ai_zombie_zod_gateworm_large_idle_loop_active", 0);
			level.var_a9f994a9.mdl_junction thread animation::Play("ai_zombie_zod_gateworm_large_idle_loop", undefined, undefined, 1);
			break;
		}
		case 4:
		{
			level.var_a9f994a9.mdl_reveal Hide();
			level.var_a9f994a9.mdl_junction show();
			level.var_a9f994a9.mdl_junction function_bdd91321(localClientNum, 0, 0);
			level.var_a9f994a9.mdl_junction ClearAnim("ai_zombie_zod_gateworm_large_idle_loop", 0);
			level.var_a9f994a9.mdl_junction thread animation::Play("ai_zombie_zod_gateworm_large_idle_loop_active", undefined, undefined, 1);
			break;
		}
	}
}

/*
	Name: function_bdd91321
	Namespace: namespace_ba13c715
	Checksum: 0xBDD8746
	Offset: 0x47C8
	Size: 0x313
	Parameters: 3
	Flags: None
*/
function function_bdd91321(localClientNum, b_hide, b_smashed)
{
	if(!isdefined(b_smashed))
	{
		b_smashed = 0;
	}
	if(b_hide)
	{
		if(isdefined(self.sndlooper))
		{
			self StopLoopSound(self.sndlooper, 1);
			self.sndlooper = undefined;
		}
		if(b_smashed)
		{
			v_origin_1 = self GetTagOrigin("j_spine_1_anim");
			v_origin_2 = self GetTagOrigin("j_spine_4_anim");
			var_38050c98 = self GetTagOrigin("j_upper_jaw_1_anim");
			playFX(localClientNum, level._effect["ee_superworm_death"], v_origin_1);
			playFX(localClientNum, level._effect["ee_superworm_death"], v_origin_2);
			playFX(localClientNum, level._effect["ee_superworm_death"], var_38050c98);
			self playsound(0, "zmb_zod_superworm_smash");
		}
		else
		{
			v_origin = self GetTagOrigin("j_spine_6_anim");
			v_angles = self GetTagAngles("j_spine_6_anim");
			playFX(localClientNum, level._effect["zombie/fx_ee_gateworm_lg_teleport_zod_zmb"], v_origin, v_angles);
			self playsound(0, "zmb_zod_superworm_warpout");
		}
	}
	else
	{
		v_origin = self GetTagOrigin("j_spine_6_anim");
		v_angles = self GetTagAngles("j_spine_6_anim");
		playFX(localClientNum, level._effect["zombie/fx_ee_gateworm_lg_teleport_zod_zmb"], v_origin, v_angles);
		self playsound(0, "zmb_zod_superworm_warpin");
		if(!isdefined(self.sndlooper))
		{
			self.sndlooper = self PlayLoopSound("zmb_zod_superworm_loop", 2);
		}
	}
}

/*
	Name: function_b6caaa24
	Namespace: namespace_ba13c715
	Checksum: 0x6BEC491E
	Offset: 0x4AE8
	Size: 0x235
	Parameters: 7
	Flags: None
*/
function function_b6caaa24(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_4c0f7435))
	{
		var_7cb357a4 = struct::get("ee_apothigod_beam_unite", "targetname");
		level.var_4c0f7435 = spawn(localClientNum, var_7cb357a4.origin, "script_model");
		level.var_4c0f7435 SetModel("tag_origin");
	}
	v_origin = level.var_4c0f7435.origin + VectorScale((0, 0, 1), 1000);
	v_angles = AnglesToForward(level.var_4c0f7435.angles);
	switch(newVal)
	{
		case 0:
		{
			exploder::stop_exploder("fx_exploder_ee_final_battle_fail");
			exploder::stop_exploder("fx_exploder_ee_final_batttle_success");
			break;
		}
		case 1:
		{
			exploder::exploder("fx_exploder_ee_final_battle_fail");
			level.var_4c0f7435 playsound(0, "zmb_zod_beam_fire_fail");
			break;
		}
		case 2:
		{
			exploder::exploder("fx_exploder_ee_final_batttle_success");
			playFX(localClientNum, level._effect["fx_ee_apothigod_beam_impact_zod_zmb"], v_origin, v_angles);
			level.var_4c0f7435 playsound(0, "zmb_zod_beam_fire_success");
			break;
		}
	}
}

/*
	Name: function_ef925b15
	Namespace: namespace_ba13c715
	Checksum: 0x62B5CD0E
	Offset: 0x4D28
	Size: 0x161
	Parameters: 7
	Flags: None
*/
function function_ef925b15(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_dcd4f61a = struct::get_array("final_boss_safepoint", "targetname");
	foreach(var_495730fe in var_dcd4f61a)
	{
		var_495730fe function_267f859f(localClientNum, level._effect["player_cleanse"], newVal, 0);
		if(newVal)
		{
			audio::playloopat("zmb_zod_player_cleanse_point", var_495730fe.origin);
			continue;
		}
		audio::stoploopat("zmb_zod_player_cleanse_point", var_495730fe.origin);
	}
}

/*
	Name: function_803f7789
	Namespace: namespace_ba13c715
	Checksum: 0xEC248245
	Offset: 0x4E98
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function function_803f7789(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread postfx::playPostfxBundle("pstfx_ring_loop_purple");
		self playsound(0, "zmb_zod_player_cursed");
		if(!isdefined(self.var_379c83c))
		{
			self.var_379c83c = self PlayLoopSound("zmb_zod_player_cursed_lp", 2);
		}
	}
	else
	{
		self postfx::exitPostfxBundle();
		self thread postfx::playPostfxBundle("pstfx_ring_loop_white");
		self playsound(0, "zmb_zod_player_cleansed");
		if(isdefined(self.var_379c83c))
		{
			self StopLoopSound(self.var_379c83c, 0.5);
			self.var_379c83c = undefined;
		}
		wait(0.25);
		self postfx::exitPostfxBundle();
	}
	self function_267f859f(localClientNum, level._effect["curse_tell"], newVal, 1, "tag_origin");
}

/*
	Name: function_c87b138e
	Namespace: namespace_ba13c715
	Checksum: 0xC1A52EFC
	Offset: 0x5048
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_c87b138e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_267f859f(localClientNum, level._effect["ee_quest_powerbox"], newVal, 1, "tag_origin");
	if(newVal == 1)
	{
		self playsound(0, "zmb_zod_rail_powerup");
	}
}

/*
	Name: function_1461c206
	Namespace: namespace_ba13c715
	Checksum: 0x2D3D1E37
	Offset: 0x50F0
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function function_1461c206(localClientNum, n_character_index)
{
	if(!isdefined(level.ee_quest))
	{
		level.ee_quest = [];
	}
	if(!isdefined(level.ee_quest[localClientNum]))
	{
		level.ee_quest[localClientNum] = [];
	}
	if(!isdefined(level.ee_quest[localClientNum][n_character_index]))
	{
		level.ee_quest[localClientNum][n_character_index] = spawnstruct();
	}
}

/*
	Name: function_274ba0e6
	Namespace: namespace_ba13c715
	Checksum: 0x81AA5B4C
	Offset: 0x5188
	Size: 0x77
	Parameters: 2
	Flags: None
*/
function function_274ba0e6(str_animname, var_e3c27047)
{
	self notify("hash_274ba0e6");
	self endon("hash_274ba0e6");
	if(!isdefined(var_e3c27047))
	{
		var_e3c27047 = 1;
	}
	while(1)
	{
		self animation::Play(str_animname, undefined, undefined, var_e3c27047, 0, 0);
	}
}

/*
	Name: function_267f859f
	Namespace: namespace_ba13c715
	Checksum: 0x1186DD63
	Offset: 0x5208
	Size: 0x18D
	Parameters: 5
	Flags: None
*/
function function_267f859f(localClientNum, fx_id, b_on, b_is_ent, str_tag)
{
	if(!isdefined(fx_id))
	{
		fx_id = undefined;
	}
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	if(!isdefined(b_is_ent))
	{
		b_is_ent = 0;
	}
	if(!isdefined(str_tag))
	{
		str_tag = "tag_origin";
	}
	if(b_on)
	{
		if(isdefined(self.vfx_ref))
		{
			stopfx(localClientNum, self.vfx_ref);
		}
		if(b_is_ent)
		{
			self.vfx_ref = PlayFXOnTag(localClientNum, fx_id, self, str_tag);
		}
		else if(self.angles === (0, 0, 0))
		{
			self.vfx_ref = playFX(localClientNum, fx_id, self.origin);
		}
		else
		{
			self.vfx_ref = playFX(localClientNum, fx_id, self.origin, self.angles);
		}
	}
	else if(isdefined(self.vfx_ref))
	{
		stopfx(localClientNum, self.vfx_ref);
		self.vfx_ref = undefined;
	}
}

/*
	Name: function_84bc32a6
	Namespace: namespace_ba13c715
	Checksum: 0x53CB2FE4
	Offset: 0x53A0
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function function_84bc32a6()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_d74175b7
	Namespace: namespace_ba13c715
	Checksum: 0x768A8B63
	Offset: 0x5440
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function function_d74175b7()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_ac5a5835
	Namespace: namespace_ba13c715
	Checksum: 0x368CDF31
	Offset: 0x54E0
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function function_ac5a5835()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_b2428d44
	Namespace: namespace_ba13c715
	Checksum: 0x76BB163B
	Offset: 0x5540
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function function_b2428d44()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_cb68e14b
	Namespace: namespace_ba13c715
	Checksum: 0x81DA6929
	Offset: 0x55A0
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function function_cb68e14b()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

#namespace capothigod;

/*
	Name: init
	Namespace: capothigod
	Checksum: 0x8C5E4990
	Offset: 0x5600
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function init(localClientNum, mdl_god, b_is_overhead)
{
	self.var_dbea7369 = mdl_god;
	self.var_8d207f9b = b_is_overhead;
	self.var_dbea7369 util::waittill_dobj(localClientNum);
	self.var_dbea7369 useanimtree(-1);
	self.var_dbea7369 SetAnim("p7_fxanim_zm_zod_apothicons_god_mouth_idle_anim", 1, 0, 1);
}

/*
	Name: function_9e0e6936
	Namespace: capothigod
	Checksum: 0x3F7C6A0F
	Offset: 0x56A8
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_9e0e6936()
{
	return self.var_8d207f9b;
}

/*
	Name: function_465ed3ec
	Namespace: capothigod
	Checksum: 0x2F609B58
	Offset: 0x56C0
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function function_465ed3ec(localClientNum, mdl_god)
{
	level notify("hash_465ed3ec");
	level endon("hash_465ed3ec");
	while(1)
	{
		self thread function_2de612ff(localClientNum, mdl_god);
		var_7397ca31 = randomIntRange(15, 60);
		wait(var_7397ca31);
	}
}

/*
	Name: function_2de612ff
	Namespace: capothigod
	Checksum: 0x641658DF
	Offset: 0x5750
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function function_2de612ff(localClientNum, mdl_god)
{
	if(!isdefined(mdl_god))
	{
		return;
	}
	self.var_dbea7369 util::waittill_dobj(localClientNum);
	mdl_god SetAnim(self.var_a9547cdf, 1, 0, 1);
	n_animlength = getanimlength("p7_fxanim_zm_zod_apothicons_god_mouth_roar_anim");
	mdl_god SetAnim("p7_fxanim_zm_zod_apothicons_god_mouth_roar_anim", 1, 0, 1);
	wait(n_animlength);
	mdl_god SetAnim("p7_fxanim_zm_zod_apothicons_god_mouth_idle_anim", 1, 0, 1);
	mdl_god SetAnim(self.var_a9547cdf, 1, 0, 1);
}

/*
	Name: function_839ff35f
	Namespace: capothigod
	Checksum: 0x309F06B9
	Offset: 0x5860
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function function_839ff35f(localClientNum, mdl_god)
{
	if(!isdefined(mdl_god))
	{
		return;
	}
	self.var_dbea7369 util::waittill_dobj(localClientNum);
	mdl_god SetAnim("p7_fxanim_zm_zod_apothicons_god_mouth_death_anim", 1, 0, 1);
	n_animlength = getanimlength("p7_fxanim_zm_zod_apothicons_god_body_death_anim");
	mdl_god SetAnim("p7_fxanim_zm_zod_apothicons_god_body_death_anim", 1, 0, 1);
	wait(n_animlength);
}

/*
	Name: function_66844d0d
	Namespace: capothigod
	Checksum: 0x79C68E9
	Offset: 0x5920
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function function_66844d0d(localClientNum, b_active)
{
	self.var_3b3701c9 = b_active;
	if(!self.var_3b3701c9)
	{
		self.var_dbea7369 StopLoopSound(3);
	}
	else if(!self.var_8d207f9b)
	{
		self.var_a9547cdf = "p7_fxanim_zm_zod_apothicons_god_loop_anim";
		self.var_dbea7369 SetAnim("p7_fxanim_zm_zod_apothicons_god_loop_anim", 1, 0, 1);
		self.var_dbea7369 playsound(localClientNum, "zmb_zod_apothigod_vox_spawn");
	}
	else
	{
		level notify("hash_465ed3ec");
		self.var_a9547cdf = "p7_fxanim_zm_zod_apothicons_god_body_idle_anim";
		self.var_dbea7369 SetAnim(self.var_a9547cdf, 1, 0, 1);
		self.var_dbea7369 PlayLoopSound("zmb_zod_apothigod_vox_lookat_lp", 12);
	}
}

/*
	Name: __constructor
	Namespace: capothigod
	Checksum: 0x99EC1590
	Offset: 0x5A58
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: capothigod
	Checksum: 0x99EC1590
	Offset: 0x5A68
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace namespace_ba13c715;

/*
	Name: capothigod
	Namespace: namespace_ba13c715
	Checksum: 0xB26A5476
	Offset: 0x5A78
	Size: 0x1A5
	Parameters: 0
	Flags: 6
*/
function private autoexec capothigod()
{
	classes.capothigod[0] = spawnstruct();
	classes.capothigod[0].__vtable[1606033458] = &capothigod::__destructor;
	classes.capothigod[0].__vtable[-1690805083] = &capothigod::__constructor;
	classes.capothigod[0].__vtable[1719946509] = &capothigod::function_66844d0d;
	classes.capothigod[0].__vtable[-2086669473] = &capothigod::function_839ff35f;
	classes.capothigod[0].__vtable[770052863] = &capothigod::function_2de612ff;
	classes.capothigod[0].__vtable[1180619756] = &capothigod::function_465ed3ec;
	classes.capothigod[0].__vtable[-1643222730] = &capothigod::function_9e0e6936;
	classes.capothigod[0].__vtable[-1017222485] = &capothigod::init;
}

