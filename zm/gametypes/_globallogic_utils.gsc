#using scripts\codescripts\struct;
#using scripts\shared\hud_message_shared;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_hostmigration;

#namespace globallogic_utils;

/*
	Name: testMenu
	Namespace: globallogic_utils
	Checksum: 0x8DD69930
	Offset: 0x2A0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function testMenu()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		wait(10);
		notifyData = spawnstruct();
		notifyData.titleText = &"MP_CHALLENGE_COMPLETED";
		notifyData.notifyText = "wheee";
		notifyData.sound = "mp_challenge_complete";
		self thread hud_message::notifyMessage(notifyData);
	}
}

/*
	Name: testShock
	Namespace: globallogic_utils
	Checksum: 0xC59707F4
	Offset: 0x340
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function testShock()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		wait(3);
		numShots = RandomInt(6);
		for(i = 0; i < numShots; i++)
		{
			IPrintLnBold(numShots);
			self shellshock("frag_grenade_mp", 0.2);
			wait(0.1);
		}
	}
}

/*
	Name: testHPs
	Namespace: globallogic_utils
	Checksum: 0x7EE9EAD6
	Offset: 0x408
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function testHPs()
{
	self endon("death");
	self endon("disconnect");
	hps = [];
	hps[hps.size] = "radar";
	hps[hps.size] = "artillery";
	hps[hps.size] = "dogs";
	for(;;)
	{
		hp = "radar";
		wait(20);
	}
}

/*
	Name: timeUntilRoundEnd
	Namespace: globallogic_utils
	Checksum: 0xB9A8E5F6
	Offset: 0x498
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function timeUntilRoundEnd()
{
	if(level.gameEnded)
	{
		timePassed = GetTime() - level.gameEndTime / 1000;
		timeRemaining = level.postRoundTime - timePassed;
		if(timeRemaining < 0)
		{
			return 0;
		}
		return timeRemaining;
	}
	if(level.inOvertime)
	{
		return undefined;
	}
	if(level.timelimit <= 0)
	{
		return undefined;
	}
	if(!isdefined(level.startTime))
	{
		return undefined;
	}
	timePassed = getTimePassed() - level.startTime / 1000;
	timeRemaining = level.timelimit * 60 - timePassed;
	return timeRemaining + level.postRoundTime;
}

/*
	Name: getTimeRemaining
	Namespace: globallogic_utils
	Checksum: 0x6362DBED
	Offset: 0x580
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function getTimeRemaining()
{
	return level.timelimit * 60 * 1000 - getTimePassed();
}

/*
	Name: registerPostRoundEvent
	Namespace: globallogic_utils
	Checksum: 0x8939DC10
	Offset: 0x5B8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function registerPostRoundEvent(eventFunc)
{
	if(!isdefined(level.postRoundEvents))
	{
		level.postRoundEvents = [];
	}
	level.postRoundEvents[level.postRoundEvents.size] = eventFunc;
}

/*
	Name: executePostRoundEvents
	Namespace: globallogic_utils
	Checksum: 0xE3B99DE2
	Offset: 0x600
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function executePostRoundEvents()
{
	if(!isdefined(level.postRoundEvents))
	{
		return;
	}
	for(i = 0; i < level.postRoundEvents.size; i++)
	{
		[[level.postRoundEvents[i]]]();
	}
}

/*
	Name: getValueInRange
	Namespace: globallogic_utils
	Checksum: 0xBA22C873
	Offset: 0x660
	Size: 0x51
	Parameters: 3
	Flags: None
*/
function getValueInRange(value, minValue, maxValue)
{
	if(value > maxValue)
	{
		return maxValue;
	}
	else if(value < minValue)
	{
		return minValue;
	}
	else
	{
		return value;
	}
}

/*
	Name: assertProperPlacement
	Namespace: globallogic_utils
	Checksum: 0x4BED67E
	Offset: 0x6C0
	Size: 0x1B1
	Parameters: 0
	Flags: None
*/
function assertProperPlacement()
{
	/#
		numPlayers = level.placement["Dev Block strings are not supported"].size;
		for(i = 0; i < numPlayers - 1; i++)
		{
			if(isdefined(level.placement["Dev Block strings are not supported"][i]) && isdefined(level.placement["Dev Block strings are not supported"][i + 1]))
			{
				if(level.placement["Dev Block strings are not supported"][i].score < level.placement["Dev Block strings are not supported"][i + 1].score)
				{
					println("Dev Block strings are not supported");
					for(i = 0; i < numPlayers; i++)
					{
						player = level.placement["Dev Block strings are not supported"][i];
						println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + player.score);
					}
					/#
						ASSERTMSG("Dev Block strings are not supported");
					#/
					break;
				}
			}
		}
	#/
}

/*
	Name: isValidClass
	Namespace: globallogic_utils
	Checksum: 0x768D8BD
	Offset: 0x880
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function isValidClass(vclass)
{
	if(level.oldschool || SessionModeIsZombiesGame())
	{
		/#
			Assert(!isdefined(vclass));
		#/
		return 1;
	}
	return isdefined(vclass) && vclass != "";
}

/*
	Name: playTickingSound
	Namespace: globallogic_utils
	Checksum: 0x5679DDEA
	Offset: 0x8F0
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function playTickingSound(gametype_tick_sound)
{
	self endon("death");
	self endon("stop_ticking");
	level endon("game_ended");
	time = level.bombTimer;
	while(1)
	{
		self playsound(gametype_tick_sound);
		if(time > 10)
		{
			time = time - 1;
			wait(1);
		}
		else if(time > 4)
		{
			time = time - 0.5;
			wait(0.5);
		}
		else if(time > 1)
		{
			time = time - 0.4;
			wait(0.4);
		}
		else
		{
			time = time - 0.3;
			wait(0.3);
		}
		hostmigration::waitTillHostMigrationDone();
	}
}

/*
	Name: stopTickingSound
	Namespace: globallogic_utils
	Checksum: 0x99407360
	Offset: 0xA18
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function stopTickingSound()
{
	self notify("stop_ticking");
}

/*
	Name: gameTimer
	Namespace: globallogic_utils
	Checksum: 0xF1A49365
	Offset: 0xA38
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function gameTimer()
{
	level endon("game_ended");
	level waittill("prematch_over");
	level.startTime = GetTime();
	level.discardTime = 0;
	if(isdefined(game["roundMillisecondsAlreadyPassed"]))
	{
		level.startTime = level.startTime - game["roundMillisecondsAlreadyPassed"];
		game["roundMillisecondsAlreadyPassed"] = undefined;
	}
	prevtime = GetTime();
	while(game["state"] == "playing")
	{
		if(!level.timerStopped)
		{
			game["timepassed"] = game["timepassed"] + GetTime() - prevtime;
		}
		prevtime = GetTime();
		wait(1);
	}
}

/*
	Name: getTimePassed
	Namespace: globallogic_utils
	Checksum: 0x6608243A
	Offset: 0xB18
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function getTimePassed()
{
	if(!isdefined(level.startTime))
	{
		return 0;
	}
	if(level.timerStopped)
	{
		return level.timerPauseTime - level.startTime - level.discardTime;
	}
	else
	{
		return GetTime() - level.startTime - level.discardTime;
	}
}

/*
	Name: pauseTimer
	Namespace: globallogic_utils
	Checksum: 0x8A2B8B27
	Offset: 0xB78
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function pauseTimer()
{
	if(level.timerStopped)
	{
		return;
	}
	level.timerStopped = 1;
	level.timerPauseTime = GetTime();
}

/*
	Name: resumeTimer
	Namespace: globallogic_utils
	Checksum: 0x61DCDEF2
	Offset: 0xBA8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function resumeTimer()
{
	if(!level.timerStopped)
	{
		return;
	}
	level.timerStopped = 0;
	level.discardTime = level.discardTime + GetTime() - level.timerPauseTime;
}

/*
	Name: getScoreRemaining
	Namespace: globallogic_utils
	Checksum: 0x38809869
	Offset: 0xBE8
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function getScoreRemaining(team)
{
	/#
		Assert(isPlayer(self) || isdefined(team));
	#/
	scoreLimit = level.scoreLimit;
	if(isPlayer(self))
	{
		return scoreLimit - globallogic_score::_getPlayerScore(self);
	}
	else
	{
		return scoreLimit - getTeamScore(team);
	}
}

/*
	Name: getScorePerMinute
	Namespace: globallogic_utils
	Checksum: 0x8255E2D
	Offset: 0xC90
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function getScorePerMinute(team)
{
	/#
		Assert(isPlayer(self) || isdefined(team));
	#/
	scoreLimit = level.scoreLimit;
	timelimit = level.timelimit;
	minutesPassed = getTimePassed() / 60000 + 0.0001;
	if(isPlayer(self))
	{
		return globallogic_score::_getPlayerScore(self) / minutesPassed;
	}
	else
	{
		return getTeamScore(team) / minutesPassed;
	}
}

/*
	Name: getEstimatedTimeUntilScoreLimit
	Namespace: globallogic_utils
	Checksum: 0x77BA2FD7
	Offset: 0xD80
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function getEstimatedTimeUntilScoreLimit(team)
{
	/#
		Assert(isPlayer(self) || isdefined(team));
	#/
	scorePerMinute = self getScorePerMinute(team);
	scoreRemaining = self getScoreRemaining(team);
	if(!scorePerMinute)
	{
		return 999999;
	}
	return scoreRemaining / scorePerMinute;
}

/*
	Name: rumbler
	Namespace: globallogic_utils
	Checksum: 0x64B0CE09
	Offset: 0xE30
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function rumbler()
{
	self endon("disconnect");
	while(1)
	{
		wait(0.1);
		self PlayRumbleOnEntity("damage_heavy");
	}
}

/*
	Name: waitForTimeOrNotify
	Namespace: globallogic_utils
	Checksum: 0x8149A8F0
	Offset: 0xE78
	Size: 0x21
	Parameters: 2
	Flags: None
*/
function waitForTimeOrNotify(time, notifyname)
{
	self endon(notifyname);
	wait(time);
}

/*
	Name: waitForTimeOrNotifyNoArtillery
	Namespace: globallogic_utils
	Checksum: 0x62DBC9E1
	Offset: 0xEA8
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function waitForTimeOrNotifyNoArtillery(time, notifyname)
{
	self endon(notifyname);
	wait(time);
	while(isdefined(level.artilleryInProgress))
	{
		/#
			Assert(level.artilleryInProgress);
		#/
		wait(0.25);
	}
}

/*
	Name: isHeadShot
	Namespace: globallogic_utils
	Checksum: 0xB727A866
	Offset: 0xF08
	Size: 0x85
	Parameters: 4
	Flags: None
*/
function isHeadShot(weapon, sHitLoc, sMeansOfDeath, eInflictor)
{
	if(sHitLoc != "head" && sHitLoc != "helmet")
	{
		return 0;
	}
	switch(sMeansOfDeath)
	{
		case "MOD_MELEE":
		{
			return 0;
		}
		case "MOD_IMPACT":
		{
			if(weapon != level.weaponBallisticKnife)
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: getHitLocHeight
	Namespace: globallogic_utils
	Checksum: 0x82CBF22B
	Offset: 0xF98
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function getHitLocHeight(sHitLoc)
{
	switch(sHitLoc)
	{
		case "head":
		case "helmet":
		case "neck":
		{
			return 60;
		}
		case "gun":
		case "left_arm_lower":
		case "left_arm_upper":
		case "left_hand":
		case "right_arm_lower":
		case "right_arm_upper":
		case "right_hand":
		case "torso_upper":
		{
			return 48;
		}
		case "torso_lower":
		{
			return 40;
		}
		case "left_leg_upper":
		case "right_leg_upper":
		{
			return 32;
		}
		case "left_leg_lower":
		case "right_leg_lower":
		{
			return 10;
		}
		case "left_foot":
		case "right_foot":
		{
			return 5;
		}
	}
	return 48;
}

/*
	Name: debugLine
	Namespace: globallogic_utils
	Checksum: 0x3912785D
	Offset: 0x1078
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function debugLine(start, end)
{
	/#
		for(i = 0; i < 50; i++)
		{
			line(start, end);
			wait(0.05);
		}
	#/
}

/*
	Name: isExcluded
	Namespace: globallogic_utils
	Checksum: 0xFC7988AB
	Offset: 0x10E8
	Size: 0x59
	Parameters: 2
	Flags: None
*/
function isExcluded(entity, entityList)
{
	for(index = 0; index < entityList.size; index++)
	{
		if(entity == entityList[index])
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: waitForTimeOrNotifies
	Namespace: globallogic_utils
	Checksum: 0x53A361FF
	Offset: 0x1150
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function waitForTimeOrNotifies(desiredDelay)
{
	startedWaiting = GetTime();
	waitedTime = GetTime() - startedWaiting / 1000;
	if(waitedTime < desiredDelay)
	{
		wait(desiredDelay - waitedTime);
		return desiredDelay;
	}
	else
	{
		return waitedTime;
	}
}

/*
	Name: logTeamWinString
	Namespace: globallogic_utils
	Checksum: 0xA2F721DA
	Offset: 0x11C0
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function logTeamWinString(wintype, winner)
{
	/#
		log_string = wintype;
		if(isdefined(winner))
		{
			log_string = log_string + "Dev Block strings are not supported" + winner;
		}
		foreach(team in level.teams)
		{
			log_string = log_string + "Dev Block strings are not supported" + team + "Dev Block strings are not supported" + game["Dev Block strings are not supported"][team];
		}
		print(log_string);
	#/
}

