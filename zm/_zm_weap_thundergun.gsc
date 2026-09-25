#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_thundergun;

/*
	Name: __init__sytem__
	Namespace: zm_weap_thundergun
	Checksum: 0xC9E49F4A
	Offset: 0x560
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_thundergun", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_thundergun
	Checksum: 0x7318F235
	Offset: 0x5A8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.weaponZMThunderGun = GetWeapon("thundergun");
	level.weaponZMThunderGunUpgraded = GetWeapon("thundergun_upgraded");
}

/*
	Name: __main__
	Namespace: zm_weap_thundergun
	Checksum: 0x10BD38FB
	Offset: 0x5F8
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level._effect["thundergun_knockdown_ground"] = "zombie/fx_thundergun_knockback_ground";
	level._effect["thundergun_smoke_cloud"] = "zombie/fx_thundergun_smoke_cloud";
	zombie_utility::set_zombie_var("thundergun_cylinder_radius", 180);
	zombie_utility::set_zombie_var("thundergun_fling_range", 480);
	zombie_utility::set_zombie_var("thundergun_gib_range", 900);
	zombie_utility::set_zombie_var("thundergun_gib_damage", 75);
	zombie_utility::set_zombie_var("thundergun_knockdown_range", 1200);
	zombie_utility::set_zombie_var("thundergun_knockdown_damage", 15);
	level.thundergun_gib_refs = [];
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "guts";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "right_arm";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "left_arm";
	level.basic_zombie_thundergun_knockdown = &zombie_knockdown;
	if(!isdefined(level.override_thundergun_damage_func))
	{
		level.override_thundergun_damage_func = &override_thundergun_damage_func;
	}
	/#
		level thread thundergun_devgui_dvar_think();
	#/
	callback::on_connect(&thundergun_on_player_connect);
}

/*
	Name: thundergun_devgui_dvar_think
	Namespace: zm_weap_thundergun
	Checksum: 0x5815D916
	Offset: 0x7C8
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function thundergun_devgui_dvar_think()
{
	/#
		if(!zm_weapons::is_weapon_included(level.weaponZMThunderGun))
		{
			return;
		}
		SetDvar("Dev Block strings are not supported", level.zombie_vars["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.zombie_vars["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.zombie_vars["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.zombie_vars["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.zombie_vars["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.zombie_vars["Dev Block strings are not supported"]);
		for(;;)
		{
			level.zombie_vars["Dev Block strings are not supported"] = GetDvarInt("Dev Block strings are not supported");
			level.zombie_vars["Dev Block strings are not supported"] = GetDvarInt("Dev Block strings are not supported");
			level.zombie_vars["Dev Block strings are not supported"] = GetDvarInt("Dev Block strings are not supported");
			level.zombie_vars["Dev Block strings are not supported"] = GetDvarInt("Dev Block strings are not supported");
			level.zombie_vars["Dev Block strings are not supported"] = GetDvarInt("Dev Block strings are not supported");
			level.zombie_vars["Dev Block strings are not supported"] = GetDvarInt("Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: thundergun_on_player_connect
	Namespace: zm_weap_thundergun
	Checksum: 0x13D97926
	Offset: 0x9F0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function thundergun_on_player_connect()
{
	self thread wait_for_thundergun_fired();
}

/*
	Name: wait_for_thundergun_fired
	Namespace: zm_weap_thundergun
	Checksum: 0x5AC9EEBB
	Offset: 0xA18
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function wait_for_thundergun_fired()
{
	self endon("disconnect");
	self waittill("spawned_player");
	for(;;)
	{
		self waittill("weapon_fired");
		currentWeapon = self GetCurrentWeapon();
		if(currentWeapon == level.weaponZMThunderGun || currentWeapon == level.weaponZMThunderGunUpgraded)
		{
			self thread thundergun_fired();
			view_pos = self GetTagOrigin("tag_flash") - self GetPlayerViewHeight();
			view_angles = self GetTagAngles("tag_flash");
			playFX(level._effect["thundergun_smoke_cloud"], view_pos, AnglesToForward(view_angles), anglesToUp(view_angles));
		}
	}
}

/*
	Name: thundergun_network_choke
	Namespace: zm_weap_thundergun
	Checksum: 0x5A601EA3
	Offset: 0xB60
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function thundergun_network_choke()
{
	level.thundergun_network_choke_count++;
	if(!level.thundergun_network_choke_count % 10)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}

/*
	Name: thundergun_fired
	Namespace: zm_weap_thundergun
	Checksum: 0xC864925D
	Offset: 0xBB8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function thundergun_fired()
{
	PhysicsExplosionCylinder(self.origin, 600, 240, 1);
	self thread thundergun_affect_ais();
}

/*
	Name: thundergun_affect_ais
	Namespace: zm_weap_thundergun
	Checksum: 0xA16EBDB3
	Offset: 0xC08
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function thundergun_affect_ais()
{
	if(!isdefined(level.thundergun_knockdown_enemies))
	{
		level.thundergun_knockdown_enemies = [];
		level.thundergun_knockdown_gib = [];
		level.thundergun_fling_enemies = [];
		level.thundergun_fling_vecs = [];
	}
	self thundergun_get_enemies_in_range();
	level.thundergun_network_choke_count = 0;
	for(i = 0; i < level.thundergun_fling_enemies.size; i++)
	{
		level.thundergun_fling_enemies[i] thread thundergun_fling_zombie(self, level.thundergun_fling_vecs[i], i);
	}
	for(i = 0; i < level.thundergun_knockdown_enemies.size; i++)
	{
		level.thundergun_knockdown_enemies[i] thread thundergun_knockdown_zombie(self, level.thundergun_knockdown_gib[i]);
	}
	level.thundergun_knockdown_enemies = [];
	level.thundergun_knockdown_gib = [];
	level.thundergun_fling_enemies = [];
	level.thundergun_fling_vecs = [];
}

/*
	Name: thundergun_get_enemies_in_range
	Namespace: zm_weap_thundergun
	Checksum: 0xA55FF913
	Offset: 0xD58
	Size: 0x6AD
	Parameters: 0
	Flags: None
*/
function thundergun_get_enemies_in_range()
{
	view_pos = self GetWeaponMuzzlePoint();
	zombies = Array::get_all_closest(view_pos, GetAITeamArray(level.zombie_team), undefined, undefined, level.zombie_vars["thundergun_knockdown_range"]);
	if(!isdefined(zombies))
	{
		return;
	}
	knockdown_range_squared = level.zombie_vars["thundergun_knockdown_range"] * level.zombie_vars["thundergun_knockdown_range"];
	gib_range_squared = level.zombie_vars["thundergun_gib_range"] * level.zombie_vars["thundergun_gib_range"];
	fling_range_squared = level.zombie_vars["thundergun_fling_range"] * level.zombie_vars["thundergun_fling_range"];
	cylinder_radius_squared = level.zombie_vars["thundergun_cylinder_radius"] * level.zombie_vars["thundergun_cylinder_radius"];
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale(forward_view_angles, level.zombie_vars["thundergun_knockdown_range"]);
	/#
		if(2 == GetDvarInt("Dev Block strings are not supported"))
		{
			near_circle_pos = view_pos + VectorScale(forward_view_angles, 2);
			circle(near_circle_pos, level.zombie_vars["Dev Block strings are not supported"], (1, 0, 0), 0, 0, 100);
			line(near_circle_pos, end_pos, (0, 0, 1), 1, 0, 100);
			circle(end_pos, level.zombie_vars["Dev Block strings are not supported"], (1, 0, 0), 0, 0, 100);
		}
	#/
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(view_pos, test_origin);
		if(test_range_squared > knockdown_range_squared)
		{
			zombies[i] thundergun_debug_print("range", (1, 0, 0));
			return;
		}
		normal = VectorNormalize(test_origin - view_pos);
		dot = VectorDot(forward_view_angles, normal);
		if(0 > dot)
		{
			zombies[i] thundergun_debug_print("dot", (1, 0, 0));
			continue;
		}
		radial_origin = PointOnSegmentNearestToPoint(view_pos, end_pos, test_origin);
		if(DistanceSquared(test_origin, radial_origin) > cylinder_radius_squared)
		{
			zombies[i] thundergun_debug_print("cylinder", (1, 0, 0));
			continue;
		}
		if(0 == zombies[i] damageConeTrace(view_pos, self))
		{
			zombies[i] thundergun_debug_print("cone", (1, 0, 0));
			continue;
		}
		if(test_range_squared < fling_range_squared)
		{
			level.thundergun_fling_enemies[level.thundergun_fling_enemies.size] = zombies[i];
			dist_mult = fling_range_squared - test_range_squared / fling_range_squared;
			fling_vec = VectorNormalize(test_origin - view_pos);
			if(5000 < test_range_squared)
			{
				fling_vec = fling_vec + VectorNormalize(test_origin - radial_origin);
			}
			fling_vec = (fling_vec[0], fling_vec[1], Abs(fling_vec[2]));
			fling_vec = VectorScale(fling_vec, 100 + 100 * dist_mult);
			level.thundergun_fling_vecs[level.thundergun_fling_vecs.size] = fling_vec;
			zombies[i] thread setup_thundergun_vox(self, 1, 0, 0);
			continue;
		}
		if(test_range_squared < gib_range_squared)
		{
			level.thundergun_knockdown_enemies[level.thundergun_knockdown_enemies.size] = zombies[i];
			level.thundergun_knockdown_gib[level.thundergun_knockdown_gib.size] = 1;
			zombies[i] thread setup_thundergun_vox(self, 0, 1, 0);
			continue;
		}
		level.thundergun_knockdown_enemies[level.thundergun_knockdown_enemies.size] = zombies[i];
		level.thundergun_knockdown_gib[level.thundergun_knockdown_gib.size] = 0;
		zombies[i] thread setup_thundergun_vox(self, 0, 0, 1);
	}
}

/*
	Name: thundergun_debug_print
	Namespace: zm_weap_thundergun
	Checksum: 0xDE4E1733
	Offset: 0x1410
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function thundergun_debug_print(msg, color)
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
	Name: thundergun_fling_zombie
	Namespace: zm_weap_thundergun
	Checksum: 0x84C7BDA
	Offset: 0x14A8
	Size: 0x187
	Parameters: 3
	Flags: None
*/
function thundergun_fling_zombie(player, fling_vec, index)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.thundergun_fling_func))
	{
		self [[self.thundergun_fling_func]](player);
		return;
	}
	self.deathpoints_already_given = 1;
	self DoDamage(self.health + 666, player.origin, player);
	if(self.health <= 0)
	{
		if(isdefined(player) && isdefined(level.hero_power_update))
		{
			level thread [[level.hero_power_update]](player, self);
		}
		points = 10;
		if(!index)
		{
			points = zm_score::get_zombie_death_player_points();
		}
		else if(1 == index)
		{
			points = 30;
		}
		player zm_score::player_add_points("thundergun_fling", points);
		self StartRagdoll();
		self LaunchRagdoll(fling_vec);
		self.thundergun_death = 1;
	}
}

/*
	Name: zombie_knockdown
	Namespace: zm_weap_thundergun
	Checksum: 0x1D7B971F
	Offset: 0x1638
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function zombie_knockdown(player, gib)
{
	if(gib && !self.gibbed)
	{
		self.a.gib_ref = Array::random(level.thundergun_gib_refs);
		self thread zombie_death::do_gib();
	}
	if(isdefined(level.override_thundergun_damage_func))
	{
		self [[level.override_thundergun_damage_func]](player, gib);
	}
	else
	{
		damage = level.zombie_vars["thundergun_knockdown_damage"];
		self playsound("fly_thundergun_forcehit");
		self.thundergun_handle_pain_notetracks = &handle_thundergun_pain_notetracks;
		self DoDamage(damage, player.origin, player);
		self animcustom(&playThundergunPainAnim);
	}
}

/*
	Name: playThundergunPainAnim
	Namespace: zm_weap_thundergun
	Checksum: 0xDB8B1444
	Offset: 0x1770
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function playThundergunPainAnim()
{
	self notify("end_play_thundergun_pain_anim");
	self endon("killanimscript");
	self endon("death");
	self endon("end_play_thundergun_pain_anim");
	if(isdefined(self.marked_for_death) && self.marked_for_death)
	{
		return;
	}
	if(self.damageyaw <= -135 || self.damageyaw >= 135)
	{
		if(self.missingLegs)
		{
			fallAnim = "zm_thundergun_fall_front_crawl";
		}
		else
		{
			fallAnim = "zm_thundergun_fall_front";
		}
		getupAnim = "zm_thundergun_getup_belly_early";
	}
	else if(self.damageyaw > -135 && self.damageyaw < -45)
	{
		fallAnim = "zm_thundergun_fall_left";
		getupAnim = "zm_thundergun_getup_belly_early";
	}
	else if(self.damageyaw > 45 && self.damageyaw < 135)
	{
		fallAnim = "zm_thundergun_fall_right";
		getupAnim = "zm_thundergun_getup_belly_early";
	}
	else
	{
		fallAnim = "zm_thundergun_fall_back";
		if(RandomInt(100) < 50)
		{
			getupAnim = "zm_thundergun_getup_back_early";
		}
		else
		{
			getupAnim = "zm_thundergun_getup_back_late";
		}
	}
	self SetAnimStateFromASD(fallAnim);
	self zombie_shared::DoNoteTracks("thundergun_fall_anim", self.thundergun_handle_pain_notetracks);
	if(!isdefined(self) || !isalive(self) || self.missingLegs || (isdefined(self.marked_for_death) && self.marked_for_death))
	{
		return;
	}
	self SetAnimStateFromASD(getupAnim);
	self zombie_shared::DoNoteTracks("thundergun_getup_anim");
}

/*
	Name: thundergun_knockdown_zombie
	Namespace: zm_weap_thundergun
	Checksum: 0x1D7E63D
	Offset: 0x19B8
	Size: 0x87
	Parameters: 2
	Flags: None
*/
function thundergun_knockdown_zombie(player, gib)
{
	self endon("death");
	playsoundatposition("wpn_thundergun_proj_impact", self.origin);
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.thundergun_knockdown_func))
	{
		self [[self.thundergun_knockdown_func]](player, gib);
	}
}

/*
	Name: handle_thundergun_pain_notetracks
	Namespace: zm_weap_thundergun
	Checksum: 0x630360B6
	Offset: 0x1A48
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function handle_thundergun_pain_notetracks(note)
{
	if(note == "zombie_knockdown_ground_impact")
	{
		playFX(level._effect["thundergun_knockdown_ground"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
		self playsound("fly_thundergun_forcehit");
	}
}

/*
	Name: is_thundergun_damage
	Namespace: zm_weap_thundergun
	Checksum: 0x568EF9EE
	Offset: 0x1AE8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function is_thundergun_damage()
{
	return self.damageWeapon == level.weaponZMThunderGun || self.damageWeapon == level.weaponZMThunderGunUpgraded && (self.damageMod != "MOD_GRENADE" && self.damageMod != "MOD_GRENADE_SPLASH");
}

/*
	Name: enemy_killed_by_thundergun
	Namespace: zm_weap_thundergun
	Checksum: 0x170155F4
	Offset: 0x1B40
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function enemy_killed_by_thundergun()
{
	return isdefined(self.thundergun_death) && self.thundergun_death;
}

/*
	Name: thundergun_sound_thread
	Namespace: zm_weap_thundergun
	Checksum: 0x92F80CA3
	Offset: 0x1B60
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function thundergun_sound_thread()
{
	self endon("disconnect");
	self waittill("spawned_player");
	for(;;)
	{
		result = self util::waittill_any_return("grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback", "disconnect");
		if(!isdefined(result))
		{
			continue;
		}
		if(result == "weapon_change" || result == "grenade_fire" && self GetCurrentWeapon() == level.weaponZMThunderGun)
		{
			self PlayLoopSound("tesla_idle", 0.25);
			continue;
		}
		self notify("weap_away");
		self StopLoopSound(0.25);
	}
}

/*
	Name: setup_thundergun_vox
	Namespace: zm_weap_thundergun
	Checksum: 0xE3CC686E
	Offset: 0x1C80
	Size: 0xD3
	Parameters: 4
	Flags: None
*/
function setup_thundergun_vox(player, fling, gib, KNOCKDOWN)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(!fling && (gib || KNOCKDOWN))
	{
	}
	if(fling)
	{
		if(30 > randomIntRange(1, 100))
		{
			player zm_audio::create_and_play_dialog("kill", "thundergun");
		}
	}
}

/*
	Name: override_thundergun_damage_func
	Namespace: zm_weap_thundergun
	Checksum: 0x958805AE
	Offset: 0x1D60
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function override_thundergun_damage_func(player, gib)
{
	self zombie_utility::setup_zombie_knockdown(player);
}

