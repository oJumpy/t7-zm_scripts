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
	clientfield::register("world", "start_anim_robot_0", 21000, 1, "int", &toggle_robot_warning_lights, 0, 0);
	clientfield::register("world", "start_anim_robot_1", 21000, 1, "int", &toggle_robot_warning_lights, 0, 0);
	clientfield::register("world", "start_anim_robot_2", 21000, 1, "int", &toggle_robot_warning_lights, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_0", 21000, 2, "int", &play_foot_stomp_fx, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_1", 21000, 2, "int", &play_foot_stomp_fx, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_2", 21000, 2, "int", &play_foot_stomp_fx, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_0", 21000, 2, "int", &play_foot_open_fx, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_1", 21000, 2, "int", &play_foot_open_fx, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_2", 21000, 2, "int", &play_foot_open_fx, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_0", 21000, 1, "int", &play_eject_warning_fx, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_1", 21000, 1, "int", &play_eject_warning_fx, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_2", 21000, 1, "int", &play_eject_warning_fx, 0, 0);
	clientfield::register("scriptmover", "light_foot_fx_robot", 21000, 2, "int", &function_98a05ad2, 0, 0);
	clientfield::register("allplayers", "eject_steam_fx", 21000, 1, "int", &play_eject_steam_fx, 0, 0);
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
	Name: play_foot_stomp_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8BA9D4D7
	Offset: 0xCE8
	Size: 0x1F3
	Parameters: 7
	Flags: None
*/
function play_foot_stomp_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	ai_robot = get_clientside_giant_robot_ai(localClientNum, fieldName);
	if(!isdefined(ai_robot))
	{
		return;
	}
	ai_robot thread play_warning_lights_in_footprints_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump);
	if(newVal == 1)
	{
		ai_robot.var_16a8765e = PlayFXOnTag(localClientNum, level._effect["robot_foot_stomp"], ai_robot, "tag_hatch_fx_ri");
		origin = ai_robot GetTagOrigin("tag_hatch_fx_ri");
		playsound(0, "zmb_robot_foot_impact", origin);
	}
	else if(newVal == 2)
	{
		ai_robot.var_16a8765e = PlayFXOnTag(localClientNum, level._effect["robot_foot_stomp"], ai_robot, "tag_hatch_fx_le");
		origin = ai_robot GetTagOrigin("tag_hatch_fx_le");
		playsound(0, "zmb_robot_foot_impact", origin);
	}
	SetFXIgnorePause(localClientNum, ai_robot.var_16a8765e, 1);
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
	Name: play_foot_open_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3B274852
	Offset: 0x1030
	Size: 0x393
	Parameters: 7
	Flags: None
*/
function play_foot_open_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	ai_robot = get_clientside_giant_robot_ai(localClientNum, fieldName);
	if(!isdefined(ai_robot))
	{
		return;
	}
	v_fx_offset = VectorScale((0, 0, 1), 56);
	if(newVal == 1)
	{
		v_fx_pos = ai_robot GetTagOrigin("tag_hatch_fx_ri");
		v_fx_pos = v_fx_pos - v_fx_offset;
		ai_robot.e_damage_fx = spawn(localClientNum, v_fx_pos, "script_model");
		ai_robot.e_damage_fx SetModel("tag_origin");
		ai_robot.e_damage_fx LinkTo(ai_robot, "tag_hatch_fx_ri");
		ai_robot.e_damage_fx playsound(0, "zmb_zombieblood_3rd_plane_explode");
		ai_robot.e_damage_fx.n_death_fx = PlayFXOnTag(localClientNum, level._effect["mechz_death"], ai_robot.e_damage_fx, "tag_origin");
		SetFXIgnorePause(localClientNum, ai_robot.e_damage_fx.n_death_fx, 1);
	}
	else if(newVal == 2)
	{
		v_fx_pos = ai_robot GetTagOrigin("tag_hatch_fx_le");
		v_fx_pos = v_fx_pos - v_fx_offset;
		ai_robot.e_damage_fx = spawn(localClientNum, v_fx_pos, "script_model");
		ai_robot.e_damage_fx SetModel("tag_origin");
		ai_robot.e_damage_fx LinkTo(ai_robot, "tag_hatch_fx_le");
		ai_robot.e_damage_fx playsound(0, "zmb_zombieblood_3rd_plane_explode");
		ai_robot.e_damage_fx.n_death_fx = PlayFXOnTag(localClientNum, level._effect["mechz_death"], ai_robot.e_damage_fx, "tag_origin");
		SetFXIgnorePause(localClientNum, ai_robot.e_damage_fx.n_death_fx, 1);
	}
	else if(isdefined(ai_robot.e_damage_fx))
	{
		ai_robot.e_damage_fx delete();
	}
}

/*
	Name: play_eject_warning_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0xBE012B68
	Offset: 0x13D0
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function play_eject_warning_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
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
	Name: play_eject_steam_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x5A64DD06
	Offset: 0x1580
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function play_eject_steam_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self thread loop_eject_steam_fx(localClientNum);
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
	Name: loop_eject_steam_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x43D184B6
	Offset: 0x1630
	Size: 0x14F
	Parameters: 1
	Flags: None
*/
function loop_eject_steam_fx(localClientNum)
{
	self endon("hash_968de603");
	self endon("player_intermission");
	a_s_tubes = struct::get_array("giant_robot_eject_tube", "script_noteworthy");
	s_tube = ArrayGetClosest(self.origin, a_s_tubes);
	self thread sndplaysteamfx("stop_eject_steam_fx", s_tube.origin);
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
		a_s_alltubes = struct::get_array("giant_robot_eject_tube", "script_noteworthy");
		var_8356f695 = ArrayGetClosest(self.origin, a_s_alltubes);
		n_robot_id = var_8356f695.script_int;
		level.a_s_tubes = [];
		level.a_s_tubes[localClientNum] = [];
		n_index = 0;
		foreach(struct in a_s_alltubes)
		{
			if(struct.script_int == n_robot_id)
			{
				struct thread loop_all_tube_steam(localClientNum);
				level.a_s_tubes[localClientNum][n_index] = struct;
				n_index++;
			}
		}
		break;
	}
	if(isdefined(level.a_s_tubes[localClientNum]))
	{
		foreach(struct in level.a_s_tubes[localClientNum])
		{
			struct notify("hash_e54dfe36");
		}
	}
}

/*
	Name: loop_all_tube_steam
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD3492BFD
	Offset: 0x19D0
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function loop_all_tube_steam(localClientNum)
{
	self endon("hash_e54dfe36");
	self thread sndplaysteamfx("stop_all_tubes_eject_steam", self.origin);
	while(1)
	{
		self.var_d1c8c63f = playFX(localClientNum, level._effect["eject_steam"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
		SetFXIgnorePause(localClientNum, self.var_d1c8c63f, 1);
		wait(0.1);
	}
}

/*
	Name: sndplaysteamfx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x21E2AB7A
	Offset: 0x1AB0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function sndplaysteamfx(the_notify, origin)
{
	audio::playloopat("zmb_bot_timeout_steam", origin);
	self waittill(the_notify);
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
	Name: get_clientside_giant_robot_ai
	Namespace: zm_tomb_giant_robot
	Checksum: 0x2B020F8B
	Offset: 0x1BF8
	Size: 0x127
	Parameters: 2
	Flags: None
*/
function get_clientside_giant_robot_ai(localClientNum, fieldName)
{
	if(!isdefined(level.a_giant_robots) || !isdefined(level.a_giant_robots[localClientNum]))
	{
		return undefined;
	}
	ai_robot = undefined;
	if(IsSubStr(fieldName, 0))
	{
		ai_robot = level.a_giant_robots[localClientNum][0];
		if(isdefined(ai_robot))
		{
			ai_robot._index_for_lights = 0;
		}
	}
	else if(IsSubStr(fieldName, 1))
	{
		ai_robot = level.a_giant_robots[localClientNum][1];
		if(isdefined(ai_robot))
		{
			ai_robot._index_for_lights = 1;
		}
	}
	else
	{
		ai_robot = level.a_giant_robots[localClientNum][2];
		if(isdefined(ai_robot))
		{
			ai_robot._index_for_lights = 2;
		}
	}
	return ai_robot;
}

/*
	Name: toggle_robot_warning_lights
	Namespace: zm_tomb_giant_robot
	Checksum: 0x1AD288B8
	Offset: 0x1D28
	Size: 0x435
	Parameters: 7
	Flags: None
*/
function toggle_robot_warning_lights(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(level.robot_light_positions))
	{
		level.robot_light_positions = [];
		level.robot_light_positions[0] = spawnstruct();
		level.robot_light_positions[0].struct_name = "nml_warn_light_fp_ref";
		level.robot_light_positions[0].warning_lights = struct::get_array("nml_foot_warn_light", "targetname");
		/#
			Assert(level.robot_light_positions[0].warning_lights.size > 0, "Dev Block strings are not supported");
		#/
		level.robot_light_positions[1] = spawnstruct();
		level.robot_light_positions[1].struct_name = "trench_warn_light_fp_ref";
		level.robot_light_positions[1].warning_lights = [];
		level.robot_light_positions[1].warning_lights = struct::get_array("trench_foot_warn_light", "targetname");
		/#
			Assert(level.robot_light_positions[1].warning_lights.size > 0, "Dev Block strings are not supported");
		#/
		level.robot_light_positions[2] = spawnstruct();
		level.robot_light_positions[2].struct_name = "church_warn_light_fp_ref";
		level.robot_light_positions[2].warning_lights = [];
		level.robot_light_positions[2].warning_lights = struct::get_array("church_foot_warn_light", "targetname");
		/#
			Assert(level.robot_light_positions[2].warning_lights.size > 0, "Dev Block strings are not supported");
		#/
	}
	ai_robot = get_clientside_giant_robot_ai(localClientNum, fieldName);
	if(!isdefined(ai_robot) || !isdefined(level.robot_light_positions[ai_robot._index_for_lights]))
	{
		return;
	}
	if(newVal == 1)
	{
		ai_robot.next_foot_left = struct::get(level.robot_light_positions[ai_robot._index_for_lights].struct_name + "_left", "targetname");
		ai_robot.next_foot_right = struct::get(level.robot_light_positions[ai_robot._index_for_lights].struct_name + "_right", "targetname");
		ai_robot turn_on_warning_lights(localClientNum, ai_robot.next_foot_left);
		ai_robot turn_on_warning_lights(localClientNum, ai_robot.next_foot_right);
	}
	else
	{
		ai_robot turn_off_all_warning_lights_for_this_robot(localClientNum);
		ai_robot.next_foot_left = undefined;
		ai_robot.next_foot_right = undefined;
	}
}

/*
	Name: turn_on_warning_lights
	Namespace: zm_tomb_giant_robot
	Checksum: 0xFCB0A1A7
	Offset: 0x2168
	Size: 0x181
	Parameters: 2
	Flags: None
*/
function turn_on_warning_lights(localClientNum, struct_footprint)
{
	a_lights = get_warning_lights_closest(struct_footprint);
	foreach(light in a_lights)
	{
		if(!isdefined(light.fx_is_on_and_id))
		{
			if(!isdefined(light.angles))
			{
				light.angles = (0, 0, 0);
			}
			light.fx_is_on_and_id = playFX(localClientNum, level._effect["giant_robot_footstep_warning_light"], light.origin, AnglesToForward(light.angles), anglesToUp(light.angles));
			SetFXIgnorePause(localClientNum, light.fx_is_on_and_id, 1);
		}
	}
}

/*
	Name: turn_off_warning_lights
	Namespace: zm_tomb_giant_robot
	Checksum: 0x131D5F0F
	Offset: 0x22F8
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function turn_off_warning_lights(localClientNum, struct_footprint)
{
	a_lights = get_warning_lights_closest(struct_footprint);
	foreach(light in a_lights)
	{
		if(isdefined(light.fx_is_on_and_id))
		{
			stopfx(localClientNum, light.fx_is_on_and_id);
			light.fx_is_on_and_id = undefined;
		}
	}
}

/*
	Name: turn_off_all_warning_lights_for_this_robot
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8C670ED3
	Offset: 0x23E8
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function turn_off_all_warning_lights_for_this_robot(localClientNum)
{
	foreach(light in level.robot_light_positions[self._index_for_lights].warning_lights)
	{
		if(isdefined(light.fx_is_on_and_id))
		{
			stopfx(localClientNum, light.fx_is_on_and_id);
			light.fx_is_on_and_id = undefined;
		}
	}
}

/*
	Name: get_warning_lights_closest
	Namespace: zm_tomb_giant_robot
	Checksum: 0x6998DA17
	Offset: 0x24C0
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function get_warning_lights_closest(struct_footprint)
{
	a_close_lights = [];
	foreach(light in level.robot_light_positions[self._index_for_lights].warning_lights)
	{
		if(DistanceSquared(struct_footprint.origin, light.origin) < 640000)
		{
			if(!isdefined(a_close_lights))
			{
				a_close_lights = [];
			}
			else if(!IsArray(a_close_lights))
			{
				a_close_lights = Array(a_close_lights);
			}
			a_close_lights[a_close_lights.size] = light;
		}
	}
	return a_close_lights;
}

/*
	Name: play_warning_lights_in_footprints_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD7CD3697
	Offset: 0x2600
	Size: 0x261
	Parameters: 7
	Flags: None
*/
function play_warning_lights_in_footprints_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	wait(1);
	if(newVal == 1)
	{
		if(isdefined(self.next_foot_right))
		{
			foot_origin = self GetTagOrigin("tag_hatch_fx_ri");
			if(DistanceSquared(self.next_foot_right.origin, foot_origin) < 300 * 300)
			{
				turn_off_warning_lights(localClientNum, self.next_foot_right);
				wait(0.05);
				if(isdefined(self.next_foot_right.target))
				{
					self.next_foot_right = struct::get(self.next_foot_right.target, "targetname");
					turn_on_warning_lights(localClientNum, self.next_foot_right);
				}
				else
				{
					self.next_foot_right = undefined;
				}
			}
		}
	}
	else if(newVal == 2)
	{
		if(isdefined(self.next_foot_left))
		{
			foot_origin = self GetTagOrigin("tag_hatch_fx_le");
			if(DistanceSquared(self.next_foot_left.origin, foot_origin) < 300 * 300)
			{
				turn_off_warning_lights(localClientNum, self.next_foot_left);
				wait(0.05);
				if(isdefined(self.next_foot_left.target))
				{
					self.next_foot_left = struct::get(self.next_foot_left.target, "targetname");
					turn_on_warning_lights(localClientNum, self.next_foot_left);
				}
				else
				{
					self.next_foot_left = undefined;
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
		self notify("stop_giant_robot_rumble_and_shake");
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
		e_church_ceiling = GetEnt(localClientNum, "church_ceiling", "targetname");
		e_church_ceiling scene::Play("p7_fxanim_zm_ori_church_ceiling_bundle", e_church_ceiling);
	}
}

