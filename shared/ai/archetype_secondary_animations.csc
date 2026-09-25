#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;

#namespace archetype_secondary_animations;

/*
	Name: main
	Namespace: archetype_secondary_animations
	Checksum: 0xD888C374
	Offset: 0x3C0
	Size: 0xA3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	if(SessionModeIsZombiesGame() && GetDvarInt("splitscreen_playerCount") > 2)
	{
		return;
	}
	ai::add_archetype_spawn_function("human", &SecondaryAnimationsInit);
	ai::add_archetype_spawn_function("zombie", &SecondaryAnimationsInit);
	ai::add_ai_spawn_function(&on_entity_spawn);
}

/*
	Name: SecondaryAnimationsInit
	Namespace: archetype_secondary_animations
	Checksum: 0xF3450D01
	Offset: 0x470
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private SecondaryAnimationsInit(localClientNum)
{
	if(!isdefined(level.__facialAnimationsList))
	{
		BuildAndValidateFacialAnimationList(localClientNum);
	}
	self callback::on_shutdown(&on_entity_shutdown);
	self thread SecondaryFacialAnimationThink(localClientNum);
}

/*
	Name: on_entity_spawn
	Namespace: archetype_secondary_animations
	Checksum: 0xF119293A
	Offset: 0x4E0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private on_entity_spawn(localClientNum)
{
	if(self hasdobj(localClientNum))
	{
		self ClearAnim(%faces, 0);
	}
	self._currentFaceState = "inactive";
}

/*
	Name: on_entity_shutdown
	Namespace: archetype_secondary_animations
	Checksum: 0x14A1909C
	Offset: 0x548
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private on_entity_shutdown(localClientNum)
{
	if(isdefined(self))
	{
		self notify("stopFacialThread");
		if(isdefined(self.facialDeathAnimStarted) && self.facialDeathAnimStarted)
		{
			return;
		}
		self ApplyDeathAnim(localClientNum);
		self.facialDeathAnimStarted = 1;
	}
}

/*
	Name: BuildAndValidateFacialAnimationList
	Namespace: archetype_secondary_animations
	Checksum: 0x3C7D436E
	Offset: 0x5B0
	Size: 0x5A1
	Parameters: 1
	Flags: None
*/
function BuildAndValidateFacialAnimationList(localClientNum)
{
	/#
		Assert(!isdefined(level.__facialAnimationsList));
	#/
	level.__facialAnimationsList = [];
	level.__facialAnimationsList["human"] = [];
	level.__facialAnimationsList["human"]["combat"] = Array("ai_face_male_generic_idle_1", "ai_face_male_generic_idle_2", "ai_face_male_generic_idle_3");
	level.__facialAnimationsList["human"]["combat_aim"] = Array("ai_face_male_aim_idle_1", "ai_face_male_aim_idle_2", "ai_face_male_aim_idle_3");
	level.__facialAnimationsList["human"]["combat_shoot"] = Array("ai_face_male_aim_fire_1", "ai_face_male_aim_fire_2", "ai_face_male_aim_fire_3");
	level.__facialAnimationsList["human"]["death"] = Array("ai_face_male_death_1", "ai_face_male_death_2", "ai_face_male_death_3");
	level.__facialAnimationsList["human"]["melee"] = Array("ai_face_male_melee_1");
	level.__facialAnimationsList["human"]["pain"] = Array("ai_face_male_pain_1");
	level.__facialAnimationsList["human"]["animscripted"] = Array("ai_face_male_generic_idle_1");
	level.__facialAnimationsList["zombie"] = [];
	level.__facialAnimationsList["zombie"]["combat"] = Array("ai_face_zombie_generic_idle_1");
	level.__facialAnimationsList["zombie"]["combat_aim"] = Array("ai_face_zombie_generic_idle_1");
	level.__facialAnimationsList["zombie"]["combat_shoot"] = Array("ai_face_zombie_generic_idle_1");
	level.__facialAnimationsList["zombie"]["death"] = Array("ai_face_zombie_generic_death_1");
	level.__facialAnimationsList["zombie"]["melee"] = Array("ai_face_zombie_generic_attack_1");
	level.__facialAnimationsList["zombie"]["pain"] = Array("ai_face_zombie_generic_pain_1");
	level.__facialAnimationsList["zombie"]["animscripted"] = Array("ai_face_zombie_generic_idle_1");
	deathAnims = [];
	foreach(animation in level.__facialAnimationsList["human"]["death"])
	{
		Array::add(deathAnims, animation);
	}
	foreach(animation in level.__facialAnimationsList["zombie"]["death"])
	{
		Array::add(deathAnims, animation);
	}
	foreach(deathAnim in deathAnims)
	{
		/#
			Assert(!IsAnimLooping(localClientNum, deathAnim), "Dev Block strings are not supported" + deathAnim + "Dev Block strings are not supported");
		#/
	}
}

/*
	Name: GetFacialAnimOverride
	Namespace: archetype_secondary_animations
	Checksum: 0x7C0B2A0E
	Offset: 0xB60
	Size: 0x18D
	Parameters: 1
	Flags: Private
*/
function private GetFacialAnimOverride(localClientNum)
{
	if(SessionModeIsCampaignGame())
	{
		primaryDeltaAnim = self GetPrimaryDeltaAnim();
		if(isdefined(primaryDeltaAnim))
		{
			primaryDeltaAnimLength = getanimlength(primaryDeltaAnim);
			notetracks = GetNotetracksInDelta(primaryDeltaAnim, 0, 1);
			foreach(Notetrack in notetracks)
			{
				if(Notetrack[1] == "facial_anim")
				{
					facialAnim = Notetrack[2];
					facialAnimLength = getanimlength(facialAnim);
					/#
					#/
					return facialAnim;
				}
			}
		}
	}
	return undefined;
}

/*
	Name: SecondaryFacialAnimationThink
	Namespace: archetype_secondary_animations
	Checksum: 0x7CAAE203
	Offset: 0xCF8
	Size: 0x5FB
	Parameters: 1
	Flags: Private
*/
function private SecondaryFacialAnimationThink(localClientNum)
{
	/#
		Assert(isdefined(self.archetype) && (self.archetype == "Dev Block strings are not supported" || self.archetype == "Dev Block strings are not supported"));
	#/
	self endon("entityshutdown");
	self endon("stopFacialThread");
	self._currentFaceState = "inactive";
	while(1)
	{
		if(self.archetype == "human" && self clientfield::get("facial_dial"))
		{
			self._currentFaceState = "inactive";
			self ClearCurrentFacialAnim(localClientNum);
			wait(0.5);
			continue;
		}
		animOverride = self GetFacialAnimOverride(localClientNum);
		asmStatus = self ASMGetStatus(localClientNum);
		forceNewAnim = 0;
		switch(asmStatus)
		{
			case "asm_status_terminated":
			{
				return;
			}
			case "asm_status_inactive":
			{
				if(isdefined(animOverride))
				{
					scriptedanim = self GetPrimaryDeltaAnim();
					if(isdefined(scriptedanim) && (!isdefined(self._scriptedAnim) || self._scriptedAnim != scriptedanim))
					{
						self._scriptedAnim = scriptedanim;
						forceNewAnim = 1;
					}
					if(isdefined(animOverride) && animOverride !== self._currentFaceAnim)
					{
						forceNewAnim = 1;
					}
				}
				else if(self._currentFaceState !== "death")
				{
					self._currentFaceState = "inactive";
					self ClearCurrentFacialAnim(localClientNum);
				}
				wait(0.5);
				continue;
			}
		}
		closestPlayer = ArrayGetClosest(self.origin, level.localPlayers, GetDvarInt("ai_clientFacialCullDist", 2000));
		if(!isdefined(closestPlayer))
		{
			wait(0.5);
			continue;
		}
		if(!self hasdobj(localClientNum) || !self HasAnimTree())
		{
			wait(0.5);
			continue;
		}
		currFaceState = self._currentFaceState;
		currentASMState = self ASMGetCurrentState(localClientNum);
		if(isdefined(currentASMState))
		{
			currentASMState = ToLower(currentASMState);
		}
		if(self ASMIsTerminating(localClientNum))
		{
			nextFaceState = "death";
		}
		else if(asmStatus == "asm_status_inactive")
		{
			nextFaceState = "animscripted";
		}
		else if(isdefined(currentASMState) && IsSubStr(currentASMState, "pain"))
		{
			nextFaceState = "pain";
		}
		else if(isdefined(currentASMState) && IsSubStr(currentASMState, "melee"))
		{
			nextFaceState = "melee";
		}
		else if(self ASMIsShootLayerActive(localClientNum))
		{
			nextFaceState = "combat_shoot";
		}
		else if(self ASMIsAimLayerActive(localClientNum))
		{
			nextFaceState = "combat_aim";
		}
		else
		{
			nextFaceState = "combat";
		}
		if(currFaceState == "inactive" || currFaceState != nextFaceState || forceNewAnim)
		{
			/#
				Assert(isdefined(level.__facialAnimationsList[self.archetype][nextFaceState]));
			#/
			clearOnCompletion = 0;
			animToPlay = Array::random(level.__facialAnimationsList[self.archetype][nextFaceState]);
			if(isdefined(animOverride))
			{
				animToPlay = animOverride;
				/#
					Assert(nextFaceState != "Dev Block strings are not supported" || !IsAnimLooping(localClientNum, animToPlay), "Dev Block strings are not supported" + animToPlay + "Dev Block strings are not supported");
				#/
			}
			ApplyNewFaceAnim(localClientNum, animToPlay, clearOnCompletion);
			self._currentFaceState = nextFaceState;
		}
		if(self._currentFaceState == "death")
		{
			break;
		}
		wait(0.25);
	}
}

/*
	Name: ApplyNewFaceAnim
	Namespace: archetype_secondary_animations
	Checksum: 0xCBC5A89F
	Offset: 0x1300
	Size: 0xFB
	Parameters: 3
	Flags: Private
*/
function private ApplyNewFaceAnim(localClientNum, animation, clearOnCompletion)
{
	if(!isdefined(clearOnCompletion))
	{
		clearOnCompletion = 0;
	}
	ClearCurrentFacialAnim(localClientNum);
	if(isdefined(animation))
	{
		self._currentFaceAnim = animation;
		if(self hasdobj(localClientNum) && self HasAnimTree())
		{
			self SetFlaggedAnimKnob("ai_secondary_facial_anim", animation, 1, 0.1, 1);
			if(clearOnCompletion)
			{
				wait(getanimlength(animation));
				ClearCurrentFacialAnim(localClientNum);
			}
		}
	}
}

/*
	Name: ApplyDeathAnim
	Namespace: archetype_secondary_animations
	Checksum: 0xED6696AD
	Offset: 0x1408
	Size: 0x133
	Parameters: 1
	Flags: Private
*/
function private ApplyDeathAnim(localClientNum)
{
	if(isdefined(self._currentFaceState) && self._currentFaceState == "death")
	{
		return;
	}
	if(GetMigrationStatus(localClientNum))
	{
		return;
	}
	if(isdefined(self) && isdefined(level.__facialAnimationsList) && isdefined(level.__facialAnimationsList[self.archetype]) && isdefined(level.__facialAnimationsList[self.archetype]["death"]))
	{
		animToPlay = Array::random(level.__facialAnimationsList[self.archetype]["death"]);
		animOverride = self GetFacialAnimOverride(localClientNum);
		if(isdefined(animOverride))
		{
			animToPlay = animOverride;
		}
		self._currentFaceState = "death";
		ApplyNewFaceAnim(localClientNum, animToPlay);
	}
}

/*
	Name: ClearCurrentFacialAnim
	Namespace: archetype_secondary_animations
	Checksum: 0xA313C959
	Offset: 0x1548
	Size: 0x7D
	Parameters: 1
	Flags: Private
*/
function private ClearCurrentFacialAnim(localClientNum)
{
	if(isdefined(self._currentFaceAnim) && self hasdobj(localClientNum) && self HasAnimTree())
	{
		self ClearAnim(self._currentFaceAnim, 0.2);
	}
	self._currentFaceAnim = undefined;
}

