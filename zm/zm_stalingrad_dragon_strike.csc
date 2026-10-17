#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace stalingrad_dragon_strike;

/*
	Name: __init__sytem__
	Namespace: stalingrad_dragon_strike
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
	Namespace: stalingrad_dragon_strike
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
	Namespace: stalingrad_dragon_strike
	Checksum: 0x3CA1EDA7
	Offset: 0x3A0
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_5f0e6212(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx_light_1))
	{
		stopfx(localClientNum, self.fx_light_1);
	}
	if(newVal == 2)
	{
		self.fx_light_1 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "0");
	}
	else
	{
		self.fx_light_1 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "0");
	}
}

/*
	Name: function_390be7a9
	Namespace: stalingrad_dragon_strike
	Checksum: 0x5C8654A
	Offset: 0x498
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_390be7a9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx_light_2))
	{
		stopfx(localClientNum, self.fx_light_2);
	}
	if(newVal == 2)
	{
		self.fx_light_2 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "1");
	}
	else
	{
		self.fx_light_2 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "1");
	}
}

/*
	Name: function_13096d40
	Namespace: stalingrad_dragon_strike
	Checksum: 0x582AAE33
	Offset: 0x590
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_13096d40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx_light_3))
	{
		stopfx(localClientNum, self.fx_light_3);
	}
	if(newVal == 2)
	{
		self.fx_light_3 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "2");
	}
	else
	{
		self.fx_light_3 = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "2");
	}
}

/*
	Name: function_1d1ac61f
	Namespace: stalingrad_dragon_strike
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

