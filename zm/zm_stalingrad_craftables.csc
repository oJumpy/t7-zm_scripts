#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace namespace_f058d6e4;

/*
	Name: init_craftables
	Namespace: namespace_f058d6e4
	Checksum: 0x425546E5
	Offset: 0x1B0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("dragonride");
	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
}

/*
	Name: include_craftables
	Namespace: namespace_f058d6e4
	Checksum: 0x701CDC63
	Offset: 0x200
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function include_craftables()
{
	zm_craftables::include_zombie_craftable("dragonride");
}

/*
	Name: register_clientfields
	Namespace: namespace_f058d6e4
	Checksum: 0xDD67189D
	Offset: 0x228
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	var_a0199abd = 1;
	RegisterClientField("world", "dragonride" + "_" + "part_transmitter", 12000, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0);
	RegisterClientField("world", "dragonride" + "_" + "part_codes", 12000, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0);
	RegisterClientField("world", "dragonride" + "_" + "part_map", 12000, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0);
	clientfield::register("toplayer", "ZMUI_DRAGONRIDE_PART_PICKUP", 12000, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZMUI_DRAGONRIDE_CRAFTED", 12000, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("clientuimodel", "zmInventory.widget_dragonride_parts", 12000, 1, "int", undefined, 0, 0);
}

