#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace objPoints;

/*
	Name: __init__sytem__
	Namespace: objPoints
	Checksum: 0xD15E79DA
	Offset: 0xF8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("objpoints", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: objPoints
	Checksum: 0x7831EA7C
	Offset: 0x138
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.objPointNames = [];
	level.objPoints = [];
	if(isdefined(level.Splitscreen) && level.Splitscreen)
	{
		level.objPointSize = 15;
	}
	else
	{
		level.objPointSize = 8;
	}
	level.objpoint_alpha_default = 1;
	level.objPointScale = 1;
}

/*
	Name: create
	Namespace: objPoints
	Checksum: 0x2FE5353D
	Offset: 0x1B0
	Size: 0x2B9
	Parameters: 6
	Flags: None
*/
function create(name, origin, team, shader, alpha, scale)
{
	/#
		Assert(isdefined(level.teams[team]) || team == "Dev Block strings are not supported");
	#/
	objPoint = get_by_name(name);
	if(isdefined(objPoint))
	{
		delete(objPoint);
	}
	if(!isdefined(shader))
	{
		shader = "objpoint_default";
	}
	if(!isdefined(scale))
	{
		scale = 1;
	}
	if(team != "all")
	{
		objPoint = NewTeamHudElem(team);
	}
	else
	{
		objPoint = NewHudElem();
	}
	objPoint.name = name;
	objPoint.x = origin[0];
	objPoint.y = origin[1];
	objPoint.z = origin[2];
	objPoint.team = team;
	objPoint.isFlashing = 0;
	objPoint.isShown = 1;
	objPoint.fadeWhenTargeted = 1;
	objPoint.archived = 0;
	objPoint SetShader(shader, level.objPointSize, level.objPointSize);
	objPoint setWaypoint(1);
	if(isdefined(alpha))
	{
		objPoint.alpha = alpha;
	}
	else
	{
		objPoint.alpha = level.objpoint_alpha_default;
	}
	objPoint.baseAlpha = objPoint.alpha;
	objPoint.index = level.objPointNames.size;
	level.objPoints[name] = objPoint;
	level.objPointNames[level.objPointNames.size] = name;
	return objPoint;
}

/*
	Name: delete
	Namespace: objPoints
	Checksum: 0xB116F0AD
	Offset: 0x478
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function delete(oldObjPoint)
{
	/#
		Assert(level.objPoints.size == level.objPointNames.size);
	#/
	if(level.objPoints.size == 1)
	{
		/#
			Assert(level.objPointNames[0] == oldObjPoint.name);
		#/
		/#
			Assert(isdefined(level.objPoints[oldObjPoint.name]));
		#/
		level.objPoints = [];
		level.objPointNames = [];
		oldObjPoint destroy();
		return;
	}
	newIndex = oldObjPoint.index;
	oldIndex = level.objPointNames.size - 1;
	objPoint = get_by_index(oldIndex);
	level.objPointNames[newIndex] = objPoint.name;
	objPoint.index = newIndex;
	level.objPointNames[oldIndex] = undefined;
	level.objPoints[oldObjPoint.name] = undefined;
	oldObjPoint destroy();
}

/*
	Name: update_origin
	Namespace: objPoints
	Checksum: 0x6EE1AE52
	Offset: 0x628
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function update_origin(origin)
{
	if(self.x != origin[0])
	{
		self.x = origin[0];
	}
	if(self.y != origin[1])
	{
		self.y = origin[1];
	}
	if(self.z != origin[2])
	{
		self.z = origin[2];
	}
}

/*
	Name: set_origin_by_name
	Namespace: objPoints
	Checksum: 0x44DD6A72
	Offset: 0x6B0
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function set_origin_by_name(name, origin)
{
	objPoint = get_by_name(name);
	objPoint update_origin(origin);
}

/*
	Name: get_by_name
	Namespace: objPoints
	Checksum: 0x67D97810
	Offset: 0x710
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function get_by_name(name)
{
	if(isdefined(level.objPoints[name]))
	{
		return level.objPoints[name];
	}
	else
	{
		return undefined;
	}
}

/*
	Name: get_by_index
	Namespace: objPoints
	Checksum: 0xF9C082C5
	Offset: 0x750
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function get_by_index(index)
{
	if(isdefined(level.objPointNames[index]))
	{
		return level.objPoints[level.objPointNames[index]];
	}
	else
	{
		return undefined;
	}
}

/*
	Name: start_flashing
	Namespace: objPoints
	Checksum: 0x8A0FE3D7
	Offset: 0x798
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function start_flashing()
{
	self endon("stop_flashing_thread");
	if(self.isFlashing)
	{
		return;
	}
	self.isFlashing = 1;
	while(self.isFlashing)
	{
		self fadeOverTime(0.75);
		self.alpha = 0.35 * self.baseAlpha;
		wait(0.75);
		self fadeOverTime(0.75);
		self.alpha = self.baseAlpha;
		wait(0.75);
	}
	self.alpha = self.baseAlpha;
}

/*
	Name: stop_flashing
	Namespace: objPoints
	Checksum: 0xFF3D7255
	Offset: 0x858
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function stop_flashing()
{
	if(!self.isFlashing)
	{
		return;
	}
	self.isFlashing = 0;
}

