#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_utility;

#namespace namespace_112fb534;

/*
	Name: __init__sytem__
	Namespace: namespace_112fb534
	Checksum: 0xA4D4E6C6
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_pop_shocks", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_112fb534
	Checksum: 0xBE98DA8
	Offset: 0x1A8
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
	bgb::register("zm_bgb_pop_shocks", "event");
}

