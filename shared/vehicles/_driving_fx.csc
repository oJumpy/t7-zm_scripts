#using scripts\shared\audio_shared;

#namespace GroundFx;

/*
	Name: function_9b385ca5
	Namespace: GroundFx
	Checksum: 0xA01B94AE
	Offset: 0x230
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.id = undefined;
	self.handle = -1;
}

/*
	Name: function_5fba2032
	Namespace: GroundFx
	Checksum: 0x99EC1590
	Offset: 0x258
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: Play
	Namespace: GroundFx
	Checksum: 0x905DFBEF
	Offset: 0x268
	Size: 0x143
	Parameters: 4
	Flags: None
*/
function Play(localClientNum, vehicle, fx_id, fx_tag)
{
	if(!isdefined(fx_id))
	{
		if(self.handle > 0)
		{
			stopfx(localClientNum, self.handle);
		}
		self.id = undefined;
		self.handle = -1;
		return;
	}
	if(!isdefined(self.id))
	{
		self.id = fx_id;
		self.handle = PlayFXOnTag(localClientNum, self.id, vehicle, fx_tag);
	}
	else if(!isdefined(self.id) || self.id != fx_id)
	{
		if(self.handle > 0)
		{
			stopfx(localClientNum, self.handle);
		}
		self.id = fx_id;
		self.handle = PlayFXOnTag(localClientNum, self.id, vehicle, fx_tag);
	}
}

/*
	Name: stop
	Namespace: GroundFx
	Checksum: 0xC63CA503
	Offset: 0x3B8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function stop(localClientNum)
{
	if(self.handle > 0)
	{
		stopfx(localClientNum, self.handle);
	}
	self.id = undefined;
	self.handle = -1;
}

#namespace driving_fx;

/*
	Name: GroundFx
	Namespace: driving_fx
	Checksum: 0x556F9718
	Offset: 0x410
	Size: 0xE5
	Parameters: 0
	Flags: 6
*/
function private autoexec GroundFx()
{
	classes.GroundFx[0] = spawnstruct();
	classes.GroundFx[0].__vtable[-51025227] = &GroundFx::stop;
	classes.GroundFx[0].__vtable[1131512199] = &GroundFx::Play;
	classes.GroundFx[0].__vtable[1606033458] = &GroundFx::function_5fba2032;
	classes.GroundFx[0].__vtable[-1690805083] = &GroundFx::function_9b385ca5;
}

#namespace VehicleWheelFx;

/*
	Name: function_9b385ca5
	Namespace: VehicleWheelFx
	Checksum: 0xF9540FA9
	Offset: 0x500
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.name = "";
	self.tag_name = "";
}

/*
	Name: function_5fba2032
	Namespace: VehicleWheelFx
	Checksum: 0x99EC1590
	Offset: 0x530
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: init
	Namespace: VehicleWheelFx
	Checksum: 0x90CD92F7
	Offset: 0x540
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function init(_name, _tag_name)
{
	self.name = _name;
	self.tag_name = _tag_name;
	self.ground_fx = [];
	function_9b385ca5();
	self.ground_fx["skid"] = GroundFx;
	function_9b385ca5();
	self.ground_fx["tread"] = GroundFx;
	self.ground_fx["tread"].id = "";
	self.ground_fx["tread"].handle = -1;
}

/*
	Name: update
	Namespace: VehicleWheelFx
	Checksum: 0x643322EF
	Offset: 0x610
	Size: 0x4CB
	Parameters: 3
	Flags: None
*/
function update(localClientNum, vehicle, speed_fraction)
{
	if(vehicle.vehicleClass === "boat")
	{
		peelingout = 0;
		sliding = 0;
		trace = bullettrace(vehicle.origin + VectorScale((0, 0, 1), 60), vehicle.origin - VectorScale((0, 0, 1), 200), 0, vehicle);
		if(trace["fraction"] < 1)
		{
			surface = trace["surfacetype"];
		}
		else
		{
			stop(self.ground_fx["skid"]);
			stop(self.ground_fx["tread"]);
			return;
		}
	}
	else if(!vehicle iswheelcolliding(self.name))
	{
		stop(self.ground_fx["skid"]);
		stop(self.ground_fx["tread"]);
		return;
	}
	peelingout = vehicle IsWheelPeelingOut(self.name);
	sliding = vehicle IsWheelSliding(self.name);
	surface = vehicle GetWheelSurface(self.name);
	origin = vehicle GetTagOrigin(self.tag_name) + (0, 0, 1);
	angles = vehicle GetTagAngles(self.tag_name);
	fwd = AnglesToForward(angles);
	right = AnglesToRight(angles);
	rumble = 0;
	if(peelingout)
	{
		peel_fx = vehicle driving_fx::get_wheel_fx("peel", surface);
		if(isdefined(peel_fx))
		{
			playFX(localClientNum, peel_fx, origin, fwd * -1);
			rumble = 1;
		}
	}
	if(sliding)
	{
		skid_fx = vehicle driving_fx::get_wheel_fx("skid", surface);
		Play(self.ground_fx["skid"], localClientNum, vehicle, skid_fx);
		vehicle.skidding = 1;
		rumble = 1;
	}
	else
	{
		stop(self.ground_fx["skid"]);
	}
	if(speed_fraction > 0.1)
	{
		tread_fx = vehicle driving_fx::get_wheel_fx("tread", surface);
		Play(self.ground_fx["tread"], localClientNum, vehicle, tread_fx);
	}
	else
	{
		stop(self.ground_fx["tread"]);
	}
	if(rumble)
	{
		if(vehicle isLocalClientDriver(localClientNum))
		{
			player = GetLocalPlayer(localClientNum);
			player PlayRumbleOnEntity(localClientNum, "reload_small");
		}
	}
}

#namespace driving_fx;

/*
	Name: VehicleWheelFx
	Namespace: driving_fx
	Checksum: 0xA60BACC7
	Offset: 0xAE8
	Size: 0xE5
	Parameters: 0
	Flags: 6
*/
function private autoexec VehicleWheelFx()
{
	classes.VehicleWheelFx[0] = spawnstruct();
	classes.VehicleWheelFx[0].__vtable[-558052070] = &VehicleWheelFx::update;
	classes.VehicleWheelFx[0].__vtable[-1017222485] = &VehicleWheelFx::init;
	classes.VehicleWheelFx[0].__vtable[1606033458] = &VehicleWheelFx::function_5fba2032;
	classes.VehicleWheelFx[0].__vtable[-1690805083] = &VehicleWheelFx::function_9b385ca5;
}

#namespace vehicle_camera_fx;

/*
	Name: function_9b385ca5
	Namespace: vehicle_camera_fx
	Checksum: 0xFC47A4E4
	Offset: 0xBD8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.quake_time_min = 0.5;
	self.quake_time_max = 1;
	self.quake_strength_min = 0.1;
	self.quake_strength_max = 0.115;
	self.rumble_name = "";
}

/*
	Name: function_5fba2032
	Namespace: vehicle_camera_fx
	Checksum: 0x99EC1590
	Offset: 0xC38
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: init
	Namespace: vehicle_camera_fx
	Checksum: 0xC5554CEC
	Offset: 0xC48
	Size: 0x9B
	Parameters: 5
	Flags: None
*/
function init(t_min, t_max, s_min, s_max, rumble)
{
	if(!isdefined(rumble))
	{
		rumble = "";
	}
	self.quake_time_min = t_min;
	self.quake_time_max = t_max;
	self.quake_strength_min = s_min;
	self.quake_strength_max = s_max;
	if(rumble != "")
	{
	}
	else
	{
	}
	self.rumble_name = self.rumble_name;
}

/*
	Name: update
	Namespace: vehicle_camera_fx
	Checksum: 0x4DA12EC7
	Offset: 0xCF0
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function update(localClientNum, vehicle, speed_fraction)
{
	if(vehicle isLocalClientDriver(localClientNum))
	{
		player = GetLocalPlayer(localClientNum);
		if(speed_fraction > 0)
		{
			strength = RandomFloatRange(self.quake_strength_min, self.quake_strength_max) * speed_fraction;
			time = RandomFloatRange(self.quake_time_min, self.quake_time_max);
			player Earthquake(strength, time, player.origin, 500);
			if(self.rumble_name != "" && speed_fraction > 0.5)
			{
				if(RandomInt(100) < 10)
				{
					player PlayRumbleOnEntity(localClientNum, self.rumble_name);
				}
			}
		}
	}
}

#namespace driving_fx;

/*
	Name: vehicle_camera_fx
	Namespace: driving_fx
	Checksum: 0x264336C3
	Offset: 0xE48
	Size: 0xE5
	Parameters: 0
	Flags: 6
*/
function private autoexec vehicle_camera_fx()
{
	classes.vehicle_camera_fx[0] = spawnstruct();
	classes.vehicle_camera_fx[0].__vtable[-558052070] = &vehicle_camera_fx::update;
	classes.vehicle_camera_fx[0].__vtable[-1017222485] = &vehicle_camera_fx::init;
	classes.vehicle_camera_fx[0].__vtable[1606033458] = &vehicle_camera_fx::function_5fba2032;
	classes.vehicle_camera_fx[0].__vtable[-1690805083] = &vehicle_camera_fx::function_9b385ca5;
}

/*
	Name: vehicle_enter
	Namespace: driving_fx
	Checksum: 0xC478FBF5
	Offset: 0xF38
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function vehicle_enter(localClientNum)
{
	self endon("entityshutdown");
	while(1)
	{
		self waittill("enter_vehicle", User);
		if(isdefined(User) && User isPlayer())
		{
			self thread collision_thread(localClientNum);
			self thread jump_landing_thread(localClientNum);
		}
	}
}

/*
	Name: speed_fx
	Namespace: driving_fx
	Checksum: 0xF1B6C61A
	Offset: 0xFD0
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function speed_fx(localClientNum)
{
	self endon("entityshutdown");
	self endon("exit_vehicle");
	while(1)
	{
		curspeed = self getspeed();
		curspeed = 0.0005 * curspeed;
		curspeed = Abs(curspeed);
		if(curspeed > 0.001)
		{
			SetSavedDvar("r_speedBlurFX_enable", "1");
			SetSavedDvar("r_speedBlurAmount", curspeed);
		}
		else
		{
			SetSavedDvar("r_speedBlurFX_enable", "0");
		}
		wait(0.05);
	}
}

/*
	Name: play_driving_fx
	Namespace: driving_fx
	Checksum: 0x5089F7A7
	Offset: 0x10D8
	Size: 0x41F
	Parameters: 1
	Flags: None
*/
function play_driving_fx(localClientNum)
{
	self endon("entityshutdown");
	self thread vehicle_enter(localClientNum);
	if(self.surfacefxdeftype == "")
	{
		return;
	}
	if(!isdefined(self.wheel_fx))
	{
		wheel_names = Array("front_left", "front_right", "back_left", "back_right");
		wheel_tag_names = Array("tag_wheel_front_left", "tag_wheel_front_right", "tag_wheel_back_left", "tag_wheel_back_right");
		if(isdefined(self.scriptvehicletype) && self.scriptvehicletype == "raps")
		{
			wheel_names = Array("front_left");
			wheel_tag_names = Array("tag_origin");
		}
		else if(self.vehicleClass == "boat")
		{
			wheel_names = Array("tag_origin");
			wheel_tag_names = Array("tag_origin");
		}
		self.wheel_fx = [];
		for(i = 0; i < wheel_names.size; i++)
		{
			function_9b385ca5();
			self.wheel_fx[i] = VehicleWheelFx;
			init(self.wheel_fx[i], wheel_names[i]);
		}
		self.camera_fx = [];
		function_9b385ca5();
		self.camera_fx["speed"] = vehicle_camera_fx;
		init(self.camera_fx["speed"], 0.5, 1, 0.1, 0.115);
		function_9b385ca5();
		self.camera_fx["skid"] = vehicle_camera_fx;
		init(self.camera_fx["skid"], 0.25, 0.35, 0.1);
	}
	self.last_screen_dirt = 0;
	self.screen_dirt_delay = 0;
	speed_fraction = 0;
	while(1)
	{
		speed = length(self GetVelocity());
		if(speed < 0)
		{
		}
		else
		{
		}
		max_speed = self GetMaxSpeed();
		if(max_speed > 0)
		{
		}
		else
		{
		}
		speed_fraction = 0;
		self.skidding = 0;
		for(i = 0; i < self.wheel_fx.size; i++)
		{
			update(self.wheel_fx[i], localClientNum, self);
		}
		wait(0.1);
	}
}

/*
	Name: get_wheel_fx
	Namespace: driving_fx
	Checksum: 0x2887D680
	Offset: 0x1500
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function get_wheel_fx(type, surface)
{
	fxArray = undefined;
	if(type == "tread")
	{
		fxArray = self.treadfxnamearray;
	}
	else if(type == "peel")
	{
		fxArray = self.peelfxnamearray;
	}
	else if(type == "skid")
	{
		fxArray = self.skidfxnamearray;
	}
	if(isdefined(fxArray))
	{
		return fxArray[surface];
	}
	return undefined;
}

/*
	Name: play_driving_fx_firstperson
	Namespace: driving_fx
	Checksum: 0x9ED9B95B
	Offset: 0x15A0
	Size: 0x1BB
	Parameters: 3
	Flags: None
*/
function play_driving_fx_firstperson(localClientNum, speed, speed_fraction)
{
	if(speed > 0 && speed_fraction >= 0.25)
	{
		viewAngles = GetLocalClientAngles(localClientNum);
		pitch = AngleClamp180(viewAngles[0]);
		if(pitch > -10)
		{
			current_additional_time = 0;
			if(pitch < 10)
			{
				current_additional_time = 1000 * pitch - 10 / -10 - 10;
			}
			if(self.last_screen_dirt + self.screen_dirt_delay + current_additional_time < GetRealTime())
			{
				screen_fx_type = self correct_surface_type_for_screen_fx();
				if(screen_fx_type == "dirt")
				{
					play_screen_fx_dirt(localClientNum);
				}
				else
				{
					play_screen_fx_dust(localClientNum);
				}
				self.last_screen_dirt = GetRealTime();
				self.screen_dirt_delay = randomIntRange(250, 500);
			}
		}
	}
}

/*
	Name: collision_thread
	Namespace: driving_fx
	Checksum: 0x589A0041
	Offset: 0x1768
	Size: 0x267
	Parameters: 1
	Flags: None
*/
function collision_thread(localClientNum)
{
	self endon("entityshutdown");
	self endon("exit_vehicle");
	while(1)
	{
		self waittill("veh_collision", hip, hitn, hit_intensity);
		if(self isLocalClientDriver(localClientNum))
		{
			player = GetLocalPlayer(localClientNum);
			if(isdefined(self.driving_fx_collision_override))
			{
				self [[self.driving_fx_collision_override]](localClientNum, player, hip, hitn, hit_intensity);
			}
			else if(isdefined(player) && isdefined(hit_intensity))
			{
				if(hit_intensity > self.heavyCollisionSpeed)
				{
					volume = get_impact_vol_from_speed();
					if(isdefined(self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_hd";
					}
					else
					{
						alias = "veh_default_suspension_lg_hd";
					}
					id = playsound(0, alias, self.origin, volume);
					if(isdefined(self.heavyCollisionRumble))
					{
						player PlayRumbleOnEntity(localClientNum, self.heavyCollisionRumble);
					}
				}
				else if(hit_intensity > self.lightCollisionSpeed)
				{
					volume = get_impact_vol_from_speed();
					if(isdefined(self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_lt";
					}
					else
					{
						alias = "veh_default_suspension_lg_lt";
					}
					id = playsound(0, alias, self.origin, volume);
					if(isdefined(self.lightCollisionRumble))
					{
						player PlayRumbleOnEntity(localClientNum, self.lightCollisionRumble);
					}
				}
			}
		}
	}
}

/*
	Name: jump_landing_thread
	Namespace: driving_fx
	Checksum: 0xEBD6AE0A
	Offset: 0x19D8
	Size: 0x167
	Parameters: 1
	Flags: None
*/
function jump_landing_thread(localClientNum)
{
	self endon("entityshutdown");
	self endon("exit_vehicle");
	while(1)
	{
		self waittill("veh_landed");
		if(self isLocalClientDriver(localClientNum))
		{
			player = GetLocalPlayer(localClientNum);
			if(isdefined(player))
			{
				if(isdefined(self.driving_fx_jump_landing_override))
				{
					self [[self.driving_fx_jump_landing_override]](localClientNum, player);
				}
				else
				{
					volume = get_impact_vol_from_speed();
					if(isdefined(self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_hd";
					}
					else
					{
						alias = "veh_default_suspension_lg_hd";
					}
					id = playsound(0, alias, self.origin, volume);
					if(isdefined(self.jumpLandingRumble))
					{
						player PlayRumbleOnEntity(localClientNum, self.jumpLandingRumble);
					}
				}
			}
		}
	}
}

/*
	Name: suspension_thread
	Namespace: driving_fx
	Checksum: 0xA0CEDF44
	Offset: 0x1B48
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function suspension_thread(localClientNum)
{
	self endon("entityshutdown");
	self endon("exit_vehicle");
	while(1)
	{
		self waittill("veh_suspension_limit_activated");
		if(self isLocalClientDriver(localClientNum))
		{
			player = GetLocalPlayer(localClientNum);
			if(isdefined(player))
			{
				volume = get_impact_vol_from_speed();
				if(isdefined(self.sounddef))
				{
					alias = self.sounddef + "_suspension_lg_lt";
				}
				else
				{
					alias = "veh_default_suspension_lg_lt";
				}
				id = playsound(0, alias, self.origin, volume);
				player PlayRumbleOnEntity(localClientNum, "damage_light");
			}
		}
	}
}

/*
	Name: get_impact_vol_from_speed
	Namespace: driving_fx
	Checksum: 0xF01DBE94
	Offset: 0x1C88
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function get_impact_vol_from_speed()
{
	curspeed = self getspeed();
	maxspeed = self GetMaxSpeed();
	volume = audio::scale_speed(0, maxspeed, 0, 1, curspeed);
	volume = volume * volume * volume;
	return volume;
}

/*
	Name: any_wheel_colliding
	Namespace: driving_fx
	Checksum: 0x7586DCC2
	Offset: 0x1D28
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function any_wheel_colliding()
{
	return self iswheelcolliding("front_left") || self iswheelcolliding("front_right") || self iswheelcolliding("back_left") || self iswheelcolliding("back_right");
}

/*
	Name: dirt_surface_type
	Namespace: driving_fx
	Checksum: 0x3828985E
	Offset: 0x1DB8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function dirt_surface_type(surface_type)
{
	switch(surface_type)
	{
		case "dirt":
		case "foliage":
		case "grass":
		case "gravel":
		case "mud":
		case "sand":
		case "snow":
		case "water":
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: correct_surface_type_for_screen_fx
	Namespace: driving_fx
	Checksum: 0x83E32467
	Offset: 0x1E28
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function correct_surface_type_for_screen_fx()
{
	right_rear = self GetWheelSurface("back_right");
	left_rear = self GetWheelSurface("back_left");
	if(dirt_surface_type(right_rear))
	{
		return "dirt";
	}
	if(dirt_surface_type(left_rear))
	{
		return "dirt";
	}
	return "dust";
}

/*
	Name: play_screen_fx_dirt
	Namespace: driving_fx
	Checksum: 0xC2E449D9
	Offset: 0x1ED0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function play_screen_fx_dirt(localClientNum)
{
}

/*
	Name: play_screen_fx_dust
	Namespace: driving_fx
	Checksum: 0x6D06D3AA
	Offset: 0x1EE8
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function play_screen_fx_dust(localClientNum)
{
}

