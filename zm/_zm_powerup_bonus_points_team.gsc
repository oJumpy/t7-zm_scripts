#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
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

#namespace namespace_50ac7dd1;

/*
	Name: __init__sytem__
	Namespace: namespace_50ac7dd1
	Checksum: 0x8625486A
	Offset: 0x2F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_bonus_points_team", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_50ac7dd1
	Checksum: 0x5BB4F292
	Offset: 0x330
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("bonus_points_team", &function_b6e2445);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("bonus_points_team", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS", &zm_powerups::func_should_never_drop, 0, 0, 0);
	}
}

/*
	Name: function_b6e2445
	Namespace: namespace_50ac7dd1
	Checksum: 0x5EDE4947
	Offset: 0x3D8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_b6e2445(player)
{
	level thread bonus_points_team_powerup(self);
	player thread zm_powerups::powerup_vo("bonus_points_team");
}

/*
	Name: bonus_points_team_powerup
	Namespace: namespace_50ac7dd1
	Checksum: 0x73E3D073
	Offset: 0x428
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function bonus_points_team_powerup(item)
{
	points = randomIntRange(1, 25) * 100;
	if(isdefined(level.bonus_points_powerup_override))
	{
		points = [[level.bonus_points_powerup_override]]();
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!players[i] laststand::player_is_in_laststand() && !players[i].sessionstate == "spectator")
		{
			players[i] zm_score::player_add_points("bonus_points_powerup", points);
		}
	}
}

