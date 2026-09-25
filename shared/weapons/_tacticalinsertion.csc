#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace tacticalinsertion;

/*
	Name: init_shared
	Namespace: tacticalinsertion
	Checksum: 0x89FF87CC
	Offset: 0x1F8
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["tacticalInsertionFriendly"] = "_t6/misc/fx_equip_tac_insert_light_grn";
	level._effect["tacticalInsertionEnemy"] = "_t6/misc/fx_equip_tac_insert_light_red";
	clientfield::register("scriptmover", "tacticalinsertion", 1, 1, "int", &spawned, 0, 0);
	latLongStruct = struct::get("lat_long", "targetname");
	if(isdefined(latLongStruct))
	{
		mapX = latLongStruct.origin[0];
		mapY = latLongStruct.origin[1];
		Lat = latLongStruct.script_vector[0];
		long = latLongStruct.script_vector[1];
	}
	else if(isdefined(level.worldMapX) && isdefined(level.worldMapY))
	{
		mapX = level.worldMapX;
		mapY = level.worldMapY;
	}
	else
	{
		mapX = 0;
		mapY = 0;
	}
	if(isdefined(level.worldLat) && isdefined(level.worldLong))
	{
		Lat = level.worldLat;
		long = level.worldLong;
	}
	else
	{
		Lat = 34.02156;
		long = -118.4487;
	}
	SetMapLatLong(mapX, mapY, long, Lat);
}

/*
	Name: spawned
	Namespace: tacticalinsertion
	Checksum: 0xD1B26E43
	Offset: 0x3F8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function spawned(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!newVal)
	{
		return;
	}
	self thread checkForPlayerSwitch(localClientNum);
}

/*
	Name: playFlareFX
	Namespace: tacticalinsertion
	Checksum: 0x6C028CAD
	Offset: 0x460
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function playFlareFX(localClientNum)
{
	self endon("entityshutdown");
	level endon("player_switch");
	if(util::friend_not_foe(localClientNum))
	{
		self.tacticalInsertionFX = PlayFXOnTag(localClientNum, level._effect["tacticalInsertionFriendly"], self, "tag_flash");
	}
	else
	{
		self.tacticalInsertionFX = PlayFXOnTag(localClientNum, level._effect["tacticalInsertionEnemy"], self, "tag_flash");
	}
	self thread watchTacInsertShutdown(localClientNum, self.tacticalInsertionFX);
	loopOrigin = self.origin;
	audio::playloopat("fly_tinsert_beep", loopOrigin);
	self thread stopflareloopWatcher(loopOrigin);
}

/*
	Name: watchTacInsertShutdown
	Namespace: tacticalinsertion
	Checksum: 0x346141D1
	Offset: 0x588
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function watchTacInsertShutdown(localClientNum, fxHandle)
{
	self waittill("entityshutdown");
	stopfx(localClientNum, fxHandle);
}

/*
	Name: stopflareloopWatcher
	Namespace: tacticalinsertion
	Checksum: 0x63CEF46E
	Offset: 0x5D0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function stopflareloopWatcher(loopOrigin)
{
	while(1)
	{
		if(!isdefined(self) || !isdefined(self.tacticalInsertionFX))
		{
			audio::stoploopat("fly_tinsert_beep", loopOrigin);
			break;
		}
		wait(0.5);
	}
}

/*
	Name: checkForPlayerSwitch
	Namespace: tacticalinsertion
	Checksum: 0x2CF0F956
	Offset: 0x638
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function checkForPlayerSwitch(localClientNum)
{
	self endon("entityshutdown");
	while(1)
	{
		level waittill("player_switch");
		if(isdefined(self.tacticalInsertionFX))
		{
			stopfx(localClientNum, self.tacticalInsertionFX);
			self.tacticalInsertionFX = undefined;
		}
		waittillframeend;
	}
}

