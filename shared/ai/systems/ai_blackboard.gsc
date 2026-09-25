#namespace blackboard;

/*
	Name: main
	Namespace: blackboard
	Checksum: 0xCAD340B0
	Offset: 0x80
	Size: 0x13
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	_InitializeBlackboard();
}

/*
	Name: _InitializeBlackboard
	Namespace: blackboard
	Checksum: 0xA675A2DD
	Offset: 0xA0
	Size: 0x23
	Parameters: 0
	Flags: Private
*/
function private _InitializeBlackboard()
{
	level.__ai_blackboard = [];
	level thread _UpdateEvents();
}

/*
	Name: _UpdateEvents
	Namespace: blackboard
	Checksum: 0x710C6DDF
	Offset: 0xD0
	Size: 0x18D
	Parameters: 0
	Flags: Private
*/
function private _UpdateEvents()
{
	waitTime = 0.05;
	updateMillis = waitTime * 1000;
	while(1)
	{
		foreach(events in level.__ai_blackboard)
		{
			liveEvents = [];
			foreach(event in events)
			{
				event.ttl = event.ttl - updateMillis;
				if(event.ttl > 0)
				{
					liveEvents[liveEvents.size] = event;
				}
			}
			level.__ai_blackboard[eventName] = liveEvents;
		}
		wait(waitTime);
	}
}

/*
	Name: AddBlackboardEvent
	Namespace: blackboard
	Checksum: 0x48C9B02C
	Offset: 0x268
	Size: 0x1A7
	Parameters: 3
	Flags: None
*/
function AddBlackboardEvent(eventName, data, timeToLiveInMillis)
{
	/#
		/#
			Assert(IsString(eventName), "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(data), "Dev Block strings are not supported");
		#/
		/#
			Assert(IsInt(timeToLiveInMillis) && timeToLiveInMillis > 0, "Dev Block strings are not supported");
		#/
	#/
	event = spawnstruct();
	event.data = data;
	event.timestamp = GetTime();
	event.ttl = timeToLiveInMillis;
	if(!isdefined(level.__ai_blackboard[eventName]))
	{
		level.__ai_blackboard[eventName] = [];
	}
	else if(!IsArray(level.__ai_blackboard[eventName]))
	{
		level.__ai_blackboard[eventName] = Array(level.__ai_blackboard[eventName]);
	}
	level.__ai_blackboard[eventName][level.__ai_blackboard[eventName].size] = event;
}

/*
	Name: GetBlackboardEvents
	Namespace: blackboard
	Checksum: 0x17147A3F
	Offset: 0x418
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function GetBlackboardEvents(eventName)
{
	if(isdefined(level.__ai_blackboard[eventName]))
	{
		return level.__ai_blackboard[eventName];
	}
	return [];
}

/*
	Name: RemoveBlackboardEvents
	Namespace: blackboard
	Checksum: 0x52A2A4F5
	Offset: 0x450
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function RemoveBlackboardEvents(eventName)
{
	if(isdefined(level.__ai_blackboard[eventName]))
	{
		level.__ai_blackboard[eventName] = undefined;
	}
}

