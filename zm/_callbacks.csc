#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_driving_fx;
#using scripts\zm\_filter;
#using scripts\zm\_sticky_grenade;

#namespace callback;

/*
	Name: __init__sytem__
	Namespace: callback
	Checksum: 0x5AD5873D
	Offset: 0x238
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("callback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: callback
	Checksum: 0x5D7E15A0
	Offset: 0x278
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread set_default_callbacks();
}

/*
	Name: set_default_callbacks
	Namespace: callback
	Checksum: 0xCBF53703
	Offset: 0x2A0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function set_default_callbacks()
{
	level.callbackPlayerSpawned = &playerspawned;
	level.callbackLocalClientConnect = &localclientconnect;
	level.callbackEntitySpawned = &entityspawned;
	level.callbackHostMigration = &host_migration;
	level.callbackPlayAIFootstep = &footsteps::playaifootstep;
	level.callbackPlayLightLoopExploder = &exploder::playlightloopexploder;
	level._custom_weapon_CB_Func = &spawned_weapon_type;
}

/*
	Name: localclientconnect
	Namespace: callback
	Checksum: 0x4A89D19C
	Offset: 0x358
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function localclientconnect(localClientNum)
{
	/#
		println("Dev Block strings are not supported" + localClientNum);
	#/
	callback("hash_da8d7d74", localClientNum);
	if(isdefined(level.characterCustomizationSetup))
	{
		[[level.characterCustomizationSetup]](localClientNum);
	}
}

/*
	Name: playerspawned
	Namespace: callback
	Checksum: 0xDE18DDED
	Offset: 0x3D8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function playerspawned(localClientNum)
{
	self endon("entityshutdown");
	if(isdefined(level._playerspawned_override))
	{
		self thread [[level._playerspawned_override]](localClientNum);
		return;
	}
	/#
		println("Dev Block strings are not supported");
	#/
	if(self isLocalPlayer())
	{
		callback("hash_842e788a", localClientNum);
	}
	callback("hash_bc12b61f", localClientNum);
	level.localPlayers = GetLocalPlayers();
}

/*
	Name: entityspawned
	Namespace: callback
	Checksum: 0xE536F726
	Offset: 0x4A8
	Size: 0x267
	Parameters: 1
	Flags: None
*/
function entityspawned(localClientNum)
{
	self endon("entityshutdown");
	if(self isPlayer())
	{
		if(isdefined(level._clientFaceAnimOnPlayerSpawned))
		{
			self thread [[level._clientFaceAnimOnPlayerSpawned]](localClientNum);
		}
	}
	if(isdefined(level._entityspawned_override))
	{
		self thread [[level._entityspawned_override]](localClientNum);
		return;
	}
	if(!isdefined(self.type))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	if(self.type == "missile")
	{
		if(isdefined(level._custom_weapon_CB_Func))
		{
			self thread [[level._custom_weapon_CB_Func]](localClientNum);
		}
		switch(self.weapon.name)
		{
			case "sticky_grenade":
			{
				self thread _sticky_grenade::spawned(localClientNum);
				break;
			}
		}
	}
	else if(self.type == "vehicle" || self.type == "helicopter" || self.type == "plane")
	{
		if(isdefined(level._customVehicleCBFunc))
		{
			self thread [[level._customVehicleCBFunc]](localClientNum);
		}
		self thread vehicle::field_toggle_exhaustfx_handler(localClientNum, undefined, 0, 1);
		self thread vehicle::field_toggle_lights_handler(localClientNum, undefined, 0, 1);
		if(self.type == "plane" || self.type == "helicopter")
		{
			self thread vehicle::aircraft_dustkick();
		}
		else
		{
			self thread driving_fx::play_driving_fx(localClientNum);
		}
	}
	else if(self.type == "actor")
	{
		if(isdefined(level._customActorCBFunc))
		{
			self thread [[level._customActorCBFunc]](localClientNum);
		}
	}
}

/*
	Name: host_migration
	Namespace: callback
	Checksum: 0x8E874C0B
	Offset: 0x718
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function host_migration(localClientNum)
{
	level thread prevent_round_switch_animation();
}

/*
	Name: prevent_round_switch_animation
	Namespace: callback
	Checksum: 0xCFCD975C
	Offset: 0x748
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function prevent_round_switch_animation()
{
	wait(3);
}

