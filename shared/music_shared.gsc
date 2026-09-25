#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace music;

/*
	Name: __init__sytem__
	Namespace: music
	Checksum: 0x77F7B329
	Offset: 0xF0
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
	Checksum: 0x8BB88893
	Offset: 0x130
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.musicState = "";
	util::registerClientSys("musicCmd");
	if(SessionModeIsCampaignGame())
	{
		callback::on_spawned(&on_player_spawned);
	}
}

/*
	Name: setmusicstate
	Namespace: music
	Checksum: 0xA2EAA94D
	Offset: 0x198
	Size: 0xA7
	Parameters: 2
	Flags: None
*/
function setmusicstate(State, player)
{
	if(isdefined(level.musicState))
	{
		if(isdefined(level.bonuszm_musicoverride) && level.bonuszm_musicoverride)
		{
			return;
		}
		if(isdefined(player))
		{
			util::setClientSysState("musicCmd", State, player);
			return;
		}
		else if(level.musicState != State)
		{
			util::setClientSysState("musicCmd", State);
		}
	}
	level.musicState = State;
}

/*
	Name: on_player_spawned
	Namespace: music
	Checksum: 0x201531C3
	Offset: 0x248
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	if(isdefined(level.musicState))
	{
		if(IsSubStr(level.musicState, "_igc") || IsSubStr(level.musicState, "igc_"))
		{
			return;
		}
		if(isdefined(self))
		{
			setmusicstate(level.musicState, self);
		}
		else
		{
			setmusicstate(level.musicState);
		}
	}
}

