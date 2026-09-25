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

#namespace namespace_52f9507e;

/*
	Name: __init__sytem__
	Namespace: namespace_52f9507e
	Checksum: 0xB4AA7609
	Offset: 0x548
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_52f9507e
	Checksum: 0xCA8AE54E
	Offset: 0x588
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_zod", 9000, 15, 2);
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("toplayer", "player_stargate_fx", 9000, 1, "int", &function_2396c469, 0, 0);
	clientfield::register("world", "portal_state_ending_0", 9000, 1, "int", &function_ed05ad08, 0, 0);
	clientfield::register("world", "portal_state_ending_1", 9000, 1, "int", &function_13082771, 0, 0);
	clientfield::register("world", "portal_state_ending_2", 9000, 1, "int", &function_390aa1da, 0, 0);
	clientfield::register("world", "portal_state_ending_3", 9000, 1, "int", &function_5f0d1c43, 0, 0);
	clientfield::register("world", "pulse_ee_boat_portal_top", 9000, 1, "counter", &function_b040f607, 0, 0);
	clientfield::register("world", "pulse_ee_boat_portal_bottom", 9000, 1, "counter", &function_bfbf92fb, 0, 0);
}

/*
	Name: function_2396c469
	Namespace: namespace_52f9507e
	Checksum: 0x902D3456
	Offset: 0x7D8
	Size: 0xF5
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
		if(IsSpectating(localClientNum))
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
	Namespace: namespace_52f9507e
	Checksum: 0xD3C1131D
	Offset: 0x8D8
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
	Namespace: namespace_52f9507e
	Checksum: 0x41DD897E
	Offset: 0x930
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_dcfb71f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("death");
	if(newVal == 1)
	{
		self.var_e4e89382 = PlayFXOnTag(localClientNum, level._effect["portal_3p"], self, "j_spineupper");
	}
	else
	{
		function_f9eb885e(localClientNum, self.var_e4e89382);
	}
}

/*
	Name: function_e962c05f
	Namespace: namespace_52f9507e
	Checksum: 0xCC09A80E
	Offset: 0x9E8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_e962c05f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_35d5bf67(localClientNum, "ee_boat", newVal);
}

/*
	Name: function_35d5bf67
	Namespace: namespace_52f9507e
	Checksum: 0xB21EE1BA
	Offset: 0xA50
	Size: 0x2AD
	Parameters: 3
	Flags: None
*/
function function_35d5bf67(localClientNum, var_d42f02cf, newVal)
{
	var_eed93042 = function_227344a6("teleport_effect_origin", var_d42f02cf, 1);
	var_2a948ed5 = function_227344a6("teleport_effect_origin", var_d42f02cf, 0);
	switch(newVal)
	{
		case 0:
		{
			level thread function_c0c1771a(localClientNum, var_eed93042, 0, 0);
			level thread function_c0c1771a(localClientNum, var_2a948ed5, 0, 1);
			level thread function_a2d0d0e4(var_eed93042.origin, var_2a948ed5.origin, "amb_teleporter_off_lp", "amb_teleporter_on_lp");
			exploder::stop_exploder("lgt_portal_" + var_d42f02cf);
			break;
		}
		case 1:
		{
			level thread function_c0c1771a(localClientNum, var_eed93042, 1, 0);
			level thread function_c0c1771a(localClientNum, var_2a948ed5, 1, 1);
			level thread function_a2d0d0e4(var_eed93042.origin, var_2a948ed5.origin, "amb_teleporter_on_lp", "amb_teleporter_off_lp", "amb_teleporter_activate");
			exploder::exploder("lgt_portal_" + var_d42f02cf);
			break;
		}
		case 2:
		{
			level thread function_c0c1771a(localClientNum, var_eed93042, 1, 0);
			level thread function_c0c1771a(localClientNum, var_2a948ed5, 1, 1);
			level thread function_a2d0d0e4(var_eed93042.origin, var_2a948ed5.origin, "amb_teleporter_on_lp", "amb_teleporter_off_lp", "amb_teleporter_activate");
			exploder::exploder("lgt_portal_" + var_d42f02cf);
			break;
		}
	}
}

/*
	Name: function_b040f607
	Namespace: namespace_52f9507e
	Checksum: 0xA69B6DE5
	Offset: 0xD08
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_b040f607(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "ee_boat", 1);
}

/*
	Name: function_bfbf92fb
	Namespace: namespace_52f9507e
	Checksum: 0x32B6DEDF
	Offset: 0xD70
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_bfbf92fb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_11ac3c33(localClientNum, "ee_boat", 0);
}

/*
	Name: function_11ac3c33
	Namespace: namespace_52f9507e
	Checksum: 0xAB680E8B
	Offset: 0xDD8
	Size: 0xED
	Parameters: 3
	Flags: None
*/
function function_11ac3c33(localClientNum, var_d42f02cf, var_a5e295bc)
{
	s_loc = function_227344a6("teleport_effect_origin", var_d42f02cf, var_a5e295bc);
	if(isdefined(s_loc))
	{
		var_836f2873 = function_86743484(localClientNum, s_loc);
		for(i = 1; i < 25; i++)
		{
			if(i % 5 === 0)
			{
				PlayFXOnTag(localClientNum, level._effect["portal_shortcut_pulse"], var_836f2873, "tag_fx_ring_" + i);
			}
		}
	}
}

/*
	Name: function_c0c1771a
	Namespace: namespace_52f9507e
	Checksum: 0x1FD87EA3
	Offset: 0xED0
	Size: 0x311
	Parameters: 4
	Flags: None
*/
function function_c0c1771a(localClientNum, s_loc, b_open, var_9c9cfb54)
{
	if(!isdefined(var_9c9cfb54))
	{
		var_9c9cfb54 = 0;
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
	function_f9eb885e(localClientNum, s_loc.var_7c0ed442[localClientNum]);
	function_f9eb885e(localClientNum, s_loc.var_20dc3b64[localClientNum]);
	if(isdefined(b_open) && b_open)
	{
		s_loc.var_1db71ac6[localClientNum] = playFX(localClientNum, level._effect["portal_shortcut_opening"], s_loc.origin, v_fwd);
	}
	var_836f2873 = function_86743484(localClientNum, s_loc);
	var_836f2873 HidePart(localClientNum, "tag_portal_open");
	if(b_open)
	{
		wait(1.3);
		var_836f2873 ShowPart(localClientNum, "tag_portal_open");
		for(i = 1; i < 25; i++)
		{
			PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], var_836f2873, "tag_fx_ring_" + i);
		}
	}
	else
	{
		var_836f2873 HidePart(localClientNum, "tag_portal_open");
	}
	function_f9eb885e(localClientNum, s_loc.var_1db71ac6[localClientNum]);
	if(isdefined(b_open) && b_open)
	{
		s_loc.var_7c0ed442[localClientNum] = playFX(localClientNum, level._effect["portal_shortcut_ambient"], s_loc.origin, v_fwd);
	}
}

/*
	Name: function_86743484
	Namespace: namespace_52f9507e
	Checksum: 0x5FF2EA7C
	Offset: 0x11F0
	Size: 0x18D
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
		return level.var_ef51ee6d[localClientNum][str_name].var_836f2873;
	}
	level.var_ef51ee6d[localClientNum][str_name] = spawnstruct();
	level.var_ef51ee6d[localClientNum][str_name].var_836f2873 = spawn(localClientNum, s_loc.origin, "script_model");
	level.var_ef51ee6d[localClientNum][str_name].var_836f2873.angles = s_loc.angles;
	level.var_ef51ee6d[localClientNum][str_name].var_836f2873 SetModel("p7_zm_zod_keeper_portal_01");
	return level.var_ef51ee6d[localClientNum][str_name].var_836f2873;
}

/*
	Name: function_227344a6
	Namespace: namespace_52f9507e
	Checksum: 0x20999577
	Offset: 0x1388
	Size: 0x13B
	Parameters: 3
	Flags: None
*/
function function_227344a6(str_targetname, var_d42f02cf, var_a5e295bc)
{
	var_3842f06d = struct::get_array(str_targetname, "targetname");
	var_216e113e = undefined;
	var_a889df54 = undefined;
	if(isdefined(var_a5e295bc) && var_a5e295bc)
	{
		var_a889df54 = "top";
	}
	else
	{
		var_a889df54 = "bottom";
	}
	foreach(var_50f27682 in var_3842f06d)
	{
		if(var_50f27682.script_noteworthy === var_d42f02cf + "_portal_" + var_a889df54)
		{
			var_216e113e = var_50f27682;
		}
	}
	return var_216e113e;
}

/*
	Name: function_f9eb885e
	Namespace: namespace_52f9507e
	Checksum: 0xEB1776F5
	Offset: 0x14D0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function function_f9eb885e(localClientNum, var_55518655)
{
	if(isdefined(var_55518655))
	{
		stopfx(localClientNum, var_55518655);
	}
}

/*
	Name: function_a2d0d0e4
	Namespace: namespace_52f9507e
	Checksum: 0x2FD801BF
	Offset: 0x1518
	Size: 0x2B
	Parameters: 5
	Flags: None
*/
function function_a2d0d0e4(origin1, origin2, var_4358f968, var_2978dbc6, activation)
{
}

/*
	Name: function_c968dcbc
	Namespace: namespace_52f9507e
	Checksum: 0x847C867A
	Offset: 0x1550
	Size: 0x35
	Parameters: 4
	Flags: None
*/
function function_c968dcbc(origin1, var_4358f968, oneshot, activate)
{
	if(!isdefined(activate))
	{
		activate = 0;
	}
}

/*
	Name: function_ed05ad08
	Namespace: namespace_52f9507e
	Checksum: 0x8B035949
	Offset: 0x1590
	Size: 0x3B3
	Parameters: 7
	Flags: None
*/
function function_ed05ad08(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(!isdefined(level.var_2cc3341a))
	{
		level.var_2cc3341a = struct::get("ending_igc_portal_0");
	}
	if(newVal)
	{
		level.var_2cc3341a.var_92f13ff4 = spawn(localClientNum, level.var_2cc3341a.origin, "script_model");
		level.var_2cc3341a.var_92f13ff4.angles = level.var_2cc3341a.angles;
		level.var_2cc3341a.var_92f13ff4 SetModel("p7_zm_zod_keeper_portal_01");
		level.var_2cc3341a.var_2f0937c1 = [];
		for(i = 1; i < 25; i++)
		{
			fx_id = PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], level.var_2cc3341a.var_92f13ff4, "tag_fx_ring_" + i);
			if(!isdefined(level.var_2cc3341a.var_2f0937c1))
			{
				level.var_2cc3341a.var_2f0937c1 = [];
			}
			else if(!IsArray(level.var_2cc3341a.var_2f0937c1))
			{
				level.var_2cc3341a.var_2f0937c1 = Array(level.var_2cc3341a.var_2f0937c1);
			}
			level.var_2cc3341a.var_2f0937c1[level.var_2cc3341a.var_2f0937c1.size] = fx_id;
		}
		level thread function_c968dcbc(level.var_2cc3341a.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_start", 1);
	}
	else
	{
		foreach(fx_id in level.var_2cc3341a.var_2f0937c1)
		{
			stopfx(localClientNum, fx_id);
		}
		playFX(localClientNum, level._effect["portal_shortcut_ending"], level.var_2cc3341a.origin, level.var_2cc3341a.angles);
		level thread function_c968dcbc(level.var_2cc3341a.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_end");
		level.var_2cc3341a.var_92f13ff4 delete();
	}
}

/*
	Name: function_13082771
	Namespace: namespace_52f9507e
	Checksum: 0x306B4AEE
	Offset: 0x1950
	Size: 0x3B3
	Parameters: 7
	Flags: None
*/
function function_13082771(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(!isdefined(level.var_52c5ae83))
	{
		level.var_52c5ae83 = struct::get("ending_igc_portal_1");
	}
	if(newVal)
	{
		level.var_52c5ae83.var_92f13ff4 = spawn(localClientNum, level.var_52c5ae83.origin, "script_model");
		level.var_52c5ae83.var_92f13ff4.angles = level.var_52c5ae83.angles;
		level.var_52c5ae83.var_92f13ff4 SetModel("p7_zm_zod_keeper_portal_01");
		level.var_52c5ae83.var_2f0937c1 = [];
		for(i = 1; i < 25; i++)
		{
			fx_id = PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], level.var_52c5ae83.var_92f13ff4, "tag_fx_ring_" + i);
			if(!isdefined(level.var_52c5ae83.var_2f0937c1))
			{
				level.var_52c5ae83.var_2f0937c1 = [];
			}
			else if(!IsArray(level.var_52c5ae83.var_2f0937c1))
			{
				level.var_52c5ae83.var_2f0937c1 = Array(level.var_52c5ae83.var_2f0937c1);
			}
			level.var_52c5ae83.var_2f0937c1[level.var_52c5ae83.var_2f0937c1.size] = fx_id;
		}
		level thread function_c968dcbc(level.var_52c5ae83.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_start", 1);
	}
	else
	{
		foreach(fx_id in level.var_52c5ae83.var_2f0937c1)
		{
			stopfx(localClientNum, fx_id);
		}
		playFX(localClientNum, level._effect["portal_shortcut_ending"], level.var_52c5ae83.origin, level.var_52c5ae83.angles);
		level thread function_c968dcbc(level.var_52c5ae83.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_end");
		level.var_52c5ae83.var_92f13ff4 delete();
	}
}

/*
	Name: function_390aa1da
	Namespace: namespace_52f9507e
	Checksum: 0x4A57CD5
	Offset: 0x1D10
	Size: 0x3B3
	Parameters: 7
	Flags: None
*/
function function_390aa1da(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(!isdefined(level.var_e0be3f48))
	{
		level.var_e0be3f48 = struct::get("ending_igc_portal_2");
	}
	if(newVal)
	{
		level.var_e0be3f48.var_92f13ff4 = spawn(localClientNum, level.var_e0be3f48.origin, "script_model");
		level.var_e0be3f48.var_92f13ff4.angles = level.var_e0be3f48.angles;
		level.var_e0be3f48.var_92f13ff4 SetModel("p7_zm_zod_keeper_portal_01");
		level.var_e0be3f48.var_2f0937c1 = [];
		for(i = 1; i < 25; i++)
		{
			fx_id = PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], level.var_e0be3f48.var_92f13ff4, "tag_fx_ring_" + i);
			if(!isdefined(level.var_e0be3f48.var_2f0937c1))
			{
				level.var_e0be3f48.var_2f0937c1 = [];
			}
			else if(!IsArray(level.var_e0be3f48.var_2f0937c1))
			{
				level.var_e0be3f48.var_2f0937c1 = Array(level.var_e0be3f48.var_2f0937c1);
			}
			level.var_e0be3f48.var_2f0937c1[level.var_e0be3f48.var_2f0937c1.size] = fx_id;
		}
		level thread function_c968dcbc(level.var_e0be3f48.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_start", 1);
	}
	else
	{
		foreach(fx_id in level.var_e0be3f48.var_2f0937c1)
		{
			stopfx(localClientNum, fx_id);
		}
		playFX(localClientNum, level._effect["portal_shortcut_ending"], level.var_e0be3f48.origin, level.var_e0be3f48.angles);
		level thread function_c968dcbc(level.var_e0be3f48.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_end");
		level.var_e0be3f48.var_92f13ff4 delete();
	}
}

/*
	Name: function_5f0d1c43
	Namespace: namespace_52f9507e
	Checksum: 0xF6BF7649
	Offset: 0x20D0
	Size: 0x3B3
	Parameters: 7
	Flags: None
*/
function function_5f0d1c43(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(!isdefined(level.var_6c0b9b1))
	{
		level.var_6c0b9b1 = struct::get("ending_igc_portal_3");
	}
	if(newVal)
	{
		level.var_6c0b9b1.var_92f13ff4 = spawn(localClientNum, level.var_6c0b9b1.origin, "script_model");
		level.var_6c0b9b1.var_92f13ff4.angles = level.var_6c0b9b1.angles;
		level.var_6c0b9b1.var_92f13ff4 SetModel("p7_zm_zod_keeper_portal_01");
		level.var_6c0b9b1.var_2f0937c1 = [];
		for(i = 1; i < 25; i++)
		{
			fx_id = PlayFXOnTag(localClientNum, level._effect["portal_shortcut_open_border"], level.var_6c0b9b1.var_92f13ff4, "tag_fx_ring_" + i);
			if(!isdefined(level.var_6c0b9b1.var_2f0937c1))
			{
				level.var_6c0b9b1.var_2f0937c1 = [];
			}
			else if(!IsArray(level.var_6c0b9b1.var_2f0937c1))
			{
				level.var_6c0b9b1.var_2f0937c1 = Array(level.var_6c0b9b1.var_2f0937c1);
			}
			level.var_6c0b9b1.var_2f0937c1[level.var_6c0b9b1.var_2f0937c1.size] = fx_id;
		}
		level thread function_c968dcbc(level.var_6c0b9b1.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_start", 1);
	}
	else
	{
		foreach(fx_id in level.var_6c0b9b1.var_2f0937c1)
		{
			stopfx(localClientNum, fx_id);
		}
		playFX(localClientNum, level._effect["portal_shortcut_ending"], level.var_6c0b9b1.origin, level.var_6c0b9b1.angles);
		level thread function_c968dcbc(level.var_6c0b9b1.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_end");
		level.var_6c0b9b1.var_92f13ff4 delete();
	}
}

