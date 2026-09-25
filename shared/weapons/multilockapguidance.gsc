#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace multilockap_guidance;

/*
	Name: __init__sytem__
	Namespace: multilockap_guidance
	Checksum: 0xCA70156D
	Offset: 0x230
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("multilockap_guidance", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: multilockap_guidance
	Checksum: 0x2A44ABA0
	Offset: 0x270
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
	SetDvar("scr_max_simLocks", 3);
}

/*
	Name: on_player_spawned
	Namespace: multilockap_guidance
	Checksum: 0xAA6F7EBE
	Offset: 0x2C0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	self ClearAPTarget();
	thread APToggleLoop();
	self thread APFiredNotify();
}

/*
	Name: ClearAPTarget
	Namespace: multilockap_guidance
	Checksum: 0xBAB8300C
	Offset: 0x318
	Size: 0x27B
	Parameters: 2
	Flags: None
*/
function ClearAPTarget(weapon, whom)
{
	if(!isdefined(self.multiLockList))
	{
		self.multiLockList = [];
	}
	if(isdefined(whom))
	{
		for(i = 0; i < self.multiLockList.size; i++)
		{
			if(whom.apTarget == self.multiLockList[i].apTarget)
			{
				if(isdefined(self.multiLockList[i].apTarget))
				{
					self.multiLockList[i].apTarget notify("missile_unlocked");
				}
				self notify("stop_sound" + whom.apSoundId);
				self WeaponLockRemoveSlot(i);
				ArrayRemoveValue(self.multiLockList, whom, 0);
				break;
			}
		}
	}
	else
	{
		for(i = 0; i < self.multiLockList.size; i++)
		{
			self.multiLockList[i].apTarget notify("missile_unlocked");
			self notify("stop_sound" + self.multiLockList[i].apSoundId);
		}
		self.multiLockList = [];
	}
	if(self.multiLockList.size == 0)
	{
		self StopRumble("stinger_lock_rumble");
		self WeaponLockRemoveSlot(-1);
		if(isdefined(weapon))
		{
			if(isdefined(weapon.lockonSeekerSearchSound))
			{
				self StopLocalSound(weapon.lockonSeekerSearchSound);
			}
			if(isdefined(weapon.lockonSeekerLockedSound))
			{
				self StopLocalSound(weapon.lockonSeekerLockedSound);
			}
		}
		self DestroyLockOnCanceledMessage();
	}
}

/*
	Name: APFiredNotify
	Namespace: multilockap_guidance
	Checksum: 0x5071D4FB
	Offset: 0x5A0
	Size: 0x11D
	Parameters: 0
	Flags: None
*/
function APFiredNotify()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self waittill("missile_fire", missile, weapon);
		if(weapon.lockonType == "AP Multi")
		{
			foreach(target in self.multiLockList)
			{
				if(isdefined(target.apTarget) && target.apLockFinalized)
				{
					target.apTarget notify("stinger_fired_at_me", missile, weapon, self);
				}
			}
		}
	}
}

/*
	Name: APToggleLoop
	Namespace: multilockap_guidance
	Checksum: 0xD5937D3
	Offset: 0x6C8
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function APToggleLoop()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		self waittill("weapon_change", weapon);
		while(weapon.lockonType == "AP Multi")
		{
			abort = 0;
			while(!self PlayerAds() == 1)
			{
				wait(0.05);
				currentWeapon = self GetCurrentWeapon();
				if(currentWeapon.lockonType != "AP Multi")
				{
					abort = 1;
					break;
				}
			}
			if(abort)
			{
				break;
			}
			self thread APLockLoop(weapon);
			while(self PlayerAds() == 1)
			{
				wait(0.05);
			}
			self notify("ap_off");
			self ClearAPTarget(weapon);
			weapon = self GetCurrentWeapon();
		}
	}
}

/*
	Name: APLockLoop
	Namespace: multilockap_guidance
	Checksum: 0x293136A1
	Offset: 0x848
	Size: 0x5B5
	Parameters: 1
	Flags: None
*/
function APLockLoop(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("ap_off");
	lockLength = self getLockOnSpeed();
	self.multiLockList = [];
	for(;;)
	{
		wait(0.05);
		do
		{
			done = 1;
			foreach(target in self.multiLockList)
			{
				if(target.apLockFinalized)
				{
					if(!IsStillValidTarget(weapon, target.apTarget))
					{
						self ClearAPTarget(weapon, target);
						done = 0;
						break;
					}
				}
			}
		}
		while(!!done);
		inLockingState = 0;
		do
		{
			done = 1;
			for(i = 0; i < self.multiLockList.size; i++)
			{
				target = self.multiLockList[i];
				if(target.apLocking)
				{
					if(!IsStillValidTarget(weapon, target.apTarget))
					{
						self ClearAPTarget(weapon, target);
						done = 0;
						break;
					}
					inLockingState = 1;
					timePassed = GetTime() - target.apLockStartTime;
					if(timePassed < lockLength)
					{
						continue;
					}
					/#
						Assert(isdefined(target.apTarget));
					#/
					target.apLockFinalized = 1;
					target.apLocking = 0;
					target.apLockPending = 0;
					self WeaponLockFinalize(target.apTarget, i);
					self thread SeekerSound(weapon.lockonSeekerLockedSound, weapon.lockonSeekerLockedSoundLoops, target.apSoundId);
					target.apTarget notify("missile_lock", self, weapon);
				}
			}
		}
		while(!!done);
		if(!inLockingState)
		{
			do
			{
				done = 1;
				for(i = 0; i < self.multiLockList.size; i++)
				{
					target = self.multiLockList[i];
					if(target.apLockPending)
					{
						if(!IsStillValidTarget(weapon, target.apTarget))
						{
							self ClearAPTarget(weapon, target);
							done = 0;
							break;
						}
						target.apLockStartTime = GetTime();
						target.apLockFinalized = 0;
						target.apLockPending = 0;
						target.apLocking = 1;
						self thread SeekerSound(weapon.lockonSeekerSearchSound, weapon.lockonSeekerSearchSoundLoops, target.apSoundId);
						done = 1;
						break;
					}
				}
			}
			while(!!done);
		}
		if(self.multiLockList.size >= GetDvarInt("scr_max_simLocks") || self.multiLockList.size >= self GetWeaponAmmoClip(weapon))
		{
			continue;
		}
		bestTarget = self GetBestTarget(weapon);
		if(!isdefined(bestTarget) && self.multiLockList.size == 0)
		{
			self DestroyLockOnCanceledMessage();
			continue;
		}
		if(isdefined(bestTarget) && self.multiLockList.size < GetDvarInt("scr_max_simLocks") && self.multiLockList.size < self GetWeaponAmmoClip(weapon))
		{
			self WeaponLockStart(bestTarget.apTarget, self.multiLockList.size);
			self.multiLockList[self.multiLockList.size] = bestTarget;
		}
	}
}

/*
	Name: DestroyLockOnCanceledMessage
	Namespace: multilockap_guidance
	Checksum: 0x73D61FBC
	Offset: 0xE08
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function DestroyLockOnCanceledMessage()
{
	if(isdefined(self.LockOnCanceledMessage))
	{
		self.LockOnCanceledMessage destroy();
	}
}

/*
	Name: DisplayLockOnCanceledMessage
	Namespace: multilockap_guidance
	Checksum: 0x61279067
	Offset: 0xE40
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function DisplayLockOnCanceledMessage()
{
	if(isdefined(self.LockOnCanceledMessage))
	{
		return;
	}
	self.LockOnCanceledMessage = newClientHudElem(self);
	self.LockOnCanceledMessage.fontscale = 1.25;
	self.LockOnCanceledMessage.x = 0;
	self.LockOnCanceledMessage.y = 50;
	self.LockOnCanceledMessage.alignX = "center";
	self.LockOnCanceledMessage.alignY = "top";
	self.LockOnCanceledMessage.horzAlign = "center";
	self.LockOnCanceledMessage.vertAlign = "top";
	self.LockOnCanceledMessage.foreground = 1;
	self.LockOnCanceledMessage.hidewhendead = 0;
	self.LockOnCanceledMessage.hidewheninmenu = 1;
	self.LockOnCanceledMessage.archived = 0;
	self.LockOnCanceledMessage.alpha = 1;
	self.LockOnCanceledMessage setText(&"MP_CANNOT_LOCKON_TO_TARGET");
}

/*
	Name: GetBestTarget
	Namespace: multilockap_guidance
	Checksum: 0xAF268941
	Offset: 0xFA0
	Size: 0x53D
	Parameters: 1
	Flags: None
*/
function GetBestTarget(weapon)
{
	playerTargets = GetPlayers();
	vehicleTargets = target_getArray();
	targetsAll = GetAITeamArray();
	targetsAll = ArrayCombine(targetsAll, playerTargets, 0, 0);
	targetsAll = ArrayCombine(targetsAll, vehicleTargets, 0, 0);
	targetsValid = [];
	for(idx = 0; idx < targetsAll.size; idx++)
	{
		if(level.teambased)
		{
			if(isdefined(targetsAll[idx].team) && targetsAll[idx].team != self.team)
			{
				if(self InsideAPReticleNoLock(targetsAll[idx]))
				{
					if(self LockSightTest(targetsAll[idx]))
					{
						targetsValid[targetsValid.size] = targetsAll[idx];
					}
				}
			}
			continue;
		}
		if(self InsideAPReticleNoLock(targetsAll[idx]))
		{
			if(isdefined(targetsAll[idx].owner) && self != targetsAll[idx].owner)
			{
				if(self LockSightTest(targetsAll[idx]))
				{
					targetsValid[targetsValid.size] = targetsAll[idx];
				}
			}
		}
	}
	if(targetsValid.size == 0)
	{
		return undefined;
	}
	playerForward = AnglesToForward(self getPlayerAngles());
	dots = [];
	for(i = 0; i < targetsValid.size; i++)
	{
		newItem = spawnstruct();
		newItem.index = i;
		newItem.dot = VectorDot(playerForward, VectorNormalize(targetsValid[i].origin - self.origin));
		Array::insertion_sort(dots, &TargetInsertionSortCompare, newItem);
	}
	index = 0;
	foreach(dot in dots)
	{
		found = 0;
		foreach(Lock in self.multiLockList)
		{
			if(Lock.apTarget == targetsValid[dot.index])
			{
				found = 1;
			}
		}
		if(found)
		{
			continue;
		}
		newEntry = spawnstruct();
		newEntry.apTarget = targetsValid[dot.index];
		newEntry.apLockStartTime = GetTime();
		newEntry.apLockPending = 1;
		newEntry.apLocking = 0;
		newEntry.apLockFinalized = 0;
		newEntry.apLostSightlineTime = 0;
		newEntry.apSoundId = RandomInt(2147483647);
		return newEntry;
	}
	return undefined;
}

/*
	Name: TargetInsertionSortCompare
	Namespace: multilockap_guidance
	Checksum: 0xE4A4B175
	Offset: 0x14E8
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function TargetInsertionSortCompare(a, b)
{
	if(a.dot < b.dot)
	{
		return -1;
	}
	if(a.dot > b.dot)
	{
		return 1;
	}
	return 0;
}

/*
	Name: InsideAPReticleNoLock
	Namespace: multilockap_guidance
	Checksum: 0x5B2AD39B
	Offset: 0x1550
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function InsideAPReticleNoLock(target)
{
	radius = self getLockOnRadius();
	return Target_IsInCircle(target, self, 65, radius);
}

/*
	Name: InsideAPReticleLocked
	Namespace: multilockap_guidance
	Checksum: 0xAEC77ABA
	Offset: 0x15B0
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function InsideAPReticleLocked(target)
{
	radius = self getLockOnLossRadius();
	return Target_IsInCircle(target, self, 65, radius);
}

/*
	Name: IsStillValidTarget
	Namespace: multilockap_guidance
	Checksum: 0xEC082C7B
	Offset: 0x1610
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function IsStillValidTarget(weapon, ent)
{
	if(!isdefined(ent))
	{
		return 0;
	}
	if(!InsideAPReticleLocked(ent))
	{
		return 0;
	}
	if(!isalive(ent))
	{
		return 0;
	}
	if(!LockSightTest(ent))
	{
		return 0;
	}
	return 1;
}

/*
	Name: SeekerSound
	Namespace: multilockap_guidance
	Checksum: 0x99F29F6B
	Offset: 0x16A0
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function SeekerSound(alias, looping, id)
{
	self notify("stop_sound" + id);
	self endon("stop_sound" + id);
	self endon("disconnect");
	self endon("death");
	if(isdefined(alias))
	{
		self PlayRumbleOnEntity("stinger_lock_rumble");
		time = soundgetplaybacktime(alias) * 0.001;
		do
		{
			self playlocalsound(alias);
			wait(time);
		}
		while(!looping);
		self StopRumble("stinger_lock_rumble");
	}
}

/*
	Name: LockSightTest
	Namespace: multilockap_guidance
	Checksum: 0x853466A8
	Offset: 0x1798
	Size: 0x17F
	Parameters: 1
	Flags: None
*/
function LockSightTest(target)
{
	eyePos = self GetEye();
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	pos = target GetShootAtPos();
	if(isdefined(pos))
	{
		passed = BulletTracePassed(eyePos, pos, 0, target, undefined, 1, 1);
		if(passed)
		{
			return 1;
		}
	}
	pos = target GetCentroid();
	if(isdefined(pos))
	{
		passed = BulletTracePassed(eyePos, pos, 0, target, undefined, 1, 1);
		if(passed)
		{
			return 1;
		}
	}
	pos = target.origin;
	passed = BulletTracePassed(eyePos, pos, 0, target, undefined, 1, 1);
	if(passed)
	{
		return 1;
	}
	return 0;
}

