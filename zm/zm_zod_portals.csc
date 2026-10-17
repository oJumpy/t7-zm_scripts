#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_8e2647d0;

/*
	Name: __init__sytem__
	Namespace: namespace_8e2647d0
	Checksum: 0xDF0B9BB6
	Offset: 0x6C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8e2647d0
	Checksum: 0x82D2D98F
	Offset: 0x708
	Size: 0x423
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_zod", 1, 15, 2);
	level._effect["portal_shortcut_closed"] = "zombie/fx_quest_portal_tear_zod_zmb";
	level._effect["portal_shortcut_open_border"] = "zombie/fx_quest_portal_edge_zod_zmb";
	level._effect["portal_shortcut_ambient"] = "zombie/fx_quest_portal_ambient_zod_zmb";
	level._effect["portal_shortcut_pulse"] = "zombie/fx_quest_portal_edge_flash_zod_zmb";
	level._effect["portal_shortcut_opening"] = "zombie/fx_quest_portal_expand_zod_zmb";
	level._effect["portal_shortcut_closed_base"] = "zombie/fx_quest_portal_closed_zod_zmb";
	level._effect["portal_shortcut_ending"] = "zombie/fx_quest_portal_close_igc_zod_zmb";
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("toplayer", "player_stargate_fx", 1, 1, "int", &function_2396c469, 0, 0);
	clientfield::register("world", "portal_state_canal", 1, n_bits, "int", &function_b3ee6c81, 0, 1);
	clientfield::register("world", "portal_state_slums", 1, n_bits, "int", &function_8e86ff36, 0, 1);
	clientfield::register("world", "portal_state_theater", 1, n_bits, "int", &function_ec77bf, 0, 1);
	clientfield::register("world", "portal_state_ending", 1, 1, "int", &function_2876d055, 0, 0);
	clientfield::register("world", "pulse_canal_portal_top", 1, 1, "counter", &function_4bc7c0a1, 0, 0);
	clientfield::register("world", "pulse_canal_portal_bottom", 1, 1, "counter", &function_bd6fa919, 0, 0);
	clientfield::register("world", "pulse_slums_portal_top", 1, 1, "counter", &function_e66eb44e, 0, 0);
	clientfield::register("world", "pulse_slums_portal_bottom", 1, 1, "counter", &function_9be42b84, 0, 0);
	clientfield::register("world", "pulse_theater_portal_top", 1, 1, "counter", &function_7acc82f, 0, 0);
	clientfield::register("world", "pulse_theater_portal_bottom", 1, 1, "counter", &function_8fbd3c13, 0, 0);
}

/*
	Name: function_2396c469
	Namespace: namespace_8e2647d0
	Checksum: 0x584E3D2F
	Offset: 0xB38
	Size: 0xDD
	Parameters: 7
	Flags: None
*/
function function_2396c469(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("hash_2396c469");
	self endon("hash_2396c469");
	if(newVal == 1)
	{
		if(IsDemoPlaying() && DemoIsAnyFreeMoveCamera())
		{
			return;
		}
		self thread function_e7a8756e(localClientNum);
		self thread postfx::playPostfxBundle("pstfx_zm_wormhole");
	}
	else
	{
		self notify("hash_ee477153");
	}
}

/*
	Name: function_e7a8756e
	Namespace: namespace_8e2647d0
	Checksum: 0x13CA61A2
	Offset: 0xC20
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_e7a8756e(localClientNum)
{
	self util::waittill_any("player_stargate_fx", "player_portal_complete");
	self postfx::exitPostfxBundle();
}

/*
	Name: function_dcfb71f
	Namespace: namespace_8e2647d0
	Checksum: 0x3B5EC4AD
	Offset: 0xC78
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_dcfb71f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("death");
	if(newVal == 1)
	{
		self.fx_portal_3p = PlayFXOnTag(localClientNum, level._effect["portal_3p"], self, "j_spineupper");
	}
	else
	{
		stop_fx_if_defined(localClientNum, self.fx_portal_3p);
	}
}

/*
	Name: function_b3ee6c81
	Namespace: namespace_8e2647d0
	Checksum: 0x4B357997
	Offset: 0xD30
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_b3ee6c81(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	portal_state_internal(localClientNum, "canal", newVal);
}

/*
	Name: function_8e86ff36
	Namespace: namespace_8e2647d0
	Checksum: 0x8244DD64
	Offset: 0xD98
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_8e86ff36(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	portal_state_internal(localClientNum, "slums", newVal);
}

/*
	Name: function_ec77bf
	Namespace: namespace_8e2647d0
	Checksum: 0xB3B5EF43
	Offset: 0xE00
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_ec77bf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	portal_state_internal(localClientNum, "theater", newVal);
}

/*
	Name: portal_state_internal
	Namespace: namespace_8e2647d0
	Checksum: 0x241E96EF
	Offset: 0xE68
	Size: 0x2AD
	Parameters: 3
	Flags: None
*/
function portal_state_internal(localClientNum, str_areaname, newVal)
{
	s_loc_upper = get_portal_fx_loc("teleport_effect_origin", str_areaname, 1);
	s_loc_lower = get_portal_fx_loc("teleport_effect_origin", str_areaname, 0);
	switch(newVal)
	{
		case 0:
		{
			level thread function_c0c1771a(localClientNum, s_loc_upper, 0, 0);
			level thread function_c0c1771a(localClientNum, s_loc_lower, 0, 1);
			level thread sndportal(s_loc_upper.origin, s_loc_lower.origin, "amb_teleporter_off_lp", "amb_teleporter_on_lp");
			exploder::stop_exploder("lgt_portal_" + str_areaname);
			break;
		}
		case 1:
		{
			level thread function_c0c1771a(localClientNum, s_loc_upper, 1, 0);
			level thread function_c0c1771a(localClientNum, s_loc_lower, 1, 1);
			level thread sndportal(s_loc_upper.origin, s_loc_lower.origin, "amb_teleporter_on_lp", "amb_teleporter_off_lp", "amb_teleporter_activate");
			exploder::exploder("lgt_portal_" + str_areaname);
			break;
		}
		case 2:
		{
			level thread function_c0c1771a(localClientNum, s_loc_upper, 1, 0);
			level thread function_c0c1771a(localClientNum, s_loc_lower, 1, 1);
			level thread sndportal(s_loc_upper.origin, s_loc_lower.origin, "amb_teleporter_on_lp", "amb_teleporter_off_lp", "amb_teleporter_activate");
			exploder::exploder("lgt_portal_" + str_areaname);
			break;
		}
	}
}

/*
	Name: function_2876d055
	Namespace: namespace_8e2647d0
	Checksum: 0x5665C2D9
	Offset: 0x1120
	Size: 0x333
	Parameters: 7
	Flags: None
*/
function function_2876d055(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	s_loc = struct::get("ending_igc_portal", "targetname");
	v_fwd = AnglesToForward(s_loc.angles);
	if(newVal)
	{
		level.var_92f13ff4 = spawn(localClientNum, s_loc.origin, "script_model");
		level.var_92f13ff4.angles = s_loc.angles;
		level.var_92f13ff4 SetModel("p7_zm_zod_keeper_portal_01");
		level.var_120797a1 = [];
		for(i = 1; i < 25; i++)
		{
			fx_id = PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], level.var_92f13ff4, "tag_fx_ring_" + i);
			if(!isdefined(level.var_120797a1))
			{
				level.var_120797a1 = [];
			}
			else if(!IsArray(level.var_120797a1))
			{
				level.var_120797a1 = Array(level.var_120797a1);
			}
			level.var_120797a1[level.var_120797a1.size] = fx_id;
		}
		level thread function_c968dcbc(s_loc.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_start", 1);
	}
	else
	{
		foreach(fx_id in level.var_120797a1)
		{
			stopfx(localClientNum, fx_id);
		}
		playFX(localClientNum, level._effect["portal_shortcut_ending"], s_loc.origin, v_fwd);
		level.var_92f13ff4 delete();
		level thread function_c968dcbc(s_loc.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_end");
	}
}

/*
	Name: function_4bc7c0a1
	Namespace: namespace_8e2647d0
	Checksum: 0x7C78EF5C
	Offset: 0x1460
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_4bc7c0a1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "canal", 1);
}

/*
	Name: function_bd6fa919
	Namespace: namespace_8e2647d0
	Checksum: 0xEDE0996A
	Offset: 0x14C8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_bd6fa919(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "canal", 0);
}

/*
	Name: function_e66eb44e
	Namespace: namespace_8e2647d0
	Checksum: 0x6366097D
	Offset: 0x1530
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_e66eb44e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "slums", 1);
}

/*
	Name: function_9be42b84
	Namespace: namespace_8e2647d0
	Checksum: 0x6FFF9F4F
	Offset: 0x1598
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_9be42b84(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "slums", 0);
}

/*
	Name: function_7acc82f
	Namespace: namespace_8e2647d0
	Checksum: 0x2DB0B5A
	Offset: 0x1600
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_7acc82f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "theater", 1);
}

/*
	Name: function_8fbd3c13
	Namespace: namespace_8e2647d0
	Checksum: 0x62B501C8
	Offset: 0x1668
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_8fbd3c13(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "theater", 0);
}

/*
	Name: function_11ac3c33
	Namespace: namespace_8e2647d0
	Checksum: 0xE0374E4E
	Offset: 0x16D0
	Size: 0xE5
	Parameters: 3
	Flags: None
*/
function function_11ac3c33(localClientNum, str_areaname, b_is_top)
{
	s_loc = get_portal_fx_loc("teleport_effect_origin", str_areaname, b_is_top);
	mdl_portal = function_86743484(localClientNum, s_loc);
	for(i = 1; i < 25; i++)
	{
		if(i % 5 === 0)
		{
			PlayFXOnTag(localClientNum, level._effect["portal_shortcut_pulse"], mdl_portal, "tag_fx_ring_" + i);
		}
	}
}

/*
	Name: function_c0c1771a
	Namespace: namespace_8e2647d0
	Checksum: 0x86AD7E6D
	Offset: 0x17C0
	Size: 0x3C5
	Parameters: 4
	Flags: None
*/
function function_c0c1771a(localClientNum, s_loc, b_open, b_is_subway)
{
	if(!isdefined(b_is_subway))
	{
		b_is_subway = 0;
	}
	v_fwd = AnglesToForward(s_loc.angles);
	if(!isdefined(s_loc.var_7c0ed442))
	{
		s_loc.var_7c0ed442 = [];
	}
	if(!isdefined(s_loc.var_20dc3b64))
	{
		s_loc.var_20dc3b64 = [];
	}
	if(!isdefined(s_loc.var_1db71ac6))
	{
		s_loc.var_1db71ac6 = [];
	}
	stop_fx_if_defined(localClientNum, s_loc.var_7c0ed442[localClientNum]);
	stop_fx_if_defined(localClientNum, s_loc.var_20dc3b64[localClientNum]);
	if(isdefined(b_open) && b_open)
	{
		s_loc.var_1db71ac6[localClientNum] = playFX(localClientNum, level._effect["portal_shortcut_opening"], s_loc.origin, v_fwd);
	}
	mdl_portal = function_86743484(localClientNum, s_loc);
	mdl_portal HidePart(localClientNum, "tag_portal_open");
	if(b_open)
	{
		wait(1.3);
		mdl_portal ShowPart(localClientNum, "tag_portal_open");
		for(i = 1; i < 25; i++)
		{
			PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], mdl_portal, "tag_fx_ring_" + i);
		}
	}
	else
	{
		mdl_portal HidePart(localClientNum, "tag_portal_open");
	}
	stop_fx_if_defined(localClientNum, s_loc.var_1db71ac6[localClientNum]);
	if(isdefined(b_open) && b_open)
	{
		s_loc.var_7c0ed442[localClientNum] = playFX(localClientNum, level._effect["portal_shortcut_ambient"], s_loc.origin, v_fwd);
	}
	else if(b_is_subway)
	{
		s_loc.var_20dc3b64[localClientNum] = playFX(localClientNum, level._effect["portal_shortcut_closed_base"], s_loc.origin - VectorScale((0, 0, 1), 48), v_fwd);
	}
	else
	{
		s_loc.var_7c0ed442[localClientNum] = playFX(localClientNum, level._effect["portal_shortcut_closed"], s_loc.origin, v_fwd);
	}
}

/*
	Name: function_86743484
	Namespace: namespace_8e2647d0
	Checksum: 0xAF1F3B38
	Offset: 0x1B90
	Size: 0x24D
	Parameters: 2
	Flags: None
*/
function function_86743484(localClientNum, s_loc)
{
	if(!isdefined(level.var_ef51ee6d))
	{
		level.var_ef51ee6d = [];
	}
	if(!isdefined(level.var_ef51ee6d[localClientNum]))
	{
		level.var_ef51ee6d[localClientNum] = [];
	}
	str_name = s_loc.script_noteworthy;
	if(isdefined(level.var_ef51ee6d[localClientNum][str_name]))
	{
		return level.var_ef51ee6d[localClientNum][str_name].mdl_portal;
	}
	level.var_ef51ee6d[localClientNum][str_name] = spawnstruct();
	level.var_ef51ee6d[localClientNum][str_name].mdl_portal = spawn(localClientNum, s_loc.origin, "script_model");
	level.var_ef51ee6d[localClientNum][str_name].mdl_portal.angles = s_loc.angles;
	level.var_ef51ee6d[localClientNum][str_name].mdl_portal SetModel("p7_zm_zod_keeper_portal_01");
	level.var_ef51ee6d[localClientNum][str_name].mdl_base = spawn(localClientNum, s_loc.origin - VectorScale((0, 0, 1), 48), "script_model");
	level.var_ef51ee6d[localClientNum][str_name].mdl_base.angles = s_loc.angles;
	level.var_ef51ee6d[localClientNum][str_name].mdl_base SetModel("p7_zm_zod_keeper_portal_base");
	return level.var_ef51ee6d[localClientNum][str_name].mdl_portal;
}

/*
	Name: get_portal_fx_loc
	Namespace: namespace_8e2647d0
	Checksum: 0x904FDAEF
	Offset: 0x1DE8
	Size: 0x13B
	Parameters: 3
	Flags: None
*/
function get_portal_fx_loc(str_targetname, str_areaname, b_is_top)
{
	a_s_portal_locs = struct::get_array(str_targetname, "targetname");
	s_return_loc = undefined;
	str_top_or_bottom = undefined;
	if(isdefined(b_is_top) && b_is_top)
	{
		str_top_or_bottom = "top";
	}
	else
	{
		str_top_or_bottom = "bottom";
	}
	foreach(s_portal_loc in a_s_portal_locs)
	{
		if(s_portal_loc.script_noteworthy === str_areaname + "_portal_" + str_top_or_bottom)
		{
			s_return_loc = s_portal_loc;
		}
	}
	return s_return_loc;
}

/*
	Name: stop_fx_if_defined
	Namespace: namespace_8e2647d0
	Checksum: 0xF0426A88
	Offset: 0x1F30
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function stop_fx_if_defined(localClientNum, fx_reference)
{
	if(isdefined(fx_reference))
	{
		stopfx(localClientNum, fx_reference);
	}
}

/*
	Name: sndportal
	Namespace: namespace_8e2647d0
	Checksum: 0x703BCBC
	Offset: 0x1F78
	Size: 0xE3
	Parameters: 5
	Flags: None
*/
function sndportal(origin1, origin2, onloop, var_2978dbc6, activation)
{
	audio::playloopat(onloop, origin1);
	audio::stoploopat(var_2978dbc6, origin1);
	if(isdefined(activation))
	{
		playsound(0, activation, origin1);
	}
	wait(0.05);
	audio::playloopat(onloop, origin2);
	audio::stoploopat(var_2978dbc6, origin2);
	if(isdefined(activation))
	{
		playsound(0, activation, origin2);
	}
}

/*
	Name: function_c968dcbc
	Namespace: namespace_8e2647d0
	Checksum: 0xDE250584
	Offset: 0x2068
	Size: 0xA3
	Parameters: 4
	Flags: None
*/
function function_c968dcbc(origin1, onloop, oneshot, activate)
{
	if(!isdefined(activate))
	{
		activate = 0;
	}
	if(isdefined(activate) && activate)
	{
		audio::playloopat(onloop, origin1);
	}
	else
	{
		audio::stoploopat(onloop, origin1);
	}
	playsound(0, oneshot, origin1);
}

