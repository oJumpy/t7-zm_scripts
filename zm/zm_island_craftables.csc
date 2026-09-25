#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace namespace_e73c08bc;

/*
	Name: init_craftables
	Namespace: namespace_e73c08bc
	Checksum: 0x5B982EEF
	Offset: 0x178
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("gasmask");
	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
}

/*
	Name: include_craftables
	Namespace: namespace_e73c08bc
	Checksum: 0x1A9AFC8A
	Offset: 0x1C8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function include_craftables()
{
	zm_craftables::include_zombie_craftable("gasmask");
}

/*
	Name: register_clientfields
	Namespace: namespace_e73c08bc
	Checksum: 0x7829BFEA
	Offset: 0x1F0
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	var_a0199abd = 1;
	RegisterClientField("world", "gasmask" + "_" + "part_visor", 9000, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gasmask" + "_" + "part_filter", 9000, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gasmask" + "_" + "part_strap", 9000, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_PART_PICKUP", 9000, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_CRAFTED", 9000, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
}

