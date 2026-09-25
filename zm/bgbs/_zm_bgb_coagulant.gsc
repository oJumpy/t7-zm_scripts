#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_4e2ad0b7;

/*
	Name: __init__sytem__
	Namespace: namespace_4e2ad0b7
	Checksum: 0xA8C7AF2D
	Offset: 0x1A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_coagulant", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_4e2ad0b7
	Checksum: 0x2DD2054A
	Offset: 0x1E8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_coagulant", "time", 1200, &enable, &disable, undefined, undefined);
}

/*
	Name: enable
	Namespace: namespace_4e2ad0b7
	Checksum: 0x7C9767BA
	Offset: 0x258
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function enable()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	self.n_bleedout_time_multiplier = 3;
	while(1)
	{
		self waittill("player_downed");
		self bgb::do_one_shot_use(1);
	}
}

/*
	Name: disable
	Namespace: namespace_4e2ad0b7
	Checksum: 0x62D30F54
	Offset: 0x2C8
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function disable()
{
	self.n_bleedout_time_multiplier = undefined;
}

