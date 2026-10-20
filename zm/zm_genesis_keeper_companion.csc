#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_genesis_keeper_companion;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x30B80A00
	Offset: 0x2A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_keeper_companion", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x99DD98E1
	Offset: 0x2E0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	RegisterClientField("world", "keeper_callbox_head", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "keeper_callbox_totem", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "keeper_callbox_gem", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	clientfield::register("clientuimodel", "zmInventory.widget_keeper_protector_parts", 15000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_keeper_protector", 15000, 1, "int", undefined, 0, 0);
}

