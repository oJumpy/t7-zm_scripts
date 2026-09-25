#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace RobotPhalanx;

/*
	Name: _AssignPhalanxStance
	Namespace: RobotPhalanx
	Checksum: 0xD2C9FD3B
	Offset: 0x268
	Size: 0xF1
	Parameters: 2
	Flags: Private
*/
function private _AssignPhalanxStance(robots, stance)
{
	/#
		Assert(IsArray(robots));
	#/
	foreach(robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			robot ai::set_behavior_attribute("phalanx_force_stance", stance);
		}
	}
}

/*
	Name: _CreatePhalanxTier
	Namespace: RobotPhalanx
	Checksum: 0xFABDF871
	Offset: 0x368
	Size: 0x25F
	Parameters: 6
	Flags: Private
*/
function private _CreatePhalanxTier(phalanxType, tier, phalanxPosition, FORWARD, maxTierSize, spawner)
{
	if(!isdefined(spawner))
	{
		spawner = undefined;
	}
	robots = [];
	if(!IsSpawner(spawner))
	{
		spawner = _GetPhalanxSpawner(tier);
	}
	positions = _GetPhalanxPositions(phalanxType, tier);
	angles = VectorToAngles(FORWARD);
	foreach(position in positions)
	{
		if(index >= maxTierSize)
		{
			break;
		}
		orientedPos = _RotateVec(position, angles[1] - 90);
		navmeshPosition = GetClosestPointOnNavMesh(phalanxPosition + orientedPos, 200);
		if(!spawner.SPAWNFLAGS & 64)
		{
			spawner.count++;
		}
		robot = spawner spawner::spawn(1, "", navmeshPosition, angles);
		if(isalive(robot))
		{
			_InitializeRobot(robot);
			wait(0.05);
			robots[robots.size] = robot;
		}
	}
	return robots;
}

/*
	Name: _DampenExplosiveDamage
	Namespace: RobotPhalanx
	Checksum: 0x6F1E95CB
	Offset: 0x5D0
	Size: 0x1C7
	Parameters: 12
	Flags: Private
*/
function private _DampenExplosiveDamage(inflictor, attacker, damage, flags, meansOfDamage, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	isExplosive = IsInArray(Array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDamage);
	if(isExplosive && isdefined(inflictor) && isdefined(inflictor.weapon))
	{
		weapon = inflictor.weapon;
		distanceToEntity = Distance(entity.origin, inflictor.origin);
		fractionDistance = 1;
		if(weapon.explosionRadius > 0)
		{
			fractionDistance = weapon.explosionRadius - distanceToEntity / weapon.explosionRadius;
		}
		return Int(max(damage * fractionDistance, 1));
	}
	return damage;
}

/*
	Name: _GetPhalanxPositions
	Namespace: RobotPhalanx
	Checksum: 0x37E389C4
	Offset: 0x7A0
	Size: 0x4E3
	Parameters: 2
	Flags: Private
*/
function private _GetPhalanxPositions(phalanxType, tier)
{
	switch(phalanxType)
	{
		case "phanalx_wedge":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array((0, 0, 0), (-64, -48, 0), (64, -48, 0), (-128, -96, 0), (128, -96, 0));
				}
				case "phalanx_tier2":
				{
					return Array((-32, -96, 0), (32, -96, 0));
				}
				case "phalanx_tier3":
				{
					return Array();
				}
			}
			break;
		}
		case "phalanx_diagonal_left":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array((0, 0, 0), (-48, -64, 0), (-96, -128, 0), (-144, -192, 0));
				}
				case "phalanx_tier2":
				{
					return Array(VectorScale((1, 0, 0), 64), (16, -64, 0), (-48, -128, 0), (-112, -192, 0));
				}
				case "phalanx_tier3":
				{
					return Array();
				}
			}
			break;
		}
		case "phalanx_diagonal_right":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array((0, 0, 0), (48, -64, 0), (96, -128, 0), (144, -192, 0));
				}
				case "phalanx_tier2":
				{
					return Array(VectorScale((-1, 0, 0), 64), (-16, -64, 0), (48, -128, 0), (112, -192, 0));
				}
				case "phalanx_tier3":
				{
					return Array();
				}
			}
			break;
		}
		case "phalanx_forward":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array((0, 0, 0), VectorScale((1, 0, 0), 64), VectorScale((1, 0, 0), 128), VectorScale((1, 0, 0), 192));
				}
				case "phalanx_tier2":
				{
					return Array((-32, -64, 0), (32, -64, 0), (96, -64, 0), (160, -64, 0));
				}
				case "phalanx_tier3":
				{
					return Array();
				}
			}
			break;
		}
		case "phalanx_column":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array((0, 0, 0), VectorScale((-1, 0, 0), 64), VectorScale((0, -1, 0), 64), VectorScale((-1, -1, 0), 64));
				}
				case "phalanx_tier2":
				{
					return Array(VectorScale((0, -1, 0), 128), (-64, -128, 0), VectorScale((0, -1, 0), 192), (-64, -192, 0));
				}
				case "phalanx_tier3":
				{
					return Array();
				}
			}
			break;
		}
		case "phalanx_column_right":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array((0, 0, 0), VectorScale((0, -1, 0), 64), VectorScale((0, -1, 0), 128), VectorScale((0, -1, 0), 192));
				}
				case "phalanx_tier2":
				{
					return Array();
				}
				case "phalanx_tier3":
				{
					return Array();
				}
			}
			break;
		}
		case default:
		{
			/#
				Assert("Dev Block strings are not supported" + phalanxType + "Dev Block strings are not supported");
			#/
		}
	}
	/#
		Assert("Dev Block strings are not supported" + tier + "Dev Block strings are not supported");
	#/
}

/*
	Name: _GetPhalanxSpawner
	Namespace: RobotPhalanx
	Checksum: 0x9657D2F5
	Offset: 0xC90
	Size: 0xBB
	Parameters: 1
	Flags: Private
*/
function private _GetPhalanxSpawner(tier)
{
	spawner = GetSpawnerArray(tier, "targetname");
	/#
		Assert(spawner.size >= 0, "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
	#/
	/#
		Assert(spawner.size == 1, "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
	#/
	return spawner[0];
}

/*
	Name: _HaltAdvance
	Namespace: RobotPhalanx
	Checksum: 0xE88AC232
	Offset: 0xD58
	Size: 0x149
	Parameters: 1
	Flags: Private
*/
function private _HaltAdvance(robots)
{
	/#
		Assert(IsArray(robots));
	#/
	foreach(robot in robots)
	{
		if(isdefined(robot) && isalive(robot) && robot HasPath())
		{
			navmeshPosition = GetClosestPointOnNavMesh(robot.origin, 200);
			robot UsePosition(navmeshPosition);
			robot clearPath();
		}
	}
}

/*
	Name: _HaltFire
	Namespace: RobotPhalanx
	Checksum: 0x48FFF1E8
	Offset: 0xEB0
	Size: 0xDD
	Parameters: 1
	Flags: Private
*/
function private _HaltFire(robots)
{
	/#
		Assert(IsArray(robots));
	#/
	foreach(robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			robot.ignoreall = 1;
		}
	}
}

/*
	Name: _InitializeRobot
	Namespace: RobotPhalanx
	Checksum: 0xC90CD839
	Offset: 0xF98
	Size: 0xEB
	Parameters: 1
	Flags: Private
*/
function private _InitializeRobot(robot)
{
	/#
		Assert(IsActor(robot));
	#/
	robot ai::set_behavior_attribute("phalanx", 1);
	robot ai::set_behavior_attribute("move_mode", "marching");
	robot ai::set_behavior_attribute("force_cover", 1);
	robot SetAvoidanceMask("avoid none");
	AiUtility::AddAIOverrideDamageCallback(robot, &_DampenExplosiveDamage, 1);
}

/*
	Name: _MovePhalanxTier
	Namespace: RobotPhalanx
	Checksum: 0x83D68CFC
	Offset: 0x1090
	Size: 0x211
	Parameters: 5
	Flags: Private
*/
function private _MovePhalanxTier(robots, phalanxType, tier, destination, FORWARD)
{
	positions = _GetPhalanxPositions(phalanxType, tier);
	angles = VectorToAngles(FORWARD);
	/#
		Assert(robots.size <= positions.size, "Dev Block strings are not supported");
	#/
	foreach(robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			/#
				Assert(IsVec(positions[index]), "Dev Block strings are not supported" + index + "Dev Block strings are not supported" + tier + "Dev Block strings are not supported" + phalanxType);
			#/
			orientedPos = _RotateVec(positions[index], angles[1] - 90);
			navmeshPosition = GetClosestPointOnNavMesh(destination + orientedPos, 200);
			robot UsePosition(navmeshPosition);
		}
	}
}

/*
	Name: _PruneDead
	Namespace: RobotPhalanx
	Checksum: 0x75C7FF0D
	Offset: 0x12B0
	Size: 0xBF
	Parameters: 1
	Flags: Private
*/
function private _PruneDead(robots)
{
	liveRobots = [];
	foreach(robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			liveRobots[index] = robot;
		}
	}
	return liveRobots;
}

/*
	Name: _ReleaseRobot
	Namespace: RobotPhalanx
	Checksum: 0x92772E2B
	Offset: 0x1378
	Size: 0x133
	Parameters: 1
	Flags: Private
*/
function private _ReleaseRobot(robot)
{
	if(isdefined(robot) && isalive(robot))
	{
		robot ClearUsePosition();
		robot PathMode("move delayed", 1, RandomFloatRange(0.5, 1));
		robot ai::set_behavior_attribute("phalanx", 0);
		wait(0.05);
		robot ai::set_behavior_attribute("move_mode", "normal");
		robot ai::set_behavior_attribute("force_cover", 0);
		robot SetAvoidanceMask("avoid all");
		AiUtility::RemoveAIOverrideDamageCallback(robot, &_DampenExplosiveDamage);
	}
}

/*
	Name: _ReleaseRobots
	Namespace: RobotPhalanx
	Checksum: 0x110463EC
	Offset: 0x14B8
	Size: 0xC9
	Parameters: 1
	Flags: Private
*/
function private _ReleaseRobots(robots)
{
	foreach(robot in robots)
	{
		_ResumeFire(robot);
		_ReleaseRobot(robot);
		wait(RandomFloatRange(0.5, 5));
	}
}

/*
	Name: _ResumeFire
	Namespace: RobotPhalanx
	Checksum: 0x36F8D4D8
	Offset: 0x1590
	Size: 0x3F
	Parameters: 1
	Flags: Private
*/
function private _ResumeFire(robot)
{
	if(isdefined(robot) && isalive(robot))
	{
		robot.ignoreall = 0;
	}
}

/*
	Name: _ResumeFireRobots
	Namespace: RobotPhalanx
	Checksum: 0xD481A9FD
	Offset: 0x15D8
	Size: 0xC1
	Parameters: 1
	Flags: Private
*/
function private _ResumeFireRobots(robots)
{
	/#
		Assert(IsArray(robots));
	#/
	foreach(robot in robots)
	{
		_ResumeFire(robot);
	}
}

/*
	Name: _RotateVec
	Namespace: RobotPhalanx
	Checksum: 0xBD4B7A70
	Offset: 0x16A8
	Size: 0x9F
	Parameters: 2
	Flags: Private
*/
function private _RotateVec(vector, angle)
{
	return (vector[0] * cos(angle) - vector[1] * sin(angle), vector[0] * sin(angle) + vector[1] * cos(angle), vector[2]);
}

/*
	Name: _UpdatePhalanxThread
	Namespace: RobotPhalanx
	Checksum: 0xF304CCE7
	Offset: 0x1750
	Size: 0x27
	Parameters: 1
	Flags: Private
*/
function private _UpdatePhalanxThread(phalanx)
{
	while(_UpdatePhalanx())
	{
		wait(1);
	}
}

/*
	Name: function_9b385ca5
	Namespace: RobotPhalanx
	Checksum: 0x739FBA53
	Offset: 0x1780
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.tier1Robots_ = [];
	self.tier2Robots_ = [];
	self.tier3Robots_ = [];
	self.startRobotCount_ = 0;
	self.currentRobotCount_ = 0;
	self.breakingPoint_ = 0;
	self.scattered_ = 0;
}

/*
	Name: function_5fba2032
	Namespace: RobotPhalanx
	Checksum: 0x99EC1590
	Offset: 0x17E0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: _UpdatePhalanx
	Namespace: RobotPhalanx
	Checksum: 0x2472769D
	Offset: 0x17F0
	Size: 0xD3
	Parameters: 0
	Flags: Private
*/
function private _UpdatePhalanx()
{
	if(self.scattered_)
	{
		return 0;
	}
	self.tier1Robots_ = _PruneDead(self.tier1Robots_);
	self.tier2Robots_ = _PruneDead(self.tier2Robots_);
	self.tier3Robots_ = _PruneDead(self.tier3Robots_);
	self.currentRobotCount_ = self.tier1Robots_.size + self.tier2Robots_.size + self.tier2Robots_.size;
	if(self.currentRobotCount_ <= self.startRobotCount_ - self.breakingPoint_)
	{
		ScatterPhalanx();
		return 0;
	}
	return 1;
}

/*
	Name: HaltFire
	Namespace: RobotPhalanx
	Checksum: 0x4550017C
	Offset: 0x18D0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function HaltFire()
{
	_HaltFire(self.tier1Robots_);
	_HaltFire(self.tier2Robots_);
	_HaltFire(self.tier3Robots_);
}

/*
	Name: HaltAdvance
	Namespace: RobotPhalanx
	Checksum: 0xA42156B8
	Offset: 0x1928
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function HaltAdvance()
{
	if(!self.scattered_)
	{
		_HaltAdvance(self.tier1Robots_);
		_HaltAdvance(self.tier2Robots_);
		_HaltAdvance(self.tier3Robots_);
	}
}

/*
	Name: Initialize
	Namespace: RobotPhalanx
	Checksum: 0x24B3DE30
	Offset: 0x1988
	Size: 0x35B
	Parameters: 8
	Flags: None
*/
function Initialize(phalanxType, origin, destination, breakingPoint, maxTierSize, tierOneSpawner, tierTwoSpawner, tierThreeSpawner)
{
	if(!isdefined(maxTierSize))
	{
		maxTierSize = 10;
	}
	if(!isdefined(tierOneSpawner))
	{
		tierOneSpawner = undefined;
	}
	if(!isdefined(tierTwoSpawner))
	{
		tierTwoSpawner = undefined;
	}
	if(!isdefined(tierThreeSpawner))
	{
		tierThreeSpawner = undefined;
	}
	/#
		Assert(IsString(phalanxType));
	#/
	/#
		Assert(IsInt(breakingPoint));
	#/
	/#
		Assert(IsVec(origin));
	#/
	/#
		Assert(IsVec(destination));
	#/
	maxTierSize = math::clamp(maxTierSize, 1, 10);
	FORWARD = VectorNormalize(destination - origin);
	self.tier1Robots_ = _CreatePhalanxTier(phalanxType, "phalanx_tier1", origin, FORWARD, maxTierSize, tierOneSpawner);
	self.tier2Robots_ = _CreatePhalanxTier(phalanxType, "phalanx_tier2", origin, FORWARD, maxTierSize, tierTwoSpawner);
	self.tier3Robots_ = _CreatePhalanxTier(phalanxType, "phalanx_tier3", origin, FORWARD, maxTierSize, tierThreeSpawner);
	_AssignPhalanxStance(self.tier1Robots_, "crouch");
	_MovePhalanxTier(self.tier1Robots_, phalanxType, "phalanx_tier1", destination, FORWARD);
	_MovePhalanxTier(self.tier2Robots_, phalanxType, "phalanx_tier2", destination, FORWARD);
	_MovePhalanxTier(self.tier3Robots_, phalanxType, "phalanx_tier3", destination, FORWARD);
	self.startRobotCount_ = self.tier1Robots_.size + self.tier2Robots_.size + self.tier3Robots_.size;
	self.breakingPoint_ = breakingPoint;
	self.startPosition_ = origin;
	self.endPosition_ = destination;
	self.phalanxType_ = phalanxType;
	self thread _UpdatePhalanxThread(self);
}

/*
	Name: ResumeAdvance
	Namespace: RobotPhalanx
	Checksum: 0xDE707302
	Offset: 0x1CF0
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function ResumeAdvance()
{
	if(!self.scattered_)
	{
		_AssignPhalanxStance(self.tier1Robots_, "stand");
		wait(1);
		FORWARD = VectorNormalize(self.endPosition_ - self.startPosition_);
		_MovePhalanxTier(self.tier1Robots_, self.phalanxType_, "phalanx_tier1", self.endPosition_, FORWARD);
		_MovePhalanxTier(self.tier2Robots_, self.phalanxType_, "phalanx_tier2", self.endPosition_, FORWARD);
		_MovePhalanxTier(self.tier3Robots_, self.phalanxType_, "phalanx_tier3", self.endPosition_, FORWARD);
		_AssignPhalanxStance(self.tier1Robots_, "crouch");
	}
}

/*
	Name: ResumeFire
	Namespace: RobotPhalanx
	Checksum: 0xAC88A1F4
	Offset: 0x1E20
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function ResumeFire()
{
	_ResumeFireRobots(self.tier1Robots_);
	_ResumeFireRobots(self.tier2Robots_);
	_ResumeFireRobots(self.tier3Robots_);
}

/*
	Name: ScatterPhalanx
	Namespace: RobotPhalanx
	Checksum: 0x2FF433D6
	Offset: 0x1E78
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function ScatterPhalanx()
{
	if(!self.scattered_)
	{
		self.scattered_ = 1;
		_ReleaseRobots(self.tier1Robots_);
		self.tier1Robots_ = [];
		_AssignPhalanxStance(self.tier2Robots_, "crouch");
		wait(RandomFloatRange(5, 7));
		_ReleaseRobots(self.tier2Robots_);
		self.tier2Robots_ = [];
		_AssignPhalanxStance(self.tier3Robots_, "crouch");
		wait(RandomFloatRange(5, 7));
		_ReleaseRobots(self.tier3Robots_);
		self.tier3Robots_ = [];
	}
}

/*
	Name: RobotPhalanx
	Namespace: RobotPhalanx
	Checksum: 0x4EC8CEA1
	Offset: 0x1F80
	Size: 0x4D5
	Parameters: 0
	Flags: 6
*/
function private autoexec RobotPhalanx()
{
	classes.RobotPhalanx[0] = spawnstruct();
	classes.RobotPhalanx[0].__vtable[228897961] = &ScatterPhalanx;
	classes.RobotPhalanx[0].__vtable[2087719912] = &ResumeFire;
	classes.RobotPhalanx[0].__vtable[1720367946] = &ResumeAdvance;
	classes.RobotPhalanx[0].__vtable[-422924033] = &Initialize;
	classes.RobotPhalanx[0].__vtable[1167879746] = &HaltAdvance;
	classes.RobotPhalanx[0].__vtable[-2118610224] = &HaltFire;
	classes.RobotPhalanx[0].__vtable[972280915] = &_UpdatePhalanx;
	classes.RobotPhalanx[0].__vtable[1606033458] = &function_5fba2032;
	classes.RobotPhalanx[0].__vtable[-1690805083] = &function_9b385ca5;
	classes.RobotPhalanx[0].__vtable[-381269537] = &_UpdatePhalanxThread;
	classes.RobotPhalanx[0].__vtable[-362582783] = &_RotateVec;
	classes.RobotPhalanx[0].__vtable[1581873510] = &_ResumeFireRobots;
	classes.RobotPhalanx[0].__vtable[-1629199683] = &_ResumeFire;
	classes.RobotPhalanx[0].__vtable[-513305948] = &_ReleaseRobots;
	classes.RobotPhalanx[0].__vtable[-1080422827] = &_ReleaseRobot;
	classes.RobotPhalanx[0].__vtable[1001347994] = &_PruneDead;
	classes.RobotPhalanx[0].__vtable[1972227195] = &_MovePhalanxTier;
	classes.RobotPhalanx[0].__vtable[-1954370578] = &_InitializeRobot;
	classes.RobotPhalanx[0].__vtable[-501039299] = &_HaltFire;
	classes.RobotPhalanx[0].__vtable[1576816289] = &_HaltAdvance;
	classes.RobotPhalanx[0].__vtable[1383035786] = &_GetPhalanxSpawner;
	classes.RobotPhalanx[0].__vtable[-34869766] = &_GetPhalanxPositions;
	classes.RobotPhalanx[0].__vtable[2037194283] = &_DampenExplosiveDamage;
	classes.RobotPhalanx[0].__vtable[-1045739606] = &_CreatePhalanxTier;
	classes.RobotPhalanx[0].__vtable[-1604255525] = &_AssignPhalanxStance;
}

