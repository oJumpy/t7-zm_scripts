#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace namespace_5c41055a;

/*
	Name: __init__sytem__
	Namespace: namespace_5c41055a
	Checksum: 0x34D61513
	Offset: 0xC0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_radio", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_5c41055a
	Checksum: 0x99EC1590
	Offset: 0x108
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: namespace_5c41055a
	Checksum: 0x99EC1590
	Offset: 0x118
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: next_song
	Namespace: namespace_5c41055a
	Checksum: 0xFC1C1880
	Offset: 0x128
	Size: 0x203
	Parameters: 7
	Flags: None
*/
function next_song(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	/#
		Assert(isdefined(level.var_f3006fa7));
	#/
	/#
		Assert(isdefined(level.var_c017e2d5));
	#/
	/#
		Assert(isdefined(level.var_ce7032d4));
	#/
	/#
		Assert(level.var_c017e2d5.size > 0);
	#/
	if(!isdefined(level.var_58522184))
	{
		level.var_58522184 = 0;
	}
	if(!level.var_58522184)
	{
		if(newVal)
		{
			playsound(0, "static", self.origin);
			if(SoundPlaying(level.var_f3006fa7))
			{
				Fade(level.var_f3006fa7, 1);
			}
			else
			{
				wait(0.5);
			}
			if(level.var_ce7032d4 < level.var_c017e2d5.size)
			{
				/#
					println("Dev Block strings are not supported" + level.var_c017e2d5[level.var_ce7032d4]);
				#/
				level.var_f3006fa7 = playsound(0, level.var_c017e2d5[level.var_ce7032d4], self.origin);
			}
			else
			{
				return;
			}
		}
	}
	else if(isdefined(level.var_f3006fa7))
	{
		stopSound(level.var_f3006fa7);
	}
}

/*
	Name: add_song
	Namespace: namespace_5c41055a
	Checksum: 0xC0B64FA8
	Offset: 0x338
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function add_song(SONG)
{
	if(!isdefined(level.var_c017e2d5))
	{
		level.var_c017e2d5 = [];
	}
	level.var_c017e2d5[level.var_c017e2d5.size] = SONG;
}

/*
	Name: function_2b7f281d
	Namespace: namespace_5c41055a
	Checksum: 0x56136C60
	Offset: 0x380
	Size: 0x67
	Parameters: 7
	Flags: None
*/
function function_2b7f281d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	/#
		Assert(isdefined(level.var_ce7032d4));
	#/
	level.var_ce7032d4 = newVal;
}

/*
	Name: Fade
	Namespace: namespace_5c41055a
	Checksum: 0x8F27EAAD
	Offset: 0x3F0
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function Fade(n_id, n_time)
{
	n_rate = 0;
	if(n_time != 0)
	{
		n_rate = 1 / n_time;
	}
	setSoundVolumeRate(n_id, n_rate);
	setSoundVolume(n_id, 0);
	wait(n_time);
	stopSound(n_id);
}

/*
	Name: stop_radio_listener
	Namespace: namespace_5c41055a
	Checksum: 0xF662EBAB
	Offset: 0x498
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function stop_radio_listener()
{
	while(1)
	{
		level waittill("ktr");
		level.var_58522184 = 1;
		level thread next_song();
		level waittill("rrd");
		level.var_58522184 = 0;
		wait(0.5);
	}
}

