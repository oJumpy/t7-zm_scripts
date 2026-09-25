#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_2d028ffb;

/*
	Name: __init__sytem__
	Namespace: namespace_2d028ffb
	Checksum: 0x5C046E5F
	Offset: 0x1D8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zmhd_cleanup", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_2d028ffb
	Checksum: 0x32C7AE08
	Offset: 0x220
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.n_cleanups_processed_this_frame = 0;
	level.no_target_override = &no_target_override;
}

/*
	Name: __main__
	Namespace: namespace_2d028ffb
	Checksum: 0xD2AC0899
	Offset: 0x250
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread cleanup_main();
}

/*
	Name: force_check_now
	Namespace: namespace_2d028ffb
	Checksum: 0x5A67A09
	Offset: 0x278
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function force_check_now()
{
	level notify("pump_distance_check");
}

/*
	Name: cleanup_main
	Namespace: namespace_2d028ffb
	Checksum: 0x342D51CB
	Offset: 0x298
	Size: 0x295
	Parameters: 0
	Flags: Private
*/
function private cleanup_main()
{
	n_next_eval = 0;
	while(1)
	{
		util::wait_network_frame();
		n_time = GetTime();
		if(n_time < n_next_eval)
		{
			continue;
		}
		if(isdefined(level.n_cleanup_manager_restart_time))
		{
			n_current_time = GetTime() / 1000;
			n_delta_time = n_current_time - level.n_cleanup_manager_restart_time;
			if(n_delta_time < 0)
			{
				continue;
			}
			level.n_cleanup_manager_restart_time = undefined;
		}
		n_round_time = n_time - level.round_start_time / 1000;
		if(level.round_number <= 5 && n_round_time < 30)
		{
			continue;
		}
		else if(level.round_number > 5 && n_round_time < 20)
		{
			continue;
		}
		if(isdefined(level.ignore_distance_tracking) && level.ignore_distance_tracking)
		{
			continue;
		}
		n_override_cleanup_dist_sq = undefined;
		if(level.zombie_total == 0 && zombie_utility::get_current_zombie_count() < 3)
		{
			n_override_cleanup_dist_sq = 2250000;
		}
		n_next_eval = n_next_eval + 3000;
		a_ai_enemies = GetAITeamArray("axis");
		foreach(ai_enemy in a_ai_enemies)
		{
			if(level.n_cleanups_processed_this_frame >= 1)
			{
				level.n_cleanups_processed_this_frame = 0;
				util::wait_network_frame();
			}
			if(isdefined(ai_enemy) && (!isdefined(ai_enemy.ignore_cleanup_mgr) && ai_enemy.ignore_cleanup_mgr))
			{
				ai_enemy do_cleanup_check(n_override_cleanup_dist_sq);
			}
		}
	}
}

/*
	Name: do_cleanup_check
	Namespace: namespace_2d028ffb
	Checksum: 0x8A0F97E9
	Offset: 0x538
	Size: 0x277
	Parameters: 1
	Flags: None
*/
function do_cleanup_check(n_override_cleanup_dist)
{
	if(!isalive(self))
	{
		return;
	}
	if(self.b_ignore_cleanup === 1)
	{
		return;
	}
	n_time_alive = GetTime() - self.spawn_time;
	if(n_time_alive < 5000)
	{
		return;
	}
	if(self.archetype === "zombie")
	{
		if(n_time_alive < 45000 && self.script_string !== "find_flesh" && self.completed_emerging_into_playable_area !== 1)
		{
			return;
		}
	}
	b_in_active_zone = self zm_zonemgr::entity_in_active_zone();
	level.n_cleanups_processed_this_frame++;
	if(!b_in_active_zone)
	{
		n_dist_sq_min = 10000000;
		e_closest_player = level.activePlayers[0];
		foreach(player in level.activePlayers)
		{
			n_dist_sq = DistanceSquared(self.origin, player.origin);
			if(n_dist_sq < n_dist_sq_min)
			{
				n_dist_sq_min = n_dist_sq;
				e_closest_player = player;
			}
		}
		if(isdefined(n_override_cleanup_dist))
		{
			n_cleanup_dist_sq = n_override_cleanup_dist;
		}
		else if(isdefined(e_closest_player) && player_ahead_of_me(e_closest_player))
		{
			n_cleanup_dist_sq = 189225;
		}
		else
		{
			n_cleanup_dist_sq = 250000;
		}
		if(n_dist_sq_min >= n_cleanup_dist_sq)
		{
			self thread delete_zombie_noone_looking();
		}
	}
	if(!isalive(self))
	{
		return;
	}
}

/*
	Name: delete_zombie_noone_looking
	Namespace: namespace_2d028ffb
	Checksum: 0x5C4A0E24
	Offset: 0x7B8
	Size: 0x27B
	Parameters: 0
	Flags: Private
*/
function private delete_zombie_noone_looking()
{
	if(isdefined(self.in_the_ground) && self.in_the_ground)
	{
		return;
	}
	foreach(player in level.players)
	{
		if(player.sessionstate == "spectator")
		{
			continue;
		}
		if(self player_can_see_me(player))
		{
			return;
		}
	}
	if(!(isdefined(self.exclude_cleanup_adding_to_total) && self.exclude_cleanup_adding_to_total))
	{
		level.zombie_total++;
		level.zombie_respawns++;
		if(self.health < self.maxhealth)
		{
			if(!isdefined(level.a_zombie_respawn_health[self.archetype]))
			{
				level.a_zombie_respawn_health[self.archetype] = [];
			}
			if(!isdefined(level.a_zombie_respawn_health[self.archetype]))
			{
				level.a_zombie_respawn_health[self.archetype] = [];
			}
			else if(!IsArray(level.a_zombie_respawn_health[self.archetype]))
			{
				level.a_zombie_respawn_health[self.archetype] = Array(level.a_zombie_respawn_health[self.archetype]);
			}
			level.a_zombie_respawn_health[self.archetype][level.a_zombie_respawn_health[self.archetype].size] = self.health;
		}
	}
	self zombie_utility::reset_attack_spot();
	if(!(isdefined(self.magic_bullet_shield) && self.magic_bullet_shield))
	{
		self kill();
		wait(0.05);
		if(isdefined(self))
		{
			/#
				debugstar(self.origin, 1000, (1, 1, 1));
			#/
			self delete();
		}
	}
}

/*
	Name: player_can_see_me
	Namespace: namespace_2d028ffb
	Checksum: 0x2A883C21
	Offset: 0xA40
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function player_can_see_me(player)
{
	v_player_angles = player getPlayerAngles();
	v_player_forward = AnglesToForward(v_player_angles);
	v_player_to_self = self.origin - player GetOrigin();
	v_player_to_self = VectorNormalize(v_player_to_self);
	n_dot = VectorDot(v_player_forward, v_player_to_self);
	if(n_dot < 0.766)
	{
		return 0;
	}
	return 1;
}

/*
	Name: player_ahead_of_me
	Namespace: namespace_2d028ffb
	Checksum: 0xE95A3161
	Offset: 0xB20
	Size: 0xB3
	Parameters: 1
	Flags: Private
*/
function private player_ahead_of_me(player)
{
	v_player_angles = player getPlayerAngles();
	v_player_forward = AnglesToForward(v_player_angles);
	v_dir = player GetOrigin() - self.origin;
	n_dot = VectorDot(v_player_forward, v_dir);
	if(n_dot < 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: get_adjacencies_to_zone
	Namespace: namespace_2d028ffb
	Checksum: 0x79BDDD68
	Offset: 0xBE0
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function get_adjacencies_to_zone(str_zone)
{
	a_adjacencies = [];
	a_adjacencies[0] = str_zone;
	a_adjacent_zones = getArrayKeys(level.zones[str_zone].adjacent_zones);
	for(i = 0; i < a_adjacent_zones.size; i++)
	{
		if(level.zones[str_zone].adjacent_zones[a_adjacent_zones[i]].is_connected)
		{
			if(!isdefined(a_adjacencies))
			{
				a_adjacencies = [];
			}
			else if(!IsArray(a_adjacencies))
			{
				a_adjacencies = Array(a_adjacencies);
			}
			a_adjacencies[a_adjacencies.size] = a_adjacent_zones[i];
		}
	}
	return a_adjacencies;
}

/*
	Name: no_target_override
	Namespace: namespace_2d028ffb
	Checksum: 0xAD2FFA60
	Offset: 0xD08
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function no_target_override(ai_zombie)
{
	if(isdefined(self.var_c74f5ce8) && self.var_c74f5ce8)
	{
		return;
	}
	var_b52b26b9 = ai_zombie get_escape_position();
	ai_zombie thread function_dc683d01(var_b52b26b9);
}

/*
	Name: get_escape_position
	Namespace: namespace_2d028ffb
	Checksum: 0xB67F6263
	Offset: 0xD78
	Size: 0x14D
	Parameters: 0
	Flags: Private
*/
function private get_escape_position()
{
	self endon("death");
	str_zone = zm_zonemgr::get_zone_from_position(self.origin + VectorScale((0, 0, 1), 32), 1);
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		a_zones = get_adjacencies_to_zone(str_zone);
		a_wait_locations = get_wait_locations_in_zones(a_zones);
		ArraySortClosest(a_wait_locations, self.origin);
		a_wait_locations = Array::reverse(a_wait_locations);
		for(i = 0; i < a_wait_locations.size; i++)
		{
			if(a_wait_locations[i] function_eadbcbdb())
			{
				return a_wait_locations[i].origin;
			}
		}
	}
	return self.origin;
}

/*
	Name: function_dc683d01
	Namespace: namespace_2d028ffb
	Checksum: 0x7A9B5BB9
	Offset: 0xED0
	Size: 0xC1
	Parameters: 1
	Flags: Private
*/
function private function_dc683d01(var_b52b26b9)
{
	self endon("death");
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self.ignoreall = 1;
	self.var_c74f5ce8 = 1;
	self thread check_player_available();
	self SetGoal(var_b52b26b9);
	self util::waittill_any_timeout(30, "goal", "reaquire_player");
	self.ai_state = "find_flesh";
	self.ignoreall = 0;
	self.var_c74f5ce8 = undefined;
}

/*
	Name: check_player_available
	Namespace: namespace_2d028ffb
	Checksum: 0xB322FBFA
	Offset: 0xFA0
	Size: 0x77
	Parameters: 0
	Flags: Private
*/
function private check_player_available()
{
	self endon("death");
	while(isdefined(self.var_c74f5ce8) && self.var_c74f5ce8)
	{
		wait(RandomFloatRange(0.2, 0.5));
		if(self can_zombie_see_any_player())
		{
			self.var_c74f5ce8 = undefined;
			self notify("reaquire_player");
			return;
		}
	}
}

/*
	Name: can_zombie_see_any_player
	Namespace: namespace_2d028ffb
	Checksum: 0x59AE8574
	Offset: 0x1020
	Size: 0xED
	Parameters: 0
	Flags: Private
*/
function private can_zombie_see_any_player()
{
	a_players = GetPlayers();
	for(i = 0; i < a_players.size; i++)
	{
		if(!zombie_utility::is_player_valid(a_players[i]) || (isdefined(a_players[i].ignoreme) && a_players[i].ignoreme))
		{
			continue;
		}
		if(self MayMoveToPoint(a_players[i].origin, 1))
		{
			return 1;
		}
	}
	if(isdefined(level.var_7c29c50e))
	{
		return self [[level.var_7c29c50e]]();
	}
	return 0;
}

/*
	Name: get_wait_locations_in_zones
	Namespace: namespace_2d028ffb
	Checksum: 0x14EA3943
	Offset: 0x1118
	Size: 0x11D
	Parameters: 1
	Flags: Private
*/
function private get_wait_locations_in_zones(a_zones)
{
	a_wait_locations = [];
	foreach(zone in a_zones)
	{
		if(isdefined(level.zones[zone].a_loc_types["wait_location"]))
		{
			a_wait_locations = ArrayCombine(a_wait_locations, level.zones[zone].a_loc_types["wait_location"], 0, 0);
			continue;
		}
		/#
			IPrintLnBold("Dev Block strings are not supported" + zone);
		#/
	}
	return a_wait_locations;
}

/*
	Name: function_eadbcbdb
	Namespace: namespace_2d028ffb
	Checksum: 0x4657CCB2
	Offset: 0x1240
	Size: 0x5D
	Parameters: 0
	Flags: Private
*/
function private function_eadbcbdb()
{
	if(!isdefined(self))
	{
		return 0;
	}
	if(!IsPointOnNavMesh(self.origin) || !zm_utility::check_point_in_playable_area(self.origin))
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

