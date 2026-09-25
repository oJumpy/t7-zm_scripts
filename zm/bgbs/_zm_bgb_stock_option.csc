#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_5525011f;

/*
	Name: __init__sytem__
	Namespace: namespace_5525011f
	Checksum: 0xD7FBB720
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_stock_option", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_5525011f
	Checksum: 0xCB4E9D3D
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
	bgb::register("zm_bgb_stock_option", "time");
}

