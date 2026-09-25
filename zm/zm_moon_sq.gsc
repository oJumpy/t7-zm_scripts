#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_microwavegun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;
#using scripts\zm\zm_moon_sq_be;
#using scripts\zm\zm_moon_sq_ctt;
#using scripts\zm\zm_moon_sq_ctvg;
#using scripts\zm\zm_moon_sq_datalogs;
#using scripts\zm\zm_moon_sq_osc;
#using scripts\zm\zm_moon_sq_sc;
#using scripts\zm\zm_moon_sq_ss;

#namespace zm_moon_sq;

/*
	Name: init
	Namespace: zm_moon_sq
	Checksum: 0x10BF1914
	Offset: 0x928
	Size: 0x36B
	Parameters: 0
	Flags: None
*/
function init()
{
	ss_buttons = GetEntArray("sq_ss_button", "targetname");
	for(i = 0; i < ss_buttons.size; i++)
	{
		ss_buttons[i] UseTriggerRequireLookAt();
		ss_buttons[i] setHintString("");
		ss_buttons[i] setcursorhint("HINT_NOICON");
	}
	level flag::init("first_tanks_charged");
	level flag::init("second_tanks_charged");
	level flag::init("first_tanks_drained");
	level flag::init("second_tanks_drained");
	level flag::init("c_built");
	level flag::init("vg_charged");
	level flag::init("switch_done");
	level flag::init("be2");
	level flag::init("ss1");
	level flag::init("soul_swap_done");
	zm_sidequests::declare_sidequest("sq", &init_sidequest, &sidequest_logic, &complete_sidequest, &generic_stage_start, &generic_stage_complete);
	zm_moon_sq_ss::init_1();
	zm_moon_sq_ss::init_2();
	zm_moon_sq_osc::init();
	zm_moon_sq_sc::init();
	zm_moon_sq_sc::init_2();
	zm_sidequests::declare_sidequest("tanks", undefined, undefined, undefined, undefined, undefined);
	zm_moon_sq_ctt::init_1();
	zm_moon_sq_ctt::init_2();
	zm_sidequests::declare_sidequest("ctvg", undefined, undefined, undefined, undefined, undefined);
	zm_moon_sq_ctvg::init();
	zm_sidequests::declare_sidequest("be", undefined, undefined, undefined, undefined, undefined);
	zm_moon_sq_be::init();
	function_2f7d3521();
}

/*
	Name: init_clientfields
	Namespace: zm_moon_sq
	Checksum: 0x53BE1393
	Offset: 0xCA0
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	zm_sidequests::register_sidequest_icon("vril", 21000);
	zm_sidequests::register_sidequest_icon("anti115", 21000);
	zm_sidequests::register_sidequest_icon("generator", 21000);
	zm_sidequests::register_sidequest_icon("cgenerator", 21000);
	zm_sidequests::register_sidequest_icon("wire", 21000);
	zm_sidequests::register_sidequest_icon("datalog", 21000);
	clientfield::register("world", "raise_rockets", 21000, 1, "counter");
	clientfield::register("world", "rocket_launch", 21000, 1, "counter");
	clientfield::register("world", "rocket_explode", 21000, 1, "counter");
	clientfield::register("world", "charge_tank_1", 21000, 1, "counter");
	clientfield::register("world", "charge_tank_2", 21000, 1, "counter");
	clientfield::register("world", "charge_tank_cleanup", 21000, 1, "counter");
	clientfield::register("world", "sam_vo_rumble", 21000, 1, "int");
	clientfield::register("world", "charge_vril_init", 21000, 1, "int");
	clientfield::register("world", "sq_wire_init", 21000, 1, "int");
	clientfield::register("world", "sam_init", 21000, 1, "int");
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("world", "vril_generator", 21000, n_bits, "int");
	clientfield::register("world", "sam_end_rumble", 21000, 1, "int");
}

/*
	Name: reward
	Namespace: zm_moon_sq
	Checksum: 0x605CB2CD
	Offset: 0xFD8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function reward()
{
	level notify("moon_sidequest_achieved");
	players = GetPlayers();
	Array::thread_all(players, &give_perk_reward);
}

/*
	Name: watch_for_respawn
	Namespace: zm_moon_sq
	Checksum: 0x4AAD2947
	Offset: 0x1038
	Size: 0x105
	Parameters: 0
	Flags: None
*/
function watch_for_respawn()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("spawned_player");
		waittillframeend;
		foreach(perk in level._sq_perk_array)
		{
			if(!self hasPerk(perk))
			{
				if(zm_perks::use_solo_revive() && perk == "specialty_quickrevive")
				{
					continue;
					continue;
				}
				self zm_perks::give_perk(perk);
			}
		}
	}
}

/*
	Name: give_perk_reward
	Namespace: zm_moon_sq
	Checksum: 0x50A625B5
	Offset: 0x1148
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function give_perk_reward()
{
	if(isdefined(self._retain_perks))
	{
		return;
	}
	if(!isdefined(level._sq_perk_array))
	{
		level._sq_perk_array = [];
		machines = GetEntArray("zombie_vending", "targetname");
		for(i = 0; i < machines.size; i++)
		{
			level._sq_perk_array[level._sq_perk_array.size] = machines[i].script_noteworthy;
		}
	}
	for(i = 0; i < level._sq_perk_array.size; i++)
	{
		if(!self hasPerk(level._sq_perk_array[i]))
		{
			self playsound("evt_sq_bag_gain_perks");
			self zm_perks::give_perk(level._sq_perk_array[i]);
			wait(0.25);
		}
	}
	self._retain_perks = 1;
	self thread watch_for_respawn();
}

/*
	Name: start_moon_sidequest
	Namespace: zm_moon_sq
	Checksum: 0xDC773EEA
	Offset: 0x12B0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function start_moon_sidequest()
{
	init();
	level flag::wait_till("start_zombie_round_logic");
	zm_sidequests::sidequest_start("sq");
}

/*
	Name: init_sidequest
	Namespace: zm_moon_sq
	Checksum: 0xF8C8CE2B
	Offset: 0x1308
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function init_sidequest()
{
	players = GetPlayers();
	level._all_previous_done = 0;
	level._zombiemode_sidequest_icon_offset = -32;
	for(i = 0; i < players.size; i++)
	{
		entnum = players[i].characterindex;
		/#
			println("Dev Block strings are not supported" + entnum);
		#/
		if(isdefined(players[i].zm_random_char))
		{
			entnum = players[i].zm_random_char;
		}
		if(entnum == 2)
		{
			devmode = 1;
			if(devmode)
			{
				players[i] zm_sidequests::add_sidequest_icon("sq", "generator", 0);
				level._all_previous_done = 1;
				continue;
			}
			if(level.onlineGame)
			{
				if(zm::is_sidequest_previously_completed("EOA"))
				{
					players[i] zm_sidequests::add_sidequest_icon("sq", "generator", 0);
					level._all_previous_done = 1;
					break;
					continue;
				}
				players[i] zm_sidequests::add_sidequest_icon("sq", "vril", 0);
				break;
			}
		}
	}
	level thread tanks();
	level thread cassimir();
	level thread be();
	level thread zm_moon_sq_datalogs::init();
	if(1 == GetDvarInt("scr_debug_launch"))
	{
		level thread rocket_test();
	}
	level thread rocket_raise();
}

/*
	Name: rocket_test
	Namespace: zm_moon_sq
	Checksum: 0xFD417AB
	Offset: 0x1590
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function rocket_test()
{
	level flag::wait_till("power_on");
	wait(5);
	level notify("RL");
	wait(2);
	level notify("RL");
	wait(2);
	level notify("RL");
	level thread do_launch();
}

/*
	Name: rocket_raise
	Namespace: zm_moon_sq
	Checksum: 0x559900B8
	Offset: 0x1610
	Size: 0x15D
	Parameters: 1
	Flags: None
*/
function rocket_raise(player_num)
{
	rockets = GetEntArray("moon_rockets", "script_noteworthy");
	Array::thread_all(rockets, &nml_show_hide);
	for(i = 3; i > 0; i--)
	{
		level waittill("RL");
		level clientfield::increment("raise_rockets");
		rockets[i - 1] playsound("evt_rocket_move_up");
		str_scene = "p7_fxanim_zmhd_moon_rocket_launch_0" + i + "_bundle";
		level thread scene::init(str_scene);
	}
	level waittill("RL");
	for(i = 0; i < 3; i++)
	{
		rockets[i] thread launch();
	}
}

/*
	Name: nml_show_hide
	Namespace: zm_moon_sq
	Checksum: 0x3E5123E9
	Offset: 0x1778
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function nml_show_hide()
{
	level endon("intermission");
	self endon("death");
	while(1)
	{
		level flag::wait_till("enter_nml");
		self ghost();
		level flag::wait_till_clear("enter_nml");
		self show();
	}
}

/*
	Name: launch
	Namespace: zm_moon_sq
	Checksum: 0x230CE589
	Offset: 0x1810
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function launch()
{
	level clientfield::increment("rocket_launch");
	wait(RandomFloatRange(0.1, 1));
	self playsound("evt_rocket_launch");
	if(!isdefined(level._n_rockets))
	{
		level._n_rockets = 0;
	}
	level._n_rockets++;
	/#
		println("Dev Block strings are not supported" + level._n_rockets + "Dev Block strings are not supported");
	#/
	str_scene = "p7_fxanim_zmhd_moon_rocket_launch_0" + level._n_rockets + "_bundle";
	level thread zm_audio::sndMusicSystem_PlayState("end_is_near");
	level scene::Play(str_scene);
	/#
		println("Dev Block strings are not supported" + level._n_rockets + "Dev Block strings are not supported");
	#/
}

/*
	Name: sidequest_logic
	Namespace: zm_moon_sq
	Checksum: 0x10D24CCB
	Offset: 0x1958
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function sidequest_logic()
{
	level thread sq_flatcard_logic();
	level flag::wait_till("power_on");
	zm_sidequests::stage_start("sq", "ss1");
	level flag::wait_till("ss1");
	zm_sidequests::stage_start("sq", "osc");
	level waittill("sq_osc_over");
	level flag::wait_till("complete_be_1");
	wait(4);
	zm_sidequests::stage_start("sq", "sc");
	level waittill("sq_sc_over");
	level flag::wait_till("vg_charged");
	zm_sidequests::stage_start("sq", "sc2");
	level waittill("sq_sc2_over");
	wait(5);
	level thread maxis_story_vox();
	level waittill("sq_ss2_over");
	level flag::wait_till("be2");
	level thread do_launch();
}

/*
	Name: do_launch
	Namespace: zm_moon_sq
	Checksum: 0x1B80B39A
	Offset: 0x1B00
	Size: 0x22D
	Parameters: 0
	Flags: None
*/
function do_launch()
{
	foreach(e_player in level.players)
	{
		if(e_player bgb::is_active("zm_bgb_killing_time"))
		{
			e_player bgb::take();
		}
	}
	level.var_d8417111 = 1;
	zm_utility::play_sound_2d("vox_xcomp_quest_step8_4");
	wait(10);
	level notify("RL");
	wait(30);
	zm_utility::play_sound_2d("vox_xcomp_quest_step8_5");
	wait(30);
	zm_utility::play_sound_2d("evt_earth_explode");
	level clientfield::increment("rocket_explode");
	util::wait_network_frame();
	util::wait_network_frame();
	exploder::exploder("fxexp_2012");
	wait(2);
	level clientfield::increment("show_destroyed_earth");
	level._dte_done = 1;
	level notify("moon_sidequest_big_bang_achieved");
	zm_utility::play_sound_2d("vox_xcomp_quest_laugh");
	level thread play_end_lines_in_order();
	reward();
	level util::set_lighting_state(1);
	level function_7aca917c();
	level.var_d8417111 = undefined;
}

/*
	Name: function_7aca917c
	Namespace: zm_moon_sq
	Checksum: 0x2E590BAF
	Offset: 0x1D38
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_7aca917c()
{
	if(isdefined(level.var_1b3f87f7))
	{
		level.var_1b3f87f7 delete();
	}
	level.var_1b3f87f7 = CreateStreamerHint(level.activePlayers[0].origin, 1, 0);
	level.var_1b3f87f7 function_da46a629(1);
}

/*
	Name: play_end_lines_in_order
	Namespace: zm_moon_sq
	Checksum: 0x5A747106
	Offset: 0x1DC8
	Size: 0x23F
	Parameters: 0
	Flags: None
*/
function play_end_lines_in_order()
{
	level.skit_vox_override = 1;
	players = GetPlayers();
	players[randomIntRange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest8", 7);
	wait(12);
	player = get_specific_player(0);
	if(isdefined(player))
	{
		player thread zm_audio::create_and_play_dialog("eggs", "quest8", 9);
		wait(5);
	}
	player = get_specific_player(1);
	if(isdefined(player))
	{
		player thread zm_audio::create_and_play_dialog("eggs", "quest8", 9);
		wait(5);
	}
	player = get_specific_player(2);
	if(isdefined(player))
	{
		player thread zm_audio::create_and_play_dialog("eggs", "quest8", 9);
		wait(5);
	}
	player = get_specific_player(3);
	if(isdefined(player))
	{
		player thread zm_audio::create_and_play_dialog("eggs", "quest8", 9);
		wait(5);
	}
	player = get_specific_player(3);
	if(isdefined(player))
	{
		player thread zm_audio::create_and_play_dialog("eggs", "quest8", 10);
	}
	level.skit_vox_override = 0;
}

/*
	Name: get_specific_player
	Namespace: zm_moon_sq
	Checksum: 0xCA50E0BF
	Offset: 0x2010
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function get_specific_player(num)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		ent_num = players[i].characterindex;
		if(isdefined(players[i].zm_random_char))
		{
			ent_num = players[i].zm_random_char;
		}
		if(ent_num == num)
		{
			return players[i];
		}
	}
	return undefined;
}

/*
	Name: maxis_story_vox
	Namespace: zm_moon_sq
	Checksum: 0x9FA88FD7
	Offset: 0x20D8
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function maxis_story_vox()
{
	s = struct::get("sq_vg_final", "targetname");
	level.skit_vox_override = 1;
	sound::play_in_space("vox_plr_2_quest_step6_9", s.origin);
	wait(2.3);
	sound::play_in_space("vox_plr_2_quest_step6_11", s.origin);
	wait(10.5);
	sound::play_in_space("vox_xcomp_quest_step6_14", s.origin);
	level.skit_vox_override = 0;
	zm_sidequests::stage_start("sq", "ss2");
}

/*
	Name: be
	Namespace: zm_moon_sq
	Checksum: 0xFE6442F1
	Offset: 0x21D8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function be()
{
	zm_sidequests::stage_start("be", "stage_one");
	level waittill("sq_sc2_over");
	wait(2);
	zm_sidequests::stage_start("be", "stage_two");
}

/*
	Name: tanks
	Namespace: zm_moon_sq
	Checksum: 0x45156D15
	Offset: 0x2240
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function tanks()
{
	level flag::wait_till("complete_be_1");
	wait(4);
	zm_sidequests::stage_start("tanks", "ctt1");
	level waittill("sq_sc_over");
	level flag::wait_till("vg_charged");
	zm_sidequests::stage_start("tanks", "ctt2");
}

/*
	Name: cassimir
	Namespace: zm_moon_sq
	Checksum: 0xFE5B2D22
	Offset: 0x22E0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function cassimir()
{
	zm_sidequests::stage_start("ctvg", "build");
	level waittill("ctvg_build_over");
	wait(5);
	zm_sidequests::stage_start("ctvg", "charge");
}

/*
	Name: cheat_complete_stage
	Namespace: zm_moon_sq
	Checksum: 0xCAD7AAD
	Offset: 0x2348
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function cheat_complete_stage()
{
	level endon("reset_sundial");
	while(1)
	{
		if(GetDvarString("cheat_sq") != "")
		{
			if(isdefined(level._last_stage_started))
			{
				SetDvar("cheat_sq", "");
				zm_sidequests::stage_completed("sq", level._last_stage_started);
			}
		}
		wait(0.1);
	}
}

/*
	Name: generic_stage_start
	Namespace: zm_moon_sq
	Checksum: 0xDC8F24EE
	Offset: 0x23E0
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function generic_stage_start()
{
	/#
		level thread cheat_complete_stage();
	#/
	level._stage_active = 1;
}

/*
	Name: generic_stage_complete
	Namespace: zm_moon_sq
	Checksum: 0x33FD8D1
	Offset: 0x2410
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function generic_stage_complete()
{
	level._stage_active = 0;
}

/*
	Name: complete_sidequest
	Namespace: zm_moon_sq
	Checksum: 0xA4D77552
	Offset: 0x2428
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function complete_sidequest()
{
	level thread sidequest_done();
}

/*
	Name: sidequest_done
	Namespace: zm_moon_sq
	Checksum: 0x99EC1590
	Offset: 0x2450
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function sidequest_done()
{
}

/*
	Name: get_variant_from_entity_num
	Namespace: zm_moon_sq
	Checksum: 0x4768315C
	Offset: 0x2460
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function get_variant_from_entity_num(player_number)
{
	if(!isdefined(player_number))
	{
		player_number = 0;
	}
	post_fix = "a";
	switch(player_number)
	{
		case 0:
		{
			post_fix = "a";
			break;
		}
		case 1:
		{
			post_fix = "b";
			break;
		}
		case 2:
		{
			post_fix = "c";
			break;
		}
		case 3:
		{
			post_fix = "d";
			break;
		}
	}
	return post_fix;
}

/*
	Name: sq_flatcard_logic
	Namespace: zm_moon_sq
	Checksum: 0xFFC80510
	Offset: 0x2518
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function sq_flatcard_logic()
{
	nml_set = 0;
	while(1)
	{
		if(level flag::get("enter_nml") && !nml_set)
		{
			if(!isdefined(level._dte_done) || (isdefined(level._dte_done) && level._dte_done))
			{
				level clientfield::increment("hide_earth");
			}
			nml_set = 1;
		}
		else if(!level flag::get("enter_nml") && nml_set)
		{
			if(!isdefined(level._dte_done))
			{
				level clientfield::increment("show_earth");
			}
			nml_set = 0;
		}
		wait(0.1);
	}
}

/*
	Name: function_2f7d3521
	Namespace: zm_moon_sq
	Checksum: 0x8BCC1F
	Offset: 0x2620
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function function_2f7d3521()
{
	zm_spawner::add_custom_zombie_spawn_logic(&function_69090b83);
	level flag::init("sd_active");
	level flag::wait_till("start_zombie_round_logic");
	level.var_c920d4c5 = struct::get("sd_bowl", "targetname");
	var_5e8fec3f = struct::get_array("sd_start", "script_noteworthy");
	foreach(s_start in var_5e8fec3f)
	{
		var_12a1091 = util::spawn_model(s_start.model, s_start.origin, s_start.angles);
		var_12a1091.targetname = s_start.targetname;
		var_12a1091 SetScale(s_start.script_float);
		var_2ad32714 = spawn("trigger_damage", var_12a1091.origin, 0, 15, 15);
		namespace_1a0051d2::add_microwaveable_object(var_2ad32714);
		var_12a1091 thread function_7e76fe45(var_2ad32714);
		level flag::init(var_12a1091.targetname);
	}
	level thread function_4ee03f50();
}

/*
	Name: function_7e76fe45
	Namespace: zm_moon_sq
	Checksum: 0x868774FC
	Offset: 0x2868
	Size: 0x127
	Parameters: 1
	Flags: None
*/
function function_7e76fe45(var_2ad32714)
{
	self endon("death");
	while(1)
	{
		var_2ad32714 waittill("microwaved");
		level flag::set(self.targetname);
		var_6be16785 = struct::get(self.targetname + "_final", "targetname");
		var_aee26521 = util::spawn_model(self.model, var_6be16785.origin, var_6be16785.angles);
		var_aee26521 SetScale(var_6be16785.script_float);
		wait(0.05);
		var_2ad32714 delete();
		self delete();
	}
}

/*
	Name: function_4ee03f50
	Namespace: zm_moon_sq
	Checksum: 0x9BC57CF0
	Offset: 0x2998
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function function_4ee03f50()
{
	var_5e8fec3f = struct::get_array("sd_start", "script_noteworthy");
	a_flags = [];
	foreach(s_start in var_5e8fec3f)
	{
		if(!isdefined(a_flags))
		{
			a_flags = [];
		}
		else if(!IsArray(a_flags))
		{
			a_flags = Array(a_flags);
		}
		a_flags[a_flags.size] = s_start.targetname;
	}
	if(!a_flags.size)
	{
		return;
	}
	level flag::wait_till_all(a_flags);
	var_8c15cb32 = struct::get("sd_bowl", "targetname");
	var_8c15cb32.radius = 65;
	var_8c15cb32.height = 72;
	var_8c15cb32.script_float = 7;
	var_8c15cb32.custom_string = &"ZM_MOON_HACK_SILENT";
	namespace_6d813654::register_pooled_hackable_struct(var_8c15cb32, &function_9391498d);
}

/*
	Name: function_9391498d
	Namespace: zm_moon_sq
	Checksum: 0x89D73F02
	Offset: 0x2B78
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_9391498d(hacker)
{
	namespace_6d813654::deregister_hackable_struct(self);
	level flag::set("sd_active");
	level thread function_948d4e7d();
	level thread function_66951281();
}

/*
	Name: function_948d4e7d
	Namespace: zm_moon_sq
	Checksum: 0xDB040487
	Offset: 0x2BF8
	Size: 0x1D9
	Parameters: 0
	Flags: None
*/
function function_948d4e7d()
{
	level flag::init("sd_large_complete");
	var_9f30ae72 = struct::get("sd_big_soul", "targetname");
	var_51aa97ed = util::spawn_model(var_9f30ae72.model, var_9f30ae72.origin, var_9f30ae72.angles);
	var_51aa97ed SetScale(var_9f30ae72.script_float);
	var_c1b1cd1c = 2.3 / 30;
	var_fa77a9e7 = 0;
	while(1)
	{
		level waittill("hash_9b391ed5");
		if(var_fa77a9e7 < 30)
		{
			var_fa77a9e7++;
			var_51aa97ed.origin = var_51aa97ed.origin + (0, 0, var_c1b1cd1c);
		}
		else
		{
			level flag::set("sd_large_complete");
			function_cff1fcfb();
			var_51aa97ed moveto(var_9f30ae72.origin, 1.5, 0.1, 0.1);
			var_51aa97ed waittill("movedone");
			var_51aa97ed delete();
			return;
		}
	}
}

/*
	Name: function_66951281
	Namespace: zm_moon_sq
	Checksum: 0x7B0C0F2A
	Offset: 0x2DE0
	Size: 0x1D9
	Parameters: 0
	Flags: None
*/
function function_66951281()
{
	level flag::init("sd_small_complete");
	var_e7c6777b = struct::get("sd_small_soul", "targetname");
	var_51aa97ed = util::spawn_model(var_e7c6777b.model, var_e7c6777b.origin, var_e7c6777b.angles);
	var_51aa97ed SetScale(var_e7c6777b.script_float);
	var_c1b1cd1c = 2 / 15;
	var_fa77a9e7 = 0;
	while(1)
	{
		level waittill("hash_d7362b52");
		if(var_fa77a9e7 < 15)
		{
			var_fa77a9e7++;
			var_51aa97ed.origin = var_51aa97ed.origin + (0, 0, var_c1b1cd1c);
		}
		else
		{
			level flag::set("sd_small_complete");
			function_cff1fcfb();
			var_51aa97ed moveto(var_e7c6777b.origin, 1.5, 0.1, 0.1);
			var_51aa97ed waittill("movedone");
			var_51aa97ed delete();
			return;
		}
	}
}

/*
	Name: function_69090b83
	Namespace: zm_moon_sq
	Checksum: 0x54542821
	Offset: 0x2FC8
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_69090b83()
{
	self waittill("death", attacker);
	if(!isPlayer(attacker))
	{
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	if(level flag::get("sd_active"))
	{
		v_end_pos = level.var_c920d4c5.origin;
		n_dist = Distance(v_end_pos, self.origin);
		if(self.archetype === "zombie_quad")
		{
			if(level flag::get("sd_small_complete"))
			{
				return;
			}
			level notify("hash_d7362b52");
		}
		else if(level flag::get("sd_large_complete"))
		{
			return;
		}
		level notify("hash_9b391ed5");
		if(n_dist <= 256)
		{
			self clientfield::set("sd", 1);
		}
	}
}

/*
	Name: function_cff1fcfb
	Namespace: zm_moon_sq
	Checksum: 0x2CDF0102
	Offset: 0x3120
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_cff1fcfb()
{
	if(level flag::get("sd_large_complete") && level flag::get("sd_small_complete"))
	{
		level flag::clear("sd_active");
		level thread function_93878170();
		playsoundatposition("zmb_k9_ee_bling", (0, 0, 0));
	}
}

/*
	Name: function_93878170
	Namespace: zm_moon_sq
	Checksum: 0x5455D1F8
	Offset: 0x31C8
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function function_93878170()
{
	var_653beee4 = Array("p7_fxanim_zmhd_moon_spacedog_path1_sec1_bundle", "p7_fxanim_zmhd_moon_spacedog_path1_sec2_bundle", "p7_fxanim_zmhd_moon_spacedog_path2_bundle");
	var_efac5d38 = Array("p7_fxanim_zmhd_moon_spacedog_path1_sec2_bundle", "p7_fxanim_zmhd_moon_spacedog_path2_bundle");
	wait(1);
	while(1)
	{
		if(level flag::get("start_hangar_digger") || level flag::get("start_teleporter_digger"))
		{
			str_scene = Array::random(var_efac5d38);
		}
		else
		{
			str_scene = Array::random(var_653beee4);
		}
		scene::Play(str_scene);
		wait(RandomFloatRange(600, 900));
	}
}

