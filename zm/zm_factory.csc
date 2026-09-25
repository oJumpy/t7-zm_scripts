#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
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
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_factory_amb;
#using scripts\zm\zm_factory_ffotd;
#using scripts\zm\zm_factory_fx;
#using scripts\zm\zm_factory_teleporter;

#namespace zm_factory;

/*
	Name: opt_in
	Namespace: zm_factory
	Checksum: 0xEBEAC76E
	Offset: 0x1060
	Size: 0x27B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level._effect["zm_bgb_machine_available"] = "zombie/fx_bgb_machine_available_factory_zmb";
	level._effect["zm_bgb_machine_bulb_away"] = "zombie/fx_bgb_machine_bulb_away_factory_zmb";
	level._effect["zm_bgb_machine_bulb_available"] = "zombie/fx_bgb_machine_bulb_available_factory_zmb";
	level._effect["zm_bgb_machine_bulb_activated"] = "zombie/fx_bgb_machine_bulb_activated_factory_zmb";
	level._effect["zm_bgb_machine_bulb_event"] = "zombie/fx_bgb_machine_bulb_event_factory_zmb";
	level._effect["zm_bgb_machine_bulb_rounds"] = "zombie/fx_bgb_machine_bulb_rounds_factory_zmb";
	level._effect["zm_bgb_machine_bulb_time"] = "zombie/fx_bgb_machine_bulb_time_factory_zmb";
	level._effect["zm_bgb_machine_light_interior"] = "zombie/fx_bgb_machine_light_interior_factory_zmb";
	level._effect["zm_bgb_machine_light_interior_away"] = "zombie/fx_bgb_machine_light_interior_away_factory_zmb";
	clientfield::register("world", "console_blue", 1, 1, "int", &console_blue, 0, 0);
	clientfield::register("world", "console_green", 1, 1, "int", &console_green, 0, 0);
	clientfield::register("world", "console_red", 1, 1, "int", &console_red, 0, 0);
	clientfield::register("world", "console_start", 1, 1, "int", &console_start, 0, 0);
	clientfield::register("toplayer", "lightning_strike", 1, 1, "counter", &lightning_strike, 0, 0);
}

/*
	Name: main
	Namespace: zm_factory
	Checksum: 0xFA7111D3
	Offset: 0x12E8
	Size: 0x253
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_689d3383::main_start();
	zm_factory_fx::main();
	level.setupCustomCharacterExerts = &setup_personality_character_exerts;
	level.legacy_cymbal_monkey = 1;
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	level._effect["animscript_gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["player_snow"] = "dlc0/factory/fx_snow_player_os_factory";
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	level.debug_keyline_zombies = 0;
	include_weapons();
	include_perks();
	load::main();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_tesla::init();
	level thread zm_factory_amb::main();
	level thread power_on_fxanims();
	callback::on_localclient_connect(&function_8feafce2);
	callback::on_spawned(&on_player_spawned);
	level thread function_e0500062();
	namespace_689d3383::main_end();
	util::waitforclient(0);
	/#
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: function_8feafce2
	Namespace: zm_factory
	Checksum: 0xD0255DA8
	Offset: 0x1548
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function function_8feafce2(localClientNum)
{
	if(1 != GetDvarInt("movie_intro"))
	{
		return;
	}
	wait(0.05);
	keys = getArrayKeys(level._active_wallbuys);
	for(i = 0; i < keys.size; i++)
	{
		wallbuy = level._active_wallbuys[keys[i]];
		stopfx(localClientNum, wallbuy.FX[localClientNum]);
	}
}

/*
	Name: include_weapons
	Namespace: zm_factory
	Checksum: 0xA66EFAD
	Offset: 0x1628
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_factory_weapons.csv", 1);
}

/*
	Name: include_perks
	Namespace: zm_factory
	Checksum: 0x99EC1590
	Offset: 0x1658
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function include_perks()
{
}

/*
	Name: on_player_spawned
	Namespace: zm_factory
	Checksum: 0x8474B4C7
	Offset: 0x1668
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localClientNum)
{
	self thread function_9788e0f3(localClientNum);
}

/*
	Name: function_9788e0f3
	Namespace: zm_factory
	Checksum: 0xE38EFA3C
	Offset: 0x1698
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function function_9788e0f3(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	if(1 == GetDvarInt("movie_intro"))
	{
		return;
	}
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
		fxid = playFX(localClientNum, level._effect["player_snow"], self.origin);
		function_7a6170fb(localClientNum, fxid);
		wait(0.25);
	}
}

/*
	Name: power_on_fxanims
	Namespace: zm_factory
	Checksum: 0x69A14FF
	Offset: 0x17A8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function power_on_fxanims()
{
	level waittill("power_on");
	level thread scene::Play("p7_fxanim_gp_wire_sparking_ground_01_bundle");
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_factory
	Checksum: 0x52D9862F
	Offset: 0x17E0
	Size: 0x621
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_4";
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
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_melee_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_melee_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_melee_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_melee_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_melee_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_melee_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_melee_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_melee_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_melee_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_melee_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_melee_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_melee_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_melee_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_melee_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_melee_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_melee_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_melee_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_melee_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_melee_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_melee_4";
}

/*
	Name: fx_overrides
	Namespace: zm_factory
	Checksum: 0x1C2BE500
	Offset: 0x1E10
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function fx_overrides()
{
	level._effect["jugger_light"] = "zombie/fx_perk_juggernaut_factory_zmb";
	level._effect["revive_light"] = "zombie/fx_perk_quick_revive_factory_zmb";
	level._effect["sleight_light"] = "zombie/fx_perk_sleight_of_hand_factory_zmb";
	level._effect["doubletap2_light"] = "zombie/fx_perk_doubletap2_factory_zmb";
	level._effect["deadshot_light"] = "zombie/fx_perk_daiquiri_factory_zmb";
	level._effect["marathon_light"] = "zombie/fx_perk_stamin_up_factory_zmb";
	level._effect["additionalprimaryweapon_light"] = "zombie/fx_perk_mule_kick_factory_zmb";
}

/*
	Name: function_e0500062
	Namespace: zm_factory
	Checksum: 0x24030F8F
	Offset: 0x1EE0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_e0500062()
{
	level waittill("hash_e61d99fd");
	playsound(0, "zmb_robothead_laser", (-434, 706, 439));
	playsound(0, "zmb_robothead_reflection_laser", (-451, -397, 294));
}

/*
	Name: console_blue
	Namespace: zm_factory
	Checksum: 0x757639E8
	Offset: 0x1F50
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function console_blue(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	s_scene = struct::get("top_dial");
	if(newVal)
	{
		exploder::kill_exploder("teleporter_controller_red_light_1");
		exploder::exploder("teleporter_controller_light_1");
		s_scene thread scene::Play();
	}
	else
	{
		exploder::kill_exploder("teleporter_controller_light_1");
		s_scene scene::stop(1);
		s_scene scene::init();
	}
}

/*
	Name: console_green
	Namespace: zm_factory
	Checksum: 0x2D090EC0
	Offset: 0x2060
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function console_green(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	s_scene = struct::get("middle_dial");
	if(newVal)
	{
		exploder::kill_exploder("teleporter_controller_red_light_2");
		exploder::exploder("teleporter_controller_light_2");
		s_scene thread scene::Play();
	}
	else
	{
		exploder::kill_exploder("teleporter_controller_light_2");
		s_scene scene::stop(1);
		s_scene scene::init();
	}
}

/*
	Name: console_red
	Namespace: zm_factory
	Checksum: 0xCFB23F84
	Offset: 0x2170
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function console_red(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	s_scene = struct::get("bottom_dial");
	if(newVal)
	{
		exploder::kill_exploder("teleporter_controller_red_light_3");
		exploder::exploder("teleporter_controller_light_3");
		s_scene thread scene::Play();
	}
	else
	{
		exploder::kill_exploder("teleporter_controller_light_3");
		s_scene scene::stop(1);
		s_scene scene::init();
	}
}

/*
	Name: console_start
	Namespace: zm_factory
	Checksum: 0xD687F83D
	Offset: 0x2280
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function console_start(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("teleporter_controller_red_light_1");
		exploder::exploder("teleporter_controller_red_light_2");
		exploder::exploder("teleporter_controller_red_light_3");
	}
}

/*
	Name: lightning_strike
	Namespace: zm_factory
	Checksum: 0x1B21D663
	Offset: 0x2318
	Size: 0x193
	Parameters: 7
	Flags: None
*/
function lightning_strike(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	SetUkkoScriptIndex(localClientNum, 1, 1);
	playsound(0, "amb_lightning_dist_low", (0, 0, 0));
	wait(0.02);
	SetUkkoScriptIndex(localClientNum, 3, 1);
	wait(0.15);
	SetUkkoScriptIndex(localClientNum, 1, 1);
	wait(0.1);
	SetUkkoScriptIndex(localClientNum, 4, 1);
	wait(0.1);
	SetUkkoScriptIndex(localClientNum, 3, 1);
	wait(0.25);
	SetUkkoScriptIndex(localClientNum, 1, 1);
	wait(0.15);
	SetUkkoScriptIndex(localClientNum, 3, 1);
	wait(0.15);
	SetUkkoScriptIndex(localClientNum, 1, 1);
}

