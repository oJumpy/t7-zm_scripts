#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;

#namespace hacker_tool;

/*
	Name: init_shared
	Namespace: hacker_tool
	Checksum: 0xE79BEDD1
	Offset: 0x280
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	clientfield::register("toplayer", "hacker_tool", 1, 2, "int", &player_hacking, 0, 0);
	level.hackingSoundId = [];
	level.hackingSweetSpotId = [];
	level.friendlyHackingSoundId = [];
	callback::on_localplayer_spawned(&on_localplayer_spawned);
}

/*
	Name: on_localplayer_spawned
	Namespace: hacker_tool
	Checksum: 0x990620EE
	Offset: 0x320
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	player = self;
	if(isdefined(level.hackingSoundId[localClientNum]))
	{
		player StopLoopSound(level.hackingSoundId[localClientNum]);
		level.hackingSoundId[localClientNum] = undefined;
	}
	if(isdefined(level.hackingSweetSpotId[localClientNum]))
	{
		player StopLoopSound(level.hackingSweetSpotId[localClientNum]);
		level.hackingSweetSpotId[localClientNum] = undefined;
	}
	if(isdefined(level.friendlyHackingSoundId[localClientNum]))
	{
		player StopLoopSound(level.friendlyHackingSoundId[localClientNum]);
		level.friendlyHackingSoundId[localClientNum] = undefined;
	}
}

/*
	Name: player_hacking
	Namespace: hacker_tool
	Checksum: 0x31D4F09C
	Offset: 0x428
	Size: 0x48B
	Parameters: 7
	Flags: None
*/
function player_hacking(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("player_hacking_callback");
	player = self;
	if(isdefined(level.hackingSoundId[localClientNum]))
	{
		player StopLoopSound(level.hackingSoundId[localClientNum]);
		level.hackingSoundId[localClientNum] = undefined;
	}
	if(isdefined(level.hackingSweetSpotId[localClientNum]))
	{
		player StopLoopSound(level.hackingSweetSpotId[localClientNum]);
		level.hackingSweetSpotId[localClientNum] = undefined;
	}
	if(isdefined(level.friendlyHackingSoundId[localClientNum]))
	{
		player StopLoopSound(level.friendlyHackingSoundId[localClientNum]);
		level.friendlyHackingSoundId[localClientNum] = undefined;
	}
	if(isdefined(player.targetEnt))
	{
		player.targetEnt duplicate_render::set_hacker_tool_hacking(localClientNum, 0);
		player.targetEnt duplicate_render::set_hacker_tool_breaching(localClientNum, 0);
		player.targetEnt.isbreachingfirewall = 0;
		player.targetEnt = undefined;
	}
	if(newVal == 2)
	{
		player thread watchHackSpeed(localClientNum, 0);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.status"), 2);
	}
	else if(newVal == 3)
	{
		player thread watchHackSpeed(localClientNum, 1);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.status"), 1);
	}
	else if(newVal == 1)
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.status"), 0);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.perc"), 0);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.offsetShaderValue"), 0 + " " + 0 + " 0 0");
		self thread WatchForEmp(localClientNum);
	}
	else
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.status"), 0);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.perc"), 0);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.offsetShaderValue"), 0 + " " + 0 + " 0 0");
	}
}

/*
	Name: watchHackSpeed
	Namespace: hacker_tool
	Checksum: 0x1DFBB7D3
	Offset: 0x8C0
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function watchHackSpeed(localClientNum, isbreachingfirewall)
{
	self endon("entityshutdown");
	self endon("player_hacking_callback");
	player = self;
	for(;;)
	{
		targetEntArray = self GetTargetLockEntityArray();
		if(targetEntArray.size > 0)
		{
			targetEnt = targetEntArray[0];
		}
		wait(0.02);
	}
	else
	{
	}
	targetEnt watchTargetHack(localClientNum, player, isbreachingfirewall);
}

/*
	Name: watchTargetHack
	Namespace: hacker_tool
	Checksum: 0xCC654700
	Offset: 0x978
	Size: 0x42B
	Parameters: 3
	Flags: None
*/
function watchTargetHack(localClientNum, player, isbreachingfirewall)
{
	self endon("entityshutdown");
	player endon("entityshutdown");
	self endon("player_hacking_callback");
	targetEnt = self;
	player.targetEnt = targetEnt;
	if(isbreachingfirewall)
	{
		targetEnt.isbreachingfirewall = 1;
		targetEnt duplicate_render::set_hacker_tool_breaching(localClientNum, 1);
	}
	targetEnt thread watchHackerPlayerShutdown(localClientNum, player, targetEnt);
	for(;;)
	{
		distanceFromCenter = targetEnt getDistanceFromScreenCenter(localClientNum);
		inverse = 40 - distanceFromCenter;
		Ratio = inverse / 40;
		heatVal = GetWeaponHackRatio(localClientNum);
		Ratio = Ratio * Ratio * Ratio * Ratio;
		if(Ratio > 1 || Ratio < 0.001)
		{
			Ratio = 0;
			horizontal = 0;
		}
		else
		{
			horizontal = targetEnt getHorizontalOffsetFromScreenCenter(localClientNum, 40);
		}
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.offsetShaderValue"), horizontal + " " + Ratio + " 0 0");
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.perc"), heatVal);
		if(Ratio > 0.8)
		{
			if(!isdefined(level.hackingSweetSpotId[localClientNum]))
			{
				level.hackingSweetSpotId[localClientNum] = player PlayLoopSound("evt_hacker_hacking_sweet");
			}
		}
		else if(isdefined(level.hackingSweetSpotId[localClientNum]))
		{
			player StopLoopSound(level.hackingSweetSpotId[localClientNum]);
			level.hackingSweetSpotId[localClientNum] = undefined;
		}
		if(!isdefined(level.hackingSoundId[localClientNum]))
		{
			level.hackingSoundId[localClientNum] = player PlayLoopSound("evt_hacker_hacking_loop");
		}
		if(isdefined(level.hackingSoundId[localClientNum]))
		{
			setSoundPitch(level.hackingSoundId[localClientNum], Ratio);
		}
		if(!isbreachingfirewall)
		{
			friendlyHacking = WeaponFriendlyHacking(localClientNum);
			if(friendlyHacking && !isdefined(level.friendlyHackingSoundId[localClientNum]))
			{
				level.friendlyHackingSoundId[localClientNum] = player PlayLoopSound("evt_hacker_hacking_loop_mult");
			}
			else if(!friendlyHacking && isdefined(level.friendlyHackingSoundId[localClientNum]))
			{
				player StopLoopSound(level.friendlyHackingSoundId[localClientNum]);
				level.friendlyHackingSoundId[localClientNum] = undefined;
			}
		}
		wait(0.1);
	}
}

/*
	Name: watchHackerPlayerShutdown
	Namespace: hacker_tool
	Checksum: 0xEF93BB3E
	Offset: 0xDB0
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function watchHackerPlayerShutdown(localClientNum, hackerPlayer, targetEnt)
{
	self endon("entityshutdown");
	killstreakEntity = self;
	hackerPlayer endon("player_hacking_callback");
	hackerPlayer waittill("entityshutdown");
	if(isdefined(targetEnt))
	{
		targetEnt.isbreachingfirewall = 1;
	}
	killstreakEntity duplicate_render::set_hacker_tool_hacking(localClientNum, 0);
	killstreakEntity duplicate_render::set_hacker_tool_breaching(localClientNum, 0);
}

/*
	Name: WatchForEmp
	Namespace: hacker_tool
	Checksum: 0x79EDE318
	Offset: 0xE68
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function WatchForEmp(localClientNum)
{
	self endon("entityshutdown");
	self endon("player_hacking_callback");
	while(1)
	{
		if(self IsEmpJammed())
		{
			SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.status"), 3);
		}
		else
		{
			SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "hudItems.blackhat.status"), 0);
		}
		wait(0.1);
	}
}

