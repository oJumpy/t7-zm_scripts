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
	level.zombie_custom_riser_fx_handler = &capture_zombie_riser_fx;
	level.var_d7512031 = 0;
	clientfield::register("world", "packapunch_anim", 21000, 3, "int", &play_pap_anim, 0, 0);
	clientfield::register("actor", "zone_capture_zombie", 21000, 1, "int", &zone_capture_zombie_callback, 0, 0);
	clientfield::register("scriptmover", "zone_capture_emergence_hole", 21000, 1, "int", &emergence_hole_callback, 0, 0);
	clientfield::register("world", "zc_change_progress_bar_color", 21000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("world", "zone_capture_hud_all_generators_captured", 21000, 1, "int", &pap_monolith_ring_callback, 0, 1);
	SetupClientFieldCodeCallbacks("world", 1, "zone_capture_hud_all_generators_captured");
	clientfield::register("world", "pap_monolith_ring_shake", 21000, 1, "counter", &pap_monolith_ring_shake, 0, 0);
	clientfield::register("world", "zone_capture_perk_machine_smoke_fx_always_on", 21000, 1, "int", &perk_machine_smoke_fx_always_on_callback, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.capture_generator_wheel_widget", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("zbarrier", "pap_emissive_fx", 21000, 1, "int", &pap_emissive_fx, 0, 0);
	a_s_generator = struct::get_array("s_generator", "targetname");
	foreach(struct in a_s_generator)
	{
		clientfield::register("world", struct.script_noteworthy, 21000, 7, "float", &set_generator_capture_progress, 0, 0);
		clientfield::register("world", "state_" + struct.script_noteworthy, 21000, 3, "int", &set_generator_state, 0, 0);
		clientfield::register("world", "zone_capture_hud_generator_" + struct.script_int, 21000, 2, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
		clientfield::register("world", "zone_capture_monolith_crystal_" + struct.script_int, 21000, 1, "int", &monolith_crysal_glow, 0, 0);
		clientfield::register("world", "zone_capture_perk_machine_smoke_fx_" + struct.script_int, 21000, 1, "int", &perk_machine_smoke_fx_callback, 0, 0);
		SetupClientFieldCodeCallbacks("world", 1, "zone_capture_hud_generator_" + struct.script_int);
	}
	level._effect["zone_capture_damage_spark"] = "dlc5/tomb/fx_tomb_mech_dmg_armor";
	level._effect["zone_capture_damage_steam"] = "dlc1/castle/fx_mech_dmg_steam";
	level._effect["zone_capture_zombie_spawn"] = "dlc5/tomb/fx_tomb_emergence_spawn";
	register_perk_machine_smoke_struct_references();
	register_pack_a_punch_anim_sequence();
	register_exploders_with_capture_zones();
}

/*
	Name: set_generator_capture_progress
	Namespace: zm_tomb_capture_zones
	Checksum: 0x153E6F17
	Offset: 0x13C0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function set_generator_capture_progress(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_generator = get_generator_entity(fieldName, localClientNum);
	m_generator generator_set_progress(localClientNum, oldVal, newVal);
}

/*
	Name: clear_fluid_column_anims
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1EBA8555
	Offset: 0x1450
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function clear_fluid_column_anims()
{
	self ClearAnim("p7_fxanim_zm_ori_generator_fluid_up_anim", 0);
	self ClearAnim("p7_fxanim_zm_ori_generator_fluid_down_anim", 0);
}

/*
	Name: clear_pump_anims
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1E0C8CC9
	Offset: 0x14A0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function clear_pump_anims(b_skip_blend)
{
	if(!isdefined(b_skip_blend))
	{
		b_skip_blend = 0;
	}
	n_blend_time = 0.2;
	if(b_skip_blend)
	{
		n_blend_time = 0;
	}
	self ClearAnim("p7_fxanim_zm_ori_generator_start_anim", n_blend_time);
	self ClearAnim("p7_fxanim_zm_ori_generator_up_idle_anim", n_blend_time);
	self ClearAnim("p7_fxanim_zm_ori_generator_down_idle_anim", n_blend_time);
	self ClearAnim("p7_fxanim_zm_ori_generator_end_anim", n_blend_time);
}

/*
	Name: generator_set_progress
	Namespace: zm_tomb_capture_zones
	Checksum: 0x26FA4447
	Offset: 0x1570
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function generator_set_progress(localClientNumber, oldVal, newVal)
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
	self set_fluid_height(newVal);
}

/*
	Name: set_fluid_height
	Namespace: zm_tomb_capture_zones
	Checksum: 0x87093BA
	Offset: 0x16C8
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function set_fluid_height(newVal, b_skip_blend)
{
	if(!isdefined(b_skip_blend))
	{
		b_skip_blend = 0;
	}
	n_blend_time = 0.2;
	if(b_skip_blend)
	{
		n_blend_time = 0;
	}
	self SetAnim("p7_fxanim_zm_ori_generator_fluid_up_anim", newVal, n_blend_time, 1);
	self SetAnim("p7_fxanim_zm_ori_generator_fluid_down_anim", 1 - newVal, n_blend_time, 1);
	self generator_sound_enable(newVal);
}

/*
	Name: get_generator_entity
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1D22ECC4
	Offset: 0x1790
	Size: 0x175
	Parameters: 2
	Flags: None
*/
function get_generator_entity(str_name, localClientNumber)
{
	if(!isdefined(level.zone_capture_generators))
	{
		level.zone_capture_generators = [];
	}
	if(!isdefined(level.zone_capture_generators[localClientNumber]))
	{
		level.zone_capture_generators[localClientNumber] = [];
	}
	if(!isdefined(level.zone_capture_generators[localClientNumber][str_name]))
	{
		level.zone_capture_generators[localClientNumber][str_name] = GetEnt(localClientNumber, str_name, "targetname");
	}
	/#
		Assert(isdefined(level.zone_capture_generators[localClientNumber][str_name]), "Dev Block strings are not supported" + str_name + "Dev Block strings are not supported");
	#/
	level.zone_capture_generators[localClientNumber][str_name] util::waittill_dobj(localClientNumber);
	if(!level.zone_capture_generators[localClientNumber][str_name] HasAnimTree())
	{
		level.zone_capture_generators[localClientNumber][str_name] useanimtree(-1);
	}
	return level.zone_capture_generators[localClientNumber][str_name];
}

/*
	Name: set_generator_state
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7EE2409A
	Offset: 0x1910
	Size: 0x239
	Parameters: 7
	Flags: None
*/
function set_generator_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_generator = get_generator_entity(GetSubStr(fieldName, 6), localClientNum);
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
	m_generator clear_pump_anims();
	m_generator notify("generator_state_changed");
	if(newVal != 0)
	{
		m_generator thread rumble_at_generator_origin(localClientNum);
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
			m_generator generator_state_damaged(localClientNum, n_blend_time);
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
	Name: rumble_at_generator_origin
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1789777E
	Offset: 0x1B58
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function rumble_at_generator_origin(localClientNumber)
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
	self generator_sound_disable();
	self MapShaderConstant(localClientNumber, 0, "ScriptVector2", 0, 0, 0, 0);
	self generator_fx_disable(localClientNumber);
	self thread generator_offline_light_enable(localClientNumber);
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
	self generator_fx_enable(localClientNumber);
	self generator_offline_light_disable(localClientNumber);
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
	self generator_fx_enable(localClientNumber);
	self generator_offline_light_disable(localClientNumber);
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
	Name: generator_state_damaged
	Namespace: zm_tomb_capture_zones
	Checksum: 0x37BCA49E
	Offset: 0x1E10
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function generator_state_damaged(localClientNumber, n_blend_time)
{
	self generator_state_power_down(localClientNumber, n_blend_time);
	self generator_play_damage_fx(localClientNumber);
}

/*
	Name: generator_play_damage_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2B919D00
	Offset: 0x1E68
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function generator_play_damage_fx(localClientNumber)
{
	self thread _generator_play_spark_fx(localClientNumber);
	self thread _generator_play_steam_fx(localClientNumber);
}

/*
	Name: _generator_play_spark_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA562114A
	Offset: 0x1EB0
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function _generator_play_spark_fx(localClientNumber)
{
	self notify("generator_starts_spark_fx");
	self endon("generator_starts_spark_fx");
	self endon("generator_stop_damage_fx");
	if(!isdefined(self.n_spark_fx))
	{
		self.n_spark_fx = [];
	}
	a_tags = Array("fx_side_exhaust01", "fx_frnt_exhaust", "fx_side_exhaust02", "j_piston_01");
	while(1)
	{
		self.n_spark_fx[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zone_capture_damage_spark"], self, Array::random(a_tags));
		wait(RandomFloatRange(0.15, 0.35));
	}
}

/*
	Name: _generator_play_steam_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0x93591B35
	Offset: 0x1FC0
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function _generator_play_steam_fx(localClientNumber)
{
	self notify("generator_starts_steam_fx");
	self endon("generator_starts_steam_fx");
	self endon("generator_stop_damage_fx");
	if(!isdefined(self.n_steam_fx))
	{
		self.n_steam_fx = [];
	}
	a_tags = Array("fx_side_exhaust01", "fx_frnt_exhaust", "fx_side_exhaust02", "j_piston_01");
	while(1)
	{
		self.n_steam_fx[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zone_capture_damage_steam"], self, Array::random(a_tags));
		wait(RandomFloatRange(0.25, 0.35));
	}
}

/*
	Name: generator_delete_damage_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8905683F
	Offset: 0x20D0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function generator_delete_damage_fx(localClientNumber)
{
	self notify("generator_stop_damage_fx");
	if(isdefined(self.n_spark_fx) && isdefined(self.n_spark_fx[localClientNumber]))
	{
		deletefx(localClientNumber, self.n_spark_fx[localClientNumber], 1);
	}
	if(isdefined(self.n_steam_fx) && isdefined(self.n_steam_fx[localClientNumber]))
	{
		deletefx(localClientNumber, self.n_steam_fx[localClientNumber], 1);
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
	if(!isdefined(self.a_fx_power_on))
	{
		self.a_fx_power_on = [];
	}
	if(isdefined(self.a_fx_power_on[localClientNumber]))
	{
		stopfx(localClientNumber, self.a_fx_power_on[localClientNumber]);
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
	self.a_fx_power_on[localClientNumber] = PlayFXOnTag(localClientNumber, var_2a0fd09, self, "j_generator_pole");
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
	self generator_fx_disable(localClientNumber);
	self thread generator_offline_light_enable(localClientNumber);
}

/*
	Name: generator_sound_enable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3BCD1A58
	Offset: 0x23D8
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function generator_sound_enable(newVal)
{
	if(!isdefined(self.snddonutent))
	{
		sndOrigin = self GetTagOrigin("j_generator_pole");
		self.snddonutent = spawn(0, sndOrigin, "script_origin");
		self.snddonutent LinkTo(self, "j_generator_pole");
		playsound(0, "zmb_capturezone_donut_start", self.origin);
		self.snddonutent thread snddemojumpmonitor();
	}
	pitch = audio::scale_speed(0, 1, 0.8, 1.6, newVal);
	loop_id = self.snddonutent PlayLoopSound("zmb_capturezone_rise", 1);
	setSoundPitch(loop_id, pitch);
	self sndliquidvats(1);
}

/*
	Name: generator_sound_disable
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAB9939AD
	Offset: 0x2550
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function generator_sound_disable()
{
	if(isdefined(self.snddonut))
	{
		playsound(0, "zmb_capturezone_donut_stop", self.origin);
		self.snddonutent delete();
		self.snddonutent = undefined;
	}
	self sndliquidvats(0);
}

/*
	Name: generator_fx_enable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x894DF69C
	Offset: 0x25C8
	Size: 0x269
	Parameters: 1
	Flags: None
*/
function generator_fx_enable(localClientNumber)
{
	self generator_fx_disable(localClientNumber);
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
	self.a_fx_power_on[localClientNumber] = PlayFXOnTag(localClientNumber, var_2a0fd09, self, "j_generator_pole");
	self.var_878c304c[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_front"], self, "fx_frnt_exhaust");
	self.var_7078bcfd[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_rear"], self, "fx_rear_exhaust");
	self.var_eb98b036[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_side"], self, "fx_vat_exhaust01");
	self.var_c59635cd[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["capture_exhaust_side"], self, "fx_vat_exhaust02");
}

/*
	Name: generator_fx_disable
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE39F3E97
	Offset: 0x2840
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function generator_fx_disable(localClientNumber)
{
	if(!isdefined(self.a_fx_power_on))
	{
		self.a_fx_power_on = [];
	}
	if(isdefined(self.a_fx_power_on[localClientNumber]))
	{
		stopfx(localClientNumber, self.a_fx_power_on[localClientNumber]);
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
	self generator_delete_damage_fx(localClientNumber);
}

/*
	Name: generator_offline_light_disable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x107883D0
	Offset: 0x2A00
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function generator_offline_light_disable(localClientNumber)
{
	if(!isdefined(self.a_fx_light))
	{
		self.a_fx_light = [];
	}
	if(isdefined(self.a_fx_light[localClientNumber]))
	{
		deletefx(localClientNumber, self.a_fx_light[localClientNumber], 1);
	}
}

/*
	Name: generator_offline_light_enable
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB177ADB6
	Offset: 0x2A68
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function generator_offline_light_enable(localClientNumber)
{
	self endon("generator_state_changed");
	self generator_offline_light_disable(localClientNumber);
	self.a_fx_light[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zapper_light_notready"], self, "tag_pole_top");
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
	Name: sndliquidvats
	Namespace: zm_tomb_capture_zones
	Checksum: 0x20CB5BB0
	Offset: 0x2BB8
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function sndliquidvats(start)
{
	if(!isdefined(self.b_liquid_vats_sound_enabled))
	{
		self.b_liquid_vats_sound_enabled = 0;
	}
	origin1 = self GetTagOrigin("vat_01_sound");
	origin2 = self GetTagOrigin("vat_02_sound");
	if(start)
	{
		if(!self.b_liquid_vats_sound_enabled)
		{
			audio::playloopat("zmb_capturezone_vat_loop", origin1);
			audio::playloopat("zmb_capturezone_vat_loop", origin2);
			self.b_liquid_vats_sound_enabled = 1;
		}
	}
	else
	{
		audio::stoploopat("zmb_capturezone_vat_loop", origin1);
		audio::stoploopat("zmb_capturezone_vat_loop", origin2);
		self.b_liquid_vats_sound_enabled = 0;
	}
}

/*
	Name: monolith_crysal_glow
	Namespace: zm_tomb_capture_zones
	Checksum: 0x20AEBA8
	Offset: 0x2CE0
	Size: 0x1D3
	Parameters: 7
	Flags: None
*/
function monolith_crysal_glow(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_crystal = get_monolith_crystal_model(fieldName, localClientNumber);
	str_exploder = "fxexp_" + level.zone_capture_exploder_ids[fieldName];
	if(newVal)
	{
		m_crystal thread crystal_flicker(localClientNumber, 0, 0.1, 2, 4, 0.5, 3);
		m_crystal StopLoopSound(1);
		exploder::stop_exploder(str_exploder, localClientNumber);
		level thread sndexploderloop(0, level.zone_capture_exploder_ids[fieldName]);
	}
	else
	{
		m_crystal thread crystal_flicker(localClientNumber, 0.65, 1, 0.7, 1, 0.05, 0.35);
		m_crystal PlayLoopSound("amb_monolith_glow");
		exploder::exploder(str_exploder, localClientNumber);
		level thread sndexploderloop(1, level.zone_capture_exploder_ids[fieldName]);
	}
}

/*
	Name: sndexploderloop
	Namespace: zm_tomb_capture_zones
	Checksum: 0xABEA51AF
	Offset: 0x2EC0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function sndexploderloop(Play, num)
{
}

/*
	Name: crystal_flicker
	Namespace: zm_tomb_capture_zones
	Checksum: 0xDD0CB07C
	Offset: 0x2EE0
	Size: 0x1AF
	Parameters: 7
	Flags: None
*/
function crystal_flicker(localClientNumber, n_glow_value_low, n_glow_value_high, n_time_update_low, n_time_update_high, n_hold_time_low, n_hold_time_high)
{
	self notify("flicker_update");
	self endon("flicker_update");
	if(!isdefined(self.n_glow_value))
	{
		self.n_glow_value = n_glow_value_low;
	}
	while(1)
	{
		n_glow_value_target = RandomFloatRange(n_glow_value_low, n_glow_value_high);
		N_TRANSITION_TIME = RandomFloatRange(n_time_update_low, n_time_update_high);
		n_steps = Int(N_TRANSITION_TIME / 0.016);
		n_change_per_step = n_glow_value_target - self.n_glow_value / n_steps;
		for(i = 0; i < n_steps; i++)
		{
			self.n_glow_value = self.n_glow_value + n_change_per_step;
			self MapShaderConstant(localClientNumber, 2, "scriptVector2", self.n_glow_value, 0, 0, 0);
			wait(0.016);
		}
		wait(RandomFloatRange(n_hold_time_low, n_hold_time_high));
	}
}

/*
	Name: crystal_glow_lerp_to_value
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC3E22AF7
	Offset: 0x3098
	Size: 0x115
	Parameters: 3
	Flags: None
*/
function crystal_glow_lerp_to_value(localClientNumber, n_glow_value_target, N_TRANSITION_TIME)
{
	self notify("flicker_update");
	self endon("flicker_update");
	if(!isdefined(self.n_glow_value))
	{
		self.n_glow_value = 1;
	}
	n_steps = Int(N_TRANSITION_TIME / 0.016);
	n_change_per_step = n_glow_value_target - self.n_glow_value / n_steps;
	for(i = 0; i < n_steps; i++)
	{
		self.n_glow_value = self.n_glow_value + n_change_per_step;
		self MapShaderConstant(localClientNumber, 2, "scriptVector2", self.n_glow_value, 0, 0, 0);
		wait(0.016);
	}
}

/*
	Name: get_monolith_crystal_model
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFDD0C945
	Offset: 0x31B8
	Size: 0x1DD
	Parameters: 2
	Flags: None
*/
function get_monolith_crystal_model(str_targetname, localClientNum)
{
	if(!isdefined(level.zone_capture_crystals))
	{
		level.zone_capture_crystals = [];
	}
	if(!isdefined(level.zone_capture_crystals[localClientNum]))
	{
		level.zone_capture_crystals[localClientNum] = [];
	}
	if(!isdefined(level.zone_capture_crystals[localClientNum][str_targetname]))
	{
		level.zone_capture_crystals[localClientNum][str_targetname] = GetEnt(localClientNum, str_targetname, "targetname");
		level.zone_capture_crystals[localClientNum][str_targetname].mapped_shader_constant = [];
		level.zone_capture_crystals[localClientNum][str_targetname].mapped_shader_constant[localClientNum] = 0;
	}
	level.zone_capture_crystals[localClientNum][str_targetname] util::waittill_dobj(localClientNum);
	if(!level.zone_capture_crystals[localClientNum][str_targetname].mapped_shader_constant[localClientNum])
	{
		level.zone_capture_crystals[localClientNum][str_targetname] MapShaderConstant(localClientNum, 2, "scriptVector2", 0);
		level.zone_capture_crystals[localClientNum][str_targetname].mapped_shader_constant[localClientNum] = 1;
	}
	/#
		Assert(isdefined(level.zone_capture_crystals[localClientNum][str_targetname]), "Dev Block strings are not supported" + str_targetname + "Dev Block strings are not supported");
	#/
	return level.zone_capture_crystals[localClientNum][str_targetname];
}

/*
	Name: pap_monolith_ring_callback
	Namespace: zm_tomb_capture_zones
	Checksum: 0x64B4D5BA
	Offset: 0x33A0
	Size: 0x193
	Parameters: 7
	Flags: None
*/
function pap_monolith_ring_callback(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_ring = get_monolith_ring_model(localClientNumber);
	if(isdefined(m_ring))
	{
		if(newVal)
		{
			m_ring thread lerp_glow_to_value(localClientNumber, 3);
			m_ring thread pap_ring_pulled_down_anim();
		}
		else
		{
			m_ring thread lerp_glow_to_value(localClientNumber, 0);
			m_ring thread pap_ring_released_anim(oldVal);
		}
	}
	m_pack_a_punch = get_pack_a_punch_model(localClientNumber);
	if(isdefined(m_pack_a_punch))
	{
		if(newVal)
		{
			m_pack_a_punch thread crystal_flicker(localClientNumber, 0.65, 1, 0.7, 1, 0.05, 0.35);
		}
		else
		{
			m_pack_a_punch show();
			m_pack_a_punch thread crystal_glow_lerp_to_value(localClientNumber, 0, 5);
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
	m_pack_a_punch = get_pack_a_punch_model(localClientNumber);
	if(isdefined(m_pack_a_punch))
	{
		m_pack_a_punch Hide();
	}
}

/*
	Name: pap_ring_pulled_down_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0x342547DA
	Offset: 0x35A0
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function pap_ring_pulled_down_anim()
{
	self notify("pap_ring_pulling_down");
	self endon("pap_ring_released");
	self clear_all_pap_ring_anims();
	self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 1, 0.2);
	WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_pull_anim) - 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
	self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 1, 0.2);
	level.var_d7512031 = 1;
}

/*
	Name: pap_ring_released_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF52F364B
	Offset: 0x3698
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function pap_ring_released_anim(oldVal)
{
	self notify("pap_ring_released");
	self endon("pap_ring_pulling_down");
	self clear_all_pap_ring_anims();
	if(oldVal)
	{
		self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_release_anim, 1, 0.2);
		WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_release_anim) - 0.2);
		self clear_all_pap_ring_anims();
	}
	self SetAnim(%p7_fxanim_zm_ori_monolith_inductor_idle_anim, 1, 0.2);
	level.var_d7512031 = 0;
}

/*
	Name: pap_monolith_ring_shake
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4A0E125A
	Offset: 0x3790
	Size: 0x1EB
	Parameters: 7
	Flags: None
*/
function pap_monolith_ring_shake(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	m_ring = get_monolith_ring_model(localClientNumber);
	m_ring endon("pap_ring_pulling_down");
	if(newVal == 1)
	{
		m_ring clear_all_pap_ring_anims();
		m_ring SetAnim(%p7_fxanim_zm_ori_monolith_inductor_shake_anim, 1, 0.2);
		WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_shake_anim) - 0.2);
		m_ring ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_shake_anim, 0.2);
		if(level.var_d7512031)
		{
			m_ring SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 1, 0.2);
			WaitRealTime(getanimlength(%p7_fxanim_zm_ori_monolith_inductor_pull_anim) - 0.2);
			m_ring ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
			m_ring SetAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 1, 0.2);
		}
		else
		{
			m_ring thread pap_ring_released_anim(0);
		}
	}
}

/*
	Name: clear_all_pap_ring_anims
	Namespace: zm_tomb_capture_zones
	Checksum: 0x34E4441D
	Offset: 0x3988
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function clear_all_pap_ring_anims()
{
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_release_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_shake_anim, 0.2);
	self ClearAnim(%p7_fxanim_zm_ori_monolith_inductor_idle_anim, 0.2);
}

/*
	Name: lerp_glow_to_value
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8F5AA8DA
	Offset: 0x3A60
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function lerp_glow_to_value(localClientNumber, n_value)
{
	self notify("new_glow_lerp_thread_started");
	self endon("new_glow_lerp_thread_started");
	if(!isdefined(self.n_glow_value))
	{
		self.n_glow_value = [];
	}
	if(!isdefined(self.n_glow_value[localClientNumber]))
	{
		self.n_glow_value[localClientNumber] = 0;
	}
	n_delta = n_value - self.n_glow_value[localClientNumber];
	n_increment = n_delta / 4.5 * 0.016;
	while(self.n_glow_value[localClientNumber] != n_value)
	{
		self.n_glow_value[localClientNumber] = math::clamp(self.n_glow_value[localClientNumber] + n_increment, 0, 3);
		self MapShaderConstant(localClientNumber, 3, "scriptVector2", 0, self.n_glow_value[localClientNumber], 0, 0);
		wait(0.016);
	}
}

/*
	Name: get_monolith_ring_model
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB0DBEBB0
	Offset: 0x3BB0
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function get_monolith_ring_model(localClientNumber)
{
	if(!isdefined(level.zone_capture_monolith_ring))
	{
		level.zone_capture_monolith_ring = [];
	}
	if(!isdefined(level.zone_capture_monolith_ring[localClientNumber]))
	{
		level.zone_capture_monolith_ring[localClientNumber] = GetEnt(localClientNumber, "pap_monolith_ring", "targetname");
	}
	level.zone_capture_monolith_ring[localClientNumber] util::waittill_dobj(localClientNumber);
	if(!level.zone_capture_monolith_ring[localClientNumber] HasAnimTree())
	{
		level.zone_capture_monolith_ring[localClientNumber] MapShaderConstant(localClientNumber, 3, "scriptVector2", 0, 0, 0, 0);
		level.zone_capture_monolith_ring[localClientNumber] useanimtree(-1);
	}
	return level.zone_capture_monolith_ring[localClientNumber];
}

/*
	Name: emergence_hole_callback
	Namespace: zm_tomb_capture_zones
	Checksum: 0x358B24E6
	Offset: 0x3CD0
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function emergence_hole_callback(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
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
		b_delete_despawn_fx = self emergence_hole_despawn(localClientNumber, oldVal && !bNewEnt && !bWasDemoJump);
		self emergence_hole_fx_stop(localClientNumber, b_delete_despawn_fx);
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
	self emergence_hole_fx_stop(localClientNumber);
	self.n_fx_spawn[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["tesla_elec_kill"], self, "tag_origin");
	self.n_fx_loop[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["screecher_hole"], self, "tag_origin");
	if(!isdefined(self.sndent))
	{
		self.sndent = spawn(localClientNumber, self.origin, "script_origin");
		self.sndent thread snddemojumpmonitor();
	}
	self.sndent PlayLoopSound("zmb_capturezone_portal_loop", 2);
	playsound(localClientNumber, "zmb_capturezone_portal_start", self.origin);
}

/*
	Name: snddemojumpmonitor
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC88CA6A6
	Offset: 0x3EF0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function snddemojumpmonitor()
{
	self endon("entityshutdown");
	level waittill("demo_jump");
	self delete();
}

/*
	Name: emergence_hole_despawn
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3109B476
	Offset: 0x3F30
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function emergence_hole_despawn(localClientNumber, b_do_despawn)
{
	if(b_do_despawn)
	{
		b_delete_despawn_fx = 0;
		PlayFXOnTag(localClientNumber, level._effect["tesla_elec_kill"], self, "tag_origin");
		playsound(localClientNumber, "zmb_capturezone_portal_stop");
	}
	return !b_do_despawn;
}

/*
	Name: emergence_hole_fx_stop
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEB2A52F0
	Offset: 0x3FC0
	Size: 0x173
	Parameters: 2
	Flags: None
*/
function emergence_hole_fx_stop(localClientNumber, b_delete_despawn_fx)
{
	if(!isdefined(b_delete_despawn_fx))
	{
		b_delete_despawn_fx = 1;
	}
	if(!isdefined(self.n_fx_spawn))
	{
		self.n_fx_spawn = [];
	}
	if(!isdefined(self.n_fx_loop))
	{
		self.n_fx_loop = [];
	}
	if(!isdefined(self.n_fx_despawn))
	{
		self.n_fx_despawn = [];
	}
	if(isdefined(self.n_fx_loop[localClientNumber]))
	{
		deletefx(localClientNumber, self.n_fx_spawn[localClientNumber], 1);
		self.n_fx_spawn[localClientNumber] = undefined;
	}
	if(isdefined(self.n_fx_loop[localClientNumber]))
	{
		deletefx(localClientNumber, self.n_fx_loop[localClientNumber], 1);
		self.n_fx_loop[localClientNumber] = undefined;
	}
	if(b_delete_despawn_fx)
	{
		if(isdefined(self.n_fx_despawn[localClientNumber]))
		{
			deletefx(localClientNumber, self.n_fx_despawn[localClientNumber], 1);
			self.n_fx_despawn[localClientNumber] = undefined;
		}
	}
	if(isdefined(self.sndent))
	{
		self.sndent delete();
	}
}

/*
	Name: capture_zombie_riser_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE0E1518A
	Offset: 0x4140
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function capture_zombie_riser_fx()
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
	Name: register_pack_a_punch_anim_sequence
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCB24D87C
	Offset: 0x41E0
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function register_pack_a_punch_anim_sequence()
{
	add_pack_a_punch_progress_anims(0, undefined, %p7_fxanim_zm_ori_pack_return_pc1_anim);
	add_pack_a_punch_progress_anims(1, %p7_fxanim_zm_ori_pack_pc1_anim, %p7_fxanim_zm_ori_pack_return_pc2_anim);
	add_pack_a_punch_progress_anims(2, %p7_fxanim_zm_ori_pack_pc2_anim, %p7_fxanim_zm_ori_pack_return_pc3_anim);
	add_pack_a_punch_progress_anims(3, %p7_fxanim_zm_ori_pack_pc3_anim, %p7_fxanim_zm_ori_pack_return_pc4_anim);
	add_pack_a_punch_progress_anims(4, %p7_fxanim_zm_ori_pack_pc4_anim, %p7_fxanim_zm_ori_pack_return_pc5_anim);
	add_pack_a_punch_progress_anims(5, %p7_fxanim_zm_ori_pack_pc5_anim, %p7_fxanim_zm_ori_pack_return_pc6_anim);
	add_pack_a_punch_progress_anims(6, %p7_fxanim_zm_ori_pack_pc6_anim, undefined);
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
	m_pap = get_pack_a_punch_model(localClientNum);
	b_snap_to_anim = bNewEnt || bInitialSnap || bWasDemoJump;
	if(newVal > oldVal || b_snap_to_anim)
	{
		for(i = 1; i <= newVal; i++)
		{
			n_anim_time = 1;
			n_anim_rate = 0;
			if(i == newVal && !b_snap_to_anim)
			{
				n_anim_time = 0;
				n_anim_rate = 1;
			}
			anim_clear = level.pack_a_punch_anim_sequence["disassemble"][i - 1];
			if(isdefined(anim_clear))
			{
				m_pap ClearAnim(anim_clear, 0);
			}
			anim_assemble = level.pack_a_punch_anim_sequence["assemble"][i];
			m_pap SetAnim(anim_assemble, 1, 0, n_anim_rate);
			m_pap SetAnimTime(anim_assemble, n_anim_time);
		}
		break;
	}
	if(newVal < oldVal)
	{
		for(i = level.pack_a_punch_anim_sequence["disassemble"].size - 1; i >= newVal; i--)
		{
			n_anim_time = 1;
			n_anim_rate = 0;
			if(i == newVal)
			{
				n_anim_time = 0;
				n_anim_rate = 1;
			}
			anim_clear = level.pack_a_punch_anim_sequence["assemble"][i + 1];
			if(isdefined(anim_clear))
			{
				m_pap ClearAnim(anim_clear, 0);
			}
			anim_disassemble = level.pack_a_punch_anim_sequence["disassemble"][i];
			m_pap SetAnim(anim_disassemble, 1, n_anim_time, n_anim_rate);
			m_pap SetAnimTime(anim_disassemble, n_anim_time);
		}
	}
}

/*
	Name: add_pack_a_punch_progress_anims
	Namespace: zm_tomb_capture_zones
	Checksum: 0x24018A81
	Offset: 0x4650
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function add_pack_a_punch_progress_anims(n_index, anim_assemble, anim_disassemble)
{
	if(!isdefined(level.pack_a_punch_anim_sequence))
	{
		level.pack_a_punch_anim_sequence = [];
	}
	if(!isdefined(level.pack_a_punch_anim_sequence["assemble"]))
	{
		level.pack_a_punch_anim_sequence["assemble"] = [];
	}
	if(!isdefined(level.pack_a_punch_anim_sequence["disassemble"]))
	{
		level.pack_a_punch_anim_sequence["disassemble"] = [];
	}
	level.pack_a_punch_anim_sequence["assemble"][n_index] = anim_assemble;
	level.pack_a_punch_anim_sequence["disassemble"][n_index] = anim_disassemble;
}

/*
	Name: get_pack_a_punch_model
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1DFAF84A
	Offset: 0x4720
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function get_pack_a_punch_model(localClientNumber)
{
	if(!isdefined(level.pack_a_punch_model))
	{
		level.pack_a_punch_model = [];
	}
	if(!isdefined(level.pack_a_punch_model[localClientNumber]))
	{
		level.pack_a_punch_model[localClientNumber] = GetEnt(localClientNumber, "pap_cs", "targetname");
	}
	level.pack_a_punch_model[localClientNumber] util::waittill_dobj(localClientNumber);
	if(!level.pack_a_punch_model[localClientNumber] HasAnimTree())
	{
		level.pack_a_punch_model[localClientNumber] useanimtree(-1);
		level.pack_a_punch_model[localClientNumber] MapShaderConstant(localClientNumber, 2, "ScriptVector0", 1);
	}
	return level.pack_a_punch_model[localClientNumber];
}

/*
	Name: init_custom_pap
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE7ADA483
	Offset: 0x4840
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function init_custom_pap()
{
	util::waitforallclients();
	a_players = GetLocalPlayers();
	for(localClientNum = 0; localClientNum < a_players.size; localClientNum++)
	{
		e_custom_pap = get_pack_a_punch_model(localClientNum);
	}
}

/*
	Name: zone_capture_zombie_callback
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB60DD6ED
	Offset: 0x48C8
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function zone_capture_zombie_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self._aitype = "zm_tomb_basic_zone_capture";
		self thread zm::handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump);
		self._eyeglow_fx_override = level._effect["crusader_zombie_eyes"];
		self zm::deleteZombieEyes(localClientNum);
		self zm::createZombieEyes(localClientNum);
		self capture_zombie_torso_fx_enable(localClientNum);
	}
}

/*
	Name: capture_zombie_torso_fx_enable
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE240295D
	Offset: 0x49B8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function capture_zombie_torso_fx_enable(localClientNumber)
{
	self capture_zombie_torso_fx_disable(localClientNumber);
	self.a_fx_torso[localClientNumber] = PlayFXOnTag(localClientNumber, level._effect["zone_capture_zombie_torso_fx"], self, "J_Spine4");
	if(!isdefined(self.sndent))
	{
		self.sndent = spawn(0, self.origin, "script_origin");
		self.sndent LinkTo(self);
		self thread snddeleteent(self.sndent);
	}
	self.sndent PlayLoopSound("zmb_capturezone_zombie_loop", 1);
}

/*
	Name: snddeleteent
	Namespace: zm_tomb_capture_zones
	Checksum: 0x501E2868
	Offset: 0x4AC0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function snddeleteent(ent)
{
	self util::waittill_any("death", "entityshutdown");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: capture_zombie_torso_fx_disable
	Namespace: zm_tomb_capture_zones
	Checksum: 0xBC20094F
	Offset: 0x4B20
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function capture_zombie_torso_fx_disable(localClientNumber)
{
	if(!isdefined(self.a_fx_torso))
	{
		self.a_fx_torso = [];
	}
	if(isdefined(self.a_fx_torso[localClientNumber]))
	{
		deletefx(localClientNumber, self.a_fx_torso[localClientNumber], 1);
	}
}

/*
	Name: register_exploders_with_capture_zones
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCF826BC5
	Offset: 0x4B88
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function register_exploders_with_capture_zones()
{
	add_exploder_id_to_zone_capture_field("zone_capture_monolith_crystal_1", 5001);
	add_exploder_id_to_zone_capture_field("zone_capture_monolith_crystal_2", 5002);
	add_exploder_id_to_zone_capture_field("zone_capture_monolith_crystal_3", 5003);
	add_exploder_id_to_zone_capture_field("zone_capture_monolith_crystal_4", 5004);
	add_exploder_id_to_zone_capture_field("zone_capture_monolith_crystal_5", 5005);
	add_exploder_id_to_zone_capture_field("zone_capture_monolith_crystal_6", 5006);
}

/*
	Name: add_exploder_id_to_zone_capture_field
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9E9E38D3
	Offset: 0x4C58
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function add_exploder_id_to_zone_capture_field(str_field_name, n_exploder_id)
{
	if(!isdefined(level.zone_capture_exploder_ids))
	{
		level.zone_capture_exploder_ids = [];
	}
	if(!isdefined(level.zone_capture_exploder_ids[str_field_name]))
	{
		level.zone_capture_exploder_ids[str_field_name] = n_exploder_id;
	}
}

/*
	Name: register_perk_machine_smoke_struct_references
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFA41AC88
	Offset: 0x4CB8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function register_perk_machine_smoke_struct_references()
{
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_1", "revive_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_3", "speedcola_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_4", "jugg_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_5", "staminup_pipes");
}

/*
	Name: register_perk_machine_smoke_struct_with_field_name
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC18DD335
	Offset: 0x4D48
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function register_perk_machine_smoke_struct_with_field_name(str_field_name, str_perk_machine_struct_targetname)
{
	if(!isdefined(level.perk_machine_smoke_struct_references))
	{
		level.perk_machine_smoke_struct_references = [];
	}
	if(!isdefined(level.perk_machine_smoke_struct_references[str_field_name]))
	{
		level.perk_machine_smoke_struct_references[str_field_name] = str_perk_machine_struct_targetname;
	}
}

/*
	Name: pap_emissive_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA2A1FC6F
	Offset: 0x4DA8
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function pap_emissive_fx(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
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
	Name: perk_machine_smoke_fx_always_on_callback
	Namespace: zm_tomb_capture_zones
	Checksum: 0x6C1BDC3A
	Offset: 0x4EA0
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function perk_machine_smoke_fx_always_on_callback(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		s_pipes_mule_kick = struct::get("mulekick_pipes", "targetname");
		s_pipes_mule_kick perk_pipe_smoke_fx_enable(localClientNumber);
	}
}

/*
	Name: perk_machine_smoke_fx_callback
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3DBA3EC9
	Offset: 0x4F38
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function perk_machine_smoke_fx_callback(localClientNumber, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	s_pipes = get_perk_machine_smoke_fx_struct_from_field_name(fieldName);
	if(isdefined(s_pipes))
	{
		if(newVal == 1)
		{
			s_pipes perk_pipe_smoke_fx_enable(localClientNumber);
		}
		else
		{
			s_pipes perk_pipe_smoke_fx_disable(localClientNumber);
		}
	}
}

/*
	Name: get_perk_machine_smoke_fx_struct_from_field_name
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF6A439C7
	Offset: 0x4FF8
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function get_perk_machine_smoke_fx_struct_from_field_name(str_field_name)
{
	s_fx = undefined;
	if(isdefined(level.perk_machine_smoke_struct_references[str_field_name]))
	{
		if(!isdefined(level.perk_machine_smoke_structs))
		{
			level.perk_machine_smoke_structs = [];
		}
		if(!isdefined(level.perk_machine_smoke_structs[level.perk_machine_smoke_struct_references[str_field_name]]))
		{
			level.perk_machine_smoke_structs[level.perk_machine_smoke_struct_references[str_field_name]] = struct::get(level.perk_machine_smoke_struct_references[str_field_name], "targetname");
		}
		s_fx = level.perk_machine_smoke_structs[level.perk_machine_smoke_struct_references[str_field_name]];
	}
	return s_fx;
}

/*
	Name: perk_pipe_smoke_fx_disable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8EF1C42E
	Offset: 0x50C8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function perk_pipe_smoke_fx_disable(localClientNumber)
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
	Name: perk_pipe_smoke_fx_enable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x628AA4F
	Offset: 0x5130
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function perk_pipe_smoke_fx_enable(localClientNumber)
{
	self perk_pipe_smoke_fx_disable(localClientNumber);
	self.a_fx[localClientNumber] = playFX(localClientNumber, level._effect["perk_pipe_smoke"], self.origin, AnglesToForward(self.angles));
}

