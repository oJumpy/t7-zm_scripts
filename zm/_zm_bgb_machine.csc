#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_bgb;

#namespace bgb_machine;

/*
	Name: __init__sytem__
	Namespace: bgb_machine
	Checksum: 0xE3EA3E58
	Offset: 0x980
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb_machine", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bgb_machine
	Checksum: 0x587388D8
	Offset: 0x9C0
	Size: 0x4BB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level.staggered_start = 0.016;
	clientfield::register("zbarrier", "zm_bgb_machine", 1, 1, "int", &bgb_machine_init, 0, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_selection", 1, 8, "int", &bgb_machine_selection, 1, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int", &bgb_machine_fx_state, 0, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "zm_bgb_machine_round_buys", 10000, 3, "int", &function_27a93844, 0, 0);
	level._effect["zm_bgb_machine_eye_away"] = "zombie/fx_bgb_machine_eye_away_zmb";
	level._effect["zm_bgb_machine_eye_activated"] = "zombie/fx_bgb_machine_eye_activated_zmb";
	level._effect["zm_bgb_machine_eye_event"] = "zombie/fx_bgb_machine_eye_event_zmb";
	level._effect["zm_bgb_machine_eye_rounds"] = "zombie/fx_bgb_machine_eye_rounds_zmb";
	level._effect["zm_bgb_machine_eye_time"] = "zombie/fx_bgb_machine_eye_time_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_available"]))
	{
		level._effect["zm_bgb_machine_available"] = "zombie/fx_bgb_machine_available_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_away"]))
	{
		level._effect["zm_bgb_machine_bulb_away"] = "zombie/fx_bgb_machine_bulb_away_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_available"]))
	{
		level._effect["zm_bgb_machine_bulb_available"] = "zombie/fx_bgb_machine_bulb_available_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_activated"]))
	{
		level._effect["zm_bgb_machine_bulb_activated"] = "zombie/fx_bgb_machine_bulb_activated_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_event"]))
	{
		level._effect["zm_bgb_machine_bulb_event"] = "zombie/fx_bgb_machine_bulb_event_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_rounds"]))
	{
		level._effect["zm_bgb_machine_bulb_rounds"] = "zombie/fx_bgb_machine_bulb_rounds_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_time"]))
	{
		level._effect["zm_bgb_machine_bulb_time"] = "zombie/fx_bgb_machine_bulb_time_zmb";
	}
	level._effect["zm_bgb_machine_bulb_spark"] = "zombie/fx_bgb_machine_bulb_spark_zmb";
	level._effect["zm_bgb_machine_flying_elec"] = "zombie/fx_bgb_machine_flying_elec_zmb";
	level._effect["zm_bgb_machine_flying_embers_down"] = "zombie/fx_bgb_machine_flying_embers_down_zmb";
	level._effect["zm_bgb_machine_flying_embers_up"] = "zombie/fx_bgb_machine_flying_embers_up_zmb";
	level._effect["zm_bgb_machine_smoke"] = "zombie/fx_bgb_machine_smoke_zmb";
	level._effect["zm_bgb_machine_gumball_halo"] = "zombie/fx_bgb_machine_gumball_halo_zmb";
	level._effect["zm_bgb_machine_gumball_ghost"] = "zombie/fx_bgb_gumball_ghost_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_light_interior"]))
	{
		level._effect["zm_bgb_machine_light_interior"] = "zombie/fx_bgb_machine_light_interior_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_light_interior_away"]))
	{
		level._effect["zm_bgb_machine_light_interior_away"] = "zombie/fx_bgb_machine_light_interior_away_zmb";
	}
	function_b90b22b6();
}

/*
	Name: bgb_machine_init
	Namespace: bgb_machine
	Checksum: 0xF86E5C92
	Offset: 0xE88
	Size: 0x3CB
	Parameters: 7
	Flags: Private
*/
function private bgb_machine_init(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.bgb_machine_fx))
	{
		return;
	}
	if(!isdefined(level.bgb_machines))
	{
		level.bgb_machines = [];
	}
	Array::add(level.bgb_machines, self);
	staggered_start = level.staggered_start;
	level.staggered_start = level.staggered_start + 0.016;
	wait(staggered_start);
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(level.bgb_machine_streamer_forced))
	{
		pieceCount = self GetNumZBarrierPieces();
		for(i = 0; i < pieceCount; i++)
		{
			piece = self ZBarrierGetPiece(i);
			ForceStreamXModel(piece.model);
		}
		level.bgb_machine_streamer_forced = 1;
	}
	self.bgb_machine_fx = [];
	self.bgb_machine_fx["tag_origin"] = [];
	self.bgb_machine_fx["tag_fx_light_lion_lft_eye_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_lion_rt_eye_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_mid_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_btm_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_mid_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_btm_jnt"] = [];
	self.bgb_machine_fx["tag_fx_glass_cntr_jnt"] = [];
	self.bgb_machine_fx["tag_gumball_ghost"] = [];
	self.bgb_machine_fx_bulb_tags = [];
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_mid_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_btm_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_mid_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_btm_jnt";
	self thread bgb_machine_flying_ember_think(localClientNum, "closing", level._effect["zm_bgb_machine_flying_embers_down"]);
	self thread bgb_machine_flying_ember_think(localClientNum, "opening", level._effect["zm_bgb_machine_flying_embers_up"]);
	self thread bgb_machine_flying_gumballs_think(localClientNum);
	self thread bgb_machine_give_gumball_think(localClientNum);
	self thread bgb_machine_interior_light_shake_piece_think(localClientNum);
}

/*
	Name: bgb_machine_selection
	Namespace: bgb_machine
	Checksum: 0x221F43A3
	Offset: 0x1260
	Size: 0x61
	Parameters: 7
	Flags: Private
*/
function private bgb_machine_selection(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!newVal)
	{
		return;
	}
	bgb = level.bgb_item_index_to_name[newVal];
}

/*
	Name: bgb_machine_play_random_sparks
	Namespace: bgb_machine
	Checksum: 0x5162026D
	Offset: 0x12D0
	Size: 0xFF
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_random_sparks(localClientNum, FX, piece)
{
	piece endon("opened");
	piece endon("closed");
	self.bgb_machine_fx_bulb_tags = Array::randomize(self.bgb_machine_fx_bulb_tags);
	for(i = 0; i < self.bgb_machine_fx_bulb_tags.size; i++)
	{
		if(randomIntRange(0, 4))
		{
			PlayFXOnTag(localClientNum, FX, piece, self.bgb_machine_fx_bulb_tags[i]);
		}
		wait_time = RandomFloatRange(0, 0.2);
		if(wait_time)
		{
			wait(wait_time);
		}
	}
}

/*
	Name: bgb_machine_flying_ember_think
	Namespace: bgb_machine
	Checksum: 0x568D4594
	Offset: 0x13D8
	Size: 0x16F
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_flying_ember_think(localClientNum, notifyname, FX)
{
	listen_piece = self ZBarrierGetPiece(3);
	fx_piece = self ZBarrierGetPiece(5);
	for(;;)
	{
		listen_piece waittill(notifyname);
		tag_angles = fx_piece GetTagAngles("tag_fx_glass_cntr_jnt");
		playFX(localClientNum, FX, fx_piece GetTagOrigin("tag_fx_glass_cntr_jnt"), AnglesToForward(tag_angles), anglesToUp(tag_angles));
		playFX(localClientNum, level._effect["zm_bgb_machine_smoke"], self.origin);
		self thread bgb_machine_play_random_sparks(localClientNum, level._effect["zm_bgb_machine_bulb_spark"], fx_piece);
		wait(0.01);
	}
}

/*
	Name: bgb_machine_flying_gumballs_think
	Namespace: bgb_machine
	Checksum: 0x4A3F6CB9
	Offset: 0x1550
	Size: 0x313
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_flying_gumballs_think(localClientNum)
{
	gumballs_piece = self ZBarrierGetPiece(4);
	fx_piece = self ZBarrierGetPiece(5);
	for(;;)
	{
		function_5885778a(gumballs_piece);
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(gumballs_piece))
		{
			gumballs_piece = self ZBarrierGetPiece(4);
			fx_piece = self ZBarrierGetPiece(5);
		}
		bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
		bgb = level.bgb_item_index_to_name[bgb_item_index];
		if(!isdefined(bgb))
		{
			continue;
		}
		self thread bgb_machine_bulb_flash_selecting(localClientNum);
		PlayFXOnTag(localClientNum, level._effect["zm_bgb_machine_flying_elec"], fx_piece, "tag_fx_glass_cntr_jnt");
		gumballs_piece HidePart(localClientNum, "tag_gumballs", "", 1);
		bgb_pack = [];
		for(i = 0; i < level.bgb_pack[localClientNum].size; i++)
		{
			if(bgb == level.bgb_pack[localClientNum][i])
			{
				continue;
			}
			bgb_pack[bgb_pack.size] = level.bgb_pack[localClientNum][i];
		}
		for(i = 0; i < level.bgb_pack[localClientNum].size; i++)
		{
			bgb_pack[bgb_pack.size] = level.bgb_pack[localClientNum][i];
		}
		bgb_pack = Array::randomize(bgb_pack);
		Array::push_front(bgb_pack, bgb);
		for(i = 0; i < 10; i++)
		{
			gumballs_piece ShowPart(localClientNum, level.bgb[bgb_pack[i]].flying_gumball_tag + "_" + i);
		}
		wait(0.01);
	}
}

/*
	Name: function_5885778a
	Namespace: bgb_machine
	Checksum: 0x5C4AF776
	Offset: 0x1870
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_5885778a(piece)
{
	level endon("demo_jump");
	piece util::waittill_any("opening", "closing");
}

/*
	Name: bgb_machine_give_gumball_think
	Namespace: bgb_machine
	Checksum: 0x9EB4133D
	Offset: 0x18B8
	Size: 0x17F
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_give_gumball_think(localClientNum)
{
	piece = self ZBarrierGetPiece(2);
	while(isdefined(self))
	{
		function_36a807de(piece);
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(piece))
		{
			piece = self ZBarrierGetPiece(2);
		}
		bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
		bgb = level.bgb_item_index_to_name[bgb_item_index];
		if(!isdefined(bgb))
		{
			continue;
		}
		piece HidePart(localClientNum, "tag_gumballs", "", 1);
		if(self clientfield::get("zm_bgb_machine_ghost_ball"))
		{
			piece ShowPart(localClientNum, "tag_gumball_ghost");
		}
		else
		{
			piece ShowPart(localClientNum, level.bgb[bgb].give_gumball_tag);
		}
		wait(0.01);
	}
}

/*
	Name: function_36a807de
	Namespace: bgb_machine
	Checksum: 0x9FECF8F6
	Offset: 0x1A40
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function function_36a807de(piece)
{
	level endon("demo_jump");
	piece waittill("opening");
}

/*
	Name: bgb_machine_interior_light_shake_piece_think
	Namespace: bgb_machine
	Checksum: 0x329CC8E6
	Offset: 0x1A70
	Size: 0x77
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_interior_light_shake_piece_think(localClientNum)
{
	piece = self ZBarrierGetPiece(1);
	for(;;)
	{
		piece waittill("opening");
		bgb_machine_play_fx(localClientNum, piece, "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"]);
		wait(0.01);
	}
}

/*
	Name: bgb_machine_get_eye_fx_for_selected_bgb
	Namespace: bgb_machine
	Checksum: 0x830DBC28
	Offset: 0x1AF0
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private bgb_machine_get_eye_fx_for_selected_bgb()
{
	bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
	bgb = level.bgb_item_index_to_name[bgb_item_index];
	switch(level.bgb[bgb].limit_type)
	{
		case "activated":
		{
			return level._effect["zm_bgb_machine_eye_activated"];
		}
		case "event":
		{
			return level._effect["zm_bgb_machine_eye_event"];
		}
		case "rounds":
		{
			return level._effect["zm_bgb_machine_eye_rounds"];
		}
		case "time":
		{
			return level._effect["zm_bgb_machine_eye_time"];
		}
	}
	return undefined;
}

/*
	Name: bgb_machine_get_bulb_fx_for_selected_bgb
	Namespace: bgb_machine
	Checksum: 0x93521BB0
	Offset: 0x1BE0
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private bgb_machine_get_bulb_fx_for_selected_bgb()
{
	bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
	bgb = level.bgb_item_index_to_name[bgb_item_index];
	switch(level.bgb[bgb].limit_type)
	{
		case "activated":
		{
			return level._effect["zm_bgb_machine_bulb_activated"];
		}
		case "event":
		{
			return level._effect["zm_bgb_machine_bulb_event"];
		}
		case "rounds":
		{
			return level._effect["zm_bgb_machine_bulb_rounds"];
		}
		case "time":
		{
			return level._effect["zm_bgb_machine_bulb_time"];
		}
	}
	return undefined;
}

/*
	Name: bgb_machine_play_fx
	Namespace: bgb_machine
	Checksum: 0xB1E36F70
	Offset: 0x1CD0
	Size: 0xD7
	Parameters: 5
	Flags: Private
*/
function private bgb_machine_play_fx(localClientNum, piece, tag, FX, deleteImmediate)
{
	if(!isdefined(deleteImmediate))
	{
		deleteImmediate = 1;
	}
	if(isdefined(self.bgb_machine_fx[tag][localClientNum]))
	{
		deletefx(localClientNum, self.bgb_machine_fx[tag][localClientNum], deleteImmediate);
		self.bgb_machine_fx[tag][localClientNum] = undefined;
	}
	if(isdefined(FX))
	{
		self.bgb_machine_fx[tag][localClientNum] = PlayFXOnTag(localClientNum, FX, piece, tag);
	}
}

/*
	Name: bgb_machine_play_top_fx
	Namespace: bgb_machine
	Checksum: 0x57F88F67
	Offset: 0x1DB0
	Size: 0x43
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_top_fx(localClientNum, piece, FX)
{
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_top_jnt", FX);
}

/*
	Name: bgb_machine_play_top_side_fx
	Namespace: bgb_machine
	Checksum: 0xE976FE0C
	Offset: 0x1E00
	Size: 0x6B
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_top_side_fx(localClientNum, piece, FX)
{
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_side_lft_top_jnt", FX);
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_side_rt_top_jnt", FX);
}

/*
	Name: bgb_machine_play_mid_side_fx
	Namespace: bgb_machine
	Checksum: 0x46228CA6
	Offset: 0x1E78
	Size: 0x6B
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_mid_side_fx(localClientNum, piece, FX)
{
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_side_lft_mid_jnt", FX);
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_side_rt_mid_jnt", FX);
}

/*
	Name: bgb_machine_play_btm_side_fx
	Namespace: bgb_machine
	Checksum: 0x15AC5003
	Offset: 0x1EF0
	Size: 0x6B
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_btm_side_fx(localClientNum, piece, FX)
{
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_side_lft_btm_jnt", FX);
	bgb_machine_play_fx(localClientNum, piece, "tag_fx_light_side_rt_btm_jnt", FX);
}

/*
	Name: bgb_machine_play_all_bulb_fx
	Namespace: bgb_machine
	Checksum: 0x4404DCD8
	Offset: 0x1F68
	Size: 0x9B
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_all_bulb_fx(localClientNum, piece, FX)
{
	bgb_machine_play_top_fx(localClientNum, piece, FX);
	bgb_machine_play_top_side_fx(localClientNum, piece, FX);
	bgb_machine_play_mid_side_fx(localClientNum, piece, FX);
	bgb_machine_play_btm_side_fx(localClientNum, piece, FX);
}

/*
	Name: bgb_machine_play_sound
	Namespace: bgb_machine
	Checksum: 0xB691EEF7
	Offset: 0x2010
	Size: 0x63
	Parameters: 3
	Flags: Private
*/
function private bgb_machine_play_sound(localClientNum, entity, alias)
{
	origin = entity GetTagOrigin("tag_fx_light_top_jnt");
	playsound(localClientNum, alias, origin);
}

/*
	Name: function_d5f882d0
	Namespace: bgb_machine
	Checksum: 0x7740EBF
	Offset: 0x2080
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_d5f882d0(localClientNum)
{
	self bgb_machine_play_fx(localClientNum, self ZBarrierGetPiece(5), "tag_origin", undefined);
}

/*
	Name: bgb_machine_bulb_pattern
	Namespace: bgb_machine
	Checksum: 0x62D16D2
	Offset: 0x20D0
	Size: 0xA3
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_bulb_pattern(localClientNum)
{
	self notify("bgb_machine_bulb_fx_start");
	self endon("bgb_machine_bulb_fx_start");
	self bgb_machine_play_all_bulb_fx(localClientNum, self ZBarrierGetPiece(5), undefined);
	self bgb_machine_play_fx(localClientNum, self ZBarrierGetPiece(5), "tag_origin", level._effect["zm_bgb_machine_available"]);
}

/*
	Name: bgb_machine_bulb_flash
	Namespace: bgb_machine
	Checksum: 0xA9376D4B
	Offset: 0x2180
	Size: 0xCD
	Parameters: 5
	Flags: Private
*/
function private bgb_machine_bulb_flash(localClientNum, piece, FX, flash_time, alias)
{
	self notify("bgb_machine_bulb_fx_start");
	self endon("bgb_machine_bulb_fx_start");
	function_d5f882d0(localClientNum);
	for(;;)
	{
		bgb_machine_play_all_bulb_fx(localClientNum, piece, FX);
		if(isdefined(alias))
		{
			bgb_machine_play_sound(localClientNum, piece, alias);
		}
		wait(flash_time);
		bgb_machine_play_all_bulb_fx(localClientNum, piece, undefined);
		wait(flash_time);
	}
}

/*
	Name: bgb_machine_bulb_flash_selected_bgb
	Namespace: bgb_machine
	Checksum: 0xD4F806F1
	Offset: 0x2258
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_bulb_flash_selected_bgb(localClientNum)
{
	self thread bgb_machine_bulb_flash(localClientNum, self ZBarrierGetPiece(5), self bgb_machine_get_bulb_fx_for_selected_bgb(), 0.4, "zmb_bgb_machine_light_ready");
}

/*
	Name: bgb_machine_bulb_flash_selecting
	Namespace: bgb_machine
	Checksum: 0x47301EA5
	Offset: 0x22C8
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_bulb_flash_selecting(localClientNum)
{
	self thread bgb_machine_bulb_flash(localClientNum, self ZBarrierGetPiece(5), level._effect["zm_bgb_machine_bulb_available"], 0.2, "zmb_bgb_machine_light_click");
}

/*
	Name: bgb_machine_bulb_flash_away
	Namespace: bgb_machine
	Checksum: 0xB3A8ED9E
	Offset: 0x2338
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_bulb_flash_away(localClientNum)
{
	self thread bgb_machine_bulb_flash(localClientNum, self ZBarrierGetPiece(1), level._effect["zm_bgb_machine_bulb_away"], 0.4, "zmb_bgb_machine_light_leaving");
}

/*
	Name: bgb_machine_bulb_solid_away
	Namespace: bgb_machine
	Checksum: 0x7AC62F10
	Offset: 0x23A8
	Size: 0x73
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_bulb_solid_away(localClientNum)
{
	self notify("bgb_machine_bulb_fx_start");
	function_d5f882d0(localClientNum);
	bgb_machine_play_all_bulb_fx(localClientNum, self ZBarrierGetPiece(5), level._effect["zm_bgb_machine_bulb_away"]);
}

/*
	Name: bgb_machine_fx_state
	Namespace: bgb_machine
	Checksum: 0x43AA040D
	Offset: 0x2428
	Size: 0x38B
	Parameters: 7
	Flags: Private
*/
function private bgb_machine_fx_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	bgb_machine_init(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	if(!isdefined(self))
	{
		return;
	}
	eye_fx = undefined;
	light_interior_fx = undefined;
	switch(newVal)
	{
		case 1:
		{
			bgb_machine_play_fx(localClientNum, self ZBarrierGetPiece(5), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior_away"]);
			self thread bgb_machine_bulb_solid_away(localClientNum);
			break;
		}
		case 2:
		{
			eye_fx = level._effect["zm_bgb_machine_eye_away"];
			eye_piece = self ZBarrierGetPiece(1);
			self thread bgb_machine_bulb_flash_away(localClientNum);
			break;
		}
		case 3:
		{
			light_interior_fx = level._effect["zm_bgb_machine_light_interior"];
			light_interior_piece = self ZBarrierGetPiece(5);
			eye_fx = bgb_machine_get_eye_fx_for_selected_bgb();
			eye_piece = self ZBarrierGetPiece(2);
			self thread bgb_machine_bulb_flash_selected_bgb(localClientNum);
			if(self clientfield::get("zm_bgb_machine_ghost_ball"))
			{
				bgb_machine_play_fx(localClientNum, eye_piece, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_ghost"]);
			}
			else
			{
				bgb_machine_play_fx(localClientNum, eye_piece, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_halo"]);
			}
			break;
		}
		case 4:
		{
			bgb_machine_play_fx(localClientNum, self ZBarrierGetPiece(5), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"]);
			self thread bgb_machine_bulb_pattern(localClientNum);
			halo_piece = self ZBarrierGetPiece(2);
			bgb_machine_play_fx(localClientNum, halo_piece, "tag_gumball_ghost", undefined, 0);
			break;
		}
	}
	bgb_machine_play_fx(localClientNum, eye_piece, "tag_fx_light_lion_lft_eye_jnt", eye_fx);
	bgb_machine_play_fx(localClientNum, eye_piece, "tag_fx_light_lion_rt_eye_jnt", eye_fx);
}

/*
	Name: function_b90b22b6
	Namespace: bgb_machine
	Checksum: 0xED282766
	Offset: 0x27C0
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function function_b90b22b6()
{
	if(!isdefined(level.bgb_machine_max_uses_per_round))
	{
		level.bgb_machine_max_uses_per_round = 3;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_a3e3127d))
	{
		level.var_a3e3127d = 2;
	}
	if(!isdefined(level.var_8ef45dc2))
	{
		level.var_8ef45dc2 = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	if(!isdefined(level.var_bb2b3f61))
	{
		level.var_bb2b3f61 = [];
	}
	if(!isdefined(level.var_32948a58))
	{
		level.var_32948a58 = [];
	}
	if(!isdefined(level.var_f26edb66))
	{
		level.var_f26edb66 = [];
	}
	if(!isdefined(level.bgb_machine_calc_player_cost))
	{
		level.bgb_machine_calc_player_cost = &bgb_machine_calc_player_cost;
	}
	callback::on_localplayer_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: bgb_machine
	Checksum: 0x6EB53440
	Offset: 0x28E8
	Size: 0xFB
	Parameters: 1
	Flags: Private
*/
function private on_player_spawned(localClientNum)
{
	if(!isdefined(level.var_bb2b3f61[localClientNum]))
	{
		level.var_bb2b3f61[localClientNum] = 0;
	}
	if(!isdefined(level.var_32948a58[localClientNum]))
	{
		level.var_32948a58[localClientNum] = 0;
	}
	if(!isdefined(level.var_f26edb66[localClientNum]))
	{
		level.var_f26edb66[localClientNum] = 0;
	}
	function_725214c(localClientNum, level.var_bb2b3f61[localClientNum], level.var_32948a58[localClientNum], level.var_f26edb66[localClientNum]);
	self thread function_763ef0fd(localClientNum);
	self thread function_5d9d13da(localClientNum);
	self thread function_fda54943(localClientNum);
}

/*
	Name: function_763ef0fd
	Namespace: bgb_machine
	Checksum: 0x67486D7A
	Offset: 0x29F0
	Size: 0xCD
	Parameters: 1
	Flags: Private
*/
function private function_763ef0fd(localClientNum)
{
	self notify("hash_763ef0fd");
	self endon("hash_763ef0fd");
	self endon("entityshutdown");
	while(1)
	{
		rounds = getRoundsPlayed(localClientNum);
		if(rounds != level.var_bb2b3f61[localClientNum])
		{
			level.var_bb2b3f61[localClientNum] = rounds;
			function_725214c(localClientNum, level.var_bb2b3f61[localClientNum], level.var_32948a58[localClientNum], level.var_f26edb66[localClientNum]);
		}
		wait(1);
	}
}

/*
	Name: function_5d9d13da
	Namespace: bgb_machine
	Checksum: 0xCD47F3D6
	Offset: 0x2AC8
	Size: 0xBF
	Parameters: 1
	Flags: Private
*/
function private function_5d9d13da(localClientNum)
{
	self notify("hash_5d9d13da");
	self endon("hash_5d9d13da");
	self endon("entityshutdown");
	while(1)
	{
		self waittill("powerup", powerup, State);
		if(powerup == "powerup_fire_sale")
		{
			level.var_f26edb66[localClientNum] = State;
			function_725214c(localClientNum, level.var_bb2b3f61[localClientNum], level.var_32948a58[localClientNum], level.var_f26edb66[localClientNum]);
		}
	}
}

/*
	Name: function_fda54943
	Namespace: bgb_machine
	Checksum: 0xF65EAE22
	Offset: 0x2B90
	Size: 0x16D
	Parameters: 1
	Flags: Private
*/
function private function_fda54943(localClientNum)
{
	self endon("entityshutdown");
	var_89caac36 = 160000;
	while(1)
	{
		if(isdefined(level.bgb_machines))
		{
			foreach(machine in level.bgb_machines)
			{
				if(DistanceSquared(self.origin, machine.origin) <= var_89caac36 && 96 > Abs(self.origin[2] - machine.origin[2]))
				{
					wait(randomIntRange(1, 4));
					machine playsound(localClientNum, "zmb_bgb_lionhead_roar");
					wait(130);
					break;
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_27a93844
	Namespace: bgb_machine
	Checksum: 0x717F7168
	Offset: 0x2D08
	Size: 0x8B
	Parameters: 7
	Flags: Private
*/
function private function_27a93844(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level.var_32948a58[localClientNum] = newVal;
	function_725214c(localClientNum, level.var_bb2b3f61[localClientNum], level.var_32948a58[localClientNum], level.var_f26edb66[localClientNum]);
}

/*
	Name: function_725214c
	Namespace: bgb_machine
	Checksum: 0x1935A457
	Offset: 0x2DA0
	Size: 0x8B
	Parameters: 4
	Flags: Private
*/
function private function_725214c(localClientNum, rounds, buys, firesale)
{
	base_cost = 500;
	if(firesale)
	{
		base_cost = 10;
	}
	cost = [[level.bgb_machine_calc_player_cost]](self, base_cost, buys, rounds, firesale);
	setbgbcost(localClientNum, cost);
}

/*
	Name: bgb_machine_calc_player_cost
	Namespace: bgb_machine
	Checksum: 0x5353186D
	Offset: 0x2E38
	Size: 0x1C7
	Parameters: 5
	Flags: None
*/
function bgb_machine_calc_player_cost(player, base_cost, buys, rounds, firesale)
{
	if(buys < 1 && GetDvarInt("scr_firstGumFree") === 1)
	{
		return 0;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	cost = 500;
	if(buys >= 1)
	{
		var_33ea806b = floor(rounds / level.var_e1dee7ba);
		var_33ea806b = math::clamp(var_33ea806b, 0, level.var_8ef45dc2);
		var_39a90c5a = pow(level.var_a3e3127d, var_33ea806b);
		cost = cost + level.var_f02c5598 * var_39a90c5a;
	}
	if(buys >= 2)
	{
		cost = cost * level.var_1485dcdc;
	}
	cost = Int(cost);
	if(500 != base_cost)
	{
		cost = cost - 500 - base_cost;
	}
	return cost;
}

