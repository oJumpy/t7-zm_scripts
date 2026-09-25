#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_security_breach;

/*
	Name: __init__sytem__
	Namespace: _gadget_security_breach
	Checksum: 0xFB747C75
	Offset: 0x1F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_security_breach", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_security_breach
	Checksum: 0x99EC1590
	Offset: 0x238
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

