#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#namespace zm_weap_shrink_ray;

/*
	Name: __init__sytem__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x12975D65
	Offset: 0x478
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_shrink_ray", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x3FC39EBE
	Offset: 0x4C0
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "fun_size", 5000, 1, "int");
	level.shrink_models = [];
	zombie_utility::set_zombie_var("shrink_ray_fling_range", 480);
	level._effect["shrink_ray_stepped_on"] = "dlc5/temple/fx_ztem_zombie_mini_squish";
	level._effect["shrink_ray_stepped_on_in_water"] = "dlc5/temple/fx_ztem_zombie_mini_drown";
	level._effect["shrink_ray_stepped_on_no_gore"] = "dlc5/temple/fx_ztem_monkey_shrink";
	level._effect["shrink"] = "dlc5/zmb_weapon/fx_shrink_ray_zombie_shrink";
	level._effect["unshrink"] = "dlc5/zmb_weapon/fx_shrink_ray_zombie_unshrink";
	callback::on_spawned(&wait_for_shrink_ray_fired);
	level._shrinkable_objects = [];
	level.w_shrink_ray = GetWeapon("shrink_ray");
	level.w_shrink_ray_upgraded = GetWeapon("shrink_ray_upgraded");
	zm::register_player_damage_callback(&function_19171a77);
}

/*
	Name: __main__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x8B11A348
	Offset: 0x640
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(isdefined(level.shrink_ray_model_mapping_func))
	{
		[[level.shrink_ray_model_mapping_func]]();
	}
}

/*
	Name: add_shrinkable_object
	Namespace: zm_weap_shrink_ray
	Checksum: 0x7D6A5113
	Offset: 0x668
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function add_shrinkable_object(ent)
{
	Array::add(level._shrinkable_objects, ent, 0);
}

/*
	Name: remove_shrinkable_object
	Namespace: zm_weap_shrink_ray
	Checksum: 0x32EB8F72
	Offset: 0x6A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function remove_shrinkable_object(ent)
{
	ArrayRemoveValue(level._shrinkable_objects, ent);
}

/*
	Name: kicked_vox_network_choke
	Namespace: zm_weap_shrink_ray
	Checksum: 0x5EDA1459
	Offset: 0x6D8
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function kicked_vox_network_choke()
{
	while(1)
	{
		level._num_kicked_vox = 0;
		util::wait_network_frame();
	}
}

/*
	Name: wait_for_shrink_ray_fired
	Namespace: zm_weap_shrink_ray
	Checksum: 0xFE8F8CF3
	Offset: 0x710
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function wait_for_shrink_ray_fired()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("weapon_fired");
		currentWeapon = self GetCurrentWeapon();
		if(currentWeapon == level.w_shrink_ray || currentWeapon == level.w_shrink_ray_upgraded)
		{
			self thread shrink_ray_fired(currentWeapon == level.w_shrink_ray_upgraded);
		}
	}
}

/*
	Name: function_19171a77
	Namespace: zm_weap_shrink_ray
	Checksum: 0x1837C087
	Offset: 0x7A0
	Size: 0xA3
	Parameters: 13
	Flags: None
*/
function function_19171a77(e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, w_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name)
{
	if(isdefined(e_inflictor))
	{
		if(isdefined(e_inflictor.shrinked) && e_inflictor.shrinked)
		{
			return 5;
		}
	}
	return n_damage;
}

/*
	Name: shrink_ray_fired
	Namespace: zm_weap_shrink_ray
	Checksum: 0x66095D4B
	Offset: 0x850
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function shrink_ray_fired(upgraded)
{
	zombies = shrink_ray_get_enemies_in_range(upgraded, 0);
	objects = shrink_ray_get_enemies_in_range(upgraded, 1);
	zombies = ArrayCombine(zombies, objects, 1, 0);
	maxshrinks = 1000;
	for(i = 0; i < zombies.size && i < maxshrinks; i++)
	{
		if(isai(zombies[i]))
		{
			zombies[i] thread shrink_zombie(upgraded, self);
			continue;
		}
		zombies[i] notify("shrunk", upgraded);
	}
}

/*
	Name: shrink_ray_do_damage
	Namespace: zm_weap_shrink_ray
	Checksum: 0xE66B2C8A
	Offset: 0x988
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function shrink_ray_do_damage(upgraded, player)
{
	damage = 10;
	self DoDamage(damage, player.origin, player, undefined, "projectile");
	self shrink_ray_debug_print(damage, (0, 1, 0));
}

/*
	Name: shrink_corpse
	Namespace: zm_weap_shrink_ray
	Checksum: 0x94F50335
	Offset: 0xA10
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function shrink_corpse(upgraded, attacker)
{
	if(isdefined(self.shrinked) && self.shrinked)
	{
		return;
	}
	self.shrinked = 1;
	nummodels = self getattachsize();
	for(i = nummodels - 1; i >= 0; i--)
	{
		model = self getAttachModelName(i);
		self Detach(model);
		attachmodel = level.shrink_models[model];
		if(isdefined(attachmodel))
		{
			self Attach(attachmodel);
		}
	}
	mini_model = level.shrink_models[self.model];
	if(isdefined(mini_model))
	{
		self SetModel(mini_model);
	}
}

/*
	Name: shrink_zombie
	Namespace: zm_weap_shrink_ray
	Checksum: 0xD22E8E38
	Offset: 0xB68
	Size: 0xACD
	Parameters: 2
	Flags: None
*/
function shrink_zombie(upgraded, attacker)
{
	self endon("death");
	if(isdefined(self.shrinked) && self.shrinked)
	{
		return;
	}
	if(!isdefined(self.shrink_count))
	{
		self.shrink_count = 0;
	}
	shrinktime = 2.5;
	if(self.animName == "sonic_zombie")
	{
		if(self.shrink_count == 0)
		{
			shrinktime = 0.75;
		}
		else if(self.shrink_count == 1)
		{
			shrinktime = 1.5;
		}
		else
		{
			shrinktime = 2.5;
		}
	}
	else if(self.animName == "napalm_zombie")
	{
		if(self.shrink_count == 0)
		{
			shrinktime = 0.75;
		}
		else if(self.shrink_count == 1)
		{
			shrinktime = 1.5;
		}
		else
		{
			shrinktime = 2.5;
		}
	}
	else
	{
		shrinktime = 2.5;
		shrinktime = shrinktime + RandomFloatRange(0, 0.5);
	}
	if(upgraded)
	{
		shrinktime = shrinktime * 2;
	}
	self.shrink_count++;
	shrinkfxwait = 0;
	if(IsActor(self))
	{
		self clientfield::set("fun_size", 1);
	}
	self notify("shrink");
	self.shrinked = 1;
	self.shrinkattacker = attacker;
	self.kill_on_wine_coccon = 1;
	if(!isdefined(attacker.shrinked_zombies))
	{
		attacker.shrinked_zombies = [];
	}
	if(!isdefined(attacker.shrinked_zombies[self.animName]))
	{
		attacker.shrinked_zombies[self.animName] = 0;
	}
	attacker.shrinked_zombies[self.animName]++;
	normalmodel = self.model;
	health = self.health;
	if(isdefined(self.animName) && self.animName == "monkey_zombie")
	{
		if(isdefined(self.shrink_ray_fling))
		{
			self [[self.shrink_ray_fling]](attacker);
		}
		else
		{
			fling_range_squared = level.zombie_vars["shrink_ray_fling_range"] * level.zombie_vars["shrink_ray_fling_range"];
			view_pos = attacker GetWeaponMuzzlePoint();
			test_origin = self GetCentroid();
			test_range_squared = DistanceSquared(view_pos, test_origin);
			dist_mult = fling_range_squared - test_range_squared / fling_range_squared;
			fling_vec = VectorNormalize(test_origin - view_pos);
			fling_vec = (fling_vec[0], fling_vec[1], Abs(fling_vec[2]));
			fling_vec = VectorScale(fling_vec, 100 + 100 * dist_mult);
			self DoDamage(self.health + 666, attacker.origin, attacker);
			self StartRagdoll();
			self LaunchRagdoll(fling_vec);
		}
	}
	else if(self zombie_gib_on_shrink_ray())
	{
		self shrink_death(attacker);
	}
	else
	{
		self playsound("evt_shrink");
		self.shrinkattacker thread zm_audio::create_and_play_dialog("kill", "shrink");
		self thread play_shrink_fx("shrink", "J_MainRoot");
		saved_meleedamage = self.meleeDamage;
		self.meleeDamage = 5;
		self.no_gib = 1;
		self zombie_utility::zombie_eye_glow_stop();
		attachedmodels = [];
		attachedtags = [];
		hatModel = self.hatModel;
		nummodels = self getattachsize();
		for(i = nummodels - 1; i >= 0; i--)
		{
			model = self getAttachModelName(i);
			tag = self getAttachTagName(i);
			ishat = isdefined(self.hatModel) && self.hatModel == model;
			if(ishat)
			{
				self.hatModel = undefined;
			}
			attachedmodels[attachedmodels.size] = model;
			attachedtags[attachedtags.size] = tag;
			self Detach(model);
			attachmodel = level.shrink_models[model];
			if(isdefined(attachmodel))
			{
				self Attach(attachmodel);
				if(ishat)
				{
					self.hatModel = attachmodel;
				}
			}
		}
		mini_model = level.shrink_models[self.model];
		if(isdefined(mini_model))
		{
			self SetModel(mini_model);
		}
		if(!self.missingLegs)
		{
			self setPhysParams(8, -2, 32);
		}
		else
		{
			self AllowPitchAngle(0);
			newOrigin = self.origin + VectorScale((0, 0, 1), 10);
			self teleport(newOrigin, self.angles);
			self setPhysParams(8, -16, 10);
		}
		self.health = 1;
		self thread play_ambient_vox();
		self thread watch_for_kicked();
		self thread watch_for_death();
		self.zombie_board_tear_down_callback = &zomibe_shrunk_board_tear_down;
		if(isdefined(self._zombie_shrink_callback))
		{
			self [[self._zombie_shrink_callback]]();
		}
		wait(shrinktime);
		self playsound("evt_unshrink");
		self thread play_shrink_fx("unshrink", "J_MainRoot");
		wait(0.5);
		self.zombie_board_tear_down_callback = undefined;
		if(isdefined(self._zombie_unshrink_callback))
		{
			self [[self._zombie_unshrink_callback]]();
		}
		nummodels = self getattachsize();
		for(i = nummodels - 1; i >= 0; i--)
		{
			model = self getAttachModelName(i);
			tag = self getAttachTagName(i);
			self Detach(model);
		}
		self.hatModel = hatModel;
		for(i = 0; i < attachedmodels.size; i++)
		{
			self Attach(attachedmodels[i]);
		}
		self SetModel(normalmodel);
		if(!self.missingLegs)
		{
			self setPhysParams(15, 0, 72);
		}
		else
		{
			self setPhysParams(15, 0, 24);
			self AllowPitchAngle(1);
		}
		self.health = health;
		self.meleeDamage = saved_meleedamage;
		self.no_gib = 0;
	}
	self zombie_utility::zombie_eye_glow();
	if(IsActor(self))
	{
		self clientfield::set("fun_size", 0);
	}
	self notify("unshrink");
	self.shrinked = 0;
	self.shrinkattacker = undefined;
	self.kill_on_wine_coccon = undefined;
}

/*
	Name: zombie_gib_on_shrink_ray
	Namespace: zm_weap_shrink_ray
	Checksum: 0x3608522C
	Offset: 0x1640
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function zombie_gib_on_shrink_ray()
{
	if(isdefined(self GetLinkedEnt()))
	{
		return 1;
	}
	if(isdefined(self.sliding) && self.sliding)
	{
		return 1;
	}
	if(isdefined(self.in_the_ceiling) && self.in_the_ceiling)
	{
		return 1;
	}
	return 0;
}

/*
	Name: play_ambient_vox
	Namespace: zm_weap_shrink_ray
	Checksum: 0xF402627F
	Offset: 0x16B0
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function play_ambient_vox()
{
	self endon("unshrink");
	self endon("stepped_on");
	self endon("kicked");
	self endon("death");
	wait(RandomFloatRange(0.2, 0.5));
	while(1)
	{
		self playsound("zmb_mini_ambient");
		wait(RandomFloatRange(1, 2.25));
	}
}

/*
	Name: play_shrink_fx
	Namespace: zm_weap_shrink_ray
	Checksum: 0x4FD1895A
	Offset: 0x1758
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function play_shrink_fx(fxName, jointname, offset)
{
	PlayFXOnTag(level._effect[fxName], self, "tag_origin");
}

/*
	Name: play_shrink_sound
	Namespace: zm_weap_shrink_ray
	Checksum: 0x1C90F728
	Offset: 0x17A8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function play_shrink_sound(alias)
{
	self endon("death");
	wait(RandomFloat(0.5));
	self zm_utility::play_sound_on_ent(alias);
}

/*
	Name: watch_for_kicked
	Namespace: zm_weap_shrink_ray
	Checksum: 0xC2FA3375
	Offset: 0x17F8
	Size: 0x2DF
	Parameters: 0
	Flags: None
*/
function watch_for_kicked()
{
	self endon("death");
	self endon("unshrink");
	self.shrinktrigger = spawn("trigger_radius", self.origin, 0, 30, 24);
	self.shrinktrigger setHintString("");
	self.shrinktrigger setcursorhint("HINT_NOICON");
	self.shrinktrigger EnableLinkTo();
	self.shrinktrigger LinkTo(self);
	self.shrinktrigger thread function_2c318bd(self);
	self.shrinktrigger endon("death");
	while(1)
	{
		self.shrinktrigger waittill("trigger", who);
		if(!isPlayer(who))
		{
			continue;
		}
		if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
		{
			continue;
		}
		if(isdefined(self.magic_bullet_shield) && self.magic_bullet_shield)
		{
			continue;
		}
		movement = who GetNormalizedMovement();
		if(length(movement) < 0.1)
		{
			continue;
		}
		toEnemy = self.origin - who.origin;
		toEnemy = (toEnemy[0], toEnemy[1], 0);
		toEnemy = VectorNormalize(toEnemy);
		forward_view_angles = AnglesToForward(who.angles);
		dotfacing = VectorDot(forward_view_angles, toEnemy);
		if(dotfacing > 0.5 && movement[0] > 0)
		{
			self notify("kicked");
			who notify("hash_49423c6f");
			self kicked_death(who);
		}
		else
		{
			self notify("stepped_on");
			self shrink_death(who);
		}
	}
}

/*
	Name: function_2c318bd
	Namespace: zm_weap_shrink_ray
	Checksum: 0x6E64FE79
	Offset: 0x1AE0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_2c318bd(e_watched)
{
	self endon("death");
	e_watched waittill("death");
	self delete();
}

/*
	Name: watch_for_death
	Namespace: zm_weap_shrink_ray
	Checksum: 0x73DB3762
	Offset: 0x1B28
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function watch_for_death()
{
	self endon("unshrink");
	self endon("stepped_on");
	self endon("kicked");
	self waittill("death");
	self shrink_death();
}

/*
	Name: function_12c1fddf
	Namespace: zm_weap_shrink_ray
	Checksum: 0x19F2988A
	Offset: 0x1B80
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_12c1fddf(v_launch)
{
	if(!isdefined(level.var_6d0abb4c))
	{
		level.var_6d0abb4c = 0;
	}
	if(level.var_6d0abb4c < 5)
	{
		level.var_6d0abb4c++;
		self LaunchRagdoll(v_launch);
		wait(3);
		level.var_6d0abb4c--;
	}
}

/*
	Name: kicked_death
	Namespace: zm_weap_shrink_ray
	Checksum: 0x5C097801
	Offset: 0x1BF0
	Size: 0x28B
	Parameters: 1
	Flags: None
*/
function kicked_death(killer)
{
	if(level flag::get("world_is_paused"))
	{
		self SetIgnorePauseWorld(1);
	}
	self thread kicked_sound();
	kickAngles = killer.angles;
	kickAngles = kickAngles + (RandomFloatRange(-30, -20), RandomFloatRange(-5, 5), 0);
	launchDir = AnglesToForward(kickAngles);
	if(killer issprinting())
	{
		launchForce = RandomFloatRange(350, 400);
	}
	else
	{
		vel = killer GetVelocity();
		speed = length(vel);
		scale = math::clamp(speed / 190, 0.1, 1);
		launchForce = RandomFloatRange(200 * scale, 250 * scale);
	}
	self StartRagdoll();
	self thread function_12c1fddf(launchDir * launchForce);
	util::wait_network_frame();
	killer thread zm_audio::create_and_play_dialog("kill", "shrunken");
	self DoDamage(self.health + 666, self.origin, killer);
	if(isdefined(self.shrinktrigger))
	{
		self.shrinktrigger delete();
	}
}

/*
	Name: kicked_sound
	Namespace: zm_weap_shrink_ray
	Checksum: 0x35555096
	Offset: 0x1E88
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function kicked_sound()
{
	if(!isdefined(level._num_kicked_vox))
	{
		level thread kicked_vox_network_choke();
	}
	if(level._num_kicked_vox > 3)
	{
		return;
	}
	level._num_kicked_vox++;
	playsoundatposition("zmb_mini_kicked", self.origin);
}

/*
	Name: shrink_death
	Namespace: zm_weap_shrink_ray
	Checksum: 0xF1818AA6
	Offset: 0x1EF8
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function shrink_death(killer)
{
	playsoundatposition("zmb_mini_squashed", self.origin);
	if(level flag::get("world_is_paused"))
	{
		self SetIgnorePauseWorld(1);
	}
	playFX(level._effect["shrink_ray_stepped_on_no_gore"], self.origin);
	self thread zombie_utility::zombie_eye_glow_stop();
	util::wait_network_frame();
	self Hide();
	self DoDamage(self.health + 666, self.origin, killer);
	if(isdefined(self.shrinktrigger))
	{
		self.shrinktrigger delete();
	}
}

/*
	Name: shrink_ray_get_enemies_in_range
	Namespace: zm_weap_shrink_ray
	Checksum: 0x9DEE8EFA
	Offset: 0x2030
	Size: 0x585
	Parameters: 2
	Flags: None
*/
function shrink_ray_get_enemies_in_range(upgraded, shrinkable_objects)
{
	range = 480;
	radius = 60;
	if(upgraded)
	{
		range = 1200;
		radius = 84;
	}
	hitzombies = [];
	view_pos = self GetWeaponMuzzlePoint();
	test_list = undefined;
	if(shrinkable_objects)
	{
		test_list = level._shrinkable_objects;
		range = range * 5;
	}
	else
	{
		test_list = GetAISpeciesArray(level.zombie_team, "all");
	}
	zombies = util::get_array_of_closest(view_pos, test_list, undefined, undefined, range * 1.1);
	if(!isdefined(zombies))
	{
		return;
	}
	range_squared = range * range;
	radius_squared = radius * radius;
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale(forward_view_angles, range);
	/#
		if(2 == GetDvarInt("Dev Block strings are not supported"))
		{
			near_circle_pos = view_pos + VectorScale(forward_view_angles, 2);
			circle(near_circle_pos, radius, (1, 0, 0), 0, 0, 100);
			line(near_circle_pos, end_pos, (0, 0, 1), 1, 0, 100);
			circle(end_pos, radius, (1, 0, 0), 0, 0, 100);
		}
	#/
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || (isai(zombies[i]) && !isalive(zombies[i])))
		{
			continue;
		}
		if(isdefined(zombies[i].shrinked) && zombies[i].shrinked)
		{
			zombies[i] shrink_ray_debug_print("shrinked", (1, 0, 0));
			continue;
		}
		if(isdefined(zombies[i].no_shrink) && zombies[i].no_shrink)
		{
			zombies[i] shrink_ray_debug_print("no_shrink", (1, 0, 0));
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(view_pos, test_origin);
		if(test_range_squared > range_squared)
		{
			zombies[i] shrink_ray_debug_print("range", (1, 0, 0));
			break;
		}
		normal = VectorNormalize(test_origin - view_pos);
		dot = VectorDot(forward_view_angles, normal);
		if(0 > dot)
		{
			zombies[i] shrink_ray_debug_print("dot", (1, 0, 0));
			continue;
		}
		radial_origin = PointOnSegmentNearestToPoint(view_pos, end_pos, test_origin);
		if(DistanceSquared(test_origin, radial_origin) > radius_squared)
		{
			zombies[i] shrink_ray_debug_print("cylinder", (1, 0, 0));
			continue;
		}
		if(0 == zombies[i] damageConeTrace(view_pos, self))
		{
			zombies[i] shrink_ray_debug_print("cone", (1, 0, 0));
			continue;
		}
		hitzombies[hitzombies.size] = zombies[i];
	}
	return hitzombies;
}

/*
	Name: shrink_ray_debug_print
	Namespace: zm_weap_shrink_ray
	Checksum: 0xA6F3C4C6
	Offset: 0x25C0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function shrink_ray_debug_print(msg, color)
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + VectorScale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: zomibe_shrunk_board_tear_down
	Namespace: zm_weap_shrink_ray
	Checksum: 0x71ACA6D8
	Offset: 0x2658
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function zomibe_shrunk_board_tear_down()
{
	self endon("death");
	self endon("unshrink");
	while(1)
	{
		taunt_anim = Array::random(level._zombie_board_taunt["zombie"]);
	}
}

