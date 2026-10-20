#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_zod_sword;

/*
	Name: __init__sytem__
	Namespace: zm_zod_sword
	Checksum: 0x73194443
	Offset: 0x890
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_sword", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_sword
	Checksum: 0x2AC8D5EE
	Offset: 0x8D0
	Size: 0x661
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["egg_glow"] = "zombie/fx_egg_ready_zod_zmb";
	level._effect["blood_soul"] = "zombie/fx_trail_blood_soul_zmb";
	level._effect["sword_quest_ground_glow_white"] = "zombie/fx_sword_quest_egg_ground_whitepedestal_zod_zmb";
	level._effect["sword_quest_ground_fire_white"] = "zombie/fx_sword_quest_egg_ground_whitefire_zod_zmb";
	level._effect["sword_quest_sword_glow"] = "zombie/fx_sword_quest_glow_zod_zmb";
	clientfield::register("scriptmover", "zod_egg_glow", 1, 1, "int", &sword_egg_glow, 0, 0);
	clientfield::register("scriptmover", "zod_egg_soul", 1, 1, "int", &blood_soul_fx, 0, 0);
	clientfield::register("scriptmover", "sword_statue_glow", 1, 1, "int", &sword_statue_glow, 0, 0);
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("toplayer", "magic_circle_state_0", 1, n_bits, "int", &function_528aad40, 0, 1);
	clientfield::register("toplayer", "magic_circle_state_1", 1, n_bits, "int", &function_1d308217, 0, 1);
	clientfield::register("toplayer", "magic_circle_state_2", 1, n_bits, "int", &function_b17464d4, 0, 1);
	clientfield::register("toplayer", "magic_circle_state_3", 1, n_bits, "int", &function_b6499939, 0, 1);
	n_bits = GetMinBitCountForNum(9);
	clientfield::register("world", "keeper_quest_state_0", 1, n_bits, "int", &function_9ba2b995, 0, 1);
	clientfield::register("world", "keeper_quest_state_1", 1, n_bits, "int", &function_fd8ec03a, 0, 1);
	clientfield::register("world", "keeper_quest_state_2", 1, n_bits, "int", &function_32002235, 0, 1);
	clientfield::register("world", "keeper_quest_state_3", 1, n_bits, "int", &function_4fd5e276, 0, 1);
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("world", "keeper_egg_location_0", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("world", "keeper_egg_location_1", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("world", "keeper_egg_location_2", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("world", "keeper_egg_location_3", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL1_SWORD_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL1_EGG_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL2_SWORD_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL2_EGG_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	level.var_e91b9e85 = [];
	level.var_e91b9e85[0] = "wpn_t7_zmb_zod_sword2_box_world";
	level.var_e91b9e85[1] = "wpn_t7_zmb_zod_sword2_det_world";
	level.var_e91b9e85[2] = "wpn_t7_zmb_zod_sword2_fem_world";
	level.var_e91b9e85[3] = "wpn_t7_zmb_zod_sword2_mag_world";
}

/*
	Name: magic_circle_state_internal
	Namespace: zm_zod_sword
	Checksum: 0x80E9111F
	Offset: 0xF40
	Size: 0x3F5
	Parameters: 3
	Flags: None
*/
function magic_circle_state_internal(localClientNum, newVal, n_current_ritual)
{
	self notify("magic_circle_state_internal" + localClientNum);
	self endon("magic_circle_state_internal" + localClientNum);
	s_ritual = function_5dab7fb(localClientNum, n_current_ritual);
	var_768e52e3 = undefined;
	var_5306b772 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(s_circle in var_5306b772)
	{
		if(s_circle.script_int === n_current_ritual)
		{
			var_768e52e3 = s_circle;
		}
	}
	if(!isdefined(s_ritual.var_e2a5419e))
	{
		s_ritual.var_e2a5419e = [];
	}
	if(!isdefined(s_ritual.var_bbf9b058))
	{
		s_ritual.var_bbf9b058 = [];
	}
	if(isdefined(s_ritual.var_e2a5419e[localClientNum]))
	{
		stopfx(localClientNum, s_ritual.var_e2a5419e[localClientNum]);
		s_ritual.var_e2a5419e[localClientNum] = undefined;
	}
	if(isdefined(s_ritual.var_bbf9b058[localClientNum]))
	{
		stopfx(localClientNum, s_ritual.var_bbf9b058[localClientNum]);
		s_ritual.var_bbf9b058[localClientNum] = undefined;
	}
	switch(newVal)
	{
		case 0:
		{
			function_cf043736(s_ritual, 0);
			break;
		}
		case 1:
		{
			s_ritual.var_e2a5419e[localClientNum] = playFX(localClientNum, level._effect["sword_quest_ground_tell"], var_768e52e3.origin);
			function_cf043736(s_ritual, 0);
			break;
		}
		case 2:
		{
			s_ritual.var_e2a5419e[localClientNum] = playFX(localClientNum, level._effect["sword_quest_ground_glow"], var_768e52e3.origin);
			function_cf043736(s_ritual, 1);
			break;
		}
		case 3:
		{
			s_ritual.var_e2a5419e[localClientNum] = playFX(localClientNum, level._effect["sword_quest_ground_glow_white"], var_768e52e3.origin);
			s_ritual.var_bbf9b058[localClientNum] = playFX(localClientNum, level._effect["sword_quest_ground_fire_white"], var_768e52e3.origin);
			function_cf043736(s_ritual, 1);
			break;
		}
	}
}

/*
	Name: function_cf043736
	Namespace: zm_zod_sword
	Checksum: 0x79CDDDDE
	Offset: 0x1340
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function function_cf043736(s_ritual, b_glowing)
{
	if(b_glowing)
	{
		s_ritual.var_55e0bdcf show();
		s_ritual.var_6a0d8b03 Hide();
	}
	else
	{
		s_ritual.var_55e0bdcf Hide();
		s_ritual.var_6a0d8b03 show();
	}
}

/*
	Name: function_4d020922
	Namespace: zm_zod_sword
	Checksum: 0x9B3A461F
	Offset: 0x13E8
	Size: 0xEA9
	Parameters: 3
	Flags: None
*/
function function_4d020922(localClientNum, newVal, n_character_index)
{
	level notify("hash_4d020922");
	level endon("hash_4d020922");
	s_ritual = function_6890ca81(localClientNum, n_character_index);
	s_ritual.e_keeper util::waittill_dobj(localClientNum);
	if(!s_ritual.e_keeper HasAnimTree())
	{
		s_ritual.e_keeper useanimtree(-1);
	}
	s_ritual.e_keeper duplicate_render::set_dr_flag("zod_ghost", 1);
	s_ritual.e_keeper duplicate_render::update_dr_filters(localClientNum);
	if(!s_ritual.e_egg HasAnimTree())
	{
		s_ritual.e_egg useanimtree(-1);
	}
	switch(newVal)
	{
		case 0:
		{
			s_ritual.e_keeper Hide();
			s_ritual.e_sword Hide();
			s_ritual.e_egg Hide();
			if(isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper StopLoopSound(s_ritual.e_keeper.sndloop, 1);
			}
			break;
		}
		case 1:
		{
			v_origin = s_ritual.e_keeper GetTagOrigin("tag_weapon_right");
			v_angles = s_ritual.e_keeper GetTagAngles("tag_weapon_right");
			s_ritual.e_egg Unlink();
			s_ritual.e_egg.origin = v_origin;
			s_ritual.e_egg.angles = v_angles;
			s_ritual.e_egg LinkTo(s_ritual.e_keeper, "tag_weapon_right");
			s_ritual.e_keeper show();
			s_ritual.e_sword Hide();
			s_ritual.e_egg show();
			level thread function_bd205438(localClientNum, s_ritual);
			s_ritual.e_keeper playsound(0, "zmb_ee_keeper_ghost_appear");
			if(!isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper.sndloop = s_ritual.e_keeper PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			s_ritual.e_keeper animation::Play("ai_zombie_zod_keeper_give_egg_intro", undefined, undefined, 1);
			s_ritual.e_keeper thread function_274ba0e6("ai_zombie_zod_keeper_give_egg_loop");
			s_ritual.e_egg thread play_fx(localClientNum, "egg_glow");
			break;
		}
		case 2:
		{
			s_ritual.e_keeper show();
			s_ritual.e_sword Hide();
			s_ritual.e_egg Hide();
			if(!isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper.sndloop = s_ritual.e_keeper PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			s_ritual.e_keeper notify("hash_274ba0e6");
			s_ritual.e_keeper ClearAnim("ai_zombie_zod_keeper_give_egg_intro", 0);
			s_ritual.e_keeper ClearAnim("ai_zombie_zod_keeper_give_egg_loop", 0);
			s_ritual.e_keeper animation::Play("ai_zombie_zod_keeper_give_egg_outro", undefined, undefined, 1);
			s_ritual.e_egg notify("remove_" + "egg_glow");
			break;
		}
		case 3:
		{
			s_ritual.e_keeper Hide();
			s_ritual.e_sword Hide();
			s_ritual.e_egg Hide();
			s_ritual.e_egg notify("remove_" + "egg_glow");
			if(isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper StopLoopSound(s_ritual.e_keeper.sndloop, 1);
			}
			break;
		}
		case 4:
		{
			var_4d1c542 = level clientfield::get("keeper_egg_location_" + n_character_index);
			v_origin = function_85b951d8(var_4d1c542);
			s_ritual.e_egg Unlink();
			s_ritual.e_egg.origin = v_origin;
			s_ritual.e_keeper Hide();
			s_ritual.e_sword Hide();
			s_ritual.e_egg show();
			if(isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper StopLoopSound(s_ritual.e_keeper.sndloop, 1);
			}
			s_ritual.e_egg thread play_fx(localClientNum, "egg_glow", "egg_keeper_jnt");
			s_ritual.e_egg thread function_5b78bb9e(v_origin);
			break;
		}
		case 5:
		{
			s_ritual.e_keeper show();
			s_ritual.e_sword Hide();
			s_ritual.e_egg Hide();
			if(!isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper.sndloop = s_ritual.e_keeper PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			s_ritual.e_egg notify("remove_" + "egg_glow");
			break;
		}
		case 6:
		{
			s_ritual.e_keeper show();
			s_ritual.e_sword Hide();
			s_ritual.e_egg Hide();
			if(!isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper.sndloop = s_ritual.e_keeper PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			s_ritual.e_keeper animation::Play("ai_zombie_zod_keeper_give_me_sword_intro", undefined, undefined, 1);
			s_ritual.e_keeper thread function_274ba0e6("ai_zombie_zod_keeper_give_me_sword_loop");
			break;
		}
		case 7:
		{
			v_origin = s_ritual.e_keeper GetTagOrigin("tag_weapon_right");
			v_angles = s_ritual.e_keeper GetTagAngles("tag_weapon_right");
			s_ritual.e_sword Unlink();
			s_ritual.e_sword.origin = v_origin;
			s_ritual.e_sword.angles = v_angles;
			s_ritual.e_sword LinkTo(s_ritual.e_keeper, "tag_weapon_right");
			s_ritual.e_keeper show();
			s_ritual.e_sword show();
			s_ritual.e_egg Hide();
			if(!isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper.sndloop = s_ritual.e_keeper PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			s_ritual.e_keeper notify("hash_274ba0e6");
			s_ritual.e_sword play_fx(localClientNum, "sword_quest_sword_glow", "tag_knife_fx");
			s_ritual.e_keeper animation::Play("ai_zombie_zod_keeper_upgrade_sword", undefined, undefined, 1);
			s_ritual.e_keeper thread function_274ba0e6("ai_zombie_zod_keeper_give_me_sword_loop");
			break;
		}
		case 8:
		{
			s_ritual.e_sword notify("remove_" + "sword_quest_sword_glow");
			wait(0.016);
			s_ritual.e_keeper show();
			s_ritual.e_sword Hide();
			s_ritual.e_egg Hide();
			if(!isdefined(s_ritual.e_keeper.sndloop))
			{
				s_ritual.e_keeper.sndloop = s_ritual.e_keeper PlayLoopSound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			s_ritual.e_keeper notify("hash_274ba0e6");
			s_ritual.e_keeper animation::Play("ai_zombie_zod_keeper_give_me_sword_outro", undefined, undefined, 1);
			s_ritual.e_keeper thread function_274ba0e6("ai_zombie_zod_keeper_idle");
			wait(2);
			s_ritual.var_5ab40ec3 = PlayFXOnTag(localClientNum, level._effect["keeper_spawn"], s_ritual.e_keeper, "tag_origin");
			wait(0.5);
			s_ritual.e_keeper Hide();
		}
	}
}

/*
	Name: function_bd205438
	Namespace: zm_zod_sword
	Checksum: 0xBB9F12C0
	Offset: 0x22A0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function function_bd205438(localClientNum, s_ritual)
{
	s_ritual.var_5ab40ec3 = PlayFXOnTag(localClientNum, level._effect["keeper_spawn"], s_ritual.e_keeper, "tag_origin");
	wait(1);
	stopfx(localClientNum, s_ritual.var_5ab40ec3);
}

/*
	Name: function_5b78bb9e
	Namespace: zm_zod_sword
	Checksum: 0xD956A7EE
	Offset: 0x2338
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_5b78bb9e(v_origin)
{
	self ClearAnim("p7_fxanim_zm_zod_egg_keeper_rise_anim", 0);
	self ClearAnim("p7_fxanim_zm_zod_egg_keeper_idle_anim", 0);
	self animation::Play("p7_fxanim_zm_zod_egg_keeper_rise_anim", v_origin, (0, 0, 1), 1);
	self animation::Play("p7_fxanim_zm_zod_egg_keeper_idle_anim", v_origin, (0, 0, 1), 1);
}

/*
	Name: function_274ba0e6
	Namespace: zm_zod_sword
	Checksum: 0xE4DA7DD0
	Offset: 0x23F0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function function_274ba0e6(str_animname)
{
	self notify("hash_274ba0e6");
	self endon("hash_274ba0e6");
	while(1)
	{
		self animation::Play(str_animname, undefined, undefined, 1);
	}
}

/*
	Name: function_528aad40
	Namespace: zm_zod_sword
	Checksum: 0x5E7EAB09
	Offset: 0x2450
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_528aad40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	magic_circle_state_internal(localClientNum, newVal, 0);
}

/*
	Name: function_1d308217
	Namespace: zm_zod_sword
	Checksum: 0x1C42A4F5
	Offset: 0x24B8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_1d308217(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	magic_circle_state_internal(localClientNum, newVal, 1);
}

/*
	Name: function_b17464d4
	Namespace: zm_zod_sword
	Checksum: 0xB9894BD8
	Offset: 0x2520
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_b17464d4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	magic_circle_state_internal(localClientNum, newVal, 2);
}

/*
	Name: function_b6499939
	Namespace: zm_zod_sword
	Checksum: 0x7B63602E
	Offset: 0x2588
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_b6499939(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	magic_circle_state_internal(localClientNum, newVal, 3);
}

/*
	Name: function_9ba2b995
	Namespace: zm_zod_sword
	Checksum: 0xAEA98577
	Offset: 0x25F0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_9ba2b995(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_4d020922(localClientNum, newVal, 0);
}

/*
	Name: function_fd8ec03a
	Namespace: zm_zod_sword
	Checksum: 0x6A865EE6
	Offset: 0x2658
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_fd8ec03a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_4d020922(localClientNum, newVal, 1);
}

/*
	Name: function_32002235
	Namespace: zm_zod_sword
	Checksum: 0x9BCBC289
	Offset: 0x26C0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_32002235(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_4d020922(localClientNum, newVal, 2);
}

/*
	Name: function_4fd5e276
	Namespace: zm_zod_sword
	Checksum: 0x98C846A0
	Offset: 0x2728
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_4fd5e276(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_4d020922(localClientNum, newVal, 3);
}

/*
	Name: function_5dab7fb
	Namespace: zm_zod_sword
	Checksum: 0xD8C85672
	Offset: 0x2790
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function function_5dab7fb(localClientNum, n_current_ritual)
{
	if(!isdefined(level.sword_quest))
	{
		level.sword_quest = [];
	}
	if(!isdefined(level.sword_quest[localClientNum]))
	{
		level.sword_quest[localClientNum] = [];
	}
	if(!isdefined(level.sword_quest[localClientNum][n_current_ritual]))
	{
		level.sword_quest[localClientNum][n_current_ritual] = spawnstruct();
	}
	s_ritual = level.sword_quest[localClientNum][n_current_ritual];
	return s_ritual;
}

/*
	Name: function_6890ca81
	Namespace: zm_zod_sword
	Checksum: 0x7380D20B
	Offset: 0x2850
	Size: 0x3CF
	Parameters: 2
	Flags: None
*/
function function_6890ca81(localClientNum, n_character_index)
{
	s_loc = struct::get("keeper_spirit_" + n_character_index, "targetname");
	s_ritual = function_5dab7fb(localClientNum, n_character_index);
	if(!isdefined(s_ritual.e_keeper))
	{
		s_ritual.e_keeper = spawn(localClientNum, s_loc.origin, "script_model");
		s_ritual.e_keeper.angles = s_loc.angles;
		s_ritual.e_keeper SetModel("c_zom_zod_keeper_fb");
	}
	if(!isdefined(s_ritual.e_sword))
	{
		s_ritual.e_sword = spawn(localClientNum, s_loc.origin, "script_model");
		s_ritual.e_sword SetModel(level.var_e91b9e85[n_character_index]);
	}
	if(!isdefined(s_ritual.e_egg))
	{
		s_ritual.e_egg = spawn(localClientNum, s_loc.origin, "script_model");
		s_ritual.e_egg SetModel("zm_zod_sword_egg_keeper_s1");
	}
	if(!isdefined(s_ritual.var_55e0bdcf))
	{
		a_circles = GetEntArray(localClientNum, "sword_quest_magic_circle_on", "targetname");
		var_55e0bdcf = undefined;
		foreach(e_circle in a_circles)
		{
			if(e_circle.script_int === n_character_index)
			{
				var_55e0bdcf = e_circle;
			}
		}
		s_ritual.var_55e0bdcf = var_55e0bdcf;
	}
	if(!isdefined(s_ritual.var_6a0d8b03))
	{
		a_circles = GetEntArray(localClientNum, "sword_quest_magic_circle_off", "targetname");
		var_6a0d8b03 = undefined;
		foreach(e_circle in a_circles)
		{
			if(e_circle.script_int === n_character_index)
			{
				var_6a0d8b03 = e_circle;
			}
		}
		s_ritual.var_6a0d8b03 = var_6a0d8b03;
	}
	return s_ritual;
}

/*
	Name: get_name_from_ritual_clientfield_value
	Namespace: zm_zod_sword
	Checksum: 0x719A89EB
	Offset: 0x2C28
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function get_name_from_ritual_clientfield_value(n_current_ritual)
{
	switch(n_current_ritual)
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
	}
}

/*
	Name: function_85b951d8
	Namespace: zm_zod_sword
	Checksum: 0x43595057
	Offset: 0x2C90
	Size: 0xCD
	Parameters: 1
	Flags: None
*/
function function_85b951d8(var_181b74a5)
{
	a_s_circles = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(s_circle in a_s_circles)
	{
		if(s_circle.script_int === var_181b74a5)
		{
			return s_circle.origin;
		}
	}
}

/*
	Name: function_96ae1a10
	Namespace: zm_zod_sword
	Checksum: 0xF4556CB3
	Offset: 0x2D68
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function function_96ae1a10(var_181b74a5, n_character_index)
{
	a_s_circles = struct::get_array("sword_quest_magic_circle_player_" + n_character_index, "targetname");
	foreach(s_circle in a_s_circles)
	{
		if(s_circle.script_int === var_181b74a5)
		{
			return s_circle;
		}
	}
}

/*
	Name: play_fx
	Namespace: zm_zod_sword
	Checksum: 0xE937124
	Offset: 0x2E48
	Size: 0xCB
	Parameters: 3
	Flags: None
*/
function play_fx(localClientNum, str_fx, str_tag)
{
	FX = undefined;
	if(isdefined(str_tag))
	{
		FX = PlayFXOnTag(localClientNum, level._effect[str_fx], self, str_tag);
	}
	else
	{
		FX = playFX(localClientNum, level._effect[str_fx], self.origin);
	}
	self waittill("remove_" + str_fx);
	stopfx(localClientNum, FX);
}

/*
	Name: sword_statue_glow
	Namespace: zm_zod_sword
	Checksum: 0x91987208
	Offset: 0x2F20
	Size: 0x87
	Parameters: 7
	Flags: None
*/
function sword_statue_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread play_fx(localClientNum, "sword_quest_sword_glow", "tag_knife_fx");
	}
	else
	{
		self notify("remove_" + "sword_quest_sword_glow");
	}
}

/*
	Name: sword_egg_glow
	Namespace: zm_zod_sword
	Checksum: 0xD8C0C34D
	Offset: 0x2FB0
	Size: 0x7F
	Parameters: 7
	Flags: None
*/
function sword_egg_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread play_fx(localClientNum, "egg_glow");
	}
	else
	{
		self notify("remove_" + "egg_glow");
	}
}

/*
	Name: blood_soul_fx
	Namespace: zm_zod_sword
	Checksum: 0x37CCDEC7
	Offset: 0x3038
	Size: 0x7D
	Parameters: 7
	Flags: None
*/
function blood_soul_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread play_fx(localClientNum, "blood_soul", "tag_origin");
	}
	else
	{
		self notify("remove_blood_soul");
	}
}

