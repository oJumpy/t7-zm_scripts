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
	level thread function_4fb7632c();
	if(!isdefined(level.var_42792b8b))
	{
		level.var_42792b8b = 0;
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
	if(!isdefined(level.var_6cb6a683))
	{
		level.var_6cb6a683 = 3;
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
	if(!isdefined(level.var_d776839c))
	{
		level.var_d776839c = 1000;
	}
	if(!isdefined(level.var_d453a2ed))
	{
		level.var_d453a2ed = 1;
	}
	if(!isdefined(level.var_cc480293))
	{
		level.var_cc480293 = &function_cffffa44;
	}
	/#
		level thread setup_devgui();
	#/
	level thread function_8115371();
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
	level thread function_d83737d3();
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
	level thread function_d83737d3();
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
		var_33b4e7c1 = "Dev Block strings are not supported";
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		keys = getArrayKeys(level.bgb);
		for(i = 0; i < keys.size; i++)
		{
			AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + keys[i] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + keys[i] + "Dev Block strings are not supported");
		}
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		level thread function_95dc1528();
	#/
}

/*
	Name: function_95dc1528
	Namespace: bgb_machine
	Checksum: 0x71FB99E9
	Offset: 0xB28
	Size: 0x3A7
	Parameters: 0
	Flags: Private
*/
function private function_95dc1528()
{
	/#
		for(;;)
		{
			ARRIVE = GetDvarInt("Dev Block strings are not supported");
			move = GetDvarInt("Dev Block strings are not supported");
			if(move || ARRIVE)
			{
				pos = level.players[0].origin;
				var_7ee3aad9 = 999999999;
				best_index = -1;
				for(i = 0; i < level.var_5081bd63.size; i++)
				{
					var_7f58a9c3 = DistanceSquared(pos, level.var_5081bd63[i].origin);
					if(var_7f58a9c3 < var_7ee3aad9)
					{
						best_index = i;
						var_7ee3aad9 = var_7f58a9c3;
					}
				}
				if(0 <= best_index)
				{
					if(ARRIVE)
					{
						if(!level.var_5081bd63[best_index].var_4d6e7e5e)
						{
							for(i = 0; i < level.var_5081bd63.size; i++)
							{
								if(level.var_5081bd63[i].var_4d6e7e5e)
								{
									level.var_5081bd63[i] thread function_3f75d3b();
									break;
								}
							}
							level.var_5081bd63[best_index].var_4d6e7e5e = 1;
							level.var_5081bd63[best_index] thread function_13565590();
						}
					}
					else
					{
						level.var_5081bd63[best_index] thread function_872660fc();
					}
				}
				SetDvar("Dev Block strings are not supported", 0);
				SetDvar("Dev Block strings are not supported", 0);
			}
			var_113a43ca = GetDvarString("Dev Block strings are not supported");
			if(GetDvarInt("Dev Block strings are not supported") || "Dev Block strings are not supported" != var_113a43ca)
			{
				for(i = 0; i < level.players.size; i++)
				{
					level.players[i].var_85da8a33 = 0;
					level.players[i] clientfield::set_to_player("Dev Block strings are not supported", level.players[i].var_85da8a33);
				}
				SetDvar("Dev Block strings are not supported", 0);
			}
			if("Dev Block strings are not supported" != var_113a43ca)
			{
				level.var_fcfc78d0 = var_113a43ca;
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_8115371
	Namespace: bgb_machine
	Checksum: 0xA7B45725
	Offset: 0xED8
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private function_8115371()
{
	waittillframeend;
	level.var_5081bd63 = GetEntArray("bgb_machine_use", "targetname");
	function_62051f89();
}

/*
	Name: function_62051f89
	Namespace: bgb_machine
	Checksum: 0xE939DD37
	Offset: 0xF20
	Size: 0x1F3
	Parameters: 0
	Flags: Private
*/
function private function_62051f89()
{
	if(!level.var_5081bd63.size)
	{
		return;
	}
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		if(!isdefined(level.var_5081bd63[i].base_cost))
		{
			level.var_5081bd63[i].base_cost = 500;
		}
		level.var_5081bd63[i].old_cost = level.var_5081bd63[i].base_cost;
		level.var_5081bd63[i].var_4d6e7e5e = 0;
		level.var_5081bd63[i].uses_at_current_location = 0;
		level.var_5081bd63[i] function_c4ed49b();
	}
	if(!level.enable_magic)
	{
		foreach(bgb_machine in level.var_5081bd63)
		{
			bgb_machine thread function_3f75d3b();
		}
		return;
	}
	level.var_5081bd63 = Array::randomize(level.var_5081bd63);
	function_a5bbc4ee();
	Array::thread_all(level.var_5081bd63, &function_d9f9a9c1);
}

/*
	Name: function_a5bbc4ee
	Namespace: bgb_machine
	Checksum: 0xC5B5EBC5
	Offset: 0x1120
	Size: 0x213
	Parameters: 0
	Flags: Private
*/
function private function_a5bbc4ee()
{
	var_ed3848d8 = 0;
	var_ff664010 = [];
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i] clientfield::set("zm_bgb_machine", 1);
		if(var_ed3848d8 >= level.var_d776839c || !isdefined(level.var_5081bd63[i].script_noteworthy) || !IsSubStr(level.var_5081bd63[i].script_noteworthy, "start_bgb_machine"))
		{
			var_ff664010[var_ff664010.size] = level.var_5081bd63[i];
			continue;
		}
		level.var_5081bd63[i].hidden = 0;
		level.var_5081bd63[i].var_4d6e7e5e = 1;
		level.var_5081bd63[i] function_561f90cb("initial");
		var_ed3848d8++;
	}
	for(i = 0; i < var_ff664010.size; i++)
	{
		if(var_ed3848d8 >= level.var_d776839c)
		{
			var_ff664010[i] thread function_3f75d3b();
			continue;
		}
		var_ff664010[i].hidden = 0;
		var_ff664010[i].var_4d6e7e5e = 1;
		var_ff664010[i] function_561f90cb("initial");
		var_ed3848d8++;
	}
}

/*
	Name: function_c4ed49b
	Namespace: bgb_machine
	Checksum: 0xD9B7226F
	Offset: 0x1340
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function function_c4ed49b()
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
	self.unitrigger_stub.prompt_and_visibility_func = &function_30e4012c;
}

/*
	Name: function_30e4012c
	Namespace: bgb_machine
	Checksum: 0x664AA04F
	Offset: 0x1490
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_30e4012c(player)
{
	can_use = self function_ec0482ba(player);
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
	Name: function_6c7a96b4
	Namespace: bgb_machine
	Checksum: 0xC25EA1F0
	Offset: 0x1528
	Size: 0x1C7
	Parameters: 2
	Flags: None
*/
function function_6c7a96b4(player, base_cost)
{
	if(player.var_85da8a33 < 1 && GetDvarInt("scr_firstGumFree") === 1)
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
	if(player.var_85da8a33 >= 1)
	{
		var_33ea806b = floor(level.round_number / level.var_e1dee7ba);
		var_33ea806b = math::clamp(var_33ea806b, 0, level.var_8ef45dc2);
		var_39a90c5a = pow(level.var_a3e3127d, var_33ea806b);
		cost = cost + level.var_f02c5598 * var_39a90c5a;
	}
	if(player.var_85da8a33 >= 2)
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
	Name: function_ec0482ba
	Namespace: bgb_machine
	Checksum: 0xBC9C007E
	Offset: 0x16F8
	Size: 0x247
	Parameters: 1
	Flags: None
*/
function function_ec0482ba(player)
{
	b_result = 0;
	if(!self trigger_visible_to_player(player))
	{
		return b_result;
	}
	self.hint_parm1 = undefined;
	if(isdefined(self.stub.trigger_target.var_a2b01d1d) && self.stub.trigger_target.var_a2b01d1d)
	{
		if(!(isdefined(self.stub.trigger_target.var_16d95df4) && self.stub.trigger_target.var_16d95df4))
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
		var_562e3c5 = level.bgb[self.stub.trigger_target.var_b287be].var_e25ca181;
		self setcursorhint(cursor_hint, var_562e3c5);
		self.hint_string = str_hint;
	}
	else
	{
		self setcursorhint("HINT_NOICON");
		if(player.var_85da8a33 < level.var_6cb6a683)
		{
			if(isdefined(level.var_42792b8b) && level.var_42792b8b)
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE_CFILL";
			}
			else
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE";
				self.hint_parm1 = function_6c7a96b4(player, self.stub.trigger_target.base_cost);
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
	if(isdefined(self.stub.trigger_target.var_492b876) && player !== self.stub.trigger_target.var_492b876)
	{
		return 0;
	}
	self SetVisibleToPlayer(player);
	return 1;
}

/*
	Name: function_ededc488
	Namespace: bgb_machine
	Checksum: 0x346BA220
	Offset: 0x1A10
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_ededc488()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", player);
		self.stub.trigger_target notify("trigger", player);
	}
}

/*
	Name: function_13565590
	Namespace: bgb_machine
	Checksum: 0xA993BA4C
	Offset: 0x1A70
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_13565590()
{
	self function_561f90cb("arriving");
	self waittill("arrived");
	self.hidden = 0;
}

/*
	Name: function_3f75d3b
	Namespace: bgb_machine
	Checksum: 0xA81C74FE
	Offset: 0x1AB8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_3f75d3b(var_4600cfd0)
{
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.hidden = 1;
	self.uses_at_current_location = 0;
	self.var_4d6e7e5e = 0;
	if(isdefined(var_4600cfd0) && var_4600cfd0)
	{
		self thread function_561f90cb("leaving");
	}
	else
	{
		self thread function_561f90cb("away");
	}
}

/*
	Name: function_5bd3a49b
	Namespace: bgb_machine
	Checksum: 0xBCCB4055
	Offset: 0x1B60
	Size: 0x1C9
	Parameters: 1
	Flags: Private
*/
function private function_5bd3a49b(player)
{
	if(!player.var_8414308a.size)
	{
		player.var_8414308a = Array::randomize(player.var_98ba48a2);
	}
	self.var_b287be = Array::pop_front(player.var_8414308a);
	/#
		if(isdefined(level.var_fcfc78d0))
		{
			self.var_b287be = level.var_fcfc78d0;
			level.var_fcfc78d0 = undefined;
			if("Dev Block strings are not supported" == self.var_b287be)
			{
				keys = Array::randomize(getArrayKeys(level.bgb));
				for(i = 0; i < keys.size; i++)
				{
					if(level.bgb[keys[i]].var_e0715b48)
					{
						self.var_b287be = keys[i];
						break;
					}
				}
				clientfield::set("Dev Block strings are not supported", level.bgb[self.var_b287be].var_e25ca181);
				return 0;
			}
		}
	#/
	clientfield::set("zm_bgb_machine_selection", level.bgb[self.var_b287be].var_e25ca181);
	return player bgb::function_f59fbff(self.var_b287be);
}

/*
	Name: function_d9f9a9c1
	Namespace: bgb_machine
	Checksum: 0x29F0CC66
	Offset: 0x1D38
	Size: 0xA1B
	Parameters: 0
	Flags: None
*/
function function_d9f9a9c1()
{
	var_9bbdff4d = -1;
	while(1)
	{
		var_5e7af4df = undefined;
		self waittill("trigger", User);
		var_9bbdff4d = -1;
		if(isdefined(User.bgb) && isdefined(level.bgb[User.bgb]))
		{
			var_9bbdff4d = level.bgb[User.bgb].var_e25ca181;
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
		cost = function_6c7a96b4(User, self.base_cost);
		if(zm_utility::is_player_valid(User) && User zm_score::can_player_purchase(cost))
		{
			User zm_score::minus_to_player_score(cost);
			self.var_492b876 = User;
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
	if(isdefined(level.var_5912cc2e))
	{
		User thread [[level.var_5912cc2e]]();
	}
	User.var_85da8a33++;
	User clientfield::set_to_player("zm_bgb_machine_round_buys", User.var_85da8a33);
	self.var_492b876 = User;
	self.var_bc4509eb = 1;
	self.var_a23dc60f = 0;
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.var_a23dc60f = 1;
	}
	else
	{
		self.uses_at_current_location++;
	}
	self.var_16d95df4 = self thread function_5bd3a49b(User);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self function_561f90cb("open");
	self waittill("hash_c5d46831");
	self.var_a2b01d1d = 1;
	self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &function_ededc488);
	var_2c6b4c12 = 0;
	var_88ccefee = 0;
	var_8a2037cd = 0;
	if(self.var_16d95df4)
	{
		bb::function_91f32a58(User, self, self.current_cost, self.var_b287be, 0, "_bgb", "_offered");
		if(isdefined(level.bgb[self.var_b287be]))
		{
			var_88ccefee = level.bgb[self.var_b287be].var_e25ca181;
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
					self notify("hash_69873c12");
					User notify("hash_69873c12");
					bb::function_91f32a58(User, self, self.current_cost, self.var_b287be, 0, "_bgb", "_grabbed");
					User RecordMapEvent(3, GetTime(), User.origin, level.round_number, var_9bbdff4d, var_88ccefee);
					User function_fa5d216b(self.var_b287be, 1);
					User bgb::function_66a597c1(self.var_b287be);
					var_2c6b4c12 = 1;
					function_594d2bdf(1);
					User thread bgb::function_b107a7f3(self.var_b287be, 0);
					function_594d2bdf(0);
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
					bb::function_91f32a58(User, self, self.current_cost, self.var_b287be, 0, "_bgb", "_returned");
					break;
				}
			}
			wait(0.05);
		}
		if(grabber == User)
		{
			self function_561f90cb("close");
			self waittill("closed");
		}
	}
	else
	{
		self waittill("trigger");
		bb::function_91f32a58(User, self, self.current_cost, self.var_b287be, 0, "_bgb", "_ghostball");
		if(!var_625e97d1)
		{
			User zm_score::add_to_player_score(self.current_cost, 0, "bgb_machine_ghost_ball");
		}
		var_8a2037cd = 1;
	}
	User function_54e7e486(var_5e7af4df, self.origin, var_88ccefee, var_9bbdff4d, var_2c6b4c12, var_8a2037cd, self.var_a23dc60f);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.var_a2b01d1d = 0;
	wait(1);
	if(function_d8680cd2())
	{
		self thread function_872660fc();
	}
	else if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"] || self.var_4d6e7e5e)
	{
		self thread function_561f90cb("initial");
	}
	self.var_bc4509eb = 0;
	self.var_a23dc60f = 0;
	self.var_492b876 = undefined;
	self notify("hash_62124c1e");
	self thread function_d9f9a9c1();
}

/*
	Name: function_d8680cd2
	Namespace: bgb_machine
	Checksum: 0x1913383E
	Offset: 0x2760
	Size: 0xA3
	Parameters: 0
	Flags: Private
*/
function private function_d8680cd2()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			return 0;
		}
	#/
	if(isdefined(level.var_d453a2ed) && level.var_d453a2ed)
	{
		return 0;
	}
	if(self.uses_at_current_location >= level.var_d118bcf4)
	{
		return 1;
	}
	if(self.uses_at_current_location < level.var_82f744de)
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
	Name: function_d83737d3
	Namespace: bgb_machine
	Checksum: 0x7584FCB8
	Offset: 0x2810
	Size: 0xC9
	Parameters: 0
	Flags: Private
*/
function private function_d83737d3()
{
	if(isdefined(level.var_cfc8eddf))
	{
		[[level.var_cfc8eddf]]();
		return;
	}
	switch(level.players.size)
	{
		case 1:
		{
			level.var_82f744de = 1;
			level.var_d118bcf4 = 3;
			break;
		}
		case 2:
		{
			level.var_82f744de = 1;
			level.var_d118bcf4 = 4;
			break;
		}
		case 3:
		{
			level.var_82f744de = 3;
			level.var_d118bcf4 = 5;
			break;
		}
		case 4:
		{
			level.var_82f744de = 3;
			level.var_d118bcf4 = 6;
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
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i].old_cost = level.var_5081bd63[i].base_cost;
		level.var_5081bd63[i].base_cost = 10;
		if(!level.var_5081bd63[i].var_4d6e7e5e)
		{
			level.var_5081bd63[i].var_7ec446a0 = 1;
			level.var_5081bd63[i] thread function_13565590();
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
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i].base_cost = level.var_5081bd63[i].old_cost;
		if(!level.var_5081bd63[i].var_4d6e7e5e && (isdefined(level.var_5081bd63[i].var_7ec446a0) && level.var_5081bd63[i].var_7ec446a0))
		{
			level.var_5081bd63[i].var_7ec446a0 = undefined;
			level.var_5081bd63[i] thread function_348263ec();
		}
	}
}

/*
	Name: function_348263ec
	Namespace: bgb_machine
	Checksum: 0xF0DCDE0F
	Offset: 0x2AC0
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private function_348263ec()
{
	while(isdefined(self.var_492b876) || (isdefined(self.var_bc4509eb) && self.var_bc4509eb))
	{
		util::wait_network_frame();
	}
	if(level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.var_7ec446a0 = 1;
		self.base_cost = 10;
		return;
	}
	self thread function_3f75d3b(1);
}

/*
	Name: function_872660fc
	Namespace: bgb_machine
	Checksum: 0xAEED0965
	Offset: 0x2B50
	Size: 0x1F1
	Parameters: 0
	Flags: None
*/
function function_872660fc()
{
	self function_3f75d3b(1);
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
	keys = getArrayKeys(level.var_5081bd63);
	keys = Array::randomize(keys);
	for(i = 0; i < keys.size; i++)
	{
		if(self == level.var_5081bd63[keys[i]] || level.var_5081bd63[keys[i]].var_4d6e7e5e)
		{
			continue;
		}
		level.var_5081bd63[keys[i]].var_4d6e7e5e = 1;
		level.var_5081bd63[keys[i]] function_13565590();
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
	self thread function_13565590();
	self.base_cost = 10;
	util::wait_network_frame();
	level waittill("fire_sale_off");
	while(isdefined(self.var_bc4509eb) && self.var_bc4509eb)
	{
		wait(0.1);
	}
	self thread function_3f75d3b(1);
	self.base_cost = self.old_cost;
}

/*
	Name: function_ca233e7d
	Namespace: bgb_machine
	Checksum: 0xDEC16793
	Offset: 0x2E18
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_ca233e7d()
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
	Name: function_1174bcd9
	Namespace: bgb_machine
	Checksum: 0x34A4D46A
	Offset: 0x2F08
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_1174bcd9()
{
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self SetZBarrierPieceState(2, "open");
	self SetZBarrierPieceState(3, "open");
	self SetZBarrierPieceState(5, "closed");
}

/*
	Name: function_e7f3a3f5
	Namespace: bgb_machine
	Checksum: 0xFF4549D8
	Offset: 0x2F98
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_e7f3a3f5()
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
	self thread function_561f90cb("initial");
}

/*
	Name: function_4aa434eb
	Namespace: bgb_machine
	Checksum: 0x66B60AEB
	Offset: 0x30D8
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_4aa434eb()
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
	self thread function_561f90cb("away");
}

/*
	Name: function_118970ca
	Namespace: bgb_machine
	Checksum: 0x5D71BA03
	Offset: 0x3218
	Size: 0x1C9
	Parameters: 0
	Flags: None
*/
function function_118970ca()
{
	self endon("zbarrier_state_change");
	self SetZBarrierPieceState(3, "open");
	self SetZBarrierPieceState(5, "closed");
	clientfield::set("zm_bgb_machine_ghost_ball", !self.var_16d95df4);
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
	self notify("hash_c5d46831");
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
	Name: function_ed2e5150
	Namespace: bgb_machine
	Checksum: 0xA3177C7
	Offset: 0x33F0
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function function_ed2e5150()
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
	Name: function_b56ef180
	Namespace: bgb_machine
	Checksum: 0x33CC9153
	Offset: 0x34C8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_b56ef180()
{
	curr_state = self function_8ae729a7();
	if(curr_state == "open" || curr_state == "close")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_8ae729a7
	Namespace: bgb_machine
	Checksum: 0x87E5FA36
	Offset: 0x3520
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_8ae729a7()
{
	return self.State;
}

/*
	Name: function_561f90cb
	Namespace: bgb_machine
	Checksum: 0xA4F5D29A
	Offset: 0x3538
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_561f90cb(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	self [[level.var_cc480293]](State);
}

/*
	Name: function_cffffa44
	Namespace: bgb_machine
	Checksum: 0x73DAF883
	Offset: 0x35C0
	Size: 0x339
	Parameters: 1
	Flags: None
*/
function function_cffffa44(State)
{
	switch(State)
	{
		case "away":
		{
			self ShowZBarrierPiece(0);
			self ShowZBarrierPiece(5);
			self thread function_ca233e7d();
			self.State = "away";
			break;
		}
		case "arriving":
		{
			self ShowZBarrierPiece(1);
			self ShowZBarrierPiece(3);
			self thread function_e7f3a3f5();
			self.State = "arriving";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(2);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(5);
			self thread function_1174bcd9();
			self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &function_ededc488);
			self.State = "initial";
			break;
		}
		case "open":
		{
			self ShowZBarrierPiece(2);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(4);
			self ShowZBarrierPiece(5);
			self thread function_118970ca();
			self.State = "open";
			break;
		}
		case "close":
		{
			self ShowZBarrierPiece(2);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(5);
			self thread function_ed2e5150();
			self.State = "close";
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self ShowZBarrierPiece(3);
			self thread function_4aa434eb();
			self.State = "leaving";
			break;
		}
		case default:
		{
			if(isdefined(level.var_50c3449d))
			{
				self [[level.var_50c3449d]](State);
			}
			break;
		}
	}
}

/*
	Name: function_4fb7632c
	Namespace: bgb_machine
	Checksum: 0xB0454634
	Offset: 0x3908
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function function_4fb7632c()
{
	level endon("end_game");
	level notify("hash_4fb7632c");
	level endon("hash_4fb7632c");
	while(1)
	{
		level waittill("host_migration_end");
		if(!isdefined(level.var_5081bd63))
		{
			continue;
		}
		foreach(bgb_machine in level.var_5081bd63)
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
	if(isdefined(level.bgb[machine.var_b287be]) && level.bgb[machine.var_b287be].var_c9e64d65 == "activated")
	{
		self zm_audio::create_and_play_dialog("bgb", "buy");
	}
	else
	{
		self zm_audio::create_and_play_dialog("bgb", "eat");
	}
}

