#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_4754119d;

/*
	Name: __init__sytem__
	Namespace: namespace_4754119d
	Checksum: 0xB735FB7A
	Offset: 0x1E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_armamental_accomplishment", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_4754119d
	Checksum: 0x75406CC4
	Offset: 0x228
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
	bgb::register("zm_bgb_armamental_accomplishment", "rounds", 3, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_4754119d
	Checksum: 0x403E80BF
	Offset: 0x290
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function enable()
{
	self setPerk("specialty_fastmeleerecovery");
	self setPerk("specialty_fastweaponswitch");
	self setPerk("specialty_fastequipmentuse");
	self setPerk("specialty_fasttoss");
}

/*
	Name: disable
	Namespace: namespace_4754119d
	Checksum: 0x7BBA458A
	Offset: 0x320
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function disable()
{
	self unsetPerk("specialty_fastmeleerecovery");
	self unsetPerk("specialty_fastweaponswitch");
	self unsetPerk("specialty_fastequipmentuse");
	self unsetPerk("specialty_fasttoss");
}

