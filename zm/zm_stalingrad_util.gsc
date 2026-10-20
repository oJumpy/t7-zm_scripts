#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_dragon;

#namespace namespace_48c05c81;

/*
	Name: main
	Namespace: namespace_48c05c81
	Checksum: 0xE2F3BF56
	Offset: 0x610
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread function_828240c9();
	level thread flag_init();
	level thread function_28c0c208();
}

/*
	Name: flag_init
	Namespace: namespace_48c05c81
	Checksum: 0xD064ADFB
	Offset: 0x668
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function flag_init()
{
	level flag::init("wave_event_raz_spawning_active");
	level flag::init("wave_event_sentinel_spawning_active");
	level flag::init("wave_event_zombies_complete");
}

/*
	Name: function_828240c9
	Namespace: namespace_48c05c81
	Checksum: 0x350CE5D5
	Offset: 0x6D8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_828240c9()
{
	level waittill("start_zombie_round_logic");
	if(isdefined(level._custom_powerups["shield_charge"]))
	{
		ArrayRemoveIndex(level._custom_powerups, "shield_charge", 1);
	}
}

/*
	Name: function_e7c75cf0
	Namespace: namespace_48c05c81
	Checksum: 0xD330D8FF
	Offset: 0x730
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function function_e7c75cf0()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		e_player = players[i];
		e_player zm::spectator_respawn_player();
	}
}

/*
	Name: rotate_randomly
	Namespace: namespace_48c05c81
	Checksum: 0xB6DE9779
	Offset: 0x7B0
	Size: 0x18F
	Parameters: 0
	Flags: None
*/
function rotate_randomly()
{
	while(isdefined(self))
	{
		waitTime = RandomFloatRange(2.5, 5);
		yaw = RandomInt(360);
		if(yaw > 300)
		{
			yaw = 300;
		}
		else if(yaw < 60)
		{
			yaw = 60;
		}
		yaw = self.angles[1] + yaw;
		new_angles = (-60 + RandomInt(120), yaw, -45 + RandomInt(90));
		self RotateTo(new_angles, waitTime, waitTime * 0.5, waitTime * 0.5);
		if(isdefined(self.worldgundw))
		{
			self.worldgundw RotateTo(new_angles, waitTime, waitTime * 0.5, waitTime * 0.5);
		}
		wait(RandomFloat(waitTime - 0.1));
	}
}

/*
	Name: zombie_no_powerups
	Namespace: namespace_48c05c81
	Checksum: 0xB3BBDC95
	Offset: 0x948
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function zombie_no_powerups()
{
	self endon("death");
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
	{
		self waittill("completed_emerging_into_playable_area");
	}
	self.no_powerups = 1;
}

/*
	Name: function_1af75b1b
	Namespace: namespace_48c05c81
	Checksum: 0x4ACA42CC
	Offset: 0x990
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_1af75b1b(n_distance)
{
	foreach(e_player in level.players)
	{
		if(zm_utility::is_player_valid(e_player, 0, 1) && function_86b1188c(n_distance, self, e_player))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_86b1188c
	Namespace: namespace_48c05c81
	Checksum: 0xC6BB90F3
	Offset: 0xA60
	Size: 0x7D
	Parameters: 3
	Flags: None
*/
function function_86b1188c(n_distance, var_d21815c4, var_441f84ff)
{
	var_31dc18aa = n_distance * n_distance;
	var_2931dc75 = DistanceSquared(var_d21815c4.origin, var_441f84ff.origin);
	if(var_2931dc75 <= var_31dc18aa)
	{
		return 1;
	}
	return 0;
}

/*
	Name: disable_pap
	Namespace: namespace_48c05c81
	Checksum: 0x6E3E2CA0
	Offset: 0xAE8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function disable_pap(b_disable)
{
	if(!isdefined(b_disable))
	{
		b_disable = 1;
	}
	if(b_disable && level flag::get("pack_machine_in_use"))
	{
		level flag::wait_till_clear("pack_machine_in_use");
	}
	e_pap_trigger = GetEnt("pack_a_punch", "script_noteworthy");
	e_pap_trigger TriggerEnable(!b_disable);
}

/*
	Name: function_f8043960
	Namespace: namespace_48c05c81
	Checksum: 0xC5D6DD9A
	Offset: 0xBA0
	Size: 0x149
	Parameters: 4
	Flags: None
*/
function function_f8043960(var_57216c49, e_volume, var_50efb072, var_2f65a401)
{
	if(!isdefined(e_volume))
	{
		e_volume = undefined;
	}
	if(!isdefined(var_50efb072))
	{
		var_50efb072 = 1;
	}
	if(!isdefined(var_2f65a401))
	{
		var_2f65a401 = undefined;
	}
	while(1)
	{
		level waittill("hash_fbd59317", e_player);
		if(isdefined(var_2f65a401) && ![[var_2f65a401]](e_player))
		{
			continue;
		}
		if(isdefined(e_volume) && !e_player istouching(e_volume))
		{
			continue;
		}
		var_5572b89 = e_player function_7fbdcc5f(var_57216c49);
		if(isdefined(e_player))
		{
			e_player.var_9d9ac25d = undefined;
		}
		if(isdefined(var_5572b89) && var_5572b89)
		{
			if(isdefined(e_volume) && var_50efb072)
			{
				e_volume delete();
			}
			return;
		}
	}
}

/*
	Name: function_7fbdcc5f
	Namespace: namespace_48c05c81
	Checksum: 0x1C2701B7
	Offset: 0xCF8
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function function_7fbdcc5f(var_57216c49)
{
	self endon("death");
	self.dragon_whelp endon("death");
	self.var_9d9ac25d = 1;
	self.dragon_whelp vehicle_ai::start_scripted();
	var_5572b89 = self [[var_57216c49]]();
	self.dragon_whelp vehicle_ai::stop_scripted();
	if(isdefined(var_5572b89) && var_5572b89)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_adf4d1d0
	Namespace: namespace_48c05c81
	Checksum: 0x610A1BB
	Offset: 0xD98
	Size: 0x5A1
	Parameters: 1
	Flags: None
*/
function function_adf4d1d0(a_ai_zombies)
{
	var_63baafec = !isdefined(a_ai_zombies);
	if(var_63baafec)
	{
		a_ai_zombies = GetAITeamArray(level.zombie_team);
	}
	var_6b1085eb = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if(isdefined(ai_zombie.var_81e263d5) && ai_zombie.var_81e263d5)
		{
			continue;
		}
		if(isdefined(ai_zombie.marked_for_death) && ai_zombie.marked_for_death)
		{
			continue;
		}
		if(isdefined(ai_zombie.nuke_damage_func))
		{
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(ai_zombie))
		{
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach(var_f92b3d80 in var_6b1085eb)
	{
		if(!isdefined(var_f92b3d80))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80))
		{
			continue;
		}
		if(isdefined(var_f92b3d80.var_81e263d5) && var_f92b3d80.var_81e263d5)
		{
			continue;
		}
		var_f92b3d80 DoDamage(var_f92b3d80.health, var_f92b3d80.origin);
		if(!isdefined(var_f92b3d80.exclude_cleanup_adding_to_total) && var_f92b3d80.exclude_cleanup_adding_to_total && !level flag::get("special_round"))
		{
			level.zombie_total++;
		}
		wait(RandomFloatRange(0.05, 0.15));
	}
	if(var_63baafec)
	{
		a_ai_raz = GetAIArchetypeArray("raz");
		foreach(ai_raz in a_ai_raz)
		{
			if(isdefined(ai_raz.var_81e263d5) && ai_raz.var_81e263d5)
			{
				continue;
			}
			if(!isdefined(ai_raz.exclude_cleanup_adding_to_total) && ai_raz.exclude_cleanup_adding_to_total && !level flag::get("special_round"))
			{
				level.zombie_total++;
			}
			ai_raz.no_powerups = 1;
			ai_raz kill();
		}
		a_ai_sentinels = GetAIArchetypeArray("sentinel_drone");
		foreach(ai_sentinel in a_ai_sentinels)
		{
			if(isdefined(ai_sentinel.var_81e263d5) && ai_sentinel.var_81e263d5)
			{
				continue;
			}
			if(!isdefined(ai_sentinel.exclude_cleanup_adding_to_total) && ai_sentinel.exclude_cleanup_adding_to_total && !level flag::get("special_round"))
			{
				level.zombie_total++;
			}
			ai_sentinel.no_powerups = 1;
			ai_sentinel kill();
		}
	}
}

/*
	Name: function_3804dbf1
	Namespace: namespace_48c05c81
	Checksum: 0x6A2FA752
	Offset: 0x1348
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function function_3804dbf1(b_stop, str_endon)
{
	if(!isdefined(b_stop))
	{
		b_stop = 1;
	}
	if(!isdefined(str_endon))
	{
		str_endon = undefined;
	}
	if(b_stop)
	{
		if(isdefined(str_endon))
		{
			level endon(str_endon);
		}
		if(!level flag::get("spawn_zombies"))
		{
			level flag::wait_till("spawn_zombies");
		}
		level.disable_nuke_delay_spawning = 1;
		level flag::clear("spawn_zombies");
	}
	else if(isdefined(str_endon))
	{
		level notify(str_endon);
	}
	level.disable_nuke_delay_spawning = 1;
	level flag::set("spawn_zombies");
}

/*
	Name: function_f70dde0b
	Namespace: namespace_48c05c81
	Checksum: 0x2723446F
	Offset: 0x1450
	Size: 0x543
	Parameters: 8
	Flags: None
*/
function function_f70dde0b(a_e_spawners, a_s_spawnpoints, var_9c84987b, var_2494b61e, var_dc7b7a0f, n_max_zombies, str_notify, var_d965b1c7)
{
	if(!isdefined(var_2494b61e))
	{
		var_2494b61e = 24;
	}
	if(!isdefined(var_dc7b7a0f))
	{
		var_dc7b7a0f = 0.05;
	}
	if(!isdefined(var_d965b1c7))
	{
		var_d965b1c7 = 0;
	}
	/#
		Assert(isdefined(a_e_spawners), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(a_s_spawnpoints), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(var_9c84987b), "Dev Block strings are not supported");
	#/
	level notify("hash_91fef4b1");
	level endon("hash_91fef4b1");
	level flag::clear("wave_event_zombies_complete");
	if(isdefined(str_notify))
	{
		level endon(str_notify);
	}
	if(!isdefined(n_max_zombies))
	{
		/#
			Assert(isdefined(str_notify), "Dev Block strings are not supported");
		#/
		var_54939bf3 = 1;
	}
	var_9a8fc4a4 = [];
	var_613bb82b = 0;
	if(isdefined(level.var_c3c3ffc5))
	{
		level.var_c3c3ffc5 = Array::filter(level.var_c3c3ffc5, 0, &function_91d64824);
		var_9a8fc4a4 = ArrayCopy(level.var_c3c3ffc5);
		var_9a8fc4a4 = Array::filter(var_9a8fc4a4, 0, &function_46cd1314);
		level.var_b1d4e9a1 = var_9a8fc4a4.size;
	}
	else
	{
		level.var_c3c3ffc5 = [];
		level.var_b1d4e9a1 = 0;
	}
	level.var_258441ba = 0;
	if(IsArray(a_e_spawners))
	{
		e_spawner = Array::random(a_e_spawners);
		continue;
	}
	e_spawner = a_e_spawners;
	while(isdefined(var_54939bf3) && var_54939bf3 || var_613bb82b < n_max_zombies)
	{
		var_9a8fc4a4 = Array::filter(var_9a8fc4a4, 0, &function_91d64824);
		while(var_9a8fc4a4.size < var_2494b61e && (isdefined(var_54939bf3) && var_54939bf3 || var_613bb82b < n_max_zombies))
		{
			var_9a8fc4a4 = Array::filter(var_9a8fc4a4, 0, &function_91d64824);
			level function_58cdc394();
			level function_9b76f612("zombie");
			s_spawn_point = get_unused_spawn_point(a_s_spawnpoints);
			ai = zombie_utility::spawn_zombie(e_spawner, var_9c84987b, s_spawn_point);
			if(isdefined(ai))
			{
				if(!isdefined(var_9a8fc4a4))
				{
					var_9a8fc4a4 = [];
				}
				else if(!IsArray(var_9a8fc4a4))
				{
					var_9a8fc4a4 = Array(var_9a8fc4a4);
				}
				var_9a8fc4a4[var_9a8fc4a4.size] = ai;
				if(!isdefined(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = [];
				}
				else if(!IsArray(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = Array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = ai;
				var_613bb82b++;
				ai thread function_ff194e31(var_d965b1c7);
			}
			wait(var_dc7b7a0f);
		}
		wait(0.05);
	}
	while(var_9a8fc4a4.size > 0)
	{
		var_9a8fc4a4 = Array::filter(var_9a8fc4a4, 0, &function_91d64824);
		wait(0.5);
	}
	level flag::set("wave_event_zombies_complete");
}

/*
	Name: function_9b76f612
	Namespace: namespace_48c05c81
	Checksum: 0xB7BBB461
	Offset: 0x19A0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_9b76f612(str_ai_type)
{
	var_eec0f058 = 0;
	if(isdefined(level.var_9ddab511))
	{
		var_eec0f058 = level [[level.var_9ddab511]](str_ai_type);
	}
	while(isdefined(level.var_4209c599) && level.var_4209c599 || var_eec0f058)
	{
		wait(RandomFloatRange(0.1, 0.2));
		if(var_eec0f058)
		{
			var_eec0f058 = level [[level.var_9ddab511]](str_ai_type);
		}
	}
	level.var_4209c599 = 1;
}

/*
	Name: function_28c0c208
	Namespace: namespace_48c05c81
	Checksum: 0x2E2A638A
	Offset: 0x1A58
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_28c0c208()
{
	while(1)
	{
		util::wait_network_frame();
		level.var_4209c599 = 0;
	}
}

/*
	Name: function_91d64824
	Namespace: namespace_48c05c81
	Checksum: 0xA39409DF
	Offset: 0x1A90
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function function_91d64824(VAL)
{
	return isalive(VAL) && (!isdefined(VAL.aat_turned) && VAL.aat_turned) && (!isdefined(VAL.var_1d3a1f9e) && VAL.var_1d3a1f9e);
}

/*
	Name: function_46cd1314
	Namespace: namespace_48c05c81
	Checksum: 0x6864F0E1
	Offset: 0x1B08
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function function_46cd1314(VAL)
{
	return isalive(VAL) && (!isdefined(VAL.aat_turned) && VAL.aat_turned) && isdefined(VAL.archetype) && VAL.archetype == "zombie";
}

/*
	Name: function_412874e
	Namespace: namespace_48c05c81
	Checksum: 0xCE31D24A
	Offset: 0x1B88
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function function_412874e(VAL)
{
	return isalive(VAL) && isdefined(VAL.archetype) && VAL.archetype == "raz";
}

/*
	Name: function_f0610596
	Namespace: namespace_48c05c81
	Checksum: 0x642C5BD5
	Offset: 0x1BE0
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function function_f0610596(VAL)
{
	return isalive(VAL) && isdefined(VAL.archetype) && VAL.archetype == "sentinel_drone";
}

/*
	Name: function_ff194e31
	Namespace: namespace_48c05c81
	Checksum: 0x7FB587C4
	Offset: 0x1C38
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function function_ff194e31(var_d965b1c7)
{
	self endon("death");
	self thread function_b74ff7d4();
	self setPhysParams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.exclude_cleanup_adding_to_total = 1;
	self.sword_kill_power = 2;
	self.heroweapon_kill_power = 2;
	util::wait_network_frame();
	if(!var_d965b1c7)
	{
		self.no_damage_points = 1;
		self.deathpoints_already_given = 1;
		self thread zombie_no_powerups();
	}
	self zombie_utility::set_zombie_run_cycle("sprint");
	self.noCrawler = 1;
}

/*
	Name: function_b74ff7d4
	Namespace: namespace_48c05c81
	Checksum: 0x8206D0E3
	Offset: 0x1D30
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_b74ff7d4()
{
	ai_zombie = self;
	ai_zombie waittill("death", e_attacker);
	if(isPlayer(e_attacker))
	{
		[[level.hero_power_update]](e_attacker, ai_zombie);
	}
}

/*
	Name: function_d182335a
	Namespace: namespace_48c05c81
	Checksum: 0xD7799767
	Offset: 0x1D98
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_d182335a(ai_zombie)
{
	level.var_b1d4e9a1++;
	ai_zombie waittill("death");
	level.var_258441ba++;
}

/*
	Name: get_unused_spawn_point
	Namespace: namespace_48c05c81
	Checksum: 0xD38D5A5A
	Offset: 0x1DD0
	Size: 0x157
	Parameters: 1
	Flags: None
*/
function get_unused_spawn_point(a_s_spawnpoints)
{
	b_all_points_used = 0;
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in a_s_spawnpoints)
		{
			if(!isdefined(s_spawn_point.spawned_zombie) || b_all_points_used)
			{
				s_spawn_point.spawned_zombie = 0;
			}
			if(!s_spawn_point.spawned_zombie)
			{
				Array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	s_spawn_point = Array::random(a_valid_spawn_points);
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

/*
	Name: function_b55ebb81
	Namespace: namespace_48c05c81
	Checksum: 0x12CF87BD
	Offset: 0x1F30
	Size: 0x5E9
	Parameters: 7
	Flags: None
*/
function function_b55ebb81(a_spawnpoints, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_b4fcee85, str_notify_end, var_ee8c6a82)
{
	if(!isdefined(var_ee8c6a82))
	{
		var_ee8c6a82 = 0;
	}
	level notify("turbine_idle");
	level endon("turbine_idle");
	if(isdefined(str_notify_end))
	{
		level endon(str_notify_end);
		level thread function_4334972f("wave_event_raz_complete", str_notify_end, "wave_event_raz_spawning_active");
	}
	if(!isdefined(var_2b71b5b4))
	{
		/#
			Assert(isdefined(str_notify_end), "Dev Block strings are not supported");
		#/
		var_54939bf3 = 1;
	}
	if(var_f92c3865 < 0.1)
	{
		var_f92c3865 = 0.1;
	}
	if(isdefined(var_ee8c6a82) && var_ee8c6a82)
	{
		var_60d8c6a2 = 0;
	}
	level flag::set("wave_event_raz_spawning_active");
	var_4751753a = [];
	var_766273f0 = 0;
	while(isdefined(var_b4fcee85) && !isdefined(level.var_c3c3ffc5))
	{
		wait(0.05);
	}
	if(isdefined(level.var_c3c3ffc5))
	{
		level.var_c3c3ffc5 = Array::filter(level.var_c3c3ffc5, 0, &function_91d64824);
		var_4751753a = ArrayCopy(level.var_c3c3ffc5);
		var_4751753a = Array::filter(var_4751753a, 0, &function_412874e);
		var_766273f0 = var_4751753a.size;
	}
	util::wait_network_frame();
	while(isdefined(var_54939bf3) && var_54939bf3 || var_766273f0 < var_2b71b5b4 && level flag::get("wave_event_raz_spawning_active"))
	{
		var_4751753a = Array::remove_dead(var_4751753a, 0);
		while(var_4751753a.size < var_15eb9a52 && (isdefined(var_54939bf3) && var_54939bf3 || var_766273f0 < var_2b71b5b4) && level flag::get("wave_event_raz_spawning_active"))
		{
			var_4751753a = Array::remove_dead(var_4751753a, 0);
			level function_9b76f612("raz");
			ai_raz = function_432cdad9(a_spawnpoints);
			if(isalive(ai_raz))
			{
				ai_raz.no_powerups = 1;
				ai_raz.no_damage_points = 1;
				ai_raz.deathpoints_already_given = 1;
				if(!isdefined(var_4751753a))
				{
					var_4751753a = [];
				}
				else if(!IsArray(var_4751753a))
				{
					var_4751753a = Array(var_4751753a);
				}
				var_4751753a[var_4751753a.size] = ai_raz;
				if(!isdefined(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = [];
				}
				else if(!IsArray(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = Array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = ai_raz;
				ai_raz function_d48ad6b4();
				var_766273f0++;
				if(isdefined(var_ee8c6a82) && var_ee8c6a82)
				{
					if(isdefined(level.var_141e2500) && level.var_141e2500 && var_60d8c6a2 >= 3)
					{
						level.var_141e2500 = 0;
						var_60d8c6a2 = 0;
					}
					else
					{
						level.var_141e2500 = 1;
						var_60d8c6a2++;
					}
				}
				if(isdefined(level.var_141e2500) && level.var_141e2500)
				{
					ai_raz.invoke_sprint_time = GetTime();
				}
			}
			level function_a03df69f(var_f92c3865, var_b4fcee85, str_notify_end);
		}
		util::wait_network_frame();
		if(isdefined(var_2b71b5b4) && level flag::get("wave_event_zombies_complete"))
		{
			var_15eb9a52 = var_2b71b5b4;
		}
	}
	while(var_4751753a.size > 0 && level flag::get("wave_event_raz_spawning_active"))
	{
		var_4751753a = Array::remove_dead(var_4751753a, 0);
		wait(0.05);
	}
	level flag::clear("wave_event_raz_spawning_active");
	level notify("wave_event_raz_complete");
}

/*
	Name: function_4334972f
	Namespace: namespace_48c05c81
	Checksum: 0x9589E0F
	Offset: 0x2528
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function function_4334972f(str_endon, str_notify_end, var_1d9f5031)
{
	level endon(str_endon);
	level waittill(str_notify_end);
	level flag::clear(var_1d9f5031);
}

/*
	Name: function_432cdad9
	Namespace: namespace_48c05c81
	Checksum: 0xC2A181F6
	Offset: 0x2578
	Size: 0x24B
	Parameters: 2
	Flags: None
*/
function function_432cdad9(a_spawnpoints, func_on_spawned)
{
	players = GetPlayers();
	e_favorite_enemy = zm_ai_raz::get_favorite_enemy();
	if(isdefined(level.raz_spawn_func))
	{
		s_spawn_loc = [[level.raz_spawn_func]](level.a_sp_raz, e_favorite_enemy);
	}
	else if(isdefined(a_spawnpoints))
	{
		s_spawn_loc = function_77b29938(a_spawnpoints);
	}
	else if(level.zm_loc_types["raz_location"].size > 0)
	{
		s_spawn_loc = Array::random(level.zm_loc_types["raz_location"]);
	}
	if(!isdefined(s_spawn_loc))
	{
		return undefined;
	}
	ai = zm_ai_raz::spawn_raz_zombie(level.a_sp_raz[0]);
	if(isdefined(ai))
	{
		ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
		ai.script_string = s_spawn_loc.script_string;
		ai.find_flesh_struct_string = ai.script_string;
		ai.sword_kill_power = 4;
		ai.heroweapon_kill_power = 4;
		if(isdefined(e_favorite_enemy))
		{
			ai.favoriteenemy = e_favorite_enemy;
			ai.favoriteenemy.hunted_by++;
		}
		if(isdefined(func_on_spawned))
		{
			ai thread [[func_on_spawned]]();
		}
		playsoundatposition("zmb_raz_spawn", s_spawn_loc.origin);
		return ai;
	}
	return undefined;
}

/*
	Name: function_a03df69f
	Namespace: namespace_48c05c81
	Checksum: 0xFA040559
	Offset: 0x27D0
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function function_a03df69f(var_f92c3865, var_b4fcee85, str_notify_end)
{
	level notify("hash_7794a855");
	level endon("hash_7794a855");
	if(isdefined(str_notify_end))
	{
		level endon(str_notify_end);
	}
	if(!isdefined(var_b4fcee85))
	{
		wait(var_f92c3865);
		return;
	}
	var_c0068ac4 = level.var_258441ba;
	level.var_c3c3ffc5 = Array::remove_dead(level.var_c3c3ffc5, 0);
	n_time_start = GetTime() / 1000;
	do
	{
		var_bd4301c0 = level.var_258441ba - var_c0068ac4;
		n_time_current = GetTime() / 1000;
		n_time_elapsed = n_time_current - n_time_start;
		wait(0.05);
	}
	while(!(var_bd4301c0 < var_b4fcee85 && n_time_elapsed < var_f92c3865));
}

/*
	Name: function_77b29938
	Namespace: namespace_48c05c81
	Checksum: 0x333D667
	Offset: 0x28F0
	Size: 0x1B7
	Parameters: 2
	Flags: None
*/
function function_77b29938(a_spawners, e_favorite_enemy)
{
	b_all_points_used = 0;
	if(isdefined(a_spawners))
	{
		a_spawnpoints = ArrayCopy(a_spawners);
	}
	else
	{
		a_spawnpoints = ArrayCopy(level.zm_loc_types["raz_location"]);
	}
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in a_spawnpoints)
		{
			if(!isdefined(s_spawn_point.spawned_zombie) || b_all_points_used)
			{
				s_spawn_point.spawned_zombie = 0;
			}
			if(!s_spawn_point.spawned_zombie)
			{
				Array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	s_spawn_point = Array::random(a_valid_spawn_points);
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

/*
	Name: function_923f7f72
	Namespace: namespace_48c05c81
	Checksum: 0x38AC350A
	Offset: 0x2AB0
	Size: 0x4B9
	Parameters: 5
	Flags: None
*/
function function_923f7f72(var_af22dd13, var_ed448d3b, var_e25e1ccc, var_b4fcee85, str_notify_end)
{
	level notify("hash_93ef69e7");
	level endon("hash_93ef69e7");
	if(isdefined(str_notify_end))
	{
		level endon(str_notify_end);
		level thread function_4334972f("wave_event_sentinels_complete", str_notify_end, "wave_event_sentinel_spawning_active");
	}
	if(var_e25e1ccc < 0.1)
	{
		var_e25e1ccc = 0.1;
	}
	if(!isdefined(var_af22dd13))
	{
		var_54939bf3 = 1;
	}
	level flag::set("wave_event_sentinel_spawning_active");
	var_5e8e8152 = [];
	var_469adf27 = 0;
	while(!isdefined(level.var_c3c3ffc5))
	{
		wait(0.05);
	}
	if(isdefined(level.var_c3c3ffc5))
	{
		level.var_c3c3ffc5 = Array::filter(level.var_c3c3ffc5, 0, &function_91d64824);
		var_5e8e8152 = ArrayCopy(level.var_c3c3ffc5);
		var_5e8e8152 = Array::filter(var_5e8e8152, 0, &function_f0610596);
		var_469adf27 = var_5e8e8152.size;
	}
	util::wait_network_frame();
	while(isdefined(var_54939bf3) && var_54939bf3 || var_469adf27 < var_af22dd13 && level flag::get("wave_event_sentinel_spawning_active"))
	{
		var_5e8e8152 = Array::remove_dead(var_5e8e8152, 0);
		while(var_5e8e8152.size < var_ed448d3b && (isdefined(var_54939bf3) && var_54939bf3 || var_469adf27 < var_af22dd13) && level flag::get("wave_event_sentinel_spawning_active"))
		{
			var_5e8e8152 = Array::remove_dead(var_5e8e8152, 0);
			level function_9b76f612("sentinel");
			ai_sentinel = function_70e59bda();
			if(isalive(ai_sentinel))
			{
				ai_sentinel.no_powerups = 1;
				ai_sentinel.no_damage_points = 1;
				ai_sentinel.deathpoints_already_given = 1;
				if(!isdefined(var_5e8e8152))
				{
					var_5e8e8152 = [];
				}
				else if(!IsArray(var_5e8e8152))
				{
					var_5e8e8152 = Array(var_5e8e8152);
				}
				var_5e8e8152[var_5e8e8152.size] = ai_sentinel;
				if(!isdefined(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = [];
				}
				else if(!IsArray(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = Array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = ai_sentinel;
				ai_sentinel function_d48ad6b4();
				var_469adf27++;
			}
			wait(var_e25e1ccc);
			if(level flag::get("wave_event_zombies_complete"))
			{
				var_ed448d3b = var_af22dd13;
			}
		}
		util::wait_network_frame();
	}
	while(var_5e8e8152.size > 0 && level flag::get("wave_event_sentinel_spawning_active"))
	{
		var_5e8e8152 = Array::remove_dead(var_5e8e8152, 0);
		wait(0.05);
	}
	level flag::clear("wave_event_sentinel_spawning_active");
	level notify("wave_event_sentinels_complete");
}

/*
	Name: function_70e59bda
	Namespace: namespace_48c05c81
	Checksum: 0x4D606F55
	Offset: 0x2F78
	Size: 0x123
	Parameters: 2
	Flags: None
*/
function function_70e59bda(func_on_spawned, var_1d8ab289)
{
	if(isdefined(var_1d8ab289))
	{
		s_spawn_loc = var_1d8ab289;
	}
	else if(isdefined(level.sentinel_spawn_func))
	{
		s_spawn_loc = [[level.sentinel_spawn_func]](level.var_fda4b3f3);
	}
	else
	{
		s_spawn_loc = zm_ai_sentinel_drone::function_f9c9e7e0();
	}
	if(!isdefined(s_spawn_loc))
	{
		return undefined;
	}
	ai = zm_ai_sentinel_drone::function_fded8158(level.var_fda4b3f3[0]);
	if(isdefined(ai))
	{
		ai thread zm_ai_sentinel_drone::function_b27530eb(s_spawn_loc.origin);
		if(isdefined(func_on_spawned))
		{
			ai thread [[func_on_spawned]]();
		}
		ai.sword_kill_power = 4;
		ai.heroweapon_kill_power = 4;
		return ai;
	}
	return undefined;
}

/*
	Name: function_383b110b
	Namespace: namespace_48c05c81
	Checksum: 0xA6F2A445
	Offset: 0x30A8
	Size: 0x1AF
	Parameters: 1
	Flags: None
*/
function function_383b110b(a_spawners)
{
	b_all_points_used = 0;
	if(isdefined(a_spawners))
	{
		a_spawnpoints = ArrayCopy(a_spawners);
	}
	else
	{
		a_spawnpoints = ArrayCopy(level.zm_loc_types["sentinel_location"]);
	}
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in a_spawnpoints)
		{
			if(!isdefined(s_spawn_point.var_1565f394) || b_all_points_used)
			{
				s_spawn_point.var_1565f394 = 0;
			}
			if(!s_spawn_point.var_1565f394)
			{
				Array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	s_spawn_point = Array::random(a_valid_spawn_points);
	s_spawn_point.var_1565f394 = 1;
	return s_spawn_point;
}

/*
	Name: function_d48ad6b4
	Namespace: namespace_48c05c81
	Checksum: 0x38DB81AC
	Offset: 0x3260
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function function_d48ad6b4()
{
	level.var_c3c3ffc5 = Array::remove_dead(level.var_c3c3ffc5, 0);
	if(isdefined(level.var_5fe02c5a))
	{
		n_ai_limit = level.var_5fe02c5a;
	}
	else
	{
		n_ai_limit = level.zombie_ai_limit;
	}
	if(level.var_c3c3ffc5.size > n_ai_limit)
	{
		n_to_kill = level.var_c3c3ffc5.size - n_ai_limit;
		if(isVehicle(self))
		{
			n_to_kill++;
		}
		for(i = 0; i < n_to_kill; i++)
		{
			do
			{
				ai_target = Array::random(level.var_c3c3ffc5);
				wait(0.05);
			}
			while(!!level function_4614e0e9(ai_target));
			ai_target.var_1d3a1f9e = 1;
			wait(0.05);
			if(function_4614e0e9(ai_target))
			{
				ai_target kill();
			}
			level.var_c3c3ffc5 = Array::remove_dead(level.var_c3c3ffc5, 0);
			if(level.var_c3c3ffc5.size <= n_ai_limit)
			{
				break;
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: function_4614e0e9
	Namespace: namespace_48c05c81
	Checksum: 0x4611A9C4
	Offset: 0x3410
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function function_4614e0e9(ai_target)
{
	if(!isdefined(ai_target))
	{
		return 0;
	}
	if(ai_target.archetype !== "zombie" || zm_utility::is_magic_bullet_shield_enabled(ai_target))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_58cdc394
	Namespace: namespace_48c05c81
	Checksum: 0x6717F33D
	Offset: 0x3470
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_58cdc394()
{
	while(level.var_c3c3ffc5.size >= level.zombie_ai_limit)
	{
		level.var_c3c3ffc5 = Array::remove_dead(level.var_c3c3ffc5, 0);
		wait(0.05);
	}
}

/*
	Name: function_5eeabbe0
	Namespace: namespace_48c05c81
	Checksum: 0x8A215CE9
	Offset: 0x34C0
	Size: 0x333
	Parameters: 4
	Flags: None
*/
function function_5eeabbe0(var_47ee7db6, nd_path_start, var_f08b56c6, str_notify)
{
	self.var_fa6d2a24 = 1;
	self zm_utility::increment_ignoreme();
	self bgb::suspend_weapon_cycling();
	self.bgb_disabled = 1;
	self.vh_rail = spawner::simple_spawn_single(var_47ee7db6);
	self.vh_rail SetIgnorePauseWorld(1);
	self.vh_rail SetAcceleration(500);
	self.vh_rail setturningability(0.3);
	self.vh_rail.origin = self.origin;
	self SetPlayerAngles(self.vh_rail.angles);
	self.vh_rail.e_parent = self;
	self notify("hash_94217b77");
	switch(nd_path_start.targetname)
	{
		case "sewer_ride_start":
		{
			exploder::exploder("fxexp_501");
			break;
		}
		case "ee_sewer_rail_start":
		{
			exploder::exploder("fxexp_503");
		}
		case default:
		{
			break;
		}
	}
	self PlayerLinkToDelta(self.vh_rail, undefined, 1, 20, 20, 15, 60);
	self.vh_rail vehicle::get_on_path(nd_path_start);
	self playsound("evt_zipline_attach");
	self thread function_6efec755(var_f08b56c6);
	self util::magic_bullet_shield();
	self.vh_rail waittill("rail_over");
	self.var_fa6d2a24 = 0;
	self zm_utility::decrement_ignoreme();
	self.bgb_disabled = 0;
	self bgb::resume_weapon_cycling();
	if(isdefined(str_notify))
	{
		level notify(str_notify);
	}
	if(!isdefined(level.var_2de93bbe) && level.var_2de93bbe && nd_path_start.targetname != "ee_sewer_rail_start")
	{
		self zm_audio::create_and_play_dialog("transport", "sewer");
	}
	self util::stop_magic_bullet_shield();
}

/*
	Name: function_6efec755
	Namespace: namespace_48c05c81
	Checksum: 0x9D2CFD3A
	Offset: 0x3800
	Size: 0x1DD
	Parameters: 1
	Flags: None
*/
function function_6efec755(var_f08b56c6)
{
	self endon("disconnect");
	self endon("switch_rail");
	self.vh_rail thread play_current_fx();
	self clientfield::set_to_player("tp_water_sheeting", 1);
	self.vh_rail vehicle::go_path();
	if(isdefined(var_f08b56c6))
	{
		self.vh_rail.origin = var_f08b56c6.origin;
		self.origin = var_f08b56c6.origin;
		self SetPlayerAngles(var_f08b56c6.angles);
		self.vh_rail vehicle::get_on_path(var_f08b56c6);
		self.vh_rail vehicle::go_path();
	}
	self.vh_rail notify("rail_over");
	self clientfield::increment_to_player("sewer_landing_rumble");
	self playsound("zmb_stalingrad_sewer_air_land");
	self StopLoopSound(0.4);
	self Unlink();
	self clientfield::set_to_player("tp_water_sheeting", 0);
	wait(0.3);
	self.vh_rail delete();
	self.var_a0a9409e = undefined;
}

/*
	Name: function_ab2df0ca
	Namespace: namespace_48c05c81
	Checksum: 0xF57CBC5E
	Offset: 0x39E8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_ab2df0ca()
{
	self endon("rail_over");
	self endon("disconnect");
	self waittill("hash_94217b77");
	self.vh_rail waittill("hash_c4eac163");
	self clientfield::set_to_player("drown_stage", 4);
	wait(0.5);
	self LUI::screen_fade_out(1.5);
	self.vh_rail util::waittill_notify_or_timeout("sewer_fade_up", 3);
	self LUI::screen_fade_in(1);
	self clientfield::set_to_player("drown_stage", 0);
}

/*
	Name: play_current_fx
	Namespace: namespace_48c05c81
	Checksum: 0x89BB7519
	Offset: 0x3AD8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function play_current_fx()
{
	self endon("rail_over");
	while(1)
	{
		PlayFXOnTag(level._effect["current_effect"], self, "tag_origin");
		wait(0.1);
	}
}

/*
	Name: function_eda4b163
	Namespace: namespace_48c05c81
	Checksum: 0x6E04E75D
	Offset: 0x3B30
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_eda4b163()
{
	while(1)
	{
		self trigger::wait_till();
		exploder::exploder(self.script_string);
	}
}

/*
	Name: function_4da6e8
	Namespace: namespace_48c05c81
	Checksum: 0xBFBC9F26
	Offset: 0x3B78
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_4da6e8(b_open)
{
	var_2e1f1409 = GetEnt("dept_occluder", "targetname");
	if(b_open)
	{
		var_2e1f1409 ghost();
		var_2e1f1409 notsolid();
		umbragate_set("umbragate1", 1);
	}
	else
	{
		var_2e1f1409 show();
		var_2e1f1409 solid();
		umbragate_set("umbragate1", 0);
	}
}

/*
	Name: function_903f6b36
	Namespace: namespace_48c05c81
	Checksum: 0x77AFD827
	Offset: 0x3C58
	Size: 0x1E3
	Parameters: 2
	Flags: None
*/
function function_903f6b36(b_turn_on, str_identifier)
{
	if(!isdefined(str_identifier))
	{
		str_identifier = undefined;
	}
	if(!isdefined(str_identifier))
	{
		str_identifier = self.script_noteworthy;
		a_e_switch = GetEntArray(str_identifier, "targetname");
	}
	else
	{
		a_e_switch = GetEntArray(str_identifier + "_switch", "targetname");
	}
	if(b_turn_on)
	{
		str_scene = "p7_fxanim_zm_stal_power_switch_on_bundle";
		exploder::exploder(str_identifier + "_red");
		exploder::stop_exploder(str_identifier + "_green");
	}
	else
	{
		str_scene = "p7_fxanim_zm_stal_power_switch_reset_bundle";
	}
	foreach(e_switch in a_e_switch)
	{
		e_switch thread scene::Play(str_scene, e_switch);
	}
	wait(1);
	if(!b_turn_on)
	{
		exploder::exploder(str_identifier + "_green");
		exploder::stop_exploder(str_identifier + "_red");
	}
}

/*
	Name: function_c66f2957
	Namespace: namespace_48c05c81
	Checksum: 0x704789EC
	Offset: 0x3E48
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function function_c66f2957(s_point)
{
	return s_point.script_noteworthy === "spawn_location" || s_point.script_noteworthy === "riser_location";
}

