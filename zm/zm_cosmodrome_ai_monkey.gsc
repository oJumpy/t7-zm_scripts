#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace namespace_b73b7f62;

/*
	Name: init
	Namespace: namespace_b73b7f62
	Checksum: 0x889D33BC
	Offset: 0x1F8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function init()
{
	level.monkey_zombie_enter_level = &monkey_cosmodrome_enter_level;
}

/*
	Name: monkey_cosmodrome_enter_level
	Namespace: namespace_b73b7f62
	Checksum: 0x6E75E3CE
	Offset: 0x220
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function monkey_cosmodrome_enter_level()
{
	self endon("death");
	end = self monkey_lander_get_closest_dest();
	end_launch = struct::get(end.target, "targetname");
	start_launch = end_launch.origin + VectorScale((0, 0, 1), 2000);
	lander = spawn("script_model", start_launch);
	angles = VectorToAngles(end.origin - start_launch);
	lander.angles = angles;
	lander SetModel("p7_fxanim_zm_asc_lander_crash_mod");
	lander Hide();
	lander thread clear_lander();
	self Hide();
	util::wait_network_frame();
	lander clientfield::set("COSMO_MONKEY_LANDER_FX", 1);
	self ForceTeleport(lander.origin);
	self LinkTo(lander);
	wait(2.5);
	lander show();
	lander moveto(end.origin, 0.6);
	lander waittill("movedone");
	lander clientfield::set("COSMO_MONKEY_LANDER_FX", 0);
	wait(2);
	self Unlink();
	self show();
}

/*
	Name: clear_lander
	Namespace: namespace_b73b7f62
	Checksum: 0x9CE6AF15
	Offset: 0x4A8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function clear_lander()
{
	wait(8);
	self MoveZ(-100, 0.5);
	self waittill("movedone");
	self delete();
}

/*
	Name: monkey_lander_get_closest_dest
	Namespace: namespace_b73b7f62
	Checksum: 0xB076B3AD
	Offset: 0x500
	Size: 0x1D1
	Parameters: 0
	Flags: None
*/
function monkey_lander_get_closest_dest()
{
	if(!isdefined(level._lander_endarray))
	{
		level._lander_endarray = [];
	}
	if(!isdefined(level._lander_endarray[self.script_noteworthy]))
	{
		level._lander_endarray[self.script_noteworthy] = [];
		end_spots = struct::get_array("monkey_land", "targetname");
		for(i = 0; i < end_spots.size; i++)
		{
			if(self.script_noteworthy == end_spots[i].script_noteworthy)
			{
				level._lander_endarray[self.script_noteworthy][level._lander_endarray[self.script_noteworthy].size] = end_spots[i];
			}
		}
	}
	choice = level._lander_endarray[self.script_noteworthy][0];
	max_dist = 1410065408;
	for(i = 0; i < level._lander_endarray[self.script_noteworthy].size; i++)
	{
		dist = Distance2D(self.origin, level._lander_endarray[self.script_noteworthy][i].origin);
		if(dist < max_dist)
		{
			max_dist = dist;
			choice = level._lander_endarray[self.script_noteworthy][i];
		}
	}
	return choice;
}

/*
	Name: monkey_cosmodrome_prespawn
	Namespace: namespace_b73b7f62
	Checksum: 0x95D900D3
	Offset: 0x6E0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function monkey_cosmodrome_prespawn()
{
	self.lander_death = &monkey_cosmodrome_lander_death;
}

/*
	Name: monkey_cosmodrome_failsafe
	Namespace: namespace_b73b7f62
	Checksum: 0xC9ABFFA7
	Offset: 0x708
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function monkey_cosmodrome_failsafe()
{
	self endon("death");
	while(1)
	{
		if(self.State != "bhb_jump")
		{
			if(!zm_utility::check_point_in_playable_area(self.origin))
			{
				break;
			}
		}
		wait(1);
	}
	/#
		ASSERTMSG("Dev Block strings are not supported" + self.origin);
	#/
	self DoDamage(self.health + 100, self.origin);
}

/*
	Name: monkey_cosmodrome_lander_death
	Namespace: namespace_b73b7f62
	Checksum: 0xD83ED238
	Offset: 0x7B8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function monkey_cosmodrome_lander_death()
{
	self zombie_utility::reset_attack_spot();
	self thread zombie_utility::zombie_eye_glow_stop();
	level.monkey_death++;
	level.monkey_death_total++;
	self namespace_8fb880d9::monkey_remove_from_pack();
	util::wait_network_frame();
}

