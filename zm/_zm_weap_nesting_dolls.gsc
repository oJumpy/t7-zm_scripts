#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_utility;

#namespace namespace_d2920ea5;

/*
	Name: __init__sytem__
	Namespace: namespace_d2920ea5
	Checksum: 0x96BDBFE8
	Offset: 0x380
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_nesting_dolls", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_d2920ea5
	Checksum: 0x93BC3F30
	Offset: 0x3C0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.w_nesting_dolls = GetWeapon("nesting_dolls");
	level.w_nesting_dolls_single = GetWeapon("nesting_dolls_single");
	level.nesting_dolls_launch_speed = 500;
	level.nesting_dolls_launch_angle = 45;
	level.nesting_dolls_too_close_dist = 10000;
	level.nesting_dolls_det_time = 0.25;
	level.nesting_dolls_player_aim_dot = cos(22.5);
	level.nesting_dolls_damage_radius = 180;
	gravity = GetDvarFloat("bg_gravity");
	level.nesting_dolls_launch_peak_time = level.nesting_dolls_launch_speed * sin(level.nesting_dolls_launch_angle) / Abs(gravity) * 0.5;
	level.nesting_dolls_max_ids = 10;
	/#
		level.zombiemode_devgui_nesting_dolls_give = &player_give_nesting_dolls;
	#/
	setup_nesting_dolls_data();
}

/*
	Name: setup_nesting_dolls_data
	Namespace: namespace_d2920ea5
	Checksum: 0xABC3154B
	Offset: 0x518
	Size: 0x2AF
	Parameters: 0
	Flags: None
*/
function setup_nesting_dolls_data()
{
	if(isdefined(level.nesting_dolls_override_setup))
	{
		[[level.nesting_dolls_override_setup]]();
		return;
	}
	level._effect["nesting_doll_trail_blue"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_blue";
	level._effect["nesting_doll_trail_green"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_green";
	level._effect["nesting_doll_trail_red"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_red";
	level._effect["nesting_doll_trail_yellow"] = "dlc5/zmb_weapon/fx_zmb_trail_doll_yellow";
	level.nesting_dolls_data = [];
	level.nesting_dolls_data[0] = spawnstruct();
	level.nesting_dolls_data[0].name = "dempsey";
	level.nesting_dolls_data[0].id = 127;
	level.nesting_dolls_data[0].trailfx = level._effect["nesting_doll_trail_blue"];
	level.nesting_dolls_data[1] = spawnstruct();
	level.nesting_dolls_data[1].name = "nikolai";
	level.nesting_dolls_data[1].id = 128;
	level.nesting_dolls_data[1].trailfx = level._effect["nesting_doll_trail_red"];
	level.nesting_dolls_data[2] = spawnstruct();
	level.nesting_dolls_data[2].name = "takeo";
	level.nesting_dolls_data[2].id = 130;
	level.nesting_dolls_data[2].trailfx = level._effect["nesting_doll_trail_green"];
	level.nesting_dolls_data[3] = spawnstruct();
	level.nesting_dolls_data[3].name = "richtofen";
	level.nesting_dolls_data[3].id = 129;
	level.nesting_dolls_data[3].trailfx = level._effect["nesting_doll_trail_yellow"];
}

/*
	Name: nesting_dolls_exists
	Namespace: namespace_d2920ea5
	Checksum: 0x14483B93
	Offset: 0x7D0
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function nesting_dolls_exists()
{
	return isdefined(level.zombie_weapons["nesting_dolls"]);
}

/*
	Name: player_give_nesting_dolls
	Namespace: namespace_d2920ea5
	Checksum: 0x22DA1DCA
	Offset: 0x7F0
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function player_give_nesting_dolls()
{
	self nesting_dolls_create_randomized_indices(0);
	start_camo = level.nesting_dolls_data[self.nesting_dolls_randomized_indices[0][0]].id;
	weapon_options = self CalcWeaponOptions(start_camo, 0, 0);
	if(self HasWeapon(level.w_nesting_dolls))
	{
		self updateweaponoptions(level.w_nesting_dolls, weapon_options);
	}
	else
	{
		self GiveWeapon(level.w_nesting_dolls, weapon_options);
	}
	self zm_utility::set_player_tactical_grenade(level.w_nesting_dolls);
	self thread player_handle_nesting_dolls();
}

/*
	Name: player_handle_nesting_dolls
	Namespace: namespace_d2920ea5
	Checksum: 0x2AC1D21
	Offset: 0x910
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function player_handle_nesting_dolls()
{
	self notify("starting_nesting_dolls");
	self endon("disconnect");
	self endon("starting_nesting_dolls");
	while(1)
	{
		grenade = get_thrown_nesting_dolls();
		if(isdefined(grenade))
		{
			if(self laststand::player_is_in_laststand())
			{
				grenade delete();
				continue;
			}
			self thread doll_spawner_cluster(grenade);
		}
		wait(0.05);
	}
}

/*
	Name: doll_spawner
	Namespace: namespace_d2920ea5
	Checksum: 0x10DCD8A3
	Offset: 0x9C8
	Size: 0x1CD
	Parameters: 1
	Flags: None
*/
function doll_spawner(start_grenade)
{
	self endon("disconnect");
	self endon("death");
	num_dolls = 1;
	max_dolls = 4;
	self nesting_dolls_set_id();
	self thread nesting_dolls_setup_next_doll_throw();
	if(isdefined(start_grenade))
	{
		start_grenade spawn_doll_model(self.doll_id, 0, self);
		start_grenade thread doll_behavior_explode_when_stopped(self, self.doll_id, 0);
	}
	while(num_dolls < max_dolls)
	{
		self waittill("spawn_doll", origin, angles);
		grenade_vel = self get_launch_velocity(origin, 2000);
		if(grenade_vel == (0, 0, 0))
		{
			grenade_vel = self get_random_launch_velocity(origin, angles);
		}
		grenade = self MagicGrenadeType(level.w_nesting_dolls_single, origin, grenade_vel);
		grenade spawn_doll_model(self.doll_id, num_dolls, self);
		grenade thread doll_behavior_explode_when_stopped(self, self.doll_id, num_dolls);
		num_dolls++;
	}
}

/*
	Name: doll_spawner_cluster
	Namespace: namespace_d2920ea5
	Checksum: 0xB452BE0A
	Offset: 0xBA0
	Size: 0x207
	Parameters: 1
	Flags: None
*/
function doll_spawner_cluster(start_grenade)
{
	self endon("disconnect");
	self endon("death");
	num_dolls = 1;
	max_dolls = 4;
	self nesting_dolls_set_id();
	self thread nesting_dolls_setup_next_doll_throw();
	self thread nesting_dolls_track_achievement(self.doll_id);
	self thread nesting_dolls_check_achievement(self.doll_id);
	if(isdefined(start_grenade))
	{
		start_grenade spawn_doll_model(self.doll_id, 0, self);
		start_grenade thread doll_behavior_explode_when_stopped(self, self.doll_id, 0);
	}
	self waittill("spawn_doll", origin, angles);
	while(num_dolls < max_dolls)
	{
		grenade_vel = self get_cluster_launch_velocity(angles, num_dolls);
		grenade = self MagicGrenadeType(level.w_nesting_dolls_single, origin, grenade_vel);
		grenade spawn_doll_model(self.doll_id, num_dolls, self);
		grenade playsound("wpn_nesting_pop_npc");
		grenade thread doll_behavior_explode_when_stopped(self, self.doll_id, num_dolls);
		num_dolls++;
		wait(0.25);
	}
}

/*
	Name: doll_do_damage
	Namespace: namespace_d2920ea5
	Checksum: 0x3DF22E63
	Offset: 0xDB0
	Size: 0x183
	Parameters: 4
	Flags: None
*/
function doll_do_damage(origin, owner, id, index)
{
	self waittill("explode");
	zombies = zombie_utility::get_round_enemy_array();
	if(zombies.size == 0)
	{
		return;
	}
	zombie_sort = util::get_array_of_closest(origin, zombies, undefined, undefined, level.nesting_dolls_damage_radius);
	for(i = 0; i < zombie_sort.size; i++)
	{
		if(isalive(zombie_sort[i]))
		{
			if(zombie_sort[i] damageConeTrace(origin, owner) == 1)
			{
				owner.nesting_dolls_tracker[id][index] = owner.nesting_dolls_tracker[id][index] + 1;
			}
		}
	}
	RadiusDamage(origin, level.nesting_dolls_damage_radius, 95000, 95000, owner, "MOD_GRENADE_SPLASH", level.w_nesting_dolls_single);
}

/*
	Name: randomize_angles
	Namespace: namespace_d2920ea5
	Checksum: 0x2D9219B1
	Offset: 0xF40
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function randomize_angles(angles)
{
	random_yaw = randomIntRange(-45, 45);
	random_pitch = randomIntRange(-45, -35);
	random = (random_pitch, random_yaw, 0);
	return_angles = angles + random;
	return return_angles;
}

/*
	Name: get_random_launch_velocity
	Namespace: namespace_d2920ea5
	Checksum: 0x6993EAE4
	Offset: 0xFD8
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function get_random_launch_velocity(doll_origin, angles)
{
	angles = randomize_angles(angles);
	trace_dist = level.nesting_dolls_launch_speed * level.nesting_dolls_launch_peak_time;
	for(i = 0; i < 4; i++)
	{
		dir = AnglesToForward(angles);
		if(BulletTracePassed(doll_origin, doll_origin + dir * trace_dist, 0, undefined))
		{
			grenade_vel = dir * level.nesting_dolls_launch_speed;
			return grenade_vel;
			continue;
		}
		angles = angles + VectorScale((0, 1, 0), 90);
	}
	return (0, 0, level.nesting_dolls_launch_speed);
}

/*
	Name: get_cluster_launch_velocity
	Namespace: namespace_d2920ea5
	Checksum: 0x84F2CDEA
	Offset: 0x10F8
	Size: 0xC5
	Parameters: 2
	Flags: None
*/
function get_cluster_launch_velocity(angles, index)
{
	random_pitch = randomIntRange(-45, -35);
	offsets = Array(45, 0, -45);
	angles = angles + (random_pitch, offsets[index - 1], 0);
	dir = AnglesToForward(angles);
	grenade_vel = dir * level.nesting_dolls_launch_speed;
	return grenade_vel;
}

/*
	Name: get_launch_velocity
	Namespace: namespace_d2920ea5
	Checksum: 0x4F696A79
	Offset: 0x11C8
	Size: 0x105
	Parameters: 2
	Flags: None
*/
function get_launch_velocity(doll_origin, range)
{
	velocity = (0, 0, 0);
	target = get_doll_best_doll_target(doll_origin, range);
	if(isdefined(target))
	{
		target_origin = target get_target_leading_pos();
		dir = VectorToAngles(target_origin - doll_origin);
		dir = (dir[0] - level.nesting_dolls_launch_angle, dir[1], dir[2]);
		dir = AnglesToForward(dir);
		velocity = dir * level.nesting_dolls_launch_speed;
	}
	return velocity;
}

/*
	Name: get_target_leading_pos
	Namespace: namespace_d2920ea5
	Checksum: 0x470943D5
	Offset: 0x12D8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function get_target_leading_pos()
{
	position = self.origin;
	return position;
}

/*
	Name: spawn_doll_model
	Namespace: namespace_d2920ea5
	Checksum: 0x82D293DF
	Offset: 0x1300
	Size: 0x1B3
	Parameters: 3
	Flags: None
*/
function spawn_doll_model(id, index, parent)
{
	self Hide();
	self.doll_model = spawn("script_model", self.origin);
	data_index = parent.nesting_dolls_randomized_indices[id][index];
	name = level.nesting_dolls_data[data_index].name;
	model_index = index + 1;
	model_name = "wpn_t7_zmb_hd_nesting_dolls_" + name + "_doll" + model_index + "_world";
	self.doll_model SetModel(model_name);
	self.doll_model useanimtree(-1);
	self.doll_model LinkTo(self);
	self.doll_model.angles = self.angles;
	self.doll_model thread nesting_dolls_cleanup(self);
	wait(0.1);
	PlayFXOnTag(level.nesting_dolls_data[data_index].trailfx, self.doll_model, "tag_origin");
}

/*
	Name: doll_behavior_explode_when_stopped
	Namespace: namespace_d2920ea5
	Checksum: 0xDEE34D19
	Offset: 0x14C0
	Size: 0x183
	Parameters: 3
	Flags: None
*/
function doll_behavior_explode_when_stopped(parent, doll_id, index)
{
	velocitySq = 100000000;
	oldpos = self.origin;
	while(velocitySq != 0)
	{
		wait(0.1);
		if(!isdefined(self))
		{
			break;
		}
		velocitySq = DistanceSquared(self.origin, oldpos);
		oldpos = self.origin;
	}
	if(isdefined(self))
	{
		self.doll_model Unlink();
		self.doll_model.origin = self.origin;
		self.doll_model.angles = self.angles;
		parent notify("spawn_doll", self.origin, self.angles);
		self thread doll_do_damage(self.origin, parent, doll_id, index);
		self ResetMissileDetonationTime(level.nesting_dolls_det_time);
		if(isdefined(index) && index == 3)
		{
			parent thread nesting_dolls_end_achievement_tracking(doll_id);
		}
	}
}

/*
	Name: nesting_dolls_end_achievement_tracking
	Namespace: namespace_d2920ea5
	Checksum: 0x836615AA
	Offset: 0x1650
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function nesting_dolls_end_achievement_tracking(doll_id)
{
	wait(level.nesting_dolls_det_time + 0.1);
	self notify("end_achievement_tracker" + doll_id);
}

/*
	Name: get_player_aim_best_doll_target
	Namespace: namespace_d2920ea5
	Checksum: 0x72DCC9C7
	Offset: 0x1688
	Size: 0x295
	Parameters: 1
	Flags: None
*/
function get_player_aim_best_doll_target(range)
{
	view_pos = self GetWeaponMuzzlePoint();
	zombies = util::get_array_of_closest(view_pos, zombie_utility::get_round_enemy_array(), undefined, undefined, range * 1.1);
	if(!isdefined(zombies))
	{
		return;
	}
	range_squared = range * range;
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale(forward_view_angles, range);
	best_dot = -999;
	best_target = undefined;
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(view_pos, test_origin);
		if(test_range_squared > range_squared)
		{
			return;
		}
		normal = VectorNormalize(test_origin - view_pos);
		dot = VectorDot(forward_view_angles, normal);
		if(dot < 0)
		{
			continue;
		}
		if(dot < level.nesting_dolls_player_aim_dot)
		{
			continue;
		}
		if(0 == zombies[i] damageConeTrace(view_pos, self))
		{
			continue;
		}
		if(dot > best_dot)
		{
			best_dot = dot;
			best_target = zombies[i];
		}
	}
	/#
	#/
	return best_target;
}

/*
	Name: get_doll_best_doll_target
	Namespace: namespace_d2920ea5
	Checksum: 0x8E42A65
	Offset: 0x1928
	Size: 0x125
	Parameters: 2
	Flags: None
*/
function get_doll_best_doll_target(origin, range)
{
	zombies = GetAIArray(level.zombie_team);
	if(zombies.size > 0)
	{
		zombie_sort = util::get_array_of_closest(origin, zombies, undefined, undefined, range);
		for(i = 0; i < zombie_sort.size; i++)
		{
			if(isdefined(zombie_sort[i]) && isalive(zombie_sort[i]))
			{
				centroid = zombie_sort[i] GetCentroid();
				if(BulletTracePassed(origin, centroid, 0, undefined))
				{
					return zombie_sort[i];
				}
			}
		}
	}
	return undefined;
}

/*
	Name: nesting_dolls_cleanup
	Namespace: namespace_d2920ea5
	Checksum: 0x1AD87A5C
	Offset: 0x1A58
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function nesting_dolls_cleanup(parent)
{
	while(1)
	{
		if(!isdefined(parent))
		{
			zm_utility::self_delete();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: do_nesting_dolls_sound
	Namespace: namespace_d2920ea5
	Checksum: 0x74312B56
	Offset: 0x1AA8
	Size: 0x7D
	Parameters: 2
	Flags: None
*/
function do_nesting_dolls_sound(model, info)
{
	monk_scream_vox = 0;
	if(level.music_override == 0)
	{
		monk_scream_vox = 0;
		self playsound("zmb_monkey_song");
	}
	self waittill("explode", position);
}

/*
	Name: get_thrown_nesting_dolls
	Namespace: namespace_d2920ea5
	Checksum: 0x1772A031
	Offset: 0x1B30
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function get_thrown_nesting_dolls()
{
	self endon("disconnect");
	self endon("starting_nesting_dolls");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(weapon == level.w_nesting_dolls)
		{
			return grenade;
		}
		wait(0.05);
	}
}

/*
	Name: nesting_dolls_debug_print
	Namespace: namespace_d2920ea5
	Checksum: 0xAC58E4B0
	Offset: 0x1BA8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function nesting_dolls_debug_print(msg, color)
{
	/#
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + VectorScale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: nesting_dolls_set_id
	Namespace: namespace_d2920ea5
	Checksum: 0x2CCBA0BD
	Offset: 0x1C20
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function nesting_dolls_set_id()
{
	if(!isdefined(self.doll_id))
	{
		self.doll_id = 0;
		return;
	}
	self.doll_id = self.doll_id + 1;
	if(self.doll_id >= level.nesting_dolls_max_ids)
	{
		self.doll_id = 0;
	}
}

/*
	Name: nesting_dolls_track_achievement
	Namespace: namespace_d2920ea5
	Checksum: 0x85970470
	Offset: 0x1C80
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function nesting_dolls_track_achievement(doll_id)
{
	self endon("end_achievement_tracker" + doll_id);
	if(!isdefined(self.nesting_dolls_tracker))
	{
		self.nesting_dolls_tracker = [];
		for(i = 0; i < level.nesting_dolls_max_ids; i++)
		{
			self.nesting_dolls_tracker[i] = [];
		}
	}
	for(i = 0; i < 4; i++)
	{
		self.nesting_dolls_tracker[doll_id][i] = 0;
	}
}

/*
	Name: nesting_dolls_check_achievement
	Namespace: namespace_d2920ea5
	Checksum: 0x145525F6
	Offset: 0x1D30
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function nesting_dolls_check_achievement(doll_id)
{
	self waittill("end_achievement_tracker" + doll_id);
	min_kills_per_doll = 1;
	for(i = 0; i < 4; i++)
	{
		if(self.nesting_dolls_tracker[doll_id][i] < min_kills_per_doll)
		{
			return;
		}
	}
}

/*
	Name: nesting_dolls_create_randomized_indices
	Namespace: namespace_d2920ea5
	Checksum: 0x1396AB39
	Offset: 0x1DB0
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function nesting_dolls_create_randomized_indices(id)
{
	if(!isdefined(self.nesting_dolls_randomized_indices))
	{
		self.nesting_dolls_randomized_indices = [];
	}
	base_indices = Array(0, 1, 2, 3);
	self.nesting_dolls_randomized_indices[id] = Array::randomize(base_indices);
}

/*
	Name: nesting_dolls_setup_next_doll_throw
	Namespace: namespace_d2920ea5
	Checksum: 0xC0252611
	Offset: 0x1E30
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function nesting_dolls_setup_next_doll_throw()
{
	self endon("death");
	self endon("disconnect");
	wait(0.5);
	next_id = self.doll_id + 1;
	if(next_id >= level.nesting_dolls_max_ids)
	{
		next_id = 0;
	}
	self nesting_dolls_create_randomized_indices(next_id);
	if(self HasWeapon(level.w_nesting_dolls))
	{
		cammo = level.nesting_dolls_data[self.nesting_dolls_randomized_indices[next_id][0]].id;
		self updateweaponoptions(level.w_nesting_dolls, self CalcWeaponOptions(cammo, 0, 0));
	}
}

