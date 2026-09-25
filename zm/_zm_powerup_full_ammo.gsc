#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_full_ammo;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_full_ammo
	Checksum: 0xD3F246E4
	Offset: 0x2A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_full_ammo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_full_ammo
	Checksum: 0xDEFD7360
	Offset: 0x2E8
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("full_ammo", &grab_full_ammo);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("full_ammo", "p7_zm_power_up_max_ammo", &"ZOMBIE_POWERUP_MAX_AMMO", &zm_powerups::func_should_always_drop, 0, 0, 0);
	}
}

/*
	Name: grab_full_ammo
	Namespace: zm_powerup_full_ammo
	Checksum: 0x4051E8D1
	Offset: 0x390
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function grab_full_ammo(player)
{
	level thread full_ammo_powerup(self, player);
	player thread zm_powerups::powerup_vo("full_ammo");
}

/*
	Name: full_ammo_powerup
	Namespace: zm_powerup_full_ammo
	Checksum: 0xB43E3EE0
	Offset: 0x3E0
	Size: 0x2F3
	Parameters: 2
	Flags: None
*/
function full_ammo_powerup(drop_item, player)
{
	players = GetPlayers(player.team);
	if(isdefined(level._get_game_module_players))
	{
		players = [[level._get_game_module_players]](player);
	}
	level notify("zmb_max_ammo_level");
	for(i = 0; i < players.size; i++)
	{
		if(players[i] laststand::player_is_in_laststand())
		{
			break;
		}
		if(isdefined(level.check_player_is_ready_for_ammo))
		{
			if([[level.check_player_is_ready_for_ammo]](players[i]) == 0)
			{
				break;
			}
		}
		primary_weapons = players[i] GetWeaponsList(1);
		players[i] notify("zmb_max_ammo");
		players[i] notify("zmb_lost_knife");
		players[i] zm_placeable_mine::disable_all_prompts_for_player();
		for(x = 0; x < primary_weapons.size; x++)
		{
			if(level.headshots_only && zm_utility::is_lethal_grenade(primary_weapons[x]))
			{
				continue;
			}
			if(isdefined(level.zombie_include_equipment) && isdefined(level.zombie_include_equipment[primary_weapons[x]]) && (!isdefined(level.zombie_equipment[primary_weapons[x]].refill_max_ammo) && level.zombie_equipment[primary_weapons[x]].refill_max_ammo))
			{
				continue;
			}
			if(isdefined(level.zombie_weapons_no_max_ammo) && isdefined(level.zombie_weapons_no_max_ammo[primary_weapons[x].name]))
			{
				continue;
			}
			if(zm_utility::is_hero_weapon(primary_weapons[x]))
			{
				continue;
			}
			if(players[i] HasWeapon(primary_weapons[x]))
			{
				players[i] giveMaxAmmo(primary_weapons[x]);
			}
		}
	}
	level thread full_ammo_on_hud(drop_item, player.team);
}

/*
	Name: full_ammo_on_hud
	Namespace: zm_powerup_full_ammo
	Checksum: 0xC26AF102
	Offset: 0x6E0
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function full_ammo_on_hud(drop_item, player_team)
{
	players = GetPlayers(player_team);
	players[0] playsoundtoteam("zmb_full_ammo", player_team);
	if(isdefined(drop_item))
	{
		LUINotifyEvent(&"zombie_notification", 1, drop_item.hint);
	}
}

