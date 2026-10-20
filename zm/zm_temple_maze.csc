#namespace zm_temple_maze;

/*
	Name: maze_trap_move_wall
	Namespace: zm_temple_maze
	Checksum: 0x3D467A86
	Offset: 0xD0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function maze_trap_move_wall(localClientNum, active)
{
	if(!isdefined(self.wall))
	{
		self set_maze_trap_wall(localClientNum);
	}
	wall = self.wall;
	if(isdefined(wall))
	{
		wall thread maze_wall_init(localClientNum);
		wall thread move_maze_wall(active);
	}
}

/*
	Name: maze_wall_init
	Namespace: zm_temple_maze
	Checksum: 0xA8884E9F
	Offset: 0x168
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function maze_wall_init(localClientNum)
{
	if(!isdefined(self.init) || !self.init)
	{
		self init_maze_mover(-128, 0.25, 1, 1, "evt_maze_wall_down", "evt_maze_wall_up");
		self.script_fxid = level._effect["maze_wall_impact"];
		self.script_fxid2 = level._effect["maze_wall_raise"];
		self.fx_active_offset = VectorScale((0, 0, -1), 60);
		self.fx_active2_offset = VectorScale((0, 0, 1), 75);
		self.init = 1;
		self.client_num = localClientNum;
	}
}

/*
	Name: init_maze_mover
	Namespace: zm_temple_maze
	Checksum: 0xB9663D49
	Offset: 0x248
	Size: 0xD7
	Parameters: 6
	Flags: None
*/
function init_maze_mover(moveDist, moveUpTime, moveDownTime, blockspaths, moveupsound, movedownsound)
{
	self.isActive = 0;
	self.activeCount = 0;
	self.ismoving = 0;
	self.moveDist = moveDist;
	self.activeheight = self.origin[2] + moveDist;
	self.moveUpTime = moveUpTime;
	self.moveDownTime = moveDownTime;
	self.pathblocker = 0;
	self.alwaysactive = 0;
	self.moveupsound = moveupsound;
	self.movedownsound = movedownsound;
	self.startAngles = self.angles;
}

/*
	Name: move_maze_wall
	Namespace: zm_temple_maze
	Checksum: 0xE8B5DA90
	Offset: 0x328
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function move_maze_wall(active)
{
	goalpos = (self.origin[0], self.origin[1], self.activeheight);
	if(!active)
	{
		goalpos = (goalpos[0], goalpos[1], goalpos[2] - self.moveDist);
	}
	moveTime = self.moveUpTime;
	if(!active)
	{
		moveTime = self.moveDownTime;
	}
	if(self.ismoving)
	{
		currentz = self.origin[2];
		goalz = goalpos[2];
		Ratio = Abs(goalz - currentz) / Abs(self.moveDist);
		moveTime = moveTime * Ratio;
	}
	self notify("stop_maze_mover", !active && isdefined(self.movedownsound), active && isdefined(self.moveupsound));
	self.isActive = active;
	self thread _maze_mover_move(goalpos, moveTime);
}

/*
	Name: set_maze_trap_wall
	Namespace: zm_temple_maze
	Checksum: 0xA11B60E2
	Offset: 0x4C8
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function set_maze_trap_wall(localClientNum)
{
	walls = GetEntArray(localClientNum, "maze_trap_wall", "targetname");
	bestwall = undefined;
	bestdist = undefined;
	for(i = 0; i < walls.size; i++)
	{
		wall = walls[i];
		if(isdefined(wall.assigned))
		{
			continue;
		}
		dist = DistanceSquared(self.origin, wall.origin);
		if(!isdefined(bestdist) || dist < bestdist)
		{
			bestdist = dist;
			bestwall = wall;
		}
	}
	self.wall = bestwall;
	if(isdefined(self.wall))
	{
		self.wall.assigned = 1;
	}
}

/*
	Name: _maze_mover_move
	Namespace: zm_temple_maze
	Checksum: 0x785543EC
	Offset: 0x618
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function _maze_mover_move(goal, time)
{
	self endon("stop_maze_mover");
	self.ismoving = 1;
	if(time == 0)
	{
		time = 0.01;
	}
	if(self.isActive === 0)
	{
		_maze_mover_play_fx(self.script_fxid2, self.fx_active2_offset);
	}
	self moveto(goal, time);
	self waittill("movedone");
	self.ismoving = 0;
	if(self.isActive === 1)
	{
		_maze_mover_play_fx(self.script_fxid, self.fx_active_offset);
	}
}

/*
	Name: _maze_mover_play_fx
	Namespace: zm_temple_maze
	Checksum: 0xA5A6B046
	Offset: 0x700
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function _maze_mover_play_fx(fx_name, offset)
{
	if(isdefined(fx_name))
	{
		vFwd = AnglesToForward(self.angles);
		org = self.origin;
		if(isdefined(offset))
		{
			org = org + offset;
		}
		playFX(self.client_num, fx_name, org, vFwd, (0, 0, 1));
	}
}

