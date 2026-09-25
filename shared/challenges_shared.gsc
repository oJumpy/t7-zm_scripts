#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\drown;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace challenges;

/*
	Name: init_shared
	Namespace: challenges
	Checksum: 0x99EC1590
	Offset: 0x1140
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_shared()
{
}

/*
	Name: pickedUpBallisticKnife
	Namespace: challenges
	Checksum: 0xDB13F45
	Offset: 0x1150
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function pickedUpBallisticKnife()
{
	self.retreivedBlades++;
}

/*
	Name: trackAssists
	Namespace: challenges
	Checksum: 0x1339CEAD
	Offset: 0x1168
	Size: 0x89
	Parameters: 3
	Flags: None
*/
function trackAssists(attacker, damage, isFlare)
{
	if(!isdefined(self.flareAttackerDamage))
	{
		self.flareAttackerDamage = [];
	}
	if(isdefined(isFlare) && isFlare == 1)
	{
		self.flareAttackerDamage[attacker.clientid] = 1;
	}
	else
	{
		self.flareAttackerDamage[attacker.clientid] = 0;
	}
}

/*
	Name: destroyedEquipment
	Namespace: challenges
	Checksum: 0x2669AC5B
	Offset: 0x1200
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function destroyedEquipment(weapon)
{
	if(isdefined(weapon) && weapon.isEmp)
	{
		if(self util::is_item_purchased("emp_grenade"))
		{
			self AddPlayerStat("destroy_equipment_with_emp_grenade", 1);
		}
		self addweaponstat(weapon, "combatRecordStat", 1);
		if(self util::has_hacker_perk_purchased_and_equipped())
		{
			self AddPlayerStat("destroy_equipment_with_emp_engineer", 1);
			self AddPlayerStat("destroy_equipment_engineer", 1);
		}
	}
	else if(self util::has_hacker_perk_purchased_and_equipped())
	{
		self AddPlayerStat("destroy_equipment_engineer", 1);
	}
	self AddPlayerStat("destroy_equipment", 1);
	if(isdefined(weapon) && weapon.isBulletWeapon)
	{
		self AddPlayerStat("destroy_equipment_with_bullet", 1);
	}
	self hackedOrDestroyedEquipment();
}

/*
	Name: destroyedTacticalInsert
	Namespace: challenges
	Checksum: 0x68E3B065
	Offset: 0x1398
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function destroyedTacticalInsert()
{
	if(!isdefined(self.pers["tacticalInsertsDestroyed"]))
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
	}
	self.pers["tacticalInsertsDestroyed"]++;
	if(self.pers["tacticalInsertsDestroyed"] >= 5)
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
		self AddPlayerStat("destroy_5_tactical_inserts", 1);
	}
}

/*
	Name: addFlySwatterStat
	Namespace: challenges
	Checksum: 0x9160F807
	Offset: 0x1438
	Size: 0x195
	Parameters: 2
	Flags: None
*/
function addFlySwatterStat(weapon, aircraft)
{
	if(!isdefined(self.pers["flyswattercount"]))
	{
		self.pers["flyswattercount"] = 0;
	}
	self addweaponstat(weapon, "destroyed_aircraft", 1);
	self.pers["flyswattercount"]++;
	if(self.pers["flyswattercount"] == 5)
	{
		self addweaponstat(weapon, "destroyed_5_aircraft", 1);
	}
	if(isdefined(aircraft) && isdefined(aircraft.birthtime))
	{
		if(GetTime() - aircraft.birthtime < 20000)
		{
			self addweaponstat(weapon, "destroyed_aircraft_under20s", 1);
		}
	}
	if(!isdefined(self.destroyedAircraftTime))
	{
		self.destroyedAircraftTime = [];
	}
	if(isdefined(self.destroyedAircraftTime[weapon]) && GetTime() - self.destroyedAircraftTime[weapon] < 10000)
	{
		self addweaponstat(weapon, "destroyed_2aircraft_quickly", 1);
		self.destroyedAircraftTime[weapon] = undefined;
	}
	else
	{
		self.destroyedAircraftTime[weapon] = GetTime();
	}
}

/*
	Name: destroyNonAirScoreStreak_PostStatsLock
	Namespace: challenges
	Checksum: 0x130DAB7B
	Offset: 0x15D8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function destroyNonAirScoreStreak_PostStatsLock(weapon)
{
	self addweaponstat(weapon, "destroyed_aircraft", 1);
}

/*
	Name: canProcessChallenges
	Namespace: challenges
	Checksum: 0x78388B3C
	Offset: 0x1618
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function canProcessChallenges()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported", 0))
		{
			return 1;
		}
	#/
	if(level.rankedMatch || level.arenaMatch || level.wagerMatch || SessionModeIsCampaignGame())
	{
		return 1;
	}
	return 0;
}

/*
	Name: initTeamChallenges
	Namespace: challenges
	Checksum: 0xFB58FFB9
	Offset: 0x1690
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function initTeamChallenges(team)
{
	if(!isdefined(game["challenge"]))
	{
		game["challenge"] = [];
	}
	if(!isdefined(game["challenge"][team]))
	{
		game["challenge"][team] = [];
		game["challenge"][team]["plantedBomb"] = 0;
		game["challenge"][team]["destroyedBombSite"] = 0;
		game["challenge"][team]["capturedFlag"] = 0;
	}
	game["challenge"][team]["allAlive"] = 1;
}

/*
	Name: registerChallengesCallback
	Namespace: challenges
	Checksum: 0x83C7A33
	Offset: 0x1770
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function registerChallengesCallback(callback, func)
{
	if(!isdefined(level.ChallengesCallbacks[callback]))
	{
		level.ChallengesCallbacks[callback] = [];
	}
	level.ChallengesCallbacks[callback][level.ChallengesCallbacks[callback].size] = func;
}

/*
	Name: doChallengeCallback
	Namespace: challenges
	Checksum: 0xBBF11B7C
	Offset: 0x17D8
	Size: 0xE1
	Parameters: 2
	Flags: None
*/
function doChallengeCallback(callback, data)
{
	if(!isdefined(level.ChallengesCallbacks))
	{
		return;
	}
	if(!isdefined(level.ChallengesCallbacks[callback]))
	{
		return;
	}
	if(isdefined(data))
	{
		for(i = 0; i < level.ChallengesCallbacks[callback].size; i++)
		{
			thread [[level.ChallengesCallbacks[callback][i]]](data);
		}
		break;
	}
	for(i = 0; i < level.ChallengesCallbacks[callback].size; i++)
	{
		thread [[level.ChallengesCallbacks[callback][i]]]();
	}
}

/*
	Name: on_player_connect
	Namespace: challenges
	Checksum: 0x25FC86CC
	Offset: 0x18C8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread initChallengeData();
	self thread spawnWatcher();
	self thread monitorReloads();
}

/*
	Name: monitorReloads
	Namespace: challenges
	Checksum: 0x85B59098
	Offset: 0x1920
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function monitorReloads()
{
	self endon("disconnect");
	self endon("killMonitorReloads");
	while(1)
	{
		self waittill("reload");
		currentWeapon = self GetCurrentWeapon();
		if(currentWeapon == level.weaponNone)
		{
			continue;
		}
		time = GetTime();
		self.lastReloadTime = time;
		if(WeaponHasAttachment(currentWeapon, "supply") || WeaponHasAttachment(currentWeapon, "dualclip"))
		{
			self thread reloadThenKill(currentWeapon);
		}
	}
}

/*
	Name: reloadThenKill
	Namespace: challenges
	Checksum: 0x1C42F89F
	Offset: 0x1A00
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function reloadThenKill(reloadWeapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("reloadThenKillTimedOut");
	self notify("reloadThenKillStart");
	self endon("reloadThenKillStart");
	self thread reloadThenKillTimeOut(5);
	for(;;)
	{
		self waittill("killed_enemy_player", time, weapon);
		if(reloadWeapon == weapon)
		{
			self AddPlayerStat("reload_then_kill_dualclip", 1);
		}
	}
}

/*
	Name: reloadThenKillTimeOut
	Namespace: challenges
	Checksum: 0x5B7E30E9
	Offset: 0x1AB8
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function reloadThenKillTimeOut(time)
{
	self endon("disconnect");
	self endon("death");
	self endon("reloadThenKillStart");
	wait(time);
	self notify("reloadThenKillTimedOut");
}

/*
	Name: initChallengeData
	Namespace: challenges
	Checksum: 0xF7854EFA
	Offset: 0x1B08
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function initChallengeData()
{
	self.pers["bulletStreak"] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["stickExplosiveKill"] = 0;
	self.pers["carepackagesCalled"] = 0;
	self.explosiveInfo = [];
}

/*
	Name: isDamageFromPlayerControlledAITank
	Namespace: challenges
	Checksum: 0xDE353EC9
	Offset: 0x1B70
	Size: 0xE1
	Parameters: 3
	Flags: None
*/
function isDamageFromPlayerControlledAITank(eAttacker, eInflictor, weapon)
{
	if(weapon.name == "ai_tank_drone_gun")
	{
		if(isdefined(eAttacker) && isdefined(eAttacker.remoteWeapon) && isdefined(eInflictor))
		{
			if(isdefined(eInflictor.controlled) && eInflictor.controlled)
			{
				if(eAttacker.remoteWeapon == eInflictor)
				{
					return 1;
				}
			}
		}
	}
	else if(weapon.name == "ai_tank_drone_rocket")
	{
		if(isdefined(eInflictor) && !isdefined(eInflictor.from_ai))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: isDamageFromPlayerControlledSentry
	Namespace: challenges
	Checksum: 0x6F8D3828
	Offset: 0x1C60
	Size: 0xA1
	Parameters: 3
	Flags: None
*/
function isDamageFromPlayerControlledSentry(eAttacker, eInflictor, weapon)
{
	if(weapon.name == "auto_gun_turret")
	{
		if(isdefined(eAttacker) && isdefined(eAttacker.remoteWeapon) && isdefined(eInflictor))
		{
			if(eAttacker.remoteWeapon == eInflictor)
			{
				if(isdefined(eInflictor.controlled) && eInflictor.controlled)
				{
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: perkKills
	Namespace: challenges
	Checksum: 0xAD6DFD0B
	Offset: 0x1D10
	Size: 0x6E3
	Parameters: 3
	Flags: None
*/
function perkKills(victim, isStunned, time)
{
	player = self;
	if(player hasPerk("specialty_movefaster"))
	{
		player AddPlayerStat("perk_movefaster_kills", 1);
	}
	if(player hasPerk("specialty_noname"))
	{
		player AddPlayerStat("perk_noname_kills", 1);
	}
	if(player hasPerk("specialty_quieter"))
	{
		player AddPlayerStat("perk_quieter_kills", 1);
	}
	if(player hasPerk("specialty_longersprint"))
	{
		if(isdefined(player.lastSprintTime) && GetTime() - player.lastSprintTime < 2500)
		{
			player AddPlayerStat("perk_longersprint", 1);
		}
	}
	if(player hasPerk("specialty_fastmantle"))
	{
		if(isdefined(player.lastSprintTime) && GetTime() - player.lastSprintTime < 2500 && player PlayerAds() >= 1)
		{
			player AddPlayerStat("perk_fastmantle_kills", 1);
		}
	}
	if(player hasPerk("specialty_loudenemies"))
	{
		player AddPlayerStat("perk_loudenemies_kills", 1);
	}
	if(isStunned == 1 && player hasPerk("specialty_stunprotection"))
	{
		player AddPlayerStat("perk_protection_stun_kills", 1);
	}
	activeEnemyEmp = 0;
	activeCUAV = 0;
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			/#
				Assert(isdefined(level.activeCounterUAVs[team]));
			#/
			/#
				Assert(isdefined(level.ActiveEMPs[team]));
			#/
			if(team == player.team)
			{
				continue;
			}
			if(level.activeCounterUAVs[team] > 0)
			{
				activeCUAV = 1;
			}
			if(level.ActiveEMPs[team] > 0)
			{
				activeEnemyEmp = 1;
			}
		}
		break;
	}
	/#
		Assert(isdefined(level.activeCounterUAVs[victim.entnum]));
	#/
	/#
		Assert(isdefined(level.ActiveEMPs[victim.entnum]));
	#/
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(players[i] != player)
		{
			if(isdefined(level.activeCounterUAVs[players[i].entnum]) && level.activeCounterUAVs[players[i].entnum] > 0)
			{
				activeCUAV = 1;
			}
			if(isdefined(level.ActiveEMPs[players[i].entnum]) && level.ActiveEMPs[players[i].entnum] > 0)
			{
				activeEnemyEmp = 1;
			}
		}
	}
	if(activeCUAV == 1 || activeEnemyEmp == 1)
	{
		if(player hasPerk("specialty_immunecounteruav"))
		{
			player AddPlayerStat("perk_immune_cuav_kills", 1);
		}
	}
	activeUAVVictim = 0;
	if(level.teambased)
	{
		if(level.activeUAVs[victim.team] > 0)
		{
			activeUAVVictim = 1;
		}
	}
	else
	{
		activeUAVVictim = isdefined(level.activeUAVs[victim.entnum]) && level.activeUAVs[victim.entnum] > 0;
	}
	if(activeUAVVictim == 1)
	{
		if(player hasPerk("specialty_gpsjammer"))
		{
			player AddPlayerStat("perk_gpsjammer_immune_kills", 1);
		}
	}
	if(player.lastWeaponChange + 5000 > time)
	{
		if(player hasPerk("specialty_fastweaponswitch"))
		{
			player AddPlayerStat("perk_fastweaponswitch_kill_after_swap", 1);
		}
	}
	if(player.scavenged == 1)
	{
		if(player hasPerk("specialty_scavenger"))
		{
			player AddPlayerStat("perk_scavenger_kills_after_resupply", 1);
		}
	}
}

/*
	Name: flakjacketProtected
	Namespace: challenges
	Checksum: 0xEEFCAAE0
	Offset: 0x2400
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function flakjacketProtected(weapon, attacker)
{
	if(weapon.name == "claymore")
	{
		self.flakJacketClaymore[attacker.clientid] = 1;
	}
	self AddPlayerStat("survive_with_flak", 1);
	self.challenge_lastsurvivewithflakfrom = attacker;
	self.challenge_lastsurvivewithflaktime = GetTime();
}

/*
	Name: earnedKillstreak
	Namespace: challenges
	Checksum: 0x1DF7A9EA
	Offset: 0x2490
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function earnedKillstreak()
{
	if(self util::has_purchased_perk_equipped("specialty_anteup"))
	{
		self AddPlayerStat("earn_scorestreak_anteup", 1);
		if(!isdefined(self.challenge_anteup_earned))
		{
			self.challenge_anteup_earned = 0;
		}
		self.challenge_anteup_earned++;
		if(self.challenge_anteup_earned >= 5)
		{
			self AddPlayerStat("earn_5_scorestreaks_anteup", 1);
			self.challenge_anteup_earned = 0;
		}
	}
}

/*
	Name: genericBulletKill
	Namespace: challenges
	Checksum: 0x893395D7
	Offset: 0x2538
	Size: 0x163
	Parameters: 3
	Flags: None
*/
function genericBulletKill(data, victim, weapon)
{
	player = self;
	time = data.time;
	if(player.pers["lastBulletKillTime"] == time)
	{
		player.pers["bulletStreak"]++;
	}
	else
	{
		player.pers["bulletStreak"] = 1;
	}
	player.pers["lastBulletKillTime"] = time;
	if(data.victim.iDFlagsTime == time)
	{
		if(data.victim.iDFlags & 8)
		{
			player AddPlayerStat("kill_enemy_through_wall", 1);
			if(isdefined(weapon) && WeaponHasAttachment(weapon, "fmj"))
			{
				player AddPlayerStat("kill_enemy_through_wall_with_fmj", 1);
			}
		}
	}
}

/*
	Name: isHighestScoringPlayer
	Namespace: challenges
	Checksum: 0xA22021D3
	Offset: 0x26A8
	Size: 0x189
	Parameters: 1
	Flags: None
*/
function isHighestScoringPlayer(player)
{
	if(!isdefined(player.score) || player.score < 1)
	{
		return 0;
	}
	players = level.players;
	if(level.teambased)
	{
		team = player.pers["team"];
	}
	else
	{
		team = "all";
	}
	highScore = player.score;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].score))
		{
			continue;
		}
		if(players[i] == player)
		{
			continue;
		}
		if(players[i].score < 1)
		{
			continue;
		}
		if(team != "all" && players[i].pers["team"] != team)
		{
			continue;
		}
		if(players[i].score >= highScore)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: spawnWatcher
	Namespace: challenges
	Checksum: 0x14F7D655
	Offset: 0x2840
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function spawnWatcher()
{
	self endon("disconnect");
	self endon("killSpawnMonitor");
	self.pers["stickExplosiveKill"] = 0;
	self.pers["pistolHeadshot"] = 0;
	self.pers["assaultRifleHeadshot"] = 0;
	self.pers["killNemesis"] = 0;
	while(1)
	{
		self waittill("spawned_player");
		self.pers["longshotsPerLife"] = 0;
		self.flakJacketClaymore = [];
		self.weaponKills = [];
		self.attachmentKills = [];
		self.retreivedBlades = 0;
		self.lastReloadTime = 0;
		self.crossbowClipKillCount = 0;
		self thread watchForDTP();
		self thread watchForMantle();
		self thread monitor_player_sprint();
	}
}

/*
	Name: watchForDTP
	Namespace: challenges
	Checksum: 0x3067E610
	Offset: 0x2970
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function watchForDTP()
{
	self endon("disconnect");
	self endon("death");
	self endon("killDTPMonitor");
	self.dtpTime = 0;
	while(1)
	{
		self waittill("dtp_end");
		self.dtpTime = GetTime() + 4000;
	}
}

/*
	Name: watchForMantle
	Namespace: challenges
	Checksum: 0x15CFAF55
	Offset: 0x29D0
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function watchForMantle()
{
	self endon("disconnect");
	self endon("death");
	self endon("killMantleMonitor");
	self.mantleTime = 0;
	while(1)
	{
		self waittill("mantle_start", mantleEndTime);
		self.mantleTime = mantleEndTime;
	}
}

/*
	Name: disarmedHackedCarepackage
	Namespace: challenges
	Checksum: 0xEB574863
	Offset: 0x2A38
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function disarmedHackedCarepackage()
{
	self AddPlayerStat("disarm_hacked_carepackage", 1);
}

/*
	Name: destroyed_car
	Namespace: challenges
	Checksum: 0xDCB700EA
	Offset: 0x2A68
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function destroyed_car()
{
	if(!isdefined(self) || !isPlayer(self))
	{
		return;
	}
	self AddPlayerStat("destroy_car", 1);
}

/*
	Name: killedNemesis
	Namespace: challenges
	Checksum: 0x18F1E175
	Offset: 0x2AC0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function killedNemesis()
{
	self.pers["killNemesis"]++;
	if(self.pers["killNemesis"] >= 5)
	{
		self.pers["killNemesis"] = 0;
		self AddPlayerStat("kill_nemesis", 1);
	}
}

/*
	Name: killWhileDamagingWithHPM
	Namespace: challenges
	Checksum: 0x45E5068D
	Offset: 0x2B30
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function killWhileDamagingWithHPM()
{
	self AddPlayerStat("kill_while_damaging_with_microwave_turret", 1);
}

/*
	Name: longDistanceHatchetKill
	Namespace: challenges
	Checksum: 0x129D8501
	Offset: 0x2B60
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function longDistanceHatchetKill()
{
	self AddPlayerStat("long_distance_hatchet_kill", 1);
}

/*
	Name: blockedSatellite
	Namespace: challenges
	Checksum: 0x749A5640
	Offset: 0x2B90
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function blockedSatellite()
{
	self AddPlayerStat("activate_cuav_while_enemy_satelite_active", 1);
}

/*
	Name: longDistanceKill
	Namespace: challenges
	Checksum: 0x6B89390D
	Offset: 0x2BC0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function longDistanceKill()
{
	self.pers["longshotsPerLife"]++;
	if(self.pers["longshotsPerLife"] >= 3)
	{
		self.pers["longshotsPerLife"] = 0;
		self AddPlayerStat("longshot_3_onelife", 1);
	}
}

/*
	Name: challengeRoundEnd
	Namespace: challenges
	Checksum: 0x7725F298
	Offset: 0x2C30
	Size: 0x169
	Parameters: 1
	Flags: None
*/
function challengeRoundEnd(data)
{
	player = data.player;
	winner = data.winner;
	if(endedEarly(winner))
	{
		return;
	}
	if(level.teambased)
	{
		winnerScore = game["teamScores"][winner];
		loserScore = getLosersTeamScores(winner);
	}
	switch(level.gametype)
	{
		case "sd":
		{
			if(player.team == winner)
			{
				if(game["challenge"][winner]["allAlive"])
				{
					player AddGameTypeStat("round_win_no_deaths", 1);
				}
				if(isdefined(player.lastManSDDefeat3Enemies))
				{
					player AddGameTypeStat("last_man_defeat_3_enemies", 1);
				}
			}
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: roundEnd
	Namespace: challenges
	Checksum: 0xCC098FAB
	Offset: 0x2DA8
	Size: 0x135
	Parameters: 1
	Flags: None
*/
function roundEnd(winner)
{
	wait(0.05);
	data = spawnstruct();
	data.time = GetTime();
	if(level.teambased)
	{
		if(isdefined(winner) && isdefined(level.teams[winner]))
		{
			data.winner = winner;
		}
	}
	else if(isdefined(winner))
	{
		data.winner = winner;
	}
	for(index = 0; index < level.placement["all"].size; index++)
	{
		data.player = level.placement["all"][index];
		if(isdefined(data.player))
		{
			data.place = index;
			doChallengeCallback("roundEnd", data);
		}
	}
}

/*
	Name: gameEnd
	Namespace: challenges
	Checksum: 0xBD746BFE
	Offset: 0x2EE8
	Size: 0x1F5
	Parameters: 1
	Flags: None
*/
function gameEnd(winner)
{
	wait(0.05);
	data = spawnstruct();
	data.time = GetTime();
	if(level.teambased)
	{
		if(isdefined(winner) && isdefined(level.teams[winner]))
		{
			data.winner = winner;
		}
	}
	else if(isdefined(winner) && isPlayer(winner))
	{
		data.winner = winner;
	}
	for(index = 0; index < level.placement["all"].size; index++)
	{
		data.player = level.placement["all"][index];
		data.place = index;
		if(isdefined(data.player))
		{
			doChallengeCallback("gameEnd", data);
		}
		data.player.completedGame = 1;
	}
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index].completedGame) || level.players[index].completedGame != 1)
		{
			scoreevents::processScoreEvent("completed_match", level.players[index]);
		}
	}
}

/*
	Name: getFinalKill
	Namespace: challenges
	Checksum: 0xE528FA30
	Offset: 0x30E8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function getFinalKill(player)
{
	if(isPlayer(player))
	{
		player AddPlayerStat("get_final_kill", 1);
	}
}

/*
	Name: destroyRCBomb
	Namespace: challenges
	Checksum: 0xE9858751
	Offset: 0x3138
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function destroyRCBomb(weapon)
{
	if(!isPlayer(self))
	{
		return;
	}
	self destroyScoreStreak(weapon, 1, 1);
	if(weapon.rootweapon.name == "hatchet")
	{
		self AddPlayerStat("destroy_hcxd_with_hatchet", 1);
	}
}

/*
	Name: capturedCrate
	Namespace: challenges
	Checksum: 0xE15718C6
	Offset: 0x31D8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function capturedCrate(owner)
{
	if(isdefined(self.lastRescuedBy) && isdefined(self.lastRescuedTime))
	{
		if(self.lastRescuedTime + 5000 > GetTime())
		{
			self.lastRescuedBy AddPlayerStat("defend_teammate_who_captured_package", 1);
		}
	}
	if(owner != self && (level.teambased && owner.team != self.team || !level.teambased))
	{
		self AddPlayerStat("capture_enemy_carepackage", 1);
	}
}

/*
	Name: destroyScoreStreak
	Namespace: challenges
	Checksum: 0x7B3EE90D
	Offset: 0x32A0
	Size: 0x3CB
	Parameters: 4
	Flags: None
*/
function destroyScoreStreak(weapon, playerControlled, groundBased, countAsKillstreakVehicle)
{
	if(!isdefined(countAsKillstreakVehicle))
	{
		countAsKillstreakVehicle = 1;
	}
	if(!isPlayer(self))
	{
		return;
	}
	if(isdefined(level.killstreakWeapons[weapon]))
	{
		if(level.killstreakWeapons[weapon] == "dart")
		{
			self AddPlayerStat("destroy_scorestreak_with_dart", 1);
		}
	}
	else if(isdefined(weapon.isHeroWeapon) && weapon.isHeroWeapon == 1)
	{
		self AddPlayerStat("destroy_scorestreak_with_specialist", 1);
	}
	else if(WeaponHasAttachment(weapon, "fmj", "rf"))
	{
		self AddPlayerStat("destroy_scorestreak_rapidfire_fmj", 1);
	}
	if(!isdefined(playerControlled) || playerControlled == 0)
	{
		if(self util::has_cold_blooded_perk_purchased_and_equipped())
		{
			if(groundBased)
			{
				self AddPlayerStat("destroy_ai_scorestreak_coldblooded", 1);
			}
			if(self util::has_blind_eye_perk_purchased_and_equipped())
			{
				if(groundBased)
				{
					self.pers["challenge_destroyed_ground"]++;
				}
				else
				{
					self.pers["challenge_destroyed_air"]++;
				}
				if(self.pers["challenge_destroyed_ground"] > 0 && self.pers["challenge_destroyed_air"] > 0)
				{
					self AddPlayerStat("destroy_air_and_ground_blindeye_coldblooded", 1);
					self.pers["challenge_destroyed_air"] = 0;
					self.pers["challenge_destroyed_ground"] = 0;
				}
			}
		}
	}
	if(!isdefined(self.pers["challenge_destroyed_killstreak"]))
	{
		self.pers["challenge_destroyed_killstreak"] = 0;
	}
	self.pers["challenge_destroyed_killstreak"]++;
	if(self.pers["challenge_destroyed_killstreak"] >= 5)
	{
		self.pers["challenge_destroyed_killstreak"] = 0;
		self addweaponstat(weapon, "destroy_5_killstreak", 1);
		self addweaponstat(weapon, "destroy_5_killstreak_vehicle", 1);
	}
	self addweaponstat(weapon, "destroy_killstreak", 1);
	weaponPickedUp = 0;
	if(isdefined(self.pickedUpWeapons) && isdefined(self.pickedUpWeapons[weapon]))
	{
		weaponPickedUp = 1;
	}
	self addweaponstat(weapon, "destroyed", 1, self.class_num, weaponPickedUp, undefined, self.primaryLoadoutGunSmithVariantIndex, self.secondaryLoadoutGunSmithVariantIndex);
	self thread watchForRapidDestroy(weapon);
}

/*
	Name: watchForRapidDestroy
	Namespace: challenges
	Checksum: 0x4F19127B
	Offset: 0x3678
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function watchForRapidDestroy(weapon)
{
	self endon("disconnect");
	if(!isdefined(self.challenge_previousDestroyWeapon) || self.challenge_previousDestroyWeapon != weapon)
	{
		self.challenge_previousDestroyWeapon = weapon;
		self.challenge_previousDestroyCount = 0;
	}
	else
	{
		self.challenge_previousDestroyCount++;
	}
	self waitTillTimeoutOrDeath(4);
	if(self.challenge_previousDestroyCount > 1)
	{
		self addweaponstat(weapon, "destroy_2_killstreaks_rapidly", 1);
	}
}

/*
	Name: capturedObjective
	Namespace: challenges
	Checksum: 0xEB6F723B
	Offset: 0x3738
	Size: 0x241
	Parameters: 2
	Flags: None
*/
function capturedObjective()
{
System.Exception: Unexpected non-stack operation within jump expression
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‬‪‎⁭⁭⁮‎⁮⁭⁯‭‍⁯⁯⁪⁬‪‎⁪⁮‎⁭‬‪​‍‭⁪‮‪​‮‪⁯‪⁮⁬‪‮‏‮(Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‫⁯⁪​‍⁭​⁫‫⁯‮​‍‬‮‌‪‪‎‫⁫‎‭‫⁪‫⁪⁬‪‍⁮‏‌⁪​‎‎⁯‮‭‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: hackedOrDestroyedEquipment
	Namespace: challenges
	Checksum: 0xFFCA2299
	Offset: 0x3988
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function hackedOrDestroyedEquipment()
{
	if(self util::has_hacker_perk_purchased_and_equipped())
	{
		self AddPlayerStat("perk_hacker_destroy", 1);
	}
}

/*
	Name: bladeKill
	Namespace: challenges
	Checksum: 0x9B76E15
	Offset: 0x39D0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function bladeKill()
{
	if(!isdefined(self.pers["bladeKills"]))
	{
		self.pers["bladeKills"] = 0;
	}
	self.pers["bladeKills"]++;
	if(self.pers["bladeKills"] >= 15)
	{
		self.pers["bladeKills"] = 0;
		self AddPlayerStat("kill_15_with_blade", 1);
	}
}

/*
	Name: destroyedExplosive
	Namespace: challenges
	Checksum: 0xB040179E
	Offset: 0x3A70
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function destroyedExplosive(weapon)
{
	self destroyedEquipment(weapon);
	self AddPlayerStat("destroy_explosive", 1);
}

/*
	Name: assisted
	Namespace: challenges
	Checksum: 0x9BC27188
	Offset: 0x3AC0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function assisted()
{
	self AddPlayerStat("assist", 1);
}

/*
	Name: earnedMicrowaveAssistScore
	Namespace: challenges
	Checksum: 0x306AB679
	Offset: 0x3AF0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function earnedMicrowaveAssistScore(score)
{
	self AddPlayerStat("assist_score_microwave_turret", score);
	self AddPlayerStat("assist_score_killstreak", score);
	self addweaponstat(GetWeapon("microwave_turret_deploy"), "assists", 1);
	self addweaponstat(GetWeapon("microwave_turret_deploy"), "assist_score", score);
}

/*
	Name: earnedCUAVAssistScore
	Namespace: challenges
	Checksum: 0x4D6E7675
	Offset: 0x3BB8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function earnedCUAVAssistScore(score)
{
	self AddPlayerStat("assist_score_cuav", score);
	self AddPlayerStat("assist_score_killstreak", score);
	self addweaponstat(GetWeapon("counteruav"), "assists", 1);
	self addweaponstat(GetWeapon("counteruav"), "assist_score", score);
}

/*
	Name: earnedUAVAssistScore
	Namespace: challenges
	Checksum: 0x9A66C963
	Offset: 0x3C80
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function earnedUAVAssistScore(score)
{
	self AddPlayerStat("assist_score_uav", score);
	self AddPlayerStat("assist_score_killstreak", score);
	self addweaponstat(GetWeapon("uav"), "assists", 1);
	self addweaponstat(GetWeapon("uav"), "assist_score", score);
}

/*
	Name: earnedSatelliteAssistScore
	Namespace: challenges
	Checksum: 0x43B4D283
	Offset: 0x3D48
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function earnedSatelliteAssistScore(score)
{
	self AddPlayerStat("assist_score_satellite", score);
	self AddPlayerStat("assist_score_killstreak", score);
	self addweaponstat(GetWeapon("satellite"), "assists", 1);
	self addweaponstat(GetWeapon("satellite"), "assist_score", score);
}

/*
	Name: earnedEMPAssistScore
	Namespace: challenges
	Checksum: 0x93E62307
	Offset: 0x3E10
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function earnedEMPAssistScore(score)
{
	self AddPlayerStat("assist_score_emp", score);
	self AddPlayerStat("assist_score_killstreak", score);
	self addweaponstat(GetWeapon("emp_turret"), "assists", 1);
	self addweaponstat(GetWeapon("emp_turret"), "assist_score", score);
}

/*
	Name: teamCompletedChallenge
	Namespace: challenges
	Checksum: 0x45B7357E
	Offset: 0x3ED8
	Size: 0xB5
	Parameters: 2
	Flags: None
*/
function teamCompletedChallenge(team, challenge)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].team) && players[i].team == team)
		{
			players[i] AddGameTypeStat(challenge, 1);
		}
	}
}

/*
	Name: endedEarly
	Namespace: challenges
	Checksum: 0x28EDFA1
	Offset: 0x3F98
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function endedEarly(winner)
{
	if(level.hostForcedEnd)
	{
		return 1;
	}
	if(!isdefined(winner))
	{
		return 1;
	}
	if(level.teambased)
	{
		if(winner == "tie")
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: getLosersTeamScores
	Namespace: challenges
	Checksum: 0x40627411
	Offset: 0x3FF0
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function getLosersTeamScores(winner)
{
	teamScores = 0;
	foreach(team in level.teams)
	{
		if(team == winner)
		{
			continue;
		}
		teamScores = teamScores + game["teamScores"][team];
	}
	return teamScores;
}

/*
	Name: didLoserFailChallenge
	Namespace: challenges
	Checksum: 0xE9A0E39F
	Offset: 0x40B8
	Size: 0xB7
	Parameters: 2
	Flags: None
*/
function didLoserFailChallenge(winner, challenge)
{
	foreach(team in level.teams)
	{
		if(team == winner)
		{
			continue;
		}
		if(game["challenge"][team][challenge])
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: challengeGameEnd
	Namespace: challenges
	Checksum: 0x6AACAAFD
	Offset: 0x4178
	Size: 0x56D
	Parameters: 1
	Flags: None
*/
function challengeGameEnd(data)
{
	player = data.player;
	winner = data.winner;
	if(endedEarly(winner))
	{
		return;
	}
	if(level.teambased)
	{
		winnerScore = game["teamScores"][winner];
		loserScore = getLosersTeamScores(winner);
	}
	switch(level.gametype)
	{
		case "tdm":
		{
			if(player.team == winner)
			{
				if(winnerScore >= loserScore + 20)
				{
					player AddGameTypeStat("CRUSH", 1);
				}
			}
			mostKillsLeastDeaths = 1;
			for(index = 0; index < level.placement["all"].size; index++)
			{
				if(level.placement["all"][index].deaths < player.deaths)
				{
					mostKillsLeastDeaths = 0;
				}
				if(level.placement["all"][index].kills > player.kills)
				{
					mostKillsLeastDeaths = 0;
				}
			}
			if(mostKillsLeastDeaths && player.kills > 0 && level.placement["all"].size > 3)
			{
				player AddGameTypeStat("most_kills_least_deaths", 1);
			}
			break;
		}
		case "dm":
		{
			if(player == winner)
			{
				if(level.placement["all"].size >= 2)
				{
					secondPlace = level.placement["all"][1];
					if(player.kills >= secondPlace.kills + 7)
					{
						player AddGameTypeStat("CRUSH", 1);
					}
				}
			}
			break;
		}
		case "ctf":
		{
			if(player.team == winner)
			{
				if(loserScore == 0)
				{
					player AddGameTypeStat("SHUT_OUT", 1);
				}
			}
			break;
		}
		case "dom":
		{
			if(player.team == winner)
			{
				if(winnerScore >= loserScore + 70)
				{
					player AddGameTypeStat("CRUSH", 1);
				}
			}
			break;
		}
		case "hq":
		{
			if(player.team == winner && winnerScore > 0)
			{
				if(winnerScore >= loserScore + 70)
				{
					player AddGameTypeStat("CRUSH", 1);
				}
			}
			break;
		}
		case "koth":
		{
			if(player.team == winner && winnerScore > 0)
			{
				if(winnerScore >= loserScore + 70)
				{
					player AddGameTypeStat("CRUSH", 1);
				}
			}
			if(player.team == winner && winnerScore > 0)
			{
				if(winnerScore >= loserScore + 110)
				{
					player AddGameTypeStat("ANNIHILATION", 1);
				}
			}
			break;
		}
		case "dem":
		{
			if(player.team == game["defenders"] && player.team == winner)
			{
				if(loserScore == 0)
				{
					player AddGameTypeStat("SHUT_OUT", 1);
				}
			}
			break;
		}
		case "sd":
		{
			if(player.team == winner)
			{
				if(loserScore <= 1)
				{
					player AddGameTypeStat("CRUSH", 1);
				}
			}
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: multiKill
	Namespace: challenges
	Checksum: 0x8201B330
	Offset: 0x46F0
	Size: 0x1A3
	Parameters: 2
	Flags: None
*/
function multiKill(killcount, weapon)
{
	if(killcount >= 3 && isdefined(self.lastKillWhenInjured))
	{
		if(self.lastKillWhenInjured + 5000 > GetTime())
		{
			self AddPlayerStat("multikill_3_near_death", 1);
		}
	}
	self addweaponstat(weapon, "doublekill", Int(killcount / 2));
	self addweaponstat(weapon, "triplekill", Int(killcount / 3));
	if(weapon.isHeroWeapon)
	{
		doubleKill = Int(killcount / 2);
		if(doubleKill)
		{
			self AddPlayerStat("MULTIKILL_2_WITH_HEROWEAPON", doubleKill);
		}
		tripleKill = Int(killcount / 3);
		if(tripleKill)
		{
			self AddPlayerStat("MULTIKILL_3_WITH_HEROWEAPON", tripleKill);
		}
	}
}

/*
	Name: domAttackerMultiKill
	Namespace: challenges
	Checksum: 0x914A2A52
	Offset: 0x48A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function domAttackerMultiKill(killcount)
{
	self AddGameTypeStat("kill_2_enemies_capturing_your_objective", 1);
}

/*
	Name: totalDomination
	Namespace: challenges
	Checksum: 0xF7AC4006
	Offset: 0x48D8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function totalDomination(team)
{
	teamCompletedChallenge(team, "control_3_points_3_minutes");
}

/*
	Name: holdFlagEntireMatch
	Namespace: challenges
	Checksum: 0x9BF000A4
	Offset: 0x4910
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function holdFlagEntireMatch(team, label)
{
	switch(label)
	{
		case "_a":
		{
			event = "hold_a_entire_match";
			break;
		}
		case "_b":
		{
			event = "hold_b_entire_match";
			break;
		}
		case "_c":
		{
			event = "hold_c_entire_match";
			break;
		}
		case default:
		{
			return;
		}
	}
	teamCompletedChallenge(team, event);
}

/*
	Name: capturedBFirstMinute
	Namespace: challenges
	Checksum: 0x6A9A9936
	Offset: 0x49B8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function capturedBFirstMinute()
{
	self AddGameTypeStat("capture_b_first_minute", 1);
}

/*
	Name: controlZoneEntirely
	Namespace: challenges
	Checksum: 0x213CEF8E
	Offset: 0x49E8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function controlZoneEntirely(team)
{
	teamCompletedChallenge(team, "control_zone_entirely");
}

/*
	Name: multi_LMG_SMG_Kill
	Namespace: challenges
	Checksum: 0xB6EC8FF8
	Offset: 0x4A20
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function multi_LMG_SMG_Kill()
{
	self AddPlayerStat("multikill_3_lmg_or_smg_hip_fire", 1);
}

/*
	Name: killedZoneAttacker
	Namespace: challenges
	Checksum: 0x80BB8CF7
	Offset: 0x4A50
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function killedZoneAttacker(weapon)
{
	if(weapon.name == "planemortar" || weapon.name == "remote_missile_missile" || weapon.name == "remote_missile_bomblet")
	{
		self thread updatezonemultikills();
	}
}

/*
	Name: killedDog
	Namespace: challenges
	Checksum: 0xA209CB4
	Offset: 0x4AD0
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function killedDog()
{
	origin = self.origin;
	if(level.teambased)
	{
		teammates = util::get_team_alive_players_s(self.team);
		foreach(player in teammates.a)
		{
			if(player == self)
			{
				continue;
			}
			distSq = DistanceSquared(origin, player.origin);
			if(distSq < 57600)
			{
				self AddPlayerStat("killed_dog_close_to_teammate", 1);
				break;
			}
		}
	}
}

/*
	Name: updatezonemultikills
	Namespace: challenges
	Checksum: 0x858D3C0B
	Offset: 0x4C10
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function updatezonemultikills()
{
	self endon("disconnect");
	level endon("game_ended");
	self notify("updateRecentZoneKills");
	self endon("updateRecentZoneKills");
	if(!isdefined(self.recentZoneKillCount))
	{
		self.recentZoneKillCount = 0;
	}
	self.recentZoneKillCount++;
	wait(4);
	if(self.recentZoneKillCount > 1)
	{
		self AddPlayerStat("multikill_2_zone_attackers", 1);
	}
	self.recentZoneKillCount = 0;
}

/*
	Name: multi_RCBomb_Kill
	Namespace: challenges
	Checksum: 0xC993C293
	Offset: 0x4CB0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function multi_RCBomb_Kill()
{
	self AddPlayerStat("multikill_2_with_rcbomb", 1);
}

/*
	Name: multi_RemoteMissile_Kill
	Namespace: challenges
	Checksum: 0x3FB64DC7
	Offset: 0x4CE0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function multi_RemoteMissile_Kill()
{
	self AddPlayerStat("multikill_3_remote_missile", 1);
}

/*
	Name: multi_MGL_Kill
	Namespace: challenges
	Checksum: 0xD2FF9DB5
	Offset: 0x4D10
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function multi_MGL_Kill()
{
	self AddPlayerStat("multikill_3_with_mgl", 1);
}

/*
	Name: immediateCapture
	Namespace: challenges
	Checksum: 0xE97E088
	Offset: 0x4D40
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function immediateCapture()
{
	self AddGameTypeStat("immediate_capture", 1);
}

/*
	Name: killedLastContester
	Namespace: challenges
	Checksum: 0x60FB589F
	Offset: 0x4D70
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function killedLastContester()
{
	self AddGameTypeStat("contest_then_capture", 1);
}

/*
	Name: bothBombsDetonateWithinTime
	Namespace: challenges
	Checksum: 0x1ED52C38
	Offset: 0x4DA0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function bothBombsDetonateWithinTime()
{
	self AddGameTypeStat("both_bombs_detonate_10_seconds", 1);
}

/*
	Name: calledInCarePackage
	Namespace: challenges
	Checksum: 0xBC456E3C
	Offset: 0x4DD0
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function calledInCarePackage()
{
	self.pers["carepackagesCalled"]++;
	if(self.pers["carepackagesCalled"] >= 3)
	{
		self AddPlayerStat("call_in_3_care_packages", 1);
		self.pers["carepackagesCalled"] = 0;
	}
}

/*
	Name: destroyedHelicopter
	Namespace: challenges
	Checksum: 0x5B662697
	Offset: 0x4E48
	Size: 0xA3
	Parameters: 4
	Flags: None
*/
function destroyedHelicopter(attacker, weapon, damageType, playerControlled)
{
	if(!isPlayer(attacker))
	{
		return;
	}
	attacker destroyScoreStreak(weapon, playerControlled, 0);
	if(damageType == "MOD_RIFLE_BULLET" || damageType == "MOD_PISTOL_BULLET")
	{
		attacker AddPlayerStat("destroyed_helicopter_with_bullet", 1);
	}
}

/*
	Name: destroyedQRDrone
	Namespace: challenges
	Checksum: 0xD0EB46DF
	Offset: 0x4EF8
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function destroyedQRDrone(damageType, weapon)
{
	self destroyScoreStreak(weapon, 1, 0);
	self AddPlayerStat("destroy_qrdrone", 1);
	if(damageType == "MOD_RIFLE_BULLET" || damageType == "MOD_PISTOL_BULLET")
	{
		self AddPlayerStat("destroyed_qrdrone_with_bullet", 1);
	}
	self destroyedPlayerControlledAircraft();
}

/*
	Name: destroyedPlayerControlledAircraft
	Namespace: challenges
	Checksum: 0xBC74E46C
	Offset: 0x4FB0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function destroyedPlayerControlledAircraft()
{
	if(self hasPerk("specialty_noname"))
	{
		self AddPlayerStat("destroy_helicopter", 1);
	}
}

/*
	Name: destroyedAircraft
	Namespace: challenges
	Checksum: 0x79F2051F
	Offset: 0x5000
	Size: 0x1FB
	Parameters: 3
	Flags: None
*/
function destroyedAircraft(attacker, weapon, playerControlled)
{
	if(!isPlayer(attacker))
	{
		return;
	}
	attacker destroyScoreStreak(weapon, playerControlled, 0);
	if(isdefined(weapon))
	{
		if(weapon.name == "emp" && attacker util::is_item_purchased("killstreak_emp"))
		{
			attacker AddPlayerStat("destroy_aircraft_with_emp", 1);
		}
		else if(weapon.name == "missile_drone_projectile" || weapon.name == "missile_drone")
		{
			attacker AddPlayerStat("destroy_aircraft_with_missile_drone", 1);
		}
		else if(weapon.isBulletWeapon)
		{
			attacker AddPlayerStat("shoot_aircraft", 1);
		}
	}
	if(attacker util::has_blind_eye_perk_purchased_and_equipped())
	{
		attacker AddPlayerStat("perk_nottargetedbyairsupport_destroy_aircraft", 1);
	}
	attacker AddPlayerStat("destroy_aircraft", 1);
	if(isdefined(playerControlled) && playerControlled == 0)
	{
		if(attacker util::has_blind_eye_perk_purchased_and_equipped())
		{
			attacker AddPlayerStat("destroy_ai_aircraft_using_blindeye", 1);
		}
	}
}

/*
	Name: killstreakTen
	Namespace: challenges
	Checksum: 0xA1F284DB
	Offset: 0x5208
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function killstreakTen()
{
	if(!isdefined(self.class_num))
	{
		return;
	}
	primary = self GetLoadoutItem(self.class_num, "primary");
	if(primary != 0)
	{
		return;
	}
	secondary = self GetLoadoutItem(self.class_num, "secondary");
	if(secondary != 0)
	{
		return;
	}
	primarygrenade = self GetLoadoutItem(self.class_num, "primarygrenade");
	if(primarygrenade != 0)
	{
		return;
	}
	specialgrenade = self GetLoadoutItem(self.class_num, "specialgrenade");
	if(specialgrenade != 0)
	{
		return;
	}
	for(numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++)
	{
		perk = self GetLoadoutItem(self.class_num, "specialty" + numSpecialties + 1);
		if(perk != 0)
		{
			return;
		}
	}
	self AddPlayerStat("killstreak_10_no_weapons_perks", 1);
}

/*
	Name: scavengedGrenade
	Namespace: challenges
	Checksum: 0x43F4FBE6
	Offset: 0x53C0
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function scavengedGrenade()
{
	self endon("disconnect");
	self endon("death");
	self notify("scavengedGrenade");
	self endon("scavengedGrenade");
	self notify("scavenged_primary_grenade");
	for(;;)
	{
		self waittill("lethalGrenadeKill");
		self AddPlayerStat("kill_with_resupplied_lethal_grenade", 1);
	}
}

/*
	Name: stunnedTankWithEMPGrenade
	Namespace: challenges
	Checksum: 0x9CCC5630
	Offset: 0x5438
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function stunnedTankWithEMPGrenade(attacker)
{
	attacker AddPlayerStat("stun_aitank_wIth_emp_grenade", 1);
}

/*
	Name: playerKilled
	Namespace: challenges
	Checksum: 0x9EA5FF6B
	Offset: 0x5470
	Size: 0x16A3
	Parameters: 8
	Flags: None
*/
function playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, sHitLoc, attackerStance, bledOut)
{
	/#
		print(level.gametype);
	#/
	self.anglesOnDeath = self getPlayerAngles();
	if(isdefined(attacker))
	{
		attacker.anglesOnKill = attacker getPlayerAngles();
	}
	if(!isdefined(weapon))
	{
		weapon = level.weaponNone;
	}
	self endon("disconnect");
	data = spawnstruct();
	data.victim = self;
	data.victimOrigin = self.origin;
	data.victimStance = self GetStance();
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.attackerStance = attackerStance;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.weapon = weapon;
	data.sHitLoc = sHitLoc;
	data.time = GetTime();
	data.bledOut = 0;
	if(isdefined(bledOut))
	{
		data.bledOut = bledOut;
	}
	if(isdefined(eInflictor) && isdefined(eInflictor.lastWeaponBeforeToss))
	{
		data.lastWeaponBeforeToss = eInflictor.lastWeaponBeforeToss;
	}
	if(isdefined(eInflictor) && isdefined(eInflictor.ownerWeaponAtLaunch))
	{
		data.ownerWeaponAtLaunch = eInflictor.ownerWeaponAtLaunch;
	}
	wasLockingOn = 0;
	washacked = 0;
	if(isdefined(eInflictor))
	{
		if(isdefined(eInflictor.locking_on))
		{
			wasLockingOn = wasLockingOn | eInflictor.locking_on;
		}
		if(isdefined(eInflictor.locked_on))
		{
			wasLockingOn = wasLockingOn | eInflictor.locked_on;
		}
		washacked = eInflictor util::isHacked();
	}
	wasLockingOn = wasLockingOn & 1 << data.victim.entnum;
	if(wasLockingOn != 0)
	{
		data.wasLockingOn = 1;
	}
	else
	{
		data.wasLockingOn = 0;
	}
	data.washacked = washacked;
	data.wasPlanting = data.victim.isPlanting;
	data.wasUnderwater = data.victim IsPlayerUnderwater();
	if(!isdefined(data.wasPlanting))
	{
		data.wasPlanting = 0;
	}
	data.wasDefusing = data.victim.isDefusing;
	if(!isdefined(data.wasDefusing))
	{
		data.wasDefusing = 0;
	}
	data.victimWeapon = data.victim.currentWeapon;
	data.victimOnGround = data.victim IsOnGround();
	data.victimWasWallRunning = data.victim IsWallRunning();
	data.victimLastStunnedBy = data.victim.lastStunnedBy;
	data.victimWasDoubleJumping = data.victim IsDoubleJumping();
	data.victimCombatEfficiencyLastOnTime = data.victim.combatEfficiencyLastOnTime;
	data.victimSpeedburstLastOnTime = data.victim.speedburstLastOnTime;
	data.victimCombatEfficieny = data.victim ability_util::gadget_is_active(15);
	data.victimflashbackTime = data.victim.flashbackTime;
	data.victimHeroAbilityActive = ability_player::gadget_CheckHeroAbilityKill(data.victim);
	data.victimElectrifiedBy = data.victim.electrifiedBy;
	data.victimHeroAbility = data.victim.heroAbility;
	data.victimWasInSlamState = data.victim IsSlamming();
	data.victimWasLungingWithArmBlades = data.victim IsGadgetMeleeCharging();
	data.victimWasHeatWaveStunned = data.victim isHeatWaveStunned();
	data.victimPowerArmorLastTookDamageTime = data.victim.power_armor_last_took_damage_time;
	data.victimHeroWeaponKillsThisActivation = data.victim.heroWeaponKillsThisActivation;
	data.victimGadgetPower = data.victim GadgetPowerGet(0);
	data.victimGadgetWasActiveLastDamage = data.victim.gadget_was_active_last_damage;
	data.victimIsThiefOrRoulette = data.victim.isThief === 1 || data.victim.isRoulette === 1;
	data.victimHeroAbilityName = data.victim.heroAbilityName;
	if(!isdefined(data.victimflashbackTime))
	{
		data.victimflashbackTime = 0;
	}
	if(!isdefined(data.victimCombatEfficiencyLastOnTime))
	{
		data.victimCombatEfficiencyLastOnTime = 0;
	}
	if(!isdefined(data.victimSpeedburstLastOnTime))
	{
		data.victimSpeedburstLastOnTime = 0;
	}
	data.victimVisionPulseActivateTime = data.victim.visionPulseActivateTime;
	if(!isdefined(data.victimVisionPulseActivateTime))
	{
		data.victimVisionPulseActivateTime = 0;
	}
	data.victimVisionPulseArray = util::array_copy_if_array(data.victim.visionPulseArray);
	data.victimVisionPulseOrigin = data.victim.visionPulseOrigin;
	data.victimVisionPulseOriginArray = util::array_copy_if_array(data.victim.visionPulseOriginArray);
	data.victimAttackersThisSpawn = util::array_copy_if_array(data.victim.attackersThisSpawn);
	data.victim_doublejump_begin = data.victim.challenge_doublejump_begin;
	data.victim_doublejump_end = data.victim.challenge_doublejump_end;
	data.victim_jump_begin = data.victim.challenge_jump_begin;
	data.victim_jump_end = data.victim.challenge_jump_end;
	data.victim_swimming_begin = data.victim.challenge_swimming_begin;
	data.victim_swimming_end = data.victim.challenge_swimming_end;
	data.victim_slide_begin = data.victim.challenge_slide_begin;
	data.victim_slide_end = data.victim.challenge_slide_end;
	data.victim_wallrun_begin = data.victim.challenge_wallrun_begin;
	data.victim_wallrun_end = data.victim.challenge_wallrun_end;
	data.victim_was_drowning = data.victim drown::is_player_drowning();
	if(isdefined(data.victim.activeProximityGrenades))
	{
		data.victimActiveProximityGrenades = [];
		ArrayRemoveValue(data.victim.activeProximityGrenades, undefined);
		foreach(proximityGrenade in data.victim.activeProximityGrenades)
		{
			proximityGrenadeInfo = spawnstruct();
			proximityGrenadeInfo.origin = proximityGrenade.origin;
			data.victimActiveProximityGrenades[data.victimActiveProximityGrenades.size] = proximityGrenadeInfo;
		}
	}
	else if(isdefined(data.victim.activeBouncingBetties))
	{
		data.victimActiveBouncingBetties = [];
		ArrayRemoveValue(data.victim.activeBouncingBetties, undefined);
		foreach(bouncingbetty in data.victim.activeBouncingBetties)
		{
			bouncingBettyInfo = spawnstruct();
			bouncingBettyInfo.origin = bouncingbetty.origin;
			data.victimActiveBouncingBetties[data.victimActiveBouncingBetties.size] = bouncingBettyInfo;
		}
	}
	else if(isPlayer(attacker))
	{
		data.attackerOrigin = data.attacker.origin;
		data.attackerOnGround = data.attacker IsOnGround();
		data.attackerWallRunning = data.attacker IsWallRunning();
		data.attackerDoubleJumping = data.attacker IsDoubleJumping();
		data.attackerTraversing = data.attacker IsTraversing();
		data.attackerSliding = data.attacker IsSliding();
		data.attackerSpeedburst = data.attacker ability_util::gadget_is_active(13);
		data.attackerflashbackTime = data.attacker.flashbackTime;
		data.attackerHeroAbilityActive = ability_player::gadget_CheckHeroAbilityKill(data.attacker);
		data.attackerHeroAbility = data.attacker.heroAbility;
		if(!isdefined(data.attackerflashbackTime))
		{
			data.attackerflashbackTime = 0;
		}
		data.attackerVisionPulseActivateTime = attacker.visionPulseActivateTime;
		if(!isdefined(data.attackerVisionPulseActivateTime))
		{
			data.attackerVisionPulseActivateTime = 0;
		}
		data.attackerVisionPulseArray = util::array_copy_if_array(attacker.visionPulseArray);
		data.attackerVisionPulseOrigin = attacker.visionPulseOrigin;
		if(!isdefined(data.attackerStance))
		{
			data.attackerStance = data.attacker GetStance();
		}
		data.attackerVisionPulseOriginArray = util::array_copy_if_array(attacker.visionPulseOriginArray);
		data.attackerWasFlashed = data.attacker isFlashbanged();
		data.attackerLastFlashedBy = data.attacker.lastFlashedBy;
		data.attackerLastStunnedBy = data.attacker.lastStunnedBy;
		data.attackerLastStunnedTime = data.attacker.lastStunnedTime;
		data.attackerWasConcussed = isdefined(data.attacker.concussionEndTime) && data.attacker.concussionEndTime > GetTime();
		data.attackerWasHeatWaveStunned = data.attacker isHeatWaveStunned();
		data.attackerWasUnderwater = data.attacker IsPlayerUnderwater();
		data.attackerLastFastReloadTime = data.attacker.lastFastReloadTime;
		data.attackerWasSliding = data.attacker IsSliding();
		data.attackerWasSprinting = data.attacker issprinting();
		data.attackerisThief = attacker.isThief === 1;
		data.attackerIsRoulette = attacker.isRoulette === 1;
		data.attacker_doublejump_begin = data.attacker.challenge_doublejump_begin;
		data.attacker_doublejump_end = data.attacker.challenge_doublejump_end;
		data.attacker_jump_begin = data.attacker.challenge_jump_begin;
		data.attacker_jump_end = data.attacker.challenge_jump_end;
		data.attacker_swimming_begin = data.attacker.challenge_swimming_begin;
		data.attacker_swimming_end = data.attacker.challenge_swimming_end;
		data.attacker_slide_begin = data.attacker.challenge_slide_begin;
		data.attacker_slide_end = data.attacker.challenge_slide_end;
		data.attacker_wallrun_begin = data.attacker.challenge_wallrun_begin;
		data.attacker_wallrun_end = data.attacker.challenge_wallrun_end;
		data.attacker_was_drowning = data.attacker drown::is_player_drowning();
		data.attacker_sprint_begin = data.attacker.challenge_sprint_begin;
		data.attacker_sprint_end = data.attacker.challenge_sprint_end;
		data.attacker_wallRanTwoOppositeWallsNoGround = data.attacker.wallRanTwoOppositeWallsNoGround;
		if(level.allow_vehicle_challenge_check === 1 && attacker IsInVehicle())
		{
			vehicle = attacker GetVehicleOccupied();
			if(isdefined(vehicle))
			{
				data.attackerInVehicleArchetype = vehicle.archetype;
			}
		}
	}
	else
	{
		data.attackerOnGround = 0;
		data.attackerWallRunning = 0;
		data.attackerDoubleJumping = 0;
		data.attackerTraversing = 0;
		data.attackerSliding = 0;
		data.attackerSpeedburst = 0;
		data.attackerflashbackTime = 0;
		data.attackerVisionPulseActivateTime = 0;
		data.attackerWasFlashed = 0;
		data.attackerWasConcussed = 0;
		data.attackerHeroAbilityActive = 0;
		data.attackerWasHeatWaveStunned = 0;
		data.attackerStance = "stand";
		data.attackerWasUnderwater = 0;
		data.attackerWasSprinting = 0;
		data.attackerisThief = 0;
		data.attackerIsRoulette = 0;
	}
	if(isdefined(eInflictor))
	{
		if(isdefined(eInflictor.isCooked))
		{
			data.inflictorIsCooked = eInflictor.isCooked;
		}
		else
		{
			data.inflictorIsCooked = 0;
		}
		if(isdefined(eInflictor.challenge_hatchetTossCount))
		{
			data.inflictorChallenge_hatchetTossCount = eInflictor.challenge_hatchetTossCount;
		}
		else
		{
			data.inflictorChallenge_hatchetTossCount = 0;
		}
		if(isdefined(eInflictor.ownerWasSprinting))
		{
			data.inflictorOwnerWasSprinting = eInflictor.ownerWasSprinting;
		}
		else
		{
			data.inflictorOwnerWasSprinting = 0;
		}
		if(isdefined(eInflictor.playerHasEngineerPerk))
		{
			data.inflictorPlayerHasEngineerPerk = eInflictor.playerHasEngineerPerk;
		}
		else
		{
			data.inflictorPlayerHasEngineerPerk = 0;
		}
	}
	else
	{
		data.inflictorIsCooked = 0;
		data.inflictorChallenge_hatchetTossCount = 0;
		data.inflictorOwnerWasSprinting = 0;
		data.inflictorPlayerHasEngineerPerk = 0;
	}
	waitAndProcessPlayerKilledCallback(data);
	data.attacker notify("playerKilledChallengesProcessed");
}

/*
	Name: doScoreEventCallback
	Namespace: challenges
	Checksum: 0x5175AB86
	Offset: 0x6B20
	Size: 0xE1
	Parameters: 2
	Flags: None
*/
function doScoreEventCallback(callback, data)
{
	if(!isdefined(level.scoreEventCallbacks))
	{
		return;
	}
	if(!isdefined(level.scoreEventCallbacks[callback]))
	{
		return;
	}
	if(isdefined(data))
	{
		for(i = 0; i < level.scoreEventCallbacks[callback].size; i++)
		{
			thread [[level.scoreEventCallbacks[callback][i]]](data);
		}
		break;
	}
	for(i = 0; i < level.scoreEventCallbacks[callback].size; i++)
	{
		thread [[level.scoreEventCallbacks[callback][i]]]();
	}
}

/*
	Name: waitAndProcessPlayerKilledCallback
	Namespace: challenges
	Checksum: 0x756AD309
	Offset: 0x6C10
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function waitAndProcessPlayerKilledCallback(data)
{
	if(isdefined(data.attacker))
	{
		data.attacker endon("disconnect");
	}
	wait(0.05);
	util::WaitTillSlowProcessAllowed();
	level thread doChallengeCallback("playerKilled", data);
	level thread doScoreEventCallback("playerKilled", data);
}

/*
	Name: weaponIsKnife
	Namespace: challenges
	Checksum: 0x89D306
	Offset: 0x6CA8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function weaponIsKnife(weapon)
{
	if(weapon == level.weaponBaseMelee || weapon == level.weaponBaseMeleeHeld || weapon == level.weaponBallisticKnife)
	{
		return 1;
	}
	return 0;
}

/*
	Name: eventReceived
	Namespace: challenges
	Checksum: 0x6A03774E
	Offset: 0x6CF8
	Size: 0x461
	Parameters: 1
	Flags: None
*/
function eventReceived(eventName)
{
	self endon("disconnect");
	util::WaitTillSlowProcessAllowed();
	switch(level.gametype)
	{
		case "tdm":
		{
			if(eventName == "killstreak_10")
			{
				self AddGameTypeStat("killstreak_10", 1);
			}
			else if(eventName == "killstreak_15")
			{
				self AddGameTypeStat("killstreak_15", 1);
			}
			else if(eventName == "killstreak_20")
			{
				self AddGameTypeStat("killstreak_20", 1);
			}
			else if(eventName == "multikill_3")
			{
				self AddGameTypeStat("multikill_3", 1);
			}
			else if(eventName == "kill_enemy_who_killed_teammate")
			{
				self AddGameTypeStat("kill_enemy_who_killed_teammate", 1);
			}
			else if(eventName == "kill_enemy_injuring_teammate")
			{
				self AddGameTypeStat("kill_enemy_injuring_teammate", 1);
			}
			break;
		}
		case "dm":
		{
			if(eventName == "killstreak_10")
			{
				self AddGameTypeStat("killstreak_10", 1);
			}
			else if(eventName == "killstreak_15")
			{
				self AddGameTypeStat("killstreak_15", 1);
			}
			else if(eventName == "killstreak_20")
			{
				self AddGameTypeStat("killstreak_20", 1);
			}
			else if(eventName == "killstreak_30")
			{
				self AddGameTypeStat("killstreak_30", 1);
			}
			break;
		}
		case "sd":
		{
			if(eventName == "defused_bomb_last_man_alive")
			{
				self AddGameTypeStat("defused_bomb_last_man_alive", 1);
			}
			else if(eventName == "elimination_and_last_player_alive")
			{
				self AddGameTypeStat("elimination_and_last_player_alive", 1);
			}
			else if(eventName == "killed_bomb_planter")
			{
				self AddGameTypeStat("killed_bomb_planter", 1);
			}
			else if(eventName == "killed_bomb_defuser")
			{
				self AddGameTypeStat("killed_bomb_defuser", 1);
			}
			break;
		}
		case "ctf":
		{
			if(eventName == "kill_flag_carrier")
			{
				self AddGameTypeStat("kill_flag_carrier", 1);
			}
			else if(eventName == "defend_flag_carrier")
			{
				self AddGameTypeStat("defend_flag_carrier", 1);
			}
			break;
		}
		case "dem":
		{
			if(eventName == "killed_bomb_planter")
			{
				self AddGameTypeStat("killed_bomb_planter", 1);
			}
			else if(eventName == "killed_bomb_defuser")
			{
				self AddGameTypeStat("killed_bomb_defuser", 1);
			}
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: monitor_player_sprint
	Namespace: challenges
	Checksum: 0x434C3AD4
	Offset: 0x7168
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function monitor_player_sprint()
{
	self endon("disconnect");
	self endon("killPlayerSprintMonitor");
	self endon("death");
	self.lastSprintTime = undefined;
	while(1)
	{
		self waittill("sprint_begin");
		self waittill("sprint_end");
		self.lastSprintTime = GetTime();
	}
}

/*
	Name: isFlashbanged
	Namespace: challenges
	Checksum: 0x22C30967
	Offset: 0x71D0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function isFlashbanged()
{
	return isdefined(self.flashEndTime) && GetTime() < self.flashEndTime;
}

/*
	Name: isHeatWaveStunned
	Namespace: challenges
	Checksum: 0x9484E149
	Offset: 0x71F8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function isHeatWaveStunned()
{
	return isdefined(self._heat_wave_stuned_end) && GetTime() < self._heat_wave_stuned_end;
}

/*
	Name: trophy_defense
	Namespace: challenges
	Checksum: 0xAED9091F
	Offset: 0x7220
	Size: 0xFD
	Parameters: 2
	Flags: None
*/
function trophy_defense(origin, radius)
{
	if(isdefined(level.challenge_scorestreaksenabled) && level.challenge_scorestreaksenabled == 1)
	{
		entities = GetDamageableEntArray(origin, radius);
		foreach(entity in entities)
		{
			if(isdefined(entity.challenge_isScoreStreak))
			{
				self AddPlayerStat("protect_streak_with_trophy", 1);
				break;
			}
		}
	}
}

/*
	Name: waitTillTimeoutOrDeath
	Namespace: challenges
	Checksum: 0xC223F5D4
	Offset: 0x7328
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function waitTillTimeoutOrDeath(timeout)
{
	self endon("death");
	wait(timeout);
}

