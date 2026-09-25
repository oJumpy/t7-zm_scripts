#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_spectating;

#namespace globallogic_ui;

/*
	Name: __init__sytem__
	Namespace: globallogic_ui
	Checksum: 0x5A958BED
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic_ui", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: globallogic_ui
	Checksum: 0x99EC1590
	Offset: 0x288
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: SetupCallbacks
	Namespace: globallogic_ui
	Checksum: 0xE1C11B17
	Offset: 0x298
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function SetupCallbacks()
{
	level.autoassign = &menuAutoAssign;
	level.Spectator = &menuSpectator;
	level.curClass = &menuClass;
	level.teamMenu = &menuTeam;
}

/*
	Name: freeGameplayHudElems
	Namespace: globallogic_ui
	Checksum: 0x4F9FE9DF
	Offset: 0x308
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function freeGameplayHudElems()
{
	if(isdefined(self.perkicon))
	{
		for(numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++)
		{
			if(isdefined(self.perkicon[numSpecialties]))
			{
				self.perkicon[numSpecialties] hud::destroyElem();
				self.perkname[numSpecialties] hud::destroyElem();
			}
		}
	}
	else if(isdefined(self.perkHudelem))
	{
		self.perkHudelem hud::destroyElem();
	}
	if(isdefined(self.killstreakicon))
	{
		if(isdefined(self.killstreakicon[0]))
		{
			self.killstreakicon[0] hud::destroyElem();
		}
		if(isdefined(self.killstreakicon[1]))
		{
			self.killstreakicon[1] hud::destroyElem();
		}
		if(isdefined(self.killstreakicon[2]))
		{
			self.killstreakicon[2] hud::destroyElem();
		}
		if(isdefined(self.killstreakicon[3]))
		{
			self.killstreakicon[3] hud::destroyElem();
		}
		if(isdefined(self.killstreakicon[4]))
		{
			self.killstreakicon[4] hud::destroyElem();
		}
	}
	if(isdefined(self.lowerMessage))
	{
		self.lowerMessage hud::destroyElem();
	}
	if(isdefined(self.lowerTimer))
	{
		self.lowerTimer hud::destroyElem();
	}
	if(isdefined(self.proxBar))
	{
		self.proxBar hud::destroyElem();
	}
	if(isdefined(self.proxBarText))
	{
		self.proxBarText hud::destroyElem();
	}
	if(isdefined(self.carryIcon))
	{
		self.carryIcon hud::destroyElem();
	}
}

/*
	Name: teamPlayerCountsEqual
	Namespace: globallogic_ui
	Checksum: 0xFB20DD7D
	Offset: 0x590
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function teamPlayerCountsEqual(playerCounts)
{
	count = undefined;
	foreach(team in level.teams)
	{
		if(!isdefined(count))
		{
			count = playerCounts[team];
			continue;
		}
		if(count != playerCounts[team])
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: teamWithLowestPlayerCount
	Namespace: globallogic_ui
	Checksum: 0xCBD00BF2
	Offset: 0x660
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function teamWithLowestPlayerCount(playerCounts, ignore_team)
{
	count = 9999;
	lowest_team = undefined;
	foreach(team in level.teams)
	{
		if(count > playerCounts[team])
		{
			count = playerCounts[team];
			lowest_team = team;
		}
	}
	return lowest_team;
}

/*
	Name: menuAutoAssign
	Namespace: globallogic_ui
	Checksum: 0xE330584F
	Offset: 0x748
	Size: 0x56B
	Parameters: 1
	Flags: None
*/
function menuAutoAssign(comingFromMenu)
{
	teamKeys = getArrayKeys(level.teams);
	assignment = teamKeys[RandomInt(teamKeys.size)];
	self closeMenus();
	if(isdefined(level.forceAllAllies) && level.forceAllAllies)
	{
		assignment = "allies";
	}
	else if(level.teambased)
	{
		if(GetDvarInt("party_autoteams") == 1)
		{
			if(level.allow_teamchange == "1" && (self.hasSpawned || comingFromMenu))
			{
				assignment = "";
				break;
			}
			team = getAssignedTeam(self);
			switch(team)
			{
				case 1:
				{
					assignment = teamKeys[1];
					break;
				}
				case 2:
				{
					assignment = teamKeys[0];
					break;
				}
				case 3:
				{
					assignment = teamKeys[2];
					break;
				}
				case 4:
				{
					if(!isdefined(level.forceAutoAssign) || !level.forceAutoAssign)
					{
						self SetClientScriptMainMenu(game["menu_start_menu"]);
						return;
					}
				}
				case default:
				{
					assignment = "";
					if(isdefined(level.teams[team]))
					{
						assignment = team;
					}
					else if(team == "spectator" && !level.forceAutoAssign)
					{
						self SetClientScriptMainMenu(game["menu_start_menu"]);
						return;
					}
				}
			}
		}
		if(assignment == "" || GetDvarInt("party_autoteams") == 0)
		{
			if(SessionModeIsZombiesGame())
			{
				assignment = "allies";
			}
		}
		if(assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
		{
			self beginClassChoice();
			return;
		}
	}
	else if(GetDvarInt("party_autoteams") == 1)
	{
		if(level.allow_teamchange != "1" || (!self.hasSpawned && !comingFromMenu))
		{
			team = getAssignedTeam(self);
			if(isdefined(level.teams[team]))
			{
				assignment = team;
			}
			else if(team == "spectator" && !level.forceAutoAssign)
			{
				self SetClientScriptMainMenu(game["menu_start_menu"]);
				return;
			}
		}
	}
	if(assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
		self.switching_teams = 1;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}
	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.curClass = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self updateObjectiveText();
	self.sessionteam = assignment;
	if(!isalive(self))
	{
		self.statusicon = "hud_status_dead";
	}
	self notify("joined_team");
	level notify("joined_team");
	self callback::callback("hash_95a6c4c0");
	self notify("end_respawn");
	self beginClassChoice();
	self SetClientScriptMainMenu(game["menu_start_menu"]);
}

/*
	Name: teamScoresEqual
	Namespace: globallogic_ui
	Checksum: 0xFF84DAC
	Offset: 0xCC0
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function teamScoresEqual()
{
	score = undefined;
	foreach(team in level.teams)
	{
		if(!isdefined(score))
		{
			score = getTeamScore(team);
			continue;
		}
		if(score != getTeamScore(team))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: teamWithLowestScore
	Namespace: globallogic_ui
	Checksum: 0xC3AAB7DC
	Offset: 0xD98
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function teamWithLowestScore()
{
	score = 99999999;
	lowest_team = undefined;
	foreach(team in level.teams)
	{
		if(score > getTeamScore(team))
		{
			lowest_team = team;
		}
	}
	return lowest_team;
}

/*
	Name: pickTeamFromScores
	Namespace: globallogic_ui
	Checksum: 0x29E3FCCD
	Offset: 0xE68
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function pickTeamFromScores(teams)
{
	assignment = "allies";
	if(teamScoresEqual())
	{
		assignment = teams[RandomInt(teams.size)];
	}
	else
	{
		assignment = teamWithLowestScore();
	}
	return assignment;
}

/*
	Name: getSplitscreenTeam
	Namespace: globallogic_ui
	Checksum: 0x45C3EB7E
	Offset: 0xEE8
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function getSplitscreenTeam()
{
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index]))
		{
			continue;
		}
		if(level.players[index] == self)
		{
			continue;
		}
		if(!self IsPlayerOnSameMachine(level.players[index]))
		{
			continue;
		}
		team = level.players[index].sessionteam;
		if(team != "spectator")
		{
			return team;
		}
	}
	return "";
}

/*
	Name: updateObjectiveText
	Namespace: globallogic_ui
	Checksum: 0xC3C4A600
	Offset: 0xFC0
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function updateObjectiveText()
{
	if(SessionModeIsZombiesGame() || self.pers["team"] == "spectator")
	{
		self SetClientCGObjectiveText("");
		return;
	}
	if(level.scoreLimit > 0)
	{
		self SetClientCGObjectiveText(util::getObjectiveScoreText(self.pers["team"]));
	}
	else
	{
		self SetClientCGObjectiveText(util::getObjectiveText(self.pers["team"]));
	}
}

/*
	Name: closeMenus
	Namespace: globallogic_ui
	Checksum: 0x51601F7A
	Offset: 0x10A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function closeMenus()
{
	self closeInGameMenu();
}

/*
	Name: beginClassChoice
	Namespace: globallogic_ui
	Checksum: 0xA82BA665
	Offset: 0x10C8
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function beginClassChoice(forceNewChoice)
{
	/#
		Assert(isdefined(level.teams[self.pers["Dev Block strings are not supported"]]));
	#/
	team = self.pers["team"];
	if(level.disableCAC == 1)
	{
		self.pers["class"] = level.defaultClass;
		self.curClass = level.defaultClass;
		if(self.sessionstate != "playing" && game["state"] == "playing")
		{
			self thread [[level.spawnClient]]();
		}
		level thread globallogic::updateTeamStatus();
		self thread spectating::setSpectatePermissionsForMachine();
		return;
	}
	self openMenu(game["menu_changeclass_" + team]);
}

/*
	Name: showMainMenuForTeam
	Namespace: globallogic_ui
	Checksum: 0x28668455
	Offset: 0x1200
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function showMainMenuForTeam()
{
	/#
		Assert(isdefined(level.teams[self.pers["Dev Block strings are not supported"]]));
	#/
	team = self.pers["team"];
	self openMenu(game["menu_changeclass_" + team]);
}

/*
	Name: menuTeam
	Namespace: globallogic_ui
	Checksum: 0xD64FA18
	Offset: 0x1280
	Size: 0x203
	Parameters: 1
	Flags: None
*/
function menuTeam(team)
{
	self closeMenus();
	if(!level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat))
	{
		return;
	}
	if(self.pers["team"] != team)
	{
		if(level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat))
		{
			self.hasSpawned = 0;
		}
		if(self.sessionstate == "playing")
		{
			self.switching_teams = 1;
			self.joining_team = team;
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = team;
		self.team = team;
		self.pers["class"] = undefined;
		self.curClass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateObjectiveText();
		self.sessionteam = team;
		self SetClientScriptMainMenu(game["menu_start_menu"]);
		self notify("joined_team");
		level notify("joined_team");
		self callback::callback("hash_95a6c4c0");
		self notify("end_respawn");
	}
	self beginClassChoice();
}

/*
	Name: menuSpectator
	Namespace: globallogic_ui
	Checksum: 0x4384B87A
	Offset: 0x1490
	Size: 0x181
	Parameters: 0
	Flags: None
*/
function menuSpectator()
{
	self closeMenus();
	if(self.pers["team"] != "spectator")
	{
		if(isalive(self))
		{
			self.switching_teams = 1;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.pers["class"] = undefined;
		self.curClass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateObjectiveText();
		self.sessionteam = "spectator";
		[[level.spawnSpectator]]();
		self thread globallogic_player::spectate_player_watcher();
		self SetClientScriptMainMenu(game["menu_start_menu"]);
		self notify("joined_spectators");
	}
}

/*
	Name: menuClass
	Namespace: globallogic_ui
	Checksum: 0x310E6512
	Offset: 0x1620
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function menuClass(response)
{
	self closeMenus();
}

/*
	Name: removeSpawnMessageShortly
	Namespace: globallogic_ui
	Checksum: 0xE5CDE140
	Offset: 0x1650
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function removeSpawnMessageShortly(delay)
{
	self endon("disconnect");
	waittillframeend;
	self endon("end_respawn");
	wait(delay);
	self util::clearLowerMessage(2);
}

