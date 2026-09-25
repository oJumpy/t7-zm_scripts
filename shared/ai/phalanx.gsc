#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace phalanx;

/*
	Name: _AssignPhalanxStance
	Namespace: phalanx
	Checksum: 0xB2AEF026
	Offset: 0x280
	Size: 0xF1
	Parameters: 2
	Flags: Private
*/
function private _AssignPhalanxStance(sentients, stance)
{
	/#
		Assert(IsArray(sentients));
	#/
	foreach(sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			sentient ai::set_behavior_attribute("phalanx_force_stance", stance);
		}
	}
}

/*
	Name: _CreatePhalanxTier
	Namespace: phalanx
	Checksum: 0x4FF4C826
	Offset: 0x380
	Size: 0x247
	Parameters: 6
	Flags: Private
*/
function private _CreatePhalanxTier(phalanxType, tier, phalanxPosition, FORWARD, maxTierSize, spawner)
{
	if(!isdefined(spawner))
	{
		spawner = undefined;
	}
	sentients = [];
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
		sentient = spawner spawner::spawn(1, "", navmeshPosition, angles);
		_InitializeSentient(sentient);
		wait(0.05);
		sentients[sentients.size] = sentient;
	}
	return sentients;
}

/*
	Name: _DampenExplosiveDamage
	Namespace: phalanx
	Checksum: 0x2F4A405B
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
	Namespace: phalanx
	Checksum: 0x137C7964
	Offset: 0x7A0
	Size: 0x573
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
		case "phalanx_reverse_wedge":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return Array(VectorScale((-1, 0, 0), 32), VectorScale((1, 0, 0), 32));
				}
				case "phalanx_tier2":
				{
					return Array(VectorScale((0, -1, 0), 96));
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
	Namespace: phalanx
	Checksum: 0xF7443407
	Offset: 0xD20
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
	Namespace: phalanx
	Checksum: 0xA30A51AC
	Offset: 0xDE8
	Size: 0x149
	Parameters: 1
	Flags: Private
*/
function private _HaltAdvance(sentients)
{
	/#
		Assert(IsArray(sentients));
	#/
	foreach(sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient) && sentient HasPath())
		{
			navmeshPosition = GetClosestPointOnNavMesh(sentient.origin, 200);
			sentient UsePosition(navmeshPosition);
			sentient clearPath();
		}
	}
}

/*
	Name: _HaltFire
	Namespace: phalanx
	Checksum: 0xF92052A6
	Offset: 0xF40
	Size: 0xDD
	Parameters: 1
	Flags: Private
*/
function private _HaltFire(sentients)
{
	/#
		Assert(IsArray(sentients));
	#/
	foreach(sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			sentient.ignoreall = 1;
		}
	}
}

/*
	Name: _InitializeSentient
	Namespace: phalanx
	Checksum: 0x1CC79723
	Offset: 0x1028
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function _InitializeSentient(sentient)
{
	/#
		Assert(IsActor(sentient));
	#/
	sentient ai::set_behavior_attribute("phalanx", 1);
	if(sentient.archetype === "human")
	{
		sentient.allowPain = 0;
	}
	sentient SetAvoidanceMask("avoid none");
	if(isdefined(sentient.archetype) && sentient.archetype == "robot")
	{
		sentient ai::set_behavior_attribute("move_mode", "marching");
		sentient ai::set_behavior_attribute("force_cover", 1);
	}
	AiUtility::AddAIOverrideDamageCallback(sentient, &_DampenExplosiveDamage, 1);
}

/*
	Name: _MovePhalanxTier
	Namespace: phalanx
	Checksum: 0x9403F38E
	Offset: 0x1178
	Size: 0x211
	Parameters: 5
	Flags: Private
*/
function private _MovePhalanxTier(sentients, phalanxType, tier, destination, FORWARD)
{
	positions = _GetPhalanxPositions(phalanxType, tier);
	angles = VectorToAngles(FORWARD);
	/#
		Assert(sentients.size <= positions.size, "Dev Block strings are not supported");
	#/
	foreach(sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			/#
				Assert(IsVec(positions[index]), "Dev Block strings are not supported" + index + "Dev Block strings are not supported" + tier + "Dev Block strings are not supported" + phalanxType);
			#/
			orientedPos = _RotateVec(positions[index], angles[1] - 90);
			navmeshPosition = GetClosestPointOnNavMesh(destination + orientedPos, 200);
			sentient UsePosition(navmeshPosition);
		}
	}
}

/*
	Name: _PruneDead
	Namespace: phalanx
	Checksum: 0x3C13C3A6
	Offset: 0x1398
	Size: 0xBF
	Parameters: 1
	Flags: Private
*/
function private _PruneDead(sentients)
{
	liveSentients = [];
	foreach(sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			liveSentients[index] = sentient;
		}
	}
	return liveSentients;
}

/*
	Name: _ReleaseSentient
	Namespace: phalanx
	Checksum: 0x62EB1995
	Offset: 0x1460
	Size: 0x193
	Parameters: 1
	Flags: Private
*/
function private _ReleaseSentient(sentient)
{
	if(isdefined(sentient) && isalive(sentient))
	{
		sentient ClearUsePosition();
		sentient PathMode("move delayed", 1, RandomFloatRange(0.5, 1));
		sentient ai::set_behavior_attribute("phalanx", 0);
		wait(0.05);
		if(sentient.archetype === "human")
		{
			sentient.allowPain = 1;
		}
		sentient SetAvoidanceMask("avoid all");
		AiUtility::RemoveAIOverrideDamageCallback(sentient, &_DampenExplosiveDamage);
		if(isdefined(sentient.archetype) && sentient.archetype == "robot")
		{
			sentient ai::set_behavior_attribute("move_mode", "normal");
			sentient ai::set_behavior_attribute("force_cover", 0);
		}
	}
}

/*
	Name: _ReleaseSentients
	Namespace: phalanx
	Checksum: 0x4AA02EDF
	Offset: 0x1600
	Size: 0xC9
	Parameters: 1
	Flags: Private
*/
function private _ReleaseSentients(sentients)
{
	foreach(sentient in sentients)
	{
		_ResumeFire(sentient);
		_ReleaseSentient(sentient);
		wait(RandomFloatRange(0.5, 5));
	}
}

/*
	Name: _ResumeFire
	Namespace: phalanx
	Checksum: 0x63C49BD1
	Offset: 0x16D8
	Size: 0x3F
	Parameters: 1
	Flags: Private
*/
function private _ResumeFire(sentient)
{
	if(isdefined(sentient) && isalive(sentient))
	{
		sentient.ignoreall = 0;
	}
}

/*
	Name: _ResumeFireSentients
	Namespace: phalanx
	Checksum: 0xC5BF8D1F
	Offset: 0x1720
	Size: 0xC1
	Parameters: 1
	Flags: Private
*/
function private _ResumeFireSentients(sentients)
{
	/#
		Assert(IsArray(sentients));
	#/
	foreach(sentient in sentients)
	{
		_ResumeFire(sentient);
	}
}

/*
	Name: _RotateVec
	Namespace: phalanx
	Checksum: 0xFFDD27CC
	Offset: 0x17F0
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
	Namespace: phalanx
	Checksum: 0xC2391823
	Offset: 0x1898
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
	Namespace: phalanx
	Checksum: 0x6E402192
	Offset: 0x18C8
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.sentientTiers_ = [];
	self.startSentientCount_ = 0;
	self.currentSentientCount_ = 0;
	self.breakingPoint_ = 0;
	self.scattered_ = 0;
}

/*
	Name: function_5fba2032
	Namespace: phalanx
	Checksum: 0x99EC1590
	Offset: 0x1910
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: _UpdatePhalanx
	Namespace: phalanx
	Checksum: 0x951D7949
	Offset: 0x1920
	Size: 0x10B
	Parameters: 0
	Flags: Private
*/
function private _UpdatePhalanx()
{
	if(self.scattered_)
	{
		return 0;
	}
	self.currentSentientCount_ = 0;
	foreach(tier in self.sentientTiers_)
	{
		self.sentientTiers_[name] = _PruneDead(tier);
		self.currentSentientCount_ = self.currentSentientCount_ + self.sentientTiers_[name].size;
	}
	if(self.currentSentientCount_ <= self.startSentientCount_ - self.breakingPoint_)
	{
		ScatterPhalanx();
		return 0;
	}
	return 1;
}

/*
	Name: HaltFire
	Namespace: phalanx
	Checksum: 0x3EC579A5
	Offset: 0x1A38
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function HaltFire()
{
	foreach(tier in self.sentientTiers_)
	{
		_HaltFire(tier);
	}
}

/*
	Name: HaltAdvance
	Namespace: phalanx
	Checksum: 0xFF39D917
	Offset: 0x1AD0
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function HaltAdvance()
{
	if(!self.scattered_)
	{
		foreach(tier in self.sentientTiers_)
		{
			_HaltAdvance(tier);
		}
	}
}

/*
	Name: Initialize
	Namespace: phalanx
	Checksum: 0xCE283740
	Offset: 0x1B78
	Size: 0x3E3
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
	tierSpawners = [];
	tierSpawners["phalanx_tier1"] = tierOneSpawner;
	tierSpawners["phalanx_tier2"] = tierTwoSpawner;
	tierSpawners["phalanx_tier3"] = tierThreeSpawner;
	maxTierSize = math::clamp(maxTierSize, 1, 10);
	FORWARD = VectorNormalize(destination - origin);
	foreach(tierName in Array("phalanx_tier1", "phalanx_tier2", "phalanx_tier3"))
	{
		self.sentientTiers_[tierName] = _CreatePhalanxTier(phalanxType, tierName, origin, FORWARD, maxTierSize, tierSpawners[tierName]);
		self.startSentientCount_ = self.startSentientCount_ + self.sentientTiers_[tierName].size;
	}
	_AssignPhalanxStance(self.sentientTiers_["phalanx_tier1"], "crouch");
	foreach(tier in self.sentientTiers_)
	{
		_MovePhalanxTier(self.sentientTiers_[name], phalanxType, name, destination, FORWARD);
	}
	self.breakingPoint_ = breakingPoint;
	self.startPosition_ = origin;
	self.endPosition_ = destination;
	self.phalanxType_ = phalanxType;
	self thread _UpdatePhalanxThread(self);
}

/*
	Name: ResumeAdvance
	Namespace: phalanx
	Checksum: 0x49DF480A
	Offset: 0x1F68
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function ResumeAdvance()
{
	if(!self.scattered_)
	{
		_AssignPhalanxStance(self.sentientTiers_["phalanx_tier1"], "stand");
		wait(1);
		FORWARD = VectorNormalize(self.endPosition_ - self.startPosition_);
		_MovePhalanxTier(self.sentientTiers_["phalanx_tier1"], self.phalanxType_, "phalanx_tier1", self.endPosition_, FORWARD);
		_MovePhalanxTier(self.sentientTiers_["phalanx_tier2"], self.phalanxType_, "phalanx_tier2", self.endPosition_, FORWARD);
		_MovePhalanxTier(self.sentientTiers_["phalanx_tier3"], self.phalanxType_, "phalanx_tier3", self.endPosition_, FORWARD);
		_AssignPhalanxStance(self.sentientTiers_["phalanx_tier1"], "crouch");
	}
}

/*
	Name: ResumeFire
	Namespace: phalanx
	Checksum: 0x2DE4AE11
	Offset: 0x20D8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function ResumeFire()
{
	_ResumeFireSentients(self.sentientTiers_["phalanx_tier1"]);
	_ResumeFireSentients(self.sentientTiers_["phalanx_tier2"]);
	_ResumeFireSentients(self.sentientTiers_["phalanx_tier3"]);
}

/*
	Name: ScatterPhalanx
	Namespace: phalanx
	Checksum: 0xDEE1A0F
	Offset: 0x2160
	Size: 0x159
	Parameters: 0
	Flags: None
*/
function ScatterPhalanx()
{
	if(!self.scattered_)
	{
		self.scattered_ = 1;
		_ReleaseSentients(self.sentientTiers_["phalanx_tier1"]);
		self.sentientTiers_["phalanx_tier1"] = [];
		_AssignPhalanxStance(self.sentientTiers_["phalanx_tier2"], "crouch");
		wait(RandomFloatRange(5, 7));
		_ReleaseSentients(self.sentientTiers_["phalanx_tier2"]);
		self.sentientTiers_["phalanx_tier2"] = [];
		_AssignPhalanxStance(self.sentientTiers_["phalanx_tier3"], "crouch");
		wait(RandomFloatRange(5, 7));
		_ReleaseSentients(self.sentientTiers_["phalanx_tier3"]);
		self.sentientTiers_["phalanx_tier3"] = [];
	}
}

/*
	Name: phalanx
	Namespace: phalanx
	Checksum: 0xA20418EF
	Offset: 0x22C8
	Size: 0x4D5
	Parameters: 0
	Flags: 6
*/
function private autoexec phalanx()
{
	classes.phalanx[0] = spawnstruct();
	classes.phalanx[0].__vtable[228897961] = &ScatterPhalanx;
	classes.phalanx[0].__vtable[2087719912] = &ResumeFire;
	classes.phalanx[0].__vtable[1720367946] = &ResumeAdvance;
	classes.phalanx[0].__vtable[-422924033] = &Initialize;
	classes.phalanx[0].__vtable[1167879746] = &HaltAdvance;
	classes.phalanx[0].__vtable[-2118610224] = &HaltFire;
	classes.phalanx[0].__vtable[972280915] = &_UpdatePhalanx;
	classes.phalanx[0].__vtable[1606033458] = &function_5fba2032;
	classes.phalanx[0].__vtable[-1690805083] = &function_9b385ca5;
	classes.phalanx[0].__vtable[-381269537] = &_UpdatePhalanxThread;
	classes.phalanx[0].__vtable[-362582783] = &_RotateVec;
	classes.phalanx[0].__vtable[2035712678] = &_ResumeFireSentients;
	classes.phalanx[0].__vtable[-1629199683] = &_ResumeFire;
	classes.phalanx[0].__vtable[-894352604] = &_ReleaseSentients;
	classes.phalanx[0].__vtable[-1608913963] = &_ReleaseSentient;
	classes.phalanx[0].__vtable[1001347994] = &_PruneDead;
	classes.phalanx[0].__vtable[1972227195] = &_MovePhalanxTier;
	classes.phalanx[0].__vtable[-920952828] = &_InitializeSentient;
	classes.phalanx[0].__vtable[-501039299] = &_HaltFire;
	classes.phalanx[0].__vtable[1576816289] = &_HaltAdvance;
	classes.phalanx[0].__vtable[1383035786] = &_GetPhalanxSpawner;
	classes.phalanx[0].__vtable[-34869766] = &_GetPhalanxPositions;
	classes.phalanx[0].__vtable[2037194283] = &_DampenExplosiveDamage;
	classes.phalanx[0].__vtable[-1045739606] = &_CreatePhalanxTier;
	classes.phalanx[0].__vtable[-1604255525] = &_AssignPhalanxStance;
}

