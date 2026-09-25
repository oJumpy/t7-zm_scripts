#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_speed_burst;

/*
	Name: __init__sytem__
	Namespace: _gadget_speed_burst
	Checksum: 0x820F1323
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_speed_burst", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_speed_burst
	Checksum: 0xCC6C3066
	Offset: 0x288
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	clientfield::register("toplayer", "speed_burst", 1, 1, "int", &player_speed_changed, 0, 1);
	visionset_mgr::register_visionset_info("speed_burst", 1, 9, undefined, "speed_burst_initialize");
}

/*
	Name: on_localplayer_spawned
	Namespace: _gadget_speed_burst
	Checksum: 0xB7E83340
	Offset: 0x328
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	filter::init_filter_speed_burst(self);
	filter::disable_filter_speed_burst(self, 3);
}

/*
	Name: player_speed_changed
	Namespace: _gadget_speed_burst
	Checksum: 0x5DAC8861
	Offset: 0x388
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function player_speed_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(self == GetLocalPlayer(localClientNum))
		{
			filter::enable_filter_speed_burst(self, 3);
		}
	}
	else if(self == GetLocalPlayer(localClientNum))
	{
		filter::disable_filter_speed_burst(self, 3);
	}
}

