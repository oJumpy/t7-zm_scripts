#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_744abc1c;

/*
	Name: create_unitrigger
	Namespace: namespace_744abc1c
	Checksum: 0x69792900
	Offset: 0x180
	Size: 0x15B
	Parameters: 4
	Flags: None
*/
function create_unitrigger(str_hint, n_radius, func_prompt_and_visibility, func_unitrigger_logic)
{
	if(!isdefined(n_radius))
	{
		n_radius = 64;
	}
	if(!isdefined(func_prompt_and_visibility))
	{
		func_prompt_and_visibility = &unitrigger_prompt_and_visibility;
	}
	if(!isdefined(func_unitrigger_logic))
	{
		func_unitrigger_logic = &unitrigger_logic;
	}
	s_unitrigger = spawnstruct();
	s_unitrigger.origin = self.origin;
	s_unitrigger.angles = self.angles;
	s_unitrigger.script_unitrigger_type = "unitrigger_radius_use";
	s_unitrigger.cursor_hint = "HINT_NOICON";
	s_unitrigger.hint_string = str_hint;
	s_unitrigger.prompt_and_visibility_func = func_prompt_and_visibility;
	s_unitrigger.related_parent = self;
	s_unitrigger.radius = n_radius;
	self.s_unitrigger = s_unitrigger;
	zm_unitrigger::register_static_unitrigger(s_unitrigger, func_unitrigger_logic);
}

/*
	Name: unitrigger_prompt_and_visibility
	Namespace: namespace_744abc1c
	Checksum: 0x9C33223
	Offset: 0x2E8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function unitrigger_prompt_and_visibility(player)
{
	b_visible = 1;
	return b_visible;
}

/*
	Name: unitrigger_logic
	Namespace: namespace_744abc1c
	Checksum: 0x24B3B4A0
	Offset: 0x318
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function unitrigger_logic()
{
	self endon("death");
	while(1)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		if(isdefined(self.stub.related_parent))
		{
			self.stub.related_parent notify("trigger_activated", player);
		}
	}
}

/*
	Name: function_fa7da172
	Namespace: namespace_744abc1c
	Checksum: 0xAC5E3585
	Offset: 0x3E0
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function function_fa7da172()
{
	self endon("death");
	var_82a4f07b = struct::get("keeper_end_loc");
	var_77b9bd02 = 0;
	while(isdefined(level.var_8ef26cd9) && level.var_8ef26cd9)
	{
		str_player_zone = self zm_zonemgr::get_player_zone();
		if(zm_utility::is_player_valid(self) && str_player_zone === "zone_undercroft")
		{
			if(!isdefined(var_77b9bd02) && var_77b9bd02 && Distance2DSquared(var_82a4f07b.origin, self.origin) <= 53361)
			{
				self clientfield::set_to_player("gravity_trap_rumble", 1);
				var_77b9bd02 = 1;
			}
			else if(isdefined(var_77b9bd02) && var_77b9bd02 && Distance2DSquared(var_82a4f07b.origin, self.origin) > 53361)
			{
				self clientfield::set_to_player("gravity_trap_rumble", 0);
				var_77b9bd02 = 0;
			}
		}
		else if(isdefined(var_77b9bd02) && var_77b9bd02)
		{
			self clientfield::set_to_player("gravity_trap_rumble", 0);
			var_77b9bd02 = 0;
		}
		wait(0.15);
	}
	self clientfield::set_to_player("gravity_trap_rumble", 0);
}

/*
	Name: function_8faf1d24
	Namespace: namespace_744abc1c
	Checksum: 0xC51FADF6
	Offset: 0x5E0
	Size: 0x107
	Parameters: 4
	Flags: None
*/
function function_8faf1d24(v_color, var_8882142e, n_scale, str_endon)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = VectorScale((0, 0, 1), 255);
		}
		if(!isdefined(var_8882142e))
		{
			var_8882142e = "Dev Block strings are not supported";
		}
		if(!isdefined(n_scale))
		{
			n_scale = 0.25;
		}
		if(!isdefined(str_endon))
		{
			str_endon = "Dev Block strings are not supported";
		}
		if(GetDvarInt("Dev Block strings are not supported") == 0)
		{
			return;
		}
		if(isdefined(str_endon))
		{
			self endon(str_endon);
		}
		origin = self.origin;
		while(1)
		{
			print3d(origin, var_8882142e, v_color, n_scale);
			wait(0.1);
		}
	#/
}

/*
	Name: setup_devgui_func
	Namespace: namespace_744abc1c
	Checksum: 0xD3574411
	Offset: 0x6F0
	Size: 0x11F
	Parameters: 5
	Flags: None
*/
function setup_devgui_func(str_devgui_path, str_dvar, n_value, func, n_base_value)
{
	/#
		if(!isdefined(n_base_value))
		{
			n_base_value = -1;
		}
		SetDvar(str_dvar, n_base_value);
		AddDebugCommand("Dev Block strings are not supported" + str_devgui_path + "Dev Block strings are not supported" + str_dvar + "Dev Block strings are not supported" + n_value + "Dev Block strings are not supported");
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
	#/
}

