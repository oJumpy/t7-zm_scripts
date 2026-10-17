#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_sentinel_drone;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;

#namespace namespace_8bc21961;

/*
	Name: __init__sytem__
	Namespace: namespace_8bc21961
	Checksum: 0x3CE44D05
	Offset: 0x808
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_sentinel_drone", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8bc21961
	Checksum: 0x1871FEE4
	Offset: 0x850
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_8a3cc09a = 1;
	level.var_fef7211a = 0;
	level.var_e476eac3 = 0;
	level.var_d6d4b6f9 = 2500;
	zm_score::register_score_event("death_sentinel", &function_c35ddec4);
	level flag::init("sentinel_round");
	level flag::init("sentinel_round_in_progress");
	level flag::init("sentinel_rez_in_progress");
	register_clientfields();
	level thread AAT::register_immunity("zm_aat_blast_furnace", "sentinel_drone", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "sentinel_drone", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "sentinel_drone", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "sentinel_drone", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "sentinel_drone", 1, 1, 1);
	sentinel_spawner_init();
}

/*
	Name: __main__
	Namespace: namespace_8bc21961
	Checksum: 0xD58066
	Offset: 0xA28
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
		execdevgui("Dev Block strings are not supported");
		thread function_5715a7cc();
	#/
	visionset_mgr::register_info("visionset", "zm_sentinel_round_visionset", 12000, 22, 31, 0, &visionset_mgr::ramp_in_out_thread, 0);
}

/*
	Name: register_clientfields
	Namespace: namespace_8bc21961
	Checksum: 0xD0CCCF09
	Offset: 0xAA0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("world", "sentinel_round_fog", 12000, 1, "int");
	clientfield::register("toplayer", "sentinel_round_fx", 12000, 1, "int");
	clientfield::register("vehicle", "necro_sentinel_fx", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_spawn_fx", 12000, 1, "int");
	clientfield::register("actor", "sentinel_zombie_spawn_fx", 12000, 1, "int");
}

/*
	Name: function_c35ddec4
	Namespace: namespace_8bc21961
	Checksum: 0xDE989A3E
	Offset: 0xBA0
	Size: 0x63
	Parameters: 5
	Flags: None
*/
function function_c35ddec4(str_event, str_mod, str_hit_location, var_48d0b2fe, w_damage_weapon)
{
	if(str_event === "death_sentinel")
	{
		scoreevents::processScoreEvent("kill_sentinel", self, undefined, w_damage_weapon);
		return 100;
	}
	return 0;
}

/*
	Name: enable_sentinel_rounds
	Namespace: namespace_8bc21961
	Checksum: 0xBE5500D1
	Offset: 0xC10
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function enable_sentinel_rounds()
{
	level.var_fef7211a = 1;
	level.var_35078afd = 0;
	level.var_a657e360 = spawnstruct();
	level.var_a657e360.origin = (0, 0, 0);
	level.var_a657e360.angles = (0, 0, 0);
	level.var_a657e360.script_noteworthy = "riser_location";
	level.var_a657e360.script_string = "find_flesh";
	if(!isdefined(level.var_c7979e0a))
	{
		level.var_c7979e0a = &function_e38b964d;
	}
	level thread [[level.var_c7979e0a]]();
}

/*
	Name: sentinel_spawner_init
	Namespace: namespace_8bc21961
	Checksum: 0x95C3AEF5
	Offset: 0xCD8
	Size: 0x179
	Parameters: 0
	Flags: None
*/
function sentinel_spawner_init()
{
	level.var_fda4b3f3 = GetSpawnerArray("zombie_sentinel_spawner", "script_noteworthy");
	level.var_34fd66c3 = GetSpawnerArray("zombie_sentinel_zombie_spawner", "script_noteworthy");
	Array::thread_all(level.var_34fd66c3, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	if(level.var_fda4b3f3.size == 0)
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	foreach(sp_sentinel in level.var_fda4b3f3)
	{
		sp_sentinel.is_enabled = 1;
		sp_sentinel.script_forcespawn = 1;
		sp_sentinel spawner::add_spawn_function(&function_3b40bf32);
	}
}

/*
	Name: function_e38b964d
	Namespace: namespace_8bc21961
	Checksum: 0xC031B788
	Offset: 0xE60
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function function_e38b964d()
{
	if(level.players.size == 1)
	{
		level.var_a78effc7 = randomIntRange(12, 16);
	}
	else
	{
		level.var_a78effc7 = randomIntRange(9, 12);
	}
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(1)
	{
		level waittill("between_round_over");
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				level.var_a78effc7 = level.round_number;
			}
		#/
		if(level.round_number == level.var_a78effc7)
		{
			level.sndMusicSpecialRound = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			sentinel_round_start();
			level.round_spawn_func = &sentinel_round_spawning;
			level.round_wait_func = &sentinel_round_wait_func;
			if(isdefined(level.zm_custom_get_next_sentinel_round))
			{
				level.var_a78effc7 = [[level.zm_custom_get_next_sentinel_round]]();
			}
			else
			{
				level.var_a78effc7 = level.var_a78effc7 + randomIntRange(7, 10);
			}
			/#
				level.players[0] iprintln("Dev Block strings are not supported" + level.var_a78effc7);
			#/
		}
		else if(level flag::get("sentinel_round"))
		{
			sentinel_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
		}
	}
}

/*
	Name: sentinel_round_start
	Namespace: namespace_8bc21961
	Checksum: 0xE457A466
	Offset: 0x1090
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function sentinel_round_start()
{
	level flag::set("sentinel_round");
	level flag::set("special_round");
	level.var_35078afd++;
	level.var_e476eac3 = 1;
	level notify("sentinel_round_starting");
	level thread zm_audio::sndMusicSystem_PlayState("sentinel_roundstart");
	level.var_a61a9af4 = GetDvarInt("Sentinel_Move_Speed");
	SetDvar("Sentinel_Move_Speed", 5);
}

/*
	Name: sentinel_round_stop
	Namespace: namespace_8bc21961
	Checksum: 0x4039BE20
	Offset: 0x1160
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function sentinel_round_stop()
{
	level flag::clear("sentinel_round");
	level flag::clear("special_round");
	SetDvar("Sentinel_Move_Speed", level.var_a61a9af4);
	level.var_e476eac3 = 0;
	level notify("hash_d32683ce");
}

/*
	Name: sentinel_round_spawning
	Namespace: namespace_8bc21961
	Checksum: 0xF325E9E3
	Offset: 0x11E8
	Size: 0x33F
	Parameters: 0
	Flags: None
*/
function sentinel_round_spawning()
{
	level endon("intermission");
	level endon("hash_bc0aaf7c");
	level.var_6693a532 = GetPlayers();
	for(i = 0; i < level.var_6693a532.size; i++)
	{
		level.var_6693a532[i].hunted_by = 0;
	}
	level endon("restart_round");
	/#
		level endon("kill_round");
		if(GetDvarInt("Dev Block strings are not supported") == 2 || GetDvarInt("Dev Block strings are not supported") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	Array::thread_all(level.players, &play_sentinel_round);
	sentinel_health_increase();
	level.zombie_total = get_sentinel_spawn_total();
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported" && GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level.zombie_total = GetDvarInt("Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", 0);
		}
	#/
	wait(1);
	function_9a46f975(1);
	visionset_mgr::activate("visionset", "zm_sentinel_round_visionset", undefined, 1.5, 1.5, 2);
	playsoundatposition("vox_zmba_event_sentinelstart_0", (0, 0, 0));
	level thread namespace_dcf9c464::function_3800b6e0();
	wait(3);
	level flag::set("sentinel_round_in_progress");
	level endon("last_ai_down");
	level thread sentinel_round_aftermath();
	while(1)
	{
		while(level.zombie_total > 0)
		{
			if(isdefined(level.bzm_worldPaused) && level.bzm_worldPaused)
			{
				util::wait_network_frame();
				continue;
			}
			var_c94972aa = level.var_35078afd > 1 && level.zombie_total % 2 == 0;
			spawn_sentinel(var_c94972aa);
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_fded8158
	Namespace: namespace_8bc21961
	Checksum: 0x50F4C45A
	Offset: 0x1530
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function function_fded8158(spawner, s_spot)
{
	ai_sentinel = zombie_utility::spawn_zombie(level.var_fda4b3f3[0], "sentinel", s_spot);
	if(isdefined(ai_sentinel))
	{
		ai_sentinel.check_point_in_enabled_zone = &zm_utility::check_point_in_playable_area;
	}
	return ai_sentinel;
}

/*
	Name: function_f9c9e7e0
	Namespace: namespace_8bc21961
	Checksum: 0x34D06F9E
	Offset: 0x15B0
	Size: 0x2CB
	Parameters: 0
	Flags: None
*/
function function_f9c9e7e0()
{
	a_s_spawn_locs = [];
	s_spawn_loc = undefined;
	foreach(s_zone in level.zones)
	{
		if(s_zone.is_enabled && isdefined(s_zone.a_loc_types["sentinel_location"]) && s_zone.a_loc_types["sentinel_location"].size)
		{
			foreach(s_loc in s_zone.a_loc_types["sentinel_location"])
			{
				foreach(player in level.activePlayers)
				{
					n_dist_sq = DistanceSquared(player.origin, s_loc.origin);
					if(n_dist_sq > 65536 && n_dist_sq < 2250000)
					{
						if(!isdefined(a_s_spawn_locs))
						{
							a_s_spawn_locs = [];
						}
						else if(!IsArray(a_s_spawn_locs))
						{
							a_s_spawn_locs = Array(a_s_spawn_locs);
						}
						a_s_spawn_locs[a_s_spawn_locs.size] = s_loc;
						break;
					}
				}
			}
		}
	}
	s_spawn_loc = Array::random(a_s_spawn_locs);
	if(!isdefined(s_spawn_loc))
	{
		s_spawn_loc = Array::random(level.zm_loc_types["sentinel_location"]);
	}
	return s_spawn_loc;
}

/*
	Name: spawn_sentinel
	Namespace: namespace_8bc21961
	Checksum: 0xB32843F5
	Offset: 0x1888
	Size: 0x1D3
	Parameters: 1
	Flags: None
*/
function spawn_sentinel(var_c94972aa)
{
	if(!isdefined(var_c94972aa))
	{
		var_c94972aa = 0;
	}
	while(!function_74ab7484())
	{
		wait(0.1);
	}
	s_spawn_loc = undefined;
	if(isdefined(level.func_sentinel_spawn))
	{
		s_spawn_loc = [[level.func_sentinel_spawn]]();
	}
	else
	{
		if(level.zm_loc_types["Dev Block strings are not supported"].size == 0)
		{
			IPrintLnBold("Dev Block strings are not supported");
		}
		s_spawn_loc = function_f9c9e7e0();
	}
	/#
	#/
	if(!isdefined(s_spawn_loc))
	{
		wait(RandomFloatRange(0.3333333, 0.6666667));
		return;
	}
	ai = function_fded8158(level.var_fda4b3f3[0]);
	if(isdefined(ai))
	{
		ai.nuke_damage_func = &function_306f9403;
		ai.instakill_func = &function_306f9403;
		ai.s_spawn_loc = s_spawn_loc;
		ai thread function_b27530eb(s_spawn_loc.origin);
		if(var_c94972aa)
		{
			ai.var_c94972aa = 1;
			ai.var_580a32ea = 6;
		}
		level.zombie_total--;
		waiting_for_next_sentinel_spawn();
	}
}

/*
	Name: function_b27530eb
	Namespace: namespace_8bc21961
	Checksum: 0xE3EC954F
	Offset: 0x1A68
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function function_b27530eb(v_pos)
{
	self endon("death");
	self sentinel_drone::sentinel_Intro();
	self vehicle::toggle_sounds(0);
	var_92968756 = v_pos + VectorScale((0, 0, 1), 30);
	self.origin = v_pos + VectorScale((0, 0, 1), 5000);
	self.angles = (0, randomIntRange(0, 360), 0);
	e_origin = spawn("script_origin", self.origin);
	e_origin.angles = self.angles;
	self LinkTo(e_origin);
	e_origin moveto(var_92968756, 3);
	e_origin playsound("zmb_sentinel_intro_spawn");
	e_origin util::delay(3, undefined, &function_e6bf0279);
	self clientfield::set("sentinel_spawn_fx", 1);
	wait(3);
	self clientfield::set("sentinel_spawn_fx", 0);
	wait(1);
	self vehicle::toggle_sounds(1);
	self.origin = var_92968756;
	self Unlink();
	e_origin delete();
	self flag::set("completed_spawning");
	wait(0.2);
	self sentinel_drone::sentinel_IntroCompleted();
}

/*
	Name: function_e6bf0279
	Namespace: namespace_8bc21961
	Checksum: 0x5BC97D4B
	Offset: 0x1CC0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_e6bf0279()
{
	self playsound("zmb_sentinel_intro_land");
}

/*
	Name: function_306f9403
	Namespace: namespace_8bc21961
	Checksum: 0xF8638743
	Offset: 0x1CF0
	Size: 0x1F
	Parameters: 3
	Flags: None
*/
function function_306f9403(player, mod, HIT_LOCATION)
{
	return 1;
}

/*
	Name: function_d600cb9a
	Namespace: namespace_8bc21961
	Checksum: 0x372FD239
	Offset: 0x1D18
	Size: 0x7AD
	Parameters: 0
	Flags: None
*/
function function_d600cb9a()
{
	self endon("hash_d600cb9a");
	self endon("death");
	self thread function_caadf4b1();
	self flag::wait_till("completed_spawning");
	var_4b9c276c = function_5b91ab3a();
	while(1)
	{
		level flag::wait_till_clear("sentinel_rez_in_progress");
		while(zombie_utility::get_current_zombie_count() >= var_4b9c276c)
		{
			wait(0.1);
		}
		if(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			zombie_utility::clear_all_corpses();
			wait(0.1);
			continue;
		}
		v_spawn_pos = undefined;
		if(isdefined(self.var_98bec529) && self.var_98bec529)
		{
			query_result = PositionQuery_Source_Navigation(self.origin, 16, 768, 200, 40, 32);
			if(query_result.data.size)
			{
				a_s_locs = Array::randomize(query_result.data);
				foreach(s_loc in a_s_locs)
				{
					var_caae2f83 = [[self.check_point_in_enabled_zone]](s_loc.origin, 1);
					if(var_caae2f83)
					{
						continue;
					}
					var_e31f585b = GetClosestPointOnNavMesh(s_loc.origin, 96, 32);
					if(isdefined(var_e31f585b))
					{
						var_c85c791d = 0;
						foreach(player in level.activePlayers)
						{
							n_dist_sq = DistanceSquared(self.origin, s_loc.origin);
							if(n_dist_sq < 250000)
							{
								var_c85c791d = 1;
								break;
							}
						}
						if(var_c85c791d)
						{
							continue;
						}
						s_spawn_loc = ArrayGetClosest(var_e31f585b, level.exterior_goals);
						if(isdefined(s_spawn_loc.script_string))
						{
							level.var_a657e360.script_string = s_spawn_loc.script_string;
						}
						a_ground_trace = GroundTrace(var_e31f585b + VectorScale((0, 0, 1), 64), var_e31f585b + VectorScale((0, 0, -1), 128), 0, undefined);
						v_spawn_pos = a_ground_trace["position"];
						break;
					}
				}
			}
			break;
		}
		player = zombie_utility::get_closest_valid_player(self.origin);
		if(!isdefined(player))
		{
			wait(3);
			continue;
		}
		query_result = PositionQuery_Source_Navigation(self.origin, 500, 768, 200, 40, 32);
		if(query_result.data.size)
		{
			a_s_locs = Array::randomize(query_result.data);
			foreach(s_loc in a_s_locs)
			{
				var_caae2f83 = [[self.check_point_in_enabled_zone]](s_loc.origin, 1);
				if(var_caae2f83)
				{
					var_c85c791d = 0;
					foreach(player in level.activePlayers)
					{
						n_dist_sq = DistanceSquared(self.origin, s_loc.origin);
						if(n_dist_sq < 250000)
						{
							var_c85c791d = 1;
							break;
						}
					}
					if(var_c85c791d)
					{
						continue;
					}
					level.var_a657e360.script_string = "find_flesh";
					v_spawn_pos = s_loc.origin;
					break;
				}
			}
		}
		else if(isdefined(v_spawn_pos))
		{
			if(level flag::get("sentinel_rez_in_progress"))
			{
				return;
			}
			level flag::set("sentinel_rez_in_progress");
			self.var_7e04bb3 = 1;
			self thread function_b7a02494();
			self sentinel_drone::sentinel_ForceGoAndStayInPosition(1, v_spawn_pos + VectorScale((0, 0, 1), 106));
			self waittill("goal");
			level.var_a657e360.origin = v_spawn_pos + VectorScale((0, 0, 1), 8);
			level.var_a657e360.angles = self.angles;
			self clientfield::set("necro_sentinel_fx", 1);
			self function_1a7787ed();
			self clientfield::set("necro_sentinel_fx", 0);
			self sentinel_drone::sentinel_ForceGoAndStayInPosition(0);
			wait(5);
			self.var_7e04bb3 = 0;
			level flag::clear("sentinel_rez_in_progress");
		}
		wait(1);
	}
}

/*
	Name: function_b7a02494
	Namespace: namespace_8bc21961
	Checksum: 0xE1D3F632
	Offset: 0x24D0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_b7a02494()
{
	self endon("hash_411508f7");
	self waittill("death");
	level flag::clear("sentinel_rez_in_progress");
}

/*
	Name: function_1a7787ed
	Namespace: namespace_8bc21961
	Checksum: 0x3E612246
	Offset: 0x2518
	Size: 0x22F
	Parameters: 0
	Flags: None
*/
function function_1a7787ed()
{
	self endon("death");
	self endon("hash_15969cec");
	var_4bb04d82 = get_zombie_spawn_delay();
	var_4b9c276c = function_5b91ab3a();
	n_num_to_spawn = randomIntRange(6, 24);
	while(n_num_to_spawn)
	{
		while(zombie_utility::get_current_zombie_count() >= var_4b9c276c)
		{
			return;
		}
		if(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			return;
		}
		if(flag::exists("world_is_paused") && level flag::get("world_is_paused"))
		{
			level flag::wait_till_clear("world_is_paused");
			continue;
		}
		if(!level flag::get("spawn_zombies"))
		{
			level flag::wait_till("spawn_zombies");
			continue;
		}
		ai_zombie = zombie_utility::spawn_zombie(level.var_34fd66c3[0], "sentinel_riser", level.var_a657e360);
		if(isdefined(ai_zombie))
		{
			n_num_to_spawn--;
			ai_zombie clientfield::set("sentinel_zombie_spawn_fx", 1);
			ai_zombie thread function_fdd9c3df(self);
			playsoundatposition("zmb_sentinel_res_spawn", level.var_a657e360.origin);
			wait(var_4bb04d82);
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_caadf4b1
	Namespace: namespace_8bc21961
	Checksum: 0x107F9853
	Offset: 0x2750
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function function_caadf4b1()
{
	self waittill("death");
	self clientfield::set("necro_sentinel_fx", 0);
	a_ai_zombies = GetAITeamArray(level.zombie_team);
	a_ai_children = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		if(ai_zombie.var_ec3fb9eb === self)
		{
			if(!isdefined(a_ai_children))
			{
				a_ai_children = [];
			}
			else if(!IsArray(a_ai_children))
			{
				a_ai_children = Array(a_ai_children);
			}
			a_ai_children[a_ai_children.size] = ai_zombie;
			ai_zombie.nuked = 1;
		}
	}
	if(a_ai_children.size)
	{
		namespace_48c05c81::function_adf4d1d0(a_ai_children);
	}
}

/*
	Name: function_fdd9c3df
	Namespace: namespace_8bc21961
	Checksum: 0x97B96242
	Offset: 0x28D0
	Size: 0x22B
	Parameters: 1
	Flags: None
*/
function function_fdd9c3df(ai_parent)
{
	self endon("death");
	ai_parent endon("death");
	self.b_ignore_cleanup = 1;
	self.exclude_cleanup_adding_to_total = 1;
	if(ai_parent.var_580a32ea > 0)
	{
		ai_parent.var_580a32ea--;
		self thread function_ea9730d8(ai_parent);
	}
	else
	{
		self.no_damage_points = 1;
		self.deathpoints_already_given = 1;
	}
	self.var_ec3fb9eb = ai_parent;
	self.var_bb98125f = 1;
	namespace_57695b4d::function_1b1bb1b();
	self.health = Int(level.zombie_health / 2);
	self waittill("completed_emerging_into_playable_area");
	self.no_powerups = 1;
	n_timeout = GetTime() + 60000;
	while(!isdefined(self.enemy))
	{
		wait(0.1);
	}
	if(!self CanPath(self.origin, self.enemy.origin))
	{
		ai_parent notify("hash_15969cec");
		self kill();
		return;
	}
	n_dist_sq_max = RandomFloatRange(1048448, 1048576);
	while(GetTime() < n_timeout)
	{
		n_dist_sq = DistanceSquared(self.origin, ai_parent.origin);
		if(n_dist_sq > 1048576)
		{
			break;
		}
		wait(1);
	}
	self kill();
}

/*
	Name: function_ea9730d8
	Namespace: namespace_8bc21961
	Checksum: 0xB380B8C9
	Offset: 0x2B08
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function function_ea9730d8(ai_parent)
{
	self endon("hash_107a4ece");
	ai_parent endon("death");
	self function_cb2c6547();
	if(!isdefined(self.attacker) || !isPlayer(self.attacker))
	{
		ai_parent.var_580a32ea++;
	}
}

/*
	Name: function_cb2c6547
	Namespace: namespace_8bc21961
	Checksum: 0xEEA05561
	Offset: 0x2B88
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function function_cb2c6547()
{
	self endon("death");
	while(1)
	{
		self waittill("damage", n_damage, e_attacker);
		if(isdefined(e_attacker) && isPlayer(e_attacker))
		{
			self notify("hash_107a4ece");
		}
	}
}

/*
	Name: get_sentinel_spawn_total
	Namespace: namespace_8bc21961
	Checksum: 0x1414D126
	Offset: 0x2C00
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function get_sentinel_spawn_total()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_wave_count = 6;
			var_ebe16089 = 1;
			break;
		}
		case 2:
		{
			n_wave_count = 9;
			var_ebe16089 = 2;
			break;
		}
		case 3:
		{
			n_wave_count = 12;
			var_ebe16089 = 3;
			break;
		}
		case default:
		{
			n_wave_count = 15;
			var_ebe16089 = 4;
		}
	}
	return n_wave_count + level.var_35078afd - 1 * var_ebe16089;
}

/*
	Name: function_5b91ab3a
	Namespace: namespace_8bc21961
	Checksum: 0x53D26C87
	Offset: 0x2CC8
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function function_5b91ab3a()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_count = 10;
			break;
		}
		case 2:
		{
			n_count = 10;
			break;
		}
		case 3:
		{
			n_count = 10;
			break;
		}
		case default:
		{
			n_count = 12;
		}
	}
	return n_count;
}

/*
	Name: get_zombie_spawn_delay
	Namespace: namespace_8bc21961
	Checksum: 0x7FDC9D96
	Offset: 0x2D50
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function get_zombie_spawn_delay()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_delay = 2.5;
			break;
		}
		case 2:
		{
			n_delay = 2;
			break;
		}
		case 3:
		{
			n_delay = 1.5;
			break;
		}
		case default:
		{
			n_delay = 1;
		}
	}
	return n_delay;
}

/*
	Name: sentinel_round_wait_func
	Namespace: namespace_8bc21961
	Checksum: 0x6FB57405
	Offset: 0x2DE0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function sentinel_round_wait_func()
{
	level endon("restart_round");
	/#
		level endon("kill_round");
	#/
	if(level flag::get("sentinel_round"))
	{
		level flag::wait_till("sentinel_round_in_progress");
		level flag::wait_till_clear("sentinel_round_in_progress");
	}
	level.sndMusicSpecialRound = 0;
}

/*
	Name: get_current_sentinel_count
	Namespace: namespace_8bc21961
	Checksum: 0xDB916B7F
	Offset: 0x2E70
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function get_current_sentinel_count()
{
	a_ai_sentinel = GetEntArray("zombie_sentinel", "targetname");
	var_5eecf676 = a_ai_sentinel.size;
	foreach(ai_sentinel in a_ai_sentinel)
	{
		if(!isalive(ai_sentinel))
		{
			var_5eecf676--;
		}
	}
	return var_5eecf676;
}

/*
	Name: function_e4aafac
	Namespace: namespace_8bc21961
	Checksum: 0xB87871BF
	Offset: 0x2F50
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function function_e4aafac()
{
	switch(level.players.size)
	{
		case 1:
		{
			return 3;
			break;
		}
		case 2:
		{
			return 4;
			break;
		}
		case 3:
		{
			return 5;
			break;
		}
		case 4:
		{
			return 6;
			break;
		}
	}
}

/*
	Name: function_9a46f975
	Namespace: namespace_8bc21961
	Checksum: 0x616C4CD
	Offset: 0x2FC0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_9a46f975(n_val)
{
	if(n_val)
	{
		foreach(player in level.players)
		{
			player clientfield::set_to_player("sentinel_round_fx", n_val);
		}
	}
	level clientfield::set("sentinel_round_fog", n_val);
}

/*
	Name: function_74ab7484
	Namespace: namespace_8bc21961
	Checksum: 0xCE20FA2C
	Offset: 0x3090
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_74ab7484()
{
	var_8d70c285 = get_current_sentinel_count();
	var_f285bab2 = function_e4aafac();
	if(var_8d70c285 >= var_f285bab2 || !level flag::get("spawn_zombies"))
	{
		return 0;
	}
	return 1;
}

/*
	Name: waiting_for_next_sentinel_spawn
	Namespace: namespace_8bc21961
	Checksum: 0xB01BF704
	Offset: 0x3110
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function waiting_for_next_sentinel_spawn()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_default_wait = 2.25;
			break;
		}
		case 2:
		{
			n_default_wait = 1.75;
			break;
		}
		case 3:
		{
			n_default_wait = 1.25;
			break;
		}
		case default:
		{
			n_default_wait = 0.75;
			break;
		}
	}
	wait(n_default_wait);
}

/*
	Name: sentinel_round_aftermath
	Namespace: namespace_8bc21961
	Checksum: 0x4D7C7907
	Offset: 0x31A0
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function sentinel_round_aftermath()
{
	level waittill("last_ai_down", ai_sentinel, e_attacker);
	level thread zm_audio::sndMusicSystem_PlayState("sentinel_roundend");
	if(isdefined(level.zm_override_ai_aftermath_powerup_drop))
	{
		[[level.zm_override_ai_aftermath_powerup_drop]](ai_sentinel, level.var_6a6f912a);
	}
	else
	{
		var_4a50cb2a = level.var_6a6f912a;
		if(isdefined(var_4a50cb2a))
		{
			mdl_powerup = level zm_powerups::specific_powerup_drop("full_ammo", var_4a50cb2a);
			if(isPlayer(e_attacker))
			{
				v_destination = e_attacker.origin;
			}
			else
			{
				e_player = zm_utility::get_closest_player(var_4a50cb2a);
				v_destination = e_player.origin;
			}
			mdl_powerup thread function_630f7ed5(v_destination);
		}
	}
	wait(2);
	level.sndMusicSpecialRound = 0;
	wait(6);
	level thread function_9a46f975(0);
	level flag::clear("sentinel_round_in_progress");
}

/*
	Name: function_630f7ed5
	Namespace: namespace_8bc21961
	Checksum: 0x98BB82B1
	Offset: 0x3338
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_630f7ed5(v_origin)
{
	self endon("death");
	v_navmesh = GetClosestPointOnNavMesh(v_origin, 512, 16);
	if(isdefined(v_navmesh))
	{
		wait(2);
		self moveto(v_navmesh + VectorScale((0, 0, 1), 40), 2);
	}
}

/*
	Name: sentinel_health_increase
	Namespace: namespace_8bc21961
	Checksum: 0x8E6978F4
	Offset: 0x33C0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function sentinel_health_increase()
{
	level.var_d6d4b6f9 = 2500 + level.round_number * 200;
	if(level.var_d6d4b6f9 < 4500)
	{
		level.var_d6d4b6f9 = 4500;
	}
	else if(level.var_d6d4b6f9 > 50000)
	{
		level.var_d6d4b6f9 = 50000;
	}
	level.var_d6d4b6f9 = Int(level.var_d6d4b6f9 * 1 + 0.25 * level.players.size - 1);
}

/*
	Name: play_sentinel_round
	Namespace: namespace_8bc21961
	Checksum: 0x5A6477A1
	Offset: 0x3478
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function play_sentinel_round()
{
	self playlocalsound("zmb_sentinel_round_start");
	wait(4.5);
	n_index = randomIntRange(0, level.activePlayers.size);
	level.activePlayers[n_index] zm_audio::create_and_play_dialog("general", "sentinel_spawn");
}

/*
	Name: function_3b40bf32
	Namespace: namespace_8bc21961
	Checksum: 0x999C0C26
	Offset: 0x3510
	Size: 0x32F
	Parameters: 0
	Flags: None
*/
function function_3b40bf32()
{
	self.targetname = "zombie_sentinel";
	self.script_noteworthy = undefined;
	self.animName = "zombie_sentinel";
	self.allowdeath = 1;
	self.allowPain = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
	self.no_eye_glow = 1;
	self.no_powerups = 1;
	self.lightning_chain_immune = 1;
	self.holdFire = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = 1;
	self.suppressionThreshold = 1;
	self.noDodgeMove = 1;
	self.dontShootWhileMoving = 1;
	self.pathenemylookahead = 0;
	self.chatInitialized = 0;
	self.missingLegs = 0;
	self.team = level.zombie_team;
	self.sword_kill_power = 4;
	self.sentinel_ElectrifyZombie = &function_c72cf6e1;
	self.sentinel_GetNearestZombie = &function_49b3a408;
	if(isdefined(level.var_97596556))
	{
		self.func_custom_cleanup_check = level.var_97596556;
	}
	self.b_widows_wine_no_powerup = 1;
	self.maxhealth = level.var_d6d4b6f9;
	if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
	{
		self.health = level.a_zombie_respawn_health[self.archetype][0];
		ArrayRemoveValue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
	}
	else
	{
		self.health = self.maxhealth;
	}
	self thread sentinel_death();
	self thread compact_mode();
	self flag::init("completed_spawning");
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	if(self.var_c94972aa === 1)
	{
		self thread function_d600cb9a();
	}
	self zm_spawner::zombie_history("zombie_sentinel_spawn_init -> Spawned = " + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self thread [[level.achievement_monitor_func]]();
	}
}

/*
	Name: sentinel_death
	Namespace: namespace_8bc21961
	Checksum: 0x95852347
	Offset: 0x3848
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function sentinel_death()
{
	self waittill("death", attacker);
	if(get_current_sentinel_count() == 0 && level.zombie_total <= 0)
	{
		if(!isdefined(level.zm_ai_round_over) || [[level.zm_ai_round_over]]())
		{
			level.var_6a6f912a = self.origin;
			level notify("last_ai_down", self, attacker);
		}
	}
	if(isPlayer(attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			attacker zm_score::player_add_points("death_sentinel");
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](attacker, self);
		}
		attacker zm_audio::create_and_play_dialog("kill", "sentinel");
		attacker zm_stats::increment_client_stat("zsentinel_killed");
		attacker zm_stats::increment_player_stat("zsentinel_killed");
	}
	if(isdefined(attacker) && isai(attacker))
	{
		attacker notify("killed", self);
	}
	if(isdefined(self))
	{
		self StopLoopSound();
		self thread function_acaa3ee4(self.origin);
	}
}

/*
	Name: function_acaa3ee4
	Namespace: namespace_8bc21961
	Checksum: 0x45213080
	Offset: 0x3A20
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_acaa3ee4(origin)
{
}

/*
	Name: compact_mode
	Namespace: namespace_8bc21961
	Checksum: 0x88A4A165
	Offset: 0x3A38
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function compact_mode()
{
	self endon("death");
	v_compact_mode = GetEnt("sentinel_compact", "targetname");
	while(1)
	{
		if(self istouching(v_compact_mode))
		{
			self sentinel_drone::sentinel_SetCompactMode(1);
			while(self istouching(v_compact_mode))
			{
				wait(0.5);
			}
			self sentinel_drone::sentinel_SetCompactMode(0);
		}
		wait(0.2);
	}
}

/*
	Name: zombie_setup_attack_properties_sentinel
	Namespace: namespace_8bc21961
	Checksum: 0xF5FCC519
	Offset: 0x3B00
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function zombie_setup_attack_properties_sentinel()
{
	self zm_spawner::zombie_history("zombie_setup_attack_properties()");
	self ai::set_ignoreall(0);
	self.meleeAttackDist = 64;
	self.disableArrivals = 1;
	self.disableExits = 1;
}

/*
	Name: stop_sentinel_sound_on_death
	Namespace: namespace_8bc21961
	Checksum: 0x912AF253
	Offset: 0x3B68
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function stop_sentinel_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

/*
	Name: special_sentinel_spawn
	Namespace: namespace_8bc21961
	Checksum: 0xCE4FBC20
	Offset: 0x3B98
	Size: 0x19B
	Parameters: 4
	Flags: None
*/
function special_sentinel_spawn(n_to_spawn, func_on_spawned, b_force_spawn, var_b7959229)
{
	if(!isdefined(n_to_spawn))
	{
		n_to_spawn = 1;
	}
	if(!isdefined(b_force_spawn))
	{
		b_force_spawn = 0;
	}
	if(!isdefined(var_b7959229))
	{
		var_b7959229 = undefined;
	}
	n_spawned = 0;
	while(n_spawned < n_to_spawn)
	{
		if(!b_force_spawn && !function_74ab7484())
		{
			return n_spawned;
		}
		if(isdefined(var_b7959229))
		{
			s_spawn_loc = var_b7959229;
		}
		else if(isdefined(level.sentinel_spawn_func))
		{
			s_spawn_loc = [[level.sentinel_spawn_func]](level.var_fda4b3f3);
		}
		else
		{
			s_spawn_loc = function_f9c9e7e0();
		}
		if(!isdefined(s_spawn_loc))
		{
			return 0;
		}
		ai = function_fded8158(level.var_fda4b3f3[0]);
		if(isdefined(ai))
		{
			ai thread function_b27530eb(s_spawn_loc.origin);
			n_spawned++;
			if(isdefined(func_on_spawned))
			{
				ai thread [[func_on_spawned]]();
			}
		}
		waiting_for_next_sentinel_spawn();
	}
	return 1;
}

/*
	Name: function_9a59090e
	Namespace: namespace_8bc21961
	Checksum: 0x250479B5
	Offset: 0x3D40
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_9a59090e()
{
	self endon("death");
	while(1)
	{
		self playsound("zmb_hellhound_vocals_amb");
		wait(RandomFloatRange(3, 6));
	}
}

/*
	Name: function_c72cf6e1
	Namespace: namespace_8bc21961
	Checksum: 0x7E2C6C52
	Offset: 0x3D98
	Size: 0x2B1
	Parameters: 3
	Flags: None
*/
function function_c72cf6e1(origin, zombie, radius)
{
	self endon("death");
	self endon("disconnect");
	self endon("delete");
	if(isdefined(zombie) && (isdefined(zombie.zombie_think_done) && zombie.zombie_think_done))
	{
		if(zombie.is_elemental_zombie !== 1 && zombie.var_3531cf2b !== 1)
		{
			zombie namespace_57695b4d::function_1b1bb1b();
		}
	}
	if(isdefined(radius) && radius > 0)
	{
		var_199ecc3a = namespace_57695b4d::function_4aeed0a5("sparky");
		if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
		{
			var_82aacc64 = namespace_57695b4d::function_d41418b8();
			var_82aacc64 = ArraySortClosest(var_82aacc64, origin);
			radius_sq = radius * radius;
			foreach(ai_zombie in var_82aacc64)
			{
				if(!isdefined(ai_zombie))
				{
					continue;
				}
				if(!isalive(ai_zombie))
				{
					continue;
				}
				if(!(isdefined(ai_zombie.zombie_think_done) && ai_zombie.zombie_think_done))
				{
					continue;
				}
				if(!(ai_zombie.is_elemental_zombie !== 1 && ai_zombie.var_3531cf2b !== 1))
				{
					continue;
				}
				dist_sq = Distance2DSquared(origin, ai_zombie.origin);
				if(dist_sq <= radius_sq)
				{
					ai_zombie namespace_57695b4d::function_1b1bb1b();
					continue;
				}
				break;
			}
		}
	}
}

/*
	Name: function_49b3a408
	Namespace: namespace_8bc21961
	Checksum: 0x45BF4ABA
	Offset: 0x4058
	Size: 0x2BF
	Parameters: 4
	Flags: None
*/
function function_49b3a408(origin, b_ignore_elemental, b_outside_playable_area, radius)
{
	if(!isdefined(b_ignore_elemental))
	{
		b_ignore_elemental = 1;
	}
	if(!isdefined(b_outside_playable_area))
	{
		b_outside_playable_area = 1;
	}
	if(!isdefined(radius))
	{
		radius = 2000;
	}
	self endon("death");
	self endon("disconnect");
	self endon("delete");
	if(isdefined(radius) && radius > 0)
	{
		var_199ecc3a = namespace_57695b4d::function_4aeed0a5("sparky");
		if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
		{
			var_82aacc64 = namespace_57695b4d::function_d41418b8();
			var_82aacc64 = ArraySortClosest(var_82aacc64, origin);
			radius_sq = radius * radius;
			foreach(ai_zombie in var_82aacc64)
			{
				if(!isdefined(ai_zombie))
				{
					continue;
				}
				if(!isalive(ai_zombie))
				{
					continue;
				}
				if(!(isdefined(ai_zombie.zombie_think_done) && ai_zombie.zombie_think_done))
				{
					continue;
				}
				if(isdefined(ai_zombie.var_3531cf2b) && ai_zombie.var_3531cf2b)
				{
					continue;
				}
				if(b_ignore_elemental && (isdefined(ai_zombie.is_elemental_zombie) && ai_zombie.is_elemental_zombie))
				{
					continue;
				}
				if(isdefined(ai_zombie.hunted_by_sentinel) && ai_zombie.hunted_by_sentinel)
				{
					continue;
				}
				dist_sq = Distance2DSquared(origin, ai_zombie.origin);
				if(dist_sq <= radius_sq)
				{
					return ai_zombie;
					break;
				}
			}
		}
	}
	return undefined;
}

/*
	Name: function_5715a7cc
	Namespace: namespace_8bc21961
	Checksum: 0x11362BB3
	Offset: 0x4320
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_5715a7cc()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		zm_devgui::add_custom_devgui_callback(&function_c630bba3);
	#/
}

/*
	Name: function_c630bba3
	Namespace: namespace_8bc21961
	Checksum: 0x1EEE3A65
	Offset: 0x4460
	Size: 0x5E5
	Parameters: 1
	Flags: None
*/
function function_c630bba3(cmd)
{
	/#
		if(level.var_fda4b3f3.size == 0)
		{
			return;
		}
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				player = level.players[0];
				v_direction = player getPlayerAngles();
				v_direction = AnglesToForward(v_direction) * 8000;
				v_eye = player GetEye();
				trace = bullettrace(v_eye, v_eye + v_direction, 0, undefined);
				var_feba5c63 = PositionQuery_Source_Navigation(trace["Dev Block strings are not supported"], 128, 256, 128, 20);
				s_spot = spawnstruct();
				if(isdefined(var_feba5c63) && var_feba5c63.data.size > 0)
				{
					s_spot.origin = var_feba5c63.data[0].origin;
				}
				else
				{
					s_spot.origin = player.origin;
				}
				s_spot.angles = (0, player.angles[1] - 180, 0);
				special_sentinel_spawn(1, undefined, 1, s_spot);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				zm_devgui::zombie_devgui_goto_round(level.var_a78effc7);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				curValue = GetDvarInt("Dev Block strings are not supported", 0);
				if(curValue == 0)
				{
					curValue = 1;
				}
				else
				{
					curValue = 0;
				}
				SetDvar("Dev Block strings are not supported", curValue);
				return 1;
			}
			case default:
			{
				return 0;
			}
		}
	#/
}

