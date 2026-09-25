#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_glaive;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\_zm_magicbox_zod;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_glaive;
#using scripts\zm\_zm_weap_idgun;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weap_rocketshield;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\aats\_zm_aat_blast_furnace;
#using scripts\zm\aats\_zm_aat_turned;
#using scripts\zm\archetype_zod_companion;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_amb;
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_ee;
#using scripts\zm\zm_zod_ee_side;
#using scripts\zm\zm_zod_ffotd;
#using scripts\zm\zm_zod_fx;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_perks;
#using scripts\zm\zm_zod_pods;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_robot;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_train;
#using scripts\zm\zm_zod_transformer;
#using scripts\zm\zm_zod_traps;
#using scripts\zm\zm_zod_util;

#namespace zm_zod;

/*
	Name: opt_in
	Namespace: zm_zod
	Checksum: 0xFD3F7874
	Offset: 0x17C0
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
	Namespace: zm_zod
	Checksum: 0x4850D5DB
	Offset: 0x17E8
	Size: 0x363
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_b65ec48a::main_start();
	ForceStreamXModel("p7_zm_vending_widows_wine");
	ForceStreamXModel("p7_zm_vending_jugg");
	ForceStreamXModel("p7_zm_vending_sleight");
	ForceStreamXModel("p7_zm_vending_three_gun");
	level.var_6f8e5f09 = [];
	Array::add(level.var_6f8e5f09, "boxer");
	Array::add(level.var_6f8e5f09, "detective");
	Array::add(level.var_6f8e5f09, "femme");
	Array::add(level.var_6f8e5f09, "magician");
	register_clientfields();
	level.setupCustomCharacterExerts = &setup_personality_character_exerts;
	level.debug_keyline_zombies = 0;
	namespace_47b9c241::main();
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange_zod";
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	level._effect["animscript_gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["rain_light"] = "weather/fx_rain_system_lite_runner";
	level._effect["rain_medium"] = "weather/fx_rain_system_med_runner";
	level._effect["rain_heavy"] = "weather/fx_rain_system_hvy_runner";
	level._effect["rain_acid"] = "weather/fx_rain_system_hvy_acid_zod";
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	include_weapons();
	namespace_cfbe948b::init();
	zm_zod_craftables::include_craftables();
	zm_zod_craftables::init_craftables();
	namespace_bb738c6::init();
	load::main();
	thread namespace_c3257ae1::main();
	callback::on_spawned(&on_player_spawned);
	duplicate_render::set_dr_filter_framebuffer("zod_ghost", 90, "zod_ghost", undefined, 0, "mc/hud_zod_ghost", 0);
	namespace_b65ec48a::main_end();
	util::waitforclient(0);
}

/*
	Name: register_clientfields
	Namespace: zm_zod
	Checksum: 0x81E3C41D
	Offset: 0x1B58
	Size: 0x5CB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("toplayer", "fullscreen_rain_fx", 1, 1, "int", &toggle_rain_overlay, 0, 1);
	clientfield::register("world", "rain_state", 1, 1, "int", undefined, 0, 0);
	clientfield::register("world", "junction_crane_state", 1, 1, "int", &function_b339a5f5, 0, 1);
	clientfield::register("toplayer", "devgui_lightning_test", 1, 1, "counter", &function_2cf3dd37, 0, 0);
	n_bits = GetMinBitCountForNum(8);
	clientfield::register("toplayer", "player_rumble_and_shake", 1, n_bits, "int", &namespace_8e578893::function_f118a0e7, 0, 0);
	clientfield::register("actor", "ghost_actor", 1, 1, "int", &function_b48f294, 0, 0);
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("clientuimodel", "zmInventory.player_character_identity", 1, n_bits, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_using_sprayer", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_fusebox", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_idgun", 1, 1, "int", undefined, 0, 0);
	n_bits = GetMinBitCountForNum(7);
	clientfield::register("clientuimodel", "zmInventory.player_sword_quest_egg_state", 1, n_bits, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_sword_quest_completed_level_1", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_quest_items", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_idgun_parts", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_fuses", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_egg", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_sprayer", 1, 1, "int", undefined, 0, 0);
	clientfield::register("world", "hide_perf_static_models", 1, 1, "int", &function_f8cdd387, 0, 1);
	clientfield::register("world", "breakable_show", 1, 3, "int", &function_66fdd0a3, 0, 1);
	clientfield::register("world", "breakable_hide", 1, 3, "int", &function_5a6fb328, 0, 1);
	visionset_mgr::register_visionset_info("zombie_noire", 1, 1, undefined, "zombie_noire");
}

/*
	Name: on_player_spawned
	Namespace: zm_zod
	Checksum: 0x888E40EC
	Offset: 0x2130
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localClientNum)
{
	if(self == GetLocalPlayer(localClientNum))
	{
		self thread function_48d14da2(localClientNum);
		if(!IsDemoPlaying() || GetDemoVersion() >= 8)
		{
			util::spawn_model(localClientNum, "p7_zm_zod_cipher_06", (2600.75, -3538, -364.75), (110, 180, 0));
		}
	}
}

/*
	Name: toggle_rain_overlay
	Namespace: zm_zod
	Checksum: 0x408FD6C8
	Offset: 0x21F0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function toggle_rain_overlay(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		/#
			println("Dev Block strings are not supported");
		#/
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: function_48d14da2
	Namespace: zm_zod
	Checksum: 0xF5A5366E
	Offset: 0x2280
	Size: 0x157
	Parameters: 1
	Flags: None
*/
function function_48d14da2(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	if(!self isLocalPlayer() || !isdefined(self getlocalclientnumber()) || localClientNum != self getlocalclientnumber())
	{
		return;
	}
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		var_53729670 = level clientfield::get("rain_state");
		if(var_53729670 === 1)
		{
			fxid = playFX(localClientNum, level._effect["rain_acid"], self.origin);
		}
		else
		{
			fxid = playFX(localClientNum, level._effect["rain_heavy"], self.origin);
		}
		function_7a6170fb(localClientNum, fxid);
		wait(0.25);
	}
}

/*
	Name: function_b339a5f5
	Namespace: zm_zod
	Checksum: 0x87889480
	Offset: 0x23E0
	Size: 0x29B
	Parameters: 7
	Flags: None
*/
function function_b339a5f5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	wait(0.016);
	var_4cec7cba = GetEnt(localClientNum, "junction_crane_crate_phrase", "targetname");
	e_crane = GetEnt(localClientNum, "quest_personal_item_junction_crane", "targetname");
	var_970f30f6 = GetEnt(localClientNum, "junction_crane_crate", "targetname");
	var_385d73c3 = function_de7504ea("fxanim_crate_junction_break_static");
	HideStaticModel(var_385d73c3[0]);
	var_3153c901 = function_de7504ea("fxanim_junction_crane_static");
	if(newVal == 1)
	{
		HideStaticModel(var_3153c901[0]);
		var_49dac624 = function_de7504ea("fxanim_crate_junction_static");
		HideStaticModel(var_49dac624[0]);
		level thread function_8db965a5(var_385d73c3[0]);
		scene::Play("p7_fxanim_zm_zod_crate_breakable_03_junction_bundle");
		UnhideStaticModel(var_3153c901[0]);
	}
	else
	{
		UnhideStaticModel(var_3153c901[0]);
		if(isdefined(e_crane))
		{
			PlayFXOnTag(localClientNum, level._effect["crane_light"], e_crane, "j_light");
		}
		if(isdefined(var_4cec7cba))
		{
			PlayFXOnTag(localClientNum, level._effect["cultist_crate_personal_item"], var_4cec7cba, "tag_origin");
		}
	}
}

/*
	Name: function_8db965a5
	Namespace: zm_zod
	Checksum: 0x58D8FA7
	Offset: 0x2688
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_8db965a5(var_df899b02)
{
	wait(9.5);
	UnhideStaticModel(var_df899b02);
}

/*
	Name: include_weapons
	Namespace: zm_zod
	Checksum: 0x3E06A848
	Offset: 0x26C0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_zod_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_zod
	Checksum: 0x5080CA6A
	Offset: 0x2700
	Size: 0x1079
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale";
	level.exert_sounds[2]["playerbreathinsound"][2] = "vox_plr_1_exert_inhale";
	level.exert_sounds[3]["playerbreathinsound"][2] = "vox_plr_2_exert_inhale";
	level.exert_sounds[4]["playerbreathinsound"][2] = "vox_plr_3_exert_inhale";
	level.exert_sounds[1]["playerbreathoutsound"][2] = "vox_plr_0_exert_exhale";
	level.exert_sounds[2]["playerbreathoutsound"][2] = "vox_plr_1_exert_exhale";
	level.exert_sounds[3]["playerbreathoutsound"][2] = "vox_plr_2_exert_exhale";
	level.exert_sounds[4]["playerbreathoutsound"][2] = "vox_plr_3_exert_exhale";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_gasp";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_gasp";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_gasp";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_gasp";
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_bit_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_bit_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_bit_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_bit_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["falldamage"][8] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_bit_0";
	level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_bit_1";
	level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_bit_2";
	level.exert_sounds[4]["falldamage"][8] = "vox_plr_3_exert_bit_3";
	level.exert_sounds[4]["falldamage"][9] = "vox_plr_3_exert_bit_4";
	level.exert_sounds[4]["falldamage"][10] = "vox_plr_3_exert_bit_6";
	level.exert_sounds[4]["falldamage"][11] = "vox_plr_3_exert_bit_7";
	level.exert_sounds[4]["falldamage"][12] = "vox_plr_3_exert_bit_8";
	level.exert_sounds[4]["falldamage"][13] = "vox_plr_3_exert_bit_9";
	level.exert_sounds[4]["falldamage"][14] = "vox_plr_3_exert_bit_10";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_charge_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_charge_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_charge_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_charge_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_melee_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_melee_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][6] = "vox_plr_0_exert_melee_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][7] = "vox_plr_0_exert_melee_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][8] = "vox_plr_0_exert_melee_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_charge_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_charge_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_melee_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_melee_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_melee_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_melee_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][6] = "vox_plr_1_exert_melee_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_charge_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_charge_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_melee_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_melee_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_melee_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_melee_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][6] = "vox_plr_2_exert_melee_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_melee_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_melee_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_melee_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_melee_4";
	level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_bit_0";
	level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_bit_1";
	level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_bit_2";
	level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_bit_3";
	level.exert_sounds[1]["dtplandsoundplayer"][4] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["dtplandsoundplayer"][5] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["dtplandsoundplayer"][6] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["dtplandsoundplayer"][7] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["dtplandsoundplayer"][8] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["dtplandsoundplayer"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["dtplandsoundplayer"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["dtplandsoundplayer"][4] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[4]["dtplandsoundplayer"][5] = "vox_plr_3_exert_bit_0";
	level.exert_sounds[4]["dtplandsoundplayer"][6] = "vox_plr_3_exert_bit_1";
	level.exert_sounds[4]["dtplandsoundplayer"][7] = "vox_plr_3_exert_bit_2";
	level.exert_sounds[4]["dtplandsoundplayer"][8] = "vox_plr_3_exert_bit_3";
	level.exert_sounds[4]["dtplandsoundplayer"][9] = "vox_plr_3_exert_bit_4";
	level.exert_sounds[4]["dtplandsoundplayer"][10] = "vox_plr_3_exert_bit_6";
	level.exert_sounds[4]["dtplandsoundplayer"][11] = "vox_plr_3_exert_bit_7";
	level.exert_sounds[4]["dtplandsoundplayer"][12] = "vox_plr_3_exert_bit_8";
	level.exert_sounds[4]["dtplandsoundplayer"][13] = "vox_plr_3_exert_bit_9";
	level.exert_sounds[4]["dtplandsoundplayer"][14] = "vox_plr_3_exert_bit_10";
}

/*
	Name: function_7d846745
	Namespace: zm_zod
	Checksum: 0xA2299820
	Offset: 0x3788
	Size: 0x1AD
	Parameters: 7
	Flags: None
*/
function function_7d846745(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_3082faeb = function_de7504ea("pap_weed");
	if(newVal == 1)
	{
		foreach(model in var_3082faeb)
		{
			UnhideStaticModel(model);
			if(i % 25 == 0)
			{
				wait(0.016);
			}
		}
		break;
	}
	foreach(model in var_3082faeb)
	{
		HideStaticModel(model);
		if(i % 10 == 0)
		{
			wait(0.016);
		}
	}
}

/*
	Name: function_2cf3dd37
	Namespace: zm_zod
	Checksum: 0xC24E7569
	Offset: 0x3940
	Size: 0x183
	Parameters: 7
	Flags: None
*/
function function_2cf3dd37(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	SetUkkoScriptIndex(localClientNum, 2, 1);
	exploder::exploder("fx_exploder_lightning_dock");
	playsound(0, "amb_lightning_dist_low", (0, 0, 0));
	wait(0.15);
	SetUkkoScriptIndex(localClientNum, 3, 1);
	wait(0.2);
	SetUkkoScriptIndex(localClientNum, 2, 1);
	wait(0.1);
	SetUkkoScriptIndex(localClientNum, 3, 1);
	wait(0.25);
	SetUkkoScriptIndex(localClientNum, 4, 1);
	wait(0.05);
	SetUkkoScriptIndex(localClientNum, 5, 1);
	wait(0.05);
	SetUkkoScriptIndex(localClientNum, 1, 1);
}

/*
	Name: function_f650f42a
	Namespace: zm_zod
	Checksum: 0xDD510285
	Offset: 0x3AD0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_f650f42a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isPlayer() && self isLocalPlayer() && !IsDemoPlaying())
	{
		if(!isdefined(self getlocalclientnumber()) || localClientNum == self getlocalclientnumber())
		{
			return;
		}
	}
	self duplicate_render::set_dr_flag("zod_ghost", newVal);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: function_b48f294
	Namespace: zm_zod
	Checksum: 0x8EDE04D
	Offset: 0x3BD8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_b48f294(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self duplicate_render::set_dr_flag("zod_ghost", newVal);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: function_f8cdd387
	Namespace: zm_zod
	Checksum: 0x43FDA5A5
	Offset: 0x3C58
	Size: 0x263
	Parameters: 7
	Flags: None
*/
function function_f8cdd387(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_bc94ac00 = function_de7504ea("fxanim_crate_waterfront_break_static");
	var_90dba62a = function_de7504ea("fxanim_crate_canal_static");
	for(i = 0; i < var_bc94ac00.size; i++)
	{
		HideStaticModel(var_bc94ac00[i]);
	}
	for(i = 0; i < var_90dba62a.size; i++)
	{
		HideStaticModel(var_90dba62a[i]);
	}
	var_48d31804 = function_de7504ea("fxanim_pap_bridge_01_static");
	HideStaticModel(var_48d31804[0]);
	var_48d31804 = function_de7504ea("fxanim_pap_bridge_02_static");
	HideStaticModel(var_48d31804[0]);
	var_48d31804 = function_de7504ea("fxanim_crate_footlight_static");
	HideStaticModel(var_48d31804[0]);
	var_48d31804 = function_de7504ea("fxanim_crate_footlight_break_static");
	HideStaticModel(var_48d31804[0]);
	var_48d31804 = function_de7504ea("fxanim_crate_start_static");
	HideStaticModel(var_48d31804[0]);
	var_48d31804 = function_de7504ea("fxanim_crate_start_break_static");
	HideStaticModel(var_48d31804[0]);
}

/*
	Name: function_66fdd0a3
	Namespace: zm_zod
	Checksum: 0x23B06917
	Offset: 0x3EC8
	Size: 0xDD
	Parameters: 7
	Flags: None
*/
function function_66fdd0a3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			var_48d31804 = function_de7504ea("fxanim_crate_start_static");
			UnhideStaticModel(var_48d31804[0]);
			break;
		}
		case 2:
		{
			var_48d31804 = function_de7504ea("fxanim_crate_start_break_static");
			UnhideStaticModel(var_48d31804[0]);
			break;
		}
	}
}

/*
	Name: function_5a6fb328
	Namespace: zm_zod
	Checksum: 0xE526335
	Offset: 0x3FB0
	Size: 0xDD
	Parameters: 7
	Flags: None
*/
function function_5a6fb328(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			var_48d31804 = function_de7504ea("fxanim_crate_start_static");
			HideStaticModel(var_48d31804[0]);
			break;
		}
		case 2:
		{
			var_48d31804 = function_de7504ea("fxanim_crate_start_break_static");
			HideStaticModel(var_48d31804[0]);
			break;
		}
	}
}

