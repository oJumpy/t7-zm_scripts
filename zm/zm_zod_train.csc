#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace namespace_835aa2f1;

/*
	Name: __init__sytem__
	Namespace: namespace_835aa2f1
	Checksum: 0xBF8AA55D
	Offset: 0x4A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_train", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_835aa2f1
	Checksum: 0xA426B2D4
	Offset: 0x4E8
	Size: 0x2EB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level._additional_wallbuy_weapons))
	{
		level._additional_wallbuy_weapons = [];
	}
	var_d7d92d53 = GetWeapon("smg_sten");
	if(!isdefined(level._additional_wallbuy_weapons))
	{
		level._additional_wallbuy_weapons = [];
	}
	else if(!IsArray(level._additional_wallbuy_weapons))
	{
		level._additional_wallbuy_weapons = Array(level._additional_wallbuy_weapons);
	}
	level._additional_wallbuy_weapons[level._additional_wallbuy_weapons.size] = var_d7d92d53;
	level._effect["train_switch_use"] = "light/fx_light_button_green_traincar_zod_zmb";
	level._effect["train_switch_cooldown"] = "light/fx_light_button_yellow_traincar_zod_zmb";
	level._effect["train_switch_offline"] = "light/fx_light_button_red_train_zod_zmb";
	level._effect["callbox_use"] = "light/fx_light_button_green_traincar_zod_zmb";
	level._effect["callbox_cooldown"] = "light/fx_light_button_yellow_traincar_zod_zmb";
	level._effect["callbox_offline"] = "light/fx_light_button_red_train_zod_zmb";
	level._effect["map_light"] = "light/fx_light_button_yellow_traincar_zod_zmb";
	clientfield::register("vehicle", "train_switch_light", 1, 2, "int", &function_18352dd1, 0, 0);
	clientfield::register("scriptmover", "train_callbox_light", 1, 2, "int", &function_a07a4f8a, 0, 0);
	clientfield::register("scriptmover", "train_map_light", 1, 2, "int", &function_103916d7, 0, 0);
	clientfield::register("vehicle", "train_rain_fx_occluder", 1, 1, "int", &function_2aa2bd33, 0, 0);
	clientfield::register("world", "sndTrainVox", 1, 4, "int", &function_9fb5567b, 0, 0);
	level thread function_1093db4e();
}

/*
	Name: function_2aa2bd33
	Namespace: namespace_835aa2f1
	Checksum: 0x6776114F
	Offset: 0x7E0
	Size: 0x15B
	Parameters: 7
	Flags: None
*/
function function_2aa2bd33(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsDemoPlaying() && function_c8c0455e(localClientNum) < 100)
	{
		var_2a6bebf9 = function_c8c0455e(localClientNum);
		return;
	}
	if(newVal)
	{
		if(!isdefined(self.var_d07c1b83))
		{
			self.var_d07c1b83 = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
			self.var_d07c1b83 LinkTo(self);
			self.var_c604c399 = function_6edd51c4(localClientNum, self.var_d07c1b83, "tag_origin", (768 / 2, 184 / 2, 296 / 2));
		}
	}
}

/*
	Name: function_18352dd1
	Namespace: namespace_835aa2f1
	Checksum: 0x44B67039
	Offset: 0x948
	Size: 0x39D
	Parameters: 7
	Flags: None
*/
function function_18352dd1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			if(isdefined(self.var_f5d230df))
			{
				stopfx(localClientNum, self.var_f5d230df);
			}
			if(isdefined(self.var_2e5172f3))
			{
				stopfx(localClientNum, self.var_2e5172f3);
			}
			self.var_f5d230df = PlayFXOnTag(localClientNum, level._effect["train_switch_cooldown"], self, "tag_fx_switch_front");
			self.var_2e5172f3 = PlayFXOnTag(localClientNum, level._effect["train_switch_cooldown"], self, "tag_fx_switch_back");
			var_98df44c1 = self GetTagOrigin("tag_fx_switch_front");
			var_bee1bf2a = self GetTagOrigin("tag_fx_switch_back");
			level thread function_3e0f1f7e("evt_train_switch_hit", var_98df44c1, var_bee1bf2a);
			break;
		}
		case 1:
		{
			if(isdefined(self.var_f5d230df))
			{
				stopfx(localClientNum, self.var_f5d230df);
			}
			if(isdefined(self.var_2e5172f3))
			{
				stopfx(localClientNum, self.var_2e5172f3);
			}
			self.var_f5d230df = PlayFXOnTag(localClientNum, level._effect["train_switch_use"], self, "tag_fx_switch_front");
			self.var_2e5172f3 = PlayFXOnTag(localClientNum, level._effect["train_switch_use"], self, "tag_fx_switch_back");
			var_98df44c1 = self GetTagOrigin("tag_fx_switch_front");
			var_bee1bf2a = self GetTagOrigin("tag_fx_switch_back");
			level thread function_3e0f1f7e("evt_train_switch_ready", var_98df44c1, var_bee1bf2a);
			break;
		}
		case 2:
		{
			if(isdefined(self.var_f5d230df))
			{
				stopfx(localClientNum, self.var_f5d230df);
			}
			if(isdefined(self.var_2e5172f3))
			{
				stopfx(localClientNum, self.var_2e5172f3);
			}
			self.var_f5d230df = PlayFXOnTag(localClientNum, level._effect["train_switch_offline"], self, "tag_fx_switch_front");
			self.var_2e5172f3 = PlayFXOnTag(localClientNum, level._effect["train_switch_offline"], self, "tag_fx_switch_back");
			break;
		}
	}
}

/*
	Name: function_3e0f1f7e
	Namespace: namespace_835aa2f1
	Checksum: 0xE2E60EFB
	Offset: 0xCF0
	Size: 0x63
	Parameters: 3
	Flags: None
*/
function function_3e0f1f7e(alias, origin1, origin2)
{
	playsound(0, alias, origin1);
	wait(0.05);
	playsound(0, alias, origin2);
}

/*
	Name: function_a07a4f8a
	Namespace: namespace_835aa2f1
	Checksum: 0xFC9DC8EF
	Offset: 0xD60
	Size: 0x19D
	Parameters: 7
	Flags: None
*/
function function_a07a4f8a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			if(isdefined(self.FX))
			{
				stopfx(localClientNum, self.FX);
			}
			self.FX = PlayFXOnTag(localClientNum, level._effect["callbox_cooldown"], self, "Tag_fx_light");
			break;
		}
		case 1:
		{
			if(isdefined(self.FX))
			{
				stopfx(localClientNum, self.FX);
			}
			self.FX = PlayFXOnTag(localClientNum, level._effect["callbox_use"], self, "Tag_fx_light");
			break;
		}
		case 2:
		{
			if(isdefined(self.FX))
			{
				stopfx(localClientNum, self.FX);
			}
			self.FX = PlayFXOnTag(localClientNum, level._effect["callbox_offline"], self, "Tag_fx_light");
			break;
		}
	}
}

/*
	Name: function_103916d7
	Namespace: namespace_835aa2f1
	Checksum: 0x6D2BCE3E
	Offset: 0xF08
	Size: 0x1E5
	Parameters: 7
	Flags: None
*/
function function_103916d7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_66058d50) && newVal != 1)
	{
		stopfx(localClientNum, self.var_66058d50);
		self.var_66058d50 = undefined;
	}
	if(isdefined(self.var_de7b8712) && newVal != 2)
	{
		stopfx(localClientNum, self.var_de7b8712);
		self.var_de7b8712 = undefined;
	}
	if(isdefined(self.var_79780b1f) && newVal != 3)
	{
		stopfx(localClientNum, self.var_79780b1f);
		self.var_79780b1f = undefined;
	}
	switch(newVal)
	{
		case 1:
		{
			self.var_66058d50 = PlayFXOnTag(localClientNum, level._effect["map_light"], self, "tag_fx_light_waterfront");
			break;
		}
		case 2:
		{
			self.var_de7b8712 = PlayFXOnTag(localClientNum, level._effect["map_light"], self, "tag_fx_light_footlight");
			break;
		}
		case 3:
		{
			self.var_79780b1f = PlayFXOnTag(localClientNum, level._effect["map_light"], self, "tag_fx_light_canals");
			break;
		}
	}
}

/*
	Name: function_1093db4e
	Namespace: namespace_835aa2f1
	Checksum: 0xDA311D1E
	Offset: 0x10F8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_1093db4e()
{
	level.var_98f27ad = Array("vox_tanc_board_canal_", "vox_tanc_board_slums_", "vox_tanc_board_theater_", "vox_tanc_depart_canal_", "vox_tanc_depart_slums_", "vox_tanc_depart_theater_", "vox_tanc_divert_canal_", "vox_tanc_divert_slums_", "vox_tanc_divert_theater_");
	level.var_71738ea0 = struct::get_array("sndTrainVox", "targetname");
}

/*
	Name: function_9fb5567b
	Namespace: namespace_835aa2f1
	Checksum: 0x4C2504B0
	Offset: 0x1190
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function function_9fb5567b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_71738ea0))
	{
		return;
	}
	if(newVal)
	{
		alias = level.var_98f27ad[newVal - 1];
		foreach(location in level.var_71738ea0)
		{
			num = 1;
			if(location.script_string == "small")
			{
				num = 0;
			}
			playsound(0, alias + num, location.origin);
			wait(0.016);
		}
	}
	level.var_71738ea0 = Array::randomize(level.var_71738ea0);
}

