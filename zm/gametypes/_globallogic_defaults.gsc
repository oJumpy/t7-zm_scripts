#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_spawnlogic;

#namespace globallogic_defaults;

/*
	Name: getWinningTeamFromLoser
	Namespace: globallogic_defaults
	Checksum: 0x14D14D3D
	Offset: 0x2B0
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function getWinningTeamFromLoser(losing_team)
{
	if(level.multiTeam)
	{
		return "tie";
	}
	return util::getOtherTeam(losing_team);
}

/*
	Name: default_onForfeit
	Namespace: globallogic_defaults
	Checksum: 0xAE330B20
	Offset: 0x2F0
	Size: 0x2C3
	Parameters: 1
	Flags: None
*/
function default_onForfeit(team)
{
	level.gameForfeited = 1;
	level notify("forfeit in progress");
	level endon("forfeit in progress");
	level endon("abort forfeit");
	forfeit_delay = 20;
	announcement(game["strings"]["opponent_forfeiting_in"], forfeit_delay, 0);
	wait(10);
	announcement(game["strings"]["opponent_forfeiting_in"], 10, 0);
	wait(10);
	endReason = &"";
	if(!isdefined(team))
	{
		SetDvar("ui_text_endreason", game["strings"]["players_forfeited"]);
		endReason = game["strings"]["players_forfeited"];
		winner = level.players[0];
	}
	else if(isdefined(level.teams[team]))
	{
		endReason = game["strings"][team + "_forfeited"];
		SetDvar("ui_text_endreason", endReason);
		winner = getWinningTeamFromLoser(team);
	}
	else
	{
		Assert(isdefined(team), "Dev Block strings are not supported");
		/#
			Assert(0, "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		winner = "tie";
	}
	/#
	#/
	level.forcedEnd = 1;
	/#
		if(isPlayer(winner))
		{
			print("Dev Block strings are not supported" + winner getXuid() + "Dev Block strings are not supported" + winner.name + "Dev Block strings are not supported");
		}
		else
		{
			globallogic_utils::logTeamWinString("Dev Block strings are not supported", winner);
		}
	#/
	thread globallogic::endGame(winner, endReason);
}

/*
	Name: default_onDeadEvent
	Namespace: globallogic_defaults
	Checksum: 0x5FBEAD3
	Offset: 0x5C0
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function default_onDeadEvent(team)
{
	if(isdefined(level.teams[team]))
	{
		eliminatedString = game["strings"][team + "_eliminated"];
		iprintln(eliminatedString);
		SetDvar("ui_text_endreason", eliminatedString);
		winner = getWinningTeamFromLoser(team);
		globallogic_utils::logTeamWinString("team eliminated", winner);
		thread globallogic::endGame(winner, eliminatedString);
	}
	else
	{
		SetDvar("ui_text_endreason", game["strings"]["tie"]);
		globallogic_utils::logTeamWinString("tie");
		if(level.teambased)
		{
			thread globallogic::endGame("tie", game["strings"]["tie"]);
		}
		else
		{
			thread globallogic::endGame(undefined, game["strings"]["tie"]);
		}
	}
}

/*
	Name: default_onAliveCountChange
	Namespace: globallogic_defaults
	Checksum: 0x4F978BC1
	Offset: 0x750
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function default_onAliveCountChange(team)
{
}

/*
	Name: default_onRoundEndGame
	Namespace: globallogic_defaults
	Checksum: 0xCCD9333A
	Offset: 0x768
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function default_onRoundEndGame(winner)
{
	return winner;
}

/*
	Name: default_onOneLeftEvent
	Namespace: globallogic_defaults
	Checksum: 0xB23BC7EE
	Offset: 0x780
	Size: 0x16D
	Parameters: 1
	Flags: None
*/
function default_onOneLeftEvent(team)
{
	if(!level.teambased)
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
			if(isdefined(winner))
			{
				print("Dev Block strings are not supported" + winner.name);
			}
			else
			{
				print("Dev Block strings are not supported");
			}
		#/
		thread globallogic::endGame(winner, &"MP_ENEMIES_ELIMINATED");
		break;
	}
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(!isalive(player))
		{
			continue;
		}
		if(!isdefined(player.pers["team"]) || player.pers["team"] != team)
		{
			continue;
		}
		player globallogic_audio::leaderDialogOnPlayer("sudden_death");
	}
}

/*
	Name: default_onTimeLimit
	Namespace: globallogic_defaults
	Checksum: 0x49F6D004
	Offset: 0x8F8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function default_onTimeLimit()
{
	winner = undefined;
	if(level.teambased)
	{
		winner = globallogic::determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString("time limit", winner);
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
			if(isdefined(winner))
			{
				print("Dev Block strings are not supported" + winner.name);
			}
			else
			{
				print("Dev Block strings are not supported");
			}
		#/
	}
	SetDvar("ui_text_endreason", game["strings"]["time_limit_reached"]);
	thread globallogic::endGame(winner, game["strings"]["time_limit_reached"]);
}

/*
	Name: default_onScoreLimit
	Namespace: globallogic_defaults
	Checksum: 0x97EFAFFD
	Offset: 0xA28
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function default_onScoreLimit()
{
	if(!level.endGameOnScoreLimit)
	{
		return 0;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = globallogic::determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString("scorelimit", winner);
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
			if(isdefined(winner))
			{
				print("Dev Block strings are not supported" + winner.name);
			}
			else
			{
				print("Dev Block strings are not supported");
			}
		#/
	}
	SetDvar("ui_text_endreason", game["strings"]["score_limit_reached"]);
	thread globallogic::endGame(winner, game["strings"]["score_limit_reached"]);
	return 1;
}

/*
	Name: default_onSpawnSpectator
	Namespace: globallogic_defaults
	Checksum: 0x8CF46196
	Offset: 0xB68
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function default_onSpawnSpectator(origin, angles)
{
	if(isdefined(origin) && isdefined(angles))
	{
		self spawn(origin, angles);
		return;
	}
	spawnPointName = "mp_global_intermission";
	Spawnpoints = GetEntArray(spawnPointName, "classname");
	/#
		Assert(Spawnpoints.size, "Dev Block strings are not supported");
	#/
	spawnpoint = spawnlogic::getSpawnpoint_Random(Spawnpoints);
	self spawn(spawnpoint.origin, spawnpoint.angles);
}

/*
	Name: default_onSpawnIntermission
	Namespace: globallogic_defaults
	Checksum: 0x36A195A3
	Offset: 0xC70
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function default_onSpawnIntermission()
{
	spawnPointName = "mp_global_intermission";
	Spawnpoints = GetEntArray(spawnPointName, "classname");
	spawnpoint = Spawnpoints[0];
	if(isdefined(spawnpoint))
	{
		self spawn(spawnpoint.origin, spawnpoint.angles);
	}
	else
	{
		util::error("Dev Block strings are not supported" + spawnPointName + "Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: default_getTimeLimit
	Namespace: globallogic_defaults
	Checksum: 0xED10C520
	Offset: 0xD38
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function default_getTimeLimit()
{
	return math::clamp(GetGametypeSetting("timeLimit"), level.timeLimitMin, level.timeLimitMax);
}

