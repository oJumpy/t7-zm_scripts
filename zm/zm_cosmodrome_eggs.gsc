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
	level.var_1999d459 = [];
	level.var_46651379["a"] = GetEnt("letter_a", "targetname");
	level.var_46651379["e"] = GetEnt("letter_e", "targetname");
	level.var_46651379["h"] = GetEnt("letter_h", "targetname");
	level.var_46651379["i"] = GetEnt("letter_i", "targetname");
	level.var_46651379["l"] = GetEnt("letter_l", "targetname");
	level.var_46651379["m"] = GetEnt("letter_m", "targetname");
	level.var_46651379["n"] = GetEnt("letter_n", "targetname");
	level.var_46651379["r"] = GetEnt("letter_r", "targetname");
	level.var_46651379["s"] = GetEnt("letter_s", "targetname");
	level.var_46651379["t"] = GetEnt("letter_t", "targetname");
	level.var_46651379["u"] = GetEnt("letter_u", "targetname");
	level.var_46651379["y"] = GetEnt("letter_y", "targetname");
	keys = getArrayKeys(level.var_46651379);
	for(i = 0; i < keys.size; i++)
	{
		level.var_46651379[keys[i]] ghost();
	}
	monitor = GetEnt("casimir_monitor", "targetname");
	monitor SetModel("p7_zm_asc_monitor_screen_off");
	function_2f116aad();
	function_6b4d4b8a();
	function_55c69e42();
	function_38cded10();
	function_18c28e7b();
	function_6f6480bb();
	level notify("hash_e09c6a09");
	monitor = GetEnt("casimir_monitor", "targetname");
	monitor SetModel("p7_zm_asc_monitor_screen_off");
	monitor StopLoopSound(0.1);
	monitor playsound("zmb_ee_monitor_off");
}

/*
	Name: function_bf374409
	Namespace: namespace_f23e8c1a
	Checksum: 0xDA9BC137
	Offset: 0xEF8
	Size: 0x71
	Parameters: 3
	Flags: None
*/
function function_bf374409(alias, sound_ent, text)
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
	Name: function_55403b86
	Namespace: namespace_f23e8c1a
	Checksum: 0x76077CD9
	Offset: 0xF78
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function function_55403b86(num)
{
	spot = struct::get("casimir_light_" + num, "targetname");
	if(isdefined(spot))
	{
		light = spawn("script_model", spot.origin);
		light SetModel("tag_origin");
		light.angles = spot.angles;
		FX = PlayFXOnTag(level._effect["fx_light_ee_progress"], light, "tag_origin");
		level.var_1999d459[level.var_1999d459.size] = light;
	}
}

/*
	Name: function_2f116aad
	Namespace: namespace_f23e8c1a
	Checksum: 0x20C0495
	Offset: 0x1090
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function function_2f116aad()
{
	var_e624516d = struct::get("teleport_target_start", "targetname");
	var_cf61e83e = struct::get("teleport_target_spark", "targetname");
	var_1dc1d30a = var_cf61e83e.angles;
	level.teleport_target = spawn("script_model", var_e624516d.origin);
	level.teleport_target SetModel("p7_zm_asc_transformer_electrical");
	level.teleport_target.angles = var_e624516d.angles;
	var_cf61e83e = spawn("script_model", var_cf61e83e.origin);
	var_cf61e83e SetModel("tag_origin");
	var_cf61e83e.angles = var_1dc1d30a;
	PlayFXOnTag(level._effect["generator_ee_sparks"], var_cf61e83e, "tag_origin");
	level.teleport_target_trigger = spawn("trigger_radius", var_e624516d.origin + VectorScale((0, 0, -1), 70), 0, 125, 100);
	/#
		if(!isdefined(level.var_74eed1d3) || !level.var_74eed1d3)
		{
			level.teleport_target thread namespace_670cb61::function_620401c0(level.teleport_target.origin, "Dev Block strings are not supported", "Dev Block strings are not supported", 2);
		}
	#/
	level.black_hole_bomb_loc_check_func = &bhb_teleport_loc_check;
	level waittill("hash_2a49912");
	var_cf61e83e delete();
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
	var_2298d0fe = struct::get("teleport_target_end", "targetname");
	level.teleport_target ghost();
	playsoundatposition("zmb_gersh_teleporter_out", grenade.origin + VectorScale((0, 0, 1), 50));
	wait(0.5);
	level.teleport_target.angles = var_2298d0fe.angles;
	level.teleport_target moveto(var_2298d0fe.origin, 0.05);
	wait(0.5);
	level.teleport_target show();
	PlayFXOnTag(level._effect["black_hole_bomb_event_horizon"], level.teleport_target, "tag_origin");
	level.teleport_target playsound("zmb_gersh_teleporter_go");
	wait(2);
	model delete();
	level flag::set("target_teleported");
}

/*
	Name: function_6b4d4b8a
	Namespace: namespace_f23e8c1a
	Checksum: 0x89C2963C
	Offset: 0x1630
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function function_6b4d4b8a()
{
	monitor = GetEnt("casimir_monitor", "targetname");
	location = struct::get("casimir_monitor_struct", "targetname");
	monitor playsound("zmb_ee_monitor_on");
	monitor PlayLoopSound("zmb_ee_monitor_whitenoise", 1);
	monitor SetModel("p7_zm_asc_monitor_screen_on");
	trig = spawn("trigger_radius", location.origin, 0, 32, 60);
	/#
		if(!isdefined(level.var_4058a336) || !level.var_4058a336)
		{
			trig thread namespace_670cb61::function_620401c0(monitor.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
	trig function_78f34b16(monitor);
	trig delete();
	level flag::set("rerouted_power");
	monitor SetModel("p7_zm_asc_monitor_screen_logo");
	monitor PlayLoopSound("zmb_ee_monitor_active", 1);
	level thread play_egg_vox("vox_ann_egg2_success", "vox_gersh_egg2", 2);
	level thread function_55403b86(1);
}

/*
	Name: function_78f34b16
	Namespace: namespace_f23e8c1a
	Checksum: 0x12A32001
	Offset: 0x1858
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function function_78f34b16(monitor)
{
	/#
		if(isdefined(level.var_4058a336) && level.var_4058a336)
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
	Name: function_55c69e42
	Namespace: namespace_f23e8c1a
	Checksum: 0x1D34EF7C
	Offset: 0x1940
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_55c69e42()
{
	switches = struct::get_array("sync_switch_start", "targetname");
	self function_27c6e567(switches);
	level thread play_egg_vox("vox_ann_egg3_success", "vox_gersh_egg3", 3);
	level thread function_55403b86(2);
}

/*
	Name: function_27c6e567
	Namespace: namespace_f23e8c1a
	Checksum: 0x2BE59079
	Offset: 0x19D8
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function function_27c6e567(switches)
{
	/#
		if(isdefined(level.var_dc7eef87) && level.var_dc7eef87)
		{
			return;
		}
	#/
	while(!level flag::get("switches_synced"))
	{
		level flag::wait_till("monkey_round");
		Array::thread_all(switches, &function_2fee275);
		self thread function_c1215448();
		level util::waittill_either("between_round_over", "switches_synced");
	}
}

/*
	Name: function_2fee275
	Namespace: namespace_f23e8c1a
	Checksum: 0x32C79B62
	Offset: 0x1AA8
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function function_2fee275()
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
			if(!isdefined(level.var_dc7eef87) || !level.var_dc7eef87)
			{
				trig thread namespace_670cb61::function_620401c0(button.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
			}
		#/
		trig thread function_91a40788(self, button);
		level util::waittill_either("between_round_over", "switches_synced");
		/#
			if(!isdefined(level.var_dc7eef87) || !level.var_dc7eef87)
			{
				trig namespace_670cb61::function_bb831d("Dev Block strings are not supported");
			}
		#/
		trig delete();
	}
	button moveto(self.origin, time);
	wait(time);
	button delete();
}

/*
	Name: function_91a40788
	Namespace: namespace_f23e8c1a
	Checksum: 0xAC8A09A5
	Offset: 0x1D20
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function function_91a40788(ss, button)
{
	level endon("between_round_over");
	level endon("hash_589f4116");
	ss.pressed = 0;
	while(1)
	{
		self waittill("trigger", who);
		while(isPlayer(who) && who istouching(self))
		{
			if(who useButtonPressed())
			{
				level notify("hash_7dad0c40");
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
	Name: function_c1215448
	Namespace: namespace_f23e8c1a
	Checksum: 0x1DBD00F8
	Offset: 0x1E60
	Size: 0x265
	Parameters: 0
	Flags: None
*/
function function_c1215448()
{
	level endon("between_round_over");
	pressed = 0;
	switches = struct::get_array("sync_switch_start", "targetname");
	while(1)
	{
		level waittill("hash_7dad0c40");
		timeout = GetTime() + 500;
		/#
			if(isdefined(level.var_ee92e6f7) && level.var_ee92e6f7)
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
				level notify("hash_589f4116");
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
	Name: function_38cded10
	Namespace: namespace_f23e8c1a
	Checksum: 0x9326816A
	Offset: 0x20D0
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function function_38cded10()
{
	area = struct::get("pressure_pad", "targetname");
	trig = spawn("trigger_radius", area.origin, 0, 300, 100);
	n_timer = 120;
	/#
		if(isdefined(level.var_4a2af85f) && level.var_4a2af85f)
		{
			n_timer = 30;
		}
	#/
	trig function_40a71984(n_timer);
	trig delete();
	level thread play_egg_vox("vox_ann_egg4_success", "vox_gersh_egg4", 4);
	level thread function_55403b86(3);
}

/*
	Name: function_40a71984
	Namespace: namespace_f23e8c1a
	Checksum: 0x89F6BB6D
	Offset: 0x21F8
	Size: 0x5E9
	Parameters: 1
	Flags: None
*/
function function_40a71984(time)
{
	var_18687de = struct::get("pressure_timer", "targetname");
	clock = spawn("script_model", var_18687de.origin);
	clock SetModel("p7_zm_tra_wall_clock");
	clock.angles = var_18687de.angles;
	var_b07ae42e = struct::get("clock_timer_hand", "targetname");
	var_4e945c7c = VectorScale((0, 1, 0), 90);
	var_43e449d4 = util::spawn_model("p7_zm_kin_clock_second_hand", var_b07ae42e.origin, var_4e945c7c);
	/#
		if(!isdefined(level.var_c28796c3) || !level.var_c28796c3)
		{
			self thread namespace_670cb61::function_620401c0(self.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else if(isdefined(level.var_c28796c3) && level.var_c28796c3)
		{
			self thread function_1129ebfe();
		}
	#/
	step = 1;
	while(!level flag::get("pressure_sustained"))
	{
		self waittill("trigger");
		var_b8ea1afb = 0;
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] istouching(self))
			{
				wait(step);
				var_b8ea1afb = 1;
				/#
					if(isdefined(level.var_c28796c3) && level.var_c28796c3)
					{
						var_b8ea1afb = 0;
					}
				#/
			}
		}
		if(var_b8ea1afb)
		{
			continue;
		}
		self playsound("zmb_ee_pressure_plate_down");
		time_remaining = time;
		var_43e449d4 RotatePitch(-360, time);
		/#
			if(isdefined(level.var_c28796c3) && level.var_c28796c3)
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
					var_b8ea1afb = 1;
					self playsound("zmb_ee_pressure_plate_up");
					var_43e449d4 RotateTo(var_4e945c7c, 0.5);
					var_43e449d4 playsound("zmb_ee_pressure_deny");
					wait(0.5);
					break;
				}
			}
			if(var_b8ea1afb)
			{
				break;
			}
			wait(step);
			time_remaining = time_remaining - step;
			var_43e449d4 playsound("zmb_ee_pressure_timer");
		}
		if(time_remaining <= 0)
		{
			level flag::set("pressure_sustained");
			players = GetPlayers();
			var_99867264 = undefined;
			if(isdefined(players[0].FX))
			{
				var_99867264 = players[0].FX;
			}
			var_43e449d4 playsound("zmb_perks_packa_ready");
			players[0].FX = level.zombie_powerups["nuke"].FX;
			level thread zm_powerup_nuke::nuke_powerup(players[0], players[0].team);
			clock StopLoopSound(1);
			wait(1);
			if(isdefined(var_99867264))
			{
				players[0].FX = var_99867264;
			}
			else
			{
				players[0].FX = undefined;
			}
			/#
				if(!isdefined(level.var_c28796c3) || !level.var_c28796c3)
				{
					self namespace_670cb61::function_bb831d("Dev Block strings are not supported");
				}
			#/
			clock delete();
			var_43e449d4 delete();
			return;
		}
	}
}

/*
	Name: function_1129ebfe
	Namespace: namespace_f23e8c1a
	Checksum: 0x235E7242
	Offset: 0x27F0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function function_1129ebfe()
{
	/#
		wait(1);
		self notify("trigger");
	#/
}

/*
	Name: function_18c28e7b
	Namespace: namespace_f23e8c1a
	Checksum: 0x2F453967
	Offset: 0x2818
	Size: 0x343
	Parameters: 0
	Flags: None
*/
function function_18c28e7b()
{
	level flag::init("letter_acquired");
	level.var_8093285f = [];
	level.var_8093285f["lander_station1"]["lander_station3"] = "s";
	level.var_8093285f["lander_station1"]["lander_station4"] = "r";
	level.var_8093285f["lander_station1"]["lander_station5"] = "e";
	level.var_8093285f["lander_station3"]["lander_station1"] = "y";
	level.var_8093285f["lander_station3"]["lander_station4"] = "a";
	level.var_8093285f["lander_station3"]["lander_station5"] = "i";
	level.var_8093285f["lander_station4"]["lander_station1"] = "m";
	level.var_8093285f["lander_station4"]["lander_station3"] = "h";
	level.var_8093285f["lander_station4"]["lander_station5"] = "u";
	level.var_8093285f["lander_station5"]["lander_station1"] = "t";
	level.var_8093285f["lander_station5"]["lander_station3"] = "n";
	level.var_8093285f["lander_station5"]["lander_station4"] = "l";
	level.var_ce30083b = Array("l", "u", "n", "a");
	level.var_4a825f7 = 0;
	level.var_b505a146 = Array("h", "i", "t", "s", "a", "m");
	level.var_66e412e8 = 0;
	level.var_8f0326dd = Array("h", "y", "e", "n", "a");
	level.var_fd63aa69 = 0;
	level thread function_adcb2f80();
	level flag::wait_till("passkey_confirmed");
	level thread play_egg_vox("vox_ann_egg5_success", "vox_gersh_egg5", 5);
	level thread function_55403b86(4);
}

/*
	Name: function_adcb2f80
	Namespace: namespace_f23e8c1a
	Checksum: 0x64AE7ABF
	Offset: 0x2B68
	Size: 0x357
	Parameters: 0
	Flags: None
*/
function function_adcb2f80()
{
	lander = GetEnt("lander", "targetname");
	/#
		if(isdefined(level.var_c0e05145) && level.var_c0e05145)
		{
			return;
		}
		lander thread function_33078896();
	#/
	while(!level flag::get("passkey_confirmed"))
	{
		level waittill("lander_launched");
		if(lander.called)
		{
			start = lander.depart_station;
			dest = lander.station;
			letter = level.var_8093285f[start][dest];
			model = level.var_46651379[letter];
			model show();
			model playsound("zmb_spawn_powerup");
			model thread function_ac792024();
			model PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
			trig = spawn("trigger_radius", model.origin, 0, 200, 150);
			/#
				trig function_362373ab(model);
			#/
			trig thread function_172345ea(letter, model);
			level flag::wait_till("lander_grounded");
			if(!level flag::get("letter_acquired"))
			{
				function_874d06b6();
				/#
					lander thread function_33078896();
					trig thread namespace_670cb61::function_bb831d("Dev Block strings are not supported");
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
				lander thread function_33078896();
				trig thread namespace_670cb61::function_bb831d("Dev Block strings are not supported");
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
			model.origin = level.var_40705128.origin + VectorScale((0, 0, 1), 32);
			self.origin = model.origin;
		}
		self thread namespace_670cb61::function_620401c0(model.origin, "Dev Block strings are not supported", "Dev Block strings are not supported", 3);
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
		level notify("hash_eeefde1f");
	#/
	level.var_4a825f7 = 0;
	level.var_66e412e8 = 0;
	level.var_fd63aa69 = 0;
}

/*
	Name: function_33078896
	Namespace: namespace_f23e8c1a
	Checksum: 0xBE135435
	Offset: 0x3058
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function function_33078896()
{
	/#
		if(!isdefined(level.var_c0e05145) || !level.var_c0e05145)
		{
			level endon("hash_eeefde1f");
			var_1fc8b439 = Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
			for(i = 0; i < var_1fc8b439.size; i++)
			{
				level.var_40705128 = struct::get(var_1fc8b439[i], "Dev Block strings are not supported");
				level.var_40705128 thread namespace_670cb61::function_620401c0(level.var_40705128.origin, "Dev Block strings are not supported", "Dev Block strings are not supported", 3);
				self function_e07806c9(level.var_40705128);
			}
		}
	#/
}

/*
	Name: function_e07806c9
	Namespace: namespace_f23e8c1a
	Checksum: 0x272545F8
	Offset: 0x3188
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_e07806c9(var_43240065)
{
	/#
		while(self.station != var_43240065.targetname)
		{
			wait(0.25);
		}
		var_43240065 notify("hash_9465652d");
		util::wait_network_frame();
	#/
}

/*
	Name: function_ac792024
	Namespace: namespace_f23e8c1a
	Checksum: 0xFA0519E2
	Offset: 0x31E8
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_ac792024()
{
	level endon("lander_grounded");
	level endon("hash_20fb11dc");
	while(1)
	{
		self RotateYaw(90, 5);
		wait(5);
	}
}

/*
	Name: function_172345ea
	Namespace: namespace_f23e8c1a
	Checksum: 0xF16BDC23
	Offset: 0x3238
	Size: 0x1EB
	Parameters: 2
	Flags: None
*/
function function_172345ea(letter, model)
{
	level endon("lander_grounded");
	self waittill("trigger", e_player);
	level flag::set("letter_acquired");
	playsoundatposition("zmb_powerup_grabbed", model.origin);
	model ghost();
	/#
		self namespace_670cb61::function_bb831d("Dev Block strings are not supported");
	#/
	if(letter == level.var_ce30083b[level.var_4a825f7])
	{
		level.var_4a825f7++;
		if(level.var_4a825f7 == level.var_ce30083b.size)
		{
			level flag::set("passkey_confirmed");
		}
	}
	else
	{
		level.var_4a825f7 = 0;
	}
	if(letter == level.var_b505a146[level.var_66e412e8])
	{
		level.var_66e412e8++;
		if(level.var_66e412e8 == level.var_b505a146.size)
		{
			e_player playsoundtoplayer("evt_letter_pickup_secret_1", e_player);
		}
	}
	else
	{
		level.var_66e412e8 = 0;
	}
	if(letter == level.var_8f0326dd[level.var_fd63aa69])
	{
		level.var_fd63aa69++;
		if(level.var_fd63aa69 == level.var_8f0326dd.size)
		{
			e_player playsoundtoplayer("evt_letter_pickup_secret_2", e_player);
		}
	}
	else
	{
		level.var_fd63aa69 = 0;
	}
}

/*
	Name: function_6f6480bb
	Namespace: namespace_f23e8c1a
	Checksum: 0xC96906AC
	Offset: 0x3430
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function function_6f6480bb()
{
	level flag::init("thundergun_hit");
	var_c45fbbb9 = struct::get("weapon_combo_spot", "targetname");
	var_e35067d3 = spawn("script_model", var_c45fbbb9.origin);
	var_e35067d3 SetModel("tag_origin");
	FX = PlayFXOnTag(level._effect["gersh_spark"], var_e35067d3, "tag_origin");
	level.var_81ac6ac4 = spawn("trigger_radius", var_c45fbbb9.origin, 0, 50, 72);
	level.black_hole_bomb_loc_check_func = &function_184744ba;
	/#
		var_e35067d3 thread function_a0ad103c(var_c45fbbb9);
	#/
	level flag::wait_till("weapons_combined");
	level.var_81ac6ac4 delete();
	level.black_hole_bomb_loc_check_func = undefined;
	var_e35067d3 delete();
	for(i = 0; i < level.var_1999d459.size; i++)
	{
		level.var_1999d459[i] delete();
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
function function_a0ad103c(var_c45fbbb9)
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
			var_c45fbbb9 thread function_8172c64e();
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
		self thread namespace_670cb61::function_620401c0(self.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
		level flag::wait_till("Dev Block strings are not supported");
		self thread namespace_670cb61::function_bb831d("Dev Block strings are not supported");
	#/
}

/*
	Name: function_184744ba
	Namespace: namespace_f23e8c1a
	Checksum: 0xF39A4078
	Offset: 0x3728
	Size: 0x5D
	Parameters: 3
	Flags: None
*/
function function_184744ba(grenade, model, info)
{
	if(isdefined(level.var_81ac6ac4) && grenade istouching(level.var_81ac6ac4))
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
	self thread function_61f25aa1(trig);
}

/*
	Name: function_61f25aa1
	Namespace: namespace_f23e8c1a
	Checksum: 0xF5AD32C6
	Offset: 0x37F0
	Size: 0x289
	Parameters: 1
	Flags: None
*/
function function_61f25aa1(trig)
{
	self endon("death");
	self thread function_cc6ea79(trig);
	var_c45fbbb9 = struct::get("weapon_combo_spot", "targetname");
	var_68345fe = 0;
	var_83e9f930 = 0;
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			var_68345fe = 1;
			var_83e9f930 = 1;
		}
	#/
	players = GetPlayers();
	Array::thread_all(players, &function_6d87905c, self, trig, var_c45fbbb9);
	while(1)
	{
		trig waittill("damage", amount, inflictor, direction, point, type, tagName, modelName, partName, weapon);
		if(isdefined(inflictor))
		{
			if(type == "MOD_PROJECTILE" && (weapon.name == "ray_gun_upgraded" || weapon.name == "raygun_mark2_upgraded"))
			{
				var_68345fe = 1;
			}
			else if(weapon.name == "nesting_dolls" || weapon.name == "nesting_dolls_single")
			{
				var_83e9f930 = 1;
			}
			if(var_68345fe && var_83e9f930 && level flag::get("thundergun_hit"))
			{
				level flag::set("weapons_combined");
				level thread function_d0a93ec2(self, trig.origin);
				return;
			}
		}
	}
}

/*
	Name: function_6d87905c
	Namespace: namespace_f23e8c1a
	Checksum: 0xB534131B
	Offset: 0x3A88
	Size: 0x1B7
	Parameters: 3
	Flags: None
*/
function function_6d87905c(model, trig, var_c45fbbb9)
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
		var_ca8d49bb = self GetCurrentWeapon();
		if(var_ca8d49bb.name == "thundergun_upgraded")
		{
			if(DistanceSquared(self.origin, var_c45fbbb9.origin) < 90000)
			{
				var_a9399ec7 = VectorNormalize(var_c45fbbb9.origin - self GetWeaponMuzzlePoint());
				var_8e3e37c9 = self GetWeaponForwardDir();
				angle_diff = ACos(VectorDot(var_a9399ec7, var_8e3e37c9));
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
	Name: function_cc6ea79
	Namespace: namespace_f23e8c1a
	Checksum: 0x9A59AA6E
	Offset: 0x3CB0
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function function_cc6ea79(trig)
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
	Name: function_d0a93ec2
	Namespace: namespace_f23e8c1a
	Checksum: 0xCA277015
	Offset: 0x3DB8
	Size: 0x17B
	Parameters: 2
	Flags: None
*/
function function_d0a93ec2(model, origin)
{
	soul = spawn("script_model", origin);
	soul SetModel("tag_origin");
	soul PlayLoopSound("zmb_egg_soul");
	FX = PlayFXOnTag(level._effect["gersh_spark"], soul, "tag_origin");
	time = 20;
	model waittill("death");
	level thread play_egg_vox("vox_ann_egg6_success", "vox_gersh_egg6_success", 9);
	level thread function_944c8cd2();
	soul MoveZ(2500, time, time - 1);
	wait(time);
	soul delete();
	wait(2);
	level thread function_28a46c0d();
}

/*
	Name: function_944c8cd2
	Namespace: namespace_f23e8c1a
	Checksum: 0xEEBAFA53
	Offset: 0x3F40
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function function_944c8cd2()
{
	wait(12.5);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread function_467428d0();
	}
}

/*
	Name: function_467428d0
	Namespace: namespace_f23e8c1a
	Checksum: 0x10D4E2A3
	Offset: 0x3FB8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_467428d0()
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
function play_egg_vox(var_d6e54e9f, var_1bb1a809, var_2c0c1edc)
{
	if(isdefined(var_d6e54e9f))
	{
		level namespace_9dd378ec::play_cosmo_announcer_vox(var_d6e54e9f);
	}
	if(isdefined(var_2c0c1edc) && !isdefined(level.var_92ed253c))
	{
		players = GetPlayers();
		rand = randomIntRange(0, players.size);
		players[rand] PlaySoundWithNotify("vox_plr_" + players[rand].characterindex + "_level_start_" + randomIntRange(0, 4), "level_start_vox_done");
		players[rand] waittill("hash_200a4e11");
		level.var_92ed253c = 1;
	}
	if(isdefined(var_1bb1a809))
	{
		level namespace_9dd378ec::function_524d0ceb(var_1bb1a809);
	}
	if(isdefined(var_2c0c1edc))
	{
		players = GetPlayers();
		rand = randomIntRange(0, players.size);
		players[rand] zm_audio::create_and_play_dialog("eggs", "gersh_response", var_2c0c1edc);
	}
}

/*
	Name: function_28a46c0d
	Namespace: namespace_f23e8c1a
	Checksum: 0x2F0A3798
	Offset: 0x4240
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_28a46c0d()
{
	playsoundatposition("zmb_samantha_earthquake", (0, 0, 0));
	playsoundatposition("zmb_samantha_whispers", (0, 0, 0));
	wait(6);
	level clientfield::set("COSMO_EGG_SAM_ANGRY", 1);
	playsoundatposition("zmb_samantha_scream", (0, 0, 0));
	wait(6);
	level clientfield::set("COSMO_EGG_SAM_ANGRY", 0);
}

