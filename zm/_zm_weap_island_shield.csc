#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_b2c57c5e;

/*
	Name: __init__sytem__
	Namespace: namespace_b2c57c5e
	Checksum: 0xF2A669B9
	Offset: 0x150
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_island_shield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_b2c57c5e
	Checksum: 0x99EC1590
	Offset: 0x190
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

