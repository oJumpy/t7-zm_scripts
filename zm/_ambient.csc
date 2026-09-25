#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;

#namespace ambient;

/*
	Name: __init__sytem__
	Namespace: ambient
	Checksum: 0x79F10783
	Offset: 0x3E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ambient", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ambient
	Checksum: 0x2649E2AA
	Offset: 0x420
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localclient_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: ambient
	Checksum: 0x7FECC266
	Offset: 0x450
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function on_player_connect(localClientNum)
{
	thread ceiling_fans_init(localClientNum);
	thread clocks_init(localClientNum);
	thread spin_anemometers(localClientNum);
}

/*
	Name: setup_point_fx
	Namespace: ambient
	Checksum: 0x4908C4C1
	Offset: 0x4B0
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function setup_point_fx(point, fx_id)
{
	if(isdefined(point.script_fxid))
	{
		fx_id = point.script_fxid;
	}
	point.fx_id = fx_id;
	if(isdefined(point.angles))
	{
		point.FORWARD = AnglesToForward(point.angles);
		point.up = anglesToUp(point.angles);
	}
	else
	{
		point.angles = (0, 0, 0);
		point.FORWARD = (0, 0, 0);
		point.up = (0, 0, 0);
	}
	if(point.targetname == "flak_fire_fx")
	{
		level thread ambient_flak_think(point);
	}
	if(point.targetname == "fake_fire_fx")
	{
		level thread ambient_fakefire_think(point);
	}
}

/*
	Name: ambient_flak_think
	Namespace: ambient
	Checksum: 0x5FAB33B5
	Offset: 0x620
	Size: 0x1D7
	Parameters: 1
	Flags: None
*/
function ambient_flak_think(point)
{
	amount = undefined;
	speed = undefined;
	night = 0;
	min_delay = 0.4;
	max_delay = 4;
	min_burst_time = 1;
	max_burst_time = 3;
	point.is_firing = 0;
	level thread ambient_flak_rotate(point);
	level thread ambient_flak_flash(point, min_burst_time, max_burst_time);
	for(;;)
	{
		for(timer = RandomFloatRange(min_burst_time, max_burst_time); timer > 0;  = RandomFloatRange(min_burst_time, max_burst_time))
		{
			point.is_firing = 1;
			playFX(0, level._effect[point.fx_id], point.origin, point.FORWARD, point.up);
			thread sound::play_in_space(0, "wpn_triple25_fire", point.origin);
			wait(0.2);
		}
		point.is_firing = 0;
		wait(RandomFloatRange(min_delay, max_delay));
	}
}

/*
	Name: ambient_flak_rotate
	Namespace: ambient
	Checksum: 0x12837222
	Offset: 0x800
	Size: 0x227
	Parameters: 1
	Flags: None
*/
function ambient_flak_rotate(point)
{
	min_pitch = 30;
	max_pitch = 80;
	if(isdefined(point.angles))
	{
		pointangles = point.angles;
	}
	else
	{
		pointangles = (0, 0, 0);
	}
	for(;;)
	{
		time = RandomFloatRange(0.5, 2);
		steps = time * 10;
		random_angle = (randomIntRange(min_pitch, max_pitch) * -1, RandomInt(360), 0);
		FORWARD = AnglesToForward(random_angle);
		up = anglesToUp(random_angle);
		diff_forward = FORWARD - point.FORWARD / steps;
		diff_up = up - point.up / steps;
		for(i = 0; i < steps; i++)
		{
			point.FORWARD = point.FORWARD + diff_forward;
			point.up = point.up + diff_up;
			wait(0.1);
		}
		point.FORWARD = FORWARD;
		point.up = up;
	}
}

/*
	Name: ambient_flak_flash
	Namespace: ambient
	Checksum: 0xCEA300E9
	Offset: 0xA30
	Size: 0x1BF
	Parameters: 3
	Flags: None
*/
function ambient_flak_flash(point, min_burst_time, max_burst_time)
{
	min_dist = 5000;
	max_dist = 6500;
	if(isdefined(point.script_mindist))
	{
		min_dist = point.script_mindist;
	}
	if(isdefined(point.script_maxdist))
	{
		max_dist = point.script_maxdist;
	}
	min_burst_time = 0.25;
	max_burst_time = 1;
	fxpos = undefined;
	while(1)
	{
		if(!point.is_firing)
		{
			wait(0.25);
			continue;
		}
		fxpos = point.origin + VectorScale(point.FORWARD, randomIntRange(min_dist, max_dist));
		playFX(0, level._effect["flak_burst_single"], fxpos);
		if(isdefined(level.timeofday) && (level.timeofday == "evening" || level.timeofday == "night"))
		{
			playFX(0, level._effect["flak_cloudflash_night"], fxpos);
		}
		wait(RandomFloatRange(min_burst_time, max_burst_time));
	}
}

/*
	Name: ambient_fakefire_think
	Namespace: ambient
	Checksum: 0x1D4FE2CA
	Offset: 0xBF8
	Size: 0x7BF
	Parameters: 1
	Flags: None
*/
function ambient_fakefire_think(point)
{
	fireSound = undefined;
	weapType = undefined;
	burstMin = undefined;
	burstMax = undefined;
	betweenShotsMin = undefined;
	betweenShotsMax = undefined;
	reloadTimeMin = undefined;
	reloadTimeMax = undefined;
	soundChance = undefined;
	if(!isdefined(point.weaponinfo))
	{
		point.weaponinfo = "axis_turret";
	}
	switch(point.weaponinfo)
	{
		case "allies_assault":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				fireSound = "weap_bar_fire";
			}
			else
			{
				fireSound = "weap_dp28_fire_plr";
			}
			burstMin = 16;
			burstMax = 24;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 4;
			reloadTimeMax = 7;
			soundChance = 75;
			weapType = "assault";
			break;
		}
		case "axis_assault":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				fireSound = "weap_mp44_fire";
			}
			else
			{
				fireSound = "weap_type99_fire";
			}
			burstMin = 16;
			burstMax = 24;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 4;
			reloadTimeMax = 7;
			soundChance = 75;
			weapType = "assault";
			break;
		}
		case "allies_rifle":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				fireSound = "weap_m1garand_fire";
			}
			else
			{
				fireSound = "weap_mosinnagant_fire";
			}
			burstMin = 1;
			burstMax = 3;
			betweenShotsMin = 0.8;
			betweenShotsMax = 1.3;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "rifle";
			break;
		}
		case "axis_rifle":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				fireSound = "weap_kar98k_fire";
			}
			else
			{
				fireSound = "weap_arisaka_fire";
			}
			burstMin = 1;
			burstMax = 3;
			betweenShotsMin = 0.8;
			betweenShotsMax = 1.3;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "rifle";
			break;
		}
		case "allies_smg":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				fireSound = "weap_thompson_fire";
			}
			else
			{
				fireSound = "weap_ppsh_fire";
			}
			burstMin = 14;
			burstMax = 28;
			betweenShotsMin = 0.08;
			betweenShotsMax = 0.12;
			reloadTimeMin = 2;
			reloadTimeMax = 5;
			soundChance = 75;
			weapType = "smg";
			break;
		}
		case "axis_smg":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				fireSound = "weap_mp40_fire";
			}
			else
			{
				fireSound = "weap_type100_fire";
			}
			burstMin = 14;
			burstMax = 28;
			betweenShotsMin = 0.08;
			betweenShotsMax = 0.12;
			reloadTimeMin = 2;
			reloadTimeMax = 5;
			soundChance = 75;
			weapType = "smg";
			break;
		}
		case "allies_turret":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				fireSound = "weap_30cal_fire";
			}
			else
			{
				fireSound = "weap_dp28_fire_plr";
			}
			burstMin = 60;
			burstMax = 90;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "turret";
			break;
		}
		case "axis_turret":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				fireSound = "weap_bar_fire";
			}
			else
			{
				fireSound = "weap_type92_fire";
			}
			burstMin = 60;
			burstMax = 90;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "turret";
			break;
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + point.weaponinfo + "Dev Block strings are not supported");
			#/
		}
	}
	while(1)
	{
		burst = randomIntRange(burstMin, burstMax);
		for(i = 0; i < burst; i++)
		{
			traceDist = 10000;
			target = point.origin + VectorScale(AnglesToForward(point.angles + (-3 + RandomInt(6), -5 + RandomInt(10), 0)), traceDist);
			if(RandomInt(100) <= 20)
			{
				bulletTracer(point.origin, target);
			}
			playFX(0, level._effect[point.fx_id], point.origin, point.FORWARD);
			wait(RandomFloatRange(betweenShotsMin, betweenShotsMax));
		}
		wait(RandomFloatRange(reloadTimeMin, reloadTimeMax));
	}
}

/*
	Name: ceiling_fans_init
	Namespace: ambient
	Checksum: 0x22D48721
	Offset: 0x13C0
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function ceiling_fans_init(clientNum)
{
	fan_array = GetEntArray(clientNum, "ceiling_fan", "targetname");
	if(isdefined(fan_array))
	{
		/#
			println("Dev Block strings are not supported" + fan_array.size);
		#/
		Array::thread_all(fan_array, &spin_fan);
	}
}

/*
	Name: spin_fan
	Namespace: ambient
	Checksum: 0x58E212B5
	Offset: 0x1458
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function spin_fan()
{
	self endon("entityshutdown");
	if(!isdefined(self.speed))
	{
		self.speed = randomIntRange(1, 100);
		self.speed = self.speed % 10 + 1;
	}
	if(self.speed < 1)
	{
		self.speed = randomIntRange(1, 100);
		self.speed = self.speed % 10 + 1;
	}
	do_wobble = 0;
	wobble = self.script_noteworthy;
	if(isdefined(wobble))
	{
		if(wobble == "wobble")
		{
			do_wobble = 1;
			self.wobble_speed = self.speed * 0.5;
		}
	}
	while(1)
	{
		if(!do_wobble)
		{
			self RotateYaw(180, self.speed);
			self waittill("rotatedone");
		}
		else
		{
			self RotateYaw(340, self.speed);
			self waittill("rotatedone");
			self RotateYaw(20, self.wobble_speed);
			self waittill("rotatedone");
		}
	}
}

/*
	Name: clocks_init
	Namespace: ambient
	Checksum: 0xF4DD434
	Offset: 0x1610
	Size: 0x3FB
	Parameters: 1
	Flags: None
*/
function clocks_init(clientNum)
{
	curr_time = GetSystemTime();
	hours = curr_time[0];
	if(hours > 12)
	{
		hours = hours - 12;
	}
	if(hours == 0)
	{
		hours = 12;
	}
	minutes = curr_time[1];
	seconds = curr_time[2];
	hour_hand = GetEntArray(clientNum, "hour_hand", "targetname");
	hour_values = [];
	hour_values["hand_time"] = hours;
	hour_values["rotate"] = 30;
	hour_values["rotate_bit"] = 0.008333334;
	hour_values["first_rotate"] = minutes * 60 + seconds * hour_values["rotate_bit"];
	minute_hand = GetEntArray(clientNum, "minute_hand", "targetname");
	minute_values = [];
	minute_values["hand_time"] = minutes;
	minute_values["rotate"] = 6;
	minute_values["rotate_bit"] = 0.1;
	minute_values["first_rotate"] = seconds * minute_values["rotate_bit"];
	second_hand = GetEntArray(clientNum, "second_hand", "targetname");
	second_values = [];
	second_values["hand_time"] = seconds;
	second_values["rotate"] = 6;
	second_values["rotate_bit"] = 6;
	hour_hand_array = GetEntArray(clientNum, "hour_hand", "targetname");
	if(isdefined(hour_hand_array))
	{
		/#
			println("Dev Block strings are not supported" + hour_hand_array.size);
		#/
		Array::thread_all(hour_hand_array, &clock_run, hour_values);
	}
	minute_hand_array = GetEntArray(clientNum, "minute_hand", "targetname");
	if(isdefined(minute_hand_array))
	{
		/#
			println("Dev Block strings are not supported" + minute_hand_array.size);
		#/
		Array::thread_all(minute_hand_array, &clock_run, minute_values);
	}
	second_hand_array = GetEntArray(clientNum, "second_hand", "targetname");
	if(isdefined(second_hand_array))
	{
		/#
			println("Dev Block strings are not supported" + second_hand_array.size);
		#/
		Array::thread_all(second_hand_array, &clock_run, second_values);
	}
}

/*
	Name: clock_run
	Namespace: ambient
	Checksum: 0x31571B4A
	Offset: 0x1A18
	Size: 0x3AB
	Parameters: 1
	Flags: None
*/
function clock_run(time_values)
{
	self endon("entityshutdown");
	if(isdefined(self.script_noteworthy))
	{
		hour = time_values["hand_time"];
		curr_time = GetSystemTime(1);
		switch(ToLower(self.script_noteworthy))
		{
			case "honolulu":
			{
				hour = curr_time[0] - 10;
				break;
			}
			case "alaska":
			{
				hour = curr_time[0] - 9;
				break;
			}
			case "los angeles":
			{
				hour = curr_time[0] - 8;
				break;
			}
			case "denver":
			{
				hour = curr_time[0] - 7;
				break;
			}
			case "chicago":
			{
				hour = curr_time[0] - 6;
				break;
			}
			case "new york":
			{
				hour = curr_time[0] - 5;
				break;
			}
			case "halifax":
			{
				hour = curr_time[0] - 4;
				break;
			}
			case "greenland":
			{
				hour = curr_time[0] - 3;
				break;
			}
			case "london":
			{
				hour = curr_time[0];
				break;
			}
			case "paris":
			{
				hour = curr_time[0] + 1;
				break;
			}
			case "helsinki":
			{
				hour = curr_time[0] + 2;
				break;
			}
			case "moscow":
			{
				hour = curr_time[0] + 3;
				break;
			}
			case "vietnam":
			{
				hour = curr_time[0] + 7;
				break;
			}
			case "china":
			{
				hour = curr_time[0] + 8;
				break;
			}
		}
		if(hour < 1)
		{
			hour = hour + 12;
		}
		if(hour > 12)
		{
			hour = hour - 12;
		}
		time_values["hand_time"] = hour;
	}
	self RotatePitch(time_values["hand_time"] * time_values["rotate"], 0.05);
	self waittill("rotatedone");
	if(isdefined(time_values["first_rotate"]))
	{
		self RotatePitch(time_values["first_rotate"], 0.05);
		self waittill("rotatedone");
	}
	prev_time = GetSystemTime();
	while(1)
	{
		curr_time = GetSystemTime();
		if(prev_time != curr_time)
		{
			self RotatePitch(time_values["rotate_bit"], 0.05);
			prev_time = curr_time;
		}
		wait(1);
	}
}

/*
	Name: spin_anemometers
	Namespace: ambient
	Checksum: 0x9157E31B
	Offset: 0x1DD0
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function spin_anemometers(clientNum)
{
	spoon_spinners = GetEntArray(clientNum, "spinner1", "targetname");
	flat_spinners = GetEntArray(clientNum, "spinner2", "targetname");
	if(isdefined(spoon_spinners))
	{
		/#
			println("Dev Block strings are not supported" + spoon_spinners.size);
		#/
		Array::thread_all(spoon_spinners, &spoon_spin_func);
	}
	if(isdefined(flat_spinners))
	{
		/#
			println("Dev Block strings are not supported" + flat_spinners.size);
		#/
		Array::thread_all(flat_spinners, &arrow_spin_func);
	}
}

/*
	Name: spoon_spin_func
	Namespace: ambient
	Checksum: 0x3F78AB4B
	Offset: 0x1EE8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function spoon_spin_func()
{
	self endon("entityshutdown");
	if(isdefined(self.script_float))
	{
		model_speed = self.script_float;
		continue;
	}
	model_speed = 2;
	while(1)
	{
		speed = RandomFloatRange(model_speed * 0.6, model_speed);
		self RotateYaw(1200, speed);
		self waittill("rotatedone");
	}
}

/*
	Name: arrow_spin_func
	Namespace: ambient
	Checksum: 0xE3BBC1A8
	Offset: 0x1F98
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function arrow_spin_func()
{
	self endon("entityshutdown");
	if(isdefined(self.script_int))
	{
		model_direction_change = self.script_int;
	}
	else
	{
		model_direction_change = 25;
	}
	if(isdefined(self.script_float))
	{
		model_speed = self.script_float;
		continue;
	}
	model_speed = 0.8;
	while(1)
	{
		direction_change = model_direction_change + randomIntRange(-11, 11);
		speed_change = RandomFloatRange(model_speed * 0.3, model_speed);
		self RotateYaw(direction_change, speed_change);
		self waittill("rotatedone");
		self RotateYaw(direction_change * -1, speed_change);
		self waittill("rotatedone");
	}
}

