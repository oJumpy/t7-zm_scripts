#namespace zm_moon_gravity;

/*
	Name: init
	Namespace: zm_moon_gravity
	Checksum: 0x99EC1590
	Offset: 0x88
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init()
{
}

/*
	Name: zombie_low_gravity
	Namespace: zm_moon_gravity
	Checksum: 0xDB43CDDC
	Offset: 0x98
	Size: 0x77
	Parameters: 7
	Flags: None
*/
function zombie_low_gravity(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("death");
	self endon("entityshutdown");
	if(newVal)
	{
		self.in_low_g = 1;
	}
	else
	{
		self.in_low_g = 0;
	}
}

/*
	Name: function_20286238
	Namespace: zm_moon_gravity
	Checksum: 0x20BB67BE
	Offset: 0x118
	Size: 0xC5
	Parameters: 7
	Flags: None
*/
function function_20286238(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("death");
	self endon("entityshutdown");
	if(newVal)
	{
		if(!isdefined(self.var_9f5aac3e))
		{
			self.var_9f5aac3e = self PlayLoopSound("zmb_moon_bg_airless");
		}
	}
	else if(isdefined(self.var_9f5aac3e))
	{
		self StopLoopSound(self.var_9f5aac3e);
		self.var_9f5aac3e = undefined;
	}
}

