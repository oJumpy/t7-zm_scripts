#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_34c58dc;

/*
	Name: init
	Namespace: namespace_34c58dc
	Checksum: 0x4AED2560
	Offset: 0x170
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("vehicle", "sewer_current_fx", 9000, 1, "int", &function_1647aec4, 0, 0);
}

/*
	Name: function_1647aec4
	Namespace: namespace_34c58dc
	Checksum: 0xD740AD0A
	Offset: 0x1C8
	Size: 0xCB
	Parameters: 7
	Flags: None
*/
function function_1647aec4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.var_7e61ace3))
		{
			self.var_7e61ace3 = [];
		}
		self thread function_a39e4663(localClientNum);
	}
	else
	{
		self notify("hash_ab837d11");
		if(isdefined(self.var_7e61ace3[localClientNum]))
		{
			deletefx(localClientNum, self.var_7e61ace3[localClientNum], 0);
		}
	}
}

/*
	Name: function_a39e4663
	Namespace: namespace_34c58dc
	Checksum: 0xEE601996
	Offset: 0x2A0
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_a39e4663(localClientNum)
{
	self endon("hash_ab837d11");
	while(1)
	{
		self.var_7e61ace3[localClientNum] = PlayFXOnTag(localClientNum, level._effect["current_effect"], self, "tag_origin");
		wait(0.05);
	}
}

