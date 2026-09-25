#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace colors;

/*
	Name: __init__sytem__
	Namespace: colors
	Checksum: 0x3EC97383
	Offset: 0x3C8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("colors", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: colors
	Checksum: 0x4C6F5581
	Offset: 0x410
	Size: 0x88B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	nodes = GetAllNodes();
	level flag::init("player_looks_away_from_spawner");
	level flag::init("friendly_spawner_locked");
	level flag::init("respawn_friendlies");
	level.arrays_of_colorCoded_nodes = [];
	level.arrays_of_colorCoded_nodes["axis"] = [];
	level.arrays_of_colorCoded_nodes["allies"] = [];
	level.colorCoded_volumes = [];
	level.colorCoded_volumes["axis"] = [];
	level.colorCoded_volumes["allies"] = [];
	Volumes = GetEntArray("info_volume", "classname");
	for(i = 0; i < nodes.size; i++)
	{
		if(isdefined(nodes[i].script_color_allies))
		{
			nodes[i] add_node_to_global_arrays(nodes[i].script_color_allies, "allies");
		}
		if(isdefined(nodes[i].script_color_axis))
		{
			nodes[i] add_node_to_global_arrays(nodes[i].script_color_axis, "axis");
		}
	}
	for(i = 0; i < Volumes.size; i++)
	{
		if(isdefined(Volumes[i].script_color_allies))
		{
			Volumes[i] add_volume_to_global_arrays(Volumes[i].script_color_allies, "allies");
		}
		if(isdefined(Volumes[i].script_color_axis))
		{
			Volumes[i] add_volume_to_global_arrays(Volumes[i].script_color_axis, "axis");
		}
	}
	/#
		level.colorNodes_debug_array = [];
		level.colorNodes_debug_array["Dev Block strings are not supported"] = [];
		level.colorNodes_debug_array["Dev Block strings are not supported"] = [];
	#/
	level.color_node_type_function = [];
	add_cover_node("BAD NODE");
	add_cover_node("Cover Stand");
	add_cover_node("Cover Crouch");
	add_cover_node("Cover Prone");
	add_cover_node("Cover Crouch Window");
	add_cover_node("Cover Right");
	add_cover_node("Cover Left");
	add_cover_node("Cover Wide Left");
	add_cover_node("Cover Wide Right");
	add_cover_node("Cover Pillar");
	add_cover_node("Conceal Stand");
	add_cover_node("Conceal Crouch");
	add_cover_node("Conceal Prone");
	add_cover_node("Reacquire");
	add_cover_node("Balcony");
	add_cover_node("Scripted");
	add_cover_node("Begin");
	add_cover_node("End");
	add_cover_node("Turret");
	add_path_node("Guard");
	add_path_node("Exposed");
	add_path_node("Path");
	level.colorList = [];
	level.colorList[level.colorList.size] = "r";
	level.colorList[level.colorList.size] = "b";
	level.colorList[level.colorList.size] = "y";
	level.colorList[level.colorList.size] = "c";
	level.colorList[level.colorList.size] = "g";
	level.colorList[level.colorList.size] = "p";
	level.colorList[level.colorList.size] = "o";
	level.colorCheckList["red"] = "r";
	level.colorCheckList["r"] = "r";
	level.colorCheckList["blue"] = "b";
	level.colorCheckList["b"] = "b";
	level.colorCheckList["yellow"] = "y";
	level.colorCheckList["y"] = "y";
	level.colorCheckList["cyan"] = "c";
	level.colorCheckList["c"] = "c";
	level.colorCheckList["green"] = "g";
	level.colorCheckList["g"] = "g";
	level.colorCheckList["purple"] = "p";
	level.colorCheckList["p"] = "p";
	level.colorCheckList["orange"] = "o";
	level.colorCheckList["o"] = "o";
	level.currentColorForced = [];
	level.currentColorForced["allies"] = [];
	level.currentColorForced["axis"] = [];
	level.lastColorForced = [];
	level.lastColorForced["allies"] = [];
	level.lastColorForced["axis"] = [];
	for(i = 0; i < level.colorList.size; i++)
	{
		level.arrays_of_colorForced_ai["allies"][level.colorList[i]] = [];
		level.arrays_of_colorForced_ai["axis"][level.colorList[i]] = [];
		level.currentColorForced["allies"][level.colorList[i]] = undefined;
		level.currentColorForced["axis"][level.colorList[i]] = undefined;
	}
	/#
		thread debugDvars();
		thread debugColorFriendlies();
	#/
}

/*
	Name: __main__
	Namespace: colors
	Checksum: 0x6B06ABF2
	Offset: 0xCA8
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function __main__()
{
	foreach(trig in trigger::get_all())
	{
		if(isdefined(trig.script_color_allies))
		{
			trig thread trigger_issues_orders(trig.script_color_allies, "allies");
		}
		if(isdefined(trig.script_color_axis))
		{
			trig thread trigger_issues_orders(trig.script_color_axis, "axis");
		}
	}
}

/*
	Name: debugDvars
	Namespace: colors
	Checksum: 0xAB28E8A0
	Offset: 0xDB0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function debugDvars()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				thread debug_colornodes();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: get_team_substr
	Namespace: colors
	Checksum: 0xD4742313
	Offset: 0xE50
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function get_team_substr()
{
	/#
		if(self.team == "Dev Block strings are not supported")
		{
			if(!isdefined(self.node.script_color_allies_old))
			{
				return;
			}
			return self.node.script_color_allies_old;
		}
		if(self.team == "Dev Block strings are not supported")
		{
			if(!isdefined(self.node.script_color_axis_old))
			{
				return;
			}
			return self.node.script_color_axis_old;
		}
	#/
}

/*
	Name: try_to_draw_line_to_node
	Namespace: colors
	Checksum: 0x3159F7DF
	Offset: 0xED8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function try_to_draw_line_to_node()
{
	/#
		if(!isdefined(self.node))
		{
			return;
		}
		if(!isdefined(self.script_forceColor))
		{
			return;
		}
		subStr = get_team_substr();
		if(!isdefined(subStr))
		{
			return;
		}
		if(!IsSubStr(subStr, self.script_forceColor))
		{
			return;
		}
		recordLine(self.origin + VectorScale((0, 0, 1), 25), self.node.origin, function_310be1cc(self.script_forceColor), "Dev Block strings are not supported", self);
		line(self.origin + VectorScale((0, 0, 1), 25), self.node.origin, function_310be1cc(self.script_forceColor));
	#/
}

/*
	Name: function_310be1cc
	Namespace: colors
	Checksum: 0xAE842A2A
	Offset: 0x1008
	Size: 0x125
	Parameters: 1
	Flags: None
*/
function function_310be1cc(str_color)
{
	/#
		switch(str_color)
		{
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (1, 0, 0);
				break;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (0, 1, 0);
				break;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (0, 0, 1);
				break;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (1, 1, 0);
				break;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (1, 0.5, 0);
				break;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (0, 1, 1);
				break;
			}
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				return (1, 0, 1);
				break;
			}
			case default:
			{
				println("Dev Block strings are not supported" + str_color + "Dev Block strings are not supported");
				return (0, 0, 0);
				break;
			}
		}
	#/
}

/*
	Name: debug_colornodes
	Namespace: colors
	Checksum: 0x6BEB9722
	Offset: 0x1138
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function debug_colornodes()
{
	/#
		Array = [];
		Array["Dev Block strings are not supported"] = [];
		Array["Dev Block strings are not supported"] = [];
		Array["Dev Block strings are not supported"] = [];
		foreach(ai in GetAIArray())
		{
			if(!isdefined(ai.currentColorCode))
			{
				continue;
			}
			Array[ai.team][ai.currentColorCode] = 1;
			color = (1, 1, 1);
			if(isdefined(ai.script_forceColor))
			{
				color = function_310be1cc(ai.script_forceColor);
			}
			recordEntText(ai.currentColorCode, ai, color, "Dev Block strings are not supported");
			print3d(ai.origin + VectorScale((0, 0, 1), 25), ai.currentColorCode, color, 1, 0.7);
			if(ai.team == "Dev Block strings are not supported")
			{
				continue;
			}
			ai try_to_draw_line_to_node();
		}
		draw_colorNodes(Array, "Dev Block strings are not supported");
		draw_colorNodes(Array, "Dev Block strings are not supported");
	#/
}

/*
	Name: draw_colorNodes
	Namespace: colors
	Checksum: 0x28B56944
	Offset: 0x1370
	Size: 0x2F7
	Parameters: 2
	Flags: None
*/
function draw_colorNodes(Array, team)
{
	/#
		keys = getArrayKeys(Array[team]);
		for(i = 0; i < keys.size; i++)
		{
			color = function_310be1cc(GetSubStr(keys[i], 0, 1));
			if(isdefined(level.colorNodes_debug_array[team][keys[i]]))
			{
				var_c015bc60 = level.colorNodes_debug_array[team][keys[i]];
				for(p = 0; p < var_c015bc60.size; p++)
				{
					print3d(var_c015bc60[p].origin, "Dev Block strings are not supported" + keys[i], color, 1, 0.7);
					if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported" && isdefined(var_c015bc60[p].script_color_allies_old))
					{
						if(isdefined(var_c015bc60[p].color_user) && isalive(var_c015bc60[p].color_user) && isdefined(var_c015bc60[p].color_user.script_forceColor))
						{
							print3d(var_c015bc60[p].origin + VectorScale((0, 0, -1), 5), "Dev Block strings are not supported" + var_c015bc60[p].script_color_allies_old, function_310be1cc(var_c015bc60[p].color_user.script_forceColor), 0.5, 0.4);
							continue;
						}
						print3d(var_c015bc60[p].origin + VectorScale((0, 0, -1), 5), "Dev Block strings are not supported" + var_c015bc60[p].script_color_allies_old, color, 0.5, 0.4);
					}
				}
			}
		}
	#/
}

/*
	Name: debugColorFriendlies
	Namespace: colors
	Checksum: 0xDA48F319
	Offset: 0x1670
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function debugColorFriendlies()
{
	/#
		level.debug_color_friendlies = [];
		level.debug_color_huds = [];
		level thread debugColorFriendliesToggleWatch();
		for(;;)
		{
			level waittill("updated_color_friendlies");
			draw_color_friendlies();
		}
	#/
}

/*
	Name: debugColorFriendliesToggleWatch
	Namespace: colors
	Checksum: 0xE0A44F34
	Offset: 0x16D0
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function debugColorFriendliesToggleWatch()
{
	/#
		just_turned_on = 0;
		just_turned_off = 0;
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported" && !just_turned_on)
			{
				just_turned_on = 1;
				just_turned_off = 0;
				draw_color_friendlies();
			}
			if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported" && !just_turned_off)
			{
				just_turned_off = 1;
				just_turned_on = 0;
				draw_color_friendlies();
			}
			wait(0.25);
		}
	#/
}

/*
	Name: get_script_palette
	Namespace: colors
	Checksum: 0xB35E26BE
	Offset: 0x17B8
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function get_script_palette()
{
	/#
		RGB = [];
		RGB["Dev Block strings are not supported"] = (1, 0, 0);
		RGB["Dev Block strings are not supported"] = (1, 0.5, 0);
		RGB["Dev Block strings are not supported"] = (1, 1, 0);
		RGB["Dev Block strings are not supported"] = (0, 1, 0);
		RGB["Dev Block strings are not supported"] = (0, 1, 1);
		RGB["Dev Block strings are not supported"] = (0, 0, 1);
		RGB["Dev Block strings are not supported"] = (1, 0, 1);
		return RGB;
	#/
}

/*
	Name: draw_color_friendlies
	Namespace: colors
	Checksum: 0x2DEF34E6
	Offset: 0x1878
	Size: 0x391
	Parameters: 0
	Flags: None
*/
function draw_color_friendlies()
{
	/#
		level endon("updated_color_friendlies");
		keys = getArrayKeys(level.debug_color_friendlies);
		colored_friendlies = [];
		colors = [];
		colors[colors.size] = "Dev Block strings are not supported";
		colors[colors.size] = "Dev Block strings are not supported";
		colors[colors.size] = "Dev Block strings are not supported";
		colors[colors.size] = "Dev Block strings are not supported";
		colors[colors.size] = "Dev Block strings are not supported";
		colors[colors.size] = "Dev Block strings are not supported";
		colors[colors.size] = "Dev Block strings are not supported";
		RGB = get_script_palette();
		for(i = 0; i < colors.size; i++)
		{
			colored_friendlies[colors[i]] = 0;
		}
		for(i = 0; i < keys.size; i++)
		{
			color = level.debug_color_friendlies[keys[i]];
			colored_friendlies[color]++;
		}
		for(i = 0; i < level.debug_color_huds.size; i++)
		{
			level.debug_color_huds[i] destroy();
		}
		level.debug_color_huds = [];
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			return;
		}
		y = 365;
		for(i = 0; i < colors.size; i++)
		{
			if(colored_friendlies[colors[i]] <= 0)
			{
				continue;
			}
			for(p = 0; p < colored_friendlies[colors[i]]; p++)
			{
				overlay = NewHudElem();
				overlay.x = 15 + 25 * p;
				overlay.y = y;
				overlay SetShader("Dev Block strings are not supported", 16, 16);
				overlay.alignX = "Dev Block strings are not supported";
				overlay.alignY = "Dev Block strings are not supported";
				overlay.alpha = 1;
				overlay.color = RGB[colors[i]];
				level.debug_color_huds[level.debug_color_huds.size] = overlay;
			}
			y = y + 25;
		}
	#/
}

/*
	Name: player_init_color_grouping
	Namespace: colors
	Checksum: 0x2046CE39
	Offset: 0x1C18
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function player_init_color_grouping()
{
	thread player_color_node();
}

/*
	Name: convert_color_to_short_string
	Namespace: colors
	Checksum: 0xEBF75FC9
	Offset: 0x1C38
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function convert_color_to_short_string()
{
	self.script_forceColor = level.colorCheckList[self.script_forceColor];
}

/*
	Name: goto_current_ColorIndex
	Namespace: colors
	Checksum: 0x86B71F80
	Offset: 0x1C60
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function goto_current_ColorIndex()
{
	if(!isdefined(self.currentColorCode))
	{
		return;
	}
	nodes = level.arrays_of_colorCoded_nodes[self.team][self.currentColorCode];
	if(!isdefined(nodes))
	{
		nodes = [];
	}
	else if(!IsArray(nodes))
	{
		nodes = Array(nodes);
	}
	nodes[nodes.size] = level.colorCoded_volumes[self.team][self.currentColorCode];
	self left_color_node();
	if(!isalive(self))
	{
		return;
	}
	if(!has_color())
	{
		return;
	}
	for(i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		if(isalive(node.color_user) && !isPlayer(node.color_user))
		{
			continue;
		}
		self thread ai_sets_goal_with_delay(node);
		thread decrementColorUsers(node);
		return;
	}
	/#
		println("Dev Block strings are not supported" + self.export + "Dev Block strings are not supported");
	#/
}

/*
	Name: get_color_list
	Namespace: colors
	Checksum: 0x60E0F9EA
	Offset: 0x1E50
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function get_color_list()
{
	colorList = [];
	colorList[colorList.size] = "r";
	colorList[colorList.size] = "b";
	colorList[colorList.size] = "y";
	colorList[colorList.size] = "c";
	colorList[colorList.size] = "g";
	colorList[colorList.size] = "p";
	colorList[colorList.size] = "o";
	return colorList;
}

/*
	Name: get_colorcodes_from_trigger
	Namespace: colors
	Checksum: 0x48CBC8D6
	Offset: 0x1F00
	Size: 0x255
	Parameters: 2
	Flags: None
*/
function get_colorcodes_from_trigger(color_team, team)
{
	colorCodes = StrTok(color_team, " ");
	colors = [];
	colorCodesByColorIndex = [];
	usable_colorCodes = [];
	colorList = get_color_list();
	for(i = 0; i < colorCodes.size; i++)
	{
		color = undefined;
		for(p = 0; p < colorList.size; p++)
		{
			if(IsSubStr(colorCodes[i], colorList[p]))
			{
				color = colorList[p];
				break;
			}
		}
		if(!isdefined(level.arrays_of_colorCoded_nodes[team][colorCodes[i]]) && !isdefined(level.colorCoded_volumes[team][colorCodes[i]]))
		{
			continue;
		}
		/#
			Assert(isdefined(color), "Dev Block strings are not supported" + self GetOrigin() + "Dev Block strings are not supported" + colorCodes[i]);
		#/
		colorCodesByColorIndex[color] = colorCodes[i];
		colors[colors.size] = color;
		usable_colorCodes[usable_colorCodes.size] = colorCodes[i];
	}
	colorCodes = usable_colorCodes;
	Array = [];
	Array["colorCodes"] = colorCodes;
	Array["colorCodesByColorIndex"] = colorCodesByColorIndex;
	Array["colors"] = colors;
	return Array;
}

/*
	Name: trigger_issues_orders
	Namespace: colors
	Checksum: 0xCF2316C6
	Offset: 0x2160
	Size: 0x297
	Parameters: 2
	Flags: None
*/
function trigger_issues_orders(color_team, team)
{
	self endon("death");
	Array = get_colorcodes_from_trigger(color_team, team);
	colorCodes = Array["colorCodes"];
	colorCodesByColorIndex = Array["colorCodesByColorIndex"];
	colors = Array["colors"];
	if(isdefined(self.target))
	{
		a_s_targets = struct::get_array(self.target, "targetname");
		foreach(s_target in a_s_targets)
		{
			if(s_target.script_string === "hero_catch_up")
			{
				if(!isdefined(self.a_s_hero_catch_up))
				{
					self.a_s_hero_catch_up = [];
				}
				if(!isdefined(self.a_s_hero_catch_up))
				{
					self.a_s_hero_catch_up = [];
				}
				else if(!IsArray(self.a_s_hero_catch_up))
				{
					self.a_s_hero_catch_up = Array(self.a_s_hero_catch_up);
				}
				self.a_s_hero_catch_up[self.a_s_hero_catch_up.size] = s_target;
				if(isdefined(s_target.script_num))
				{
					self.num_hero_catch_up_dist = s_target.script_num;
				}
			}
		}
	}
	for(;;)
	{
		self waittill("trigger");
		if(isdefined(self.activated_color_trigger))
		{
			self.activated_color_trigger = undefined;
			continue;
		}
		if(!isdefined(self.color_enabled) || (isdefined(self.color_enabled) && self.color_enabled))
		{
			activate_color_trigger_internal(colorCodes, colors, team, colorCodesByColorIndex);
		}
		trigger_auto_disable();
	}
}

/*
	Name: trigger_auto_disable
	Namespace: colors
	Checksum: 0xC214B5BD
	Offset: 0x2400
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function trigger_auto_disable()
{
	if(!isdefined(self.script_color_stay_on))
	{
		self.script_color_stay_on = 0;
	}
	if(!isdefined(self.color_enabled))
	{
		if(isdefined(self.script_color_stay_on) && self.script_color_stay_on)
		{
			self.color_enabled = 1;
		}
		else
		{
			self.color_enabled = 0;
		}
	}
}

/*
	Name: activate_color_trigger
	Namespace: colors
	Checksum: 0xF74E22F2
	Offset: 0x2468
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function activate_color_trigger(team)
{
	if(team == "allies")
	{
		self thread get_colorcodes_and_activate_trigger(self.script_color_allies, team);
	}
	else
	{
		self thread get_colorcodes_and_activate_trigger(self.script_color_axis, team);
	}
}

/*
	Name: get_colorcodes_and_activate_trigger
	Namespace: colors
	Checksum: 0x56246455
	Offset: 0x24D8
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function get_colorcodes_and_activate_trigger(color_team, team)
{
	Array = get_colorcodes_from_trigger(color_team, team);
	colorCodes = Array["colorCodes"];
	colorCodesByColorIndex = Array["colorCodesByColorIndex"];
	colors = Array["colors"];
	activate_color_trigger_internal(colorCodes, colors, team, colorCodesByColorIndex);
}

/*
	Name: is_target_visible
	Namespace: colors
	Checksum: 0xA11F33B2
	Offset: 0x2590
	Size: 0x24F
	Parameters: 1
	Flags: Private
*/
function private is_target_visible(target)
{
	n_player_fov = GetDvarFloat("cg_fov");
	n_dot_check = cos(n_player_fov);
	v_pos = target;
	if(!IsVec(target))
	{
		v_pos = target.origin;
	}
	foreach(player in level.players)
	{
		v_eye = player GetEye();
		v_facing = AnglesToForward(player getPlayerAngles());
		v_to_ent = VectorNormalize(v_pos - v_eye);
		n_dot = VectorDot(v_facing, v_to_ent);
		if(n_dot > n_dot_check)
		{
			return 1;
			continue;
		}
		if(IsVec(target))
		{
			a_trace = bullettrace(v_eye, target, 0, player);
			if(a_trace["fraction"] == 1)
			{
				return 1;
			}
			continue;
		}
		if(target SightConeTrace(v_eye, player) != 0)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_89827d0f
	Namespace: colors
	Checksum: 0xC6FF04F6
	Offset: 0x27E8
	Size: 0x4E7
	Parameters: 4
	Flags: None
*/
function function_89827d0f(s_teleport, var_7ea5275e, var_9a424b4f, func_callback)
{
	if(!isdefined(var_7ea5275e))
	{
		var_7ea5275e = 400;
	}
	if(!isdefined(var_9a424b4f))
	{
		var_9a424b4f = 0;
	}
	self notify("hash_795df34d");
	self endon("hash_795df34d");
	self endon("hash_8882daa6");
	var_d4ff1aaa = var_7ea5275e * var_7ea5275e;
	self endon("death");
	var_9ef79ad8 = s_teleport;
	if(!isdefined(var_9ef79ad8))
	{
		var_9ef79ad8 = [];
	}
	else if(!IsArray(var_9ef79ad8))
	{
		var_9ef79ad8 = Array(var_9ef79ad8);
	}
	var_9ef79ad8 = Array::randomize(var_9ef79ad8);
	while(1)
	{
		var_adcebd47 = 0;
		foreach(player in level.players)
		{
			if(DistanceSquared(player.origin, self.origin) < var_d4ff1aaa)
			{
				var_adcebd47 = 1;
				break;
			}
		}
		if(!var_adcebd47)
		{
			var_b05feb15 = -1;
			if(isdefined(self.goal))
			{
				var_b05feb15 = self CalcPathLength(self.node);
			}
			foreach(s in var_9ef79ad8)
			{
				if(positionWouldTelefrag(s.origin))
				{
					continue;
				}
				if(isdefined(s.teleport_cooldown))
				{
					if(GetTime() < s.teleport_cooldown)
					{
						continue;
					}
				}
				if(self.team == "allies" && isdefined(level.heroes))
				{
					var_7cffe1c3 = ArrayGetClosest(s.origin, level.heroes, 16);
					if(isdefined(var_7cffe1c3))
					{
						continue;
					}
				}
				if(isdefined(self.node) && var_b05feb15 >= 0)
				{
					var_d0f7a681 = PathDistance(s.origin, self.node.origin);
					if(var_d0f7a681 > var_b05feb15)
					{
						return;
					}
				}
				if(is_target_visible(self))
				{
					continue;
				}
				if(is_target_visible(s.origin))
				{
					continue;
				}
				if(isdefined(self.script_forceColor) || var_9a424b4f)
				{
					if(self ForceTeleport(s.origin, s.angles, 1, 1))
					{
						self PathMode("move allowed");
						s.teleport_cooldown = GetTime() + 2000;
						self notify("hash_89827d0f");
						if(var_9a424b4f)
						{
							disable();
						}
						else
						{
							self set_force_color(self.script_forceColor);
						}
						if(isdefined(func_callback))
						{
							self [[func_callback]]();
						}
						return;
					}
				}
			}
		}
		else
		{
			return;
		}
		wait(0.5);
	}
}

/*
	Name: activate_color_trigger_internal
	Namespace: colors
	Checksum: 0xA96C7742
	Offset: 0x2CD8
	Size: 0x4BD
	Parameters: 4
	Flags: None
*/
function activate_color_trigger_internal(colorCodes, colors, team, colorCodesByColorIndex)
{
	for(i = 0; i < colorCodes.size; i++)
	{
		if(!isdefined(level.arrays_of_colorCoded_spawners[team][colorCodes[i]]))
		{
			break;
		}
		ArrayRemoveValue(level.arrays_of_colorCoded_spawners[team][colorCodes[i]], undefined);
		for(p = 0; p < level.arrays_of_colorCoded_spawners[team][colorCodes[i]].size; p++)
		{
			level.arrays_of_colorCoded_spawners[team][colorCodes[i]][p].currentColorCode = colorCodes[i];
		}
	}
	for(i = 0; i < colors.size; i++)
	{
		level.arrays_of_colorForced_ai[team][colors[i]] = Array::remove_dead(level.arrays_of_colorForced_ai[team][colors[i]]);
		level.lastColorForced[team][colors[i]] = level.currentColorForced[team][colors[i]];
		level.currentColorForced[team][colors[i]] = colorCodesByColorIndex[colors[i]];
		/#
			/#
				Assert(isdefined(level.arrays_of_colorCoded_nodes[team][level.currentColorForced[team][colors[i]]]) || isdefined(level.colorCoded_volumes[team][level.currentColorForced[team][colors[i]]]), "Dev Block strings are not supported" + colors[i] + "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
			#/
		#/
	}
	ai_array = [];
	for(i = 0; i < colorCodes.size; i++)
	{
		if(same_color_code_as_last_time(team, colors[i]))
		{
			break;
		}
		colorCode = colorCodes[i];
		if(!isdefined(level.arrays_of_colorCoded_ai[team][colorCode]))
		{
			break;
		}
		ai_array[colorCode] = issue_leave_node_order_to_ai_and_get_ai(colorCode, colors[i], team);
		if(isdefined(self.a_s_hero_catch_up) && ai_array.size > 0)
		{
			if(isdefined(ai_array[colorCode]))
			{
				for(j = 0; j < ai_array[colorCode].size; j++)
				{
					ai = ai_array[colorCode][j];
					if(isdefined(ai.is_hero) && ai.is_hero && isdefined(ai.script_forceColor))
					{
						ai thread function_89827d0f(self.a_s_hero_catch_up);
					}
				}
			}
		}
	}
	for(i = 0; i < colorCodes.size; i++)
	{
		colorCode = colorCodes[i];
		if(!isdefined(ai_array[colorCode]))
		{
			continue;
		}
		if(same_color_code_as_last_time(team, colors[i]))
		{
			continue;
		}
		if(!isdefined(level.arrays_of_colorCoded_ai[team][colorCode]))
		{
			continue;
		}
		issue_color_order_to_ai(colorCode, colors[i], team, ai_array[colorCode]);
	}
}

/*
	Name: same_color_code_as_last_time
	Namespace: colors
	Checksum: 0xBB58EC24
	Offset: 0x31A0
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function same_color_code_as_last_time(team, color)
{
	if(!isdefined(level.lastColorForced[team][color]))
	{
		return 0;
	}
	return level.lastColorForced[team][color] == level.currentColorForced[team][color];
}

/*
	Name: process_cover_node_with_last_in_mind_allies
	Namespace: colors
	Checksum: 0xA992CE5F
	Offset: 0x3200
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function process_cover_node_with_last_in_mind_allies(node, lastColor)
{
	if(IsSubStr(node.script_color_allies, lastColor))
	{
		self.cover_nodes_last[self.cover_nodes_last.size] = node;
	}
	else
	{
		self.cover_nodes_first[self.cover_nodes_first.size] = node;
	}
}

/*
	Name: process_cover_node_with_last_in_mind_axis
	Namespace: colors
	Checksum: 0xAD889497
	Offset: 0x3278
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function process_cover_node_with_last_in_mind_axis(node, lastColor)
{
	if(IsSubStr(node.script_color_axis, lastColor))
	{
		self.cover_nodes_last[self.cover_nodes_last.size] = node;
	}
	else
	{
		self.cover_nodes_first[self.cover_nodes_first.size] = node;
	}
}

/*
	Name: process_cover_node
	Namespace: colors
	Checksum: 0x954AD4F3
	Offset: 0x32F0
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function process_cover_node(node, null)
{
	self.cover_nodes_first[self.cover_nodes_first.size] = node;
}

/*
	Name: process_path_node
	Namespace: colors
	Checksum: 0xD3B398D5
	Offset: 0x3328
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function process_path_node(node, null)
{
	self.path_nodes[self.path_nodes.size] = node;
}

/*
	Name: prioritize_colorCoded_nodes
	Namespace: colors
	Checksum: 0xB1CD1A17
	Offset: 0x3360
	Size: 0x21B
	Parameters: 3
	Flags: None
*/
function prioritize_colorCoded_nodes(team, colorCode, color)
{
	nodes = level.arrays_of_colorCoded_nodes[team][colorCode];
	ent = spawnstruct();
	ent.path_nodes = [];
	ent.cover_nodes_first = [];
	ent.cover_nodes_last = [];
	lastColorForced_exists = isdefined(level.lastColorForced[team][color]);
	for(i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		ent [[level.color_node_type_function[node.type][lastColorForced_exists][team]]](node, level.lastColorForced[team][color]);
	}
	ent.cover_nodes_first = Array::randomize(ent.cover_nodes_first);
	nodes = ent.cover_nodes_first;
	for(i = 0; i < ent.cover_nodes_last.size; i++)
	{
		nodes[nodes.size] = ent.cover_nodes_last[i];
	}
	for(i = 0; i < ent.path_nodes.size; i++)
	{
		nodes[nodes.size] = ent.path_nodes[i];
	}
	level.arrays_of_colorCoded_nodes[team][colorCode] = nodes;
}

/*
	Name: get_prioritized_colorCoded_nodes
	Namespace: colors
	Checksum: 0xD63ADA45
	Offset: 0x3588
	Size: 0x73
	Parameters: 3
	Flags: None
*/
function get_prioritized_colorCoded_nodes(team, colorCode, color)
{
	if(isdefined(level.arrays_of_colorCoded_nodes[team][colorCode]))
	{
		return level.arrays_of_colorCoded_nodes[team][colorCode];
	}
	if(isdefined(level.colorCoded_volumes[team][colorCode]))
	{
		return level.colorCoded_volumes[team][colorCode];
	}
}

/*
	Name: issue_leave_node_order_to_ai_and_get_ai
	Namespace: colors
	Checksum: 0x438F74E6
	Offset: 0x3608
	Size: 0x189
	Parameters: 3
	Flags: None
*/
function issue_leave_node_order_to_ai_and_get_ai(colorCode, color, team)
{
	level.arrays_of_colorCoded_ai[team][colorCode] = Array::remove_dead(level.arrays_of_colorCoded_ai[team][colorCode]);
	ai = level.arrays_of_colorCoded_ai[team][colorCode];
	ai = ArrayCombine(ai, level.arrays_of_colorForced_ai[team][color], 1, 0);
	newArray = [];
	for(i = 0; i < ai.size; i++)
	{
		if(isdefined(ai[i].currentColorCode) && ai[i].currentColorCode == colorCode)
		{
			continue;
		}
		newArray[newArray.size] = ai[i];
	}
	ai = newArray;
	if(!ai.size)
	{
		return;
	}
	for(i = 0; i < ai.size; i++)
	{
		ai[i] left_color_node();
	}
	return ai;
}

/*
	Name: issue_color_order_to_ai
	Namespace: colors
	Checksum: 0x8B02D036
	Offset: 0x37A0
	Size: 0x227
	Parameters: 4
	Flags: None
*/
function issue_color_order_to_ai(colorCode, color, team, ai)
{
	original_ai_array = ai;
	prioritize_colorCoded_nodes(team, colorCode, color);
	nodes = get_prioritized_colorCoded_nodes(team, colorCode, color);
	/#
		level.colorNodes_debug_array[team][colorCode] = nodes;
	#/
	/#
		if(nodes.size < ai.size)
		{
			println("Dev Block strings are not supported" + ai.size + "Dev Block strings are not supported" + nodes.size + "Dev Block strings are not supported");
		}
	#/
	counter = 0;
	ai_count = ai.size;
	for(i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		if(isalive(node.color_user))
		{
			continue;
		}
		closestAI = ArraySort(ai, node.origin, 1, 1)[0];
		/#
			Assert(isalive(closestAI));
		#/
		ArrayRemoveValue(ai, closestAI);
		closestAI take_color_node(node, colorCode, self, counter);
		counter++;
		if(!ai.size)
		{
			return;
		}
	}
}

/*
	Name: take_color_node
	Namespace: colors
	Checksum: 0xBF792997
	Offset: 0x39D0
	Size: 0x6B
	Parameters: 4
	Flags: None
*/
function take_color_node(node, colorCode, trigger, counter)
{
	self notify("stop_color_move");
	self.script_careful = 1;
	self.currentColorCode = colorCode;
	self thread process_color_order_to_ai(node, trigger, counter);
}

/*
	Name: player_color_node
	Namespace: colors
	Checksum: 0xF04771CF
	Offset: 0x3A48
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function player_color_node()
{
	for(;;)
	{
		playerNode = undefined;
		if(!isdefined(self.node))
		{
			wait(0.05);
			continue;
		}
		olduser = self.node.color_user;
		playerNode = self.node;
		playerNode.color_user = self;
		while(!isdefined(self.node))
		{
			break;
			if(self.node != playerNode)
			{
				break;
			}
			wait(0.05);
		}
		playerNode.color_user = undefined;
		playerNode color_node_finds_a_user();
	}
}

/*
	Name: color_node_finds_a_user
	Namespace: colors
	Checksum: 0x8C6BB86E
	Offset: 0x3B10
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function color_node_finds_a_user()
{
	if(isdefined(self.script_color_allies))
	{
		color_node_finds_user_from_colorcodes(self.script_color_allies, "allies");
	}
	if(isdefined(self.script_color_axis))
	{
		color_node_finds_user_from_colorcodes(self.script_color_axis, "axis");
	}
}

/*
	Name: color_node_finds_user_from_colorcodes
	Namespace: colors
	Checksum: 0xF6A88993
	Offset: 0x3B80
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function color_node_finds_user_from_colorcodes(colorCodeString, team)
{
	if(isdefined(self.color_user))
	{
		return;
	}
	colorCodes = StrTok(colorCodeString, " ");
	Array::thread_all_ents(colorCodes, &color_node_finds_user_for_colorCode, team);
}

/*
	Name: color_node_finds_user_for_colorCode
	Namespace: colors
	Checksum: 0x9ABA7A01
	Offset: 0x3BF8
	Size: 0x157
	Parameters: 2
	Flags: None
*/
function color_node_finds_user_for_colorCode(colorCode, team)
{
	color = colorCode[0];
	/#
		Assert(colorIsLegit(color), "Dev Block strings are not supported" + color + "Dev Block strings are not supported");
	#/
	if(!isdefined(level.currentColorForced[team][color]))
	{
		return;
	}
	if(level.currentColorForced[team][color] != colorCode)
	{
		return;
	}
	ai = get_force_color_guys(team, color);
	if(!ai.size)
	{
		return;
	}
	for(i = 0; i < ai.size; i++)
	{
		guy = ai[i];
		if(guy occupies_colorCode(colorCode))
		{
			continue;
		}
		guy take_color_node(self, colorCode);
		return;
	}
}

/*
	Name: occupies_colorCode
	Namespace: colors
	Checksum: 0x128D7439
	Offset: 0x3D58
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function occupies_colorCode(colorCode)
{
	if(!isdefined(self.currentColorCode))
	{
		return 0;
	}
	return self.currentColorCode == colorCode;
}

/*
	Name: ai_sets_goal_with_delay
	Namespace: colors
	Checksum: 0x699294D6
	Offset: 0x3D88
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function ai_sets_goal_with_delay(node)
{
	self endon("death");
	delay = my_current_node_delays();
	if(delay)
	{
		wait(delay);
	}
	ai_sets_goal(node);
}

/*
	Name: ai_sets_goal
	Namespace: colors
	Checksum: 0x4AFC43C
	Offset: 0x3DF0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function ai_sets_goal(node)
{
	self notify("stop_going_to_node");
	set_goal_and_volume(node);
	volume = level.colorCoded_volumes[self.team][self.currentColorCode];
}

/*
	Name: set_goal_and_volume
	Namespace: colors
	Checksum: 0x631B29E6
	Offset: 0x3E58
	Size: 0x15F
	Parameters: 1
	Flags: None
*/
function set_goal_and_volume(node)
{
	if(isdefined(self._colors_go_line))
	{
		self notify("colors_go_line_done");
		self._colors_go_line = undefined;
	}
	if(isdefined(node.radius) && node.radius)
	{
		self.goalRadius = node.radius;
	}
	if(isdefined(node.script_forcegoal) && node.script_forcegoal)
	{
		self thread color_force_goal(node);
	}
	else
	{
		self SetGoal(node);
	}
	volume = level.colorCoded_volumes[self.team][self.currentColorCode];
	if(isdefined(volume))
	{
		self SetGoal(volume);
	}
	else
	{
		self clearFixedNodeSafeVolume();
	}
	if(isdefined(node.fixedNodeSafeRadius))
	{
		self.fixedNodeSafeRadius = node.fixedNodeSafeRadius;
	}
	else
	{
		self.fixedNodeSafeRadius = 64;
	}
}

/*
	Name: color_force_goal
	Namespace: colors
	Checksum: 0x5EA659AD
	Offset: 0x3FC0
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function color_force_goal(node)
{
	self endon("death");
	self thread ai::force_goal(node, undefined, 1, "stop_color_forcegoal", 1);
	self util::waittill_either("goal", "stop_color_move");
	self notify("stop_color_forcegoal");
}

/*
	Name: careful_logic
	Namespace: colors
	Checksum: 0x7CAB48E6
	Offset: 0x4040
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function careful_logic(node, volume)
{
	self endon("death");
	self endon("stop_being_careful");
	self endon("stop_going_to_node");
	thread recover_from_careful_disable(node);
	for(;;)
	{
		wait_until_an_enemy_is_in_safe_area(node, volume);
		use_big_goal_until_goal_is_safe(node, volume);
		set_goal_and_volume(node);
	}
}

/*
	Name: recover_from_careful_disable
	Namespace: colors
	Checksum: 0x1DC9AA72
	Offset: 0x40E0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function recover_from_careful_disable(node)
{
	self endon("death");
	self endon("stop_going_to_node");
	self waittill("stop_being_careful");
	set_goal_and_volume(node);
}

/*
	Name: use_big_goal_until_goal_is_safe
	Namespace: colors
	Checksum: 0x949F8A42
	Offset: 0x4130
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function use_big_goal_until_goal_is_safe(node, volume)
{
	self.goalRadius = 1024;
	self SetGoal(self.origin);
	if(isdefined(volume))
	{
		for(;;)
		{
			wait(1);
			if(self isKnownEnemyInRadius(node.origin, self.fixedNodeSafeRadius))
			{
				continue;
			}
			if(self isKnownEnemyInVolume(volume))
			{
				continue;
			}
			return;
		}
		break;
	}
	while(!self isKnownEnemyInRadius(node.origin, self.fixedNodeSafeRadius))
	{
		return;
		wait(1);
	}
}

/*
	Name: wait_until_an_enemy_is_in_safe_area
	Namespace: colors
	Checksum: 0x688E6159
	Offset: 0x4218
	Size: 0xA9
	Parameters: 2
	Flags: None
*/
function wait_until_an_enemy_is_in_safe_area(node, volume)
{
	if(isdefined(volume))
	{
		while(self isKnownEnemyInRadius(node.origin, self.fixedNodeSafeRadius))
		{
			return;
			if(self isKnownEnemyInVolume(volume))
			{
				return;
			}
			wait(1);
		}
		break;
	}
	while(self isKnownEnemyInRadius(node.origin, self.fixedNodeSafeRadius))
	{
		return;
		wait(1);
	}
}

/*
	Name: my_current_node_delays
	Namespace: colors
	Checksum: 0xEEA81BFB
	Offset: 0x42D0
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function my_current_node_delays()
{
	if(!isdefined(self.node))
	{
		return 0;
	}
	return self.node util::script_delay();
}

/*
	Name: process_color_order_to_ai
	Namespace: colors
	Checksum: 0x3502A90D
	Offset: 0x4308
	Size: 0x217
	Parameters: 3
	Flags: None
*/
function process_color_order_to_ai(node, trigger, counter)
{
	thread decrementColorUsers(node);
	self endon("stop_color_move");
	self endon("death");
	if(isdefined(trigger))
	{
		trigger util::script_delay();
	}
	if(isdefined(trigger))
	{
		if(isdefined(trigger.script_flag_wait))
		{
			level flag::wait_till(trigger.script_flag_wait);
		}
	}
	if(!my_current_node_delays())
	{
		if(isdefined(counter))
		{
			wait(counter * RandomFloatRange(0.2, 0.35));
		}
	}
	self ai_sets_goal(node);
	self.color_ordered_node_assignment = node;
	for(;;)
	{
		self waittill("node_taken", taker);
		if(taker == self)
		{
			wait(0.05);
		}
		node = get_best_available_new_colored_node();
		if(isdefined(node))
		{
			/#
				Assert(!isalive(node.color_user), "Dev Block strings are not supported");
			#/
			if(isalive(self.color_node.color_user) && self.color_node.color_user == self)
			{
				self.color_node.color_user = undefined;
			}
			self.color_node = node;
			node.color_user = self;
			self ai_sets_goal(node);
		}
	}
}

/*
	Name: get_best_available_colored_node
	Namespace: colors
	Checksum: 0x1F05508E
	Offset: 0x4528
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function get_best_available_colored_node()
{
	/#
		Assert(self.team != "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(self.script_forceColor), "Dev Block strings are not supported" + self.export + "Dev Block strings are not supported");
	#/
	colorCode = level.currentColorForced[self.team][self.script_forceColor];
	nodes = get_prioritized_colorCoded_nodes(self.team, colorCode, self.script_forceColor);
	/#
		Assert(nodes.size > 0, "Dev Block strings are not supported" + self.export + "Dev Block strings are not supported" + self.script_forceColor + "Dev Block strings are not supported");
	#/
	for(i = 0; i < nodes.size; i++)
	{
		if(!isalive(nodes[i].color_user))
		{
			return nodes[i];
		}
	}
}

/*
	Name: get_best_available_new_colored_node
	Namespace: colors
	Checksum: 0x47D06455
	Offset: 0x46A0
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function get_best_available_new_colored_node()
{
	/#
		Assert(self.team != "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(self.script_forceColor), "Dev Block strings are not supported" + self.export + "Dev Block strings are not supported");
	#/
	colorCode = level.currentColorForced[self.team][self.script_forceColor];
	nodes = get_prioritized_colorCoded_nodes(self.team, colorCode, self.script_forceColor);
	/#
		Assert(nodes.size > 0, "Dev Block strings are not supported" + self.export + "Dev Block strings are not supported" + self.script_forceColor + "Dev Block strings are not supported");
	#/
	nodes = ArraySort(nodes, self.origin);
	for(i = 0; i < nodes.size; i++)
	{
		if(!isalive(nodes[i].color_user))
		{
			return nodes[i];
		}
	}
}

/*
	Name: process_stop_short_of_node
	Namespace: colors
	Checksum: 0x598D226E
	Offset: 0x4838
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function process_stop_short_of_node(node)
{
	self endon("stopScript");
	self endon("death");
	if(isdefined(self.node))
	{
		return;
	}
	if(DistanceSquared(node.origin, self.origin) < 1024)
	{
		reached_node_but_could_not_claim_it(node);
		return;
	}
	currentTime = GetTime();
	wait_for_killanimscript_or_time(1);
	newTime = GetTime();
	if(newTime - currentTime >= 1000)
	{
		reached_node_but_could_not_claim_it(node);
	}
}

/*
	Name: wait_for_killanimscript_or_time
	Namespace: colors
	Checksum: 0x879D3279
	Offset: 0x4918
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function wait_for_killanimscript_or_time(timer)
{
	self endon("killanimscript");
	wait(timer);
}

/*
	Name: reached_node_but_could_not_claim_it
	Namespace: colors
	Checksum: 0x9572631E
	Offset: 0x4940
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function reached_node_but_could_not_claim_it(node)
{
	ai = GetAIArray();
	for(i = 0; i < ai.size; i++)
	{
		if(!isdefined(ai[i].node))
		{
			continue;
		}
		if(ai[i].node != node)
		{
			continue;
		}
		ai[i] notify("eject_from_my_node");
		wait(1);
		self notify("eject_from_my_node");
		return 1;
	}
	return 0;
}

/*
	Name: decrementColorUsers
	Namespace: colors
	Checksum: 0xB91058F5
	Offset: 0x4A08
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function decrementColorUsers(node)
{
	node.color_user = self;
	self.color_node = node;
	/#
		self.color_node_debug_val = 1;
	#/
	self endon("stop_color_move");
	self waittill("death");
	self.color_node.color_user = undefined;
}

/*
	Name: colorIsLegit
	Namespace: colors
	Checksum: 0x5391E178
	Offset: 0x4A70
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function colorIsLegit(color)
{
	for(i = 0; i < level.colorList.size; i++)
	{
		if(color == level.colorList[i])
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: add_volume_to_global_arrays
	Namespace: colors
	Checksum: 0xF7AB04A3
	Offset: 0x4AD0
	Size: 0xC9
	Parameters: 2
	Flags: None
*/
function add_volume_to_global_arrays(colorCode, team)
{
	colors = StrTok(colorCode, " ");
	for(p = 0; p < colors.size; p++)
	{
		/#
			Assert(!isdefined(level.colorCoded_volumes[team][colors[p]]), "Dev Block strings are not supported" + colors[p]);
		#/
		level.colorCoded_volumes[team][colors[p]] = self;
	}
}

/*
	Name: add_node_to_global_arrays
	Namespace: colors
	Checksum: 0x2BEDC8ED
	Offset: 0x4BA8
	Size: 0x1ED
	Parameters: 2
	Flags: None
*/
function add_node_to_global_arrays(colorCode, team)
{
	self.color_user = undefined;
	colors = StrTok(colorCode, " ");
	for(p = 0; p < colors.size; p++)
	{
		if(isdefined(level.arrays_of_colorCoded_nodes[team]) && isdefined(level.arrays_of_colorCoded_nodes[team][colors[p]]))
		{
			if(!isdefined(level.arrays_of_colorCoded_nodes[team][colors[p]]))
			{
				level.arrays_of_colorCoded_nodes[team][colors[p]] = [];
			}
			else if(!IsArray(level.arrays_of_colorCoded_nodes[team][colors[p]]))
			{
				level.arrays_of_colorCoded_nodes[team][colors[p]] = Array(level.arrays_of_colorCoded_nodes[team][colors[p]]);
			}
			level.arrays_of_colorCoded_nodes[team][colors[p]][level.arrays_of_colorCoded_nodes[team][colors[p]].size] = self;
			continue;
		}
		level.arrays_of_colorCoded_nodes[team][colors[p]][0] = self;
		level.arrays_of_colorCoded_ai[team][colors[p]] = [];
		level.arrays_of_colorCoded_spawners[team][colors[p]] = [];
	}
}

/*
	Name: left_color_node
	Namespace: colors
	Checksum: 0xEB920D3F
	Offset: 0x4DA0
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function left_color_node()
{
	/#
		self.color_node_debug_val = undefined;
	#/
	if(!isdefined(self.color_node))
	{
		return;
	}
	if(isdefined(self.color_node.color_user) && self.color_node.color_user == self)
	{
		self.color_node.color_user = undefined;
	}
	self.color_node = undefined;
	self notify("stop_color_move");
}

/*
	Name: GetColorNumberArray
	Namespace: colors
	Checksum: 0x3FC1753C
	Offset: 0x4E20
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function GetColorNumberArray()
{
	Array = [];
	if(IsSubStr(self.classname, "axis") || IsSubStr(self.classname, "enemy"))
	{
		Array["team"] = "axis";
		Array["colorTeam"] = self.script_color_axis;
	}
	if(IsSubStr(self.classname, "ally") || IsSubStr(self.classname, "civilian"))
	{
		Array["team"] = "allies";
		Array["colorTeam"] = self.script_color_allies;
	}
	if(!isdefined(Array["colorTeam"]))
	{
		Array = undefined;
	}
	return Array;
}

/*
	Name: removeSpawnerFromColorNumberArray
	Namespace: colors
	Checksum: 0x6BBA5EDC
	Offset: 0x4F40
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function removeSpawnerFromColorNumberArray()
{
	colorNumberArray = GetColorNumberArray();
	if(!isdefined(colorNumberArray))
	{
		return;
	}
	team = colorNumberArray["team"];
	colorTeam = colorNumberArray["colorTeam"];
	colors = StrTok(colorTeam, " ");
	for(i = 0; i < colors.size; i++)
	{
		ArrayRemoveValue(level.arrays_of_colorCoded_spawners[team][colors[i]], self);
	}
}

/*
	Name: add_cover_node
	Namespace: colors
	Checksum: 0xD01E9457
	Offset: 0x5028
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function add_cover_node(type)
{
	level.color_node_type_function[type][1]["allies"] = &process_cover_node_with_last_in_mind_allies;
	level.color_node_type_function[type][1]["axis"] = &process_cover_node_with_last_in_mind_axis;
	level.color_node_type_function[type][0]["allies"] = &process_cover_node;
	level.color_node_type_function[type][0]["axis"] = &process_cover_node;
}

/*
	Name: add_path_node
	Namespace: colors
	Checksum: 0xB494F2A
	Offset: 0x50F0
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function add_path_node(type)
{
	level.color_node_type_function[type][1]["allies"] = &process_path_node;
	level.color_node_type_function[type][0]["allies"] = &process_path_node;
	level.color_node_type_function[type][1]["axis"] = &process_path_node;
	level.color_node_type_function[type][0]["axis"] = &process_path_node;
}

/*
	Name: colorNode_spawn_reinforcement
	Namespace: colors
	Checksum: 0x5598015E
	Offset: 0x51B8
	Size: 0x2FF
	Parameters: 2
	Flags: None
*/
function colorNode_spawn_reinforcement(classname, fromColor)
{
	level endon("kill_color_replacements");
	var_bf55f06f = function_d1fc12(classname, fromColor);
	while(level.var_29739fb6[var_bf55f06f] > 0)
	{
		spawn = undefined;
		while(!level flag::get("respawn_friendlies"))
		{
			if(!isdefined(level.friendly_respawn_vision_checker_thread))
			{
				thread friendly_spawner_vision_checker();
			}
			for(;;)
			{
				level flag::wait_till_any(Array("player_looks_away_from_spawner", "respawn_friendlies"));
				level flag::wait_till_clear("friendly_spawner_locked");
				if(level flag::get("player_looks_away_from_spawner") || level flag::get("respawn_friendlies"))
				{
				}
			}
			else
			{
			}
			level flag::set("friendly_spawner_locked");
			spawner = get_color_spawner(classname, fromColor);
			spawner.count = 1;
			level.var_29739fb6[var_bf55f06f] = level.var_29739fb6[var_bf55f06f] - 1;
			spawner util::script_wait();
			spawn = spawner spawner::spawn();
			if(spawner::spawn_failed(spawn))
			{
				thread lock_spawner_for_awhile();
				wait(1);
			}
			else
			{
				level notify("reinforcement_spawned", spawn);
				break;
			}
		}
		while(!isdefined(fromColor))
		{
			break;
			if(get_color_from_order(fromColor, level.current_color_order) == "none")
			{
				break;
			}
			fromColor = level.current_color_order[fromColor];
		}
		if(isdefined(fromColor))
		{
			spawn set_force_color(fromColor);
		}
		thread lock_spawner_for_awhile();
		if(isdefined(level.friendly_startup_thread))
		{
			spawn thread [[level.friendly_startup_thread]]();
		}
		spawn thread colorNode_replace_on_death();
	}
}

/*
	Name: colorNode_replace_on_death
	Namespace: colors
	Checksum: 0x6CD84B2
	Offset: 0x54C0
	Size: 0x3B3
	Parameters: 0
	Flags: None
*/
function colorNode_replace_on_death()
{
	level endon("kill_color_replacements");
	/#
		Assert(isalive(self), "Dev Block strings are not supported");
	#/
	self endon("_disable_reinforcement");
	if(self.team == "axis")
	{
		return;
	}
	if(isdefined(self.replace_on_death))
	{
		return;
	}
	self.replace_on_death = 1;
	/#
		Assert(!isdefined(self.respawn_on_death), "Dev Block strings are not supported" + self.export + "Dev Block strings are not supported");
	#/
	classname = self.classname;
	color = self.script_forceColor;
	waittillframeend;
	if(isalive(self))
	{
		self waittill("death");
	}
	color_order = level.current_color_order;
	if(!isdefined(self.script_forceColor))
	{
		return;
	}
	var_bf55f06f = function_d1fc12(classname, self.script_forceColor);
	if(!isdefined(level.var_29739fb6) || !isdefined(level.var_29739fb6[var_bf55f06f]) || level.var_29739fb6[var_bf55f06f] <= 0)
	{
		level.var_29739fb6[var_bf55f06f] = 1;
		thread colorNode_spawn_reinforcement(classname, self.script_forceColor);
	}
	else
	{
		level.var_29739fb6[var_bf55f06f] = level.var_29739fb6[var_bf55f06f] + 1;
	}
	if(isdefined(self) && isdefined(self.script_forceColor))
	{
		color = self.script_forceColor;
	}
	if(isdefined(self) && isdefined(self.origin))
	{
		origin = self.origin;
	}
	while(get_color_from_order(color, color_order) == "none")
	{
		return;
		correct_colored_friendlies = get_force_color_guys("allies", color_order[color]);
		correct_colored_friendlies = Array::filter_classname(correct_colored_friendlies, 1, classname);
		if(!correct_colored_friendlies.size)
		{
			wait(2);
		}
		else
		{
			players = GetPlayers();
			correct_colored_guy = ArraySort(correct_colored_friendlies, players[0].origin, 1)[0];
			/#
				Assert(correct_colored_guy.script_forceColor != color, "Dev Block strings are not supported" + color + "Dev Block strings are not supported");
			#/
			waittillframeend;
			if(!isalive(correct_colored_guy))
			{
			}
			else
			{
				correct_colored_guy set_force_color(color);
				if(isdefined(level.friendly_promotion_thread))
				{
					correct_colored_guy [[level.friendly_promotion_thread]](color);
				}
				color = color_order[color];
			}
		}
	}
}

/*
	Name: get_color_from_order
	Namespace: colors
	Checksum: 0x3434303D
	Offset: 0x5880
	Size: 0x5D
	Parameters: 2
	Flags: None
*/
function get_color_from_order(color, color_order)
{
	if(!isdefined(color))
	{
		return "none";
	}
	if(!isdefined(color_order))
	{
		return "none";
	}
	if(!isdefined(color_order[color]))
	{
		return "none";
	}
	return color_order[color];
}

/*
	Name: friendly_spawner_vision_checker
	Namespace: colors
	Checksum: 0x8A737BCD
	Offset: 0x58E8
	Size: 0x22F
	Parameters: 0
	Flags: None
*/
function friendly_spawner_vision_checker()
{
	level.friendly_respawn_vision_checker_thread = 1;
	successes = 0;
	for(;;)
	{
		level flag::wait_till_clear("respawn_friendlies");
		wait(1);
		if(!isdefined(level.respawn_spawner))
		{
			continue;
		}
		spawner = level.respawn_spawner;
		players = GetPlayers();
		player_sees_spawner = 0;
		for(q = 0; q < players.size; q++)
		{
			difference_vec = players[q].origin - spawner.origin;
			if(length(difference_vec) < 200)
			{
				player_sees_spawner();
				player_sees_spawner = 1;
				break;
			}
			FORWARD = AnglesToForward((0, players[q] getPlayerAngles()[1], 0));
			difference = VectorNormalize(difference_vec);
			dot = VectorDot(FORWARD, difference);
			if(dot < 0.2)
			{
				player_sees_spawner();
				player_sees_spawner = 1;
				break;
			}
			successes++;
			if(successes < 3)
			{
				continue;
			}
		}
		if(player_sees_spawner)
		{
			continue;
		}
		level flag::set("player_looks_away_from_spawner");
	}
}

/*
	Name: get_color_spawner
	Namespace: colors
	Checksum: 0xE032E8F3
	Offset: 0x5B20
	Size: 0x283
	Parameters: 2
	Flags: None
*/
function get_color_spawner(classname, fromColor)
{
	specificFromColor = 0;
	if(isdefined(level.respawn_spawners_specific) && isdefined(level.respawn_spawners_specific[fromColor]))
	{
		specificFromColor = 1;
	}
	if(!isdefined(level.respawn_spawner))
	{
		if(!isdefined(fromColor) || !specificFromColor)
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		}
	}
	if(!isdefined(classname))
	{
		if(isdefined(fromColor) && specificFromColor)
		{
			return level.respawn_spawners_specific[fromColor];
		}
		else
		{
			return level.respawn_spawner;
		}
	}
	spawners = GetEntArray("color_spawner", "targetname");
	class_spawners = [];
	for(i = 0; i < spawners.size; i++)
	{
		class_spawners[spawners[i].classname] = spawners[i];
	}
	spawner = undefined;
	keys = getArrayKeys(class_spawners);
	for(i = 0; i < keys.size; i++)
	{
		if(!IsSubStr(class_spawners[keys[i]].classname, classname))
		{
			continue;
		}
		spawner = class_spawners[keys[i]];
		break;
	}
	if(!isdefined(spawner))
	{
		if(isdefined(fromColor) && specificFromColor)
		{
			return level.respawn_spawners_specific[fromColor];
		}
		else
		{
			return level.respawn_spawner;
		}
	}
	if(isdefined(fromColor) && specificFromColor)
	{
		spawner.origin = level.respawn_spawners_specific[fromColor].origin;
	}
	else
	{
		spawner.origin = level.respawn_spawner.origin;
	}
	return spawner;
}

/*
	Name: function_d1fc12
	Namespace: colors
	Checksum: 0xDD9C0F0B
	Offset: 0x5DB0
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function function_d1fc12(classname, fromColor)
{
	var_e5e1e63c = classname;
	if(isdefined(fromColor))
	{
		var_e5e1e63c = var_e5e1e63c + "##" + fromColor;
	}
	return var_e5e1e63c;
}

/*
	Name: lock_spawner_for_awhile
	Namespace: colors
	Checksum: 0x1099FB02
	Offset: 0x5E08
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function lock_spawner_for_awhile()
{
	level flag::set("friendly_spawner_locked");
	wait(2);
	level flag::clear("friendly_spawner_locked");
}

/*
	Name: player_sees_spawner
	Namespace: colors
	Checksum: 0x9BC18E48
	Offset: 0x5E58
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function player_sees_spawner()
{
	level flag::clear("player_looks_away_from_spawner");
}

/*
	Name: kill_color_replacements
	Namespace: colors
	Checksum: 0x87E38CF3
	Offset: 0x5E88
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function kill_color_replacements()
{
	level flag::clear("friendly_spawner_locked");
	level notify("kill_color_replacements");
	level.var_29739fb6 = undefined;
	ai = GetAIArray();
	Array::thread_all(ai, &remove_replace_on_death);
}

/*
	Name: remove_replace_on_death
	Namespace: colors
	Checksum: 0xCDA5C060
	Offset: 0x5F10
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function remove_replace_on_death()
{
	self.replace_on_death = undefined;
}

/*
	Name: set_force_color
	Namespace: colors
	Checksum: 0x13DFBB31
	Offset: 0x5F28
	Size: 0x263
	Parameters: 1
	Flags: None
*/
function set_force_color(_color)
{
	color = shortenColor(_color);
	/#
		Assert(colorIsLegit(color), "Dev Block strings are not supported" + color);
	#/
	if(!IsActor(self))
	{
		set_force_color_spawner(color);
		return;
	}
	/#
		Assert(isalive(self), "Dev Block strings are not supported");
	#/
	self.fixedNodeSafeRadius = 64;
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	self.old_forcecolor = undefined;
	if(isdefined(self.script_forceColor))
	{
		ArrayRemoveValue(level.arrays_of_colorForced_ai[self.team][self.script_forceColor], self);
	}
	self.script_forceColor = color;
	if(!isdefined(level.arrays_of_colorForced_ai[self.team][self.script_forceColor]))
	{
		level.arrays_of_colorForced_ai[self.team][self.script_forceColor] = [];
	}
	else if(!IsArray(level.arrays_of_colorForced_ai[self.team][self.script_forceColor]))
	{
		level.arrays_of_colorForced_ai[self.team][self.script_forceColor] = Array(level.arrays_of_colorForced_ai[self.team][self.script_forceColor]);
	}
	level.arrays_of_colorForced_ai[self.team][self.script_forceColor][level.arrays_of_colorForced_ai[self.team][self.script_forceColor].size] = self;
	level thread function_9054b7cf(self);
	self thread new_color_being_set(color);
}

/*
	Name: function_9054b7cf
	Namespace: colors
	Checksum: 0x19A53544
	Offset: 0x6198
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function function_9054b7cf(ai)
{
	script_forceColor = ai.script_forceColor;
	team = ai.team;
	ai waittill("death");
	level.arrays_of_colorForced_ai[team][script_forceColor] = Array::remove_undefined(level.arrays_of_colorForced_ai[team][script_forceColor]);
}

/*
	Name: shortenColor
	Namespace: colors
	Checksum: 0xC3A921A5
	Offset: 0x6228
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function shortenColor(color)
{
	/#
		Assert(isdefined(level.colorCheckList[ToLower(color)]), "Dev Block strings are not supported" + color);
	#/
	return level.colorCheckList[ToLower(color)];
}

/*
	Name: set_force_color_spawner
	Namespace: colors
	Checksum: 0xE93A8079
	Offset: 0x62A0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function set_force_color_spawner(color)
{
	self.script_forceColor = color;
	self.old_forcecolor = undefined;
}

/*
	Name: new_color_being_set
	Namespace: colors
	Checksum: 0x86E0B71E
	Offset: 0x62D0
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function new_color_being_set(color)
{
	self notify("new_color_being_set");
	self.new_force_color_being_set = 1;
	left_color_node();
	self endon("new_color_being_set");
	self endon("death");
	waittillframeend;
	waittillframeend;
	if(isdefined(self.script_forceColor))
	{
		self.currentColorCode = level.currentColorForced[self.team][self.script_forceColor];
		self thread goto_current_ColorIndex();
	}
	self.new_force_color_being_set = undefined;
	self notify("done_setting_new_color");
	/#
		update_debug_friendlycolor();
	#/
}

/*
	Name: update_debug_friendlycolor_on_death
	Namespace: colors
	Checksum: 0x5E5836F0
	Offset: 0x63A8
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function update_debug_friendlycolor_on_death()
{
	self notify("debug_color_update");
	self endon("debug_color_update");
	self waittill("death");
	/#
		a_keys = getArrayKeys(level.debug_color_friendlies);
		foreach(n_key in a_keys)
		{
			ai = GetEntByNum(n_key);
			if(!isalive(ai))
			{
				ArrayRemoveIndex(level.debug_color_friendlies, n_key, 1);
			}
		}
	#/
	level notify("updated_color_friendlies");
}

/*
	Name: update_debug_friendlycolor
	Namespace: colors
	Checksum: 0xF336FAC5
	Offset: 0x64D8
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function update_debug_friendlycolor()
{
	self thread update_debug_friendlycolor_on_death();
	if(isdefined(self.script_forceColor))
	{
		level.debug_color_friendlies[self GetEntityNumber()] = self.script_forceColor;
	}
	else
	{
		level.debug_color_friendlies[self GetEntityNumber()] = undefined;
	}
	level notify("updated_color_friendlies");
}

/*
	Name: has_color
	Namespace: colors
	Checksum: 0x939A5164
	Offset: 0x6560
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function has_color()
{
	if(self.team == "axis")
	{
		return isdefined(self.script_color_axis) || isdefined(self.script_forceColor);
	}
	return isdefined(self.script_color_allies) || isdefined(self.script_forceColor);
}

/*
	Name: get_force_color
	Namespace: colors
	Checksum: 0xF38A2714
	Offset: 0x65B0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function get_force_color()
{
	color = self.script_forceColor;
	return color;
}

/*
	Name: get_force_color_guys
	Namespace: colors
	Checksum: 0x3E873281
	Offset: 0x65D8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function get_force_color_guys(team, color)
{
	ai = GetAITeamArray(team);
	guys = [];
	for(i = 0; i < ai.size; i++)
	{
		guy = ai[i];
		if(!isdefined(guy.script_forceColor))
		{
			continue;
		}
		if(guy.script_forceColor != color)
		{
			continue;
		}
		guys[guys.size] = guy;
	}
	return guys;
}

/*
	Name: get_all_force_color_friendlies
	Namespace: colors
	Checksum: 0xEA699EE5
	Offset: 0x66B8
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function get_all_force_color_friendlies()
{
	ai = GetAITeamArray("allies");
	guys = [];
	for(i = 0; i < ai.size; i++)
	{
		guy = ai[i];
		if(!isdefined(guy.script_forceColor))
		{
			continue;
		}
		guys[guys.size] = guy;
	}
	return guys;
}

/*
	Name: disable
	Namespace: colors
	Checksum: 0xE8F46EFD
	Offset: 0x6768
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function disable(stop_being_careful)
{
	if(isdefined(self.new_force_color_being_set))
	{
		self endon("death");
		self waittill("done_setting_new_color");
	}
	if(isdefined(stop_being_careful) && stop_being_careful)
	{
		self notify("stop_going_to_node");
		self notify("stop_being_careful");
	}
	self clearFixedNodeSafeVolume();
	if(!isdefined(self.script_forceColor))
	{
		return;
	}
	/#
		Assert(!isdefined(self.old_forcecolor), "Dev Block strings are not supported");
	#/
	self.old_forcecolor = self.script_forceColor;
	ArrayRemoveValue(level.arrays_of_colorForced_ai[self.team][self.script_forceColor], self);
	left_color_node();
	self.script_forceColor = undefined;
	self.currentColorCode = undefined;
	/#
		update_debug_friendlycolor();
	#/
}

/*
	Name: enable
	Namespace: colors
	Checksum: 0xBD0E601F
	Offset: 0x6890
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function enable()
{
	if(isdefined(self.script_forceColor))
	{
		return;
	}
	if(!isdefined(self.old_forcecolor))
	{
		return;
	}
	set_force_color(self.old_forcecolor);
	self.old_forcecolor = undefined;
}

/*
	Name: is_color_ai
	Namespace: colors
	Checksum: 0xFD7E9382
	Offset: 0x68E0
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function is_color_ai()
{
	return isdefined(self.script_forceColor) || isdefined(self.old_forcecolor);
}

/*
	Name: insure_player_does_not_set_forcecolor_twice_in_one_frame
	Namespace: colors
	Checksum: 0x8F107D4B
	Offset: 0x6900
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function insure_player_does_not_set_forcecolor_twice_in_one_frame()
{
	/#
		/#
			Assert(!isdefined(self.setforcecolor), "Dev Block strings are not supported");
		#/
		self.setforcecolor = 1;
		waittillframeend;
		if(!isalive(self))
		{
			return;
		}
		self.setforcecolor = undefined;
	#/
}

