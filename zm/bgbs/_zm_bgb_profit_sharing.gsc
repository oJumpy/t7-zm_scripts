#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_profit_sharing;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x349E44D2
	Offset: 0x288
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_profit_sharing", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x56CF753D
	Offset: 0x2C8
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("allplayers", "zm_bgb_profit_sharing_3p_fx", 15000, 1, "int");
	clientfield::register("toplayer", "zm_bgb_profit_sharing_1p_fx", 15000, 1, "int");
	bgb::register("zm_bgb_profit_sharing", "time", 600, &enable, &disable, undefined, undefined);
	bgb::register_add_to_player_score_override("zm_bgb_profit_sharing", &add_to_player_score_override, 1);
}

/*
	Name: enable
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x835A979A
	Offset: 0x3C8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function enable()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("bgb_update");
	self thread bgb::player_proximity_watcher(720, &proximity_start, &proximity_end);
	self thread function_677e212b();
}

/*
	Name: disable
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x99EC1590
	Offset: 0x448
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

/*
	Name: function_677e212b
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x68B0A1B8
	Offset: 0x458
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function function_677e212b()
{
	self endon("disconnect");
	self clientfield::set("zm_bgb_profit_sharing_3p_fx", 1);
	self util::waittill_either("bled_out", "bgb_update");
	self clientfield::set("zm_bgb_profit_sharing_3p_fx", 0);
	self notify("profit_sharing_complete");
}

/*
	Name: add_to_player_score_override
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x487FE3A7
	Offset: 0x4E8
	Size: 0x235
	Parameters: 3
	Flags: None
*/
function add_to_player_score_override(n_points, str_awarded_by, var_1ed9bd9b)
{
	if(str_awarded_by == "zm_bgb_profit_sharing")
	{
		return n_points;
	}
	switch(str_awarded_by)
	{
		case "bgb_machine_ghost_ball":
		case "equip_hacker":
		case "magicbox_bear":
		case "reviver":
		{
			return n_points;
		}
		case default:
		{
			break;
		}
	}
	if(!var_1ed9bd9b)
	{
		foreach(e_player in level.players)
		{
			if(isdefined(e_player) && "zm_bgb_profit_sharing" == e_player bgb::get_enabled())
			{
				if(isdefined(e_player.var_6638f10b) && Array::contains(e_player.var_6638f10b, self))
				{
					e_player thread zm_score::add_to_player_score(n_points, 1, "zm_bgb_profit_sharing");
				}
			}
		}
		break;
	}
	if(isdefined(self.var_6638f10b) && self.var_6638f10b.size > 0)
	{
		foreach(e_player in self.var_6638f10b)
		{
			if(isdefined(e_player))
			{
				e_player thread zm_score::add_to_player_score(n_points, 1, "zm_bgb_profit_sharing");
			}
		}
	}
	return n_points;
}

/*
	Name: proximity_start
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x9CAE7A35
	Offset: 0x728
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function proximity_start(e_player)
{
	self function_d1d595b5();
	e_player function_d1d595b5();
	str_notify = "profit_sharing_fx_stop_" + self GetEntityNumber();
	level util::waittill_any_ents(e_player, "disconnect", e_player, str_notify, self, "disconnect", self, "profit_sharing_complete");
	if(isdefined(self))
	{
		self function_c0b35f9d();
	}
	if(isdefined(e_player))
	{
		e_player function_c0b35f9d();
	}
}

/*
	Name: proximity_end
	Namespace: zm_bgb_profit_sharing
	Checksum: 0xE52AF0DC
	Offset: 0x810
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function proximity_end(e_player)
{
	str_notify = "profit_sharing_fx_stop_" + self GetEntityNumber();
	e_player notify(str_notify);
}

/*
	Name: function_d1d595b5
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x6534358C
	Offset: 0x858
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_d1d595b5()
{
	if(!isdefined(self.var_95b54) || self.var_95b54 == 0)
	{
		self.var_95b54 = 1;
		self clientfield::set_to_player("zm_bgb_profit_sharing_1p_fx", 1);
	}
	else
	{
		self.var_95b54++;
	}
}

/*
	Name: function_c0b35f9d
	Namespace: zm_bgb_profit_sharing
	Checksum: 0xD977B079
	Offset: 0x8C0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_c0b35f9d()
{
	self.var_95b54--;
	if(self.var_95b54 == 0)
	{
		self clientfield::set_to_player("zm_bgb_profit_sharing_1p_fx", 0);
	}
}

