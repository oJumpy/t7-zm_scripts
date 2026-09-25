#using scripts\codescripts\struct;
#using scripts\shared\array_shared;

#namespace zm_game_module_utility;

/*
	Name: move_ring
	Namespace: zm_game_module_utility
	Checksum: 0xC2EA6A80
	Offset: 0xC8
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function move_ring(ring)
{
	positions = struct::get_array(ring.target, "targetname");
	positions = Array::randomize(positions);
	level endon("end_game");
	while(1)
	{
		foreach(position in positions)
		{
			self moveto(position.origin, randomIntRange(30, 45));
			self waittill("movedone");
		}
	}
}

/*
	Name: rotate_ring
	Namespace: zm_game_module_utility
	Checksum: 0x2B93D922
	Offset: 0x1F8
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function rotate_ring(FORWARD)
{
	level endon("end_game");
	dir = -360;
	if(FORWARD)
	{
		dir = 360;
	}
	while(1)
	{
		self RotateYaw(dir, 9);
		wait(9);
	}
}

