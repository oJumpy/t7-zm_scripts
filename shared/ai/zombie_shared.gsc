#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;

#namespace zombie_shared;

/*
	Name: deleteAtLimit
	Namespace: zombie_shared
	Checksum: 0xF1BB0EFD
	Offset: 0x520
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function deleteAtLimit()
{
	wait(30);
	self delete();
}

/*
	Name: LookAtEntity
	Namespace: zombie_shared
	Checksum: 0x8249CEAA
	Offset: 0x550
	Size: 0x2D
	Parameters: 5
	Flags: None
*/
function LookAtEntity(lookTargetEntity, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	return;
}

/*
	Name: LookAtPosition
	Namespace: zombie_shared
	Checksum: 0x78B2033D
	Offset: 0x588
	Size: 0x1B1
	Parameters: 5
	Flags: None
*/
function LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	/#
		Assert(isai(self), "Dev Block strings are not supported");
	#/
	/#
		Assert(self.a.targetLookInitilized == 1, "Dev Block strings are not supported");
	#/
	/#
		Assert(lookSpeed == "Dev Block strings are not supported" || lookSpeed == "Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
	if(!isdefined(interruptOthers) || interruptOthers == "interrupt others" || GetTime() > self.a.lookEndTime)
	{
		self.a.lookTargetPos = lookTargetPos;
		self.a.lookEndTime = GetTime() + lookDuration * 1000;
		if(lookSpeed == "casual")
		{
			self.a.lookTargetSpeed = 800;
		}
		else
		{
			self.a.lookTargetSpeed = 1600;
		}
		if(isdefined(eyesOnly) && eyesOnly == "eyes only")
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
}

/*
	Name: LookAtAnimations
	Namespace: zombie_shared
	Checksum: 0xE5DFDF2C
	Offset: 0x748
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function LookAtAnimations(leftanim, rightanim)
{
	self.a.LookAnimationLeft = leftanim;
	self.a.LookAnimationRight = rightanim;
}

/*
	Name: HandleDogSoundNoteTracks
	Namespace: zombie_shared
	Checksum: 0xCEF2EB
	Offset: 0x790
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function HandleDogSoundNoteTracks(note)
{
	if(note == "sound_dogstep_run_default" || note == "dogstep_rf" || note == "dogstep_lf")
	{
		self playsound("fly_dog_step_run_default");
		return 1;
	}
	prefix = GetSubStr(note, 0, 5);
	if(prefix != "sound")
	{
		return 0;
	}
	alias = "aml" + GetSubStr(note, 5);
	if(isalive(self))
	{
		self thread sound::play_on_tag(alias, "tag_eye");
	}
	else
	{
		self thread sound::play_in_space(alias, self GetTagOrigin("tag_eye"));
	}
	return 1;
}

/*
	Name: growling
	Namespace: zombie_shared
	Checksum: 0xEFFF4CEB
	Offset: 0x8D0
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function growling()
{
	return isdefined(self.script_growl);
}

/*
	Name: registerNoteTracks
	Namespace: zombie_shared
	Checksum: 0xF1673CD7
	Offset: 0x8E8
	Size: 0x2A5
	Parameters: 0
	Flags: None
*/
function registerNoteTracks()
{
	anim.notetracks["anim_pose = "stand""] = &noteTrackPoseStand;
	anim.notetracks["anim_pose = "crouch""] = &noteTrackPoseCrouch;
	anim.notetracks["anim_movement = "stop""] = &noteTrackMovementStop;
	anim.notetracks["anim_movement = "walk""] = &noteTrackMovementWalk;
	anim.notetracks["anim_movement = "run""] = &noteTrackMovementRun;
	anim.notetracks["anim_alertness = causal"] = &noteTrackAlertnessCasual;
	anim.notetracks["anim_alertness = alert"] = &noteTrackAlertnessAlert;
	anim.notetracks["gravity on"] = &noteTrackGravity;
	anim.notetracks["gravity off"] = &noteTrackGravity;
	anim.notetracks["gravity code"] = &noteTrackGravity;
	anim.notetracks["bodyfall large"] = &noteTrackBodyFall;
	anim.notetracks["bodyfall small"] = &noteTrackBodyFall;
	anim.notetracks["footstep"] = &noteTrackFootStep;
	anim.notetracks["step"] = &noteTrackFootStep;
	anim.notetracks["footstep_right_large"] = &noteTrackFootStep;
	anim.notetracks["footstep_right_small"] = &noteTrackFootStep;
	anim.notetracks["footstep_left_large"] = &noteTrackFootStep;
	anim.notetracks["footstep_left_small"] = &noteTrackFootStep;
	anim.notetracks["footscrape"] = &noteTrackFootScrape;
	anim.notetracks["land"] = &noteTrackLand;
	anim.notetracks["start_ragdoll"] = &notetrackStartRagdoll;
}

/*
	Name: noteTrackStopAnim
	Namespace: zombie_shared
	Checksum: 0xF0B6C5D6
	Offset: 0xB98
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function noteTrackStopAnim(note, flagName)
{
}

/*
	Name: notetrackStartRagdoll
	Namespace: zombie_shared
	Checksum: 0x2B1B9CF
	Offset: 0xBB8
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function notetrackStartRagdoll(note, flagName)
{
	if(isdefined(self.noragdoll))
	{
		return;
	}
	self Unlink();
	self StartRagdoll();
}

/*
	Name: noteTrackMovementStop
	Namespace: zombie_shared
	Checksum: 0xE3687222
	Offset: 0xC10
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function noteTrackMovementStop(note, flagName)
{
	if(IsSentient(self))
	{
		self.a.movement = "stop";
	}
}

/*
	Name: noteTrackMovementWalk
	Namespace: zombie_shared
	Checksum: 0x12B7E8C6
	Offset: 0xC60
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function noteTrackMovementWalk(note, flagName)
{
	if(IsSentient(self))
	{
		self.a.movement = "walk";
	}
}

/*
	Name: noteTrackMovementRun
	Namespace: zombie_shared
	Checksum: 0x42380774
	Offset: 0xCB0
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function noteTrackMovementRun(note, flagName)
{
	if(IsSentient(self))
	{
		self.a.movement = "run";
	}
}

/*
	Name: noteTrackAlertnessCasual
	Namespace: zombie_shared
	Checksum: 0x56546D63
	Offset: 0xD00
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function noteTrackAlertnessCasual(note, flagName)
{
	if(IsSentient(self))
	{
		self.a.alertness = "casual";
	}
}

/*
	Name: noteTrackAlertnessAlert
	Namespace: zombie_shared
	Checksum: 0x7D3C8C5F
	Offset: 0xD50
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function noteTrackAlertnessAlert(note, flagName)
{
	if(IsSentient(self))
	{
		self.a.alertness = "alert";
	}
}

/*
	Name: noteTrackPoseStand
	Namespace: zombie_shared
	Checksum: 0x64417B5C
	Offset: 0xDA0
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function noteTrackPoseStand(note, flagName)
{
	self.a.pose = "stand";
	self notify("entered_pose" + "stand");
}

/*
	Name: noteTrackPoseCrouch
	Namespace: zombie_shared
	Checksum: 0xB5B531DC
	Offset: 0xDF0
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function noteTrackPoseCrouch(note, flagName)
{
	self.a.pose = "crouch";
	self notify("entered_pose" + "crouch");
	if(self.a.crouchPain)
	{
		self.a.crouchPain = 0;
		self.health = 150;
	}
}

/*
	Name: noteTrackGravity
	Namespace: zombie_shared
	Checksum: 0xD08E891
	Offset: 0xE70
	Size: 0xED
	Parameters: 2
	Flags: None
*/
function noteTrackGravity(note, flagName)
{
	if(IsSubStr(note, "on"))
	{
		self animMode("gravity");
	}
	else if(IsSubStr(note, "off"))
	{
		self animMode("nogravity");
		self.nogravity = 1;
	}
	else if(IsSubStr(note, "code"))
	{
		self animMode("none");
		self.nogravity = undefined;
	}
}

/*
	Name: noteTrackBodyFall
	Namespace: zombie_shared
	Checksum: 0x7996BDC3
	Offset: 0xF68
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function noteTrackBodyFall(note, flagName)
{
	if(isdefined(self.groundType))
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
	if(IsSubStr(note, "large"))
	{
		self playsound("fly_bodyfall_large_" + groundType);
	}
	else if(IsSubStr(note, "small"))
	{
		self playsound("fly_bodyfall_small_" + groundType);
	}
}

/*
	Name: noteTrackFootStep
	Namespace: zombie_shared
	Checksum: 0x80C74B0E
	Offset: 0x1038
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function noteTrackFootStep(note, flagName)
{
	if(IsSubStr(note, "left"))
	{
		playFootStep("J_Ball_LE");
	}
	else
	{
		playFootStep("J_BALL_RI");
	}
	if(!level.clientscripts)
	{
		self playsound("fly_gear_run");
	}
}

/*
	Name: noteTrackFootScrape
	Namespace: zombie_shared
	Checksum: 0xE08BF739
	Offset: 0x10D8
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function noteTrackFootScrape(note, flagName)
{
	if(isdefined(self.groundType))
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
	self playsound("fly_step_scrape_" + groundType);
}

/*
	Name: noteTrackLand
	Namespace: zombie_shared
	Checksum: 0x803319C9
	Offset: 0x1148
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function noteTrackLand(note, flagName)
{
	if(isdefined(self.groundType))
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
	self playsound("fly_land_npc_" + groundType);
}

/*
	Name: HandleNoteTrack
	Namespace: zombie_shared
	Checksum: 0xBC00C609
	Offset: 0x11B8
	Size: 0x309
	Parameters: 4
	Flags: None
*/
function HandleNoteTrack(note, flagName, customFunction, var1)
{
	if(isai(self) && isdefined(anim.notetracks))
	{
		notetrackFunc = anim.notetracks[note];
		if(isdefined(notetrackFunc))
		{
			return [[notetrackFunc]](note, flagName);
		}
	}
	switch(note)
	{
		case "end":
		case "finish":
		case "undefined":
		{
			return note;
		}
		case "swish small":
		{
			self thread sound::play_in_space("fly_gear_enemy", self GetTagOrigin("TAG_WEAPON_RIGHT"));
			break;
		}
		case "swish large":
		{
			self thread sound::play_in_space("fly_gear_enemy_large", self GetTagOrigin("TAG_WEAPON_RIGHT"));
			break;
		}
		case "no death":
		{
			self.a.nodeath = 1;
			break;
		}
		case "no pain":
		{
			self.allowPain = 0;
			break;
		}
		case "allow pain":
		{
			self.allowPain = 1;
			break;
		}
		case "anim_melee = "right"":
		case "anim_melee = right":
		{
			self.a.meleeState = "right";
			break;
		}
		case "anim_melee = "left"":
		case "anim_melee = left":
		{
			self.a.meleeState = "left";
			break;
		}
		case "swap taghelmet to tagleft":
		{
			if(isdefined(self.hatModel))
			{
				if(isdefined(self.helmetSideModel))
				{
					self Detach(self.helmetSideModel, "TAG_HELMETSIDE");
					self.helmetSideModel = undefined;
				}
				self Detach(self.hatModel, "");
				self Attach(self.hatModel, "TAG_WEAPON_LEFT");
				self.hatModel = undefined;
			}
			break;
		}
		case default:
		{
			if(isdefined(customFunction))
			{
				if(!isdefined(var1))
				{
					return [[customFunction]](note);
				}
				else
				{
					return [[customFunction]](note, var1);
				}
			}
			break;
		}
	}
}

/*
	Name: DoNoteTracks
	Namespace: zombie_shared
	Checksum: 0x293CF051
	Offset: 0x14D0
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function DoNoteTracks(flagName, customFunction, var1)
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
	Name: DoNoteTracksForeverProc
	Namespace: zombie_shared
	Checksum: 0x9CDDDEA5
	Offset: 0x1568
	Size: 0x13D
	Parameters: 5
	Flags: None
*/
function DoNoteTracksForeverProc(notetracksFunc, flagName, killString, customFunction, var1)
{
	if(isdefined(killString))
	{
		self endon(killString);
	}
	self endon("killanimscript");
	for(;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, var1);
		timetaken = GetTime() - time;
		if(timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, var1);
			timetaken = GetTime() - time;
			if(timetaken < 0.05)
			{
				/#
					println(GetTime() + "Dev Block strings are not supported" + flagName + "Dev Block strings are not supported" + returnedNote + "Dev Block strings are not supported");
				#/
				wait(0.05 - timetaken);
			}
		}
	}
}

/*
	Name: DoNoteTracksForever
	Namespace: zombie_shared
	Checksum: 0xB6BF397D
	Offset: 0x16B0
	Size: 0x53
	Parameters: 4
	Flags: None
*/
function DoNoteTracksForever(flagName, killString, customFunction, var1)
{
	DoNoteTracksForeverProc(&DoNoteTracks, flagName, killString, customFunction, var1);
}

/*
	Name: DoNoteTracksForTimeProc
	Namespace: zombie_shared
	Checksum: 0xE9663CF2
	Offset: 0x1710
	Size: 0x59
	Parameters: 6
	Flags: None
*/
function DoNoteTracksForTimeProc(doNoteTracksForeverFunc, time, flagName, customFunction, ent, var1)
{
	ent endon("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, var1);
}

/*
	Name: DoNoteTracksForTime
	Namespace: zombie_shared
	Checksum: 0xF012D78C
	Offset: 0x1778
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function DoNoteTracksForTime(time, flagName, customFunction, var1)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(&DoNoteTracksForever, time, flagName, customFunction, ent, var1);
}

/*
	Name: doNoteTracksForTimeEndNotify
	Namespace: zombie_shared
	Checksum: 0x132B5AAB
	Offset: 0x1818
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function doNoteTracksForTimeEndNotify(time)
{
	wait(time);
	self notify("stop_notetracks");
}

/*
	Name: playFootStep
	Namespace: zombie_shared
	Checksum: 0xAC931724
	Offset: 0x1840
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function playFootStep(FOOT)
{
	if(!level.clientscripts)
	{
		if(!isai(self))
		{
			self playsound("fly_step_run_dirt");
			return;
		}
	}
	groundType = undefined;
	if(!isdefined(self.groundType))
	{
		if(!isdefined(self.lastGroundtype))
		{
			if(!level.clientscripts)
			{
				self playsound("fly_step_run_dirt");
			}
			return;
		}
		groundType = self.lastGroundtype;
	}
	else
	{
		groundType = self.groundType;
		self.lastGroundtype = self.groundType;
	}
	if(!level.clientscripts)
	{
		self playsound("fly_step_run_" + groundType);
	}
	[[anim.optionalStepEffectFunction]](FOOT, groundType);
}

/*
	Name: playFootStepEffect
	Namespace: zombie_shared
	Checksum: 0x5ACB6A2C
	Offset: 0x1958
	Size: 0x107
	Parameters: 2
	Flags: None
*/
function playFootStepEffect(FOOT, groundType)
{
	if(level.clientscripts)
	{
		return;
	}
	for(i = 0; i < anim.optionalStepEffects.size; i++)
	{
		if(isdefined(self.fire_footsteps) && self.fire_footsteps)
		{
			groundType = "fire";
		}
		if(groundType != anim.optionalStepEffects[i])
		{
			continue;
		}
		org = self GetTagOrigin(FOOT);
		playFX(level._effect["step_" + anim.optionalStepEffects[i]], org, org + VectorScale((0, 0, 1), 100));
		return;
	}
}

/*
	Name: moveToOriginOverTime
	Namespace: zombie_shared
	Checksum: 0x31182A9B
	Offset: 0x1A68
	Size: 0x167
	Parameters: 2
	Flags: None
*/
function moveToOriginOverTime(origin, time)
{
	self endon("killanimscript");
	if(DistanceSquared(self.origin, origin) > 256 && !self MayMoveToPoint(origin))
	{
		/#
			println("Dev Block strings are not supported" + origin + "Dev Block strings are not supported");
		#/
		return;
	}
	self.keepClaimedNodeInGoal = 1;
	offset = self.origin - origin;
	frames = Int(time * 20);
	offsetreduction = VectorScale(offset, 1 / frames);
	for(i = 0; i < frames; i++)
	{
		offset = offset - offsetreduction;
		self teleport(origin + offset);
		wait(0.05);
	}
	self.keepClaimedNodeInGoal = 0;
}

/*
	Name: returnTrue
	Namespace: zombie_shared
	Checksum: 0x7F22AEB8
	Offset: 0x1BD8
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function returnTrue()
{
	return 1;
}

/*
	Name: trackLoop
	Namespace: zombie_shared
	Checksum: 0x343BDCCC
	Offset: 0x1BE8
	Size: 0x713
	Parameters: 0
	Flags: None
*/
function trackLoop()
{
	players = GetPlayers();
	deltaChangePerFrame = 5;
	aimBlendTime = 0.05;
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5;
	maxPitchDeltaChange = 5;
	pitchAdd = 0;
	yawAdd = 0;
	if(self.type == "dog" || self.type == "zombie" || self.type == "zombie_dog")
	{
		doMaxAngleCheck = 0;
		self.shootEnt = self.enemy;
	}
	else
	{
		doMaxAngleCheck = 1;
		if(self.a.script == "cover_crouch" && isdefined(self.a.coverMode) && self.a.coverMode == "lean")
		{
			pitchAdd = -1 * anim.coverCrouchLeanPitch;
		}
		if(self.a.script == "cover_left" || self.a.script == "cover_right" && isdefined(self.a.cornerMode) && self.a.cornerMode == "lean")
		{
			yawAdd = self.coverNode.angles[1] - self.angles[1];
		}
	}
	yawDelta = 0;
	pitchDelta = 0;
	firstframe = 1;
	for(;;)
	{
		incrAnimAimWeight();
		selfShootAtPos = (self.origin[0], self.origin[1], self GetEye()[2]);
		shootpos = undefined;
		if(isdefined(self.enemy))
		{
			shootpos = self.enemy GetShootAtPos();
		}
		if(!isdefined(shootpos))
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			vectorToShootPos = shootpos - selfShootAtPos;
			anglesToShootPos = VectorToAngles(vectorToShootPos);
			pitchDelta = 360 - anglesToShootPos[0];
			pitchDelta = AngleClamp180(pitchDelta + pitchAdd);
			yawDelta = self.angles[1] - anglesToShootPos[1];
			yawDelta = AngleClamp180(yawDelta + yawAdd);
		}
		if(doMaxAngleCheck && (Abs(yawDelta) > 60 || Abs(pitchDelta) > 60))
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else if(yawDelta > self.rightAimLimit)
		{
			yawDelta = self.rightAimLimit;
		}
		else if(yawDelta < self.leftAimLimit)
		{
			yawDelta = self.leftAimLimit;
		}
		if(pitchDelta > self.upAimLimit)
		{
			pitchDelta = self.upAimLimit;
		}
		else if(pitchDelta < self.downAimLimit)
		{
			pitchDelta = self.downAimLimit;
		}
		if(firstframe)
		{
			firstframe = 0;
		}
		else
		{
			yawDeltaChange = yawDelta - prevYawDelta;
			if(Abs(yawDeltaChange) > maxYawDeltaChange)
			{
				yawDelta = prevYawDelta + maxYawDeltaChange * math::sign(yawDeltaChange);
			}
			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if(Abs(pitchDeltaChange) > maxPitchDeltaChange)
			{
				pitchDelta = prevPitchDelta + maxPitchDeltaChange * math::sign(pitchDeltaChange);
			}
		}
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		updown = 0;
		leftright = 0;
		if(yawDelta > 0)
		{
			/#
				Assert(yawDelta <= self.rightAimLimit);
			#/
			weight = yawDelta / self.rightAimLimit * self.a.aimweight;
			leftright = weight;
		}
		else if(yawDelta < 0)
		{
			/#
				Assert(yawDelta >= self.leftAimLimit);
			#/
			weight = yawDelta / self.leftAimLimit * self.a.aimweight;
			leftright = -1 * weight;
		}
		if(pitchDelta > 0)
		{
			/#
				Assert(pitchDelta <= self.upAimLimit);
			#/
			weight = pitchDelta / self.upAimLimit * self.a.aimweight;
			updown = weight;
		}
		else if(pitchDelta < 0)
		{
			/#
				Assert(pitchDelta >= self.downAimLimit);
			#/
			weight = pitchDelta / self.downAimLimit * self.a.aimweight;
			updown = -1 * weight;
		}
		wait(0.05);
	}
}

/*
	Name: setAnimAimWeight
	Namespace: zombie_shared
	Checksum: 0x51A0DD60
	Offset: 0x2308
	Size: 0x107
	Parameters: 2
	Flags: None
*/
function setAnimAimWeight(goalweight, goalTime)
{
	if(!isdefined(goalTime) || goalTime <= 0)
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = goalweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = 0;
	}
	else
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = Int(goalTime * 20);
	}
	self.a.aimweight_t = 0;
}

/*
	Name: incrAnimAimWeight
	Namespace: zombie_shared
	Checksum: 0x1AA70A61
	Offset: 0x2418
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function incrAnimAimWeight()
{
	if(self.a.aimweight_t < self.a.aimweight_transframes)
	{
		self.a.aimweight_t++;
		t = 1 * self.a.aimweight_t / self.a.aimweight_transframes;
		self.a.aimweight = self.a.aimweight_start * 1 - t + self.a.aimweight_end * t;
	}
}

