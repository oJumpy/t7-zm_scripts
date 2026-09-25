#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_defaults;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hud_message;
#using scripts\zm\gametypes\_spawning;
#using scripts\zm\gametypes\_weapons;

#namespace zm_gametype;

/*
	Name: main
	Namespace: zm_gametype
	Checksum: 0x783FA47F
	Offset: 0xAF0
	Size: 0x653
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	GlobalLogic_SetupDefault_ZombieCallbacks();
	menu_init();
	util::registerRoundLimit(1, 1);
	util::registerTimeLimit(0, 0);
	util::registerScoreLimit(0, 0);
	util::registerRoundWinLimit(0, 0);
	util::registerNumLives(1, 1);
	weapons::registerGrenadeLauncherDudDvar(level.gametype, 10, 0, 1440);
	weapons::registerThrownGrenadeDudDvar(level.gametype, 0, 0, 1440);
	weapons::registerKillstreakDelay(level.gametype, 0, 0, 1440);
	globallogic::registerFriendlyFireDelay(level.gametype, 15, 0, 1440);
	level.takeLivesOnDeath = 1;
	level.teambased = 1;
	level.disablePrematchMessages = 1;
	level.disableMomentum = 1;
	level.overrideTeamScore = 0;
	level.overridePlayerScore = 0;
	level.displayHalftimeText = 0;
	level.displayRoundEndText = 0;
	level.allowAnnouncer = 0;
	level.endGameOnScoreLimit = 0;
	level.endGameOnTimeLimit = 0;
	level.resetPlayerScoreEveryRound = 1;
	level.doPrematch = 0;
	level.noPersistence = 1;
	level.cumulativeRoundScores = 1;
	level.forceAutoAssign = 1;
	level.dontShowEndReason = 1;
	level.forceAllAllies = 1;
	level.allow_teamchange = 0;
	SetDvar("scr_disable_team_selection", 1);
	SetDvar("scr_disable_weapondrop", 1);
	level.onStartGameType = &onStartGameType;
	level.onSpawnPlayer = &globallogic::blank;
	level.onSpawnPlayerUnified = &onSpawnPlayerUnified;
	level.onRoundEndGame = &onRoundEndGame;
	level.playerMaySpawn = &maySpawn;
	zm_utility::set_game_var("ZM_roundLimit", 1);
	zm_utility::set_game_var("ZM_scoreLimit", 1);
	zm_utility::set_game_var("_team1_num", 0);
	zm_utility::set_game_var("_team2_num", 0);
	map_name = level.script;
	mode = GetDvarString("ui_gametype");
	if(!isdefined(mode) || mode == "" && isdefined(level.default_game_mode))
	{
		mode = level.default_game_mode;
	}
	zm_utility::set_gamemode_var_once("mode", mode);
	zm_utility::set_game_var_once("side_selection", 1);
	location = level.default_start_location;
	zm_utility::set_gamemode_var_once("location", location);
	zm_utility::set_gamemode_var_once("randomize_mode", GetDvarInt("zm_rand_mode"));
	zm_utility::set_gamemode_var_once("randomize_location", GetDvarInt("zm_rand_loc"));
	zm_utility::set_gamemode_var_once("team_1_score", 0);
	zm_utility::set_gamemode_var_once("team_2_score", 0);
	zm_utility::set_gamemode_var_once("current_round", 0);
	zm_utility::set_gamemode_var_once("rules_read", 0);
	zm_utility::set_game_var_once("switchedsides", 0);
	gametype = GetDvarString("ui_gametype");
	game["dialog"]["gametype"] = gametype + "_start";
	game["dialog"]["gametype_hardcore"] = gametype + "_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	zm_utility::set_gamemode_var("pre_init_zombie_spawn_func", undefined);
	zm_utility::set_gamemode_var("post_init_zombie_spawn_func", undefined);
	zm_utility::set_gamemode_var("match_end_notify", undefined);
	zm_utility::set_gamemode_var("match_end_func", undefined);
	setscoreboardcolumns("score", "kills", "downs", "revives", "headshots");
	callback::on_connect(&onPlayerConnect_check_for_hotjoin);
}

/*
	Name: GlobalLogic_SetupDefault_ZombieCallbacks
	Namespace: zm_gametype
	Checksum: 0x9F68562F
	Offset: 0x1150
	Size: 0x4D3
	Parameters: 0
	Flags: None
*/
function GlobalLogic_SetupDefault_ZombieCallbacks()
{
	level.spawnPlayer = &globallogic_spawn::spawnPlayer;
	level.spawnPlayerPrediction = &globallogic_spawn::spawnPlayerPrediction;
	level.spawnClient = &globallogic_spawn::spawnClient;
	level.spawnSpectator = &globallogic_spawn::spawnSpectator;
	level.spawnIntermission = &globallogic_spawn::spawnIntermission;
	level.scoreOnGivePlayerScore = &globallogic_score::givePlayerScore;
	level.onPlayerScore = &globallogic::blank;
	level.onTeamScore = &globallogic::blank;
	level.waveSpawnTimer = &globallogic::waveSpawnTimer;
	level.onSpawnPlayer = &globallogic::blank;
	level.onSpawnPlayerUnified = &globallogic::blank;
	level.onSpawnSpectator = &onSpawnSpectator;
	level.onSpawnIntermission = &onSpawnIntermission;
	level.onRespawnDelay = &globallogic::blank;
	level.onForfeit = &globallogic::blank;
	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;
	level.onDeadEvent = &onDeadEvent;
	level.onOneLeftEvent = &globallogic::blank;
	level.giveTeamScore = &globallogic::blank;
	level.getTimePassed = &globallogic_utils::getTimePassed;
	level.getTimeLimit = &globallogic_defaults::default_getTimeLimit;
	level.getTeamKillPenalty = &globallogic::blank;
	level.getTeamKillScore = &globallogic::blank;
	level.isKillBoosting = &globallogic::blank;
	level._setTeamScore = &globallogic_score::_setTeamScore;
	level._setPlayerScore = &globallogic::blank;
	level._getTeamScore = &globallogic::blank;
	level._getPlayerScore = &globallogic::blank;
	level.onPrecacheGameType = &globallogic::blank;
	level.onStartGameType = &globallogic::blank;
	level.onPlayerConnect = &globallogic::blank;
	level.onPlayerDisconnect = &onPlayerDisconnect;
	level.onPlayerDamage = &globallogic::blank;
	level.onPlayerKilled = &globallogic::blank;
	level.onPlayerKilledExtraUnthreadedCBs = [];
	level.onTeamOutcomeNotify = &hud_message::teamOutcomeNotifyZombie;
	level.onOutcomeNotify = &globallogic::blank;
	level.onTeamWagerOutcomeNotify = &globallogic::blank;
	level.onWagerOutcomeNotify = &globallogic::blank;
	level.onEndGame = &onEndGame;
	level.onRoundEndGame = &globallogic::blank;
	level.onMedalAwarded = &globallogic::blank;
	level.dogManagerOnGetDogs = &globallogic::blank;
	level.autoassign = &globallogic_ui::menuAutoAssign;
	level.Spectator = &globallogic_ui::menuSpectator;
	level.curClass = &globallogic_ui::menuClass;
	level.allies = &menuAlliesZombies;
	level.teamMenu = &globallogic_ui::menuTeam;
	level.callbackActorKilled = &globallogic::blank;
	level.callbackVehicleDamage = &globallogic::blank;
	level.callbackVehicleKilled = &globallogic::blank;
}

/*
	Name: do_game_mode_shellshock
	Namespace: zm_gametype
	Checksum: 0xE2FEFFD6
	Offset: 0x1630
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function do_game_mode_shellshock()
{
	self endon("disconnect");
	self._being_shellshocked = 1;
	self shellshock("grief_stab_zm", 0.75);
	wait(0.75);
	self._being_shellshocked = 0;
}

/*
	Name: canPlayerSuicide
	Namespace: zm_gametype
	Checksum: 0x19B751C5
	Offset: 0x1690
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function canPlayerSuicide()
{
	return 0;
}

/*
	Name: onPlayerDisconnect
	Namespace: zm_gametype
	Checksum: 0xF848057E
	Offset: 0x16A0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function onPlayerDisconnect()
{
	if(isdefined(level.game_mode_custom_onPlayerDisconnect))
	{
		level [[level.game_mode_custom_onPlayerDisconnect]](self);
	}
	if(isdefined(level.check_quickrevive_hotjoin))
	{
		level thread [[level.check_quickrevive_hotjoin]]();
	}
	self zm_laststand::add_weighted_down();
	level zm::checkForAllDead(self);
}

/*
	Name: onDeadEvent
	Namespace: zm_gametype
	Checksum: 0xED8BF7D9
	Offset: 0x1718
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function onDeadEvent(team)
{
	thread globallogic::endGame(level.zombie_team, "");
}

/*
	Name: onSpawnIntermission
	Namespace: zm_gametype
	Checksum: 0xEBE2A04
	Offset: 0x1750
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function onSpawnIntermission()
{
	spawnPointName = "info_intermission";
	Spawnpoints = GetEntArray(spawnPointName, "classname");
	if(Spawnpoints.size < 1)
	{
		/#
			println("Dev Block strings are not supported" + spawnPointName + "Dev Block strings are not supported");
		#/
		return;
	}
	spawnpoint = Spawnpoints[RandomInt(Spawnpoints.size)];
	if(isdefined(spawnpoint))
	{
		self spawn(spawnpoint.origin, spawnpoint.angles);
	}
}

/*
	Name: onSpawnSpectator
	Namespace: zm_gametype
	Checksum: 0x61458BE8
	Offset: 0x1838
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function onSpawnSpectator(origin, angles)
{
}

/*
	Name: maySpawn
	Namespace: zm_gametype
	Checksum: 0x28F4AD58
	Offset: 0x1858
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function maySpawn()
{
	if(isdefined(level.customMaySpawnLogic))
	{
		return self [[level.customMaySpawnLogic]]();
	}
	if(self.pers["lives"] == 0)
	{
		level notify("player_eliminated");
		self notify("player_eliminated");
		return 0;
	}
	return 1;
}

/*
	Name: onStartGameType
	Namespace: zm_gametype
	Checksum: 0x1A23C67B
	Offset: 0x18C0
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function onStartGameType()
{
	setClientNameMode("auto_change");
	level.spawnMins = (0, 0, 0);
	level.spawnMaxs = (0, 0, 0);
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnMins = math::expand_mins(level.spawnMins, struct.origin);
		level.spawnMaxs = math::expand_maxs(level.spawnMaxs, struct.origin);
	}
	level.mapCenter = math::find_box_center(level.spawnMins, level.spawnMaxs);
	setMapCenter(level.mapCenter);
	level.displayRoundEndText = 0;
	Spawning::create_map_placed_influencers();
	if(!util::isOneRound())
	{
		level.displayRoundEndText = 1;
		if(level.scoreRoundWinBased)
		{
			globallogic_score::resetTeamScores();
		}
	}
}

/*
	Name: onSpawnPlayerUnified
	Namespace: zm_gametype
	Checksum: 0xA9D6F9D0
	Offset: 0x1A98
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function onSpawnPlayerUnified()
{
	onSpawnPlayer(0);
}

/*
	Name: onFindValidSpawnPoint
	Namespace: zm_gametype
	Checksum: 0xA136A1F9
	Offset: 0x1AC0
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function onFindValidSpawnPoint()
{
	/#
		println("Dev Block strings are not supported");
	#/
	if(level flag::get("begin_spawning"))
	{
		spawnpoint = zm::check_for_valid_spawn_near_team(self, 1);
		/#
			if(!isdefined(spawnpoint))
			{
				println("Dev Block strings are not supported");
			}
		#/
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
	return spawnpoint;
}

/*
	Name: onSpawnPlayer
	Namespace: zm_gametype
	Checksum: 0xACBE64EA
	Offset: 0x1DE8
	Size: 0x373
	Parameters: 1
	Flags: None
*/
function onSpawnPlayer(predictedSpawn)
{
	if(!isdefined(predictedSpawn))
	{
		predictedSpawn = 0;
	}
	PixBeginEvent("ZSURVIVAL:onSpawnPlayer");
	self.usingObj = undefined;
	self.is_zombie = 0;
	zm::updatePlayerNum(self);
	if(isdefined(level.custom_spawnPlayer) && (isdefined(self.player_initialized) && self.player_initialized))
	{
		self [[level.custom_spawnPlayer]]();
		return;
	}
	if(isdefined(level.customSpawnLogic))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		spawnpoint = self [[level.customSpawnLogic]](predictedSpawn);
		if(predictedSpawn)
		{
			return;
		}
	}
	else
	{
		println("Dev Block strings are not supported");
		spawnpoint = self onFindValidSpawnPoint();
		if(predictedSpawn)
		{
			self predictSpawnPoint(spawnpoint.origin, spawnpoint.angles);
			return;
		}
		else
		{
			self spawn(spawnpoint.origin, spawnpoint.angles, "zsurvival");
		}
	}
	/#
	#/
	self.entity_num = self GetEntityNumber();
	self thread zm::onPlayerSpawned();
	self thread zm::player_revive_monitor();
	self FreezeControls(1);
	self.spectator_respawn = spawnpoint;
	self.score = self globallogic_score::getPersStat("score");
	self.pers["participation"] = 0;
	/#
		if(GetDvarInt("Dev Block strings are not supported") >= 1)
		{
			self.score = 100000;
		}
	#/
	self.score_total = self.score;
	self.old_score = self.score;
	self.player_initialized = 0;
	self.zombification_time = 0;
	self.enableText = 1;
	self thread zm_blockers::rebuild_barrier_reward_reset();
	if(!(isdefined(level.host_ended_game) && level.host_ended_game))
	{
		self util::freeze_player_controls(0);
		self enableWeapons();
	}
	if(isdefined(level.game_mode_spawn_player_logic))
	{
		spawn_in_spectate = [[level.game_mode_spawn_player_logic]]();
		if(spawn_in_spectate)
		{
			self util::delay(0.05, undefined, &zm::spawnSpectator);
		}
	}
	PixEndEvent();
}

/*
	Name: get_player_spawns_for_gametype
	Namespace: zm_gametype
	Checksum: 0x42F8595A
	Offset: 0x2168
	Size: 0x21D
	Parameters: 0
	Flags: None
*/
function get_player_spawns_for_gametype()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	if(location == "default" || location == "" && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}
	match_string = level.scr_zm_ui_gametype + "_" + location;
	player_spawns = [];
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		if(isdefined(struct.script_string))
		{
			tokens = StrTok(struct.script_string, " ");
			foreach(token in tokens)
			{
				if(token == match_string)
				{
					player_spawns[player_spawns.size] = struct;
				}
			}
			continue;
		}
		player_spawns[player_spawns.size] = struct;
	}
	return player_spawns;
}

/*
	Name: onEndGame
	Namespace: zm_gametype
	Checksum: 0x296DDE4C
	Offset: 0x2390
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function onEndGame(winningTeam)
{
}

/*
	Name: onRoundEndGame
	Namespace: zm_gametype
	Checksum: 0x119131E8
	Offset: 0x23A8
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function onRoundEndGame(roundWinner)
{
	if(game["roundswon"]["allies"] == game["roundswon"]["axis"])
	{
		winner = "tie";
	}
	else if(game["roundswon"]["axis"] > game["roundswon"]["allies"])
	{
		winner = "axis";
	}
	else
	{
		winner = "allies";
	}
	return winner;
}

/*
	Name: menu_init
	Namespace: zm_gametype
	Checksum: 0x8EBF43F3
	Offset: 0x2458
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function menu_init()
{
	game["menu_team"] = "ChangeTeam";
	game["menu_changeclass_allies"] = "ChooseClass_InGame";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_changeclass_axis"] = "ChooseClass_InGame";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_start_menu"] = "StartMenu_Main";
	game["menu_changeclass"] = "ChooseClass_InGame";
	game["menu_changeclass_offline"] = "ChooseClass_InGame";
	game["menu_wager_side_bet"] = "sidebet";
	game["menu_wager_side_bet_player"] = "sidebet_player";
	game["menu_changeclass_wager"] = "changeclass_wager";
	game["menu_changeclass_custom"] = "changeclass_custom";
	game["menu_changeclass_barebones"] = "changeclass_barebones";
	game["menu_controls"] = "ingame_controls";
	game["menu_options"] = "ingame_options";
	game["menu_leavegame"] = "popup_leavegame";
	game["menu_restartgamepopup"] = "restartgamepopup";
	level thread menu_onPlayerConnect();
}

/*
	Name: menu_onPlayerConnect
	Namespace: zm_gametype
	Checksum: 0xB7A889FB
	Offset: 0x25E8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function menu_onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread menu_onMenuResponse();
	}
}

/*
	Name: menu_onMenuResponse
	Namespace: zm_gametype
	Checksum: 0x1A981B2D
	Offset: 0x2628
	Size: 0x75B
	Parameters: 0
	Flags: None
*/
function menu_onMenuResponse()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		if(response == "back")
		{
			self closeInGameMenu();
			if(level.console)
			{
				if(menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"])
				{
					if(self.pers["team"] == "allies")
					{
						self openMenu(game["menu_start_menu"]);
					}
					if(self.pers["team"] == "axis")
					{
						self openMenu(game["menu_start_menu"]);
					}
				}
			}
			continue;
		}
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
		if(response == "changeclass_marines")
		{
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_allies"]);
			continue;
		}
		if(response == "changeclass_opfor")
		{
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_axis"]);
			continue;
		}
		if(response == "changeclass_wager")
		{
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_wager"]);
			continue;
		}
		if(response == "changeclass_custom")
		{
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_custom"]);
			continue;
		}
		if(response == "changeclass_barebones")
		{
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_barebones"]);
			continue;
		}
		if(response == "changeclass_marines_splitscreen")
		{
			self openMenu("changeclass_marines_splitscreen");
		}
		if(response == "changeclass_opfor_splitscreen")
		{
			self openMenu("changeclass_opfor_splitscreen");
		}
		if(response == "endgame")
		{
			if(self IsSplitscreen())
			{
				level.skipVote = 1;
				if(!(isdefined(level.gameEnded) && level.gameEnded))
				{
					self zm_laststand::add_weighted_down();
					self zm_stats::increment_client_stat("deaths");
					self zm_stats::increment_player_stat("deaths");
					self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
					level.host_ended_game = 1;
					zm_game_module::freeze_players(1);
					level notify("end_game");
				}
			}
			continue;
		}
		if(response == "restart_level_zm")
		{
			self zm_laststand::add_weighted_down();
			self zm_stats::increment_client_stat("deaths");
			self zm_stats::increment_player_stat("deaths");
			self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
			missionfailed();
		}
		if(response == "killserverpc")
		{
			level thread globallogic::killserverPc();
			continue;
		}
		if(response == "endround")
		{
			if(!(isdefined(level.gameEnded) && level.gameEnded))
			{
				self globallogic::gameHistoryPlayerQuit();
				self zm_laststand::add_weighted_down();
				self closeInGameMenu();
				level.host_ended_game = 1;
				zm_game_module::freeze_players(1);
				level notify("end_game");
			}
			else
			{
				self closeInGameMenu();
				self iprintln(&"MP_HOST_ENDGAME_RESPONSE");
			}
			continue;
		}
		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
				case "allies":
				{
					self [[level.allies]]();
					break;
				}
				case "axis":
				{
					self [[level.teamMenu]](response);
					break;
				}
				case "autoassign":
				{
					self [[level.autoassign]](1);
					break;
				}
				case "spectator":
				{
					self [[level.Spectator]]();
					break;
				}
			}
			continue;
		}
		if(menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_changeclass_wager"] || menu == game["menu_changeclass_custom"] || menu == game["menu_changeclass_barebones"])
		{
			self closeInGameMenu();
			self.selectedClass = 1;
			self [[level.curClass]](response);
		}
	}
}

/*
	Name: menuAlliesZombies
	Namespace: zm_gametype
	Checksum: 0x7E41310C
	Offset: 0x2D90
	Size: 0x1F9
	Parameters: 0
	Flags: None
*/
function menuAlliesZombies()
{
	self globallogic_ui::closeMenus();
	if(!level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat))
	{
		return;
	}
	if(self.pers["team"] != "allies")
	{
		if(level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat))
		{
			self.hasSpawned = 0;
		}
		if(self.sessionstate == "playing")
		{
			self.switching_teams = 1;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.curClass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self globallogic_ui::updateObjectiveText();
		self.sessionteam = "allies";
		self SetClientScriptMainMenu(game["menu_start_menu"]);
		self notify("joined_team");
		level notify("joined_team");
		self callback::callback("hash_95a6c4c0");
		self notify("end_respawn");
	}
}

/*
	Name: custom_spawn_init_func
	Namespace: zm_gametype
	Checksum: 0x6395C280
	Offset: 0x2F98
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function custom_spawn_init_func()
{
	Array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	Array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, level._zombies_round_spawn_failsafe);
}

/*
	Name: init
	Namespace: zm_gametype
	Checksum: 0x9CDD9EA3
	Offset: 0x3010
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("pregame");
	level flag::set("pregame");
	level thread onPlayerConnect();
}

/*
	Name: onPlayerConnect
	Namespace: zm_gametype
	Checksum: 0x4B694B63
	Offset: 0x3078
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
		if(isdefined(level.game_module_onPlayerConnect))
		{
			player [[level.game_module_onPlayerConnect]]();
		}
	}
}

/*
	Name: onPlayerSpawned
	Namespace: zm_gametype
	Checksum: 0x6B82615A
	Offset: 0x30D8
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	level endon("end_game");
	self endon("disconnect");
	for(;;)
	{
		self util::waittill_either("spawned_player", "fake_spawned_player");
		if(isdefined(level.match_is_ending) && level.match_is_ending)
		{
			return;
		}
		if(self laststand::player_is_in_laststand())
		{
			self thread zm_laststand::auto_revive(self);
		}
		if(isdefined(level.custom_player_fake_death_cleanup))
		{
			self [[level.custom_player_fake_death_cleanup]]();
		}
		self SetStance("stand");
		self.zmbDialogQueue = [];
		self.zmbDialogActive = 0;
		self.zmbDialogGroups = [];
		self.zmbDialogGroup = "";
		self TakeAllWeapons();
		if(isdefined(level.giveCustomCharacters))
		{
			self [[level.giveCustomCharacters]]();
		}
		self GiveWeapon(level.weaponBaseMelee);
		if(isdefined(level.onPlayerSpawned_restore_previous_weapons) && (isdefined(level.isresetting_grief) && level.isresetting_grief))
		{
			weapons_restored = self [[level.onPlayerSpawned_restore_previous_weapons]]();
		}
		if(!(isdefined(weapons_restored) && weapons_restored))
		{
			self zm_utility::give_start_weapon(1);
		}
		weapons_restored = 0;
		if(isdefined(level._team_loadout))
		{
			self GiveWeapon(level._team_loadout);
			self SwitchToWeapon(level._team_loadout);
		}
		if(isdefined(level.gamemode_post_spawn_logic))
		{
			self [[level.gamemode_post_spawn_logic]]();
		}
	}
}

/*
	Name: onPlayerConnect_check_for_hotjoin
	Namespace: zm_gametype
	Checksum: 0x3BB5EE96
	Offset: 0x32F8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function onPlayerConnect_check_for_hotjoin()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			return;
		}
	#/
	map_logic_exists = level flag::exists("start_zombie_round_logic");
	map_logic_started = level flag::get("start_zombie_round_logic");
	if(map_logic_exists && map_logic_started)
	{
		self thread player_hotjoin();
	}
}

/*
	Name: player_hotjoin
	Namespace: zm_gametype
	Checksum: 0xB8D9C228
	Offset: 0x33A8
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function player_hotjoin()
{
	self endon("disconnect");
	self InitialBlack();
	self.rebuild_barrier_reward = 1;
	self.is_hotjoining = 1;
	wait(0.5);
	if(isdefined(level.giveCustomCharacters))
	{
		self [[level.giveCustomCharacters]]();
	}
	self zm::spawnSpectator();
	music::setmusicstate("none");
	self.is_hotjoining = 0;
	self.is_hotjoin = 1;
	self thread wait_fade_in();
	if(isdefined(level.intermission) && level.intermission || (isdefined(level.host_ended_game) && level.host_ended_game))
	{
		self SetClientThirdPerson(0);
		self resetFov();
		self.health = 100;
		self thread [[level.custom_intermission]]();
	}
}

/*
	Name: wait_fade_in
	Namespace: zm_gametype
	Checksum: 0xB4B3DEA8
	Offset: 0x34E8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function wait_fade_in()
{
	self util::streamer_wait(undefined, 0, 30);
	if(isdefined(level.hotjoin_extra_blackscreen_time))
	{
		wait(level.hotjoin_extra_blackscreen_time);
	}
	initialBlackEnd();
}

/*
	Name: InitialBlack
	Namespace: zm_gametype
	Checksum: 0xCC42AF6B
	Offset: 0x3540
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function InitialBlack()
{
	self CloseMenu("InitialBlack");
	self openMenu("InitialBlack");
}

/*
	Name: initialBlackEnd
	Namespace: zm_gametype
	Checksum: 0xBFDBF3DE
	Offset: 0x3590
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function initialBlackEnd()
{
	self CloseMenu("InitialBlack");
}

