#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_island_util;

#namespace namespace_bbfc4da3;

/*
	Name: main
	Namespace: namespace_bbfc4da3
	Checksum: 0xDE5FAAE8
	Offset: 0xC60
	Size: 0x7C3
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::init("flag_init_challenge_pillars");
	level thread function_ebb99c53();
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		Array::run_all(GetEntArray("t_lookat_challenge_1", "targetname"), &delete);
		Array::run_all(GetEntArray("t_lookat_challenge_2", "targetname"), &delete);
		Array::run_all(GetEntArray("t_lookat_challenge_3", "targetname"), &delete);
		Array::thread_all(struct::get_array("s_challenge_trigger"), &struct::delete);
		struct::get("s_challenge_altar") struct::delete();
	}
	else
	{
		level._challenges = spawnstruct();
		level._challenges.var_4687355c = [];
		level._challenges.var_b88ea497 = [];
		level._challenges.var_928c2a2e = [];
		Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_ISLAND_CHALLENGE_1_1", 1, "update_challenge_1_1", undefined));
		Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_ISLAND_CHALLENGE_1_2", 1, "update_challenge_1_2", undefined));
		Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_ISLAND_CHALLENGE_1_3", 5, "update_challenge_1_3", undefined));
		Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_ISLAND_CHALLENGE_1_4", 5, "update_challenge_1_4", undefined));
		Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_ISLAND_CHALLENGE_1_5", 5, "update_challenge_1_5", &function_2dbc7cd3));
		Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_ISLAND_CHALLENGE_2_1", 1, "update_challenge_2_1", undefined));
		Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_ISLAND_CHALLENGE_2_2", 1, "update_challenge_2_2", &function_25c1bab7));
		Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_ISLAND_CHALLENGE_2_3", 15, "update_challenge_2_3", undefined));
		Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_ISLAND_CHALLENGE_2_4", 10, "update_challenge_2_4", undefined));
		Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_ISLAND_CHALLENGE_2_5", 20, "update_challenge_2_5", undefined));
		Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_ISLAND_CHALLENGE_2_6", 20, "update_challenge_2_6", undefined));
		Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_ISLAND_CHALLENGE_3_1", 8, "update_challenge_3_1", undefined));
		Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_ISLAND_CHALLENGE_3_2", 3, "update_challenge_3_2", undefined));
		Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_ISLAND_CHALLENGE_3_3", 1, "update_challenge_3_3", &function_5a96677a));
		Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_ISLAND_CHALLENGE_3_4", 30, "update_challenge_3_4", undefined));
		Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_ISLAND_CHALLENGE_3_5", 5, "update_challenge_3_5", &function_26c58398));
		zm_spawner::register_zombie_death_event_callback(&function_905d9544);
		zm_spawner::register_zombie_death_event_callback(&function_682e6fc4);
		zm_spawner::register_zombie_death_event_callback(&function_5a2a9ef9);
		zm_spawner::register_zombie_death_event_callback(&function_fe94c179);
		level thread function_89d8e005();
		level flag::set("flag_init_player_challenges");
		/#
			function_b9b4ce34();
		#/
	}
}

/*
	Name: function_970609e0
	Namespace: namespace_bbfc4da3
	Checksum: 0x7143945B
	Offset: 0x1430
	Size: 0xAF
	Parameters: 5
	Flags: None
*/
function function_970609e0(n_challenge_index, var_3e1001b, var_80792f67, str_challenge_notify, var_d675d6d8)
{
	s_challenge = spawnstruct();
	s_challenge.n_index = n_challenge_index;
	s_challenge.str_info = var_3e1001b;
	s_challenge.n_count = var_80792f67;
	s_challenge.str_notify = str_challenge_notify;
	s_challenge.var_c0e6cb4e = var_d675d6d8;
	return s_challenge;
}

/*
	Name: on_player_connect
	Namespace: namespace_bbfc4da3
	Checksum: 0x517793A4
	Offset: 0x14E8
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	level flag::wait_till("flag_init_player_challenges");
	var_a879fa43 = self GetEntityNumber();
	self.var_8575e180 = 0;
	self.var_26f3bd30 = 0;
	self.var_301c71e9 = 0;
	self._challenges = spawnstruct();
	self._challenges.var_4687355c = [];
	self._challenges.var_b88ea497 = [];
	self._challenges.var_928c2a2e = [];
	self._challenges.var_4687355c = Array::random(level._challenges.var_4687355c);
	self._challenges.var_b88ea497 = Array::random(level._challenges.var_b88ea497);
	self._challenges.var_928c2a2e = Array::random(level._challenges.var_928c2a2e);
	ArrayRemoveValue(level._challenges.var_4687355c, self._challenges.var_4687355c);
	ArrayRemoveValue(level._challenges.var_b88ea497, self._challenges.var_b88ea497);
	ArrayRemoveValue(level._challenges.var_928c2a2e, self._challenges.var_928c2a2e);
	self thread function_b7156b15(var_a879fa43);
}

/*
	Name: function_ebb99c53
	Namespace: namespace_bbfc4da3
	Checksum: 0x9392B838
	Offset: 0x16F0
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_ebb99c53()
{
	level flag::wait_till("start_zombie_round_logic");
	for(i = 1; i < 4; i++)
	{
		level clientfield::set("pillar_challenge_0_" + i, 1);
		level clientfield::set("pillar_challenge_1_" + i, 1);
		level clientfield::set("pillar_challenge_2_" + i, 1);
		level clientfield::set("pillar_challenge_3_" + i, 1);
		wait(0.5);
	}
	level flag::set("flag_init_challenge_pillars");
}

/*
	Name: on_player_disconnect
	Namespace: namespace_bbfc4da3
	Checksum: 0x351F311F
	Offset: 0x1810
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	level flag::wait_till("flag_init_player_challenges");
	var_a879fa43 = self GetEntityNumber();
	for(i = 1; i < 4; i++)
	{
		level clientfield::set("pillar_challenge_" + var_a879fa43 + "_" + i, 1);
	}
	Array::add(level._challenges.var_4687355c, self._challenges.var_4687355c);
	Array::add(level._challenges.var_b88ea497, self._challenges.var_b88ea497);
	Array::add(level._challenges.var_928c2a2e, self._challenges.var_928c2a2e);
}

/*
	Name: function_b7156b15
	Namespace: namespace_bbfc4da3
	Checksum: 0x95212E28
	Offset: 0x1950
	Size: 0x501
	Parameters: 1
	Flags: None
*/
function function_b7156b15(var_a879fa43)
{
	self endon("disconnect");
	self flag::init("flag_player_collected_reward_1");
	self flag::init("flag_player_collected_reward_2");
	self flag::init("flag_player_collected_reward_3");
	self flag::init("flag_player_completed_challenge_1");
	self flag::init("flag_player_completed_challenge_2");
	self flag::init("flag_player_completed_challenge_3");
	self thread function_2ce855f3(self._challenges.var_4687355c.n_index, self._challenges.var_4687355c.var_c0e6cb4e, self._challenges.var_4687355c.n_count, self._challenges.var_4687355c.str_notify);
	self thread function_2ce855f3(self._challenges.var_b88ea497.n_index, self._challenges.var_b88ea497.var_c0e6cb4e, self._challenges.var_b88ea497.n_count, self._challenges.var_b88ea497.str_notify);
	self thread function_2ce855f3(self._challenges.var_928c2a2e.n_index, self._challenges.var_928c2a2e.var_c0e6cb4e, self._challenges.var_928c2a2e.n_count, self._challenges.var_928c2a2e.str_notify);
	self thread function_fbbc8608(self._challenges.var_4687355c.n_index, "flag_player_completed_challenge_1");
	self thread function_fbbc8608(self._challenges.var_b88ea497.n_index, "flag_player_completed_challenge_2");
	self thread function_fbbc8608(self._challenges.var_928c2a2e.n_index, "flag_player_completed_challenge_3");
	self thread function_974d5f1d();
	var_8e2d9e6f = [];
	var_e01fcddc = [];
	for(i = 1; i < 4; i++)
	{
		foreach(t_lookat in GetEntArray("t_lookat_challenge_" + i, "targetname"))
		{
			if(t_lookat.script_special == var_a879fa43)
			{
				var_e01fcddc[i] = t_lookat;
			}
		}
		var_8e2d9e6f[i] = i;
		self thread function_7fc84e9c(var_a879fa43, var_8e2d9e6f[i]);
		self thread function_e43d4636(var_a879fa43, var_8e2d9e6f[i]);
	}
	foreach(s_challenge in struct::get_array("s_challenge_trigger"))
	{
		if(s_challenge.script_special == var_a879fa43)
		{
			s_challenge function_72a5d5e5(var_a879fa43, var_8e2d9e6f, var_e01fcddc);
		}
	}
}

/*
	Name: function_72a5d5e5
	Namespace: namespace_bbfc4da3
	Checksum: 0xC7BC69EA
	Offset: 0x1E60
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function function_72a5d5e5(var_a879fa43, var_8e2d9e6f, var_e01fcddc)
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 128;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.inactive_reassess_time = 0.5;
	unitrigger_stub.var_a879fa43 = var_a879fa43;
	unitrigger_stub.var_8e2d9e6f = var_8e2d9e6f;
	unitrigger_stub.var_e01fcddc = var_e01fcddc;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &function_3ae0d6d5;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_a00e23d0);
}

/*
	Name: function_fbbc8608
	Namespace: namespace_bbfc4da3
	Checksum: 0x29C71DA6
	Offset: 0x1FC0
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function function_fbbc8608(n_challenge_index, var_d4adfa57)
{
	self endon("disconnect");
	self flag::wait_till(var_d4adfa57);
	var_d6b47fd3 = "";
	if(n_challenge_index == 1)
	{
		var_d6b47fd3 = self._challenges.var_4687355c.str_info;
	}
	else if(n_challenge_index == 2)
	{
		var_d6b47fd3 = self._challenges.var_b88ea497.str_info;
	}
	else
	{
		var_d6b47fd3 = self._challenges.var_928c2a2e.str_info;
	}
	self LUINotifyEvent(&"trial_complete", 2, &"ZM_ISLAND_TRIAL_COMPLETE", var_d6b47fd3);
}

/*
	Name: function_e8547a5b
	Namespace: namespace_bbfc4da3
	Checksum: 0xA93D5E88
	Offset: 0x20C0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_e8547a5b(var_cc0f18cc)
{
	if(self.var_f121cc22 !== var_cc0f18cc)
	{
		self.var_f121cc22 = var_cc0f18cc;
		self LUINotifyEvent(&"trial_set_description", 1, self.var_f121cc22);
	}
}

/*
	Name: function_27f6c3cd
	Namespace: namespace_bbfc4da3
	Checksum: 0x45C0E2A3
	Offset: 0x2120
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function function_27f6c3cd(player, n_challenge_index)
{
	if(self.stub.var_8e2d9e6f[n_challenge_index] == 1)
	{
		player function_e8547a5b(player._challenges.var_4687355c.str_info);
	}
	else if(self.stub.var_8e2d9e6f[n_challenge_index] == 2)
	{
		player function_e8547a5b(player._challenges.var_b88ea497.str_info);
	}
	else
	{
		player function_e8547a5b(player._challenges.var_928c2a2e.str_info);
	}
}

/*
	Name: function_23c9ffd3
	Namespace: namespace_bbfc4da3
	Checksum: 0x7CA5A195
	Offset: 0x2220
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_23c9ffd3(player)
{
	self notify("hash_23c9ffd3");
	self endon("hash_23c9ffd3");
	while(1)
	{
		wait(0.5);
		if(!isdefined(player))
		{
			break;
		}
		if(!isdefined(self) || Distance(player.origin, self.stub.origin) > 500)
		{
			player clientfield::set_player_uimodel("trialWidget.visible", 0);
			break;
		}
	}
}

/*
	Name: function_3ae0d6d5
	Namespace: namespace_bbfc4da3
	Checksum: 0x9D06FE05
	Offset: 0x22D8
	Size: 0x407
	Parameters: 1
	Flags: None
*/
function function_3ae0d6d5(player)
{
	if(player GetEntityNumber() == self.stub.var_a879fa43)
	{
		var_a51a0ba6 = 0;
		for(i = 1; i < 4; i++)
		{
			if(player function_3f67a723(self.stub.var_e01fcddc[i].origin, 20, 0) && Distance(player.origin, self.stub.origin) < 500)
			{
				self function_27f6c3cd(player, i);
				player clientfield::set_player_uimodel("trialWidget.visible", 1);
				player clientfield::set_player_uimodel("trialWidget.progress", player.var_873a3e27[self.stub.var_8e2d9e6f[i]]);
				if(!player flag::get("flag_player_completed_challenge_" + self.stub.var_8e2d9e6f[i]))
				{
					self function_cb2c15eb(player, "");
					var_a51a0ba6 = 1;
					self thread function_23c9ffd3(player);
					return 1;
					continue;
				}
				if(!player flag::get("flag_player_collected_reward_" + self.stub.var_8e2d9e6f[i]) && !level flag::get("flag_player_initialized_reward"))
				{
					self function_cb2c15eb(player, &"ZM_ISLAND_CHALLENGE_REWARD");
					var_a51a0ba6 = 1;
					self thread function_23c9ffd3(player);
					return 1;
					continue;
				}
				if(!player flag::get("flag_player_collected_reward_" + self.stub.var_8e2d9e6f[i]) && level flag::get("flag_player_initialized_reward"))
				{
					self function_cb2c15eb(player, &"ZM_ISLAND_CHALLENGE_ALTAR_IN_USE");
					var_a51a0ba6 = 1;
					self thread function_23c9ffd3(player);
					return 1;
					continue;
				}
				self function_cb2c15eb(player, "");
				var_a51a0ba6 = 1;
				self thread function_23c9ffd3(player);
				return 1;
			}
		}
		if(!var_a51a0ba6)
		{
			self function_cb2c15eb(player, "");
			player clientfield::set_player_uimodel("trialWidget.visible", 0);
			return 0;
		}
	}
	else
	{
		self function_cb2c15eb(player, "");
		player clientfield::set_player_uimodel("trialWidget.visible", 0);
		return 0;
	}
}

/*
	Name: function_3f67a723
	Namespace: namespace_bbfc4da3
	Checksum: 0x308BE38B
	Offset: 0x26E8
	Size: 0xB3
	Parameters: 4
	Flags: None
*/
function function_3f67a723(origin, arc_angle_degrees, do_trace, e_ignore)
{
	if(!isdefined(arc_angle_degrees))
	{
		arc_angle_degrees = 90;
	}
	arc_angle_degrees = AbsAngleClamp360(arc_angle_degrees);
	dot = cos(arc_angle_degrees * 0.5);
	if(self util::is_player_looking_at(origin, dot, do_trace, e_ignore))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_a00e23d0
	Namespace: namespace_bbfc4da3
	Checksum: 0x7C77AEEA
	Offset: 0x27A8
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function function_a00e23d0()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who GetEntityNumber() == self.stub.var_a879fa43)
		{
			for(i = 1; i < 4; i++)
			{
				if(e_who function_3f67a723(self.stub.var_e01fcddc[i].origin, 20, 0) && Distance(e_who.origin, self.stub.origin) < 500)
				{
					if(e_who flag::get("flag_player_completed_challenge_" + self.stub.var_8e2d9e6f[i]) && !e_who flag::get("flag_player_collected_reward_" + self.stub.var_8e2d9e6f[i]) && !level flag::get("flag_player_initialized_reward"))
					{
						e_who thread function_8675d6ed(self.stub.var_8e2d9e6f[i]);
					}
				}
			}
			self function_cb2c15eb(e_who, "");
		}
	}
}

/*
	Name: function_7fc84e9c
	Namespace: namespace_bbfc4da3
	Checksum: 0x6040925C
	Offset: 0x2988
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function function_7fc84e9c(var_a879fa43, var_15fa438f)
{
	self endon("disconnect");
	self flag::wait_till("flag_player_completed_challenge_" + var_15fa438f);
	switch(var_a879fa43)
	{
		case 0:
		{
			str_exploder = "fxexp_820";
			break;
		}
		case 1:
		{
			str_exploder = "fxexp_821";
			break;
		}
		case 2:
		{
			str_exploder = "fxexp_822";
			break;
		}
		case 3:
		{
			str_exploder = "fxexp_823";
			break;
		}
	}
	exploder::exploder(str_exploder);
	wait(1);
	exploder::stop_exploder(str_exploder);
}

/*
	Name: function_e43d4636
	Namespace: namespace_bbfc4da3
	Checksum: 0x52CD298A
	Offset: 0x2A80
	Size: 0x123
	Parameters: 2
	Flags: None
*/
function function_e43d4636(var_a879fa43, var_15fa438f)
{
	self endon("disconnect");
	level flag::wait_till("flag_init_challenge_pillars");
	level clientfield::set("pillar_challenge_" + var_a879fa43 + "_" + var_15fa438f, 2);
	self flag::wait_till("flag_player_completed_challenge_" + var_15fa438f);
	level clientfield::set("pillar_challenge_" + var_a879fa43 + "_" + var_15fa438f, 3);
	self flag::wait_till("flag_player_collected_reward_" + var_15fa438f);
	level clientfield::set("pillar_challenge_" + var_a879fa43 + "_" + var_15fa438f, 4);
}

/*
	Name: function_8675d6ed
	Namespace: namespace_bbfc4da3
	Checksum: 0x3FB05F9A
	Offset: 0x2BB0
	Size: 0x433
	Parameters: 1
	Flags: None
*/
function function_8675d6ed(var_15fa438f)
{
	self endon("disconnect");
	var_a879fa43 = self GetEntityNumber();
	var_81d71db = [];
	var_60934569 = struct::get("s_challenge_altar");
	if(var_15fa438f == 1)
	{
		var_c9d33fc4 = "p7_zm_power_up_max_ammo";
	}
	else if(var_15fa438f == 2)
	{
		Array::add(var_81d71db, "wpn_t7_lmg_dingo_world");
		Array::add(var_81d71db, "wpn_t7_shotty_gator_world");
		Array::add(var_81d71db, "wpn_t7_sniper_svg100_world");
		var_c9d33fc4 = Array::random(var_81d71db);
	}
	else
	{
		var_c9d33fc4 = "zombie_pickup_perk_bottle";
	}
	level flag::set("flag_player_initialized_reward");
	var_a6a1ecf9 = GetEnt("altar_lid", "targetname");
	self function_d655a4ce(var_a6a1ecf9);
	self thread function_26abcbe0();
	self thread function_994b4784(var_a6a1ecf9);
	if(var_15fa438f == 2)
	{
		v_spawnpt = var_60934569.origin + (0, 8, 30);
	}
	else
	{
		v_spawnpt = var_60934569.origin + (0, 0, 30);
	}
	var_30ff0d6c = function_5e39bbbe(var_c9d33fc4, v_spawnpt, var_60934569.angles);
	self thread function_6168d051(var_30ff0d6c);
	if(var_15fa438f == 1)
	{
		var_30ff0d6c clientfield::set("challenge_glow_fx", 1);
	}
	else if(var_15fa438f == 3)
	{
		var_30ff0d6c clientfield::set("challenge_glow_fx", 2);
	}
	var_30ff0d6c thread timer_til_despawn(self, var_15fa438f, v_spawnpt, 30 * -1);
	self thread function_5c44a258(var_30ff0d6c);
	var_30ff0d6c endon("hash_59e0fa55");
	var_30ff0d6c.trigger = var_60934569 function_be89930d(var_a879fa43, var_15fa438f);
	var_30ff0d6c.trigger waittill("trigger", e_who);
	if(e_who == self)
	{
		self playsoundtoplayer("zmb_trial_unlock_reward", self);
		var_30ff0d6c.trigger notify("hash_6e68aec2");
		self function_640cd978(var_15fa438f, var_60934569, var_c9d33fc4);
		if(isdefined(var_30ff0d6c.trigger))
		{
			zm_unitrigger::unregister_unitrigger(var_30ff0d6c.trigger);
			var_30ff0d6c.trigger = undefined;
		}
		if(isdefined(var_30ff0d6c))
		{
			var_30ff0d6c delete();
		}
	}
}

/*
	Name: function_5e39bbbe
	Namespace: namespace_bbfc4da3
	Checksum: 0xB05B46DA
	Offset: 0x2FF0
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function function_5e39bbbe(var_c9d33fc4, v_origin, v_angles)
{
	var_30ff0d6c = util::spawn_model(var_c9d33fc4, v_origin, v_angles + VectorScale((0, 1, 0), 90));
	return var_30ff0d6c;
}

/*
	Name: timer_til_despawn
	Namespace: namespace_bbfc4da3
	Checksum: 0xF7574D9F
	Offset: 0x3058
	Size: 0xE3
	Parameters: 4
	Flags: None
*/
function timer_til_despawn(player, var_15fa438f, v_float, n_dist)
{
	player endon("disconnect");
	self endon("hash_6e68aec2");
	self MoveZ(n_dist, 12, 6);
	self waittill("movedone");
	self notify("hash_59e0fa55");
	level flag::clear("flag_player_initialized_reward");
	if(isdefined(self.trigger))
	{
		zm_unitrigger::unregister_unitrigger(self.trigger);
		self.trigger = undefined;
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_5c44a258
	Namespace: namespace_bbfc4da3
	Checksum: 0xCA07DE39
	Offset: 0x3148
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_5c44a258(var_30ff0d6c)
{
	self endon("hash_994b4784");
	self waittill("disconnect");
	level flag::clear("flag_player_initialized_reward");
	var_30ff0d6c delete();
}

/*
	Name: function_640cd978
	Namespace: namespace_bbfc4da3
	Checksum: 0x327BEB88
	Offset: 0x31B0
	Size: 0x179
	Parameters: 3
	Flags: None
*/
function function_640cd978(var_15fa438f, var_60934569, var_c9d33fc4)
{
	if(var_15fa438f == 1)
	{
		level thread zm_powerups::specific_powerup_drop("full_ammo", self.origin);
	}
	else if(var_15fa438f == 2)
	{
		if(var_c9d33fc4 == "wpn_t7_lmg_dingo_world")
		{
			e_weapon = GetWeapon("lmg_cqb");
		}
		else if(var_c9d33fc4 == "wpn_t7_shotty_gator_world")
		{
			e_weapon = GetWeapon("shotgun_semiauto");
		}
		else
		{
			e_weapon = GetWeapon("sniper_powerbolt");
		}
		self thread namespace_8aed53c9::swap_weapon(e_weapon);
	}
	else
	{
		level thread zm_powerups::specific_powerup_drop("empty_perk", self.origin);
	}
	self flag::set("flag_player_collected_reward_" + var_15fa438f);
	level flag::clear("flag_player_initialized_reward");
	self notify("hash_6e68aec2");
}

/*
	Name: function_be89930d
	Namespace: namespace_bbfc4da3
	Checksum: 0x288312AB
	Offset: 0x3338
	Size: 0x127
	Parameters: 2
	Flags: None
*/
function function_be89930d(var_a879fa43, var_15fa438f)
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 128;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.var_a879fa43 = var_a879fa43;
	unitrigger_stub.var_15fa438f = var_15fa438f;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &function_6d42affc;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_1e314338);
	return unitrigger_stub;
}

/*
	Name: function_6d42affc
	Namespace: namespace_bbfc4da3
	Checksum: 0x95C70A78
	Offset: 0x3468
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function function_6d42affc(player)
{
	w_current = player GetCurrentWeapon();
	if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponNone || w_current.isHeroWeapon == 1 && self.stub.var_15fa438f == 2)
	{
		self function_cb2c15eb(player, "");
		return 0;
	}
	else if(player GetEntityNumber() == self.stub.var_a879fa43)
	{
		self function_cb2c15eb(player, &"ZM_ISLAND_CHALLENGE_REWARD");
		return 1;
	}
	else
	{
		self function_cb2c15eb(player, "");
		return 0;
	}
}

/*
	Name: function_1e314338
	Namespace: namespace_bbfc4da3
	Checksum: 0x831DF3C9
	Offset: 0x35B8
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_1e314338()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", player);
		w_current = player GetCurrentWeapon();
		if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponNone || w_current.isHeroWeapon == 1 && self.stub.var_15fa438f == 2)
		{
			continue;
		}
		if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
		{
			continue;
		}
		self.stub notify("trigger", player);
	}
}

/*
	Name: function_d655a4ce
	Namespace: namespace_bbfc4da3
	Checksum: 0x3952F4EA
	Offset: 0x36C8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_d655a4ce(var_a6a1ecf9)
{
	self endon("hash_994b4784");
	level.var_2371bbc = self;
	var_a6a1ecf9 SetIgnorePauseWorld(1);
	var_a6a1ecf9 playsound("zmb_challenge_altar_open");
	var_a6a1ecf9 scene::Play("p7_fxanim_zm_island_altar_skull_lid_rise_bundle", var_a6a1ecf9);
	var_a6a1ecf9 thread scene::Play("p7_fxanim_zm_island_altar_skull_lid_idle_bundle", var_a6a1ecf9);
}

/*
	Name: function_994b4784
	Namespace: namespace_bbfc4da3
	Checksum: 0xA5108A9B
	Offset: 0x3770
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function function_994b4784(var_a6a1ecf9)
{
	self waittill("hash_994b4784");
	var_a6a1ecf9 playsound("zmb_challenge_altar_close");
	var_a6a1ecf9 scene::Play("p7_fxanim_zm_island_altar_skull_lid_fall_bundle", var_a6a1ecf9);
	level.var_2371bbc = undefined;
}

/*
	Name: function_26abcbe0
	Namespace: namespace_bbfc4da3
	Checksum: 0xA88DAAF3
	Offset: 0x37D8
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function function_26abcbe0()
{
	self endon("hash_994b4784");
	self util::waittill_any("disconnect", "death", "reward_grabbed");
	self notify("hash_994b4784");
}

/*
	Name: function_6168d051
	Namespace: namespace_bbfc4da3
	Checksum: 0x3773CDE1
	Offset: 0x3830
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function function_6168d051(var_30ff0d6c)
{
	self endon("hash_994b4784");
	var_30ff0d6c waittill("hash_59e0fa55");
	self notify("hash_994b4784");
}

/*
	Name: function_2dbc7cd3
	Namespace: namespace_bbfc4da3
	Checksum: 0xED969996
	Offset: 0x3870
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_2dbc7cd3()
{
	self endon("disconnect");
	while(!self flag::get("flag_player_completed_challenge_1"))
	{
		self waittill("hash_7ae66b0a");
		self notify("hash_296e52f0");
	}
}

/*
	Name: function_fe94c179
	Namespace: namespace_bbfc4da3
	Checksum: 0xA5C45D7E
	Offset: 0x38C8
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_fe94c179(e_attacker)
{
	if(isPlayer(e_attacker) && (isdefined(self.var_61f7b3a0) && self.var_61f7b3a0) && (!isdefined(self.thrasherHasTurnedBerserk) && self.thrasherHasTurnedBerserk))
	{
		e_attacker notify("hash_fb461733");
	}
}

/*
	Name: function_25c1bab7
	Namespace: namespace_bbfc4da3
	Checksum: 0xDCFEF272
	Offset: 0x3938
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_25c1bab7()
{
	self endon("disconnect");
	while(!self flag::get("flag_player_completed_challenge_2"))
	{
		self waittill("hash_61bbe625");
		self notify("hash_893ea7f8");
	}
}

/*
	Name: function_5a2a9ef9
	Namespace: namespace_bbfc4da3
	Checksum: 0x51934EDA
	Offset: 0x3990
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_5a2a9ef9(e_attacker)
{
	if(isPlayer(e_attacker) && self.archetype === "zombie" && isdefined(self.attackable))
	{
		if(self.attackable.scriptbundlename == "zm_island_trap_plant_attackable" || self.attackable.scriptbundlename == "zm_island_trap_plant_upgraded_attackable")
		{
			e_attacker notify("hash_af412261");
		}
	}
}

/*
	Name: function_682e6fc4
	Namespace: namespace_bbfc4da3
	Checksum: 0xBCD966C3
	Offset: 0x3A28
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_682e6fc4(e_attacker)
{
	if(isPlayer(e_attacker) && self.archetype === "zombie" && (isdefined(self.var_34d00e7) && self.var_34d00e7))
	{
		e_attacker notify("hash_80ff169");
	}
}

/*
	Name: function_5a96677a
	Namespace: namespace_bbfc4da3
	Checksum: 0x5249729A
	Offset: 0x3A90
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_5a96677a()
{
	self endon("disconnect");
	while(!self flag::get("flag_player_completed_challenge_3"))
	{
		self waittill("hash_3e1e1a8");
		self notify("hash_e20d7700");
	}
}

/*
	Name: function_905d9544
	Namespace: namespace_bbfc4da3
	Checksum: 0xF23F8C6C
	Offset: 0x3AE8
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function function_905d9544(e_attacker)
{
	if(isPlayer(e_attacker))
	{
		if(!e_attacker flag::get("flag_player_completed_challenge_2") && self.archetype === "zombie" && (isdefined(self.var_d07c64b6) && self.var_d07c64b6))
		{
			if(isdefined(self.damagelocation) && self.damagelocation == "head" || self.damagelocation == "helmet")
			{
				e_attacker notify("hash_6d4d866e");
			}
		}
		if(!e_attacker flag::get("flag_player_completed_challenge_2") && self.archetype === "zombie" && e_attacker IsPlayerUnderwater())
		{
			e_attacker notify("hash_935000d7");
		}
	}
}

/*
	Name: function_26c58398
	Namespace: namespace_bbfc4da3
	Checksum: 0x7A180273
	Offset: 0x3C08
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function function_26c58398()
{
	self endon("death");
	while(1)
	{
		self waittill("destroyed_thrasher_head");
		self notify("hash_c61c5576");
	}
}

/*
	Name: function_2ce855f3
	Namespace: namespace_bbfc4da3
	Checksum: 0xD08C76C7
	Offset: 0x3C48
	Size: 0xF3
	Parameters: 4
	Flags: None
*/
function function_2ce855f3(n_challenge_index, var_d675d6d8, var_80792f67, str_challenge_notify)
{
	self endon("disconnect");
	/#
		self endon("hash_1e547c60");
	#/
	if(isdefined(var_d675d6d8))
	{
		self thread [[var_d675d6d8]]();
	}
	if(!isdefined(self.var_873a3e27))
	{
		self.var_873a3e27 = [];
	}
	self.var_873a3e27[n_challenge_index] = 0;
	var_ea184c3d = var_80792f67;
	while(var_80792f67 > 0)
	{
		self waittill(str_challenge_notify);
		var_80792f67--;
		self.var_873a3e27[n_challenge_index] = 1 - var_80792f67 / var_ea184c3d;
	}
	self flag::set("flag_player_completed_challenge_" + n_challenge_index);
}

/*
	Name: function_974d5f1d
	Namespace: namespace_bbfc4da3
	Checksum: 0xAAF14CE6
	Offset: 0x3D48
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function function_974d5f1d()
{
	self endon("disconnect");
	a_flags = Array("flag_player_completed_challenge_1", "flag_player_completed_challenge_2", "flag_player_completed_challenge_3");
	self flag::wait_till_all(a_flags);
	level notify("hash_41370469");
}

/*
	Name: function_89d8e005
	Namespace: namespace_bbfc4da3
	Checksum: 0xA05DB97B
	Offset: 0x3DC0
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_89d8e005()
{
	level.var_c28313cd = 0;
	callback::on_disconnect(&function_b1cd865a);
	while(1)
	{
		level waittill("hash_41370469");
		level.var_c28313cd++;
		if(level.var_c28313cd >= level.players.size)
		{
			level flag::set("all_challenges_completed");
			level thread function_397b26ee();
			break;
		}
	}
}

/*
	Name: function_b1cd865a
	Namespace: namespace_bbfc4da3
	Checksum: 0x4B9E50D3
	Offset: 0x3E70
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_b1cd865a()
{
	if(level.var_c28313cd >= level.players.size)
	{
		level flag::set("all_challenges_completed");
	}
}

/*
	Name: function_397b26ee
	Namespace: namespace_bbfc4da3
	Checksum: 0xC341F37F
	Offset: 0x3EB0
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function function_397b26ee()
{
	var_45a970ad = [];
	Array::add(var_45a970ad, "fxexp_820");
	Array::add(var_45a970ad, "fxexp_821");
	Array::add(var_45a970ad, "fxexp_822");
	Array::add(var_45a970ad, "fxexp_823");
	wait(1.5);
	while(var_45a970ad.size > 0)
	{
		var_c490d0cd = Array::random(var_45a970ad);
		exploder::exploder(var_c490d0cd);
		ArrayRemoveValue(var_45a970ad, var_c490d0cd);
		wait(RandomFloatRange(0.5, 1.5));
	}
	wait(5);
	exploder::stop_exploder("fxexp_820");
	exploder::stop_exploder("fxexp_821");
	exploder::stop_exploder("fxexp_822");
	exploder::stop_exploder("fxexp_823");
	var_45a970ad = undefined;
}

/*
	Name: function_b9b4ce34
	Namespace: namespace_bbfc4da3
	Checksum: 0xEEE47FD2
	Offset: 0x4048
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_b9b4ce34()
{
	/#
		zm_devgui::function_4acecab5(&function_16ba3a1e);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_16ba3a1e
	Namespace: namespace_bbfc4da3
	Checksum: 0x49E60582
	Offset: 0x40F8
	Size: 0x6E9
	Parameters: 1
	Flags: None
*/
function function_16ba3a1e(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.players)
				{
					player flag::set("Dev Block strings are not supported");
					player.var_873a3e27[1] = 1;
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.players)
				{
					player flag::set("Dev Block strings are not supported");
					player.var_873a3e27[2] = 1;
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.players)
				{
					player flag::set("Dev Block strings are not supported");
					player.var_873a3e27[3] = 1;
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.players)
				{
					Array::add(level._challenges.var_4687355c, player._challenges.var_4687355c);
					Array::add(level._challenges.var_b88ea497, player._challenges.var_b88ea497);
					Array::add(level._challenges.var_928c2a2e, player._challenges.var_928c2a2e);
				}
				foreach(player in level.players)
				{
					player notify("hash_1e547c60");
					player.var_873a3e27 = undefined;
					player._challenges.var_4687355c = Array::random(level._challenges.var_4687355c);
					player._challenges.var_b88ea497 = Array::random(level._challenges.var_b88ea497);
					player._challenges.var_928c2a2e = Array::random(level._challenges.var_928c2a2e);
					ArrayRemoveValue(level._challenges.var_4687355c, player._challenges.var_4687355c);
					ArrayRemoveValue(level._challenges.var_b88ea497, player._challenges.var_b88ea497);
					ArrayRemoveValue(level._challenges.var_928c2a2e, player._challenges.var_928c2a2e);
					player thread function_2ce855f3(player._challenges.var_4687355c.n_index, player._challenges.var_4687355c.var_c0e6cb4e, player._challenges.var_4687355c.n_count, player._challenges.var_4687355c.str_notify);
					player thread function_2ce855f3(player._challenges.var_b88ea497.n_index, player._challenges.var_b88ea497.var_c0e6cb4e, player._challenges.var_b88ea497.n_count, player._challenges.var_b88ea497.str_notify);
					player thread function_2ce855f3(player._challenges.var_928c2a2e.n_index, player._challenges.var_928c2a2e.var_c0e6cb4e, player._challenges.var_928c2a2e.n_count, player._challenges.var_928c2a2e.str_notify);
				}
				return 1;
			}
		}
		return 0;
	#/
}

