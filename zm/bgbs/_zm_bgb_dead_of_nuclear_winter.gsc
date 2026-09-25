#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_a3222192;

/*
	Name: __init__sytem__
	Namespace: namespace_a3222192
	Checksum: 0x35513D12
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_dead_of_nuclear_winter", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_a3222192
	Checksum: 0xD5858DD5
	Offset: 0x1A8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_dead_of_nuclear_winter", "activated", 2, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: namespace_a3222192
	Checksum: 0x40B5C35E
	Offset: 0x208
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function activation()
{
	self thread bgb::function_dea74fb0("nuke");
}

