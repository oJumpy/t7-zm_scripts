#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_trap_fire;

/*
	Name: __init__sytem__
	Namespace: zm_trap_fire
	Checksum: 0xA7481C0E
	Offset: 0x160
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_trap_fire", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_trap_fire
	Checksum: 0xD5E3E2A7
	Offset: 0x1A0
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function __init__()
{
	a_traps = struct::get_array("trap_fire", "targetname");
	foreach(trap in a_traps)
	{
		clientfield::register("world", trap.script_noteworthy, 21000, 1, "int", &trap_fx_monitor, 0, 0);
	}
}

/*
	Name: trap_fx_monitor
	Namespace: zm_trap_fire
	Checksum: 0x92B72F08
	Offset: 0x290
	Size: 0x171
	Parameters: 7
	Flags: None
*/
function trap_fx_monitor(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	exploder_name = "trap_fire_" + fieldName;
	if(newVal)
	{
		exploder::exploder(exploder_name);
	}
	else
	{
		exploder::stop_exploder(exploder_name);
	}
	fire_points = struct::get_array(fieldName, "targetname");
	foreach(point in fire_points)
	{
		if(!isdefined(point.script_noteworthy))
		{
			if(newVal)
			{
				point thread fire_trap_fx();
				continue;
			}
			point thread stop_trap_fx();
		}
	}
}

/*
	Name: fire_trap_fx
	Namespace: zm_trap_fire
	Checksum: 0xD5B0BE98
	Offset: 0x410
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function fire_trap_fx()
{
	ang = self.angles;
	FORWARD = AnglesToForward(ang);
	up = anglesToUp(ang);
	if(isdefined(self.loopFX) && self.loopFX.size)
	{
		stop_trap_fx();
	}
	if(!isdefined(self.loopFX))
	{
		self.loopFX = [];
	}
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		self.loopFX[i] = playFX(i, level._effect["fire_trap"], self.origin, FORWARD, up, 0);
	}
}

/*
	Name: stop_trap_fx
	Namespace: zm_trap_fire
	Checksum: 0x1D332B26
	Offset: 0x548
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function stop_trap_fx()
{
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(self.loopFX[i]))
		{
			stopfx(i, self.loopFX[i]);
		}
	}
	self.loopFX = [];
}

