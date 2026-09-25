#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_util;
#using scripts\zm\_zm_placeable_mine;

#namespace bouncingbetty;

/*
	Name: __init__sytem__
	Namespace: bouncingbetty
	Checksum: 0x43C5DE25
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bouncingbetty", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bouncingbetty
	Checksum: 0x6C2E6E41
	Offset: 0x1F0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._proximityWeaponObjectDetonation_override = &proximityWeaponObjectDetonation_override;
	init_shared();
	zm_placeable_mine::add_mine_type("bouncingbetty", &"MP_BOUNCINGBETTY_PICKUP");
	level.bettyJumpHeight = 55;
	level.bettyDamageMax = 1000;
	level.bettyDamageMin = 800;
	level.bettyDamageHeight = level.bettyJumpHeight;
	/#
		SetDvar("Dev Block strings are not supported", level.bettyDamageMax);
		SetDvar("Dev Block strings are not supported", level.bettyDamageMin);
		SetDvar("Dev Block strings are not supported", level.bettyJumpHeight);
	#/
}

/*
	Name: proximityWeaponObjectDetonation_override
	Namespace: bouncingbetty
	Checksum: 0x7D73C82A
	Offset: 0x2E0
	Size: 0x177
	Parameters: 1
	Flags: None
*/
function proximityWeaponObjectDetonation_override(watcher)
{
	self endon("death");
	self endon("hacked");
	self endon("kill_target_detection");
	weaponobjects::proximityWeaponObject_ActivationDelay(watcher);
	damagearea = weaponobjects::proximityWeaponObject_CreateDamageArea(watcher);
	up = anglesToUp(self.angles);
	traceOrigin = self.origin + up;
	if(isdefined(level._bouncingBettyWatchForTrigger))
	{
		self thread [[level._bouncingBettyWatchForTrigger]](watcher);
	}
	while(1)
	{
		damagearea waittill("trigger", ent);
		if(!weaponobjects::proximityWeaponObject_ValidTriggerEntity(watcher, ent))
		{
			continue;
		}
		if(weaponobjects::proximityWeaponObject_IsSpawnProtected(watcher, ent))
		{
			continue;
		}
		if(ent damageConeTrace(traceOrigin, self) > 0)
		{
			thread weaponobjects::proximityWeaponObject_DoDetonation(watcher, ent, traceOrigin);
		}
	}
}

