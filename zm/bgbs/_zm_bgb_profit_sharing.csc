#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_19b2be8a;

/*
	Name: __init__sytem__
	Namespace: namespace_19b2be8a
	Checksum: 0x7FA579B3
	Offset: 0x1F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_profit_sharing", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_19b2be8a
	Checksum: 0x8CF3600F
	Offset: 0x238
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("allplayers", "zm_bgb_profit_sharing_3p_fx", 15000, 1, "int", &function_df72a623, 0, 0);
	clientfield::register("toplayer", "zm_bgb_profit_sharing_1p_fx", 15000, 1, "int", &function_f683a0e1, 0, 1);
	bgb::register("zm_bgb_profit_sharing", "time");
	level.var_75dff42 = [];
}

/*
	Name: function_df72a623
	Namespace: namespace_19b2be8a
	Checksum: 0x8A6BB27D
	Offset: 0x318
	Size: 0x127
	Parameters: 7
	Flags: None
*/
function function_df72a623(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_b84b5692 = GetLocalPlayer(localClientNum);
	if(newVal)
	{
		if(var_b84b5692 != self)
		{
			if(!isdefined(self.var_3485cf73))
			{
				self.var_3485cf73 = [];
			}
			if(isdefined(self.var_3485cf73[localClientNum]))
			{
				return;
			}
			self.var_3485cf73[localClientNum] = PlayFXOnTag(localClientNum, "zombie/fx_bgb_profit_3p", self, "j_spine4");
		}
	}
	else if(isdefined(self.var_3485cf73) && isdefined(self.var_3485cf73[localClientNum]))
	{
		stopfx(localClientNum, self.var_3485cf73[localClientNum]);
		self.var_3485cf73[localClientNum] = undefined;
	}
}

/*
	Name: function_f683a0e1
	Namespace: namespace_19b2be8a
	Checksum: 0x6B98415E
	Offset: 0x448
	Size: 0xF7
	Parameters: 7
	Flags: None
*/
function function_f683a0e1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(level.var_75dff42[localClientNum]))
		{
			deletefx(localClientNum, level.var_75dff42[localClientNum]);
		}
		level.var_75dff42[localClientNum] = PlayFXOnCamera(localClientNum, "zombie/fx_bgb_profit_1p", (0, 0, 0), (1, 0, 0));
	}
	else if(isdefined(level.var_75dff42[localClientNum]))
	{
		stopfx(localClientNum, level.var_75dff42[localClientNum]);
		level.var_75dff42[localClientNum] = undefined;
	}
}

