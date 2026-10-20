#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_empty_perk;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_empty_perk
	Checksum: 0xB25EB9FA
	Offset: 0x2F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_empty_perk", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_empty_perk
	Checksum: 0x92939947
	Offset: 0x338
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("empty_perk", &grab_empty_perk);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("empty_perk", "zombie_pickup_perk_bottle", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("empty_perk");
	}
	level.get_player_perk_purchase_limit = &perk_purchase_limit_override;
	/#
		thread function_ac499d74();
	#/
}

/*
	Name: grab_empty_perk
	Namespace: zm_powerup_empty_perk
	Checksum: 0xE59EC9FA
	Offset: 0x430
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function grab_empty_perk(player)
{
	player thread function_ba8751f2();
}

/*
	Name: function_ba8751f2
	Namespace: zm_powerup_empty_perk
	Checksum: 0xD20565BE
	Offset: 0x460
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_ba8751f2()
{
	if(!isdefined(self.player_perk_purchase_limit))
	{
		self.player_perk_purchase_limit = level.perk_purchase_limit;
	}
	if(self.player_perk_purchase_limit < level.var_1eddc9ee)
	{
		self.player_perk_purchase_limit++;
	}
}

/*
	Name: perk_purchase_limit_override
	Namespace: zm_powerup_empty_perk
	Checksum: 0x7648FC35
	Offset: 0x4A8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function perk_purchase_limit_override()
{
	if(!isdefined(self.player_perk_purchase_limit))
	{
		self.player_perk_purchase_limit = level.perk_purchase_limit;
	}
	return self.player_perk_purchase_limit;
}

/*
	Name: function_ac499d74
	Namespace: zm_powerup_empty_perk
	Checksum: 0x310C5FD1
	Offset: 0x4D8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_ac499d74()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_5d69c3e);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_5d69c3e
	Namespace: zm_powerup_empty_perk
	Checksum: 0xF3ACE2CD
	Offset: 0x560
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_5d69c3e(cmd)
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

