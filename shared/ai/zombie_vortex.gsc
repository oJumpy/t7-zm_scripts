#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zombie_vortex;

/*
	Name: __init__sytem__
	Namespace: zombie_vortex
	Checksum: 0x9C5A6D42
	Offset: 0x300
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vortex_shared", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zombie_vortex
	Checksum: 0xA2E72EBC
	Offset: 0x348
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.vsmgr_prio_visionset_zombie_vortex))
	{
		level.vsmgr_prio_visionset_zombie_vortex = 23;
	}
	if(!isdefined(level.vsmgr_prio_overlay_zombie_vortex))
	{
		level.vsmgr_prio_overlay_zombie_vortex = 23;
	}
	visionset_mgr::register_info("visionset", "zm_idgun_vortex" + "_visionset", 1, level.vsmgr_prio_visionset_zombie_vortex, 30, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	visionset_mgr::register_info("overlay", "zm_idgun_vortex" + "_blur", 1, level.vsmgr_prio_overlay_zombie_vortex, 1, 1, &visionset_mgr::ramp_in_out_thread_per_player, 1);
	clientfield::register("scriptmover", "vortex_start", 1, 2, "counter");
	clientfield::register("allplayers", "vision_blur", 1, 1, "int");
	level.vortex_manager = spawnstruct();
	level.vortex_manager.count = 0;
	level.vortex_manager.a_vorticies = [];
	level.vortex_manager.a_active_vorticies = [];
	level.vortex_id = 0;
	init_vortices();
}

/*
	Name: __main__
	Namespace: zombie_vortex
	Checksum: 0xAE870778
	Offset: 0x4F0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level vehicle_ai::register_custom_add_state_callback(&idgun_add_vehicle_death_state);
}

/*
	Name: init_vortices
	Namespace: zombie_vortex
	Checksum: 0xC63596C0
	Offset: 0x520
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function init_vortices()
{
	for(i = 0; i < 8; i++)
	{
		sVortex = spawn("script_model", (0, 0, 0));
		if(!isdefined(level.vortex_manager.a_vorticies))
		{
			level.vortex_manager.a_vorticies = [];
		}
		else if(!IsArray(level.vortex_manager.a_vorticies))
		{
			level.vortex_manager.a_vorticies = Array(level.vortex_manager.a_vorticies);
		}
		level.vortex_manager.a_vorticies[level.vortex_manager.a_vorticies.size] = sVortex;
	}
}

/*
	Name: get_unused_vortex
	Namespace: zombie_vortex
	Checksum: 0x13B113B
	Offset: 0x620
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function get_unused_vortex()
{
	foreach(vortex in level.vortex_manager.a_vorticies)
	{
		if(!(isdefined(vortex.in_use) && vortex.in_use))
		{
			return vortex;
		}
	}
	return level.vortex_manager.a_vorticies[0];
}

/*
	Name: get_active_vortex_count
	Namespace: zombie_vortex
	Checksum: 0x62EC3668
	Offset: 0x6E0
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function get_active_vortex_count()
{
	count = 0;
	foreach(vortex in level.vortex_manager.a_vorticies)
	{
		if(isdefined(vortex.in_use) && vortex.in_use)
		{
			count++;
		}
	}
	return count;
}

/*
	Name: stop_vortex_fx_after_time
	Namespace: zombie_vortex
	Checksum: 0x1CBDF75
	Offset: 0x7A8
	Size: 0x71
	Parameters: 4
	Flags: Private
*/
function private stop_vortex_fx_after_time(vortex_fx_handle, vortex_position, vortex_explosion_fx, n_vortex_time)
{
	n_starttime = GetTime();
	for(n_curtime = GetTime() - n_starttime; n_curtime < n_vortex_time;  = GetTime() - n_starttime)
	{
		wait(0.05);
	}
}

/*
	Name: start_timed_vortex
	Namespace: zombie_vortex
	Checksum: 0xEF231649
	Offset: 0x828
	Size: 0xA8B
	Parameters: 13
	Flags: None
*/
function start_timed_vortex(v_vortex_origin, n_vortex_radius, vortex_pull_duration, vortex_effect_duration, n_vortex_explosion_radius, eAttacker, weapon, should_shellshock_player, visionset_func, should_shield, effect_version, should_explode, vortex_projectile)
{
	if(!isdefined(should_shellshock_player))
	{
		should_shellshock_player = 0;
	}
	if(!isdefined(visionset_func))
	{
		visionset_func = undefined;
	}
	if(!isdefined(should_shield))
	{
		should_shield = 0;
	}
	if(!isdefined(effect_version))
	{
		effect_version = 0;
	}
	if(!isdefined(should_explode))
	{
		should_explode = 1;
	}
	if(!isdefined(vortex_projectile))
	{
		vortex_projectile = undefined;
	}
	self endon("death");
	self endon("disconnect");
	/#
		Assert(isdefined(v_vortex_origin), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(n_vortex_radius), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(vortex_pull_duration), "Dev Block strings are not supported");
	#/
	n_starttime = GetTime();
	n_currtime = GetTime() - n_starttime;
	a_e_players = GetPlayers();
	if(!isdefined(n_vortex_explosion_radius))
	{
		n_vortex_explosion_radius = n_vortex_radius * 1.5;
	}
	sVortex = get_unused_vortex();
	sVortex.in_use = 1;
	sVortex.attacker = eAttacker;
	sVortex.weapon = weapon;
	sVortex.angles = (0, 0, 0);
	sVortex.origin = v_vortex_origin;
	sVortex DontInterpolate();
	sVortex clientfield::increment("vortex_start", effect_version);
	s_active_vortex = struct::spawn(v_vortex_origin);
	s_active_vortex.weapon = weapon;
	s_active_vortex.attacker = eAttacker;
	if(!isdefined(level.vortex_manager.a_active_vorticies))
	{
		level.vortex_manager.a_active_vorticies = [];
	}
	else if(!IsArray(level.vortex_manager.a_active_vorticies))
	{
		level.vortex_manager.a_active_vorticies = Array(level.vortex_manager.a_active_vorticies);
	}
	level.vortex_manager.a_active_vorticies[level.vortex_manager.a_active_vorticies.size] = s_active_vortex;
	n_vortex_time_sv = vortex_pull_duration;
	if(isdefined(vortex_effect_duration))
	{
	}
	else
	{
	}
	n_vortex_time_cl = vortex_pull_duration;
	n_vortex_time = n_vortex_time_sv * 1000;
	team = "axis";
	if(isdefined(level.zombie_team))
	{
		team = level.zombie_team;
	}
	while(n_currtime <= n_vortex_time)
	{
		a_ai_zombies = Array::get_all_closest(v_vortex_origin, GetAITeamArray(team), undefined, undefined, n_vortex_radius);
		a_ai_zombies = ArrayCombine(a_ai_zombies, vortex_z_extension(a_ai_zombies, v_vortex_origin, n_vortex_radius), 0, 0);
		sVortex.zombies = a_ai_zombies;
		if(isdefined(level.idgun_draw_debug) && level.idgun_draw_debug)
		{
			/#
				circle(v_vortex_origin, n_vortex_radius, (0, 0, 1), 0, 1, 1);
			#/
		}
		foreach(ai_zombie in a_ai_zombies)
		{
			if(isVehicle(ai_zombie))
			{
				if(isalive(ai_zombie) && isdefined(ai_zombie vehicle_ai::get_state_callbacks("idgun_death")) && ai_zombie vehicle_ai::get_current_state() != "idgun_death" && !ai_zombie.ignorevortices)
				{
					params = spawnstruct();
					params.vPoint = v_vortex_origin;
					params.attacker = eAttacker;
					params.weapon = weapon;
					if(isdefined(ai_zombie.idgun_death_speed))
					{
						params.idgun_death_speed = ai_zombie.idgun_death_speed;
					}
					ai_zombie vehicle_ai::set_state("idgun_death", params);
				}
				continue;
			}
			if(!isdefined(ai_zombie.interdimensional_gun_kill) && ai_zombie.interdimensional_gun_kill && !ai_zombie.ignorevortices)
			{
				ai_zombie.damageOrigin = v_vortex_origin;
				if(isdefined(should_shield) && should_shield)
				{
					ai_zombie.allowdeath = 0;
					ai_zombie.magic_bullet_shield = 1;
				}
				ai_zombie.interdimensional_gun_kill = 1;
				ai_zombie.interdimensional_gun_attacker = eAttacker;
				ai_zombie.interdimensional_gun_inflictor = eAttacker;
				ai_zombie.interdimensional_gun_weapon = weapon;
				ai_zombie.interdimensional_gun_projectile = vortex_projectile;
			}
		}
		if(should_shellshock_player)
		{
			foreach(e_player in a_e_players)
			{
				if(isdefined(visionset_func))
				{
					e_player thread [[visionset_func]](v_vortex_origin, n_vortex_radius, n_starttime, n_vortex_time_sv, n_vortex_time_cl);
					continue;
				}
				if(isdefined(e_player) && (!isdefined(e_player.idgun_vision_on) && e_player.idgun_vision_on))
				{
					if(Distance(e_player.origin, v_vortex_origin) < float(n_vortex_radius / 2))
					{
						e_player thread player_vortex_visionset("zm_idgun_vortex");
					}
				}
			}
		}
		wait(0.05);
		n_currtime = GetTime() - n_starttime;
	}
	if(isdefined(should_explode) && should_explode)
	{
		n_time_to_wait_for_explosion = n_vortex_time_cl - n_vortex_time_sv + 0.35;
		wait(n_time_to_wait_for_explosion);
		sVortex.in_use = 0;
		ArrayRemoveValue(level.vortex_manager.a_active_vorticies, s_active_vortex);
		vortex_explosion(v_vortex_origin, eAttacker, n_vortex_explosion_radius);
	}
	else
	{
		foreach(zombie in sVortex.zombies)
		{
			if(!isdefined(zombie) || !isalive(zombie))
			{
				continue;
			}
			if(isdefined(level.vortexResetCondition) && [[level.vortexResetCondition]](zombie))
			{
				continue;
			}
			zombie.interdimensional_gun_kill = undefined;
			zombie.interdimensional_gun_attacker = undefined;
			zombie.interdimensional_gun_inflictor = undefined;
			zombie.interdimensional_gun_weapon = undefined;
			zombie.interdimensional_gun_projectile = undefined;
			zombie PathMode("move allowed");
		}
		sVortex.in_use = 0;
		ArrayRemoveValue(level.vortex_manager.a_active_vorticies, s_active_vortex);
	}
}

/*
	Name: vortex_z_extension
	Namespace: zombie_vortex
	Checksum: 0xD79D2B49
	Offset: 0x12C0
	Size: 0x15B
	Parameters: 3
	Flags: None
*/
function vortex_z_extension(a_ai_zombies, v_vortex_origin, n_vortex_radius)
{
	a_ai_zombies_extended = Array::get_all_closest(v_vortex_origin, GetAITeamArray("axis"), undefined, undefined, n_vortex_radius + 72);
	a_ai_zombies_extended_filtered = Array::exclude(a_ai_zombies_extended, a_ai_zombies);
	i = 0;
	while(i < a_ai_zombies_extended_filtered.size)
	{
		if(a_ai_zombies_extended_filtered[i].origin[2] < v_vortex_origin[2] && BulletTracePassed(a_ai_zombies_extended_filtered[i].origin + VectorScale((0, 0, 1), 5), v_vortex_origin + VectorScale((0, 0, 1), 20), 0, self, undefined, 0, 0))
		{
			i++;
		}
		else
		{
			ArrayRemoveValue(a_ai_zombies_extended_filtered, a_ai_zombies_extended_filtered[i]);
		}
	}
	return a_ai_zombies_extended_filtered;
}

/*
	Name: vortex_explosion
	Namespace: zombie_vortex
	Checksum: 0xF6447435
	Offset: 0x1428
	Size: 0x379
	Parameters: 3
	Flags: Private
*/
function private vortex_explosion(v_vortex_explosion_origin, eAttacker, n_vortex_radius)
{
	team = "axis";
	if(isdefined(level.zombie_team))
	{
		team = level.zombie_team;
	}
	a_ai_zombies = Array::get_all_closest(v_vortex_explosion_origin, GetAITeamArray(team), undefined, undefined, n_vortex_radius);
	if(isdefined(level.idgun_draw_debug) && level.idgun_draw_debug)
	{
		/#
			circle(v_vortex_explosion_origin, n_vortex_radius, (1, 0, 0), 0, 1, 1000);
		#/
	}
	foreach(ai_zombie in a_ai_zombies)
	{
		if(!ai_zombie.ignorevortices)
		{
			if(isdefined(ai_zombie.interdimensional_gun_kill) && ai_zombie.interdimensional_gun_kill)
			{
				ai_zombie Hide();
				continue;
			}
			ai_zombie.interdimensional_gun_kill = undefined;
			ai_zombie.interdimensional_gun_kill_vortex_explosion = 1;
			ai_zombie.veh_idgun_allow_damage = 1;
			if(isdefined(eAttacker))
			{
				ai_zombie DoDamage(ai_zombie.health + 10000, ai_zombie.origin, eAttacker, undefined, undefined, "MOD_EXPLOSIVE");
			}
			else
			{
				ai_zombie DoDamage(ai_zombie.health + 10000, ai_zombie.origin, undefined, undefined, undefined, "MOD_EXPLOSIVE");
			}
			n_radius_sqr = n_vortex_radius * n_vortex_radius;
			n_distance_sqr = DistanceSquared(ai_zombie.origin, v_vortex_explosion_origin);
			n_dist_mult = n_distance_sqr / n_radius_sqr;
			v_fling = VectorNormalize(ai_zombie.origin - v_vortex_explosion_origin);
			v_fling = (v_fling[0], v_fling[1], Abs(v_fling[2]));
			v_fling = VectorScale(v_fling, 100 + 100 * n_dist_mult);
			if(!(isdefined(level.ignore_vortex_ragdoll) && level.ignore_vortex_ragdoll))
			{
				ai_zombie StartRagdoll();
				ai_zombie LaunchRagdoll(v_fling);
			}
		}
	}
}

/*
	Name: player_vortex_visionset
	Namespace: zombie_vortex
	Checksum: 0xC451E690
	Offset: 0x17B0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function player_vortex_visionset(name)
{
	thread visionset_mgr::activate("visionset", name + "_visionset", self, 0.25, 2, 0.25);
	thread visionset_mgr::activate("overlay", name + "_blur", self, 0.25, 2, 0.25);
	self.idgun_vision_on = 1;
	wait(2.5);
	self.idgun_vision_on = 0;
}

/*
	Name: idgun_add_vehicle_death_state
	Namespace: zombie_vortex
	Checksum: 0x822FB480
	Offset: 0x1868
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function idgun_add_vehicle_death_state()
{
	if(IsAirBorne(self))
	{
		self vehicle_ai::add_state("idgun_death", &state_idgun_flying_crush_enter, &state_idgun_flying_crush_update, undefined);
	}
	else
	{
		self vehicle_ai::add_state("idgun_death", &state_idgun_crush_enter, &state_idgun_crush_update, undefined);
	}
}

/*
	Name: state_idgun_crush_enter
	Namespace: zombie_vortex
	Checksum: 0x802A509E
	Offset: 0x1910
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function state_idgun_crush_enter(params)
{
	self vehicle_ai::ClearAllLookingAndTargeting();
	self vehicle_ai::ClearAllMovement();
	self CancelAIMove();
}

/*
	Name: flyEntDelete
	Namespace: zombie_vortex
	Checksum: 0x1FD2B42
	Offset: 0x1970
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function flyEntDelete(entToWatch)
{
	self endon("death");
	entToWatch waittill("death");
	self delete();
}

/*
	Name: state_idgun_crush_update
	Namespace: zombie_vortex
	Checksum: 0x2CA14B93
	Offset: 0x19B8
	Size: 0x287
	Parameters: 1
	Flags: None
*/
function state_idgun_crush_update(params)
{
	self endon("death");
	black_hole_center = params.vPoint;
	attacker = params.attacker;
	weapon = params.weapon;
	if(self.archetype == "raps")
	{
		crush_anim = "ai_zombie_zod_raps_dth_f_id_gun_crush";
	}
	veh_to_black_hole_vec = VectorNormalize(black_hole_center - self.origin);
	fly_ent = spawn("script_origin", self.origin);
	fly_ent thread flyEntDelete(self);
	self LinkTo(fly_ent);
	while(1)
	{
		veh_to_black_hole_dist_sqr = DistanceSquared(self.origin, black_hole_center);
		if(veh_to_black_hole_dist_sqr < 144)
		{
			self.veh_idgun_allow_damage = 1;
			self DoDamage(self.health + 666, self.origin, attacker, undefined, "none", "MOD_UNKNOWN", 0, weapon);
			return;
		}
		else if(!isdefined(self.crush_anim_started) && self.crush_anim_started && veh_to_black_hole_dist_sqr < 1600)
		{
			if(isdefined(crush_anim))
			{
				self AnimScripted("anim_notify", self.origin, self.angles, crush_anim, "normal", undefined, undefined, 0.2);
			}
			self.crush_anim_started = 1;
		}
		fly_ent.origin = fly_ent.origin + veh_to_black_hole_vec * 8;
		wait(0.1);
	}
}

/*
	Name: state_idgun_flying_crush_enter
	Namespace: zombie_vortex
	Checksum: 0x3ACFD7F3
	Offset: 0x1C48
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function state_idgun_flying_crush_enter(params)
{
	self vehicle_ai::ClearAllMovement();
	self CancelAIMove();
	self SetNearGoalNotifyDist(4);
	self.vehAirCraftCollisionEnabled = 0;
}

/*
	Name: state_idgun_flying_crush_update
	Namespace: zombie_vortex
	Checksum: 0x671B631E
	Offset: 0x1CB0
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function state_idgun_flying_crush_update(params)
{
	self endon("death");
	black_hole_center = params.vPoint;
	attacker = params.attacker;
	weapon = params.weapon;
	death_speed = 2;
	if(isdefined(params.idgun_death_speed))
	{
		death_speed = params.idgun_death_speed;
	}
	self SetSpeed(death_speed);
	self ASMRequestSubstate("idgun@movement");
	self thread switch_to_crush_asm(black_hole_center);
	self SetVehGoalPos(black_hole_center, 0, 0);
	self waittill("near_goal");
	self vehicle_ai::get_state_callbacks("death").update_func = &state_idgun_flying_death_update;
	self.veh_idgun_allow_damage = 1;
	self DoDamage(self.health + 666, self.origin, attacker, undefined, "none", "MOD_UNKNOWN", 0, weapon);
}

/*
	Name: switch_to_crush_asm
	Namespace: zombie_vortex
	Checksum: 0xA25E6D37
	Offset: 0x1E58
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function switch_to_crush_asm(black_hole_center)
{
	self endon("death");
	while(1)
	{
		if(DistanceSquared(self.origin, black_hole_center) < 900)
		{
			self ASMRequestSubstate("idgun_crush@movement");
			return;
		}
		wait(0.1);
	}
}

/*
	Name: state_idgun_flying_death_update
	Namespace: zombie_vortex
	Checksum: 0xA20B8A41
	Offset: 0x1EE0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function state_idgun_flying_death_update(params)
{
	self endon("death");
	if(isdefined(self.parasiteEnemy) && isdefined(self.parasiteEnemy.hunted_by))
	{
		self.parasiteEnemy.hunted_by--;
	}
	self playsound("zmb_parasite_explo");
	wait(0.2);
	self delete();
}

