#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_puppet;

/*
	Name: function_ec1c999e
	Namespace: zm_puppet
	Checksum: 0x2F419328
	Offset: 0xA0
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function function_ec1c999e()
{
	/#
		self endon("death");
		self.var_8501b4a7 = 0;
		while(1)
		{
			if(isdefined(self.isPuppet) && self.isPuppet && !self.var_8501b4a7)
			{
				self notify("stop_zombie_goto_entrance");
				self.var_8501b4a7 = 1;
			}
			if(!isdefined(self.isPuppet) && self.isPuppet && self.var_8501b4a7)
			{
				self.var_8501b4a7 = 0;
			}
			if(isdefined(self.isPuppet) && self.isPuppet && zm_utility::check_point_in_playable_area(self.origin) && !isdefined(self.completed_emerging_into_playable_area))
			{
				self zm_spawner::zombie_complete_emerging_into_playable_area();
				self.barricade_enter = 0;
			}
			player = GetPlayers()[0];
			if(isdefined(player) && player buttonpressed("Dev Block strings are not supported"))
			{
				if(self.var_8501b4a7)
				{
					if(zm_utility::check_point_in_playable_area(self.goalpos) && !zm_utility::check_point_in_playable_area(self.origin))
					{
						self.var_85ae7f15 = self.goalpos;
						self thread zm_spawner::zombie_goto_entrance(self.var_5029f747, 0);
					}
					if(!zm_utility::check_point_in_playable_area(self.goalpos) && isdefined(self.var_5029f747) && self.goalpos != self.var_5029f747.origin)
					{
						self notify("stop_zombie_goto_entrance");
					}
				}
			}
			wait(0.05);
		}
	#/
}

