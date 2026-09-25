#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace music;

/*
	Name: __init__sytem__
	Namespace: music
	Checksum: 0xA392E30A
	Offset: 0xC8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("music", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: music
	Checksum: 0x6154177E
	Offset: 0x108
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.activeMusicState = "";
	level.nextMusicState = "";
	level.musicStates = [];
	util::REGISTER_SYSTEM("musicCmd", &musicCmdHandler);
}

/*
	Name: musicCmdHandler
	Namespace: music
	Checksum: 0x87E0BBA1
	Offset: 0x170
	Size: 0x63
	Parameters: 3
	Flags: None
*/
function musicCmdHandler(clientNum, State, oldState)
{
	if(State != "death")
	{
		level._lastMusicState = State;
	}
	State = ToLower(State);
	soundsetmusicstate(State);
}

