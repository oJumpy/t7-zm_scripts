#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_1958c5da;

/*
	Name: __init__sytem__
	Namespace: namespace_1958c5da
	Checksum: 0x89F94FB2
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_impatient", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_1958c5da
	Checksum: 0xF31290CF
	Offset: 0x1F0
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
	bgb::register("zm_bgb_impatient", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: namespace_1958c5da
	Checksum: 0x47ED6A2E
	Offset: 0x250
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self waittill("hash_eecacfa5");
	self thread function_50f23dee();
}

/*
	Name: function_50f23dee
	Namespace: namespace_1958c5da
	Checksum: 0xE0C33368
	Offset: 0x298
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_50f23dee()
{
	self endon("disconnect");
	wait(1);
	while(level.zombie_total > 0)
	{
		wait(0.05);
	}
	self zm::spectator_respawn_player();
	self bgb::do_one_shot_use();
}

