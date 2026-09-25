#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_ai_quad;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_auto_turret;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_remaster_zombie;
#using scripts\zm\zm_theater_achievements;
#using scripts\zm\zm_theater_amb;
#using scripts\zm\zm_theater_ffotd;
#using scripts\zm\zm_theater_fx;
#using scripts\zm\zm_theater_magic_box;
#using scripts\zm\zm_theater_movie_screen;
#using scripts\zm\zm_theater_quad;
#using scripts\zm\zm_theater_teleporter;
#using scripts\zm\zm_theater_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace namespace_aed37ba8;

/*
	Name: opt_in
	Namespace: namespace_aed37ba8
	Checksum: 0x4930BDC2
	Offset: 0x13D0
	Size: 0x27
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.pack_a_punch_camo_index = 132;
}

/*
	Name: main
	Namespace: namespace_aed37ba8
	Checksum: 0xB87B9925
	Offset: 0x1400
	Size: 0x5B3
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_16a77fe2::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	namespace_265ae7e9::main();
	init_clientfields();
	zm::init_fx();
	level.zombiemode = 1;
	level.sndZHDAudio = 1;
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	visionset_mgr::register_info("visionset", "flare", 21000, 15, 1, 1);
	visionset_mgr::register_info("visionset", "cheat_bw_contrast", 21000, 16, 1, 1);
	visionset_mgr::register_info("visionset", "cheat_bw_invert_contrast", 21000, 17, 1, 1);
	visionset_mgr::register_info("visionset", "zombie_turned", 21000, 18, 1, 1);
	level.precacheCustomCharacters = &precacheCustomCharacters;
	level.giveCustomCharacters = &giveCustomCharacters;
	initCharacterStartIndex();
	level._round_start_func = &zm::round_start;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	include_perks_in_random_rotation();
	load::main();
	namespace_6d4f3e39::main();
	level.default_laststandpistol = GetWeapon("pistol_m1911");
	level.default_solo_laststandpistol = GetWeapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	level.var_9aaae7ae = &function_869d6f66;
	level.var_9cef605e = &function_823705c7;
	if(GetDvarInt("artist") > 0)
	{
		return;
	}
	level.dogs_enabled = 1;
	level.random_pandora_box_start = 1;
	level.quad_move_speed = 35;
	level.quad_traverse_death_fx = &namespace_1e94246a::quad_traverse_death_fx;
	level.quad_explode = 1;
	level.custom_ai_type = [];
	level.door_dialog_function = &zm::play_door_dialog;
	level._allow_melee_weapon_switching = 1;
	_zm_weap_cymbal_monkey::init();
	zm_ai_dogs::enable_dog_rounds();
	level.zombie_init_done = &function_ec7faaac;
	init_zombie_theater();
	compass::setupMiniMap("menu_map_zombie_theater");
	level.ignore_spawner_func = &theater_ignore_spawner;
	level.player_out_of_playable_area_monitor_callback = &function_d1ca1764;
	level.zones = [];
	level.zone_manager_init_func = &theater_zone_init;
	init_zones[0] = "foyer_zone";
	init_zones[1] = "foyer2_zone";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.zombie_ai_limit = 24;
	SetDvar("hkai_pathfindIterationLimit", 1200);
	level.extracam_screen = GetEnt("movie_screen_model", "script_noteworthy");
	util::clientNotify("camera_stop");
	init_sounds();
	setupMusic();
	level thread add_powerups_after_round_1();
	level thread function_6452fa9d();
	/#
		function_27cb39f1();
	#/
	chandelier = GetEntArray("theater_chandelier", "targetname");
	Array::thread_all(chandelier, &theater_chandelier_model_scale);
	level thread namespace_8847920b::teleport_pad_hide_use();
	level thread zm_perks::spare_change();
	scene::add_scene_func("cin_zmhd_sizzle_theater_cam", &function_8d0bd61d, "play");
	namespace_16a77fe2::main_end();
}

/*
	Name: function_8d0bd61d
	Namespace: namespace_aed37ba8
	Checksum: 0x552CC4A2
	Offset: 0x19C0
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function function_8d0bd61d(a_ents)
{
	level.disable_print3d_ent = 1;
	exploder::kill_exploder("teleporter_light_red");
	exploder::exploder("fxexp_200");
	exploder::exploder("teleporter_light_green");
	foreach(var_6cae1ad0 in a_ents)
	{
		if(IsSubStr(var_6cae1ad0.model, "body"))
		{
			var_6cae1ad0 clientfield::set("zombie_has_eyes", 1);
		}
	}
	level waittill("hash_1a22222d");
	exploder::kill_exploder("teleporter_light_green");
	exploder::exploder("teleporter_light_red");
	exploder::kill_exploder("fxexp_200");
	level clientfield::increment("teleporter_initiate_fx");
}

/*
	Name: init_clientfields
	Namespace: namespace_aed37ba8
	Checksum: 0xACF489A3
	Offset: 0x1B60
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	clientfield::register("world", "zm_theater_screen_in_place", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int");
	clientfield::register("world", "zm_theater_movie_reel_playing", 21000, 2, "int");
	zm_sidequests::register_sidequest_icon("movieReel", 21000);
}

/*
	Name: function_ec7faaac
	Namespace: namespace_aed37ba8
	Checksum: 0x3A18AF7A
	Offset: 0x1C50
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_ec7faaac()
{
	self.allowPain = 0;
}

/*
	Name: function_869d6f66
	Namespace: namespace_aed37ba8
	Checksum: 0x9C118035
	Offset: 0x1C68
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_869d6f66()
{
	if(!isdefined(self namespace_93b7f03::function_728dfe3()))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_823705c7
	Namespace: namespace_aed37ba8
	Checksum: 0x50477AD2
	Offset: 0x1C98
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function function_823705c7()
{
	if(isdefined(self.is_teleporting) && self.is_teleporting)
	{
		return 0;
	}
	var_7d7ca0ea = GetEnt("trigger_teleport_pad_0", "targetname");
	if(self istouching(var_7d7ca0ea))
	{
		return 0;
	}
	if(isdefined(self.var_35c3d096) && self.var_35c3d096)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_6452fa9d
	Namespace: namespace_aed37ba8
	Checksum: 0x58D9C7C5
	Offset: 0x1D30
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_6452fa9d()
{
	var_174ba740 = GetEnt("use_elec_switch", "targetname");
	var_cf413835 = struct::get("power_switch", "targetname");
	var_174ba740 setcursorhint("HINT_NOICON");
	var_174ba740 waittill("trigger", User);
	playsoundatposition("zmb_switch_flip", var_cf413835.origin);
	playFX(level._effect["switch_sparks"], struct::get("elec_switch_fx", "script_noteworthy").origin);
	var_cf413835 scene::Play("p7_fxanim_zmhd_power_switch_bundle");
}

/*
	Name: function_d1ca1764
	Namespace: namespace_aed37ba8
	Checksum: 0xF707A806
	Offset: 0x1E60
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_d1ca1764()
{
	var_7fed53df = 1;
	if(isdefined(self.is_teleporting) && self.is_teleporting == 1)
	{
		var_7fed53df = 0;
	}
	return var_7fed53df;
}

/*
	Name: precacheCustomCharacters
	Namespace: namespace_aed37ba8
	Checksum: 0x99EC1590
	Offset: 0x1EA8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precacheCustomCharacters()
{
}

/*
	Name: initCharacterStartIndex
	Namespace: namespace_aed37ba8
	Checksum: 0xA1396B2C
	Offset: 0x1EB8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function initCharacterStartIndex()
{
	level.characterStartIndex = RandomInt(4);
}

/*
	Name: selectCharacterIndexToUse
	Namespace: namespace_aed37ba8
	Checksum: 0xED3B6B
	Offset: 0x1EE8
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function selectCharacterIndexToUse()
{
	if(level.characterStartIndex >= 4)
	{
		level.characterStartIndex = 0;
	}
	self.characterindex = level.characterStartIndex;
	level.characterStartIndex++;
	return self.characterindex;
}

/*
	Name: giveCustomCharacters
	Namespace: namespace_aed37ba8
	Checksum: 0x8B58EDF0
	Offset: 0x1F30
	Size: 0x303
	Parameters: 0
	Flags: None
*/
function giveCustomCharacters()
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
			self.characterindex = Int(GetDvarString("Dev Block strings are not supported"));
		}
	#/
	self SetCharacterBodyType(self.characterindex);
	self SetCharacterBodyStyle(0);
	self SetCharacterHelmetStyle(0);
	switch(self.characterindex)
	{
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("bouncingbetty");
			self.characterindex = 0;
			break;
		}
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("870mcs");
			self.characterindex = 1;
			break;
		}
		case 2:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("hk416");
			self.characterindex = 2;
			break;
		}
		case 3:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndRadioA = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("pistol_standard");
			self.characterindex = 3;
			break;
		}
	}
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
	self thread namespace_52adc03e::set_exert_id();
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: namespace_aed37ba8
	Checksum: 0xA3AFDC9C
	Offset: 0x2240
	Size: 0x15B
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
	players = level.players;
	if(players.size == 1)
	{
		charindexarray = Array::randomize(charindexarray);
		return charindexarray[0];
	}
	else
	{
		foreach(player in players)
		{
			if(isdefined(player.characterindex))
			{
				ArrayRemoveValue(charindexarray, player.characterindex, 0);
			}
		}
		if(charindexarray.size > 0)
		{
			return charindexarray[0];
		}
	}
	return 0;
}

/*
	Name: offhand_weapon_overrride
	Namespace: namespace_aed37ba8
	Checksum: 0xF4AE0892
	Offset: 0x23A8
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = GetWeapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey_upgraded");
	zm_utility::register_melee_weapon_for_level(level.weaponBaseMelee.name);
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: function_ce6ee03b
	Namespace: namespace_aed37ba8
	Checksum: 0xC2C93E0D
	Offset: 0x2470
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_ce6ee03b()
{
	scene::add_scene_func("p7_fxanim_zm_kino_curtains_stage_main_bundle", &function_9a38ad2c, "play");
	var_5be55f14 = GetEnt("theater_curtains", "targetname");
	var_5be55f14 thread scene::Play("p7_fxanim_zm_kino_curtains_stage_main_bundle", var_5be55f14);
	playsoundatposition("evt_curtain_open", var_5be55f14.origin);
}

/*
	Name: function_9a38ad2c
	Namespace: namespace_aed37ba8
	Checksum: 0xDA371CB3
	Offset: 0x2528
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_9a38ad2c(a_ents)
{
	var_115bc805 = a_ents["main_stage_curtains"];
	var_115bc805 connectpaths();
}

/*
	Name: custom_add_weapons
	Namespace: namespace_aed37ba8
	Checksum: 0xFE162E6
	Offset: 0x2570
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_theater_weapons.csv", 1);
}

/*
	Name: custom_add_vox
	Namespace: namespace_aed37ba8
	Checksum: 0x157CCA68
	Offset: 0x25A0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_theater_vox.csv");
	level thread init_level_specific_audio();
}

/*
	Name: add_powerups_after_round_1
	Namespace: namespace_aed37ba8
	Checksum: 0xB651750C
	Offset: 0x25E0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function add_powerups_after_round_1()
{
	ArrayRemoveValue(level.zombie_powerup_array, "nuke", 0);
	ArrayRemoveValue(level.zombie_powerup_array, "fire_sale", 0);
	while(1)
	{
		if(level.round_number > 1)
		{
			if(!isdefined(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = [];
			}
			else if(!IsArray(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = Array(level.zombie_powerup_array);
			}
			level.zombie_powerup_array[level.zombie_powerup_array.size] = "nuke";
			if(!isdefined(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = [];
			}
			else if(!IsArray(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = Array(level.zombie_powerup_array);
			}
			level.zombie_powerup_array[level.zombie_powerup_array.size] = "fire_sale";
			break;
		}
		wait(1);
	}
}

/*
	Name: init_zombie_theater
	Namespace: namespace_aed37ba8
	Checksum: 0xCAE9A78D
	Offset: 0x2738
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function init_zombie_theater()
{
	level flag::init("curtains_done");
	level flag::init("lobby_occupied");
	level flag::init("dining_occupied");
	level flag::init("special_quad_round");
	level thread electric_switch();
	level namespace_5daad52::magic_box_init();
	level thread namespace_39123edc::initMovieScreen();
	thread namespace_1e94246a::init_roofs();
	level thread teleporter_intro();
}

/*
	Name: teleporter_intro
	Namespace: namespace_aed37ba8
	Checksum: 0xDBC59519
	Offset: 0x2838
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function teleporter_intro()
{
	level flag::wait_till("initial_players_connected");
	wait(0.25);
	playsoundatposition("evt_beam_fx_2d", (0, 0, 0));
	playsoundatposition("evt_pad_cooldown_2d", (0, 0, 0));
}

/*
	Name: electric_switch
	Namespace: namespace_aed37ba8
	Checksum: 0x1922A6C2
	Offset: 0x28B0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function electric_switch()
{
	level thread wait_for_power();
}

/*
	Name: wait_for_power
	Namespace: namespace_aed37ba8
	Checksum: 0x3E2A2C55
	Offset: 0x28D8
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function wait_for_power()
{
	level flag::wait_till("power_on");
	util::clientNotify("ZPO");
	level clientfield::set("zombie_power_on", 1);
	exploder::exploder("lgt_exploder_power_on");
	exploder::exploder("lgt_exploder_teleporter_on");
	exploder::exploder("lgt_exploder_projector_on");
	exploder::exploder("lgt_exploder_ceiling_holes");
	namespace_8847920b::teleporter_init();
	players = level.players;
	level.quads_per_round = 4 * players.size;
	level notify("quad_round_can_end");
	level.delay_spawners = undefined;
	level thread quad_wave_init();
}

/*
	Name: init_sounds
	Namespace: namespace_aed37ba8
	Checksum: 0xF2FF2842
	Offset: 0x2A00
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function init_sounds()
{
	zm_utility::add_sound("zmb_wooden_door", "zmb_door_wood_open");
	zm_utility::add_sound("zmb_fence_door", "zmb_door_fence_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
	level thread custom_add_vox();
	level.audio_get_mod_type = &function_642e6aef;
	level.vox_response_override = 1;
}

/*
	Name: setupMusic
	Namespace: namespace_aed37ba8
	Checksum: 0xB2481FB2
	Offset: 0x2AA8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function setupMusic()
{
	zm_audio::musicState_Create("round_start", 3, "round_start_theater_1", "round_start_theater_2");
	zm_audio::musicState_Create("round_start_short", 3, "round_start_theater_1", "round_start_theater_2");
	zm_audio::musicState_Create("round_start_first", 3, "round_start_theater_1", "round_start_theater_2");
	zm_audio::musicState_Create("round_end", 3, "round_end_theater_1");
	zm_audio::musicState_Create("dog_start", 3, "dog_start_1");
	zm_audio::musicState_Create("dog_end", 3, "dog_end_1");
	zm_audio::musicState_Create("115", 4, "115");
	zm_audio::musicState_Create("game_over", 5, "game_over_zhd_theater");
	zm_audio::musicState_Create("none", 4, "none");
	zm_audio::musicState_Create("sam", 4, "sam");
}

/*
	Name: theater_zone_init
	Namespace: namespace_aed37ba8
	Checksum: 0xB5C0EC21
	Offset: 0x2C60
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function theater_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("foyer_zone", "foyer2_zone", "always_on");
	zm_zonemgr::add_adjacent_zone("foyer_zone", "vip_zone", "magic_box_foyer1");
	zm_zonemgr::add_adjacent_zone("foyer2_zone", "crematorium_zone", "magic_box_crematorium1");
	zm_zonemgr::add_adjacent_zone("foyer_zone", "crematorium_zone", "magic_box_crematorium1");
	zm_zonemgr::add_adjacent_zone("vip_zone", "dining_zone", "vip_to_dining");
	zm_zonemgr::add_adjacent_zone("crematorium_zone", "alleyway_zone", "magic_box_alleyway1");
	zm_zonemgr::add_adjacent_zone("dining_zone", "dressing_zone", "dining_to_dressing");
	zm_zonemgr::add_adjacent_zone("dressing_zone", "stage_zone", "magic_box_dressing1");
	zm_zonemgr::add_adjacent_zone("stage_zone", "west_balcony_zone", "magic_box_west_balcony2");
	zm_zonemgr::add_adjacent_zone("theater_zone", "foyer2_zone", "power_on");
	zm_zonemgr::add_adjacent_zone("theater_zone", "stage_zone", "power_on");
	zm_zonemgr::add_adjacent_zone("west_balcony_zone", "alleyway_zone", "magic_box_west_balcony1");
}

/*
	Name: theater_ignore_spawner
	Namespace: namespace_aed37ba8
	Checksum: 0x7CF5B9C9
	Offset: 0x2E90
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function theater_ignore_spawner(spawner)
{
	if(!level flag::get("curtains_done"))
	{
		if(spawner.script_noteworthy == "quad_zombie_spawner")
		{
			return 1;
		}
	}
	if(level flag::get("special_quad_round"))
	{
		if(spawner.script_noteworthy != "quad_zombie_spawner")
		{
			return 1;
		}
	}
	if(!level flag::get("lobby_occupied"))
	{
		if(spawner.script_noteworthy == "quad_zombie_spawner" && spawner.targetname == "foyer_zone_spawners")
		{
			return 1;
		}
	}
	if(!level flag::get("dining_occupied"))
	{
		if(spawner.script_noteworthy == "quad_zombie_spawner" && spawner.targetname == "zombie_spawner_dining")
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: quad_wave_init
	Namespace: namespace_aed37ba8
	Checksum: 0x2F9D48DB
	Offset: 0x2FE0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function quad_wave_init()
{
	level thread time_for_quad_wave("foyer_zone");
	level thread time_for_quad_wave("theater_zone");
	level thread time_for_quad_wave("stage_zone");
	level thread time_for_quad_wave("dining_zone");
	level waittill("end_of_round");
	level flag::clear("special_quad_round");
}

/*
	Name: time_for_quad_wave
	Namespace: namespace_aed37ba8
	Checksum: 0xFE502DDD
	Offset: 0x3098
	Size: 0x2AB
	Parameters: 1
	Flags: None
*/
function time_for_quad_wave(zone_name)
{
	if(!isdefined(zone_name))
	{
		return;
	}
	zone = level.zones[zone_name];
	level waittill("between_round_over");
	if(level.next_dog_round === level.round_number)
	{
		level thread time_for_quad_wave(zone_name);
		return;
	}
	max = level.zombie_vars["zombie_max_ai"];
	multiplier = level.round_number / 5;
	if(multiplier < 1)
	{
		multiplier = 1;
	}
	if(level.round_number >= 10)
	{
		multiplier = multiplier * level.round_number * 0.15;
	}
	player_num = level.players.size;
	if(player_num == 1)
	{
		max = max + Int(0.5 * level.zombie_vars["zombie_ai_per_player"] * multiplier);
	}
	else
	{
		max = max + Int(player_num - 1 * level.zombie_vars["zombie_ai_per_player"] * multiplier);
	}
	chance = 100;
	max_zombies = [[level.max_zombie_func]](max, level.round_number);
	current_round = level.round_number;
	if(level.round_number % 3 == 0 && chance >= RandomInt(100))
	{
		if(zone.is_occupied)
		{
			level flag::set("special_quad_round");
			while(level.zombie_total < max_zombies / 2 && current_round == level.round_number)
			{
				wait(0.1);
			}
			level flag::clear("special_quad_round");
		}
	}
	level thread time_for_quad_wave(zone_name);
}

/*
	Name: theater_chandelier_model_scale
	Namespace: namespace_aed37ba8
	Checksum: 0xE574029A
	Offset: 0x3350
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function theater_chandelier_model_scale()
{
	level flag::wait_till("power_on");
	if(self.model == "zombie_theater_chandelier1arm_off")
	{
		self SetModel("zombie_theater_chandelier1arm_on");
	}
	else if(self.model == "zombie_theater_chandelier1_off")
	{
		self SetModel("zombie_theater_chandelier1_on");
	}
}

/*
	Name: function_27cb39f1
	Namespace: namespace_aed37ba8
	Checksum: 0x9D448B91
	Offset: 0x33E8
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function function_27cb39f1()
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
		all_nodes = GetAllNodes();
		for(i = 0; i < all_nodes.size; i++)
		{
			node = all_nodes[i];
			if(node.type == "Dev Block strings are not supported")
			{
				node thread debug_display();
			}
		}
	#/
}

/*
	Name: debug_display
	Namespace: namespace_aed37ba8
	Checksum: 0x2859DD00
	Offset: 0x34B0
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function debug_display()
{
	/#
		while(1)
		{
			print3d(self.origin, self.animscript, (1, 0, 0), 1, 0.2, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: init_level_specific_audio
	Namespace: namespace_aed37ba8
	Checksum: 0xD3AA1EA1
	Offset: 0x3508
	Size: 0x34B
	Parameters: 0
	Flags: None
*/
function init_level_specific_audio()
{
	level.vox zm_audio::zmbVoxAdd("general", "door_deny", "nomoney", 100, 0);
	level.vox zm_audio::zmbVoxAdd("general", "perk_deny", "nomoney", 100, 0);
	level.vox zm_audio::zmbVoxAdd("general", "no_money_weapon", "nomoney", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "room_screen", "egg_room_screen", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "room_dress", "egg_room_dress", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "room_lounge", "egg_room_lounge", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "room_rest", "egg_room_rest", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "room_alley", "egg_room_alley", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "portrait_dempsey", "egg_port_dempsey", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "portrait_nikolai", "egg_port_nikolai", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "portrait_takeo", "egg_port_takeo", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "portrait_richtofan", "egg_port_richtofan", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "portrait_empty", "egg_port_empty", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "meteors", "egg_pedastool", 100, 0);
	level.vox zm_audio::zmbVoxAdd("eggs", "music_activate", "secret", 100, 0);
}

/*
	Name: function_642e6aef
	Namespace: namespace_aed37ba8
	Checksum: 0xC1C76D52
	Offset: 0x3860
	Size: 0x3DD
	Parameters: 7
	Flags: None
*/
function function_642e6aef(impact, mod, weapon, zombie, instakill, dist, player)
{
	var_adac242b = 4096;
	var_2c1bd1bd = 15376;
	var_af03c4a6 = 160000;
	if(zombie.damageWeapon.name == "sticky_grenade_widows_wine")
	{
		return "default";
	}
	if(zm_utility::is_placeable_mine(weapon))
	{
		if(!instakill)
		{
			return "betty";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(zombie.archetype == "zombie_quad")
	{
		return "quad";
	}
	if(zombie.damageWeapon.name == "cymbal_monkey")
	{
		if(instakill)
		{
			return "weapon_instakill";
		}
		else
		{
			return "monkey";
		}
	}
	if(zombie.damageWeapon.name == "ray_gun" || zombie.damageWeapon.name == "ray_gun_upgraded" && dist > var_af03c4a6)
	{
		if(!instakill)
		{
			return "raygun";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(zm_utility::is_headshot(weapon, impact, mod) && dist >= var_af03c4a6)
	{
		return "headshot";
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < var_adac242b)
	{
		if(!instakill)
		{
			return "melee";
		}
		else
		{
			return "melee_instakill";
		}
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && weapon.name != "ray_gun_upgraded" && (!isdefined(zombie.is_on_fire) && zombie.is_on_fire))
	{
		if(!instakill)
		{
			return "explosive";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(weapon.doesFireDamage && (mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH"))
	{
		if(!instakill)
		{
			return "flame";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(!isdefined(impact))
	{
		impact = "";
	}
	if(mod != "MOD_MELEE" && zombie.missingLegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < var_adac242b)
	{
		return "close";
	}
	if(mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
	{
		if(!instakill)
		{
			return "bullet";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(instakill)
	{
		return "default";
	}
	return "default";
}

/*
	Name: include_perks_in_random_rotation
	Namespace: namespace_aed37ba8
	Checksum: 0x5287A3F0
	Offset: 0x3C48
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function include_perks_in_random_rotation()
{
	zm_perk_random::include_perk_in_random_rotation("specialty_staminup");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
	level.custom_random_perk_weights = &function_c027d01d;
}

/*
	Name: function_c027d01d
	Namespace: namespace_aed37ba8
	Checksum: 0xE25DA84C
	Offset: 0x3CB8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_c027d01d()
{
	temp_array = [];
	temp_array = Array::randomize(temp_array);
	level._random_perk_machine_perk_list = Array::randomize(level._random_perk_machine_perk_list);
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = getArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}

