#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace namespace_912a86f7;

/*
	Name: init
	Namespace: namespace_912a86f7
	Checksum: 0x7EE498BB
	Offset: 0x2D0
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "perk_light_doubletap", 5000, 1, "int", &function_59525d83, 0, 0);
	clientfield::register("world", "perk_light_juggernaut", 5000, 1, "int", &function_865d7d93, 0, 0);
	clientfield::register("world", "perk_light_mule_kick", 1, 1, "int", &function_eb0b323d, 0, 0);
	clientfield::register("world", "perk_light_quick_revive", 5000, 1, "int", &function_e63629a0, 0, 0);
	clientfield::register("world", "perk_light_speed_cola", 5000, 1, "int", &function_c574aa0c, 0, 0);
	clientfield::register("world", "perk_light_staminup", 5000, 1, "int", &function_b169f826, 0, 0);
	clientfield::register("world", "perk_light_widows_wine", 5000, 1, "int", &function_9021b00a, 0, 0);
}

/*
	Name: function_c574aa0c
	Namespace: namespace_912a86f7
	Checksum: 0xD87EE69A
	Offset: 0x4D8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_c574aa0c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_speed_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_speed_on");
	}
}

/*
	Name: function_865d7d93
	Namespace: namespace_912a86f7
	Checksum: 0x4ED0CD38
	Offset: 0x560
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_865d7d93(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_jugg_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_jugg_on");
	}
}

/*
	Name: function_59525d83
	Namespace: namespace_912a86f7
	Checksum: 0x911A6FD0
	Offset: 0x5E8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_59525d83(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_tap_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_tap_on");
	}
}

/*
	Name: function_e63629a0
	Namespace: namespace_912a86f7
	Checksum: 0xC6AB7D18
	Offset: 0x670
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_e63629a0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("quick_revive_lgts");
	}
	else
	{
		exploder::stop_exploder("quick_revive_lgts");
	}
}

/*
	Name: function_9021b00a
	Namespace: namespace_912a86f7
	Checksum: 0x38823405
	Offset: 0x6F8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_9021b00a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_widows_wine_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_widows_wine_on");
	}
}

/*
	Name: function_eb0b323d
	Namespace: namespace_912a86f7
	Checksum: 0xC4776434
	Offset: 0x780
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_eb0b323d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_mulekick_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_mulekick_on");
	}
}

/*
	Name: function_b169f826
	Namespace: namespace_912a86f7
	Checksum: 0x9DC63521
	Offset: 0x808
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_b169f826(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_ stamina_up");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_ stamina_up");
	}
}

