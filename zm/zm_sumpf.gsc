#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_net;
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
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_sumpf_achievements;
#using scripts\zm\zm_sumpf_ffotd;
#using scripts\zm\zm_sumpf_fx;
#using scripts\zm\zm_sumpf_magic_box;
#using scripts\zm\zm_sumpf_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace namespace_e722cafc;

/*
	Name: opt_in
	Namespace: namespace_e722cafc
	Checksum: 0x6C36654
	Offset: 0x11A0
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
	Namespace: namespace_e722cafc
	Checksum: 0xC368B186
	Offset: 0x11C8
	Size: 0x68B
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread zm_sumpf_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	level.use_water_risers = 1;
	level.sndZHDAudio = 1;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	zm_sumpf_fx::main();
	zm::init_fx();
	level._zmbVoxLevelSpecific = &init_level_specific_audio;
	level.randomize_perks = 0;
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = 0;
	level.door_dialog_function = &zm::play_door_dialog;
	level.dogs_enabled = 1;
	level.zombie_rise_spawners = [];
	level.burning_zombies = [];
	level.use_zombie_heroes = 1;
	level.kzmb_name = "sumpf_kzmb";
	level.custom_ai_type = [];
	if(!isdefined(level.custom_ai_type))
	{
		level.custom_ai_type = [];
	}
	else if(!IsArray(level.custom_ai_type))
	{
		level.custom_ai_type = Array(level.custom_ai_type);
	}
	level.custom_ai_type[level.custom_ai_type.size] = &zm_ai_dogs::init;
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.use_zombie_heroes = 1;
	level.giveCustomCharacters = &giveCustomCharacters;
	initCharacterStartIndex();
	level._round_start_func = &zm::round_start;
	level._effect["zombie_grain"] = "misc/fx_zombie_grain_cloud";
	init_zombie_sumpf();
	clientfield::register("world", "SUMPF_VISIONSET_DOGS", 21000, 1, "int");
	clientfield::register("actor", "zombie_flogger_trap", 21000, 1, "int");
	clientfield::register("allplayers", "player_legs_hide", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
	include_perks_in_random_rotation();
	load::main();
	level.default_laststandpistol = GetWeapon("pistol_m1911");
	level.default_solo_laststandpistol = GetWeapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	function_12859198();
	level thread zm_perks::spare_change();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_tesla::init();
	zm_ai_dogs::enable_dog_rounds();
	level.zones = [];
	level.zone_manager_init_func = &sumpf_zone_init;
	init_zones[0] = "center_building_upstairs";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.zombie_ai_limit = 24;
	level.validate_poi_attractors = 1;
	level thread water_burst_overwrite();
	/#
		level.custom_devgui = &sumpf_devgui;
	#/
	init_sounds();
	level thread setupMusic();
	level notify("setup_rope");
	level.has_pack_a_punch = 0;
	setculldist(2400);
	/#
		display_traversals();
	#/
	SetDvar("sv_maxPhysExplosionSpheres", 15);
	SetDvar("r_lightGridEnableTweaks", 1);
	SetDvar("r_lightGridIntensity", 1.25);
	SetDvar("r_lightGridContrast", 0.1);
	level thread watch_for_dogs();
	turn_power_on();
	level thread function_5b94e922();
	SetDvar("player_shallowWaterWadeScale", 0.55);
	SetDvar("player_waistWaterWadeScale", 0.55);
	scene::add_scene_func("p7_fxanim_zm_sumpf_zipline_down_bundle", &function_b87f949f, "init");
	level scene::init("p7_fxanim_zm_sumpf_zipline_down_bundle");
	level.zm_bgb_anywhere_but_here_validation_override = &anywhere_but_here_validation_override;
	level.var_9cef605e = &function_3e7eb37b;
	level thread zm_sumpf_ffotd::main_end();
}

/*
	Name: function_12859198
	Namespace: namespace_e722cafc
	Checksum: 0x38AF74B4
	Offset: 0x1860
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function function_12859198()
{
	level._effect["doubletap2_light"] = "dlc5/zmhd/fx_perk_doubletap";
	level._effect["jugger_light"] = "dlc5/zmhd/fx_perk_juggernaut";
	level._effect["revive_light"] = "dlc5/zmhd/fx_perk_quick_revive";
	level._effect["sleight_light"] = "dlc5/zmhd/fx_perk_sleight_of_hand";
	level._effect["additionalprimaryweapon_light"] = "dlc5/zmhd/fx_perk_mule_kick";
}

/*
	Name: function_b87f949f
	Namespace: namespace_e722cafc
	Checksum: 0x4563A656
	Offset: 0x18F8
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function function_b87f949f(a_ents)
{
	foreach(ent in a_ents)
	{
		ent SetIgnorePauseWorld(1);
	}
}

/*
	Name: function_5b94e922
	Namespace: namespace_e722cafc
	Checksum: 0xF876005E
	Offset: 0x1998
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function function_5b94e922()
{
	level endon("end_game");
	var_6c4e714 = struct::get_array("hanging_dead_guy_force", "targetname");
	n_index = 0;
	while(1)
	{
		while(!(isdefined(zm_zonemgr::any_player_in_zone("center_building_upstairs")) && zm_zonemgr::any_player_in_zone("center_building_upstairs")))
		{
			wait(0.1);
		}
		PhysicsExplosionSphere(var_6c4e714[n_index].origin + VectorScale((0, 1, 0), 5), 20, 10, 0.09);
		n_index++;
		if(n_index >= var_6c4e714.size)
		{
			n_index = 0;
		}
		wait(1);
	}
}

/*
	Name: anywhere_but_here_validation_override
	Namespace: namespace_e722cafc
	Checksum: 0xE2514886
	Offset: 0x1AB0
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function anywhere_but_here_validation_override()
{
	if(!isdefined(self zm_bgb_anywhere_but_here::function_728dfe3()))
	{
		return 0;
	}
	if(isdefined(self.on_zipline) && self.on_zipline)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_3e7eb37b
	Namespace: namespace_e722cafc
	Checksum: 0xB3091B18
	Offset: 0x1B00
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_3e7eb37b()
{
	if(isdefined(self.on_zipline) && self.on_zipline)
	{
		return 0;
	}
	return 1;
}

/*
	Name: turn_power_on
	Namespace: namespace_e722cafc
	Checksum: 0x91CFAC1E
	Offset: 0x1B30
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function turn_power_on()
{
	level flag::wait_till("start_zombie_round_logic");
	zm_power::turn_power_on_and_open_doors();
}

/*
	Name: watch_for_dogs
	Namespace: namespace_e722cafc
	Checksum: 0x5D6F3231
	Offset: 0x1B70
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function watch_for_dogs()
{
	while(1)
	{
		level flag::wait_till("dog_round");
		level clientfield::set("SUMPF_VISIONSET_DOGS", 1);
		level waittill("dog_round_ending");
		level clientfield::set("SUMPF_VISIONSET_DOGS", 0);
	}
}

/*
	Name: giveCustomCharacters
	Namespace: namespace_e722cafc
	Checksum: 0x5D443CFC
	Offset: 0x1BF0
	Size: 0x2F3
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
			self.characterindex = GetDvarInt("Dev Block strings are not supported");
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
			break;
		}
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("870mcs");
			break;
		}
		case 2:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("hk416");
			break;
		}
		case 3:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndRadioA = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("pistol_standard");
			break;
		}
	}
	level.vox zm_audio::zmbVoxInitSpeaker("player", "vox_plr_", self);
	self thread zm_audio_zhd::set_exert_id();
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: namespace_e722cafc
	Checksum: 0x8AA33263
	Offset: 0x1EF0
	Size: 0x153
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
	if(level.players.size == 1)
	{
		charindexarray = Array::randomize(charindexarray);
		return charindexarray[0];
	}
	else
	{
		foreach(player in level.players)
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
	Name: initCharacterStartIndex
	Namespace: namespace_e722cafc
	Checksum: 0x2D2005F8
	Offset: 0x2050
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
	Namespace: namespace_e722cafc
	Checksum: 0xDEBA4C3
	Offset: 0x2080
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
	Name: sumpf_zone_init
	Namespace: namespace_e722cafc
	Checksum: 0x2B8358A
	Offset: 0x20C8
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function sumpf_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs", "center_building_upstairs_buy", "unlock_hospital_upstairs");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs", "center_building_combined", "unlock_hospital_downstairs");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs_buy", "center_building_combined", "unlock_hospital_upstairs");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs_buy", "center_building_combined", "unlock_hospital_downstairs");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "northeast_outside", "ne_magic_box");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "northwest_outside", "nw_magic_box");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "southeast_outside", "se_magic_box");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "southwest_outside", "sw_magic_box");
	zm_zonemgr::add_adjacent_zone("northeast_outside", "northeast_building", "northeast_building_unlocked");
	zm_zonemgr::add_adjacent_zone("northwest_outside", "northwest_building", "northwest_building_unlocked");
	zm_zonemgr::add_adjacent_zone("southeast_outside", "southeast_building", "southeast_building_unlocked");
	zm_zonemgr::add_adjacent_zone("southwest_outside", "southwest_building", "southwest_building_unlocked");
}

/*
	Name: init_sounds
	Namespace: namespace_e722cafc
	Checksum: 0xFBF69BC8
	Offset: 0x22F8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function init_sounds()
{
	zm_utility::add_sound("zmb_wooden_door", "zmb_door_wood_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
	level thread custom_add_vox();
	level.vox_response_override = 1;
	/#
		IPrintLnBold("Dev Block strings are not supported");
	#/
	level thread phone_useage();
	level thread hut_radios();
	level thread function_34a348fc();
	level thread function_8aa785e();
	level thread radio_eggs();
	level thread meteor_trigger();
	level thread book_useage();
	level thread super_egg();
	level thread function_d166ac07();
}

/*
	Name: setupMusic
	Namespace: namespace_e722cafc
	Checksum: 0xF14133FB
	Offset: 0x2460
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function setupMusic()
{
	zm_audio::musicState_Create("round_start", 3, "sumpf_roundstart_1", "sumpf_roundstart_2", "sumpf_roundstart_3", "sumpf_roundstart_4");
	zm_audio::musicState_Create("round_start_short", 3, "sumpf_roundstart_1", "sumpf_roundstart_2", "sumpf_roundstart_3", "sumpf_roundstart_4");
	zm_audio::musicState_Create("round_start_first", 3, "sumpf_roundstart_1", "sumpf_roundstart_2", "sumpf_roundstart_3", "sumpf_roundstart_4");
	zm_audio::musicState_Create("round_end", 3, "sumpf_roundend_1", "sumpf_roundend_2", "sumpf_roundend_3", "sumpf_roundend_4");
	zm_audio::musicState_Create("dog_start", 3, "dog_start_1");
	zm_audio::musicState_Create("dog_end", 3, "dog_end_1");
	zm_audio::musicState_Create("the_one", 4, "the_one");
	zm_audio::musicState_Create("game_over", 5, "game_over_zhd_sumpf");
	zm_audio::musicState_Create("none", 4, "none");
	zm_audio::musicState_Create("sam", 4, "sam");
}

/*
	Name: offhand_weapon_overrride
	Namespace: namespace_e722cafc
	Checksum: 0x9DE34E95
	Offset: 0x2660
	Size: 0xA5
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
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: custom_add_weapons
	Namespace: namespace_e722cafc
	Checksum: 0xF164470D
	Offset: 0x2710
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_sumpf_weapons.csv", 1);
}

/*
	Name: custom_add_vox
	Namespace: namespace_e722cafc
	Checksum: 0xC7A0E312
	Offset: 0x2740
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_prototype_vox.csv");
}

/*
	Name: init_zombie_sumpf
	Namespace: namespace_e722cafc
	Checksum: 0xDDA96718
	Offset: 0x2768
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function init_zombie_sumpf()
{
	thread zm_sumpf_magic_box::magic_box_init();
	zipHintDeactivated = GetEnt("zipline_deactivated_hint_trigger", "targetname");
	zipHintDeactivated setHintString(&"ZOMBIE_ZIPLINE_DEACTIVATED");
	zipHintDeactivated setcursorhint("HINT_NOICON");
}

/*
	Name: turnLightGreen
	Namespace: namespace_e722cafc
	Checksum: 0xE1D77230
	Offset: 0x27F0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function turnLightGreen(name)
{
	str_light_red = name + "_red";
	str_light_green = name + "_green";
	exploder::stop_exploder(str_light_red);
	exploder::exploder(str_light_green);
}

/*
	Name: turnLightRed
	Namespace: namespace_e722cafc
	Checksum: 0xF2F6A652
	Offset: 0x2870
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function turnLightRed(name)
{
	str_light_red = name + "_red";
	str_light_green = name + "_green";
	exploder::stop_exploder(str_light_green);
	exploder::exploder(str_light_red);
}

/*
	Name: book_useage
	Namespace: namespace_e722cafc
	Checksum: 0xC0A14D84
	Offset: 0x28F0
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function book_useage()
{
	book_counter = 0;
	book_trig = GetEnt("book_trig", "targetname");
	book_trig setcursorhint("HINT_NOICON");
	book_trig UseTriggerRequireLookAt();
	/#
		level thread debug_display_at_pos((11308, 3635, -582), "Dev Block strings are not supported", book_trig, "Dev Block strings are not supported");
	#/
	if(isdefined(book_trig))
	{
		maniac_l = GetEnt("maniac_l", "targetname");
		maniac_r = GetEnt("maniac_r", "targetname");
		book_trig waittill("trigger", player);
		if(isdefined(maniac_l))
		{
			maniac_l playsound("evt_maniac_l");
		}
		if(isdefined(maniac_r))
		{
			maniac_r playsound("evt_maniac_r");
		}
	}
}

/*
	Name: phone_useage
	Namespace: namespace_e722cafc
	Checksum: 0xC4F8591F
	Offset: 0x2A78
	Size: 0x2DB
	Parameters: 0
	Flags: None
*/
function phone_useage()
{
	s_phone_egg = struct::get("s_phone_egg", "targetname");
	if(!isdefined(s_phone_egg))
	{
		return;
	}
	s_phone_egg zm_unitrigger::create_unitrigger(undefined, 256);
	var_e5549a81 = spawn("script_origin", s_phone_egg.origin);
	var_fd0167be = 0;
	while(var_fd0167be < 4)
	{
		s_phone_egg waittill("trigger_activated");
		if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || (isdefined(level.musicSystemOverride) && level.musicSystemOverride))
		{
			continue;
		}
		else
		{
			switch(var_fd0167be)
			{
				case 0:
				{
					var_e5549a81 PlayLoopSound("evt_phone_dialtone");
					wait(1);
					break;
				}
				case 1:
				{
					var_e5549a81 StopLoopSound(0.5);
					var_e5549a81 playsound("evt_dial_9");
					wait(0.25);
					break;
				}
				case 2:
				{
					var_e5549a81 playsound("evt_dial_1");
					wait(0.25);
					break;
				}
				case 3:
				{
					var_e5549a81 playsound("evt_dial_1");
					wait(0.5);
					var_e5549a81 playsound("evt_riiing");
					wait(2.5);
					var_e5549a81 playsound("evt_riiing");
					wait(2);
					var_e5549a81 playsound("evt_phone_answer");
					wait(3.7);
					break;
				}
			}
			var_fd0167be++;
		}
	}
	playsoundatposition("zmb_cha_ching", s_phone_egg.origin);
	zm_unitrigger::unregister_unitrigger(s_phone_egg.s_unitrigger);
	level thread zm_audio::sndMusicSystem_PlayState("the_one");
}

/*
	Name: play_radio_sounds
	Namespace: namespace_e722cafc
	Checksum: 0xF83522D0
	Offset: 0x2D60
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function play_radio_sounds()
{
	/#
		IPrintLnBold("Dev Block strings are not supported");
	#/
	pa_system = GetEnt("speaker_in_attic", "targetname");
	wait(0.05);
	pa_system PlaySoundWithNotify("evt_secret_message", "message_complete");
	pa_system waittill("message_complete");
}

/*
	Name: radio_eggs
	Namespace: namespace_e722cafc
	Checksum: 0x5309A920
	Offset: 0x2DF8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function radio_eggs()
{
	if(!isdefined(level.radio_counter))
	{
		level.radio_counter = 0;
	}
	while(level.radio_counter < 3)
	{
		wait(1);
	}
	level thread play_radio_sounds();
	/#
		IPrintLnBold("Dev Block strings are not supported");
	#/
}

/*
	Name: function_34a348fc
	Namespace: namespace_e722cafc
	Checksum: 0x33F5CE11
	Offset: 0x2E70
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function function_34a348fc()
{
	level.var_34a348fc = GetEntArray("super_egg_radio", "targetname");
	if(isdefined(level.var_34a348fc))
	{
		for(i = 0; i < level.var_34a348fc.size; i++)
		{
			level.var_34a348fc[i] thread function_53e56ac8();
		}
	}
}

/*
	Name: function_53e56ac8
	Namespace: namespace_e722cafc
	Checksum: 0x696F0A17
	Offset: 0x2F00
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_53e56ac8()
{
	if(!isdefined(level.superegg_counter))
	{
		level.superegg_counter = 0;
	}
	self zm_unitrigger::create_unitrigger(undefined, 128);
	/#
	#/
	self waittill("trigger_activated");
	self zm_unitrigger::unregister_unitrigger(self.unitrigger);
	level.superegg_counter = level.superegg_counter + 1;
	self PlayLoopSound(self.script_sound);
}

/*
	Name: play_super_egg_radio_pa_sounds
	Namespace: namespace_e722cafc
	Checksum: 0xB7978A4F
	Offset: 0x2FA0
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function play_super_egg_radio_pa_sounds()
{
	pa_system = GetEnt("speaker_in_attic", "targetname");
	wait(0.05);
	pa_system PlaySoundWithNotify("vox_superegg_secret_message", "message_complete");
	pa_system waittill("message_complete");
}

/*
	Name: super_egg
	Namespace: namespace_e722cafc
	Checksum: 0x79A48340
	Offset: 0x3018
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function super_egg()
{
	if(!isdefined(level.superegg_counter))
	{
		level.superegg_counter = 0;
	}
	while(level.superegg_counter < 3)
	{
		wait(2);
	}
	level thread play_super_egg_radio_pa_sounds();
}

/*
	Name: function_8aa785e
	Namespace: namespace_e722cafc
	Checksum: 0xAD290428
	Offset: 0x3070
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function function_8aa785e()
{
	level.var_34a348fc = GetEntArray("sur_radio", "targetname");
	if(isdefined(level.var_34a348fc))
	{
		for(i = 0; i < level.var_34a348fc.size; i++)
		{
			level.var_34a348fc[i] thread function_4deca569();
		}
	}
}

/*
	Name: function_4deca569
	Namespace: namespace_e722cafc
	Checksum: 0x80E30B38
	Offset: 0x3100
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_4deca569()
{
	if(!isdefined(level.superegg_counter))
	{
		level.superegg_counter = 0;
	}
	self thread zm_sidequests::fake_use("sur_radio_activated");
	/#
	#/
	self waittill("sur_radio_activated");
	self playsound(self.script_sound);
}

/*
	Name: hut_radios
	Namespace: namespace_e722cafc
	Checksum: 0x5747F54E
	Offset: 0x3178
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function hut_radios()
{
	level.hut_radios = GetEntArray("radio_hut", "targetname");
	if(isdefined(level.hut_radios))
	{
		for(i = 0; i < level.hut_radios.size; i++)
		{
			level.hut_radios[i] thread function_2fa9f915();
		}
	}
}

/*
	Name: function_2fa9f915
	Namespace: namespace_e722cafc
	Checksum: 0xF4B403B9
	Offset: 0x3208
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_2fa9f915()
{
	if(!isdefined(level.radio_counter))
	{
		level.radio_counter = 0;
	}
	self zm_unitrigger::create_unitrigger(undefined, 128);
	/#
	#/
	self waittill("trigger_activated");
	self zm_unitrigger::unregister_unitrigger(self.unitrigger);
	level.radio_counter = level.radio_counter + 1;
	self PlayLoopSound(self.script_sound);
}

/*
	Name: meteor_trigger
	Namespace: namespace_e722cafc
	Checksum: 0x3C850CBC
	Offset: 0x32A8
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function meteor_trigger()
{
	player = GetPlayers();
	level endon("meteor_triggered");
	dmgtrig = GetEnt("meteor", "targetname");
	/#
		level thread debug_display_at_pos((11260.5, -2091, -634), "Dev Block strings are not supported", dmgtrig, "Dev Block strings are not supported", 3);
	#/
	while(1)
	{
		dmgtrig waittill("trigger", player);
		if(DistanceSquared(player.origin, dmgtrig.origin) < 100000000)
		{
			player thread zm_audio::create_and_play_dialog("level", "meteor");
			level notify("meteor_triggered");
		}
		else
		{
			wait(0.1);
		}
	}
}

/*
	Name: setup_custom_vox
	Namespace: namespace_e722cafc
	Checksum: 0x99EC1590
	Offset: 0x33E8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function setup_custom_vox()
{
}

/*
	Name: sumpf_player_spawn_placement
	Namespace: namespace_e722cafc
	Checksum: 0x3C590FF5
	Offset: 0x33F8
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function sumpf_player_spawn_placement()
{
	structs = struct::get_array("initial_spawn_points", "targetname");
	level flag::wait_till("start_zombie_round_logic");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] SetOrigin(structs[i].origin);
		players[i] SetPlayerAngles(structs[i].angles);
		players[i].spectator_respawn = structs[i];
	}
}

/*
	Name: water_burst_overwrite
	Namespace: namespace_e722cafc
	Checksum: 0x7F38733D
	Offset: 0x3518
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function water_burst_overwrite()
{
	level waittill("between_round_over");
	level._effect["rise_burst_water"] = "maps/zombie/fx_zombie_body_wtr_burst_smpf";
	level._effect["rise_billow_water"] = "maps/zombie/fx_zombie_body_wtr_billow_smpf";
}

/*
	Name: sumpf_devgui
	Namespace: namespace_e722cafc
	Checksum: 0x11C803E8
	Offset: 0x3568
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function sumpf_devgui(cmd)
{
	/#
		cmd_strings = StrTok(cmd, "Dev Block strings are not supported");
		switch(cmd_strings[0])
		{
			case "Dev Block strings are not supported":
			{
				devgui_skipto_dog_round();
				break;
			}
			case "Dev Block strings are not supported":
			{
				devgui_activate_zipline();
				break;
			}
			case default:
			{
				break;
			}
		}
	#/
}

/*
	Name: devgui_skipto_dog_round
	Namespace: namespace_e722cafc
	Checksum: 0x4C98A1D5
	Offset: 0x3610
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function devgui_skipto_dog_round()
{
	/#
		if(level.round_number <= 1)
		{
			level flag::wait_till("Dev Block strings are not supported");
			iprintln("Dev Block strings are not supported");
			wait(12);
		}
		n_next_round = level.round_number + 1;
		level.next_dog_round = n_next_round;
		iprintln("Dev Block strings are not supported" + n_next_round);
		zm_devgui::zombie_devgui_goto_round(n_next_round);
		iprintln("Dev Block strings are not supported" + n_next_round);
	#/
}

/*
	Name: devgui_activate_zipline
	Namespace: namespace_e722cafc
	Checksum: 0x55AC1BA2
	Offset: 0x36F0
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function devgui_activate_zipline()
{
	/#
		t_zip_power_trig = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(isdefined(t_zip_power_trig))
		{
			zm_devgui::zombie_devgui_open_sesame();
			t_zip_power_trig notify("trigger", GetPlayers()[0]);
		}
	#/
}

/*
	Name: display_traversals
	Namespace: namespace_e722cafc
	Checksum: 0xB39A1A5
	Offset: 0x3770
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function display_traversals()
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
	Namespace: namespace_e722cafc
	Checksum: 0x860E7D40
	Offset: 0x3838
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
	Name: debug_display_at_pos
	Namespace: namespace_e722cafc
	Checksum: 0x5FB76797
	Offset: 0x3890
	Size: 0xD7
	Parameters: 5
	Flags: None
*/
function debug_display_at_pos(v_org, str_msg, e_ender, str_ender, n_scale)
{
	/#
		if(!isdefined(n_scale))
		{
			n_scale = 1;
		}
		e_ender endon(str_ender);
		level thread debug_display_end_msg(str_msg, e_ender, str_ender);
		v_display_org = v_org - VectorScale((0, 0, 1), 16);
		while(1)
		{
			print3d(v_display_org, "Dev Block strings are not supported", VectorScale((0, 1, 0), 255), 1, n_scale, 1);
			wait(0.1);
		}
	#/
}

/*
	Name: debug_display_end_msg
	Namespace: namespace_e722cafc
	Checksum: 0x4710426F
	Offset: 0x3970
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function debug_display_end_msg(str_msg, e_ender, str_ender)
{
	/#
		e_ender waittill(str_ender);
		IPrintLnBold(str_msg);
	#/
}

/*
	Name: init_level_specific_audio
	Namespace: namespace_e722cafc
	Checksum: 0x99EC1590
	Offset: 0x39C0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_level_specific_audio()
{
}

/*
	Name: function_d166ac07
	Namespace: namespace_e722cafc
	Checksum: 0xDA8C3352
	Offset: 0x39D0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_d166ac07()
{
	level.n_plate_count = 0;
	var_5e490b83 = GetEntArray("sndzhd_plates", "targetname");
	Array::thread_all(var_5e490b83, &function_4bb6626e);
}

/*
	Name: function_4bb6626e
	Namespace: namespace_e722cafc
	Checksum: 0x40D12982
	Offset: 0x3A40
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_4bb6626e()
{
	while(1)
	{
		self waittill("damage", damage, attacker, dir, loc, str_type, model, tag, part, weapon, flags);
		if(!isPlayer(attacker))
		{
			continue;
		}
		if(weapon != level.start_weapon)
		{
			continue;
		}
		if(str_type != "MOD_PISTOL_BULLET")
		{
			continue;
		}
		level.n_plate_count++;
		playsoundatposition("zmb_zhd_plate_hit", self.origin);
		break;
	}
	if(level.n_plate_count >= 4)
	{
		level flag::set("snd_zhdegg_activate");
	}
}

/*
	Name: include_perks_in_random_rotation
	Namespace: namespace_e722cafc
	Checksum: 0xED9A0A56
	Offset: 0x3B80
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
	Namespace: namespace_e722cafc
	Checksum: 0x5393DA01
	Offset: 0x3BF0
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

