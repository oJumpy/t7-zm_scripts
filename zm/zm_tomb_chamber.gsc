#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_tomb_utility;

#namespace zm_tomb_chamber;

/*
	Name: __init__sytem__
	Namespace: zm_tomb_chamber
	Checksum: 0x6822CA56
	Offset: 0x270
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_tomb_chamber", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_tomb_chamber
	Checksum: 0x720F42CF
	Offset: 0x2B0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "divider_fx", 21000, 1, "counter");
}

/*
	Name: main
	Namespace: zm_tomb_chamber
	Checksum: 0x90F11457
	Offset: 0x2F0
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread chamber_wall_change_randomly();
	a_walls = GetEntArray("chamber_wall", "script_noteworthy");
	foreach(e_wall in a_walls)
	{
		e_wall.down_origin = e_wall.origin;
		e_wall.up_origin = (e_wall.origin[0], e_wall.origin[1], e_wall.origin[2] + 1000);
	}
	level.n_chamber_wall_active = 0;
	level flag::wait_till("start_zombie_round_logic");
	wait(3);
	foreach(e_wall in a_walls)
	{
		e_wall moveto(e_wall.up_origin, 0.05);
		e_wall connectpaths();
	}
	/#
		level thread chamber_devgui();
	#/
}

/*
	Name: chamber_devgui
	Namespace: zm_tomb_chamber
	Checksum: 0x1C921373
	Offset: 0x508
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function chamber_devgui()
{
	/#
		SetDvar("Dev Block strings are not supported", 5);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		level thread watch_chamber_wall();
	#/
}

/*
	Name: watch_chamber_wall
	Namespace: zm_tomb_chamber
	Checksum: 0xB60E131
	Offset: 0x5D0
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function watch_chamber_wall()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") != 5)
			{
				chamber_change_walls(GetDvarInt("Dev Block strings are not supported"));
				SetDvar("Dev Block strings are not supported", 5);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: cap_value
	Namespace: zm_tomb_chamber
	Checksum: 0x6DA7302C
	Offset: 0x668
	Size: 0x51
	Parameters: 3
	Flags: None
*/
function cap_value(VAL, min, max)
{
	if(VAL < min)
	{
		return min;
	}
	else if(VAL > max)
	{
		return max;
	}
	else
	{
		return VAL;
	}
}

/*
	Name: chamber_change_walls
	Namespace: zm_tomb_chamber
	Checksum: 0x8FD2D0FA
	Offset: 0x6C8
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function chamber_change_walls(n_element)
{
	if(n_element == level.n_chamber_wall_active)
	{
		return;
	}
	e_current_wall = undefined;
	e_new_wall = undefined;
	playsoundatposition("zmb_chamber_wallchange", (10342, -7921, -272));
	a_walls = GetEntArray("chamber_wall", "script_noteworthy");
	foreach(e_wall in a_walls)
	{
		if(e_wall.script_int == n_element)
		{
			e_wall thread move_wall_down();
			continue;
		}
		if(e_wall.script_int == level.n_chamber_wall_active)
		{
			e_wall thread move_wall_up();
		}
	}
	level.n_chamber_wall_active = n_element;
}

/*
	Name: is_chamber_occupied
	Namespace: zm_tomb_chamber
	Checksum: 0xC111772A
	Offset: 0x840
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function is_chamber_occupied()
{
	a_players = GetPlayers();
	foreach(e_player in a_players)
	{
		if(is_point_in_chamber(e_player.origin))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: is_point_in_chamber
	Namespace: zm_tomb_chamber
	Checksum: 0x863250C1
	Offset: 0x900
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function is_point_in_chamber(v_origin)
{
	if(!isdefined(level.s_chamber_center))
	{
		level.s_chamber_center = struct::get("chamber_center", "targetname");
		level.s_chamber_center.radius_sq = level.s_chamber_center.script_float * level.s_chamber_center.script_float;
	}
	return Distance2DSquared(level.s_chamber_center.origin, v_origin) < level.s_chamber_center.radius_sq;
}

/*
	Name: chamber_wall_change_randomly
	Namespace: zm_tomb_chamber
	Checksum: 0xCFE789CC
	Offset: 0x9B8
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function chamber_wall_change_randomly()
{
	level flag::wait_till("start_zombie_round_logic");
	a_element_enums = Array(1, 2, 3, 4);
	level endon("stop_random_chamber_walls");
	n_elem_prev = undefined;
	while(1)
	{
		while(!is_chamber_occupied())
		{
			wait(1);
		}
		level flag::wait_till("any_crystal_picked_up");
		n_round = cap_value(level.round_number, 10, 30);
		f_progression_pct = n_round - 10 / 30 - 10;
		n_change_wall_time = LerpFloat(15, 5, f_progression_pct);
		n_elem = Array::random(a_element_enums);
		ArrayRemoveValue(a_element_enums, n_elem, 0);
		if(isdefined(n_elem_prev))
		{
			a_element_enums[a_element_enums.size] = n_elem_prev;
		}
		chamber_change_walls(n_elem);
		wait(n_change_wall_time);
		n_elem_prev = n_elem;
	}
}

/*
	Name: move_wall_up
	Namespace: zm_tomb_chamber
	Checksum: 0x68444F8B
	Offset: 0xB90
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function move_wall_up()
{
	self moveto(self.up_origin, 1);
	self waittill("movedone");
	self connectpaths();
}

/*
	Name: move_wall_down
	Namespace: zm_tomb_chamber
	Checksum: 0x5B5EB426
	Offset: 0xBE0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function move_wall_down()
{
	self moveto(self.down_origin, 1);
	self waittill("movedone");
	zm_tomb_utility::rumble_players_in_chamber(2, 0.1);
	self clientfield::increment("divider_fx");
	self disconnectpaths();
}

/*
	Name: random_shuffle
	Namespace: zm_tomb_chamber
	Checksum: 0x944ABA54
	Offset: 0xC70
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function random_shuffle(a_items, item)
{
	b_done_shuffling = undefined;
	if(!isdefined(item))
	{
		item = a_items[a_items.size - 1];
	}
	while(!(isdefined(b_done_shuffling) && b_done_shuffling))
	{
		a_items = Array::randomize(a_items);
		if(a_items[0] != item)
		{
			b_done_shuffling = 1;
		}
		wait(0.05);
	}
	return a_items;
}

/*
	Name: tomb_chamber_find_exit_point
	Namespace: zm_tomb_chamber
	Checksum: 0x2DB07A5
	Offset: 0xD18
	Size: 0x217
	Parameters: 0
	Flags: None
*/
function tomb_chamber_find_exit_point()
{
	self endon("death");
	player = GetPlayers()[0];
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	away = VectorNormalize(self.origin - player.origin);
	endPos = self.origin + VectorScale(away, 600);
	locs = Array::randomize(level.zm_loc_types["wait_location"]);
	for(i = 0; i < locs.size; i++)
	{
		dist_zombie = DistanceSquared(locs[i].origin, endPos);
		dist_player = DistanceSquared(locs[i].origin, player.origin);
		if(dist_zombie < dist_player)
		{
			dest = i;
			break;
		}
	}
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	if(isdefined(locs[dest]))
	{
		self setgoalpos(locs[dest].origin);
	}
	self.b_wandering_in_chamber = 1;
	level flag::wait_till("player_active_in_chamber");
	self.b_wandering_in_chamber = 0;
}

/*
	Name: chamber_zombies_find_poi
	Namespace: zm_tomb_chamber
	Checksum: 0xB5071755
	Offset: 0xF38
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function chamber_zombies_find_poi()
{
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		if(isdefined(zombies[i].b_wandering_in_chamber) && zombies[i].b_wandering_in_chamber)
		{
			continue;
		}
		if(!is_point_in_chamber(zombies[i].origin))
		{
			continue;
		}
		zombies[i] thread tomb_chamber_find_exit_point();
	}
}

/*
	Name: tomb_is_valid_target_in_chamber
	Namespace: zm_tomb_chamber
	Checksum: 0xAA700FB9
	Offset: 0x1008
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function tomb_is_valid_target_in_chamber()
{
	a_players = GetPlayers();
	foreach(e_player in a_players)
	{
		if(e_player laststand::player_is_in_laststand())
		{
			continue;
		}
		if(isdefined(e_player.b_zombie_blood) && e_player.b_zombie_blood || (isdefined(e_player.ignoreme) && e_player.ignoreme))
		{
			continue;
		}
		if(!is_point_in_chamber(e_player.origin))
		{
			continue;
		}
		return 1;
	}
	return 0;
}

/*
	Name: is_player_in_chamber
	Namespace: zm_tomb_chamber
	Checksum: 0xD97DED6C
	Offset: 0x1130
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function is_player_in_chamber()
{
	if(is_point_in_chamber(self.origin))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: tomb_watch_chamber_player_activity
	Namespace: zm_tomb_chamber
	Checksum: 0xCF2751A9
	Offset: 0x1168
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function tomb_watch_chamber_player_activity()
{
	level flag::init("player_active_in_chamber");
	level flag::wait_till("start_zombie_round_logic");
	while(1)
	{
		wait(1);
		if(is_chamber_occupied())
		{
			if(tomb_is_valid_target_in_chamber())
			{
				level flag::set("player_active_in_chamber");
			}
			else
			{
				level flag::clear("player_active_in_chamber");
				chamber_zombies_find_poi();
			}
		}
	}
}

