#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_bb;
#using scripts\zm\_util;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_bot;
#using scripts\zm\_zm_daily_challenges;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_ffotd;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_player;
#using scripts\zm\_zm_powerup_bonus_points_player;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\aats\_zm_aat_blast_furnace;
#using scripts\zm\aats\_zm_aat_dead_wire;
#using scripts\zm\aats\_zm_aat_fire_works;
#using scripts\zm\aats\_zm_aat_thunder_wall;
#using scripts\zm\aats\_zm_aat_turned;
#using scripts\zm\bgbs\_zm_bgb_aftertaste;
#using scripts\zm\bgbs\_zm_bgb_alchemical_antithesis;
#using scripts\zm\bgbs\_zm_bgb_always_done_swiftly;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\bgbs\_zm_bgb_armamental_accomplishment;
#using scripts\zm\bgbs\_zm_bgb_arms_grace;
#using scripts\zm\bgbs\_zm_bgb_arsenal_accelerator;
#using scripts\zm\bgbs\_zm_bgb_board_games;
#using scripts\zm\bgbs\_zm_bgb_board_to_death;
#using scripts\zm\bgbs\_zm_bgb_bullet_boost;
#using scripts\zm\bgbs\_zm_bgb_burned_out;
#using scripts\zm\bgbs\_zm_bgb_cache_back;
#using scripts\zm\bgbs\_zm_bgb_coagulant;
#using scripts\zm\bgbs\_zm_bgb_crate_power;
#using scripts\zm\bgbs\_zm_bgb_crawl_space;
#using scripts\zm\bgbs\_zm_bgb_danger_closest;
#using scripts\zm\bgbs\_zm_bgb_dead_of_nuclear_winter;
#using scripts\zm\bgbs\_zm_bgb_disorderly_combat;
#using scripts\zm\bgbs\_zm_bgb_ephemeral_enhancement;
#using scripts\zm\bgbs\_zm_bgb_extra_credit;
#using scripts\zm\bgbs\_zm_bgb_eye_candy;
#using scripts\zm\bgbs\_zm_bgb_fatal_contraption;
#using scripts\zm\bgbs\_zm_bgb_fear_in_headlights;
#using scripts\zm\bgbs\_zm_bgb_firing_on_all_cylinders;
#using scripts\zm\bgbs\_zm_bgb_flavor_hexed;
#using scripts\zm\bgbs\_zm_bgb_head_drama;
#using scripts\zm\bgbs\_zm_bgb_idle_eyes;
#using scripts\zm\bgbs\_zm_bgb_im_feelin_lucky;
#using scripts\zm\bgbs\_zm_bgb_immolation_liquidation;
#using scripts\zm\bgbs\_zm_bgb_impatient;
#using scripts\zm\bgbs\_zm_bgb_in_plain_sight;
#using scripts\zm\bgbs\_zm_bgb_kill_joy;
#using scripts\zm\bgbs\_zm_bgb_killing_time;
#using scripts\zm\bgbs\_zm_bgb_licensed_contractor;
#using scripts\zm\bgbs\_zm_bgb_lucky_crit;
#using scripts\zm\bgbs\_zm_bgb_mind_blown;
#using scripts\zm\bgbs\_zm_bgb_near_death_experience;
#using scripts\zm\bgbs\_zm_bgb_newtonian_negation;
#using scripts\zm\bgbs\_zm_bgb_now_you_see_me;
#using scripts\zm\bgbs\_zm_bgb_on_the_house;
#using scripts\zm\bgbs\_zm_bgb_perkaholic;
#using scripts\zm\bgbs\_zm_bgb_phoenix_up;
#using scripts\zm\bgbs\_zm_bgb_pop_shocks;
#using scripts\zm\bgbs\_zm_bgb_power_vacuum;
#using scripts\zm\bgbs\_zm_bgb_profit_sharing;
#using scripts\zm\bgbs\_zm_bgb_projectile_vomiting;
#using scripts\zm\bgbs\_zm_bgb_reign_drops;
#using scripts\zm\bgbs\_zm_bgb_respin_cycle;
#using scripts\zm\bgbs\_zm_bgb_round_robbin;
#using scripts\zm\bgbs\_zm_bgb_secret_shopper;
#using scripts\zm\bgbs\_zm_bgb_self_medication;
#using scripts\zm\bgbs\_zm_bgb_shopping_free;
#using scripts\zm\bgbs\_zm_bgb_slaughter_slide;
#using scripts\zm\bgbs\_zm_bgb_soda_fountain;
#using scripts\zm\bgbs\_zm_bgb_stock_option;
#using scripts\zm\bgbs\_zm_bgb_sword_flay;
#using scripts\zm\bgbs\_zm_bgb_temporal_gift;
#using scripts\zm\bgbs\_zm_bgb_tone_death;
#using scripts\zm\bgbs\_zm_bgb_unbearable;
#using scripts\zm\bgbs\_zm_bgb_undead_man_walking;
#using scripts\zm\bgbs\_zm_bgb_unquenchable;
#using scripts\zm\bgbs\_zm_bgb_wall_power;
#using scripts\zm\bgbs\_zm_bgb_whos_keeping_score;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_vehicle;
#using scripts\zm\gametypes\_weapons;
#using scripts\zm\gametypes\_zm_gametype;

#namespace zm;

/*
	Name: ignore_systems
	Namespace: zm
	Checksum: 0x2FBC46F3
	Offset: 0x3550
	Size: 0x393
	Parameters: 0
	Flags: AutoExec
*/
function autoexec ignore_systems()
{
	system::Ignore("gadget_clone");
	system::Ignore("gadget_armor");
	system::Ignore("gadget_heat_wave");
	system::Ignore("gadget_resurrect");
	system::Ignore("gadget_shock_field");
	system::Ignore("gadget_active_camo");
	system::Ignore("gadget_mrpukey");
	system::Ignore("gadget_misdirection");
	system::Ignore("gadget_smokescreen");
	system::Ignore("gadget_firefly_swarm");
	system::Ignore("gadget_immolation");
	system::Ignore("gadget_forced_malfunction");
	system::Ignore("gadget_sensory_overload");
	system::Ignore("gadget_rapid_strike");
	system::Ignore("gadget_unstoppable_force");
	system::Ignore("gadget_overdrive");
	system::Ignore("gadget_concussive_wave");
	system::Ignore("gadget_ravage_core");
	system::Ignore("gadget_es_strike");
	system::Ignore("gadget_cacophany");
	system::Ignore("gadget_iff_override");
	system::Ignore("gadget_security_breach");
	system::Ignore("gadget_surge");
	system::Ignore("gadget_exo_breakdown");
	system::Ignore("gadget_servo_shortout");
	system::Ignore("gadget_system_overload");
	system::Ignore("gadget_cleanse");
	system::Ignore("gadget_flashback");
	system::Ignore("gadget_combat_efficiency");
	system::Ignore("gadget_other");
	system::Ignore("gadget_camo");
	system::Ignore("gadget_vision_pulse");
	system::Ignore("gadget_speed_burst");
	system::Ignore("gadget_thief");
	system::Ignore("replay_gun");
	system::Ignore("spike_charge_siegebot");
	system::Ignore("siegebot");
	system::Ignore("amws");
}

/*
	Name: __init__sytem__
	Namespace: zm
	Checksum: 0x435733ED
	Offset: 0x38F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm
	Checksum: 0x876A6228
	Offset: 0x3930
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.zombie_vars))
	{
		level.zombie_vars = [];
	}
}

/*
	Name: init
	Namespace: zm
	Checksum: 0xD6FF5513
	Offset: 0x3958
	Size: 0x8FB
	Parameters: 0
	Flags: None
*/
function init()
{
	SetDvar("doublejump_enabled", 0);
	SetDvar("juke_enabled", 0);
	SetDvar("playerEnergy_enabled", 0);
	SetDvar("wallrun_enabled", 0);
	SetDvar("sprintLeap_enabled", 0);
	SetDvar("traverse_mode", 2);
	SetDvar("weaponrest_enabled", 0);
	SetDvar("ui_allowDisplayContinue", 1);
	if(!isdefined(level.killstreakWeapons))
	{
		level.killstreakWeapons = [];
	}
	level.weaponNone = GetWeapon("none");
	level.weaponNull = GetWeapon("weapon_null");
	level.weaponBaseMelee = GetWeapon("knife");
	level.weaponBaseMeleeHeld = GetWeapon("knife_held");
	level.weaponBallisticKnife = GetWeapon("knife_ballistic");
	if(!isdefined(level.weaponRiotshield))
	{
		level.weaponRiotshield = GetWeapon("riotshield");
	}
	level.weaponReviveTool = GetWeapon("syrette");
	level.weaponZMDeathThroe = GetWeapon("death_throe");
	level.weaponZMFists = GetWeapon("zombie_fists");
	if(!isdefined(level.giveCustomLoadout))
	{
		level.giveCustomLoadout = &zm_weapons::give_start_weapons;
	}
	level.projectiles_should_ignore_world_pause = 1;
	level.player_out_of_playable_area_monitor = 1;
	level.player_too_many_weapons_monitor = 1;
	level.player_too_many_weapons_monitor_func = &player_too_many_weapons_monitor;
	level.player_too_many_players_check = 1;
	level.player_too_many_players_check_func = &player_too_many_players_check;
	level._use_choke_weapon_hints = 1;
	level._use_choke_blockers = 1;
	level.speed_change_round = 15;
	level.passed_introscreen = 0;
	if(!isdefined(level.custom_ai_type))
	{
		level.custom_ai_type = [];
	}
	level.custom_ai_spawn_check_funcs = [];
	level thread zm_ffotd::main_start();
	level.zombiemode = 1;
	level.reviveFeature = 0;
	level.swimmingFeature = 0;
	level.calc_closest_player_using_paths = 0;
	level.zombie_melee_in_water = 1;
	level.put_timed_out_zombies_back_in_queue = 1;
	level.use_alternate_poi_positioning = 1;
	level.zmb_laugh_alias = "zmb_laugh_child";
	level.sndAnnouncerIsRich = 1;
	level.scr_zm_ui_gametype = GetDvarString("ui_gametype");
	level.scr_zm_ui_gametype_group = "";
	level.scr_zm_map_start_location = "";
	level.curr_gametype_affects_rank = 0;
	gametype = ToLower(GetDvarString("g_gametype"));
	if("zclassic" == gametype || "zstandard" == gametype)
	{
		level.curr_gametype_affects_rank = 1;
	}
	level.grenade_multiattack_bookmark_count = 1;
	demo::initActorBookmarkParams(3, 6000, 6000);
	if(!isdefined(level._zombies_round_spawn_failsafe))
	{
		level._zombies_round_spawn_failsafe = &zombie_utility::round_spawn_failsafe;
	}
	level.func_get_zombie_spawn_delay = &get_zombie_spawn_delay;
	level.func_get_delay_between_rounds = &get_delay_between_rounds;
	level.zombie_visionset = "zombie_neutral";
	level.wait_and_revive = 0;
	if(GetDvarString("anim_intro") == "1")
	{
		level.zombie_anim_intro = 1;
	}
	else
	{
		level.zombie_anim_intro = 0;
	}
	precache_models();
	precache_zombie_leaderboards();
	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;
	level._ZOMBIE_GIB_PIECE_INDEX_HAT = 7;
	if(!isdefined(level.zombie_ai_limit))
	{
		level.zombie_ai_limit = 24;
	}
	if(!isdefined(level.zombie_actor_limit))
	{
		level.zombie_actor_limit = 31;
	}
	init_flags();
	init_dvars();
	init_strings();
	init_levelvars();
	init_sounds();
	init_shellshocks();
	init_client_field_callback_funcs();
	zm_utility::register_offhand_weapons_for_level_defaults();
	level thread drive_client_connected_notifies();
	zm_craftables::init();
	zm_perks::init();
	zm_powerups::init();
	zm_spawner::init();
	zm_weapons::init();
	level.zombie_poi_array = GetEntArray("zombie_poi", "script_noteworthy");
	init_function_overrides();
	level thread last_stand_pistol_rank_init();
	level thread post_all_players_connected();
	level start_zm_dash_counter_watchers();
	zm_utility::init_utility();
	util::registerClientSys("lsm");
	initializeStatTracking();
	if(GetPlayers().size <= 1)
	{
		incrementCounter("global_solo_games", 1);
	}
	else if(isdefined(level.systemLink) && level.systemLink)
	{
		incrementCounter("global_systemlink_games", 1);
	}
	else if(GetDvarInt("splitscreen_playerCount") == GetPlayers().size)
	{
		incrementCounter("global_splitscreen_games", 1);
	}
	else
	{
		incrementCounter("global_coop_games", 1);
	}
	callback::on_connect(&zm_on_player_connect);
	zm_utility::set_demo_intermission_point();
	level thread zm_ffotd::main_end();
	level thread zm_utility::track_players_intersection_tracker();
	level thread onAllPlayersReady();
	level thread startUnitriggers();
	level thread function_83b0d780();
	callback::on_spawned(&zm_on_player_spawned);
	printHashIDs();
}

/*
	Name: post_main
	Namespace: zm
	Checksum: 0x206EEE61
	Offset: 0x4260
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function post_main()
{
	level thread init_custom_ai_type();
}

/*
	Name: cheat_enabled
	Namespace: zm
	Checksum: 0xD34E2F76
	Offset: 0x4288
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function cheat_enabled(VAL)
{
	if(GetDvarInt("zombie_cheat") >= VAL)
	{
		/#
			return 1;
		#/
		if(function_bdf61114())
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_83b0d780
	Namespace: zm
	Checksum: 0xF6F3A754
	Offset: 0x42E8
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function function_83b0d780()
{
	level flag::wait_till_any(Array("start_zombie_round_logic", "start_encounters_match_logic"));
	while(1)
	{
		var_82d7c36d = get_round_number();
		level.round_number = undefined;
		var_fa2cbc15 = var_82d7c36d;
		switch(RandomInt(5))
		{
			case 0:
			{
				var_d42a41ac = var_82d7c36d;
			}
			case 1:
			{
				var_ae27c743 = var_82d7c36d;
			}
			case 2:
			{
				var_88254cda = var_82d7c36d;
			}
			case 3:
			{
				var_6222d271 = var_82d7c36d;
			}
			case 4:
			{
				var_3c205808 = var_82d7c36d;
			}
		}
		level.round_number = var_82d7c36d;
		var_82d7c36d = undefined;
		var_202f367e = undefined;
		var_fa2cbc15 = undefined;
		var_d42a41ac = undefined;
		var_ae27c743 = undefined;
		var_88254cda = undefined;
		var_6222d271 = undefined;
		var_3c205808 = undefined;
		wait(0.05);
	}
}

/*
	Name: set_round_number
	Namespace: zm
	Checksum: 0x93D97C9B
	Offset: 0x4470
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function set_round_number(new_round)
{
	if(new_round > 255)
	{
		new_round = 255;
	}
	world.var_48b0db18 = new_round ^ 115;
}

/*
	Name: get_round_number
	Namespace: zm
	Checksum: 0x70ACDA70
	Offset: 0x44B0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function get_round_number()
{
	return world.var_48b0db18 ^ 115;
}

/*
	Name: startUnitriggers
	Namespace: zm
	Checksum: 0x5A4E8D64
	Offset: 0x44D0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function startUnitriggers()
{
	level flag::wait_till_any(Array("start_zombie_round_logic", "start_encounters_match_logic"));
	level thread zm_unitrigger::main();
}

/*
	Name: drive_client_connected_notifies
	Namespace: zm
	Checksum: 0x8CCEC013
	Offset: 0x4528
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function drive_client_connected_notifies()
{
	while(1)
	{
		level waittill("connected", player);
		player demo::reset_actor_bookmark_kill_times();
		player callback::callback("hash_eaffea17");
	}
}

/*
	Name: fade_out_intro_screen_zm
	Namespace: zm
	Checksum: 0xE53AA0C4
	Offset: 0x4590
	Size: 0x28B
	Parameters: 3
	Flags: None
*/
function fade_out_intro_screen_zm(hold_black_time, fade_out_time, destroyed_afterwards)
{
	LUI::screen_fade_out(0, undefined);
	if(isdefined(hold_black_time))
	{
		wait(hold_black_time);
	}
	else
	{
		wait(0.2);
	}
	if(!isdefined(fade_out_time))
	{
		fade_out_time = 1.5;
	}
	Array::thread_all(GetPlayers(), &initialBlackEnd);
	level clientfield::set("sndZMBFadeIn", 1);
	LUI::screen_fade_in(fade_out_time, undefined);
	wait(1.6);
	level.passed_introscreen = 1;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(level.customHudReveal))
		{
			players[i] thread [[level.customHudReveal]]();
		}
		else
		{
			players[i] ShowHudAndPlayPromo();
		}
		if(!(isdefined(level.host_ended_game) && level.host_ended_game))
		{
			if(isdefined(level.player_movement_suppressed))
			{
				players[i] FreezeControls(level.player_movement_suppressed);
				/#
					println("Dev Block strings are not supported");
				#/
				continue;
			}
			if(!(isdefined(players[i].hostMigrationControlsFrozen) && players[i].hostMigrationControlsFrozen))
			{
				players[i] FreezeControls(0);
				/#
					println("Dev Block strings are not supported");
				#/
			}
		}
	}
	level flag::set("initial_blackscreen_passed");
	level clientfield::set("gameplay_started", 1);
}

/*
	Name: ShowHudAndPlayPromo
	Namespace: zm
	Checksum: 0x67349B3
	Offset: 0x4828
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function ShowHudAndPlayPromo()
{
	self setClientUIVisibilityFlag("hud_visible", 1);
	self setClientUIVisibilityFlag("weapon_hud_visible", 1);
	if(!isdefined(self.seen_promo_anim) && self.seen_promo_anim && SessionModeIsOnlineGame())
	{
		self LUINotifyEvent(&"play_promo_anim", 0);
		self.seen_promo_anim = 1;
	}
}

/*
	Name: onAllPlayersReady
	Namespace: zm
	Checksum: 0xDF67639D
	Offset: 0x48C8
	Size: 0x4BB
	Parameters: 0
	Flags: None
*/
function onAllPlayersReady()
{
	timeout = GetTime() + 5000;
	while(IsLoadingCinematicPlaying() || (getnumexpectedplayers() == 0 && GetTime() < timeout))
	{
		wait(0.1);
	}
	/#
		println("Dev Block strings are not supported" + getnumexpectedplayers());
	#/
	player_count_actual = 0;
	while(getnumconnectedplayers() < getnumexpectedplayers() || player_count_actual != getnumexpectedplayers())
	{
		players = GetPlayers();
		player_count_actual = 0;
		for(i = 0; i < players.size; i++)
		{
			players[i] FreezeControls(1);
			if(players[i].sessionstate == "playing")
			{
				player_count_actual++;
			}
		}
		/#
			println("Dev Block strings are not supported" + getnumconnectedplayers() + "Dev Block strings are not supported" + getnumexpectedplayers());
		#/
		wait(0.1);
	}
	SetInitialPlayersConnected();
	level flag::set("all_players_connected");
	SetDvar("all_players_are_connected", "1");
	/#
		println("Dev Block strings are not supported");
	#/
	if(1 == getnumconnectedplayers() && GetDvarInt("scr_zm_enable_bots") == 1)
	{
		level thread add_bots();
		level flag::set("initial_players_connected");
	}
	else
	{
		players = GetPlayers();
		if(players.size == 1)
		{
			level flag::set("solo_game");
			level.solo_lives_given = 0;
			foreach(player in players)
			{
				player.lives = 0;
			}
			level set_default_laststand_pistol(1);
		}
		level flag::set("initial_players_connected");
		Array::thread_all(GetPlayers(), &InitialBlack);
		while(!AreTexturesLoaded())
		{
			wait(0.05);
		}
		if(isdefined(level.added_initial_streamer_blackscreen))
		{
			wait(level.added_initial_streamer_blackscreen);
		}
		thread start_zombie_logic_in_x_sec(3);
	}
	set_intermission_point();
	n_black_screen = 5;
	level thread fade_out_intro_screen_zm(n_black_screen, 1.5, 1);
	wait(n_black_screen);
	level.n_gameplay_start_time = GetTime();
	clientfield::set("game_start_time", level.n_gameplay_start_time);
}

/*
	Name: InitialBlack
	Namespace: zm
	Checksum: 0x1F601C99
	Offset: 0x4D90
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function InitialBlack()
{
	self CloseMenu("InitialBlack");
	self openMenu("InitialBlack");
}

/*
	Name: initialBlackEnd
	Namespace: zm
	Checksum: 0xA8C330CD
	Offset: 0x4DE0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function initialBlackEnd()
{
	self CloseMenu("InitialBlack");
}

/*
	Name: start_zombie_logic_in_x_sec
	Namespace: zm
	Checksum: 0xF0EF5A50
	Offset: 0x4E10
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function start_zombie_logic_in_x_sec(time_to_wait)
{
	wait(time_to_wait);
	level flag::set("start_zombie_round_logic");
}

/*
	Name: getAllOtherPlayers
	Namespace: zm
	Checksum: 0x99E476A5
	Offset: 0x4E48
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function getAllOtherPlayers()
{
	aliveplayers = [];
	for(i = 0; i < level.players.size; i++)
	{
		if(!isdefined(level.players[i]))
		{
			continue;
		}
		player = level.players[i];
		if(player.sessionstate != "playing" || player == self)
		{
			continue;
		}
		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}

/*
	Name: updatePlayerNum
	Namespace: zm
	Checksum: 0x53C9AD43
	Offset: 0x4F08
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function updatePlayerNum(player)
{
	if(!isdefined(player.playerNum))
	{
		if(player.team == "allies")
		{
			player.playerNum = zm_utility::get_game_var("_team1_num");
			zm_utility::set_game_var("_team1_num", player.playerNum + 1);
		}
		else
		{
			player.playerNum = zm_utility::get_game_var("_team2_num");
			zm_utility::set_game_var("_team2_num", player.playerNum + 1);
		}
	}
}

/*
	Name: getFreeSpawnpoint
	Namespace: zm
	Checksum: 0x360D40C7
	Offset: 0x4FF8
	Size: 0x499
	Parameters: 2
	Flags: None
*/
function getFreeSpawnpoint(Spawnpoints, player)
{
	if(!isdefined(Spawnpoints))
	{
		/#
			IPrintLnBold("Dev Block strings are not supported");
		#/
		return undefined;
	}
	if(!isdefined(game["spawns_randomized"]))
	{
		game["spawns_randomized"] = 1;
		Spawnpoints = Array::randomize(Spawnpoints);
		random_chance = RandomInt(100);
		if(random_chance > 50)
		{
			zm_utility::set_game_var("side_selection", 1);
		}
		else
		{
			zm_utility::set_game_var("side_selection", 2);
		}
	}
	side_selection = zm_utility::get_game_var("side_selection");
	if(zm_utility::get_game_var("switchedsides"))
	{
		if(side_selection == 2)
		{
			side_selection = 1;
		}
		else if(side_selection == 1)
		{
			side_selection = 2;
		}
	}
	if(isdefined(player) && isdefined(player.team))
	{
		i = 0;
		while(isdefined(Spawnpoints) && i < Spawnpoints.size)
		{
			if(side_selection == 1)
			{
				if(player.team != "allies" && (isdefined(Spawnpoints[i].script_int) && Spawnpoints[i].script_int == 1))
				{
					ArrayRemoveValue(Spawnpoints, Spawnpoints[i]);
					i = 0;
				}
				else if(player.team == "allies" && (isdefined(Spawnpoints[i].script_int) && Spawnpoints[i].script_int == 2))
				{
					ArrayRemoveValue(Spawnpoints, Spawnpoints[i]);
					i = 0;
				}
				else
				{
					i++;
				}
			}
			else if(player.team == "allies" && (isdefined(Spawnpoints[i].script_int) && Spawnpoints[i].script_int == 1))
			{
				ArrayRemoveValue(Spawnpoints, Spawnpoints[i]);
				i = 0;
			}
			else if(player.team != "allies" && (isdefined(Spawnpoints[i].script_int) && Spawnpoints[i].script_int == 2))
			{
				ArrayRemoveValue(Spawnpoints, Spawnpoints[i]);
				i = 0;
			}
			else
			{
				i++;
			}
		}
	}
	updatePlayerNum(player);
	for(j = 0; j < Spawnpoints.size; j++)
	{
		if(!isdefined(Spawnpoints[j].en_num))
		{
			for(m = 0; m < Spawnpoints.size; m++)
			{
				Spawnpoints[m].en_num = m;
			}
		}
		else if(Spawnpoints[j].en_num == player.playerNum)
		{
			return Spawnpoints[j];
		}
	}
	return Spawnpoints[0];
}

/*
	Name: delete_in_createfx
	Namespace: zm
	Checksum: 0x59EBB64B
	Offset: 0x54A0
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function delete_in_createfx()
{
	exterior_goals = struct::get_array("exterior_goal", "targetname");
	for(i = 0; i < exterior_goals.size; i++)
	{
		if(!isdefined(exterior_goals[i].target))
		{
			break;
		}
		targets = GetEntArray(exterior_goals[i].target, "targetname");
		for(j = 0; j < targets.size; j++)
		{
			targets[j] zm_utility::self_delete();
		}
	}
	if(isdefined(level.level_createfx_callback_thread))
	{
		level thread [[level.level_createfx_callback_thread]]();
	}
}

/*
	Name: add_bots
	Namespace: zm
	Checksum: 0xA673FA12
	Offset: 0x55C0
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function add_bots()
{
	for(host = util::getHostPlayer(); !isdefined(host);  = util::getHostPlayer())
	{
		wait(0.05);
	}
	wait(4);
	zbot_spawn();
	SetDvar("bot_AllowMovement", "1");
	SetDvar("bot_PressAttackBtn", "1");
	SetDvar("bot_PressMeleeBtn", "1");
	while(GetPlayers().size < 2)
	{
		wait(0.05);
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] FreezeControls(0);
		/#
			println("Dev Block strings are not supported");
		#/
	}
	level.numberBotsAdded = 1;
	level flag::set("start_zombie_round_logic");
}

/*
	Name: zbot_spawn
	Namespace: zm
	Checksum: 0x852E6382
	Offset: 0x5768
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function zbot_spawn()
{
	player = util::getHostPlayer();
	bot = AddTestClient();
	if(!isdefined(bot))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	spawnpoint = bot zm_gametype::onFindValidSpawnPoint();
	bot.pers["isBot"] = 1;
	bot.equipment_enabled = 0;
	yaw = spawnpoint.angles[1];
	return bot;
}

/*
	Name: post_all_players_connected
	Namespace: zm
	Checksum: 0xA7D21F1C
	Offset: 0x5850
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function post_all_players_connected()
{
	level thread end_game();
	level flag::wait_till("start_zombie_round_logic");
	zm_utility::increment_zm_dash_counter("start_per_game", 1);
	zm_utility::increment_zm_dash_counter("start_per_player", level.players.size);
	zm_utility::upload_zm_dash_counters();
	level.dash_counter_start_player_count = level.players.size;
	/#
		println("Dev Block strings are not supported", level.script, "Dev Block strings are not supported", GetPlayers().size);
	#/
	level thread round_end_monitor();
	if(!level.zombie_anim_intro)
	{
		if(isdefined(level._round_start_func))
		{
			level thread [[level._round_start_func]]();
		}
	}
	level thread players_playing();
	DisableGrenadeSuicide();
	level.startInvulnerableTime = GetDvarInt("player_deathInvulnerableTime");
}

/*
	Name: start_zm_dash_counter_watchers
	Namespace: zm
	Checksum: 0xF35C678C
	Offset: 0x59C0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function start_zm_dash_counter_watchers()
{
	level thread first_consumables_used_watcher();
	level thread players_reached_rounds_counter_watcher();
}

/*
	Name: first_consumables_used_watcher
	Namespace: zm
	Checksum: 0x54779A9E
	Offset: 0x5A00
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function first_consumables_used_watcher()
{
	level flag::init("first_consumables_used");
	level flag::wait_till("first_consumables_used");
	zm_utility::increment_zm_dash_counter("first_consumables_used", 1);
	zm_utility::upload_zm_dash_counters();
}

/*
	Name: players_reached_rounds_counter_watcher
	Namespace: zm
	Checksum: 0x5438E105
	Offset: 0x5A80
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function players_reached_rounds_counter_watcher()
{
	while(1)
	{
		level waittill("start_of_round");
		if(!isdefined(level.dash_counter_round_reached_5) && level.round_number >= 5)
		{
			level.dash_counter_round_reached_5 = 1;
			zm_utility::increment_zm_dash_counter("reached_5", 1);
		}
		if(!isdefined(level.dash_counter_round_reached_10) && level.round_number >= 10)
		{
			level.dash_counter_round_reached_10 = 1;
			zm_utility::increment_zm_dash_counter("reached_10", 1);
			return;
		}
	}
}

/*
	Name: init_custom_ai_type
	Namespace: zm
	Checksum: 0xBF34B5A9
	Offset: 0x5B40
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function init_custom_ai_type()
{
	if(isdefined(level.custom_ai_type))
	{
		for(i = 0; i < level.custom_ai_type.size; i++)
		{
			[[level.custom_ai_type[i]]]();
		}
	}
}

/*
	Name: zombiemode_melee_miss
	Namespace: zm
	Checksum: 0xA7FA0724
	Offset: 0x5B98
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function zombiemode_melee_miss()
{
	if(isdefined(self.enemy.curr_pay_turret))
	{
		self.enemy DoDamage(GetDvarInt("ai_meleeDamage"), self.origin, self, self, "none", "melee");
	}
}

/*
	Name: player_track_ammo_count
	Namespace: zm
	Checksum: 0xF5AD6CFB
	Offset: 0x5C08
	Size: 0x1DB
	Parameters: 0
	Flags: None
*/
function player_track_ammo_count()
{
	self notify("stop_ammo_tracking");
	self endon("disconnect");
	self endon("stop_ammo_tracking");
	ammoLowCount = 0;
	ammoOutCount = 0;
	while(1)
	{
		wait(0.5);
		weapon = self GetCurrentWeapon();
		if(weapon == level.weaponNone || weapon.skiplowammovox)
		{
			continue;
		}
		if(weapon.type == "grenade")
		{
			continue;
		}
		if(self getammocount(weapon) > 5 || self laststand::player_is_in_laststand())
		{
			ammoOutCount = 0;
			ammoLowCount = 0;
			continue;
		}
		if(self getammocount(weapon) > 0)
		{
			if(ammoLowCount < 1)
			{
				self zm_audio::create_and_play_dialog("general", "ammo_low");
				ammoLowCount++;
			}
		}
		else if(ammoOutCount < 1)
		{
			wait(0.5);
			if(self GetCurrentWeapon() !== weapon)
			{
				continue;
			}
			self zm_audio::create_and_play_dialog("general", "ammo_out");
			ammoOutCount++;
		}
		wait(20);
	}
}

/*
	Name: spawn_vo
	Namespace: zm
	Checksum: 0x770B2946
	Offset: 0x5DF0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function spawn_vo()
{
	wait(1);
	players = GetPlayers();
	if(players.size > 1)
	{
		player = Array::random(players);
		index = zm_utility::get_player_index(player);
		player thread spawn_vo_player(index, players.size);
	}
}

/*
	Name: spawn_vo_player
	Namespace: zm
	Checksum: 0x220D6778
	Offset: 0x5E98
	Size: 0x6F
	Parameters: 2
	Flags: None
*/
function spawn_vo_player(index, num)
{
	sound = "plr_" + index + "_vox_" + num + "play";
	self PlaySoundWithNotify(sound, "sound_done");
	self waittill("sound_done");
}

/*
	Name: precache_models
	Namespace: zm
	Checksum: 0x507B05D6
	Offset: 0x5F10
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function precache_models()
{
	if(isdefined(level.precacheCustomCharacters))
	{
		self [[level.precacheCustomCharacters]]();
	}
}

/*
	Name: init_shellshocks
	Namespace: zm
	Checksum: 0x6D14B74E
	Offset: 0x5F38
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function init_shellshocks()
{
	level.player_killed_shellshock = "zombie_death";
}

/*
	Name: init_strings
	Namespace: zm
	Checksum: 0xBAAF43EC
	Offset: 0x5F58
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function init_strings()
{
	zm_utility::add_zombie_hint("undefined", &"ZOMBIE_UNDEFINED");
	zm_utility::add_zombie_hint("default_treasure_chest", &"ZOMBIE_RANDOM_WEAPON_COST");
	zm_utility::add_zombie_hint("default_buy_barrier_piece_10", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_10");
	zm_utility::add_zombie_hint("default_buy_barrier_piece_20", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_20");
	zm_utility::add_zombie_hint("default_buy_barrier_piece_50", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_50");
	zm_utility::add_zombie_hint("default_buy_barrier_piece_100", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_100");
	zm_utility::add_zombie_hint("default_reward_barrier_piece", &"ZOMBIE_BUTTON_REWARD_BARRIER");
	zm_utility::add_zombie_hint("default_buy_area", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_COST");
}

/*
	Name: init_sounds
	Namespace: zm
	Checksum: 0x43B0AD9C
	Offset: 0x6068
	Size: 0x3E3
	Parameters: 0
	Flags: None
*/
function init_sounds()
{
	zm_utility::add_sound("end_of_round", "mus_zmb_round_over");
	zm_utility::add_sound("end_of_game", "mus_zmb_game_over");
	zm_utility::add_sound("chalk_one_up", "mus_zmb_chalk");
	zm_utility::add_sound("purchase", "zmb_cha_ching");
	zm_utility::add_sound("no_purchase", "zmb_no_cha_ching");
	zm_utility::add_sound("playerzombie_usebutton_sound", "zmb_zombie_vocals_attack");
	zm_utility::add_sound("playerzombie_attackbutton_sound", "zmb_zombie_vocals_attack");
	zm_utility::add_sound("playerzombie_adsbutton_sound", "zmb_zombie_vocals_attack");
	zm_utility::add_sound("zombie_head_gib", "zmb_zombie_head_gib");
	zm_utility::add_sound("rebuild_barrier_piece", "zmb_repair_boards");
	zm_utility::add_sound("rebuild_barrier_metal_piece", "zmb_metal_repair");
	zm_utility::add_sound("rebuild_barrier_hover", "zmb_boards_float");
	zm_utility::add_sound("debris_hover_loop", "zmb_couch_loop");
	zm_utility::add_sound("break_barrier_piece", "zmb_break_boards");
	zm_utility::add_sound("grab_metal_bar", "zmb_bar_pull");
	zm_utility::add_sound("break_metal_bar", "zmb_bar_break");
	zm_utility::add_sound("drop_metal_bar", "zmb_bar_drop");
	zm_utility::add_sound("blocker_end_move", "zmb_board_slam");
	zm_utility::add_sound("barrier_rebuild_slam", "zmb_board_slam");
	zm_utility::add_sound("bar_rebuild_slam", "zmb_bar_repair");
	zm_utility::add_sound("zmb_rock_fix", "zmb_break_rock_barrier_fix");
	zm_utility::add_sound("zmb_vent_fix", "evt_vent_slat_repair");
	zm_utility::add_sound("zmb_barrier_debris_move", "zmb_barrier_debris_move");
	zm_utility::add_sound("door_slide_open", "zmb_door_slide_open");
	zm_utility::add_sound("door_rotate_open", "zmb_door_slide_open");
	zm_utility::add_sound("debris_move", "zmb_weap_wall");
	zm_utility::add_sound("open_chest", "zmb_lid_open");
	zm_utility::add_sound("music_chest", "zmb_music_box");
	zm_utility::add_sound("close_chest", "zmb_lid_close");
	zm_utility::add_sound("weapon_show", "zmb_weap_wall");
	zm_utility::add_sound("break_stone", "evt_break_stone");
}

/*
	Name: init_levelvars
	Namespace: zm
	Checksum: 0x3878AF35
	Offset: 0x6458
	Size: 0x9BB
	Parameters: 0
	Flags: None
*/
function init_levelvars()
{
	level.is_zombie_level = 1;
	level.default_laststandpistol = GetWeapon("pistol_standard");
	level.default_solo_laststandpistol = GetWeapon("pistol_standard_upgraded");
	level.super_ee_weapon = GetWeapon("pistol_burst");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level.first_round = 1;
	level.start_round = GetGametypeSetting("startRound");
	level.round_number = level.start_round;
	level.enable_magic = GetGametypeSetting("magic");
	level.headshots_only = GetGametypeSetting("headshotsonly");
	level.player_starting_points = level.round_number * 500;
	level.round_start_time = 0;
	level.pro_tips_start_time = 0;
	level.intermission = 0;
	level.dog_intermission = 0;
	level.zombie_total = 0;
	level.zombie_respawns = 0;
	level.total_zombies_killed = 0;
	level.hudelem_count = 0;
	level.zm_loc_types = [];
	level.zm_loc_types["zombie_location"] = [];
	level.zm_variant_type_max = [];
	level.zm_variant_type_max["walk"] = [];
	level.zm_variant_type_max["run"] = [];
	level.zm_variant_type_max["sprint"] = [];
	level.zm_variant_type_max["super_sprint"] = [];
	level.zm_variant_type_max["walk"]["down"] = 14;
	level.zm_variant_type_max["walk"]["up"] = 16;
	level.zm_variant_type_max["run"]["down"] = 13;
	level.zm_variant_type_max["run"]["up"] = 12;
	level.zm_variant_type_max["sprint"]["down"] = 9;
	level.zm_variant_type_max["sprint"]["up"] = 8;
	level.zm_variant_type_max["super_sprint"]["down"] = 1;
	level.zm_variant_type_max["super_sprint"]["up"] = 1;
	level.zm_variant_type_max["burned"]["down"] = 1;
	level.zm_variant_type_max["burned"]["up"] = 1;
	level.zm_variant_type_max["jump_pad_super_sprint"]["down"] = 1;
	level.zm_variant_type_max["jump_pad_super_sprint"]["up"] = 1;
	level.current_zombie_array = [];
	level.current_zombie_count = 0;
	level.zombie_total_subtract = 0;
	level.destructible_callbacks = [];
	foreach(team in level.teams)
	{
		if(!isdefined(level.zombie_vars[team]))
		{
			level.zombie_vars[team] = [];
		}
	}
	difficulty = 1;
	column = Int(difficulty) + 1;
	zombie_utility::set_zombie_var("zombie_health_increase", 100, 0, column);
	zombie_utility::set_zombie_var("zombie_health_increase_multiplier", 0.1, 1, column);
	zombie_utility::set_zombie_var("zombie_health_start", 150, 0, column);
	zombie_utility::set_zombie_var("zombie_spawn_delay", 2, 1, column);
	zombie_utility::set_zombie_var("zombie_new_runner_interval", 10, 0, column);
	zombie_utility::set_zombie_var("zombie_move_speed_multiplier", 4, 0, column);
	zombie_utility::set_zombie_var("zombie_move_speed_multiplier_easy", 2, 0, column);
	zombie_utility::set_zombie_var("zombie_max_ai", 24, 0, column);
	zombie_utility::set_zombie_var("zombie_ai_per_player", 6, 0, column);
	zombie_utility::set_zombie_var("below_world_check", -1000);
	zombie_utility::set_zombie_var("spectators_respawn", 1);
	zombie_utility::set_zombie_var("zombie_use_failsafe", 1);
	zombie_utility::set_zombie_var("zombie_between_round_time", 10);
	zombie_utility::set_zombie_var("zombie_intermission_time", 15);
	zombie_utility::set_zombie_var("game_start_delay", 0, 0, column);
	zombie_utility::set_zombie_var("player_base_health", 100);
	zombie_utility::set_zombie_var("penalty_no_revive", 0.1, 1, column);
	zombie_utility::set_zombie_var("penalty_died", 0, 1, column);
	zombie_utility::set_zombie_var("penalty_downed", 0.05, 1, column);
	zombie_utility::set_zombie_var("zombie_score_kill_4player", 50);
	zombie_utility::set_zombie_var("zombie_score_kill_3player", 50);
	zombie_utility::set_zombie_var("zombie_score_kill_2player", 50);
	zombie_utility::set_zombie_var("zombie_score_kill_1player", 50);
	zombie_utility::set_zombie_var("zombie_score_damage_normal", 10);
	zombie_utility::set_zombie_var("zombie_score_damage_light", 10);
	zombie_utility::set_zombie_var("zombie_score_bonus_melee", 80);
	zombie_utility::set_zombie_var("zombie_score_bonus_head", 50);
	zombie_utility::set_zombie_var("zombie_score_bonus_neck", 20);
	zombie_utility::set_zombie_var("zombie_score_bonus_torso", 10);
	zombie_utility::set_zombie_var("zombie_score_bonus_burn", 10);
	zombie_utility::set_zombie_var("zombie_flame_dmg_point_delay", 500);
	zombie_utility::set_zombie_var("zombify_player", 0);
	if(IsSplitscreen())
	{
		zombie_utility::set_zombie_var("zombie_timer_offset", 280);
	}
	level thread init_player_levelvars();
	level.gamedifficulty = GetGametypeSetting("zmDifficulty");
	if(level.gamedifficulty == 0)
	{
		level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
	}
	else
	{
		level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
	}
	if(level.round_number == 1)
	{
		level.zombie_move_speed = 1;
	}
	level.speed_change_max = 0;
	level.speed_change_num = 0;
	set_round_number(level.round_number);
}

/*
	Name: init_player_levelvars
	Namespace: zm
	Checksum: 0x9547CB0
	Offset: 0x6E20
	Size: 0xF1
	Parameters: 0
	Flags: None
*/
function init_player_levelvars()
{
	level flag::wait_till("start_zombie_round_logic");
	difficulty = 1;
	column = Int(difficulty) + 1;
	for(i = 0; i < 8; i++)
	{
		points = 500;
		if(i > 3)
		{
			points = 3000;
		}
		points = zombie_utility::set_zombie_var("zombie_score_start_" + i + 1 + "p", points, 0, column);
	}
}

/*
	Name: init_dvars
	Namespace: zm
	Checksum: 0xE432219C
	Offset: 0x6F20
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function init_dvars()
{
	if(GetDvarString("zombie_debug") == "")
	{
		SetDvar("zombie_debug", "0");
	}
	if(GetDvarString("scr_zm_enable_bots") == "")
	{
		SetDvar("scr_zm_enable_bots", "0");
	}
	if(GetDvarString("zombie_cheat") == "")
	{
		SetDvar("zombie_cheat", "0");
	}
	if(GetDvarString("zombiemode_debug_zombie_count") == "")
	{
		SetDvar("zombiemode_debug_zombie_count", "0");
	}
	if(level.script != "zombie_cod5_prototype")
	{
		SetDvar("magic_chest_movable", "1");
	}
	SetDvar("revive_trigger_radius", "75");
	SetDvar("scr_deleteexplosivesonspawn", "0");
}

/*
	Name: init_function_overrides
	Namespace: zm
	Checksum: 0xD8C2ED9E
	Offset: 0x70C8
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function init_function_overrides()
{
	level.callbackPlayerDamage = &Callback_PlayerDamage;
	level.overridePlayerDamage = &player_damage_override;
	level.callbackPlayerKilled = &player_killed_override;
	level.playerlaststand_func = &player_laststand;
	level.callbackPlayerLastStand = &Callback_PlayerLastStand;
	level.prevent_player_damage = &player_prevent_damage;
	level.callbackActorKilled = &actor_killed_override;
	level.callbackActorDamage = &actor_damage_override_wrapper;
	level.callbackVehicleDamage = &vehicle_damage_override;
	level.callbackVehicleKilled = &globallogic_vehicle::Callback_VehicleKilled;
	level.callbackVehicleRadiusDamage = &globallogic_vehicle::Callback_VehicleRadiusDamage;
	level.custom_introscreen = &zombie_intro_screen;
	level.custom_intermission = &player_intermission;
	level.global_damage_func = &zm_spawner::zombie_damage;
	level.global_damage_func_ads = &zm_spawner::zombie_damage_ads;
	level.reset_clientdvars = &onPlayerConnect_clientDvars;
	level.zombie_last_stand = &last_stand_pistol_swap;
	level.zombie_last_stand_pistol_memory = &last_stand_save_pistol_ammo;
	level.zombie_last_stand_ammo_return = &last_stand_restore_pistol_ammo;
	level.player_becomes_zombie = &zombify_player;
	level.validate_enemy_path_length = &zm_utility::default_validate_enemy_path_length;
}

/*
	Name: Callback_PlayerLastStand
	Namespace: zm
	Checksum: 0x3D93F68
	Offset: 0x72D0
	Size: 0x8B
	Parameters: 9
	Flags: None
*/
function Callback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("disconnect");
	zm_laststand::PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}

/*
	Name: CodeCallback_DestructibleEvent
	Namespace: zm
	Checksum: 0x2D66980B
	Offset: 0x7368
	Size: 0x11B
	Parameters: 4
	Flags: None
*/
function CodeCallback_DestructibleEvent(event, param1, param2, param3)
{
	if(event == "broken")
	{
		notify_type = param1;
		attacker = param2;
		weapon = param3;
		if(isdefined(level.destructible_callbacks[notify_type]))
		{
			self thread [[level.destructible_callbacks[notify_type]]](notify_type, attacker);
		}
		self notify(event, notify_type, attacker);
	}
	else if(event == "breakafter")
	{
		piece = param1;
		time = param2;
		damage = param3;
		self thread breakAfter(time, damage, piece);
	}
}

/*
	Name: breakAfter
	Namespace: zm
	Checksum: 0xF97AD49D
	Offset: 0x7490
	Size: 0x63
	Parameters: 3
	Flags: None
*/
function breakAfter(time, damage, piece)
{
	self notify("breakAfter");
	self endon("breakAfter");
	wait(time);
	self DoDamage(damage, self.origin, undefined, undefined);
}

/*
	Name: Callback_PlayerDamage
	Namespace: zm
	Checksum: 0xEE7FBD87
	Offset: 0x7500
	Size: 0x6AB
	Parameters: 13
	Flags: None
*/
function Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal)
{
	startedInLastStand = 0;
	if(isPlayer(self))
	{
		startedInLastStand = self laststand::player_is_in_laststand();
	}
	/#
		println("Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported");
	#/
	if(isdefined(eAttacker) && isPlayer(eAttacker) && eAttacker.sessionteam == self.sessionteam && !eAttacker hasPerk("specialty_playeriszombie") && (!isdefined(self.is_zombie) && self.is_zombie))
	{
		self process_friendly_fire_callbacks(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
		if(self != eAttacker)
		{
			/#
				println("Dev Block strings are not supported");
			#/
			return;
		}
		else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" && sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_PROJECTILE" && sMeansOfDeath != "MOD_PROJECTILE_SPLASH" && sMeansOfDeath != "MOD_BURNED" && sMeansOfDeath != "MOD_SUICIDE")
		{
			/#
				println("Dev Block strings are not supported");
			#/
			return;
		}
	}
	if(isdefined(level.pers_upgrade_insta_kill) && level.pers_upgrade_insta_kill)
	{
		self zm_pers_upgrades_functions::pers_insta_kill_melee_swipe(sMeansOfDeath, eAttacker);
	}
	if(isdefined(self.overridePlayerDamage))
	{
		iDamage = self [[self.overridePlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
	}
	else if(isdefined(level.overridePlayerDamage))
	{
		iDamage = self [[level.overridePlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
	}
	/#
		Assert(isdefined(iDamage), "Dev Block strings are not supported");
	#/
	if(isdefined(self.magic_bullet_shield) && self.magic_bullet_shield)
	{
		maxhealth = self.maxhealth;
		self.health = self.health + iDamage;
		self.maxhealth = maxhealth;
	}
	if(isdefined(self.divetoprone) && self.divetoprone == 1)
	{
		if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
		{
			dist = Distance2D(vPoint, self.origin);
			if(dist > 32)
			{
				dot_product = VectorDot(AnglesToForward(self.angles), vDir);
				if(dot_product > 0)
				{
					iDamage = Int(iDamage * 0.5);
				}
			}
		}
	}
	/#
		println("Dev Block strings are not supported");
	#/
	if(isdefined(level.prevent_player_damage))
	{
		if(self [[level.prevent_player_damage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime))
		{
			return;
		}
	}
	iDFlags = iDFlags | level.IDFLAGS_NO_KNOCKBACK;
	if(iDamage > 0 && sHitLoc == "riotshield")
	{
		sHitLoc = "torso_upper";
	}
	/#
		println("Dev Block strings are not supported");
	#/
	wasDowned = 0;
	if(isPlayer(self))
	{
		wasDowned = !startedInLastStand && self laststand::player_is_in_laststand();
	}
	/#
		if(isdefined(eAttacker))
		{
			Record3DText("Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported" + self.health + "Dev Block strings are not supported" + eAttacker GetEntityNumber(), self.origin, (1, 0, 0), "Dev Block strings are not supported", self);
		}
		else
		{
			Record3DText("Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported" + self.health + "Dev Block strings are not supported", self.origin, (1, 0, 0), "Dev Block strings are not supported", self);
		}
	#/
	self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
	bb::function_2aa586aa(eAttacker, self, weapon, iDamage, sMeansOfDeath, sHitLoc, self.health <= 0, wasDowned);
}

/*
	Name: finishPlayerDamageWrapper
	Namespace: zm
	Checksum: 0x59CE70F
	Offset: 0x7BB8
	Size: 0xB3
	Parameters: 13
	Flags: None
*/
function finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal)
{
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
}

/*
	Name: register_player_friendly_fire_callback
	Namespace: zm
	Checksum: 0x4FBE04B8
	Offset: 0x7C78
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_player_friendly_fire_callback(callback)
{
	if(!isdefined(level.player_friendly_fire_callbacks))
	{
		level.player_friendly_fire_callbacks = [];
	}
	level.player_friendly_fire_callbacks[level.player_friendly_fire_callbacks.size] = callback;
}

/*
	Name: process_friendly_fire_callbacks
	Namespace: zm
	Checksum: 0x6BEFCFF2
	Offset: 0x7CC0
	Size: 0x111
	Parameters: 11
	Flags: None
*/
function process_friendly_fire_callbacks(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
{
	if(isdefined(level.player_friendly_fire_callbacks))
	{
		foreach(callback in level.player_friendly_fire_callbacks)
		{
			self [[callback]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
		}
	}
}

/*
	Name: init_flags
	Namespace: zm
	Checksum: 0x9ADC2D6E
	Offset: 0x7DE0
	Size: 0x2D9
	Parameters: 0
	Flags: None
*/
function init_flags()
{
	level flag::init("solo_game");
	level flag::init("start_zombie_round_logic");
	level flag::init("start_encounters_match_logic");
	level flag::init("spawn_point_override");
	level flag::init("crawler_round");
	level flag::init("spawn_zombies", 1);
	level flag::init("special_round");
	level flag::init("dog_round");
	level flag::init("raps_round");
	level flag::init("begin_spawning");
	level flag::init("end_round_wait");
	level flag::init("wait_and_revive");
	level flag::init("instant_revive");
	level flag::init("initial_blackscreen_passed");
	level flag::init("initial_players_connected");
	level flag::init("power_on");
	power_trigs = GetEntArray("use_elec_switch", "targetname");
	foreach(trig in power_trigs)
	{
		if(isdefined(trig.script_int))
		{
			level flag::init("power_on" + trig.script_int);
		}
	}
}

/*
	Name: init_client_field_callback_funcs
	Namespace: zm
	Checksum: 0x1E10F555
	Offset: 0x80C8
	Size: 0x3BB
	Parameters: 0
	Flags: None
*/
function init_client_field_callback_funcs()
{
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int");
	if(isdefined(level.use_water_risers) && level.use_water_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_water", 1, 1, "int");
	}
	if(isdefined(level.use_foliage_risers) && level.use_foliage_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_foliage", 1, 1, "int");
	}
	if(isdefined(level.use_low_gravity_risers) && level.use_low_gravity_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_lowg", 1, 1, "int");
	}
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int");
	clientfield::register("actor", "zombie_ragdoll_explode", 1, 1, "int");
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int");
	clientfield::register("actor", "sndZombieContext", -1, 1, "int");
	clientfield::register("actor", "zombie_keyline_render", 1, 1, "int");
	bits = 4;
	trigs = GetEntArray("use_elec_switch", "targetname");
	if(isdefined(trigs))
	{
		bits = GetMinBitCountForNum(trigs.size + 1);
	}
	clientfield::register("world", "zombie_power_on", 1, bits, "int");
	clientfield::register("world", "zombie_power_off", 1, bits, "int");
	clientfield::register("world", "round_complete_time", 1, 20, "int");
	clientfield::register("world", "round_complete_num", 1, 8, "int");
	clientfield::register("world", "game_end_time", 1, 20, "int");
	clientfield::register("world", "quest_complete_time", 1, 20, "int");
	clientfield::register("world", "game_start_time", 15001, 20, "int");
}

/*
	Name: init_fx
	Namespace: zm
	Checksum: 0xD66CD9EA
	Offset: 0x8490
	Size: 0x331
	Parameters: 0
	Flags: None
*/
function init_fx()
{
	level.createfx_callback_thread = &delete_in_createfx;
	level._effect["fx_zombie_bar_break"] = "_t6/maps/zombie/fx_zombie_bar_break";
	level._effect["fx_zombie_bar_break_lite"] = "_t6/maps/zombie/fx_zombie_bar_break_lite";
	if(!(isdefined(level.FX_exclude_edge_fog) && level.FX_exclude_edge_fog))
	{
		level._effect["edge_fog"] = "_t6/maps/zombie/fx_fog_zombie_amb";
	}
	level._effect["chest_light"] = "zombie/fx_weapon_box_open_glow_zmb";
	level._effect["chest_light_closed"] = "zombie/fx_weapon_box_closed_glow_zmb";
	if(!(isdefined(level.FX_exclude_default_eye_glow) && level.FX_exclude_default_eye_glow))
	{
		level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	}
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	if(!(isdefined(level.FX_exclude_tesla_head_light) && level.FX_exclude_tesla_head_light))
	{
		level._effect["tesla_head_light"] = "_t6/maps/zombie/fx_zombie_tesla_neck_spurt";
	}
	level._effect["zombie_guts_explosion"] = "zombie/fx_blood_torso_explo_lg_zmb";
	level._effect["rise_burst_water"] = "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow_water"] = "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust_water"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["rise_burst"] = "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"] = "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["fall_burst"] = "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["fall_billow"] = "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["fall_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["character_fire_death_sm"] = "zombie/fx_fire_torso_zmb";
	level._effect["character_fire_death_torso"] = "zombie/fx_fire_torso_zmb";
	if(!(isdefined(level.fx_exclude_default_explosion) && level.fx_exclude_default_explosion))
	{
		level._effect["def_explosion"] = "_t6/explosions/fx_default_explosion";
	}
	if(!(isdefined(level.disable_fx_upgrade_aquired) && level.disable_fx_upgrade_aquired))
	{
		level._effect["upgrade_aquired"] = "_t6/maps/zombie/fx_zmb_tanzit_upgrade";
	}
}

/*
	Name: zombie_intro_screen
	Namespace: zm
	Checksum: 0x477EF2A4
	Offset: 0x87D0
	Size: 0x4B
	Parameters: 5
	Flags: None
*/
function zombie_intro_screen(string1, string2, string3, string4, string5)
{
	level flag::wait_till("start_zombie_round_logic");
}

/*
	Name: players_playing
	Namespace: zm
	Checksum: 0x8453F8CD
	Offset: 0x8828
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function players_playing()
{
	players = GetPlayers();
	level.players_playing = players.size;
	wait(20);
	players = GetPlayers();
	level.players_playing = players.size;
}

/*
	Name: onPlayerConnect_clientDvars
	Namespace: zm
	Checksum: 0x4D782060
	Offset: 0x8890
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function onPlayerConnect_clientDvars()
{
	self SetClientCompass(0);
	self SetClientThirdPerson(0);
	self resetFov();
	self SetClientThirdPersonAngle(0);
	self setClientUIVisibilityFlag("weapon_hud_visible", 1);
	self SetClientMiniScoreboardHide(1);
	self SetClientHUDHardcore(0);
	self SetClientPlayerPushAmount(1);
	self setDepthOfField(0, 0, 512, 4000, 4, 0);
	self zm_laststand::player_getup_setup();
}

/*
	Name: checkForAllDead
	Namespace: zm
	Checksum: 0x2C6FE200
	Offset: 0x89A8
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function checkForAllDead(excluded_player)
{
	players = GetPlayers();
	count = 0;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(excluded_player) && excluded_player == players[i])
		{
			continue;
		}
		if(!players[i] laststand::player_is_in_laststand() && !players[i].sessionstate == "spectator")
		{
			count++;
		}
	}
	if(count == 0 && (!isdefined(level.no_end_game_check) && level.no_end_game_check))
	{
		level notify("end_game");
	}
}

/*
	Name: onPlayerSpawned
	Namespace: zm
	Checksum: 0x53B3E651
	Offset: 0x8AB0
	Size: 0x4FF
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	self endon("disconnect");
	self notify("stop_onPlayerSpawned");
	self endon("stop_onPlayerSpawned");
	for(;;)
	{
		self waittill("spawned_player");
		if(!(isdefined(level.host_ended_game) && level.host_ended_game))
		{
			self FreezeControls(0);
			/#
				println("Dev Block strings are not supported");
			#/
		}
		self.hits = 0;
		self zm_utility::init_player_offhand_weapons();
		lethal_grenade = self zm_utility::get_player_lethal_grenade();
		if(!self HasWeapon(lethal_grenade))
		{
			self GiveWeapon(lethal_grenade);
			self SetWeaponAmmoClip(lethal_grenade, 0);
		}
		self RecordPlayerReviveZombies(self);
		/#
			if(GetDvarInt("Dev Block strings are not supported") >= 1 && GetDvarInt("Dev Block strings are not supported") <= 3)
			{
				self EnableInvulnerability();
			}
		#/
		self SetActionSlot(3, "altMode");
		self PlayerKnockback(0);
		self SetClientThirdPerson(0);
		self resetFov();
		self SetClientThirdPersonAngle(0);
		self setDepthOfField(0, 0, 512, 4000, 4, 0);
		self CameraActivate(0);
		self.num_perks = 0;
		self.on_lander_last_stand = undefined;
		self setblur(0, 0.1);
		self.zmbDialogQueue = [];
		self.zmbDialogActive = 0;
		self.zmbDialogGroups = [];
		self.zmbDialogGroup = "";
		if(isdefined(level.player_out_of_playable_area_monitor) && level.player_out_of_playable_area_monitor)
		{
			self thread player_out_of_playable_area_monitor();
		}
		if(isdefined(level.player_too_many_weapons_monitor) && level.player_too_many_weapons_monitor)
		{
			self thread [[level.player_too_many_weapons_monitor_func]]();
		}
		if(isdefined(level.player_too_many_players_check) && level.player_too_many_players_check)
		{
			level thread [[level.player_too_many_players_check_func]]();
		}
		self.disabled_perks = [];
		if(isdefined(self.player_initialized))
		{
			if(self.player_initialized == 0)
			{
				self.player_initialized = 1;
				self GiveWeapon(self zm_utility::get_player_lethal_grenade());
				self SetWeaponAmmoClip(self zm_utility::get_player_lethal_grenade(), 0);
				self setClientUIVisibilityFlag("weapon_hud_visible", 1);
				self SetClientMiniScoreboardHide(0);
				self.IS_DRINKING = 0;
				self thread player_zombie_breadcrumb();
				self thread player_monitor_travel_dist();
				self thread player_monitor_time_played();
				if(isdefined(level.custom_player_track_ammo_count))
				{
					self thread [[level.custom_player_track_ammo_count]]();
				}
				else
				{
					self thread player_track_ammo_count();
				}
				self thread zm_utility::shock_onpain();
				self thread player_grenade_watcher();
				self laststand::revive_hud_create();
				if(isdefined(level.zm_gamemodule_spawn_func))
				{
					self thread [[level.zm_gamemodule_spawn_func]]();
				}
				self thread player_spawn_protection();
				if(!isdefined(self.lives))
				{
					self.lives = 0;
				}
			}
		}
	}
}

/*
	Name: player_spawn_protection
	Namespace: zm
	Checksum: 0xEEBACD21
	Offset: 0x8FB8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function player_spawn_protection()
{
	self endon("disconnect");
	self zm_utility::increment_ignoreme();
	for(x = 0; x < 60; x++)
	{
		wait(0.05);
	}
	self zm_utility::decrement_ignoreme();
}

/*
	Name: spawn_life_brush
	Namespace: zm
	Checksum: 0x397625D9
	Offset: 0x9030
	Size: 0x67
	Parameters: 3
	Flags: None
*/
function spawn_life_brush(origin, radius, height)
{
	life_brush = spawn("trigger_radius", origin, 0, radius, height);
	life_brush.script_noteworthy = "life_brush";
	return life_brush;
}

/*
	Name: in_life_brush
	Namespace: zm
	Checksum: 0xECEB9729
	Offset: 0x90A0
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function in_life_brush()
{
	life_brushes = GetEntArray("life_brush", "script_noteworthy");
	if(!isdefined(life_brushes))
	{
		return 0;
	}
	for(i = 0; i < life_brushes.size; i++)
	{
		if(self istouching(life_brushes[i]))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: spawn_kill_brush
	Namespace: zm
	Checksum: 0x72B480B4
	Offset: 0x9138
	Size: 0x67
	Parameters: 3
	Flags: None
*/
function spawn_kill_brush(origin, radius, height)
{
	kill_brush = spawn("trigger_radius", origin, 0, radius, height);
	kill_brush.script_noteworthy = "kill_brush";
	return kill_brush;
}

/*
	Name: in_kill_brush
	Namespace: zm
	Checksum: 0x8DA70110
	Offset: 0x91A8
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function in_kill_brush()
{
	kill_brushes = GetEntArray("kill_brush", "script_noteworthy");
	self.kill_brush = undefined;
	if(!isdefined(kill_brushes))
	{
		return 0;
	}
	for(i = 0; i < kill_brushes.size; i++)
	{
		if(self istouching(kill_brushes[i]))
		{
			self.kill_brush = kill_brushes[i];
			return 1;
		}
	}
	return 0;
}

/*
	Name: in_enabled_playable_area
	Namespace: zm
	Checksum: 0x701D04CD
	Offset: 0x9260
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function in_enabled_playable_area()
{
	zm_zonemgr::wait_zone_flags_updating();
	playable_area = GetEntArray("player_volume", "script_noteworthy");
	if(!isdefined(playable_area))
	{
		return 0;
	}
	for(i = 0; i < playable_area.size; i++)
	{
		if(zm_zonemgr::zone_is_enabled(playable_area[i].targetname) && self istouching(playable_area[i]))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: get_player_out_of_playable_area_monitor_wait_time
	Namespace: zm
	Checksum: 0x4318C6C5
	Offset: 0x9330
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function get_player_out_of_playable_area_monitor_wait_time()
{
	/#
		if(isdefined(level.check_kill_thread_every_frame) && level.check_kill_thread_every_frame)
		{
			return 0.05;
		}
	#/
	return 3;
}

/*
	Name: player_out_of_playable_area_monitor
	Namespace: zm
	Checksum: 0xB222E902
	Offset: 0x9368
	Size: 0x37F
	Parameters: 0
	Flags: None
*/
function player_out_of_playable_area_monitor()
{
	self notify("stop_player_out_of_playable_area_monitor");
	self endon("stop_player_out_of_playable_area_monitor");
	self endon("disconnect");
	level endon("end_game");
	while(!isdefined(self.characterindex))
	{
		wait(0.05);
	}
	wait(0.15 * self.characterindex);
	while(1)
	{
		if(self.sessionstate == "spectator")
		{
			wait(get_player_out_of_playable_area_monitor_wait_time());
			continue;
		}
		if(isdefined(level.hostmigration_occured) && level.hostmigration_occured)
		{
			wait(get_player_out_of_playable_area_monitor_wait_time());
			continue;
		}
		if(!self in_life_brush() && (self in_kill_brush() || !self in_enabled_playable_area() || (isdefined(level.player_out_of_playable_area_override) && (isdefined(self [[level.player_out_of_playable_area_override]]()) && self [[level.player_out_of_playable_area_override]]()))))
		{
			if(!isdefined(level.player_out_of_playable_area_monitor_callback) || self [[level.player_out_of_playable_area_monitor_callback]]())
			{
				/#
					if(isdefined(level.kill_thread_test_mode) && level.kill_thread_test_mode)
					{
						PrintTopRightln("Dev Block strings are not supported" + self.origin);
						wait(get_player_out_of_playable_area_monitor_wait_time());
						continue;
					}
					if(self IsInMoveMode("Dev Block strings are not supported", "Dev Block strings are not supported") || (isdefined(level.disable_kill_thread) && level.disable_kill_thread) || GetDvarInt("Dev Block strings are not supported") > 0)
					{
						wait(get_player_out_of_playable_area_monitor_wait_time());
						continue;
					}
				#/
				self zm_stats::increment_map_cheat_stat("cheat_out_of_playable");
				self zm_stats::increment_client_stat("cheat_out_of_playable", 0);
				self zm_stats::increment_client_stat("cheat_total", 0);
				self playlocalsound(level.zmb_laugh_alias);
				wait(0.5);
				if(GetPlayers().size == 1 && level flag::get("solo_game") && (isdefined(self.waiting_to_revive) && self.waiting_to_revive))
				{
					level notify("end_game");
				}
				else
				{
					self DisableInvulnerability();
					self.lives = 0;
					self DoDamage(self.health + 1000, self.origin);
					self.bleedout_time = 0;
				}
			}
		}
		wait(get_player_out_of_playable_area_monitor_wait_time());
	}
}

/*
	Name: get_player_too_many_weapons_monitor_wait_time
	Namespace: zm
	Checksum: 0xE6985129
	Offset: 0x96F0
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function get_player_too_many_weapons_monitor_wait_time()
{
	return 3;
}

/*
	Name: player_too_many_weapons_monitor_takeaway_simultaneous
	Namespace: zm
	Checksum: 0x92D6EB5B
	Offset: 0x9700
	Size: 0x125
	Parameters: 1
	Flags: None
*/
function player_too_many_weapons_monitor_takeaway_simultaneous(primary_weapons_to_take)
{
	self endon("player_too_many_weapons_monitor_takeaway_sequence_done");
	self util::waittill_any("player_downed", "replace_weapon_powerup");
	for(i = 0; i < primary_weapons_to_take.size; i++)
	{
		self TakeWeapon(primary_weapons_to_take[i]);
	}
	self zm_score::player_reduce_points("take_all");
	self zm_utility::give_start_weapon(0);
	if(!self laststand::player_is_in_laststand())
	{
		self zm_utility::decrement_is_drinking();
	}
	else if(level flag::get("solo_game"))
	{
		self.score_lost_when_downed = 0;
	}
	self notify("player_too_many_weapons_monitor_takeaway_sequence_done");
}

/*
	Name: player_too_many_weapons_monitor_takeaway_sequence
	Namespace: zm
	Checksum: 0x6C7A6B48
	Offset: 0x9830
	Size: 0x1C1
	Parameters: 1
	Flags: None
*/
function player_too_many_weapons_monitor_takeaway_sequence(primary_weapons_to_take)
{
	self thread player_too_many_weapons_monitor_takeaway_simultaneous(primary_weapons_to_take);
	self endon("player_downed");
	self endon("replace_weapon_powerup");
	self zm_utility::increment_is_drinking();
	score_decrement = zm_utility::round_up_to_ten(Int(self.score / primary_weapons_to_take.size + 1));
	for(i = 0; i < primary_weapons_to_take.size; i++)
	{
		self playlocalsound(level.zmb_laugh_alias);
		self SwitchToWeapon(primary_weapons_to_take[i]);
		self zm_score::player_reduce_points("take_specified", score_decrement);
		wait(3);
		self TakeWeapon(primary_weapons_to_take[i]);
	}
	self playlocalsound(level.zmb_laugh_alias);
	self zm_score::player_reduce_points("take_all");
	wait(1);
	self zm_utility::give_start_weapon(1);
	self zm_utility::decrement_is_drinking();
	self notify("player_too_many_weapons_monitor_takeaway_sequence_done");
}

/*
	Name: player_too_many_weapons_monitor
	Namespace: zm
	Checksum: 0x54AEC34E
	Offset: 0x9A00
	Size: 0x307
	Parameters: 0
	Flags: None
*/
function player_too_many_weapons_monitor()
{
	self notify("stop_player_too_many_weapons_monitor");
	self endon("stop_player_too_many_weapons_monitor");
	self endon("disconnect");
	level endon("end_game");
	scalar = self.characterindex;
	if(!isdefined(scalar))
	{
		scalar = self GetEntityNumber();
	}
	wait(0.15 * scalar);
	while(1)
	{
		if(self zm_utility::has_powerup_weapon() || self laststand::player_is_in_laststand() || self.sessionstate == "spectator" || isdefined(self.laststandpistol))
		{
			wait(get_player_too_many_weapons_monitor_wait_time());
			continue;
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				wait(get_player_too_many_weapons_monitor_wait_time());
				continue;
			}
		#/
		weapon_limit = zm_utility::get_player_weapon_limit(self);
		primaryWeapons = self GetWeaponsListPrimaries();
		if(primaryWeapons.size > weapon_limit)
		{
			self zm_weapons::take_fallback_weapon();
			primaryWeapons = self GetWeaponsListPrimaries();
		}
		primary_weapons_to_take = [];
		for(i = 0; i < primaryWeapons.size; i++)
		{
			if(zm_weapons::is_weapon_included(primaryWeapons[i]) || zm_weapons::is_weapon_upgraded(primaryWeapons[i]))
			{
				primary_weapons_to_take[primary_weapons_to_take.size] = primaryWeapons[i];
			}
		}
		if(primary_weapons_to_take.size > weapon_limit)
		{
			if(!isdefined(level.player_too_many_weapons_monitor_callback) || self [[level.player_too_many_weapons_monitor_callback]](primary_weapons_to_take))
			{
				self zm_stats::increment_map_cheat_stat("cheat_too_many_weapons");
				self zm_stats::increment_client_stat("cheat_too_many_weapons", 0);
				self zm_stats::increment_client_stat("cheat_total", 0);
				self thread player_too_many_weapons_monitor_takeaway_sequence(primary_weapons_to_take);
				self waittill("player_too_many_weapons_monitor_takeaway_sequence_done");
			}
		}
		wait(get_player_too_many_weapons_monitor_wait_time());
	}
}

/*
	Name: player_monitor_travel_dist
	Namespace: zm
	Checksum: 0xE6D65D37
	Offset: 0x9D10
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function player_monitor_travel_dist()
{
	self endon("disconnect");
	self notify("stop_player_monitor_travel_dist");
	self endon("stop_player_monitor_travel_dist");
	prevpos = self.origin;
	while(1)
	{
		wait(0.1);
		self.pers["distance_traveled"] = self.pers["distance_traveled"] + Distance(self.origin, prevpos);
		prevpos = self.origin;
	}
}

/*
	Name: player_monitor_time_played
	Namespace: zm
	Checksum: 0x1468B84D
	Offset: 0x9DB8
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function player_monitor_time_played()
{
	self endon("disconnect");
	self notify("stop_player_monitor_time_played");
	self endon("stop_player_monitor_time_played");
	level flag::wait_till("start_zombie_round_logic");
	for(;;)
	{
		wait(1);
		zm_stats::increment_client_stat("time_played_total");
	}
}

/*
	Name: player_grenade_multiattack_bookmark_watcher
	Namespace: zm
	Checksum: 0xCDFBF565
	Offset: 0x9E28
	Size: 0x2BB
	Parameters: 1
	Flags: None
*/
function player_grenade_multiattack_bookmark_watcher(grenade)
{
	self endon("disconnect");
	waittillframeend;
	if(!isdefined(grenade))
	{
		return;
	}
	inflictorEntNum = grenade GetEntityNumber();
	inflictorEntType = grenade getEntityType();
	inflictorBirthTime = 0;
	if(isdefined(grenade.birthtime))
	{
		inflictorBirthTime = grenade.birthtime;
	}
	ret_val = grenade util::waittill_any_ex(15, "explode", "death", self, "disconnect");
	if(!isdefined(self) || (isdefined(ret_val) && "timeout" == ret_val))
	{
		return;
	}
	self.grenade_multiattack_count = 0;
	self.grenade_multiattack_ent = undefined;
	self.grenade_multikill_count = 0;
	waittillframeend;
	if(!isdefined(self))
	{
		return;
	}
	count = level.grenade_multiattack_bookmark_count;
	if(isdefined(grenade.grenade_multiattack_bookmark_count) && grenade.grenade_multiattack_bookmark_count)
	{
		count = grenade.grenade_multiattack_bookmark_count;
	}
	bookmark_string = "zm_player_grenade_multiattack";
	if(isdefined(grenade.use_grenade_special_long_bookmark) && grenade.use_grenade_special_long_bookmark)
	{
		bookmark_string = "zm_player_grenade_special_long";
	}
	else if(isdefined(grenade.use_grenade_special_bookmark) && grenade.use_grenade_special_bookmark)
	{
		bookmark_string = "zm_player_grenade_special";
	}
	if(count <= self.grenade_multiattack_count && isdefined(self.grenade_multiattack_ent))
	{
		addDemoBookmark(bookmark_string, GetTime(), self GetEntityNumber(), 255, 0, inflictorEntNum, inflictorEntType, inflictorBirthTime, 0, self.grenade_multiattack_ent GetEntityNumber());
	}
	if(5 <= self.grenade_multikill_count)
	{
		self zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_EXPLOSION_MULTIKILL");
	}
	self.grenade_multiattack_count = 0;
	self.grenade_multikill_count = 0;
}

/*
	Name: player_grenade_watcher
	Namespace: zm
	Checksum: 0xF481EC5A
	Offset: 0xA0F0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function player_grenade_watcher()
{
	self endon("disconnect");
	self notify("stop_player_grenade_watcher");
	self endon("stop_player_grenade_watcher");
	self.grenade_multiattack_count = 0;
	self.grenade_multikill_count = 0;
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(isdefined(grenade) && isalive(grenade))
		{
			grenade.team = self.team;
		}
		self thread player_grenade_multiattack_bookmark_watcher(grenade);
		if(isdefined(level.grenade_watcher))
		{
			self [[level.grenade_watcher]](grenade, weapon);
		}
	}
}

/*
	Name: player_prevent_damage
	Namespace: zm
	Checksum: 0xA75B1D8A
	Offset: 0xA1E0
	Size: 0xEF
	Parameters: 10
	Flags: None
*/
function player_prevent_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(!isdefined(eInflictor) || !isdefined(eAttacker))
	{
		return 0;
	}
	if(eInflictor == self || eAttacker == self)
	{
		return 0;
	}
	if(isdefined(eInflictor) && isdefined(eInflictor.team))
	{
		if(!(isdefined(eInflictor.damage_own_team) && eInflictor.damage_own_team))
		{
			if(eInflictor.team == self.team)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: player_revive_monitor
	Namespace: zm
	Checksum: 0x78338077
	Offset: 0xA2D8
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function player_revive_monitor()
{
	self endon("disconnect");
	self notify("stop_player_revive_monitor");
	self endon("stop_player_revive_monitor");
	while(1)
	{
		self waittill("player_revived", reviver);
		self playsoundtoplayer("zmb_character_revived", self);
		if(isdefined(level.isresetting_grief) && level.isresetting_grief)
		{
			continue;
		}
		if(isdefined(reviver))
		{
			if(reviver != self)
			{
				if(math::cointoss())
				{
					self zm_audio::create_and_play_dialog("general", "revive_up");
				}
				else
				{
					reviver zm_audio::create_and_play_dialog("general", "revive_support");
				}
			}
			else
			{
				self zm_audio::create_and_play_dialog("general", "revive_up");
			}
			points = self.score_lost_when_downed;
			if(!isdefined(points))
			{
				points = 0;
			}
			/#
				println("Dev Block strings are not supported" + points);
			#/
			reviver zm_score::player_add_points("reviver", points);
			self.score_lost_when_downed = 0;
			if(isPlayer(reviver) && reviver != self)
			{
				reviver zm_stats::increment_challenge_stat("SURVIVALIST_REVIVE");
			}
		}
	}
}

/*
	Name: laststand_giveback_player_perks
	Namespace: zm
	Checksum: 0xAC9655E9
	Offset: 0xA4B0
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function laststand_giveback_player_perks()
{
	if(isdefined(self.laststand_perks))
	{
		lost_perk_index = Int(-1);
		if(self.laststand_perks.size > 1)
		{
			lost_perk_index = RandomInt(self.laststand_perks.size - 1);
		}
		for(i = 0; i < self.laststand_perks.size; i++)
		{
			if(self hasPerk(self.laststand_perks[i]))
			{
				continue;
			}
			if(i == lost_perk_index)
			{
				continue;
			}
			zm_perks::give_perk(self.laststand_perks[i]);
		}
	}
}

/*
	Name: remote_revive_watch
	Namespace: zm
	Checksum: 0x6CCB5985
	Offset: 0xA5A8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function remote_revive_watch()
{
	self endon("death");
	self endon("player_revived");
	keep_checking = 1;
	while(keep_checking)
	{
		self waittill("remote_revive", reviver);
		if(reviver.team == self.team)
		{
			keep_checking = 0;
		}
	}
	self zm_laststand::remote_revive(reviver);
}

/*
	Name: player_laststand
	Namespace: zm
	Checksum: 0x3149C58F
	Offset: 0xA640
	Size: 0x3B3
	Parameters: 9
	Flags: None
*/
function player_laststand(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	/#
		println("Dev Block strings are not supported");
	#/
	b_alt_visionset = 0;
	self AllowJump(0);
	currWeapon = self GetCurrentWeapon();
	self addweaponstat(currWeapon, "deathsDuringUse", 1);
	if(isdefined(self.pers_upgrades_awarded["perk_lose"]) && self.pers_upgrades_awarded["perk_lose"])
	{
		self zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}
	players = GetPlayers();
	if(players.size == 1 && level flag::get("solo_game"))
	{
		if(self.lives > 0 && self hasPerk("specialty_quickrevive"))
		{
			self thread wait_and_revive();
		}
	}
	self zm_utility::clear_is_drinking();
	self thread remote_revive_watch();
	self zm_score::player_downed_penalty();
	self disableOffhandWeapons();
	self thread last_stand_grenade_save_and_return();
	if(sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_FALLING")
	{
		if(!(isdefined(self.intermission) && self.intermission))
		{
			self zm_audio::create_and_play_dialog("general", "revive_down");
		}
		else if(isdefined(level.custom_player_death_vo_func) && !self [[level.custom_player_death_vo_func]]())
		{
			self zm_audio::create_and_play_dialog("general", "exert_death");
		}
	}
	if(isdefined(level._zombie_minigun_powerup_last_stand_func))
	{
		self thread [[level._zombie_minigun_powerup_last_stand_func]]();
	}
	if(isdefined(level._zombie_tesla_powerup_last_stand_func))
	{
		self thread [[level._zombie_tesla_powerup_last_stand_func]]();
	}
	if(self hasPerk("specialty_electriccherry"))
	{
		b_alt_visionset = 1;
		if(isdefined(level.custom_laststand_func))
		{
			self thread [[level.custom_laststand_func]]();
		}
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		wait(0.5);
		self stopsounds();
		level waittill("forever");
	}
	if(!b_alt_visionset)
	{
		visionset_mgr::activate("visionset", "zombie_last_stand", self, 1);
	}
}

/*
	Name: failsafe_revive_give_back_weapons
	Namespace: zm
	Checksum: 0x45E47E8
	Offset: 0xAA00
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function failsafe_revive_give_back_weapons(excluded_player)
{
	for(i = 0; i < 10; i++)
	{
		wait(0.05);
		players = GetPlayers();
		foreach(player in players)
		{
			if(player == excluded_player || !isdefined(player.reviveProgressBar) || player zm_laststand::is_reviving_any())
			{
				continue;
			}
			/#
				IPrintLnBold("Dev Block strings are not supported");
			#/
			player zm_laststand::revive_give_back_weapons(level.weaponNone);
			if(isdefined(player.reviveProgressBar))
			{
				player.reviveProgressBar hud::destroyElem();
			}
			if(isdefined(player.reviveTextHud))
			{
				player.reviveTextHud destroy();
			}
		}
	}
}

/*
	Name: set_intermission_point
	Namespace: zm
	Checksum: 0x73411F63
	Offset: 0xABB0
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function set_intermission_point()
{
	points = struct::get_array("intermission", "targetname");
	if(points.size < 1)
	{
		return;
	}
	points = Array::randomize(points);
	point = points[0];
	setDemoIntermissionPoint(point.origin, point.angles);
}

/*
	Name: spawnSpectator
	Namespace: zm
	Checksum: 0xF72B4289
	Offset: 0xAC60
	Size: 0x251
	Parameters: 0
	Flags: None
*/
function spawnSpectator()
{
	self endon("disconnect");
	self endon("spawned_spectator");
	self notify("spawned");
	self notify("end_respawn");
	if(level.intermission)
	{
		return;
	}
	if(isdefined(level.no_spectator) && level.no_spectator)
	{
		wait(3);
		exitLevel();
	}
	self.is_zombie = 1;
	level thread failsafe_revive_give_back_weapons(self);
	self notify("zombified");
	if(isdefined(self.reviveTrigger))
	{
		self.reviveTrigger delete();
		self.reviveTrigger = undefined;
	}
	self.zombification_time = GetTime();
	resetTimeout();
	self StopShellshock();
	self StopRumble("damage_heavy");
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.maxhealth = self.health;
	self.shellshocked = 0;
	self.inWater = 0;
	self.friendlydamage = undefined;
	self.hasSpawned = 1;
	self.spawntime = GetTime();
	self.afk = 0;
	/#
		println("Dev Block strings are not supported");
	#/
	self DetachAll();
	if(isdefined(level.custom_spectate_permissions))
	{
		self [[level.custom_spectate_permissions]]();
	}
	else
	{
		self setSpectatePermissions(1);
	}
	self thread spectator_thread();
	self spawn(self.origin, self.angles);
	self notify("spawned_spectator");
}

/*
	Name: setSpectatePermissions
	Namespace: zm
	Checksum: 0xEA3068A6
	Offset: 0xAEC0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function setSpectatePermissions(isOn)
{
	self allowSpectateTeam("allies", isOn && self.team == "allies");
	self allowSpectateTeam("axis", isOn && self.team == "axis");
	self allowSpectateTeam("freelook", 0);
	self allowSpectateTeam("none", 0);
}

/*
	Name: spectator_thread
	Namespace: zm
	Checksum: 0xD54A0040
	Offset: 0xAF88
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function spectator_thread()
{
	self endon("disconnect");
	self endon("spawned_player");
}

/*
	Name: spectator_toggle_3rd_person
	Namespace: zm
	Checksum: 0xABFC51AF
	Offset: 0xAFB0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function spectator_toggle_3rd_person()
{
	self endon("disconnect");
	self endon("spawned_player");
	third_person = 1;
	self set_third_person(1);
}

/*
	Name: set_third_person
	Namespace: zm
	Checksum: 0x3809971E
	Offset: 0xB000
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function set_third_person(value)
{
	if(value)
	{
		self SetClientThirdPerson(1);
		self SetClientThirdPersonAngle(354);
		self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
	}
	else
	{
		self SetClientThirdPerson(0);
		self SetClientThirdPersonAngle(0);
		self setDepthOfField(0, 0, 512, 4000, 4, 0);
	}
	self resetFov();
}

/*
	Name: last_stand_revive
	Namespace: zm
	Checksum: 0x601DE0BF
	Offset: 0xB0F0
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
function last_stand_revive()
{
	level endon("between_round_over");
	players = GetPlayers();
	laststand_count = 0;
	foreach(player in players)
	{
		if(!zm_utility::is_player_valid(player))
		{
			laststand_count++;
		}
	}
	if(laststand_count == players.size)
	{
		for(i = 0; i < players.size; i++)
		{
			if(players[i] laststand::player_is_in_laststand() && players[i].reviveTrigger.beingRevived == 0)
			{
				players[i] zm_laststand::auto_revive(players[i]);
			}
		}
	}
}

/*
	Name: last_stand_pistol_rank_init
	Namespace: zm
	Checksum: 0xB5378950
	Offset: 0xB268
	Size: 0x1F5
	Parameters: 0
	Flags: None
*/
function last_stand_pistol_rank_init()
{
	level.pistol_values = [];
	level.pistol_values[level.pistol_values.size] = level.default_laststandpistol;
	level.pistol_values[level.pistol_values.size] = GetWeapon("pistol_burst");
	level.pistol_values[level.pistol_values.size] = GetWeapon("pistol_fullauto");
	level.pistol_value_solo_replace_below = level.pistol_values.size - 1;
	level.pistol_values[level.pistol_values.size] = level.default_solo_laststandpistol;
	level.pistol_values[level.pistol_values.size] = GetWeapon("pistol_burst_upgraded");
	level.pistol_values[level.pistol_values.size] = GetWeapon("pistol_fullauto_upgraded");
	level.pistol_values[level.pistol_values.size] = GetWeapon("ray_gun");
	level.pistol_values[level.pistol_values.size] = GetWeapon("raygun_mark2");
	level.pistol_values[level.pistol_values.size] = GetWeapon("ray_gun_upgraded");
	level.pistol_values[level.pistol_values.size] = GetWeapon("raygun_mark2_upgraded");
	level.pistol_values[level.pistol_values.size] = GetWeapon("raygun_mark3");
	level.pistol_values[level.pistol_values.size] = GetWeapon("raygun_mark3_upgraded");
}

/*
	Name: last_stand_pistol_swap
	Namespace: zm
	Checksum: 0x9BC11305
	Offset: 0xB468
	Size: 0x48B
	Parameters: 0
	Flags: None
*/
function last_stand_pistol_swap()
{
	if(self zm_utility::has_powerup_weapon())
	{
		self.lastActiveWeapon = level.weaponNone;
	}
	if(isdefined(self.w_min_last_stand_pistol_override))
	{
		self last_stand_minimum_pistol_override();
	}
	if(!self HasWeapon(self.laststandpistol))
	{
		self GiveWeapon(self.laststandpistol);
	}
	ammoclip = self.laststandpistol.clipSize;
	doubleclip = ammoclip * 2;
	if(isdefined(self._special_solo_pistol_swap) && self._special_solo_pistol_swap || (self.laststandpistol == level.default_solo_laststandpistol && !self.hadpistol))
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = 0;
		self SetWeaponAmmoStock(self.laststandpistol, doubleclip);
	}
	else if(level flag::get("solo_game") && self.laststandpistol == level.default_solo_laststandpistol)
	{
		self SetWeaponAmmoStock(self.laststandpistol, doubleclip);
	}
	else if(self.laststandpistol == level.default_laststandpistol)
	{
		self SetWeaponAmmoStock(self.laststandpistol, doubleclip);
	}
	else if(!isdefined(self.stored_weapon_info) || !isdefined(self.stored_weapon_info[self.laststandpistol]))
	{
		self SetWeaponAmmoStock(self.laststandpistol, doubleclip);
	}
	else if(self.laststandpistol.name == "ray_gun" || self.laststandpistol.name == "ray_gun_upgraded")
	{
		if(self.stored_weapon_info[self.laststandpistol].total_amt >= ammoclip)
		{
			self SetWeaponAmmoClip(self.laststandpistol, ammoclip);
			self.stored_weapon_info[self.laststandpistol].given_amt = ammoclip;
		}
		else
		{
			self SetWeaponAmmoClip(self.laststandpistol, self.stored_weapon_info[self.laststandpistol].total_amt);
			self.stored_weapon_info[self.laststandpistol].given_amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}
		self SetWeaponAmmoStock(self.laststandpistol, 0);
	}
	else if(self.stored_weapon_info[self.laststandpistol].stock_amt >= doubleclip)
	{
		self SetWeaponAmmoStock(self.laststandpistol, doubleclip);
		self.stored_weapon_info[self.laststandpistol].given_amt = doubleclip + self.stored_weapon_info[self.laststandpistol].clip_amt + self.stored_weapon_info[self.laststandpistol].left_clip_amt;
	}
	else
	{
		self SetWeaponAmmoStock(self.laststandpistol, self.stored_weapon_info[self.laststandpistol].stock_amt);
		self.stored_weapon_info[self.laststandpistol].given_amt = self.stored_weapon_info[self.laststandpistol].total_amt;
	}
	self SwitchToWeapon(self.laststandpistol);
}

/*
	Name: last_stand_minimum_pistol_override
	Namespace: zm
	Checksum: 0x32AB2B11
	Offset: 0xB900
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function last_stand_minimum_pistol_override()
{
	for(i = 0; i < level.pistol_values.size; i++)
	{
		if(level.pistol_values[i] == self.w_min_last_stand_pistol_override)
		{
			n_min_last_stand_pistol_value = i;
			break;
		}
	}
	for(K = 0; K < level.pistol_values.size; K++)
	{
		if(level.pistol_values[K] == self.laststandpistol)
		{
			n_default_last_stand_pistol_value = K;
			break;
		}
	}
	if(n_min_last_stand_pistol_value > n_default_last_stand_pistol_value)
	{
		self.hadpistol = 0;
		self.laststandpistol = self.w_min_last_stand_pistol_override;
	}
}

/*
	Name: last_stand_best_pistol
	Namespace: zm
	Checksum: 0xEA431232
	Offset: 0xB9F0
	Size: 0x293
	Parameters: 0
	Flags: None
*/
function last_stand_best_pistol()
{
	pistol_array = [];
	current_weapons = self GetWeaponsListPrimaries();
	for(i = 0; i < current_weapons.size; i++)
	{
		wclass = current_weapons[i].weapClass;
		if(current_weapons[i].isBallisticKnife)
		{
			wclass = "knife";
		}
		if(wclass == "pistol" || wclass == "pistolspread" || wclass == "pistol spread")
		{
			if(current_weapons[i] != level.default_solo_laststandpistol && !level flag::get("solo_game") || (!level flag::get("solo_game") && current_weapons[i] != level.default_solo_laststandpistol))
			{
				if(current_weapons[i] != self.laststandpistol || self.laststandpistol != level.default_laststandpistol)
				{
					if(self getammocount(current_weapons[i]) <= 0)
					{
						break;
					}
				}
			}
			pistol_array_index = pistol_array.size;
			pistol_array[pistol_array_index] = spawnstruct();
			pistol_array[pistol_array_index].weapon = current_weapons[i];
			pistol_array[pistol_array_index].value = 0;
			for(j = 0; j < level.pistol_values.size; j++)
			{
				if(level.pistol_values[j] == current_weapons[i].rootweapon)
				{
					pistol_array[pistol_array_index].value = j;
					break;
				}
			}
		}
	}
	self.laststandpistol = last_stand_compare_pistols(pistol_array);
}

/*
	Name: last_stand_compare_pistols
	Namespace: zm
	Checksum: 0xE7C679B
	Offset: 0xBC90
	Size: 0x223
	Parameters: 1
	Flags: None
*/
function last_stand_compare_pistols(struct_array)
{
	if(!IsArray(struct_array) || struct_array.size <= 0)
	{
		self.hadpistol = 0;
		if(isdefined(self.stored_weapon_info))
		{
			stored_weapon_info = getArrayKeys(self.stored_weapon_info);
			for(j = 0; j < stored_weapon_info.size; j++)
			{
				if(stored_weapon_info[j].rootweapon == level.laststandpistol)
				{
					self.hadpistol = 1;
					return stored_weapon_info[j];
				}
			}
		}
		return level.laststandpistol;
	}
	highest_score_pistol = struct_array[0];
	for(i = 1; i < struct_array.size; i++)
	{
		if(struct_array[i].value > highest_score_pistol.value)
		{
			highest_score_pistol = struct_array[i];
		}
	}
	if(level flag::get("solo_game"))
	{
		self._special_solo_pistol_swap = 0;
		if(highest_score_pistol.value <= level.pistol_value_solo_replace_below)
		{
			self.hadpistol = 0;
			self._special_solo_pistol_swap = 1;
			if(isdefined(level.force_solo_quick_revive) && level.force_solo_quick_revive && !self hasPerk("specialty_quickrevive"))
			{
				return highest_score_pistol.weapon;
			}
			else
			{
				return level.laststandpistol;
			}
		}
		else
		{
			return highest_score_pistol.weapon;
		}
	}
	else
	{
		return highest_score_pistol.weapon;
	}
}

/*
	Name: last_stand_save_pistol_ammo
	Namespace: zm
	Checksum: 0xF27FD251
	Offset: 0xBEC0
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function last_stand_save_pistol_ammo()
{
	weapon_inventory = self GetWeaponsList(1);
	self.stored_weapon_info = [];
	for(i = 0; i < weapon_inventory.size; i++)
	{
		weapon = weapon_inventory[i];
		wclass = weapon.weapClass;
		if(weapon.isBallisticKnife)
		{
			wclass = "knife";
		}
		if(wclass == "pistol" || wclass == "pistolspread" || wclass == "pistol spread")
		{
			self.stored_weapon_info[weapon] = spawnstruct();
			self.stored_weapon_info[weapon].clip_amt = self GetWeaponAmmoClip(weapon);
			self.stored_weapon_info[weapon].left_clip_amt = 0;
			dual_wield_weapon = weapon.dualWieldWeapon;
			if(level.weaponNone != dual_wield_weapon)
			{
				self.stored_weapon_info[weapon].left_clip_amt = self GetWeaponAmmoClip(dual_wield_weapon);
			}
			self.stored_weapon_info[weapon].stock_amt = self GetWeaponAmmoStock(weapon);
			self.stored_weapon_info[weapon].total_amt = self.stored_weapon_info[weapon].clip_amt + self.stored_weapon_info[weapon].left_clip_amt + self.stored_weapon_info[weapon].stock_amt;
			self.stored_weapon_info[weapon].given_amt = 0;
		}
	}
	self last_stand_best_pistol();
}

/*
	Name: last_stand_restore_pistol_ammo
	Namespace: zm
	Checksum: 0x43FDCD2C
	Offset: 0xC138
	Size: 0x3EB
	Parameters: 0
	Flags: None
*/
function last_stand_restore_pistol_ammo()
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = level.weaponNone;
	if(!isdefined(self.stored_weapon_info))
	{
		return;
	}
	weapon_inventory = self GetWeaponsList(1);
	weapon_to_restore = getArrayKeys(self.stored_weapon_info);
	for(i = 0; i < weapon_inventory.size; i++)
	{
		weapon = weapon_inventory[i];
		if(weapon != self.laststandpistol)
		{
			break;
		}
		for(j = 0; j < weapon_to_restore.size; j++)
		{
			if(weapon == weapon_to_restore[j])
			{
				dual_wield_weapon = weapon_to_restore[j].dualWieldWeapon;
				if(weapon != level.default_laststandpistol)
				{
					last_clip = self GetWeaponAmmoClip(weapon);
					last_left_clip = 0;
					if(level.weaponNone != dual_wield_weapon)
					{
						last_left_clip = self GetWeaponAmmoClip(dual_wield_weapon);
					}
					last_stock = self GetWeaponAmmoStock(weapon);
					last_total = last_clip + last_left_clip + last_stock;
					used_amt = self.stored_weapon_info[weapon].given_amt - last_total;
					if(used_amt >= self.stored_weapon_info[weapon].stock_amt)
					{
						used_amt = used_amt - self.stored_weapon_info[weapon].stock_amt;
						self.stored_weapon_info[weapon].stock_amt = 0;
						self.stored_weapon_info[weapon].clip_amt = self.stored_weapon_info[weapon].clip_amt - used_amt;
						if(self.stored_weapon_info[weapon].clip_amt < 0)
						{
							self.stored_weapon_info[weapon].clip_amt = 0;
						}
					}
					else
					{
						new_stock_amt = self.stored_weapon_info[weapon].stock_amt - used_amt;
						if(new_stock_amt < self.stored_weapon_info[weapon].stock_amt)
						{
							self.stored_weapon_info[weapon].stock_amt = new_stock_amt;
						}
					}
				}
				self SetWeaponAmmoClip(weapon, self.stored_weapon_info[weapon].clip_amt);
				if(level.weaponNone != dual_wield_weapon)
				{
					self SetWeaponAmmoClip(dual_wield_weapon, self.stored_weapon_info[weapon].left_clip_amt);
				}
				self SetWeaponAmmoStock(weapon, self.stored_weapon_info[weapon].stock_amt);
				break;
			}
		}
	}
}

/*
	Name: last_stand_take_thrown_grenade
	Namespace: zm
	Checksum: 0x11FE2523
	Offset: 0xC530
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function last_stand_take_thrown_grenade()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("player_revived");
	self waittill("grenade_fire", grenade, weapon);
	if(isdefined(self.lsgsar_lethal) && weapon == self.lsgsar_lethal)
	{
		self.lsgsar_lethal_nade_amt--;
	}
	if(isdefined(self.lsgsar_tactical) && weapon == self.lsgsar_tactical)
	{
		self.lsgsar_tactical_nade_amt--;
	}
}

/*
	Name: last_stand_grenade_save_and_return
	Namespace: zm
	Checksum: 0xB5F5DF54
	Offset: 0xC5D0
	Size: 0x2ED
	Parameters: 0
	Flags: None
*/
function last_stand_grenade_save_and_return()
{
	if(isdefined(level.isresetting_grief) && level.isresetting_grief)
	{
		return;
	}
	self endon("disconnect");
	self endon("bled_out");
	self.lsgsar_lethal_nade_amt = 0;
	self.lsgsar_has_lethal_nade = 0;
	self.lsgsar_tactical_nade_amt = 0;
	self.lsgsar_has_tactical_nade = 0;
	self.lsgsar_lethal = undefined;
	self.lsgsar_tactical = undefined;
	if(self IsThrowingGrenade())
	{
		self thread last_stand_take_thrown_grenade();
	}
	weapon = self zm_utility::get_player_lethal_grenade();
	if(weapon != level.weaponNone)
	{
		self.lsgsar_has_lethal_nade = 1;
		self.lsgsar_lethal = weapon;
		self.lsgsar_lethal_nade_amt = self GetWeaponAmmoClip(weapon);
		self SetWeaponAmmoClip(weapon, 0);
		self TakeWeapon(weapon);
	}
	weapon = self zm_utility::get_player_tactical_grenade();
	if(weapon != level.weaponNone)
	{
		self.lsgsar_has_tactical_nade = 1;
		self.lsgsar_tactical = weapon;
		self.lsgsar_tactical_nade_amt = self GetWeaponAmmoClip(weapon);
		self SetWeaponAmmoClip(weapon, 0);
		self TakeWeapon(weapon);
	}
	self waittill("player_revived");
	if(self.lsgsar_has_lethal_nade)
	{
		self zm_utility::set_player_lethal_grenade(self.lsgsar_lethal);
		self GiveWeapon(self.lsgsar_lethal);
		self SetWeaponAmmoClip(self.lsgsar_lethal, self.lsgsar_lethal_nade_amt);
	}
	if(self.lsgsar_has_tactical_nade)
	{
		self zm_utility::set_player_tactical_grenade(self.lsgsar_tactical);
		self GiveWeapon(self.lsgsar_tactical);
		self SetWeaponAmmoClip(self.lsgsar_tactical, self.lsgsar_tactical_nade_amt);
	}
	self.lsgsar_lethal_nade_amt = undefined;
	self.lsgsar_has_lethal_nade = undefined;
	self.lsgsar_tactical_nade_amt = undefined;
	self.lsgsar_has_tactical_nade = undefined;
	self.lsgsar_lethal = undefined;
	self.lsgsar_tactical = undefined;
}

/*
	Name: spectators_respawn
	Namespace: zm
	Checksum: 0xB96F03A6
	Offset: 0xC8C8
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function spectators_respawn()
{
	level endon("between_round_over");
	if(!isdefined(level.zombie_vars["spectators_respawn"]) || !level.zombie_vars["spectators_respawn"])
	{
		return;
	}
	while(1)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			e_player = players[i];
			e_player spectator_respawn_player();
		}
		wait(1);
	}
}

/*
	Name: spectator_respawn_player
	Namespace: zm
	Checksum: 0xAA556A87
	Offset: 0xC998
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function spectator_respawn_player()
{
	if(self.sessionstate == "spectator" && isdefined(self.spectator_respawn))
	{
		if(!isdefined(level.custom_spawnPlayer))
		{
			level.custom_spawnPlayer = &spectator_respawn;
		}
		self [[level.spawnPlayer]]();
		thread refresh_player_navcard_hud();
		if(isdefined(level.script) && level.round_number > 6 && self.score < 1500)
		{
			self.old_score = self.score;
			if(isdefined(level.spectator_respawn_custom_score))
			{
				self [[level.spectator_respawn_custom_score]]();
			}
			self.score = 1500;
		}
	}
}

/*
	Name: spectator_respawn
	Namespace: zm
	Checksum: 0xF43261B8
	Offset: 0xCA68
	Size: 0x2FF
	Parameters: 0
	Flags: None
*/
function spectator_respawn()
{
	/#
		println("Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(self.spectator_respawn));
	#/
	origin = self.spectator_respawn.origin;
	angles = self.spectator_respawn.angles;
	self setSpectatePermissions(0);
	new_origin = undefined;
	if(isdefined(level.check_valid_spawn_override))
	{
		new_origin = [[level.check_valid_spawn_override]](self);
	}
	if(!isdefined(new_origin))
	{
		new_origin = check_for_valid_spawn_near_team(self, 1);
	}
	if(isdefined(new_origin))
	{
		if(!isdefined(new_origin.angles))
		{
			angles = (0, 0, 0);
		}
		else
		{
			angles = new_origin.angles;
		}
		self spawn(new_origin.origin, angles);
	}
	else
	{
		self spawn(origin, angles);
	}
	if(isdefined(self zm_utility::get_player_placeable_mine()))
	{
		self TakeWeapon(self zm_utility::get_player_placeable_mine());
		self zm_utility::set_player_placeable_mine(level.weaponNone);
	}
	self zm_equipment::take();
	self.is_burning = undefined;
	self.abilities = [];
	self.is_zombie = 0;
	zm_laststand::set_ignoreme(0);
	self clientfield::set("zmbLastStand", 0);
	self RevivePlayer();
	self notify("spawned_player");
	self callback::callback("hash_bc12b61f");
	if(isdefined(level._zombiemode_post_respawn_callback))
	{
		self thread [[level._zombiemode_post_respawn_callback]]();
	}
	self zm_score::player_reduce_points("died");
	self zm_melee_weapon::spectator_respawn_all();
	self thread player_zombie_breadcrumb();
	self thread zm_perks::return_retained_perks();
	return 1;
}

/*
	Name: check_for_valid_spawn_near_team
	Namespace: zm
	Checksum: 0x5BEFF19E
	Offset: 0xCD70
	Size: 0x325
	Parameters: 2
	Flags: None
*/
function check_for_valid_spawn_near_team(revivee, return_struct)
{
	if(isdefined(level.check_for_valid_spawn_near_team_callback))
	{
		spawn_location = [[level.check_for_valid_spawn_near_team_callback]](revivee, return_struct);
		return spawn_location;
	}
	else
	{
		players = GetPlayers();
		spawn_points = zm_gametype::get_player_spawns_for_gametype();
		closest_group = undefined;
		closest_distance = 100000000;
		backup_group = undefined;
		backup_distance = 100000000;
		if(spawn_points.size == 0)
		{
			return undefined;
		}
		a_enabled_zone_entities = zm_zonemgr::get_active_zones_entities();
		for(i = 0; i < players.size; i++)
		{
			if(zm_utility::is_player_valid(players[i], undefined, 1) && players[i] != self)
			{
				for(j = 0; j < spawn_points.size; j++)
				{
					if(isdefined(spawn_points[j].script_int))
					{
						ideal_distance = spawn_points[j].script_int;
					}
					else
					{
						ideal_distance = 1000;
					}
					if(zm_utility::check_point_in_enabled_zone(spawn_points[j].origin, 0, a_enabled_zone_entities) == 0)
					{
						continue;
					}
					if(spawn_points[j].locked == 0)
					{
						plyr_dist = DistanceSquared(players[i].origin, spawn_points[j].origin);
						if(plyr_dist < ideal_distance * ideal_distance)
						{
							if(plyr_dist < closest_distance)
							{
								closest_distance = plyr_dist;
								closest_group = j;
							}
							continue;
						}
						if(plyr_dist < backup_distance)
						{
							backup_group = j;
							backup_distance = plyr_dist;
						}
					}
				}
			}
			else if(!isdefined(closest_group))
			{
				closest_group = backup_group;
			}
			if(isdefined(closest_group))
			{
				spawn_location = get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct);
				if(isdefined(spawn_location))
				{
					return spawn_location;
				}
			}
		}
		return undefined;
	}
}

/*
	Name: get_valid_spawn_location
	Namespace: zm
	Checksum: 0x98E0CE1A
	Offset: 0xD0A0
	Size: 0x285
	Parameters: 4
	Flags: None
*/
function get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct)
{
	spawn_array = struct::get_array(spawn_points[closest_group].target, "targetname");
	spawn_array = Array::randomize(spawn_array);
	for(K = 0; K < spawn_array.size; K++)
	{
		if(isdefined(spawn_array[K].plyr) && spawn_array[K].plyr == revivee GetEntityNumber())
		{
			if(positionWouldTelefrag(spawn_array[K].origin))
			{
				spawn_array[K].plyr = undefined;
				break;
				continue;
			}
			if(isdefined(return_struct) && return_struct)
			{
				return spawn_array[K];
				continue;
			}
			return spawn_array[K].origin;
		}
	}
	for(K = 0; K < spawn_array.size; K++)
	{
		if(positionWouldTelefrag(spawn_array[K].origin))
		{
			continue;
		}
		if(!isdefined(spawn_array[K].plyr) || spawn_array[K].plyr == revivee GetEntityNumber())
		{
			spawn_array[K].plyr = revivee GetEntityNumber();
			if(isdefined(return_struct) && return_struct)
			{
				return spawn_array[K];
				continue;
			}
			return spawn_array[K].origin;
		}
	}
	if(isdefined(return_struct) && return_struct)
	{
		return spawn_array[0];
	}
	return spawn_array[0].origin;
}

/*
	Name: check_for_valid_spawn_near_position
	Namespace: zm
	Checksum: 0x5D1D0130
	Offset: 0xD330
	Size: 0x209
	Parameters: 3
	Flags: None
*/
function check_for_valid_spawn_near_position(revivee, v_position, return_struct)
{
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	if(spawn_points.size == 0)
	{
		return undefined;
	}
	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;
	for(i = 0; i < spawn_points.size; i++)
	{
		if(isdefined(spawn_points[i].script_int))
		{
			ideal_distance = spawn_points[i].script_int;
		}
		else
		{
			ideal_distance = 1000;
		}
		if(spawn_points[i].locked == 0)
		{
			dist = DistanceSquared(v_position, spawn_points[i].origin);
			if(dist < ideal_distance * ideal_distance)
			{
				if(dist < closest_distance)
				{
					closest_distance = dist;
					closest_group = i;
				}
			}
			else if(dist < backup_distance)
			{
				backup_group = i;
				backup_distance = dist;
			}
		}
		if(!isdefined(closest_group))
		{
			closest_group = backup_group;
		}
	}
	if(isdefined(closest_group))
	{
		spawn_location = get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct);
		if(isdefined(spawn_location))
		{
			return spawn_location;
		}
	}
	return undefined;
}

/*
	Name: check_for_valid_spawn_within_range
	Namespace: zm
	Checksum: 0xA7570C86
	Offset: 0xD548
	Size: 0x181
	Parameters: 5
	Flags: None
*/
function check_for_valid_spawn_within_range(revivee, v_position, return_struct, min_distance, max_distance)
{
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	if(spawn_points.size == 0)
	{
		return undefined;
	}
	closest_group = undefined;
	closest_distance = 100000000;
	for(i = 0; i < spawn_points.size; i++)
	{
		if(spawn_points[i].locked == 0)
		{
			dist = Distance(v_position, spawn_points[i].origin);
			if(dist >= min_distance && dist <= max_distance)
			{
				if(dist < closest_distance)
				{
					closest_distance = dist;
					closest_group = i;
				}
			}
		}
	}
	if(isdefined(closest_group))
	{
		spawn_location = get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct);
		if(isdefined(spawn_location))
		{
			return spawn_location;
		}
	}
	return undefined;
}

/*
	Name: get_players_on_team
	Namespace: zm
	Checksum: 0x3D07545A
	Offset: 0xD6D8
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function get_players_on_team(exclude)
{
	teammates = [];
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i].spawn_side == self.spawn_side && !isdefined(players[i].reviveTrigger) && players[i] != exclude)
		{
			teammates[teammates.size] = players[i];
		}
	}
	return teammates;
}

/*
	Name: get_safe_breadcrumb_pos
	Namespace: zm
	Checksum: 0x4F08D70A
	Offset: 0xD7B0
	Size: 0x17F
	Parameters: 1
	Flags: None
*/
function get_safe_breadcrumb_pos(player)
{
	players = GetPlayers();
	valid_players = [];
	min_dist = 22500;
	for(i = 0; i < players.size; i++)
	{
		if(!zm_utility::is_player_valid(players[i]))
		{
			continue;
		}
		valid_players[valid_players.size] = players[i];
	}
	for(i = 0; i < valid_players.size; i++)
	{
		count = 0;
		for(q = 1; q < player.zombie_breadcrumbs.size; q++)
		{
			if(DistanceSquared(player.zombie_breadcrumbs[q], valid_players[i].origin) < min_dist)
			{
				continue;
			}
			count++;
			if(count == valid_players.size)
			{
				return player.zombie_breadcrumbs[q];
			}
		}
	}
	return undefined;
}

/*
	Name: round_spawning
	Namespace: zm
	Checksum: 0xCE206C35
	Offset: 0xD938
	Size: 0x537
	Parameters: 0
	Flags: None
*/
function round_spawning()
{
	level endon("intermission");
	level endon("end_of_round");
	level endon("restart_round");
	/#
		level endon("kill_round");
	#/
	if(level.intermission)
	{
		return;
	}
	if(cheat_enabled(2))
	{
		return;
	}
	if(level.zm_loc_types["zombie_location"].size < 1)
	{
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
		return;
	}
	zombie_utility::ai_calculate_health(level.round_number);
	count = 0;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].zombification_time = 0;
	}
	if(!(isdefined(level.kill_counter_hud) && level.zombie_total > 0))
	{
		level.zombie_total = get_zombie_count_for_round(level.round_number, level.players.size);
		level.zombie_respawns = 0;
		level notify("zombie_total_set");
	}
	if(isdefined(level.zombie_total_set_func))
	{
		level thread [[level.zombie_total_set_func]]();
	}
	if(level.round_number < 10 || level.speed_change_max > 0)
	{
		level thread zombie_utility::zombie_speed_up();
	}
	old_spawn = undefined;
	while(1)
	{
		while(zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0)
		{
			wait(0.1);
		}
		while(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			zombie_utility::clear_all_corpses();
			wait(0.1);
		}
		if(flag::exists("world_is_paused"))
		{
			level flag::wait_till_clear("world_is_paused");
		}
		level flag::wait_till("spawn_zombies");
		while(level.zm_loc_types["zombie_location"].size <= 0)
		{
			wait(0.1);
		}
		run_custom_ai_spawn_checks();
		if(isdefined(level.hostMigrationTimer) && level.hostMigrationTimer)
		{
			util::wait_network_frame();
			continue;
		}
		if(isdefined(level.fn_custom_round_ai_spawn))
		{
			if([[level.fn_custom_round_ai_spawn]]())
			{
				util::wait_network_frame();
				continue;
			}
		}
		if(isdefined(level.zombie_spawners))
		{
			if(isdefined(level.fn_custom_zombie_spawner_selection))
			{
				spawner = [[level.fn_custom_zombie_spawner_selection]]();
			}
			else if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
			{
				if(isdefined(level.spawner_int) && (isdefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size))
				{
					spawner = Array::random(level.zombie_spawn[level.spawner_int]);
				}
				else
				{
					spawner = Array::random(level.zombie_spawners);
				}
			}
			else
			{
				spawner = Array::random(level.zombie_spawners);
			}
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		}
		if(isdefined(ai))
		{
			level.zombie_total--;
			if(level.zombie_respawns > 0)
			{
				level.zombie_respawns--;
			}
			ai thread zombie_utility::round_spawn_failsafe();
			count++;
			if(ai ai::has_behavior_attribute("can_juke"))
			{
				ai ai::set_behavior_attribute("can_juke", 0);
			}
			if(level.zombie_respawns > 0)
			{
				wait(0.1);
			}
			else
			{
				wait(level.zombie_vars["zombie_spawn_delay"]);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: get_zombie_count_for_round
	Namespace: zm
	Checksum: 0x4BD50353
	Offset: 0xDE78
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function get_zombie_count_for_round(n_round, n_player_count)
{
	max = level.zombie_vars["zombie_max_ai"];
	multiplier = n_round / 5;
	if(multiplier < 1)
	{
		multiplier = 1;
	}
	if(n_round >= 10)
	{
		multiplier = multiplier * n_round * 0.15;
	}
	if(n_player_count == 1)
	{
		max = max + Int(0.5 * level.zombie_vars["zombie_ai_per_player"] * multiplier);
	}
	else
	{
		max = max + Int(n_player_count - 1 * level.zombie_vars["zombie_ai_per_player"] * multiplier);
	}
	if(!isdefined(level.max_zombie_func))
	{
		level.max_zombie_func = &zombie_utility::default_max_zombie_func;
	}
	n_zombie_count = [[level.max_zombie_func]](max, n_round);
	return n_zombie_count;
}

/*
	Name: run_custom_ai_spawn_checks
	Namespace: zm
	Checksum: 0x9C562BCB
	Offset: 0xDFE8
	Size: 0x56F
	Parameters: 0
	Flags: None
*/
function run_custom_ai_spawn_checks()
{
	foreach(s in level.custom_ai_spawn_check_funcs)
	{
		if([[s.func_check]]())
		{
			a_spawners = [[s.func_get_spawners]]();
			level.zombie_spawners = ArrayCombine(level.zombie_spawners, a_spawners, 0, 0);
			if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
			{
				foreach(SP in a_spawners)
				{
					if(isdefined(SP.script_int))
					{
						if(!isdefined(level.zombie_spawn[SP.script_int]))
						{
							level.zombie_spawn[SP.script_int] = [];
						}
						if(!IsInArray(level.zombie_spawn[SP.script_int], SP))
						{
							if(!isdefined(level.zombie_spawn[SP.script_int]))
							{
								level.zombie_spawn[SP.script_int] = [];
							}
							else if(!IsArray(level.zombie_spawn[SP.script_int]))
							{
								level.zombie_spawn[SP.script_int] = Array(level.zombie_spawn[SP.script_int]);
							}
							level.zombie_spawn[SP.script_int][level.zombie_spawn[SP.script_int].size] = SP;
						}
					}
				}
			}
			else if(isdefined(s.func_get_locations))
			{
				a_locations = [[s.func_get_locations]]();
				level.zm_loc_types["zombie_location"] = ArrayCombine(level.zm_loc_types["zombie_location"], a_locations, 0, 0);
			}
			break;
		}
		a_spawners = [[s.func_get_spawners]]();
		foreach(SP in a_spawners)
		{
			ArrayRemoveValue(level.zombie_spawners, SP);
		}
		if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
		{
			foreach(SP in a_spawners)
			{
				if(isdefined(SP.script_int) && isdefined(level.zombie_spawn[SP.script_int]))
				{
					ArrayRemoveValue(level.zombie_spawn[SP.script_int], SP);
				}
			}
		}
		else if(isdefined(s.func_get_locations))
		{
			a_locations = [[s.func_get_locations]]();
			foreach(s_loc in a_locations)
			{
				ArrayRemoveValue(level.zm_loc_types["zombie_location"], s_loc);
			}
		}
	}
}

/*
	Name: register_custom_ai_spawn_check
	Namespace: zm
	Checksum: 0x6AA3ADE5
	Offset: 0xE560
	Size: 0xAF
	Parameters: 4
	Flags: None
*/
function register_custom_ai_spawn_check(str_id, func_check, func_get_spawners, func_get_locations)
{
	if(!isdefined(level.custom_ai_spawn_check_funcs[str_id]))
	{
		level.custom_ai_spawn_check_funcs[str_id] = spawnstruct();
	}
	level.custom_ai_spawn_check_funcs[str_id].func_check = func_check;
	level.custom_ai_spawn_check_funcs[str_id].func_get_spawners = func_get_spawners;
	level.custom_ai_spawn_check_funcs[str_id].func_get_locations = func_get_locations;
}

/*
	Name: round_spawning_test
	Namespace: zm
	Checksum: 0x1EDE1BEB
	Offset: 0xE618
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function round_spawning_test()
{
	while(1)
	{
		spawn_point = Array::random(level.zm_loc_types["zombie_location"]);
		spawner = Array::random(level.zombie_spawners);
		ai = zombie_utility::spawn_zombie(spawner, spawner.targetname, spawn_point);
		ai waittill("death");
		wait(5);
	}
}

/*
	Name: round_pause
	Namespace: zm
	Checksum: 0x7C534447
	Offset: 0xE6D0
	Size: 0x203
	Parameters: 1
	Flags: None
*/
function round_pause(delay)
{
	if(!isdefined(delay))
	{
		delay = 30;
	}
	level.countdown_hud = zm_utility::create_counter_hud();
	level.countdown_hud setValue(delay);
	level.countdown_hud.color = (1, 1, 1);
	level.countdown_hud.alpha = 1;
	level.countdown_hud fadeOverTime(2);
	wait(2);
	level.countdown_hud.color = VectorScale((1, 0, 0), 0.21);
	level.countdown_hud fadeOverTime(3);
	wait(3);
	while(delay >= 1)
	{
		wait(1);
		delay--;
		level.countdown_hud setValue(delay);
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] playlocalsound("zmb_perks_packa_ready");
	}
	level.countdown_hud fadeOverTime(1);
	level.countdown_hud.color = (1, 1, 1);
	level.countdown_hud.alpha = 0;
	wait(1);
	level.countdown_hud zm_utility::destroy_hud();
}

/*
	Name: round_start
	Namespace: zm
	Checksum: 0x822A5A22
	Offset: 0xE8E0
	Size: 0x253
	Parameters: 0
	Flags: None
*/
function round_start()
{
	if(!isdefined(level.zombie_spawners) || level.zombie_spawners.size == 0)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		level flag::set("begin_spawning");
		return;
	}
	/#
		println("Dev Block strings are not supported");
	#/
	if(isdefined(level.round_prestart_func))
	{
		[[level.round_prestart_func]]();
	}
	else
	{
		n_delay = 2;
		if(isdefined(level.zombie_round_start_delay))
		{
			n_delay = level.zombie_round_start_delay;
		}
		wait(n_delay);
	}
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	if(GetDvarInt("scr_writeconfigstrings") == 1)
	{
		wait(5);
		exitLevel();
		return;
	}
	if(level.zombie_vars["game_start_delay"] > 0)
	{
		round_pause(level.zombie_vars["game_start_delay"]);
	}
	level flag::set("begin_spawning");
	if(!isdefined(level.round_spawn_func))
	{
		level.round_spawn_func = &round_spawning;
	}
	if(!isdefined(level.move_spawn_func))
	{
		level.move_spawn_func = &zm_utility::move_zombie_spawn_location;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			level.round_spawn_func = &round_spawning_test;
		}
	#/
	if(!isdefined(level.round_wait_func))
	{
		level.round_wait_func = &round_wait;
	}
	if(!isdefined(level.round_think_func))
	{
		level.round_think_func = &round_think;
	}
	level thread [[level.round_think_func]]();
}

/*
	Name: play_door_dialog
	Namespace: zm
	Checksum: 0x9B7B9318
	Offset: 0xEB40
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function play_door_dialog()
{
	self endon("warning_dialog");
	timer = 0;
	while(1)
	{
		wait(0.05);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			dist = DistanceSquared(players[i].origin, self.origin);
			if(dist > 4900)
			{
				timer = 0;
				continue;
			}
			while(dist < 4900 && timer < 3)
			{
				wait(0.5);
				timer++;
			}
			if(dist > 4900 && timer >= 3)
			{
				self playsound("door_deny");
				players[i] zm_audio::create_and_play_dialog("general", "outofmoney");
				wait(3);
				self notify("warning_dialog");
			}
		}
	}
}

/*
	Name: wait_until_first_player
	Namespace: zm
	Checksum: 0x9A4ADCC
	Offset: 0xECC8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function wait_until_first_player()
{
	players = GetPlayers();
	if(!isdefined(players[0]))
	{
		level waittill("first_player_ready");
	}
}

/*
	Name: round_one_up
	Namespace: zm
	Checksum: 0x4F450AE7
	Offset: 0xED10
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function round_one_up()
{
	level endon("end_game");
	if(isdefined(level.noRoundNumber) && level.noRoundNumber == 1)
	{
		return;
	}
	if(!isdefined(level.doground_nomusic))
	{
		level.doground_nomusic = 0;
	}
	if(level.first_round)
	{
		intro = 1;
		if(isdefined(level._custom_intro_vox))
		{
			level thread [[level._custom_intro_vox]]();
		}
		else
		{
			level thread play_level_start_vox_delayed();
		}
	}
	else
	{
		intro = 0;
	}
	if(level.round_number == 5 || level.round_number == 10 || level.round_number == 20 || level.round_number == 35 || level.round_number == 50)
	{
		players = GetPlayers();
		rand = randomIntRange(0, players.size);
		players[rand] thread zm_audio::create_and_play_dialog("general", "round_" + level.round_number);
	}
	if(intro)
	{
		if(isdefined(level.host_ended_game) && level.host_ended_game)
		{
			return;
		}
		wait(6.25);
		level notify("intro_hud_done");
		wait(2);
	}
	else
	{
		wait(2.5);
	}
	ReportMTU(level.round_number);
}

/*
	Name: round_over
	Namespace: zm
	Checksum: 0x37D6300
	Offset: 0xEEF0
	Size: 0x1E1
	Parameters: 0
	Flags: None
*/
function round_over()
{
	if(isdefined(level.noRoundNumber) && level.noRoundNumber == 1)
	{
		return;
	}
	time = [[level.func_get_delay_between_rounds]]();
	players = GetPlayers();
	for(player_index = 0; player_index < players.size; player_index++)
	{
		if(!isdefined(players[player_index].pers["previous_distance_traveled"]))
		{
			players[player_index].pers["previous_distance_traveled"] = 0;
		}
		distanceThisRound = Int(players[player_index].pers["distance_traveled"] - players[player_index].pers["previous_distance_traveled"]);
		players[player_index].pers["previous_distance_traveled"] = players[player_index].pers["distance_traveled"];
		players[player_index] IncrementPlayerStat("distance_traveled", distanceThisRound);
		if(players[player_index].pers["team"] != "spectator")
		{
			players[player_index] recordRoundEndStats();
		}
	}
	RecordZombieRoundEnd();
	wait(time);
}

/*
	Name: get_delay_between_rounds
	Namespace: zm
	Checksum: 0xF601CD1D
	Offset: 0xF0E0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function get_delay_between_rounds()
{
	return level.zombie_vars["zombie_between_round_time"];
}

/*
	Name: recordPlayerRoundWeapon
	Namespace: zm
	Checksum: 0x9EB278ED
	Offset: 0xF100
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function recordPlayerRoundWeapon(weapon, statName)
{
	if(isdefined(weapon))
	{
		weaponIdx = GetBaseWeaponItemIndex(weapon);
		if(isdefined(weaponIdx))
		{
			self IncrementPlayerStat(statName, weaponIdx);
		}
	}
}

/*
	Name: recordPrimaryWeaponsStats
	Namespace: zm
	Checksum: 0xA5E91415
	Offset: 0xF170
	Size: 0x95
	Parameters: 2
	Flags: None
*/
function recordPrimaryWeaponsStats(base_stat_name, max_weapons)
{
	current_weapons = self GetWeaponsListPrimaries();
	for(index = 0; index < max_weapons && index < current_weapons.size; index++)
	{
		recordPlayerRoundWeapon(current_weapons[index], base_stat_name + index);
	}
}

/*
	Name: recordRoundStartStats
	Namespace: zm
	Checksum: 0x4B1662EA
	Offset: 0xF210
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function recordRoundStartStats()
{
	zoneName = self zm_utility::get_current_zone();
	if(isdefined(zoneName))
	{
		self RecordZombieZone("startingZone", zoneName);
	}
	self IncrementPlayerStat("score", self.score);
	primaryWeapon = self GetCurrentWeapon();
	self recordPrimaryWeaponsStats("roundStartPrimaryWeapon", 3);
	self RecordMapEvent(8, GetTime(), self.origin, level.round_number);
}

/*
	Name: recordRoundEndStats
	Namespace: zm
	Checksum: 0xDD888F64
	Offset: 0xF308
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function recordRoundEndStats()
{
	zoneName = self zm_utility::get_current_zone();
	if(isdefined(zoneName))
	{
		self RecordZombieZone("endingZone", zoneName);
	}
	self recordPrimaryWeaponsStats("roundEndPrimaryWeapon", 3);
	self RecordMapEvent(9, GetTime(), self.origin, level.round_number);
}

/*
	Name: round_think
	Namespace: zm
	Checksum: 0xA451A363
	Offset: 0xF3B0
	Size: 0xAD7
	Parameters: 1
	Flags: None
*/
function round_think(restart)
{
	if(!isdefined(restart))
	{
		restart = 0;
	}
	/#
		println("Dev Block strings are not supported");
	#/
	level endon("end_round_think");
	if(!(isdefined(restart) && restart))
	{
		if(isdefined(level.initial_round_wait_func))
		{
			[[level.initial_round_wait_func]]();
		}
		if(!(isdefined(level.host_ended_game) && level.host_ended_game))
		{
			players = GetPlayers();
			foreach(player in players)
			{
				if(!(isdefined(player.hostMigrationControlsFrozen) && player.hostMigrationControlsFrozen))
				{
					player FreezeControls(0);
					/#
						println("Dev Block strings are not supported");
					#/
				}
				player zm_stats::set_global_stat("rounds", level.round_number);
			}
		}
	}
	SetRoundsPlayed(level.round_number);
	for(;;)
	{
		maxreward = 50 * level.round_number;
		if(maxreward > 500)
		{
			maxreward = 500;
		}
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		level.pro_tips_start_time = GetTime();
		level.zombie_last_run_time = GetTime();
		if(isdefined(level.zombie_round_change_custom))
		{
			[[level.zombie_round_change_custom]]();
		}
		else if(!(isdefined(level.sndMusicSpecialRound) && level.sndMusicSpecialRound))
		{
			if(isdefined(level.sndGotoRoundOccurred) && level.sndGotoRoundOccurred)
			{
				level.sndGotoRoundOccurred = 0;
			}
			else if(level.round_number == 1)
			{
				level thread zm_audio::sndMusicSystem_PlayState("round_start_first");
			}
			else if(level.round_number <= 5)
			{
				level thread zm_audio::sndMusicSystem_PlayState("round_start");
			}
			else
			{
				level thread zm_audio::sndMusicSystem_PlayState("round_start_short");
			}
		}
		round_one_up();
		zm_powerups::powerup_round_start();
		players = GetPlayers();
		Array::thread_all(players, &zm_blockers::rebuild_barrier_reward_reset);
		if(!isdefined(level.headshots_only) && level.headshots_only && !restart)
		{
			level thread award_grenades_for_survivors();
		}
		/#
			println("Dev Block strings are not supported" + level.round_number + "Dev Block strings are not supported" + players.size);
		#/
		level.round_start_time = GetTime();
		while(level.zm_loc_types["zombie_location"].size <= 0)
		{
			wait(0.1);
		}
		/#
			zkeys = getArrayKeys(level.zones);
			for(i = 0; i < zkeys.size; i++)
			{
				zoneName = zkeys[i];
				level.zones[zoneName].round_spawn_count = 0;
			}
		#/
		level thread [[level.round_spawn_func]]();
		level notify("start_of_round");
		RecordZombieRoundStart();
		bb::function_2c248b75("start_of_round");
		players = GetPlayers();
		for(index = 0; index < players.size; index++)
		{
			players[index] recordRoundStartStats();
		}
		if(isdefined(level.round_start_custom_func))
		{
			[[level.round_start_custom_func]]();
		}
		[[level.round_wait_func]]();
		level.first_round = 0;
		level notify("end_of_round");
		bb::function_2c248b75("end_of_round");
		UploadStats();
		if(isdefined(level.round_end_custom_logic))
		{
			[[level.round_end_custom_logic]]();
		}
		players = GetPlayers();
		if(isdefined(level.no_end_game_check) && level.no_end_game_check)
		{
			level thread last_stand_revive();
			level thread spectators_respawn();
		}
		else if(1 != players.size)
		{
			level thread spectators_respawn();
		}
		players = GetPlayers();
		Array::thread_all(players, &zm_pers_upgrades_system::round_end);
		if(Int(level.round_number / 5) * 5 == level.round_number)
		{
			level clientfield::set("round_complete_time", Int(level.time - level.n_gameplay_start_time + 500 / 1000));
			level clientfield::set("round_complete_num", level.round_number);
		}
		if(level.gamedifficulty == 0)
		{
			level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
		}
		else
		{
			level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
		}
		set_round_number(1 + get_round_number());
		SetRoundsPlayed(get_round_number());
		level.zombie_vars["zombie_spawn_delay"] = [[level.func_get_zombie_spawn_delay]](get_round_number());
		matchUTCTime = getUTC();
		players = GetPlayers();
		foreach(player in players)
		{
			if(level.curr_gametype_affects_rank && get_round_number() > 3 + level.start_round)
			{
				player zm_stats::add_client_stat("weighted_rounds_played", get_round_number());
			}
			player zm_stats::set_global_stat("rounds", get_round_number());
			player zm_stats::update_playing_utc_time(matchUTCTime);
			player zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 1);
			for(i = 0; i < 4; i++)
			{
				player.number_revives_per_round[i] = 0;
			}
			if(isalive(player) && player.sessionstate != "spectator" && (!isdefined(level.skip_alive_at_round_end_xp) && level.skip_alive_at_round_end_xp))
			{
				player zm_stats::increment_challenge_stat("SURVIVALIST_SURVIVE_ROUNDS");
				score_number = get_round_number() - 1;
				if(score_number < 1)
				{
					score_number = 1;
				}
				else if(score_number > 20)
				{
					score_number = 20;
				}
				scoreevents::processScoreEvent("alive_at_round_end_" + score_number, player);
			}
		}
		if(isdefined(level.check_quickrevive_hotjoin))
		{
			[[level.check_quickrevive_hotjoin]]();
		}
		level.round_number = get_round_number();
		level round_over();
		level notify("between_round_over");
		level.skip_alive_at_round_end_xp = 0;
		restart = 0;
	}
}

/*
	Name: award_grenades_for_survivors
	Namespace: zm
	Checksum: 0x41538396
	Offset: 0xFE90
	Size: 0x1FD
	Parameters: 0
	Flags: None
*/
function award_grenades_for_survivors()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!players[i].is_zombie && (!isdefined(players[i].altbody) && players[i].altbody) && !players[i] laststand::player_is_in_laststand())
		{
			lethal_grenade = players[i] zm_utility::get_player_lethal_grenade();
			if(!players[i] HasWeapon(lethal_grenade))
			{
				players[i] GiveWeapon(lethal_grenade);
				players[i] SetWeaponAmmoClip(lethal_grenade, 0);
			}
			frac = players[i] GetFractionMaxAmmo(lethal_grenade);
			if(frac < 0.25)
			{
				players[i] SetWeaponAmmoClip(lethal_grenade, 2);
				continue;
			}
			if(frac < 0.5)
			{
				players[i] SetWeaponAmmoClip(lethal_grenade, 3);
				continue;
			}
			players[i] SetWeaponAmmoClip(lethal_grenade, 4);
		}
	}
}

/*
	Name: get_zombie_spawn_delay
	Namespace: zm
	Checksum: 0x9609D0B5
	Offset: 0x10098
	Size: 0x115
	Parameters: 1
	Flags: None
*/
function get_zombie_spawn_delay(n_round)
{
	if(n_round > 60)
	{
		n_round = 60;
	}
	n_multiplier = 0.95;
	switch(level.players.size)
	{
		case 1:
		{
			n_delay = 2;
			break;
		}
		case 2:
		{
			n_delay = 1.5;
			break;
		}
		case 3:
		{
			n_delay = 0.89;
			break;
		}
		case 4:
		{
			n_delay = 0.67;
			break;
		}
	}
	for(i = 1; i < n_round; i++)
	{
		n_delay = n_delay * n_multiplier;
		if(n_delay <= 0.1)
		{
			n_delay = 0.1;
			break;
		}
	}
	return n_delay;
}

/*
	Name: round_spawn_failsafe_debug
	Namespace: zm
	Checksum: 0x7530B4AD
	Offset: 0x101B8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function round_spawn_failsafe_debug()
{
	/#
		level notify("failsafe_debug_stop");
		level endon("failsafe_debug_stop");
		start = GetTime();
		level.chunk_time = 0;
		while(1)
		{
			level.failsafe_time = GetTime() - start;
			if(isdefined(self.lastchunk_destroy_time))
			{
				level.chunk_time = GetTime() - self.lastchunk_destroy_time;
			}
			util::wait_network_frame();
		}
	#/
}

/*
	Name: print_zombie_counts
	Namespace: zm
	Checksum: 0x5437EA3
	Offset: 0x10248
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function print_zombie_counts()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				if(!isdefined(level.debug_zombie_count_hud))
				{
					level.debug_zombie_count_hud = NewDebugHudElem();
					level.debug_zombie_count_hud.alignX = "Dev Block strings are not supported";
					level.debug_zombie_count_hud.x = 100;
					level.debug_zombie_count_hud.y = 10;
					level.debug_zombie_count_hud setText("Dev Block strings are not supported");
				}
				currentCount = zombie_utility::get_current_zombie_count();
				number_to_kill = level.zombie_total;
				level.debug_zombie_count_hud setText("Dev Block strings are not supported" + currentCount + "Dev Block strings are not supported" + number_to_kill);
			}
			else if(isdefined(level.debug_zombie_count_hud))
			{
				level.debug_zombie_count_hud destroy();
				level.debug_zombie_count_hud = undefined;
			}
			wait(0.1);
		}
	#/
}

/*
	Name: round_wait
	Namespace: zm
	Checksum: 0x965D5553
	Offset: 0x103B0
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function round_wait()
{
	level endon("restart_round");
	/#
		level endon("kill_round");
	#/
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			level waittill("forever");
		}
	#/
	if(cheat_enabled(2))
	{
		level waittill("forever");
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 0)
		{
			level waittill("forever");
		}
	#/
	wait(1);
	/#
		level thread print_zombie_counts();
		level thread sndMusicOnKillRound();
	#/
	while(1)
	{
		should_wait = zombie_utility::get_current_zombie_count() > 0 || level.zombie_total > 0 || level.intermission;
		if(!should_wait)
		{
			level thread zm_audio::sndMusicSystem_PlayState("round_end");
			return;
		}
		if(level flag::get("end_round_wait"))
		{
			level thread zm_audio::sndMusicSystem_PlayState("round_end");
			return;
		}
		wait(1);
	}
}

/*
	Name: sndMusicOnKillRound
	Namespace: zm
	Checksum: 0x49389CCC
	Offset: 0x10550
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function sndMusicOnKillRound()
{
	level endon("end_of_round");
	level waittill("kill_round");
	level thread zm_audio::sndMusicSystem_PlayState("round_end");
}

/*
	Name: zombify_player
	Namespace: zm
	Checksum: 0x6A0FF7D4
	Offset: 0x10598
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function zombify_player()
{
	self zm_score::player_died_penalty();
	self RecordPlayerDeathZombies();
	if(isdefined(level.deathcard_spawn_func))
	{
		self [[level.deathcard_spawn_func]]();
	}
	if(isdefined(level.func_clone_plant_respawn) && isdefined(self.s_clone_plant))
	{
		self [[level.func_clone_plant_respawn]]();
		return;
	}
	if(!isdefined(level.zombie_vars["zombify_player"]) || !level.zombie_vars["zombify_player"])
	{
		self thread spawnSpectator();
		return;
	}
	self.ignoreme = 1;
	self.is_zombie = 1;
	self.zombification_time = GetTime();
	self.team = level.zombie_team;
	self notify("zombified");
	if(isdefined(self.reviveTrigger))
	{
		self.reviveTrigger delete();
	}
	self.reviveTrigger = undefined;
	self setMoveSpeedScale(0.3);
	self RevivePlayer();
	self TakeAllWeapons();
	self DisableWeaponCycling();
	self disableOffhandWeapons();
	self thread zombie_utility::zombie_eye_glow();
	self thread playerzombie_player_damage();
	self thread playerzombie_soundboard();
}

/*
	Name: playerzombie_player_damage
	Namespace: zm
	Checksum: 0xB09355E9
	Offset: 0x107A0
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function playerzombie_player_damage()
{
	self endon("death");
	self endon("disconnect");
	self thread playerzombie_infinite_health();
	self.zombiehealth = level.zombie_health;
	while(1)
	{
		self waittill("damage", amount, attacker, directionVec, point, type);
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			wait(0.05);
			continue;
		}
		self.zombiehealth = self.zombiehealth - amount;
		if(self.zombiehealth <= 0)
		{
			self thread playerzombie_downed_state();
			self waittill("playerzombie_downed_state_done");
			self.zombiehealth = level.zombie_health;
		}
	}
}

/*
	Name: playerzombie_downed_state
	Namespace: zm
	Checksum: 0xCA827F66
	Offset: 0x108C0
	Size: 0x191
	Parameters: 0
	Flags: None
*/
function playerzombie_downed_state()
{
	self endon("death");
	self endon("disconnect");
	downTime = 15;
	startTime = GetTime();
	endTime = startTime + downTime * 1000;
	self thread playerzombie_downed_hud();
	self.playerzombie_soundboard_disable = 1;
	self thread zombie_utility::zombie_eye_glow_stop();
	self DisableWeapons();
	self AllowStand(0);
	self AllowCrouch(0);
	self AllowProne(1);
	while(GetTime() < endTime)
	{
		wait(0.05);
	}
	self.playerzombie_soundboard_disable = 0;
	self thread zombie_utility::zombie_eye_glow();
	self enableWeapons();
	self AllowStand(1);
	self AllowCrouch(0);
	self AllowProne(0);
	self notify("playerzombie_downed_state_done");
}

/*
	Name: playerzombie_downed_hud
	Namespace: zm
	Checksum: 0x686E2F68
	Offset: 0x10A60
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function playerzombie_downed_hud()
{
	self endon("death");
	self endon("disconnect");
	text = newClientHudElem(self);
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "user_center";
	text.vertAlign = "user_bottom";
	text.foreground = 1;
	text.font = "default";
	text.fontscale = 1.8;
	text.alpha = 0;
	text.color = (1, 1, 1);
	text setText(&"ZOMBIE_PLAYERZOMBIE_DOWNED");
	text.y = -113;
	if(self IsSplitscreen())
	{
		text.y = -137;
	}
	text fadeOverTime(0.1);
	text.alpha = 1;
	self waittill("playerzombie_downed_state_done");
	text fadeOverTime(0.1);
	text.alpha = 0;
}

/*
	Name: playerzombie_infinite_health
	Namespace: zm
	Checksum: 0xB523A44C
	Offset: 0x10C18
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function playerzombie_infinite_health()
{
	self endon("death");
	self endon("disconnect");
	bighealth = 100000;
	while(1)
	{
		if(self.health < bighealth)
		{
			self.health = bighealth;
		}
		wait(0.1);
	}
}

/*
	Name: playerzombie_soundboard
	Namespace: zm
	Checksum: 0x62A9C26E
	Offset: 0x10C80
	Size: 0x293
	Parameters: 0
	Flags: None
*/
function playerzombie_soundboard()
{
	self endon("death");
	self endon("disconnect");
	self.playerzombie_soundboard_disable = 0;
	self.buttonpressed_use = 0;
	self.buttonpressed_attack = 0;
	self.buttonpressed_ads = 0;
	self.useSound_waitTime = 3000;
	self.useSound_nextTime = GetTime();
	useSound = "playerzombie_usebutton_sound";
	self.attackSound_waitTime = 3000;
	self.attackSound_nextTime = GetTime();
	attackSound = "playerzombie_attackbutton_sound";
	self.adsSound_waitTime = 3000;
	self.adsSound_nextTime = GetTime();
	adsSound = "playerzombie_adsbutton_sound";
	self.inputSound_nextTime = GetTime();
	while(1)
	{
		if(self.playerzombie_soundboard_disable)
		{
			wait(0.05);
			continue;
		}
		if(self useButtonPressed())
		{
			if(self can_do_input("use"))
			{
				self thread playerzombie_play_sound(useSound);
				self thread playerzombie_waitfor_buttonrelease("use");
				self.useSound_nextTime = GetTime() + self.useSound_waitTime;
			}
		}
		else if(self AttackButtonPressed())
		{
			if(self can_do_input("attack"))
			{
				self thread playerzombie_play_sound(attackSound);
				self thread playerzombie_waitfor_buttonrelease("attack");
				self.attackSound_nextTime = GetTime() + self.attackSound_waitTime;
			}
		}
		else if(self AdsButtonPressed())
		{
			if(self can_do_input("ads"))
			{
				self thread playerzombie_play_sound(adsSound);
				self thread playerzombie_waitfor_buttonrelease("ads");
				self.adsSound_nextTime = GetTime() + self.adsSound_waitTime;
			}
		}
		wait(0.05);
	}
}

/*
	Name: can_do_input
	Namespace: zm
	Checksum: 0x1FA5B356
	Offset: 0x10F20
	Size: 0x101
	Parameters: 1
	Flags: None
*/
function can_do_input(inputType)
{
	if(GetTime() < self.inputSound_nextTime)
	{
		return 0;
	}
	canDo = 0;
	switch(inputType)
	{
		case "use":
		{
			if(GetTime() >= self.useSound_nextTime && !self.buttonpressed_use)
			{
				canDo = 1;
			}
			break;
		}
		case "attack":
		{
			if(GetTime() >= self.attackSound_nextTime && !self.buttonpressed_attack)
			{
				canDo = 1;
			}
			break;
		}
		case "ads":
		{
			if(GetTime() >= self.useSound_nextTime && !self.buttonpressed_ads)
			{
				canDo = 1;
			}
			break;
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + inputType);
			#/
			break;
		}
	}
	return canDo;
}

/*
	Name: playerzombie_play_sound
	Namespace: zm
	Checksum: 0x77173D61
	Offset: 0x11030
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function playerzombie_play_sound(alias)
{
	self zm_utility::play_sound_on_ent(alias);
}

/*
	Name: playerzombie_waitfor_buttonrelease
	Namespace: zm
	Checksum: 0xF3CD3FD
	Offset: 0x11060
	Size: 0x187
	Parameters: 1
	Flags: None
*/
function playerzombie_waitfor_buttonrelease(inputType)
{
	if(inputType != "use" && inputType != "attack" && inputType != "ads")
	{
		/#
			ASSERTMSG("Dev Block strings are not supported" + inputType + "Dev Block strings are not supported");
		#/
		return;
	}
	notifyString = "waitfor_buttonrelease_" + inputType;
	self notify(notifyString);
	self endon(notifyString);
	if(inputType == "use")
	{
		self.buttonpressed_use = 1;
		while(self useButtonPressed())
		{
			wait(0.05);
		}
		self.buttonpressed_use = 0;
	}
	else if(inputType == "attack")
	{
		self.buttonpressed_attack = 1;
		while(self AttackButtonPressed())
		{
			wait(0.05);
		}
		self.buttonpressed_attack = 0;
	}
	else if(inputType == "ads")
	{
		self.buttonpressed_ads = 1;
		while(self AdsButtonPressed())
		{
			wait(0.05);
		}
		self.buttonpressed_ads = 0;
	}
}

/*
	Name: remove_ignore_attacker
	Namespace: zm
	Checksum: 0x49F7C45B
	Offset: 0x111F0
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function remove_ignore_attacker()
{
	self notify("new_ignore_attacker");
	self endon("new_ignore_attacker");
	self endon("disconnect");
	if(!isdefined(level.ignore_enemy_timer))
	{
		level.ignore_enemy_timer = 0.4;
	}
	wait(level.ignore_enemy_timer);
	self.ignoreAttacker = undefined;
}

/*
	Name: player_damage_override_cheat
	Namespace: zm
	Checksum: 0x94E80145
	Offset: 0x11258
	Size: 0x8D
	Parameters: 10
	Flags: None
*/
function player_damage_override_cheat(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	player_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
	return 0;
}

/*
	Name: player_damage_override
	Namespace: zm
	Checksum: 0xBDA597A5
	Offset: 0x112F0
	Size: 0x10D5
	Parameters: 10
	Flags: None
*/
function player_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	iDamage = self check_player_damage_callbacks(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
	if(self.scene_takedamage === 0)
	{
		return 0;
	}
	if(isdefined(eAttacker) && (isdefined(eAttacker.b_aat_fire_works_weapon) && eAttacker.b_aat_fire_works_weapon))
	{
		return 0;
	}
	if(isdefined(self.use_adjusted_grenade_damage) && self.use_adjusted_grenade_damage)
	{
		self.use_adjusted_grenade_damage = undefined;
		if(self.health > iDamage)
		{
			return iDamage;
		}
	}
	if(!iDamage)
	{
		return 0;
	}
	if(self laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(isdefined(eInflictor))
	{
		if(isdefined(eInflictor.water_damage) && eInflictor.water_damage)
		{
			return 0;
		}
	}
	if(isdefined(eAttacker))
	{
		if(eAttacker.owner === self)
		{
			return 0;
		}
		if(isdefined(self.ignoreAttacker) && self.ignoreAttacker == eAttacker)
		{
			return 0;
		}
		if(isdefined(self.is_zombie) && self.is_zombie && (isdefined(eAttacker.is_zombie) && eAttacker.is_zombie))
		{
			return 0;
		}
		if(isdefined(eAttacker.is_zombie) && eAttacker.is_zombie)
		{
			self.ignoreAttacker = eAttacker;
			self thread remove_ignore_attacker();
			if(isdefined(eAttacker.custom_damage_func))
			{
				iDamage = eAttacker [[eAttacker.custom_damage_func]](self);
			}
		}
		eAttacker notify("hit_player");
		if(isdefined(eAttacker) && isdefined(eAttacker.func_mod_damage_override))
		{
			sMeansOfDeath = eAttacker [[eAttacker.func_mod_damage_override]](eInflictor, sMeansOfDeath, weapon);
		}
		if(sMeansOfDeath != "MOD_FALLING")
		{
			self thread playSwipeSound(sMeansOfDeath, eAttacker);
			if(isdefined(eAttacker.is_zombie) && eAttacker.is_zombie || isPlayer(eAttacker))
			{
				self PlayRumbleOnEntity("damage_heavy");
			}
			if(isdefined(eAttacker.is_zombie) && eAttacker.is_zombie)
			{
				self zm_audio::create_and_play_dialog("general", "attacked");
			}
			canExert = 1;
			if(isdefined(level.pers_upgrade_flopper) && level.pers_upgrade_flopper)
			{
				if(isdefined(self.pers_upgrades_awarded["flopper"]) && self.pers_upgrades_awarded["flopper"])
				{
					canExert = sMeansOfDeath != "MOD_PROJECTILE_SPLASH" && sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_GRENADE_SPLASH";
				}
			}
			if(isdefined(canExert) && canExert)
			{
				if(randomIntRange(0, 1) == 0)
				{
					self thread zm_audio::playerExert("hitmed");
				}
				else
				{
					self thread zm_audio::playerExert("hitlrg");
				}
			}
		}
	}
	if(isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_DROWN")
	{
		self thread zm_audio::playerExert("drowning", 1);
		self.voxDrowning = 1;
	}
	if(isdefined(level.perk_damage_override))
	{
		foreach(func in level.perk_damage_override)
		{
			n_damage = self [[func]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
			if(isdefined(n_damage))
			{
				iDamage = n_damage;
			}
		}
	}
	finalDamage = iDamage;
	if(zm_utility::is_placeable_mine(weapon))
	{
		return 0;
	}
	if(isdefined(self.player_damage_override))
	{
		self thread [[self.player_damage_override]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
	}
	if(isdefined(eInflictor) && isdefined(eInflictor.archetype) && eInflictor.archetype == "zombie_quad")
	{
		if(sMeansOfDeath == "MOD_EXPLOSIVE")
		{
			if(self.health > 75)
			{
				return 75;
			}
		}
	}
	if(sMeansOfDeath == "MOD_SUICIDE" && self bgb::is_enabled("zm_bgb_danger_closest"))
	{
		return 0;
	}
	if(sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE")
	{
		if(self bgb::is_enabled("zm_bgb_danger_closest"))
		{
			return 0;
		}
		if(!(isdefined(self.is_zombie) && self.is_zombie))
		{
			if(!isdefined(eAttacker) || (!isdefined(eAttacker.is_zombie) && eAttacker.is_zombie && (!isdefined(eAttacker.b_override_explosive_damage_cap) && eAttacker.b_override_explosive_damage_cap)))
			{
				if(isdefined(weapon.name) && (weapon.name == "ray_gun" || weapon.name == "ray_gun_upgraded"))
				{
					if(self.health > 25 && iDamage > 25)
					{
						return 25;
					}
				}
				else if(self.health > 75 && iDamage > 75)
				{
					return 75;
				}
			}
		}
	}
	if(iDamage < self.health)
	{
		if(isdefined(eAttacker))
		{
			if(isdefined(level.custom_kill_damaged_VO))
			{
				eAttacker thread [[level.custom_kill_damaged_VO]](self);
			}
			else
			{
				eAttacker.sound_damage_player = self;
			}
			if(isdefined(eAttacker.missingLegs) && eAttacker.missingLegs)
			{
				self zm_audio::create_and_play_dialog("general", "crawl_hit");
			}
		}
		return finalDamage;
	}
	if(isdefined(eAttacker))
	{
		if(isdefined(eAttacker.animName) && eAttacker.animName == "zombie_dog")
		{
			self zm_stats::increment_client_stat("killed_by_zdog");
			self zm_stats::increment_player_stat("killed_by_zdog");
		}
		else if(isdefined(eAttacker.is_avogadro) && eAttacker.is_avogadro)
		{
			self zm_stats::increment_client_stat("killed_by_avogadro", 0);
			self zm_stats::increment_player_stat("killed_by_avogadro");
		}
	}
	self thread clear_path_timers();
	if(level.intermission)
	{
		level waittill("forever");
	}
	if(level.scr_zm_ui_gametype == "zcleansed" && iDamage > 0)
	{
		if(isdefined(eAttacker) && isPlayer(eAttacker) && eAttacker.team != self.team && (!isdefined(self.laststand) && self.laststand && !self laststand::player_is_in_laststand() || !isdefined(self.last_player_attacker)))
		{
			if(isdefined(eAttacker.maxhealth) && (isdefined(eAttacker.is_zombie) && eAttacker.is_zombie))
			{
				eAttacker.health = eAttacker.maxhealth;
			}
			if(isdefined(level.player_kills_player))
			{
				self thread [[level.player_kills_player]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
			}
		}
	}
	if(self.lives > 0 && self hasPerk("specialty_whoswho"))
	{
		self.lives--;
		if(isdefined(level.whoswho_laststand_func))
		{
			self thread [[level.whoswho_laststand_func]]();
			return 0;
		}
	}
	players = GetPlayers();
	count = 0;
	for(i = 0; i < players.size; i++)
	{
		if(players[i] == self || players[i].is_zombie || players[i] laststand::player_is_in_laststand() || players[i].sessionstate == "spectator")
		{
			count++;
		}
	}
	if(count < players.size || (isdefined(level._game_module_game_end_check) && ![[level._game_module_game_end_check]]()))
	{
		if(isdefined(self.lives) && self.lives > 0 && (isdefined(level.force_solo_quick_revive) && level.force_solo_quick_revive) && self hasPerk("specialty_quickrevive"))
		{
			self thread wait_and_revive();
		}
		return finalDamage;
	}
	if(players.size == 1 && level flag::get("solo_game"))
	{
		if(isdefined(level.no_end_game_check) && level.no_end_game_check || (isdefined(level.check_end_solo_game_override) && [[level.check_end_solo_game_override]]()))
		{
			return finalDamage;
		}
		else if(self.lives == 0 || !self hasPerk("specialty_quickrevive"))
		{
			self.intermission = 1;
		}
	}
	solo_death = players.size == 1 && level flag::get("solo_game") && (self.lives == 0 || !self hasPerk("specialty_quickrevive"));
	non_solo_death = count > 1 || (players.size == 1 && !level flag::get("solo_game"));
	if(solo_death || non_solo_death && (!isdefined(level.no_end_game_check) && level.no_end_game_check))
	{
		level notify("stop_suicide_trigger");
		self AllowProne(1);
		self thread zm_laststand::PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
		if(!isdefined(vDir))
		{
			vDir = (1, 0, 0);
		}
		self FakeDamageFrom(vDir);
		level notify("last_player_died");
		if(isdefined(level.custom_player_fake_death))
		{
			self thread [[level.custom_player_fake_death]](vDir, sMeansOfDeath);
		}
		else
		{
			self thread player_fake_death();
		}
	}
	if(count == players.size && (!isdefined(level.no_end_game_check) && level.no_end_game_check))
	{
		if(players.size == 1 && level flag::get("solo_game"))
		{
			if(self.lives == 0 || !self hasPerk("specialty_quickrevive"))
			{
				self.lives = 0;
				level notify("pre_end_game");
				util::wait_network_frame();
				if(level flag::get("dog_round"))
				{
					increment_dog_round_stat("lost");
				}
				level notify("end_game");
			}
			else
			{
				return finalDamage;
			}
		}
		else
		{
			level notify("pre_end_game");
			util::wait_network_frame();
			if(level flag::get("dog_round"))
			{
				increment_dog_round_stat("lost");
			}
			level notify("end_game");
		}
		return 0;
	}
	else
	{
		surface = "flesh";
		return finalDamage;
	}
}

/*
	Name: clear_path_timers
	Namespace: zm
	Checksum: 0x258C679E
	Offset: 0x123D0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function clear_path_timers()
{
	zombies = GetAITeamArray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(isdefined(zombie.favoriteenemy) && zombie.favoriteenemy == self)
		{
			zombie.zombie_path_timer = 0;
		}
	}
}

/*
	Name: check_player_damage_callbacks
	Namespace: zm
	Checksum: 0x5FDBE36C
	Offset: 0x124B0
	Size: 0xF7
	Parameters: 10
	Flags: None
*/
function check_player_damage_callbacks(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(!isdefined(level.player_damage_callbacks))
	{
		return iDamage;
	}
	for(i = 0; i < level.player_damage_callbacks.size; i++)
	{
		newDamage = self [[level.player_damage_callbacks[i]]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
		if(-1 != newDamage)
		{
			return newDamage;
		}
	}
	return iDamage;
}

/*
	Name: register_player_damage_callback
	Namespace: zm
	Checksum: 0x49B15B2A
	Offset: 0x125B0
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_player_damage_callback(func)
{
	if(!isdefined(level.player_damage_callbacks))
	{
		level.player_damage_callbacks = [];
	}
	level.player_damage_callbacks[level.player_damage_callbacks.size] = func;
}

/*
	Name: wait_and_revive
	Namespace: zm
	Checksum: 0xECBEF3A5
	Offset: 0x125F8
	Size: 0x2F3
	Parameters: 0
	Flags: None
*/
function wait_and_revive()
{
	self endon("remote_revive");
	level flag::set("wait_and_revive");
	level.wait_and_revive = 1;
	if(isdefined(self.waiting_to_revive) && self.waiting_to_revive == 1)
	{
		return;
	}
	if(isdefined(self.pers_upgrades_awarded["perk_lose"]) && self.pers_upgrades_awarded["perk_lose"])
	{
		self zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}
	self.waiting_to_revive = 1;
	self.lives--;
	if(isdefined(level.exit_level_func))
	{
		self thread [[level.exit_level_func]]();
	}
	else if(GetPlayers().size == 1)
	{
		player = GetPlayers()[0];
		level.move_away_points = PositionQuery_Source_Navigation(player.origin, 480, 960, 120, 20);
		if(!isdefined(level.move_away_points))
		{
			level.move_away_points = PositionQuery_Source_Navigation(player.last_valid_position, 480, 960, 120, 20);
		}
	}
	solo_revive_time = 10;
	name = level.player_name_directive[self GetEntityNumber()];
	self.revive_hud setText(&"ZOMBIE_REVIVING_SOLO", name);
	self laststand::revive_hud_show_n_fade(solo_revive_time);
	level flag::wait_till_timeout(solo_revive_time, "instant_revive");
	if(level flag::get("instant_revive"))
	{
		self laststand::revive_hud_show_n_fade(1);
	}
	level flag::clear("wait_and_revive");
	level.wait_and_revive = 0;
	self zm_laststand::auto_revive(self);
	self.waiting_to_revive = 0;
	if(isdefined(self.pers_upgrades_awarded["perk_lose"]) && self.pers_upgrades_awarded["perk_lose"])
	{
		self thread zm_pers_upgrades_functions::pers_upgrade_perk_lose_restore();
	}
}

/*
	Name: register_vehicle_damage_callback
	Namespace: zm
	Checksum: 0x59961262
	Offset: 0x128F8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_vehicle_damage_callback(func)
{
	if(!isdefined(level.vehicle_damage_callbacks))
	{
		level.vehicle_damage_callbacks = [];
	}
	level.vehicle_damage_callbacks[level.vehicle_damage_callbacks.size] = func;
}

/*
	Name: vehicle_damage_override
	Namespace: zm
	Checksum: 0xAA951640
	Offset: 0x12940
	Size: 0x15B
	Parameters: 15
	Flags: None
*/
function vehicle_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(isdefined(level.vehicle_damage_callbacks))
	{
		for(i = 0; i < level.vehicle_damage_callbacks.size; i++)
		{
			iDamage = self [[level.vehicle_damage_callbacks[i]]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
		}
	}
	self globallogic_vehicle::Callback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
}

/*
	Name: actor_damage_override
	Namespace: zm
	Checksum: 0x53D7BDB8
	Offset: 0x12AA8
	Size: 0x889
	Parameters: 12
	Flags: None
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(!isdefined(self) || !isdefined(attacker))
	{
		return damage;
	}
	damage = bgb::actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType);
	damage = self check_actor_damage_callbacks(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType);
	self.knuckles_extinguish_flames = weapon.name == "tazer_knuckles";
	if(isdefined(attacker.animName) && attacker.animName == "quad_zombie")
	{
		if(isdefined(self.animName) && self.animName == "quad_zombie")
		{
			return 0;
		}
	}
	if(isdefined(self.killby_interdimensional_gun_hole))
	{
		return damage;
	}
	else if(isdefined(self.interdimensional_gun_kill))
	{
		if(isdefined(self.idgun_damage_cb))
		{
			self [[self.idgun_damage_cb]](inflictor, attacker);
			return 0;
		}
	}
	if(isdefined(weapon))
	{
		if(is_idgun_damage(weapon) && (!isdefined(meansOfDeath) || meansOfDeath != "MOD_EXPLOSIVE"))
		{
			if(!self.archetype === "margwa" && !self.archetype === "mechz")
			{
				self.damageOrigin = vPoint;
				self.allowdeath = 0;
				self.magic_bullet_shield = 1;
				self.interdimensional_gun_kill = 1;
				self.interdimensional_gun_weapon = weapon;
				self.interdimensional_gun_attacker = attacker;
				if(isdefined(inflictor))
				{
					self.interdimensional_gun_inflictor = inflictor;
				}
				else
				{
					self.interdimensional_gun_inflictor = attacker;
				}
			}
			if(isdefined(self.idgun_damage_cb))
			{
				self [[self.idgun_damage_cb]](inflictor, attacker);
			}
			return 0;
		}
	}
	attacker thread zm_audio::sndPlayerHitAlert(self, meansOfDeath, inflictor, weapon);
	if(!isPlayer(attacker) && isdefined(self.non_attacker_func))
	{
		if(isdefined(self.non_attack_func_takes_attacker) && self.non_attack_func_takes_attacker)
		{
			return self [[self.non_attacker_func]](damage, weapon, attacker);
		}
		else
		{
			return self [[self.non_attacker_func]](damage, weapon);
		}
	}
	if(isdefined(attacker) && isai(attacker))
	{
		if(self.team == attacker.team && meansOfDeath == "MOD_MELEE")
		{
			return 0;
		}
	}
	if(attacker.classname == "script_vehicle" && isdefined(attacker.owner))
	{
		attacker = attacker.owner;
	}
	if(!isdefined(damage) || !isdefined(meansOfDeath))
	{
		return damage;
	}
	if(meansOfDeath == "")
	{
		return damage;
	}
	if(isdefined(self.aiOverrideDamage))
	{
		for(index = 0; index < self.aiOverrideDamage.size; index++)
		{
			damageCallback = self.aiOverrideDamage[index];
			damage = self [[damageCallback]](inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, undefined);
		}
		if(damage < 1)
		{
			return 0;
		}
		damage = Int(damage + 0.5);
	}
	old_damage = damage;
	final_damage = damage;
	if(isdefined(self.actor_damage_func))
	{
		final_damage = [[self.actor_damage_func]](inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			println("Dev Block strings are not supported" + final_damage / old_damage + "Dev Block strings are not supported" + old_damage + "Dev Block strings are not supported" + final_damage);
		}
	#/
	if(isdefined(self.in_water) && self.in_water)
	{
		if(Int(final_damage) >= self.health)
		{
			self.water_damage = 1;
		}
	}
	if(isdefined(inflictor) && isdefined(inflictor.archetype) && inflictor.archetype == "glaive")
	{
		if(meansOfDeath == "MOD_CRUSH")
		{
			if(isdefined(inflictor.enemy) && inflictor.enemy != self || (isdefined(inflictor._glaive_must_return_to_owner) && inflictor._glaive_must_return_to_owner))
			{
				if(isdefined(self.archetype) && self.archetype != "margwa")
				{
					final_damage = final_damage + self.health;
					if(IsActor(self))
					{
						self zombie_utility::gib_random_parts();
					}
				}
			}
			else
			{
				return 0;
			}
		}
	}
	if(isdefined(inflictor) && isPlayer(attacker) && attacker == inflictor)
	{
		if(meansOfDeath == "MOD_HEAD_SHOT" || meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_RIFLE_BULLET")
		{
			attacker.hits++;
		}
	}
	if(isdefined(level.headshots_only) && level.headshots_only && isdefined(attacker) && isPlayer(attacker))
	{
		if(meansOfDeath == "MOD_MELEE" && (sHitLoc == "head" || sHitLoc == "helmet"))
		{
			return Int(final_damage);
		}
		if(zm_utility::is_explosive_damage(meansOfDeath))
		{
			return Int(final_damage);
		}
		else if(!zm_utility::is_headshot(weapon, sHitLoc, meansOfDeath))
		{
			return 0;
		}
	}
	return Int(final_damage);
}

/*
	Name: check_actor_damage_callbacks
	Namespace: zm
	Checksum: 0xBEB96848
	Offset: 0x13340
	Size: 0x10F
	Parameters: 12
	Flags: None
*/
function check_actor_damage_callbacks(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(!isdefined(level.actor_damage_callbacks))
	{
		return damage;
	}
	for(i = 0; i < level.actor_damage_callbacks.size; i++)
	{
		newDamage = self [[level.actor_damage_callbacks[i]]](inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType);
		if(-1 != newDamage)
		{
			return newDamage;
		}
	}
	return damage;
}

/*
	Name: register_actor_damage_callback
	Namespace: zm
	Checksum: 0x2BB3C5FF
	Offset: 0x13458
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_actor_damage_callback(func)
{
	if(!isdefined(level.actor_damage_callbacks))
	{
		level.actor_damage_callbacks = [];
	}
	level.actor_damage_callbacks[level.actor_damage_callbacks.size] = func;
}

/*
	Name: actor_damage_override_wrapper
	Namespace: zm
	Checksum: 0x39D54F98
	Offset: 0x134A0
	Size: 0x24B
	Parameters: 15
	Flags: None
*/
function actor_damage_override_wrapper(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal)
{
	damage_override = self actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType);
	willBeKilled = self.health - damage_override <= 0;
	if(isdefined(level.zombie_damage_override_callbacks))
	{
		foreach(func_override in level.zombie_damage_override_callbacks)
		{
			self thread [[func_override]](willBeKilled, inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType);
		}
	}
	bb::function_2aa586aa(attacker, self, weapon, damage_override, meansOfDeath, sHitLoc, willBeKilled, willBeKilled);
	if(!willBeKilled || (!isdefined(self.dont_die_on_me) && self.dont_die_on_me))
	{
		self finishActorDamage(inflictor, attacker, damage_override, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);
	}
}

/*
	Name: register_zombie_damage_override_callback
	Namespace: zm
	Checksum: 0x2B99D855
	Offset: 0x136F8
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function register_zombie_damage_override_callback(func)
{
	if(!isdefined(level.zombie_damage_override_callbacks))
	{
		level.zombie_damage_override_callbacks = [];
	}
	if(!isdefined(level.zombie_damage_override_callbacks))
	{
		level.zombie_damage_override_callbacks = [];
	}
	else if(!IsArray(level.zombie_damage_override_callbacks))
	{
		level.zombie_damage_override_callbacks = Array(level.zombie_damage_override_callbacks);
	}
	level.zombie_damage_override_callbacks[level.zombie_damage_override_callbacks.size] = func;
}

/*
	Name: actor_killed_override
	Namespace: zm
	Checksum: 0x7B472E42
	Offset: 0x13798
	Size: 0x28F
	Parameters: 8
	Flags: None
*/
function actor_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isai(attacker) && isdefined(attacker.script_owner))
	{
		if(attacker.script_owner.team != self.team)
		{
			attacker = attacker.script_owner;
		}
	}
	if(attacker.classname == "script_vehicle" && isdefined(attacker.owner))
	{
		attacker = attacker.owner;
	}
	if(isdefined(attacker) && isPlayer(attacker))
	{
		multiplier = 1;
		if(zm_utility::is_headshot(weapon, sHitLoc, sMeansOfDeath))
		{
			multiplier = 1.5;
		}
		type = undefined;
		if(isdefined(self.animName))
		{
			switch(self.animName)
			{
				case "quad_zombie":
				{
					type = "quadkill";
					break;
				}
				case "ape_zombie":
				{
					type = "apekill";
					break;
				}
				case "zombie":
				{
					type = "zombiekill";
					break;
				}
				case "zombie_dog":
				{
					type = "dogkill";
					break;
				}
			}
		}
	}
	if(isdefined(self.is_ziplining) && self.is_ziplining)
	{
		self.deathAnim = undefined;
	}
	if(isdefined(self.actor_killed_override))
	{
		self [[self.actor_killed_override]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
	}
	if(isdefined(self.deathFunction))
	{
		self [[self.deathFunction]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
	}
}

/*
	Name: round_end_monitor
	Namespace: zm
	Checksum: 0x2A4656C5
	Offset: 0x13A30
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function round_end_monitor()
{
	while(1)
	{
		level waittill("end_of_round");
		demo::bookmark("zm_round_end", GetTime(), undefined, undefined, 1);
		BBPostDemoStreamStatsForRound(level.round_number);
		zm_utility::upload_zm_dash_counters();
		wait(0.05);
	}
}

/*
	Name: updateEndOfMatchCounters
	Namespace: zm
	Checksum: 0x21B849E7
	Offset: 0x13AA8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function updateEndOfMatchCounters()
{
	zm_utility::increment_zm_dash_counter("end_per_game", 1);
	zm_utility::increment_zm_dash_counter("end_per_player", level.players.size);
	if(!(isdefined(level.dash_counter_round_reached_5) && level.dash_counter_round_reached_5))
	{
		zm_utility::increment_zm_dash_counter("end_less_5", 1);
	}
	else if(!(isdefined(level.dash_counter_round_reached_10) && level.dash_counter_round_reached_10))
	{
		zm_utility::increment_zm_dash_counter("end_reached_5_less_10", 1);
	}
	else
	{
		zm_utility::increment_zm_dash_counter("end_reached_10", 1);
	}
	if(!zm_utility::is_solo_ranked_game())
	{
		if(level.dash_counter_start_player_count != level.players.size)
		{
			zm_utility::increment_zm_dash_counter("end_player_count_diff", 1);
		}
	}
}

/*
	Name: end_game
	Namespace: zm
	Checksum: 0x93AA97
	Offset: 0x13BC8
	Size: 0xF99
	Parameters: 0
	Flags: None
*/
function end_game()
{
	level waittill("end_game");
	check_end_game_intermission_delay();
	/#
		println("Dev Block strings are not supported");
	#/
	SetMatchFlag("game_ended", 1);
	level clientfield::set("gameplay_started", 0);
	level clientfield::set("game_end_time", Int(GetTime() - level.n_gameplay_start_time + 500 / 1000));
	util::clientNotify("zesn");
	level thread zm_audio::sndMusicSystem_PlayState("game_over");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set("zmbLastStand", 0);
	}
	for(i = 0; i < players.size; i++)
	{
		if(players[i] laststand::player_is_in_laststand())
		{
			players[i] RecordPlayerDeathZombies();
			players[i] zm_stats::increment_player_stat("deaths");
			players[i] zm_stats::increment_client_stat("deaths");
			players[i] zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
		}
		if(isdefined(players[i].reviveTextHud))
		{
			players[i].reviveTextHud destroy();
		}
	}
	StopAllRumbles();
	level.intermission = 1;
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
	level.zombie_vars["zombie_powerup_double_points_time"] = 0;
	wait(0.1);
	game_over = [];
	survived = [];
	players = GetPlayers();
	SetMatchFlag("disableIngameMenu", 1);
	foreach(player in players)
	{
		player closeInGameMenu();
		player CloseMenu("StartMenu_Main");
	}
	foreach(player in players)
	{
		player SetDStat("AfterActionReportStats", "lobbyPopup", "summary");
	}
	if(!isdefined(level._supress_survived_screen))
	{
		for(i = 0; i < players.size; i++)
		{
			game_over[i] = newClientHudElem(players[i]);
			survived[i] = newClientHudElem(players[i]);
			if(isdefined(level.custom_game_over_hud_elem))
			{
				[[level.custom_game_over_hud_elem]](players[i], game_over[i], survived[i]);
			}
			else
			{
				game_over[i].alignX = "center";
				game_over[i].alignY = "middle";
				game_over[i].horzAlign = "center";
				game_over[i].vertAlign = "middle";
				game_over[i].y = game_over[i].y - 130;
				game_over[i].foreground = 1;
				game_over[i].fontscale = 3;
				game_over[i].alpha = 0;
				game_over[i].color = (1, 1, 1);
				game_over[i].hidewheninmenu = 1;
				game_over[i] setText(&"ZOMBIE_GAME_OVER");
				game_over[i] fadeOverTime(1);
				game_over[i].alpha = 1;
				if(players[i] IsSplitscreen())
				{
					game_over[i].fontscale = 2;
					game_over[i].y = game_over[i].y + 40;
				}
				survived[i].alignX = "center";
				survived[i].alignY = "middle";
				survived[i].horzAlign = "center";
				survived[i].vertAlign = "middle";
				survived[i].y = survived[i].y - 100;
				survived[i].foreground = 1;
				survived[i].fontscale = 2;
				survived[i].alpha = 0;
				survived[i].color = (1, 1, 1);
				survived[i].hidewheninmenu = 1;
				if(players[i] IsSplitscreen())
				{
					survived[i].fontscale = 1.5;
					survived[i].y = survived[i].y + 40;
				}
			}
			if(level.round_number < 2)
			{
				if(level.script == "zm_moon")
				{
					if(!isdefined(level.left_nomans_land))
					{
						nomanslandtime = level.nml_best_time;
						player_survival_time = Int(nomanslandtime / 1000);
						player_survival_time_in_mins = to_mins(player_survival_time);
						survived[i] setText(&"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins);
					}
					else if(level.left_nomans_land == 2)
					{
						survived[i] setText(&"ZOMBIE_SURVIVED_ROUND");
					}
				}
				else
				{
					survived[i] setText(&"ZOMBIE_SURVIVED_ROUND");
				}
			}
			else
			{
				survived[i] setText(&"ZOMBIE_SURVIVED_ROUNDS", level.round_number);
			}
			survived[i] fadeOverTime(1);
			survived[i].alpha = 1;
		}
	}
	else if(isdefined(level.custom_end_screen))
	{
		level [[level.custom_end_screen]]();
	}
	for(i = 0; i < players.size; i++)
	{
		players[i] setClientUIVisibilityFlag("weapon_hud_visible", 0);
		players[i] SetClientMiniScoreboardHide(1);
		players[i] notify("report_bgb_consumption");
		players[i] zm_utility::zm_dash_stats_game_end();
	}
	UploadStats();
	zm_stats::update_players_stats_at_match_end(players);
	zm_stats::update_global_counters_on_match_end();
	bb::function_2c248b75("end_game");
	upload_leaderboards();
	recordGameResult("draw");
	globallogic::recordZMEndGameComScoreEvent("draw");
	globallogic_player::recordActivePlayersEndGameMatchRecordStats();
	updateEndOfMatchCounters();
	if(SessionModeIsOnlineGame())
	{
		level thread zm_utility::upload_zm_dash_counters_end_game();
	}
	finalizeMatchRecord();
	players = GetPlayers();
	foreach(player in players)
	{
		if(isdefined(player.sessionstate) && player.sessionstate == "spectator")
		{
			player.sessionstate = "playing";
			player thread end_game_player_was_spectator();
		}
	}
	wait(0.05);
	/#
		if(!isdefined(level.host_ended_game) && level.host_ended_game && GetDvarInt("Dev Block strings are not supported") > 1)
		{
			LUINotifyEvent(&"Dev Block strings are not supported", 0);
			map_restart(1);
			wait(666);
		}
	#/
	players = GetPlayers();
	LUINotifyEvent(&"force_scoreboard", 1, 1);
	intermission();
	wait(level.zombie_vars["zombie_intermission_time"]);
	if(!isdefined(level._supress_survived_screen))
	{
		for(i = 0; i < players.size; i++)
		{
			survived[i] destroy();
			game_over[i] destroy();
		}
		break;
	}
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].survived_hud))
		{
			players[i].survived_hud destroy();
		}
		if(isdefined(players[i].game_over_hud))
		{
			players[i].game_over_hud destroy();
		}
	}
	level notify("stop_intermission");
	Array::thread_all(GetPlayers(), &player_exit_level);
	wait(1.5);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] CameraActivate(0);
	}
	/#
		if(!isdefined(level.host_ended_game) && level.host_ended_game && GetDvarInt("Dev Block strings are not supported"))
		{
			LUINotifyEvent(&"Dev Block strings are not supported", 1, 0);
			map_restart(1);
			wait(666);
		}
	#/
	exitLevel(0);
	wait(666);
}

/*
	Name: end_game_player_was_spectator
	Namespace: zm
	Checksum: 0xBD8CF547
	Offset: 0x14B70
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function end_game_player_was_spectator()
{
	wait(0.05);
	self ghost();
	self FreezeControls(1);
}

/*
	Name: disable_end_game_intermission
	Namespace: zm
	Checksum: 0xFA97E3FF
	Offset: 0x14BB8
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function disable_end_game_intermission(delay)
{
	level.disable_intermission = 1;
	wait(delay);
	level.disable_intermission = undefined;
}

/*
	Name: check_end_game_intermission_delay
	Namespace: zm
	Checksum: 0x6C396D95
	Offset: 0x14BE8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function check_end_game_intermission_delay()
{
	if(isdefined(level.disable_intermission))
	{
		while(1)
		{
			if(!isdefined(level.disable_intermission))
			{
				break;
			}
			wait(0.01);
		}
	}
}

/*
	Name: upload_leaderboards
	Namespace: zm
	Checksum: 0xBE2284A3
	Offset: 0x14C28
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function upload_leaderboards()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] uploadleaderboards();
	}
}

/*
	Name: initializeStatTracking
	Namespace: zm
	Checksum: 0x5B2D48E
	Offset: 0x14C98
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function initializeStatTracking()
{
	level.global_zombies_killed = 0;
	level.zombies_timeout_spawn = 0;
	level.zombies_timeout_playspace = 0;
	level.zombies_timeout_undamaged = 0;
	level.zombie_player_killed_count = 0;
	level.zombie_trap_killed_count = 0;
	level.zombie_pathing_failed = 0;
	level.zombie_breadcrumb_failed = 0;
}

/*
	Name: uploadGlobalStatCounters
	Namespace: zm
	Checksum: 0xB6C563AC
	Offset: 0x14D08
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function uploadGlobalStatCounters()
{
	incrementCounter("global_zombies_killed", level.global_zombies_killed);
	incrementCounter("global_zombies_killed_by_players", level.zombie_player_killed_count);
	incrementCounter("global_zombies_killed_by_traps", level.zombie_trap_killed_count);
}

/*
	Name: player_fake_death
	Namespace: zm
	Checksum: 0xF46FB374
	Offset: 0x14D78
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function player_fake_death()
{
	level notify("fake_death");
	self notify("fake_death");
	self TakeAllWeapons();
	self AllowStand(0);
	self AllowCrouch(0);
	self AllowProne(1);
	self.ignoreme = 1;
	self EnableInvulnerability();
	wait(1);
	self FreezeControls(1);
}

/*
	Name: player_exit_level
	Namespace: zm
	Checksum: 0x6E971C8A
	Offset: 0x14E40
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function player_exit_level()
{
	self AllowStand(1);
	self AllowCrouch(0);
	self AllowProne(0);
}

/*
	Name: player_killed_override
	Namespace: zm
	Checksum: 0x51304140
	Offset: 0x14E98
	Size: 0x57
	Parameters: 9
	Flags: None
*/
function player_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	level waittill("forever");
}

/*
	Name: player_zombie_breadcrumb
	Namespace: zm
	Checksum: 0x406BA864
	Offset: 0x14EF8
	Size: 0x2CD
	Parameters: 0
	Flags: None
*/
function player_zombie_breadcrumb()
{
	self notify("stop_player_zombie_breadcrumb");
	self endon("stop_player_zombie_breadcrumb");
	self endon("disconnect");
	self endon("spawned_spectator");
	level endon("intermission");
	self.zombie_breadcrumbs = [];
	self.zombie_breadcrumb_distance = 576;
	self.zombie_breadcrumb_area_num = 3;
	self.zombie_breadcrumb_area_distance = 16;
	self store_crumb(self.origin);
	last_crumb = self.origin;
	self thread zm_utility::debug_breadcrumbs();
	while(1)
	{
		wait_time = 0.1;
		if(self.ignoreme)
		{
			wait(wait_time);
			continue;
		}
		store_crumb = 1;
		airborne = 0;
		crumb = self.origin;
		if(!self IsOnGround() && self IsInVehicle())
		{
			trace = bullettrace(self.origin + VectorScale((0, 0, 1), 10), self.origin, 0, undefined);
			crumb = trace["position"];
		}
		if(!airborne && DistanceSquared(crumb, last_crumb) < self.zombie_breadcrumb_distance)
		{
			store_crumb = 0;
		}
		if(airborne && self IsOnGround())
		{
			store_crumb = 1;
			airborne = 0;
		}
		if(isdefined(level.custom_breadcrumb_store_func))
		{
			store_crumb = self [[level.custom_breadcrumb_store_func]](store_crumb);
		}
		if(isdefined(level.custom_airborne_func))
		{
			airborne = self [[level.custom_airborne_func]](airborne);
		}
		if(store_crumb)
		{
			zm_utility::debug_print("Player is storing breadcrumb " + crumb);
			if(isdefined(self.node))
			{
				zm_utility::debug_print("has closest node ");
			}
			last_crumb = crumb;
			self store_crumb(crumb);
		}
		wait(wait_time);
	}
}

/*
	Name: store_crumb
	Namespace: zm
	Checksum: 0x8790F528
	Offset: 0x151D0
	Size: 0x263
	Parameters: 1
	Flags: None
*/
function store_crumb(origin)
{
	offsets = [];
	height_offset = 32;
	index = 0;
	for(j = 1; j <= self.zombie_breadcrumb_area_num; j++)
	{
		offset = j * self.zombie_breadcrumb_area_distance;
		offsets[0] = (origin[0] - offset, origin[1], origin[2]);
		offsets[1] = (origin[0] + offset, origin[1], origin[2]);
		offsets[2] = (origin[0], origin[1] - offset, origin[2]);
		offsets[3] = (origin[0], origin[1] + offset, origin[2]);
		offsets[4] = (origin[0] - offset, origin[1], origin[2] + height_offset);
		offsets[5] = (origin[0] + offset, origin[1], origin[2] + height_offset);
		offsets[6] = (origin[0], origin[1] - offset, origin[2] + height_offset);
		offsets[7] = (origin[0], origin[1] + offset, origin[2] + height_offset);
		for(i = 0; i < offsets.size; i++)
		{
			self.zombie_breadcrumbs[index] = offsets[i];
			index++;
		}
	}
}

/*
	Name: to_mins
	Namespace: zm
	Checksum: 0x9BE29E6F
	Offset: 0x15440
	Size: 0x1BF
	Parameters: 1
	Flags: None
*/
function to_mins(seconds)
{
	hours = 0;
	minutes = 0;
	if(seconds > 59)
	{
		minutes = Int(seconds / 60);
		seconds = Int(seconds * 1000) % 60000;
		seconds = seconds * 0.001;
		if(minutes > 59)
		{
			hours = Int(minutes / 60);
			minutes = Int(minutes * 1000) % 60000;
			minutes = minutes * 0.001;
		}
	}
	if(hours < 10)
	{
		hours = "0" + hours;
	}
	if(minutes < 10)
	{
		minutes = "0" + minutes;
	}
	seconds = Int(seconds);
	if(seconds < 10)
	{
		seconds = "0" + seconds;
	}
	combined = "" + hours + ":" + minutes + ":" + seconds;
	return combined;
}

/*
	Name: intermission
	Namespace: zm
	Checksum: 0x46118BB7
	Offset: 0x15608
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function intermission()
{
	level.intermission = 1;
	level notify("intermission");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] SetClientThirdPerson(0);
		players[i] resetFov();
		players[i].health = 100;
		players[i] thread [[level.custom_intermission]]();
		players[i] stopsounds();
	}
	wait(5.25);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set("zmbLastStand", 0);
	}
	level thread zombie_game_over_death();
}

/*
	Name: zombie_game_over_death
	Namespace: zm
	Checksum: 0x232256FE
	Offset: 0x15788
	Size: 0x1AD
	Parameters: 0
	Flags: None
*/
function zombie_game_over_death()
{
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		if(!isalive(zombies[i]))
		{
			continue;
		}
		zombies[i] SetGoal(zombies[i].origin);
	}
	for(i = 0; i < zombies.size; i++)
	{
		if(!isalive(zombies[i]))
		{
			continue;
		}
		if(isdefined(zombies[i].ignore_game_over_death) && zombies[i].ignore_game_over_death)
		{
			continue;
		}
		wait(0.5 + RandomFloat(2));
		if(isdefined(zombies[i]))
		{
			if(!isVehicle(zombies[i]))
			{
				zombies[i] zombie_utility::zombie_head_gib();
			}
			zombies[i] kill();
		}
	}
}

/*
	Name: screen_fade_in
	Namespace: zm
	Checksum: 0x8C04E608
	Offset: 0x15940
	Size: 0x49
	Parameters: 3
	Flags: None
*/
function screen_fade_in(n_time, v_color, str_menu_id)
{
	LUI::screen_fade(n_time, 0, 1, v_color, 0, str_menu_id);
	wait(n_time);
}

/*
	Name: player_intermission
	Namespace: zm
	Checksum: 0xBA715883
	Offset: 0x15998
	Size: 0x403
	Parameters: 0
	Flags: None
*/
function player_intermission()
{
	self closeInGameMenu();
	self CloseMenu("StartMenu_Main");
	self notify("player_intermission");
	self endon("player_intermission");
	level endon("stop_intermission");
	self endon("disconnect");
	self endon("death");
	self notify("_zombie_game_over");
	self.score = self.score_total;
	points = struct::get_array("intermission", "targetname");
	if(!isdefined(points) || points.size == 0)
	{
		points = GetEntArray("info_intermission", "classname");
		if(points.size < 1)
		{
			/#
				println("Dev Block strings are not supported");
			#/
			return;
		}
	}
	if(isdefined(level.b_show_single_intermission) && level.b_show_single_intermission)
	{
		a_s_temp_points = Array::randomize(points);
		points = [];
		points[0] = Array::random(a_s_temp_points);
	}
	else
	{
		points = Array::randomize(points);
	}
	self zm_utility::create_streamer_hint(points[0].origin, points[0].angles, 0.9);
	wait(5);
	self LUI::screen_fade_out(1);
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.friendlydamage = undefined;
	if(isdefined(level.player_intemission_spawn_callback))
	{
		self thread [[level.player_intemission_spawn_callback]](points[0].origin, points[0].angles);
	}
	while(1)
	{
		for(i = 0; i < points.size; i++)
		{
			point = points[i];
			nextPoint = points[i + 1];
			self SetOrigin(point.origin);
			self SetPlayerAngles(point.angles);
			wait(0.15);
			self notify("player_intermission_spawned");
			if(isdefined(nextPoint))
			{
				self zm_utility::create_streamer_hint(nextPoint.origin, nextPoint.angles, 0.9);
				self screen_fade_in(2);
				wait(3);
				self LUI::screen_fade_out(2);
				continue;
			}
			self screen_fade_in(2);
			if(points.size == 1)
			{
				return;
			}
		}
	}
}

/*
	Name: fade_up_over_time
	Namespace: zm
	Checksum: 0x3B366255
	Offset: 0x15DA8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function fade_up_over_time(t)
{
	self fadeOverTime(t);
	self.alpha = 1;
}

/*
	Name: default_exit_level
	Namespace: zm
	Checksum: 0x49741F0A
	Offset: 0x15DE0
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function default_exit_level()
{
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		if(isdefined(zombies[i].ignore_solo_last_stand) && zombies[i].ignore_solo_last_stand)
		{
			continue;
		}
		if(isdefined(zombies[i].find_exit_point))
		{
			zombies[i] thread [[zombies[i].find_exit_point]]();
			continue;
		}
		if(zombies[i].ignoreme)
		{
			zombies[i] thread default_delayed_exit();
			continue;
		}
		zombies[i] thread default_find_exit_point();
	}
}

/*
	Name: default_delayed_exit
	Namespace: zm
	Checksum: 0x55C4E156
	Offset: 0x15F00
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function default_delayed_exit()
{
	self endon("death");
	while(1)
	{
		if(!level flag::get("wait_and_revive"))
		{
			return;
		}
		if(!self.ignoreme)
		{
			break;
		}
		wait(0.1);
	}
	self thread default_find_exit_point();
}

/*
	Name: default_find_exit_point
	Namespace: zm
	Checksum: 0x5A54AD2D
	Offset: 0x15F78
	Size: 0x2B7
	Parameters: 0
	Flags: None
*/
function default_find_exit_point()
{
	self endon("death");
	player = GetPlayers()[0];
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	away = VectorNormalize(self.origin - player.origin);
	endPos = self.origin + VectorScale(away, 600);
	if(isdefined(level.zm_loc_types["wait_location"]) && level.zm_loc_types["wait_location"].size > 0)
	{
		locs = Array::randomize(level.zm_loc_types["wait_location"]);
	}
	else
	{
		locs = Array::randomize(level.zm_loc_types["dog_location"]);
	}
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
		self SetGoal(locs[dest].origin);
	}
	while(1)
	{
		b_passed_override = 1;
		if(isdefined(level.default_find_exit_position_override))
		{
			b_passed_override = [[level.default_find_exit_position_override]]();
		}
		if(!level flag::get("wait_and_revive") && b_passed_override)
		{
			break;
		}
		wait(0.1);
	}
}

/*
	Name: play_level_start_vox_delayed
	Namespace: zm
	Checksum: 0x52365A02
	Offset: 0x16238
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function play_level_start_vox_delayed()
{
	wait(3);
	players = GetPlayers();
	num = randomIntRange(0, players.size);
	players[num] zm_audio::create_and_play_dialog("general", "intro");
}

/*
	Name: register_sidequest
	Namespace: zm
	Checksum: 0x87E96F92
	Offset: 0x162C0
	Size: 0x125
	Parameters: 2
	Flags: None
*/
function register_sidequest(id, sidequest_stat)
{
	if(!isdefined(level.zombie_sidequest_stat))
	{
		level.zombie_sidequest_previously_completed = [];
		level.zombie_sidequest_stat = [];
	}
	level.zombie_sidequest_stat[id] = sidequest_stat;
	level flag::wait_till("start_zombie_round_logic");
	level.zombie_sidequest_previously_completed[id] = 0;
	if(!level.onlineGame)
	{
		return;
	}
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] zm_stats::get_global_stat(level.zombie_sidequest_stat[id]))
		{
			level.zombie_sidequest_previously_completed[id] = 1;
			return;
		}
	}
}

/*
	Name: is_sidequest_previously_completed
	Namespace: zm
	Checksum: 0x30CC5FC8
	Offset: 0x163F0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function is_sidequest_previously_completed(id)
{
	return isdefined(level.zombie_sidequest_previously_completed[id]) && level.zombie_sidequest_previously_completed[id];
}

/*
	Name: set_sidequest_completed
	Namespace: zm
	Checksum: 0x19156669
	Offset: 0x16428
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function set_sidequest_completed(id)
{
	level notify("zombie_sidequest_completed", id);
	level.zombie_sidequest_previously_completed[id] = 1;
	if(!level.onlineGame)
	{
		return;
	}
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(level.zombie_sidequest_stat[id]))
		{
			players[i] zm_stats::add_global_stat(level.zombie_sidequest_stat[id], 1);
		}
	}
}

/*
	Name: playSwipeSound
	Namespace: zm
	Checksum: 0xF80CCAFA
	Offset: 0x16510
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function playSwipeSound(mod, attacker)
{
	if(isdefined(attacker.is_zombie) && attacker.is_zombie || (isdefined(attacker.archetype) && attacker.archetype == "margwa"))
	{
		self playsoundtoplayer("evt_player_swiped", self);
		return;
	}
}

/*
	Name: precache_zombie_leaderboards
	Namespace: zm
	Checksum: 0xD4AB3FC2
	Offset: 0x165A0
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function precache_zombie_leaderboards()
{
	if(SessionModeIsSystemlink())
	{
		return;
	}
	globalLeaderboards = "LB_ZM_GB_BULLETS_FIRED_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_BULLETS_HIT_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_DISTANCE_TRAVELED_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_DOORS_PURCHASED_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_GRENADE_KILLS_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_HEADSHOTS_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_KILLS_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_PERKS_DRANK_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_REVIVES_AT ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_KILLSTATS_MR ";
	globalLeaderboards = globalLeaderboards + "LB_ZM_GB_GAMESTATS_MR ";
	if(!level.rankedMatch && GetDvarInt("zm_private_rankedmatch", 0) == 0)
	{
		precacheLeaderboards(globalLeaderboards);
		return;
	}
	mapname = GetDvarString("mapname");
	expectedPlayerNum = getnumexpectedplayers();
	mapLeaderboard = "LB_ZM_MAP_" + GetSubStr(mapname, 3, mapname.size) + "_" + expectedPlayerNum + "PLAYER";
	precacheLeaderboards(globalLeaderboards + mapLeaderboard);
}

/*
	Name: zm_on_player_connect
	Namespace: zm
	Checksum: 0x85D9B28B
	Offset: 0x16790
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function zm_on_player_connect()
{
	if(level.passed_introscreen)
	{
		self setClientUIVisibilityFlag("hud_visible", 1);
		self setClientUIVisibilityFlag("weapon_hud_visible", 1);
		zm_utility::increment_zm_dash_counter("hotjoined", 1);
		zm_utility::upload_zm_dash_counters();
	}
	self flag::init("used_consumable");
	self thread zm_utility::zm_dash_stats_game_start();
	self thread zm_utility::zm_dash_stats_wait_for_consumable_use();
	thread refresh_player_navcard_hud();
	self thread watchDisconnect();
	self.hud_damagefeedback = newdamageindicatorhudelem(self);
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = 1;
	self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
	self.hitSoundTracker = 1;
}

/*
	Name: zm_on_player_disconnect
	Namespace: zm
	Checksum: 0x720EE805
	Offset: 0x16960
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function zm_on_player_disconnect()
{
	thread refresh_player_navcard_hud();
	zm_utility::increment_zm_dash_counter("left_midgame", 1);
	zm_utility::upload_zm_dash_counters();
}

/*
	Name: watchDisconnect
	Namespace: zm
	Checksum: 0x4BDF71F8
	Offset: 0x169B0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function watchDisconnect()
{
	self notify("watchDisconnect");
	self endon("watchDisconnect");
	self waittill("disconnect");
	zm_on_player_disconnect();
}

/*
	Name: increment_dog_round_stat
	Namespace: zm
	Checksum: 0xC2DFED38
	Offset: 0x169F8
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function increment_dog_round_stat(stat)
{
	players = GetPlayers();
	foreach(player in players)
	{
		player zm_stats::increment_client_stat("zdog_rounds_" + stat);
	}
}

/*
	Name: setup_player_navcard_hud
	Namespace: zm
	Checksum: 0x671DE82E
	Offset: 0x16AC0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function setup_player_navcard_hud()
{
	level flag::wait_till("start_zombie_round_logic");
	thread refresh_player_navcard_hud();
}

/*
	Name: refresh_player_navcard_hud
	Namespace: zm
	Checksum: 0x3A9F239D
	Offset: 0x16B00
	Size: 0x1D9
	Parameters: 0
	Flags: None
*/
function refresh_player_navcard_hud()
{
	if(!isdefined(level.navcards))
	{
		return;
	}
	players = GetPlayers();
	foreach(player in players)
	{
		navcard_bits = 0;
		for(i = 0; i < level.navcards.size; i++)
		{
			hasit = player zm_stats::get_global_stat(level.navcards[i]);
			if(isdefined(player.navcard_grabbed) && player.navcard_grabbed == level.navcards[i])
			{
				hasit = 1;
			}
			if(hasit)
			{
				navcard_bits = navcard_bits + 1 << i;
			}
		}
		util::wait_network_frame();
		player clientfield::set("navcard_held", 0);
		if(navcard_bits > 0)
		{
			util::wait_network_frame();
			player clientfield::set("navcard_held", navcard_bits);
		}
	}
}

/*
	Name: set_default_laststand_pistol
	Namespace: zm
	Checksum: 0x7926F174
	Offset: 0x16CE8
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function set_default_laststand_pistol(solo_mode)
{
	if(!solo_mode)
	{
		level.laststandpistol = level.default_laststandpistol;
	}
	else
	{
		level.laststandpistol = level.default_solo_laststandpistol;
	}
}

/*
	Name: player_too_many_players_check
	Namespace: zm
	Checksum: 0xD91D5804
	Offset: 0x16D28
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function player_too_many_players_check()
{
	max_players = 4;
	if(level.scr_zm_ui_gametype == "zgrief" || level.scr_zm_ui_gametype == "zmeat")
	{
		max_players = 8;
	}
	if(GetPlayers().size > max_players)
	{
		zm_game_module::freeze_players(1);
		level notify("end_game");
	}
}

/*
	Name: is_idgun_damage
	Namespace: zm
	Checksum: 0x5ED74505
	Offset: 0x16DC0
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function is_idgun_damage(weapon)
{
	if(isdefined(level.idgun_weapons))
	{
		if(IsInArray(level.idgun_weapons, weapon))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: zm_on_player_spawned
	Namespace: zm
	Checksum: 0x23A475E2
	Offset: 0x16E08
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function zm_on_player_spawned()
{
	thread update_zone_name();
	thread update_is_player_valid();
}

/*
	Name: update_is_player_valid
	Namespace: zm
	Checksum: 0xF93EDCCD
	Offset: 0x16E38
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function update_is_player_valid()
{
	self endon("death");
	self endon("disconnnect");
	self.am_i_valid = 1;
	while(isdefined(self))
	{
		self.am_i_valid = zm_utility::is_player_valid(self, 1);
		wait(0.05);
	}
}

/*
	Name: update_zone_name
	Namespace: zm
	Checksum: 0x59D13817
	Offset: 0x16EA0
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function update_zone_name()
{
	self endon("death");
	self endon("disconnnect");
	self.zone_name = zm_utility::get_current_zone();
	if(isdefined(self.zone_name))
	{
		self.previous_zone_name = self.zone_name;
	}
	while(isdefined(self))
	{
		if(isdefined(self.zone_name))
		{
			self.previous_zone_name = self.zone_name;
		}
		self.zone_name = zm_utility::get_current_zone();
		wait(RandomFloatRange(0.5, 1));
	}
}

/*
	Name: printHashIDs
	Namespace: zm
	Checksum: 0xAA3194D6
	Offset: 0x16F58
	Size: 0x493
	Parameters: 0
	Flags: None
*/
function printHashIDs()
{
	/#
		outputString = "Dev Block strings are not supported";
		outputString = outputString + "Dev Block strings are not supported";
		foreach(s_craftable in level.zombie_include_craftables)
		{
			outputString = outputString + "Dev Block strings are not supported" + s_craftable.name + "Dev Block strings are not supported" + s_craftable.hash_id + "Dev Block strings are not supported";
			if(!isdefined(s_craftable.a_piecestubs))
			{
				break;
			}
			foreach(s_piece in s_craftable.a_piecestubs)
			{
				outputString = outputString + s_piece.pieceName + "Dev Block strings are not supported" + s_piece.hash_id + "Dev Block strings are not supported";
			}
		}
		outputString = outputString + "Dev Block strings are not supported";
		foreach(powerup in level.zombie_powerups)
		{
			outputString = outputString + powerup.powerup_name + "Dev Block strings are not supported" + powerup.hash_id + "Dev Block strings are not supported";
		}
		outputString = outputString + "Dev Block strings are not supported";
		if(isdefined(level.aat_in_use) && level.aat_in_use)
		{
			foreach(AAT in level.AAT)
			{
				if(!isdefined(AAT) || !isdefined(AAT.name) || AAT.name == "Dev Block strings are not supported")
				{
					continue;
				}
				outputString = outputString + AAT.name + "Dev Block strings are not supported" + AAT.hash_id + "Dev Block strings are not supported";
			}
		}
		outputString = outputString + "Dev Block strings are not supported";
		foreach(perk in level._custom_perks)
		{
			if(!isdefined(perk) || !isdefined(perk.alias))
			{
				continue;
			}
			outputString = outputString + perk.alias + "Dev Block strings are not supported" + perk.hash_id + "Dev Block strings are not supported";
		}
		outputString = outputString + "Dev Block strings are not supported";
		println(outputString);
	#/
}

