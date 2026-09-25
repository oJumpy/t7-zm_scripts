#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_ai_quad;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
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
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_theater_amb;
#using scripts\zm\zm_theater_ffotd;
#using scripts\zm\zm_theater_fx;
#using scripts\zm\zm_theater_teleporter;

#namespace namespace_aed37ba8;

/*
	Name: opt_in
	Namespace: namespace_aed37ba8
	Checksum: 0x341B7D08
	Offset: 0x920
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
	Namespace: namespace_aed37ba8
	Checksum: 0x795593A6
	Offset: 0x948
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_16a77fe2::main_start();
	include_weapons();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	visionset_mgr::register_visionset_info("flare", 21000, 1, "flare", "flare");
	visionset_mgr::register_visionset_info("cheat_bw_contrast", 21000, 1, "cheat_bw_contrast", "cheat_bw_invert_contrast");
	visionset_mgr::register_visionset_info("cheat_bw_invert_contrast", 21000, 1, "cheat_bw_invert_contrast", "cheat_bw_invert_contrast");
	visionset_mgr::register_visionset_info("zombie_turned", 21000, 1, "zombie_turned", "zombie_turned");
	register_clientfields();
	namespace_8847920b::main();
	namespace_265ae7e9::main();
	namespace_6d4f3e39::main();
	level._BOX_INDICATOR_FLASH_LIGHTS_FIRE_SALE = 98;
	init_theater_box_indicator();
	load::main();
	_zm_weap_cymbal_monkey::init();
	thread util::waitforclient(0);
	level._power_on = 0;
	level thread theatre_ZPO_listener();
	level thread function_6ac83719();
	level thread theater_light_model_swap_init();
	level thread function_d87a7dcc();
	level thread function_d19cb2f8();
	namespace_16a77fe2::main_end();
}

/*
	Name: function_6ac83719
	Namespace: namespace_aed37ba8
	Checksum: 0x248FCAE
	Offset: 0xB80
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_6ac83719()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zm_theater", 0);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zm_theater");
	visionset_mgr::fog_vol_to_visionset_set_info(1, "zombie_theater_erooms_pentagon");
	visionset_mgr::fog_vol_to_visionset_set_info(2, "zombie_theater_eroom_asylum");
	visionset_mgr::fog_vol_to_visionset_set_info(3, "zombie_theater_eroom_girlold");
	visionset_mgr::fog_vol_to_visionset_set_info(4, "zombie_theater_eroom_girlnew");
}

/*
	Name: function_d87a7dcc
	Namespace: namespace_aed37ba8
	Checksum: 0x5CC94BDC
	Offset: 0xC60
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function function_d87a7dcc()
{
	if(isdefined(level.createFX_enabled) && level.createFX_enabled)
	{
		return;
	}
	var_bd7ba30 = 0;
	while(1)
	{
		if(!level clientfield::get("zombie_power_on"))
		{
			level.power_on = 0;
			if(var_bd7ba30)
			{
				level notify("power_controlled_light");
			}
			level util::waittill_any("power_on", "pwr", "ZPO");
		}
		level notify("power_controlled_light");
		level util::waittill_any("pwo", "ZPOff");
		var_bd7ba30 = 1;
	}
}

/*
	Name: include_weapons
	Namespace: namespace_aed37ba8
	Checksum: 0xB0A4E944
	Offset: 0xD50
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_theater_weapons.csv", 1);
}

/*
	Name: init_theater_box_indicator
	Namespace: namespace_aed37ba8
	Checksum: 0x18683985
	Offset: 0xD80
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function init_theater_box_indicator()
{
	level._custom_box_monitor = &theater_box_monitor;
	level._box_locations = Array("start_chest_loc", "foyer_chest_loc", "crematorium_chest_loc", "alleyway_chest_loc", "control_chest_loc", "stage_chest_loc", "dressing_chest_loc", "dining_chest_loc", "theater_chest_loc");
	callback::on_localclient_connect(&init_board_lights);
}

/*
	Name: init_board_lights
	Namespace: namespace_aed37ba8
	Checksum: 0x872138A
	Offset: 0xE28
	Size: 0x1A7
	Parameters: 1
	Flags: None
*/
function init_board_lights(clientNum)
{
	structs = struct::get_array("magic_box_loc_light", "targetname");
	for(j = 0; j < structs.size; j++)
	{
		s = structs[j];
		if(!isdefined(s.lights))
		{
			s.lights = [];
		}
		if(isdefined(s.lights[clientNum]))
		{
			if(isdefined(s.lights[clientNum].FX))
			{
				s.lights[clientNum].FX delete();
				s.lights[clientNum].FX = undefined;
			}
			s.lights[clientNum] delete();
			s.lights[clientNum] = undefined;
		}
		s.lights[clientNum] = util::spawn_model(clientNum, "p7_zm_nac_cagelight", s.origin, s.angles);
	}
}

/*
	Name: get_lights
	Namespace: namespace_aed37ba8
	Checksum: 0x1D0AF62B
	Offset: 0xFD8
	Size: 0xF5
	Parameters: 2
	Flags: None
*/
function get_lights(clientNum, name)
{
	structs = struct::get_array(name, "script_noteworthy");
	lights = [];
	for(i = 0; i < structs.size; i++)
	{
		lights[lights.size] = structs[i].lights[clientNum];
		if(structs[i].script_string === "move_fx")
		{
			lights[lights.size - 1].script_string = structs[i].script_string;
		}
	}
	return lights;
}

/*
	Name: turn_off_all_box_lights
	Namespace: namespace_aed37ba8
	Checksum: 0x4351C4A7
	Offset: 0x10D8
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function turn_off_all_box_lights(clientNum)
{
	level notify("kill_box_light_threads_" + clientNum);
	for(i = 0; i < level._box_locations.size; i++)
	{
		turn_off_light(clientNum, i);
	}
}

/*
	Name: flash_lights
	Namespace: namespace_aed37ba8
	Checksum: 0xA118788A
	Offset: 0x1148
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function flash_lights(clientNum, period)
{
	level notify("kill_box_light_threads_" + clientNum);
	level endon("kill_box_light_threads_" + clientNum);
	while(1)
	{
		wait(period);
		for(i = 0; i < level._box_locations.size; i++)
		{
			turn_light_green(clientNum, i);
		}
		wait(period);
		for(i = 0; i < level._box_locations.size; i++)
		{
			turn_off_light(clientNum, i, 1);
		}
	}
}

/*
	Name: turn_light_green
	Namespace: namespace_aed37ba8
	Checksum: 0xCB63C5
	Offset: 0x1230
	Size: 0x7B
	Parameters: 3
	Flags: None
*/
function turn_light_green(clientNum, light_num, play_fx)
{
	if(!isdefined(play_fx))
	{
		play_fx = 0;
	}
	if(light_num == level._BOX_INDICATOR_NO_LIGHTS)
	{
		return;
	}
	name = level._box_locations[light_num] + "_lgt";
	exploder::exploder(name);
}

/*
	Name: turn_off_light
	Namespace: namespace_aed37ba8
	Checksum: 0xDC3FB92A
	Offset: 0x12B8
	Size: 0x83
	Parameters: 3
	Flags: None
*/
function turn_off_light(clientNum, light_num, dont_kill_threads)
{
	if(!isdefined(dont_kill_threads))
	{
		level notify("kill_box_light_threads_" + clientNum);
	}
	if(light_num == level._BOX_INDICATOR_NO_LIGHTS)
	{
		return;
	}
	name = level._box_locations[light_num] + "_lgt";
	exploder::stop_exploder(name);
}

/*
	Name: theater_box_monitor
	Namespace: namespace_aed37ba8
	Checksum: 0xEA5B77C0
	Offset: 0x1348
	Size: 0x16B
	Parameters: 3
	Flags: None
*/
function theater_box_monitor(clientNum, State, oldState)
{
	s = Int(State);
	if(s == level._BOX_INDICATOR_NO_LIGHTS)
	{
		turn_off_all_box_lights(clientNum);
	}
	else if(s == level._BOX_INDICATOR_FLASH_LIGHTS_MOVING)
	{
		level thread flash_lights(clientNum, 0.25);
	}
	else if(s == level._BOX_INDICATOR_FLASH_LIGHTS_FIRE_SALE)
	{
		level thread flash_lights(clientNum, 0.3);
	}
	else if(s < 0 || s > level._box_locations.size)
	{
		return;
	}
	level notify("kill_box_light_threads_" + clientNum);
	turn_off_all_box_lights(clientNum);
	level._box_indicator = s;
	if(level clientfield::get("zombie_power_on"))
	{
		turn_light_green(clientNum, level._box_indicator, 1);
	}
}

/*
	Name: theatre_ZPO_listener
	Namespace: namespace_aed37ba8
	Checksum: 0x735B9AFC
	Offset: 0x14C0
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function theatre_ZPO_listener()
{
	wait(0.016);
	if(!level clientfield::get("zombie_power_on"))
	{
		level waittill("ZPO");
	}
	while(1)
	{
		level._power_on = 1;
		if(level._box_indicator != level._BOX_INDICATOR_NO_LIGHTS)
		{
			for(i = 0; i < GetLocalPlayers().size; i++)
			{
				theater_box_monitor(i, level._box_indicator);
			}
		}
		level notify("threeprimaries_on");
		level notify("pl1");
		level waittill("ZPO");
	}
}

/*
	Name: theater_light_model_swap_init
	Namespace: namespace_aed37ba8
	Checksum: 0xFD275F47
	Offset: 0x15A8
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function theater_light_model_swap_init()
{
	wait(0.016);
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		theater_light_models = GetEntArray(i, "model_lights_on", "targetname");
		if(isdefined(theater_light_models) && theater_light_models.size > 0)
		{
			Array::thread_all(theater_light_models, &theater_light_model_swap);
		}
	}
}

/*
	Name: theater_light_model_swap
	Namespace: namespace_aed37ba8
	Checksum: 0x23D312CE
	Offset: 0x1670
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function theater_light_model_swap()
{
	wait(0.016);
	if(!level clientfield::get("zombie_power_on"))
	{
		level waittill("ZPO");
	}
	if(self.model == "lights_hang_single")
	{
		self SetModel("lights_hang_single_on_nonflkr");
	}
	else if(self.model == "zombie_zapper_cagelight")
	{
		self SetModel("zombie_zapper_cagelight_on");
	}
}

/*
	Name: register_clientfields
	Namespace: namespace_aed37ba8
	Checksum: 0x218C80BA
	Offset: 0x1720
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("world", "zm_theater_screen_in_place", 21000, 1, "int", &function_17e9c62f, 0, 0);
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int", &zm::zombie_eyes_clientfield_cb, 0, 0);
	clientfield::register("world", "zm_theater_movie_reel_playing", 21000, 2, "int", &namespace_265ae7e9::function_e4b3e1ca, 0, 0);
	zm_sidequests::register_sidequest_icon("movieReel", 21000);
}

/*
	Name: function_ce6ee03b
	Namespace: namespace_aed37ba8
	Checksum: 0xA483AD33
	Offset: 0x1828
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function function_ce6ee03b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
}

/*
	Name: function_17e9c62f
	Namespace: namespace_aed37ba8
	Checksum: 0xE04BABDF
	Offset: 0x1870
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function function_17e9c62f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
}

/*
	Name: function_d19cb2f8
	Namespace: namespace_aed37ba8
	Checksum: 0x84187B56
	Offset: 0x18B8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function function_d19cb2f8()
{
	loopers = struct::get_array("exterior_goal", "targetname");
	if(isdefined(loopers) && loopers.size > 0)
	{
		delay = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + loopers.size + "Dev Block strings are not supported");
			}
		#/
		for(i = 0; i < loopers.size; i++)
		{
			loopers[i] thread soundLoopThink();
			delay = delay + 1;
			if(delay % 20 == 0)
			{
				wait(0.016);
			}
		}
	}
	else
	{
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported");
		}
	}
	/#
	#/
}

/*
	Name: soundLoopThink
	Namespace: namespace_aed37ba8
	Checksum: 0x1CFD44DB
	Offset: 0x1A20
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function soundLoopThink()
{
	if(!isdefined(self.origin))
	{
		return;
	}
	if(!isdefined(self.script_sound))
	{
		self.script_sound = "zmb_spawn_walla";
	}
	notifyname = "";
	/#
		Assert(isdefined(notifyname));
	#/
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	/#
		Assert(isdefined(notifyname));
	#/
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundloopemitter(self.script_sound, self.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundstoploopemitter(self.script_sound, self.origin);
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

