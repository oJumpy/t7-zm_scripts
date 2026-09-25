#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;

#namespace spawnlogic;

/*
	Name: __init__sytem__
	Namespace: spawnlogic
	Checksum: 0x13EC583F
	Offset: 0x210
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spawnlogic", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spawnlogic
	Checksum: 0x70E22872
	Offset: 0x250
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
	Namespace: spawnlogic
	Checksum: 0xE63CC88E
	Offset: 0x280
	Size: 0x3BB
	Parameters: 0
	Flags: None
*/
function main()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", 0);
		}
		level.storeSpawnData = GetDvarInt("Dev Block strings are not supported");
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", 0);
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", 0.25);
		}
		thread loopbotspawns();
	#/
	level.spawnlogic_deaths = [];
	level.spawnlogic_spawnkills = [];
	level.players = [];
	level.grenades = [];
	level.pipebombs = [];
	level.spawnMins = (0, 0, 0);
	level.spawnMaxs = (0, 0, 0);
	level.spawnMinsMaxsPrimed = 0;
	if(isdefined(level.safespawns))
	{
		for(i = 0; i < level.safespawns.size; i++)
		{
			level.safespawns[i] spawnPointInit();
		}
	}
	else if(GetDvarString("scr_spawn_enemyavoiddist") == "")
	{
		SetDvar("scr_spawn_enemyavoiddist", "800");
	}
	if(GetDvarString("scr_spawn_enemyavoidweight") == "")
	{
		SetDvar("scr_spawn_enemyavoidweight", "0");
	}
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			thread showDeathsDebug();
			thread updateDeathInfoDebug();
			thread profileDebug();
		}
		if(level.storeSpawnData)
		{
			thread allowSpawnDataReading();
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		thread watchSpawnProfile();
		thread spawnGraphCheck();
	#/
}

/*
	Name: findBoxCenter
	Namespace: spawnlogic
	Checksum: 0x741B132F
	Offset: 0x648
	Size: 0x75
	Parameters: 2
	Flags: None
*/
function findBoxCenter(mins, maxs)
{
	center = (0, 0, 0);
	center = maxs - mins;
	center = (center[0] / 2, center[1] / 2, center[2] / 2) + mins;
	return center;
}

/*
	Name: expandMins
	Namespace: spawnlogic
	Checksum: 0x6EC732D3
	Offset: 0x6C8
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function expandMins(mins, point)
{
	if(mins[0] > point[0])
	{
		mins = (point[0], mins[1], mins[2]);
	}
	if(mins[1] > point[1])
	{
		mins = (mins[0], point[1], mins[2]);
	}
	if(mins[2] > point[2])
	{
		mins = (mins[0], mins[1], point[2]);
	}
	return mins;
}

/*
	Name: expandMaxs
	Namespace: spawnlogic
	Checksum: 0x2695103B
	Offset: 0x7A0
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function expandMaxs(maxs, point)
{
	if(maxs[0] < point[0])
	{
		maxs = (point[0], maxs[1], maxs[2]);
	}
	if(maxs[1] < point[1])
	{
		maxs = (maxs[0], point[1], maxs[2]);
	}
	if(maxs[2] < point[2])
	{
		maxs = (maxs[0], maxs[1], point[2]);
	}
	return maxs;
}

/*
	Name: addSpawnPointsInternal
	Namespace: spawnlogic
	Checksum: 0x968F6D4E
	Offset: 0x878
	Size: 0x233
	Parameters: 2
	Flags: None
*/
function addSpawnPointsInternal(team, spawnPointName)
{
	oldSpawnPoints = [];
	if(level.teamSpawnPoints[team].size)
	{
		oldSpawnPoints = level.teamSpawnPoints[team];
	}
	level.teamSpawnPoints[team] = getSpawnpointArray(spawnPointName);
	if(!isdefined(level.Spawnpoints))
	{
		level.Spawnpoints = [];
	}
	for(index = 0; index < level.teamSpawnPoints[team].size; index++)
	{
		spawnpoint = level.teamSpawnPoints[team][index];
		if(!isdefined(spawnpoint.inited))
		{
			spawnpoint spawnPointInit();
			level.Spawnpoints[level.Spawnpoints.size] = spawnpoint;
		}
	}
	for(index = 0; index < oldSpawnPoints.size; index++)
	{
		origin = oldSpawnPoints[index].origin;
		level.spawnMins = expandMins(level.spawnMins, origin);
		level.spawnMaxs = expandMaxs(level.spawnMaxs, origin);
		level.teamSpawnPoints[team][level.teamSpawnPoints[team].size] = oldSpawnPoints[index];
	}
	if(!level.teamSpawnPoints[team].size)
	{
		/#
			println("Dev Block strings are not supported" + spawnPointName + "Dev Block strings are not supported");
		#/
		callback::abort_level();
		wait(1);
		return;
	}
}

/*
	Name: clearSpawnPoints
	Namespace: spawnlogic
	Checksum: 0xCF32EEB9
	Offset: 0xAB8
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function clearSpawnPoints()
{
	foreach(team in level.teams)
	{
		level.teamSpawnPoints[team] = [];
	}
	level.Spawnpoints = [];
	level.unified_spawn_points = undefined;
}

/*
	Name: addSpawnPoints
	Namespace: spawnlogic
	Checksum: 0x6B27C310
	Offset: 0xB60
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function addSpawnPoints(team, spawnPointName)
{
	addSpawnPointClassName(spawnPointName);
	addSpawnPointTeamClassName(team, spawnPointName);
	addSpawnPointsInternal(team, spawnPointName);
}

/*
	Name: rebuildSpawnPoints
	Namespace: spawnlogic
	Checksum: 0x8B7A34BE
	Offset: 0xBC8
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function rebuildSpawnPoints(team)
{
	level.teamSpawnPoints[team] = [];
	for(index = 0; index < level.spawn_point_team_class_names[team].size; index++)
	{
		addSpawnPointsInternal(team, level.spawn_point_team_class_names[team][index]);
	}
}

/*
	Name: placeSpawnPoints
	Namespace: spawnlogic
	Checksum: 0xF05A11B3
	Offset: 0xC50
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function placeSpawnPoints(spawnPointName)
{
	addSpawnPointClassName(spawnPointName);
	Spawnpoints = getSpawnpointArray(spawnPointName);
	/#
		if(!isdefined(level.extraspawnpointsused))
		{
			level.extraspawnpointsused = [];
		}
	#/
	if(!Spawnpoints.size)
	{
		/#
			println("Dev Block strings are not supported" + spawnPointName + "Dev Block strings are not supported");
		#/
		callback::abort_level();
		wait(1);
		return;
	}
	for(index = 0; index < Spawnpoints.size; index++)
	{
		Spawnpoints[index] spawnPointInit();
		/#
			Spawnpoints[index].fakeclassname = spawnPointName;
			level.extraspawnpointsused[level.extraspawnpointsused.size] = Spawnpoints[index];
		#/
	}
}

/*
	Name: dropSpawnPoints
	Namespace: spawnlogic
	Checksum: 0x2828F42
	Offset: 0xD90
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function dropSpawnPoints(spawnPointName)
{
	Spawnpoints = getSpawnpointArray(spawnPointName);
	if(!Spawnpoints.size)
	{
		/#
			println("Dev Block strings are not supported" + spawnPointName + "Dev Block strings are not supported");
		#/
		return;
	}
	for(index = 0; index < Spawnpoints.size; index++)
	{
		Spawnpoints[index] placeSpawnpoint();
	}
}

/*
	Name: addSpawnPointClassName
	Namespace: spawnlogic
	Checksum: 0xA21098C8
	Offset: 0xE48
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function addSpawnPointClassName(spawnPointClassName)
{
	if(!isdefined(level.spawn_point_class_names))
	{
		level.spawn_point_class_names = [];
	}
	level.spawn_point_class_names[level.spawn_point_class_names.size] = spawnPointClassName;
}

/*
	Name: addSpawnPointTeamClassName
	Namespace: spawnlogic
	Checksum: 0x614EF82B
	Offset: 0xE90
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function addSpawnPointTeamClassName(team, spawnPointClassName)
{
	level.spawn_point_team_class_names[team][level.spawn_point_team_class_names[team].size] = spawnPointClassName;
}

/*
	Name: getSpawnpointArray
	Namespace: spawnlogic
	Checksum: 0x121E7D34
	Offset: 0xED0
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function getSpawnpointArray(classname)
{
	Spawnpoints = GetEntArray(classname, "classname");
	if(!isdefined(level.extraspawnpoints) || !isdefined(level.extraspawnpoints[classname]))
	{
		return Spawnpoints;
	}
	for(i = 0; i < level.extraspawnpoints[classname].size; i++)
	{
		Spawnpoints[Spawnpoints.size] = level.extraspawnpoints[classname][i];
	}
	return Spawnpoints;
}

/*
	Name: spawnPointInit
	Namespace: spawnlogic
	Checksum: 0x490B5164
	Offset: 0xF98
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function spawnPointInit()
{
	spawnpoint = self;
	origin = spawnpoint.origin;
	if(!level.spawnMinsMaxsPrimed)
	{
		level.spawnMins = origin;
		level.spawnMaxs = origin;
		level.spawnMinsMaxsPrimed = 1;
	}
	else
	{
		level.spawnMins = expandMins(level.spawnMins, origin);
		level.spawnMaxs = expandMaxs(level.spawnMaxs, origin);
	}
	spawnpoint placeSpawnpoint();
	spawnpoint.FORWARD = AnglesToForward(spawnpoint.angles);
	spawnpoint.sightTracePoint = spawnpoint.origin + VectorScale((0, 0, 1), 50);
	spawnpoint.inited = 1;
}

/*
	Name: getTeamSpawnPoints
	Namespace: spawnlogic
	Checksum: 0x24C23F10
	Offset: 0x10D8
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function getTeamSpawnPoints(team)
{
	return level.teamSpawnPoints[team];
}

/*
	Name: getSpawnpoint_Final
	Namespace: spawnlogic
	Checksum: 0xA35BE266
	Offset: 0x10F8
	Size: 0x23F
	Parameters: 2
	Flags: None
*/
function getSpawnpoint_Final(Spawnpoints, useweights)
{
	bestSpawnPoint = undefined;
	if(!isdefined(Spawnpoints) || Spawnpoints.size == 0)
	{
		return undefined;
	}
	if(!isdefined(useweights))
	{
		useweights = 1;
	}
	if(useweights)
	{
		bestSpawnPoint = getBestWeightedSpawnpoint(Spawnpoints);
		thread spawnWeightDebug(Spawnpoints);
		break;
	}
	for(i = 0; i < Spawnpoints.size; i++)
	{
		if(isdefined(self.lastSpawnPoint) && self.lastSpawnPoint == Spawnpoints[i])
		{
			continue;
		}
		if(positionWouldTelefrag(Spawnpoints[i].origin))
		{
			continue;
		}
		bestSpawnPoint = Spawnpoints[i];
		break;
	}
	if(!isdefined(bestSpawnPoint))
	{
		if(isdefined(self.lastSpawnPoint) && !positionWouldTelefrag(self.lastSpawnPoint.origin))
		{
			for(i = 0; i < Spawnpoints.size; i++)
			{
				if(Spawnpoints[i] == self.lastSpawnPoint)
				{
					bestSpawnPoint = Spawnpoints[i];
					break;
				}
			}
		}
	}
	else if(!isdefined(bestSpawnPoint))
	{
		if(useweights)
		{
			bestSpawnPoint = Spawnpoints[RandomInt(Spawnpoints.size)];
		}
		else
		{
			bestSpawnPoint = Spawnpoints[0];
		}
	}
	self finalizeSpawnpointChoice(bestSpawnPoint);
	/#
		self storeSpawnData(Spawnpoints, useweights, bestSpawnPoint);
	#/
	return bestSpawnPoint;
}

/*
	Name: finalizeSpawnpointChoice
	Namespace: spawnlogic
	Checksum: 0x53F90906
	Offset: 0x1340
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function finalizeSpawnpointChoice(spawnpoint)
{
	time = GetTime();
	self.lastSpawnPoint = spawnpoint;
	self.lastspawntime = time;
	spawnpoint.lastspawnedplayer = self;
	spawnpoint.lastspawntime = time;
}

/*
	Name: getBestWeightedSpawnpoint
	Namespace: spawnlogic
	Checksum: 0xC848704
	Offset: 0x13A0
	Size: 0x2B5
	Parameters: 1
	Flags: None
*/
function getBestWeightedSpawnpoint(Spawnpoints)
{
	maxSightTracedSpawnpoints = 3;
	for(try = 0; try <= maxSightTracedSpawnpoints; try++)
	{
		bestspawnpoints = [];
		bestweight = undefined;
		bestSpawnPoint = undefined;
		for(i = 0; i < Spawnpoints.size; i++)
		{
			if(!isdefined(bestweight) || Spawnpoints[i].weight > bestweight)
			{
				if(positionWouldTelefrag(Spawnpoints[i].origin))
				{
					continue;
				}
				bestspawnpoints = [];
				bestspawnpoints[0] = Spawnpoints[i];
				bestweight = Spawnpoints[i].weight;
				continue;
			}
			if(Spawnpoints[i].weight == bestweight)
			{
				if(positionWouldTelefrag(Spawnpoints[i].origin))
				{
					continue;
				}
				bestspawnpoints[bestspawnpoints.size] = Spawnpoints[i];
			}
		}
		if(bestspawnpoints.size == 0)
		{
			return undefined;
		}
		bestSpawnPoint = bestspawnpoints[RandomInt(bestspawnpoints.size)];
		if(try == maxSightTracedSpawnpoints)
		{
			return bestSpawnPoint;
		}
		if(isdefined(bestSpawnPoint.lastSightTraceTime) && bestSpawnPoint.lastSightTraceTime == GetTime())
		{
			return bestSpawnPoint;
		}
		if(!lastMinuteSightTraces(bestSpawnPoint))
		{
			return bestSpawnPoint;
		}
		penalty = getLosPenalty();
		/#
			if(level.storeSpawnData || level.debugSpawning)
			{
				bestSpawnPoint.spawnData[bestSpawnPoint.spawnData.size] = "Dev Block strings are not supported" + penalty;
			}
		#/
		bestSpawnPoint.weight = bestSpawnPoint.weight - penalty;
		bestSpawnPoint.lastSightTraceTime = GetTime();
	}
}

/*
	Name: checkBad
	Namespace: spawnlogic
	Checksum: 0x7DE1D6AB
	Offset: 0x1660
	Size: 0x155
	Parameters: 1
	Flags: None
*/
function checkBad(spawnpoint)
{
	/#
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(!isalive(player) || player.sessionstate != "Dev Block strings are not supported")
			{
				continue;
			}
			if(level.teambased && player.team == self.team)
			{
				continue;
			}
			losExists = BulletTracePassed(player.origin + VectorScale((0, 0, 1), 50), spawnpoint.sightTracePoint, 0, undefined);
			if(losExists)
			{
				thread badSpawnLine(spawnpoint.sightTracePoint, player.origin + VectorScale((0, 0, 1), 50), self.name, player.name);
			}
		}
	#/
}

/*
	Name: badSpawnLine
	Namespace: spawnlogic
	Checksum: 0x8A759258
	Offset: 0x17C0
	Size: 0xE5
	Parameters: 4
	Flags: None
*/
function badSpawnLine(start, end, name1, name2)
{
	/#
		dist = Distance(start, end);
		for(i = 0; i < 200; i++)
		{
			line(start, end, (1, 0, 0));
			print3d(start, "Dev Block strings are not supported" + name1 + "Dev Block strings are not supported" + dist);
			print3d(end, name2);
			wait(0.05);
		}
	#/
}

/*
	Name: storeSpawnData
	Namespace: spawnlogic
	Checksum: 0xC1DB8BE5
	Offset: 0x18B0
	Size: 0x88B
	Parameters: 3
	Flags: None
*/
function storeSpawnData(Spawnpoints, useweights, bestSpawnPoint)
{
	/#
		if(!isdefined(level.storeSpawnData) || !level.storeSpawnData)
		{
			return;
		}
		level.storeSpawnData = GetDvarInt("Dev Block strings are not supported");
		if(!level.storeSpawnData)
		{
			return;
		}
		if(!isdefined(level.spawnid))
		{
			level.spawnGameID = RandomInt(100);
			level.spawnid = 0;
		}
		if(bestSpawnPoint.classname == "Dev Block strings are not supported")
		{
			return;
		}
		level.spawnid++;
		file = openfile("Dev Block strings are not supported", "Dev Block strings are not supported");
		fPrintFields(file, level.spawnGameID + "Dev Block strings are not supported" + level.spawnid + "Dev Block strings are not supported" + Spawnpoints.size + "Dev Block strings are not supported" + self.name);
		for(i = 0; i < Spawnpoints.size; i++)
		{
			STR = vectostr(Spawnpoints[i].origin) + "Dev Block strings are not supported";
			if(Spawnpoints[i] == bestSpawnPoint)
			{
				STR = STR + "Dev Block strings are not supported";
			}
			else
			{
				STR = STR + "Dev Block strings are not supported";
			}
			if(!useweights)
			{
				STR = STR + "Dev Block strings are not supported";
			}
			else
			{
				STR = STR + Spawnpoints[i].weight + "Dev Block strings are not supported";
			}
			if(!isdefined(Spawnpoints[i].spawnData))
			{
				Spawnpoints[i].spawnData = [];
			}
			if(!isdefined(Spawnpoints[i].sightChecks))
			{
				Spawnpoints[i].sightChecks = [];
			}
			STR = STR + Spawnpoints[i].spawnData.size + "Dev Block strings are not supported";
			for(j = 0; j < Spawnpoints[i].spawnData.size; j++)
			{
				STR = STR + Spawnpoints[i].spawnData[j] + "Dev Block strings are not supported";
			}
			STR = STR + Spawnpoints[i].sightChecks.size + "Dev Block strings are not supported";
			for(j = 0; j < Spawnpoints[i].sightChecks.size; j++)
			{
				STR = STR + Spawnpoints[i].sightChecks[j].penalty + "Dev Block strings are not supported" + vectostr(Spawnpoints[i].origin) + "Dev Block strings are not supported";
			}
			fPrintFields(file, STR);
		}
		obj = spawnstruct();
		getAllAlliedAndEnemyPlayers(obj);
		numAllies = 0;
		numEnemies = 0;
		STR = "Dev Block strings are not supported";
		for(i = 0; i < obj.allies.size; i++)
		{
			if(obj.allies[i] == self)
			{
				continue;
			}
			numAllies++;
			STR = STR + vectostr(obj.allies[i].origin) + "Dev Block strings are not supported";
		}
		for(i = 0; i < obj.enemies.size; i++)
		{
			numEnemies++;
			STR = STR + vectostr(obj.enemies[i].origin) + "Dev Block strings are not supported";
		}
		STR = numAllies + "Dev Block strings are not supported" + numEnemies + "Dev Block strings are not supported" + STR;
		fPrintFields(file, STR);
		otherdata = [];
		if(isdefined(level.bombguy))
		{
			index = otherdata.size;
			otherdata[index] = spawnstruct();
			otherdata[index].origin = level.bombguy.origin + VectorScale((0, 0, 1), 20);
			otherdata[index].text = "Dev Block strings are not supported";
		}
		else if(isdefined(level.bombpos))
		{
			index = otherdata.size;
			otherdata[index] = spawnstruct();
			otherdata[index].origin = level.bombpos;
			otherdata[index].text = "Dev Block strings are not supported";
		}
		if(isdefined(level.flags))
		{
			for(i = 0; i < level.flags.size; i++)
			{
				index = otherdata.size;
				otherdata[index] = spawnstruct();
				otherdata[index].origin = level.flags[i].origin;
				otherdata[index].text = level.flags[i].useObj gameobjects::get_owner_team() + "Dev Block strings are not supported";
			}
		}
		STR = otherdata.size + "Dev Block strings are not supported";
		for(i = 0; i < otherdata.size; i++)
		{
			STR = STR + vectostr(otherdata[i].origin) + "Dev Block strings are not supported" + otherdata[i].text + "Dev Block strings are not supported";
		}
		fPrintFields(file, STR);
		closefile(file);
		thisspawnid = level.spawnGameID + "Dev Block strings are not supported" + level.spawnid;
		self.thisspawnid = thisspawnid;
	#/
}

/*
	Name: readSpawnData
	Namespace: spawnlogic
	Checksum: 0x8A29C334
	Offset: 0x2148
	Size: 0xB33
	Parameters: 2
	Flags: None
*/
function readSpawnData(desiredID, relativepos)
{
	/#
		file = openfile("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(file < 0)
		{
			return;
		}
		oldspawndata = level.curspawndata;
		level.curspawndata = undefined;
		prev = undefined;
		prevThisPlayer = undefined;
		lookingForNextThisPlayer = 0;
		lookingForNext = 0;
		if(isdefined(relativepos) && !isdefined(oldspawndata))
		{
			return;
		}
		while(1)
		{
			if(fReadLn(file) <= 0)
			{
				break;
			}
			data = spawnstruct();
			data.id = fGetArg(file, 0);
			numspawns = Int(fGetArg(file, 1));
			if(numspawns > 256)
			{
				break;
			}
			data.playerName = fGetArg(file, 2);
			data.Spawnpoints = [];
			data.friends = [];
			data.enemies = [];
			data.otherdata = [];
			for(i = 0; i < numspawns; i++)
			{
				if(fReadLn(file) <= 0)
				{
					break;
				}
				spawnpoint = spawnstruct();
				spawnpoint.origin = strtovec(fGetArg(file, 0));
				spawnpoint.winner = Int(fGetArg(file, 1));
				spawnpoint.weight = Int(fGetArg(file, 2));
				spawnpoint.data = [];
				spawnpoint.sightChecks = [];
				if(i == 0)
				{
					data.minweight = spawnpoint.weight;
					data.maxweight = spawnpoint.weight;
				}
				else if(spawnpoint.weight < data.minweight)
				{
					data.minweight = spawnpoint.weight;
				}
				if(spawnpoint.weight > data.maxweight)
				{
					data.maxweight = spawnpoint.weight;
				}
				argnum = 4;
				numdata = Int(fGetArg(file, 3));
				if(numdata > 256)
				{
					break;
				}
				for(j = 0; j < numdata; j++)
				{
					spawnpoint.data[spawnpoint.data.size] = fGetArg(file, argnum);
					argnum++;
				}
				numsightchecks = Int(fGetArg(file, argnum));
				argnum++;
				if(numsightchecks > 256)
				{
					break;
				}
				for(j = 0; j < numsightchecks; j++)
				{
					index = spawnpoint.sightChecks.size;
					spawnpoint.sightChecks[index] = spawnstruct();
					spawnpoint.sightChecks[index].penalty = Int(fGetArg(file, argnum));
					argnum++;
					spawnpoint.sightChecks[index].origin = strtovec(fGetArg(file, argnum));
					argnum++;
				}
				data.Spawnpoints[data.Spawnpoints.size] = spawnpoint;
			}
			if(!isdefined(data.minweight))
			{
				data.minweight = -1;
				data.maxweight = 0;
			}
			if(data.minweight == data.maxweight)
			{
				data.minweight = data.minweight - 1;
			}
			if(fReadLn(file) <= 0)
			{
				break;
			}
			numfriends = Int(fGetArg(file, 0));
			numEnemies = Int(fGetArg(file, 1));
			if(numfriends > 32 || numEnemies > 32)
			{
				break;
			}
			argnum = 2;
			for(i = 0; i < numfriends; i++)
			{
				data.friends[data.friends.size] = strtovec(fGetArg(file, argnum));
				argnum++;
			}
			for(i = 0; i < numEnemies; i++)
			{
				data.enemies[data.enemies.size] = strtovec(fGetArg(file, argnum));
				argnum++;
			}
			if(fReadLn(file) <= 0)
			{
				break;
			}
			numotherdata = Int(fGetArg(file, 0));
			argnum = 1;
			for(i = 0; i < numotherdata; i++)
			{
				otherdata = spawnstruct();
				otherdata.origin = strtovec(fGetArg(file, argnum));
				argnum++;
				otherdata.text = fGetArg(file, argnum);
				argnum++;
				data.otherdata[data.otherdata.size] = otherdata;
			}
			if(isdefined(relativepos))
			{
				if(relativepos == "Dev Block strings are not supported")
				{
					if(data.id == oldspawndata.id)
					{
						level.curspawndata = prevThisPlayer;
						break;
					}
				}
				else if(relativepos == "Dev Block strings are not supported")
				{
					if(data.id == oldspawndata.id)
					{
						level.curspawndata = prev;
						break;
					}
				}
				else if(relativepos == "Dev Block strings are not supported")
				{
					if(lookingForNextThisPlayer)
					{
						level.curspawndata = data;
						break;
					}
					else if(data.id == oldspawndata.id)
					{
						lookingForNextThisPlayer = 1;
					}
				}
				else if(relativepos == "Dev Block strings are not supported")
				{
					if(lookingForNext)
					{
						level.curspawndata = data;
						break;
					}
					else if(data.id == oldspawndata.id)
					{
						lookingForNext = 1;
					}
				}
			}
			else if(data.id == desiredID)
			{
				level.curspawndata = data;
				break;
			}
			prev = data;
			if(isdefined(oldspawndata) && data.playerName == oldspawndata.playerName)
			{
				prevThisPlayer = data;
			}
		}
		closefile(file);
	#/
}

/*
	Name: drawSpawnData
	Namespace: spawnlogic
	Checksum: 0x17A5399A
	Offset: 0x2C88
	Size: 0x473
	Parameters: 0
	Flags: None
*/
function drawSpawnData()
{
	/#
		level notify("drawing_spawn_data");
		level endon("drawing_spawn_data");
		textoffset = VectorScale((0, 0, -1), 12);
		while(1)
		{
			if(!isdefined(level.curspawndata))
			{
				wait(0.5);
				continue;
			}
			for(i = 0; i < level.curspawndata.friends.size; i++)
			{
				print3d(level.curspawndata.friends[i], "Dev Block strings are not supported", (0.5, 1, 0.5), 1, 5);
			}
			for(i = 0; i < level.curspawndata.enemies.size; i++)
			{
				print3d(level.curspawndata.enemies[i], "Dev Block strings are not supported", (1, 0.5, 0.5), 1, 5);
			}
			for(i = 0; i < level.curspawndata.otherdata.size; i++)
			{
				print3d(level.curspawndata.otherdata[i].origin, level.curspawndata.otherdata[i].text, (0.5, 0.75, 1), 1, 2);
			}
			for(i = 0; i < level.curspawndata.Spawnpoints.size; i++)
			{
				SP = level.curspawndata.Spawnpoints[i];
				orig = SP.sightTracePoint;
				if(SP.winner)
				{
					print3d(orig, level.curspawndata.playerName + "Dev Block strings are not supported", (0.5, 0.5, 1), 1, 2);
					orig = orig + textoffset;
				}
				amnt = SP.weight - level.curspawndata.minweight / level.curspawndata.maxweight - level.curspawndata.minweight;
				print3d(orig, "Dev Block strings are not supported" + SP.weight, (1 - amnt, amnt, 0.5));
				orig = orig + textoffset;
				for(j = 0; j < SP.data.size; j++)
				{
					print3d(orig, SP.data[j], (1, 1, 1));
					orig = orig + textoffset;
				}
				for(j = 0; j < SP.sightChecks.size; j++)
				{
					print3d(orig, "Dev Block strings are not supported" + SP.sightChecks[j].penalty, (1, 0.5, 0.5));
					orig = orig + textoffset;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: vectostr
	Namespace: spawnlogic
	Checksum: 0xB721D12E
	Offset: 0x3108
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function vectostr(vec)
{
	/#
		return Int(vec[0]) + "Dev Block strings are not supported" + Int(vec[1]) + "Dev Block strings are not supported" + Int(vec[2]);
	#/
}

/*
	Name: strtovec
	Namespace: spawnlogic
	Checksum: 0x38EDA5A8
	Offset: 0x3190
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function strtovec(STR)
{
	/#
		parts = StrTok(STR, "Dev Block strings are not supported");
		if(parts.size != 3)
		{
			return (0, 0, 0);
		}
		return (Int(parts[0]), Int(parts[1]), Int(parts[2]));
	#/
}

/*
	Name: getSpawnpoint_Random
	Namespace: spawnlogic
	Checksum: 0x3AB2D852
	Offset: 0x3238
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function getSpawnpoint_Random(Spawnpoints)
{
	if(!isdefined(Spawnpoints))
	{
		return undefined;
	}
	for(i = 0; i < Spawnpoints.size; i++)
	{
		j = RandomInt(Spawnpoints.size);
		spawnpoint = Spawnpoints[i];
		Spawnpoints[i] = Spawnpoints[j];
		Spawnpoints[j] = spawnpoint;
	}
	return getSpawnpoint_Final(Spawnpoints, 0);
}

/*
	Name: getAllOtherPlayers
	Namespace: spawnlogic
	Checksum: 0x201D9EF9
	Offset: 0x3308
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function getAllOtherPlayers()
{
	aliveplayers = [];
	for(i = 0; i < level.players.size; i++)
	{
		if(!isdefined(level.players[i]))
		{
			continue;
		}
		player = level.players[i];
		if(player.sessionstate != "playing" || player == self)
		{
			continue;
		}
		if(isdefined(level.customAliveCheck))
		{
			if(![[level.customAliveCheck]](player))
			{
				continue;
			}
		}
		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}

/*
	Name: getAllAlliedAndEnemyPlayers
	Namespace: spawnlogic
	Checksum: 0x8F16F09E
	Offset: 0x33F0
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function getAllAlliedAndEnemyPlayers(obj)
{
	if(level.teambased)
	{
		/#
			Assert(isdefined(level.teams[self.team]));
		#/
		obj.allies = [];
		obj.enemies = [];
		for(i = 0; i < level.players.size; i++)
		{
			if(!isdefined(level.players[i]))
			{
				continue;
			}
			player = level.players[i];
			if(player.sessionstate != "playing" || player == self)
			{
				continue;
			}
			if(isdefined(level.customAliveCheck))
			{
				if(![[level.customAliveCheck]](player))
				{
					continue;
				}
			}
			if(player.team == self.team)
			{
				obj.allies[obj.allies.size] = player;
				continue;
			}
			obj.enemies[obj.enemies.size] = player;
		}
	}
	else
	{
		obj.allies = [];
		obj.enemies = level.activePlayers;
	}
}

/*
	Name: initWeights
	Namespace: spawnlogic
	Checksum: 0xA0B322D1
	Offset: 0x3598
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function initWeights(Spawnpoints)
{
	for(i = 0; i < Spawnpoints.size; i++)
	{
		Spawnpoints[i].weight = 0;
	}
	/#
		if(level.storeSpawnData || level.debugSpawning)
		{
			for(i = 0; i < Spawnpoints.size; i++)
			{
				Spawnpoints[i].spawnData = [];
				Spawnpoints[i].sightChecks = [];
			}
		}
	#/
}

/*
	Name: spawnPointUpdate_zm
	Namespace: spawnlogic
	Checksum: 0xB7BD9453
	Offset: 0x3660
	Size: 0x2C1
	Parameters: 1
	Flags: None
*/
function spawnPointUpdate_zm(spawnpoint)
{
	foreach(team in level.teams)
	{
		spawnpoint.distSum[team] = 0;
		spawnpoint.enemyDistSum[team] = 0;
	}
	players = GetPlayers();
	spawnpoint.numPlayersAtLastUpdate = players.size;
	foreach(player in players)
	{
		if(!isdefined(player))
		{
			break;
		}
		if(player.sessionstate != "playing")
		{
			break;
		}
		if(isdefined(level.customAliveCheck))
		{
			if(![[level.customAliveCheck]](player))
			{
				break;
			}
		}
		dist = Distance(spawnpoint.origin, player.origin);
		spawnpoint.distSum[player.team] = spawnpoint.distSum[player.team] + dist;
		foreach(team in level.teams)
		{
			if(team != player.team)
			{
				spawnpoint.enemyDistSum[team] = spawnpoint.enemyDistSum[team] + dist;
			}
		}
	}
}

/*
	Name: getSpawnpoint_NearTeam
	Namespace: spawnlogic
	Checksum: 0x6BD52E60
	Offset: 0x3930
	Size: 0x5B7
	Parameters: 4
	Flags: None
*/
function getSpawnpoint_NearTeam(Spawnpoints, favoredspawnpoints, forceAllyDistanceWeight, forceEnemyDistanceWeight)
{
	if(!isdefined(Spawnpoints))
	{
		return undefined;
	}
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			return getSpawnpoint_Random(Spawnpoints);
		}
	#/
	if(GetDvarInt("scr_spawnsimple") > 0)
	{
		return getSpawnpoint_Random(Spawnpoints);
	}
	Spawnlogic_Begin();
	k_favored_spawn_point_bonus = 25000;
	initWeights(Spawnpoints);
	obj = spawnstruct();
	getAllAlliedAndEnemyPlayers(obj);
	numPlayers = obj.allies.size + obj.enemies.size;
	alliedDistanceWeight = 2;
	if(isdefined(forceAllyDistanceWeight))
	{
		alliedDistanceWeight = forceAllyDistanceWeight;
	}
	enemyDistanceWeight = 1;
	if(isdefined(forceEnemyDistanceWeight))
	{
		enemyDistanceWeight = forceEnemyDistanceWeight;
	}
	myTeam = self.team;
	for(i = 0; i < Spawnpoints.size; i++)
	{
		spawnpoint = Spawnpoints[i];
		spawnPointUpdate_zm(spawnpoint);
		if(!isdefined(spawnpoint.numPlayersAtLastUpdate))
		{
			spawnpoint.numPlayersAtLastUpdate = 0;
		}
		if(spawnpoint.numPlayersAtLastUpdate > 0)
		{
			allyDistSum = spawnpoint.distSum[myTeam];
			enemyDistSum = spawnpoint.enemyDistSum[myTeam];
			spawnpoint.weight = enemyDistanceWeight * enemyDistSum - alliedDistanceWeight * allyDistSum / spawnpoint.numPlayersAtLastUpdate;
			/#
				if(level.storeSpawnData || level.debugSpawning)
				{
					spawnpoint.spawnData[spawnpoint.spawnData.size] = "Dev Block strings are not supported" + Int(spawnpoint.weight) + "Dev Block strings are not supported" + enemyDistanceWeight + "Dev Block strings are not supported" + Int(enemyDistSum) + "Dev Block strings are not supported" + alliedDistanceWeight + "Dev Block strings are not supported" + Int(allyDistSum) + "Dev Block strings are not supported" + spawnpoint.numPlayersAtLastUpdate;
				}
			#/
			continue;
		}
		spawnpoint.weight = 0;
		/#
			if(level.storeSpawnData || level.debugSpawning)
			{
				spawnpoint.spawnData[spawnpoint.spawnData.size] = "Dev Block strings are not supported";
			}
		#/
	}
	if(isdefined(favoredspawnpoints))
	{
		for(i = 0; i < favoredspawnpoints.size; i++)
		{
			if(isdefined(favoredspawnpoints[i].weight))
			{
				favoredspawnpoints[i].weight = favoredspawnpoints[i].weight + k_favored_spawn_point_bonus;
				continue;
			}
			favoredspawnpoints[i].weight = k_favored_spawn_point_bonus;
		}
	}
	avoidSameSpawn(Spawnpoints);
	avoidSpawnReuse(Spawnpoints, 1);
	avoidWeaponDamage(Spawnpoints);
	avoidVisibleEnemies(Spawnpoints, 1);
	result = getSpawnpoint_Final(Spawnpoints);
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			checkBad(result);
		}
	#/
	return result;
}

/*
	Name: getSpawnpoint_DM
	Namespace: spawnlogic
	Checksum: 0x6C1E115A
	Offset: 0x3EF0
	Size: 0x299
	Parameters: 1
	Flags: None
*/
function getSpawnpoint_DM(Spawnpoints)
{
	if(!isdefined(Spawnpoints))
	{
		return undefined;
	}
	Spawnlogic_Begin();
	initWeights(Spawnpoints);
	aliveplayers = getAllOtherPlayers();
	idealDist = 1600;
	badDist = 1200;
	if(aliveplayers.size > 0)
	{
		for(i = 0; i < Spawnpoints.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for(j = 0; j < aliveplayers.size; j++)
			{
				dist = Distance(Spawnpoints[i].origin, aliveplayers[j].origin);
				if(dist < badDist)
				{
					nearbyBadAmount = nearbyBadAmount + badDist - dist / badDist;
				}
				distfromideal = Abs(dist - idealDist);
				totalDistFromIdeal = totalDistFromIdeal + distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			wellDistancedAmount = idealDist - avgDistFromIdeal / idealDist;
			Spawnpoints[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + RandomFloat(0.2);
		}
	}
	avoidSameSpawn(Spawnpoints);
	avoidSpawnReuse(Spawnpoints, 0);
	avoidWeaponDamage(Spawnpoints);
	avoidVisibleEnemies(Spawnpoints, 0);
	return getSpawnpoint_Final(Spawnpoints);
}

/*
	Name: getSpawnpoint_Turned
	Namespace: spawnlogic
	Checksum: 0x7FB84081
	Offset: 0x4198
	Size: 0x371
	Parameters: 5
	Flags: None
*/
function getSpawnpoint_Turned(Spawnpoints, idealDist, badDist, idealDistTeam, badDistTeam)
{
	if(!isdefined(Spawnpoints))
	{
		return undefined;
	}
	Spawnlogic_Begin();
	initWeights(Spawnpoints);
	aliveplayers = getAllOtherPlayers();
	if(!isdefined(idealDist))
	{
		idealDist = 1600;
	}
	if(!isdefined(idealDistTeam))
	{
		idealDistTeam = 1200;
	}
	if(!isdefined(badDist))
	{
		badDist = 1200;
	}
	if(!isdefined(badDistTeam))
	{
		badDistTeam = 600;
	}
	myTeam = self.team;
	if(aliveplayers.size > 0)
	{
		for(i = 0; i < Spawnpoints.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for(j = 0; j < aliveplayers.size; j++)
			{
				dist = Distance(Spawnpoints[i].origin, aliveplayers[j].origin);
				distfromideal = 0;
				if(aliveplayers[j].team == myTeam)
				{
					if(dist < badDistTeam)
					{
						nearbyBadAmount = nearbyBadAmount + badDistTeam - dist / badDistTeam;
					}
					distfromideal = Abs(dist - idealDistTeam);
				}
				else if(dist < badDist)
				{
					nearbyBadAmount = nearbyBadAmount + badDist - dist / badDist;
				}
				distfromideal = Abs(dist - idealDist);
				totalDistFromIdeal = totalDistFromIdeal + distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			wellDistancedAmount = idealDist - avgDistFromIdeal / idealDist;
			Spawnpoints[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + RandomFloat(0.2);
		}
	}
	avoidSameSpawn(Spawnpoints);
	avoidSpawnReuse(Spawnpoints, 0);
	avoidWeaponDamage(Spawnpoints);
	avoidVisibleEnemies(Spawnpoints, 0);
	return getSpawnpoint_Final(Spawnpoints);
}

/*
	Name: Spawnlogic_Begin
	Namespace: spawnlogic
	Checksum: 0xAF347363
	Offset: 0x4518
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function Spawnlogic_Begin()
{
	/#
		level.storeSpawnData = GetDvarInt("Dev Block strings are not supported");
		level.debugSpawning = GetDvarInt("Dev Block strings are not supported") > 0;
	#/
}

/*
	Name: watchSpawnProfile
	Namespace: spawnlogic
	Checksum: 0xDAB55FF4
	Offset: 0x4570
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function watchSpawnProfile()
{
	/#
		while(1)
		{
			while(1)
			{
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					break;
				}
				wait(0.05);
			}
			thread spawnProfile();
			while(1)
			{
				if(GetDvarInt("Dev Block strings are not supported") <= 0)
				{
					break;
				}
				wait(0.05);
			}
			level notify("stop_spawn_profile");
		}
	#/
}

/*
	Name: spawnProfile
	Namespace: spawnlogic
	Checksum: 0x540B0A0A
	Offset: 0x4620
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function spawnProfile()
{
	/#
		level endon("stop_spawn_profile");
		while(1)
		{
			if(level.players.size > 0 && level.Spawnpoints.size > 0)
			{
				playerNum = RandomInt(level.players.size);
				player = level.players[playerNum];
				attempt = 1;
				while(!isdefined(player) && attempt < level.players.size)
				{
					playerNum = playerNum + 1 % level.players.size;
					attempt++;
					player = level.players[playerNum];
				}
				player getSpawnpoint_NearTeam(level.Spawnpoints);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: spawnGraphCheck
	Namespace: spawnlogic
	Checksum: 0x929DA1D3
	Offset: 0x4738
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function spawnGraphCheck()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") < 1)
			{
				wait(3);
				continue;
			}
			thread spawnGraph();
			return;
		}
	#/
}

/*
	Name: spawnGraph
	Namespace: spawnlogic
	Checksum: 0xE787AA5F
	Offset: 0x47A0
	Size: 0x64F
	Parameters: 0
	Flags: None
*/
function spawnGraph()
{
	/#
		w = 20;
		h = 20;
		weightscale = 0.1;
		fakespawnpoints = [];
		corners = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(corners.size != 2)
		{
			println("Dev Block strings are not supported");
			return;
		}
		min = corners[0].origin;
		max = corners[0].origin;
		if(corners[1].origin[0] > max[0])
		{
			max = (corners[1].origin[0], max[1], max[2]);
		}
		else
		{
			min = (corners[1].origin[0], min[1], min[2]);
		}
		if(corners[1].origin[1] > max[1])
		{
			max = (max[0], corners[1].origin[1], max[2]);
		}
		else
		{
			min = (min[0], corners[1].origin[1], min[2]);
		}
		i = 0;
		for(y = 0; y < h; y++)
		{
			yamnt = y / h - 1;
			for(x = 0; x < w; x++)
			{
				xamnt = x / w - 1;
				fakespawnpoints[i] = spawnstruct();
				fakespawnpoints[i].origin = (min[0] * xamnt + max[0] * 1 - xamnt, min[1] * yamnt + max[1] * 1 - yamnt, min[2]);
				fakespawnpoints[i].angles = (0, 0, 0);
				fakespawnpoints[i].FORWARD = AnglesToForward(fakespawnpoints[i].angles);
				fakespawnpoints[i].sightTracePoint = fakespawnpoints[i].origin;
				i++;
			}
		}
		didweights = 0;
		while(1)
		{
			spawni = 0;
			numiters = 5;
			for(i = 0; i < numiters; i++)
			{
				if(!level.players.size || !isdefined(level.players[0].team) || level.players[0].team == "Dev Block strings are not supported" || !isdefined(level.players[0].curClass))
				{
					break;
				}
				endspawni = spawni + fakespawnpoints.size / numiters;
				if(i == numiters - 1)
				{
					endspawni = fakespawnpoints.size;
				}
				while(spawni < endspawni)
				{
					spawnPointUpdate(fakespawnpoints[spawni]);
					spawni++;
				}
				if(didweights)
				{
					level.players[0] drawSpawnGraph(fakespawnpoints, w, h, weightscale);
				}
				wait(0.05);
			}
			if(!level.players.size || !isdefined(level.players[0].team) || level.players[0].team == "Dev Block strings are not supported" || !isdefined(level.players[0].curClass))
			{
				wait(1);
				continue;
			}
			level.players[0] getSpawnpoint_NearTeam(fakespawnpoints);
			for(i = 0; i < fakespawnpoints.size; i++)
			{
				setupSpawnGraphPoint(fakespawnpoints[i], weightscale);
			}
			didweights = 1;
			level.players[0] drawSpawnGraph(fakespawnpoints, w, h, weightscale);
			wait(0.05);
		}
	#/
}

/*
	Name: drawSpawnGraph
	Namespace: spawnlogic
	Checksum: 0x5B6B27CB
	Offset: 0x4DF8
	Size: 0x145
	Parameters: 4
	Flags: None
*/
function drawSpawnGraph(fakespawnpoints, w, h, weightscale)
{
	/#
		i = 0;
		for(y = 0; y < h; y++)
		{
			yamnt = y / h - 1;
			for(x = 0; x < w; x++)
			{
				xamnt = x / w - 1;
				if(y > 0)
				{
					spawnGraphLine(fakespawnpoints[i], fakespawnpoints[i - w], weightscale);
				}
				if(x > 0)
				{
					spawnGraphLine(fakespawnpoints[i], fakespawnpoints[i - 1], weightscale);
				}
				i++;
			}
		}
	#/
}

/*
	Name: setupSpawnGraphPoint
	Namespace: spawnlogic
	Checksum: 0xAC5C3DEA
	Offset: 0x4F48
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function setupSpawnGraphPoint(s1, weightscale)
{
	/#
		s1.visible = 1;
		if(s1.weight < -1000 / weightscale)
		{
			s1.visible = 0;
		}
	#/
}

/*
	Name: spawnGraphLine
	Namespace: spawnlogic
	Checksum: 0x64048E45
	Offset: 0x4FB0
	Size: 0xDB
	Parameters: 3
	Flags: None
*/
function spawnGraphLine(s1, s2, weightscale)
{
	/#
		if(!s1.visible || !s2.visible)
		{
			return;
		}
		p1 = s1.origin + (0, 0, s1.weight * weightscale + 100);
		p2 = s2.origin + (0, 0, s2.weight * weightscale + 100);
		line(p1, p2, (1, 1, 1));
	#/
}

/*
	Name: loopbotspawns
	Namespace: spawnlogic
	Checksum: 0x98CEA030
	Offset: 0x5098
	Size: 0x363
	Parameters: 0
	Flags: None
*/
function loopbotspawns()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") < 1)
			{
				wait(3);
				continue;
			}
			if(!isdefined(level.players))
			{
				wait(0.05);
				continue;
			}
			bots = [];
			for(i = 0; i < level.players.size; i++)
			{
				if(!isdefined(level.players[i]))
				{
					continue;
				}
				if(level.players[i].sessionstate == "Dev Block strings are not supported" && IsSubStr(level.players[i].name, "Dev Block strings are not supported"))
				{
					bots[bots.size] = level.players[i];
				}
			}
			if(bots.size > 0)
			{
				if(GetDvarInt("Dev Block strings are not supported") == 1)
				{
					killer = bots[RandomInt(bots.size)];
					victim = bots[RandomInt(bots.size)];
					victim thread [[level.callbackPlayerDamage]](killer, killer, 1000, 0, "Dev Block strings are not supported", level.weaponNone, (0, 0, 0), (0, 0, 0), "Dev Block strings are not supported", 0, 0);
					break;
				}
				numKills = GetDvarInt("Dev Block strings are not supported");
				lastVictim = undefined;
				for(index = 0; index < numKills; index++)
				{
					killer = bots[RandomInt(bots.size)];
					for(victim = bots[RandomInt(bots.size)]; isdefined(lastVictim) && victim == lastVictim;  = bots[RandomInt(bots.size)])
					{
					}
					victim thread [[level.callbackPlayerDamage]](killer, killer, 1000, 0, "Dev Block strings are not supported", level.weaponNone, (0, 0, 0), (0, 0, 0), "Dev Block strings are not supported", 0, 0);
					lastVictim = victim;
				}
			}
			else if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
			{
				wait(GetDvarFloat("Dev Block strings are not supported"));
			}
			else
			{
				wait(0.05);
			}
		}
	#/
}

/*
	Name: allowSpawnDataReading
	Namespace: spawnlogic
	Checksum: 0xD7C6A2F5
	Offset: 0x5408
	Size: 0x1E7
	Parameters: 0
	Flags: None
*/
function allowSpawnDataReading()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		prevval = GetDvarString("Dev Block strings are not supported");
		prevrelval = GetDvarString("Dev Block strings are not supported");
		readthistime = 0;
		while(1)
		{
			VAL = GetDvarString("Dev Block strings are not supported");
			relval = undefined;
			if(!isdefined(VAL) || VAL == prevval)
			{
				relval = GetDvarString("Dev Block strings are not supported");
				if(isdefined(relval) && relval != "Dev Block strings are not supported")
				{
					SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				}
				else
				{
					wait(0.5);
					continue;
				}
			}
			prevval = VAL;
			readthistime = 0;
			readSpawnData(VAL, relval);
			if(!isdefined(level.curspawndata))
			{
				println("Dev Block strings are not supported");
			}
			else
			{
				println("Dev Block strings are not supported" + level.curspawndata.id);
			}
			thread drawSpawnData();
		}
	#/
}

/*
	Name: showDeathsDebug
	Namespace: spawnlogic
	Checksum: 0xF11662C6
	Offset: 0x55F8
	Size: 0x4AF
	Parameters: 0
	Flags: None
*/
function showDeathsDebug()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				wait(3);
				continue;
			}
			time = GetTime();
			for(i = 0; i < level.spawnlogic_deaths.size; i++)
			{
				if(isdefined(level.spawnlogic_deaths[i].los))
				{
					line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killOrg, (1, 0, 0));
				}
				else
				{
					line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killOrg, (1, 1, 1));
				}
				killer = level.spawnlogic_deaths[i].killer;
				if(isdefined(killer) && isalive(killer))
				{
					line(level.spawnlogic_deaths[i].killOrg, killer.origin, (0.4, 0.4, 0.8));
				}
			}
			for(p = 0; p < level.players.size; p++)
			{
				if(!isdefined(level.players[p]))
				{
					continue;
				}
				if(isdefined(level.players[p].spawnlogic_killdist))
				{
					print3d(level.players[p].origin + VectorScale((0, 0, 1), 64), level.players[p].spawnlogic_killdist, (1, 1, 1));
				}
			}
			oldspawnkills = level.spawnlogic_spawnkills;
			level.spawnlogic_spawnkills = [];
			for(i = 0; i < oldspawnkills.size; i++)
			{
				spawnkill = oldspawnkills[i];
				if(spawnkill.dierwasspawner)
				{
					line(spawnkill.spawnpointorigin, spawnkill.dierorigin, (0.4, 0.5, 0.4));
					line(spawnkill.dierorigin, spawnkill.killerorigin, (0, 1, 1));
					print3d(spawnkill.dierorigin + VectorScale((0, 0, 1), 32), "Dev Block strings are not supported", (0, 1, 1));
				}
				else
				{
					line(spawnkill.spawnpointorigin, spawnkill.killerorigin, (0.4, 0.5, 0.4));
					line(spawnkill.killerorigin, spawnkill.dierorigin, (0, 1, 1));
					print3d(spawnkill.dierorigin + VectorScale((0, 0, 1), 32), "Dev Block strings are not supported", (0, 1, 1));
				}
				if(time - spawnkill.time < 60000)
				{
					level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = oldspawnkills[i];
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: updateDeathInfoDebug
	Namespace: spawnlogic
	Checksum: 0x27E6C2D3
	Offset: 0x5AB0
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function updateDeathInfoDebug()
{
	while(1)
	{
		if(GetDvarString("scr_spawnpointdebug") == "0")
		{
			wait(3);
			continue;
		}
		updateDeathInfo();
		wait(3);
	}
}

/*
	Name: spawnWeightDebug
	Namespace: spawnlogic
	Checksum: 0xEAA47D9B
	Offset: 0x5B10
	Size: 0x313
	Parameters: 1
	Flags: None
*/
function spawnWeightDebug(Spawnpoints)
{
	level notify("stop_spawn_weight_debug");
	level endon("stop_spawn_weight_debug");
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				wait(3);
				continue;
			}
			textoffset = VectorScale((0, 0, -1), 12);
			for(i = 0; i < Spawnpoints.size; i++)
			{
				amnt = 1 * 1 - Spawnpoints[i].weight / -100000;
				if(amnt < 0)
				{
					amnt = 0;
				}
				if(amnt > 1)
				{
					amnt = 1;
				}
				orig = Spawnpoints[i].origin + VectorScale((0, 0, 1), 80);
				print3d(orig, Int(Spawnpoints[i].weight), (1, amnt, 0.5));
				orig = orig + textoffset;
				if(isdefined(Spawnpoints[i].spawnData))
				{
					for(j = 0; j < Spawnpoints[i].spawnData.size; j++)
					{
						print3d(orig, Spawnpoints[i].spawnData[j], VectorScale((1, 1, 1), 0.5));
						orig = orig + textoffset;
					}
				}
				else if(isdefined(Spawnpoints[i].sightChecks))
				{
					for(j = 0; j < Spawnpoints[i].sightChecks.size; j++)
					{
						if(Spawnpoints[i].sightChecks[j].penalty == 0)
						{
							continue;
						}
						print3d(orig, "Dev Block strings are not supported" + Spawnpoints[i].sightChecks[j].penalty, VectorScale((1, 1, 1), 0.5));
						orig = orig + textoffset;
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: profileDebug
	Namespace: spawnlogic
	Checksum: 0xE733E3A6
	Offset: 0x5E30
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function profileDebug()
{
	while(1)
	{
		if(GetDvarString("scr_spawnpointprofile") != "1")
		{
			wait(3);
			continue;
		}
		for(i = 0; i < level.Spawnpoints.size; i++)
		{
			level.Spawnpoints[i].weight = RandomInt(10000);
		}
		if(level.players.size > 0)
		{
			level.players[RandomInt(level.players.size)] getSpawnpoint_NearTeam(level.Spawnpoints);
		}
		wait(0.05);
	}
}

/*
	Name: debugNearbyPlayers
	Namespace: spawnlogic
	Checksum: 0x7BA1D82
	Offset: 0x5F28
	Size: 0xDF
	Parameters: 2
	Flags: None
*/
function debugNearbyPlayers(players, origin)
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			return;
		}
		startTime = GetTime();
		while(1)
		{
			for(i = 0; i < players.size; i++)
			{
				line(players[i].origin, origin, (0.5, 1, 0.5));
			}
			if(GetTime() - startTime > 5000)
			{
				return;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: deathOccured
	Namespace: spawnlogic
	Checksum: 0xE5057095
	Offset: 0x6010
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function deathOccured(dier, killer)
{
}

/*
	Name: checkForSimilarDeaths
	Namespace: spawnlogic
	Checksum: 0x69B44222
	Offset: 0x6030
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function checkForSimilarDeaths(deathInfo)
{
	for(i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		if(level.spawnlogic_deaths[i].killer == deathInfo.killer)
		{
			dist = Distance(level.spawnlogic_deaths[i].org, deathInfo.org);
			if(dist > 200)
			{
				continue;
			}
			dist = Distance(level.spawnlogic_deaths[i].killOrg, deathInfo.killOrg);
			if(dist > 200)
			{
				continue;
			}
			level.spawnlogic_deaths[i].remove = 1;
		}
	}
}

/*
	Name: updateDeathInfo
	Namespace: spawnlogic
	Checksum: 0x80DEB82A
	Offset: 0x6160
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function updateDeathInfo()
{
	time = GetTime();
	for(i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		deathInfo = level.spawnlogic_deaths[i];
		if(time - deathInfo.time > 90000 || !isdefined(deathInfo.killer) || !isalive(deathInfo.killer) || !isdefined(level.teams[deathInfo.killer.team]) || Distance(deathInfo.killer.origin, deathInfo.killOrg) > 400)
		{
			level.spawnlogic_deaths[i].remove = 1;
		}
	}
	oldarray = level.spawnlogic_deaths;
	level.spawnlogic_deaths = [];
	start = 0;
	if(oldarray.size - 1024 > 0)
	{
		start = oldarray.size - 1024;
	}
	for(i = start; i < oldarray.size; i++)
	{
		if(!isdefined(oldarray[i].remove))
		{
			level.spawnlogic_deaths[level.spawnlogic_deaths.size] = oldarray[i];
		}
	}
}

/*
	Name: isPointVulnerable
	Namespace: spawnlogic
	Checksum: 0x5B7CC3F8
	Offset: 0x6350
	Size: 0x127
	Parameters: 1
	Flags: None
*/
function isPointVulnerable(playerOrigin)
{
	pos = self.origin + level.bettymodelcenteroffset;
	playerpos = playerOrigin + VectorScale((0, 0, 1), 32);
	distSqrd = DistanceSquared(pos, playerpos);
	FORWARD = AnglesToForward(self.angles);
	if(distSqrd < level.bettyDetectionRadius * level.bettyDetectionRadius)
	{
		playerdir = VectorNormalize(playerpos - pos);
		angle = ACos(VectorDot(playerdir, FORWARD));
		if(angle < level.bettyDetectionConeAngle)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: avoidWeaponDamage
	Namespace: spawnlogic
	Checksum: 0xB89CC5F1
	Offset: 0x6480
	Size: 0x211
	Parameters: 1
	Flags: None
*/
function avoidWeaponDamage(Spawnpoints)
{
	if(GetDvarString("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	weaponDamagePenalty = 100000;
	if(GetDvarString("scr_spawnpointweaponpenalty") != "" && GetDvarString("scr_spawnpointweaponpenalty") != "0")
	{
		weaponDamagePenalty = GetDvarFloat("scr_spawnpointweaponpenalty");
	}
	mingrenadedistsquared = 62500;
	for(i = 0; i < Spawnpoints.size; i++)
	{
		for(j = 0; j < level.grenades.size; j++)
		{
			if(!isdefined(level.grenades[j]))
			{
				continue;
			}
			if(DistanceSquared(Spawnpoints[i].origin, level.grenades[j].origin) < mingrenadedistsquared)
			{
				Spawnpoints[i].weight = Spawnpoints[i].weight - weaponDamagePenalty;
				/#
					if(level.storeSpawnData || level.debugSpawning)
					{
						Spawnpoints[i].spawnData[Spawnpoints[i].spawnData.size] = "Dev Block strings are not supported" + Int(weaponDamagePenalty);
					}
				#/
			}
		}
	}
}

/*
	Name: spawnPerFrameUpdate
	Namespace: spawnlogic
	Checksum: 0xE111F332
	Offset: 0x66A0
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function spawnPerFrameUpdate()
{
	spawnpointindex = 0;
	while(1)
	{
		wait(0.05);
		if(!isdefined(level.Spawnpoints))
		{
			return;
		}
		spawnpointindex = spawnpointindex + 1 % level.Spawnpoints.size;
		spawnpoint = level.Spawnpoints[spawnpointindex];
		spawnPointUpdate(spawnpoint);
	}
}

/*
	Name: getNonTeamSum
	Namespace: spawnlogic
	Checksum: 0xCD200160
	Offset: 0x6728
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function getNonTeamSum(skip_team, sums)
{
	value = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		value = value + sums[team];
	}
	return value;
}

/*
	Name: getNonTeamMinDist
	Namespace: spawnlogic
	Checksum: 0x6A5824DE
	Offset: 0x67F0
	Size: 0xD1
	Parameters: 2
	Flags: None
*/
function getNonTeamMinDist(skip_team, minDists)
{
	dist = 9999999;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		if(dist > minDists[team])
		{
			dist = minDists[team];
		}
	}
	return dist;
}

/*
	Name: spawnPointUpdate
	Namespace: spawnlogic
	Checksum: 0x3C5136F0
	Offset: 0x68D0
	Size: 0x6E9
	Parameters: 1
	Flags: None
*/
function spawnPointUpdate(spawnpoint)
{
	if(level.teambased)
	{
		sights = [];
		foreach(team in level.teams)
		{
			spawnpoint.enemySights[team] = 0;
			sights[team] = 0;
			spawnpoint.nearbyPlayers[team] = [];
		}
	}
	else
	{
		spawnpoint.enemySights = 0;
		spawnpoint.nearbyPlayers["all"] = [];
	}
	spawnpointdir = spawnpoint.FORWARD;
	debug = 0;
	/#
		debug = GetDvarInt("Dev Block strings are not supported") > 0;
	#/
	mindist = [];
	distSum = [];
	if(!level.teambased)
	{
		mindist["all"] = 9999999;
	}
	foreach(team in level.teams)
	{
		spawnpoint.distSum[team] = 0;
		spawnpoint.enemyDistSum[team] = 0;
		spawnpoint.minEnemyDist[team] = 9999999;
		mindist[team] = 9999999;
	}
	spawnpoint.numPlayersAtLastUpdate = 0;
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(player.sessionstate != "playing")
		{
			continue;
		}
		diff = player.origin - spawnpoint.origin;
		diff = (diff[0], diff[1], 0);
		dist = length(diff);
		team = "all";
		if(level.teambased)
		{
			team = player.team;
		}
		if(dist < 1024)
		{
			spawnpoint.nearbyPlayers[team][spawnpoint.nearbyPlayers[team].size] = player;
		}
		if(dist < mindist[team])
		{
			mindist[team] = dist;
		}
		distSum[team] = distSum[team] + dist;
		spawnpoint.numPlayersAtLastUpdate++;
		pdir = AnglesToForward(player.angles);
		if(VectorDot(spawnpointdir, diff) < 0 && VectorDot(pdir, diff) > 0)
		{
			continue;
		}
		losExists = BulletTracePassed(player.origin + VectorScale((0, 0, 1), 50), spawnpoint.sightTracePoint, 0, undefined);
		spawnpoint.lastSightTraceTime = GetTime();
		if(losExists)
		{
			if(level.teambased)
			{
				sights[player.team]++;
			}
			else
			{
				spawnpoint.enemySights++;
			}
			/#
				if(debug)
				{
					line(player.origin + VectorScale((0, 0, 1), 50), spawnpoint.sightTracePoint, (0.5, 1, 0.5));
				}
			#/
		}
	}
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			spawnpoint.enemySights[team] = getNonTeamSum(team, sights);
			spawnpoint.minEnemyDist[team] = getNonTeamMinDist(team, mindist);
			spawnpoint.distSum[team] = distSum[team];
			spawnpoint.enemyDistSum[team] = getNonTeamSum(team, distSum);
		}
	}
	else
	{
		spawnpoint.distSum["all"] = distSum["all"];
		spawnpoint.enemyDistSum["all"] = distSum["all"];
		spawnpoint.minEnemyDist["all"] = mindist["all"];
	}
}

/*
	Name: getLosPenalty
	Namespace: spawnlogic
	Checksum: 0xBD6EB74E
	Offset: 0x6FC8
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function getLosPenalty()
{
	if(GetDvarString("scr_spawnpointlospenalty") != "" && GetDvarString("scr_spawnpointlospenalty") != "0")
	{
		return GetDvarFloat("scr_spawnpointlospenalty");
	}
	return 100000;
}

/*
	Name: lastMinuteSightTraces
	Namespace: spawnlogic
	Checksum: 0xE13C53B5
	Offset: 0x7048
	Size: 0x2DD
	Parameters: 1
	Flags: None
*/
function lastMinuteSightTraces(spawnpoint)
{
	if(!isdefined(spawnpoint.nearbyPlayers))
	{
		return 0;
	}
	closest = undefined;
	closestDistsq = undefined;
	secondClosest = undefined;
	secondClosestDistsq = undefined;
	foreach(team in spawnpoint.nearbyPlayers)
	{
		if(team == self.team)
		{
			break;
		}
		for(i = 0; i < spawnpoint.nearbyPlayers[team].size; i++)
		{
			player = spawnpoint.nearbyPlayers[team][i];
			if(!isdefined(player))
			{
				continue;
			}
			if(player.sessionstate != "playing")
			{
				continue;
			}
			if(player == self)
			{
				continue;
			}
			distSq = DistanceSquared(spawnpoint.origin, player.origin);
			if(!isdefined(closest) || distSq < closestDistsq)
			{
				secondClosest = closest;
				secondClosestDistsq = closestDistsq;
				closest = player;
				closestDistsq = distSq;
				continue;
			}
			if(!isdefined(secondClosest) || distSq < secondClosestDistsq)
			{
				secondClosest = player;
				secondClosestDistsq = distSq;
			}
		}
	}
	if(isdefined(closest))
	{
		if(BulletTracePassed(closest.origin + VectorScale((0, 0, 1), 50), spawnpoint.sightTracePoint, 0, undefined))
		{
			return 1;
		}
	}
	if(isdefined(secondClosest))
	{
		if(BulletTracePassed(secondClosest.origin + VectorScale((0, 0, 1), 50), spawnpoint.sightTracePoint, 0, undefined))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: avoidVisibleEnemies
	Namespace: spawnlogic
	Checksum: 0x948783B1
	Offset: 0x7330
	Size: 0x56F
	Parameters: 2
	Flags: None
*/
function avoidVisibleEnemies(Spawnpoints, teambased)
{
	if(GetDvarString("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	lospenalty = getLosPenalty();
	minDistTeam = self.team;
	if(teambased)
	{
		for(i = 0; i < Spawnpoints.size; i++)
		{
			if(!isdefined(Spawnpoints[i].enemySights))
			{
				continue;
			}
			penalty = lospenalty * Spawnpoints[i].enemySights[self.team];
			Spawnpoints[i].weight = Spawnpoints[i].weight - penalty;
			/#
				if(level.storeSpawnData || level.debugSpawning)
				{
					index = Spawnpoints[i].sightChecks.size;
					Spawnpoints[i].sightChecks[index] = spawnstruct();
					Spawnpoints[i].sightChecks[index].penalty = penalty;
				}
			#/
		}
	}
	else
	{
		for(i = 0; i < Spawnpoints.size; i++)
		{
			if(!isdefined(Spawnpoints[i].enemySights))
			{
				continue;
			}
			penalty = lospenalty * Spawnpoints[i].enemySights;
			Spawnpoints[i].weight = Spawnpoints[i].weight - penalty;
			/#
				if(level.storeSpawnData || level.debugSpawning)
				{
					index = Spawnpoints[i].sightChecks.size;
					Spawnpoints[i].sightChecks[index] = spawnstruct();
					Spawnpoints[i].sightChecks[index].penalty = penalty;
				}
			#/
		}
		minDistTeam = "all";
	}
	avoidWeight = GetDvarFloat("scr_spawn_enemyavoidweight");
	if(avoidWeight != 0)
	{
		nearbyEnemyOuterRange = GetDvarFloat("scr_spawn_enemyavoiddist");
		nearbyEnemyOuterRangeSq = nearbyEnemyOuterRange * nearbyEnemyOuterRange;
		nearbyEnemyPenalty = 1500 * avoidWeight;
		nearbyEnemyMinorPenalty = 800 * avoidWeight;
		lastAttackerOrigin = VectorScale((-1, -1, -1), 99999);
		lastDeathPos = VectorScale((-1, -1, -1), 99999);
		if(isalive(self.lastAttacker))
		{
			lastAttackerOrigin = self.lastAttacker.origin;
		}
		if(isdefined(self.lastDeathPos))
		{
			lastDeathPos = self.lastDeathPos;
		}
		for(i = 0; i < Spawnpoints.size; i++)
		{
			mindist = Spawnpoints[i].minEnemyDist[minDistTeam];
			if(mindist < nearbyEnemyOuterRange * 2)
			{
				penalty = nearbyEnemyMinorPenalty * 1 - mindist / nearbyEnemyOuterRange * 2;
				if(mindist < nearbyEnemyOuterRange)
				{
					penalty = penalty + nearbyEnemyPenalty * 1 - mindist / nearbyEnemyOuterRange;
				}
				if(penalty > 0)
				{
					Spawnpoints[i].weight = Spawnpoints[i].weight - penalty;
					/#
						if(level.storeSpawnData || level.debugSpawning)
						{
							Spawnpoints[i].spawnData[Spawnpoints[i].spawnData.size] = "Dev Block strings are not supported" + Int(Spawnpoints[i].minEnemyDist[minDistTeam]) + "Dev Block strings are not supported" + Int(penalty);
						}
					#/
				}
			}
		}
	}
}

/*
	Name: avoidSpawnReuse
	Namespace: spawnlogic
	Checksum: 0x406CB07E
	Offset: 0x78A8
	Size: 0x28B
	Parameters: 2
	Flags: None
*/
function avoidSpawnReuse(Spawnpoints, teambased)
{
	if(GetDvarString("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	time = GetTime();
	maxTime = 10000;
	maxDistSq = 1048576;
	for(i = 0; i < Spawnpoints.size; i++)
	{
		spawnpoint = Spawnpoints[i];
		if(!isdefined(spawnpoint.lastspawnedplayer) || !isdefined(spawnpoint.lastspawntime) || !isalive(spawnpoint.lastspawnedplayer))
		{
			continue;
		}
		if(spawnpoint.lastspawnedplayer == self)
		{
			continue;
		}
		if(teambased && spawnpoint.lastspawnedplayer.team == self.team)
		{
			continue;
		}
		timePassed = time - spawnpoint.lastspawntime;
		if(timePassed < maxTime)
		{
			distSq = DistanceSquared(spawnpoint.lastspawnedplayer.origin, spawnpoint.origin);
			if(distSq < maxDistSq)
			{
				worsen = 5000 * 1 - distSq / maxDistSq * 1 - timePassed / maxTime;
				spawnpoint.weight = spawnpoint.weight - worsen;
				/#
					if(level.storeSpawnData || level.debugSpawning)
					{
						spawnpoint.spawnData[spawnpoint.spawnData.size] = "Dev Block strings are not supported" + worsen;
					}
				#/
			}
			else
			{
				spawnpoint.lastspawnedplayer = undefined;
			}
			continue;
		}
		spawnpoint.lastspawnedplayer = undefined;
	}
}

/*
	Name: avoidSameSpawn
	Namespace: spawnlogic
	Checksum: 0xE09D2051
	Offset: 0x7B40
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function avoidSameSpawn(Spawnpoints)
{
	if(GetDvarString("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	if(!isdefined(self.lastSpawnPoint))
	{
		return;
	}
	for(i = 0; i < Spawnpoints.size; i++)
	{
		if(Spawnpoints[i] == self.lastSpawnPoint)
		{
			Spawnpoints[i].weight = Spawnpoints[i].weight - 50000;
			/#
				if(level.storeSpawnData || level.debugSpawning)
				{
					Spawnpoints[i].spawnData[Spawnpoints[i].spawnData.size] = "Dev Block strings are not supported";
				}
			#/
			break;
		}
	}
}

/*
	Name: getRandomIntermissionPoint
	Namespace: spawnlogic
	Checksum: 0x45C34536
	Offset: 0x7C50
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function getRandomIntermissionPoint()
{
	Spawnpoints = GetEntArray("mp_global_intermission", "classname");
	if(!Spawnpoints.size)
	{
		Spawnpoints = GetEntArray("info_player_start", "classname");
	}
	/#
		Assert(Spawnpoints.size);
	#/
	spawnpoint = getSpawnpoint_Random(Spawnpoints);
	return spawnpoint;
}

