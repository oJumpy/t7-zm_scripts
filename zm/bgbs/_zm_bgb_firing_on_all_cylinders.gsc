#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_ef480314;

/*
	Name: __init__sytem__
	Namespace: namespace_ef480314
	Checksum: 0xDB373B32
	Offset: 0x190
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_firing_on_all_cylinders", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_ef480314
	Checksum: 0xC1659A96
	Offset: 0x1D0
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
	bgb::register("zm_bgb_firing_on_all_cylinders", "rounds", 3, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_ef480314
	Checksum: 0x88718F4C
	Offset: 0x238
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function enable()
{
	self setPerk("specialty_sprintfire");
}

/*
	Name: disable
	Namespace: namespace_ef480314
	Checksum: 0xDD5C5348
	Offset: 0x268
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function disable()
{
	self unsetPerk("specialty_sprintfire");
}

