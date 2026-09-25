#using scripts\shared\animation_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace animation;

/*
	Name: __init__
	Namespace: animation
	Checksum: 0x2D796748
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
			var_77a83846 = GetDvarInt("Dev Block strings are not supported", 0) || GetDvarInt("Dev Block strings are not supported", 0);
			level flagsys::set_val("Dev Block strings are not supported", var_77a83846);
			if(!var_77a83846)
			{
				level notify("hash_bcf33e7b");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: anim_info_render_thread
	Namespace: animation
	Checksum: 0x4CE08CAD
	Offset: 0x1B8
	Size: 0x4BF
	Parameters: 7
	Flags: None
*/
function anim_info_render_thread(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp)
{
	/#
		self endon("death");
		self endon("scriptedanim");
		self notify("hash_b8a0309f");
		self endon("hash_b8a0309f");
		while(1)
		{
			level flagsys::wait_till("Dev Block strings are not supported");
			function_b8bf0754();
			str_extra_info = "Dev Block strings are not supported";
			color = (0, 1, 1);
			if(flagsys::get("Dev Block strings are not supported"))
			{
				str_extra_info = str_extra_info + "Dev Block strings are not supported";
			}
			s_pos = _get_align_pos(v_origin_or_ent, v_angles_or_tag);
			self anim_origin_render(s_pos.origin, s_pos.angles);
			line(self.origin, s_pos.origin, color, 0.5, 1);
			sphere(s_pos.origin, 2, VectorScale((1, 1, 1), 0.3), 0.5, 1);
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
				print3d(v_origin_or_ent.origin + VectorScale((0, 0, 1), 5), str_name, VectorScale((1, 1, 1), 0.3), 1, 0.15);
			}
			self anim_origin_render(self.origin, self.angles);
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
			print3d(self.origin, self GetEntNum() + function_6596e38() + "Dev Block strings are not supported" + str_name, color, 0.8, 0.3);
			print3d(self.origin - VectorScale((0, 0, 1), 5), "Dev Block strings are not supported" + animation, color, 0.8, 0.3);
			print3d(self.origin - VectorScale((0, 0, 1), 7), str_extra_info, color, 0.8, 0.15);
			function_9063d1b4("Dev Block strings are not supported", "Dev Block strings are not supported");
			function_9063d1b4("Dev Block strings are not supported", "Dev Block strings are not supported");
			function_9063d1b4("Dev Block strings are not supported", "Dev Block strings are not supported");
			function_9063d1b4("Dev Block strings are not supported", "Dev Block strings are not supported");
			function_2182aee7();
			wait(0.01);
		}
	#/
}

/*
	Name: function_6596e38
	Namespace: animation
	Checksum: 0xF464E42
	Offset: 0x680
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function function_6596e38()
{
	/#
		if(isdefined(self.classname))
		{
		}
		else
		{
		}
		return self.classname + "Dev Block strings are not supported" + "Dev Block strings are not supported";
	#/
}

/*
	Name: function_b8bf0754
	Namespace: animation
	Checksum: 0x3EDA4064
	Offset: 0x6C8
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function function_b8bf0754()
{
	/#
	#/
}

/*
	Name: function_2182aee7
	Namespace: animation
	Checksum: 0xA115834F
	Offset: 0x6D8
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function function_2182aee7()
{
	/#
		self.var_cd57ce78 = undefined;
	#/
}

/*
	Name: function_9063d1b4
	Namespace: animation
	Checksum: 0xBA824C8C
	Offset: 0x6F8
	Size: 0xE3
	Parameters: 2
	Flags: None
*/
function function_9063d1b4(str_tag, str_label)
{
	/#
		if(!isdefined(str_label))
		{
			str_label = str_tag;
		}
		v_tag_org = self GetTagOrigin(str_tag);
		if(isdefined(v_tag_org))
		{
			v_tag_ang = self GetTagAngles(str_tag);
			anim_origin_render(v_tag_org, v_tag_ang, 2, str_label);
			if(isdefined(self.var_cd57ce78))
			{
				line(self.var_cd57ce78, v_tag_org, VectorScale((1, 1, 1), 0.3), 0.5, 1);
			}
		}
	#/
}

/*
	Name: anim_origin_render
	Namespace: animation
	Checksum: 0x9D5E1456
	Offset: 0x7E8
	Size: 0x18B
	Parameters: 4
	Flags: None
*/
function anim_origin_render(org, angles, line_length, str_label)
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
			line(org, originEndPoint, (1, 0, 0));
			line(org, originRightPoint, (0, 1, 0));
			line(org, originUpPoint, (0, 0, 1));
			if(isdefined(str_label))
			{
				print3d(org, str_label, (1, 0.7529412, 0.7960784), 1, 0.05);
			}
		}
	#/
}

