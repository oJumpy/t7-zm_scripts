#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_fd6bdadc;

/*
	Name: __init__sytem__
	Namespace: namespace_fd6bdadc
	Checksum: 0x2EF31405
	Offset: 0x1D0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_timer", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_fd6bdadc
	Checksum: 0x99EC1590
	Offset: 0x218
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: namespace_fd6bdadc
	Checksum: 0xE39BF422
	Offset: 0x228
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __main__()
{
	clientfield::register("world", "time_attack_reward", 12000, 3, "int", &function_b94ee48a, 0, 0);
	level.wallbuy_callback_hack_override = &function_3ec869e2;
}

/*
	Name: function_b94ee48a
	Namespace: namespace_fd6bdadc
	Checksum: 0x9E44C41C
	Offset: 0x298
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function function_b94ee48a(n_local_client, var_3bf16bb3, var_6998917a, b_new_ent, var_b54312de, str_field_name, b_was_time_jump)
{
	level.var_dd724c18 = var_6998917a;
}

/*
	Name: function_3ec869e2
	Namespace: namespace_fd6bdadc
	Checksum: 0x9C381C10
	Offset: 0x2E8
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function function_3ec869e2()
{
	switch(level.var_dd724c18)
	{
		case 1:
		{
			self SetModel("wpn_t7_loot_wrench_world");
			break;
		}
		case 2:
		{
			self SetModel("wpn_t7_loot_ritual_dagger_world");
			break;
		}
		case 3:
		{
			self SetModel("wpn_t7_loot_axe_world");
			break;
		}
		case 4:
		{
			self SetModel("wpn_t7_loot_sword_world");
			break;
		}
		case 5:
		{
			self SetModel("wpn_t7_loot_daisho_world");
			break;
		}
	}
}

