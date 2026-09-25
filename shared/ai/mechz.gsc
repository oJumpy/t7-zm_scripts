#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace MechzBehavior;

/*
	Name: init
	Namespace: MechzBehavior
	Checksum: 0xA241E276
	Offset: 0xAB8
	Size: 0x273
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitMechzBehaviorsAndASM();
	spawner::add_archetype_spawn_function("mechz", &ArchetypeMechzBlackboardInit);
	spawner::add_archetype_spawn_function("mechz", &MechzServerUtils::mechzSpawnSetup);
	clientfield::register("actor", "mechz_ft", 5000, 1, "int");
	clientfield::register("actor", "mechz_faceplate_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_powercap_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_claw_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_115_gun_firing", 5000, 1, "int");
	clientfield::register("actor", "mechz_rknee_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_lknee_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_rshoulder_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_lshoulder_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_headlamp_off", 5000, 2, "int");
	clientfield::register("actor", "mechz_face", 1, 3, "int");
}

/*
	Name: InitMechzBehaviorsAndASM
	Namespace: MechzBehavior
	Checksum: 0x33D94F30
	Offset: 0xD38
	Size: 0x473
	Parameters: 0
	Flags: Private
*/
function private InitMechzBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzTargetService", &mechzTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzGrenadeService", &mechzGrenadeService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzBerserkKnockdownService", &mechzBerserkKnockdownService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldMelee", &mechzShouldMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldShowPain", &mechzShouldShowPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldShootGrenade", &mechzShouldShootGrenade);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldShootFlame", &mechzShouldShootFlame);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldShootFlameSweep", &mechzShouldShootFlameSweep);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldTurnBerserk", &mechzShouldTurnBerserk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldStun", &mechzShouldStun);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShouldStumble", &mechzShouldStumble);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("mechzStunLoop", &mechzStunStart, &mechzStunUpdate, &mechzStunEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("mechzStumbleLoop", &mechzStumbleStart, &mechzStumbleUpdate, &mechzStumbleEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("mechzShootFlameAction", &mechzShootFlameActionStart, &mechzShootFlameActionUpdate, &mechzShootFlameActionEnd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShootGrenade", &mechzShootGrenade);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzShootFlame", &mechzShootFlame);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzUpdateFlame", &mechzUpdateFlame);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzStopFlame", &mechzStopFlame);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzPlayedBerserkIntro", &mechzPlayedBerserkIntro);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzAttackStart", &mechzAttackStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzDeathStart", &mechzDeathStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzIdleStart", &mechzIdleStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzPainStart", &mechzPainStart);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mechzPainTerminate", &mechzPainTerminate);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("melee_soldat", &mechzNotetrackMelee);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("fire_chaingun", &mechzNotetrackShootGrenade);
}

/*
	Name: ArchetypeMechzBlackboardInit
	Namespace: MechzBehavior
	Checksum: 0xC5E372B0
	Offset: 0x11B8
	Size: 0x1EB
	Parameters: 0
	Flags: Private
*/
function private ArchetypeMechzBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_should_turn", "should_not_turn", &BB_GetShouldTurn);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_zombie_damageweapon_type", "regular", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_mechz_part", "mechz_powercore", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeMechzOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeMechzOnAnimscriptedCallback
	Namespace: MechzBehavior
	Checksum: 0xFDB8D738
	Offset: 0x13B0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeMechzOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeMechzBlackboardInit();
}

/*
	Name: BB_GetShouldTurn
	Namespace: MechzBehavior
	Checksum: 0x9C03DEA5
	Offset: 0x13F0
	Size: 0x29
	Parameters: 0
	Flags: Private
*/
function private BB_GetShouldTurn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: mechzNotetrackMelee
	Namespace: MechzBehavior
	Checksum: 0xC5D808E
	Offset: 0x1428
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private mechzNotetrackMelee(entity)
{
	if(isdefined(entity.mechz_melee_knockdown_function))
	{
		entity thread [[entity.mechz_melee_knockdown_function]]();
	}
	entity melee();
}

/*
	Name: mechzNotetrackShootGrenade
	Namespace: MechzBehavior
	Checksum: 0x86A65D17
	Offset: 0x1480
	Size: 0x2CB
	Parameters: 1
	Flags: Private
*/
function private mechzNotetrackShootGrenade(entity)
{
	if(!isdefined(entity.enemy))
	{
		return;
	}
	base_target_pos = entity.enemy.origin;
	v_velocity = entity.enemy GetVelocity();
	base_target_pos = base_target_pos + v_velocity * 1.5;
	target_pos_offset_x = math::randomSign() * RandomInt(32);
	target_pos_offset_y = math::randomSign() * RandomInt(32);
	target_pos = base_target_pos + (target_pos_offset_x, target_pos_offset_y, 0);
	dir = VectorToAngles(target_pos - entity.origin);
	dir = AnglesToForward(dir);
	launch_offset = dir * 5;
	launch_pos = entity GetTagOrigin("tag_gun_barrel2") + launch_offset;
	dist = Distance(launch_pos, target_pos);
	velocity = dir * dist;
	velocity = velocity + VectorScale((0, 0, 1), 120);
	VAL = 1;
	oldVal = entity clientfield::get("mechz_115_gun_firing");
	if(oldVal === VAL)
	{
		VAL = 0;
	}
	entity clientfield::set("mechz_115_gun_firing", VAL);
	entity MagicGrenadeType(GetWeapon("electroball_grenade"), launch_pos, velocity);
	playsoundatposition("wpn_grenade_fire_mechz", entity.origin);
}

/*
	Name: mechzTargetService
	Namespace: MechzBehavior
	Checksum: 0xEBF0C8F6
	Offset: 0x1758
	Size: 0x267
	Parameters: 1
	Flags: None
*/
function mechzTargetService(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
	entity.favoriteenemy = player;
	if(!isdefined(player) || player IsNoTarget())
	{
		if(isdefined(entity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			entity.ignore_player = [];
		}
		/#
			if(isdefined(level.b_mechz_true_ignore) && level.b_mechz_true_ignore)
			{
				entity SetGoal(entity.origin);
				return 0;
			}
		#/
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](entity);
		}
		else
		{
			entity SetGoal(entity.origin);
		}
		return 0;
	}
	else if(isdefined(level.enemy_location_override_func))
	{
		enemy_ground_pos = [[level.enemy_location_override_func]](entity, player);
		if(isdefined(enemy_ground_pos))
		{
			entity SetGoal(enemy_ground_pos);
			return 1;
		}
	}
	targetPos = GetClosestPointOnNavMesh(player.origin, 64, 30);
	if(isdefined(targetPos))
	{
		entity SetGoal(targetPos);
		return 1;
	}
	else
	{
		entity SetGoal(entity.origin);
		return 0;
	}
}

/*
	Name: mechzGrenadeService
	Namespace: MechzBehavior
	Checksum: 0x9D66E638
	Offset: 0x19C8
	Size: 0xFF
	Parameters: 1
	Flags: Private
*/
function private mechzGrenadeService(entity)
{
	if(!isdefined(entity.burstGrenadesFired))
	{
		entity.burstGrenadesFired = 0;
	}
	if(entity.burstGrenadesFired >= 3)
	{
		if(GetTime() > entity.nextGrenadeTime)
		{
			entity.burstGrenadesFired = 0;
		}
	}
	if(isdefined(level.a_electroball_grenades))
	{
		level.a_electroball_grenades = Array::remove_undefined(level.a_electroball_grenades);
		a_active_grenades = Array::filter(level.a_electroball_grenades, 0, &mechzFilterGrenadesByOwner, entity);
		entity.activeGrenades = a_active_grenades.size;
	}
	else
	{
		entity.activeGrenades = 0;
	}
}

/*
	Name: mechzFilterGrenadesByOwner
	Namespace: MechzBehavior
	Checksum: 0x8F624B3F
	Offset: 0x1AD0
	Size: 0x33
	Parameters: 2
	Flags: Private
*/
function private mechzFilterGrenadesByOwner(grenade, mechz)
{
	if(grenade.owner === mechz)
	{
		return 1;
	}
	return 0;
}

/*
	Name: mechzBerserkKnockdownService
	Namespace: MechzBehavior
	Checksum: 0xC5D2D7A5
	Offset: 0x1B10
	Size: 0x439
	Parameters: 1
	Flags: Private
*/
function private mechzBerserkKnockdownService(entity)
{
	velocity = entity GetVelocity();
	predict_time = 0.3;
	predicted_pos = entity.origin + velocity * predict_time;
	move_dist_sq = DistanceSquared(predicted_pos, entity.origin);
	speed = move_dist_sq / predict_time;
	if(speed >= 10)
	{
		a_zombies = GetAIArchetypeArray("zombie");
		a_filtered_zombies = Array::filter(a_zombies, 0, &mechzZombieEligibleForBerserkKnockdown, entity, predicted_pos);
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				zombie.KNOCKDOWN = 1;
				zombie.knockdown_type = "knockdown_shoved";
				zombie_to_mechz = entity.origin - zombie.origin;
				zombie_to_mechz_2d = VectorNormalize((zombie_to_mechz[0], zombie_to_mechz[1], 0));
				zombie_forward = AnglesToForward(zombie.angles);
				zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
				zombie_right = AnglesToRight(zombie.angles);
				zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
				dot = VectorDot(zombie_to_mechz_2d, zombie_forward_2d);
				if(dot >= 0.5)
				{
					zombie.knockdown_direction = "front";
					zombie.getup_direction = "getup_back";
					continue;
				}
				if(dot < 0.5 && dot > -0.5)
				{
					dot = VectorDot(zombie_to_mechz_2d, zombie_right_2d);
					if(dot > 0)
					{
						zombie.knockdown_direction = "right";
						if(math::cointoss())
						{
							zombie.getup_direction = "getup_back";
						}
						else
						{
							zombie.getup_direction = "getup_belly";
						}
					}
					else
					{
						zombie.knockdown_direction = "left";
						zombie.getup_direction = "getup_belly";
					}
					continue;
				}
				zombie.knockdown_direction = "back";
				zombie.getup_direction = "getup_belly";
			}
		}
	}
}

/*
	Name: mechzZombieEligibleForBerserkKnockdown
	Namespace: MechzBehavior
	Checksum: 0x27164013
	Offset: 0x1F58
	Size: 0x1C3
	Parameters: 3
	Flags: Private
*/
function private mechzZombieEligibleForBerserkKnockdown(zombie, mechz, predicted_pos)
{
	if(zombie.KNOCKDOWN === 1)
	{
		return 0;
	}
	knockdown_dist_sq = 2304;
	dist_sq = DistanceSquared(predicted_pos, zombie.origin);
	if(dist_sq > knockdown_dist_sq)
	{
		return 0;
	}
	if(zombie.is_immune_to_knockdown === 1)
	{
		return 0;
	}
	origin = mechz.origin;
	facing_vec = AnglesToForward(mechz.angles);
	enemy_vec = zombie.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechzShouldMelee
	Namespace: MechzBehavior
	Checksum: 0x68ED31
	Offset: 0x2128
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function mechzShouldMelee(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.enemy.origin) > 12544)
	{
		return 0;
	}
	if(isdefined(entity.enemy.usingvehicle) && entity.enemy.usingvehicle)
	{
		return 1;
	}
	yaw = Abs(zombie_utility::getYawToEnemy());
	if(yaw > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechzShouldShowPain
	Namespace: MechzBehavior
	Checksum: 0x4653E3C0
	Offset: 0x2218
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private mechzShouldShowPain(entity)
{
	if(entity.partDestroyed === 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: mechzShouldShootGrenade
	Namespace: MechzBehavior
	Checksum: 0x47A72C52
	Offset: 0x2250
	Size: 0x13F
	Parameters: 1
	Flags: Private
*/
function private mechzShouldShootGrenade(entity)
{
	if(entity.Berserk === 1)
	{
		return 0;
	}
	if(entity.gun_attached !== 1)
	{
		return 0;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return 0;
	}
	if(entity.burstGrenadesFired >= 3)
	{
		return 0;
	}
	if(entity.activeGrenades >= 9)
	{
		return 0;
	}
	if(!entity MechzServerUtils::mechzGrenadeCheckInArc())
	{
		return 0;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return 0;
	}
	dist_sq = DistanceSquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 62500 || dist_sq > 1440000)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechzShouldShootFlame
	Namespace: MechzBehavior
	Checksum: 0xBBE24C5D
	Offset: 0x2398
	Size: 0x1F7
	Parameters: 1
	Flags: Private
*/
function private mechzShouldShootFlame(entity)
{
	/#
		if(isdefined(entity.shoot_flame) && entity.shoot_flame)
		{
			return 1;
		}
	#/
	if(entity.Berserk === 1)
	{
		return 0;
	}
	if(isdefined(entity.isShootingFlame) && entity.isShootingFlame && GetTime() < entity.stopShootingFlameTime)
	{
		return 1;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return 0;
	}
	if(entity.isShootingFlame === 1 && entity.stopShootingFlameTime <= GetTime())
	{
		return 0;
	}
	if(entity.nextFlameTime > GetTime())
	{
		return 0;
	}
	if(!entity MechzServerUtils::mechzCheckInArc(26, "tag_flamethrower_fx"))
	{
		return 0;
	}
	dist_sq = DistanceSquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 9216 || dist_sq > 50625)
	{
		return 0;
	}
	can_see = BulletTracePassed(entity.origin + VectorScale((0, 0, 1), 36), entity.favoriteenemy.origin + VectorScale((0, 0, 1), 36), 0, undefined);
	if(!can_see)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechzShouldShootFlameSweep
	Namespace: MechzBehavior
	Checksum: 0x4DFB1D87
	Offset: 0x2598
	Size: 0x155
	Parameters: 1
	Flags: Private
*/
function private mechzShouldShootFlameSweep(entity)
{
	if(entity.Berserk === 1)
	{
		return 0;
	}
	if(!mechzShouldShootFlame(entity))
	{
		return 0;
	}
	if(RandomInt(100) > 10)
	{
		return 0;
	}
	near_players = 0;
	players = GetPlayers();
	foreach(player in players)
	{
		if(Distance2DSquared(entity.origin, player.origin) < 10000)
		{
			near_players++;
		}
	}
	if(near_players < 2)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechzShouldTurnBerserk
	Namespace: MechzBehavior
	Checksum: 0xE898D1A1
	Offset: 0x26F8
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private mechzShouldTurnBerserk(entity)
{
	if(entity.Berserk === 1 && entity.hasTurnedBerserk !== 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: mechzShouldStun
	Namespace: MechzBehavior
	Checksum: 0x86F0F149
	Offset: 0x2748
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private mechzShouldStun(entity)
{
	if(isdefined(entity.stun) && entity.stun)
	{
		return 1;
	}
	return 0;
}

/*
	Name: mechzShouldStumble
	Namespace: MechzBehavior
	Checksum: 0x1A2651E1
	Offset: 0x2790
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private mechzShouldStumble(entity)
{
	if(isdefined(entity.stumble) && entity.stumble)
	{
		return 1;
	}
	return 0;
}

/*
	Name: mechzShootGrenadeAction
	Namespace: MechzBehavior
	Checksum: 0x548BD0BD
	Offset: 0x27D8
	Size: 0x47
	Parameters: 2
	Flags: Private
*/
function private mechzShootGrenadeAction(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	entity.grenadeStartTime = GetTime() + 3000;
	return 5;
}

/*
	Name: mechzShootGrenadeActionUpdate
	Namespace: MechzBehavior
	Checksum: 0x2673E98C
	Offset: 0x2828
	Size: 0x43
	Parameters: 2
	Flags: Private
*/
function private mechzShootGrenadeActionUpdate(entity, asmStateName)
{
	if(!(isdefined(entity.shoot_grenade) && entity.shoot_grenade))
	{
		return 4;
	}
	return 5;
}

/*
	Name: mechzStunStart
	Namespace: MechzBehavior
	Checksum: 0x2F1A8BD6
	Offset: 0x2878
	Size: 0x47
	Parameters: 2
	Flags: Private
*/
function private mechzStunStart(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	entity.stunTime = GetTime() + 500;
	return 5;
}

/*
	Name: mechzStunUpdate
	Namespace: MechzBehavior
	Checksum: 0x35F1D3CA
	Offset: 0x28C8
	Size: 0x31
	Parameters: 2
	Flags: Private
*/
function private mechzStunUpdate(entity, asmStateName)
{
	if(GetTime() > entity.stunTime)
	{
		return 4;
	}
	return 5;
}

/*
	Name: mechzStunEnd
	Namespace: MechzBehavior
	Checksum: 0x7FEA3D7B
	Offset: 0x2908
	Size: 0x3F
	Parameters: 2
	Flags: Private
*/
function private mechzStunEnd(entity, asmStateName)
{
	entity.stun = 0;
	entity.stumble_stun_cooldown_time = GetTime() + 10000;
	return 4;
}

/*
	Name: mechzStumbleStart
	Namespace: MechzBehavior
	Checksum: 0x4DBCB46B
	Offset: 0x2950
	Size: 0x47
	Parameters: 2
	Flags: Private
*/
function private mechzStumbleStart(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	entity.stumbleTime = GetTime() + 500;
	return 5;
}

/*
	Name: mechzStumbleUpdate
	Namespace: MechzBehavior
	Checksum: 0x5747D9B9
	Offset: 0x29A0
	Size: 0x31
	Parameters: 2
	Flags: Private
*/
function private mechzStumbleUpdate(entity, asmStateName)
{
	if(GetTime() > entity.stumbleTime)
	{
		return 4;
	}
	return 5;
}

/*
	Name: mechzStumbleEnd
	Namespace: MechzBehavior
	Checksum: 0xF708103C
	Offset: 0x29E0
	Size: 0x3F
	Parameters: 2
	Flags: Private
*/
function private mechzStumbleEnd(entity, asmStateName)
{
	entity.stumble = 0;
	entity.stumble_stun_cooldown_time = GetTime() + 10000;
	return 4;
}

/*
	Name: mechzShootFlameActionStart
	Namespace: MechzBehavior
	Checksum: 0x883DD19F
	Offset: 0x2A28
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function mechzShootFlameActionStart(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	mechzShootFlame(entity);
	return 5;
}

/*
	Name: mechzShootFlameActionUpdate
	Namespace: MechzBehavior
	Checksum: 0x88E62F42
	Offset: 0x2A78
	Size: 0x12F
	Parameters: 2
	Flags: None
*/
function mechzShootFlameActionUpdate(entity, asmStateName)
{
	if(isdefined(entity.Berserk) && entity.Berserk)
	{
		mechzStopFlame(entity);
		return 4;
	}
	if(isdefined(mechzShouldMelee(entity)) && mechzShouldMelee(entity))
	{
		mechzStopFlame(entity);
		return 4;
	}
	if(isdefined(entity.isShootingFlame) && entity.isShootingFlame)
	{
		if(isdefined(entity.stopShootingFlameTime) && GetTime() > entity.stopShootingFlameTime)
		{
			mechzStopFlame(entity);
			return 4;
		}
		mechzUpdateFlame(entity);
	}
	return 5;
}

/*
	Name: mechzShootFlameActionEnd
	Namespace: MechzBehavior
	Checksum: 0x985A6238
	Offset: 0x2BB0
	Size: 0x2F
	Parameters: 2
	Flags: None
*/
function mechzShootFlameActionEnd(entity, asmStateName)
{
	mechzStopFlame(entity);
	return 4;
}

/*
	Name: mechzShootGrenade
	Namespace: MechzBehavior
	Checksum: 0x52640D37
	Offset: 0x2BE8
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private mechzShootGrenade(entity)
{
	entity.burstGrenadesFired++;
	if(entity.burstGrenadesFired >= 3)
	{
		entity.nextGrenadeTime = GetTime() + 6000;
	}
}

/*
	Name: mechzShootFlame
	Namespace: MechzBehavior
	Checksum: 0x3F71CAA2
	Offset: 0x2C40
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private mechzShootFlame(entity)
{
	entity thread mechzDelayFlame();
}

/*
	Name: mechzDelayFlame
	Namespace: MechzBehavior
	Checksum: 0x4D59C986
	Offset: 0x2C70
	Size: 0x6F
	Parameters: 0
	Flags: Private
*/
function private mechzDelayFlame()
{
	self endon("death");
	self notify("mechzDelayFlame");
	self endon("mechzDelayFlame");
	wait(0.3);
	self clientfield::set("mechz_ft", 1);
	self.isShootingFlame = 1;
	self.stopShootingFlameTime = GetTime() + 2500;
}

/*
	Name: mechzUpdateFlame
	Namespace: MechzBehavior
	Checksum: 0x9828CF1D
	Offset: 0x2CE8
	Size: 0x173
	Parameters: 1
	Flags: Private
*/
function private mechzUpdateFlame(entity)
{
	if(isdefined(level.mechz_flamethrower_player_callback))
	{
		[[level.mechz_flamethrower_player_callback]](entity);
		break;
	}
	players = GetPlayers();
	foreach(player in players)
	{
		if(!(isdefined(player.is_burning) && player.is_burning))
		{
			if(player istouching(entity.flameTrigger))
			{
				if(isdefined(entity.mechzFlameDamage))
				{
					player thread [[entity.mechzFlameDamage]]();
					continue;
				}
				player thread playerFlameDamage(entity);
			}
		}
	}
	if(isdefined(level.mechz_flamethrower_ai_callback))
	{
		[[level.mechz_flamethrower_ai_callback]](entity);
	}
}

/*
	Name: playerFlameDamage
	Namespace: MechzBehavior
	Checksum: 0xC331EB5D
	Offset: 0x2E68
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function playerFlameDamage(mechz)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.is_burning) && self.is_burning && zombie_utility::is_player_valid(self, 1))
	{
		self.is_burning = 1;
		if(!self hasPerk("specialty_armorvest"))
		{
			self burnplayer::SetPlayerBurning(1.5, 0.5, 30, mechz, undefined);
		}
		else
		{
			self burnplayer::SetPlayerBurning(1.5, 0.5, 20, mechz, undefined);
		}
		wait(1.5);
		self.is_burning = 0;
	}
}

/*
	Name: mechzStopFlame
	Namespace: MechzBehavior
	Checksum: 0xA9CAD245
	Offset: 0x2F68
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function mechzStopFlame(entity)
{
	self notify("mechzDelayFlame");
	entity clientfield::set("mechz_ft", 0);
	entity.isShootingFlame = 0;
	entity.nextFlameTime = GetTime() + 7500;
	entity.stopShootingFlameTime = undefined;
}

/*
	Name: mechzGoBerserk
	Namespace: MechzBehavior
	Checksum: 0xDD71AC10
	Offset: 0x2FE8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function mechzGoBerserk()
{
	entity = self;
	g_time = GetTime();
	entity.berserkEndTime = g_time + 10000;
	if(entity.Berserk !== 1)
	{
		entity.Berserk = 1;
		entity thread mechzEndBerserk();
		blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

/*
	Name: mechzPlayedBerserkIntro
	Namespace: MechzBehavior
	Checksum: 0x3BF96614
	Offset: 0x3098
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private mechzPlayedBerserkIntro(entity)
{
	entity.hasTurnedBerserk = 1;
}

/*
	Name: mechzEndBerserk
	Namespace: MechzBehavior
	Checksum: 0x2A1E43B4
	Offset: 0x30C0
	Size: 0xA7
	Parameters: 0
	Flags: Private
*/
function private mechzEndBerserk()
{
	self endon("death");
	self endon("disconnect");
	while(self.Berserk === 1)
	{
		if(GetTime() >= self.berserkEndTime)
		{
			self.Berserk = 0;
			self.hasTurnedBerserk = 0;
			self ASMSetAnimationRate(1);
			blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run");
		}
		wait(0.25);
	}
}

/*
	Name: mechzAttackStart
	Namespace: MechzBehavior
	Checksum: 0x660F1FB7
	Offset: 0x3170
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private mechzAttackStart(entity)
{
	entity clientfield::set("mechz_face", 1);
}

/*
	Name: mechzDeathStart
	Namespace: MechzBehavior
	Checksum: 0x4C604890
	Offset: 0x31A8
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private mechzDeathStart(entity)
{
	entity clientfield::set("mechz_face", 2);
}

/*
	Name: mechzIdleStart
	Namespace: MechzBehavior
	Checksum: 0x6631C3C4
	Offset: 0x31E0
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private mechzIdleStart(entity)
{
	entity clientfield::set("mechz_face", 3);
}

/*
	Name: mechzPainStart
	Namespace: MechzBehavior
	Checksum: 0xF4F64D0D
	Offset: 0x3218
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private mechzPainStart(entity)
{
	entity clientfield::set("mechz_face", 4);
}

/*
	Name: mechzPainTerminate
	Namespace: MechzBehavior
	Checksum: 0xB2D5B22A
	Offset: 0x3250
	Size: 0x29
	Parameters: 1
	Flags: Private
*/
function private mechzPainTerminate(entity)
{
	entity.partDestroyed = 0;
	entity.show_pain_from_explosive_dmg = undefined;
}

#namespace MechzServerUtils;

/*
	Name: mechzSpawnSetup
	Namespace: MechzServerUtils
	Checksum: 0x83D7AB87
	Offset: 0x3288
	Size: 0x1F1
	Parameters: 0
	Flags: Private
*/
function private mechzSpawnSetup()
{
	self DisableAimAssist();
	self.disableAmmoDrop = 1;
	self.no_gib = 1;
	self.ignore_nuke = 1;
	self.ignore_enemy_count = 1;
	self.ignore_round_robbin_death = 1;
	self.zombie_move_speed = "run";
	blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run");
	self.ignorerunAndgundist = 1;
	self mechzAddAttachments();
	self.grenadeCount = 9;
	self.nextFlameTime = GetTime();
	self.stumble_stun_cooldown_time = GetTime();
	/#
		self.debug_traversal_ast = "Dev Block strings are not supported";
	#/
	self.flameTrigger = spawn("trigger_box", self.origin, 0, 200, 50, 25);
	self.flameTrigger EnableLinkTo();
	self.flameTrigger.origin = self GetTagOrigin("tag_flamethrower_fx");
	self.flameTrigger.angles = self GetTagAngles("tag_flamethrower_fx");
	self.flameTrigger LinkTo(self, "tag_flamethrower_fx");
	self thread weaponobjects::watchWeaponObjectUsage();
	self.pers = [];
	self.pers["team"] = self.team;
}

/*
	Name: mechzFlameWatcher
	Namespace: MechzServerUtils
	Checksum: 0x7C76025E
	Offset: 0x3488
	Size: 0x6F
	Parameters: 0
	Flags: Private
*/
function private mechzFlameWatcher()
{
	self endon("death");
	while(1)
	{
		if(isdefined(self.favoriteenemy))
		{
			if(self.flameTrigger istouching(self.favoriteenemy))
			{
				/#
					PrintTopRightln("Dev Block strings are not supported");
				#/
			}
		}
		wait(0.05);
	}
}

/*
	Name: mechzAddAttachments
	Namespace: MechzServerUtils
	Checksum: 0xBF0BB662
	Offset: 0x3500
	Size: 0x10B
	Parameters: 0
	Flags: Private
*/
function private mechzAddAttachments()
{
	self.has_left_knee_armor = 1;
	self.left_knee_armor_health = 50;
	self.has_right_knee_armor = 1;
	self.right_knee_armor_health = 50;
	self.has_left_shoulder_armor = 1;
	self.left_shoulder_armor_health = 50;
	self.has_right_shoulder_armor = 1;
	self.right_shoulder_armor_health = 50;
	org = self GetTagOrigin("tag_gun_spin");
	ang = self GetTagAngles("tag_gun_spin");
	self.gun_attached = 1;
	self.has_faceplate = 1;
	self.faceplate_health = 50;
	self.has_powercap = 1;
	self.powercap_covered = 1;
	self.powercap_cover_health = 50;
	self.powercap_health = 50;
}

/*
	Name: mechzDamageCallback
	Namespace: MechzServerUtils
	Checksum: 0x690F974A
	Offset: 0x3618
	Size: 0x16B3
	Parameters: 12
	Flags: None
*/
function mechzDamageCallback(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(isdefined(self.b_flyin_done) && (!isdefined(self.b_flyin_done) && self.b_flyin_done))
	{
		return 0;
	}
	if(isdefined(level.mechz_should_stun_override) && (!isdefined(self.stun) && self.stun || (isdefined(self.stumble) && self.stumble)))
	{
		if(self.stumble_stun_cooldown_time < GetTime() && (!isdefined(self.Berserk) && self.Berserk))
		{
			self [[level.mechz_should_stun_override]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		}
	}
	if(IsSubStr(weapon.name, "elemental_bow") && isdefined(inflictor) && inflictor.classname === "rocket")
	{
		return 0;
	}
	damage = mechzWeaponDamageModifier(damage, weapon);
	if(isdefined(level.mechz_damage_override))
	{
		damage = [[level.mechz_damage_override]](attacker, damage);
	}
	if(!isdefined(self.next_pain_time) || GetTime() >= self.next_pain_time)
	{
		self thread mechz_play_pain_audio();
		self.next_pain_time = GetTime() + 250 + RandomInt(500);
	}
	if(isdefined(self.damage_scoring_function))
	{
		self [[self.damage_scoring_function]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
	}
	if(isdefined(level.mechz_staff_damage_override))
	{
		staffDamage = [[level.mechz_staff_damage_override]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		if(staffDamage > 0)
		{
			n_mechz_damage_percent = 0.5;
			if(!isdefined(self.has_faceplate) && self.has_faceplate && n_mechz_damage_percent < 1)
			{
				n_mechz_damage_percent = 1;
			}
			staffDamage = staffDamage * n_mechz_damage_percent;
			if(isdefined(self.has_faceplate) && self.has_faceplate)
			{
				self mechz_track_faceplate_damage(staffDamage);
			}
			/#
				IPrintLnBold("Dev Block strings are not supported" + staffDamage + "Dev Block strings are not supported" + self.health - staffDamage);
			#/
			if(!isdefined(self.explosive_dmg_taken))
			{
				self.explosive_dmg_taken = 0;
			}
			self.explosive_dmg_taken = self.explosive_dmg_taken + staffDamage;
			if(isdefined(level.mechz_explosive_damage_reaction_callback))
			{
				self [[level.mechz_explosive_damage_reaction_callback]]();
			}
			return staffDamage;
		}
	}
	if(isdefined(level.mechz_explosive_damage_reaction_callback))
	{
		if(isdefined(mod) && mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE")
		{
			n_mechz_damage_percentage = 0.5;
			if(isdefined(attacker) && isPlayer(attacker) && isalive(attacker) && (level.zombie_vars[attacker.team]["zombie_insta_kill"] || (isdefined(attacker.personal_instakill) && attacker.personal_instakill)))
			{
				n_mechz_damage_percentage = 1;
			}
			explosive_damage = damage * n_mechz_damage_percentage;
			if(!isdefined(self.explosive_dmg_taken))
			{
				self.explosive_dmg_taken = 0;
			}
			self.explosive_dmg_taken = self.explosive_dmg_taken + explosive_damage;
			if(isdefined(self.has_faceplate) && self.has_faceplate)
			{
				self mechz_track_faceplate_damage(explosive_damage);
			}
			self [[level.mechz_explosive_damage_reaction_callback]]();
			/#
				IPrintLnBold("Dev Block strings are not supported" + explosive_damage + "Dev Block strings are not supported" + self.health - explosive_damage);
			#/
			return explosive_damage;
		}
	}
	if(hitLoc == "head")
	{
		attacker show_hit_marker();
		/#
			IPrintLnBold("Dev Block strings are not supported" + damage + "Dev Block strings are not supported" + self.health - damage);
		#/
		return damage;
	}
	if(hitLoc !== "none")
	{
		switch(hitLoc)
		{
			case "torso_upper":
			{
				if(self.has_faceplate == 1)
				{
					faceplate_pos = self GetTagOrigin("j_faceplate");
					dist_sq = DistanceSquared(faceplate_pos, point);
					if(dist_sq <= 144)
					{
						self mechz_track_faceplate_damage(damage);
						attacker show_hit_marker();
					}
					headlamp_dist_sq = DistanceSquared(point, self GetTagOrigin("tag_headlamp_FX"));
					if(headlamp_dist_sq <= 9)
					{
						self mechz_turn_off_headlamp(1);
					}
				}
				partName = GetPartName("c_zom_mech_body", boneIndex);
				if(self.powercap_covered === 1 && (partName === "tag_powersupply" || partName === "tag_powersupply_hit"))
				{
					self mechz_track_powercap_cover_damage(damage);
					attacker show_hit_marker();
					/#
						IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
					#/
					return damage * 0.1;
				}
				else if(self.powercap_covered !== 1 && self.has_powercap === 1 && (partName === "tag_powersupply" || partName === "tag_powersupply_hit"))
				{
					self mechz_track_powercap_damage(damage);
					attacker show_hit_marker();
					/#
						IPrintLnBold("Dev Block strings are not supported" + damage + "Dev Block strings are not supported" + self.health - damage);
					#/
					return damage;
				}
				else if(self.powercap_covered !== 1 && self.has_powercap !== 1 && (partName === "tag_powersupply" || partName === "tag_powersupply_hit"))
				{
					/#
						IPrintLnBold("Dev Block strings are not supported" + damage * 0.5 + "Dev Block strings are not supported" + self.health - damage * 0.5);
					#/
					attacker show_hit_marker();
					return damage * 0.5;
				}
				if(self.has_right_shoulder_armor === 1 && partName === "j_shoulderarmor_ri")
				{
					self mechz_track_rshoulder_armor_damage(damage);
					/#
						IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
					#/
					return damage * 0.1;
				}
				if(self.has_left_shoulder_armor === 1 && partName === "j_shoulderarmor_le")
				{
					self mechz_track_lshoulder_armor_damage(damage);
					/#
						IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
					#/
					return damage * 0.1;
				}
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
				#/
				return damage * 0.1;
				break;
			}
			case "left_leg_lower":
			{
				partName = GetPartName("c_zom_mech_body", boneIndex);
				if(partName === "j_knee_attach_le" && self.has_left_knee_armor === 1)
				{
					self mechz_track_lknee_armor_damage(damage);
				}
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
				#/
				return damage * 0.1;
				break;
			}
			case "right_leg_lower":
			{
				partName = GetPartName("c_zom_mech_body", boneIndex);
				if(partName === "j_knee_attach_ri" && self.has_right_knee_armor === 1)
				{
					self mechz_track_rknee_armor_damage(damage);
				}
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
				#/
				return damage * 0.1;
				break;
			}
			case "left_arm_lower":
			case "left_arm_upper":
			case "left_hand":
			{
				if(isdefined(level.mechz_left_arm_damage_callback))
				{
					self [[level.mechz_left_arm_damage_callback]]();
				}
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
				#/
				return damage * 0.1;
				break;
			}
			case default:
			{
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage * 0.1 + "Dev Block strings are not supported" + self.health - damage * 0.1);
				#/
				return damage * 0.1;
				break;
			}
		}
	}
	if(mod == "MOD_PROJECTILE")
	{
		hit_damage = damage * 0.1;
		if(self.has_faceplate !== 1)
		{
			head_pos = self GetTagOrigin("tag_eye");
			dist_sq = DistanceSquared(head_pos, point);
			if(dist_sq <= 144)
			{
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage + "Dev Block strings are not supported" + self.health - damage);
				#/
				attacker show_hit_marker();
				return damage;
			}
		}
		if(self.has_faceplate === 1)
		{
			faceplate_pos = self GetTagOrigin("j_faceplate");
			dist_sq = DistanceSquared(faceplate_pos, point);
			if(dist_sq <= 144)
			{
				self mechz_track_faceplate_damage(damage);
				attacker show_hit_marker();
			}
			headlamp_dist_sq = DistanceSquared(point, self GetTagOrigin("tag_headlamp_FX"));
			if(headlamp_dist_sq <= 9)
			{
				self mechz_turn_off_headlamp(1);
			}
		}
		power_pos = self GetTagOrigin("tag_powersupply_hit");
		power_dist_sq = DistanceSquared(power_pos, point);
		if(power_dist_sq <= 25)
		{
			if(self.powercap_covered !== 1 && self.has_powercap !== 1)
			{
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage + "Dev Block strings are not supported" + self.health - damage);
				#/
				attacker show_hit_marker();
				return damage;
			}
			if(self.powercap_covered !== 1 && self.has_powercap === 1)
			{
				self mechz_track_powercap_damage(damage);
				attacker show_hit_marker();
				/#
					IPrintLnBold("Dev Block strings are not supported" + damage + "Dev Block strings are not supported" + self.health - damage);
				#/
				return damage;
			}
			if(self.powercap_covered === 1)
			{
				self mechz_track_powercap_cover_damage(damage);
				attacker show_hit_marker();
			}
		}
		if(self.has_right_shoulder_armor === 1)
		{
			armor_pos = self GetTagOrigin("j_shoulderarmor_ri");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 64)
			{
				self mechz_track_rshoulder_armor_damage(damage);
			}
		}
		if(self.has_left_shoulder_armor === 1)
		{
			armor_pos = self GetTagOrigin("j_shoulderarmor_le");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 64)
			{
				self mechz_track_lshoulder_armor_damage(damage);
			}
		}
		if(self.has_right_knee_armor === 1)
		{
			armor_pos = self GetTagOrigin("j_knee_attach_ri");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 36)
			{
				self mechz_track_rknee_armor_damage(damage);
			}
		}
		if(self.has_left_knee_armor === 1)
		{
			armor_pos = self GetTagOrigin("j_knee_attach_le");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 36)
			{
				self mechz_track_lknee_armor_damage(damage);
			}
		}
		/#
			IPrintLnBold("Dev Block strings are not supported" + hit_damage + "Dev Block strings are not supported" + self.health - hit_damage);
		#/
		return hit_damage;
	}
	else if(mod == "MOD_PROJECTILE_SPLASH")
	{
		hit_damage = damage * 0.2;
		i_num_armor_pieces = 0;
		if(isdefined(level.mechz_faceplate_damage_override))
		{
			self [[level.mechz_faceplate_damage_override]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		}
		if(self.has_right_shoulder_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			right_shoulder_index = i_num_armor_pieces;
		}
		if(self.has_left_shoulder_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			left_shoulder_index = i_num_armor_pieces;
		}
		if(self.has_right_knee_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			right_knee_index = i_num_armor_pieces;
		}
		if(self.has_left_knee_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			left_knee_index = i_num_armor_pieces;
		}
		if(i_num_armor_pieces > 0)
		{
			if(i_num_armor_pieces <= 1)
			{
				i_random = 0;
			}
			else
			{
				i_random = RandomInt(i_num_armor_pieces - 1);
			}
			i_random = i_random + 1;
			if(self.has_right_shoulder_armor === 1 && right_shoulder_index === i_random)
			{
				self mechz_track_rshoulder_armor_damage(damage);
			}
			if(self.has_left_shoulder_armor === 1 && left_shoulder_index === i_random)
			{
				self mechz_track_lshoulder_armor_damage(damage);
			}
			if(self.has_right_knee_armor === 1 && right_knee_index === i_random)
			{
				self mechz_track_rknee_armor_damage(damage);
			}
			if(self.has_left_knee_armor === 1 && left_knee_index === i_random)
			{
				self mechz_track_lknee_armor_damage(damage);
			}
		}
		else if(self.powercap_covered === 1)
		{
			self mechz_track_powercap_cover_damage(damage * 0.5);
		}
		if(self.has_faceplate == 1)
		{
			self mechz_track_faceplate_damage(damage * 0.5);
		}
		/#
			IPrintLnBold("Dev Block strings are not supported" + hit_damage + "Dev Block strings are not supported" + self.health - hit_damage);
		#/
		return hit_damage;
	}
	return 0;
}

/*
	Name: mechzWeaponDamageModifier
	Namespace: MechzServerUtils
	Checksum: 0xC06BDF2F
	Offset: 0x4CD8
	Size: 0x149
	Parameters: 2
	Flags: Private
*/
function private mechzWeaponDamageModifier(damage, weapon)
{
	if(isdefined(weapon) && isdefined(weapon.name))
	{
		if(IsSubStr(weapon.name, "shotgun_fullauto"))
		{
			return damage * 0.5;
		}
		if(IsSubStr(weapon.name, "lmg_cqb"))
		{
			return damage * 0.65;
		}
		if(IsSubStr(weapon.name, "lmg_heavy"))
		{
			return damage * 0.65;
		}
		if(IsSubStr(weapon.name, "shotgun_precision"))
		{
			return damage * 0.65;
		}
		if(IsSubStr(weapon.name, "shotgun_semiauto"))
		{
			return damage * 0.75;
		}
	}
	return damage;
}

/*
	Name: mechz_play_pain_audio
	Namespace: MechzServerUtils
	Checksum: 0xA5E536CA
	Offset: 0x4E30
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function mechz_play_pain_audio()
{
	self playsound("zmb_ai_mechz_destruction");
}

/*
	Name: show_hit_marker
	Namespace: MechzServerUtils
	Checksum: 0x66F41B19
	Offset: 0x4E60
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: hide_part
	Namespace: MechzServerUtils
	Checksum: 0x809EA9DF
	Offset: 0x4EF0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function hide_part(strTag)
{
	if(self HasPart(strTag))
	{
		self HidePart(strTag);
	}
}

/*
	Name: mechz_track_faceplate_damage
	Namespace: MechzServerUtils
	Checksum: 0x47D1BA10
	Offset: 0x4F38
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function mechz_track_faceplate_damage(damage)
{
	self.faceplate_health = self.faceplate_health - damage;
	if(self.faceplate_health <= 0)
	{
		self hide_part("j_faceplate");
		self clientfield::set("mechz_faceplate_detached", 1);
		self.has_faceplate = 0;
		self mechz_turn_off_headlamp();
		self.partDestroyed = 1;
		blackboard::SetBlackBoardAttribute(self, "_mechz_part", "mechz_faceplate");
		self MechzBehavior::mechzGoBerserk();
		level notify("mechz_faceplate_detached");
	}
}

/*
	Name: mechz_track_powercap_cover_damage
	Namespace: MechzServerUtils
	Checksum: 0x6A0D5B24
	Offset: 0x5028
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function mechz_track_powercap_cover_damage(damage)
{
	self.powercap_cover_health = self.powercap_cover_health - damage;
	if(self.powercap_cover_health <= 0)
	{
		self hide_part("tag_powersupply");
		self clientfield::set("mechz_powercap_detached", 1);
		self.powercap_covered = 0;
		self.partDestroyed = 1;
		blackboard::SetBlackBoardAttribute(self, "_mechz_part", "mechz_powercore");
	}
}

/*
	Name: mechz_track_powercap_damage
	Namespace: MechzServerUtils
	Checksum: 0x6208F9B8
	Offset: 0x50E0
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function mechz_track_powercap_damage(damage)
{
	self.powercap_health = self.powercap_health - damage;
	if(self.powercap_health <= 0)
	{
		if(isdefined(level.mechz_powercap_destroyed_callback))
		{
			self [[level.mechz_powercap_destroyed_callback]]();
		}
		self hide_part("tag_gun_spin");
		self hide_part("tag_gun_barrel1");
		self hide_part("tag_gun_barrel2");
		self hide_part("tag_gun_barrel3");
		self hide_part("tag_gun_barrel4");
		self hide_part("tag_gun_barrel5");
		self hide_part("tag_gun_barrel6");
		self clientfield::set("mechz_claw_detached", 1);
		self.has_powercap = 0;
		self.gun_attached = 0;
		self.partDestroyed = 1;
		blackboard::SetBlackBoardAttribute(self, "_mechz_part", "mechz_gun");
		level notify("mechz_gun_detached");
	}
}

/*
	Name: mechz_track_rknee_armor_damage
	Namespace: MechzServerUtils
	Checksum: 0x5A9426F1
	Offset: 0x5290
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function mechz_track_rknee_armor_damage(damage)
{
	self.right_knee_armor_health = self.right_knee_armor_health - damage;
	if(self.right_knee_armor_health <= 0)
	{
		self hide_part("j_knee_attach_ri");
		self clientfield::set("mechz_rknee_armor_detached", 1);
		self.has_right_knee_armor = 0;
	}
}

/*
	Name: mechz_track_lknee_armor_damage
	Namespace: MechzServerUtils
	Checksum: 0x71910697
	Offset: 0x5310
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function mechz_track_lknee_armor_damage(damage)
{
	self.left_knee_armor_health = self.left_knee_armor_health - damage;
	if(self.left_knee_armor_health <= 0)
	{
		self hide_part("j_knee_attach_le");
		self clientfield::set("mechz_lknee_armor_detached", 1);
		self.has_left_knee_armor = 0;
	}
}

/*
	Name: mechz_track_rshoulder_armor_damage
	Namespace: MechzServerUtils
	Checksum: 0xDDD26758
	Offset: 0x5390
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function mechz_track_rshoulder_armor_damage(damage)
{
	self.right_shoulder_armor_health = self.right_shoulder_armor_health - damage;
	if(self.right_shoulder_armor_health <= 0)
	{
		self hide_part("j_shoulderarmor_ri");
		self clientfield::set("mechz_rshoulder_armor_detached", 1);
		self.has_right_shoulder_armor = 0;
	}
}

/*
	Name: mechz_track_lshoulder_armor_damage
	Namespace: MechzServerUtils
	Checksum: 0x38E7245D
	Offset: 0x5410
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function mechz_track_lshoulder_armor_damage(damage)
{
	self.left_shoulder_armor_health = self.left_shoulder_armor_health - damage;
	if(self.left_shoulder_armor_health <= 0)
	{
		self hide_part("j_shoulderarmor_le");
		self clientfield::set("mechz_lshoulder_armor_detached", 1);
		self.has_left_shoulder_armor = 0;
	}
}

/*
	Name: mechzCheckInArc
	Namespace: MechzServerUtils
	Checksum: 0x603F88AF
	Offset: 0x5490
	Size: 0x223
	Parameters: 2
	Flags: None
*/
function mechzCheckInArc(right_offset, aim_tag)
{
	origin = self.origin;
	angles = self.angles;
	if(isdefined(aim_tag))
	{
		origin = self GetTagOrigin(aim_tag);
		angles = self GetTagAngles(aim_tag);
	}
	if(isdefined(right_offset))
	{
		right_angle = AnglesToRight(angles);
		origin = origin + right_angle * right_offset;
	}
	facing_vec = AnglesToForward(angles);
	enemy_vec = self.favoriteenemy.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.5)
	{
		return 0;
	}
	enemy_angles = VectorToAngles(enemy_vec);
	if(Abs(AngleClamp180(enemy_angles[0])) > 60)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechzGrenadeCheckInArc
	Namespace: MechzServerUtils
	Checksum: 0x51DEDCCE
	Offset: 0x56C0
	Size: 0x1C3
	Parameters: 1
	Flags: Private
*/
function private mechzGrenadeCheckInArc(right_offset)
{
	origin = self.origin;
	if(isdefined(right_offset))
	{
		right_angle = AnglesToRight(self.angles);
		origin = origin + right_angle * right_offset;
	}
	facing_vec = AnglesToForward(self.angles);
	enemy_vec = self.favoriteenemy.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.5)
	{
		return 0;
	}
	enemy_angles = VectorToAngles(enemy_vec);
	if(Abs(AngleClamp180(enemy_angles[0])) > 60)
	{
		return 0;
	}
	return 1;
}

/*
	Name: mechz_turn_off_headlamp
	Namespace: MechzServerUtils
	Checksum: 0x2830C23D
	Offset: 0x5890
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function mechz_turn_off_headlamp(headlamp_broken)
{
	if(headlamp_broken !== 1)
	{
		self clientfield::set("mechz_headlamp_off", 1);
	}
	else
	{
		self clientfield::set("mechz_headlamp_off", 2);
	}
}

