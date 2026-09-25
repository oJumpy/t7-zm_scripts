#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace namespace_c9806b9;

/*
	Name: __init__sytem__
	Namespace: namespace_c9806b9
	Checksum: 0xF8A69F56
	Offset: 0x1B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c9806b9
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

