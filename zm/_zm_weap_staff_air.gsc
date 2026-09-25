#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_staff_common;
#using scripts\zm\zm_tomb_utility;

#namespace namespace_589e3c80;

/*
	Name: __init__sytem__
	Namespace: namespace_589e3c80
	Checksum: 0xA3F2B770
	Offset: 0x410
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_air", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_589e3c80
	Checksum: 0xF1BFE87D
	Offset: 0x450
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["whirlwind"] = "weapon/zmb_staff/fx_zmb_staff_air_ug_impact_miss";
	clientfield::register("scriptmover", "whirlwind_play_fx", 21000, 1, "int");
	clientfield::register("actor", "air_staff_launch", 21000, 1, "int");
	clientfield::register("allplayers", "air_staff_source", 21000, 1, "int");
	callback::on_spawned(&onPlayerSpawned);
	level flag::init("whirlwind_active");
	zm_spawner::register_zombie_damage_callback(&staff_air_zombie_damage_response);
	zm_spawner::register_zombie_death_event_callback(&staff_air_death_event);
	level.var_3481edfa = GetWeapon("staff_air");
	level.var_7830b075 = GetWeapon("staff_air_upgraded");
}

/*
	Name: onPlayerSpawned
	Namespace: namespace_589e3c80
	Checksum: 0xB7C64E83
	Offset: 0x5C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	self endon("disconnect");
	self thread watch_staff_air_fired();
	self thread watch_staff_air_impact();
	self thread zm_tomb_utility::watch_staff_usage();
}

/*
	Name: air_projectile_delete
	Namespace: namespace_589e3c80
	Checksum: 0x1E14AEF2
	Offset: 0x628
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function air_projectile_delete()
{
	self endon("death");
	wait(0.75);
	self delete();
}

/*
	Name: watch_staff_air_fired
	Namespace: namespace_589e3c80
	Checksum: 0x9B3F49F1
	Offset: 0x660
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function watch_staff_air_fired()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("missile_fire", e_projectile, w_weapon);
		if(w_weapon.name == "staff_air_upgraded" || w_weapon.name == "staff_air")
		{
			e_projectile thread air_projectile_delete();
			wind_damage_cone(w_weapon);
			self clientfield::set("air_staff_source", 1);
			util::wait_network_frame();
			self clientfield::set("air_staff_source", 0);
		}
	}
}

/*
	Name: watch_staff_air_impact
	Namespace: namespace_589e3c80
	Checksum: 0xCE57585E
	Offset: 0x760
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function watch_staff_air_impact()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("projectile_impact", w_weapon, v_explode_point, n_radius, projectile);
		if(w_weapon.name == "staff_air_upgraded2" || w_weapon.name == "staff_air_upgraded3")
		{
			self thread staff_air_find_source(v_explode_point, w_weapon);
		}
	}
}

/*
	Name: staff_air_find_source
	Namespace: namespace_589e3c80
	Checksum: 0xAA8CA3D7
	Offset: 0x818
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function staff_air_find_source(v_detonate, w_weapon)
{
	self endon("disconnect");
	if(!isdefined(v_detonate))
	{
		return;
	}
	a_zombies = GetAIArray();
	a_zombies = util::get_array_of_closest(v_detonate, a_zombies);
	if(a_zombies.size)
	{
		for(i = 0; i < a_zombies.size; i++)
		{
			if(isalive(a_zombies[i]))
			{
				if(isdefined(a_zombies[i].staff_hit) && a_zombies[i].staff_hit)
				{
					continue;
				}
				if(Distance2DSquared(v_detonate, a_zombies[i].origin) <= 10000)
				{
					self thread staff_air_zombie_source(a_zombies[0], w_weapon);
				}
				else
				{
					self thread staff_air_position_source(v_detonate, w_weapon);
				}
				return;
			}
		}
	}
	else
	{
		self thread staff_air_position_source(v_detonate, w_weapon);
	}
}

/*
	Name: staff_air_zombie_source
	Namespace: namespace_589e3c80
	Checksum: 0xFF8D0695
	Offset: 0x9A8
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function staff_air_zombie_source(ai_zombie, w_weapon)
{
	self endon("disconnect");
	ai_zombie.staff_hit = 1;
	ai_zombie.is_source = 1;
	v_whirlwind_pos = ai_zombie.origin;
	self thread staff_air_position_source(v_whirlwind_pos, w_weapon);
	if(!isdefined(ai_zombie.is_mechz))
	{
		self thread source_zombie_death(ai_zombie);
	}
}

/*
	Name: staff_air_position_source
	Namespace: namespace_589e3c80
	Checksum: 0xDB61B19E
	Offset: 0xA60
	Size: 0x23B
	Parameters: 2
	Flags: None
*/
function staff_air_position_source(v_detonate, w_weapon)
{
	self endon("disconnect");
	if(!isdefined(v_detonate))
	{
		return;
	}
	if(level flag::get("whirlwind_active"))
	{
		level notify("whirlwind_stopped");
		while(level flag::get("whirlwind_active"))
		{
			util::wait_network_frame();
		}
		wait(0.3);
	}
	level flag::set("whirlwind_active");
	n_time = self.chargeShotLevel * 3.5;
	e_whirlwind = spawn("script_model", v_detonate + VectorScale((0, 0, 1), 100));
	e_whirlwind SetModel("tag_origin");
	e_whirlwind.angles = VectorScale((-1, 0, 0), 90);
	e_whirlwind thread zm_tomb_utility::puzzle_debug_position("X", VectorScale((1, 1, 0), 255));
	e_whirlwind moveto(zm_utility::groundpos_ignore_water_new(e_whirlwind.origin), 0.05);
	e_whirlwind waittill("movedone");
	e_whirlwind clientfield::set("whirlwind_play_fx", 1);
	e_whirlwind thread zm_tomb_utility::whirlwind_rumble_nearby_players("whirlwind_active");
	e_whirlwind thread whirlwind_timeout(n_time);
	wait(0.5);
	e_whirlwind.player_owner = self;
	e_whirlwind thread whirlwind_seek_zombies(self.chargeShotLevel, w_weapon);
}

/*
	Name: whirlwind_seek_zombies
	Namespace: namespace_589e3c80
	Checksum: 0x654A88D6
	Offset: 0xCA8
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function whirlwind_seek_zombies(n_level, w_weapon)
{
	self endon("death");
	self.b_found_zombies = 0;
	n_range = get_air_blast_range(n_level);
	while(1)
	{
		a_zombies = staff_air_zombie_range(self.origin, n_range);
		if(a_zombies.size)
		{
			self.b_found_zombies = 1;
			self thread whirlwind_kill_zombies(n_level, w_weapon);
			break;
		}
		wait(0.1);
	}
}

/*
	Name: whirlwind_timeout
	Namespace: namespace_589e3c80
	Checksum: 0xBEC17C94
	Offset: 0xD70
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function whirlwind_timeout(n_time)
{
	self endon("death");
	level util::waittill_any_timeout(n_time, "whirlwind_stopped");
	level notify("whirlwind_stopped");
	self clientfield::set("whirlwind_play_fx", 0);
	self notify("stop_debug_position");
	level flag::clear("whirlwind_active");
	wait(1.5);
	self delete();
}

/*
	Name: move_along_ground_position
	Namespace: namespace_589e3c80
	Checksum: 0x69BCFA69
	Offset: 0xE28
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function move_along_ground_position(v_position, n_time)
{
	v_diff = VectorNormalize(v_position - self.origin);
	v_newpos = self.origin + v_diff * 50 + VectorScale((0, 0, 1), 50);
	v_ground = zm_utility::groundpos_ignore_water_new(v_newpos);
	self moveto(v_ground, n_time);
}

/*
	Name: whirlwind_kill_zombies
	Namespace: namespace_589e3c80
	Checksum: 0x8BD63839
	Offset: 0xEE0
	Size: 0x2C7
	Parameters: 2
	Flags: None
*/
function whirlwind_kill_zombies(n_level, w_weapon)
{
	self endon("death");
	n_range = get_air_blast_range(n_level);
	self.n_charge_level = n_level;
	while(1)
	{
		a_zombies = staff_air_zombie_range(self.origin, n_range);
		a_zombies = util::get_array_of_closest(self.origin, a_zombies);
		for(i = 0; i < a_zombies.size; i++)
		{
			if(!isdefined(a_zombies[i]))
			{
				continue;
			}
			if(!(isdefined(a_zombies[i].completed_emerging_into_playable_area) && a_zombies[i].completed_emerging_into_playable_area))
			{
				continue;
			}
			if(isdefined(a_zombies[i].is_mechz) && a_zombies[i].is_mechz)
			{
				continue;
			}
			if(isdefined(self._whirlwind_attract_anim) && self._whirlwind_attract_anim)
			{
				continue;
			}
			v_offset = (10, 10, 32);
			if(!zm_tomb_utility::bullet_trace_throttled(self.origin + v_offset, a_zombies[i].origin + v_offset, undefined))
			{
				continue;
			}
			if(!isdefined(a_zombies[i]) || !isalive(a_zombies[i]))
			{
				continue;
			}
			v_offset = (-10, -10, 64);
			if(!zm_tomb_utility::bullet_trace_throttled(self.origin + v_offset, a_zombies[i].origin + v_offset, undefined))
			{
				continue;
			}
			if(!isdefined(a_zombies[i]) || !isalive(a_zombies[i]))
			{
				continue;
			}
			a_zombies[i] thread whirlwind_drag_zombie(self, w_weapon);
			wait(0.5);
		}
		util::wait_network_frame();
	}
}

/*
	Name: whirlwind_drag_zombie
	Namespace: namespace_589e3c80
	Checksum: 0x9E4F41FC
	Offset: 0x11B0
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function whirlwind_drag_zombie(e_whirlwind, w_weapon)
{
	if(isdefined(self.e_linker))
	{
		return;
	}
	self whirlwind_move_zombie(e_whirlwind);
	if(isdefined(self) && isdefined(e_whirlwind) && level flag::get("whirlwind_active"))
	{
		player = e_whirlwind.player_owner;
		self zm_tomb_utility::do_damage_network_safe(player, self.health, w_weapon, "MOD_IMPACT");
		level thread staff_air_gib(self);
	}
}

/*
	Name: whirlwind_move_zombie
	Namespace: namespace_589e3c80
	Checksum: 0x93D1DF45
	Offset: 0x1288
	Size: 0x233
	Parameters: 1
	Flags: None
*/
function whirlwind_move_zombie(e_whirlwind)
{
	if(isdefined(self.e_linker))
	{
		return;
	}
	self.e_linker = spawn("script_origin", (0, 0, 0));
	self.e_linker.origin = self.origin;
	self.e_linker.angles = self.angles;
	self LinkTo(self.e_linker);
	self thread whirlwind_unlink(e_whirlwind);
	if(isdefined(e_whirlwind))
	{
		n_dist_sq = Distance2DSquared(e_whirlwind.origin, self.origin);
	}
	n_fling_range_sq = 900;
	while(isalive(self) && n_dist_sq > n_fling_range_sq && isdefined(e_whirlwind) && level flag::get("whirlwind_active"))
	{
		n_dist_sq = Distance2DSquared(e_whirlwind.origin, self.origin);
		b_supercharged = e_whirlwind.n_charge_level == 3;
		self thread whirlwind_attract_anim(e_whirlwind.origin, b_supercharged);
		n_movetime = 1;
		if(b_supercharged)
		{
			n_movetime = 0.8;
		}
		self.e_linker thread move_along_ground_position(e_whirlwind.origin, n_movetime);
		wait(0.05);
	}
	self notify("reached_whirlwind");
	self.e_linker delete();
}

/*
	Name: whirlwind_unlink
	Namespace: namespace_589e3c80
	Checksum: 0xD89FDCB
	Offset: 0x14C8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function whirlwind_unlink(e_whirlwind)
{
	self endon("death");
	e_whirlwind waittill("death");
	self Unlink();
}

/*
	Name: source_zombie_death
	Namespace: namespace_589e3c80
	Checksum: 0x9E794768
	Offset: 0x1510
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function source_zombie_death(ai_zombie)
{
	self endon("disconnect");
	n_range = get_air_blast_range(self.chargeShotLevel);
	tag = "J_SpineUpper";
	if(ai_zombie.isdog)
	{
		tag = "J_Spine1";
	}
	v_source = ai_zombie GetTagOrigin(tag);
	ai_zombie thread staff_air_fling_zombie(self);
	a_zombies = staff_air_zombie_range(v_source, n_range);
	if(!isdefined(a_zombies))
	{
		return;
	}
	self thread staff_air_proximity_kill(a_zombies);
}

/*
	Name: get_air_blast_range
	Namespace: namespace_589e3c80
	Checksum: 0xEA0EEF7F
	Offset: 0x1610
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function get_air_blast_range(n_charge)
{
	switch(n_charge)
	{
		case 1:
		{
			n_range = 100;
			break;
		}
		case default:
		{
			n_range = 250;
			break;
		}
	}
	return n_range;
}

/*
	Name: staff_air_proximity_kill
	Namespace: namespace_589e3c80
	Checksum: 0xD6295F9C
	Offset: 0x1670
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function staff_air_proximity_kill(a_zombies)
{
	self endon("disconnect");
	if(!isdefined(a_zombies))
	{
		return;
	}
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isalive(a_zombies[i]))
		{
			a_zombies[i] thread staff_air_fling_zombie(self);
			wait(0.05);
		}
	}
}

/*
	Name: staff_air_zombie_range
	Namespace: namespace_589e3c80
	Checksum: 0x63312265
	Offset: 0x1708
	Size: 0x15D
	Parameters: 2
	Flags: None
*/
function staff_air_zombie_range(v_source, n_range)
{
	a_enemies = [];
	a_zombies = GetAIArray();
	a_zombies = util::get_array_of_closest(v_source, a_zombies);
	n_range_sq = n_range * n_range;
	if(isdefined(a_zombies))
	{
		for(i = 0; i < a_zombies.size; i++)
		{
			if(!isdefined(a_zombies[i]))
			{
				continue;
			}
			v_zombie_pos = a_zombies[i].origin;
			if(isdefined(a_zombies[i].staff_hit) && a_zombies[i].staff_hit == 1)
			{
				continue;
			}
			if(DistanceSquared(v_source, v_zombie_pos) > n_range_sq)
			{
				continue;
			}
			a_enemies[a_enemies.size] = a_zombies[i];
		}
	}
	return a_enemies;
}

/*
	Name: staff_air_fling_zombie
	Namespace: namespace_589e3c80
	Checksum: 0xFBE45639
	Offset: 0x1870
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function staff_air_fling_zombie(player)
{
	player endon("disconnect");
	if(!isalive(self))
	{
		return;
	}
	if(isdefined(self.is_source) || math::cointoss())
	{
		self thread zombie_launch(player, level.var_7830b075);
	}
	else
	{
		self zm_tomb_utility::do_damage_network_safe(player, self.health, level.var_7830b075, "MOD_IMPACT");
		level thread staff_air_gib(self);
	}
}

/*
	Name: zombie_launch
	Namespace: namespace_589e3c80
	Checksum: 0x2A57743E
	Offset: 0x1938
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function zombie_launch(e_attacker, w_weapon)
{
	self zm_tomb_utility::do_damage_network_safe(e_attacker, self.health, w_weapon, "MOD_IMPACT");
	if(isdefined(level.ragdoll_limit_check) && ![[level.ragdoll_limit_check]]())
	{
		level thread staff_air_gib(self);
	}
	else if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	self StartRagdoll();
	self clientfield::set("air_staff_launch", 1);
}

/*
	Name: determine_launch_vector
	Namespace: namespace_589e3c80
	Checksum: 0x5007A274
	Offset: 0x1A10
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function determine_launch_vector(e_attacker, ai_target)
{
	v_launch = VectorNormalize(ai_target.origin - e_attacker.origin) * randomIntRange(125, 150) + (0, 0, randomIntRange(75, 150));
	return v_launch;
}

/*
	Name: staff_air_gib
	Namespace: namespace_589e3c80
	Checksum: 0xEDB8979F
	Offset: 0x1AA8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function staff_air_gib(ai_zombie)
{
	if(math::cointoss())
	{
		ai_zombie thread zm_tomb_utility::zombie_gib_all();
	}
	ai_zombie thread zm_tomb_utility::zombie_gib_guts();
}

/*
	Name: staff_air_zombie_damage_response
	Namespace: namespace_589e3c80
	Checksum: 0xCF913AB6
	Offset: 0x1B00
	Size: 0xBB
	Parameters: 13
	Flags: None
*/
function staff_air_zombie_damage_response(mod, HIT_LOCATION, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(self is_staff_air_damage(self.damageWeapon) && mod != "MOD_MELEE")
	{
		self thread stun_zombie();
		return 1;
	}
	return 0;
}

/*
	Name: is_staff_air_damage
	Namespace: namespace_589e3c80
	Checksum: 0xE2520E72
	Offset: 0x1BC8
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function is_staff_air_damage(weapon)
{
	return isdefined(weapon) && (weapon.name == "staff_air" || weapon.name == "staff_air_upgraded") && (!isdefined(self.set_beacon_damage) && self.set_beacon_damage);
}

/*
	Name: staff_air_death_event
	Namespace: namespace_589e3c80
	Checksum: 0x622DC4F3
	Offset: 0x1C30
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function staff_air_death_event(attacker)
{
	if(is_staff_air_damage(self.damageWeapon) && self.damageMod != "MOD_MELEE")
	{
		if(isdefined(self.is_mechz) && self.is_mechz)
		{
			return;
		}
		self thread zombie_utility::zombie_eye_glow_stop();
		if(isdefined(level.ragdoll_limit_check) && ![[level.ragdoll_limit_check]]())
		{
			level thread staff_air_gib(self);
		}
		else
		{
			self StartRagdoll();
			self clientfield::set("air_staff_launch", 1);
		}
	}
}

/*
	Name: wind_damage_cone
	Namespace: namespace_589e3c80
	Checksum: 0x7072F67A
	Offset: 0x1D18
	Size: 0x211
	Parameters: 1
	Flags: None
*/
function wind_damage_cone(w_weapon)
{
	fire_angles = self getPlayerAngles();
	fire_origin = self GetPlayerCameraPos();
	a_targets = GetAIArray();
	a_targets = util::get_array_of_closest(self.origin, a_targets, undefined, 12, 400);
	if(w_weapon.name == "staff_air_upgraded")
	{
		n_damage = 3300;
		n_fov = 60;
	}
	else
	{
		n_damage = 2050;
		n_fov = 45;
	}
	foreach(target in a_targets)
	{
		if(isai(target))
		{
			if(util::within_fov(fire_origin, fire_angles, target GetTagOrigin("j_spine4"), cos(n_fov)))
			{
				if(self zm_powerups::is_insta_kill_active())
				{
					n_damage = target.health;
				}
				target zm_tomb_utility::do_damage_network_safe(self, n_damage, w_weapon, "MOD_IMPACT");
			}
		}
	}
}

/*
	Name: stun_zombie
	Namespace: namespace_589e3c80
	Checksum: 0x7A6F27BB
	Offset: 0x1F38
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function stun_zombie()
{
	self endon("death");
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	if(isdefined(self.is_electrocuted) && self.is_electrocuted)
	{
		return;
	}
	if(!isdefined(self.ai_state) || self.ai_state != "find_flesh")
	{
		return;
	}
	self.forceMovementScriptState = 1;
	self.ignoreall = 1;
	self.is_electrocuted = 1;
	tag = "J_SpineUpper";
	if(self.isdog)
	{
		tag = "J_Spine1";
	}
	self zombie_shared::DoNoteTracks("stunned");
	self.forceMovementScriptState = 0;
	self.ignoreall = 0;
	self.is_electrocuted = 0;
}

/*
	Name: whirlwind_attract_anim_watch_cancel
	Namespace: namespace_589e3c80
	Checksum: 0x62B57C7C
	Offset: 0x2038
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function whirlwind_attract_anim_watch_cancel()
{
	self endon("death");
	while(level flag::get("whirlwind_active"))
	{
		util::wait_network_frame();
	}
	self.deathAnim = undefined;
	self StopAnimScripted();
	self._whirlwind_attract_anim = 0;
}

/*
	Name: whirlwind_attract_anim
	Namespace: namespace_589e3c80
	Checksum: 0xBC0FEEA6
	Offset: 0x20B0
	Size: 0x1DF
	Parameters: 2
	Flags: None
*/
function whirlwind_attract_anim(v_attract_point, b_move_fast)
{
	if(!isdefined(b_move_fast))
	{
		b_move_fast = 0;
	}
	self endon("death");
	level endon("whirlwind_stopped");
	if(isdefined(self._whirlwind_attract_anim) && self._whirlwind_attract_anim)
	{
		return;
	}
	v_angles_to_source = VectorToAngles(v_attract_point - self.origin);
	v_source_to_target = VectorToAngles(self.origin - v_attract_point);
	self.a.runBlendTime = 0.9;
	if(!(isdefined(self.missingLegs) && self.missingLegs))
	{
		self._had_legs = 1;
	}
	else
	{
		self._had_legs = 0;
	}
	if(b_move_fast)
	{
		blackboard::SetBlackBoardAttribute(self, "_whirlwind_speed", "whirlwind_fast");
	}
	else
	{
		blackboard::SetBlackBoardAttribute(self, "_whirlwind_speed", "whirlwind_normal");
	}
	if(isdefined(self.nogravity) && self.nogravity)
	{
		self animMode("none");
		self.nogravity = undefined;
	}
	self._whirlwind_attract_anim = 1;
	self.a.runBlendTime = self._normal_run_blend_time;
	self thread whirlwind_attract_anim_watch_cancel();
	self waittill("reached_whirlwind");
}

