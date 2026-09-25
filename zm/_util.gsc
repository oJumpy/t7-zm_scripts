#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace util;

/*
	Name: error
	Namespace: util
	Checksum: 0xA1FD40F2
	Offset: 0x270
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function error(msg)
{
	/#
		println("Dev Block strings are not supported", msg);
		wait(0.05);
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		}
	#/
}

/*
	Name: warning
	Namespace: util
	Checksum: 0xA02AA6F1
	Offset: 0x2F0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function warning(msg)
{
	/#
		println("Dev Block strings are not supported" + msg);
	#/
}

/*
	Name: brush_delete
	Namespace: util
	Checksum: 0x29C03407
	Offset: 0x330
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function brush_delete()
{
	num = self.V["exploder"];
	if(isdefined(self.V["delay"]))
	{
		wait(self.V["delay"]);
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self.model))
	{
		return;
	}
	/#
		Assert(isdefined(self.model));
	#/
	if(!isdefined(self.V["fxid"]) || self.V["fxid"] == "No FX")
	{
		self.V["exploder"] = undefined;
	}
	waittillframeend;
	self.model delete();
}

/*
	Name: brush_show
	Namespace: util
	Checksum: 0x8DD2055D
	Offset: 0x428
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function brush_show()
{
	if(isdefined(self.V["delay"]))
	{
		wait(self.V["delay"]);
	}
	/#
		Assert(isdefined(self.model));
	#/
	self.model show();
	self.model solid();
}

/*
	Name: brush_throw
	Namespace: util
	Checksum: 0x47E4C043
	Offset: 0x4B0
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function brush_throw()
{
	if(isdefined(self.V["delay"]))
	{
		wait(self.V["delay"]);
	}
	ent = undefined;
	if(isdefined(self.V["target"]))
	{
		ent = GetEnt(self.V["target"], "targetname");
	}
	if(!isdefined(ent))
	{
		self.model delete();
		return;
	}
	self.model show();
	startorg = self.V["origin"];
	startAng = self.V["angles"];
	org = ent.origin;
	temp_vec = org - self.V["origin"];
	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];
	self.model rotateVelocity((x, y, z), 12);
	self.model MoveGravity((x, y, z), 12);
	self.V["exploder"] = undefined;
	wait(6);
	self.model delete();
}

/*
	Name: playSoundOnPlayers
	Namespace: util
	Checksum: 0x8D6618CE
	Offset: 0x6C8
	Size: 0x175
	Parameters: 2
	Flags: None
*/
function playSoundOnPlayers(sound, team)
{
	/#
		Assert(isdefined(level.players));
	#/
	if(level.Splitscreen)
	{
		if(isdefined(level.players[0]))
		{
			level.players[0] playlocalsound(sound);
		}
		break;
	}
	if(isdefined(team))
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pers["team"]) && player.pers["team"] == team)
			{
				player playlocalsound(sound);
			}
		}
		break;
	}
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] playlocalsound(sound);
	}
}

/*
	Name: get_player_height
	Namespace: util
	Checksum: 0xAF6A8C70
	Offset: 0x848
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_player_height()
{
	return 70;
}

/*
	Name: IsBulletImpactMOD
	Namespace: util
	Checksum: 0xF8A53991
	Offset: 0x860
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function IsBulletImpactMOD(sMeansOfDeath)
{
	return IsSubStr(sMeansOfDeath, "BULLET") || sMeansOfDeath == "MOD_HEAD_SHOT";
}

/*
	Name: waitRespawnButton
	Namespace: util
	Checksum: 0x673C12E1
	Offset: 0x8A8
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function waitRespawnButton()
{
	self endon("disconnect");
	self endon("end_respawn");
	while(self useButtonPressed() != 1)
	{
		wait(0.05);
	}
}

/*
	Name: setLowerMessage
	Namespace: util
	Checksum: 0x393A04CD
	Offset: 0x8F0
	Size: 0x1FF
	Parameters: 3
	Flags: None
*/
function setLowerMessage(text, time, combineMessageAndTimer)
{
	if(!isdefined(self.lowerMessage))
	{
		return;
	}
	if(isdefined(self.lowerMessageOverride) && text != &"")
	{
		text = self.lowerMessageOverride;
		time = undefined;
	}
	self notify("lower_message_set");
	self.lowerMessage setText(text);
	if(isdefined(time) && time > 0)
	{
		if(!isdefined(combineMessageAndTimer) || !combineMessageAndTimer)
		{
			self.lowerTimer.label = &"";
		}
		else
		{
			self.lowerMessage setText("");
			self.lowerTimer.label = text;
		}
		self.lowerTimer setTimer(time);
	}
	else
	{
		self.lowerTimer setText("");
		self.lowerTimer.label = &"";
	}
	if(self IsSplitscreen())
	{
		self.lowerMessage.fontscale = 1.4;
	}
	self.lowerMessage fadeOverTime(0.05);
	self.lowerMessage.alpha = 1;
	self.lowerTimer fadeOverTime(0.05);
	self.lowerTimer.alpha = 1;
}

/*
	Name: setLowerMessageValue
	Namespace: util
	Checksum: 0x85B3CB54
	Offset: 0xAF8
	Size: 0x227
	Parameters: 3
	Flags: None
*/
function setLowerMessageValue(text, value, combineMessage)
{
	if(!isdefined(self.lowerMessage))
	{
		return;
	}
	if(isdefined(self.lowerMessageOverride) && text != &"")
	{
		text = self.lowerMessageOverride;
		time = undefined;
	}
	self notify("lower_message_set");
	if(!isdefined(combineMessage) || !combineMessage)
	{
		self.lowerMessage setText(text);
	}
	else
	{
		self.lowerMessage setText("");
	}
	if(isdefined(value) && value > 0)
	{
		if(!isdefined(combineMessage) || !combineMessage)
		{
			self.lowerTimer.label = &"";
		}
		else
		{
			self.lowerTimer.label = text;
		}
		self.lowerTimer setValue(value);
	}
	else
	{
		self.lowerTimer setText("");
		self.lowerTimer.label = &"";
	}
	if(self IsSplitscreen())
	{
		self.lowerMessage.fontscale = 1.4;
	}
	self.lowerMessage fadeOverTime(0.05);
	self.lowerMessage.alpha = 1;
	self.lowerTimer fadeOverTime(0.05);
	self.lowerTimer.alpha = 1;
}

/*
	Name: clearLowerMessage
	Namespace: util
	Checksum: 0xA108F191
	Offset: 0xD28
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function clearLowerMessage(fadetime)
{
	if(!isdefined(self.lowerMessage))
	{
		return;
	}
	self notify("lower_message_set");
	if(!isdefined(fadetime) || fadetime == 0)
	{
		setLowerMessage(&"");
	}
	else
	{
		self endon("disconnect");
		self endon("lower_message_set");
		self.lowerMessage fadeOverTime(fadetime);
		self.lowerMessage.alpha = 0;
		self.lowerTimer fadeOverTime(fadetime);
		self.lowerTimer.alpha = 0;
		wait(fadetime);
		self setLowerMessage("");
	}
}

/*
	Name: printOnTeam
	Namespace: util
	Checksum: 0x4A3577E3
	Offset: 0xE28
	Size: 0xD5
	Parameters: 2
	Flags: None
*/
function printOnTeam(text, team)
{
	/#
		Assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player iprintln(text);
		}
	}
}

/*
	Name: printBoldOnTeam
	Namespace: util
	Checksum: 0x616F55C6
	Offset: 0xF08
	Size: 0xD5
	Parameters: 2
	Flags: None
*/
function printBoldOnTeam(text, team)
{
	/#
		Assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player IPrintLnBold(text);
		}
	}
}

/*
	Name: printBoldOnTeamArg
	Namespace: util
	Checksum: 0x2F21DF99
	Offset: 0xFE8
	Size: 0xDD
	Parameters: 3
	Flags: None
*/
function printBoldOnTeamArg(text, team, arg)
{
	/#
		Assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player IPrintLnBold(text, arg);
		}
	}
}

/*
	Name: printOnTeamArg
	Namespace: util
	Checksum: 0x526CB98C
	Offset: 0x10D0
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function printOnTeamArg(text, team, arg)
{
}

/*
	Name: printOnPlayers
	Namespace: util
	Checksum: 0x72CB3B72
	Offset: 0x10F8
	Size: 0xED
	Parameters: 2
	Flags: None
*/
function printOnPlayers(text, team)
{
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(team))
		{
			if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == team)
			{
				players[i] iprintln(text);
			}
			continue;
		}
		players[i] iprintln(text);
	}
}

/*
	Name: printAndSoundOnEveryone
	Namespace: util
	Checksum: 0xBAAA1ADE
	Offset: 0x11F0
	Size: 0x515
	Parameters: 7
	Flags: None
*/
function printAndSoundOnEveryone(team, enemyteam, printFriendly, printEnemy, soundFriendly, soundEnemy, printarg)
{
	shouldDoSounds = isdefined(soundFriendly);
	shouldDoEnemySounds = 0;
	if(isdefined(soundEnemy))
	{
		/#
			Assert(shouldDoSounds);
		#/
		shouldDoEnemySounds = 1;
	}
	if(!isdefined(printarg))
	{
		printarg = "";
	}
	if(level.Splitscreen || !shouldDoSounds)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if(isdefined(playerteam))
			{
				if(playerteam == team && isdefined(printFriendly) && printFriendly != &"")
				{
					player iprintln(printFriendly, printarg);
					continue;
				}
				if(isdefined(printEnemy) && printEnemy != &"")
				{
					if(isdefined(enemyteam) && playerteam == enemyteam)
					{
						player iprintln(printEnemy, printarg);
						continue;
					}
					if(!isdefined(enemyteam) && playerteam != team)
					{
						player iprintln(printEnemy, printarg);
					}
				}
			}
		}
		if(shouldDoSounds)
		{
			/#
				Assert(level.Splitscreen);
			#/
			level.players[0] playlocalsound(soundFriendly);
		}
		break;
	}
	/#
		Assert(shouldDoSounds);
	#/
	if(shouldDoEnemySounds)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if(isdefined(playerteam))
			{
				if(playerteam == team)
				{
					if(isdefined(printFriendly) && printFriendly != &"")
					{
						player iprintln(printFriendly, printarg);
					}
					player playlocalsound(soundFriendly);
					continue;
				}
				if(isdefined(enemyteam) && playerteam == enemyteam || (!isdefined(enemyteam) && playerteam != team))
				{
					if(isdefined(printEnemy) && printEnemy != &"")
					{
						player iprintln(printEnemy, printarg);
					}
					player playlocalsound(soundEnemy);
				}
			}
		}
		break;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		playerteam = player.pers["team"];
		if(isdefined(playerteam))
		{
			if(playerteam == team)
			{
				if(isdefined(printFriendly) && printFriendly != &"")
				{
					player iprintln(printFriendly, printarg);
				}
				player playlocalsound(soundFriendly);
				continue;
			}
			if(isdefined(printEnemy) && printEnemy != &"")
			{
				if(isdefined(enemyteam) && playerteam == enemyteam)
				{
					player iprintln(printEnemy, printarg);
					continue;
				}
				if(!isdefined(enemyteam) && playerteam != team)
				{
					player iprintln(printEnemy, printarg);
				}
			}
		}
	}
}

/*
	Name: _playLocalSound
	Namespace: util
	Checksum: 0xD456B4B4
	Offset: 0x1710
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function _playLocalSound(soundAlias)
{
	if(level.Splitscreen && !self IsHost())
	{
		return;
	}
	self playlocalsound(soundAlias);
}

/*
	Name: getOtherTeam
	Namespace: util
	Checksum: 0x260E7090
	Offset: 0x1768
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function getOtherTeam(team)
{
	if(team == "allies")
	{
		return "axis";
	}
	else if(team == "axis")
	{
		return "allies";
	}
	else
	{
		return "allies";
	}
	/#
		ASSERTMSG("Dev Block strings are not supported" + team);
	#/
}

/*
	Name: getTeamMask
	Namespace: util
	Checksum: 0xE633F130
	Offset: 0x17E8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function getTeamMask(team)
{
	if(!level.teambased || !isdefined(team) || !isdefined(level.spawnsystem.iSPAWN_TEAMMASK[team]))
	{
		return level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	return level.spawnsystem.iSPAWN_TEAMMASK[team];
}

/*
	Name: getOtherTeamsMask
	Namespace: util
	Checksum: 0x68A95EE8
	Offset: 0x1858
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function getOtherTeamsMask(skip_team)
{
	mask = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		mask = mask | getTeamMask(team);
	}
	return mask;
}

/*
	Name: plot_points
	Namespace: util
	Checksum: 0x46F5F282
	Offset: 0x1928
	Size: 0x10D
	Parameters: 5
	Flags: None
*/
function plot_points(plotpoints, r, g, b, timer)
{
	/#
		lastpoint = plotpoints[0];
		if(!isdefined(r))
		{
			r = 1;
		}
		if(!isdefined(g))
		{
			g = 1;
		}
		if(!isdefined(b))
		{
			b = 1;
		}
		if(!isdefined(timer))
		{
			timer = 0.05;
		}
		for(i = 1; i < plotpoints.size; i++)
		{
			line(lastpoint, plotpoints[i], (r, g, b), 1, timer);
			lastpoint = plotpoints[i];
		}
	#/
}

/*
	Name: getfx
	Namespace: util
	Checksum: 0xE2A1B730
	Offset: 0x1A40
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function getfx(FX)
{
	/#
		Assert(isdefined(level._effect[FX]), "Dev Block strings are not supported" + FX + "Dev Block strings are not supported");
	#/
	return level._effect[FX];
}

/*
	Name: set_dvar_if_unset
	Namespace: util
	Checksum: 0xD0C9770F
	Offset: 0x1A98
	Size: 0x91
	Parameters: 3
	Flags: None
*/
function set_dvar_if_unset(dvar, value, reset)
{
	if(!isdefined(reset))
	{
		reset = 0;
	}
	if(reset || GetDvarString(dvar) == "")
	{
		SetDvar(dvar, value);
		return value;
	}
	return GetDvarString(dvar);
}

/*
	Name: set_dvar_float_if_unset
	Namespace: util
	Checksum: 0xC7E74D2B
	Offset: 0x1B38
	Size: 0x89
	Parameters: 3
	Flags: None
*/
function set_dvar_float_if_unset(dvar, value, reset)
{
	if(!isdefined(reset))
	{
		reset = 0;
	}
	if(reset || GetDvarString(dvar) == "")
	{
		SetDvar(dvar, value);
	}
	return GetDvarFloat(dvar);
}

/*
	Name: set_dvar_int_if_unset
	Namespace: util
	Checksum: 0x494368F8
	Offset: 0x1BD0
	Size: 0xA1
	Parameters: 3
	Flags: None
*/
function set_dvar_int_if_unset(dvar, value, reset)
{
	if(!isdefined(reset))
	{
		reset = 0;
	}
	if(reset || GetDvarString(dvar) == "")
	{
		SetDvar(dvar, value);
		return Int(value);
	}
	return GetDvarInt(dvar);
}

/*
	Name: isStrStart
	Namespace: util
	Checksum: 0x9C25316E
	Offset: 0x1C80
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function isStrStart(string1, subStr)
{
	return GetSubStr(string1, 0, subStr.size) == subStr;
}

/*
	Name: isKillStreaksEnabled
	Namespace: util
	Checksum: 0x5DFD93AA
	Offset: 0x1CC0
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function isKillStreaksEnabled()
{
	return isdefined(level.killstreaksenabled) && level.killstreaksenabled;
}

/*
	Name: setUsingRemote
	Namespace: util
	Checksum: 0x394B61BA
	Offset: 0x1CE0
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function setUsingRemote(remoteName)
{
	if(isdefined(self.carryIcon))
	{
		self.carryIcon.alpha = 0;
	}
	/#
		Assert(!self isUsingRemote());
	#/
	self.usingRemote = remoteName;
	self disableOffhandWeapons();
	self notify("using_remote");
}

/*
	Name: getRemoteName
	Namespace: util
	Checksum: 0xFEA073EA
	Offset: 0x1D70
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function getRemoteName()
{
	/#
		Assert(self isUsingRemote());
	#/
	return self.usingRemote;
}

/*
	Name: setObjectiveText
	Namespace: util
	Checksum: 0x977051AB
	Offset: 0x1DB0
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function setObjectiveText(team, text)
{
	game["strings"]["objective_" + team] = text;
}

/*
	Name: setObjectiveScoreText
	Namespace: util
	Checksum: 0x907EA9E3
	Offset: 0x1DF0
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function setObjectiveScoreText(team, text)
{
	game["strings"]["objective_score_" + team] = text;
}

/*
	Name: setObjectiveHintText
	Namespace: util
	Checksum: 0x74881B0
	Offset: 0x1E30
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function setObjectiveHintText(team, text)
{
	game["strings"]["objective_hint_" + team] = text;
}

/*
	Name: getObjectiveText
	Namespace: util
	Checksum: 0xE4E71209
	Offset: 0x1E70
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function getObjectiveText(team)
{
	return game["strings"]["objective_" + team];
}

/*
	Name: getObjectiveScoreText
	Namespace: util
	Checksum: 0x337A7CA5
	Offset: 0x1EA0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function getObjectiveScoreText(team)
{
	return game["strings"]["objective_score_" + team];
}

/*
	Name: getObjectiveHintText
	Namespace: util
	Checksum: 0x5C0B9BDD
	Offset: 0x1ED0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function getObjectiveHintText(team)
{
	return game["strings"]["objective_hint_" + team];
}

/*
	Name: registerRoundSwitch
	Namespace: util
	Checksum: 0xC29B81F9
	Offset: 0x1F00
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function registerRoundSwitch(minValue, maxValue)
{
	level.roundSwitch = math::clamp(GetGametypeSetting("roundSwitch"), minValue, maxValue);
	level.roundSwitchMin = minValue;
	level.roundSwitchMax = maxValue;
}

/*
	Name: registerRoundLimit
	Namespace: util
	Checksum: 0x713C3392
	Offset: 0x1F70
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function registerRoundLimit(minValue, maxValue)
{
	level.roundLimit = math::clamp(GetGametypeSetting("roundLimit"), minValue, maxValue);
	level.roundLimitMin = minValue;
	level.roundLimitMax = maxValue;
}

/*
	Name: registerRoundWinLimit
	Namespace: util
	Checksum: 0xA14BF1E8
	Offset: 0x1FE0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function registerRoundWinLimit(minValue, maxValue)
{
	level.roundWinLimit = math::clamp(GetGametypeSetting("roundWinLimit"), minValue, maxValue);
	level.roundWinLimitMin = minValue;
	level.roundWinLimitMax = maxValue;
}

/*
	Name: registerScoreLimit
	Namespace: util
	Checksum: 0x2003C062
	Offset: 0x2050
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function registerScoreLimit(minValue, maxValue)
{
	level.scoreLimit = math::clamp(GetGametypeSetting("scoreLimit"), minValue, maxValue);
	level.scoreLimitMin = minValue;
	level.scoreLimitMax = maxValue;
	SetDvar("ui_scorelimit", level.scoreLimit);
}

/*
	Name: registerTimeLimit
	Namespace: util
	Checksum: 0x36D23CF6
	Offset: 0x20E0
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function registerTimeLimit(minValue, maxValue)
{
	level.timelimit = math::clamp(GetGametypeSetting("timeLimit"), minValue, maxValue);
	level.timeLimitMin = minValue;
	level.timeLimitMax = maxValue;
	SetDvar("ui_timelimit", level.timelimit);
}

/*
	Name: registerNumLives
	Namespace: util
	Checksum: 0x11C9519D
	Offset: 0x2170
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function registerNumLives(minValue, maxValue)
{
	level.numLives = math::clamp(GetGametypeSetting("playerNumLives"), minValue, maxValue);
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
}

/*
	Name: getPlayerFromClientNum
	Namespace: util
	Checksum: 0xD89A118C
	Offset: 0x21E0
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function getPlayerFromClientNum(clientNum)
{
	if(clientNum < 0)
	{
		return undefined;
	}
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i] GetEntityNumber() == clientNum)
		{
			return level.players[i];
		}
	}
	return undefined;
}

/*
	Name: isPressBuild
	Namespace: util
	Checksum: 0xB7703687
	Offset: 0x2268
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function isPressBuild()
{
	buildType = GetDvarString("buildType");
	if(isdefined(buildType) && buildType == "press")
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFlashbanged
	Namespace: util
	Checksum: 0x5B41C029
	Offset: 0x22C0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function isFlashbanged()
{
	return isdefined(self.flashEndTime) && GetTime() < self.flashEndTime;
}

/*
	Name: DoMaxDamage
	Namespace: util
	Checksum: 0x4C7FC933
	Offset: 0x22E8
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function DoMaxDamage(origin, attacker, inflictor, headshot, mod)
{
	if(isdefined(self.damagedToDeath) && self.damagedToDeath)
	{
		return;
	}
	if(isdefined(self.maxhealth))
	{
		damage = self.maxhealth + 1;
	}
	else
	{
		damage = self.health + 1;
	}
	self.damagedToDeath = 1;
	self DoDamage(damage, origin, attacker, inflictor, headshot, mod);
}

/*
	Name: get_array_of_closest
	Namespace: util
	Checksum: 0xBFD0E975
	Offset: 0x23B0
	Size: 0x327
	Parameters: 5
	Flags: None
*/
function get_array_of_closest(org, Array, excluders, max, maxdist)
{
	if(!isdefined(max))
	{
		max = Array.size;
	}
	if(!isdefined(excluders))
	{
		excluders = [];
	}
	maxdists2rd = undefined;
	if(isdefined(maxdist))
	{
		maxdists2rd = maxdist * maxdist;
	}
	dist = [];
	index = [];
	for(i = 0; i < Array.size; i++)
	{
		if(!isdefined(Array[i]))
		{
			continue;
		}
		if(IsInArray(excluders, Array[i]))
		{
			continue;
		}
		if(IsVec(Array[i]))
		{
			length = DistanceSquared(org, Array[i]);
		}
		else
		{
			length = DistanceSquared(org, Array[i].origin);
		}
		if(isdefined(maxdists2rd) && maxdists2rd < length)
		{
			continue;
		}
		dist[dist.size] = length;
		index[index.size] = i;
	}
	for(;;)
	{
		change = 0;
		for(i = 0; i < dist.size - 1; i++)
		{
			if(dist[i] <= dist[i + 1])
			{
				continue;
			}
			change = 1;
			temp = dist[i];
			dist[i] = dist[i + 1];
			dist[i + 1] = temp;
			temp = index[i];
			index[i] = index[i + 1];
			index[i + 1] = temp;
		}
		if(!change)
		{
		}
	}
	else
	{
	}
	newArray = [];
	if(max > dist.size)
	{
		max = dist.size;
	}
	for(i = 0; i < max; i++)
	{
		newArray[i] = Array[index[i]];
	}
	return newArray;
}

