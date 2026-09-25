#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace audio;

/*
	Name: __init__sytem__
	Namespace: audio
	Checksum: 0x54EB2526
	Offset: 0x8C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: audio
	Checksum: 0x6C48B937
	Offset: 0x900
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	snd_snapshot_init();
	callback::on_localclient_connect(&player_init);
	callback::on_localplayer_spawned(&local_player_spawn);
	level thread register_clientfields();
	level thread sndKillcam();
	level thread SetPfxContext();
	setsoundcontext("foley", "normal");
	setsoundcontext("plr_impact", "");
}

/*
	Name: register_clientfields
	Namespace: audio
	Checksum: 0x68AE4611
	Offset: 0x9E8
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("world", "sndMatchSnapshot", 1, 2, "int", &sndMatchSnapshot, 1, 0);
	clientfield::register("world", "sndFoleyContext", 1, 1, "int", &sndFoleyContext, 0, 0);
	clientfield::register("scriptmover", "sndRattle", 1, 1, "int", &sndRattle_Server, 1, 0);
	clientfield::register("toplayer", "sndMelee", 1, 1, "int", &weapon_butt_sounds, 1, 1);
	clientfield::register("vehicle", "sndSwitchVehicleContext", 1, 3, "int", &sndSwitchVehicleContext, 0, 0);
	clientfield::register("toplayer", "sndCCHacking", 1, 2, "int", &sndCChacking, 1, 1);
	clientfield::register("toplayer", "sndTacRig", 1, 1, "int", &sndTacRig, 0, 1);
	clientfield::register("toplayer", "sndLevelStartSnapOff", 1, 1, "int", &sndLevelStartSnapOff, 0, 1);
	clientfield::register("world", "sndIGCsnapshot", 1, 4, "int", &sndIGCsnapshot, 1, 0);
	clientfield::register("world", "sndChyronLoop", 1, 1, "int", &sndChyronLoop, 0, 0);
	clientfield::register("world", "sndZMBFadeIn", 1, 1, "int", &sndZMBFadeIn, 1, 0);
}

/*
	Name: local_player_spawn
	Namespace: audio
	Checksum: 0x11EFE10D
	Offset: 0xD10
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function local_player_spawn(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	setsoundcontext("foley", "normal");
	if(!SessionModeIsMultiplayerGame())
	{
		if(isdefined(level._lastMusicState))
		{
			soundsetmusicstate(level._lastMusicState);
		}
		self thread sndMusicDeathWatcher();
	}
	self thread isPlayerInfected();
	self thread snd_underwater(localClientNum);
	self thread clientVoiceSetup(localClientNum);
}

/*
	Name: player_init
	Namespace: audio
	Checksum: 0x4C35C6D5
	Offset: 0xE00
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function player_init(localClientNum)
{
	if(IsSplitScreenHost(localClientNum))
	{
		level thread bump_trigger_start(localClientNum);
		level thread init_audio_triggers(localClientNum);
		level thread sndRattle_Grenade_Client();
		startSoundRandoms(localClientNum);
		startSoundLoops();
		startLineEmitters();
		startRattles();
	}
}

/*
	Name: sndDoubleJump_Watcher
	Namespace: audio
	Checksum: 0xC76A7CD3
	Offset: 0xEC0
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function sndDoubleJump_Watcher()
{
	self endon("entityshutdown");
	while(1)
	{
		self waittill("doublejump_start");
		trace = tracepoint(self.origin, self.origin - VectorScale((0, 0, 1), 100000));
		trace_surface_type = trace["surfacetype"];
		trace_origin = trace["position"];
		if(!isdefined(trace) || !isdefined(trace_origin))
		{
			continue;
		}
		if(!isdefined(trace_surface_type))
		{
			trace_surface_type = "default";
		}
		playsound(0, "veh_jetpack_surface_" + trace_surface_type, trace_origin);
	}
}

/*
	Name: clientVoiceSetup
	Namespace: audio
	Checksum: 0x608F7998
	Offset: 0xFB8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function clientVoiceSetup(localClientNum)
{
	self endon("entityshutdown");
	if(isdefined(level.clientVoiceSetup))
	{
		[[level.clientVoiceSetup]](localClientNum);
		return;
	}
	self.teamClientPrefix = "vox_gen";
	self thread sndVoNotify("playerbreathinsound", "sinper_hold");
	self thread sndVoNotify("playerbreathoutsound", "sinper_exhale");
	self thread sndVoNotify("playerbreathgaspsound", "sinper_gasp");
}

/*
	Name: sndVoNotify
	Namespace: audio
	Checksum: 0xC65C6F96
	Offset: 0x1088
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function sndVoNotify(notifyString, dialog)
{
	self endon("entityshutdown");
	for(;;)
	{
		self waittill(notifyString);
		soundAlias = self.teamClientPrefix + "_" + dialog;
		self playsound(0, soundAlias);
	}
}

/*
	Name: snd_snapshot_init
	Namespace: audio
	Checksum: 0xB9451265
	Offset: 0x10F8
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function snd_snapshot_init()
{
	level._sndActiveSnapshot = "default";
	level._sndNextSnapshot = "default";
	mapname = GetDvarString("mapname");
	if(mapname !== "core_frontend")
	{
		if(SessionModeIsCampaignGame())
		{
			level._sndActiveSnapshot = "cmn_level_start";
			level._sndNextSnapshot = "cmn_level_start";
		}
		if(SessionModeIsZombiesGame())
		{
			if(mapname !== "zm_cosmodrome" && mapname !== "zm_prototype" && mapname !== "zm_moon" && mapname !== "zm_sumpf" && mapname !== "zm_asylum" && mapname !== "zm_temple" && mapname !== "zm_theater" && mapname !== "zm_tomb")
			{
				level._sndActiveSnapshot = "zmb_game_start_nofade";
				level._sndNextSnapshot = "zmb_game_start_nofade";
			}
			else
			{
				level._sndActiveSnapshot = "zmb_hd_game_start_nofade";
				level._sndNextSnapshot = "zmb_hd_game_start_nofade";
			}
		}
	}
	setgroupsnapshot(level._sndActiveSnapshot);
	thread snd_snapshot_think();
}

/*
	Name: sndOnWait
	Namespace: audio
	Checksum: 0xF6E0D08A
	Offset: 0x1298
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function sndOnWait()
{
	level endon("sndOnOverride");
	level util::waittill_any_timeout(20, "sndOn", "sndOnOverride");
}

/*
	Name: snd_set_snapshot
	Namespace: audio
	Checksum: 0xC112AA88
	Offset: 0x12D8
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function snd_set_snapshot(State)
{
	level._sndNextSnapshot = State;
	/#
		println("Dev Block strings are not supported" + State + "Dev Block strings are not supported");
	#/
	level notify("new_bus");
}

/*
	Name: snd_snapshot_think
	Namespace: audio
	Checksum: 0x2776E79
	Offset: 0x1338
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function snd_snapshot_think()
{
	while(level._sndActiveSnapshot == level._sndNextSnapshot)
	{
		level waittill("new_bus");
		if(level._sndActiveSnapshot == level._sndNextSnapshot)
		{
		}
		else
		{
			Assert(isdefined(level._sndNextSnapshot));
			/#
				Assert(isdefined(level._sndActiveSnapshot));
			#/
			setgroupsnapshot(level._sndNextSnapshot);
			level._sndActiveSnapshot = level._sndNextSnapshot;
		}
		/#
		#/
	}
}

/*
	Name: soundRandom_Thread
	Namespace: audio
	Checksum: 0xE652ED17
	Offset: 0x13E8
	Size: 0x22F
	Parameters: 2
	Flags: None
*/
function soundRandom_Thread(localClientNum, randSound)
{
	if(!isdefined(randSound.script_wait_min))
	{
		randSound.script_wait_min = 1;
	}
	if(!isdefined(randSound.script_wait_max))
	{
		randSound.script_wait_max = 3;
	}
	notify_name = undefined;
	if(isdefined(randSound.script_string))
	{
		notify_name = randSound.script_string;
	}
	if(!isdefined(notify_name) && isdefined(randSound.script_sound))
	{
		CreateSoundRandom(randSound.origin, randSound.script_sound, randSound.script_wait_min, randSound.script_wait_max);
		return;
	}
	randSound.playing = 1;
	level thread soundRandom_NotifyWait(notify_name, randSound);
	while(1)
	{
		wait(RandomFloatRange(randSound.script_wait_min, randSound.script_wait_max));
		if(isdefined(randSound.script_sound) && (isdefined(randSound.playing) && randSound.playing))
		{
			playsound(localClientNum, randSound.script_sound, randSound.origin);
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				print3d(randSound.origin, randSound.script_sound, VectorScale((0, 1, 0), 0.8), 1, 3, 45);
			}
		#/
	}
}

/*
	Name: soundRandom_NotifyWait
	Namespace: audio
	Checksum: 0x20CBADEC
	Offset: 0x1620
	Size: 0x77
	Parameters: 2
	Flags: None
*/
function soundRandom_NotifyWait(notify_name, randSound)
{
	while(1)
	{
		level waittill(notify_name);
		if(isdefined(randSound.playing) && randSound.playing)
		{
			randSound.playing = 0;
		}
		else
		{
			randSound.playing = 1;
		}
	}
}

/*
	Name: startSoundRandoms
	Namespace: audio
	Checksum: 0x68CC2D7A
	Offset: 0x16A0
	Size: 0x105
	Parameters: 1
	Flags: None
*/
function startSoundRandoms(localClientNum)
{
	randoms = struct::get_array("random", "script_label");
	if(isdefined(randoms) && randoms.size > 0)
	{
		nScriptThreadedRandoms = 0;
		for(i = 0; i < randoms.size; i++)
		{
			if(isdefined(randoms[i].script_scripted))
			{
				nScriptThreadedRandoms++;
			}
		}
		AllocateSoundRandoms(randoms.size - nScriptThreadedRandoms);
		for(i = 0; i < randoms.size; i++)
		{
			thread soundRandom_Thread(localClientNum, randoms[i]);
		}
	}
}

/*
	Name: soundLoopThink
	Namespace: audio
	Checksum: 0x2E62BC1F
	Offset: 0x17B0
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function soundLoopThink()
{
	if(!isdefined(self.script_sound))
	{
		return;
	}
	if(!isdefined(self.origin))
	{
		return;
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
				self thread soundLoopCheckpointRestore();
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
	Name: soundLoopCheckpointRestore
	Namespace: audio
	Checksum: 0xF608BA75
	Offset: 0x1930
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function soundLoopCheckpointRestore()
{
	level waittill("save_restore");
	soundloopemitter(self.script_sound, self.origin);
}

/*
	Name: soundLineThink
	Namespace: audio
	Checksum: 0x4BE6950B
	Offset: 0x1970
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function soundLineThink()
{
	if(!isdefined(self.target))
	{
		return;
	}
	target = struct::get(self.target, "targetname");
	if(!isdefined(target))
	{
		return;
	}
	notifyname = "";
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundLineEmitter(self.script_sound, self.origin, target.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundStopLineEmitter(self.script_sound, self.origin, target.origin);
				self thread soundLineCheckpointRestore(target);
			}
			else
			{
				soundLineEmitter(self.script_sound, self.origin, target.origin);
			}
			started = !started;
		}
	}
}

/*
	Name: soundLineCheckpointRestore
	Namespace: audio
	Checksum: 0xACAC1318
	Offset: 0x1B00
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function soundLineCheckpointRestore(target)
{
	level waittill("save_restore");
	soundLineEmitter(self.script_sound, self.origin, target.origin);
}

/*
	Name: startSoundLoops
	Namespace: audio
	Checksum: 0x89DB718
	Offset: 0x1B50
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function startSoundLoops()
{
	loopers = struct::get_array("looper", "script_label");
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
	Name: startLineEmitters
	Namespace: audio
	Checksum: 0xD40546B8
	Offset: 0x1CB8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function startLineEmitters()
{
	lineEmitters = struct::get_array("line_emitter", "script_label");
	if(isdefined(lineEmitters) && lineEmitters.size > 0)
	{
		delay = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + lineEmitters.size + "Dev Block strings are not supported");
			}
		#/
		for(i = 0; i < lineEmitters.size; i++)
		{
			lineEmitters[i] thread soundLineThink();
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
	Name: startRattles
	Namespace: audio
	Checksum: 0x252C16D3
	Offset: 0x1E20
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function startRattles()
{
	rattles = struct::get_array("sound_rattle", "script_label");
	if(isdefined(rattles))
	{
		/#
			println("Dev Block strings are not supported" + rattles.size + "Dev Block strings are not supported");
		#/
		delay = 0;
		for(i = 0; i < rattles.size; i++)
		{
			soundrattlesetup(rattles[i].script_sound, rattles[i].origin);
			delay = delay + 1;
			if(delay % 20 == 0)
			{
				wait(0.016);
			}
		}
	}
}

/*
	Name: init_audio_triggers
	Namespace: audio
	Checksum: 0x7A647695
	Offset: 0x1F38
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function init_audio_triggers(localClientNum)
{
	util::waitforclient(localClientNum);
	stepTrigs = GetEntArray(localClientNum, "audio_step_trigger", "targetname");
	materialTrigs = GetEntArray(localClientNum, "audio_material_trigger", "targetname");
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + stepTrigs.size + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + materialTrigs.size + "Dev Block strings are not supported");
		}
	#/
	Array::thread_all(stepTrigs, &audio_step_trigger, localClientNum);
	Array::thread_all(materialTrigs, &audio_material_trigger, localClientNum);
}

/*
	Name: audio_step_trigger
	Namespace: audio
	Checksum: 0x59471705
	Offset: 0x2098
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function audio_step_trigger(localClientNum)
{
	self._localClientNum = localClientNum;
	for(;;)
	{
		self waittill("trigger", trigPlayer);
		self thread trigger::function_thread(trigPlayer, &trig_enter_audio_step_trigger, &trig_leave_audio_step_trigger);
	}
}

/*
	Name: audio_material_trigger
	Namespace: audio
	Checksum: 0x82801E2C
	Offset: 0x2110
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function audio_material_trigger(trig)
{
	for(;;)
	{
		self waittill("trigger", trigPlayer);
		self thread trigger::function_thread(trigPlayer, &trig_enter_audio_material_trigger, &trig_leave_audio_material_trigger);
	}
}

/*
	Name: trig_enter_audio_material_trigger
	Namespace: audio
	Checksum: 0xA3C81852
	Offset: 0x2178
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function trig_enter_audio_material_trigger(player)
{
	if(!isdefined(player.inMaterialOverrideTrigger))
	{
		player.inMaterialOverrideTrigger = 0;
	}
	if(isdefined(self.script_label))
	{
		player.inMaterialOverrideTrigger++;
		player.audioMaterialOverride = self.script_label;
		player SetMaterialOverride(self.script_label);
	}
}

/*
	Name: trig_leave_audio_material_trigger
	Namespace: audio
	Checksum: 0x3B91A333
	Offset: 0x2200
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function trig_leave_audio_material_trigger(player)
{
	if(isdefined(self.script_label))
	{
		player.inMaterialOverrideTrigger--;
		/#
			/#
				Assert(player.inMaterialOverrideTrigger >= 0);
			#/
		#/
		if(player.inMaterialOverrideTrigger <= 0)
		{
			player.audioMaterialOverride = undefined;
			player.inMaterialOverrideTrigger = 0;
			player ClearMaterialOverride();
		}
	}
}

/*
	Name: trig_enter_audio_step_trigger
	Namespace: audio
	Checksum: 0x2DC37895
	Offset: 0x22A8
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function trig_enter_audio_step_trigger(trigPlayer)
{
	localClientNum = self._localClientNum;
	if(!isdefined(trigPlayer.inStepTrigger))
	{
		trigPlayer.inStepTrigger = 0;
	}
	suffix = "_npc";
	if(trigPlayer isLocalPlayer())
	{
		suffix = "_plr";
	}
	if(isdefined(self.script_label))
	{
		trigPlayer.step_sound = self.script_label;
		trigPlayer.inStepTrigger = trigPlayer.inStepTrigger + 1;
		trigPlayer SetStepTriggerSound(self.script_label + suffix);
	}
	if(isdefined(self.script_sound) && trigPlayer GetMovementType() == "sprint")
	{
		volume = get_vol_from_speed(trigPlayer);
		trigPlayer playsound(localClientNum, self.script_sound + suffix, self.origin, volume);
	}
}

/*
	Name: trig_leave_audio_step_trigger
	Namespace: audio
	Checksum: 0x9185709D
	Offset: 0x2418
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function trig_leave_audio_step_trigger(trigPlayer)
{
	localClientNum = self._localClientNum;
	suffix = "_npc";
	if(trigPlayer isLocalPlayer())
	{
		suffix = "_plr";
	}
	if(isdefined(self.script_noteworthy) && trigPlayer GetMovementType() == "sprint")
	{
		volume = get_vol_from_speed(trigPlayer);
		trigPlayer playsound(localClientNum, self.script_noteworthy + suffix, self.origin, volume);
	}
	if(isdefined(self.script_label))
	{
		trigPlayer.inStepTrigger = trigPlayer.inStepTrigger - 1;
	}
	if(trigPlayer.inStepTrigger < 0)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		trigPlayer.inStepTrigger = 0;
	}
	if(trigPlayer.inStepTrigger == 0)
	{
		trigPlayer.step_sound = "none";
		trigPlayer ClearStepTriggerSound();
	}
}

/*
	Name: bump_trigger_start
	Namespace: audio
	Checksum: 0xCF03E099
	Offset: 0x25B0
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function bump_trigger_start(localClientNum)
{
	bump_trigs = GetEntArray(localClientNum, "audio_bump_trigger", "targetname");
	for(i = 0; i < bump_trigs.size; i++)
	{
		bump_trigs[i] thread thread_bump_trigger(localClientNum);
	}
}

/*
	Name: thread_bump_trigger
	Namespace: audio
	Checksum: 0x255F20E3
	Offset: 0x2648
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function thread_bump_trigger(localClientNum)
{
	self thread bump_trigger_listener();
	if(!isdefined(self.script_activated))
	{
		self.script_activated = 1;
	}
	self._localClientNum = localClientNum;
	for(;;)
	{
		self waittill("trigger", trigPlayer);
		self thread trigger::function_thread(trigPlayer, &trig_enter_bump, &trig_leave_bump);
	}
}

/*
	Name: trig_enter_bump
	Namespace: audio
	Checksum: 0x92F611CB
	Offset: 0x26F0
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function trig_enter_bump(ent)
{
	if(!isdefined(ent))
	{
		return;
	}
	localClientNum = self._localClientNum;
	volume = get_vol_from_speed(ent);
	if(!SessionModeIsZombiesGame())
	{
		if(ent isPlayer() && ent hasPerk(localClientNum, "specialty_quieter"))
		{
			volume = volume / 2;
		}
	}
	if(isdefined(self.script_sound) && self.script_activated)
	{
		if(isdefined(self.script_noteworthy) && self.script_wait > volume)
		{
			test_id = ent playsound(localClientNum, self.script_noteworthy, self.origin, volume);
		}
		if(isdefined(self.script_parameters))
		{
			test_id = ent playsound(localClientNum, self.script_parameters, self.origin, volume);
		}
		if(!isdefined(self.script_wait) || self.script_wait <= volume)
		{
			test_id = ent playsound(localClientNum, self.script_sound, self.origin, volume);
		}
	}
	if(isdefined(self.script_location) && self.script_activated)
	{
		ent thread mantle_wait(self.script_location, localClientNum);
	}
}

/*
	Name: mantle_wait
	Namespace: audio
	Checksum: 0x30FEDEE1
	Offset: 0x28E0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function mantle_wait(alias, localClientNum)
{
	self endon("death");
	self endon("left_mantle");
	self waittill("traversesound");
	self playsound(localClientNum, alias, self.origin, 1);
}

/*
	Name: trig_leave_bump
	Namespace: audio
	Checksum: 0x3B71DE64
	Offset: 0x2950
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function trig_leave_bump(ent)
{
	wait(1);
	ent notify("left_mantle");
}

/*
	Name: bump_trigger_listener
	Namespace: audio
	Checksum: 0x5DD2AAA6
	Offset: 0x2978
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function bump_trigger_listener()
{
	if(isdefined(self.script_label))
	{
		level waittill(self.script_label);
		self.script_activated = 0;
	}
}

/*
	Name: scale_speed
	Namespace: audio
	Checksum: 0x3E3DD149
	Offset: 0x29A8
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function scale_speed(x1, x2, y1, y2, z)
{
	if(z < x1)
	{
		z = x1;
	}
	if(z > x2)
	{
		z = x2;
	}
	dx = x2 - x1;
	n = z - x1 / dx;
	dy = y2 - y1;
	w = n * dy + y1;
	return w;
}

/*
	Name: get_vol_from_speed
	Namespace: audio
	Checksum: 0x74D0A80D
	Offset: 0x2A80
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function get_vol_from_speed(player)
{
	min_speed = 21;
	max_speed = 285;
	max_vol = 1;
	min_vol = 0.1;
	speed = player getspeed();
	abs_speed = absolute_value(Int(speed));
	volume = scale_speed(min_speed, max_speed, min_vol, max_vol, abs_speed);
	return volume;
}

/*
	Name: absolute_value
	Namespace: audio
	Checksum: 0x9DE1AA44
	Offset: 0x2B70
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function absolute_value(fowd)
{
	if(fowd < 0)
	{
		return fowd * -1;
	}
	else
	{
		return fowd;
	}
}

/*
	Name: closest_point_on_line_to_point
	Namespace: audio
	Checksum: 0xE9CC5EB
	Offset: 0x2BA8
	Size: 0x1DF
	Parameters: 3
	Flags: None
*/
function closest_point_on_line_to_point(point, LineStart, LineEnd)
{
	self endon("end line sound");
	LineMagSqrd = LengthSquared(LineEnd - LineStart);
	t = point[0] - LineStart[0] * LineEnd[0] - LineStart[0] + point[1] - LineStart[1] * LineEnd[1] - LineStart[1] + point[2] - LineStart[2] * LineEnd[2] - LineStart[2] / LineMagSqrd;
	if(t < 0)
	{
		self.origin = LineStart;
	}
	else if(t > 1)
	{
		self.origin = LineEnd;
	}
	else
	{
		start_x = LineStart[0] + t * LineEnd[0] - LineStart[0];
		start_y = LineStart[1] + t * LineEnd[1] - LineStart[1];
		start_z = LineStart[2] + t * LineEnd[2] - LineStart[2];
		self.origin = (start_x, start_y, start_z);
	}
}

/*
	Name: snd_play_auto_fx
	Namespace: audio
	Checksum: 0x877405E1
	Offset: 0x2D90
	Size: 0x83
	Parameters: 9
	Flags: None
*/
function snd_play_auto_fx(fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override)
{
	SoundPlayAutoFX(fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override);
}

/*
	Name: snd_print_fx_id
	Namespace: audio
	Checksum: 0x4D2D743B
	Offset: 0x2E20
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function snd_print_fx_id(fxid, type, ent)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + fxid + "Dev Block strings are not supported" + type);
		}
	#/
}

/*
	Name: debug_line_emitter
	Namespace: audio
	Checksum: 0xD6BD2BF
	Offset: 0x2E98
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function debug_line_emitter()
{
	while(1)
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				line(self.start, self.end, (0, 1, 0));
				print3d(self.start, "Dev Block strings are not supported", VectorScale((0, 1, 0), 0.8), 1, 3, 1);
				print3d(self.end, "Dev Block strings are not supported", VectorScale((0, 1, 0), 0.8), 1, 3, 1);
				print3d(self.origin, self.script_sound, VectorScale((0, 1, 0), 0.8), 1, 3, 1);
			}
			wait(0.016);
		#/
	}
}

/*
	Name: move_sound_along_line
	Namespace: audio
	Checksum: 0xD24E6C50
	Offset: 0x2FA8
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function move_sound_along_line()
{
	closest_dist = undefined;
	/#
		self thread debug_line_emitter();
	#/
	while(1)
	{
		self closest_point_on_line_to_point(getlocalclientpos(0), self.start, self.end);
		if(isdefined(self.fake_ent))
		{
			self.fake_ent.origin = self.origin;
		}
		closest_dist = DistanceSquared(getlocalclientpos(0), self.origin);
		if(closest_dist > 1048576)
		{
			wait(2);
		}
		else if(closest_dist > 262144)
		{
			wait(0.2);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: playloopat
	Namespace: audio
	Checksum: 0xB5F6B6FB
	Offset: 0x30B8
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function playloopat(aliasname, origin)
{
	soundloopemitter(aliasname, origin);
}

/*
	Name: stoploopat
	Namespace: audio
	Checksum: 0xA502F2A1
	Offset: 0x30F0
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function stoploopat(aliasname, origin)
{
	soundstoploopemitter(aliasname, origin);
}

/*
	Name: soundwait
	Namespace: audio
	Checksum: 0x9995F98A
	Offset: 0x3128
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function soundwait(id)
{
	while(SoundPlaying(id))
	{
		wait(0.1);
	}
}

/*
	Name: snd_underwater
	Namespace: audio
	Checksum: 0xFF65BE16
	Offset: 0x3168
	Size: 0x2FF
	Parameters: 1
	Flags: None
*/
function snd_underwater(localClientNum)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	level endon("killcam_begin" + localClientNum);
	level endon("killcam_end" + localClientNum);
	self endon("sndEndUWWatcher");
	if(!isdefined(level.audioSharedSwimming))
	{
		level.audioSharedSwimming = 0;
	}
	if(!isdefined(level.audioSharedUnderwater))
	{
		level.audioSharedUnderwater = 0;
	}
	if(level.audioSharedSwimming != IsSwimming(localClientNum))
	{
		level.audioSharedSwimming = IsSwimming(localClientNum);
		if(level.audioSharedSwimming)
		{
			swimBegin();
		}
		else
		{
			swimCancel(localClientNum);
		}
	}
	if(level.audioSharedUnderwater != IsUnderwater(localClientNum))
	{
		level.audioSharedUnderwater = IsUnderwater(localClientNum);
		if(level.audioSharedUnderwater)
		{
			self underwaterBegin();
			continue;
		}
		self underwaterEnd();
	}
	while(1)
	{
		underwaterNotify = self util::waittill_any_ex("underwater_begin", "underwater_end", "swimming_begin", "swimming_end", "death", "entityshutdown", "sndEndUWWatcher", level, "demo_jump", "killcam_begin" + localClientNum, "killcam_end" + localClientNum);
		if(underwaterNotify == "death")
		{
			self underwaterEnd();
			self swimEnd(localClientNum);
		}
		if(underwaterNotify == "underwater_begin")
		{
			self underwaterBegin();
		}
		else if(underwaterNotify == "underwater_end")
		{
			self underwaterEnd();
		}
		else if(underwaterNotify == "swimming_begin")
		{
			self swimBegin();
		}
		else if(underwaterNotify == "swimming_end" && self isPlayer() && isalive(self))
		{
			self swimEnd(localClientNum);
		}
	}
}

/*
	Name: underwaterBegin
	Namespace: audio
	Checksum: 0x906D07C7
	Offset: 0x3470
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function underwaterBegin()
{
	level.audioSharedUnderwater = 1;
}

/*
	Name: underwaterEnd
	Namespace: audio
	Checksum: 0x51736077
	Offset: 0x3488
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function underwaterEnd()
{
	level.audioSharedUnderwater = 0;
}

/*
	Name: SetPfxContext
	Namespace: audio
	Checksum: 0x26847F8B
	Offset: 0x34A0
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function SetPfxContext()
{
	level waittill("pfx_igc_on");
	setsoundcontext("igc", "on");
	level waittill("pfx_igc_off");
	setsoundcontext("igc", "");
	continue;
}

/*
	Name: swimBegin
	Namespace: audio
	Checksum: 0x5FD64260
	Offset: 0x3510
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function swimBegin()
{
	self.audioSharedSwimming = 1;
}

/*
	Name: swimEnd
	Namespace: audio
	Checksum: 0x930BD3D2
	Offset: 0x3528
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function swimEnd(localClientNum)
{
	self.audioSharedSwimming = 0;
}

/*
	Name: swimCancel
	Namespace: audio
	Checksum: 0x63377CA4
	Offset: 0x3548
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function swimCancel(localClientNum)
{
	self.audioSharedSwimming = 0;
}

/*
	Name: soundplayuidecodeloop
	Namespace: audio
	Checksum: 0xE3987C19
	Offset: 0x3568
	Size: 0xBD
	Parameters: 2
	Flags: None
*/
function soundplayuidecodeloop(decodeString, playTimeMs)
{
	if(!isdefined(level.playingUIDecodeLoop) || !level.playingUIDecodeLoop)
	{
		level.playingUIDecodeLoop = 1;
		fake_ent = spawn(0, (0, 0, 0), "script_origin");
		if(isdefined(fake_ent))
		{
			fake_ent PlayLoopSound("uin_notify_data_loop");
			wait(playTimeMs / 1000);
			fake_ent StopAllLoopSounds(0);
		}
		level.playingUIDecodeLoop = undefined;
	}
}

/*
	Name: setCurrentAmbientState
	Namespace: audio
	Checksum: 0xBBFB71E9
	Offset: 0x3630
	Size: 0x53
	Parameters: 5
	Flags: None
*/
function setCurrentAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom)
{
	if(isdefined(level._sndAmbientStateCallback))
	{
		level thread [[level._sndAmbientStateCallback]](ambientRoom, ambientPackage, roomColliderCent);
	}
}

/*
	Name: isPlayerInfected
	Namespace: audio
	Checksum: 0x322A951E
	Offset: 0x3690
	Size: 0x2C5
	Parameters: 0
	Flags: None
*/
function isPlayerInfected()
{
	self endon("entityshutdown");
	mapname = GetDvarString("mapname");
	if(!isdefined(mapname))
	{
		mapname = "cp_mi_eth_prologue";
	}
	if(isdefined(self))
	{
		switch(mapname)
		{
			case "cp_mi_eth_prologue":
			{
				self.isInfected = 0;
				setsoundcontext("healthstate", "human");
				break;
			}
			case "cp_mi_cairo_infection2":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_infection3":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_aquifer":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_lotus":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_lotus2":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_lotus3":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_zurich_coalescence":
			{
				self.isInfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "zm_zod":
			{
				self.isInfected = 0;
				setsoundcontext("healthstate", "human");
				break;
			}
			case "zm_factory":
			{
				self.isInfected = 0;
				setsoundcontext("healthstate", "human");
				break;
			}
			case default:
			{
				self.isInfected = 0;
				setsoundcontext("healthstate", "cyber");
				break;
			}
		}
	}
}

/*
	Name: sndHealthSystem
	Namespace: audio
	Checksum: 0x2BC52004
	Offset: 0x3960
	Size: 0x33D
	Parameters: 7
	Flags: None
*/
function sndHealthSystem(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	lowHealthEnterAlias = "chr_health_lowhealth_enter";
	lowHealthExitAlias = "chr_health_lowhealth_exit";
	laststandExitAlias = "chr_health_laststand_exit";
	dniReparAlais = "chr_health_dni_repair";
	if(newVal)
	{
		switch(newVal)
		{
			case 1:
			{
				self.lowhealth = 1;
				playsound(localClientNum, lowHealthEnterAlias, (0, 0, 0));
				forceambientroom("sndHealth_LowHealth");
				self thread sndDniRepair(localClientNum, dniReparAlais, 0.4, 0.8);
				break;
			}
			case 2:
			{
				playsound(localClientNum, lowHealthExitAlias, (0, 0, 0));
				forceambientroom("sndHealth_LastStand");
				self notify("sndDniRepairDone");
				setsoundcontext("laststand", "active");
				break;
			}
		}
	}
	else
	{
		self.lowhealth = 0;
		setsoundcontext("laststand", "");
		if(SessionModeIsCampaignGame() && (isdefined(level.audioSharedUnderwater) && level.audioSharedUnderwater))
		{
			mapname = GetDvarString("mapname");
			if(mapname == "cp_mi_sing_sgen")
			{
				forceambientroom("");
			}
			else
			{
				forceambientroom("");
			}
		}
		else
		{
			forceambientroom("");
		}
		if(oldVal == 1)
		{
			playsound(localClientNum, lowHealthExitAlias, (0, 0, 0));
			self notify("sndDniRepairDone");
		}
		else if(isalive(self))
		{
			playsound(localClientNum, laststandExitAlias, (0, 0, 0));
			if(isdefined(self.sndTacRigEmergencyReserve) && self.sndTacRigEmergencyReserve)
			{
				playsound(localClientNum, "gdt_cybercore_regen_complete", (0, 0, 0));
			}
		}
		self notify("sndDniRepairDone");
		continue;
	}
}

/*
	Name: sndDniRepair
	Namespace: audio
	Checksum: 0xF588A7EA
	Offset: 0x3CA8
	Size: 0xB7
	Parameters: 4
	Flags: None
*/
function sndDniRepair(localClientNum, alais, min, max)
{
	self endon("sndDniRepairDone");
	wait(0.5);
	if(isdefined(self) && isdefined(self.isInfected))
	{
		if(self.isInfected)
		{
			playsound(localClientNum, "vox_dying_infected_after", (0, 0, 0));
		}
		while(isdefined(self))
		{
			playsound(localClientNum, alais, (0, 0, 0));
			wait(RandomFloatRange(min, max));
		}
	}
}

/*
	Name: sndTacRig
	Namespace: audio
	Checksum: 0x967DC574
	Offset: 0x3D68
	Size: 0x5F
	Parameters: 7
	Flags: None
*/
function sndTacRig(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.sndTacRigEmergencyReserve = 1;
	}
	else
	{
		self.sndTacRigEmergencyReserve = 0;
	}
}

/*
	Name: doRattle
	Namespace: audio
	Checksum: 0x8C26F403
	Offset: 0x3DD0
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function doRattle(origin, min, max)
{
	if(isdefined(min) && min > 0)
	{
		if(isdefined(max) && max <= 0)
		{
			max = undefined;
		}
		soundrattle(origin, min, max);
	}
}

/*
	Name: sndRattle_Server
	Namespace: audio
	Checksum: 0xFBC8F75
	Offset: 0x3E48
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function sndRattle_Server(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(self.model == "wpn_t7_bouncing_betty_world")
		{
			betty = GetWeapon("bouncingbetty");
			level thread doRattle(self.origin, betty.soundRattleRangeMin, betty.soundRattleRangeMax);
		}
		else
		{
			level thread doRattle(self.origin, 25, 600);
		}
	}
}

/*
	Name: sndRattle_Grenade_Client
	Namespace: audio
	Checksum: 0xE193693
	Offset: 0x3F30
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function sndRattle_Grenade_Client()
{
	while(1)
	{
		level waittill("explode", localClientNum, position, mod, weapon, owner_cent);
		level thread doRattle(position, weapon.soundRattleRangeMin, weapon.soundRattleRangeMax);
	}
}

/*
	Name: weapon_butt_sounds
	Namespace: audio
	Checksum: 0xAE004963
	Offset: 0x3FC0
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function weapon_butt_sounds(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.meleed = 1;
		level.mysnd = playsound(localClientNum, "chr_melee_tinitus", (0, 0, 0));
		forceambientroom("sndHealth_Melee");
	}
	else
	{
		self.meleed = 0;
		forceambientroom("");
		if(isdefined(level.mysnd))
		{
			stopSound(level.mysnd);
		}
	}
}

/*
	Name: set_sound_context_defaults
	Namespace: audio
	Checksum: 0x4EC4661C
	Offset: 0x40B0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function set_sound_context_defaults()
{
	wait(2);
	setsoundcontext("foley", "normal");
}

/*
	Name: sndMatchSnapshot
	Namespace: audio
	Checksum: 0x86915F80
	Offset: 0x40E8
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function sndMatchSnapshot(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		switch(newVal)
		{
			case 1:
			{
				snd_set_snapshot("mpl_prematch");
				break;
			}
			case 2:
			{
				snd_set_snapshot("mpl_postmatch");
				break;
			}
			case 3:
			{
				snd_set_snapshot("mpl_endmatch");
				break;
			}
		}
	}
	else
	{
		snd_set_snapshot("default");
	}
}

/*
	Name: sndFoleyContext
	Namespace: audio
	Checksum: 0xB8467FD6
	Offset: 0x41D8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function sndFoleyContext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	setsoundcontext("foley", "normal");
}

/*
	Name: sndKillcam
	Namespace: audio
	Checksum: 0x9F8EAA81
	Offset: 0x4240
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function sndKillcam()
{
	level thread sndFinalKillcam_Slowdown();
	level thread sndFinalKillcam_Deactivate();
}

/*
	Name: sndDeath_Activate
	Namespace: audio
	Checksum: 0xF32B5731
	Offset: 0x4280
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function sndDeath_Activate()
{
	while(1)
	{
		level waittill("sndDED");
		snd_set_snapshot("mpl_death");
	}
}

/*
	Name: sndDeath_Deactivate
	Namespace: audio
	Checksum: 0x911BE21
	Offset: 0x42C0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function sndDeath_Deactivate()
{
	while(1)
	{
		level waittill("sndDEDe");
		snd_set_snapshot("default");
	}
}

/*
	Name: sndFinalKillcam_Activate
	Namespace: audio
	Checksum: 0x4F3E54A
	Offset: 0x4300
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function sndFinalKillcam_Activate()
{
	while(1)
	{
		level waittill("sndFKs");
		playsound(0, "mpl_final_killcam_enter", (0, 0, 0));
		snd_set_snapshot("mpl_final_killcam");
	}
}

/*
	Name: sndFinalKillcam_Slowdown
	Namespace: audio
	Checksum: 0x7B44CEA0
	Offset: 0x4360
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function sndFinalKillcam_Slowdown()
{
	while(1)
	{
		level waittill("sndFKsl");
		playsound(0, "mpl_final_killcam_enter", (0, 0, 0));
		playsound(0, "mpl_final_killcam_slowdown", (0, 0, 0));
		snd_set_snapshot("mpl_final_killcam_slowdown");
	}
}

/*
	Name: sndFinalKillcam_Deactivate
	Namespace: audio
	Checksum: 0x15E09478
	Offset: 0x43E0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function sndFinalKillcam_Deactivate()
{
	while(1)
	{
		level waittill("sndFKe");
		snd_set_snapshot("default");
	}
}

/*
	Name: sndSwitchVehicleContext
	Namespace: audio
	Checksum: 0x8E4EE317
	Offset: 0x4420
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function sndSwitchVehicleContext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isLocalClientDriver(localClientNum))
	{
		setsoundcontext("plr_impact", "veh");
	}
	else
	{
		setsoundcontext("plr_impact", "");
	}
}

/*
	Name: sndMusicDeathWatcher
	Namespace: audio
	Checksum: 0x44883A53
	Offset: 0x44C8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function sndMusicDeathWatcher()
{
	self waittill("death");
	soundsetmusicstate("death");
}

/*
	Name: sndCChacking
	Namespace: audio
	Checksum: 0xA9F834B
	Offset: 0x4500
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function sndCChacking(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		switch(newVal)
		{
			case 1:
			{
				playsound(0, "gdt_cybercore_hack_start_plr", (0, 0, 0));
				self.hsnd = self PlayLoopSound("gdt_cybercore_hack_lp_plr", 0.5);
				break;
			}
			case 2:
			{
				playsound(0, "gdt_cybercore_prime_upg_plr", (0, 0, 0));
				self.hsnd = self PlayLoopSound("gdt_cybercore_prime_loop_plr", 0.5);
				break;
			}
		}
	}
	else if(isdefined(self.hsnd))
	{
		self StopLoopSound(self.hsnd, 0.5);
	}
	if(oldVal == 1)
	{
		playsound(0, "gdt_cybercore_hack_success_plr", (0, 0, 0));
	}
	else if(oldVal == 2)
	{
		playsound(0, "gdt_cybercore_activate_fail_plr", (0, 0, 0));
	}
}

/*
	Name: sndIGCsnapshot
	Namespace: audio
	Checksum: 0x629AC3F6
	Offset: 0x46B0
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function sndIGCsnapshot(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		switch(newVal)
		{
			case 1:
			{
				snd_set_snapshot("cmn_igc_bg_lower");
				level.sndIGCsnapshotOverride = 0;
				break;
			}
			case 2:
			{
				snd_set_snapshot("cmn_igc_amb_silent");
				level.sndIGCsnapshotOverride = 1;
				break;
			}
			case 3:
			{
				snd_set_snapshot("cmn_igc_foley_lower");
				level.sndIGCsnapshotOverride = 0;
				break;
			}
			case 4:
			{
				snd_set_snapshot("cmn_level_fadeout");
				level.sndIGCsnapshotOverride = 0;
				break;
			}
			case 5:
			{
				snd_set_snapshot("cmn_level_fade_immediate");
				level.sndIGCsnapshotOverride = 0;
				break;
			}
		}
	}
	else
	{
		level.sndIGCsnapshotOverride = 0;
		snd_set_snapshot("default");
	}
}

/*
	Name: sndLevelStartSnapOff
	Namespace: audio
	Checksum: 0x2D38D683
	Offset: 0x4828
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function sndLevelStartSnapOff(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!(isdefined(level.sndIGCsnapshotOverride) && level.sndIGCsnapshotOverride))
		{
			snd_set_snapshot("default");
		}
	}
}

/*
	Name: sndZMBFadeIn
	Namespace: audio
	Checksum: 0x2DF9160D
	Offset: 0x48A8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function sndZMBFadeIn(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		snd_set_snapshot("default");
	}
}

/*
	Name: sndChyronLoop
	Namespace: audio
	Checksum: 0xCD94760E
	Offset: 0x4910
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function sndChyronLoop(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!isdefined(level.chyronLoop))
		{
			level.chyronLoop = spawn(0, (0, 0, 0), "script_origin");
			level.chyronLoop PlayLoopSound("uin_chyron_loop");
		}
	}
	else if(isdefined(level.chyronLoop))
	{
		level.chyronLoop delete();
	}
}

