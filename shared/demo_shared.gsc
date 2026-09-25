#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

#namespace demo;

/*
	Name: __init__sytem__
	Namespace: demo
	Checksum: 0x957C388
	Offset: 0xC0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("demo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: demo
	Checksum: 0x88053449
	Offset: 0x100
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread watch_actor_bookmarks();
}

/*
	Name: initActorBookmarkParams
	Namespace: demo
	Checksum: 0x78ED5EAC
	Offset: 0x128
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function initActorBookmarkParams(killTimesCount, killTimeMsec, killTimeDelay)
{
	level.actor_bookmark_kill_times_count = killTimesCount;
	level.actor_bookmark_kill_times_msec = killTimeMsec;
	level.actor_bookmark_kill_times_delay = killTimeDelay;
	level.actorbookmarkParamsInitialized = 1;
}

/*
	Name: bookmark
	Namespace: demo
	Checksum: 0xD1C7724
	Offset: 0x180
	Size: 0x1F3
	Parameters: 8
	Flags: None
*/
function bookmark(type, time, mainClientEnt, otherClientEnt, eventPriority, inflictorEnt, overrideEntityCamera, actorEnt)
{
	mainClientNum = -1;
	otherClientNum = -1;
	inflictorEntNum = -1;
	inflictorEntType = 0;
	inflictorBirthTime = 0;
	actorEntNum = undefined;
	scoreEventPriority = 0;
	if(isdefined(mainClientEnt))
	{
		mainClientNum = mainClientEnt GetEntityNumber();
	}
	if(isdefined(otherClientEnt))
	{
		otherClientNum = otherClientEnt GetEntityNumber();
	}
	if(isdefined(eventPriority))
	{
		scoreEventPriority = eventPriority;
	}
	if(isdefined(inflictorEnt))
	{
		inflictorEntNum = inflictorEnt GetEntityNumber();
		inflictorEntType = inflictorEnt getEntityType();
		if(isdefined(inflictorEnt.birthtime))
		{
			inflictorBirthTime = inflictorEnt.birthtime;
		}
	}
	if(!isdefined(overrideEntityCamera))
	{
		overrideEntityCamera = 0;
	}
	if(isdefined(actorEnt))
	{
		actorEntNum = actorEnt GetEntityNumber();
	}
	addDemoBookmark(type, time, mainClientNum, otherClientNum, scoreEventPriority, inflictorEntNum, inflictorEntType, inflictorBirthTime, overrideEntityCamera, actorEntNum);
}

/*
	Name: gameResultBookmark
	Namespace: demo
	Checksum: 0x6ECAB4BF
	Offset: 0x380
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function gameResultBookmark(type, winningTeamIndex, losingTeamIndex)
{
	mainClientNum = -1;
	otherClientNum = -1;
	scoreEventPriority = 0;
	inflictorEntNum = -1;
	inflictorEntType = 0;
	inflictorBirthTime = 0;
	overrideEntityCamera = 0;
	actorEntNum = undefined;
	if(isdefined(winningTeamIndex))
	{
		mainClientNum = winningTeamIndex;
	}
	if(isdefined(losingTeamIndex))
	{
		otherClientNum = losingTeamIndex;
	}
	addDemoBookmark(type, GetTime(), mainClientNum, otherClientNum, scoreEventPriority, inflictorEntNum, inflictorEntType, inflictorBirthTime, overrideEntityCamera, actorEntNum);
}

/*
	Name: reset_actor_bookmark_kill_times
	Namespace: demo
	Checksum: 0x1E6623AD
	Offset: 0x490
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function reset_actor_bookmark_kill_times()
{
	if(!isdefined(level.actorbookmarkParamsInitialized))
	{
		return;
	}
	if(!isdefined(self.actor_bookmark_kill_times))
	{
		self.actor_bookmark_kill_times = [];
		self.ignore_actor_kill_times = 0;
	}
	for(i = 0; i < level.actor_bookmark_kill_times_count; i++)
	{
		self.actor_bookmark_kill_times[i] = 0;
	}
}

/*
	Name: add_actor_bookmark_kill_time
	Namespace: demo
	Checksum: 0x1A208869
	Offset: 0x510
	Size: 0xF1
	Parameters: 0
	Flags: None
*/
function add_actor_bookmark_kill_time()
{
	if(!isdefined(level.actorbookmarkParamsInitialized))
	{
		return;
	}
	now = GetTime();
	if(now <= self.ignore_actor_kill_times)
	{
		return;
	}
	oldest_index = 0;
	oldest_time = now + 1;
	for(i = 0; i < level.actor_bookmark_kill_times_count; i++)
	{
		if(!self.actor_bookmark_kill_times[i])
		{
			oldest_index = i;
			break;
			continue;
		}
		if(oldest_time > self.actor_bookmark_kill_times[i])
		{
			oldest_index = i;
			oldest_time = self.actor_bookmark_kill_times[i];
		}
	}
	self.actor_bookmark_kill_times[oldest_index] = now;
}

/*
	Name: watch_actor_bookmarks
	Namespace: demo
	Checksum: 0xDE0286C9
	Offset: 0x610
	Size: 0x1F5
	Parameters: 0
	Flags: None
*/
function watch_actor_bookmarks()
{
	while(1)
	{
		if(!isdefined(level.actorbookmarkParamsInitialized))
		{
			wait(0.5);
			continue;
		}
		wait(0.05);
		waittillframeend;
		now = GetTime();
		oldest_allowed = now - level.actor_bookmark_kill_times_msec;
		players = GetPlayers();
		for(player_index = 0; player_index < players.size; player_index++)
		{
			player = players[player_index];
			/#
				if(isdefined(player.pers["Dev Block strings are not supported"]) && player.pers["Dev Block strings are not supported"])
				{
					continue;
				}
			#/
			for(time_index = 0; time_index < level.actor_bookmark_kill_times_count; time_index++)
			{
				if(!isdefined(player.actor_bookmark_kill_times) || !player.actor_bookmark_kill_times[time_index])
				{
					break;
					continue;
				}
				if(oldest_allowed > player.actor_bookmark_kill_times[time_index])
				{
					player.actor_bookmark_kill_times[time_index] = 0;
					break;
				}
			}
			if(time_index >= level.actor_bookmark_kill_times_count)
			{
				bookmark("actor_kill", GetTime(), player);
				player reset_actor_bookmark_kill_times();
				player.ignore_actor_kill_times = now + level.actor_bookmark_kill_times_delay;
			}
		}
	}
}

