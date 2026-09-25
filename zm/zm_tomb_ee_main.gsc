#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_craftables;
#using scripts\zm\zm_tomb_ee_main;
#using scripts\zm\zm_tomb_ee_main_step_1;
#using scripts\zm\zm_tomb_ee_main_step_2;
#using scripts\zm\zm_tomb_ee_main_step_3;
#using scripts\zm\zm_tomb_ee_main_step_4;
#using scripts\zm\zm_tomb_ee_main_step_5;
#using scripts\zm\zm_tomb_ee_main_step_6;
#using scripts\zm\zm_tomb_ee_main_step_7;
#using scripts\zm\zm_tomb_ee_main_step_8;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_ee_main;

/*
	Name: init
	Namespace: zm_tomb_ee_main
	Checksum: 0xAFEA48FF
	Offset: 0x8D0
	Size: 0x373
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("actor", "ee_zombie_fist_fx", 21000, 1, "int");
	clientfield::register("actor", "ee_zombie_soul_portal", 21000, 1, "int");
	clientfield::register("world", "ee_sam_portal", 21000, 2, "int");
	clientfield::register("vehicle", "ee_plane_fx", 21000, 1, "int");
	clientfield::register("world", "TombEndGameBlackScreen", 21000, 1, "int");
	level flag::init("ee_all_staffs_crafted");
	level flag::init("ee_all_staffs_upgraded");
	level flag::init("ee_all_staffs_placed");
	level flag::init("ee_mech_zombie_hole_opened");
	level flag::init("ee_mech_zombie_fight_completed");
	level flag::init("ee_maxis_drone_retrieved");
	level flag::init("ee_all_players_upgraded_punch");
	level flag::init("ee_souls_absorbed");
	level flag::init("ee_samantha_released");
	level flag::init("ee_quadrotor_disabled");
	level flag::init("ee_sam_portal_active");
	if(!zm_sidequests::is_sidequest_allowed("zclassic"))
	{
		return;
	}
	/#
		level thread setup_ee_main_devgui();
	#/
	zm_sidequests::declare_sidequest("little_girl_lost", &init_sidequest, &sidequest_logic, &complete_sidequest, &generic_stage_start, &generic_stage_end);
	zm_tomb_ee_main_step_1::init();
	zm_tomb_ee_main_step_2::init();
	zm_tomb_ee_main_step_3::init();
	zm_tomb_ee_main_step_4::init();
	zm_tomb_ee_main_step_5::init();
	zm_tomb_ee_main_step_6::init();
	zm_tomb_ee_main_step_7::init();
	zm_tomb_ee_main_step_8::init();
}

/*
	Name: main
	Namespace: zm_tomb_ee_main
	Checksum: 0x4BDEA872
	Offset: 0xC50
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::wait_till("start_zombie_round_logic");
	zm_sidequests::sidequest_start("little_girl_lost");
}

/*
	Name: init_sidequest
	Namespace: zm_tomb_ee_main
	Checksum: 0xA387EE0F
	Offset: 0xC98
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function init_sidequest()
{
	level.n_ee_step = 0;
	level.n_ee_robot_staffs_planted = 0;
}

/*
	Name: sidequest_logic
	Namespace: zm_tomb_ee_main
	Checksum: 0xA87C316
	Offset: 0xCC0
	Size: 0x27F
	Parameters: 0
	Flags: None
*/
function sidequest_logic()
{
	level._cur_stage_name = "step_0";
	level flag::wait_till("ee_all_staffs_crafted");
	level flag::wait_till("all_zones_captured");
	level.n_ee_step++;
	level thread zombie_blood_hint_watch();
	zm_sidequests::stage_start("little_girl_lost", "step_1");
	level waittill("little_girl_lost_step_1_over");
	zm_sidequests::stage_start("little_girl_lost", "step_2");
	level waittill("little_girl_lost_step_2_over");
	level thread zm_tomb_amb::sndplaystingerwithoverride("ee_main_1");
	zm_sidequests::stage_start("little_girl_lost", "step_3");
	level waittill("little_girl_lost_step_3_over");
	level thread zm_tomb_amb::sndplaystingerwithoverride("ee_main_2");
	zm_sidequests::stage_start("little_girl_lost", "step_4");
	level waittill("little_girl_lost_step_4_over");
	level thread zm_tomb_amb::sndplaystingerwithoverride("ee_main_3");
	zm_sidequests::stage_start("little_girl_lost", "step_5");
	level waittill("little_girl_lost_step_5_over");
	level thread zm_tomb_amb::sndplaystingerwithoverride("ee_main_4");
	zm_sidequests::stage_start("little_girl_lost", "step_6");
	level waittill("little_girl_lost_step_6_over");
	level thread zm_tomb_amb::sndplaystingerwithoverride("ee_main_5");
	zm_sidequests::stage_start("little_girl_lost", "step_7");
	level waittill("little_girl_lost_step_7_over");
	level thread zm_tomb_amb::sndplaystingerwithoverride("ee_main_6");
	zm_sidequests::stage_start("little_girl_lost", "step_8");
	level waittill("little_girl_lost_step_8_over");
}

/*
	Name: zombie_blood_hint_watch
	Namespace: zm_tomb_ee_main
	Checksum: 0x9543F944
	Offset: 0xF48
	Size: 0x3DF
	Parameters: 0
	Flags: None
*/
function zombie_blood_hint_watch()
{
	n_curr_step = level.n_ee_step;
	a_player_hint[0] = 0;
	a_player_hint[1] = 0;
	a_player_hint[2] = 0;
	a_player_hint[3] = 0;
	while(!level flag::get("ee_samantha_released"))
	{
		level waittill("player_zombie_blood", e_player);
		if(n_curr_step != level.n_ee_step)
		{
			n_curr_step = level.n_ee_step;
			for(i = 0; i < a_player_hint.size; i++)
			{
				a_player_hint[i] = 0;
			}
		}
		else if(!a_player_hint[e_player.characterindex])
		{
			wait(RandomFloatRange(3, 7));
			if(isdefined(e_player.vo_promises_playing) && e_player.vo_promises_playing)
			{
				continue;
			}
			while(isdefined(level.sam_talking) && level.sam_talking)
			{
				wait(0.05);
			}
			if(isdefined(e_player) && isPlayer(e_player) && e_player.zombie_vars["zombie_powerup_zombie_blood_on"])
			{
				a_player_hint[e_player.characterindex] = 1;
				zm_tomb_vo::set_players_dontspeak(1);
				level.sam_talking = 1;
				str_vox = get_zombie_blood_hint_vox();
				e_player playsoundtoplayer(str_vox, e_player);
				n_duration = soundgetplaybacktime(str_vox);
				wait(n_duration / 1000);
				level.sam_talking = 0;
				zm_tomb_vo::set_players_dontspeak(0);
			}
		}
		else if(RandomInt(100) < 20)
		{
			wait(RandomFloatRange(3, 7));
			if(isdefined(e_player.vo_promises_playing) && e_player.vo_promises_playing)
			{
				continue;
			}
			while(isdefined(level.sam_talking) && level.sam_talking)
			{
				wait(0.05);
			}
			if(isdefined(e_player) && isPlayer(e_player) && e_player.zombie_vars["zombie_powerup_zombie_blood_on"])
			{
				str_vox = get_zombie_blood_hint_generic_vox();
				if(isdefined(str_vox))
				{
					zm_tomb_vo::set_players_dontspeak(1);
					level.sam_talking = 1;
					e_player playsoundtoplayer(str_vox, e_player);
					n_duration = soundgetplaybacktime(str_vox);
					wait(n_duration / 1000);
					level.sam_talking = 0;
					zm_tomb_vo::set_players_dontspeak(0);
				}
			}
		}
	}
}

/*
	Name: get_step_announce_vox
	Namespace: zm_tomb_ee_main
	Checksum: 0xA1C5980F
	Offset: 0x1330
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function get_step_announce_vox()
{
	switch(level.n_ee_step)
	{
		case 1:
		{
			return "vox_sam_all_staff_upgrade_key_0";
		}
		case 2:
		{
			return "vox_sam_all_staff_ascend_darkness_0";
		}
		case 3:
		{
			return "vox_sam_all_staff_rain_fire_0";
		}
		case 4:
		{
			return "vox_sam_all_staff_unleash_hoard_0";
		}
		case 5:
		{
			return "vox_sam_all_staff_skewer_beast_0";
		}
		case 6:
		{
			return "vox_sam_all_staff_fist_iron_0";
		}
		case 7:
		{
			return "vox_sam_all_staff_raise_hell_0";
		}
		case default:
		{
			return undefined;
		}
	}
}

/*
	Name: get_zombie_blood_hint_vox
	Namespace: zm_tomb_ee_main
	Checksum: 0xD702FB28
	Offset: 0x13D0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function get_zombie_blood_hint_vox()
{
	if(level flag::get("all_zones_captured"))
	{
		return "vox_sam_upgrade_staff_clue_" + level.n_ee_step + "_0";
	}
	return "vox_sam_upgrade_staff_clue_" + level.n_ee_step + "_grbld_0";
}

/*
	Name: get_zombie_blood_hint_generic_vox
	Namespace: zm_tomb_ee_main
	Checksum: 0xCDEBAAA4
	Offset: 0x1438
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function get_zombie_blood_hint_generic_vox()
{
	if(!isdefined(level.generic_clue_index))
	{
		level.generic_clue_index = 0;
	}
	vo_array[0] = "vox_sam_heard_by_all_1_0";
	vo_array[1] = "vox_sam_heard_by_all_2_0";
	vo_array[2] = "vox_sam_heard_by_all_3_0";
	vo_array[3] = "vox_sam_slow_progress_0";
	vo_array[4] = "vox_sam_slow_progress_2";
	vo_array[5] = "vox_sam_slow_progress_3";
	if(level.generic_clue_index >= vo_array.size)
	{
		return undefined;
	}
	str_vo = vo_array[level.generic_clue_index];
	level.generic_clue_index++;
	return str_vo;
}

/*
	Name: complete_sidequest
	Namespace: zm_tomb_ee_main
	Checksum: 0x32D747DD
	Offset: 0x1518
	Size: 0x2E9
	Parameters: 0
	Flags: None
*/
function complete_sidequest()
{
	level LUI::prime_movie("zm_outro_tomb", 0, "");
	level.sndgameovermusicoverride = "game_over_ee";
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		player FreezeControls(1);
		player EnableInvulnerability();
	}
	level flag::clear("spawn_zombies");
	level thread function_ab51bfd();
	playsoundatposition("zmb_squest_whiteout", (0, 0, 0));
	level LUI::screen_fade_out(1, "white", "starting_ee_screen");
	util::delay(0.5, undefined, &remove_portal_beam);
	level thread LUI::play_movie("zm_outro_tomb", "fullscreen", 0, 0, "");
	level LUI::screen_fade_out(0, "black", "starting_ee_screen");
	level waittill("movie_done");
	level.custom_intermission = &player_intermission_ee;
	level notify("end_game");
	level thread LUI::screen_fade_in(2, "black", "starting_ee_screen");
	wait(1.5);
	foreach(player in a_players)
	{
		player FreezeControls(0);
		player DisableInvulnerability();
	}
}

/*
	Name: function_202bf99e
	Namespace: zm_tomb_ee_main
	Checksum: 0x1FBCA3D
	Offset: 0x1810
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_202bf99e(var_87423d00)
{
	self endon("end_game");
	self LUI::screen_fade_in(var_87423d00);
}

/*
	Name: remove_portal_beam
	Namespace: zm_tomb_ee_main
	Checksum: 0x18A1CB50
	Offset: 0x1848
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function remove_portal_beam()
{
	if(isdefined(level.ee_ending_beam_fx))
	{
		level.ee_ending_beam_fx delete();
	}
}

/*
	Name: generic_stage_start
	Namespace: zm_tomb_ee_main
	Checksum: 0xDD48341
	Offset: 0x1880
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function generic_stage_start()
{
	str_vox = get_step_announce_vox();
	if(isdefined(str_vox))
	{
		level thread ee_samantha_say(str_vox);
	}
}

/*
	Name: generic_stage_end
	Namespace: zm_tomb_ee_main
	Checksum: 0x2BE560B1
	Offset: 0x18D0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function generic_stage_end()
{
	level.n_ee_step++;
	if(level.n_ee_step <= 6)
	{
		level flag::wait_till("all_zones_captured");
	}
	util::wait_network_frame();
	util::wait_network_frame();
}

/*
	Name: all_staffs_inserted_in_puzzle_room
	Namespace: zm_tomb_ee_main
	Checksum: 0xE989E181
	Offset: 0x1938
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function all_staffs_inserted_in_puzzle_room()
{
	n_staffs_inserted = 0;
	foreach(staff in level.a_elemental_staffs)
	{
		if(staff.upgrade.charger.is_inserted)
		{
			n_staffs_inserted++;
		}
	}
	if(n_staffs_inserted == 4)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: ee_samantha_say
	Namespace: zm_tomb_ee_main
	Checksum: 0xC5CB19D3
	Offset: 0x1A08
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function ee_samantha_say(str_vox)
{
	level flag::wait_till_clear("story_vo_playing");
	level flag::set("story_vo_playing");
	zm_tomb_vo::set_players_dontspeak(1);
	zm_tomb_vo::samanthasay(str_vox, GetPlayers()[0]);
	zm_tomb_vo::set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: player_intermission_ee
	Namespace: zm_tomb_ee_main
	Checksum: 0xDE1D59B2
	Offset: 0x1AE0
	Size: 0x621
	Parameters: 0
	Flags: None
*/
function player_intermission_ee()
{
	self closeInGameMenu();
	level endon("stop_intermission");
	self endon("disconnect");
	self endon("death");
	self notify("_zombie_game_over");
	self.score = self.score_total;
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.friendlydamage = undefined;
	points = struct::get_array("ee_cam", "targetname");
	if(!isdefined(points) || points.size == 0)
	{
		points = GetEntArray("info_intermission", "classname");
		if(points.size < 1)
		{
			/#
				println("Dev Block strings are not supported");
			#/
			return;
		}
	}
	self.game_over_bg = newClientHudElem(self);
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader("black", 640, 480);
	self.game_over_bg.alpha = 1;
	visionSetNaked("cheat_bw", 0.05);
	org = undefined;
	while(1)
	{
		points = Array::randomize(points);
		for(i = 0; i < points.size; i++)
		{
			point = points[i];
			if(!isdefined(org))
			{
				self spawn(point.origin, point.angles);
			}
			if(isdefined(points[i].target))
			{
				if(!isdefined(org))
				{
					org = spawn("script_model", self.origin + VectorScale((0, 0, -1), 60));
					org SetModel("tag_origin");
				}
				org.origin = points[i].origin;
				org.angles = points[i].angles;
				for(j = 0; j < GetPlayers().size; j++)
				{
					player = GetPlayers()[j];
					player CameraSetPosition(org);
					player CameraSetLookAt();
					player CameraActivate(1);
				}
				speed = 20;
				if(isdefined(points[i].speed))
				{
					speed = points[i].speed;
				}
				target_point = struct::get(points[i].target, "targetname");
				dist = Distance(points[i].origin, target_point.origin);
				time = dist / speed;
				q_time = time * 0.25;
				if(q_time > 1)
				{
					q_time = 1;
				}
				self.game_over_bg fadeOverTime(q_time);
				self.game_over_bg.alpha = 0;
				org moveto(target_point.origin, time, q_time, q_time);
				org RotateTo(target_point.angles, time, q_time, q_time);
				wait(time - q_time);
				self.game_over_bg fadeOverTime(q_time);
				self.game_over_bg.alpha = 1;
				wait(q_time);
				continue;
			}
			self.game_over_bg fadeOverTime(1);
			self.game_over_bg.alpha = 0;
			wait(5);
			self.game_over_bg thread zm::fade_up_over_time(1);
		}
	}
}

/*
	Name: setup_ee_main_devgui
	Namespace: zm_tomb_ee_main
	Checksum: 0xF901B9C4
	Offset: 0x2110
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function setup_ee_main_devgui()
{
	/#
		wait(5);
		b_activated = 0;
		while(!b_activated)
		{
			foreach(player in GetPlayers())
			{
				if(Distance2D(player.origin, (2904, 5040, -336)) < 100 && player useButtonPressed())
				{
					wait(2);
					if(player useButtonPressed())
					{
						b_activated = 1;
					}
				}
			}
			wait(0.05);
		}
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		level thread watch_devgui_ee_main();
	#/
}

/*
	Name: watch_devgui_ee_main
	Namespace: zm_tomb_ee_main
	Checksum: 0x19A833D3
	Offset: 0x2308
	Size: 0x477
	Parameters: 0
	Flags: None
*/
function watch_devgui_ee_main()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level.ee_debug = 1;
				level flag::set("Dev Block strings are not supported");
				switch(level._cur_stage_name)
				{
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level flag::set("Dev Block strings are not supported");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_1_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_2_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						m_floor = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
						if(isdefined(m_floor))
						{
							m_floor delete();
						}
						level waittill("little_girl_lost_step_3_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level flag::set("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_4_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level flag::clear("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_5_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_6_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_7_over");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level flag::set("Dev Block strings are not supported");
						level waittill("little_girl_lost_step_8_over");
						break;
					}
					case default:
					{
						break;
					}
				}
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level clientfield::set("Dev Block strings are not supported", 2);
				complete_sidequest();
			}
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				Array::thread_all(GetPlayers(), &zm_weapons::weapon_give, "Dev Block strings are not supported");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_ab51bfd
	Namespace: zm_tomb_ee_main
	Checksum: 0xF95EA982
	Offset: 0x2788
	Size: 0x1A1
	Parameters: 0
	Flags: None
*/
function function_ab51bfd()
{
	a_ai_enemies = GetAITeamArray("axis");
	foreach(ai in a_ai_enemies)
	{
		if(isalive(ai))
		{
			ai.marked_for_death = 1;
			ai ai::set_ignoreall(1);
		}
		util::wait_network_frame();
	}
	foreach(ai in a_ai_enemies)
	{
		if(isalive(ai))
		{
			ai DoDamage(ai.health + 666, ai.origin);
		}
	}
}

