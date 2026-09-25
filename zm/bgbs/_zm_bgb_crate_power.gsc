#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_4385caec;

/*
	Name: __init__sytem__
	Namespace: namespace_4385caec
	Checksum: 0xCB70FB5B
	Offset: 0x178
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_crate_power", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_4385caec
	Checksum: 0xDB6C86F1
	Offset: 0x1B8
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
	bgb::register("zm_bgb_crate_power", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: namespace_4385caec
	Checksum: 0x1345AC68
	Offset: 0x218
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self waittill("zm_bgb_crate_power_used");
	self playsoundtoplayer("zmb_bgb_crate_power", self);
	self bgb::do_one_shot_use();
}

