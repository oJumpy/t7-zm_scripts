#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_playerhealth;

/*
	Name: __init__sytem__
	Namespace: zm_playerhealth
	Checksum: 0xEE20FC50
	Offset: 0x190
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_playerhealth", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_playerhealth
	Checksum: 0x2F6AE073
	Offset: 0x1D0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "sndZombieHealth", 21000, 1, "int", &sndZombieHealth, 0, 1);
	visionset_mgr::register_overlay_info_style_speed_blur("zm_health_blur", 1, 1, 0.1, 0.5, 0.75, 0, 0, 500, 500, 0);
}

/*
	Name: sndZombieHealth
	Namespace: zm_playerhealth
	Checksum: 0x38B51BF0
	Offset: 0x270
	Size: 0x113
	Parameters: 7
	Flags: None
*/
function sndZombieHealth(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!isdefined(self.sndZombieHealthID))
		{
			playsound(0, "zmb_health_lowhealth_enter", self.origin);
			self.sndZombieHealthID = self PlayLoopSound("zmb_health_lowhealth_loop");
		}
	}
	else if(isdefined(self.sndZombieHealthID))
	{
		self StopLoopSound(self.sndZombieHealthID);
		self.sndZombieHealthID = undefined;
		if(!(isdefined(self.inLastStand) && self.inLastStand))
		{
			playsound(0, "zmb_health_lowhealth_exit", self.origin);
		}
	}
}

