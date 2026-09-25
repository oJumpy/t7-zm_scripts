#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\mechz;
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
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace namespace_ef567265;

/*
	Name: __init__sytem__
	Namespace: namespace_ef567265
	Checksum: 0xD378E478
	Offset: 0x6B0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_ef567265
	Checksum: 0xBF891CCD
	Offset: 0x6F8
	Size: 0x2BB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	function_f20c04a4();
	level.mechz_base_health = 1200;
	level.mechz_health = level.mechz_base_health;
	level.var_fa14536d = 1500;
	level.MECHZ_FACEPLATE_HEALTH = level.var_fa14536d;
	level.var_f12b2aa3 = 500;
	level.MECHZ_POWERCAP_COVER_HEALTH = level.var_f12b2aa3;
	level.var_e12ec39f = 500;
	level.MECHZ_POWERCAP_HEALTH = level.var_e12ec39f;
	level.var_3f1bf221 = 250;
	level.var_2cbc5b59 = level.var_3f1bf221;
	level.mechz_health_increase = 100;
	level.var_1a5bb9d8 = 100;
	level.var_a1943286 = 15;
	level.var_9684c99e = 15;
	level.var_158234c = 10;
	level.mechz_round_count = 0;
	level.mechz_spawners = GetEntArray("zombie_mechz_spawner", "script_noteworthy");
	level.mechz_locations = struct::get_array("mechz_location", "script_noteworthy");
	spawner::add_archetype_spawn_function("mechz", &function_3d5df242);
	zm::register_player_damage_callback(&function_ed70c868);
	level.mechz_flamethrower_ai_callback = &function_1add8026;
	level thread AAT::register_immunity("zm_aat_blast_furnace", "mechz", 0, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "mechz", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "mechz", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "mechz", 0, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "mechz", 1, 1, 1);
	/#
		execdevgui("Dev Block strings are not supported");
		thread function_fbad70fd();
	#/
}

/*
	Name: __main__
	Namespace: namespace_ef567265
	Checksum: 0xB9C57B89
	Offset: 0x9C0
	Size: 0x67
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
	if(!isdefined(level.var_98b48f9c))
	{
		level.var_98b48f9c = 80;
	}
	visionset_mgr::register_info("overlay", "mechz_player_burn", 5000, level.var_98b48f9c, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
	level.var_e7b9aac8 = 1;
}

/*
	Name: function_f20c04a4
	Namespace: namespace_ef567265
	Checksum: 0xE808B314
	Offset: 0xA30
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_f20c04a4()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMechzTargetService", &function_c28caf48);
}

/*
	Name: function_c28caf48
	Namespace: namespace_ef567265
	Checksum: 0xA1DBAFD
	Offset: 0xA68
	Size: 0x29F
	Parameters: 1
	Flags: Private
*/
function private function_c28caf48(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	player = zm_utility::get_closest_valid_player(self.origin, self.ignore_player);
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
	playerpos = player.origin;
	if(isdefined(player.last_valid_position))
	{
		playerpos = player.last_valid_position;
	}
	targetPos = GetClosestPointOnNavMesh(playerpos, 64, 30);
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
	Name: function_48cabef5
	Namespace: namespace_ef567265
	Checksum: 0x518888F5
	Offset: 0xD10
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_48cabef5()
{
	if(isdefined(self.customTraverseEndNode) && isdefined(self.customTraverseStartNode))
	{
		return self.customTraverseEndNode.script_noteworthy === "custom_traversal" && self.customTraverseStartNode.script_noteworthy === "custom_traversal";
	}
	return 0;
}

/*
	Name: function_3d5df242
	Namespace: namespace_ef567265
	Checksum: 0x6C26F914
	Offset: 0xD70
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private function_3d5df242()
{
	self.b_ignore_cleanup = 1;
	self.is_mechz = 1;
	self.var_7884b12d = self.health;
	self.team = level.zombie_team;
	self.zombie_lift_override = &function_817c85eb;
	self.thundergun_fling_func = &function_9bac2f00;
	self.thundergun_knockdown_func = &function_19b9b682;
	self.var_23340a5d = &function_9bac2f00;
	self.var_e1dbd63 = &function_19b9b682;
	self.var_48cabef5 = &function_48cabef5;
	level thread zm_spawner::zombie_death_event(self);
}

/*
	Name: function_ed70c868
	Namespace: namespace_ef567265
	Checksum: 0x574CF82A
	Offset: 0xE60
	Size: 0x91
	Parameters: 10
	Flags: Private
*/
function private function_ed70c868(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(eAttacker) && eAttacker.archetype === "mechz" && sMeansOfDeath === "MOD_MELEE")
	{
		return 150;
	}
	return -1;
}

/*
	Name: function_58655f2a
	Namespace: namespace_ef567265
	Checksum: 0xF0FDA4FA
	Offset: 0xF00
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function function_58655f2a()
{
	if(!isdefined(self.stun) && self.stun && self.stumble_stun_cooldown_time < GetTime())
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_9bac2f00
	Namespace: namespace_ef567265
	Checksum: 0xAEAF1A5F
	Offset: 0xF40
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_9bac2f00(e_player, gib)
{
	self endon("death");
	self function_b8e0ce15(e_player);
	if(!isdefined(self.stun) && self.stun && self.stumble_stun_cooldown_time < GetTime())
	{
		self.stun = 1;
	}
}

/*
	Name: function_19b9b682
	Namespace: namespace_ef567265
	Checksum: 0xC3560C9D
	Offset: 0xFB0
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_19b9b682(e_player, gib)
{
	self endon("death");
	self function_b8e0ce15(e_player);
	if(!isdefined(self.stun) && self.stun && self.stumble_stun_cooldown_time < GetTime())
	{
		self.stun = 1;
	}
}

/*
	Name: function_b8e0ce15
	Namespace: namespace_ef567265
	Checksum: 0xE943A1DD
	Offset: 0x1020
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function function_b8e0ce15(e_player)
{
	var_3bb42832 = level.mechz_health;
	if(isdefined(level.var_f4dc2834))
	{
		var_3bb42832 = math::clamp(var_3bb42832, 0, level.var_f4dc2834);
	}
	n_damage = var_3bb42832 * 0.25 / 0.2;
	self DoDamage(n_damage, self GetCentroid(), e_player, e_player, undefined, "MOD_PROJECTILE_SPLASH", 0, GetWeapon("thundergun"));
}

/*
	Name: spawn_mechz
	Namespace: namespace_ef567265
	Checksum: 0xAF38FF31
	Offset: 0x10F8
	Size: 0x50F
	Parameters: 2
	Flags: None
*/
function spawn_mechz(s_location, flyin)
{
	if(!isdefined(flyin))
	{
		flyin = 0;
	}
	if(isdefined(level.mechz_spawners[0]))
	{
		if(isdefined(level.var_7f2a926d))
		{
			[[level.var_7f2a926d]]();
		}
		level.mechz_spawners[0].script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(level.mechz_spawners[0], "mechz", s_location);
		if(isdefined(ai))
		{
			ai DisableAimAssist();
			ai thread function_ef1ba7e5();
			ai thread function_949a3fdf();
			/#
				ai thread function_75a79bb5();
			#/
			ai.actor_damage_func = &MechzServerUtils::mechzDamageCallback;
			ai.damage_scoring_function = &function_b03abc02;
			ai.mechz_melee_knockdown_function = &function_55483494;
			ai.health = level.mechz_health;
			ai.faceplate_health = level.MECHZ_FACEPLATE_HEALTH;
			ai.powercap_cover_health = level.MECHZ_POWERCAP_COVER_HEALTH;
			ai.powercap_health = level.MECHZ_POWERCAP_HEALTH;
			ai.left_knee_armor_health = level.var_2cbc5b59;
			ai.right_knee_armor_health = level.var_2cbc5b59;
			ai.left_shoulder_armor_health = level.var_2cbc5b59;
			ai.right_shoulder_armor_health = level.var_2cbc5b59;
			ai.heroweapon_kill_power = 10;
			e_player = zm_utility::get_closest_player(s_location.origin);
			v_dir = e_player.origin - s_location.origin;
			v_dir = VectorNormalize(v_dir);
			v_angles = VectorToAngles(v_dir);
			var_89f898ad = zm_utility::flat_angle(v_angles);
			var_6ea4ef96 = s_location;
			queryResult = PositionQuery_Source_Navigation(var_6ea4ef96.origin, 0, 32, 20, 4);
			if(queryResult.data.size)
			{
				v_ground_position = Array::random(queryResult.data).origin;
			}
			if(!isdefined(v_ground_position))
			{
				trace = bullettrace(var_6ea4ef96.origin, var_6ea4ef96.origin + VectorScale((0, 0, -1), 256), 0, s_location);
				v_ground_position = trace["position"];
			}
			var_1750e965 = v_ground_position;
			if(isdefined(level.var_e1e49cc1))
			{
				ai thread [[level.var_e1e49cc1]]();
			}
			ai ForceTeleport(var_1750e965, var_89f898ad);
			if(flyin === 1)
			{
				ai thread function_d07fd448();
				ai thread scene::Play("cin_zm_castle_mechz_entrance", ai);
				ai thread function_c441eaba(var_1750e965);
				ai thread function_bbdc1f34(var_1750e965);
			}
			else if(isdefined(level.var_7d2a391d))
			{
				ai thread [[level.var_7d2a391d]]();
			}
			ai.b_flyin_done = 1;
			ai thread function_bb048b27();
			ai.ignore_round_robbin_death = 1;
			/#
				ai.ignore_devgui_death = 1;
			#/
			return ai;
		}
	}
	return undefined;
}

/*
	Name: function_d07fd448
	Namespace: namespace_ef567265
	Checksum: 0x792C0F16
	Offset: 0x1610
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_d07fd448()
{
	self endon("death");
	self.b_flyin_done = 0;
	self.bgbIgnoreFearInHeadlights = 1;
	self util::waittill_any("mechz_flyin_done", "scene_done");
	self.b_flyin_done = 1;
	self.bgbIgnoreFearInHeadlights = 0;
}

/*
	Name: function_c441eaba
	Namespace: namespace_ef567265
	Checksum: 0xEF2326B6
	Offset: 0x1680
	Size: 0x34B
	Parameters: 1
	Flags: None
*/
function function_c441eaba(var_678a2319)
{
	self endon("death");
	var_b54110bd = 2304;
	var_f0dad551 = 9216;
	var_44615973 = 2250000;
	self waittill("hash_f93797a6");
	a_zombies = GetAIArchetypeArray("zombie");
	foreach(e_zombie in a_zombies)
	{
		dist_sq = DistanceSquared(e_zombie.origin, var_678a2319);
		if(dist_sq <= var_b54110bd)
		{
			e_zombie kill();
		}
	}
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		dist_sq = DistanceSquared(player.origin, var_678a2319);
		if(dist_sq <= var_b54110bd)
		{
			player DoDamage(100, var_678a2319, self, self);
		}
		scale = var_44615973 - dist_sq / var_44615973;
		if(scale <= 0 || scale >= 1)
		{
			return;
		}
		earthquake_scale = scale * 0.15;
		Earthquake(earthquake_scale, 0.1, var_678a2319, 1500);
		if(scale >= 0.66)
		{
			player PlayRumbleOnEntity("shotgun_fire");
			continue;
		}
		if(scale >= 0.33)
		{
			player PlayRumbleOnEntity("damage_heavy");
			continue;
		}
		player PlayRumbleOnEntity("reload_small");
	}
	if(isdefined(self.var_1411e129))
	{
		self.var_1411e129 delete();
	}
}

/*
	Name: function_bbdc1f34
	Namespace: namespace_ef567265
	Checksum: 0xFE5D4750
	Offset: 0x19D8
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function function_bbdc1f34(var_678a2319)
{
	self endon("death");
	self endon("hash_f93797a6");
	self waittill("hash_3d18ed4f");
	var_f0dad551 = 9216;
	while(1)
	{
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			dist_sq = DistanceSquared(player.origin, var_678a2319);
			if(dist_sq <= var_f0dad551)
			{
				if(!isdefined(player.is_burning) && player.is_burning && zombie_utility::is_player_valid(player, 0))
				{
					player function_3389e2f3(self);
				}
			}
		}
		a_zombies = namespace_57695b4d::function_d41418b8();
		foreach(e_zombie in a_zombies)
		{
			dist_sq = DistanceSquared(e_zombie.origin, var_678a2319);
			if(dist_sq <= var_f0dad551 && self.var_e05d0be2 !== 1)
			{
				self function_3efae612(e_zombie);
				e_zombie namespace_57695b4d::function_f4defbc2();
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_3389e2f3
	Namespace: namespace_ef567265
	Checksum: 0x2D8082B7
	Offset: 0x1C60
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function function_3389e2f3(mechz)
{
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
	Name: function_817c85eb
	Namespace: namespace_ef567265
	Checksum: 0xE3945188
	Offset: 0x1D48
	Size: 0x2C7
	Parameters: 6
	Flags: None
*/
function function_817c85eb(e_player, v_attack_source, n_push_away, n_lift_height, v_lift_offset, n_lift_speed)
{
	self endon("death");
	if(isdefined(self.in_gravity_trap) && self.in_gravity_trap && e_player.gravityspikes_state === 3)
	{
		if(isdefined(self.var_1f5fe943) && self.var_1f5fe943)
		{
			return;
		}
		self.var_bcecff1d = 1;
		self.var_1f5fe943 = 1;
		self DoDamage(10, self.origin);
		self.var_ab0efcf6 = self.origin;
		self thread scene::Play("cin_zm_dlc1_mechz_dth_deathray_01", self);
		self clientfield::set("sparky_beam_fx", 1);
		self clientfield::set("death_ray_shock_fx", 1);
		self playsound("zmb_talon_electrocute");
		n_start_time = GetTime();
		for(n_total_time = 0; 10 > n_total_time && e_player.gravityspikes_state === 3;  = 0)
		{
			util::wait_network_frame();
		}
		self scene::stop("cin_zm_dlc1_mechz_dth_deathray_01");
		self thread function_bb84a54(self);
		self clientfield::set("sparky_beam_fx", 0);
		self clientfield::set("death_ray_shock_fx", 0);
		self.var_bcecff1d = undefined;
		while(e_player.gravityspikes_state === 3)
		{
			util::wait_network_frame();
		}
		self.var_1f5fe943 = undefined;
		self.in_gravity_trap = undefined;
	}
	else
	{
		self DoDamage(10, self.origin);
		if(!(isdefined(self.stun) && self.stun))
		{
			self.stun = 1;
		}
	}
}

/*
	Name: function_bb84a54
	Namespace: namespace_ef567265
	Checksum: 0xBA95E5F0
	Offset: 0x2018
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_bb84a54(mechz)
{
	mechz endon("death");
	if(isdefined(mechz))
	{
		mechz scene::Play("cin_zm_dlc1_mechz_dth_deathray_02", mechz);
	}
	if(isdefined(mechz) && isalive(mechz) && isdefined(mechz.var_ab0efcf6))
	{
		v_eye_pos = mechz GetTagOrigin("tag_eye");
		/#
			recordLine(mechz.origin, v_eye_pos, VectorScale((0, 1, 0), 255), "Dev Block strings are not supported", mechz);
		#/
		trace = bullettrace(v_eye_pos, mechz.origin, 0, mechz);
		if(trace["position"] !== mechz.origin)
		{
			point = GetClosestPointOnNavMesh(trace["position"], 64, 30);
			if(!isdefined(point))
			{
				point = mechz.var_ab0efcf6;
			}
			mechz ForceTeleport(point);
		}
	}
}

/*
	Name: function_1add8026
	Namespace: namespace_ef567265
	Checksum: 0xE573A4A3
	Offset: 0x21C8
	Size: 0x101
	Parameters: 1
	Flags: None
*/
function function_1add8026(mechz)
{
	flameTrigger = mechz.flameTrigger;
	a_zombies = namespace_57695b4d::function_d41418b8();
	foreach(zombie in a_zombies)
	{
		if(zombie istouching(flameTrigger) && zombie.var_e05d0be2 !== 1)
		{
			zombie namespace_57695b4d::function_f4defbc2();
		}
	}
}

/*
	Name: function_ef1ba7e5
	Namespace: namespace_ef567265
	Checksum: 0x46C91E89
	Offset: 0x22D8
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_ef1ba7e5()
{
	self waittill("death");
	if(isPlayer(self.attacker))
	{
		event = "death_mechz";
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			self.attacker zm_score::player_add_points(event, 1500);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](self.attacker, self);
		}
	}
}

/*
	Name: function_949a3fdf
	Namespace: namespace_ef567265
	Checksum: 0xBE00FCC7
	Offset: 0x2380
	Size: 0x171
	Parameters: 0
	Flags: None
*/
function function_949a3fdf()
{
	self waittill("hash_46c1e51d");
	v_origin = self.origin;
	a_ai = GetAISpeciesArray(level.zombie_team);
	a_ai_kill_zombies = ArraySortClosest(a_ai, v_origin, 18, 0, 200);
	foreach(ai_enemy in a_ai_kill_zombies)
	{
		if(isdefined(ai_enemy))
		{
			if(ai_enemy.archetype === "mechz")
			{
				ai_enemy DoDamage(level.mechz_health * 0.25, v_origin);
			}
			else
			{
				ai_enemy DoDamage(ai_enemy.health + 100, v_origin);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_b03abc02
	Namespace: namespace_ef567265
	Checksum: 0x98528F4A
	Offset: 0x2500
	Size: 0x10B
	Parameters: 12
	Flags: None
*/
function function_b03abc02(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(isdefined(attacker) && isPlayer(attacker))
	{
		if(zm_spawner::player_using_hi_score_weapon(attacker))
		{
			damage_type = "damage";
		}
		else
		{
			damage_type = "damage_light";
		}
		if(!(isdefined(self.no_damage_points) && self.no_damage_points))
		{
			attacker zm_score::player_add_points(damage_type, mod, hitLoc, self.isdog, self.team, weapon);
		}
	}
}

/*
	Name: function_3efae612
	Namespace: namespace_ef567265
	Checksum: 0x9A9A3379
	Offset: 0x2618
	Size: 0x2A3
	Parameters: 1
	Flags: None
*/
function function_3efae612(zombie)
{
	zombie.KNOCKDOWN = 1;
	zombie.knockdown_type = "knockdown_shoved";
	zombie_to_mechz = self.origin - zombie.origin;
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
	}
	else if(dot < 0.5 && dot > -0.5)
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
	}
	else
	{
		zombie.knockdown_direction = "back";
		zombie.getup_direction = "getup_belly";
	}
}

/*
	Name: function_55483494
	Namespace: namespace_ef567265
	Checksum: 0xB02E189
	Offset: 0x28C8
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function function_55483494()
{
	a_zombies = GetAIArchetypeArray("zombie");
	foreach(zombie in a_zombies)
	{
		dist_sq = DistanceSquared(self.origin, zombie.origin);
		if(zombie function_10d36217(self) && dist_sq <= 12544)
		{
			self function_3efae612(zombie);
		}
	}
}

/*
	Name: function_10d36217
	Namespace: namespace_ef567265
	Checksum: 0x22178440
	Offset: 0x29E0
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function function_10d36217(mechz)
{
	origin = self.origin;
	facing_vec = AnglesToForward(mechz.angles);
	enemy_vec = origin - mechz.origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.7)
	{
		return 0;
	}
	enemy_angles = VectorToAngles(enemy_vec);
	if(Abs(AngleClamp180(enemy_angles[0])) > 45)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_bb048b27
	Namespace: namespace_ef567265
	Checksum: 0xACD20183
	Offset: 0x2B70
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function function_bb048b27()
{
	self endon("death");
	while(1)
	{
		wait(randomIntRange(9, 14));
		self playsound("zmb_ai_mechz_vox_ambient");
	}
}

/*
	Name: function_75a79bb5
	Namespace: namespace_ef567265
	Checksum: 0x30CB72AC
	Offset: 0x2BD0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function function_75a79bb5()
{
	self endon("death");
	/#
		while(1)
		{
			if(isdefined(level.var_70068a8) && level.var_70068a8)
			{
				if(self.health > 0)
				{
					print3d(self.origin + VectorScale((0, 0, 1), 72), self.health, (0, 0.8, 0.6), 3);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_fbad70fd
	Namespace: namespace_ef567265
	Checksum: 0x262E6075
	Offset: 0x2C70
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private function_fbad70fd()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::function_4acecab5(&function_94a24a91);
	#/
}

/*
	Name: function_94a24a91
	Namespace: namespace_ef567265
	Checksum: 0x4F4E362B
	Offset: 0x2CC0
	Size: 0x40D
	Parameters: 1
	Flags: Private
*/
function private function_94a24a91(cmd)
{
	/#
		players = GetPlayers();
		var_6aad1b23 = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		mechz = ArrayGetClosest(GetPlayers()[0].origin, var_6aad1b23);
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				queryResult = PositionQuery_Source_Navigation(players[0].origin, 128, 256, 128, 20);
				spot = spawnstruct();
				spot.origin = players[0].origin;
				if(isdefined(queryResult) && queryResult.data.size > 0)
				{
					spot.origin = queryResult.data[0].origin;
				}
				mechz = spawn_mechz(spot);
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(!isdefined(level.zm_loc_types["Dev Block strings are not supported"]) || level.zm_loc_types["Dev Block strings are not supported"].size == 0)
				{
					iprintln("Dev Block strings are not supported");
				}
				spot = ArrayGetClosest(GetPlayers()[0].origin, level.zm_loc_types["Dev Block strings are not supported"]);
				if(isdefined(spot))
				{
					mechz = spawn_mechz(spot, 1);
				}
				else
				{
					iprintln("Dev Block strings are not supported");
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(mechz))
				{
					mechz kill();
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(mechz))
				{
					if(isdefined(mechz.shoot_grenade))
					{
						mechz.shoot_grenade = !mechz.shoot_grenade;
					}
					else
					{
						mechz.shoot_grenade = 1;
					}
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(mechz))
				{
					if(isdefined(mechz.shoot_flame))
					{
						mechz.shoot_flame = !mechz.shoot_flame;
					}
					else
					{
						mechz.shoot_flame = 1;
					}
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(mechz))
				{
					mechz.Berserk = 1;
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(!(isdefined(level.var_70068a8) && level.var_70068a8))
				{
					level.var_70068a8 = 1;
				}
				else
				{
					level.var_70068a8 = 0;
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(!(isdefined(level.b_mechz_true_ignore) && level.b_mechz_true_ignore))
				{
					level.b_mechz_true_ignore = 1;
				}
				else
				{
					level.b_mechz_true_ignore = 0;
				}
				break;
			}
		}
	#/
}

