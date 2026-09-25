#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_trap_electric;

/*
	Name: __init__sytem__
	Namespace: zm_trap_electric
	Checksum: 0x26A0FAC0
	Offset: 0x170
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_trap_electric", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_trap_electric
	Checksum: 0x7FCEB13D
	Offset: 0x1B0
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_electrified("zm_trap_electric", 1, 15, 1.25);
	a_traps = struct::get_array("trap_electric", "targetname");
	foreach(trap in a_traps)
	{
		clientfield::register("world", trap.script_noteworthy, 1, 1, "int", &trap_fx_monitor, 0, 0);
	}
}

/*
	Name: trap_fx_monitor
	Namespace: zm_trap_electric
	Checksum: 0x4B16959A
	Offset: 0x2C8
	Size: 0x171
	Parameters: 7
	Flags: None
*/
function trap_fx_monitor(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	exploder_name = "trap_electric_" + fieldName;
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
				point thread electric_trap_fx();
				continue;
			}
			point thread stop_trap_fx();
		}
	}
}

/*
	Name: electric_trap_fx
	Namespace: zm_trap_electric
	Checksum: 0xF5FAC119
	Offset: 0x448
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function electric_trap_fx()
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
		self.loopFX[i] = playFX(i, level._effect["zapper"], self.origin, FORWARD, up, 0);
	}
}

/*
	Name: stop_trap_fx
	Namespace: zm_trap_electric
	Checksum: 0xC2CFFC0C
	Offset: 0x580
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

