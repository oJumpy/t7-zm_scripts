#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace ability_power;

/*
	Name: __init__sytem__
	Namespace: ability_power
	Checksum: 0x9BF5BC2B
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_power", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_power
	Checksum: 0x99EC1590
	Offset: 0x188
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

