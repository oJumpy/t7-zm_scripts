#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_power;

#namespace zm_temple_power;

/*
	Name: init_electric_switch
	Namespace: zm_temple_power
	Checksum: 0xDC89B75F
	Offset: 0x430
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function init_electric_switch()
{
	level flag::wait_till("initial_players_connected");
	level.power_blockers = GetEntArray("temple_power_door", "targetname");
	level flag::init("left_switch_pulled");
	level flag::init("right_switch_pulled");
	level flag::init("left_switch_done");
	level flag::init("right_switch_done");
	water_wheel_init();
	var_af844e4d = struct::get("power_switch_left", "targetname");
	var_5e17cc70 = struct::get("power_switch_right", "targetname");
	level thread function_22a3c3fb("power_trigger_left", "left_switch_pulled");
	level thread function_22a3c3fb("power_trigger_right", "right_switch_pulled");
	var_af844e4d thread wait_for_power_switch("left_switch_pulled", "left_switch_done");
	var_5e17cc70 thread wait_for_power_switch("right_switch_pulled", "right_switch_done");
	level thread wait_for_power();
	level thread on_power_on();
}

/*
	Name: water_wheel_init
	Namespace: zm_temple_power
	Checksum: 0x5C45CA1
	Offset: 0x640
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function water_wheel_init()
{
	level thread water_start("left_switch_done", 48, 25, 0, "evt_waterwheel02");
	level thread water_start("right_switch_done", 49, 26, 1, "evt_waterwheel01");
	level thread water_sounds_left();
	level thread water_sounds_right();
}

/*
	Name: function_22a3c3fb
	Namespace: zm_temple_power
	Checksum: 0xBD726961
	Offset: 0x6E0
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function function_22a3c3fb(trigger_name, switch_flag)
{
	switch_trigger = GetEnt(trigger_name, "targetname");
	switch_trigger setHintString(&"ZM_TEMPLE_RELEASE_WATER");
	switch_trigger setcursorhint("HINT_NOICON");
	while(1)
	{
		switch_trigger waittill("trigger", player);
		if(isPlayer(player))
		{
			level flag::set(switch_flag);
			break;
		}
	}
	switch_trigger delete();
	level thread play_poweron_vox(player);
}

/*
	Name: play_poweron_vox
	Namespace: zm_temple_power
	Checksum: 0x5A776816
	Offset: 0x7F0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function play_poweron_vox(player)
{
	level notify("end_duplicate_poweron_vox");
	level endon("end_duplicate_poweron_vox");
	wait(5);
	if(isdefined(player) && level flag::get("power_on"))
	{
		player thread zm_audio::create_and_play_dialog("general", "poweron");
	}
}

/*
	Name: wait_for_power_switch
	Namespace: zm_temple_power
	Checksum: 0x30F51CCE
	Offset: 0x878
	Size: 0x13B
	Parameters: 2
	Flags: None
*/
function wait_for_power_switch(switch_flag, switch_done_flag)
{
	level flag::wait_till(switch_flag);
	playsoundatposition("zmb_switch_flip_temple", self.origin);
	if(IsSubStr(self.targetname, "left"))
	{
		var_1e69bd24 = "elec_switch_fx_left";
	}
	else
	{
		var_1e69bd24 = "elec_switch_fx_right";
	}
	playFX(level._effect["switch_sparks"], struct::get(var_1e69bd24, "targetname").origin);
	level scene::Play(self.targetname, "targetname");
	playsoundatposition("zmb_turn_on", self.origin);
	level flag::set(switch_done_flag);
}

/*
	Name: wait_for_power
	Namespace: zm_temple_power
	Checksum: 0xFF34737E
	Offset: 0x9C0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function wait_for_power()
{
	level flag::wait_till("left_switch_done");
	level flag::wait_till("right_switch_done");
	wait(1);
	zm_power::turn_power_on_and_open_doors();
}

/*
	Name: on_power_on
	Namespace: zm_temple_power
	Checksum: 0x29B3BCD9
	Offset: 0xA28
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function on_power_on()
{
	level flag::wait_till("power_on");
	level clientfield::set("zombie_power_on", 1);
	level flag::set("left_switch_pulled");
	level flag::set("right_switch_pulled");
	level thread activate_perk_machines();
	exploder::exploder("power_on");
	for(i = 0; i < level.power_blockers.size; i++)
	{
		level.power_blockers[i] connectpaths();
	}
	Array::delete_all(level.power_blockers);
	playsoundatposition("zmb_poweron_front", (0, 0, 0));
	playsoundatposition("zmb_poweron_rear", (0, 0, 0));
	wait(4.5);
	exploder::exploder("fxexp_15");
}

/*
	Name: activate_perk_machines
	Namespace: zm_temple_power
	Checksum: 0x9B931B40
	Offset: 0xBA8
	Size: 0xF1
	Parameters: 0
	Flags: None
*/
function activate_perk_machines()
{
	level notify("juggernog_on");
	util::wait_network_frame();
	level notify("sleight_on");
	util::wait_network_frame();
	level notify("revive_on");
	util::wait_network_frame();
	level notify("marathon_on");
	util::wait_network_frame();
	level notify("divetonuke_on");
	util::wait_network_frame();
	level notify("deadshot_on");
	util::wait_network_frame();
	level notify("doubletap_on");
	util::wait_network_frame();
	level notify("Pack_A_Punch_on");
}

/*
	Name: move_water_covers
	Namespace: zm_temple_power
	Checksum: 0xAFD5BEE
	Offset: 0xCA8
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function move_water_covers(name_of_water_covers)
{
	water_covers = GetEntArray(name_of_water_covers, "targetname");
	for(i = 0; i < water_covers.size; i++)
	{
		water_covers[i] thread _movez(-180, 4, 0.25, 0.25);
	}
}

/*
	Name: _movez
	Namespace: zm_temple_power
	Checksum: 0x62125E92
	Offset: 0xD50
	Size: 0x4B
	Parameters: 4
	Flags: None
*/
function _movez(z_value, time, acceleration_time, deceleration_time)
{
	self MoveZ(z_value, time, acceleration_time, deceleration_time);
}

/*
	Name: water_start
	Namespace: zm_temple_power
	Checksum: 0x960574F1
	Offset: 0xDA8
	Size: 0x10B
	Parameters: 5
	Flags: None
*/
function water_start(switch_done_flag, water_exploder, spark_exploder, isRight, sound)
{
	level flag::wait_till(switch_done_flag);
	wait(3.5);
	exploder::exploder("fxexp_" + water_exploder);
	exploder::stop_exploder("fxexp_" + spark_exploder);
	wait(1.2);
	soundent = GetEnt(sound + "_origin", "targetname");
	if(isdefined(soundent))
	{
		soundent PlayLoopSound(sound, 1);
	}
	water_wheel_rotate_constant(isRight);
}

/*
	Name: water_sounds_left
	Namespace: zm_temple_power
	Checksum: 0x67FE4648
	Offset: 0xEC0
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function water_sounds_left()
{
	level flag::wait_till("left_switch_done");
	wait(3.5);
	start_struct = struct::get("water_spout_01", "targetname");
	if(isdefined(start_struct))
	{
		level thread sound::play_in_space("evt_water_spout01", start_struct.origin);
	}
	wait(1);
	loop_struct = struct::get("water_pour_01", "targetname");
	if(isdefined(loop_struct))
	{
		sound_entity = spawn("script_origin", (0, 0, 1));
		sound_entity.origin = loop_struct.origin;
		sound_entity PlayLoopSound("evt_water_pour01");
	}
}

/*
	Name: water_sounds_right
	Namespace: zm_temple_power
	Checksum: 0xB47B2116
	Offset: 0xFF8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function water_sounds_right()
{
	level flag::wait_till("right_switch_done");
	wait(3.5);
	start_struct = struct::get("water_spout_02", "targetname");
	if(isdefined(start_struct))
	{
		level thread sound::play_in_space("evt_water_spout02", start_struct.origin);
	}
	wait(1);
	loop_struct = struct::get("water_pour_02", "targetname");
	if(isdefined(loop_struct))
	{
		sound_entity = spawn("script_origin", (0, 0, 1));
		sound_entity.origin = loop_struct.origin;
		sound_entity PlayLoopSound("evt_water_pour02");
	}
}

/*
	Name: water_wheel_rotate_constant
	Namespace: zm_temple_power
	Checksum: 0x3F5BBFFB
	Offset: 0x1130
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function water_wheel_rotate_constant(isRight)
{
	if(isRight)
	{
		level clientfield::set("water_wheel_right", 1);
	}
	else
	{
		level clientfield::set("water_wheel_left", 1);
	}
}

