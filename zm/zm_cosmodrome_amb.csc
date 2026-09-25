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
	level thread function_236ee1ee();
	level thread function_ddc1ee89();
	level thread spawn_fx_loopers();
	level thread play_minigun_loop();
	level thread function_be596677();
	level thread function_d19cb2f8();
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
	Name: function_236ee1ee
	Namespace: namespace_9dd378ec
	Checksum: 0xD624FA65
	Offset: 0x768
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function function_236ee1ee()
{
	level waittill("power_on");
	wait(2.5);
	level thread function_d2ed7980();
	wait(21);
	level notify("hash_78527d76");
}

/*
	Name: function_ddc1ee89
	Namespace: namespace_9dd378ec
	Checksum: 0xB3CE7329
	Offset: 0x7B0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_ddc1ee89()
{
	level waittill("power_on");
	wait(8.5);
	level thread function_44f4e8bb();
}

/*
	Name: function_90cfe8c5
	Namespace: namespace_9dd378ec
	Checksum: 0x5339836D
	Offset: 0x7E8
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_90cfe8c5()
{
	level endon("hash_78527d76");
	while(1)
	{
		playsound(0, "evt_alarm_a", self.origin);
		wait(1.1);
	}
}

/*
	Name: function_b6d2632e
	Namespace: namespace_9dd378ec
	Checksum: 0x86B13FFF
	Offset: 0x838
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_b6d2632e()
{
	var_11935664 = spawn(0, self.origin, "script.origin");
	var_11935664.var_1875fe27 = var_11935664 PlayLoopSound("evt_alarm_b_loop", 0.8);
	wait(8.8);
	playsound(0, "evt_alarm_b_end", self.origin);
	wait(0.1);
	var_11935664 StopLoopSound(var_11935664.var_1875fe27, 0.6);
	wait(3);
	var_11935664 delete();
}

/*
	Name: function_d2ed7980
	Namespace: namespace_9dd378ec
	Checksum: 0xA32D8B73
	Offset: 0x928
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_d2ed7980()
{
	Array::thread_all(struct::get_array("amb_warning_siren", "targetname"), &function_90cfe8c5);
}

/*
	Name: function_44f4e8bb
	Namespace: namespace_9dd378ec
	Checksum: 0x66645AD2
	Offset: 0x978
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_44f4e8bb()
{
	Array::thread_all(struct::get_array("amb_warning_bell", "targetname"), &function_b6d2632e);
}

/*
	Name: function_7179c1c9
	Namespace: namespace_9dd378ec
	Checksum: 0x7C7CA3C0
	Offset: 0x9C8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_7179c1c9()
{
	wait(2);
	playsound(0, "amb_vox_rus_PA", self.origin);
}

/*
	Name: function_84e46cfe
	Namespace: namespace_9dd378ec
	Checksum: 0xD47EEF
	Offset: 0xA00
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function function_84e46cfe(localClientNum)
{
	player = GetLocalPlayers()[localClientNum];
	audio::snd_set_snapshot("zmb_samantha_scream");
	player Earthquake(0.4, 10, player.origin, 150);
	visionset_mgr::fog_vol_to_visionset_set_suffix("_nopower");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 2.5);
	player thread function_7c49fd5a();
	wait(6);
	audio::snd_set_snapshot("default");
	visionset_mgr::fog_vol_to_visionset_set_suffix("_poweron");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 2.5);
}

/*
	Name: function_7c49fd5a
	Namespace: namespace_9dd378ec
	Checksum: 0x6C6E64EE
	Offset: 0xB40
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function function_7c49fd5a()
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
	level.var_6d9d81aa = "mus_cosmo_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_cosmo_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
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
function function_b234849(var_6d9d81aa)
{
	level endon("hash_51d7bc7c");
	level.var_eb526c90 StopAllLoopSounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(var_6d9d81aa, 2);
}

/*
	Name: function_be596677
	Namespace: namespace_9dd378ec
	Checksum: 0xECBACCD2
	Offset: 0xE50
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function function_be596677()
{
	wait(2);
	level.var_41176517 = struct::get_array("amb_computer", "targetname");
	level waittill("power_on");
	level.var_39f6798 = struct::get("amb_power_up", "targetname");
	if(isdefined(level.var_39f6798))
	{
		playsound(0, level.var_39f6798.script_sound, level.var_39f6798.origin);
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
	level notify("hash_562bd5c4");
	level thread function_729f3d20();
	if(isdefined(level.var_39f6798))
	{
		audio::playloopat("evt_power_loop", level.var_39f6798.origin);
	}
}

/*
	Name: function_729f3d20
	Namespace: namespace_9dd378ec
	Checksum: 0xF3E15566
	Offset: 0x1008
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function function_729f3d20()
{
	level.var_9a2181e2 = struct::get_array("amb_power_surge", "targetname");
	for(i = 0; i < level.var_9a2181e2.size; i++)
	{
		audio::playloopat(level.var_9a2181e2[i].script_sound, level.var_9a2181e2[i].origin);
	}
}

/*
	Name: function_d19cb2f8
	Namespace: namespace_9dd378ec
	Checksum: 0x2D3AC81F
	Offset: 0x10A8
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

