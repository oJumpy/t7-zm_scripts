#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_sticky_grenade;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_demo;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_ffotd;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerup_bonus_points_player;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zdraw;
#using scripts\zm\aats\_zm_aat_blast_furnace;
#using scripts\zm\aats\_zm_aat_dead_wire;
#using scripts\zm\aats\_zm_aat_fire_works;
#using scripts\zm\aats\_zm_aat_thunder_wall;
#using scripts\zm\aats\_zm_aat_turned;
#using scripts\zm\bgbs\_zm_bgb_aftertaste;
#using scripts\zm\bgbs\_zm_bgb_alchemical_antithesis;
#using scripts\zm\bgbs\_zm_bgb_always_done_swiftly;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\bgbs\_zm_bgb_armamental_accomplishment;
#using scripts\zm\bgbs\_zm_bgb_arms_grace;
#using scripts\zm\bgbs\_zm_bgb_arsenal_accelerator;
#using scripts\zm\bgbs\_zm_bgb_board_games;
#using scripts\zm\bgbs\_zm_bgb_board_to_death;
#using scripts\zm\bgbs\_zm_bgb_bullet_boost;
#using scripts\zm\bgbs\_zm_bgb_burned_out;
#using scripts\zm\bgbs\_zm_bgb_cache_back;
#using scripts\zm\bgbs\_zm_bgb_coagulant;
#using scripts\zm\bgbs\_zm_bgb_crate_power;
#using scripts\zm\bgbs\_zm_bgb_crawl_space;
#using scripts\zm\bgbs\_zm_bgb_danger_closest;
#using scripts\zm\bgbs\_zm_bgb_dead_of_nuclear_winter;
#using scripts\zm\bgbs\_zm_bgb_disorderly_combat;
#using scripts\zm\bgbs\_zm_bgb_ephemeral_enhancement;
#using scripts\zm\bgbs\_zm_bgb_extra_credit;
#using scripts\zm\bgbs\_zm_bgb_eye_candy;
#using scripts\zm\bgbs\_zm_bgb_fatal_contraption;
#using scripts\zm\bgbs\_zm_bgb_fear_in_headlights;
#using scripts\zm\bgbs\_zm_bgb_firing_on_all_cylinders;
#using scripts\zm\bgbs\_zm_bgb_flavor_hexed;
#using scripts\zm\bgbs\_zm_bgb_head_drama;
#using scripts\zm\bgbs\_zm_bgb_idle_eyes;
#using scripts\zm\bgbs\_zm_bgb_im_feelin_lucky;
#using scripts\zm\bgbs\_zm_bgb_immolation_liquidation;
#using scripts\zm\bgbs\_zm_bgb_impatient;
#using scripts\zm\bgbs\_zm_bgb_in_plain_sight;
#using scripts\zm\bgbs\_zm_bgb_kill_joy;
#using scripts\zm\bgbs\_zm_bgb_killing_time;
#using scripts\zm\bgbs\_zm_bgb_licensed_contractor;
#using scripts\zm\bgbs\_zm_bgb_lucky_crit;
#using scripts\zm\bgbs\_zm_bgb_mind_blown;
#using scripts\zm\bgbs\_zm_bgb_near_death_experience;
#using scripts\zm\bgbs\_zm_bgb_newtonian_negation;
#using scripts\zm\bgbs\_zm_bgb_now_you_see_me;
#using scripts\zm\bgbs\_zm_bgb_on_the_house;
#using scripts\zm\bgbs\_zm_bgb_perkaholic;
#using scripts\zm\bgbs\_zm_bgb_phoenix_up;
#using scripts\zm\bgbs\_zm_bgb_pop_shocks;
#using scripts\zm\bgbs\_zm_bgb_power_vacuum;
#using scripts\zm\bgbs\_zm_bgb_profit_sharing;
#using scripts\zm\bgbs\_zm_bgb_projectile_vomiting;
#using scripts\zm\bgbs\_zm_bgb_reign_drops;
#using scripts\zm\bgbs\_zm_bgb_respin_cycle;
#using scripts\zm\bgbs\_zm_bgb_round_robbin;
#using scripts\zm\bgbs\_zm_bgb_secret_shopper;
#using scripts\zm\bgbs\_zm_bgb_self_medication;
#using scripts\zm\bgbs\_zm_bgb_shopping_free;
#using scripts\zm\bgbs\_zm_bgb_slaughter_slide;
#using scripts\zm\bgbs\_zm_bgb_soda_fountain;
#using scripts\zm\bgbs\_zm_bgb_stock_option;
#using scripts\zm\bgbs\_zm_bgb_sword_flay;
#using scripts\zm\bgbs\_zm_bgb_temporal_gift;
#using scripts\zm\bgbs\_zm_bgb_tone_death;
#using scripts\zm\bgbs\_zm_bgb_unbearable;
#using scripts\zm\bgbs\_zm_bgb_undead_man_walking;
#using scripts\zm\bgbs\_zm_bgb_unquenchable;
#using scripts\zm\bgbs\_zm_bgb_wall_power;
#using scripts\zm\bgbs\_zm_bgb_whos_keeping_score;

#namespace zm;

/*
	Name: ignore_systems
	Namespace: zm
	Checksum: 0x74C9E6E2
	Offset: 0x1900
	Size: 0x3B3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec ignore_systems()
{
	system::Ignore("gadget_clone");
	system::Ignore("gadget_heat_wave");
	system::Ignore("gadget_resurrect");
	system::Ignore("gadget_shock_field");
	system::Ignore("gadget_es_strike");
	system::Ignore("gadget_misdirection");
	system::Ignore("gadget_smokescreen");
	system::Ignore("gadget_firefly_swarm");
	system::Ignore("gadget_immolation");
	system::Ignore("gadget_forced_malfunction");
	system::Ignore("gadget_sensory_overload");
	system::Ignore("gadget_rapid_strike");
	system::Ignore("gadget_camo_render");
	system::Ignore("gadget_unstoppable_force");
	system::Ignore("gadget_overdrive");
	system::Ignore("gadget_concussive_wave");
	system::Ignore("gadget_ravage_core");
	system::Ignore("gadget_cacophany");
	system::Ignore("gadget_iff_override");
	system::Ignore("gadget_security_breach");
	system::Ignore("gadget_surge");
	system::Ignore("gadget_exo_breakdown");
	system::Ignore("gadget_servo_shortout");
	system::Ignore("gadget_system_overload");
	system::Ignore("gadget_cleanse");
	system::Ignore("gadget_flashback");
	system::Ignore("gadget_combat_efficiency");
	system::Ignore("gadget_other");
	system::Ignore("gadget_vision_pulse");
	system::Ignore("gadget_camo");
	system::Ignore("gadget_speed_burst");
	system::Ignore("gadget_armor");
	system::Ignore("gadget_thief");
	system::Ignore("replay_gun");
	system::Ignore("spike_charge_siegebot");
	system::Ignore("end_game_taunts");
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		system::Ignore("footsteps");
		system::Ignore("ambient");
	}
}

/*
	Name: init
	Namespace: zm
	Checksum: 0x30EFBC66
	Offset: 0x1CC0
	Size: 0x3F3
	Parameters: 0
	Flags: None
*/
function init()
{
	/#
		println("Dev Block strings are not supported");
	#/
	level thread zm_ffotd::main_start();
	level.onlineGame = SessionModeIsOnlineGame();
	level.swimmingFeature = 0;
	level.scr_zm_ui_gametype = GetDvarString("ui_gametype");
	level.scr_zm_map_start_location = "";
	level.gamedifficulty = GetGametypeSetting("zmDifficulty");
	level.enable_magic = GetGametypeSetting("magic");
	level.headshots_only = GetGametypeSetting("headshotsonly");
	level.disable_equipment_team_object = 1;
	util::REGISTER_SYSTEM("lsm", &last_stand_monitor);
	level.clientVoiceSetup = &zm_audio::clientVoiceSetup;
	level.playerFallDamageSound = &zm_audio::playerFallDamageSound;
	/#
		println("Dev Block strings are not supported");
	#/
	init_clientfields();
	zm_perks::init();
	zm_powerups::init();
	zm_weapons::init();
	init_blocker_fx();
	init_riser_fx();
	init_zombie_explode_fx();
	level.gibResetTime = 0.5;
	level.gibMaxCount = 3;
	level.gibTimer = 0;
	level.gibCount = 0;
	level._gibEventCBFunc = &on_gib_event;
	level thread resetGibCounter();
	level thread ZPO_listener();
	level thread ZPOff_listener();
	level._BOX_INDICATOR_NO_LIGHTS = -1;
	level._BOX_INDICATOR_FLASH_LIGHTS_MOVING = 99;
	level._box_indicator = level._BOX_INDICATOR_NO_LIGHTS;
	util::REGISTER_SYSTEM("box_indicator", &box_monitor);
	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;
	level._ZOMBIE_GIB_PIECE_INDEX_HAT = 7;
	callback::add_callback("hash_da8d7d74", &basic_player_connect);
	callback::on_spawned(&player_duplicaterender);
	callback::on_spawned(&player_umbrahotfixes);
	level.update_aat_hud = &update_aat_hud;
	if(isdefined(level.setupCustomCharacterExerts))
	{
		[[level.setupCustomCharacterExerts]]();
	}
	level thread zm_ffotd::main_end();
	/#
		level thread function_9fee0219();
	#/
}

/*
	Name: delay_for_clients_then_execute
	Namespace: zm
	Checksum: 0xBE7CC57B
	Offset: 0x20C0
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function delay_for_clients_then_execute(func)
{
	wait(0.1);
	players = GetLocalPlayers();
	for(x = 0; x < players.size; x++)
	{
		while(!clienthassnapshot(x))
		{
			wait(0.05);
		}
	}
	wait(0.1);
	level thread [[func]]();
}

/*
	Name: function_9fee0219
	Namespace: zm
	Checksum: 0xBDF70B76
	Offset: 0x2160
	Size: 0x1B5
	Parameters: 0
	Flags: None
*/
function function_9fee0219()
{
	/#
		wait(0.1);
		players = GetLocalPlayers();
		for(x = 0; x < players.size; x++)
		{
			while(!clienthassnapshot(x))
			{
				wait(0.05);
			}
		}
		wait(0.1);
		if(!isdefined(level.var_478e3c32))
		{
			level.var_478e3c32 = [];
		}
		var_d38a76f6 = 0;
		while(1)
		{
			dvar_value = GetDvarInt("Dev Block strings are not supported");
			if(dvar_value != var_d38a76f6)
			{
				players = level.var_478e3c32;
				foreach(player in players)
				{
					player duplicate_render::set_dr_flag("Dev Block strings are not supported", !dvar_value);
					player duplicate_render::update_dr_filters(0);
				}
			}
			var_d38a76f6 = dvar_value;
			wait(1);
		}
	#/
}

/*
	Name: init_duplicaterender_settings
	Namespace: zm
	Checksum: 0x3B978554
	Offset: 0x2320
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function init_duplicaterender_settings()
{
	self oed_sitrepscan_enable(4);
	self oed_sitrepscan_setoutline(1);
	self oed_sitrepscan_setlinewidth(2);
	self oed_sitrepscan_setsolid(1);
	self oed_sitrepscan_setradius(800);
	self oed_sitrepscan_setfalloff(0.1);
	duplicate_render::set_dr_filter_offscreen("player_keyline", 25, "keyline_active", "keyline_disabled", 2, "mc/hud_keyline_zm_player", 1);
	duplicate_render::set_dr_filter_offscreen("player_keyline_ls", 30, "keyline_active,keyline_ls", "keyline_disabled", 2, "mc/hud_keyline_zm_player_ls", 1);
}

/*
	Name: player_duplicaterender
	Namespace: zm
	Checksum: 0x269E5211
	Offset: 0x2448
	Size: 0x1AB
	Parameters: 1
	Flags: None
*/
function player_duplicaterender(localClientNum)
{
	/#
		if(!isdefined(level.var_478e3c32))
		{
			level.var_478e3c32 = [];
		}
		if(!isdefined(level.var_478e3c32))
		{
			level.var_478e3c32 = [];
		}
		else if(!IsArray(level.var_478e3c32))
		{
			level.var_478e3c32 = Array(level.var_478e3c32);
		}
		level.var_478e3c32[level.var_478e3c32.size] = self;
	#/
	if(self == GetLocalPlayer(localClientNum))
	{
		self init_duplicaterender_settings();
		self thread force_update_player_clientfields(localClientNum);
	}
	if(self isPlayer() && self isLocalPlayer())
	{
		if(!isdefined(self getlocalclientnumber()) || localClientNum == self getlocalclientnumber())
		{
			return;
		}
	}
	dvar_value = GetDvarInt("scr_hide_player_keyline");
	self duplicate_render::set_dr_flag("keyline_active", !dvar_value);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: player_umbrahotfixes
	Namespace: zm
	Checksum: 0x6BA54B0D
	Offset: 0x2600
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function player_umbrahotfixes(localClientNum)
{
	if(!self isLocalPlayer() || !isdefined(self getlocalclientnumber()) || localClientNum != self getlocalclientnumber())
	{
		return;
	}
	self thread zm_utility::umbra_fix_logic(localClientNum);
}

/*
	Name: basic_player_connect
	Namespace: zm
	Checksum: 0xAAA20AB6
	Offset: 0x2688
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function basic_player_connect(localClientNum)
{
	if(!isdefined(level._laststand))
	{
		level._laststand = [];
	}
	level._laststand[localClientNum] = 0;
}

/*
	Name: force_update_player_clientfields
	Namespace: zm
	Checksum: 0x78FE4A60
	Offset: 0x26C8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function force_update_player_clientfields(localClientNum)
{
	self endon("entityshutdown");
	while(!clienthassnapshot(localClientNum))
	{
		wait(0.25);
	}
	wait(0.25);
	self ProcessClientFieldsAsIfNew();
}

/*
	Name: init_blocker_fx
	Namespace: zm
	Checksum: 0x99EC1590
	Offset: 0x2730
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_blocker_fx()
{
}

/*
	Name: init_riser_fx
	Namespace: zm
	Checksum: 0x585B51C4
	Offset: 0x2740
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function init_riser_fx()
{
	if(isdefined(level.use_new_riser_water) && level.use_new_riser_water)
	{
		level._effect["rise_burst_water"] = "_t6/maps/zombie/fx_mp_zombie_hand_water_burst";
		level._effect["rise_billow_water"] = "_t6/maps/zombie/fx_mp_zombie_body_water_billowing";
		level._effect["rise_dust_water"] = "_t6/maps/zombie/fx_zombie_body_wtr_falling";
	}
	level._effect["rise_burst"] = "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"] = "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	if(isdefined(level.riser_type) && level.riser_type == "snow")
	{
		level._effect["rise_burst_snow"] = "_t6/maps/zombie/fx_mp_zombie_hand_snow_burst";
		level._effect["rise_billow_snow"] = "_t6/maps/zombie/fx_mp_zombie_body_snow_billowing";
		level._effect["rise_dust_snow"] = "_t6/maps/zombie/fx_mp_zombie_body_snow_falling";
	}
}

/*
	Name: init_clientfields
	Namespace: zm
	Checksum: 0xD5279033
	Offset: 0x2880
	Size: 0x55B
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	/#
		println("Dev Block strings are not supported");
	#/
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, 1, 1);
	if(isdefined(level.use_water_risers) && level.use_water_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_water", 1, 1, "int", &handle_zombie_risers_water, 1, 1);
	}
	if(isdefined(level.use_foliage_risers) && level.use_foliage_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_foliage", 1, 1, "int", &handle_zombie_risers_foliage, 1, 1);
	}
	if(isdefined(level.use_low_gravity_risers) && level.use_low_gravity_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_lowg", 1, 1, "int", &handle_zombie_risers_lowg, 1, 1);
	}
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, 0, 1);
	clientfield::register("actor", "zombie_ragdoll_explode", 1, 1, "int", &zombie_ragdoll_explode_cb, 0, 1);
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &zombie_gut_explosion_cb, 0, 1);
	clientfield::register("actor", "sndZombieContext", -1, 1, "int", &zm_audio::sndSetZombieContext, 0, 1);
	clientfield::register("actor", "zombie_keyline_render", 1, 1, "int", &zombie_zombie_keyline_render_clientfield_cb, 0, 1);
	bits = 4;
	power = struct::get_array("elec_switch_fx", "script_noteworthy");
	if(isdefined(power))
	{
		bits = GetMinBitCountForNum(power.size + 1);
	}
	clientfield::register("world", "zombie_power_on", 1, bits, "int", &zombie_power_clientfield_on, 1, 1);
	clientfield::register("world", "zombie_power_off", 1, bits, "int", &zombie_power_clientfield_off, 1, 1);
	clientfield::register("world", "round_complete_time", 1, 20, "int", &round_complete_time, 0, 1);
	clientfield::register("world", "round_complete_num", 1, 8, "int", &round_complete_num, 0, 1);
	clientfield::register("world", "game_end_time", 1, 20, "int", &game_end_time, 0, 1);
	clientfield::register("world", "quest_complete_time", 1, 20, "int", &quest_complete_time, 0, 1);
	clientfield::register("world", "game_start_time", 15001, 20, "int", &game_start_time, 0, 1);
}

/*
	Name: box_monitor
	Namespace: zm
	Checksum: 0x4980C0B4
	Offset: 0x2DE8
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function box_monitor(clientNum, State, oldState)
{
	if(isdefined(level._custom_box_monitor))
	{
		[[level._custom_box_monitor]](clientNum, State, oldState);
	}
}

/*
	Name: ZPO_listener
	Namespace: zm
	Checksum: 0xE4E3F2C4
	Offset: 0x2E38
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function ZPO_listener()
{
	while(1)
	{
		Int = undefined;
		level waittill("ZPO", Int);
		if(isdefined(Int))
		{
			level notify("power_on", Int);
		}
		else
		{
			level notify("power_on");
		}
	}
}

/*
	Name: ZPOff_listener
	Namespace: zm
	Checksum: 0xFED6339A
	Offset: 0x2EA0
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function ZPOff_listener()
{
	while(1)
	{
		Int = undefined;
		level waittill("ZPOff", Int);
		if(isdefined(Int))
		{
			level notify("power_off", Int);
		}
		else
		{
			level notify("power_off");
		}
	}
}

/*
	Name: zombie_power_clientfield_on
	Namespace: zm
	Checksum: 0xFF682800
	Offset: 0x2F08
	Size: 0x55
	Parameters: 7
	Flags: None
*/
function zombie_power_clientfield_on(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level notify("ZPO", newVal);
	}
}

/*
	Name: zombie_power_clientfield_off
	Namespace: zm
	Checksum: 0x65CAE13C
	Offset: 0x2F68
	Size: 0x55
	Parameters: 7
	Flags: None
*/
function zombie_power_clientfield_off(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level notify("ZPOff", newVal);
	}
}

/*
	Name: round_complete_time
	Namespace: zm
	Checksum: 0x8FD681EA
	Offset: 0x2FC8
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function round_complete_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel(GetUIModelForController(localClientNum), "hudItems.time.round_complete_time");
	SetUIModelValue(model, newVal);
}

/*
	Name: round_complete_num
	Namespace: zm
	Checksum: 0x51BB72F1
	Offset: 0x3068
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function round_complete_num(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel(GetUIModelForController(localClientNum), "hudItems.time.round_complete_num");
	SetUIModelValue(model, newVal);
}

/*
	Name: game_end_time
	Namespace: zm
	Checksum: 0xF3D61731
	Offset: 0x3108
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function game_end_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel(GetUIModelForController(localClientNum), "hudItems.time.game_end_time");
	SetUIModelValue(model, newVal);
}

/*
	Name: quest_complete_time
	Namespace: zm
	Checksum: 0x3BB9A4A2
	Offset: 0x31A8
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function quest_complete_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel(GetUIModelForController(localClientNum), "hudItems.time.quest_complete_time");
	SetUIModelValue(model, newVal);
}

/*
	Name: game_start_time
	Namespace: zm
	Checksum: 0x24DF764D
	Offset: 0x3248
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function game_start_time(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel(GetUIModelForController(localClientNum), "hudItems.time.game_start_time");
	SetUIModelValue(model, newVal);
}

/*
	Name: createZombieEyesInternal
	Namespace: zm
	Checksum: 0xECB384B5
	Offset: 0x32E8
	Size: 0x101
	Parameters: 1
	Flags: None
*/
function createZombieEyesInternal(localClientNum)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self._eyeArray))
	{
		self._eyeArray = [];
	}
	if(!isdefined(self._eyeArray[localClientNum]))
	{
		linkTag = "j_eyeball_le";
		effect = level._effect["eye_glow"];
		if(isdefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		if(isdefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}
		if(isdefined(self._eyeglow_tag_override))
		{
			linkTag = self._eyeglow_tag_override;
		}
		self._eyeArray[localClientNum] = PlayFXOnTag(localClientNum, effect, self, linkTag);
	}
}

/*
	Name: createZombieEyes
	Namespace: zm
	Checksum: 0xF36F93B
	Offset: 0x33F8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function createZombieEyes(localClientNum)
{
	self thread createZombieEyesInternal(localClientNum);
}

/*
	Name: deleteZombieEyes
	Namespace: zm
	Checksum: 0x13F963A9
	Offset: 0x3428
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function deleteZombieEyes(localClientNum)
{
	if(isdefined(self._eyeArray))
	{
		if(isdefined(self._eyeArray[localClientNum]))
		{
			deletefx(localClientNum, self._eyeArray[localClientNum], 1);
			self._eyeArray[localClientNum] = undefined;
		}
	}
}

/*
	Name: player_eyes_clientfield_cb
	Namespace: zm
	Checksum: 0x8FCA5312
	Offset: 0x3490
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function player_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isPlayer())
	{
		self.zombie_face = newVal;
		self notify("face", "face_advance");
		if(isdefined(self.special_eyes) && self.special_eyes)
		{
		}
	}
	if(self isPlayer() && self isLocalPlayer() && !IsDemoPlaying())
	{
		if(localClientNum == self getlocalclientnumber())
		{
			return;
		}
	}
	if(!IsDemoPlaying())
	{
		zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
	else
	{
		zombie_eyes_demo_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: player_eye_color_clientfield_cb
	Namespace: zm
	Checksum: 0xC5AE85D2
	Offset: 0x3610
	Size: 0x1B3
	Parameters: 7
	Flags: None
*/
function player_eye_color_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isPlayer() && self isLocalPlayer() && !IsDemoPlaying())
	{
		if(localClientNum == self getlocalclientnumber())
		{
			return;
		}
	}
	if(!isdefined(self.special_eyes) || self.special_eyes != newVal)
	{
		self.special_eyes = newVal;
		if(isdefined(self.special_eyes) && self.special_eyes)
		{
			self._eyeglow_fx_override = level._effect["player_eye_glow_blue"];
		}
		else
		{
			self._eyeglow_fx_override = level._effect["player_eye_glow_orng"];
		}
		if(!IsDemoPlaying())
		{
			zombie_eyes_clientfield_cb(localClientNum, 0, isdefined(self.zombie_face) && self.zombie_face, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		}
		else
		{
			zombie_eyes_demo_clientfield_cb(localClientNum, 0, isdefined(self.zombie_face) && self.zombie_face, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		}
	}
}

/*
	Name: zombie_eyes_handle_demo_jump
	Namespace: zm
	Checksum: 0x9A4AF5ED
	Offset: 0x37D0
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function zombie_eyes_handle_demo_jump(localClientNum)
{
	self endon("entityshutdown");
	self endon("death_or_disconnect");
	self endon("new_zombie_eye_cb");
	while(1)
	{
		level util::waittill_any("demo_jump", "demo_player_switch");
		self deleteZombieEyes(localClientNum);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
		self.eyes_spawned = 0;
	}
}

/*
	Name: zombie_eyes_demo_watcher
	Namespace: zm
	Checksum: 0xD44A2B10
	Offset: 0x38A8
	Size: 0x25F
	Parameters: 7
	Flags: None
*/
function zombie_eyes_demo_watcher(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self endon("death_or_disconnect");
	self endon("new_zombie_eye_cb");
	self thread zombie_eyes_handle_demo_jump(localClientNum);
	if(newVal)
	{
		while(1)
		{
			if(!self isLocalPlayer() || IsSpectating(localClientNum, 1) || localClientNum != self getlocalclientnumber())
			{
				if(!(isdefined(self.eyes_spawned) && self.eyes_spawned))
				{
					self createZombieEyes(localClientNum);
					self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
					self.eyes_spawned = 1;
				}
			}
			else if(isdefined(self.eyes_spawned) && self.eyes_spawned)
			{
				self deleteZombieEyes(localClientNum);
				self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
				self.eyes_spawned = 0;
			}
			wait(0.016);
		}
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
		self.eyes_spawned = 0;
	}
}

/*
	Name: zombie_eyes_demo_clientfield_cb
	Namespace: zm
	Checksum: 0x4E7A70F1
	Offset: 0x3B10
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function zombie_eyes_demo_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("new_zombie_eye_cb");
	self thread zombie_eyes_demo_watcher(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
}

/*
	Name: zombie_eyes_clientfield_cb
	Namespace: zm
	Checksum: 0x87CC82E5
	Offset: 0x3B98
	Size: 0x153
	Parameters: 7
	Flags: None
*/
function zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(newVal)
	{
		self createZombieEyes(localClientNum);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
	}
	if(isdefined(level.zombie_eyes_clientfield_cb_additional))
	{
		self [[level.zombie_eyes_clientfield_cb_additional]](localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: zombie_zombie_keyline_render_clientfield_cb
	Namespace: zm
	Checksum: 0xB6E6AA2C
	Offset: 0x3CF8
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function zombie_zombie_keyline_render_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		if(newVal)
		{
			self duplicate_render::set_dr_flag("keyline_active", 1);
			self duplicate_render::update_dr_filters(localClientNum);
		}
		else
		{
			self duplicate_render::set_dr_flag("keyline_active", 0);
			self duplicate_render::update_dr_filters(localClientNum);
		}
	}
}

/*
	Name: get_eyeball_on_luminance
	Namespace: zm
	Checksum: 0xA327895A
	Offset: 0x3DD8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function get_eyeball_on_luminance()
{
	if(isdefined(level.eyeball_on_luminance_override))
	{
		return level.eyeball_on_luminance_override;
	}
	return 1;
}

/*
	Name: get_eyeball_off_luminance
	Namespace: zm
	Checksum: 0x4D816DF3
	Offset: 0x3E00
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function get_eyeball_off_luminance()
{
	if(isdefined(level.eyeball_off_luminance_override))
	{
		return level.eyeball_off_luminance_override;
	}
	return 0;
}

/*
	Name: get_eyeball_color
	Namespace: zm
	Checksum: 0x3BFA785E
	Offset: 0x3E28
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function get_eyeball_color()
{
	VAL = 0;
	if(isdefined(level.zombie_eyeball_color_override))
	{
		VAL = level.zombie_eyeball_color_override;
	}
	if(isdefined(self.zombie_eyeball_color_override))
	{
		VAL = self.zombie_eyeball_color_override;
	}
	return VAL;
}

/*
	Name: zombie_ragdoll_explode_cb
	Namespace: zm
	Checksum: 0xC9C33D0B
	Offset: 0x3E78
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function zombie_ragdoll_explode_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self zombie_wait_explode(localClientNum);
	}
}

/*
	Name: zombie_gut_explosion_cb
	Namespace: zm
	Checksum: 0x503B4312
	Offset: 0x3EE0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function zombie_gut_explosion_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]))
		{
			org = self GetTagOrigin("J_SpineLower");
			if(isdefined(org))
			{
				playFX(localClientNum, level._effect["zombie_guts_explosion"], org);
			}
		}
	}
}

/*
	Name: init_zombie_explode_fx
	Namespace: zm
	Checksum: 0x2C45CC35
	Offset: 0x3FA0
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function init_zombie_explode_fx()
{
	level._effect["zombie_guts_explosion"] = "zombie/fx_blood_torso_explo_lg_zmb";
}

/*
	Name: zombie_wait_explode
	Namespace: zm
	Checksum: 0xBBF4EBF6
	Offset: 0x3FC8
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function zombie_wait_explode(localClientNum)
{
	where = self GetTagOrigin("J_SpineLower");
	if(!isdefined(where))
	{
		where = self.origin;
	}
	start = GetTime();
	while(GetTime() - start < 2000)
	{
		if(isdefined(self))
		{
			where = self GetTagOrigin("J_SpineLower");
			if(!isdefined(where))
			{
				where = self.origin;
			}
		}
		wait(0.05);
	}
	if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
	{
		playFX(localClientNum, level._effect["zombie_guts_explosion"], where);
	}
}

/*
	Name: mark_piece_gibbed
	Namespace: zm
	Checksum: 0x966D6779
	Offset: 0x40E8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function mark_piece_gibbed(piece_index)
{
	if(!isdefined(self.gibbed_pieces))
	{
		self.gibbed_pieces = [];
	}
	self.gibbed_pieces[self.gibbed_pieces.size] = piece_index;
}

/*
	Name: has_gibbed_piece
	Namespace: zm
	Checksum: 0x69F97B7
	Offset: 0x4130
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function has_gibbed_piece(piece_index)
{
	if(!isdefined(self.gibbed_pieces))
	{
		return 0;
	}
	for(i = 0; i < self.gibbed_pieces.size; i++)
	{
		if(self.gibbed_pieces[i] == piece_index)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: do_headshot_gib_fx
	Namespace: zm
	Checksum: 0xB0987D6A
	Offset: 0x41A0
	Size: 0x1E5
	Parameters: 0
	Flags: None
*/
function do_headshot_gib_fx()
{
	fxTag = "j_neck";
	fxOrigin = self GetTagOrigin(fxTag);
	upvec = anglesToUp(self GetTagAngles(fxTag));
	forwardVec = AnglesToForward(self GetTagAngles(fxTag));
	players = level.localPlayers;
	for(i = 0; i < players.size; i++)
	{
		playFX(i, level._effect["headshot"], fxOrigin, forwardVec, upvec);
		playFX(i, level._effect["headshot_nochunks"], fxOrigin, forwardVec, upvec);
	}
	playsound(0, "zmb_zombie_head_gib", fxOrigin);
	wait(0.3);
	if(isdefined(self))
	{
		players = level.localPlayers;
		for(i = 0; i < players.size; i++)
		{
			PlayFXOnTag(i, level._effect["bloodspurt"], self, fxTag);
		}
	}
}

/*
	Name: do_gib_fx
	Namespace: zm
	Checksum: 0xC1E6A91B
	Offset: 0x4390
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function do_gib_fx(tag)
{
	players = level.localPlayers;
	for(i = 0; i < players.size; i++)
	{
		PlayFXOnTag(i, level._effect["animscript_gib_fx"], self, tag);
	}
	playsound(0, "zmb_death_gibs", self GetTagOrigin(tag));
}

/*
	Name: do_gib
	Namespace: zm
	Checksum: 0x12003A1D
	Offset: 0x4448
	Size: 0x22B
	Parameters: 2
	Flags: None
*/
function do_gib(model, tag)
{
	start_pos = self GetTagOrigin(tag);
	start_angles = self GetTagAngles(tag);
	wait(0.016);
	end_pos = undefined;
	angles = undefined;
	if(!isdefined(self))
	{
		end_pos = start_pos + AnglesToForward(start_angles) * 10;
		angles = start_angles;
	}
	else
	{
		end_pos = self GetTagOrigin(tag);
		angles = self GetTagAngles(tag);
	}
	if(isdefined(self._gib_vel))
	{
		FORWARD = self._gib_vel;
		self._gib_vel = undefined;
	}
	else
	{
		FORWARD = VectorNormalize(end_pos - start_pos);
		FORWARD = FORWARD * RandomFloatRange(0.6, 1);
		FORWARD = FORWARD + (0, 0, RandomFloatRange(0.4, 0.7));
	}
	CreateDynEntAndLaunch(0, model, end_pos, angles, start_pos, FORWARD, level._effect["animscript_gibtrail_fx"], 1);
	if(isdefined(self))
	{
		self do_gib_fx(tag);
	}
	else
	{
		playsound(0, "zmb_death_gibs", end_pos);
	}
}

/*
	Name: do_hat_gib
	Namespace: zm
	Checksum: 0x53BE97EF
	Offset: 0x4680
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function do_hat_gib(model, tag)
{
	start_pos = self GetTagOrigin(tag);
	start_angles = self GetTagAngles(tag);
	up_angles = (0, 0, 1);
	force = (0, 0, RandomFloatRange(1.4, 1.7));
	CreateDynEntAndLaunch(0, model, start_pos, up_angles, start_pos, force);
}

/*
	Name: check_should_gib
	Namespace: zm
	Checksum: 0x270F64BE
	Offset: 0x4758
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function check_should_gib()
{
	if(level.gibCount <= level.gibMaxCount)
	{
		return 1;
	}
	return 0;
}

/*
	Name: resetGibCounter
	Namespace: zm
	Checksum: 0xB04A2A36
	Offset: 0x4780
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function resetGibCounter()
{
	self endon("disconnect");
	while(1)
	{
		wait(level.gibResetTime);
		level.gibTimer = 0;
		level.gibCount = 0;
	}
}

/*
	Name: on_gib_event
	Namespace: zm
	Checksum: 0x15B437B9
	Offset: 0x47C8
	Size: 0x6FB
	Parameters: 3
	Flags: None
*/
function on_gib_event(localClientNum, type, locations)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(!util::is_mature())
	{
		return;
	}
	if(!isdefined(self._gib_def))
	{
		return;
	}
	if(isdefined(level._gib_overload_func))
	{
		if(self [[level._gib_overload_func]](type, locations))
		{
			return;
		}
	}
	if(!check_should_gib())
	{
		return;
	}
	level.gibCount++;
	for(i = 0; i < locations.size; i++)
	{
		if(isdefined(self.gibbed) && level._ZOMBIE_GIB_PIECE_INDEX_HEAD != locations[i])
		{
			break;
		}
		switch(locations[i])
		{
			case 0:
			{
				if(isdefined(self._gib_def.gibSpawn1) && isdefined(self._gib_def.gibSpawnTag1))
				{
					self thread do_gib(self._gib_def.gibSpawn1, self._gib_def.gibSpawnTag1);
				}
				if(isdefined(self._gib_def.gibSpawn2) && isdefined(self._gib_def.gibSpawnTag2))
				{
					self thread do_gib(self._gib_def.gibSpawn2, self._gib_def.gibSpawnTag2);
				}
				if(isdefined(self._gib_def.gibSpawn3) && isdefined(self._gib_def.gibSpawnTag3))
				{
					self thread do_gib(self._gib_def.gibSpawn3, self._gib_def.gibSpawnTag3);
				}
				if(isdefined(self._gib_def.gibSpawn4) && isdefined(self._gib_def.gibSpawnTag4))
				{
					self thread do_gib(self._gib_def.gibSpawn4, self._gib_def.gibSpawnTag4);
				}
				if(isdefined(self._gib_def.gibSpawn5) && isdefined(self._gib_def.gibSpawnTag5))
				{
					self thread do_hat_gib(self._gib_def.gibSpawn5, self._gib_def.gibSpawnTag5);
				}
				self thread do_headshot_gib_fx();
				self thread do_gib_fx("J_SpineLower");
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM);
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM);
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG);
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG);
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_HEAD);
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_HAT);
				break;
			}
			case 1:
			{
				if(isdefined(self._gib_def.gibSpawn1) && isdefined(self._gib_def.gibSpawnTag1))
				{
					self thread do_gib(self._gib_def.gibSpawn1, self._gib_def.gibSpawnTag1);
				}
				else
				{
				}
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM);
				break;
			}
			case 2:
			{
				if(isdefined(self._gib_def.gibSpawn2) && isdefined(self._gib_def.gibSpawnTag2))
				{
					self thread do_gib(self._gib_def.gibSpawn2, self._gib_def.gibSpawnTag2);
				}
				else
				{
				}
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM);
				break;
			}
			case 3:
			{
				if(isdefined(self._gib_def.gibSpawn3) && isdefined(self._gib_def.gibSpawnTag3))
				{
					self thread do_gib(self._gib_def.gibSpawn3, self._gib_def.gibSpawnTag3);
				}
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG);
				break;
			}
			case 4:
			{
				if(isdefined(self._gib_def.gibSpawn4) && isdefined(self._gib_def.gibSpawnTag4))
				{
					self thread do_gib(self._gib_def.gibSpawn4, self._gib_def.gibSpawnTag4);
				}
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG);
				break;
			}
			case 5:
			{
				self thread do_headshot_gib_fx();
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_HEAD);
				break;
			}
			case 6:
			{
				self thread do_gib_fx("J_SpineLower");
				break;
			}
			case 7:
			{
				if(isdefined(self._gib_def.gibSpawn5) && isdefined(self._gib_def.gibSpawnTag5))
				{
					self thread do_hat_gib(self._gib_def.gibSpawn5, self._gib_def.gibSpawnTag5);
				}
				mark_piece_gibbed(level._ZOMBIE_GIB_PIECE_INDEX_HAT);
				break;
			}
		}
	}
	self.gibbed = 1;
}

/*
	Name: zombie_vision_set_apply
	Namespace: zm
	Checksum: 0x4B2DFF80
	Offset: 0x4ED0
	Size: 0x283
	Parameters: 4
	Flags: None
*/
function zombie_vision_set_apply(str_visionset, int_priority, flt_transition_time, int_clientnum)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self._zombie_visionset_list))
	{
		self._zombie_visionset_list = [];
	}
	if(!isdefined(str_visionset) || !isdefined(int_priority))
	{
		return;
	}
	if(!isdefined(flt_transition_time))
	{
		flt_transition_time = 1;
	}
	if(!isdefined(int_clientnum))
	{
		if(self isLocalPlayer())
		{
			int_clientnum = self getlocalclientnumber();
		}
		if(!isdefined(int_clientnum))
		{
			return;
		}
	}
	already_in_array = 0;
	if(self._zombie_visionset_list.size != 0)
	{
		for(i = 0; i < self._zombie_visionset_list.size; i++)
		{
			if(isdefined(self._zombie_visionset_list[i].vision_set) && self._zombie_visionset_list[i].vision_set == str_visionset)
			{
				already_in_array = 1;
				if(self._zombie_visionset_list[i].priority != int_priority)
				{
					self._zombie_visionset_list[i].priority = int_priority;
				}
				break;
			}
		}
	}
	else if(!already_in_array)
	{
		temp_struct = spawnstruct();
		temp_struct.vision_set = str_visionset;
		temp_struct.priority = int_priority;
		Array::add(self._zombie_visionset_list, temp_struct, 0);
	}
	vision_to_set = self zombie_highest_vision_set_apply();
	if(isdefined(vision_to_set))
	{
		visionSetNaked(int_clientnum, vision_to_set, flt_transition_time);
	}
	else
	{
		visionSetNaked(int_clientnum, "undefined", flt_transition_time);
	}
}

/*
	Name: zombie_vision_set_remove
	Namespace: zm
	Checksum: 0x362D963E
	Offset: 0x5160
	Size: 0x1DB
	Parameters: 3
	Flags: None
*/
function zombie_vision_set_remove(str_visionset, flt_transition_time, int_clientnum)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(str_visionset))
	{
		return;
	}
	if(!isdefined(flt_transition_time))
	{
		flt_transition_time = 1;
	}
	if(!isdefined(self._zombie_visionset_list))
	{
		self._zombie_visionset_list = [];
	}
	if(!isdefined(int_clientnum))
	{
		if(self isLocalPlayer())
		{
			int_clientnum = self getlocalclientnumber();
		}
		if(!isdefined(int_clientnum))
		{
			return;
		}
	}
	temp_struct = undefined;
	for(i = 0; i < self._zombie_visionset_list.size; i++)
	{
		if(isdefined(self._zombie_visionset_list[i].vision_set) && self._zombie_visionset_list[i].vision_set == str_visionset)
		{
			temp_struct = self._zombie_visionset_list[i];
		}
	}
	if(isdefined(temp_struct))
	{
		ArrayRemoveValue(self._zombie_visionset_list, temp_struct);
	}
	vision_to_set = self zombie_highest_vision_set_apply();
	if(isdefined(vision_to_set))
	{
		visionSetNaked(int_clientnum, vision_to_set, flt_transition_time);
	}
	else
	{
		visionSetNaked(int_clientnum, "undefined", flt_transition_time);
	}
}

/*
	Name: zombie_highest_vision_set_apply
	Namespace: zm
	Checksum: 0x60DA8DFC
	Offset: 0x5348
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function zombie_highest_vision_set_apply()
{
	if(!isdefined(self._zombie_visionset_list))
	{
		return;
	}
	highest_score = 0;
	highest_score_vision = undefined;
	for(i = 0; i < self._zombie_visionset_list.size; i++)
	{
		if(isdefined(self._zombie_visionset_list[i].priority) && self._zombie_visionset_list[i].priority > highest_score)
		{
			highest_score = self._zombie_visionset_list[i].priority;
			highest_score_vision = self._zombie_visionset_list[i].vision_set;
		}
	}
	return highest_score_vision;
}

/*
	Name: handle_zombie_risers_foliage
	Namespace: zm
	Checksum: 0xE95875E5
	Offset: 0x5430
	Size: 0x13D
	Parameters: 7
	Flags: None
*/
function handle_zombie_risers_foliage(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	if(!oldVal && newVal)
	{
		localPlayers = level.localPlayers;
		playsound(0, "zmb_zombie_spawn", self.origin);
		burst_fx = level._effect["rise_burst_foliage"];
		billow_fx = level._effect["rise_billow_foliage"];
		type = "foliage";
		for(i = 0; i < localPlayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: handle_zombie_risers_water
	Namespace: zm
	Checksum: 0x7B816927
	Offset: 0x5578
	Size: 0x13D
	Parameters: 7
	Flags: None
*/
function handle_zombie_risers_water(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	if(!oldVal && newVal)
	{
		localPlayers = level.localPlayers;
		playsound(0, "zmb_zombie_spawn_water", self.origin);
		burst_fx = level._effect["rise_burst_water"];
		billow_fx = level._effect["rise_billow_water"];
		type = "water";
		for(i = 0; i < localPlayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: handle_zombie_risers
	Namespace: zm
	Checksum: 0x8DF561FE
	Offset: 0x56C0
	Size: 0x1BD
	Parameters: 7
	Flags: None
*/
function handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	if(!oldVal && newVal)
	{
		localPlayers = level.localPlayers;
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		if(isdefined(level.riser_type) && level.riser_type == "snow")
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}
		playsound(0, sound, self.origin);
		for(i = 0; i < localPlayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: handle_zombie_risers_lowg
	Namespace: zm
	Checksum: 0x18C23C07
	Offset: 0x5888
	Size: 0x1BD
	Parameters: 7
	Flags: None
*/
function handle_zombie_risers_lowg(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	if(!oldVal && newVal)
	{
		localPlayers = level.localPlayers;
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst_lg"];
		billow_fx = level._effect["rise_billow_lg"];
		type = "dirt";
		if(isdefined(level.riser_type) && level.riser_type == "snow")
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}
		playsound(0, sound, self.origin);
		for(i = 0; i < localPlayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: rise_dust_fx
	Namespace: zm
	Checksum: 0x1B3B914
	Offset: 0x5A50
	Size: 0x325
	Parameters: 4
	Flags: None
*/
function rise_dust_fx(clientNum, type, billow_fx, burst_fx)
{
	dust_tag = "J_SpineUpper";
	self endon("entityshutdown");
	level endon("demo_jump");
	if(isdefined(level.zombie_custom_riser_fx_handler))
	{
		s_info = self [[level.zombie_custom_riser_fx_handler]]();
		if(isdefined(s_info))
		{
			if(isdefined(s_info.burst_fx))
			{
				burst_fx = s_info.burst_fx;
			}
			if(isdefined(s_info.billow_fx))
			{
				billow_fx = s_info.billow_fx;
			}
			if(isdefined(s_info.type))
			{
				type = s_info.type;
			}
		}
	}
	if(isdefined(burst_fx))
	{
		playFX(clientNum, burst_fx, self.origin + (0, 0, randomIntRange(5, 10)));
	}
	wait(0.25);
	if(isdefined(billow_fx))
	{
		playFX(clientNum, billow_fx, self.origin + (randomIntRange(-10, 10), randomIntRange(-10, 10), randomIntRange(5, 10)));
	}
	wait(2);
	dust_time = 5.5;
	dust_interval = 0.3;
	player = level.localPlayers[clientNum];
	effect = level._effect["rise_dust"];
	if(type == "water")
	{
		effect = level._effect["rise_dust_water"];
	}
	else if(type == "snow")
	{
		effect = level._effect["rise_dust_snow"];
	}
	else if(type == "foliage")
	{
		effect = level._effect["rise_dust_foliage"];
	}
	else if(type == "none")
	{
		return;
	}
	for(t = 0; t < dust_time;  = 0)
	{
		if(!isdefined(self))
		{
			return;
		}
		PlayFXOnTag(clientNum, effect, self, dust_tag);
		wait(dust_interval);
	}
}

/*
	Name: end_last_stand
	Namespace: zm
	Checksum: 0x34AA64E8
	Offset: 0x5D80
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function end_last_stand(clientNum)
{
	self waittill("lastStandEnd");
	/#
		println("Dev Block strings are not supported" + clientNum);
	#/
	WaitRealTime(0.7);
	/#
		println("Dev Block strings are not supported");
	#/
	playsound(clientNum, "revive_gasp");
}

/*
	Name: last_stand_thread
	Namespace: zm
	Checksum: 0xD875607
	Offset: 0x5E10
	Size: 0x177
	Parameters: 1
	Flags: None
*/
function last_stand_thread(clientNum)
{
	self thread end_last_stand(clientNum);
	self endon("lastStandEnd");
	/#
		println("Dev Block strings are not supported" + clientNum);
	#/
	Pause = 0.5;
	VOL = 0.5;
	while(1)
	{
		id = playsound(clientNum, "chr_heart_beat");
		setSoundVolume(id, VOL);
		WaitRealTime(Pause);
		if(Pause < 2)
		{
			Pause = Pause * 1.05;
			if(Pause > 2)
			{
				Pause = 2;
			}
		}
		if(VOL < 1)
		{
			VOL = VOL * 1.05;
			if(VOL > 1)
			{
				VOL = 1;
			}
		}
	}
}

/*
	Name: last_stand_monitor
	Namespace: zm
	Checksum: 0x1839CDCE
	Offset: 0x5F90
	Size: 0x19D
	Parameters: 3
	Flags: None
*/
function last_stand_monitor(clientNum, State, oldState)
{
	player = level.localPlayers[clientNum];
	players = level.localPlayers;
	if(!isdefined(player))
	{
		return;
	}
	if(State == "1")
	{
		if(!level._laststand[clientNum])
		{
			if(!isdefined(level.lslooper))
			{
				level.lslooper = spawn(0, player.origin, "script.origin");
			}
			player thread last_stand_thread(clientNum);
			if(players.size <= 1)
			{
				level.lslooper PlayLoopSound("evt_laststand_loop", 0.3);
			}
			level._laststand[clientNum] = 1;
		}
	}
	else if(level._laststand[clientNum])
	{
		if(isdefined(level.lslooper))
		{
			level.lslooper StopAllLoopSounds(0.7);
			playsound(0, "evt_laststand_in", (0, 0, 0));
		}
		player notify("lastStandEnd");
		level._laststand[clientNum] = 0;
	}
}

/*
	Name: laststand
	Namespace: zm
	Checksum: 0x8AB02A33
	Offset: 0x6138
	Size: 0x1B3
	Parameters: 7
	Flags: None
*/
function laststand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!(self isPlayer() && self isLocalPlayer() && IsDemoPlaying()))
		{
			self duplicate_render::set_dr_flag("keyline_ls", 1);
			self duplicate_render::update_dr_filters(localClientNum);
		}
	}
	else
	{
		self duplicate_render::set_dr_flag("keyline_ls", 0);
		self duplicate_render::update_dr_filters(localClientNum);
	}
	if(self isPlayer() && self isLocalPlayer() && !IsDemoPlaying())
	{
		if(isdefined(self getlocalclientnumber()) && localClientNum == self getlocalclientnumber())
		{
			self zm_audio::sndZmbLaststand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		}
	}
}

/*
	Name: update_aat_hud
	Namespace: zm
	Checksum: 0xB29BD461
	Offset: 0x62F8
	Size: 0x14B
	Parameters: 7
	Flags: None
*/
function update_aat_hud(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	str_localized = AAT::get_string(newVal);
	icon = AAT::get_icon(newVal);
	if(str_localized == "none")
	{
		str_localized = "";
	}
	controllerModel = GetUIModelForController(localClientNum);
	AATModel = CreateUIModel(controllerModel, "CurrentWeapon.aat");
	SetUIModelValue(AATModel, str_localized);
	AATIconModel = CreateUIModel(controllerModel, "CurrentWeapon.aatIcon");
	SetUIModelValue(AATIconModel, icon);
}

