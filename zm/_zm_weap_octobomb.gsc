#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace _zm_weap_octobomb;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_octobomb
	Checksum: 0x51ACE1EA
	Offset: 0x628
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_octobomb", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_octobomb
	Checksum: 0x4DFB5D0
	Offset: 0x670
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "octobomb_fx", 1, 2, "int");
	clientfield::register("actor", "octobomb_spores_fx", 1, 2, "int");
	clientfield::register("actor", "octobomb_tentacle_hit_fx", 1, 1, "int");
	clientfield::register("actor", "octobomb_zombie_explode_fx", 8000, 1, "counter");
	clientfield::register("toplayer", "octobomb_state", 1, 3, "int");
	clientfield::register("missile", "octobomb_spit_fx", 1, 2, "int");
	/#
		level thread octobomb_devgui();
	#/
}

/*
	Name: __main__
	Namespace: _zm_weap_octobomb
	Checksum: 0xF33BB175
	Offset: 0x7B8
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level.w_octobomb = GetWeapon("octobomb");
	level.w_octobomb_upgraded = GetWeapon("octobomb_upgraded");
	level.mdl_octobomb = "p7_fxanim_zm_zod_octobomb_mod";
	if(!octobomb_exists())
	{
		return;
	}
	level._effect["grenade_samantha_steal"] = "zombie/fx_monkey_lightning_zmb";
	zm_weapons::register_zombie_weapon_callback(level.w_octobomb, &player_give_octobomb);
	zm_weapons::register_zombie_weapon_callback(level.w_octobomb_upgraded, &player_give_octobomb_upgraded);
	level.octobombs = [];
}

/*
	Name: player_give_octobomb_upgraded
	Namespace: _zm_weap_octobomb
	Checksum: 0x66860B28
	Offset: 0x8A0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function player_give_octobomb_upgraded()
{
	self player_give_octobomb("octobomb_upgraded");
}

/*
	Name: player_give_octobomb
	Namespace: _zm_weap_octobomb
	Checksum: 0x6BBE70AE
	Offset: 0x8D0
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function player_give_octobomb(str_weapon)
{
	if(!isdefined(str_weapon))
	{
		str_weapon = "octobomb";
	}
	w_tactical = self zm_utility::get_player_tactical_grenade();
	if(isdefined(w_tactical))
	{
		self TakeWeapon(w_tactical);
	}
	w_weapon = GetWeapon(str_weapon);
	self GiveWeapon(w_weapon);
	self zm_utility::set_player_tactical_grenade(w_weapon);
	self thread player_handle_octobomb();
}

/*
	Name: player_handle_octobomb
	Namespace: _zm_weap_octobomb
	Checksum: 0xBC22068E
	Offset: 0x9B8
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function player_handle_octobomb()
{
	self notify("starting_octobomb_watch");
	self endon("death");
	self endon("starting_octobomb_watch");
	attract_dist_custom = level.octobomb_attract_dist_custom;
	if(!isdefined(attract_dist_custom))
	{
		attract_dist_custom = 10;
	}
	num_attractors = level.num_octobomb_attractors;
	if(!isdefined(num_attractors))
	{
		num_attractors = 64;
	}
	max_attract_dist = level.octobomb_attract_dist;
	if(!isdefined(max_attract_dist))
	{
		max_attract_dist = 1024;
	}
	while(1)
	{
		e_grenade = get_thrown_octobomb();
		if(isdefined(e_grenade))
		{
			self thread player_throw_octobomb(e_grenade, num_attractors, max_attract_dist, attract_dist_custom);
		}
	}
}

/*
	Name: show_briefly
	Namespace: _zm_weap_octobomb
	Checksum: 0x1DC08BC5
	Offset: 0xAB8
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
	Namespace: _zm_weap_octobomb
	Checksum: 0x6EB61A86
	Offset: 0xB70
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
	Namespace: _zm_weap_octobomb
	Checksum: 0x3F16585C
	Offset: 0xBF8
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
	Name: FakeLinkto
	Namespace: _zm_weap_octobomb
	Checksum: 0xCAD41153
	Offset: 0xE30
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
	Name: grenade_planted
	Namespace: _zm_weap_octobomb
	Checksum: 0xF1B25D27
	Offset: 0xEB8
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function grenade_planted(grenade, model)
{
	ride_vehicle = undefined;
	grenade.ground_ent = grenade GetGroundEnt();
	if(isdefined(grenade.ground_ent))
	{
		if(isVehicle(grenade.ground_ent) && !level.zombie_team === grenade.ground_ent)
		{
			ride_vehicle = grenade.ground_ent;
		}
	}
	if(isdefined(ride_vehicle))
	{
		if(isdefined(grenade))
		{
			grenade SetMovingPlatformEnabled(1);
			grenade.equipment_can_move = 1;
			grenade.isOnVehicle = 1;
			grenade.move_parent = ride_vehicle;
			if(isdefined(model))
			{
				model SetMovingPlatformEnabled(1);
				model LinkTo(ride_vehicle);
				model.isOnVehicle = 1;
				grenade FakeLinkto(model);
			}
		}
	}
}

/*
	Name: check_octobomb_on_train
	Namespace: _zm_weap_octobomb
	Checksum: 0xACD4817C
	Offset: 0x1048
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function check_octobomb_on_train()
{
	self endon("death");
	if(self zm_zonemgr::entity_in_zone("zone_train_rail"))
	{
		while(!level.o_zod_train flag::get("moving"))
		{
			wait(0.05);
			continue;
		}
		self detonate();
	}
}

/*
	Name: player_throw_octobomb
	Namespace: _zm_weap_octobomb
	Checksum: 0xE43C1BAF
	Offset: 0x10C8
	Size: 0x61B
	Parameters: 4
	Flags: None
*/
function player_throw_octobomb(e_grenade, num_attractors, max_attract_dist, attract_dist_custom)
{
	self endon("starting_octobomb_watch");
	e_grenade endon("death");
	if(self laststand::player_is_in_laststand())
	{
		if(isdefined(e_grenade.damagearea))
		{
			e_grenade.damagearea delete();
		}
		e_grenade delete();
		return;
	}
	v_angles_clone_model = self.angles + VectorScale((1, 0, 1), 90);
	v_angles_anim_model = self.angles - VectorScale((0, 1, 0), 90);
	is_upgraded = e_grenade.weapon == level.w_octobomb_upgraded;
	if(is_upgraded)
	{
		n_cf_val = 2;
	}
	else
	{
		n_cf_val = 1;
	}
	e_grenade ghost();
	e_grenade.angles = v_angles_clone_model;
	e_grenade.clone_model = util::spawn_model(e_grenade.model, e_grenade.origin, e_grenade.angles);
	e_grenade.clone_model LinkTo(e_grenade);
	e_grenade thread octobomb_cleanup();
	e_grenade waittill("stationary", v_position, v_normal);
	e_grenade thread check_octobomb_on_train();
	self thread grenade_planted(e_grenade, e_grenade.clone_model);
	e_grenade ResetMissileDetonationTime();
	e_grenade is_on_navmesh();
	b_valid_poi = zm_utility::check_point_in_enabled_zone(e_grenade.origin, undefined, undefined);
	if(isdefined(level.check_b_valid_poi))
	{
		b_valid_poi = e_grenade [[level.check_b_valid_poi]](b_valid_poi);
	}
	if(b_valid_poi && e_grenade.navmesh_check)
	{
		if(isdefined(level.octobomb_attack_callback) && IsFunctionPtr(level.octobomb_attack_callback))
		{
			[[level.octobomb_attack_callback]](e_grenade);
		}
		e_grenade move_away_from_edges();
		e_grenade zm_utility::create_zombie_point_of_interest(max_attract_dist, num_attractors, 10000);
		e_grenade thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, attract_dist_custom);
		e_grenade thread zm_utility::wait_for_attractor_positions_complete();
		if(!(isdefined(e_grenade.b_special_octobomb) && e_grenade.b_special_octobomb))
		{
			e_grenade.clone_model zm_utility::self_delete();
			e_grenade.angles = v_angles_anim_model;
			e_grenade.anim_model = util::spawn_model(level.mdl_octobomb, e_grenade.origin, e_grenade.angles);
			if(isdefined(e_grenade.isOnVehicle) && e_grenade.isOnVehicle)
			{
				e_grenade.anim_model SetMovingPlatformEnabled(1);
				e_grenade.anim_model LinkTo(e_grenade.ground_ent);
				e_grenade.anim_model.isOnVehicle = 1;
				e_grenade thread FakeLinkto(e_grenade.anim_model);
			}
			e_grenade.anim_model clientfield::set("octobomb_fx", 3);
			wait(0.05);
			e_grenade.anim_model clientfield::set("octobomb_fx", n_cf_val);
			e_grenade thread animate_octobomb(is_upgraded);
			e_grenade thread do_octobomb_sound();
		}
		e_grenade thread do_tentacle_burst(self, is_upgraded);
		e_grenade thread do_tentacle_grab(self, is_upgraded);
		e_grenade thread sndAttackVox();
		e_grenade thread special_attractor_spawn(self, max_attract_dist);
		level.octobombs[level.octobombs.size] = e_grenade;
	}
	else
	{
		e_grenade.script_noteworthy = undefined;
		level thread grenade_stolen_by_sam(e_grenade);
	}
}

/*
	Name: is_on_navmesh
	Namespace: _zm_weap_octobomb
	Checksum: 0x215730C8
	Offset: 0x16F0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function is_on_navmesh()
{
	self endon("death");
	if(IsPointOnNavMesh(self.origin, 60) == 1)
	{
		self.navmesh_check = 1;
		return;
	}
	v_valid_point = GetClosestPointOnNavMesh(self.origin, 100);
	if(isdefined(v_valid_point))
	{
		n_z_correct = 0;
		if(self.origin[2] > v_valid_point[2])
		{
			n_z_correct = self.origin[2] - v_valid_point[2];
		}
		self.origin = v_valid_point + (0, 0, n_z_correct);
		self.navmesh_check = 1;
		return;
	}
	self.navmesh_check = 0;
}

/*
	Name: animate_octobomb
	Namespace: _zm_weap_octobomb
	Checksum: 0x4E4583A9
	Offset: 0x17F0
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function animate_octobomb(is_upgraded)
{
	self endon("death");
	self playsound("wpn_octobomb_explode");
	self scene::Play("p7_fxanim_zm_zod_octobomb_start_bundle", self.anim_model);
	self thread scene::Play("p7_fxanim_zm_zod_octobomb_loop_bundle", self.anim_model);
	n_start_anim_length = getanimlength("p7_fxanim_zm_zod_octobomb_start_anim");
	n_end_anim_length = getanimlength("p7_fxanim_zm_zod_octobomb_end_anim");
	n_life_time = self.weapon.fusetime - n_end_anim_length * 1000 - n_start_anim_length * 1000 / 1000;
	wait(n_life_time * 0.75);
	if(is_upgraded)
	{
		n_fx = 2;
	}
	else
	{
		n_fx = 1;
	}
	self thread clientfield::set("octobomb_spit_fx", n_fx);
	wait(n_life_time * 0.25);
	self scene::Play("p7_fxanim_zm_zod_octobomb_end_bundle", self.anim_model);
	self playsound("wpn_octobomb_end");
}

/*
	Name: move_away_from_edges
	Namespace: _zm_weap_octobomb
	Checksum: 0xA4B302B0
	Offset: 0x19B0
	Size: 0x1D9
	Parameters: 0
	Flags: None
*/
function move_away_from_edges()
{
	v_orig = self.origin;
	n_angles = self.angles;
	n_z_correct = 0;
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, 200, 100, 2, 20);
	if(queryResult.data.size)
	{
		foreach(point in queryResult.data)
		{
			if(BulletTracePassed(point.origin + VectorScale((0, 0, 1), 20), v_orig + VectorScale((0, 0, 1), 20), 0, self, undefined, 0, 0))
			{
				if(self.origin[2] > queryResult.origin[2])
				{
					n_z_correct = self.origin[2] - queryResult.origin[2];
				}
				self.origin = point.origin + (0, 0, n_z_correct);
				self.angles = n_angles;
				break;
			}
		}
	}
}

/*
	Name: grenade_stolen_by_sam
	Namespace: _zm_weap_octobomb
	Checksum: 0x2B271FDB
	Offset: 0x1B98
	Size: 0x2FB
	Parameters: 1
	Flags: None
*/
function grenade_stolen_by_sam(e_grenade)
{
	if(!isdefined(e_grenade))
	{
		return;
	}
	direction = e_grenade.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	if(!(isdefined(e_grenade.sndNoSamLaugh) && e_grenade.sndNoSamLaugh))
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(isalive(players[i]))
			{
				players[i] playlocalsound(level.zmb_laugh_alias);
			}
		}
	}
	PlayFXOnTag(level._effect["grenade_samantha_steal"], e_grenade, "tag_origin");
	e_grenade.clone_model Unlink();
	e_grenade.clone_model MoveZ(60, 1, 0.25, 0.25);
	e_grenade.clone_model vibrate(direction, 1.5, 2.5, 1);
	e_grenade.clone_model waittill("movedone");
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	e_grenade.clone_model delete();
	if(isdefined(e_grenade))
	{
		if(isdefined(e_grenade.damagearea))
		{
			e_grenade.damagearea delete();
		}
		e_grenade delete();
	}
}

/*
	Name: octobomb_cleanup
	Namespace: _zm_weap_octobomb
	Checksum: 0xD9072A32
	Offset: 0x1EA0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function octobomb_cleanup()
{
	while(1)
	{
		if(!isdefined(self))
		{
			if(isdefined(self.clone_model))
			{
				self.clone_model delete();
			}
			if(isdefined(self.anim_model))
			{
				self.anim_model delete();
			}
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
	Name: do_octobomb_sound
	Namespace: _zm_weap_octobomb
	Checksum: 0x1469FE2F
	Offset: 0x1F78
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function do_octobomb_sound()
{
	self waittill("explode", position);
	level notify("grenade_exploded", position, 100, 5000, 450);
	octobomb_index = -1;
	for(i = 0; i < level.octobombs.size; i++)
	{
		if(!isdefined(level.octobombs[i]))
		{
			octobomb_index = i;
			break;
		}
	}
	if(octobomb_index >= 0)
	{
		ArrayRemoveIndex(level.octobombs, octobomb_index);
	}
}

/*
	Name: do_tentacle_burst
	Namespace: _zm_weap_octobomb
	Checksum: 0x321C0A6C
	Offset: 0x2048
	Size: 0x287
	Parameters: 2
	Flags: None
*/
function do_tentacle_burst(e_player, is_upgraded)
{
	self endon("explode");
	n_time_started = GetTime() / 1000;
	while(1)
	{
		n_time_current = GetTime() / 1000;
		n_time_elapsed = n_time_current - n_time_started;
		if(n_time_elapsed < 1)
		{
			n_radius = LerpFloat(0, 100, n_time_elapsed / 1);
		}
		else if(n_time_elapsed == 1)
		{
			n_radius = 100;
		}
		a_ai_potential_targets = zombie_utility::get_zombie_array();
		if(isdefined(level.octobomb_targets))
		{
			a_ai_potential_targets = [[level.octobomb_targets]](a_ai_potential_targets);
		}
		a_ai_targets = ArraySortClosest(a_ai_potential_targets, self.origin, a_ai_potential_targets.size, 0, 100);
		foreach(ai_target in a_ai_targets)
		{
			if(isalive(ai_target))
			{
				ai_target thread clientfield::set("octobomb_tentacle_hit_fx", 1);
				if(ai_target.b_octobomb_infected !== 1)
				{
					self notify("sndKillVox");
					ai_target playsound("wpn_octobomb_zombie_imp");
					ai_target thread zombie_explodes();
					ai_target thread zombie_spore_infect(e_player, self, is_upgraded);
				}
				wait(0.05);
				ai_target thread clientfield::set("octobomb_tentacle_hit_fx", 0);
			}
		}
		wait(0.5);
	}
}

/*
	Name: zombie_spore_infect
	Namespace: _zm_weap_octobomb
	Checksum: 0x605D82E8
	Offset: 0x22D8
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function zombie_spore_infect(e_player, e_grenade, is_upgraded)
{
	self endon("death");
	self.octobomb_infected = 1;
	n_infection_time = 0;
	n_infection_half_time = 3.5;
	n_burst_damage = 3;
	if(is_upgraded)
	{
		n_damage = 1200;
		n_spore_val = 2;
	}
	else
	{
		n_damage = 600;
		n_spore_val = 1;
	}
	self clientfield::set("octobomb_spores_fx", n_spore_val);
	while(n_infection_time < 7)
	{
		wait(0.5);
		n_infection_time++;
		self DoDamage(n_damage * n_burst_damage, self.origin, e_player, e_grenade);
		n_burst_damage = 1;
	}
	self.octobomb_infected = 0;
	self clientfield::set("octobomb_spores_fx", 0);
}

/*
	Name: zombie_explodes
	Namespace: _zm_weap_octobomb
	Checksum: 0xD42BFE1C
	Offset: 0x2430
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function zombie_explodes()
{
	self waittill("death");
	if(isdefined(self))
	{
		if(self.octobomb_infected == 1)
		{
			self clientfield::increment("octobomb_zombie_explode_fx", 1);
			self octo_gib();
		}
	}
}

/*
	Name: do_tentacle_grab
	Namespace: _zm_weap_octobomb
	Checksum: 0x8C57E552
	Offset: 0x24A0
	Size: 0x37F
	Parameters: 2
	Flags: None
*/
function do_tentacle_grab(e_player, is_upgraded)
{
	self endon("death");
	b_fast_grab = 1;
	n_grabs = 0;
	if(is_upgraded)
	{
		n_spore_val = 2;
		n_time_min = 0.5;
		n_time_max = 1.5;
		continue;
	}
	n_spore_val = 1;
	n_time_min = 1.5;
	n_time_max = 2.5;
	while(1)
	{
		if(b_fast_grab == 0)
		{
			n_wait_grab = RandomFloatRange(n_time_min, n_time_max);
		}
		else
		{
			n_wait_grab = 0.1;
		}
		wait(n_wait_grab);
		a_ai_potential_targets = zombie_utility::get_zombie_array();
		if(isdefined(level.octobomb_targets))
		{
			a_ai_potential_targets = [[level.octobomb_targets]](a_ai_potential_targets);
		}
		a_ai_targets = ArraySort(a_ai_potential_targets, self.origin, 1, a_ai_potential_targets.size, 112);
		n_random_x = RandomFloatRange(-5, 5);
		n_random_y = RandomFloatRange(-5, 5);
		if(a_ai_targets.size > 0)
		{
			ai_target = Array::random(a_ai_targets);
			if(isalive(ai_target))
			{
				ai_target clientfield::set("octobomb_spores_fx", n_spore_val);
				self.octobomb_infected = 1;
				self notify("sndKillVox");
				ai_target playsound("wpn_octobomb_zombie_imp");
				ai_target octo_gib();
				ai_target DoDamage(ai_target.health, ai_target.origin, e_player, self);
				ai_target StartRagdoll();
				ai_target LaunchRagdoll(105 * VectorNormalize(ai_target.origin - self.origin + (n_random_x, n_random_y, 200)));
			}
			if(RandomInt(6) > n_grabs + 3)
			{
				b_fast_grab = 1;
				n_grabs++;
			}
			else
			{
				b_fast_grab = 0;
				n_grabs = 0;
			}
		}
		else
		{
			b_fast_grab = 1;
		}
	}
}

/*
	Name: octo_gib
	Namespace: _zm_weap_octobomb
	Checksum: 0xD03FC6FB
	Offset: 0x2828
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function octo_gib()
{
	GibServerUtils::GibHead(self);
	if(math::cointoss())
	{
		GibServerUtils::GibLeftArm(self);
	}
	else
	{
		GibServerUtils::GibRightArm(self);
	}
	GibServerUtils::GibLegs(self);
}

/*
	Name: special_attractor_spawn
	Namespace: _zm_weap_octobomb
	Checksum: 0xCD367F35
	Offset: 0x28A8
	Size: 0x34F
	Parameters: 2
	Flags: None
*/
function special_attractor_spawn(e_player, max_attract_dist)
{
	self endon("death");
	self MakeSentient();
	self setmaxhealth(1000);
	self setnormalhealth(1);
	self thread parasite_attractor_grab(self);
	while(1)
	{
		a_ai_zombies = Array::get_all_closest(self.origin, GetAITeamArray(level.zombie_team), undefined, undefined, max_attract_dist * 1.5);
		foreach(ai_zombie in a_ai_zombies)
		{
			if(isVehicle(ai_zombie))
			{
				if(ai_zombie.archetype == "parasite" && ai_zombie.ignoreme !== 1 && ai_zombie vehicle_ai::get_current_state() != "scripted")
				{
					if(!isdefined(self.v_parasite_attractor_center))
					{
						self parasite_attractor_init();
					}
					ai_zombie thread parasite_variables(self);
					ai_zombie thread parasite_attractor(self);
					continue;
				}
				if(ai_zombie.archetype == "raps" && ai_zombie.b_attracted_to_octobomb !== 1)
				{
					ai_zombie thread vehicle_attractor(self);
				}
				if(ai_zombie.archetype == "raps" && ai_zombie.octobomb_infected !== 1 && Distance(self.origin, ai_zombie.origin) <= 100)
				{
					ai_zombie thread vehicle_attractor_damage(e_player);
				}
				if(ai_zombie.archetype == "spider" && ai_zombie.octobomb_infected !== 1 && Distance(self.origin, ai_zombie.origin) <= 100)
				{
					ai_zombie thread vehicle_attractor_damage(e_player);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: vehicle_attractor
	Namespace: _zm_weap_octobomb
	Checksum: 0x4AC33718
	Offset: 0x2C00
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function vehicle_attractor(e_grenade)
{
	self endon("death");
	self.favoriteenemy = e_grenade;
	self.b_attracted_to_octobomb = 1;
	self.ignoreme = 1;
	e_grenade waittill("death");
	self.b_attracted_to_octobomb = 0;
	self.ignoreme = 0;
}

/*
	Name: vehicle_attractor_damage
	Namespace: _zm_weap_octobomb
	Checksum: 0xBF318B1A
	Offset: 0x2C68
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function vehicle_attractor_damage(e_player)
{
	self endon("death");
	self.octobomb_infected = 1;
	n_infection_time = 0;
	while(n_infection_time < 7)
	{
		self DoDamage(600, self.origin, e_player);
		wait(0.5);
	}
	self.octobomb_infected = 0;
}

/*
	Name: parasite_attractor_init
	Namespace: _zm_weap_octobomb
	Checksum: 0x66612A2E
	Offset: 0x2CF0
	Size: 0x22D
	Parameters: 0
	Flags: None
*/
function parasite_attractor_init()
{
	self.v_parasite_attractor_center = self.origin + VectorScale((0, 0, 1), 80);
	self.a_v_parasite_attractors = [];
	if(!isdefined(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = [];
	}
	else if(!IsArray(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = Array(self.a_v_parasite_attractors);
	}
	self.a_v_parasite_attractors[self.a_v_parasite_attractors.size] = self.v_parasite_attractor_center + VectorScale((1, 0, 0), 80);
	if(!isdefined(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = [];
	}
	else if(!IsArray(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = Array(self.a_v_parasite_attractors);
	}
	self.a_v_parasite_attractors[self.a_v_parasite_attractors.size] = self.v_parasite_attractor_center + VectorScale((0, 1, 0), 80);
	if(!isdefined(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = [];
	}
	else if(!IsArray(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = Array(self.a_v_parasite_attractors);
	}
	self.a_v_parasite_attractors[self.a_v_parasite_attractors.size] = self.v_parasite_attractor_center + VectorScale((-1, 0, 0), 80);
	if(!isdefined(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = [];
	}
	else if(!IsArray(self.a_v_parasite_attractors))
	{
		self.a_v_parasite_attractors = Array(self.a_v_parasite_attractors);
	}
	self.a_v_parasite_attractors[self.a_v_parasite_attractors.size] = self.v_parasite_attractor_center + VectorScale((0, -1, 0), 80);
}

/*
	Name: parasite_variables
	Namespace: _zm_weap_octobomb
	Checksum: 0xD738A365
	Offset: 0x2F28
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function parasite_variables(e_grenade)
{
	self endon("death");
	self.favoriteenemy = e_grenade;
	self vehicle_ai::set_state("scripted");
	self.b_parasite_attracted = 1;
	self.ignoreme = 1;
	self.parasiteEnemy = e_grenade;
	self ai::set_ignoreall(1);
	e_grenade waittill("death");
	self ResumeSpeed();
	self vehicle_ai::set_state("combat");
	self.b_parasite_attracted = 0;
	self.ignoreme = 0;
	self ai::set_ignoreall(0);
}

/*
	Name: parasite_attractor
	Namespace: _zm_weap_octobomb
	Checksum: 0xA3E24B1F
	Offset: 0x3028
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function parasite_attractor(e_grenade)
{
	self endon("death");
	e_grenade endon("death");
	f_speed = 10;
	if(Distance(e_grenade.v_parasite_attractor_center, self.origin) > 80)
	{
		self SetSpeed(10);
		self SetVehGoalPos(e_grenade.v_parasite_attractor_center, 0, 1);
		while(Distance(e_grenade.v_parasite_attractor_center, self.origin) > 80)
		{
			wait(0.05);
		}
		self ClearVehGoalPos();
	}
	i = 0;
	while(self.b_parasite_attracted)
	{
		if(i == 4)
		{
			i = 0;
		}
		self SetVehGoalPos(e_grenade.a_v_parasite_attractors[i], 0, 1);
		while(Distance(e_grenade.a_v_parasite_attractors[i], self.origin) > 10)
		{
			if(!self.b_parasite_attracted)
			{
				break;
			}
			wait(0.05);
		}
		self ClearVehGoalPos();
		i++;
		wait(0.05);
	}
}

/*
	Name: parasite_attractor_grab
	Namespace: _zm_weap_octobomb
	Checksum: 0x61A6C658
	Offset: 0x3200
	Size: 0x25F
	Parameters: 1
	Flags: None
*/
function parasite_attractor_grab(e_grenade)
{
	e_grenade endon("death");
	self endon("death");
	b_fast_grab = 1;
	n_grabs = 0;
	while(1)
	{
		if(b_fast_grab == 0)
		{
			n_wait_grab = RandomFloatRange(1.5, 2.5);
		}
		else
		{
			n_wait_grab = 0.1;
		}
		wait(n_wait_grab);
		a_ai_parasites = Array::get_all_closest(self.origin, GetAITeamArray(level.zombie_team), undefined, undefined, 150);
		i = 0;
		while(i < a_ai_parasites.size)
		{
			if(isdefined(a_ai_parasites[i]) && a_ai_parasites[i].archetype != "parasite")
			{
				ArrayRemoveValue(a_ai_parasites, a_ai_parasites[i]);
				i = 0;
				continue;
			}
			i++;
		}
		if(a_ai_parasites.size > 0)
		{
			ai_parasite = Array::random(a_ai_parasites);
			v_fling = VectorNormalize(ai_parasite.origin - e_grenade.origin);
			ai_parasite DoDamage(ai_parasite.maxhealth, self.origin);
			if(RandomInt(6) > n_grabs + 3)
			{
				b_fast_grab = 1;
				n_grabs++;
			}
			else
			{
				b_fast_grab = 0;
				n_grabs = 0;
			}
		}
		else
		{
			b_fast_grab = 1;
		}
	}
}

/*
	Name: sndAttackVox
	Namespace: _zm_weap_octobomb
	Checksum: 0x1A76B328
	Offset: 0x3468
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function sndAttackVox()
{
	self endon("explode");
	while(1)
	{
		self waittill("sndKillVox");
		wait(0.25);
		self playsound("wpn_octobomb_attack_vox");
		wait(2.5);
	}
}

/*
	Name: get_thrown_octobomb
	Namespace: _zm_weap_octobomb
	Checksum: 0xA00E9117
	Offset: 0x34C8
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function get_thrown_octobomb()
{
	self endon("death");
	self endon("starting_octobomb_watch");
	while(1)
	{
		self waittill("grenade_fire", e_grenade, w_weapon);
		if(w_weapon == level.w_octobomb || w_weapon == level.w_octobomb_upgraded)
		{
			e_grenade.use_grenade_special_long_bookmark = 1;
			e_grenade.grenade_multiattack_bookmark_count = 1;
			e_grenade.weapon = w_weapon;
			return e_grenade;
		}
		wait(0.05);
	}
}

/*
	Name: octobomb_exists
	Namespace: _zm_weap_octobomb
	Checksum: 0x188ABBD
	Offset: 0x3588
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function octobomb_exists()
{
	return zm_weapons::is_weapon_included(level.w_octobomb);
}

/*
	Name: octobomb_devgui
	Namespace: _zm_weap_octobomb
	Checksum: 0xFAA6A6A7
	Offset: 0x35B0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function octobomb_devgui()
{
	for(i = 0; i < 4; i++)
	{
		level thread setup_devgui_func("ZM/Weapons/Offhand/Octobomb/Give" + i, "zod_give_octobomb", i, &devgui_octobomb_give);
	}
	level thread setup_devgui_func("ZM/Weapons/Offhand/Octobomb/Give to All", "zod_give_octobomb", 4, &devgui_octobomb_give);
}

/*
	Name: setup_devgui_func
	Namespace: _zm_weap_octobomb
	Checksum: 0xE4FD05DB
	Offset: 0x3658
	Size: 0x11F
	Parameters: 5
	Flags: Private
*/
function private setup_devgui_func(str_devgui_path, str_dvar, n_value, func, n_base_value)
{
	if(!isdefined(n_base_value))
	{
		n_base_value = -1;
	}
	SetDvar(str_dvar, n_base_value);
	AddDebugCommand("devgui_cmd "" + str_devgui_path + "" "" + str_dvar + " " + n_value + ""
");
	while(1)
	{
		n_dvar = GetDvarInt(str_dvar);
		if(n_dvar > n_base_value)
		{
			[[func]](n_dvar);
			SetDvar(str_dvar, n_base_value);
		}
		util::wait_network_frame();
	}
}

/*
	Name: devgui_octobomb_give
	Namespace: _zm_weap_octobomb
	Checksum: 0x35598070
	Offset: 0x3780
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function devgui_octobomb_give(n_player_index)
{
	players = GetPlayers();
	player = players[n_player_index];
	if(isdefined(player))
	{
		octobomb_give(player);
		break;
	}
	if(n_player_index === 4)
	{
		foreach(player in players)
		{
			octobomb_give(player);
		}
	}
}

/*
	Name: octobomb_give
	Namespace: _zm_weap_octobomb
	Checksum: 0x6B955389
	Offset: 0x3880
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function octobomb_give(player)
{
	player clientfield::set_to_player("octobomb_state", 3);
	weapon = GetWeapon("octobomb");
	player TakeWeapon(weapon);
	player zm_weapons::weapon_give(weapon, undefined, undefined, 1);
}

