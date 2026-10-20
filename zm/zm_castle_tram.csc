#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace zm_castle_tram;

/*
	Name: __init__sytem__
	Namespace: zm_castle_tram
	Checksum: 0xB3D00FDF
	Offset: 0x278
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_tram", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_tram
	Checksum: 0xE0202E89
	Offset: 0x2B8
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["tram_fuse_destroy"] = "dlc1/castle/fx_glow_115_fuse_burst_castle";
	level._effect["tram_fuse_fx"] = "dlc1/castle/fx_glow_115_fuse_castle";
	clientfield::register("scriptmover", "tram_fuse_destroy", 1, 1, "counter", &tram_fuse_destroy, 0, 0);
	clientfield::register("scriptmover", "tram_fuse_fx", 1, 1, "counter", &tram_fuse_fx_callback, 0, 0);
	clientfield::register("scriptmover", "cleanup_dynents", 1, 1, "counter", &remove_dyn_ents, 0, 0);
	clientfield::register("world", "snd_tram", 5000, 2, "int", &snd_tram, 0, 0);
	thread function_58a73de9();
	thread function_60283937();
}

/*
	Name: function_b84c3341
	Namespace: zm_castle_tram
	Checksum: 0x3A75998A
	Offset: 0x438
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_b84c3341(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_19082f83();
	}
}

/*
	Name: function_19082f83
	Namespace: zm_castle_tram
	Checksum: 0x162940B6
	Offset: 0x4A0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_19082f83()
{
	self endon("entityshutdown");
	self function_2d89f1a7(7.5, 0.5);
	self function_2d89f1a7(2.5, 0.25);
	self function_2d89f1a7(1.5, 0.1);
}

/*
	Name: function_2d89f1a7
	Namespace: zm_castle_tram
	Checksum: 0x9CAA2046
	Offset: 0x530
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function function_2d89f1a7(var_e2026f3a, n_blink_rate)
{
	self endon("entityshutdown");
	n_counter = 0;
	n_timer = 0;
	while(n_timer < var_e2026f3a)
	{
		if(n_counter % 2)
		{
			self show();
		}
		else
		{
			self Hide();
		}
		wait(n_blink_rate);
		n_timer = n_timer + n_blink_rate;
		n_counter++;
	}
}

/*
	Name: tram_fuse_fx_callback
	Namespace: zm_castle_tram
	Checksum: 0x13841580
	Offset: 0x5E0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function tram_fuse_fx_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.tram_fuse_fx = PlayFXOnTag(localClientNum, level._effect["tram_fuse_fx"], self, "j_fuse_main");
}

/*
	Name: tram_fuse_destroy
	Namespace: zm_castle_tram
	Checksum: 0x9BD35B3A
	Offset: 0x660
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function tram_fuse_destroy(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.tram_fuse_fx))
	{
		deletefx(localClientNum, self.tram_fuse_fx, 1);
		self.tram_fuse_fx = undefined;
	}
	PlayFXOnTag(localClientNum, level._effect["tram_fuse_destroy"], self, "j_fuse_main");
}

/*
	Name: snd_tram
	Namespace: zm_castle_tram
	Checksum: 0xCBF25B09
	Offset: 0x710
	Size: 0x2D9
	Parameters: 7
	Flags: None
*/
function snd_tram(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(newVal == 1)
		{
			playsound(0, "evt_tram_motor_start", (342, 979, 135));
			foreach(location in level.var_4ea0a9e6)
			{
				audio::playloopat("evt_tram_pulley_large_loop", location);
			}
			foreach(location in level.var_a49222f2)
			{
				audio::playloopat("evt_tram_pulley_small_loop", location);
			}
		}
		else if(newVal == 2)
		{
			playsound(0, "evt_tram_motor_stop", (342, 979, 135));
			foreach(location in level.var_4ea0a9e6)
			{
				audio::stoploopat("evt_tram_pulley_large_loop", location);
			}
			foreach(location in level.var_a49222f2)
			{
				audio::stoploopat("evt_tram_pulley_small_loop", location);
			}
		}
	}
}

/*
	Name: function_58a73de9
	Namespace: zm_castle_tram
	Checksum: 0xB1F8A7D8
	Offset: 0x9F8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_58a73de9()
{
	level.var_4ea0a9e6 = Array((159, 999, 265), (276, 1186, 264), (511, 1077, 264));
	level.var_a49222f2 = Array((273, 431, 242), (603, 499, 238));
}

/*
	Name: function_60283937
	Namespace: zm_castle_tram
	Checksum: 0x22EDDF39
	Offset: 0xA88
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_60283937()
{
	while(1)
	{
		level waittill("tram_motor_sound", duration);
		if(duration == "long")
		{
			playsound(0, "evt_tram_motor_long", (342, 979, 135));
		}
		else
		{
			playsound(0, "evt_tram_motor_short", (342, 979, 135));
		}
	}
}

/*
	Name: remove_dyn_ents
	Namespace: zm_castle_tram
	Checksum: 0x12C754A6
	Offset: 0xB20
	Size: 0x4B
	Parameters: 7
	Flags: None
*/
function remove_dyn_ents(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	CleanupSpawnedDynents();
}

