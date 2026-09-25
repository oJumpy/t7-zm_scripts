#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;

#namespace namespace_23c72813;

/*
	Name: function_ad78a144
	Namespace: namespace_23c72813
	Checksum: 0x9D8137B3
	Offset: 0x110
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function function_ad78a144()
{
	clientfield::register("scriptmover", "show_wearable", 12000, 1, "int", &function_1d8d6ac0, 0, 0);
	for(i = 0; i < 4; i++)
	{
		RegisterClientField("world", "player" + i + "wearableItem", 12000, 2, "int", &zm_utility::setSharedInventoryUIModels, 0);
	}
}

/*
	Name: function_1d8d6ac0
	Namespace: namespace_23c72813
	Checksum: 0x7BAFACF6
	Offset: 0x1D8
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function function_1d8d6ac0(localClientNum, oldVal, newVal)
{
	if(newVal)
	{
		self show();
	}
	else
	{
		self Hide();
	}
}

