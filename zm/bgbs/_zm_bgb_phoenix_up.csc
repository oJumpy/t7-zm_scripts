#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_7ffac71e;

/*
	Name: __init__sytem__
	Namespace: namespace_7ffac71e
	Checksum: 0xB57E802A
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_phoenix_up", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_7ffac71e
	Checksum: 0xB0CFD6E3
	Offset: 0x188
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_phoenix_up", "activated");
}

