#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_tomb_capture_zones;

/*
	Name: init_structs
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8E09BC50
	Offset: 0xE18
	Size: 0x59B
	Parameters: 0
	Flags: None
*/
function init_structs()
{
	level.zombie_custom_riser_fx_handler = &function_5f50cf29;
	level.var_d7512031 = 0;
	clientfield::register("world", "packapunch_anim", 21000, 3, "int", &play_pap_anim, 0, 0);
	clientfield::register("actor", "zone_capture_zombie", 21000, 1, "int", &function_a412a80d, 0, 0);
	clientfield::register("scriptmover", "zone_capture_emergence_hole", 21000, 1, "int", &function_be0738b1, 0, 0);
	clientfield::register("world", "zc_change_progress_bar_color", 21000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("world", "zone_capture_hud_all_generators_captured", 21000, 1, "int", &function_ac197e52, 0, 1);
	SetupClientFieldCodeCallbacks("world", 1, "zone_capture_hud_all_generators_captured");
	clientfield::register("world", "pap_monolith_ring_shake", 21000, 1, "counter", &function_d892a20f, 0, 0);
	clientfield::register("world", "zone_capture_perk_machine_smoke_fx_always_on", 21000, 1, "int", &function_daf4318, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.capture_generator_wheel_widget", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("zbarrier", "pap_emissive_fx", 21000, 1, "int", &function_27abf8e3, 0, 0);
	a_s_generator = struct::get_array("s_generator", "targetname");
	foreach(struct in a_s_generator)
	{
		clientfield::register("world", struct.script_noteworthy, 21000, 7, "float", &function_a6f34d1c, 0, 0);
		clientfield::register("world", "state_" + struct.script_noteworthy, 21000, 3, "int", &function_d56a2c4b, 0, 0);
		clientfield::register("world", "zone_capture_hud_generator_" + struct.script_int, 21000, 2, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
		clientfield::register("world", "zone_capture_monolith_crystal_" + struct.script_int, 21000, 1, "int", &function_54aa6e5c, 0, 0);
		clientfield::register("world", "zone_capture_perk_machine_smoke_fx_" + struct.script_int, 21000, 1, "int", &function_6543186c, 0, 0);
		SetupClientFieldCodeCallbacks("world", 1, "zone_capture_hud_generator_" + struct.script_int);
	}
	level._effect["zone_capture_damage_spark"] = "dlc5/tomb/fx_tomb_mech_dmg_armor";
	level._effect["zone_capture_damage_steam"] = "dlc1/castle/fx_mech_dmg_steam";
	level._effect["zone_capture_zombie_spawn"] = "dlc5/tomb/fx_tomb_emergence_spawn";
	function_3ec54bc4();
	function_7cc68e33();
	function_a4e6d2a7();
}

/*
	Name: function_a6f34d1c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x153E6F17
	Offset: 0x13C0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_a6f34d1c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_generator = function_f424a041(fieldName, localClientNum);
	m_generator function_c516c0e9(localClientNum, oldVal, newVal);
}

/*
	Name: function_c1a782c1
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1EBA8555
	Offset: 0x1450
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_c1a782c1()
{
	self ClearAnim("p7_fxanim_zm_ori_generator_fluid_up_anim", 0);
	self ClearAnim("p7_fxanim_zm_ori_generator_fluid_down_anim", 0);
}

/*
	Name: function_9c5303ba
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1E0C8CC9
	Offset: 0x14A0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_9c5303ba(var_ce864151)
{
	if(!isdefined(var_ce864151))
	{
		var_ce864151 = 0;
	}
	n_blend_time = 0.2;
	if(var_ce864151)
	{
		n_blend_time = 0;
	}
	self ClearAnim("p7_fxanim_zm_ori_generator_start_anim", n_blend_time);
	self ClearAnim("p7_fxanim_zm_ori_generator_up_idle_anim", n_blend_time);
	self ClearAnim("p7_fxanim_zm_ori_generator_down_idle_anim", n_blend_time);
	self ClearAnim("p7_fxanim_zm_ori_generator_end_anim", n_blend_time);
}

/*
	Name: function_c516c0e9
	Namespace: zm_tomb_capture_zones
	Checksum: 0x26FA4447
	Offset: 0x1570
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function function_c516c0e9(localClientNumber, oldVal, newVal)
{
	if(newVal == 1)
	{
		self ClearAnim("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim", 0.2);
		self SetAnim("p7_fxanim_zm_ori_generator_fluid_rotate_up_anim", 1, 0.2, 1);
	}
	else if(newVal < oldVal && oldVal == 1)
	{
		self ClearAnim("p7_fxanim_zm_ori_generator_fluid_rotate_up_anim", 0.2);
		self SetAnim("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim", 1, 0.2, 1);
		wait(getanimlength("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim"));
		self ClearAnim("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim", 0.2);
	}
	self function_f937236c(newVal);
}

/*
	Name: function_f937236c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x87093BA
	Offset: 0x16C8
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function function_f937236c(newVal, var_ce864151)
{
	if(!isdefined(var_ce864151))
	{
		var_ce864151 = 0;
	}
	n_blend_time = 0.2;
	if(var_ce864151)
	{
		n_blend_time = 0;
	}
	self SetAnim("p7_fxanim_zm_ori_generator_fluid_up_anim", newVal, n_blend_time, 1);
	self SetAnim("p7_fxanim_zm_ori_generator_fluid_down_anim", 1 - newVal, n_blend_time, 1);
	self function_7c4c8c42(newVal);
}

/*
	Name: function_f424a041
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1D22ECC4
	Offset: 0x1790
	Size: 0x175
	Parameters: 2
	Flags: None
*/
function function_f424a041(str_name, localClientNumber)
{
	if(!isdefined(level.var_92a1717d))
	{
		level.var_92a1717d = [];
	}
	if(!isdefined(level.var_92a1717d[localClientNumber]))
	{
		level.var_92a1717d[localClientNumber] = [];
	}
	if(!isdefined(level.var_92a1717d[localClientNumber][str_name]))
	{
		level.var_92a1717d[localClientNumber][str_name] = GetEnt(localClientNumber, str_name, "targetname");
	}
	/#
		Assert(isdefined(level.var_92a1717d[localClientNumber][str_name]), "Dev Block strings are not supported" + str_name + "Dev Block strings are not supported");
	#/
	level.var_92a1717d[localClientNumber][str_name] util::waittill_dobj(localClientNumber);
	if(!level.var_92a1717d[localClientNumber][str_name] HasAnimTree())
	{
		level.var_92a1717d[localClientNumber][str_name] useanimtree(-1);
	}
	return level.var_92a1717d[localClientNumber][str_name];
}

/*
	Name: function_d56a2c4b
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7EE2409A
	Offset: 0x1910
	Size: 0x239
	Parameters: 7
	Flags: None
*/
function function_d56a2c4b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_generator = function_f424a041(GetSubStr(fieldName, 6), localClientNum);
	if(newVal == 6)
	{
		m_generator function_bbdb6db3(localClientNum);
		return;
	}
	n_blend_time = 0.2;
	if(bNewEnt || bInitialSnap || bWasDemoJump)
	{
		n_blend_time = 0;
	}
	m_generator function_9c5303ba();
	m_generator notify("hash_a7f9aff7");
	if(newVal != 0)
	{
		m_generator thread function_d66ac605(localClientNum);
	}
	switch(newVal)
	{
		case 0:
		{
			m_generator generator_state_off(localClientNum, n_blend_time);
			break;
		}
		case 1:
		{
			m_generator generator_state_turn_on(localClientNum, n_blend_time);
			break;
		}
		case 2:
		{
			m_generator generator_state_power_up(localClientNum, n_blend_time);
			break;
		}
		case 3:
		{
			m_generator generator_state_power_down(localClientNum, n_blend_time);
			break;
		}
		case 5:
		{
			m_generator function_3414585a(localClientNum, n_blend_time);
			break;
		}
		case 4:
		{
			m_generator generator_state_turn_off(localClientNum, n_blend_time);
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: function_d66ac605
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1789777E
	Offset: 0x1B58
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_d66ac605(localClientNumber)
{
	self endon("entityshutdown");
	self.var_c4cb7bc3 = 1;
	while(isdefined(self.var_c4cb7bc3) && self.var_c4cb7bc3)
	{
		PlayRumbleOnPosition(localClientNumber, "generator_active", self.origin);
		wait(0.3);
	}
}

/*
	Name: generator_state_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0x59BF9A1E
	Offset: 0x1BC8
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function generator_state_off(localClientNumber, n_blend_time)
{
	self.var_c4cb7bc3 = 0;
	self function_71e86201();
	self MapShaderConstant(localClientNumber, 0, "ScriptVector2", 0, 0, 0, 0);
	self function_312726e4(localClientNumber);
	self thread function_7be891d1(localClientNumber);
}

/*
	Name: generator_state_turn_on
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF064B92D
	Offset: 0x1C60
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function generator_state_turn_on(localClientNumber, n_blend_time)
{
	self SetAnim("p7_fxanim_zm_ori_generator_start_anim", 1, n_blend_time, 1);
	self MapShaderConstant(localClientNumber, 0, "ScriptVector2", 0, 1, 0, 0);
	self function_f6af797d(localClientNumber);
	self function_3f53e168(localClientNumber);
}

/*
	Name: generator_state_power_up
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB82CE97D
	Offset: 0x1D00
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function generator_state_power_up(localClientNumber, n_blend_time)
{
	self SetAnim("p7_fxanim_zm_ori_generator_up_idle_anim", 1, n_blend_time, 1);
	self MapShaderConstant(localClientNumber, 0, "ScriptVector2", 0, 1, 0, 0);
	self function_f6af797d(localClientNumber);
	self function_3f53e168(localClientNumber);
}

/*
	Name: generator_state_power_down
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4782384C
	Offset: 0x1DA0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function generator_state_power_down(localClientNumber, n_blend_time)
{
	self SetAnim("p7_fxanim_zm_ori_generator_down_idle_anim", 1, n_blend_time, 1);
	self MapShaderConstant(localClientNumber, 0, "ScriptVector2", 0, 1, 0, 0);
}

/*
	Name: function_3414585a
	Namespace: zm_tomb_capture_zones
	Checksum: 0x37BCA49E
	Offset: 0x1E10
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function function_3414585a(localClientNumber, n_blend_time)
{
	self generator_state_power_down(localClientNumber, n_blend_time);
	self function_c1810bcc(localClientNumber);
}

/*
	Name: function_c1810bcc
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2B919D00
	Offset: 0x1E68
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_c1810bcc(localClientNumber)
{
	self thread function_8daa207b(localClientNumber);
	self thread function_afe4ef7e(localClientNumber);
}

/*
	Name: function_8daa207b
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA562114A
	Offset: 0x1EB0
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function function_8daa207b(localClientNumber)
{
	self notify("hash_74845d8b");
	self endon("hash_74845d8b");
	self endon("hash_a0c3abea");
	if(!isdefined(self.var_25ac834))
	{
		self.var_25ac834 = [];
	}
	a_tags = Array("fx_side_exhaust01", "fx_frnt_exhaust", "fx_side_exhaust02", "j_piston_01");
	while(1)
	{
		self.var_25ac834[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zone_capture_damage_spark"], self, Array::random(a_tags));
		wait(RandomFloatRange(0.15, 0.35));
	}
}

/*
	Name: function_afe4ef7e
	Namespace: zm_tomb_capture_zones
	Checksum: 0x93591B35
	Offset: 0x1FC0
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function function_afe4ef7e(localClientNumber)
{
	self notify("hash_e3f7fe2e");
	self endon("hash_e3f7fe2e");
	self endon("hash_a0c3abea");
	if(!isdefined(self.var_9fe4037d))
	{
		self.var_9fe4037d = [];
	}
	a_tags = Array("fx_side_exhaust01", "fx_frnt_exhaust", "fx_side_exhaust02", "j_piston_01");
	while(1)
	{
		self.var_9fe4037d[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zone_capture_damage_steam"], self, Array::random(a_tags));
		wait(RandomFloatRange(0.25, 0.35));
	}
}

/*
	Name: function_501771e3
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8905683F
	Offset: 0x20D0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_501771e3(localClientNumber)
{
	self notify("hash_a0c3abea");
	if(isdefined(self.var_25ac834) && isdefined(self.var_25ac834[localClientNumber]))
	{
		deletefx(localClientNumber, self.var_25ac834[localClientNumber], 1);
	}
	if(isdefined(self.var_9fe4037d) && isdefined(self.var_9fe4037d[localClientNumber]))
	{
		deletefx(localClientNumber, self.var_9fe4037d[localClientNumber], 1);
	}
}

/*
	Name: function_bbdb6db3
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8CCA09C
	Offset: 0x2188
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function function_bbdb6db3(localClientNumber)
{
	if(!isdefined(self.var_244ac37))
	{
		self.var_244ac37 = [];
	}
	if(isdefined(self.var_244ac37[localClientNumber]))
	{
		stopfx(localClientNumber, self.var_244ac37[localClientNumber]);
	}
	var_a1c15b1a = self.targetname;
	var_2a0fd09 = undefined;
	switch(var_a1c15b1a)
	{
		case "generator_start_bunker":
		{
			var_2a0fd09 = level._effect["capture_complete_1"];
			break;
		}
		case "generator_tank_trench":
		{
			var_2a0fd09 = level._effect["capture_complete_2"];
			break;
		}
		case "generator_mid_trench":
		{
			var_2a0fd09 = level._effect["capture_complete_3"];
			break;
		}
		case "generator_nml_right":
		{
			var_2a0fd09 = level._effect["capture_complete_4"];
			break;
		}
		case "generator_nml_left":
		{
			var_2a0fd09 = level._effect["capture_complete_5"];
			break;
		}
		case "generator_church":
		{
			var_2a0fd09 = level._effect["capture_complete_6"];
			break;
		}
		case default:
		{
			return;
		}
	}
	self.var_244ac37[localClientNumber] = PlayFXOnTag(localClientNumber, var_2a0fd09, self, "j_generator_pole");
}

/*
	Name: generator_state_turn_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0x469960C6
	Offset: 0x2338
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function generator_state_turn_off(localClientNumber, n_blend_time)
{
	self SetAnim("p7_fxanim_zm_ori_generator_end_anim", 1, n_blend_time, 1);
	self MapShaderConstant(localClientNumber, 0, "ScriptVector2", 0, 0, 0, 0);
	self function_312726e4(localClientNumber);
	self thread function_7be891d1(localClientNumber);
}

/*
	Name: function_7c4c8c42
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3BCD1A58
	Offset: 0x23D8
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_7c4c8c42(newVal)
{
	if(!isdefined(self.var_be886049))
	{
		sndOrigin = self GetTagOrigin("j_generator_pole");
		self.var_be886049 = spawn(0, sndOrigin, "script_origin");
		self.var_be886049 LinkTo(self, "j_generator_pole");
		playsound(0, "zmb_capturezone_donut_start", self.origin);
		self.var_be886049 thread function_3a4d4e97();
	}
	pitch = audio::scale_speed(0, 1, 0.8, 1.6, newVal);
	loop_id = self.var_be886049 PlayLoopSound("zmb_capturezone_rise", 1);
	setSoundPitch(loop_id, pitch);
	self function_738a49be(1);
}

/*
	Name: function_71e86201
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAB9939AD
	Offset: 0x2550
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_71e86201()
{
	if(isdefined(self.var_ffb79f2))
	{
		playsound(0, "zmb_capturezone_donut_stop", self.origin);
		self.var_be886049 delete();
		self.var_be886049 = undefined;
	}
	self function_738a49be(0);
}

/*
	Name: function_f6af797d
	Namespace: zm_tomb_capture_zones
	Checksum: 0x894DF69C
	Offset: 0x25C8
	Size: 0x269
	Parameters: 1
	Flags: None
*/
function function_f6af797d(localClientNumber)
{
	self function_312726e4(localClientNumber);
	var_a1c15b1a = self.targetname;
	var_2a0fd09 = undefined;
	switch(var_a1c15b1a)
	{
		case "generator_start_bunker":
		{
			var_2a0fd09 = level._effect["capture_progression_1"];
			break;
		}
		case "generator_tank_trench":
		{
			var_2a0fd09 = level._effect["capture_progression_2"];
			break;
		}
		case "generator_mid_trench":
		{
			var_2a0fd09 = level._effect["capture_progression_3"];
			break;
		}
		case "generator_nml_right":
		{
			var_2a0fd09 = level._effect["capture_progression_4"];
			break;
		}
		case "generator_nml_left":
		{
			var_2a0fd09 = level._effect["capture_progression_5"];
			break;
		}
		case "generator_church":
		{
			var_2a0fd09 = level._effect["capture_progression_6"];
			break;
		}
		case default:
		{
			return;
		}
	}
	self.var_244ac37[localClientNumber] = PlayFXOnTag(localClientNumber, var_2a0fd09, self, "j_generator_pole");
	self.var_878c304c[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_front"], self, "fx_frnt_exhaust");
	self.var_7078bcfd[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_rear"], self, "fx_rear_exhaust");
	self.var_eb98b036[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_side"], self, "fx_vat_exhaust01");
	self.var_c59635cd[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_side"], self, "fx_vat_exhaust02");
}

/*
	Name: function_312726e4
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE39F3E97
	Offset: 0x2840
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function function_312726e4(localClientNumber)
{
	if(!isdefined(self.var_244ac37))
	{
		self.var_244ac37 = [];
	}
	if(isdefined(self.var_244ac37[localClientNumber]))
	{
		stopfx(localClientNumber, self.var_244ac37[localClientNumber]);
	}
	if(!isdefined(self.var_878c304c))
	{
		self.var_878c304c = [];
	}
	if(!isdefined(self.var_7078bcfd))
	{
		self.var_7078bcfd = [];
	}
	if(!isdefined(self.var_eb98b036))
	{
		self.var_eb98b036 = [];
	}
	if(!isdefined(self.var_c59635cd))
	{
		self.var_c59635cd = [];
	}
	if(isdefined(self.var_878c304c[localClientNumber]))
	{
		stopfx(localClientNumber, self.var_878c304c[localClientNumber]);
	}
	if(isdefined(self.var_7078bcfd[localClientNumber]))
	{
		stopfx(localClientNumber, self.var_7078bcfd[localClientNumber]);
	}
	if(isdefined(self.var_eb98b036[localClientNumber]))
	{
		stopfx(localClientNumber, self.var_eb98b036[localClientNumber]);
	}
	if(isdefined(self.var_c59635cd[localClientNumber]))
	{
		stopfx(localClientNumber, self.var_c59635cd[localClientNumber]);
	}
	self function_501771e3(localClientNumber);
}

/*
	Name: function_3f53e168
	Namespace: zm_tomb_capture_zones
	Checksum: 0x107883D0
	Offset: 0x2A00
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_3f53e168(localClientNumber)
{
	if(!isdefined(self.var_88677912))
	{
		self.var_88677912 = [];
	}
	if(isdefined(self.var_88677912[localClientNumber]))
	{
		deletefx(localClientNumber, self.var_88677912[localClientNumber], 1);
	}
}

/*
	Name: function_7be891d1
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB177ADB6
	Offset: 0x2A68
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function function_7be891d1(localClientNumber)
{
	self endon("hash_a7f9aff7");
	self function_3f53e168(localClientNumber);
	self.var_88677912[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zapper_light_notready"], self, "tag_pole_top");
}

/*
	Name: scale_speed
	Namespace: zm_tomb_capture_zones
	Checksum: 0x95DD005A
	Offset: 0x2AE0
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function scale_speed(x1, x2, y1, y2, z)
{
	if(z < x1)
	{
		z = x1;
	}
	if(z > x2)
	{
		z = x2;
	}
	dx = x2 - x1;
	n = z - x1 / dx;
	dy = y2 - y1;
	w = n * dy + y1;
	return w;
}

/*
	Name: function_738a49be
	Namespace: zm_tomb_capture_zones
	Checksum: 0x20CB5BB0
	Offset: 0x2BB8
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function function_738a49be(start)
{
	if(!isdefined(self.var_f2b9c979))
	{
		self.var_f2b9c979 = 0;
	}
	origin1 = self GetTagOrigin("vat_01_sound");
	origin2 = self GetTagOrigin("vat_02_sound");
	if(start)
	{
		if(!self.var_f2b9c979)
		{
			audio::playloopat("zmb_capturezone_vat_loop", origin1);
			audio::playloopat("zmb_capturezone_vat_loop", origin2);
			self.var_f2b9c979 = 1;
		}
	}
	else
	{
		audio::stoploopat("zmb_capturezone_vat_loop", origin1);
		audio::stoploopat("zmb_capturezone_vat_loop", origin2);
		self.var_f2b9c979 = 0;
	}
}

/*
	Name: function_54aa6e5c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x20AEBA8
	Offset: 0x2CE0
	Size: 0x1D3
	Parameters: 7
	Flags: None
*/
function function_54aa6e5c(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_a0a565ad = function_24fcf23b(fieldName, localClientNumber);
	str_exploder = "fxexp_" + level.var_6aec00d3[fieldName];
	if(newVal)
	{
		var_a0a565ad thread function_59c8afc0(localClientNumber, 0, 0.1, 2, 4, 0.5, 3);
		var_a0a565ad StopLoopSound(1);
		exploder::stop_exploder(str_exploder, localClientNumber);
		level thread function_31e3b463(0, level.var_6aec00d3[fieldName]);
	}
	else
	{
		var_a0a565ad thread function_59c8afc0(localClientNumber, 0.65, 1, 0.7, 1, 0.05, 0.35);
		var_a0a565ad PlayLoopSound("amb_monolith_glow");
		exploder::exploder(str_exploder, localClientNumber);
		level thread function_31e3b463(1, level.var_6aec00d3[fieldName]);
	}
}

/*
	Name: function_31e3b463
	Namespace: zm_tomb_capture_zones
	Checksum: 0xABEA51AF
	Offset: 0x2EC0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function function_31e3b463(Play, num)
{
}

/*
	Name: function_59c8afc0
	Namespace: zm_tomb_capture_zones
	Checksum: 0xDD0CB07C
	Offset: 0x2EE0
	Size: 0x1AF
	Parameters: 7
	Flags: None
*/
function function_59c8afc0(localClientNumber, var_98ce6736, var_4333264, var_e2ad4e8e, var_22a5887c, var_48d50352, var_d056f9f8)
{
	self notify("hash_c0d7e9d");
	self endon("hash_c0d7e9d");
	if(!isdefined(self.var_40a6544d))
	{
		self.var_40a6544d = var_98ce6736;
	}
	while(1)
	{
		var_68feedab = RandomFloatRange(var_98ce6736, var_4333264);
		N_TRANSITION_TIME = RandomFloatRange(var_e2ad4e8e, var_22a5887c);
		n_steps = Int(N_TRANSITION_TIME / 0.016);
		var_5885a5c5 = var_68feedab - self.var_40a6544d / n_steps;
		for(i = 0; i < n_steps; i++)
		{
			self.var_40a6544d = self.var_40a6544d + var_5885a5c5;
			self MapShaderConstant(localClientNumber, 2, "scriptVector2", self.var_40a6544d, 0, 0, 0);
			wait(0.016);
		}
		wait(RandomFloatRange(var_48d50352, var_d056f9f8));
	}
}

/*
	Name: function_217d24cd
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC3E22AF7
	Offset: 0x3098
	Size: 0x115
	Parameters: 3
	Flags: None
*/
function function_217d24cd(localClientNumber, var_68feedab, N_TRANSITION_TIME)
{
	self notify("hash_c0d7e9d");
	self endon("hash_c0d7e9d");
	if(!isdefined(self.var_40a6544d))
	{
		self.var_40a6544d = 1;
	}
	n_steps = Int(N_TRANSITION_TIME / 0.016);
	var_5885a5c5 = var_68feedab - self.var_40a6544d / n_steps;
	for(i = 0; i < n_steps; i++)
	{
		self.var_40a6544d = self.var_40a6544d + var_5885a5c5;
		self MapShaderConstant(localClientNumber, 2, "scriptVector2", self.var_40a6544d, 0, 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_24fcf23b
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFDD0C945
	Offset: 0x31B8
	Size: 0x1DD
	Parameters: 2
	Flags: None
*/
function function_24fcf23b(str_targetname, localClientNum)
{
	if(!isdefined(level.var_4cb39fae))
	{
		level.var_4cb39fae = [];
	}
	if(!isdefined(level.var_4cb39fae[localClientNum]))
	{
		level.var_4cb39fae[localClientNum] = [];
	}
	if(!isdefined(level.var_4cb39fae[localClientNum][str_targetname]))
	{
		level.var_4cb39fae[localClientNum][str_targetname] = GetEnt(localClientNum, str_targetname, "targetname");
		level.var_4cb39fae[localClientNum][str_targetname].var_8d2380bb = [];
		level.var_4cb39fae[localClientNum][str_targetname].var_8d2380bb[localClientNum] = 0;
	}
	level.var_4cb39fae[localClientNum][str_targetname] util::waittill_dobj(localClientNum);
	if(!level.var_4cb39fae[localClientNum][str_targetname].var_8d2380bb[localClientNum])
	{
		level.var_4cb39fae[localClientNum][str_targetname] MapShaderConstant(localClientNum, 2, "scriptVector2", 0);
		level.var_4cb39fae[localClientNum][str_targetname].var_8d2380bb[localClientNum] = 1;
	}
	/#
		Assert(isdefined(level.var_4cb39fae[localClientNum][str_targetname]), "Dev Block strings are not supported" + str_targetname + "Dev Block strings are not supported");
	#/
	return level.var_4cb39fae[localClientNum][str_targetname];
}

/*
	Name: function_ac197e52
	Namespace: zm_tomb_capture_zones
	Checksum: 0x64B4D5BA
	Offset: 0x33A0
	Size: 0x193
	Parameters: 7
	Flags: None
*/
function function_ac197e52(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_eb1b4657 = function_12a07195(localClientNumber);
	if(isdefined(var_eb1b4657))
	{
		if(newVal)
		{
			var_eb1b4657 thread function_aab40f28(localClientNumber, 3);
			var_eb1b4657 thread function_f35264ff();
		}
		else
		{
			var_eb1b4657 thread function_aab40f28(localClientNumber, 0);
			var_eb1b4657 thread function_3f73ddc3(oldVal);
		}
	}
	var_82347477 = function_cd49ce76(localClientNumber);
	if(isdefined(var_82347477))
	{
		if(newVal)
		{
			var_82347477 thread function_59c8afc0(localClientNumber, 0.65, 1, 0.7, 1, 0.05, 0.35);
		}
		else
		{
			var_82347477 show();
			var_82347477 thread function_217d24cd(localClientNumber, 0, 5);
		}
	}
}

/*
	Name: function_9164d089
	Namespace: zm_tomb_capture_zones
	Checksum: 0x97DE2781
	Offset: 0x3540
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_9164d089(localClientNumber)
{
	var_82347477 = function_cd49ce76(localClientNumber);
	if(isdefined(var_82347477))
	{
		var_82347477 Hide();
	}
}

/*
	Name: function_f35264ff
	Namespace: zm_tomb_capture_zones
	Checksum: 0x342547DA
	Offset: 0x35A0
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function function_f35264ff()
{
	self notify("hash_3b22402e");
	self endon("hash_765cfe11");
	self function_4f226940();
	self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 1, 0.2);
	WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_pull_anim) - 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
	self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 1, 0.2);
	level.var_d7512031 = 1;
}

/*
	Name: function_3f73ddc3
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF52F364B
	Offset: 0x3698
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function function_3f73ddc3(oldVal)
{
	self notify("hash_765cfe11");
	self endon("hash_3b22402e");
	self function_4f226940();
	if(oldVal)
	{
		self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_release_anim, 1, 0.2);
		WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_release_anim) - 0.2);
		self function_4f226940();
	}
	self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_idle_anim, 1, 0.2);
	level.var_d7512031 = 0;
}

/*
	Name: function_d892a20f
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4A0E125A
	Offset: 0x3790
	Size: 0x1EB
	Parameters: 7
	Flags: None
*/
function function_d892a20f(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_eb1b4657 = function_12a07195(localClientNumber);
	var_eb1b4657 endon("hash_3b22402e");
	if(newVal == 1)
	{
		var_eb1b4657 function_4f226940();
		var_eb1b4657 SetAnim(%p7_fxanim_zm_ori_monolith_inductor_shake_anim, 1, 0.2);
		WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_shake_anim) - 0.2);
		var_eb1b4657 ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_shake_anim, 0.2);
		if(level.var_d7512031)
		{
			var_eb1b4657 SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 1, 0.2);
			WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_pull_anim) - 0.2);
			var_eb1b4657 ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
			var_eb1b4657 SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 1, 0.2);
		}
		else
		{
			var_eb1b4657 thread function_3f73ddc3(0);
		}
	}
}

/*
	Name: function_4f226940
	Namespace: zm_tomb_capture_zones
	Checksum: 0x34E4441D
	Offset: 0x3988
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_4f226940()
{
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_release_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_shake_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_idle_anim, 0.2);
}

/*
	Name: function_aab40f28
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8F5AA8DA
	Offset: 0x3A60
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function function_aab40f28(localClientNumber, n_value)
{
	self notify("hash_c6efbac2");
	self endon("hash_c6efbac2");
	if(!isdefined(self.var_40a6544d))
	{
		self.var_40a6544d = [];
	}
	if(!isdefined(self.var_40a6544d[localClientNumber]))
	{
		self.var_40a6544d[localClientNumber] = 0;
	}
	n_delta = n_value - self.var_40a6544d[localClientNumber];
	n_increment = n_delta / 4.5 * 0.016;
	while(self.var_40a6544d[localClientNumber] != n_value)
	{
		self.var_40a6544d[localClientNumber] = math::clamp(self.var_40a6544d[localClientNumber] + n_increment, 0, 3);
		self MapShaderConstant(localClientNumber, 3, "scriptVector2", 0, self.var_40a6544d[localClientNumber], 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_12a07195
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB0DBEBB0
	Offset: 0x3BB0
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function function_12a07195(localClientNumber)
{
	if(!isdefined(level.var_9920ede0))
	{
		level.var_9920ede0 = [];
	}
	if(!isdefined(level.var_9920ede0[localClientNumber]))
	{
		level.var_9920ede0[localClientNumber] = GetEnt(localClientNumber, "pap_monolith_ring", "targetname");
	}
	level.var_9920ede0[localClientNumber] util::waittill_dobj(localClientNumber);
	if(!level.var_9920ede0[localClientNumber] HasAnimTree())
	{
		level.var_9920ede0[localClientNumber] MapShaderConstant(localClientNumber, 3, "scriptVector2", 0, 0, 0, 0);
		level.var_9920ede0[localClientNumber] useanimtree(-1);
	}
	return level.var_9920ede0[localClientNumber];
}

/*
	Name: function_be0738b1
	Namespace: zm_tomb_capture_zones
	Checksum: 0x358B24E6
	Offset: 0x3CD0
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function function_be0738b1(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		self emergence_hole_spawn(localClientNumber);
	}
	else
	{
		var_4478dceb = self function_45d7dc5a(localClientNumber, oldVal && !bNewEnt && !bWasDemoJump);
		self function_345cde91(localClientNumber, var_4478dceb);
	}
}

/*
	Name: emergence_hole_spawn
	Namespace: zm_tomb_capture_zones
	Checksum: 0xD511D2D2
	Offset: 0x3DA0
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function emergence_hole_spawn(localClientNumber)
{
	self function_345cde91(localClientNumber);
	self.var_a326f0e[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["tesla_elec_kill"], self, "tag_origin");
	self.var_70ef4eef[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["screecher_hole"], self, "tag_origin");
	if(!isdefined(self.sndent))
	{
		self.sndent = spawn(localClientNumber, self.origin, "script_origin");
		self.sndent thread function_3a4d4e97();
	}
	self.sndent PlayLoopSound("zmb_capturezone_portal_loop", 2);
	playsound(localClientNumber, "zmb_capturezone_portal_start", self.origin);
}

/*
	Name: function_3a4d4e97
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC88CA6A6
	Offset: 0x3EF0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_3a4d4e97()
{
	self endon("entityshutdown");
	level waittill("demo_jump");
	self delete();
}

/*
	Name: function_45d7dc5a
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3109B476
	Offset: 0x3F30
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function function_45d7dc5a(localClientNumber, var_4f49ffe0)
{
	if(var_4f49ffe0)
	{
		var_4478dceb = 0;
		PlayFXOnTag(localClientNumber, level._effect["tesla_elec_kill"], self, "tag_origin");
		playsound(localClientNumber, "zmb_capturezone_portal_stop");
	}
	return !var_4f49ffe0;
}

/*
	Name: function_345cde91
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEB2A52F0
	Offset: 0x3FC0
	Size: 0x173
	Parameters: 2
	Flags: None
*/
function function_345cde91(localClientNumber, var_4478dceb)
{
	if(!isdefined(var_4478dceb))
	{
		var_4478dceb = 1;
	}
	if(!isdefined(self.var_a326f0e))
	{
		self.var_a326f0e = [];
	}
	if(!isdefined(self.var_70ef4eef))
	{
		self.var_70ef4eef = [];
	}
	if(!isdefined(self.var_6ecbad39))
	{
		self.var_6ecbad39 = [];
	}
	if(isdefined(self.var_70ef4eef[localClientNumber]))
	{
		deletefx(localClientNumber, self.var_a326f0e[localClientNumber], 1);
		self.var_a326f0e[localClientNumber] = undefined;
	}
	if(isdefined(self.var_70ef4eef[localClientNumber]))
	{
		deletefx(localClientNumber, self.var_70ef4eef[localClientNumber], 1);
		self.var_70ef4eef[localClientNumber] = undefined;
	}
	if(var_4478dceb)
	{
		if(isdefined(self.var_6ecbad39[localClientNumber]))
		{
			deletefx(localClientNumber, self.var_6ecbad39[localClientNumber], 1);
			self.var_6ecbad39[localClientNumber] = undefined;
		}
	}
	if(isdefined(self.sndent))
	{
		self.sndent delete();
	}
}

/*
	Name: function_5f50cf29
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE0E1518A
	Offset: 0x4140
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_5f50cf29()
{
	if(self._aitype === "zm_tomb_basic_zone_capture")
	{
		s_info = spawnstruct();
		s_info.burst_fx = level._effect["zone_capture_zombie_spawn"];
		s_info.billow_fx = level._effect["zone_capture_zombie_spawn"];
		s_info.type = "none";
		return s_info;
	}
}

/*
	Name: function_7cc68e33
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCB24D87C
	Offset: 0x41E0
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_7cc68e33()
{
	function_6784d594(0, undefined, %p7_fxanim_zm_ori_pack_return_pc1_anim);
	function_6784d594(1, %p7_fxanim_zm_ori_pack_pc1_anim, %p7_fxanim_zm_ori_pack_return_pc2_anim);
	function_6784d594(2, %p7_fxanim_zm_ori_pack_pc2_anim, %p7_fxanim_zm_ori_pack_return_pc3_anim);
	function_6784d594(3, %p7_fxanim_zm_ori_pack_pc3_anim, %p7_fxanim_zm_ori_pack_return_pc4_anim);
	function_6784d594(4, %p7_fxanim_zm_ori_pack_pc4_anim, %p7_fxanim_zm_ori_pack_return_pc5_anim);
	function_6784d594(5, %p7_fxanim_zm_ori_pack_pc5_anim, %p7_fxanim_zm_ori_pack_return_pc6_anim);
	function_6784d594(6, %p7_fxanim_zm_ori_pack_pc6_anim, undefined);
}

/*
	Name: play_pap_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8402969F
	Offset: 0x4320
	Size: 0x325
	Parameters: 7
	Flags: None
*/
function play_pap_anim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_29003520 = function_cd49ce76(localClientNum);
	var_c0fc4c20 = bNewEnt || bInitialSnap || bWasDemoJump;
	if(newVal > oldVal || var_c0fc4c20)
	{
		for(i = 1; i <= newVal; i++)
		{
			n_anim_time = 1;
			n_anim_rate = 0;
			if(i == newVal && !var_c0fc4c20)
			{
				n_anim_time = 0;
				n_anim_rate = 1;
			}
			var_f24fe15c = level.var_f983511b["disassemble"][i - 1];
			if(isdefined(var_f24fe15c))
			{
				var_29003520 ClearAnim(var_f24fe15c, 0);
			}
			var_c930c99 = level.var_f983511b["assemble"][i];
			var_29003520 SetAnim(var_c930c99, 1, 0, n_anim_rate);
			var_29003520 SetAnimTime(var_c930c99, n_anim_time);
		}
		break;
	}
	if(newVal < oldVal)
	{
		for(i = level.var_f983511b["disassemble"].size - 1; i >= newVal; i--)
		{
			n_anim_time = 1;
			n_anim_rate = 0;
			if(i == newVal)
			{
				n_anim_time = 0;
				n_anim_rate = 1;
			}
			var_f24fe15c = level.var_f983511b["assemble"][i + 1];
			if(isdefined(var_f24fe15c))
			{
				var_29003520 ClearAnim(var_f24fe15c, 0);
			}
			var_653a11db = level.var_f983511b["disassemble"][i];
			var_29003520 SetAnim(var_653a11db, 1, n_anim_time, n_anim_rate);
			var_29003520 SetAnimTime(var_653a11db, n_anim_time);
		}
	}
}

/*
	Name: function_6784d594
	Namespace: zm_tomb_capture_zones
	Checksum: 0x24018A81
	Offset: 0x4650
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function function_6784d594(n_index, var_c930c99, var_653a11db)
{
	if(!isdefined(level.var_f983511b))
	{
		level.var_f983511b = [];
	}
	if(!isdefined(level.var_f983511b["assemble"]))
	{
		level.var_f983511b["assemble"] = [];
	}
	if(!isdefined(level.var_f983511b["disassemble"]))
	{
		level.var_f983511b["disassemble"] = [];
	}
	level.var_f983511b["assemble"][n_index] = var_c930c99;
	level.var_f983511b["disassemble"][n_index] = var_653a11db;
}

/*
	Name: function_cd49ce76
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1DFAF84A
	Offset: 0x4720
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function function_cd49ce76(localClientNumber)
{
	if(!isdefined(level.var_6a68eb65))
	{
		level.var_6a68eb65 = [];
	}
	if(!isdefined(level.var_6a68eb65[localClientNumber]))
	{
		level.var_6a68eb65[localClientNumber] = GetEnt(localClientNumber, "pap_cs", "targetname");
	}
	level.var_6a68eb65[localClientNumber] util::waittill_dobj(localClientNumber);
	if(!level.var_6a68eb65[localClientNumber] HasAnimTree())
	{
		level.var_6a68eb65[localClientNumber] useanimtree(-1);
		level.var_6a68eb65[localClientNumber] MapShaderConstant(localClientNumber, 2, "ScriptVector0", 1);
	}
	return level.var_6a68eb65[localClientNumber];
}

/*
	Name: function_902e1a6d
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE7ADA483
	Offset: 0x4840
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function function_902e1a6d()
{
	util::waitforallclients();
	a_players = GetLocalPlayers();
	for(localClientNum = 0; localClientNum < a_players.size; localClientNum++)
	{
		var_3fe0feb2 = function_cd49ce76(localClientNum);
	}
}

/*
	Name: function_a412a80d
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB60DD6ED
	Offset: 0x48C8
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_a412a80d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self._aitype = "zm_tomb_basic_zone_capture";
		self thread zm::handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump);
		self._eyeglow_fx_override = level._effect["crusader_zombie_eyes"];
		self zm::deleteZombieEyes(localClientNum);
		self zm::createZombieEyes(localClientNum);
		self function_82ce76c3(localClientNum);
	}
}

/*
	Name: function_82ce76c3
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE240295D
	Offset: 0x49B8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function function_82ce76c3(localClientNumber)
{
	self function_b031f5ce(localClientNumber);
	self.var_3199f723[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zone_capture_zombie_torso_fx"], self, "J_Spine4");
	if(!isdefined(self.sndent))
	{
		self.sndent = spawn(0, self.origin, "script_origin");
		self.sndent LinkTo(self);
		self thread function_613e39fa(self.sndent);
	}
	self.sndent PlayLoopSound("zmb_capturezone_zombie_loop", 1);
}

/*
	Name: function_613e39fa
	Namespace: zm_tomb_capture_zones
	Checksum: 0x501E2868
	Offset: 0x4AC0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_613e39fa(ent)
{
	self util::waittill_any("death", "entityshutdown");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: function_b031f5ce
	Namespace: zm_tomb_capture_zones
	Checksum: 0xBC20094F
	Offset: 0x4B20
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_b031f5ce(localClientNumber)
{
	if(!isdefined(self.var_3199f723))
	{
		self.var_3199f723 = [];
	}
	if(isdefined(self.var_3199f723[localClientNumber]))
	{
		deletefx(localClientNumber, self.var_3199f723[localClientNumber], 1);
	}
}

/*
	Name: function_a4e6d2a7
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCF826BC5
	Offset: 0x4B88
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_a4e6d2a7()
{
	function_eebeeca5("zone_capture_monolith_crystal_1", 5001);
	function_eebeeca5("zone_capture_monolith_crystal_2", 5002);
	function_eebeeca5("zone_capture_monolith_crystal_3", 5003);
	function_eebeeca5("zone_capture_monolith_crystal_4", 5004);
	function_eebeeca5("zone_capture_monolith_crystal_5", 5005);
	function_eebeeca5("zone_capture_monolith_crystal_6", 5006);
}

/*
	Name: function_eebeeca5
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9E9E38D3
	Offset: 0x4C58
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function function_eebeeca5(str_field_name, n_exploder_id)
{
	if(!isdefined(level.var_6aec00d3))
	{
		level.var_6aec00d3 = [];
	}
	if(!isdefined(level.var_6aec00d3[str_field_name]))
	{
		level.var_6aec00d3[str_field_name] = n_exploder_id;
	}
}

/*
	Name: function_3ec54bc4
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFA41AC88
	Offset: 0x4CB8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_3ec54bc4()
{
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_1", "revive_pipes");
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_3", "speedcola_pipes");
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_4", "jugg_pipes");
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_5", "staminup_pipes");
}

/*
	Name: function_b27ab5bf
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC18DD335
	Offset: 0x4D48
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function function_b27ab5bf(str_field_name, var_4560e0ce)
{
	if(!isdefined(level.var_2707a8c))
	{
		level.var_2707a8c = [];
	}
	if(!isdefined(level.var_2707a8c[str_field_name]))
	{
		level.var_2707a8c[str_field_name] = var_4560e0ce;
	}
}

/*
	Name: function_27abf8e3
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA2A1FC6F
	Offset: 0x4DA8
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_27abf8e3(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNumber, 0, "scriptVector2", 0, 1, 0, 0);
		level thread function_9164d089(localClientNumber);
	}
	else
	{
		self MapShaderConstant(localClientNumber, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: function_daf4318
	Namespace: zm_tomb_capture_zones
	Checksum: 0x6C1BDC3A
	Offset: 0x4EA0
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_daf4318(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		var_3aed1533 = struct::get("mulekick_pipes", "targetname");
		var_3aed1533 function_b64620a3(localClientNumber);
	}
}

/*
	Name: function_6543186c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3DBA3EC9
	Offset: 0x4F38
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_6543186c(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_d26305ae = function_23d70c75(fieldName);
	if(isdefined(var_d26305ae))
	{
		if(newVal == 1)
		{
			var_d26305ae function_b64620a3(localClientNumber);
		}
		else
		{
			var_d26305ae function_176e302e(localClientNumber);
		}
	}
}

/*
	Name: function_23d70c75
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF6A439C7
	Offset: 0x4FF8
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function function_23d70c75(str_field_name)
{
	s_fx = undefined;
	if(isdefined(level.var_2707a8c[str_field_name]))
	{
		if(!isdefined(level.var_d5b89792))
		{
			level.var_d5b89792 = [];
		}
		if(!isdefined(level.var_d5b89792[level.var_2707a8c[str_field_name]]))
		{
			level.var_d5b89792[level.var_2707a8c[str_field_name]] = struct::get(level.var_2707a8c[str_field_name], "targetname");
		}
		s_fx = level.var_d5b89792[level.var_2707a8c[str_field_name]];
	}
	return s_fx;
}

/*
	Name: function_176e302e
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8EF1C42E
	Offset: 0x50C8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_176e302e(localClientNumber)
{
	if(!isdefined(self.a_fx))
	{
		self.a_fx = [];
	}
	if(isdefined(self.a_fx[localClientNumber]))
	{
		deletefx(localClientNumber, self.a_fx[localClientNumber], 0);
	}
}

/*
	Name: function_b64620a3
	Namespace: zm_tomb_capture_zones
	Checksum: 0x628AA4F
	Offset: 0x5130
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function function_b64620a3(localClientNumber)
{
	self function_176e302e(localClientNumber);
	self.a_fx[localClientNumber] = playFX(localClientNumber, level._effect["perk_pipe_smoke"], self.origin, AnglesToForward(self.angles));
}

