#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scrambler;

/*
	Name: init_shared
	Namespace: scrambler
	Checksum: 0x94FEA33
	Offset: 0x238
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["scrambler_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["scrambler_friendly_light"] = "_t6/misc/fx_equip_light_green";
	level.scramblerHandle = 1;
	level.scramblerVOOuterRadius = 1440000;
	level.scramblerInnerRadius = 250000;
	level.scramblesound = "mpl_scrambler_static";
	level.globalscramblesound = "mpl_cuav_static";
	level.scramblesoundalert = "mpl_scrambler_alert";
	level.scramblesoundping = "mpl_scrambler_ping";
	level.scramblesoundburst = "mpl_scrambler_burst";
	clientfield::register("missile", "scrambler", 1, 1, "int", &spawnedScrambler, 0, 0);
	level.scramblers = [];
	level.playerPersistent = [];
	localClientNum = 0;
	util::waitforclient(localClientNum);
	level thread scramblerUpdate(localClientNum);
	level thread checkForPlayerSwitch();
}

/*
	Name: spawnedScrambler
	Namespace: scrambler
	Checksum: 0x42665048
	Offset: 0x3B0
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function spawnedScrambler(localClientNum, set)
{
	if(!set)
	{
		return;
	}
	if(localClientNum != 0)
	{
		return;
	}
	self spawned(localClientNum, set, 1);
}

/*
	Name: spawnedGlobalScramber
	Namespace: scrambler
	Checksum: 0x9C94BEB0
	Offset: 0x408
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function spawnedGlobalScramber(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!newVal)
	{
		return;
	}
	if(localClientNum != 0)
	{
		return;
	}
	self spawned(localClientNum, newVal, 0);
}

/*
	Name: spawned
	Namespace: scrambler
	Checksum: 0xBA4BA597
	Offset: 0x488
	Size: 0x233
	Parameters: 3
	Flags: None
*/
function spawned(localClientNum, set, isLocalized)
{
	if(!set)
	{
		return;
	}
	if(localClientNum != 0)
	{
		return;
	}
	scramblerHandle = level.scramblerHandle;
	level.scramblerHandle++;
	SIZE = level.scramblers.size;
	level.scramblers[SIZE] = spawnstruct();
	level.scramblers[SIZE].scramblerHandle = scramblerHandle;
	level.scramblers[SIZE].cent = self;
	level.scramblers[SIZE].team = self.team;
	level.scramblers[SIZE].isLocalized = isLocalized;
	level.scramblers[SIZE].sndent = spawn(0, self.origin, "script_origin");
	level.scramblers[SIZE].sndId = -1;
	level.scramblers[SIZE].sndPingEnt = spawn(0, self.origin, "script_origin");
	level.scramblers[SIZE].sndPingId = -1;
	players = level.localPlayers;
	owner = self GetOwner(localClientNum);
	util::local_players_entity_thread(self, &spawnedPerClient, isLocalized, scramblerHandle);
	level thread cleanUpScramblerOnDelete(self, scramblerHandle, isLocalized, localClientNum);
}

/*
	Name: spawnedPerClient
	Namespace: scrambler
	Checksum: 0xF713B19F
	Offset: 0x6C8
	Size: 0x353
	Parameters: 3
	Flags: None
*/
function spawnedPerClient(localClientNum, isLocalized, scramblerHandle)
{
	player = GetLocalPlayer(localClientNum);
	isEnemy = self isEnemyScrambler(localClientNum);
	owner = self GetOwner(localClientNum);
	scramblerIndex = undefined;
	for(i = 0; i < level.scramblers.size; i++)
	{
		if(level.scramblers[i].scramblerHandle == scramblerHandle)
		{
			scramblerIndex = i;
			break;
		}
	}
	if(!isdefined(scramblerIndex))
	{
		return;
	}
	if(!isEnemy)
	{
		if(isLocalized)
		{
			if(owner == player && !IsSpectating(localClientNum, 0))
			{
				player AddFriendlyScrambler(self.origin[0], self.origin[1], scramblerHandle);
			}
			if(isdefined(level.scramblers[scramblerIndex].sndent))
			{
				level.scramblers[scramblerIndex].sndId = level.scramblers[scramblerIndex].sndent PlayLoopSound(level.scramblesoundalert);
				playsound(0, level.scramblesoundburst, level.scramblers[scramblerIndex].sndent.origin);
			}
			if(isdefined(level.scramblers[scramblerIndex].sndPingEnt))
			{
				level.scramblers[scramblerIndex].sndPingId = level.scramblers[scramblerIndex].sndPingEnt PlayLoopSound(level.scramblesoundping);
			}
		}
	}
	else
	{
		scramblesound = level.scramblesound;
		if(isLocalized == 0)
		{
			scramblesound = level.globalscramblesound;
		}
		if(isdefined(level.scramblers[scramblerIndex].sndent))
		{
			level.scramblers[scramblerIndex].sndId = level.scramblers[scramblerIndex].sndent PlayLoopSound(scramblesound);
		}
	}
	self thread FX::blinky_light(localClientNum, "tag_light", level._effect["scrambler_friendly_light"], level._effect["scrambler_enemy_light"]);
}

/*
	Name: scramblerUpdate
	Namespace: scrambler
	Checksum: 0xF5BA1137
	Offset: 0xA28
	Size: 0x8AF
	Parameters: 1
	Flags: None
*/
function scramblerUpdate(localClientNum)
{
	nearestEnemy = level.scramblerVOOuterRadius;
	nearestFriendly = level.scramblerVOOuterRadius;
	for(;;)
	{
		players = level.localPlayers;
		for(localClientNum = 0; localClientNum < players.size; localClientNum++)
		{
			player = players[localClientNum];
			if(!isdefined(player.team))
			{
				continue;
			}
			if(!isdefined(level.playerPersistent[localClientNum]))
			{
				level.playerPersistent[localClientNum] = spawnstruct();
				level.playerPersistent[localClientNum].previousTeam = player.team;
				player removeallFriendlyScramblers();
			}
			if(level.playerPersistent[localClientNum].previousTeam != player.team)
			{
				teamChanged = 1;
				level.playerPersistent[localClientNum].previousTeam = player.team;
			}
			else
			{
				teamChanged = 0;
			}
			enemyScramblerAmount = 0;
			friendlyScramblerAmount = 0;
			nearestEnemy = level.scramblerVOOuterRadius;
			nearestFriendly = level.scramblerVOOuterRadius;
			isGlobalScrambler = 0;
			distToScrambler = level.scramblerVOOuterRadius;
			nearestEnemyScramblerCent = undefined;
			for(i = 0; i < level.scramblers.size; i++)
			{
				if(!isdefined(level.scramblers[i].cent))
				{
					continue;
				}
				if(isdefined(level.scramblers[i].cent.stunned) && level.scramblers[i].cent.stunned)
				{
					level.scramblers[i].cent.reenable = 1;
					player RemoveFriendlyScrambler(level.scramblers[i].scramblerHandle);
					continue;
				}
				else if(isdefined(level.scramblers[i].cent.reenable) && level.scramblers[i].cent.reenable)
				{
					teamChanged = 1;
					level.scramblers[i].cent.reenable = 0;
				}
				if(level.scramblers[i].isLocalized)
				{
					distToScrambler = DistanceSquared(player.origin, level.scramblers[i].cent.origin);
				}
				if(!level.scramblers[i].isLocalized && level.scramblers[i].cent isEnemyScrambler(localClientNum))
				{
					isGlobalScrambler = 1;
				}
				isEnemy = level.scramblers[i].cent isEnemyScrambler(localClientNum);
				if(level.scramblers[i].team != level.scramblers[i].cent.team)
				{
					scramblerTeamChanged = 1;
					level.scramblers[i].team = level.scramblers[i].cent.team;
				}
				else
				{
					scramblerTeamChanged = 0;
				}
				if(teamChanged || scramblerTeamChanged)
				{
					level.scramblers[i] restartSound(isEnemy);
				}
				if(isEnemy)
				{
					if(nearestEnemy > distToScrambler)
					{
						nearestEnemyScramblerCent = level.scramblers[i].cent;
						nearestEnemy = distToScrambler;
					}
					if(level.scramblers[i].isLocalized && (teamChanged || scramblerTeamChanged))
					{
						player RemoveFriendlyScrambler(level.scramblers[i].scramblerHandle);
					}
					continue;
				}
				if(level.scramblers[i].isLocalized)
				{
					if(nearestFriendly > distToScrambler)
					{
						nearestFriendly = distToScrambler;
					}
					owner = level.scramblers[i].cent GetOwner(localClientNum);
					if(owner == player && !IsSpectating(localClientNum, 0))
					{
						if(teamChanged || scramblerTeamChanged)
						{
							player AddFriendlyScrambler(level.scramblers[i].cent.origin[0], level.scramblers[i].cent.origin[1], level.scramblers[i].scramblerHandle);
						}
					}
				}
			}
			if(nearestEnemy < level.scramblerVOOuterRadius)
			{
				enemyVOScramblerAmount = 1 - nearestEnemy - level.scramblerInnerRadius / level.scramblerVOOuterRadius - level.scramblerInnerRadius;
			}
			else
			{
				enemyVOScramblerAmount = 0;
			}
			if(nearestFriendly < level.scramblerInnerRadius)
			{
				friendlyScramblerAmount = 1;
			}
			else if(nearestFriendly < level.scramblerVOOuterRadius)
			{
				friendlyScramblerAmount = 1 - nearestFriendly - level.scramblerInnerRadius / level.scramblerVOOuterRadius - level.scramblerInnerRadius;
			}
			player SetFriendlyScramblerAmount(friendlyScramblerAmount);
			if(level.scramblers.size > 0 && isdefined(nearestEnemyScramblerCent))
			{
				player SetNearestEnemyScrambler(nearestEnemyScramblerCent);
			}
			else
			{
				player ClearNearestEnemyScrambler();
			}
			if(isGlobalScrambler && player hasPerk(localClientNum, "specialty_immunecounteruav") == 0)
			{
				player SetEnemyGlobalScrambler(1);
			}
			else
			{
				player SetEnemyGlobalScrambler(0);
			}
			if(enemyVOScramblerAmount > 1)
			{
				enemyVOScramblerAmount = 1;
			}
			if(GetDvarFloat("snd_futz") != enemyVOScramblerAmount)
			{
				SetDvar("snd_futz", enemyVOScramblerAmount);
			}
		}
		wait(0.25);
		util::waitforallclients();
	}
}

/*
	Name: cleanUpScramblerOnDelete
	Namespace: scrambler
	Checksum: 0x151400E3
	Offset: 0x12E0
	Size: 0x2F5
	Parameters: 4
	Flags: None
*/
function cleanUpScramblerOnDelete(scramblerEnt, scramblerHandle, isLocalized, localClientNum)
{
	scramblerEnt waittill("entityshutdown");
	players = level.localPlayers;
	for(j = 0; j < level.scramblers.size; j++)
	{
		SIZE = level.scramblers.size;
		if(scramblerHandle == level.scramblers[j].scramblerHandle)
		{
			playsound(0, level.scramblesoundburst, level.scramblers[j].sndent.origin);
			level.scramblers[j].sndent delete();
			level.scramblers[j].sndent = self.scramblers[SIZE - 1].sndent;
			level.scramblers[j].sndPingEnt delete();
			level.scramblers[j].sndPingEnt = self.scramblers[SIZE - 1].sndPingEnt;
			level.scramblers[j].cent = level.scramblers[SIZE - 1].cent;
			level.scramblers[j].scramblerHandle = level.scramblers[SIZE - 1].scramblerHandle;
			level.scramblers[j].team = level.scramblers[SIZE - 1].team;
			level.scramblers[j].isLocalized = level.scramblers[SIZE - 1].isLocalized;
			level.scramblers[SIZE - 1] = undefined;
			break;
		}
	}
	if(isLocalized)
	{
		for(i = 0; i < players.size; i++)
		{
			players[i] RemoveFriendlyScrambler(scramblerHandle);
		}
	}
}

/*
	Name: isEnemyScrambler
	Namespace: scrambler
	Checksum: 0x636F277E
	Offset: 0x15E0
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function isEnemyScrambler(localClientNum)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported", 0))
		{
			return 1;
		}
	#/
	enemy = !util::friend_not_foe(localClientNum);
	return enemy;
}

/*
	Name: checkForPlayerSwitch
	Namespace: scrambler
	Checksum: 0xB0DF6B07
	Offset: 0x1648
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function checkForPlayerSwitch()
{
	while(1)
	{
		level waittill("player_switch");
		waittillframeend;
		players = level.localPlayers;
		for(localClientNum = 0; localClientNum < players.size; localClientNum++)
		{
			for(j = 0; j < level.scramblers.size; j++)
			{
				ent = level.scramblers[j].cent;
				ent thread FX::stop_blinky_light(localClientNum);
				ent thread FX::blinky_light(localClientNum, "tag_light", level._effect["scrambler_friendly_light"], level._effect["scrambler_enemy_light"]);
				isEnemy = ent isEnemyScrambler(localClientNum);
				level.scramblers[j] restartSound(isEnemy);
			}
		}
	}
}

/*
	Name: restartSound
	Namespace: scrambler
	Checksum: 0xA7C804A0
	Offset: 0x17A8
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function restartSound(isEnemy)
{
	if(self.sndId != -1)
	{
		self.sndent StopAllLoopSounds(0.1);
		self.sndId = -1;
	}
	if(!isEnemy)
	{
		if(self.isLocalized)
		{
			self.sndId = self.sndent PlayLoopSound(level.scramblesoundalert);
		}
	}
	else
	{
		isLocalized = self.isLocalized;
		scramblesound = level.scramblesound;
		if(isLocalized == 0)
		{
			scramblesound = level.globalscramblesound;
		}
		self.sndId = self.sndent PlayLoopSound(scramblesound);
	}
}

