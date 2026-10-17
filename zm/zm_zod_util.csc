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
		self thread player_continuous_rumble(localClientNum, 1);
	}
	else if(newVal == 6)
	{
		self notify("stop_rumble_and_shake");
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
		self thread player_continuous_rumble(localClientNum, 1, 0);
	}
	else
	{
		self notify("stop_rumble_and_shake");
	}
}

/*
	Name: player_continuous_rumble
	Namespace: namespace_8e578893
	Checksum: 0xDAF0A5D6
	Offset: 0x400
	Size: 0x17F
	Parameters: 3
	Flags: None
*/
function player_continuous_rumble(localClientNum, rumble_level, shake_camera)
{
	if(!isdefined(shake_camera))
	{
		shake_camera = 1;
	}
	self notify("stop_rumble_and_shake");
	self endon("disconnect");
	self endon("stop_rumble_and_shake");
	start_time = GetTime();
	while(GetTime() - start_time < 120000)
	{
		if(isdefined(self) && self isLocalPlayer() && isdefined(self))
		{
			if(rumble_level == 1)
			{
				if(shake_camera)
				{
					self Earthquake(0.2, 1, self.origin, 100);
				}
				self PlayRumbleOnEntity(localClientNum, "reload_small");
				wait(0.05);
			}
			else if(shake_camera)
			{
				self Earthquake(0.3, 1, self.origin, 100);
			}
			self PlayRumbleOnEntity(localClientNum, "damage_light");
		}
		wait(0.1);
	}
}

