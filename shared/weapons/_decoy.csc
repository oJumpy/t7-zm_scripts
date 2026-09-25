#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace decoy;

/*
	Name: init_shared
	Namespace: decoy
	Checksum: 0x9C1B8C04
	Offset: 0xF8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level thread level_watch_for_fake_fire();
	callback::add_weapon_type("nightingale", &spawned);
}

/*
	Name: spawned
	Namespace: decoy
	Checksum: 0x32F989BD
	Offset: 0x148
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	self thread watch_for_fake_fire(localClientNum);
}

/*
	Name: watch_for_fake_fire
	Namespace: decoy
	Checksum: 0x346133B7
	Offset: 0x178
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function watch_for_fake_fire(localClientNum)
{
	self endon("entityshutdown");
	while(1)
	{
		self waittill("fake_fire");
		PlayFXOnTag(localClientNum, level._effect["decoy_fire"], self, "tag_origin");
	}
}

/*
	Name: level_watch_for_fake_fire
	Namespace: decoy
	Checksum: 0xECBE9D4F
	Offset: 0x1E0
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function level_watch_for_fake_fire()
{
	while(1)
	{
		self waittill("fake_fire", origin);
	}
}

