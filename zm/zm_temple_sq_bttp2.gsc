#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_bttp2;

/*
	Name: init
	Namespace: zm_temple_sq_bttp2
	Checksum: 0xD186088F
	Offset: 0x260
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("sq", "bttp2", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "bttp2", 300, &bttp2_timer_func);
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_bttp2
	Checksum: 0x4EDCD52F
	Offset: 0x2F0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function init_stage()
{
	level notify("bttp2_start");
	level._num_dials_correct = 0;
	Dials = GetEntArray("sq_bttp2_dial", "targetname");
	level._num_dials_to_match = Dials.size;
	Array::thread_all(Dials, &dial_handler);
	zm_temple_sq_brock::delete_radio();
	if(level flag::get("radio_7_played"))
	{
		level thread delayed_start_skit("tt7a");
	}
	else
	{
		level thread delayed_start_skit("tt7b");
	}
	level thread bolt_from_the_blue();
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_bttp2
	Checksum: 0x9A0C0D1D
	Offset: 0x400
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function delayed_start_skit(skit)
{
	wait(0.5);
	level thread zm_temple_sq_skits::start_skit(skit);
}

/*
	Name: bolt_from_the_blue
	Namespace: zm_temple_sq_bttp2
	Checksum: 0x9AE07DB1
	Offset: 0x438
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function bolt_from_the_blue()
{
	wait(25);
	a_struct = struct::get("sq_bttp2_bolt_from_the_blue_a", "targetname");
	b_struct = struct::get("sq_bttp2_bolt_from_the_blue_b", "targetname");
	a = spawn("script_model", a_struct.origin);
	a SetModel("tag_origin");
	util::wait_network_frame();
	b = spawn("script_model", b_struct.origin);
	b SetModel("tag_origin");
	util::wait_network_frame();
	original_origin = a.origin;
	for(i = 0; i < 7; i++)
	{
		yaw = RandomFloat(360);
		r = RandomFloatRange(500, 1000);
		amntx = cos(yaw) * r;
		amnty = sin(yaw) * r;
		a.origin = original_origin + (amntx, amnty, 0);
		zm_temple_sq::bounce_from_a_to_b(a, b, 0);
		wait(0.55);
	}
	wait(5);
	a.origin = original_origin;
	zm_temple_sq::bounce_from_a_to_b(b, a, 1);
	wait(1);
	a delete();
	b delete();
}

/*
	Name: bttp2_timer_func
	Namespace: zm_temple_sq_bttp2
	Checksum: 0xF5FFD8ED
	Offset: 0x6F8
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function bttp2_timer_func()
{
	if(level flag::get("radio_7_played"))
	{
		return 300;
	}
	else
	{
		return 60;
	}
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_bttp2
	Checksum: 0x3306C818
	Offset: 0x738
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function stage_logic()
{
	while(level._num_dials_correct != level._num_dials_to_match)
	{
		wait(0.1);
	}
	level notify("raise_crystal_1");
	level notify("raise_crystal_2");
	level notify("raise_crystal_3");
	level notify("raise_crystal_4");
	level notify("raise_crystal_5");
	level notify("raise_crystal_6", 1);
	level waittill("raised_crystal_6");
	wait(5);
	zm_sidequests::stage_completed("sq", "bttp2");
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_bttp2
	Checksum: 0x935DB095
	Offset: 0x7F0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function exit_stage(success)
{
	Dials = GetEntArray("sq_bttp2_dial", "targetname");
	Array::thread_all(Dials, &dud_dial_handler);
	if(success)
	{
		zm_temple_sq_brock::create_radio(8);
	}
	else
	{
		zm_temple_sq_brock::create_radio(7, &zm_temple_sq_brock::radio7_override);
		level thread zm_temple_sq_skits::fail_skit();
	}
}

/*
	Name: dial_trigger
	Namespace: zm_temple_sq_bttp2
	Checksum: 0xA5D758C
	Offset: 0x8B8
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function dial_trigger()
{
	level endon("bttp2_start");
	level endon("sq_bttp2_over");
	while(1)
	{
		self waittill("triggered", who);
		self.owner_ent notify("triggered", who);
	}
}

/*
	Name: dial_handler
	Namespace: zm_temple_sq_bttp2
	Checksum: 0xDE0257D5
	Offset: 0x918
	Size: 0x253
	Parameters: 0
	Flags: None
*/
function dial_handler()
{
	if(!level flag::get("radio_7_played"))
	{
		self thread dud_dial_handler("We don't know what we're doing.");
	}
	level endon("sq_bttp2_over");
	self.angles = self.original_angles;
	pos = randomIntRange(0, 3);
	if(pos == self.script_int)
	{
		pos = pos + 1 % 4;
	}
	self RotatePitch(90 * pos, 0.01);
	correct = 0;
	while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
	{
		self waittill("triggered", who);
		self playsound("evt_sq_bttp2_wheel_turn");
		self RotatePitch(90, 0.25);
		self waittill("rotatedone");
		pos = pos + 1 % 4;
		if(pos == self.script_int)
		{
			level._num_dials_correct++;
			/#
				print3d(self.origin, "Dev Block strings are not supported", VectorScale((0, 1, 0), 255), 10);
			#/
			correct = 1;
			if(isdefined(who) && isPlayer(who))
			{
				if(level._num_dials_correct == level._num_dials_to_match)
				{
					who thread zm_audio::create_and_play_dialog("eggs", "quest7", 0);
				}
			}
		}
		else if(correct)
		{
			correct = 0;
			level._num_dials_correct--;
		}
		wait(0.1);
	}
}

/*
	Name: dud_dial_handler
	Namespace: zm_temple_sq_bttp2
	Checksum: 0xC7F79E9D
	Offset: 0xB78
	Size: 0x127
	Parameters: 1
	Flags: None
*/
function dud_dial_handler(dont_know_alias)
{
	level endon("bttp2_start");
	self.trigger thread dial_trigger();
	if(!isdefined(self.original_angles))
	{
		self.original_angles = self.angles;
	}
	self.angles = self.original_angles;
	rot = randomIntRange(0, 3);
	self RotatePitch(rot * 90, 0.01);
	while(1)
	{
		self waittill("triggered");
		self playsound("evt_sq_bttp2_wheel_turn");
		if(isdefined(dont_know_alias))
		{
			/#
				IPrintLnBold("Dev Block strings are not supported" + dont_know_alias);
			#/
		}
		self RotatePitch(90, 0.25);
	}
}

