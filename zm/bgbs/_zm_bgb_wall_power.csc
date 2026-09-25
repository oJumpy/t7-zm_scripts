#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_df65c2a7;

/*
	Name: __init__sytem__
	Namespace: namespace_df65c2a7
	Checksum: 0xB25C4F12
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_wall_power", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_df65c2a7
	Checksum: 0xDF687423
	Offset: 0x180
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
	bgb::register("zm_bgb_wall_power", "event");
}

