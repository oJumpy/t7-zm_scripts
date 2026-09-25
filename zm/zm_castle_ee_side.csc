#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_61c0be00;

/*
	Name: __init__sytem__
	Namespace: namespace_61c0be00
	Checksum: 0xCC1194B6
	Offset: 0x308
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee_side", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_61c0be00
	Checksum: 0x9E99A542
	Offset: 0x348
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["clocktower_flash"] = "dlc1/castle/fx_lightning_strike_weathervane";
	level._effect["exploding_death"] = "dlc1/zmb_weapon/fx_ee_plunger_teleport_impact";
	clientfield::register("world", "clocktower_flash", 5000, 1, "counter", &function_c7500953, 0, 0);
	clientfield::register("world", "sndUEB", 5000, 1, "int", &function_b5d300ce, 0, 0);
	clientfield::register("actor", "plunger_exploding_ai", 5000, 1, "int", &function_b3f0d569, 0, 0);
	clientfield::register("toplayer", "plunger_charged_strike", 5000, 1, "counter", &function_e43cd8, 0, 0);
}

/*
	Name: function_c7500953
	Namespace: namespace_61c0be00
	Checksum: 0x8665134F
	Offset: 0x4A8
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_c7500953(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_1f1c6e96 = struct::get("ee_clocktower_lightning_rod", "targetname");
	playFX(localClientNum, level._effect["clocktower_flash"], var_1f1c6e96.origin);
}

/*
	Name: function_b5d300ce
	Namespace: namespace_61c0be00
	Checksum: 0xCF7258A2
	Offset: 0x550
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_b5d300ce(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playsound(0, "zmb_pyramid_energy_ball_start", (-1192, 2256, 320));
		audio::playloopat("zmb_pyramid_energy_ball_lp", (-1192, 2256, 320));
	}
	else
	{
		playsound(0, "zmb_pyramid_energy_ball_end", (-1192, 2256, 320));
		audio::stoploopat("zmb_pyramid_energy_ball_lp", (-1192, 2256, 320));
	}
}

/*
	Name: function_b3f0d569
	Namespace: namespace_61c0be00
	Checksum: 0xF12D3C0E
	Offset: 0x648
	Size: 0x13B
	Parameters: 7
	Flags: None
*/
function function_b3f0d569(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		v_pos = self GetTagOrigin("j_spine4");
		v_angles = self GetTagAngles("j_spine4");
		var_e6ddb5de = util::spawn_model(localClientNum, "tag_origin", v_pos, v_angles);
		PlayFXOnTag(localClientNum, level._effect["exploding_death"], var_e6ddb5de, "tag_origin");
		var_e6ddb5de playsound(localClientNum, "evt_ai_explode");
		WaitRealTime(6);
		var_e6ddb5de delete();
	}
}

/*
	Name: function_e43cd8
	Namespace: namespace_61c0be00
	Checksum: 0xDBEED443
	Offset: 0x790
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_e43cd8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayViewmodelFX(localClientNum, level._effect["plunger_charge_1p"], "tag_fx");
	PlayFXOnTag(localClientNum, level._effect["plunger_charge_3p"], self, "tag_fx");
}

