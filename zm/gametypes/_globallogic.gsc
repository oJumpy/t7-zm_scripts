#using scripts\codescripts\struct;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\music_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_challenges;
#using scripts\zm\_rat;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_dev;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_defaults;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hostmigration;
#using scripts\zm\gametypes\_hud_message;
#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_weapon_utils;
#using scripts\zm\gametypes\_weaponobjects;
#using scripts\zm\gametypes\_weapons;

#namespace globallogic;

/*
	Name: init
	Namespace: globallogic
	Checksum: 0x77414DF0
	Offset: 0x1268
	Size: 0x7E3
	Parameters: 0
	Flags: None
*/
function init()
{
	level.language = GetDvarString("language");
	level.Splitscreen = IsSplitscreen();
	level.xenon = GetDvarString("xenonGame") == "true";
	level.ps3 = GetDvarString("ps3Game") == "true";
	level.wiiu = GetDvarString("wiiuGame") == "true";
	level.orbis = GetDvarString("orbisGame") == "true";
	level.durango = GetDvarString("durangoGame") == "true";
	level.createFX_disable_fx = GetDvarInt("disable_fx") == 1;
	level.onlineGame = SessionModeIsOnlineGame();
	level.systemLink = SessionModeIsSystemlink();
	level.console = level.xenon || level.ps3 || level.wiiu || level.orbis || level.durango;
	level.rankedMatch = GameModeIsUsingXP();
	level.leagueMatch = 0;
	level.arenaMatch = 0;
	level.wagerMatch = 0;
	level.contractsEnabled = !GetGametypeSetting("disableContracts");
	level.contractsEnabled = 0;
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			level.rankedMatch = 1;
		}
	#/
	level.script = ToLower(GetDvarString("mapname"));
	level.gametype = ToLower(GetDvarString("g_gametype"));
	level.teambased = 0;
	level.teamCount = GetGametypeSetting("teamCount");
	level.multiTeam = level.teamCount > 2;
	if(SessionModeIsZombiesGame())
	{
		level.zombie_team_index = level.teamCount + 1;
		if(2 == level.zombie_team_index)
		{
			level.zombie_team = "axis";
		}
		else
		{
			level.zombie_team = "team" + level.zombie_team_index;
		}
	}
	level.teams = [];
	level.teamIndex = [];
	teamCount = level.teamCount;
	level.teams["allies"] = "allies";
	level.teams["axis"] = "axis";
	level.teamIndex["neutral"] = 0;
	level.teamIndex["allies"] = 1;
	level.teamIndex["axis"] = 2;
	for(teamIndex = 3; teamIndex <= teamCount; teamIndex++)
	{
		level.teams["team" + teamIndex] = "team" + teamIndex;
		level.teamIndex["team" + teamIndex] = teamIndex;
	}
	level.overrideTeamScore = 0;
	level.overridePlayerScore = 0;
	level.displayHalftimeText = 0;
	level.displayRoundEndText = 1;
	level.endGameOnScoreLimit = 1;
	level.endGameOnTimeLimit = 1;
	level.scoreRoundWinBased = 0;
	level.resetPlayerScoreEveryRound = 0;
	level.gameForfeited = 0;
	level.forceAutoAssign = 0;
	level.halftimeType = "halftime";
	level.halftimeSubCaption = &"MP_SWITCHING_SIDES_CAPS";
	level.lastStatusTime = 0;
	level.wasWinning = [];
	level.lastSlowProcessFrame = 0;
	level.placement = [];
	foreach(team in level.teams)
	{
		level.placement[team] = [];
	}
	level.placement["all"] = [];
	level.postRoundTime = 7;
	level.inOvertime = 0;
	level.defaultOffenseRadius = 560;
	level.dropTeam = GetDvarInt("sv_maxclients");
	level.inFinalKillcam = 0;
	registerDvars();
	level.oldschool = GetDvarInt("scr_oldschool") == 1;
	if(level.oldschool)
	{
		/#
			print("Dev Block strings are not supported");
		#/
		SetDvar("jump_height", 64);
		SetDvar("jump_slowdownEnable", 0);
		SetDvar("bg_fallDamageMinHeight", 256);
		SetDvar("bg_fallDamageMaxHeight", 512);
		SetDvar("player_clipSizeMultiplier", 2);
	}
	precache_mp_leaderboards();
	if(!isdefined(game["tiebreaker"]))
	{
		game["tiebreaker"] = 0;
	}
	globallogic_audio::registerDialogGroup("item_destroyed", 1);
	globallogic_audio::registerDialogGroup("introboost", 1);
	globallogic_audio::registerDialogGroup("status", 1);
	level.playersDrivingVehiclesBecomeInvulnerable = 1;
	level.figure_out_attacker = &globallogic_player::figureOutAttacker;
	level.figure_out_friendly_fire = &globallogic_player::figureOutFriendlyFire;
	level.get_base_weapon_param = &weapon_utils::getBaseWeaponParam;
}

/*
	Name: registerDvars
	Namespace: globallogic
	Checksum: 0x1122D582
	Offset: 0x1A58
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function registerDvars()
{
	if(GetDvarString("scr_oldschool") == "")
	{
		SetDvar("scr_oldschool", "0");
	}
	if(GetDvarString("ui_guncycle") == "")
	{
		SetDvar("ui_guncycle", 0);
	}
	if(GetDvarString("ui_weapon_tiers") == "")
	{
		SetDvar("ui_weapon_tiers", 0);
	}
	SetDvar("ui_text_endreason", "");
	SetMatchFlag("bomb_timer", 0);
	if(GetDvarString("scr_vehicle_damage_scalar") == "")
	{
		SetDvar("scr_vehicle_damage_scalar", "1");
	}
	level.vehicleDamageScalar = GetDvarFloat("scr_vehicle_damage_scalar");
	level.fire_audio_repeat_duration = GetDvarInt("fire_audio_repeat_duration");
	level.fire_audio_random_max_duration = GetDvarInt("fire_audio_random_max_duration");
}

/*
	Name: blank
	Namespace: globallogic
	Checksum: 0x46187FD1
	Offset: 0x1C10
	Size: 0x53
	Parameters: 10
	Flags: None
*/
function blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
{
}

/*
	Name: SetupCallbacks
	Namespace: globallogic
	Checksum: 0x5F32B867
	Offset: 0x1C70
	Size: 0x473
	Parameters: 0
	Flags: None
*/
function SetupCallbacks()
{
	level.spawnPlayer = &globallogic_spawn::spawnPlayer;
	level.spawnPlayerPrediction = &globallogic_spawn::spawnPlayerPrediction;
	level.spawnClient = &globallogic_spawn::spawnClient;
	level.spawnSpectator = &globallogic_spawn::spawnSpectator;
	level.spawnIntermission = &globallogic_spawn::spawnIntermission;
	level.scoreOnGivePlayerScore = &globallogic_score::givePlayerScore;
	level.onPlayerScore = &globallogic_score::default_onPlayerScore;
	level.onTeamScore = &globallogic_score::default_onTeamScore;
	level.waveSpawnTimer = &waveSpawnTimer;
	level.spawnMessage = &globallogic_spawn::default_spawnMessage;
	level.onSpawnPlayer = &blank;
	level.onSpawnPlayerUnified = &blank;
	level.onSpawnSpectator = &globallogic_defaults::default_onSpawnSpectator;
	level.onSpawnIntermission = &globallogic_defaults::default_onSpawnIntermission;
	level.onRespawnDelay = &blank;
	level.onForfeit = &globallogic_defaults::default_onForfeit;
	level.onTimeLimit = &globallogic_defaults::default_onTimeLimit;
	level.onScoreLimit = &globallogic_defaults::default_onScoreLimit;
	level.onAliveCountChange = &globallogic_defaults::default_onAliveCountChange;
	level.onDeadEvent = &globallogic_defaults::default_onDeadEvent;
	level.onOneLeftEvent = &globallogic_defaults::default_onOneLeftEvent;
	level.giveTeamScore = &globallogic_score::giveTeamScore;
	level.onLastTeamAliveEvent = undefined;
	level.getTimePassed = &globallogic_utils::getTimePassed;
	level.getTimeLimit = &globallogic_defaults::default_getTimeLimit;
	level.getTeamKillPenalty = &blank;
	level.getTeamKillScore = &blank;
	level.isKillBoosting = &globallogic_score::default_isKillBoosting;
	level._setTeamScore = &globallogic_score::_setTeamScore;
	level._setPlayerScore = &globallogic_score::_setPlayerScore;
	level._getTeamScore = &globallogic_score::_getTeamScore;
	level._getPlayerScore = &globallogic_score::_getPlayerScore;
	level.onPrecacheGameType = &blank;
	level.onStartGameType = &blank;
	level.onPlayerConnect = &blank;
	level.onPlayerDisconnect = &blank;
	level.onPlayerDamage = &blank;
	level.onPlayerKilled = &blank;
	level.onPlayerKilledExtraUnthreadedCBs = [];
	level.onTeamOutcomeNotify = &hud_message::teamOutcomeNotify;
	level.onOutcomeNotify = &hud_message::outcomeNotify;
	level.onTeamWagerOutcomeNotify = &hud_message::teamWagerOutcomeNotify;
	level.onWagerOutcomeNotify = &hud_message::wagerOutcomeNotify;
	level.setMatchScoreHUDElemForTeam = &hud_message::setMatchScoreHUDElemForTeam;
	level.onEndGame = &blank;
	level.onRoundEndGame = &globallogic_defaults::default_onRoundEndGame;
	level.onMedalAwarded = &blank;
	level.dogManagerOnGetDogs = &blank;
	globallogic_ui::SetupCallbacks();
}

/*
	Name: precache_mp_leaderboards
	Namespace: globallogic
	Checksum: 0x1A3FE2AD
	Offset: 0x20F0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function precache_mp_leaderboards()
{
	if(SessionModeIsZombiesGame())
	{
		return;
	}
	if(!level.rankedMatch)
	{
		return;
	}
	mapname = GetDvarString("mapname");
	globalLeaderboards = "LB_MP_GB_XPPRESTIGE LB_MP_GB_TOTALXP_AT LB_MP_GB_TOTALXP_LT LB_MP_GB_WINS_AT LB_MP_GB_WINS_LT LB_MP_GB_KILLS_AT LB_MP_GB_KILLS_LT LB_MP_GB_ACCURACY_AT LB_MP_GB_ACCURACY_LT";
	gamemodeLeaderboard = " LB_MP_GM_" + level.gametype;
	if(GetDvarInt("g_hardcore"))
	{
		gamemodeLeaderboard = gamemodeLeaderboard + "_HC";
	}
	mapLeaderboard = " LB_MP_MAP_" + GetSubStr(mapname, 3, mapname.size);
	precacheLeaderboards(globalLeaderboards + gamemodeLeaderboard + mapLeaderboard);
}

/*
	Name: compareTeamByGameStat
	Namespace: globallogic
	Checksum: 0x3E523075
	Offset: 0x2200
	Size: 0xE5
	Parameters: 4
	Flags: None
*/
function compareTeamByGameStat(gameStat, teamA, teamB, previous_winner_score)
{
	winner = undefined;
	if(teamA == "tie")
	{
		winner = "tie";
		if(previous_winner_score < game[gameStat][teamB])
		{
			winner = teamB;
		}
	}
	else if(game[gameStat][teamA] == game[gameStat][teamB])
	{
		winner = "tie";
	}
	else if(game[gameStat][teamB] > game[gameStat][teamA])
	{
		winner = teamB;
	}
	else
	{
		winner = teamA;
	}
	return winner;
}

/*
	Name: determineTeamWinnerByGameStat
	Namespace: globallogic
	Checksum: 0xF3CEF4BA
	Offset: 0x22F0
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function determineTeamWinnerByGameStat(gameStat)
{
	teamKeys = getArrayKeys(level.teams);
	winner = teamKeys[0];
	previous_winner_score = game[gameStat][winner];
	for(teamIndex = 1; teamIndex < teamKeys.size; teamIndex++)
	{
		winner = compareTeamByGameStat(gameStat, winner, teamKeys[teamIndex], previous_winner_score);
		if(winner != "tie")
		{
			previous_winner_score = game[gameStat][winner];
		}
	}
	return winner;
}

/*
	Name: compareTeamByTeamScore
	Namespace: globallogic
	Checksum: 0x108CCFBA
	Offset: 0x23E0
	Size: 0xED
	Parameters: 3
	Flags: None
*/
function compareTeamByTeamScore(teamA, teamB, previous_winner_score)
{
	winner = undefined;
	teamBScore = [[level._getTeamScore]](teamB);
	if(teamA == "tie")
	{
		winner = "tie";
		if(previous_winner_score < teamBScore)
		{
			winner = teamB;
		}
		return winner;
	}
	teamAScore = [[level._getTeamScore]](teamA);
	if(teamBScore == teamAScore)
	{
		winner = "tie";
	}
	else if(teamBScore > teamAScore)
	{
		winner = teamB;
	}
	else
	{
		winner = teamA;
	}
	return winner;
}

/*
	Name: determineTeamWinnerByTeamScore
	Namespace: globallogic
	Checksum: 0xF50AE9D5
	Offset: 0x24D8
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function determineTeamWinnerByTeamScore()
{
	teamKeys = getArrayKeys(level.teams);
	winner = teamKeys[0];
	previous_winner_score = [[level._getTeamScore]](winner);
	for(teamIndex = 1; teamIndex < teamKeys.size; teamIndex++)
	{
		winner = compareTeamByTeamScore(winner, teamKeys[teamIndex], previous_winner_score);
		if(winner != "tie")
		{
			previous_winner_score = [[level._getTeamScore]](winner);
		}
	}
	return winner;
}

/*
	Name: forceEnd
	Namespace: globallogic
	Checksum: 0x7C74E04D
	Offset: 0x25C0
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function forceEnd(hostsucks)
{
	if(!isdefined(hostsucks))
	{
		hostsucks = 0;
	}
	if(level.hostForcedEnd || level.forcedEnd)
	{
		return;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString("host ended game", winner);
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
	level.forcedEnd = 1;
	level.hostForcedEnd = 1;
	if(hostsucks)
	{
		endString = &"MP_HOST_SUCKS";
	}
	else if(level.Splitscreen)
	{
		endString = &"MP_ENDED_GAME";
	}
	else
	{
		endString = &"MP_HOST_ENDED_GAME";
	}
	SetMatchFlag("disableIngameMenu", 1);
	SetDvar("ui_text_endreason", endString);
	thread endGame(winner, endString);
}

/*
	Name: killserverPc
	Namespace: globallogic
	Checksum: 0xEF37A8AD
	Offset: 0x2780
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function killserverPc()
{
	if(level.hostForcedEnd || level.forcedEnd)
	{
		return;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString("host ended game", winner);
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
	level.forcedEnd = 1;
	level.hostForcedEnd = 1;
	level.killserver = 1;
	endString = &"MP_HOST_ENDED_GAME";
	/#
		println("Dev Block strings are not supported");
	#/
	thread endGame(winner, endString);
}

/*
	Name: someoneOnEachTeam
	Namespace: globallogic
	Checksum: 0x88491E33
	Offset: 0x28D8
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function someoneOnEachTeam()
{
	foreach(team in level.teams)
	{
		if(level.playerCount[team] == 0)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: checkIfTeamForfeits
	Namespace: globallogic
	Checksum: 0xF80F9DD
	Offset: 0x2978
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function checkIfTeamForfeits(team)
{
	if(!level.everExisted[team])
	{
		return 0;
	}
	if(level.playerCount[team] < 1 && util::totalPlayerCount() > 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: checkForAnyTeamForfeit
	Namespace: globallogic
	Checksum: 0x764F3F11
	Offset: 0x29E0
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function checkForAnyTeamForfeit()
{
	foreach(team in level.teams)
	{
		if(checkIfTeamForfeits(team))
		{
			thread [[level.onForfeit]](team);
			return 1;
		}
	}
	return 0;
}

/*
	Name: doSpawnQueueUpdates
	Namespace: globallogic
	Checksum: 0x757A8050
	Offset: 0x2A90
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function doSpawnQueueUpdates()
{
	foreach(team in level.teams)
	{
		if(level.spawnQueueModified[team])
		{
			[[level.onAliveCountChange]](team);
		}
	}
}

/*
	Name: isTeamAllDead
	Namespace: globallogic
	Checksum: 0xF3DECE44
	Offset: 0x2B38
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function isTeamAllDead(team)
{
	return level.everExisted[team] && !level.aliveCount[team] && !level.playerLives[team];
}

/*
	Name: areAllTeamsDead
	Namespace: globallogic
	Checksum: 0x4A5686A4
	Offset: 0x2B80
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function areAllTeamsDead()
{
	foreach(team in level.teams)
	{
		if(!isTeamAllDead(team))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: allDeadTeamCount
	Namespace: globallogic
	Checksum: 0x14E870B1
	Offset: 0x2C20
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function allDeadTeamCount()
{
	count = 0;
	foreach(team in level.teams)
	{
		if(isTeamAllDead(team))
		{
			count++;
		}
	}
	return count;
}

/*
	Name: doDeadEventUpdates
	Namespace: globallogic
	Checksum: 0x9965D25E
	Offset: 0x2CD0
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function doDeadEventUpdates()
{
	if(level.teambased)
	{
		if(areAllTeamsDead())
		{
			[[level.onDeadEvent]]("all");
			return 1;
		}
		if(isdefined(level.onLastTeamAliveEvent))
		{
			if(allDeadTeamCount() == level.teams.size - 1)
			{
				foreach(team in level.teams)
				{
					if(!isTeamAllDead(team))
					{
						[[level.onLastTeamAliveEvent]](team);
						return 1;
					}
				}
			}
			break;
		}
		foreach(team in level.teams)
		{
			if(isTeamAllDead(team))
			{
				[[level.onDeadEvent]](team);
				return 1;
			}
		}
	}
	else if(totalAliveCount() == 0 && totalPlayerLives() == 0 && level.maxPlayerCount > 1)
	{
		[[level.onDeadEvent]]("all");
		return 1;
	}
	return 0;
}

/*
	Name: isOnlyOneLeftAliveOnTeam
	Namespace: globallogic
	Checksum: 0xFFF5424A
	Offset: 0x2F00
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function isOnlyOneLeftAliveOnTeam(team)
{
	return level.lastAliveCount[team] > 1 && level.aliveCount[team] == 1 && level.playerLives[team] == 1;
}

/*
	Name: doOneLeftEventUpdates
	Namespace: globallogic
	Checksum: 0x771A1452
	Offset: 0x2F58
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function doOneLeftEventUpdates()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(isOnlyOneLeftAliveOnTeam(team))
			{
				[[level.onOneLeftEvent]](team);
				return 1;
			}
		}
	}
	else if(totalAliveCount() == 1 && totalPlayerLives() == 1 && level.maxPlayerCount > 1)
	{
		[[level.onOneLeftEvent]]("all");
		return 1;
	}
	return 0;
}

/*
	Name: updateGameEvents
	Namespace: globallogic
	Checksum: 0x79B2DE8B
	Offset: 0x3080
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function updateGameEvents()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			return;
		}
	#/
	if(level.rankedMatch || level.wagerMatch || level.leagueMatch && !level.inGracePeriod)
	{
		if(level.teambased)
		{
			if(!level.gameForfeited)
			{
				if(game["state"] == "playing" && checkForAnyTeamForfeit())
				{
					return;
				}
			}
			else if(someoneOnEachTeam())
			{
				level.gameForfeited = 0;
				level notify("abort forfeit");
			}
		}
		else if(!level.gameForfeited)
		{
			if(util::totalPlayerCount() == 1 && level.maxPlayerCount > 1)
			{
				thread [[level.onForfeit]]();
				return;
			}
		}
		else if(util::totalPlayerCount() > 1)
		{
			level.gameForfeited = 0;
			level notify("abort forfeit");
		}
	}
	if(!level.playerQueuedRespawn && !level.numLives && !level.inOvertime)
	{
		return;
	}
	if(level.inGracePeriod)
	{
		return;
	}
	if(level.playerQueuedRespawn)
	{
		doSpawnQueueUpdates();
	}
	if(doDeadEventUpdates())
	{
		return;
	}
	if(doOneLeftEventUpdates())
	{
		return;
	}
}

/*
	Name: matchStartTimer
	Namespace: globallogic
	Checksum: 0x374702E7
	Offset: 0x3268
	Size: 0x2CB
	Parameters: 0
	Flags: None
*/
function matchStartTimer()
{
	matchStartText = hud::createServerFontString("objective", 1.5);
	matchStartText hud::setPoint("CENTER", "CENTER", 0, -40);
	matchStartText.sort = 1001;
	matchStartText setText(game["strings"]["waiting_for_teams"]);
	matchStartText.foreground = 0;
	matchStartText.hidewheninmenu = 1;
	waitForPlayers();
	matchStartText setText(game["strings"]["match_starting_in"]);
	matchStartTimer = hud::createServerFontString("objective", 2.2);
	matchStartTimer hud::setPoint("CENTER", "CENTER", 0, 0);
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1, 1, 0);
	matchStartTimer.foreground = 0;
	matchStartTimer.hidewheninmenu = 1;
	countTime = Int(level.prematchPeriod);
	if(countTime >= 2)
	{
		while(countTime > 0 && !level.gameEnded)
		{
			matchStartTimer setValue(countTime);
			if(countTime == 2)
			{
				visionSetNaked(GetDvarString("mapname"), 3);
			}
			countTime--;
			wait(1);
		}
	}
	else
	{
		visionSetNaked(GetDvarString("mapname"), 1);
	}
	matchStartTimer hud::destroyElem();
	matchStartText hud::destroyElem();
}

/*
	Name: matchStartTimerSkip
	Namespace: globallogic
	Checksum: 0x5B3D11AE
	Offset: 0x3540
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function matchStartTimerSkip()
{
	visionSetNaked(GetDvarString("mapname"), 0);
}

/*
	Name: notifyTeamWaveSpawn
	Namespace: globallogic
	Checksum: 0x41B6E911
	Offset: 0x3580
	Size: 0x75
	Parameters: 2
	Flags: None
*/
function notifyTeamWaveSpawn(team, time)
{
	if(time - level.lastWave[team] > level.waveDelay[team] * 1000)
	{
		level notify("wave_respawn_" + team);
		level.lastWave[team] = time;
		level.wavePlayerSpawnIndex[team] = 0;
	}
}

/*
	Name: waveSpawnTimer
	Namespace: globallogic
	Checksum: 0xDAE4FACD
	Offset: 0x3600
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function waveSpawnTimer()
{
	level endon("game_ended");
	while(game["state"] == "playing")
	{
		time = GetTime();
		foreach(team in level.teams)
		{
			notifyTeamWaveSpawn(team, time);
		}
		wait(0.05);
	}
}

/*
	Name: hostIdledOut
	Namespace: globallogic
	Checksum: 0xF83B0B9B
	Offset: 0x36D8
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function hostIdledOut()
{
	hostPlayer = util::getHostPlayer();
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1 || GetDvarInt("Dev Block strings are not supported") == 1)
		{
			return 0;
		}
	#/
	if(isdefined(hostPlayer) && !hostPlayer.hasSpawned && !isdefined(hostPlayer.selectedClass))
	{
		return 1;
	}
	return 0;
}

/*
	Name: IncrementMatchCompletionStat
	Namespace: globallogic
	Checksum: 0x564E3F0E
	Offset: 0x3788
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function IncrementMatchCompletionStat(gamemode, playedOrHosted, stat)
{
	self AddDStat("gameHistory", gamemode, "modeHistory", playedOrHosted, stat, 1);
}

/*
	Name: SetMatchCompletionStat
	Namespace: globallogic
	Checksum: 0x7258B17E
	Offset: 0x37E8
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function SetMatchCompletionStat(gamemode, playedOrHosted, stat)
{
	self SetDStat("gameHistory", gamemode, "modeHistory", playedOrHosted, stat, 1);
}

/*
	Name: displayRoundEnd
	Namespace: globallogic
	Checksum: 0x207AE4AC
	Offset: 0x3848
	Size: 0x2F3
	Parameters: 2
	Flags: None
*/
function displayRoundEnd(winner, endReasonText)
{
	if(level.displayRoundEndText)
	{
		if(winner == "tie")
		{
			demo::gameResultBookmark("round_result", level.teamIndex["neutral"], level.teamIndex["neutral"]);
		}
		else
		{
			demo::gameResultBookmark("round_result", level.teamIndex[winner], level.teamIndex["neutral"]);
		}
		SetMatchFlag("cg_drawSpectatorMessages", 0);
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			if(!isdefined(player.pers["team"]))
			{
				player [[level.spawnIntermission]](1);
				player closeInGameMenu();
				continue;
			}
			if(level.wagerMatch)
			{
				if(level.teambased)
				{
					player thread [[level.onTeamWagerOutcomeNotify]](winner, 1, endReasonText);
				}
				else
				{
					player thread [[level.onWagerOutcomeNotify]](winner, endReasonText);
				}
			}
			else if(level.teambased)
			{
				player thread [[level.onTeamOutcomeNotify]](winner, 1, endReasonText);
				player globallogic_audio::set_music_on_player("ROUND_END");
			}
			else
			{
				player thread [[level.onOutcomeNotify]](winner, 1, endReasonText);
				player globallogic_audio::set_music_on_player("ROUND_END");
			}
			player setClientUIVisibilityFlag("hud_visible", 0);
			player setClientUIVisibilityFlag("g_compassShowEnemies", 0);
		}
	}
	else if(util::wasLastRound())
	{
		roundEndWait(level.roundEndDelay, 0);
	}
	else
	{
		thread globallogic_audio::announceRoundWinner(winner, level.roundEndDelay / 4);
		roundEndWait(level.roundEndDelay, 1);
	}
}

/*
	Name: displayRoundSwitch
	Namespace: globallogic
	Checksum: 0x1453A835
	Offset: 0x3B48
	Size: 0x2A3
	Parameters: 2
	Flags: None
*/
function displayRoundSwitch(winner, endReasonText)
{
	switchType = level.halftimeType;
	if(switchType == "halftime")
	{
		if(isdefined(level.nextRoundIsOvertime) && level.nextRoundIsOvertime)
		{
			switchType = "overtime";
		}
		else if(level.roundLimit)
		{
			if(game["roundsplayed"] * 2 == level.roundLimit)
			{
				switchType = "halftime";
			}
			else
			{
				switchType = "intermission";
			}
		}
		else if(level.scoreLimit)
		{
			if(game["roundsplayed"] == level.scoreLimit - 1)
			{
				switchType = "halftime";
			}
			else
			{
				switchType = "intermission";
			}
		}
		else
		{
			switchType = "intermission";
		}
	}
	leaderDialog = globallogic_audio::getRoundSwitchDialog(switchType);
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(!isdefined(player.pers["team"]))
		{
			player [[level.spawnIntermission]](1);
			player closeInGameMenu();
			continue;
		}
		player globallogic_audio::leaderDialogOnPlayer(leaderDialog);
		player globallogic_audio::set_music_on_player("ROUND_SWITCH");
		if(level.wagerMatch)
		{
			player thread [[level.onTeamWagerOutcomeNotify]](switchType, 1, level.halftimeSubCaption);
		}
		else
		{
			player thread [[level.onTeamOutcomeNotify]](switchType, 0, level.halftimeSubCaption);
		}
		player setClientUIVisibilityFlag("hud_visible", 0);
	}
	roundEndWait(level.halftimeRoundEndDelay, 0);
}

/*
	Name: displayGameEnd
	Namespace: globallogic
	Checksum: 0xA7C46E30
	Offset: 0x3DF8
	Size: 0x483
	Parameters: 2
	Flags: None
*/
function displayGameEnd(winner, endReasonText)
{
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	SetMatchFlag("cg_drawSpectatorMessages", 0);
	if(winner == "tie")
	{
		demo::gameResultBookmark("game_result", level.teamIndex["neutral"], level.teamIndex["neutral"]);
	}
	else
	{
		demo::gameResultBookmark("game_result", level.teamIndex[winner], level.teamIndex["neutral"]);
	}
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(!isdefined(player.pers["team"]))
		{
			player [[level.spawnIntermission]](1);
			player closeInGameMenu();
			continue;
		}
		if(level.wagerMatch)
		{
			if(level.teambased)
			{
				player thread [[level.onTeamWagerOutcomeNotify]](winner, 0, endReasonText);
			}
			else
			{
				player thread [[level.onWagerOutcomeNotify]](winner, endReasonText);
			}
		}
		else if(level.teambased)
		{
			player thread [[level.onTeamOutcomeNotify]](winner, 0, endReasonText);
		}
		else
		{
			player thread [[level.onOutcomeNotify]](winner, 0, endReasonText);
			if(isdefined(winner) && player == winner)
			{
				player globallogic_audio::set_music_on_player("VICTORY");
			}
			else if(!level.Splitscreen)
			{
				player globallogic_audio::set_music_on_player("LOSE");
			}
		}
		player setClientUIVisibilityFlag("hud_visible", 0);
		player setClientUIVisibilityFlag("g_compassShowEnemies", 0);
	}
	if(level.teambased)
	{
		thread globallogic_audio::announceGameWinner(winner, level.postRoundTime / 2);
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			team = player.pers["team"];
			if(level.Splitscreen)
			{
				if(winner == "tie")
				{
					player globallogic_audio::set_music_on_player("DRAW");
				}
				else if(winner == team)
				{
					player globallogic_audio::set_music_on_player("VICTORY");
				}
				else
				{
					player globallogic_audio::set_music_on_player("LOSE");
				}
				continue;
			}
			if(winner == "tie")
			{
				player globallogic_audio::set_music_on_player("DRAW");
				continue;
			}
			if(winner == team)
			{
				player globallogic_audio::set_music_on_player("VICTORY");
				continue;
			}
			player globallogic_audio::set_music_on_player("LOSE");
		}
	}
	bbPrint("global_session_epilogs", "reason %s", endReasonText);
	roundEndWait(level.postRoundTime, 1);
}

/*
	Name: getEndReasonText
	Namespace: globallogic
	Checksum: 0x3913C709
	Offset: 0x4288
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function getEndReasonText()
{
	if(util::hitRoundLimit() || util::hitRoundWinLimit())
	{
		return game["strings"]["round_limit_reached"];
	}
	else if(util::hitScoreLimit())
	{
		return game["strings"]["score_limit_reached"];
	}
	if(level.forcedEnd)
	{
		if(level.hostForcedEnd)
		{
			return &"MP_HOST_ENDED_GAME";
		}
		else
		{
			return &"MP_ENDED_GAME";
		}
	}
	return game["strings"]["time_limit_reached"];
}

/*
	Name: resetOutcomeForAllPlayers
	Namespace: globallogic
	Checksum: 0xE3EDBFBF
	Offset: 0x4348
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function resetOutcomeForAllPlayers()
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player notify("reset_outcome");
	}
}

/*
	Name: startNextRound
	Namespace: globallogic
	Checksum: 0x92AC3477
	Offset: 0x43C0
	Size: 0x25B
	Parameters: 2
	Flags: None
*/
function startNextRound(winner, endReasonText)
{
	if(!util::isOneRound())
	{
		displayRoundEnd(winner, endReasonText);
		globallogic_utils::executePostRoundEvents();
		if(!util::wasLastRound())
		{
			if(checkRoundSwitch())
			{
				displayRoundSwitch(winner, endReasonText);
			}
			if(isdefined(level.nextRoundIsOvertime) && level.nextRoundIsOvertime)
			{
				if(!isdefined(game["overtime_round"]))
				{
					game["overtime_round"] = 1;
				}
				else
				{
					game["overtime_round"]++;
				}
			}
			SetMatchTalkFlag("DeadChatWithDead", level.voip.deadChatWithDead);
			SetMatchTalkFlag("DeadChatWithTeam", level.voip.deadChatWithTeam);
			SetMatchTalkFlag("DeadHearTeamLiving", level.voip.deadHearTeamLiving);
			SetMatchTalkFlag("DeadHearAllLiving", level.voip.deadHearAllLiving);
			SetMatchTalkFlag("EveryoneHearsEveryone", level.voip.everyoneHearsEveryone);
			SetMatchTalkFlag("DeadHearKiller", level.voip.deadHearKiller);
			SetMatchTalkFlag("KillersHearVictim", level.voip.killersHearVictim);
			game["state"] = "playing";
			level.allowbattlechatter["bc"] = GetGametypeSetting("allowBattleChatter");
			map_restart(1);
			return 1;
		}
	}
	return 0;
}

/*
	Name: getGameLength
	Namespace: globallogic
	Checksum: 0x96D9CED
	Offset: 0x4628
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function getGameLength()
{
	if(!level.timelimit || level.forcedEnd)
	{
		gameLength = globallogic_utils::getTimePassed() / 1000;
		gameLength = min(gameLength, 1200);
	}
	else
	{
		gameLength = level.timelimit * 60;
	}
	return gameLength;
}

/*
	Name: gameHistoryPlayerQuit
	Namespace: globallogic
	Checksum: 0x7FA76E0A
	Offset: 0x46B0
	Size: 0x131
	Parameters: 0
	Flags: None
*/
function gameHistoryPlayerQuit()
{
	if(!GameModeIsMode(0))
	{
		return;
	}
	teamScoreRatio = 0;
	self GameHistoryFinishMatch(3, 0, 0, 0, 0, teamScoreRatio);
	if(isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::GetCurrentGameMode();
		self IncrementMatchCompletionStat(gamemode, "played", "quit");
		if(isdefined(self.pers["matchesHostedStatsTracked"]))
		{
			self IncrementMatchCompletionStat(gamemode, "hosted", "quit");
			self.pers["matchesHostedStatsTracked"] = undefined;
		}
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}
	UploadStats(self);
	wait(1);
}

/*
	Name: recordZMEndGameComScoreEvent
	Namespace: globallogic
	Checksum: 0x98A5A066
	Offset: 0x47F0
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function recordZMEndGameComScoreEvent(winner)
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		globallogic_player::recordZMEndGameComScoreEventForPlayer(players[index], winner);
	}
}

/*
	Name: endGame
	Namespace: globallogic
	Checksum: 0x243B0053
	Offset: 0x4868
	Size: 0x833
	Parameters: 2
	Flags: None
*/
function endGame(winner, endReasonText)
{
	if(game["state"] == "postgame" || level.gameEnded)
	{
		return;
	}
	if(isdefined(level.onEndGame))
	{
		[[level.onEndGame]](winner);
	}
	if(!isdefined(level.disableOutroVisionSet) || level.disableOutroVisionSet == 0)
	{
		if(SessionModeIsZombiesGame() && level.forcedEnd)
		{
			visionSetNaked("zombie_last_stand", 2);
		}
		else
		{
			visionSetNaked("mpOutro", 2);
		}
	}
	SetMatchFlag("cg_drawSpectatorMessages", 0);
	SetMatchFlag("game_ended", 1);
	game["state"] = "postgame";
	level.gameEndTime = GetTime();
	level.gameEnded = 1;
	SetDvar("g_gameEnded", 1);
	level.inGracePeriod = 0;
	level notify("game_ended");
	level.allowbattlechatter["bc"] = 0;
	globallogic_audio::flushDialog();
	if(!isdefined(game["overtime_round"]) || util::wasLastRound())
	{
		game["roundsplayed"]++;
		game["roundwinner"][game["roundsplayed"]] = winner;
		if(level.teambased)
		{
			game["roundswon"][winner]++;
		}
	}
	if(isdefined(winner) && isdefined(level.teams[winner]))
	{
		level.finalKillCam_winner = winner;
	}
	else
	{
		level.finalKillCam_winner = "none";
	}
	setGameEndTime(0);
	updatePlacement();
	updateRankedMatch(winner);
	players = level.players;
	newTime = GetTime();
	gameLength = getGameLength();
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	bbGameOver = 0;
	if(util::isOneRound() || util::wasLastRound())
	{
		bbGameOver = 1;
		if(level.teambased)
		{
			if(winner == "tie")
			{
				recordGameResult("draw");
			}
			else
			{
				recordGameResult(winner);
			}
		}
		else if(!isdefined(winner))
		{
			recordGameResult("draw");
		}
		else
		{
			recordGameResult(winner.team);
		}
	}
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player globallogic_player::freezePlayerForRoundEnd();
		player thread roundEndDoF(4);
		player globallogic_ui::freeGameplayHudElems();
		player weapons::updateWeaponTimings(newTime);
		player bbPlayerMatchEnd(gameLength, endReasonText, bbGameOver);
		if(level.rankedMatch || level.wagerMatch || level.leagueMatch && !player IsSplitscreen())
		{
			if(isdefined(player.setPromotion))
			{
				player SetDStat("AfterActionReportStats", "lobbyPopup", "promotion");
				continue;
			}
			player SetDStat("AfterActionReportStats", "lobbyPopup", "summary");
		}
	}
	music::setmusicstate("SILENT");
	thread challenges::roundEnd(winner);
	recordZMEndGameComScoreEvent(winner);
	globallogic_player::recordActivePlayersEndGameMatchRecordStats();
	if(startNextRound(winner, endReasonText))
	{
		return;
	}
	if(!util::isOneRound())
	{
		if(isdefined(level.onRoundEndGame))
		{
			winner = [[level.onRoundEndGame]](winner);
		}
		endReasonText = getEndReasonText();
	}
	skillUpdate(winner, level.teambased);
	recordLeagueWinner(winner);
	thread challenges::gameEnd(winner);
	if(isdefined(winner) && (!isdefined(level.skipGameEnd) || !level.skipGameEnd))
	{
		displayGameEnd(winner, endReasonText);
	}
	if(util::isOneRound())
	{
		globallogic_utils::executePostRoundEvents();
	}
	level.intermission = 1;
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	stopdemorecording();
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		recordPlayerStats(player, "presentAtEnd", 1);
		player closeInGameMenu();
		player notify("reset_outcome");
		player thread [[level.spawnIntermission]]();
		player setClientUIVisibilityFlag("hud_visible", 1);
		player setClientUIVisibilityFlag("weapon_hud_visible", 1);
	}
	level notify("sfade");
	/#
		print("Dev Block strings are not supported");
	#/
	if(!isdefined(level.skipGameEnd) || !level.skipGameEnd)
	{
		wait(5);
	}
	exitLevel(0);
}

/*
	Name: bbPlayerMatchEnd
	Namespace: globallogic
	Checksum: 0xC05721F3
	Offset: 0x50A8
	Size: 0xBF
	Parameters: 3
	Flags: None
*/
function bbPlayerMatchEnd(gameLength, endReasonString, gameOver)
{
	playerRank = getPlacementForPlayer(self);
	totalTimePlayed = 0;
	if(isdefined(self.timePlayed) && isdefined(self.timePlayed["total"]))
	{
		totalTimePlayed = self.timePlayed["total"];
		if(totalTimePlayed > gameLength)
		{
			totalTimePlayed = gameLength;
		}
	}
	xuid = self getXuid();
}

/*
	Name: roundEndWait
	Namespace: globallogic
	Checksum: 0x29A66835
	Offset: 0x5170
	Size: 0x1AD
	Parameters: 2
	Flags: None
*/
function roundEndWait(defaultDelay, matchBonus)
{
	notifiesDone = 0;
	while(!notifiesDone)
	{
		players = level.players;
		notifiesDone = 1;
		for(index = 0; index < players.size; index++)
		{
			if(!isdefined(players[index].doingNotify) || !players[index].doingNotify)
			{
				continue;
			}
			notifiesDone = 0;
		}
		wait(0.5);
	}
	if(!matchBonus)
	{
		wait(defaultDelay);
		level notify("round_end_done");
		return;
	}
	wait(defaultDelay / 2);
	level notify("give_match_bonus");
	wait(defaultDelay / 2);
	notifiesDone = 0;
	while(!notifiesDone)
	{
		players = level.players;
		notifiesDone = 1;
		for(index = 0; index < players.size; index++)
		{
			if(!isdefined(players[index].doingNotify) || !players[index].doingNotify)
			{
				continue;
			}
			notifiesDone = 0;
		}
		wait(0.5);
	}
	level notify("round_end_done");
}

/*
	Name: roundEndDoF
	Namespace: globallogic
	Checksum: 0xF84821DE
	Offset: 0x5328
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function roundEndDoF(time)
{
	self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
}

/*
	Name: checkTimeLimit
	Namespace: globallogic
	Checksum: 0xB875B600
	Offset: 0x5370
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function checkTimeLimit()
{
	if(isdefined(level.timeLimitOverride) && level.timeLimitOverride)
	{
		return;
	}
	if(game["state"] != "playing")
	{
		setGameEndTime(0);
		return;
	}
	if(level.timelimit <= 0)
	{
		setGameEndTime(0);
		return;
	}
	if(level.inPrematchPeriod)
	{
		setGameEndTime(0);
		return;
	}
	if(level.timerStopped)
	{
		setGameEndTime(0);
		return;
	}
	if(!isdefined(level.startTime))
	{
		return;
	}
	timeLeft = globallogic_utils::getTimeRemaining();
	setGameEndTime(GetTime() + Int(timeLeft));
	if(timeLeft > 0)
	{
		return;
	}
	[[level.onTimeLimit]]();
}

/*
	Name: allTeamsUnderScoreLimit
	Namespace: globallogic
	Checksum: 0x23C80FA6
	Offset: 0x54A8
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function allTeamsUnderScoreLimit()
{
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= level.scoreLimit)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: checkScoreLimit
	Namespace: globallogic
	Checksum: 0x30C86BC2
	Offset: 0x5550
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function checkScoreLimit()
{
	if(game["state"] != "playing")
	{
		return 0;
	}
	if(level.scoreLimit <= 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		if(allTeamsUnderScoreLimit())
		{
			return 0;
		}
	}
	else if(!isPlayer(self))
	{
		return 0;
	}
	if(self.score < level.scoreLimit)
	{
		return 0;
	}
	[[level.onScoreLimit]]();
}

/*
	Name: updateGametypeDvars
	Namespace: globallogic
	Checksum: 0x5D993022
	Offset: 0x5600
	Size: 0x1F1
	Parameters: 0
	Flags: None
*/
function updateGametypeDvars()
{
	level endon("game_ended");
	while(game["state"] == "playing")
	{
		roundLimit = math::clamp(GetGametypeSetting("roundLimit"), level.roundLimitMin, level.roundLimitMax);
		if(roundLimit != level.roundLimit)
		{
			level.roundLimit = roundLimit;
			level notify("update_roundlimit");
		}
		timelimit = [[level.getTimeLimit]]();
		if(timelimit != level.timelimit)
		{
			level.timelimit = timelimit;
			SetDvar("ui_timelimit", level.timelimit);
			level notify("update_timelimit");
		}
		thread checkTimeLimit();
		scoreLimit = math::clamp(GetGametypeSetting("scoreLimit"), level.scoreLimitMin, level.scoreLimitMax);
		if(scoreLimit != level.scoreLimit)
		{
			level.scoreLimit = scoreLimit;
			SetDvar("ui_scorelimit", level.scoreLimit);
			level notify("update_scorelimit");
		}
		thread checkScoreLimit();
		if(isdefined(level.startTime))
		{
			if(globallogic_utils::getTimeRemaining() < 3000)
			{
				wait(0.1);
				continue;
			}
		}
		wait(1);
	}
}

/*
	Name: removeDisconnectedPlayerFromPlacement
	Namespace: globallogic
	Checksum: 0xF8834A38
	Offset: 0x5800
	Size: 0x1D5
	Parameters: 0
	Flags: None
*/
function removeDisconnectedPlayerFromPlacement()
{
	offset = 0;
	numPlayers = level.placement["all"].size;
	found = 0;
	for(i = 0; i < numPlayers; i++)
	{
		if(level.placement["all"][i] == self)
		{
			found = 1;
		}
		if(found)
		{
			level.placement["all"][i] = level.placement["all"][i + 1];
		}
	}
	if(!found)
	{
		return;
	}
	level.placement["all"][numPlayers - 1] = undefined;
	/#
		Assert(level.placement["Dev Block strings are not supported"].size == numPlayers - 1);
	#/
	/#
		globallogic_utils::assertProperPlacement();
	#/
	updateTeamPlacement();
	if(level.teambased)
	{
		return;
	}
	numPlayers = level.placement["all"].size;
	for(i = 0; i < numPlayers; i++)
	{
		player = level.placement["all"][i];
		player notify("update_outcome");
	}
}

/*
	Name: updatePlacement
	Namespace: globallogic
	Checksum: 0xFD226142
	Offset: 0x59E0
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function updatePlacement()
{
	if(!level.players.size)
	{
		return;
	}
	level.placement["all"] = [];
	foreach(player in level.players)
	{
		if(!level.teambased || isdefined(level.teams[player.team]))
		{
			level.placement["all"][level.placement["all"].size] = player;
		}
	}
	placementAll = level.placement["all"];
	for(i = 1; i < placementAll.size; i++)
	{
		player = placementAll[i];
		playerScore = player.score;
		for(j = i - 1; j >= 0 && (playerScore > placementAll[j].score || (playerScore == placementAll[j].score && player.deaths < placementAll[j].deaths)); j--)
		{
			placementAll[j + 1] = placementAll[j];
		}
		placementAll[j + 1] = player;
	}
	level.placement["all"] = placementAll;
	/#
		globallogic_utils::assertProperPlacement();
	#/
	updateTeamPlacement();
}

/*
	Name: updateTeamPlacement
	Namespace: globallogic
	Checksum: 0x524A17D8
	Offset: 0x5C58
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function updateTeamPlacement()
{
	foreach(team in level.teams)
	{
		placement[team] = [];
	}
	placement["spectator"] = [];
	if(!level.teambased)
	{
		return;
	}
	placementAll = level.placement["all"];
	placementAllSize = placementAll.size;
	for(i = 0; i < placementAllSize; i++)
	{
		player = placementAll[i];
		if(isdefined(player))
		{
			team = player.pers["team"];
			placement[team][placement[team].size] = player;
		}
	}
	foreach(team in level.teams)
	{
		level.placement[team] = placement[team];
	}
}

/*
	Name: getPlacementForPlayer
	Namespace: globallogic
	Checksum: 0xFF717C0D
	Offset: 0x5E40
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function getPlacementForPlayer(player)
{
	updatePlacement();
	playerRank = -1;
	placement = level.placement["all"];
	for(placementIndex = 0; placementIndex < placement.size; placementIndex++)
	{
		if(level.placement["all"][placementIndex] == player)
		{
			playerRank = placementIndex + 1;
			break;
		}
	}
	return playerRank;
}

/*
	Name: sortDeadPlayers
	Namespace: globallogic
	Checksum: 0xA9C3C508
	Offset: 0x5F00
	Size: 0x199
	Parameters: 1
	Flags: None
*/
function sortDeadPlayers(team)
{
	if(!level.playerQueuedRespawn)
	{
		return;
	}
	for(i = 1; i < level.deadPlayers[team].size; i++)
	{
		player = level.deadPlayers[team][i];
		for(j = i - 1; j >= 0 && player.deathtime < level.deadPlayers[team][j].deathtime; j--)
		{
			level.deadPlayers[team][j + 1] = level.deadPlayers[team][j];
		}
		level.deadPlayers[team][j + 1] = player;
	}
	for(i = 0; i < level.deadPlayers[team].size; i++)
	{
		if(level.deadPlayers[team][i].spawnQueueIndex != i)
		{
			level.spawnQueueModified[team] = 1;
		}
		level.deadPlayers[team][i].spawnQueueIndex = i;
	}
}

/*
	Name: totalAliveCount
	Namespace: globallogic
	Checksum: 0x2DFC2AAD
	Offset: 0x60A8
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function totalAliveCount()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.aliveCount[team];
	}
	return count;
}

/*
	Name: totalPlayerLives
	Namespace: globallogic
	Checksum: 0xEEC8A364
	Offset: 0x6158
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function totalPlayerLives()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.playerLives[team];
	}
	return count;
}

/*
	Name: initTeamVariables
	Namespace: globallogic
	Checksum: 0xB4F4B9BE
	Offset: 0x6208
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function initTeamVariables(team)
{
	if(!isdefined(level.aliveCount))
	{
		level.aliveCount = [];
	}
	level.aliveCount[team] = 0;
	level.lastAliveCount[team] = 0;
	level.everExisted[team] = 0;
	level.waveDelay[team] = 0;
	level.lastWave[team] = 0;
	level.wavePlayerSpawnIndex[team] = 0;
	resetTeamVariables(team);
}

/*
	Name: resetTeamVariables
	Namespace: globallogic
	Checksum: 0x1DA42165
	Offset: 0x62B0
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function resetTeamVariables(team)
{
	level.playerCount[team] = 0;
	level.botsCount[team] = 0;
	level.lastAliveCount[team] = level.aliveCount[team];
	level.aliveCount[team] = 0;
	level.playerLives[team] = 0;
	level.aliveplayers[team] = [];
	level.deadPlayers[team] = [];
	level.squads[team] = [];
	level.spawnQueueModified[team] = 0;
}

/*
	Name: updateTeamStatus
	Namespace: globallogic
	Checksum: 0xEA1D9F5E
	Offset: 0x6368
	Size: 0x3C3
	Parameters: 0
	Flags: None
*/
function updateTeamStatus()
{
	level notify("updating_team_status");
	level endon("updating_team_status");
	level endon("game_ended");
	waittillframeend;
	wait(0);
	if(game["state"] == "postgame")
	{
		return;
	}
	resetTimeout();
	foreach(team in level.teams)
	{
		resetTeamVariables(team);
	}
	level.activePlayers = [];
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player) && level.Splitscreen)
		{
			continue;
		}
		team = player.team;
		if(team != "spectator")
		{
			level.playerCount[team]++;
			if(isdefined(player.pers["isBot"]))
			{
				level.botsCount[team]++;
			}
			if(player.sessionstate == "playing")
			{
				level.aliveCount[team]++;
				level.playerLives[team]++;
				player.spawnQueueIndex = -1;
				if(isalive(player))
				{
					level.aliveplayers[team][level.aliveplayers[team].size] = player;
					level.activePlayers[level.activePlayers.size] = player;
				}
				else
				{
					level.deadPlayers[team][level.deadPlayers[team].size] = player;
				}
				continue;
			}
			level.deadPlayers[team][level.deadPlayers[team].size] = player;
			if(player globallogic_spawn::maySpawn())
			{
				level.playerLives[team]++;
			}
		}
	}
	totalAlive = totalAliveCount();
	if(totalAlive > level.maxPlayerCount)
	{
		level.maxPlayerCount = totalAlive;
	}
	foreach(team in level.teams)
	{
		if(level.aliveCount[team])
		{
			level.everExisted[team] = 1;
		}
		sortDeadPlayers(team);
	}
	level updateGameEvents();
}

/*
	Name: checkTeamScoreLimitSoon
	Namespace: globallogic
	Checksum: 0x82EFE007
	Offset: 0x6738
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function checkTeamScoreLimitSoon(team)
{
	/#
		Assert(isdefined(team));
	#/
	if(level.scoreLimit <= 0)
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	if(globallogic_utils::getTimePassed() < 60000)
	{
		return;
	}
	timeLeft = globallogic_utils::getEstimatedTimeUntilScoreLimit(team);
	if(timeLeft < 1)
	{
		level notify("match_ending_soon", "score");
	}
}

/*
	Name: checkPlayerScoreLimitSoon
	Namespace: globallogic
	Checksum: 0x4D2D5D52
	Offset: 0x67F8
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function checkPlayerScoreLimitSoon()
{
	/#
		Assert(isPlayer(self));
	#/
	if(level.scoreLimit <= 0)
	{
		return;
	}
	if(level.teambased)
	{
		return;
	}
	if(globallogic_utils::getTimePassed() < 60000)
	{
		return;
	}
	timeLeft = globallogic_utils::getEstimatedTimeUntilScoreLimit(undefined);
	if(timeLeft < 1)
	{
		level notify("match_ending_soon", "score");
	}
}

/*
	Name: startGame
	Namespace: globallogic
	Checksum: 0x402E68EC
	Offset: 0x68B0
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function startGame()
{
	thread globallogic_utils::gameTimer();
	level.timerStopped = 0;
	SetMatchTalkFlag("DeadChatWithDead", level.voip.deadChatWithDead);
	SetMatchTalkFlag("DeadChatWithTeam", level.voip.deadChatWithTeam);
	SetMatchTalkFlag("DeadHearTeamLiving", level.voip.deadHearTeamLiving);
	SetMatchTalkFlag("DeadHearAllLiving", level.voip.deadHearAllLiving);
	SetMatchTalkFlag("EveryoneHearsEveryone", level.voip.everyoneHearsEveryone);
	SetMatchTalkFlag("DeadHearKiller", level.voip.deadHearKiller);
	SetMatchTalkFlag("KillersHearVictim", level.voip.killersHearVictim);
	prematchPeriod();
	level notify("prematch_over");
	thread gracePeriod();
	thread watchMatchEndingSoon();
	thread globallogic_audio::musicController();
	thread bb::recordBlackBoxBreadcrumbData("zmbreadcrumb");
	recordMatchBegin();
}

/*
	Name: waitForPlayers
	Namespace: globallogic
	Checksum: 0x99EC1590
	Offset: 0x6A70
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function waitForPlayers()
{
}

/*
	Name: prematchPeriod
	Namespace: globallogic
	Checksum: 0x4E687BBF
	Offset: 0x6A80
	Size: 0x121
	Parameters: 0
	Flags: None
*/
function prematchPeriod()
{
	SetMatchFlag("hud_hardcore", level.hardcoreMode);
	level endon("game_ended");
	if(level.prematchPeriod > 0)
	{
		thread matchStartTimer();
		waitForPlayers();
		wait(level.prematchPeriod);
	}
	else
	{
		matchStartTimerSkip();
		wait(0.05);
	}
	level.inPrematchPeriod = 0;
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] util::freeze_player_controls(0);
		level.players[index] enableWeapons();
	}
	if(game["state"] != "playing")
	{
		return;
	}
}

/*
	Name: gracePeriod
	Namespace: globallogic
	Checksum: 0xDB3433F1
	Offset: 0x6BB0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function gracePeriod()
{
	level endon("game_ended");
	if(isdefined(level.gracePeriodFunc))
	{
		[[level.gracePeriodFunc]]();
	}
	else
	{
		wait(level.gracePeriod);
	}
	level notify("grace_period_ending");
	wait(0.05);
	level.inGracePeriod = 0;
	if(game["state"] != "playing")
	{
		return;
	}
	if(level.numLives)
	{
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player.hasSpawned && player.sessionteam != "spectator" && !isalive(player))
			{
				player.statusicon = "hud_status_dead";
			}
		}
	}
	level thread updateTeamStatus();
}

/*
	Name: watchMatchEndingSoon
	Namespace: globallogic
	Checksum: 0xC1844E3
	Offset: 0x6D08
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function watchMatchEndingSoon()
{
	SetDvar("xblive_matchEndingSoon", 0);
	level waittill("match_ending_soon", reason);
	SetDvar("xblive_matchEndingSoon", 1);
}

/*
	Name: assertTeamVariables
	Namespace: globallogic
	Checksum: 0x99EC1590
	Offset: 0x6D68
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function assertTeamVariables()
{
}

/*
	Name: anyTeamHasWaveDelay
	Namespace: globallogic
	Checksum: 0xD2E37D0C
	Offset: 0x6D78
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function anyTeamHasWaveDelay()
{
	foreach(team in level.teams)
	{
		if(level.waveDelay[team])
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: Callback_StartGameType
	Namespace: globallogic
	Checksum: 0x687CEBEB
	Offset: 0x6E10
	Size: 0x138B
	Parameters: 0
	Flags: None
*/
function Callback_StartGameType()
{
	level.prematchPeriod = 0;
	level.intermission = 0;
	SetMatchFlag("cg_drawSpectatorMessages", 1);
	SetMatchFlag("game_ended", 0);
	if(!isdefined(game["gamestarted"]))
	{
		if(!isdefined(game["allies"]))
		{
			game["allies"] = "seals";
		}
		if(!isdefined(game["axis"]))
		{
			game["axis"] = "pmc";
		}
		if(!isdefined(game["attackers"]))
		{
			game["attackers"] = "allies";
		}
		if(!isdefined(game["defenders"]))
		{
			game["defenders"] = "axis";
		}
		/#
			Assert(game["Dev Block strings are not supported"] != game["Dev Block strings are not supported"]);
		#/
		foreach(team in level.teams)
		{
			if(!isdefined(game[team]))
			{
				game[team] = "pmc";
			}
		}
		if(!isdefined(game["state"]))
		{
			game["state"] = "playing";
		}
		SetDvar("cg_thirdPersonAngle", 354);
		game["strings"]["press_to_spawn"] = &"PLATFORM_PRESS_TO_SPAWN";
		if(level.teambased)
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		else
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_PLAYERS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
		game["strings"]["spawn_next_round"] = &"MP_SPAWN_NEXT_ROUND";
		game["strings"]["waiting_to_spawn"] = &"MP_WAITING_TO_SPAWN";
		game["strings"]["waiting_to_spawn_ss"] = &"MP_WAITING_TO_SPAWN_SS";
		game["strings"]["you_will_spawn"] = &"MP_YOU_WILL_RESPAWN";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["change_class"] = &"MP_CHANGE_CLASS_NEXT_SPAWN";
		game["strings"]["last_stand"] = &"MPUI_LAST_STAND";
		game["strings"]["cowards_way"] = &"PLATFORM_COWARDS_WAY_OUT";
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";
		assertTeamVariables();
		[[level.onPrecacheGameType]]();
		game["gamestarted"] = 1;
		game["totalKills"] = 0;
		foreach(team in level.teams)
		{
			game["teamScores"][team] = 0;
			game["totalKillsTeam"][team] = 0;
		}
		if(!level.Splitscreen)
		{
			level.prematchPeriod = GetGametypeSetting("prematchperiod");
		}
		if(GetDvarInt("xblive_clanmatch") != 0)
		{
			foreach(team in level.teams)
			{
				game["icons"][team] = "composite_emblem_team_axis";
			}
			game["icons"]["allies"] = "composite_emblem_team_allies";
			game["icons"]["axis"] = "composite_emblem_team_axis";
		}
	}
	if(!isdefined(game["timepassed"]))
	{
		game["timepassed"] = 0;
	}
	if(!isdefined(game["roundsplayed"]))
	{
		game["roundsplayed"] = 0;
	}
	SetRoundsPlayed(game["roundsplayed"]);
	if(!isdefined(game["roundwinner"]))
	{
		game["roundwinner"] = [];
	}
	if(!isdefined(game["roundswon"]))
	{
		game["roundswon"] = [];
	}
	if(!isdefined(game["roundswon"]["tie"]))
	{
		game["roundswon"]["tie"] = 0;
	}
	foreach(team in level.teams)
	{
		if(!isdefined(game["roundswon"][team]))
		{
			game["roundswon"][team] = 0;
		}
		level.teamSpawnPoints[team] = [];
		level.spawn_point_team_class_names[team] = [];
	}
	level.skipVote = 0;
	level.gameEnded = 0;
	SetDvar("g_gameEnded", 0);
	level.objIDStart = 0;
	level.forcedEnd = 0;
	level.hostForcedEnd = 0;
	level.hardcoreMode = GetGametypeSetting("hardcoreMode");
	if(level.hardcoreMode)
	{
		/#
			print("Dev Block strings are not supported");
		#/
		if(!isdefined(level.friendlyFireDelayTime))
		{
			level.friendlyFireDelayTime = 0;
		}
	}
	if(GetDvarString("scr_max_rank") == "")
	{
		SetDvar("scr_max_rank", "0");
	}
	level.rankCap = GetDvarInt("scr_max_rank");
	if(GetDvarString("scr_min_prestige") == "")
	{
		SetDvar("scr_min_prestige", "0");
	}
	level.minPrestige = GetDvarInt("scr_min_prestige");
	level.useStartSpawns = 1;
	level.cumulativeRoundScores = GetGametypeSetting("cumulativeRoundScores");
	level.allowHitMarkers = GetGametypeSetting("allowhitmarkers");
	level.playerQueuedRespawn = GetGametypeSetting("playerQueuedRespawn");
	level.playerForceRespawn = GetGametypeSetting("playerForceRespawn");
	level.perksEnabled = GetGametypeSetting("perksEnabled");
	level.disableAttachments = GetGametypeSetting("disableAttachments");
	level.disableTacInsert = GetGametypeSetting("disableTacInsert");
	level.disableCAC = GetGametypeSetting("disableCAC");
	level.disableWeaponDrop = GetGametypeSetting("disableweapondrop");
	level.onlyHeadShots = GetGametypeSetting("onlyHeadshots");
	level.minimumAllowedTeamKills = GetGametypeSetting("teamKillPunishCount") - 1;
	level.teamKillReducedPenalty = GetGametypeSetting("teamKillReducedPenalty");
	level.teamKillPointLoss = GetGametypeSetting("teamKillPointLoss");
	level.teamKillSpawnDelay = GetGametypeSetting("teamKillSpawnDelay");
	level.deathPointLoss = GetGametypeSetting("deathPointLoss");
	level.leaderBonus = GetGametypeSetting("leaderBonus");
	level.forceradar = GetGametypeSetting("forceRadar");
	level.playerSprintTime = GetGametypeSetting("playerSprintTime");
	level.bulletDamageScalar = GetGametypeSetting("bulletDamageScalar");
	level.playerMaxHealth = GetGametypeSetting("playerMaxHealth");
	level.playerHealthRegenTime = GetGametypeSetting("playerHealthRegenTime");
	level.playerRespawnDelay = GetGametypeSetting("playerRespawnDelay");
	level.playerObjectiveHeldRespawnDelay = GetGametypeSetting("playerObjectiveHeldRespawnDelay");
	level.waveRespawnDelay = GetGametypeSetting("waveRespawnDelay");
	level.spectateType = GetGametypeSetting("spectateType");
	level.voip = spawnstruct();
	level.voip.deadChatWithDead = GetGametypeSetting("voipDeadChatWithDead");
	level.voip.deadChatWithTeam = GetGametypeSetting("voipDeadChatWithTeam");
	level.voip.deadHearAllLiving = GetGametypeSetting("voipDeadHearAllLiving");
	level.voip.deadHearTeamLiving = GetGametypeSetting("voipDeadHearTeamLiving");
	level.voip.everyoneHearsEveryone = GetGametypeSetting("voipEveryoneHearsEveryone");
	level.voip.deadHearKiller = GetGametypeSetting("voipDeadHearKiller");
	level.voip.killersHearVictim = GetGametypeSetting("voipKillersHearVictim");
	callback::callback("hash_cc62acca");
	level.prematchPeriod = 0;
	level.persistentDataInfo = [];
	level.maxRecentStats = 10;
	level.maxHitLocations = 19;
	level.globalShotsFired = 0;
	thread hud_message::init();
	foreach(team in level.teams)
	{
		initTeamVariables(team);
	}
	level.maxPlayerCount = 0;
	level.activePlayers = [];
	level.allowAnnouncer = GetGametypeSetting("allowAnnouncer");
	if(!isdefined(level.timelimit))
	{
		util::registerTimeLimit(1, 1440);
	}
	if(!isdefined(level.scoreLimit))
	{
		util::registerScoreLimit(1, 500);
	}
	if(!isdefined(level.roundLimit))
	{
		util::registerRoundLimit(0, 10);
	}
	if(!isdefined(level.roundWinLimit))
	{
		util::registerRoundWinLimit(0, 10);
	}
	waveDelay = level.waveRespawnDelay;
	if(waveDelay)
	{
		foreach(team in level.teams)
		{
			level.waveDelay[team] = waveDelay;
			level.lastWave[team] = 0;
		}
		level thread [[level.waveSpawnTimer]]();
	}
	level.inPrematchPeriod = 1;
	if(level.prematchPeriod > 2)
	{
		level.prematchPeriod = level.prematchPeriod + RandomFloat(4) - 2;
	}
	if(level.numLives || anyTeamHasWaveDelay() || level.playerQueuedRespawn)
	{
		level.gracePeriod = 15;
	}
	else
	{
		level.gracePeriod = 5;
	}
	level.inGracePeriod = 1;
	level.roundEndDelay = 5;
	level.halftimeRoundEndDelay = 3;
	globallogic_score::updateAllTeamScores();
	level.killstreaksenabled = 1;
	if(GetDvarString("scr_game_rankenabled") == "")
	{
		SetDvar("scr_game_rankenabled", 1);
	}
	level.rankEnabled = GetDvarInt("scr_game_rankenabled");
	if(GetDvarString("scr_game_medalsenabled") == "")
	{
		SetDvar("scr_game_medalsenabled", 1);
	}
	level.medalsEnabled = GetDvarInt("scr_game_medalsenabled");
	if(level.hardcoreMode && level.rankedMatch && GetDvarString("scr_game_friendlyFireDelay") == "")
	{
		SetDvar("scr_game_friendlyFireDelay", 1);
	}
	level.friendlyFireDelay = GetDvarInt("scr_game_friendlyFireDelay");
	[[level.onStartGameType]]();
	if(GetDvarInt("custom_killstreak_mode") == 1)
	{
		level.killstreaksenabled = 0;
	}
	thread startGame();
	level thread updateGametypeDvars();
	level thread simple_hostmigration::UpdateHostMigrationData();
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			level.skipGameEnd = 1;
			level.roundLimit = 1;
			wait(1);
			thread forceEnd(0);
		}
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			thread ForceDebugHostMigration();
		}
	#/
}

/*
	Name: ForceDebugHostMigration
	Namespace: globallogic
	Checksum: 0x7E39C948
	Offset: 0x81A8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function ForceDebugHostMigration()
{
	/#
		while(1)
		{
			hostmigration::waitTillHostMigrationDone();
			wait(60);
			starthostmigration();
			hostmigration::waitTillHostMigrationDone();
		}
	#/
}

/*
	Name: registerFriendlyFireDelay
	Namespace: globallogic
	Checksum: 0x878B2EBE
	Offset: 0x8200
	Size: 0x10B
	Parameters: 4
	Flags: None
*/
function registerFriendlyFireDelay(dvarString, defaultValue, minValue, maxValue)
{
	dvarString = "scr_" + dvarString + "_friendlyFireDelayTime";
	if(GetDvarString(dvarString) == "")
	{
		SetDvar(dvarString, defaultValue);
	}
	if(GetDvarInt(dvarString) > maxValue)
	{
		SetDvar(dvarString, maxValue);
	}
	else if(GetDvarInt(dvarString) < minValue)
	{
		SetDvar(dvarString, minValue);
	}
	level.friendlyFireDelayTime = GetDvarInt(dvarString);
}

/*
	Name: checkRoundSwitch
	Namespace: globallogic
	Checksum: 0xA17D99BA
	Offset: 0x8318
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function checkRoundSwitch()
{
	if(!isdefined(level.roundSwitch) || !level.roundSwitch)
	{
		return 0;
	}
	if(!isdefined(level.onRoundSwitch))
	{
		return 0;
	}
	/#
		Assert(game["Dev Block strings are not supported"] > 0);
	#/
	if(game["roundsplayed"] % level.roundSwitch == 0)
	{
		[[level.onRoundSwitch]]();
		return 1;
	}
	return 0;
}

/*
	Name: listenForGameEnd
	Namespace: globallogic
	Checksum: 0xB8DC60C8
	Offset: 0x83B0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function listenForGameEnd()
{
	self waittill("host_sucks_end_game");
	level.skipVote = 1;
	if(!level.gameEnded)
	{
		level thread forceEnd(1);
	}
}

/*
	Name: getKillStreaks
	Namespace: globallogic
	Checksum: 0xEE99FF5
	Offset: 0x83F8
	Size: 0x127
	Parameters: 1
	Flags: None
*/
function getKillStreaks(player)
{
	for(killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++)
	{
		killstreak[killstreakNum] = "killstreak_null";
	}
	if(isPlayer(player) && !level.oldschool && level.disableCAC != 1 && (!isdefined(player.pers["isBot"]) && isdefined(player.killstreak)))
	{
		currentKillstreak = 0;
		for(killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++)
		{
			if(isdefined(player.killstreak[killstreakNum]))
			{
				killstreak[currentKillstreak] = player.killstreak[killstreakNum];
				currentKillstreak++;
			}
		}
	}
	return killstreak;
}

/*
	Name: updateRankedMatch
	Namespace: globallogic
	Checksum: 0xCBC8A627
	Offset: 0x8528
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function updateRankedMatch(winner)
{
	if(level.rankedMatch)
	{
		if(hostIdledOut())
		{
			level.hostForcedEnd = 1;
			/#
				print("Dev Block strings are not supported");
			#/
			endLobby();
		}
	}
}

