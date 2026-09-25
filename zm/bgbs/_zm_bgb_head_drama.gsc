#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_51278ff7;

/*
	Name: __init__sytem__
	Namespace: namespace_51278ff7
	Checksum: 0x9FE15EBA
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_head_drama", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_51278ff7
	Checksum: 0xB61B5B28
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
	bgb::register("zm_bgb_head_drama", "rounds", 0, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_51278ff7
	Checksum: 0x292EE1E3
	Offset: 0x230
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function enable()
{
	self setPerk("specialty_locdamagecountsasheadshot");
}

/*
	Name: disable
	Namespace: namespace_51278ff7
	Checksum: 0x12CC76E3
	Offset: 0x260
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function disable()
{
	self unsetPerk("specialty_locdamagecountsasheadshot");
}

