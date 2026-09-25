#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace namespace_c3257ae1;

/*
	Name: main
	Namespace: namespace_c3257ae1
	Checksum: 0x93CA3E02
	Offset: 0x1D0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread function_bab3ea62();
}

/*
	Name: function_bab3ea62
	Namespace: namespace_c3257ae1
	Checksum: 0x9B5E5B47
	Offset: 0x1F8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_bab3ea62()
{
	level thread function_53b9afad();
	var_29085ef = GetEntArray(0, "sndMusicTrig", "targetname");
	Array::thread_all(var_29085ef, &function_95d61fc1);
}

/*
	Name: function_95d61fc1
	Namespace: namespace_c3257ae1
	Checksum: 0xB9F418FE
	Offset: 0x278
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
	Namespace: namespace_c3257ae1
	Checksum: 0x64BBB2D
	Offset: 0x318
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function function_53b9afad()
{
	var_b6342abd = "mus_zod_underscore_default";
	var_6d9d81aa = "mus_zod_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		var_6d9d81aa = "mus_zod_underscore_" + location;
		if(var_6d9d81aa != var_b6342abd)
		{
			level thread function_51d7bc7c(var_6d9d81aa);
			var_b6342abd = var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: namespace_c3257ae1
	Checksum: 0xE9EF3E6D
	Offset: 0x408
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

