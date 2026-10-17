#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_af029029;

/*
	Name: function_8e89793a
	Namespace: namespace_af029029
	Checksum: 0xF7CCA825
	Offset: 0x3E0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_8e89793a()
{
	level.var_ab7eb3d4 = 0;
	level.var_c102a998 = &function_c102a998;
	level thread function_419bf2ad();
}

/*
	Name: function_c102a998
	Namespace: namespace_af029029
	Checksum: 0x89BDFC37
	Offset: 0x428
	Size: 0x179
	Parameters: 0
	Flags: None
*/
function function_c102a998()
{
	wait(6);
	level flag::clear("spider_round_in_progress");
	foreach(player in level.players)
	{
		if(player IsPlayerUnderwater())
		{
			str_current_zone = player zm_utility::get_current_zone();
			if(isdefined(str_current_zone))
			{
				if(str_current_zone == "zone_start_water" || str_current_zone == "zone_meteor_site" || str_current_zone == "zone_meteor_site_2")
				{
					player clientfield::set_to_player("set_world_fog", 1);
				}
				else
				{
					player clientfield::set_to_player("set_world_fog", 2);
				}
			}
			continue;
		}
		player clientfield::increment_to_player("spider_end_of_round_reset", 1);
	}
}

/*
	Name: function_33aa4940
	Namespace: namespace_af029029
	Checksum: 0x89677D46
	Offset: 0x5B0
	Size: 0x397
	Parameters: 0
	Flags: None
*/
function function_33aa4940()
{
	b_spawn_spider = 0;
	var_622d2c20 = 0;
	if(level.round_number > 35)
	{
		if(RandomFloat(100) < 10)
		{
			b_spawn_spider = 1;
		}
	}
	else if(level.round_number > 30)
	{
		if(RandomFloat(100) < 8)
		{
			b_spawn_spider = 1;
		}
	}
	else if(level.round_number > 25)
	{
		if(RandomFloat(100) < 7)
		{
			b_spawn_spider = 1;
		}
	}
	else if(level.round_number > 20)
	{
		if(RandomFloat(100) < 5)
		{
			b_spawn_spider = 1;
		}
	}
	if(level.round_number > level.var_5ccd3661 && level.round_number > 7)
	{
		if(zm_zonemgr::any_player_in_zone("zone_spider_lair") || (zm_zonemgr::any_player_in_zone("zone_jungle_lab") || zm_zonemgr::any_player_in_zone("zone_jungle_lab_upper") && level.b_cage_down))
		{
			if(RandomFloat(100) < 30 && level.var_ab7eb3d4 < 3)
			{
				b_spawn_spider = 1;
				var_622d2c20 = 1;
			}
		}
	}
	if(b_spawn_spider)
	{
		if(var_622d2c20)
		{
			var_a5f01313 = struct::get_array("zone_spider_lair_spawners", "targetname");
			a_spider_spawners = [];
			foreach(s_spawner in var_a5f01313)
			{
				if(s_spawner.script_noteworthy == "spider_location")
				{
					if(!isdefined(a_spider_spawners))
					{
						a_spider_spawners = [];
					}
					else if(!IsArray(a_spider_spawners))
					{
						a_spider_spawners = Array(a_spider_spawners);
					}
					a_spider_spawners[a_spider_spawners.size] = s_spawner;
				}
			}
			namespace_27f8b154::special_spider_spawn(1, Array::random(a_spider_spawners));
			level.var_ab7eb3d4++;
		}
		else
		{
			namespace_27f8b154::special_spider_spawn(1);
		}
		level.zombie_total--;
	}
	return b_spawn_spider;
}

/*
	Name: function_419bf2ad
	Namespace: namespace_af029029
	Checksum: 0xBC786D21
	Offset: 0x950
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_419bf2ad()
{
	level endon("end_game");
	while(1)
	{
		level waittill("between_round_over");
		level.var_ab7eb3d4 = 0;
	}
}

