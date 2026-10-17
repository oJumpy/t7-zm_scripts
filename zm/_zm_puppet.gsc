#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_puppet;

/*
	Name: wait_for_puppet_pickup
	Namespace: zm_puppet
	Checksum: 0x2F419328
	Offset: 0xA0
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function wait_for_puppet_pickup()
{
	/#
		self endon("death");
		self.iscurrentlypuppet = 0;
		while(1)
		{
			if(isdefined(self.isPuppet) && self.isPuppet && !self.iscurrentlypuppet)
			{
				self notify("stop_zombie_goto_entrance");
				self.iscurrentlypuppet = 1;
			}
			if(!isdefined(self.isPuppet) && self.isPuppet && self.iscurrentlypuppet)
			{
				self.iscurrentlypuppet = 0;
			}
			if(isdefined(self.isPuppet) && self.isPuppet && zm_utility::check_point_in_playable_area(self.origin) && !isdefined(self.completed_emerging_into_playable_area))
			{
				self zm_spawner::zombie_complete_emerging_into_playable_area();
				self.barricade_enter = 0;
			}
			player = GetPlayers()[0];
			if(isdefined(player) && player buttonpressed("Dev Block strings are not supported"))
			{
				if(self.iscurrentlypuppet)
				{
					if(zm_utility::check_point_in_playable_area(self.goalpos) && !zm_utility::check_point_in_playable_area(self.origin))
					{
						self.var_85ae7f15 = self.goalpos;
						self thread zm_spawner::zombie_goto_entrance(self.backupnode, 0);
					}
					if(!zm_utility::check_point_in_playable_area(self.goalpos) && isdefined(self.backupnode) && self.goalpos != self.backupnode.origin)
					{
						self notify("stop_zombie_goto_entrance");
					}
				}
			}
			wait(0.05);
		}
	#/
}

