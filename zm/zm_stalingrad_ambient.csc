#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace namespace_c71bfefb;

/*
	Name: __init__sytem__
	Namespace: namespace_c71bfefb
	Checksum: 0x321BCE00
	Offset: 0x360
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_ambient", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c71bfefb
	Checksum: 0x2C9D783D
	Offset: 0x3A0
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "ambient_mortar_strike", 12000, 2, "int", &function_c6cda7e2, 0, 0);
	clientfield::register("scriptmover", "ambient_artillery_strike", 12000, 2, "int", &function_9c206421, 0, 0);
	clientfield::register("world", "power_on_level", 12000, 1, "int", &function_bad0de07, 0, 0);
	level thread function_866a2751();
	level thread function_a8bcf075();
	level thread function_1eb91e4b();
	level thread function_b833e317();
	level thread function_65c51e85();
}

/*
	Name: function_c6cda7e2
	Namespace: namespace_c71bfefb
	Checksum: 0xBDBEBA14
	Offset: 0x500
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function function_c6cda7e2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			var_df2299f9 = "ambient_mortar_small";
			break;
		}
		case 2:
		{
			var_df2299f9 = "ambient_mortar_medium";
			break;
		}
		case 3:
		{
			var_df2299f9 = "ambient_mortar_large";
			break;
		}
		case default:
		{
			return;
		}
	}
	self thread function_a7d3e4ff(localClientNum, var_df2299f9);
}

/*
	Name: function_9c206421
	Namespace: namespace_c71bfefb
	Checksum: 0xA0BF571E
	Offset: 0x5D0
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function function_9c206421(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			var_df2299f9 = "ambient_artillery_small";
			break;
		}
		case 2:
		{
			var_df2299f9 = "ambient_artillery_medium";
			break;
		}
		case 3:
		{
			var_df2299f9 = "ambient_artillery_large";
			break;
		}
		case default:
		{
			return;
		}
	}
	self thread function_a7d3e4ff(localClientNum, var_df2299f9);
}

/*
	Name: function_a7d3e4ff
	Namespace: namespace_c71bfefb
	Checksum: 0xB40305A0
	Offset: 0x6A0
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function function_a7d3e4ff(localClientNum, var_df2299f9)
{
	level endon("demo_jump");
	playsound(localClientNum, "prj_mortar_incoming", self.origin);
	wait(1);
	playsound(localClientNum, "exp_mortar", self.origin);
	playFX(localClientNum, level._effect[var_df2299f9], self.origin);
	PlayRumbleOnPosition(localClientNum, "artillery_rumble", self.origin);
}

/*
	Name: function_bad0de07
	Namespace: namespace_c71bfefb
	Checksum: 0x2024E277
	Offset: 0x778
	Size: 0x51
	Parameters: 7
	Flags: None
*/
function function_bad0de07(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(n_new)
	{
		level notify("hash_bad0de07");
	}
}

/*
	Name: function_866a2751
	Namespace: namespace_c71bfefb
	Checksum: 0x4636F9D7
	Offset: 0x7D8
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_866a2751()
{
	level thread function_916d6917("comm_monitor_lrg_combined");
	level thread function_916d6917("comm_equip_top_01");
	level thread function_916d6917("comm_equip_top_02");
	level thread function_916d6917("comm_equip_top_03");
	level thread function_916d6917("comm_equip_top_04");
	level thread function_916d6917("comm_equip_base_02");
	level waittill("hash_bad0de07");
	function_4820908f("comm_monitor_lrg_combined_off");
	function_4820908f("comm_equip_top_01_off");
	function_4820908f("comm_equip_top_02_off");
	function_4820908f("comm_equip_top_03_off");
	function_4820908f("comm_equip_top_04_off");
	function_4820908f("comm_equip_base_02_off");
}

/*
	Name: function_916d6917
	Namespace: namespace_c71bfefb
	Checksum: 0x736496A9
	Offset: 0x948
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function function_916d6917(str_targetname)
{
	var_1bbd14fd = function_de7504ea(str_targetname);
	foreach(n_model_index in var_1bbd14fd)
	{
		HideStaticModel(n_model_index);
	}
	level waittill("hash_bad0de07");
	foreach(n_model_index in var_1bbd14fd)
	{
		UnhideStaticModel(n_model_index);
	}
}

/*
	Name: function_4820908f
	Namespace: namespace_c71bfefb
	Checksum: 0x7602F239
	Offset: 0xA90
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function function_4820908f(str_targetname)
{
	var_1bbd14fd = function_de7504ea(str_targetname);
	foreach(n_model_index in var_1bbd14fd)
	{
		UnhideStaticModel(n_model_index);
	}
	level waittill("hash_bad0de07");
	foreach(n_model_index in var_1bbd14fd)
	{
		HideStaticModel(n_model_index);
	}
}

/*
	Name: function_a8bcf075
	Namespace: namespace_c71bfefb
	Checksum: 0x89A66A65
	Offset: 0xBD8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_a8bcf075()
{
	level waittill("hash_350165d0");
	audio::snd_set_snapshot("zmb_stal_boss_fight");
}

/*
	Name: function_1eb91e4b
	Namespace: namespace_c71bfefb
	Checksum: 0xC24BAAC2
	Offset: 0xC10
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_1eb91e4b()
{
	level waittill("hash_2a3c981c");
	audio::snd_set_snapshot("default");
}

/*
	Name: function_b833e317
	Namespace: namespace_c71bfefb
	Checksum: 0x30FAB8DC
	Offset: 0xC48
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_b833e317()
{
	level waittill("hash_18671e96");
	audio::snd_set_snapshot("zmb_stal_dragon_fight");
}

/*
	Name: function_b6e2489
	Namespace: namespace_c71bfefb
	Checksum: 0x47AB23DC
	Offset: 0xC80
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_b6e2489()
{
	level waittill("hash_b9dbb809");
	audio::snd_set_snapshot("default");
}

/*
	Name: function_65c51e85
	Namespace: namespace_c71bfefb
	Checksum: 0xB0BEC197
	Offset: 0xCB8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_65c51e85()
{
	audio::playloopat("amb_air_raid", (-1819, 2705, 1167));
}

