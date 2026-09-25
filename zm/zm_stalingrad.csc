#using scripts\codescripts\struct;
#using scripts\shared\ai\raz;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_sentinel_drone;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_elemental_zombies;
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
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_dragon_gauntlet;
#using scripts\zm\_zm_weap_dragon_scale_shield;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weap_raygun_mark3;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_siegebot_nikolai;
#using scripts\zm\zm_stalingrad_amb;
#using scripts\zm\zm_stalingrad_ambient;
#using scripts\zm\zm_stalingrad_audio;
#using scripts\zm\zm_stalingrad_challenges;
#using scripts\zm\zm_stalingrad_craftables;
#using scripts\zm\zm_stalingrad_dragon;
#using scripts\zm\zm_stalingrad_dragon_strike;
#using scripts\zm\zm_stalingrad_ee_main;
#using scripts\zm\zm_stalingrad_eye_beam_trap;
#using scripts\zm\zm_stalingrad_ffotd;
#using scripts\zm\zm_stalingrad_fx;
#using scripts\zm\zm_stalingrad_mounted_mg;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_timer;
#using scripts\zm\zm_stalingrad_wearables;

#namespace namespace_320a344e;

/*
	Name: opt_in
	Namespace: namespace_320a344e
	Checksum: 0x6F6F64C6
	Offset: 0x1B98
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
	Name: init_gamemodes
	Namespace: namespace_320a344e
	Checksum: 0x99EC1590
	Offset: 0x1BC0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_gamemodes()
{
}

/*
	Name: main
	Namespace: namespace_320a344e
	Checksum: 0x31D930
	Offset: 0x1BD0
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function main()
{
	scene::add_scene_func("p7_fxanim_gp_tracer_fire_01_bundle", &function_1c53c4e1);
	namespace_15d4d4c0::main_start();
	level.debug_keyline_zombies = 0;
	level.setupCustomCharacterExerts = &setup_personality_character_exerts;
	level._effect["eye_glow"] = "dlc3/stalingrad/fx_glow_eye_red_stal";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	dragon::init_clientfields();
	register_clientfields();
	namespace_f058d6e4::include_craftables();
	namespace_f058d6e4::init_craftables();
	namespace_23c72813::function_ad78a144();
	include_weapons();
	load::main();
	namespace_c49c3ddb::init();
	init_gamemodes();
	level thread function_3a429aee();
	thread namespace_db83306f::main();
	util::waitforclient(0);
	namespace_15d4d4c0::main_end();
	level thread function_38b57afd();
}

/*
	Name: function_1c53c4e1
	Namespace: namespace_320a344e
	Checksum: 0x6DF4BF3E
	Offset: 0x1DF0
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function function_1c53c4e1(a_ents)
{
	level endon("zesn");
	while(1)
	{
		while(!isdefined(level.localPlayers[0]) || !IsIGCActive(level.localPlayers[0].localClientNum))
		{
			wait(1);
		}
		self scene::stop(1);
		while(IsIGCActive(level.localPlayers[0].localClientNum))
		{
			wait(1);
		}
		self scene::Play();
	}
}

/*
	Name: register_clientfields
	Namespace: namespace_320a344e
	Checksum: 0x8B40FD1F
	Offset: 0x1EC0
	Size: 0x6A3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_dragon_strike", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_cylinder", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.piece_cylinder", 12000, 2, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_egg", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.piece_egg", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.progress_egg", 12000, 4, "float", undefined, 0, 0);
	clientfield::register("actor", "drop_pod_score_beam_fx", 12000, 1, "counter", &namespace_b57650e4::function_c86c0cdd, 0, 0);
	clientfield::register("scriptmover", "drop_pod_active", 12000, 1, "int", &namespace_b57650e4::function_5858bdaf, 0, 0);
	clientfield::register("scriptmover", "drop_pod_hp_light", 12000, 2, "int", &namespace_b57650e4::function_5e369bd2, 0, 0);
	clientfield::register("world", "drop_pod_streaming", 12000, 1, "int", &namespace_b57650e4::function_7a72544b, 0, 0);
	clientfield::register("toplayer", "tp_water_sheeting", 12000, 1, "int", &function_6be6da89, 0, 0);
	clientfield::register("toplayer", "sewer_landing_rumble", 12000, 1, "counter", &function_931fa0e1, 0, 0);
	clientfield::register("scriptmover", "dragon_egg_heat_fx", 12000, 1, "int", &function_3931d3fe, 0, 0);
	clientfield::register("scriptmover", "dragon_egg_placed", 12000, 1, "counter", &function_4b1f1b87, 0, 0);
	clientfield::register("actor", "dragon_egg_score_beam_fx", 12000, 1, "counter", &function_bfdc67e3, 0, 0);
	clientfield::register("world", "force_stream_dragon_egg", 12000, 1, "int", &function_b116183d, 0, 0);
	clientfield::register("scriptmover", "ethereal_audio_log_fx", 12000, 1, "int", &function_a96968f2, 0, 0);
	clientfield::register("world", "deactivate_ai_vox", 12000, 1, "int", &function_27fb11e6, 0, 0);
	clientfield::register("world", "sophia_intro_outro", 12000, 1, "int", &function_21deab84, 0, 0);
	clientfield::register("allplayers", "sophia_follow", 12000, 3, "int", &function_a431bec5, 0, 0);
	clientfield::register("scriptmover", "sophia_eye_shader", 12000, 1, "int", &function_70b3b237, 0, 0);
	clientfield::register("world", "sophia_main_waveform", 12000, 1, "int", &function_6cfcd54d, 0, 0);
	clientfield::register("toplayer", "interact_rumble", 12000, 1, "counter", &function_bbbdcfd5, 0, 0);
	level.var_6ca4d0f2 = [];
	level.var_48c1095e = [];
}

/*
	Name: include_weapons
	Namespace: namespace_320a344e
	Checksum: 0xBE52B7C9
	Offset: 0x2570
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_stalingrad_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: setup_personality_character_exerts
	Namespace: namespace_320a344e
	Checksum: 0x5C4870ED
	Offset: 0x25B0
	Size: 0x1071
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
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
	level.exert_sounds[2]["mantlesoundplayer"][6] = "vox_plr_1_exert_grunt_6";
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
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_3";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][6] = "vox_plr_3_exert_grunt_6";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
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
	Name: function_3a429aee
	Namespace: namespace_320a344e
	Checksum: 0x1D7AAB7E
	Offset: 0x3630
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function function_3a429aee()
{
	ForceStreamXModel("p7_zm_vending_jugg");
	ForceStreamXModel("p7_zm_vending_revive");
	ForceStreamXModel("p7_zm_vending_three_gun");
	ForceStreamXModel("p7_zm_sta_dragon_network_console");
	ForceStreamXModel("p7_zm_power_up_max_ammo");
	ForceStreamXModel("p7_zm_power_up_carpenter");
	ForceStreamXModel("p7_zm_power_up_double_points");
	ForceStreamXModel("p7_zm_power_up_firesale");
	ForceStreamXModel("p7_zm_power_up_insta_kill");
	ForceStreamXModel("p7_zm_power_up_nuke");
	ForceStreamXModel("zombie_pickup_minigun");
	ForceStreamXModel("zombie_pickup_perk_bottle");
	ForceStreamXModel("zombie_z_money_icon");
	ForceStreamXModel("p7_zm_power_up_widows_wine");
	ForceStreamXModel("p7_zm_sta_code_cylinder");
	ForceStreamXModel("p7_zm_sta_code_cylinder_red");
	ForceStreamXModel("p7_zm_sta_code_cylinder_yellow");
}

/*
	Name: function_38b57afd
	Namespace: namespace_320a344e
	Checksum: 0x1F8F77C
	Offset: 0x37D8
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function function_38b57afd()
{
	var_beffc54 = struct::get_array("ambient_fxanim", "targetname");
	if(GetDvarInt("splitscreen_playerCount") >= 2)
	{
		foreach(s_fxanim in var_beffc54)
		{
			struct::delete();
		}
		var_1bbd14fd = function_de7504ea("ambient_siege_anim");
		foreach(n_model_index in var_1bbd14fd)
		{
			HideStaticModel(n_model_index);
		}
	}
	else
	{
		level thread scene::Play("ambient_fxanim", "targetname");
	}
}

/*
	Name: function_6be6da89
	Namespace: namespace_320a344e
	Checksum: 0x9400E8C7
	Offset: 0x3988
	Size: 0x1B1
	Parameters: 7
	Flags: None
*/
function function_6be6da89(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		function_6c7d1149(localClientNum, 1);
		playsound(localClientNum, "zmb_stalingrad_sewer_water_travel_start");
		self.var_5962d89c = self PlayLoopSound("zmb_stalingrad_sewer_water_travel_lp", 0.3);
		var_11eaf469 = GetEntArray(0, "sewer_ride_end", "targetname");
		foreach(var_b81de649 in var_11eaf469)
		{
			self thread function_da4ab728(localClientNum, var_b81de649);
		}
	}
	else
	{
		function_d92493fb(localClientNum, 0);
		self StopLoopSound(self.var_5962d89c);
		self notify("hash_e7cca3ce");
	}
}

/*
	Name: function_da4ab728
	Namespace: namespace_320a344e
	Checksum: 0x92E8458C
	Offset: 0x3B48
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function function_da4ab728(localClientNum, var_b81de649)
{
	self endon("hash_e7cca3ce");
	while(1)
	{
		var_b81de649 waittill("trigger", who);
		if(who isLocalPlayer())
		{
			playsound(localClientNum, "zmb_stalingrad_sewer_pipe_exit");
			self StopLoopSound(self.var_5962d89c);
			wait(0.1);
			self.var_5962d89c = self PlayLoopSound("zmb_stalingrad_sewer_air_lp", 0.3);
			return;
		}
	}
}

/*
	Name: function_931fa0e1
	Namespace: namespace_320a344e
	Checksum: 0xAE0AD506
	Offset: 0x3C30
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_931fa0e1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self PlayRumbleOnEntity(localClientNum, "zm_stalingrad_sewer_landing");
	}
}

/*
	Name: function_4b1f1b87
	Namespace: namespace_320a344e
	Checksum: 0xD9E1B74
	Offset: 0x3CA0
	Size: 0x4D
	Parameters: 7
	Flags: None
*/
function function_4b1f1b87(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level.var_48c1095e[localClientNum] = self;
}

/*
	Name: function_bfdc67e3
	Namespace: namespace_320a344e
	Checksum: 0x2622D9D1
	Offset: 0x3CF8
	Size: 0x113
	Parameters: 7
	Flags: None
*/
function function_bfdc67e3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_42bd22b8 = level.var_48c1095e[localClientNum];
	var_3929e8a2 = util::spawn_model(localClientNum, "tag_origin", var_42bd22b8.origin + VectorScale((0, 0, 1), 50));
	var_e43465f2 = util::spawn_model(localClientNum, "tag_origin", self GetTagOrigin("j_spine4"), self GetTagAngles("j_spine4"));
	var_e43465f2 thread function_10e7e603(var_3929e8a2);
}

/*
	Name: function_10e7e603
	Namespace: namespace_320a344e
	Checksum: 0x98980533
	Offset: 0x3E18
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_10e7e603(var_3929e8a2)
{
	level beam::launch(self, "tag_origin", var_3929e8a2, "tag_origin", "electric_arc_zombie_to_drop_pod");
	var_3929e8a2 playsound(0, "zmb_pod_electrocute");
	wait(0.2);
	self playsound(0, "zmb_pod_electrocute_zmb");
	level beam::kill(self, "tag_origin", var_3929e8a2, "tag_origin", "electric_arc_zombie_to_drop_pod");
	var_3929e8a2 delete();
	self delete();
}

/*
	Name: function_3931d3fe
	Namespace: namespace_320a344e
	Checksum: 0x60A02A77
	Offset: 0x3F08
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_3931d3fe(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.n_fx_id = PlayFXOnTag(localClientNum, level._effect["dragon_egg_heat"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localClientNum, self.n_fx_id);
	}
}

/*
	Name: function_b116183d
	Namespace: namespace_320a344e
	Checksum: 0x11B68F70
	Offset: 0x3FC8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_b116183d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		ForceStreamXModel("p7_fxanim_zm_stal_dragon_incubator_egg_mod");
	}
	else
	{
		StopForceStreamingXModel("p7_fxanim_zm_stal_dragon_incubator_egg_mod");
	}
}

/*
	Name: function_a96968f2
	Namespace: namespace_320a344e
	Checksum: 0x93761C2F
	Offset: 0x4050
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_a96968f2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.n_fx_id = PlayFXOnTag(localClientNum, level._effect["audio_log"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localClientNum, self.n_fx_id);
	}
}

/*
	Name: function_21deab84
	Namespace: namespace_320a344e
	Checksum: 0x2B52DF5C
	Offset: 0x4110
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function function_21deab84(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_1c7b6837 = GetEnt(localClientNum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newVal)
	{
		var_1c7b6837 RotateTo((0, 0, 0), 2, 0.5, 0.5);
		var_1c7b6837 MapShaderConstant(localClientNum, 0, "scriptVector2", newVal, 0, 0);
	}
	else
	{
		level notify("hash_deeb3634");
		wait(0.5);
		var_1c7b6837 RotateTo((0, 0, 0), 0.2);
		level waittill("hash_7dde7b99");
		var_1c7b6837 delete();
	}
}

/*
	Name: function_a431bec5
	Namespace: namespace_320a344e
	Checksum: 0xADDE615E
	Offset: 0x4260
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_a431bec5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	var_1c7b6837 = GetEnt(localClientNum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	level notify("hash_deeb3634");
	wait(0.5);
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newVal == 0)
	{
		var_1c7b6837 RotateTo((0, 0, 0), 0.5);
	}
	else
	{
		level.var_9a736d20 = 1;
		var_1c7b6837 thread function_36666e11(self);
	}
}

/*
	Name: function_36666e11
	Namespace: namespace_320a344e
	Checksum: 0x82463136
	Offset: 0x4368
	Size: 0x1D7
	Parameters: 1
	Flags: None
*/
function function_36666e11(e_player)
{
	level endon("demo_jump");
	level endon("hash_deeb3634");
	e_player endon("death");
	self endon("entityshutdown");
	while(isdefined(e_player))
	{
		var_c746e6bf = e_player GetTagOrigin("j_head");
		var_933e0d32 = VectorToAngles(self.origin - var_c746e6bf);
		if(var_933e0d32[0] > 200)
		{
			var_f59577b7 = math::clamp(var_933e0d32[0], 333, 360);
			var_933e0d32 = (var_f59577b7, var_933e0d32[1], var_933e0d32[2]);
		}
		if(var_933e0d32[1] > 200)
		{
			var_cf92fd4e = math::clamp(var_933e0d32[1], 333, 360);
			var_933e0d32 = (var_933e0d32[0], var_cf92fd4e, var_933e0d32[2]);
		}
		else
		{
			var_cf92fd4e = math::clamp(var_933e0d32[1], 0, 27);
			var_933e0d32 = (var_933e0d32[0], var_cf92fd4e, var_933e0d32[2]);
		}
		self RotateTo(var_933e0d32, 0.1);
		wait(0.1);
	}
}

/*
	Name: function_70b3b237
	Namespace: namespace_320a344e
	Checksum: 0xA17D2129
	Offset: 0x4548
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_70b3b237(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector2", newVal, 0, 0);
}

/*
	Name: function_6cfcd54d
	Namespace: namespace_320a344e
	Checksum: 0xE13581C6
	Offset: 0x45B8
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function function_6cfcd54d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_1c7b6837 = GetEnt(localClientNum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newVal)
	{
		var_1c7b6837 HidePart(localClientNum, "flatline_jnt");
		var_1c7b6837 ShowPart(localClientNum, "wave_jnt");
	}
	else
	{
		var_1c7b6837 ShowPart(localClientNum, "flatline_jnt");
		var_1c7b6837 HidePart(localClientNum, "wave_jnt");
	}
}

/*
	Name: function_bbbdcfd5
	Namespace: namespace_320a344e
	Checksum: 0xD54E9199
	Offset: 0x46D0
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_bbbdcfd5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self PlayRumbleOnEntity(localClientNum, "zm_stalingrad_interact_rumble");
	}
}

/*
	Name: function_27fb11e6
	Namespace: namespace_320a344e
	Checksum: 0xEFB38616
	Offset: 0x4740
	Size: 0x71
	Parameters: 7
	Flags: None
*/
function function_27fb11e6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			level.voxAIdeactivate = 0;
		}
		case 1:
		{
			level.voxAIdeactivate = 1;
		}
	}
}

