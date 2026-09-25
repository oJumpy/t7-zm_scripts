#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
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
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_gravityspikes;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weap_raygun_mark3;
#using scripts\zm\_zm_weap_rocketshield;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_usermap_ai;

#namespace zm_usermap;

/*
	Name: opt_in
	Namespace: zm_usermap
	Checksum: 0x11CD404C
	Offset: 0xDC0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	if(!isdefined(level.aat_in_use))
	{
		level.aat_in_use = 1;
	}
	if(!isdefined(level.bgb_in_use))
	{
		level.bgb_in_use = 1;
	}
}

/*
	Name: init_fx
	Namespace: zm_usermap
	Checksum: 0xF1ED1157
	Offset: 0xE00
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_fx()
{
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
}

/*
	Name: main
	Namespace: zm_usermap
	Checksum: 0x477E0D42
	Offset: 0xE40
	Size: 0x29B
	Parameters: 0
	Flags: None
*/
function main()
{
	level._uses_default_wallbuy_fx = 1;
	zm::init_fx();
	level util::set_lighting_state(1);
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	level._effect["animscript_gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["switch_sparks"] = "electric/fx_elec_sparks_directional_orange";
	level.default_start_location = "start_room";
	level.default_game_mode = "zclassic";
	level.giveCustomLoadout = &giveCustomLoadout;
	level.precacheCustomCharacters = &precacheCustomCharacters;
	level.giveCustomCharacters = &giveCustomCharacters;
	level thread setup_personality_character_exerts();
	initCharacterStartIndex();
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	if(!isdefined(level._zombie_custom_add_weapons))
	{
		level._zombie_custom_add_weapons = &custom_add_weapons;
	}
	level._allow_melee_weapon_switching = 1;
	level.zombiemode_reusing_pack_a_punch = 1;
	include_weapons();
	load::main();
	if(!isdefined(level.dog_rounds_allowed))
	{
		level.dog_rounds_allowed = 1;
	}
	if(level.dog_rounds_allowed)
	{
		zm_ai_dogs::enable_dog_rounds();
	}
	_zm_weap_cymbal_monkey::init();
	_zm_weap_tesla::init();
	level._round_start_func = &zm::round_start;
	level thread sndFunctions();
}

/*
	Name: template_test_zone_init
	Namespace: zm_usermap
	Checksum: 0x64654E7A
	Offset: 0x10E8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function template_test_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
}

/*
	Name: offhand_weapon_overrride
	Namespace: zm_usermap
	Checksum: 0xF53F9194
	Offset: 0x1138
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = GetWeapon("frag_grenade");
	zm_utility::register_melee_weapon_for_level(level.weaponBaseMelee.name);
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: offhand_weapon_give_override
	Namespace: zm_usermap
	Checksum: 0xA74EEF9
	Offset: 0x11D0
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function offhand_weapon_give_override(weapon)
{
	self endon("death");
	if(zm_utility::is_tactical_grenade(weapon) && isdefined(self zm_utility::get_player_tactical_grenade()) && !self zm_utility::is_player_tactical_grenade(weapon))
	{
		self SetWeaponAmmoClip(self zm_utility::get_player_tactical_grenade(), 0);
		self TakeWeapon(self zm_utility::get_player_tactical_grenade());
	}
	return 0;
}

/*
	Name: include_weapons
	Namespace: zm_usermap
	Checksum: 0x99EC1590
	Offset: 0x1298
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
}

/*
	Name: precacheCustomCharacters
	Namespace: zm_usermap
	Checksum: 0x99EC1590
	Offset: 0x12A8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precacheCustomCharacters()
{
}

/*
	Name: initCharacterStartIndex
	Namespace: zm_usermap
	Checksum: 0xE0BECB00
	Offset: 0x12B8
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
	Namespace: zm_usermap
	Checksum: 0x2FD0C0AC
	Offset: 0x12E8
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
	Name: assign_lowest_unused_character_index
	Namespace: zm_usermap
	Checksum: 0x3A4590A9
	Offset: 0x1330
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
	Name: giveCustomCharacters
	Namespace: zm_usermap
	Checksum: 0xA882EE77
	Offset: 0x1550
	Size: 0x27B
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
	self SetCharacterBodyType(self.characterindex);
	self SetCharacterBodyStyle(0);
	self SetCharacterHelmetStyle(0);
	switch(self.characterindex)
	{
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("870mcs");
			break;
		}
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("bouncingbetty");
			break;
		}
		case 3:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("hk416");
			break;
		}
		case 2:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndRadioA = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon("pistol_standard");
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
	Namespace: zm_usermap
	Checksum: 0x49413FBF
	Offset: 0x17D8
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
	Name: setup_personality_character_exerts
	Namespace: zm_usermap
	Checksum: 0xF3E98CBA
	Offset: 0x1838
	Size: 0x7F1
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["burp"][0] = "evt_belch";
	level.exert_sounds[1]["burp"][1] = "evt_belch";
	level.exert_sounds[1]["burp"][2] = "evt_belch";
	level.exert_sounds[2]["burp"][0] = "evt_belch";
	level.exert_sounds[2]["burp"][1] = "evt_belch";
	level.exert_sounds[2]["burp"][2] = "evt_belch";
	level.exert_sounds[3]["burp"][0] = "evt_belch";
	level.exert_sounds[3]["burp"][1] = "evt_belch";
	level.exert_sounds[3]["burp"][2] = "evt_belch";
	level.exert_sounds[4]["burp"][0] = "evt_belch";
	level.exert_sounds[4]["burp"][1] = "evt_belch";
	level.exert_sounds[4]["burp"][2] = "evt_belch";
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
	Name: giveCustomLoadout
	Namespace: zm_usermap
	Checksum: 0x9C1C1D7
	Offset: 0x2038
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function giveCustomLoadout(TakeAllWeapons, alreadySpawned)
{
	self GiveWeapon(level.weaponBaseMelee);
	self zm_utility::give_start_weapon(1);
}

/*
	Name: custom_add_weapons
	Namespace: zm_usermap
	Checksum: 0x69AAC353
	Offset: 0x2090
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

/*
	Name: perk_init
	Namespace: zm_usermap
	Checksum: 0x4F016C31
	Offset: 0x20C0
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function perk_init()
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
	Name: sndFunctions
	Namespace: zm_usermap
	Checksum: 0xC01600D8
	Offset: 0x2190
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function sndFunctions()
{
	level thread setupMusic();
}

/*
	Name: setupMusic
	Namespace: zm_usermap
	Checksum: 0x4548D55B
	Offset: 0x21B8
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function setupMusic()
{
	zm_audio::musicState_Create("round_start", 3, "roundstart1", "roundstart2", "roundstart3", "roundstart4");
	zm_audio::musicState_Create("round_start_short", 3, "roundstart_short1", "roundstart_short2", "roundstart_short3", "roundstart_short4");
	zm_audio::musicState_Create("round_start_first", 3, "roundstart_first");
	zm_audio::musicState_Create("round_end", 3, "roundend1");
	zm_audio::musicState_Create("game_over", 5, "gameover");
	zm_audio::musicState_Create("dog_start", 3, "dogstart1");
	zm_audio::musicState_Create("dog_end", 3, "dogend1");
	zm_audio::musicState_Create("timer", 3, "timer");
	zm_audio::musicState_Create("power_on", 2, "poweron");
}

