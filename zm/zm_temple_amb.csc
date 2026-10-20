#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace zm_temple_amb;

/*
	Name: main
	Namespace: zm_temple_amb
	Checksum: 0x31D1FB4F
	Offset: 0x258
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread sq_setup();
	level thread waitfor_revive_deactivate();
	level thread geyser_watch();
	level thread wait_for_game_end();
	level thread snd_start_autofx_audio();
	level thread startzmbspawnersoundloops();
	clientfield::register("scriptmover", "meteor_shrink", 21000, 1, "counter", &meteor_shrink, 0, 0);
}

/*
	Name: waitfor_revive_deactivate
	Namespace: zm_temple_amb
	Checksum: 0x599C5C2A
	Offset: 0x340
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function waitfor_revive_deactivate()
{
	level waittill("drb");
	level notify("deactivate_revive_bump");
}

/*
	Name: sq_setup
	Namespace: zm_temple_amb
	Checksum: 0x444C1DA6
	Offset: 0x368
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function sq_setup()
{
	level.bg_ent = undefined;
}

/*
	Name: waitfor_ec
	Namespace: zm_temple_amb
	Checksum: 0x34DC33DE
	Offset: 0x380
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function waitfor_ec(amb_structs)
{
	playsound(0, "evt_sq_gen_transition", (0, 0, 0));
	setsoundcontext("aquifer_cockpit", "active");
	audio::playloopat("evt_sq_gen_bg", (0, 0, 0));
}

/*
	Name: waitfor_return
	Namespace: zm_temple_amb
	Checksum: 0xC24A6A0D
	Offset: 0x3F8
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function waitfor_return(bNewEnt, bInitialSnap, bWasDemoJump)
{
	if(!bNewEnt && !bInitialSnap && !bWasDemoJump)
	{
		playsound(0, "evt_sq_gen_transition", (0, 0, 0));
	}
	setsoundcontext("aquifer_cockpit", "");
	audio::stoploopat("evt_sq_gen_bg", (0, 0, 0));
}

/*
	Name: geyser_watch
	Namespace: zm_temple_amb
	Checksum: 0xD232CC20
	Offset: 0x4A0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function geyser_watch()
{
	level thread geyser_emitter(0);
	level thread geyser_emitter(1);
}

/*
	Name: geyser_emitter
	Namespace: zm_temple_amb
	Checksum: 0x80B4F551
	Offset: 0x4E0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function geyser_emitter(num)
{
	while(1)
	{
		level waittill("ge" + num);
		level notify("evt_geyser_blast_" + num);
		wait(14.5);
		level notify("evt_geyser_blast_" + num);
	}
}

/*
	Name: meteor_shrink
	Namespace: zm_temple_amb
	Checksum: 0x737D4442
	Offset: 0x540
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function meteor_shrink(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	audio::snd_set_snapshot("zmb_temple_egg");
	level thread function_762642a6();
}

/*
	Name: function_762642a6
	Namespace: zm_temple_amb
	Checksum: 0xEEB455C4
	Offset: 0x5B8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_762642a6()
{
	wait(5.5);
	if(isdefined(level.bg_ent))
	{
		audio::snd_set_snapshot("zmb_temple_sq");
	}
	else
	{
		audio::snd_set_snapshot("default");
	}
}

/*
	Name: wait_for_game_end
	Namespace: zm_temple_amb
	Checksum: 0x99A42B81
	Offset: 0x618
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function wait_for_game_end()
{
	level waittill("zesn");
	audio::snd_set_snapshot("zmb_temple_egg");
}

/*
	Name: snd_start_autofx_audio
	Namespace: zm_temple_amb
	Checksum: 0x7F6162AF
	Offset: 0x650
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function snd_start_autofx_audio()
{
	audio::snd_play_auto_fx("fx_ztem_torch", "amb_fire_medium");
}

/*
	Name: function_60a32834
	Namespace: zm_temple_amb
	Checksum: 0xE6879B3D
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
	Namespace: zm_temple_amb
	Checksum: 0x9BEEA0CE
	Offset: 0x720
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_temple_underscore_default";
	level.newmus = "mus_temple_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.newmus = "mus_temple_underscore_" + location;
		if(level.newmus != level.var_b6342abd)
		{
			level thread function_b234849(level.newmus);
			level.var_b6342abd = level.newmus;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_temple_amb
	Checksum: 0x602551BA
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
	Namespace: zm_temple_amb
	Checksum: 0x1B4285B8
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
	Namespace: zm_temple_amb
	Checksum: 0x88D1E5A3
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

