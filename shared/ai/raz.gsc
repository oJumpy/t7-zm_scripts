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
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace RazBehavior;

/*
	Name: init
	Namespace: RazBehavior
	Checksum: 0x8DD4E943
	Offset: 0xA60
	Size: 0x243
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitRazBehaviorsAndASM();
	spawner::add_archetype_spawn_function("raz", &ArchetypeRazBlackboardInit);
	spawner::add_archetype_spawn_function("raz", &RazServerUtils::razSpawnSetup);
	clientfield::register("scriptmover", "raz_detonate_ground_torpedo", 12000, 1, "int");
	clientfield::register("scriptmover", "raz_torpedo_play_fx_on_self", 12000, 1, "int");
	clientfield::register("scriptmover", "raz_torpedo_play_trail", 12000, 1, "counter");
	clientfield::register("actor", "raz_detach_gun", 12000, 1, "int");
	clientfield::register("actor", "raz_gun_weakpoint_hit", 12000, 1, "counter");
	clientfield::register("actor", "raz_detach_helmet", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_chest_armor", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_l_shoulder_armor", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_r_thigh_armor", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_l_thigh_armor", 12000, 1, "int");
}

/*
	Name: InitRazBehaviorsAndASM
	Namespace: RazBehavior
	Checksum: 0x74E85121
	Offset: 0xCB0
	Size: 0x2D3
	Parameters: 0
	Flags: Private
*/
function private InitRazBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razTargetService", &razTargetService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razSprintService", &razSprintService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldMelee", &razShouldMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldShowPain", &razShouldShowPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldShowSpecialPain", &razShouldShowSpecialPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldShowShieldPain", &razShouldShowShieldPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldShootGroundTorpedo", &razShouldShootGroundTorpedo);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldGoBerserk", &razShouldGoBerserk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razShouldTraverseWindow", &razShouldTraverseWindow);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razStartMelee", &razStartMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razFinishMelee", &razFinishMelee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razFinishGroundTorpedo", &razFinishGroundTorpedo);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razGoneBerserk", &razGoneBerserk);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razStartTraverseWindow", &razStartTraverseWindow);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razFinishTraverseWindow", &razFinishTraverseWindow);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razTookPain", &razTookPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("razStartDeath", &razStartDeath);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("mangler_fire", &razNotetrackShootGroundTorpedo);
}

/*
	Name: ArchetypeRazBlackboardInit
	Namespace: RazBehavior
	Checksum: 0xA6ABA10B
	Offset: 0xF90
	Size: 0x24B
	Parameters: 0
	Flags: Private
*/
function private ArchetypeRazBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_gibbed_limbs", "none", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", undefined);
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
	blackboard::RegisterBlackBoardAttribute(self, "_gib_location", "legs", undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeRazOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeRazOnAnimscriptedCallback
	Namespace: RazBehavior
	Checksum: 0xC6246CC5
	Offset: 0x11E8
	Size: 0xD3
	Parameters: 1
	Flags: Private
*/
function private ArchetypeRazOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeRazBlackboardInit();
	if(isdefined(entity.started_running) && entity.started_running)
	{
		entity.invoke_sprint_time = undefined;
		blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
	if(!(isdefined(entity.razHasGunAttached) && entity.razHasGunAttached))
	{
		blackboard::SetBlackBoardAttribute(entity, "_gibbed_limbs", "right_arm");
	}
}

/*
	Name: BB_GetShouldTurn
	Namespace: RazBehavior
	Checksum: 0x10159912
	Offset: 0x12C8
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
	Name: findNodesService
	Namespace: RazBehavior
	Checksum: 0xD10A1D5F
	Offset: 0x1300
	Size: 0x22D
	Parameters: 1
	Flags: None
*/
function findNodesService(behaviorTreeEntity)
{
	node = undefined;
	behaviorTreeEntity.entrance_nodes = [];
	if(isdefined(behaviorTreeEntity.find_flesh_struct_string))
	{
		if(behaviorTreeEntity.find_flesh_struct_string == "find_flesh")
		{
			return 0;
		}
		for(i = 0; i < level.exterior_goals.size; i++)
		{
			if(isdefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == behaviorTreeEntity.find_flesh_struct_string)
			{
				node = level.exterior_goals[i];
				break;
			}
		}
		behaviorTreeEntity.entrance_nodes[behaviorTreeEntity.entrance_nodes.size] = node;
		/#
			Assert(isdefined(node), "Dev Block strings are not supported" + behaviorTreeEntity.find_flesh_struct_string + "Dev Block strings are not supported");
		#/
		behaviorTreeEntity.first_node = node;
		behaviorTreeEntity.goalRadius = 80;
		behaviorTreeEntity.mocomp_barricade_offset = GetDvarInt("raz_node_origin_offset", -22);
		node_origin = node.origin + AnglesToForward(node.angles) * behaviorTreeEntity.mocomp_barricade_offset;
		behaviorTreeEntity SetGoal(node_origin);
		if(zm_behavior::zombieIsAtEntrance(behaviorTreeEntity))
		{
			behaviorTreeEntity.got_to_entrance = 1;
		}
		return 1;
	}
}

/*
	Name: shouldSkipTeardown
	Namespace: RazBehavior
	Checksum: 0xDEB9BB66
	Offset: 0x1538
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function shouldSkipTeardown(entity)
{
	if(isdefined(entity.destroying_window) && entity.destroying_window)
	{
		return 1;
	}
	if(!isdefined(entity.script_string) || entity.script_string == "find_flesh")
	{
		return 1;
	}
	return 0;
}

/*
	Name: razGetNonDestroyedChuncks
	Namespace: RazBehavior
	Checksum: 0xF6D66AC
	Offset: 0x15B0
	Size: 0x53
	Parameters: 0
	Flags: Private
*/
function private razGetNonDestroyedChuncks()
{
	chunks = undefined;
	if(isdefined(self.first_node))
	{
		chunks = zm_utility::get_non_destroyed_chunks(self.first_node, self.first_node.barrier_chunks);
	}
	return chunks;
}

/*
	Name: razDestroyWindow
	Namespace: RazBehavior
	Checksum: 0xD35CC82C
	Offset: 0x1610
	Size: 0x21D
	Parameters: 2
	Flags: Private
*/
function private razDestroyWindow(entity, b_destroy_actual_pieces)
{
	if(!(isdefined(b_destroy_actual_pieces) && b_destroy_actual_pieces))
	{
		entity.got_to_entrance = 0;
		entity.destroying_window = 1;
		entity ForceTeleport(entity.origin, entity.first_node.angles);
		chunks = entity razGetNonDestroyedChuncks();
		if(!isdefined(chunks) || chunks.size == 0)
		{
			entity.jump_through_window = 1;
			entity.jump_through_window_angle = entity.angles;
		}
		else if(isdefined(entity.razHasGunAttached) && entity.razHasGunAttached)
		{
			entity.destroy_window_by_torpedo = 1;
		}
		else
		{
			entity.destroy_window_by_melee = 1;
		}
		break;
	}
	entity.jump_through_window = 1;
	entity.jump_through_window_angle = entity.angles;
	if(isdefined(entity.first_node))
	{
		chunks = entity razGetNonDestroyedChuncks();
		if(isdefined(chunks))
		{
			for(i = 0; i < chunks.size; i++)
			{
				entity.first_node.zbarrier SetZBarrierPieceState(chunks[i], "opening", 0.2);
			}
		}
	}
}

/*
	Name: razTargetService
	Namespace: RazBehavior
	Checksum: 0xF2CEB743
	Offset: 0x1838
	Size: 0x36F
	Parameters: 1
	Flags: Private
*/
function private razTargetService(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(isdefined(entity.jump_through_window) && entity.jump_through_window)
	{
		return 0;
	}
	if(!zm_behavior::InPlayableArea(entity) && !shouldSkipTeardown(entity))
	{
		if(isdefined(entity.got_to_entrance) && entity.got_to_entrance)
		{
			razDestroyWindow(entity);
		}
		else if(zm_behavior::zombieEnteredPlayable(entity))
		{
			return 0;
		}
		findNodesService(entity);
		return 0;
	}
	if(level.zombie_poi_array.size > 0)
	{
		zombie_poi = entity zm_utility::get_zombie_point_of_interest(entity.origin);
		if(isdefined(zombie_poi))
		{
			targetPos = GetClosestPointOnNavMesh(zombie_poi[0], 64, 30);
			entity.zombie_poi = zombie_poi;
			entity.enemyoverride = zombie_poi;
			if(isdefined(targetPos))
			{
				self SetGoal(targetPos);
			}
			else
			{
				self SetGoal(zombie_poi[0]);
			}
			return;
		}
		else
		{
			entity.zombie_poi = undefined;
			entity.enemyoverride = undefined;
		}
	}
	else
	{
		entity.zombie_poi = undefined;
		entity.enemyoverride = undefined;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player, 1);
	entity.favoriteenemy = player;
	if(!isdefined(player) || player IsNoTarget())
	{
		if(isdefined(self.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			self.ignore_player = [];
		}
		self SetGoal(self.origin);
		return 0;
	}
	else
	{
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
}

/*
	Name: razSprintService
	Namespace: RazBehavior
	Checksum: 0x7B0442B6
	Offset: 0x1BB0
	Size: 0xD3
	Parameters: 1
	Flags: Private
*/
function private razSprintService(entity)
{
	if(isdefined(entity.started_running) && entity.started_running)
	{
		return 0;
	}
	if(!isdefined(entity.invoke_sprint_time))
	{
		return 0;
	}
	if(GetTime() > entity.invoke_sprint_time)
	{
		entity.invoke_sprint_time = undefined;
		entity.started_running = 1;
		entity.Berserk = 1;
		entity thread razSprintKnockdownZombies();
		blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

/*
	Name: razShouldMelee
	Namespace: RazBehavior
	Checksum: 0x6F5A727C
	Offset: 0x1C90
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function razShouldMelee(entity)
{
	if(isdefined(entity.destroy_window_by_melee) && entity.destroy_window_by_melee)
	{
		return 1;
	}
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.enemy.origin) > 5625)
	{
		return 0;
	}
	yaw = Abs(zombie_utility::getYawToEnemy());
	if(yaw > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: razShouldShowPain
	Namespace: RazBehavior
	Checksum: 0x74B32DBA
	Offset: 0x1D70
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private razShouldShowPain(entity)
{
	if(isdefined(entity.Berserk) && entity.Berserk && (!isdefined(entity.razHasGoneBerserk) && entity.razHasGoneBerserk))
	{
		return 0;
	}
	return 1;
}

/*
	Name: razShouldShowSpecialPain
	Namespace: RazBehavior
	Checksum: 0xFB5A61C1
	Offset: 0x1DD8
	Size: 0xC3
	Parameters: 1
	Flags: Private
*/
function private razShouldShowSpecialPain(entity)
{
	GIB_LOCATION = blackboard::GetBlackBoardAttribute(entity, "_gib_location");
	if(GIB_LOCATION == "right_arm")
	{
		return 1;
	}
	if(!razShouldShowPain(entity))
	{
		return 0;
	}
	if(GIB_LOCATION == "head" || GIB_LOCATION == "arms" || GIB_LOCATION == "right_leg" || GIB_LOCATION == "left_leg" || GIB_LOCATION == "left_arm")
	{
		return 1;
	}
	return 0;
}

/*
	Name: razShouldShowShieldPain
	Namespace: RazBehavior
	Checksum: 0x85D9F01C
	Offset: 0x1EA8
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private razShouldShowShieldPain(entity)
{
	if(isdefined(entity.damageWeapon) && isdefined(entity.damageWeapon.name))
	{
		return entity.damageWeapon.name == "dragonshield";
	}
	return 0;
}

/*
	Name: razShouldGoBerserk
	Namespace: RazBehavior
	Checksum: 0xEA81A38D
	Offset: 0x1F10
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private razShouldGoBerserk(entity)
{
	if(isdefined(entity.Berserk) && entity.Berserk && (!isdefined(entity.razHasGoneBerserk) && entity.razHasGoneBerserk))
	{
		return 1;
	}
	return 0;
}

/*
	Name: razShouldTraverseWindow
	Namespace: RazBehavior
	Checksum: 0x981EA0AA
	Offset: 0x1F78
	Size: 0x2D
	Parameters: 1
	Flags: Private
*/
function private razShouldTraverseWindow(entity)
{
	return isdefined(entity.jump_through_window) && entity.jump_through_window;
}

/*
	Name: razGoneBerserk
	Namespace: RazBehavior
	Checksum: 0xDA44275
	Offset: 0x1FB0
	Size: 0x1F
	Parameters: 1
	Flags: Private
*/
function private razGoneBerserk(entity)
{
	entity.razHasGoneBerserk = 1;
}

/*
	Name: razStartTraverseWindow
	Namespace: RazBehavior
	Checksum: 0xDB1D6CF2
	Offset: 0x1FD8
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private razStartTraverseWindow(entity)
{
	raz_dir = AnglesToForward(entity.first_node.angles);
	raz_dir = VectorScale(raz_dir, 100);
	entity SetGoal(entity.origin + raz_dir);
}

/*
	Name: razFinishTraverseWindow
	Namespace: RazBehavior
	Checksum: 0x932A2B03
	Offset: 0x2060
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private razFinishTraverseWindow(entity)
{
	entity SetGoal(entity.origin);
	entity.jump_through_window = undefined;
	entity.first_node = undefined;
	if(!(isdefined(entity.completed_emerging_into_playable_area) && entity.completed_emerging_into_playable_area))
	{
		entity zm_spawner::zombie_complete_emerging_into_playable_area();
	}
}

/*
	Name: razTookPain
	Namespace: RazBehavior
	Checksum: 0x855BF4E1
	Offset: 0x20F0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private razTookPain(entity)
{
	blackboard::SetBlackBoardAttribute(entity, "_gib_location", "legs");
}

/*
	Name: razStartDeath
	Namespace: RazBehavior
	Checksum: 0xD7FA1F6B
	Offset: 0x2130
	Size: 0x50B
	Parameters: 1
	Flags: Private
*/
function private razStartDeath(entity)
{
	entity PlaySoundOnTag("zmb_raz_death", "tag_eye");
	if(isdefined(entity.razHasGunAttached) && entity.razHasGunAttached)
	{
		entity clientfield::set("raz_detach_gun", 1);
		entity.razHasGunAttached = 0;
		entity Detach("c_zom_dlc3_raz_cannon_arm");
		entity HidePart("j_shouldertwist_ri_attach", "", 1);
		entity HidePart("j_shoulder_ri_attach");
		wait(0.05);
		if(isdefined(entity))
		{
			entity RazServerUtils::razInvalidateGibbedArmor();
		}
	}
	if(isdefined(entity))
	{
		if(isdefined(entity.razHasHelmet) && entity.razHasHelmet)
		{
			entity clientfield::set("raz_detach_helmet", 1);
			entity HidePart("j_head_attach", "", 1);
			entity.razHasHelmet = 0;
		}
		if(isdefined(entity.razHasChestArmor) && entity.razHasChestArmor)
		{
			entity clientfield::set("raz_detach_chest_armor", 1);
			entity HidePart("j_spine4_attach", "", 1);
			entity HidePart("j_spineupper_attach", "", 1);
			entity HidePart("j_spinelower_attach", "", 1);
			entity HidePart("j_mainroot_attach", "", 1);
			entity HidePart("j_clavicle_ri_attachbp", "", 1);
			entity HidePart("j_clavicle_le_attachbp", "", 1);
			entity.razHasChestArmor = 0;
		}
		if(isdefined(entity.razHasLeftShoulderArmor) && entity.razHasLeftShoulderArmor)
		{
			entity clientfield::set("raz_detach_l_shoulder_armor", 1);
			entity HidePart("j_shouldertwist_le_attach", "", 1);
			entity HidePart("j_shoulder_le_attach", "", 1);
			entity HidePart("j_clavicle_le_attach", "", 1);
			entity.razHasLeftShoulderArmor = 0;
		}
		if(isdefined(entity.razHasLeftThighArmor) && entity.razHasLeftThighArmor)
		{
			entity clientfield::set("raz_detach_l_thigh_armor", 1);
			entity HidePart("j_hiptwist_le_attach", "", 1);
			entity HidePart("j_hip_le_attach", "", 1);
			entity.razHasLeftThighArmor = 0;
		}
		if(isdefined(entity.razHasRightThighArmor) && entity.razHasRightThighArmor)
		{
			entity clientfield::set("raz_detach_r_thigh_armor", 1);
			entity HidePart("j_hiptwist_ri_attach", "", 1);
			entity HidePart("j_hip_ri_attach", "", 1);
			entity.razHasRightThighArmor = 0;
		}
	}
}

/*
	Name: razShouldShootGroundTorpedo
	Namespace: RazBehavior
	Checksum: 0x62BB7650
	Offset: 0x2648
	Size: 0x177
	Parameters: 1
	Flags: Private
*/
function private razShouldShootGroundTorpedo(entity)
{
	if(isdefined(entity.destroy_window_by_torpedo) && entity.destroy_window_by_torpedo)
	{
		return 1;
	}
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(!(isdefined(entity.razHasGunAttached) && entity.razHasGunAttached))
	{
		return 0;
	}
	time = GetTime();
	if(time < entity.next_torpedo_time)
	{
		return 0;
	}
	enemy_dist_sq = DistanceSquared(entity.origin, entity.enemy.origin);
	if(!(enemy_dist_sq >= 22500 && enemy_dist_sq <= 1440000 && entity razCanSeeTorpedoTarget(entity.enemy)))
	{
		return 0;
	}
	if(isdefined(entity.check_point_in_enabled_zone))
	{
		in_enabled_zone = [[entity.check_point_in_enabled_zone]](entity.origin);
		if(!in_enabled_zone)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: razCanSeeTorpedoTarget
	Namespace: RazBehavior
	Checksum: 0x7C9D8B28
	Offset: 0x27C8
	Size: 0x185
	Parameters: 1
	Flags: Private
*/
function private razCanSeeTorpedoTarget(enemy)
{
	entity = self;
	origin_point = entity GetTagOrigin("tag_weapon_right");
	target_point = enemy.origin + VectorScale((0, 0, 1), 48);
	forward_vect = AnglesToForward(self.angles);
	vect_to_enemy = target_point - origin_point;
	if(VectorDot(forward_vect, vect_to_enemy) <= 0)
	{
		return 0;
	}
	right_vect = AnglesToRight(self.angles);
	projected_distance = VectorDot(vect_to_enemy, right_vect);
	if(Abs(projected_distance) > 50)
	{
		return 0;
	}
	trace = bullettrace(origin_point, target_point, 0, self);
	if(trace["position"] === target_point)
	{
		return 1;
	}
	return 0;
}

/*
	Name: razStartMelee
	Namespace: RazBehavior
	Checksum: 0x2321398F
	Offset: 0x2958
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private razStartMelee(entity)
{
	if(isdefined(entity.destroy_window_by_melee) && entity.destroy_window_by_melee)
	{
		wait(1.1);
		razDestroyWindow(entity, 1);
	}
}

/*
	Name: razFinishMelee
	Namespace: RazBehavior
	Checksum: 0x1AA98562
	Offset: 0x29B8
	Size: 0x19
	Parameters: 1
	Flags: Private
*/
function private razFinishMelee(entity)
{
	entity.destroy_window_by_melee = undefined;
}

/*
	Name: razFinishGroundTorpedo
	Namespace: RazBehavior
	Checksum: 0x6795C333
	Offset: 0x29E0
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private razFinishGroundTorpedo(entity)
{
	entity.destroy_window_by_torpedo = undefined;
	entity.next_torpedo_time = GetTime() + 3000;
}

/*
	Name: razNotetrackShootGroundTorpedo
	Namespace: RazBehavior
	Checksum: 0xB982895C
	Offset: 0x2A18
	Size: 0x163
	Parameters: 1
	Flags: Private
*/
function private razNotetrackShootGroundTorpedo(entity)
{
	if(!isdefined(entity.enemy) && (!isdefined(entity.destroy_window_by_torpedo) && entity.destroy_window_by_torpedo))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	if(isdefined(entity.destroy_window_by_torpedo) && entity.destroy_window_by_torpedo)
	{
		razDestroyWindow(entity, 1);
		raz_dir = AnglesToForward(entity.first_node.angles);
		entity razShootGroundTorpedo(entity.first_node, VectorScale(raz_dir, 100) + VectorScale((0, 0, 1), 48));
	}
	else
	{
		entity razShootGroundTorpedo(entity.enemy, VectorScale((0, 0, 1), 48));
	}
	entity.next_torpedo_time = GetTime() + 3000;
}

/*
	Name: razTorpedoLaunchDirection
	Namespace: RazBehavior
	Checksum: 0x84781273
	Offset: 0x2B88
	Size: 0x12F
	Parameters: 4
	Flags: Private
*/
function private razTorpedoLaunchDirection(forward_dir, torpedo_pos, torpedo_target_pos, max_angle)
{
	vec_to_enemy = torpedo_target_pos - torpedo_pos;
	vec_to_enemy_normal = VectorNormalize(vec_to_enemy);
	angle_to_enemy = VectorDot(forward_dir, vec_to_enemy_normal);
	if(angle_to_enemy >= max_angle)
	{
		return vec_to_enemy_normal;
	}
	plane_normal = VectorCross(forward_dir, vec_to_enemy_normal);
	perpendicular_normal = VectorCross(plane_normal, forward_dir);
	torpedo_dir = forward_dir * cos(max_angle) + perpendicular_normal * sin(max_angle);
	return torpedo_dir;
}

/*
	Name: razShootGroundTorpedo
	Namespace: RazBehavior
	Checksum: 0xCD285C9C
	Offset: 0x2CC0
	Size: 0x2B3
	Parameters: 2
	Flags: Private
*/
function private razShootGroundTorpedo(torpedo_target, torpedo_target_offset)
{
	torpedo_pos = self GetTagOrigin("tag_weapon_right");
	torpedo_target_pos = torpedo_target.origin + torpedo_target_offset;
	Torpedo = spawn("script_model", torpedo_pos);
	Torpedo SetModel("tag_origin");
	Torpedo clientfield::set("raz_torpedo_play_fx_on_self", 1);
	Torpedo.torpedo_trail_iterations = 0;
	Torpedo.raz_torpedo_owner = self;
	vec_to_enemy = razTorpedoLaunchDirection(AnglesToForward(self.angles), torpedo_pos, torpedo_target_pos, 0.7);
	angles_to_enemy = VectorToAngles(vec_to_enemy);
	Torpedo.angles = angles_to_enemy;
	normal_vector = VectorNormalize(vec_to_enemy);
	Torpedo.torpedo_old_normal_vector = normal_vector;
	Torpedo.knockdown_iterations = 0;
	iteration_move_distance = 50;
	max_trail_iterations = Int(1200 / iteration_move_distance);
	Torpedo thread razTorpedoKnockdownZombies(torpedo_target);
	Torpedo thread razTorpedoDetonateIfCloseToTarget(torpedo_target, torpedo_target_offset);
	while(isdefined(Torpedo))
	{
		if(!isdefined(torpedo_target) || Torpedo.torpedo_trail_iterations >= max_trail_iterations)
		{
			Torpedo thread razTorpedoDetonate(0);
		}
		else
		{
			Torpedo razTorpedoMoveToTarget(torpedo_target);
			Torpedo.torpedo_trail_iterations = Torpedo.torpedo_trail_iterations + 1;
		}
		wait(0.1);
	}
}

/*
	Name: razTorpedoDetonateIfCloseToTarget
	Namespace: RazBehavior
	Checksum: 0xF82A95D0
	Offset: 0x2F80
	Size: 0xBF
	Parameters: 2
	Flags: Private
*/
function private razTorpedoDetonateIfCloseToTarget(torpedo_target, torpedo_target_offset)
{
	self endon("death");
	self endon("detonated");
	Torpedo = self;
	while(isdefined(Torpedo) && isdefined(torpedo_target))
	{
		torpedo_target_pos = torpedo_target.origin + torpedo_target_offset;
		if(DistanceSquared(Torpedo.origin, torpedo_target_pos) <= 4096)
		{
			Torpedo thread razTorpedoDetonate(0);
		}
		wait(0.05);
	}
}

/*
	Name: razTorpedoMoveToTarget
	Namespace: RazBehavior
	Checksum: 0xF75ED641
	Offset: 0x3048
	Size: 0x43B
	Parameters: 1
	Flags: Private
*/
function private razTorpedoMoveToTarget(torpedo_target)
{
	self endon("death");
	self endon("detonated");
	if(!isdefined(self.torpedo_max_yaw_cos))
	{
		torpedo_yaw_per_interval = 13.5;
		self.torpedo_max_yaw_cos = cos(torpedo_yaw_per_interval);
	}
	if(isdefined(self.torpedo_old_normal_vector))
	{
		torpedo_target_point = torpedo_target.origin + VectorScale((0, 0, 1), 48);
		if(isPlayer(torpedo_target))
		{
			torpedo_target_point = torpedo_target GetPlayerCameraPos();
		}
		vector_to_target = torpedo_target_point - self.origin;
		normal_vector = VectorNormalize(vector_to_target);
		flat_mapped_normal_vector = VectorNormalize((normal_vector[0], normal_vector[1], 0));
		flat_mapped_old_normal_vector = VectorNormalize((self.torpedo_old_normal_vector[0], self.torpedo_old_normal_vector[1], 0));
		dot = VectorDot(flat_mapped_normal_vector, flat_mapped_old_normal_vector);
		if(dot >= 1)
		{
			dot = 1;
		}
		else if(dot <= -1)
		{
			dot = -1;
		}
		if(dot < self.torpedo_max_yaw_cos)
		{
			new_vector = normal_vector - self.torpedo_old_normal_vector;
			angle_between_vectors = ACos(dot);
			if(!isdefined(angle_between_vectors))
			{
				angle_between_vectors = 180;
			}
			if(angle_between_vectors == 0)
			{
				angle_between_vectors = 0.0001;
			}
			max_angle_per_interval = 13.5;
			Ratio = max_angle_per_interval / angle_between_vectors;
			if(Ratio > 1)
			{
				Ratio = 1;
			}
			new_vector = new_vector * Ratio;
			new_vector = new_vector + self.torpedo_old_normal_vector;
			normal_vector = VectorNormalize(new_vector);
		}
		else
		{
			normal_vector = self.torpedo_old_normal_vector;
		}
	}
	move_distance = 50;
	move_vector = move_distance * normal_vector;
	move_to_point = self.origin + move_vector;
	trace = bullettrace(self.origin, move_to_point, 0, self);
	if(trace["surfacetype"] !== "none")
	{
		detonate_point = trace["position"];
		dist_sq = DistanceSquared(detonate_point, self.origin);
		move_dist_sq = move_distance * move_distance;
		Ratio = dist_sq / move_dist_sq;
		delay = Ratio * 0.1;
		self thread razTorpedoDetonate(delay);
	}
	self.torpedo_old_normal_vector = normal_vector;
	self moveto(move_to_point, 0.1);
}

/*
	Name: razTorpedoPlayTrailEffect
	Namespace: RazBehavior
	Checksum: 0x33EA7F91
	Offset: 0x3490
	Size: 0xC3
	Parameters: 0
	Flags: Private
*/
function private razTorpedoPlayTrailEffect()
{
	self endon("death");
	self endon("detonated");
	surface_check_offset = 26;
	if(self.torpedo_trail_iterations >= 1)
	{
		trace = bullettrace(self.origin + VectorScale((0, 0, 1), 10), self.origin - (0, 0, surface_check_offset), 0, self);
		if(trace["surfacetype"] !== "none")
		{
			self clientfield::increment("raz_torpedo_play_trail", 1);
		}
	}
}

/*
	Name: razKnockdownZombies
	Namespace: RazBehavior
	Checksum: 0x9F5C36EC
	Offset: 0x3560
	Size: 0x5EF
	Parameters: 1
	Flags: Private
*/
function private razKnockdownZombies(target)
{
	self endon("death");
	while(isdefined(self))
	{
		if(isdefined(target))
		{
			if(isPlayer(target))
			{
				torpedo_target_position = target.origin + VectorScale((0, 0, 1), 48);
			}
			else
			{
				torpedo_target_position = target.origin;
			}
			prediction_time = 0.3;
			if(isdefined(self.knockdown_iterations) && self.knockdown_iterations < 3)
			{
				if(self.knockdown_iterations == 0)
				{
					prediction_time = 0.075;
				}
				if(self.knockdown_iterations == 1)
				{
					prediction_time = 0.15;
				}
				if(self.knockdown_iterations == 2)
				{
					prediction_time = 0.225;
				}
			}
			self.knockdown_iterations = self.knockdown_iterations + 1;
			vector_to_target = torpedo_target_position - self.origin;
			normal_vector = VectorNormalize(vector_to_target);
			move_distance = 500 * prediction_time;
			move_vector = move_distance * normal_vector;
			self.angles = VectorToAngles(move_vector);
		}
		else
		{
			velocity = self GetVelocity();
			velocityMag = length(velocity);
			b_sprinting = velocityMag >= 40;
			if(b_sprinting)
			{
				predict_time = 0.2;
				move_vector = velocity * predict_time;
			}
		}
		if(!isdefined(b_sprinting) || b_sprinting == 1)
		{
			predicted_pos = self.origin + move_vector;
			a_zombies = GetAIArchetypeArray("zombie");
			a_filtered_zombies = Array::filter(a_zombies, 0, &razZombieEligibleForKnockdown, self, predicted_pos);
		}
		else
		{
			wait(0.2);
			continue;
		}
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				zombie.KNOCKDOWN = 1;
				zombie.knockdown_type = "knockdown_shoved";
				zombie_to_target = self.origin - zombie.origin;
				zombie_to_target_2d = VectorNormalize((zombie_to_target[0], zombie_to_target[1], 0));
				zombie_forward = AnglesToForward(zombie.angles);
				zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
				zombie_right = AnglesToRight(zombie.angles);
				zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
				dot = VectorDot(zombie_to_target_2d, zombie_forward_2d);
				if(dot >= 0.5)
				{
					zombie.knockdown_direction = "front";
					zombie.getup_direction = "getup_back";
					continue;
				}
				if(dot < 0.5 && dot > -0.5)
				{
					dot = VectorDot(zombie_to_target_2d, zombie_right_2d);
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
		wait(0.2);
	}
}

/*
	Name: razTorpedoKnockdownZombies
	Namespace: RazBehavior
	Checksum: 0x7BD8BD3A
	Offset: 0x3B58
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private razTorpedoKnockdownZombies(torpedo_target)
{
	self endon("death");
	self endon("detonated");
	razKnockdownZombies(torpedo_target);
}

/*
	Name: razSprintKnockdownZombies
	Namespace: RazBehavior
	Checksum: 0x66AF7FF3
	Offset: 0x3BA0
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private razSprintKnockdownZombies()
{
	self endon("death");
	self notify("razSprintKnockdownZombies");
	self endon("razSprintKnockdownZombies");
	razKnockdownZombies();
}

/*
	Name: razTorpedoDetonate
	Namespace: RazBehavior
	Checksum: 0x58A93EBA
	Offset: 0x3BE8
	Size: 0x1B3
	Parameters: 1
	Flags: Private
*/
function private razTorpedoDetonate(delay)
{
	self notify("detonated");
	Torpedo = self;
	raz_torpedo_owner = self.raz_torpedo_owner;
	if(delay > 0)
	{
		wait(delay);
	}
	if(isdefined(self))
	{
		self razApplyPlayerDetonationEffects();
		w_weapon = GetWeapon("none");
		explosion_point = Torpedo.origin;
		Torpedo clientfield::set("raz_detonate_ground_torpedo", 1);
		RadiusDamage(explosion_point + VectorScale((0, 0, 1), 18), 128, 100, 50, self.raz_torpedo_owner, "MOD_UNKNOWN", w_weapon);
		razApplyTorpedoDetonationPushToPlayers(explosion_point + VectorScale((0, 0, 1), 18));
		self clientfield::set("raz_torpedo_play_fx_on_self", 0);
		wait(0.05);
		if(isdefined(raz_torpedo_owner) && (isdefined(level.b_raz_ignore_mangler_cooldown) && level.b_raz_ignore_mangler_cooldown))
		{
			raz_torpedo_owner.next_torpedo_time = GetTime();
		}
		if(isdefined(self))
		{
			self delete();
		}
	}
}

/*
	Name: razApplyTorpedoDetonationPushToPlayers
	Namespace: RazBehavior
	Checksum: 0xB6DD2BD6
	Offset: 0x3DA8
	Size: 0x28D
	Parameters: 1
	Flags: Private
*/
function private razApplyTorpedoDetonationPushToPlayers(torpedo_origin)
{
	players = GetPlayers();
	v_length = 100 * 100;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isalive(player))
		{
			continue;
		}
		if(player.sessionstate == "spectator")
		{
			continue;
		}
		if(player.sessionstate == "intermission")
		{
			continue;
		}
		if(isdefined(player.ignoreme) && player.ignoreme)
		{
			continue;
		}
		if(player IsNoTarget())
		{
			continue;
		}
		if(!player IsOnGround())
		{
			continue;
		}
		n_distance = Distance2DSquared(torpedo_origin, player.origin);
		if(n_distance < 0.01)
		{
			continue;
		}
		if(n_distance < v_length)
		{
			v_dir = player.origin - torpedo_origin;
			v_dir = (v_dir[0], v_dir[1], 0.1);
			v_dir = VectorNormalize(v_dir);
			n_push_strength = GetDvarInt("raz_n_push_strength", 500);
			n_push_strength = 200 + RandomInt(n_push_strength - 200);
			v_player_velocity = player GetVelocity();
			player SetVelocity(v_player_velocity + v_dir * n_push_strength);
		}
	}
}

/*
	Name: razApplyPlayerDetonationEffects
	Namespace: RazBehavior
	Checksum: 0xD691400D
	Offset: 0x4040
	Size: 0xE5
	Parameters: 0
	Flags: Private
*/
function private razApplyPlayerDetonationEffects()
{
	Earthquake(0.4, 0.8, self.origin, 300);
	for(i = 0; i < level.activePlayers.size; i++)
	{
		distanceSq = DistanceSquared(self.origin, level.activePlayers[i].origin + VectorScale((0, 0, 1), 48));
		if(distanceSq > 4096)
		{
			continue;
		}
		level.activePlayers[i] PlayRumbleOnEntity("damage_heavy");
	}
}

/*
	Name: razZombieEligibleForKnockdown
	Namespace: RazBehavior
	Checksum: 0xB253091F
	Offset: 0x4130
	Size: 0x233
	Parameters: 3
	Flags: Private
*/
function private razZombieEligibleForKnockdown(zombie, target, predicted_pos)
{
	if(zombie.KNOCKDOWN === 1)
	{
		return 0;
	}
	if(GibServerUtils::IsGibbed(zombie, 384))
	{
		return 0;
	}
	knockdown_dist = 48;
	check_pos = zombie.origin;
	if(!IsActor(target))
	{
		check_pos = zombie GetCentroid();
		knockdown_dist = 64;
	}
	knockdown_dist_sq = knockdown_dist * knockdown_dist;
	dist_sq = DistanceSquared(predicted_pos, check_pos);
	if(dist_sq > knockdown_dist_sq)
	{
		return 0;
	}
	origin = target.origin;
	facing_vec = AnglesToForward(target.angles);
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

#namespace RazServerUtils;

/*
	Name: razSpawnSetup
	Namespace: RazServerUtils
	Checksum: 0x3BB9B0DA
	Offset: 0x4370
	Size: 0x1DB
	Parameters: 0
	Flags: Private
*/
function private razSpawnSetup()
{
	self.invoke_sprint_time = GetTime() + 90000;
	self.next_torpedo_time = GetTime();
	self.razHasGunAttached = 1;
	self.razHasHelmet = 1;
	self.razHasLeftShoulderArmor = 1;
	self.razHasChestArmor = 1;
	self.razHasRightThighArmor = 1;
	self.razHasLeftThighArmor = 1;
	self.razHasGoneBerserk = 0;
	if(!isdefined(level.razGunHealth))
	{
		level.razGunHealth = 500;
	}
	if(!isdefined(level.razMaxHealth))
	{
		level.razMaxHealth = self.health;
	}
	if(!isdefined(level.razHelmetHealth))
	{
		level.razHelmetHealth = 100;
	}
	if(!isdefined(level.razLeftShoulderArmorHealth))
	{
		level.razLeftShoulderArmorHealth = 100;
	}
	if(!isdefined(level.razChestArmorHealth))
	{
		level.razChestArmorHealth = 100;
	}
	if(!isdefined(level.razThighArmorHealth))
	{
		level.razThighArmorHealth = 100;
	}
	self.maxhealth = level.razMaxHealth;
	self.razGunHealth = level.razGunHealth;
	self.razHelmetHealth = level.razHelmetHealth;
	self.razChestArmorHealth = level.razChestArmorHealth;
	self.razRightThighHealth = level.razThighArmorHealth;
	self.razLeftThighHealth = level.razThighArmorHealth;
	self.razLeftShoulderArmorHealth = level.razLeftShoulderArmorHealth;
	self.canBeTargetedByTurnedZombies = 1;
	self.no_widows_wine = 1;
	self.flame_fx_timeout = 3;
	AiUtility::AddAIOverrideDamageCallback(self, &razDamageCallback);
	self thread razGibZombiesOnMelee();
}

/*
	Name: razGibZombiesOnMelee
	Namespace: RazServerUtils
	Checksum: 0xAE1A3211
	Offset: 0x4558
	Size: 0x42D
	Parameters: 0
	Flags: Private
*/
function private razGibZombiesOnMelee()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("melee_fire");
		a_zombies = GetAIArchetypeArray("zombie");
		foreach(zombie in a_zombies)
		{
			if(isdefined(zombie.no_gib) && zombie.no_gib)
			{
				continue;
			}
			heightDiff = Abs(zombie.origin[2] - self.origin[2]);
			if(heightDiff > 50)
			{
				continue;
			}
			distance2DSq = Distance2DSquared(zombie.origin, self.origin);
			if(distance2DSq > 90 * 90)
			{
				continue;
			}
			raz_forward = AnglesToForward(self.angles);
			vect_to_enemy = zombie.origin - self.origin;
			if(VectorDot(raz_forward, vect_to_enemy) <= 0)
			{
				continue;
			}
			right_vect = AnglesToRight(self.angles);
			projected_distance = VectorDot(vect_to_enemy, right_vect);
			if(Abs(projected_distance) > 35)
			{
				continue;
			}
			b_gibbed = 0;
			VAL = RandomInt(100);
			if(VAL > 50)
			{
				zombie zombie_utility::zombie_head_gib();
				b_gibbed = 1;
			}
			VAL = RandomInt(100);
			if(VAL > 50)
			{
				if(!GibServerUtils::IsGibbed(zombie, 32))
				{
					GibServerUtils::GibRightArm(zombie);
					b_gibbed = 1;
				}
			}
			VAL = RandomInt(100);
			if(VAL > 50)
			{
				if(!GibServerUtils::IsGibbed(zombie, 16))
				{
					GibServerUtils::GibLeftArm(zombie);
					b_gibbed = 1;
				}
			}
			if(!(isdefined(b_gibbed) && b_gibbed))
			{
				if(!GibServerUtils::IsGibbed(zombie, 32))
				{
					GibServerUtils::GibRightArm(zombie);
					continue;
				}
				if(!GibServerUtils::IsGibbed(zombie, 16))
				{
					GibServerUtils::GibLeftArm(zombie);
					continue;
				}
				zombie zombie_utility::zombie_head_gib();
			}
		}
	}
}

/*
	Name: razInvalidateGibbedArmor
	Namespace: RazServerUtils
	Checksum: 0x470E5A3D
	Offset: 0x4990
	Size: 0x30B
	Parameters: 0
	Flags: Private
*/
function private razInvalidateGibbedArmor()
{
	if(!(isdefined(self.razHasGunAttached) && self.razHasGunAttached))
	{
		self HidePart("j_shouldertwist_ri_attach", "", 1);
		self HidePart("j_shoulder_ri_attach");
	}
	if(!(isdefined(self.razHasChestArmor) && self.razHasChestArmor))
	{
		self HidePart("j_spine4_attach", "", 1);
		self HidePart("j_spineupper_attach", "", 1);
		self HidePart("j_spinelower_attach", "", 1);
		self HidePart("j_mainroot_attach", "", 1);
		self HidePart("j_clavicle_ri_attachbp", "", 1);
		self HidePart("j_clavicle_le_attachbp", "", 1);
	}
	if(!(isdefined(self.razHasLeftShoulderArmor) && self.razHasLeftShoulderArmor))
	{
		self HidePart("j_shouldertwist_le_attach", "", 1);
		self HidePart("j_shoulder_le_attach", "", 1);
		self HidePart("j_clavicle_le_attach", "", 1);
	}
	if(!(isdefined(self.razHasRightThighArmor) && self.razHasRightThighArmor))
	{
		self HidePart("j_hiptwist_ri_attach", "", 1);
		self HidePart("j_hip_ri_attach", "", 1);
	}
	if(!(isdefined(self.razHasLeftThighArmor) && self.razHasLeftThighArmor))
	{
		self HidePart("j_hiptwist_le_attach", "", 1);
		self HidePart("j_hip_le_attach", "", 1);
	}
	if(!(isdefined(self.razHasHelmet) && self.razHasHelmet))
	{
		self HidePart("j_head_attach", "", 1);
	}
}

/*
	Name: razDamageCallback
	Namespace: RazServerUtils
	Checksum: 0x42526A18
	Offset: 0x4CA8
	Size: 0x5E3
	Parameters: 12
	Flags: Private
*/
function private razDamageCallback(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	entity = self;
	entity.last_damage_hit_armor = 0;
	if(isdefined(attacker) && attacker == entity)
	{
		return 0;
	}
	if(mod !== "MOD_PROJECTILE_SPLASH")
	{
		if(isdefined(entity.razHasGunAttached) && entity.razHasGunAttached)
		{
			b_hit_shoulder_weakpoint = raz_check_for_location_hit(entity, hitLoc, point, "right_arm_upper", 81, "j_shouldertwist_ri_attach");
			if(isdefined(b_hit_shoulder_weakpoint) && b_hit_shoulder_weakpoint)
			{
				entity razTrackGunDamage(damage, attacker);
				damage = damage * 0.1;
				if(!(isdefined(entity.razHasGunAttached) && entity.razHasGunAttached))
				{
					post_hit_health = entity.health - damage;
					gun_detach_damage = entity.maxhealth * 0.33;
					post_hit_health_percent = post_hit_health - gun_detach_damage / entity.maxhealth;
					if(post_hit_health_percent > 0.25)
					{
						return entity.health - entity.maxhealth * 0.25;
					}
					else
					{
						return gun_detach_damage;
					}
				}
				return damage;
			}
		}
		if(isdefined(entity.razHasChestArmor) && entity.razHasChestArmor)
		{
			b_hit_chest = raz_check_for_location_hit(entity, hitLoc, point, "torso_upper", 144, "j_spine4_attach");
			if(b_hit_chest || hitLoc === "torso_lower" || hitLoc === "torso_mid")
			{
				entity razTrackChestArmorDamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razHasLeftShoulderArmor) && entity.razHasLeftShoulderArmor)
		{
			b_hit_l_shoulder_armor = raz_check_for_location_hit(entity, hitLoc, point, "left_arm_upper", 81, "j_shouldertwist_le_attach");
			if(b_hit_l_shoulder_armor)
			{
				entity razTrackLeftShoulderArmorDamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razHasRightThighArmor) && entity.razHasRightThighArmor)
		{
			b_hit_r_thigh_armor = raz_check_for_location_hit(entity, hitLoc, point, "right_leg_upper", 81, "j_hiptwist_ri_attach");
			if(b_hit_r_thigh_armor)
			{
				entity razTrackRightThighArmorDamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razHasLeftThighArmor) && entity.razHasLeftThighArmor)
		{
			b_hit_l_thigh_armor = raz_check_for_location_hit(entity, hitLoc, point, "left_leg_upper", 81, "j_hiptwist_le_attach");
			if(b_hit_l_thigh_armor)
			{
				entity razTrackLeftThighArmorDamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razHasHelmet) && entity.razHasHelmet)
		{
			b_hit_head = raz_check_for_location_hit(entity, hitLoc, point, "head", 121, "j_head");
			if(b_hit_head || hitLoc === "neck" || hitLoc === "helmet")
			{
				entity razTrackHelmetDamage(damage, attacker);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
	}
	return damage;
}

/*
	Name: raz_check_for_location_hit
	Namespace: RazServerUtils
	Checksum: 0xFEB6B01A
	Offset: 0x5298
	Size: 0xD3
	Parameters: 6
	Flags: Private
*/
function private raz_check_for_location_hit(entity, hitLoc, point, location, hit_radius_sq, tag)
{
	b_hit_location = 0;
	if(isdefined(hitLoc) && hitLoc != "none")
	{
		if(hitLoc == location)
		{
			b_hit_location = 1;
		}
	}
	else
	{
		dist_sq = DistanceSquared(point, entity GetTagOrigin(tag));
		if(dist_sq <= hit_radius_sq)
		{
			b_hit_location = 1;
		}
	}
	return b_hit_location;
}

/*
	Name: razTrackGunDamage
	Namespace: RazServerUtils
	Checksum: 0x5BDFB813
	Offset: 0x5378
	Size: 0x30D
	Parameters: 2
	Flags: Private
*/
function private razTrackGunDamage(damage, attacker)
{
	entity = self;
	entity.razGunHealth = entity.razGunHealth - damage;
	post_hit_health = entity.health - damage;
	post_hit_health_percent = post_hit_health / entity.maxhealth;
	if(entity.razGunHealth > 0)
	{
		entity clientfield::increment("raz_gun_weakpoint_hit", 1);
	}
	if(entity.razGunHealth <= 0)
	{
		entity.razGunHealth = 0;
		entity clientfield::set("raz_detach_gun", 1);
		entity.razHasGunAttached = 0;
		entity.invoke_sprint_time = undefined;
		entity.started_running = 1;
		entity thread RazBehavior::razSprintKnockdownZombies();
		blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
		blackboard::SetBlackBoardAttribute(entity, "_gibbed_limbs", "right_arm");
		blackboard::SetBlackBoardAttribute(entity, "_gib_location", "right_arm");
		explosion_max_damage = 0.5 * entity.maxhealth;
		explosion_min_damage = 0.25 * entity.maxhealth;
		weapon = GetWeapon("raz_melee");
		RadiusDamage(self.origin + VectorScale((0, 0, 1), 18), 128, explosion_max_damage, explosion_min_damage, entity, "MOD_PROJECTILE_SPLASH", weapon);
		self Detach("c_zom_dlc3_raz_cannon_arm");
		self HidePart("j_shouldertwist_ri_attach", "", 1);
		self HidePart("j_shoulder_ri_attach");
		razInvalidateGibbedArmor();
		level notify("raz_arm_detach", attacker);
		self notify("raz_arm_detach", attacker);
	}
}

/*
	Name: razTrackHelmetDamage
	Namespace: RazServerUtils
	Checksum: 0xB7EF4B63
	Offset: 0x5690
	Size: 0xED
	Parameters: 2
	Flags: Private
*/
function private razTrackHelmetDamage(damage, attacker)
{
	entity = self;
	entity.razHelmetHealth = entity.razHelmetHealth - damage;
	if(entity.razHelmetHealth <= 0)
	{
		entity clientfield::set("raz_detach_helmet", 1);
		entity HidePart("j_head_attach", "", 1);
		entity.razHasHelmet = 0;
		blackboard::SetBlackBoardAttribute(entity, "_gib_location", "head");
		level notify("raz_mask_destroyed", attacker);
	}
}

/*
	Name: razTrackChestArmorDamage
	Namespace: RazServerUtils
	Checksum: 0x3D91B31B
	Offset: 0x5788
	Size: 0x19B
	Parameters: 1
	Flags: Private
*/
function private razTrackChestArmorDamage(damage)
{
	entity = self;
	entity.razChestArmorHealth = entity.razChestArmorHealth - damage;
	if(entity.razChestArmorHealth <= 0)
	{
		entity clientfield::set("raz_detach_chest_armor", 1);
		entity HidePart("j_spine4_attach", "", 1);
		entity HidePart("j_spineupper_attach", "", 1);
		entity HidePart("j_spinelower_attach", "", 1);
		entity HidePart("j_mainroot_attach", "", 1);
		entity HidePart("j_clavicle_ri_attachbp", "", 1);
		entity HidePart("j_clavicle_le_attachbp", "", 1);
		entity.razHasChestArmor = 0;
		blackboard::SetBlackBoardAttribute(entity, "_gib_location", "arms");
	}
}

/*
	Name: razTrackLeftShoulderArmorDamage
	Namespace: RazServerUtils
	Checksum: 0x51DD4760
	Offset: 0x5930
	Size: 0x123
	Parameters: 1
	Flags: Private
*/
function private razTrackLeftShoulderArmorDamage(damage)
{
	entity = self;
	entity.razLeftShoulderArmorHealth = entity.razLeftShoulderArmorHealth - damage;
	if(entity.razLeftShoulderArmorHealth <= 0)
	{
		entity clientfield::set("raz_detach_l_shoulder_armor", 1);
		entity HidePart("j_shouldertwist_le_attach", "", 1);
		entity HidePart("j_shoulder_le_attach", "", 1);
		entity HidePart("j_clavicle_le_attach", "", 1);
		entity.razHasLeftShoulderArmor = 0;
		blackboard::SetBlackBoardAttribute(entity, "_gib_location", "left_arm");
	}
}

/*
	Name: razTrackLeftThighArmorDamage
	Namespace: RazServerUtils
	Checksum: 0xEA7F73B6
	Offset: 0x5A60
	Size: 0xFB
	Parameters: 1
	Flags: Private
*/
function private razTrackLeftThighArmorDamage(damage)
{
	entity = self;
	entity.razLeftThighHealth = entity.razLeftThighHealth - damage;
	if(entity.razLeftThighHealth <= 0)
	{
		entity clientfield::set("raz_detach_l_thigh_armor", 1);
		entity HidePart("j_hiptwist_le_attach", "", 1);
		entity HidePart("j_hip_le_attach", "", 1);
		entity.razHasLeftThighArmor = 0;
		blackboard::SetBlackBoardAttribute(entity, "_gib_location", "left_leg");
	}
}

/*
	Name: razTrackRightThighArmorDamage
	Namespace: RazServerUtils
	Checksum: 0x16649441
	Offset: 0x5B68
	Size: 0xFB
	Parameters: 1
	Flags: Private
*/
function private razTrackRightThighArmorDamage(damage)
{
	entity = self;
	entity.razRightThighHealth = entity.razRightThighHealth - damage;
	if(entity.razRightThighHealth <= 0)
	{
		entity clientfield::set("raz_detach_r_thigh_armor", 1);
		entity HidePart("j_hiptwist_ri_attach", "", 1);
		entity HidePart("j_hip_ri_attach", "", 1);
		entity.razHasRightThighArmor = 0;
		blackboard::SetBlackBoardAttribute(entity, "_gib_location", "right_leg");
	}
}

