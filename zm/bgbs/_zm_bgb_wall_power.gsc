#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_df65c2a7;

/*
	Name: __init__sytem__
	Namespace: namespace_df65c2a7
	Checksum: 0xCB3DE2E1
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_wall_power", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_df65c2a7
	Checksum: 0x740B41F8
	Offset: 0x1C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_wall_power", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: namespace_df65c2a7
	Checksum: 0x2DB4A56C
	Offset: 0x228
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self waittill("zm_bgb_wall_power_used");
	self playsoundtoplayer("zmb_bgb_wall_power", self);
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_WALL_POWER");
	self bgb::do_one_shot_use();
}

