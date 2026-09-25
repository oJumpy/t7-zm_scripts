#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;

#namespace namespace_29da2c3c;

/*
	Name: init
	Namespace: namespace_29da2c3c
	Checksum: 0xE7A39EB6
	Offset: 0xE8
	Size: 0x83
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	zombie_utility::register_ignore_player_handler("margwa", &function_478e89a7);
	zombie_utility::register_ignore_player_handler("zombie", &function_478e89a7);
	level.raps_can_reach_inaccessible_location = &raps_can_reach_inaccessible_location;
	level.is_player_accessible_to_raps = &is_player_accessible_to_raps;
}

/*
	Name: function_478e89a7
	Namespace: namespace_29da2c3c
	Checksum: 0x3BEE7064
	Offset: 0x178
	Size: 0x215
	Parameters: 0
	Flags: Private
*/
function private function_478e89a7()
{
	self.ignore_player = [];
	foreach(player in level.players)
	{
		if(isdefined(player.teleporting) && player.teleporting)
		{
			Array::add(self.ignore_player, player);
			continue;
		}
		if(isdefined(player.on_train) && player.on_train)
		{
			var_d3443466 = function_3e62f527();
			if(!isdefined(self.var_e0d198e4) && self.var_e0d198e4 && (!isdefined(var_d3443466) && var_d3443466))
			{
				touching = function_406e4ba9(level.o_zod_train);
				if(!touching)
				{
					Array::add(self.ignore_player, player);
				}
			}
		}
		if(isdefined(self.var_81ac9e79) && self.var_81ac9e79 && (!isdefined(player.var_84f1bc44) && player.var_84f1bc44))
		{
			Array::add(self.ignore_player, player);
			continue;
		}
		if(isdefined(self.var_de609f65) && player !== self.var_de609f65)
		{
			Array::add(self.ignore_player, player);
			continue;
		}
	}
}

/*
	Name: raps_can_reach_inaccessible_location
	Namespace: namespace_29da2c3c
	Checksum: 0xFFD17D44
	Offset: 0x398
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function raps_can_reach_inaccessible_location()
{
	if(function_406e4ba9(level.o_zod_train))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_player_accessible_to_raps
	Namespace: namespace_29da2c3c
	Checksum: 0x895C738A
	Offset: 0x3C8
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function is_player_accessible_to_raps(player)
{
	if(isdefined(player.on_train) && player.on_train)
	{
		var_d3443466 = function_3e62f527();
		if(!isdefined(self.var_e0d198e4) && self.var_e0d198e4 && (!isdefined(var_d3443466) && var_d3443466))
		{
			return 0;
		}
	}
	return 1;
}

