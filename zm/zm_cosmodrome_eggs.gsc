#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_cosmodrome;
#using scripts\zm\zm_cosmodrome_amb;
#using scripts\zm\zm_cosmodrome_eggs;

#namespace namespace_f23e8c1a;

/*
	Name: init
	Namespace: namespace_f23e8c1a
	Checksum: 0x7E63E63F
	Offset: 0xA30
	Size: 0x4BB
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("target_teleported");
	level flag::init("rerouted_power");
	level flag::init("switches_synced");
	level flag::init("pressure_sustained");
	level flag::init("passkey_confirmed");
	level flag::init("weapons_combined");
	level.casimir_lights = [];
	level.lander_letters["a"] = GetEnt("letter_a", "targetname");
	level.lander_letters["e"] = GetEnt("letter_e", "targetname");
	level.lander_letters["h"] = GetEnt("letter_h", "targetname");
	level.lander_letters["i"] = GetEnt("letter_i", "targetname");
	level.lander_letters["l"] = GetEnt("letter_l", "targetname");
	level.lander_letters["m"] = GetEnt("letter_m", "targetname");
	level.lander_letters["n"] = GetEnt("letter_n", "targetname");
	level.lander_letters["r"] = GetEnt("letter_r", "targetname");
	level.lander_letters["s"] = GetEnt("letter_s", "targetname");
	level.lander_letters["t"] = GetEnt("letter_t", "targetname");
	level.lander_letters["u"] = GetEnt("letter_u", "targetname");
	level.lander_letters["y"] = GetEnt("letter_y", "targetname");
	keys = getArrayKeys(level.lander_letters);
	for(i = 0; i < keys.size; i++)
	{
		level.lander_letters[keys[i]] ghost();
	}
	monitor = GetEnt("casimir_monitor", "targetname");
	monitor SetModel("p7_zm_asc_monitor_screen_off");
	teleport_target_event();
	reroute_power_event();
	sync_switch_event();
	pressure_plate_event();
	lander_passkey_event();
	weapon_combo_event();
	level notify("help_found");
	monitor = GetEnt("casimir_monitor", "targetname");
	monitor SetModel("p7_zm_asc_monitor_screen_off");
	monitor StopLoopSound(0.1);
	monitor playsound("zmb_ee_monitor_off");
}

/*
	Name: play_easter_egg_audio
	Namespace: namespace_f23e8c1a
	Checksum: 0xDA9BC137
	Offset: 0xEF8
	Size: 0x71
	Parameters: 3
	Flags: None
*/
function play_easter_egg_audio(alias, sound_ent, text)
{
	if(alias == undefined)
	{
		/#
			IPrintLnBold(text);
		#/
		return;
	}
	sound_ent PlaySoundWithNotify(alias, "sounddone");
	sound_ent waittill("sounddone");
}

/*
	Name: activate_casimir_light
	Namespace: namespace_f23e8c1a
	Checksum: 0x76077CD9
	Offset: 0xF78
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function activate_casimir_light(num)
{
	spot = struct::get("casimir_light_" + num, "targetname");
	if(isdefined(spot))
	{
		light = spawn("script_model", spot.origin);
		light SetModel("tag_origin");
		light.angles = spot.angles;
		FX = PlayFXOnTag(level._effect["fx_light_ee_progress"], light, "tag_origin");
		level.casimir_lights[level.casimir_lights.size] = light;
	}
}

/*
	Name: teleport_target_event
	Namespace: namespace_f23e8c1a
	Checksum: 0x20C0495
	Offset: 0x1090
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function teleport_target_event()
{
	teleport_target_start = struct::get("teleport_target_start", "targetname");
	teleport_target_spark = struct::get("teleport_target_spark", "targetname");
	var_1dc1d30a = teleport_target_spark.angles;
	level.teleport_target = spawn("script_model", teleport_target_start.origin);
	level.teleport_target SetModel("p7_zm_asc_transformer_electrical");
	level.teleport_target.angles = teleport_target_start.angles;
	teleport_target_spark = spawn("script_model", teleport_target_spark.origin);
	teleport_target_spark SetModel("tag_origin");
	teleport_target_spark.angles = var_1dc1d30a;
	PlayFXOnTag(level._effect["generator_ee_sparks"], teleport_target_spark, "tag_origin");
	level.teleport_target_trigger = spawn("trigger_radius", teleport_target_start.origin + VectorScale((0, 0, -1), 70), 0, 125, 100);
	/#
		if(!isdefined(level.debug_skip_teleport_event) || !level.debug_skip_teleport_event)
		{
			level.teleport_target thread zm_cosmodrome::debug_display_at_pos(level.teleport_target.origin, "Dev Block strings are not supported", "Dev Block strings are not supported", 2);
		}
	#/
	level.black_hole_bomb_loc_check_func = &bhb_teleport_loc_check;
	level waittill("hash_2a49912");
	teleport_target_spark delete();
	level flag::wait_till("target_teleported");
	level.black_hole_bomb_loc_check_func = undefined;
	level thread play_egg_vox("vox_ann_egg1_success", "vox_gersh_egg1", 1);
}

/*
	Name: bhb_teleport_loc_check
	Namespace: namespace_f23e8c1a
	Checksum: 0x348C9816
	Offset: 0x1348
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function bhb_teleport_loc_check(grenade, model, info)
{
	if(isdefined(level.teleport_target_trigger) && grenade istouching(level.teleport_target_trigger))
	{
		model clientfield::set("toggle_black_hole_deployed", 1);
		level thread teleport_target(grenade, model);
		return 1;
	}
	return 0;
}

/*
	Name: teleport_target
	Namespace: namespace_f23e8c1a
	Checksum: 0xAEAD40EA
	Offset: 0x13E0
	Size: 0x243
	Parameters: 2
	Flags: None
*/
function teleport_target(grenade, model)
{
	level.teleport_target_trigger delete();
	level.teleport_target_trigger = undefined;
	wait(1);
	level notify("hash_2a49912");
	time = 3;
	level.teleport_target moveto(grenade.origin + VectorScale((0, 0, 1), 50), time, time - 0.05);
	wait(time);
	teleport_target_end = struct::get("teleport_target_end", "targetname");
	level.teleport_target ghost();
	playsoundatposition("zmb_gersh_teleporter_out", grenade.origin + VectorScale((0, 0, 1), 50));
	wait(0.5);
	level.teleport_target.angles = teleport_target_end.angles;
	level.teleport_target moveto(teleport_target_end.origin, 0.05);
	wait(0.5);
	level.teleport_target show();
	PlayFXOnTag(level._effect["black_hole_bomb_event_horizon"], level.teleport_target, "tag_origin");
	level.teleport_target playsound("zmb_gersh_teleporter_go");
	wait(2);
	model delete();
	level flag::set("target_teleported");
}

/*
	Name: reroute_power_event
	Namespace: namespace_f23e8c1a
	Checksum: 0x89C2963C
	Offset: 0x1630
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function reroute_power_event()
{
	monitor = GetEnt("casimir_monitor", "targetname");
	location = struct::get("casimir_monitor_struct", "targetname");
	monitor playsound("zmb_ee_monitor_on");
	monitor PlayLoopSound("zmb_ee_monitor_whitenoise", 1);
	monitor SetModel("p7_zm_asc_monitor_screen_on");
	trig = spawn("trigger_radius", location.origin, 0, 32, 60);
	/#
		if(!isdefined(level.debug_skip_reroute_event) || !level.debug_skip_reroute_event)
		{
			trig thread zm_cosmodrome::debug_display_at_pos(monitor.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
	trig wait_for_use(monitor);
	trig delete();
	level flag::set("rerouted_power");
	monitor SetModel("p7_zm_asc_monitor_screen_logo");
	monitor PlayLoopSound("zmb_ee_monitor_active", 1);
	level thread play_egg_vox("vox_ann_egg2_success", "vox_gersh_egg2", 2);
	level thread activate_casimir_light(1);
}

/*
	Name: wait_for_use
	Namespace: namespace_f23e8c1a
	Checksum: 0x12A32001
	Offset: 0x1858
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function wait_for_use(monitor)
{
	/#
		if(isdefined(level.debug_skip_reroute_event) && level.debug_skip_reroute_event)
		{
			return;
		}
	#/
	while(1)
	{
		self waittill("trigger", who);
		while(isPlayer(who) && who istouching(self))
		{
			if(who useButtonPressed())
			{
				level flag::set("rerouted_power");
				monitor playsound("zmb_ee_monitor_button");
				return;
			}
			wait(0.05);
		}
	}
}

/*
	Name: sync_switch_event
	Namespace: namespace_f23e8c1a
	Checksum: 0x1D34EF7C
	Offset: 0x1940
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function sync_switch_event()
{
	switches = struct::get_array("sync_switch_start", "targetname");
	self waittill_switches_synced(switches);
	level thread play_egg_vox("vox_ann_egg3_success", "vox_gersh_egg3", 3);
	level thread activate_casimir_light(2);
}

/*
	Name: waittill_switches_synced
	Namespace: namespace_f23e8c1a
	Checksum: 0x2BE59079
	Offset: 0x19D8
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function waittill_switches_synced(switches)
{
	/#
		if(isdefined(level.debug_skip_sync_event) && level.debug_skip_sync_event)
		{
			return;
		}
	#/
	while(!level flag::get("switches_synced"))
	{
		level flag::wait_till("monkey_round");
		Array::thread_all(switches, &reveal_switch);
		self thread switch_watcher();
		level util::waittill_either("between_round_over", "switches_synced");
	}
}

/*
	Name: reveal_switch
	Namespace: namespace_f23e8c1a
	Checksum: 0x32C79B62
	Offset: 0x1AA8
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function reveal_switch()
{
	button = spawn("script_model", self.origin);
	button SetModel("p7_zm_asc_switch_electric_05");
	button.angles = self.angles + VectorScale((0, 1, 0), 90);
	offset = AnglesToForward(self.angles) * 8;
	time = 1;
	button moveto(button.origin + offset, 1);
	wait(1);
	if(level flag::get("monkey_round"))
	{
		trig = spawn("trigger_radius", button.origin, 0, 32, 72);
		/#
			if(!isdefined(level.debug_skip_sync_event) || !level.debug_skip_sync_event)
			{
				trig thread zm_cosmodrome::debug_display_at_pos(button.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
			}
		#/
		trig thread wait_for_sync_use(self, button);
		level util::waittill_either("between_round_over", "switches_synced");
		/#
			if(!isdefined(level.debug_skip_sync_event) || !level.debug_skip_sync_event)
			{
				trig zm_cosmodrome::debug_remove("Dev Block strings are not supported");
			}
		#/
		trig delete();
	}
	button moveto(self.origin, time);
	wait(time);
	button delete();
}

/*
	Name: wait_for_sync_use
	Namespace: namespace_f23e8c1a
	Checksum: 0xAC8A09A5
	Offset: 0x1D20
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function wait_for_sync_use(ss, button)
{
	level endon("between_round_over");
	level endon("switches_synced");
	ss.pressed = 0;
	while(1)
	{
		self waittill("trigger", who);
		while(isPlayer(who) && who istouching(self))
		{
			if(who useButtonPressed())
			{
				level notify("sync_button_pressed");
				button playsound("zmb_ee_syncbutton_button");
				ss.pressed = 1;
				/#
					IPrintLnBold("Dev Block strings are not supported");
				#/
				while(who useButtonPressed())
				{
					wait(0.05);
				}
			}
			wait(0.05);
		}
	}
}

/*
	Name: switch_watcher
	Namespace: namespace_f23e8c1a
	Checksum: 0x1DBD00F8
	Offset: 0x1E60
	Size: 0x265
	Parameters: 0
	Flags: None
*/
function switch_watcher()
{
	level endon("between_round_over");
	pressed = 0;
	switches = struct::get_array("sync_switch_start", "targetname");
	while(1)
	{
		level waittill("sync_button_pressed");
		timeout = GetTime() + 500;
		/#
			if(isdefined(level.sp_egg_testing) && level.sp_egg_testing)
			{
				timeout = timeout + 100000;
			}
		#/
		while(GetTime() < timeout)
		{
			pressed = 0;
			for(i = 0; i < switches.size; i++)
			{
				if(isdefined(switches[i].pressed) && switches[i].pressed)
				{
					pressed++;
				}
			}
			if(pressed == 4)
			{
				level flag::set("switches_synced");
				level notify("switches_synced");
				for(i = 0; i < switches.size; i++)
				{
					playsoundatposition("zmb_ee_syncbutton_success", switches[i].origin);
				}
				return;
			}
			wait(0.05);
		}
		switch(pressed)
		{
			case 1:
			case 2:
			case 3:
			{
				for(i = 0; i < switches.size; i++)
				{
					playsoundatposition("zmb_ee_syncbutton_deny", switches[i].origin);
				}
				break;
			}
		}
		for(i = 0; i < switches.size; i++)
		{
			switches[i].pressed = 0;
		}
	}
}

/*
	Name: pressure_plate_event
	Namespace: namespace_f23e8c1a
	Checksum: 0x9326816A
	Offset: 0x20D0
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function pressure_plate_event()
{
	area = struct::get("pressure_pad", "targetname");
	trig = spawn("trigger_radius", area.origin, 0, 300, 100);
	n_timer = 120;
	/#
		if(isdefined(level.debug_pressure_plate_time) && level.debug_pressure_plate_time)
		{
			n_timer = 30;
		}
	#/
	trig area_timer(n_timer);
	trig delete();
	level thread play_egg_vox("vox_ann_egg4_success", "vox_gersh_egg4", 4);
	level thread activate_casimir_light(3);
}

/*
	Name: area_timer
	Namespace: namespace_f23e8c1a
	Checksum: 0x89F6BB6D
	Offset: 0x21F8
	Size: 0x5E9
	Parameters: 1
	Flags: None
*/
function area_timer(time)
{
	clock_loc = struct::get("pressure_timer", "targetname");
	clock = spawn("script_model", clock_loc.origin);
	clock SetModel("p7_zm_tra_wall_clock");
	clock.angles = clock_loc.angles;
	var_b07ae42e = struct::get("clock_timer_hand", "targetname");
	timer_hand_angles_init = VectorScale((0, 1, 0), 90);
	timer_hand = util::spawn_model("p7_zm_kin_clock_second_hand", var_b07ae42e.origin, timer_hand_angles_init);
	/#
		if(!isdefined(level.debug_skip_pressure_plate) || !level.debug_skip_pressure_plate)
		{
			self thread zm_cosmodrome::debug_display_at_pos(self.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else if(isdefined(level.debug_skip_pressure_plate) && level.debug_skip_pressure_plate)
		{
			self thread debug_trigger_pressure_plate();
		}
	#/
	step = 1;
	while(!level flag::get("pressure_sustained"))
	{
		self waittill("trigger");
		stop_timer = 0;
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] istouching(self))
			{
				wait(step);
				stop_timer = 1;
				/#
					if(isdefined(level.debug_skip_pressure_plate) && level.debug_skip_pressure_plate)
					{
						stop_timer = 0;
					}
				#/
			}
		}
		if(stop_timer)
		{
			continue;
		}
		self playsound("zmb_ee_pressure_plate_down");
		time_remaining = time;
		timer_hand RotatePitch(-360, time);
		/#
			if(isdefined(level.debug_skip_pressure_plate) && level.debug_skip_pressure_plate)
			{
				time_remaining = 0;
			}
		#/
		while(time_remaining)
		{
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				if(!players[i] istouching(self))
				{
					wait(step);
					time_remaining = time;
					stop_timer = 1;
					self playsound("zmb_ee_pressure_plate_up");
					timer_hand RotateTo(timer_hand_angles_init, 0.5);
					timer_hand playsound("zmb_ee_pressure_deny");
					wait(0.5);
					break;
				}
			}
			if(stop_timer)
			{
				break;
			}
			wait(step);
			time_remaining = time_remaining - step;
			timer_hand playsound("zmb_ee_pressure_timer");
		}
		if(time_remaining <= 0)
		{
			level flag::set("pressure_sustained");
			players = GetPlayers();
			temp_fx = undefined;
			if(isdefined(players[0].FX))
			{
				temp_fx = players[0].FX;
			}
			timer_hand playsound("zmb_perks_packa_ready");
			players[0].FX = level.zombie_powerups["nuke"].FX;
			level thread zm_powerup_nuke::nuke_powerup(players[0], players[0].team);
			clock StopLoopSound(1);
			wait(1);
			if(isdefined(temp_fx))
			{
				players[0].FX = temp_fx;
			}
			else
			{
				players[0].FX = undefined;
			}
			/#
				if(!isdefined(level.debug_skip_pressure_plate) || !level.debug_skip_pressure_plate)
				{
					self zm_cosmodrome::debug_remove("Dev Block strings are not supported");
				}
			#/
			clock delete();
			timer_hand delete();
			return;
		}
	}
}

/*
	Name: debug_trigger_pressure_plate
	Namespace: namespace_f23e8c1a
	Checksum: 0x235E7242
	Offset: 0x27F0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function debug_trigger_pressure_plate()
{
	/#
		wait(1);
		self notify("trigger");
	#/
}

/*
	Name: lander_passkey_event
	Namespace: namespace_f23e8c1a
	Checksum: 0x2F453967
	Offset: 0x2818
	Size: 0x343
	Parameters: 0
	Flags: None
*/
function lander_passkey_event()
{
	level flag::init("letter_acquired");
	level.lander_key = [];
	level.lander_key["lander_station1"]["lander_station3"] = "s";
	level.lander_key["lander_station1"]["lander_station4"] = "r";
	level.lander_key["lander_station1"]["lander_station5"] = "e";
	level.lander_key["lander_station3"]["lander_station1"] = "y";
	level.lander_key["lander_station3"]["lander_station4"] = "a";
	level.lander_key["lander_station3"]["lander_station5"] = "i";
	level.lander_key["lander_station4"]["lander_station1"] = "m";
	level.lander_key["lander_station4"]["lander_station3"] = "h";
	level.lander_key["lander_station4"]["lander_station5"] = "u";
	level.lander_key["lander_station5"]["lander_station1"] = "t";
	level.lander_key["lander_station5"]["lander_station3"] = "n";
	level.lander_key["lander_station5"]["lander_station4"] = "l";
	level.passkey = Array("l", "u", "n", "a");
	level.passkey_progress = 0;
	level.secret1 = Array("h", "i", "t", "s", "a", "m");
	level.secret1_progress = 0;
	level.secret2 = Array("h", "y", "e", "n", "a");
	level.secret2_progress = 0;
	level thread lander_monitor();
	level flag::wait_till("passkey_confirmed");
	level thread play_egg_vox("vox_ann_egg5_success", "vox_gersh_egg5", 5);
	level thread activate_casimir_light(4);
}

/*
	Name: lander_monitor
	Namespace: namespace_f23e8c1a
	Checksum: 0x64AE7ABF
	Offset: 0x2B68
	Size: 0x357
	Parameters: 0
	Flags: None
*/
function lander_monitor()
{
	lander = GetEnt("lander", "targetname");
	/#
		if(isdefined(level.debug_skip_luna) && level.debug_skip_luna)
		{
			return;
		}
		lander thread debug_passkey_event();
	#/
	while(!level flag::get("passkey_confirmed"))
	{
		level waittill("lander_launched");
		if(lander.called)
		{
			start = lander.depart_station;
			dest = lander.station;
			letter = level.lander_key[start][dest];
			model = level.lander_letters[letter];
			model show();
			model playsound("zmb_spawn_powerup");
			model thread spin_letter();
			model PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
			trig = spawn("trigger_radius", model.origin, 0, 200, 150);
			/#
				trig function_362373ab(model);
			#/
			trig thread letter_grab(letter, model);
			level flag::wait_till("lander_grounded");
			if(!level flag::get("letter_acquired"))
			{
				function_874d06b6();
				/#
					lander thread debug_passkey_event();
					trig thread zm_cosmodrome::debug_remove("Dev Block strings are not supported");
				#/
			}
			else
			{
				level flag::clear("letter_acquired");
			}
			trig delete();
			model ghost();
			model StopLoopSound(0.5);
		}
		else
		{
			function_874d06b6();
			/#
				lander thread debug_passkey_event();
				trig thread zm_cosmodrome::debug_remove("Dev Block strings are not supported");
			#/
		}
	}
}

/*
	Name: function_362373ab
	Namespace: namespace_f23e8c1a
	Checksum: 0x45AE0F1E
	Offset: 0x2EC8
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function function_362373ab(model)
{
	/#
		if(level flag::get("Dev Block strings are not supported"))
		{
			v_player_angles = GetPlayers()[0] getPlayerAngles();
			v_player_origin = GetPlayers()[0] GetOrigin();
			var_ab7c1d7f = v_player_origin + AnglesToForward(v_player_angles) * 128;
			model.origin = level.s_call_to_station.origin + VectorScale((0, 0, 1), 32);
			self.origin = model.origin;
		}
		self thread zm_cosmodrome::debug_display_at_pos(model.origin, "Dev Block strings are not supported", "Dev Block strings are not supported", 3);
	#/
}

/*
	Name: function_874d06b6
	Namespace: namespace_f23e8c1a
	Checksum: 0x47496ED
	Offset: 0x3018
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_874d06b6()
{
	/#
		level notify("passkey_reset");
	#/
	level.passkey_progress = 0;
	level.secret1_progress = 0;
	level.secret2_progress = 0;
}

/*
	Name: debug_passkey_event
	Namespace: namespace_f23e8c1a
	Checksum: 0xBE135435
	Offset: 0x3058
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function debug_passkey_event()
{
	/#
		if(!isdefined(level.debug_skip_luna) || !level.debug_skip_luna)
		{
			level endon("passkey_reset");
			a_str_passkey_stations = Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
			for(i = 0; i < a_str_passkey_stations.size; i++)
			{
				level.s_call_to_station = struct::get(a_str_passkey_stations[i], "Dev Block strings are not supported");
				level.s_call_to_station thread zm_cosmodrome::debug_display_at_pos(level.s_call_to_station.origin, "Dev Block strings are not supported", "Dev Block strings are not supported", 3);
				self debug_waittill_lander_station(level.s_call_to_station);
			}
		}
	#/
}

/*
	Name: debug_waittill_lander_station
	Namespace: namespace_f23e8c1a
	Checksum: 0x272545F8
	Offset: 0x3188
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function debug_waittill_lander_station(s_station)
{
	/#
		while(self.station != s_station.targetname)
		{
			wait(0.25);
		}
		s_station notify("lander_reached_station");
		util::wait_network_frame();
	#/
}

/*
	Name: spin_letter
	Namespace: namespace_f23e8c1a
	Checksum: 0xFA0519E2
	Offset: 0x31E8
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function spin_letter()
{
	level endon("lander_grounded");
	level endon("letter_acquired");
	while(1)
	{
		self RotateYaw(90, 5);
		wait(5);
	}
}

/*
	Name: letter_grab
	Namespace: namespace_f23e8c1a
	Checksum: 0xF16BDC23
	Offset: 0x3238
	Size: 0x1EB
	Parameters: 2
	Flags: None
*/
function letter_grab(letter, model)
{
	level endon("lander_grounded");
	self waittill("trigger", e_player);
	level flag::set("letter_acquired");
	playsoundatposition("zmb_powerup_grabbed", model.origin);
	model ghost();
	/#
		self zm_cosmodrome::debug_remove("Dev Block strings are not supported");
	#/
	if(letter == level.passkey[level.passkey_progress])
	{
		level.passkey_progress++;
		if(level.passkey_progress == level.passkey.size)
		{
			level flag::set("passkey_confirmed");
		}
	}
	else
	{
		level.passkey_progress = 0;
	}
	if(letter == level.secret1[level.secret1_progress])
	{
		level.secret1_progress++;
		if(level.secret1_progress == level.secret1.size)
		{
			e_player playsoundtoplayer("evt_letter_pickup_secret_1", e_player);
		}
	}
	else
	{
		level.secret1_progress = 0;
	}
	if(letter == level.secret2[level.secret2_progress])
	{
		level.secret2_progress++;
		if(level.secret2_progress == level.secret2.size)
		{
			e_player playsoundtoplayer("evt_letter_pickup_secret_2", e_player);
		}
	}
	else
	{
		level.secret2_progress = 0;
	}
}

/*
	Name: weapon_combo_event
	Namespace: namespace_f23e8c1a
	Checksum: 0xC96906AC
	Offset: 0x3430
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function weapon_combo_event()
{
	level flag::init("thundergun_hit");
	weapon_combo_spot = struct::get("weapon_combo_spot", "targetname");
	focal_point = spawn("script_model", weapon_combo_spot.origin);
	focal_point SetModel("tag_origin");
	FX = PlayFXOnTag(level._effect["gersh_spark"], focal_point, "tag_origin");
	level.black_hold_bomb_target_trig = spawn("trigger_radius", weapon_combo_spot.origin, 0, 50, 72);
	level.black_hole_bomb_loc_check_func = &bhb_combo_loc_check;
	/#
		focal_point thread function_a0ad103c(weapon_combo_spot);
	#/
	level flag::wait_till("weapons_combined");
	level.black_hold_bomb_target_trig delete();
	level.black_hole_bomb_loc_check_func = undefined;
	focal_point delete();
	for(i = 0; i < level.casimir_lights.size; i++)
	{
		level.casimir_lights[i] delete();
	}
}

/*
	Name: function_a0ad103c
	Namespace: namespace_f23e8c1a
	Checksum: 0xD69D8FD4
	Offset: 0x3628
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_a0ad103c(weapon_combo_spot)
{
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			self thread function_510c4845();
			wait(1);
			self notify("death");
		}
		else
		{
			weapon_combo_spot thread function_8172c64e();
		}
	#/
}

/*
	Name: function_8172c64e
	Namespace: namespace_f23e8c1a
	Checksum: 0x25741739
	Offset: 0x36A0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_8172c64e()
{
	/#
		self thread zm_cosmodrome::debug_display_at_pos(self.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
		level flag::wait_till("Dev Block strings are not supported");
		self thread zm_cosmodrome::debug_remove("Dev Block strings are not supported");
	#/
}

/*
	Name: bhb_combo_loc_check
	Namespace: namespace_f23e8c1a
	Checksum: 0xF39A4078
	Offset: 0x3728
	Size: 0x5D
	Parameters: 3
	Flags: None
*/
function bhb_combo_loc_check(grenade, model, info)
{
	if(isdefined(level.black_hold_bomb_target_trig) && grenade istouching(level.black_hold_bomb_target_trig))
	{
		grenade function_510c4845();
	}
	return 0;
}

/*
	Name: function_510c4845
	Namespace: namespace_f23e8c1a
	Checksum: 0x286B70FE
	Offset: 0x3790
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_510c4845()
{
	trig = spawn("trigger_damage", self.origin, 0, 15, 72);
	self thread wait_for_combo(trig);
}

/*
	Name: wait_for_combo
	Namespace: namespace_f23e8c1a
	Checksum: 0xF5AD32C6
	Offset: 0x37F0
	Size: 0x289
	Parameters: 1
	Flags: None
*/
function wait_for_combo(trig)
{
	self endon("death");
	self thread kill_trig_on_death(trig);
	weapon_combo_spot = struct::get("weapon_combo_spot", "targetname");
	ray_gun_hit = 0;
	doll_hit = 0;
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			ray_gun_hit = 1;
			doll_hit = 1;
		}
	#/
	players = GetPlayers();
	Array::thread_all(players, &thundergun_check, self, trig, weapon_combo_spot);
	while(1)
	{
		trig waittill("damage", amount, inflictor, direction, point, type, tagName, modelName, partName, weapon);
		if(isdefined(inflictor))
		{
			if(type == "MOD_PROJECTILE" && (weapon.name == "ray_gun_upgraded" || weapon.name == "raygun_mark2_upgraded"))
			{
				ray_gun_hit = 1;
			}
			else if(weapon.name == "nesting_dolls" || weapon.name == "nesting_dolls_single")
			{
				doll_hit = 1;
			}
			if(ray_gun_hit && doll_hit && level flag::get("thundergun_hit"))
			{
				level flag::set("weapons_combined");
				level thread soul_release(self, trig.origin);
				return;
			}
		}
	}
}

/*
	Name: thundergun_check
	Namespace: namespace_f23e8c1a
	Checksum: 0xB534131B
	Offset: 0x3A88
	Size: 0x1B7
	Parameters: 3
	Flags: None
*/
function thundergun_check(model, trig, weapon_combo_spot)
{
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			util::wait_network_frame();
			self function_30d8de55(trig);
			return;
		}
	#/
	model endon("death");
	while(1)
	{
		self waittill("weapon_fired");
		w_player_weapon = self GetCurrentWeapon();
		if(w_player_weapon.name == "thundergun_upgraded")
		{
			if(DistanceSquared(self.origin, weapon_combo_spot.origin) < 90000)
			{
				vector_to_spot = VectorNormalize(weapon_combo_spot.origin - self GetWeaponMuzzlePoint());
				vector_player_facing = self GetWeaponForwardDir();
				angle_diff = ACos(VectorDot(vector_to_spot, vector_player_facing));
				if(angle_diff <= 20)
				{
					self function_30d8de55(trig);
				}
			}
		}
	}
}

/*
	Name: function_30d8de55
	Namespace: namespace_f23e8c1a
	Checksum: 0xED7CDC56
	Offset: 0x3C48
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_30d8de55(trig)
{
	level flag::set("thundergun_hit");
	RadiusDamage(trig.origin, 5, 1, 1, self);
}

/*
	Name: kill_trig_on_death
	Namespace: namespace_f23e8c1a
	Checksum: 0x9A59AA6E
	Offset: 0x3CB0
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function kill_trig_on_death(trig)
{
	self waittill("death");
	trig delete();
	if(level flag::get("thundergun_hit") && !level flag::get("weapons_combined"))
	{
		level thread play_egg_vox("vox_ann_egg6p1_success", "vox_gersh_egg6_fail2", 7);
	}
	else if(!level flag::get("weapons_combined"))
	{
		level thread play_egg_vox(undefined, "vox_gersh_egg6_fail1", 6);
	}
	level flag::clear("thundergun_hit");
}

/*
	Name: soul_release
	Namespace: namespace_f23e8c1a
	Checksum: 0xCA277015
	Offset: 0x3DB8
	Size: 0x17B
	Parameters: 2
	Flags: None
*/
function soul_release(model, origin)
{
	soul = spawn("script_model", origin);
	soul SetModel("tag_origin");
	soul PlayLoopSound("zmb_egg_soul");
	FX = PlayFXOnTag(level._effect["gersh_spark"], soul, "tag_origin");
	time = 20;
	model waittill("death");
	level thread play_egg_vox("vox_ann_egg6_success", "vox_gersh_egg6_success", 9);
	level thread wait_for_gersh_vox();
	soul MoveZ(2500, time, time - 1);
	wait(time);
	soul delete();
	wait(2);
	level thread samantha_is_angry();
}

/*
	Name: wait_for_gersh_vox
	Namespace: namespace_f23e8c1a
	Checksum: 0xEEBAFA53
	Offset: 0x3F40
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function wait_for_gersh_vox()
{
	wait(12.5);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread reward_wait();
	}
}

/*
	Name: reward_wait
	Namespace: namespace_f23e8c1a
	Checksum: 0x10D4E2A3
	Offset: 0x3FB8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function reward_wait()
{
	while(!zombie_utility::is_player_valid(self) || (self useButtonPressed() && self zm_utility::in_revive_trigger()))
	{
		wait(1);
	}
	if(!self bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		level thread zm_powerup_weapon_minigun::minigun_weapon_powerup(self, 90);
	}
	self zm_utility::give_player_all_perks();
}

/*
	Name: play_egg_vox
	Namespace: namespace_f23e8c1a
	Checksum: 0xB7648028
	Offset: 0x4078
	Size: 0x1BB
	Parameters: 3
	Flags: None
*/
function play_egg_vox(ann_alias, gersh_alias, plr_num)
{
	if(isdefined(ann_alias))
	{
		level namespace_9dd378ec::play_cosmo_announcer_vox(ann_alias);
	}
	if(isdefined(plr_num) && !isdefined(level.var_92ed253c))
	{
		players = GetPlayers();
		rand = randomIntRange(0, players.size);
		players[rand] PlaySoundWithNotify("vox_plr_" + players[rand].characterindex + "_level_start_" + randomIntRange(0, 4), "level_start_vox_done");
		players[rand] waittill("level_start_vox_done");
		level.var_92ed253c = 1;
	}
	if(isdefined(gersh_alias))
	{
		level namespace_9dd378ec::play_gersh_vox(gersh_alias);
	}
	if(isdefined(plr_num))
	{
		players = GetPlayers();
		rand = randomIntRange(0, players.size);
		players[rand] zm_audio::create_and_play_dialog("eggs", "gersh_response", plr_num);
	}
}

/*
	Name: samantha_is_angry
	Namespace: namespace_f23e8c1a
	Checksum: 0x2F0A3798
	Offset: 0x4240
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function samantha_is_angry()
{
	playsoundatposition("zmb_samantha_earthquake", (0, 0, 0));
	playsoundatposition("zmb_samantha_whispers", (0, 0, 0));
	wait(6);
	level clientfield::set("COSMO_EGG_SAM_ANGRY", 1);
	playsoundatposition("zmb_samantha_scream", (0, 0, 0));
	wait(6);
	level clientfield::set("COSMO_EGG_SAM_ANGRY", 0);
}

