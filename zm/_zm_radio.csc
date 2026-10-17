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
		Assert(isdefined(level.n_radio_id));
	#/
	/#
		Assert(isdefined(level.a_radio_songs));
	#/
	/#
		Assert(isdefined(level.n_radio_index));
	#/
	/#
		Assert(level.a_radio_songs.size > 0);
	#/
	if(!isdefined(level.b_stop_radio))
	{
		level.b_stop_radio = 0;
	}
	if(!level.b_stop_radio)
	{
		if(newVal)
		{
			playsound(0, "static", self.origin);
			if(SoundPlaying(level.n_radio_id))
			{
				Fade(level.n_radio_id, 1);
			}
			else
			{
				wait(0.5);
			}
			if(level.n_radio_index < level.a_radio_songs.size)
			{
				/#
					println("Dev Block strings are not supported" + level.a_radio_songs[level.n_radio_index]);
				#/
				level.n_radio_id = playsound(0, level.a_radio_songs[level.n_radio_index], self.origin);
			}
			else
			{
				return;
			}
		}
	}
	else if(isdefined(level.n_radio_id))
	{
		stopSound(level.n_radio_id);
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
	if(!isdefined(level.a_radio_songs))
	{
		level.a_radio_songs = [];
	}
	level.a_radio_songs[level.a_radio_songs.size] = SONG;
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
		Assert(isdefined(level.n_radio_index));
	#/
	level.n_radio_index = newVal;
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
		level.b_stop_radio = 1;
		level thread next_song();
		level waittill("rrd");
		level.b_stop_radio = 0;
		wait(0.5);
	}
}

