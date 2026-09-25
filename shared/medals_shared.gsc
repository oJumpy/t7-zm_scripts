#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace Medals;

/*
	Name: __init__sytem__
	Namespace: Medals
	Checksum: 0xA3EC32E4
	Offset: 0xF0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("medals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: Medals
	Checksum: 0xEA18E637
	Offset: 0x130
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: Medals
	Checksum: 0xEF5E30A3
	Offset: 0x160
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function init()
{
	level.medalInfo = [];
	level.medalCallbacks = [];
	level.numKills = 0;
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: Medals
	Checksum: 0x49CB5FB7
	Offset: 0x1B8
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.lastKilledBy = undefined;
}

/*
	Name: setLastKilledBy
	Namespace: Medals
	Checksum: 0xEDD6078F
	Offset: 0x1D0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function setLastKilledBy(attacker)
{
	self.lastKilledBy = attacker;
}

/*
	Name: offenseGlobalCount
	Namespace: Medals
	Checksum: 0x58D37075
	Offset: 0x1F0
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function offenseGlobalCount()
{
	level.globalTeamMedals++;
}

/*
	Name: defenseGlobalCount
	Namespace: Medals
	Checksum: 0x136DD30F
	Offset: 0x208
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function defenseGlobalCount()
{
	level.globalTeamMedals++;
}

/*
	Name: CodeCallback_Medal
	Namespace: Medals
	Checksum: 0x55D469D2
	Offset: 0x220
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function CodeCallback_Medal(medalIndex)
{
	self LUINotifyEvent(&"medal_received", 1, medalIndex);
	self LUINotifyEventToSpectators(&"medal_received", 1, medalIndex);
}

