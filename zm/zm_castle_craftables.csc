#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace namespace_dddf9a25;

/*
	Name: init_craftables
	Namespace: namespace_dddf9a25
	Checksum: 0x16F96CC6
	Offset: 0x298
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("gravityspike");
	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
	level._effect["craftable_powerup_on"] = "dlc1/castle/fx_talon_spike_glow_castle";
	level._effect["craftable_powerup_teleport"] = "dlc1/castle/fx_castle_pap_teleport_parts";
}

/*
	Name: include_craftables
	Namespace: namespace_dddf9a25
	Checksum: 0x9D739FD5
	Offset: 0x320
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function include_craftables()
{
	zm_craftables::include_zombie_craftable("gravityspike");
}

/*
	Name: register_clientfields
	Namespace: namespace_dddf9a25
	Checksum: 0xF67E8B33
	Offset: 0x348
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	var_a0199abd = 1;
	RegisterClientField("world", "gravityspike" + "_" + "part_body", 1, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gravityspike" + "_" + "part_guards", 1, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gravityspike" + "_" + "part_handle", 1, var_a0199abd, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	clientfield::register("scriptmover", "craftable_powerup_fx", 1, 1, "int", &function_f1838e49, 0, 0);
	clientfield::register("scriptmover", "craftable_teleport_fx", 1, 1, "int", &function_a43a3438, 0, 0);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_PART_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_CRAFTED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("clientuimodel", "zmInventory.widget_gravityspike_parts", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_gravityspikes", 1, 1, "int", undefined, 0, 0);
}

/*
	Name: function_f1838e49
	Namespace: namespace_dddf9a25
	Checksum: 0x99FDFDAD
	Offset: 0x600
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function function_f1838e49(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_1785a8a8 = PlayFXOnTag(localClientNum, level._effect["craftable_powerup_on"], self, "tag_origin");
	}
	else if(isdefined(self.var_1785a8a8))
	{
		deletefx(localClientNum, self.var_1785a8a8, 1);
		self.var_1785a8a8 = undefined;
	}
}

/*
	Name: function_a43a3438
	Namespace: namespace_dddf9a25
	Checksum: 0x5E317D00
	Offset: 0x6C8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_a43a3438(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFXOnTag(localClientNum, level._effect["craftable_powerup_teleport"], self, "tag_origin");
	}
}

