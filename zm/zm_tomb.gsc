#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_ai_mechz_claw;
#using scripts\zm\_zm_ai_quadrotor;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerup_zombie_blood;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_beacon;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\_zm_weap_riotshield_tomb;
#using scripts\zm\_zm_weap_staff_air;
#using scripts\zm\_zm_weap_staff_fire;
#using scripts\zm\_zm_weap_staff_lightning;
#using scripts\zm\_zm_weap_staff_revive;
#using scripts\zm\_zm_weap_staff_water;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_challenges_tomb;
#using scripts\zm\zm_remaster_zombie;
#using scripts\zm\zm_tomb_achievement;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_ambient_scripts;
#using scripts\zm\zm_tomb_capture_zones;
#using scripts\zm\zm_tomb_challenges;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_craftables;
#using scripts\zm\zm_tomb_dig;
#using scripts\zm\zm_tomb_ee_main;
#using scripts\zm\zm_tomb_ee_side;
#using scripts\zm\zm_tomb_ffotd;
#using scripts\zm\zm_tomb_fx;
#using scripts\zm\zm_tomb_giant_robot;
#using scripts\zm\zm_tomb_magicbox;
#using scripts\zm\zm_tomb_main_quest;
#using scripts\zm\zm_tomb_mech;
#using scripts\zm\zm_tomb_quest_fire;
#using scripts\zm\zm_tomb_tank;
#using scripts\zm\zm_tomb_teleporter;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;
#using scripts\zm\zm_tomb_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace zm_tomb;

/*
	Name: opt_in
	Namespace: zm_tomb
	Checksum: 0x2FD4F349
	Offset: 0x2278
	Size: 0x27
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.pack_a_punch_camo_index = 133;
}

/*
	Name: main
	Namespace: zm_tomb
	Checksum: 0x5CF4F1E8
	Offset: 0x22A8
	Size: 0xD73
	Parameters: 0
	Flags: None
*/
function main()
{
	zm_tomb_ffotd::main_start();
	level._no_equipment_activated_clientfield = 1;
	level._no_navcards = 1;
	level._wallbuy_override_num_bits = 1;
	level.player_out_of_playable_area_monitor_callback = &player_out_of_playable_area_override;
	zm_tomb_fx::main();
	level.default_game_mode = "zclassic";
	level.default_start_location = "tomb";
	setup_rex_starts();
	level.FX_exclude_edge_fog = 1;
	level.FX_exclude_tesla_head_light = 1;
	level.fx_exclude_default_explosion = 1;
	level.FX_exclude_footsteps = 1;
	level._uses_sticky_grenades = 1;
	level.disable_fx_zmb_wall_buy_semtex = 1;
	level._uses_taser_knuckles = 0;
	level.disable_fx_upgrade_aquired = 1;
	level.sndZHDAudio = 1;
	zm::init_fx();
	level.zombiemode = 1;
	level._no_water_risers = 1;
	level.riser_fx_on_client = 1;
	level._round_start_func = &zm::round_start;
	level.n_active_ragdolls = 0;
	level.ragdoll_limit_check = &zm_tomb_utility::ragdoll_attempt;
	level._limited_equipment = [];
	level._limited_equipment[level._limited_equipment.size] = GetWeapon("equip_dieseldrone");
	level._limited_equipment[level._limited_equipment.size] = GetWeapon("staff_air");
	level._limited_equipment[level._limited_equipment.size] = GetWeapon("staff_fire");
	level._limited_equipment[level._limited_equipment.size] = GetWeapon("staff_lightning");
	level._limited_equipment[level._limited_equipment.size] = GetWeapon("staff_water");
	level.a_func_vehicle_damage_override = [];
	level.callbackVehicleDamage = &tomb_vehicle_damage_override_wrapper;
	level.level_specific_stats_init = &init_tomb_stats;
	SetDvar("zombiemode_path_minz_bias", 13);
	SetDvar("bg_chargeShotExponentialAmmoPerChargeLevel", 1);
	SetDvar("dlc2_fix_scripted_looping_linked_animations", 1);
	level thread setup_tomb_spawn_groups();
	spawner_main_chamber_capture_zombies = GetEnt("chamber_capture_zombie_spawner", "targetname");
	spawner_main_chamber_capture_zombies spawner::add_spawn_function(&chamber_capture_zombie_spawn_init);
	level.has_richtofen = 0;
	level.giveCustomCharacters = &give_personality_characters;
	level.setupCustomCharacterExerts = &zm_tomb_vo::setup_personality_character_exerts;
	initCharacterStartIndex();
	level thread zm_tomb_vo::init_flags();
	level._zmbVoxLevelSpecific = &zm_tomb_vo::init_level_specific_audio;
	level.custom_player_fake_death = &zm_player_fake_death;
	level.custom_player_fake_death_cleanup = &zm_player_fake_death_cleanup;
	level.custom_player_track_ammo_count = &tomb_custom_player_track_ammo_count;
	level.zombie_init_done = &zombie_init_done;
	level._zombies_round_spawn_failsafe = &tomb_round_spawn_failsafe;
	level.random_pandora_box_start = 1;
	level.custom_electric_cherry_perk_threads = zm_perks::register_perk_threads("specialty_electriccherry", &tomb_custom_electric_cherry_reload_attack, &zm_perk_electric_cherry::electric_cherry_perk_lost);
	level.custom_laststand_func = &tomb_custom_electric_cherry_laststand;
	level.perk_random_vo_func_usemachine = &zm_tomb_vo::wunderfizz_used_vo;
	level._custom_turn_packapunch_on = &zm_tomb_capture_zones::pack_a_punch_dummy_init;
	zm_pap_util::set_interaction_trigger_radius(80);
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level._allow_melee_weapon_switching = 1;
	zm_placeable_mine::add_weapon_to_mine_slot("equip_dieseldrone");
	level.custom_ai_type = [];
	level.raygun2_included = 1;
	include_powerups();
	include_perks_in_random_rotation();
	level thread zm_tomb_ee_main::init();
	level thread zm_tomb_ee_side::init();
	level zm_tomb_achievement::init();
	if(level.Splitscreen && GetDvarInt("splitscreen_playerCount") > 2)
	{
		level.optimise_for_splitscreen = 1;
	}
	else
	{
		level.optimise_for_splitscreen = 0;
	}
	level.var_7c29c50e = &function_56848b85;
	level.special_weapon_magicbox_check = &tomb_special_weapon_magicbox_check;
	level.dont_unset_perk_when_machine_paused = 1;
	tomb_register_client_fields();
	register_burn_overlay();
	zm_tomb_tank::init();
	zm_tomb_giant_robot::init_giant_robot_glows();
	zm_tomb_giant_robot::init_giant_robot();
	level.can_revive = &zm_tomb_giant_robot::tomb_can_revive_override;
	zm_tomb_capture_zones::init_capture_zones();
	zm_tomb_ambient_scripts::init_tomb_ambient_scripts();
	zm_tomb_dig::init_shovel();
	level thread zm_tomb_teleporter::teleporter_init();
	zm_craftables::init();
	zm_tomb_craftables::include_craftables();
	zm_tomb_craftables::init_craftables();
	zm_tomb_craftables::register_clientfields();
	zm_tomb_craftables::randomize_craftable_spawns();
	_zm_weap_beacon::init();
	_zm_weap_one_inch_punch::init();
	zm_tomb_challenges::challenges_init();
	zm_tomb_amb::init();
	load::main();
	level thread function_89182d9b();
	function_67268668();
	zm_tomb_tank::main();
	zm_tomb_teleporter::main();
	zm_tomb_ambient_scripts::main();
	init_sounds();
	level thread setupMusic();
	zm_tomb_amb::main();
	level thread zm_tomb_ee_main::main();
	level.callbackActorDamage = &tomb_actor_damage_override_wrapper;
	level._weaponobjects_on_player_connect_override = &tomb_weaponobjects_on_player_connect_override;
	zm_spawner::register_zombie_death_event_callback(&tomb_zombie_death_event_callback);
	level.player_intersection_tracker_override = &tomb_player_intersection_tracker_override;
	_zm_weap_cymbal_monkey::init();
	level._melee_weapons = [];
	level.a_e_slow_areas = GetEntArray("player_slow_area", "targetname");
	level thread namespace_baebcb1::init();
	level.n_crystals_pickedup = 0;
	level thread zm_tomb_main_quest::main_quest_init();
	level.closest_player_override = &tomb_closest_player_override;
	level.validate_enemy_path_length = &tomb_validate_enemy_path_length;
	level.zones = [];
	level.zone_manager_init_func = &working_zone_init;
	init_zones[0] = "zone_start";
	level thread zm_zonemgr::manage_zones(init_zones);
	if(isdefined(level.optimise_for_splitscreen) && level.optimise_for_splitscreen)
	{
		if(zm_utility::is_Classic())
		{
			level.zombie_ai_limit = 20;
		}
		SetDvar("fx_marks_draw", 0);
		SetDvar("disable_rope", 1);
		SetDvar("cg_disableplayernames", 1);
		SetDvar("disableLookAtEntityLogic", 1);
	}
	else
	{
		level.zombie_ai_limit = 24;
	}
	level.default_laststandpistol = GetWeapon("pistol_c96");
	level.default_solo_laststandpistol = GetWeapon("pistol_c96_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	level thread drop_all_barriers();
	level thread zm_tomb_utility::traversal_blocker();
	callback::on_connect(&on_player_connect);
	callback::on_ai_spawned(&function_7b72be0d);
	zm::register_player_damage_callback(&tomb_player_damage_callback);
	level.custom_get_round_enemy_array_func = &zm_tomb_get_round_enemy_array;
	level flag::wait_till("start_zombie_round_logic");
	util::wait_network_frame();
	level notify("specialty_additionalprimaryweapon_power_on");
	util::wait_network_frame();
	level notify("additionalprimaryweapon_on");
	zombie_utility::set_zombie_var("zombie_use_failsafe", 0);
	level zm_tomb_utility::check_solo_status();
	level thread zm_tomb_utility::adjustments_for_solo();
	level thread zm_tomb_utility::zone_capture_powerup();
	level thread zm_tomb_utility::clean_up_bunker_doors();
	level clientfield::set("lantern_fx", 1);
	level thread zm_tomb_chamber::tomb_watch_chamber_player_activity();
	/#
		zm_tomb_utility::setup_devgui();
	#/
	zm_tomb_utility::init_weather_manager();
	zm_tomb_capture_zones::function_b0debead();
	level.var_9aaae7ae = &function_869d6f66;
	level.var_9f5c2c50 = &function_e36dbcf4;
	level.var_2d4e3645 = &function_d9e1ec4d;
	level.var_2d0e5eb6 = &function_2d0e5eb6;
	level thread zm_tomb_ambient_scripts::function_add29756();
	level thread zm_perks::spare_change();
	zm_tomb_ffotd::main_end();
}

/*
	Name: tomb_register_client_fields
	Namespace: zm_tomb
	Checksum: 0x82487E78
	Offset: 0x3028
	Size: 0x54B
	Parameters: 0
	Flags: None
*/
function tomb_register_client_fields()
{
	clientfield::register("scriptmover", "stone_frozen", 21000, 1, "int");
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("world", "rain_level", 21000, n_bits, "int");
	clientfield::register("world", "snow_level", 21000, n_bits, "int");
	clientfield::register("toplayer", "player_weather_visionset", 21000, 2, "int");
	n_bits = GetMinBitCountForNum(6);
	clientfield::register("toplayer", "player_rumble_and_shake", 21000, n_bits, "int");
	clientfield::register("scriptmover", "sky_pillar", 21000, 1, "int");
	clientfield::register("scriptmover", "staff_charger", 21000, 3, "int");
	clientfield::register("toplayer", "player_staff_charge", 21000, 2, "int");
	clientfield::register("toplayer", "player_tablet_state", 21000, 2, "int");
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("actor", "zombie_soul", 21000, n_bits, "int");
	clientfield::register("zbarrier", "magicbox_runes", 21000, 1, "int");
	clientfield::register("scriptmover", "barbecue_fx", 21000, 1, "int");
	clientfield::register("world", "cooldown_steam", 21000, 2, "int");
	clientfield::register("world", "mus_zmb_egg_snapshot_loop", 21000, 1, "int");
	clientfield::register("toplayer", "sndMaelstrom", 21000, 1, "int");
	clientfield::register("actor", "foot_print_box_fx", 21000, 1, "int");
	clientfield::register("scriptmover", "foot_print_box_glow", 21000, 1, "int");
	clientfield::register("world", "crypt_open_exploder", 21000, 1, "int");
	clientfield::register("world", "lantern_fx", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 21000, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 21000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 21000, 1, "int");
	clientfield::register("actor", "tomb_mech_eye", 21000, 1, "int");
	clientfield::register("actor", "crusader_emissive_fx", 21000, 1, "int");
	clientfield::register("actor", "zombie_instant_explode", 21000, 1, "int");
	clientfield::register("scriptmover", "glow_biplane_trail_fx", 21000, 1, "int");
}

/*
	Name: register_burn_overlay
	Namespace: zm_tomb
	Checksum: 0x34CA649D
	Offset: 0x3580
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function register_burn_overlay()
{
	level.zm_transit_burn_max_duration = 2;
	if(!isdefined(level.vsmgr_prio_overlay_zm_transit_burn))
	{
		level.vsmgr_prio_overlay_zm_transit_burn = 20;
	}
	visionset_mgr::register_info("overlay", "zm_transit_burn", 21000, level.vsmgr_prio_overlay_zm_transit_burn, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
}

/*
	Name: function_2d0e5eb6
	Namespace: zm_tomb
	Checksum: 0x55CA3A5A
	Offset: 0x35F8
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function function_2d0e5eb6()
{
	var_cdb0f86b = getArrayKeys(level.zombie_powerups);
	var_b4442b55 = Array("shield_charge", "ww_grenade", "bonus_points_team");
	var_62e2eaf2 = [];
	for(i = 0; i < var_cdb0f86b.size; i++)
	{
		var_77917a61 = 0;
		foreach(var_68de493a in var_b4442b55)
		{
			if(var_cdb0f86b[i] == var_68de493a)
			{
				var_77917a61 = 1;
				break;
			}
		}
		if(var_77917a61)
		{
			continue;
			continue;
		}
		if(!isdefined(var_62e2eaf2))
		{
			var_62e2eaf2 = [];
		}
		else if(!IsArray(var_62e2eaf2))
		{
			var_62e2eaf2 = Array(var_62e2eaf2);
		}
		var_62e2eaf2[var_62e2eaf2.size] = var_cdb0f86b[i];
	}
	str_powerup = Array::random(var_62e2eaf2);
	return str_powerup;
}

/*
	Name: function_56848b85
	Namespace: zm_tomb
	Checksum: 0x3305DB06
	Offset: 0x37D8
	Size: 0x195
	Parameters: 0
	Flags: None
*/
function function_56848b85()
{
	zombie_in_chamber = zm_tomb_chamber::is_point_in_chamber(self.origin);
	a_players = GetPlayers();
	for(i = 0; i < a_players.size; i++)
	{
		if(!zombie_utility::is_player_valid(a_players[i]) || (isdefined(a_players[i].ignoreme) && a_players[i].ignoreme))
		{
			continue;
		}
		if(isdefined(a_players[i].b_already_on_tank) && a_players[i].b_already_on_tank)
		{
			if(isdefined(self.b_on_tank) && self.b_on_tank)
			{
				return 1;
			}
			else
			{
				a_players[i].origin = level.vh_tank GetTagOrigin("window_left_rear_jmp_jnt");
			}
			continue;
		}
		player_in_chamber = zm_tomb_chamber::is_point_in_chamber(a_players[i].origin);
		if(player_in_chamber != zombie_in_chamber)
		{
			continue;
		}
	}
	return 0;
}

/*
	Name: function_ce3464b9
	Namespace: zm_tomb
	Checksum: 0xD458B5DE
	Offset: 0x3978
	Size: 0x10D
	Parameters: 1
	Flags: Private
*/
function private function_ce3464b9(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid))
	{
		return;
	}
	self.var_13ed8adf = undefined;
	foreach(player in players)
	{
		if(isdefined(player.am_i_valid) && player.am_i_valid && zm_tomb_utility::function_d39fc97a(player))
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: function_7b72be0d
	Namespace: zm_tomb
	Checksum: 0x12877A62
	Offset: 0x3A90
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_7b72be0d()
{
	if(!IsSubStr(self.classname, "crusader"))
	{
		return;
	}
	self clientfield::set("crusader_emissive_fx", 1);
	self waittill("death");
	self clientfield::set("crusader_emissive_fx", 0);
}

/*
	Name: tomb_closest_player_override
	Namespace: zm_tomb
	Checksum: 0xF9BACCCF
	Offset: 0x3B10
	Size: 0x359
	Parameters: 2
	Flags: None
*/
function tomb_closest_player_override(v_zombie_origin, a_players_to_check)
{
	if(isdefined(self.zombie_poi))
	{
		return undefined;
	}
	if(isdefined(self.attackable))
	{
		return undefined;
	}
	if(!isdefined(self.last_closest_player))
	{
		self.last_closest_player = a_players_to_check[0];
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time && (!isdefined(self.var_13ed8adf) || self.var_13ed8adf < level.time))
	{
		self function_ce3464b9(a_players_to_check);
		return self.last_closest_player;
	}
	if(!isdefined(self.var_13ed8adf) || self.var_13ed8adf == level.time)
	{
		self.var_13ed8adf = level.time;
		level.last_closest_time = level.time;
		level.var_2613231a = self;
		if(a_players_to_check.size == 1)
		{
			self.last_closest_player = a_players_to_check[0];
			self function_ce3464b9(a_players_to_check);
			return self.last_closest_player;
		}
		e_player_to_attack = zm_tomb_utility::tomb_get_closest_player_using_paths(v_zombie_origin, a_players_to_check);
		a_players = zm_tomb_tank::get_players_on_tank(1);
		if(a_players.size > 0)
		{
			e_player_closest_on_tank = undefined;
			n_dist_tank_min = 99999999;
			foreach(e_player in a_players)
			{
				n_dist_sq = Distance2DSquared(self.origin, e_player.origin);
				if(n_dist_sq < n_dist_tank_min)
				{
					n_dist_tank_min = n_dist_sq;
					e_player_closest_on_tank = e_player;
				}
			}
			if(zombie_utility::is_player_valid(e_player_to_attack))
			{
				n_dist_for_path = Distance2DSquared(self.origin, e_player_to_attack.origin);
				if(n_dist_tank_min < n_dist_for_path)
				{
					e_player_to_attack = e_player_closest_on_tank;
				}
			}
			else if(zombie_utility::is_player_valid(e_player_closest_on_tank))
			{
				e_player_to_attack = e_player_closest_on_tank;
			}
		}
		if(!isdefined(e_player_to_attack))
		{
			e_player_to_attack = ArrayGetClosest(v_zombie_origin, a_players_to_check);
		}
		self.last_closest_player = e_player_to_attack;
	}
	self function_ce3464b9(a_players_to_check);
	return self.last_closest_player;
}

/*
	Name: function_869d6f66
	Namespace: zm_tomb
	Checksum: 0xFE03A394
	Offset: 0x3E78
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function function_869d6f66()
{
	if(!isdefined(self namespace_93b7f03::function_728dfe3()))
	{
		return 0;
	}
	if(isdefined(self.var_b605c6c3) && !self.var_b605c6c3)
	{
		return 0;
	}
	if(IsSubStr(self.zone_name, "zone_chamber"))
	{
		return 0;
	}
	if(isdefined(self.b_already_on_tank) && self.b_already_on_tank)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_e36dbcf4
	Namespace: zm_tomb
	Checksum: 0x86739D67
	Offset: 0x3F10
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_e36dbcf4()
{
	if(self.is_stomped === 1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_d9e1ec4d
	Namespace: zm_tomb
	Checksum: 0x2EE4ED50
	Offset: 0x3F38
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function function_d9e1ec4d(var_bbf77908)
{
	var_c7786100 = struct::get("zone_chamber", "script_noteworthy");
	ArrayRemoveValue(var_bbf77908, var_c7786100);
	return var_bbf77908;
}

/*
	Name: zm_tomb_get_round_enemy_array
	Namespace: zm_tomb
	Checksum: 0x172F3AE7
	Offset: 0x3F98
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function zm_tomb_get_round_enemy_array()
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAISpeciesArray(level.zombie_team, "all");
	for(i = 0; i < enemies.size; i++)
	{
		if(isdefined(enemies[i].ignore_enemy_count) && enemies[i].ignore_enemy_count && (!isdefined(enemies[i].script_noteworthy) || enemies[i].script_noteworthy != "capture_zombie"))
		{
			continue;
		}
		if(!isdefined(valid_enemies))
		{
			valid_enemies = [];
		}
		else if(!IsArray(valid_enemies))
		{
			valid_enemies = Array(valid_enemies);
		}
		valid_enemies[valid_enemies.size] = enemies[i];
	}
	return valid_enemies;
}

/*
	Name: tomb_player_damage_callback
	Namespace: zm_tomb
	Checksum: 0xD57CAF3A
	Offset: 0x40E8
	Size: 0xF5
	Parameters: 13
	Flags: None
*/
function tomb_player_damage_callback(e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, w_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name)
{
	if(isdefined(w_weapon))
	{
		if(IsSubStr(w_weapon.name, "staff"))
		{
			return 0;
		}
		switch(w_weapon.name)
		{
			case "quadrotorturret":
			case "quadrotorturret_upgraded":
			case "t72_turret":
			case "zombie_markiv_cannon":
			case "zombie_markiv_side_cannon":
			case "zombie_markiv_turret":
			{
				return 0;
			}
		}
	}
	return n_damage;
}

/*
	Name: tomb_random_perk_weights
	Namespace: zm_tomb
	Checksum: 0x25F5F1C5
	Offset: 0x41E8
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function tomb_random_perk_weights()
{
	temp_array = [];
	if(RandomInt(4) == 0)
	{
		ArrayInsert(temp_array, "specialty_doubletap2", 0);
	}
	if(RandomInt(4) == 0)
	{
		ArrayInsert(temp_array, "specialty_deadshot", 0);
	}
	if(RandomInt(4) == 0)
	{
		ArrayInsert(temp_array, "specialty_additionalprimaryweapon", 0);
	}
	if(RandomInt(4) == 0)
	{
		ArrayInsert(temp_array, "specialty_widowswine", 0);
	}
	if(RandomInt(4) == 0)
	{
		ArrayInsert(temp_array, "specialty_electriccherry", 0);
	}
	temp_array = Array::randomize(temp_array);
	level._random_perk_machine_perk_list = Array::randomize(level._random_perk_machine_perk_list);
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = getArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}

/*
	Name: on_player_connect
	Namespace: zm_tomb
	Checksum: 0x2E2EEFB1
	Offset: 0x43D8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread revive_watcher();
	util::wait_network_frame();
	self thread zm_tomb_utility::player_slow_movement_speed_monitor();
	level thread function_a5d4f26d();
}

/*
	Name: revive_watcher
	Namespace: zm_tomb
	Checksum: 0x1B40E612
	Offset: 0x4440
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function revive_watcher()
{
	self endon("death_or_disconnect");
	while(1)
	{
		self waittill("do_revive_ended_normally");
		if(self hasPerk("specialty_quickrevive"))
		{
			self notify("quick_revived_player");
		}
		else
		{
			self notify("revived_player");
		}
	}
}

/*
	Name: function_a5d4f26d
	Namespace: zm_tomb
	Checksum: 0x3841C81
	Offset: 0x44B0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_a5d4f26d()
{
	var_22082ed0 = GetEnt("specialty_additionalprimaryweapon", "script_noteworthy");
	if(isdefined(var_22082ed0) && isdefined(var_22082ed0))
	{
		var_22082ed0.clip ghost();
		var_22082ed0.clip connectpaths();
	}
}

/*
	Name: setup_tomb_spawn_groups
	Namespace: zm_tomb
	Checksum: 0xEA1AA2DF
	Offset: 0x4540
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function setup_tomb_spawn_groups()
{
	level.use_multiple_spawns = 1;
	level.spawner_int = 1;
	level.fn_custom_zombie_spawner_selection = &function_df9f5719;
	level waittill("start_zombie_round_logic");
}

/*
	Name: function_df9f5719
	Namespace: zm_tomb
	Checksum: 0x4E6852F5
	Offset: 0x4588
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function function_df9f5719()
{
	var_6af221a2 = [];
	a_s_spots = Array::randomize(level.zm_loc_types["zombie_location"]);
	for(i = 0; i < a_s_spots.size; i++)
	{
		if(!isdefined(a_s_spots[i].script_int))
		{
			var_343b1937 = 1;
		}
		else
		{
			var_343b1937 = a_s_spots[i].script_int;
		}
		var_c15b2128 = [];
		foreach(var_a0bd4da1 in level.zombie_spawners)
		{
			if(var_a0bd4da1.script_int == var_343b1937)
			{
				if(!isdefined(var_c15b2128))
				{
					var_c15b2128 = [];
				}
				else if(!IsArray(var_c15b2128))
				{
					var_c15b2128 = Array(var_c15b2128);
				}
				var_c15b2128[var_c15b2128.size] = var_a0bd4da1;
			}
		}
		if(var_c15b2128.size)
		{
			var_a0bd4da1 = Array::random(var_c15b2128);
			return var_a0bd4da1;
		}
	}
	/#
		Assert(isdefined(var_a0bd4da1), "Dev Block strings are not supported" + var_343b1937);
	#/
}

/*
	Name: chamber_capture_zombie_spawn_init
	Namespace: zm_tomb
	Checksum: 0x1DBAF05A
	Offset: 0x4798
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function chamber_capture_zombie_spawn_init()
{
	self endon("death");
	self waittill("completed_emerging_into_playable_area");
	self clientfield::set("zone_capture_zombie", 1);
}

/*
	Name: tomb_round_spawn_failsafe
	Namespace: zm_tomb
	Checksum: 0x9F08C650
	Offset: 0x47E0
	Size: 0x35F
	Parameters: 0
	Flags: None
*/
function tomb_round_spawn_failsafe()
{
	self endon("death");
	prevOrigin = self.origin;
	while(1)
	{
		if(isdefined(self.ignore_round_spawn_failsafe) && self.ignore_round_spawn_failsafe)
		{
			return;
		}
		wait(15);
		if(isdefined(self.is_inert) && self.is_inert)
		{
			continue;
		}
		players = GetPlayers();
		zombie_blood = 0;
		foreach(player in players)
		{
			if(zm_utility::is_player_valid(player))
			{
				if(isdefined(player.zombie_vars["zombie_powerup_zombie_blood_on"]) && player.zombie_vars["zombie_powerup_zombie_blood_on"])
				{
					zombie_blood = 1;
					break;
				}
			}
		}
		if(zombie_blood)
		{
			continue;
		}
		if(isdefined(self.lastchunk_destroy_time))
		{
			if(GetTime() - self.lastchunk_destroy_time < 8000)
			{
				continue;
			}
		}
		if(self.origin[2] < -3000)
		{
			if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !level flag::get("dog_round") && (!isdefined(self.isscreecher) && self.isscreecher))
			{
				level.zombie_total++;
				level.zombie_total_subtract++;
			}
			self DoDamage(self.health + 100, (0, 0, 0));
			break;
		}
		if(DistanceSquared(self.origin, prevOrigin) < 576)
		{
			if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !level flag::get("dog_round"))
			{
				if(!self.ignoreall && (!isdefined(self.nuked) && self.nuked) && (!isdefined(self.marked_for_death) && self.marked_for_death) && (!isdefined(self.isscreecher) && self.isscreecher) && (!isdefined(self.missingLegs) && self.missingLegs) && (!isdefined(self.is_brutus) && self.is_brutus))
				{
					level.zombie_total++;
					level.zombie_total_subtract++;
				}
			}
			level.zombies_timeout_playspace++;
			self DoDamage(self.health + 100, (0, 0, 0));
			break;
		}
		prevOrigin = self.origin;
	}
}

/*
	Name: give_personality_characters
	Namespace: zm_tomb
	Checksum: 0xDFE5BFA6
	Offset: 0x4B48
	Size: 0x2E3
	Parameters: 0
	Flags: None
*/
function give_personality_characters()
{
	if(isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_farmgirl_viewhands"))
	{
		return;
	}
	self DetachAll();
	if(!isdefined(self.characterindex))
	{
		self.characterindex = assign_lowest_unused_character_index();
	}
	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = 0;
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			self.characterindex = GetDvarInt("Dev Block strings are not supported");
		}
	#/
	self SetCharacterBodyType(self.characterindex);
	self SetCharacterBodyStyle(0);
	self SetCharacterHelmetStyle(0);
	switch(self.characterindex)
	{
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("shotgun_semiauto");
			self.character_name = "Nikolai";
			break;
		}
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("frag_grenade");
			self.character_name = "Dempsey";
			break;
		}
		case 3:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("ar_accurate");
			self.character_name = "Takeo";
			break;
		}
		case 2:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndRadioA = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("pistol_c96");
			self.character_name = "Richtofen";
			break;
		}
	}
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
	self thread set_exert_id();
}

/*
	Name: set_exert_id
	Namespace: zm_tomb
	Checksum: 0xC8AC26F6
	Offset: 0x4E38
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function set_exert_id()
{
	self endon("disconnect");
	util::wait_network_frame();
	util::wait_network_frame();
	self zm_audio::SetExertVoice(self.characterindex + 1);
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: zm_tomb
	Checksum: 0xC0F664CD
	Offset: 0x4E98
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = GetPlayers();
	if(players.size == 1)
	{
		charindexarray = Array::randomize(charindexarray);
		if(charindexarray[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	else
	{
		n_characters_defined = 0;
		foreach(player in players)
		{
			if(isdefined(player.characterindex))
			{
				ArrayRemoveValue(charindexarray, player.characterindex, 0);
				n_characters_defined++;
			}
		}
		if(charindexarray.size > 0)
		{
			if(n_characters_defined == players.size - 1)
			{
				if(!(isdefined(level.has_richtofen) && level.has_richtofen))
				{
					level.has_richtofen = 1;
					return 2;
				}
			}
			charindexarray = Array::randomize(charindexarray);
			if(charindexarray[0] == 2)
			{
				level.has_richtofen = 1;
			}
			return charindexarray[0];
		}
	}
	return 0;
}

/*
	Name: initCharacterStartIndex
	Namespace: zm_tomb
	Checksum: 0x295B22A3
	Offset: 0x50B8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function initCharacterStartIndex()
{
	level.characterStartIndex = RandomInt(4);
}

/*
	Name: zm_player_fake_death_cleanup
	Namespace: zm_tomb
	Checksum: 0x921E5545
	Offset: 0x50E8
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function zm_player_fake_death_cleanup()
{
	if(isdefined(self._fall_down_anchor))
	{
		self._fall_down_anchor delete();
		self._fall_down_anchor = undefined;
	}
}

/*
	Name: zm_player_fake_death
	Namespace: zm_tomb
	Checksum: 0xE376BCF6
	Offset: 0x5128
	Size: 0x159
	Parameters: 1
	Flags: None
*/
function zm_player_fake_death(vDir)
{
	level notify("fake_death");
	self notify("fake_death");
	stance = self GetStance();
	self.ignoreme = 1;
	self EnableInvulnerability();
	self TakeAllWeapons();
	if(isdefined(self.insta_killed) && self.insta_killed)
	{
		self zm::player_fake_death();
		self AllowProne(1);
		self AllowCrouch(0);
		self AllowStand(0);
		wait(0.25);
		self FreezeControls(1);
	}
	else
	{
		self FreezeControls(1);
		self thread fall_down(vDir, stance);
		wait(1);
	}
}

/*
	Name: fall_down
	Namespace: zm_tomb
	Checksum: 0xE76168C
	Offset: 0x5290
	Size: 0x493
	Parameters: 2
	Flags: None
*/
function fall_down(vDir, stance)
{
	self endon("disconnect");
	level endon("game_module_ended");
	self ghost();
	origin = self.origin;
	xySpeed = (0, 0, 0);
	angles = self getPlayerAngles();
	angles = (angles[0], angles[1], angles[2] + RandomFloatRange(-5, 5));
	if(isdefined(vDir) && length(vDir) > 0)
	{
		XYSpeedMag = 40 + RandomInt(12) + RandomInt(12);
		xySpeed = XYSpeedMag * VectorNormalize((vDir[0], vDir[1], 0));
	}
	linker = spawn("script_origin", (0, 0, 0));
	linker.origin = origin;
	linker.angles = angles;
	self._fall_down_anchor = linker;
	self playerLinkTo(linker);
	self playsoundtoplayer("zmb_player_death_fall", self);
	falling = stance != "prone";
	if(falling)
	{
		origin = playerphysicstrace(origin, origin + xySpeed);
		eye = self util::get_eye();
		floor_height = 10 + origin[2] - eye[2];
		origin = origin + (0, 0, floor_height);
		lerpTime = 0.5;
		linker moveto(origin, lerpTime, lerpTime);
		linker RotateTo(angles, lerpTime, lerpTime);
	}
	self FreezeControls(1);
	if(falling)
	{
		linker waittill("movedone");
	}
	self GiveWeapon(level.weaponZMDeathThroe);
	self SwitchToWeapon(level.weaponZMDeathThroe);
	if(falling)
	{
		bounce = RandomInt(4) + 8;
		origin = origin + (0, 0, bounce) - xySpeed * 0.1;
		lerpTime = bounce / 50;
		linker moveto(origin, lerpTime, 0, lerpTime);
		linker waittill("movedone");
		origin = origin + (0, 0, bounce * -1) + xySpeed * 0.1;
		lerpTime = lerpTime / 2;
		linker moveto(origin, lerpTime, lerpTime);
		linker waittill("movedone");
		linker moveto(origin, 5, 0);
	}
	wait(15);
	linker delete();
}

/*
	Name: offhand_weapon_overrride
	Namespace: zm_tomb
	Checksum: 0xBD4666EE
	Offset: 0x5730
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = GetWeapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("beacon");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey_upgraded");
	zm_utility::register_melee_weapon_for_level(level.weaponBaseMelee.name);
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	level.zombie_equipment_player_init = undefined;
	level.equipment_safe_to_drop = &equipment_safe_to_drop;
}

/*
	Name: equipment_safe_to_drop
	Namespace: zm_tomb
	Checksum: 0x5F9F3C98
	Offset: 0x5828
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function equipment_safe_to_drop(weapon)
{
	if(!isdefined(self.origin))
	{
		return 1;
	}
	return 1;
}

/*
	Name: offhand_weapon_give_override
	Namespace: zm_tomb
	Checksum: 0xBD6C1B62
	Offset: 0x5858
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function offhand_weapon_give_override(str_weapon)
{
	self endon("death");
	if(zm_utility::is_tactical_grenade(str_weapon) && isdefined(self zm_utility::get_player_tactical_grenade()) && !self zm_utility::is_player_tactical_grenade(str_weapon))
	{
		self SetWeaponAmmoClip(self zm_utility::get_player_tactical_grenade(), 0);
		self TakeWeapon(self zm_utility::get_player_tactical_grenade());
	}
	return 0;
}

/*
	Name: tomb_weaponobjects_on_player_connect_override
	Namespace: zm_tomb
	Checksum: 0xACEAABA4
	Offset: 0x5920
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function tomb_weaponobjects_on_player_connect_override()
{
	level.retrievable_knife_init_names = [];
	callback::on_connect(&zm_weapons::weaponobjects_on_player_connect_override_internal);
}

/*
	Name: tomb_player_intersection_tracker_override
	Namespace: zm_tomb
	Checksum: 0x19AF7133
	Offset: 0x5960
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function tomb_player_intersection_tracker_override(e_player)
{
	if(isdefined(e_player.b_already_on_tank) && e_player.b_already_on_tank || (isdefined(self.b_already_on_tank) && self.b_already_on_tank))
	{
		return 1;
	}
	if(isdefined(e_player.giant_robot_transition) && e_player.giant_robot_transition || (isdefined(self.giant_robot_transition) && self.giant_robot_transition))
	{
		return 1;
	}
	return 0;
}

/*
	Name: init_tomb_stats
	Namespace: zm_tomb
	Checksum: 0x8B3AD997
	Offset: 0x5A00
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function init_tomb_stats()
{
	self zm_tomb_achievement::init_player_achievement_stats();
}

/*
	Name: custom_add_weapons
	Namespace: zm_tomb
	Checksum: 0xCA6B221E
	Offset: 0x5A28
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_tomb_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: custom_add_vox
	Namespace: zm_tomb
	Checksum: 0x85AADC54
	Offset: 0x5A68
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_tomb_vox.csv");
}

/*
	Name: include_powerups
	Namespace: zm_tomb
	Checksum: 0x9F6316A
	Offset: 0x5A90
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function include_powerups()
{
	level._zombiemode_powerup_grab = &tomb_powerup_grab;
	/#
		setup_powerup_devgui();
	#/
	/#
		setup_oneinchpunch_devgui();
	#/
	/#
		setup_tablet_devgui();
	#/
}

/*
	Name: include_perks_in_random_rotation
	Namespace: zm_tomb
	Checksum: 0xA4E1C94A
	Offset: 0x5B00
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function include_perks_in_random_rotation()
{
	zm_perk_random::include_perk_in_random_rotation("specialty_armorvest");
	zm_perk_random::include_perk_in_random_rotation("specialty_quickrevive");
	zm_perk_random::include_perk_in_random_rotation("specialty_fastreload");
	zm_perk_random::include_perk_in_random_rotation("specialty_doubletap2");
	zm_perk_random::include_perk_in_random_rotation("specialty_staminup");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_additionalprimaryweapon");
	zm_perk_random::include_perk_in_random_rotation("specialty_electriccherry");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
	level.custom_random_perk_weights = &tomb_random_perk_weights;
}

/*
	Name: tomb_powerup_grab
	Namespace: zm_tomb
	Checksum: 0x217CED55
	Offset: 0x5C00
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function tomb_powerup_grab(s_powerup, e_player)
{
	if(s_powerup.powerup_name == "zombie_blood")
	{
		level thread namespace_43a18dd5::zombie_blood_powerup(s_powerup, e_player);
	}
}

/*
	Name: setup_powerup_devgui
	Namespace: zm_tomb
	Checksum: 0x1FE5FD5F
	Offset: 0x5C58
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function setup_powerup_devgui()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		level thread watch_devgui_zombie_blood();
	#/
}

/*
	Name: setup_oneinchpunch_devgui
	Namespace: zm_tomb
	Checksum: 0xCEFB4E0
	Offset: 0x5CC0
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function setup_oneinchpunch_devgui()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		level thread watch_devgui_oneinchpunch();
	#/
}

/*
	Name: watch_devgui_oneinchpunch
	Namespace: zm_tomb
	Checksum: 0x2701A74A
	Offset: 0x5E40
	Size: 0x5CF
	Parameters: 0
	Flags: None
*/
function watch_devgui_oneinchpunch()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(player in GetPlayers())
				{
					player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
				}
				break;
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(player in GetPlayers())
				{
					player.b_punch_upgraded = 1;
					player.str_punch_element = "Dev Block strings are not supported";
					player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
				}
				break;
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(player in GetPlayers())
				{
					player.b_punch_upgraded = 1;
					player.str_punch_element = "Dev Block strings are not supported";
					player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
				}
				break;
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(player in GetPlayers())
				{
					player.b_punch_upgraded = 1;
					player.str_punch_element = "Dev Block strings are not supported";
					player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
				}
				break;
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(player in GetPlayers())
				{
					player.b_punch_upgraded = 1;
					player.str_punch_element = "Dev Block strings are not supported";
					player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
				}
				break;
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(player in GetPlayers())
				{
					player.b_punch_upgraded = 1;
					player.str_punch_element = "Dev Block strings are not supported";
					player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
				}
			}
			wait(0.1);
		}
	#/
}

/*
	Name: setup_tablet_devgui
	Namespace: zm_tomb
	Checksum: 0xB42C4A0E
	Offset: 0x6418
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function setup_tablet_devgui()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		level thread watch_devgui_tablet();
	#/
}

/*
	Name: watch_devgui_tablet
	Namespace: zm_tomb
	Checksum: 0x8ECC5316
	Offset: 0x64B0
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function watch_devgui_tablet()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
			{
				player = GetPlayers()[0];
				n_tablet_state = Int(GetDvarInt("Dev Block strings are not supported"));
				player clientfield::set_to_player("Dev Block strings are not supported", n_tablet_state);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.1);
		}
	#/
}

/*
	Name: watch_devgui_zombie_blood
	Namespace: zm_tomb
	Checksum: 0x2D7D2FCE
	Offset: 0x6598
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function watch_devgui_zombie_blood()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level thread zm_devgui::zombie_devgui_give_powerup("Dev Block strings are not supported", 1);
			}
			wait(0.1);
		}
	#/
}

/*
	Name: watch_devgui_double_points
	Namespace: zm_tomb
	Checksum: 0x946E420E
	Offset: 0x6628
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function watch_devgui_double_points()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level thread zm_devgui::zombie_devgui_give_powerup("Dev Block strings are not supported", 1);
				IPrintLnBold("Dev Block strings are not supported");
			}
			wait(0.1);
		}
	#/
}

/*
	Name: setup_rex_starts
	Namespace: zm_tomb
	Checksum: 0x2A3E7409
	Offset: 0x66D0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function setup_rex_starts()
{
	zm_utility::add_gametype("zclassic", &dummy, "zclassic", &dummy);
	zm_utility::add_gameloc("tomb", &dummy, "tomb", &dummy);
}

/*
	Name: dummy
	Namespace: zm_tomb
	Checksum: 0x99EC1590
	Offset: 0x6760
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function dummy()
{
}

/*
	Name: working_zone_init
	Namespace: zm_tomb
	Checksum: 0xA91BAD30
	Offset: 0x6770
	Size: 0x19EB
	Parameters: 0
	Flags: None
*/
function working_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("zone_robot_head", "zone_robot_head", "always_on");
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_start_a", "always_on");
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_start_b", "always_on");
	zm_zonemgr::add_adjacent_zone("zone_start_a", "zone_start_b", "always_on");
	zm_zonemgr::add_adjacent_zone("zone_start_a", "zone_bunker_1a", "activate_zone_bunker_1");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1a", "zone_bunker_1", "activate_zone_bunker_1");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1a", "zone_bunker_1", "activate_zone_bunker_3a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1", "zone_bunker_3a", "activate_zone_bunker_3a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_3a", "zone_bunker_3b", "activate_zone_bunker_3a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_3a", "zone_bunker_3b", "activate_zone_bunker_3b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_3b", "zone_bunker_5a", "activate_zone_bunker_3b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_5a", "zone_bunker_5b", "activate_zone_bunker_3b");
	zm_zonemgr::add_adjacent_zone("zone_start_b", "zone_bunker_2a", "activate_zone_bunker_2");
	zm_zonemgr::add_adjacent_zone("zone_bunker_2a", "zone_bunker_2", "activate_zone_bunker_2");
	zm_zonemgr::add_adjacent_zone("zone_bunker_2a", "zone_bunker_2", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_2", "zone_bunker_4a", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4a", "zone_bunker_4b", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4a", "zone_bunker_4c", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4b", "zone_bunker_4f", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4c", "zone_bunker_4d", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4c", "zone_bunker_4e", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_c1", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_d", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_bunker_4a");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4a", "zone_bunker_4b", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4a", "zone_bunker_4c", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4b", "zone_bunker_4f", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4c", "zone_bunker_4d", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4c", "zone_bunker_4e", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4b", "zone_bunker_5a", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_5a", "zone_bunker_5b", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_c1", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_d", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_bunker_4b");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_a", "zone_nml_7", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_a", "zone_nml_7a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_a", "zone_bunker_tank_a1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_a1", "zone_bunker_tank_a2", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_a1", "zone_bunker_tank_b", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_b", "zone_bunker_tank_c", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_d1", "zone_bunker_tank_e", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_e", "zone_bunker_tank_e1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_e1", "zone_bunker_tank_e2", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_e1", "zone_bunker_tank_f", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_f", "zone_nml_1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_bunker_5b", "zone_nml_2a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_0", "zone_nml_1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_0", "zone_nml_farm", "activate_zone_farm");
	zm_zonemgr::add_adjacent_zone("zone_nml_1", "zone_nml_2", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_1", "zone_nml_4", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_1", "zone_nml_20", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_2", "zone_nml_2a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_2", "zone_nml_2b", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_2", "zone_nml_3", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_3", "zone_nml_4", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_3", "zone_nml_13", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_4", "zone_nml_5", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_4", "zone_nml_13", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_5", "zone_nml_farm", "activate_zone_farm");
	zm_zonemgr::add_adjacent_zone("zone_nml_6", "zone_nml_2b", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_6", "zone_nml_7", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_6", "zone_nml_7a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_6", "zone_nml_8", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_7", "zone_nml_7a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_7", "zone_nml_9", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_7", "zone_nml_10", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_8", "zone_nml_10a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_8", "zone_nml_14", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_8", "zone_nml_16", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_9", "zone_nml_7a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_9", "zone_nml_9a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_9", "zone_nml_11", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_10", "zone_nml_10a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_10", "zone_nml_11", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_10a", "zone_nml_12", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_10a", "zone_village_4", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_11", "zone_nml_9a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_11", "zone_nml_11a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_11", "zone_nml_12", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_12", "zone_nml_11a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_12", "zone_nml_12a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_13", "zone_nml_15", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_14", "zone_nml_15", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_15", "zone_nml_17", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_15a", "zone_nml_14", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_15a", "zone_nml_15", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_16", "zone_nml_2b", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_16", "zone_nml_16a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_16", "zone_nml_18", "activate_zone_ruins");
	zm_zonemgr::add_adjacent_zone("zone_nml_17", "zone_nml_17a", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_17", "zone_nml_18", "activate_zone_ruins");
	zm_zonemgr::add_adjacent_zone("zone_nml_18", "zone_nml_19", "activate_zone_ruins");
	zm_zonemgr::add_adjacent_zone("zone_nml_farm", "zone_nml_celllar", "activate_zone_farm");
	zm_zonemgr::add_adjacent_zone("zone_nml_farm", "zone_nml_farm_1", "activate_zone_farm");
	zm_zonemgr::add_adjacent_zone("zone_nml_19", "ug_bottom_zone", "activate_zone_crypt");
	zm_zonemgr::add_adjacent_zone("zone_village_0", "zone_nml_15", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_0", "zone_village_4b", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_1", "zone_village_1a", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_1", "zone_village_2", "activate_zone_village_1");
	zm_zonemgr::add_adjacent_zone("zone_village_1", "zone_village_4b", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_1", "zone_village_5b", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_2", "zone_village_3", "activate_zone_village_1");
	zm_zonemgr::add_adjacent_zone("zone_village_3", "zone_village_3a", "activate_zone_village_1");
	zm_zonemgr::add_adjacent_zone("zone_village_3", "zone_ice_stairs", "activate_zone_village_1");
	zm_zonemgr::add_adjacent_zone("zone_ice_stairs", "zone_ice_stairs_1", "activate_zone_village_1");
	zm_zonemgr::add_adjacent_zone("zone_village_3a", "zone_village_3b", "activate_zone_village_1");
	zm_zonemgr::add_adjacent_zone("zone_village_4", "zone_nml_14", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_4", "zone_village_4a", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_4", "zone_village_4b", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_5", "zone_nml_4", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_5", "zone_village_5a", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_5a", "zone_village_5b", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_6", "zone_village_5b", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_village_6", "zone_village_6a", "activate_zone_village_0");
	zm_zonemgr::add_adjacent_zone("zone_chamber_0", "zone_chamber_1", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_0", "zone_chamber_3", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_0", "zone_chamber_4", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_1", "zone_chamber_2", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_1", "zone_chamber_3", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_1", "zone_chamber_4", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_1", "zone_chamber_5", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_2", "zone_chamber_4", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_2", "zone_chamber_5", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_3", "zone_chamber_4", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_3", "zone_chamber_6", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_3", "zone_chamber_7", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_4", "zone_chamber_5", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_4", "zone_chamber_6", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_4", "zone_chamber_7", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_4", "zone_chamber_8", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_5", "zone_chamber_7", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_5", "zone_chamber_8", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_6", "zone_chamber_7", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_chamber_7", "zone_chamber_8", "activate_zone_chamber");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1", "zone_bunker_1a", "activate_zone_bunker_1_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1a", "zone_fire_stairs", "activate_zone_bunker_1_tank");
	zm_zonemgr::add_adjacent_zone("zone_fire_stairs", "zone_fire_stairs_1", "activate_zone_bunker_1_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_2", "zone_bunker_2a", "activate_zone_bunker_2_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4a", "zone_bunker_4b", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4a", "zone_bunker_4c", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4c", "zone_bunker_4d", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4c", "zone_bunker_4e", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_c1", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_d", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_bunker_4_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_tank_b", "zone_bunker_6", "activate_zone_bunker_6_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1", "zone_bunker_6", "activate_zone_bunker_6_tank");
	level thread activate_zone_trig("trig_zone_bunker_1", "activate_zone_bunker_1_tank");
	level thread activate_zone_trig("trig_zone_bunker_2", "activate_zone_bunker_2_tank");
	level thread activate_zone_trig("trig_zone_bunker_4", "activate_zone_bunker_4_tank");
	level thread activate_zone_trig("trig_zone_bunker_6", "activate_zone_bunker_6_tank", "activate_zone_bunker_1_tank");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1a", "zone_fire_stairs", "activate_zone_bunker_1");
	zm_zonemgr::add_adjacent_zone("zone_fire_stairs", "zone_fire_stairs_1", "activate_zone_bunker_1");
	zm_zonemgr::add_adjacent_zone("zone_bunker_1a", "zone_fire_stairs", "activate_zone_bunker_3a");
	zm_zonemgr::add_adjacent_zone("zone_fire_stairs", "zone_fire_stairs_1", "activate_zone_bunker_3a");
	zm_zonemgr::add_adjacent_zone("zone_nml_9", "zone_air_stairs", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_air_stairs", "zone_air_stairs_1", "activate_zone_nml");
	zm_zonemgr::add_adjacent_zone("zone_nml_celllar", "zone_bolt_stairs", "activate_zone_farm");
	zm_zonemgr::add_adjacent_zone("zone_bolt_stairs", "zone_bolt_stairs_1", "activate_zone_farm");
}

/*
	Name: activate_zone_trig
	Namespace: zm_tomb
	Checksum: 0x81707589
	Offset: 0x8168
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function activate_zone_trig(str_name, str_zone1, str_zone2)
{
	trig = GetEnt(str_name, "targetname");
	trig waittill("trigger");
	if(isdefined(str_zone1))
	{
		level flag::set(str_zone1);
	}
	if(isdefined(str_zone2))
	{
		level flag::set(str_zone2);
	}
	trig delete();
}

/*
	Name: check_tank_platform_zone
	Namespace: zm_tomb
	Checksum: 0xF27D1BB5
	Offset: 0x8228
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function check_tank_platform_zone()
{
	while(1)
	{
		level waittill("newzoneActive", activeZone);
		if(activeZone == "zone_bunker_3")
		{
			break;
		}
		wait(1);
	}
	level flag::set("activate_zone_nml");
}

/*
	Name: tomb_vehicle_damage_override_wrapper
	Namespace: zm_tomb
	Checksum: 0xF3C3F015
	Offset: 0x8290
	Size: 0x99
	Parameters: 13
	Flags: None
*/
function tomb_vehicle_damage_override_wrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName)
{
	if(isdefined(level.a_func_vehicle_damage_override[self.vehicleType]))
	{
		return level.a_func_vehicle_damage_override[self.vehicleType];
	}
	return iDamage;
}

/*
	Name: drop_all_barriers
	Namespace: zm_tomb
	Checksum: 0x4322A9CE
	Offset: 0x8338
	Size: 0x187
	Parameters: 0
	Flags: None
*/
function drop_all_barriers()
{
	zkeys = getArrayKeys(level.zones);
	for(z = 0; z < level.zones.size; z++)
	{
		zbarriers = get_all_zone_zbarriers(zkeys[z]);
		if(!isdefined(zbarriers))
		{
			break;
		}
		foreach(zbarrier in zbarriers)
		{
			zbarrier_pieces = zbarrier GetNumZBarrierPieces();
			for(i = 0; i < zbarrier_pieces; i++)
			{
				zbarrier HideZBarrierPiece(i);
				zbarrier SetZBarrierPieceState(i, "open");
			}
			wait(0.05);
		}
	}
}

/*
	Name: get_all_zone_zbarriers
	Namespace: zm_tomb
	Checksum: 0x2A2EA32
	Offset: 0x84C8
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function get_all_zone_zbarriers(zone_name)
{
	if(!isdefined(zone_name))
	{
		return undefined;
	}
	zone = level.zones[zone_name];
	return zone.zbarriers;
}

/*
	Name: tomb_special_weapon_magicbox_check
	Namespace: zm_tomb
	Checksum: 0x6D9EF7A5
	Offset: 0x8518
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function tomb_special_weapon_magicbox_check(weapon)
{
	if(weapon.name == "beacon")
	{
		if(isdefined(self.beacon_ready) && self.beacon_ready)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	if(isdefined(level.zombie_weapons[weapon].shared_ammo_weapon))
	{
		if(self zm_weapons::has_weapon_or_upgrade(level.zombie_weapons[weapon].shared_ammo_weapon))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: tomb_actor_damage_override_wrapper
	Namespace: zm_tomb
	Checksum: 0xA20FBA0A
	Offset: 0x85C0
	Size: 0x30F
	Parameters: 15
	Flags: None
*/
function tomb_actor_damage_override_wrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal)
{
	if(isdefined(self.b_zombie_blood_damage_only) && self.b_zombie_blood_damage_only)
	{
		if(!isPlayer(eAttacker) || !eAttacker.zombie_vars["zombie_powerup_zombie_blood_on"])
		{
			return 0;
		}
	}
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "capture_zombie" && isdefined(eAttacker) && isPlayer(eAttacker))
	{
		if(iDamage >= self.health)
		{
			if(100 * level.round_number > eAttacker.n_capture_zombie_points)
			{
				eAttacker zm_score::player_add_points("rebuild_board", 10);
				eAttacker.n_capture_zombie_points = eAttacker.n_capture_zombie_points + 10;
			}
		}
	}
	return_val = self zm::actor_damage_override_wrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal);
	if(self.health <= 0)
	{
		if(weapon.name == "zombie_markiv_cannon" && sMeansOfDeath == "MOD_CRUSH")
		{
			self thread zm_tomb_utility::zombie_gib_guts();
		}
		else if(isdefined(self.b_on_tank) && self.b_on_tank || (isdefined(self.b_climbing_tank) && self.b_climbing_tank))
		{
			self zm_tomb_tank::zombie_on_tank_death_animscript_callback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal);
		}
		if(isdefined(eAttacker) && isdefined(eAttacker.targetname) && eAttacker.targetname == "quadrotor_ai")
		{
			eAttacker thread zm_tomb_vo::function_860b0710();
		}
	}
	return return_val;
}

/*
	Name: tomb_zombie_death_event_callback
	Namespace: zm_tomb
	Checksum: 0x221AD21F
	Offset: 0x88D8
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function tomb_zombie_death_event_callback(attacker)
{
	if(isdefined(self) && isdefined(self.damagelocation) && isdefined(self.damageMod) && isdefined(self.damageWeapon) && isdefined(self.attacker) && isPlayer(self.attacker))
	{
		if(zm_utility::is_headshot(self.damageWeapon, self.damagelocation, self.damageMod) && namespace_a528e918::challenge_exists("zc_headshots") && !self.script_noteworthy === "capture_zombie")
		{
			self.attacker namespace_a528e918::increment_stat("zc_headshots");
		}
	}
}

/*
	Name: zombie_init_done
	Namespace: zm_tomb
	Checksum: 0xF48A0D04
	Offset: 0x89B8
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function zombie_init_done()
{
	self.allowPain = 0;
}

/*
	Name: tomb_validate_enemy_path_length
	Namespace: zm_tomb
	Checksum: 0x2F926176
	Offset: 0x89D0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function tomb_validate_enemy_path_length(player)
{
	max_dist = 1296;
	d = DistanceSquared(self.origin, player.origin);
	if(d <= max_dist)
	{
		return 1;
	}
	return 0;
}

/*
	Name: show_zombie_count
	Namespace: zm_tomb
	Checksum: 0x9029E003
	Offset: 0x8A40
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function show_zombie_count()
{
	self endon("death_or_disconnect");
	level flag::wait_till("start_zombie_round_logic");
	while(1)
	{
		n_round_zombies = zombie_utility::get_current_zombie_count();
		str_hint = "Alive: " + n_round_zombies + ". To Spawn: " + level.zombie_total;
		/#
			IPrintLnBold(str_hint);
		#/
		wait(5);
	}
}

/*
	Name: tomb_custom_electric_cherry_laststand
	Namespace: zm_tomb
	Checksum: 0x7A387D0A
	Offset: 0x8AE8
	Size: 0x221
	Parameters: 0
	Flags: None
*/
function tomb_custom_electric_cherry_laststand()
{
	VisionSetLastStand("zombie_last_stand", 1);
	if(isdefined(self))
	{
		playFX(level._effect["electric_cherry_explode"], self.origin);
		self playsound("zmb_cherry_explode");
		self notify("electric_cherry_start");
		wait(0.05);
		a_zombies = GetAISpeciesArray("axis", "all");
		a_zombies = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, 500);
		for(i = 0; i < a_zombies.size; i++)
		{
			if(isalive(self))
			{
				if(a_zombies[i].health <= 1000)
				{
					a_zombies[i] thread zm_perk_electric_cherry::electric_cherry_death_fx();
					if(isdefined(self.cherry_kills))
					{
						self.cherry_kills++;
					}
					self zm_score::add_to_player_score(40);
				}
				else
				{
					a_zombies[i] thread zm_perk_electric_cherry::electric_cherry_stun();
					a_zombies[i] thread zm_perk_electric_cherry::electric_cherry_shock_fx();
				}
				wait(0.1);
				a_zombies[i] DoDamage(1000, self.origin, self, self, "none");
			}
		}
		self notify("electric_cherry_end");
	}
}

/*
	Name: tomb_custom_electric_cherry_reload_attack
	Namespace: zm_tomb
	Checksum: 0x50E5EA00
	Offset: 0x8D18
	Size: 0x4B5
	Parameters: 0
	Flags: None
*/
function tomb_custom_electric_cherry_reload_attack()
{
	self endon("death");
	self endon("disconnect");
	self endon("stop_electric_cherry_reload_attack");
	self.wait_on_reload = [];
	self.consecutive_electric_cherry_attacks = 0;
	while(1)
	{
		self waittill("reload_start");
		var_1bcd223d = self GetCurrentWeapon();
		if(IsInArray(self.wait_on_reload, var_1bcd223d))
		{
			continue;
		}
		self.wait_on_reload[self.wait_on_reload.size] = var_1bcd223d;
		self.consecutive_electric_cherry_attacks++;
		n_clip_current = self GetWeaponAmmoClip(var_1bcd223d);
		n_clip_max = var_1bcd223d.clipSize;
		n_fraction = n_clip_current / n_clip_max;
		perk_radius = math::linear_map(n_fraction, 1, 0, 32, 128);
		perk_dmg = math::linear_map(n_fraction, 1, 0, 1, 1045);
		self thread zm_perk_electric_cherry::check_for_reload_complete(var_1bcd223d);
		if(isdefined(self))
		{
			switch(self.consecutive_electric_cherry_attacks)
			{
				case 0:
				case 1:
				{
					n_zombie_limit = undefined;
					break;
				}
				case 2:
				{
					n_zombie_limit = 8;
					break;
				}
				case 3:
				{
					n_zombie_limit = 4;
					break;
				}
				case 4:
				{
					n_zombie_limit = 2;
					break;
				}
				case default:
				{
					n_zombie_limit = 0;
				}
			}
			self thread zm_perk_electric_cherry::electric_cherry_cooldown_timer(var_1bcd223d);
			if(isdefined(n_zombie_limit) && n_zombie_limit == 0)
			{
				continue;
			}
			self thread zm_perk_electric_cherry::electric_cherry_reload_fx(n_fraction);
			self notify("electric_cherry_start");
			self playsound("zmb_cherry_explode");
			a_zombies = GetAISpeciesArray("axis", "all");
			a_zombies = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, perk_radius);
			n_zombies_hit = 0;
			for(i = 0; i < a_zombies.size; i++)
			{
				if(isalive(self) && isalive(a_zombies[i]))
				{
					if(isdefined(n_zombie_limit))
					{
						if(n_zombies_hit < n_zombie_limit)
						{
							n_zombies_hit++;
						}
						else
						{
							break;
						}
					}
					if(a_zombies[i].health <= perk_dmg)
					{
						a_zombies[i] thread zm_perk_electric_cherry::electric_cherry_death_fx();
						if(isdefined(self.cherry_kills))
						{
							self.cherry_kills++;
						}
						self zm_score::add_to_player_score(40);
					}
					else if(!isdefined(a_zombies[i].is_mechz))
					{
						a_zombies[i] thread zm_perk_electric_cherry::electric_cherry_stun();
					}
					a_zombies[i] thread zm_perk_electric_cherry::electric_cherry_shock_fx();
					wait(0.1);
					if(isalive(a_zombies[i]))
					{
						a_zombies[i] DoDamage(perk_dmg, self.origin, self, self, "none");
					}
				}
			}
			self notify("electric_cherry_end");
		}
	}
}

/*
	Name: tomb_custom_player_track_ammo_count
	Namespace: zm_tomb
	Checksum: 0x12C46D
	Offset: 0x91D8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function tomb_custom_player_track_ammo_count()
{
	self notify("stop_ammo_tracking");
	self endon("disconnect");
	self endon("stop_ammo_tracking");
	ammoLowCount = 0;
	ammoOutCount = 0;
	while(1)
	{
		wait(0.5);
		weap = self GetCurrentWeapon();
		if(!isdefined(weap) || weap == level.weaponNone || !tomb_can_track_ammo_custom(weap))
		{
			continue;
		}
		if(self getammocount(weap) > 5 || self laststand::player_is_in_laststand())
		{
			ammoOutCount = 0;
			ammoLowCount = 0;
			continue;
		}
		if(self getammocount(weap) > 0)
		{
			if(ammoLowCount < 1)
			{
				self zm_audio::create_and_play_dialog("general", "ammo_low");
				ammoLowCount++;
			}
		}
		else if(ammoOutCount < 1)
		{
			self zm_audio::create_and_play_dialog("general", "ammo_out");
			ammoOutCount++;
		}
		wait(20);
	}
}

/*
	Name: tomb_can_track_ammo_custom
	Namespace: zm_tomb
	Checksum: 0x843D9B54
	Offset: 0x9390
	Size: 0x18D
	Parameters: 1
	Flags: None
*/
function tomb_can_track_ammo_custom(weap)
{
	if(!isdefined(weap))
	{
		return 0;
	}
	switch(weap.name)
	{
		case "death_throe":
		case "equip_dieseldrone":
		case "falling_hands_tomb":
		case "hero_annihilator":
		case "minigun":
		case "no_hands":
		case "none":
		case "one_inch_punch":
		case "one_inch_punch_air":
		case "one_inch_punch_fire":
		case "one_inch_punch_ice":
		case "one_inch_punch_lightning":
		case "one_inch_punch_upgraded":
		case "riotshield":
		case "staff_revive":
		case "zombie_bowie_flourish":
		case "zombie_builder":
		case "zombie_fists":
		case "zombie_knuckle_crack":
		case "zombie_one_inch_punch_flourish":
		case "zombie_one_inch_punch_upgrade_flourish":
		{
			return 0;
		}
		case default:
		{
			if(weap.isPerkBottle || zm_utility::is_placeable_mine(weap) || zm_equipment::is_equipment(weap) || IsSubStr(weap.name, "knife_ballistic_") || GetSubStr(weap.name, 0, 3) == "gl_")
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: function_89182d9b
	Namespace: zm_tomb
	Checksum: 0xF90FAE3B
	Offset: 0x9528
	Size: 0x27D
	Parameters: 0
	Flags: None
*/
function function_89182d9b()
{
	level.machine_assets["specialty_additionalprimaryweapon"].power_on_callback = &zm_tomb_capture_zones::custom_vending_power_on;
	level.machine_assets["specialty_additionalprimaryweapon"].power_off_callback = &zm_tomb_capture_zones::custom_vending_power_off;
	level.machine_assets["specialty_armorvest"].power_on_callback = &zm_tomb_capture_zones::custom_vending_power_on;
	level.machine_assets["specialty_armorvest"].power_off_callback = &zm_tomb_capture_zones::custom_vending_power_off;
	level.machine_assets["specialty_fastreload"].power_on_callback = &zm_tomb_capture_zones::custom_vending_power_on;
	level.machine_assets["specialty_fastreload"].power_off_callback = &zm_tomb_capture_zones::custom_vending_power_off;
	level.machine_assets["specialty_quickrevive"].power_on_callback = &zm_tomb_capture_zones::custom_vending_power_on;
	level.machine_assets["specialty_quickrevive"].power_off_callback = &zm_tomb_capture_zones::custom_vending_power_off;
	level.machine_assets["specialty_staminup"].power_on_callback = &zm_tomb_capture_zones::custom_vending_power_on;
	level.machine_assets["specialty_staminup"].power_off_callback = &zm_tomb_capture_zones::custom_vending_power_off;
	level flag::wait_till("start_zombie_round_logic");
	wait(0.5);
	foreach(var_3b5635b9 in level.powered_items)
	{
		if(var_3b5635b9.target.script_noteworthy != "pack_a_punch")
		{
			var_3b5635b9.power_on_func = &zm_tomb_capture_zones::custom_vending_power_on;
			var_3b5635b9.power_off_func = &zm_tomb_capture_zones::custom_vending_power_off;
		}
	}
}

/*
	Name: function_67268668
	Namespace: zm_tomb
	Checksum: 0x4EB0F63F
	Offset: 0x97B0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_67268668()
{
	level.machine_assets["specialty_quickrevive"].off_model = "p7_zm_ori_vending_revive";
	level.machine_assets["specialty_quickrevive"].on_model = "p7_zm_ori_vending_revive";
}

/*
	Name: init_sounds
	Namespace: zm_tomb
	Checksum: 0xDDD353E0
	Offset: 0x9808
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function init_sounds()
{
	level thread custom_add_vox();
	level thread zm_tomb_vo::init_level_specific_audio();
}

/*
	Name: setupMusic
	Namespace: zm_tomb
	Checksum: 0x9B29891C
	Offset: 0x9848
	Size: 0x7B3
	Parameters: 0
	Flags: None
*/
function setupMusic()
{
	zm_audio::musicState_Create("round_start", 3, "round_start_tomb_1", "round_start_tomb_2", "round_start_tomb_3", "round_start_tomb_4");
	zm_audio::musicState_Create("round_start_short", 3, "round_start_tomb_1", "round_start_tomb_2", "round_start_tomb_3", "round_start_tomb_4");
	zm_audio::musicState_Create("round_start_first", 3, "round_start_tomb_first");
	zm_audio::musicState_Create("round_end", 3, "round_end_tomb_1");
	zm_audio::musicState_Create("aether", 4, "aether");
	zm_audio::musicState_Create("archangel", 4, "archangel");
	zm_audio::musicState_Create("shepherd_of_fire", 4, "shepherd_of_fire");
	zm_audio::musicState_Create("sam", 4, "sam");
	zm_audio::musicState_Create("game_over", 5, "game_over_zhd_tomb");
	zm_audio::musicState_Create("round_start_recap", 3, "round_start_recap");
	zm_audio::musicState_Create("round_end_recap", 3, "round_end_recap");
	zm_audio::musicState_Create("zone_nml_18", 4, "location_hilltop");
	zm_audio::musicState_Create("zone_village_2", 4, "location_church");
	zm_audio::musicState_Create("ug_bottom_zone", 4, "location_crypt");
	zm_audio::musicState_Create("zone_robot_head", 4, "location_robot");
	zm_audio::musicState_Create("zone_air_stairs", 4, "location_cave_air");
	zm_audio::musicState_Create("zone_ice_stairs", 4, "location_cave_ice");
	zm_audio::musicState_Create("zone_bolt_stairs", 4, "location_cave_lightning");
	zm_audio::musicState_Create("zone_fire_stairs", 4, "location_cave_fire");
	zm_audio::musicState_Create("mus_event_first_door", 4, "location_firstdoor");
	zm_audio::musicState_Create("mus_event_second_door", 4, "location_seconddoor");
	zm_audio::musicState_Create("generator_1", 2, "event_generator_1");
	zm_audio::musicState_Create("generator_2", 2, "event_generator_2");
	zm_audio::musicState_Create("generator_3", 2, "event_generator_3");
	zm_audio::musicState_Create("generator_4", 2, "event_generator_4");
	zm_audio::musicState_Create("generator_5", 2, "event_generator_5");
	zm_audio::musicState_Create("generator_6", 2, "event_generator_6");
	zm_audio::musicState_Create("staff_air", 2, "staff_air");
	zm_audio::musicState_Create("staff_air_upgraded", 2, "staff_air_upg");
	zm_audio::musicState_Create("staff_fire", 2, "staff_fire");
	zm_audio::musicState_Create("staff_fire_upgraded", 2, "staff_fire_upg");
	zm_audio::musicState_Create("staff_ice", 2, "staff_ice");
	zm_audio::musicState_Create("staff_ice_upgraded", 2, "staff_ice_upg");
	zm_audio::musicState_Create("staff_lightning", 2, "staff_lightning");
	zm_audio::musicState_Create("staff_lightning_upgraded", 2, "staff_lightning_upg");
	zm_audio::musicState_Create("staff_all_upgraded", 2, "staff_all");
	zm_audio::musicState_Create("side_sting_1", 2, "side_sting_1");
	zm_audio::musicState_Create("side_sting_2", 2, "side_sting_2");
	zm_audio::musicState_Create("side_sting_3", 2, "side_sting_3");
	zm_audio::musicState_Create("side_sting_4", 2, "side_sting_4");
	zm_audio::musicState_Create("side_sting_5", 2, "side_sting_5");
	zm_audio::musicState_Create("side_sting_6", 2, "side_sting_6");
	zm_audio::musicState_Create("ee_main_1", 4, "ee_main_1");
	zm_audio::musicState_Create("ee_main_2", 4, "ee_main_2");
	zm_audio::musicState_Create("ee_main_3", 4, "ee_main_3");
	zm_audio::musicState_Create("ee_main_4", 4, "ee_main_4");
	zm_audio::musicState_Create("ee_main_5", 4, "ee_main_5");
	zm_audio::musicState_Create("ee_main_6", 4, "ee_main_6");
}

/*
	Name: player_out_of_playable_area_override
	Namespace: zm_tomb
	Checksum: 0x9DC29A8D
	Offset: 0xA008
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function player_out_of_playable_area_override()
{
	if(self clientfield::get_to_player("mechz_grab"))
	{
		return 0;
	}
	return 1;
}

