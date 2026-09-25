#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_e0675efb;

/*
	Name: __init__sytem__
	Namespace: namespace_e0675efb
	Checksum: 0x3B5AD3F9
	Offset: 0x3B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_challenges", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_e0675efb
	Checksum: 0x8A3D9FC6
	Offset: 0x3F0
	Size: 0x3E3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	var_a42274ee = struct::get_array("challenge_fire_struct", "targetname");
	foreach(var_d2c81bd9 in var_a42274ee)
	{
		var_d2c81bd9.var_90369c89 = [];
	}
	level function_5d17d17c();
	level._effect["grave_fire"] = "dlc3/stalingrad/fx_grave_stone_glow";
	level._effect["grave_arm_fx"] = "dlc3/stalingrad/fx_dirt_hand_burst_challenges";
	level._effect["pr_c_fx"] = "fire/fx_fire_candle_flame_tall";
	clientfield::register("toplayer", "challenge_grave_fire", 12000, 2, "int", &function_6f749a23, 0, 1);
	clientfield::register("scriptmover", "challenge_arm_reveal", 12000, 1, "counter", &function_87a462eb, 0, 0);
	clientfield::register("toplayer", "pr_b", 12000, 3, "int", &function_93efc4ef, 0, 1);
	clientfield::register("toplayer", "pr_c", 12000, 3, "int", &function_553225f, 0, 1);
	clientfield::register("toplayer", "pr_l_c", 12000, 1, "int", &function_20880e24, 0, 0);
	clientfield::register("missile", "pr_gm_e_fx", 12000, 1, "int", &function_e28f1c4a, 0, 0);
	clientfield::register("scriptmover", "pr_g_c_fx", 12000, 1, "int", &function_d4db02b2, 0, 0);
	clientfield::register("toplayer", "challenge1state", 14000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge2state", 14000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge3state", 14000, 2, "int", &function_4ff59189, 0, 0);
}

/*
	Name: function_5d17d17c
	Namespace: namespace_e0675efb
	Checksum: 0xE83B2096
	Offset: 0x7E0
	Size: 0x165
	Parameters: 0
	Flags: None
*/
function function_5d17d17c()
{
	var_77797571 = struct::get_array("pr_b_spawn", "targetname");
	foreach(var_4af818ae in var_77797571)
	{
		var_4af818ae.var_46f4840b = [];
	}
	var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
	foreach(var_238c2594 in var_977659a7)
	{
		var_238c2594.var_453e8445 = [];
		var_238c2594.var_90369c89 = [];
	}
}

/*
	Name: function_6f749a23
	Namespace: namespace_e0675efb
	Checksum: 0x8774C0A6
	Offset: 0x950
	Size: 0x1F5
	Parameters: 7
	Flags: None
*/
function function_6f749a23(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_a42274ee = struct::get_array("challenge_fire_struct", "targetname");
	foreach(var_d2c81bd9 in var_a42274ee)
	{
		if(var_d2c81bd9.script_int == self GetEntityNumber())
		{
			if(!isdefined(var_d2c81bd9.var_90369c89[localClientNum]))
			{
				var_d2c81bd9.var_90369c89[localClientNum] = playFX(localClientNum, level._effect["grave_fire"], var_d2c81bd9.origin + VectorScale((0, 0, -1), 8));
				audio::playloopat("zmb_challenge_fire_lp", var_d2c81bd9.origin);
			}
			continue;
		}
		if(isdefined(var_d2c81bd9.var_90369c89[localClientNum]))
		{
			deletefx(localClientNum, var_d2c81bd9.var_90369c89[localClientNum]);
			var_d2c81bd9.var_90369c89[localClientNum] = undefined;
		}
	}
}

/*
	Name: function_87a462eb
	Namespace: namespace_e0675efb
	Checksum: 0x2AF06309
	Offset: 0xB50
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_87a462eb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayRumbleOnPosition(localClientNum, "zm_stalingrad_challenge_arm_rumble", self.origin);
		playFX(localClientNum, level._effect["grave_arm_fx"], self.origin, (0, 0, 1));
	}
}

/*
	Name: function_93efc4ef
	Namespace: namespace_e0675efb
	Checksum: 0x8EB9F25B
	Offset: 0xC00
	Size: 0x259
	Parameters: 7
	Flags: None
*/
function function_93efc4ef(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_77797571 = struct::get_array("pr_b_spawn", "targetname");
	if(newVal == 4)
	{
		foreach(var_4af818ae in var_77797571)
		{
			if(isdefined(var_4af818ae.var_46f4840b[localClientNum]))
			{
				var_4af818ae.var_46f4840b[localClientNum] delete();
			}
		}
		break;
	}
	foreach(var_4af818ae in var_77797571)
	{
		if(var_4af818ae.script_int == self GetEntityNumber())
		{
			if(!isdefined(var_4af818ae.var_46f4840b[localClientNum]))
			{
				var_4af818ae.var_46f4840b[localClientNum] = util::spawn_model(localClientNum, "p7_foliage_flower_bouquet_glass", var_4af818ae.origin, var_4af818ae.angles);
			}
			continue;
		}
		if(isdefined(var_4af818ae.var_46f4840b[localClientNum]))
		{
			var_4af818ae.var_46f4840b[localClientNum] delete();
		}
	}
}

/*
	Name: function_553225f
	Namespace: namespace_e0675efb
	Checksum: 0x3F4A4969
	Offset: 0xE68
	Size: 0x379
	Parameters: 7
	Flags: None
*/
function function_553225f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
	if(newVal == 4)
	{
		foreach(var_238c2594 in var_977659a7)
		{
			if(isdefined(var_238c2594.var_453e8445[localClientNum]))
			{
				var_238c2594.var_453e8445[localClientNum] delete();
			}
			if(isdefined(var_238c2594.var_90369c89[localClientNum]))
			{
				deletefx(localClientNum, var_238c2594.var_90369c89[localClientNum]);
			}
		}
		break;
	}
	foreach(var_238c2594 in var_977659a7)
	{
		if(var_238c2594.script_int == self GetEntityNumber())
		{
			if(!isdefined(var_238c2594.var_453e8445[localClientNum]))
			{
				if(isdefined(self.var_d3aeebe1) && self.var_d3aeebe1)
				{
					STR_MODEL = "p7_candle_tall_on";
					var_238c2594.var_90369c89[localClientNum] = playFX(localClientNum, level._effect["pr_c_fx"], var_238c2594.origin + (-1.25, 0, 5));
				}
				else
				{
					STR_MODEL = "p7_candle_tall";
				}
				var_238c2594.var_453e8445[localClientNum] = util::spawn_model(localClientNum, STR_MODEL, var_238c2594.origin, var_238c2594.angles);
			}
			continue;
		}
		if(isdefined(var_238c2594.var_453e8445[localClientNum]))
		{
			var_238c2594.var_453e8445[localClientNum] delete();
		}
		if(isdefined(var_238c2594.var_90369c89[localClientNum]))
		{
			deletefx(localClientNum, var_238c2594.var_90369c89[localClientNum]);
		}
	}
}

/*
	Name: function_20880e24
	Namespace: namespace_e0675efb
	Checksum: 0x568E291A
	Offset: 0x11F0
	Size: 0x1FB
	Parameters: 7
	Flags: None
*/
function function_20880e24(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
		foreach(var_238c2594 in var_977659a7)
		{
			if(var_238c2594.script_int == self GetEntityNumber())
			{
				if(isdefined(var_238c2594.var_453e8445[localClientNum]) && (!isdefined(self.var_d3aeebe1) && self.var_d3aeebe1))
				{
					self.var_d3aeebe1 = 1;
					var_238c2594.var_453e8445[localClientNum] SetModel("p7_candle_tall_on");
					var_238c2594.var_453e8445[localClientNum] PlayLoopSound("zmb_candle_pickup_lp");
					var_238c2594.var_90369c89[localClientNum] = playFX(localClientNum, level._effect["pr_c_fx"], var_238c2594.origin + (-1.25, 0, 5));
				}
			}
		}
	}
}

/*
	Name: function_e28f1c4a
	Namespace: namespace_e0675efb
	Checksum: 0xC5947C59
	Offset: 0x13F8
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_e28f1c4a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["generic_explosion"], self.origin);
		PlayRumbleOnPosition(localClientNum, "zm_stalingrad_ee_safe_smash", self.origin);
		self playsound(0, "wpn_grenade_explode");
	}
}

/*
	Name: function_d4db02b2
	Namespace: namespace_e0675efb
	Checksum: 0x7D99140A
	Offset: 0x14C0
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_d4db02b2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.n_fx_id = playFX(localClientNum, level._effect["pr_c_fx"], self.origin + (-1.25, 0, 5));
	}
	else
	{
		stopfx(localClientNum, self.n_fx_id);
	}
}

/*
	Name: function_4ff59189
	Namespace: namespace_e0675efb
	Checksum: 0x5C5B9777
	Offset: 0x1578
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_4ff59189(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	var_42bfa7b6 = GetUIModel(GetUIModelForController(localClientNum), "trialWidget." + fieldName);
	if(isdefined(var_42bfa7b6))
	{
		SetUIModelValue(var_42bfa7b6, newVal);
	}
}

