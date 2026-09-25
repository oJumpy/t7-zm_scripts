#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_e581e076;

/*
	Name: __init__sytem__
	Namespace: namespace_e581e076
	Checksum: 0x2AFDEAAB
	Offset: 0x4A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_demonic_rune", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_e581e076
	Checksum: 0x9CBD3652
	Offset: 0x4E8
	Size: 0x57B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "demonic_rune_fx", 5000, 1, "int");
	zm_powerups::register_powerup("demonic_rune_lor", &function_b11a0932);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_lor", "p7_zm_ctl_demon_gate_power_up_icons_lor", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_lor");
		zm_powerups::powerup_set_player_specific("demonic_rune_lor", 1);
	}
	zm_powerups::register_powerup("demonic_rune_ulla", &function_b11a0932);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_ulla", "p7_zm_ctl_demon_gate_power_up_icons_door", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_ulla");
		zm_powerups::powerup_set_player_specific("demonic_rune_ulla", 1);
	}
	zm_powerups::register_powerup("demonic_rune_oth", &function_b11a0932);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_oth", "p7_zm_ctl_demon_gate_power_up_icons_oth", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_oth");
		zm_powerups::powerup_set_player_specific("demonic_rune_oth", 1);
	}
	zm_powerups::register_powerup("demonic_rune_zor", &function_b11a0932);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_zor", "p7_zm_ctl_demon_gate_power_up_icons_zor", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_zor");
		zm_powerups::powerup_set_player_specific("demonic_rune_zor", 1);
	}
	zm_powerups::register_powerup("demonic_rune_mar", &function_b11a0932);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_mar", "p7_zm_ctl_demon_gate_power_up_icons_stag", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_mar");
		zm_powerups::powerup_set_player_specific("demonic_rune_mar", 1);
	}
	zm_powerups::register_powerup("demonic_rune_uja", &function_b11a0932);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_uja", "p7_zm_ctl_demon_gate_power_up_icons_uja", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_uja");
		zm_powerups::powerup_set_player_specific("demonic_rune_uja", 1);
	}
	level flag::init("demonic_rune_dropped");
	/#
		level thread function_15732f56();
	#/
}

/*
	Name: function_b11a0932
	Namespace: namespace_e581e076
	Checksum: 0xA6FDB452
	Offset: 0xA70
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_b11a0932(player)
{
	level flag::clear("demonic_rune_dropped");
	level notify("hash_968008cb");
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: function_5b767c2
	Namespace: namespace_e581e076
	Checksum: 0xC4640AE2
	Offset: 0xAD0
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function function_5b767c2()
{
	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self zm_powerups::powerup_show(1);
	wait_time = 1;
	if(isdefined(level._powerup_timeout_custom_time))
	{
		time = [[level._powerup_timeout_custom_time]](self);
		if(time == 0)
		{
			return;
		}
		wait_time = time;
	}
	wait(wait_time);
	for(i = 20; i > 0; i--)
	{
		if(i % 2)
		{
			self zm_powerups::powerup_show(0);
		}
		else
		{
			self zm_powerups::powerup_show(1);
		}
		if(i > 15)
		{
			wait(0.3);
		}
		if(i > 10)
		{
			wait(0.25);
			continue;
		}
		if(i > 5)
		{
			wait(0.15);
			continue;
		}
		wait(0.1);
	}
	level.var_923a3c95 = undefined;
	level flag::clear("demonic_rune_dropped");
	level notify("hash_a4e87164");
	self notify("powerup_timedout");
	self zm_powerups::powerup_delete();
}

/*
	Name: function_15732f56
	Namespace: namespace_e581e076
	Checksum: 0x53E08A60
	Offset: 0xC90
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_15732f56()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_a4207c70);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_2449723c
	Namespace: namespace_e581e076
	Checksum: 0xB0634DD7
	Offset: 0xD78
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_2449723c()
{
	/#
		if(isdefined(self.var_1688944a))
		{
			if(self.var_1688944a == GetTime())
			{
				return 1;
			}
		}
		self.var_1688944a = GetTime();
		return 0;
	#/
}

/*
	Name: function_a4207c70
	Namespace: namespace_e581e076
	Checksum: 0xB687FD05
	Offset: 0xDB8
	Size: 0x297
	Parameters: 1
	Flags: None
*/
function function_a4207c70(cmd)
{
	/#
		if(!isdefined(level.var_6e68c0d8) || !level flag::get("Dev Block strings are not supported") || level flag::get("Dev Block strings are not supported"))
		{
			return;
		}
		retval = 0;
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::function_9589a11f(cmd, 1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::function_9589a11f(cmd, 1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::function_9589a11f(cmd, 1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::function_9589a11f(cmd, 1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::function_9589a11f(cmd, 1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::function_9589a11f(cmd, 1);
				return 1;
			}
		}
		return retval;
	#/
}

