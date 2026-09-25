#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_zombie_dog_interface;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace ZombieDogBehavior;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: ZombieDogBehavior
	Checksum: 0xA551AFE6
	Offset: 0x3F8
	Size: 0x13B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec RegisterBehaviorScriptFunctions()
{
	spawner::add_archetype_spawn_function("zombie_dog", &ArchetypeZombieDogBlackboardInit);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogTargetService", &zombieDogTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogShouldMelee", &zombieDogShouldMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogShouldWalk", &zombieDogShouldWalk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogShouldRun", &zombieDogShouldRun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieDogMeleeAction", &zombieDogMeleeAction, undefined, &zombieDogMeleeActionTerminate);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("dog_melee", &ZombieBehavior::zombieNotetrackMeleeFire);
	ZombieDogInterface::RegisterZombieDogInterfaceAttributes();
}

/*
	Name: ArchetypeZombieDogBlackboardInit
	Namespace: ZombieDogBehavior
	Checksum: 0x3F2BF9C1
	Offset: 0x540
	Size: 0x1B7
	Parameters: 0
	Flags: None
*/
function ArchetypeZombieDogBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	ai::CreateInterfaceForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_low_gravity", "normal", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_should_run", "walk", &BB_GetShouldRunStatus);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_should_howl", "dont_howl", &BB_GetShouldHowlStatus);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeZombieDogOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
	self.kill_on_wine_coccon = 1;
}

/*
	Name: ArchetypeZombieDogOnAnimscriptedCallback
	Namespace: ZombieDogBehavior
	Checksum: 0xA802FDE6
	Offset: 0x700
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeZombieDogOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeZombieDogBlackboardInit();
}

/*
	Name: BB_GetShouldRunStatus
	Namespace: ZombieDogBehavior
	Checksum: 0xF20CE35D
	Offset: 0x740
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function BB_GetShouldRunStatus()
{
	/#
		if(isdefined(self.isPuppet) && self.isPuppet)
		{
			return "Dev Block strings are not supported";
		}
	#/
	if(isdefined(self.hasSeenFavoriteEnemy) && self.hasSeenFavoriteEnemy || (ai::HasAiAttribute(self, "sprint") && ai::GetAiAttribute(self, "sprint")))
	{
		return "run";
	}
	return "walk";
}

/*
	Name: BB_GetShouldHowlStatus
	Namespace: ZombieDogBehavior
	Checksum: 0x5AE64F5D
	Offset: 0x7D8
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function BB_GetShouldHowlStatus()
{
	if(self ai::has_behavior_attribute("howl_chance") && (isdefined(self.hasSeenFavoriteEnemy) && self.hasSeenFavoriteEnemy))
	{
		if(!isdefined(self.shouldHowl))
		{
			chance = self ai::get_behavior_attribute("howl_chance");
			self.shouldHowl = RandomFloat(1) <= chance;
		}
		if(self.shouldHowl)
		{
			return "howl";
		}
		else
		{
			return "dont_howl";
		}
	}
	return "dont_howl";
}

/*
	Name: GetYaw
	Namespace: ZombieDogBehavior
	Checksum: 0x620981F
	Offset: 0x8A0
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function GetYaw(org)
{
	angles = VectorToAngles(org - self.origin);
	return angles[1];
}

/*
	Name: AbsYawToEnemy
	Namespace: ZombieDogBehavior
	Checksum: 0xD4D00370
	Offset: 0x8F0
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function AbsYawToEnemy()
{
	/#
		Assert(isdefined(self.enemy));
	#/
	yaw = self.angles[1] - GetYaw(self.enemy.origin);
	yaw = AngleClamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: need_to_run
	Namespace: ZombieDogBehavior
	Checksum: 0x51B27044
	Offset: 0x998
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function need_to_run()
{
	run_dist_squared = self ai::get_behavior_attribute("min_run_dist") * self ai::get_behavior_attribute("min_run_dist");
	run_yaw = 20;
	run_pitch = 30;
	run_height = 64;
	if(self.health < self.maxhealth)
	{
		return 1;
	}
	if(!isdefined(self.enemy) || !isalive(self.enemy))
	{
		return 0;
	}
	if(!self cansee(self.enemy))
	{
		return 0;
	}
	dist = DistanceSquared(self.origin, self.enemy.origin);
	if(dist > run_dist_squared)
	{
		return 0;
	}
	height = self.origin[2] - self.enemy.origin[2];
	if(Abs(height) > run_height)
	{
		return 0;
	}
	yaw = self AbsYawToEnemy();
	if(yaw > run_yaw)
	{
		return 0;
	}
	pitch = AngleClamp180(VectorToAngles(self.origin - self.enemy.origin)[0]);
	if(Abs(pitch) > run_pitch)
	{
		return 0;
	}
	return 1;
}

/*
	Name: is_target_valid
	Namespace: ZombieDogBehavior
	Checksum: 0x51D4D9A5
	Offset: 0xBD8
	Size: 0x1EB
	Parameters: 2
	Flags: Private
*/
function private is_target_valid(dog, target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(!dog.team == "allies")
	{
		if(!isPlayer(target) && SessionModeIsZombiesGame())
		{
			return 0;
		}
		if(isdefined(target.is_zombie) && target.is_zombie == 1)
		{
			return 0;
		}
	}
	if(isPlayer(target) && target.sessionstate == "spectator")
	{
		return 0;
	}
	if(isPlayer(target) && target.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		return 0;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return 0;
	}
	if(target IsNoTarget())
	{
		return 0;
	}
	if(dog.team == target.team)
	{
		return 0;
	}
	if(isPlayer(target) && isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](target);
	}
	return 1;
}

/*
	Name: get_favorite_enemy
	Namespace: ZombieDogBehavior
	Checksum: 0x58636A97
	Offset: 0xDD0
	Size: 0x26D
	Parameters: 1
	Flags: Private
*/
function private get_favorite_enemy(dog)
{
	dog_targets = [];
	if(SessionModeIsZombiesGame())
	{
		if(self.team == "allies")
		{
			dog_targets = GetAITeamArray(level.zombie_team);
		}
		else
		{
			dog_targets = GetPlayers();
		}
	}
	else
	{
		dog_targets = ArrayCombine(GetPlayers(), GetAIArray(), 0, 0);
	}
	least_hunted = dog_targets[0];
	closest_target_dist_squared = undefined;
	for(i = 0; i < dog_targets.size; i++)
	{
		if(!isdefined(dog_targets[i].hunted_by))
		{
			dog_targets[i].hunted_by = 0;
		}
		if(!is_target_valid(dog, dog_targets[i]))
		{
			continue;
		}
		if(!is_target_valid(dog, least_hunted))
		{
			least_hunted = dog_targets[i];
		}
		dist_squared = DistanceSquared(dog.origin, dog_targets[i].origin);
		if(dog_targets[i].hunted_by <= least_hunted.hunted_by && (!isdefined(closest_target_dist_squared) || dist_squared < closest_target_dist_squared))
		{
			least_hunted = dog_targets[i];
			closest_target_dist_squared = dist_squared;
		}
	}
	if(!is_target_valid(dog, least_hunted))
	{
		return undefined;
	}
	else
	{
		least_hunted.hunted_by = least_hunted.hunted_by + 1;
		return least_hunted;
	}
}

/*
	Name: get_last_valid_position
	Namespace: ZombieDogBehavior
	Checksum: 0xF80434A
	Offset: 0x1048
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function get_last_valid_position()
{
	if(isPlayer(self))
	{
		return self.last_valid_position;
	}
	return self.origin;
}

/*
	Name: get_locomotion_target
	Namespace: ZombieDogBehavior
	Checksum: 0xE0F97C6E
	Offset: 0x1080
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function get_locomotion_target(behaviorTreeEntity)
{
	last_valid_position = behaviorTreeEntity.favoriteenemy get_last_valid_position();
	if(!isdefined(last_valid_position))
	{
		return undefined;
	}
	locomotion_target = last_valid_position;
	if(ai::has_behavior_attribute("spacing_value"))
	{
		spacing_near_dist = ai::get_behavior_attribute("spacing_near_dist");
		spacing_far_dist = ai::get_behavior_attribute("spacing_far_dist");
		spacing_horz_dist = ai::get_behavior_attribute("spacing_horz_dist");
		spacing_value = ai::get_behavior_attribute("spacing_value");
		to_enemy = behaviorTreeEntity.favoriteenemy.origin - behaviorTreeEntity.origin;
		perp = VectorNormalize((to_enemy[1] * -1, to_enemy[0], 0));
		offset = perp * spacing_horz_dist * spacing_value;
		spacing_dist = math::clamp(length(to_enemy), spacing_near_dist, spacing_far_dist);
		lerp_amount = math::clamp(spacing_dist - spacing_near_dist / spacing_far_dist - spacing_near_dist, 0, 1);
		desired_point = last_valid_position + offset * lerp_amount;
		desired_point = GetClosestPointOnNavMesh(desired_point, spacing_horz_dist * 1.2, 16);
		if(isdefined(desired_point))
		{
			locomotion_target = desired_point;
		}
	}
	return locomotion_target;
}

/*
	Name: zombieDogTargetService
	Namespace: ZombieDogBehavior
	Checksum: 0xAE29F58E
	Offset: 0x1308
	Size: 0x3BF
	Parameters: 1
	Flags: None
*/
function zombieDogTargetService(behaviorTreeEntity)
{
	if(isdefined(level.intermission) && level.intermission)
	{
		behaviorTreeEntity clearPath();
		return;
	}
	/#
		if(isdefined(behaviorTreeEntity.isPuppet) && behaviorTreeEntity.isPuppet)
		{
			return;
		}
	#/
	if(behaviorTreeEntity.ignoreall || behaviorTreeEntity.pacifist || (isdefined(behaviorTreeEntity.favoriteenemy) && !is_target_valid(behaviorTreeEntity, behaviorTreeEntity.favoriteenemy)))
	{
		if(isdefined(behaviorTreeEntity.favoriteenemy) && isdefined(behaviorTreeEntity.favoriteenemy.hunted_by) && behaviorTreeEntity.favoriteenemy.hunted_by > 0)
		{
			behaviorTreeEntity.favoriteenemy.hunted_by--;
		}
		behaviorTreeEntity.favoriteenemy = undefined;
		behaviorTreeEntity.hasSeenFavoriteEnemy = 0;
		if(!behaviorTreeEntity.ignoreall)
		{
			behaviorTreeEntity SetGoal(behaviorTreeEntity.origin);
		}
		return;
	}
	if(isdefined(behaviorTreeEntity.ignoreme) && behaviorTreeEntity.ignoreme)
	{
		return;
	}
	if(!SessionModeIsZombiesGame() || behaviorTreeEntity.team == "allies" && !is_target_valid(behaviorTreeEntity, behaviorTreeEntity.favoriteenemy))
	{
		behaviorTreeEntity.favoriteenemy = get_favorite_enemy(behaviorTreeEntity);
	}
	if(!(isdefined(behaviorTreeEntity.hasSeenFavoriteEnemy) && behaviorTreeEntity.hasSeenFavoriteEnemy))
	{
		if(isdefined(behaviorTreeEntity.favoriteenemy) && behaviorTreeEntity need_to_run())
		{
			behaviorTreeEntity.hasSeenFavoriteEnemy = 1;
		}
	}
	if(isdefined(behaviorTreeEntity.favoriteenemy))
	{
		if(isdefined(level.enemy_location_override_func))
		{
			goalpos = [[level.enemy_location_override_func]](behaviorTreeEntity, behaviorTreeEntity.favoriteenemy);
			if(isdefined(goalpos))
			{
				behaviorTreeEntity SetGoal(goalpos);
				return;
			}
		}
		locomotion_target = get_locomotion_target(behaviorTreeEntity);
		if(isdefined(locomotion_target))
		{
			repathDist = 16;
			if(!isdefined(behaviorTreeEntity.lastTargetPosition) || DistanceSquared(behaviorTreeEntity.lastTargetPosition, locomotion_target) > repathDist * repathDist || !behaviorTreeEntity HasPath())
			{
				behaviorTreeEntity UsePosition(locomotion_target);
				behaviorTreeEntity.lastTargetPosition = locomotion_target;
			}
		}
	}
}

/*
	Name: zombieDogShouldMelee
	Namespace: ZombieDogBehavior
	Checksum: 0x8C4C8C99
	Offset: 0x16D0
	Size: 0x1E7
	Parameters: 1
	Flags: None
*/
function zombieDogShouldMelee(behaviorTreeEntity)
{
	if(behaviorTreeEntity.ignoreall || !is_target_valid(behaviorTreeEntity, behaviorTreeEntity.favoriteenemy))
	{
		return 0;
	}
	if(!(isdefined(level.intermission) && level.intermission))
	{
		meleeDist = 72;
		if(DistanceSquared(behaviorTreeEntity.origin, behaviorTreeEntity.favoriteenemy.origin) < meleeDist * meleeDist && behaviorTreeEntity cansee(behaviorTreeEntity.favoriteenemy))
		{
			dog_eye = behaviorTreeEntity.origin + VectorScale((0, 0, 1), 40);
			enemy_eye = behaviorTreeEntity.favoriteenemy GetEye();
			clip_mask = 1 | 8;
			trace = PhysicsTrace(dog_eye, enemy_eye, (0, 0, 0), (0, 0, 0), self, clip_mask);
			can_melee = trace["fraction"] == 1 || (isdefined(trace["entity"]) && trace["entity"] == behaviorTreeEntity.favoriteenemy);
			if(isdefined(can_melee) && can_melee)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: zombieDogShouldWalk
	Namespace: ZombieDogBehavior
	Checksum: 0x3B6EAC05
	Offset: 0x18C0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function zombieDogShouldWalk(behaviorTreeEntity)
{
	return BB_GetShouldRunStatus() == "walk";
}

/*
	Name: zombieDogShouldRun
	Namespace: ZombieDogBehavior
	Checksum: 0xA7BA0B7B
	Offset: 0x18F0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function zombieDogShouldRun(behaviorTreeEntity)
{
	return BB_GetShouldRunStatus() == "run";
}

/*
	Name: use_low_attack
	Namespace: ZombieDogBehavior
	Checksum: 0x515F4316
	Offset: 0x1920
	Size: 0x165
	Parameters: 0
	Flags: None
*/
function use_low_attack()
{
	if(!isdefined(self.enemy) || !isPlayer(self.enemy))
	{
		return 0;
	}
	height_diff = self.enemy.origin[2] - self.origin[2];
	low_enough = 30;
	if(height_diff < low_enough && self.enemy GetStance() == "prone")
	{
		return 1;
	}
	melee_origin = (self.origin[0], self.origin[1], self.origin[2] + 65);
	enemy_origin = (self.enemy.origin[0], self.enemy.origin[1], self.enemy.origin[2] + 32);
	if(!BulletTracePassed(melee_origin, enemy_origin, 0, self))
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombieDogMeleeAction
	Namespace: ZombieDogBehavior
	Checksum: 0xC19E23DD
	Offset: 0x1A90
	Size: 0x9F
	Parameters: 2
	Flags: None
*/
function zombieDogMeleeAction(behaviorTreeEntity, asmStateName)
{
	behaviorTreeEntity clearPath();
	context = "high";
	if(behaviorTreeEntity use_low_attack())
	{
		context = "low";
	}
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_context", context);
	AnimationStateNetworkUtility::RequestState(behaviorTreeEntity, asmStateName);
	return 5;
}

/*
	Name: zombieDogMeleeActionTerminate
	Namespace: ZombieDogBehavior
	Checksum: 0xE2F947DC
	Offset: 0x1B38
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function zombieDogMeleeActionTerminate(behaviorTreeEntity, asmStateName)
{
	blackboard::SetBlackBoardAttribute(behaviorTreeEntity, "_context", undefined);
	return 4;
}

/*
	Name: zombieDogGravity
	Namespace: ZombieDogBehavior
	Checksum: 0x217E011F
	Offset: 0x1B78
	Size: 0x43
	Parameters: 4
	Flags: None
*/
function zombieDogGravity(entity, attribute, oldValue, value)
{
	blackboard::SetBlackBoardAttribute(entity, "_low_gravity", value);
}

