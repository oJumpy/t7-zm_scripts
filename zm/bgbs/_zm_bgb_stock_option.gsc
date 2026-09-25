#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_5525011f;

/*
	Name: __init__sytem__
	Namespace: namespace_5525011f
	Checksum: 0x69AA66A0
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_stock_option", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_5525011f
	Checksum: 0x60E3F36F
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
	bgb::register("zm_bgb_stock_option", "time", 180, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_5525011f
	Checksum: 0xC39DE15C
	Offset: 0x230
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function enable()
{
	self setPerk("specialty_ammodrainsfromstockfirst");
}

/*
	Name: disable
	Namespace: namespace_5525011f
	Checksum: 0x65F98B63
	Offset: 0x260
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function disable()
{
	self unsetPerk("specialty_ammodrainsfromstockfirst");
}

