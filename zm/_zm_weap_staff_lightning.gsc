#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weap_staff_common;
#using scripts\zm\zm_tomb_utility;

#namespace namespace_dc4ed61a;

/*
	Name: __init__sytem__
	Namespace: namespace_dc4ed61a
	Checksum: 0xDA4F7BFD
	Offset: 0x488
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_lightning", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_dc4ed61a
	Checksum: 0xA5CCBB62
	Offset: 0x4C8
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["lightning_miss"] = "dlc5/zmb_weapon/fx_staff_elec_impact_ug_miss";
	level._effect["lightning_arc"] = "dlc5/zmb_weapon/fx_staff_elec_trail_bolt_cheap";
	level._effect["lightning_impact"] = "dlc5/zmb_weapon/fx_staff_elec_impact_ug_hit_torso";
	level._effect["tesla_shock_eyes"] = "dlc5/zmb_weapon/fx_staff_elec_impact_ug_hit_eyes";
	clientfield::register("actor", "lightning_impact_fx", 21000, 1, "int");
	clientfield::register("scriptmover", "lightning_miss_fx", 21000, 1, "int");
	clientfield::register("actor", "lightning_arc_fx", 21000, 1, "int");
	zombie_utility::set_zombie_var("tesla_head_gib_chance", 50);
	callback::on_spawned(&onPlayerSpawned);
	zm_spawner::register_zombie_damage_callback(&staff_lightning_zombie_damage_response);
	zm_spawner::register_zombie_death_event_callback(&staff_lightning_death_event);
}

/*
	Name: onPlayerSpawned
	Namespace: namespace_dc4ed61a
	Checksum: 0x7E4F50E1
	Offset: 0x658
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	self endon("disconnect");
	self thread watch_staff_lightning_fired();
	self thread zm_tomb_utility::watch_staff_usage();
}

/*
	Name: watch_staff_lightning_fired
	Namespace: namespace_dc4ed61a
	Checksum: 0x33D3FF64
	Offset: 0x6A0
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function watch_staff_lightning_fired()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("missile_fire", e_projectile, str_weapon);
		if(str_weapon.name == "staff_lightning_upgraded2" || str_weapon.name == "staff_lightning_upgraded3")
		{
			fire_angles = VectorToAngles(self GetWeaponForwardDir());
			fire_origin = self GetWeaponMuzzlePoint();
			self thread staff_lightning_position_source(fire_origin, fire_angles, str_weapon);
		}
	}
}

/*
	Name: lightning_ball_wait
	Namespace: namespace_dc4ed61a
	Checksum: 0xA538717C
	Offset: 0x798
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function lightning_ball_wait(n_lifetime_after_move)
{
	level endon("lightning_ball_created");
	self waittill("movedone");
	wait(n_lifetime_after_move);
	return 1;
}

/*
	Name: staff_lightning_position_source
	Namespace: namespace_dc4ed61a
	Checksum: 0xC03E7164
	Offset: 0x7D0
	Size: 0x36B
	Parameters: 3
	Flags: None
*/
function staff_lightning_position_source(v_detonate, v_angles, str_weapon)
{
	self endon("disconnect");
	level notify("lightning_ball_created");
	if(!isdefined(v_angles))
	{
		v_angles = (0, 0, 0);
	}
	e_ball_fx = spawn("script_model", v_detonate + AnglesToForward(v_angles) * 100);
	e_ball_fx.angles = v_angles;
	e_ball_fx.str_weapon = str_weapon;
	e_ball_fx SetModel("tag_origin");
	e_ball_fx.n_range = get_lightning_blast_range(self.chargeShotLevel);
	e_ball_fx.n_damage_per_sec = get_lightning_ball_damage_per_sec(self.chargeShotLevel);
	e_ball_fx clientfield::set("lightning_miss_fx", 1);
	n_shot_range = staff_lightning_get_shot_range(self.chargeShotLevel);
	v_end = v_detonate + AnglesToForward(v_angles) * n_shot_range;
	trace = bullettrace(v_detonate, v_end, 0, self);
	if(trace["fraction"] != 1)
	{
		v_end = trace["position"];
	}
	staff_lightning_ball_speed = n_shot_range / 8;
	n_dist = Distance(e_ball_fx.origin, v_end);
	n_max_movetime_s = n_shot_range / staff_lightning_ball_speed;
	n_movetime_s = n_dist / staff_lightning_ball_speed;
	n_leftover_time = n_max_movetime_s - n_movetime_s;
	e_ball_fx thread staff_lightning_ball_kill_zombies(self);
	/#
		e_ball_fx thread zm_tomb_utility::puzzle_debug_position("Dev Block strings are not supported", (175, 0, 255));
	#/
	e_ball_fx moveto(v_end, n_movetime_s);
	finished_playing = e_ball_fx lightning_ball_wait(n_leftover_time);
	e_ball_fx notify("stop_killing");
	e_ball_fx notify("stop_debug_position");
	if(isdefined(finished_playing) && finished_playing)
	{
		wait(3);
	}
	if(isdefined(e_ball_fx))
	{
		e_ball_fx delete();
	}
}

/*
	Name: staff_lightning_ball_kill_zombies
	Namespace: namespace_dc4ed61a
	Checksum: 0xF2CCAB03
	Offset: 0xB48
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function staff_lightning_ball_kill_zombies(e_attacker)
{
	self endon("death");
	self endon("stop_killing");
	while(1)
	{
		a_zombies = staff_lightning_get_valid_targets(e_attacker, self.origin);
		if(isdefined(a_zombies))
		{
			foreach(zombie in a_zombies)
			{
				if(staff_lightning_is_target_valid(zombie))
				{
					e_attacker thread staff_lightning_arc_fx(self, zombie);
					wait(0.2);
				}
			}
		}
		wait(0.5);
	}
}

/*
	Name: staff_lightning_get_valid_targets
	Namespace: namespace_dc4ed61a
	Checksum: 0xE27D4559
	Offset: 0xC68
	Size: 0x121
	Parameters: 2
	Flags: None
*/
function staff_lightning_get_valid_targets(player, v_source)
{
	player endon("disconnect");
	a_enemies = [];
	a_zombies = GetAIArray();
	a_zombies = util::get_array_of_closest(v_source, a_zombies, undefined, undefined, self.n_range);
	if(isdefined(a_zombies))
	{
		foreach(ai_zombie in a_zombies)
		{
			if(staff_lightning_is_target_valid(ai_zombie))
			{
				a_enemies[a_enemies.size] = ai_zombie;
			}
		}
	}
	return a_enemies;
}

/*
	Name: staff_lightning_get_shot_range
	Namespace: namespace_dc4ed61a
	Checksum: 0x6305D988
	Offset: 0xD98
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function staff_lightning_get_shot_range(n_charge)
{
	switch(n_charge)
	{
		case 3:
		{
			return 1200;
		}
		case default:
		{
			return 800;
		}
	}
}

/*
	Name: get_lightning_blast_range
	Namespace: namespace_dc4ed61a
	Checksum: 0xA261E509
	Offset: 0xDE0
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function get_lightning_blast_range(n_charge)
{
	switch(n_charge)
	{
		case 1:
		{
			n_range = 200;
			break;
		}
		case 2:
		{
			n_range = 150;
			break;
		}
		case 3:
		case default:
		{
			n_range = 250;
			break;
		}
	}
	return n_range;
}

/*
	Name: get_lightning_ball_damage_per_sec
	Namespace: namespace_dc4ed61a
	Checksum: 0xA9C32486
	Offset: 0xE60
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function get_lightning_ball_damage_per_sec(n_charge)
{
	if(!isdefined(n_charge))
	{
		return 2500;
	}
	switch(n_charge)
	{
		case 3:
		{
			return 3500;
		}
		case default:
		{
			return 2500;
		}
	}
}

/*
	Name: staff_lightning_is_target_valid
	Namespace: namespace_dc4ed61a
	Checksum: 0xB7E8382D
	Offset: 0xEB8
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function staff_lightning_is_target_valid(ai_zombie)
{
	if(!isdefined(ai_zombie))
	{
		return 0;
	}
	if(isdefined(ai_zombie.is_being_zapped) && ai_zombie.is_being_zapped)
	{
		return 0;
	}
	if(isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz)
	{
		return 0;
	}
	return 1;
}

/*
	Name: staff_lightning_ball_damage_over_time
	Namespace: namespace_dc4ed61a
	Checksum: 0x5FFD488C
	Offset: 0xF30
	Size: 0x2EB
	Parameters: 3
	Flags: None
*/
function staff_lightning_ball_damage_over_time(e_source, e_target, e_attacker)
{
	e_attacker endon("disconnect");
	e_target clientfield::set("lightning_impact_fx", 1);
	n_range_sq = e_source.n_range * e_source.n_range;
	e_target.is_being_zapped = 1;
	e_target clientfield::set("lightning_arc_fx", 1);
	wait(0.5);
	if(isdefined(e_source))
	{
		if(!isdefined(e_source.n_damage_per_sec))
		{
			e_source.n_damage_per_sec = get_lightning_ball_damage_per_sec(e_attacker.chargeShotLevel);
		}
		n_damage_per_pulse = e_source.n_damage_per_sec * 1;
	}
	while(isdefined(e_source) && isalive(e_target))
	{
		e_target thread stun_zombie();
		wait(1);
		if(!isdefined(e_source) || !isalive(e_target))
		{
			break;
		}
		n_dist_sq = DistanceSquared(e_source.origin, e_target.origin);
		if(n_dist_sq > n_range_sq)
		{
			break;
		}
		if(isalive(e_target) && isdefined(e_source))
		{
			instakill_on = e_attacker zm_powerups::is_insta_kill_active();
			if(n_damage_per_pulse < e_target.health && !instakill_on)
			{
				e_target zm_tomb_utility::do_damage_network_safe(e_attacker, n_damage_per_pulse, e_source.str_weapon, "MOD_RIFLE_BULLET");
			}
			else
			{
				e_target thread zombie_shock_eyes();
				e_target thread staff_lightning_kill_zombie(e_attacker, e_source.str_weapon);
				break;
			}
		}
	}
	if(isdefined(e_target))
	{
		e_target.is_being_zapped = 0;
		e_target clientfield::set("lightning_arc_fx", 0);
	}
}

/*
	Name: staff_lightning_arc_fx
	Namespace: namespace_dc4ed61a
	Checksum: 0x9DC306FD
	Offset: 0x1228
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function staff_lightning_arc_fx(e_source, ai_zombie)
{
	self endon("disconnect");
	if(!isdefined(ai_zombie))
	{
		return;
	}
	if(!zm_tomb_utility::bullet_trace_throttled(e_source.origin, ai_zombie.origin + VectorScale((0, 0, 1), 20), ai_zombie))
	{
		return;
	}
	if(isdefined(e_source) && isdefined(ai_zombie) && isalive(ai_zombie))
	{
		level thread staff_lightning_ball_damage_over_time(e_source, ai_zombie, self);
	}
}

/*
	Name: staff_lightning_kill_zombie
	Namespace: namespace_dc4ed61a
	Checksum: 0xFA1AF81
	Offset: 0x12F0
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function staff_lightning_kill_zombie(player, str_weapon)
{
	player endon("disconnect");
	if(!isalive(self))
	{
		return;
	}
	self.var_26747e92 = 1;
	self zm_tomb_utility::do_damage_network_safe(player, self.health, str_weapon, "MOD_RIFLE_BULLET");
	player zm_score::player_add_points("death", "", "");
}

/*
	Name: staff_lightning_death_fx
	Namespace: namespace_dc4ed61a
	Checksum: 0x2F32950B
	Offset: 0x13A0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function staff_lightning_death_fx()
{
	if(isdefined(self))
	{
		self clientfield::set("lightning_impact_fx", 1);
		self thread zombie_shock_eyes();
	}
}

/*
	Name: zombie_shock_eyes_network_safe
	Namespace: namespace_dc4ed61a
	Checksum: 0xCD74B845
	Offset: 0x13F0
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function zombie_shock_eyes_network_safe(FX, entity, tag)
{
	if(zm_net::network_entity_valid(entity))
	{
		if(!(isdefined(self.head_gibbed) && self.head_gibbed))
		{
			PlayFXOnTag(FX, entity, tag);
		}
	}
}

/*
	Name: zombie_shock_eyes
	Namespace: namespace_dc4ed61a
	Checksum: 0x543301E9
	Offset: 0x1468
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function zombie_shock_eyes()
{
	if(isdefined(self.head_gibbed) && self.head_gibbed)
	{
		return;
	}
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	zm_net::network_safe_init("shock_eyes", 2);
	zm_net::network_choke_action("shock_eyes", &zombie_shock_eyes_network_safe, level._effect["tesla_shock_eyes"], self, "j_eyeball_le");
}

/*
	Name: staff_lightning_zombie_damage_response
	Namespace: namespace_dc4ed61a
	Checksum: 0x881DE97F
	Offset: 0x1508
	Size: 0xBD
	Parameters: 13
	Flags: None
*/
function staff_lightning_zombie_damage_response(mod, HIT_LOCATION, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(self is_staff_lightning_damage(self.damageWeapon) && self.damageMod != "MOD_RIFLE_BULLET")
	{
		self thread stun_zombie();
	}
	return 0;
}

/*
	Name: is_staff_lightning_damage
	Namespace: namespace_dc4ed61a
	Checksum: 0xB1C4BF80
	Offset: 0x15D0
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function is_staff_lightning_damage(weapon)
{
	return isdefined(weapon) && (weapon.name == "staff_lightning" || weapon.name == "staff_lightning_upgraded") && (!isdefined(self.set_beacon_damage) && self.set_beacon_damage);
}

/*
	Name: staff_lightning_death_event
	Namespace: namespace_dc4ed61a
	Checksum: 0x8ED2B4C4
	Offset: 0x1638
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function staff_lightning_death_event(attacker)
{
	if(is_staff_lightning_damage(self.damageWeapon) && self.damageMod != "MOD_MELEE")
	{
		if(isdefined(self.is_mechz) && self.is_mechz)
		{
			return;
		}
		self thread zombie_utility::zombie_eye_glow_stop();
		self.var_26747e92 = 1;
		tag = "J_SpineUpper";
		self clientfield::set("lightning_impact_fx", 1);
		self thread zombie_shock_eyes();
		if(isdefined(self.deathAnim))
		{
			self waittillmatch("death_anim");
		}
		self zm_tomb_utility::do_damage_network_safe(self.attacker, self.health, self.damageWeapon, "MOD_RIFLE_BULLET");
	}
}

/*
	Name: stun_zombie
	Namespace: namespace_dc4ed61a
	Checksum: 0xF77813CD
	Offset: 0x1760
	Size: 0x117
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
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
	{
		return;
	}
	self.forceMovementScriptState = 1;
	self.ignoreall = 1;
	self.is_electrocuted = 1;
	tag = "J_SpineUpper";
	self clientfield::set("lightning_impact_fx", 1);
	if(!(isdefined(self.missingLegs) && self.missingLegs))
	{
		self.var_b52ab77a = 1;
	}
	self zombie_shared::DoNoteTracks("stunned");
	self.forceMovementScriptState = 0;
	self.ignoreall = 0;
	self.is_electrocuted = 0;
}

