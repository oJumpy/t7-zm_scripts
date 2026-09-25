#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
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
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_asylum_achievements;
#using scripts\zm\zm_asylum_ffotd;
#using scripts\zm\zm_asylum_fx;
#using scripts\zm\zm_asylum_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace namespace_f69b3b38;

/*
	Name: function_d9af860b
	Namespace: namespace_f69b3b38
	Checksum: 0xBBFD8A28
	Offset: 0x11F8
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_d9af860b()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.zbarrier_override = &function_aeabaa98;
	level.zbarrier_override_tear_in = &function_ee422b5c;
}

/*
	Name: main
	Namespace: namespace_f69b3b38
	Checksum: 0xBCE1E742
	Offset: 0x1250
	Size: 0x49B
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_1e5daa72::main_start();
	SetClearanceCeiling(17);
	level.sndZHDAudio = 1;
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	namespace_bf71ff59::main();
	init_clientfields();
	visionset_mgr::register_info("visionset", "zm_showerhead", 21000, 100, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	visionset_mgr::register_info("overlay", "zm_showerhead_postfx", 21000, 500, 32, 1);
	visionset_mgr::register_info("overlay", "zm_waterfall_postfx", 21000, 501, 32, 1);
	level._uses_sticky_grenades = 1;
	zm::init_fx();
	level._uses_retrievable_ballisitic_knives = 1;
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level._zmbVoxLevelSpecific = &init_level_specific_audio;
	level.customSpawnLogic = &function_91b06047;
	level._round_start_func = &zm::round_start;
	level.giveCustomCharacters = &giveCustomCharacters;
	initCharacterStartIndex();
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level.CustomRandomWeaponWeights = &function_659c2324;
	level.var_12d3a848 = 0;
	level.customHudReveal = &customHudReveal;
	include_perks_in_random_rotation();
	level flag::init("intro_finished");
	load::main();
	level.default_laststandpistol = GetWeapon("pistol_m1911");
	level.default_solo_laststandpistol = GetWeapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_tesla::init();
	level thread function_54bf648f();
	level.zone_manager_init_func = &asylum_zone_init;
	init_zones[0] = "west_downstairs_zone";
	init_zones[1] = "west2_downstairs_zone";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.zombie_ai_limit = 24;
	level.burning_zombies = [];
	init_zombie_asylum();
	init_sounds();
	level thread setupMusic();
	level thread intro_screen();
	level thread chair_useage();
	level thread function_a67a7819();
	level flag::wait_till("start_zombie_round_logic");
	level thread function_bb75f24a();
	level thread master_electric_switch();
	function_a552cd4a();
	level.var_9aaae7ae = &function_869d6f66;
	level thread zm_perks::spare_change();
	namespace_1e5daa72::main_end();
}

/*
	Name: init_clientfields
	Namespace: namespace_f69b3b38
	Checksum: 0xC797FF15
	Offset: 0x16F8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	clientfield::register("world", "asylum_trap_fx_north", 21000, 1, "int");
	clientfield::register("world", "asylum_trap_fx_south", 21000, 1, "int");
	clientfield::register("world", "asylum_generator_state", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 21000, 2, "int");
}

/*
	Name: customHudReveal
	Namespace: namespace_f69b3b38
	Checksum: 0x4BA1968C
	Offset: 0x17C8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function customHudReveal()
{
	self endon("disconnect");
	self endon("death");
	level flag::wait_till("intro_finished");
	self zm::ShowHudAndPlayPromo();
}

/*
	Name: function_869d6f66
	Namespace: namespace_f69b3b38
	Checksum: 0x7A94062F
	Offset: 0x1820
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
	Name: init_sounds
	Namespace: namespace_f69b3b38
	Checksum: 0xFC335EE3
	Offset: 0x1850
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function init_sounds()
{
	zm_utility::add_sound("break_stone", "break_stone");
	zm_utility::add_sound("zmb_couch_slam", "couch_slam");
	zm_utility::add_sound("door_slide_open", "door_slide_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
	level thread custom_add_vox();
}

/*
	Name: setupMusic
	Namespace: namespace_f69b3b38
	Checksum: 0x3961B4B3
	Offset: 0x18F8
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function setupMusic()
{
	zm_audio::musicState_Create("round_start", 3, "round_start_asylum_1");
	zm_audio::musicState_Create("round_start_short", 3, "round_start_asylum_1");
	zm_audio::musicState_Create("round_start_first", 3, "round_start_asylum_1");
	zm_audio::musicState_Create("round_end", 3, "round_end_asylum_1");
	zm_audio::musicState_Create("lullaby_for_a_dead_man", 4, "lullaby_for_a_dead_man");
	zm_audio::musicState_Create("game_over", 5, "game_over_zhd_asylum");
	zm_audio::musicState_Create("none", 4, "none");
	zm_audio::musicState_Create("sam", 4, "sam");
}

/*
	Name: initCharacterStartIndex
	Namespace: namespace_f69b3b38
	Checksum: 0x5AD987DA
	Offset: 0x1A48
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
	Namespace: namespace_f69b3b38
	Checksum: 0x7CF18148
	Offset: 0x1A78
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
	Namespace: namespace_f69b3b38
	Checksum: 0x74D702EB
	Offset: 0x1AC0
	Size: 0x2DB
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
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: namespace_f69b3b38
	Checksum: 0x71B70FC3
	Offset: 0x1DA8
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
	Name: offhand_weapon_overrride
	Namespace: namespace_f69b3b38
	Checksum: 0x7046BBC1
	Offset: 0x1F08
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
	Name: asylum_zone_init
	Namespace: namespace_f69b3b38
	Checksum: 0x1F2AB23F
	Offset: 0x1FB8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function asylum_zone_init()
{
	zm_zonemgr::add_adjacent_zone("west_downstairs_zone", "west2_downstairs_zone", "power_on");
	zm_zonemgr::add_adjacent_zone("west2_downstairs_zone", "north_downstairs_zone", "north_door1");
	zm_zonemgr::add_adjacent_zone("north_downstairs_zone", "north_upstairs_zone", "north_upstairs_blocker");
	zm_zonemgr::add_adjacent_zone("north_upstairs_zone", "north2_upstairs_zone", "upstairs_north_door1");
	zm_zonemgr::add_adjacent_zone("north2_upstairs_zone", "kitchen_upstairs_zone", "upstairs_north_door2");
	zm_zonemgr::add_adjacent_zone("kitchen_upstairs_zone", "power_upstairs_zone", "magic_box_north");
	zm_zonemgr::add_adjacent_zone("west_downstairs_zone", "south_upstairs_zone", "south_upstairs_blocker");
	zm_zonemgr::add_adjacent_zone("south_upstairs_zone", "south2_upstairs_zone", "south_access_1");
	zm_zonemgr::add_adjacent_zone("south2_upstairs_zone", "power_upstairs_zone", "magic_box_south");
}

/*
	Name: function_54bf648f
	Namespace: namespace_f69b3b38
	Checksum: 0x7A914011
	Offset: 0x2130
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_54bf648f()
{
	level.use_multiple_spawns = 1;
	level.spawner_int = 1;
	level.fn_custom_zombie_spawner_selection = &function_54da140a;
}

/*
	Name: function_54da140a
	Namespace: namespace_f69b3b38
	Checksum: 0xCFF5D468
	Offset: 0x2170
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function function_54da140a()
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
	Name: custom_add_weapons
	Namespace: namespace_f69b3b38
	Checksum: 0x146AA2A4
	Offset: 0x2380
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_asylum_weapons.csv", 1);
}

/*
	Name: custom_add_vox
	Namespace: namespace_f69b3b38
	Checksum: 0x9C0EC3FF
	Offset: 0x23B0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_theater_vox.csv");
}

/*
	Name: intro_screen
	Namespace: namespace_f69b3b38
	Checksum: 0x2B818FC9
	Offset: 0x23D8
	Size: 0x42B
	Parameters: 0
	Flags: None
*/
function intro_screen()
{
	level flag::wait_till("start_zombie_round_logic");
	wait(2);
	level.intro_hud = [];
	for(i = 0; i < 3; i++)
	{
		level.intro_hud[i] = NewHudElem();
		level.intro_hud[i].x = 0;
		level.intro_hud[i].y = 0;
		level.intro_hud[i].alignX = "left";
		level.intro_hud[i].alignY = "bottom";
		level.intro_hud[i].horzAlign = "left";
		level.intro_hud[i].vertAlign = "bottom";
		level.intro_hud[i].foreground = 1;
		if(level.Splitscreen && !level.hidef)
		{
			level.intro_hud[i].fontscale = 2.75;
		}
		else
		{
			level.intro_hud[i].fontscale = 1.75;
		}
		level.intro_hud[i].alpha = 0;
		level.intro_hud[i].color = (1, 1, 1);
		level.intro_hud[i].inUse = 0;
	}
	level.intro_hud[0].y = -110;
	level.intro_hud[1].y = -90;
	level.intro_hud[2].y = -70;
	level.intro_hud[0] setText(&"ZM_ASYLUM_INTRO_ASYLUM_LEVEL_BERLIN");
	level.intro_hud[1] setText(&"ZM_ASYLUM_INTRO_ASYLUM_LEVEL_HIMMLER");
	level.intro_hud[2] setText(&"ZM_ASYLUM_INTRO_ASYLUM_LEVEL_SEPTEMBER");
	for(i = 0; i < 3; i++)
	{
		level.intro_hud[i] fadeOverTime(1.5);
		level.intro_hud[i].alpha = 1;
		wait(1.5);
	}
	wait(1.5);
	for(i = 0; i < 3; i++)
	{
		level.intro_hud[i] fadeOverTime(1.5);
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	}
	for(i = 0; i < 3; i++)
	{
		level.intro_hud[i] destroy();
	}
	level flag::set("intro_finished");
	level thread magic_box_limit_location_init();
}

/*
	Name: init_zombie_asylum
	Namespace: namespace_f69b3b38
	Checksum: 0xF6505950
	Offset: 0x2810
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function init_zombie_asylum()
{
	level flag::init("electric_switch_used");
	level flag::set("spawn_point_override");
	level thread init_lights();
	water_trigs = GetEntArray("waterfall", "targetname");
	Array::thread_all(water_trigs, &watersheet_on_trigger);
}

/*
	Name: chair_useage
	Namespace: namespace_f69b3b38
	Checksum: 0x7D26DABF
	Offset: 0x28C8
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function chair_useage()
{
	wait(2);
	chair_trig = GetEnt("dentist_chair", "targetname");
	if(isdefined(chair_trig))
	{
		chair_trig setcursorhint("HINT_NOICON");
		chair_trig UseTriggerRequireLookAt();
		players = GetPlayers();
		while(1)
		{
			chair_trig waittill("trigger", players);
			playsoundatposition("evt_chair", chair_trig.origin);
			wait(3);
		}
	}
}

/*
	Name: function_a67a7819
	Namespace: namespace_f69b3b38
	Checksum: 0x7AC9FE6B
	Offset: 0x29B0
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function function_a67a7819()
{
	var_769dd606 = struct::get("snd_flusher", "targetname");
	if(!isdefined(var_769dd606))
	{
		return;
	}
	var_769dd606 zm_unitrigger::create_unitrigger(undefined, undefined, &function_f8772aa4);
	var_7d2efc67 = 0;
	while(var_7d2efc67 < 3)
	{
		var_769dd606 waittill("trigger_activated");
		if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || (isdefined(level.musicSystemOverride) && level.musicSystemOverride))
		{
			continue;
		}
		else
		{
			var_7d2efc67++;
			playsoundatposition("evt_toilet_flush", var_769dd606.origin);
			wait(3.8);
		}
	}
	zm_unitrigger::unregister_unitrigger(var_769dd606.s_unitrigger);
	playsoundatposition("zmb_cha_ching", var_769dd606.origin);
	level thread zm_audio::sndMusicSystem_PlayState("lullaby_for_a_dead_man");
}

/*
	Name: function_f8772aa4
	Namespace: namespace_f69b3b38
	Checksum: 0x5D5DC03F
	Offset: 0x2B38
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function function_f8772aa4(player)
{
	if(!isdefined(level.var_a3dcfd4f))
	{
		return 1;
	}
	if(level.var_a3dcfd4f >= 2)
	{
		return 0;
	}
	return 1;
}

/*
	Name: init_lights
	Namespace: namespace_f69b3b38
	Checksum: 0x2B3C29F5
	Offset: 0x2B78
	Size: 0x29D
	Parameters: 0
	Flags: None
*/
function init_lights()
{
	tinhats = [];
	arms = [];
	ents = GetEntArray("elect_light_model", "targetname");
	for(i = 0; i < ents.size; i++)
	{
		if(IsSubStr(ents[i].model, "tinhat"))
		{
			tinhats[tinhats.size] = ents[i];
		}
		if(IsSubStr(ents[i].model, "indlight"))
		{
			arms[arms.size] = ents[i];
		}
	}
	for(i = 0; i < tinhats.size; i++)
	{
		util::wait_network_frame();
		tinhats[i] SetModel("lights_tinhatlamp_off");
	}
	for(i = 0; i < arms.size; i++)
	{
		util::wait_network_frame();
		arms[i] SetModel("lights_indlight");
	}
	level flag::wait_till("electric_switch_used");
	for(i = 0; i < tinhats.size; i++)
	{
		util::wait_network_frame();
		tinhats[i] SetModel("lights_tinhatlamp_on");
	}
	for(i = 0; i < arms.size; i++)
	{
		util::wait_network_frame();
		arms[i] SetModel("lights_indlight_on");
	}
}

/*
	Name: function_91b06047
	Namespace: namespace_f69b3b38
	Checksum: 0x957076A6
	Offset: 0x2E20
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_91b06047(predictedSpawn)
{
	if(!isdefined(level.var_df35cb81))
	{
		level.var_df35cb81 = function_da4025bc();
	}
	/#
		Assert(isdefined(level.var_df35cb81), "Dev Block strings are not supported");
	#/
	spawnpoint = function_290134d5(level.var_df35cb81, self);
	self spawn(spawnpoint.origin, spawnpoint.angles, "zsurvival");
	return spawnpoint;
}

/*
	Name: function_290134d5
	Namespace: namespace_f69b3b38
	Checksum: 0x8261BC38
	Offset: 0x2EE0
	Size: 0x129
	Parameters: 2
	Flags: None
*/
function function_290134d5(Spawnpoints, player)
{
	if(!isdefined(self.playerNum))
	{
		if(self.team == "allies")
		{
			self.playerNum = zm_utility::get_game_var("_team1_num");
			zm_utility::set_game_var("_team1_num", self.playerNum + 1);
		}
		else
		{
			self.playerNum = zm_utility::get_game_var("_team2_num");
			zm_utility::set_game_var("_team2_num", self.playerNum + 1);
		}
	}
	for(j = 0; j < Spawnpoints.size; j++)
	{
		if(Spawnpoints[j].en_num == self.playerNum)
		{
			return Spawnpoints[j];
		}
	}
	return Spawnpoints[0];
}

/*
	Name: function_da4025bc
	Namespace: namespace_f69b3b38
	Checksum: 0xA845A7A5
	Offset: 0x3018
	Size: 0x24D
	Parameters: 0
	Flags: None
*/
function function_da4025bc()
{
	var_7eacef00 = [];
	var_95bba386 = [];
	north_structs = struct::get_array("north_spawn", "script_noteworthy");
	south_structs = struct::get_array("south_spawn", "script_noteworthy");
	for(i = 0; i < 2; i++)
	{
		if(!isdefined(var_7eacef00))
		{
			var_7eacef00 = [];
		}
		else if(!IsArray(var_7eacef00))
		{
			var_7eacef00 = Array(var_7eacef00);
		}
		var_7eacef00[var_7eacef00.size] = north_structs[i];
	}
	for(j = 0; j < 2; j++)
	{
		if(!isdefined(var_95bba386))
		{
			var_95bba386 = [];
		}
		else if(!IsArray(var_95bba386))
		{
			var_95bba386 = Array(var_95bba386);
		}
		var_95bba386[var_95bba386.size] = south_structs[j];
	}
	side1 = var_7eacef00;
	side2 = var_95bba386;
	if(RandomInt(100) > 50)
	{
		side1 = var_95bba386;
		side2 = var_7eacef00;
	}
	Spawnpoints = ArrayCombine(side1, side2, 0, 0);
	for(i = 0; i < Spawnpoints.size; i++)
	{
		Spawnpoints[i].en_num = i;
	}
	return Spawnpoints;
}

/*
	Name: disable_bump_trigger
	Namespace: namespace_f69b3b38
	Checksum: 0xDB21ED77
	Offset: 0x3270
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function disable_bump_trigger(triggername)
{
	triggers = GetEntArray("audio_bump_trigger", "targetname");
	if(isdefined(triggers))
	{
		for(i = 0; i < triggers.size; i++)
		{
			if(isdefined(triggers[i].script_label) && triggers[i].script_label == triggername)
			{
				triggers[i].script_activated = 0;
			}
		}
	}
}

/*
	Name: master_electric_switch
	Namespace: namespace_f69b3b38
	Checksum: 0x39712EC
	Offset: 0x3338
	Size: 0x4C3
	Parameters: 0
	Flags: None
*/
function master_electric_switch()
{
	trig = GetEnt("use_master_switch", "targetname");
	var_cf413835 = struct::get("power_switch", "targetname");
	trig setHintString(&"ZOMBIE_ELECTRIC_SWITCH");
	trig setcursorhint("HINT_NOICON");
	fx_org = spawn("script_model", (-674.922, -300.473, 284.125));
	fx_org SetModel("tag_origin");
	fx_org.angles = VectorScale((0, 1, 0), 90);
	cheat = 0;
	/#
		if(GetDvarInt("Dev Block strings are not supported") >= 3)
		{
			wait(5);
			cheat = 1;
		}
	#/
	level clientfield::set("asylum_generator_state", 1);
	if(cheat != 1)
	{
		trig waittill("trigger", User);
	}
	playsoundatposition("zmb_switch_flip", var_cf413835.origin);
	zm_power::turn_power_on_and_open_doors();
	level notify("switch_flipped");
	disable_bump_trigger("switch_door_trig");
	level thread function_463cb1c6();
	util::setClientSysState("levelNotify", "start_lights");
	level flag::set("electric_switch_used");
	trig delete();
	traps = GetEntArray("gas_access", "targetname");
	for(i = 0; i < traps.size; i++)
	{
		traps[i] setHintString(&"ZOMBIE_ELECTRIC_SWITCH");
		traps[i] setcursorhint("HINT_NOICON");
		traps[i].is_available = 1;
	}
	var_cf413835 scene::Play("p7_fxanim_zmhd_power_switch_bundle");
	playFX(level._effect["switch_sparks"], struct::get("switch_fx", "targetname").origin);
	level notify("master_switch_activated");
	fx_org delete();
	fx_org = spawn("script_model", (-675.021, -300.906, 283.724));
	fx_org SetModel("tag_origin");
	fx_org.angles = VectorScale((0, 1, 0), 90);
	wait(6);
	fx_org StopLoopSound();
	level notify("sleight_on");
	util::wait_network_frame();
	level notify("revive_on");
	util::wait_network_frame();
	level notify("doubletap_on");
	util::wait_network_frame();
	level notify("juggernog_on");
	exploder::exploder("lgt_exploder_power_on");
}

/*
	Name: function_463cb1c6
	Namespace: namespace_f69b3b38
	Checksum: 0x5398772
	Offset: 0x3808
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function function_463cb1c6()
{
	power_on = GetEnt("audio_swtch_left", "targetname");
	var_5c141942 = struct::get("evt_circuit_1", "targetname");
	var_36119ed9 = struct::get("evt_circuit_2", "targetname");
	var_100f2470 = struct::get("evt_circuit_3", "targetname");
	wait(0.75);
	if(isdefined(var_5c141942))
	{
		playsoundatposition("evt_circuit_1", var_5c141942.origin);
	}
	wait(1.5);
	if(isdefined(var_36119ed9))
	{
		playsoundatposition("evt_circuit_2", var_36119ed9.origin);
	}
	wait(1.5);
	if(isdefined(var_100f2470))
	{
		playsoundatposition("evt_circuit_3", var_100f2470.origin);
	}
	wait(0.25);
	power_on playsound("evt_power_on");
	wait(5.5);
	power_on PlayLoopSound("evt_power_loop");
	level thread play_the_numbers();
	wait(1);
	level thread play_pa_system();
}

/*
	Name: electric_trap_wire_sparks
	Namespace: namespace_f69b3b38
	Checksum: 0x40523BC9
	Offset: 0x3A00
	Size: 0x237
	Parameters: 1
	Flags: None
*/
function electric_trap_wire_sparks(side)
{
	self endon("elec_done");
	while(1)
	{
		sparks = struct::get("trap_wire_sparks_" + side, "targetname");
		self.fx_org = util::spawn_model("tag_origin", sparks.origin, sparks.angles);
		PlayFXOnTag(level._effect["electric_current"], self.fx_org, "tag_origin");
		targ = struct::get(sparks.target, "targetname");
		while(isdefined(targ))
		{
			self.fx_org moveto(targ.origin, 0.15);
			self.fx_org PlayLoopSound("zmb_elec_current_loop", 0.1);
			self.fx_org waittill("movedone");
			self.fx_org StopLoopSound(0.1);
			if(isdefined(targ.target))
			{
				targ = struct::get(targ.target, "targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		PlayFXOnTag(level._effect["electric_short_oneshot"], self.fx_org, "tag_origin");
		wait(randomIntRange(3, 9));
		self.fx_org delete();
	}
}

/*
	Name: electric_current_open_middle_door
	Namespace: namespace_f69b3b38
	Checksum: 0x57CB27B1
	Offset: 0x3C40
	Size: 0x293
	Parameters: 0
	Flags: None
*/
function electric_current_open_middle_door()
{
	sparks = struct::get("electric_middle_door", "targetname");
	fx_org = util::spawn_model("script_model", sparks.origin, sparks.angles);
	PlayFXOnTag(level._effect["electric_current"], fx_org, "tag_origin");
	targ = struct::get(sparks.target, "targetname");
	while(isdefined(targ))
	{
		fx_org moveto(targ.origin, 0.075);
		if(isdefined(targ.script_noteworthy) && (targ.script_noteworthy == "junction_boxs" || targ.script_noteworthy == "electric_end"))
		{
			PlayFXOnTag(level._effect["electric_short_oneshot"], fx_org, "tag_origin");
		}
		fx_org PlayLoopSound("zmb_elec_current_loop", 0.1);
		fx_org waittill("movedone");
		fx_org StopLoopSound(0.1);
		if(isdefined(targ.target))
		{
			targ = struct::get(targ.target, "targetname");
		}
		else
		{
			targ = undefined;
		}
	}
	level notify("electric_on_middle_door");
	PlayFXOnTag(level._effect["electric_short_oneshot"], fx_org, "tag_origin");
	wait(randomIntRange(3, 9));
	fx_org delete();
}

/*
	Name: play_the_numbers
	Namespace: namespace_f69b3b38
	Checksum: 0x4E206EFA
	Offset: 0x3EE0
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function play_the_numbers()
{
	level thread function_9a0695b3();
	while(1)
	{
		wait(randomIntRange(15, 20));
		playsoundatposition("evt_the_numbers", (-758, -310, 125));
		wait(randomIntRange(15, 20));
	}
}

/*
	Name: function_9a0695b3
	Namespace: namespace_f69b3b38
	Checksum: 0x9FB08932
	Offset: 0x3F68
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_9a0695b3()
{
	while(1)
	{
		wait(randomIntRange(3, 8));
		playsoundatposition("zmb_elec_room_sweets", (-758, -310, 125));
	}
}

/*
	Name: magic_box_limit_location_init
	Namespace: namespace_f69b3b38
	Checksum: 0xB1344714
	Offset: 0x3FC0
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function magic_box_limit_location_init()
{
	level.open_chest_location = [];
	level.open_chest_location[0] = undefined;
	level.open_chest_location[1] = undefined;
	level.open_chest_location[2] = undefined;
	level.open_chest_location[3] = "opened_chest";
	level.open_chest_location[4] = "start_chest";
	level thread waitfor_flag_open_chest_location("magic_box_south");
	level thread waitfor_flag_open_chest_location("south_access_1");
	level thread waitfor_flag_open_chest_location("north_door1");
	level thread waitfor_flag_open_chest_location("north_upstairs_blocker");
	level thread waitfor_flag_open_chest_location("south_upstairs_blocker");
}

/*
	Name: waitfor_flag_open_chest_location
	Namespace: namespace_f69b3b38
	Checksum: 0xC2AAEA90
	Offset: 0x40C8
	Size: 0x175
	Parameters: 1
	Flags: None
*/
function waitfor_flag_open_chest_location(which)
{
	wait(3);
	switch(which)
	{
		case "magic_box_south":
		{
			level flag::wait_till("magic_box_south");
			level.open_chest_location[0] = "magic_box_south";
			break;
		}
		case "south_access_1":
		{
			level flag::wait_till("south_access_1");
			level.open_chest_location[0] = "magic_box_south";
			level.open_chest_location[1] = "magic_box_bathroom";
			break;
		}
		case "north_door1":
		{
			level flag::wait_till("north_door1");
			level.open_chest_location[2] = "magic_box_hallway";
			break;
		}
		case "north_upstairs_blocker":
		{
			level flag::wait_till("north_upstairs_blocker");
			level.open_chest_location[2] = "magic_box_hallway";
			break;
		}
		case "south_upstairs_blocker":
		{
			level flag::wait_till("south_upstairs_blocker");
			level.open_chest_location[1] = "magic_box_bathroom";
			break;
		}
		case default:
		{
			return;
		}
	}
}

/*
	Name: watersheet_on_trigger
	Namespace: namespace_f69b3b38
	Checksum: 0x64271CF7
	Offset: 0x4248
	Size: 0x105
	Parameters: 0
	Flags: None
*/
function watersheet_on_trigger()
{
	while(1)
	{
		self waittill("trigger", who);
		if(isdefined(who) && isPlayer(who) && isalive(who) && who.sessionstate != "spectator")
		{
			if(!who laststand::player_is_in_laststand())
			{
				if(isdefined(who.var_1e4200d5))
				{
					if(!who.var_1e4200d5)
					{
						who thread function_4c24944a(self);
					}
				}
				else
				{
					who.var_1e4200d5 = 1;
					who thread function_4c24944a(self);
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_4c24944a
	Namespace: namespace_f69b3b38
	Checksum: 0xF3303C02
	Offset: 0x4358
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function function_4c24944a(t_water)
{
	self.var_1e4200d5 = 1;
	if(isdefined(t_water.script_int) && t_water.script_int)
	{
		visionset_mgr::activate("visionset", "zm_showerhead", self, 0.5, 2, 0.5);
		visionset_mgr::activate("overlay", "zm_showerhead_postfx", self, 0.5, 2, 0.5);
	}
	else
	{
		visionset_mgr::activate("overlay", "zm_waterfall_postfx", self, 0.5, 2, 0.5);
	}
	wait(1);
	if(self istouching(t_water))
	{
		self thread function_4c24944a(t_water);
	}
	else if(isdefined(t_water.script_int) && t_water.script_int)
	{
		visionset_mgr::deactivate("visionset", "zm_showerhead", self);
		visionset_mgr::deactivate("overlay", "zm_showerhead_postfx", self);
	}
	else
	{
		visionset_mgr::deactivate("overlay", "zm_waterfall_postfx", self);
	}
	self.var_1e4200d5 = 0;
}

/*
	Name: setup_custom_vox
	Namespace: namespace_f69b3b38
	Checksum: 0x3FC7BB0F
	Offset: 0x4530
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function setup_custom_vox()
{
	level.plr_vox["level"]["power"] = "power";
}

/*
	Name: exit_level_func
	Namespace: namespace_f69b3b38
	Checksum: 0x3E29D03A
	Offset: 0x4560
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function exit_level_func()
{
	zombies = GetAIArray();
	foreach(zombie in zombies)
	{
		if(isdefined(zombie.ignore_solo_last_stand) && zombie.ignore_solo_last_stand)
		{
			continue;
		}
		if(isdefined(zombie.find_exit_point))
		{
			zombie thread [[zombie.find_exit_point]]();
			continue;
		}
		if(zombie.ignoreme)
		{
			zombie thread zm::default_delayed_exit();
			continue;
		}
		zombie thread zm::default_find_exit_point();
	}
}

/*
	Name: play_pa_system
	Namespace: namespace_f69b3b38
	Checksum: 0xFEF23131
	Offset: 0x4698
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function play_pa_system()
{
	level clientfield::set("asylum_generator_state", 0);
	speakerA = struct::get("loudspeaker", "targetname");
	playsoundatposition("amb_alarm", speakerA.origin);
	level thread play_comp_sounds();
	wait(8);
	playsoundatposition("amb_pa_system", speakerA.origin);
}

/*
	Name: play_comp_sounds
	Namespace: namespace_f69b3b38
	Checksum: 0x498869CA
	Offset: 0x4760
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function play_comp_sounds()
{
	computer = GetEnt("comp", "targetname");
	computer playsound("amb_comp_start");
	wait(6);
	computer PlayLoopSound("amb_comp_loop");
}

/*
	Name: init_level_specific_audio
	Namespace: namespace_f69b3b38
	Checksum: 0xFDA7A9B8
	Offset: 0x47D8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function init_level_specific_audio()
{
	level.vox zm_audio::zmbVoxAdd("player", "general", "intro", "level_start", undefined);
	level.vox zm_audio::zmbVoxAdd("player", "general", "door_deny", "nomoney", undefined);
	level.vox zm_audio::zmbVoxAdd("player", "general", "perk_deny", "nomoney", undefined);
	level.vox zm_audio::zmbVoxAdd("player", "general", "no_money_weapon", "nomoney", undefined);
}

/*
	Name: function_a552cd4a
	Namespace: namespace_f69b3b38
	Checksum: 0x547C0750
	Offset: 0x48C8
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function function_a552cd4a()
{
	perk_machines = GetEntArray("zombie_vending", "targetname");
	foreach(perk_machine in perk_machines)
	{
		if(isdefined(perk_machine.clip) && perk_machine.script_noteworthy == "specialty_additionalprimaryweapon")
		{
			perk_machine.clip delete();
		}
	}
}

/*
	Name: function_aeabaa98
	Namespace: namespace_f69b3b38
	Checksum: 0x69891438
	Offset: 0x49C0
	Size: 0x1ED
	Parameters: 1
	Flags: None
*/
function function_aeabaa98(zbarrier)
{
	self.zbarrier = zbarrier;
	if(isdefined(self.zbarrier.script_string))
	{
	}
	else
	{
	}
	m_collision = "p6_anim_zm_barricade_board_collision";
	if(m_collision == "p6_anim_zm_barricade_board_collision")
	{
		self.zbarrier SetZBarrierColModel(m_collision);
	}
	self.zbarrier.chunk_health = [];
	for(i = 0; i < self.zbarrier GetNumZBarrierPieces(); i++)
	{
		self.zbarrier.chunk_health[i] = 0;
	}
	if(isdefined(self.zbarrier.target))
	{
		self.zbarrier.dynents = GetEntArray(self.zbarrier.target, "targetname");
		for(i = 0; i < self.zbarrier.dynents.size; i++)
		{
			self.zbarrier HideZBarrierPiece(self.zbarrier.dynents[i].script_int);
			self.zbarrier.dynents[i] thread function_ee8a2035(self.zbarrier.dynents[i].script_int, self.zbarrier);
		}
	}
}

/*
	Name: function_ee8a2035
	Namespace: namespace_f69b3b38
	Checksum: 0xFE0F4D9C
	Offset: 0x4BB8
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function function_ee8a2035(piece_index, zbarrier)
{
	self endon("damage");
	for(var_31410ef7 = "closed"; var_31410ef7 != "open" && var_31410ef7 != "opening";  = "closed")
	{
		wait(0.05);
	}
	self notify("torn_down", zbarrier GetZBarrierPieceState(piece_index));
	e_piece = zbarrier.dynents[piece_index];
	if(isdefined(e_piece))
	{
		self ghost();
		zm_utility::play_sound_at_pos("break_barrier_piece", self.origin);
		wait(RandomFloatRange(0.3, 0.6));
		zm_utility::play_sound_at_pos("break_barrier_piece", self.origin);
	}
	self delete();
}

/*
	Name: function_ee422b5c
	Namespace: namespace_f69b3b38
	Checksum: 0x3973CBB7
	Offset: 0x4D08
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function function_ee422b5c(chunk)
{
	if(isdefined(self.first_node.zbarrier.dynents) && isdefined(self.first_node.zbarrier.dynents[chunk]))
	{
		if(isdefined(self.first_node.zbarrier.dynents[chunk].script_noteworthy))
		{
			animStateBase = self.first_node.zbarrier.dynents[chunk].script_noteworthy;
			self.first_node.zbarrier.var_48c7593a = 1;
		}
		else
		{
			ASSERTMSG("Dev Block strings are not supported" + chunk + "Dev Block strings are not supported");
		}
		/#
		#/
	}
	else
	{
		animStateBase = self.first_node.zbarrier GetZBarrierPieceAnimState(chunk);
	}
	return animStateBase;
}

/*
	Name: function_659c2324
	Namespace: namespace_f69b3b38
	Checksum: 0x88056698
	Offset: 0x4E40
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_659c2324(a_keys)
{
	if(a_keys[0] === level.weaponZMTeslaGun)
	{
		level.var_12d3a848 = 0;
		return a_keys;
	}
	n_chance = 0;
	if(zm_weapons::limited_weapon_below_quota(level.weaponZMTeslaGun))
	{
		level.var_12d3a848++;
		if(level.var_12d3a848 <= 12)
		{
			n_chance = 5;
		}
		else if(level.var_12d3a848 > 12 && level.var_12d3a848 <= 17)
		{
			n_chance = 8;
		}
		else if(level.var_12d3a848 > 17)
		{
			n_chance = 12;
		}
	}
	else
	{
		level.var_12d3a848 = 0;
	}
	if(RandomInt(100) <= n_chance && zm_magicbox::treasure_chest_CanPlayerReceiveWeapon(self, level.weaponZMTeslaGun) && !self HasWeapon(level.weaponZMTeslaGunUpgraded))
	{
		ArrayInsert(a_keys, level.weaponZMTeslaGun, 0);
		level.var_12d3a848 = 0;
	}
	return a_keys;
}

/*
	Name: function_bb75f24a
	Namespace: namespace_f69b3b38
	Checksum: 0x8414E85C
	Offset: 0x4FB8
	Size: 0x139
	Parameters: 0
	Flags: None
*/
function function_bb75f24a()
{
	level.var_a3dcfd4f = 0;
	var_f0a0f84f = struct::get_array("s_toilet_zhd", "targetname");
	Array::thread_all(var_f0a0f84f, &function_db379af2);
	level thread function_fa408417();
	level waittill("hash_137fb152");
	level.var_a3dcfd4f = undefined;
	level flag::set("snd_zhdegg_activate");
	foreach(struct in var_f0a0f84f)
	{
		zm_unitrigger::unregister_unitrigger(struct.s_unitrigger);
	}
}

/*
	Name: function_db379af2
	Namespace: namespace_f69b3b38
	Checksum: 0x4DED5F24
	Offset: 0x5100
	Size: 0x199
	Parameters: 0
	Flags: None
*/
function function_db379af2()
{
	level endon("hash_137fb152");
	self.var_46907f23 = 0;
	self.activated = 0;
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "toilet3")
	{
		self zm_unitrigger::create_unitrigger(undefined, undefined, &function_dffe609d);
		continue;
	}
	self zm_unitrigger::create_unitrigger();
	while(1)
	{
		self waittill("trigger_activated");
		self.var_46907f23++;
		if(self.var_46907f23 > 9)
		{
			playsoundatposition("zmb_zhd_toilet_flusheroo", self.origin);
			self.var_46907f23 = 0;
		}
		else
		{
			playsoundatposition("zmb_zhd_toilet_hit", self.origin);
		}
		if(self.var_46907f23 == self.script_int)
		{
			self.activated = 1;
			level.var_a3dcfd4f++;
			level notify("hash_b280e2e");
		}
		else if(isdefined(self.activated) && self.activated)
		{
			self.activated = 0;
			level.var_a3dcfd4f--;
			level notify("hash_b280e2e");
		}
		if(level.var_a3dcfd4f >= 3)
		{
			level notify("hash_137fb152");
		}
	}
}

/*
	Name: function_dffe609d
	Namespace: namespace_f69b3b38
	Checksum: 0xB98C4CE4
	Offset: 0x52A8
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function function_dffe609d(player)
{
	if(!isdefined(level.var_a3dcfd4f))
	{
		return 1;
	}
	if(level.var_a3dcfd4f < 2)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_fa408417
	Namespace: namespace_f69b3b38
	Checksum: 0x9994FC83
	Offset: 0x52E8
	Size: 0x19D
	Parameters: 0
	Flags: None
*/
function function_fa408417()
{
	level endon("hash_137fb152");
	var_f0a0f84f = struct::get_array("s_toilet_zhd", "targetname");
	while(1)
	{
		level waittill("hash_b280e2e");
		foreach(struct in var_f0a0f84f)
		{
			if(isdefined(struct.script_noteworthy) && struct.script_noteworthy == "toilet3")
			{
				if(struct.var_46907f23 > 0 && level.var_a3dcfd4f <= 1)
				{
					struct.var_46907f23 = 0;
					playsoundatposition("zmb_zhd_toilet_flusheroo", struct.origin);
				}
				if(isdefined(struct.activated) && struct.activated && level.var_a3dcfd4f <= 2)
				{
					struct.activated = 0;
					level.var_a3dcfd4f--;
				}
			}
		}
	}
}

/*
	Name: include_perks_in_random_rotation
	Namespace: namespace_f69b3b38
	Checksum: 0xD92760DE
	Offset: 0x5490
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
	Namespace: namespace_f69b3b38
	Checksum: 0x5C318AE1
	Offset: 0x5500
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

