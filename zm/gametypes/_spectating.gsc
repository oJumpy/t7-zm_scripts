#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace spectating;

/*
	Name: __init__sytem__
	Namespace: spectating
	Checksum: 0xA7F8E255
	Offset: 0x110
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spectating", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spectating
	Checksum: 0x663AE2B6
	Offset: 0x150
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&main);
}

/*
	Name: main
	Namespace: spectating
	Checksum: 0xB3433432
	Offset: 0x180
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function main()
{
	foreach(team in level.teams)
	{
		level.spectateOverride[team] = spawnstruct();
	}
	callback::on_connecting(&on_player_connecting);
}

/*
	Name: on_player_connecting
	Namespace: spectating
	Checksum: 0xCE59167C
	Offset: 0x248
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function on_player_connecting()
{
	callback::on_joined_team(&on_joined_team);
	callback::on_spawned(&on_player_spawned);
	callback::on_joined_spectate(&on_joined_spectate);
}

/*
	Name: on_player_spawned
	Namespace: spectating
	Checksum: 0xF208C339
	Offset: 0x2B8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	self setSpectatePermissions();
}

/*
	Name: on_joined_team
	Namespace: spectating
	Checksum: 0xE6EBF1EC
	Offset: 0x2E8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_joined_team()
{
	self endon("disconnect");
	self setSpectatePermissionsForMachine();
}

/*
	Name: on_joined_spectate
	Namespace: spectating
	Checksum: 0x76AA7F1A
	Offset: 0x318
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_joined_spectate()
{
	self endon("disconnect");
	self setSpectatePermissionsForMachine();
}

/*
	Name: updateSpectateSettings
	Namespace: spectating
	Checksum: 0x8FA82224
	Offset: 0x348
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function updateSpectateSettings()
{
	level endon("game_ended");
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] setSpectatePermissions();
	}
}

/*
	Name: getSplitscreenTeam
	Namespace: spectating
	Checksum: 0x706E7BF1
	Offset: 0x3B0
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
	return self.sessionteam;
}

/*
	Name: OtherLocalPlayerStillAlive
	Namespace: spectating
	Checksum: 0x4B1FF96D
	Offset: 0x488
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function OtherLocalPlayerStillAlive()
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
		if(isalive(level.players[index]))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: allowSpectateAllTeams
	Namespace: spectating
	Checksum: 0x434309F6
	Offset: 0x548
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function allowSpectateAllTeams(Allow)
{
	foreach(team in level.teams)
	{
		self allowSpectateTeam(team, Allow);
	}
}

/*
	Name: allowSpectateAllTeamsExceptTeam
	Namespace: spectating
	Checksum: 0x190F26BB
	Offset: 0x5F0
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function allowSpectateAllTeamsExceptTeam(skip_team, Allow)
{
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		self allowSpectateTeam(team, Allow);
	}
}

/*
	Name: setSpectatePermissions
	Namespace: spectating
	Checksum: 0xFCCC78F2
	Offset: 0x6B0
	Size: 0x523
	Parameters: 0
	Flags: None
*/
function setSpectatePermissions()
{
	team = self.sessionteam;
	if(team == "spectator")
	{
		if(self IsSplitscreen() && !level.Splitscreen)
		{
			team = getSplitscreenTeam();
		}
		if(team == "spectator")
		{
			self allowSpectateAllTeams(1);
			self allowSpectateTeam("freelook", 0);
			self allowSpectateTeam("none", 1);
			self allowSpectateTeam("localplayers", 1);
			return;
		}
	}
	spectateType = level.spectateType;
	switch(spectateType)
	{
		case 0:
		{
			self allowSpectateAllTeams(0);
			self allowSpectateTeam("freelook", 0);
			self allowSpectateTeam("none", 1);
			self allowSpectateTeam("localplayers", 0);
			break;
		}
		case 3:
		{
			if(self IsSplitscreen() && self OtherLocalPlayerStillAlive())
			{
				self allowSpectateAllTeams(0);
				self allowSpectateTeam("none", 0);
				self allowSpectateTeam("freelook", 0);
				self allowSpectateTeam("localplayers", 1);
				break;
			}
		}
		case 1:
		{
			if(!level.teambased)
			{
				self allowSpectateAllTeams(1);
				self allowSpectateTeam("none", 1);
				self allowSpectateTeam("freelook", 0);
				self allowSpectateTeam("localplayers", 1);
			}
			else if(isdefined(team) && isdefined(level.teams[team]))
			{
				self allowSpectateTeam(team, 1);
				self allowSpectateAllTeamsExceptTeam(team, 0);
				self allowSpectateTeam("freelook", 0);
				self allowSpectateTeam("none", 0);
				self allowSpectateTeam("localplayers", 1);
			}
			else
			{
				self allowSpectateAllTeams(0);
				self allowSpectateTeam("freelook", 0);
				self allowSpectateTeam("none", 0);
				self allowSpectateTeam("localplayers", 1);
			}
			break;
		}
		case 2:
		{
			self allowSpectateAllTeams(1);
			self allowSpectateTeam("freelook", 1);
			self allowSpectateTeam("none", 1);
			self allowSpectateTeam("localplayers", 1);
			break;
		}
	}
	if(isdefined(team) && isdefined(level.teams[team]))
	{
		if(isdefined(level.spectateOverride[team].allowFreeSpectate))
		{
			self allowSpectateTeam("freelook", 1);
		}
		if(isdefined(level.spectateOverride[team].allowEnemySpectate))
		{
			self allowSpectateAllTeamsExceptTeam(team, 1);
		}
	}
}

/*
	Name: setSpectatePermissionsForMachine
	Namespace: spectating
	Checksum: 0xC780025D
	Offset: 0xBE0
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function setSpectatePermissionsForMachine()
{
	self setSpectatePermissions();
	if(!self IsSplitscreen())
	{
		return;
	}
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
		level.players[index] setSpectatePermissions();
	}
}

