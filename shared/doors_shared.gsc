#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

#namespace cDoor;

/*
	Name: function_9b385ca5
	Namespace: cDoor
	Checksum: 0x9F3F54B6
	Offset: 0x230
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.m_n_trigger_height = 80;
	self.m_override_swing_angle = undefined;
	self.m_door_open_delay_time = 0;
	self.m_e_trigger_player = undefined;
}

/*
	Name: function_5fba2032
	Namespace: cDoor
	Checksum: 0x8DA9AEA7
	Offset: 0x270
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
	if(isdefined(self.m_e_trigger))
	{
		self.m_e_trigger delete();
	}
}

/*
	Name: init_xmodel
	Namespace: cDoor
	Checksum: 0x69916EA7
	Offset: 0x2A8
	Size: 0xBB
	Parameters: 4
	Flags: None
*/
function init_xmodel(str_xmodel, connect_paths, v_origin, v_angles)
{
	if(!isdefined(str_xmodel))
	{
		str_xmodel = "script_origin";
	}
	self.m_e_door = spawn("script_model", v_origin, 1);
	self.m_e_door SetModel(str_xmodel);
	self.m_e_door.angles = v_angles;
	if(connect_paths)
	{
		self.m_e_door disconnectpaths();
	}
}

/*
	Name: get_hack_pos
	Namespace: cDoor
	Checksum: 0x46E8E6C9
	Offset: 0x370
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function get_hack_pos()
{
	v_trigger_offset = self.m_s_bundle.v_trigger_offset;
	v_pos = calculate_offset_position(self.m_e_door.origin, self.m_e_door.angles, v_trigger_offset);
	v_pos = (v_pos[0], v_pos[1], v_pos[2] + 50);
	if(isdefined(self.m_str_target))
	{
		e_target = GetEnt(self.m_str_target, "targetname");
		if(isdefined(e_target))
		{
			return e_target.origin;
		}
	}
	return v_pos;
}

/*
	Name: get_hack_angles
	Namespace: cDoor
	Checksum: 0x57820E12
	Offset: 0x460
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function get_hack_angles()
{
	v_angles = self.m_e_door.angles;
	if(isdefined(self.m_str_target))
	{
		e_target = GetEnt(self.m_str_target, "targetname");
		if(isdefined(e_target))
		{
			return e_target.angles;
		}
	}
	return v_angles;
}

/*
	Name: init_hint_trigger
	Namespace: cDoor
	Checksum: 0xEF60C3C9
	Offset: 0x4E0
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function init_hint_trigger()
{
	if(self.m_s_bundle.door_unlock_method == "default" && (!isdefined(self.m_s_bundle.door_trigger_at_target) && self.m_s_bundle.door_trigger_at_target))
	{
		return;
	}
	if(self.m_s_bundle.door_unlock_method == "key")
	{
		return;
	}
	v_offset = self.m_s_bundle.v_trigger_offset;
	n_radius = self.m_s_bundle.door_trigger_radius;
	v_pos = calculate_offset_position(self.m_e_door.origin, self.m_e_door.angles, v_offset);
	v_pos = (v_pos[0], v_pos[1], v_pos[2] + 50);
	e_trig = spawn("trigger_radius_use", v_pos, 0, n_radius, self.m_n_trigger_height);
	e_trig TriggerIgnoreTeam();
	e_trig SetVisibleToAll();
	e_trig SetTeamForTrigger("none");
	e_trig UseTriggerRequireLookAt();
	e_trig setcursorhint("HINT_NOICON");
	self.m_e_hint_trigger = e_trig;
	thread process_hint_trigger_message();
}

/*
	Name: Lock
	Namespace: cDoor
	Checksum: 0xB234477B
	Offset: 0x6D8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function Lock()
{
	self flag::set("locked");
	update_use_message();
}

/*
	Name: unlock
	Namespace: cDoor
	Checksum: 0x2A5369BB
	Offset: 0x718
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function unlock()
{
	self flag::clear("locked");
}

/*
	Name: delete_door
	Namespace: cDoor
	Checksum: 0x1AAC9C86
	Offset: 0x748
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function delete_door()
{
	self.m_e_door delete();
	self.m_e_door = undefined;
	if(isdefined(self.m_e_trigger))
	{
		self.m_e_trigger delete();
		self.m_e_trigger = undefined;
	}
}

/*
	Name: open
	Namespace: cDoor
	Checksum: 0x1735149A
	Offset: 0x7A8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function open()
{
	self flag::set("open");
}

/*
	Name: close_internal
	Namespace: cDoor
	Checksum: 0x28AEFD97
	Offset: 0x7D8
	Size: 0x35B
	Parameters: 0
	Flags: None
*/
function close_internal()
{
	self flag::clear("open");
	set_script_flags(0);
	self flag::set("animating");
	if(isdefined(self.m_s_bundle.b_loop_sound) && self.m_s_bundle.b_loop_sound)
	{
		self.m_e_door playsound(self.m_s_bundle.door_start_sound);
		sndent = spawn("script_origin", self.m_e_door.origin);
		sndent LinkTo(self.m_e_door);
		sndent PlayLoopSound(self.m_s_bundle.door_loop_sound, 1);
	}
	else if(isdefined(self.m_s_bundle.door_stop_sound) && self.m_s_bundle.door_stop_sound != "")
	{
		self.m_e_door playsound(self.m_s_bundle.door_stop_sound);
	}
	if(self.m_s_bundle.door_open_method == "slide")
	{
		self.m_e_door moveto(self.m_v_close_pos, self.m_s_bundle.door_open_time);
	}
	else if(self.m_s_bundle.door_open_method == "swing")
	{
		angle = GetSwingAngle();
		v_angle = (self.m_e_door.angles[0], self.m_e_door.angles[1] - angle, self.m_e_door.angles[2]);
		self.m_e_door RotateTo(v_angle, self.m_s_bundle.door_open_time);
	}
	wait(self.m_s_bundle.door_open_time);
	if(isdefined(self.m_n_door_connect_paths) && self.m_n_door_connect_paths)
	{
		self.m_e_door disconnectpaths();
	}
	if(isdefined(self.m_s_bundle.b_loop_sound) && self.m_s_bundle.b_loop_sound)
	{
		sndent delete();
		self.m_e_door playsound(self.m_s_bundle.door_stop_sound);
	}
	flag::clear("animating");
	update_use_message();
}

/*
	Name: close
	Namespace: cDoor
	Checksum: 0xFFD4001C
	Offset: 0xB40
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function close()
{
	self flag::clear("open");
}

/*
	Name: open_internal
	Namespace: cDoor
	Checksum: 0xD665CD3
	Offset: 0xB70
	Size: 0x353
	Parameters: 0
	Flags: None
*/
function open_internal()
{
	self flag::set("animating");
	self.m_e_door notify("door_opening");
	if(isdefined(self.m_s_bundle.door_start_sound) && self.m_s_bundle.door_start_sound != "")
	{
		self.m_e_door playsound(self.m_s_bundle.door_start_sound);
	}
	if(isdefined(self.m_s_bundle.b_loop_sound) && self.m_s_bundle.b_loop_sound)
	{
		sndent = spawn("script_origin", self.m_e_door.origin);
		sndent LinkTo(self.m_e_door);
		sndent PlayLoopSound(self.m_s_bundle.door_loop_sound, 1);
	}
	if(self.m_s_bundle.door_open_method == "slide")
	{
		self.m_e_door moveto(self.m_v_open_pos, self.m_s_bundle.door_open_time);
	}
	else if(self.m_s_bundle.door_open_method == "swing")
	{
		angle = GetSwingAngle();
		v_angle = (self.m_e_door.angles[0], self.m_e_door.angles[1] + angle, self.m_e_door.angles[2]);
		self.m_e_door RotateTo(v_angle, self.m_s_bundle.door_open_time);
	}
	if(isdefined(self.m_n_door_connect_paths) && self.m_n_door_connect_paths)
	{
		self.m_e_door connectpaths();
	}
	wait(self.m_s_bundle.door_open_time);
	if(isdefined(self.m_s_bundle.b_loop_sound) && self.m_s_bundle.b_loop_sound)
	{
		sndent delete();
	}
	if(isdefined(self.m_s_bundle.door_stop_sound) && self.m_s_bundle.door_stop_sound != "")
	{
		self.m_e_door playsound(self.m_s_bundle.door_stop_sound);
	}
	flag::clear("animating");
	set_script_flags(1);
	update_use_message();
}

/*
	Name: update_use_message
	Namespace: cDoor
	Checksum: 0x80E55F01
	Offset: 0xED0
	Size: 0x121
	Parameters: 0
	Flags: None
*/
function update_use_message()
{
	if(!(isdefined(self.m_s_bundle.door_use_trigger) && self.m_s_bundle.door_use_trigger))
	{
		return;
	}
	if(self flag::get("open"))
	{
		if(!(isdefined(self.m_s_bundle.door_closes) && self.m_s_bundle.door_closes))
		{
		}
	}
	else if(isdefined(self.m_s_bundle.door_open_message) && self.m_s_bundle.door_open_message != "")
	{
	}
	else if(isdefined(self.m_s_bundle.door_use_hold) && self.m_s_bundle.door_use_hold)
	{
	}
	else if(self.m_s_bundle.door_unlock_method == "key")
	{
	}
	else if(self flag::get("locked"))
	{
	}
}

/*
	Name: run_lock_fx
	Namespace: cDoor
	Checksum: 0x27951F73
	Offset: 0x1000
	Size: 0x237
	Parameters: 0
	Flags: None
*/
function run_lock_fx()
{
	if(!isdefined(self.m_s_bundle.door_locked_fx) && !isdefined(self.m_s_bundle.door_unlocked_fx))
	{
		return;
	}
	e_fx = undefined;
	v_pos = get_hack_pos();
	v_angles = get_hack_angles();
	while(1)
	{
		self flag::wait_till("locked");
		if(isdefined(e_fx))
		{
			e_fx delete();
			e_fx = undefined;
		}
		if(isdefined(self.m_s_bundle.door_locked_fx))
		{
			e_fx = spawn("script_model", v_pos);
			e_fx SetModel("tag_origin");
			e_fx.angles = v_angles;
			PlayFXOnTag(self.m_s_bundle.door_locked_fx, e_fx, "tag_origin");
		}
		self flag::wait_till_clear("locked");
		if(isdefined(e_fx))
		{
			e_fx delete();
			e_fx = undefined;
		}
		if(isdefined(self.m_s_bundle.door_unlocked_fx))
		{
			e_fx = spawn("script_model", v_pos);
			e_fx SetModel("tag_origin");
			e_fx.angles = v_angles;
			PlayFXOnTag(self.m_s_bundle.door_unlocked_fx, e_fx, "tag_origin");
		}
	}
}

/*
	Name: process_hint_trigger_message
	Namespace: cDoor
	Checksum: 0xAD8CDF04
	Offset: 0x1240
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function process_hint_trigger_message()
{
	str_hint = "";
	if(isdefined(self.m_s_bundle.door_trigger_at_target) && self.m_s_bundle.door_trigger_at_target)
	{
		str_hint = "This door is controlled elsewhere";
		continue;
	}
	if(self.m_s_bundle.door_unlock_method == "hack")
	{
		str_hint = "This door is electronically locked";
	}
	while(1)
	{
		self.m_e_hint_trigger setHintString(str_hint);
		if(isdefined(self.m_s_bundle.door_trigger_at_target) && self.m_s_bundle.door_trigger_at_target)
		{
			self flag::wait_till("open");
		}
		else
		{
			self flag::wait_till_clear("locked");
		}
		self.m_e_hint_trigger setHintString("");
		if(isdefined(self.m_s_bundle.door_trigger_at_target) && self.m_s_bundle.door_trigger_at_target)
		{
			self flag::wait_till_clear("open");
		}
		else
		{
			self flag::wait_till("locked");
		}
	}
}

/*
	Name: init_trigger
	Namespace: cDoor
	Checksum: 0xBB002632
	Offset: 0x13C8
	Size: 0x20B
	Parameters: 2
	Flags: None
*/
function init_trigger(v_offset, n_radius)
{
	v_pos = calculate_offset_position(self.m_e_door.origin, self.m_e_door.angles, v_offset);
	v_pos = (v_pos[0], v_pos[1], v_pos[2] + 50);
	if(isdefined(self.m_s_bundle.door_trigger_at_target) && self.m_s_bundle.door_trigger_at_target)
	{
		e_target = GetEnt(self.m_str_target, "targetname");
		if(isdefined(e_target))
		{
			v_pos = e_target.origin;
		}
	}
	if(isdefined(self.m_s_bundle.door_use_trigger) && self.m_s_bundle.door_use_trigger)
	{
		self.m_e_trigger = spawn("trigger_radius_use", v_pos, 0, n_radius, self.m_n_trigger_height);
		self.m_e_trigger TriggerIgnoreTeam();
		self.m_e_trigger SetVisibleToAll();
		self.m_e_trigger SetTeamForTrigger("none");
		self.m_e_trigger UseTriggerRequireLookAt();
		self.m_e_trigger setcursorhint("HINT_NOICON");
	}
	else
	{
		self.m_e_trigger = spawn("trigger_radius", v_pos, 0, n_radius, self.m_n_trigger_height);
	}
}

/*
	Name: set_script_flags
	Namespace: cDoor
	Checksum: 0x9BE49C60
	Offset: 0x15E0
	Size: 0xF9
	Parameters: 1
	Flags: None
*/
function set_script_flags(b_set)
{
	if(isdefined(self.m_str_script_flag))
	{
		a_flags = StrTok(self.m_str_script_flag, ",");
		foreach(str_flag in a_flags)
		{
			if(b_set)
			{
				level flag::set(str_flag);
				continue;
			}
			level flag::clear(str_flag);
		}
	}
}

/*
	Name: init_movement
	Namespace: cDoor
	Checksum: 0x483A0BAE
	Offset: 0x16E8
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function init_movement(n_slide_up, n_slide_amount)
{
	if(self.m_s_bundle.door_open_method == "slide")
	{
		if(n_slide_up)
		{
			v_offset = (0, 0, n_slide_amount);
		}
		else
		{
			v_offset = (n_slide_amount, 0, 0);
		}
		self.m_v_open_pos = calculate_offset_position(self.m_e_door.origin, self.m_e_door.angles, v_offset);
		self.m_v_close_pos = self.m_e_door.origin;
	}
}

/*
	Name: set_door_paths
	Namespace: cDoor
	Checksum: 0x53EBB206
	Offset: 0x17B0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function set_door_paths(n_door_connect_paths)
{
	self.m_n_door_connect_paths = n_door_connect_paths;
}

/*
	Name: calculate_offset_position
	Namespace: cDoor
	Checksum: 0x6DA45DE7
	Offset: 0x17D0
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function calculate_offset_position(v_origin, v_angles, v_offset)
{
	v_pos = v_origin;
	if(v_offset[0])
	{
		v_side = AnglesToForward(v_angles);
		v_pos = v_pos + v_offset[0] * v_side;
	}
	if(v_offset[1])
	{
		v_dir = AnglesToRight(v_angles);
		v_pos = v_pos + v_offset[1] * v_dir;
	}
	if(v_offset[2])
	{
		v_up = anglesToUp(v_angles);
		v_pos = v_pos + v_offset[2] * v_up;
	}
	return v_pos;
}

/*
	Name: set_swing_angle
	Namespace: cDoor
	Checksum: 0x743EE8A4
	Offset: 0x18F0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function set_swing_angle(angle)
{
	self.m_override_swing_angle = angle;
}

/*
	Name: GetSwingAngle
	Namespace: cDoor
	Checksum: 0x4659AA50
	Offset: 0x1910
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function GetSwingAngle()
{
	if(isdefined(self.m_override_swing_angle))
	{
		angle = self.m_override_swing_angle;
	}
	else
	{
		angle = self.m_s_bundle.door_swing_angle;
	}
	return angle;
}

/*
	Name: SetDoorOpenDelay
	Namespace: cDoor
	Checksum: 0x4509FF20
	Offset: 0x1958
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function SetDoorOpenDelay(delay_time)
{
	self.m_door_open_delay_time = delay_time;
}

#namespace doors;

/*
	Name: cDoor
	Namespace: doors
	Checksum: 0xCA7221DF
	Offset: 0x1978
	Size: 0x4A5
	Parameters: 0
	Flags: 6
*/
function private autoexec cDoor()
{
	classes.cDoor[0] = spawnstruct();
	classes.cDoor[0].__vtable[1336728104] = &cDoor::SetDoorOpenDelay;
	classes.cDoor[0].__vtable[-1385799904] = &cDoor::GetSwingAngle;
	classes.cDoor[0].__vtable[545224600] = &cDoor::set_swing_angle;
	classes.cDoor[0].__vtable[-97650009] = &cDoor::calculate_offset_position;
	classes.cDoor[0].__vtable[943284939] = &cDoor::set_door_paths;
	classes.cDoor[0].__vtable[-1256085383] = &cDoor::init_movement;
	classes.cDoor[0].__vtable[1189441475] = &cDoor::set_script_flags;
	classes.cDoor[0].__vtable[1427073926] = &cDoor::init_trigger;
	classes.cDoor[0].__vtable[886634661] = &cDoor::process_hint_trigger_message;
	classes.cDoor[0].__vtable[-1510748301] = &cDoor::run_lock_fx;
	classes.cDoor[0].__vtable[-529998670] = &cDoor::update_use_message;
	classes.cDoor[0].__vtable[-691551209] = &cDoor::open_internal;
	classes.cDoor[0].__vtable[-1247479729] = &cDoor::close;
	classes.cDoor[0].__vtable[-379193783] = &cDoor::close_internal;
	classes.cDoor[0].__vtable[206324137] = &cDoor::open;
	classes.cDoor[0].__vtable[423820431] = &cDoor::delete_door;
	classes.cDoor[0].__vtable[1513534149] = &cDoor::unlock;
	classes.cDoor[0].__vtable[6626168] = &cDoor::Lock;
	classes.cDoor[0].__vtable[-223333212] = &cDoor::init_hint_trigger;
	classes.cDoor[0].__vtable[-696337716] = &cDoor::get_hack_angles;
	classes.cDoor[0].__vtable[1794592682] = &cDoor::get_hack_pos;
	classes.cDoor[0].__vtable[-1234449151] = &cDoor::init_xmodel;
	classes.cDoor[0].__vtable[1606033458] = &cDoor::function_5fba2032;
	classes.cDoor[0].__vtable[-1690805083] = &cDoor::function_9b385ca5;
}

/*
	Name: __init__sytem__
	Namespace: doors
	Checksum: 0xF1DF7E63
	Offset: 0x1E28
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("doors", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: doors
	Checksum: 0x9AE5757F
	Offset: 0x1E68
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function __init__()
{
	a_doors = struct::get_array("scriptbundle_doors", "classname");
	foreach(s_instance in a_doors)
	{
		c_door = s_instance init();
		if(isdefined(c_door))
		{
			s_instance.c_door = c_door;
		}
	}
}

/*
	Name: init
	Namespace: doors
	Checksum: 0xBDE7E972
	Offset: 0x1F50
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(self.angles))
	{
		self.angles = (0, 0, 0);
	}
	s_door_bundle = level.scriptbundles["doors"][self.scriptbundlename];
	return setup_door_scriptbundle(s_door_bundle, self);
}

/*
	Name: setup_door_scriptbundle
	Namespace: doors
	Checksum: 0xD682492C
	Offset: 0x1FB8
	Size: 0x767
	Parameters: 2
	Flags: None
*/
function setup_door_scriptbundle()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: door_open_update
	Namespace: doors
	Checksum: 0x8243F2C9
	Offset: 0x2728
	Size: 0x3C7
	Parameters: 1
	Flags: None
*/
function door_open_update()
{
System.InvalidOperationException: Stack empty.
   at System.ThrowHelper.ThrowInvalidOperationException(ExceptionResource resource)
   at System.Collections.Generic.Stack`1.Pop()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: door_update
	Namespace: doors
	Checksum: 0xB03FB4DF
	Offset: 0x2AF8
	Size: 0x271
	Parameters: 1
	Flags: None
*/
function door_update(c_door)
{
	str_unlock_method = "default";
	if(isdefined(c_door.m_s_bundle.door_unlock_method))
	{
		str_unlock_method = c_door.m_s_bundle.door_unlock_method;
	}
	if(isdefined(c_door.m_s_bundle.door_locked) && c_door.m_s_bundle.door_locked && str_unlock_method != "key")
	{
		c_door flag::set("locked");
		if(isdefined(c_door.m_str_targetname))
		{
			thread door_update_lock_scripted(c_door);
		}
	}
	thread door_open_update(c_door);
	update_use_message();
	while(1)
	{
		if(c_door flag::get("locked"))
		{
			c_door flag::wait_till_clear("locked");
		}
		c_door flag::wait_till("open");
		if(c_door.m_door_open_delay_time > 0)
		{
			c_door.m_e_door notify("door_waiting_to_open", c_door.m_e_trigger_player, c_door);
			wait(c_door.m_door_open_delay_time);
		}
		open_internal();
		c_door flag::wait_till_clear("open");
		close_internal();
		if(!(isdefined(c_door.m_s_bundle.door_closes) && c_door.m_s_bundle.door_closes))
		{
			break;
		}
		wait(0.05);
	}
	c_door.m_e_trigger delete();
	c_door.m_e_trigger = undefined;
}

/*
	Name: door_update_lock_scripted
	Namespace: doors
	Checksum: 0xD1A569CD
	Offset: 0x2D78
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function door_update_lock_scripted(c_door)
{
	door_str = c_door.m_str_targetname;
	c_door.m_e_trigger.targetname = door_str + "_trig";
	while(1)
	{
		c_door.m_e_trigger waittill("unlocked");
		unlock();
	}
}

/*
	Name: player_freeze_in_place
	Namespace: doors
	Checksum: 0xFE6C3B34
	Offset: 0x2E00
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function player_freeze_in_place(b_do_freeze)
{
	if(!b_do_freeze)
	{
		if(isdefined(self.freeze_origin))
		{
			self Unlink();
			self.freeze_origin delete();
			self.freeze_origin = undefined;
		}
	}
	else if(!isdefined(self.freeze_origin))
	{
		self.freeze_origin = spawn("script_model", self.origin);
		self.freeze_origin SetModel("tag_origin");
		self.freeze_origin.angles = self.angles;
		self PlayerLinkToDelta(self.freeze_origin, "tag_origin", 1, 45, 45, 45, 45);
	}
}

/*
	Name: trigger_wait_until_clear
	Namespace: doors
	Checksum: 0xCD587D65
	Offset: 0x2F28
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function trigger_wait_until_clear(c_door)
{
	self endon("death");
	last_trigger_time = GetTime();
	self.ents_in_trigger = 1;
	str_kill_trigger_notify = "trigger_now_clear";
	self thread trigger_check_for_ents_touching(str_kill_trigger_notify);
	while(1)
	{
		time = GetTime();
		if(self.ents_in_trigger == 1)
		{
			self.ents_in_trigger = 0;
			last_trigger_time = time;
		}
		DT = time - last_trigger_time / 1000;
		if(DT >= 0.3)
		{
			break;
		}
		wait(0.05);
	}
	self notify(str_kill_trigger_notify);
}

/*
	Name: door_wait_until_user_release
	Namespace: doors
	Checksum: 0x6954BD70
	Offset: 0x3020
	Size: 0xF5
	Parameters: 3
	Flags: None
*/
function door_wait_until_user_release(c_door, e_triggerer, str_kill_on_door_notify)
{
	if(isdefined(str_kill_on_door_notify))
	{
		c_door endon(str_kill_on_door_notify);
	}
	wait(0.25);
	max_dist_sq = c_door.m_s_bundle.door_trigger_radius * c_door.m_s_bundle.door_trigger_radius;
	b_pressed = 1;
	n_dist = 0;
	do
	{
		wait(0.05);
		b_pressed = e_triggerer useButtonPressed();
		n_dist = DistanceSquared(e_triggerer.origin, self.origin);
	}
	while(!(b_pressed && n_dist < max_dist_sq));
}

/*
	Name: door_wait_until_clear
	Namespace: doors
	Checksum: 0x4F1D9DC3
	Offset: 0x3120
	Size: 0x213
	Parameters: 2
	Flags: None
*/
function door_wait_until_clear(c_door, e_triggerer)
{
	e_trigger = c_door.m_e_trigger;
	e_temp_trigger = undefined;
	if(isdefined(c_door.m_s_bundle.door_trigger_at_target) && c_door.m_s_bundle.door_trigger_at_target)
	{
		e_door = c_door.m_e_door;
		v_trigger_offset = c_door.m_s_bundle.v_trigger_offset;
		v_pos = calculate_offset_position(c_door, e_door.origin, e_door.angles);
		n_radius = c_door.m_s_bundle.door_trigger_radius;
		n_height = c_door.m_n_trigger_height;
		e_temp_trigger = spawn("trigger_radius", v_pos, 0, n_radius, n_height);
		e_trigger = e_temp_trigger;
	}
	if(isPlayer(e_triggerer) && (isdefined(c_door.m_s_bundle.door_use_hold) && c_door.m_s_bundle.door_use_hold))
	{
		c_door.m_e_trigger door_wait_until_user_release(c_door, e_triggerer);
	}
	e_trigger trigger_wait_until_clear(c_door);
	if(isdefined(e_temp_trigger))
	{
		e_temp_trigger delete();
	}
}

/*
	Name: trigger_check_for_ents_touching
	Namespace: doors
	Checksum: 0xEE1AFFA2
	Offset: 0x3340
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function trigger_check_for_ents_touching(str_kill_trigger_notify)
{
	self endon("death");
	self endon(str_kill_trigger_notify);
	while(1)
	{
		self waittill("trigger", e_who);
		self.ents_in_trigger = 1;
	}
}

/*
	Name: door_debug_line
	Namespace: doors
	Checksum: 0x517BA6BF
	Offset: 0x3398
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function door_debug_line(v_origin)
{
	self endon("death");
	while(1)
	{
		v_start = v_origin;
		v_end = v_start + VectorScale((0, 0, 1), 1000);
		v_col = (0, 0, 1);
		/#
			line(v_start, v_end, (0, 0, 1));
		#/
		wait(0.1);
	}
}

/*
	Name: player_has_key
	Namespace: doors
	Checksum: 0xA3E29DB3
	Offset: 0x3430
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function player_has_key(str_key_type)
{
	if(!isdefined(self.collectible_keys))
	{
		return 0;
	}
	if(!isdefined(self.collectible_keys[str_key_type]))
	{
		return 0;
	}
	return self.collectible_keys[str_key_type].num_keys > 0;
}

/*
	Name: player_take_key
	Namespace: doors
	Checksum: 0xFF21EF6D
	Offset: 0x3488
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function player_take_key(str_key_type)
{
	if(!player_has_key(str_key_type))
	{
		return;
	}
	self.collectible_keys[str_key_type].num_keys--;
	if(self.collectible_keys[str_key_type].num_keys <= 0 && isdefined(self.collectible_keys[str_key_type].hudelem))
	{
		self.collectible_keys[str_key_type].hudelem destroy();
		self.collectible_keys[str_key_type].hudelem = undefined;
	}
}

/*
	Name: rotate_key_forever
	Namespace: doors
	Checksum: 0xE8F7B543
	Offset: 0x3550
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function rotate_key_forever()
{
	self endon("death");
	while(1)
	{
		self RotateYaw(180, 3);
		wait(2.5);
	}
}

/*
	Name: key_process_timeout
	Namespace: doors
	Checksum: 0x4A64825A
	Offset: 0x3598
	Size: 0x173
	Parameters: 3
	Flags: None
*/
function key_process_timeout(n_timeout_sec, e_trigger, e_model)
{
	e_trigger endon("death");
	if(n_timeout_sec < 5)
	{
		n_timeout_sec = 5 + 1;
	}
	wait(n_timeout_sec - 5);
	n_stepsize = 0.5;
	b_on = 1;
	for(f = 0; f < 5;  = 0)
	{
		if(b_on)
		{
			e_model Hide();
		}
		else
		{
			e_model show();
		}
		b_on = !b_on;
		wait(n_stepsize);
		if(n_stepsize > 0.15)
		{
			n_stepsize = n_stepsize * 0.9;
		}
	}
	level notify("key_drop_timeout", f + n_stepsize);
	e_model delete();
	e_trigger delete();
}

/*
	Name: give_ai_key_internal
	Namespace: doors
	Checksum: 0x40E6EA88
	Offset: 0x3718
	Size: 0x29B
	Parameters: 2
	Flags: None
*/
function give_ai_key_internal(n_timeout_sec, str_key_type)
{
	v_pos = self.origin;
	e_model = spawn("script_model", v_pos + VectorScale((0, 0, 1), 80));
	e_model.angles = VectorScale((1, 0, 1), 10);
	e_model SetModel(level.door_key_model);
	if(isdefined(level.door_key_fx))
	{
		PlayFXOnTag(level.door_key_fx, e_model, "tag_origin");
	}
	while(isalive(self))
	{
		e_model moveto(self.origin + VectorScale((0, 0, 1), 80), 0.2);
		e_model RotateYaw(30, 0.2);
		wait(0.1);
	}
	e_model MoveZ(-60, 1);
	wait(1);
	e_model thread rotate_key_forever();
	e_trigger = spawn("trigger_radius", e_model.origin, 0, 25, 100);
	if(isdefined(n_timeout_sec))
	{
		level thread key_process_timeout(n_timeout_sec, e_trigger, e_model);
	}
	e_trigger endon("death");
	while(1)
	{
		e_trigger waittill("trigger", e_who);
		if(isPlayer(e_who))
		{
			e_who give_player_key(str_key_type);
			break;
		}
	}
	e_model delete();
	e_trigger delete();
}

/*
	Name: give_ai_key
	Namespace: doors
	Checksum: 0xF57CC901
	Offset: 0x39C0
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function give_ai_key(n_timeout_sec, str_key_type)
{
	if(!isdefined(n_timeout_sec))
	{
		n_timeout_sec = undefined;
	}
	if(!isdefined(str_key_type))
	{
		str_key_type = "door";
	}
	/#
		Assert(isdefined(level.door_key_model), "Dev Block strings are not supported");
	#/
	self thread give_ai_key_internal(n_timeout_sec, str_key_type);
}

/*
	Name: give_player_key
	Namespace: doors
	Checksum: 0x230F1AD7
	Offset: 0x3A50
	Size: 0x20F
	Parameters: 1
	Flags: None
*/
function give_player_key(str_key_type)
{
	if(!isdefined(str_key_type))
	{
		str_key_type = "door";
	}
	/#
		Assert(isdefined(level.door_key_icon), "Dev Block strings are not supported");
	#/
	if(!isdefined(self.collectible_keys))
	{
		self.collectible_keys = [];
	}
	if(!isdefined(self.collectible_keys[str_key_type]))
	{
		self.collectible_keys[str_key_type] = spawnstruct();
		self.collectible_keys[str_key_type].num_keys = 0;
		self.collectible_keys[str_key_type].type = str_key_type;
	}
	hudelem = self.collectible_keys[str_key_type].hudelem;
	if(!isdefined(hudelem))
	{
		hudelem = newClientHudElem(self);
	}
	hudelem.alignX = "right";
	hudelem.alignY = "bottom";
	hudelem.horzAlign = "right";
	hudelem.vertAlign = "bottom";
	hudelem.hidewheninmenu = 1;
	hudelem.hideWhenInDemo = 1;
	hudelem.y = -75;
	hudelem.x = -25;
	hudelem SetShader(level.door_key_icon, 16, 16);
	self.collectible_keys[str_key_type].hudelem = hudelem;
	self.collectible_keys[str_key_type].num_keys++;
}

/*
	Name: unlock_all
	Namespace: doors
	Checksum: 0xBBF92A43
	Offset: 0x3C68
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function unlock_all(b_do_open)
{
	if(!isdefined(b_do_open))
	{
		b_do_open = 1;
	}
	a_s_inst_list = struct::get_array("scriptbundle_doors", "classname");
	foreach(s_inst in a_s_inst_list)
	{
		c_door = s_inst.c_door;
		if(isdefined(c_door))
		{
			unlock();
			if(b_do_open)
			{
				open();
			}
		}
	}
}

/*
	Name: unlock
	Namespace: doors
	Checksum: 0x5DAE71B2
	Offset: 0x3D80
	Size: 0x129
	Parameters: 3
	Flags: None
*/
function unlock(str_name, str_name_type, b_do_open)
{
	if(!isdefined(str_name_type))
	{
		str_name_type = "targetname";
	}
	if(!isdefined(b_do_open))
	{
		b_do_open = 1;
	}
	a_s_inst_list = struct::get_array(str_name, str_name_type);
	foreach(s_inst in a_s_inst_list)
	{
		if(isdefined(s_inst.c_door))
		{
			unlock();
			if(b_do_open)
			{
				open();
			}
		}
	}
}

