#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_util;
#using scripts\zm\_zm_utility;
#using scripts\zm\gametypes\_zm_gametype;

#namespace zm_zonemgr;

/*
	Name: __init__sytem__
	Namespace: zm_zonemgr
	Checksum: 0x18B5852B
	Offset: 0x358
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zonemgr", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zonemgr
	Checksum: 0x8CFDDF95
	Offset: 0x398
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		println("Dev Block strings are not supported");
	#/
	level flag::init("zones_initialized");
	level.zones = [];
	level.zone_flags = [];
	level.zone_scanning_active = 0;
	level.str_zone_mgr_mode = "occupied_and_adjacent";
	level.create_spawner_list_func = &create_spawner_list;
}

/*
	Name: zone_is_enabled
	Namespace: zm_zonemgr
	Checksum: 0x1FE39401
	Offset: 0x430
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function zone_is_enabled(zone_name)
{
	if(!isdefined(level.zones) || !isdefined(level.zones[zone_name]) || !level.zones[zone_name].is_enabled)
	{
		return 0;
	}
	return 1;
}

/*
	Name: zone_wait_till_enabled
	Namespace: zm_zonemgr
	Checksum: 0xF30BFB44
	Offset: 0x490
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function zone_wait_till_enabled(zone_name)
{
	if(!zone_is_enabled(zone_name))
	{
		level waittill(zone_name);
	}
}

/*
	Name: get_player_zone
	Namespace: zm_zonemgr
	Checksum: 0xE8766F0B
	Offset: 0x4C8
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_player_zone()
{
	return zm_utility::get_current_zone();
}

/*
	Name: get_zone_from_position
	Namespace: zm_zonemgr
	Checksum: 0x286F24B2
	Offset: 0x4E8
	Size: 0xF7
	Parameters: 2
	Flags: None
*/
function get_zone_from_position(v_pos, ignore_enabled_check)
{
	zone = undefined;
	scr_org = spawn("script_origin", v_pos);
	keys = getArrayKeys(level.zones);
	for(i = 0; i < keys.size; i++)
	{
		if(scr_org entity_in_zone(keys[i], ignore_enabled_check))
		{
			zone = keys[i];
			break;
		}
	}
	scr_org delete();
	return zone;
}

/*
	Name: get_zone_magic_boxes
	Namespace: zm_zonemgr
	Checksum: 0x86DCD8C9
	Offset: 0x5E8
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function get_zone_magic_boxes(zone_name)
{
	if(isdefined(zone_name) && !zone_is_enabled(zone_name))
	{
		return undefined;
	}
	zone = level.zones[zone_name];
	/#
		Assert(isdefined(zone_name));
	#/
	return zone.magic_boxes;
}

/*
	Name: get_zone_zbarriers
	Namespace: zm_zonemgr
	Checksum: 0x10DACC5F
	Offset: 0x670
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function get_zone_zbarriers(zone_name)
{
	if(isdefined(zone_name) && !zone_is_enabled(zone_name))
	{
		return undefined;
	}
	zone = level.zones[zone_name];
	/#
		Assert(isdefined(zone_name));
	#/
	return zone.zbarriers;
}

/*
	Name: get_players_in_zone
	Namespace: zm_zonemgr
	Checksum: 0x554CEB2C
	Offset: 0x6F8
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function get_players_in_zone(zone_name, return_players)
{
	wait_zone_flags_updating();
	if(!zone_is_enabled(zone_name))
	{
		return 0;
	}
	zone = level.zones[zone_name];
	num_in_zone = 0;
	players_in_zone = [];
	players = GetPlayers();
	for(i = 0; i < zone.Volumes.size; i++)
	{
		for(j = 0; j < players.size; j++)
		{
			if(players[j] istouching(zone.Volumes[i]))
			{
				num_in_zone++;
				players_in_zone[players_in_zone.size] = players[j];
			}
		}
	}
	if(isdefined(return_players))
	{
		return players_in_zone;
	}
	return num_in_zone;
}

/*
	Name: any_player_in_zone
	Namespace: zm_zonemgr
	Checksum: 0xE6E9A67C
	Offset: 0x868
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function any_player_in_zone(zone_name)
{
	if(!zone_is_enabled(zone_name))
	{
		return 0;
	}
	zone = level.zones[zone_name];
	for(i = 0; i < zone.Volumes.size; i++)
	{
		players = GetPlayers();
		for(j = 0; j < players.size; j++)
		{
			if(players[j] istouching(zone.Volumes[i]) && !players[j].sessionstate == "spectator")
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: entity_in_zone
	Namespace: zm_zonemgr
	Checksum: 0xD3A8CC34
	Offset: 0x990
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function entity_in_zone(zone_name, ignore_enabled_check)
{
	if(!isdefined(ignore_enabled_check))
	{
		ignore_enabled_check = 0;
	}
	if(isPlayer(self) && self.sessionstate == "spectator")
	{
		return 0;
	}
	if(!zone_is_enabled(zone_name) && !ignore_enabled_check)
	{
		return 0;
	}
	zone = level.zones[zone_name];
	foreach(e_volume in zone.Volumes)
	{
		if(self istouching(e_volume))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: entity_in_active_zone
	Namespace: zm_zonemgr
	Checksum: 0xD70CB542
	Offset: 0xAD0
	Size: 0xF5
	Parameters: 1
	Flags: None
*/
function entity_in_active_zone(ignore_enabled_check)
{
	if(!isdefined(ignore_enabled_check))
	{
		ignore_enabled_check = 0;
	}
	if(isPlayer(self) && self.sessionstate == "spectator")
	{
		return 0;
	}
	foreach(str_adj_zone in level.active_zone_names)
	{
		b_in_zone = entity_in_zone(str_adj_zone, ignore_enabled_check);
		if(b_in_zone)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: deactivate_initial_barrier_goals
	Namespace: zm_zonemgr
	Checksum: 0x4DCDF23B
	Offset: 0xBD0
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function deactivate_initial_barrier_goals()
{
	special_goals = struct::get_array("exterior_goal", "targetname");
	for(i = 0; i < special_goals.size; i++)
	{
		if(isdefined(special_goals[i].script_noteworthy))
		{
			special_goals[i].is_active = 0;
			special_goals[i] TriggerEnable(0);
		}
	}
}

/*
	Name: zone_init
	Namespace: zm_zonemgr
	Checksum: 0x8B35D090
	Offset: 0xC80
	Size: 0xABB
	Parameters: 2
	Flags: None
*/
function zone_init(zone_name, zone_tag)
{
	if(isdefined(level.zones[zone_name]))
	{
		return;
	}
	/#
		println("Dev Block strings are not supported" + zone_name);
	#/
	level.zones[zone_name] = spawnstruct();
	zone = level.zones[zone_name];
	zone.is_enabled = 0;
	zone.is_occupied = 0;
	zone.is_active = 0;
	zone.adjacent_zones = [];
	zone.is_spawning_allowed = 0;
	if(isdefined(zone_tag))
	{
		zone_name_tokens = StrTok(zone_name, "_");
		zone.district = zone_name_tokens[1];
		zone.area = zone_tag;
	}
	zone.Volumes = [];
	Volumes = GetEntArray(zone_name, "targetname");
	/#
		println("Dev Block strings are not supported" + Volumes.size);
	#/
	for(i = 0; i < Volumes.size; i++)
	{
		if(Volumes[i].classname == "info_volume")
		{
			zone.Volumes[zone.Volumes.size] = Volumes[i];
		}
	}
	/#
		Assert(isdefined(zone.Volumes[0]), "Dev Block strings are not supported" + zone_name);
	#/
	/#
		zone.total_spawn_count = 0;
		zone.round_spawn_count = 0;
	#/
	zone.a_loc_types = [];
	zone.a_loc_types["zombie_location"] = [];
	zone.zbarriers = [];
	zone.magic_boxes = [];
	if(isdefined(zone.Volumes[0].target))
	{
		spots = struct::get_array(zone.Volumes[0].target, "targetname");
		barricades = struct::get_array("exterior_goal", "targetname");
		box_locs = struct::get_array("treasure_chest_use", "targetname");
		foreach(spot in spots)
		{
			spot.zone_name = zone_name;
			if(!(isdefined(spot.is_blocked) && spot.is_blocked))
			{
				spot.is_enabled = 1;
			}
			else
			{
				spot.is_enabled = 0;
			}
			tokens = StrTok(spot.script_noteworthy, " ");
			foreach(token in tokens)
			{
				switch(token)
				{
					case "custom_spawner_entry":
					case "faller_location":
					case "riser_location":
					case "spawn_location":
					{
						if(!isdefined(zone.a_loc_types["zombie_location"]))
						{
							zone.a_loc_types["zombie_location"] = [];
						}
						else if(!IsArray(zone.a_loc_types["zombie_location"]))
						{
							zone.a_loc_types["zombie_location"] = Array(zone.a_loc_types["zombie_location"]);
						}
						zone.a_loc_types["zombie_location"][zone.a_loc_types["zombie_location"].size] = spot;
						break;
					}
					case default:
					{
						if(!isdefined(zone.a_loc_types[token]))
						{
							zone.a_loc_types[token] = [];
						}
						if(!isdefined(zone.a_loc_types[token]))
						{
							zone.a_loc_types[token] = [];
						}
						else if(!IsArray(zone.a_loc_types[token]))
						{
							zone.a_loc_types[token] = Array(zone.a_loc_types[token]);
						}
						zone.a_loc_types[token][zone.a_loc_types[token].size] = spot;
					}
				}
			}
			if(isdefined(spot.script_string))
			{
				barricade_id = spot.script_string;
				for(K = 0; K < barricades.size; K++)
				{
					if(isdefined(barricades[K].script_string) && barricades[K].script_string == barricade_id)
					{
						nodes = GetNodeArray(barricades[K].target, "targetname");
						for(j = 0; j < nodes.size; j++)
						{
							if(isdefined(nodes[j].type) && nodes[j].type == "Begin")
							{
								spot.target = nodes[j].targetname;
							}
						}
					}
				}
			}
		}
		for(i = 0; i < barricades.size; i++)
		{
			targets = GetEntArray(barricades[i].target, "targetname");
			for(j = 0; j < targets.size; j++)
			{
				if(targets[j] IsZBarrier() && isdefined(targets[j].script_string) && targets[j].script_string == zone_name)
				{
					if(!isdefined(zone.zbarriers))
					{
						zone.zbarriers = [];
					}
					else if(!IsArray(zone.zbarriers))
					{
						zone.zbarriers = Array(zone.zbarriers);
					}
					zone.zbarriers[zone.zbarriers.size] = targets[j];
				}
			}
		}
		for(i = 0; i < box_locs.size; i++)
		{
			chest_ent = GetEnt(box_locs[i].script_noteworthy + "_zbarrier", "script_noteworthy");
			if(chest_ent entity_in_zone(zone_name, 1))
			{
				if(!isdefined(zone.magic_boxes))
				{
					zone.magic_boxes = [];
				}
				else if(!IsArray(zone.magic_boxes))
				{
					zone.magic_boxes = Array(zone.magic_boxes);
				}
				zone.magic_boxes[zone.magic_boxes.size] = box_locs[i];
			}
		}
	}
}

/*
	Name: reinit_zone_spawners
	Namespace: zm_zonemgr
	Checksum: 0x57DC41A3
	Offset: 0x1748
	Size: 0x487
	Parameters: 0
	Flags: None
*/
function reinit_zone_spawners()
{
	zkeys = getArrayKeys(level.zones);
	for(i = 0; i < level.zones.size; i++)
	{
		zone = level.zones[zkeys[i]];
		zone.a_loc_types = [];
		zone.a_loc_types["zombie_location"] = [];
		if(isdefined(zone.Volumes[0].target))
		{
			spots = struct::get_array(zone.Volumes[0].target, "targetname");
			foreach(spot in spots)
			{
				spot.zone_name = zkeys[n_index];
				if(!(isdefined(spot.is_blocked) && spot.is_blocked))
				{
					spot.is_enabled = 1;
				}
				else
				{
					spot.is_enabled = 0;
				}
				tokens = StrTok(spot.script_noteworthy, " ");
				foreach(token in tokens)
				{
					switch(token)
					{
						case "custom_spawner_entry":
						case "faller_location":
						case "riser_location":
						case "spawn_location":
						case "spawner_location":
						{
							if(!isdefined(zone.a_loc_types["zombie_location"]))
							{
								zone.a_loc_types["zombie_location"] = [];
							}
							else if(!IsArray(zone.a_loc_types["zombie_location"]))
							{
								zone.a_loc_types["zombie_location"] = Array(zone.a_loc_types["zombie_location"]);
							}
							zone.a_loc_types["zombie_location"][zone.a_loc_types["zombie_location"].size] = spot;
							break;
						}
						case default:
						{
							if(!isdefined(zone.a_a_locs[token]))
							{
								zone.a_loc_types[token] = [];
							}
							if(!isdefined(zone.a_loc_types[token]))
							{
								zone.a_loc_types[token] = [];
							}
							else if(!IsArray(zone.a_loc_types[token]))
							{
								zone.a_loc_types[token] = Array(zone.a_loc_types[token]);
							}
							zone.a_loc_types[token][zone.a_loc_types[token].size] = spot;
						}
					}
				}
			}
		}
	}
}

/*
	Name: enable_zone
	Namespace: zm_zonemgr
	Checksum: 0xA401B3CD
	Offset: 0x1BD8
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function enable_zone(zone_name)
{
	/#
		Assert(isdefined(level.zones) && isdefined(level.zones[zone_name]), "Dev Block strings are not supported");
	#/
	if(level.zones[zone_name].is_enabled)
	{
		return;
	}
	level.zones[zone_name].is_enabled = 1;
	level.zones[zone_name].is_spawning_allowed = 1;
	level notify(zone_name);
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	for(i = 0; i < spawn_points.size; i++)
	{
		if(spawn_points[i].script_noteworthy == zone_name)
		{
			spawn_points[i].locked = 0;
		}
	}
	entry_points = struct::get_array(zone_name + "_barriers", "script_noteworthy");
	for(i = 0; i < entry_points.size; i++)
	{
		entry_points[i].is_active = 1;
		entry_points[i] TriggerEnable(1);
	}
	bb::function_2c248b75("zone_enable_" + zone_name);
}

/*
	Name: make_zone_adjacent
	Namespace: zm_zonemgr
	Checksum: 0xE33B129F
	Offset: 0x1DB0
	Size: 0x195
	Parameters: 3
	Flags: None
*/
function make_zone_adjacent(main_zone_name, adj_zone_name, flag_name)
{
	main_zone = level.zones[main_zone_name];
	if(!isdefined(main_zone.adjacent_zones[adj_zone_name]))
	{
		main_zone.adjacent_zones[adj_zone_name] = spawnstruct();
		adj_zone = main_zone.adjacent_zones[adj_zone_name];
		adj_zone.is_connected = 0;
		adj_zone.flags_do_or_check = 0;
		if(IsArray(flag_name))
		{
			adj_zone.flags = flag_name;
		}
		else
		{
			adj_zone.flags[0] = flag_name;
		}
	}
	else
	{
		Assert(!IsArray(flag_name), "Dev Block strings are not supported");
		adj_zone = main_zone.adjacent_zones[adj_zone_name];
		SIZE = adj_zone.flags.size;
		adj_zone.flags_do_or_check = 1;
		adj_zone.flags[SIZE] = flag_name;
	}
	/#
	#/
}

/*
	Name: add_zone_flags
	Namespace: zm_zonemgr
	Checksum: 0xEF55DE66
	Offset: 0x1F50
	Size: 0x10D
	Parameters: 2
	Flags: None
*/
function add_zone_flags(wait_flag, add_flags)
{
	if(!IsArray(add_flags))
	{
		temp = add_flags;
		add_flags = [];
		add_flags[0] = temp;
	}
	keys = getArrayKeys(level.zone_flags);
	for(i = 0; i < keys.size; i++)
	{
		if(keys[i] == wait_flag)
		{
			level.zone_flags[keys[i]] = ArrayCombine(level.zone_flags[keys[i]], add_flags, 1, 0);
			return;
		}
	}
	level.zone_flags[wait_flag] = add_flags;
}

/*
	Name: add_adjacent_zone
	Namespace: zm_zonemgr
	Checksum: 0xAF93031C
	Offset: 0x2068
	Size: 0xEB
	Parameters: 6
	Flags: None
*/
function add_adjacent_zone(zone_name_a, zone_name_b, flag_name, one_way, zone_tag_a, zone_tag_b)
{
	if(!isdefined(one_way))
	{
		one_way = 0;
	}
	if(!isdefined(level.flag[flag_name]))
	{
		level flag::init(flag_name);
	}
	zone_init(zone_name_a, zone_tag_a);
	zone_init(zone_name_b, zone_tag_b);
	make_zone_adjacent(zone_name_a, zone_name_b, flag_name);
	if(!one_way)
	{
		make_zone_adjacent(zone_name_b, zone_name_a, flag_name);
	}
}

/*
	Name: setup_zone_flag_waits
	Namespace: zm_zonemgr
	Checksum: 0x822AC094
	Offset: 0x2160
	Size: 0x1B5
	Parameters: 0
	Flags: None
*/
function setup_zone_flag_waits()
{
	flags = [];
	zkeys = getArrayKeys(level.zones);
	for(z = 0; z < level.zones.size; z++)
	{
		zone = level.zones[zkeys[z]];
		azkeys = getArrayKeys(zone.adjacent_zones);
		for(az = 0; az < zone.adjacent_zones.size; az++)
		{
			azone = zone.adjacent_zones[azkeys[az]];
			for(f = 0; f < azone.flags.size; f++)
			{
				Array::add(flags, azone.flags[f], 0);
			}
		}
	}
	for(i = 0; i < flags.size; i++)
	{
		level thread zone_flag_wait(flags[i]);
	}
}

/*
	Name: wait_zone_flags_updating
	Namespace: zm_zonemgr
	Checksum: 0x3E1D6EA6
	Offset: 0x2320
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function wait_zone_flags_updating()
{
	if(!isdefined(level.zone_flags_updating))
	{
		level.zone_flags_updating = 0;
	}
	while(level.zone_flags_updating > 0)
	{
		wait(0.05);
	}
}

/*
	Name: zone_flag_wait_throttle
	Namespace: zm_zonemgr
	Checksum: 0x9ED5E9C1
	Offset: 0x2360
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function zone_flag_wait_throttle()
{
	if(!isdefined(level.zone_flag_wait_throttle))
	{
		level.zone_flag_wait_throttle = 0;
	}
	level.zone_flag_wait_throttle++;
	if(level.zone_flag_wait_throttle > 3)
	{
		level.zone_flag_wait_throttle = 0;
		wait(0.05);
	}
}

/*
	Name: zone_flag_wait
	Namespace: zm_zonemgr
	Checksum: 0xF4EC94A9
	Offset: 0x23B0
	Size: 0x41F
	Parameters: 1
	Flags: None
*/
function zone_flag_wait(flag_name)
{
	if(!isdefined(level.flag[flag_name]))
	{
		level flag::init(flag_name);
	}
	level flag::wait_till(flag_name);
	if(!isdefined(level.zone_flags_updating))
	{
		level.zone_flags_updating = 0;
	}
	level.zone_flags_updating++;
	flags_set = 0;
	for(z = 0; z < level.zones.size; z++)
	{
		zkeys = getArrayKeys(level.zones);
		zone = level.zones[zkeys[z]];
		for(az = 0; az < zone.adjacent_zones.size; az++)
		{
			azkeys = getArrayKeys(zone.adjacent_zones);
			azone = zone.adjacent_zones[azkeys[az]];
			if(!azone.is_connected)
			{
				if(azone.flags_do_or_check)
				{
					flags_set = 0;
					for(f = 0; f < azone.flags.size; f++)
					{
						if(level flag::get(azone.flags[f]))
						{
							flags_set = 1;
							break;
						}
					}
					break;
				}
				flags_set = 1;
				for(f = 0; f < azone.flags.size; f++)
				{
					if(!level flag::get(azone.flags[f]))
					{
						flags_set = 0;
					}
				}
				if(flags_set)
				{
					enable_zone(zkeys[z]);
					azone.is_connected = 1;
					if(!level.zones[azkeys[az]].is_enabled)
					{
						enable_zone(azkeys[az]);
					}
					if(level flag::get("door_can_close"))
					{
						azone thread door_close_disconnect(flag_name);
					}
				}
			}
		}
		zone_flag_wait_throttle();
	}
	keys = getArrayKeys(level.zone_flags);
	for(i = 0; i < keys.size; i++)
	{
		if(keys[i] == flag_name)
		{
			check_flag = level.zone_flags[keys[i]];
			for(K = 0; K < check_flag.size; K++)
			{
				level flag::set(check_flag[K]);
			}
			break;
		}
		zone_flag_wait_throttle();
	}
	level.zone_flags_updating--;
}

/*
	Name: door_close_disconnect
	Namespace: zm_zonemgr
	Checksum: 0xCBD92D88
	Offset: 0x27D8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function door_close_disconnect(flag_name)
{
	while(level flag::get(flag_name))
	{
		wait(1);
	}
	self.is_connected = 0;
	level thread zone_flag_wait(flag_name);
}

/*
	Name: connect_zones
	Namespace: zm_zonemgr
	Checksum: 0xE90F3F66
	Offset: 0x2840
	Size: 0x197
	Parameters: 3
	Flags: None
*/
function connect_zones(zone_name_a, zone_name_b, one_way)
{
	if(!isdefined(one_way))
	{
		one_way = 0;
	}
	zone_init(zone_name_a);
	zone_init(zone_name_b);
	enable_zone(zone_name_a);
	enable_zone(zone_name_b);
	if(!isdefined(level.zones[zone_name_a].adjacent_zones[zone_name_b]))
	{
		level.zones[zone_name_a].adjacent_zones[zone_name_b] = spawnstruct();
		level.zones[zone_name_a].adjacent_zones[zone_name_b].is_connected = 1;
	}
	if(!one_way)
	{
		if(!isdefined(level.zones[zone_name_b].adjacent_zones[zone_name_a]))
		{
			level.zones[zone_name_b].adjacent_zones[zone_name_a] = spawnstruct();
			level.zones[zone_name_b].adjacent_zones[zone_name_a].is_connected = 1;
		}
	}
}

/*
	Name: manage_zones
	Namespace: zm_zonemgr
	Checksum: 0x5B78664C
	Offset: 0x29E0
	Size: 0x88D
	Parameters: 1
	Flags: None
*/
function manage_zones(initial_zone)
{
	/#
		Assert(isdefined(initial_zone), "Dev Block strings are not supported");
	#/
	deactivate_initial_barrier_goals();
	level.player_zone_found = 1;
	zone_choke = 0;
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	for(i = 0; i < spawn_points.size; i++)
	{
		/#
			Assert(isdefined(spawn_points[i].script_noteworthy), "Dev Block strings are not supported");
		#/
		spawn_points[i].locked = 1;
	}
	if(isdefined(level.zone_manager_init_func))
	{
		[[level.zone_manager_init_func]]();
	}
	/#
		println("Dev Block strings are not supported" + initial_zone.size);
	#/
	if(IsArray(initial_zone))
	{
		/#
			println("Dev Block strings are not supported" + initial_zone[0]);
		#/
		for(i = 0; i < initial_zone.size; i++)
		{
			zone_init(initial_zone[i]);
			enable_zone(initial_zone[i]);
		}
	}
	else
	{
		println("Dev Block strings are not supported" + initial_zone);
		zone_init(initial_zone);
		enable_zone(initial_zone);
	}
	/#
	#/
	setup_zone_flag_waits();
	zkeys = getArrayKeys(level.zones);
	level.zone_keys = zkeys;
	level.newzones = [];
	for(z = 0; z < zkeys.size; z++)
	{
		level.newzones[zkeys[z]] = spawnstruct();
	}
	oldzone = undefined;
	level flag::set("zones_initialized");
	level flag::wait_till("begin_spawning");
	/#
		level thread _debug_zones();
	#/
	while(GetDvarInt("noclip") == 0 || GetDvarInt("notarget") != 0)
	{
		wait_zone_flags_updating();
		for(z = 0; z < zkeys.size; z++)
		{
			level.newzones[zkeys[z]].is_active = 0;
			level.newzones[zkeys[z]].is_occupied = 0;
		}
		a_zone_is_active = 0;
		a_zone_is_spawning_allowed = 0;
		level.zone_scanning_active = 1;
		for(z = 0; z < zkeys.size; z++)
		{
			zone = level.zones[zkeys[z]];
			newzone = level.newzones[zkeys[z]];
			if(!zone.is_enabled)
			{
				continue;
			}
			if(isdefined(level.zone_occupied_func))
			{
				newzone.is_occupied = [[level.zone_occupied_func]](zkeys[z]);
			}
			else
			{
				newzone.is_occupied = any_player_in_zone(zkeys[z]);
			}
			if(newzone.is_occupied)
			{
				newzone.is_active = 1;
				a_zone_is_active = 1;
				if(zone.is_spawning_allowed)
				{
					a_zone_is_spawning_allowed = 1;
				}
				if(!isdefined(oldzone) || oldzone != newzone)
				{
					level notify("newzoneActive", zkeys[z]);
					oldzone = newzone;
				}
				azkeys = getArrayKeys(zone.adjacent_zones);
				for(az = 0; az < zone.adjacent_zones.size; az++)
				{
					if(zone.adjacent_zones[azkeys[az]].is_connected && level.zones[azkeys[az]].is_enabled)
					{
						level.newzones[azkeys[az]].is_active = 1;
						if(level.zones[azkeys[az]].is_spawning_allowed)
						{
							a_zone_is_spawning_allowed = 1;
						}
					}
				}
			}
			zone_choke++;
			if(zone_choke >= 3)
			{
				zone_choke = 0;
				wait(0.05);
				wait_zone_flags_updating();
			}
		}
		level.zone_scanning_active = 0;
		for(z = 0; z < zkeys.size; z++)
		{
			level.zones[zkeys[z]].is_active = level.newzones[zkeys[z]].is_active;
			level.zones[zkeys[z]].is_occupied = level.newzones[zkeys[z]].is_occupied;
		}
		if(!a_zone_is_active || !a_zone_is_spawning_allowed)
		{
			if(IsArray(initial_zone))
			{
				level.zones[initial_zone[0]].is_active = 1;
				level.zones[initial_zone[0]].is_occupied = 1;
				level.zones[initial_zone[0]].is_spawning_allowed = 1;
			}
			else
			{
				level.zones[initial_zone].is_active = 1;
				level.zones[initial_zone].is_occupied = 1;
				level.zones[initial_zone].is_spawning_allowed = 1;
			}
			level.player_zone_found = 0;
		}
		else
		{
			level.player_zone_found = 1;
		}
		[[level.create_spawner_list_func]](zkeys);
		/#
			debug_show_spawn_locations();
		#/
		level.active_zone_names = get_active_zone_names();
		wait(1);
	}
}

/*
	Name: debug_show_spawn_locations
	Namespace: zm_zonemgr
	Checksum: 0x841CB850
	Offset: 0x3278
	Size: 0x161
	Parameters: 0
	Flags: None
*/
function debug_show_spawn_locations()
{
	/#
		if(isdefined(level.toggle_show_spawn_locations) && level.toggle_show_spawn_locations)
		{
			host_player = util::getHostPlayer();
			foreach(location in level.zm_loc_types["Dev Block strings are not supported"])
			{
				Distance = Distance(location.origin, host_player.origin);
				color = (0, 0, 1);
				if(Distance > GetDvarInt("Dev Block strings are not supported") * 12)
				{
					color = (1, 0, 0);
				}
				debugstar(location.origin, GetDvarInt("Dev Block strings are not supported"), color);
			}
		}
	#/
}

/*
	Name: old_manage_zones
	Namespace: zm_zonemgr
	Checksum: 0x52D939F
	Offset: 0x33E8
	Size: 0x67D
	Parameters: 1
	Flags: None
*/
function old_manage_zones(initial_zone)
{
	/#
		Assert(isdefined(initial_zone), "Dev Block strings are not supported");
	#/
	deactivate_initial_barrier_goals();
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	for(i = 0; i < spawn_points.size; i++)
	{
		/#
			Assert(isdefined(spawn_points[i].script_noteworthy), "Dev Block strings are not supported");
		#/
		spawn_points[i].locked = 1;
	}
	if(isdefined(level.zone_manager_init_func))
	{
		[[level.zone_manager_init_func]]();
	}
	/#
		println("Dev Block strings are not supported" + initial_zone.size);
	#/
	if(IsArray(initial_zone))
	{
		/#
			println("Dev Block strings are not supported" + initial_zone[0]);
		#/
		for(i = 0; i < initial_zone.size; i++)
		{
			zone_init(initial_zone[i]);
			enable_zone(initial_zone[i]);
		}
	}
	else
	{
		println("Dev Block strings are not supported" + initial_zone);
		zone_init(initial_zone);
		enable_zone(initial_zone);
	}
	/#
	#/
	setup_zone_flag_waits();
	zkeys = getArrayKeys(level.zones);
	level.zone_keys = zkeys;
	level flag::set("zones_initialized");
	level flag::wait_till("begin_spawning");
	/#
		level thread _debug_zones();
	#/
	while(GetDvarInt("noclip") == 0 || GetDvarInt("notarget") != 0)
	{
		for(z = 0; z < zkeys.size; z++)
		{
			level.zones[zkeys[z]].is_active = 0;
			level.zones[zkeys[z]].is_occupied = 0;
		}
		a_zone_is_active = 0;
		a_zone_is_spawning_allowed = 0;
		for(z = 0; z < zkeys.size; z++)
		{
			zone = level.zones[zkeys[z]];
			if(!zone.is_enabled)
			{
				break;
			}
			if(isdefined(level.zone_occupied_func))
			{
				zone.is_occupied = [[level.zone_occupied_func]](zkeys[z]);
			}
			else
			{
				zone.is_occupied = any_player_in_zone(zkeys[z]);
			}
			if(zone.is_occupied)
			{
				zone.is_active = 1;
				a_zone_is_active = 1;
				if(zone.is_spawning_allowed)
				{
					a_zone_is_spawning_allowed = 1;
				}
				azkeys = getArrayKeys(zone.adjacent_zones);
				for(az = 0; az < zone.adjacent_zones.size; az++)
				{
					if(zone.adjacent_zones[azkeys[az]].is_connected && level.zones[azkeys[az]].is_enabled)
					{
						level.zones[azkeys[az]].is_active = 1;
						if(level.zones[azkeys[az]].is_spawning_allowed)
						{
							a_zone_is_spawning_allowed = 1;
						}
					}
				}
			}
		}
		if(!a_zone_is_active || !a_zone_is_spawning_allowed)
		{
			if(IsArray(initial_zone))
			{
				level.zones[initial_zone[0]].is_active = 1;
				level.zones[initial_zone[0]].is_occupied = 1;
				level.zones[initial_zone[0]].is_spawning_allowed = 1;
			}
			else
			{
				level.zones[initial_zone].is_active = 1;
				level.zones[initial_zone].is_occupied = 1;
				level.zones[initial_zone].is_spawning_allowed = 1;
			}
		}
		[[level.create_spawner_list_func]](zkeys);
		level.active_zone_names = get_active_zone_names();
		wait(1);
	}
}

/*
	Name: create_spawner_list
	Namespace: zm_zonemgr
	Checksum: 0xEC83FD3F
	Offset: 0x3A70
	Size: 0x35D
	Parameters: 1
	Flags: None
*/
function create_spawner_list(zkeys)
{
	foreach(a_locs in level.zm_loc_types)
	{
		level.zm_loc_types[str_index] = [];
	}
	for(z = 0; z < zkeys.size; z++)
	{
		zone = level.zones[zkeys[z]];
		if(zone.is_enabled && zone.is_active && zone.is_spawning_allowed)
		{
			foreach(a_locs in zone.a_loc_types)
			{
				foreach(loc in a_locs)
				{
					if(isdefined(loc.is_enabled) && loc.is_enabled == 0)
					{
						break;
					}
					tokens = StrTok(loc.script_noteworthy, " ");
					foreach(token in tokens)
					{
						switch(token)
						{
							case "custom_spawner_entry":
							case "faller_location":
							case "riser_location":
							case "spawn_location":
							{
								Array::add(level.zm_loc_types["zombie_location"], loc, 0);
								break;
							}
							case default:
							{
								if(!isdefined(level.zm_loc_types[token]))
								{
									level.zm_loc_types[token] = [];
								}
								Array::add(level.zm_loc_types[token], loc, 0);
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: get_active_zone_names
	Namespace: zm_zonemgr
	Checksum: 0x656CDE60
	Offset: 0x3DD8
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function get_active_zone_names()
{
	ret_list = [];
	if(!isdefined(level.zone_keys))
	{
		return ret_list;
	}
	while(level.zone_scanning_active)
	{
		wait(0.05);
	}
	for(i = 0; i < level.zone_keys.size; i++)
	{
		if(level.zones[level.zone_keys[i]].is_active)
		{
			ret_list[ret_list.size] = level.zone_keys[i];
		}
	}
	return ret_list;
}

/*
	Name: get_active_zones_entities
	Namespace: zm_zonemgr
	Checksum: 0x1A3DB6A9
	Offset: 0x3E90
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function get_active_zones_entities()
{
	a_player_zones = GetEntArray("player_volume", "script_noteworthy");
	a_active_zones = [];
	for(i = 0; i < a_player_zones.size; i++)
	{
		e_zone = a_player_zones[i];
		zone = level.zones[e_zone.targetname];
		if(isdefined(zone) && (isdefined(zone.is_enabled) && zone.is_enabled))
		{
			a_active_zones[a_active_zones.size] = e_zone;
		}
	}
	return a_active_zones;
}

/*
	Name: _init_debug_zones
	Namespace: zm_zonemgr
	Checksum: 0x31107122
	Offset: 0x3F88
	Size: 0x2C5
	Parameters: 0
	Flags: None
*/
function _init_debug_zones()
{
	level.last_debug_zone_index = 0;
	current_y = 30;
	current_x = 20;
	xloc = [];
	xloc[0] = 50;
	xloc[1] = 60;
	xloc[2] = 100;
	xloc[3] = 130;
	xloc[4] = 170;
	xloc[5] = 220;
	zkeys = getArrayKeys(level.zones);
	for(i = 0; i < zkeys.size; i++)
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];
		zone.debug_hud = [];
		/#
			for(j = 0; j < 6; j++)
			{
				zone.debug_hud[j] = NewDebugHudElem();
				if(!j)
				{
					zone.debug_hud[j].alignX = "Dev Block strings are not supported";
				}
				else
				{
					zone.debug_hud[j].alignX = "Dev Block strings are not supported";
				}
				zone.debug_hud[j].x = xloc[j];
				zone.debug_hud[j].y = current_y;
			}
			if(i == 40)
			{
				for(x = 0; x < xloc.size; x++)
				{
					xloc[x] = xloc[x] + 350;
				}
				current_y = 30;
			}
			else
			{
				current_y = current_y + 10;
			}
			zone.debug_hud[0] setText(zoneName);
		#/
	}
}

/*
	Name: _destroy_debug_zones
	Namespace: zm_zonemgr
	Checksum: 0x629F0065
	Offset: 0x4258
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function _destroy_debug_zones()
{
	level.last_debug_zone_index = undefined;
	zkeys = getArrayKeys(level.zones);
	for(i = 0; i < zkeys.size; i++)
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];
		for(j = 0; j < 6; j++)
		{
			zone.debug_hud[j] destroy();
			zone.debug_hud[j] = undefined;
		}
	}
}

/*
	Name: _debug_show_zone
	Namespace: zm_zonemgr
	Checksum: 0x9E5A79E0
	Offset: 0x4350
	Size: 0x129
	Parameters: 3
	Flags: None
*/
function _debug_show_zone(zone, color, alpha)
{
	if(isdefined(zone))
	{
		foreach(volume in zone.Volumes)
		{
			if(!isdefined(color) || !isdefined(alpha))
			{
				ShowInfoVolume(volume GetEntityNumber(), (0.2, 0.5, 0), 0.05);
				continue;
			}
			ShowInfoVolume(volume GetEntityNumber(), color, alpha);
		}
	}
}

/*
	Name: _debug_zones
	Namespace: zm_zonemgr
	Checksum: 0x98F36604
	Offset: 0x4488
	Size: 0x543
	Parameters: 0
	Flags: None
*/
function _debug_zones()
{
	enabled = 0;
	if(GetDvarString("zombiemode_debug_zones") == "")
	{
		SetDvar("zombiemode_debug_zones", "0");
	}
	InfoVolumeDebugInit();
	zkeys = getArrayKeys(level.zones);
	for(i = 0; i < zkeys.size; i++)
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];
		_debug_show_zone(zone, (RandomFloatRange(0, 1), RandomFloatRange(0, 1), RandomFloatRange(0, 1)), 0.2);
	}
	while(1)
	{
		wasEnabled = enabled;
		enabled = GetDvarInt("zombiemode_debug_zones");
		if(enabled && !wasEnabled)
		{
			_init_debug_zones();
		}
		else if(!enabled && wasEnabled)
		{
			_destroy_debug_zones();
		}
		occupied_zone = undefined;
		if(enabled)
		{
			zkeys = getArrayKeys(level.zones);
			for(i = 0; i < zkeys.size; i++)
			{
				zoneName = zkeys[i];
				zone = level.zones[zoneName];
				text = zoneName;
				zone.debug_hud[0] setText(text);
				if(zone.is_enabled)
				{
					text = text + " Enabled";
					zone.debug_hud[1] setText("Enabled");
				}
				else
				{
					zone.debug_hud[1] setText("");
				}
				if(zone.is_active)
				{
					text = text + " Active";
					zone.debug_hud[2] setText("Active");
				}
				else
				{
					zone.debug_hud[2] setText("");
				}
				if(zone.is_occupied)
				{
					text = text + " Occupied";
					zone.debug_hud[3] setText("Occupied");
					occupied_zone = zone;
				}
				else
				{
					zone.debug_hud[3] setText("");
				}
				if(zone.is_spawning_allowed)
				{
					text = text + " SpawnOK";
					zone.debug_hud[4] setText("SpawnOK");
				}
				else
				{
					zone.debug_hud[4] setText("");
				}
				/#
					text = text + zone.a_loc_types["Dev Block strings are not supported"].size + "Dev Block strings are not supported";
					zone.debug_hud[5] setText(zone.a_loc_types["Dev Block strings are not supported"].size + "Dev Block strings are not supported" + zone.total_spawn_count + "Dev Block strings are not supported" + zone.round_spawn_count);
				#/
			}
		}
		wait(0.1);
	}
}

