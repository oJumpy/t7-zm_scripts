#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\util_shared;

#namespace shared;

/*
	Name: main
	Namespace: shared
	Checksum: 0x32100736
	Offset: 0x250
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	function_9b385ca5();
	level.ai_weapon_throttle = Throttle;
	Initialize(level.ai_weapon_throttle, 1);
}

/*
	Name: _throwStowedWeapon
	Namespace: shared
	Checksum: 0x3EC5EBC2
	Offset: 0x298
	Size: 0x9B
	Parameters: 3
	Flags: Private
*/
function private _throwStowedWeapon(entity, weapon, weaponModel)
{
	entity waittill("death");
	if(isdefined(entity))
	{
		weaponModel Unlink();
		entity ThrowWeapon(weapon, getTagForPos("back"), 0);
	}
	weaponModel delete();
}

/*
	Name: StowWeapon
	Namespace: shared
	Checksum: 0x3D6A37F0
	Offset: 0x340
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function StowWeapon(weapon, positionOffset, orientationOffset)
{
	entity = self;
	if(!isdefined(positionOffset))
	{
		positionOffset = (0, 0, 0);
	}
	if(!isdefined(orientationOffset))
	{
		orientationOffset = (0, 0, 0);
	}
	weaponModel = spawn("script_model", (0, 0, 0));
	weaponModel SetModel(weapon.worldmodel);
	weaponModel LinkTo(entity, "tag_stowed_back", positionOffset, orientationOffset);
	entity thread _throwStowedWeapon(entity, weapon, weaponModel);
}

/*
	Name: placeWeaponOn
	Namespace: shared
	Checksum: 0xFFFEDC67
	Offset: 0x438
	Size: 0x3DB
	Parameters: 2
	Flags: None
*/
function placeWeaponOn(weapon, position)
{
	self notify("weapon_position_change");
	if(IsString(weapon))
	{
		weapon = GetWeapon(weapon);
	}
	if(!isdefined(self.weaponinfo[weapon.name]))
	{
		self init::initWeapon(weapon);
	}
	curPosition = self.weaponinfo[weapon.name].position;
	/#
		Assert(curPosition == "Dev Block strings are not supported" || self.a.weaponPos[curPosition] == weapon);
	#/
	if(!IsArray(self.a.weaponPos))
	{
		self.a.weaponPos = [];
	}
	/#
		Assert(IsArray(self.a.weaponPos));
	#/
	/#
		Assert(position == "Dev Block strings are not supported" || isdefined(self.a.weaponPos[position]), "Dev Block strings are not supported" + position + "Dev Block strings are not supported");
	#/
	/#
		Assert(IsWeapon(weapon));
	#/
	if(position != "none" && self.a.weaponPos[position] == weapon)
	{
		return;
	}
	self detachAllWeaponModels();
	if(curPosition != "none")
	{
		self detachWeapon(weapon);
	}
	if(position == "none")
	{
		self updateAttachedWeaponModels();
		self AiUtility::setCurrentWeapon(level.weaponNone);
		return;
	}
	if(self.a.weaponPos[position] != level.weaponNone)
	{
		self detachWeapon(self.a.weaponPos[position]);
	}
	if(position == "left" || position == "right")
	{
		self updateScriptWeaponInfoAndPos(weapon, position);
		self AiUtility::setCurrentWeapon(weapon);
	}
	else
	{
		self updateScriptWeaponInfoAndPos(weapon, position);
	}
	self updateAttachedWeaponModels();
	/#
		Assert(self.a.weaponPos["Dev Block strings are not supported"] == level.weaponNone || self.a.weaponPos["Dev Block strings are not supported"] == level.weaponNone);
	#/
}

/*
	Name: detachWeapon
	Namespace: shared
	Checksum: 0x76FF76F0
	Offset: 0x820
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function detachWeapon(weapon)
{
	self.a.weaponPos[self.weaponinfo[weapon.name].position] = level.weaponNone;
	self.weaponinfo[weapon.name].position = "none";
}

/*
	Name: updateScriptWeaponInfoAndPos
	Namespace: shared
	Checksum: 0xE6379C3C
	Offset: 0x898
	Size: 0x55
	Parameters: 2
	Flags: None
*/
function updateScriptWeaponInfoAndPos(weapon, position)
{
	self.weaponinfo[weapon.name].position = position;
	self.a.weaponPos[position] = weapon;
}

/*
	Name: detachAllWeaponModels
	Namespace: shared
	Checksum: 0x53BCE2C7
	Offset: 0x8F8
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function detachAllWeaponModels()
{
	if(isdefined(self.weapon_positions))
	{
		for(index = 0; index < self.weapon_positions.size; index++)
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			if(weapon == level.weaponNone)
			{
				continue;
			}
			self SetActorWeapon(level.weaponNone, self GetActorWeaponOptions());
		}
	}
}

/*
	Name: updateAttachedWeaponModels
	Namespace: shared
	Checksum: 0x9AE828FC
	Offset: 0x9B0
	Size: 0x12D
	Parameters: 0
	Flags: None
*/
function updateAttachedWeaponModels()
{
	if(isdefined(self.weapon_positions))
	{
		for(index = 0; index < self.weapon_positions.size; index++)
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			if(weapon == level.weaponNone)
			{
				continue;
			}
			if(self.weapon_positions[index] != "right")
			{
				continue;
			}
			self SetActorWeapon(weapon, self GetActorWeaponOptions());
			if(self.weaponinfo[weapon.name].useClip && !self.weaponinfo[weapon.name].hasClip)
			{
				self HidePart("tag_clip");
			}
		}
	}
}

/*
	Name: getTagForPos
	Namespace: shared
	Checksum: 0xD588D183
	Offset: 0xAE8
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function getTagForPos(position)
{
	switch(position)
	{
		case "chest":
		{
			return "tag_weapon_chest";
		}
		case "back":
		{
			return "tag_stowed_back";
		}
		case "left":
		{
			return "tag_weapon_left";
		}
		case "right":
		{
			return "tag_weapon_right";
		}
		case "hand":
		{
			return "tag_inhand";
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + position);
			#/
			break;
		}
	}
}

/*
	Name: ThrowWeapon
	Namespace: shared
	Checksum: 0x1FFBCE23
	Offset: 0xB90
	Size: 0x1E9
	Parameters: 3
	Flags: None
*/
function ThrowWeapon(weapon, positionTag, scavenger)
{
	waitTime = 0.1;
	linearScalar = 2;
	angularScalar = 10;
	startPosition = self GetTagOrigin(positionTag);
	startAngles = self GetTagAngles(positionTag);
	wait(waitTime);
	if(isdefined(self))
	{
		endPosition = self GetTagOrigin(positionTag);
		endAngles = self GetTagAngles(positionTag);
		linearVelocity = endPosition - startPosition * 1 / waitTime * linearScalar;
		angularVelocity = VectorNormalize(endAngles - startAngles) * angularScalar;
		ThrowWeapon = self dropweapon(weapon, positionTag, linearVelocity, angularVelocity, scavenger);
		if(isdefined(ThrowWeapon))
		{
			~ThrowWeapon;
			ThrowWeapon setContents(ThrowWeapon setContents(0) & 32768 | 67108864 | 8388608 | 33554432);
		}
		return ThrowWeapon;
	}
}

/*
	Name: DropAIWeapon
	Namespace: shared
	Checksum: 0x260B0B57
	Offset: 0xD88
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function DropAIWeapon()
{
	self endon("death");
	if(self.weapon == level.weaponNone)
	{
		return;
	}
	if(isdefined(self.script_nodropsecondaryweapon) && self.script_nodropsecondaryweapon && self.weapon == self.initial_secondaryweapon)
	{
		/#
			println("Dev Block strings are not supported" + self.weapon.name + "Dev Block strings are not supported");
		#/
		return;
	}
	else if(isdefined(self.script_nodropsidearm) && self.script_nodropsidearm && self.weapon == self.sidearm)
	{
		/#
			println("Dev Block strings are not supported" + self.weapon.name + "Dev Block strings are not supported");
		#/
		return;
	}
	WaitInQueue(level.ai_weapon_throttle);
	current_weapon = self.weapon;
	dropWeaponName = player_weapon_drop(current_weapon);
	position = self.weaponinfo[current_weapon.name].position;
	shouldDropWeapon = !isdefined(self.dontDropWeapon) || self.dontDropWeapon === 0;
	if(current_weapon.isScavengable == 0)
	{
		shouldDropWeapon = 0;
	}
	if(shouldDropWeapon && self.dropweapon)
	{
		self.dontDropWeapon = 1;
		positionTag = getTagForPos(position);
		ThrowWeapon(dropWeaponName, positionTag, 0);
	}
	if(self.weapon != level.weaponNone)
	{
		placeWeaponOn(current_weapon, "none");
		if(self.weapon == self.primaryWeapon)
		{
			self AiUtility::setPrimaryWeapon(level.weaponNone);
		}
		else if(self.weapon == self.secondaryWeapon)
		{
			self AiUtility::setSecondaryWeapon(level.weaponNone);
		}
	}
	self AiUtility::setCurrentWeapon(level.weaponNone);
}

/*
	Name: DropAllAIWeapons
	Namespace: shared
	Checksum: 0xC2C979BB
	Offset: 0x1068
	Size: 0x3F1
	Parameters: 0
	Flags: None
*/
function DropAllAIWeapons()
{
	if(isdefined(self.a.dropping_weapons) && self.a.dropping_weapons)
	{
		return;
	}
	if(!self.dropweapon)
	{
		if(self.weapon != level.weaponNone)
		{
			placeWeaponOn(self.weapon, "none");
			self AiUtility::setCurrentWeapon(level.weaponNone);
		}
		return;
	}
	self.a.dropping_weapons = 1;
	self detachAllWeaponModels();
	droppedSideArm = 0;
	if(isdefined(self.weapon_positions))
	{
		for(index = 0; index < self.weapon_positions.size; index++)
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			if(weapon != level.weaponNone)
			{
				self.weaponinfo[weapon.name].position = "none";
				self.a.weaponPos[self.weapon_positions[index]] = level.weaponNone;
				if(isdefined(self.script_nodropsecondaryweapon) && self.script_nodropsecondaryweapon && weapon == self.initial_secondaryweapon)
				{
					/#
						println("Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported");
					#/
					continue;
				}
				if(isdefined(self.script_nodropsidearm) && self.script_nodropsidearm && weapon == self.sidearm)
				{
					/#
						println("Dev Block strings are not supported" + weapon.name + "Dev Block strings are not supported");
					#/
					continue;
				}
				velocity = self GetVelocity();
				speed = length(velocity) * 0.5;
				weapon = player_weapon_drop(weapon);
				droppedWeapon = self dropweapon(weapon, self.weapon_positions[index], speed);
				if(self.sidearm != level.weaponNone)
				{
					if(weapon == self.sidearm)
					{
						droppedSideArm = 1;
					}
				}
			}
		}
	}
	else if(!droppedSideArm && self.sidearm != level.weaponNone)
	{
		if(RandomInt(100) <= 10)
		{
			velocity = self GetVelocity();
			speed = length(velocity) * 0.5;
			droppedWeapon = self dropweapon(self.sidearm, "chest", speed);
		}
	}
	self AiUtility::setCurrentWeapon(level.weaponNone);
	self.a.dropping_weapons = undefined;
}

/*
	Name: player_weapon_drop
	Namespace: shared
	Checksum: 0xBB911A10
	Offset: 0x1468
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function player_weapon_drop(weapon)
{
	if(IsSubStr(weapon.name, "rpg"))
	{
		return GetWeapon("rpg_player");
	}
	return weapon;
}

/*
	Name: HandleNoteTrack
	Namespace: shared
	Checksum: 0x1B5977B3
	Offset: 0x14C0
	Size: 0x23
	Parameters: 4
	Flags: None
*/
function HandleNoteTrack(note, flagName, customFunction, var1)
{
}

/*
	Name: DoNoteTracks
	Namespace: shared
	Checksum: 0x16E30061
	Offset: 0x14F0
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function DoNoteTracks(flagName, customFunction, debugIdentifier, var1)
{
	for(;;)
	{
		self waittill(flagName, note);
		if(!isdefined(note))
		{
			note = "undefined";
		}
		VAL = self HandleNoteTrack(note, flagName, customFunction, var1);
		if(isdefined(VAL))
		{
			return VAL;
		}
	}
}

/*
	Name: DoNoteTracksIntercept
	Namespace: shared
	Checksum: 0x3BBDAD8
	Offset: 0x1590
	Size: 0xD3
	Parameters: 3
	Flags: None
*/
function DoNoteTracksIntercept(flagName, interceptFunction, debugIdentifier)
{
	/#
		Assert(isdefined(interceptFunction));
	#/
	for(;;)
	{
		self waittill(flagName, note);
		if(!isdefined(note))
		{
			note = "undefined";
		}
		intercepted = [[interceptFunction]](note);
		if(isdefined(intercepted) && intercepted)
		{
			continue;
		}
		VAL = self HandleNoteTrack(note, flagName);
		if(isdefined(VAL))
		{
			return VAL;
		}
	}
}

/*
	Name: DoNoteTracksPostCallback
	Namespace: shared
	Checksum: 0x369EE95D
	Offset: 0x1670
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function DoNoteTracksPostCallback(flagName, postFunction)
{
	/#
		Assert(isdefined(postFunction));
	#/
	for(;;)
	{
		self waittill(flagName, note);
		if(!isdefined(note))
		{
			note = "undefined";
		}
		VAL = self HandleNoteTrack(note, flagName);
		[[postFunction]](note);
		if(isdefined(VAL))
		{
			return VAL;
		}
	}
}

/*
	Name: DoNoteTracksForever
	Namespace: shared
	Checksum: 0x6426AE61
	Offset: 0x1728
	Size: 0x53
	Parameters: 4
	Flags: None
*/
function DoNoteTracksForever(flagName, killString, customFunction, debugIdentifier)
{
	DoNoteTracksForeverProc(&DoNoteTracks, flagName, killString, customFunction, debugIdentifier);
}

/*
	Name: DoNoteTracksForeverIntercept
	Namespace: shared
	Checksum: 0x753AF5B4
	Offset: 0x1788
	Size: 0x53
	Parameters: 4
	Flags: None
*/
function DoNoteTracksForeverIntercept(flagName, killString, interceptFunction, debugIdentifier)
{
	DoNoteTracksForeverProc(&DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier);
}

/*
	Name: DoNoteTracksForeverProc
	Namespace: shared
	Checksum: 0x646E8812
	Offset: 0x17E8
	Size: 0x165
	Parameters: 5
	Flags: None
*/
function DoNoteTracksForeverProc(notetracksFunc, flagName, killString, customFunction, debugIdentifier)
{
	if(isdefined(killString))
	{
		self endon(killString);
	}
	self endon("killanimscript");
	if(!isdefined(debugIdentifier))
	{
		debugIdentifier = "undefined";
	}
	for(;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
		timetaken = GetTime() - time;
		if(timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
			timetaken = GetTime() - time;
			if(timetaken < 0.05)
			{
				/#
					println(GetTime() + "Dev Block strings are not supported" + debugIdentifier + "Dev Block strings are not supported" + flagName + "Dev Block strings are not supported" + returnedNote + "Dev Block strings are not supported");
				#/
				wait(0.05 - timetaken);
			}
		}
	}
}

/*
	Name: DoNoteTracksForTime
	Namespace: shared
	Checksum: 0x55E3B573
	Offset: 0x1958
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function DoNoteTracksForTime(time, flagName, customFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(&DoNoteTracksForever, time, flagName, customFunction, debugIdentifier, ent);
}

/*
	Name: DoNoteTracksForTimeIntercept
	Namespace: shared
	Checksum: 0x10EF8EFF
	Offset: 0x19F8
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function DoNoteTracksForTimeIntercept(time, flagName, interceptFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(&DoNoteTracksForeverIntercept, time, flagName, interceptFunction, debugIdentifier, ent);
}

/*
	Name: DoNoteTracksForTimeProc
	Namespace: shared
	Checksum: 0xD5A663E0
	Offset: 0x1A98
	Size: 0x59
	Parameters: 6
	Flags: None
*/
function DoNoteTracksForTimeProc(doNoteTracksForeverFunc, time, flagName, customFunction, debugIdentifier, ent)
{
	ent endon("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, debugIdentifier);
}

/*
	Name: doNoteTracksForTimeEndNotify
	Namespace: shared
	Checksum: 0xC7221F27
	Offset: 0x1B00
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function doNoteTracksForTimeEndNotify(time)
{
	wait(time);
	self notify("stop_notetracks");
}

