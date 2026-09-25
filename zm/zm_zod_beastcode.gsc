#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace namespace_b361ecc3;

/*
	Name: __init__sytem__
	Namespace: namespace_b361ecc3
	Checksum: 0xF5AC61D0
	Offset: 0x438
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_beastcode", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_b361ecc3
	Checksum: 0x99EC1590
	Offset: 0x478
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: init
	Namespace: namespace_b361ecc3
	Checksum: 0xF86350C0
	Offset: 0x488
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function init()
{
	var_2516d492 = [];
	var_f90df519 = [];
	var_bf684c45 = [];
	for(i = 0; i < 3; i++)
	{
		var_c53d0ab2 = GetEnt("keeper_sword_locker_clue_" + i, "targetname");
		var_f90df519[var_f90df519.size] = var_c53d0ab2;
	}
	for(i = 0; i < 10; i++)
	{
		var_fce4f486 = GetEnt("keeper_sword_locker_number_" + i, "targetname");
		var_2516d492[var_2516d492.size] = var_fce4f486;
		var_d729a52a = GetEnt("keeper_sword_locker_trigger_" + i, "targetname");
		var_bf684c45[var_bf684c45.size] = var_d729a52a;
	}
	var_4582f16d = GetEntArray("keeper_sword_locker_clue_lookat", "targetname");
	function_9b385ca5();
	level.var_ca7eab3b = var_b43ec356;
	init(level.var_ca7eab3b, var_2516d492, var_bf684c45, var_4582f16d);
	var_b1917dfa = function_c69f5b9d();
	function_110d42fa(level.var_ca7eab3b);
}

/*
	Name: function_146f6916
	Namespace: namespace_b361ecc3
	Checksum: 0xA3B990EF
	Offset: 0x690
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_146f6916()
{
	level flag::set("keeper_sword_locker");
}

#namespace namespace_b43ec356;

/*
	Name: init
	Namespace: namespace_b43ec356
	Checksum: 0x6A80B72F
	Offset: 0x6C0
	Size: 0x123
	Parameters: 4
	Flags: None
*/
function init(var_2516d492, var_bf684c45, var_4582f16d, func_activate)
{
	self.var_5475b2f6 = var_2516d492;
	self.var_4d6497d9 = var_bf684c45;
	self.var_1d4fdfa6 = var_4582f16d;
	self.var_75a61704 = Array(0, 0, 0);
	self.var_d270ab05 = 0;
	self.var_d5f15351 = Array(function_6bbb4752());
	self.var_2c51c4a = Array(func_activate);
	self.var_36948aba = 1;
	self.var_71f130fa = self.var_36948aba;
	self thread function_4e399c97();
	self thread function_36c50de5();
	self.var_7a01aaae = 0;
	self.var_116811f0 = 1;
}

/*
	Name: function_c69f5b9d
	Namespace: namespace_b43ec356
	Checksum: 0x81DA9E91
	Offset: 0x7F0
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function function_c69f5b9d(var_951f65fa)
{
	if(!isdefined(var_951f65fa))
	{
		var_951f65fa = 0;
	}
	var_b1917dfa = self.var_d5f15351[var_951f65fa];
	return var_b1917dfa;
}

/*
	Name: function_1efeef1f
	Namespace: namespace_b43ec356
	Checksum: 0x54EC2CA
	Offset: 0x838
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function function_1efeef1f(var_951f65fa, var_def860b4)
{
	return self.var_d5f15351[var_951f65fa][var_def860b4];
}

/*
	Name: function_113a1256
	Namespace: namespace_b43ec356
	Checksum: 0xEA4C9267
	Offset: 0x868
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_113a1256()
{
	return self.var_a2ddee88;
}

/*
	Name: function_6bbb4752
	Namespace: namespace_b43ec356
	Checksum: 0x521180F3
	Offset: 0x880
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function function_6bbb4752()
{
	var_a3a90476 = Array(0, 1, 2, 3, 4, 5, 6, 7, 8);
	var_b1917dfa = [];
	for(i = 0; i < 3; i++)
	{
		var_a3a90476 = Array::randomize(var_a3a90476);
		var_852832cf = Array::pop_front(var_a3a90476);
		if(!isdefined(var_b1917dfa))
		{
			var_b1917dfa = [];
		}
		else if(!IsArray(var_b1917dfa))
		{
			var_b1917dfa = Array(var_b1917dfa);
		}
		var_b1917dfa[var_b1917dfa.size] = var_852832cf;
	}
	return var_b1917dfa;
}

/*
	Name: function_cc777878
	Namespace: namespace_b43ec356
	Checksum: 0x81D19590
	Offset: 0x9A0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function function_cc777878(var_b1917dfa, func_custom)
{
}

/*
	Name: function_110d42fa
	Namespace: namespace_b43ec356
	Checksum: 0x60982E6D
	Offset: 0x9C0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function function_110d42fa(var_f90df519, n_index)
{
	if(!isdefined(n_index))
	{
		n_index = 0;
	}
	if(!isdefined(self.var_c256f3a5))
	{
		self.var_c256f3a5 = Array(undefined);
	}
	self.var_c256f3a5[n_index] = var_f90df519;
	self thread function_65cfd36f(n_index);
}

/*
	Name: function_5b0296e8
	Namespace: namespace_b43ec356
	Checksum: 0x2AAEFD80
	Offset: 0xA48
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function function_5b0296e8(b_hide)
{
	if(!isdefined(b_hide))
	{
		b_hide = 1;
	}
	foreach(var_22f3c343 in self.var_5475b2f6)
	{
		if(b_hide)
		{
			var_22f3c343 ghost();
			continue;
		}
		var_22f3c343 show();
		namespace_215602b6::function_41cc3fc8();
	}
}

/*
	Name: function_2f4a90b6
	Namespace: namespace_b43ec356
	Checksum: 0x271B5DC
	Offset: 0xB30
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_2f4a90b6(n_index)
{
	self.var_5475b2f6[n_index] ghost();
}

/*
	Name: function_4e399c97
	Namespace: namespace_b43ec356
	Checksum: 0x6217FB4C
	Offset: 0xB68
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_4e399c97()
{
	for(i = 0; i < self.var_5475b2f6.size; i++)
	{
		self.var_5475b2f6[i] thread namespace_215602b6::function_c5c7aef3(self.var_4d6497d9[i]);
		self.var_4d6497d9[i] thread function_e174bab4(self, i);
		function_d48f6252(i, i);
	}
}

/*
	Name: function_36c50de5
	Namespace: namespace_b43ec356
	Checksum: 0xC4D70E94
	Offset: 0xC10
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_36c50de5()
{
	while(1)
	{
		level waittill("start_of_round");
		if(0 >= self.var_71f130fa)
		{
			function_5b0296e8(0);
			self.var_116811f0 = 1;
		}
		self.var_71f130fa = self.var_36948aba;
	}
}

/*
	Name: function_d48f6252
	Namespace: namespace_b43ec356
	Checksum: 0x29F759F6
	Offset: 0xC78
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function function_d48f6252(n_index, n_value)
{
	var_22f3c343 = self.var_5475b2f6[n_index];
	for(i = 0; i < 10; i++)
	{
		var_22f3c343 HidePart("J_" + i);
		var_22f3c343 HidePart("j_keeper_" + i);
	}
	var_22f3c343 ShowPart("j_keeper_" + n_value);
}

/*
	Name: function_13c28fed
	Namespace: namespace_b43ec356
	Checksum: 0xF72C379E
	Offset: 0xD50
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function function_13c28fed(n_index, var_36f3fe5b)
{
	if(var_36f3fe5b)
	{
		self.var_5475b2f6[n_index] show();
	}
	else
	{
		self.var_5475b2f6[n_index] Hide();
	}
}

/*
	Name: function_65cfd36f
	Namespace: namespace_b43ec356
	Checksum: 0x24BDB145
	Offset: 0xDC0
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function function_65cfd36f(n_index)
{
	if(!isdefined(n_index))
	{
		n_index = 0;
	}
	var_b1917dfa = self.var_d5f15351[n_index];
	for(i = 0; i < 3; i++)
	{
		var_c53d0ab2 = self.var_c256f3a5[n_index][i];
		for(j = 0; j < 10; j++)
		{
			var_c53d0ab2 HidePart("J_" + j);
			var_c53d0ab2 HidePart("p7_zm_zod_keepers_code_0" + j);
		}
		var_c53d0ab2 ShowPart("p7_zm_zod_keepers_code_0" + var_b1917dfa[i]);
	}
}

/*
	Name: function_869ec8c8
	Namespace: namespace_b43ec356
	Checksum: 0x72A1E1C9
	Offset: 0xEE8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_869ec8c8()
{
	self.var_71f130fa = self.var_71f130fa - 1;
	for(i = 0; i < self.var_d5f15351.size; i++)
	{
		if(function_a90f2e5c(self.var_d5f15351[i]))
		{
			playsoundatposition("zmb_zod_sword_symbol_right", (2624, -5104, -312));
			self.var_116811f0 = 3;
			function_5b0296e8(1);
			[[self.var_2c51c4a[i]]]();
			return;
		}
	}
	self.var_116811f0 = 4;
	self.var_d270ab05 = 0;
	playsoundatposition("zmb_zod_sword_symbol_wrong", (2624, -5104, -312));
	if(self.var_71f130fa > 0)
	{
		function_5b0296e8(1);
		wait(3);
		function_5b0296e8(0);
		self.var_116811f0 = 1;
	}
	else
	{
		function_5b0296e8(1);
	}
}

/*
	Name: function_a90f2e5c
	Namespace: namespace_b43ec356
	Checksum: 0xFFA6DECE
	Offset: 0x1060
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_a90f2e5c(var_b1917dfa)
{
	for(i = 0; i < var_b1917dfa.size; i++)
	{
		if(!IsInArray(self.var_75a61704, var_b1917dfa[i]))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_974a40ff
	Namespace: namespace_b43ec356
	Checksum: 0x41BF41ED
	Offset: 0x10C8
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function function_974a40ff()
{
	width = 128;
	height = 128;
	length = 128;
	var_67e0afb7.unitrigger_stub = spawnstruct();
	var_67e0afb7.unitrigger_stub.origin = var_67e0afb7.origin;
	var_67e0afb7.unitrigger_stub.angles = var_67e0afb7.angles;
	var_67e0afb7.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	var_67e0afb7.unitrigger_stub.cursor_hint = "HINT_NOICON";
	var_67e0afb7.unitrigger_stub.script_width = width;
	var_67e0afb7.unitrigger_stub.script_height = height;
	var_67e0afb7.unitrigger_stub.script_length = length;
	var_67e0afb7.unitrigger_stub.require_look_at = 0;
	var_67e0afb7.unitrigger_stub.var_7aae7803 = self;
	var_67e0afb7.unitrigger_stub.prompt_and_visibility_func = &function_7a9d4a27;
	zm_unitrigger::register_static_unitrigger(var_67e0afb7.unitrigger_stub, &function_e174bab4);
}

/*
	Name: function_71154a2
	Namespace: namespace_b43ec356
	Checksum: 0x78E69D39
	Offset: 0x1288
	Size: 0x251
	Parameters: 3
	Flags: None
*/
function function_71154a2(t_lookat, var_951f65fa, var_d7d7b586)
{
	var_c929283d = struct::get(t_lookat.target, "targetname");
	var_43544e59 = var_c929283d.origin;
	while(1)
	{
		t_lookat waittill("trigger", player);
		while(player istouching(t_lookat))
		{
			v_eye_origin = player GetPlayerCameraPos();
			v_eye_direction = AnglesToForward(player getPlayerAngles());
			var_744d3805 = VectorNormalize(var_43544e59 - v_eye_origin);
			n_dot = VectorDot(var_744d3805, v_eye_direction);
			if(n_dot > 0.9)
			{
				var_852832cf = function_1efeef1f(var_951f65fa, var_d7d7b586);
				player.var_ab153665 = player hud::createPrimaryProgressBarText();
				player.var_ab153665 setText("You sense the number " + var_852832cf);
				player.var_ab153665 hud::showElem();
			}
			wait(0.05);
			if(isdefined(player.var_ab153665))
			{
				player.var_ab153665 hud::destroyElem();
				player.var_ab153665 = undefined;
			}
		}
	}
}

/*
	Name: function_7a9d4a27
	Namespace: namespace_b43ec356
	Checksum: 0xCF010192
	Offset: 0x14E8
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function function_7a9d4a27(player)
{
	b_is_invis = !isdefined(player.beastmode) && player.beastmode;
	self SetInvisibleToPlayer(player, b_is_invis);
	self thread function_d081c849(player);
	return !b_is_invis;
}

/*
	Name: function_d081c849
	Namespace: namespace_b43ec356
	Checksum: 0xEAA53E1A
	Offset: 0x1570
	Size: 0x3B7
	Parameters: 1
	Flags: None
*/
function function_d081c849(player)
{
	self endon("kill_trigger");
	player endon("death_or_disconnect");
	str_hint = &"";
	str_old_hint = &"";
	var_3d791fac = function_113a1256();
	while(1)
	{
		n_state = function_384b2fb3();
		switch(n_state)
		{
			case 2:
			{
				str_hint = &"ZM_ZOD_KEYCODE_TRYING";
				break;
			}
			case 3:
			{
				str_hint = &"ZM_ZOD_KEYCODE_SUCCESS";
				break;
			}
			case 4:
			{
				str_hint = &"ZM_ZOD_KEYCODE_FAIL";
				break;
			}
			case 0:
			{
				str_hint = &"ZM_ZOD_KEYCODE_UNAVAILABLE";
				break;
			}
			case 1:
			{
				player.var_dd607d96 = undefined;
				n_closest_dot = 0.996;
				v_eye_origin = player GetPlayerCameraPos();
				v_eye_direction = AnglesToForward(player getPlayerAngles());
				foreach(s_tag in var_3d791fac)
				{
					v_tag_origin = s_tag.v_origin;
					v_eye_to_tag = VectorNormalize(v_tag_origin - v_eye_origin);
					n_dot = VectorDot(v_eye_to_tag, v_eye_direction);
					if(n_dot > n_closest_dot)
					{
						n_closest_dot = n_dot;
						player.var_dd607d96 = s_tag.n_index;
					}
				}
				if(!isdefined(player.var_dd607d96))
				{
					str_hint = &"";
				}
				else if(player.var_dd607d96 < 3)
				{
					str_hint = &"ZM_ZOD_KEYCODE_INCREMENT_NUMBER";
				}
				else
				{
					str_hint = &"ZM_ZOD_KEYCODE_ACTIVATE";
				}
				break;
			}
		}
		if(str_old_hint != str_hint)
		{
			str_old_hint = str_hint;
			self.stub.hint_string = str_hint;
			if(str_hint === &"ZM_ZOD_KEYCODE_INCREMENT_NUMBER")
			{
				self setHintString(self.stub.hint_string, player.var_dd607d96 + 1);
			}
			else
			{
				self setHintString(self.stub.hint_string);
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_e174bab4
	Namespace: namespace_b43ec356
	Checksum: 0xAD544E1C
	Offset: 0x1930
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function function_e174bab4(var_63f5ae73, n_index)
{
	while(1)
	{
		self waittill("trigger", player);
		if(var_63f5ae73.var_71f130fa <= 0)
		{
			continue;
		}
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!(isdefined(function_384b2fb3()) && function_384b2fb3()))
		{
			continue;
		}
		function_b77dd968(var_63f5ae73, player);
	}
}

/*
	Name: function_384b2fb3
	Namespace: namespace_b43ec356
	Checksum: 0xE6DE8CDE
	Offset: 0x19F0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_384b2fb3()
{
	return self.var_116811f0;
}

/*
	Name: function_b77dd968
	Namespace: namespace_b43ec356
	Checksum: 0x59BB32F7
	Offset: 0x1A08
	Size: 0x7F
	Parameters: 2
	Flags: None
*/
function function_b77dd968(player, n_index)
{
	self.var_116811f0 = 0;
	function_2f4a90b6(n_index);
	self.var_75a61704[self.var_d270ab05] = n_index;
	self.var_d270ab05++;
	if(self.var_d270ab05 == 3)
	{
		function_869ec8c8();
	}
	self.var_116811f0 = 1;
}

/*
	Name: function_9b385ca5
	Namespace: namespace_b43ec356
	Checksum: 0x99EC1590
	Offset: 0x1A90
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_b43ec356
	Checksum: 0x99EC1590
	Offset: 0x1AA0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_b361ecc3;

/*
	Name: function_b43ec356
	Namespace: namespace_b361ecc3
	Checksum: 0x19B2D208
	Offset: 0x1AB0
	Size: 0x4D5
	Parameters: 0
	Flags: 6
*/
function private autoexec function_b43ec356()
{
	classes.var_b43ec356[0] = spawnstruct();
	classes.var_b43ec356[0].__vtable[1606033458] = &namespace_b43ec356::function_5fba2032;
	classes.var_b43ec356[0].__vtable[-1690805083] = &namespace_b43ec356::function_9b385ca5;
	classes.var_b43ec356[0].__vtable[-1216489112] = &namespace_b43ec356::function_b77dd968;
	classes.var_b43ec356[0].__vtable[944451507] = &namespace_b43ec356::function_384b2fb3;
	classes.var_b43ec356[0].__vtable[-512443724] = &namespace_b43ec356::function_e174bab4;
	classes.var_b43ec356[0].__vtable[-796800951] = &namespace_b43ec356::function_d081c849;
	classes.var_b43ec356[0].__vtable[2057128487] = &namespace_b43ec356::function_7a9d4a27;
	classes.var_b43ec356[0].__vtable[118576290] = &namespace_b43ec356::function_71154a2;
	classes.var_b43ec356[0].__vtable[-1756741377] = &namespace_b43ec356::function_974a40ff;
	classes.var_b43ec356[0].__vtable[-1458622884] = &namespace_b43ec356::function_a90f2e5c;
	classes.var_b43ec356[0].__vtable[-2036414264] = &namespace_b43ec356::function_869ec8c8;
	classes.var_b43ec356[0].__vtable[1708118895] = &namespace_b43ec356::function_65cfd36f;
	classes.var_b43ec356[0].__vtable[331517933] = &namespace_b43ec356::function_13c28fed;
	classes.var_b43ec356[0].__vtable[-728800686] = &namespace_b43ec356::function_d48f6252;
	classes.var_b43ec356[0].__vtable[918883813] = &namespace_b43ec356::function_36c50de5;
	classes.var_b43ec356[0].__vtable[1312398487] = &namespace_b43ec356::function_4e399c97;
	classes.var_b43ec356[0].__vtable[793415862] = &namespace_b43ec356::function_2f4a90b6;
	classes.var_b43ec356[0].__vtable[1526896360] = &namespace_b43ec356::function_5b0296e8;
	classes.var_b43ec356[0].__vtable[286081786] = &namespace_b43ec356::function_110d42fa;
	classes.var_b43ec356[0].__vtable[-864585608] = &namespace_b43ec356::function_cc777878;
	classes.var_b43ec356[0].__vtable[1807435602] = &namespace_b43ec356::function_6bbb4752;
	classes.var_b43ec356[0].__vtable[289018454] = &namespace_b43ec356::function_113a1256;
	classes.var_b43ec356[0].__vtable[520023839] = &namespace_b43ec356::function_1efeef1f;
	classes.var_b43ec356[0].__vtable[-962634851] = &namespace_b43ec356::function_c69f5b9d;
	classes.var_b43ec356[0].__vtable[-1017222485] = &namespace_b43ec356::init;
}

