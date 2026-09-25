#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace ability_gadgets;

/*
	Name: __init__sytem__
	Namespace: ability_gadgets
	Checksum: 0xF15A4BA4
	Offset: 0x178
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_gadgets", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_gadgets
	Checksum: 0x99EC1590
	Offset: 0x1B8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

