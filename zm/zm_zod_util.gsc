#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_margwa;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace namespace_8e578893;

/*
	Name: __init__sytem__
	Namespace: namespace_8e578893
	Checksum: 0x5FB11104
	Offset: 0x348
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_util", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8e578893
	Checksum: 0xE7160671
	Offset: 0x390
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_51a9eeb9 = [];
}

/*
	Name: __main__
	Namespace: namespace_8e578893
	Checksum: 0xEE9D1FCD
	Offset: 0x3A8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
		Assert(isdefined(level.zombie_spawners));
	#/
	if(isdefined(level.var_df6256da))
	{
		foreach(fn in level.var_df6256da)
		{
			function_6681ab86(fn);
		}
	}
	level.var_df6256da = undefined;
	function_6681ab86(&function_3fb7d590);
	callback::on_connect(&on_player_connect);
	level.var_ee31d3b1 = struct::get_array("teleport_position");
}

/*
	Name: function_6c995606
	Namespace: namespace_8e578893
	Checksum: 0x41CBCB1
	Offset: 0x4D8
	Size: 0xE1
	Parameters: 2
	Flags: None
*/
function function_6c995606(v_pos, v_angles)
{
	if(level.var_51a9eeb9.size == 0)
	{
		e_model = util::spawn_model("tag_origin", v_pos, v_angles);
		return e_model;
	}
	else
	{
		n_index = level.var_51a9eeb9.size - 1;
		e_model = level.var_51a9eeb9[n_index];
		ArrayRemoveIndex(level.var_51a9eeb9, n_index);
		e_model.angles = v_angles;
		e_model.origin = v_pos;
		e_model notify("hash_7af2343d");
		return e_model;
	}
}

/*
	Name: function_44a841
	Namespace: namespace_8e578893
	Checksum: 0x495976E7
	Offset: 0x5C8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_44a841()
{
	if(!isdefined(level.var_51a9eeb9))
	{
		level.var_51a9eeb9 = [];
	}
	else if(!IsArray(level.var_51a9eeb9))
	{
		level.var_51a9eeb9 = Array(level.var_51a9eeb9);
	}
	level.var_51a9eeb9[level.var_51a9eeb9.size] = self;
	self thread function_5fec5f06();
}

/*
	Name: function_5fec5f06
	Namespace: namespace_8e578893
	Checksum: 0x695CD8A1
	Offset: 0x658
	Size: 0x4B
	Parameters: 0
	Flags: Private
*/
function private function_5fec5f06()
{
	self endon("hash_7af2343d");
	wait(20);
	ArrayRemoveValue(level.var_51a9eeb9, self);
	self delete();
}

/*
	Name: function_3fb7d590
	Namespace: namespace_8e578893
	Checksum: 0xDAFBD50C
	Offset: 0x6B0
	Size: 0xD1
	Parameters: 0
	Flags: Private
*/
function private function_3fb7d590()
{
	self waittill("death", e_attacker, str_means_of_death, weapon);
	if(isdefined(self))
	{
		if(isdefined(level.var_7806fb91))
		{
			foreach(var_8643a121 in level.var_7806fb91)
			{
				self thread [[var_8643a121]](e_attacker, str_means_of_death, weapon);
			}
		}
	}
}

/*
	Name: function_f7f2ffed
	Namespace: namespace_8e578893
	Checksum: 0xB333C970
	Offset: 0x790
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_f7f2ffed(V)
{
	return "<" + V[0] + ", " + V[1] + ", " + V[2] + ">";
}

/*
	Name: function_d92ce25
	Namespace: namespace_8e578893
	Checksum: 0x522A28FA
	Offset: 0x7E8
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function function_d92ce25(player)
{
	b_visible = 1;
	if(isdefined(player.beastmode) && player.beastmode && (!isdefined(self.var_8842df9d) && self.var_8842df9d))
	{
		b_visible = 0;
	}
	else if(isdefined(self.stub.var_98775f3))
	{
		b_visible = self [[self.stub.var_98775f3]](player);
	}
	str_msg = &"";
	param1 = undefined;
	if(b_visible)
	{
		if(isdefined(self.stub.var_af0b9c6c))
		{
			str_msg = self [[self.stub.var_af0b9c6c]](player);
		}
		else
		{
			str_msg = self.stub.hint_string;
			param1 = self.stub.hint_parm1;
		}
	}
	if(isdefined(param1))
	{
		self setHintString(str_msg, param1);
	}
	else
	{
		self setHintString(str_msg);
	}
	return b_visible;
}

/*
	Name: function_c1947ff7
	Namespace: namespace_8e578893
	Checksum: 0x15BD2504
	Offset: 0x960
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_c1947ff7()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_4973348c
	Namespace: namespace_8e578893
	Checksum: 0xE5D9A087
	Offset: 0x988
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_4973348c()
{
	self.var_8842df9d = 1;
}

/*
	Name: unitrigger_think
	Namespace: namespace_8e578893
	Checksum: 0xFC80AA6F
	Offset: 0x9A0
	Size: 0x9B
	Parameters: 0
	Flags: Private
*/
function private unitrigger_think()
{
	self endon("kill_trigger");
	self.stub thread function_c1947ff7();
	while(1)
	{
		self waittill("trigger", player);
		if(isdefined(self.var_8842df9d) && self.var_8842df9d || (!isdefined(player.beastmode) && player.beastmode))
		{
			self.stub notify("trigger", player);
		}
	}
}

/*
	Name: teleport_player
	Namespace: namespace_8e578893
	Checksum: 0xE7346C2B
	Offset: 0xA48
	Size: 0x3CB
	Parameters: 1
	Flags: None
*/
function teleport_player(struct_targetname)
{
	/#
		Assert(isdefined(struct_targetname));
	#/
	a_dest = struct::get_array(struct_targetname, "targetname");
	if(a_dest.size == 0)
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported" + struct_targetname + "Dev Block strings are not supported");
			#/
		#/
		return;
	}
	v_dest_origin = a_dest[0].origin;
	v_dest_angles = a_dest[0].angles;
	var_675a91a3 = 0;
	var_accbe04 = function_6c995606(self.origin, self.angles);
	self PlayerLinkToAbsolute(var_accbe04, "tag_origin");
	var_accbe04.origin = level.var_ee31d3b1[self.characterindex].origin;
	var_accbe04.angles = level.var_ee31d3b1[self.characterindex].angles;
	self FreezeControls(1);
	self DisableWeapons();
	self disableOffhandWeapons();
	wait(2);
	foreach(s_dest in a_dest)
	{
		foreach(e_player in level.players)
		{
			if(Distance2DSquared(e_player.origin, s_dest.origin) > 10000)
			{
				var_675a91a3 = 1;
				v_dest_origin = s_dest.origin;
				v_dest_angles = s_dest.angles;
				break;
			}
		}
		if(var_675a91a3)
		{
			break;
		}
	}
	var_accbe04.origin = v_dest_origin;
	var_accbe04.angles = v_dest_angles;
	wait(0.5);
	self Unlink();
	var_accbe04 function_44a841();
	self FreezeControls(0);
	self enableWeapons();
	self EnableOffhandWeapons();
}

/*
	Name: set_unitrigger_hint_string
	Namespace: namespace_8e578893
	Checksum: 0x7579C6D6
	Offset: 0xE20
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function set_unitrigger_hint_string(str_message, param1)
{
	self.hint_string = str_message;
	self.hint_parm1 = param1;
	zm_unitrigger::unregister_unitrigger(self);
	zm_unitrigger::register_unitrigger(self, &unitrigger_think);
}

/*
	Name: function_a40fee2f
	Namespace: namespace_8e578893
	Checksum: 0xC2EF750E
	Offset: 0xE90
	Size: 0x1F7
	Parameters: 5
	Flags: Private
*/
function private function_a40fee2f(origin, angles, var_3b9cee11, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	str_type = "unitrigger_radius";
	if(IsVec(var_3b9cee11))
	{
		trigger_stub.script_length = var_3b9cee11[0];
		trigger_stub.script_width = var_3b9cee11[1];
		trigger_stub.script_height = var_3b9cee11[2];
		str_type = "unitrigger_box";
		if(!isdefined(angles))
		{
			angles = (0, 0, 0);
		}
		trigger_stub.angles = angles;
	}
	else
	{
		trigger_stub.radius = var_3b9cee11;
	}
	if(use_trigger)
	{
		trigger_stub.cursor_hint = "HINT_NOICON";
		trigger_stub.script_unitrigger_type = str_type + "_use";
	}
	else
	{
		trigger_stub.script_unitrigger_type = str_type;
	}
	if(isdefined(func_per_player_msg))
	{
		trigger_stub.var_af0b9c6c = func_per_player_msg;
		zm_unitrigger::unitrigger_force_per_player_triggers(trigger_stub, 1);
	}
	trigger_stub.prompt_and_visibility_func = &function_d92ce25;
	zm_unitrigger::register_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: function_d095318
	Namespace: namespace_8e578893
	Checksum: 0xE7B132EE
	Offset: 0x1090
	Size: 0x59
	Parameters: 4
	Flags: None
*/
function function_d095318(origin, radius, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	return function_a40fee2f(origin, undefined, radius, use_trigger, func_per_player_msg);
}

/*
	Name: function_c17c0335
	Namespace: namespace_8e578893
	Checksum: 0xB00194D2
	Offset: 0x10F8
	Size: 0x61
	Parameters: 5
	Flags: None
*/
function function_c17c0335(origin, angles, var_f726970c, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	return function_a40fee2f(origin, angles, var_f726970c, use_trigger, func_per_player_msg);
}

/*
	Name: function_6681ab86
	Namespace: namespace_8e578893
	Checksum: 0xB101CAC6
	Offset: 0x1168
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function function_6681ab86(var_16552c29)
{
	if(!isdefined(level.zombie_spawners))
	{
		if(!isdefined(level.var_df6256da))
		{
			level.var_df6256da = [];
		}
		if(!isdefined(level.var_df6256da))
		{
			level.var_df6256da = [];
		}
		else if(!IsArray(level.var_df6256da))
		{
			level.var_df6256da = Array(level.var_df6256da);
		}
		level.var_df6256da[level.var_df6256da.size] = var_16552c29;
	}
	else
	{
		Array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, var_16552c29);
		var_9fe2a32c = GetEntArray("ritual_zombie_spawner", "targetname");
		Array::thread_all(var_9fe2a32c, &spawner::add_spawn_function, var_16552c29);
	}
}

/*
	Name: on_player_connect
	Namespace: namespace_8e578893
	Checksum: 0x7BA8ABBA
	Offset: 0x1290
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("bled_out");
		if(isdefined(level.var_d4326708))
		{
			foreach(fn in level.var_d4326708)
			{
				self thread [[fn]]();
			}
		}
	}
}

/*
	Name: function_2d5dfb29
	Namespace: namespace_8e578893
	Checksum: 0x41550F87
	Offset: 0x1350
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function function_2d5dfb29(var_57314382)
{
	if(!isdefined(level.var_7806fb91))
	{
		level.var_7806fb91 = [];
	}
	if(!isdefined(level.var_7806fb91))
	{
		level.var_7806fb91 = [];
	}
	else if(!IsArray(level.var_7806fb91))
	{
		level.var_7806fb91 = Array(level.var_7806fb91);
	}
	level.var_7806fb91[level.var_7806fb91.size] = var_57314382;
}

/*
	Name: function_658879b1
	Namespace: namespace_8e578893
	Checksum: 0x294A7FE6
	Offset: 0x13F0
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function function_658879b1(var_8643a121)
{
	if(!isdefined(level.var_d4326708))
	{
		level.var_d4326708 = [];
	}
	if(!isdefined(level.var_d4326708))
	{
		level.var_d4326708 = [];
	}
	else if(!IsArray(level.var_d4326708))
	{
		level.var_d4326708 = Array(level.var_d4326708);
	}
	level.var_d4326708[level.var_d4326708.size] = var_8643a121;
}

/*
	Name: function_6edf48d5
	Namespace: namespace_8e578893
	Checksum: 0xCB377CBC
	Offset: 0x1490
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function function_6edf48d5(var_5017cd53, var_d00db512)
{
	self notify("hash_6edf48d5");
	self endon("disconnect");
	self endon("hash_6edf48d5");
	self thread clientfield::set_to_player("player_rumble_and_shake", var_5017cd53);
	if(isdefined(var_d00db512))
	{
		wait(var_d00db512);
		self thread function_6edf48d5(0);
	}
}

/*
	Name: function_3a7a7013
	Namespace: namespace_8e578893
	Checksum: 0xF3A5E99B
	Offset: 0x1520
	Size: 0x101
	Parameters: 4
	Flags: None
*/
function function_3a7a7013(var_5017cd53, n_radius, v_origin, var_d00db512)
{
	var_699d80d5 = n_radius * n_radius;
	foreach(player in level.activePlayers)
	{
		if(isdefined(player) && Distance2DSquared(player.origin, v_origin) <= var_699d80d5)
		{
			player thread function_6edf48d5(var_5017cd53, var_d00db512);
		}
	}
}

/*
	Name: function_5cc835d6
	Namespace: namespace_8e578893
	Checksum: 0x12987D36
	Offset: 0x1630
	Size: 0x11B
	Parameters: 3
	Flags: None
*/
function function_5cc835d6(v_origin, v_target, n_duration)
{
	/#
		Assert(isdefined(v_origin), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(v_target), "Dev Block strings are not supported");
	#/
	e_fx = function_6c995606(v_origin, (0, 0, 0));
	e_fx clientfield::set("zod_egg_soul", 1);
	e_fx moveto(v_target, n_duration);
	e_fx waittill("movedone");
	e_fx clientfield::set("zod_egg_soul", 0);
	e_fx function_44a841();
}

/*
	Name: function_15166300
	Namespace: namespace_8e578893
	Checksum: 0x67FF3D05
	Offset: 0x1758
	Size: 0x28B
	Parameters: 1
	Flags: None
*/
function function_15166300(var_c3a9e22d)
{
	var_49fa7253 = 0;
	var_565450eb = 0;
	n_wasps_alive = 0;
	n_raps_alive = 0;
	switch(var_c3a9e22d)
	{
		case 1:
		{
			var_565450eb = zombie_utility::get_current_zombie_count();
			var_32218d0b = min(level.activePlayers.size * 5, 10);
			var_49fa7253 = var_32218d0b - var_565450eb;
			break;
		}
		case 2:
		{
			n_wasps_alive = zm_ai_wasp::get_current_wasp_count();
			var_32218d0b = min(level.activePlayers.size * 4, 8);
			var_49fa7253 = var_32218d0b - n_wasps_alive;
			break;
		}
		case 3:
		{
			n_raps_alive = zm_ai_raps::get_current_raps_count();
			var_32218d0b = min(level.activePlayers.size * 4, 13);
			var_49fa7253 = var_32218d0b - n_raps_alive;
			break;
		}
		case 4:
		{
			var_49fa7253 = 3 - level.var_6e63e659;
			var_73d2bce8 = level.zm_loc_types["margwa_location"].size < 1;
			if(var_73d2bce8)
			{
				var_49fa7253 = 0;
			}
			break;
		}
	}
	var_4422ef10 = var_565450eb + n_wasps_alive * 2 + n_raps_alive * 2 + level.var_6e63e659;
	var_e1bef548 = level.zombie_ai_limit - var_4422ef10;
	var_49fa7253 = min(var_49fa7253, var_e1bef548);
	if(var_49fa7253 > 0 && (var_c3a9e22d === 2 || var_c3a9e22d === 3))
	{
		var_49fa7253 = var_49fa7253 / 2;
		var_49fa7253 = floor(var_49fa7253);
	}
	return var_49fa7253;
}

/*
	Name: function_55f114f9
	Namespace: namespace_8e578893
	Checksum: 0x30304A59
	Offset: 0x19F0
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function function_55f114f9(var_c94b52fa, n_duration)
{
	self clientfield::set_player_uimodel(var_c94b52fa, 1);
	wait(n_duration);
	self clientfield::set_player_uimodel(var_c94b52fa, 0);
}

/*
	Name: show_infotext_for_duration
	Namespace: namespace_8e578893
	Checksum: 0xA26A96A4
	Offset: 0x1A50
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: setup_devgui_func
	Namespace: namespace_8e578893
	Checksum: 0x9EEE0471
	Offset: 0x1AB0
	Size: 0x11F
	Parameters: 5
	Flags: None
*/
function setup_devgui_func(str_devgui_path, str_dvar, n_value, func, n_base_value)
{
	if(!isdefined(n_base_value))
	{
		n_base_value = -1;
	}
	SetDvar(str_dvar, n_base_value);
	AddDebugCommand("devgui_cmd "" + str_devgui_path + "" "" + str_dvar + " " + n_value + ""
");
	while(1)
	{
		n_dvar = GetDvarInt(str_dvar);
		if(n_dvar > n_base_value)
		{
			[[func]](n_dvar);
			SetDvar(str_dvar, n_base_value);
		}
		util::wait_network_frame();
	}
}

