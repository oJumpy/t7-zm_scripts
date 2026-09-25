#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_6cf54cb6;

/*
	Name: __init__sytem__
	Namespace: namespace_6cf54cb6
	Checksum: 0xA3AEBFB3
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_power_vacuum", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_6cf54cb6
	Checksum: 0x3550DE5F
	Offset: 0x1A8
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
	bgb::register("zm_bgb_power_vacuum", "rounds", 4, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_6cf54cb6
	Checksum: 0xF6C1E19D
	Offset: 0x210
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function enable()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	level.powerup_drop_count = 0;
	while(1)
	{
		level waittill("powerup_dropped");
		self bgb::do_one_shot_use();
		level.powerup_drop_count = 0;
	}
}

/*
	Name: disable
	Namespace: namespace_6cf54cb6
	Checksum: 0x99EC1590
	Offset: 0x288
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

