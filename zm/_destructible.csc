#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace destructible;

/*
	Name: __init__sytem__
	Namespace: destructible
	Checksum: 0x49DDCBA0
	Offset: 0x100
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("destructible", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: destructible
	Checksum: 0xF8B228ED
	Offset: 0x140
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "start_destructible_explosion", 1, 10, "int", &doExplosion, 0, 0);
}

/*
	Name: playGrenadeRumble
	Namespace: destructible
	Checksum: 0x4FA47495
	Offset: 0x198
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function playGrenadeRumble(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayRumbleOnPosition(localClientNum, "grenade_rumble", self.origin);
	GetLocalPlayer(localClientNum) Earthquake(0.5, 0.5, self.origin, 800);
}

/*
	Name: doExplosion
	Namespace: destructible
	Checksum: 0x1E66F446
	Offset: 0x250
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function doExplosion(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 0)
	{
		return;
	}
	physics_explosion = 0;
	if(newVal & 1 << 9)
	{
		physics_explosion = 1;
		newVal = newVal - 1 << 9;
	}
	physics_force = 0.3;
	if(physics_explosion)
	{
		PhysicsExplosionSphere(localClientNum, self.origin, newVal, newVal - 1, physics_force, 25, 400);
	}
	playGrenadeRumble(localClientNum, self.origin);
}

