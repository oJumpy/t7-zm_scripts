#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_electroball_grenade;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
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
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_castle_demonic_rune;
#using scripts\zm\_zm_powerup_castle_tram_token;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_castle_rocketshield;
#using scripts\zm\_zm_weap_claymore;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weap_elemental_bow_demongate;
#using scripts\zm\_zm_weap_elemental_bow_rune_prison;
#using scripts\zm\_zm_weap_elemental_bow_storm;
#using scripts\zm\_zm_weap_elemental_bow_wolf_howl;
#using scripts\zm\_zm_weap_gravityspikes;
#using scripts\zm\_zm_weap_plunger;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_castle_achievements;
#using scripts\zm\zm_castle_characters;
#using scripts\zm\zm_castle_cleanup_mgr;
#using scripts\zm\zm_castle_craftables;
#using scripts\zm\zm_castle_death_ray_trap;
#using scripts\zm\zm_castle_dogs;
#using scripts\zm\zm_castle_ee;
#using scripts\zm\zm_castle_ee_bossfight;
#using scripts\zm\zm_castle_ee_side;
#using scripts\zm\zm_castle_ffotd;
#using scripts\zm\zm_castle_flingers;
#using scripts\zm\zm_castle_fx;
#using scripts\zm\zm_castle_gamemodes;
#using scripts\zm\zm_castle_low_grav;
#using scripts\zm\zm_castle_masher_trap;
#using scripts\zm\zm_castle_mechz;
#using scripts\zm\zm_castle_pap_quest;
#using scripts\zm\zm_castle_perks;
#using scripts\zm\zm_castle_rocket_trap;
#using scripts\zm\zm_castle_teleporter;
#using scripts\zm\zm_castle_tram;
#using scripts\zm\zm_castle_util;
#using scripts\zm\zm_castle_vo;
#using scripts\zm\zm_castle_weap_quest;
#using scripts\zm\zm_castle_weap_quest_upgrade;
#using scripts\zm\zm_castle_zombie;
#using scripts\zm\zm_castle_zones;

#namespace namespace_c491e335;

/*
	Name: opt_in
	Namespace: namespace_c491e335
	Checksum: 0x28FDA671
	Offset: 0x21F8
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.random_pandora_box_start = 1;
	level._no_vending_machine_auto_collision = 1;
	level.pack_a_punch_camo_index = 75;
	level.pack_a_punch_camo_index_number_variants = 5;
}

/*
	Name: main
	Namespace: namespace_c491e335
	Checksum: 0xAAC5ADA3
	Offset: 0x2250
	Size: 0xABB
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_6b519a03::main_start();
	SetClearanceCeiling(28);
	clientfield::register("clientuimodel", "player_lives", 5000, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_fuses", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 1, 1, "int");
	clientfield::register("toplayer", "player_snow_fx", 5000, 1, "counter");
	clientfield::register("world", "snd_low_gravity_state", 5000, 2, "int");
	clientfield::register("world", "castle_fog_bank_switch", 1, 1, "int");
	spawner::add_archetype_spawn_function("zombie", &function_59909697);
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	level.var_1ae26ca5 = 5;
	level.var_bd64e31e = 5;
	level.fn_custom_zombie_spawner_selection = &function_4353b980;
	level.perk_random_idle_effects_override = &function_555e8704;
	level.str_elec_damage_shellshock_override = "castle_electrocution_zm";
	AddDebugCommand("devgui_cmd "ZM/Perks/Drink Dead Shot Daiquir (Castle)i:7" "zombie_devgui specialty_deadshot_castle"
");
	AddDebugCommand("devgui_cmd "ZM/Perks/Drink Widow's Wine (Castle):9" "zombie_devgui specialty_widowswine_castle"
");
	AddDebugCommand("devgui_cmd "ZM/Perks/Drink Electric Cherry (Castle):10" "zombie_devgui specialty_electriccherry_castle"
");
	AddDebugCommand("devgui_cmd "ZM/Perks/Remove All Perks (Castle):0" "zombie_devgui remove_perks_castle"
");
	AddDebugCommand("devgui_cmd "ZM/AI/Toggle_Skeletons (Castle):0" "zombie_devgui toggle_skeletons_castle"
");
	level.custom_devgui = &function_fcfd712e;
	level flag::init("rocket_firing");
	zm::init_fx();
	namespace_35f5e9b2::main();
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["raven_death_fx"] = "dlc1/castle/fx_raven_death";
	level._effect["raven_feather_fx"] = "dlc1/castle/fx_raven_death_feathers";
	level._effect["switch_sparks"] = "electric/fx_elec_sparks_directional_orange";
	level.default_start_location = "start_room";
	level.default_game_mode = "zclassic";
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&on_player_connect);
	level.has_richtofen = 0;
	level.precacheCustomCharacters = &namespace_72c864a4::precacheCustomCharacters;
	level.giveCustomCharacters = &namespace_72c864a4::giveCustomCharacters;
	level thread setup_personality_character_exerts();
	namespace_72c864a4::initCharacterStartIndex();
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	level.sndWeaponPickupOverride = Array("elemental_bow", "elemental_bow_demongate", "elemental_bow_rune_prison", "elemental_bow_storm", "elemental_bow_wolf_howl");
	level.craft_shield_piece_pickup_vo_override = &namespace_97ddfc0d::function_43b44df3;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level thread custom_add_vox();
	level._allow_melee_weapon_switching = 1;
	level.enemy_location_override_func = &enemy_location_override;
	level.no_target_override = &no_target_override;
	level.minigun_damage_adjust_override = &function_ec8a9331;
	level.var_2d0e5eb6 = &function_8921895f;
	level.var_9aaae7ae = &function_869d6f66;
	level.var_2d4e3645 = &function_d9e1ec4d;
	level.var_9cef605e = &function_98a0818e;
	level.gravityspike_position_check = &function_6190ec3f;
	level.player_score_override = &function_77b8a0f7;
	level.team_score_override = &function_5a64329b;
	level.var_4e84030d = &function_f9a3207d;
	level.gravityspikes_target_filter_callback = &function_862e966e;
	level._zombie_custom_spawn_logic = &function_639f3b62;
	level.zm_custom_spawn_location_selection = &function_c624f0b2;
	level.player_out_of_playable_area_monitor_callback = &player_out_of_playable_area_monitor_callback;
	level.debug_keyline_zombies = 0;
	namespace_4fd1ba2a::function_976c9217();
	include_perks_in_random_rotation();
	namespace_f2d05c13::main();
	namespace_ee5f5b26::main();
	level thread namespace_2eabe570::main();
	level thread function_69573a4c();
	level thread function_e0836624();
	level thread namespace_c93e4c32::main();
	level thread namespace_b1bc995c::init();
	level thread namespace_61c0be00::main();
	namespace_912a86f7::init();
	zm_craftables::init();
	namespace_dddf9a25::randomize_craftable_spawns();
	namespace_dddf9a25::include_craftables();
	namespace_dddf9a25::init_craftables();
	load::main();
	level._powerup_grab_check = &function_9b56d76;
	level thread function_13fc99fa();
	level.dog_round_track_override = &namespace_2545f7c9::dog_round_tracker;
	level.custom_dog_target_validity_check = &namespace_2545f7c9::function_1aaa22b5;
	level.fn_custom_round_ai_spawn = &namespace_2545f7c9::function_33aa4940;
	level.dog_spawn_func = &namespace_2545f7c9::function_92e4eaff;
	level.dog_setup_func = &namespace_2545f7c9::function_8cf500c9;
	level.dog_rounds_allowed = GetGametypeSetting("allowdogs");
	if(level.dog_rounds_allowed)
	{
		zm_ai_dogs::enable_dog_rounds();
	}
	namespace_48131a3f::enable_mechz_rounds();
	zombie_utility::set_zombie_var("below_world_check", -2500);
	level thread function_6058f34d();
	level thread function_a691b3f6();
	level thread power_electric_switch();
	level thread function_632e15ea();
	level thread function_a6477691();
	level thread function_9be4ecd1();
	_zm_weap_cymbal_monkey::init();
	level._round_start_func = &zm::round_start;
	level.powerup_fx_func = &function_c7d8dba7;
	init_sounds();
	level.zones = [];
	level.zone_manager_init_func = &namespace_63d46525::init;
	level thread zm_zonemgr::manage_zones(Array("zone_start"));
	level thread intro_screen();
	level thread setupMusic();
	level.zone_occupied_func = &function_1ba33179;
	SetDvar("hkai_pathfindIterationLimit", 1000);
	/#
		level thread function_287ae5ec();
	#/
	namespace_6b519a03::main_end();
}

/*
	Name: function_59909697
	Namespace: namespace_c491e335
	Checksum: 0x3C0A900A
	Offset: 0x2D18
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_59909697()
{
	if(IsSubStr(self.model, "skeleton"))
	{
		self HidePart("tag_weapon_left");
		self HidePart("tag_weapon_right");
	}
}

/*
	Name: function_4353b980
	Namespace: namespace_c491e335
	Checksum: 0xA3EBF435
	Offset: 0x2D88
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function function_4353b980()
{
	if(!isdefined(level.var_2c78e44c))
	{
		level.var_a70b4aef = [];
		level.var_2c78e44c = [];
		foreach(e_spawner in level.zombie_spawners)
		{
			if(e_spawner.targetname === "skeleton_spawner")
			{
				if(!isdefined(level.var_2c78e44c))
				{
					level.var_2c78e44c = [];
				}
				else if(!IsArray(level.var_2c78e44c))
				{
					level.var_2c78e44c = Array(level.var_2c78e44c);
				}
				level.var_2c78e44c[level.var_2c78e44c.size] = e_spawner;
				continue;
			}
			if(!isdefined(level.var_a70b4aef))
			{
				level.var_a70b4aef = [];
			}
			else if(!IsArray(level.var_a70b4aef))
			{
				level.var_a70b4aef = Array(level.var_a70b4aef);
			}
			level.var_a70b4aef[level.var_a70b4aef.size] = e_spawner;
		}
	}
	else if(level.var_9bf9e084 === 1)
	{
		var_a0bd4da1 = Array::random(level.var_2c78e44c);
	}
	else
	{
		var_a0bd4da1 = Array::random(level.var_a70b4aef);
	}
	return var_a0bd4da1;
}

/*
	Name: function_1ba33179
	Namespace: namespace_c491e335
	Checksum: 0xCC617185
	Offset: 0x2F80
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function function_1ba33179(zone_name)
{
	if(!zm_zonemgr::zone_is_enabled(zone_name))
	{
		return 0;
	}
	var_46ac7dc1 = 0;
	if(zone_name == "zone_v10_pad" || zone_name == "zone_v10_pad_exterior")
	{
		var_46ac7dc1 = 1;
	}
	zone = level.zones[zone_name];
	for(i = 0; i < zone.Volumes.size; i++)
	{
		players = GetPlayers();
		for(j = 0; j < players.size; j++)
		{
			if(players[j] istouching(zone.Volumes[i]) && !players[j].sessionstate == "spectator")
			{
				if(!var_46ac7dc1 || !players[j] laststand::player_is_in_laststand())
				{
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: function_e0836624
	Namespace: namespace_c491e335
	Checksum: 0xCF971DCA
	Offset: 0x3110
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_e0836624()
{
	level endon("end_game");
	level notify("hash_a3369c1f");
	level endon("hash_a3369c1f");
	while(1)
	{
		level waittill("host_migration_end");
		SetDvar("doublejump_enabled", 1);
		SetDvar("playerEnergy_enabled", 1);
		SetDvar("wallrun_enabled", 1);
	}
}

/*
	Name: function_fcfd712e
	Namespace: namespace_c491e335
	Checksum: 0x3C52D705
	Offset: 0x31B8
	Size: 0x355
	Parameters: 1
	Flags: None
*/
function function_fcfd712e(cmd)
{
	cmd_strings = StrTok(cmd, " ");
	var_8ceb4930 = GetEnt("specialty_doubletap2", "script_noteworthy");
	switch(cmd_strings[0])
	{
		case "specialty_deadshot_castle":
		{
			foreach(player in level.players)
			{
				var_8ceb4930 zm_perks::vending_trigger_post_think(player, "specialty_deadshot");
			}
			break;
		}
		case "specialty_widowswine_castle":
		{
			foreach(player in level.players)
			{
				var_8ceb4930 zm_perks::vending_trigger_post_think(player, "specialty_widowswine");
			}
			break;
		}
		case "specialty_electriccherry_castle":
		{
			foreach(player in level.players)
			{
				var_8ceb4930 zm_perks::vending_trigger_post_think(player, "specialty_electriccherry");
			}
			break;
		}
		case "remove_perks_castle":
		{
			zm_devgui::function_54b2ecf8();
			foreach(player in level.players)
			{
				player notify("specialty_deadshot" + "_stop");
				player notify("specialty_widowswine" + "_stop");
				player notify("specialty_electriccherry" + "_stop");
			}
			break;
		}
		case "toggle_skeletons_castle":
		{
			if(level.var_9bf9e084 !== 1)
			{
				level.var_9bf9e084 = 1;
			}
			else
			{
				level.var_9bf9e084 = 0;
			}
			break;
		}
	}
}

/*
	Name: player_out_of_playable_area_monitor_callback
	Namespace: namespace_c491e335
	Checksum: 0x4E4A29D5
	Offset: 0x3518
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function player_out_of_playable_area_monitor_callback()
{
	if(isdefined(self.var_122a2dda) && self.var_122a2dda)
	{
		return 0;
	}
	if(isdefined(self.teleport_origin))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_9b56d76
	Namespace: namespace_c491e335
	Checksum: 0xC673219A
	Offset: 0x3558
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_9b56d76(player)
{
	if(self.powerup_name == "castle_tram_token" && player clientfield::get_to_player("has_castle_tram_token"))
	{
		player thread function_f42077ff();
		return 0;
	}
	return 1;
}

/*
	Name: function_f42077ff
	Namespace: namespace_c491e335
	Checksum: 0x5206158
	Offset: 0x35C0
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function function_f42077ff()
{
	if(!(isdefined(self.var_378aff9e) && self.var_378aff9e))
	{
		self.var_378aff9e = 1;
		self thread zm_equipment::show_hint_text(&"ZM_CASTLE_TRAM_TOKEN_DENIED", 3);
		wait(6);
		self.var_378aff9e = undefined;
	}
}

/*
	Name: init_sounds
	Namespace: namespace_c491e335
	Checksum: 0x516A46C3
	Offset: 0x3630
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function init_sounds()
{
	zm_utility::add_sound("break_stone", "evt_break_stone");
	zm_utility::add_sound("gate_door", "zmb_gate_slide_open");
	zm_utility::add_sound("heavy_door", "zmb_heavy_door_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
}

/*
	Name: offhand_weapon_overrride
	Namespace: namespace_c491e335
	Checksum: 0xD48D3001
	Offset: 0x36C0
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = GetWeapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_melee_weapon_for_level(level.weaponBaseMelee.name);
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	zm_utility::register_melee_weapon_for_level("knife_plunger");
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: offhand_weapon_give_override
	Namespace: namespace_c491e335
	Checksum: 0x6FA2FF21
	Offset: 0x3788
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
	Name: function_f9a3207d
	Namespace: namespace_c491e335
	Checksum: 0x139A2232
	Offset: 0x3850
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function function_f9a3207d(ai_enemy)
{
	return isdefined(ai_enemy) && !IsSubStr(ai_enemy.classname, "keeper") && (ai_enemy.archetype !== "mechz" || (ai_enemy.archetype == "mechz" && (isdefined(ai_enemy.b_flyin_done) && ai_enemy.b_flyin_done))) && (!isdefined(ai_enemy.var_1ea49cd7) && ai_enemy.var_1ea49cd7) && (!isdefined(ai_enemy.var_bce6e774) && ai_enemy.var_bce6e774) && (!isdefined(ai_enemy.in_gravity_trap) && ai_enemy.in_gravity_trap) && (!isdefined(ai_enemy.b_melee_kill) && ai_enemy.b_melee_kill);
}

/*
	Name: function_862e966e
	Namespace: namespace_c491e335
	Checksum: 0x55FF21BE
	Offset: 0x3990
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_862e966e(ai_enemy)
{
	return !isdefined(ai_enemy.var_98056717) && ai_enemy.var_98056717;
}

/*
	Name: intro_screen
	Namespace: namespace_c491e335
	Checksum: 0x211A01EA
	Offset: 0x39C8
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function intro_screen()
{
	if(1 == GetDvarInt("movie_intro"))
	{
		return;
	}
	level flag::wait_till("start_zombie_round_logic");
	wait(2);
	level.intro_hud = NewHudElem();
	level.intro_hud.x = 0;
	level.intro_hud.y = 0;
	level.intro_hud.alignX = "left";
	level.intro_hud.alignY = "bottom";
	level.intro_hud.horzAlign = "left";
	level.intro_hud.vertAlign = "bottom";
	level.intro_hud.foreground = 1;
	if(level.Splitscreen && !level.hidef)
	{
		level.intro_hud.fontscale = 2.75;
	}
	else
	{
		level.intro_hud.fontscale = 1.75;
	}
	level.intro_hud.alpha = 0;
	level.intro_hud.color = (1, 1, 1);
	level.intro_hud.inUse = 0;
	level.intro_hud.y = -110;
	level.intro_hud fadeOverTime(3.5);
	level.intro_hud.alpha = 1;
	level notify("hash_59e5a3dd");
	wait(6);
	level.intro_hud fadeOverTime(3.5);
	level.intro_hud.alpha = 0;
	wait(4.5);
	level.intro_hud destroy();
}

/*
	Name: custom_add_weapons
	Namespace: namespace_c491e335
	Checksum: 0x7AE90265
	Offset: 0x3C18
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_castle_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: custom_add_vox
	Namespace: namespace_c491e335
	Checksum: 0x15223B0F
	Offset: 0x3C58
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_castle_vox.csv");
}

/*
	Name: setupMusic
	Namespace: namespace_c491e335
	Checksum: 0x618ACB38
	Offset: 0x3C80
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function setupMusic()
{
	zm_audio::musicState_Create("round_start", 3, "castle_roundstart_1");
	zm_audio::musicState_Create("round_start_short", 3, "castle_roundstart_1");
	zm_audio::musicState_Create("round_start_first", 3, "castle_roundstart_1");
	zm_audio::musicState_Create("round_end", 3, "castle_roundend_1", "castle_roundend_2", "castle_roundend_3");
	zm_audio::musicState_Create("game_over", 5, "castle_gameover");
	zm_audio::musicState_Create("location_lab", 4, "castle_location_lab");
	zm_audio::musicState_Create("requiem", 4, "requiem");
	zm_audio::musicState_Create("dead_again", 4, "dead_again");
	zm_audio::musicState_Create("moon_rockets", 4, "moon_rockets");
	zm_audio::musicState_Create("none", 4, "none");
	Array = GetEntArray("sndMusicLocationTrig", "targetname");
	Array::thread_all(Array, &function_44dc3fb4);
}

/*
	Name: function_44dc3fb4
	Namespace: namespace_c491e335
	Checksum: 0xC5C236C2
	Offset: 0x3E80
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_44dc3fb4()
{
	while(1)
	{
		self waittill("trigger", trigPlayer);
		if(isPlayer(trigPlayer))
		{
			if(self.script_sound == "richtofen")
			{
				return;
			}
			zm_audio::sndMusicSystem_PlayState("location_" + self.script_sound);
			return;
		}
		else
		{
			wait(0.016);
		}
	}
}

/*
	Name: on_player_spawned
	Namespace: namespace_c491e335
	Checksum: 0xCF98B747
	Offset: 0x3F18
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self function_f0051f1b(0);
	self function_7c34e9c7(0);
	self.var_7dd18a0 = 0;
	self.tesla_network_death_choke = 0;
	self.var_b94b5f2f = 1;
	if(!level flag::get("pap_reformed"))
	{
		self thread namespace_155a700c::function_b9cca08f();
	}
	level flag::wait_till("start_zombie_round_logic");
	wait(0.05);
	self clientfield::increment_to_player("player_snow_fx");
}

/*
	Name: on_player_connect
	Namespace: namespace_c491e335
	Checksum: 0x53EDF0E4
	Offset: 0x3FF8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread namespace_8e89abe3::function_c3f6aa22();
	self thread function_30cebef9();
}

/*
	Name: include_perks_in_random_rotation
	Namespace: namespace_c491e335
	Checksum: 0x48B5CC2B
	Offset: 0x4038
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
	zm_perk_random::include_perk_in_random_rotation("specialty_additionalprimaryweapon");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_electriccherry");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
	level.custom_random_perk_weights = &function_798c5d1a;
}

/*
	Name: function_798c5d1a
	Namespace: namespace_c491e335
	Checksum: 0x5B599423
	Offset: 0x4138
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function function_798c5d1a()
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
		ArrayInsert(temp_array, "specialty_electriccherry", 0);
	}
	temp_array = Array::randomize(temp_array);
	level._random_perk_machine_perk_list = Array::randomize(level._random_perk_machine_perk_list);
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = getArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}

/*
	Name: enemy_location_override
	Namespace: namespace_c491e335
	Checksum: 0x820A6223
	Offset: 0x42E8
	Size: 0x10D
	Parameters: 2
	Flags: None
*/
function enemy_location_override(ai_zombie, ai_enemy)
{
	AIProfile_BeginEntry("castle-enemy_location_override");
	if(isPlayer(ai_enemy) && ai_enemy zm_zonemgr::entity_in_zone("zone_undercroft") && (ai_enemy IsWallRunning() || !ai_enemy IsOnGround()))
	{
		if(!isdefined(ai_enemy.v_ground_pos))
		{
			ai_enemy thread function_d578bf1a();
		}
		if(isdefined(ai_enemy.v_ground_pos))
		{
			AIProfile_EndEntry();
			return ai_enemy.v_ground_pos;
		}
	}
	AIProfile_EndEntry();
	return undefined;
}

/*
	Name: function_d578bf1a
	Namespace: namespace_c491e335
	Checksum: 0x27EB61E7
	Offset: 0x4400
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function function_d578bf1a()
{
	self endon("death");
	while(self zm_zonemgr::entity_in_zone("zone_undercroft") && (self IsWallRunning() || !self IsOnGround()))
	{
		var_24ab58cb = GroundTrace(self.origin, self.origin + VectorScale((0, 0, -1), 10000), 0, undefined)["position"];
		self.v_ground_pos = GetClosestPointOnNavMesh(var_24ab58cb, 256);
		wait(0.5);
	}
	self.v_ground_pos = undefined;
}

/*
	Name: function_c7d8dba7
	Namespace: namespace_c491e335
	Checksum: 0x153EECDE
	Offset: 0x44F0
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function function_c7d8dba7()
{
	if(self.powerup_name === "castle_tram_token")
	{
		self clientfield::set("powerup_fuse_fx", 1);
	}
	else if(IsSubStr(self.powerup_name, "demonic_rune"))
	{
		self clientfield::set("demonic_rune_fx", 1);
	}
	else if(self.only_affects_grabber)
	{
		self clientfield::set("powerup_fx", 2);
	}
	else if(self.any_team)
	{
		self clientfield::set("powerup_fx", 4);
	}
	else if(self.zombie_grabbable)
	{
		self clientfield::set("powerup_fx", 3);
	}
	else
	{
		self clientfield::set("powerup_fx", 1);
	}
}

/*
	Name: function_632e15ea
	Namespace: namespace_c491e335
	Checksum: 0x83FCBBF4
	Offset: 0x4638
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_632e15ea()
{
	level thread function_814261d();
	level thread function_4da48892();
	level thread function_9c99c6db();
	level thread function_5dd2bbf1();
	var_b549e63 = GetEnt("great_hall_outer_door", "script_noteworthy");
	var_8907f940 = GetEnt("great_hall_inner_door", "script_noteworthy");
	var_8907f940 LinkTo(var_b549e63);
}

/*
	Name: function_814261d
	Namespace: namespace_c491e335
	Checksum: 0x780BDCF6
	Offset: 0x4720
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_814261d()
{
	level thread scene::init("p7_fxanim_zm_castle_barricade_great_hall_left_bundle");
	level thread scene::init("p7_fxanim_zm_castle_barricade_great_hall_right_bundle");
	exploder::exploder("fxexp_112");
	level flag::wait_till("connect_courtyard_to_greathall_upper");
	level thread scene::Play("p7_fxanim_zm_castle_barricade_great_hall_left_bundle");
	level thread scene::Play("p7_fxanim_zm_castle_barricade_great_hall_right_bundle");
	exploder::exploder_stop("fxexp_112");
}

/*
	Name: function_4da48892
	Namespace: namespace_c491e335
	Checksum: 0x1B8574A5
	Offset: 0x4800
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_4da48892()
{
	level thread scene::init("p7_fxanim_zm_castle_barricade_living_quart_bundle");
	exploder::exploder("fxexp_110");
	level flag::wait_till("connect_lowercourtyard_to_livingquarters");
	level thread scene::Play("p7_fxanim_zm_castle_barricade_living_quart_bundle");
	exploder::exploder_stop("fxexp_110");
}

/*
	Name: function_9c99c6db
	Namespace: namespace_c491e335
	Checksum: 0x8CB1DF24
	Offset: 0x48A0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_9c99c6db()
{
	level thread scene::init("p7_fxanim_zm_castle_barricade_trophy_room_bundle");
	exploder::exploder("fxexp_111");
	level flag::wait_till("connect_subclocktower_to_courtyard");
	level thread scene::Play("p7_fxanim_zm_castle_barricade_trophy_room_bundle");
	exploder::exploder_stop("fxexp_111");
}

/*
	Name: function_5dd2bbf1
	Namespace: namespace_c491e335
	Checksum: 0xAA40E61B
	Offset: 0x4940
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_5dd2bbf1()
{
	level flag::wait_till("power_on");
	e_door_clip = GetEnt("dungeon_door_clip", "targetname");
	e_door_clip delete();
	e_door_left = GetEnt("dungeon_door_left", "targetname");
	e_door_right = GetEnt("dungeon_door_right", "targetname");
	e_door_left MoveX(-40, 2, 0, 1);
	e_door_right MoveX(40, 2, 0, 1);
}

/*
	Name: function_8921895f
	Namespace: namespace_c491e335
	Checksum: 0x26DF79A3
	Offset: 0x4A58
	Size: 0x1AF
	Parameters: 0
	Flags: None
*/
function function_8921895f()
{
	var_cdb0f86b = getArrayKeys(level.zombie_powerups);
	var_b4442b55 = Array("bonus_points_team", "shield_charge", "ww_grenade", "demonic_rune_lor", "demonic_rune_mar", "demonic_rune_oth", "demonic_rune_uja", "demonic_rune_ulla", "demonic_rune_zor");
	var_d7a75a6e = [];
	for(i = 0; i < var_cdb0f86b.size; i++)
	{
		var_77917a61 = 0;
		foreach(var_68de493a in var_b4442b55)
		{
			if(var_cdb0f86b[i] == var_68de493a)
			{
				var_77917a61 = 1;
			}
		}
		if(var_77917a61)
		{
			continue;
			continue;
		}
		var_d7a75a6e[var_d7a75a6e.size] = var_cdb0f86b[i];
	}
	var_d7a75a6e = Array::randomize(var_d7a75a6e);
	return var_d7a75a6e[0];
}

/*
	Name: function_98a0818e
	Namespace: namespace_c491e335
	Checksum: 0xE78157FE
	Offset: 0x4C10
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function function_98a0818e()
{
	if(isdefined(self.var_122a2dda) && self.var_122a2dda || (isdefined(self.var_9a017681) && self.var_9a017681) || (isdefined(self.var_c7a6615d) && self.var_c7a6615d))
	{
		return 0;
	}
	if(isdefined(self.b_teleporting) && self.b_teleporting)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_869d6f66
	Namespace: namespace_c491e335
	Checksum: 0x83B36AFF
	Offset: 0x4C88
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_869d6f66()
{
	if(!isdefined(self namespace_93b7f03::function_728dfe3()))
	{
		return 0;
	}
	if(level flag::get("boss_fight_begin") && !level flag::get("boss_fight_completed"))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_d9e1ec4d
	Namespace: namespace_c491e335
	Checksum: 0x5D82E55D
	Offset: 0x4D00
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function function_d9e1ec4d(var_bbf77908)
{
	if(level flag::get("rocket_firing"))
	{
		var_ea555b15 = struct::get("zone_v10_pad_exterior", "script_noteworthy");
		ArrayRemoveValue(var_bbf77908, var_ea555b15);
	}
	return var_bbf77908;
}

/*
	Name: function_6190ec3f
	Namespace: namespace_c491e335
	Checksum: 0x6767E5C3
	Offset: 0x4D80
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_6190ec3f()
{
	var_3592813c = GetEnt("player_tram_car_interior", "targetname");
	var_a799f077 = GetEnt("docked_tram_car_interior", "targetname");
	if(!IsPointOnNavMesh(self.origin, self) || self istouching(var_3592813c) || self istouching(var_a799f077))
	{
		self thread zm_equipment::show_hint_text(&"ZM_CASTLE_GRAVITYSPIKE_BAD_LOCATION", 3);
		return 0;
	}
	return 1;
}

/*
	Name: function_77b8a0f7
	Namespace: namespace_c491e335
	Checksum: 0x65FBFF6C
	Offset: 0x4E68
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function function_77b8a0f7(var_2f7fd5db, n_points)
{
	if(!isdefined(n_points))
	{
		return 0;
	}
	if(var_2f7fd5db === GetWeapon("hero_gravityspikes_melee") && n_points > 20)
	{
		n_points = 20;
	}
	return n_points;
}

/*
	Name: function_5a64329b
	Namespace: namespace_c491e335
	Checksum: 0x9DA01FF
	Offset: 0x4ED0
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function function_5a64329b(var_2f7fd5db, n_points)
{
	if(var_2f7fd5db === GetWeapon("hero_gravityspikes_melee"))
	{
		n_points = 0;
	}
	return n_points;
}

/*
	Name: no_target_override
	Namespace: namespace_c491e335
	Checksum: 0x56E64A74
	Offset: 0x4F20
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function no_target_override(ai_zombie)
{
	if(isdefined(self.var_c74f5ce8) && self.var_c74f5ce8)
	{
		return;
	}
	var_b52b26b9 = ai_zombie get_escape_position();
	ai_zombie thread function_dc683d01(var_b52b26b9);
}

/*
	Name: get_escape_position
	Namespace: namespace_c491e335
	Checksum: 0x1D9C2041
	Offset: 0x4F90
	Size: 0x145
	Parameters: 0
	Flags: Private
*/
function private get_escape_position()
{
	str_zone = zm_zonemgr::get_zone_from_position(self.origin + VectorScale((0, 0, 1), 32), 1);
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		a_zones = namespace_f59aa2e8::get_adjacencies_to_zone(str_zone);
		a_wait_locations = get_wait_locations_in_zones(a_zones);
		ArraySortClosest(a_wait_locations, self.origin);
		a_wait_locations = Array::reverse(a_wait_locations);
		for(i = 0; i < a_wait_locations.size; i++)
		{
			if(a_wait_locations[i] function_eadbcbdb())
			{
				return a_wait_locations[i].origin;
			}
		}
	}
	return self.origin;
}

/*
	Name: get_wait_locations_in_zones
	Namespace: namespace_c491e335
	Checksum: 0xDDE154DA
	Offset: 0x50E0
	Size: 0xD1
	Parameters: 1
	Flags: Private
*/
function private get_wait_locations_in_zones(a_zones)
{
	a_wait_locations = [];
	foreach(zone in a_zones)
	{
		a_wait_locations = ArrayCombine(a_wait_locations, level.zones[zone].a_loc_types["wait_location"], 0, 0);
	}
	return a_wait_locations;
}

/*
	Name: function_eadbcbdb
	Namespace: namespace_c491e335
	Checksum: 0x7D5CAA67
	Offset: 0x51C0
	Size: 0x5D
	Parameters: 0
	Flags: Private
*/
function private function_eadbcbdb()
{
	if(!isdefined(self))
	{
		return 0;
	}
	if(!IsPointOnNavMesh(self.origin) || !zm_utility::check_point_in_playable_area(self.origin))
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

/*
	Name: function_dc683d01
	Namespace: namespace_c491e335
	Checksum: 0x65126481
	Offset: 0x5228
	Size: 0xC9
	Parameters: 1
	Flags: Private
*/
function private function_dc683d01(var_b52b26b9)
{
	self endon("death");
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self.ignoreall = 1;
	self.var_c74f5ce8 = 1;
	self thread check_player_available();
	self SetGoal(var_b52b26b9);
	self util::waittill_any_timeout(30, "goal", "reaquire_player", "death");
	self.ai_state = "find_flesh";
	self.ignoreall = 0;
	self.var_c74f5ce8 = undefined;
}

/*
	Name: check_player_available
	Namespace: namespace_c491e335
	Checksum: 0xE2BF1D0C
	Offset: 0x5300
	Size: 0x77
	Parameters: 0
	Flags: Private
*/
function private check_player_available()
{
	self endon("death");
	while(isdefined(self.var_c74f5ce8) && self.var_c74f5ce8)
	{
		wait(RandomFloatRange(0.2, 0.5));
		if(self can_zombie_see_any_player())
		{
			self.var_c74f5ce8 = undefined;
			self notify("reaquire_player");
			return;
		}
	}
}

/*
	Name: can_zombie_see_any_player
	Namespace: namespace_c491e335
	Checksum: 0xA9A4174B
	Offset: 0x5380
	Size: 0x7F
	Parameters: 0
	Flags: Private
*/
function private can_zombie_see_any_player()
{
	for(i = 0; i < level.activePlayers.size; i++)
	{
		if(zombie_utility::is_player_valid(level.activePlayers[i]))
		{
			if(self namespace_e9d5a0ce::function_7b63bf24(level.activePlayers[i]))
			{
				return 1;
			}
		}
		wait(0.1);
	}
	return 0;
}

/*
	Name: function_c624f0b2
	Namespace: namespace_c491e335
	Checksum: 0x94DB125E
	Offset: 0x5408
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_c624f0b2(a_spots)
{
	if(math::cointoss())
	{
		if(!isdefined(level.n_player_spawn_selection_index))
		{
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if(level.n_player_spawn_selection_index > level.players.size - 1)
		{
			level.n_player_spawn_selection_index = 0;
		}
		if(!zm_utility::is_player_valid(e_player))
		{
			s_spot = Array::random(a_spots);
			return s_spot;
		}
		var_e8c67fc0 = Array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		if(var_e8c67fc0.size)
		{
			s_spot = Array::random(var_e8c67fc0);
		}
		else
		{
			s_spot = Array::random(a_spots);
		}
	}
	else
	{
		s_spot = Array::random(a_spots);
	}
	return s_spot;
}

/*
	Name: function_69573a4c
	Namespace: namespace_c491e335
	Checksum: 0x48CFDB36
	Offset: 0x5580
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_69573a4c()
{
	scene::add_scene_func("p7_fxanim_gp_raven_idle_eating_bundle", &function_f7046db2, "play");
}

/*
	Name: function_f7046db2
	Namespace: namespace_c491e335
	Checksum: 0x344EA73A
	Offset: 0x55C0
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function function_f7046db2(a_ents)
{
	var_9be38c79 = a_ents["raven_idle"];
	if(isdefined(var_9be38c79))
	{
		var_9be38c79 SetCanDamage(1);
		var_9be38c79.health = 100000;
		var_9be38c79 thread function_a8aef7fe();
		var_9be38c79 waittill("damage", n_amount, e_attacker, v_direction, v_point, str_type);
		var_9be38c79 playsound("amb_castle_raven_death");
		PlayFXOnTag(level._effect["raven_death_fx"], var_9be38c79, "j_pelvis");
		PlayFXOnTag(level._effect["raven_feather_fx"], var_9be38c79, "j_pelvis");
		util::wait_network_frame();
		var_9be38c79 delete();
	}
}

/*
	Name: function_a8aef7fe
	Namespace: namespace_c491e335
	Checksum: 0x7A570D8A
	Offset: 0x5730
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_a8aef7fe()
{
	self endon("damage");
	self endon("death");
	wait(randomIntRange(3, 9));
	while(1)
	{
		self playsound("amb_castle_raven_caw");
		wait(randomIntRange(11, 21));
	}
}

/*
	Name: function_6058f34d
	Namespace: namespace_c491e335
	Checksum: 0x9AE15467
	Offset: 0x57B0
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function function_6058f34d()
{
	exploder::exploder("power_door_lgts");
	level flag::wait_till("power_on");
	exploder::exploder("exp_lgt_power_on");
	exploder::exploder("lgt_vending_doubletap2_castle");
	exploder::exploder("lgt_vending_juggernaut_castle");
	exploder::exploder("lgt_vending_mule_kick_castle");
	exploder::exploder("lgt_vending_quick_revive_castle");
	exploder::exploder("lgt_vending_sleight_of_hand_castle");
	exploder::exploder("lgt_vending_stamina_up_castle");
	playsoundatposition("zmb_castle_poweron", (0, 0, 0));
	exploder::exploder_stop("power_door_lgts");
	level thread scene::Play("p7_fxanim_zm_castle_door_sliding_bundle");
}

/*
	Name: function_a691b3f6
	Namespace: namespace_c491e335
	Checksum: 0x6720595F
	Offset: 0x58F8
	Size: 0x1E1
	Parameters: 0
	Flags: None
*/
function function_a691b3f6()
{
	level scene::init("p7_fxanim_zm_castle_rocket_01_bundle");
	level scene::add_scene_func("p7_fxanim_zm_castle_rocket_01_bundle", &function_7aae0fb2, "play");
	level waittill("hash_59e5a3dd");
	level thread scene::Play("p7_fxanim_zm_castle_rocket_01_bundle");
	level waittill("start_of_round");
	var_d16e2136 = struct::get_array("initial_spawn_points");
	foreach(player in level.players)
	{
		player zm_utility::create_streamer_hint(var_d16e2136[0].origin, var_d16e2136[0].angles, 1);
	}
	wait(9);
	foreach(player in level.players)
	{
		player zm_utility::clear_streamer_hint();
	}
}

/*
	Name: function_7aae0fb2
	Namespace: namespace_c491e335
	Checksum: 0xBFED8C71
	Offset: 0x5AE8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_7aae0fb2(a_ents)
{
	Array::run_all(level.players, &PlayRumbleOnEntity, "zm_castle_opening_rocket_launch");
}

/*
	Name: power_electric_switch
	Namespace: namespace_c491e335
	Checksum: 0x79765153
	Offset: 0x5B30
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function power_electric_switch()
{
	level scene::init("p7_fxanim_zm_power_switch_bundle");
	trig = GetEnt("use_power_switch", "targetname");
	trig setHintString(&"ZOMBIE_ELECTRIC_SWITCH");
	trig setcursorhint("HINT_NOICON");
	cheat = 0;
	User = undefined;
	if(cheat != 1)
	{
		trig waittill("trigger", User);
		if(isdefined(User))
		{
			User zm_audio::create_and_play_dialog("general", "power_on");
		}
	}
	level thread scene::Play("power_switch", "targetname");
	level flag::set("power_on");
	util::clientNotify("ZPO");
	util::wait_network_frame();
	wait(1);
	exploder::exploder("fxexp_400");
	FORWARD = AnglesToForward(trig.origin);
	playFX(level._effect["switch_sparks"], trig.origin, FORWARD);
	trig delete();
}

/*
	Name: function_639f3b62
	Namespace: namespace_c491e335
	Checksum: 0xF2DA1BE7
	Offset: 0x5D40
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_639f3b62()
{
	self thread namespace_8e89abe3::function_3ccd9604();
}

/*
	Name: function_30cebef9
	Namespace: namespace_c491e335
	Checksum: 0xC4A7C3FA
	Offset: 0x5D68
	Size: 0x2C3
	Parameters: 0
	Flags: None
*/
function function_30cebef9()
{
	if(level flag::get("power_on"))
	{
		exploder::exploder("exp_lgt_power_on");
		exploder::exploder("lgt_vending_doubletap2_castle");
		exploder::exploder("lgt_vending_juggernaut_castle");
		exploder::exploder("lgt_vending_mule_kick_castle");
		exploder::exploder("lgt_vending_quick_revive_castle");
		exploder::exploder("lgt_vending_sleight_of_hand_castle");
		exploder::exploder("lgt_vending_stamina_up_castle");
		exploder::exploder("fxexp_400");
		exploder::exploder("fxexp_710");
		exploder::exploder("fxexp_720");
		if(!level flag::get("tesla_coil_on"))
		{
			exploder::exploder("lgt_deathray_green");
		}
		exploder::exploder("fxexp_100");
		if(level flag::get("castle_teleporter_used") && !level flag::get("rocket_firing"))
		{
			exploder::exploder("lgt_rocket_green");
		}
	}
	else
	{
		exploder::exploder("power_door_lgts");
	}
	if(level flag::get("upper_courtyard_pad_flag"))
	{
		exploder::exploder("lgt_upper_courtyard_nolink");
	}
	if(level flag::get("lower_courtyard_pad_flag"))
	{
		exploder::exploder("lgt_lower_courtyard_nolink");
	}
	if(level flag::get("rooftop_pad_flag"))
	{
		exploder::exploder("lgt_roof_nolink");
	}
	if(level flag::get("v10_rocket_pad_flag"))
	{
		exploder::exploder("lgt_v10_nolink");
	}
}

/*
	Name: function_a6477691
	Namespace: namespace_c491e335
	Checksum: 0x99D6D678
	Offset: 0x6038
	Size: 0x277
	Parameters: 0
	Flags: None
*/
function function_a6477691()
{
	level waittill("start_zombie_round_logic");
	sndent = spawn("script_origin", (611, 3496, 699));
	sndent PlayLoopSound("zmb_projector_hum", 0.25);
	while(1)
	{
		exploder::exploder("lgt_castle_slide_one");
		sndent playsound("zmb_projector_slide");
		wait(RandomFloatRange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_one");
		exploder::exploder("lgt_castle_slide_two");
		sndent playsound("zmb_projector_slide");
		wait(RandomFloatRange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_two");
		exploder::exploder("lgt_castle_slide_three");
		sndent playsound("zmb_projector_slide");
		wait(RandomFloatRange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_three");
		exploder::exploder("lgt_castle_slide_four");
		sndent playsound("zmb_projector_slide");
		wait(RandomFloatRange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_four");
		exploder::exploder("lgt_castle_slide_five");
		sndent playsound("zmb_projector_slide");
		wait(RandomFloatRange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_five");
	}
}

/*
	Name: function_555e8704
	Namespace: namespace_c491e335
	Checksum: 0xE212D569
	Offset: 0x62B8
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_555e8704()
{
	switch(self.unitrigger_stub.in_zone)
	{
		case "zone_v10_pad_door":
		{
			str_exploder = "fxexp_900";
			break;
		}
		case "zone_clocktower_rooftop":
		{
			str_exploder = "fxexp_901";
			break;
		}
		case "zone_lower_courtyard_back":
		{
			str_exploder = "fxexp_902";
			break;
		}
		case "zone_living_quarters":
		{
			str_exploder = "fxexp_903";
			break;
		}
		case "zone_great_hall_upper_left":
		{
			str_exploder = "fxexp_904";
			break;
		}
	}
	exploder::exploder(str_exploder);
	while(self.State == "idle")
	{
		wait(0.05);
	}
	exploder::exploder_stop(str_exploder);
}

/*
	Name: function_9be4ecd1
	Namespace: namespace_c491e335
	Checksum: 0x5C45C447
	Offset: 0x63B8
	Size: 0x211
	Parameters: 0
	Flags: None
*/
function function_9be4ecd1()
{
	n_start_time = undefined;
	while(1)
	{
		if(level.zombie_total <= 0)
		{
			a_zombies = GetAITeamArray(level.zombie_team);
			var_565450eb = zombie_utility::get_current_zombie_count();
			if(var_565450eb <= 3 && level.round_number > 3)
			{
				a_zombies = GetAITeamArray(level.zombie_team);
				foreach(e_zombie in a_zombies)
				{
					if(e_zombie.zombie_move_speed == "walk")
					{
						e_zombie zombie_utility::set_zombie_run_cycle("run");
					}
				}
			}
			else if(var_565450eb == 1)
			{
				if(!isdefined(n_start_time))
				{
					n_start_time = GetTime();
				}
				n_time = GetTime();
				var_be13851f = n_time - n_start_time / 1000;
				if(var_be13851f >= 25)
				{
					a_zombies[0] zombie_utility::set_zombie_run_cycle("sprint");
					util::waittill_any_ents(self, "death", level, "start_of_round");
				}
			}
			else
			{
				n_start_time = undefined;
			}
		}
		wait(1);
	}
}

/*
	Name: setup_personality_character_exerts
	Namespace: namespace_c491e335
	Checksum: 0x378C0534
	Offset: 0x65D8
	Size: 0x621
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitmed"][4] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitmed"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitmed"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitmed"][4] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitlrg"][4] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitlrg"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitlrg"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitlrg"][4] = "vox_plr_3_exert_pain_4";
}

/*
	Name: function_13fc99fa
	Namespace: namespace_c491e335
	Checksum: 0xFE088D48
	Offset: 0x6C08
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_13fc99fa()
{
	zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", 3);
	level flag::wait_till("start_zombie_round_logic");
	while(level.round_number < 10)
	{
		level waittill("between_round_over");
	}
	zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", 4);
}

/*
	Name: function_ec8a9331
	Namespace: namespace_c491e335
	Checksum: 0xCD4BD18A
	Offset: 0x6C98
	Size: 0x7B
	Parameters: 12
	Flags: None
*/
function function_ec8a9331(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(self.archetype == "mechz")
	{
		return 0;
	}
}

/*
	Name: function_2449723c
	Namespace: namespace_c491e335
	Checksum: 0xFDEDA4C4
	Offset: 0x6D20
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_2449723c()
{
	/#
		if(isdefined(self.var_8665ab89))
		{
			if(self.var_8665ab89 == GetTime())
			{
				return 1;
			}
		}
		self.var_8665ab89 = GetTime();
		return 0;
	#/
}

/*
	Name: function_287ae5ec
	Namespace: namespace_c491e335
	Checksum: 0xC27BA03
	Offset: 0x6D60
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_287ae5ec()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_f04119b5);
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_f04119b5
	Namespace: namespace_c491e335
	Checksum: 0x65ACB937
	Offset: 0x6DD0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function function_f04119b5(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level thread function_7f27602f();
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: function_7f27602f
	Namespace: namespace_c491e335
	Checksum: 0xF773CC0B
	Offset: 0x6E40
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function function_7f27602f()
{
	/#
		zm_devgui::zombie_devgui_open_sesame();
		level flag::set("Dev Block strings are not supported");
		var_15ed352b = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		foreach(var_3b9a12e0 in var_15ed352b)
		{
			var_3b9a12e0 delete();
		}
		level notify("hash_854ff4f5");
		var_a6e47643 = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
		Array::thread_all(var_a6e47643, &function_e9162f72);
	#/
}

/*
	Name: function_e9162f72
	Namespace: namespace_c491e335
	Checksum: 0x83D1C7DB
	Offset: 0x6F90
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_e9162f72()
{
	/#
		var_1143aa58 = GetEnt(self.target, "Dev Block strings are not supported");
		var_9ca35935 = self.script_noteworthy;
		level flag::set(var_9ca35935);
		var_1143aa58 SetModel("Dev Block strings are not supported");
	#/
}

