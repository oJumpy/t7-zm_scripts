#using scripts\codescripts\struct;
#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_challenges;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_utils;

#namespace globallogic_score;

/*
	Name: getHighestScoringPlayer
	Namespace: globallogic_score
	Checksum: 0x2A16ED6E
	Offset: 0x4D8
	Size: 0x139
	Parameters: 0
	Flags: None
*/
function getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = 0;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].score))
		{
			continue;
		}
		if(players[i].score < 1)
		{
			continue;
		}
		if(!isdefined(winner) || players[i].score > winner.score)
		{
			winner = players[i];
			tie = 0;
			continue;
		}
		if(players[i].score == winner.score)
		{
			tie = 1;
		}
	}
	if(tie || !isdefined(winner))
	{
		return undefined;
	}
	else
	{
		return winner;
	}
}

/*
	Name: resetScoreChain
	Namespace: globallogic_score
	Checksum: 0xE0C8FDB6
	Offset: 0x620
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function resetScoreChain()
{
	self notify("reset_score_chain");
	self.scoreChain = 0;
	self.rankUpdateTotal = 0;
}

/*
	Name: scoreChainTimer
	Namespace: globallogic_score
	Checksum: 0x7544113C
	Offset: 0x650
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function scoreChainTimer()
{
	self notify("score_chain_timer");
	self endon("reset_score_chain");
	self endon("score_chain_timer");
	self endon("death");
	self endon("disconnect");
	wait(20);
	self thread resetScoreChain();
}

/*
	Name: roundToNearestFive
	Namespace: globallogic_score
	Checksum: 0xC76B841D
	Offset: 0x6B8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function roundToNearestFive(score)
{
	rounding = score % 5;
	if(rounding <= 2)
	{
		return score - rounding;
	}
	else
	{
		return score + 5 - rounding;
	}
}

/*
	Name: givePlayerMomentumNotification
	Namespace: globallogic_score
	Checksum: 0xABBE78F2
	Offset: 0x718
	Size: 0x1E3
	Parameters: 4
	Flags: None
*/
function givePlayerMomentumNotification(score, label, descValue, countsTowardRampage)
{
	rampageBonus = 0;
	if(isdefined(level.usingRampage) && level.usingRampage)
	{
		if(countsTowardRampage)
		{
			if(!isdefined(self.scoreChain))
			{
				self.scoreChain = 0;
			}
			self.scoreChain++;
			self thread scoreChainTimer();
		}
		if(isdefined(self.scoreChain) && self.scoreChain >= 999)
		{
			rampageBonus = roundToNearestFive(Int(score * level.rampageBonusScale + 0.5));
		}
	}
	combat_efficiency_factor = 0;
	if(score != 0)
	{
		self LUINotifyEvent(&"score_event", 4, label, score, rampageBonus, combat_efficiency_factor);
	}
	score = score + rampageBonus;
	if(score > 0 && self hasPerk("specialty_earnmoremomentum"))
	{
		score = roundToNearestFive(Int(score * GetDvarFloat("perk_killstreakMomentumMultiplier") + 0.5));
	}
	_setPlayerMomentum(self, self.pers["momentum"] + score);
}

/*
	Name: resetPlayerMomentumOnDeath
	Namespace: globallogic_score
	Checksum: 0x37DB69F0
	Offset: 0x908
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function resetPlayerMomentumOnDeath()
{
	if(isdefined(level.usingScoreStreaks) && level.usingScoreStreaks)
	{
		_setPlayerMomentum(self, 0);
		self thread resetScoreChain();
	}
}

/*
	Name: givePlayerXPDisplay
	Namespace: globallogic_score
	Checksum: 0xC39953E6
	Offset: 0x960
	Size: 0x16F
	Parameters: 4
	Flags: None
*/
function givePlayerXPDisplay(event, player, victim, descValue)
{
	score = rank::getScoreInfoValue(event);
	/#
		Assert(isdefined(score));
	#/
	XP = rank::getScoreInfoXP(event);
	/#
		Assert(isdefined(XP));
	#/
	label = rank::getScoreInfoLabel(event);
	if(XP && !level.gameEnded && isdefined(label))
	{
		xpScale = player GetXPScale();
		if(1 != xpScale)
		{
			XP = Int(XP * xpScale + 0.5);
		}
		player LUINotifyEvent(&"score_event", 2, label, XP);
	}
	return score;
}

/*
	Name: givePlayerScore
	Namespace: globallogic_score
	Checksum: 0x3B8E8F04
	Offset: 0xAD8
	Size: 0x49
	Parameters: 5
	Flags: None
*/
function givePlayerScore(event, player, victim, descValue, weapon)
{
	return givePlayerXPDisplay(event, player, victim, descValue);
}

/*
	Name: default_onPlayerScore
	Namespace: globallogic_score
	Checksum: 0xD575D29B
	Offset: 0xB30
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function default_onPlayerScore(event, player, victim)
{
}

/*
	Name: _setPlayerScore
	Namespace: globallogic_score
	Checksum: 0x62423F7C
	Offset: 0xB58
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function _setPlayerScore(player, score)
{
}

/*
	Name: _getPlayerScore
	Namespace: globallogic_score
	Checksum: 0x3BB427ED
	Offset: 0xB78
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function _getPlayerScore(player)
{
	return player.pers["score"];
}

/*
	Name: _setPlayerMomentum
	Namespace: globallogic_score
	Checksum: 0xB66F0B5F
	Offset: 0xBA0
	Size: 0x11F
	Parameters: 2
	Flags: None
*/
function _setPlayerMomentum(player, momentum)
{
	momentum = math::clamp(momentum, 0, 2000);
	oldMomentum = player.pers["momentum"];
	if(momentum == oldMomentum)
	{
		return;
	}
	player bb::add_to_stat("momentum", momentum - oldMomentum);
	if(momentum > oldMomentum)
	{
		highestMomentumCost = 0;
		numKillstreaks = player.killstreak.size;
		killStreakTypeArray = [];
	}
	player.pers["momentum"] = momentum;
	player.momentum = player.pers["momentum"];
}

/*
	Name: _givePlayerKillstreakInternal
	Namespace: globallogic_score
	Checksum: 0x7AD64985
	Offset: 0xCC8
	Size: 0x23
	Parameters: 4
	Flags: None
*/
function _givePlayerKillstreakInternal(player, momentum, oldMomentum, killStreakTypeArray)
{
}

/*
	Name: setPlayerMomentumDebug
	Namespace: globallogic_score
	Checksum: 0x9AF048A7
	Offset: 0xCF8
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function setPlayerMomentumDebug()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		while(1)
		{
			wait(1);
			momentumPercent = GetDvarFloat("Dev Block strings are not supported", 0);
			if(momentumPercent != 0)
			{
				player = util::getHostPlayer();
				if(!isdefined(player))
				{
					return;
				}
				if(isdefined(player.killstreak))
				{
					_setPlayerMomentum(player, Int(2000 * momentumPercent / 100));
				}
			}
		}
	#/
}

/*
	Name: giveTeamScore
	Namespace: globallogic_score
	Checksum: 0x7295D380
	Offset: 0xDF0
	Size: 0x123
	Parameters: 4
	Flags: None
*/
function giveTeamScore(event, team, player, victim)
{
	if(level.overrideTeamScore)
	{
		return;
	}
	PixBeginEvent("level.onTeamScore");
	teamScore = game["teamScores"][team];
	[[level.onTeamScore]](event, team);
	PixEndEvent();
	newScore = game["teamScores"][team];
	bbPrint("mpteamscores", "gametime %d event %s team %d diff %d score %d", GetTime(), event, team, newScore - teamScore, newScore);
	if(teamScore == newScore)
	{
		return;
	}
	updateTeamScores(team);
	thread globallogic::checkScoreLimit();
}

/*
	Name: giveTeamScoreForObjective
	Namespace: globallogic_score
	Checksum: 0xE5B8F6FC
	Offset: 0xF20
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function giveTeamScoreForObjective(team, score)
{
	teamScore = game["teamScores"][team];
	onTeamScore(score, team);
	newScore = game["teamScores"][team];
	if(teamScore == newScore)
	{
		return;
	}
	updateTeamScores(team);
	thread globallogic::checkScoreLimit();
}

/*
	Name: _setTeamScore
	Namespace: globallogic_score
	Checksum: 0x2F0FFF95
	Offset: 0xFD0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function _setTeamScore(team, teamScore)
{
	if(teamScore == game["teamScores"][team])
	{
		return;
	}
	game["teamScores"][team] = teamScore;
	updateTeamScores(team);
	thread globallogic::checkScoreLimit();
}

/*
	Name: resetTeamScores
	Namespace: globallogic_score
	Checksum: 0x88D04600
	Offset: 0x1048
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function resetTeamScores()
{
	if(level.scoreRoundWinBased || util::isFirstRound())
	{
		foreach(team in level.teams)
		{
			game["teamScores"][team] = 0;
		}
	}
	updateAllTeamScores();
}

/*
	Name: resetAllScores
	Namespace: globallogic_score
	Checksum: 0x88E70510
	Offset: 0x1110
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function resetAllScores()
{
	resetTeamScores();
	resetPlayerScores();
}

/*
	Name: resetPlayerScores
	Namespace: globallogic_score
	Checksum: 0x8ACD1904
	Offset: 0x1140
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function resetPlayerScores()
{
	players = level.players;
	winner = undefined;
	tie = 0;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].pers["score"]))
		{
			_setPlayerScore(players[i], 0);
		}
	}
}

/*
	Name: updateTeamScores
	Namespace: globallogic_score
	Checksum: 0xB434DFB5
	Offset: 0x11F0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function updateTeamScores(team)
{
	setTeamScore(team, game["teamScores"][team]);
	level thread globallogic::checkTeamScoreLimitSoon(team);
}

/*
	Name: updateAllTeamScores
	Namespace: globallogic_score
	Checksum: 0x2549CE5
	Offset: 0x1248
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function updateAllTeamScores()
{
	foreach(team in level.teams)
	{
		updateTeamScores(team);
	}
}

/*
	Name: _getTeamScore
	Namespace: globallogic_score
	Checksum: 0xC28803F3
	Offset: 0x12E0
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function _getTeamScore(team)
{
	return game["teamScores"][team];
}

/*
	Name: getHighestTeamScoreTeam
	Namespace: globallogic_score
	Checksum: 0x67C280D6
	Offset: 0x1308
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function getHighestTeamScoreTeam()
{
	score = 0;
	winning_teams = [];
	foreach(team in level.teams)
	{
		team_score = game["teamScores"][team];
		if(team_score > score)
		{
			score = team_score;
			winning_teams = [];
		}
		if(team_score == score)
		{
			winning_teams[team] = team;
		}
	}
	return winning_teams;
}

/*
	Name: areTeamArraysEqual
	Namespace: globallogic_score
	Checksum: 0xA556DC6A
	Offset: 0x1408
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function areTeamArraysEqual(teamsA, teamsB)
{
	if(teamsA.size != teamsB.size)
	{
		return 0;
	}
	foreach(team in teamsA)
	{
		if(!isdefined(teamsB[team]))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: onTeamScore
	Namespace: globallogic_score
	Checksum: 0xA76F163A
	Offset: 0x14C0
	Size: 0x2C7
	Parameters: 2
	Flags: None
*/
function onTeamScore(score, team)
{
	game["teamScores"][team] = game["teamScores"][team] + score;
	if(level.scoreLimit && game["teamScores"][team] > level.scoreLimit)
	{
		game["teamScores"][team] = level.scoreLimit;
	}
	if(level.Splitscreen)
	{
		return;
	}
	if(level.scoreLimit == 1)
	{
		return;
	}
	isWinning = getHighestTeamScoreTeam();
	if(isWinning.size == 0)
	{
		return;
	}
	if(GetTime() - level.lastStatusTime < 5000)
	{
		return;
	}
	if(areTeamArraysEqual(isWinning, level.wasWinning))
	{
		return;
	}
	level.lastStatusTime = GetTime();
	if(isWinning.size == 1)
	{
		foreach(team in isWinning)
		{
			if(isdefined(level.wasWinning[team]))
			{
				if(level.wasWinning.size == 1)
				{
					continue;
				}
			}
			globallogic_audio::leaderDialog("lead_taken", team, "status");
		}
	}
	else if(level.wasWinning.size == 1)
	{
		foreach(team in level.wasWinning)
		{
			if(isdefined(isWinning[team]))
			{
				if(isWinning.size == 1)
				{
					continue;
				}
				if(level.wasWinning.size > 1)
				{
					continue;
				}
			}
			globallogic_audio::leaderDialog("lead_lost", team, "status");
		}
	}
	level.wasWinning = isWinning;
}

/*
	Name: default_onTeamScore
	Namespace: globallogic_score
	Checksum: 0x3FFB2FB1
	Offset: 0x1790
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function default_onTeamScore(event, team)
{
}

/*
	Name: initPersStat
	Namespace: globallogic_score
	Checksum: 0x73A11619
	Offset: 0x17B0
	Size: 0xE1
	Parameters: 3
	Flags: None
*/
function initPersStat(dataName, record_stats, init_to_stat_value)
{
	if(!isdefined(self.pers[dataName]))
	{
		self.pers[dataName] = 0;
	}
	if(!isdefined(record_stats) || record_stats == 1)
	{
		recordPlayerStats(self, dataName, Int(self.pers[dataName]));
	}
	if(isdefined(init_to_stat_value) && init_to_stat_value == 1)
	{
		self.pers[dataName] = self GetDStat("PlayerStatsList", dataName, "StatValue");
	}
}

/*
	Name: getPersStat
	Namespace: globallogic_score
	Checksum: 0xDE0FE12
	Offset: 0x18A0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function getPersStat(dataName)
{
	return self.pers[dataName];
}

/*
	Name: incPersStat
	Namespace: globallogic_score
	Checksum: 0x58F005DC
	Offset: 0x18C0
	Size: 0xBB
	Parameters: 4
	Flags: None
*/
function incPersStat(dataName, increment, record_stats, includeGametype)
{
	PixBeginEvent("incPersStat");
	self.pers[dataName] = self.pers[dataName] + increment;
	self AddPlayerStat(dataName, increment);
	if(!isdefined(record_stats) || record_stats == 1)
	{
		self thread threadedRecordPlayerStats(dataName);
	}
	PixEndEvent();
}

/*
	Name: threadedRecordPlayerStats
	Namespace: globallogic_score
	Checksum: 0xA6430CFA
	Offset: 0x1988
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function threadedRecordPlayerStats(dataName)
{
	self endon("disconnect");
	waittillframeend;
	recordPlayerStats(self, dataName, self.pers[dataName]);
}

/*
	Name: incKillstreakTracker
	Namespace: globallogic_score
	Checksum: 0xB1FE0A37
	Offset: 0x19D0
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function incKillstreakTracker(weapon)
{
	self endon("disconnect");
	waittillframeend;
	if(weapon.name == "artillery")
	{
		self.pers["artillery_kills"]++;
	}
	if(weapon.name == "dog_bite")
	{
		self.pers["dog_kills"]++;
	}
}

/*
	Name: trackAttackerKill
	Namespace: globallogic_score
	Checksum: 0xC8BC6CD1
	Offset: 0x1A50
	Size: 0x343
	Parameters: 5
	Flags: None
*/
function trackAttackerKill(name, rank, XP, prestige, xuid)
{
	self endon("disconnect");
	attacker = self;
	waittillframeend;
	PixBeginEvent("trackAttackerKill");
	if(!isdefined(attacker.pers["killed_players"][name]))
	{
		attacker.pers["killed_players"][name] = 0;
	}
	if(!isdefined(attacker.killedPlayersCurrent[name]))
	{
		attacker.killedPlayersCurrent[name] = 0;
	}
	if(!isdefined(attacker.pers["nemesis_tracking"][name]))
	{
		attacker.pers["nemesis_tracking"][name] = 0;
	}
	attacker.pers["killed_players"][name]++;
	attacker.killedPlayersCurrent[name]++;
	attacker.pers["nemesis_tracking"][name] = attacker.pers["nemesis_tracking"][name] + 1;
	if(attacker.pers["nemesis_name"] == name)
	{
		attacker challenges::killedNemesis();
	}
	if(attacker.pers["nemesis_name"] == "" || attacker.pers["nemesis_tracking"][name] > attacker.pers["nemesis_tracking"][attacker.pers["nemesis_name"]])
	{
		attacker.pers["nemesis_name"] = name;
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_rankIcon"] = prestige;
		attacker.pers["nemesis_xp"] = XP;
		attacker.pers["nemesis_xuid"] = xuid;
	}
	else if(isdefined(attacker.pers["nemesis_name"]) && attacker.pers["nemesis_name"] == name)
	{
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_xp"] = XP;
	}
	PixEndEvent();
}

/*
	Name: trackAttackeeDeath
	Namespace: globallogic_score
	Checksum: 0x7FF2117F
	Offset: 0x1DA0
	Size: 0x2DB
	Parameters: 5
	Flags: None
*/
function trackAttackeeDeath(attackerName, rank, XP, prestige, xuid)
{
	self endon("disconnect");
	waittillframeend;
	PixBeginEvent("trackAttackeeDeath");
	if(!isdefined(self.pers["killed_by"][attackerName]))
	{
		self.pers["killed_by"][attackerName] = 0;
	}
	self.pers["killed_by"][attackerName]++;
	if(!isdefined(self.pers["nemesis_tracking"][attackerName]))
	{
		self.pers["nemesis_tracking"][attackerName] = 0;
	}
	self.pers["nemesis_tracking"][attackerName] = self.pers["nemesis_tracking"][attackerName] + 1.5;
	if(self.pers["nemesis_name"] == "" || self.pers["nemesis_tracking"][attackerName] > self.pers["nemesis_tracking"][self.pers["nemesis_name"]])
	{
		self.pers["nemesis_name"] = attackerName;
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_rankIcon"] = prestige;
		self.pers["nemesis_xp"] = XP;
		self.pers["nemesis_xuid"] = xuid;
	}
	else if(isdefined(self.pers["nemesis_name"]) && self.pers["nemesis_name"] == attackerName)
	{
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_xp"] = XP;
	}
	if(self.pers["nemesis_name"] == attackerName && self.pers["nemesis_tracking"][attackerName] >= 2)
	{
		self setClientUIVisibilityFlag("killcam_nemesis", 1);
	}
	else
	{
		self setClientUIVisibilityFlag("killcam_nemesis", 0);
	}
	PixEndEvent();
}

/*
	Name: default_isKillBoosting
	Namespace: globallogic_score
	Checksum: 0xCEB59323
	Offset: 0x2088
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function default_isKillBoosting()
{
	return 0;
}

/*
	Name: giveKillStats
	Namespace: globallogic_score
	Checksum: 0xC5CF0200
	Offset: 0x2098
	Size: 0x193
	Parameters: 3
	Flags: None
*/
function giveKillStats(sMeansOfDeath, weapon, eVictim)
{
	self endon("disconnect");
	waittillframeend;
	if(level.rankedMatch && self [[level.isKillBoosting]]())
	{
		/#
			self IPrintLnBold("Dev Block strings are not supported");
		#/
		return;
	}
	PixBeginEvent("giveKillStats");
	self incPersStat("kills", 1, 1, 1);
	self.kills = self getPersStat("kills");
	self UpdateStatRatio("kdratio", "kills", "deaths");
	attacker = self;
	if(sMeansOfDeath == "MOD_HEAD_SHOT")
	{
		attacker thread incPersStat("headshots", 1, 1, 0);
		attacker.headshots = attacker.pers["headshots"];
		eVictim RecordKillModifier("headshot");
	}
	PixEndEvent();
}

/*
	Name: incTotalKills
	Namespace: globallogic_score
	Checksum: 0x2B68BCF3
	Offset: 0x2238
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function incTotalKills(team)
{
	if(level.teambased && isdefined(level.teams[team]))
	{
		game["totalKillsTeam"][team]++;
	}
	game["totalKills"]++;
}

/*
	Name: setInflictorStat
	Namespace: globallogic_score
	Checksum: 0x964B3F67
	Offset: 0x2290
	Size: 0x17B
	Parameters: 3
	Flags: None
*/
function setInflictorStat(eInflictor, eAttacker, weapon)
{
	if(!isdefined(eAttacker))
	{
		return;
	}
	if(!isdefined(eInflictor))
	{
		eAttacker addweaponstat(weapon, "hits", 1);
		return;
	}
	if(!isdefined(eInflictor.playerAffectedArray))
	{
		eInflictor.playerAffectedArray = [];
	}
	foundNewPlayer = 1;
	for(i = 0; i < eInflictor.playerAffectedArray.size; i++)
	{
		if(eInflictor.playerAffectedArray[i] == self)
		{
			foundNewPlayer = 0;
			break;
		}
	}
	if(foundNewPlayer)
	{
		eInflictor.playerAffectedArray[eInflictor.playerAffectedArray.size] = self;
		if(weapon == "concussion_grenade" || weapon == "tabun_gas")
		{
			eAttacker addweaponstat(weapon, "used", 1);
		}
		eAttacker addweaponstat(weapon, "hits", 1);
	}
}

/*
	Name: processShieldAssist
	Namespace: globallogic_score
	Checksum: 0x9648CB23
	Offset: 0x2418
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function processShieldAssist(killedplayer)
{
	self endon("disconnect");
	killedplayer endon("disconnect");
	wait(0.05);
	util::WaitTillSlowProcessAllowed();
	if(!isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(self.pers["team"] == killedplayer.pers["team"])
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	self incPersStat("assists", 1, 1, 1);
	self.assists = self getPersStat("assists");
}

/*
	Name: processAssist
	Namespace: globallogic_score
	Checksum: 0x8C62DCC3
	Offset: 0x2508
	Size: 0x22B
	Parameters: 3
	Flags: None
*/
function processAssist(killedplayer, damagedone, weapon)
{
	self endon("disconnect");
	killedplayer endon("disconnect");
	wait(0.05);
	util::WaitTillSlowProcessAllowed();
	if(!isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(self.pers["team"] == killedplayer.pers["team"])
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	assist_level = "assist";
	assist_level_value = Int(ceil(damagedone / 25));
	if(assist_level_value < 1)
	{
		assist_level_value = 1;
	}
	else if(assist_level_value > 3)
	{
		assist_level_value = 3;
	}
	assist_level = assist_level + "_" + assist_level_value * 25;
	self incPersStat("assists", 1, 1, 1);
	self.assists = self getPersStat("assists");
	switch(weapon.name)
	{
		case "concussion_grenade":
		{
			assist_level = "assist_concussion";
			break;
		}
		case "flash_grenade":
		{
			assist_level = "assist_flash";
			break;
		}
		case "emp_grenade":
		{
			assist_level = "assist_emp";
			break;
		}
		case "proximity_grenade":
		case "proximity_grenade_aoe":
		{
			assist_level = "assist_proximity";
			break;
		}
	}
	self challenges::assisted();
}

/*
	Name: xpRateThread
	Namespace: globallogic_score
	Checksum: 0x662CEBCE
	Offset: 0x2740
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function xpRateThread()
{
	/#
	#/
}

