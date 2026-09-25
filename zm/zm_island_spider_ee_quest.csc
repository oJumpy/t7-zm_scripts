#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace namespace_fdccf5c4;

/*
	Name: init
	Namespace: namespace_fdccf5c4
	Checksum: 0x876D29C5
	Offset: 0x210
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("vehicle", "spider_glow_fx", 9000, 1, "int", &function_b050960b, 0, 0);
	clientfield::register("vehicle", "spider_drinks_fx", 9000, 2, "int", &function_f9f39b8e, 0, 0);
	clientfield::register("scriptmover", "jungle_cage_charged_fx", 9000, 1, "int", &function_23e69e71, 0, 0);
}

/*
	Name: function_b050960b
	Namespace: namespace_fdccf5c4
	Checksum: 0xF14BB4BA
	Offset: 0x2F8
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_b050960b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_6cbaf065 = PlayFXOnTag(localClientNum, level._effect["spider_glow_red"], self, "tag_driver");
	}
	else if(isdefined(self.var_6cbaf065))
	{
		deletefx(localClientNum, self.var_6cbaf065);
	}
}

/*
	Name: function_f9f39b8e
	Namespace: namespace_fdccf5c4
	Checksum: 0x7899C6D
	Offset: 0x3B8
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function function_f9f39b8e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.var_163815ae))
	{
		self.var_163815ae = [];
	}
	if(newVal == 1)
	{
		self.var_163815ae[localClientNum] = PlayFXOnTag(localClientNum, level._effect["spider_drink_lair"], self, "tag_flash");
	}
	else if(newVal == 2)
	{
		self.var_163815ae[localClientNum] = PlayFXOnTag(localClientNum, level._effect["spider_drink_meteor"], self, "tag_flash");
	}
	else if(newVal == 3)
	{
		self.var_163815ae[localClientNum] = PlayFXOnTag(localClientNum, level._effect["spider_drink_bunker"], self, "tag_flash");
	}
	else if(isdefined(self.var_163815ae[localClientNum]))
	{
		deletefx(localClientNum, self.var_163815ae[localClientNum]);
	}
}

/*
	Name: function_23e69e71
	Namespace: namespace_fdccf5c4
	Checksum: 0x2BBA3A50
	Offset: 0x540
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function function_23e69e71(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_da0d0e02[localClientNum] = PlayFXOnTag(localClientNum, level._effect["lightning_shield_control_panel"], self, "tag_origin");
	}
	else if(isdefined(self.var_da0d0e02))
	{
		a_keys = getArrayKeys(self.var_da0d0e02);
		if(IsInArray(a_keys, localClientNum))
		{
			deletefx(localClientNum, self.var_da0d0e02[localClientNum], 0);
		}
	}
}

