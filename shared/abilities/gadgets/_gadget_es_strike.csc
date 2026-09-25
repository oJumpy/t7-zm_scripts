#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_es_strike;

/*
	Name: __init__sytem__
	Namespace: _gadget_es_strike
	Checksum: 0xBE776149
	Offset: 0x1E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_es_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_es_strike
	Checksum: 0xEB349219
	Offset: 0x228
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: _gadget_es_strike
	Checksum: 0xF087634D
	Offset: 0x258
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function on_player_spawned(local_client_num)
{
}

