#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_4e2ad0b7;

/*
	Name: __init__sytem__
	Namespace: namespace_4e2ad0b7
	Checksum: 0x5417E983
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_coagulant", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_4e2ad0b7
	Checksum: 0x96699459
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
	bgb::register("zm_bgb_coagulant", "time");
}

