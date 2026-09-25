#using scripts\codescripts\struct;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_cymbal_monkey;

/*
	Name: init
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x8B008347
	Offset: 0x3F0
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function init()
{
	level.weaponZMCymbalMonkey = GetWeapon("cymbal_monkey");
	zm_weapons::register_zombie_weapon_callback(level.weaponZMCymbalMonkey, &player_give_cymbal_monkey);
	if(!cymbal_monkey_exists(level.weaponZMCymbalMonkey))
	{
		return;
	}
	level.w_cymbal_monkey_upgraded = GetWeapon("cymbal_monkey_upgraded");
	if(cymbal_monkey_exists(level.w_cymbal_monkey_upgraded))
	{
		zm_weapons::register_zombie_weapon_callback(level.w_cymbal_monkey_upgraded, &player_give_cymbal_monkey_upgraded);
		level._effect["monkey_bass"] = "dlc3/stalingrad/fx_cymbal_monkey_radial_pulse";
	}
	/#
		level.zombiemode_devgui_cymbal_monkey_give = &player_give_cymbal_monkey;
	#/
	if(isdefined(level.legacy_cymbal_monkey) && level.legacy_cymbal_monkey)
	{
		level.cymbal_monkey_model = "weapon_zombie_monkey_bomb";
	}
	else
	{
		level.cymbal_monkey_model = "wpn_t7_zmb_monkey_bomb_world";
	}
	level._effect["monkey_glow"] = "zombie/fx_cymbal_monkey_light_zmb";
	level._effect["grenade_samantha_steal"] = "zombie/fx_monkey_lightning_zmb";
	level.cymbal_monkeys = [];
	if(!isdefined(level.VALID_POI_MAX_RADIUS))
	{
		level.VALID_POI_MAX_RADIUS = 200;
	}
	if(!isdefined(level.VALID_POI_HALF_HEIGHT))
	{
		level.VALID_POI_HALF_HEIGHT = 100;
	}
	if(!isdefined(level.VALID_POI_INNER_SPACING))
	{
		level.VALID_POI_INNER_SPACING = 2;
	}
	if(!isdefined(level.VALID_POI_RADIUS_FROM_EDGES))
	{
		level.VALID_POI_RADIUS_FROM_EDGES = 15;
	}
	if(!isdefined(level.VALID_POI_HEIGHT))
	{
		level.VALID_POI_HEIGHT = 36;
	}
}

/*
	Name: player_give_cymbal_monkey
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xF73F989C
	Offset: 0x5F0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function player_give_cymbal_monkey()
{
	self GiveWeapon(level.weaponZMCymbalMonkey);
	self zm_utility::set_player_tactical_grenade(level.weaponZMCymbalMonkey);
	self thread player_handle_cymbal_monkey();
}

/*
	Name: player_give_cymbal_monkey_upgraded
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xAB224972
	Offset: 0x658
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function player_give_cymbal_monkey_upgraded()
{
	/#
		self notify("give_tactical_grenade_thread");
	#/
	if(isdefined(self zm_utility::get_player_tactical_grenade()))
	{
		self TakeWeapon(self zm_utility::get_player_tactical_grenade());
	}
	self GiveWeapon(level.w_cymbal_monkey_upgraded);
	self zm_utility::set_player_tactical_grenade(level.w_cymbal_monkey_upgraded);
	self thread player_handle_cymbal_monkey();
}

/*
	Name: player_handle_cymbal_monkey
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xD643BC1E
	Offset: 0x710
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function player_handle_cymbal_monkey()
{
	self notify("starting_monkey_watch");
	self endon("disconnect");
	self endon("starting_monkey_watch");
	attract_dist_diff = level.monkey_attract_dist_diff;
	if(!isdefined(attract_dist_diff))
	{
		attract_dist_diff = 45;
	}
	num_attractors = level.num_monkey_attractors;
	if(!isdefined(num_attractors))
	{
		num_attractors = 96;
	}
	max_attract_dist = level.monkey_attract_dist;
	if(!isdefined(max_attract_dist))
	{
		max_attract_dist = 1536;
	}
	while(1)
	{
		grenade = get_thrown_monkey();
		self player_throw_cymbal_monkey(grenade, num_attractors, max_attract_dist, attract_dist_diff);
		wait(0.05);
	}
}

/*
	Name: watch_for_dud
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x686475E
	Offset: 0x810
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function watch_for_dud(model, actor)
{
	self endon("death");
	self waittill("grenade_dud");
	model.dud = 1;
	self playsound("zmb_vox_monkey_scream");
	self.monk_scream_vox = 1;
	wait(3);
	if(isdefined(model))
	{
		model delete();
	}
	if(isdefined(actor))
	{
		actor delete();
	}
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: watch_for_emp
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xA8207C0F
	Offset: 0x910
	Size: 0x1EB
	Parameters: 2
	Flags: None
*/
function watch_for_emp(model, actor)
{
	self endon("death");
	if(!zm_utility::should_watch_for_emp())
	{
		return;
	}
	while(1)
	{
		level waittill("emp_detonate", origin, radius);
		if(DistanceSquared(origin, self.origin) < radius * radius)
		{
			break;
		}
	}
	self.stun_fx = 1;
	if(isdefined(level._equipment_emp_destroy_fx))
	{
		playFX(level._equipment_emp_destroy_fx, self.origin + VectorScale((0, 0, 1), 5), (0, RandomFloat(360), 0));
	}
	wait(0.15);
	self.attract_to_origin = 0;
	self zm_utility::deactivate_zombie_point_of_interest();
	model ClearAnim(%o_monkey_bomb, 0);
	wait(1);
	self detonate();
	wait(1);
	if(isdefined(model))
	{
		model delete();
	}
	if(isdefined(actor))
	{
		actor delete();
	}
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: clone_player_angles
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xE35DA994
	Offset: 0xB08
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function clone_player_angles(owner)
{
	self endon("death");
	owner endon("death");
	while(isdefined(self))
	{
		self.angles = owner.angles;
		wait(0.05);
	}
}

/*
	Name: show_briefly
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x4597327E
	Offset: 0xB60
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function show_briefly(showtime)
{
	self endon("show_owner");
	if(isdefined(self.show_for_time))
	{
		self.show_for_time = showtime;
		return;
	}
	self.show_for_time = showtime;
	self SetVisibleToAll();
	while(self.show_for_time > 0)
	{
		self.show_for_time = self.show_for_time - 0.05;
		wait(0.05);
	}
	self SetVisibleToAllExceptTeam(level.zombie_team);
	self.show_for_time = undefined;
}

/*
	Name: show_owner_on_attack
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x60E8B30F
	Offset: 0xC18
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function show_owner_on_attack(owner)
{
	owner endon("hide_owner");
	owner endon("show_owner");
	self endon("explode");
	self endon("death");
	self endon("grenade_dud");
	owner.show_for_time = undefined;
	for(;;)
	{
		owner waittill("weapon_fired");
		owner thread show_briefly(0.5);
	}
}

/*
	Name: hide_owner
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x62579F73
	Offset: 0xCA0
	Size: 0x22B
	Parameters: 1
	Flags: None
*/
function hide_owner(owner)
{
	owner notify("hide_owner");
	owner endon("hide_owner");
	owner setPerk("specialty_immunemms");
	owner.no_burning_sfx = 1;
	owner notify("stop_flame_sounds");
	owner SetVisibleToAllExceptTeam(level.zombie_team);
	owner.hide_owner = 1;
	if(isdefined(level._effect["human_disappears"]))
	{
		playFX(level._effect["human_disappears"], owner.origin);
	}
	self thread show_owner_on_attack(owner);
	evt = self util::waittill_any_ex("explode", "death", "grenade_dud", owner, "hide_owner");
	/#
		println("Dev Block strings are not supported" + evt);
	#/
	owner notify("show_owner");
	owner unsetPerk("specialty_immunemms");
	if(isdefined(level._effect["human_disappears"]))
	{
		playFX(level._effect["human_disappears"], owner.origin);
	}
	owner.no_burning_sfx = undefined;
	owner SetVisibleToAll();
	owner.hide_owner = undefined;
	owner show();
}

/*
	Name: proximity_detonate
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x3AF2B9C5
	Offset: 0xED8
	Size: 0x26B
	Parameters: 1
	Flags: None
*/
function proximity_detonate(owner)
{
	wait(1.5);
	if(!isdefined(self))
	{
		return;
	}
	detonateRadius = 96;
	explosionRadius = detonateRadius * 2;
	damagearea = spawn("trigger_radius", self.origin + (0, 0, 0 - detonateRadius), 4, detonateRadius, detonateRadius * 1.5);
	damagearea SetExcludeTeamForTrigger(owner.team);
	damagearea EnableLinkTo();
	damagearea LinkTo(self);
	self.damagearea = damagearea;
	while(isdefined(self))
	{
		damagearea waittill("trigger", ent);
		if(isdefined(owner) && ent == owner)
		{
			continue;
		}
		if(isdefined(ent.team) && ent.team == owner.team)
		{
			continue;
		}
		self playsound("wpn_claymore_alert");
		dist = Distance(self.origin, ent.origin);
		RadiusDamage(self.origin + VectorScale((0, 0, 1), 12), explosionRadius, 1, 1, owner, "MOD_GRENADE_SPLASH", level.weaponZMCymbalMonkey);
		if(isdefined(owner))
		{
			self detonate(owner);
		}
		else
		{
			self detonate(undefined);
		}
		break;
	}
	if(isdefined(damagearea))
	{
		damagearea delete();
	}
}

/*
	Name: FakeLinkto
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xB0D2DAB
	Offset: 0x1150
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function FakeLinkto(linkee)
{
	self notify("FakeLinkto");
	self endon("FakeLinkto");
	self.backlinked = 1;
	while(isdefined(self) && isdefined(linkee))
	{
		self.origin = linkee.origin;
		self.angles = linkee.angles;
		wait(0.05);
	}
}

/*
	Name: player_throw_cymbal_monkey
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x59CA39BC
	Offset: 0x11D8
	Size: 0x75B
	Parameters: 4
	Flags: None
*/
function player_throw_cymbal_monkey(grenade, num_attractors, max_attract_dist, attract_dist_diff)
{
	self endon("disconnect");
	self endon("starting_monkey_watch");
	if(isdefined(grenade))
	{
		grenade endon("death");
		if(self laststand::player_is_in_laststand())
		{
			if(isdefined(grenade.damagearea))
			{
				grenade.damagearea delete();
			}
			grenade delete();
			return;
		}
		grenade Hide();
		model = spawn("script_model", grenade.origin);
		model SetModel(level.cymbal_monkey_model);
		model useanimtree(-1);
		model LinkTo(grenade);
		model.angles = grenade.angles;
		model thread monkey_cleanup(grenade);
		clone = undefined;
		if(isdefined(level.cymbal_monkey_dual_view) && level.cymbal_monkey_dual_view)
		{
			model SetVisibleToAllExceptTeam(level.zombie_team);
			clone = zm_clone::spawn_player_clone(self, VectorScale((0, 0, -1), 999), level.cymbal_monkey_clone_weapon, undefined);
			model.simulacrum = clone;
			clone zm_clone::clone_animate("idle");
			clone thread clone_player_angles(self);
			clone notsolid();
			clone ghost();
		}
		grenade thread watch_for_dud(model, clone);
		grenade thread watch_for_emp(model, clone);
		info = spawnstruct();
		info.sound_attractors = [];
		grenade waittill("stationary");
		if(isdefined(level.grenade_planted))
		{
			self thread [[level.grenade_planted]](grenade, model);
		}
		if(isdefined(grenade))
		{
			grenade.ground_ent = grenade GetGroundEnt();
			if(isdefined(model))
			{
				if(isdefined(grenade.ground_ent) && !grenade.ground_ent.classname === "worldspawn")
				{
					model SetMovingPlatformEnabled(1);
					model LinkTo(grenade.ground_ent);
					grenade thread FakeLinkto(model);
				}
				else if(!(isdefined(grenade.backlinked) && grenade.backlinked))
				{
					model Unlink();
					model.origin = grenade.origin;
					model.angles = grenade.angles;
				}
				wait(0.1);
				model AnimScripted("cymbal_monkey_anim", grenade.origin, grenade.angles, %o_monkey_bomb);
			}
			if(isdefined(clone))
			{
				clone ForceTeleport(grenade.origin, grenade.angles);
				clone thread hide_owner(self);
				grenade thread proximity_detonate(self);
				clone show();
				clone SetInvisibleToAll();
				clone SetVisibleToTeam(level.zombie_team);
			}
			grenade ResetMissileDetonationTime();
			PlayFXOnTag(level._effect["monkey_glow"], model, "tag_origin_animate");
			valid_poi = zm_utility::check_point_in_enabled_zone(grenade.origin, undefined, undefined);
			if(isdefined(level.move_valid_poi_to_navmesh) && level.move_valid_poi_to_navmesh)
			{
				valid_poi = grenade move_valid_poi_to_navmesh(valid_poi);
			}
			if(isdefined(level.check_valid_poi))
			{
				valid_poi = grenade [[level.check_valid_poi]](valid_poi);
			}
			if(valid_poi)
			{
				grenade zm_utility::create_zombie_point_of_interest(max_attract_dist, num_attractors, 10000);
				grenade.attract_to_origin = 1;
				grenade thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, attract_dist_diff);
				grenade thread zm_utility::wait_for_attractor_positions_complete();
				if(grenade.weapon == level.w_cymbal_monkey_upgraded)
				{
					grenade thread pulse_damage(self, model);
				}
				grenade thread do_monkey_sound(model, info);
				level.cymbal_monkeys[level.cymbal_monkeys.size] = grenade;
			}
			else
			{
				grenade.script_noteworthy = undefined;
				level thread grenade_stolen_by_sam(grenade, model, clone);
			}
		}
		else
		{
			grenade.script_noteworthy = undefined;
			level thread grenade_stolen_by_sam(grenade, model, clone);
		}
	}
}

/*
	Name: move_valid_poi_to_navmesh
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xBDE94FEA
	Offset: 0x1940
	Size: 0x1E9
	Parameters: 1
	Flags: None
*/
function move_valid_poi_to_navmesh(valid_poi)
{
	if(!(isdefined(valid_poi) && valid_poi))
	{
		return 0;
	}
	if(IsPointOnNavMesh(self.origin))
	{
		return 1;
	}
	v_orig = self.origin;
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, level.VALID_POI_MAX_RADIUS, level.VALID_POI_HALF_HEIGHT, level.VALID_POI_INNER_SPACING, level.VALID_POI_RADIUS_FROM_EDGES);
	if(queryResult.data.size)
	{
		foreach(point in queryResult.data)
		{
			height_offset = Abs(self.origin[2] - point.origin[2]);
			if(height_offset > level.VALID_POI_HEIGHT)
			{
				continue;
			}
			if(BulletTracePassed(point.origin + VectorScale((0, 0, 1), 20), v_orig + VectorScale((0, 0, 1), 20), 0, self, undefined, 0, 0))
			{
				self.origin = point.origin;
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: grenade_stolen_by_sam
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x53E0F73C
	Offset: 0x1B38
	Size: 0x2DB
	Parameters: 3
	Flags: None
*/
function grenade_stolen_by_sam(ent_grenade, ent_model, ent_actor)
{
	if(!isdefined(ent_model))
	{
		return;
	}
	direction = ent_model.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]))
		{
			players[i] playlocalsound(level.zmb_laugh_alias);
		}
	}
	PlayFXOnTag(level._effect["grenade_samantha_steal"], ent_model, "tag_origin");
	ent_model StopAnimScripted();
	ent_model MoveZ(60, 1, 0.25, 0.25);
	ent_model vibrate(direction, 1.5, 2.5, 1);
	ent_model waittill("movedone");
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	ent_model delete();
	if(isdefined(ent_actor))
	{
		ent_actor delete();
	}
	if(isdefined(ent_grenade))
	{
		if(isdefined(ent_grenade.damagearea))
		{
			ent_grenade.damagearea delete();
		}
		ent_grenade delete();
	}
}

/*
	Name: monkey_cleanup
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x945465F1
	Offset: 0x1E20
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function monkey_cleanup(parent)
{
	while(1)
	{
		if(!isdefined(parent))
		{
			if(isdefined(self) && (isdefined(self.dud) && self.dud))
			{
				wait(6);
			}
			if(isdefined(self.simulacrum))
			{
				self.simulacrum delete();
			}
			zm_utility::self_delete();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: pulse_damage
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x283F7B1
	Offset: 0x1EB8
	Size: 0x1EF
	Parameters: 2
	Flags: None
*/
function pulse_damage(e_owner, model)
{
	self endon("explode");
	util::wait_network_frame();
	PlayFXOnTag(level._effect["monkey_bass"], model, "tag_origin_animate");
	n_damage_origin = self.origin + VectorScale((0, 0, 1), 12);
	while(1)
	{
		a_ai_targets = GetAITeamArray("axis");
		foreach(ai_target in a_ai_targets)
		{
			if(isdefined(ai_target))
			{
				n_distance_to_target = Distance(ai_target.origin, n_damage_origin);
				if(n_distance_to_target > 128)
				{
					continue;
				}
				n_damage = math::linear_map(n_distance_to_target, 0, 128, 500, 1000);
				ai_target DoDamage(n_damage, ai_target.origin, e_owner, self, "none", "MOD_GRENADE_SPLASH", 0, level.w_cymbal_monkey_upgraded);
			}
		}
		wait(1);
	}
}

/*
	Name: do_monkey_sound
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xF628398
	Offset: 0x20B0
	Size: 0x2FB
	Parameters: 2
	Flags: None
*/
function do_monkey_sound(model, info)
{
	self.monk_scream_vox = 0;
	if(isdefined(level.grenade_safe_to_bounce))
	{
		if(![[level.grenade_safe_to_bounce]](self.owner, level.weaponZMCymbalMonkey))
		{
			self playsound("zmb_vox_monkey_scream");
			self.monk_scream_vox = 1;
		}
	}
	if(isdefined(level.monkey_song_override))
	{
		if([[level.monkey_song_override]](self.owner, level.weaponZMCymbalMonkey))
		{
			self playsound("zmb_vox_monkey_scream");
			self.monk_scream_vox = 1;
		}
	}
	if(!self.monk_scream_vox && level.musicSystem.currentPlaytype < 4)
	{
		if(isdefined(level.cymbal_monkey_dual_view) && level.cymbal_monkey_dual_view)
		{
			self playsoundtoteam("zmb_monkey_song", "allies");
		}
		else if(self.weapon.name == "cymbal_monkey_upgraded")
		{
			self playsound("zmb_monkey_song_upgraded");
		}
		else
		{
			self playsound("zmb_monkey_song");
		}
	}
	if(!self.monk_scream_vox)
	{
		self thread play_delayed_explode_vox();
	}
	self waittill("explode", position);
	level notify("grenade_exploded", position, 100, 5000, 450);
	monkey_index = -1;
	for(i = 0; i < level.cymbal_monkeys.size; i++)
	{
		if(!isdefined(level.cymbal_monkeys[i]))
		{
			monkey_index = i;
			break;
		}
	}
	if(monkey_index >= 0)
	{
		ArrayRemoveIndex(level.cymbal_monkeys, monkey_index);
	}
	if(isdefined(model))
	{
		model ClearAnim(%o_monkey_bomb, 0.2);
	}
	for(i = 0; i < info.sound_attractors.size; i++)
	{
		if(isdefined(info.sound_attractors[i]))
		{
			info.sound_attractors[i] notify("monkey_blown_up");
		}
	}
}

/*
	Name: play_delayed_explode_vox
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x1768175C
	Offset: 0x23B8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function play_delayed_explode_vox()
{
	wait(6.5);
	if(isdefined(self))
	{
		if(self.weapon.name == "cymbal_monkey_upgraded")
		{
			self playsound("zmb_vox_monkey_explode_upgraded");
		}
		else
		{
			self playsound("zmb_vox_monkey_explode");
		}
	}
}

/*
	Name: get_thrown_monkey
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x342DEE84
	Offset: 0x2430
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function get_thrown_monkey()
{
	self endon("disconnect");
	self endon("starting_monkey_watch");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(weapon == level.weaponZMCymbalMonkey || weapon == level.w_cymbal_monkey_upgraded)
		{
			grenade.use_grenade_special_long_bookmark = 1;
			grenade.grenade_multiattack_bookmark_count = 1;
			grenade.weapon = weapon;
			return grenade;
		}
		wait(0.05);
	}
}

/*
	Name: monitor_zombie_groans
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x13C6F717
	Offset: 0x24F0
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function monitor_zombie_groans(info)
{
	self endon("explode");
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(self.attractor_array))
		{
			wait(0.05);
			continue;
		}
		for(i = 0; i < self.attractor_array.size; i++)
		{
			if(!IsInArray(info.sound_attractors, self.attractor_array[i]))
			{
				if(isdefined(self.origin) && isdefined(self.attractor_array[i].origin))
				{
					if(DistanceSquared(self.origin, self.attractor_array[i].origin) < 250000)
					{
						if(!isdefined(info.sound_attractors))
						{
							info.sound_attractors = [];
						}
						else if(!IsArray(info.sound_attractors))
						{
							info.sound_attractors = Array(info.sound_attractors);
						}
						info.sound_attractors[info.sound_attractors.size] = self.attractor_array[i];
						self.attractor_array[i] thread play_zombie_groans();
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: play_zombie_groans
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x60CC1BEE
	Offset: 0x26C8
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function play_zombie_groans()
{
	self endon("death");
	self endon("monkey_blown_up");
	while(1)
	{
		if(isdefined(self))
		{
			self playsound("zmb_vox_zombie_groan");
			wait(RandomFloatRange(2, 3));
		}
		else
		{
			return;
		}
	}
}

/*
	Name: cymbal_monkey_exists
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xE07A4342
	Offset: 0x2738
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function cymbal_monkey_exists(w_weapon)
{
	return zm_weapons::is_weapon_included(w_weapon);
}

