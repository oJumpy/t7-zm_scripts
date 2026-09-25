#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_3b1d9a60;

/*
	Name: __init__sytem__
	Namespace: namespace_3b1d9a60
	Checksum: 0x52C49CBC
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_danger_closest", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_3b1d9a60
	Checksum: 0x717020C3
	Offset: 0x1A8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_danger_closest", "rounds", 3, undefined, undefined, undefined);
}

