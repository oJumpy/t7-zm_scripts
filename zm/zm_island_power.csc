#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_f3e3de78;

/*
	Name: init
	Namespace: namespace_f3e3de78
	Checksum: 0xA58A8E1A
	Offset: 0x258
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("scriptmover", "bucket_fx", 9000, 1, "int", &function_9865d978, 0, 0);
	clientfield::register("world", "power_switch_1_fx", 9000, 1, "int", &function_41da9a24, 0, 0);
	clientfield::register("world", "power_switch_2_fx", 9000, 1, "int", &function_11d41051, 0, 0);
	clientfield::register("world", "penstock_fx_anim", 9000, 1, "int", &function_8816d2aa, 0, 0);
	clientfield::register("scriptmover", "power_plant_glow", 9000, 1, "int", &function_884da1ce, 0, 0);
}

/*
	Name: function_9865d978
	Namespace: namespace_f3e3de78
	Checksum: 0x5C8CEBD
	Offset: 0x3D0
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function function_9865d978(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.fx_id))
	{
		deletefx(localClientNum, self.fx_id);
		self.fx_id = undefined;
	}
	if(newVal == 1)
	{
		self.fx_id = PlayFXOnTag(localClientNum, level._effect["bucket_fx"], self, "tag_origin");
	}
}

/*
	Name: function_41da9a24
	Namespace: namespace_f3e3de78
	Checksum: 0xB2C01677
	Offset: 0x4B8
	Size: 0x3A3
	Parameters: 7
	Flags: None
*/
function function_41da9a24(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_9ee18415 = struct::get_array("power_switch_1_fx", "targetname");
	foreach(s_fx in var_9ee18415)
	{
		if(isdefined(s_fx.a_fx_id))
		{
			a_keys = getArrayKeys(s_fx.a_fx_id);
			if(IsInArray(a_keys, localClientNum))
			{
				deletefx(localClientNum, s_fx.a_fx_id[localClientNum], 0);
			}
		}
	}
	if(newVal == 1)
	{
		var_92ee343f = GetEnt(localClientNum, "power_wires_lab_a", "targetname");
		var_92ee343f thread function_5ae9f178(localClientNum, 0);
		foreach(s_fx in var_9ee18415)
		{
			if(!isdefined(s_fx.a_fx_id))
			{
				s_fx.a_fx_id = [];
			}
			s_fx.a_fx_id[localClientNum] = playFX(localClientNum, level._effect["tower_light_red"], s_fx.origin);
		}
		break;
	}
	var_92ee343f = GetEnt(localClientNum, "power_wires_lab_a", "targetname");
	var_92ee343f thread function_5ae9f178(localClientNum, 1);
	foreach(s_fx in var_9ee18415)
	{
		if(!isdefined(s_fx.a_fx_id))
		{
			s_fx.a_fx_id = [];
		}
		s_fx.a_fx_id[localClientNum] = playFX(localClientNum, level._effect["tower_light_green"], s_fx.origin);
	}
}

/*
	Name: function_11d41051
	Namespace: namespace_f3e3de78
	Checksum: 0x8315189E
	Offset: 0x868
	Size: 0x3A3
	Parameters: 7
	Flags: None
*/
function function_11d41051(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_9ee18415 = struct::get_array("power_switch_2_fx", "targetname");
	foreach(s_fx in var_9ee18415)
	{
		if(isdefined(s_fx.a_fx_id))
		{
			a_keys = getArrayKeys(s_fx.a_fx_id);
			if(IsInArray(a_keys, localClientNum))
			{
				deletefx(localClientNum, s_fx.a_fx_id[localClientNum], 0);
			}
		}
	}
	if(newVal == 1)
	{
		var_92ee343f = GetEnt(localClientNum, "power_wires_lab_b", "targetname");
		var_92ee343f thread function_5ae9f178(localClientNum, 0);
		foreach(s_fx in var_9ee18415)
		{
			if(!isdefined(s_fx.a_fx_id))
			{
				s_fx.a_fx_id = [];
			}
			s_fx.a_fx_id[localClientNum] = playFX(localClientNum, level._effect["tower_light_red"], s_fx.origin);
		}
		break;
	}
	var_92ee343f = GetEnt(localClientNum, "power_wires_lab_b", "targetname");
	var_92ee343f thread function_5ae9f178(localClientNum, 1);
	foreach(s_fx in var_9ee18415)
	{
		if(!isdefined(s_fx.a_fx_id))
		{
			s_fx.a_fx_id = [];
		}
		s_fx.a_fx_id[localClientNum] = playFX(localClientNum, level._effect["tower_light_green"], s_fx.origin);
	}
}

/*
	Name: function_5ae9f178
	Namespace: namespace_f3e3de78
	Checksum: 0x3EB5843
	Offset: 0xC18
	Size: 0x1BF
	Parameters: 2
	Flags: None
*/
function function_5ae9f178(localClientNum, b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	self endon("entityshutdown");
	self notify("hash_67a9e087");
	self endon("hash_67a9e087");
	n_start_time = GetTime();
	n_end_time = n_start_time + 2 * 1000;
	b_is_updating = 1;
	if(isdefined(b_on) && b_on)
	{
		n_max = 1;
		n_min = 0;
		continue;
	}
	n_max = 0;
	n_min = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_8816d2aa
	Namespace: namespace_f3e3de78
	Checksum: 0x50BB08B9
	Offset: 0xDE0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_8816d2aa(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		scene::init("p7_fxanim_zm_island_penstock_vent_stuck_bundle");
	}
	else
	{
		scene::Play("p7_fxanim_zm_island_penstock_vent_stuck_bundle");
	}
}

/*
	Name: function_884da1ce
	Namespace: namespace_f3e3de78
	Checksum: 0x114B2009
	Offset: 0xE70
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_884da1ce(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread function_a88bde9b(localClientNum, 1);
	}
	else
	{
		self thread function_a88bde9b(localClientNum, 0);
	}
}

/*
	Name: function_a88bde9b
	Namespace: namespace_f3e3de78
	Checksum: 0x77305CEE
	Offset: 0xF00
	Size: 0x1BF
	Parameters: 2
	Flags: None
*/
function function_a88bde9b(localClientNum, b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	self endon("entityshutdown");
	self notify("hash_67a9e087");
	self endon("hash_67a9e087");
	n_start_time = GetTime();
	n_end_time = n_start_time + 2 * 1000;
	b_is_updating = 1;
	if(isdefined(b_on) && b_on)
	{
		n_max = 1;
		n_min = 0;
		continue;
	}
	n_max = 0;
	n_min = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

