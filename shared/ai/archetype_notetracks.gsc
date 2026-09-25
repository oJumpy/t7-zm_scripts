#using scripts\shared\ai\archetype_human_cover;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;

#namespace AnimationStateNetwork;

/*
	Name: RegisterDefaultNotetrackHandlerFunctions
	Namespace: AnimationStateNetwork
	Checksum: 0xF6C90615
	Offset: 0x438
	Size: 0x43B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterDefaultNotetrackHandlerFunctions()
{
	RegisterNotetrackHandlerFunction("fire", &notetrackFireBullet);
	RegisterNotetrackHandlerFunction("gib_disable", &notetrackGibDisable);
	RegisterNotetrackHandlerFunction("gib = "head"", &GibServerUtils::GibHead);
	RegisterNotetrackHandlerFunction("gib = "arm_left"", &GibServerUtils::GibLeftArm);
	RegisterNotetrackHandlerFunction("gib = "arm_right"", &GibServerUtils::GibRightArm);
	RegisterNotetrackHandlerFunction("gib = "leg_left"", &GibServerUtils::GibLeftLeg);
	RegisterNotetrackHandlerFunction("gib = "leg_right"", &GibServerUtils::GibRightLeg);
	RegisterNotetrackHandlerFunction("dropgun", &notetrackDropGun);
	RegisterNotetrackHandlerFunction("gun drop", &notetrackDropGun);
	RegisterNotetrackHandlerFunction("drop_shield", &notetrackDropShield);
	RegisterNotetrackHandlerFunction("hide_weapon", &notetrackHideWeapon);
	RegisterNotetrackHandlerFunction("show_weapon", &notetrackShowWeapon);
	RegisterNotetrackHandlerFunction("hide_ai", &notetrackHideAI);
	RegisterNotetrackHandlerFunction("show_ai", &notetrackShowAI);
	RegisterNotetrackHandlerFunction("attach_knife", &notetrackAttachKnife);
	RegisterNotetrackHandlerFunction("detach_knife", &notetrackDetachKnife);
	RegisterNotetrackHandlerFunction("grenade_throw", &notetrackGrenadeThrow);
	RegisterNotetrackHandlerFunction("start_ragdoll", &notetrackStartRagdoll);
	RegisterNotetrackHandlerFunction("ragdoll_nodeath", &notetrackStartRagdollNoDeath);
	RegisterNotetrackHandlerFunction("unsync", &notetrackMeleeUnsync);
	RegisterNotetrackHandlerFunction("step1", &notetrackStaircaseStep1);
	RegisterNotetrackHandlerFunction("step2", &notetrackStaircaseStep2);
	RegisterNotetrackHandlerFunction("anim_movement = "stop"", &notetrackAnimMovementStop);
	RegisterBlackboardNotetrackHandler("anim_pose = "stand"", "_stance", "stand");
	RegisterBlackboardNotetrackHandler("anim_pose = "crouch"", "_stance", "crouch");
	RegisterBlackboardNotetrackHandler("anim_pose = "prone_front"", "_stance", "prone_front");
	RegisterBlackboardNotetrackHandler("anim_pose = "prone_back"", "_stance", "prone_back");
}

/*
	Name: notetrackAnimMovementStop
	Namespace: AnimationStateNetwork
	Checksum: 0x15562793
	Offset: 0x880
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private notetrackAnimMovementStop(entity)
{
	if(entity HasPath())
	{
		entity PathMode("move delayed", 1, RandomFloatRange(2, 4));
	}
}

/*
	Name: notetrackStaircaseStep1
	Namespace: AnimationStateNetwork
	Checksum: 0xAE971B2D
	Offset: 0x8F0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private notetrackStaircaseStep1(entity)
{
	numSteps = blackboard::GetBlackBoardAttribute(entity, "_staircase_num_steps");
	numSteps++;
	blackboard::SetBlackBoardAttribute(entity, "_staircase_num_steps", numSteps);
}

/*
	Name: notetrackStaircaseStep2
	Namespace: AnimationStateNetwork
	Checksum: 0xC0E3500
	Offset: 0x958
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private notetrackStaircaseStep2(entity)
{
	numSteps = blackboard::GetBlackBoardAttribute(entity, "_staircase_num_steps");
	numSteps = numSteps + 2;
	blackboard::SetBlackBoardAttribute(entity, "_staircase_num_steps", numSteps);
}

/*
	Name: notetrackDropGunInternal
	Namespace: AnimationStateNetwork
	Checksum: 0xBE7E929D
	Offset: 0x9D0
	Size: 0x93
	Parameters: 1
	Flags: Private
*/
function private notetrackDropGunInternal(entity)
{
	if(entity.weapon == level.weaponNone)
	{
		return;
	}
	entity.lastWeapon = entity.weapon;
	primaryWeapon = entity.primaryWeapon;
	secondaryWeapon = entity.secondaryWeapon;
	entity thread shared::DropAIWeapon();
}

/*
	Name: notetrackAttachKnife
	Namespace: AnimationStateNetwork
	Checksum: 0xC300680F
	Offset: 0xA70
	Size: 0x67
	Parameters: 1
	Flags: Private
*/
function private notetrackAttachKnife(entity)
{
	if(!(isdefined(entity._ai_melee_attachedKnife) && entity._ai_melee_attachedKnife))
	{
		entity Attach("t6_wpn_knife_melee", "TAG_WEAPON_LEFT");
		entity._ai_melee_attachedKnife = 1;
	}
}

/*
	Name: notetrackDetachKnife
	Namespace: AnimationStateNetwork
	Checksum: 0xA3BB392A
	Offset: 0xAE0
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private notetrackDetachKnife(entity)
{
	if(isdefined(entity._ai_melee_attachedKnife) && entity._ai_melee_attachedKnife)
	{
		entity Detach("t6_wpn_knife_melee", "TAG_WEAPON_LEFT");
		entity._ai_melee_attachedKnife = 0;
	}
}

/*
	Name: notetrackHideWeapon
	Namespace: AnimationStateNetwork
	Checksum: 0xCA0AADC8
	Offset: 0xB50
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private notetrackHideWeapon(entity)
{
	entity ai::gun_remove();
}

/*
	Name: notetrackShowWeapon
	Namespace: AnimationStateNetwork
	Checksum: 0x2EBCF9DE
	Offset: 0xB80
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private notetrackShowWeapon(entity)
{
	entity ai::gun_recall();
}

/*
	Name: notetrackHideAI
	Namespace: AnimationStateNetwork
	Checksum: 0x2D0CAF1B
	Offset: 0xBB0
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private notetrackHideAI(entity)
{
	entity Hide();
}

/*
	Name: notetrackShowAI
	Namespace: AnimationStateNetwork
	Checksum: 0x6038F3BC
	Offset: 0xBE0
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private notetrackShowAI(entity)
{
	entity show();
}

/*
	Name: notetrackStartRagdoll
	Namespace: AnimationStateNetwork
	Checksum: 0xCC16F3EA
	Offset: 0xC10
	Size: 0xB3
	Parameters: 1
	Flags: Private
*/
function private notetrackStartRagdoll(entity)
{
	if(IsActor(entity) && entity isInScriptedState())
	{
		entity.overrideActorDamage = undefined;
		entity.allowdeath = 1;
		entity.skipdeath = 1;
		entity kill();
	}
	notetrackDropGunInternal(entity);
	entity StartRagdoll();
}

/*
	Name: _DelayedRagdoll
	Namespace: AnimationStateNetwork
	Checksum: 0x210EE748
	Offset: 0xCD0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function _DelayedRagdoll(entity)
{
	wait(0.25);
	if(isdefined(entity) && !entity IsRagdoll())
	{
		entity StartRagdoll();
	}
}

/*
	Name: notetrackStartRagdollNoDeath
	Namespace: AnimationStateNetwork
	Checksum: 0xA7C3B49F
	Offset: 0xD28
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function notetrackStartRagdollNoDeath(entity)
{
	if(isdefined(entity._ai_melee_opponent))
	{
		entity._ai_melee_opponent Unlink();
	}
	entity thread _DelayedRagdoll(entity);
}

/*
	Name: notetrackFireBullet
	Namespace: AnimationStateNetwork
	Checksum: 0x989220D0
	Offset: 0xD88
	Size: 0x103
	Parameters: 1
	Flags: Private
*/
function private notetrackFireBullet(animationEntity)
{
	if(IsActor(animationEntity) && animationEntity isInScriptedState())
	{
		if(animationEntity.weapon != level.weaponNone)
		{
			animationEntity notify("about_to_shoot");
			startPos = animationEntity GetTagOrigin("tag_flash");
			endPos = startPos + VectorScale(animationEntity GetWeaponForwardDir(), 100);
			MagicBullet(animationEntity.weapon, startPos, endPos, animationEntity);
			animationEntity notify("shoot");
			animationEntity.bulletsInClip--;
		}
	}
}

/*
	Name: notetrackDropGun
	Namespace: AnimationStateNetwork
	Checksum: 0x1B2C6E95
	Offset: 0xE98
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private notetrackDropGun(animationEntity)
{
	notetrackDropGunInternal(animationEntity);
}

/*
	Name: notetrackDropShield
	Namespace: AnimationStateNetwork
	Checksum: 0xFDA9364
	Offset: 0xEC8
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private notetrackDropShield(animationEntity)
{
	AiUtility::dropRiotshield(animationEntity);
}

/*
	Name: notetrackGrenadeThrow
	Namespace: AnimationStateNetwork
	Checksum: 0x6729FE6E
	Offset: 0xEF8
	Size: 0xD3
	Parameters: 1
	Flags: Private
*/
function private notetrackGrenadeThrow(animationEntity)
{
	if(archetype_human_cover::shouldThrowGrenadeAtCoverCondition(animationEntity, 1))
	{
		animationEntity GrenadeThrow();
	}
	else if(isdefined(animationEntity.grenadeThrowPosition))
	{
		arm_offset = archetype_human_cover::TEMP_get_arm_offset(animationEntity, animationEntity.grenadeThrowPosition);
		throw_vel = animationEntity CanThrowGrenadePos(arm_offset, animationEntity.grenadeThrowPosition);
		if(isdefined(throw_vel))
		{
			animationEntity GrenadeThrow();
		}
	}
}

/*
	Name: notetrackMeleeUnsync
	Namespace: AnimationStateNetwork
	Checksum: 0x81C1A10B
	Offset: 0xFD8
	Size: 0x73
	Parameters: 1
	Flags: Private
*/
function private notetrackMeleeUnsync(animationEntity)
{
	if(isdefined(animationEntity) && isdefined(animationEntity.enemy))
	{
		if(isdefined(animationEntity.enemy._ai_melee_markedDead) && animationEntity.enemy._ai_melee_markedDead)
		{
			animationEntity Unlink();
		}
	}
}

/*
	Name: notetrackGibDisable
	Namespace: AnimationStateNetwork
	Checksum: 0xE786BE4E
	Offset: 0x1058
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private notetrackGibDisable(animationEntity)
{
	if(animationEntity ai::has_behavior_attribute("can_gib"))
	{
		animationEntity ai::set_behavior_attribute("can_gib", 0);
	}
}

