#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_castle_cleanup_mgr;
#using scripts\zm\zm_castle_zombie;

#namespace namespace_6b519a03;

/*
	Name: main_start
	Namespace: namespace_6b519a03
	Checksum: 0x31B116FF
	Offset: 0x400
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function main_start()
{
	level.var_42792b8b = 1;
}

/*
	Name: main_end
	Namespace: namespace_6b519a03
	Checksum: 0xACC763F1
	Offset: 0x418
	Size: 0x813
	Parameters: 0
	Flags: None
*/
function main_end()
{
	spawncollision("collision_monster_wall_256x256x10", "collider", (1519, 1051.5, 210), VectorScale((0, 1, 0), 5.49973));
	spawncollision("collision_monster_wall_128x128x10", "collider", (1763.25, 1340.5, 307), VectorScale((0, 1, 0), 335.598));
	spawncollision("collision_monster_wall_128x128x10", "collider", (1685, 1245, 296.75), VectorScale((0, 1, 0), 305.119));
	spawncollision("collision_monster_wall_128x128x10", "collider", (1574.5, 1193.75, 270.25), VectorScale((0, 1, 0), 283.009));
	spawncollision("collision_monster_wall_128x128x10", "collider", (1555, 871.75, 191.75), VectorScale((0, 1, 0), 21.1991));
	spawncollision("collision_clip_32x32x128", "collider", (-710.68, 2255.49, 401.158), (32.1356, 340.445, 17.6571));
	spawncollision("collision_clip_32x32x128", "collider", (-710.816, 2257.55, 401.282), (31.048, 25.5567, -10.7585));
	spawncollision("collision_clip_wall_256x256x10", "collider", (1180, 2991, 633), (0, 0, 0));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-350.335, 2012.799, 834), (270, 0.2, 33.5993));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-392.558, 1842.61, 834), (270, 359.8, 27.3984));
	spawncollision("collision_clip_32x32x128", "collider", (-472, 1950, 823), (270, 284.042, -14.0418));
	spawncollision("collision_clip_64x64x256", "collider", (-192.968, 1677.31, 968), VectorScale((0, 1, 0), 334.399));
	spawncollision("collision_clip_wedge_32x128", "collider", (-1630.27, 2540.83, 330.354), (295, 342.199, -89.999));
	spawncollision("collision_clip_wall_256x256x10", "collider", (724, 2835, 332), VectorScale((0, 1, 0), 270));
	spawncollision("collision_clip_64x64x256", "collider", (1144, 1869, 803), VectorScale((0, 1, 0), 45));
	spawncollision("collision_clip_ramp_256x24", "collider", (-852, 1808, 237), (0, 180, 90));
	spawncollision("collision_clip_ramp_256x24", "collider", (48.4593, 784.8, 280.078), (89.999, 252.348, -72.6515));
	spawncollision("collision_clip_ramp_256x24", "collider", (-954.754, 2905.79, 792), (270, 0.2, 8.59951));
	spawncollision("collision_clip_ramp_256x24", "collider", (-759.689, 2907.04, 792), (89.9997, 357.416, 1.61555));
	spawncollision("collision_clip_wall_128x128x10", "collider", (-589.48, 2435.78, 399.528), (3.79981, 210.2, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (-550, 2414.02, 399.528), (3.79986, 270, -6.15847E-07));
	spawncollision("collision_clip_wall_128x128x10", "collider", (-513.245, 2434.79, 399.528), (3.79981, 327.799, -1.35792E-06));
	zm::spawn_kill_brush((864, 2664, 408), 72, 128);
	zm::spawn_kill_brush((960, 2680, 408), 72, 128);
	zm::spawn_kill_brush((1080, 2672, 408), 72, 128);
	zm::spawn_kill_brush((1328, 928, 64), 92, 43);
	zm::spawn_kill_brush((-616, 2160, 616), 75, 128);
	zm::spawn_kill_brush((-544, 2160, 616), 75, 128);
	spawncollision("collision_clip_ramp_256x24", "collider", (456, 3459, 816), VectorScale((0, 0, -1), 90));
	spawncollision("collision_clip_wall_128x128x10", "collider", (456, 3442, 844), VectorScale((0, 1, 0), 270));
	zm::spawn_kill_brush((1200, 928, 64), 92, 43);
	level thread function_965d5385();
	level thread function_78328cd0();
	level.no_target_override = &function_c428951;
	level.player_score_override = &function_d6da0785;
	level.player_intersection_tracker_override = &function_401305fb;
}

/*
	Name: function_965d5385
	Namespace: namespace_6b519a03
	Checksum: 0x9B2077EE
	Offset: 0xC38
	Size: 0x235
	Parameters: 0
	Flags: None
*/
function function_965d5385()
{
	a_s_spawn_pos = struct::get_array("zone_tram_to_gatehouse_spawners", "targetname");
	for(i = 0; i < a_s_spawn_pos.size; i++)
	{
		if(a_s_spawn_pos[i].origin == (1550.5, 1291.7, 243.239))
		{
			a_s_spawn_pos[i].angles = VectorScale((0, 1, 0), 180);
		}
	}
	var_5381c01a = struct::get_array("player_respawn_point", "targetname");
	foreach(var_81cac751 in var_5381c01a)
	{
		if(var_81cac751.script_noteworthy === "zone_gatehouse")
		{
			var_e50cc92f = struct::get_array(var_81cac751.target, "targetname");
			foreach(var_59fe7f49 in var_e50cc92f)
			{
				function_b1c9999(var_59fe7f49);
			}
			var_81cac751.origin = (1504, 1536, 480);
		}
	}
}

/*
	Name: function_b1c9999
	Namespace: namespace_6b519a03
	Checksum: 0xE7EF05F5
	Offset: 0xE78
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function function_b1c9999(var_59fe7f49)
{
	switch(var_59fe7f49.script_noteworthy)
	{
		case "player_1":
		{
			var_59fe7f49.origin = (1472, 1568, 470.609);
			break;
		}
		case "player_2":
		{
			var_59fe7f49.origin = (1536, 1568, 470.609);
			break;
		}
		case "player_3":
		{
			var_59fe7f49.origin = (1472, 1504, 465.043);
			break;
		}
		case "player_4":
		{
			var_59fe7f49.origin = (1536, 1504, 465.043);
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: function_78328cd0
	Namespace: namespace_6b519a03
	Checksum: 0xFC1A3F67
	Offset: 0xF68
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_78328cd0()
{
	var_7f68d264 = (5426, -2802, -2253);
	level thread function_f9f5dbb3(var_7f68d264);
	var_f170419f = (5521, -2364, -2253);
	level thread function_f9f5dbb3(var_f170419f);
}

/*
	Name: function_f9f5dbb3
	Namespace: namespace_6b519a03
	Checksum: 0xC9825762
	Offset: 0xFE8
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function function_f9f5dbb3(v_origin)
{
	var_640a9eac = spawn("trigger_box", v_origin, 9, 100, 128, 128);
	var_640a9eac.angles = VectorScale((0, 1, 0), 75.7984);
	var_640a9eac SetTeamForTrigger(level.zombie_team);
	while(1)
	{
		var_640a9eac waittill("trigger", e_who);
		e_who.no_powerups = 1;
		while(isalive(e_who) && e_who istouching(var_640a9eac))
		{
			wait(1);
		}
		if(isalive(e_who) && !level flag::get("rocket_firing"))
		{
			e_who.no_powerups = 0;
		}
	}
}

/*
	Name: function_c428951
	Namespace: namespace_6b519a03
	Checksum: 0x6733F32F
	Offset: 0x1138
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_c428951(ai_zombie)
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
	Namespace: namespace_6b519a03
	Checksum: 0x89805C5F
	Offset: 0x11A8
	Size: 0x145
	Parameters: 0
	Flags: Private
*/
function private get_escape_position()
{
	str_zone = zm_zonemgr::get_zone_from_position(self.origin + VectorScale((0, 0, 1), 32), 1);
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		a_zones = namespace_f59aa2e8::get_adjacencies_to_zone(str_zone);
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
	Name: get_wait_locations_in_zones
	Namespace: namespace_6b519a03
	Checksum: 0xA78BEFFF
	Offset: 0x12F8
	Size: 0xD1
	Parameters: 1
	Flags: Private
*/
function private get_wait_locations_in_zones(a_zones)
{
	a_wait_locations = [];
	foreach(zone in a_zones)
	{
		a_wait_locations = ArrayCombine(a_wait_locations, level.zones[zone].a_loc_types["wait_location"], 0, 0);
	}
	return a_wait_locations;
}

/*
	Name: function_eadbcbdb
	Namespace: namespace_6b519a03
	Checksum: 0x918D5C91
	Offset: 0x13D8
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

/*
	Name: function_dc683d01
	Namespace: namespace_6b519a03
	Checksum: 0x95C923E8
	Offset: 0x1440
	Size: 0xC9
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
	self util::waittill_any_timeout(30, "goal", "reaquire_player", "death");
	self.ai_state = "find_flesh";
	self.ignoreall = 0;
	self.var_c74f5ce8 = undefined;
}

/*
	Name: check_player_available
	Namespace: namespace_6b519a03
	Checksum: 0xDDD3520A
	Offset: 0x1518
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
	Namespace: namespace_6b519a03
	Checksum: 0x90E2E4CD
	Offset: 0x1598
	Size: 0x7F
	Parameters: 0
	Flags: Private
*/
function private can_zombie_see_any_player()
{
	for(i = 0; i < level.activePlayers.size; i++)
	{
		if(zombie_utility::is_player_valid(level.activePlayers[i]))
		{
			if(self namespace_e9d5a0ce::function_7b63bf24(level.activePlayers[i]))
			{
				return 1;
			}
		}
		wait(0.1);
	}
	return 0;
}

/*
	Name: function_d6da0785
	Namespace: namespace_6b519a03
	Checksum: 0x6CBCC355
	Offset: 0x1620
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function function_d6da0785(var_2f7fd5db, n_points)
{
	if(!isdefined(n_points))
	{
		return 0;
	}
	if(var_2f7fd5db === GetWeapon("hero_gravityspikes_melee") && n_points > 20)
	{
		n_points = 20;
	}
	return n_points;
}

/*
	Name: function_401305fb
	Namespace: namespace_6b519a03
	Checksum: 0x2E76BBF5
	Offset: 0x1688
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function function_401305fb(var_3c6a24bf)
{
	if(isdefined(self.var_122a2dda) && self.var_122a2dda || (isdefined(var_3c6a24bf.var_122a2dda) && var_3c6a24bf.var_122a2dda))
	{
		return 1;
	}
	return 0;
}

