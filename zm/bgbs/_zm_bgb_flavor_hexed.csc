#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_3ecfcb30;

/*
	Name: __init__sytem__
	Namespace: namespace_3ecfcb30
	Checksum: 0xD48D2F3E
	Offset: 0x170
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_flavor_hexed", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_3ecfcb30
	Checksum: 0x156DDA0C
	Offset: 0x1B0
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
	bgb::register("zm_bgb_flavor_hexed", "event");
}

