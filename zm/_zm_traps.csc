#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_traps;

/*
	Name: __init__sytem__
	Namespace: zm_traps
	Checksum: 0x2088E50D
	Offset: 0xE8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_traps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_traps
	Checksum: 0x1C521A67
	Offset: 0x128
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	s_traps_array = struct::get_array("zm_traps", "targetname");
	a_registered_traps = [];
	foreach(trap in s_traps_array)
	{
		if(isdefined(trap.script_noteworthy))
		{
			if(!trap is_trap_registered(a_registered_traps))
			{
				a_registered_traps[trap.script_noteworthy] = 1;
			}
		}
	}
}

/*
	Name: is_trap_registered
	Namespace: zm_traps
	Checksum: 0x883CAE0
	Offset: 0x228
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function is_trap_registered(a_registered_traps)
{
	return isdefined(a_registered_traps[self.script_noteworthy]);
}

