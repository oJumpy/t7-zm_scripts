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

#namespace namespace_f633c4d9;

/*
	Name: __init__sytem__
	Namespace: namespace_f633c4d9
	Checksum: 0xD56F9A47
	Offset: 0x308
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_bonus_points_player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_f633c4d9
	Checksum: 0xA617132C
	Offset: 0x348
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("bonus_points_player", &function_17a48195);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("bonus_points_player", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS", &zm_powerups::func_should_never_drop, 1, 0, 0);
	}
}

/*
	Name: function_17a48195
	Namespace: namespace_f633c4d9
	Checksum: 0xAE29B89
	Offset: 0x3F8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_17a48195(player)
{
	level thread bonus_points_player_powerup(self, player);
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: bonus_points_player_powerup
	Namespace: namespace_f633c4d9
	Checksum: 0xC869E739
	Offset: 0x448
	Size: 0xE3
	Parameters: 2
	Flags: None
*/
function bonus_points_player_powerup(item, player)
{
	points = randomIntRange(1, 25) * 100;
	if(isdefined(level.bonus_points_powerup_override))
	{
		points = [[level.bonus_points_powerup_override]]();
	}
	if(isdefined(item.bonus_points_powerup_override))
	{
		points = [[item.bonus_points_powerup_override]]();
	}
	if(!player laststand::player_is_in_laststand() && !player.sessionstate == "spectator")
	{
		player zm_score::player_add_points("bonus_points_powerup", points);
	}
}

