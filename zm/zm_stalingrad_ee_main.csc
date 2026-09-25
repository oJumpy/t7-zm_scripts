#using scripts\codescripts\struct;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_c5d72679;

/*
	Name: __init__sytem__
	Namespace: namespace_c5d72679
	Checksum: 0xD950B922
	Offset: 0x670
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_ee_main", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c5d72679
	Checksum: 0xBF6C8032
	Offset: 0x6B0
	Size: 0x633
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["ee_anomaly_hit"] = "dlc3/stalingrad/fx_main_anomoly_hit";
	level._effect["ee_anomaly_pulse"] = "dlc3/stalingrad/fx_main_anomoly_emp_pulse";
	level._effect["ee_anomaly_loop"] = "dlc3/stalingrad/fx_main_anomoly_loop_trail";
	level._effect["ee_anomaly_talk"] = "dlc3/stalingrad/fx_main_anomoly_loop_trail_talk";
	level._effect["ee_drone_cam"] = "dlc3/stalingrad/fx_main_sentinel_drone_scanner";
	level._effect["ee_raz_eye"] = "dlc3/stalingrad/fx_main_raz_eye_glow_friendly";
	level._effect["ee_sewer_switch"] = "dlc3/stalingrad/fx_main_impact_success";
	level._effect["post_outro_smoke"] = "dlc3/stalingrad/fx_mech_vdest_smoke_column";
	clientfield::register("scriptmover", "ee_anomaly_hit", 12000, 1, "counter", &function_f5deabb1, 0, 0);
	clientfield::register("scriptmover", "ee_anomaly_loop", 12000, 1, "int", &function_d1216748, 0, 0);
	clientfield::register("scriptmover", "ee_cargo_explosion", 12000, 1, "int", &function_9a9410ac, 0, 0);
	clientfield::register("vehicle", "ee_drone_cam_override", 12000, 1, "int", &function_5bdec411, 0, 0);
	clientfield::register("scriptmover", "ee_generator_kill", 12000, 1, "int", &function_2a4222fe, 0, 0);
	clientfield::register("scriptmover", "ee_generator_target", 12000, 1, "int", &function_3a96f955, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_1", 12000, 2, "int", &function_ee9d73b7, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_2", 12000, 2, "int", &function_7c96047c, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_3", 12000, 2, "int", &function_a2987ee5, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_4", 12000, 2, "int", &function_30910faa, 0, 0);
	clientfield::register("toplayer", "ee_lockdown_fog", 12000, 1, "int", &function_1616098c, 0, 0);
	clientfield::register("actor", "ee_raz_eye_override", 12000, 1, "int", &function_17268d90, 0, 0);
	clientfield::register("scriptmover", "ee_sewer_switch", 12000, 1, "int", &function_f1804aa5, 0, 0);
	clientfield::register("world", "ee_eye_beam_rumble", 12000, 1, "int", &function_ae73f9d5, 0, 0);
	clientfield::register("toplayer", "ee_hatch_strain_rumble", 12000, 1, "int", &function_fb18b2da, 0, 0);
	clientfield::register("scriptmover", "ee_hatch_break_rumble", 12000, 1, "int", &function_ebc93656, 0, 0);
	clientfield::register("scriptmover", "ee_safe_smash_rumble", 12000, 1, "int", &function_61ba3846, 0, 0);
	clientfield::register("scriptmover", "ee_timed_explosion_rumble", 12000, 1, "counter", &function_fa9a5ecf, 0, 0);
	clientfield::register("scriptmover", "post_outro_smoke", 12000, 1, "int", &function_725d353b, 0, 0);
}

/*
	Name: function_f5deabb1
	Namespace: namespace_c5d72679
	Checksum: 0x94C430C7
	Offset: 0xCF0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_f5deabb1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["ee_anomaly_hit"], self.origin);
	}
}

/*
	Name: function_d1216748
	Namespace: namespace_c5d72679
	Checksum: 0x8D7E4071
	Offset: 0xD70
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function function_d1216748(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, level._effect["ee_anomaly_pulse"], self.origin);
	PlayRumbleOnPosition(localClientNum, "zm_stalingrad_ee_pursue_pulse", self.origin);
	if(newVal == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			stopfx(localClientNum, self.n_fx_id);
		}
		self.n_fx_id = PlayFXOnTag(localClientNum, level._effect["ee_anomaly_loop"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localClientNum, self.n_fx_id);
	}
	self.n_fx_id = PlayFXOnTag(localClientNum, level._effect["ee_anomaly_talk"], self, "tag_origin");
}

/*
	Name: function_9a9410ac
	Namespace: namespace_c5d72679
	Checksum: 0xFB53C5F5
	Offset: 0xEE8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_9a9410ac(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["generic_explosion"], self.origin);
	}
}

/*
	Name: function_5bdec411
	Namespace: namespace_c5d72679
	Checksum: 0x80122B44
	Offset: 0xF68
	Size: 0x14D
	Parameters: 7
	Flags: None
*/
function function_5bdec411(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(isdefined(self.CameraScannerFX))
		{
			stopfx(localClientNum, self.CameraScannerFX);
		}
		if(!isdefined(self.var_734c069))
		{
			self.var_734c069 = self PlayLoopSound("zmb_scenario_magneto_ping");
		}
		self.CameraScannerFX = PlayFXOnTag(localClientNum, level._effect["ee_drone_cam"], self, "tag_flash");
	}
	else if(isdefined(self.CameraScannerFX))
	{
		stopfx(localClientNum, self.CameraScannerFX);
		self.CameraScannerFX = undefined;
	}
	if(isdefined(self.var_734c069))
	{
		self StopLoopSound(self.var_734c069);
		self.var_734c069 = undefined;
	}
}

/*
	Name: function_2a4222fe
	Namespace: namespace_c5d72679
	Checksum: 0x1475D7E0
	Offset: 0x10C0
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function function_2a4222fe(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		var_b4349698 = level.var_346f70b8[localClientNum];
		level beam::launch(self, "tag_origin", var_b4349698, "tag_origin", "electric_arc_zombie_to_drop_pod");
		var_b4349698 playsound(0, "zmb_pod_electrocute");
		wait(0.2);
		level beam::kill(self, "tag_origin", var_b4349698, "tag_origin", "electric_arc_zombie_to_drop_pod");
		self playsound(0, "zmb_pod_electrocute_zmb");
	}
}

/*
	Name: function_3a96f955
	Namespace: namespace_c5d72679
	Checksum: 0x927A044A
	Offset: 0x11D0
	Size: 0x61
	Parameters: 7
	Flags: None
*/
function function_3a96f955(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_346f70b8[localClientNum] = self;
	}
	else
	{
		level.var_346f70b8 = undefined;
	}
}

/*
	Name: function_ee9d73b7
	Namespace: namespace_c5d72679
	Checksum: 0xDC55E5F2
	Offset: 0x1240
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_ee9d73b7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_b1ffcb5c(localClientNum, 0, newVal);
}

/*
	Name: function_7c96047c
	Namespace: namespace_c5d72679
	Checksum: 0xE5283CC6
	Offset: 0x12A8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_7c96047c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_b1ffcb5c(localClientNum, 1, newVal);
}

/*
	Name: function_a2987ee5
	Namespace: namespace_c5d72679
	Checksum: 0xBDF2A043
	Offset: 0x1310
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_a2987ee5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_b1ffcb5c(localClientNum, 2, newVal);
}

/*
	Name: function_30910faa
	Namespace: namespace_c5d72679
	Checksum: 0x88C02C66
	Offset: 0x1378
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_30910faa(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_b1ffcb5c(localClientNum, 3, newVal);
}

/*
	Name: function_b1ffcb5c
	Namespace: namespace_c5d72679
	Checksum: 0xEE444E37
	Offset: 0x13E0
	Size: 0x159
	Parameters: 3
	Flags: None
*/
function function_b1ffcb5c(localClientNum, var_46ab6018, newVal)
{
	if(!isdefined(self.var_b3ab5e19))
	{
		self.var_b3ab5e19 = [];
	}
	if(isdefined(self.var_b3ab5e19[var_46ab6018]))
	{
		stopfx(localClientNum, self.var_b3ab5e19[var_46ab6018]);
	}
	if(newVal == 0)
	{
		return;
	}
	if(newVal == 1)
	{
		str_fx = "dlc3/stalingrad/fx_glow_red_dragonstrike";
	}
	else if(newVal == 2)
	{
		str_fx = "dlc3/stalingrad/fx_glow_green_dragonstrike";
	}
	var_9bcca82d = var_46ab6018 + 1;
	str_tag = "tag_dragon_network_console_terminal_light_green_0" + var_9bcca82d;
	v_position = self GetTagOrigin(str_tag) + (1.25, -1.25, -0.25);
	self.var_b3ab5e19[var_46ab6018] = playFX(localClientNum, str_fx, v_position);
}

/*
	Name: function_1616098c
	Namespace: namespace_c5d72679
	Checksum: 0xF4E1E49D
	Offset: 0x1548
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_1616098c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		SetLitFogBank(localClientNum, -1, 2, -1);
		SetWorldFogActiveBank(localClientNum, 4);
	}
	else
	{
		SetLitFogBank(localClientNum, -1, 0, -1);
		SetWorldFogActiveBank(localClientNum, 1);
	}
}

/*
	Name: function_17268d90
	Namespace: namespace_c5d72679
	Checksum: 0xB9414636
	Offset: 0x1610
	Size: 0xD1
	Parameters: 7
	Flags: None
*/
function function_17268d90(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(isdefined(self._eyeArray))
		{
			if(isdefined(self._eyeArray[localClientNum]))
			{
				deletefx(localClientNum, self._eyeArray[localClientNum], 1);
			}
		}
		self._eyeArray[localClientNum] = PlayFXOnTag(localClientNum, level._effect["ee_raz_eye"], self, "tag_eye_glow");
	}
}

/*
	Name: function_f1804aa5
	Namespace: namespace_c5d72679
	Checksum: 0x5999BFF8
	Offset: 0x16F0
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_f1804aa5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		playFX(localClientNum, level._effect["ee_sewer_switch"], self.origin);
	}
}

/*
	Name: function_ae73f9d5
	Namespace: namespace_c5d72679
	Checksum: 0xD062AC1C
	Offset: 0x1778
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_ae73f9d5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		var_1f9211a4 = struct::get("ee_core_end_struct", "targetname");
		PlayRumbleOnPosition(localClientNum, "zm_stalingrad_ee_eye_beam", var_1f9211a4.origin);
	}
}

/*
	Name: function_fb18b2da
	Namespace: namespace_c5d72679
	Checksum: 0xDB1071F1
	Offset: 0x1820
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_fb18b2da(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self PlayRumbleLoopOnEntity(localClientNum, "zm_stalingrad_ee_hatch");
	}
	else
	{
		self StopRumble(localClientNum, "zm_stalingrad_ee_hatch");
	}
}

/*
	Name: function_ebc93656
	Namespace: namespace_c5d72679
	Checksum: 0x465C545A
	Offset: 0x18B8
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_ebc93656(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayRumbleOnPosition(localClientNum, "zm_stalingrad_ee_sophia_small", self.origin);
	}
}

/*
	Name: function_61ba3846
	Namespace: namespace_c5d72679
	Checksum: 0xB9151C28
	Offset: 0x1930
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_61ba3846(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayRumbleOnPosition(localClientNum, "zm_stalingrad_ee_safe_smash", self.origin);
	}
}

/*
	Name: function_fa9a5ecf
	Namespace: namespace_c5d72679
	Checksum: 0xD7C69494
	Offset: 0x19A8
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_fa9a5ecf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayRumbleOnPosition(localClientNum, "zm_stalingrad_drop_pod_explosion", self.origin);
	}
}

/*
	Name: function_725d353b
	Namespace: namespace_c5d72679
	Checksum: 0xD745BA0F
	Offset: 0x1A20
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_725d353b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["post_outro_smoke"], self, "tag_body");
	}
}

