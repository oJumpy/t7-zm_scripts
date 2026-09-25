#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod;

#namespace namespace_54c8dc69;

/*
	Name: __init__sytem__
	Namespace: namespace_54c8dc69
	Checksum: 0x7F2F7ECB
	Offset: 0x2C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee_side", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_54c8dc69
	Checksum: 0xB9F33274
	Offset: 0x300
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "change_bouncingbetties", 1, 2, "int", &function_fc478037, 0, 0);
	clientfield::register("world", "lil_arnie_dance", 1, 1, "int", &function_905dbf86, 0, 0);
	level._effect["portal_3p"] = "zombie/fx_quest_portal_trail_zod_zmb";
	level._effect["octobomb_explode"] = "zombie/fx_octobomb_explo_death_ee_zod_zmb";
}

/*
	Name: function_fc478037
	Namespace: namespace_54c8dc69
	Checksum: 0xC771E5B6
	Offset: 0x3D8
	Size: 0x9D
	Parameters: 7
	Flags: None
*/
function function_fc478037(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			level._effect["fx_betty_exp"] = "zombie/fx_donut_exp_zod_zmb";
			break;
		}
		case 2:
		{
			level._effect["fx_betty_exp"] = "zombie/fx_cake_exp_zod_zmb";
			break;
		}
	}
}

/*
	Name: function_905dbf86
	Namespace: namespace_54c8dc69
	Checksum: 0x3614C8B1
	Offset: 0x480
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_905dbf86(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		thread function_a5b33f7(localClientNum);
	}
}

/*
	Name: function_a5b33f7
	Namespace: namespace_54c8dc69
	Checksum: 0x23321553
	Offset: 0x4F0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_a5b33f7(localClientNum)
{
	scene::add_scene_func("zm_zod_lil_arnie_dance", &function_75ad5595, "play");
	level scene::Play("zm_zod_lil_arnie_dance");
	var_150c4640 = struct::get("lil_arnie_stage_center");
	playFX(localClientNum, level._effect["octobomb_explode"], var_150c4640.origin);
}

/*
	Name: function_75ad5595
	Namespace: namespace_54c8dc69
	Checksum: 0xF5F50AE6
	Offset: 0x5B0
	Size: 0x121
	Parameters: 1
	Flags: Private
*/
function private function_75ad5595(var_ff840495)
{
	var_ff840495["arnie_tie_mdl"] SetScale(0.13);
	var_ff840495["arnie_hat_mdl"] SetScale(0.18);
	var_ff840495["arnie_cane_mdl"] SetScale(0.08);
	foreach(var_fba08aba in var_ff840495)
	{
		playFX(0, level._effect["portal_3p"], var_fba08aba.origin);
	}
}

