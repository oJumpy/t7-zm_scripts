#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace bgb_machine;

/*
	Name: __init__sytem__
	Namespace: bgb_machine
	Checksum: 0x88E3F9C8
	Offset: 0x540
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb_machine", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb_machine
	Checksum: 0xCF3111BF
	Offset: 0x588
	Size: 0x17B
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
	clientfield::register("zbarrier", "zm_bgb_machine", 1, 1, "int");
	clientfield::register("zbarrier", "zm_bgb_machine_selection", 1, 8, "int");
	clientfield::register("zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int");
	clientfield::register("zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int");
	clientfield::register("toplayer", "zm_bgb_machine_round_buys", 10000, 3, "int");
	level thread bgb_machine_host_migration();
	if(!isdefined(level.bgb_cost_client_filled))
	{
		level.bgb_cost_client_filled = 0;
	}
}

/*
	Name: __main__
	Namespace: bgb_machine
	Checksum: 0x8A8D9F59
	Offset: 0x710
	Size: 0x12B
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	if(!isdefined(level.bgb_machine_max_uses_per_round))
	{
		level.bgb_machine_max_uses_per_round = 3;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_a3e3127d))
	{
		level.var_a3e3127d = 2;
	}
	if(!isdefined(level.var_8ef45dc2))
	{
		level.var_8ef45dc2 = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	if(!isdefined(level.bgb_machine_count))
	{
		level.bgb_machine_count = 1000;
	}
	if(!isdefined(level.bgb_machine_never_move))
	{
		level.bgb_machine_never_move = 1;
	}
	if(!isdefined(level.bgb_machine_state_func))
	{
		level.bgb_machine_state_func = &process_bgb_machine_state;
	}
	/#
		level thread setup_devgui();
	#/
	level thread setup_bgb_machines();
}

/*
	Name: on_player_connect
	Namespace: bgb_machine
	Checksum: 0xAD8B048A
	Offset: 0x848
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private on_player_connect()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level thread bgb_machine_movement_frequency();
}

/*
	Name: on_player_disconnect
	Namespace: bgb_machine
	Checksum: 0x6935E52B
	Offset: 0x888
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private on_player_disconnect()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level thread bgb_machine_movement_frequency();
}

/*
	Name: setup_devgui
	Namespace: bgb_machine
	Checksum: 0xCC01B82C
	Offset: 0x8C8
	Size: 0x253
	Parameters: 0
	Flags: Private
*/
function private setup_devgui()
{
	/#
		waittillframeend;
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		bgb_devgui_base = "Dev Block strings are not supported";
		AddDebugCommand(bgb_devgui_base + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		keys = getArrayKeys(level.bgb);
		for(i = 0; i < keys.size; i++)
		{
			AddDebugCommand(bgb_devgui_base + "Dev Block strings are not supported" + keys[i] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + keys[i] + "Dev Block strings are not supported");
		}
		AddDebugCommand(bgb_devgui_base + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(bgb_devgui_base + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(bgb_devgui_base + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(bgb_devgui_base + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		level thread bgb_machine_devgui_think();
	#/
}

/*
	Name: bgb_machine_devgui_think
	Namespace: bgb_machine
	Checksum: 0x71FB99E9
	Offset: 0xB28
	Size: 0x3A7
	Parameters: 0
	Flags: Private
*/
function private bgb_machine_devgui_think()
{
	/#
		for(;;)
		{
			ARRIVE = GetDvarInt("Dev Block strings are not supported");
			move = GetDvarInt("Dev Block strings are not supported");
			if(move || ARRIVE)
			{
				pos = level.players[0].origin;
				best_dist_sq = 999999999;
				best_index = -1;
				for(i = 0; i < level.bgb_machines.size; i++)
				{
					new_dist_sq = DistanceSquared(pos, level.bgb_machines[i].origin);
					if(new_dist_sq < best_dist_sq)
					{
						best_index = i;
						best_dist_sq = new_dist_sq;
					}
				}
				if(0 <= best_index)
				{
					if(ARRIVE)
					{
						if(!level.bgb_machines[best_index].current_bgb_machine)
						{
							for(i = 0; i < level.bgb_machines.size; i++)
							{
								if(level.bgb_machines[i].current_bgb_machine)
								{
									level.bgb_machines[i] thread hide_bgb_machine();
									break;
								}
							}
							level.bgb_machines[best_index].current_bgb_machine = 1;
							level.bgb_machines[best_index] thread show_bgb_machine();
						}
					}
					else
					{
						level.bgb_machines[best_index] thread bgb_machine_move();
					}
				}
				SetDvar("Dev Block strings are not supported", 0);
				SetDvar("Dev Block strings are not supported", 0);
			}
			force_give = GetDvarString("Dev Block strings are not supported");
			if(GetDvarInt("Dev Block strings are not supported") || "Dev Block strings are not supported" != force_give)
			{
				for(i = 0; i < level.players.size; i++)
				{
					level.players[i].bgb_machine_uses_this_round = 0;
					level.players[i] clientfield::set_to_player("Dev Block strings are not supported", level.players[i].bgb_machine_uses_this_round);
				}
				SetDvar("Dev Block strings are not supported", 0);
			}
			if("Dev Block strings are not supported" != force_give)
			{
				level.bgb_machine_force_give = force_give;
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: setup_bgb_machines
	Namespace: bgb_machine
	Checksum: 0xA7B45725
	Offset: 0xED8
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private setup_bgb_machines()
{
	waittillframeend;
	level.bgb_machines = GetEntArray("bgb_machine_use", "targetname");
	bgb_machine_init();
}

/*
	Name: bgb_machine_init
	Namespace: bgb_machine
	Checksum: 0xE939DD37
	Offset: 0xF20
	Size: 0x1F3
	Parameters: 0
	Flags: Private
*/
function private bgb_machine_init()
{
	if(!level.bgb_machines.size)
	{
		return;
	}
	for(i = 0; i < level.bgb_machines.size; i++)
	{
		if(!isdefined(level.bgb_machines[i].base_cost))
		{
			level.bgb_machines[i].base_cost = 500;
		}
		level.bgb_machines[i].old_cost = level.bgb_machines[i].base_cost;
		level.bgb_machines[i].current_bgb_machine = 0;
		level.bgb_machines[i].uses_at_current_location = 0;
		level.bgb_machines[i] create_bgb_machine_unitrigger_stub();
	}
	if(!level.enable_magic)
	{
		foreach(bgb_machine in level.bgb_machines)
		{
			bgb_machine thread hide_bgb_machine();
		}
		return;
	}
	level.bgb_machines = Array::randomize(level.bgb_machines);
	init_starting_bgb_machine_location();
	Array::thread_all(level.bgb_machines, &bgb_machine_think);
}

/*
	Name: init_starting_bgb_machine_location
	Namespace: bgb_machine
	Checksum: 0xC5B5EBC5
	Offset: 0x1120
	Size: 0x213
	Parameters: 0
	Flags: Private
*/
function private init_starting_bgb_machine_location()
{
	start_bgb_machine_found = 0;
	bgb_machines_to_hide = [];
	for(i = 0; i < level.bgb_machines.size; i++)
	{
		level.bgb_machines[i] clientfield::set("zm_bgb_machine", 1);
		if(start_bgb_machine_found >= level.bgb_machine_count || !isdefined(level.bgb_machines[i].script_noteworthy) || !IsSubStr(level.bgb_machines[i].script_noteworthy, "start_bgb_machine"))
		{
			bgb_machines_to_hide[bgb_machines_to_hide.size] = level.bgb_machines[i];
			continue;
		}
		level.bgb_machines[i].hidden = 0;
		level.bgb_machines[i].current_bgb_machine = 1;
		level.bgb_machines[i] set_bgb_machine_state("initial");
		start_bgb_machine_found++;
	}
	for(i = 0; i < bgb_machines_to_hide.size; i++)
	{
		if(start_bgb_machine_found >= level.bgb_machine_count)
		{
			bgb_machines_to_hide[i] thread hide_bgb_machine();
			continue;
		}
		bgb_machines_to_hide[i].hidden = 0;
		bgb_machines_to_hide[i].current_bgb_machine = 1;
		bgb_machines_to_hide[i] set_bgb_machine_state("initial");
		start_bgb_machine_found++;
	}
}

/*
	Name: create_bgb_machine_unitrigger_stub
	Namespace: bgb_machine
	Checksum: 0xD9B7226F
	Offset: 0x1340
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function create_bgb_machine_unitrigger_stub()
{
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.script_width = 30;
	self.unitrigger_stub.script_height = 70;
	self.unitrigger_stub.script_length = 25;
	self.unitrigger_stub.origin = self.origin + AnglesToRight(self.angles) * self.unitrigger_stub.script_length + anglesToUp(self.angles) * self.unitrigger_stub.script_height / 2;
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.trigger_target = self;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.unitrigger_stub, 1);
	self.unitrigger_stub.prompt_and_visibility_func = &bgb_machine_trigger_update_prompt;
}

/*
	Name: bgb_machine_trigger_update_prompt
	Namespace: bgb_machine
	Checksum: 0x664AA04F
	Offset: 0x1490
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function bgb_machine_trigger_update_prompt(player)
{
	can_use = self bgb_machine_stub_update_prompt(player);
	if(isdefined(self.hint_string))
	{
		if(isdefined(self.hint_parm1))
		{
			self setHintString(self.hint_string, self.hint_parm1);
		}
		else
		{
			self setHintString(self.hint_string);
		}
	}
	return can_use;
}

/*
	Name: bgb_machine_calc_player_cost
	Namespace: bgb_machine
	Checksum: 0xC25EA1F0
	Offset: 0x1528
	Size: 0x1C7
	Parameters: 2
	Flags: None
*/
function bgb_machine_calc_player_cost(player, base_cost)
{
	if(player.bgb_machine_uses_this_round < 1 && GetDvarInt("scr_firstGumFree") === 1)
	{
		return 0;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	cost = 500;
	if(player.bgb_machine_uses_this_round >= 1)
	{
		var_33ea806b = floor(level.round_number / level.var_e1dee7ba);
		var_33ea806b = math::clamp(var_33ea806b, 0, level.var_8ef45dc2);
		var_39a90c5a = pow(level.var_a3e3127d, var_33ea806b);
		cost = cost + level.var_f02c5598 * var_39a90c5a;
	}
	if(player.bgb_machine_uses_this_round >= 2)
	{
		cost = cost * level.var_1485dcdc;
	}
	cost = Int(cost);
	if(500 != base_cost)
	{
		cost = cost - 500 - base_cost;
	}
	return cost;
}

/*
	Name: bgb_machine_stub_update_prompt
	Namespace: bgb_machine
	Checksum: 0xBC9C007E
	Offset: 0x16F8
	Size: 0x247
	Parameters: 1
	Flags: None
*/
function bgb_machine_stub_update_prompt(player)
{
	b_result = 0;
	if(!self trigger_visible_to_player(player))
	{
		return b_result;
	}
	self.hint_parm1 = undefined;
	if(isdefined(self.stub.trigger_target.grab_bgb_hint) && self.stub.trigger_target.grab_bgb_hint)
	{
		if(!(isdefined(self.stub.trigger_target.b_bgb_is_available) && self.stub.trigger_target.b_bgb_is_available))
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OUT_OF";
			b_result = 0;
		}
		else
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OFFERING";
			b_result = 1;
		}
		cursor_hint = "HINT_BGB";
		cursor_hint_bgb = level.bgb[self.stub.trigger_target.selected_bgb].item_index;
		self setcursorhint(cursor_hint, cursor_hint_bgb);
		self.hint_string = str_hint;
	}
	else
	{
		self setcursorhint("HINT_NOICON");
		if(player.bgb_machine_uses_this_round < level.bgb_machine_max_uses_per_round)
		{
			if(isdefined(level.bgb_cost_client_filled) && level.bgb_cost_client_filled)
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE_CFILL";
			}
			else
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE";
				self.hint_parm1 = bgb_machine_calc_player_cost(player, self.stub.trigger_target.base_cost);
			}
			b_result = 1;
		}
		else
		{
			self.hint_string = &"ZOMBIE_BGB_MACHINE_COMEBACK";
			b_result = 0;
		}
	}
	return b_result;
}

/*
	Name: trigger_visible_to_player
	Namespace: bgb_machine
	Checksum: 0x189F1957
	Offset: 0x1948
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function trigger_visible_to_player(player)
{
	self SetInvisibleToPlayer(player);
	visible = 1;
	if(!player zm_magicbox::can_buy_weapon())
	{
		visible = 0;
	}
	if(!visible)
	{
		return 0;
	}
	if(isdefined(self.stub.trigger_target.bgb_machine_user) && player !== self.stub.trigger_target.bgb_machine_user)
	{
		return 0;
	}
	self SetVisibleToPlayer(player);
	return 1;
}

/*
	Name: bgb_machine_unitrigger_think
	Namespace: bgb_machine
	Checksum: 0x346BA220
	Offset: 0x1A10
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function bgb_machine_unitrigger_think()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", player);
		self.stub.trigger_target notify("trigger", player);
	}
}

/*
	Name: show_bgb_machine
	Namespace: bgb_machine
	Checksum: 0xA993BA4C
	Offset: 0x1A70
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function show_bgb_machine()
{
	self set_bgb_machine_state("arriving");
	self waittill("arrived");
	self.hidden = 0;
}

/*
	Name: hide_bgb_machine
	Namespace: bgb_machine
	Checksum: 0xA81C74FE
	Offset: 0x1AB8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function hide_bgb_machine(do_bgb_machine_leave)
{
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.hidden = 1;
	self.uses_at_current_location = 0;
	self.current_bgb_machine = 0;
	if(isdefined(do_bgb_machine_leave) && do_bgb_machine_leave)
	{
		self thread set_bgb_machine_state("leaving");
	}
	else
	{
		self thread set_bgb_machine_state("away");
	}
}

/*
	Name: bgb_machine_select_bgb
	Namespace: bgb_machine
	Checksum: 0xBCCB4055
	Offset: 0x1B60
	Size: 0x1C9
	Parameters: 1
	Flags: Private
*/
function private bgb_machine_select_bgb(player)
{
	if(!player.bgb_pack_randomized.size)
	{
		player.bgb_pack_randomized = Array::randomize(player.bgb_pack);
	}
	self.selected_bgb = Array::pop_front(player.bgb_pack_randomized);
	/#
		if(isdefined(level.bgb_machine_force_give))
		{
			self.selected_bgb = level.bgb_machine_force_give;
			level.bgb_machine_force_give = undefined;
			if("Dev Block strings are not supported" == self.selected_bgb)
			{
				keys = Array::randomize(getArrayKeys(level.bgb));
				for(i = 0; i < keys.size; i++)
				{
					if(level.bgb[keys[i]].consumable)
					{
						self.selected_bgb = keys[i];
						break;
					}
				}
				clientfield::set("Dev Block strings are not supported", level.bgb[self.selected_bgb].item_index);
				return 0;
			}
		}
	#/
	clientfield::set("zm_bgb_machine_selection", level.bgb[self.selected_bgb].item_index);
	return player bgb::get_bgb_available(self.selected_bgb);
}

/*
	Name: bgb_machine_think
	Namespace: bgb_machine
	Checksum: 0x29F0CC66
	Offset: 0x1D38
	Size: 0xA1B
	Parameters: 0
	Flags: None
*/
function bgb_machine_think()
{
	var_9bbdff4d = -1;
	while(1)
	{
		var_5e7af4df = undefined;
		self waittill("trigger", User);
		var_9bbdff4d = -1;
		if(isdefined(User.bgb) && isdefined(level.bgb[User.bgb]))
		{
			var_9bbdff4d = level.bgb[User.bgb].item_index;
		}
		var_5e7af4df = GetTime();
		if(User == level)
		{
			continue;
		}
		if(User zm_utility::in_revive_trigger())
		{
			wait(0.1);
			continue;
		}
		if(User.IS_DRINKING > 0)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.disabled) && self.disabled)
		{
			wait(0.1);
			continue;
		}
		if(User GetCurrentWeapon() == level.weaponNone)
		{
			wait(0.1);
			continue;
		}
		var_625e97d1 = 0;
		cost = bgb_machine_calc_player_cost(User, self.base_cost);
		if(zm_utility::is_player_valid(User) && User zm_score::can_player_purchase(cost))
		{
			User zm_score::minus_to_player_score(cost);
			self.bgb_machine_user = User;
			self.current_cost = cost;
			if(User bgb::is_enabled("zm_bgb_shopping_free"))
			{
				var_625e97d1 = 1;
			}
			break;
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			User zm_audio::create_and_play_dialog("general", "outofmoney");
			continue;
		}
		wait(0.05);
	}
	if(isdefined(level.bgb_machine_used_vo))
	{
		User thread [[level.bgb_machine_used_vo]]();
	}
	User.bgb_machine_uses_this_round++;
	User clientfield::set_to_player("zm_bgb_machine_round_buys", User.bgb_machine_uses_this_round);
	self.bgb_machine_user = User;
	self.bgb_machine_open = 1;
	self.bgb_machine_opened_by_fire_sale = 0;
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.bgb_machine_opened_by_fire_sale = 1;
	}
	else
	{
		self.uses_at_current_location++;
	}
	self.b_bgb_is_available = self thread bgb_machine_select_bgb(User);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self set_bgb_machine_state("open");
	self waittill("gumball_available");
	self.grab_bgb_hint = 1;
	self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &bgb_machine_unitrigger_think);
	gumballtaken = 0;
	gumballoffered = 0;
	var_8a2037cd = 0;
	if(self.b_bgb_is_available)
	{
		bb::logpurchaseevent(User, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_offered");
		if(isdefined(level.bgb[self.selected_bgb]))
		{
			gumballoffered = level.bgb[self.selected_bgb].item_index;
		}
		while(1)
		{
			self waittill("trigger", grabber);
			if(isdefined(grabber.IS_DRINKING) && grabber.IS_DRINKING > 0)
			{
				wait(0.1);
				continue;
			}
			if(grabber == User && User GetCurrentWeapon() == level.weaponNone)
			{
				wait(0.1);
				continue;
			}
			if(grabber == User || grabber == level)
			{
				current_weapon = level.weaponNone;
				if(zm_utility::is_player_valid(User))
				{
					current_weapon = User GetCurrentWeapon();
				}
				if(grabber == User && zm_utility::is_player_valid(User) && !User.IS_DRINKING > 0 && !zm_utility::is_placeable_mine(current_weapon) && !zm_equipment::is_equipment(current_weapon) && !User zm_utility::is_player_revive_tool(current_weapon) && !current_weapon.isHeroWeapon && !current_weapon.isgadget)
				{
					self notify("user_grabbed_bgb");
					User notify("user_grabbed_bgb");
					bb::logpurchaseevent(User, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_grabbed");
					User RecordMapEvent(3, GetTime(), User.origin, level.round_number, var_9bbdff4d, gumballoffered);
					User __protected__notelootconsume(self.selected_bgb, 1);
					User bgb::sub_consumable_bgb(self.selected_bgb);
					gumballtaken = 1;
					__protected__setbgbunlocked(1);
					User thread bgb::bgb_gumball_anim(self.selected_bgb, 0);
					__protected__setbgbunlocked(0);
					if(isdefined(level.var_361ee139))
					{
						User thread [[level.var_361ee139]](self);
					}
					else
					{
						User thread function_acf1c4da(self);
					}
					User zm_stats::increment_challenge_stat("ZM_DAILY_EAT_GOBBLEGUM");
					break;
				}
				else if(grabber == level)
				{
					bb::logpurchaseevent(User, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_returned");
					break;
				}
			}
			wait(0.05);
		}
		if(grabber == User)
		{
			self set_bgb_machine_state("close");
			self waittill("closed");
		}
	}
	else
	{
		self waittill("trigger");
		bb::logpurchaseevent(User, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_ghostball");
		if(!var_625e97d1)
		{
			User zm_score::add_to_player_score(self.current_cost, 0, "bgb_machine_ghost_ball");
		}
		var_8a2037cd = 1;
	}
	User recordzombiegumballevent(var_5e7af4df, self.origin, gumballoffered, var_9bbdff4d, gumballtaken, var_8a2037cd, self.bgb_machine_opened_by_fire_sale);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.grab_bgb_hint = 0;
	wait(1);
	if(bgb_machine_should_move())
	{
		self thread bgb_machine_move();
	}
	else if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"] || self.current_bgb_machine)
	{
		self thread set_bgb_machine_state("initial");
	}
	self.bgb_machine_open = 0;
	self.bgb_machine_opened_by_fire_sale = 0;
	self.bgb_machine_user = undefined;
	self notify("bgb_machine_accessed");
	self thread bgb_machine_think();
}

/*
	Name: bgb_machine_should_move
	Namespace: bgb_machine
	Checksum: 0x1913383E
	Offset: 0x2760
	Size: 0xA3
	Parameters: 0
	Flags: Private
*/
function private bgb_machine_should_move()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			return 0;
		}
	#/
	if(isdefined(level.bgb_machine_never_move) && level.bgb_machine_never_move)
	{
		return 0;
	}
	if(self.uses_at_current_location >= level.bgb_machine_max_uses_before_move)
	{
		return 1;
	}
	if(self.uses_at_current_location < level.bgb_machine_min_uses_before_move)
	{
		return 0;
	}
	if(RandomInt(100) < 30)
	{
		return 1;
	}
	return 0;
}

/*
	Name: bgb_machine_movement_frequency
	Namespace: bgb_machine
	Checksum: 0x7584FCB8
	Offset: 0x2810
	Size: 0xC9
	Parameters: 0
	Flags: Private
*/
function private bgb_machine_movement_frequency()
{
	if(isdefined(level.bgb_machine_movement_frequency_override_func))
	{
		[[level.bgb_machine_movement_frequency_override_func]]();
		return;
	}
	switch(level.players.size)
	{
		case 1:
		{
			level.bgb_machine_min_uses_before_move = 1;
			level.bgb_machine_max_uses_before_move = 3;
			break;
		}
		case 2:
		{
			level.bgb_machine_min_uses_before_move = 1;
			level.bgb_machine_max_uses_before_move = 4;
			break;
		}
		case 3:
		{
			level.bgb_machine_min_uses_before_move = 3;
			level.bgb_machine_max_uses_before_move = 5;
			break;
		}
		case 4:
		{
			level.bgb_machine_min_uses_before_move = 3;
			level.bgb_machine_max_uses_before_move = 6;
			break;
		}
	}
}

/*
	Name: turn_on_fire_sale
	Namespace: bgb_machine
	Checksum: 0x2E12BC0B
	Offset: 0x28E8
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function turn_on_fire_sale()
{
	for(i = 0; i < level.bgb_machines.size; i++)
	{
		level.bgb_machines[i].old_cost = level.bgb_machines[i].base_cost;
		level.bgb_machines[i].base_cost = 10;
		if(!level.bgb_machines[i].current_bgb_machine)
		{
			level.bgb_machines[i].was_fire_sale_temp = 1;
			level.bgb_machines[i] thread show_bgb_machine();
		}
	}
}

/*
	Name: turn_off_fire_sale
	Namespace: bgb_machine
	Checksum: 0xDD5B9175
	Offset: 0x29C8
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function turn_off_fire_sale()
{
	for(i = 0; i < level.bgb_machines.size; i++)
	{
		level.bgb_machines[i].base_cost = level.bgb_machines[i].old_cost;
		if(!level.bgb_machines[i].current_bgb_machine && (isdefined(level.bgb_machines[i].was_fire_sale_temp) && level.bgb_machines[i].was_fire_sale_temp))
		{
			level.bgb_machines[i].was_fire_sale_temp = undefined;
			level.bgb_machines[i] thread remove_temp_machine();
		}
	}
}

/*
	Name: remove_temp_machine
	Namespace: bgb_machine
	Checksum: 0xF0DCDE0F
	Offset: 0x2AC0
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private remove_temp_machine()
{
	while(isdefined(self.bgb_machine_user) || (isdefined(self.bgb_machine_open) && self.bgb_machine_open))
	{
		util::wait_network_frame();
	}
	if(level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.was_fire_sale_temp = 1;
		self.base_cost = 10;
		return;
	}
	self thread hide_bgb_machine(1);
}

/*
	Name: bgb_machine_move
	Namespace: bgb_machine
	Checksum: 0xAEED0965
	Offset: 0x2B50
	Size: 0x1F1
	Parameters: 0
	Flags: None
*/
function bgb_machine_move()
{
	self hide_bgb_machine(1);
	wait(0.1);
	post_selection_wait_duration = 7;
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		current_sale_time = level.zombie_vars["zombie_powerup_fire_sale_time"];
		util::wait_network_frame();
		self thread fire_sale_fix();
		level.zombie_vars["zombie_powerup_fire_sale_time"] = current_sale_time;
		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}
	}
	else
	{
		post_selection_wait_duration = post_selection_wait_duration + 5;
	}
	wait(post_selection_wait_duration);
	keys = getArrayKeys(level.bgb_machines);
	keys = Array::randomize(keys);
	for(i = 0; i < keys.size; i++)
	{
		if(self == level.bgb_machines[keys[i]] || level.bgb_machines[keys[i]].current_bgb_machine)
		{
			continue;
		}
		level.bgb_machines[keys[i]].current_bgb_machine = 1;
		level.bgb_machines[keys[i]] show_bgb_machine();
		break;
	}
}

/*
	Name: fire_sale_fix
	Namespace: bgb_machine
	Checksum: 0x47B2B5CE
	Offset: 0x2D50
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function fire_sale_fix()
{
	if(!isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]))
	{
		return;
	}
	self.old_cost = self.base_cost;
	self thread show_bgb_machine();
	self.base_cost = 10;
	util::wait_network_frame();
	level waittill("fire_sale_off");
	while(isdefined(self.bgb_machine_open) && self.bgb_machine_open)
	{
		wait(0.1);
	}
	self thread hide_bgb_machine(1);
	self.base_cost = self.old_cost;
}

/*
	Name: bgb_machine_lion_twitches
	Namespace: bgb_machine
	Checksum: 0xDEC16793
	Offset: 0x2E18
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function bgb_machine_lion_twitches()
{
	self endon("zbarrier_state_change");
	clientfield::set("zm_bgb_machine_fx_state", 1);
	self SetZBarrierPieceState(0, "closed");
	self SetZBarrierPieceState(5, "closed");
	while(1)
	{
		wait(RandomFloatRange(180, 1800));
		self SetZBarrierPieceState(0, "opening");
		wait(RandomFloatRange(180, 1800));
		self SetZBarrierPieceState(0, "closing");
	}
}

/*
	Name: bgb_machine_initial
	Namespace: bgb_machine
	Checksum: 0x34A4D46A
	Offset: 0x2F08
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function bgb_machine_initial()
{
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self SetZBarrierPieceState(2, "open");
	self SetZBarrierPieceState(3, "open");
	self SetZBarrierPieceState(5, "closed");
}

/*
	Name: bgb_machine_arrives
	Namespace: bgb_machine
	Checksum: 0xFF4549D8
	Offset: 0x2F98
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function bgb_machine_arrives()
{
	self endon("zbarrier_state_change");
	self SetZBarrierPieceState(3, "closed");
	clientfield::set("zm_bgb_machine_fx_state", 2);
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait(0.05);
	}
	self SetZBarrierPieceState(1, "closing");
	self SetZBarrierPieceState(3, "opening");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait(0.05);
	}
	self notify("arrived");
	self thread set_bgb_machine_state("initial");
}

/*
	Name: bgb_machine_leaves
	Namespace: bgb_machine
	Checksum: 0x66B60AEB
	Offset: 0x30D8
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function bgb_machine_leaves()
{
	self endon("zbarrier_state_change");
	self SetZBarrierPieceState(3, "open");
	clientfield::set("zm_bgb_machine_fx_state", 2);
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait(0.05);
	}
	self SetZBarrierPieceState(1, "closing");
	self SetZBarrierPieceState(3, "closing");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait(0.05);
	}
	self notify("left");
	self thread set_bgb_machine_state("away");
}

/*
	Name: bgb_machine_opens
	Namespace: bgb_machine
	Checksum: 0x5D71BA03
	Offset: 0x3218
	Size: 0x1C9
	Parameters: 0
	Flags: None
*/
function bgb_machine_opens()
{
	self endon("zbarrier_state_change");
	self SetZBarrierPieceState(3, "open");
	self SetZBarrierPieceState(5, "closed");
	clientfield::set("zm_bgb_machine_ghost_ball", !self.b_bgb_is_available);
	State = "opening";
	if(math::cointoss())
	{
		State = "closing";
	}
	self SetZBarrierPieceState(4, State);
	while(self GetZBarrierPieceState(4) == State)
	{
		wait(0.05);
	}
	self SetZBarrierPieceState(2, "opening");
	wait(1);
	clientfield::set("zm_bgb_machine_fx_state", 3);
	self notify("gumball_available");
	wait(5.5);
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait(0.05);
	}
	self notify("trigger", level);
}

/*
	Name: bgb_machine_closes
	Namespace: bgb_machine
	Checksum: 0xA3177C7
	Offset: 0x33F0
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function bgb_machine_closes()
{
	self endon("zbarrier_state_change");
	self SetZBarrierPieceState(3, "open");
	self SetZBarrierPieceState(5, "closed");
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self SetZBarrierPieceState(2, "closing");
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait(0.05);
	}
	self notify("closed");
}

/*
	Name: is_bgb_machine_active
	Namespace: bgb_machine
	Checksum: 0x33CC9153
	Offset: 0x34C8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function is_bgb_machine_active()
{
	curr_state = self get_bgb_machine_state();
	if(curr_state == "open" || curr_state == "close")
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_bgb_machine_state
	Namespace: bgb_machine
	Checksum: 0x87E5FA36
	Offset: 0x3520
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_bgb_machine_state()
{
	return self.State;
}

/*
	Name: set_bgb_machine_state
	Namespace: bgb_machine
	Checksum: 0xA4F5D29A
	Offset: 0x3538
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function set_bgb_machine_state(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	self [[level.bgb_machine_state_func]](State);
}

/*
	Name: process_bgb_machine_state
	Namespace: bgb_machine
	Checksum: 0x73DAF883
	Offset: 0x35C0
	Size: 0x339
	Parameters: 1
	Flags: None
*/
function process_bgb_machine_state(State)
{
	switch(State)
	{
		case "away":
		{
			self ShowZBarrierPiece(0);
			self ShowZBarrierPiece(5);
			self thread bgb_machine_lion_twitches();
			self.State = "away";
			break;
		}
		case "arriving":
		{
			self ShowZBarrierPiece(1);
			self ShowZBarrierPiece(3);
			self thread bgb_machine_arrives();
			self.State = "arriving";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(2);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(5);
			self thread bgb_machine_initial();
			self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &bgb_machine_unitrigger_think);
			self.State = "initial";
			break;
		}
		case "open":
		{
			self ShowZBarrierPiece(2);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(4);
			self ShowZBarrierPiece(5);
			self thread bgb_machine_opens();
			self.State = "open";
			break;
		}
		case "close":
		{
			self ShowZBarrierPiece(2);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(5);
			self thread bgb_machine_closes();
			self.State = "close";
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self ShowZBarrierPiece(3);
			self thread bgb_machine_leaves();
			self.State = "leaving";
			break;
		}
		case default:
		{
			if(isdefined(level.custom_bgb_machine_state_handler))
			{
				self [[level.custom_bgb_machine_state_handler]](State);
			}
			break;
		}
	}
}

/*
	Name: bgb_machine_host_migration
	Namespace: bgb_machine
	Checksum: 0xB0454634
	Offset: 0x3908
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function bgb_machine_host_migration()
{
	level endon("end_game");
	level notify("bgb_machine_host_migration");
	level endon("bgb_machine_host_migration");
	while(1)
	{
		level waittill("host_migration_end");
		if(!isdefined(level.bgb_machines))
		{
			continue;
		}
		foreach(bgb_machine in level.bgb_machines)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_acf1c4da
	Namespace: bgb_machine
	Checksum: 0xBE0ED8CB
	Offset: 0x3A08
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_acf1c4da(machine)
{
	if(isdefined(level.bgb[machine.selected_bgb]) && level.bgb[machine.selected_bgb].limit_type == "activated")
	{
		self zm_audio::create_and_play_dialog("bgb", "buy");
	}
	else
	{
		self zm_audio::create_and_play_dialog("bgb", "eat");
	}
}

