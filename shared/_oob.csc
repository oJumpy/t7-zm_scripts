#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;

#namespace oob;

/*
	Name: __init__sytem__
	Namespace: oob
	Checksum: 0xA62B8D4E
	Offset: 0x178
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("out_of_bounds", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: oob
	Checksum: 0x62AF9BDE
	Offset: 0x1B8
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(SessionModeIsMultiplayerGame())
	{
		level.oob_timelimit_ms = GetDvarInt("oob_timelimit_ms", 3000);
		level.oob_timekeep_ms = GetDvarInt("oob_timekeep_ms", 3000);
	}
	else
	{
		level.oob_timelimit_ms = GetDvarInt("oob_timelimit_ms", 6000);
	}
	clientfield::register("toplayer", "out_of_bounds", 1, 5, "int", &onOutOfBoundsChange, 0, 1);
	if(!SessionModeIsZombiesGame())
	{
		callback::on_localclient_connect(&on_localplayer_connect);
		callback::on_localplayer_spawned(&on_localplayer_spawned);
		callback::on_localclient_shutdown(&on_localplayer_shutdown);
	}
}

/*
	Name: on_localplayer_connect
	Namespace: oob
	Checksum: 0x6D22B931
	Offset: 0x308
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function on_localplayer_connect(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	oobModel = GetOObUIModel(localClientNum);
	SetUIModelValue(oobModel, 0);
}

/*
	Name: on_localplayer_spawned
	Namespace: oob
	Checksum: 0xA06FB2AF
	Offset: 0x380
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
	filter::disable_filter_oob(self, 0);
	self Randomfade(0);
}

/*
	Name: on_localplayer_shutdown
	Namespace: oob
	Checksum: 0xBD01F527
	Offset: 0x3C8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function on_localplayer_shutdown(localClientNum)
{
	localPlayer = self;
	if(isdefined(localPlayer))
	{
		StopOutOfBoundsEffects(localClientNum, localPlayer);
	}
}

/*
	Name: onOutOfBoundsChange
	Namespace: oob
	Checksum: 0xFE4045DA
	Offset: 0x418
	Size: 0x33B
	Parameters: 7
	Flags: None
*/
function onOutOfBoundsChange(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	localPlayer = GetLocalPlayer(localClientNum);
	if(!isdefined(level.oob_sound_ent))
	{
		level.oob_sound_ent = [];
	}
	if(!isdefined(level.oob_sound_ent[localClientNum]))
	{
		level.oob_sound_ent[localClientNum] = spawn(localClientNum, (0, 0, 0), "script_origin");
	}
	if(newVal > 0)
	{
		if(!isdefined(localPlayer.oob_effect_enabled))
		{
			filter::init_filter_oob(localPlayer);
			filter::enable_filter_oob(localPlayer, 0);
			localPlayer.oob_effect_enabled = 1;
			level.oob_sound_ent[localClientNum] PlayLoopSound("uin_out_of_bounds_loop", 0.5);
			oobModel = GetOObUIModel(localClientNum);
			if(isdefined(level.oob_timekeep_ms) && isdefined(self.oob_start_time) && isdefined(self.oob_active_duration) && getServerTime(0) - self.oob_end_time < level.oob_timekeep_ms)
			{
				SetUIModelValue(oobModel, getServerTime(0, 1) + level.oob_timelimit_ms - self.oob_active_duration);
			}
			else
			{
				self.oob_active_duration = undefined;
				SetUIModelValue(oobModel, getServerTime(0, 1) + level.oob_timelimit_ms);
			}
			self.oob_start_time = getServerTime(0, 1);
		}
		newValf = newVal / 31;
		localPlayer Randomfade(newValf);
	}
	else if(isdefined(level.oob_timekeep_ms) && isdefined(self.oob_start_time))
	{
		self.oob_end_time = getServerTime(0, 1);
		if(!isdefined(self.oob_active_duration))
		{
			self.oob_active_duration = 0;
		}
		self.oob_active_duration = self.oob_active_duration + self.oob_end_time - self.oob_start_time;
	}
	StopOutOfBoundsEffects(localClientNum, localPlayer);
}

/*
	Name: StopOutOfBoundsEffects
	Namespace: oob
	Checksum: 0xB0C56CA4
	Offset: 0x760
	Size: 0xFD
	Parameters: 2
	Flags: None
*/
function StopOutOfBoundsEffects(localClientNum, localPlayer)
{
	filter::disable_filter_oob(localPlayer, 0);
	localPlayer Randomfade(0);
	if(isdefined(level.oob_sound_ent) && isdefined(level.oob_sound_ent[localClientNum]))
	{
		level.oob_sound_ent[localClientNum] StopAllLoopSounds(0.5);
	}
	oobModel = GetOObUIModel(localClientNum);
	SetUIModelValue(oobModel, 0);
	if(isdefined(localPlayer.oob_effect_enabled))
	{
		localPlayer.oob_effect_enabled = 0;
		localPlayer.oob_effect_enabled = undefined;
	}
}

/*
	Name: GetOObUIModel
	Namespace: oob
	Checksum: 0xCE4EF0F2
	Offset: 0x868
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function GetOObUIModel(localClientNum)
{
	controllerModel = GetUIModelForController(localClientNum);
	return CreateUIModel(controllerModel, "hudItems.outOfBoundsEndTime");
}

