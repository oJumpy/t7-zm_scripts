#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace hostmigration;

/*
	Name: debug_script_structs
	Namespace: hostmigration
	Checksum: 0x66100F4E
	Offset: 0x268
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
	Checksum: 0xC43D16B6
	Offset: 0x3B0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function UpdateTimerPausedness()
{
	shouldBeStopped = isdefined(level.hostMigrationTimer);
	if(!level.timerStopped && shouldBeStopped)
	{
		level.timerStopped = 1;
		level.timerPauseTime = GetTime();
	}
	else if(level.timerStopped && !shouldBeStopped)
	{
		level.timerStopped = 0;
		level.discardTime = level.discardTime + GetTime() - level.timerPauseTime;
	}
}

/*
	Name: Callback_HostMigrationSave
	Namespace: hostmigration
	Checksum: 0x99EC1590
	Offset: 0x440
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function Callback_HostMigrationSave()
{
}

/*
	Name: Callback_PreHostMigrationSave
	Namespace: hostmigration
	Checksum: 0x69B39178
	Offset: 0x450
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function Callback_PreHostMigrationSave()
{
	zm_utility::undo_link_changes();
	if(isdefined(level._hm_should_pause_spawning) && level._hm_should_pause_spawning)
	{
		level flag::set("spawn_zombies");
	}
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] EnableInvulnerability();
		level.players[i] SetDStat("AfterActionReportStats", "lobbyPopup", "summary");
	}
}

/*
	Name: pauseTimer
	Namespace: hostmigration
	Checksum: 0xF05C517D
	Offset: 0x520
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
	Checksum: 0xC45D5429
	Offset: 0x538
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
	Checksum: 0x29D6DFF4
	Offset: 0x560
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
	Name: Callback_HostMigration
	Namespace: hostmigration
	Checksum: 0x7FA55ABD
	Offset: 0x5D0
	Size: 0x899
	Parameters: 0
	Flags: None
*/
function Callback_HostMigration()
{
	zm_utility::redo_link_changes();
	setSlowMotion(1, 1, 0);
	zm_utility::upload_zm_dash_counters();
	level.hostMigrationReturnedPlayerCount = 0;
	if(level.gameEnded)
	{
		/#
			println("Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported");
		#/
		return;
	}
	sethostmigrationstatus(1);
	level notify("host_migration_begin");
	for(i = 0; i < level.players.size; i++)
	{
		if(isdefined(level.hostmigration_link_entity_callback))
		{
			if(!isdefined(level.players[i]._host_migration_link_entity))
			{
				level.players[i]._host_migration_link_entity = level.players[i] [[level.hostmigration_link_entity_callback]]();
			}
		}
		level.players[i] thread hostMigrationTimerThink();
	}
	if(isdefined(level.hostmigration_ai_link_entity_callback))
	{
		zombies = GetAITeamArray(level.zombie_team);
		if(isdefined(zombies) && zombies.size > 0)
		{
			foreach(zombie in zombies)
			{
				if(!isdefined(zombie._host_migration_link_entity))
				{
					zombie._host_migration_link_entity = zombie [[level.hostmigration_ai_link_entity_callback]]();
				}
			}
		}
		break;
	}
	zombies = GetAITeamArray(level.zombie_team);
	if(isdefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			zombie.no_powerups = 1;
			zombie.marked_for_recycle = 1;
			zombie.has_been_damaged_by_player = 0;
			zombie DoDamage(zombie.health + 1000, zombie.origin, zombie);
		}
	}
	else if(level.inPrematchPeriod)
	{
		level waittill("prematch_over");
	}
	/#
		println("Dev Block strings are not supported" + GetTime());
	#/
	level.hostMigrationTimer = 1;
	thread lockTimer();
	if(isdefined(level.b_host_migration_force_player_respawn) && level.b_host_migration_force_player_respawn)
	{
		foreach(player in level.players)
		{
			if(zm_utility::is_player_valid(player, 0, 0))
			{
				player host_migration_respawn();
			}
		}
	}
	zombies = GetAITeamArray(level.zombie_team);
	if(isdefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			if(isdefined(zombie._host_migration_link_entity))
			{
				ent = spawn("script_origin", zombie.origin);
				ent.angles = zombie.angles;
				zombie LinkTo(ent);
				ent LinkTo(zombie._host_migration_link_entity, "tag_origin", zombie._host_migration_link_entity WorldToLocalCoords(ent.origin), ent.angles + zombie._host_migration_link_entity.angles);
				zombie._host_migration_link_helper = ent;
				zombie LinkTo(zombie._host_migration_link_helper);
			}
		}
	}
	level endon("host_migration_begin");
	should_pause_spawning = level flag::get("spawn_zombies");
	if(should_pause_spawning)
	{
		level flag::clear("spawn_zombies");
	}
	hostMigrationWait();
	foreach(player in level.players)
	{
		player thread post_migration_invulnerability();
	}
	zombies = GetAITeamArray(level.zombie_team);
	if(isdefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			if(isdefined(zombie._host_migration_link_entity))
			{
				zombie Unlink();
				zombie._host_migration_link_helper delete();
				zombie._host_migration_link_helper = undefined;
				zombie._host_migration_link_entity = undefined;
			}
		}
	}
	else if(should_pause_spawning)
	{
		level flag::set("spawn_zombies");
	}
	level.hostMigrationTimer = undefined;
	level._hm_should_pause_spawning = undefined;
	sethostmigrationstatus(0);
	/#
		println("Dev Block strings are not supported" + GetTime());
	#/
	level notify("host_migration_end");
}

/*
	Name: post_migration_become_vulnerable
	Namespace: hostmigration
	Checksum: 0xA9E37AB6
	Offset: 0xE78
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function post_migration_become_vulnerable()
{
	self endon("disconnect");
}

/*
	Name: post_migration_invulnerability
	Namespace: hostmigration
	Checksum: 0x9C8798D9
	Offset: 0xE90
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function post_migration_invulnerability()
{
	self endon("disconnect");
	was_inv = self EnableInvulnerability();
	wait(3);
	self DisableInvulnerability();
}

/*
	Name: host_migration_respawn
	Namespace: hostmigration
	Checksum: 0x9B7FE140
	Offset: 0xEE8
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function host_migration_respawn()
{
	/#
		println("Dev Block strings are not supported");
	#/
	new_origin = undefined;
	if(isdefined(level.check_valid_spawn_override))
	{
		new_origin = [[level.check_valid_spawn_override]](self);
	}
	if(!isdefined(new_origin))
	{
		new_origin = zm::check_for_valid_spawn_near_team(self, 1);
	}
	if(isdefined(new_origin))
	{
		if(!isdefined(new_origin.angles))
		{
			angles = (0, 0, 0);
		}
		else
		{
			angles = new_origin.angles;
		}
		self DontInterpolate();
		self SetOrigin(new_origin.origin);
		self SetPlayerAngles(angles);
	}
	return 1;
}

/*
	Name: matchStartTimerConsole_Internal
	Namespace: hostmigration
	Checksum: 0x1462FFE2
	Offset: 0x1000
	Size: 0xB3
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
		countTime--;
		wait(1 - matchStartTimer.inFrames * 0.05);
	}
}

/*
	Name: matchStartTimerConsole
	Namespace: hostmigration
	Checksum: 0x5E36ED5E
	Offset: 0x10C0
	Size: 0x263
	Parameters: 2
	Flags: None
*/
function matchStartTimerConsole(type, duration)
{
	thread matchStartBlacscreen(duration);
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
	if(countTime >= 2)
	{
		matchStartTimerConsole_Internal(countTime, matchStartTimer);
	}
	matchStartTimer hud::destroyElem();
	matchStartText hud::destroyElem();
}

/*
	Name: matchStartBlacscreen
	Namespace: hostmigration
	Checksum: 0xD4D8DE13
	Offset: 0x1330
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function matchStartBlacscreen(duration)
{
	Array::thread_all(GetPlayers(), &zm::InitialBlack);
	fade_time = 4;
	n_black_screen = duration - fade_time;
	level thread zm::fade_out_intro_screen_zm(n_black_screen, fade_time, 1);
	wait(fade_time);
}

/*
	Name: hostMigrationWait
	Namespace: hostmigration
	Checksum: 0x6D66783B
	Offset: 0x13D0
	Size: 0x89
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
	thread matchStartTimerConsole("match_starting_in", 9);
	wait(5);
}

/*
	Name: hostMigrationWaitForPlayers
	Namespace: hostmigration
	Checksum: 0xBF0D71D4
	Offset: 0x1468
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
	Checksum: 0xB34A1481
	Offset: 0x1488
	Size: 0x18F
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
	if(isdefined(self._host_migration_link_entity))
	{
		ent = spawn("script_origin", self.origin);
		ent.angles = self.angles;
		self LinkTo(ent);
		ent LinkTo(self._host_migration_link_entity, "tag_origin", self._host_migration_link_entity WorldToLocalCoords(ent.origin), ent.angles + self._host_migration_link_entity.angles);
		self._host_migration_link_helper = ent;
		/#
			println("Dev Block strings are not supported" + self._host_migration_link_entity.targetname);
		#/
	}
	self.hostMigrationControlsFrozen = 1;
	self FreezeControls(1);
	level waittill("host_migration_end");
}

/*
	Name: hostMigrationTimerThink
	Namespace: hostmigration
	Checksum: 0x1C86DC4E
	Offset: 0x1620
	Size: 0xF5
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
		self.hostMigrationControlsFrozen = 0;
		/#
			println("Dev Block strings are not supported");
		#/
	}
	if(isdefined(self._host_migration_link_entity))
	{
		self Unlink();
		self._host_migration_link_helper delete();
		self._host_migration_link_helper = undefined;
		if(isdefined(self._host_migration_link_entity._post_host_migration_thread))
		{
			self thread [[self._host_migration_link_entity._post_host_migration_thread]](self._host_migration_link_entity);
		}
		self._host_migration_link_entity = undefined;
	}
}

/*
	Name: waitTillHostMigrationDone
	Namespace: hostmigration
	Checksum: 0xE10DA501
	Offset: 0x1720
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
	Checksum: 0xEC32DD0D
	Offset: 0x1760
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
	Checksum: 0x2CD505BD
	Offset: 0x1798
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
	if(GetTime() != endTime)
	{
		/#
			println("Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported" + endTime);
		#/
	}
	waitTillHostMigrationDone();
	return GetTime() - startTime;
}

/*
	Name: waitLongDurationWithGameEndTimeUpdate
	Namespace: hostmigration
	Checksum: 0x6A917748
	Offset: 0x18D0
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
	Name: find_alternate_player_place
	Namespace: hostmigration
	Checksum: 0xBF225FB1
	Offset: 0x1A58
	Size: 0x2AB
	Parameters: 5
	Flags: None
*/
function find_alternate_player_place(v_origin, min_radius, max_radius, max_height, ignore_targetted_nodes)
{
	found_node = undefined;
	a_nodes = GetNodesInRadiusSorted(v_origin, max_radius, min_radius, max_height, "pathnodes");
	if(isdefined(a_nodes) && a_nodes.size > 0)
	{
		a_player_volumes = GetEntArray("player_volume", "script_noteworthy");
		index = a_nodes.size - 1;
		for(i = index; i >= 0; i--)
		{
			n_node = a_nodes[i];
			if(ignore_targetted_nodes == 1)
			{
				if(isdefined(n_node.target))
				{
					continue;
				}
			}
			if(!positionWouldTelefrag(n_node.origin))
			{
				if(zm_utility::check_point_in_enabled_zone(n_node.origin, 1, a_player_volumes))
				{
					v_start = (n_node.origin[0], n_node.origin[1], n_node.origin[2] + 30);
					v_end = (n_node.origin[0], n_node.origin[1], n_node.origin[2] - 30);
					trace = bullettrace(v_start, v_end, 0, undefined);
					if(trace["fraction"] < 1)
					{
						override_abort = 0;
						if(isdefined(level._whoswho_reject_node_override_func))
						{
							override_abort = [[level._whoswho_reject_node_override_func]](v_origin, n_node);
						}
						if(!override_abort)
						{
							found_node = n_node;
							break;
						}
					}
				}
			}
		}
	}
	return found_node;
}

/*
	Name: hostmigration_put_player_in_better_place
	Namespace: hostmigration
	Checksum: 0x933975CA
	Offset: 0x1D10
	Size: 0x393
	Parameters: 0
	Flags: None
*/
function hostmigration_put_player_in_better_place()
{
	spawnpoint = undefined;
	spawnpoint = find_alternate_player_place(self.origin, 50, 150, 64, 1);
	if(!isdefined(spawnpoint))
	{
		spawnpoint = find_alternate_player_place(self.origin, 150, 400, 64, 1);
	}
	if(!isdefined(spawnpoint))
	{
		spawnpoint = find_alternate_player_place(self.origin, 50, 400, 256, 0);
	}
	if(!isdefined(spawnpoint))
	{
		spawnpoint = zm::check_for_valid_spawn_near_team(self, 1);
	}
	if(!isdefined(spawnpoint))
	{
		match_string = "";
		location = level.scr_zm_map_start_location;
		if(location == "default" || location == "" && isdefined(level.default_start_location))
		{
			location = level.default_start_location;
		}
		match_string = level.scr_zm_ui_gametype + "_" + location;
		Spawnpoints = [];
		structs = struct::get_array("initial_spawn", "script_noteworthy");
		if(isdefined(structs))
		{
			foreach(struct in structs)
			{
				if(isdefined(struct.script_string))
				{
					tokens = StrTok(struct.script_string, " ");
					foreach(token in tokens)
					{
						if(token == match_string)
						{
							Spawnpoints[Spawnpoints.size] = struct;
						}
					}
				}
			}
		}
		else if(!isdefined(Spawnpoints) || Spawnpoints.size == 0)
		{
			Spawnpoints = struct::get_array("initial_spawn_points", "targetname");
		}
		/#
			Assert(isdefined(Spawnpoints), "Dev Block strings are not supported");
		#/
		spawnpoint = zm::getFreeSpawnpoint(Spawnpoints, self);
	}
	if(isdefined(spawnpoint))
	{
		self SetOrigin(spawnpoint.origin);
	}
}

