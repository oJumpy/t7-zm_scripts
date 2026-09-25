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

#namespace zm_powerup_ww_grenade;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x6072768
	Offset: 0x368
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_ww_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x3361D814
	Offset: 0x3A8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("ww_grenade", &grab_ww_grenade);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("ww_grenade", "p7_zm_power_up_widows_wine", &"ZOMBIE_POWERUP_WW_GRENADE", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_player_specific("ww_grenade", 1);
	}
	/#
		level thread function_39ac3091();
	#/
}

/*
	Name: grab_ww_grenade
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x5CA451F5
	Offset: 0x490
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function grab_ww_grenade(player)
{
	level thread ww_grenade_powerup(self, player);
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: ww_grenade_powerup
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x6BD72D27
	Offset: 0x4E0
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function ww_grenade_powerup(item, player)
{
	if(!player laststand::player_is_in_laststand() && !player.sessionstate == "spectator")
	{
		if(player hasPerk("specialty_widowswine"))
		{
			change = 1;
			oldammo = player GetWeaponAmmoClip(player.current_lethal_grenade);
			maxAmmo = player.current_lethal_grenade.startammo;
			newAmmo = Int(min(maxAmmo, max(0, oldammo + change)));
			player SetWeaponAmmoClip(player.current_lethal_grenade, newAmmo);
		}
	}
}

/*
	Name: function_39ac3091
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x5787EA35
	Offset: 0x630
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_39ac3091()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_dcedd7b5);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_2449723c
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x2F4519CF
	Offset: 0x6B8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_2449723c()
{
	/#
		if(isdefined(self.var_2654b40c))
		{
			if(self.var_2654b40c == GetTime())
			{
				return 1;
			}
		}
		self.var_2654b40c = GetTime();
		return 0;
	#/
}

/*
	Name: function_dcedd7b5
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x534E7A40
	Offset: 0x6F8
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function function_dcedd7b5(cmd)
{
	/#
		players = GetPlayers();
		retval = 0;
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				Array::thread_all(players, &zm_devgui::function_9589a11f, cmd, 1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				Array::thread_all(players, &zm_devgui::function_9589a11f, GetSubStr(cmd, 5), 0);
				return 1;
			}
		}
		return retval;
	#/
}

