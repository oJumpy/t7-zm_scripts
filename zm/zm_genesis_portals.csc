#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
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

#namespace namespace_766d6099;

/*
	Name: __init__sytem__
	Namespace: namespace_766d6099
	Checksum: 0x146EC814
	Offset: 0x568
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_766d6099
	Checksum: 0x970E7E6F
	Offset: 0x5A8
	Size: 0x463
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_zod", 15000, 15, 2);
	clientfield::register("toplayer", "player_stargate_fx", 15000, 1, "int", &player_stargate_fx, 0, 0);
	clientfield::register("toplayer", "player_light_exploder", 15000, 4, "int", &player_light_exploder, 0, 0);
	clientfield::register("world", "genesis_light_exposure", 15000, 1, "int", &genesis_light_exposure, 0, 0);
	clientfield::register("world", "power_pad_sheffield", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("world", "power_pad_prison", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("world", "power_pad_asylum", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("world", "power_pad_temple", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("toplayer", "hint_verruckt_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_verruckt_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_temple_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_temple_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_sheffield_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_sheffield_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_prison_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_prison_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
}

/*
	Name: player_stargate_fx
	Namespace: namespace_766d6099
	Checksum: 0x5B09EDD
	Offset: 0xA18
	Size: 0xDD
	Parameters: 7
	Flags: None
*/
function player_stargate_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("player_stargate_fx");
	self endon("player_stargate_fx");
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
		self notify("player_portal_complete");
	}
}

/*
	Name: function_e7a8756e
	Namespace: namespace_766d6099
	Checksum: 0x5924945F
	Offset: 0xB00
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
	Name: player_light_exploder
	Namespace: namespace_766d6099
	Checksum: 0x90F4CA8C
	Offset: 0xB58
	Size: 0x1DD
	Parameters: 7
	Flags: None
*/
function player_light_exploder(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			exploder::exploder("lgt_island_underside_sheff", localClientNum);
			break;
		}
		case 2:
		{
			exploder::stop_exploder("lgt_island_underside_sheff", localClientNum);
			break;
		}
		case 3:
		{
			exploder::exploder("lgt_island_underside_prison", localClientNum);
			break;
		}
		case 4:
		{
			exploder::stop_exploder("lgt_island_underside_prison", localClientNum);
			break;
		}
		case 5:
		{
			exploder::exploder("lgt_island_underside_asylum", localClientNum);
			break;
		}
		case 6:
		{
			exploder::stop_exploder("lgt_island_underside_asylum", localClientNum);
			break;
		}
		case 7:
		{
			exploder::exploder("lgt_island_underside_temple", localClientNum);
			break;
		}
		case 8:
		{
			exploder::stop_exploder("lgt_island_underside_temple", localClientNum);
			break;
		}
		case 9:
		{
			exploder::exploder("lgt_island_underside_proto", localClientNum);
			break;
		}
		case 10:
		{
			exploder::stop_exploder("lgt_island_underside_proto", localClientNum);
			break;
		}
	}
}

/*
	Name: genesis_light_exposure
	Namespace: namespace_766d6099
	Checksum: 0x146146C6
	Offset: 0xD40
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function genesis_light_exposure(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Name: function_44c843d5
	Namespace: namespace_766d6099
	Checksum: 0x25B6EC63
	Offset: 0xE00
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_44c843d5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		setstreamerrequest(localClientNum, fieldName);
	}
	else
	{
		clearstreamerrequest(localClientNum);
	}
}

/*
	Name: function_7e1ae25a
	Namespace: namespace_766d6099
	Checksum: 0xDC270E20
	Offset: 0xE88
	Size: 0x261
	Parameters: 7
	Flags: None
*/
function function_7e1ae25a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(fieldName)
	{
		case "power_pad_prison":
		{
			var_2cedcd81 = Array("fxexp_220", "fxexp_222", "fxexp_223", "lgt_power_prison");
			break;
		}
		case "power_pad_sheffield":
		{
			var_2cedcd81 = Array("fxexp_210", "fxexp_212", "fxexp_213", "lgt_power_sheffield");
			break;
		}
		case "power_pad_temple":
		{
			var_2cedcd81 = Array("fxexp_240", "fxexp_242", "fxexp_243", "lgt_power_temple");
			break;
		}
		case "power_pad_asylum":
		{
			var_2cedcd81 = Array("fxexp_230", "fxexp_232", "fxexp_233", "lgt_power_asylum");
			break;
		}
	}
	if(newVal)
	{
		foreach(str_exploder in var_2cedcd81)
		{
			exploder::exploder(str_exploder);
		}
		break;
	}
	foreach(str_exploder in var_2cedcd81)
	{
		exploder::stop_exploder(str_exploder);
	}
}

