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

#namespace namespace_403823cc;

/*
	Name: __init__sytem__
	Namespace: namespace_403823cc
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
	Namespace: namespace_403823cc
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
	Namespace: namespace_403823cc
	Checksum: 0x46F389B1
	Offset: 0x400
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	var_63a08f52 = 0;
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
		var_63a08f52++;
		self thread bgb::set_timer(2 - var_63a08f52, 2);
		self bgb::do_one_shot_use();
		if(2 <= var_63a08f52)
		{
			return;
		}
		wait(1.5);
	}
}

/*
	Name: result
	Namespace: namespace_403823cc
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
	var_c8f67e5c = [];
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
		var_c8f67e5c[var_c8f67e5c.size] = zombies[i];
	}
	for(i = 0; i < var_c8f67e5c.size; i++)
	{
		util::wait_network_frame();
		if(!isdefined(var_c8f67e5c[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_c8f67e5c[i]))
		{
			continue;
		}
		var_c8f67e5c[i] DoDamage(var_c8f67e5c[i].health + 666, var_c8f67e5c[i].origin);
		self zm_stats::increment_challenge_stat("GUM_GOBBLER_BURNED_OUT");
	}
}

