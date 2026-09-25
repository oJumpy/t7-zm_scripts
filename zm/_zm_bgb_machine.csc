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
	level.var_962d1590 = 0.016;
	clientfield::register("zbarrier", "zm_bgb_machine", 1, 1, "int", &function_62051f89, 0, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_selection", 1, 8, "int", &function_3bb1978f, 1, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int", &function_f312291b, 0, 0);
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
	Name: function_62051f89
	Namespace: bgb_machine
	Checksum: 0xF86E5C92
	Offset: 0xE88
	Size: 0x3CB
	Parameters: 7
	Flags: Private
*/
function private function_62051f89(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_16139ac9))
	{
		return;
	}
	if(!isdefined(level.var_5081bd63))
	{
		level.var_5081bd63 = [];
	}
	Array::add(level.var_5081bd63, self);
	var_962d1590 = level.var_962d1590;
	level.var_962d1590 = level.var_962d1590 + 0.016;
	wait(var_962d1590);
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(level.var_10a6bc02))
	{
		pieceCount = self GetNumZBarrierPieces();
		for(i = 0; i < pieceCount; i++)
		{
			piece = self ZBarrierGetPiece(i);
			ForceStreamXModel(piece.model);
		}
		level.var_10a6bc02 = 1;
	}
	self.var_16139ac9 = [];
	self.var_16139ac9["tag_origin"] = [];
	self.var_16139ac9["tag_fx_light_lion_lft_eye_jnt"] = [];
	self.var_16139ac9["tag_fx_light_lion_rt_eye_jnt"] = [];
	self.var_16139ac9["tag_fx_light_top_jnt"] = [];
	self.var_16139ac9["tag_fx_light_side_lft_top_jnt"] = [];
	self.var_16139ac9["tag_fx_light_side_lft_mid_jnt"] = [];
	self.var_16139ac9["tag_fx_light_side_lft_btm_jnt"] = [];
	self.var_16139ac9["tag_fx_light_side_rt_top_jnt"] = [];
	self.var_16139ac9["tag_fx_light_side_rt_mid_jnt"] = [];
	self.var_16139ac9["tag_fx_light_side_rt_btm_jnt"] = [];
	self.var_16139ac9["tag_fx_glass_cntr_jnt"] = [];
	self.var_16139ac9["tag_gumball_ghost"] = [];
	self.var_6860c69f = [];
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_top_jnt";
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_side_lft_top_jnt";
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_side_lft_mid_jnt";
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_side_lft_btm_jnt";
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_side_rt_top_jnt";
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_side_rt_mid_jnt";
	self.var_6860c69f[self.var_6860c69f.size] = "tag_fx_light_side_rt_btm_jnt";
	self thread function_7cf480af(localClientNum, "closing", level._effect["zm_bgb_machine_flying_embers_down"]);
	self thread function_7cf480af(localClientNum, "opening", level._effect["zm_bgb_machine_flying_embers_up"]);
	self thread function_25c29799(localClientNum);
	self thread function_f27e16f6(localClientNum);
	self thread function_3939ad2f(localClientNum);
}

/*
	Name: function_3bb1978f
	Namespace: bgb_machine
	Checksum: 0x221F43A3
	Offset: 0x1260
	Size: 0x61
	Parameters: 7
	Flags: Private
*/
function private function_3bb1978f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!newVal)
	{
		return;
	}
	bgb = level.var_318929eb[newVal];
}

/*
	Name: function_8711c7b2
	Namespace: bgb_machine
	Checksum: 0x5162026D
	Offset: 0x12D0
	Size: 0xFF
	Parameters: 3
	Flags: Private
*/
function private function_8711c7b2(localClientNum, FX, piece)
{
	piece endon("opened");
	piece endon("closed");
	self.var_6860c69f = Array::randomize(self.var_6860c69f);
	for(i = 0; i < self.var_6860c69f.size; i++)
	{
		if(randomIntRange(0, 4))
		{
			PlayFXOnTag(localClientNum, FX, piece, self.var_6860c69f[i]);
		}
		wait_time = RandomFloatRange(0, 0.2);
		if(wait_time)
		{
			wait(wait_time);
		}
	}
}

/*
	Name: function_7cf480af
	Namespace: bgb_machine
	Checksum: 0x568D4594
	Offset: 0x13D8
	Size: 0x16F
	Parameters: 3
	Flags: Private
*/
function private function_7cf480af(localClientNum, notifyname, FX)
{
	var_3af6034f = self ZBarrierGetPiece(3);
	fx_piece = self ZBarrierGetPiece(5);
	for(;;)
	{
		var_3af6034f waittill(notifyname);
		tag_angles = fx_piece GetTagAngles("tag_fx_glass_cntr_jnt");
		playFX(localClientNum, FX, fx_piece GetTagOrigin("tag_fx_glass_cntr_jnt"), AnglesToForward(tag_angles), anglesToUp(tag_angles));
		playFX(localClientNum, level._effect["zm_bgb_machine_smoke"], self.origin);
		self thread function_8711c7b2(localClientNum, level._effect["zm_bgb_machine_bulb_spark"], fx_piece);
		wait(0.01);
	}
}

/*
	Name: function_25c29799
	Namespace: bgb_machine
	Checksum: 0x4A3F6CB9
	Offset: 0x1550
	Size: 0x313
	Parameters: 1
	Flags: Private
*/
function private function_25c29799(localClientNum)
{
	var_f3eb485b = self ZBarrierGetPiece(4);
	fx_piece = self ZBarrierGetPiece(5);
	for(;;)
	{
		function_5885778a(var_f3eb485b);
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(var_f3eb485b))
		{
			var_f3eb485b = self ZBarrierGetPiece(4);
			fx_piece = self ZBarrierGetPiece(5);
		}
		var_286fd1ed = self clientfield::get("zm_bgb_machine_selection");
		bgb = level.var_318929eb[var_286fd1ed];
		if(!isdefined(bgb))
		{
			continue;
		}
		self thread function_5f830538(localClientNum);
		PlayFXOnTag(localClientNum, level._effect["zm_bgb_machine_flying_elec"], fx_piece, "tag_fx_glass_cntr_jnt");
		var_f3eb485b HidePart(localClientNum, "tag_gumballs", "", 1);
		var_98ba48a2 = [];
		for(i = 0; i < level.var_98ba48a2[localClientNum].size; i++)
		{
			if(bgb == level.var_98ba48a2[localClientNum][i])
			{
				continue;
			}
			var_98ba48a2[var_98ba48a2.size] = level.var_98ba48a2[localClientNum][i];
		}
		for(i = 0; i < level.var_98ba48a2[localClientNum].size; i++)
		{
			var_98ba48a2[var_98ba48a2.size] = level.var_98ba48a2[localClientNum][i];
		}
		var_98ba48a2 = Array::randomize(var_98ba48a2);
		Array::push_front(var_98ba48a2, bgb);
		for(i = 0; i < 10; i++)
		{
			var_f3eb485b ShowPart(localClientNum, level.bgb[var_98ba48a2[i]].var_d3c80142 + "_" + i);
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
	Name: function_f27e16f6
	Namespace: bgb_machine
	Checksum: 0x9EB4133D
	Offset: 0x18B8
	Size: 0x17F
	Parameters: 1
	Flags: Private
*/
function private function_f27e16f6(localClientNum)
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
		var_286fd1ed = self clientfield::get("zm_bgb_machine_selection");
		bgb = level.var_318929eb[var_286fd1ed];
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
			piece ShowPart(localClientNum, level.bgb[bgb].var_ece14434);
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
	Name: function_3939ad2f
	Namespace: bgb_machine
	Checksum: 0x329CC8E6
	Offset: 0x1A70
	Size: 0x77
	Parameters: 1
	Flags: Private
*/
function private function_3939ad2f(localClientNum)
{
	piece = self ZBarrierGetPiece(1);
	for(;;)
	{
		piece waittill("opening");
		function_42630d5e(localClientNum, piece, "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"]);
		wait(0.01);
	}
}

/*
	Name: function_9b51ab0
	Namespace: bgb_machine
	Checksum: 0x830DBC28
	Offset: 0x1AF0
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private function_9b51ab0()
{
	var_286fd1ed = self clientfield::get("zm_bgb_machine_selection");
	bgb = level.var_318929eb[var_286fd1ed];
	switch(level.bgb[bgb].var_c9e64d65)
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
	Name: function_43d950d2
	Namespace: bgb_machine
	Checksum: 0x93521BB0
	Offset: 0x1BE0
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private function_43d950d2()
{
	var_286fd1ed = self clientfield::get("zm_bgb_machine_selection");
	bgb = level.var_318929eb[var_286fd1ed];
	switch(level.bgb[bgb].var_c9e64d65)
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
	Name: function_42630d5e
	Namespace: bgb_machine
	Checksum: 0xB1E36F70
	Offset: 0x1CD0
	Size: 0xD7
	Parameters: 5
	Flags: Private
*/
function private function_42630d5e(localClientNum, piece, tag, FX, deleteImmediate)
{
	if(!isdefined(deleteImmediate))
	{
		deleteImmediate = 1;
	}
	if(isdefined(self.var_16139ac9[tag][localClientNum]))
	{
		deletefx(localClientNum, self.var_16139ac9[tag][localClientNum], deleteImmediate);
		self.var_16139ac9[tag][localClientNum] = undefined;
	}
	if(isdefined(FX))
	{
		self.var_16139ac9[tag][localClientNum] = PlayFXOnTag(localClientNum, FX, piece, tag);
	}
}

/*
	Name: function_e5bc89d2
	Namespace: bgb_machine
	Checksum: 0x57F88F67
	Offset: 0x1DB0
	Size: 0x43
	Parameters: 3
	Flags: Private
*/
function private function_e5bc89d2(localClientNum, piece, FX)
{
	function_42630d5e(localClientNum, piece, "tag_fx_light_top_jnt", FX);
}

/*
	Name: function_cb90ea4e
	Namespace: bgb_machine
	Checksum: 0xE976FE0C
	Offset: 0x1E00
	Size: 0x6B
	Parameters: 3
	Flags: Private
*/
function private function_cb90ea4e(localClientNum, piece, FX)
{
	function_42630d5e(localClientNum, piece, "tag_fx_light_side_lft_top_jnt", FX);
	function_42630d5e(localClientNum, piece, "tag_fx_light_side_rt_top_jnt", FX);
}

/*
	Name: function_47c2c4a1
	Namespace: bgb_machine
	Checksum: 0x46228CA6
	Offset: 0x1E78
	Size: 0x6B
	Parameters: 3
	Flags: Private
*/
function private function_47c2c4a1(localClientNum, piece, FX)
{
	function_42630d5e(localClientNum, piece, "tag_fx_light_side_lft_mid_jnt", FX);
	function_42630d5e(localClientNum, piece, "tag_fx_light_side_rt_mid_jnt", FX);
}

/*
	Name: function_3c131c80
	Namespace: bgb_machine
	Checksum: 0x15AC5003
	Offset: 0x1EF0
	Size: 0x6B
	Parameters: 3
	Flags: Private
*/
function private function_3c131c80(localClientNum, piece, FX)
{
	function_42630d5e(localClientNum, piece, "tag_fx_light_side_lft_btm_jnt", FX);
	function_42630d5e(localClientNum, piece, "tag_fx_light_side_rt_btm_jnt", FX);
}

/*
	Name: function_38aeb872
	Namespace: bgb_machine
	Checksum: 0x4404DCD8
	Offset: 0x1F68
	Size: 0x9B
	Parameters: 3
	Flags: Private
*/
function private function_38aeb872(localClientNum, piece, FX)
{
	function_e5bc89d2(localClientNum, piece, FX);
	function_cb90ea4e(localClientNum, piece, FX);
	function_47c2c4a1(localClientNum, piece, FX);
	function_3c131c80(localClientNum, piece, FX);
}

/*
	Name: function_8bca2811
	Namespace: bgb_machine
	Checksum: 0xB691EEF7
	Offset: 0x2010
	Size: 0x63
	Parameters: 3
	Flags: Private
*/
function private function_8bca2811(localClientNum, entity, alias)
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
	self function_42630d5e(localClientNum, self ZBarrierGetPiece(5), "tag_origin", undefined);
}

/*
	Name: function_eb5b80c5
	Namespace: bgb_machine
	Checksum: 0x62D16D2
	Offset: 0x20D0
	Size: 0xA3
	Parameters: 1
	Flags: Private
*/
function private function_eb5b80c5(localClientNum)
{
	self notify("hash_fff2ccd6");
	self endon("hash_fff2ccd6");
	self function_38aeb872(localClientNum, self ZBarrierGetPiece(5), undefined);
	self function_42630d5e(localClientNum, self ZBarrierGetPiece(5), "tag_origin", level._effect["zm_bgb_machine_available"]);
}

/*
	Name: function_63a14f25
	Namespace: bgb_machine
	Checksum: 0xA9376D4B
	Offset: 0x2180
	Size: 0xCD
	Parameters: 5
	Flags: Private
*/
function private function_63a14f25(localClientNum, piece, FX, flash_time, alias)
{
	self notify("hash_fff2ccd6");
	self endon("hash_fff2ccd6");
	function_d5f882d0(localClientNum);
	for(;;)
	{
		function_38aeb872(localClientNum, piece, FX);
		if(isdefined(alias))
		{
			function_8bca2811(localClientNum, piece, alias);
		}
		wait(flash_time);
		function_38aeb872(localClientNum, piece, undefined);
		wait(flash_time);
	}
}

/*
	Name: function_d0281a17
	Namespace: bgb_machine
	Checksum: 0xD4F806F1
	Offset: 0x2258
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private function_d0281a17(localClientNum)
{
	self thread function_63a14f25(localClientNum, self ZBarrierGetPiece(5), self function_43d950d2(), 0.4, "zmb_bgb_machine_light_ready");
}

/*
	Name: function_5f830538
	Namespace: bgb_machine
	Checksum: 0x47301EA5
	Offset: 0x22C8
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private function_5f830538(localClientNum)
{
	self thread function_63a14f25(localClientNum, self ZBarrierGetPiece(5), level._effect["zm_bgb_machine_bulb_available"], 0.2, "zmb_bgb_machine_light_click");
}

/*
	Name: function_9e064c6
	Namespace: bgb_machine
	Checksum: 0xB3A8ED9E
	Offset: 0x2338
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private function_9e064c6(localClientNum)
{
	self thread function_63a14f25(localClientNum, self ZBarrierGetPiece(1), level._effect["zm_bgb_machine_bulb_away"], 0.4, "zmb_bgb_machine_light_leaving");
}

/*
	Name: function_dec3df0b
	Namespace: bgb_machine
	Checksum: 0x7AC62F10
	Offset: 0x23A8
	Size: 0x73
	Parameters: 1
	Flags: Private
*/
function private function_dec3df0b(localClientNum)
{
	self notify("hash_fff2ccd6");
	function_d5f882d0(localClientNum);
	function_38aeb872(localClientNum, self ZBarrierGetPiece(5), level._effect["zm_bgb_machine_bulb_away"]);
}

/*
	Name: function_f312291b
	Namespace: bgb_machine
	Checksum: 0x43AA040D
	Offset: 0x2428
	Size: 0x38B
	Parameters: 7
	Flags: Private
*/
function private function_f312291b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_62051f89(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	if(!isdefined(self))
	{
		return;
	}
	var_d6b4bc51 = undefined;
	var_56e169c3 = undefined;
	switch(newVal)
	{
		case 1:
		{
			function_42630d5e(localClientNum, self ZBarrierGetPiece(5), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior_away"]);
			self thread function_dec3df0b(localClientNum);
			break;
		}
		case 2:
		{
			var_d6b4bc51 = level._effect["zm_bgb_machine_eye_away"];
			var_5324e4f7 = self ZBarrierGetPiece(1);
			self thread function_9e064c6(localClientNum);
			break;
		}
		case 3:
		{
			var_56e169c3 = level._effect["zm_bgb_machine_light_interior"];
			var_5c057e0d = self ZBarrierGetPiece(5);
			var_d6b4bc51 = function_9b51ab0();
			var_5324e4f7 = self ZBarrierGetPiece(2);
			self thread function_d0281a17(localClientNum);
			if(self clientfield::get("zm_bgb_machine_ghost_ball"))
			{
				function_42630d5e(localClientNum, var_5324e4f7, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_ghost"]);
			}
			else
			{
				function_42630d5e(localClientNum, var_5324e4f7, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_halo"]);
			}
			break;
		}
		case 4:
		{
			function_42630d5e(localClientNum, self ZBarrierGetPiece(5), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"]);
			self thread function_eb5b80c5(localClientNum);
			var_58d675a8 = self ZBarrierGetPiece(2);
			function_42630d5e(localClientNum, var_58d675a8, "tag_gumball_ghost", undefined, 0);
			break;
		}
	}
	function_42630d5e(localClientNum, var_5324e4f7, "tag_fx_light_lion_lft_eye_jnt", var_d6b4bc51);
	function_42630d5e(localClientNum, var_5324e4f7, "tag_fx_light_lion_rt_eye_jnt", var_d6b4bc51);
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
	if(!isdefined(level.var_6cb6a683))
	{
		level.var_6cb6a683 = 3;
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
	if(!isdefined(level.var_6c7a96b4))
	{
		level.var_6c7a96b4 = &function_6c7a96b4;
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
		if(isdefined(level.var_5081bd63))
		{
			foreach(machine in level.var_5081bd63)
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
	cost = [[level.var_6c7a96b4]](self, base_cost, buys, rounds, firesale);
	function_1bfbfeb3(localClientNum, cost);
}

/*
	Name: function_6c7a96b4
	Namespace: bgb_machine
	Checksum: 0x5353186D
	Offset: 0x2E38
	Size: 0x1C7
	Parameters: 5
	Flags: None
*/
function function_6c7a96b4(player, base_cost, buys, rounds, firesale)
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

