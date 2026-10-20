#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_arsenal_accelerator;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_arsenal_accelerator
	Checksum: 0x69B661C3
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_arsenal_accelerator", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_arsenal_accelerator
	Checksum: 0x34697311
	Offset: 0x1C8
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
	bgb::register("zm_bgb_arsenal_accelerator", "time", 600, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_arsenal_accelerator
	Checksum: 0xBAFF06
	Offset: 0x230
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function enable()
{
	self setPerk("specialty_overcharge");
}

/*
	Name: disable
	Namespace: zm_bgb_arsenal_accelerator
	Checksum: 0x5E37BE27
	Offset: 0x260
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function disable()
{
	self unsetPerk("specialty_overcharge");
}

