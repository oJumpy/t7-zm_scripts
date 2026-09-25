#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_b0f00253;

/*
	Name: __init__sytem__
	Namespace: namespace_b0f00253
	Checksum: 0xFC3A56C3
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_on_the_house", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_b0f00253
	Checksum: 0x945B7103
	Offset: 0x188
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
	bgb::register("zm_bgb_on_the_house", "activated");
}

