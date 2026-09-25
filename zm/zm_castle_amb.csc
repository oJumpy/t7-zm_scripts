#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace namespace_77c14780;

/*
	Name: main
	Namespace: namespace_77c14780
	Checksum: 0x8A20538A
	Offset: 0x238
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function main()
{
	thread function_d19cb2f8();
	thread function_163d3651();
	thread function_509ffc62();
	level thread function_bab3ea62();
}

/*
	Name: function_d19cb2f8
	Namespace: namespace_77c14780
	Checksum: 0x793F76CD
	Offset: 0x290
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
	Namespace: namespace_77c14780
	Checksum: 0x54ED277A
	Offset: 0x3F8
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
	Name: function_163d3651
	Namespace: namespace_77c14780
	Checksum: 0x97737954
	Offset: 0x570
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_163d3651()
{
	soundloopemitter("zmb_spawn_undercroft_walla", (-508, 1615, 110));
	soundloopemitter("zmb_spawn_undercroft_walla", (607, 2189, 162));
	soundloopemitter("zmb_spawn_undercroft_walla", (-1771, 1924, 235));
	soundloopemitter("zmb_spawn_undercroft_walla", (-1730, 2565, 227));
	soundloopemitter("zmb_spawn_undercroft_walla", (-828, 2911, 261));
}

/*
	Name: function_509ffc62
	Namespace: namespace_77c14780
	Checksum: 0x32C06AA6
	Offset: 0x648
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_509ffc62()
{
	soundloopemitter("amb_radio_2", (-1080, 1625, 856));
	soundloopemitter("amb_radio_beep", (-1006, 1578, 856));
	soundloopemitter("amb_radio_3", (-1365, 1332, 856));
}

/*
	Name: function_bab3ea62
	Namespace: namespace_77c14780
	Checksum: 0x853C7F2A
	Offset: 0x6D0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_bab3ea62()
{
	wait(3);
	level thread function_53b9afad();
	var_29085ef = GetEntArray(0, "sndMusicTrig", "targetname");
	Array::thread_all(var_29085ef, &function_95d61fc1);
}

/*
	Name: function_95d61fc1
	Namespace: namespace_77c14780
	Checksum: 0xA4F71712
	Offset: 0x750
	Size: 0x93
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
	Namespace: namespace_77c14780
	Checksum: 0x766FDE2D
	Offset: 0x7F0
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function function_53b9afad()
{
	var_b6342abd = "mus_castle_underscore_gondola";
	var_6d9d81aa = "mus_castle_underscore_gondola";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		var_6d9d81aa = "mus_castle_underscore_" + location;
		if(var_6d9d81aa != var_b6342abd)
		{
			level thread function_51d7bc7c(var_6d9d81aa);
			var_b6342abd = var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: namespace_77c14780
	Checksum: 0xC60DC07C
	Offset: 0x8E0
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

