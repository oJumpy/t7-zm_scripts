#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace zm_sumpf_amb;

/*
	Name: main
	Namespace: zm_sumpf_amb
	Checksum: 0x727516F6
	Offset: 0x248
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function main()
{
	thread play_meteor_loop();
	level thread startzmbspawnersoundloops();
}

/*
	Name: play_meteor_loop
	Namespace: zm_sumpf_amb
	Checksum: 0xA36713C8
	Offset: 0x280
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function play_meteor_loop()
{
	meteor = audio::playloopat("amb_meteor_loop", (11264, -1920, -592));
}

/*
	Name: start_lights
	Namespace: zm_sumpf_amb
	Checksum: 0x52C171FC
	Offset: 0x2C0
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function start_lights()
{
	level waittill("start_lights");
	wait(2);
	Array::thread_all(struct::get_array("electrical_circuit", "targetname"), &circuit_sound);
	playsound(0, "zmb_turn_on", (0, 0, 0));
	wait(3);
	Array::thread_all(struct::get_array("electrical_surge", "targetname"), &light_sound);
	Array::thread_all(struct::get_array("low_buzz", "targetname"), &buzz_sound);
	playertrack = audio::playloopat("player_ambience", (0, 0, 0));
}

/*
	Name: light_sound
	Namespace: zm_sumpf_amb
	Checksum: 0x26F5CAAA
	Offset: 0x3F8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function light_sound()
{
	wait(RandomFloatRange(1, 4));
	playsound(0, "evt_electrical_surge", self.origin);
	playFX(0, level._effect["electric_short_oneshot"], self.origin);
	wait(RandomFloatRange(1, 2));
	e1 = audio::playloopat("light", self.origin);
	self run_sparks_loop();
}

/*
	Name: run_sparks_loop
	Namespace: zm_sumpf_amb
	Checksum: 0xB636D4AE
	Offset: 0x4D0
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function run_sparks_loop()
{
	while(1)
	{
		wait(RandomFloatRange(4, 15));
		if(RandomFloatRange(0, 1) < 0.5)
		{
			playFX(0, level._effect["electric_short_oneshot"], self.origin);
			playsound(0, "evt_electrical_surge", self.origin);
		}
		wait(randomIntRange(1, 4));
	}
}

/*
	Name: circuit_sound
	Namespace: zm_sumpf_amb
	Checksum: 0xCB0AECCD
	Offset: 0x590
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function circuit_sound()
{
	wait(1);
	playsound(0, "circuit", self.origin);
}

/*
	Name: buzz_sound
	Namespace: zm_sumpf_amb
	Checksum: 0x1F20FE22
	Offset: 0x5C8
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function buzz_sound()
{
	lowbuzz = audio::playloopat("low_arc", self.origin);
}

/*
	Name: function_c9207335
	Namespace: zm_sumpf_amb
	Checksum: 0xF21471DA
	Offset: 0x600
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
	Namespace: zm_sumpf_amb
	Checksum: 0x55CDA395
	Offset: 0x680
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
	Namespace: zm_sumpf_amb
	Checksum: 0x2E908DC5
	Offset: 0x720
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_sumpf_underscore_default";
	level.newmus = "mus_sumpf_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.newmus = "mus_sumpf_underscore_" + location;
		if(level.newmus != level.var_b6342abd)
		{
			level thread function_b234849(level.newmus);
			level.var_b6342abd = level.newmus;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_sumpf_amb
	Checksum: 0xF20F6D7
	Offset: 0x820
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
	Name: startzmbspawnersoundloops
	Namespace: zm_sumpf_amb
	Checksum: 0x5CF78C34
	Offset: 0x890
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
	Namespace: zm_sumpf_amb
	Checksum: 0xE3CAD9AE
	Offset: 0x9F8
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

