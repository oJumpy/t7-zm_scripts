#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic_utils;

#namespace globallogic_audio;

/*
	Name: __init__sytem__
	Namespace: globallogic_audio
	Checksum: 0x57B19B2F
	Offset: 0xC48
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: globallogic_audio
	Checksum: 0xA157E38E
	Offset: 0xC88
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: globallogic_audio
	Checksum: 0x27620DBC
	Offset: 0xCB8
	Size: 0x10C3
	Parameters: 0
	Flags: None
*/
function init()
{
	game["music"]["defeat"] = "mus_defeat";
	game["music"]["victory_spectator"] = "mus_defeat";
	game["music"]["winning"] = "mus_time_running_out_winning";
	game["music"]["losing"] = "mus_time_running_out_losing";
	game["music"]["match_end"] = "mus_match_end";
	game["music"]["victory_tie"] = "mus_defeat";
	game["music"]["suspense"] = [];
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_01";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_02";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_03";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_04";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_05";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_06";
	game["dialog"]["mission_success"] = "mission_success";
	game["dialog"]["mission_failure"] = "mission_fail";
	game["dialog"]["mission_draw"] = "draw";
	game["dialog"]["round_success"] = "encourage_win";
	game["dialog"]["round_failure"] = "encourage_lost";
	game["dialog"]["round_draw"] = "draw";
	game["dialog"]["timesup"] = "timesup";
	game["dialog"]["winning"] = "winning";
	game["dialog"]["losing"] = "losing";
	game["dialog"]["min_draw"] = "min_draw";
	game["dialog"]["lead_lost"] = "lead_lost";
	game["dialog"]["lead_tied"] = "tied";
	game["dialog"]["lead_taken"] = "lead_taken";
	game["dialog"]["last_alive"] = "lastalive";
	game["dialog"]["boost"] = "generic_boost";
	if(!isdefined(game["dialog"]["offense_obj"]))
	{
		game["dialog"]["offense_obj"] = "generic_boost";
	}
	if(!isdefined(game["dialog"]["defense_obj"]))
	{
		game["dialog"]["defense_obj"] = "generic_boost";
	}
	game["dialog"]["hardcore"] = "hardcore";
	game["dialog"]["oldschool"] = "oldschool";
	game["dialog"]["highspeed"] = "highspeed";
	game["dialog"]["tactical"] = "tactical";
	game["dialog"]["challenge"] = "challengecomplete";
	game["dialog"]["promotion"] = "promotion";
	game["dialog"]["bomb_acquired"] = "sd_bomb_taken";
	game["dialog"]["bomb_taken"] = "sd_bomb_taken_taken";
	game["dialog"]["bomb_lost"] = "sd_bomb_drop";
	game["dialog"]["bomb_defused"] = "sd_bomb_defused";
	game["dialog"]["bomb_planted"] = "sd_bomb_planted";
	game["dialog"]["obj_taken"] = "securedobj";
	game["dialog"]["obj_lost"] = "lostobj";
	game["dialog"]["obj_defend"] = "defend_start";
	game["dialog"]["obj_destroy"] = "destroy_start";
	game["dialog"]["obj_capture"] = "capture_obj";
	game["dialog"]["objs_capture"] = "capture_objs";
	game["dialog"]["hq_located"] = "hq_located";
	game["dialog"]["hq_enemy_captured"] = "hq_capture";
	game["dialog"]["hq_enemy_destroyed"] = "hq_defend";
	game["dialog"]["hq_secured"] = "hq_secured";
	game["dialog"]["hq_offline"] = "hq_offline";
	game["dialog"]["hq_online"] = "hq_online";
	game["dialog"]["koth_located"] = "koth_located";
	game["dialog"]["koth_captured"] = "koth_captured";
	game["dialog"]["koth_lost"] = "koth_lost";
	game["dialog"]["koth_secured"] = "koth_secured";
	game["dialog"]["koth_contested"] = "koth_contest";
	game["dialog"]["koth_offline"] = "koth_offline";
	game["dialog"]["koth_online"] = "koth_online";
	game["dialog"]["move_to_new"] = "new_positions";
	game["dialog"]["attack"] = "attack";
	game["dialog"]["defend"] = "defend";
	game["dialog"]["offense"] = "offense";
	game["dialog"]["defense"] = "defense";
	game["dialog"]["halftime"] = "halftime";
	game["dialog"]["overtime"] = "overtime";
	game["dialog"]["side_switch"] = "switchingsides";
	game["dialog"]["flag_taken"] = "ourflag";
	game["dialog"]["flag_dropped"] = "ourflag_drop";
	game["dialog"]["flag_returned"] = "ourflag_return";
	game["dialog"]["flag_captured"] = "ourflag_capt";
	game["dialog"]["enemy_flag_taken"] = "enemyflag";
	game["dialog"]["enemy_flag_dropped"] = "enemyflag_drop";
	game["dialog"]["enemy_flag_returned"] = "enemyflag_return";
	game["dialog"]["enemy_flag_captured"] = "enemyflag_capt";
	game["dialog"]["securing_a"] = "dom_securing_a";
	game["dialog"]["securing_b"] = "dom_securing_b";
	game["dialog"]["securing_c"] = "dom_securing_c";
	game["dialog"]["securing_d"] = "dom_securing_d";
	game["dialog"]["securing_e"] = "dom_securing_e";
	game["dialog"]["securing_f"] = "dom_securing_f";
	game["dialog"]["secured_a"] = "dom_secured_a";
	game["dialog"]["secured_b"] = "dom_secured_b";
	game["dialog"]["secured_c"] = "dom_secured_c";
	game["dialog"]["secured_d"] = "dom_secured_d";
	game["dialog"]["secured_e"] = "dom_secured_e";
	game["dialog"]["secured_f"] = "dom_secured_f";
	game["dialog"]["losing_a"] = "dom_losing_a";
	game["dialog"]["losing_b"] = "dom_losing_b";
	game["dialog"]["losing_c"] = "dom_losing_c";
	game["dialog"]["losing_d"] = "dom_losing_d";
	game["dialog"]["losing_e"] = "dom_losing_e";
	game["dialog"]["losing_f"] = "dom_losing_f";
	game["dialog"]["lost_a"] = "dom_lost_a";
	game["dialog"]["lost_b"] = "dom_lost_b";
	game["dialog"]["lost_c"] = "dom_lost_c";
	game["dialog"]["lost_d"] = "dom_lost_d";
	game["dialog"]["lost_e"] = "dom_lost_e";
	game["dialog"]["lost_f"] = "dom_lost_f";
	game["dialog"]["secure_flag"] = "secure_flag";
	game["dialog"]["securing_flag"] = "securing_flag";
	game["dialog"]["losing_flag"] = "losing_flag";
	game["dialog"]["lost_flag"] = "lost_flag";
	game["dialog"]["oneflag_enemy"] = "oneflag_enemy";
	game["dialog"]["oneflag_friendly"] = "oneflag_friendly";
	game["dialog"]["lost_all"] = "dom_lock_theytake";
	game["dialog"]["secure_all"] = "dom_lock_wetake";
	game["dialog"]["squad_move"] = "squad_move";
	game["dialog"]["squad_30sec"] = "squad_30sec";
	game["dialog"]["squad_winning"] = "squad_onemin_vic";
	game["dialog"]["squad_losing"] = "squad_onemin_loss";
	game["dialog"]["squad_down"] = "squad_down";
	game["dialog"]["squad_bomb"] = "squad_bomb";
	game["dialog"]["squad_plant"] = "squad_plant";
	game["dialog"]["squad_take"] = "squad_takeobj";
	game["dialog"]["kicked"] = "player_kicked";
	game["dialog"]["sentry_destroyed"] = "dest_sentry";
	game["dialog"]["sentry_hacked"] = "kls_turret_hacked";
	game["dialog"]["microwave_destroyed"] = "dest_microwave";
	game["dialog"]["microwave_hacked"] = "kls_microwave_hacked";
	game["dialog"]["sam_destroyed"] = "dest_sam";
	game["dialog"]["tact_destroyed"] = "dest_tact";
	game["dialog"]["equipment_destroyed"] = "dest_equip";
	game["dialog"]["hacked_equip"] = "hacked_equip";
	game["dialog"]["uav_destroyed"] = "kls_u2_destroyed";
	game["dialog"]["cuav_destroyed"] = "kls_cu2_destroyed";
	level.dialogGroups = [];
	level thread post_match_snapshot_watcher();
}

/*
	Name: registerDialogGroup
	Namespace: globallogic_audio
	Checksum: 0xAB839279
	Offset: 0x1D88
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function registerDialogGroup(group, skipIfCurrentlyPlayingGroup)
{
	if(!isdefined(level.dialogGroups))
	{
		level.dialogGroups = [];
	}
	else if(isdefined(level.dialogGroup[group]))
	{
		util::error("registerDialogGroup:  Dialog group " + group + " already registered.");
		return;
	}
	level.dialogGroup[group] = spawnstruct();
	level.dialogGroup[group].group = group;
	level.dialogGroup[group].skipIfCurrentlyPlayingGroup = skipIfCurrentlyPlayingGroup;
	level.dialogGroup[group].currentCount = 0;
}

/*
	Name: sndStartMusicSystem
	Namespace: globallogic_audio
	Checksum: 0x51859829
	Offset: 0x1E78
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function sndStartMusicSystem()
{
	self endon("disconnect");
	if(game["state"] == "postgame")
	{
		return;
	}
	if(!isdefined(level.nextMusicState))
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
		self.pers["music"].currentState = "UNDERSCORE";
		self thread suspenseMusic();
	}
}

/*
	Name: suspenseMusicForPlayer
	Namespace: globallogic_audio
	Checksum: 0x31B64C40
	Offset: 0x1F30
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function suspenseMusicForPlayer()
{
	self endon("disconnect");
	self thread set_music_on_player("UNDERSCORE", 0);
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + self.pers["Dev Block strings are not supported"].returnState + "Dev Block strings are not supported" + self GetEntityNumber());
		}
	#/
}

/*
	Name: suspenseMusic
	Namespace: globallogic_audio
	Checksum: 0x7E5392BB
	Offset: 0x1FE0
	Size: 0x287
	Parameters: 1
	Flags: None
*/
function suspenseMusic(random)
{
	level endon("game_ended");
	level endon("match_ending_soon");
	self endon("disconnect");
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported");
		}
	#/
	while(1)
	{
		wait(randomIntRange(25, 60));
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
		if(!isdefined(self.pers["music"].inque))
		{
			self.pers["music"].inque = 0;
		}
		if(self.pers["music"].inque)
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					println("Dev Block strings are not supported");
				}
			#/
			continue;
		}
		if(!isdefined(self.pers["music"].currentState))
		{
			self.pers["music"].currentState = "SILENT";
		}
		if(RandomInt(100) < self.underscoreChance && self.pers["music"].currentState != "ACTION" && self.pers["music"].currentState != "TIME_OUT")
		{
			self thread suspenseMusicForPlayer();
			self.underscoreChance = self.underscoreChance - 20;
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					println("Dev Block strings are not supported");
				}
			#/
		}
	}
}

/*
	Name: leaderDialogForOtherTeams
	Namespace: globallogic_audio
	Checksum: 0xCE9A39A1
	Offset: 0x2270
	Size: 0xB9
	Parameters: 3
	Flags: None
*/
function leaderDialogForOtherTeams(dialog, skip_team, squad_dialog)
{
	foreach(team in level.teams)
	{
		if(team != skip_team)
		{
			leaderDialog(dialog, team, undefined, undefined, squad_dialog);
		}
	}
}

/*
	Name: announceRoundWinner
	Namespace: globallogic_audio
	Checksum: 0xAF97CD59
	Offset: 0x2338
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function announceRoundWinner(winner, delay)
{
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(winner) || isPlayer(winner))
	{
		return;
	}
	if(isdefined(level.teams[winner]))
	{
		leaderDialog("round_success", winner);
		leaderDialogForOtherTeams("round_failure", winner);
	}
	else
	{
		foreach(team in level.teams)
		{
			thread util::playSoundOnPlayers("mus_round_draw" + "_" + level.teamPostfix[team]);
		}
		leaderDialog("round_draw");
	}
}

/*
	Name: announceGameWinner
	Namespace: globallogic_audio
	Checksum: 0xE131F084
	Offset: 0x24A0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function announceGameWinner(winner, delay)
{
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(winner) || isPlayer(winner))
	{
		return;
	}
	if(isdefined(level.teams[winner]))
	{
		leaderDialog("mission_success", winner);
		leaderDialogForOtherTeams("mission_failure", winner);
	}
	else
	{
		leaderDialog("mission_draw");
	}
}

/*
	Name: doFlameAudio
	Namespace: globallogic_audio
	Checksum: 0x52569C2C
	Offset: 0x2568
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function doFlameAudio()
{
	self endon("disconnect");
	waittillframeend;
	if(!isdefined(self.lastFlameHurtAudio))
	{
		self.lastFlameHurtAudio = 0;
	}
	currentTime = GetTime();
	if(self.lastFlameHurtAudio + level.fire_audio_repeat_duration + RandomInt(level.fire_audio_random_max_duration) < currentTime)
	{
		self playlocalsound("vox_pain_small");
		self.lastFlameHurtAudio = currentTime;
	}
}

/*
	Name: leaderDialog
	Namespace: globallogic_audio
	Checksum: 0x4236B373
	Offset: 0x2608
	Size: 0x2B5
	Parameters: 5
	Flags: None
*/
function leaderDialog(dialog, team, group, excludeList, squadDialog)
{
	/#
		Assert(isdefined(level.players));
	#/
	if(level.Splitscreen)
	{
		return;
	}
	if(level.wagerMatch)
	{
		return;
	}
	if(!isdefined(team))
	{
		dialogs = [];
		foreach(team in level.teams)
		{
			dialogs[team] = dialog;
		}
		leaderDialogAllTeams(dialogs, group, excludeList);
		return;
	}
	if(level.Splitscreen)
	{
		if(level.players.size)
		{
			level.players[0] leaderDialogOnPlayer(dialog, group);
		}
		return;
	}
	if(isdefined(excludeList))
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pers["team"]) && player.pers["team"] == team && !globallogic_utils::isExcluded(player, excludeList))
			{
				player leaderDialogOnPlayer(dialog, group);
			}
		}
		break;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player leaderDialogOnPlayer(dialog, group);
		}
	}
}

/*
	Name: leaderDialogAllTeams
	Namespace: globallogic_audio
	Checksum: 0xA770B8FE
	Offset: 0x28C8
	Size: 0x17D
	Parameters: 3
	Flags: None
*/
function leaderDialogAllTeams(dialogs, group, excludeList)
{
	/#
		Assert(isdefined(level.players));
	#/
	if(level.Splitscreen)
	{
		return;
	}
	if(level.Splitscreen)
	{
		if(level.players.size)
		{
			level.players[0] leaderDialogOnPlayer(dialogs[level.players[0].team], group);
		}
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		team = player.pers["team"];
		if(!isdefined(team))
		{
			continue;
		}
		if(!isdefined(dialogs[team]))
		{
			continue;
		}
		if(isdefined(excludeList) && globallogic_utils::isExcluded(player, excludeList))
		{
			continue;
		}
		player leaderDialogOnPlayer(dialogs[team], group);
	}
}

/*
	Name: flushDialog
	Namespace: globallogic_audio
	Checksum: 0x49B0557C
	Offset: 0x2A50
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function flushDialog()
{
	foreach(player in level.players)
	{
		player flushDialogOnPlayer();
	}
}

/*
	Name: flushDialogOnPlayer
	Namespace: globallogic_audio
	Checksum: 0x8766FCCC
	Offset: 0x2AE8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function flushDialogOnPlayer()
{
	self.leaderDialogGroups = [];
	self.leaderDialogQueue = [];
	self.leaderDialogActive = 0;
	self.currentLeaderDialogGroup = "";
}

/*
	Name: flushGroupDialog
	Namespace: globallogic_audio
	Checksum: 0x2C8C089D
	Offset: 0x2B28
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function flushGroupDialog(group)
{
	foreach(player in level.players)
	{
		player flushGroupDialogOnPlayer(group);
	}
}

/*
	Name: flushGroupDialogOnPlayer
	Namespace: globallogic_audio
	Checksum: 0xFCCF40A5
	Offset: 0x2BD0
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function flushGroupDialogOnPlayer(group)
{
	self.leaderDialogGroups[group] = undefined;
	foreach(dialog in self.leaderDialogQueue)
	{
		if(dialog == group)
		{
			self.leaderDialogQueue[key] = undefined;
		}
	}
}

/*
	Name: addGroupDialogToPlayer
	Namespace: globallogic_audio
	Checksum: 0x2537C82B
	Offset: 0x2C80
	Size: 0x1E9
	Parameters: 2
	Flags: None
*/
function addGroupDialogToPlayer(dialog, group)
{
	if(!isdefined(level.dialogGroup[group]))
	{
		util::error("leaderDialogOnPlayer:  Dialog group " + group + " is not registered");
		return 0;
	}
	addToQueue = 0;
	if(!isdefined(self.leaderDialogGroups[group]))
	{
		addToQueue = 1;
	}
	if(!level.dialogGroup[group].skipIfCurrentlyPlayingGroup)
	{
		if(self.currentLeaderDialog == dialog && self.currentLeaderDialogTime + 2000 > GetTime())
		{
			self.leaderDialogGroups[group] = undefined;
			foreach(leader_dialog in self.leaderDialogQueue)
			{
				if(leader_dialog == group)
				{
					for(i = key + 1; i < self.leaderDialogQueue.size; i++)
					{
						self.leaderDialogQueue[i - 1] = self.leaderDialogQueue[i];
					}
					self.leaderDialogQueue[i - 1] = undefined;
					break;
				}
			}
			return 0;
		}
	}
	else if(self.currentLeaderDialogGroup == group)
	{
		return 0;
	}
	self.leaderDialogGroups[group] = dialog;
	return addToQueue;
}

/*
	Name: testDialogQueue
	Namespace: globallogic_audio
	Checksum: 0x7EB2B86E
	Offset: 0x2E78
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function testDialogQueue(group)
{
	/#
		count = 0;
		foreach(temp in self.leaderDialogQueue)
		{
			if(temp == group)
			{
				count++;
			}
		}
		if(count > 1)
		{
			shit = 0;
		}
	#/
}

/*
	Name: leaderDialogOnPlayer
	Namespace: globallogic_audio
	Checksum: 0xD8651EEB
	Offset: 0x2F48
	Size: 0xE5
	Parameters: 2
	Flags: None
*/
function leaderDialogOnPlayer(dialog, group)
{
	team = self.pers["team"];
	if(level.Splitscreen)
	{
		return;
	}
	if(!isdefined(team))
	{
		return;
	}
	if(!isdefined(level.teams[team]))
	{
		return;
	}
	if(isdefined(group))
	{
		if(!addGroupDialogToPlayer(dialog, group))
		{
			self testDialogQueue(group);
			return;
		}
		dialog = group;
	}
	if(!self.leaderDialogActive)
	{
		self thread playLeaderDialogOnPlayer(dialog);
	}
	else
	{
		self.leaderDialogQueue[self.leaderDialogQueue.size] = dialog;
	}
}

/*
	Name: waitForSound
	Namespace: globallogic_audio
	Checksum: 0xEEDF1044
	Offset: 0x3038
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function waitForSound(sound, extraTime)
{
	if(!isdefined(extraTime))
	{
		extraTime = 0.1;
	}
	time = soundgetplaybacktime(sound);
	if(time < 0)
	{
		wait(3 + extraTime);
	}
	else
	{
		wait(time * 0.001 + extraTime);
	}
}

/*
	Name: playLeaderDialogOnPlayer
	Namespace: globallogic_audio
	Checksum: 0xD23669E6
	Offset: 0x30C8
	Size: 0x293
	Parameters: 1
	Flags: None
*/
function playLeaderDialogOnPlayer(dialog)
{
	if(isdefined(level.allowAnnouncer) && !level.allowAnnouncer)
	{
		return;
	}
	team = self.pers["team"];
	self endon("disconnect");
	self.leaderDialogActive = 1;
	if(isdefined(self.leaderDialogGroups[dialog]))
	{
		group = dialog;
		dialog = self.leaderDialogGroups[group];
		self.leaderDialogGroups[group] = undefined;
		self.currentLeaderDialogGroup = group;
		self testDialogQueue(group);
	}
	if(level.wagerMatch || !isdefined(game["voice"]))
	{
		faction = "vox_wm_";
	}
	else
	{
		faction = game["voice"][team];
	}
	sound_name = faction + game["dialog"][dialog];
	if(level.allowAnnouncer)
	{
		self playlocalsound(sound_name);
		self.currentLeaderDialog = dialog;
		self.currentLeaderDialogTime = GetTime();
	}
	waitForSound(sound_name);
	self.leaderDialogActive = 0;
	self.currentLeaderDialogGroup = "";
	self.currentLeaderDialog = "";
	if(self.leaderDialogQueue.size > 0)
	{
		nextDialog = self.leaderDialogQueue[0];
		for(i = 1; i < self.leaderDialogQueue.size; i++)
		{
			self.leaderDialogQueue[i - 1] = self.leaderDialogQueue[i];
		}
		self.leaderDialogQueue[i - 1] = undefined;
		if(isdefined(self.leaderDialogGroups[dialog]))
		{
			self testDialogQueue(dialog);
		}
		self thread playLeaderDialogOnPlayer(nextDialog);
	}
}

/*
	Name: isTeamWinning
	Namespace: globallogic_audio
	Checksum: 0x5E34189F
	Offset: 0x3368
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function isTeamWinning(checkTeam)
{
	score = game["teamScores"][checkTeam];
	foreach(team in level.teams)
	{
		if(team != checkTeam)
		{
			if(game["teamScores"][team] >= score)
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: announceTeamIsWinning
	Namespace: globallogic_audio
	Checksum: 0xCF1FA321
	Offset: 0x3440
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function announceTeamIsWinning()
{
	foreach(team in level.teams)
	{
		if(isTeamWinning(team))
		{
			leaderDialog("winning", team, undefined, undefined, "squad_winning");
			leaderDialogForOtherTeams("losing", team, "squad_losing");
			return 1;
		}
	}
	return 0;
}

/*
	Name: musicController
	Namespace: globallogic_audio
	Checksum: 0xD17F15DF
	Offset: 0x3530
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function musicController()
{
	level endon("game_ended");
	level thread musicTimesOut();
	level waittill("match_ending_soon");
	if(util::isLastRound() || util::isOneRound())
	{
		if(!level.Splitscreen)
		{
			if(level.teambased)
			{
				if(!announceTeamIsWinning())
				{
					leaderDialog("min_draw");
				}
			}
			level waittill("match_ending_very_soon");
			foreach(team in level.teams)
			{
				leaderDialog("timesup", team, undefined, undefined, "squad_30sec");
			}
		}
	}
	else
	{
		level waittill("match_ending_vox");
		leaderDialog("timesup");
	}
}

/*
	Name: musicTimesOut
	Namespace: globallogic_audio
	Checksum: 0xEEF964E9
	Offset: 0x36B0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function musicTimesOut()
{
	level endon("game_ended");
	level waittill("match_ending_very_soon");
	thread set_music_on_team("TIME_OUT", "both", 1, 0);
}

/*
	Name: actionMusicSet
	Namespace: globallogic_audio
	Checksum: 0xF48B64E4
	Offset: 0x3700
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function actionMusicSet()
{
	level endon("game_ended");
	level.playingActionMusic = 1;
	wait(45);
	level.playingActionMusic = 0;
}

/*
	Name: play_2d_on_team
	Namespace: globallogic_audio
	Checksum: 0xF0F66B03
	Offset: 0x3738
	Size: 0xD5
	Parameters: 2
	Flags: None
*/
function play_2d_on_team(alias, team)
{
	/#
		Assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player playlocalsound(alias);
		}
	}
}

/*
	Name: set_music_on_team
	Namespace: globallogic_audio
	Checksum: 0x9E3D3CFD
	Offset: 0x3818
	Size: 0x2FD
	Parameters: 5
	Flags: None
*/
function set_music_on_team(State, team, save_state, return_state, wait_time)
{
	if(SessionModeIsZombiesGame())
	{
		return;
	}
	/#
		Assert(isdefined(level.players));
	#/
	if(!isdefined(team))
	{
		team = "both";
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	if(!isdefined(save_state))
	{
		save_sate = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	if(!isdefined(return_state))
	{
		return_state = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(team == "both")
		{
			player thread set_music_on_player(State, save_state, return_state, wait_time);
			continue;
		}
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player thread set_music_on_player(State, save_state, return_state, wait_time);
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					println("Dev Block strings are not supported" + State + "Dev Block strings are not supported" + player GetEntityNumber());
				}
			#/
		}
	}
}

/*
	Name: set_music_on_player
	Namespace: globallogic_audio
	Checksum: 0x51F55112
	Offset: 0x3B20
	Size: 0x423
	Parameters: 4
	Flags: None
*/
function set_music_on_player(State, save_state, return_state, wait_time)
{
	self endon("disconnect");
	if(SessionModeIsZombiesGame())
	{
		return;
	}
	/#
		Assert(isPlayer(self));
	#/
	if(!isdefined(save_state))
	{
		save_state = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	if(!isdefined(return_state))
	{
		return_state = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	if(!isdefined(State))
	{
		State = "UNDERSCORE";
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	music::setmusicstate(State, self);
	if(isdefined(self.pers["music"].currentState) && save_state)
	{
		self.pers["music"].returnState = State;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + self.pers["Dev Block strings are not supported"].returnState + "Dev Block strings are not supported" + self GetEntityNumber());
			}
		#/
	}
	self.pers["music"].previousState = self.pers["music"].currentState;
	self.pers["music"].currentState = State;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + State + "Dev Block strings are not supported" + self GetEntityNumber());
		}
	#/
	if(isdefined(self.pers["music"].returnState) && return_state)
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + self.pers["Dev Block strings are not supported"].returnState + "Dev Block strings are not supported" + self GetEntityNumber());
			}
		#/
		self set_next_music_state(self.pers["music"].returnState, wait_time);
	}
}

/*
	Name: return_music_state_player
	Namespace: globallogic_audio
	Checksum: 0x8CED2F82
	Offset: 0x3F50
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function return_music_state_player(wait_time)
{
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	self set_next_music_state(self.pers["music"].returnState, wait_time);
}

/*
	Name: return_music_state_team
	Namespace: globallogic_audio
	Checksum: 0xAA3E54F5
	Offset: 0x3FF0
	Size: 0x1DD
	Parameters: 2
	Flags: None
*/
function return_music_state_team(team, wait_time)
{
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported");
			}
		#/
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(team == "both")
		{
			player thread set_next_music_state(self.pers["music"].returnState, wait_time);
			continue;
		}
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player thread set_next_music_state(self.pers["music"].returnState, wait_time);
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					println("Dev Block strings are not supported" + self.pers["Dev Block strings are not supported"].returnState + "Dev Block strings are not supported" + player GetEntityNumber());
				}
			#/
		}
	}
}

/*
	Name: set_next_music_state
	Namespace: globallogic_audio
	Checksum: 0xEC443CF2
	Offset: 0x41D8
	Size: 0x1BB
	Parameters: 2
	Flags: None
*/
function set_next_music_state(nextstate, wait_time)
{
	self endon("disconnect");
	self.pers["music"].nextstate = nextstate;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + self.pers["Dev Block strings are not supported"].nextstate + "Dev Block strings are not supported" + self GetEntityNumber());
		}
	#/
	if(!isdefined(self.pers["music"].inque))
	{
		self.pers["music"].inque = 0;
	}
	if(self.pers["music"].inque)
	{
		return;
		/#
			println("Dev Block strings are not supported");
		#/
	}
	else
	{
		self.pers["music"].inque = 1;
		if(wait_time)
		{
			wait(wait_time);
		}
		self set_music_on_player(self.pers["music"].nextstate, 0);
		self.pers["music"].inque = 0;
	}
}

/*
	Name: getRoundSwitchDialog
	Namespace: globallogic_audio
	Checksum: 0xC7C47AAF
	Offset: 0x43A0
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function getRoundSwitchDialog(switchType)
{
	switch(switchType)
	{
		case "halftime":
		{
			return "halftime";
		}
		case "overtime":
		{
			return "overtime";
		}
		case default:
		{
			return "side_switch";
		}
	}
}

/*
	Name: post_match_snapshot_watcher
	Namespace: globallogic_audio
	Checksum: 0x4BEEF10F
	Offset: 0x43F8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function post_match_snapshot_watcher()
{
	level waittill("game_ended");
	level util::clientNotify("pm");
	level waittill("sfade");
	level util::clientNotify("pmf");
}

