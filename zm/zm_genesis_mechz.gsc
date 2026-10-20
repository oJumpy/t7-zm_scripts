#using scripts\codescripts\struct;
#using scripts\shared\ai\mechz;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_idgun;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_round_bosses;
#using scripts\zm\zm_genesis_vo;

#namespace zm_genesis_mechz;

/*
	Name: init
	Namespace: zm_genesis_mechz
	Checksum: 0x2082694F
	Offset: 0x6E0
	Size: 0x18B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_24ed806f();
	level flag::init("can_spawn_mechz", 1);
	spawner::add_archetype_spawn_function("mechz", &function_d8d01032);
	spawner::add_archetype_spawn_function("mechz", &function_b7e11612);
	level thread set_electric_trap();
	level.mechz_should_stun_override = &function_f517cdd6;
	level.var_7f2a926d = &mechz_health_increases;
	level.mechz_damage_override = &mechz_damage_override;
	level.var_7d2a391d = &spawn_effect;
	if(ai::shouldRegisterClientFieldForArchetype("mechz"))
	{
		clientfield::register("actor", "death_ray_shock_fx", 15000, 1, "int");
	}
	clientfield::register("actor", "mechz_fx_spawn", 15000, 1, "counter");
	/#
		level thread function_78e44cda();
	#/
}

/*
	Name: function_24ed806f
	Namespace: zm_genesis_mechz
	Checksum: 0x91C5683B
	Offset: 0x878
	Size: 0x1FB
	Parameters: 0
	Flags: Private
*/
function private function_24ed806f()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("castleMechzTrapService", &function_b25360f);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("genesisVortexService", &function_8746ceea);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("genesisMechzOctobombService", &function_2ffb7337);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("castleMechzShouldMoveToTrap", &function_beb13c4b);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("castleMechzIsAtTrap", &function_fc277828);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("castleMechzShouldAttackTrap", &function_d1cb5cbc);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("genesisMechzShouldOctobombAttack", &function_4e06a982);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("casteMechzTrapMoveTerminate", &function_4210ca29);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("casteMechzTrapAttackTerminate", &function_910e57ee);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("genesisMechzDestoryOctobomb", &function_78198ba2);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_trap_attack@mechz", &function_45f397ee, undefined, &function_9da58a6f);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@mechz", &teleporttraversalmocompstart, undefined, undefined);
}

/*
	Name: set_electric_trap
	Namespace: zm_genesis_mechz
	Checksum: 0x7B4F9D99
	Offset: 0xA80
	Size: 0xCD
	Parameters: 0
	Flags: Private
*/
function private set_electric_trap()
{
	wait(0.5);
	a_e_traps = GetEntArray("zombie_trap", "targetname");
	foreach(e_trap in a_e_traps)
	{
		if(e_trap.script_noteworthy == "electric")
		{
			level.electric_trap = e_trap;
		}
	}
}

/*
	Name: function_b25360f
	Namespace: zm_genesis_mechz
	Checksum: 0x7283641E
	Offset: 0xB58
	Size: 0x125
	Parameters: 1
	Flags: Private
*/
function private function_b25360f(entity)
{
	if(isdefined(entity.var_d77404f7) && entity.var_d77404f7 || (isdefined(entity.var_72308ff2) && entity.var_72308ff2))
	{
		return 1;
	}
	if(level flag::get("masher_on"))
	{
		if(entity function_d8f5da34("masher_trap_switch"))
		{
			return 1;
		}
	}
	if(isdefined(level.electric_trap))
	{
		if(isdefined(level.electric_trap._trap_in_use) && level.electric_trap._trap_in_use && (!isdefined(level.electric_trap._trap_cooling_down) && level.electric_trap._trap_cooling_down))
		{
			if(entity function_d8f5da34("elec_trap_switch"))
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: function_604404
	Namespace: zm_genesis_mechz
	Checksum: 0x72B858C2
	Offset: 0xC88
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
	Namespace: zm_genesis_mechz
	Checksum: 0x200C993B
	Offset: 0xD30
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
	Name: function_8746ceea
	Namespace: zm_genesis_mechz
	Checksum: 0x6C7E79B4
	Offset: 0xD78
	Size: 0x1C1
	Parameters: 1
	Flags: Private
*/
function private function_8746ceea(entity)
{
	if(!entity zm_ai_mechz::function_58655f2a())
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
					entity.stun = 1;
					entity.vortex = vortex;
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
	Name: function_2ffb7337
	Namespace: zm_genesis_mechz
	Checksum: 0xCF00231A
	Offset: 0xF48
	Size: 0x159
	Parameters: 1
	Flags: Private
*/
function private function_2ffb7337(entity)
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
	Name: function_d8f5da34
	Namespace: zm_genesis_mechz
	Checksum: 0xEF228288
	Offset: 0x10B0
	Size: 0x183
	Parameters: 1
	Flags: Private
*/
function private function_d8f5da34(trap_name)
{
	a_s_traps = struct::get_array(trap_name, "script_noteworthy");
	self.s_trap = undefined;
	n_closest_dist_sq = 57600;
	foreach(s_trap in a_s_traps)
	{
		n_dist_sq = DistanceSquared(s_trap.origin, self.origin);
		if(n_dist_sq < n_closest_dist_sq)
		{
			n_closest_dist_sq = n_dist_sq;
			self.s_trap = s_trap;
		}
	}
	if(isdefined(self.s_trap))
	{
		self.var_d77404f7 = 1;
		self.ignoreall = 1;
		self SetGoal(self.s_trap.origin);
		self thread function_957c9419();
		return 1;
	}
	return 0;
}

/*
	Name: function_957c9419
	Namespace: zm_genesis_mechz
	Checksum: 0x56378946
	Offset: 0x1240
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_957c9419()
{
	self endon("death");
	wait(60);
	if(isdefined(self.var_d77404f7) && self.var_d77404f7 || (isdefined(self.var_72308ff2) && self.var_72308ff2) || (isdefined(self.ignoreall) && self.ignoreall))
	{
		self.var_d77404f7 = 0;
		self.var_72308ff2 = 0;
		self.ignoreall = 0;
		MechzBehavior::mechzTargetService(self);
	}
}

/*
	Name: function_beb13c4b
	Namespace: zm_genesis_mechz
	Checksum: 0x62EB8DCB
	Offset: 0x12E0
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_beb13c4b(entity)
{
	if(isdefined(entity.var_d77404f7) && entity.var_d77404f7)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_fc277828
	Namespace: zm_genesis_mechz
	Checksum: 0x4CF7A31
	Offset: 0x1328
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function function_fc277828(entity)
{
	if(entity IsAtGoal())
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_d1cb5cbc
	Namespace: zm_genesis_mechz
	Checksum: 0xF00A1DB5
	Offset: 0x1360
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_d1cb5cbc(entity)
{
	if(isdefined(entity.var_72308ff2) && entity.var_72308ff2)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_4e06a982
	Namespace: zm_genesis_mechz
	Checksum: 0x8D6FDF20
	Offset: 0x13A8
	Size: 0xBD
	Parameters: 1
	Flags: Private
*/
function private function_4e06a982(entity)
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
	Name: function_4210ca29
	Namespace: zm_genesis_mechz
	Checksum: 0x2FDF1357
	Offset: 0x1470
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_4210ca29(entity)
{
	entity.var_d77404f7 = 0;
	entity.var_72308ff2 = 1;
}

/*
	Name: function_910e57ee
	Namespace: zm_genesis_mechz
	Checksum: 0xB370CE16
	Offset: 0x14A8
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_910e57ee(entity)
{
	entity.var_72308ff2 = 0;
	entity.ignoreall = 0;
	if(isdefined(entity.s_trap))
	{
		if(entity.s_trap.script_noteworthy == "masher_trap_switch")
		{
			level flag::clear("masher_on");
		}
		else
		{
			level.electric_trap notify("trap_deactivate");
		}
	}
	MechzBehavior::mechzTargetService(entity);
}

/*
	Name: function_78198ba2
	Namespace: zm_genesis_mechz
	Checksum: 0x17184BF0
	Offset: 0x1568
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_78198ba2(entity)
{
	if(isdefined(entity.destroy_octobomb))
	{
		entity.destroy_octobomb detonate();
		entity.destroy_octobomb = undefined;
	}
	MechzBehavior::mechzStopFlame(entity);
}

/*
	Name: function_45f397ee
	Namespace: zm_genesis_mechz
	Checksum: 0x8AF26E9A
	Offset: 0x15D8
	Size: 0x83
	Parameters: 5
	Flags: None
*/
function function_45f397ee(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.s_trap.angles[1]);
	entity animMode("normal");
}

/*
	Name: function_9da58a6f
	Namespace: zm_genesis_mechz
	Checksum: 0xC8867E8E
	Offset: 0x1668
	Size: 0x4B
	Parameters: 5
	Flags: None
*/
function function_9da58a6f(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face default");
}

/*
	Name: mechz_health_increases
	Namespace: zm_genesis_mechz
	Checksum: 0x6D4ACC3F
	Offset: 0x16C0
	Size: 0x2EB
	Parameters: 0
	Flags: None
*/
function mechz_health_increases()
{
	if(!isdefined(level.mechz_last_spawn_round) || level.round_number > level.mechz_last_spawn_round)
	{
		a_players = GetPlayers();
		n_player_modifier = 1;
		switch(a_players.size)
		{
			case 0:
			case 1:
			{
				n_player_modifier = 1;
				break;
			}
			case 2:
			{
				n_player_modifier = 1.33;
				break;
			}
			case 3:
			{
				n_player_modifier = 1.66;
				break;
			}
			case 4:
			{
				n_player_modifier = 2;
				break;
			}
		}
		var_485a2c2c = level.zombie_health / level.zombie_vars["zombie_health_start"];
		level.mechz_health = Int(n_player_modifier * level.mechz_base_health + level.mechz_health_increase * var_485a2c2c);
		level.MECHZ_FACEPLATE_HEALTH = Int(n_player_modifier * level.var_fa14536d + level.var_1a5bb9d8 * var_485a2c2c);
		level.MECHZ_POWERCAP_COVER_HEALTH = Int(n_player_modifier * level.MECHZ_POWERCAP_COVER_HEALTH + level.var_a1943286 * var_485a2c2c);
		level.MECHZ_POWERCAP_HEALTH = Int(n_player_modifier * level.MECHZ_POWERCAP_HEALTH + level.var_9684c99e * var_485a2c2c);
		level.mechz_armor_health = Int(n_player_modifier * level.var_3f1bf221 + level.var_158234c * var_485a2c2c);
		level.mechz_health = function_26beb37e(level.mechz_health, 17500, n_player_modifier);
		level.MECHZ_FACEPLATE_HEALTH = function_26beb37e(level.MECHZ_FACEPLATE_HEALTH, 16000, n_player_modifier);
		level.MECHZ_POWERCAP_COVER_HEALTH = function_26beb37e(level.MECHZ_POWERCAP_COVER_HEALTH, 7500, n_player_modifier);
		level.MECHZ_POWERCAP_HEALTH = function_26beb37e(level.MECHZ_POWERCAP_HEALTH, 5000, n_player_modifier);
		level.mechz_armor_health = function_26beb37e(level.mechz_armor_health, 3500, n_player_modifier);
		level.mechz_last_spawn_round = level.round_number;
	}
}

/*
	Name: function_26beb37e
	Namespace: zm_genesis_mechz
	Checksum: 0xD8F5E84C
	Offset: 0x19B8
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function function_26beb37e(n_value, n_limit, n_player_modifier)
{
	if(n_value >= n_limit * n_player_modifier)
	{
		n_value = Int(n_limit * n_player_modifier);
	}
	return n_value;
}

/*
	Name: function_d8d01032
	Namespace: zm_genesis_mechz
	Checksum: 0x3FA40FB3
	Offset: 0x1A18
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function function_d8d01032()
{
	self.idgun_damage_cb = &function_5f2149bb;
	self.var_c732138b = &function_1df1ec14;
	self.traversalSpeedBoost = &function_40ef38f8;
	self thread function_a2a11991();
	self thread mechz_corpse();
	self thread function_2a26e636();
	self thread zm::update_zone_name();
	self waittill("death");
	self thread function_2a2bfc25();
	if(isdefined(self.var_9b31a70d) && self.var_9b31a70d)
	{
		level.var_638dde56--;
	}
	level notify("hash_8f65ad3d");
}

/*
	Name: spawn_effect
	Namespace: zm_genesis_mechz
	Checksum: 0x395BF9F3
	Offset: 0x1B20
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function spawn_effect()
{
	self mechz_freeze();
	util::wait_network_frame();
	self clientfield::increment("mechz_fx_spawn");
	wait(1);
	self function_ee090a93();
}

/*
	Name: function_b7e11612
	Namespace: zm_genesis_mechz
	Checksum: 0x2363B45C
	Offset: 0x1B90
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_b7e11612()
{
	self waittill("death");
	self zm_genesis_vo::function_f7879c72(self.attacker);
}

/*
	Name: mechz_corpse
	Namespace: zm_genesis_mechz
	Checksum: 0xF4DCA2D
	Offset: 0x1BC8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function mechz_corpse()
{
	self waittill("actor_corpse", mechz);
	wait(60);
	if(isdefined(mechz))
	{
		mechz delete();
	}
}

/*
	Name: function_2a26e636
	Namespace: zm_genesis_mechz
	Checksum: 0x89EA333C
	Offset: 0x1C18
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function function_2a26e636()
{
	self endon("death");
	while(1)
	{
		if(!isdefined(self.zone_name))
		{
			wait(0.1);
			continue;
		}
		var_225b5e15 = 1;
		var_e01c8f74 = 1;
		players = GetPlayers();
		foreach(player in players)
		{
			if(isdefined(player.b_is_flung) && player.b_is_flung || (isdefined(player.var_a393601c) && player.var_a393601c))
			{
				var_225b5e15 = 0;
				var_e01c8f74 = 0;
				break;
				continue;
			}
			if(isdefined(player.am_i_valid) && player.am_i_valid)
			{
				if(!isdefined(player.zone_name))
				{
					var_225b5e15 = 0;
					var_e01c8f74 = 0;
					break;
				}
				if(isdefined(player.zone_name))
				{
					if(player.zone_name == "apothicon_interior_zone")
					{
						var_e01c8f74 = 0;
						continue;
					}
					var_225b5e15 = 0;
				}
			}
		}
		var_9626d5b6 = 0;
		if(self.zone_name == "apothicon_interior_zone")
		{
			var_9626d5b6 = 1;
		}
		if(var_225b5e15 && !var_9626d5b6 || (var_e01c8f74 && var_9626d5b6))
		{
			break;
		}
		wait(0.5);
	}
	self thread genesis_mechz_cleanup();
}

/*
	Name: genesis_mechz_cleanup
	Namespace: zm_genesis_mechz
	Checksum: 0x7B4EFA08
	Offset: 0x1E68
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function genesis_mechz_cleanup()
{
	wait(0.05);
	if(isdefined(self))
	{
		self delete();
	}
	wait(1.1);
	level thread zm_genesis_round_bosses::spawn_boss("mechz");
}

/*
	Name: function_a2a11991
	Namespace: zm_genesis_mechz
	Checksum: 0xDFD65FD3
	Offset: 0x1EC8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_a2a11991()
{
	self endon("death");
	while(!isdefined(self.zombie_lift_override))
	{
		wait(0.05);
	}
	self.zombie_lift_override = &function_2d571578;
}

/*
	Name: function_2a2bfc25
	Namespace: zm_genesis_mechz
	Checksum: 0x7668C947
	Offset: 0x1F10
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_2a2bfc25()
{
	self waittill("hash_46c1e51d");
	if(level flag::get("zombie_drop_powerups") && (!isdefined(self.no_powerups) && self.no_powerups))
	{
		a_bonus_types = Array("double_points", "insta_kill", "full_ammo", "nuke");
		str_type = Array::random(a_bonus_types);
		zm_powerups::specific_powerup_drop(str_type, self.origin);
	}
}

/*
	Name: function_f517cdd6
	Namespace: zm_genesis_mechz
	Checksum: 0x127817F3
	Offset: 0x1FE0
	Size: 0x63
	Parameters: 12
	Flags: None
*/
function function_f517cdd6(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
}

/*
	Name: teleporttraversalmocompstart
	Namespace: zm_genesis_mechz
	Checksum: 0x55D305A2
	Offset: 0x2050
	Size: 0xDB
	Parameters: 5
	Flags: None
*/
function teleporttraversalmocompstart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.is_teleporting = 1;
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("normal");
	if(isdefined(entity.traverseStartNode))
	{
		portal_trig = entity.traverseStartNode.portal_trig;
		portal_trig thread namespace_766d6099::portal_teleport_ai(entity);
	}
}

/*
	Name: function_2d571578
	Namespace: zm_genesis_mechz
	Checksum: 0xF5B7B7A4
	Offset: 0x2138
	Size: 0x2C7
	Parameters: 6
	Flags: None
*/
function function_2d571578(e_player, v_attack_source, n_push_away, n_lift_height, v_lift_offset, n_lift_speed)
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
		self thread function_a0b6d6b9(self);
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
	Name: function_a0b6d6b9
	Namespace: zm_genesis_mechz
	Checksum: 0xCDD8F98B
	Offset: 0x2408
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_a0b6d6b9(mechz)
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
	Name: function_5f2149bb
	Namespace: zm_genesis_mechz
	Checksum: 0xBE06B1AA
	Offset: 0x25B8
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function function_5f2149bb(inflictor, attacker)
{
	var_3bb42832 = level.mechz_health;
	n_damage = var_3bb42832 * 0.25 / 0.2;
	self DoDamage(n_damage, self GetCentroid(), inflictor, attacker, undefined, "MOD_PROJECTILE_SPLASH", 0, GetWeapon("none"));
}

/*
	Name: function_1df1ec14
	Namespace: zm_genesis_mechz
	Checksum: 0xF9FD1480
	Offset: 0x2668
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private function_1df1ec14()
{
	if(self zm_ai_mechz::function_58655f2a())
	{
		self.stun = 1;
		return 1;
	}
	return 0;
}

/*
	Name: function_40ef38f8
	Namespace: zm_genesis_mechz
	Checksum: 0x868B0E29
	Offset: 0x26A8
	Size: 0xAD
	Parameters: 0
	Flags: Private
*/
function private function_40ef38f8()
{
	traversal = self.traversal;
	speedBoost = 0;
	if(traversal.absLengthToEnd > 200)
	{
		speedBoost = 48;
	}
	else if(traversal.absLengthToEnd > 120)
	{
		speedBoost = 24;
	}
	else if(traversal.absLengthToEnd > 80 || traversal.absHeightToEnd > 80)
	{
		speedBoost = 12;
	}
	return speedBoost;
}

/*
	Name: mechz_damage_override
	Namespace: zm_genesis_mechz
	Checksum: 0xDCC4E48E
	Offset: 0x2760
	Size: 0x45
	Parameters: 2
	Flags: None
*/
function mechz_damage_override(attacker, damage)
{
	if(isdefined(attacker.var_bbd3efb8))
	{
		damage = damage * attacker.var_bbd3efb8;
	}
	return damage;
}

/*
	Name: mechz_freeze
	Namespace: zm_genesis_mechz
	Checksum: 0xEBF31B1C
	Offset: 0x27B0
	Size: 0x6B
	Parameters: 0
	Flags: Private
*/
function private mechz_freeze()
{
	self.canDamage = 0;
	self.isFrozen = 1;
	self ghost();
	self notsolid();
	self PathMode("dont move");
}

/*
	Name: function_ee090a93
	Namespace: zm_genesis_mechz
	Checksum: 0x6950A9C0
	Offset: 0x2828
	Size: 0x6F
	Parameters: 0
	Flags: Private
*/
function private function_ee090a93()
{
	self.isFrozen = 0;
	self show();
	self solid();
	wait(0.5);
	self PathMode("move allowed");
	self.canDamage = 1;
}

/*
	Name: function_78e44cda
	Namespace: zm_genesis_mechz
	Checksum: 0xB373F219
	Offset: 0x28A0
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function function_78e44cda()
{
	/#
		wait(0.05);
		level waittill("start_zombie_round_logic");
		wait(0.05);
		SetDvar("Dev Block strings are not supported", 0);
		AddDebugCommand("Dev Block strings are not supported");
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				SetDvar("Dev Block strings are not supported", 0);
				level thread function_eac1444a();
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_eac1444a
	Namespace: zm_genesis_mechz
	Checksum: 0x5DA0BFA5
	Offset: 0x2960
	Size: 0x281
	Parameters: 0
	Flags: None
*/
function function_eac1444a()
{
	/#
		var_10b176f0 = GetAIArchetypeArray("Dev Block strings are not supported");
		foreach(ai_mechz in var_10b176f0)
		{
			var_efe3c52f = level.activePlayers[0] GetTagOrigin("Dev Block strings are not supported") + VectorScale((0, 0, 1), 20);
			var_7ddc55f4 = level.activePlayers[0] GetTagOrigin("Dev Block strings are not supported") + (5, 0, 20);
			var_a3ded05d = level.activePlayers[0] GetTagOrigin("Dev Block strings are not supported") + (-5, 0, 20);
			var_31d76122 = level.activePlayers[0] GetTagOrigin("Dev Block strings are not supported") + VectorScale((0, 0, 1), 15);
			MagicBullet(level.var_e106fba5, var_efe3c52f, ai_mechz GetCentroid(), level.activePlayers[0]);
			MagicBullet(level.var_791ba87b, var_7ddc55f4, ai_mechz GetCentroid(), level.activePlayers[0]);
			MagicBullet(level.var_5d4538da, var_a3ded05d, ai_mechz GetCentroid(), level.activePlayers[0]);
			MagicBullet(level.var_30611368, var_31d76122, ai_mechz GetCentroid(), level.activePlayers[0]);
		}
	#/
}

/*
	Name: function_22cf3e9f
	Namespace: zm_genesis_mechz
	Checksum: 0xDAD1DE02
	Offset: 0x2BF0
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function function_22cf3e9f(str_weapon_name, v_source, ai_mechz)
{
	/#
		MagicBullet(level.var_791ba87b, v_source, ai_mechz GetCentroid(), level.activePlayers[0]);
	#/
}

