#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#namespace vehicle_death;

/*
	Name: __init__sytem__
	Namespace: vehicle_death
	Checksum: 0xA2D3384B
	Offset: 0x450
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_death", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle_death
	Checksum: 0x4CD01A4B
	Offset: 0x490
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	SetDvar("debug_crash_type", -1);
}

/*
	Name: main
	Namespace: vehicle_death
	Checksum: 0xF31DF8C6
	Offset: 0x4C0
	Size: 0x62F
	Parameters: 0
	Flags: None
*/
function main()
{
	self endon("nodeath_thread");
	while(isdefined(self))
	{
		self waittill("death", attacker, damageFromUnderneath, weapon, point, dir);
		if(isdefined(self.death_enter_cb))
		{
			[[self.death_enter_cb]]();
		}
		if(isdefined(self.script_deathflag))
		{
			level flag::set(self.script_deathflag);
		}
		if(!isdefined(self.delete_on_death))
		{
			self thread play_death_audio();
		}
		if(!isdefined(self))
		{
			return;
		}
		self death_cleanup_level_variables();
		if(vehicle::is_corpse(self))
		{
			if(!(isdefined(self.dont_kill_riders) && self.dont_kill_riders))
			{
				self death_cleanup_riders();
			}
			self notify("delete_destructible");
			return;
		}
		self vehicle::lights_off();
		if(isdefined(level.vehicle_death_thread[self.vehicleType]))
		{
			thread [[level.vehicle_death_thread[self.vehicleType]]]();
		}
		if(!isdefined(self.delete_on_death))
		{
			thread death_radius_damage();
		}
		is_aircraft = isdefined(self.vehicleClass) && self.vehicleClass == "plane" || (isdefined(self.vehicleClass) && self.vehicleClass == "helicopter");
		if(!isdefined(self.destructibledef))
		{
			if(!is_aircraft && (!self.vehicleType == "horse" || self.vehicleType == "horse_player" || self.vehicleType == "horse_player_low" || self.vehicleType == "horse_low" || self.vehicleType == "horse_axis") && isdefined(self.deathmodel) && self.deathmodel != "")
			{
				self thread set_death_model(self.deathmodel, self.modelswapdelay);
			}
			if(!isdefined(self.delete_on_death) && (!isdefined(self.mantled) || !self.mantled) && !isdefined(self.nodeathfx))
			{
				thread death_fx();
			}
			if(isdefined(self.delete_on_death))
			{
				wait(0.05);
				if(self.disconnectPathOnStop === 1)
				{
					self vehicle::disconnect_paths();
				}
				if(!(isdefined(self.no_free_on_death) && self.no_free_on_death))
				{
					self freevehicle();
					self.isacorpse = 1;
					wait(0.05);
					if(isdefined(self))
					{
						self notify("death_finished");
						self delete();
					}
				}
				continue;
			}
		}
		thread death_make_badplace(self.vehicleType);
		if(isdefined(level.vehicle_deathnotify) && isdefined(level.vehicle_deathnotify[self.vehicleType]))
		{
			level notify(level.vehicle_deathnotify[self.vehicleType], attacker);
		}
		if(Target_IsTarget(self))
		{
			Target_remove(self);
		}
		if(self.classname == "script_vehicle")
		{
			self thread death_jolt(self.vehicleType);
		}
		if(do_scripted_crash())
		{
			self thread death_update_crash(point, dir);
		}
		if(isdefined(self.turretWeapon) && self.turretWeapon != level.weaponNone)
		{
			self ClearTurretTarget();
		}
		self waittill_crash_done_or_stopped();
		if(isdefined(self))
		{
			while(isdefined(self) && isdefined(self.dontfreeme))
			{
				wait(0.05);
			}
			self notify("stop_looping_death_fx");
			self notify("death_finished");
			wait(0.05);
			if(isdefined(self))
			{
				if(vehicle::is_corpse(self))
				{
					continue;
				}
				if(!isdefined(self))
				{
					continue;
				}
				occupants = self GetVehOccupants();
				if(isdefined(occupants) && occupants.size)
				{
					for(i = 0; i < occupants.size; i++)
					{
						self usevehicle(occupants[i], 0);
					}
				}
				else if(!(isdefined(self.no_free_on_death) && self.no_free_on_death))
				{
					self freevehicle();
					self.isacorpse = 1;
				}
				if(self.modeldummyon)
				{
					self Hide();
				}
			}
		}
	}
}

/*
	Name: do_scripted_crash
	Namespace: vehicle_death
	Checksum: 0x3E34D393
	Offset: 0xAF8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function do_scripted_crash()
{
	return !isdefined(self.do_scripted_crash) || (isdefined(self.do_scripted_crash) && self.do_scripted_crash);
}

/*
	Name: play_death_audio
	Namespace: vehicle_death
	Checksum: 0x41E563D8
	Offset: 0xB28
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function play_death_audio()
{
	if(isdefined(self) && (isdefined(self.vehicleClass) && self.vehicleClass == "helicopter"))
	{
		if(!isdefined(self.death_counter))
		{
			self.death_counter = 0;
		}
		if(self.death_counter == 0)
		{
			self.death_counter++;
			self playsound("exp_veh_helicopter_hit");
		}
	}
}

/*
	Name: play_spinning_plane_sound
	Namespace: vehicle_death
	Checksum: 0x60D9FA49
	Offset: 0xBB0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function play_spinning_plane_sound()
{
	self PlayLoopSound("veh_drone_spin", 0.05);
	level util::waittill_any("crash_move_done", "death");
	self StopLoopSound(0.02);
}

/*
	Name: set_death_model
	Namespace: vehicle_death
	Checksum: 0xDCA0F9B2
	Offset: 0xC30
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function set_death_model(sModel, fDelay)
{
	if(!isdefined(sModel))
	{
		return;
	}
	if(isdefined(fDelay) && fDelay > 0)
	{
		wait(fDelay);
	}
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.deathmodel_attached))
	{
		return;
	}
	eModel = vehicle::get_dummy();
	if(!isdefined(eModel))
	{
		return;
	}
	if(!isdefined(eModel.death_anim) && isdefined(eModel.animTree))
	{
		eModel ClearAnim(%root, 0);
	}
	if(sModel != self.vehmodel)
	{
		eModel SetModel(sModel);
		eModel SetEnemyModel(sModel);
	}
}

/*
	Name: aircraft_crash
	Namespace: vehicle_death
	Checksum: 0x1CFBC55
	Offset: 0xD48
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function aircraft_crash(point, dir)
{
	self.crashing = 1;
	if(isdefined(self.unloading))
	{
		while(isdefined(self.unloading))
		{
			wait(0.05);
		}
	}
	if(!isdefined(self))
	{
		return;
	}
	self thread aircraft_crash_move(point, dir);
	self thread play_spinning_plane_sound();
}

/*
	Name: helicopter_crash
	Namespace: vehicle_death
	Checksum: 0xBE09BF78
	Offset: 0xDD8
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function helicopter_crash(point, dir)
{
	self.crashing = 1;
	self thread play_crashing_loop();
	if(isdefined(self.unloading))
	{
		while(isdefined(self.unloading))
		{
			wait(0.05);
		}
	}
	if(!isdefined(self))
	{
		return;
	}
	self thread helicopter_crash_movement(point, dir);
}

/*
	Name: helicopter_crash_movement
	Namespace: vehicle_death
	Checksum: 0x93541DD2
	Offset: 0xE60
	Size: 0x4B5
	Parameters: 2
	Flags: None
*/
function helicopter_crash_movement(point, dir)
{
	self endon("crash_done");
	self CancelAIMove();
	self ClearVehGoalPos();
	if(isdefined(level.heli_crash_smoke_trail_fx))
	{
		if(IsSubStr(self.vehicleType, "v78"))
		{
			PlayFXOnTag(level.heli_crash_smoke_trail_fx, self, "tag_origin");
		}
		else if(self.vehicleType == "drone_firescout_axis" || self.vehicleType == "drone_firescout_isi")
		{
			PlayFXOnTag(level.heli_crash_smoke_trail_fx, self, "tag_main_rotor");
		}
		else
		{
			PlayFXOnTag(level.heli_crash_smoke_trail_fx, self, "tag_engine_left");
		}
	}
	crash_zones = struct::get_array("heli_crash_zone", "targetname");
	if(crash_zones.size > 0)
	{
		best_dist = 99999;
		best_idx = -1;
		if(isdefined(self.a_crash_zones))
		{
			crash_zones = self.a_crash_zones;
		}
		for(i = 0; i < crash_zones.size; i++)
		{
			vec_to_crash_zone = crash_zones[i].origin - self.origin;
			vec_to_crash_zone = (vec_to_crash_zone[0], vec_to_crash_zone[1], 0);
			dist = length(vec_to_crash_zone);
			vec_to_crash_zone = vec_to_crash_zone / dist;
			veloctiy_scale = VectorDot(self.velocity, vec_to_crash_zone) * -1;
			dist = dist + 500 * veloctiy_scale;
			if(dist < best_dist)
			{
				best_dist = dist;
				best_idx = i;
			}
		}
		if(best_idx != -1)
		{
			self.crash_zone = crash_zones[best_idx];
			self thread helicopter_crash_zone_accel(dir);
		}
	}
	else if(isdefined(dir))
	{
		dir = VectorNormalize(dir);
	}
	else
	{
		dir = (1, 0, 0);
	}
	side_dir = VectorCross(dir, (0, 0, 1));
	side_dir_mag = RandomFloatRange(-500, 500);
	side_dir_mag = side_dir_mag + math::sign(side_dir_mag) * 60;
	side_dir = side_dir * side_dir_mag;
	side_dir = side_dir + VectorScale((0, 0, 1), 150);
	self SetPhysAcceleration((randomIntRange(-500, 500), randomIntRange(-500, 500), -1000));
	self SetVehVelocity(self.velocity + side_dir);
	self thread helicopter_crash_accel();
	if(isdefined(point))
	{
		self thread helicopter_crash_rotation(point, dir);
	}
	else
	{
		self thread helicopter_crash_rotation(self.origin, dir);
	}
	self thread crash_collision_test();
	wait(15);
	if(isdefined(self))
	{
		self notify("crash_done");
	}
}

/*
	Name: helicopter_crash_accel
	Namespace: vehicle_death
	Checksum: 0xE91642B0
	Offset: 0x1320
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function helicopter_crash_accel()
{
	self endon("crash_done");
	self endon("crash_move_done");
	self endon("death");
	if(!isdefined(self.crash_accel))
	{
		self.crash_accel = RandomFloatRange(50, 80);
	}
	while(isdefined(self))
	{
		self SetVehVelocity(self.velocity + anglesToUp(self.angles) * self.crash_accel);
		wait(0.1);
	}
}

/*
	Name: helicopter_crash_rotation
	Namespace: vehicle_death
	Checksum: 0x40006202
	Offset: 0x13D0
	Size: 0x387
	Parameters: 2
	Flags: None
*/
function helicopter_crash_rotation(point, dir)
{
	self endon("crash_done");
	self endon("crash_move_done");
	self endon("death");
	start_angles = self.angles;
	start_angles = (start_angles[0] + 10, start_angles[1], start_angles[2]);
	start_angles = (start_angles[0], start_angles[1], start_angles[2] + 10);
	ang_vel = self GetAngularVelocity();
	ang_vel = (0, ang_vel[1] * RandomFloatRange(2, 3), 0);
	self SetAngularVelocity(ang_vel);
	point_2d = (point[0], point[1], self.origin[2]);
	torque = (0, randomIntRange(90, 180), 0);
	if(self GetAngularVelocity()[1] < 0)
	{
		torque = torque * -1;
	}
	if(Distance(self.origin, point_2d) > 5)
	{
		local_hit_point = point_2d - self.origin;
		dir_2d = (dir[0], dir[1], 0);
		if(length(dir_2d) > 0.01)
		{
			dir_2d = VectorNormalize(dir_2d);
			torque = VectorCross(VectorNormalize(local_hit_point), dir);
			torque = (0, 0, torque[2]);
			torque = VectorNormalize(torque);
			torque = (0, torque[2] * 180, 0);
		}
	}
	while(1)
	{
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + torque * 0.05;
		if(ang_vel[1] < 360 * -1)
		{
			ang_vel = (ang_vel[0], 360 * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > 360)
		{
			ang_vel = (ang_vel[0], 360, ang_vel[2]);
		}
		self SetAngularVelocity(ang_vel);
		wait(0.05);
	}
}

/*
	Name: helicopter_crash_zone_accel
	Namespace: vehicle_death
	Checksum: 0x31B6E14B
	Offset: 0x1760
	Size: 0x63F
	Parameters: 1
	Flags: None
*/
function helicopter_crash_zone_accel(dir)
{
	self endon("crash_done");
	self endon("crash_move_done");
	torque = (0, randomIntRange(90, 150), 0);
	ang_vel = self GetAngularVelocity();
	torque = torque * math::sign(ang_vel[1]);
	/#
		if(isdefined(self.crash_zone.height))
		{
			self.crash_zone.height = 0;
		}
	#/
	if(Abs(self.angles[2]) < 3)
	{
		self.angles = (self.angles[0], self.angles[1], randomIntRange(3, 6) * math::sign(self.angles[2]));
	}
	is_vtol = IsSubStr(self.vehicleType, "v78");
	if(is_vtol)
	{
		torque = torque * 0.3;
	}
	while(isdefined(self))
	{
		/#
			Assert(isdefined(self.crash_zone));
		#/
		dist = Distance2D(self.origin, self.crash_zone.origin);
		if(dist < self.crash_zone.radius)
		{
			self SetPhysAcceleration(VectorScale((0, 0, -1), 400));
			/#
				circle(self.crash_zone.origin + (0, 0, self.crash_zone.height), self.crash_zone.radius, (0, 1, 0), 0, 2000);
			#/
			self.crash_accel = 0;
		}
		else
		{
			self SetPhysAcceleration(VectorScale((0, 0, -1), 50));
			/#
				circle(self.crash_zone.origin + (0, 0, self.crash_zone.height), self.crash_zone.radius, (1, 0, 0), 0, 2);
			#/
		}
		self.crash_vel = self.crash_zone.origin - self.origin;
		self.crash_vel = (self.crash_vel[0], self.crash_vel[1], 0);
		self.crash_vel = VectorNormalize(self.crash_vel);
		self.crash_vel = self.crash_vel * self GetMaxSpeed() * 0.5;
		if(is_vtol)
		{
			self.crash_vel = self.crash_vel * 0.5;
		}
		crash_vel_forward = anglesToUp(self.angles) * self GetMaxSpeed() * 2;
		crash_vel_forward = (crash_vel_forward[0], crash_vel_forward[1], 0);
		self.crash_vel = self.crash_vel + crash_vel_forward;
		vel_x = DiffTrack(self.crash_vel[0], self.velocity[0], 1, 0.1);
		vel_y = DiffTrack(self.crash_vel[1], self.velocity[1], 1, 0.1);
		vel_z = DiffTrack(self.crash_vel[2], self.velocity[2], 1, 0.1);
		self SetVehVelocity((vel_x, vel_y, vel_z));
		ang_vel = self GetAngularVelocity();
		ang_vel = (0, ang_vel[1], 0);
		ang_vel = ang_vel + torque * 0.1;
		max_angluar_vel = 200;
		if(is_vtol)
		{
			max_angluar_vel = 100;
		}
		if(ang_vel[1] < max_angluar_vel * -1)
		{
			ang_vel = (ang_vel[0], max_angluar_vel * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > max_angluar_vel)
		{
			ang_vel = (ang_vel[0], max_angluar_vel, ang_vel[2]);
		}
		self SetAngularVelocity(ang_vel);
		wait(0.1);
	}
}

/*
	Name: helicopter_collision
	Namespace: vehicle_death
	Checksum: 0x4790C3D
	Offset: 0x1DA8
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function helicopter_collision()
{
	self endon("crash_done");
	while(1)
	{
		self waittill("veh_collision", velocity, normal);
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity(ang_vel);
		if(normal[2] < 0.7)
		{
			self SetVehVelocity(self.velocity + normal * 70);
		}
		else
		{
			self notify("crash_done");
		}
	}
}

/*
	Name: play_crashing_loop
	Namespace: vehicle_death
	Checksum: 0x34BD476F
	Offset: 0x1E90
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function play_crashing_loop()
{
	ent = spawn("script_origin", self.origin);
	ent LinkTo(self);
	ent PlayLoopSound("exp_heli_crash_loop");
	self util::waittill_any("death", "snd_impact");
	ent delete();
}

/*
	Name: helicopter_explode
	Namespace: vehicle_death
	Checksum: 0x360CAF15
	Offset: 0x1F48
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function helicopter_explode(delete_me)
{
	self endon("death");
	self vehicle::do_death_fx();
	if(isdefined(delete_me) && delete_me == 1)
	{
		self delete();
	}
	self thread set_death_model(self.deathmodel, self.modelswapdelay);
}

/*
	Name: aircraft_crash_move
	Namespace: vehicle_death
	Checksum: 0xA1CBE6CD
	Offset: 0x1FD8
	Size: 0x5A7
	Parameters: 2
	Flags: None
*/
function aircraft_crash_move(point, dir)
{
	self endon("crash_move_done");
	self endon("death");
	self thread crash_collision_test();
	self ClearVehGoalPos();
	self CancelAIMove();
	self SetRotorSpeed(0.2);
	if(isdefined(self) && isdefined(self.vehicleType))
	{
		b_custom_deathmodel_setup = 1;
		switch(self.vehicleType)
		{
			case default:
			{
				b_custom_deathmodel_setup = 0;
				break;
			}
		}
		if(b_custom_deathmodel_setup)
		{
			self.deathmodel_attached = 1;
		}
	}
	ang_vel = self GetAngularVelocity();
	ang_vel = (0, 0, 0);
	self SetAngularVelocity(ang_vel);
	nodes = self GetVehicleAvoidanceNodes(10000);
	closest_index = -1;
	best_dist = 999999;
	if(nodes.size > 0)
	{
		for(i = 0; i < nodes.size; i++)
		{
			dir = VectorNormalize(nodes[i] - self.origin);
			FORWARD = AnglesToForward(self.angles);
			dot = VectorDot(dir, FORWARD);
			if(dot < 0)
			{
				continue;
			}
			dist = Distance2D(self.origin, nodes[i]);
			if(dist < best_dist)
			{
				best_dist = dist;
				closest_index = i;
			}
		}
		if(closest_index >= 0)
		{
			o = nodes[closest_index];
			o = (o[0], o[1], self.origin[2]);
			dir = VectorNormalize(o - self.origin);
			self SetVehVelocity(self.velocity + dir * 2000);
		}
		else
		{
			self SetVehVelocity(self.velocity + AnglesToRight(self.angles) * randomIntRange(-1000, 1000) + (0, 0, randomIntRange(0, 1500)));
		}
	}
	else
	{
		self SetVehVelocity(self.velocity + AnglesToRight(self.angles) * randomIntRange(-1000, 1000) + (0, 0, randomIntRange(0, 1500)));
	}
	self thread delay_set_gravity(RandomFloatRange(1.5, 3));
	torque = (0, randomIntRange(-90, 90), randomIntRange(90, 720));
	if(RandomInt(100) < 50)
	{
		torque = (torque[0], torque[1], torque[2] * -1);
	}
	while(isdefined(self))
	{
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + torque * 0.05;
		if(ang_vel[2] < 500 * -1)
		{
			ang_vel = (ang_vel[0], ang_vel[1], 500 * -1);
		}
		else if(ang_vel[2] > 500)
		{
			ang_vel = (ang_vel[0], ang_vel[1], 500);
		}
		self SetAngularVelocity(ang_vel);
		wait(0.05);
	}
}

/*
	Name: delay_set_gravity
	Namespace: vehicle_death
	Checksum: 0x5CEA5205
	Offset: 0x2588
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function delay_set_gravity(delay)
{
	self endon("crash_move_done");
	self endon("death");
	wait(delay);
	self SetPhysAcceleration((randomIntRange(-1600, 1600), randomIntRange(-1600, 1600), -1600));
}

/*
	Name: helicopter_crash_move
	Namespace: vehicle_death
	Checksum: 0x56026486
	Offset: 0x2608
	Size: 0x377
	Parameters: 2
	Flags: None
*/
function helicopter_crash_move(point, dir)
{
	self endon("crash_move_done");
	self endon("death");
	self thread crash_collision_test();
	self CancelAIMove();
	self ClearVehGoalPos();
	self setturningability(0);
	self SetPhysAcceleration(VectorScale((0, 0, -1), 800));
	vel = self.velocity;
	dir = VectorNormalize(dir);
	ang_vel = self GetAngularVelocity();
	ang_vel = (0, ang_vel[1] * RandomFloatRange(1, 3), 0);
	self SetAngularVelocity(ang_vel);
	point_2d = (point[0], point[1], self.origin[2]);
	torque = VectorScale((0, 1, 0), 720);
	if(Distance(self.origin, point_2d) > 5)
	{
		local_hit_point = point_2d - self.origin;
		dir_2d = (dir[0], dir[1], 0);
		if(length(dir_2d) > 0.01)
		{
			dir_2d = VectorNormalize(dir_2d);
			torque = VectorCross(VectorNormalize(local_hit_point), dir);
			torque = (0, 0, torque[2]);
			torque = VectorNormalize(torque);
			torque = (0, torque[2] * 180, 0);
		}
	}
	while(1)
	{
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + torque * 0.05;
		if(ang_vel[1] < 360 * -1)
		{
			ang_vel = (ang_vel[0], 360 * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > 360)
		{
			ang_vel = (ang_vel[0], 360, ang_vel[2]);
		}
		self SetAngularVelocity(ang_vel);
		wait(0.05);
	}
}

/*
	Name: boat_crash
	Namespace: vehicle_death
	Checksum: 0xFBE3AB51
	Offset: 0x2988
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function boat_crash(point, dir)
{
	self.crashing = 1;
	if(isdefined(self.unloading))
	{
		while(isdefined(self.unloading))
		{
			wait(0.05);
		}
	}
	if(!isdefined(self))
	{
		return;
	}
	self thread boat_crash_movement(point, dir);
}

/*
	Name: boat_crash_movement
	Namespace: vehicle_death
	Checksum: 0xD69D1E48
	Offset: 0x2A00
	Size: 0x2BF
	Parameters: 2
	Flags: None
*/
function boat_crash_movement(point, dir)
{
	self endon("crash_move_done");
	self endon("death");
	self CancelAIMove();
	self ClearVehGoalPos();
	self SetPhysAcceleration(VectorScale((0, 0, -1), 50));
	vel = self.velocity;
	dir = VectorNormalize(dir);
	ang_vel = self GetAngularVelocity();
	ang_vel = (0, 0, 0);
	self SetAngularVelocity(ang_vel);
	if(randomIntRange(0, 100) < 50)
	{
	}
	else
	{
	}
	torque = (randomIntRange(-5, -3), 0, 5);
	self thread boat_crash_monitor(point, dir, 4);
	while(1)
	{
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + torque * 0.05;
		if(ang_vel[1] < 360 * -1)
		{
			ang_vel = (ang_vel[0], 360 * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > 360)
		{
			ang_vel = (ang_vel[0], 360, ang_vel[2]);
		}
		self SetAngularVelocity(ang_vel);
		velocity = self.velocity;
		velocity = (velocity[0] * 0.975, velocity[1], velocity[2]);
		velocity = (velocity[0], velocity[1] * 0.975, velocity[2]);
		self SetVehVelocity(velocity);
		wait(0.05);
	}
}

/*
	Name: boat_crash_monitor
	Namespace: vehicle_death
	Checksum: 0xAD262DEA
	Offset: 0x2CC8
	Size: 0x59
	Parameters: 3
	Flags: None
*/
function boat_crash_monitor(point, dir, crash_time)
{
	self endon("death");
	wait(crash_time);
	self notify("crash_move_done");
	self crash_stop();
	self notify("crash_done");
}

/*
	Name: crash_stop
	Namespace: vehicle_death
	Checksum: 0x5D209FC5
	Offset: 0x2D30
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function crash_stop()
{
	self endon("death");
	self SetPhysAcceleration((0, 0, 0));
	self SetRotorSpeed(0);
	speed = self GetSpeedMPH();
	while(speed > 2)
	{
		velocity = self.velocity;
		velocity = velocity * 0.9;
		self SetVehVelocity(velocity);
		angular_velocity = self GetAngularVelocity();
		angular_velocity = angular_velocity * 0.9;
		self SetAngularVelocity(angular_velocity);
		speed = self GetSpeedMPH();
		wait(0.05);
	}
	self SetVehVelocity((0, 0, 0));
	self SetAngularVelocity((0, 0, 0));
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
}

/*
	Name: crash_collision_test
	Namespace: vehicle_death
	Checksum: 0x77E5CBFE
	Offset: 0x2ED8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function crash_collision_test()
{
	self endon("death");
	self waittill("veh_collision", velocity, normal);
	self helicopter_explode();
	self notify("crash_move_done");
	if(normal[2] > 0.7)
	{
		FORWARD = AnglesToForward(self.angles);
		right = VectorCross(normal, FORWARD);
		desired_forward = VectorCross(right, normal);
		self SetPhysAngles(VectorToAngles(desired_forward));
		self crash_stop();
		self notify("crash_done");
	}
	else
	{
		wait(0.05);
		self delete();
	}
}

/*
	Name: crash_path_check
	Namespace: vehicle_death
	Checksum: 0x97B039A5
	Offset: 0x3040
	Size: 0x1B1
	Parameters: 1
	Flags: None
*/
function crash_path_check(node)
{
	targ = node;
	for(search_depth = 5; isdefined(targ) && search_depth >= 0; search_depth--)
	{
		if(isdefined(targ.detoured) && targ.detoured == 0)
		{
			detourpath = vehicle::path_detour_get_detourpath(GetVehicleNode(targ.target, "targetname"));
			if(isdefined(detourpath) && isdefined(detourpath.script_crashtype))
			{
				return 1;
			}
		}
		if(isdefined(targ.target))
		{
			targ1 = GetVehicleNode(targ.target, "targetname");
			if(isdefined(targ1) && isdefined(targ1.target) && isdefined(targ.targetname) && targ1.target == targ.targetname)
			{
				return 0;
			}
			else if(isdefined(targ1) && targ1 == node)
			{
				return 0;
			}
			else
			{
				targ = targ1;
			}
			continue;
		}
		targ = undefined;
	}
	return 0;
}

/*
	Name: death_firesound
	Namespace: vehicle_death
	Checksum: 0x37DD2DAB
	Offset: 0x3200
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function death_firesound(sound)
{
	self thread sound::loop_on_tag(sound, undefined, 0);
	self util::waittill_any("fire_extinguish", "stop_crash_loop_sound");
	if(!isdefined(self))
	{
		return;
	}
	self notify("stop sound" + sound);
}

/*
	Name: death_fx
	Namespace: vehicle_death
	Checksum: 0x99A681CF
	Offset: 0x3278
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function death_fx()
{
	if(self vehicle::is_destructible())
	{
		return;
	}
	self util::explode_notify_wrapper();
	if(isdefined(self.do_death_fx))
	{
		self [[self.do_death_fx]]();
	}
	else
	{
		self vehicle::do_death_fx();
	}
}

/*
	Name: death_make_badplace
	Namespace: vehicle_death
	Checksum: 0x8674DF3E
	Offset: 0x32F0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function death_make_badplace(type)
{
	if(!isdefined(level.vehicle_death_badplace[type]))
	{
		return;
	}
	struct = level.vehicle_death_badplace[type];
	if(isdefined(struct.delay))
	{
		wait(struct.delay);
	}
	if(!isdefined(self))
	{
		return;
	}
	BadPlace_Box("vehicle_kill_badplace", struct.duration, self.origin, struct.radius, "all");
}

/*
	Name: death_jolt
	Namespace: vehicle_death
	Checksum: 0x9B380FA3
	Offset: 0x33A0
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function death_jolt(type)
{
	self endon("death");
	if(isdefined(self.ignore_death_jolt) && self.ignore_death_jolt)
	{
		return;
	}
	self JoltBody(self.origin + (23, 33, 64), 3);
	if(isdefined(self.death_anim))
	{
		self AnimScripted("death_anim", self.origin, self.angles, self.death_anim, "normal", %root, 1, 0);
		self waittillmatch("death_anim");
	}
	else if(self.isphysicsvehicle)
	{
		num_launch_multiplier = 1;
		if(isdefined(self.physicslaunchdeathscale))
		{
			num_launch_multiplier = self.physicslaunchdeathscale;
		}
		self LaunchVehicle(VectorScale((0, 0, 1), 180) * num_launch_multiplier, (RandomFloatRange(5, 10), RandomFloatRange(-5, 5), 0), 1, 0, 1);
	}
}

/*
	Name: deathrollon
	Namespace: vehicle_death
	Checksum: 0x5449791F
	Offset: 0x3520
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function deathrollon()
{
	if(self.health > 0)
	{
		self.rollingdeath = 1;
	}
}

/*
	Name: deathrolloff
	Namespace: vehicle_death
	Checksum: 0x1B628B79
	Offset: 0x3548
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function deathrolloff()
{
	self.rollingdeath = undefined;
	self notify("deathrolloff");
}

/*
	Name: loop_fx_on_vehicle_tag
	Namespace: vehicle_death
	Checksum: 0x1043DC4E
	Offset: 0x3570
	Size: 0xBD
	Parameters: 3
	Flags: None
*/
function loop_fx_on_vehicle_tag(effect, looptime, tag)
{
	/#
		Assert(isdefined(effect));
	#/
	/#
		Assert(isdefined(tag));
	#/
	/#
		Assert(isdefined(looptime));
	#/
	self endon("stop_looping_death_fx");
	while(isdefined(self))
	{
		PlayFXOnTag(effect, deathfx_ent(), tag);
		wait(looptime);
	}
}

/*
	Name: deathfx_ent
	Namespace: vehicle_death
	Checksum: 0xE7A1D4C
	Offset: 0x3638
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function deathfx_ent()
{
	if(!isdefined(self.deathfx_ent))
	{
		ent = spawn("script_model", (0, 0, 0));
		eModel = vehicle::get_dummy();
		ent SetModel(self.model);
		ent.origin = eModel.origin;
		ent.angles = eModel.angles;
		ent notsolid();
		ent Hide();
		ent LinkTo(eModel);
		self.deathfx_ent = ent;
	}
	else
	{
		self.deathfx_ent SetModel(self.model);
	}
	return self.deathfx_ent;
}

/*
	Name: death_cleanup_level_variables
	Namespace: vehicle_death
	Checksum: 0x274BA33D
	Offset: 0x3770
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function death_cleanup_level_variables()
{
	script_linkname = self.script_linkname;
	targetname = self.targetname;
	if(isdefined(script_linkname))
	{
		ArrayRemoveValue(level.vehicle_link[script_linkname], self);
	}
	if(isdefined(self.script_VehicleSpawngroup))
	{
		if(isdefined(level.vehicle_SpawnGroup[self.script_VehicleSpawngroup]))
		{
			ArrayRemoveValue(level.vehicle_SpawnGroup[self.script_VehicleSpawngroup], self);
			ArrayRemoveValue(level.vehicle_SpawnGroup[self.script_VehicleSpawngroup], undefined);
		}
	}
	if(isdefined(self.script_VehicleStartMove))
	{
		ArrayRemoveValue(level.vehicle_StartMoveGroup[self.script_VehicleStartMove], self);
	}
	if(isdefined(self.script_vehicleGroupDelete))
	{
		ArrayRemoveValue(level.vehicle_DeleteGroup[self.script_vehicleGroupDelete], self);
	}
}

/*
	Name: death_cleanup_riders
	Namespace: vehicle_death
	Checksum: 0xD35C1ACA
	Offset: 0x38A8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function death_cleanup_riders()
{
	if(isdefined(self.riders))
	{
		for(j = 0; j < self.riders.size; j++)
		{
			if(isdefined(self.riders[j]))
			{
				self.riders[j] delete();
			}
		}
	}
	else if(vehicle::is_corpse(self))
	{
		self.riders = [];
	}
}

/*
	Name: death_radius_damage
	Namespace: vehicle_death
	Checksum: 0x65E7FA1D
	Offset: 0x3940
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function death_radius_damage(meansOfDamage)
{
	if(!isdefined(meansOfDamage))
	{
		meansOfDamage = "MOD_EXPLOSIVE";
	}
	self endon("death");
	if(!isdefined(self) || self.abandoned === 1 || self.damage_on_death === 0 || self.radiusdamageradius <= 0)
	{
		return;
	}
	position = self.origin + VectorScale((0, 0, 1), 15);
	radius = self.radiusdamageradius;
	damageMax = self.radiusdamagemax;
	damageMin = self.radiusdamagemin;
	attacker = self;
	wait(0.05);
	if(isdefined(self))
	{
		self RadiusDamage(position, radius, damageMax, damageMin, attacker, meansOfDamage);
	}
}

/*
	Name: death_update_crash
	Namespace: vehicle_death
	Checksum: 0xC1A92822
	Offset: 0x3A60
	Size: 0x2F3
	Parameters: 2
	Flags: None
*/
function death_update_crash(point, dir)
{
	if(!isdefined(self.destructibledef))
	{
		if(isdefined(self.script_crashtypeoverride))
		{
			crashType = self.script_crashtypeoverride;
		}
		else if(isdefined(self.vehicleClass) && self.vehicleClass == "plane")
		{
			crashType = "aircraft";
		}
		else if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter")
		{
			crashType = "helicopter";
		}
		else if(isdefined(self.vehicleClass) && self.vehicleClass == "boat")
		{
			crashType = "boat";
		}
		else if(isdefined(self.currentNode) && crash_path_check(self.currentNode))
		{
			crashType = "none";
		}
		else
		{
			crashType = "tank";
		}
		if(crashType == "aircraft")
		{
			self thread aircraft_crash(point, dir);
		}
		else if(crashType == "helicopter")
		{
			if(isdefined(self.script_nocorpse))
			{
				self thread helicopter_explode();
			}
			else
			{
				self thread helicopter_crash(point, dir);
			}
		}
		else if(crashType == "boat")
		{
			self thread boat_crash(point, dir);
		}
		else if(crashType == "tank")
		{
			if(!isdefined(self.rollingdeath))
			{
				self vehicle::set_speed(0, 25, "Dead");
			}
			else
			{
				self waittill("deathrolloff");
				self vehicle::set_speed(0, 25, "Dead, finished path intersection");
			}
			wait(0.4);
			if(isdefined(self) && !vehicle::is_corpse(self))
			{
				self vehicle::set_speed(0, 10000, "deadstop");
				self notify("deadstop");
				if(self.disconnectPathOnStop === 1)
				{
					self vehicle::disconnect_paths();
				}
				if(isdefined(self.tankgetout) && self.tankgetout > 0)
				{
					self waittill("animsdone");
				}
			}
		}
	}
}

/*
	Name: waittill_crash_done_or_stopped
	Namespace: vehicle_death
	Checksum: 0xE1B657A3
	Offset: 0x3D60
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function waittill_crash_done_or_stopped()
{
	self endon("death");
	if(isdefined(self) && (isdefined(self.vehicleClass) && self.vehicleClass == "plane" || (isdefined(self.vehicleClass) && self.vehicleClass == "boat")))
	{
		if(isdefined(self.crashing) && self.crashing == 1)
		{
			self waittill("crash_done");
		}
		break;
	}
	wait(0.2);
	if(self.isphysicsvehicle)
	{
		self ClearVehGoalPos();
		self CancelAIMove();
		stable_count = 0;
		while(stable_count < 3)
		{
			if(isdefined(self.velocity) && LengthSquared(self.velocity) > 1)
			{
				stable_count = 0;
			}
			else
			{
				stable_count++;
			}
			wait(0.3);
		}
		self vehicle::disconnect_paths();
		break;
	}
	while(isdefined(self) && self GetSpeedMPH() > 0)
	{
		wait(0.3);
	}
}

/*
	Name: vehicle_damage_filter_damage_watcher
	Namespace: vehicle_death
	Checksum: 0xB9C422E9
	Offset: 0x3EE8
	Size: 0x1AB
	Parameters: 2
	Flags: None
*/
function vehicle_damage_filter_damage_watcher(driver, heavy_damage_threshold)
{
	self endon("death");
	self endon("exit_vehicle");
	self endon("end_damage_filter");
	if(!isdefined(heavy_damage_threshold))
	{
		heavy_damage_threshold = 100;
	}
	while(1)
	{
		self waittill("damage", damage, attacker, direction, point, type, tagName, modelName, partName, weapon);
		Earthquake(0.25, 0.15, self.origin, 512, self);
		driver PlayRumbleOnEntity("damage_light");
		time = GetTime();
		if(time - level.n_last_damage_time > 500)
		{
			level.n_hud_damage = 1;
			if(damage > heavy_damage_threshold)
			{
				driver playsound("veh_damage_filter_heavy");
			}
			else
			{
				driver playsound("veh_damage_filter_light");
			}
			level.n_last_damage_time = GetTime();
		}
	}
}

/*
	Name: vehicle_damage_filter_exit_watcher
	Namespace: vehicle_death
	Checksum: 0x87BD53C7
	Offset: 0x40A0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function vehicle_damage_filter_exit_watcher(driver)
{
	self util::waittill_any("exit_vehicle", "death", "end_damage_filter");
}

/*
	Name: vehicle_damage_filter
	Namespace: vehicle_death
	Checksum: 0x7743D4CB
	Offset: 0x40E8
	Size: 0x187
	Parameters: 4
	Flags: None
*/
function vehicle_damage_filter(vision_set, heavy_damage_threshold, filterid, b_use_player_damage)
{
	if(!isdefined(filterid))
	{
		filterid = 0;
	}
	if(!isdefined(b_use_player_damage))
	{
		b_use_player_damage = 0;
	}
	self endon("death");
	self endon("exit_vehicle");
	self endon("end_damage_filter");
	driver = self GetSeatOccupant(0);
	if(!isdefined(self.damage_filter_init))
	{
		self.damage_filter_init = 1;
	}
	level.n_hud_damage = 0;
	level.n_last_damage_time = GetTime();
	if(isdefined(b_use_player_damage) && b_use_player_damage)
	{
	}
	else
	{
	}
	damagee = self;
	damagee thread vehicle_damage_filter_damage_watcher(driver, heavy_damage_threshold);
	damagee thread vehicle_damage_filter_exit_watcher(driver);
	while(1)
	{
		if(isdefined(level.n_hud_damage) && level.n_hud_damage)
		{
			time = GetTime();
			if(time - level.n_last_damage_time > 500)
			{
				level.n_hud_damage = 0;
			}
		}
		wait(0.05);
	}
}

/*
	Name: flipping_shooting_death
	Namespace: vehicle_death
	Checksum: 0x5430D41C
	Offset: 0x4278
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function flipping_shooting_death(attacker, hitdir)
{
	if(isdefined(self.delete_on_death))
	{
		if(isdefined(self))
		{
			self delete();
		}
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	self endon("death");
	self death_cleanup_level_variables();
	self DisableAimAssist();
	self death_fx();
	self thread death_radius_damage();
	self thread set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self vehicle::lights_off();
	self thread flipping_shooting_crash_movement(attacker, hitdir);
	self waittill("crash_done");
	while(isdefined(self.controlled) && self.controlled)
	{
		wait(0.05);
	}
	self delete();
}

/*
	Name: plane_crash
	Namespace: vehicle_death
	Checksum: 0x41E158CD
	Offset: 0x4420
	Size: 0x28B
	Parameters: 0
	Flags: None
*/
function plane_crash()
{
	self endon("death");
	self SetPhysAcceleration(VectorScale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	FORWARD = AnglesToForward(self.angles);
	forward_mag = RandomFloatRange(0, 300);
	forward_mag = forward_mag + math::sign(forward_mag) * 400;
	FORWARD = FORWARD * forward_mag;
	new_vel = FORWARD + self.velocity * 0.2;
	ang_vel = self GetAngularVelocity();
	yaw_vel = RandomFloatRange(0, 130) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + math::sign(yaw_vel) * 20;
	ang_vel = (RandomFloatRange(-1, 1), yaw_vel, 0);
	roll_amount = Abs(ang_vel[1]) / 150 * 30;
	if(ang_vel[1] > 0)
	{
		roll_amount = roll_amount * -1;
	}
	self.angles = (self.angles[0], self.angles[1], roll_amount);
	ang_vel = (ang_vel[0], ang_vel[1], roll_amount * 0.9);
	self.velocity_rotation_frac = 1;
	self.crash_accel = RandomFloatRange(65, 90);
	set_movement_and_accel(new_vel, ang_vel);
}

/*
	Name: barrel_rolling_crash
	Namespace: vehicle_death
	Checksum: 0xD0997231
	Offset: 0x46B8
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function barrel_rolling_crash()
{
	self endon("death");
	self SetPhysAcceleration(VectorScale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	FORWARD = AnglesToForward(self.angles);
	forward_mag = RandomFloatRange(0, 250);
	forward_mag = forward_mag + math::sign(forward_mag) * 300;
	FORWARD = FORWARD * forward_mag;
	new_vel = FORWARD + VectorScale((0, 0, 1), 70);
	ang_vel = self GetAngularVelocity();
	yaw_vel = RandomFloatRange(0, 60) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + math::sign(yaw_vel) * 30;
	roll_vel = RandomFloatRange(-200, 200);
	roll_vel = roll_vel + math::sign(roll_vel) * 300;
	ang_vel = (RandomFloatRange(-5, 5), yaw_vel, roll_vel);
	self.velocity_rotation_frac = 1;
	self.crash_accel = RandomFloatRange(145, 210);
	self SetPhysAcceleration(VectorScale((0, 0, -1), 250));
	set_movement_and_accel(new_vel, ang_vel);
}

/*
	Name: random_crash
	Namespace: vehicle_death
	Checksum: 0x7325C797
	Offset: 0x4910
	Size: 0x31B
	Parameters: 1
	Flags: None
*/
function random_crash(hitdir)
{
	self endon("death");
	self SetPhysAcceleration(VectorScale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	if(!isdefined(hitdir))
	{
		hitdir = (1, 0, 0);
	}
	hitdir = VectorNormalize(hitdir);
	side_dir = VectorCross(hitdir, (0, 0, 1));
	side_dir_mag = RandomFloatRange(-280, 280);
	side_dir_mag = side_dir_mag + math::sign(side_dir_mag) * 150;
	side_dir = side_dir * side_dir_mag;
	FORWARD = AnglesToForward(self.angles);
	forward_mag = RandomFloatRange(0, 300);
	forward_mag = forward_mag + math::sign(forward_mag) * 30;
	FORWARD = FORWARD * forward_mag;
	new_vel = self.velocity * 1.2 + FORWARD + side_dir + VectorScale((0, 0, 1), 50);
	ang_vel = self GetAngularVelocity();
	ang_vel = (ang_vel[0] * 0.3, ang_vel[1], ang_vel[2] * 1.2);
	yaw_vel = RandomFloatRange(0, 130) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + math::sign(yaw_vel) * 50;
	ang_vel = ang_vel + (RandomFloatRange(-5, 5), yaw_vel, RandomFloatRange(-18, 18));
	self.velocity_rotation_frac = RandomFloatRange(0.3, 0.99);
	self.crash_accel = RandomFloatRange(65, 90);
	set_movement_and_accel(new_vel, ang_vel);
}

/*
	Name: set_movement_and_accel
	Namespace: vehicle_death
	Checksum: 0x4B3E7008
	Offset: 0x4C38
	Size: 0x20D
	Parameters: 2
	Flags: None
*/
function set_movement_and_accel(new_vel, ang_vel)
{
	self death_fx();
	self thread death_radius_damage();
	self SetVehVelocity(new_vel);
	self SetAngularVelocity(ang_vel);
	if(!isdefined(self.off))
	{
		self thread flipping_shooting_crash_accel();
	}
	self thread vehicle_ai::nudge_collision();
	self playsound("veh_wasp_dmg_hit");
	self vehicle::toggle_sounds(0);
	if(!isdefined(self.off))
	{
		self thread flipping_shooting_dmg_snd();
	}
	wait(0.1);
	if(RandomInt(100) < 40 && !isdefined(self.off) && self.variant !== "rocket")
	{
		self thread vehicle_ai::fire_for_time(RandomFloatRange(0.7, 2));
	}
	result = self util::waittill_any_timeout(15, "crash_done");
	if(result === "crash_done")
	{
		self vehicle::do_death_dynents();
		self set_death_model(self.deathmodel, self.modelswapdelay);
	}
	else
	{
		self notify("crash_done");
	}
}

/*
	Name: flipping_shooting_crash_movement
	Namespace: vehicle_death
	Checksum: 0xAAD4F63D
	Offset: 0x4E50
	Size: 0x199
	Parameters: 2
	Flags: None
*/
function flipping_shooting_crash_movement(attacker, hitdir)
{
	self endon("crash_done");
	self endon("death");
	self CancelAIMove();
	self ClearVehGoalPos();
	self ClearLookAtEnt();
	self SetPhysAcceleration(VectorScale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	if(!isdefined(hitdir))
	{
		hitdir = (1, 0, 0);
	}
	hitdir = VectorNormalize(hitdir);
	new_vel = self.velocity;
	self.crash_style = GetDvarInt("debug_crash_type");
	if(self.crash_style == -1)
	{
		self.crash_style = RandomInt(3);
	}
	switch(self.crash_style)
	{
		case 0:
		{
			barrel_rolling_crash();
			break;
		}
		case 1:
		{
			plane_crash();
			break;
		}
		case default:
		{
			random_crash(hitdir);
		}
	}
}

/*
	Name: flipping_shooting_dmg_snd
	Namespace: vehicle_death
	Checksum: 0x3CBAE300
	Offset: 0x4FF8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function flipping_shooting_dmg_snd()
{
	dmg_ent = spawn("script_origin", self.origin);
	dmg_ent LinkTo(self);
	dmg_ent PlayLoopSound("veh_wasp_dmg_loop");
	self util::waittill_any("crash_done", "death");
	dmg_ent StopLoopSound(1);
	wait(2);
	dmg_ent delete();
}

/*
	Name: flipping_shooting_crash_accel
	Namespace: vehicle_death
	Checksum: 0x41466A4E
	Offset: 0x50D0
	Size: 0x2FF
	Parameters: 0
	Flags: None
*/
function flipping_shooting_crash_accel()
{
	self endon("crash_done");
	self endon("death");
	count = 0;
	prev_forward = AnglesToForward(self.angles);
	prev_forward_vel = VectorDot(self.velocity, prev_forward) * self.velocity_rotation_frac;
	if(prev_forward_vel < 0)
	{
		prev_forward_vel = 0;
	}
	while(1)
	{
		self SetVehVelocity(self.velocity + anglesToUp(self.angles) * self.crash_accel);
		self.crash_accel = self.crash_accel * 0.98;
		new_velocity = self.velocity;
		new_velocity = new_velocity - prev_forward * prev_forward_vel;
		FORWARD = AnglesToForward(self.angles);
		new_velocity = new_velocity + FORWARD * prev_forward_vel;
		prev_forward = FORWARD;
		prev_forward_vel = VectorDot(new_velocity, prev_forward) * self.velocity_rotation_frac;
		if(prev_forward_vel < 10)
		{
			new_velocity = new_velocity + FORWARD * 40;
			prev_forward_vel = 0;
		}
		self SetVehVelocity(new_velocity);
		wait(0.1);
		count++;
		if(count % 8 == 0 && RandomInt(100) > 40)
		{
			if(self.velocity[2] > 130)
			{
				self.crash_accel = self.crash_accel * 0.75;
			}
			else if(self.velocity[2] < 40 && count < 60)
			{
				if(Abs(self.angles[0]) > 35 || Abs(self.angles[2]) > 35)
				{
					self.crash_accel = RandomFloatRange(100, 150);
				}
				else
				{
					self.crash_accel = RandomFloatRange(45, 70);
				}
			}
		}
	}
}

/*
	Name: death_fire_loop_audio
	Namespace: vehicle_death
	Checksum: 0xEC5F4FE7
	Offset: 0x53D8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function death_fire_loop_audio()
{
	sound_ent = spawn("script_origin", self.origin);
	sound_ent PlayLoopSound("veh_qrdrone_death_fire_loop", 0.1);
	wait(11);
	sound_ent StopLoopSound(1);
	sound_ent delete();
}

/*
	Name: FreeWhenSafe
	Namespace: vehicle_death
	Checksum: 0x4091733C
	Offset: 0x5470
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function FreeWhenSafe(time)
{
	if(!isdefined(time))
	{
		time = 4;
	}
	self thread DelayedRemove_thread(time, 0);
}

/*
	Name: DeleteWhenSafe
	Namespace: vehicle_death
	Checksum: 0x884277C2
	Offset: 0x54B8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function DeleteWhenSafe(time)
{
	if(!isdefined(time))
	{
		time = 4;
	}
	self thread DelayedRemove_thread(time, 1);
}

/*
	Name: DelayedRemove_thread
	Namespace: vehicle_death
	Checksum: 0xC9DAEF3B
	Offset: 0x5500
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function DelayedRemove_thread(time, shouldDelete)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon("death");
	self endon("free_vehicle");
	if(shouldDelete === 1)
	{
		self SetVehVelocity((0, 0, 0));
		self ghost();
		self notsolid();
	}
	util::waitForTimeAndNetworkFrame(time);
	if(shouldDelete === 1)
	{
		self delete();
	}
	else
	{
		self freevehicle();
	}
}

/*
	Name: CleanUp
	Namespace: vehicle_death
	Checksum: 0x6DA5E86A
	Offset: 0x55E8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CleanUp()
{
	if(isdefined(self.cleanup_after_time))
	{
		wait(self.cleanup_after_time);
		if(isdefined(self))
		{
			self delete();
		}
	}
}

