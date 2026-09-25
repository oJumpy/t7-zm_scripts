#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace weapons_shared;

/*
	Name: __init__sytem__
	Namespace: weapons_shared
	Checksum: 0xA0C3A048
	Offset: 0xC8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("weapon_shared", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: weapons_shared
	Checksum: 0x99EC1590
	Offset: 0x108
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

