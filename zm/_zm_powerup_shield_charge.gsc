#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
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

#namespace zm_powerup_shield_charge;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_shield_charge
	Checksum: 0x11E28EF8
	Offset: 0x3A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_shield_charge", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_shield_charge
	Checksum: 0xC93CD9A9
	Offset: 0x3E0
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("shield_charge", &grab_shield_charge);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("shield_charge", "p7_zm_zod_nitrous_tank", &"ZOMBIE_POWERUP_SHIELD_CHARGE", &func_drop_when_players_own, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("shield_charge");
	}
	/#
		thread function_f3127c4f();
	#/
}

/*
	Name: func_drop_when_players_own
	Namespace: zm_powerup_shield_charge
	Checksum: 0x88A8188A
	Offset: 0x4C0
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function func_drop_when_players_own()
{
	return 0;
}

/*
	Name: grab_shield_charge
	Namespace: zm_powerup_shield_charge
	Checksum: 0xFA7A3EFD
	Offset: 0x4D0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function grab_shield_charge(player)
{
	level thread shield_charge_powerup(self, player);
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: shield_charge_powerup
	Namespace: zm_powerup_shield_charge
	Checksum: 0xFDA8D266
	Offset: 0x520
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function shield_charge_powerup(item, player)
{
	if(isdefined(player.hasRiotShield) && player.hasRiotShield)
	{
		player GiveStartAmmo(player.weaponRiotshield);
	}
	level thread shield_on_hud(item, player.team);
}

/*
	Name: shield_on_hud
	Namespace: zm_powerup_shield_charge
	Checksum: 0x62901095
	Offset: 0x5B0
	Size: 0x123
	Parameters: 2
	Flags: None
*/
function shield_on_hud(drop_item, player_team)
{
	self endon("disconnect");
	hudelem = hud::createServerFontString("objective", 2, player_team);
	hudelem hud::setPoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - level.zombie_vars["zombie_timer_offset_interval"] * 2);
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeOverTime(0.5);
	hudelem.alpha = 1;
	if(isdefined(drop_item))
	{
		hudelem.label = drop_item.hint;
	}
	hudelem thread full_ammo_move_hud(player_team);
}

/*
	Name: full_ammo_move_hud
	Namespace: zm_powerup_shield_charge
	Checksum: 0x235C03E6
	Offset: 0x6E0
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function full_ammo_move_hud(player_team)
{
	players = GetPlayers(player_team);
	players[0] playsoundtoteam("zmb_full_ammo", player_team);
	wait(0.5);
	move_fade_time = 1.5;
	self fadeOverTime(move_fade_time);
	self MoveOverTime(move_fade_time);
	self.y = 270;
	self.alpha = 0;
	wait(move_fade_time);
	self destroy();
}

/*
	Name: function_f3127c4f
	Namespace: zm_powerup_shield_charge
	Checksum: 0xEB04E2DF
	Offset: 0x7C0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_f3127c4f()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_b6937313);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_b6937313
	Namespace: zm_powerup_shield_charge
	Checksum: 0x20C58BDA
	Offset: 0x848
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_b6937313(cmd)
{
	/#
		players = GetPlayers();
		retval = 0;
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				zm_devgui::zombie_devgui_give_powerup(cmd, 1);
				break;
			}
			case "Dev Block strings are not supported":
			{
				zm_devgui::zombie_devgui_give_powerup(GetSubStr(cmd, 5), 0);
				break;
			}
		}
		return retval;
	#/
}

