#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_timer;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_timer
	Checksum: 0x7D77C56C
	Offset: 0x1D8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_timer", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_timer
	Checksum: 0x99EC1590
	Offset: 0x220
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_genesis_timer
	Checksum: 0x393961B1
	Offset: 0x230
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __main__()
{
	clientfield::register("world", "time_attack_reward", 12000, 3, "int", &set_time_attack_reward, 0, 0);
	level.wallbuy_callback_hack_override = &function_3ec869e2;
}

/*
	Name: set_time_attack_reward
	Namespace: zm_genesis_timer
	Checksum: 0x10087577
	Offset: 0x2A0
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function set_time_attack_reward(n_local_client, n_old_val, n_new_val, b_new_ent, var_b54312de, str_field_name, b_was_time_jump)
{
	level.var_dd724c18 = n_new_val;
}

/*
	Name: function_3ec869e2
	Namespace: zm_genesis_timer
	Checksum: 0x5C64D2C9
	Offset: 0x2F0
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function function_3ec869e2()
{
	s_parent = self.parent_struct;
	if(!isdefined(s_parent.var_67b0ba8d))
	{
		s_parent.var_67b0ba8d = s_parent.origin;
	}
	if(!isdefined(self.var_cd859c93))
	{
		self.var_cd859c93 = self.angles;
	}
	v_offset_origin = (0, 0, 0);
	var_5c51aae8 = (0, 0, 0);
	switch(level.var_dd724c18)
	{
		case 1:
		{
			self SetModel("wpn_t7_loot_nunchucks_world");
			break;
		}
		case 2:
		{
			self SetModel("wpn_t7_loot_mace_world");
			var_5c51aae8 = VectorScale((1, 0, 0), 90);
			break;
		}
		case 3:
		{
			self SetModel("wpn_t7_loot_improvise_world");
			v_offset_origin = VectorScale((0, -1, 0), 3);
			var_5c51aae8 = VectorScale((1, 0, 0), 90);
			break;
		}
		case 4:
		{
			self SetModel("wpn_t7_loot_boneglass_world");
			v_offset_origin = (0, -6, 1);
			var_5c51aae8 = VectorScale((-1, 0, 0), 15);
			break;
		}
		case 5:
		{
			self SetModel("wpn_t7_loot_melee_katana_world");
			v_offset_origin = (1, -22, 0);
			var_5c51aae8 = VectorScale((-1, 0, 0), 88);
			break;
		}
	}
	s_parent.origin = s_parent.var_67b0ba8d + v_offset_origin;
	self.angles = self.var_cd859c93 + var_5c51aae8;
}

