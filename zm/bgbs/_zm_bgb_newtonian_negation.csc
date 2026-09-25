#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_5bdced82;

/*
	Name: __init__sytem__
	Namespace: namespace_5bdced82
	Checksum: 0x224BC0CB
	Offset: 0x150
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_newtonian_negation", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_5bdced82
	Checksum: 0x3F8CBAA9
	Offset: 0x190
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
	bgb::register("zm_bgb_newtonian_negation", "time");
}

