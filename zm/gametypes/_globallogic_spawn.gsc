#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_defaults;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hostmigration;
#using scripts\zm\gametypes\_spawning;
#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_spectating;

#namespace globallogic_spawn;

/*
	Name: init
	Namespace: globallogic_spawn
	Checksum: 0xE463DD58
	Offset: 0x630
	Size: 0x23
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	if(!isdefined(level.giveStartLoadout))
	{
		level.giveStartLoadout = &giveStartLoadout;
	}
}

/*
	Name: timeUntilSpawn
	Namespace: globallogic_spawn
	Checksum: 0x8B584914
	Offset: 0x660
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function timeUntilSpawn(includeTeamkillDelay)
{
	if(level.inGracePeriod && !self.hasSpawned)
	{
		return 0;
	}
	respawnDelay = 0;
	if(self.hasSpawned)
	{
		result = self [[level.onRespawnDelay]]();
		if(isdefined(result))
		{
			respawnDelay = result;
		}
		else
		{
			respawnDelay = level.playerRespawnDelay;
		}
		if(includeTeamkillDelay && (isdefined(self.teamKillPunish) && self.teamKillPunish))
		{
			respawnDelay = respawnDelay + globallogic_player::teamKillDelay();
		}
	}
	waveBased = level.waveRespawnDelay > 0;
	if(waveBased)
	{
		return self TimeUntilWaveSpawn(respawnDelay);
	}
	return respawnDelay;
}

/*
	Name: allTeamsHaveExisted
	Namespace: globallogic_spawn
	Checksum: 0x62C76B8C
	Offset: 0x768
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function allTeamsHaveExisted()
{
	foreach(team in level.teams)
	{
		if(!level.everExisted[team])
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: maySpawn
	Namespace: globallogic_spawn
	Checksum: 0x89CF901C
	Offset: 0x800
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function maySpawn()
{
	if(isdefined(level.playerMaySpawn) && !self [[level.playerMaySpawn]]())
	{
		return 0;
	}
	if(level.inOvertime)
	{
		return 0;
	}
	if(level.playerQueuedRespawn && !isdefined(self.allowQueueSpawn) && !level.inGracePeriod && !level.useStartSpawns)
	{
		return 0;
	}
	if(level.numLives)
	{
		if(level.teambased)
		{
			gameHasStarted = allTeamsHaveExisted();
		}
		else
		{
			gameHasStarted = level.maxPlayerCount > 1 || (!util::isOneRound() && !util::isFirstRound());
		}
		if(!self.pers["lives"] && gameHasStarted)
		{
			return 0;
		}
		else if(gameHasStarted)
		{
			if(!level.inGracePeriod && !self.hasSpawned && !level.wagerMatch)
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: TimeUntilWaveSpawn
	Namespace: globallogic_spawn
	Checksum: 0x3E010EF
	Offset: 0x950
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function TimeUntilWaveSpawn(minimumWait)
{
	earliestSpawnTime = GetTime() + minimumWait * 1000;
	lastWaveTime = level.lastWave[self.pers["team"]];
	waveDelay = level.waveDelay[self.pers["team"]] * 1000;
	if(waveDelay == 0)
	{
		return 0;
	}
	numWavesPassedEarliestSpawnTime = earliestSpawnTime - lastWaveTime / waveDelay;
	numWaves = ceil(numWavesPassedEarliestSpawnTime);
	timeOfSpawn = lastWaveTime + numWaves * waveDelay;
	if(isdefined(self.waveSpawnIndex))
	{
		timeOfSpawn = timeOfSpawn + 50 * self.waveSpawnIndex;
	}
	return timeOfSpawn - GetTime() / 1000;
}

/*
	Name: stopPoisoningAndFlareOnSpawn
	Namespace: globallogic_spawn
	Checksum: 0x3D0C9E1
	Offset: 0xA80
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function stopPoisoningAndFlareOnSpawn()
{
	self endon("disconnect");
	self.inPoisonArea = 0;
	self.inBurnArea = 0;
	self.inFlareVisionArea = 0;
	self.inGroundNapalm = 0;
}

/*
	Name: spawnPlayerPrediction
	Namespace: globallogic_spawn
	Checksum: 0x904A888F
	Offset: 0xAC8
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function spawnPlayerPrediction()
{
	self endon("disconnect");
	self endon("end_respawn");
	self endon("game_ended");
	self endon("joined_spectators");
	self endon("spawned");
	while(1)
	{
		wait(0.5);
		if(isdefined(level.onSpawnPlayerUnified) && GetDvarInt("scr_disableunifiedspawning") == 0)
		{
			Spawning::onSpawnPlayer_Unified(1);
		}
		else
		{
			self [[level.onSpawnPlayer]](1);
		}
	}
}

/*
	Name: giveLoadoutLevelSpecific
	Namespace: globallogic_spawn
	Checksum: 0xD4DD4D69
	Offset: 0xB80
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function giveLoadoutLevelSpecific(team, _class)
{
	PixBeginEvent("giveLoadoutLevelSpecific");
	if(isdefined(level.giveCustomCharacters))
	{
		self [[level.giveCustomCharacters]]();
	}
	if(isdefined(level.giveStartLoadout))
	{
		self [[level.giveStartLoadout]]();
	}
	self flagsys::set("loadout_given");
	callback::callback("hash_33bba039");
	PixEndEvent();
}

/*
	Name: giveStartLoadout
	Namespace: globallogic_spawn
	Checksum: 0x53BDB948
	Offset: 0xC38
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function giveStartLoadout()
{
	if(isdefined(level.giveCustomLoadout))
	{
		self [[level.giveCustomLoadout]]();
	}
}

/*
	Name: spawnPlayer
	Namespace: globallogic_spawn
	Checksum: 0x9A5031F2
	Offset: 0xC60
	Size: 0xD03
	Parameters: 0
	Flags: None
*/
function spawnPlayer()
{
	PixBeginEvent("spawnPlayer_preUTS");
	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	level notify("player_spawned");
	self notify("end_respawn");
	self setSpawnVariables();
	self LUINotifyEvent(&"player_spawned", 0);
	if(!self.hasSpawned)
	{
		self.underscoreChance = 70;
		self thread globallogic_audio::sndStartMusicSystem();
	}
	self.sessionteam = self.team;
	hadSpawned = self.hasSpawned;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.statusicon = "";
	self.damagedPlayers = [];
	if(GetDvarInt("scr_csmode") > 0)
	{
		self.maxhealth = GetDvarInt("scr_csmode");
	}
	else
	{
		self.maxhealth = level.playerMaxHealth;
	}
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = 1;
	self.spawntime = GetTime();
	self.afk = 0;
	if(self.pers["lives"] && (!isdefined(level.takeLivesOnDeath) || level.takeLivesOnDeath == 0))
	{
		self.pers["lives"]--;
		if(self.pers["lives"] == 0)
		{
			level notify("player_eliminated");
			self notify("player_eliminated");
		}
	}
	self.laststand = undefined;
	self.revivingTeammate = 0;
	self.burning = undefined;
	self.nextKillstreakFree = undefined;
	self.activeUAVs = 0;
	self.activeCounterUAVs = 0;
	self.activeSatellites = 0;
	self.deathMachineKills = 0;
	self.disabledWeapon = 0;
	self util::resetUsability();
	self globallogic_player::resetAttackerList();
	self.diedOnVehicle = undefined;
	if(!self.wasAliveAtMatchStart)
	{
		if(level.inGracePeriod || globallogic_utils::getTimePassed() < 20000)
		{
			self.wasAliveAtMatchStart = 1;
		}
	}
	self setDepthOfField(0, 0, 512, 512, 4, 0);
	self resetFov();
	PixBeginEvent("onSpawnPlayer");
	if(isdefined(level.onSpawnPlayerUnified) && GetDvarInt("scr_disableunifiedspawning") == 0)
	{
		self [[level.onSpawnPlayerUnified]]();
	}
	else
	{
		self [[level.onSpawnPlayer]](0);
	}
	if(isdefined(level.playerSpawnedCB))
	{
		self [[level.playerSpawnedCB]]();
	}
	PixEndEvent();
	PixEndEvent();
	level thread globallogic::updateTeamStatus();
	PixBeginEvent("spawnPlayer_postUTS");
	self thread stopPoisoningAndFlareOnSpawn();
	/#
		Assert(globallogic_utils::isValidClass(self.curClass));
	#/
	self giveLoadoutLevelSpecific(self.team, self.curClass);
	if(level.inPrematchPeriod)
	{
		self util::freeze_player_controls(1);
		team = self.pers["team"];
		if(isdefined(self.pers["music"].spawn) && self.pers["music"].spawn == 0)
		{
			if(level.wagerMatch)
			{
				music = "SPAWN_WAGER";
			}
			else
			{
				music = game["music"]["spawn_" + team];
			}
			self thread globallogic_audio::set_music_on_player(music, 0, 0);
			self.pers["music"].spawn = 1;
		}
		if(level.Splitscreen)
		{
			if(isdefined(level.playedStartingMusic))
			{
				music = undefined;
			}
			else
			{
				level.playedStartingMusic = 1;
			}
		}
		if(!isdefined(level.disablePrematchMessages) || level.disablePrematchMessages == 0)
		{
			thread hud_message::showInitialFactionPopup(team);
			hintMessage = util::getObjectiveHintText(self.pers["team"]);
			if(isdefined(hintMessage))
			{
				self thread hud_message::hintMessage(hintMessage);
			}
			if(isdefined(game["dialog"]["gametype"]) && (!level.Splitscreen || self == level.players[0]))
			{
				if(!isdefined(level.inFinalFight) || !level.inFinalFight)
				{
					if(level.hardcoreMode)
					{
						self globallogic_audio::leaderDialogOnPlayer("gametype_hardcore");
					}
					else
					{
						self globallogic_audio::leaderDialogOnPlayer("gametype");
					}
				}
			}
			if(team == game["attackers"])
			{
				self globallogic_audio::leaderDialogOnPlayer("offense_obj", "introboost");
			}
			else
			{
				self globallogic_audio::leaderDialogOnPlayer("defense_obj", "introboost");
			}
		}
	}
	else
	{
		self util::freeze_player_controls(0);
		self enableWeapons();
		if(!hadSpawned && game["state"] == "playing")
		{
			PixBeginEvent("sound");
			team = self.team;
			if(isdefined(self.pers["music"].spawn) && self.pers["music"].spawn == 0)
			{
				self thread globallogic_audio::set_music_on_player("SPAWN_SHORT", 0, 0);
				self.pers["music"].spawn = 1;
			}
			if(level.Splitscreen)
			{
				if(isdefined(level.playedStartingMusic))
				{
					music = undefined;
				}
				else
				{
					level.playedStartingMusic = 1;
				}
			}
			if(!isdefined(level.disablePrematchMessages) || level.disablePrematchMessages == 0)
			{
				thread hud_message::showInitialFactionPopup(team);
				hintMessage = util::getObjectiveHintText(self.pers["team"]);
				if(isdefined(hintMessage))
				{
					self thread hud_message::hintMessage(hintMessage);
				}
				if(isdefined(game["dialog"]["gametype"]) && (!level.Splitscreen || self == level.players[0]))
				{
					if(!isdefined(level.inFinalFight) || !level.inFinalFight)
					{
						if(level.hardcoreMode)
						{
							self globallogic_audio::leaderDialogOnPlayer("gametype_hardcore");
						}
						else
						{
							self globallogic_audio::leaderDialogOnPlayer("gametype");
						}
					}
				}
				if(team == game["attackers"])
				{
					self globallogic_audio::leaderDialogOnPlayer("offense_obj", "introboost");
				}
				else
				{
					self globallogic_audio::leaderDialogOnPlayer("defense_obj", "introboost");
				}
			}
			PixEndEvent();
		}
	}
	if(GetDvarString("scr_showperksonspawn") == "")
	{
		SetDvar("scr_showperksonspawn", "0");
	}
	if(level.hardcoreMode)
	{
		SetDvar("scr_showperksonspawn", "0");
	}
	if(!level.Splitscreen && GetDvarInt("scr_showperksonspawn") == 1 && game["state"] != "postgame")
	{
		PixBeginEvent("showperksonspawn");
		if(level.perksEnabled == 1)
		{
			self hud::showPerks();
		}
		PixEndEvent();
	}
	if(isdefined(self.pers["momentum"]))
	{
		self.momentum = self.pers["momentum"];
	}
	PixEndEvent();
	waittillframeend;
	self notify("spawned_player");
	self callback::callback("hash_bc12b61f");
	/#
		print("Dev Block strings are not supported" + self.origin[0] + "Dev Block strings are not supported" + self.origin[1] + "Dev Block strings are not supported" + self.origin[2] + "Dev Block strings are not supported");
	#/
	SetDvar("scr_selecting_location", "");
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			self thread globallogic_score::xpRateThread();
		}
	#/
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	if(game["state"] == "postgame")
	{
		/#
			Assert(!level.intermission);
		#/
		self globallogic_player::freezePlayerForRoundEnd();
	}
	self util::set_lighting_state();
	self util::set_sun_shadow_split_distance();
}

/*
	Name: spawnSpectator
	Namespace: globallogic_spawn
	Checksum: 0xA40386FC
	Offset: 0x1970
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");
	in_spawnSpectator(origin, angles);
}

/*
	Name: respawn_asSpectator
	Namespace: globallogic_spawn
	Checksum: 0xE46C158F
	Offset: 0x19C8
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function respawn_asSpectator(origin, angles)
{
	in_spawnSpectator(origin, angles);
}

/*
	Name: in_spawnSpectator
	Namespace: globallogic_spawn
	Checksum: 0xC127FE95
	Offset: 0x1A00
	Size: 0x18B
	Parameters: 2
	Flags: None
*/
function in_spawnSpectator(origin, angles)
{
	pixmarker("BEGIN: in_spawnSpectator");
	self setSpawnVariables();
	if(self.pers["team"] == "spectator")
	{
		self util::clearLowerMessage();
	}
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.friendlydamage = undefined;
	if(self.pers["team"] == "spectator")
	{
		self.statusicon = "";
	}
	else
	{
		self.statusicon = "hud_status_dead";
	}
	spectating::setSpectatePermissionsForMachine();
	[[level.onSpawnSpectator]](origin, angles);
	if(level.teambased && !level.Splitscreen)
	{
		self thread spectatorThirdPersonness();
	}
	level thread globallogic::updateTeamStatus();
	pixmarker("END: in_spawnSpectator");
}

/*
	Name: spectatorThirdPersonness
	Namespace: globallogic_spawn
	Checksum: 0x74F3659C
	Offset: 0x1B98
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function spectatorThirdPersonness()
{
	self endon("disconnect");
	self endon("spawned");
	self notify("spectator_thirdperson_thread");
	self endon("spectator_thirdperson_thread");
	self.spectatingThirdPerson = 0;
}

/*
	Name: forceSpawn
	Namespace: globallogic_spawn
	Checksum: 0x34827141
	Offset: 0x1BE0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function forceSpawn(time)
{
	self endon("death");
	self endon("disconnect");
	self endon("spawned");
	if(!isdefined(time))
	{
		time = 60;
	}
	wait(time);
	if(self.hasSpawned)
	{
		return;
	}
	if(self.pers["team"] == "spectator")
	{
		return;
	}
	if(!globallogic_utils::isValidClass(self.pers["class"]))
	{
		self.pers["class"] = "CLASS_CUSTOM1";
		self.curClass = self.pers["class"];
	}
	self globallogic_ui::closeMenus();
	self thread [[level.spawnClient]]();
}

/*
	Name: kickIfDontSpawn
	Namespace: globallogic_spawn
	Checksum: 0xD6461EAF
	Offset: 0x1CE0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function kickIfDontSpawn()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			return;
		}
	#/
	if(self IsHost())
	{
		return;
	}
	self kickIfIDontSpawnInternal();
}

/*
	Name: kickIfIDontSpawnInternal
	Namespace: globallogic_spawn
	Checksum: 0x6DB59FCB
	Offset: 0x1D48
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function kickIfIDontSpawnInternal()
{
	self endon("death");
	self endon("disconnect");
	self endon("spawned");
	waitTime = 90;
	if(GetDvarString("scr_kick_time") != "")
	{
		waitTime = GetDvarFloat("scr_kick_time");
	}
	minTime = 45;
	if(GetDvarString("scr_kick_mintime") != "")
	{
		minTime = GetDvarFloat("scr_kick_mintime");
	}
	startTime = GetTime();
	kickWait(waitTime);
	timePassed = GetTime() - startTime / 1000;
	if(timePassed < waitTime - 0.1 && timePassed < minTime)
	{
		return;
	}
	if(self.hasSpawned)
	{
		return;
	}
	if(SessionModeIsPrivate())
	{
		return;
	}
	if(self.pers["team"] == "spectator")
	{
		return;
	}
	kick(self GetEntityNumber());
}

/*
	Name: kickWait
	Namespace: globallogic_spawn
	Checksum: 0x89964BF0
	Offset: 0x1EF8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function kickWait(waitTime)
{
	level endon("game_ended");
	hostmigration::waitLongDurationWithHostMigrationPause(waitTime);
}

/*
	Name: spawnInterRoundIntermission
	Namespace: globallogic_spawn
	Checksum: 0xEA4083B3
	Offset: 0x1F30
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function spawnInterRoundIntermission()
{
	self notify("spawned");
	self notify("end_respawn");
	self setSpawnVariables();
	self util::clearLowerMessage();
	self util::freeze_player_controls(0);
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.friendlydamage = undefined;
	self globallogic_defaults::default_onSpawnIntermission();
	self SetOrigin(self.origin);
	self SetPlayerAngles(self.angles);
	self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
}

/*
	Name: spawnIntermission
	Namespace: globallogic_spawn
	Checksum: 0x342BD89A
	Offset: 0x2070
	Size: 0x233
	Parameters: 1
	Flags: None
*/
function spawnIntermission(useDefaultCallback)
{
	self notify("spawned");
	self notify("end_respawn");
	self endon("disconnect");
	self setSpawnVariables();
	self util::clearLowerMessage();
	self util::freeze_player_controls(0);
	if(level.rankedMatch && util::wasLastRound())
	{
		if(self.postGameMilestones || self.postGameContracts || self.postGamePromotion)
		{
			if(self.postGamePromotion)
			{
				self playlocalsound("mus_level_up");
			}
			else if(self.postGameContracts)
			{
				self playlocalsound("mus_challenge_complete");
			}
			else if(self.postGameMilestones)
			{
				self playlocalsound("mus_contract_complete");
			}
			self closeInGameMenu();
			for(waitTime = 4; waitTime;  = 4)
			{
				wait(0.25);
			}
		}
	}
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.friendlydamage = undefined;
	if(isdefined(useDefaultCallback) && useDefaultCallback)
	{
		globallogic_defaults::default_onSpawnIntermission();
	}
	else
	{
		[[level.onSpawnIntermission]]();
	}
	self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
}

/*
	Name: spawnQueuedClientOnTeam
	Namespace: globallogic_spawn
	Checksum: 0x5F6B1916
	Offset: 0x22B0
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function spawnQueuedClientOnTeam(team)
{
	player_to_spawn = undefined;
	for(i = 0; i < level.deadPlayers[team].size; i++)
	{
		player = level.deadPlayers[team][i];
		if(player.waitingToSpawn)
		{
			continue;
		}
		player_to_spawn = player;
		break;
	}
	if(isdefined(player_to_spawn))
	{
		player_to_spawn.allowQueueSpawn = 1;
		player_to_spawn globallogic_ui::closeMenus();
		player_to_spawn thread [[level.spawnClient]]();
	}
}

/*
	Name: spawnQueuedClient
	Namespace: globallogic_spawn
	Checksum: 0x1658C3CB
	Offset: 0x2390
	Size: 0x151
	Parameters: 2
	Flags: None
*/
function spawnQueuedClient(dead_player_team, killer)
{
	if(!level.playerQueuedRespawn)
	{
		return;
	}
	util::WaitTillSlowProcessAllowed();
	spawn_team = undefined;
	if(isdefined(killer) && isdefined(killer.team) && isdefined(level.teams[killer.team]))
	{
		spawn_team = killer.team;
	}
	if(isdefined(spawn_team))
	{
		spawnQueuedClientOnTeam(spawn_team);
		return;
	}
	foreach(team in level.teams)
	{
		if(team == dead_player_team)
		{
			continue;
		}
		spawnQueuedClientOnTeam(team);
	}
}

/*
	Name: allTeamsNearScoreLimit
	Namespace: globallogic_spawn
	Checksum: 0x35AAE151
	Offset: 0x24F0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function allTeamsNearScoreLimit()
{
	if(!level.teambased)
	{
		return 0;
	}
	if(level.scoreLimit <= 1)
	{
		return 0;
	}
	foreach(team in level.teams)
	{
		if(!game["teamScores"][team] >= level.scoreLimit - 1)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: shouldShowRespawnMessage
	Namespace: globallogic_spawn
	Checksum: 0x12349506
	Offset: 0x25C0
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function shouldShowRespawnMessage()
{
	if(util::wasLastRound())
	{
		return 0;
	}
	if(util::isOneRound())
	{
		return 0;
	}
	if(isdefined(level.livesDoNotReset) && level.livesDoNotReset)
	{
		return 0;
	}
	if(allTeamsNearScoreLimit())
	{
		return 0;
	}
	return 1;
}

/*
	Name: default_spawnMessage
	Namespace: globallogic_spawn
	Checksum: 0x173D0A98
	Offset: 0x2638
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function default_spawnMessage()
{
	util::setLowerMessage(game["strings"]["spawn_next_round"]);
	self thread globallogic_ui::removeSpawnMessageShortly(3);
}

/*
	Name: showSpawnMessage
	Namespace: globallogic_spawn
	Checksum: 0x6049EE38
	Offset: 0x2688
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function showSpawnMessage()
{
	if(shouldShowRespawnMessage())
	{
		self thread [[level.spawnMessage]]();
	}
}

/*
	Name: spawnClient
	Namespace: globallogic_spawn
	Checksum: 0xA00A5955
	Offset: 0x26B8
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function spawnClient(timeAlreadyPassed)
{
	PixBeginEvent("spawnClient");
	/#
		Assert(isdefined(self.team));
	#/
	/#
		Assert(globallogic_utils::isValidClass(self.curClass));
	#/
	if(!self maySpawn())
	{
		currentorigin = self.origin;
		currentangles = self.angles;
		self showSpawnMessage();
		self thread [[level.spawnSpectator]](currentorigin + VectorScale((0, 0, 1), 60), currentangles);
		PixEndEvent();
		return;
	}
	if(self.waitingToSpawn)
	{
		PixEndEvent();
		return;
	}
	self.waitingToSpawn = 1;
	self.allowQueueSpawn = undefined;
	self waitAndSpawnClient(timeAlreadyPassed);
	if(isdefined(self))
	{
		self.waitingToSpawn = 0;
	}
	PixEndEvent();
}

/*
	Name: waitAndSpawnClient
	Namespace: globallogic_spawn
	Checksum: 0xDCE61B95
	Offset: 0x2840
	Size: 0x4D7
	Parameters: 1
	Flags: None
*/
function waitAndSpawnClient(timeAlreadyPassed)
{
	self endon("disconnect");
	self endon("end_respawn");
	level endon("game_ended");
	if(!isdefined(timeAlreadyPassed))
	{
		timeAlreadyPassed = 0;
	}
	spawnedAsSpectator = 0;
	if(isdefined(self.teamKillPunish) && self.teamKillPunish)
	{
		teamKillDelay = globallogic_player::teamKillDelay();
		if(teamKillDelay > timeAlreadyPassed)
		{
			teamKillDelay = teamKillDelay - timeAlreadyPassed;
			timeAlreadyPassed = 0;
		}
		else
		{
			timeAlreadyPassed = timeAlreadyPassed - teamKillDelay;
			teamKillDelay = 0;
		}
		if(teamKillDelay > 0)
		{
			util::setLowerMessage(&"MP_FRIENDLY_FIRE_WILL_NOT", teamKillDelay);
			self thread respawn_asSpectator(self.origin + VectorScale((0, 0, 1), 60), self.angles);
			spawnedAsSpectator = 1;
			wait(teamKillDelay);
		}
		self.teamKillPunish = 0;
	}
	if(!isdefined(self.waveSpawnIndex) && isdefined(level.wavePlayerSpawnIndex[self.team]))
	{
		self.waveSpawnIndex = level.wavePlayerSpawnIndex[self.team];
		level.wavePlayerSpawnIndex[self.team]++;
	}
	timeUntilSpawn = timeUntilSpawn(0);
	if(timeUntilSpawn > timeAlreadyPassed)
	{
		timeUntilSpawn = timeUntilSpawn - timeAlreadyPassed;
		timeAlreadyPassed = 0;
	}
	else
	{
		timeAlreadyPassed = timeAlreadyPassed - timeUntilSpawn;
		timeUntilSpawn = 0;
	}
	if(timeUntilSpawn > 0)
	{
		if(level.playerQueuedRespawn)
		{
			util::setLowerMessage(game["strings"]["you_will_spawn"], timeUntilSpawn);
		}
		else if(self IsSplitscreen())
		{
			util::setLowerMessage(game["strings"]["waiting_to_spawn_ss"], timeUntilSpawn, 1);
		}
		else
		{
			util::setLowerMessage(game["strings"]["waiting_to_spawn"], timeUntilSpawn);
		}
		if(!spawnedAsSpectator)
		{
			spawnOrigin = self.origin + VectorScale((0, 0, 1), 60);
			spawnAngles = self.angles;
			if(isdefined(level.useIntermissionPointsOnWaveSpawn) && [[level.useIntermissionPointsOnWaveSpawn]]() == 1)
			{
				spawnpoint = spawnlogic::getRandomIntermissionPoint();
				if(isdefined(spawnpoint))
				{
					spawnOrigin = spawnpoint.origin;
					spawnAngles = spawnpoint.angles;
				}
			}
			self thread respawn_asSpectator(spawnOrigin, spawnAngles);
		}
		spawnedAsSpectator = 1;
		self globallogic_utils::waitForTimeOrNotify(timeUntilSpawn, "force_spawn");
		self notify("stop_wait_safe_spawn_button");
	}
	waveBased = level.waveRespawnDelay > 0;
	if(!level.playerForceRespawn && self.hasSpawned && !waveBased && !self.wantSafeSpawn && !level.playerQueuedRespawn)
	{
		util::setLowerMessage(game["strings"]["press_to_spawn"]);
		if(!spawnedAsSpectator)
		{
			self thread respawn_asSpectator(self.origin + VectorScale((0, 0, 1), 60), self.angles);
		}
		spawnedAsSpectator = 1;
		self waitRespawnOrSafeSpawnButton();
	}
	self.waitingToSpawn = 0;
	self util::clearLowerMessage();
	self.waveSpawnIndex = undefined;
	self.respawnTimerStartTime = undefined;
	self thread [[level.spawnPlayer]]();
}

/*
	Name: waitRespawnOrSafeSpawnButton
	Namespace: globallogic_spawn
	Checksum: 0x1A065C5E
	Offset: 0x2D20
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function waitRespawnOrSafeSpawnButton()
{
	self endon("disconnect");
	self endon("end_respawn");
	while(1)
	{
		if(self useButtonPressed())
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: waitInSpawnQueue
	Namespace: globallogic_spawn
	Checksum: 0xBB0D37E4
	Offset: 0x2D70
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function waitInSpawnQueue()
{
	self endon("disconnect");
	self endon("end_respawn");
	if(!level.inGracePeriod && !level.useStartSpawns)
	{
		currentorigin = self.origin;
		currentangles = self.angles;
		self thread [[level.spawnSpectator]](currentorigin + VectorScale((0, 0, 1), 60), currentangles);
		self waittill("queue_respawn");
	}
}

/*
	Name: setThirdPerson
	Namespace: globallogic_spawn
	Checksum: 0x63226B07
	Offset: 0x2E08
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function setThirdPerson(value)
{
	if(!level.console)
	{
		return;
	}
	if(!isdefined(self.spectatingThirdPerson) || value != self.spectatingThirdPerson)
	{
		self.spectatingThirdPerson = value;
		if(value)
		{
			self SetClientThirdPerson(1);
			self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
		}
		else
		{
			self SetClientThirdPerson(0);
			self setDepthOfField(0, 0, 512, 4000, 4, 0);
		}
		self resetFov();
	}
}

/*
	Name: setSpawnVariables
	Namespace: globallogic_spawn
	Checksum: 0xBE93185A
	Offset: 0x2F00
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function setSpawnVariables()
{
	resetTimeout();
	self StopShellshock();
	self StopRumble("damage_heavy");
}

