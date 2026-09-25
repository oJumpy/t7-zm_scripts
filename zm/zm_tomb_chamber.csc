#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_utility;

#namespace namespace_a528e918;

/*
	Name: __init__sytem__
	Namespace: namespace_a528e918
	Checksum: 0x316AF679
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_tomb_chamber", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_a528e918
	Checksum: 0xE27B5683
	Offset: 0x180
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "divider_fx", 21000, 1, "counter", &function_fa586bee, 0, 0);
}

/*
	Name: function_fa586bee
	Namespace: namespace_a528e918
	Checksum: 0x68ECC20C
	Offset: 0x1D8
	Size: 0xA5
	Parameters: 7
	Flags: None
*/
function function_fa586bee(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		for(i = 1; i <= 9; i++)
		{
			PlayFXOnTag(localClientNum, level._effect["crypt_wall_drop"], self, "tag_fx_dust_0" + i);
		}
	}
}

