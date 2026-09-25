#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_free_perk;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_free_perk
	Checksum: 0xFF24FB40
	Offset: 0x310
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_free_perk", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_free_perk
	Checksum: 0xBA19622E
	Offset: 0x350
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("free_perk", &grab_free_perk);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("free_perk", "zombie_pickup_perk_bottle", &"ZOMBIE_POWERUP_FREE_PERK", &zm_powerups::func_should_never_drop, 0, 0, 0);
	}
}

/*
	Name: grab_free_perk
	Namespace: zm_powerup_free_perk
	Checksum: 0x96523314
	Offset: 0x3F8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function grab_free_perk(player)
{
	level thread free_perk_powerup(self);
}

/*
	Name: free_perk_powerup
	Namespace: zm_powerup_free_perk
	Checksum: 0xF3252F3
	Offset: 0x428
	Size: 0x195
	Parameters: 1
	Flags: None
*/
function free_perk_powerup(item)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!players[i] laststand::player_is_in_laststand() && !players[i].sessionstate == "spectator")
		{
			player = players[i];
			if(isdefined(item.ghost_powerup))
			{
				player zm_stats::increment_client_stat("buried_ghost_perk_acquired", 0);
				player zm_stats::increment_player_stat("buried_ghost_perk_acquired");
				player notify("player_received_ghost_round_free_perk");
			}
			free_perk = player zm_perks::give_random_perk();
			if(isdefined(level.disable_free_perks_before_power) && level.disable_free_perks_before_power)
			{
				player thread disable_perk_before_power(free_perk);
			}
			if(isdefined(free_perk) && isdefined(level.perk_bought_func))
			{
				player [[level.perk_bought_func]](free_perk);
			}
		}
	}
}

/*
	Name: disable_perk_before_power
	Namespace: zm_powerup_free_perk
	Checksum: 0xCDF32E41
	Offset: 0x5C8
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function disable_perk_before_power(perk)
{
	self endon("disconnect");
	if(isdefined(perk))
	{
		wait(0.1);
		if(!level flag::get("power_on"))
		{
			a_players = GetPlayers();
			if(isdefined(a_players) && a_players.size == 1 && perk == "specialty_quickrevive")
			{
				return;
			}
			self zm_perks::perk_pause(perk);
			level flag::wait_till("power_on");
			self zm_perks::perk_unpause(perk);
		}
	}
}

