#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_fb5c506f;

/*
	Name: __init__sytem__
	Namespace: namespace_fb5c506f
	Checksum: 0x47AD38B0
	Offset: 0x158
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_fatal_contraption", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_fb5c506f
	Checksum: 0x97DF8F34
	Offset: 0x198
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
	bgb::register("zm_bgb_fatal_contraption", "activated");
}

