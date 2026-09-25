#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_19e79ea1;

/*
	Name: __init__sytem__
	Namespace: namespace_19e79ea1
	Checksum: 0xC244C572
	Offset: 0x230
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_dragon_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_19e79ea1
	Checksum: 0x58C0319B
	Offset: 0x270
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "lockbox_light_1", 12000, 2, "int", &function_5f0e6212, 0, 0);
	clientfield::register("scriptmover", "lockbox_light_2", 12000, 2, "int", &function_390be7a9, 0, 0);
	clientfield::register("scriptmover", "lockbox_light_3", 12000, 2, "int", &function_13096d40, 0, 0);
	clientfield::register("scriptmover", "lockbox_light_4", 12000, 2, "int", &function_1d1ac61f, 0, 0);
}

/*
	Name: function_5f0e6212
	Namespace: namespace_19e79ea1
	Checksum: 0x3CA1EDA7
	Offset: 0x3A0
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_5f0e6212(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_fbe6c07a))
	{
		stopfx(localClientNum, self.var_fbe6c07a);
	}
	if(newVal == 2)
	{
		self.var_fbe6c07a = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "0");
	}
	else
	{
		self.var_fbe6c07a = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "0");
	}
}

/*
	Name: function_390be7a9
	Namespace: namespace_19e79ea1
	Checksum: 0x5C8654A
	Offset: 0x498
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_390be7a9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_d5e44611))
	{
		stopfx(localClientNum, self.var_d5e44611);
	}
	if(newVal == 2)
	{
		self.var_d5e44611 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "1");
	}
	else
	{
		self.var_d5e44611 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "1");
	}
}

/*
	Name: function_13096d40
	Namespace: namespace_19e79ea1
	Checksum: 0x582AAE33
	Offset: 0x590
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_13096d40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_afe1cba8))
	{
		stopfx(localClientNum, self.var_afe1cba8);
	}
	if(newVal == 2)
	{
		self.var_afe1cba8 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "2");
	}
	else
	{
		self.var_afe1cba8 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "2");
	}
}

/*
	Name: function_1d1ac61f
	Namespace: namespace_19e79ea1
	Checksum: 0x1B5C4922
	Offset: 0x688
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_1d1ac61f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_b9f32487))
	{
		stopfx(localClientNum, self.var_b9f32487);
	}
	if(newVal == 2)
	{
		self.var_b9f32487 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "3");
	}
	else
	{
		self.var_b9f32487 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "3");
	}
}

