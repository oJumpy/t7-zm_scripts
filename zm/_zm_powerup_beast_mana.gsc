#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_6500cb2b;

/*
	Name: __init__sytem__
	Namespace: namespace_6500cb2b
	Checksum: 0x10D4FC6B
	Offset: 0x340
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_beast_mana", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6500cb2b
	Checksum: 0x23A9D5CF
	Offset: 0x380
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("beast_mana", &function_fb2447d7);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("beast_mana", "zombie_z_money_icon", &"ZM_ZOD_POWERUP_BEAST_MANA", &zm_powerups::func_should_never_drop, 1, 0, 0);
	}
}

/*
	Name: function_fb2447d7
	Namespace: namespace_6500cb2b
	Checksum: 0x7FED1127
	Offset: 0x430
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_fb2447d7(player)
{
	level thread function_98d4dd81(self, player);
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: function_98d4dd81
	Namespace: namespace_6500cb2b
	Checksum: 0x168E0B4D
	Offset: 0x480
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function function_98d4dd81(item, player)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!players[i] laststand::player_is_in_laststand() && !players[i].sessionstate == "spectator")
		{
			if(isdefined(players[i].beastmode) && players[i].beastmode)
			{
				players[i].var_39f3c137 = 1;
				continue;
			}
			players[i].var_5e82a563++;
		}
	}
	level thread function_5cff02a2(item, player.team);
}

/*
	Name: function_5cff02a2
	Namespace: namespace_6500cb2b
	Checksum: 0x189DE10B
	Offset: 0x5B8
	Size: 0x123
	Parameters: 2
	Flags: None
*/
function function_5cff02a2(drop_item, player_team)
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
	Namespace: namespace_6500cb2b
	Checksum: 0x4EE9D9A3
	Offset: 0x6E8
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

