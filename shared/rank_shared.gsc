#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace rank;

/*
	Name: __init__sytem__
	Namespace: rank
	Checksum: 0xAD97CE6B
	Offset: 0x6E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("rank", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: rank
	Checksum: 0x51E9FE91
	Offset: 0x720
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
	Namespace: rank
	Checksum: 0x6C7A32A6
	Offset: 0x750
	Size: 0x583
	Parameters: 0
	Flags: None
*/
function init()
{
	level.scoreInfo = [];
	level.codPointsXpScale = GetDvarFloat("scr_codpointsxpscale");
	level.codPointsMatchScale = GetDvarFloat("scr_codpointsmatchscale");
	level.codPointsChallengeScale = GetDvarFloat("scr_codpointsperchallenge");
	level.rankXpCap = GetDvarInt("scr_rankXpCap");
	level.codPointsCap = GetDvarInt("scr_codPointsCap");
	level.usingMomentum = 1;
	level.usingScoreStreaks = GetDvarInt("scr_scorestreaks") != 0;
	level.scoreStreaksMaxStacking = GetDvarInt("scr_scorestreaks_maxstacking");
	level.maxInventoryScoreStreaks = GetDvarInt("scr_maxinventory_scorestreaks", 3);
	level.usingRampage = !isdefined(level.usingScoreStreaks) || !level.usingScoreStreaks;
	level.rampageBonusScale = GetDvarFloat("scr_rampagebonusscale");
	level.rankTable = [];
	if(SessionModeIsCampaignGame())
	{
		level.xpScale = GetDvarFloat("scr_xpscalecp");
		level.ranktable_name = "gamedata/tables/cp/cp_ranktable.csv";
		level.rankicontable_name = "gamedata/tables/cp/cp_rankIconTable.csv";
	}
	else if(SessionModeIsZombiesGame())
	{
		level.xpScale = GetDvarFloat("scr_xpscalezm");
		level.ranktable_name = "gamedata/tables/zm/zm_ranktable.csv";
		level.rankicontable_name = "gamedata/tables/zm/zm_rankIconTable.csv";
	}
	else
	{
		level.xpScale = GetDvarFloat("scr_xpscalemp");
		level.ranktable_name = "gamedata/tables/mp/mp_ranktable.csv";
		level.rankicontable_name = "gamedata/tables/mp/mp_rankIconTable.csv";
	}
	initScoreInfo();
	level.maxRank = Int(tableLookup(level.ranktable_name, 0, "maxrank", 1));
	level.maxRankStarterPack = Int(tableLookup(level.ranktable_name, 0, "maxrankstarterpack", 1));
	level.maxPrestige = Int(tableLookup(level.rankicontable_name, 0, "maxprestige", 1));
	rankID = 0;
	rankName = tableLookup(level.ranktable_name, 0, rankID, 1);
	/#
		Assert(isdefined(rankName) && rankName != "Dev Block strings are not supported");
	#/
	while(isdefined(rankName) && rankName != "")
	{
		level.rankTable[rankID][1] = tableLookup(level.ranktable_name, 0, rankID, 1);
		level.rankTable[rankID][2] = tableLookup(level.ranktable_name, 0, rankID, 2);
		level.rankTable[rankID][3] = tableLookup(level.ranktable_name, 0, rankID, 3);
		level.rankTable[rankID][7] = tableLookup(level.ranktable_name, 0, rankID, 7);
		level.rankTable[rankID][14] = tableLookup(level.ranktable_name, 0, rankID, 14);
		if(SessionModeIsCampaignGame())
		{
			level.rankTable[rankID][18] = tableLookup(level.ranktable_name, 0, rankID, 18);
		}
		rankID++;
		rankName = tableLookup(level.ranktable_name, 0, rankID, 1);
	}
	callback::on_connect(&on_player_connect);
}

/*
	Name: initScoreInfo
	Namespace: rank
	Checksum: 0xBB4AFA63
	Offset: 0xCE0
	Size: 0x56B
	Parameters: 0
	Flags: None
*/
function initScoreInfo()
{
	scoreInfoTableID = scoreevents::getScoreEventTableID();
	/#
		Assert(isdefined(scoreInfoTableID));
	#/
	if(!isdefined(scoreInfoTableID))
	{
		return;
	}
	scoreColumn = scoreevents::getScoreEventColumn(level.gametype);
	xpColumn = scoreevents::getXPEventColumn(level.gametype);
	/#
		Assert(scoreColumn >= 0);
	#/
	if(scoreColumn < 0)
	{
		return;
	}
	/#
		Assert(xpColumn >= 0);
	#/
	if(xpColumn < 0)
	{
		return;
	}
	for(row = 1; row < 512; row++)
	{
		type = TableLookupColumnForRow(scoreInfoTableID, row, 0);
		if(type != "")
		{
			labelString = TableLookupColumnForRow(scoreInfoTableID, row, 1);
			label = undefined;
			if(labelString != "")
			{
				label = tableLookupIString(scoreInfoTableID, 0, type, 1);
			}
			teamScoreString = TableLookupColumnForRow(scoreInfoTableID, row, 4);
			teamscore_material = undefined;
			if(teamScoreString != "")
			{
				teamscore_material = tableLookupIString(scoreInfoTableID, 0, type, 4);
			}
			scoreValue = Int(TableLookupColumnForRow(scoreInfoTableID, row, scoreColumn));
			xpValue = Int(TableLookupColumnForRow(scoreInfoTableID, row, xpColumn));
			registerScoreInfo(type, scoreValue, xpValue, label, teamscore_material);
			if(!isdefined(game["ScoreInfoInitialized"]))
			{
				xpValue = float(TableLookupColumnForRow(scoreInfoTableID, row, xpColumn));
				setDDLStat = TableLookupColumnForRow(scoreInfoTableID, row, 8);
				AddPlayerStat = 0;
				if(setDDLStat == "TRUE")
				{
					AddPlayerStat = 1;
				}
				isMedal = 0;
				istring = tableLookupIString(scoreInfoTableID, 0, type, 2);
				if(isdefined(istring) && istring != &"")
				{
					isMedal = 1;
				}
				demoBookmarkPriority = Int(TableLookupColumnForRow(scoreInfoTableID, row, 9));
				if(!isdefined(demoBookmarkPriority))
				{
					demoBookmarkPriority = 0;
				}
				RegisterXP(type, xpValue, AddPlayerStat, isMedal, demoBookmarkPriority, row);
			}
			allowKillstreakWeapons = TableLookupColumnForRow(scoreInfoTableID, row, 5);
			if(allowKillstreakWeapons == "TRUE")
			{
				level.scoreInfo[type]["allowKillstreakWeapons"] = 1;
			}
			allowHero = TableLookupColumnForRow(scoreInfoTableID, row, 7);
			if(allowHero == "TRUE")
			{
				level.scoreInfo[type]["allow_hero"] = 1;
			}
			combatEfficiencyEvent = TableLookupColumnForRow(scoreInfoTableID, row, 6);
			if(isdefined(combatEfficiencyEvent) && combatEfficiencyEvent != "")
			{
				level.scoreInfo[type]["combat_efficiency_event"] = combatEfficiencyEvent;
			}
		}
	}
	game["ScoreInfoInitialized"] = 1;
}

/*
	Name: getRankXPCapped
	Namespace: rank
	Checksum: 0xCA12B509
	Offset: 0x1258
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function getRankXPCapped(inRankXp)
{
	if(isdefined(level.rankXpCap) && level.rankXpCap && level.rankXpCap <= inRankXp)
	{
		return level.rankXpCap;
	}
	return inRankXp;
}

/*
	Name: getCodPointsCapped
	Namespace: rank
	Checksum: 0x543DAEEB
	Offset: 0x12A0
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function getCodPointsCapped(inCodPoints)
{
	if(isdefined(level.codPointsCap) && level.codPointsCap && level.codPointsCap <= inCodPoints)
	{
		return level.codPointsCap;
	}
	return inCodPoints;
}

/*
	Name: registerScoreInfo
	Namespace: rank
	Checksum: 0x2F451C23
	Offset: 0x12E8
	Size: 0x1AF
	Parameters: 5
	Flags: None
*/
function registerScoreInfo(type, value, XP, label, teamscore_material)
{
	overrideDvar = "scr_" + level.gametype + "_score_" + type;
	if(GetDvarString(overrideDvar) != "")
	{
		value = GetDvarInt(overrideDvar);
	}
	if(type == "kill")
	{
		multiplier = GetGametypeSetting("killEventScoreMultiplier");
		level.scoreInfo[type]["value"] = value;
		if(multiplier > 0)
		{
			level.scoreInfo[type]["value"] = Int(multiplier * value);
		}
	}
	else
	{
		level.scoreInfo[type]["value"] = value;
	}
	level.scoreInfo[type]["xp"] = XP;
	if(isdefined(label))
	{
		level.scoreInfo[type]["label"] = label;
	}
	if(isdefined(teamscore_material))
	{
		level.scoreInfo[type]["team_icon"] = teamscore_material;
	}
}

/*
	Name: getScoreInfoValue
	Namespace: rank
	Checksum: 0x2645D314
	Offset: 0x14A0
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function getScoreInfoValue(type)
{
	if(isdefined(level.scoreInfo[type]))
	{
		n_score = level.scoreInfo[type]["value"];
		if(isdefined(level.scoreModifierCallback) && isdefined(n_score))
		{
			n_score = [[level.scoreModifierCallback]](type, n_score);
		}
		return n_score;
	}
}

/*
	Name: getScoreInfoXP
	Namespace: rank
	Checksum: 0x3CEB7265
	Offset: 0x1528
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function getScoreInfoXP(type)
{
	if(isdefined(level.scoreInfo[type]))
	{
		n_xp = level.scoreInfo[type]["xp"];
		if(isdefined(level.xpModifierCallback) && isdefined(n_xp))
		{
			n_xp = [[level.xpModifierCallback]](type, n_xp);
		}
		return n_xp;
	}
}

/*
	Name: shouldSkipMomentumDisplay
	Namespace: rank
	Checksum: 0x2ADC181E
	Offset: 0x15B0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function shouldSkipMomentumDisplay(type)
{
	if(isdefined(level.disableMomentum) && level.disableMomentum)
	{
		return 1;
	}
	if(isdefined(level.teamScoreUICallback) && isdefined(level.scoreInfo[type]["team_icon"]))
	{
		return 1;
	}
	return 0;
}

/*
	Name: getScoreInfoLabel
	Namespace: rank
	Checksum: 0x3A8619FD
	Offset: 0x1610
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function getScoreInfoLabel(type)
{
	return level.scoreInfo[type]["label"];
}

/*
	Name: getCombatEfficiencyEvent
	Namespace: rank
	Checksum: 0x41CC360
	Offset: 0x1640
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function getCombatEfficiencyEvent(type)
{
	return level.scoreInfo[type]["combat_efficiency_event"];
}

/*
	Name: doesScoreInfoCountTowardRampage
	Namespace: rank
	Checksum: 0x859BA387
	Offset: 0x1670
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function doesScoreInfoCountTowardRampage(type)
{
	return isdefined(level.scoreInfo[type]["rampage"]) && level.scoreInfo[type]["rampage"];
}

/*
	Name: getRankInfoMinXP
	Namespace: rank
	Checksum: 0xAE52A085
	Offset: 0x16B8
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function getRankInfoMinXP(rankID)
{
	return Int(level.rankTable[rankID][2]);
}

/*
	Name: getRankInfoXPAmt
	Namespace: rank
	Checksum: 0xA9D64B95
	Offset: 0x16F8
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function getRankInfoXPAmt(rankID)
{
	return Int(level.rankTable[rankID][3]);
}

/*
	Name: getRankInfoMaxXp
	Namespace: rank
	Checksum: 0x2E3B73E9
	Offset: 0x1738
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function getRankInfoMaxXp(rankID)
{
	return Int(level.rankTable[rankID][7]);
}

/*
	Name: getRankInfoFull
	Namespace: rank
	Checksum: 0x692D9C7D
	Offset: 0x1778
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function getRankInfoFull(rankID)
{
	return tableLookupIString(level.ranktable_name, 0, rankID, 16);
}

/*
	Name: getRankInfoIcon
	Namespace: rank
	Checksum: 0xC8ABBFC0
	Offset: 0x17B0
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function getRankInfoIcon(rankID, prestigeId)
{
	return tableLookup(level.rankicontable_name, 0, rankID, prestigeId + 1);
}

/*
	Name: getRankInfoLevel
	Namespace: rank
	Checksum: 0xBEDDB22C
	Offset: 0x17F8
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function getRankInfoLevel(rankID)
{
	return Int(tableLookup(level.ranktable_name, 0, rankID, 13));
}

/*
	Name: getRankInfoCodPointsEarned
	Namespace: rank
	Checksum: 0x4FF70D3E
	Offset: 0x1848
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function getRankInfoCodPointsEarned(rankID)
{
	return Int(tableLookup(level.ranktable_name, 0, rankID, 17));
}

/*
	Name: shouldKickByRank
	Namespace: rank
	Checksum: 0x4140A883
	Offset: 0x1898
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function shouldKickByRank()
{
	if(self IsHost())
	{
		return 0;
	}
	if(level.rankCap > 0 && self.pers["rank"] > level.rankCap)
	{
		return 1;
	}
	if(level.rankCap > 0 && level.minPrestige == 0 && self.pers["plevel"] > 0)
	{
		return 1;
	}
	if(level.minPrestige > self.pers["plevel"])
	{
		return 1;
	}
	return 0;
}

/*
	Name: getCodPointsStat
	Namespace: rank
	Checksum: 0xD867DB71
	Offset: 0x1960
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function getCodPointsStat()
{
	codPoints = self GetDStat("playerstatslist", "CODPOINTS", "StatValue");
	codPointsCapped = getCodPointsCapped(codPoints);
	if(codPoints > codPointsCapped)
	{
		self setCodPointsStat(codPointsCapped);
	}
	return codPointsCapped;
}

/*
	Name: setCodPointsStat
	Namespace: rank
	Checksum: 0xCC1A9CC
	Offset: 0x19F0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function setCodPointsStat(codPoints)
{
	self SetDStat("PlayerStatsList", "CODPOINTS", "StatValue", getCodPointsCapped(codPoints));
}

/*
	Name: getRankXpStat
	Namespace: rank
	Checksum: 0x5D49367
	Offset: 0x1A48
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function getRankXpStat()
{
	RANKXP = self GetDStat("playerstatslist", "RANKXP", "StatValue");
	rankXpCapped = getRankXPCapped(RANKXP);
	if(RANKXP > rankXpCapped)
	{
		self SetDStat("playerstatslist", "RANKXP", "StatValue", rankXpCapped);
	}
	return rankXpCapped;
}

/*
	Name: getArenaPointsStat
	Namespace: rank
	Checksum: 0x96D8F505
	Offset: 0x1AF0
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function getArenaPointsStat()
{
	arenaSlot = ArenaGetSlot();
	arenaPoints = self GetDStat("arenaStats", arenaSlot, "points");
	return arenaPoints + 1;
}

/*
	Name: on_player_connect
	Namespace: rank
	Checksum: 0x41400E7B
	Offset: 0x1B60
	Size: 0x68B
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.pers["rankxp"] = self getRankXpStat();
	self.pers["codpoints"] = self getCodPointsStat();
	self.pers["currencyspent"] = self GetDStat("playerstatslist", "currencyspent", "StatValue");
	rankID = self getRankForXp(self getRankXP());
	self.pers["rank"] = rankID;
	self.pers["plevel"] = self GetDStat("playerstatslist", "PLEVEL", "StatValue");
	if(self shouldKickByRank())
	{
		kick(self GetEntityNumber());
		return;
	}
	if(!isdefined(self.pers["participation"]))
	{
		self.pers["participation"] = 0;
	}
	self.rankUpdateTotal = 0;
	self.cur_rankNum = rankID;
	/#
		Assert(isdefined(self.cur_rankNum), "Dev Block strings are not supported" + rankID + "Dev Block strings are not supported" + level.ranktable_name);
	#/
	prestige = self GetDStat("playerstatslist", "plevel", "StatValue");
	self setRank(rankID, prestige);
	self.pers["prestige"] = prestige;
	if(SessionModeIsMultiplayerGame() && GameModeIsUsingStats() || (SessionModeIsZombiesGame() && SessionModeIsOnlineGame()))
	{
		paragonRank = self GetDStat("playerstatslist", "paragon_rank", "StatValue");
		self setParagonRank(paragonRank);
		self.pers["paragonrank"] = paragonRank;
		paragonIconId = self GetDStat("playerstatslist", "paragon_icon_id", "StatValue");
		self setParagonIconId(paragonIconId);
		self.pers["paragoniconid"] = paragonIconId;
	}
	if(!isdefined(self.pers["summary"]))
	{
		self.pers["summary"] = [];
		self.pers["summary"]["xp"] = 0;
		self.pers["summary"]["score"] = 0;
		self.pers["summary"]["challenge"] = 0;
		self.pers["summary"]["match"] = 0;
		self.pers["summary"]["misc"] = 0;
		self.pers["summary"]["codpoints"] = 0;
	}
	if(GameModeIsMode(6) && !self util::is_bot())
	{
		arenaPoints = self getArenaPointsStat();
		arenaPoints = Int(min(arenaPoints, 100));
		self.pers["arenapoints"] = arenaPoints;
		self setArenaPoints(arenaPoints);
	}
	if(level.rankedMatch)
	{
		self SetDStat("playerstatslist", "rank", "StatValue", rankID);
		self SetDStat("playerstatslist", "minxp", "StatValue", getRankInfoMinXP(rankID));
		self SetDStat("playerstatslist", "maxxp", "StatValue", getRankInfoMaxXp(rankID));
		self SetDStat("playerstatslist", "lastxp", "StatValue", getRankXPCapped(self.pers["rankxp"]));
	}
	self.explosiveKills[0] = 0;
	callback::on_spawned(&on_player_spawned);
	callback::on_joined_team(&on_joined_team);
	callback::on_joined_spectate(&on_joined_spectators);
}

/*
	Name: on_joined_team
	Namespace: rank
	Checksum: 0x4EC3D9C4
	Offset: 0x21F8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_joined_team()
{
	self endon("disconnect");
	self thread removeRankHUD();
}

/*
	Name: on_joined_spectators
	Namespace: rank
	Checksum: 0x51D8B29
	Offset: 0x2228
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_joined_spectators()
{
	self endon("disconnect");
	self thread removeRankHUD();
}

/*
	Name: on_player_spawned
	Namespace: rank
	Checksum: 0x57EF742D
	Offset: 0x2258
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	if(!isdefined(self.hud_rankscroreupdate))
	{
		self.hud_rankscroreupdate = NewScoreHudElem(self);
		self.hud_rankscroreupdate.horzAlign = "center";
		self.hud_rankscroreupdate.vertAlign = "middle";
		self.hud_rankscroreupdate.alignX = "center";
		self.hud_rankscroreupdate.alignY = "middle";
		self.hud_rankscroreupdate.x = 0;
		if(self IsSplitscreen())
		{
			self.hud_rankscroreupdate.y = -15;
		}
		else
		{
			self.hud_rankscroreupdate.y = -60;
		}
		self.hud_rankscroreupdate.font = "default";
		self.hud_rankscroreupdate.fontscale = 2;
		self.hud_rankscroreupdate.archived = 0;
		self.hud_rankscroreupdate.color = (1, 1, 0.5);
		self.hud_rankscroreupdate.alpha = 0;
		self.hud_rankscroreupdate.sort = 50;
		self.hud_rankscroreupdate hud::font_pulse_init();
	}
}

/*
	Name: incCodPoints
	Namespace: rank
	Checksum: 0x11480C1D
	Offset: 0x2400
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function incCodPoints(amount)
{
	if(!util::isRankEnabled())
	{
		return;
	}
	if(!level.rankedMatch)
	{
		return;
	}
	newCodPoints = getCodPointsCapped(self.pers["codpoints"] + amount);
	if(newCodPoints > self.pers["codpoints"])
	{
		self.pers["summary"]["codpoints"] = self.pers["summary"]["codpoints"] + newCodPoints - self.pers["codpoints"];
	}
	self.pers["codpoints"] = newCodPoints;
	setCodPointsStat(Int(newCodPoints));
}

/*
	Name: atLeastOnePlayerOnEachTeam
	Namespace: rank
	Checksum: 0xCB10DC5B
	Offset: 0x2518
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function atLeastOnePlayerOnEachTeam()
{
	foreach(team in level.teams)
	{
		if(!level.playerCount[team])
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: giveRankXP
	Namespace: rank
	Checksum: 0x5FEF201E
	Offset: 0x25B0
	Size: 0x66B
	Parameters: 3
	Flags: None
*/
function giveRankXP(type, value, devAdd)
{
	self endon("disconnect");
	if(SessionModeIsZombiesGame())
	{
		return;
	}
	if(level.teambased && !atLeastOnePlayerOnEachTeam() && !isdefined(devAdd))
	{
		return;
	}
	else if(!level.teambased && util::totalPlayerCount() < 2 && !isdefined(devAdd))
	{
		return;
	}
	if(!util::isRankEnabled())
	{
		return;
	}
	PixBeginEvent("giveRankXP");
	if(!isdefined(value))
	{
		value = getScoreInfoValue(type);
	}
	if(level.rankedMatch)
	{
		bbPrint("mpplayerxp", "gametime %d, player %s, type %s, delta %d", GetTime(), self.name, type, value);
	}
	switch(type)
	{
		case "assault":
		case "assault_assist":
		case "assist":
		case "assist_25":
		case "assist_50":
		case "assist_75":
		case "capture":
		case "defend":
		case "defuse":
		case "destroyer":
		case "dogassist":
		case "dogkill":
		case "headshot":
		case "helicopterassist":
		case "helicopterassist_25":
		case "helicopterassist_50":
		case "helicopterassist_75":
		case "helicopterkill":
		case "kill":
		case "medal":
		case "pickup":
		case "plant":
		case "rcbombdestroy":
		case "return":
		case "revive":
		case "spyplaneassist":
		case "spyplanekill":
		{
			value = Int(value * level.xpScale);
			break;
		}
		case default:
		{
			if(level.xpScale == 0)
			{
				value = 0;
			}
			break;
		}
	}
	xpIncrease = self incRankXP(value);
	if(level.rankedMatch)
	{
		self updateRank();
	}
	if(value != 0)
	{
		self syncXPStat();
	}
	if(isdefined(self.enableText) && self.enableText && !level.hardcoreMode)
	{
		if(type == "teamkill")
		{
			self thread updateRankScoreHUD(0 - getScoreInfoValue("kill"));
		}
		else
		{
			self thread updateRankScoreHUD(value);
		}
	}
	switch(type)
	{
		case "assault":
		case "assist":
		case "assist_25":
		case "assist_50":
		case "assist_75":
		case "capture":
		case "defend":
		case "headshot":
		case "helicopterassist":
		case "helicopterassist_25":
		case "helicopterassist_50":
		case "helicopterassist_75":
		case "kill":
		case "medal":
		case "pickup":
		case "return":
		case "revive":
		case "suicide":
		case "teamkill":
		{
			self.pers["summary"]["score"] = self.pers["summary"]["score"] + value;
			incCodPoints(round_this_number(value * level.codPointsXpScale));
			break;
		}
		case "loss":
		case "tie":
		case "win":
		{
			self.pers["summary"]["match"] = self.pers["summary"]["match"] + value;
			incCodPoints(round_this_number(value * level.codPointsMatchScale));
			break;
		}
		case "challenge":
		{
			self.pers["summary"]["challenge"] = self.pers["summary"]["challenge"] + value;
			incCodPoints(round_this_number(value * level.codPointsChallengeScale));
			break;
		}
		case default:
		{
			self.pers["summary"]["misc"] = self.pers["summary"]["misc"] + value;
			self.pers["summary"]["match"] = self.pers["summary"]["match"] + value;
			incCodPoints(round_this_number(value * level.codPointsMatchScale));
			break;
		}
	}
	self.pers["summary"]["xp"] = self.pers["summary"]["xp"] + xpIncrease;
	PixEndEvent();
}

/*
	Name: round_this_number
	Namespace: rank
	Checksum: 0xF5305A17
	Offset: 0x2C28
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function round_this_number(value)
{
	value = Int(value + 0.5);
	return value;
}

/*
	Name: updateRank
	Namespace: rank
	Checksum: 0x6E180D2B
	Offset: 0x2C68
	Size: 0x30F
	Parameters: 0
	Flags: None
*/
function updateRank()
{
	newRankId = self getRank();
	if(newRankId == self.pers["rank"])
	{
		return 0;
	}
	oldRank = self.pers["rank"];
	rankID = self.pers["rank"];
	self.pers["rank"] = newRankId;
	while(rankID <= newRankId)
	{
		self SetDStat("playerstatslist", "rank", "StatValue", rankID);
		self SetDStat("playerstatslist", "minxp", "StatValue", Int(level.rankTable[rankID][2]));
		self SetDStat("playerstatslist", "maxxp", "StatValue", Int(level.rankTable[rankID][7]));
		self.setPromotion = 1;
		if(level.rankedMatch && level.gameEnded && !self IsSplitscreen())
		{
			self SetDStat("AfterActionReportStats", "lobbyPopup", "promotion");
		}
		if(rankID != oldRank)
		{
			codPointsEarnedForRank = getRankInfoCodPointsEarned(rankID);
			incCodPoints(codPointsEarnedForRank);
			if(!isdefined(self.pers["rankcp"]))
			{
				self.pers["rankcp"] = 0;
			}
			self.pers["rankcp"] = self.pers["rankcp"] + codPointsEarnedForRank;
		}
		rankID++;
	}
	/#
		print("Dev Block strings are not supported" + oldRank + "Dev Block strings are not supported" + newRankId + "Dev Block strings are not supported" + self GetDStat("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported"));
	#/
	self setRank(newRankId);
	return 1;
}

/*
	Name: CodeCallback_RankUp
	Namespace: rank
	Checksum: 0x627FFA57
	Offset: 0x2F80
	Size: 0x197
	Parameters: 3
	Flags: None
*/
function CodeCallback_RankUp(rank, prestige, unlockTokensAdded)
{
	if(SessionModeIsCampaignGame())
	{
		n_extra_tokens = level.rankTable[rank][18];
		if(isdefined(n_extra_tokens) && n_extra_tokens != "")
		{
			self GiveUnlockToken(Int(n_extra_tokens));
		}
		UploadStats(self);
		return;
	}
	if(SessionModeIsMultiplayerGame())
	{
		if(rank > 53)
		{
			self GiveAchievement("MP_REACH_ARENA");
		}
		if(rank > 8)
		{
			self GiveAchievement("MP_REACH_SERGEANT");
		}
	}
	self LUINotifyEvent(&"rank_up", 3, rank, prestige, unlockTokensAdded);
	self LUINotifyEventToSpectators(&"rank_up", 3, rank, prestige, unlockTokensAdded);
	if(isdefined(level.playPromotionReaction))
	{
		self thread [[level.playPromotionReaction]]();
	}
}

/*
	Name: GetItemIndex
	Namespace: rank
	Checksum: 0x1A2D6973
	Offset: 0x3120
	Size: 0xA7
	Parameters: 1
	Flags: None
*/
function GetItemIndex(refString)
{
	statsTableName = util::getStatsTableName();
	itemIndex = Int(tableLookup(statsTableName, 4, refString, 0));
	/#
		Assert(itemIndex > 0, "Dev Block strings are not supported" + refString + "Dev Block strings are not supported" + itemIndex);
	#/
	return itemIndex;
}

/*
	Name: endGameUpdate
	Namespace: rank
	Checksum: 0xC8810436
	Offset: 0x31D0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function endGameUpdate()
{
	player = self;
}

/*
	Name: updateRankScoreHUD
	Namespace: rank
	Checksum: 0xD49D78CD
	Offset: 0x31F0
	Size: 0x1BB
	Parameters: 1
	Flags: None
*/
function updateRankScoreHUD(amount)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	if(isdefined(level.usingMomentum) && level.usingMomentum)
	{
		return;
	}
	if(amount == 0)
	{
		return;
	}
	self notify("update_score");
	self endon("update_score");
	self.rankUpdateTotal = self.rankUpdateTotal + amount;
	wait(0.05);
	if(isdefined(self.hud_rankscroreupdate))
	{
		if(self.rankUpdateTotal < 0)
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (0.73, 0.19, 0.19);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1, 1, 0.5);
		}
		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread hud::font_pulse(self);
		wait(1);
		self.hud_rankscroreupdate fadeOverTime(0.75);
		self.hud_rankscroreupdate.alpha = 0;
		self.rankUpdateTotal = 0;
	}
}

/*
	Name: updateMomentumHUD
	Namespace: rank
	Checksum: 0xCA282A52
	Offset: 0x33B8
	Size: 0x2EB
	Parameters: 3
	Flags: None
*/
function updateMomentumHUD(amount, reason, reasonValue)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	if(amount == 0)
	{
		return;
	}
	self notify("update_score");
	self endon("update_score");
	self.rankUpdateTotal = self.rankUpdateTotal + amount;
	if(isdefined(self.hud_rankscroreupdate))
	{
		if(self.rankUpdateTotal < 0)
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (0.73, 0.19, 0.19);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1, 1, 0.5);
		}
		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread hud::font_pulse(self);
		if(isdefined(self.hud_momentumreason))
		{
			if(isdefined(reason))
			{
				if(isdefined(reasonValue))
				{
					self.hud_momentumreason.label = reason;
					self.hud_momentumreason setValue(reasonValue);
				}
				else
				{
					self.hud_momentumreason.label = reason;
					self.hud_momentumreason setValue(amount);
				}
				self.hud_momentumreason.alpha = 0.85;
				self.hud_momentumreason thread hud::font_pulse(self);
			}
			else
			{
				self.hud_momentumreason fadeOverTime(0.01);
				self.hud_momentumreason.alpha = 0;
			}
		}
		wait(1);
		self.hud_rankscroreupdate fadeOverTime(0.75);
		self.hud_rankscroreupdate.alpha = 0;
		if(isdefined(self.hud_momentumreason) && isdefined(reason))
		{
			self.hud_momentumreason fadeOverTime(0.75);
			self.hud_momentumreason.alpha = 0;
		}
		wait(0.75);
		self.rankUpdateTotal = 0;
	}
}

/*
	Name: removeRankHUD
	Namespace: rank
	Checksum: 0x1F443B49
	Offset: 0x36B0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function removeRankHUD()
{
	if(isdefined(self.hud_rankscroreupdate))
	{
		self.hud_rankscroreupdate.alpha = 0;
	}
	if(isdefined(self.hud_momentumreason))
	{
		self.hud_momentumreason.alpha = 0;
	}
}

/*
	Name: getRank
	Namespace: rank
	Checksum: 0x359B8374
	Offset: 0x3700
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function getRank()
{
	RANKXP = getRankXPCapped(self.pers["rankxp"]);
	rankID = self.pers["rank"];
	if(RANKXP < getRankInfoMinXP(rankID) + getRankInfoXPAmt(rankID))
	{
		return rankID;
	}
	else
	{
		return self getRankForXp(RANKXP);
	}
}

/*
	Name: getRankForXp
	Namespace: rank
	Checksum: 0xE146AE37
	Offset: 0x37C0
	Size: 0x105
	Parameters: 1
	Flags: None
*/
function getRankForXp(xpVal)
{
	rankID = 0;
	rankName = level.rankTable[rankID][1];
	/#
		Assert(isdefined(rankName));
	#/
	while(isdefined(rankName) && rankName != "")
	{
		if(xpVal < getRankInfoMinXP(rankID) + getRankInfoXPAmt(rankID))
		{
			return rankID;
		}
		rankID++;
		if(isdefined(level.rankTable[rankID]))
		{
			rankName = level.rankTable[rankID][1];
		}
		else
		{
			rankName = undefined;
		}
	}
	rankID--;
	return rankID;
}

/*
	Name: getSPM
	Namespace: rank
	Checksum: 0x5C7CF053
	Offset: 0x38D0
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function getSPM()
{
	rankLevel = self getRank() + 1;
	return 3 + rankLevel * 0.5 * 10;
}

/*
	Name: getRankXP
	Namespace: rank
	Checksum: 0xA3C8BB4A
	Offset: 0x3920
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function getRankXP()
{
	return getRankXPCapped(self.pers["rankxp"]);
}

/*
	Name: incRankXP
	Namespace: rank
	Checksum: 0xD911516E
	Offset: 0x3958
	Size: 0x1A9
	Parameters: 1
	Flags: None
*/
function incRankXP(amount)
{
	if(!level.rankedMatch)
	{
		return 0;
	}
	XP = self getRankXP();
	newXp = getRankXPCapped(XP + amount);
	if(self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXp(level.maxRank))
	{
		newXp = getRankInfoMaxXp(level.maxRank);
	}
	if(self IsStarterPack() && self.pers["rank"] >= level.maxRankStarterPack && newXp >= getRankInfoMinXP(level.maxRankStarterPack))
	{
		newXp = getRankInfoMinXP(level.maxRankStarterPack);
	}
	xpIncrease = getRankXPCapped(newXp) - self.pers["rankxp"];
	if(xpIncrease < 0)
	{
		xpIncrease = 0;
	}
	self.pers["rankxp"] = getRankXPCapped(newXp);
	return xpIncrease;
}

/*
	Name: syncXPStat
	Namespace: rank
	Checksum: 0xFC596716
	Offset: 0x3B10
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function syncXPStat()
{
	XP = getRankXPCapped(self getRankXP());
	cp = getCodPointsCapped(Int(self.pers["codpoints"]));
	self SetDStat("playerstatslist", "rankxp", "StatValue", XP);
	self SetDStat("playerstatslist", "codpoints", "StatValue", cp);
}

