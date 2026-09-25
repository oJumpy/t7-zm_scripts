#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace wasp;

/*
	Name: __init__sytem__
	Namespace: wasp
	Checksum: 0x8EBB590E
	Offset: 0x1D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("wasp", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: wasp
	Checksum: 0x6939802F
	Offset: 0x218
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("vehicle", "rocket_wasp_hijacked", 1, 1, "int", &handle_lod_display_for_driver, 0, 0);
	level.sentinelBundle = struct::get_script_bundle("killstreak", "killstreak_sentinel");
	if(isdefined(level.sentinelBundle))
	{
		vehicle::add_vehicletype_callback(level.sentinelBundle.ksVehicle, &spawned);
	}
}

/*
	Name: spawned
	Namespace: wasp
	Checksum: 0x9BB269C3
	Offset: 0x2D8
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	self.killstreakBundle = level.sentinelBundle;
}

/*
	Name: handle_lod_display_for_driver
	Namespace: wasp
	Checksum: 0x7DA71F55
	Offset: 0x300
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function handle_lod_display_for_driver(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(isdefined(self))
	{
		if(self isLocalClientDriver(localClientNum))
		{
			self SetHighDetail(1);
			wait(0.05);
			self vehicle::lights_off(localClientNum);
		}
	}
}

