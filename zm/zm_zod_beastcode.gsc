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
	a_mdl_inputs = [];
	a_mdl_clues = [];
	a_t_inputs = [];
	for(i = 0; i < 3; i++)
	{
		mdl_clue_number = GetEnt("keeper_sword_locker_clue_" + i, "targetname");
		a_mdl_clues[a_mdl_clues.size] = mdl_clue_number;
	}
	for(i = 0; i < 10; i++)
	{
		mdl_beast_number = GetEnt("keeper_sword_locker_number_" + i, "targetname");
		a_mdl_inputs[a_mdl_inputs.size] = mdl_beast_number;
		t_input = GetEnt("keeper_sword_locker_trigger_" + i, "targetname");
		a_t_inputs[a_t_inputs.size] = t_input;
	}
	a_t_clue = GetEntArray("keeper_sword_locker_clue_lookat", "targetname");
	__constructor();
	level.o_canal_beastcode = cbeastcode;
	init(level.o_canal_beastcode, a_mdl_inputs, a_t_inputs, a_t_clue);
	a_code = get_code();
	set_clue_numbers_for_code(level.o_canal_beastcode);
}

/*
	Name: keeper_sword_locker_open_locker
	Namespace: namespace_b361ecc3
	Checksum: 0xA3B990EF
	Offset: 0x690
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function keeper_sword_locker_open_locker()
{
	level flag::set("keeper_sword_locker");
}

#namespace cbeastcode;

/*
	Name: init
	Namespace: cbeastcode
	Checksum: 0x6A80B72F
	Offset: 0x6C0
	Size: 0x123
	Parameters: 4
	Flags: None
*/
function init(a_mdl_inputs, a_t_inputs, a_t_clue, func_activate)
{
	self.m_a_mdl_inputs = a_mdl_inputs;
	self.m_a_t_inputs = a_t_inputs;
	self.var_1d4fdfa6 = a_t_clue;
	self.m_a_current = Array(0, 0, 0);
	self.m_n_input_index = 0;
	self.m_a_codes = Array(generate_random_code());
	self.m_a_funcs = Array(func_activate);
	self.var_36948aba = 1;
	self.var_71f130fa = self.var_36948aba;
	self thread setup_input_threads();
	self thread function_36c50de5();
	self.m_b_discovered = 0;
	self.m_n_device_state = 1;
}

/*
	Name: get_code
	Namespace: cbeastcode
	Checksum: 0x81DA9E91
	Offset: 0x7F0
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function get_code(n_code_index)
{
	if(!isdefined(n_code_index))
	{
		n_code_index = 0;
	}
	a_code = self.m_a_codes[n_code_index];
	return a_code;
}

/*
	Name: get_number_in_code
	Namespace: cbeastcode
	Checksum: 0x54EC2CA
	Offset: 0x838
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function get_number_in_code(n_code_index, n_place_index)
{
	return self.m_a_codes[n_code_index][n_place_index];
}

/*
	Name: get_tags_from_input_device
	Namespace: cbeastcode
	Checksum: 0xEA4C9267
	Offset: 0x868
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_tags_from_input_device()
{
	return self.m_a_s_input_button_tags;
}

/*
	Name: generate_random_code
	Namespace: cbeastcode
	Checksum: 0x521180F3
	Offset: 0x880
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function generate_random_code()
{
	a_n_numbers = Array(0, 1, 2, 3, 4, 5, 6, 7, 8);
	a_code = [];
	for(i = 0; i < 3; i++)
	{
		a_n_numbers = Array::randomize(a_n_numbers);
		n_number = Array::pop_front(a_n_numbers);
		if(!isdefined(a_code))
		{
			a_code = [];
		}
		else if(!IsArray(a_code))
		{
			a_code = Array(a_code);
		}
		a_code[a_code.size] = n_number;
	}
	return a_code;
}

/*
	Name: add_code_function_pair
	Namespace: cbeastcode
	Checksum: 0x81D19590
	Offset: 0x9A0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function add_code_function_pair(a_code, func_custom)
{
}

/*
	Name: set_clue_numbers_for_code
	Namespace: cbeastcode
	Checksum: 0x60982E6D
	Offset: 0x9C0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function set_clue_numbers_for_code(a_mdl_clues, n_index)
{
	if(!isdefined(n_index))
	{
		n_index = 0;
	}
	if(!isdefined(self.m_a_mdl_clues))
	{
		self.m_a_mdl_clues = Array(undefined);
	}
	self.m_a_mdl_clues[n_index] = a_mdl_clues;
	self thread update_clue_numbers_for_code(n_index);
}

/*
	Name: hide_readout
	Namespace: cbeastcode
	Checksum: 0x2AAEFD80
	Offset: 0xA48
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function hide_readout(b_hide)
{
	if(!isdefined(b_hide))
	{
		b_hide = 1;
	}
	foreach(mdl_input in self.m_a_mdl_inputs)
	{
		if(b_hide)
		{
			mdl_input ghost();
			continue;
		}
		mdl_input show();
		namespace_215602b6::function_41cc3fc8();
	}
}

/*
	Name: hide_given_input
	Namespace: cbeastcode
	Checksum: 0x271B5DC
	Offset: 0xB30
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function hide_given_input(n_index)
{
	self.m_a_mdl_inputs[n_index] ghost();
}

/*
	Name: setup_input_threads
	Namespace: cbeastcode
	Checksum: 0x6217FB4C
	Offset: 0xB68
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function setup_input_threads()
{
	for(i = 0; i < self.m_a_mdl_inputs.size; i++)
	{
		self.m_a_mdl_inputs[i] thread namespace_215602b6::watch_lightning_damage(self.m_a_t_inputs[i]);
		self.m_a_t_inputs[i] thread keycode_input_trigger_think(self, i);
		set_input_number(i, i);
	}
}

/*
	Name: function_36c50de5
	Namespace: cbeastcode
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
			hide_readout(0);
			self.m_n_device_state = 1;
		}
		self.var_71f130fa = self.var_36948aba;
	}
}

/*
	Name: set_input_number
	Namespace: cbeastcode
	Checksum: 0x29F759F6
	Offset: 0xC78
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function set_input_number(n_index, n_value)
{
	mdl_input = self.m_a_mdl_inputs[n_index];
	for(i = 0; i < 10; i++)
	{
		mdl_input HidePart("J_" + i);
		mdl_input HidePart("j_keeper_" + i);
	}
	mdl_input ShowPart("j_keeper_" + n_value);
}

/*
	Name: set_input_number_visibility
	Namespace: cbeastcode
	Checksum: 0xF72C379E
	Offset: 0xD50
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function set_input_number_visibility(n_index, b_is_visible)
{
	if(b_is_visible)
	{
		self.m_a_mdl_inputs[n_index] show();
	}
	else
	{
		self.m_a_mdl_inputs[n_index] Hide();
	}
}

/*
	Name: update_clue_numbers_for_code
	Namespace: cbeastcode
	Checksum: 0x24BDB145
	Offset: 0xDC0
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function update_clue_numbers_for_code(n_index)
{
	if(!isdefined(n_index))
	{
		n_index = 0;
	}
	a_code = self.m_a_codes[n_index];
	for(i = 0; i < 3; i++)
	{
		mdl_clue_number = self.m_a_mdl_clues[n_index][i];
		for(j = 0; j < 10; j++)
		{
			mdl_clue_number HidePart("J_" + j);
			mdl_clue_number HidePart("p7_zm_zod_keepers_code_0" + j);
		}
		mdl_clue_number ShowPart("p7_zm_zod_keepers_code_0" + a_code[i]);
	}
}

/*
	Name: activate_input_device
	Namespace: cbeastcode
	Checksum: 0x72A1E1C9
	Offset: 0xEE8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function activate_input_device()
{
	self.var_71f130fa = self.var_71f130fa - 1;
	for(i = 0; i < self.m_a_codes.size; i++)
	{
		if(test_current_code_against_this_code(self.m_a_codes[i]))
		{
			playsoundatposition("zmb_zod_sword_symbol_right", (2624, -5104, -312));
			self.m_n_device_state = 3;
			hide_readout(1);
			[[self.m_a_funcs[i]]]();
			return;
		}
	}
	self.m_n_device_state = 4;
	self.m_n_input_index = 0;
	playsoundatposition("zmb_zod_sword_symbol_wrong", (2624, -5104, -312));
	if(self.var_71f130fa > 0)
	{
		hide_readout(1);
		wait(3);
		hide_readout(0);
		self.m_n_device_state = 1;
	}
	else
	{
		hide_readout(1);
	}
}

/*
	Name: test_current_code_against_this_code
	Namespace: cbeastcode
	Checksum: 0xFFA6DECE
	Offset: 0x1060
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function test_current_code_against_this_code(a_code)
{
	for(i = 0; i < a_code.size; i++)
	{
		if(!IsInArray(self.m_a_current, a_code[i]))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: create_code_input_unitrigger
	Namespace: cbeastcode
	Checksum: 0x41BF41ED
	Offset: 0x10C8
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function create_code_input_unitrigger()
{
	width = 128;
	height = 128;
	length = 128;
	m_mdl_input.unitrigger_stub = spawnstruct();
	m_mdl_input.unitrigger_stub.origin = m_mdl_input.origin;
	m_mdl_input.unitrigger_stub.angles = m_mdl_input.angles;
	m_mdl_input.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	m_mdl_input.unitrigger_stub.cursor_hint = "HINT_NOICON";
	m_mdl_input.unitrigger_stub.script_width = width;
	m_mdl_input.unitrigger_stub.script_height = height;
	m_mdl_input.unitrigger_stub.script_length = length;
	m_mdl_input.unitrigger_stub.require_look_at = 0;
	m_mdl_input.unitrigger_stub.o_keycode = self;
	m_mdl_input.unitrigger_stub.prompt_and_visibility_func = &keycode_input_visibility;
	zm_unitrigger::register_static_unitrigger(m_mdl_input.unitrigger_stub, &keycode_input_trigger_think);
}

/*
	Name: function_71154a2
	Namespace: cbeastcode
	Checksum: 0x78E69D39
	Offset: 0x1288
	Size: 0x251
	Parameters: 3
	Flags: None
*/
function function_71154a2(t_lookat, n_code_index, var_d7d7b586)
{
	s_focus = struct::get(t_lookat.target, "targetname");
	var_43544e59 = s_focus.origin;
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
				n_number = get_number_in_code(n_code_index, var_d7d7b586);
				player.var_ab153665 = player hud::createPrimaryProgressBarText();
				player.var_ab153665 setText("You sense the number " + n_number);
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
	Name: keycode_input_visibility
	Namespace: cbeastcode
	Checksum: 0xCF010192
	Offset: 0x14E8
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function keycode_input_visibility(player)
{
	b_is_invis = !isdefined(player.beastmode) && player.beastmode;
	self SetInvisibleToPlayer(player, b_is_invis);
	self thread keycode_input_prompt(player);
	return !b_is_invis;
}

/*
	Name: keycode_input_prompt
	Namespace: cbeastcode
	Checksum: 0xEAA53E1A
	Offset: 0x1570
	Size: 0x3B7
	Parameters: 1
	Flags: None
*/
function keycode_input_prompt(player)
{
	self endon("kill_trigger");
	player endon("death_or_disconnect");
	str_hint = &"";
	str_old_hint = &"";
	a_s_input_button_tags = get_tags_from_input_device();
	while(1)
	{
		n_state = get_keycode_device_state();
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
				player.n_keycode_lookat_tag = undefined;
				n_closest_dot = 0.996;
				v_eye_origin = player GetPlayerCameraPos();
				v_eye_direction = AnglesToForward(player getPlayerAngles());
				foreach(s_tag in a_s_input_button_tags)
				{
					v_tag_origin = s_tag.v_origin;
					v_eye_to_tag = VectorNormalize(v_tag_origin - v_eye_origin);
					n_dot = VectorDot(v_eye_to_tag, v_eye_direction);
					if(n_dot > n_closest_dot)
					{
						n_closest_dot = n_dot;
						player.n_keycode_lookat_tag = s_tag.n_index;
					}
				}
				if(!isdefined(player.n_keycode_lookat_tag))
				{
					str_hint = &"";
				}
				else if(player.n_keycode_lookat_tag < 3)
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
				self setHintString(self.stub.hint_string, player.n_keycode_lookat_tag + 1);
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
	Name: keycode_input_trigger_think
	Namespace: cbeastcode
	Checksum: 0xAD544E1C
	Offset: 0x1930
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function keycode_input_trigger_think(o_beastcode, n_index)
{
	while(1)
	{
		self waittill("trigger", player);
		if(o_beastcode.var_71f130fa <= 0)
		{
			continue;
		}
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!(isdefined(get_keycode_device_state()) && get_keycode_device_state()))
		{
			continue;
		}
		interpret_trigger_event(o_beastcode, player);
	}
}

/*
	Name: get_keycode_device_state
	Namespace: cbeastcode
	Checksum: 0xE6DE8CDE
	Offset: 0x19F0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_keycode_device_state()
{
	return self.m_n_device_state;
}

/*
	Name: interpret_trigger_event
	Namespace: cbeastcode
	Checksum: 0x59BB32F7
	Offset: 0x1A08
	Size: 0x7F
	Parameters: 2
	Flags: None
*/
function interpret_trigger_event(player, n_index)
{
	self.m_n_device_state = 0;
	hide_given_input(n_index);
	self.m_a_current[self.m_n_input_index] = n_index;
	self.m_n_input_index++;
	if(self.m_n_input_index == 3)
	{
		activate_input_device();
	}
	self.m_n_device_state = 1;
}

/*
	Name: __constructor
	Namespace: cbeastcode
	Checksum: 0x99EC1590
	Offset: 0x1A90
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: cbeastcode
	Checksum: 0x99EC1590
	Offset: 0x1AA0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace namespace_b361ecc3;

/*
	Name: cbeastcode
	Namespace: namespace_b361ecc3
	Checksum: 0x19B2D208
	Offset: 0x1AB0
	Size: 0x4D5
	Parameters: 0
	Flags: 6
*/
function private autoexec cbeastcode()
{
	classes.cbeastcode[0] = spawnstruct();
	classes.cbeastcode[0].__vtable[1606033458] = &cbeastcode::__destructor;
	classes.cbeastcode[0].__vtable[-1690805083] = &cbeastcode::__constructor;
	classes.cbeastcode[0].__vtable[-1216489112] = &cbeastcode::interpret_trigger_event;
	classes.cbeastcode[0].__vtable[944451507] = &cbeastcode::get_keycode_device_state;
	classes.cbeastcode[0].__vtable[-512443724] = &cbeastcode::keycode_input_trigger_think;
	classes.cbeastcode[0].__vtable[-796800951] = &cbeastcode::keycode_input_prompt;
	classes.cbeastcode[0].__vtable[2057128487] = &cbeastcode::keycode_input_visibility;
	classes.cbeastcode[0].__vtable[118576290] = &cbeastcode::function_71154a2;
	classes.cbeastcode[0].__vtable[-1756741377] = &cbeastcode::create_code_input_unitrigger;
	classes.cbeastcode[0].__vtable[-1458622884] = &cbeastcode::test_current_code_against_this_code;
	classes.cbeastcode[0].__vtable[-2036414264] = &cbeastcode::activate_input_device;
	classes.cbeastcode[0].__vtable[1708118895] = &cbeastcode::update_clue_numbers_for_code;
	classes.cbeastcode[0].__vtable[331517933] = &cbeastcode::set_input_number_visibility;
	classes.cbeastcode[0].__vtable[-728800686] = &cbeastcode::set_input_number;
	classes.cbeastcode[0].__vtable[918883813] = &cbeastcode::function_36c50de5;
	classes.cbeastcode[0].__vtable[1312398487] = &cbeastcode::setup_input_threads;
	classes.cbeastcode[0].__vtable[793415862] = &cbeastcode::hide_given_input;
	classes.cbeastcode[0].__vtable[1526896360] = &cbeastcode::hide_readout;
	classes.cbeastcode[0].__vtable[286081786] = &cbeastcode::set_clue_numbers_for_code;
	classes.cbeastcode[0].__vtable[-864585608] = &cbeastcode::add_code_function_pair;
	classes.cbeastcode[0].__vtable[1807435602] = &cbeastcode::generate_random_code;
	classes.cbeastcode[0].__vtable[289018454] = &cbeastcode::get_tags_from_input_device;
	classes.cbeastcode[0].__vtable[520023839] = &cbeastcode::get_number_in_code;
	classes.cbeastcode[0].__vtable[-962634851] = &cbeastcode::get_code;
	classes.cbeastcode[0].__vtable[-1017222485] = &cbeastcode::init;
}

