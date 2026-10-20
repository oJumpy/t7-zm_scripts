#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_weap_shrink_ray;

/*
	Name: __init__sytem__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x83664836
	Offset: 0x1B0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_shrink_ray", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x2ACDBB0B
	Offset: 0x1F8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "fun_size", 5000, 1, "int", &fun_size, 0, 0);
}

/*
	Name: __main__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x99EC1590
	Offset: 0x250
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: fun_size
	Namespace: zm_weap_shrink_ray
	Checksum: 0x37DC10BE
	Offset: 0x260
	Size: 0x5F
	Parameters: 7
	Flags: None
*/
function fun_size(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self suppressragdollselfcollision(newVal);
	self.shrunken = newVal;
}

