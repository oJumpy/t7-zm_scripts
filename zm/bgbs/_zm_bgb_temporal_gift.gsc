#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_906c7034;

/*
	Name: __init__sytem__
	Namespace: namespace_906c7034
	Checksum: 0xEC834B91
	Offset: 0x150
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_temporal_gift", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_906c7034
	Checksum: 0xB7C1473F
	Offset: 0x190
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_temporal_gift", "rounds", 1, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_906c7034
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function enable()
{
}

/*
	Name: disable
	Namespace: namespace_906c7034
	Checksum: 0x99EC1590
	Offset: 0x208
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

