#using scripts\shared\animation_debug_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\shaderanim_shared;
#using scripts\shared\system_shared;

#namespace animation;

/*
	Name: __init__sytem__
	Namespace: animation
	Checksum: 0xE0AC7F5E
	Offset: 0x348
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("animation", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: animation
	Checksum: 0x25DA405
	Offset: 0x388
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "cracks_on", 1, GetMinBitCountForNum(4), "int", &cf_cracks_on, 0, 0);
	clientfield::register("scriptmover", "cracks_off", 1, GetMinBitCountForNum(4), "int", &cf_cracks_off, 0, 0);
	setup_notetracks();
}

/*
	Name: first_frame
	Namespace: animation
	Checksum: 0x311D4031
	Offset: 0x458
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function first_frame(animation, v_origin_or_ent, v_angles_or_tag)
{
	self thread Play(animation, v_origin_or_ent, v_angles_or_tag, 0);
}

/*
	Name: Play
	Namespace: animation
	Checksum: 0xDF4D2215
	Offset: 0x4A0
	Size: 0xE7
	Parameters: 8
	Flags: None
*/
function Play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, b_link)
{
	if(!isdefined(n_rate))
	{
		n_rate = 1;
	}
	if(!isdefined(n_blend_in))
	{
		n_blend_in = 0.2;
	}
	if(!isdefined(n_blend_out))
	{
		n_blend_out = 0.2;
	}
	if(!isdefined(b_link))
	{
		b_link = 0;
	}
	self endon("entityshutdown");
	self thread _play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, b_link);
	self waittill("scriptedanim");
}

/*
	Name: _play
	Namespace: animation
	Checksum: 0x5831FC01
	Offset: 0x590
	Size: 0x3F3
	Parameters: 8
	Flags: None
*/
function _play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, b_link)
{
	if(!isdefined(n_rate))
	{
		n_rate = 1;
	}
	if(!isdefined(n_blend_in))
	{
		n_blend_in = 0.2;
	}
	if(!isdefined(n_blend_out))
	{
		n_blend_out = 0.2;
	}
	if(!isdefined(b_link))
	{
		b_link = 0;
	}
	self endon("entityshutdown");
	self notify("new_scripted_anim");
	self endon("new_scripted_anim");
	flagsys::set_val("firstframe", n_rate == 0);
	flagsys::set("scripted_anim_this_frame");
	flagsys::set("scriptedanim");
	if(!isdefined(v_origin_or_ent))
	{
		v_origin_or_ent = self;
	}
	if(IsVec(v_origin_or_ent) && IsVec(v_angles_or_tag))
	{
		self AnimScripted("_anim_notify_", v_origin_or_ent, v_angles_or_tag, animation, n_blend_in, n_rate);
	}
	else if(IsString(v_angles_or_tag))
	{
		/#
			Assert(isdefined(v_origin_or_ent.model), "Dev Block strings are not supported" + animation + "Dev Block strings are not supported" + v_angles_or_tag + "Dev Block strings are not supported");
		#/
		v_pos = v_origin_or_ent GetTagOrigin(v_angles_or_tag);
		v_ang = v_origin_or_ent GetTagAngles(v_angles_or_tag);
		self.origin = v_pos;
		self.angles = v_ang;
		b_link = 1;
		self AnimScripted("_anim_notify_", self.origin, self.angles, animation, n_blend_in, n_rate);
	}
	else if(isdefined(v_origin_or_ent.angles))
	{
	}
	else
	{
	}
	v_angles = (0, 0, 0);
	self AnimScripted("_anim_notify_", v_origin_or_ent.origin, v_angles, animation, n_blend_in, n_rate);
	if(!b_link)
	{
		self Unlink();
	}
	/#
		self thread anim_info_render_thread(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp);
	#/
	self thread handle_notetracks();
	self waittill_end();
	if(b_link)
	{
		self Unlink();
	}
	flagsys::clear("scriptedanim");
	flagsys::clear("firstframe");
	waittillframeend;
	flagsys::clear("scripted_anim_this_frame");
}

/*
	Name: waittill_end
	Namespace: animation
	Checksum: 0xC638E379
	Offset: 0x990
	Size: 0x25
	Parameters: 0
	Flags: Private
*/
function private waittill_end()
{
	level endon("demo_jump");
	self waittillmatch("_anim_notify_");
}

/*
	Name: _get_align_ent
	Namespace: animation
	Checksum: 0xA063394E
	Offset: 0x9C0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function _get_align_ent(e_align)
{
	e = self;
	if(isdefined(e_align))
	{
		e = e_align;
	}
	if(!isdefined(e.angles))
	{
		e.angles = (0, 0, 0);
	}
	return e;
}

/*
	Name: _get_align_pos
	Namespace: animation
	Checksum: 0x60BFAEE6
	Offset: 0xA28
	Size: 0x1DF
	Parameters: 2
	Flags: None
*/
function _get_align_pos(v_origin_or_ent, v_angles_or_tag)
{
	if(!isdefined(v_origin_or_ent))
	{
		v_origin_or_ent = self.origin;
	}
	if(!isdefined(v_angles_or_tag))
	{
		if(isdefined(self.angles))
		{
		}
		else
		{
		}
		v_angles_or_tag = (0, 0, 0);
	}
	s = spawnstruct();
	if(IsVec(v_origin_or_ent))
	{
		/#
			Assert(IsVec(v_angles_or_tag), "Dev Block strings are not supported");
		#/
		s.origin = v_origin_or_ent;
		s.angles = v_angles_or_tag;
	}
	else
	{
		e_align = _get_align_ent(v_origin_or_ent);
		if(IsString(v_angles_or_tag))
		{
			s.origin = e_align GetTagOrigin(v_angles_or_tag);
			s.angles = e_align GetTagAngles(v_angles_or_tag);
		}
		else
		{
			s.origin = e_align.origin;
			s.angles = e_align.angles;
		}
	}
	if(!isdefined(s.angles))
	{
		s.angles = (0, 0, 0);
	}
	return s;
}

/*
	Name: play_siege
	Namespace: animation
	Checksum: 0x4B654A82
	Offset: 0xC10
	Size: 0x157
	Parameters: 4
	Flags: None
*/
function play_siege(str_anim, str_shot, n_rate, b_loop)
{
	if(!isdefined(str_shot))
	{
		str_shot = "default";
	}
	if(!isdefined(n_rate))
	{
		n_rate = 1;
	}
	if(!isdefined(b_loop))
	{
		b_loop = 0;
	}
	level endon("demo_jump");
	self endon("entityshutdown");
	if(!isdefined(str_shot))
	{
		str_shot = "default";
	}
	if(n_rate == 0)
	{
		self SiegeCmd("set_anim", str_anim, "set_shot", str_shot, "pause", "goto_start");
	}
	else if(b_loop)
	{
	}
	else
	{
	}
	self SiegeCmd("set_anim", str_anim, "set_shot", str_shot, "unpause", "set_playback_speed", n_rate, "send_end_events", 1, "unloop");
	self waittill("end");
}

/*
	Name: add_notetrack_func
	Namespace: animation
	Checksum: 0xBDC28941
	Offset: 0xD70
	Size: 0x6D
	Parameters: 2
	Flags: None
*/
function add_notetrack_func(funcname, func)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		level._animnotifyfuncs = [];
	}
	/#
		Assert(!isdefined(level._animnotifyfuncs[funcname]), "Dev Block strings are not supported");
	#/
	level._animnotifyfuncs[funcname] = func;
}

/*
	Name: add_global_notetrack_handler
	Namespace: animation
	Checksum: 0xA1D627FB
	Offset: 0xDE8
	Size: 0x103
	Parameters: 3
	Flags: 32
*/
function add_global_notetrack_handler(str_note, func, vararg)
{
	if(!isdefined(level._animnotetrackhandlers))
	{
		level._animnotetrackhandlers = [];
	}
	if(!isdefined(level._animnotetrackhandlers[str_note]))
	{
		level._animnotetrackhandlers[str_note] = [];
	}
	if(!isdefined(level._animnotetrackhandlers[str_note]))
	{
		level._animnotetrackhandlers[str_note] = [];
	}
	else if(!IsArray(level._animnotetrackhandlers[str_note]))
	{
		level._animnotetrackhandlers[str_note] = Array(level._animnotetrackhandlers[str_note]);
	}
	level._animnotetrackhandlers[str_note][level._animnotetrackhandlers[str_note].size] = Array(func, vararg);
}

/*
	Name: call_notetrack_handler
	Namespace: animation
	Checksum: 0xE356F2BC
	Offset: 0xEF8
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function call_notetrack_handler(str_note)
{
	if(isdefined(level._animnotetrackhandlers) && isdefined(level._animnotetrackhandlers[str_note]))
	{
		foreach(handler in level._animnotetrackhandlers[str_note])
		{
			func = handler[0];
			args = handler[1];
			switch(args.size)
			{
				case 6:
				{
					self [[func]](args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				}
				case 5:
				{
					self [[func]](args[0], args[1], args[2], args[3], args[4]);
					break;
				}
				case 4:
				{
					self [[func]](args[0], args[1], args[2], args[3]);
					break;
				}
				case 3:
				{
					self [[func]](args[0], args[1], args[2]);
					break;
				}
				case 2:
				{
					self [[func]](args[0], args[1]);
					break;
				}
				case 1:
				{
					self [[func]](args[0]);
					break;
				}
				case 0:
				{
					self [[func]]();
					break;
				}
				case default:
				{
					/#
						ASSERTMSG("Dev Block strings are not supported");
					#/
				}
			}
		}
	}
}

/*
	Name: setup_notetracks
	Namespace: animation
	Checksum: 0x17B050D
	Offset: 0x1180
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function setup_notetracks()
{
	add_notetrack_func("flag::set", &flag::set);
	add_notetrack_func("flag::clear", &flag::clear);
	add_notetrack_func("postfx::PlayPostFxBundle", &postfx::playPostfxBundle);
	add_notetrack_func("postfx::StopPostFxBundle", &postfx::StopPostfxBundle);
	add_global_notetrack_handler("red_cracks_on", &cracks_on, "red");
	add_global_notetrack_handler("green_cracks_on", &cracks_on, "green");
	add_global_notetrack_handler("blue_cracks_on", &cracks_on, "blue");
	add_global_notetrack_handler("all_cracks_on", &cracks_on, "all");
	add_global_notetrack_handler("red_cracks_off", &cracks_off, "red");
	add_global_notetrack_handler("green_cracks_off", &cracks_off, "green");
	add_global_notetrack_handler("blue_cracks_off", &cracks_off, "blue");
	add_global_notetrack_handler("all_cracks_off", &cracks_off, "all");
}

/*
	Name: handle_notetracks
	Namespace: animation
	Checksum: 0x85FA08C8
	Offset: 0x13B0
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function handle_notetracks()
{
	level endon("demo_jump");
	self endon("entityshutdown");
	while(1)
	{
		self waittill("_anim_notify_", str_note);
		if(str_note != "end" && str_note != "loop_end")
		{
			self thread call_notetrack_handler(str_note);
		}
		else
		{
			return;
		}
	}
}

/*
	Name: cracks_on
	Namespace: animation
	Checksum: 0x1E682765
	Offset: 0x1438
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function cracks_on(str_type)
{
	switch(str_type)
	{
		case "red":
		{
			cf_cracks_on(self.localClientNum, 0, 1);
			break;
		}
		case "green":
		{
			cf_cracks_on(self.localClientNum, 0, 3);
			break;
		}
		case "blue":
		{
			cf_cracks_on(self.localClientNum, 0, 2);
			break;
		}
		case "all":
		{
			cf_cracks_on(self.localClientNum, 0, 4);
			break;
		}
	}
}

/*
	Name: cracks_off
	Namespace: animation
	Checksum: 0xB65B2C21
	Offset: 0x1500
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function cracks_off(str_type)
{
	switch(str_type)
	{
		case "red":
		{
			cf_cracks_off(self.localClientNum, 0, 1);
			break;
		}
		case "green":
		{
			cf_cracks_off(self.localClientNum, 0, 3);
			break;
		}
		case "blue":
		{
			cf_cracks_off(self.localClientNum, 0, 2);
			break;
		}
		case "all":
		{
			cf_cracks_off(self.localClientNum, 0, 4);
			break;
		}
	}
}

/*
	Name: cf_cracks_on
	Namespace: animation
	Checksum: 0xBDEE7454
	Offset: 0x15C8
	Size: 0x191
	Parameters: 7
	Flags: None
*/
function cf_cracks_on(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector1", 0, 3, 0, 1);
			break;
		}
		case 3:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector2", 0, 3, 0, 1);
			break;
		}
		case 2:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector3", 0, 3, 0, 1);
			break;
		}
		case 4:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector1", 0, 3, 0, 1);
			shaderanim::animate_crack(localClientNum, "scriptVector2", 0, 3, 0, 1);
			shaderanim::animate_crack(localClientNum, "scriptVector3", 0, 3, 0, 1);
		}
	}
}

/*
	Name: cf_cracks_off
	Namespace: animation
	Checksum: 0xA1D888F6
	Offset: 0x1768
	Size: 0x179
	Parameters: 7
	Flags: None
*/
function cf_cracks_off(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector1", 0, 0, 1, 0);
			break;
		}
		case 3:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector2", 0, 0, 1, 0);
			break;
		}
		case 2:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector3", 0, 0, 1, 0);
			break;
		}
		case 4:
		{
			shaderanim::animate_crack(localClientNum, "scriptVector1", 0, 0, 1, 0);
			shaderanim::animate_crack(localClientNum, "scriptVector2", 0, 0, 1, 0);
			shaderanim::animate_crack(localClientNum, "scriptVector3", 0, 0, 1, 0);
		}
	}
}

