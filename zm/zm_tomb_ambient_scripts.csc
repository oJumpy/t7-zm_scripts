#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_ambient_scripts;

/*
	Name: main
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0xCAB87353
	Offset: 0x150
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("scriptmover", "zeppelin_fx", 21000, 1, "int", &function_3f9c04ed, 0, 0);
}

/*
	Name: function_3f9c04ed
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0xC1BC4B49
	Offset: 0x1A8
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_3f9c04ed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self.var_1f4bb75 = PlayFXOnTag(localClientNum, level._effect["zeppelin_lights"], self, "tag_body");
	}
	else if(isdefined(self.var_1f4bb75))
	{
		stopfx(localClientNum, self.var_1f4bb75);
	}
}

