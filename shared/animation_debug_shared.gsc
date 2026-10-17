#using scripts\shared\animation_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace animation;

/*
	Name: __init__
	Namespace: animation
	Checksum: 0x49208920
	Offset: 0xE0
	Size: 0xCF
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		while(1)
		{
			anim_debug = GetDvarInt("Dev Block strings are not supported", 0) || GetDvarInt("Dev Block strings are not supported", 0);
			level flagsys::set_val("Dev Block strings are not supported", anim_debug);
			if(!anim_debug)
			{
				level notify("kill_anim_debug");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: anim_info_render_thread
	Namespace: animation
	Checksum: 0xA1BFACD9
	Offset: 0x1B8
	Size: 0x6E7
	Parameters: 7
	Flags: None
*/
function anim_info_render_thread(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp)
{
	/#
		self endon("death");
		self endon("scriptedanim");
		self notify("_anim_info_render_thread_");
		self endon("_anim_info_render_thread_");
		if(!IsVec(v_origin_or_ent))
		{
			v_origin_or_ent endon("death");
		}
		RecordEnt(self);
		while(1)
		{
			level flagsys::wait_till("Dev Block strings are not supported");
			b_anim_debug_on = 1;
			_init_frame();
			str_extra_info = "Dev Block strings are not supported";
			color = (1, 1, 0);
			if(flagsys::get("Dev Block strings are not supported"))
			{
				str_extra_info = str_extra_info + "Dev Block strings are not supported";
			}
			s_pos = _get_align_pos(v_origin_or_ent, v_angles_or_tag);
			self anim_origin_render(s_pos.origin, s_pos.angles, undefined, undefined, !b_anim_debug_on);
			if(b_anim_debug_on)
			{
				line(self.origin, s_pos.origin, color, 0.5, 1);
				sphere(s_pos.origin, 2, VectorScale((1, 1, 1), 0.3), 0.5, 1);
			}
			recordLine(self.origin, s_pos.origin, color, "Dev Block strings are not supported");
			RecordSphere(s_pos.origin, 2, VectorScale((1, 1, 1), 0.3), "Dev Block strings are not supported");
			if(!IsVec(v_origin_or_ent) && (v_origin_or_ent != self && v_origin_or_ent != level))
			{
				str_name = "Dev Block strings are not supported";
				if(isdefined(v_origin_or_ent.animName))
				{
					str_name = v_origin_or_ent.animName;
				}
				else if(isdefined(v_origin_or_ent.targetname))
				{
					str_name = v_origin_or_ent.targetname;
				}
				if(b_anim_debug_on)
				{
					print3d(v_origin_or_ent.origin + VectorScale((0, 0, 1), 5), str_name, VectorScale((1, 1, 1), 0.3), 1, 0.15);
				}
				Record3DText(str_name, v_origin_or_ent.origin + VectorScale((0, 0, 1), 5), VectorScale((1, 1, 1), 0.3), "Dev Block strings are not supported");
			}
			self anim_origin_render(self.origin, self.angles, undefined, undefined, !b_anim_debug_on);
			str_name = "Dev Block strings are not supported";
			if(isdefined(self.anim_debug_name))
			{
				str_name = self.anim_debug_name;
			}
			else if(isdefined(self.animName))
			{
				str_name = self.animName;
			}
			else if(isdefined(self.targetname))
			{
				str_name = self.targetname;
			}
			if(b_anim_debug_on)
			{
				print3d(self.origin, self GetEntNum() + get_ent_type() + "Dev Block strings are not supported" + str_name, color, 0.8, 0.3);
				print3d(self.origin - VectorScale((0, 0, 1), 5), "Dev Block strings are not supported" + animation, color, 0.8, 0.3);
				print3d(self.origin - VectorScale((0, 0, 1), 7), str_extra_info, color, 0.8, 0.15);
			}
			Record3DText(self GetEntNum() + get_ent_type() + "Dev Block strings are not supported" + str_name, self.origin, color, "Dev Block strings are not supported");
			Record3DText("Dev Block strings are not supported" + animation, self.origin - VectorScale((0, 0, 1), 5), color, "Dev Block strings are not supported");
			Record3DText(str_extra_info, self.origin - VectorScale((0, 0, 1), 7), color, "Dev Block strings are not supported");
			render_tag("Dev Block strings are not supported", "Dev Block strings are not supported", !b_anim_debug_on);
			render_tag("Dev Block strings are not supported", "Dev Block strings are not supported", !b_anim_debug_on);
			render_tag("Dev Block strings are not supported", "Dev Block strings are not supported", !b_anim_debug_on);
			render_tag("Dev Block strings are not supported", "Dev Block strings are not supported", !b_anim_debug_on);
			_reset_frame();
			wait(0.05);
		}
	#/
}

/*
	Name: get_ent_type
	Namespace: animation
	Checksum: 0x559085F3
	Offset: 0x8A8
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function get_ent_type()
{
	/#
		if(IsActor(self))
		{
			return "Dev Block strings are not supported";
		}
		else if(isVehicle(self))
		{
			return "Dev Block strings are not supported";
		}
		else
		{
			return "Dev Block strings are not supported" + self.classname + "Dev Block strings are not supported";
		}
	#/
}

/*
	Name: _init_frame
	Namespace: animation
	Checksum: 0x4681CB72
	Offset: 0x920
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function _init_frame()
{
	/#
		self.v_centroid = self GetCentroid();
	#/
}

/*
	Name: _reset_frame
	Namespace: animation
	Checksum: 0x5C8339B3
	Offset: 0x950
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function _reset_frame()
{
	/#
		self.v_centroid = undefined;
	#/
}

/*
	Name: render_tag
	Namespace: animation
	Checksum: 0xA930CFB8
	Offset: 0x970
	Size: 0x143
	Parameters: 3
	Flags: None
*/
function render_tag(str_tag, str_label, b_recorder_only)
{
	/#
		if(!isdefined(str_label))
		{
			str_label = str_tag;
		}
		if(!isdefined(self.v_centroid))
		{
			self.v_centroid = self GetCentroid();
		}
		v_tag_org = self GetTagOrigin(str_tag);
		if(isdefined(v_tag_org))
		{
			v_tag_ang = self GetTagAngles(str_tag);
			anim_origin_render(v_tag_org, v_tag_ang, 2, str_label, b_recorder_only);
			if(!b_recorder_only)
			{
				line(self.v_centroid, v_tag_org, VectorScale((1, 1, 1), 0.3), 0.5, 1);
			}
			recordLine(self.v_centroid, v_tag_org, VectorScale((1, 1, 1), 0.3), "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: anim_origin_render
	Namespace: animation
	Checksum: 0xE0C0BA68
	Offset: 0xAC0
	Size: 0x25B
	Parameters: 5
	Flags: None
*/
function anim_origin_render(org, angles, line_length, str_label, b_recorder_only)
{
	/#
		if(!isdefined(line_length))
		{
			line_length = 6;
		}
		if(isdefined(org) && isdefined(angles))
		{
			originEndPoint = org + VectorScale(AnglesToForward(angles), line_length);
			originRightPoint = org + VectorScale(AnglesToRight(angles), -1 * line_length);
			originUpPoint = org + VectorScale(anglesToUp(angles), line_length);
			if(!b_recorder_only)
			{
				line(org, originEndPoint, (1, 0, 0));
				line(org, originRightPoint, (0, 1, 0));
				line(org, originUpPoint, (0, 0, 1));
			}
			recordLine(org, originEndPoint, (1, 0, 0), "Dev Block strings are not supported");
			recordLine(org, originRightPoint, (0, 1, 0), "Dev Block strings are not supported");
			recordLine(org, originUpPoint, (0, 0, 1), "Dev Block strings are not supported");
			if(isdefined(str_label))
			{
				if(!b_recorder_only)
				{
					print3d(org, str_label, (1, 0.7529412, 0.7960784), 1, 0.05);
				}
				Record3DText(str_label, org, (1, 0.7529412, 0.7960784), "Dev Block strings are not supported");
			}
		}
	#/
}

