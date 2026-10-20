#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_idgun;

#namespace zm_ai_margwa;

/*
	Name: init
	Namespace: zm_ai_margwa
	Checksum: 0x79B29F7
	Offset: 0x670
	Size: 0x1AB
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmmargwabehaviorsandasm();
	level.margwa_spawners = GetEntArray("zombie_margwa_spawner", "script_noteworthy");
	level.margwa_locations = struct::get_array("margwa_location", "script_noteworthy");
	level thread AAT::register_immunity("zm_aat_blast_furnace", "margwa", 0, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "margwa", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "margwa", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "margwa", 0, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "margwa", 1, 1, 1);
	spawner::add_archetype_spawn_function("margwa", &margwa_setup);
	/#
		execdevgui("Dev Block strings are not supported");
		thread margwa_devgui();
	#/
}

/*
	Name: function_4092fa4d
	Namespace: zm_ai_margwa
	Checksum: 0xF5BCDACB
	Offset: 0x828
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_4092fa4d()
{
	wait(20);
	for(i = 0; i < 1; i++)
	{
		margwa_location = ArrayGetClosest(level.players[0].origin, level.margwa_locations);
		margwa = spawn_margwa(margwa_location);
		wait(0.5);
	}
}

/*
	Name: initzmmargwabehaviorsandasm
	Namespace: zm_ai_margwa
	Checksum: 0x8F7013EE
	Offset: 0x8C8
	Size: 0x28B
	Parameters: 0
	Flags: Private
*/
function private initzmmargwabehaviorsandasm()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaTargetService", &zm_margwa_target_service);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaTeleportService", &zm_margwa_teleport_service);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaZoneService", &zm_margwa_zone_service);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaPushService", &zm_margwa_push_service);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaOctobombService", &zm_margwa_octobomb_service);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaVortexService", &zm_margwa_vortex_service);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaShouldSmashAttack", &zm_margwa_should_smash_attack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaShouldSwipeAttack", &zm_margwa_should_swipe_attack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaShouldOctobombAttack", &zm_margwa_should_octobomb_attack);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaShouldMove", &zm_margwa_should_move);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zmMargwaSwipeAttackAction", &zm_margwa_swipe_attack_action, &zm_margwa_swipe_attack_action_update, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zmMargwaOctobombAttackAction", &zm_margwa_octobomb_attack_action, &zm_margwa_octobomb_attack_action_update, &zm_margwa_octobomb_attack_action_terminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaSmashAttackTerminate", &zm_margwa_smash_attack_terminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaSwipeAttackTerminate", &zm_margwa_swipe_attack_terminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMargwaTeleportInTerminate", &zm_margwa_teleport_in_terminate);
}

/*
	Name: zm_margwa_target_service
	Namespace: zm_ai_margwa
	Checksum: 0x30BDA08B
	Offset: 0xB60
	Size: 0x1F1
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_target_service(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(isdefined(entity.isTeleporting) && entity.isTeleporting)
	{
		return 0;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	entity zombie_utility::run_ignore_player_handler();
	player = zm_utility::get_closest_valid_player(entity.origin, entity.ignore_player);
	entity.favoriteenemy = player;
	if(!isdefined(player) || zm_behavior::zombieShouldMoveAwayCondition(entity))
	{
		zone = zm_utility::get_current_zone();
		if(isdefined(zone))
		{
			wait_locations = level.zones[zone].a_loc_types["wait_location"];
			if(isdefined(wait_locations) && wait_locations.size > 0)
			{
				return entity MargwaServerUtils::margwaSetGoal(wait_locations[0].origin, 64, 30);
			}
		}
		entity SetGoal(entity.origin);
		return 0;
	}
	return entity MargwaServerUtils::margwaSetGoal(entity.favoriteenemy.origin, 64, 30);
}

/*
	Name: zm_margwa_teleport_service
	Namespace: zm_ai_margwa
	Checksum: 0xBA288AD3
	Offset: 0xD60
	Size: 0x2E3
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_teleport_service(entity)
{
	if(isdefined(entity.favoriteenemy))
	{
		if(isdefined(entity.favoriteenemy.on_train) && entity.favoriteenemy.on_train)
		{
			var_d3443466 = get_doors_state();
			if(isdefined(entity.locked_in_train) && entity.locked_in_train && (!isdefined(var_d3443466) && var_d3443466))
			{
				return 0;
			}
		}
	}
	if(!isdefined(entity.needTeleportOut) && entity.needTeleportOut && (!isdefined(entity.isTeleporting) && entity.isTeleporting) && isdefined(entity.favoriteenemy))
	{
		var_1dd5ad4d = 0;
		dist_sq = DistanceSquared(self.favoriteenemy.origin, entity.origin);
		var_9c921a96 = 2250000;
		/#
			var_7a419cfb = GetDvarInt("Dev Block strings are not supported") * 12;
			var_9c921a96 = var_7a419cfb * var_7a419cfb;
		#/
		if(dist_sq > var_9c921a96)
		{
			if(isdefined(entity.destroy_octobomb))
			{
				var_1dd5ad4d = 0;
			}
			else
			{
				var_1dd5ad4d = 1;
			}
		}
		else if(isdefined(level.var_785a0d1e))
		{
			if(entity [[level.var_785a0d1e]]())
			{
				var_1dd5ad4d = 1;
			}
		}
		if(var_1dd5ad4d)
		{
			if(isdefined(self.favoriteenemy.zone_name))
			{
				wait_locations = level.zones[self.favoriteenemy.zone_name].a_loc_types["wait_location"];
				if(isdefined(wait_locations) && wait_locations.size > 0)
				{
					wait_locations = Array::randomize(wait_locations);
					entity.needTeleportOut = 1;
					entity.teleportPos = wait_locations[0].origin;
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: zm_margwa_zone_service
	Namespace: zm_ai_margwa
	Checksum: 0x15548D70
	Offset: 0x1050
	Size: 0xAB
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_zone_service(entity)
{
	if(isdefined(entity.isTeleporting) && entity.isTeleporting)
	{
		return 0;
	}
	if(!isdefined(entity.zone_name))
	{
		entity.zone_name = zm_utility::get_current_zone();
	}
	else
	{
		entity.previous_zone_name = entity.zone_name;
		entity.zone_name = zm_utility::get_current_zone();
	}
	return 1;
}

/*
	Name: zm_margwa_push_service
	Namespace: zm_ai_margwa
	Checksum: 0xBD91E702
	Offset: 0x1108
	Size: 0x225
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_push_service(entity)
{
	if(entity.zombie_move_speed == "walk")
	{
		return 0;
	}
	zombies = zombie_utility::get_round_enemy_array();
	foreach(zombie in zombies)
	{
		distSq = DistanceSquared(entity.origin, zombie.origin);
		if(distSq < 2304)
		{
			zombie.pushed = 1;
			var_16ce8ab3 = self.origin - zombie.origin;
			var_e1fcfc7c = VectorNormalize((var_16ce8ab3[0], var_16ce8ab3[1], 0));
			zombie_right = AnglesToRight(zombie.angles);
			zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
			dot = VectorDot(var_e1fcfc7c, zombie_right_2d);
			if(dot > 0)
			{
				zombie.PUSH_DIRECTION = "left";
				continue;
			}
			zombie.PUSH_DIRECTION = "right";
		}
	}
}

/*
	Name: zm_margwa_octobomb_service
	Namespace: zm_ai_margwa
	Checksum: 0x2BA1C7BC
	Offset: 0x1338
	Size: 0x159
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_octobomb_service(entity)
{
	if(isdefined(entity.destroy_octobomb))
	{
		entity SetGoal(entity.destroy_octobomb.origin);
		return 1;
	}
	if(isdefined(level.octobombs))
	{
		foreach(octobomb in level.octobombs)
		{
			if(isdefined(octobomb))
			{
				dist_sq = DistanceSquared(octobomb.origin, self.origin);
				if(dist_sq < 360000)
				{
					entity.destroy_octobomb = octobomb;
					entity SetGoal(octobomb.origin);
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: function_604404
	Namespace: zm_ai_margwa
	Checksum: 0xA0955BAA
	Offset: 0x14A0
	Size: 0x9D
	Parameters: 1
	Flags: Private
*/
function private function_604404(entity)
{
	if(isdefined(self.react))
	{
		foreach(react in self.react)
		{
			if(react == entity)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: function_e92d3bb1
	Namespace: zm_ai_margwa
	Checksum: 0x64EC76BC
	Offset: 0x1548
	Size: 0x39
	Parameters: 1
	Flags: Private
*/
function private function_e92d3bb1(entity)
{
	if(!isdefined(self.react))
	{
		self.react = [];
	}
	self.react[self.react.size] = entity;
}

/*
	Name: zm_margwa_vortex_service
	Namespace: zm_ai_margwa
	Checksum: 0x21401142
	Offset: 0x1590
	Size: 0x1B9
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_vortex_service(entity)
{
	if(!(isdefined(entity.canStun) && entity.canStun))
	{
		return 0;
	}
	if(isdefined(level.vortex_manager) && isdefined(level.vortex_manager.a_active_vorticies))
	{
		foreach(vortex in level.vortex_manager.a_active_vorticies)
		{
			if(!vortex function_604404(entity))
			{
				dist_sq = DistanceSquared(vortex.origin, self.origin);
				if(dist_sq < 9216)
				{
					entity.reactIDGun = 1;
					if(isdefined(vortex.weapon) && idgun::function_9b7ac6a9(vortex.weapon))
					{
						blackboard::SetBlackBoardAttribute(entity, "_zombie_damageweapon_type", "packed");
					}
					vortex function_e92d3bb1(entity);
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: zm_margwa_should_smash_attack
	Namespace: zm_ai_margwa
	Checksum: 0xEEC30B91
	Offset: 0x1758
	Size: 0x69
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_should_smash_attack(entity)
{
	if(isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	if(!isdefined(entity.next_attack) || entity.next_attack != 1)
	{
		return 0;
	}
	return MargwaBehavior::margwaShouldSmashAttack(entity);
}

/*
	Name: zm_margwa_should_swipe_attack
	Namespace: zm_ai_margwa
	Checksum: 0xFF4528F5
	Offset: 0x17D0
	Size: 0x69
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_should_swipe_attack(entity)
{
	if(isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	if(!isdefined(entity.next_attack) || entity.next_attack != 2)
	{
		return 0;
	}
	return MargwaBehavior::margwaShouldSwipeAttack(entity);
}

/*
	Name: zm_margwa_should_octobomb_attack
	Namespace: zm_ai_margwa
	Checksum: 0xE9D4295A
	Offset: 0x1848
	Size: 0xBD
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_should_octobomb_attack(entity)
{
	if(!isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.destroy_octobomb.origin) > 16384)
	{
		return 0;
	}
	yaw = Abs(zombie_utility::GetYawToSpot(entity.destroy_octobomb.origin));
	if(yaw > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: zm_margwa_should_move
	Namespace: zm_ai_margwa
	Checksum: 0x40ABB118
	Offset: 0x1910
	Size: 0xC5
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_should_move(entity)
{
	if(isdefined(entity.needTeleportOut) && entity.needTeleportOut)
	{
		return 0;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		if(zm_margwa_should_octobomb_attack(entity))
		{
			return 0;
		}
	}
	else if(zm_margwa_should_swipe_attack(entity))
	{
		return 0;
	}
	if(zm_margwa_should_smash_attack(entity))
	{
		return 0;
	}
	if(entity HasPath())
	{
		return 1;
	}
	return 0;
}

/*
	Name: zm_margwa_octobomb_attack_action
	Namespace: zm_ai_margwa
	Checksum: 0x7D85B2AD
	Offset: 0x19E0
	Size: 0x6F
	Parameters: 2
	Flags: Private
*/
function private zm_margwa_octobomb_attack_action(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	if(!isdefined(entity.octobomb_end_time))
	{
		entity.octobomb_end_time = GetTime() + randomIntRange(3000, 4000);
	}
	return 5;
}

/*
	Name: zm_margwa_octobomb_attack_action_update
	Namespace: zm_ai_margwa
	Checksum: 0xC0E5F83C
	Offset: 0x1A58
	Size: 0x5D
	Parameters: 2
	Flags: Private
*/
function private zm_margwa_octobomb_attack_action_update(entity, asmStateName)
{
	if(!isdefined(entity.destroy_octobomb))
	{
		return 4;
	}
	if(isdefined(entity.octobomb_end_time) && GetTime() > entity.octobomb_end_time)
	{
		return 4;
	}
	return 5;
}

/*
	Name: zm_margwa_octobomb_attack_action_terminate
	Namespace: zm_ai_margwa
	Checksum: 0xC7367E43
	Offset: 0x1AC0
	Size: 0x55
	Parameters: 2
	Flags: Private
*/
function private zm_margwa_octobomb_attack_action_terminate(entity, asmStateName)
{
	if(isdefined(entity.destroy_octobomb))
	{
		entity.destroy_octobomb detonate();
	}
	entity.octobomb_end_time = undefined;
	return 4;
}

/*
	Name: zm_margwa_swipe_attack_action
	Namespace: zm_ai_margwa
	Checksum: 0xE77B1353
	Offset: 0x1B20
	Size: 0xFF
	Parameters: 2
	Flags: Private
*/
function private zm_margwa_swipe_attack_action(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	if(!isdefined(entity.swipe_end_time))
	{
		swipeActionAST = entity ASTSearch(istring(asmStateName));
		swipeActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap(entity, swipeActionAST["animation"]);
		swipeActionTime = getanimlength(swipeActionAnimation) * 1000;
		entity.swipe_end_time = GetTime() + swipeActionTime;
	}
	MargwaBehavior::margwaSwipeAttackStart(entity);
	return 5;
}

/*
	Name: zm_margwa_swipe_attack_action_update
	Namespace: zm_ai_margwa
	Checksum: 0x615D79D9
	Offset: 0x1C28
	Size: 0x45
	Parameters: 2
	Flags: Private
*/
function private zm_margwa_swipe_attack_action_update(entity, asmStateName)
{
	if(isdefined(entity.swipe_end_time) && GetTime() > entity.swipe_end_time)
	{
		return 4;
	}
	return 5;
}

/*
	Name: zm_margwa_smash_attack_terminate
	Namespace: zm_ai_margwa
	Checksum: 0x2771DC5E
	Offset: 0x1C78
	Size: 0x4B
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_smash_attack_terminate(entity)
{
	entity.swipe_end_time = undefined;
	entity function_941cbfc5();
	MargwaBehavior::margwaSmashAttackTerminate(entity);
}

/*
	Name: zm_margwa_swipe_attack_terminate
	Namespace: zm_ai_margwa
	Checksum: 0x4E4DEEEC
	Offset: 0x1CD0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_swipe_attack_terminate(entity)
{
	entity.swipe_end_time = undefined;
	entity function_941cbfc5();
}

/*
	Name: zm_margwa_teleport_in_terminate
	Namespace: zm_ai_margwa
	Checksum: 0x9E26FEB2
	Offset: 0x1D10
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private zm_margwa_teleport_in_terminate(entity)
{
	MargwaBehavior::margwaTeleportInTerminate(entity);
	entity.previous_zone_name = entity.zone_name;
	entity.zone_name = zm_utility::get_current_zone();
}

/*
	Name: margwa_wait
	Namespace: zm_ai_margwa
	Checksum: 0x72678812
	Offset: 0x1D78
	Size: 0x4B
	Parameters: 0
	Flags: Private
*/
function private margwa_wait()
{
	self endon("death");
	entity.waiting = 1;
	util::wait_network_frame();
	entity.waiting = 0;
}

/*
	Name: margwa_setup
	Namespace: zm_ai_margwa
	Checksum: 0x1E890827
	Offset: 0x1DD0
	Size: 0xFB
	Parameters: 0
	Flags: Private
*/
function private margwa_setup()
{
	self.destroyHeadCB = &margwa_destroy_head;
	self.bodyfallCB = &margwa_bodyfall;
	self.var_16ec9b37 = &function_a89905c6;
	self.chop_actor_cb = &margwa_chop_actor;
	self.var_a3b60c68 = &function_dbd9ba44;
	self.var_de36fc8 = &function_2aa0209c;
	self.smashAttackCB = &margwa_smash_attack;
	self.lightning_chain_immune = 1;
	self.ignore_game_over_death = 1;
	self.should_turn = 1;
	self.jawAnimEnabled = 1;
	self.sword_kill_power = 5;
	self function_941cbfc5();
}

/*
	Name: margwa_destroy_head
	Namespace: zm_ai_margwa
	Checksum: 0x7D5B50EE
	Offset: 0x1ED8
	Size: 0x223
	Parameters: 2
	Flags: Private
*/
function private margwa_destroy_head(modelHit, attacker)
{
	if(isPlayer(attacker) && (!isdefined(self.deathpoints_already_given) && self.deathpoints_already_given) && (!isdefined(level.var_1f6ca9c8) && level.var_1f6ca9c8))
	{
		attacker zm_score::player_add_points("bonus_points_powerup", 500);
	}
	right = AnglesToRight(self.angles);
	spawn_pos = self.origin + AnglesToRight(self.angles) + VectorScale((0, 0, 1), 128);
	var_df9f2e65 = self.origin - AnglesToRight(self.angles) + VectorScale((0, 0, 1), 128);
	loc = spawnstruct();
	loc.origin = spawn_pos;
	loc.angles = self.angles;
	self margwa_head_explosion();
	spawner_override = undefined;
	if(isdefined(level.var_39c0c115))
	{
		spawner_override = level.var_39c0c115;
	}
	zm_ai_wasp::special_wasp_spawn(1, loc, 32, 32, 1, 0, 0, spawner_override);
	if(isdefined(self.var_26f9f957))
	{
		self thread [[self.var_26f9f957]](modelHit, attacker);
	}
	if(isdefined(level.hero_power_update))
	{
		[[level.hero_power_update]](attacker, self);
	}
	loc struct::delete();
}

/*
	Name: margwa_bodyfall
	Namespace: zm_ai_margwa
	Checksum: 0xADBDD166
	Offset: 0x2108
	Size: 0x173
	Parameters: 0
	Flags: Private
*/
function private margwa_bodyfall()
{
	power_up_origin = self.origin + VectorScale(AnglesToForward(self.angles), 32) + VectorScale((0, 0, 1), 16);
	if(isdefined(power_up_origin) && (!isdefined(self.no_powerups) && self.no_powerups))
	{
		var_3bd46762 = [];
		foreach(powerup in level.zombie_powerup_array)
		{
			if(powerup == "carpenter")
			{
				continue;
			}
			if(![[level.zombie_powerups[powerup].func_should_drop_with_regular_powerups]]())
			{
				continue;
			}
			var_3bd46762[var_3bd46762.size] = powerup;
		}
		var_3dc91cb3 = Array::random(var_3bd46762);
		level thread zm_powerups::specific_powerup_drop(var_3dc91cb3, power_up_origin);
	}
}

/*
	Name: margwa_head_explosion
	Namespace: zm_ai_margwa
	Checksum: 0xEE1C770F
	Offset: 0x2288
	Size: 0xE9
	Parameters: 0
	Flags: Private
*/
function private margwa_head_explosion()
{
	players = GetPlayers();
	foreach(player in players)
	{
		distSq = DistanceSquared(self.origin, player.origin);
		if(distSq < 16384)
		{
			player clientfield::increment_to_player("margwa_head_explosion");
		}
	}
}

/*
	Name: spawn_margwa
	Namespace: zm_ai_margwa
	Checksum: 0x6E188FB3
	Offset: 0x2380
	Size: 0x223
	Parameters: 1
	Flags: None
*/
function spawn_margwa(s_location)
{
	if(isdefined(level.margwa_spawners[0]))
	{
		level.margwa_spawners[0].script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(level.margwa_spawners[0], "margwa", s_location);
		ai DisableAimAssist();
		ai.actor_damage_func = &MargwaServerUtils::margwaDamage;
		ai.canDamage = 0;
		ai.targetname = "margwa";
		ai.holdFire = 1;
		e_player = zm_utility::get_closest_player(s_location.origin);
		v_dir = e_player.origin - s_location.origin;
		v_dir = VectorNormalize(v_dir);
		v_angles = VectorToAngles(v_dir);
		ai ForceTeleport(s_location.origin, v_angles);
		ai margwa_freeze();
		if(isdefined(level.var_7cef68dc))
		{
			ai thread function_8d578a58();
		}
		ai.ignore_round_robbin_death = 1;
		/#
			ai.ignore_devgui_death = 1;
			ai thread function_618bf323();
		#/
		ai thread function_3d56f587();
		return ai;
	}
	return undefined;
}

/*
	Name: function_618bf323
	Namespace: zm_ai_margwa
	Checksum: 0xDDDFA2AC
	Offset: 0x25B0
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function function_618bf323()
{
	self endon("death");
	/#
		while(1)
		{
			if(isdefined(self.debugHealth) && self.debugHealth)
			{
				if(isdefined(self.head))
				{
					foreach(head in self.head)
					{
						if(head.health > 0)
						{
							head_origin = self GetTagOrigin(head.tag);
							print3d(head_origin + VectorScale((0, 0, 1), 15), head.health, (0, 0.8, 0.6), 3);
						}
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_3d56f587
	Namespace: zm_ai_margwa
	Checksum: 0x9B8717E7
	Offset: 0x2708
	Size: 0x6B
	Parameters: 0
	Flags: Private
*/
function private function_3d56f587()
{
	util::wait_network_frame();
	self clientfield::increment("margwa_fx_spawn");
	wait(3);
	self margwa_unfreeze();
	self.canDamage = 1;
	self.needSpawn = 1;
}

/*
	Name: margwa_freeze
	Namespace: zm_ai_margwa
	Checksum: 0xF732D2AB
	Offset: 0x2780
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private margwa_freeze()
{
	self.isFrozen = 1;
	self ghost();
	self notsolid();
	self PathMode("dont move");
}

/*
	Name: margwa_unfreeze
	Namespace: zm_ai_margwa
	Checksum: 0xA6493A8F
	Offset: 0x27E8
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private margwa_unfreeze()
{
	self.isFrozen = 0;
	self show();
	self solid();
	self PathMode("move allowed");
}

/*
	Name: function_8d578a58
	Namespace: zm_ai_margwa
	Checksum: 0xE6AB496D
	Offset: 0x2850
	Size: 0x123
	Parameters: 0
	Flags: Private
*/
function private function_8d578a58()
{
	self waittill("death", attacker, mod, weapon);
	foreach(player in level.players)
	{
		if(player.am_i_valid && (!isdefined(level.var_1f6ca9c8) && level.var_1f6ca9c8) && (!isdefined(self.no_xp) && self.no_xp))
		{
			scoreevents::processScoreEvent("kill_margwa", player, undefined, undefined);
		}
	}
	level notify("margwa_died");
	[[level.var_7cef68dc]]();
}

/*
	Name: margwa_chop_actor
	Namespace: zm_ai_margwa
	Checksum: 0x54D0CBF8
	Offset: 0x2980
	Size: 0x393
	Parameters: 3
	Flags: Private
*/
function private margwa_chop_actor(entity, inflictor, weapon)
{
	if(!(isdefined(entity.canDamage) && entity.canDamage))
	{
		return 0;
	}
	var_ddc770da = [];
	if(isdefined(entity.head))
	{
		foreach(head in entity.head)
		{
			if(head.health > 0 && head.canDamage)
			{
				var_ddc770da[var_ddc770da.size] = head;
			}
		}
	}
	else if(var_ddc770da.size > 0)
	{
		view_pos = self GetWeaponMuzzlePoint();
		forward_view_angles = self GetWeaponForwardDir();
		var_d8748e76 = undefined;
		foreach(head in var_ddc770da)
		{
			head_pos = entity GetTagOrigin(head.tag);
			var_b01d89e6 = DistanceSquared(head_pos, view_pos);
			var_ca049230 = VectorNormalize(head_pos - view_pos);
			if(!isdefined(var_d8748e76))
			{
				var_d8748e76 = head;
				var_e4facdff = VectorDot(forward_view_angles, var_ca049230);
				continue;
			}
			dot = VectorDot(forward_view_angles, var_ca049230);
			if(dot > var_e4facdff)
			{
				var_e4facdff = dot;
				var_d8748e76 = head;
			}
		}
		if(isdefined(var_d8748e76))
		{
			var_d8748e76.health = var_d8748e76.health - 1750;
			entity clientfield::increment(var_d8748e76.impactCF);
			if(var_d8748e76.health <= 0)
			{
				if(entity MargwaServerUtils::margwaKillHead(var_d8748e76.model, self))
				{
					entity kill(self.origin, undefined, undefined, weapon);
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: function_dbd9ba44
	Namespace: zm_ai_margwa
	Checksum: 0xAA7CA0D3
	Offset: 0x2D20
	Size: 0x4B
	Parameters: 2
	Flags: Private
*/
function private function_dbd9ba44(entity, weapon)
{
	if(isdefined(entity.canStun) && entity.canStun)
	{
		entity.reactStun = 1;
	}
}

/*
	Name: function_aea7f2f4
	Namespace: zm_ai_margwa
	Checksum: 0xF7D7753A
	Offset: 0x2D78
	Size: 0x27
	Parameters: 0
	Flags: Private
*/
function private function_aea7f2f4()
{
	if(isdefined(self.canStun) && self.canStun)
	{
		self.reactIDGun = 1;
	}
}

/*
	Name: function_2aa0209c
	Namespace: zm_ai_margwa
	Checksum: 0x4D91D47
	Offset: 0x2DA8
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private function_2aa0209c(trap)
{
	if(isdefined(self.isTeleporting) && self.isTeleporting || (isdefined(self.needTeleportOut) && self.needTeleportOut))
	{
		return;
	}
	self.needTeleportOut = 1;
	pos = self.origin + VectorScale(AnglesToForward(self.angles), 200);
	navmesh_pos = GetClosestPointOnNavMesh(pos, 64, 30);
	self.teleportPos = navmesh_pos;
	/#
		recordLine(self.origin, self.teleportPos);
	#/
}

/*
	Name: margwa_smash_attack
	Namespace: zm_ai_margwa
	Checksum: 0x10002F0F
	Offset: 0x2E90
	Size: 0x129
	Parameters: 0
	Flags: Private
*/
function private margwa_smash_attack()
{
	zombies = zombie_utility::get_round_enemy_array();
	foreach(zombie in zombies)
	{
		smashPos = self.origin + VectorScale(AnglesToForward(self.angles), 60);
		distSq = DistanceSquared(smashPos, zombie.origin);
		if(distSq < 20736)
		{
			zombie.KNOCKDOWN = 1;
			self function_f1358c65(zombie);
		}
	}
}

/*
	Name: function_941cbfc5
	Namespace: zm_ai_margwa
	Checksum: 0x2915FDF4
	Offset: 0x2FC8
	Size: 0x53
	Parameters: 0
	Flags: Private
*/
function private function_941cbfc5()
{
	r = randomIntRange(0, 100);
	if(r < 40)
	{
		self.next_attack = 2;
	}
	else
	{
		self.next_attack = 1;
	}
}

/*
	Name: function_f1358c65
	Namespace: zm_ai_margwa
	Checksum: 0x90B23D2F
	Offset: 0x3028
	Size: 0x27B
	Parameters: 1
	Flags: Private
*/
function private function_f1358c65(zombie)
{
	var_16ce8ab3 = self.origin - zombie.origin;
	var_e1fcfc7c = VectorNormalize((var_16ce8ab3[0], var_16ce8ab3[1], 0));
	zombie_forward = AnglesToForward(zombie.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(zombie.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(var_e1fcfc7c, zombie_forward_2d);
	if(dot >= 0.5)
	{
		zombie.knockdown_direction = "front";
		zombie.getup_direction = "getup_back";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(var_e1fcfc7c, zombie_right_2d);
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
	}
	else
	{
		zombie.knockdown_direction = "back";
		zombie.getup_direction = "getup_belly";
	}
}

/*
	Name: margwa_devgui
	Namespace: zm_ai_margwa
	Checksum: 0x64709624
	Offset: 0x32B0
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private margwa_devgui()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::add_custom_devgui_callback(&margwa_devgui_callback);
	#/
}

/*
	Name: margwa_devgui_callback
	Namespace: zm_ai_margwa
	Checksum: 0xAC09A861
	Offset: 0x3300
	Size: 0x1F5
	Parameters: 1
	Flags: Private
*/
function private margwa_devgui_callback(cmd)
{
	/#
		players = GetPlayers();
		margwas = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		margwa = ArrayGetClosest(GetPlayers()[0].origin, margwas);
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				margwa_location = ArrayGetClosest(players[0].origin, level.margwa_locations);
				margwa = spawn_margwa(margwa_location);
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(margwa))
				{
					margwa kill();
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(margwa))
				{
					if(!isdefined(margwa.debugHitLoc))
					{
						margwa.debugHitLoc = 1;
					}
					else
					{
						margwa.debugHitLoc = !margwa.debugHitLoc;
					}
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(margwa))
				{
					if(!isdefined(margwa.debugHealth))
					{
						margwa.debugHealth = 1;
					}
					else
					{
						margwa.debugHealth = !margwa.debugHealth;
					}
				}
				break;
			}
		}
	#/
}

/*
	Name: function_a89905c6
	Namespace: zm_ai_margwa
	Checksum: 0x63EDE08F
	Offset: 0x3500
	Size: 0xD5
	Parameters: 0
	Flags: Private
*/
function private function_a89905c6()
{
	/#
		rate = 1;
		if(self.zombie_move_speed == "Dev Block strings are not supported")
		{
			percent = GetDvarInt("Dev Block strings are not supported");
			rate = float(percent / 100);
		}
		else if(self.zombie_move_speed == "Dev Block strings are not supported")
		{
			percent = GetDvarInt("Dev Block strings are not supported");
			rate = float(percent / 100);
		}
		return rate;
	#/
}

