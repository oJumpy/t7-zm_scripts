#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_burned_out;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_burned_out
	Checksum: 0x4741742B
	Offset: 0x260
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_burned_out", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_burned_out
	Checksum: 0x867604FE
	Offset: 0x2A0
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_burned_out", "event", &event, undefined, undefined, undefined);
	clientfield::register("toplayer", "zm_bgb_burned_out" + "_1p" + "toplayer", 1, 1, "counter");
	clientfield::register("allplayers", "zm_bgb_burned_out" + "_3p" + "_allplayers", 1, 1, "counter");
	clientfield::register("actor", "zm_bgb_burned_out" + "_fire_torso" + "_actor", 1, 1, "counter");
	clientfield::register("vehicle", "zm_bgb_burned_out" + "_fire_torso" + "_vehicle", 1, 1, "counter");
}

/*
	Name: event
	Namespace: zm_bgb_burned_out
	Checksum: 0x46F389B1
	Offset: 0x400
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("bgb_update");
	limit_count = 0;
	self thread bgb::set_timer(2, 2);
	for(;;)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type);
		if("MOD_MELEE" != type || !isai(attacker))
		{
			continue;
		}
		self thread result();
		self playsound("zmb_bgb_powerup_burnedout");
		limit_count++;
		self thread bgb::set_timer(2 - limit_count, 2);
		self bgb::do_one_shot_use();
		if(2 <= limit_count)
		{
			return;
		}
		wait(1.5);
	}
}

/*
	Name: result
	Namespace: zm_bgb_burned_out
	Checksum: 0xD3104A3F
	Offset: 0x558
	Size: 0x325
	Parameters: 0
	Flags: None
*/
function result()
{
	self clientfield::increment_to_player("zm_bgb_burned_out" + "_1p" + "toplayer");
	self clientfield::increment("zm_bgb_burned_out" + "_3p" + "_allplayers");
	zombies = Array::get_all_closest(self.origin, GetAITeamArray(level.zombie_team), undefined, undefined, 720);
	if(!isdefined(zombies))
	{
		return;
	}
	dist_sq = 720 * 720;
	zombies_burned_out = [];
	for(i = 0; i < zombies.size; i++)
	{
		if(isdefined(zombies[i].ignore_nuke) && zombies[i].ignore_nuke)
		{
			continue;
		}
		if(isdefined(zombies[i].marked_for_death) && zombies[i].marked_for_death)
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
		{
			continue;
		}
		zombies[i].marked_for_death = 1;
		if(isVehicle(zombies[i]))
		{
			zombies[i] clientfield::increment("zm_bgb_burned_out" + "_fire_torso" + "_vehicle");
		}
		else
		{
			zombies[i] clientfield::increment("zm_bgb_burned_out" + "_fire_torso" + "_actor");
		}
		zombies_burned_out[zombies_burned_out.size] = zombies[i];
	}
	for(i = 0; i < zombies_burned_out.size; i++)
	{
		util::wait_network_frame();
		if(!isdefined(zombies_burned_out[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies_burned_out[i]))
		{
			continue;
		}
		zombies_burned_out[i] DoDamage(zombies_burned_out[i].health + 666, zombies_burned_out[i].origin);
		self zm_stats::increment_challenge_stat("GUM_GOBBLER_BURNED_OUT");
	}
}

