#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_cb5bc243;

/*
	Name: __init__sytem__
	Namespace: namespace_cb5bc243
	Checksum: 0x9F18ED32
	Offset: 0x250
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_castle_tram_token", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_cb5bc243
	Checksum: 0xC95FE51B
	Offset: 0x290
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	register_clientfields();
	zm_powerups::include_zombie_powerup("castle_tram_token");
	zm_powerups::add_zombie_powerup("castle_tram_token");
	level._effect["fuse_pickup_fx"] = "dlc1/castle/fx_glow_115_fuse_pickup_castle";
}

/*
	Name: register_clientfields
	Namespace: namespace_cb5bc243
	Checksum: 0x5B5C23B2
	Offset: 0x2F8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("toplayer", "has_castle_tram_token", 1, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "ZM_CASTLE_TRAM_TOKEN_ACQUIRED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("scriptmover", "powerup_fuse_fx", 1, 1, "int", &function_4f546258, 0, 0);
	for(i = 0; i < 4; i++)
	{
		RegisterClientField("world", "player" + i + "hasItem", 1, 1, "int", &zm_utility::setSharedInventoryUIModels, 0);
	}
	clientfield::register("clientuimodel", "zmInventory.player_using_sprayer", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_sprayer", 1, 1, "int", undefined, 0, 0);
}

/*
	Name: function_4f546258
	Namespace: namespace_cb5bc243
	Checksum: 0xA5BEA765
	Offset: 0x4B0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_4f546258(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_300f73ce = PlayFXOnTag(localClientNum, level._effect["fuse_pickup_fx"], self, "j_fuse_main");
	}
}

