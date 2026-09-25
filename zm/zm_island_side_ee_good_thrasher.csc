#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_f777c489;

/*
	Name: init
	Namespace: namespace_f777c489
	Checksum: 0xBD4BE237
	Offset: 0x2D8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function init()
{
	var_b20c97f = GetMinBitCountForNum(7);
	var_1b7d5552 = GetMinBitCountForNum(3);
	clientfield::register("scriptmover", "side_ee_gt_spore_glow_fx", 9000, 1, "int", &function_f72d6a5e, 0, 0);
	clientfield::register("scriptmover", "side_ee_gt_spore_cloud_fx", 9000, var_b20c97f, "int", &function_7583072e, 0, 0);
	clientfield::register("actor", "side_ee_gt_spore_trail_enemy_fx", 9000, 1, "int", &function_f68bb4e3, 0, 0);
	clientfield::register("allplayers", "side_ee_gt_spore_trail_player_fx", 9000, var_1b7d5552, "int", &function_f68bb4e3, 0, 0);
	clientfield::register("actor", "good_thrasher_fx", 9000, 1, "int", &function_9993f1d3, 0, 0);
}

/*
	Name: function_f72d6a5e
	Namespace: namespace_f777c489
	Checksum: 0x87EEA4DE
	Offset: 0x490
	Size: 0x115
	Parameters: 7
	Flags: None
*/
function function_f72d6a5e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(isdefined(self.var_a1aff3d8))
		{
			stopfx(localClientNum, self.var_a1aff3d8);
		}
		self.var_a1aff3d8 = playFX(localClientNum, level._effect["SPORE_GLOW"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
	}
	else if(isdefined(self.var_a1aff3d8))
	{
		stopfx(localClientNum, self.var_a1aff3d8);
		self.var_a1aff3d8 = undefined;
	}
}

/*
	Name: function_7583072e
	Namespace: namespace_f777c489
	Checksum: 0x5ECC3137
	Offset: 0x5B0
	Size: 0x19D
	Parameters: 7
	Flags: None
*/
function function_7583072e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal >= 1)
	{
		var_74df34f7 = ArrayGetClosest(self.origin, struct::get_array("s_side_ee_gt_spore_pos"));
		var_38c08794 = var_74df34f7;
		var_828d501f = var_74df34f7;
		var_a506772a = var_74df34f7;
		playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_GOOD_LG"], var_74df34f7.origin, AnglesToForward(var_74df34f7.angles));
		self.var_b76ed967 = playFX(localClientNum, level._effect["SPORE_CLOUD_GOOD_LG"], var_a506772a.origin, AnglesToForward(var_a506772a.angles));
	}
	else if(isdefined(self.var_b76ed967))
	{
		stopfx(localClientNum, self.var_b76ed967);
		self.var_b76ed967 = undefined;
	}
}

/*
	Name: function_f68bb4e3
	Namespace: namespace_f777c489
	Checksum: 0xB0BECB6B
	Offset: 0x758
	Size: 0xED
	Parameters: 7
	Flags: None
*/
function function_f68bb4e3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal > 0)
	{
		if(isdefined(self.var_3ecc4b30))
		{
			stopfx(localClientNum, self.var_3ecc4b30);
			self.var_3ecc4b30 = undefined;
		}
		self.var_3ecc4b30 = PlayFXOnTag(localClientNum, level._effect["SPORE_TRAIL_GOOD"], self, "j_spine4");
	}
	else if(isdefined(self.var_3ecc4b30))
	{
		stopfx(localClientNum, self.var_3ecc4b30);
		self.var_3ecc4b30 = undefined;
	}
}

/*
	Name: function_9993f1d3
	Namespace: namespace_f777c489
	Checksum: 0x960BC75
	Offset: 0x850
	Size: 0x289
	Parameters: 7
	Flags: None
*/
function function_9993f1d3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(isdefined(self.var_ba9281dc))
		{
			foreach(fx_id in self.var_ba9281dc)
			{
				stopfx(localClientNum, fx_id);
			}
		}
		self.var_ba9281dc = [];
		self.var_ba9281dc["eyes"] = PlayFXOnTag(localClientNum, level._effect["SIDE_EE_GT_EYES"], self, "j_eyeball_le");
		self.var_ba9281dc["spine"] = PlayFXOnTag(localClientNum, level._effect["SIDE_EE_GT_SPINE"], self, "j_spinelower");
		self.var_ba9281dc["leg_l"] = PlayFXOnTag(localClientNum, level._effect["SIDE_EE_GT_LEG_L"], self, "j_hip_le");
		self.var_ba9281dc["leg_r"] = PlayFXOnTag(localClientNum, level._effect["SIDE_EE_GT_LEG_R"], self, "j_hip_rt");
	}
	else if(isdefined(self.var_ba9281dc))
	{
		foreach(fx_id in self.var_ba9281dc)
		{
			stopfx(localClientNum, fx_id);
		}
		self.var_ba9281dc = undefined;
	}
}

