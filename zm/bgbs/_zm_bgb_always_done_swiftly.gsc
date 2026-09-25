#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_d7f1b6c4;

/*
	Name: __init__sytem__
	Namespace: namespace_d7f1b6c4
	Checksum: 0x1D5DB552
	Offset: 0x198
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_always_done_swiftly", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_d7f1b6c4
	Checksum: 0x79606D3
	Offset: 0x1D8
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
	bgb::register("zm_bgb_always_done_swiftly", "rounds", 3, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_d7f1b6c4
	Checksum: 0x83975A95
	Offset: 0x240
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function enable()
{
	self setPerk("specialty_fastads");
	self setPerk("specialty_stalker");
}

/*
	Name: disable
	Namespace: namespace_d7f1b6c4
	Checksum: 0x41F6037E
	Offset: 0x290
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function disable()
{
	self unsetPerk("specialty_fastads");
	self unsetPerk("specialty_stalker");
}

