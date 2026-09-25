#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_parasite;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod_idgun_quest;

#namespace zm_ai_wasp;

/*
	Name: init
	Namespace: zm_ai_wasp
	Checksum: 0x25027067
	Offset: 0x708
	Size: 0x2FB
	Parameters: 0
	Flags: None
*/
function init()
{
	level.wasp_enabled = 1;
	level.wasp_rounds_enabled = 0;
	level.wasp_round_count = 1;
	level.wasp_spawners = [];
	level.a_wasp_priority_targets = [];
	level flag::init("wasp_round");
	level flag::init("wasp_round_in_progress");
	level.melee_range_sav = GetDvarString("ai_meleeRange");
	level.melee_width_sav = GetDvarString("ai_meleeWidth");
	level.melee_height_sav = GetDvarString("ai_meleeHeight");
	if(!isdefined(level.vsmgr_prio_overlay_zm_wasp_round))
	{
		level.vsmgr_prio_overlay_zm_wasp_round = 22;
	}
	clientfield::register("toplayer", "parasite_round_fx", 1, 1, "counter");
	clientfield::register("toplayer", "parasite_round_ring_fx", 1, 1, "counter");
	clientfield::register("world", "toggle_on_parasite_fog", 1, 2, "int");
	visionset_mgr::register_info("visionset", "zm_wasp_round_visionset", 1, level.vsmgr_prio_overlay_zm_wasp_round, 31, 0, &visionset_mgr::ramp_in_out_thread, 0);
	level._effect["lightning_wasp_spawn"] = "zombie/fx_parasite_spawn_buildup_zod_zmb";
	callback::on_connect(&watch_player_melee_events);
	level thread AAT::register_immunity("zm_aat_blast_furnace", "parasite", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "parasite", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "parasite", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "parasite", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "parasite", 1, 1, 1);
	wasp_spawner_init();
}

/*
	Name: enable_wasp_rounds
	Namespace: zm_ai_wasp
	Checksum: 0x3AF4FD52
	Offset: 0xA10
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function enable_wasp_rounds()
{
	level.wasp_rounds_enabled = 1;
	if(!isdefined(level.wasp_round_track_override))
	{
		level.wasp_round_track_override = &wasp_round_tracker;
	}
	level thread [[level.wasp_round_track_override]]();
}

/*
	Name: wasp_spawner_init
	Namespace: zm_ai_wasp
	Checksum: 0x91EF11C5
	Offset: 0xA60
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function wasp_spawner_init()
{
	level.wasp_spawners = GetEntArray("zombie_wasp_spawner", "script_noteworthy");
	later_wasp = GetEntArray("later_round_wasp_spawners", "script_noteworthy");
	level.wasp_spawners = ArrayCombine(level.wasp_spawners, later_wasp, 1, 0);
	if(level.wasp_spawners.size == 0)
	{
		return;
	}
	for(i = 0; i < level.wasp_spawners.size; i++)
	{
		if(zm_spawner::is_spawner_targeted_by_blocker(level.wasp_spawners[i]))
		{
			level.wasp_spawners[i].is_enabled = 0;
			continue;
		}
		level.wasp_spawners[i].is_enabled = 1;
		level.wasp_spawners[i].script_forcespawn = 1;
	}
	/#
		Assert(level.wasp_spawners.size > 0);
	#/
	level.wasp_health = 100;
	vehicle::add_main_callback("spawner_bo3_parasite_enemy_tool", &wasp_init);
}

/*
	Name: get_current_wasp_count
	Namespace: zm_ai_wasp
	Checksum: 0x20A6146E
	Offset: 0xC08
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function get_current_wasp_count()
{
	Wasps = GetEntArray("zombie_wasp", "targetname");
	num_alive_wasps = Wasps.size;
	foreach(wasp in Wasps)
	{
		if(!isalive(wasp))
		{
			num_alive_wasps--;
		}
	}
	return num_alive_wasps;
}

/*
	Name: wasp_round_spawning
	Namespace: zm_ai_wasp
	Checksum: 0xAEA5A0B
	Offset: 0xCE8
	Size: 0x38F
	Parameters: 0
	Flags: None
*/
function wasp_round_spawning()
{
	level endon("intermission");
	level endon("wasp_round");
	level.wasp_targets = level.players;
	for(i = 0; i < level.wasp_targets.size; i++)
	{
		level.wasp_targets[i].hunted_by = 0;
	}
	level endon("restart_round");
	level endon("kill_round");
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 2 || GetDvarInt("Dev Block strings are not supported") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	Array::thread_all(level.players, &play_wasp_round);
	n_wave_count = 10;
	if(level.players.size > 1)
	{
		n_wave_count = n_wave_count * level.players.size * 0.75;
	}
	wasp_health_increase();
	level.zombie_total = Int(n_wave_count * 1);
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported" && GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level.zombie_total = GetDvarInt("Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", 0);
		}
	#/
	wait(1);
	parasite_round_fx();
	visionset_mgr::activate("visionset", "zm_wasp_round_visionset", undefined, 1.5, 1.5, 2);
	level clientfield::set("toggle_on_parasite_fog", 1);
	playsoundatposition("vox_zmba_event_waspstart_0", (0, 0, 0));
	wait(6);
	n_wasps_alive = 0;
	level flag::set("wasp_round_in_progress");
	level endon("last_ai_down");
	level thread wasp_round_aftermath();
	while(1)
	{
		while(level.zombie_total > 0)
		{
			if(isdefined(level.bzm_worldPaused) && level.bzm_worldPaused)
			{
				util::wait_network_frame();
				continue;
			}
			if(isdefined(level.zm_mixed_wasp_raps_spawning))
			{
				[[level.zm_mixed_wasp_raps_spawning]]();
			}
			else
			{
				spawn_wasp();
			}
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: spawn_wasp
	Namespace: zm_ai_wasp
	Checksum: 0xDE38381D
	Offset: 0x1080
	Size: 0x55F
	Parameters: 0
	Flags: None
*/
function spawn_wasp()
{
	b_swarm_spawned = 0;
	while(!b_swarm_spawned)
	{
		while(!ready_to_spawn_wasp())
		{
			wait(1);
		}
		spawn_point = undefined;
		while(!isdefined(spawn_point))
		{
			favorite_enemy = get_favorite_enemy();
			spawn_enemy = favorite_enemy;
			if(!isdefined(spawn_enemy))
			{
				spawn_enemy = GetPlayers()[0];
			}
			if(isdefined(level.wasp_spawn_func))
			{
				spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
			}
			else
			{
				spawn_point = wasp_spawn_logic(spawn_enemy);
			}
			if(!isdefined(spawn_point))
			{
				wait(RandomFloatRange(0.6666666, 1.333333));
			}
		}
		v_spawn_origin = spawn_point.origin;
		v_ground = bullettrace(spawn_point.origin + VectorScale((0, 0, 1), 60), spawn_point.origin + VectorScale((0, 0, 1), 60) + VectorScale((0, 0, -1), 100000), 0, undefined)["position"];
		if(DistanceSquared(v_ground, spawn_point.origin) < 3600)
		{
			v_spawn_origin = v_ground + VectorScale((0, 0, 1), 60);
		}
		queryResult = PositionQuery_Source_Navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
		a_points = Array::randomize(queryResult.data);
		a_spawn_origins = [];
		n_points_found = 0;
		foreach(point in a_points)
		{
			if(BulletTracePassed(point.origin, spawn_point.origin, 0, spawn_enemy))
			{
				if(!isdefined(a_spawn_origins))
				{
					a_spawn_origins = [];
				}
				else if(!IsArray(a_spawn_origins))
				{
					a_spawn_origins = Array(a_spawn_origins);
				}
				a_spawn_origins[a_spawn_origins.size] = point.origin;
				n_points_found++;
				if(n_points_found >= 1)
				{
					break;
				}
			}
		}
		if(a_spawn_origins.size >= 1)
		{
			n_spawn = 0;
			while(n_spawn < 1 && level.zombie_total > 0)
			{
				for(i = a_spawn_origins.size - 1; i >= 0; i--)
				{
					v_origin = a_spawn_origins[i];
					level.wasp_spawners[0].origin = v_origin;
					ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
					if(isdefined(ai))
					{
						ai parasite::set_parasite_enemy(favorite_enemy);
						level thread wasp_spawn_init(ai, v_origin);
						ArrayRemoveIndex(a_spawn_origins, i);
						if(isdefined(level.zm_wasp_spawn_callback))
						{
							ai thread [[level.zm_wasp_spawn_callback]]();
						}
						n_spawn++;
						level.zombie_total--;
						wait(RandomFloatRange(0.06666666, 0.1333333));
						break;
					}
					wait(RandomFloatRange(0.06666666, 0.1333333));
				}
			}
			b_swarm_spawned = 1;
		}
		util::wait_network_frame();
	}
}

/*
	Name: parasite_round_fx
	Namespace: zm_ai_wasp
	Checksum: 0x29CB2F2C
	Offset: 0x15E8
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function parasite_round_fx()
{
	foreach(player in level.players)
	{
		player clientfield::increment_to_player("parasite_round_fx");
		player clientfield::increment_to_player("parasite_round_ring_fx");
	}
}

/*
	Name: show_hit_marker
	Namespace: zm_ai_wasp
	Checksum: 0xCED6635
	Offset: 0x16A8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: waspDamage
	Namespace: zm_ai_wasp
	Checksum: 0x8C5C2DCB
	Offset: 0x1738
	Size: 0x87
	Parameters: 12
	Flags: None
*/
function waspDamage(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(isdefined(attacker))
	{
		attacker show_hit_marker();
	}
	return damage;
}

/*
	Name: ready_to_spawn_wasp
	Namespace: zm_ai_wasp
	Checksum: 0xB5770994
	Offset: 0x17C8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function ready_to_spawn_wasp()
{
	n_wasps_alive = get_current_wasp_count();
	b_wasp_count_at_max = n_wasps_alive >= 16;
	b_wasp_count_per_player_at_max = n_wasps_alive >= level.players.size * 5;
	if(b_wasp_count_at_max || b_wasp_count_per_player_at_max || !level flag::get("spawn_zombies"))
	{
		return 0;
	}
	return 1;
}

/*
	Name: wasp_round_aftermath
	Namespace: zm_ai_wasp
	Checksum: 0xD9A4F3AA
	Offset: 0x1860
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function wasp_round_aftermath()
{
	level waittill("last_ai_down", e_wasp);
	level thread zm_audio::sndMusicSystem_PlayState("parasite_over");
	if(isdefined(level.zm_override_ai_aftermath_powerup_drop))
	{
		[[level.zm_override_ai_aftermath_powerup_drop]](e_wasp, level.last_ai_origin);
	}
	else if(isdefined(level.last_ai_origin))
	{
		enemy = e_wasp.favoriteenemy;
		if(!isdefined(enemy))
		{
			enemy = Array::random(level.players);
		}
		enemy parasite_drop_item(level.last_ai_origin);
	}
	wait(2);
	level clientfield::set("toggle_on_parasite_fog", 2);
	level.sndMusicSpecialRound = 0;
	wait(6);
	level flag::clear("wasp_round_in_progress");
}

/*
	Name: parasite_drop_item
	Namespace: zm_ai_wasp
	Checksum: 0x3C5A9E1A
	Offset: 0x1998
	Size: 0x38B
	Parameters: 1
	Flags: None
*/
function parasite_drop_item(v_parasite_origin)
{
	if(!zm_utility::check_point_in_enabled_zone(v_parasite_origin, 1, level.active_zones))
	{
		e_parasite_drop = level zm_powerups::specific_powerup_drop("full_ammo", v_parasite_origin);
		current_zone = self zm_utility::get_current_zone();
		if(isdefined(current_zone))
		{
			v_start = e_parasite_drop.origin;
			e_closest_player = ArrayGetClosest(v_start, level.activePlayers);
			if(isdefined(e_closest_player))
			{
				v_target = e_closest_player.origin + (0, 0, 20);
				n_distance_to_target = Distance(v_start, v_target);
				v_dir = VectorNormalize(v_target - v_start);
				n_step = 50;
				n_distance_moved = 0;
				v_position = v_start;
				while(n_distance_moved <= n_distance_to_target)
				{
					v_position = v_position + v_dir * n_step;
					if(zm_utility::check_point_in_enabled_zone(v_position, 1, level.active_zones))
					{
						n_height_diff = Abs(v_target[2] - v_position[2]);
						if(n_height_diff < 60)
						{
							break;
						}
					}
					n_distance_moved = n_distance_moved + n_step;
				}
				trace = bullettrace(v_position, v_position + VectorScale((0, 0, -1), 256), 0, undefined);
				v_ground_position = trace["position"];
				if(isdefined(v_ground_position))
				{
					v_position = (v_position[0], v_position[1], v_ground_position[2] + 20);
				}
				n_flight_time = Distance(v_start, v_position) / 100;
				if(n_flight_time > 4)
				{
					n_flight_time = 4;
				}
				e_parasite_drop moveto(v_position, n_flight_time);
			}
			else
			{
				v_nav_check = GetClosestPointOnNavMesh(e_parasite_drop.origin, 2000, 32);
			}
		}
	}
	else
	{
		level zm_powerups::specific_powerup_drop("full_ammo", GetClosestPointOnNavMesh(v_parasite_origin, 1000, 30));
	}
}

/*
	Name: wasp_spawn_init
	Namespace: zm_ai_wasp
	Checksum: 0x91120360
	Offset: 0x1D30
	Size: 0x293
	Parameters: 3
	Flags: None
*/
function wasp_spawn_init(ai, origin, should_spawn_fx)
{
	if(!isdefined(should_spawn_fx))
	{
		should_spawn_fx = 1;
	}
	ai endon("death");
	ai SetInvisibleToAll();
	if(isdefined(origin))
	{
		v_origin = origin;
	}
	else
	{
		v_origin = ai.origin;
	}
	if(should_spawn_fx)
	{
		playFX(level._effect["lightning_wasp_spawn"], v_origin);
	}
	wait(1.5);
	Earthquake(0.3, 0.5, v_origin, 256);
	if(isdefined(ai.favoriteenemy))
	{
		angle = VectorToAngles(ai.favoriteenemy.origin - v_origin);
	}
	else
	{
		angle = ai.angles;
	}
	angles = (ai.angles[0], angle[1], ai.angles[2]);
	ai.origin = v_origin;
	ai.angles = angles;
	/#
		Assert(isdefined(ai), "Dev Block strings are not supported");
	#/
	/#
		Assert(isalive(ai), "Dev Block strings are not supported");
	#/
	ai thread zombie_setup_attack_properties_wasp();
	if(isdefined(level._wasp_death_cb))
	{
		ai callback::add_callback("hash_acb66515", level._wasp_death_cb);
	}
	ai SetVisibleToAll();
	ai.ignoreme = 0;
	ai notify("visible");
}

/*
	Name: create_global_wasp_spawn_locations_list
	Namespace: zm_ai_wasp
	Checksum: 0x2571F410
	Offset: 0x1FD0
	Size: 0x179
	Parameters: 0
	Flags: None
*/
function create_global_wasp_spawn_locations_list()
{
	if(!isdefined(level.enemy_wasp_global_locations))
	{
		level.enemy_wasp_global_locations = [];
		keys = getArrayKeys(level.zones);
		for(i = 0; i < keys.size; i++)
		{
			zone = level.zones[keys[i]];
			foreach(loc in zone.a_locs["wasp_location"])
			{
				if(!isdefined(level.enemy_wasp_global_locations))
				{
					level.enemy_wasp_global_locations = [];
				}
				else if(!IsArray(level.enemy_wasp_global_locations))
				{
					level.enemy_wasp_global_locations = Array(level.enemy_wasp_global_locations);
				}
				level.enemy_wasp_global_locations[level.enemy_wasp_global_locations.size] = loc;
			}
		}
	}
}

/*
	Name: wasp_find_closest_in_global_pool
	Namespace: zm_ai_wasp
	Checksum: 0x4CC4F14F
	Offset: 0x2158
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function wasp_find_closest_in_global_pool(favorite_enemy)
{
	index_to_use = 0;
	closest_distance_squared = DistanceSquared(level.enemy_wasp_global_locations[index_to_use].origin, favorite_enemy.origin);
	for(i = 0; i < level.enemy_wasp_global_locations.size; i++)
	{
		if(level.enemy_wasp_global_locations[i].is_enabled)
		{
			dist_squared = DistanceSquared(level.enemy_wasp_global_locations[i].origin, favorite_enemy.origin);
			if(dist_squared < closest_distance_squared)
			{
				index_to_use = i;
				closest_distance_squared = dist_squared;
			}
		}
	}
	return level.enemy_wasp_global_locations[index_to_use];
}

/*
	Name: wasp_spawn_logic
	Namespace: zm_ai_wasp
	Checksum: 0x80244FA0
	Offset: 0x2278
	Size: 0x397
	Parameters: 1
	Flags: None
*/
function wasp_spawn_logic(favorite_enemy)
{
	if(!GetDvarInt("zm_wasp_open_spawning", 0))
	{
		wasp_locs = level.zm_loc_types["wasp_location"];
		if(wasp_locs.size == 0)
		{
			create_global_wasp_spawn_locations_list();
			return wasp_find_closest_in_global_pool(favorite_enemy);
		}
		if(isdefined(level.old_wasp_spawn))
		{
			dist_squared = DistanceSquared(level.old_wasp_spawn.origin, favorite_enemy.origin);
			if(dist_squared > 160000 && dist_squared < 360000)
			{
				return level.old_wasp_spawn;
			}
		}
		foreach(loc in wasp_locs)
		{
			dist_squared = DistanceSquared(loc.origin, favorite_enemy.origin);
			if(dist_squared > 160000 && dist_squared < 360000)
			{
				level.old_wasp_spawn = loc;
				return loc;
			}
		}
	}
	switch(level.players.size)
	{
		case 4:
		{
			spawn_dist_max = 600;
			break;
		}
		case 3:
		{
			spawn_dist_max = 700;
			break;
		}
		case 2:
		{
			spawn_dist_max = 900;
			break;
		}
		case 1:
		case default:
		{
			spawn_dist_max = 1200;
			break;
		}
	}
	queryResult = PositionQuery_Source_Navigation(favorite_enemy.origin + (0, 0, randomIntRange(40, 100)), 300, spawn_dist_max, 10, 10, "navvolume_small");
	a_points = Array::randomize(queryResult.data);
	foreach(point in a_points)
	{
		if(BulletTracePassed(point.origin, favorite_enemy.origin, 0, favorite_enemy))
		{
			level.old_wasp_spawn = point;
			return point;
		}
	}
	return a_points[0];
}

/*
	Name: get_favorite_enemy
	Namespace: zm_ai_wasp
	Checksum: 0x582BFE2E
	Offset: 0x2618
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function get_favorite_enemy()
{
	if(level.a_wasp_priority_targets.size > 0)
	{
		e_enemy = level.a_wasp_priority_targets[0];
		if(isdefined(e_enemy))
		{
			ArrayRemoveValue(level.a_wasp_priority_targets, e_enemy);
			return e_enemy;
		}
	}
	if(isdefined(level.fn_custom_wasp_favourate_enemy))
	{
		e_enemy = [[level.fn_custom_wasp_favourate_enemy]]();
		return e_enemy;
	}
	target = parasite::get_parasite_enemy();
	return target;
}

/*
	Name: wasp_health_increase
	Namespace: zm_ai_wasp
	Checksum: 0xE4AE1203
	Offset: 0x26C8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function wasp_health_increase()
{
	players = GetPlayers();
	level.wasp_health = level.round_number * 50;
	if(level.wasp_health > 1600)
	{
		level.wasp_health = 1600;
	}
}

/*
	Name: wasp_round_wait_func
	Namespace: zm_ai_wasp
	Checksum: 0xA3F839EF
	Offset: 0x2720
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function wasp_round_wait_func()
{
	level endon("restart_round");
	level endon("kill_round");
	if(level flag::get("wasp_round"))
	{
		level flag::wait_till("wasp_round_in_progress");
		level flag::wait_till_clear("wasp_round_in_progress");
	}
}

/*
	Name: wasp_round_tracker
	Namespace: zm_ai_wasp
	Checksum: 0x5181C307
	Offset: 0x27A0
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function wasp_round_tracker()
{
	level.wasp_round_count = 1;
	level.next_wasp_round = level.round_number + randomIntRange(4, 6);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(1)
	{
		level waittill("between_round_over");
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				level.next_wasp_round = level.round_number;
			}
		#/
		if(level.round_number == level.next_wasp_round)
		{
			level.sndMusicSpecialRound = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			wasp_round_start();
			level.round_spawn_func = &wasp_round_spawning;
			level.round_wait_func = &wasp_round_wait_func;
			if(isdefined(level.zm_custom_get_next_wasp_round))
			{
				level.next_wasp_round = [[level.zm_custom_get_next_wasp_round]]();
			}
			else
			{
				level.next_wasp_round = 5 + level.wasp_round_count * 10 + randomIntRange(-1, 1);
			}
			/#
				GetPlayers()[0] iprintln("Dev Block strings are not supported" + level.next_wasp_round);
			#/
		}
		else if(level flag::get("wasp_round"))
		{
			wasp_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.wasp_round_count = level.wasp_round_count + 1;
		}
	}
}

/*
	Name: wasp_round_start
	Namespace: zm_ai_wasp
	Checksum: 0x7B7E6D9C
	Offset: 0x29D8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function wasp_round_start()
{
	level flag::set("wasp_round");
	level flag::set("special_round");
	if(!isdefined(level.waspround_nomusic))
	{
		level.waspround_nomusic = 0;
	}
	level.waspround_nomusic = 1;
	level notify("wasp_round_starting");
	level thread zm_audio::sndMusicSystem_PlayState("parasite_start");
	if(isdefined(level.wasp_melee_range))
	{
		SetDvar("ai_meleeRange", level.wasp_melee_range);
	}
	else
	{
		SetDvar("ai_meleeRange", 100);
	}
}

/*
	Name: wasp_round_stop
	Namespace: zm_ai_wasp
	Checksum: 0x70247676
	Offset: 0x2AC8
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function wasp_round_stop()
{
	level flag::clear("wasp_round");
	level flag::clear("special_round");
	if(!isdefined(level.waspround_nomusic))
	{
		level.waspround_nomusic = 0;
	}
	level.waspround_nomusic = 0;
	level notify("wasp_round_ending");
	SetDvar("ai_meleeRange", level.melee_range_sav);
	SetDvar("ai_meleeWidth", level.melee_width_sav);
	SetDvar("ai_meleeHeight", level.melee_height_sav);
}

/*
	Name: play_wasp_round
	Namespace: zm_ai_wasp
	Checksum: 0x918D379C
	Offset: 0x2BA8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function play_wasp_round()
{
	self playlocalsound("zmb_wasp_round_start");
	variation_count = 5;
	wait(4.5);
	players = GetPlayers();
	num = randomIntRange(0, players.size);
	players[num] zm_audio::create_and_play_dialog("general", "wasp_spawn");
}

/*
	Name: wasp_init
	Namespace: zm_ai_wasp
	Checksum: 0x17699E32
	Offset: 0x2C68
	Size: 0x3FF
	Parameters: 0
	Flags: None
*/
function wasp_init()
{
	self.targetname = "zombie_wasp";
	self.script_noteworthy = undefined;
	self.animName = "zombie_wasp";
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.allowdeath = 1;
	self.allowPain = 0;
	self.no_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
	self.no_eye_glow = 1;
	self.lightning_chain_immune = 1;
	self.holdFire = 0;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = 1;
	self.suppressionThreshold = 1;
	self.noDodgeMove = 1;
	self.dontShootWhileMoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatInitialized = 0;
	self.missingLegs = 0;
	self.isdog = 0;
	self.teslafxtag = "tag_origin";
	self.grapple_type = 2;
	self SetGrapplableType(self.grapple_type);
	self.team = level.zombie_team;
	self.sword_kill_power = 2;
	parasite::parasite_initialize();
	health_multiplier = 1;
	if(GetDvarString("scr_wasp_health_walk_multiplier") != "")
	{
		health_multiplier = GetDvarFloat("scr_wasp_health_walk_multiplier");
	}
	self.maxhealth = Int(level.wasp_health * health_multiplier);
	if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
	{
		self.health = level.a_zombie_respawn_health[self.archetype][0];
		ArrayRemoveValue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
	}
	else
	{
		self.health = Int(level.wasp_health * health_multiplier);
	}
	self thread wasp_run_think();
	self thread watch_player_melee();
	self SetInvisibleToAll();
	self thread wasp_death();
	self thread wasp_cleanup_failsafe();
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	self.thundergun_knockdown_func = &wasp_thundergun_knockdown;
	self zm_spawner::zombie_history("zombie_wasp_spawn_init -> Spawned = " + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self [[level.achievement_monitor_func]]();
	}
}

/*
	Name: wasp_thundergun_knockdown
	Namespace: zm_ai_wasp
	Checksum: 0x131B23B9
	Offset: 0x3070
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function wasp_thundergun_knockdown(e_player, gib)
{
	self endon("death");
	n_damage = Int(self.maxhealth * 0.5);
	self DoDamage(n_damage, self.origin, e_player);
}

/*
	Name: wasp_cleanup_failsafe
	Namespace: zm_ai_wasp
	Checksum: 0x7E0BC6A2
	Offset: 0x30F0
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function wasp_cleanup_failsafe()
{
	self endon("death");
	n_wasp_created_time = GetTime();
	n_check_time = n_wasp_created_time;
	v_check_position = self.origin;
	while(1)
	{
		n_current_time = GetTime();
		if(isdefined(level.bzm_worldPaused) && level.bzm_worldPaused)
		{
			n_check_time = n_current_time;
			wait(1);
			continue;
		}
		n_dist = Distance(v_check_position, self.origin);
		if(n_dist > 100)
		{
			n_check_time = n_current_time;
			v_check_position = self.origin;
		}
		else
		{
			n_delta_time = n_current_time - n_check_time / 1000;
			if(n_delta_time >= 20)
			{
				break;
			}
		}
		n_delta_time = n_current_time - n_wasp_created_time / 1000;
		if(n_delta_time >= 150)
		{
			break;
		}
		wait(1);
	}
	self DoDamage(self.health + 100, self.origin);
}

/*
	Name: wasp_death
	Namespace: zm_ai_wasp
	Checksum: 0xB8BA0F2B
	Offset: 0x3260
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function wasp_death()
{
	self waittill("death", attacker);
	if(get_current_wasp_count() == 0 && level.zombie_total == 0)
	{
		if(!isdefined(level.zm_ai_round_over) || [[level.zm_ai_round_over]]())
		{
			level.last_ai_origin = self.origin;
			level notify("last_ai_down", self);
		}
	}
	if(isPlayer(attacker))
	{
		if(isdefined(attacker.on_train) && attacker.on_train)
		{
			attacker notify("wasp_train_kill");
		}
		attacker zm_score::player_add_points("death_wasp", 70);
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](attacker, self);
		}
		if(randomIntRange(0, 100) >= 80)
		{
			attacker zm_audio::create_and_play_dialog("kill", "hellhound");
		}
		attacker zm_stats::increment_client_stat("zwasp_killed");
		attacker zm_stats::increment_player_stat("zwasp_killed");
	}
	if(isdefined(attacker) && isai(attacker))
	{
		attacker notify("killed", self);
	}
	self StopLoopSound();
}

/*
	Name: zombie_setup_attack_properties_wasp
	Namespace: zm_ai_wasp
	Checksum: 0x5AF9698F
	Offset: 0x3450
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function zombie_setup_attack_properties_wasp()
{
	self zm_spawner::zombie_history("zombie_setup_attack_properties()");
	self thread wasp_behind_audio();
	self.ignoreall = 0;
	self.meleeAttackDist = 64;
	self.disableArrivals = 1;
	self.disableExits = 1;
	if(level.wasp_round_count == 2)
	{
		self ai::set_behavior_attribute("firing_rate", "medium");
	}
	else if(level.wasp_round_count > 2)
	{
		self ai::set_behavior_attribute("firing_rate", "fast");
	}
}

/*
	Name: stop_wasp_sound_on_death
	Namespace: zm_ai_wasp
	Checksum: 0x701EEDF6
	Offset: 0x3538
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function stop_wasp_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

/*
	Name: wasp_behind_audio
	Namespace: zm_ai_wasp
	Checksum: 0x85DD8D48
	Offset: 0x3568
	Size: 0x1AF
	Parameters: 0
	Flags: None
*/
function wasp_behind_audio()
{
	self thread stop_wasp_sound_on_death();
	self endon("death");
	self util::waittill_any("wasp_running", "wasp_combat");
	wait(3);
	while(1)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			waspAngle = AngleClamp180(VectorToAngles(self.origin - players[i].origin)[1] - players[i].angles[1]);
			if(isalive(players[i]) && !isdefined(players[i].reviveTrigger))
			{
				if(Abs(waspAngle) > 90 && Distance2D(self.origin, players[i].origin) > 100)
				{
					wait(3);
				}
			}
		}
		wait(0.75);
	}
}

/*
	Name: special_wasp_spawn
	Namespace: zm_ai_wasp
	Checksum: 0x22F50D56
	Offset: 0x3720
	Size: 0x393
	Parameters: 8
	Flags: None
*/
function special_wasp_spawn(n_to_spawn, spawn_point, n_radius, n_half_height, b_non_round, spawn_fx, b_return_ai, spawner_override)
{
	if(!isdefined(n_to_spawn))
	{
		n_to_spawn = 1;
	}
	if(!isdefined(n_radius))
	{
		n_radius = 32;
	}
	if(!isdefined(n_half_height))
	{
		n_half_height = 32;
	}
	if(!isdefined(spawn_fx))
	{
		spawn_fx = 1;
	}
	if(!isdefined(b_return_ai))
	{
		b_return_ai = 0;
	}
	if(!isdefined(spawner_override))
	{
		spawner_override = undefined;
	}
	wasp = GetEntArray("zombie_wasp", "targetname");
	if(isdefined(wasp) && wasp.size >= 9)
	{
		return 0;
	}
	count = 0;
	while(count < n_to_spawn)
	{
		players = GetPlayers();
		favorite_enemy = get_favorite_enemy();
		spawn_enemy = favorite_enemy;
		if(!isdefined(spawn_enemy))
		{
			spawn_enemy = players[0];
		}
		if(isdefined(level.wasp_spawn_func))
		{
			spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
		}
		while(!isdefined(spawn_point))
		{
			if(!isdefined(spawn_point))
			{
				spawn_point = wasp_spawn_logic(spawn_enemy);
			}
			if(isdefined(spawn_point))
			{
				break;
			}
			wait(0.05);
		}
		spawner = level.wasp_spawners[0];
		if(isdefined(spawner_override))
		{
			spawner = spawner_override;
		}
		ai = zombie_utility::spawn_zombie(spawner);
		v_spawn_origin = spawn_point.origin;
		if(isdefined(ai))
		{
			queryResult = PositionQuery_Source_Navigation(v_spawn_origin, 0, n_radius, n_half_height, 15, "navvolume_small");
			if(queryResult.data.size)
			{
				point = queryResult.data[RandomInt(queryResult.data.size)];
				v_spawn_origin = point.origin;
			}
			ai parasite::set_parasite_enemy(favorite_enemy);
			ai.does_not_count_to_round = b_non_round;
			level thread wasp_spawn_init(ai, v_spawn_origin, spawn_fx);
			count++;
		}
		wait(level.zombie_vars["zombie_spawn_delay"]);
	}
	if(b_return_ai)
	{
		return ai;
	}
	return 1;
}

/*
	Name: wasp_run_think
	Namespace: zm_ai_wasp
	Checksum: 0x294D19E6
	Offset: 0x3AC0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function wasp_run_think()
{
	self endon("death");
	self waittill("visible");
	if(self.health > level.wasp_health)
	{
		self.maxhealth = level.wasp_health;
		self.health = level.wasp_health;
	}
	while(1)
	{
		wait(0.2);
	}
}

/*
	Name: watch_player_melee
	Namespace: zm_ai_wasp
	Checksum: 0xCE9384DF
	Offset: 0x3B50
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function watch_player_melee()
{
	self endon("death");
	self waittill("visible");
	while(isdefined(self))
	{
		level waittill("player_melee", player, weapon);
		peye = player GetEye();
		dist2 = Distance2DSquared(peye, self.origin);
		if(dist2 > 5184)
		{
			continue;
		}
		if(Abs(peye[2] - self.origin[2]) > 64)
		{
			continue;
		}
		pfwd = player GetWeaponForwardDir();
		tome = self.origin - peye;
		tome = VectorNormalize(tome);
		dot = VectorDot(pfwd, tome);
		if(dot < 0.5)
		{
			continue;
		}
		damage = 150;
		if(isdefined(weapon))
		{
			damage = weapon.meleeDamage;
		}
		self DoDamage(damage, peye, player, player, "none", "MOD_MELEE", 0, weapon);
	}
}

/*
	Name: watch_player_melee_events
	Namespace: zm_ai_wasp
	Checksum: 0xCA68BE58
	Offset: 0x3D30
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function watch_player_melee_events()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("weapon_melee", weapon);
		level notify("player_melee", self, weapon);
	}
}

/*
	Name: wasp_stalk_audio
	Namespace: zm_ai_wasp
	Checksum: 0xEBCBC968
	Offset: 0x3D78
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function wasp_stalk_audio()
{
	self endon("death");
	self endon("wasp_running");
	self endon("wasp_combat");
	while(1)
	{
		wait(RandomFloatRange(3, 6));
	}
}

/*
	Name: wasp_add_to_spawn_pool
	Namespace: zm_ai_wasp
	Checksum: 0x3BDF36FB
	Offset: 0x3DD0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function wasp_add_to_spawn_pool(optional_player_target)
{
	if(isdefined(optional_player_target))
	{
		Array::add(level.a_wasp_priority_targets, optional_player_target);
	}
	level.zombie_total++;
}

