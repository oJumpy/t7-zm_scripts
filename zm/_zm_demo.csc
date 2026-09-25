#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _zm_demo;

/*
	Name: __init__sytem__
	Namespace: _zm_demo
	Checksum: 0xA96465A8
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_demo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_demo
	Checksum: 0xD9C3BDFB
	Offset: 0x1A8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(IsDemoPlaying())
	{
		if(!isdefined(level.demolocalclients))
		{
			level.demolocalclients = [];
		}
		callback::on_localclient_connect(&player_on_connect);
	}
}

/*
	Name: player_on_connect
	Namespace: _zm_demo
	Checksum: 0x838493F1
	Offset: 0x208
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function player_on_connect(localClientNum)
{
	level thread watch_predicted_player_changes(localClientNum);
}

/*
	Name: watch_predicted_player_changes
	Namespace: _zm_demo
	Checksum: 0x3AF5D63D
	Offset: 0x238
	Size: 0x213
	Parameters: 1
	Flags: None
*/
function watch_predicted_player_changes(localClientNum)
{
	level.demolocalclients[localClientNum] = spawnstruct();
	level.demolocalclients[localClientNum].nonpredicted_local_player = GetNonPredictedLocalPlayer(localClientNum);
	level.demolocalclients[localClientNum].predicted_local_player = GetLocalPlayer(localClientNum);
	while(1)
	{
		nonpredicted_local_player = GetNonPredictedLocalPlayer(localClientNum);
		predicted_local_player = GetLocalPlayer(localClientNum);
		if(nonpredicted_local_player !== level.demolocalclients[localClientNum].nonpredicted_local_player)
		{
			level notify("demo_nplplayer_change", localClientNum, level.demolocalclients[localClientNum].nonpredicted_local_player, nonpredicted_local_player);
			level notify("demo_nplplayer_change" + localClientNum, level.demolocalclients[localClientNum].nonpredicted_local_player, nonpredicted_local_player);
			level.demolocalclients[localClientNum].nonpredicted_local_player = nonpredicted_local_player;
		}
		if(predicted_local_player !== level.demolocalclients[localClientNum].predicted_local_player)
		{
			level notify("demo_plplayer_change", localClientNum, level.demolocalclients[localClientNum].predicted_local_player, predicted_local_player);
			level notify("demo_plplayer_change" + localClientNum, level.demolocalclients[localClientNum].predicted_local_player, predicted_local_player);
			level.demolocalclients[localClientNum].predicted_local_player = predicted_local_player;
		}
		wait(0.016);
	}
}

