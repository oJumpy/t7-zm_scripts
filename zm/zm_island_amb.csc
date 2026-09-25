#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace namespace_f67badb7;

/*
	Name: main
	Namespace: namespace_f67badb7
	Checksum: 0x1374C0A9
	Offset: 0x320
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function main()
{
	thread function_d19cb2f8();
	thread function_d1abcaef();
	thread function_bab3ea62();
}

/*
	Name: function_d1abcaef
	Namespace: namespace_f67badb7
	Checksum: 0xFD1505AD
	Offset: 0x360
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_d1abcaef()
{
	audio::playloopat("zmb_meteor_site_loop", (3222, 2237, -599));
}

/*
	Name: function_d19cb2f8
	Namespace: namespace_f67badb7
	Checksum: 0xBE775534
	Offset: 0x398
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
	Namespace: namespace_f67badb7
	Checksum: 0xE949B689
	Offset: 0x500
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
	Namespace: namespace_f67badb7
	Checksum: 0x5C8C598
	Offset: 0x678
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_bab3ea62()
{
	wait(3);
	level.var_65d981dd = "spider_lair_active";
	level.var_2d9f200e = "takeo_battle_inactive";
	level thread function_ab8dfbdf();
	level thread function_17e798e9();
	level thread function_7a83b09a();
	level thread function_610a705b();
	level thread function_53b9afad();
	var_29085ef = GetEntArray(0, "sndMusicTrig", "targetname");
	Array::thread_all(var_29085ef, &function_95d61fc1);
}

/*
	Name: function_95d61fc1
	Namespace: namespace_f67badb7
	Checksum: 0x51B0DF74
	Offset: 0x780
	Size: 0xF3
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
			if(self.script_sound == "spider_lair")
			{
				level notify("hash_51d7bc7c", level.var_65d981dd);
				continue;
			}
			if(self.script_sound == "takeo")
			{
				level notify("hash_51d7bc7c", level.var_2d9f200e);
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
	Namespace: namespace_f67badb7
	Checksum: 0x2C14FDE8
	Offset: 0x880
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function function_53b9afad()
{
	level.var_b6342abd = "mus_island_underscore_outdoor";
	level.var_6d9d81aa = "mus_island_underscore_outdoor";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_island_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_51d7bc7c(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: namespace_f67badb7
	Checksum: 0xFDA86F04
	Offset: 0x980
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
	Name: function_ab8dfbdf
	Namespace: namespace_f67badb7
	Checksum: 0x3AE69385
	Offset: 0x9F0
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function function_ab8dfbdf()
{
	level waittill("hash_30cde396");
	level.var_65d981dd = "spider_lair_inactive";
	if(level.var_b6342abd == "mus_island_underscore_spider_lair_active")
	{
		level notify("hash_51d7bc7c", level.var_65d981dd);
	}
}

/*
	Name: function_17e798e9
	Namespace: namespace_f67badb7
	Checksum: 0x59FC5B2
	Offset: 0xA48
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function function_17e798e9()
{
	level endon("hash_c535f9f1");
	level waittill("hash_b0bea12a");
	level.var_2d9f200e = "takeo_battle_active";
	if(level.var_b6342abd == "mus_island_underscore_takeo_battle_inactive")
	{
		level notify("hash_51d7bc7c", level.var_2d9f200e);
	}
}

/*
	Name: function_7a83b09a
	Namespace: namespace_f67badb7
	Checksum: 0x2A0F20F9
	Offset: 0xAA8
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function function_7a83b09a()
{
	level waittill("hash_c535f9f1");
	level.var_2d9f200e = "takeo_battle_over";
	if(level.var_b6342abd == "mus_island_underscore_takeo_battle_active")
	{
		level notify("hash_51d7bc7c", level.var_2d9f200e);
	}
}

/*
	Name: function_610a705b
	Namespace: namespace_f67badb7
	Checksum: 0x34F13ABB
	Offset: 0xB00
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function function_610a705b()
{
	while(1)
	{
		level waittill("hash_9c487e8b");
		level notify("hash_51d7bc7c", level.var_2d9f200e);
	}
}

