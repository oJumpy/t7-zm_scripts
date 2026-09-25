#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_105bda17;

/*
	Name: __init__sytem__
	Namespace: namespace_105bda17
	Checksum: 0x4C8117F5
	Offset: 0x158
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_fear_in_headlights", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_105bda17
	Checksum: 0x73A1C36B
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
	bgb::register("zm_bgb_fear_in_headlights", "activated");
}

