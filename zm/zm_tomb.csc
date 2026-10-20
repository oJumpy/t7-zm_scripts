#using scripts\codescripts\struct;
#using scripts\shared\ai\mechz;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_callbacks;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_ai_mechz_claw;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch;
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
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerup_zombie_blood;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_beacon;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\_zm_weap_staff_air;
#using scripts\zm\_zm_weap_staff_fire;
#using scripts\zm\_zm_weap_staff_lightning;
#using scripts\zm\_zm_weap_staff_water;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\zm_challenges_tomb;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_ambient_scripts;
#using scripts\zm\zm_tomb_capture_zones;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_craftables;
#using scripts\zm\zm_tomb_dig;
#using scripts\zm\zm_tomb_ee;
#using scripts\zm\zm_tomb_ffotd;
#using scripts\zm\zm_tomb_fx;
#using scripts\zm\zm_tomb_giant_robot;
#using scripts\zm\zm_tomb_magicbox;
#using scripts\zm\zm_tomb_mech;
#using scripts\zm\zm_tomb_quest_fire;
#using scripts\zm\zm_tomb_tank;
#using scripts\zm\zm_tomb_teleporter;

#namespace zm_tomb;

/*
	Name: opt_in
	Namespace: zm_tomb
	Checksum: 0x170EB750
	Offset: 0x1E90
	Size: 0x1B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_tomb
	Checksum: 0xB99A7C37
	Offset: 0x1EB8
	Size: 0xB33
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread zm_tomb_ffotd::main_start();
	clientfield::register("scriptmover", "glow_biplane_trail_fx", 21000, 1, "int", &glow_biplane_trail_fx, 0, 0);
	clientfield::register("scriptmover", "element_glow_fx", 21000, 4, "int", &crystal_fx, 0, 0);
	clientfield::register("scriptmover", "bryce_cake", 21000, 2, "int", &init_central_crypt_disc, 0, 0);
	clientfield::register("scriptmover", "switch_spark", 21000, 1, "int", &switch_spark_fx, 0, 0);
	clientfield::register("scriptmover", "plane_fx", 21000, 1, "int", &function_ae268bd3, 0, 0);
	clientfield::register("world", "cooldown_steam", 21000, 2, "int", &switch_cooldown_fx, 0, 0);
	clientfield::register("scriptmover", "teleporter_fx", 21000, 1, "int", &zm_tomb_teleporter::teleporter_fx_play, 0, 0);
	n_bits = GetMinBitCountForNum(6);
	clientfield::register("toplayer", "player_rumble_and_shake", 21000, n_bits, "int", &player_rumble_and_shake, 0, 0);
	clientfield::register("scriptmover", "stone_frozen", 21000, 1, "int", &stone_frozen_shader, 0, 0);
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("world", "rain_level", 21000, n_bits, "int", &set_level_rain, 0, 0);
	clientfield::register("world", "snow_level", 21000, n_bits, "int", &set_level_snow, 0, 0);
	clientfield::register("toplayer", "player_weather_visionset", 21000, 2, "int", &set_player_weather_visionset, 0, 0);
	clientfield::register("scriptmover", "sky_pillar", 21000, 1, "int", &sky_pillar_fx, 0, 0);
	clientfield::register("scriptmover", "staff_charger", 21000, 3, "int", &staff_charger_init, 0, 0);
	clientfield::register("toplayer", "player_staff_charge", 21000, 2, "int", &player_staff_charge_level, 0, 0);
	clientfield::register("toplayer", "player_tablet_state", 21000, 2, "int", &zm_utility::setInventoryUIModels, 0, 1);
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("actor", "zombie_soul", 21000, n_bits, "int", &zombie_soul_fx, 0, 0);
	clientfield::register("zbarrier", "magicbox_runes", 21000, 1, "int", &magicbox_shader_cb, 0, 0);
	clientfield::register("actor", "foot_print_box_fx", 21000, 1, "int", &foot_print_box_fx, 0, 0);
	clientfield::register("scriptmover", "foot_print_box_glow", 21000, 1, "int", &foot_print_box_glow, 0, 0);
	clientfield::register("world", "crypt_open_exploder", 21000, 1, "int", &crypt_open, 0, 0);
	clientfield::register("world", "lantern_fx", 21000, 1, "int", &toggle_lantern_fx, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "sndMudSlow", 21000, 1, "int", &zm_tomb_amb::sndmudslow, 0, 0);
	clientfield::register("world", "mus_zmb_egg_snapshot_loop", 21000, 1, "int", &zm_tomb_amb::audio_snapshot_clientfield_callback, 1, 0);
	clientfield::register("toplayer", "sndMaelstrom", 21000, 1, "int", &zm_tomb_amb::sndmaelstrom, 0, 0);
	clientfield::register("actor", "crusader_emissive_fx", 21000, 1, "int", &crusader_emissive_fx, 0, 0);
	clientfield::register("actor", "zombie_instant_explode", 21000, 1, "int", &zombie_instant_explode_cb, 0, 1);
	level.default_start_location = "tomb";
	level.default_game_mode = "zclassic";
	level._no_water_risers = 1;
	level.eyeball_luminance_override = 3;
	level.zombie_eyes_clientfield_cb_additional = &zm_tomb_zombie_eyes_think;
	level._uses_sticky_grenades = 1;
	level.disable_fx_zmb_wall_buy_semtex = 1;
	level._uses_taser_knuckles = 0;
	level._wallbuy_override_num_bits = 1;
	level.setupCustomCharacterExerts = &setup_personality_character_exerts;
	level._no_equipment_activated_clientfield = 1;
	level._no_navcards = 1;
	level.weather_rain = 0;
	level.weather_snow = 0;
	level.weather_fog = 0;
	_zm_weap_one_inch_punch::init();
	zm_tomb_quest_fire::main();
	zm_tomb_tank::init();
	zm_tomb_giant_robot::init();
	start_zombie_stuff();
	zm_tomb_dig::init();
	namespace_baebcb1::init();
	zm_tomb_fx::main();
	namespace_711a44f0::init();
	zm_tomb_teleporter::init();
	level thread zm_tomb_ambient_scripts::main();
	level._entityspawned_override = &entityspawned_tomb;
	zm_tomb_craftables::include_craftables();
	zm_tomb_craftables::init_craftables();
	zm_tomb_capture_zones::init_structs();
	level thread zm_tomb_amb::main();
	load::main();
	level.n_level_sunlight = GetDvarFloat("r_lightTweakSunLight");
	util::waitforclient(0);
	level thread zm_tomb_fx::setup_prop_anims();
	level thread init_fog_vol_to_visionset();
	level thread zm_tomb_capture_zones::init_custom_pap();
	level.sndNoMeleeOnClient = 1;
	SetDvar("bg_chargeShotExponentialAmmoPerChargeLevel", 1);
	level thread zm_tomb_ffotd::main_end();
}

/*
	Name: start_zombie_stuff
	Namespace: zm_tomb
	Checksum: 0xF9074194
	Offset: 0x29F8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function start_zombie_stuff()
{
	level.raygun2_included = 1;
	include_weapons();
	include_equipment_for_level();
	_zm_weap_beacon::init();
	_zm_weap_cymbal_monkey::init();
	zm_tomb_teleporter::main();
	visionset_mgr::register_overlay_info_style_burn("zm_transit_burn", 21000, 15, 2);
}

/*
	Name: include_equipment_for_level
	Namespace: zm_tomb
	Checksum: 0xAB5988AE
	Offset: 0x2A90
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function include_equipment_for_level()
{
	zm_equipment::Include("equip_dieseldrone");
	zm_equipment::Include("tomb_shield");
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_tomb
	Checksum: 0x810B159D
	Offset: 0x2AD0
	Size: 0x1481
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[1]["playerbreathinsound"][1] = "vox_plr_0_exert_inhale_1";
	level.exert_sounds[1]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale_2";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][1] = "vox_plr_1_exert_inhale_1";
	level.exert_sounds[2]["playerbreathinsound"][2] = "vox_plr_1_exert_inhale_2";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][1] = "vox_plr_2_exert_inhale_1";
	level.exert_sounds[3]["playerbreathinsound"][2] = "vox_plr_2_exert_inhale_2";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][1] = "vox_plr_3_exert_inhale_1";
	level.exert_sounds[4]["playerbreathinsound"][2] = "vox_plr_3_exert_inhale_2";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathoutsound"][2] = "vox_plr_0_exert_exhale_2";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathoutsound"][2] = "vox_plr_1_exert_exhale_2";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathoutsound"][2] = "vox_plr_2_exert_exhale_2";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathoutsound"][2] = "vox_plr_3_exert_exhale_2";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathgaspsound"][2] = "vox_plr_0_exert_exhale_2";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathgaspsound"][2] = "vox_plr_1_exert_exhale_2";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathgaspsound"][2] = "vox_plr_2_exert_exhale_2";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathgaspsound"][2] = "vox_plr_3_exert_exhale_2";
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
	level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
	level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
	level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
	level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
	level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
	level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
	level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
	level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
	level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
	level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
	level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
	level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
	level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
	level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
	level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
	level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
	level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
	level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
	level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
	level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
	level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
	level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
	level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
	level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
	level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
	level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
	level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
	level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
	level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
	level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
	level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
	level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
	level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
	level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
	level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
	level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
	level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
	level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
	level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
	level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
	level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
	level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
	level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
	level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
	level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
	level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
	level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
	level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_6";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_knife_swipe_5";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_knife_swipe_5";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_knife_swipe_5";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][5] = "vox_plr_3_exert_knife_swipe_5";
	level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
	level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
	level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
	level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}

/*
	Name: init_fog_vol_to_visionset
	Namespace: zm_tomb
	Checksum: 0x954C4FFD
	Offset: 0x3F60
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function init_fog_vol_to_visionset()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zm_tomb", 1);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zm_tomb");
	level thread visionset_mgr::fog_vol_to_visionset_monitor();
}

/*
	Name: init_clientflag_variables
	Namespace: zm_tomb
	Checksum: 0x99EC1590
	Offset: 0x3FE0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_clientflag_variables()
{
}

/*
	Name: register_clientflag_callbacks
	Namespace: zm_tomb
	Checksum: 0x99EC1590
	Offset: 0x3FF0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function register_clientflag_callbacks()
{
}

/*
	Name: include_weapons
	Namespace: zm_tomb
	Checksum: 0x8091FA0F
	Offset: 0x4000
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_tomb_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: entityspawned_tomb
	Namespace: zm_tomb
	Checksum: 0x61C7CBA4
	Offset: 0x4040
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function entityspawned_tomb(localClientNum)
{
	if(!isdefined(self.type))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	if(self.type == "player")
	{
		self thread callback::playerspawned(localClientNum);
	}
	else if(self.type == "vehicle")
	{
		if(self.vehicleType === "heli_quadrotor_zm" || self.vehicleType === "heli_quadrotor_upgraded_zm")
		{
			self thread function_b14689f(localClientNum);
		}
	}
	else if(self.type == "actor")
	{
		if(isdefined(level._customActorCBFunc))
		{
			self thread [[level._customActorCBFunc]](localClientNum);
		}
	}
}

/*
	Name: function_b14689f
	Namespace: zm_tomb
	Checksum: 0x687DB595
	Offset: 0x4140
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_b14689f(localClientNum)
{
	self util::waittill_dobj(localClientNum);
	level thread zm_tomb_amb::init();
	self thread zm_tomb_amb::start_helicopter_sounds();
}

/*
	Name: player_staff_charge_rumble
	Namespace: zm_tomb
	Checksum: 0x92355B63
	Offset: 0x41A0
	Size: 0x87
	Parameters: 2
	Flags: None
*/
function player_staff_charge_rumble(localClientNum, str_rumble)
{
	self endon("stop_charge_rumble");
	self endon("disconnect");
	delta_time = 0.1;
	n_max_time = 10;
	while(isdefined(self))
	{
		self PlayRumbleOnEntity(localClientNum, str_rumble);
		wait(0.1);
	}
}

/*
	Name: player_staff_charge_level
	Namespace: zm_tomb
	Checksum: 0x4CF35DA1
	Offset: 0x4230
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function player_staff_charge_level(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self notify("stop_charge_rumble");
	str_rumble = undefined;
	switch(newVal)
	{
		case 1:
		{
			str_rumble = "reload_small";
			break;
		}
		case 2:
		{
			str_rumble = "damage_light";
			break;
		}
		case 3:
		{
			str_rumble = "damage_heavy";
			break;
		}
		case default:
		{
			break;
		}
	}
	if(isdefined(str_rumble))
	{
		self thread player_staff_charge_rumble(localClientNum, str_rumble);
	}
}

/*
	Name: staff_charger_init
	Namespace: zm_tomb
	Checksum: 0x33332CC3
	Offset: 0x4328
	Size: 0x15D
	Parameters: 7
	Flags: None
*/
function staff_charger_init(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(level.charger_origins))
	{
		level.charger_origins = [];
	}
	if(newVal != 0)
	{
		level.charger_origins[newVal] = self.origin;
		break;
	}
	keys = getArrayKeys(level.charger_origins);
	foreach(i in keys)
	{
		if(!isdefined(level.charger_origins[i]))
		{
			continue;
		}
		if(DistanceSquared(level.charger_origins[i], self.origin) < 100)
		{
			level.charger_origins[i] = undefined;
		}
	}
}

/*
	Name: zombie_soul_fx
	Namespace: zm_tomb
	Checksum: 0x654FAF55
	Offset: 0x4490
	Size: 0x28B
	Parameters: 7
	Flags: None
*/
function zombie_soul_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	v_origin = self GetTagOrigin("J_SpineUpper");
	v_dest = undefined;
	if(!isdefined(level.charger_origins))
	{
		level.charger_origins = [];
	}
	if(isdefined(level.charger_origins[newVal]))
	{
		v_dest = level.charger_origins[newVal];
	}
	if(!isdefined(v_dest) || !isdefined(v_origin))
	{
		return;
	}
	if(isdefined(self))
	{
		v_origin = self GetTagOrigin("J_SpineUpper");
	}
	e_fx = spawn(localClientNum, v_origin, "script_model");
	e_fx SetModel("tag_origin");
	e_fx playsound(localClientNum, "zmb_squest_charge_soul_leave");
	e_fx PlayLoopSound("zmb_squest_charge_soul_lp");
	PlayFXOnTag(localClientNum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(v_dest + VectorScale((0, 0, 1), 5), 0.5);
	e_fx waittill("movedone");
	e_fx playsound(localClientNum, "zmb_squest_charge_soul_impact");
	PlayFXOnTag(localClientNum, level._effect["staff_charge"], e_fx, "tag_origin");
	util::server_wait(localClientNum, 0.3);
	e_fx delete();
}

/*
	Name: magicbox_shader_cb
	Namespace: zm_tomb
	Checksum: 0xE266AF9D
	Offset: 0x4728
	Size: 0x1C5
	Parameters: 7
	Flags: None
*/
function magicbox_shader_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	n_pieces = self GetNumZBarrierPieces();
	if(!isdefined(self.mapped_const))
	{
		for(i = 0; i < n_pieces; i++)
		{
			e_piece = self ZBarrierGetPiece(i);
			e_piece MapShaderConstant(localClientNum, 1, "ScriptVector0");
		}
		self.mapped_const = 1;
	}
	if(newVal)
	{
		for(i = 0; i < n_pieces; i++)
		{
			e_piece = self ZBarrierGetPiece(i);
			e_piece SetShaderConstant(localClientNum, 1, 0, 1, 0, 0);
		}
		break;
	}
	for(i = 0; i < n_pieces; i++)
	{
		e_piece = self ZBarrierGetPiece(i);
		e_piece SetShaderConstant(localClientNum, 1, 0, 0, 0, 0);
	}
}

/*
	Name: angle_dif
	Namespace: zm_tomb
	Checksum: 0x386A5018
	Offset: 0x48F8
	Size: 0x75
	Parameters: 2
	Flags: None
*/
function angle_dif(oldangle, newangle)
{
	outvalue = oldangle - newangle % 360;
	if(outvalue < 0)
	{
		outvalue = outvalue + 360;
	}
	if(outvalue > 180)
	{
		outvalue = outvalue - 360 * -1;
	}
	return outvalue;
}

/*
	Name: get_disc_color
	Namespace: zm_tomb
	Checksum: 0x3484E440
	Offset: 0x4978
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function get_disc_color()
{
	for(i = 0; i < 5; i++)
	{
		if(!isdefined(level.element_rotations[i]))
		{
			continue;
		}
		n_rotation = Int(level.element_rotations[i]);
		n_target = Int(self.angles[1]);
		diff = Abs(angle_dif(n_target, n_rotation));
		if(diff <= 45)
		{
			return i;
		}
	}
	return 0;
}

/*
	Name: central_crypt_disc_update_color
	Namespace: zm_tomb
	Checksum: 0xA3A07C8
	Offset: 0x4A70
	Size: 0x2D7
	Parameters: 2
	Flags: None
*/
function central_crypt_disc_update_color(localClientNum, light_on)
{
	if(!isdefined(level.element_rotations))
	{
		level.element_rotations = [];
		level.element_rotations[2] = 270;
		level.element_rotations[1] = 180;
		level.element_rotations[3] = 90;
		level.element_rotations[4] = 0;
	}
	if(!isdefined(level.element_colors))
	{
		level.element_colors = [];
		level.element_colors[0] = -1;
		level.element_colors[2] = 2;
		level.element_colors[1] = 3;
		level.element_colors[3] = 0;
		level.element_colors[4] = 1;
		level.element_colors[5] = 4;
	}
	var_477f7b08 = self get_disc_color();
	v_color = level.element_colors[var_477f7b08];
	n_brightness = 0.1;
	if(isdefined(level.light_on_color) && light_on)
	{
		var_904d8a16 = level clientfield::get("light_show");
		switch(var_904d8a16)
		{
			case 1:
			{
				var_477f7b08 = 0;
				break;
			}
			case 2:
			{
				var_477f7b08 = 1;
				break;
			}
			case 3:
			{
				var_477f7b08 = 5;
				break;
			}
			case default:
			{
				var_477f7b08 = 0;
				break;
			}
		}
		n_brightness = n_brightness * 10;
	}
	else if(isdefined(level.light_off_color) && !light_on)
	{
		var_477f7b08 = 0;
		n_brightness = 0;
	}
	else if(light_on)
	{
		n_brightness = n_brightness * 10;
	}
	playsound(0, "zmb_crypt_disc_light", self.origin);
	n_test = self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_brightness, level.element_colors[var_477f7b08], 0);
}

/*
	Name: init_central_crypt_disc
	Namespace: zm_tomb
	Checksum: 0xFCD857D8
	Offset: 0x4D50
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function init_central_crypt_disc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 2)
	{
		self thread central_crypt_disc_update_color(localClientNum, 1);
	}
	else
	{
		self thread central_crypt_disc_update_color(localClientNum, 0);
	}
}

/*
	Name: switch_spark_fx
	Namespace: zm_tomb
	Checksum: 0x266ED6FE
	Offset: 0x4DE0
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function switch_spark_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(isdefined(self.spark_fx))
	{
		stopfx(localClientNum, self.spark_fx);
		self.spark_fx = undefined;
	}
	if(newVal)
	{
		self.spark_fx = PlayFXOnTag(localClientNum, level._effect["fx_tomb_sparks"], self, "lever_jnt");
	}
}

/*
	Name: function_ae268bd3
	Namespace: zm_tomb
	Checksum: 0xD33EC512
	Offset: 0x4E98
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_ae268bd3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self.fx_element_glow = PlayFXOnTag(localClientNum, level._effect["biplane_glow"], self, "tag_origin");
	}
	else if(isdefined(self.fx_element_glow))
	{
		stopfx(localClientNum, self.fx_element_glow);
	}
}

/*
	Name: switch_cooldown_fx
	Namespace: zm_tomb
	Checksum: 0xBB2912BC
	Offset: 0x4F50
	Size: 0x11B
	Parameters: 7
	Flags: None
*/
function switch_cooldown_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level notify("stop_cooldown_fx");
	if(newVal == 1)
	{
		cooldown_struct = struct::get("cooldown_steam_1", "targetname");
	}
	else if(newVal == 2)
	{
		cooldown_struct = struct::get("cooldown_steam_2", "targetname");
	}
	else if(newVal == 3)
	{
		cooldown_struct = struct::get("cooldown_steam_3", "targetname");
	}
	if(isdefined(cooldown_struct))
	{
		cooldown_struct thread loop_cooldown_fx(localClientNum);
	}
}

/*
	Name: loop_cooldown_fx
	Namespace: zm_tomb
	Checksum: 0xCA755F68
	Offset: 0x5078
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function loop_cooldown_fx(localClientNum)
{
	level endon("stop_cooldown_fx");
	while(1)
	{
		playFX(localClientNum, level._effect["cooldown_steam"], self.origin);
		wait(0.1);
	}
}

/*
	Name: teleporter_fx
	Namespace: zm_tomb
	Checksum: 0x1DA026FD
	Offset: 0x50D8
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function teleporter_fx(localClientNum, enum)
{
	str_fx = "teleport_air";
	switch(enum)
	{
		case 1:
		{
			str_fx = "teleport_fire";
			break;
		}
		case 4:
		{
			str_fx = "teleport_ice";
			break;
		}
		case 3:
		{
			str_fx = "teleport_elec";
			break;
		}
		case 2:
		case default:
		{
			str_fx = "teleport_air";
			break;
		}
	}
	self.fx_element_glow = PlayFXOnTag(localClientNum, level._effect[str_fx], self, "tag_origin");
	SetFXIgnorePause(localClientNum, self.fx_element_glow, 1);
}

/*
	Name: glow_biplane_trail_fx
	Namespace: zm_tomb
	Checksum: 0x829B6C6B
	Offset: 0x51D8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function glow_biplane_trail_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["glow_biplane_trail_fx"], self, "tag_origin");
	}
}

/*
	Name: crystal_fx
	Namespace: zm_tomb
	Checksum: 0x8C3E277
	Offset: 0x5258
	Size: 0x24B
	Parameters: 7
	Flags: None
*/
function crystal_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal >= 5)
	{
		element_enum = newVal - 4;
		teleporter_fx(localClientNum, element_enum);
		return;
	}
	if(newVal == 1)
	{
		self.fx_element_glow = PlayFXOnTag(localClientNum, level._effect["fire_glow"], self, "tag_origin");
		SetFXIgnorePause(localClientNum, self.fx_element_glow, 1);
	}
	else if(newVal == 2)
	{
		self.fx_element_glow = PlayFXOnTag(localClientNum, level._effect["air_glow"], self, "tag_origin");
		SetFXIgnorePause(localClientNum, self.fx_element_glow, 1);
	}
	else if(newVal == 3)
	{
		self.fx_element_glow = PlayFXOnTag(localClientNum, level._effect["elec_glow"], self, "tag_origin");
		SetFXIgnorePause(localClientNum, self.fx_element_glow, 1);
	}
	else if(newVal == 4)
	{
		self.fx_element_glow = PlayFXOnTag(localClientNum, level._effect["ice_glow"], self, "tag_origin");
		SetFXIgnorePause(localClientNum, self.fx_element_glow, 1);
	}
	else if(newVal == 0)
	{
		stopfx(localClientNum, self.fx_element_glow);
	}
}

/*
	Name: stone_frozen_shader
	Namespace: zm_tomb
	Checksum: 0x963CADC4
	Offset: 0x54B0
	Size: 0xF1
	Parameters: 7
	Flags: None
*/
function stone_frozen_shader(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		self MapShaderConstant(localClientNum, 0, "ScriptVector3");
		for(f = 0; f <= 1;  = 0)
		{
			self SetShaderConstant(localClientNum, 0, f, f, f, f);
			util::server_wait(localClientNum, 0.0166);
		}
	}
}

/*
	Name: sky_pillar_fade
	Namespace: zm_tomb
	Checksum: 0x8EA6C2E
	Offset: 0x55B0
	Size: 0x1CD
	Parameters: 3
	Flags: None
*/
function sky_pillar_fade(localClientNum, fade_in, fade_time)
{
	self notify("sky_pillar_fade_stop");
	self endon("sky_pillar_fade_stop");
	self endon("entityshutdown");
	start_val = 0;
	end_val = 1;
	if(fade_in)
	{
		start_val = 1;
		end_val = 0;
	}
	frame_time = 0.0166;
	num_steps = Int(fade_time / frame_time);
	step_size = 1 / num_steps;
	for(i = 0; i < num_steps; i++)
	{
		pct = step_size * i;
		if(pct < 0)
		{
			pct = 0;
		}
		else if(pct > 1)
		{
			pct = 1;
		}
		value = LerpFloat(start_val, end_val, pct);
		self SetShaderConstant(localClientNum, 0, value, value, value, value);
		util::server_wait(localClientNum, frame_time);
	}
}

/*
	Name: sky_pillar_fx
	Namespace: zm_tomb
	Checksum: 0x7D6FD5AE
	Offset: 0x5788
	Size: 0x1EB
	Parameters: 7
	Flags: None
*/
function sky_pillar_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNum, 0, "ScriptVector0");
		self thread sky_pillar_fade(localClientNum, 1, 1);
		playsound(0, "zmb_squest_crystal_sky_pillar_start", (3, 0, 218));
		audio::playloopat("zmb_squest_crystal_sky_pillar_loop", (0, -2, 435));
		audio::playloopat("zmb_squest_crystal_sky_pillar_loop_fx", VectorScale((0, 0, 1), 150));
		/#
			println("Dev Block strings are not supported");
		#/
	}
	else
	{
		self thread sky_pillar_fade(localClientNum, 0, 4);
		playsound(0, "zmb_squest_crystal_sky_pillar_stop", (3, 0, 218));
		audio::stoploopat("zmb_squest_crystal_sky_pillar_loop", (0, -2, 435));
		audio::stoploopat("zmb_squest_crystal_sky_pillar_loop_fx", VectorScale((0, 0, 1), 150));
		/#
			println("Dev Block strings are not supported");
		#/
	}
}

/*
	Name: player_rumble_and_shake
	Namespace: zm_tomb
	Checksum: 0x7230F1B6
	Offset: 0x5980
	Size: 0x205
	Parameters: 7
	Flags: None
*/
function player_rumble_and_shake(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("disconnect");
	if(newVal == 4)
	{
		self thread player_continuous_rumble(localClientNum, 1);
	}
	else if(newVal == 5)
	{
		self thread player_continuous_rumble(localClientNum, 2);
	}
	else if(newVal == 3)
	{
		self Earthquake(0.6, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
	}
	else if(newVal == 2)
	{
		self Earthquake(0.3, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "shotgun_fire");
	}
	else if(newVal == 1)
	{
		self Earthquake(0.1, 1, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "damage_heavy");
	}
	else if(newVal == 6)
	{
		self thread player_continuous_rumble(localClientNum, 1, 0);
	}
	else
	{
		self notify("stop_rumble_and_shake");
	}
}

/*
	Name: player_continuous_rumble
	Namespace: zm_tomb
	Checksum: 0xE7266FB
	Offset: 0x5B90
	Size: 0x15F
	Parameters: 3
	Flags: None
*/
function player_continuous_rumble(localClientNum, rumble_level, shake_camera)
{
	if(!isdefined(shake_camera))
	{
		shake_camera = 1;
	}
	self notify("stop_rumble_and_shake");
	self endon("disconnect");
	self endon("stop_rumble_and_shake");
	while(1)
	{
		if(isdefined(self) && self isLocalPlayer() && isdefined(self))
		{
			if(rumble_level == 1)
			{
				if(shake_camera)
				{
					self Earthquake(0.2, 1, self.origin, 100);
				}
				self PlayRumbleOnEntity(localClientNum, "reload_small");
				wait(0.05);
			}
			else if(shake_camera)
			{
				self Earthquake(0.3, 1, self.origin, 100);
			}
			self PlayRumbleOnEntity(localClientNum, "damage_light");
		}
		wait(0.1);
	}
}

/*
	Name: crypt_open
	Namespace: zm_tomb
	Checksum: 0x113B4F07
	Offset: 0x5CF8
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function crypt_open(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	exploder::exploder(222);
}

/*
	Name: toggle_lantern_fx
	Namespace: zm_tomb
	Checksum: 0x8C2F72B8
	Offset: 0x5D58
	Size: 0x2B9
	Parameters: 7
	Flags: None
*/
function toggle_lantern_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	a_lantern_names = Array("phys_lantern01", "phys_lantern02", "phys_lantern03", "phys_lantern04", "phys_lantern05", "phys_lantern06", "phys_lantern07", "phys_lantern08", "phys_lantern09", "phys_lantern10", "phys_lantern11", "phys_lantern12", "phys_lantern13", "phys_lantern14", "phys_lantern15", "phys_lantern16", "phys_lantern17", "phys_lantern18", "phys_lantern19");
	a_lanterns = [];
	foreach(str_name in a_lantern_names)
	{
		a_lanterns = ArrayCombine(a_lanterns, getdynentarray(str_name), 0, 0);
	}
	if(newVal)
	{
		foreach(lantern in a_lanterns)
		{
			lantern lantern_fx_enable(localClientNum);
		}
		break;
	}
	foreach(lantern in a_lanterns)
	{
		lantern lantern_fx_disable(localClientNum);
	}
}

/*
	Name: lantern_fx_enable
	Namespace: zm_tomb
	Checksum: 0x22D00797
	Offset: 0x6020
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function lantern_fx_enable(localClientNumber)
{
	self lantern_fx_disable(localClientNumber);
	self.a_fx[localClientNumber] = PlayFXOnDynEnt(level._effect["fx_tomb_light_expensive"], self);
}

/*
	Name: lantern_fx_disable
	Namespace: zm_tomb
	Checksum: 0x5EEB385E
	Offset: 0x6088
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function lantern_fx_disable(localClientNumber)
{
	if(!isdefined(self.a_fx))
	{
		self.a_fx = [];
	}
	if(isdefined(self.a_fx[localClientNumber]))
	{
		deletefx(localClientNumber, self.a_fx[localClientNumber], 1);
	}
}

/*
	Name: set_level_rain
	Namespace: zm_tomb
	Checksum: 0x98E8F10
	Offset: 0x60F0
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function set_level_rain(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.weather_rain = newVal;
}

/*
	Name: set_level_snow
	Namespace: zm_tomb
	Checksum: 0xFE6C8A97
	Offset: 0x6140
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function set_level_snow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.weather_snow = newVal;
}

/*
	Name: set_player_snow
	Namespace: zm_tomb
	Checksum: 0x89A6B808
	Offset: 0x6190
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function set_player_snow(localClientNum)
{
	if(!isdefined(level.sndweather))
	{
		level thread zm_tomb_amb::sndweathersetup();
	}
	if(level.weather_snow == 0)
	{
		level notify("_snow_thread" + localClientNum);
		level.sndweather.issnow = 0;
	}
	else
	{
		self thread _snow_thread(level.weather_snow, localClientNum);
		level.sndweather.issnow = 1;
	}
	level thread sndweatherupdate(self);
}

/*
	Name: set_player_rain
	Namespace: zm_tomb
	Checksum: 0x453E4B00
	Offset: 0x6248
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function set_player_rain(localClientNum)
{
	if(!isdefined(level.sndweather))
	{
		level thread zm_tomb_amb::sndweathersetup();
	}
	if(!isdefined(self.b_lightning))
	{
		self.b_lightning = 0;
	}
	if(level.weather_rain == 0)
	{
		level notify("_rain_thread" + localClientNum);
		self.b_lightning = 0;
		level.sndweather.israin = 0;
	}
	else if(isdefined(self.b_lightning) && !self.b_lightning)
	{
		self thread _lightning_thread(localClientNum);
	}
	self thread _rain_thread(level.weather_rain, localClientNum);
	level.sndweather.israin = 1;
	level thread sndweatherupdate(self);
}

/*
	Name: set_player_weather_visionset
	Namespace: zm_tomb
	Checksum: 0xC7080D4C
	Offset: 0x6358
	Size: 0x2AB
	Parameters: 7
	Flags: None
*/
function set_player_weather_visionset(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	n_suncolor_lerp_time = 10;
	if(bNewEnt || bInitialSnap || bWasDemoJump)
	{
		n_suncolor_lerp_time = 0;
	}
	if(isdefined(self))
	{
		self set_player_rain(localClientNum);
		self set_player_snow(localClientNum);
	}
	if(newVal == 0 || newVal == 3)
	{
		function_b5ac96ec("clear", localClientNum);
		SetLitFogBank(localClientNum, -1, 0, -1);
		if(GetDvarInt("splitscreen_playerCount") > 2)
		{
			SetWorldFogActiveBank(localClientNum, 9);
		}
		else
		{
			SetWorldFogActiveBank(localClientNum, 1);
		}
	}
	else if(newVal == 1)
	{
		function_b5ac96ec("rain", localClientNum);
		SetLitFogBank(localClientNum, -1, 2, -1);
		if(GetDvarInt("splitscreen_playerCount") > 2)
		{
			SetWorldFogActiveBank(localClientNum, 12);
		}
		else
		{
			SetWorldFogActiveBank(localClientNum, 4);
		}
	}
	else if(newVal == 2)
	{
		function_b5ac96ec("snow", localClientNum);
		SetLitFogBank(localClientNum, -1, 1, -1);
		if(GetDvarInt("splitscreen_playerCount") > 2)
		{
			SetWorldFogActiveBank(localClientNum, 10);
		}
		else
		{
			SetWorldFogActiveBank(localClientNum, 2);
		}
	}
}

/*
	Name: function_b5ac96ec
	Namespace: zm_tomb
	Checksum: 0x44223C9A
	Offset: 0x6610
	Size: 0x109
	Parameters: 2
	Flags: None
*/
function function_b5ac96ec(str_weather, localClientNum)
{
	exploder::stop_exploder("fxexp_111", localClientNum);
	exploder::stop_exploder("fxexp_112", localClientNum);
	exploder::stop_exploder("fxexp_113", localClientNum);
	switch(str_weather)
	{
		case "clear":
		{
			exploder::exploder("fxexp_111", localClientNum);
			break;
		}
		case "rain":
		{
			exploder::exploder("fxexp_112", localClientNum);
			break;
		}
		case "snow":
		{
			exploder::exploder("fxexp_113", localClientNum);
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: lerp_suncolor_dvar
	Namespace: zm_tomb
	Checksum: 0xDA1AAEE5
	Offset: 0x6728
	Size: 0x23
	Parameters: 4
	Flags: None
*/
function lerp_suncolor_dvar(localClientNum, src_suncolor, tgt_suncolor, n_lerp_time)
{
}

/*
	Name: sndweatherupdate
	Namespace: zm_tomb
	Checksum: 0x10230E36
	Offset: 0x6758
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function sndweatherupdate(player)
{
	level notify("sndweatherupdating");
	level endon("sndweatherupdating");
	wait(0.5);
	level notify("sndweatherupdate");
	player thread sndupdateroomweather();
}

/*
	Name: sndupdateroomweather
	Namespace: zm_tomb
	Checksum: 0x1979B466
	Offset: 0x67B8
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function sndupdateroomweather()
{
	wait(0.1);
	name = level.activeAmbientPackage;
}

/*
	Name: _rain_thread
	Namespace: zm_tomb
	Checksum: 0x95B258B4
	Offset: 0x6810
	Size: 0x125
	Parameters: 2
	Flags: None
*/
function _rain_thread(n_level, localClientNum)
{
	level notify("_rain_thread" + localClientNum);
	level notify("_rain_begin" + localClientNum);
	level endon("_snow_begin" + localClientNum);
	level endon("_rain_thread" + localClientNum);
	self endon("disconnect");
	self endon("entityshutdown");
	n_wait = 0.35 / n_level;
	if(n_wait < 0.15)
	{
		n_wait = 0.15;
	}
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		var_f0b23899 = function_508af4e9(localClientNum);
		playFX(localClientNum, level._effect["player_rain"], var_f0b23899[0], var_f0b23899[1]);
		wait(n_wait);
	}
}

/*
	Name: _snow_thread
	Namespace: zm_tomb
	Checksum: 0xF757B3B4
	Offset: 0x6940
	Size: 0x125
	Parameters: 2
	Flags: None
*/
function _snow_thread(n_level, localClientNum)
{
	level notify("_snow_thread" + localClientNum);
	level notify("_snow_begin" + localClientNum);
	level endon("_rain_begin" + localClientNum);
	level endon("_snow_thread" + localClientNum);
	self endon("disconnect");
	self endon("entityshutdown");
	n_wait = 0.5 / n_level;
	self.b_lightning = 0;
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(level.localPlayers[localClientNum]))
		{
			return;
		}
		var_f0b23899 = function_508af4e9(localClientNum);
		playFX(localClientNum, level._effect["player_snow"], var_f0b23899[0], var_f0b23899[1]);
		wait(n_wait);
	}
}

/*
	Name: _lightning_thread
	Namespace: zm_tomb
	Checksum: 0x4C387AD
	Offset: 0x6A70
	Size: 0x2EF
	Parameters: 1
	Flags: None
*/
function _lightning_thread(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	self.b_lightning = 1;
	if(localClientNum != 0)
	{
		return;
	}
	level notify("_lightning_thread" + localClientNum);
	level endon("_lightning_thread" + localClientNum);
	if(isdefined(localClientNum))
	{
		self util::waittill_dobj(localClientNum);
		while(isdefined(self.b_lightning) && self.b_lightning)
		{
			v_p_angles = self.angles;
			v_forward = AnglesToForward(self.angles) * 25000;
			v_end_pos = self.origin + (v_forward[0], v_forward[1], 0);
			v_offset = (randomIntRange(-5000, 5000), randomIntRange(-5000, 5000), RandomInt(3000));
			v_end_pos = v_end_pos + v_offset;
			exploder::exploder("fxexp_400");
			playsound(0, "amb_thunder_clap_zm", v_end_pos);
			util::server_wait(localClientNum, RandomFloatRange(0.2, 0.3));
			self thread _lightning_disconnect_thread(localClientNum);
			n_strikes = randomIntRange(3, 5);
			for(i = 0; i < n_strikes; i++)
			{
				util::server_wait(localClientNum, 0.1);
				n_blend_time = RandomFloatRange(0.1, 0.35);
				playsound(0, "amb_thunder_flash_zm", v_end_pos);
			}
			self notify("lightning_done");
			util::server_wait(localClientNum, RandomFloatRange(5, 10));
		}
	}
}

/*
	Name: function_508af4e9
	Namespace: zm_tomb
	Checksum: 0x8CE465DF
	Offset: 0x6D68
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function function_508af4e9(localClientNum)
{
	var_bbb1872c = GetLocalClientEyePos(localClientNum);
	var_4bde0ff5 = GetLocalClientAngles(localClientNum);
	var_4bde0ff5 = AnglesToForward(var_4bde0ff5);
	var_4bde0ff5 = (var_4bde0ff5[0], var_4bde0ff5[1], 0);
	if(var_4bde0ff5[0] == 0 && var_4bde0ff5[1] == 0)
	{
		if(RandomInt(1) == 0)
		{
			var_4bde0ff5 = VectorScale((1, 1, 0), 0.01);
		}
		else
		{
			var_4bde0ff5 = VectorScale((-1, -1, 0), 0.01);
		}
	}
	var_f0b23899 = [];
	var_f0b23899[0] = var_bbb1872c;
	var_f0b23899[1] = var_4bde0ff5;
	return var_f0b23899;
}

/*
	Name: _lightning_disconnect_thread
	Namespace: zm_tomb
	Checksum: 0x58C0165B
	Offset: 0x6E90
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function _lightning_disconnect_thread(localClientNum)
{
	self endon("lightning_done");
	self waittill("_lightning_thread" + localClientNum);
}

/*
	Name: lerp_dvar
	Namespace: zm_tomb
	Checksum: 0xC0C90FD0
	Offset: 0x6EC8
	Size: 0x163
	Parameters: 5
	Flags: None
*/
function lerp_dvar(str_dvar, n_val, n_lerp_time, b_saved_dvar, localClientNum)
{
	n_start_val = GetDvarFloat(str_dvar);
	n_time_delta = 0;
	do
	{
		util::server_wait(localClientNum, 0.05);
		n_time_delta = n_time_delta + 0.05;
		n_curr_val = LerpFloat(n_start_val, n_val, n_time_delta / n_lerp_time);
		if(isdefined(b_saved_dvar) && b_saved_dvar)
		{
			SetSavedDvar(str_dvar, n_curr_val);
		}
		else
		{
			SetDvar(str_dvar, n_curr_val);
		}
	}
	while(!n_time_delta < n_lerp_time);
	if(isdefined(b_saved_dvar) && b_saved_dvar)
	{
		SetSavedDvar(str_dvar, n_val);
	}
	else
	{
		SetDvar(str_dvar, n_val);
	}
}

/*
	Name: foot_print_box_fx
	Namespace: zm_tomb
	Checksum: 0x3569F3E8
	Offset: 0x7038
	Size: 0x21B
	Parameters: 7
	Flags: None
*/
function foot_print_box_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	a_structs = struct::get_array("foot_box_pos", "targetname");
	s_box = ArrayGetClosest(self.origin, a_structs);
	e_fx = spawn(localClientNum, self GetTagOrigin("J_SpineUpper"), "script_model");
	e_fx SetModel("tag_origin");
	e_fx playsound(localClientNum, "zmb_squest_charge_soul_leave");
	e_fx PlayLoopSound("zmb_squest_charge_soul_lp");
	PlayFXOnTag(localClientNum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(s_box.origin, 1);
	e_fx waittill("movedone");
	playsound(localClientNum, "zmb_squest_charge_soul_impact", e_fx.origin);
	PlayFXOnTag(localClientNum, level._effect["staff_charge"], e_fx, "tag_origin");
	wait(0.3);
	e_fx delete();
}

/*
	Name: foot_print_box_glow
	Namespace: zm_tomb
	Checksum: 0xE3443A39
	Offset: 0x7260
	Size: 0x1BD
	Parameters: 7
	Flags: None
*/
function foot_print_box_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self util::waittill_dobj(localClientNum);
	if(newVal == 1)
	{
		if(!isdefined(self.fx_glow))
		{
			self.fx_glow = PlayFXOnTag(localClientNum, level._effect["foot_box_glow"], self, "tag_origin");
			self thread foot_print_box_glow_in(localClientNum);
		}
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent PlayLoopSound("zmb_footprintbox_glow_lp", 1);
			self.sndent thread snddemojumpmonitor();
		}
	}
	else if(isdefined(self.fx_glow))
	{
		stopfx(localClientNum, self.fx_glow);
		self.fx_glow = undefined;
		self thread foot_print_box_glow_out(localClientNum);
	}
	if(isdefined(self.sndent))
	{
		self.sndent delete();
		self.sndent = undefined;
	}
}

/*
	Name: snddemojumpmonitor
	Namespace: zm_tomb
	Checksum: 0x4C5C73F1
	Offset: 0x7428
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function snddemojumpmonitor()
{
	self endon("entityshutdown");
	level waittill("demo_jump");
	self delete();
}

/*
	Name: foot_print_box_glow_in
	Namespace: zm_tomb
	Checksum: 0x3DCE0B30
	Offset: 0x7468
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function foot_print_box_glow_in(localClientNum)
{
	self endon("entityshutdown");
	self MapShaderConstant(localClientNum, 0, "ScriptVector1");
	s_timer = new_timer(localClientNum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localClientNum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat(1, 0, n_current_time / n_phase_in);
		self SetShaderConstant(localClientNum, 0, n_delta_val, 0, 0, 0);
	}
	while(!n_current_time < n_phase_in);
}

/*
	Name: foot_print_box_glow_out
	Namespace: zm_tomb
	Checksum: 0x952B828A
	Offset: 0x7580
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function foot_print_box_glow_out(localClientNum)
{
	self endon("entityshutdown");
	self MapShaderConstant(localClientNum, 0, "ScriptVector1");
	s_timer = new_timer(localClientNum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localClientNum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat(0, 1, n_current_time / n_phase_in);
		self SetShaderConstant(localClientNum, 0, n_delta_val, 0, 0, 0);
	}
	while(!n_current_time < n_phase_in);
}

/*
	Name: timer_increment_loop
	Namespace: zm_tomb
	Checksum: 0x1ADD694A
	Offset: 0x7698
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function timer_increment_loop(localClientNum)
{
	while(isdefined(self))
	{
		util::server_wait(localClientNum, 0.016);
		self.n_time_current = self.n_time_current + 0.016;
	}
}

/*
	Name: new_timer
	Namespace: zm_tomb
	Checksum: 0x394A2F
	Offset: 0x76F0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function new_timer(localClientNum)
{
	s_timer = spawnstruct();
	s_timer.n_time_current = 0;
	s_timer thread timer_increment_loop(localClientNum);
	return s_timer;
}

/*
	Name: get_time
	Namespace: zm_tomb
	Checksum: 0x26F72387
	Offset: 0x7750
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function get_time()
{
	return self.n_time_current * 1000;
}

/*
	Name: get_time_in_seconds
	Namespace: zm_tomb
	Checksum: 0x93FF51EC
	Offset: 0x7768
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_time_in_seconds()
{
	return self.n_time_current;
}

/*
	Name: reset_timer
	Namespace: zm_tomb
	Checksum: 0xE3DB4217
	Offset: 0x7780
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

/*
	Name: crusader_emissive_fx
	Namespace: zm_tomb
	Checksum: 0x2DBD555D
	Offset: 0x7798
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function crusader_emissive_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: zombie_instant_explode_cb
	Namespace: zm_tomb
	Checksum: 0x20D5F734
	Offset: 0x7848
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function zombie_instant_explode_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		where = self GetTagOrigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
		{
			playFX(localClientNum, level._effect["zombie_guts_explosion"], where);
		}
	}
}

/*
	Name: zm_tomb_zombie_eyes_think
	Namespace: zm_tomb
	Checksum: 0x5A927049
	Offset: 0x7938
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function zm_tomb_zombie_eyes_think(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		if(isdefined(self) && isdefined(self._aitype) && self._aitype == "zm_tomb_basic_crusader")
		{
			self._eyeglow_fx_override = level._effect["eye_glow_blue"];
			self zm::deleteZombieEyes(localClientNum);
			self zm::createZombieEyes(localClientNum);
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, level.eyeball_luminance_override, 0);
		}
	}
}

