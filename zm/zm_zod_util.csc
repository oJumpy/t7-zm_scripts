#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_8e578893;

/*
	Name: function_f118a0e7
	Namespace: namespace_8e578893
	Checksum: 0x7873F0D8
	Offset: 0x180
	Size: 0x275
	Parameters: 7
	Flags: None
*/
function function_f118a0e7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("disconnect");
	if(newVal == 5)
	{
		self thread function_878b1e6c(localClientNum, 1);
	}
	else if(newVal == 6)
	{
		self notify("hash_f9095a82");
		self Earthquake(0.6, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
	}
	else if(newVal == 4)
	{
		self Earthquake(0.6, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
	}
	else if(newVal == 3)
	{
		self Earthquake(0.3, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "shotgun_fire");
	}
	else if(newVal == 2)
	{
		self Earthquake(0.1, 1, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "damage_heavy");
	}
	else if(newVal == 1)
	{
		self PlayRumbleOnEntity(localClientNum, "damage_light");
	}
	else if(newVal == 7)
	{
		self thread function_878b1e6c(localClientNum, 1, 0);
	}
	else
	{
		self notify("hash_f9095a82");
	}
}

/*
	Name: function_878b1e6c
	Namespace: namespace_8e578893
	Checksum: 0xDAF0A5D6
	Offset: 0x400
	Size: 0x17F
	Parameters: 3
	Flags: None
*/
function function_878b1e6c(localClientNum, var_4be1e559, var_d2e77e71)
{
	if(!isdefined(var_d2e77e71))
	{
		var_d2e77e71 = 1;
	}
	self notify("hash_f9095a82");
	self endon("disconnect");
	self endon("hash_f9095a82");
	start_time = GetTime();
	while(GetTime() - start_time < 120000)
	{
		if(isdefined(self) && self isLocalPlayer() && isdefined(self))
		{
			if(var_4be1e559 == 1)
			{
				if(var_d2e77e71)
				{
					self Earthquake(0.2, 1, self.origin, 100);
				}
				self PlayRumbleOnEntity(localClientNum, "reload_small");
				wait(0.05);
			}
			else if(var_d2e77e71)
			{
				self Earthquake(0.3, 1, self.origin, 100);
			}
			self PlayRumbleOnEntity(localClientNum, "damage_light");
		}
		wait(0.1);
	}
}

