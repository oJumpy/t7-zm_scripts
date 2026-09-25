#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;

#namespace namespace_c8222934;

/*
	Name: init
	Namespace: namespace_c8222934
	Checksum: 0x93A98CDE
	Offset: 0x408
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "perk_light_speed_cola", 1, 3, "int", &function_c574aa0c, 0, 0);
	clientfield::register("world", "perk_light_doubletap", 1, 3, "int", &function_59525d83, 0, 0);
	clientfield::register("world", "perk_light_quick_revive", 1, 3, "int", &function_e63629a0, 0, 0);
	clientfield::register("world", "perk_light_staminup", 1, 3, "int", &function_b169f826, 0, 0);
	clientfield::register("world", "perk_light_juggernog", 1, 3, "int", &function_3cfbcaf5, 0, 0);
	clientfield::register("world", "perk_light_mule_kick", 1, 1, "int", &function_eb0b323d, 0, 0);
}

/*
	Name: function_c574aa0c
	Namespace: namespace_c8222934
	Checksum: 0xC551649F
	Offset: 0x5C8
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_c574aa0c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_7202315c = "lgt_sleight_" + newVal;
		exploder::exploder(level.var_7202315c);
	}
	else if(isdefined(level.var_7202315c))
	{
		exploder::stop_exploder(level.var_7202315c);
	}
}

/*
	Name: function_59525d83
	Namespace: namespace_c8222934
	Checksum: 0xA140F3A3
	Offset: 0x670
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_59525d83(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_c09154cb = "lgt_doubletap_" + newVal;
		exploder::exploder(level.var_c09154cb);
	}
	else if(isdefined(level.var_c09154cb))
	{
		exploder::stop_exploder(level.var_c09154cb);
	}
}

/*
	Name: function_e63629a0
	Namespace: namespace_c8222934
	Checksum: 0xD38C1140
	Offset: 0x718
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_e63629a0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_2ff875ec = "lgt_revive_" + newVal;
		exploder::exploder(level.var_2ff875ec);
	}
	else if(isdefined(level.var_2ff875ec))
	{
		exploder::stop_exploder(level.var_2ff875ec);
	}
}

/*
	Name: function_b169f826
	Namespace: namespace_c8222934
	Checksum: 0xBAAF4844
	Offset: 0x7C0
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_b169f826(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_d3ce4f8e = "lgt_staminup_" + newVal;
		exploder::exploder(level.var_d3ce4f8e);
	}
	else if(isdefined(level.var_d3ce4f8e))
	{
		exploder::stop_exploder(level.var_d3ce4f8e);
	}
}

/*
	Name: function_3cfbcaf5
	Namespace: namespace_c8222934
	Checksum: 0x92CE3ED7
	Offset: 0x868
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_3cfbcaf5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_7202315c = "lgt_jugg_" + newVal;
		exploder::exploder(level.var_7202315c);
	}
	else if(isdefined(level.var_7202315c))
	{
		exploder::stop_exploder(level.var_7202315c);
	}
}

/*
	Name: function_eb0b323d
	Namespace: namespace_c8222934
	Checksum: 0xEB8F6421
	Offset: 0x910
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_eb0b323d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_island_vending_mulekick_on");
	}
	else
	{
		exploder::stop_exploder("lgt_island_vending_mulekick_on");
	}
}

