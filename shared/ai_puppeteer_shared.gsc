#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\init;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace ai_puppeteer;

/*
	Name: __init__sytem__
	Namespace: ai_puppeteer
	Checksum: 0x2FEB7CC4
	Offset: 0x178
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ai_puppeteer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ai_puppeteer
	Checksum: 0xF2700EB1
	Offset: 0x1B8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		level thread function_b469f415();
	#/
}

/*
	Name: function_b469f415
	Namespace: ai_puppeteer
	Checksum: 0x7D4EFA32
	Offset: 0x1E0
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function function_b469f415()
{
	/#
		while(1)
		{
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported" && (!isdefined(level.ai_puppeteer_active) || level.ai_puppeteer_active == 0))
			{
				level.ai_puppeteer_active = 1;
				level notify("kill ai puppeteer");
				AddDebugCommand("Dev Block strings are not supported");
				thread ai_puppeteer();
			}
			else if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported" && isdefined(level.ai_puppeteer_active) && level.ai_puppeteer_active == 1)
			{
				level.ai_puppeteer_active = 0;
				AddDebugCommand("Dev Block strings are not supported");
				level notify("kill ai puppeteer");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ai_puppeteer
	Namespace: ai_puppeteer
	Checksum: 0x7D23B61A
	Offset: 0x310
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function ai_puppeteer()
{
	/#
		player = undefined;
		while(!isPlayer(player))
		{
			player = GetPlayers()[0];
			wait(0.05);
		}
		ai_puppeteer_create_hud();
		level.ai_puppet_highlighting = 0;
		player thread ai_puppet_cursor_tracker();
		player thread ai_puppet_manager();
		player.ignoreme = 1;
		level waittill("kill ai puppeteer");
		player.ignoreme = 0;
		ai_puppet_release(1);
		if(isdefined(level.ai_puppet_target))
		{
			level.ai_puppet_target delete();
		}
		ai_puppeteer_destroy_hud();
	#/
}

/*
	Name: ai_puppet_manager
	Namespace: ai_puppeteer
	Checksum: 0x83018ECE
	Offset: 0x440
	Size: 0xBCF
	Parameters: 0
	Flags: None
*/
function ai_puppet_manager()
{
	/#
		level endon("kill ai puppeteer");
		self endon("death");
		while(1)
		{
			if(isdefined(level.playerCursor["Dev Block strings are not supported"]) && isdefined(level.ai_puppet) && isdefined(level.ai_puppet.debugLookAtEnabled) && level.ai_puppet.debugLookAtEnabled == 1)
			{
				level.ai_puppet lookAtPos(level.playerCursor["Dev Block strings are not supported"]);
			}
			if(self buttonpressed("Dev Block strings are not supported") && self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(level.ai_puppet))
				{
					level.ai_puppet ForceTeleport(level.playerCursor["Dev Block strings are not supported"], level.ai_puppet.angles);
				}
				wait(0.2);
			}
			else if(self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(level.ai_puppet))
				{
					if(isdefined(level.ai_puppet_target))
					{
						if(isai(level.ai_puppet_target))
						{
							self thread ai_puppeteer_highlight_ai(level.ai_puppet_target, (1, 0, 0));
							level.ai_puppet clearentitytarget();
							level.ai_puppet_target = undefined;
						}
						else
						{
							self thread ai_puppeteer_highlight_point(level.ai_puppet_target.origin, level.ai_puppet_target_normal, AnglesToForward(self getPlayerAngles()), (1, 0, 0));
							level.ai_puppet clearentitytarget();
							level.ai_puppet_target delete();
						}
					}
					else if(isdefined(level.playerCursorAi))
					{
						if(level.playerCursorAi != level.ai_puppet)
						{
							level.ai_puppet SetEntityTarget(level.playerCursorAi);
							level.ai_puppet_target = level.playerCursorAi;
							level.ai_puppet GetPerfectInfo(level.ai_puppet_target);
							self thread ai_puppeteer_highlight_ai(level.playerCursorAi, (1, 0, 0));
						}
					}
					else
					{
						level.ai_puppet_target = spawn("Dev Block strings are not supported", level.playerCursor["Dev Block strings are not supported"]);
						level.ai_puppet_target_normal = level.playerCursor["Dev Block strings are not supported"];
						level.ai_puppet SetEntityTarget(level.ai_puppet_target);
						self thread ai_puppeteer_highlight_point(level.ai_puppet_target.origin, level.ai_puppet_target_normal, AnglesToForward(self getPlayerAngles()), (1, 0, 0));
					}
				}
				wait(0.2);
			}
			else if(self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(level.ai_puppet))
				{
					if(isdefined(level.playerCursorAi) && level.playerCursorAi != level.ai_puppet)
					{
						level.ai_puppet SetGoal(level.playerCursorAi);
						level.ai_puppet.goalRadius = 64;
						self thread ai_puppeteer_highlight_ai(level.playerCursorAi, (0, 1, 0));
					}
					else if(isdefined(level.playerCursorNode))
					{
						level.ai_puppet SetGoal(level.playerCursorNode);
						self thread ai_puppeteer_highlight_node(level.playerCursorNode);
					}
					else if(isdefined(level.ai_puppet.scriptenemy))
					{
						to_target = level.ai_puppet.scriptenemy.origin - level.ai_puppet.origin;
					}
					else
					{
						to_target = level.playerCursor["Dev Block strings are not supported"] - level.ai_puppet.origin;
					}
					angles = VectorToAngles(to_target);
					level.ai_puppet SetGoal(level.playerCursor["Dev Block strings are not supported"]);
					self thread ai_puppeteer_highlight_point(level.playerCursor["Dev Block strings are not supported"], level.playerCursor["Dev Block strings are not supported"], AnglesToForward(self getPlayerAngles()), (0, 1, 0));
				}
				wait(0.2);
			}
			else if(self buttonpressed("Dev Block strings are not supported") && self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(level.ai_puppet))
				{
					if(isdefined(level.playerCursorAi) && level.playerCursorAi != level.ai_puppet)
					{
						level.ai_puppet SetGoal(level.playerCursorAi);
						level.ai_puppet.goalRadius = 64;
						self thread ai_puppeteer_highlight_ai(level.playerCursorAi, (0, 1, 0));
					}
					else if(isdefined(level.playerCursorNode))
					{
						level.ai_puppet SetGoal(level.playerCursorNode, 1);
						self thread ai_puppeteer_highlight_node(level.playerCursorNode);
					}
					else if(isdefined(level.ai_puppet.scriptenemy))
					{
						to_target = level.ai_puppet.scriptenemy.origin - level.ai_puppet.origin;
					}
					else
					{
						to_target = level.playerCursor["Dev Block strings are not supported"] - level.ai_puppet.origin;
					}
					angles = VectorToAngles(to_target);
					level.ai_puppet SetGoal(level.playerCursor["Dev Block strings are not supported"], 1);
					self thread ai_puppeteer_highlight_point(level.playerCursor["Dev Block strings are not supported"], level.playerCursor["Dev Block strings are not supported"], AnglesToForward(self getPlayerAngles()), (0, 1, 0));
				}
				wait(0.2);
			}
			else if(self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(level.playerCursorAi))
				{
					if(isdefined(level.ai_puppet) && level.playerCursorAi == level.ai_puppet)
					{
						ai_puppet_release(1);
					}
					else if(isdefined(level.ai_puppet))
					{
						ai_puppet_release(0);
					}
					ai_puppet_set();
					self thread ai_puppeteer_highlight_ai(level.ai_puppet, (0, 1, 1));
				}
				wait(0.2);
			}
			else if(self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(level.ai_puppet))
				{
					level.ai_puppet ClearForcedGoal();
				}
				wait(0.2);
			}
			if(isdefined(level.ai_puppet))
			{
				ai_puppeteer_render_ai(level.ai_puppet, (0, 1, 1));
				if(isdefined(level.ai_puppet.scriptenemy) && !level.ai_puppet_highlighting)
				{
					if(isai(level.ai_puppet.scriptenemy))
					{
						ai_puppeteer_render_ai(level.ai_puppet.scriptenemy, (1, 0, 0));
					}
					else if(isdefined(level.ai_puppet_target))
					{
						self thread ai_puppeteer_render_point(level.ai_puppet_target.origin, level.ai_puppet_target_normal, AnglesToForward(self getPlayerAngles()), (1, 0, 0));
					}
				}
			}
			if(isdefined(level.ai_puppet))
			{
				if(self buttonpressed("Dev Block strings are not supported"))
				{
					level.ai_puppet.goalRadius = level.ai_puppet.goalRadius + 64;
				}
				else if(self buttonpressed("Dev Block strings are not supported"))
				{
					radius = level.ai_puppet.goalRadius - 64;
					if(radius < 16)
					{
						radius = 16;
					}
					level.ai_puppet.goalRadius = radius;
				}
				else if(self buttonpressed("Dev Block strings are not supported"))
				{
					level.ai_puppet.goalRadius = 16;
				}
			}
			if(isdefined(level.ai_puppet))
			{
				if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
				{
					level.ai_puppet.fixedNode = 1;
					ai_puppeteer_render_ai(level.ai_puppet, (1, 1, 1));
				}
				else
				{
					level.ai_puppet.fixedNode = 0;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ai_puppet_set
	Namespace: ai_puppeteer
	Checksum: 0xD212E734
	Offset: 0x1018
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function ai_puppet_set()
{
	/#
		level.ai_puppet = level.playerCursorAi;
		level.ai_puppet.isPuppet = 1;
		level.ai_puppet.old_goalradius = level.ai_puppet.goalRadius;
		level.ai_puppet.goalRadius = 16;
		level.ai_puppet StopAnimScripted();
	#/
}

/*
	Name: ai_puppet_release
	Namespace: ai_puppeteer
	Checksum: 0xABA40A3B
	Offset: 0x10A0
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function ai_puppet_release(restore)
{
	/#
		if(isdefined(level.ai_puppet))
		{
			if(restore)
			{
				level.ai_puppet.goalRadius = level.ai_puppet.old_goalradius;
				level.ai_puppet.isPuppet = 0;
				level.ai_puppet clearentitytarget();
			}
			level.ai_puppet = undefined;
		}
	#/
}

/*
	Name: ai_puppet_cursor_tracker
	Namespace: ai_puppeteer
	Checksum: 0xD09280A4
	Offset: 0x1128
	Size: 0x2CF
	Parameters: 0
	Flags: None
*/
function ai_puppet_cursor_tracker()
{
	/#
		level endon("kill ai puppeteer");
		self endon("death");
		while(1)
		{
			FORWARD = AnglesToForward(self getPlayerAngles());
			forward_vector = VectorScale(FORWARD, 4000);
			level.playerCursor = bullettrace(self GetEye(), self GetEye() + forward_vector, 1, self);
			level.playerCursorAi = undefined;
			level.playerCursorNode = undefined;
			cursorColor = (0, 1, 1);
			hitEnt = level.playerCursor["Dev Block strings are not supported"];
			if(isdefined(hitEnt) && isai(hitEnt))
			{
				cursorColor = (1, 0, 0);
				if(isdefined(level.ai_puppet) && level.ai_puppet != hitEnt)
				{
					if(!level.ai_puppet_highlighting)
					{
						ai_puppeteer_render_ai(hitEnt, cursorColor);
					}
				}
				level.playerCursorAi = hitEnt;
			}
			else if(isdefined(level.ai_puppet))
			{
				nodes = GetAnyNodeArray(level.playerCursor["Dev Block strings are not supported"], 24);
				if(nodes.size > 0)
				{
					node = nodes[0];
					if(node.type != "Dev Block strings are not supported" && DistanceSquared(node.origin, level.playerCursor["Dev Block strings are not supported"]) < 576)
					{
						if(!level.ai_puppet_highlighting)
						{
							ai_puppeteer_render_node(node, (0, 1, 1));
						}
						level.playerCursorNode = node;
					}
				}
			}
			if(!level.ai_puppet_highlighting)
			{
				ai_puppeteer_render_point(level.playerCursor["Dev Block strings are not supported"], level.playerCursor["Dev Block strings are not supported"], FORWARD, cursorColor);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ai_puppeteer_create_hud
	Namespace: ai_puppeteer
	Checksum: 0x578FD6BB
	Offset: 0x1400
	Size: 0x3AB
	Parameters: 0
	Flags: None
*/
function ai_puppeteer_create_hud()
{
	/#
		/#
			level.puppeteer_hud_select = NewDebugHudElem();
			level.puppeteer_hud_select.x = 0;
			level.puppeteer_hud_select.y = 180;
			level.puppeteer_hud_select.fontscale = 1;
			level.puppeteer_hud_select.alignX = "Dev Block strings are not supported";
			level.puppeteer_hud_select.horzAlign = "Dev Block strings are not supported";
			level.puppeteer_hud_select.color = (0, 0, 1);
			level.puppeteer_hud_goto = NewDebugHudElem();
			level.puppeteer_hud_goto.x = 0;
			level.puppeteer_hud_goto.y = 200;
			level.puppeteer_hud_goto.fontscale = 1;
			level.puppeteer_hud_goto.alignX = "Dev Block strings are not supported";
			level.puppeteer_hud_goto.horzAlign = "Dev Block strings are not supported";
			level.puppeteer_hud_goto.color = (0, 1, 0);
			level.puppeteer_hud_lookat = NewDebugHudElem();
			level.puppeteer_hud_lookat.x = 0;
			level.puppeteer_hud_lookat.y = 220;
			level.puppeteer_hud_lookat.fontscale = 1;
			level.puppeteer_hud_lookat.alignX = "Dev Block strings are not supported";
			level.puppeteer_hud_lookat.horzAlign = "Dev Block strings are not supported";
			level.puppeteer_hud_lookat.color = (0, 1, 1);
			level.puppeteer_hud_shoot = NewDebugHudElem();
			level.puppeteer_hud_shoot.x = 0;
			level.puppeteer_hud_shoot.y = 240;
			level.puppeteer_hud_shoot.fontscale = 1;
			level.puppeteer_hud_shoot.alignX = "Dev Block strings are not supported";
			level.puppeteer_hud_shoot.horzAlign = "Dev Block strings are not supported";
			level.puppeteer_hud_shoot.color = (1, 1, 1);
			level.var_16b904f3 = NewDebugHudElem();
			level.var_16b904f3.x = 0;
			level.var_16b904f3.y = 260;
			level.var_16b904f3.fontscale = 1;
			level.var_16b904f3.alignX = "Dev Block strings are not supported";
			level.var_16b904f3.horzAlign = "Dev Block strings are not supported";
			level.var_16b904f3.color = (1, 0, 0);
			level.puppeteer_hud_select setText("Dev Block strings are not supported");
			level.puppeteer_hud_goto setText("Dev Block strings are not supported");
			level.puppeteer_hud_lookat setText("Dev Block strings are not supported");
			level.puppeteer_hud_shoot setText("Dev Block strings are not supported");
			level.var_16b904f3 setText("Dev Block strings are not supported");
		#/
	#/
}

/*
	Name: ai_puppeteer_destroy_hud
	Namespace: ai_puppeteer
	Checksum: 0x400AB25A
	Offset: 0x17B8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function ai_puppeteer_destroy_hud()
{
	/#
		if(isdefined(level.puppeteer_hud_select))
		{
			level.puppeteer_hud_select destroy();
		}
		if(isdefined(level.puppeteer_hud_lookat))
		{
			level.puppeteer_hud_lookat destroy();
		}
		if(isdefined(level.puppeteer_hud_goto))
		{
			level.puppeteer_hud_goto destroy();
		}
		if(isdefined(level.puppeteer_hud_shoot))
		{
			level.puppeteer_hud_shoot destroy();
		}
	#/
}

/*
	Name: ai_puppeteer_render_point
	Namespace: ai_puppeteer
	Checksum: 0x3CAE6BCB
	Offset: 0x1868
	Size: 0x163
	Parameters: 4
	Flags: None
*/
function ai_puppeteer_render_point(point, normal, FORWARD, color)
{
	/#
		surface_vector = VectorCross(FORWARD, normal);
		surface_vector = VectorNormalize(surface_vector);
		line(point, point + VectorScale(surface_vector, 5), color, 1, 1);
		line(point, point + VectorScale(surface_vector, -5), color, 1, 1);
		surface_vector = VectorCross(normal, surface_vector);
		surface_vector = VectorNormalize(surface_vector);
		line(point, point + VectorScale(surface_vector, 5), color, 1, 1);
		line(point, point + VectorScale(surface_vector, -5), color, 1, 1);
	#/
}

/*
	Name: ai_puppeteer_render_node
	Namespace: ai_puppeteer
	Checksum: 0x69B4D232
	Offset: 0x19D8
	Size: 0x123
	Parameters: 2
	Flags: None
*/
function ai_puppeteer_render_node(node, color)
{
	/#
		print3d(node.origin, node.type, color, 1, 0.35);
		box(node.origin, VectorScale((-1, -1, 0), 16), VectorScale((1, 1, 1), 16), node.angles[1], color, 1, 1);
		nodeForward = AnglesToForward(node.angles);
		nodeForward = VectorScale(nodeForward, 8);
		line(node.origin, node.origin + nodeForward, color, 1, 1);
	#/
}

/*
	Name: ai_puppeteer_render_ai
	Namespace: ai_puppeteer
	Checksum: 0xEEF902B
	Offset: 0x1B08
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function ai_puppeteer_render_ai(ai, color)
{
	/#
		circle(ai.goalpos + (0, 0, 1), ai.goalRadius, color, 0, 1);
		circle(ai.origin + (0, 0, 1), ai function_7e33656b(), (1, 0, 0), 0, 1);
		line(ai.goalpos, ai.origin, color, 1, 1);
	#/
}

/*
	Name: ai_puppeteer_highlight_point
	Namespace: ai_puppeteer
	Checksum: 0x357DBADB
	Offset: 0x1BE0
	Size: 0xC7
	Parameters: 4
	Flags: None
*/
function ai_puppeteer_highlight_point(point, normal, FORWARD, color)
{
	/#
		level endon("kill ai puppeteer");
		self endon("death");
		level.ai_puppet_highlighting = 1;
		timer = 0;
		while(timer < 0.7)
		{
			ai_puppeteer_render_point(point, normal, FORWARD, color);
			timer = timer + 0.15;
			wait(0.15);
		}
		level.ai_puppet_highlighting = 0;
	#/
}

/*
	Name: ai_puppeteer_highlight_node
	Namespace: ai_puppeteer
	Checksum: 0xEFF01CBB
	Offset: 0x1CB0
	Size: 0xA7
	Parameters: 1
	Flags: None
*/
function ai_puppeteer_highlight_node(node)
{
	/#
		level endon("kill ai puppeteer");
		self endon("death");
		level.ai_puppet_highlighting = 1;
		timer = 0;
		while(timer < 0.7)
		{
			ai_puppeteer_render_node(node, (0, 1, 0));
			timer = timer + 0.15;
			wait(0.15);
		}
		level.ai_puppet_highlighting = 0;
	#/
}

/*
	Name: ai_puppeteer_highlight_ai
	Namespace: ai_puppeteer
	Checksum: 0x6A5D474
	Offset: 0x1D60
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function ai_puppeteer_highlight_ai(ai, color)
{
	/#
		level endon("kill ai puppeteer");
		self endon("death");
		level.ai_puppet_highlighting = 1;
		timer = 0;
		while(timer < 0.7 && isdefined(ai))
		{
			ai_puppeteer_render_ai(ai, color);
			timer = timer + 0.15;
			wait(0.15);
		}
		level.ai_puppet_highlighting = 0;
	#/
}

