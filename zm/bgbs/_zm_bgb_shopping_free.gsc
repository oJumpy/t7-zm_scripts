#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_18c49b5a;

/*
	Name: __init__sytem__
	Namespace: namespace_18c49b5a
	Checksum: 0xEA3A306B
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_shopping_free", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_18c49b5a
	Checksum: 0x517DDE6
	Offset: 0x188
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_shopping_free", "time", 60, &enable, &disable, undefined, undefined);
}

/*
	Name: enable
	Namespace: namespace_18c49b5a
	Checksum: 0xBF0AC0E8
	Offset: 0x1F8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function enable()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
}

/*
	Name: disable
	Namespace: namespace_18c49b5a
	Checksum: 0x99EC1590
	Offset: 0x228
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

