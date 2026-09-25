#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace namespace_db83306f;

/*
	Name: main
	Namespace: namespace_db83306f
	Checksum: 0xD0A1CD81
	Offset: 0x348
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function main()
{
	thread function_d19cb2f8();
	level thread function_bab3ea62();
	level thread function_b21d9845();
	level thread function_d4a3f122();
	level thread function_daa9b420();
	level thread play_flux_whispers();
	level thread function_157aa38();
	level thread function_1e68a892();
}

/*
	Name: function_d19cb2f8
	Namespace: namespace_db83306f
	Checksum: 0x89D2D487
	Offset: 0x410
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
	Namespace: namespace_db83306f
	Checksum: 0xC55634
	Offset: 0x578
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

/*
	Name: function_bab3ea62
	Namespace: namespace_db83306f
	Checksum: 0xC6172F94
	Offset: 0x6F0
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_bab3ea62()
{
	wait(3);
	level.var_98f2b64e = "pavlov";
	level thread function_8620d917();
	level thread function_53b9afad();
	var_29085ef = GetEntArray(0, "sndMusicTrig", "targetname");
	Array::thread_all(var_29085ef, &function_95d61fc1);
}

/*
	Name: function_95d61fc1
	Namespace: namespace_db83306f
	Checksum: 0xED5900C3
	Offset: 0x7A0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_95d61fc1()
{
	while(1)
	{
		self waittill("trigger", trigPlayer);
		if(trigPlayer isLocalPlayer())
		{
			if(self.script_sound == "pavlov")
			{
				level notify("hash_51d7bc7c", level.var_98f2b64e);
				continue;
			}
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
	Name: function_53b9afad
	Namespace: namespace_db83306f
	Checksum: 0x7AA98EF6
	Offset: 0x870
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function function_53b9afad()
{
	level.var_b6342abd = "mus_stalingrad_underscore_outdoor";
	level.var_6d9d81aa = "mus_stalingrad_underscore_outdoor";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_stalingrad_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_51d7bc7c(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: namespace_db83306f
	Checksum: 0x72365AF7
	Offset: 0x970
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_51d7bc7c(var_6d9d81aa)
{
	level endon("hash_51d7bc7c");
	level.var_eb526c90 StopAllLoopSounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(var_6d9d81aa, 2);
}

/*
	Name: function_8620d917
	Namespace: namespace_db83306f
	Checksum: 0x78556F5D
	Offset: 0x9E0
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_8620d917()
{
	while(1)
	{
		level waittill("hash_8874917e");
		if(level.var_98f2b64e == "pavlov")
		{
			level.var_98f2b64e = "pavlov_defend";
		}
		else
		{
			level.var_98f2b64e = "pavlov";
		}
		if(level.var_b6342abd == "mus_stalingrad_underscore_pavlov" || level.var_b6342abd == "mus_stalingrad_underscore_pavlov_defend")
		{
			level notify("hash_51d7bc7c", level.var_98f2b64e);
		}
	}
}

/*
	Name: function_a2a905a5
	Namespace: namespace_db83306f
	Checksum: 0x97848EA6
	Offset: 0xA80
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_a2a905a5()
{
	while(1)
	{
		level waittill("hash_c9bd87a8");
		if(level.var_98f2b64e == "pavlov" || level.var_98f2b64e == "pavlov_defend")
		{
			level.var_98f2b64e = "pavlov_ee_koth";
		}
		if(level.var_b6342abd == "mus_stalingrad_underscore_pavlov" || level.var_b6342abd == "mus_stalingrad_underscore_pavlov_defend")
		{
			level notify("hash_51d7bc7c", level.var_98f2b64e);
		}
	}
}

/*
	Name: function_b21d9845
	Namespace: namespace_db83306f
	Checksum: 0xAE4659F4
	Offset: 0xB20
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_b21d9845()
{
	while(1)
	{
		wait(randomIntRange(4, 10));
		playsound(0, "amb_comp_sweets", (-3157, 21574, -85));
	}
}

/*
	Name: function_d4a3f122
	Namespace: namespace_db83306f
	Checksum: 0x71F66D34
	Offset: 0xB78
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_d4a3f122()
{
	audio::playloopat("amb_creepy_machine_loops", (-3271, 21733, -86));
	audio::playloopat("amb_creepy_machine_loops", (-3078, 22000, -108));
	audio::playloopat("amb_creepy_machine_loops", (-2765, 21978, -106));
}

/*
	Name: function_daa9b420
	Namespace: namespace_db83306f
	Checksum: 0xF600DD06
	Offset: 0xC00
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_daa9b420()
{
	while(1)
	{
		wait(randomIntRange(10, 40));
		playsound(0, "amb_banging", (-3319, 21151, -103));
	}
}

/*
	Name: play_flux_whispers
	Namespace: namespace_db83306f
	Checksum: 0xDAD07F90
	Offset: 0xC58
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function play_flux_whispers()
{
	while(1)
	{
		wait(randomIntRange(4, 10));
		playsound(0, "amb_whispers", (-3414, 21402, 63));
		playsound(0, "amb_whispers", (-2639, 21161, -90));
		playsound(0, "amb_whispers", (-3004, 22547, 44));
	}
}

/*
	Name: function_157aa38
	Namespace: namespace_db83306f
	Checksum: 0x89A7976E
	Offset: 0xD00
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_157aa38()
{
	level waittill("hash_bad0de07");
	playsound(0, "amb_sophia_boot", (300, 4862, 296));
	audio::playloopat("amb_sophia_computer_screen_lp", (-404, 4764, 223));
	wait(8);
	audio::playloopat("amb_sophia_loop", (300, 4862, 296));
}

/*
	Name: function_1e68a892
	Namespace: namespace_db83306f
	Checksum: 0xAAF6B4F3
	Offset: 0xDA0
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_1e68a892()
{
	while(1)
	{
		wait(randomIntRange(1, 2));
		playsound(0, "amb_light_flicker_flour", (-2956, 21337, 125));
		playsound(0, "amb_light_flicker_flour", (-3037, 21457, -39));
		playsound(0, "amb_light_flicker_flour", (-3223, 21912, -47));
	}
}

