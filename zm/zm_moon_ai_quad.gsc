#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_quad;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_moon_ai_quad;

/*
	Name: init
	Namespace: zm_moon_ai_quad
	Checksum: 0xA925BFFA
	Offset: 0x620
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmmoonbehaviorsandasm();
	spawner::add_archetype_spawn_function("zombie_quad", &moon_quad_spawned);
}

/*
	Name: initzmmoonbehaviorsandasm
	Namespace: zm_moon_ai_quad
	Checksum: 0xA4112EB7
	Offset: 0x668
	Size: 0x173
	Parameters: 0
	Flags: Private
*/
function private initzmmoonbehaviorsandasm()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("quadPhasingService", &quadphasingservice);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldPhase", &shouldphase);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("phaseActionStart", &phaseactionstart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("phaseActionTerminate", &phaseactionterminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("moonQuadKilledByMicrowaveGunDw", &killedbymicrowavegundw);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("moonQuadKilledByMicrowaveGun", &killedbymicrowavegun);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("phase_start", &quadphasestart);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("phase_end", &quadphaseend);
	AnimationStateNetwork::RegisterAnimationMocomp("quad_phase", &mocompquadphase, undefined, undefined);
}

/*
	Name: quadphasingservice
	Namespace: zm_moon_ai_quad
	Checksum: 0x500B30F7
	Offset: 0x7E8
	Size: 0x39B
	Parameters: 1
	Flags: Private
*/
function private quadphasingservice(entity)
{
	if(isdefined(entity.is_phasing) && entity.is_phasing)
	{
		return 0;
	}
	entity.can_phase = 0;
	if(entity.var_20535e44 == 0)
	{
		if(math::cointoss())
		{
			entity.phase_dir = "quad_phase_right";
		}
		else
		{
			entity.phase_dir = "quad_phase_left";
		}
	}
	else if(entity.var_20535e44 == -1)
	{
		entity.phase_dir = "quad_phase_right";
	}
	else
	{
		entity.phase_dir = "quad_phase_left";
	}
	if(entity.phase_dir == "quad_phase_left")
	{
		if(isPlayer(entity.enemy) && entity.enemy islookingat(entity))
		{
			if(entity MayMoveFromPointToPoint(entity.origin, zombie_utility::getAnimEndPos(level.quad_phase_anims["phase_left_long"])))
			{
				entity.can_phase = 1;
			}
		}
	}
	else if(isPlayer(entity.enemy) && entity.enemy islookingat(entity))
	{
		if(entity MayMoveFromPointToPoint(entity.origin, zombie_utility::getAnimEndPos(level.quad_phase_anims["phase_right_long"])))
		{
			entity.can_phase = 1;
		}
	}
	if(!(isdefined(entity.can_phase) && entity.can_phase))
	{
		if(entity MayMoveFromPointToPoint(entity.origin, zombie_utility::getAnimEndPos(level.quad_phase_anims["phase_forward"])))
		{
			entity.can_phase = 1;
			entity.phase_dir = "quad_phase_forward";
		}
	}
	if(isdefined(entity.can_phase) && entity.can_phase)
	{
		blackboard::SetBlackBoardAttribute(entity, "_quad_phase_direction", entity.phase_dir);
		if(math::cointoss())
		{
			blackboard::SetBlackBoardAttribute(entity, "_quad_phase_distance", "quad_phase_short");
		}
		else
		{
			blackboard::SetBlackBoardAttribute(entity, "_quad_phase_distance", "quad_phase_long");
		}
		return 1;
	}
	return 0;
}

/*
	Name: shouldphase
	Namespace: zm_moon_ai_quad
	Checksum: 0xB53C5092
	Offset: 0xB90
	Size: 0x22B
	Parameters: 1
	Flags: Private
*/
function private shouldphase(entity)
{
	if(!(isdefined(entity.can_phase) && entity.can_phase))
	{
		return 0;
	}
	if(isdefined(entity.is_phasing) && entity.is_phasing)
	{
		return 0;
	}
	if(GetTime() - entity.last_phase_time < 2000)
	{
		return 0;
	}
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	dist_sq = DistanceSquared(entity.origin, entity.enemy.origin);
	min_dist_sq = 4096;
	max_dist_sq = 1000000;
	if(entity.phase_dir == "quad_phase_forward")
	{
		min_dist_sq = 14400;
		max_dist_sq = 5760000;
	}
	if(dist_sq < min_dist_sq)
	{
		return 0;
	}
	if(dist_sq > max_dist_sq)
	{
		return 0;
	}
	if(!isdefined(entity.pathGoalPos) || DistanceSquared(entity.origin, entity.pathGoalPos) < min_dist_sq)
	{
		return 0;
	}
	if(Abs(entity getMotionAngle()) > 15)
	{
		return 0;
	}
	yaw = zombie_utility::GetYawToOrigin(entity.enemy.origin);
	if(Abs(yaw) > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: phaseactionstart
	Namespace: zm_moon_ai_quad
	Checksum: 0x7BC2833C
	Offset: 0xDC8
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private phaseactionstart(entity)
{
	entity.is_phasing = 1;
	if(entity.phase_dir == "quad_phase_left")
	{
		entity.var_20535e44--;
	}
	else if(entity.phase_dir == "quad_phase_right")
	{
		entity.var_20535e44++;
	}
}

/*
	Name: phaseactionterminate
	Namespace: zm_moon_ai_quad
	Checksum: 0x682F8065
	Offset: 0xE50
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private phaseactionterminate(entity)
{
	entity.last_phase_time = GetTime();
	entity.is_phasing = 0;
}

/*
	Name: killedbymicrowavegundw
	Namespace: zm_moon_ai_quad
	Checksum: 0xB4D12F1D
	Offset: 0xE88
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private killedbymicrowavegundw(entity)
{
	return isdefined(entity.microwavegun_dw_death) && entity.microwavegun_dw_death;
}

/*
	Name: killedbymicrowavegun
	Namespace: zm_moon_ai_quad
	Checksum: 0x4F24DC7B
	Offset: 0xEC0
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private killedbymicrowavegun(entity)
{
	return isdefined(entity.microwavegun_death) && entity.microwavegun_death;
}

/*
	Name: quadphasestart
	Namespace: zm_moon_ai_quad
	Checksum: 0x53349F2E
	Offset: 0xEF8
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private quadphasestart(entity)
{
	entity thread moon_quad_phase_fx("quad_phasing_out");
	entity ghost();
}

/*
	Name: quadphaseend
	Namespace: zm_moon_ai_quad
	Checksum: 0xA29B838F
	Offset: 0xF48
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private quadphaseend(entity)
{
	entity thread moon_quad_phase_fx("quad_phasing_in");
	entity show();
}

/*
	Name: mocompquadphase
	Namespace: zm_moon_ai_quad
	Checksum: 0xE29D6AD6
	Offset: 0xF98
	Size: 0x4B
	Parameters: 5
	Flags: Private
*/
function private mocompquadphase(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("gravity", 0);
}

/*
	Name: moon_quad_spawned
	Namespace: zm_moon_ai_quad
	Checksum: 0x3C6524ED
	Offset: 0xFF0
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function moon_quad_spawned()
{
	self.can_phase = 0;
	self.last_phase_time = GetTime();
	self.var_20535e44 = 0;
	if(!isdefined(level.quad_phase_anims))
	{
		level.quad_phase_anims = [];
		level.quad_phase_anims["phase_forward"] = self AnimMappingSearch(istring("anim_zombie_phase_f_long_b"));
		level.quad_phase_anims["phase_left_long"] = self AnimMappingSearch(istring("anim_zombie_phase_l_long_b"));
		level.quad_phase_anims["phase_left_short"] = self AnimMappingSearch(istring("anim_zombie_phase_l_short_b"));
		level.quad_phase_anims["phase_right_long"] = self AnimMappingSearch(istring("anim_zombie_phase_r_long_b"));
		level.quad_phase_anims["phase_right_short"] = self AnimMappingSearch(istring("anim_zombie_phase_r_short_a"));
	}
}

/*
	Name: moon_quad_prespawn
	Namespace: zm_moon_ai_quad
	Checksum: 0x82F11BF4
	Offset: 0x1178
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function moon_quad_prespawn()
{
	self.no_gib = 1;
	self.zombie_can_sidestep = 1;
	self.zombie_can_forwardstep = 1;
	self.sideStepFunc = &moon_quad_sidestep;
	self.fastSprintFunc = &moon_quad_fastSprint;
}

/*
	Name: moon_quad_sidestep
	Namespace: zm_moon_ai_quad
	Checksum: 0x498F4AD1
	Offset: 0x11D8
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function moon_quad_sidestep(animName, stepAnim)
{
	self endon("death");
	self endon("stop_sidestep");
	self thread moon_quad_wait_phase_end(stepAnim);
	self thread moon_quad_exit_align(stepAnim);
	while(1)
	{
		self waittill(animName, note);
		if(note == "phase_start")
		{
			self thread moon_quad_phase_fx("quad_phasing_out");
			self playsound("zmb_quad_phase_out");
			self ghost();
		}
		else if(note == "phase_end")
		{
			self notify("stop_wait_phase_end");
			self thread moon_quad_phase_fx("quad_phasing_in");
			self show();
			self playsound("zmb_quad_phase_in");
			break;
		}
	}
}

/*
	Name: moon_quad_fastSprint
	Namespace: zm_moon_ai_quad
	Checksum: 0x256543AD
	Offset: 0x1348
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function moon_quad_fastSprint()
{
	if(isdefined(self.in_low_gravity) && self.in_low_gravity)
	{
		return "low_g_super_sprint";
	}
	return "super_sprint";
}

/*
	Name: moon_quad_wait_phase_end
	Namespace: zm_moon_ai_quad
	Checksum: 0x45746C11
	Offset: 0x1380
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function moon_quad_wait_phase_end(stepAnim)
{
	self endon("death");
	self endon("stop_wait_phase_end");
	anim_length = getanimlength(stepAnim);
	wait(anim_length);
	self thread moon_quad_phase_fx("quad_phasing_in");
	self show();
	self notify("stop_sidestep");
}

/*
	Name: moon_quad_exit_align
	Namespace: zm_moon_ai_quad
	Checksum: 0x4A91A0B
	Offset: 0x1420
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function moon_quad_exit_align(stepAnim)
{
	self endon("death");
	anim_length = getanimlength(stepAnim);
	wait(anim_length);
	if(!(isdefined(self.exit_align) && self.exit_align))
	{
		self notify("stepAnim", "exit_align");
	}
}

/*
	Name: moon_quad_phase_fx
	Namespace: zm_moon_ai_quad
	Checksum: 0x8BB9DB1
	Offset: 0x1498
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function moon_quad_phase_fx(var_99a8589b)
{
	self endon("death");
	if(isdefined(level._effect[var_99a8589b]))
	{
		PlayFXOnTag(level._effect[var_99a8589b], self, "j_spine4");
	}
}

/*
	Name: moon_quad_gas_immune
	Namespace: zm_moon_ai_quad
	Checksum: 0xA44A2E4A
	Offset: 0x14F8
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function moon_quad_gas_immune()
{
	self endon("disconnect");
	self endon("death");
}

