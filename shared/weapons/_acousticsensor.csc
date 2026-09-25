#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace acousticsensor;

/*
	Name: init_shared
	Namespace: acousticsensor
	Checksum: 0xF92C74CF
	Offset: 0x1A8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["acousticsensor_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["acousticsensor_friendly_light"] = "_t6/misc/fx_equip_light_green";
	if(!isdefined(level.acousticSensors))
	{
		level.acousticSensors = [];
	}
	if(!isdefined(level.acousticSensorHandle))
	{
		level.acousticSensorHandle = 0;
	}
	callback::on_localclient_connect(&on_player_connect);
	callback::add_weapon_type("acoustic_sensor", &spawned);
}

/*
	Name: on_player_connect
	Namespace: acousticsensor
	Checksum: 0xADAC86C9
	Offset: 0x268
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function on_player_connect(localClientNum)
{
	SetLocalRadarEnabled(localClientNum, 0);
	if(localClientNum == 0)
	{
		level thread updateAcousticSensors();
	}
}

/*
	Name: addAcousticSensor
	Namespace: acousticsensor
	Checksum: 0x4BC47850
	Offset: 0x2B8
	Size: 0x9D
	Parameters: 3
	Flags: None
*/
function addAcousticSensor(handle, sensorEnt, owner)
{
	acousticsensor = spawnstruct();
	acousticsensor.handle = handle;
	acousticsensor.sensorEnt = sensorEnt;
	acousticsensor.owner = owner;
	SIZE = level.acousticSensors.size;
	level.acousticSensors[SIZE] = acousticsensor;
}

/*
	Name: removeAcousticSensor
	Namespace: acousticsensor
	Checksum: 0x1538F359
	Offset: 0x360
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function removeAcousticSensor(acousticSensorHandle)
{
	for(i = 0; i < level.acousticSensors.size; i++)
	{
		last = level.acousticSensors.size - 1;
		if(level.acousticSensors[i].handle == acousticSensorHandle)
		{
			level.acousticSensors[i].handle = level.acousticSensors[last].handle;
			level.acousticSensors[i].sensorEnt = level.acousticSensors[last].sensorEnt;
			level.acousticSensors[i].owner = level.acousticSensors[last].owner;
			level.acousticSensors[last] = undefined;
			return;
		}
	}
}

/*
	Name: spawned
	Namespace: acousticsensor
	Checksum: 0x39BF2601
	Offset: 0x480
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	handle = level.acousticSensorHandle;
	level.acousticSensorHandle++;
	self thread WatchShutdown(handle);
	owner = self GetOwner(localClientNum);
	addAcousticSensor(handle, self, owner);
	util::local_players_entity_thread(self, &spawnedPerClient);
}

/*
	Name: spawnedPerClient
	Namespace: acousticsensor
	Checksum: 0x121B875F
	Offset: 0x530
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function spawnedPerClient(localClientNum)
{
	self endon("entityshutdown");
	self thread FX::blinky_light(localClientNum, "tag_light", level._effect["acousticsensor_friendly_light"], level._effect["acousticsensor_enemy_light"]);
}

/*
	Name: WatchShutdown
	Namespace: acousticsensor
	Checksum: 0x5B6AD378
	Offset: 0x590
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function WatchShutdown(handle)
{
	self waittill("entityshutdown");
	removeAcousticSensor(handle);
}

/*
	Name: updateAcousticSensors
	Namespace: acousticsensor
	Checksum: 0xF132EB
	Offset: 0x5C8
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function updateAcousticSensors()
{
	self endon("entityshutdown");
	localRadarEnabled = [];
	previousAcousticSensorCount = -1;
	util::waitforclient(0);
	while(1)
	{
		localPlayers = level.localPlayers;
		if(previousAcousticSensorCount != 0 || level.acousticSensors.size != 0)
		{
			for(i = 0; i < localPlayers.size; i++)
			{
				localRadarEnabled[i] = 0;
			}
			for(i = 0; i < level.acousticSensors.size; i++)
			{
				if(isdefined(level.acousticSensors[i].sensorEnt.stunned) && level.acousticSensors[i].sensorEnt.stunned)
				{
					break;
				}
				for(j = 0; j < localPlayers.size; j++)
				{
					if(localPlayers[j] == level.acousticSensors[i].sensorEnt GetOwner(j))
					{
						localRadarEnabled[j] = 1;
						SetLocalRadarPosition(j, level.acousticSensors[i].sensorEnt.origin);
					}
				}
			}
			for(i = 0; i < localPlayers.size; i++)
			{
				SetLocalRadarEnabled(i, localRadarEnabled[i]);
			}
		}
		previousAcousticSensorCount = level.acousticSensors.size;
		wait(0.1);
	}
}

