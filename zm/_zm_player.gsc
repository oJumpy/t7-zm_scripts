#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace zm_player;

/*
	Name: __init__sytem__
	Namespace: zm_player
	Checksum: 0xD4F4154D
	Offset: 0xC0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_player
	Checksum: 0x99EC1590
	Offset: 0x100
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

