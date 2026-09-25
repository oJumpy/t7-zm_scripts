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

#namespace namespace_42f5ba79;

/*
	Name: __init__sytem__
	Namespace: namespace_42f5ba79
	Checksum: 0xA6809FFF
	Offset: 0x4E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_water", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_42f5ba79
	Checksum: 0x25C708A2
	Offset: 0x520
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["staff_water_blizzard"] = "weapon/zmb_staff/fx_zmb_staff_ice_ug_impact_hit";
	level._effect["staff_water_ice_shard"] = "weapon/zmb_staff/fx_zmb_staff_ice_trail_bolt";
	level._effect["staff_water_shatter"] = "weapon/zmb_staff/fx_zmb_staff_ice_exp";
	clientfield::register("scriptmover", "staff_blizzard_fx", 21000, 1, "int");
	clientfield::register("actor", "anim_rate", 21000, 2, "float");
	clientfield::register("actor", "attach_bullet_model", 21000, 1, "int");
	clientfield::register("actor", "staff_shatter_fx", 21000, 1, "int");
	callback::on_spawned(&onPlayerSpawned);
	level flag::init("blizzard_active");
	init_tag_array();
	level thread water_dart_cleanup();
	zm_spawner::register_zombie_death_event_callback(&staff_water_death_event);
	zm_spawner::add_custom_zombie_spawn_logic(&staff_water_on_zombie_spawned);
}

/*
	Name: init_tag_array
	Namespace: namespace_42f5ba79
	Checksum: 0xA3C2D227
	Offset: 0x6E8
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function init_tag_array()
{
	level.zombie_water_icicle_tag = [];
	level.zombie_water_icicle_tag[0] = "j_hip_le";
	level.zombie_water_icicle_tag[1] = "j_hip_ri";
	level.zombie_water_icicle_tag[2] = "j_spine4";
	level.zombie_water_icicle_tag[3] = "j_elbow_le";
	level.zombie_water_icicle_tag[4] = "j_elbow_ri";
	level.zombie_water_icicle_tag[5] = "j_clavicle_le";
	level.zombie_water_icicle_tag[6] = "j_clavicle_ri";
}

/*
	Name: water_dart_cleanup
	Namespace: namespace_42f5ba79
	Checksum: 0x2DAED048
	Offset: 0x7A8
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function water_dart_cleanup()
{
	while(1)
	{
		a_grenades = GetEntArray("grenade", "classname");
		foreach(e_grenade in a_grenades)
		{
			if(isdefined(e_grenade.model) && e_grenade.model == "p6_zm_tm_staff_projectile_ice")
			{
				time = GetTime();
				if(time - e_grenade.birthtime >= 1000)
				{
					e_grenade delete();
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: onPlayerSpawned
	Namespace: namespace_42f5ba79
	Checksum: 0xFF122F09
	Offset: 0x8D8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function onPlayerSpawned()
{
	self endon("disconnect");
	self thread watch_staff_water_fired();
	self thread watch_staff_water_impact();
	self thread zm_tomb_utility::watch_staff_usage();
}

/*
	Name: watch_staff_water_fired
	Namespace: namespace_42f5ba79
	Checksum: 0xEDDC2381
	Offset: 0x938
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function watch_staff_water_fired()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("missile_fire", e_projectile, str_weapon);
		if(str_weapon.name == "staff_water" || str_weapon.name == "staff_water_upgraded")
		{
			util::wait_network_frame();
			_icicle_locate_target(str_weapon);
			util::wait_network_frame();
			_icicle_locate_target(str_weapon);
			util::wait_network_frame();
			_icicle_locate_target(str_weapon);
		}
	}
}

/*
	Name: watch_staff_water_impact
	Namespace: namespace_42f5ba79
	Checksum: 0x95D559A5
	Offset: 0xA30
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function watch_staff_water_impact()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("projectile_impact", str_weapon, v_explode_point, n_radius, str_name, n_impact);
		if(str_weapon.name == "staff_water_upgraded2" || str_weapon.name == "staff_water_upgraded3")
		{
			n_lifetime = 6;
			if(str_weapon.name == "staff_water_upgraded3")
			{
				n_lifetime = 9;
			}
			self thread staff_water_position_source(v_explode_point, n_lifetime, str_weapon);
		}
	}
}

/*
	Name: staff_water_kill_zombie
	Namespace: namespace_42f5ba79
	Checksum: 0x4CDA01EA
	Offset: 0xB30
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function staff_water_kill_zombie(player, str_weapon)
{
	self freeze_zombie();
	self zm_tomb_utility::do_damage_network_safe(player, self.health, str_weapon, "MOD_RIFLE_BULLET");
	if(isdefined(self.deathAnim))
	{
		self waittillmatch("death_anim");
	}
	if(isdefined(self))
	{
		self thread frozen_zombie_shatter();
	}
	player zm_score::player_add_points("death", "", "");
}

/*
	Name: freeze_zombie
	Namespace: namespace_42f5ba79
	Checksum: 0xE4BE0919
	Offset: 0xC08
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function freeze_zombie()
{
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	self.var_93022f09 = 1;
}

/*
	Name: _network_safe_play_fx
	Namespace: namespace_42f5ba79
	Checksum: 0xF3657466
	Offset: 0xC38
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function _network_safe_play_fx(FX, v_origin)
{
	playFX(FX, v_origin, (0, 0, 1), (1, 0, 0));
}

/*
	Name: network_safe_play_fx
	Namespace: namespace_42f5ba79
	Checksum: 0x2A996FD4
	Offset: 0xC78
	Size: 0x63
	Parameters: 4
	Flags: None
*/
function network_safe_play_fx(id, max, FX, v_origin)
{
	zm_net::network_safe_init(id, max);
	zm_net::network_choke_action(id, &_network_safe_play_fx, FX, v_origin);
}

/*
	Name: frozen_zombie_shatter
	Namespace: namespace_42f5ba79
	Checksum: 0xCF59B722
	Offset: 0xCE8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function frozen_zombie_shatter()
{
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	if(isdefined(self))
	{
		if(1)
		{
			v_fx = self GetTagOrigin("J_SpineLower");
			level thread network_safe_play_fx("frozen_shatter", 2, level._effect["staff_water_shatter"], v_fx);
			self thread frozen_zombie_gib("normal");
		}
		else
		{
			self StartRagdoll();
		}
	}
}

/*
	Name: frozen_zombie_gib
	Namespace: namespace_42f5ba79
	Checksum: 0xC5E8FF03
	Offset: 0xDB8
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function frozen_zombie_gib(gib_type)
{
	gibArray = [];
	gibArray[gibArray.size] = level._ZOMBIE_GIB_PIECE_INDEX_ALL;
	self gib(gib_type, gibArray);
	self ghost();
	wait(0.4);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: staff_water_position_source
	Namespace: namespace_42f5ba79
	Checksum: 0xFE5293D9
	Offset: 0xE50
	Size: 0x1EB
	Parameters: 3
	Flags: None
*/
function staff_water_position_source(v_detonate, n_lifetime_sec, str_weapon)
{
	self endon("disconnect");
	if(isdefined(v_detonate))
	{
		level notify("blizzard_shot");
		e_fx = spawn("script_model", v_detonate + VectorScale((0, 0, 1), 33));
		e_fx SetModel("tag_origin");
		e_fx clientfield::set("staff_blizzard_fx", 1);
		e_fx thread zm_tomb_utility::puzzle_debug_position("X", (0, 64, 255));
		wait(1);
		level flag::set("blizzard_active");
		e_fx thread ice_staff_blizzard_do_kills(self, str_weapon);
		e_fx thread zm_tomb_utility::whirlwind_rumble_nearby_players("blizzard_active");
		e_fx thread ice_staff_blizzard_timeout(n_lifetime_sec);
		e_fx thread ice_staff_blizzard_off();
		e_fx waittill("blizzard_off");
		level flag::clear("blizzard_active");
		e_fx notify("stop_debug_position");
		wait(0.1);
		e_fx clientfield::set("staff_blizzard_fx", 0);
		wait(0.1);
		e_fx delete();
	}
}

/*
	Name: ice_staff_blizzard_do_kills
	Namespace: namespace_42f5ba79
	Checksum: 0xC1437CE4
	Offset: 0x1048
	Size: 0x1A7
	Parameters: 2
	Flags: None
*/
function ice_staff_blizzard_do_kills(player, str_weapon)
{
	player endon("disconnect");
	self endon("blizzard_off");
	while(1)
	{
		a_zombies = GetAIArray();
		foreach(zombie in a_zombies)
		{
			if(!(isdefined(zombie.is_on_ice) && zombie.is_on_ice))
			{
				if(DistanceSquared(self.origin, zombie.origin) <= 30625)
				{
					if(isdefined(zombie.is_mechz) && zombie.is_mechz)
					{
						zombie thread ice_affect_mechz(player, 1);
						continue;
					}
					if(isalive(zombie))
					{
						zombie thread ice_affect_zombie(str_weapon, player, 1);
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: ice_staff_blizzard_timeout
	Namespace: namespace_42f5ba79
	Checksum: 0x7607E544
	Offset: 0x11F8
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function ice_staff_blizzard_timeout(n_time)
{
	self endon("death");
	self endon("blizzard_off");
	wait(n_time);
	self notify("blizzard_off");
}

/*
	Name: ice_staff_blizzard_off
	Namespace: namespace_42f5ba79
	Checksum: 0x71A531C0
	Offset: 0x1238
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function ice_staff_blizzard_off()
{
	self endon("death");
	self endon("blizzard_off");
	level waittill("blizzard_shot");
	self notify("blizzard_off");
}

/*
	Name: get_ice_blast_range
	Namespace: namespace_42f5ba79
	Checksum: 0xC943B665
	Offset: 0x1278
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function get_ice_blast_range(n_charge)
{
	switch(n_charge)
	{
		case 0:
		case 1:
		{
			n_range = 250000;
			break;
		}
		case 2:
		{
			n_range = 640000;
			break;
		}
		case 3:
		{
			n_range = 1000000;
			break;
		}
	}
	return n_range;
}

/*
	Name: staff_water_zombie_range
	Namespace: namespace_42f5ba79
	Checksum: 0x29E8DE8F
	Offset: 0x1300
	Size: 0x16B
	Parameters: 2
	Flags: None
*/
function staff_water_zombie_range(v_source, n_range)
{
	a_enemies = [];
	a_zombies = GetAIArray();
	a_zombies = util::get_array_of_closest(v_source, a_zombies);
	if(isdefined(a_zombies))
	{
		for(i = 0; i < a_zombies.size; i++)
		{
			if(!isdefined(a_zombies[i]))
			{
				continue;
			}
			v_zombie_pos = a_zombies[i] GetTagOrigin("j_head");
			if(DistanceSquared(v_source, v_zombie_pos) > n_range)
			{
				continue;
			}
			if(!zm_tomb_utility::bullet_trace_throttled(v_source, v_zombie_pos, undefined))
			{
				continue;
			}
			if(isdefined(a_zombies[i]) && isalive(a_zombies[i]))
			{
				a_enemies[a_enemies.size] = a_zombies[i];
			}
		}
	}
	return a_enemies;
}

/*
	Name: is_staff_water_damage
	Namespace: namespace_42f5ba79
	Checksum: 0x2B0D4B32
	Offset: 0x1478
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function is_staff_water_damage(weapon)
{
	return isdefined(weapon) && (weapon.name == "staff_water" || weapon.name == "staff_water_upgraded" || weapon.name == "staff_water_fake_dart_zm") && (!isdefined(self.set_beacon_damage) && self.set_beacon_damage);
}

/*
	Name: ice_affect_mechz
	Namespace: namespace_42f5ba79
	Checksum: 0x3C21A1D9
	Offset: 0x1500
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function ice_affect_mechz(e_player, is_upgraded)
{
	if(isdefined(self.is_on_ice) && self.is_on_ice)
	{
		return;
	}
	self.is_on_ice = 1;
	if(is_upgraded)
	{
		self zm_tomb_utility::do_damage_network_safe(e_player, 3300, "staff_water_upgraded", "MOD_RIFLE_BULLET");
	}
	else
	{
		self zm_tomb_utility::do_damage_network_safe(e_player, 2050, "staff_water", "MOD_RIFLE_BULLET");
	}
	wait(1);
	self.is_on_ice = 0;
}

/*
	Name: ice_affect_zombie
	Namespace: namespace_42f5ba79
	Checksum: 0x4EBA9401
	Offset: 0x15B8
	Size: 0x357
	Parameters: 4
	Flags: None
*/
function ice_affect_zombie(str_weapon, e_player, always_kill, n_mod)
{
	if(!isdefined(str_weapon))
	{
		str_weapon = "staff_water";
	}
	if(!isdefined(always_kill))
	{
		always_kill = 0;
	}
	if(!isdefined(n_mod))
	{
		n_mod = 1;
	}
	self endon("death");
	instakill_on = e_player zm_powerups::is_insta_kill_active();
	if(str_weapon.name == "staff_water")
	{
		n_damage = 2050;
	}
	else if(str_weapon.name == "staff_water_upgraded" || str_weapon.name == "staff_water_upgraded2" || str_weapon.name == "staff_water_upgraded3")
	{
		n_damage = 3300;
	}
	else if(str_weapon.name == "one_inch_punch_ice")
	{
		n_damage = 11275;
	}
	if(isdefined(self.is_on_ice) && self.is_on_ice)
	{
		return;
	}
	self.is_on_ice = 1;
	self clientfield::set("attach_bullet_model", 1);
	self thread function_de3654ba(1);
	n_speed = 0.3;
	self ASMSetAnimationRate(0.3);
	if(instakill_on || always_kill)
	{
		wait(RandomFloatRange(0.5, 0.7));
	}
	else
	{
		wait(RandomFloatRange(1.8, 2.3));
	}
	if(self.health < n_damage || instakill_on || always_kill)
	{
		self ASMSetAnimationRate(1);
		util::wait_network_frame();
		if(str_weapon.name != "one_inch_punch_ice")
		{
			staff_water_kill_zombie(e_player, str_weapon);
		}
	}
	else
	{
		self zm_tomb_utility::do_damage_network_safe(e_player, n_damage, str_weapon, "MOD_RIFLE_BULLET");
		self.deathAnim = undefined;
		self clientfield::set("attach_bullet_model", 0);
		wait(0.5);
		self thread function_de3654ba(0);
		self ASMSetAnimationRate(1);
		self.is_on_ice = 0;
	}
}

/*
	Name: set_anim_rate
	Namespace: namespace_42f5ba79
	Checksum: 0xD299AF7E
	Offset: 0x1918
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function set_anim_rate(n_speed)
{
	self clientfield::set("anim_rate", n_speed);
	n_rate = self clientfield::get("anim_rate");
	self setentityanimrate(n_rate);
	if(n_speed != 1)
	{
		self.preserve_asd_substates = 1;
	}
	util::wait_network_frame();
	if(!(isdefined(self.is_traversing) && self.is_traversing))
	{
		self.needs_run_update = 1;
		self notify("needs_run_update");
	}
	util::wait_network_frame();
	if(n_speed == 1)
	{
		self.preserve_asd_substates = 0;
	}
}

/*
	Name: staff_water_on_zombie_spawned
	Namespace: namespace_42f5ba79
	Checksum: 0x87550CC
	Offset: 0x1A28
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function staff_water_on_zombie_spawned()
{
	self clientfield::set("anim_rate", 1);
	n_rate = self clientfield::get("anim_rate");
	self setentityanimrate(n_rate);
}

/*
	Name: staff_water_death_event
	Namespace: namespace_42f5ba79
	Checksum: 0x5B2BCC29
	Offset: 0x1AA0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function staff_water_death_event(attacker)
{
	if(is_staff_water_damage(self.damageWeapon) && self.damageMod != "MOD_MELEE")
	{
		self.no_gib = 1;
		self.nodeathragdoll = 1;
		self freeze_zombie();
		if(isdefined(self.deathAnim))
		{
			self waittillmatch("death_anim");
		}
		self thread frozen_zombie_shatter();
	}
}

/*
	Name: _icicle_locate_target
	Namespace: namespace_42f5ba79
	Checksum: 0x60C23C50
	Offset: 0x1B50
	Size: 0x33B
	Parameters: 1
	Flags: None
*/
function _icicle_locate_target(str_weapon)
{
	is_upgraded = str_weapon.name == "staff_water_upgraded";
	fire_angles = self getPlayerAngles();
	fire_origin = self GetPlayerCameraPos();
	a_targets = GetAIArray();
	a_targets = util::get_array_of_closest(self.origin, a_targets, undefined, undefined, 600);
	foreach(target in a_targets)
	{
		if(isdefined(target.is_on_ice) && target.is_on_ice)
		{
			continue;
		}
		if(util::within_fov(fire_origin, fire_angles, target GetTagOrigin("j_spine4"), cos(25)))
		{
			if(isai(target))
			{
				a_tags = [];
				a_tags[0] = "j_hip_le";
				a_tags[1] = "j_hip_ri";
				a_tags[2] = "j_spine4";
				a_tags[3] = "j_elbow_le";
				a_tags[4] = "j_elbow_ri";
				a_tags[5] = "j_clavicle_le";
				a_tags[6] = "j_clavicle_ri";
				str_tag = a_tags[RandomInt(a_tags.size)];
				b_trace_pass = zm_tomb_utility::bullet_trace_throttled(fire_origin, target GetTagOrigin(str_tag), target);
				if(b_trace_pass && isdefined(target) && isalive(target))
				{
					if(isdefined(target.is_mechz) && target.is_mechz)
					{
						target thread ice_affect_mechz(self, is_upgraded);
					}
					else
					{
						target thread ice_affect_zombie(str_weapon, self);
					}
					return;
				}
			}
		}
	}
}

/*
	Name: _icicle_get_spread
	Namespace: namespace_42f5ba79
	Checksum: 0x4928F32D
	Offset: 0x1E98
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function _icicle_get_spread(n_spread)
{
	n_x = randomIntRange(n_spread * -1, n_spread);
	n_y = randomIntRange(n_spread * -1, n_spread);
	n_z = randomIntRange(n_spread * -1, n_spread);
	return (n_x, n_y, n_z);
}

/*
	Name: function_de3654ba
	Namespace: namespace_42f5ba79
	Checksum: 0xE3310B6
	Offset: 0x1F48
	Size: 0x2E5
	Parameters: 1
	Flags: None
*/
function function_de3654ba(is_frozen)
{
	if(self.archetype !== "zombie")
	{
		return;
	}
	if(is_frozen && !IsSubStr(self.model, "_ice"))
	{
		self.no_gib = 1;
		if(!isdefined(self.old_model))
		{
			self.old_model = self.model;
			self.var_f08c601 = self.head;
			self.var_7cff9f25 = self.hatModel;
		}
		self SetModel(self.old_model + "_ice");
		if(isdefined(self.var_f08c601) && (!isdefined(self.head_gibbed) && self.head_gibbed))
		{
			self Detach(self.head);
			self Attach(self.var_f08c601 + "_ice");
			self.head = self.var_f08c601 + "_ice";
		}
		if(isdefined(self.var_7cff9f25) && (!isdefined(self.hat_gibbed) && self.hat_gibbed))
		{
			self Detach(self.hatModel);
			self Attach(self.var_7cff9f25 + "_ice");
			self.hatModel = self.var_7cff9f25 + "_ice";
		}
	}
	else if(!is_frozen && isdefined(self.old_model))
	{
		self.no_gib = undefined;
		self SetModel(self.old_model);
		self.old_model = undefined;
		if(isdefined(self.var_f08c601) && (!isdefined(self.head_gibbed) && self.head_gibbed))
		{
			self Detach(self.head);
			self Attach(self.var_f08c601);
			self.var_f08c601 = undefined;
		}
		if(isdefined(self.var_7cff9f25) && (!isdefined(self.hat_gibbed) && self.hat_gibbed))
		{
			self Detach(self.hatModel);
			self Attach(self.var_7cff9f25);
			self.var_7cff9f25 = undefined;
		}
	}
}

