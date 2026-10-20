#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;

#namespace namespace_9dd378ec;

/*
	Name: main
	Namespace: namespace_9dd378ec
	Checksum: 0xFE225B40
	Offset: 0x438
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread alarm_a_timer();
	level thread alarm_b_timer();
	level thread spawn_fx_loopers();
	level thread play_minigun_loop();
	level thread amb_power_up();
	level thread startzmbspawnersoundloops();
	level thread function_c9207335();
}

/*
	Name: spawn_fx_loopers
	Namespace: namespace_9dd378ec
	Checksum: 0x80614AD8
	Offset: 0x4F0
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function spawn_fx_loopers()
{
	audio::snd_play_auto_fx("fx_fire_line_xsm", "amb_fire_medium");
	audio::snd_play_auto_fx("fx_fire_line_sm", "amb_fire_large");
	audio::snd_play_auto_fx("fx_fire_wall_back_sm", "amb_fire_large");
	audio::snd_play_auto_fx("fx_fire_destruction_lg", "amb_fire_extreme");
	audio::snd_play_auto_fx("fx_zmb_fire_sm_smolder", "amb_fire_medium");
	audio::snd_play_auto_fx("fx_elec_terminal", "amb_break_arc");
	audio::snd_play_auto_fx("fx_zmb_elec_terminal_bridge", "amb_break_arc");
	audio::snd_play_auto_fx("fx_zmb_pipe_steam_md", "amb_steam_medium");
	audio::snd_play_auto_fx("fx_zmb_pipe_steam_md_runner", "amb_steam_medium");
	audio::snd_play_auto_fx("fx_zmb_steam_hallway_md", "amb_steam_medium");
	audio::snd_play_auto_fx("fx_zmb_water_spray_leak_sm", "amb_water_spray_small");
	audio::playloopat("amb_secret_truck_iseverything", (-1419, 1506, -124));
}

/*
	Name: play_minigun_loop
	Namespace: namespace_9dd378ec
	Checksum: 0x1C0A880
	Offset: 0x688
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function play_minigun_loop()
{
	while(1)
	{
		level waittill("minis");
		ent = spawn(0, (0, 0, 0), "script_origin");
		ent PlayLoopSound("zmb_insta_kill_loop");
		level waittill("minie");
		playsound(0, "zmb_insta_kill", (0, 0, 0));
		ent StopLoopSound(0.5);
		wait(0.5);
		ent delete();
	}
}

/*
	Name: alarm_a_timer
	Namespace: namespace_9dd378ec
	Checksum: 0xD624FA65
	Offset: 0x768
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function alarm_a_timer()
{
	level waittill("power_on");
	wait(2.5);
	level thread alarm_a();
	wait(21);
	level notify("alarm_a_off");
}

/*
	Name: alarm_b_timer
	Namespace: namespace_9dd378ec
	Checksum: 0xB3CE7329
	Offset: 0x7B0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function alarm_b_timer()
{
	level waittill("power_on");
	wait(8.5);
	level thread alarm_b();
}

/*
	Name: play_alarm_a
	Namespace: namespace_9dd378ec
	Checksum: 0x5339836D
	Offset: 0x7E8
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function play_alarm_a()
{
	level endon("alarm_a_off");
	while(1)
	{
		playsound(0, "evt_alarm_a", self.origin);
		wait(1.1);
	}
}

/*
	Name: play_alarm_b
	Namespace: namespace_9dd378ec
	Checksum: 0x86B13FFF
	Offset: 0x838
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function play_alarm_b()
{
	alarm_bell = spawn(0, self.origin, "script.origin");
	alarm_bell.n_snd_id = alarm_bell PlayLoopSound("evt_alarm_b_loop", 0.8);
	wait(8.8);
	playsound(0, "evt_alarm_b_end", self.origin);
	wait(0.1);
	alarm_bell StopLoopSound(alarm_bell.n_snd_id, 0.6);
	wait(3);
	alarm_bell delete();
}

/*
	Name: alarm_a
	Namespace: namespace_9dd378ec
	Checksum: 0xA32D8B73
	Offset: 0x928
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function alarm_a()
{
	Array::thread_all(struct::get_array("amb_warning_siren", "targetname"), &play_alarm_a);
}

/*
	Name: alarm_b
	Namespace: namespace_9dd378ec
	Checksum: 0x66645AD2
	Offset: 0x978
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function alarm_b()
{
	Array::thread_all(struct::get_array("amb_warning_bell", "targetname"), &play_alarm_b);
}

/*
	Name: play_pa_vox
	Namespace: namespace_9dd378ec
	Checksum: 0x7C7CA3C0
	Offset: 0x9C8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function play_pa_vox()
{
	wait(2);
	playsound(0, "amb_vox_rus_PA", self.origin);
}

/*
	Name: samantha_is_angry_earthquake_and_rumbles
	Namespace: namespace_9dd378ec
	Checksum: 0xD47EEF
	Offset: 0xA00
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function samantha_is_angry_earthquake_and_rumbles(localClientNum)
{
	player = GetLocalPlayers()[localClientNum];
	audio::snd_set_snapshot("zmb_samantha_scream");
	player Earthquake(0.4, 10, player.origin, 150);
	visionset_mgr::fog_vol_to_visionset_set_suffix("_nopower");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 2.5);
	player thread do_that_sam_rumble();
	wait(6);
	audio::snd_set_snapshot("default");
	visionset_mgr::fog_vol_to_visionset_set_suffix("_poweron");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 2.5);
}

/*
	Name: do_that_sam_rumble
	Namespace: namespace_9dd378ec
	Checksum: 0x6C6E64EE
	Offset: 0xB40
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function do_that_sam_rumble()
{
	self endon("disconnect");
	for(count = 0; count <= 4 && isdefined(self);  = 0)
	{
		self PlayRumbleOnEntity(0, "damage_heavy");
		wait(0.1);
	}
}

/*
	Name: function_c9207335
	Namespace: namespace_9dd378ec
	Checksum: 0xB4BD17E2
	Offset: 0xBC0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_c9207335()
{
	wait(3);
	level thread function_d667714e();
	var_13a52dfe = GetEntArray(0, "sndMusicTrig", "targetname");
	Array::thread_all(var_13a52dfe, &function_60a32834);
}

/*
	Name: function_60a32834
	Namespace: namespace_9dd378ec
	Checksum: 0x7F3C610A
	Offset: 0xC40
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_60a32834()
{
	while(1)
	{
		self waittill("trigger", trigPlayer);
		if(trigPlayer isLocalPlayer())
		{
			level notify("hash_51d7bc7c", self.script_sound);
			while(isdefined(trigPlayer) && trigPlayer istouching(self))
			{
				wait(0.016);
			}
		}
		else
		{
			wait(0.016);
		}
	}
}

/*
	Name: function_d667714e
	Namespace: namespace_9dd378ec
	Checksum: 0x70431B36
	Offset: 0xCE0
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_cosmo_underscore_default";
	level.newmus = "mus_cosmo_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.newmus = "mus_cosmo_underscore_" + location;
		if(level.newmus != level.var_b6342abd)
		{
			level thread function_b234849(level.newmus);
			level.var_b6342abd = level.newmus;
		}
	}
}

/*
	Name: function_b234849
	Namespace: namespace_9dd378ec
	Checksum: 0xA3B29F2
	Offset: 0xDE0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_b234849(newmus)
{
	level endon("hash_51d7bc7c");
	level.var_eb526c90 StopAllLoopSounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(newmus, 2);
}

/*
	Name: amb_power_up
	Namespace: namespace_9dd378ec
	Checksum: 0xECBACCD2
	Offset: 0xE50
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function amb_power_up()
{
	wait(2);
	level.var_41176517 = struct::get_array("amb_computer", "targetname");
	level waittill("power_on");
	level.power_struct = struct::get("amb_power_up", "targetname");
	if(isdefined(level.power_struct))
	{
		playsound(0, level.power_struct.script_sound, level.power_struct.origin);
	}
	wait(4);
	if(isdefined(level.var_41176517))
	{
		for(i = 0; i < level.var_41176517.size; i++)
		{
			wait(RandomFloatRange(0.1, 0.25));
			playsound(0, level.var_41176517[i].script_soundalias, level.var_41176517[i].origin);
		}
	}
	level notify("snd_power_on");
	level thread play_hum();
	if(isdefined(level.power_struct))
	{
		audio::playloopat("evt_power_loop", level.power_struct.origin);
	}
}

/*
	Name: play_hum
	Namespace: namespace_9dd378ec
	Checksum: 0xF3E15566
	Offset: 0x1008
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function play_hum()
{
	level.var_9a2181e2 = struct::get_array("amb_power_surge", "targetname");
	for(i = 0; i < level.var_9a2181e2.size; i++)
	{
		audio::playloopat(level.var_9a2181e2[i].script_sound, level.var_9a2181e2[i].origin);
	}
}

/*
	Name: startzmbspawnersoundloops
	Namespace: namespace_9dd378ec
	Checksum: 0x2D3AC81F
	Offset: 0x10A8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function startzmbspawnersoundloops()
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
	Namespace: namespace_9dd378ec
	Checksum: 0x8109C1DE
	Offset: 0x1210
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

