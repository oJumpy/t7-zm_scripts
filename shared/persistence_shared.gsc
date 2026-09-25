#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace persistence;

/*
	Name: __init__sytem__
	Namespace: persistence
	Checksum: 0x49C3934F
	Offset: 0x2E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("persistence", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: persistence
	Checksum: 0xB769779C
	Offset: 0x320
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: persistence
	Checksum: 0x3744D723
	Offset: 0x370
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function init()
{
	level.can_set_aar_stat = 1;
	level.persistentDataInfo = [];
	level.maxRecentStats = 10;
	level.maxHitLocations = 19;
	level thread initialize_stat_tracking();
	level thread upload_global_stat_counters();
}

/*
	Name: on_player_connect
	Namespace: persistence
	Checksum: 0x47BCFEEB
	Offset: 0x3E0
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.enableText = 1;
}

/*
	Name: initialize_stat_tracking
	Namespace: persistence
	Checksum: 0x12EA8F85
	Offset: 0x3F8
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function initialize_stat_tracking()
{
	level.globalExecutions = 0;
	level.globalChallenges = 0;
	level.globalSharePackages = 0;
	level.globalContractsFailed = 0;
	level.globalContractsPassed = 0;
	level.globalContractsCPPaid = 0;
	level.globalKillstreaksCalled = 0;
	level.globalKillstreaksDestroyed = 0;
	level.globalKillstreaksDeathsFrom = 0;
	level.globalLarrysKilled = 0;
	level.globalBuzzKills = 0;
	level.globalRevives = 0;
	level.globalAfterlifes = 0;
	level.globalComebacks = 0;
	level.globalPaybacks = 0;
	level.globalBackstabs = 0;
	level.globalBankshots = 0;
	level.globalSkewered = 0;
	level.globalTeamMedals = 0;
	level.globalFeetFallen = 0;
	level.globalDistanceSprinted = 0;
	level.globalDemBombsProtected = 0;
	level.globalDemBombsDestroyed = 0;
	level.globalBombsDestroyed = 0;
	level.globalFragGrenadesFired = 0;
	level.globalSatchelChargeFired = 0;
	level.globalShotsFired = 0;
	level.globalCrossbowFired = 0;
	level.globalCarsDestroyed = 0;
	level.globalBarrelsDestroyed = 0;
	level.globalBombsDestroyedByTeam = [];
	foreach(team in level.teams)
	{
		level.globalBombsDestroyedByTeam[team] = 0;
	}
}

/*
	Name: upload_global_stat_counters
	Namespace: persistence
	Checksum: 0xCFF142CE
	Offset: 0x5F8
	Size: 0x64B
	Parameters: 0
	Flags: None
*/
function upload_global_stat_counters()
{
	level waittill("game_ended");
	if(!level.rankedMatch && !level.wagerMatch)
	{
		return;
	}
	totalKills = 0;
	totalDeaths = 0;
	totalAssists = 0;
	totalHeadshots = 0;
	totalSuicides = 0;
	totalTimePlayed = 0;
	totalFlagsCaptured = 0;
	totalFlagsReturned = 0;
	totalHQsDestroyed = 0;
	totalHQsCaptured = 0;
	totalSDDefused = 0;
	totalSDPlants = 0;
	totalHumiliations = 0;
	totalSabDestroyedByTeam = [];
	foreach(team in level.teams)
	{
		totalSabDestroyedByTeam[team] = 0;
	}
	switch(level.gametype)
	{
		case "dem":
		{
			bombZonesLeft = 0;
			for(index = 0; index < level.bombZones.size; index++)
			{
				if(!isdefined(level.bombZones[index].bombExploded) || !level.bombZones[index].bombExploded)
				{
					level.globalDemBombsProtected++;
					continue;
				}
				level.globalDemBombsDestroyed++;
			}
			break;
		}
		case "sab":
		{
			foreach(team in level.teams)
			{
				totalSabDestroyedByTeam[team] = level.globalBombsDestroyedByTeam[team];
			}
			break;
		}
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.timePlayed) && isdefined(player.timePlayed["total"]))
		{
			totalTimePlayed = totalTimePlayed + min(player.timePlayed["total"], level.timeplayedcap);
		}
	}
	if(!util::wasLastRound())
	{
		return;
	}
	wait(0.05);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		totalKills = totalKills + player.kills;
		totalDeaths = totalDeaths + player.deaths;
		totalAssists = totalAssists + player.assists;
		totalHeadshots = totalHeadshots + player.headshots;
		totalSuicides = totalSuicides + player.suicides;
		totalHumiliations = totalHumiliations + player.humiliated;
		if(isdefined(player.timePlayed) && isdefined(player.timePlayed["alive"]))
		{
			totalTimePlayed = totalTimePlayed + Int(min(player.timePlayed["alive"], level.timeplayedcap));
		}
		switch(level.gametype)
		{
			case "ctf":
			{
				totalFlagsCaptured = totalFlagsCaptured + player.Captures;
				totalFlagsReturned = totalFlagsReturned + player.returns;
				break;
			}
			case "koth":
			{
				totalHQsDestroyed = totalHQsDestroyed + player.destructions;
				totalHQsCaptured = totalHQsCaptured + player.Captures;
				break;
			}
			case "sd":
			{
				totalSDDefused = totalSDDefused + player.Defuses;
				totalSDPlants = totalSDPlants + player.Plants;
				break;
			}
			case "sab":
			{
				if(isdefined(player.team) && isdefined(level.teams[player.team]))
				{
					totalSabDestroyedByTeam[player.team] = totalSabDestroyedByTeam[player.team] + player.destructions;
				}
				break;
			}
		}
	}
}

/*
	Name: stat_get_with_gametype
	Namespace: persistence
	Checksum: 0x1596B8A
	Offset: 0xC50
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function stat_get_with_gametype(dataName)
{
	if(isdefined(level.noPersistence) && level.noPersistence)
	{
		return 0;
	}
	if(!level.onlineGame)
	{
		return 0;
	}
	return self GetDStat("PlayerStatsByGameType", get_gametype_name(), dataName, "StatValue");
}

/*
	Name: get_gametype_name
	Namespace: persistence
	Checksum: 0x9C5B71A6
	Offset: 0xCC8
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function get_gametype_name()
{
	if(!isdefined(level.fullGameTypeName))
	{
		if(isdefined(level.hardcoreMode) && level.hardcoreMode && is_party_gamemode() == 0)
		{
			prefix = "HC";
		}
		else
		{
			prefix = "";
		}
		level.fullGameTypeName = ToLower(prefix + level.gametype);
	}
	return level.fullGameTypeName;
}

/*
	Name: is_party_gamemode
	Namespace: persistence
	Checksum: 0xD64314C3
	Offset: 0xD70
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function is_party_gamemode()
{
	switch(level.gametype)
	{
		case "gun":
		case "oic":
		case "sas":
		case "shrp":
		{
			return 1;
			break;
		}
	}
	return 0;
}

/*
	Name: is_stat_modifiable
	Namespace: persistence
	Checksum: 0xA64BA86B
	Offset: 0xDC0
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function is_stat_modifiable(dataName)
{
	return level.rankedMatch || level.wagerMatch;
}

/*
	Name: stat_set_with_gametype
	Namespace: persistence
	Checksum: 0xC8CD075A
	Offset: 0xDE8
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function stat_set_with_gametype(dataName, value, incValue)
{
	if(isdefined(level.noPersistence) && level.noPersistence)
	{
		return 0;
	}
	if(!is_stat_modifiable(dataName))
	{
		return;
	}
	if(level.disableStatTracking)
	{
		return;
	}
	self SetDStat("PlayerStatsByGameType", get_gametype_name(), dataName, "StatValue", value);
}

/*
	Name: adjust_recent_stats
	Namespace: persistence
	Checksum: 0x72473311
	Offset: 0xE90
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function adjust_recent_stats()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1 || GetDvarInt("Dev Block strings are not supported") == 1)
		{
			return;
		}
	#/
	initialize_match_stats();
}

/*
	Name: get_recent_stat
	Namespace: persistence
	Checksum: 0x6A7ED652
	Offset: 0xF00
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function get_recent_stat(isGlobal, index, statName)
{
	if(level.wagerMatch)
	{
		return self GetDStat("RecentEarnings", index, statName);
	}
	else if(isGlobal)
	{
		modeName = util::GetCurrentGameMode();
		return self GetDStat("gameHistory", modeName, "matchHistory", index, statName);
	}
	else
	{
		return self GetDStat("PlayerStatsByGameType", get_gametype_name(), "prevScores", index, statName);
	}
}

/*
	Name: set_recent_stat
	Namespace: persistence
	Checksum: 0x548D8952
	Offset: 0xFF8
	Size: 0x1A3
	Parameters: 4
	Flags: None
*/
function set_recent_stat(isGlobal, index, statName, value)
{
	if(!isGlobal)
	{
		index = self GetDStat("PlayerStatsByGameType", get_gametype_name(), "prevScoreIndex");
		if(index < 0 || index > 9)
		{
			return;
		}
	}
	if(isdefined(level.noPersistence) && level.noPersistence)
	{
		return;
	}
	if(!level.onlineGame)
	{
		return;
	}
	if(!is_stat_modifiable(statName))
	{
		return;
	}
	if(level.wagerMatch)
	{
		self SetDStat("RecentEarnings", index, statName, value);
	}
	else if(isGlobal)
	{
		modeName = util::GetCurrentGameMode();
		self SetDStat("gameHistory", modeName, "matchHistory", "" + index, statName, value);
	}
	else
	{
		self SetDStat("PlayerStatsByGameType", get_gametype_name(), "prevScores", index, statName, value);
	}
}

/*
	Name: add_recent_stat
	Namespace: persistence
	Checksum: 0x2C7C70B1
	Offset: 0x11A8
	Size: 0x113
	Parameters: 4
	Flags: None
*/
function add_recent_stat(isGlobal, index, statName, value)
{
	if(isdefined(level.noPersistence) && level.noPersistence)
	{
		return;
	}
	if(!level.onlineGame)
	{
		return;
	}
	if(!is_stat_modifiable(statName))
	{
		return;
	}
	if(!isGlobal)
	{
		index = self GetDStat("PlayerStatsByGameType", get_gametype_name(), "prevScoreIndex");
		if(index < 0 || index > 9)
		{
			return;
		}
	}
	currStat = get_recent_stat(isGlobal, index, statName);
	set_recent_stat(isGlobal, index, statName, currStat + value);
}

/*
	Name: set_match_history_stat
	Namespace: persistence
	Checksum: 0x7E27CAAD
	Offset: 0x12C8
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function set_match_history_stat(statName, value)
{
	modeName = util::GetCurrentGameMode();
	historyIndex = self GetDStat("gameHistory", modeName, "currentMatchHistoryIndex");
	set_recent_stat(1, historyIndex, statName, value);
}

/*
	Name: add_match_history_stat
	Namespace: persistence
	Checksum: 0x28B7481F
	Offset: 0x1360
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function add_match_history_stat(statName, value)
{
	modeName = util::GetCurrentGameMode();
	historyIndex = self GetDStat("gameHistory", modeName, "currentMatchHistoryIndex");
	add_recent_stat(1, historyIndex, statName, value);
}

/*
	Name: initialize_match_stats
	Namespace: persistence
	Checksum: 0xB95F26C1
	Offset: 0x13F8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function initialize_match_stats()
{
	if(isdefined(level.noPersistence) && level.noPersistence)
	{
		return;
	}
	if(!level.onlineGame)
	{
		return;
	}
	if(!(level.rankedMatch || level.wagerMatch || level.leagueMatch))
	{
		return;
	}
	self.pers["lastHighestScore"] = self GetDStat("HighestStats", "highest_score");
	if(SessionModeIsMultiplayerGame())
	{
		self.pers["lastHighestKills"] = self GetDStat("HighestStats", "highest_kills");
		self.pers["lastHighestKDRatio"] = self GetDStat("HighestStats", "highest_kdratio");
	}
	currGameType = get_gametype_name();
	self GameHistoryStartMatch(getGameTypeEnumFromName(currGameType, level.hardcoreMode));
}

/*
	Name: can_set_aar_stat
	Namespace: persistence
	Checksum: 0xDBE4A28A
	Offset: 0x1560
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function can_set_aar_stat()
{
	return level.can_set_aar_stat;
}

/*
	Name: set_after_action_report_player_stat
	Namespace: persistence
	Checksum: 0x9B2523CB
	Offset: 0x1578
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function set_after_action_report_player_stat(playerIndex, statName, value)
{
	if(can_set_aar_stat())
	{
		self SetDStat("AfterActionReportStats", "playerStats", playerIndex, statName, value);
	}
}

/*
	Name: set_after_action_report_player_medal
	Namespace: persistence
	Checksum: 0xC05153
	Offset: 0x15E0
	Size: 0x63
	Parameters: 3
	Flags: None
*/
function set_after_action_report_player_medal(playerIndex, medalIndex, value)
{
	if(can_set_aar_stat())
	{
		self SetDStat("AfterActionReportStats", "playerStats", playerIndex, "medals", medalIndex, value);
	}
}

/*
	Name: set_after_action_report_stat
	Namespace: persistence
	Checksum: 0x54B78D3
	Offset: 0x1650
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function set_after_action_report_stat(statName, value, index)
{
	if(self util::is_bot())
	{
		return;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1 || GetDvarInt("Dev Block strings are not supported") == 1)
		{
			return;
		}
	#/
	if(can_set_aar_stat())
	{
		if(isdefined(index))
		{
			self setAARStat(statName, index, value);
		}
		else
		{
			self setAARStat(statName, value);
		}
	}
}

/*
	Name: CodeCallback_ChallengeComplete
	Namespace: persistence
	Checksum: 0x94783F53
	Offset: 0x1740
	Size: 0x4EB
	Parameters: 7
	Flags: None
*/
function CodeCallback_ChallengeComplete(rewardXP, maxVal, row, tableNumber, challengeType, itemIndex, challengeIndex)
{
	params = spawnstruct();
	params.rewardXP = rewardXP;
	params.maxVal = maxVal;
	params.row = row;
	params.tableNumber = tableNumber;
	params.challengeType = challengeType;
	params.itemIndex = itemIndex;
	params.challengeIndex = challengeIndex;
	if(SessionModeIsCampaignGame())
	{
		if(isdefined(self.challenge_callback_cp))
		{
			[[self.challenge_callback_cp]](rewardXP, maxVal, row, tableNumber, challengeType, itemIndex, challengeIndex);
		}
		return;
	}
	callback::callback("hash_b286c65c", params);
	self LUINotifyEvent(&"challenge_complete", 7, challengeIndex, itemIndex, challengeType, tableNumber, row, maxVal, rewardXP);
	self LUINotifyEventToSpectators(&"challenge_complete", 7, challengeIndex, itemIndex, challengeType, tableNumber, row, maxVal, rewardXP);
	tableNumber = tableNumber + 1;
	tableName = "gamedata/stats/mp/statsmilestones" + tableNumber + ".csv";
	challengeString = TableLookupColumnForRow(tableName, row, 5);
	challengeTier = Int(TableLookupColumnForRow(tableName, row, 1));
	matchRecordLogChallengeComplete(self, tableNumber, challengeTier, itemIndex, challengeString);
	/#
		if(GetDvarInt("Dev Block strings are not supported", 0) != 0)
		{
			var_9177f6a4 = challengeString + "Dev Block strings are not supported";
			var_c7a31427 = Int(TableLookupColumnForRow(tableName, row + 1, 1));
			var_fea026e8 = "Dev Block strings are not supported" + challengeTier;
			statsTableName = "Dev Block strings are not supported";
			var_49ea66ba = tableLookup(statsTableName, 0, itemIndex, 3);
			if(GetDvarInt("Dev Block strings are not supported") == 1)
			{
				IPrintLnBold(MakeLocalizedString(challengeString) + "Dev Block strings are not supported" + maxVal + "Dev Block strings are not supported" + MakeLocalizedString(var_49ea66ba));
			}
			else if(GetDvarInt("Dev Block strings are not supported") == 2)
			{
				self IPrintLnBold(MakeLocalizedString(challengeString) + "Dev Block strings are not supported" + maxVal + "Dev Block strings are not supported" + MakeLocalizedString(var_49ea66ba));
			}
			else if(GetDvarInt("Dev Block strings are not supported") == 3)
			{
				iprintln(MakeLocalizedString(challengeString) + "Dev Block strings are not supported" + maxVal + "Dev Block strings are not supported" + MakeLocalizedString(var_49ea66ba));
			}
		}
	#/
}

/*
	Name: CodeCallback_GunChallengeComplete
	Namespace: persistence
	Checksum: 0x4B56AA13
	Offset: 0x1C38
	Size: 0xC3
	Parameters: 5
	Flags: None
*/
function CodeCallback_GunChallengeComplete(rewardXP, attachmentIndex, itemIndex, rankID, isLastRank)
{
	if(SessionModeIsCampaignGame())
	{
		self notify("gun_level_complete", rewardXP, attachmentIndex, itemIndex, rankID, isLastRank);
		return;
	}
	self LUINotifyEvent(&"gun_level_complete", 4, rankID, itemIndex, attachmentIndex, rewardXP);
	self LUINotifyEventToSpectators(&"gun_level_complete", 4, rankID, itemIndex, attachmentIndex, rewardXP);
}

/*
	Name: check_contract_expirations
	Namespace: persistence
	Checksum: 0x99EC1590
	Offset: 0x1D08
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function check_contract_expirations()
{
}

/*
	Name: increment_contract_times
	Namespace: persistence
	Checksum: 0xDA1ECC9A
	Offset: 0x1D18
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function increment_contract_times(timeInc)
{
}

/*
	Name: add_contract_to_queue
	Namespace: persistence
	Checksum: 0x1CF34034
	Offset: 0x1D30
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function add_contract_to_queue(index, passed)
{
}

/*
	Name: upload_stats_soon
	Namespace: persistence
	Checksum: 0x2BFC891E
	Offset: 0x1D50
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function upload_stats_soon()
{
	self notify("upload_stats_soon");
	self endon("upload_stats_soon");
	self endon("disconnect");
	wait(1);
	UploadStats(self);
}

/*
	Name: CodeCallback_OnAddPlayerStat
	Namespace: persistence
	Checksum: 0x18C2EE21
	Offset: 0x1DA0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function CodeCallback_OnAddPlayerStat(dataName, value)
{
}

/*
	Name: CodeCallback_OnAddWeaponStat
	Namespace: persistence
	Checksum: 0xA2AD2F60
	Offset: 0x1DC0
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function CodeCallback_OnAddWeaponStat(weapon, dataName, value)
{
}

/*
	Name: process_contracts_on_add_stat
	Namespace: persistence
	Checksum: 0xA75F9D15
	Offset: 0x1DE8
	Size: 0x23
	Parameters: 4
	Flags: None
*/
function process_contracts_on_add_stat(statType, dataName, value, weapon)
{
}

