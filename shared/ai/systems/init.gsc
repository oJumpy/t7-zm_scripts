#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\gameskill_shared;
#using scripts\shared\name_shared;
#using scripts\shared\util_shared;

#namespace init;

/*
	Name: initWeapon
	Namespace: init
	Checksum: 0x49BEA41E
	Offset: 0x238
	Size: 0xE7
	Parameters: 1
	Flags: None
*/
function initWeapon(weapon)
{
	self.weaponinfo[weapon.name] = spawnstruct();
	self.weaponinfo[weapon.name].position = "none";
	self.weaponinfo[weapon.name].hasClip = 1;
	if(isdefined(weapon.ClipModel))
	{
		self.weaponinfo[weapon.name].useClip = 1;
	}
	else
	{
		self.weaponinfo[weapon.name].useClip = 0;
	}
}

/*
	Name: main
	Namespace: init
	Checksum: 0x5E702D00
	Offset: 0x328
	Size: 0x563
	Parameters: 0
	Flags: None
*/
function main()
{
	self.a = spawnstruct();
	self.a.weaponPos = [];
	if(self.weapon == level.weaponNone)
	{
		self AiUtility::setCurrentWeapon(level.weaponNone);
	}
	self AiUtility::setPrimaryWeapon(self.weapon);
	if(self.secondaryWeapon == level.weaponNone)
	{
		self AiUtility::setSecondaryWeapon(level.weaponNone);
	}
	self AiUtility::setSecondaryWeapon(self.secondaryWeapon);
	self AiUtility::setCurrentWeapon(self.primaryWeapon);
	self.initial_primaryweapon = self.primaryWeapon;
	self.initial_secondaryweapon = self.secondaryWeapon;
	self initWeapon(self.primaryWeapon);
	self initWeapon(self.secondaryWeapon);
	self initWeapon(self.sidearm);
	self.weapon_positions = Array("left", "right", "chest", "back");
	for(i = 0; i < self.weapon_positions.size; i++)
	{
		self.a.weaponPos[self.weapon_positions[i]] = level.weaponNone;
	}
	self.lastWeapon = self.weapon;
	self thread beginGrenadeTracking();
	self thread globalGrenadeTracking();
	firstInit();
	self.a.rockets = 3;
	self.a.rocketVisible = 1;
	self.a.pose = "stand";
	self.a.prevPose = self.a.pose;
	self.a.movement = "stop";
	self.a.special = "none";
	self.a.gunHand = "none";
	shared::placeWeaponOn(self.primaryWeapon, "right");
	if(isdefined(self.secondaryweaponclass) && self.secondaryweaponclass != "none" && self.secondaryweaponclass != "pistol")
	{
		shared::placeWeaponOn(self.secondaryWeapon, "back");
	}
	self.a.combatEndTime = GetTime();
	self.a.nextGrenadeTryTime = 0;
	self.a.isAiming = 0;
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
	self.walk = 0;
	self.sprint = 0;
	self.a.postScriptFunc = undefined;
	self.baseAccuracy = self.accuracy;
	if(!isdefined(self.script_accuracy))
	{
		self.script_accuracy = 1;
	}
	if(self.team == "axis" || self.team == "team3")
	{
		self thread gameskill::axisAccuracyControl();
	}
	else if(self.team == "allies")
	{
		self thread gameskill::alliesAccuracyControl();
	}
	self.a.missTime = 0;
	self.bulletsInClip = self.weapon.clipSize;
	self.lastEnemySightTime = 0;
	self.combatTime = 0;
	self.suppressed = 0;
	self.suppressedTime = 0;
	if(self.team == "allies")
	{
		self.suppressionThreshold = 0.75;
	}
	else
	{
		self.suppressionThreshold = 0.5;
	}
	if(self.team == "allies")
	{
		self.randomGrenadeRange = 0;
	}
	else
	{
		self.randomGrenadeRange = 128;
	}
	self.reacquire_state = 0;
}

/*
	Name: setNameAndRank
	Namespace: init
	Checksum: 0x834D6028
	Offset: 0x898
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function setNameAndRank()
{
	self endon("death");
	self name::get();
}

/*
	Name: DoNothing
	Namespace: init
	Checksum: 0x99EC1590
	Offset: 0x8C8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function DoNothing()
{
}

/*
	Name: set_anim_playback_rate
	Namespace: init
	Checksum: 0xF199C4B9
	Offset: 0x8D8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function set_anim_playback_rate()
{
	self.animplaybackrate = 0.9 + RandomFloat(0.2);
	self.moveplaybackrate = 1;
}

/*
	Name: trackVelocity
	Namespace: init
	Checksum: 0x3A96D7C2
	Offset: 0x918
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function trackVelocity()
{
	self endon("death");
	for(;;)
	{
		self.oldOrigin = self.origin;
		wait(0.2);
	}
}

/*
	Name: checkApproachAngles
	Namespace: init
	Checksum: 0xB2FF24E9
	Offset: 0x950
	Size: 0x40F
	Parameters: 1
	Flags: None
*/
function checkApproachAngles(transTypes)
{
	/#
		idealTransAngles[1] = 45;
		idealTransAngles[2] = 0;
		idealTransAngles[3] = -45;
		idealTransAngles[4] = 90;
		idealTransAngles[6] = -90;
		idealTransAngles[7] = 135;
		idealTransAngles[8] = 180;
		idealTransAngles[9] = -135;
		wait(0.05);
		for(i = 1; i <= 9; i++)
		{
			for(j = 0; j < transTypes.size; j++)
			{
				trans = transTypes[j];
				idealAdd = 0;
				if(trans == "Dev Block strings are not supported" || trans == "Dev Block strings are not supported")
				{
					idealAdd = 90;
				}
				else if(trans == "Dev Block strings are not supported" || trans == "Dev Block strings are not supported")
				{
					idealAdd = -90;
				}
				if(isdefined(anim.coverTransAngles[trans][i]))
				{
					correctAngle = AngleClamp180(idealTransAngles[i] + idealAdd);
					actualAngle = AngleClamp180(anim.coverTransAngles[trans][i]);
					if(AbsAngleClamp180(actualAngle - correctAngle) > 7)
					{
						println("Dev Block strings are not supported" + trans + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + actualAngle + "Dev Block strings are not supported" + correctAngle + "Dev Block strings are not supported");
					}
				}
			}
		}
		for(i = 1; i <= 9; i++)
		{
			for(j = 0; j < transTypes.size; j++)
			{
				trans = transTypes[j];
				idealAdd = 0;
				if(trans == "Dev Block strings are not supported" || trans == "Dev Block strings are not supported")
				{
					idealAdd = 90;
				}
				else if(trans == "Dev Block strings are not supported" || trans == "Dev Block strings are not supported")
				{
					idealAdd = -90;
				}
				if(isdefined(anim.coverExitAngles[trans][i]))
				{
					correctAngle = AngleClamp180(-1 * idealTransAngles[i] + idealAdd + 180);
					actualAngle = AngleClamp180(anim.coverExitAngles[trans][i]);
					if(AbsAngleClamp180(actualAngle - correctAngle) > 7)
					{
						println("Dev Block strings are not supported" + trans + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + actualAngle + "Dev Block strings are not supported" + correctAngle + "Dev Block strings are not supported");
					}
				}
			}
		}
	#/
}

/*
	Name: getExitSplitTime
	Namespace: init
	Checksum: 0x485C7C83
	Offset: 0xD68
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function getExitSplitTime(approachType, dir)
{
	return anim.coverExitSplit[approachType][dir];
}

/*
	Name: getTransSplitTime
	Namespace: init
	Checksum: 0x1D9807CF
	Offset: 0xDA0
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function getTransSplitTime(approachType, dir)
{
	return anim.coverTransSplit[approachType][dir];
}

/*
	Name: firstInit
	Namespace: init
	Checksum: 0xA42BA06F
	Offset: 0xDD8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function firstInit()
{
	if(isdefined(anim.NotFirstTime))
	{
		return;
	}
	anim.NotFirstTime = 1;
	anim.grenadeTimers["player_frag_grenade_sp"] = randomIntRange(1000, 20000);
	anim.grenadeTimers["player_flash_grenade_sp"] = randomIntRange(1000, 20000);
	anim.grenadeTimers["player_double_grenade"] = randomIntRange(10000, 60000);
	anim.grenadeTimers["AI_frag_grenade_sp"] = randomIntRange(0, 20000);
	anim.grenadeTimers["AI_flash_grenade_sp"] = randomIntRange(0, 20000);
	anim.numGrenadesInProgressTowardsPlayer = 0;
	anim.lastGrenadeLandedNearPlayerTime = -1000000;
	anim.lastFragGrenadeToPlayerStart = -1000000;
	thread setNextPlayerGrenadeTime();
	if(!isdefined(level.flag))
	{
		level.flag = [];
	}
	level.painAI = undefined;
	anim.coverCrouchLeanPitch = -55;
}

/*
	Name: onPlayerConnect
	Namespace: init
	Checksum: 0xEBE0AAA1
	Offset: 0xF50
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	player = self;
	firstInit();
	player.invul = 0;
}

/*
	Name: setNextPlayerGrenadeTime
	Namespace: init
	Checksum: 0xD36AB55D
	Offset: 0xF90
	Size: 0x155
	Parameters: 0
	Flags: None
*/
function setNextPlayerGrenadeTime()
{
	waittillframeend;
	if(isdefined(anim.playerGrenadeRangeTime))
	{
		maxTime = Int(anim.playerGrenadeRangeTime * 0.7);
		if(maxTime < 1)
		{
			maxTime = 1;
		}
		anim.grenadeTimers["player_frag_grenade_sp"] = randomIntRange(0, maxTime);
		anim.grenadeTimers["player_flash_grenade_sp"] = randomIntRange(0, maxTime);
	}
	if(isdefined(anim.playerDoubleGrenadeTime))
	{
		maxTime = Int(anim.playerDoubleGrenadeTime);
		minTime = Int(maxTime / 2);
		if(maxTime <= minTime)
		{
			maxTime = minTime + 1;
		}
		anim.grenadeTimers["player_double_grenade"] = randomIntRange(minTime, maxTime);
	}
}

/*
	Name: AddToMissiles
	Namespace: init
	Checksum: 0x320CAED
	Offset: 0x10F0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function AddToMissiles(grenade)
{
	if(!isdefined(level.MissileEntities))
	{
		level.MissileEntities = [];
	}
	if(!isdefined(level.MissileEntities))
	{
		level.MissileEntities = [];
	}
	else if(!IsArray(level.MissileEntities))
	{
		level.MissileEntities = Array(level.MissileEntities);
	}
	level.MissileEntities[level.MissileEntities.size] = grenade;
	while(isdefined(grenade))
	{
		wait(0.05);
	}
	ArrayRemoveValue(level.MissileEntities, grenade);
}

/*
	Name: globalGrenadeTracking
	Namespace: init
	Checksum: 0x6E31397B
	Offset: 0x11C0
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function globalGrenadeTracking()
{
	if(!isdefined(level.MissileEntities))
	{
		level.MissileEntities = [];
	}
	self endon("death");
	self thread globalGrenadeLauncherTracking();
	self thread globalMissileTracking();
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon);
		grenade.owner = self;
		grenade.weapon = weapon;
		level thread AddToMissiles(grenade);
	}
}

/*
	Name: globalGrenadeLauncherTracking
	Namespace: init
	Checksum: 0xCAD206B4
	Offset: 0x1280
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function globalGrenadeLauncherTracking()
{
	self endon("death");
	for(;;)
	{
		self waittill("grenade_launcher_fire", grenade, weapon);
		grenade.owner = self;
		grenade.weapon = weapon;
		level thread AddToMissiles(grenade);
	}
}

/*
	Name: globalMissileTracking
	Namespace: init
	Checksum: 0xE8657850
	Offset: 0x1300
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function globalMissileTracking()
{
	self endon("death");
	for(;;)
	{
		self waittill("missile_fire", grenade, weapon);
		grenade.owner = self;
		grenade.weapon = weapon;
		level thread AddToMissiles(grenade);
	}
}

/*
	Name: beginGrenadeTracking
	Namespace: init
	Checksum: 0x623988C7
	Offset: 0x1380
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function beginGrenadeTracking()
{
	self endon("death");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon);
		grenade thread grenade_earthQuake();
	}
}

/*
	Name: endOnDeath
	Namespace: init
	Checksum: 0x653FCA96
	Offset: 0x13D8
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function endOnDeath()
{
	self waittill("death");
	waittillframeend;
	self notify("end_explode");
}

/*
	Name: grenade_earthQuake
	Namespace: init
	Checksum: 0x56AF4433
	Offset: 0x1400
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function grenade_earthQuake()
{
	self thread endOnDeath();
	self endon("end_explode");
	self waittill("explode", position);
	PlayRumbleOnPosition("grenade_rumble", position);
	Earthquake(0.3, 0.5, position, 400);
}

/*
	Name: end_script
	Namespace: init
	Checksum: 0x99EC1590
	Offset: 0x1490
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function end_script()
{
}

