#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace player;

/*
	Name: __init__sytem__
	Namespace: player
	Checksum: 0xDC7A9049
	Offset: 0xF0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: player
	Checksum: 0xAC5B2152
	Offset: 0x130
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "gameplay_started", 4000, 1, "int", &gameplay_started_callback, 0, 1);
}

/*
	Name: gameplay_started_callback
	Namespace: player
	Checksum: 0x5E2EA3C
	Offset: 0x188
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function gameplay_started_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	SetDvar("cg_isGameplayActive", newVal);
}

