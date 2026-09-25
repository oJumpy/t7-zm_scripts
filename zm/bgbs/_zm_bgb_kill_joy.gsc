#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_969fb372;

/*
	Name: __init__sytem__
	Namespace: namespace_969fb372
	Checksum: 0x62786FB1
	Offset: 0x170
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_kill_joy", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_969fb372
	Checksum: 0x608CB52F
	Offset: 0x1B0
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
	bgb::register("zm_bgb_kill_joy", "activated", 2, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: namespace_969fb372
	Checksum: 0x910484
	Offset: 0x210
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function activation()
{
	self thread bgb::function_dea74fb0("insta_kill");
}

