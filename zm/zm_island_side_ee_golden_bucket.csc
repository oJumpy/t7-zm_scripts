#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace namespace_79fcd4bc;

/*
	Name: init
	Namespace: namespace_79fcd4bc
	Checksum: 0x1DFD866E
	Offset: 0x1C8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "reveal_golden_bucket_planting_location", 9000, 1, "int", &function_86f0587, 0, 0);
	clientfield::register("scriptmover", "golden_bucket_glow_fx", 9000, 1, "int", &function_7e9820e6, 0, 0);
}

/*
	Name: function_86f0587
	Namespace: namespace_79fcd4bc
	Checksum: 0xACD85009
	Offset: 0x268
	Size: 0x101
	Parameters: 7
	Flags: None
*/
function function_86f0587(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		var_6f80c1d8 = GetEntArray(localClientNum, "swamp_planter_skull_reveal", "targetname");
		foreach(var_31678178 in var_6f80c1d8)
		{
			var_31678178 MoveZ(-45, 2);
		}
	}
}

/*
	Name: function_7e9820e6
	Namespace: namespace_79fcd4bc
	Checksum: 0xF6678922
	Offset: 0x378
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function function_7e9820e6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_f8cafdc6[localClientNum] = playFX(localClientNum, level._effect["plant_hit_with_ww"], self.origin);
	}
	else if(isdefined(self.var_f8cafdc6[localClientNum]))
	{
		deletefx(localClientNum, self.var_f8cafdc6[localClientNum]);
	}
}

