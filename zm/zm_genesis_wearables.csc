#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_wearables;

/*
	Name: function_ad78a144
	Namespace: zm_genesis_wearables
	Checksum: 0xF78E7320
	Offset: 0x160
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_ad78a144()
{
	for(i = 0; i < 4; i++)
	{
		RegisterClientField("world", "player" + i + "wearableItem", 15000, 4, "int", &zm_utility::setSharedInventoryUIModels, 0);
	}
	clientfield::register("clientuimodel", "zmInventory.wearable_perk_icons", 15000, 2, "int", undefined, 0, 0);
	clientfield::register("scriptmover", "battery_fx", 15000, 2, "int", &function_f51349bf, 0, 0);
}

/*
	Name: function_f51349bf
	Namespace: zm_genesis_wearables
	Checksum: 0x58548947
	Offset: 0x260
	Size: 0x19B
	Parameters: 7
	Flags: None
*/
function function_f51349bf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localClientNum, self.n_fx_id, 1);
		}
		self.n_fx_id = playFX(localClientNum, level._effect["battery_uncharged"], self.origin, AnglesToForward(self.angles), (0, 0, 1));
	}
	else if(newVal == 2)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localClientNum, self.n_fx_id, 1);
		}
		self.n_fx_id = playFX(localClientNum, level._effect["battery_charged"], self.origin, AnglesToForward(self.angles), (0, 0, 1));
	}
	else if(isdefined(self.n_fx_id))
	{
		deletefx(localClientNum, self.n_fx_id, 1);
	}
}

