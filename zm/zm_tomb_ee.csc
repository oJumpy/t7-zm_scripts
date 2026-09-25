#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_tomb_ee_lights;

#namespace namespace_711a44f0;

/*
	Name: init
	Namespace: namespace_711a44f0
	Checksum: 0xA7F49FE4
	Offset: 0x440
	Size: 0x2E3
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "wagon_1_fire", 21000, 1, "int", &function_6db69694, 0, 0);
	clientfield::register("world", "wagon_2_fire", 21000, 1, "int", &function_6db69694, 0, 0);
	clientfield::register("world", "wagon_3_fire", 21000, 1, "int", &function_6db69694, 0, 0);
	clientfield::register("world", "ee_sam_portal", 21000, 2, "int", &function_aff1c5b2, 0, 0);
	clientfield::register("actor", "ee_zombie_fist_fx", 21000, 1, "int", &function_64b44f6b, 0, 0);
	clientfield::register("actor", "ee_zombie_soul_portal", 21000, 1, "int", &function_a8fdf631, 0, 0);
	clientfield::register("actor", "ee_zombie_tablet_fx", 21000, 1, "int", &function_74610c8a, 0, 0);
	clientfield::register("vehicle", "ee_plane_fx", 21000, 1, "int", &function_19452a40, 0, 0);
	clientfield::register("toplayer", "ee_beacon_reward", 21000, 1, "int", &function_b628a101, 0, 0);
	clientfield::register("world", "TombEndGameBlackScreen", 21000, 1, "int", &function_13792d2, 0, 0);
	zm_tomb_ee_lights::main();
}

/*
	Name: function_6db69694
	Namespace: namespace_711a44f0
	Checksum: 0x90458FDB
	Offset: 0x730
	Size: 0x133
	Parameters: 7
	Flags: None
*/
function function_6db69694(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	switch(fieldName)
	{
		case "wagon_1_fire":
		{
			var_a58a7b24 = "fxexp_211";
			break;
		}
		case "wagon_2_fire":
		{
			var_a58a7b24 = "fxexp_212";
			break;
		}
		case "wagon_3_fire":
		{
			var_a58a7b24 = "fxexp_213";
			break;
		}
		case default:
		{
			var_a58a7b24 = "";
		}
	}
	if(newVal == 1)
	{
		exploder::stop_exploder(var_a58a7b24, localClientNum);
		level thread function_1ebf0afe(1, fieldName);
	}
	else
	{
		exploder::exploder(var_a58a7b24, localClientNum);
		level thread function_1ebf0afe(0, fieldName);
	}
}

/*
	Name: function_6e543e40
	Namespace: namespace_711a44f0
	Checksum: 0x5BB96156
	Offset: 0x870
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function function_6e543e40(localClientNum, fieldName)
{
	level notify("stop_" + fieldName);
	self endon("stop_" + fieldName);
	s_pos = struct::get(fieldName, "targetname");
	while(1)
	{
		playFX(localClientNum, level._effect["wagon_fire"], s_pos.origin, AnglesToForward(s_pos.angles), anglesToUp(s_pos.angles));
		wait(0.5);
	}
}

/*
	Name: function_1ebf0afe
	Namespace: namespace_711a44f0
	Checksum: 0x32F14AA9
	Offset: 0x960
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function function_1ebf0afe(isOn, fieldName)
{
	struct = struct::get(fieldName, "targetname");
	origin = struct.origin;
	if(isOn)
	{
		audio::playloopat("amb_fire_xlg", origin);
	}
	else
	{
		audio::stoploopat("amb_fire_xlg", origin);
	}
}

/*
	Name: function_64b44f6b
	Namespace: namespace_711a44f0
	Checksum: 0xC51EE2F0
	Offset: 0xA10
	Size: 0x1D1
	Parameters: 7
	Flags: None
*/
function function_64b44f6b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.has_soul))
		{
			self.has_soul = 1;
			self.var_8020f50b = PlayFXOnTag(localClientNum, level._effect["fist_glow"], self, "J_Wrist_RI");
			self.var_9c121695 = PlayFXOnTag(localClientNum, level._effect["fist_glow"], self, "J_Wrist_LE");
		}
		if(!isdefined(self.var_3a8912f4))
		{
			self.var_3a8912f4 = spawn(0, self.origin, "script_origin");
			self.var_3a8912f4 LinkTo(self);
			self.var_3a8912f4 PlayLoopSound("zmb_squest_punchtime_fist_loop", 1);
			self thread function_587c5a03(self.var_3a8912f4);
		}
	}
	else if(isdefined(self.has_soul))
	{
		self.has_soul = undefined;
		stopfx(localClientNum, self.var_8020f50b);
		stopfx(localClientNum, self.var_9c121695);
	}
	self notify("hash_613e39fa");
}

/*
	Name: function_587c5a03
	Namespace: namespace_711a44f0
	Checksum: 0x5BA95816
	Offset: 0xBF0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_587c5a03(ent)
{
	self util::waittill_any("death", "entityshutdown", "sndDeleteEnt");
	ent delete();
}

/*
	Name: function_a8fdf631
	Namespace: namespace_711a44f0
	Checksum: 0x2289C365
	Offset: 0xC50
	Size: 0x20B
	Parameters: 7
	Flags: None
*/
function function_a8fdf631(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	v_dest = GetEnt(localClientNum, "ee_sam_portal", "targetname").origin;
	e_fx = spawn(localClientNum, self GetTagOrigin("J_SpineUpper"), "script_model");
	e_fx SetModel("tag_origin");
	playsound(localClientNum, "zmb_squest_charge_soul_leave", self.origin);
	e_fx PlayLoopSound("zmb_squest_charge_soul_lp");
	PlayFXOnTag(localClientNum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(v_dest + VectorScale((0, 0, 1), 5), 1);
	e_fx waittill("movedone");
	playsound(localClientNum, "zmb_squest_charge_soul_impact", v_dest);
	PlayFXOnTag(localClientNum, level._effect["staff_charge"], e_fx, "tag_origin");
	wait(0.3);
	e_fx delete();
}

/*
	Name: function_aff1c5b2
	Namespace: namespace_711a44f0
	Checksum: 0x9A1D1C0B
	Offset: 0xE68
	Size: 0x1BB
	Parameters: 7
	Flags: None
*/
function function_aff1c5b2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	e_fx = GetEnt(localClientNum, "ee_sam_portal", "targetname");
	if(isdefined(e_fx.fx_id))
	{
		e_fx StopLoopSound(5);
		stopfx(localClientNum, e_fx.fx_id);
	}
	if(newVal == 1)
	{
		e_fx.fx_id = PlayFXOnTag(localClientNum, level._effect["foot_box_glow"], e_fx, "tag_origin");
		e_fx PlayLoopSound("zmb_squest_sam_portal_closed_loop", 1);
	}
	else if(newVal == 2)
	{
		if(isdefined(e_fx.fx_id))
		{
			stopfx(localClientNum, e_fx.fx_id);
		}
		playsound(0, "zmb_squest_sam_portal_open", e_fx.origin);
		e_fx PlayLoopSound("zmb_squest_sam_portal_open_loop", 1);
	}
}

/*
	Name: function_19452a40
	Namespace: namespace_711a44f0
	Checksum: 0xBF792F42
	Offset: 0x1030
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function function_19452a40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	while(1)
	{
		e_player = GetLocalPlayer(localClientNum);
		if(isdefined(e_player) && (isdefined(e_player.var_c5eb485f) && e_player.var_c5eb485f) && !isdefined(self.var_f37e5d12))
		{
			self.var_f37e5d12 = PlayFXOnTag(localClientNum, level._effect["biplane_glow"], self, "tag_origin");
		}
		if(isdefined(e_player) && (!isdefined(e_player.var_c5eb485f) && e_player.var_c5eb485f) && isdefined(self.var_f37e5d12))
		{
			stopfx(localClientNum, self.var_f37e5d12);
			self.var_f37e5d12 = undefined;
		}
		wait(0.05);
	}
}

/*
	Name: function_74610c8a
	Namespace: namespace_711a44f0
	Checksum: 0xC2BF3970
	Offset: 0x11A8
	Size: 0x21B
	Parameters: 7
	Flags: None
*/
function function_74610c8a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	a_structs = struct::get_array("tablet_charge_pos", "targetname");
	s_box = ArrayGetClosest(self.origin, a_structs);
	e_fx = spawn(localClientNum, self GetTagOrigin("J_SpineUpper"), "script_model");
	e_fx SetModel("tag_origin");
	e_fx playsound(localClientNum, "zmb_squest_charge_soul_leave");
	e_fx PlayLoopSound("zmb_squest_charge_soul_lp");
	PlayFXOnTag(localClientNum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(s_box.origin, 1);
	e_fx waittill("movedone");
	playsound(localClientNum, "zmb_squest_charge_soul_impact", e_fx.origin);
	PlayFXOnTag(localClientNum, level._effect["staff_charge"], e_fx, "tag_origin");
	wait(0.3);
	e_fx delete();
}

/*
	Name: function_b628a101
	Namespace: namespace_711a44f0
	Checksum: 0x8AB4C4B2
	Offset: 0x13D0
	Size: 0x12B
	Parameters: 7
	Flags: None
*/
function function_b628a101(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.var_e6c8ca8e))
		{
			self.var_e6c8ca8e = 1;
			self thread function_4e9276ed(localClientNum);
			self.m_reward = util::spawn_model(localClientNum, level.var_25ef5fab.worldmodel, (-141, 4464, -322) + (8, 35, 20), self.angles);
			self.m_reward thread function_17bc361f(localClientNum);
		}
	}
	else if(isdefined(self.var_e6c8ca8e))
	{
		self.var_e6c8ca8e = 0;
		self notify("hash_7066982d");
		self.m_reward delete();
	}
}

/*
	Name: function_17bc361f
	Namespace: namespace_711a44f0
	Checksum: 0x38A003A0
	Offset: 0x1508
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function function_17bc361f(localClientNum)
{
	self endon("entityshutdown");
	self endon("death");
	self util::waittill_dobj(localClientNum);
	PlayFXOnTag(localClientNum, level._effect["staff_soul"], self, "tag_origin");
	self playsound(localClientNum, "zmb_spawn_powerup");
	self PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	self MoveY(-50, 2, 0, 1);
	self waittill("movedone");
	while(1)
	{
		self RotateYaw(360, 4);
		self waittill("rotatedone");
	}
}

/*
	Name: function_4e9276ed
	Namespace: namespace_711a44f0
	Checksum: 0x65AE7554
	Offset: 0x1628
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_4e9276ed(localClientNum)
{
	self endon("disconnect");
	self endon("hash_7066982d");
	while(1)
	{
		playFX(localClientNum, level._effect["bottle_glow"], (-141, 4464, -322) + (60, 10, 25));
		wait(0.1);
	}
}

/*
	Name: function_13792d2
	Namespace: namespace_711a44f0
	Checksum: 0xF654A93B
	Offset: 0x16B0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_13792d2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue(GetUIModel(GetUIModelForController(localClientNum), "TombEndGameBlackScreen"), newVal);
}

