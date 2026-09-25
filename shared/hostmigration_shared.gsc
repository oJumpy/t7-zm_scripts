#using scripts\codescripts\struct;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

#namespace hostmigration;

/*
	Name: debug_script_structs
	Namespace: hostmigration
	Checksum: 0x4000573A
	Offset: 0x160
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function debug_script_structs()
{
	/#
		if(isdefined(level.struct))
		{
			println("Dev Block strings are not supported" + level.struct.size);
			println("Dev Block strings are not supported");
			for(i = 0; i < level.struct.size; i++)
			{
				struct = level.struct[i];
				if(isdefined(struct.targetname))
				{
					println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + struct.targetname);
					continue;
				}
				println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + "Dev Block strings are not supported");
			}
		}
		else
		{
			println("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: UpdateTimerPausedness
	Namespace: hostmigration
	Checksum: 0xD27D2531
	Offset: 0x2A8
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function UpdateTimerPausedness()
{
	shouldBeStopped = isdefined(level.hostMigrationTimer);
	if(!level.timerStopped && shouldBeStopped)
	{
		level.timerStopped = 1;
		level.playableTimerStopped = 1;
		level.timerPauseTime = GetTime();
	}
	else if(level.timerStopped && !shouldBeStopped)
	{
		level.timerStopped = 0;
		level.playableTimerStopped = 0;
		level.discardTime = level.discardTime + GetTime() - level.timerPauseTime;
	}
}

/*
	Name: pauseTimer
	Namespace: hostmigration
	Checksum: 0xE2660599
	Offset: 0x350
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function pauseTimer()
{
	level.migrationTimerPauseTime = GetTime();
}

/*
	Name: resumeTimer
	Namespace: hostmigration
	Checksum: 0xD51A2B5B
	Offset: 0x368
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function resumeTimer()
{
	level.discardTime = level.discardTime + GetTime() - level.migrationTimerPauseTime;
}

/*
	Name: lockTimer
	Namespace: hostmigration
	Checksum: 0x75C48429
	Offset: 0x390
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function lockTimer()
{
	level endon("host_migration_begin");
	level endon("host_migration_end");
	for(;;)
	{
		currTime = GetTime();
		wait(0.05);
		if(!level.timerStopped && isdefined(level.discardTime))
		{
			level.discardTime = level.discardTime + GetTime() - currTime;
		}
	}
}

/*
	Name: matchStartTimerConsole_Internal
	Namespace: hostmigration
	Checksum: 0xF83530B
	Offset: 0x400
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function matchStartTimerConsole_Internal(countTime, matchStartTimer)
{
	waittillframeend;
	level endon("match_start_timer_beginning");
	while(countTime > 0 && !level.gameEnded)
	{
		matchStartTimer thread hud::font_pulse(level);
		wait(matchStartTimer.inFrames * 0.05);
		matchStartTimer setValue(countTime);
		if(countTime == 2)
		{
			visionSetNaked(GetDvarString("mapname"), 3);
		}
		countTime--;
		wait(1 - matchStartTimer.inFrames * 0.05);
	}
}

/*
	Name: matchStartTimerConsole
	Namespace: hostmigration
	Checksum: 0xC73E526C
	Offset: 0x500
	Size: 0x27B
	Parameters: 2
	Flags: None
*/
function matchStartTimerConsole(type, duration)
{
	level notify("match_start_timer_beginning");
	wait(0.05);
	matchStartText = hud::createServerFontString("objective", 1.5);
	matchStartText hud::setPoint("CENTER", "CENTER", 0, -40);
	matchStartText.sort = 1001;
	matchStartText setText(game["strings"]["waiting_for_teams"]);
	matchStartText.foreground = 0;
	matchStartText.hidewheninmenu = 1;
	matchStartText setText(game["strings"][type]);
	matchStartTimer = hud::createServerFontString("objective", 2.2);
	matchStartTimer hud::setPoint("CENTER", "CENTER", 0, 0);
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1, 1, 0);
	matchStartTimer.foreground = 0;
	matchStartTimer.hidewheninmenu = 1;
	matchStartTimer hud::font_pulse_init();
	countTime = Int(duration);
	if(isdefined(level.host_migration_activate_visionset_func))
	{
		level thread [[level.host_migration_activate_visionset_func]]();
	}
	if(countTime >= 2)
	{
		matchStartTimerConsole_Internal(countTime, matchStartTimer);
	}
	if(isdefined(level.host_migration_deactivate_visionset_func))
	{
		level thread [[level.host_migration_deactivate_visionset_func]]();
	}
	matchStartTimer hud::destroyElem();
	matchStartText hud::destroyElem();
}

/*
	Name: hostMigrationWait
	Namespace: hostmigration
	Checksum: 0xCA552724
	Offset: 0x788
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function hostMigrationWait()
{
	level endon("game_ended");
	if(level.hostMigrationReturnedPlayerCount < level.players.size * 2 / 3)
	{
		thread matchStartTimerConsole("waiting_for_teams", 20);
		hostMigrationWaitForPlayers();
	}
	level notify("host_migration_countdown_begin");
	thread matchStartTimerConsole("match_starting_in", 5);
	wait(5);
}

/*
	Name: waittillHostMigrationCountDown
	Namespace: hostmigration
	Checksum: 0xB75EB330
	Offset: 0x830
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittillHostMigrationCountDown()
{
	level endon("host_migration_end");
	if(!isdefined(level.hostMigrationTimer))
	{
		return;
	}
	level waittill("host_migration_countdown_begin");
}

/*
	Name: hostMigrationWaitForPlayers
	Namespace: hostmigration
	Checksum: 0xED5748DC
	Offset: 0x868
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function hostMigrationWaitForPlayers()
{
	level endon("hostmigration_enoughplayers");
	wait(15);
}

/*
	Name: hostMigrationTimerThink_Internal
	Namespace: hostmigration
	Checksum: 0x5D666D2F
	Offset: 0x888
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function hostMigrationTimerThink_Internal()
{
	level endon("host_migration_begin");
	level endon("host_migration_end");
	self.hostMigrationControlsFrozen = 0;
	while(!isalive(self))
	{
		self waittill("spawned");
	}
	self.hostMigrationControlsFrozen = 1;
	self FreezeControls(1);
	level waittill("host_migration_end");
}

/*
	Name: hostMigrationTimerThink
	Namespace: hostmigration
	Checksum: 0xA4899C94
	Offset: 0x910
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function hostMigrationTimerThink()
{
	self endon("disconnect");
	level endon("host_migration_begin");
	hostMigrationTimerThink_Internal();
	if(self.hostMigrationControlsFrozen)
	{
		self FreezeControls(0);
	}
}

/*
	Name: waitTillHostMigrationDone
	Namespace: hostmigration
	Checksum: 0xBDE13E63
	Offset: 0x968
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function waitTillHostMigrationDone()
{
	if(!isdefined(level.hostMigrationTimer))
	{
		return 0;
	}
	startTime = GetTime();
	level waittill("host_migration_end");
	return GetTime() - startTime;
}

/*
	Name: waitTillHostMigrationStarts
	Namespace: hostmigration
	Checksum: 0x8056C80D
	Offset: 0x9A8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function waitTillHostMigrationStarts(duration)
{
	if(isdefined(level.hostMigrationTimer))
	{
		return;
	}
	level endon("host_migration_begin");
	wait(duration);
}

/*
	Name: waitLongDurationWithHostMigrationPause
	Namespace: hostmigration
	Checksum: 0x29CB3318
	Offset: 0x9E0
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function waitLongDurationWithHostMigrationPause(duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		Assert(duration > 0);
	#/
	startTime = GetTime();
	endTime = GetTime() + duration * 1000;
	while(GetTime() < endTime)
	{
		waitTillHostMigrationStarts(endTime - GetTime() / 1000);
		if(isdefined(level.hostMigrationTimer))
		{
			timePassed = waitTillHostMigrationDone();
			endTime = endTime + timePassed;
		}
	}
	/#
		if(GetTime() != endTime)
		{
			println("Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported" + endTime);
		}
	#/
	waitTillHostMigrationDone();
	return GetTime() - startTime;
}

/*
	Name: waitLongDurationWithHostMigrationPauseEMP
	Namespace: hostmigration
	Checksum: 0x3577F787
	Offset: 0xB18
	Size: 0x14D
	Parameters: 1
	Flags: None
*/
function waitLongDurationWithHostMigrationPauseEMP(duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		Assert(duration > 0);
	#/
	startTime = GetTime();
	empEndTime = GetTime() + duration * 1000;
	level.empEndTime = empEndTime;
	while(GetTime() < empEndTime)
	{
		waitTillHostMigrationStarts(empEndTime - GetTime() / 1000);
		if(isdefined(level.hostMigrationTimer))
		{
			timePassed = waitTillHostMigrationDone();
			if(isdefined(empEndTime))
			{
				empEndTime = empEndTime + timePassed;
			}
		}
	}
	/#
		if(GetTime() != empEndTime)
		{
			println("Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported" + empEndTime);
		}
	#/
	waitTillHostMigrationDone();
	level.empEndTime = undefined;
	return GetTime() - startTime;
}

/*
	Name: waitLongDurationWithGameEndTimeUpdate
	Namespace: hostmigration
	Checksum: 0x8E79BBDE
	Offset: 0xC70
	Size: 0x17D
	Parameters: 1
	Flags: None
*/
function waitLongDurationWithGameEndTimeUpdate(duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		Assert(duration > 0);
	#/
	startTime = GetTime();
	endTime = GetTime() + duration * 1000;
	while(GetTime() < endTime)
	{
		waitTillHostMigrationStarts(endTime - GetTime() / 1000);
		while(isdefined(level.hostMigrationTimer))
		{
			endTime = endTime + 1000;
			setGameEndTime(Int(endTime));
			wait(1);
		}
	}
	/#
		if(GetTime() != endTime)
		{
			println("Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported" + endTime);
		}
	#/
	while(isdefined(level.hostMigrationTimer))
	{
		endTime = endTime + 1000;
		setGameEndTime(Int(endTime));
		wait(1);
	}
	return GetTime() - startTime;
}

/*
	Name: MigrationAwareWait
	Namespace: hostmigration
	Checksum: 0xF7EA8BEE
	Offset: 0xDF8
	Size: 0xE7
	Parameters: 1
	Flags: None
*/
function MigrationAwareWait(durationMs)
{
	waitTillHostMigrationDone();
	endTime = GetTime() + durationMs;
	timeRemaining = durationMs;
	while(1)
	{
		event = level util::waittill_level_any_timeout(timeRemaining / 1000, self, "game_ended", "host_migration_begin");
		if(!isdefined(event))
		{
			return;
		}
		if(event != "host_migration_begin")
		{
			return;
		}
		timeRemaining = endTime - GetTime();
		if(timeRemaining <= 0)
		{
			return;
		}
		endTime = GetTime() + durationMs;
		waitTillHostMigrationDone();
	}
}

