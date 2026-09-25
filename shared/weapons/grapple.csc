#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace grapple;

/*
	Name: __init__sytem__
	Namespace: grapple
	Checksum: 0xD9B8185F
	Offset: 0x190
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("grapple", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: grapple
	Checksum: 0x99EC1590
	Offset: 0x1D0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

