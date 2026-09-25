#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace bb;

/*
	Name: init_shared
	Namespace: bb
	Checksum: 0x3AAE8D24
	Offset: 0x218
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: bb
	Checksum: 0x1292C834
	Offset: 0x248
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init()
{
	callback::on_connect(&player_init);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: player_init
	Namespace: bb
	Checksum: 0xEAEEDA8
	Offset: 0x298
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function player_init()
{
	self thread on_player_death();
}

/*
	Name: on_player_spawned
	Namespace: bb
	Checksum: 0xA46F1E92
	Offset: 0x2C0
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	self._bbData = [];
	self._bbData["score"] = 0;
	self._bbData["momentum"] = 0;
	self._bbData["spawntime"] = GetTime();
	self._bbData["shots"] = 0;
	self._bbData["hits"] = 0;
}

/*
	Name: on_player_disconnect
	Namespace: bb
	Checksum: 0xEE53C396
	Offset: 0x348
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	for(;;)
	{
		self waittill("disconnect");
		self commit_spawn_data();
		continue;
	}
}

/*
	Name: on_player_death
	Namespace: bb
	Checksum: 0xBDE88803
	Offset: 0x380
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function on_player_death()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("death");
		self commit_spawn_data();
	}
}

/*
	Name: commit_spawn_data
	Namespace: bb
	Checksum: 0xBA180F58
	Offset: 0x3C0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function commit_spawn_data()
{
	/#
		/#
			Assert(isdefined(self._bbData));
		#/
	#/
	if(!isdefined(self._bbData))
	{
		return;
	}
	bbPrint("mpplayerlives", "gametime %d spawnid %d lifescore %d lifemomentum %d lifetime %d name %s", GetTime(), getplayerspawnid(self), self._bbData["score"], self._bbData["momentum"], GetTime() - self._bbData["spawntime"], self.name);
}

/*
	Name: commit_weapon_data
	Namespace: bb
	Checksum: 0x8C564503
	Offset: 0x478
	Size: 0x145
	Parameters: 3
	Flags: None
*/
function commit_weapon_data(spawnid, currentWeapon, time0)
{
	/#
		/#
			Assert(isdefined(self._bbData));
		#/
	#/
	if(!isdefined(self._bbData))
	{
		return;
	}
	time1 = GetTime();
	blackBoxEventName = "mpweapons";
	if(SessionModeIsCampaignGame())
	{
		blackBoxEventName = "cpweapons";
	}
	else if(SessionModeIsZombiesGame())
	{
		blackBoxEventName = "zmweapons";
	}
	bbPrint(blackBoxEventName, "spawnid %d name %s duration %d shots %d hits %d", spawnid, currentWeapon.name, time1 - time0, self._bbData["shots"], self._bbData["hits"]);
	self._bbData["shots"] = 0;
	self._bbData["hits"] = 0;
}

/*
	Name: add_to_stat
	Namespace: bb
	Checksum: 0x8E22CB3C
	Offset: 0x5C8
	Size: 0x55
	Parameters: 2
	Flags: None
*/
function add_to_stat(statName, delta)
{
	if(isdefined(self._bbData) && isdefined(self._bbData[statName]))
	{
		self._bbData[statName] = self._bbData[statName] + delta;
	}
}

/*
	Name: recordBBDataForPlayer
	Namespace: bb
	Checksum: 0xBB0627D7
	Offset: 0x628
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function recordBBDataForPlayer(breadcrumb_Table)
{
	if(isdefined(level.gametype) && level.gametype === "doa")
	{
		return;
	}
	var_2b0e341 = self function_eacb3569();
	if(var_2b0e341 == -1)
	{
		return;
	}
	movementType = "";
	stance = "";
	bbPrint(breadcrumb_Table, "gametime %d lifeIndex %d posx %d posy %d posz %d yaw %d pitch %d movetype %s stance %s", GetTime(), var_2b0e341, self.origin, self.angles[0], self.angles[1], movementType, stance);
}

/*
	Name: recordBlackBoxBreadcrumbData
	Namespace: bb
	Checksum: 0x3C081C84
	Offset: 0x708
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function recordBlackBoxBreadcrumbData(breadcrumb_Table)
{
	level endon("game_ended");
	if(!SessionModeIsOnlineGame() || (isdefined(level.gametype) && level.gametype === "doa"))
	{
		return;
	}
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isalive(player))
			{
				player recordBBDataForPlayer(breadcrumb_Table);
			}
		}
		wait(2);
	}
}

