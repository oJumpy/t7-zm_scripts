#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;

#namespace namespace_ee5f5b26;

/*
	Name: main
	Namespace: namespace_ee5f5b26
	Checksum: 0x102861ED
	Offset: 0x270
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function main()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: namespace_ee5f5b26
	Checksum: 0x5F7BC4B5
	Offset: 0x290
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("world", "rocket_trap_warning_smoke", 1, 1, "int", &function_9fc6fce2, 0, 0);
	clientfield::register("world", "rocket_trap_warning_fire", 1, 1, "int", &function_455f796b, 0, 0);
	clientfield::register("world", "sndRocketAlarm", 5000, 2, "int", &function_b50ae7c1, 0, 0);
	clientfield::register("world", "sndRocketTrap", 5000, 3, "int", &function_f38bdbaf, 0, 0);
}

/*
	Name: function_9fc6fce2
	Namespace: namespace_ee5f5b26
	Checksum: 0xBC4E0B2E
	Offset: 0x3C0
	Size: 0x1BD
	Parameters: 7
	Flags: None
*/
function function_9fc6fce2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_52d911b7 = struct::get("rocket_trap_warning_smoke", "targetname");
	v_forward = AnglesToForward(var_52d911b7.angles);
	v_up = anglesToUp(var_52d911b7.angles);
	if(isdefined(var_52d911b7.a_fx_id))
	{
		for(j = 0; j < var_52d911b7.a_fx_id.size; j++)
		{
			deletefx(localClientNum, var_52d911b7.a_fx_id[j], 0);
		}
		var_52d911b7.a_fx_id = [];
	}
	if(newVal)
	{
		if(!isdefined(var_52d911b7.a_fx_id))
		{
			var_52d911b7.a_fx_id = [];
		}
		var_52d911b7.a_fx_id[localClientNum] = playFX(localClientNum, level._effect["rocket_warning_smoke"], var_52d911b7.origin, v_forward, v_up, 0);
	}
}

/*
	Name: function_455f796b
	Namespace: namespace_ee5f5b26
	Checksum: 0x3D4737CD
	Offset: 0x588
	Size: 0x1DB
	Parameters: 7
	Flags: None
*/
function function_455f796b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_52d911b7 = struct::get("rocket_trap_warning_fire", "targetname");
	v_forward = AnglesToForward(var_52d911b7.angles);
	v_up = anglesToUp(var_52d911b7.angles);
	if(isdefined(var_52d911b7.a_fx_id))
	{
		for(j = 0; j < var_52d911b7.a_fx_id.size; j++)
		{
			deletefx(localClientNum, var_52d911b7.a_fx_id[j], 0);
		}
		var_52d911b7.a_fx_id = [];
	}
	if(newVal)
	{
		if(!isdefined(var_52d911b7.a_fx_id))
		{
			var_52d911b7.a_fx_id = [];
		}
		var_52d911b7.a_fx_id[localClientNum] = playFX(localClientNum, level._effect["rocket_warning_fire"], var_52d911b7.origin, v_forward, v_up, 0);
	}
	else
	{
		function_bdb5a3e2(localClientNum);
	}
}

/*
	Name: function_bdb5a3e2
	Namespace: namespace_ee5f5b26
	Checksum: 0xFE04F401
	Offset: 0x770
	Size: 0x1BB
	Parameters: 1
	Flags: None
*/
function function_bdb5a3e2(localClientNum)
{
	var_52d911b7 = struct::get("rocket_trap_blast", "targetname");
	v_forward = AnglesToForward(var_52d911b7.angles);
	v_up = anglesToUp(var_52d911b7.angles);
	n_fx_id = playFX(localClientNum, level._effect["rocket_side_blast"], var_52d911b7.origin, v_forward, v_up, 0);
	wait(0.4);
	var_a62b9cd7 = struct::get_array("rocket_trap_side_blast", "targetname");
	foreach(var_b25c0a2d in var_a62b9cd7)
	{
		var_b25c0a2d thread function_c1e8be(localClientNum);
	}
	wait(20);
	deletefx(localClientNum, n_fx_id, 0);
}

/*
	Name: function_c1e8be
	Namespace: namespace_ee5f5b26
	Checksum: 0xFA2D34A0
	Offset: 0x938
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function function_c1e8be(localClientNum)
{
	v_forward = AnglesToForward(self.angles);
	v_up = anglesToUp(self.angles);
	wait(RandomFloatRange(0, 1));
	n_id = playFX(localClientNum, level._effect["rocket_side_blast"], self.origin, v_forward, v_up, 0);
	wait(20);
	deletefx(localClientNum, n_id, 0);
}

/*
	Name: function_b50ae7c1
	Namespace: namespace_ee5f5b26
	Checksum: 0xBEA0761D
	Offset: 0xA20
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function function_b50ae7c1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(newVal == 1)
		{
			audio::playloopat("evt_rocket_trap_alarm", (4202, -2096, -1438));
			audio::playloopat("evt_rocket_trap_alarm_dist", (4202, -2096, -1437));
		}
		if(newVal == 2)
		{
			audio::stoploopat("evt_rocket_trap_alarm", (4202, -2096, -1438));
			audio::stoploopat("evt_rocket_trap_alarm_dist", (4202, -2096, -1437));
		}
	}
}

/*
	Name: function_f38bdbaf
	Namespace: namespace_ee5f5b26
	Checksum: 0x65B9E015
	Offset: 0xB30
	Size: 0x1E3
	Parameters: 7
	Flags: None
*/
function function_f38bdbaf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_dc3c5ca7 = (4202, -2249, -2127);
	if(newVal)
	{
		if(newVal == 1)
		{
			audio::playloopat("evt_rocket_trap_smoke", var_dc3c5ca7);
		}
		if(newVal == 2)
		{
			audio::stoploopat("evt_rocket_trap_smoke", var_dc3c5ca7);
			audio::playloopat("evt_rocket_trap_ignite", var_dc3c5ca7);
			playsound(0, "evt_rocket_trap_ignite_one_shot", var_dc3c5ca7);
		}
		if(newVal == 3)
		{
			audio::stoploopat("evt_rocket_trap_ignite", var_dc3c5ca7);
			audio::playloopat("evt_rocket_trap_burn", var_dc3c5ca7);
			playsound(0, "evt_rocket_trap_burn_one_shot", var_dc3c5ca7);
			audio::playloopat("evt_rocket_trap_burn_dist", var_dc3c5ca7 + VectorScale((0, 0, 1), 1000));
		}
		if(newVal == 4)
		{
			audio::stoploopat("evt_rocket_trap_burn", var_dc3c5ca7);
			audio::stoploopat("evt_rocket_trap_burn_dist", var_dc3c5ca7 + VectorScale((0, 0, 1), 1000));
		}
	}
}

