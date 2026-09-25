#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons_shared;
#using scripts\zm\_challenges;
#using scripts\zm\_util;
#using scripts\zm\_zm_stats;
#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hostmigration;
#using scripts\zm\gametypes\_spawning;
#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_spectating;
#using scripts\zm\gametypes\_weapons;

#namespace globallogic_player;

/*
	Name: freezePlayerForRoundEnd
	Namespace: globallogic_player
	Checksum: 0xE39323DC
	Offset: 0xED8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function freezePlayerForRoundEnd()
{
	self util::clearLowerMessage();
	self closeInGameMenu();
	self util::freeze_player_controls(1);
}

/*
	Name: Callback_PlayerConnect
	Namespace: globallogic_player
	Checksum: 0x3035529F
	Offset: 0xF30
	Size: 0xEDB
	Parameters: 0
	Flags: None
*/
function Callback_PlayerConnect()
{
	thread notifyConnecting();
	self.statusicon = "hud_status_connecting";
	self waittill("begin");
	if(isdefined(level.reset_clientdvars))
	{
		self [[level.reset_clientdvars]]();
	}
	waittillframeend;
	self.statusicon = "";
	self.guid = self getGuid();
	profilelog_begintiming(4, "ship");
	level notify("connected", self);
	if(self IsHost())
	{
		self thread globallogic::listenForGameEnd();
	}
	if(!level.Splitscreen && !isdefined(self.pers["score"]))
	{
		iprintln(&"MP_CONNECTED", self);
	}
	if(!isdefined(self.pers["score"]))
	{
		self thread zm_stats::adjustRecentStats();
	}
	if(GameModeIsMode(0) && !isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::GetCurrentGameMode();
		self globallogic::IncrementMatchCompletionStat(gamemode, "played", "started");
		if(!isdefined(self.pers["matchesHostedStatsTracked"]) && self IsLocalToHost())
		{
			self globallogic::IncrementMatchCompletionStat(gamemode, "hosted", "started");
			self.pers["matchesHostedStatsTracked"] = 1;
		}
		self.pers["matchesPlayedStatsTracked"] = 1;
		self thread zm_stats::uploadStatsSoon();
	}
	lpselfnum = self GetEntityNumber();
	lpGuid = self getGuid();
	lpXuid = self getXuid(1);
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "
");
	bbPrint("global_joins", "name %s client %s xuid %s", self.name, lpselfnum, lpXuid);
	if(!SessionModeIsZombiesGame())
	{
		self setClientUIVisibilityFlag("hud_visible", 1);
		self setClientUIVisibilityFlag("weapon_hud_visible", 1);
	}
	if(level.forceradar == 1)
	{
		self.pers["hasRadar"] = 1;
		self.hasSpyplane = 1;
		level.activeUAVs[self GetEntityNumber()] = 1;
	}
	if(level.forceradar == 2)
	{
		self setClientUIVisibilityFlag("g_compassShowEnemies", level.forceradar);
	}
	else
	{
		self setClientUIVisibilityFlag("g_compassShowEnemies", 0);
	}
	self SetClientPlayerSprintTime(level.playerSprintTime);
	self SetClientNumLives(level.numLives);
	if(level.hardcoreMode)
	{
		self SetClientDrawTalk(3);
	}
	self [[level.player_stats_init]]();
	self.killedPlayersCurrent = [];
	if(!isdefined(self.pers["best_kill_streak"]))
	{
		self.pers["killed_players"] = [];
		self.pers["killed_by"] = [];
		self.pers["nemesis_tracking"] = [];
		self.pers["artillery_kills"] = 0;
		self.pers["dog_kills"] = 0;
		self.pers["nemesis_name"] = "";
		self.pers["nemesis_rank"] = 0;
		self.pers["nemesis_rankIcon"] = 0;
		self.pers["nemesis_xp"] = 0;
		self.pers["nemesis_xuid"] = "";
		self.pers["best_kill_streak"] = 0;
	}
	if(!isdefined(self.pers["music"]))
	{
		self.pers["music"] = spawnstruct();
		self.pers["music"].spawn = 0;
		self.pers["music"].inque = 0;
		self.pers["music"].currentState = "SILENT";
		self.pers["music"].previousState = "SILENT";
		self.pers["music"].nextstate = "UNDERSCORE";
		self.pers["music"].returnState = "UNDERSCORE";
	}
	self.leaderDialogQueue = [];
	self.leaderDialogActive = 0;
	self.leaderDialogGroups = [];
	self.currentLeaderDialogGroup = "";
	self.currentLeaderDialog = "";
	self.currentLeaderDialogTime = 0;
	if(!isdefined(self.pers["cur_kill_streak"]))
	{
		self.pers["cur_kill_streak"] = 0;
	}
	if(!isdefined(self.pers["cur_total_kill_streak"]))
	{
		self.pers["cur_total_kill_streak"] = 0;
		self setplayercurrentstreak(0);
	}
	if(!isdefined(self.pers["totalKillstreakCount"]))
	{
		self.pers["totalKillstreakCount"] = 0;
	}
	if(!isdefined(self.pers["killstreaksEarnedThisKillstreak"]))
	{
		self.pers["killstreaksEarnedThisKillstreak"] = 0;
	}
	if(isdefined(level.usingScoreStreaks) && level.usingScoreStreaks && !isdefined(self.pers["killstreak_quantity"]))
	{
		self.pers["killstreak_quantity"] = [];
	}
	if(isdefined(level.usingScoreStreaks) && level.usingScoreStreaks && !isdefined(self.pers["held_killstreak_ammo_count"]))
	{
		self.pers["held_killstreak_ammo_count"] = [];
	}
	self.lastKillTime = 0;
	self.cur_death_streak = 0;
	self disabledeathstreak();
	self.death_streak = 0;
	self.kill_streak = 0;
	self.gametype_kill_streak = 0;
	self.spawnQueueIndex = -1;
	self.deathtime = 0;
	self.lastGrenadeSuicideTime = -1;
	self.teamkillsThisRound = 0;
	if(!isdefined(level.livesDoNotReset) || !level.livesDoNotReset || !isdefined(self.pers["lives"]))
	{
		self.pers["lives"] = level.numLives;
	}
	if(!level.teambased)
	{
		self.pers["team"] = undefined;
	}
	self.hasSpawned = 0;
	self.waitingToSpawn = 0;
	self.wantSafeSpawn = 0;
	self.deathCount = 0;
	self.wasAliveAtMatchStart = 0;
	level.players[level.players.size] = self;
	if(level.Splitscreen)
	{
		SetDvar("splitscreen_playerNum", level.players.size);
	}
	if(game["state"] == "postgame")
	{
		self.pers["needteam"] = 1;
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionteam = "spectator";
		self setClientUIVisibilityFlag("hud_visible", 0);
		self [[level.spawnIntermission]]();
		self closeInGameMenu();
		profilelog_endtiming(4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame());
		return;
	}
	level endon("game_ended");
	if(isdefined(level.hostMigrationTimer))
	{
		self thread hostmigration::hostMigrationTimerThink();
	}
	if(level.oldschool)
	{
		self.pers["class"] = undefined;
		self.curClass = self.pers["class"];
	}
	if(isdefined(self.pers["team"]))
	{
		self.team = self.pers["team"];
	}
	if(isdefined(self.pers["class"]))
	{
		self.curClass = self.pers["class"];
	}
	if(!isdefined(self.pers["team"]) || isdefined(self.pers["needteam"]))
	{
		self.pers["needteam"] = undefined;
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionstate = "dead";
		self globallogic_ui::updateObjectiveText();
		[[level.spawnSpectator]]();
		if(level.rankedMatch)
		{
			[[level.autoassign]](0);
			self thread globallogic_spawn::kickIfDontSpawn();
		}
		else
		{
			[[level.autoassign]](0);
		}
		if(self.pers["team"] == "spectator")
		{
			self.sessionteam = "spectator";
			self thread spectate_player_watcher();
		}
		if(level.teambased)
		{
			self.sessionteam = self.pers["team"];
			if(!isalive(self))
			{
				self.statusicon = "hud_status_dead";
			}
			self thread spectating::setSpectatePermissions();
		}
	}
	else if(self.pers["team"] == "spectator")
	{
		self SetClientScriptMainMenu(game["menu_start_menu"]);
		[[level.spawnSpectator]]();
		self.sessionteam = "spectator";
		self.sessionstate = "spectator";
		self thread spectate_player_watcher();
	}
	else
	{
		self.sessionteam = self.pers["team"];
		self.sessionstate = "dead";
		self globallogic_ui::updateObjectiveText();
		[[level.spawnSpectator]]();
		if(globallogic_utils::isValidClass(self.pers["class"]))
		{
			self thread [[level.spawnClient]]();
		}
		else
		{
			self globallogic_ui::showMainMenuForTeam();
		}
		self thread spectating::setSpectatePermissions();
	}
	if(self.sessionteam != "spectator")
	{
		self thread Spawning::onSpawnPlayer_Unified(1);
	}
	profilelog_endtiming(4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame());
}

/*
	Name: spectate_player_watcher
	Namespace: globallogic_player
	Checksum: 0x4944200E
	Offset: 0x1E18
	Size: 0x263
	Parameters: 0
	Flags: None
*/
function spectate_player_watcher()
{
	self endon("disconnect");
	self.watchingActiveClient = 1;
	self.waitingForPlayersText = undefined;
	while(1)
	{
		if(self.pers["team"] != "spectator" || level.gameEnded)
		{
			self hud_message::clearShoutcasterWaitingMessage();
			self FreezeControls(0);
			self.watchingActiveClient = 0;
			break;
		}
		else if(!level.Splitscreen && !level.hardcoreMode && GetDvarInt("scr_showperksonspawn") == 1 && game["state"] != "postgame" && !isdefined(self.perkHudelem))
		{
			if(level.perksEnabled == 1)
			{
				self hud::showPerks();
			}
		}
		count = 0;
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i].team != "spectator")
			{
				count++;
				break;
			}
		}
		if(count > 0)
		{
			if(!self.watchingActiveClient)
			{
				self hud_message::clearShoutcasterWaitingMessage();
				self FreezeControls(0);
				/#
					println("Dev Block strings are not supported");
				#/
			}
			self.watchingActiveClient = 1;
		}
		else if(self.watchingActiveClient)
		{
			[[level.onSpawnSpectator]]();
			self FreezeControls(1);
			self hud_message::setShoutcasterWaitingMessage();
		}
		self.watchingActiveClient = 0;
		wait(0.5);
	}
}

/*
	Name: Callback_PlayerMigrated
	Namespace: globallogic_player
	Checksum: 0x25A445BA
	Offset: 0x2088
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function Callback_PlayerMigrated()
{
	/#
		println("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + GetTime());
	#/
	if(isdefined(self.connected) && self.connected)
	{
		self globallogic_ui::updateObjectiveText();
	}
	self thread inform_clientvm_of_migration();
	level.hostMigrationReturnedPlayerCount++;
	if(level.hostMigrationReturnedPlayerCount >= level.players.size * 2 / 3)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		level notify("hostmigration_enoughplayers");
	}
}

/*
	Name: inform_clientvm_of_migration
	Namespace: globallogic_player
	Checksum: 0xE19D8071
	Offset: 0x2168
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function inform_clientvm_of_migration()
{
	self endon("disconnect");
	wait(1);
	self util::clientNotify("hmo");
}

/*
	Name: ArrayToString
	Namespace: globallogic_player
	Checksum: 0xAD67CACB
	Offset: 0x21A8
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function ArrayToString(inputArray)
{
	targetString = "";
	for(i = 0; i < inputArray.size; i++)
	{
		targetString = targetString + inputArray[i];
		if(i != inputArray.size - 1)
		{
			targetString = targetString + ",";
		}
	}
	return targetString;
}

/*
	Name: recordZMEndGameComScoreEventForPlayer
	Namespace: globallogic_player
	Checksum: 0xA63F1836
	Offset: 0x2240
	Size: 0x563
	Parameters: 2
	Flags: None
*/
function recordZMEndGameComScoreEventForPlayer(player, result)
{
	lpselfnum = player GetEntityNumber();
	lpXuid = player getXuid(1);
	bbPrint("global_leave", "name %s client %s xuid %s", player.name, lpselfnum, lpXuid);
	primaryWeaponName = "";
	primaryWeaponAttachStr = "";
	secondaryWeaponName = "";
	secondaryWeaponAttachStr = "";
	if(isdefined(player.primaryLoadoutWeapon))
	{
		primaryWeaponName = player.primaryLoadoutWeapon.name;
		primaryWeaponAttachStr = ArrayToString(getArrayKeys(player.primaryLoadoutWeapon.attachments));
	}
	if(isdefined(player.secondaryLoadoutWeapon))
	{
		secondaryWeaponName = player.secondaryLoadoutWeapon.name;
		secondaryWeaponAttachStr = ArrayToString(getArrayKeys(player.secondaryLoadoutWeapon.attachments));
	}
	resultStr = result;
	if(isdefined(player.team) && result == player.team)
	{
		resultStr = "win";
	}
	else if(result == "allies" || result == "axis")
	{
		resultStr = "lose";
	}
	timePlayed = game["timepassed"] / 1000;
	RecordComScoreEvent("end_match", "match_id", getDemoFileID(), "game_variant", "zm", "game_mode", level.gametype, "game_playlist", "N/A", "private_match", SessionModeIsPrivate(), "game_map", GetDvarString("mapname"), "player_xuid", player getXuid(1), "player_ip", player getipaddress(), "match_kills", player.kills, "match_deaths", player.deaths, "match_score", player.score, "match_streak", player.pers["best_kill_streak"], "match_captures", player.pers["captures"], "match_defends", player.pers["defends"], "match_headshots", player.pers["headshots"], "match_longshots", player.pers["longshots"], "prestige_max", player.pers["plevel"], "level_max", player.pers["rank"], "match_result", resultStr, "season_pass_owned", player HasSeasonPass(0), "match_hits", player.shotshit, "player_gender", player GetPlayerGenderType(CurrentSessionMode()), "money", player.score, "zombie_waves", level.round_number, "revives", player.pers["revives"], "doors", player.pers["doors_purchased"], "downs", player.pers["downs"], "loadout_primary_weapon", primaryWeaponName, "loadout_secondary_weapon", secondaryWeaponName, "loadout_primary_attachments", primaryWeaponAttachStr, "loadout_secondary_attachments", secondaryWeaponAttachStr, "dlc_owned", player GetDLCAvailable(), "match_duration", timePlayed);
}

/*
	Name: Callback_PlayerDisconnect
	Namespace: globallogic_player
	Checksum: 0x2344FFBB
	Offset: 0x27B0
	Size: 0x52B
	Parameters: 0
	Flags: None
*/
function Callback_PlayerDisconnect()
{
	profilelog_begintiming(5, "ship");
	if(game["state"] != "postgame" && !level.gameEnded)
	{
		gameLength = globallogic::getGameLength();
		self globallogic::bbPlayerMatchEnd(gameLength, "MP_PLAYER_DISCONNECT", 0);
	}
	ArrayRemoveValue(level.players, self);
	if(level.Splitscreen)
	{
		players = level.players;
		if(players.size <= 1)
		{
			level thread globallogic::forceEnd();
		}
		SetDvar("splitscreen_playerNum", players.size);
	}
	if(isdefined(self.score) && isdefined(self.pers["team"]))
	{
		/#
			print("Dev Block strings are not supported" + self.pers["Dev Block strings are not supported"] + "Dev Block strings are not supported" + self.score);
		#/
		level.dropTeam = level.dropTeam + 1;
	}
	[[level.onPlayerDisconnect]]();
	lpselfnum = self GetEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "
");
	recordZMEndGameComScoreEventForPlayer(self, "disconnected");
	for(entry = 0; entry < level.players.size; entry++)
	{
		if(level.players[entry] == self)
		{
			while(entry < level.players.size - 1)
			{
				level.players[entry] = level.players[entry + 1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
	for(entry = 0; entry < level.players.size; entry++)
	{
		if(isdefined(level.players[entry].pers["killed_players"][self.name]))
		{
			level.players[entry].pers["killed_players"][self.name] = undefined;
		}
		if(isdefined(level.players[entry].killedPlayersCurrent[self.name]))
		{
			level.players[entry].killedPlayersCurrent[self.name] = undefined;
		}
		if(isdefined(level.players[entry].pers["killed_by"][self.name]))
		{
			level.players[entry].pers["killed_by"][self.name] = undefined;
		}
		if(isdefined(level.players[entry].pers["nemesis_tracking"][self.name]))
		{
			level.players[entry].pers["nemesis_tracking"][self.name] = undefined;
		}
		if(level.players[entry].pers["nemesis_name"] == self.name)
		{
			level.players[entry] chooseNextBestNemesis();
		}
	}
	if(level.gameEnded)
	{
		self globallogic::removeDisconnectedPlayerFromPlacement();
	}
	level thread globallogic::updateTeamStatus();
	profilelog_endtiming(5, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame());
}

/*
	Name: Callback_PlayerMelee
	Namespace: globallogic_player
	Checksum: 0xA5F27B4B
	Offset: 0x2CE8
	Size: 0xC3
	Parameters: 8
	Flags: None
*/
function Callback_PlayerMelee(eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit, fromBehind)
{
	hit = 1;
	if(level.teambased && self.team == eAttacker.team)
	{
		if(level.friendlyfire == 0)
		{
			hit = 0;
		}
	}
	self finishMeleeHit(eAttacker, weapon, vOrigin, vDir, boneIndex, shieldHit, hit, fromBehind);
}

/*
	Name: chooseNextBestNemesis
	Namespace: globallogic_player
	Checksum: 0xDD76D4A8
	Offset: 0x2DB8
	Size: 0x241
	Parameters: 0
	Flags: None
*/
function chooseNextBestNemesis()
{
	nemesisArray = self.pers["nemesis_tracking"];
	nemesisArrayKeys = getArrayKeys(nemesisArray);
	nemesisAmount = 0;
	nemesisName = "";
	if(nemesisArrayKeys.size > 0)
	{
		for(i = 0; i < nemesisArrayKeys.size; i++)
		{
			nemesisArrayKey = nemesisArrayKeys[i];
			if(nemesisArray[nemesisArrayKey] > nemesisAmount)
			{
				nemesisName = nemesisArrayKey;
				nemesisAmount = nemesisArray[nemesisArrayKey];
			}
		}
	}
	self.pers["nemesis_name"] = nemesisName;
	if(nemesisName != "")
	{
		for(playerIndex = 0; playerIndex < level.players.size; playerIndex++)
		{
			if(level.players[playerIndex].name == nemesisName)
			{
				nemesisPlayer = level.players[playerIndex];
				self.pers["nemesis_rank"] = nemesisPlayer.pers["rank"];
				self.pers["nemesis_rankIcon"] = nemesisPlayer.pers["rankxp"];
				self.pers["nemesis_xp"] = nemesisPlayer.pers["prestige"];
				self.pers["nemesis_xuid"] = nemesisPlayer getXuid();
				break;
			}
		}
	}
	else
	{
		self.pers["nemesis_xuid"] = "";
	}
}

/*
	Name: custom_gamemodes_modified_damage
	Namespace: globallogic_player
	Checksum: 0xD2F7434A
	Offset: 0x3008
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function custom_gamemodes_modified_damage(victim, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc)
{
	if(level.onlineGame && !SessionModeIsPrivate())
	{
		return iDamage;
	}
	if(isdefined(eAttacker) && isdefined(eAttacker.damageModifier))
	{
		iDamage = iDamage * eAttacker.damageModifier;
	}
	if(sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET")
	{
		iDamage = Int(iDamage * level.bulletDamageScalar);
	}
	return iDamage;
}

/*
	Name: figureOutAttacker
	Namespace: globallogic_player
	Checksum: 0x1F90D744
	Offset: 0x3100
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function figureOutAttacker(eAttacker)
{
	if(isdefined(eAttacker))
	{
		if(isai(eAttacker) && isdefined(eAttacker.script_owner))
		{
			team = self.team;
			if(eAttacker.script_owner.team != team)
			{
				eAttacker = eAttacker.script_owner;
			}
		}
		if(eAttacker.classname == "script_vehicle" && isdefined(eAttacker.owner))
		{
			eAttacker = eAttacker.owner;
		}
		else if(eAttacker.classname == "auto_turret" && isdefined(eAttacker.owner))
		{
			eAttacker = eAttacker.owner;
		}
	}
	return eAttacker;
}

/*
	Name: figureOutWeapon
	Namespace: globallogic_player
	Checksum: 0x1B96055E
	Offset: 0x3220
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function figureOutWeapon(weapon, eInflictor)
{
	if(weapon == level.weaponNone && isdefined(eInflictor))
	{
		if(isdefined(eInflictor.targetname) && eInflictor.targetname == "explodable_barrel")
		{
			weapon = GetWeapon("explodable_barrel");
		}
		else if(isdefined(eInflictor.destructible_type) && IsSubStr(eInflictor.destructible_type, "vehicle_"))
		{
			weapon = GetWeapon("destructible_car");
		}
	}
	return weapon;
}

/*
	Name: figureOutFriendlyFire
	Namespace: globallogic_player
	Checksum: 0xE50C55ED
	Offset: 0x3300
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function figureOutFriendlyFire(victim)
{
	return level.friendlyfire;
}

/*
	Name: isPlayerImmuneToKillstreak
	Namespace: globallogic_player
	Checksum: 0x90C6F865
	Offset: 0x3320
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function isPlayerImmuneToKillstreak(eAttacker, weapon)
{
	if(level.hardcoreMode)
	{
		return 0;
	}
	if(!isdefined(eAttacker))
	{
		return 0;
	}
	if(self != eAttacker)
	{
		return 0;
	}
	return weapon.doNotDamageOwner;
}

/*
	Name: Callback_PlayerDamage
	Namespace: globallogic_player
	Checksum: 0x1CA51BE0
	Offset: 0x3378
	Size: 0xA13
	Parameters: 11
	Flags: None
*/
function Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
{
	profilelog_begintiming(6, "ship");
	if(game["state"] == "postgame")
	{
		return;
	}
	if(self.sessionteam == "spectator")
	{
		return;
	}
	if(isdefined(self.canDoCombat) && !self.canDoCombat)
	{
		return;
	}
	if(isdefined(eAttacker) && isPlayer(eAttacker) && isdefined(eAttacker.canDoCombat) && !eAttacker.canDoCombat)
	{
		return;
	}
	if(isdefined(level.hostMigrationTimer))
	{
		return;
	}
	if(self.scene_takedamage === 0)
	{
		return;
	}
	weaponName = weapon.name;
	if(weaponName == "ai_tank_drone_gun" || weaponName == "ai_tank_drone_rocket" && !level.hardcoreMode)
	{
		if(isdefined(eAttacker) && eAttacker == self)
		{
			if(isdefined(eInflictor) && isdefined(eInflictor.from_ai))
			{
				return;
			}
		}
		if(isdefined(eAttacker) && isdefined(eAttacker.owner) && eAttacker.owner == self)
		{
			return;
		}
	}
	if(weapon.isEmp)
	{
		self notify("emp_grenaded", eAttacker);
	}
	iDamage = custom_gamemodes_modified_damage(self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc);
	iDamage = Int(iDamage);
	self.iDFlags = iDFlags;
	self.iDFlagsTime = GetTime();
	eAttacker = figureOutAttacker(eAttacker);
	PixBeginEvent("PlayerDamage flags/tweaks");
	if(!isdefined(vDir))
	{
		iDFlags = iDFlags | level.IDFLAGS_NO_KNOCKBACK;
	}
	friendly = 0;
	if(self.health != self.maxhealth)
	{
		self notify("snd_pain_player", sMeansOfDeath);
	}
	if(isdefined(eInflictor) && isdefined(eInflictor.script_noteworthy) && eInflictor.script_noteworthy == "ragdoll_now")
	{
		sMeansOfDeath = "MOD_FALLING";
	}
	if(globallogic_utils::isHeadShot(weapon, sHitLoc, sMeansOfDeath, eInflictor) && isPlayer(eAttacker))
	{
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	if(level.onPlayerDamage != &globallogic::blank)
	{
		modifiedDamage = [[level.onPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
		if(isdefined(modifiedDamage))
		{
			if(modifiedDamage <= 0)
			{
				return;
			}
			iDamage = modifiedDamage;
		}
	}
	if(level.onlyHeadShots)
	{
		if(sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET")
		{
			return;
		}
		else if(sMeansOfDeath == "MOD_HEAD_SHOT")
		{
			iDamage = 150;
		}
	}
	if(isdefined(eAttacker) && isPlayer(eAttacker) && self.team != eAttacker.team)
	{
		self.lastAttackWeapon = weapon;
	}
	weapon = figureOutWeapon(weapon, eInflictor);
	PixEndEvent();
	attackerIsHittingTeammate = isPlayer(eAttacker) && self util::IsEnemyPlayer(eAttacker) == 0;
	if(sHitLoc == "riotshield")
	{
		if(attackerIsHittingTeammate && level.friendlyfire == 0)
		{
			return;
		}
		if(sMeansOfDeath == "MOD_PISTOL_BULLET" || (sMeansOfDeath == "MOD_RIFLE_BULLET" && !attackerIsHittingTeammate))
		{
			previous_shield_damage = self.shieldDamageBlocked;
			self.shieldDamageBlocked = self.shieldDamageBlocked + iDamage;
			if(isPlayer(eAttacker))
			{
				eAttacker.lastAttackedShieldPlayer = self;
				eAttacker.lastAttackedShieldTime = GetTime();
			}
		}
		if(iDFlags & level.IDFLAGS_SHIELD_EXPLOSIVE_IMPACT)
		{
			sHitLoc = "none";
			if(!iDFlags & level.IDFLAGS_SHIELD_EXPLOSIVE_IMPACT_HUGE)
			{
				iDamage = iDamage * 0;
			}
		}
		else if(iDFlags & level.IDFLAGS_SHIELD_EXPLOSIVE_SPLASH)
		{
			if(isdefined(eInflictor) && isdefined(eInflictor.stuckToPlayer) && eInflictor.stuckToPlayer == self)
			{
				iDamage = 101;
			}
			sHitLoc = "none";
		}
		else
		{
			return;
		}
	}
	if(isdefined(eAttacker) && eAttacker != self && !friendly)
	{
		level.useStartSpawns = 0;
	}
	PixBeginEvent("PlayerDamage log");
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			println("Dev Block strings are not supported" + self GetEntityNumber() + "Dev Block strings are not supported" + self.health + "Dev Block strings are not supported" + eAttacker.clientid + "Dev Block strings are not supported" + isPlayer(eInflictor) + "Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported" + sHitLoc);
		}
	#/
	if(self.sessionstate != "dead")
	{
		lpselfnum = self GetEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.team;
		lpselfGuid = self getGuid();
		lpattackerteam = "";
		lpattackerorigin = (0, 0, 0);
		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker GetEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.team;
			lpattackerorigin = eAttacker.origin;
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "
");
	}
	PixEndEvent();
	profilelog_endtiming(6, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame());
}

/*
	Name: resetAttackerList
	Namespace: globallogic_player
	Checksum: 0xDFFF2F6C
	Offset: 0x3D98
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function resetAttackerList()
{
	self.Attackers = [];
	self.attackerData = [];
	self.attackerDamage = [];
	self.firstTimeDamaged = 0;
}

/*
	Name: doDamageFeedback
	Namespace: globallogic_player
	Checksum: 0xFF2EE834
	Offset: 0x3DD8
	Size: 0x95
	Parameters: 4
	Flags: None
*/
function doDamageFeedback(weapon, eInflictor, iDamage, sMeansOfDeath)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(level.allowHitMarkers == 0)
	{
		return 0;
	}
	if(level.allowHitMarkers == 1)
	{
		if(isdefined(sMeansOfDeath) && isdefined(iDamage))
		{
			if(isTacticalHitMarker(weapon, sMeansOfDeath, iDamage))
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: isTacticalHitMarker
	Namespace: globallogic_player
	Checksum: 0xE212607
	Offset: 0x3E78
	Size: 0x7F
	Parameters: 3
	Flags: None
*/
function isTacticalHitMarker(weapon, sMeansOfDeath, iDamage)
{
	if(weapons::is_grenade(weapon))
	{
		if("Smoke Grenade" == weapon.offhandClass)
		{
			if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
			{
				return 1;
			}
		}
		else if(iDamage == 1)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: doPerkFeedBack
	Namespace: globallogic_player
	Checksum: 0xA000A26D
	Offset: 0x3F00
	Size: 0x37
	Parameters: 4
	Flags: None
*/
function doPerkFeedBack(player, weapon, sMeansOfDeath, eInflictor)
{
	perkFeedback = undefined;
	return perkFeedback;
}

/*
	Name: isAIKillstreakDamage
	Namespace: globallogic_player
	Checksum: 0xA99D0FFE
	Offset: 0x3F40
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function isAIKillstreakDamage(weapon, eInflictor)
{
	if(weapon.isAIKillstreakDamage)
	{
		if(weapon.name != "ai_tank_drone_rocket" || isdefined(eInflictor.firedByAI))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: finishPlayerDamageWrapper
	Namespace: globallogic_player
	Checksum: 0x2197507D
	Offset: 0x3FA8
	Size: 0x25B
	Parameters: 13
	Flags: None
*/
function finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal)
{
	PixBeginEvent("finishPlayerDamageWrapper");
	if(!level.console && iDFlags & level.IDFLAGS_PENETRATION && isPlayer(eAttacker))
	{
		/#
			println("Dev Block strings are not supported" + self GetEntityNumber() + "Dev Block strings are not supported" + self.health + "Dev Block strings are not supported" + eAttacker.clientid + "Dev Block strings are not supported" + isPlayer(eInflictor) + "Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported" + sHitLoc);
		#/
		eAttacker AddPlayerStat("penetration_shots", 1);
	}
	if(GetDvarString("scr_csmode") != "")
	{
		self shellshock("damage", 0.2);
	}
	self damageShellshockAndRumble(eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage);
	self ability_power::power_loss_event_took_damage(eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage);
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
	PixEndEvent();
}

/*
	Name: allowedAssistWeapon
	Namespace: globallogic_player
	Checksum: 0xB4A6BB75
	Offset: 0x4210
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function allowedAssistWeapon(weapon)
{
	return 1;
}

/*
	Name: Callback_PlayerKilled
	Namespace: globallogic_player
	Checksum: 0x90C56D44
	Offset: 0x4228
	Size: 0x2539
	Parameters: 9
	Flags: None
*/
function Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	profilelog_begintiming(7, "ship");
	self endon("spawned");
	self notify("killed_player");
	self flagsys::clear("loadout_given");
	if(self.sessionteam == "spectator")
	{
		return;
	}
	if(game["state"] == "postgame")
	{
		return;
	}
	self needsRevive(0);
	if(isdefined(self.burning) && self.burning == 1)
	{
		self setburn(0);
	}
	self.suicide = 0;
	if(isdefined(level.takeLivesOnDeath) && level.takeLivesOnDeath == 1)
	{
		if(self.pers["lives"])
		{
			self.pers["lives"]--;
			if(self.pers["lives"] == 0)
			{
				level notify("player_eliminated");
				self notify("player_eliminated");
			}
		}
	}
	self thread globallogic_audio::flushGroupDialogOnPlayer("item_destroyed");
	weapon = updateWeapon(eInflictor, weapon);
	PixBeginEvent("PlayerKilled pre constants");
	wasInLastStand = 0;
	deathTimeOffset = 0;
	lastWeaponBeforeDroppingIntoLastStand = undefined;
	attackerStance = undefined;
	self.lastStandThisLife = undefined;
	self.vAttackerOrigin = undefined;
	if(isdefined(self.useLastStandParams))
	{
		self.useLastStandParams = undefined;
		/#
			Assert(isdefined(self.lastStandParams));
		#/
		if(!level.teambased || (!isdefined(attacker) || !isPlayer(attacker) || attacker.team != self.team || attacker == self))
		{
			eInflictor = self.lastStandParams.eInflictor;
			attacker = self.lastStandParams.attacker;
			attackerStance = self.lastStandParams.attackerStance;
			iDamage = self.lastStandParams.iDamage;
			sMeansOfDeath = self.lastStandParams.sMeansOfDeath;
			weapon = self.lastStandParams.weapon;
			vDir = self.lastStandParams.vDir;
			sHitLoc = self.lastStandParams.sHitLoc;
			self.vAttackerOrigin = self.lastStandParams.vAttackerOrigin;
			deathTimeOffset = GetTime() - self.lastStandParams.lastStandStartTime / 1000;
			if(isdefined(self.previousPrimary))
			{
				wasInLastStand = 1;
				lastWeaponBeforeDroppingIntoLastStand = self.previousPrimary;
			}
		}
		self.lastStandParams = undefined;
	}
	bestPlayer = undefined;
	bestPlayerMeansOfDeath = undefined;
	obituaryMeansOfDeath = undefined;
	bestPlayerWeapon = undefined;
	obituaryWeapon = undefined;
	if(!isdefined(attacker) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || (isdefined(attacker.isMagicBullet) && attacker.isMagicBullet == 1) || attacker == self && isdefined(self.Attackers))
	{
		if(!isdefined(bestPlayer))
		{
			for(i = 0; i < self.Attackers.size; i++)
			{
				player = self.Attackers[i];
				if(!isdefined(player))
				{
					continue;
				}
				if(!isdefined(self.attackerDamage[player.clientid]) || !isdefined(self.attackerDamage[player.clientid].damage))
				{
					continue;
				}
				if(player == self || (level.teambased && player.team == self.team))
				{
					continue;
				}
				if(self.attackerDamage[player.clientid].lasttimedamaged + 2500 < GetTime())
				{
					continue;
				}
				if(!allowedAssistWeapon(self.attackerDamage[player.clientid].weapon))
				{
					continue;
				}
				if(self.attackerDamage[player.clientid].damage > 1 && !isdefined(bestPlayer))
				{
					bestPlayer = player;
					bestPlayerMeansOfDeath = self.attackerDamage[player.clientid].meansOfDeath;
					bestPlayerWeapon = self.attackerDamage[player.clientid].weapon;
					continue;
				}
				if(isdefined(bestPlayer) && self.attackerDamage[player.clientid].damage > self.attackerDamage[bestPlayer.clientid].damage)
				{
					bestPlayer = player;
					bestPlayerMeansOfDeath = self.attackerDamage[player.clientid].meansOfDeath;
					bestPlayerWeapon = self.attackerDamage[player.clientid].weapon;
				}
			}
		}
		else if(isdefined(bestPlayer))
		{
			self RecordKillModifier("assistedsuicide");
		}
	}
	if(isdefined(bestPlayer))
	{
		attacker = bestPlayer;
		obituaryMeansOfDeath = bestPlayerMeansOfDeath;
		obituaryWeapon = bestPlayerWeapon;
	}
	if(isPlayer(attacker))
	{
		attacker.damagedPlayers[self.clientid] = undefined;
	}
	if(globallogic_utils::isHeadShot(weapon, sHitLoc, sMeansOfDeath, eInflictor) && isPlayer(attacker))
	{
		attacker playlocalsound("prj_bullet_impact_headshot_helmet_nodie_2d");
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	self.deathtime = GetTime();
	attacker = updateAttacker(attacker, weapon);
	eInflictor = updateInflictor(eInflictor);
	sMeansOfDeath = updateMeansOfDeath(weapon, sMeansOfDeath);
	if(isdefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped == 1)
	{
		self DetachShieldModel(level.carriedShieldModel, "tag_weapon_left");
		self.hasRiotShield = 0;
		self.hasRiotShieldEquipped = 0;
	}
	self thread updateGlobalBotKilledCounter();
	if(isPlayer(attacker) && attacker != self && (!level.teambased || (level.teambased && self.team != attacker.team)))
	{
		self addweaponstat(weapon, "deaths", 1);
		if(wasInLastStand && isdefined(lastWeaponBeforeDroppingIntoLastStand))
		{
			weapon = lastWeaponBeforeDroppingIntoLastStand;
		}
		else
		{
			weapon = self.lastdroppableweapon;
		}
		if(isdefined(weapon))
		{
			self addweaponstat(weapon, "deathsDuringUse", 1);
		}
		if(sMeansOfDeath != "MOD_FALLING")
		{
			attacker addweaponstat(weapon, "kills", 1);
		}
		if(sMeansOfDeath == "MOD_HEAD_SHOT")
		{
			attacker addweaponstat(weapon, "headshots", 1);
		}
	}
	if(!isdefined(obituaryMeansOfDeath))
	{
		obituaryMeansOfDeath = sMeansOfDeath;
	}
	if(!isdefined(obituaryWeapon))
	{
		obituaryWeapon = weapon;
	}
	if(!isPlayer(attacker) || self util::IsEnemyPlayer(attacker) == 0)
	{
		level notify("reset_obituary_count");
		level.lastObituaryPlayerCount = 0;
		level.lastObituaryPlayer = undefined;
	}
	else if(isdefined(level.lastObituaryPlayer) && level.lastObituaryPlayer == attacker)
	{
		level.lastObituaryPlayerCount++;
	}
	else
	{
		level notify("reset_obituary_count");
		level.lastObituaryPlayer = attacker;
		level.lastObituaryPlayerCount = 1;
	}
	if(level.lastObituaryPlayerCount >= 4)
	{
		level notify("reset_obituary_count");
		level.lastObituaryPlayerCount = 0;
		level.lastObituaryPlayer = undefined;
	}
	overrideEntityCamera = 0;
	if(level.teambased && isdefined(attacker.pers) && self.team == attacker.team && obituaryMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0)
	{
		obituary(self, self, obituaryWeapon, obituaryMeansOfDeath);
		demo::bookmark("kill", GetTime(), self, self, 0, eInflictor, overrideEntityCamera);
	}
	else
	{
		obituary(self, attacker, obituaryWeapon, obituaryMeansOfDeath);
		demo::bookmark("kill", GetTime(), attacker, self, 0, eInflictor, overrideEntityCamera);
	}
	if(!level.inGracePeriod)
	{
		self weapons::dropScavengerForDeath(attacker);
		self weapons::dropWeaponForDeath(attacker);
	}
	spawnlogic::deathOccured(self, attacker);
	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";
	self.pers["weapon"] = undefined;
	self.killedPlayersCurrent = [];
	self.deathCount++;
	/#
		println("Dev Block strings are not supported" + self.clientid + "Dev Block strings are not supported" + self.deathCount);
	#/
	if(!isdefined(self.switching_teams))
	{
		if(isPlayer(attacker) && level.teambased && attacker != self && self.team == attacker.team)
		{
			self.pers["cur_kill_streak"] = 0;
			self.pers["cur_total_kill_streak"] = 0;
			self.pers["totalKillstreakCount"] = 0;
			self.pers["killstreaksEarnedThisKillstreak"] = 0;
			self setplayercurrentstreak(0);
		}
		else
		{
			self globallogic_score::incPersStat("deaths", 1, 1, 1);
			self.deaths = self globallogic_score::getPersStat("deaths");
			self UpdateStatRatio("kdratio", "kills", "deaths");
			if(self.pers["cur_kill_streak"] > self.pers["best_kill_streak"])
			{
				self.pers["best_kill_streak"] = self.pers["cur_kill_streak"];
			}
			self.pers["kill_streak_before_death"] = self.pers["cur_kill_streak"];
			self.pers["cur_kill_streak"] = 0;
			self.pers["cur_total_kill_streak"] = 0;
			self.pers["totalKillstreakCount"] = 0;
			self.pers["killstreaksEarnedThisKillstreak"] = 0;
			self setplayercurrentstreak(0);
			self.cur_death_streak++;
			if(self.cur_death_streak > self.death_streak)
			{
				if(level.rankedMatch)
				{
					self SetDStat("HighestStats", "death_streak", self.cur_death_streak);
				}
				self.death_streak = self.cur_death_streak;
			}
			if(self.cur_death_streak >= GetDvarInt("perk_deathStreakCountRequired"))
			{
				self enabledeathstreak();
			}
		}
	}
	else
	{
		self.pers["totalKillstreakCount"] = 0;
		self.pers["killstreaksEarnedThisKillstreak"] = 0;
	}
	lpselfnum = self GetEntityNumber();
	lpselfname = self.name;
	lpattackGuid = "";
	lpattackname = "";
	lpselfteam = self.team;
	lpselfGuid = self getGuid();
	lpattackteam = "";
	lpattackorigin = (0, 0, 0);
	lpattacknum = -1;
	awardAssists = 0;
	PixEndEvent();
	self globallogic_score::resetPlayerMomentumOnDeath();
	if(isPlayer(attacker))
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackteam = attacker.team;
		lpattackorigin = attacker.origin;
		if(attacker == self)
		{
			doKillcam = 0;
			self globallogic_score::incPersStat("suicides", 1);
			self.suicides = self globallogic_score::getPersStat("suicides");
			if(sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && self.throwingGrenade)
			{
				self.lastGrenadeSuicideTime = GetTime();
			}
			awardAssists = 1;
			self.suicide = 1;
			if(isdefined(self.friendlydamage))
			{
				self iprintln(&"MP_FRIENDLY_FIRE_WILL_NOT");
				if(level.teamKillPointLoss)
				{
					scoreSub = self [[level.getTeamKillScore]](eInflictor, attacker, sMeansOfDeath, weapon);
					globallogic_score::_setPlayerScore(attacker, globallogic_score::_getPlayerScore(attacker) - scoreSub);
				}
			}
		}
		else
		{
			PixBeginEvent("PlayerKilled attacker");
			lpattacknum = attacker GetEntityNumber();
			doKillcam = 1;
			if(level.teambased && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0)
			{
			}
			else if(level.teambased && self.team == attacker.team)
			{
				if(!IgnoreTeamKills(weapon, sMeansOfDeath))
				{
					teamkill_penalty = self [[level.getTeamKillPenalty]](eInflictor, attacker, sMeansOfDeath, weapon);
					attacker globallogic_score::incPersStat("teamkills_nostats", teamkill_penalty, 0);
					attacker globallogic_score::incPersStat("teamkills", 1);
					attacker.teamkillsThisRound++;
					if(level.teamKillPointLoss)
					{
						scoreSub = self [[level.getTeamKillScore]](eInflictor, attacker, sMeansOfDeath, weapon);
						globallogic_score::_setPlayerScore(attacker, globallogic_score::_getPlayerScore(attacker) - scoreSub);
					}
					if(globallogic_utils::getTimePassed() < 5000)
					{
						teamKillDelay = 1;
					}
					else if(attacker.pers["teamkills_nostats"] > 1 && globallogic_utils::getTimePassed() < 8000 + attacker.pers["teamkills_nostats"] * 1000)
					{
						teamKillDelay = 1;
					}
					else
					{
						teamKillDelay = attacker teamKillDelay();
					}
					if(teamKillDelay > 0)
					{
						attacker.teamKillPunish = 1;
						attacker suicide();
						if(attacker ShouldTeamKillKick(teamKillDelay))
						{
							attacker TeamKillKick();
						}
						attacker thread reduceTeamKillsOverTime();
					}
				}
			}
			else
			{
				globallogic_score::incTotalKills(attacker.team);
				attacker thread globallogic_score::giveKillStats(sMeansOfDeath, weapon, self);
				if(isalive(attacker))
				{
					PixBeginEvent("killstreak");
					if(!isdefined(eInflictor) || !isdefined(eInflictor.requiredDeathCount) || attacker.deathCount == eInflictor.requiredDeathCount)
					{
						shouldGiveKillstreak = 0;
						attacker.pers["cur_total_kill_streak"]++;
						attacker setplayercurrentstreak(attacker.pers["cur_total_kill_streak"]);
						if(isdefined(level.killstreaks) && shouldGiveKillstreak)
						{
							attacker.pers["cur_kill_streak"]++;
						}
					}
					PixEndEvent();
				}
				if(attacker.pers["cur_kill_streak"] > attacker.kill_streak)
				{
					if(level.rankedMatch)
					{
						attacker SetDStat("HighestStats", "kill_streak", attacker.pers["totalKillstreakCount"]);
					}
					attacker.kill_streak = attacker.pers["cur_kill_streak"];
				}
				killstreak = undefined;
				attacker thread globallogic_score::trackAttackerKill(self.name, self.pers["rank"], self.pers["rankxp"], self.pers["prestige"], self getXuid());
				attackerName = attacker.name;
				self thread globallogic_score::trackAttackeeDeath(attackerName, attacker.pers["rank"], attacker.pers["rankxp"], attacker.pers["prestige"], attacker getXuid());
				attacker thread globallogic_score::incKillstreakTracker(weapon);
				if(level.teambased && attacker.team != "spectator")
				{
					if(isai(attacker))
					{
						globallogic_score::giveTeamScore("kill", attacker.team, attacker, self);
					}
					else
					{
						globallogic_score::giveTeamScore("kill", attacker.team, attacker, self);
					}
				}
				scoreSub = level.deathPointLoss;
				if(scoreSub != 0)
				{
					globallogic_score::_setPlayerScore(self, globallogic_score::_getPlayerScore(self) - scoreSub);
				}
				level thread playKillBattleChatter(attacker, weapon, self);
				if(level.teambased)
				{
					awardAssists = 1;
				}
			}
			PixEndEvent();
		}
	}
	else if(isdefined(attacker) && (attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn"))
	{
		doKillcam = 0;
		lpattacknum = -1;
		lpattackGuid = "";
		lpattackname = "";
		lpattackteam = "world";
		self globallogic_score::incPersStat("suicides", 1);
		self.suicides = self globallogic_score::getPersStat("suicides");
		awardAssists = 1;
	}
	else
	{
		doKillcam = 0;
		lpattacknum = -1;
		lpattackGuid = "";
		lpattackname = "";
		lpattackteam = "world";
		if(isdefined(eInflictor) && isdefined(eInflictor.killCamEnt))
		{
			doKillcam = 1;
			lpattacknum = self GetEntityNumber();
		}
		if(isdefined(attacker) && isdefined(attacker.team) && isdefined(level.teams[attacker.team]))
		{
			if(attacker.team != self.team)
			{
				if(level.teambased)
				{
					globallogic_score::giveTeamScore("kill", attacker.team, attacker, self);
				}
			}
		}
		awardAssists = 1;
	}
	PixBeginEvent("PlayerKilled post constants");
	self.lastAttacker = attacker;
	self.lastDeathPos = self.origin;
	if(isdefined(attacker) && isPlayer(attacker) && attacker != self && (!level.teambased || attacker.team != self.team))
	{
		self thread challenges::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, sHitLoc, attackerStance);
	}
	else
	{
		self notify("playerKilledChallengesProcessed");
	}
	if(isdefined(self.Attackers))
	{
		self.Attackers = [];
	}
	if(isPlayer(attacker))
	{
	}
	logPrint("K;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "
");
	attackerString = "none";
	if(isPlayer(attacker))
	{
		attackerString = attacker getXuid() + "(" + lpattackname + ")";
	}
	/#
		print("Dev Block strings are not supported" + sMeansOfDeath + "Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported" + attackerString + "Dev Block strings are not supported" + iDamage + "Dev Block strings are not supported" + sHitLoc + "Dev Block strings are not supported" + Int(self.origin[0]) + "Dev Block strings are not supported" + Int(self.origin[1]) + "Dev Block strings are not supported" + Int(self.origin[2]));
	#/
	level thread globallogic::updateTeamStatus();
	killcamentity = self GetKillCamEntity(attacker, eInflictor, weapon);
	killcamentityindex = -1;
	killcamentitystarttime = 0;
	if(isdefined(killcamentity))
	{
		killcamentityindex = killcamentity GetEntityNumber();
		if(isdefined(killcamentity.startTime))
		{
			killcamentitystarttime = killcamentity.startTime;
		}
		else
		{
			killcamentitystarttime = killcamentity.birthtime;
		}
		if(!isdefined(killcamentitystarttime))
		{
			killcamentitystarttime = 0;
		}
	}
	if(isdefined(self.killstreak_waitamount) && self.killstreak_waitamount > 0)
	{
		doKillcam = 0;
	}
	self weapons::detach_carry_object_model();
	died_in_vehicle = 0;
	if(isdefined(self.diedOnVehicle))
	{
		died_in_vehicle = self.diedOnVehicle;
	}
	PixEndEvent();
	PixBeginEvent("PlayerKilled body and gibbing");
	if(!died_in_vehicle)
	{
		vAttackerOrigin = undefined;
		if(isdefined(attacker))
		{
			vAttackerOrigin = attacker.origin;
		}
		ragdoll_now = 0;
		if(isdefined(self.usingvehicle) && self.usingvehicle && isdefined(self.vehicleposition) && self.vehicleposition == 1)
		{
			ragdoll_now = 1;
		}
		body = self clonePlayer(deathAnimDuration, weapon, attacker);
		self createDeadBody(iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_now, body);
	}
	PixEndEvent();
	thread globallogic_spawn::spawnQueuedClient(self.team, attacker);
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;
	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	for(iCB = 0; iCB < level.onPlayerKilledExtraUnthreadedCBs.size; iCB++)
	{
		self [[level.onPlayerKilledExtraUnthreadedCBs[iCB]]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	}
	self.wantSafeSpawn = 0;
	PERKS = [];
	killstreaks = globallogic::getKillStreaks(attacker);
	if(!isdefined(self.killstreak_waitamount))
	{
		self thread [[level.spawnPlayerPrediction]]();
	}
	profilelog_endtiming(7, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame());
	wait(0.25);
	self.cancelKillcam = 0;
	defaultPlayerDeathWatchTime = 1.75;
	if(sMeansOfDeath == "MOD_MELEE_ASSASSINATE" || 0 > weapon.deathCamTime)
	{
		defaultPlayerDeathWatchTime = deathAnimDuration * 0.001 + 0.5;
	}
	else if(0 < weapon.deathCamTime)
	{
		defaultPlayerDeathWatchTime = weapon.deathCamTime;
	}
	if(isdefined(level.overridePlayerDeathWatchTimer))
	{
		defaultPlayerDeathWatchTime = [[level.overridePlayerDeathWatchTimer]](defaultPlayerDeathWatchTime);
	}
	globallogic_utils::waitForTimeOrNotifies(defaultPlayerDeathWatchTime);
	self notify("death_delay_finished");
	/#
		if(GetDvarInt("Dev Block strings are not supported") != 0)
		{
			doKillcam = 1;
			if(lpattacknum < 0)
			{
				lpattacknum = self GetEntityNumber();
			}
		}
	#/
	if(game["state"] != "playing")
	{
		return;
	}
	self.respawnTimerStartTime = GetTime();
	if(!self.cancelKillcam && doKillcam && level.killcam)
	{
		livesLeft = !level.numLives && !self.pers["lives"];
		timeUntilSpawn = globallogic_spawn::timeUntilSpawn(1);
		willRespawnImmediately = livesLeft && timeUntilSpawn <= 0 && !level.playerQueuedRespawn;
	}
	if(game["state"] != "playing")
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamtargetentity = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psOffsetTime = 0;
		return;
	}
	WaitTillKillStreakDone();
	if(globallogic_utils::isValidClass(self.curClass))
	{
		timePassed = undefined;
		if(isdefined(self.respawnTimerStartTime))
		{
			timePassed = GetTime() - self.respawnTimerStartTime / 1000;
		}
		self thread [[level.spawnClient]](timePassed);
		self.respawnTimerStartTime = undefined;
	}
}

/*
	Name: updateGlobalBotKilledCounter
	Namespace: globallogic_player
	Checksum: 0x5B8659E9
	Offset: 0x6770
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function updateGlobalBotKilledCounter()
{
	if(isdefined(self.pers["isBot"]))
	{
		level.globalLarrysKilled++;
	}
}

/*
	Name: WaitTillKillStreakDone
	Namespace: globallogic_player
	Checksum: 0x94DA8737
	Offset: 0x67A0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function WaitTillKillStreakDone()
{
	if(isdefined(self.killstreak_waitamount))
	{
		startTime = GetTime();
		waitTime = self.killstreak_waitamount * 1000;
		while(GetTime() < startTime + waitTime && isdefined(self.killstreak_waitamount))
		{
			wait(0.1);
		}
		wait(2);
		self.killstreak_waitamount = undefined;
	}
}

/*
	Name: TeamKillKick
	Namespace: globallogic_player
	Checksum: 0x9DCD2FB1
	Offset: 0x6820
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function TeamKillKick()
{
	self globallogic_score::incPersStat("sessionbans", 1);
	self endon("disconnect");
	waittillframeend;
	playlistbanquantum = tweakables::getTweakableValue("team", "teamkillerplaylistbanquantum");
	playlistbanpenalty = tweakables::getTweakableValue("team", "teamkillerplaylistbanpenalty");
	if(playlistbanquantum > 0 && playlistbanpenalty > 0)
	{
		timeplayedtotal = self GetDStat("playerstatslist", "time_played_total", "StatValue");
		minutesplayed = timeplayedtotal / 60;
		freebees = 2;
		banallowance = Int(floor(minutesplayed / playlistbanquantum)) + freebees;
		if(self.sessionbans > banallowance)
		{
			self SetDStat("playerstatslist", "gametypeban", "StatValue", timeplayedtotal + playlistbanpenalty * 60);
		}
	}
	if(self util::is_bot())
	{
		level notify("bot_kicked", self.team);
	}
	ban(self GetEntityNumber());
	globallogic_audio::leaderDialog("kicked");
}

/*
	Name: teamKillDelay
	Namespace: globallogic_player
	Checksum: 0xC68ECF8C
	Offset: 0x6A38
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function teamKillDelay()
{
	teamkills = self.pers["teamkills_nostats"];
	if(level.minimumAllowedTeamKills < 0 || teamkills <= level.minimumAllowedTeamKills)
	{
		return 0;
	}
	exceeded = teamkills - level.minimumAllowedTeamKills;
	return level.teamKillSpawnDelay * exceeded;
}

/*
	Name: ShouldTeamKillKick
	Namespace: globallogic_player
	Checksum: 0x60571D0F
	Offset: 0x6AB0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function ShouldTeamKillKick(teamKillDelay)
{
	if(teamKillDelay && level.minimumAllowedTeamKills >= 0)
	{
		if(globallogic_utils::getTimePassed() >= 5000)
		{
			return 1;
		}
		if(self.pers["teamkills_nostats"] > 1)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: reduceTeamKillsOverTime
	Namespace: globallogic_player
	Checksum: 0xC720668C
	Offset: 0x6B20
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function reduceTeamKillsOverTime()
{
	timePerOneTeamkillReduction = 20;
	reductionPerSecond = 1 / timePerOneTeamkillReduction;
	while(1)
	{
		if(isalive(self))
		{
			self.pers["teamkills_nostats"] = self.pers["teamkills_nostats"] - reductionPerSecond;
			if(self.pers["teamkills_nostats"] < level.minimumAllowedTeamKills)
			{
				self.pers["teamkills_nostats"] = level.minimumAllowedTeamKills;
				break;
			}
		}
		wait(1);
	}
}

/*
	Name: IgnoreTeamKills
	Namespace: globallogic_player
	Checksum: 0x5BE79E68
	Offset: 0x6BE8
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function IgnoreTeamKills(weapon, sMeansOfDeath)
{
	if(SessionModeIsZombiesGame())
	{
		return 1;
	}
	if(sMeansOfDeath == "MOD_MELEE")
	{
		return 0;
	}
	if(weapon.name == "briefcase_bomb")
	{
		return 1;
	}
	if(weapon.name == "supplydrop")
	{
		return 1;
	}
	return 0;
}

/*
	Name: Callback_PlayerLastStand
	Namespace: globallogic_player
	Checksum: 0x389EE803
	Offset: 0x6C78
	Size: 0x4B
	Parameters: 9
	Flags: None
*/
function Callback_PlayerLastStand(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
}

/*
	Name: damageShellshockAndRumble
	Namespace: globallogic_player
	Checksum: 0x9274A8D9
	Offset: 0x6CD0
	Size: 0x73
	Parameters: 5
	Flags: None
*/
function damageShellshockAndRumble(eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage)
{
	self thread weapons::onWeaponDamage(eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage);
	self PlayRumbleOnEntity("damage_heavy");
}

/*
	Name: createDeadBody
	Namespace: globallogic_player
	Checksum: 0x71B81D6E
	Offset: 0x6D50
	Size: 0x1E7
	Parameters: 10
	Flags: None
*/
function createDeadBody(iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body)
{
	if(sMeansOfDeath == "MOD_HIT_BY_OBJECT" && self GetStance() == "prone")
	{
		self.body = body;
		return;
	}
	if(isdefined(level.ragdoll_override) && self [[level.ragdoll_override]]())
	{
		return;
	}
	if(ragdoll_jib || self isOnLadder() || self isMantling() || sMeansOfDeath == "MOD_CRUSH" || sMeansOfDeath == "MOD_HIT_BY_OBJECT")
	{
		body StartRagdoll();
	}
	if(!self IsOnGround())
	{
		if(GetDvarInt("scr_disable_air_death_ragdoll") == 0)
		{
			body StartRagdoll();
		}
	}
	if(self is_explosive_ragdoll(weapon, eInflictor))
	{
		body start_explosive_ragdoll(vDir, weapon);
	}
	thread delayStartRagdoll(body, sHitLoc, vDir, weapon, eInflictor, sMeansOfDeath);
	self.body = body;
}

/*
	Name: is_explosive_ragdoll
	Namespace: globallogic_player
	Checksum: 0x2D786AC3
	Offset: 0x6F40
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function is_explosive_ragdoll(weapon, inflictor)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(weapon.name == "destructible_car" || weapon.name == "explodable_barrel")
	{
		return 1;
	}
	if(weapon.projExplosionType == "grenade")
	{
		if(isdefined(inflictor) && isdefined(inflictor.stuckToPlayer))
		{
			if(inflictor.stuckToPlayer == self)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: start_explosive_ragdoll
	Namespace: globallogic_player
	Checksum: 0xD1C6A931
	Offset: 0x7000
	Size: 0x1B3
	Parameters: 2
	Flags: None
*/
function start_explosive_ragdoll(dir, weapon)
{
	if(!isdefined(self))
	{
		return;
	}
	x = randomIntRange(50, 100);
	y = randomIntRange(50, 100);
	z = randomIntRange(10, 20);
	if(isdefined(weapon) && (weapon.name == "sticky_grenade" || weapon.name == "explosive_bolt"))
	{
		if(isdefined(dir) && LengthSquared(dir) > 0)
		{
			x = dir[0] * x;
			y = dir[1] * y;
		}
	}
	else if(math::cointoss())
	{
		x = x * -1;
	}
	if(math::cointoss())
	{
		y = y * -1;
	}
	self StartRagdoll();
	self LaunchRagdoll((x, y, z));
}

/*
	Name: notifyConnecting
	Namespace: globallogic_player
	Checksum: 0xC0ACDF37
	Offset: 0x71C0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function notifyConnecting()
{
	waittillframeend;
	if(isdefined(self))
	{
		level notify("connecting", self);
		self callback::callback("hash_fefe13f5");
	}
}

/*
	Name: delayStartRagdoll
	Namespace: globallogic_player
	Checksum: 0xA82BEDAD
	Offset: 0x7208
	Size: 0x313
	Parameters: 6
	Flags: None
*/
function delayStartRagdoll(ent, sHitLoc, vDir, weapon, eInflictor, sMeansOfDeath)
{
	if(isdefined(ent))
	{
		deathAnim = ent getcorpseanim();
		if(animhasnotetrack(deathAnim, "ignore_ragdoll"))
		{
			return;
		}
	}
	if(level.oldschool)
	{
		if(!isdefined(vDir))
		{
			vDir = (0, 0, 0);
		}
		explosionPos = ent.origin + (0, 0, globallogic_utils::getHitLocHeight(sHitLoc));
		explosionPos = explosionPos - vDir * 20;
		explosionRadius = 40;
		explosionForce = 0.75;
		if(sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_EXPLOSIVE" || IsSubStr(sMeansOfDeath, "MOD_GRENADE") || IsSubStr(sMeansOfDeath, "MOD_PROJECTILE") || sHitLoc == "head" || sHitLoc == "helmet")
		{
			explosionForce = 2.5;
		}
		ent StartRagdoll(1);
		wait(0.05);
		if(!isdefined(ent))
		{
			return;
		}
		PhysicsExplosionSphere(explosionPos, explosionRadius, explosionRadius / 2, explosionForce);
		return;
	}
	wait(0.2);
	if(!isdefined(ent))
	{
		return;
	}
	if(ent IsRagdoll())
	{
		return;
	}
	deathAnim = ent getcorpseanim();
	startFrac = 0.35;
	if(animhasnotetrack(deathAnim, "start_ragdoll"))
	{
		times = getnotetracktimes(deathAnim, "start_ragdoll");
		if(isdefined(times))
		{
			startFrac = times[0];
		}
	}
	waitTime = startFrac * getanimlength(deathAnim);
	wait(waitTime);
	if(isdefined(ent))
	{
		ent StartRagdoll(1);
	}
}

/*
	Name: trackAttackerDamage
	Namespace: globallogic_player
	Checksum: 0x1BC7336C
	Offset: 0x7528
	Size: 0x2B9
	Parameters: 4
	Flags: None
*/
function trackAttackerDamage(eAttacker, iDamage, sMeansOfDeath, weapon)
{
	if(!isdefined(eAttacker))
	{
		return;
	}
	if(!isPlayer(eAttacker))
	{
		return;
	}
	if(self.attackerData.size == 0)
	{
		self.firstTimeDamaged = GetTime();
	}
	if(!isdefined(self.attackerData[eAttacker.clientid]))
	{
		self.attackerDamage[eAttacker.clientid] = spawnstruct();
		self.attackerDamage[eAttacker.clientid].damage = iDamage;
		self.attackerDamage[eAttacker.clientid].meansOfDeath = sMeansOfDeath;
		self.attackerDamage[eAttacker.clientid].weapon = weapon;
		self.attackerDamage[eAttacker.clientid].time = GetTime();
		self.Attackers[self.Attackers.size] = eAttacker;
		self.attackerData[eAttacker.clientid] = 0;
	}
	else
	{
		self.attackerDamage[eAttacker.clientid].damage = self.attackerDamage[eAttacker.clientid].damage + iDamage;
		self.attackerDamage[eAttacker.clientid].meansOfDeath = sMeansOfDeath;
		self.attackerDamage[eAttacker.clientid].weapon = weapon;
		if(!isdefined(self.attackerDamage[eAttacker.clientid].time))
		{
			self.attackerDamage[eAttacker.clientid].time = GetTime();
		}
	}
	self.attackerDamage[eAttacker.clientid].lasttimedamaged = GetTime();
	if(weapons::is_primary_weapon(weapon))
	{
		self.attackerData[eAttacker.clientid] = 1;
	}
}

/*
	Name: giveAttackerAndInflictorOwnerAssist
	Namespace: globallogic_player
	Checksum: 0x1D61B9D8
	Offset: 0x77F0
	Size: 0x103
	Parameters: 5
	Flags: None
*/
function giveAttackerAndInflictorOwnerAssist(eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon)
{
	if(!allowedAssistWeapon(weapon))
	{
		return;
	}
	self trackAttackerDamage(eAttacker, iDamage, sMeansOfDeath, weapon);
	if(!isdefined(eInflictor))
	{
		return;
	}
	if(!isdefined(eInflictor.owner))
	{
		return;
	}
	if(!isdefined(eInflictor.ownerGetsAssist))
	{
		return;
	}
	if(!eInflictor.ownerGetsAssist)
	{
		return;
	}
	if(isdefined(eAttacker) && eAttacker == eInflictor.owner)
	{
		return;
	}
	self trackAttackerDamage(eInflictor.owner, iDamage, sMeansOfDeath, weapon);
}

/*
	Name: updateMeansOfDeath
	Namespace: globallogic_player
	Checksum: 0x3AC2C116
	Offset: 0x7900
	Size: 0xB5
	Parameters: 2
	Flags: None
*/
function updateMeansOfDeath(weapon, sMeansOfDeath)
{
	switch(weapon.name)
	{
		case "knife_ballistic":
		{
			if(sMeansOfDeath != "MOD_HEAD_SHOT" && sMeansOfDeath != "MOD_MELEE")
			{
				sMeansOfDeath = "MOD_PISTOL_BULLET";
			}
			break;
		}
		case "dog_bite":
		{
			sMeansOfDeath = "MOD_PISTOL_BULLET";
			break;
		}
		case "destructible_car":
		{
			sMeansOfDeath = "MOD_EXPLOSIVE";
			break;
		}
		case "explodable_barrel":
		{
			sMeansOfDeath = "MOD_EXPLOSIVE";
			break;
		}
	}
	return sMeansOfDeath;
}

/*
	Name: updateAttacker
	Namespace: globallogic_player
	Checksum: 0x15149ABF
	Offset: 0x79C0
	Size: 0x197
	Parameters: 2
	Flags: None
*/
function updateAttacker(attacker, weapon)
{
	if(isai(attacker) && isdefined(attacker.script_owner))
	{
		if(!level.teambased || attacker.script_owner.team != self.team)
		{
			attacker = attacker.script_owner;
		}
	}
	if(attacker.classname == "script_vehicle" && isdefined(attacker.owner))
	{
		attacker notify("killed", self);
		attacker = attacker.owner;
	}
	if(isai(attacker))
	{
		attacker notify("killed", self);
	}
	if(isdefined(self.capturingLastFlag) && self.capturingLastFlag == 1)
	{
		attacker.lastCapKiller = 1;
	}
	if(isdefined(attacker) && isdefined(weapon) && weapon.name == "planemortar")
	{
		if(!isdefined(attacker.planeMortarBda))
		{
			attacker.planeMortarBda = 0;
		}
		attacker.planeMortarBda++;
	}
	return attacker;
}

/*
	Name: updateInflictor
	Namespace: globallogic_player
	Checksum: 0x21CCACAC
	Offset: 0x7B60
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function updateInflictor(eInflictor)
{
	if(isdefined(eInflictor) && eInflictor.classname == "script_vehicle")
	{
		eInflictor notify("killed", self);
		if(isdefined(eInflictor.bda))
		{
			eInflictor.bda++;
		}
	}
	return eInflictor;
}

/*
	Name: updateWeapon
	Namespace: globallogic_player
	Checksum: 0x2316F73
	Offset: 0x7BD0
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function updateWeapon(eInflictor, weapon)
{
	if(weapon == level.weaponNone && isdefined(eInflictor))
	{
		if(isdefined(eInflictor.targetname) && eInflictor.targetname == "explodable_barrel")
		{
			weapon = GetWeapon("explodable_barrel");
		}
		else if(isdefined(eInflictor.destructible_type) && IsSubStr(eInflictor.destructible_type, "vehicle_"))
		{
			weapon = GetWeapon("destructible_car");
		}
	}
	return weapon;
}

/*
	Name: getClosestKillcamEntity
	Namespace: globallogic_player
	Checksum: 0x2A9674D9
	Offset: 0x7CB0
	Size: 0x21F
	Parameters: 3
	Flags: None
*/
function getClosestKillcamEntity(attacker, killCamEntities, depth)
{
	if(!isdefined(depth))
	{
		depth = 0;
	}
	closestKillcamEnt = undefined;
	closestKillcamEntIndex = undefined;
	closestKillcamEntDist = undefined;
	origin = undefined;
	foreach(killCamEnt in killCamEntities)
	{
		if(killCamEnt == attacker)
		{
			continue;
		}
		origin = killCamEnt.origin;
		if(isdefined(killCamEnt.offsetPoint))
		{
			origin = origin + killCamEnt.offsetPoint;
		}
		dist = DistanceSquared(self.origin, origin);
		if(!isdefined(closestKillcamEnt) || dist < closestKillcamEntDist)
		{
			closestKillcamEnt = killCamEnt;
			closestKillcamEntDist = dist;
			closestKillcamEntIndex = killcamEntIndex;
		}
	}
	if(depth < 3 && isdefined(closestKillcamEnt))
	{
		if(!BulletTracePassed(closestKillcamEnt.origin, self.origin, 0, self))
		{
			killCamEntities[closestKillcamEntIndex] = undefined;
			betterKillcamEnt = getClosestKillcamEntity(attacker, killCamEntities, depth + 1);
			if(isdefined(betterKillcamEnt))
			{
				closestKillcamEnt = betterKillcamEnt;
			}
		}
	}
	return closestKillcamEnt;
}

/*
	Name: GetKillCamEntity
	Namespace: globallogic_player
	Checksum: 0x1DB75DAF
	Offset: 0x7ED8
	Size: 0x197
	Parameters: 3
	Flags: None
*/
function GetKillCamEntity(attacker, eInflictor, weapon)
{
	if(!isdefined(eInflictor))
	{
		return undefined;
	}
	if(eInflictor == attacker)
	{
		if(!isdefined(eInflictor.isMagicBullet))
		{
			return undefined;
		}
		if(isdefined(eInflictor.isMagicBullet) && !eInflictor.isMagicBullet)
		{
			return undefined;
		}
	}
	else if(isdefined(level.levelSpecificKillcam))
	{
		levelSpecificKillcamEnt = self [[level.levelSpecificKillcam]]();
		if(isdefined(levelSpecificKillcamEnt))
		{
			return levelSpecificKillcamEnt;
		}
	}
	if(weapon.name == "m220_tow")
	{
		return undefined;
	}
	if(isdefined(eInflictor.killCamEnt))
	{
		if(eInflictor.killCamEnt == attacker)
		{
			return undefined;
		}
		return eInflictor.killCamEnt;
	}
	else if(isdefined(eInflictor.killCamEntities))
	{
		return getClosestKillcamEntity(attacker, eInflictor.killCamEntities);
	}
	if(isdefined(eInflictor.script_gameobjectname) && eInflictor.script_gameobjectname == "bombzone")
	{
		return eInflictor.killCamEnt;
	}
	return eInflictor;
}

/*
	Name: playKillBattleChatter
	Namespace: globallogic_player
	Checksum: 0x40C08C16
	Offset: 0x8078
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function playKillBattleChatter(attacker, weapon, victim)
{
}

/*
	Name: recordActivePlayersEndGameMatchRecordStats
	Namespace: globallogic_player
	Checksum: 0xB90365E3
	Offset: 0x80A0
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function recordActivePlayersEndGameMatchRecordStats()
{
	foreach(player in level.players)
	{
		recordPlayerMatchEnd(player);
		recordPlayerStats(player, "presentAtEnd", 1);
	}
}

