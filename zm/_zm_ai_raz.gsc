#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_1c31c03d;

/*
	Name: __init__sytem__
	Namespace: namespace_1c31c03d
	Checksum: 0x4B28842D
	Offset: 0x550
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_raz", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1c31c03d
	Checksum: 0x7EC096DF
	Offset: 0x598
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init();
}

/*
	Name: __main__
	Namespace: namespace_1c31c03d
	Checksum: 0x56529FB6
	Offset: 0x5B8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __main__()
{
	register_clientfields();
	/#
		execdevgui("Dev Block strings are not supported");
		thread function_fbcfe4b6();
	#/
}

/*
	Name: register_clientfields
	Namespace: namespace_1c31c03d
	Checksum: 0x99EC1590
	Offset: 0x608
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
}

/*
	Name: init
	Namespace: namespace_1c31c03d
	Checksum: 0x978ED1D9
	Offset: 0x618
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function init()
{
	zm::register_player_damage_callback(&function_94372a17);
	level.var_2e815d61 = 1;
	level.var_629d0743 = 0;
	level.var_d4fa016a = 1;
	level.var_b9ce6312 = 0;
	level.var_6bca5baa = [];
	level.var_f95eaac8 = 5500;
	zm_score::register_score_event("death_raz", &function_6fdcefe3);
	level flag::init("raz_round");
	level flag::init("raz_round_in_progress");
	level thread AAT::register_immunity("zm_aat_blast_furnace", "raz", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "raz", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "raz", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "raz", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "raz", 1, 1, 1);
	function_e099c556();
	level thread function_ff9b21c4();
}

/*
	Name: function_6fdcefe3
	Namespace: namespace_1c31c03d
	Checksum: 0x26F0E4FF
	Offset: 0x810
	Size: 0x123
	Parameters: 5
	Flags: None
*/
function function_6fdcefe3(str_event, str_mod, str_hit_location, var_48d0b2fe, var_2f7fd5db)
{
	if(str_event === "death_raz")
	{
		var_1fdfc3ef = zm_score::get_zombie_death_player_points();
		var_2d175949 = self zm_score::player_add_points_kill_bonus(str_mod, str_hit_location, var_2f7fd5db);
		var_1fdfc3ef = var_1fdfc3ef + var_2d175949 * 2;
		if(str_mod == "MOD_GRENADE" || str_mod == "MOD_GRENADE_SPLASH")
		{
			self zm_stats::increment_client_stat("grenade_kills");
			self zm_stats::increment_player_stat("grenade_kills");
		}
		scoreevents::processScoreEvent("kill_raz", self, undefined, var_2f7fd5db);
		return var_1fdfc3ef;
	}
	return 0;
}

/*
	Name: function_7dfa7ca6
	Namespace: namespace_1c31c03d
	Checksum: 0x128A22B3
	Offset: 0x940
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_7dfa7ca6()
{
	level.var_629d0743 = 1;
	if(!isdefined(level.var_c810e243))
	{
		level.var_c810e243 = &function_684ce0;
	}
	level thread [[level.var_c810e243]]();
}

/*
	Name: function_e099c556
	Namespace: namespace_1c31c03d
	Checksum: 0x7F78B32B
	Offset: 0x990
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function function_e099c556()
{
	level.var_6bca5baa = GetEntArray("zombie_raz_spawner", "script_noteworthy");
	if(level.var_6bca5baa.size == 0)
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	foreach(var_ad58b9ca in level.var_6bca5baa)
	{
		var_ad58b9ca.is_enabled = 1;
		var_ad58b9ca.script_forcespawn = 1;
		var_ad58b9ca spawner::add_spawn_function(&function_4749ab89);
	}
}

/*
	Name: function_ff9b21c4
	Namespace: namespace_1c31c03d
	Checksum: 0x9B33BF7A
	Offset: 0xAB8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_ff9b21c4()
{
	/#
		level waittill("start_of_round");
		function_a67ada8();
	#/
	while(1)
	{
		level waittill("between_round_over");
		function_a67ada8();
	}
}

/*
	Name: function_684ce0
	Namespace: namespace_1c31c03d
	Checksum: 0x7D2B7D3A
	Offset: 0xB10
	Size: 0x23F
	Parameters: 0
	Flags: None
*/
function function_684ce0()
{
	level.var_d4fa016a = 1;
	level.var_51a5abd0 = randomIntRange(5, 8);
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level.var_51a5abd0 = 5;
		}
	#/
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(1)
	{
		level waittill("between_round_over");
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				level.var_51a5abd0 = level.round_number;
			}
		#/
		if(level.round_number == level.var_51a5abd0)
		{
			level.sndMusicSpecialRound = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			function_77ff30a0();
			level.round_spawn_func = &function_a33bc00f;
			level.round_wait_func = &function_692370a0;
			if(isdefined(level.var_95444cb4))
			{
				level.var_51a5abd0 = [[level.var_95444cb4]]();
			}
			else
			{
				level.var_51a5abd0 = level.var_51a5abd0 + randomIntRange(5, 8);
			}
			/#
				GetPlayers()[0] iprintln("Dev Block strings are not supported" + level.var_51a5abd0);
			#/
		}
		else if(level flag::get("raz_round"))
		{
			function_783ab6ac();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.var_d4fa016a++;
		}
	}
}

/*
	Name: function_77ff30a0
	Namespace: namespace_1c31c03d
	Checksum: 0xED463214
	Offset: 0xD58
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_77ff30a0()
{
	level flag::set("raz_round");
	level flag::set("special_round");
	level.var_b9ce6312 = 1;
	level notify("hash_61c47438");
	level thread zm_audio::sndMusicSystem_PlayState("raz_start");
}

/*
	Name: function_783ab6ac
	Namespace: namespace_1c31c03d
	Checksum: 0x8C6D8007
	Offset: 0xDE0
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function function_783ab6ac()
{
	level flag::clear("raz_round");
	level flag::clear("special_round");
	level.var_b9ce6312 = 0;
	level notify("hash_22aa6eed");
}

/*
	Name: function_a33bc00f
	Namespace: namespace_1c31c03d
	Checksum: 0xED2E6C48
	Offset: 0xE48
	Size: 0x2BF
	Parameters: 0
	Flags: None
*/
function function_a33bc00f()
{
	level endon("intermission");
	level endon("hash_a613a361");
	level.var_bc3f44bf = GetPlayers();
	for(i = 0; i < level.var_bc3f44bf.size; i++)
	{
		level.var_bc3f44bf[i].hunted_by = 0;
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
	Array::thread_all(level.players, &function_bdf13070);
	n_wave_count = function_852019c2();
	function_a67ada8();
	level.zombie_total = Int(n_wave_count);
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported" && GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level.zombie_total = GetDvarInt("Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", 0);
		}
	#/
	wait(1);
	wait(6);
	var_c55cf881 = 0;
	level flag::set("raz_round_in_progress");
	level endon("last_ai_down");
	level thread function_25561504();
	while(1)
	{
		while(level.zombie_total > 0)
		{
			if(isdefined(level.bzm_worldPaused) && level.bzm_worldPaused)
			{
				util::wait_network_frame();
				continue;
			}
			function_45bace88();
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_665a13cd
	Namespace: namespace_1c31c03d
	Checksum: 0xBB36E861
	Offset: 0x1110
	Size: 0x9F
	Parameters: 2
	Flags: None
*/
function function_665a13cd(spawner, s_spot)
{
	var_a09c80cd = zombie_utility::spawn_zombie(level.var_6bca5baa[0], "raz", s_spot);
	if(isdefined(var_a09c80cd))
	{
		var_a09c80cd.check_point_in_enabled_zone = &zm_utility::check_point_in_playable_area;
		var_a09c80cd thread zombie_utility::round_spawn_failsafe();
		var_a09c80cd thread function_b8671cc0(s_spot);
	}
	return var_a09c80cd;
}

/*
	Name: function_b8671cc0
	Namespace: namespace_1c31c03d
	Checksum: 0x73307D7D
	Offset: 0x11B8
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_b8671cc0(s_spot)
{
	if(isdefined(level.var_71ab2462))
	{
		self thread [[level.var_71ab2462]](s_spot);
	}
	if(isdefined(level.var_ae95a175))
	{
		self thread [[level.var_ae95a175]]();
	}
}

/*
	Name: function_45bace88
	Namespace: namespace_1c31c03d
	Checksum: 0x937CFA31
	Offset: 0x1208
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function function_45bace88()
{
	while(!function_ea911683())
	{
		wait(0.1);
	}
	s_spawn_loc = undefined;
	var_19764360 = get_favorite_enemy();
	if(!isdefined(var_19764360))
	{
		wait(RandomFloatRange(0.3333333, 0.6666667));
		return;
	}
	if(isdefined(level.var_e80c1065))
	{
		s_spawn_loc = [[level.var_e80c1065]](var_19764360);
	}
	else
	{
		if(level.zm_loc_types["Dev Block strings are not supported"].size == 0)
		{
			IPrintLnBold("Dev Block strings are not supported");
		}
		s_spawn_loc = Array::random(level.zm_loc_types["raz_location"]);
	}
	/#
	#/
	if(!isdefined(s_spawn_loc))
	{
		wait(RandomFloatRange(0.3333333, 0.6666667));
		return;
	}
	ai = function_665a13cd(level.var_6bca5baa[0]);
	if(isdefined(ai))
	{
		ai thread function_b8671cc0(s_spawn_loc);
		ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
		if(isdefined(var_19764360))
		{
			ai.favoriteenemy = var_19764360;
			ai.favoriteenemy.hunted_by++;
		}
		level.zombie_total--;
		function_a74c2884();
	}
}

/*
	Name: function_852019c2
	Namespace: namespace_1c31c03d
	Checksum: 0x9A8FF8B
	Offset: 0x1418
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function function_852019c2()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_wave_count = 6;
			break;
		}
		case 2:
		{
			n_wave_count = 10;
			break;
		}
		case 3:
		{
			n_wave_count = 14;
			break;
		}
		case 4:
		case default:
		{
			n_wave_count = 16;
			break;
		}
	}
	return n_wave_count;
}

/*
	Name: function_692370a0
	Namespace: namespace_1c31c03d
	Checksum: 0x1E8870C6
	Offset: 0x14A8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_692370a0()
{
	level endon("restart_round");
	/#
		level endon("kill_round");
	#/
	if(level flag::get("raz_round"))
	{
		level flag::wait_till("raz_round_in_progress");
		level flag::wait_till_clear("raz_round_in_progress");
	}
	level.sndMusicSpecialRound = 0;
}

/*
	Name: function_a1d75eeb
	Namespace: namespace_1c31c03d
	Checksum: 0xF4B64643
	Offset: 0x1538
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function function_a1d75eeb()
{
	var_89de5b91 = GetEntArray("zombie_raz", "targetname");
	var_c55cf881 = var_89de5b91.size;
	foreach(var_1c963231 in var_89de5b91)
	{
		if(!isalive(var_1c963231))
		{
			var_c55cf881--;
		}
	}
	return var_c55cf881;
}

/*
	Name: function_bcbbda54
	Namespace: namespace_1c31c03d
	Checksum: 0xCDA1BF95
	Offset: 0x1618
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function function_bcbbda54()
{
	switch(level.players.size)
	{
		case 1:
		{
			return 2;
			break;
		}
		case 2:
		{
			return 3;
			break;
		}
		case 3:
		{
			return 4;
			break;
		}
		case 4:
		{
			return 4;
			break;
		}
	}
}

/*
	Name: function_ea911683
	Namespace: namespace_1c31c03d
	Checksum: 0x2E506707
	Offset: 0x1688
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_ea911683()
{
	var_c55cf881 = function_a1d75eeb();
	var_f0ab435a = function_bcbbda54();
	if(var_c55cf881 >= var_f0ab435a || !level flag::get("spawn_zombies"))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_a74c2884
	Namespace: namespace_1c31c03d
	Checksum: 0x262D82DB
	Offset: 0x1708
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_a74c2884()
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
	Name: function_25561504
	Namespace: namespace_1c31c03d
	Checksum: 0x1B0A7EB7
	Offset: 0x1798
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_25561504()
{
	level waittill("last_ai_down", e_enemy_ai);
	level thread zm_audio::sndMusicSystem_PlayState("raz_over");
	if(isdefined(level.zm_override_ai_aftermath_powerup_drop))
	{
		[[level.zm_override_ai_aftermath_powerup_drop]](e_enemy_ai, level.var_6a6f912a);
	}
	else
	{
		var_4a50cb2a = level.var_6a6f912a;
		trace = GroundTrace(var_4a50cb2a + VectorScale((0, 0, 1), 100), var_4a50cb2a + VectorScale((0, 0, -1), 1000), 0, undefined);
		var_4a50cb2a = trace["position"];
		if(isdefined(var_4a50cb2a))
		{
			level thread zm_powerups::specific_powerup_drop("full_ammo", var_4a50cb2a);
		}
	}
	wait(2);
	level.sndMusicSpecialRound = 0;
	wait(6);
	level flag::clear("raz_round_in_progress");
}

/*
	Name: get_favorite_enemy
	Namespace: namespace_1c31c03d
	Checksum: 0x9189E45F
	Offset: 0x18D8
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function get_favorite_enemy()
{
	var_bc3f44bf = GetPlayers();
	e_least_hunted = undefined;
	foreach(e_target in var_bc3f44bf)
	{
		if(!isdefined(e_target.hunted_by))
		{
			e_target.hunted_by = 0;
		}
		if(!zm_utility::is_player_valid(e_target))
		{
			continue;
		}
		if(isdefined(level.var_3fded92e) && ![[level.var_3fded92e]](e_target))
		{
			continue;
		}
		if(!isdefined(e_least_hunted))
		{
			e_least_hunted = e_target;
			continue;
		}
		if(e_target.hunted_by < e_least_hunted.hunted_by)
		{
			e_least_hunted = e_target;
		}
	}
	return e_least_hunted;
}

/*
	Name: function_a67ada8
	Namespace: namespace_1c31c03d
	Checksum: 0x50AF8ECE
	Offset: 0x1A30
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function function_a67ada8()
{
	level.var_f95eaac8 = 5500 + level.round_number * 100;
	if(level.var_f95eaac8 < 5500)
	{
		level.var_f95eaac8 = 5500;
	}
	else if(level.var_f95eaac8 > 15000)
	{
		level.var_f95eaac8 = 15000;
	}
	level.var_f95eaac8 = Int(level.var_f95eaac8 * 1 + 0.15 * level.players.size - 1);
	level.razGunHealth = level.var_f95eaac8 * 0.15;
	level.razHelmetHealth = level.var_f95eaac8 * 0.3;
	level.razLeftShoulderArmorHealth = level.var_f95eaac8 * 0.25;
	level.razChestArmorHealth = level.var_f95eaac8 * 0.4;
	level.razThighArmorHealth = level.var_f95eaac8 * 0.25;
}

/*
	Name: function_bdf13070
	Namespace: namespace_1c31c03d
	Checksum: 0x164C9D33
	Offset: 0x1B58
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_bdf13070()
{
	self playlocalsound("zmb_raz_round_start");
	variation_count = 5;
	wait(4.5);
	players = GetPlayers();
	num = randomIntRange(0, players.size);
	players[num] zm_audio::create_and_play_dialog("general", "raz_spawn");
}

/*
	Name: function_4749ab89
	Namespace: namespace_1c31c03d
	Checksum: 0x4B0DD4EC
	Offset: 0x1C18
	Size: 0x2AF
	Parameters: 0
	Flags: None
*/
function function_4749ab89()
{
	self.targetname = "zombie_raz";
	self.script_noteworthy = undefined;
	self.animName = "zombie_raz";
	self.allowdeath = 1;
	self.allowPain = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
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
	self.instakill_func = &function_a59f11f9;
	self thread zombie_utility::zombie_eye_glow();
	if(isdefined(level.var_c7da0559))
	{
		self.func_custom_cleanup_check = level.var_c7da0559;
	}
	self.maxhealth = level.var_f95eaac8;
	if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
	{
		self.health = level.a_zombie_respawn_health[self.archetype][0];
		ArrayRemoveValue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
	}
	else
	{
		self.health = self.maxhealth;
	}
	self thread function_f8080b7();
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	self zm_spawner::zombie_history("zombie_raz_spawn_init -> Spawned = " + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self thread [[level.achievement_monitor_func]]();
	}
}

/*
	Name: function_f8080b7
	Namespace: namespace_1c31c03d
	Checksum: 0x39F6A300
	Offset: 0x1ED0
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function function_f8080b7()
{
	self waittill("death", attacker);
	self thread zombie_utility::zombie_eye_glow_stop();
	if(function_a1d75eeb() == 0 && level.zombie_total == 0)
	{
		if(!isdefined(level.zm_ai_round_over) || [[level.zm_ai_round_over]]())
		{
			level.var_6a6f912a = self.origin;
			level notify("last_ai_down", self);
		}
	}
	if(isPlayer(attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			attacker zm_score::player_add_points("death_raz", self.damageMod, self.damagelocation);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](attacker, self);
		}
		attacker zm_audio::create_and_play_dialog("kill", "raz");
		attacker zm_stats::increment_client_stat("zraz_killed");
		attacker zm_stats::increment_player_stat("zraz_killed");
	}
	if(isdefined(attacker) && isai(attacker))
	{
		attacker notify("killed", self);
	}
	if(isdefined(self))
	{
		self StopLoopSound();
		self thread function_b1f85217(self.origin);
	}
}

/*
	Name: function_b1f85217
	Namespace: namespace_1c31c03d
	Checksum: 0x7B764799
	Offset: 0x20D0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_b1f85217(origin)
{
}

/*
	Name: function_b4cd74ca
	Namespace: namespace_1c31c03d
	Checksum: 0xF9B73238
	Offset: 0x20E8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_b4cd74ca()
{
	self zm_spawner::zombie_history("zombie_setup_attack_properties()");
	self.ignoreall = 0;
	self.meleeAttackDist = 64;
	self.disableArrivals = 1;
	self.disableExits = 1;
}

/*
	Name: function_7b5bfac6
	Namespace: namespace_1c31c03d
	Checksum: 0xB82979D6
	Offset: 0x2148
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_7b5bfac6()
{
	self waittill("death");
	self stopsounds();
}

/*
	Name: function_7ed6c714
	Namespace: namespace_1c31c03d
	Checksum: 0x35FFAC78
	Offset: 0x2178
	Size: 0x2AB
	Parameters: 4
	Flags: None
*/
function function_7ed6c714(n_to_spawn, var_e41e673a, var_adf6f009, var_b7959229)
{
	if(!isdefined(n_to_spawn))
	{
		n_to_spawn = 1;
	}
	if(!isdefined(var_adf6f009))
	{
		var_adf6f009 = 0;
	}
	if(!isdefined(var_b7959229))
	{
		var_b7959229 = undefined;
	}
	n_spawned = 0;
	while(n_spawned < n_to_spawn)
	{
		if(!var_adf6f009 && !function_ea911683())
		{
			return n_spawned;
		}
		players = GetPlayers();
		var_19764360 = get_favorite_enemy();
		if(isdefined(var_b7959229))
		{
			s_spawn_loc = var_b7959229;
		}
		else if(isdefined(level.var_a3559c05))
		{
			s_spawn_loc = [[level.var_a3559c05]](level.var_6bca5baa, var_19764360);
		}
		else if(level.zm_loc_types["raz_location"].size > 0)
		{
			s_spawn_loc = Array::random(level.zm_loc_types["raz_location"]);
		}
		if(!isdefined(s_spawn_loc))
		{
			return 0;
		}
		ai = function_665a13cd(level.var_6bca5baa[0]);
		if(isdefined(ai))
		{
			ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
			ai.script_string = s_spawn_loc.script_string;
			ai.find_flesh_struct_string = ai.script_string;
			if(isdefined(var_19764360))
			{
				ai.favoriteenemy = var_19764360;
				ai.favoriteenemy.hunted_by++;
			}
			n_spawned++;
			if(isdefined(var_e41e673a))
			{
				ai thread [[var_e41e673a]]();
			}
			playsoundatposition("zmb_raz_spawn", s_spawn_loc.origin);
		}
		function_a74c2884();
	}
	return 1;
}

/*
	Name: function_175052a7
	Namespace: namespace_1c31c03d
	Checksum: 0x4529FDD9
	Offset: 0x2430
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_175052a7()
{
	self endon("death");
	while(1)
	{
		self playsound("zmb_hellhound_vocals_amb");
		wait(RandomFloatRange(3, 6));
	}
}

/*
	Name: function_d1fed7c2
	Namespace: namespace_1c31c03d
	Checksum: 0x652F53AC
	Offset: 0x2488
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function function_d1fed7c2(player, gib)
{
	self endon("death");
	damage = Int(self.maxhealth * 0.5);
	self DoDamage(damage, player.origin, player, undefined, "none", "MOD_UNKNOWN");
}

/*
	Name: function_94372a17
	Namespace: namespace_1c31c03d
	Checksum: 0xD5DD9AD7
	Offset: 0x2520
	Size: 0x191
	Parameters: 10
	Flags: None
*/
function function_94372a17(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime)
{
	player = self;
	if(isdefined(attacker) && attacker.archetype === "raz" && mod === "MOD_PROJECTILE_SPLASH" && isdefined(weapon) && IsSubStr("raz_melee", weapon.name))
	{
		dist_sq = DistanceSquared(attacker.origin, player.origin);
		var_bfa346a2 = 16384;
		var_a9914202 = 1 - dist_sq / var_bfa346a2;
		var_2882f9d = 35;
		damage = var_2882f9d * var_a9914202;
		damage = Int(damage);
		damage = damage + 15;
		return damage;
	}
	return -1;
}

/*
	Name: function_a59f11f9
	Namespace: namespace_1c31c03d
	Checksum: 0x9F3DB170
	Offset: 0x26C0
	Size: 0xDB
	Parameters: 3
	Flags: None
*/
function function_a59f11f9(e_player, var_3ca8546d, var_9908b5f4)
{
	if(var_9908b5f4 == "right_arm_lower" || var_9908b5f4 == "right_hand")
	{
		return 1;
	}
	else if(var_9908b5f4 == "right_arm_upper" && self.razHasGunAttached == 1)
	{
		self.razGunHealth = 1;
		self DoDamage(1, e_player.origin, e_player, e_player, "right_arm_upper");
		return 1;
	}
	else if(isdefined(self.last_damage_hit_armor) && self.last_damage_hit_armor)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_fbcfe4b6
	Namespace: namespace_1c31c03d
	Checksum: 0x74C14E5E
	Offset: 0x27A8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_fbcfe4b6()
{
	/#
		level flag::wait_till("Dev Block strings are not supported");
		zm_devgui::function_4acecab5(&function_3626e3d1);
	#/
}

/*
	Name: function_3626e3d1
	Namespace: namespace_1c31c03d
	Checksum: 0x3154A13F
	Offset: 0x27F8
	Size: 0xCD
	Parameters: 1
	Flags: None
*/
function function_3626e3d1(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				function_39a724b1();
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_9a80ee5f();
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_e115a394(GetDvarInt("Dev Block strings are not supported"));
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_70864ef2(GetDvarInt("Dev Block strings are not supported"));
				break;
			}
		}
	#/
}

/*
	Name: function_39a724b1
	Namespace: namespace_1c31c03d
	Checksum: 0xF3A15BA5
	Offset: 0x28D0
	Size: 0x1D1
	Parameters: 0
	Flags: None
*/
function function_39a724b1()
{
	/#
		player = level.players[0];
		v_direction = player getPlayerAngles();
		v_direction = AnglesToForward(v_direction) * 8000;
		eye = player GetEye();
		trace = bullettrace(eye, eye + v_direction, 0, undefined);
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
		function_7ed6c714(1, undefined, 1, s_spot);
		return 1;
	#/
}

/*
	Name: function_9a80ee5f
	Namespace: namespace_1c31c03d
	Checksum: 0x71388C7F
	Offset: 0x2AB0
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function function_9a80ee5f()
{
	/#
		if(!(isdefined(level.b_raz_ignore_mangler_cooldown) && level.b_raz_ignore_mangler_cooldown))
		{
			level.b_raz_ignore_mangler_cooldown = 1;
		}
		else
		{
			level.b_raz_ignore_mangler_cooldown = undefined;
		}
	#/
}

/*
	Name: function_e115a394
	Namespace: namespace_1c31c03d
	Checksum: 0xF8B90C2A
	Offset: 0x2AF8
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function function_e115a394(var_eee0e63b)
{
	/#
		if(!isdefined(level.var_2e815d61) || !level.var_2e815d61)
		{
			return;
		}
		if(!isdefined(level.var_629d0743) || !level.var_629d0743)
		{
			return;
		}
		if(!isdefined(level.var_6bca5baa) || level.var_6bca5baa.size < 1)
		{
			return;
		}
		function_d8afb0d4(var_eee0e63b);
		level.var_51a5abd0 = level.round_number + 1;
	#/
}

/*
	Name: function_70864ef2
	Namespace: namespace_1c31c03d
	Checksum: 0xAD68602B
	Offset: 0x2BA0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_70864ef2(var_eee0e63b)
{
	/#
		if(isdefined(level.var_51a5abd0))
		{
			function_d8afb0d4(var_eee0e63b);
			zm_devgui::zombie_devgui_goto_round(level.var_51a5abd0);
		}
	#/
}

/*
	Name: function_d8afb0d4
	Namespace: namespace_1c31c03d
	Checksum: 0x6CE71BE8
	Offset: 0x2BF8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_d8afb0d4(var_eee0e63b)
{
	/#
		if(isdefined(var_eee0e63b) && var_eee0e63b > 0)
		{
			SetDvar("Dev Block strings are not supported", var_eee0e63b);
		}
		else
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
}

