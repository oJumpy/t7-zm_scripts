#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_tomb_amb;

#namespace zm_tomb_giant_robot;

/*
	Name: init
	Namespace: zm_tomb_giant_robot
	Checksum: 0xE6E67F5A
	Offset: 0x688
	Size: 0x55B
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("scriptmover", "register_giant_robot", 21000, 1, "int", &function_63ccebe9, 0, 0);
	clientfield::register("world", "start_anim_robot_0", 21000, 1, "int", &function_7e19465b, 0, 0);
	clientfield::register("world", "start_anim_robot_1", 21000, 1, "int", &function_7e19465b, 0, 0);
	clientfield::register("world", "start_anim_robot_2", 21000, 1, "int", &function_7e19465b, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_0", 21000, 2, "int", &function_36b7480d, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_1", 21000, 2, "int", &function_36b7480d, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_2", 21000, 2, "int", &function_36b7480d, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_0", 21000, 2, "int", &function_6e99bd62, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_1", 21000, 2, "int", &function_6e99bd62, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_2", 21000, 2, "int", &function_6e99bd62, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_0", 21000, 1, "int", &function_aa136ff9, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_1", 21000, 1, "int", &function_aa136ff9, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_2", 21000, 1, "int", &function_aa136ff9, 0, 0);
	clientfield::register("scriptmover", "light_foot_fx_robot", 21000, 2, "int", &function_98a05ad2, 0, 0);
	clientfield::register("allplayers", "eject_steam_fx", 21000, 1, "int", &function_d4c69cd, 0, 0);
	clientfield::register("allplayers", "all_tubes_play_eject_steam_fx", 21000, 1, "int", &function_3a627e4d, 0, 0);
	clientfield::register("allplayers", "gr_eject_player_impact_fx", 21000, 1, "int", &function_5e616b8a, 0, 0);
	clientfield::register("toplayer", "giant_robot_rumble_and_shake", 21000, 2, "int", &function_c50fd966, 0, 0);
	clientfield::register("world", "church_ceiling_fxanim", 21000, 1, "int", &church_ceiling_fxanim, 0, 0);
}

/*
	Name: function_63ccebe9
	Namespace: zm_tomb_giant_robot
	Checksum: 0xA40440CC
	Offset: 0xBF0
	Size: 0xEF
	Parameters: 7
	Flags: None
*/
function function_63ccebe9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(level.a_giant_robots))
	{
		level.a_giant_robots = [];
		level.a_giant_robots[localClientNum] = [];
	}
	if(self.model == "veh_t7_zhd_robot_0")
	{
		level.a_giant_robots[localClientNum][0] = self;
	}
	else if(self.model == "veh_t7_zhd_robot_1")
	{
		level.a_giant_robots[localClientNum][1] = self;
	}
	else if(self.model == "veh_t7_zhd_robot_2")
	{
		level.a_giant_robots[localClientNum][2] = self;
	}
}

/*
	Name: function_36b7480d
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8BA9D4D7
	Offset: 0xCE8
	Size: 0x1F3
	Parameters: 7
	Flags: None
*/
function function_36b7480d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_f6c5842 = function_9f95c19e(localClientNum, fieldName);
	if(!isdefined(var_f6c5842))
	{
		return;
	}
	var_f6c5842 thread function_d46dfa88(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump);
	if(newVal == 1)
	{
		var_f6c5842.var_16a8765e = PlayFXOnTag(localClientNum, level._effect["robot_foot_stomp"], var_f6c5842, "tag_hatch_fx_ri");
		origin = var_f6c5842 GetTagOrigin("tag_hatch_fx_ri");
		playsound(0, "zmb_robot_foot_impact", origin);
	}
	else if(newVal == 2)
	{
		var_f6c5842.var_16a8765e = PlayFXOnTag(localClientNum, level._effect["robot_foot_stomp"], var_f6c5842, "tag_hatch_fx_le");
		origin = var_f6c5842 GetTagOrigin("tag_hatch_fx_le");
		playsound(0, "zmb_robot_foot_impact", origin);
	}
	SetFXIgnorePause(localClientNum, var_f6c5842.var_16a8765e, 1);
}

/*
	Name: function_98a05ad2
	Namespace: zm_tomb_giant_robot
	Checksum: 0x283316E3
	Offset: 0xEE8
	Size: 0x13B
	Parameters: 7
	Flags: None
*/
function function_98a05ad2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self.var_e655463b = PlayFXOnTag(localClientNum, level._effect["giant_robot_foot_light"], self, "tag_foot_bottom_left");
		SetFXIgnorePause(localClientNum, self.var_e655463b, 1);
	}
	else if(newVal == 2)
	{
		self.var_e655463b = PlayFXOnTag(localClientNum, level._effect["giant_robot_foot_light"], self, "tag_foot_bottom_right");
		SetFXIgnorePause(localClientNum, self.var_e655463b, 1);
	}
	else if(isdefined(self.var_e655463b))
	{
		KillFX(localClientNum, self.var_e655463b);
	}
}

/*
	Name: function_6e99bd62
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3B274852
	Offset: 0x1030
	Size: 0x393
	Parameters: 7
	Flags: None
*/
function function_6e99bd62(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_f6c5842 = function_9f95c19e(localClientNum, fieldName);
	if(!isdefined(var_f6c5842))
	{
		return;
	}
	v_fx_offset = VectorScale((0, 0, 1), 56);
	if(newVal == 1)
	{
		v_fx_pos = var_f6c5842 GetTagOrigin("tag_hatch_fx_ri");
		v_fx_pos = v_fx_pos - v_fx_offset;
		var_f6c5842.var_140b6e83 = spawn(localClientNum, v_fx_pos, "script_model");
		var_f6c5842.var_140b6e83 SetModel("tag_origin");
		var_f6c5842.var_140b6e83 LinkTo(var_f6c5842, "tag_hatch_fx_ri");
		var_f6c5842.var_140b6e83 playsound(0, "zmb_zombieblood_3rd_plane_explode");
		var_f6c5842.var_140b6e83.n_death_fx = PlayFXOnTag(localClientNum, level._effect["mechz_death"], var_f6c5842.var_140b6e83, "tag_origin");
		SetFXIgnorePause(localClientNum, var_f6c5842.var_140b6e83.n_death_fx, 1);
	}
	else if(newVal == 2)
	{
		v_fx_pos = var_f6c5842 GetTagOrigin("tag_hatch_fx_le");
		v_fx_pos = v_fx_pos - v_fx_offset;
		var_f6c5842.var_140b6e83 = spawn(localClientNum, v_fx_pos, "script_model");
		var_f6c5842.var_140b6e83 SetModel("tag_origin");
		var_f6c5842.var_140b6e83 LinkTo(var_f6c5842, "tag_hatch_fx_le");
		var_f6c5842.var_140b6e83 playsound(0, "zmb_zombieblood_3rd_plane_explode");
		var_f6c5842.var_140b6e83.n_death_fx = PlayFXOnTag(localClientNum, level._effect["mechz_death"], var_f6c5842.var_140b6e83, "tag_origin");
		SetFXIgnorePause(localClientNum, var_f6c5842.var_140b6e83.n_death_fx, 1);
	}
	else if(isdefined(var_f6c5842.var_140b6e83))
	{
		var_f6c5842.var_140b6e83 delete();
	}
}

/*
	Name: function_aa136ff9
	Namespace: zm_tomb_giant_robot
	Checksum: 0xBE012B68
	Offset: 0x13D0
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function function_aa136ff9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		s_origin = struct::get(fieldName, "targetname");
		v_fx_pos = s_origin.origin;
		level.fieldName[localClientNum] = spawn(localClientNum, v_fx_pos, "script_model");
		level.fieldName[localClientNum] SetModel("tag_origin");
		level.fieldName[localClientNum].var_68f810db = PlayFXOnTag(localClientNum, level._effect["eject_warning"], level.fieldName[localClientNum], "tag_origin");
		SetFXIgnorePause(localClientNum, level.fieldName[localClientNum].var_68f810db, 1);
	}
	else if(isdefined(level.fieldName[localClientNum]))
	{
		level.fieldName[localClientNum] delete();
	}
}

/*
	Name: function_d4c69cd
	Namespace: zm_tomb_giant_robot
	Checksum: 0x5A64DD06
	Offset: 0x1580
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_d4c69cd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self thread function_691b8375(localClientNum);
	}
	else
	{
		self notify("hash_968de603");
		if(isdefined(self.fieldName))
		{
			stopfx(localClientNum, self.fieldName);
		}
	}
}

/*
	Name: function_691b8375
	Namespace: zm_tomb_giant_robot
	Checksum: 0x43D184B6
	Offset: 0x1630
	Size: 0x14F
	Parameters: 1
	Flags: None
*/
function function_691b8375(localClientNum)
{
	self endon("hash_968de603");
	self endon("player_intermission");
	var_bd5df270 = struct::get_array("giant_robot_eject_tube", "script_noteworthy");
	s_tube = ArrayGetClosest(self.origin, var_bd5df270);
	self thread function_caeb1b02("stop_eject_steam_fx", s_tube.origin);
	while(isdefined(self))
	{
		self.fieldName = playFX(localClientNum, level._effect["eject_steam"], s_tube.origin, AnglesToForward(s_tube.angles), anglesToUp(s_tube.angles));
		SetFXIgnorePause(localClientNum, self.fieldName, 1);
		wait(0.1);
	}
}

/*
	Name: function_3a627e4d
	Namespace: zm_tomb_giant_robot
	Checksum: 0x58EB7369
	Offset: 0x1788
	Size: 0x23D
	Parameters: 7
	Flags: None
*/
function function_3a627e4d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		var_66a1e889 = struct::get_array("giant_robot_eject_tube", "script_noteworthy");
		var_8356f695 = ArrayGetClosest(self.origin, var_66a1e889);
		n_robot_id = var_8356f695.script_int;
		level.var_bd5df270 = [];
		level.var_bd5df270[localClientNum] = [];
		n_index = 0;
		foreach(struct in var_66a1e889)
		{
			if(struct.script_int == n_robot_id)
			{
				struct thread function_3ae72e85(localClientNum);
				level.var_bd5df270[localClientNum][n_index] = struct;
				n_index++;
			}
		}
		break;
	}
	if(isdefined(level.var_bd5df270[localClientNum]))
	{
		foreach(struct in level.var_bd5df270[localClientNum])
		{
			struct notify("hash_e54dfe36");
		}
	}
}

/*
	Name: function_3ae72e85
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD3492BFD
	Offset: 0x19D0
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function function_3ae72e85(localClientNum)
{
	self endon("hash_e54dfe36");
	self thread function_caeb1b02("stop_all_tubes_eject_steam", self.origin);
	while(1)
	{
		self.var_d1c8c63f = playFX(localClientNum, level._effect["eject_steam"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
		SetFXIgnorePause(localClientNum, self.var_d1c8c63f, 1);
		wait(0.1);
	}
}

/*
	Name: function_caeb1b02
	Namespace: zm_tomb_giant_robot
	Checksum: 0x21E2AB7A
	Offset: 0x1AB0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function function_caeb1b02(var_365d1fde, origin)
{
	audio::playloopat("zmb_bot_timeout_steam", origin);
	self waittill(var_365d1fde);
	audio::stoploopat("zmb_bot_timeout_steam", origin);
}

/*
	Name: function_5e616b8a
	Namespace: zm_tomb_giant_robot
	Checksum: 0x158A1F04
	Offset: 0x1B18
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function function_5e616b8a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self.fieldName = playFX(localClientNum, level._effect["beacon_shell_explosion"], self.origin);
		SetFXIgnorePause(localClientNum, self.fieldName, 1);
	}
	else if(isdefined(self.fieldName))
	{
		stopfx(localClientNum, self.fieldName);
	}
}

/*
	Name: function_9f95c19e
	Namespace: zm_tomb_giant_robot
	Checksum: 0x2B020F8B
	Offset: 0x1BF8
	Size: 0x127
	Parameters: 2
	Flags: None
*/
function function_9f95c19e(localClientNum, fieldName)
{
	if(!isdefined(level.a_giant_robots) || !isdefined(level.a_giant_robots[localClientNum]))
	{
		return undefined;
	}
	var_f6c5842 = undefined;
	if(IsSubStr(fieldName, 0))
	{
		var_f6c5842 = level.a_giant_robots[localClientNum][0];
		if(isdefined(var_f6c5842))
		{
			var_f6c5842.var_90d8d560 = 0;
		}
	}
	else if(IsSubStr(fieldName, 1))
	{
		var_f6c5842 = level.a_giant_robots[localClientNum][1];
		if(isdefined(var_f6c5842))
		{
			var_f6c5842.var_90d8d560 = 1;
		}
	}
	else
	{
		var_f6c5842 = level.a_giant_robots[localClientNum][2];
		if(isdefined(var_f6c5842))
		{
			var_f6c5842.var_90d8d560 = 2;
		}
	}
	return var_f6c5842;
}

/*
	Name: function_7e19465b
	Namespace: zm_tomb_giant_robot
	Checksum: 0x1AD288B8
	Offset: 0x1D28
	Size: 0x435
	Parameters: 7
	Flags: None
*/
function function_7e19465b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(level.var_58b72d2f))
	{
		level.var_58b72d2f = [];
		level.var_58b72d2f[0] = spawnstruct();
		level.var_58b72d2f[0].struct_name = "nml_warn_light_fp_ref";
		level.var_58b72d2f[0].var_11927f3d = struct::get_array("nml_foot_warn_light", "targetname");
		/#
			Assert(level.var_58b72d2f[0].var_11927f3d.size > 0, "Dev Block strings are not supported");
		#/
		level.var_58b72d2f[1] = spawnstruct();
		level.var_58b72d2f[1].struct_name = "trench_warn_light_fp_ref";
		level.var_58b72d2f[1].var_11927f3d = [];
		level.var_58b72d2f[1].var_11927f3d = struct::get_array("trench_foot_warn_light", "targetname");
		/#
			Assert(level.var_58b72d2f[1].var_11927f3d.size > 0, "Dev Block strings are not supported");
		#/
		level.var_58b72d2f[2] = spawnstruct();
		level.var_58b72d2f[2].struct_name = "church_warn_light_fp_ref";
		level.var_58b72d2f[2].var_11927f3d = [];
		level.var_58b72d2f[2].var_11927f3d = struct::get_array("church_foot_warn_light", "targetname");
		/#
			Assert(level.var_58b72d2f[2].var_11927f3d.size > 0, "Dev Block strings are not supported");
		#/
	}
	var_f6c5842 = function_9f95c19e(localClientNum, fieldName);
	if(!isdefined(var_f6c5842) || !isdefined(level.var_58b72d2f[var_f6c5842.var_90d8d560]))
	{
		return;
	}
	if(newVal == 1)
	{
		var_f6c5842.var_6e5e4d07 = struct::get(level.var_58b72d2f[var_f6c5842.var_90d8d560].struct_name + "_left", "targetname");
		var_f6c5842.var_bd0d6d82 = struct::get(level.var_58b72d2f[var_f6c5842.var_90d8d560].struct_name + "_right", "targetname");
		var_f6c5842 function_bbae1203(localClientNum, var_f6c5842.var_6e5e4d07);
		var_f6c5842 function_bbae1203(localClientNum, var_f6c5842.var_bd0d6d82);
	}
	else
	{
		var_f6c5842 function_aacf48b5(localClientNum);
		var_f6c5842.var_6e5e4d07 = undefined;
		var_f6c5842.var_bd0d6d82 = undefined;
	}
}

/*
	Name: function_bbae1203
	Namespace: zm_tomb_giant_robot
	Checksum: 0xFCB0A1A7
	Offset: 0x2168
	Size: 0x181
	Parameters: 2
	Flags: None
*/
function function_bbae1203(localClientNum, var_75158c9e)
{
	a_lights = function_d31a2386(var_75158c9e);
	foreach(light in a_lights)
	{
		if(!isdefined(light.var_1398bc94))
		{
			if(!isdefined(light.angles))
			{
				light.angles = (0, 0, 0);
			}
			light.var_1398bc94 = playFX(localClientNum, level._effect["giant_robot_footstep_warning_light"], light.origin, AnglesToForward(light.angles), anglesToUp(light.angles));
			SetFXIgnorePause(localClientNum, light.var_1398bc94, 1);
		}
	}
}

/*
	Name: function_d91e5529
	Namespace: zm_tomb_giant_robot
	Checksum: 0x131D5F0F
	Offset: 0x22F8
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function function_d91e5529(localClientNum, var_75158c9e)
{
	a_lights = function_d31a2386(var_75158c9e);
	foreach(light in a_lights)
	{
		if(isdefined(light.var_1398bc94))
		{
			stopfx(localClientNum, light.var_1398bc94);
			light.var_1398bc94 = undefined;
		}
	}
}

/*
	Name: function_aacf48b5
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8C670ED3
	Offset: 0x23E8
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function function_aacf48b5(localClientNum)
{
	foreach(light in level.var_58b72d2f[self.var_90d8d560].var_11927f3d)
	{
		if(isdefined(light.var_1398bc94))
		{
			stopfx(localClientNum, light.var_1398bc94);
			light.var_1398bc94 = undefined;
		}
	}
}

/*
	Name: function_d31a2386
	Namespace: zm_tomb_giant_robot
	Checksum: 0x6998DA17
	Offset: 0x24C0
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function function_d31a2386(var_75158c9e)
{
	var_fa1ca319 = [];
	foreach(light in level.var_58b72d2f[self.var_90d8d560].var_11927f3d)
	{
		if(DistanceSquared(var_75158c9e.origin, light.origin) < 640000)
		{
			if(!isdefined(var_fa1ca319))
			{
				var_fa1ca319 = [];
			}
			else if(!IsArray(var_fa1ca319))
			{
				var_fa1ca319 = Array(var_fa1ca319);
			}
			var_fa1ca319[var_fa1ca319.size] = light;
		}
	}
	return var_fa1ca319;
}

/*
	Name: function_d46dfa88
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD7CD3697
	Offset: 0x2600
	Size: 0x261
	Parameters: 7
	Flags: None
*/
function function_d46dfa88(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	wait(1);
	if(newVal == 1)
	{
		if(isdefined(self.var_bd0d6d82))
		{
			var_8f93a98e = self GetTagOrigin("tag_hatch_fx_ri");
			if(DistanceSquared(self.var_bd0d6d82.origin, var_8f93a98e) < 300 * 300)
			{
				function_d91e5529(localClientNum, self.var_bd0d6d82);
				wait(0.05);
				if(isdefined(self.var_bd0d6d82.target))
				{
					self.var_bd0d6d82 = struct::get(self.var_bd0d6d82.target, "targetname");
					function_bbae1203(localClientNum, self.var_bd0d6d82);
				}
				else
				{
					self.var_bd0d6d82 = undefined;
				}
			}
		}
	}
	else if(newVal == 2)
	{
		if(isdefined(self.var_6e5e4d07))
		{
			var_8f93a98e = self GetTagOrigin("tag_hatch_fx_le");
			if(DistanceSquared(self.var_6e5e4d07.origin, var_8f93a98e) < 300 * 300)
			{
				function_d91e5529(localClientNum, self.var_6e5e4d07);
				wait(0.05);
				if(isdefined(self.var_6e5e4d07.target))
				{
					self.var_6e5e4d07 = struct::get(self.var_6e5e4d07.target, "targetname");
					function_bbae1203(localClientNum, self.var_6e5e4d07);
				}
				else
				{
					self.var_6e5e4d07 = undefined;
				}
			}
		}
	}
}

/*
	Name: function_c50fd966
	Namespace: zm_tomb_giant_robot
	Checksum: 0x72816DDB
	Offset: 0x2870
	Size: 0x1D5
	Parameters: 7
	Flags: None
*/
function function_c50fd966(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("disconnect");
	if(newVal == 3)
	{
		self Earthquake(0.6, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
		soundrattle(self.origin, 250, 750);
	}
	else if(newVal == 2)
	{
		self Earthquake(0.3, 1.5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "shotgun_fire");
		soundrattle(self.origin, 100, 500);
	}
	else if(newVal == 1)
	{
		self Earthquake(0.1, 1, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "damage_heavy");
		soundrattle(self.origin, 10, 350);
	}
	else
	{
		self notify("hash_ee5c27b3");
	}
}

/*
	Name: church_ceiling_fxanim
	Namespace: zm_tomb_giant_robot
	Checksum: 0x95EB4014
	Offset: 0x2A50
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function church_ceiling_fxanim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		var_61cbe98c = GetEnt(localClientNum, "church_ceiling", "targetname");
		var_61cbe98c scene::Play("p7_fxanim_zm_ori_church_ceiling_bundle", var_61cbe98c);
	}
}

