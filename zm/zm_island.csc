#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_powerup_bonus_points_player;
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_empty_perk;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_island_seed;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_controllable_spider;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_island_shield;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_weap_mirg2000;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_amb;
#using scripts\zm\zm_island_challenges;
#using scripts\zm\zm_island_craftables;
#using scripts\zm\zm_island_dogfights;
#using scripts\zm\zm_island_ffotd;
#using scripts\zm\zm_island_fx;
#using scripts\zm\zm_island_inventory;
#using scripts\zm\zm_island_main_ee_quest;
#using scripts\zm\zm_island_pap_quest;
#using scripts\zm\zm_island_perks;
#using scripts\zm\zm_island_planting;
#using scripts\zm\zm_island_portals;
#using scripts\zm\zm_island_power;
#using scripts\zm\zm_island_side_ee_distant_monster;
#using scripts\zm\zm_island_side_ee_doppleganger;
#using scripts\zm\zm_island_side_ee_golden_bucket;
#using scripts\zm\zm_island_side_ee_good_thrasher;
#using scripts\zm\zm_island_side_ee_secret_maxammo;
#using scripts\zm\zm_island_side_ee_spore_hallucinations;
#using scripts\zm\zm_island_skullweapon_quest;
#using scripts\zm\zm_island_spider_ee_quest;
#using scripts\zm\zm_island_spider_quest;
#using scripts\zm\zm_island_spores;
#using scripts\zm\zm_island_takeo_fight;
#using scripts\zm\zm_island_transport;
#using scripts\zm\zm_island_traps;
#using scripts\zm\zm_island_ww_quest;
#using scripts\zm\zm_island_zones;

#namespace namespace_ff3ab036;

/*
	Name: opt_in
	Namespace: namespace_ff3ab036
	Checksum: 0xE58084F2
	Offset: 0x1B08
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
	Namespace: namespace_ff3ab036
	Checksum: 0x1F89A3F9
	Offset: 0x1B30
	Size: 0x29B
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_711c2fc8::main_start();
	namespace_1a868593::main();
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	level.setupCustomCharacterExerts = &setup_personality_character_exerts;
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	register_clientfields();
	include_weapons();
	level thread function_be61cf5a();
	namespace_e73c08bc::include_craftables();
	namespace_e73c08bc::init_craftables();
	namespace_14c8b75c::init();
	namespace_eaae7728::function_30d4f164();
	namespace_7550a904::init();
	namespace_f3e3de78::init();
	namespace_14b4d4ab::init();
	namespace_34c58dc::init();
	namespace_7a07aa2f::init();
	namespace_c8222934::init();
	namespace_5f2c95ae::init();
	namespace_78528370::function_30d4f164();
	namespace_9d2fabb6::init();
	namespace_f7d4f63b::init();
	namespace_48e6dffb::init();
	namespace_13425205::init();
	namespace_bbfc4da3::init();
	namespace_6c640490::init();
	namespace_28a54cd6::init();
	namespace_f777c489::init();
	namespace_fdccf5c4::init();
	namespace_79fcd4bc::init();
	namespace_5a453011::init();
	load::main();
	level thread namespace_f67badb7::main();
	level thread namespace_9d2fabb6::main();
	util::waitforclient(0);
	level thread function_3a429aee();
	namespace_711c2fc8::main_end();
}

/*
	Name: register_clientfields
	Namespace: namespace_ff3ab036
	Checksum: 0xAADA0DC2
	Offset: 0x1DD8
	Size: 0x363
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	var_ddba80d7 = GetMinBitCountForNum(3);
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "postfx_futz_mild", 9000, 1, "counter", &function_bf8650ca, 0, 0);
	clientfield::register("toplayer", "water_motes", 9000, 1, "int", &function_5cefaf77, 0, 0);
	clientfield::register("toplayer", "play_bubbles", 9000, 1, "int", &function_58e931d1, 0, 0);
	clientfield::register("toplayer", "set_world_fog", 9000, var_ddba80d7, "int", &function_346468e3, 0, 0);
	clientfield::register("toplayer", "speed_burst", 9000, 1, "int", &player_speed_changed, 0, 1);
	clientfield::register("toplayer", "tp_water_sheeting", 9000, 1, "int", &function_6be6da89, 0, 0);
	clientfield::register("toplayer", "wind_blur", 9000, 1, "int", &function_4a01cc4e, 0, 0);
	clientfield::register("scriptmover", "set_heavy_web_fade_material", 9000, 1, "int", &function_e0aec577, 0, 0);
	clientfield::register("world", "force_stream_spiders", 9001, 1, "int", &function_e0410522, 0, 0);
	clientfield::register("world", "force_stream_takeo_arms", 11001, 1, "int", &function_e4587332, 0, 0);
}

/*
	Name: include_weapons
	Namespace: namespace_ff3ab036
	Checksum: 0x95533335
	Offset: 0x2148
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_island_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: setup_personality_character_exerts
	Namespace: namespace_ff3ab036
	Checksum: 0xFC5D7CDD
	Offset: 0x2188
	Size: 0x1111
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
	Name: function_bf8650ca
	Namespace: namespace_ff3ab036
	Checksum: 0x1D1ED365
	Offset: 0x32A8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_bf8650ca(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	player postfx::playPostfxBundle("pstfx_dni_interrupt_mild");
}

/*
	Name: function_5cefaf77
	Namespace: namespace_ff3ab036
	Checksum: 0x55B5F4EF
	Offset: 0x3330
	Size: 0xDD
	Parameters: 7
	Flags: None
*/
function function_5cefaf77(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	wait(0.1);
	if(newVal)
	{
		if(isdefined(self) && !isdefined(self.var_8e8c7340))
		{
			self.var_8e8c7340 = PlayViewmodelFX(localClientNum, level._effect["water_motes"], "tag_camera");
		}
	}
	else if(isdefined(self) && isdefined(self.var_8e8c7340))
	{
		deletefx(localClientNum, self.var_8e8c7340, 1);
		self.var_8e8c7340 = undefined;
	}
}

/*
	Name: function_58e931d1
	Namespace: namespace_ff3ab036
	Checksum: 0x52D7E579
	Offset: 0x3418
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_58e931d1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_6e954d4(localClientNum);
	}
	else
	{
		self thread function_6fb5501(localClientNum);
	}
}

/*
	Name: function_6e954d4
	Namespace: namespace_ff3ab036
	Checksum: 0x759D7927
	Offset: 0x34A0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_6e954d4(localClientNum)
{
	self endon("death");
	if(!isdefined(self.var_b5e2500e))
	{
		self.var_b5e2500e = PlayFXOnCamera(localClientNum, level._effect["bubbles"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		self thread function_738868d4(localClientNum);
	}
}

/*
	Name: function_6fb5501
	Namespace: namespace_ff3ab036
	Checksum: 0xF59468BC
	Offset: 0x3528
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function function_6fb5501(localClientNum)
{
	if(isdefined(self.var_b5e2500e))
	{
		deletefx(localClientNum, self.var_b5e2500e, 1);
		self.var_b5e2500e = undefined;
	}
	self notify("hash_a48959b9");
}

/*
	Name: function_738868d4
	Namespace: namespace_ff3ab036
	Checksum: 0x7FAB9966
	Offset: 0x3588
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_738868d4(localClientNum)
{
	self endon("hash_a48959b9");
	self waittill("death");
	self function_6fb5501(localClientNum);
}

/*
	Name: function_346468e3
	Namespace: namespace_ff3ab036
	Checksum: 0x767F9287
	Offset: 0x35D0
	Size: 0xF3
	Parameters: 7
	Flags: None
*/
function function_346468e3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		SetLitFogBank(localClientNum, -1, 1, -1);
		SetWorldFogActiveBank(localClientNum, 2);
	}
	else if(newVal == 2)
	{
		SetWorldFogActiveBank(localClientNum, 3);
	}
	else
	{
		SetLitFogBank(localClientNum, -1, 0, -1);
		SetWorldFogActiveBank(localClientNum, 1);
	}
}

/*
	Name: on_localplayer_spawned
	Namespace: namespace_ff3ab036
	Checksum: 0x5F01FD23
	Offset: 0x36D0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	filter::init_filter_speed_burst(self);
	filter::disable_filter_speed_burst(self, 3);
}

/*
	Name: player_speed_changed
	Namespace: namespace_ff3ab036
	Checksum: 0x29AC8F53
	Offset: 0x3730
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function player_speed_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(self == GetLocalPlayer(localClientNum))
		{
			filter::enable_filter_speed_burst(self, 3);
		}
	}
	else if(self == GetLocalPlayer(localClientNum))
	{
		filter::disable_filter_speed_burst(self, 3);
	}
}

/*
	Name: mapped_material_id
	Namespace: namespace_ff3ab036
	Checksum: 0x78E4714E
	Offset: 0x37F8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function mapped_material_id(materialName)
{
	if(!isdefined(level.filter_matid))
	{
		level.filter_matid = [];
	}
	return level.filter_matid[materialName];
}

/*
	Name: function_6be6da89
	Namespace: namespace_ff3ab036
	Checksum: 0xAB0F059D
	Offset: 0x3830
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_6be6da89(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		function_6c7d1149(localClientNum, 1);
		playsound(localClientNum, "evt_sewer_transport_start");
		self.var_14108ea4 = self PlayLoopSound("evt_sewer_transport_loop", 0.3);
	}
	else
	{
		function_d92493fb(localClientNum, 0);
		self StopLoopSound(self.var_14108ea4);
	}
}

/*
	Name: function_4a01cc4e
	Namespace: namespace_ff3ab036
	Checksum: 0xD9B3ED15
	Offset: 0x3928
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_4a01cc4e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		EnableSpeedBlur(localClientNum, 0.07, 0.55, 0.9, 0, 100, 100);
	}
	else
	{
		DisableSpeedBlur(localClientNum);
	}
}

/*
	Name: function_e0aec577
	Namespace: namespace_ff3ab036
	Checksum: 0xE9EE77A
	Offset: 0x39C8
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function function_e0aec577(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		var_b05b3457 = 0.01;
		var_bbfa5d7d = newVal;
		self playsound(0, "zmb_spider_web_hero_destroy");
		for(i = 1; i > var_bbfa5d7d;  = 1)
		{
			if(isdefined(self))
			{
				self MapShaderConstant(localClientNum, 0, "scriptVector2", i, i, i, 0);
				wait(var_b05b3457);
			}
			else
			{
				break;
			}
		}
		if(isdefined(self))
		{
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0, 0);
		}
	}
}

/*
	Name: function_be61cf5a
	Namespace: namespace_ff3ab036
	Checksum: 0xA75DFB9B
	Offset: 0x3B40
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function function_be61cf5a()
{
	var_f47aa4cf = getdynentarray();
	foreach(dyn_ent in var_f47aa4cf)
	{
		SetDynEntEnabled(dyn_ent, 0);
	}
}

/*
	Name: function_3a429aee
	Namespace: namespace_ff3ab036
	Checksum: 0xB6E996FE
	Offset: 0x3BF8
	Size: 0x303
	Parameters: 0
	Flags: None
*/
function function_3a429aee()
{
	ForceStreamXModel("p7_zm_isl_bucket_115");
	ForceStreamXModel("p7_fxanim_zm_island_vine_gate_mod");
	ForceStreamXModel("p7_zm_vending_jugg");
	ForceStreamXModel("p7_zm_vending_doubletap2");
	ForceStreamXModel("p7_zm_vending_revive");
	ForceStreamXModel("p7_zm_vending_sleight");
	ForceStreamXModel("p7_zm_vending_three_gun");
	ForceStreamXModel("p7_zm_vending_marathon");
	ForceStreamXModel("p7_zm_isl_web_vending_jugg");
	ForceStreamXModel("p7_zm_isl_web_vending_doubletap2");
	ForceStreamXModel("p7_zm_isl_web_vending_revive");
	ForceStreamXModel("p7_zm_isl_web_vending_sleight");
	ForceStreamXModel("p7_zm_isl_web_vending_three_gun");
	ForceStreamXModel("p7_zm_isl_web_vending_marathon");
	ForceStreamXModel("p7_zm_isl_web_buy_door");
	ForceStreamXModel("p7_zm_isl_web_buy_door_110");
	ForceStreamXModel("p7_zm_isl_web_buy_door_112");
	ForceStreamXModel("p7_zm_isl_web_buy_door_114");
	ForceStreamXModel("p7_zm_isl_web_buy_door_132");
	ForceStreamXModel("p7_zm_isl_web_buy_door_146");
	ForceStreamXModel("p7_zm_isl_web_penstock");
	ForceStreamXModel("p7_zm_isl_web_bubblegum_machine");
	ForceStreamXModel("p7_zm_power_up_max_ammo");
	ForceStreamXModel("p7_zm_power_up_carpenter");
	ForceStreamXModel("p7_zm_power_up_double_points");
	ForceStreamXModel("p7_zm_power_up_firesale");
	ForceStreamXModel("p7_zm_power_up_insta_kill");
	ForceStreamXModel("p7_zm_power_up_nuke");
	ForceStreamXModel("zombie_pickup_minigun");
	ForceStreamXModel("zombie_pickup_perk_bottle");
	ForceStreamXModel("zombie_z_money_icon");
	ForceStreamXModel("p7_zm_isl_plant_seed_pod_01");
}

/*
	Name: function_e0410522
	Namespace: namespace_ff3ab036
	Checksum: 0xD960D244
	Offset: 0x3F08
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_e0410522(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		ForceStreamXModel("c_zom_dlc2_spider");
	}
	else
	{
		StopForceStreamingXModel("c_zom_dlc2_spider");
	}
}

/*
	Name: function_e4587332
	Namespace: namespace_ff3ab036
	Checksum: 0xA5B5D80D
	Offset: 0x3F90
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function function_e4587332(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		ForceStreamXModel("p7_fxanim_zm_island_takeo_arm1_mod");
		ForceStreamXModel("p7_fxanim_zm_island_takeo_arm2_mod");
		ForceStreamXModel("p7_fxanim_zm_island_takeo_arm3_mod");
		ForceStreamXModel("p7_fxanim_zm_island_takeo_arm4_mod");
	}
	else
	{
		StopForceStreamingXModel("p7_fxanim_zm_island_takeo_arm1_mod");
		StopForceStreamingXModel("p7_fxanim_zm_island_takeo_arm2_mod");
		StopForceStreamingXModel("p7_fxanim_zm_island_takeo_arm3_mod");
		StopForceStreamingXModel("p7_fxanim_zm_island_takeo_arm4_mod");
	}
}

