#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_767b8a45;

/*
	Name: __init__sytem__
	Namespace: namespace_767b8a45
	Checksum: 0x11785C9E
	Offset: 0x158
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_cache_back", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_767b8a45
	Checksum: 0xDB0EAD9
	Offset: 0x198
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
	bgb::register("zm_bgb_cache_back", "activated", 1, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: namespace_767b8a45
	Checksum: 0x268560C4
	Offset: 0x1F8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function activation()
{
	self thread bgb::function_dea74fb0("full_ammo");
}

