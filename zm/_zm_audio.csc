#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_audio;

/*
	Name: __init__sytem__
	Namespace: zm_audio
	Checksum: 0x70FF34DC
	Offset: 0x460
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_audio
	Checksum: 0x3F5A4146
	Offset: 0x4A0
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "charindex", 1, 3, "int", &charindex_cb, 0, 1);
	clientfield::register("toplayer", "isspeaking", 1, 1, "int", &isspeaking_cb, 0, 1);
	if(!isdefined(level.exert_sounds))
	{
		level.exert_sounds = [];
	}
	level.exert_sounds[0]["playerbreathinsound"] = "vox_exert_generic_inhale";
	level.exert_sounds[0]["playerbreathoutsound"] = "vox_exert_generic_exhale";
	level.exert_sounds[0]["playerbreathgaspsound"] = "vox_exert_generic_exhale";
	level.exert_sounds[0]["falldamage"] = "vox_exert_generic_pain";
	level.exert_sounds[0]["mantlesoundplayer"] = "vox_exert_generic_mantle";
	level.exert_sounds[0]["meleeswipesoundplayer"] = "vox_exert_generic_knifeswipe";
	level.exert_sounds[0]["dtplandsoundplayer"] = "vox_exert_generic_pain";
	level thread gameover_snapshot();
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: zm_audio
	Checksum: 0x2B6B900C
	Offset: 0x650
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localClientNum)
{
}

/*
	Name: delay_set_exert_id
	Namespace: zm_audio
	Checksum: 0x7E39EB96
	Offset: 0x668
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function delay_set_exert_id(newVal)
{
	self endon("entityshutdown");
	self endon("sndEndExertOverride");
	wait(0.5);
	self.player_exert_id = newVal;
}

/*
	Name: charindex_cb
	Namespace: zm_audio
	Checksum: 0x29D2394A
	Offset: 0x6A8
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function charindex_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!bNewEnt)
	{
		self.player_exert_id = newVal;
		self._first_frame_exert_id_recieved = 1;
		self notify("sndEndExertOverride");
	}
	else if(!isdefined(self._first_frame_exert_id_recieved))
	{
		self._first_frame_exert_id_recieved = 1;
		self thread delay_set_exert_id(newVal);
	}
}

/*
	Name: isspeaking_cb
	Namespace: zm_audio
	Checksum: 0x873C8808
	Offset: 0x758
	Size: 0x5F
	Parameters: 7
	Flags: None
*/
function isspeaking_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!bNewEnt)
	{
		self.isSpeaking = newVal;
	}
	else
	{
		self.isSpeaking = 0;
	}
}

/*
	Name: zmbMusLooper
	Namespace: zm_audio
	Checksum: 0xA67FE2BE
	Offset: 0x7C0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function zmbMusLooper()
{
	ent = spawn(0, (0, 0, 0), "script_origin");
	playsound(0, "mus_zmb_gamemode_start", (0, 0, 0));
	wait(10);
	ent PlayLoopSound("mus_zmb_gamemode_loop", 0.05);
	ent thread waitfor_music_stop();
}

/*
	Name: waitfor_music_stop
	Namespace: zm_audio
	Checksum: 0xA05676DE
	Offset: 0x860
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function waitfor_music_stop()
{
	level waittill("stpm");
	self StopAllLoopSounds(0.1);
	playsound(0, "mus_zmb_gamemode_end", (0, 0, 0));
	wait(1);
	self delete();
}

/*
	Name: playerFallDamageSound
	Namespace: zm_audio
	Checksum: 0x1C1044F8
	Offset: 0x8D0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function playerFallDamageSound(client_num, firstperson)
{
	self playerExert(client_num, "falldamage");
}

/*
	Name: clientVoiceSetup
	Namespace: zm_audio
	Checksum: 0xFC787F59
	Offset: 0x910
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function clientVoiceSetup()
{
	callback::on_localclient_connect(&audio_player_connect);
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		thread audio_player_connect(i);
	}
}

/*
	Name: audio_player_connect
	Namespace: zm_audio
	Checksum: 0xAD186B6F
	Offset: 0x998
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function audio_player_connect(localClientNum)
{
	thread sndVoNotifyPlain(localClientNum, "playerbreathinsound");
	thread sndVoNotifyPlain(localClientNum, "playerbreathoutsound");
	thread sndVoNotifyPlain(localClientNum, "playerbreathgaspsound");
	thread sndVoNotifyPlain(localClientNum, "mantlesoundplayer");
	thread sndVoNotifyPlain(localClientNum, "meleeswipesoundplayer");
	thread sndVoNotifyDTP(localClientNum, "dtplandsoundplayer");
}

/*
	Name: playerExert
	Namespace: zm_audio
	Checksum: 0x2DDB3A68
	Offset: 0xA70
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function playerExert(localClientNum, EXERT)
{
	if(isdefined(self.isSpeaking) && self.isSpeaking == 1)
	{
		return;
	}
	if(isdefined(self.beast_mode) && self.beast_mode)
	{
		return;
	}
	id = level.exert_sounds[0][EXERT];
	if(IsArray(level.exert_sounds[0][EXERT]))
	{
		id = Array::random(level.exert_sounds[0][EXERT]);
	}
	if(isdefined(self.player_exert_id))
	{
		if(IsArray(level.exert_sounds[self.player_exert_id][EXERT]))
		{
			id = Array::random(level.exert_sounds[self.player_exert_id][EXERT]);
		}
		else
		{
			id = level.exert_sounds[self.player_exert_id][EXERT];
		}
	}
	if(isdefined(id))
	{
		self playsound(localClientNum, id);
	}
}

/*
	Name: sndVoNotifyDTP
	Namespace: zm_audio
	Checksum: 0x5618D8BD
	Offset: 0xBD8
	Size: 0xC7
	Parameters: 2
	Flags: None
*/
function sndVoNotifyDTP(localClientNum, notifyString)
{
	level notify("kill_sndVoNotifyDTP" + localClientNum + notifyString);
	level endon("kill_sndVoNotifyDTP" + localClientNum + notifyString);
	player = undefined;
	while(!isdefined(player))
	{
		player = GetNonPredictedLocalPlayer(localClientNum);
		wait(0.05);
	}
	player endon("disconnect");
	for(;;)
	{
		player waittill(notifyString, surfaceType);
		player playerExert(localClientNum, notifyString);
	}
}

/*
	Name: sndMeleeSwipe
	Namespace: zm_audio
	Checksum: 0xDFC6F3A5
	Offset: 0xCA8
	Size: 0x207
	Parameters: 2
	Flags: None
*/
function sndMeleeSwipe(localClientNum, notifyString)
{
	player = undefined;
	while(!isdefined(player))
	{
		player = GetNonPredictedLocalPlayer(localClientNum);
		wait(0.05);
	}
	player endon("disconnect");
	for(;;)
	{
		player waittill(notifyString);
		currentWeapon = GetCurrentWeapon(localClientNum);
		if(isdefined(level.sndNoMeleeOnClient) && level.sndNoMeleeOnClient)
		{
			return;
		}
		if(isdefined(player.is_player_zombie) && player.is_player_zombie)
		{
			playsound(0, "zmb_melee_whoosh_zmb_plr", player.origin);
			continue;
		}
		if(currentWeapon.name == "bowie_knife")
		{
			playsound(0, "zmb_bowie_swing_plr", player.origin);
			continue;
		}
		if(currentWeapon.name == "spoon_zm_alcatraz")
		{
			playsound(0, "zmb_spoon_swing_plr", player.origin);
			continue;
		}
		if(currentWeapon.name == "spork_zm_alcatraz")
		{
			playsound(0, "zmb_spork_swing_plr", player.origin);
			continue;
		}
		playsound(0, "zmb_melee_whoosh_plr", player.origin);
	}
}

/*
	Name: sndVoNotifyPlain
	Namespace: zm_audio
	Checksum: 0x6C31D1F8
	Offset: 0xEB8
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function sndVoNotifyPlain(localClientNum, notifyString)
{
	level notify("kill_sndVoNotifyPlain" + localClientNum + notifyString);
	level endon("kill_sndVoNotifyPlain" + localClientNum + notifyString);
	player = undefined;
	while(!isdefined(player))
	{
		player = GetNonPredictedLocalPlayer(localClientNum);
		wait(0.05);
	}
	player endon("disconnect");
	for(;;)
	{
		player waittill(notifyString);
		if(isdefined(player.is_player_zombie) && player.is_player_zombie)
		{
			continue;
		}
		player playerExert(localClientNum, notifyString);
	}
}

/*
	Name: end_gameover_snapshot
	Namespace: zm_audio
	Checksum: 0xFD5EF33E
	Offset: 0xFA8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function end_gameover_snapshot()
{
	level util::waittill_any("demo_jump", "demo_player_switch", "snd_clear_script_duck");
	wait(1);
	audio::snd_set_snapshot("default");
	level thread gameover_snapshot();
}

/*
	Name: gameover_snapshot
	Namespace: zm_audio
	Checksum: 0x5E058B09
	Offset: 0x1020
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function gameover_snapshot()
{
	level waittill("zesn");
	audio::snd_set_snapshot("zmb_game_over");
	level thread end_gameover_snapshot();
}

/*
	Name: sndSetZombieContext
	Namespace: zm_audio
	Checksum: 0xFF5BBEFA
	Offset: 0x1070
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function sndSetZombieContext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self setsoundentcontext("grass", "no_grass");
	}
	else
	{
		self setsoundentcontext("grass", "in_grass");
	}
}

/*
	Name: sndZmbLaststand
	Namespace: zm_audio
	Checksum: 0x8B345A0C
	Offset: 0x1110
	Size: 0x14B
	Parameters: 7
	Flags: None
*/
function sndZmbLaststand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playsound(localClientNum, "chr_health_laststand_enter", (0, 0, 0));
		self.inLastStand = 1;
		setsoundcontext("laststand", "active");
		if(!IsSplitscreen())
		{
			forceambientroom("sndHealth_LastStand");
		}
	}
	else if(isdefined(self.inLastStand) && self.inLastStand)
	{
		playsound(localClientNum, "chr_health_laststand_exit", (0, 0, 0));
		self.inLastStand = 0;
		if(!IsSplitscreen())
		{
			forceambientroom("");
		}
	}
	setsoundcontext("laststand", "");
}

