#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace skeleton;

/*
	Name: __init__sytem__
	Namespace: skeleton
	Checksum: 0xB77616BF
	Offset: 0x138
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("skeleton", &__init__, undefined, undefined);
}

/*
	Name: Precache
	Namespace: skeleton
	Checksum: 0x99EC1590
	Offset: 0x178
	Size: 0x3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
}

/*
	Name: __init__
	Namespace: skeleton
	Checksum: 0x90EDA43C
	Offset: 0x188
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(ai::shouldRegisterClientFieldForArchetype("skeleton"))
	{
		clientfield::register("actor", "skeleton", 1, 1, "int", &ZombieClientUtils::zombieHandler, 0, 0);
	}
}

#namespace ZombieClientUtils;

/*
	Name: zombieHandler
	Namespace: ZombieClientUtils
	Checksum: 0xCDFB6200
	Offset: 0x1F8
	Size: 0x183
	Parameters: 7
	Flags: None
*/
function zombieHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(isdefined(entity.archetype) && entity.archetype != "zombie")
	{
		return;
	}
	if(!isdefined(entity.initializedGibCallbacks) || !entity.initializedGibCallbacks)
	{
		entity.initializedGibCallbacks = 1;
		GibClientUtils::AddGibCallback(localClientNum, entity, 8, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 16, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 32, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 128, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 256, &_gibCallback);
	}
}

/*
	Name: _gibCallback
	Namespace: ZombieClientUtils
	Checksum: 0x3AC2300A
	Offset: 0x388
	Size: 0xA5
	Parameters: 3
	Flags: Private
*/
function private _gibCallback(localClientNum, entity, gibFlag)
{
	switch(gibFlag)
	{
		case 8:
		{
			playsound(0, "zmb_zombie_head_gib", self.origin);
			break;
		}
		case 16:
		case 32:
		case 128:
		case 256:
		{
			playsound(0, "zmb_death_gibs", self.origin);
			break;
		}
	}
}

