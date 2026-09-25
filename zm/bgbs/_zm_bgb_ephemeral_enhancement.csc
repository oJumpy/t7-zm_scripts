#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_6d4de49;

/*
	Name: __init__sytem__
	Namespace: namespace_6d4de49
	Checksum: 0x376D5FB0
	Offset: 0x160
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_ephemeral_enhancement", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6d4de49
	Checksum: 0xC1E33432
	Offset: 0x1A0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_ephemeral_enhancement", "activated");
}

