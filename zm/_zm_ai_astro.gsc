#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_c0afbdaf;

/*
	Name: init
	Namespace: namespace_c0afbdaf
	Checksum: 0xDB52656A
	Offset: 0x688
	Size: 0x283
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_ecd296a1();
	spawner::add_archetype_spawn_function("astronaut", &function_c1d5663e);
	spawner::add_archetype_spawn_function("astronaut", &function_608d24f2);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("headbutt_start", &function_381fe28d);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("astro_melee", &function_784f7bb7);
	init_astro_zombie_fx();
	if(!isdefined(level.astro_zombie_enter_level))
	{
		level.astro_zombie_enter_level = &astro_zombie_default_enter_level;
	}
	level.num_astro_zombies = 0;
	level.astro_zombie_spawners = GetEntArray("astronaut_zombie", "targetname");
	level.max_astro_zombies = 1;
	level.astro_zombie_health_mult = 4;
	level.min_astro_round_wait = 1;
	level.max_astro_round_wait = 2;
	level.astro_round_start = 1;
	level.next_astro_round = level.astro_round_start + randomIntRange(0, level.max_astro_round_wait + 1);
	level.zombies_left_before_astro_spawn = 1;
	level.zombie_left_before_spawn = 0;
	level.astro_explode_radius = 400;
	level.astro_explode_blast_radius = 150;
	level.astro_explode_pulse_min = 100;
	level.astro_explode_pulse_max = 300;
	level.astro_headbutt_delay = 2000;
	level.astro_headbutt_radius_sqr = 4096;
	level.zombie_total_update = 0;
	level.zombie_total_set_func = &astro_zombie_total_update;
	zm_spawner::register_zombie_damage_callback(&astro_damage_callback);
	while(!isdefined(level.custom_ai_spawn_check_funcs))
	{
		wait(0.05);
	}
	zm::register_custom_ai_spawn_check("astro", &function_64229c1f, &function_870ce941, &function_13189f7a);
}

/*
	Name: function_c1d5663e
	Namespace: namespace_c0afbdaf
	Checksum: 0x92A55608
	Offset: 0x918
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_c1d5663e()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(self);
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", &ZombieBehavior::BB_GetLocomotionSpeedType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &function_11b12c90;
	/#
		self function_89398c57();
	#/
}

/*
	Name: function_11b12c90
	Namespace: namespace_c0afbdaf
	Checksum: 0xCB9A2DF6
	Offset: 0xA08
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private function_11b12c90(entity)
{
	entity.__blackboard = undefined;
	entity function_c1d5663e();
}

/*
	Name: function_ecd296a1
	Namespace: namespace_c0afbdaf
	Checksum: 0x664E962
	Offset: 0xA48
	Size: 0x73
	Parameters: 0
	Flags: Private
*/
function private function_ecd296a1()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("astroTargetService", &function_fa8c98de);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("moonAstroProceduralTraversal", &function_1dd16458, &RobotSoldierBehavior::robotProceduralTraversalUpdate, &function_da0d7bfb);
}

/*
	Name: function_608d24f2
	Namespace: namespace_c0afbdaf
	Checksum: 0x1F5D5DE0
	Offset: 0xAC8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_608d24f2()
{
	self astro_prespawn();
	self thread astro_zombie_spawn(self);
}

/*
	Name: function_fa8c98de
	Namespace: namespace_c0afbdaf
	Checksum: 0xB6672ACB
	Offset: 0xB08
	Size: 0x247
	Parameters: 1
	Flags: None
*/
function function_fa8c98de(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
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
	targetPos = GetClosestPointOnNavMesh(player.origin, 15, 15);
	if(isdefined(targetPos))
	{
		entity SetGoal(targetPos);
		return 1;
	}
	if(isdefined(player.last_valid_position))
	{
		entity SetGoal(player.last_valid_position);
		return 1;
	}
	else
	{
		entity SetGoal(entity.origin);
		return 0;
	}
}

/*
	Name: function_64229c1f
	Namespace: namespace_c0afbdaf
	Checksum: 0x8F2F877F
	Offset: 0xD58
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_64229c1f()
{
	if(isdefined(level.zm_loc_types["astro_location"]) && level.zm_loc_types["astro_location"].size <= 0)
	{
		return 0;
	}
	if(!(level.round_number >= level.next_astro_round && level.num_astro_zombies < level.max_astro_zombies))
	{
		return 0;
	}
	if(!(isdefined(level.on_the_moon) && level.on_the_moon))
	{
		return 0;
	}
	if(!(isdefined(level.zombie_total_update) && level.zombie_total_update))
	{
		return 0;
	}
	if(level.zombie_total > level.zombies_left_before_astro_spawn)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_870ce941
	Namespace: namespace_c0afbdaf
	Checksum: 0x3162AA02
	Offset: 0xE20
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_870ce941()
{
	return level.astro_zombie_spawners;
}

/*
	Name: function_13189f7a
	Namespace: namespace_c0afbdaf
	Checksum: 0x772D6893
	Offset: 0xE38
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_13189f7a()
{
	return level.zm_loc_types["astro_location"];
}

/*
	Name: astro_prespawn
	Namespace: namespace_c0afbdaf
	Checksum: 0x4360516B
	Offset: 0xE58
	Size: 0x2A9
	Parameters: 0
	Flags: None
*/
function astro_prespawn()
{
	self.animName = "astro_zombie";
	self.ignoreall = 1;
	self.allowdeath = 1;
	self.is_zombie = 1;
	self.has_legs = 1;
	self AllowedStances("stand");
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.disableArrivals = 1;
	self.disableExits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = 1;
	self.suppressionThreshold = 1;
	self.noDodgeMove = 1;
	self.dontShootWhileMoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatInitialized = 0;
	self thread zm_spawner::zombie_damage_failsafe();
	self thread zombie_utility::delayed_zombie_eye_glow();
	self.flame_damage_time = 0;
	self.meleeDamage = 50;
	self.no_powerups = 1;
	self.no_gib = 1;
	self.ignorelocationaldamage = 1;
	self.actor_damage_func = &astro_actor_damage;
	self.nuke_damage_func = &astro_nuke_damage;
	self.custom_damage_func = &astro_custom_damage;
	self.microwavegun_sizzle_func = &astro_microwavegun_sizzle;
	self.ignore_cleanup_mgr = 1;
	self.ignore_distance_tracking = 1;
	self.ignore_enemy_count = 1;
	self.ignore_gravity = 1;
	self.ignore_devgui_death = 1;
	self.ignore_nml_delete = 1;
	self.ignore_round_spawn_failsafe = 1;
	self.ignore_poi_targetname = [];
	self.ignore_poi_targetname[self.ignore_poi_targetname.size] = "zm_bhb";
	self.zombie_move_speed = "walk";
	self zombie_utility::set_zombie_run_cycle();
	self.zombie_think_done = 1;
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self notify("zombie_init_done");
}

/*
	Name: init_astro_zombie_fx
	Namespace: namespace_c0afbdaf
	Checksum: 0x11F370E6
	Offset: 0x1110
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function init_astro_zombie_fx()
{
	level._effect["astro_spawn"] = "dlc5/moon/fx_moon_qbomb_explo_distort";
	level._effect["astro_explosion"] = "dlc5/moon/fx_moon_qbomb_explo_distort";
}

/*
	Name: astro_zombie_spawn
	Namespace: namespace_c0afbdaf
	Checksum: 0xD785B6DF
	Offset: 0x1158
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function astro_zombie_spawn(astro_zombie)
{
	self.script_moveoverride = 1;
	if(!isdefined(level.num_astro_zombies))
	{
		level.num_astro_zombies = 0;
	}
	level.num_astro_zombies++;
	astro_zombie.has_legs = 1;
	self.count = 100;
	playsoundatposition("evt_astro_spawn", self.origin);
	astro_zombie.deathFunction = &astro_zombie_die;
	astro_zombie.animName = "astro_zombie";
	astro_zombie.loopSound = "evt_astro_gasmask_loop";
	astro_zombie thread astro_zombie_think();
	_debug_astro_print("astro spawned in " + level.round_number);
	return astro_zombie;
}

/*
	Name: astro_zombie_total_update
	Namespace: namespace_c0afbdaf
	Checksum: 0x4F05BA75
	Offset: 0x1260
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function astro_zombie_total_update()
{
	level.zombie_total_update = 1;
	level.zombies_left_before_astro_spawn = 1;
	if(level.zombie_total > 1)
	{
		level.zombies_left_before_astro_spawn = randomIntRange(Int(level.zombie_total * 0.25), Int(level.zombie_total * 0.75));
	}
	_debug_astro_print("next astro round = " + level.next_astro_round);
	_debug_astro_print("zombies to kill = " + level.zombie_total - level.zombies_left_before_astro_spawn);
}

/*
	Name: astro_zombie_think
	Namespace: namespace_c0afbdaf
	Checksum: 0xF1D3017F
	Offset: 0x1350
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function astro_zombie_think()
{
	self endon("death");
	self.entered_level = 0;
	self.ignoreall = 0;
	self.maxhealth = level.zombie_health * GetPlayers().size * level.astro_zombie_health_mult;
	self.health = self.maxhealth;
	self.maxsightdistsqrd = 9216;
	self.zombie_move_speed = "walk";
	self thread [[level.astro_zombie_enter_level]]();
	if(isdefined(level.astro_zombie_custom_think))
	{
		self thread [[level.astro_zombie_custom_think]]();
	}
	self thread astro_zombie_headbutt_think();
	self PlayLoopSound(self.loopSound);
}

/*
	Name: astro_zombie_headbutt_think
	Namespace: namespace_c0afbdaf
	Checksum: 0x8929CAA
	Offset: 0x1438
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function astro_zombie_headbutt_think()
{
	self endon("death");
	self.is_headbutt = 0;
	self.next_headbutt_time = GetTime() + level.astro_headbutt_delay;
	while(1)
	{
		if(!isdefined(self.enemy))
		{
			wait(0.05);
			continue;
		}
		if(!self.is_headbutt && GetTime() > self.next_headbutt_time)
		{
			origin = self GetEye();
			test_origin = self.enemy GetEye();
			dist_sqr = DistanceSquared(origin, test_origin);
			if(dist_sqr > level.astro_headbutt_radius_sqr)
			{
				wait(0.05);
				continue;
			}
			yaw = zombie_utility::GetYawToOrigin(self.enemy.origin);
			if(Abs(yaw) > 45)
			{
				wait(0.05);
				continue;
			}
			if(!BulletTracePassed(origin, test_origin, 0, undefined))
			{
				wait(0.05);
				continue;
			}
			self.is_headbutt = 1;
			self thread astro_turn_player();
			headbutt_anim = self AnimMappingSearch(istring("anim_astro_headbutt"));
			time = getanimlength(headbutt_anim);
			self.player_to_headbutt thread astro_restore_move_speed(time);
			self AnimScripted("headbutt_anim", self.origin, self.angles, "ai_zm_dlc5_zombie_astro_headbutt");
			wait(time);
			self.next_headbutt_time = GetTime() + level.astro_headbutt_delay;
			self.is_headbutt = 0;
		}
		wait(0.05);
	}
}

/*
	Name: astro_restore_move_speed
	Namespace: namespace_c0afbdaf
	Checksum: 0xF4311E76
	Offset: 0x16B0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function astro_restore_move_speed(time)
{
	self endon("disconnect");
	wait(time);
	self AllowJump(1);
	self AllowProne(1);
	self AllowCrouch(1);
	self setMoveSpeedScale(1);
}

/*
	Name: function_1dd16458
	Namespace: namespace_c0afbdaf
	Checksum: 0x6EC6884
	Offset: 0x1738
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function function_1dd16458(entity, asmStateName)
{
	RobotSoldierBehavior::robotCalcProceduralTraversal(entity, asmStateName);
	RobotSoldierBehavior::robotTraverseStart(entity, asmStateName);
	return 5;
}

/*
	Name: function_da0d7bfb
	Namespace: namespace_c0afbdaf
	Checksum: 0xF3A1B7B1
	Offset: 0x1788
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function function_da0d7bfb(entity, asmStateName)
{
	RobotSoldierBehavior::robotProceduralLandingUpdate(entity, asmStateName);
	RobotSoldierBehavior::robotTraverseEnd(entity);
	return 4;
}

/*
	Name: astro_turn_player
	Namespace: namespace_c0afbdaf
	Checksum: 0x8B34E1BD
	Offset: 0x17D8
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function astro_turn_player()
{
	self endon("death");
	self.player_to_headbutt = self.enemy;
	player = self.player_to_headbutt;
	up = player.origin + VectorScale((0, 0, 1), 10);
	facing_astro = VectorToAngles(self.origin - up);
	player thread astro_watch_controls(self);
	if(self.health > 0)
	{
		player FreezeControls(1);
	}
	lerp_time = 0.2;
	enemy_to_player = VectorNormalize(player.origin - self.origin);
	link_org = self.origin + 40 * enemy_to_player;
	player lerp_player_view_to_position(link_org, facing_astro, lerp_time, 1);
	wait(lerp_time);
	player FreezeControls(0);
	player AllowJump(0);
	player AllowStand(1);
	player AllowProne(0);
	player AllowCrouch(0);
	player setMoveSpeedScale(0.1);
	player notify("released");
	dist = Distance(self.origin, player.origin);
	_debug_astro_print("grab dist = " + dist);
}

/*
	Name: lerp_player_view_to_position
	Namespace: namespace_c0afbdaf
	Checksum: 0xEE061D7D
	Offset: 0x1A50
	Size: 0x22B
	Parameters: 9
	Flags: None
*/
function lerp_player_view_to_position(origin, angles, lerpTime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo)
{
	if(isPlayer(self))
	{
		self endon("disconnect");
	}
	linker = spawn("script_origin", (0, 0, 0));
	linker.origin = self.origin;
	linker.angles = self getPlayerAngles();
	if(isdefined(hit_geo))
	{
		self playerLinkTo(linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo);
	}
	else if(isdefined(right_arc))
	{
		self playerLinkTo(linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc);
	}
	else if(isdefined(fraction))
	{
		self playerLinkTo(linker, "", fraction);
	}
	else
	{
		self playerLinkTo(linker);
	}
	linker moveto(origin, lerpTime, lerpTime * 0.25);
	linker RotateTo(angles, lerpTime, lerpTime * 0.25);
	linker waittill("movedone");
	linker delete();
}

/*
	Name: astro_watch_controls
	Namespace: namespace_c0afbdaf
	Checksum: 0xAA5F3417
	Offset: 0x1C88
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function astro_watch_controls(astro)
{
	self endon("released");
	self endon("disconnect");
	animLen = astro GetAnimLengthFromASD("zm_headbutt", 0);
	time = 0.5 + animLen;
	astro util::waittill_notify_or_timeout("death", time);
	self FreezeControls(0);
}

/*
	Name: function_784f7bb7
	Namespace: namespace_c0afbdaf
	Checksum: 0x2A5B9B59
	Offset: 0x1D38
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_784f7bb7(entity)
{
	if(!isdefined(entity.player_to_headbutt) || !zombie_utility::is_player_valid(entity.player_to_headbutt))
	{
		return;
	}
	entity thread astro_zombie_attack();
	entity thread astro_zombie_teleport_enemy();
}

/*
	Name: function_381fe28d
	Namespace: namespace_c0afbdaf
	Checksum: 0xADF4A985
	Offset: 0x1DC0
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_381fe28d(entity)
{
	_RELEASE_DIST = 59;
	player = entity.player_to_headbutt;
	if(!isdefined(player) || !isalive(player))
	{
		return;
	}
	dist = Distance(player.origin, entity.origin);
	_debug_astro_print("distance before headbutt = " + dist);
	if(dist < _RELEASE_DIST)
	{
		return;
	}
	player AllowJump(1);
	player AllowProne(1);
	player AllowCrouch(1);
	player setMoveSpeedScale(1);
	self AnimScripted("headbutt_anim", entity.origin, entity.angles, "ai_zm_dlc5_zombie_astro_headbutt_release");
}

/*
	Name: astro_zombie_attack
	Namespace: namespace_c0afbdaf
	Checksum: 0x1B330221
	Offset: 0x1F38
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function astro_zombie_attack()
{
	self endon("death");
	if(!isdefined(self.player_to_headbutt))
	{
		return;
	}
	player = self.player_to_headbutt;
	perk_list = [];
	vending_triggers = GetEntArray("zombie_vending", "targetname");
	for(i = 0; i < vending_triggers.size; i++)
	{
		perk = vending_triggers[i].script_noteworthy;
		if(player hasPerk(perk))
		{
			perk_list[perk_list.size] = perk;
		}
	}
	take_perk = 0;
	if(perk_list.size > 0 && !isdefined(player._retain_perks))
	{
		take_perk = 1;
		perk_list = Array::randomize(perk_list);
		perk = perk_list[0];
		perk_str = perk + "_stop";
		player notify(perk_str);
		if(level flag::get("solo_game") && perk == "specialty_quickrevive")
		{
			player.lives--;
		}
		player thread astro_headbutt_damage(self, self.origin);
	}
	if(!take_perk)
	{
		damage = player.health - 1;
		player DoDamage(damage, self.origin, self);
	}
}

/*
	Name: astro_headbutt_damage
	Namespace: namespace_c0afbdaf
	Checksum: 0x69E4F563
	Offset: 0x2170
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function astro_headbutt_damage(astro, org)
{
	self endon("disconnect");
	self waittill("perk_lost");
	damage = self.health - 1;
	if(isdefined(astro))
	{
		self DoDamage(damage, astro.origin, astro);
	}
	else
	{
		self DoDamage(damage, org);
	}
}

/*
	Name: astro_zombie_teleport_enemy
	Namespace: namespace_c0afbdaf
	Checksum: 0xBCCE0FAE
	Offset: 0x2218
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function astro_zombie_teleport_enemy()
{
	self endon("death");
	player = self.player_to_headbutt;
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if(isdefined(level._special_blackhole_bomb_structs))
	{
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	player_current_zone = player zm_utility::get_current_zone();
	if(!isdefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0 || !isdefined(player_current_zone))
	{
		return;
	}
	black_hole_teleport_structs = Array::randomize(black_hole_teleport_structs);
	for(i = 0; i < black_hole_teleport_structs.size; i++)
	{
		volume = level.zones[black_hole_teleport_structs[i].script_string].Volumes[0];
		zone_enabled = zm_zonemgr::get_zone_from_position(black_hole_teleport_structs[i].origin, 0);
		if(isdefined(zone_enabled) && player_current_zone != black_hole_teleport_structs[i].script_string)
		{
			if(!level flag::get("power_on") || volume.script_string == "lowgravity")
			{
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
			else
			{
				chosen_spot = black_hole_teleport_structs[i];
			}
			continue;
		}
		if(isdefined(zone_enabled))
		{
			chosen_spot = black_hole_teleport_structs[i];
		}
	}
	if(isdefined(chosen_spot))
	{
		player thread astro_zombie_teleport(chosen_spot);
	}
}

/*
	Name: astro_zombie_teleport
	Namespace: namespace_c0afbdaf
	Checksum: 0xD2CAABD5
	Offset: 0x2470
	Size: 0x26B
	Parameters: 1
	Flags: None
*/
function astro_zombie_teleport(struct_dest)
{
	self endon("death");
	if(!isdefined(struct_dest))
	{
		return;
	}
	prone_offset = VectorScale((0, 0, 1), 49);
	crouch_offset = VectorScale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	destination = undefined;
	if(self GetStance() == "prone")
	{
		destination = struct_dest.origin + prone_offset;
	}
	else if(self GetStance() == "crouch")
	{
		destination = struct_dest.origin + crouch_offset;
	}
	else
	{
		destination = struct_dest.origin + stand_offset;
	}
	if(isdefined(level._black_hole_teleport_override))
	{
		level [[level._black_hole_teleport_override]](self);
	}
	self FreezeControls(1);
	self disableOffhandWeapons();
	self DisableWeapons();
	self DontInterpolate();
	self SetOrigin(destination);
	self SetPlayerAngles(struct_dest.angles);
	self EnableOffhandWeapons();
	self enableWeapons();
	self FreezeControls(0);
	Earthquake(0.8, 0.75, self.origin, 1000, self);
	self playsoundtoplayer("zmb_gersh_teleporter_go_2d", self);
}

/*
	Name: astro_zombie_die
	Namespace: namespace_c0afbdaf
	Checksum: 0x43F8E88D
	Offset: 0x26E8
	Size: 0x159
	Parameters: 8
	Flags: None
*/
function astro_zombie_die(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	PlayFXOnTag(level._effect["astro_explosion"], self, "J_SpineLower");
	self StopLoopSound(1);
	self playsound("evt_astro_zombie_explo");
	self thread astro_delay_delete();
	self thread astro_player_pulse();
	level.num_astro_zombies--;
	level.next_astro_round = level.round_number + randomIntRange(level.min_astro_round_wait, level.max_astro_round_wait + 1);
	level.zombie_total_update = 0;
	_debug_astro_print("astro killed in " + level.round_number);
	return self zm_spawner::zombie_death_animscript();
}

/*
	Name: astro_delay_delete
	Namespace: namespace_c0afbdaf
	Checksum: 0xCE5D524E
	Offset: 0x2850
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function astro_delay_delete()
{
	self endon("death");
	self SetPlayerCollision(0);
	self thread zombie_utility::zombie_eye_glow_stop();
	wait(0.05);
	self ghost();
	wait(0.05);
	self delete();
}

/*
	Name: astro_player_pulse
	Namespace: namespace_c0afbdaf
	Checksum: 0xCC2852E5
	Offset: 0x28D8
	Size: 0x479
	Parameters: 0
	Flags: None
*/
function astro_player_pulse()
{
	eye_org = self GetEye();
	foot_org = self.origin + VectorScale((0, 0, 1), 8);
	mid_org = (foot_org[0], foot_org[1], foot_org[2] + eye_org[2] / 2);
	astro_org = self.origin;
	if(isdefined(self.player_to_headbutt))
	{
		self.player_to_headbutt AllowJump(1);
		self.player_to_headbutt AllowProne(1);
		self.player_to_headbutt AllowCrouch(1);
		self.player_to_headbutt Unlink();
		wait(0.05);
		wait(0.05);
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!zombie_utility::is_player_valid(player))
		{
			continue;
		}
		test_org = player GetEye();
		explode_radius = level.astro_explode_radius;
		if(DistanceSquared(eye_org, test_org) > explode_radius * explode_radius)
		{
			continue;
		}
		test_org_foot = player.origin + VectorScale((0, 0, 1), 8);
		test_org_mid = (test_org_foot[0], test_org_foot[1], test_org_foot[2] + test_org[2] / 2);
		if(!BulletTracePassed(eye_org, test_org, 0, undefined))
		{
			if(!BulletTracePassed(mid_org, test_org_mid, 0, undefined))
			{
				if(!BulletTracePassed(foot_org, test_org_foot, 0, undefined))
				{
					continue;
				}
			}
		}
		dist = Distance(eye_org, test_org);
		scale = 1 - dist / explode_radius;
		if(scale < 0)
		{
			scale = 0;
		}
		bonus = level.astro_explode_pulse_max - level.astro_explode_pulse_min * scale;
		pulse = level.astro_explode_pulse_min + bonus;
		dir = (player.origin[0] - astro_org[0], player.origin[1] - astro_org[1], 0);
		dir = VectorNormalize(dir);
		dir = dir + (0, 0, 1);
		dir = dir * pulse;
		player SetOrigin(player.origin + (0, 0, 1));
		player_velocity = dir;
		player SetVelocity(player_velocity);
		if(isdefined(level.ai_astro_explode))
		{
			player thread [[level.ai_astro_explode]](mid_org);
		}
	}
}

/*
	Name: astro_actor_damage
	Namespace: namespace_c0afbdaf
	Checksum: 0xBE8352DD
	Offset: 0x2D60
	Size: 0xA1
	Parameters: 11
	Flags: None
*/
function astro_actor_damage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
{
	self endon("death");
	switch(weapon.name)
	{
		case "microwavegundw_upgraded_zm":
		case "microwavegundw_zm":
		{
			damage = 0;
			break;
		}
	}
	return damage;
}

/*
	Name: astro_nuke_damage
	Namespace: namespace_c0afbdaf
	Checksum: 0x302ABA93
	Offset: 0x2E10
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function astro_nuke_damage()
{
	self endon("death");
}

/*
	Name: astro_custom_damage
	Namespace: namespace_c0afbdaf
	Checksum: 0xEF708F8B
	Offset: 0x2E28
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function astro_custom_damage(player)
{
	damage = self.meleeDamage;
	if(self.is_headbutt)
	{
		damage = player.health - 1;
	}
	_debug_astro_print("astro damage = " + damage);
	return damage;
}

/*
	Name: astro_microwavegun_sizzle
	Namespace: namespace_c0afbdaf
	Checksum: 0x86A399E4
	Offset: 0x2E98
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function astro_microwavegun_sizzle(player)
{
	_debug_astro_print("astro sizzle");
}

/*
	Name: astro_zombie_default_enter_level
	Namespace: namespace_c0afbdaf
	Checksum: 0xBAFB1638
	Offset: 0x2EC8
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function astro_zombie_default_enter_level()
{
	playFX(level._effect["astro_spawn"], self.origin);
	playsoundatposition("zmb_bolt", self.origin);
	players = GetPlayers();
	players[randomIntRange(0, players.size)] thread zm_audio::create_and_play_dialog("general", "astro_spawn");
	self.entered_level = 1;
}

/*
	Name: astro_damage_callback
	Namespace: namespace_c0afbdaf
	Checksum: 0xA21DFA10
	Offset: 0x2F90
	Size: 0x93
	Parameters: 13
	Flags: None
*/
function astro_damage_callback(mod, HIT_LOCATION, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(isdefined(self.animName) && self.animName == "astro_zombie")
	{
		return 1;
	}
	return 0;
}

/*
	Name: _debug_astro_health_watch
	Namespace: namespace_c0afbdaf
	Checksum: 0xFAC80027
	Offset: 0x3030
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function _debug_astro_health_watch()
{
	self endon("death");
	while(1)
	{
		/#
			iprintln("Dev Block strings are not supported" + self.health);
		#/
		wait(1);
	}
}

/*
	Name: _debug_astro_print
	Namespace: namespace_c0afbdaf
	Checksum: 0xE3B652E1
	Offset: 0x3080
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function _debug_astro_print(STR)
{
	/#
		if(isdefined(level.debug_astro) && level.debug_astro)
		{
			iprintln(STR);
		}
	#/
}

