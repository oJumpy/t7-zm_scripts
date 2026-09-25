#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace archetype_damage_effects;

/*
	Name: main
	Namespace: archetype_damage_effects
	Checksum: 0xF02A96FB
	Offset: 0x11D0
	Size: 0x23
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	RegisterClientFields();
	LoadEffects();
}

/*
	Name: RegisterClientFields
	Namespace: archetype_damage_effects
	Checksum: 0x2862588D
	Offset: 0x1200
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function RegisterClientFields()
{
	clientfield::register("actor", "arch_actor_fire_fx", 1, 2, "int", &actor_fire_fx_state, 0, 0);
	clientfield::register("actor", "arch_actor_char", 1, 2, "int", &actor_char, 0, 0);
}

/*
	Name: LoadEffects
	Namespace: archetype_damage_effects
	Checksum: 0x2BC6036F
	Offset: 0x12A0
	Size: 0xA81
	Parameters: 0
	Flags: None
*/
function LoadEffects()
{
	level._effect["fire_human_j_elbow_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_human_j_elbow_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_human_j_shoulder_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_human_j_shoulder_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_human_j_spine4_loop"] = "fire/fx_fire_ai_human_torso_loop";
	level._effect["fire_human_j_hip_le_loop"] = "fire/fx_fire_ai_human_hip_left_loop";
	level._effect["fire_human_j_hip_ri_loop"] = "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["fire_human_j_knee_le_loop"] = "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["fire_human_j_knee_ri_loop"] = "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["fire_human_j_head_loop"] = "fire/fx_fire_ai_human_head_loop";
	level._effect["fire_human_j_elbow_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_human_j_elbow_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_human_j_shoulder_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_human_j_shoulder_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_human_j_spine4_os"] = "fire/fx_fire_ai_human_torso_os";
	level._effect["fire_human_j_hip_le_os"] = "fire/fx_fire_ai_human_hip_left_os";
	level._effect["fire_human_j_hip_ri_os"] = "fire/fx_fire_ai_human_hip_right_os";
	level._effect["fire_human_j_knee_le_os"] = "fire/fx_fire_ai_human_leg_left_os";
	level._effect["fire_human_j_knee_ri_os"] = "fire/fx_fire_ai_human_leg_right_os";
	level._effect["fire_human_j_head_os"] = "fire/fx_fire_ai_human_head_os";
	level._effect["fire_human_riotshield_j_elbow_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_human_riotshield_j_elbow_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_human_riotshield_j_shoulder_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_human_riotshield_j_shoulder_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_human_riotshield_j_spine4_loop"] = "fire/fx_fire_ai_human_torso_loop";
	level._effect["fire_human_riotshield_j_hip_le_loop"] = "fire/fx_fire_ai_human_hip_left_loop";
	level._effect["fire_human_riotshield_j_hip_ri_loop"] = "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["fire_human_riotshield_j_knee_le_loop"] = "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["fire_human_riotshield_j_knee_ri_loop"] = "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["fire_human_riotshield_j_head_loop"] = "fire/fx_fire_ai_human_head_loop";
	level._effect["fire_human_riotshield_j_elbow_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_human_riotshield_j_elbow_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_human_riotshield_j_shoulder_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_human_riotshield_j_shoulder_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_human_riotshield_j_spine4_os"] = "fire/fx_fire_ai_human_torso_os";
	level._effect["fire_human_riotshield_j_hip_le_os"] = "fire/fx_fire_ai_human_hip_left_os";
	level._effect["fire_human_riotshield_j_hip_ri_os"] = "fire/fx_fire_ai_human_hip_right_os";
	level._effect["fire_human_riotshield_j_knee_le_os"] = "fire/fx_fire_ai_human_leg_left_os";
	level._effect["fire_human_riotshield_j_knee_ri_os"] = "fire/fx_fire_ai_human_leg_right_os";
	level._effect["fire_human_riotshield_j_head_os"] = "fire/fx_fire_ai_human_head_os";
	level._effect["fire_warlord_j_elbow_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_warlord_j_elbow_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_warlord_j_shoulder_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_warlord_j_shoulder_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_warlord_j_spine4_loop"] = "fire/fx_fire_ai_human_torso_loop";
	level._effect["fire_warlord_j_hip_le_loop"] = "fire/fx_fire_ai_human_hip_left_loop";
	level._effect["fire_warlord_j_hip_ri_loop"] = "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["fire_warlord_j_knee_le_loop"] = "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["fire_warlord_j_knee_ri_loop"] = "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["fire_warlord_j_head_loop"] = "fire/fx_fire_ai_human_head_loop";
	level._effect["fire_warlord_j_elbow_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_warlord_j_elbow_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_warlord_j_shoulder_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_warlord_j_shoulder_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_warlord_j_spine4_os"] = "fire/fx_fire_ai_human_torso_os";
	level._effect["fire_warlord_j_hip_le_os"] = "fire/fx_fire_ai_human_hip_left_os";
	level._effect["fire_warlord_j_hip_ri_os"] = "fire/fx_fire_ai_human_hip_right_os";
	level._effect["fire_warlord_j_knee_le_os"] = "fire/fx_fire_ai_human_leg_left_os";
	level._effect["fire_warlord_j_knee_ri_os"] = "fire/fx_fire_ai_human_leg_right_os";
	level._effect["fire_warlord_j_head_os"] = "fire/fx_fire_ai_human_head_os";
	level._effect["fire_zombie_j_elbow_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_zombie_j_elbow_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_zombie_j_shoulder_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_zombie_j_shoulder_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_zombie_j_spine4_os"] = "fire/fx_fire_ai_human_torso_os";
	level._effect["fire_zombie_j_hip_le_os"] = "fire/fx_fire_ai_human_hip_left_os";
	level._effect["fire_zombie_j_hip_ri_os"] = "fire/fx_fire_ai_human_hip_right_os";
	level._effect["fire_zombie_j_knee_le_os"] = "fire/fx_fire_ai_human_leg_left_os";
	level._effect["fire_zombie_j_knee_ri_os"] = "fire/fx_fire_ai_human_leg_right_os";
	level._effect["fire_zombie_j_head_os"] = "fire/fx_fire_ai_human_head_os";
	level._effect["smolder_human_j_elbow_le_os"] = "smoke/fx_smk_ai_human_arm_left_os";
	level._effect["smolder_human_j_elbow_ri_os"] = "smoke/fx_smk_ai_human_arm_right_os";
	level._effect["smolder_human_j_shoulder_le_os"] = "smoke/fx_smk_ai_human_arm_left_os";
	level._effect["smolder_human_j_shoulder_ri_os"] = "smoke/fx_smk_ai_human_arm_right_os";
	level._effect["smolder_human_j_spine4_os"] = "smoke/fx_smk_ai_human_torso_os";
	level._effect["smolder_human_j_hip_le_os"] = "smoke/fx_smk_ai_human_hip_left_os";
	level._effect["smolder_human_j_hip_ri_os"] = "smoke/fx_smk_ai_human_hip_right_os";
	level._effect["smolder_human_j_knee_le_os"] = "smoke/fx_smk_ai_human_leg_left_os";
	level._effect["smolder_human_j_knee_ri_os"] = "smoke/fx_smk_ai_human_leg_right_os";
	level._effect["smolder_human_j_head_os"] = "smoke/fx_smk_ai_human_head_os";
	level._effect["fire_robot_j_elbow_le_rot_loop"] = "fire/fx_fire_ai_robot_arm_left_loop";
	level._effect["fire_robot_j_elbow_ri_rot_loop"] = "fire/fx_fire_ai_robot_arm_right_loop";
	level._effect["fire_robot_j_shoulder_le_rot_loop"] = "fire/fx_fire_ai_robot_arm_left_loop";
	level._effect["fire_robot_j_shoulder_ri_rot_loop"] = "fire/fx_fire_ai_robot_arm_right_loop";
	level._effect["fire_robot_j_spine4_loop"] = "fire/fx_fire_ai_robot_torso_loop";
	level._effect["fire_robot_j_knee_le_loop"] = "fire/fx_fire_ai_robot_leg_left_loop";
	level._effect["fire_robot_j_knee_ri_loop"] = "fire/fx_fire_ai_robot_leg_right_loop";
	level._effect["fire_robot_j_head_loop"] = "fire/fx_fire_ai_robot_head_loop";
	level._effect["fire_robot_j_elbow_le_rot_os"] = "fire/fx_fire_ai_robot_arm_left_os";
	level._effect["fire_robot_j_elbow_ri_rot_os"] = "fire/fx_fire_ai_robot_arm_right_os";
	level._effect["fire_robot_j_shoulder_le_rot_os"] = "fire/fx_fire_ai_robot_arm_left_os";
	level._effect["fire_robot_j_shoulder_ri_rot_os"] = "fire/fx_fire_ai_robot_arm_right_os";
	level._effect["fire_robot_j_spine4_os"] = "fire/fx_fire_ai_robot_torso_os";
	level._effect["fire_robot_j_knee_le_os"] = "fire/fx_fire_ai_robot_leg_left_os";
	level._effect["fire_robot_j_knee_ri_os"] = "fire/fx_fire_ai_robot_leg_right_os";
	level._effect["fire_robot_j_head_os"] = "fire/fx_fire_ai_robot_head_os";
}

/*
	Name: _burnTag
	Namespace: archetype_damage_effects
	Checksum: 0xE1450FB9
	Offset: 0x1D30
	Size: 0x159
	Parameters: 3
	Flags: Private
*/
function private _burnTag(localClientNum, tag, postfix)
{
	if(isdefined(self) && self hasdobj(localClientNum))
	{
		fx_to_play = undefined;
		fxName = "fire_" + self.archetype + "_" + tag + postfix;
		if(isdefined(level._effect[fxName]))
		{
			fx_to_play = level._effect[fxName];
		}
		if(isdefined(self._effect) && isdefined(self._effect[fxName]))
		{
			fx_to_play = self._effect[fxName];
		}
		if(isdefined(fx_to_play))
		{
			FX = PlayFXOnTag(localClientNum, fx_to_play, self, tag);
			if(SessionModeIsCampaignZombiesGame() && isdefined(FX))
			{
				SetFXIgnorePause(localClientNum, FX, 1);
			}
			return FX;
		}
	}
}

/*
	Name: _burnStage
	Namespace: archetype_damage_effects
	Checksum: 0x6964BEC5
	Offset: 0x1E98
	Size: 0x149
	Parameters: 3
	Flags: Private
*/
function private _burnStage(localClientNum, tagArray, shouldWait)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon("entityshutdown");
	tags = Array::randomize(tagArray);
	for(i = 1; i < tags.size; i++)
	{
		if(tags[i] == "null")
		{
			continue;
		}
		if(shouldWait)
		{
		}
		else
		{
		}
		self.activeFx[self.activeFx.size] = self _burnTag(localClientNum, tags[i], "_os");
		if(shouldWait)
		{
			wait(RandomFloatRange(0.1, 0.3));
		}
	}
	if(shouldWait)
	{
		wait(RandomFloatRange(0, 1));
	}
	if(isdefined(self))
	{
		self notify("burn_stage_finished", "_loop");
	}
}

/*
	Name: _burnBody
	Namespace: archetype_damage_effects
	Checksum: 0x73388C1A
	Offset: 0x1FF0
	Size: 0x48B
	Parameters: 1
	Flags: Private
*/
function private _burnBody(localClientNum)
{
	self endon("entityshutdown");
	self.burn_loop_sound_handle = self PlayLoopSound("chr_burn_npc_loop1", 0.2);
	timer = 10;
	boneModifier = "";
	if(self.archetype == "robot")
	{
		boneModifier = "_rot";
		timer = 6;
	}
	if(SessionModeIsCampaignZombiesGame())
	{
		if(self.archetype !== "zombie")
		{
			self thread sndStopBurnLoop(timer);
		}
	}
	else
	{
		self thread sndStopBurnLoop(timer);
	}
	stage1BurnTags = Array("j_elbow_le" + boneModifier, "j_elbow_ri" + boneModifier, "null");
	stage2BurnTags = Array("j_shoulder_le" + boneModifier, "j_shoulder_ri" + boneModifier, "null");
	stage3BurnTags = Array("j_spine4", "null");
	stage4BurnTags = Array("j_hip_le", "j_hip_ri", "j_head", "null");
	stage5BurnTags = Array("j_knee_le", "j_knee_ri", "null");
	matureMask = 0;
	if(util::is_mature())
	{
		matureMask = 1;
	}
	self.activeFx = [];
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage1BurnTags, 1);
	self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 0.2);
	self waittill("burn_stage_finished");
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage2BurnTags, 1);
	self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 0.4);
	self waittill("burn_stage_finished");
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage3BurnTags, 1);
	self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 0.6);
	self waittill("burn_stage_finished");
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage4BurnTags, 1);
	self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 0.8);
	self waittill("burn_stage_finished");
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage5BurnTags, 1);
	self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 1);
}

/*
	Name: sndStopBurnLoop
	Namespace: archetype_damage_effects
	Checksum: 0x6D57220
	Offset: 0x2488
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function sndStopBurnLoop(timer)
{
	self util::waittill_any_timeout(timer, "entityshutdown", "stopBurningSounds");
	if(isdefined(self))
	{
		if(isdefined(self.burn_loop_sound_handle))
		{
			self StopLoopSound(self.burn_loop_sound_handle);
		}
	}
}

/*
	Name: _burnCorpse
	Namespace: archetype_damage_effects
	Checksum: 0xEB0BA258
	Offset: 0x24F8
	Size: 0x3E3
	Parameters: 2
	Flags: Private
*/
function private _burnCorpse(localClientNum, burningDuration)
{
	self endon("entityshutdown");
	timer = 10;
	boneModifier = "";
	if(self.archetype == "robot")
	{
		boneModifier = "_rot";
		timer = 3;
	}
	stage1BurnTags = Array("j_elbow_le" + boneModifier, "j_elbow_ri" + boneModifier);
	stage2BurnTags = Array("j_shoulder_le" + boneModifier, "j_shoulder_ri" + boneModifier);
	stage3BurnTags = Array("j_spine4", "j_spinelower", "null");
	stage4BurnTags = Array("j_hip_le", "j_hip_ri", "j_head");
	stage5BurnTags = Array("j_knee_le", "j_knee_ri");
	self.burn_loop_sound_handle = self PlayLoopSound("chr_burn_npc_loop1", 0.2);
	self thread sndStopBurnLoop(timer);
	self.activeFx = [];
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage1BurnTags, 0);
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage2BurnTags, 0);
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage3BurnTags, 0);
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage4BurnTags, 0);
	self.activeFx[self.activeFx.size] = self thread _burnStage(localClientNum, stage5BurnTags, 0);
	matureMask = 0;
	if(util::is_mature())
	{
		matureMask = 1;
	}
	self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 1);
	wait(20);
	if(isdefined(self))
	{
		foreach(FX in self.activeFx)
		{
			stopfx(localClientNum, FX);
			self notify("stopBurningSounds");
		}
		if(isdefined(self))
		{
			self.activeFx = [];
		}
	}
}

/*
	Name: _smolderCorpse
	Namespace: archetype_damage_effects
	Checksum: 0x30E14D54
	Offset: 0x28E8
	Size: 0x2E1
	Parameters: 1
	Flags: Private
*/
function private _smolderCorpse(localClientNum)
{
	self endon("entityshutdown");
	boneModifier = "";
	if(self.archetype == "robot")
	{
		boneModifier = "_rot";
	}
	activeFx = [];
	fxToPlay = [];
	tags = Array("j_elbow_le" + boneModifier, "j_elbow_ri" + boneModifier, "j_shoulder_le", "j_shoulder_ri", "j_spine4", "j_hip_le", "j_hip_ri", "j_knee_le", "j_knee_ri", "j_head");
	for(num = randomIntRange(6, 10); num; num--)
	{
		fxToPlay[fxToPlay.size] = tags[RandomInt(tags.size)];
	}
	foreach(tag in fxToPlay)
	{
		FX = "smolder_" + self.archetype + tag + "_os";
		if(isdefined(level._effect[FX]))
		{
			activeFx[activeFx.size] = PlayFXOnTag(localClientNum, level._effect[FX], self, tag);
			wait(RandomFloatRange(0.1, 1));
		}
	}
	wait(20);
	if(isdefined(self))
	{
		foreach(FX in activeFx)
		{
			stopfx(localClientNum, FX);
		}
	}
}

/*
	Name: actor_fire_fx
	Namespace: archetype_damage_effects
	Checksum: 0x9D5A020F
	Offset: 0x2BD8
	Size: 0x16D
	Parameters: 3
	Flags: None
*/
function actor_fire_fx(localClientNum, value, burningDuration)
{
	switch(value)
	{
		case 0:
		{
			if(isdefined(self.activeFx))
			{
				self StopAllLoopSounds(1);
				foreach(FX in self.activeFx)
				{
					stopfx(localClientNum, FX);
				}
			}
			self.activeFx = [];
			break;
		}
		case 1:
		{
			self thread _burnBody(localClientNum);
			break;
		}
		case 2:
		{
			self thread _burnCorpse(localClientNum, burningDuration);
			break;
		}
		case 3:
		{
			self thread _smolderCorpse(localClientNum);
			break;
		}
	}
}

/*
	Name: actor_fire_fx_state
	Namespace: archetype_damage_effects
	Checksum: 0xE0AEE3E6
	Offset: 0x2D50
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function actor_fire_fx_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self actor_fire_fx(localClientNum, newVal, 14);
}

/*
	Name: actor_char
	Namespace: archetype_damage_effects
	Checksum: 0x47EE5FC6
	Offset: 0x2DB8
	Size: 0x115
	Parameters: 7
	Flags: None
*/
function actor_char(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	matureMask = 0;
	if(util::is_mature())
	{
		matureMask = 1;
	}
	switch(newVal)
	{
		case 1:
		{
			self thread actorCharRampTo(localClientNum, 1);
			break;
		}
		case 0:
		{
			self MapShaderConstant(localClientNum, 0, "scriptVector0", 0);
			break;
		}
		case 2:
		{
			self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * 1);
			break;
		}
	}
}

/*
	Name: actorCharRampTo
	Namespace: archetype_damage_effects
	Checksum: 0xECB46D7
	Offset: 0x2ED8
	Size: 0x167
	Parameters: 2
	Flags: None
*/
function actorCharRampTo(localClientNum, charDesired)
{
	self endon("entityshutdown");
	if(!isdefined(self.curCharLevel))
	{
		self.curCharLevel = 0;
	}
	matureMask = 0;
	if(util::is_mature())
	{
		matureMask = 1;
	}
	if(!isdefined(self.charsteps))
	{
		/#
			Assert(isdefined(charDesired));
		#/
		self.charsteps = Int(200);
		delta = charDesired - self.curCharLevel;
		self.charinc = delta / self.charsteps;
	}
	while(self.charsteps)
	{
		self.curCharLevel = math::clamp(self.curCharLevel + self.charinc, 0, 1);
		self MapShaderConstant(localClientNum, 0, "scriptVector0", matureMask * self.curCharLevel);
		self.charsteps--;
		wait(0.01);
	}
}

