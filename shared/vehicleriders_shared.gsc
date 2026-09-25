#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0x740B637C
	Offset: 0x390
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicleriders", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0xC57CF260
	Offset: 0x3D0
	Size: 0x523
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.vehiclerider_groups = [];
	level.vehiclerider_groups["all"] = "all";
	level.vehiclerider_groups["driver"] = "driver";
	level.vehiclerider_groups["passengers"] = "passenger";
	level.vehiclerider_groups["crew"] = "crew";
	level.vehiclerider_groups["gunners"] = "gunner";
	a_registered_fields = [];
	foreach(bundle in struct::get_script_bundles("vehicleriders"))
	{
		foreach(object in bundle.objects)
		{
			if(IsString(object.VehicleEnterAnim))
			{
				Array::add(a_registered_fields, object.position + "_enter", 0);
			}
			if(IsString(object.VehicleExitAnim))
			{
				Array::add(a_registered_fields, object.position + "_exit", 0);
			}
			if(IsString(object.VehicleRiderDeathAnim))
			{
				Array::add(a_registered_fields, object.position + "_death", 0);
			}
		}
	}
	foreach(str_clientfield in a_registered_fields)
	{
		clientfield::register("vehicle", str_clientfield, 1, 1, "counter");
	}
	level.vehiclerider_use_index = [];
	level.vehiclerider_use_index["driver"] = 0;
	for(i = 1; i <= 4; i++)
	{
		level.vehiclerider_use_index["gunner" + i] = i;
	}
	passengerIndex = 1;
	for(i = 4 + 1; i <= 10; i++)
	{
		level.vehiclerider_use_index["passenger" + passengerIndex] = i;
		passengerIndex++;
	}
	foreach(s in struct::get_script_bundles("vehicleriders"))
	{
		if(!isdefined(s.LowExitHeight))
		{
			s.LowExitHeight = 0;
		}
		if(!isdefined(s.HighExitLandHeight))
		{
			s.HighExitLandHeight = 32;
		}
	}
	callback::on_vehicle_spawned(&on_vehicle_spawned);
	callback::on_ai_spawned(&on_ai_spawned);
	callback::on_vehicle_killed(&on_vehicle_killed);
}

/*
	Name: seat_position_to_index
	Namespace: vehicle
	Checksum: 0xB1F335AE
	Offset: 0x900
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function seat_position_to_index(str_position)
{
	return level.vehiclerider_use_index[str_position];
}

/*
	Name: on_vehicle_spawned
	Namespace: vehicle
	Checksum: 0xDF4F3292
	Offset: 0x920
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function on_vehicle_spawned()
{
	spawn_riders();
}

/*
	Name: on_ai_spawned
	Namespace: vehicle
	Checksum: 0xBC203BF2
	Offset: 0x940
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_ai_spawned()
{
	if(isVehicle(self))
	{
		self spawn_riders();
	}
}

/*
	Name: claim_position
	Namespace: vehicle
	Checksum: 0x7348F1C3
	Offset: 0x980
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function claim_position(vh, str_pos)
{
	Array::add(vh.riders, self, 0);
	vh flagsys::set(str_pos + "occupied");
	self flagsys::set("vehiclerider");
	self thread _unclaim_position_on_death(vh, str_pos);
}

/*
	Name: unclaim_position
	Namespace: vehicle
	Checksum: 0xAF4AD136
	Offset: 0xA28
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function unclaim_position(vh, str_pos)
{
	ArrayRemoveValue(vh.riders, self);
	vh flagsys::clear(str_pos + "occupied");
	self flagsys::clear("vehiclerider");
}

/*
	Name: _unclaim_position_on_death
	Namespace: vehicle
	Checksum: 0x310E2164
	Offset: 0xAB0
	Size: 0x5B
	Parameters: 2
	Flags: Private
*/
function private _unclaim_position_on_death(vh, str_pos)
{
	vh endon("death");
	vh endon(str_pos + "occupied");
	self waittill("death");
	unclaim_position(vh, str_pos);
}

/*
	Name: find_next_open_position
	Namespace: vehicle
	Checksum: 0x7E098A4E
	Offset: 0xB18
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function find_next_open_position(ai)
{
	foreach(s_rider in get_bundle_for_ai(ai).objects)
	{
		seat_index = seat_position_to_index(s_rider.position);
		if(seat_index <= 4)
		{
			if(self IsVehicleSeatOccupied(seat_index))
			{
				continue;
			}
		}
		if(!flagsys::get(s_rider.position + "occupied"))
		{
			return s_rider.position;
		}
	}
}

/*
	Name: spawn_riders
	Namespace: vehicle
	Checksum: 0xD8EB495A
	Offset: 0xC48
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function spawn_riders()
{
	self endon("death");
	self.riders = [];
	if(isdefined(self.script_vehicleride))
	{
		a_spawners = GetSpawnerArray(self.script_vehicleride, "script_vehicleride");
		foreach(SP in a_spawners)
		{
			ai_rider = SP spawner::spawn(1);
			if(isdefined(ai_rider))
			{
				ai_rider get_in(self, ai_rider.script_startingposition, 1);
			}
		}
	}
}

/*
	Name: get_bundle_for_ai
	Namespace: vehicle
	Checksum: 0x46BC1A5D
	Offset: 0xD70
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function get_bundle_for_ai(ai)
{
	vh = self;
	if(isdefined(ai.archetype) && ai.archetype == "robot")
	{
		bundle = vh get_robot_bundle();
	}
	else
	{
		bundle = vh get_bundle();
	}
	return bundle;
}

/*
	Name: get_rider_info
	Namespace: vehicle
	Checksum: 0xAB57FC29
	Offset: 0xE10
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function get_rider_info(vh, str_pos)
{
	if(!isdefined(str_pos))
	{
		str_pos = "driver";
	}
	ai = self;
	bundle = undefined;
	bundle = vh get_bundle_for_ai(ai);
	foreach(s_rider in bundle.objects)
	{
		if(s_rider.position == str_pos)
		{
			return s_rider;
		}
	}
}

/*
	Name: get_in
	Namespace: vehicle
	Checksum: 0xDC9C9654
	Offset: 0xF18
	Size: 0x5B3
	Parameters: 3
	Flags: None
*/
function get_in(vh, str_pos, b_teleport)
{
	if(!isdefined(b_teleport))
	{
		b_teleport = 0;
	}
	self endon("death");
	vh endon("death");
	if(!isdefined(str_pos))
	{
		str_pos = vh find_next_open_position(self);
	}
	/#
		Assert(isdefined(str_pos), "Dev Block strings are not supported");
	#/
	if(!isdefined(str_pos))
	{
		return;
	}
	if(!isdefined(vh.ignore_seat_check) || !vh.ignore_seat_check)
	{
		seat_index = level.vehiclerider_use_index[str_pos];
		if(seat_index <= 4)
		{
			seat_available = !vh IsVehicleSeatOccupied(seat_index);
			/#
				Assert(seat_available, "Dev Block strings are not supported");
			#/
			if(!seat_available)
			{
				return;
			}
		}
	}
	claim_position(vh, str_pos);
	if(!b_teleport && self flagsys::get("in_vehicle"))
	{
		get_out();
	}
	if(colors::is_color_ai())
	{
		colors::disable();
	}
	_init_rider(vh, str_pos);
	if(!b_teleport)
	{
		self animation::set_death_anim(self.rider_info.EnterDeathAnim);
		animation::reach(self.rider_info.EnterAnim, self.vehicle, self.rider_info.AlignTag);
		if(isdefined(self.rider_info.VehicleEnterAnim))
		{
			vh clientfield::increment(self.rider_info.position + "_enter", 1);
			self SetAnim(self.rider_info.VehicleEnterAnim, 1, 0, 1);
		}
		self animation::Play(self.rider_info.EnterAnim, self.vehicle, self.rider_info.AlignTag);
	}
	if(isdefined(self.rider_info) && isdefined(self.rider_info.RideAnim))
	{
		self thread animation::Play(self.rider_info.RideAnim, self.vehicle, self.rider_info.AlignTag, 1, 0.2, 0.2, 0, 0, 0, 0);
	}
	else if(!isdefined(level.vehiclerider_use_index[str_pos]))
	{
		/#
			Assert("Dev Block strings are not supported" + str_pos);
		#/
	}
	else if(isdefined(self.rider_info))
	{
		v_tag_pos = vh GetTagOrigin(self.rider_info.AlignTag);
		v_tag_ang = vh GetTagAngles(self.rider_info.AlignTag);
		if(isdefined(v_tag_pos))
		{
			self ForceTeleport(v_tag_pos, v_tag_ang);
		}
	}
	else
	{
		errormsg("Dev Block strings are not supported");
	}
	/#
	#/
	if(IsActor(self))
	{
		self PathMode("dont move");
		self.disableAmmoDrop = 1;
		self.dontDropWeapon = 1;
	}
	if(isdefined(level.vehiclerider_use_index[str_pos]))
	{
		if(!isdefined(self.vehicle.ignore_seat_check) || !self.vehicle.ignore_seat_check)
		{
			seat_index = level.vehiclerider_use_index[str_pos];
			if(seat_index <= 4)
			{
				if(self.vehicle IsVehicleSeatOccupied(seat_index))
				{
					get_out();
					return;
				}
			}
		}
		self.vehicle usevehicle(self, level.vehiclerider_use_index[str_pos]);
	}
	self flagsys::set("in_vehicle");
	self thread handle_rider_death();
}

/*
	Name: handle_rider_death
	Namespace: vehicle
	Checksum: 0xB9B42575
	Offset: 0x14D8
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function handle_rider_death()
{
	self endon("exiting_vehicle");
	self.vehicle endon("death");
	if(isdefined(self.rider_info.RideDeathAnim))
	{
		self animation::set_death_anim(self.rider_info.RideDeathAnim);
	}
	self waittill("death");
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.vehicle) && isdefined(self.rider_info) && isdefined(self.rider_info.VehicleRiderDeathAnim))
	{
		self.vehicle clientfield::increment(self.rider_info.position + "_death", 1);
		self.vehicle SetAnimKnobRestart(self.rider_info.VehicleRiderDeathAnim, 1, 0, 1);
	}
}

/*
	Name: delete_rider_asap
	Namespace: vehicle
	Checksum: 0xEE273B79
	Offset: 0x15E8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function delete_rider_asap(entity)
{
	wait(0.05);
	if(isdefined(entity))
	{
		entity delete();
	}
}

/*
	Name: kill_rider
	Namespace: vehicle
	Checksum: 0xF7C79348
	Offset: 0x1628
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function kill_rider(entity)
{
	if(isdefined(entity))
	{
		if(isalive(entity) && !GibServerUtils::IsGibbed(entity, 2))
		{
			if(entity IsPlayingAnimScripted())
			{
				entity StopAnimScripted();
			}
			if(GetDvarInt("tu1_vehicleRidersInvincibility", 1))
			{
				util::stop_magic_bullet_shield(entity);
			}
			GibServerUtils::GibLeftArm(entity);
			GibServerUtils::GibRightArm(entity);
			GibServerUtils::GibLegs(entity);
			GibServerUtils::Annihilate(entity);
			entity Unlink();
			entity kill();
		}
		entity ghost();
		level thread delete_rider_asap(entity);
	}
}

/*
	Name: on_vehicle_killed
	Namespace: vehicle
	Checksum: 0xF36B70D7
	Offset: 0x17A8
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function on_vehicle_killed(params)
{
	if(isdefined(self.riders))
	{
		foreach(rider in self.riders)
		{
			kill_rider(rider);
		}
	}
}

/*
	Name: is_seat_available
	Namespace: vehicle
	Checksum: 0xA56F469F
	Offset: 0x1858
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function is_seat_available(vh, str_pos)
{
	if(vh flagsys::get(str_pos + "occupied"))
	{
		return 0;
	}
	if(anglesToUp(vh.angles)[2] < 0.3)
	{
		return 0;
	}
	seat_index = seat_position_to_index(str_pos);
	if(seat_index <= 4)
	{
		if(vh IsVehicleSeatOccupied(seat_index))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: can_get_in
	Namespace: vehicle
	Checksum: 0xCBCE2E0A
	Offset: 0x1930
	Size: 0x115
	Parameters: 2
	Flags: None
*/
function can_get_in(vh, str_pos)
{
	if(!is_seat_available(vh, str_pos))
	{
		return 0;
	}
	rider_info = self get_rider_info(vh, str_pos);
	v_tag_org = vh GetTagOrigin(rider_info.AlignTag);
	v_tag_ang = vh GetTagAngles(rider_info.AlignTag);
	v_enter_pos = GetStartOrigin(v_tag_org, v_tag_ang, rider_info.EnterAnim);
	if(!self FindPath(self.origin, v_enter_pos))
	{
		return 0;
	}
	return 1;
}

/*
	Name: get_out
	Namespace: vehicle
	Checksum: 0xD65708D8
	Offset: 0x1A50
	Size: 0x3C9
	Parameters: 1
	Flags: None
*/
function get_out(str_mode)
{
	ai = self;
	self endon("death");
	self notify("exiting_vehicle");
	/#
		Assert(isalive(self), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(self.vehicle), "Dev Block strings are not supported");
	#/
	if(isdefined(self.vehicle.vehicleClass) && self.vehicle.vehicleClass == "helicopter" || (isdefined(self.vehicle.vehicleClass) && self.vehicle.vehicleClass == "plane"))
	{
		if(!isdefined(str_mode))
		{
			str_mode = "variable";
		}
	}
	else if(!isdefined(str_mode))
	{
		str_mode = "ground";
	}
	bundle = self.vehicle get_bundle_for_ai(ai);
	n_hover_height = bundle.LowExitHeight;
	if(isdefined(self.rider_info.VehicleExitAnim))
	{
		self.vehicle clientfield::increment(self.rider_info.position + "_exit", 1);
		self.vehicle SetAnim(self.rider_info.VehicleExitAnim, 1, 0, 1);
	}
	switch(str_mode)
	{
		case "ground":
		{
			exit_ground();
			break;
		}
		case "low":
		{
			exit_low();
			break;
		}
		case "variable":
		{
			exit_variable();
			break;
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		}
	}
	if(IsActor(self))
	{
		self PathMode("move allowed");
		self.disableAmmoDrop = 0;
		self.dontDropWeapon = 0;
	}
	if(isdefined(self.vehicle))
	{
		unclaim_position(self.vehicle, self.rider_info.position);
		if(isdefined(level.vehiclerider_use_index[self.rider_info.position]) && self flagsys::get("in_vehicle"))
		{
			self.vehicle usevehicle(self, level.vehiclerider_use_index[self.rider_info.position]);
		}
	}
	self flagsys::clear("in_vehicle");
	self.vehicle = undefined;
	self.rider_info = undefined;
	self animation::set_death_anim(undefined);
	set_goal();
	self notify("exited_vehicle");
}

/*
	Name: set_goal
	Namespace: vehicle
	Checksum: 0xBB29C691
	Offset: 0x1E28
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function set_goal()
{
	if(colors::is_color_ai())
	{
		colors::enable();
	}
	else if(!isdefined(self.target))
	{
		self SetGoal(self.origin);
	}
}

/*
	Name: unload
	Namespace: vehicle
	Checksum: 0x26BF2D3C
	Offset: 0x1E90
	Size: 0x245
	Parameters: 4
	Flags: None
*/
function unload(str_group, str_mode, remove_rider_before_unloading, remove_riders_wait_time)
{
	if(!isdefined(str_group))
	{
		str_group = "all";
	}
	self notify("unload", str_group);
	/#
		Assert(isdefined(level.vehiclerider_groups[str_group]), str_group + "Dev Block strings are not supported");
	#/
	str_group = level.vehiclerider_groups[str_group];
	a_ai_unloaded = [];
	foreach(ai_rider in self.riders)
	{
		if(str_group == "all" || IsSubStr(ai_rider.rider_info.position, str_group))
		{
			ai_rider thread get_out(str_mode);
			if(!isdefined(a_ai_unloaded))
			{
				a_ai_unloaded = [];
			}
			else if(!IsArray(a_ai_unloaded))
			{
				a_ai_unloaded = Array(a_ai_unloaded);
			}
			a_ai_unloaded[a_ai_unloaded.size] = ai_rider;
		}
	}
	if(a_ai_unloaded.size > 0)
	{
		if(remove_rider_before_unloading === 1)
		{
			remove_riders_after_wait(remove_riders_wait_time, a_ai_unloaded);
		}
		if(isdefined(self.unloadTimeout))
		{
		}
		else
		{
		}
		Array::flagsys_wait_clear(a_ai_unloaded, "in_vehicle", 4);
		self notify("unload", a_ai_unloaded, self.unloadTimeout);
	}
}

/*
	Name: remove_riders_after_wait
	Namespace: vehicle
	Checksum: 0xF122F610
	Offset: 0x20E0
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function remove_riders_after_wait(wait_time, a_riders_to_remove)
{
	wait(wait_time);
	if(isdefined(a_riders_to_remove))
	{
		foreach(ai in a_riders_to_remove)
		{
			ArrayRemoveValue(self.riders, ai);
		}
	}
}

/*
	Name: ragdoll_dead_exit_rider
	Namespace: vehicle
	Checksum: 0xD8670307
	Offset: 0x21A0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function ragdoll_dead_exit_rider()
{
	self endon("exited_vehicle");
	self waittill("death");
	if(IsActor(self) && !self IsRagdoll())
	{
		self Unlink();
		self StartRagdoll();
	}
}

/*
	Name: exit_ground
	Namespace: vehicle
	Checksum: 0xFA739E92
	Offset: 0x2228
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function exit_ground()
{
	self animation::set_death_anim(self.rider_info.ExitGroundDeathAnim);
	if(!isdefined(self.rider_info.ExitGroundDeathAnim))
	{
		self thread ragdoll_dead_exit_rider();
	}
	/#
		Assert(IsString(self.rider_info.ExitGroundAnim), "Dev Block strings are not supported" + self.rider_info.position + "Dev Block strings are not supported");
	#/
	if(IsString(self.rider_info.ExitGroundAnim))
	{
		animation::Play(self.rider_info.ExitGroundAnim, self.vehicle, self.rider_info.AlignTag);
	}
}

/*
	Name: exit_low
	Namespace: vehicle
	Checksum: 0x843A5CD7
	Offset: 0x2338
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function exit_low()
{
	self animation::set_death_anim(self.rider_info.ExitLowDeathAnim);
	/#
		Assert(isdefined(self.rider_info.ExitLowAnim), "Dev Block strings are not supported" + self.rider_info.position + "Dev Block strings are not supported");
	#/
	animation::Play(self.rider_info.ExitLowAnim, self.vehicle, self.rider_info.AlignTag);
}

/*
	Name: handle_falling_death
	Namespace: vehicle
	Checksum: 0x48433335
	Offset: 0x23F0
	Size: 0x63
	Parameters: 0
	Flags: Private
*/
function private handle_falling_death()
{
	self endon("landed");
	self waittill("death");
	if(IsActor(self))
	{
		self Unlink();
		self StartRagdoll();
	}
}

/*
	Name: forward_euler_integration
	Namespace: vehicle
	Checksum: 0x83C8381B
	Offset: 0x2460
	Size: 0x18D
	Parameters: 3
	Flags: Private
*/
function private forward_euler_integration(e_move, v_target_landing, n_initial_speed)
{
	landed = 0;
	integrationStep = 0.1;
	position = self.origin;
	velocity = (0, 0, n_initial_speed * -1);
	gravity = VectorScale((0, 0, -1), 385.8);
	while(!landed)
	{
		previousPosition = position;
		velocity = velocity + gravity * integrationStep;
		position = position + velocity * integrationStep;
		if(position[2] + velocity[2] * integrationStep <= v_target_landing[2])
		{
			landed = 1;
			position = v_target_landing;
		}
		/#
			recordLine(previousPosition, position, (1, 0.5, 0), "Dev Block strings are not supported", self);
		#/
		hostmigration::waitTillHostMigrationDone();
		e_move moveto(position, integrationStep);
		if(!landed)
		{
			wait(integrationStep);
		}
	}
}

/*
	Name: exit_variable
	Namespace: vehicle
	Checksum: 0xCD07A880
	Offset: 0x25F8
	Size: 0x48B
	Parameters: 0
	Flags: None
*/
function exit_variable()
{
	ai = self;
	self endon("death");
	self notify("exiting_vehicle");
	self thread handle_falling_death();
	self animation::set_death_anim(self.rider_info.ExitHighDeathAnim);
	/#
		Assert(isdefined(self.rider_info.ExitHighAnim), "Dev Block strings are not supported" + self.rider_info.position + "Dev Block strings are not supported");
	#/
	animation::Play(self.rider_info.ExitHighAnim, self.vehicle, self.rider_info.AlignTag, 1, 0, 0);
	self animation::set_death_anim(self.rider_info.ExitHighLoopDeathAnim);
	n_cur_height = get_height(self.vehicle);
	bundle = self.vehicle get_bundle_for_ai(ai);
	n_target_height = bundle.HighExitLandHeight;
	if(isdefined(self.rider_info.DropUnderVehicleOrigin) && self.rider_info.DropUnderVehicleOrigin || (isdefined(self.DropUnderVehicleOriginOverride) && self.DropUnderVehicleOriginOverride))
	{
		v_target_landing = (self.vehicle.origin[0], self.vehicle.origin[1], self.origin[2] - n_cur_height + n_target_height);
	}
	else
	{
		v_target_landing = (self.origin[0], self.origin[1], self.origin[2] - n_cur_height + n_target_height);
	}
	if(isdefined(self.overrideDropPosition))
	{
		v_target_landing = (self.overrideDropPosition[0], self.overrideDropPosition[1], v_target_landing[2]);
	}
	if(isdefined(self.targetAngles))
	{
		angles = self.targetAngles;
	}
	else
	{
		angles = self.angles;
	}
	e_move = util::spawn_model("tag_origin", self.origin, angles);
	self thread exit_high_loop_anim(e_move);
	Distance = n_target_height - n_cur_height;
	initialSpeed = bundle.DropSpeed;
	acceleration = 385.8;
	n_fall_time = initialSpeed * -1 + sqrt(pow(initialSpeed, 2) - 2 * acceleration * Distance) / acceleration;
	self notify("falling", n_fall_time);
	forward_euler_integration(e_move, v_target_landing, bundle.DropSpeed);
	e_move waittill("movedone");
	self notify("landing");
	self animation::set_death_anim(self.rider_info.ExitHighLandDeathAnim);
	animation::Play(self.rider_info.ExitHighLandAnim, e_move, "tag_origin");
	self notify("landed");
	self Unlink();
	wait(0.05);
	e_move delete();
}

/*
	Name: exit_high_loop_anim
	Namespace: vehicle
	Checksum: 0x57DD9DEE
	Offset: 0x2A90
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function exit_high_loop_anim(e_parent)
{
	self endon("death");
	self endon("landing");
	while(1)
	{
		animation::Play(self.rider_info.ExitHighLoopAnim, e_parent, "tag_origin");
	}
}

/*
	Name: get_height
	Namespace: vehicle
	Checksum: 0xA63570E0
	Offset: 0x2AF0
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function get_height(e_ignore)
{
	if(!isdefined(e_ignore))
	{
		e_ignore = self;
	}
	trace = GroundTrace(self.origin + (0, 0, 10), self.origin + VectorScale((0, 0, -1), 10000), 0, e_ignore, 0);
	/#
		recordLine(self.origin + (0, 0, 10), trace["Dev Block strings are not supported"], (1, 0.5, 0), "Dev Block strings are not supported", self);
	#/
	return Distance(self.origin, trace["position"]);
}

/*
	Name: get_bundle
	Namespace: vehicle
	Checksum: 0xD1DC17F2
	Offset: 0x2BE8
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function get_bundle()
{
	/#
		Assert(isdefined(self.vehicleridersbundle), "Dev Block strings are not supported");
	#/
	return struct::get_script_bundle("vehicleriders", self.vehicleridersbundle);
}

/*
	Name: get_robot_bundle
	Namespace: vehicle
	Checksum: 0xB237F061
	Offset: 0x2C40
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function get_robot_bundle()
{
	/#
		Assert(isdefined(self.vehicleridersrobotbundle), "Dev Block strings are not supported");
	#/
	return struct::get_script_bundle("vehicleriders", self.vehicleridersrobotbundle);
}

/*
	Name: get_rider
	Namespace: vehicle
	Checksum: 0x6CEE42B7
	Offset: 0x2C98
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function get_rider(str_pos)
{
	if(isdefined(self.riders))
	{
		foreach(ai in self.riders)
		{
			if(isdefined(ai) && ai.rider_info.position == str_pos)
			{
				return ai;
			}
		}
	}
}

/*
	Name: _init_rider
	Namespace: vehicle
	Checksum: 0xBB12BCB5
	Offset: 0x2D58
	Size: 0xD3
	Parameters: 2
	Flags: Private
*/
function private _init_rider(vh, str_pos)
{
	/#
		Assert(isdefined(self.vehicle) || isdefined(vh), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(self.rider_info) || isdefined(str_pos), "Dev Block strings are not supported");
	#/
	if(isdefined(vh))
	{
		self.vehicle = vh;
	}
	if(!isdefined(str_pos))
	{
		str_pos = self.rider_info.position;
	}
	self.rider_info = self get_rider_info(self.vehicle, str_pos);
}

