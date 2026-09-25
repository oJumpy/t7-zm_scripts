#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace hive_gun;

/*
	Name: init_shared
	Namespace: hive_gun
	Checksum: 0x433C8A4F
	Offset: 0x600
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.firefly_pod_weapon = GetWeapon("hero_chemicalgelgun");
	level.firefly_pod_secondary_explosion_weapon = GetWeapon("hive_gungun_secondary_explosion");
	level.firefly_debug = GetDvarInt("scr_firefly_debug", 0);
	level.firefly_pod_detection_radius = GetDvarInt("scr_fireflyPodDetectionRadius", 150);
	level.firefly_pod_grace_period = GetDvarFloat("scr_fireflyPodGracePeriod", 0);
	level.firefly_pod_activation_time = GetDvarFloat("scr_fireflyPodActivationTime", 1);
	level.firefly_pod_partial_move_percent = GetDvarFloat("scr_fireflyPartialMovePercent", 0.8);
	if(!isdefined(level.vsmgr_prio_overlay_gel_splat))
	{
		level.vsmgr_prio_overlay_gel_splat = 21;
	}
	level.fireflies_spawn_height = GetDvarInt("betty_jump_height_onground", 55);
	level.fireflies_spawn_height_wall = GetDvarInt("betty_jump_height_wall", 20);
	level.fireflies_spawn_height_wall_angle = GetDvarInt("betty_onground_angle_threshold", 30);
	level.fireflies_spawn_height_wall_angle_cos = cos(level.fireflies_spawn_height_wall_angle);
	level.fireflies_emit_time = GetDvarFloat("scr_firefly_emit_time", 0.2);
	level.fireflies_min_speed = GetDvarInt("scr_firefly_min_speed", 400);
	level.fireflies_attack_speed_scale = GetDvarFloat("scr_firefly_attack_attack_speed_scale", 1.75);
	level.fireflies_collision_check_interval = GetDvarFloat("scr_firefly_collision_check_interval", 0.2);
	callback::add_weapon_damage(level.firefly_pod_weapon, &on_damage_firefly_pod);
	level thread register();
	/#
		level thread update_dvars();
	#/
}

/*
	Name: update_dvars
	Namespace: hive_gun
	Checksum: 0xB3962C5A
	Offset: 0x8B0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function update_dvars()
{
	/#
		while(1)
		{
			wait(1);
			level.fireflies_min_speed = GetDvarInt("Dev Block strings are not supported", 250);
			level.fireflies_attack_speed_scale = GetDvarFloat("Dev Block strings are not supported", 1.15);
			level.firefly_debug = GetDvarInt("Dev Block strings are not supported", 0);
		}
	#/
}

/*
	Name: register
	Namespace: hive_gun
	Checksum: 0x9355C1F7
	Offset: 0x940
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("scriptmover", "firefly_state", 1, 3, "int");
	clientfield::register("toplayer", "fireflies_attacking", 1, 1, "int");
	clientfield::register("toplayer", "fireflies_chasing", 1, 1, "int");
}

/*
	Name: createFireflyPodWatcher
	Namespace: hive_gun
	Checksum: 0x54DAB11B
	Offset: 0x9E0
	Size: 0x1EF
	Parameters: 0
	Flags: None
*/
function createFireflyPodWatcher()
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher("hero_chemicalgelgun", self.team);
	watcher.onSpawn = &on_spawn_firefly_pod;
	watcher.watchForFire = 1;
	watcher.hackable = 0;
	watcher.headicon = 0;
	watcher.activateFx = 1;
	watcher.ownerGetsAssist = 1;
	watcher.ignoreDirection = 1;
	watcher.immediateDetonation = 1;
	watcher.detectionGracePeriod = level.firefly_pod_grace_period;
	watcher.detonateRadius = level.firefly_pod_detection_radius;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 0;
	watcher.onDetonateCallback = &firefly_pod_detonate;
	watcher.activationDelay = level.firefly_pod_activation_time;
	watcher.activateSound = "wpn_gelgun_blob_burst";
	watcher.shouldDamage = &firefly_pod_should_damage;
	watcher.deleteOnPlayerSpawn = 1;
	watcher.timeout = GetDvarFloat("scr_firefly_pod_timeout", 0);
	watcher.ignoreVehicles = 0;
	watcher.ignoreAI = 0;
	watcher.onSupplementalDetonateCallback = &firefly_death;
}

/*
	Name: on_spawn_firefly_pod
	Namespace: hive_gun
	Checksum: 0x1C6E6F67
	Offset: 0xBD8
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function on_spawn_firefly_pod(watcher, owner)
{
	weaponobjects::onSpawnProximityWeaponObject(watcher, owner);
	self PlayLoopSound("wpn_gelgun_blob_alert_lp", 1);
	self endon("death");
	self waittill("stationary");
	self SetModel("wpn_t7_hero_chemgun_residue3_grn");
	self SetEnemyModel("wpn_t7_hero_chemgun_residue3_org");
}

/*
	Name: start_damage_effects
	Namespace: hive_gun
	Checksum: 0xB4001B6
	Offset: 0xC88
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function start_damage_effects()
{
	/#
		if(IsGodMode(self))
		{
			return;
		}
	#/
	self thread end_damage_effects();
}

/*
	Name: end_damage_effects
	Namespace: hive_gun
	Checksum: 0xCFD5EB45
	Offset: 0xCC8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function end_damage_effects()
{
	self endon("disconnect");
	self waittill("death");
}

/*
	Name: on_damage_firefly_pod
	Namespace: hive_gun
	Checksum: 0x9889E0CB
	Offset: 0xCF0
	Size: 0x4D
	Parameters: 5
	Flags: None
*/
function on_damage_firefly_pod(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	if("MOD_GRENADE" != meansOfDeath && "MOD_GRENADE_SPLASH" != meansOfDeath)
	{
		return;
	}
}

/*
	Name: spawn_firefly_mover
	Namespace: hive_gun
	Checksum: 0xE28AAA6
	Offset: 0xD48
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function spawn_firefly_mover()
{
	firefly_mover = spawn("script_model", self.origin);
	firefly_mover.angles = self.angles;
	firefly_mover SetModel("tag_origin");
	firefly_mover.owner = self.owner;
	firefly_mover.killcamoffset = (0, 0, GetDvarFloat("scr_fireflies_start_height", 8));
	firefly_mover.weapon = GetWeapon("hero_firefly_swarm");
	firefly_mover.takedamage = 1;
	firefly_mover.soundMod = "firefly";
	firefly_mover.team = self.team;
	killCamEnt = spawn("script_model", firefly_mover.origin + firefly_mover.killcamoffset);
	killCamEnt.angles = (0, 0, 0);
	killCamEnt SetModel("tag_origin");
	killCamEnt setWeapon(firefly_mover.weapon);
	killCamEnt killcam::store_killcam_entity_on_entity(self);
	firefly_mover.killCamEnt = killCamEnt;
	self.firefly_mover = firefly_mover;
	firefly_mover.debug_time = 1;
	firefly_mover thread firefly_mover_damage();
	weaponobjects::add_supplemental_object(firefly_mover);
}

/*
	Name: firefly_mover_damage
	Namespace: hive_gun
	Checksum: 0x39898357
	Offset: 0xF70
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function firefly_mover_damage()
{
	while(1)
	{
		self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags);
		self thread firefly_death();
	}
}

/*
	Name: kill_firefly_mover
	Namespace: hive_gun
	Checksum: 0x62C835E5
	Offset: 0x1020
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function kill_firefly_mover()
{
	if(isdefined(self.firefly_mover))
	{
		if(isdefined(self.firefly_mover.killCamEnt))
		{
			self.firefly_mover.killCamEnt delete();
		}
		self.firefly_mover delete();
	}
}

/*
	Name: firefly_pod_detonate
	Namespace: hive_gun
	Checksum: 0xC75D01B8
	Offset: 0x1088
	Size: 0x183
	Parameters: 3
	Flags: None
*/
function firefly_pod_detonate(attacker, weapon, target)
{
	if(!isdefined(target) || !isdefined(target.team) || !isdefined(self.team) || self.team == target.team)
	{
		if(isdefined(weapon) && weapon.isValid)
		{
			if(isdefined(attacker))
			{
				if(self.owner util::IsEnemyPlayer(attacker))
				{
					attacker challenges::destroyedExplosive(weapon);
					scoreevents::processScoreEvent("destroyed_fireflyhive", attacker, self.owner, weapon);
				}
			}
		}
		self firefly_pod_destroyed();
		return;
	}
	else
	{
		self spawn_firefly_mover();
		self.firefly_mover thread firefly_watch_for_target_death(target);
		self.firefly_mover thread firefly_watch_for_game_ended(target);
		self thread firefly_pod_release_fireflies(attacker, target);
	}
}

/*
	Name: firefly_pod_destroyed
	Namespace: hive_gun
	Checksum: 0xC14E9337
	Offset: 0x1218
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function firefly_pod_destroyed()
{
	fx_ent = playFX("weapon/fx_hero_chem_gun_blob_death", self.origin);
	fx_ent.team = self.team;
	playsoundatposition("wpn_gelgun_blob_destroy", self.origin);
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	self kill_firefly_mover();
	self delete();
}

/*
	Name: firefly_killcam_move
	Namespace: hive_gun
	Checksum: 0xC54307B
	Offset: 0x12E0
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function firefly_killcam_move(position, time)
{
	if(!isdefined(self.killCamEnt))
	{
		return;
	}
	self endon("death");
	wait(0.5);
	Accel = 0;
	Decel = 0;
	self.killCamEnt moveto(position, time, Accel, Decel);
}

/*
	Name: firefly_killcam_stop
	Namespace: hive_gun
	Checksum: 0xAA80568E
	Offset: 0x1370
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function firefly_killcam_stop()
{
	self notify("stop_killcam");
	if(isdefined(self.killCamEnt))
	{
		self.killCamEnt moveto(self.killCamEnt.origin, 0.1, 0, 0);
	}
}

/*
	Name: firefly_move
	Namespace: hive_gun
	Checksum: 0x5F80C162
	Offset: 0x13D0
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function firefly_move(position, time)
{
	self endon("death");
	Accel = 0;
	Decel = 0;
	self thread firefly_killcam_move(position, time);
	self moveto(position, time, Accel, Decel);
	self waittill("movedone");
}

/*
	Name: firefly_partial_move
	Namespace: hive_gun
	Checksum: 0x8F4ACD32
	Offset: 0x1468
	Size: 0xD5
	Parameters: 4
	Flags: None
*/
function firefly_partial_move(target, position, time, percent)
{
	self endon("death");
	self endon("stop_killcam");
	Accel = 0;
	Decel = 0;
	self thread firefly_killcam_move(position, time);
	self moveto(position, time, Accel, Decel);
	self thread firefly_check_for_collisions(target, position, time);
	wait(time * percent);
	self notify("movedone");
}

/*
	Name: firefly_rotate
	Namespace: hive_gun
	Checksum: 0x6A159A27
	Offset: 0x1548
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function firefly_rotate(angles, time)
{
	self endon("death");
	self RotateTo(angles, time, 0, 0);
	self waittill("rotatedone");
}

/*
	Name: firefly_check_for_collisions
	Namespace: hive_gun
	Checksum: 0xF8989617
	Offset: 0x1598
	Size: 0x147
	Parameters: 3
	Flags: None
*/
function firefly_check_for_collisions(target, move_to, time)
{
	self endon("death");
	self endon("movedone");
	original_position = self.origin;
	dir = VectorNormalize(move_to - self.origin);
	dist = Distance(self.origin, move_to);
	speed = dist / time;
	delta = dir * speed * level.fireflies_collision_check_interval;
	while(1)
	{
		if(!firefly_check_move(self.origin + delta, target))
		{
			self thread firefly_death();
			self playsound("wpn_gelgun_hive_wall_impact");
		}
		wait(level.fireflies_collision_check_interval);
	}
}

/*
	Name: firefly_pod_rotated_point
	Namespace: hive_gun
	Checksum: 0x7681B6CE
	Offset: 0x16E8
	Size: 0x87
	Parameters: 3
	Flags: None
*/
function firefly_pod_rotated_point(degrees, radius, height)
{
	angles = (0, degrees, 0);
	FORWARD = (radius, 0, 0);
	point = RotatePoint(FORWARD, angles);
	return self.spawn_origin + point + (0, 0, height);
}

/*
	Name: firefly_pod_random_point
	Namespace: hive_gun
	Checksum: 0x47639EF1
	Offset: 0x1778
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function firefly_pod_random_point()
{
	return firefly_pod_rotated_point(RandomInt(359), RandomInt(level.fireflies_radius), randomIntRange(level.fireflies_height_variance * -1, level.fireflies_height_variance));
}

/*
	Name: firefly_pod_random_movement
	Namespace: hive_gun
	Checksum: 0x5FAF359A
	Offset: 0x17F0
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function firefly_pod_random_movement()
{
	self endon("death");
	self endon("attacking");
	while(1)
	{
		point = firefly_pod_random_point();
		delta = point - self.origin;
		angles = VectorToAngles(delta);
		firefly_rotate(angles, 0.15);
		dist = length(delta);
		time = 0.01;
		if(dist > 0)
		{
			time = dist / level.fireflies_min_speed;
		}
		firefly_move(point, time);
		wait(RandomFloatRange(0.1, 0.7));
	}
}

/*
	Name: firefly_spyrograph_patrol
	Namespace: hive_gun
	Checksum: 0x1F04058E
	Offset: 0x1928
	Size: 0x1B3
	Parameters: 3
	Flags: None
*/
function firefly_spyrograph_patrol(degrees, increment, radius)
{
	self endon("death");
	self endon("attacking");
	current_degrees = RandomInt(Int(360 / degrees)) * degrees;
	height_offset = 0;
	while(1)
	{
		point = firefly_pod_rotated_point(current_degrees, radius, height_offset);
		delta = point - self.origin;
		angles = (0, current_degrees, 0);
		thread firefly_rotate(angles, 0.15);
		dist = length(delta);
		time = 0.01;
		if(dist > 0)
		{
			time = dist / level.fireflies_min_speed;
		}
		firefly_move(point, time);
		wait(RandomFloatRange(0.1, 0.3));
		current_degrees = current_degrees + degrees * increment % 360;
	}
}

/*
	Name: firefly_damage_target
	Namespace: hive_gun
	Checksum: 0x1A8E06C9
	Offset: 0x1AE8
	Size: 0x2C7
	Parameters: 1
	Flags: None
*/
function firefly_damage_target(target)
{
	level endon("game_ended");
	self endon("death");
	target endon("disconnect");
	target endon("death");
	target endon("entering_last_stand");
	damage = 25;
	damage_delay = 0.1;
	weapon = self.weapon;
	target playsound("wpn_gelgun_hive_attack");
	target notify("snd_burn_scream");
	remaining_hits = 10;
	if(!isPlayer(target))
	{
		remaining_hits = 4;
	}
	while(remaining_hits > 0)
	{
		wait(damage_delay);
		target DoDamage(damage, self.origin, self.owner, self, "", "MOD_IMPACT", 0, weapon);
		remaining_hits = remaining_hits - 1;
		if(isalive(target) && isPlayer(target))
		{
			bodyType = target GetCharacterBodyType();
			if(bodyType >= 0)
			{
				bodyTypeFields = GetCharacterFields(bodyType, CurrentSessionMode());
				if(isdefined(bodyTypeFields.digitalBlood))
				{
				}
				else if(0)
				{
					PlayFXOnTag("weapon/fx_hero_firefly_sparks_os", target, "J_SpineLower");
				}
				else
				{
					PlayFXOnTag("weapon/fx_hero_firefly_blood_os", target, "J_SpineLower");
				}
			}
			else
			{
				PlayFXOnTag("weapon/fx_hero_firefly_blood_os", target, "J_SpineLower");
			}
		}
		else if(!isPlayer(target))
		{
			PlayFXOnTag("weapon/fx_hero_firefly_sparks_os", target, "tag_origin");
		}
	}
}

/*
	Name: firefly_watch_for_target_death
	Namespace: hive_gun
	Checksum: 0xFAAEA03F
	Offset: 0x1DB8
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function firefly_watch_for_target_death(target)
{
	self endon("death");
	if(isalive(target))
	{
		target util::waittill_any("death", "flashback", "game_ended");
	}
	if(isPlayer(target))
	{
		target clientfield::set_to_player("fireflies_attacking", 0);
		target clientfield::set_to_player("fireflies_chasing", 0);
	}
	self thread firefly_death();
}

/*
	Name: firefly_watch_for_game_ended
	Namespace: hive_gun
	Checksum: 0x80CC0FE0
	Offset: 0x1E90
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function firefly_watch_for_game_ended(target)
{
	self endon("death");
	level waittill("game_ended");
	if(isalive(target) && isPlayer(target))
	{
		target clientfield::set_to_player("fireflies_attacking", 0);
		target clientfield::set_to_player("fireflies_chasing", 0);
	}
	self thread firefly_death();
}

/*
	Name: firefly_death
	Namespace: hive_gun
	Checksum: 0x2E2A705B
	Offset: 0x1F48
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function firefly_death()
{
	/#
		println("Dev Block strings are not supported" + self GetEntNum());
	#/
	self clientfield::set("firefly_state", 5);
	self playsound("wpn_gelgun_hive_die");
	if(isdefined(self.target_entity) && isPlayer(self.target_entity))
	{
		self.target_entity clientfield::set_to_player("fireflies_attacking", 0);
		self.target_entity clientfield::set_to_player("fireflies_chasing", 0);
	}
	waittillframeend;
	thread cleanup_killcam_entity(self.killCamEnt);
	if(isdefined(self))
	{
		/#
			println("Dev Block strings are not supported" + self GetEntNum());
		#/
		self delete();
	}
}

/*
	Name: cleanup_killcam_entity
	Namespace: hive_gun
	Checksum: 0x83010D30
	Offset: 0x20A0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function cleanup_killcam_entity(killCamEnt)
{
	wait(5);
	if(isdefined(killCamEnt))
	{
		killCamEnt delete();
	}
}

/*
	Name: get_attack_speed
	Namespace: hive_gun
	Checksum: 0xAB9381FB
	Offset: 0x20E0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function get_attack_speed(target)
{
	velocity = target GetVelocity();
	speed = length(velocity) * level.fireflies_attack_speed_scale;
	if(speed < level.fireflies_min_speed)
	{
		speed = level.fireflies_min_speed;
	}
	return speed;
}

/*
	Name: firefly_attack
	Namespace: hive_gun
	Checksum: 0xBCBCD5A4
	Offset: 0x2168
	Size: 0x203
	Parameters: 2
	Flags: None
*/
function firefly_attack(target, State)
{
	level endon("game_ended");
	self endon("death");
	target endon("entering_last_stand");
	self thread firefly_killcam_stop();
	self clientfield::set("firefly_state", State);
	if(isPlayer(target))
	{
		target clientfield::set_to_player("fireflies_attacking", 1);
	}
	target_origin = target.origin + VectorScale((0, 0, 1), 50);
	delta = self.origin - target_origin;
	dist = length(delta);
	time = 0.01;
	if(dist > 0)
	{
		speed = get_attack_speed(target);
		time = dist / speed;
	}
	self.enemy = target;
	firefly_move(target_origin, time);
	if(!isdefined(target) || !isalive(target))
	{
		return;
	}
	self LinkTo(target);
	wait(time);
	if(!isalive(target))
	{
		return;
	}
	self thread firefly_damage_target(target);
}

/*
	Name: get_crumb_position
	Namespace: hive_gun
	Checksum: 0xB466FF50
	Offset: 0x2378
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function get_crumb_position(target)
{
	height = 50;
	if(isPlayer(target))
	{
		stance = target GetStance();
		if(stance == "crouch")
		{
			height = 30;
		}
		else if(stance == "prone")
		{
			height = 15;
		}
	}
	return target.origin + (0, 0, height);
}

/*
	Name: target_bread_crumbs_render
	Namespace: hive_gun
	Checksum: 0x5B9BFCD5
	Offset: 0x2430
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function target_bread_crumbs_render(target)
{
	/#
		self endon("death");
		self endon("attack");
		while(1)
		{
			previous_crumb = self.origin;
			for(i = 0; i < self.target_breadcrumbs.size; i++)
			{
				if(self.target_breadcrumb_current_index + i > self.target_breadcrumb_last_added)
				{
					break;
				}
				crumb_index = self.target_breadcrumb_current_index + i % self.target_breadcrumbs.size;
				crumb = self.target_breadcrumbs[crumb_index];
				sphere(crumb, 2, (0, 1, 0), 1, 1, 10, self.debug_time);
				if(i > 0)
				{
					line(previous_crumb, crumb, (0, 1, 0), 1, 1, self.debug_time);
				}
				previous_crumb = crumb;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: target_bread_crumbs
	Namespace: hive_gun
	Checksum: 0xAB284D2E
	Offset: 0x2590
	Size: 0x19D
	Parameters: 1
	Flags: None
*/
function target_bread_crumbs(target)
{
	self endon("death");
	target endon("death");
	self.target_breadcrumbs = [];
	self.target_breadcrumb_current_index = 0;
	self.target_breadcrumb_last_added = 0;
	minimum_delta_sqr = 400;
	self.max_crumbs = 20;
	self.target_breadcrumbs[self.target_breadcrumb_last_added] = get_crumb_position(target);
	/#
		if(level.firefly_debug)
		{
			self thread target_bread_crumbs_render(target);
		}
	#/
	while(1)
	{
		wait(0.25);
		previous_crumb_index = self.target_breadcrumb_last_added % self.max_crumbs;
		potential_crumb_position = get_crumb_position(target);
		if(DistanceSquared(potential_crumb_position, self.target_breadcrumbs[previous_crumb_index]) > minimum_delta_sqr)
		{
			self.target_breadcrumb_last_added++;
			if(self.target_breadcrumb_last_added >= self.target_breadcrumb_current_index + self.max_crumbs)
			{
				self.target_breadcrumb_current_index = self.target_breadcrumb_last_added - self.max_crumbs + 1;
			}
			self.target_breadcrumbs[self.target_breadcrumb_last_added % self.max_crumbs] = potential_crumb_position;
		}
	}
}

/*
	Name: get_target_bread_crumb
	Namespace: hive_gun
	Checksum: 0xA5DDB3C
	Offset: 0x2738
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function get_target_bread_crumb(target)
{
	if(self.target_breadcrumb_current_index > self.target_breadcrumb_last_added)
	{
		return get_crumb_position(target);
	}
	current_index = self.target_breadcrumb_current_index % self.max_crumbs;
	if(!isdefined(self.target_breadcrumbs[current_index]))
	{
		return get_crumb_position(target);
	}
	return self.target_breadcrumbs[current_index];
}

/*
	Name: firefly_check_move
	Namespace: hive_gun
	Checksum: 0x3497311D
	Offset: 0x27C8
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function firefly_check_move(position, target)
{
	passed = BulletTracePassed(self.origin, position, 0, self, target);
	return passed;
}

/*
	Name: firefly_chase
	Namespace: hive_gun
	Checksum: 0x146B36A
	Offset: 0x2820
	Size: 0x2EF
	Parameters: 1
	Flags: None
*/
function firefly_chase(target)
{
	level endon("game_ended");
	self endon("death");
	target endon("death");
	target endon("entering_last_stand");
	self clientfield::set("firefly_state", 2);
	if(isPlayer(target))
	{
		target clientfield::set_to_player("fireflies_chasing", 1);
	}
	max_distance = 500;
	attack_distance = 50;
	max_offset = 10;
	up = (0, 0, 1);
	while(1)
	{
		target_origin = target.origin + VectorScale((0, 0, 1), 50);
		delta = target_origin - self.origin;
		dist = length(delta);
		if(dist <= attack_distance && firefly_check_move(target_origin, target))
		{
			thread firefly_attack(target, 3);
			return;
		}
		else
		{
			target_origin = get_target_bread_crumb(target);
			/#
				if(level.firefly_debug)
				{
					sphere(self.origin, 2, (1, 0, 0), 1, 1, 10, self.debug_time);
				}
			#/
		}
		delta = target_origin - self.origin;
		angles = VectorToAngles(delta);
		thread firefly_rotate(angles, 0.15);
		dist = length(delta);
		time = 0.01;
		if(dist > 0)
		{
			speed = get_attack_speed(target);
			time = dist / speed;
		}
		firefly_partial_move(target, target_origin, time, level.firefly_pod_partial_move_percent);
		self.target_breadcrumb_current_index++;
	}
}

/*
	Name: firefly_pod_start
	Namespace: hive_gun
	Checksum: 0xCCE2D3C4
	Offset: 0x2B18
	Size: 0x20B
	Parameters: 3
	Flags: None
*/
function firefly_pod_start(start_pos, target, linked)
{
	level endon("game_ended");
	self endon("death");
	self notify("attack");
	/#
		if(level.firefly_debug)
		{
			sphere(self.origin, 4, (1, 0, 0), 1, 1, 10, self.debug_time);
		}
	#/
	level.fireflies_height_variance = 30;
	level.fireflies_radius = 100;
	self.target_origin_at_start = target.origin;
	self.target_entity = target;
	if(linked)
	{
		thread firefly_attack(target, 4);
		return;
	}
	else
	{
		thread target_bread_crumbs(target);
		self moveto(start_pos, level.fireflies_emit_time, 0, level.fireflies_emit_time);
		self waittill("movedone");
		if(isdefined(target) && isdefined(target.origin))
		{
			delta = target.origin - self.origin;
			angles = VectorToAngles(delta);
			self.angles = angles;
			self thread firefly_chase(target);
		}
	}
	wait(30);
	if(isdefined(self.killCamEnt))
	{
		self.killCamEnt delete();
	}
	self delete();
}

/*
	Name: firefly_pod_release_fireflies
	Namespace: hive_gun
	Checksum: 0x5349593B
	Offset: 0x2D30
	Size: 0x203
	Parameters: 2
	Flags: None
*/
function firefly_pod_release_fireflies(attacker, target)
{
	jumpDir = VectorNormalize(anglesToUp(self.angles));
	if(jumpDir[2] > level.fireflies_spawn_height_wall_angle_cos)
	{
		jumpHeight = level.fireflies_spawn_height;
	}
	else
	{
		jumpHeight = level.fireflies_spawn_height_wall;
	}
	explodePos = self.origin + jumpDir * jumpHeight;
	self.firefly_mover.spawn_origin = explodePos;
	linked_to = self GetLinkedEnt();
	linked = linked_to === target;
	if(!linked)
	{
		fx_ent = playFX("weapon/fx_hero_firefly_start", self.origin, anglesToUp(self.angles));
		fx_ent.team = self.team;
		self.firefly_mover clientfield::set("firefly_state", 1);
		self.firefly_mover.killCamEnt moveto(explodePos + self.firefly_mover.killcamoffset, level.fireflies_emit_time, 0, level.fireflies_emit_time);
	}
	self.firefly_mover thread firefly_pod_start(explodePos, target, linked);
	self delete();
}

/*
	Name: firefly_pod_should_damage
	Namespace: hive_gun
	Checksum: 0x1271CF06
	Offset: 0x2F40
	Size: 0x7F
	Parameters: 4
	Flags: None
*/
function firefly_pod_should_damage(watcher, attacker, weapon, damage)
{
	if(weapon == watcher.weapon)
	{
		return 0;
	}
	if(weapon.isEmp || weapon.destroysEquipment)
	{
		return 1;
	}
	if(self.damageTaken < 15)
	{
		return 0;
	}
	return 1;
}

