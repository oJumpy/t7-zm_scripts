#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_powerup_shield_charge;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_craft_shield;

/*
	Name: __init__sytem__
	Namespace: zm_craft_shield
	Checksum: 0xFA82BB45
	Offset: 0x240
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_craft_shield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_craft_shield
	Checksum: 0x50B1A1E5
	Offset: 0x280
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_craftables::include_zombie_craftable("craft_shield_zm");
	zm_craftables::add_zombie_craftable("craft_shield_zm");
	RegisterClientField("world", "piece_riotshield_dolly", 1, 1, "int", &zm_utility::setSharedInventoryUIModels, 0);
	RegisterClientField("world", "piece_riotshield_door", 1, 1, "int", &zm_utility::setSharedInventoryUIModels, 0);
	RegisterClientField("world", "piece_riotshield_clamp", 1, 1, "int", &zm_utility::setSharedInventoryUIModels, 0);
	clientfield::register("toplayer", "ZMUI_SHIELD_PART_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZMUI_SHIELD_CRAFTED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
}

