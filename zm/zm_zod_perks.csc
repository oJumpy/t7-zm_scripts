#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace namespace_bb738c6;

/*
	Name: init
	Namespace: namespace_bb738c6
	Checksum: 0x64727547
	Offset: 0x3C0
	Size: 0x323
	Parameters: 0
	Flags: None
*/
function init()
{
	level._effect["bottle_jugg"] = "zombie/fx_bottle_break_glow_jugg_zmb";
	level._effect["bottle_dtap"] = "zombie/fx_bottle_break_glow_dtap_zmb";
	level._effect["bottle_speed"] = "zombie/fx_bottle_break_glow_speed_zmb";
	clientfield::register("world", "perk_light_speed_cola", 1, 2, "int", &function_c574aa0c, 0, 0);
	clientfield::register("world", "perk_light_juggernog", 1, 2, "int", &function_3cfbcaf5, 0, 0);
	clientfield::register("world", "perk_light_doubletap", 1, 2, "int", &function_59525d83, 0, 0);
	clientfield::register("world", "perk_light_quick_revive", 1, 1, "int", &function_e63629a0, 0, 0);
	clientfield::register("world", "perk_light_widows_wine", 1, 1, "int", &function_9021b00a, 0, 0);
	clientfield::register("world", "perk_light_mule_kick", 1, 1, "int", &function_eb0b323d, 0, 0);
	clientfield::register("world", "perk_light_staminup", 1, 1, "int", &function_b169f826, 0, 0);
	clientfield::register("scriptmover", "perk_bottle_speed_cola_fx", 1, 1, "int", &function_96fbf181, 0, 0);
	clientfield::register("scriptmover", "perk_bottle_juggernog_fx", 1, 1, "int", &function_fdc76a3e, 0, 0);
	clientfield::register("scriptmover", "perk_bottle_doubletap_fx", 1, 1, "int", &function_5192f840, 0, 0);
}

/*
	Name: function_c574aa0c
	Namespace: namespace_bb738c6
	Checksum: 0x79E3829F
	Offset: 0x6F0
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_c574aa0c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_320cd7b4 = "lgt_vending_speed_" + newVal + "_on";
		exploder::exploder(level.var_320cd7b4);
	}
	else if(isdefined(level.var_320cd7b4))
	{
		exploder::stop_exploder(level.var_320cd7b4);
	}
}

/*
	Name: function_3cfbcaf5
	Namespace: namespace_bb738c6
	Checksum: 0x7965421D
	Offset: 0x7A0
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_3cfbcaf5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_d1316ad = "lgt_vending_jugg_" + newVal + "_on";
		exploder::exploder(level.var_d1316ad);
	}
	else if(isdefined(level.var_d1316ad))
	{
		exploder::stop_exploder(level.var_d1316ad);
	}
}

/*
	Name: function_59525d83
	Namespace: namespace_bb738c6
	Checksum: 0x5CD4CA2A
	Offset: 0x850
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_59525d83(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.var_c09154cb = "lgt_vending_tap_" + newVal + "_on";
		exploder::exploder(level.var_c09154cb);
	}
	else if(isdefined(level.var_c09154cb))
	{
		exploder::stop_exploder(level.var_c09154cb);
	}
}

/*
	Name: function_e63629a0
	Namespace: namespace_bb738c6
	Checksum: 0x604F0EC
	Offset: 0x900
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
	Namespace: namespace_bb738c6
	Checksum: 0x55512872
	Offset: 0x988
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
	Namespace: namespace_bb738c6
	Checksum: 0xC8FB8059
	Offset: 0xA10
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
	Namespace: namespace_bb738c6
	Checksum: 0x8C655F26
	Offset: 0xA98
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_b169f826(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_vending_stamina_up");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_stamina_up");
	}
}

/*
	Name: function_96fbf181
	Namespace: namespace_bb738c6
	Checksum: 0xDC49EEE
	Offset: 0xB20
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_96fbf181(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["bottle_speed"], self, "tag_origin");
}

/*
	Name: function_fdc76a3e
	Namespace: namespace_bb738c6
	Checksum: 0xA0B7505D
	Offset: 0xB98
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_fdc76a3e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["bottle_jugg"], self, "tag_origin");
}

/*
	Name: function_5192f840
	Namespace: namespace_bb738c6
	Checksum: 0xAA0F9BB2
	Offset: 0xC10
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_5192f840(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["bottle_dtap"], self, "tag_origin");
}

