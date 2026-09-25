#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_1958c5da;

/*
	Name: __init__sytem__
	Namespace: namespace_1958c5da
	Checksum: 0xD8A8FE18
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_impatient", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1958c5da
	Checksum: 0x8447D6E1
	Offset: 0x180
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
	bgb::register("zm_bgb_impatient", "event");
}

