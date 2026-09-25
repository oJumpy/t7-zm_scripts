#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_dragon_gauntlet;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_stalingrad_vo;

#namespace namespace_e0675efb;

/*
	Name: __init__sytem__
	Namespace: namespace_e0675efb
	Checksum: 0x452F4C65
	Offset: 0xEF8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_challenges", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_e0675efb
	Checksum: 0x36445926
	Offset: 0xF40
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "challenge_grave_fire", 12000, 2, "int");
	clientfield::register("scriptmover", "challenge_arm_reveal", 12000, 1, "counter");
	clientfield::register("toplayer", "pr_b", 12000, 3, "int");
	clientfield::register("toplayer", "pr_c", 12000, 3, "int");
	clientfield::register("toplayer", "pr_l_c", 12000, 1, "int");
	clientfield::register("missile", "pr_gm_e_fx", 12000, 1, "int");
	clientfield::register("scriptmover", "pr_g_c_fx", 12000, 1, "int");
	clientfield::register("toplayer", "challenge1state", 14000, 2, "int");
	clientfield::register("toplayer", "challenge2state", 14000, 2, "int");
	clientfield::register("toplayer", "challenge3state", 14000, 2, "int");
	level flag::init("pr_m");
	level flag::init("dragon_gauntlet_acquired");
}

/*
	Name: __main__
	Namespace: namespace_e0675efb
	Checksum: 0xD9F85152
	Offset: 0x1170
	Size: 0x72B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level._challenges = spawnstruct();
	level._challenges.var_4687355c = [];
	level._challenges.var_b88ea497 = [];
	level._challenges.var_928c2a2e = [];
	level thread function_b2413e04();
	Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_STALINGRAD_CHALLENGE_1_1", 10, "update_challenge_1_1", &function_960bfb56));
	Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_STALINGRAD_CHALLENGE_1_2", 3, "update_challenge_1_2", &function_f1c59ae));
	Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_STALINGRAD_CHALLENGE_1_3", 5, "update_challenge_1_3", &function_76bcffc2));
	Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_STALINGRAD_CHALLENGE_1_4", 3, "update_challenge_1_4", &function_dec401c2));
	Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_STALINGRAD_CHALLENGE_1_5", 5, "update_challenge_1_5", &function_c169b7dd));
	Array::add(level._challenges.var_4687355c, function_970609e0(1, &"ZM_STALINGRAD_CHALLENGE_1_6", 1, "update_challenge_1_6", &function_5efd7abf));
	Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_STALINGRAD_CHALLENGE_2_1", 10, "update_challenge_2_1", &function_4322fb5f));
	Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_STALINGRAD_CHALLENGE_2_2", 30, "update_challenge_2_2", &function_f427e9ad));
	Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_STALINGRAD_CHALLENGE_2_3", 40, "update_challenge_2_3", &function_4e107409));
	Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_STALINGRAD_CHALLENGE_2_4", 45, "update_challenge_2_4", &function_81adc498));
	Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_STALINGRAD_CHALLENGE_2_5", 10, "update_challenge_2_5", &function_64e8cc03));
	Array::add(level._challenges.var_b88ea497, function_970609e0(2, &"ZM_STALINGRAD_CHALLENGE_2_6", 1, "update_challenge_2_6", &function_31d5f655));
	Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_STALINGRAD_CHALLENGE_3_1", 1, "update_challenge_3_1", &function_75fdfc25));
	Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_STALINGRAD_CHALLENGE_3_2", 3, "update_challenge_3_2", &function_2bf9f9d4));
	Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_STALINGRAD_CHALLENGE_3_3", 100, "update_challenge_3_3", &function_dcbd7aec));
	Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_STALINGRAD_CHALLENGE_3_4", 60, "update_challenge_3_4", &function_3d0619b6));
	Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_STALINGRAD_CHALLENGE_3_5", 6, "update_challenge_3_5", &function_cdeaa5f));
	Array::add(level._challenges.var_928c2a2e, function_970609e0(3, &"ZM_STALINGRAD_CHALLENGE_3_6", 6, "update_challenge_3_6", &function_e480fc42));
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
	callback::on_spawned(&on_player_spawned);
	level.get_player_perk_purchase_limit = &function_1adeaa1c;
	/#
		function_b9b4ce34();
	#/
}

/*
	Name: function_970609e0
	Namespace: namespace_e0675efb
	Checksum: 0x78E6C79F
	Offset: 0x18A8
	Size: 0xC7
	Parameters: 5
	Flags: None
*/
function function_970609e0(n_challenge_index, var_3e1001b, var_80792f67, str_challenge_notify, var_d675d6d8)
{
	if(!isdefined(var_d675d6d8))
	{
		var_d675d6d8 = undefined;
	}
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
	Namespace: namespace_e0675efb
	Checksum: 0xBA9E2A6A
	Offset: 0x1978
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread function_b7156b15();
	self thread function_4ca86c86();
}

/*
	Name: on_player_spawned
	Namespace: namespace_e0675efb
	Checksum: 0x4385BBAF
	Offset: 0x19B8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread function_914c6e38();
	self thread function_99985d03();
	self thread function_be89247c();
}

/*
	Name: on_player_disconnect
	Namespace: namespace_e0675efb
	Checksum: 0xDD170003
	Offset: 0x1A10
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	if(!isdefined(level._challenges.var_4687355c))
	{
		level._challenges.var_4687355c = [];
	}
	else if(!IsArray(level._challenges.var_4687355c))
	{
		level._challenges.var_4687355c = Array(level._challenges.var_4687355c);
	}
	level._challenges.var_4687355c[level._challenges.var_4687355c.size] = self._challenges.var_4687355c;
	if(!isdefined(level._challenges.var_b88ea497))
	{
		level._challenges.var_b88ea497 = [];
	}
	else if(!IsArray(level._challenges.var_b88ea497))
	{
		level._challenges.var_b88ea497 = Array(level._challenges.var_b88ea497);
	}
	level._challenges.var_b88ea497[level._challenges.var_b88ea497.size] = self._challenges.var_b88ea497;
	if(!isdefined(level._challenges.var_928c2a2e))
	{
		level._challenges.var_928c2a2e = [];
	}
	else if(!IsArray(level._challenges.var_928c2a2e))
	{
		level._challenges.var_928c2a2e = Array(level._challenges.var_928c2a2e);
	}
	level._challenges.var_928c2a2e[level._challenges.var_928c2a2e.size] = self._challenges.var_928c2a2e;
	n_player_number = self GetEntityNumber();
	level notify("player_disconnected_" + n_player_number);
}

/*
	Name: function_b7156b15
	Namespace: namespace_e0675efb
	Checksum: 0x1B8BDCB0
	Offset: 0x1C68
	Size: 0x595
	Parameters: 0
	Flags: None
*/
function function_b7156b15()
{
	self endon("disconnect");
	self flag::init("flag_player_collected_reward_1");
	self flag::init("flag_player_collected_reward_2");
	self flag::init("flag_player_collected_reward_3");
	self flag::init("flag_player_collected_reward_4");
	self flag::init("flag_player_collected_reward_5");
	self flag::init("flag_player_completed_challenge_1");
	self flag::init("flag_player_completed_challenge_2");
	self flag::init("flag_player_completed_challenge_3");
	self flag::init("flag_player_completed_challenge_4");
	if(level flag::get("gauntlet_quest_complete"))
	{
		self flag::set("flag_player_completed_challenge_4");
	}
	self flag::init("flag_player_initialized_reward");
	level flag::wait_till("initial_players_connected");
	self._challenges = spawnstruct();
	self._challenges.var_4687355c = Array::random(level._challenges.var_4687355c);
	self._challenges.var_b88ea497 = Array::random(level._challenges.var_b88ea497);
	do
	{
		self._challenges.var_928c2a2e = Array::random(level._challenges.var_928c2a2e);
	}
	while(!(level flag::get("solo_game") && level.players.size == 1 && self._challenges.var_928c2a2e.str_notify == "update_challenge_3_4"));
	ArrayRemoveValue(level._challenges.var_4687355c, self._challenges.var_4687355c);
	ArrayRemoveValue(level._challenges.var_b88ea497, self._challenges.var_b88ea497);
	ArrayRemoveValue(level._challenges.var_928c2a2e, self._challenges.var_928c2a2e);
	self thread function_2ce855f3(self._challenges.var_4687355c);
	self thread function_2ce855f3(self._challenges.var_b88ea497);
	self thread function_2ce855f3(self._challenges.var_928c2a2e);
	self thread function_fbbc8608(self._challenges.var_4687355c.n_index, "flag_player_completed_challenge_1");
	self thread function_fbbc8608(self._challenges.var_b88ea497.n_index, "flag_player_completed_challenge_2");
	self thread function_fbbc8608(self._challenges.var_928c2a2e.n_index, "flag_player_completed_challenge_3");
	self thread function_974d5f1d();
	n_player_number = self GetEntityNumber();
	for(i = 1; i <= 4; i++)
	{
		self thread function_a2d25f82(i);
	}
	foreach(s_challenge in struct::get_array("s_challenge_trigger"))
	{
		if(s_challenge.script_int == n_player_number)
		{
			s_challenge function_4e61a018();
			break;
		}
	}
}

/*
	Name: function_914c6e38
	Namespace: namespace_e0675efb
	Checksum: 0x59DE798C
	Offset: 0x2208
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_914c6e38()
{
	self clientfield::set_to_player("challenge_grave_fire", self GetEntityNumber());
}

/*
	Name: function_99985d03
	Namespace: namespace_e0675efb
	Checksum: 0x8362826B
	Offset: 0x2248
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_99985d03()
{
	self flag::clear("flag_player_collected_reward_" + 4);
}

/*
	Name: function_4e61a018
	Namespace: namespace_e0675efb
	Checksum: 0xF0648905
	Offset: 0x2278
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function function_4e61a018()
{
	self zm_unitrigger::create_unitrigger("", 128, &function_3ae0d6d5);
	self.s_unitrigger.require_look_at = 0;
	self.s_unitrigger.inactive_reassess_time = 0.1;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.s_unitrigger, 1);
	self.var_b2a5207f = GetEnt("challenge_gravestone_" + self.script_int, "targetname");
	self.var_407ba908 = [];
	if(!isdefined(self.var_407ba908))
	{
		self.var_407ba908 = [];
	}
	else if(!IsArray(self.var_407ba908))
	{
		self.var_407ba908 = Array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "ar_famas_upgraded";
	if(!isdefined(self.var_407ba908))
	{
		self.var_407ba908 = [];
	}
	else if(!IsArray(self.var_407ba908))
	{
		self.var_407ba908 = Array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "ar_garand_upgraded";
	if(!isdefined(self.var_407ba908))
	{
		self.var_407ba908 = [];
	}
	else if(!IsArray(self.var_407ba908))
	{
		self.var_407ba908 = Array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "smg_mp40_upgraded";
	if(!isdefined(self.var_407ba908))
	{
		self.var_407ba908 = [];
	}
	else if(!IsArray(self.var_407ba908))
	{
		self.var_407ba908 = Array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "special_crossbow_dw_upgraded";
	if(!isdefined(self.var_407ba908))
	{
		self.var_407ba908 = [];
	}
	else if(!IsArray(self.var_407ba908))
	{
		self.var_407ba908 = Array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "launcher_multi_upgraded";
	self.var_407ba908 = Array::randomize(self.var_407ba908);
	self.var_d86e8be = 0;
	self thread function_424b6fe8();
}

/*
	Name: function_fbbc8608
	Namespace: namespace_e0675efb
	Checksum: 0xA64DD254
	Offset: 0x25B0
	Size: 0x11B
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
	self LUINotifyEvent(&"trial_complete", 3, &"ZM_STALINGRAD_CHALLENGE_COMPLETE", var_d6b47fd3, n_challenge_index - 1);
	level scoreevents::processScoreEvent("solo_challenge_stalingrad", self);
}

/*
	Name: function_e8547a5b
	Namespace: namespace_e0675efb
	Checksum: 0x4385644C
	Offset: 0x26D8
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
	Namespace: namespace_e0675efb
	Checksum: 0x3658E796
	Offset: 0x2738
	Size: 0x119
	Parameters: 2
	Flags: None
*/
function function_27f6c3cd(player, n_challenge_index)
{
	switch(n_challenge_index)
	{
		case 1:
		{
			player function_e8547a5b(player._challenges.var_4687355c.str_info);
			break;
		}
		case 2:
		{
			player function_e8547a5b(player._challenges.var_b88ea497.str_info);
			break;
		}
		case 3:
		{
			player function_e8547a5b(player._challenges.var_928c2a2e.str_info);
			break;
		}
		case 4:
		{
			player function_e8547a5b(player function_a107e8a5());
		}
	}
}

/*
	Name: function_33e91747
	Namespace: namespace_e0675efb
	Checksum: 0x65812C9A
	Offset: 0x2860
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function function_33e91747(n_challenge_index, var_fe2fb4b9)
{
	self clientfield::set_to_player("challenge" + n_challenge_index + "state", var_fe2fb4b9);
}

/*
	Name: function_23c9ffd3
	Namespace: namespace_e0675efb
	Checksum: 0xC8F45806
	Offset: 0x28B0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function function_23c9ffd3(trigger)
{
	self notify("hash_23c9ffd3");
	self endon("hash_23c9ffd3");
	while(1)
	{
		wait(0.5);
		if(!isdefined(self))
		{
			break;
		}
		if(!isdefined(trigger) || Distance(self.origin, trigger.stub.origin) > trigger.stub.radius)
		{
			self clientfield::set_player_uimodel("trialWidget.visible", 0);
			break;
		}
	}
}

/*
	Name: function_3ae0d6d5
	Namespace: namespace_e0675efb
	Checksum: 0xBFDAD4BA
	Offset: 0x2978
	Size: 0x5DF
	Parameters: 1
	Flags: None
*/
function function_3ae0d6d5(e_player)
{
	if(self.stub.related_parent.script_int == e_player GetEntityNumber())
	{
		if(e_player flag::get("flag_player_initialized_reward"))
		{
			self function_cb2c15eb(e_player, &"ZM_STALINGRAD_CHALLENGE_REWARD_TAKE");
			if(self.stub.related_parent.var_30ff0d6c.var_15fa438f == 2)
			{
				w_current = e_player GetCurrentWeapon();
				if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponNone || (isdefined(w_current.isHeroWeapon) && w_current.isHeroWeapon) || (isdefined(w_current.isgadget) && w_current.isgadget))
				{
					self function_cb2c15eb(e_player, "");
					return 0;
				}
			}
			else if(self.stub.related_parent.var_30ff0d6c.var_15fa438f == 3)
			{
				a_perks = e_player GetPerks();
				if(a_perks.size == level._custom_perks.size)
				{
					self function_cb2c15eb(e_player, "");
					return 0;
				}
			}
			return 1;
		}
		for(i = 1; i <= 4; i++)
		{
			var_18c0ce2f = self.stub.related_parent.var_b2a5207f GetTagOrigin("tag_0" + i);
			if(e_player function_3f67a723(var_18c0ce2f, 15, 0) && Distance(e_player.origin, self.stub.origin) < 500)
			{
				self function_27f6c3cd(e_player, i);
				e_player clientfield::set_player_uimodel("trialWidget.icon", i - 1);
				e_player clientfield::set_player_uimodel("trialWidget.visible", 1);
				if(i == 4)
				{
					e_player clientfield::set_player_uimodel("trialWidget.progress", e_player clientfield::get_player_uimodel("zmInventory.progress_egg"));
				}
				else
				{
					e_player clientfield::set_player_uimodel("trialWidget.progress", e_player.var_873a3e27[i]);
				}
				if(!e_player flag::get("flag_player_completed_challenge_" + i))
				{
					self function_cb2c15eb(e_player, "");
					e_player thread function_23c9ffd3(self);
					var_a51a0ba6 = 1;
					return 1;
					continue;
				}
				if(!e_player flag::get("flag_player_collected_reward_" + i) && (!isdefined(e_player.var_c981566c) && e_player.var_c981566c))
				{
					self function_cb2c15eb(e_player, &"ZM_STALINGRAD_CHALLENGE_REWARD");
					e_player thread function_23c9ffd3(self);
					var_a51a0ba6 = 1;
					return 1;
					continue;
				}
				self function_cb2c15eb(e_player, "");
				e_player thread function_23c9ffd3(self);
				var_a51a0ba6 = 1;
				return 1;
			}
		}
		if(e_player function_9ffe5c12())
		{
			self function_cb2c15eb(e_player, &"ZM_STALINGRAD_GRAVE_FIRE");
			e_player clientfield::set_player_uimodel("trialWidget.visible", 0);
			return 1;
		}
		self function_cb2c15eb(e_player, "");
		e_player clientfield::set_player_uimodel("trialWidget.visible", 0);
		return 0;
	}
	else
	{
		self function_cb2c15eb(e_player, "");
		return 0;
	}
}

/*
	Name: function_3f67a723
	Namespace: namespace_e0675efb
	Checksum: 0x333855AB
	Offset: 0x2F60
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
	Name: function_424b6fe8
	Namespace: namespace_e0675efb
	Checksum: 0x81CB2A98
	Offset: 0x3020
	Size: 0x48F
	Parameters: 0
	Flags: None
*/
function function_424b6fe8()
{
	while(1)
	{
		self waittill("trigger_activated", e_who);
		if(self.script_int == e_who GetEntityNumber())
		{
			if(e_who flag::get("flag_player_initialized_reward"))
			{
				if(self.var_30ff0d6c.var_15fa438f == 2)
				{
					w_current = e_who GetCurrentWeapon();
					if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponNone || (isdefined(w_current.isHeroWeapon) && w_current.isHeroWeapon) || (isdefined(w_current.isgadget) && w_current.isgadget))
					{
						continue;
					}
					if(e_who bgb::is_enabled("zm_bgb_disorderly_combat"))
					{
						continue;
					}
				}
				else if(self.var_30ff0d6c.var_15fa438f == 3)
				{
					a_perks = e_who GetPerks();
					if(a_perks.size == level._custom_perks.size)
					{
						continue;
					}
				}
				e_who clientfield::increment_to_player("interact_rumble");
				self.s_unitrigger.playertrigger[e_who.entity_num] function_cb2c15eb(e_who, "");
				e_who function_640cd978(self.var_30ff0d6c);
				if(isdefined(self.var_30ff0d6c))
				{
					self.var_30ff0d6c delete();
				}
			}
			else
			{
				for(i = 1; i <= 4; i++)
				{
					var_18c0ce2f = self.var_b2a5207f GetTagOrigin("tag_0" + i);
					if(e_who function_3f67a723(var_18c0ce2f, 15, 0) && Distance(e_who.origin, self.origin) < 500)
					{
						if(isdefined(e_who.var_c981566c) && e_who.var_c981566c)
						{
							break;
						}
						if(e_who flag::get("flag_player_completed_challenge_" + i) && !e_who flag::get("flag_player_collected_reward_" + i))
						{
							e_who clientfield::increment_to_player("interact_rumble");
							self.s_unitrigger.playertrigger[e_who.entity_num] function_cb2c15eb(e_who, "");
							self function_1d22626(e_who, i);
							break;
						}
					}
				}
				if(e_who function_9ffe5c12())
				{
					self.s_unitrigger.playertrigger[e_who.entity_num] function_cb2c15eb(e_who, "");
					self function_1d22626(e_who, 5);
					e_who thread function_a231bc42();
				}
			}
		}
	}
}

/*
	Name: function_a2d25f82
	Namespace: namespace_e0675efb
	Checksum: 0x363EEB63
	Offset: 0x34B8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_a2d25f82(var_15fa438f)
{
	self endon("disconnect");
	/#
		self endon("hash_f9ff0ae7");
	#/
	self flag::wait_till("flag_player_completed_challenge_" + var_15fa438f);
	self thread namespace_dcf9c464::function_73928e79();
}

/*
	Name: function_1d22626
	Namespace: namespace_e0675efb
	Checksum: 0x5147850E
	Offset: 0x3520
	Size: 0x40B
	Parameters: 2
	Flags: None
*/
function function_1d22626(e_player, var_15fa438f)
{
	e_player endon("disconnect");
	var_7bb343ef = (0, 90, 0);
	var_93571595 = struct::get_array("s_challenge_reward", "targetname");
	foreach(var_4bcd3b3a in var_93571595)
	{
		if(var_4bcd3b3a.script_int == e_player GetEntityNumber())
		{
			break;
		}
	}
	switch(var_15fa438f)
	{
		case 1:
		{
			var_17b3dc96 = "p7_zm_power_up_max_ammo";
			var_4bcd3b3a.var_e1513629 = VectorScale((0, 0, 1), 6);
			var_4bcd3b3a.var_b90d551 = var_7bb343ef;
			break;
		}
		case 2:
		{
			var_17b3dc96 = self.var_407ba908[self.var_d86e8be];
			if(self.var_d86e8be == self.var_407ba908.size - 1)
			{
				self.var_d86e8be = 0;
			}
			else
			{
				self.var_d86e8be++;
			}
			var_6b215f76 = AnglesToRight(var_4bcd3b3a.angles) * 5 + AnglesToForward(var_4bcd3b3a.angles) * -2;
			var_4bcd3b3a.var_e1513629 = var_6b215f76 + (0, 0, 1);
			var_4bcd3b3a.var_b90d551 = var_7bb343ef;
			break;
		}
		case 3:
		{
			var_17b3dc96 = "zombie_pickup_perk_bottle";
			var_1bfa1f7e = AnglesToForward(var_4bcd3b3a.angles) * -2;
			var_4bcd3b3a.var_e1513629 = var_1bfa1f7e + VectorScale((0, 0, 1), 7);
			var_4bcd3b3a.var_b90d551 = var_7bb343ef;
			break;
		}
		case 4:
		{
			var_17b3dc96 = "wpn_t7_zmb_dlc3_gauntlet_dragon_world";
			var_4bcd3b3a.var_e1513629 = VectorScale((1, 0, 0), 2);
			var_4bcd3b3a.var_b90d551 = VectorScale((-1, 0, 0), 100);
			break;
		}
		case 5:
		{
			var_17b3dc96 = "wpn_t7_zmb_monkey_bomb_world";
			var_4bcd3b3a.var_e1513629 = (0, 0, 1);
			var_4bcd3b3a.var_b90d551 = var_7bb343ef;
			break;
		}
	}
	e_player.var_c981566c = 1;
	self function_b1f54cb4(e_player, var_4bcd3b3a, var_17b3dc96, 30);
	self.var_30ff0d6c clientfield::set("powerup_fx", 1);
	self.var_30ff0d6c.var_15fa438f = var_15fa438f;
	e_player flag::set("flag_player_initialized_reward");
	self thread function_1ad9d1a0(e_player, 30 * -1);
}

/*
	Name: function_1ad9d1a0
	Namespace: namespace_e0675efb
	Checksum: 0x80BCB26C
	Offset: 0x3938
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function function_1ad9d1a0(e_player, n_dist)
{
	self endon("hash_422dba45");
	self.var_3609adde MoveZ(n_dist, 12, 6);
	self.var_2a9b65c7 MoveZ(n_dist, 12, 6);
	self.var_79dc7980 MoveZ(n_dist, 12, 6);
	self.var_30ff0d6c MoveZ(n_dist, 12, 6);
	self.var_3609adde PlayLoopSound("zmb_challenge_skel_arm_lp", 1);
	self.var_3609adde waittill("movedone");
	if(isdefined(e_player))
	{
		e_player flag::clear("flag_player_initialized_reward");
		e_player.var_c981566c = undefined;
	}
	if(isdefined(self.var_30ff0d6c))
	{
		self.var_30ff0d6c delete();
	}
	self.var_3609adde delete();
	self.var_2a9b65c7 delete();
	self.var_79dc7980 delete();
}

/*
	Name: function_b1f54cb4
	Namespace: namespace_e0675efb
	Checksum: 0xA49CE649
	Offset: 0x3AE0
	Size: 0x533
	Parameters: 4
	Flags: None
*/
function function_b1f54cb4(e_player, var_4bcd3b3a, var_17b3dc96, var_21d0cf95)
{
	var_f6c28cea = (2, 0, -6.5);
	var_e97ebb83 = (3.5, 0, -18.5);
	var_f39a667b = (1, 0, -1);
	var_48cc013c = VectorScale((1, 0, 0), 90);
	if(!isdefined(self.var_3609adde))
	{
		self.var_3609adde = util::spawn_model("c_zom_dlc1_skeleton_zombie_body_s_rarm", var_4bcd3b3a.origin, var_4bcd3b3a.angles);
		self.var_2a9b65c7 = util::spawn_model("p7_skulls_bones_arm_lower", var_4bcd3b3a.origin + var_f6c28cea, VectorScale((1, 0, 0), 180));
		self.var_79dc7980 = util::spawn_model("p7_skulls_bones_arm_lower", var_4bcd3b3a.origin + var_e97ebb83, VectorScale((1, 0, 0), 180));
	}
	else
	{
		self notify("hash_422dba45");
		self.var_3609adde StopLoopSound(0.25);
		self.var_3609adde moveto(var_4bcd3b3a.origin, 1);
		self.var_2a9b65c7 moveto(var_4bcd3b3a.origin + var_f6c28cea, 1);
		self.var_79dc7980 moveto(var_4bcd3b3a.origin + var_e97ebb83, 1);
		self.var_3609adde waittill("movedone");
		if(isdefined(self.var_3609adde.var_9cab68e0) && self.var_3609adde.var_9cab68e0)
		{
			self.var_3609adde.origin = self.var_3609adde.origin - var_f39a667b;
			self.var_3609adde.angles = self.var_3609adde.angles - var_48cc013c;
			self.var_3609adde.var_9cab68e0 = undefined;
		}
	}
	var_51a2f105 = var_4bcd3b3a.origin + var_4bcd3b3a.var_e1513629;
	var_9ef5a0dc = var_4bcd3b3a.angles + var_4bcd3b3a.var_b90d551;
	switch(var_17b3dc96)
	{
		case "ar_famas_upgraded":
		case "ar_garand_upgraded":
		case "launcher_multi_upgraded":
		case "smg_mp40_upgraded":
		case "special_crossbow_dw_upgraded":
		{
			self.var_30ff0d6c = zm_utility::spawn_buildkit_weapon_model(e_player, GetWeapon(var_17b3dc96), undefined, var_51a2f105, var_9ef5a0dc);
			self.var_30ff0d6c.str_weapon_name = var_17b3dc96;
			break;
		}
		case "wpn_t7_zmb_dlc3_gauntlet_dragon_world":
		{
			self.var_30ff0d6c = util::spawn_model(var_17b3dc96, var_51a2f105, var_9ef5a0dc);
			self.var_3609adde.origin = self.var_3609adde.origin + var_f39a667b;
			self.var_3609adde.angles = self.var_3609adde.angles + var_48cc013c;
			self.var_3609adde.var_9cab68e0 = 1;
			break;
		}
		case default:
		{
			self.var_30ff0d6c = util::spawn_model(var_17b3dc96, var_51a2f105, var_9ef5a0dc);
			break;
		}
	}
	self.var_3609adde MoveZ(var_21d0cf95, 1);
	self.var_2a9b65c7 MoveZ(var_21d0cf95, 1);
	self.var_79dc7980 MoveZ(var_21d0cf95, 1);
	self.var_30ff0d6c MoveZ(var_21d0cf95, 1);
	self.var_3609adde playsound("zmb_challenge_skel_arm_up");
	wait(0.05);
	self.var_3609adde clientfield::increment("challenge_arm_reveal");
	self.var_3609adde waittill("movedone");
	self.var_3609adde clientfield::increment("challenge_arm_reveal");
}

/*
	Name: function_640cd978
	Namespace: namespace_e0675efb
	Checksum: 0x3FF0C747
	Offset: 0x4020
	Size: 0x1E5
	Parameters: 1
	Flags: None
*/
function function_640cd978(var_30ff0d6c)
{
	switch(var_30ff0d6c.var_15fa438f)
	{
		case 1:
		{
			level thread zm_powerups::specific_powerup_drop("full_ammo", self.origin);
			break;
		}
		case 2:
		{
			if(isdefined(var_30ff0d6c.str_weapon_name))
			{
				var_e564b69e = GetWeapon(var_30ff0d6c.str_weapon_name);
			}
			self thread swap_weapon(var_e564b69e);
			break;
		}
		case 3:
		{
			self thread function_6131520e();
			break;
		}
		case 4:
		{
			self namespace_2ef08cd1::function_99a68dd();
			self notify("hash_4e21f047");
			level flag::set("dragon_gauntlet_acquired");
			break;
		}
		case 5:
		{
			self function_c46e4bfe();
			break;
		}
	}
	self flag::set("flag_player_collected_reward_" + var_30ff0d6c.var_15fa438f);
	if(var_30ff0d6c.var_15fa438f > 0 && var_30ff0d6c.var_15fa438f < 4)
	{
		self function_33e91747(var_30ff0d6c.var_15fa438f, 2);
	}
	self flag::clear("flag_player_initialized_reward");
	self.var_c981566c = undefined;
}

/*
	Name: swap_weapon
	Namespace: namespace_e0675efb
	Checksum: 0x72A6B64B
	Offset: 0x4210
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function swap_weapon(var_f4612f93)
{
	w_current = self GetCurrentWeapon();
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	if(self.IS_DRINKING > 0)
	{
		return;
	}
	if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponNone)
	{
		return;
	}
	if(!self HasWeapon(var_f4612f93.rootweapon, 1))
	{
		self take_old_weapon_and_give_new(w_current, var_f4612f93);
	}
	else
	{
		self giveMaxAmmo(var_f4612f93);
	}
}

/*
	Name: take_old_weapon_and_give_new
	Namespace: namespace_e0675efb
	Checksum: 0x119ED20C
	Offset: 0x4320
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function take_old_weapon_and_give_new(w_current, var_f4612f93)
{
	var_d2f4cbdf = self GetWeaponsListPrimaries();
	if(isdefined(var_d2f4cbdf) && var_d2f4cbdf.size >= zm_utility::get_player_weapon_limit(self))
	{
		self TakeWeapon(w_current);
	}
	var_6fc96b00 = self zm_weapons::give_build_kit_weapon(var_f4612f93);
	self GiveWeapon(var_6fc96b00);
	self SwitchToWeapon(var_6fc96b00);
}

/*
	Name: function_3420bc2f
	Namespace: namespace_e0675efb
	Checksum: 0x4F007CCE
	Offset: 0x4400
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function function_3420bc2f(var_f4612f93)
{
	var_6f845c3d = self GetWeaponsList(1);
	foreach(var_cdee635d in var_6f845c3d)
	{
		if(var_cdee635d.type === "melee")
		{
			self TakeWeapon(var_cdee635d);
			break;
		}
	}
	var_6fc96b00 = self zm_weapons::give_build_kit_weapon(var_f4612f93);
	self GiveWeapon(var_6fc96b00);
}

/*
	Name: function_6131520e
	Namespace: namespace_e0675efb
	Checksum: 0x74032B5D
	Offset: 0x4520
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function function_6131520e()
{
	self endon("disconnect");
	a_str_perks = getArrayKeys(level._custom_perks);
	a_str_perks = Array::randomize(a_str_perks);
	foreach(str_perk in a_str_perks)
	{
		if(!self hasPerk(str_perk))
		{
			self zm_perks::give_perk(str_perk, 0);
			break;
		}
	}
}

/*
	Name: function_1adeaa1c
	Namespace: namespace_e0675efb
	Checksum: 0xBC8E04BC
	Offset: 0x4620
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_1adeaa1c()
{
	var_4562cc04 = level.perk_purchase_limit;
	if(self flag::get("flag_player_collected_reward_3"))
	{
		var_4562cc04++;
	}
	return var_4562cc04;
}

/*
	Name: function_a107e8a5
	Namespace: namespace_e0675efb
	Checksum: 0x9F6413C6
	Offset: 0x4668
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_a107e8a5()
{
	if(level flag::get("gauntlet_step_4_complete"))
	{
		return &"ZM_STALINGRAD_CHALLENGE_4_6";
	}
	else if(level flag::get("gauntlet_step_3_complete"))
	{
		return &"ZM_STALINGRAD_CHALLENGE_4_5";
	}
	else if(level flag::get("gauntlet_step_2_complete"))
	{
		return &"ZM_STALINGRAD_CHALLENGE_4_4";
	}
	else if(level flag::get("egg_awakened"))
	{
		return &"ZM_STALINGRAD_CHALLENGE_4_3";
	}
	else if(level flag::get("dragon_egg_acquired"))
	{
		return &"ZM_STALINGRAD_CHALLENGE_4_2";
	}
	else
	{
		return &"ZM_STALINGRAD_CHALLENGE_4_1";
	}
}

/*
	Name: function_960bfb56
	Namespace: namespace_e0675efb
	Checksum: 0xF645FC5D
	Offset: 0x4770
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_960bfb56()
{
	self endon("disconnect");
	level.var_940aa0f3 = self;
	zm_spawner::register_zombie_death_event_callback(&function_f08cb3ce);
	self thread function_e425ba86();
	self flag::wait_till("flag_player_completed_challenge_1");
	zm_spawner::deregister_zombie_death_event_callback(&function_f08cb3ce);
	level.var_940aa0f3 = undefined;
}

/*
	Name: function_f08cb3ce
	Namespace: namespace_e0675efb
	Checksum: 0x200BFE8D
	Offset: 0x4818
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_f08cb3ce(e_attacker)
{
	if(isdefined(self) && self.var_9a02a614 === "napalm" && e_attacker === level.var_940aa0f3)
	{
		if(zm_utility::is_headshot(self.damageWeapon, self.damagelocation, self.damageMod))
		{
			e_attacker notify("hash_c1783c94");
		}
	}
}

/*
	Name: function_e425ba86
	Namespace: namespace_e0675efb
	Checksum: 0x8F7E3D21
	Offset: 0x4898
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_e425ba86()
{
	self endon("hash_72d86ab9");
	self waittill("disconnect");
	zm_spawner::deregister_zombie_death_event_callback(&function_f08cb3ce);
	level.var_940aa0f3 = undefined;
}

/*
	Name: function_f1c59ae
	Namespace: namespace_e0675efb
	Checksum: 0x120B95B1
	Offset: 0x48E8
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function function_f1c59ae()
{
	self endon("disconnect");
	self.var_c678bf7b = [];
	while(self.var_c678bf7b.size < 3)
	{
		self waittill("hash_2e47bc4a");
		if(!Array::contains(self.var_c678bf7b, level.var_9d19c7e))
		{
			Array::add(self.var_c678bf7b, level.var_9d19c7e);
			self notify("hash_337fabcf");
		}
	}
	self.var_c678bf7b = undefined;
}

/*
	Name: function_76bcffc2
	Namespace: namespace_e0675efb
	Checksum: 0x5E9966BD
	Offset: 0x4988
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function function_76bcffc2()
{
	self endon("hash_72d86ab9");
	self endon("disconnect");
	while(1)
	{
		level waittill("raz_arm_detach", e_attacker);
		if(e_attacker === self)
		{
			self notify("hash_d7d3166");
		}
	}
}

/*
	Name: function_dec401c2
	Namespace: namespace_e0675efb
	Checksum: 0xEB58F5BD
	Offset: 0x49F0
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_dec401c2()
{
	self endon("disconnect");
	while(!self flag::get("flag_player_completed_challenge_1"))
	{
		self waittill("hash_2d087eca");
		self notify("hash_4f70cd59");
	}
}

/*
	Name: function_c169b7dd
	Namespace: namespace_e0675efb
	Checksum: 0xEBB3E984
	Offset: 0x4A48
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function function_c169b7dd()
{
	self endon("hash_72d86ab9");
	self endon("disconnect");
	while(1)
	{
		level waittill("raz_mask_destroyed", e_attacker);
		if(e_attacker === self)
		{
			self notify("hash_296e52f0");
		}
	}
}

/*
	Name: function_5efd7abf
	Namespace: namespace_e0675efb
	Checksum: 0xF5875C33
	Offset: 0x4AB0
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_5efd7abf()
{
	self endon("disconnect");
	self endon("hash_72d86ab9");
	while(1)
	{
		self waittill("hash_690aad79");
		self thread function_8494f9a2();
	}
}

/*
	Name: function_8494f9a2
	Namespace: namespace_e0675efb
	Checksum: 0x969CBB69
	Offset: 0x4B00
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_8494f9a2()
{
	self endon("player_downed");
	self endon("disconnect");
	self notify("hash_2dcfeeb9");
	self endon("hash_2dcfeeb9");
	wait(5);
	self notify("hash_9b75c22b");
}

/*
	Name: function_4322fb5f
	Namespace: namespace_e0675efb
	Checksum: 0xF4D37753
	Offset: 0x4B50
	Size: 0x11D
	Parameters: 0
	Flags: None
*/
function function_4322fb5f()
{
	self endon("disconnect");
	var_d0e8cd34 = GetEnt("finger_trap_slide_trigger", "targetname");
	level.var_7ee8825e = self;
	while(!self flag::get("flag_player_completed_challenge_2"))
	{
		self waittill("hash_ad9aba38");
		while(level flag::get("finger_trap_on") && !self flag::get("flag_player_completed_challenge_2"))
		{
			var_d0e8cd34 waittill("trigger", e_who);
			if(e_who === self && self IsSliding())
			{
				self function_2e7f6910();
			}
		}
	}
	level.var_7ee8825e = undefined;
}

/*
	Name: function_2e7f6910
	Namespace: namespace_e0675efb
	Checksum: 0xB7CE5D66
	Offset: 0x4C78
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function function_2e7f6910()
{
	self endon("disconnect");
	self endon("hash_b7166543");
	var_ac9fe035 = 3;
	self util::delay_notify(var_ac9fe035, "stop_slide_kill_watcher");
	while(!self flag::get("flag_player_completed_challenge_2"))
	{
		self waittill("hash_2637f64f");
		self notify("hash_fb461733");
	}
}

/*
	Name: function_f427e9ad
	Namespace: namespace_e0675efb
	Checksum: 0x129355B
	Offset: 0x4D10
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_f427e9ad()
{
	self endon("disconnect");
	level.var_7d70299a = self;
	zm_spawner::register_zombie_death_event_callback(&function_9903d501);
	self thread function_b44b0c5d();
	self flag::wait_till("flag_player_completed_challenge_2");
	zm_spawner::deregister_zombie_death_event_callback(&function_9903d501);
	level.var_7d70299a = undefined;
}

/*
	Name: function_9903d501
	Namespace: namespace_e0675efb
	Checksum: 0x9FC308ED
	Offset: 0x4DB8
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function function_9903d501(e_attacker)
{
	if(isdefined(self) && self.damageWeapon === GetWeapon("dragonshield") && e_attacker === level.var_7d70299a)
	{
		e_attacker notify("hash_893ea7f8");
	}
}

/*
	Name: function_b44b0c5d
	Namespace: namespace_e0675efb
	Checksum: 0x21F56CA1
	Offset: 0x4E18
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_b44b0c5d()
{
	self endon("hash_98dae522");
	self waittill("disconnect");
	zm_spawner::deregister_zombie_death_event_callback(&function_9903d501);
	level.var_7d70299a = undefined;
}

/*
	Name: function_4e107409
	Namespace: namespace_e0675efb
	Checksum: 0xD35EE8C0
	Offset: 0x4E68
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function function_4e107409()
{
	self endon("hash_98dae522");
	self endon("disconnect");
	while(1)
	{
		self waittill("hash_696f953");
		self notify("hash_af412261");
	}
}

/*
	Name: function_81adc498
	Namespace: namespace_e0675efb
	Checksum: 0x27C345A4
	Offset: 0x4EB8
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function function_81adc498()
{
	self endon("disconnect");
	self.var_e34aa037 = 0;
	while(!self flag::get("flag_player_completed_challenge_2"))
	{
		self waittill("hash_3d742bf8");
		self notify("hash_6d4d866e");
	}
	self.var_e34aa037 = undefined;
}

/*
	Name: function_64e8cc03
	Namespace: namespace_e0675efb
	Checksum: 0xCCAE5B97
	Offset: 0x4F20
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_64e8cc03()
{
	self endon("disconnect");
	level.var_33f7b0fc = self;
	zm_spawner::register_zombie_death_event_callback(&function_f99f9ce7);
	self thread function_f65cfb93();
	self flag::wait_till("flag_player_completed_challenge_2");
	zm_spawner::deregister_zombie_death_event_callback(&function_f99f9ce7);
	level.var_33f7b0fc = undefined;
}

/*
	Name: function_f99f9ce7
	Namespace: namespace_e0675efb
	Checksum: 0x469379BF
	Offset: 0x4FC8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_f99f9ce7(e_attacker)
{
	if(isdefined(self) && self.var_9a02a614 === "sparky" && e_attacker === level.var_33f7b0fc)
	{
		if(zm_utility::is_headshot(self.damageWeapon, self.damagelocation, self.damageMod))
		{
			e_attacker notify("hash_935000d7");
		}
	}
}

/*
	Name: function_f65cfb93
	Namespace: namespace_e0675efb
	Checksum: 0x6EB08877
	Offset: 0x5048
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_f65cfb93()
{
	self endon("hash_98dae522");
	self waittill("disconnect");
	zm_spawner::deregister_zombie_death_event_callback(&function_f99f9ce7);
	level.var_33f7b0fc = undefined;
}

/*
	Name: function_31d5f655
	Namespace: namespace_e0675efb
	Checksum: 0xEA39D80B
	Offset: 0x5098
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function function_31d5f655()
{
	self endon("hash_98dae522");
	self endon("disconnect");
	while(1)
	{
		self waittill("hash_f7608efe", n_kill_count);
		if(n_kill_count >= 8)
		{
			self notify("hash_2148919c");
		}
	}
}

/*
	Name: function_75fdfc25
	Namespace: namespace_e0675efb
	Checksum: 0x7EF227EF
	Offset: 0x5100
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_75fdfc25()
{
	self endon("hash_bedd5f8b");
	self endon("disconnect");
	while(1)
	{
		self waittill("hash_2e47bc4a");
		self thread function_638f34fd();
	}
}

/*
	Name: function_638f34fd
	Namespace: namespace_e0675efb
	Checksum: 0x1111BD2E
	Offset: 0x5150
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function function_638f34fd()
{
	self endon("hash_4cea57aa");
	self endon("bled_out");
	self endon("disconnect");
	var_3275089e = 0;
	level waittill("between_round_over");
	while(var_3275089e < 4)
	{
		level waittill("end_of_round");
		var_3275089e++;
	}
	self notify("hash_2e126bd2");
}

/*
	Name: function_2bf9f9d4
	Namespace: namespace_e0675efb
	Checksum: 0xEE9C95D
	Offset: 0x51D8
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function function_2bf9f9d4()
{
	self endon("disconnect");
	self.var_f12fd515 = [];
	while(self.var_f12fd515.size < 3)
	{
		self waittill("hash_e442448", n_kill_count, str_location);
		if(n_kill_count >= 3)
		{
			if(!Array::contains(self.var_f12fd515, str_location))
			{
				Array::add(self.var_f12fd515, str_location);
				self notify("hash_80ff169");
			}
		}
	}
	self.var_f12fd515 = undefined;
}

/*
	Name: function_dcbd7aec
	Namespace: namespace_e0675efb
	Checksum: 0xC41D13C7
	Offset: 0x5298
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_dcbd7aec()
{
	self endon("disconnect");
	level.var_c6d8defd = self;
	zm_spawner::register_zombie_death_event_callback(&function_22664e38);
	self thread function_cf22215c();
	self flag::wait_till("flag_player_completed_challenge_3");
	zm_spawner::deregister_zombie_death_event_callback(&function_22664e38);
	level.var_c6d8defd = undefined;
}

/*
	Name: function_22664e38
	Namespace: namespace_e0675efb
	Checksum: 0x7EC3A9C
	Offset: 0x5340
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_22664e38(e_attacker)
{
	if(isdefined(self) && (self.damageWeapon === GetWeapon("launcher_dragon_fire") || self.damageWeapon === GetWeapon("launcher_dragon_fire_upgraded")))
	{
		if(isdefined(e_attacker) && e_attacker.player === level.var_c6d8defd)
		{
			e_attacker.player notify("hash_e20d7700");
		}
	}
}

/*
	Name: function_cf22215c
	Namespace: namespace_e0675efb
	Checksum: 0x36A49F4E
	Offset: 0x53E0
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_cf22215c()
{
	self endon("hash_bedd5f8b");
	self waittill("disconnect");
	zm_spawner::deregister_zombie_death_event_callback(&function_22664e38);
	level.var_c6d8defd = undefined;
}

/*
	Name: function_3d0619b6
	Namespace: namespace_e0675efb
	Checksum: 0xB5E20530
	Offset: 0x5430
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_3d0619b6()
{
	self endon("disconnect");
	level.var_471bf3e9 = self;
	zm_spawner::register_zombie_death_event_callback(&function_b3fffcec);
	self thread function_c54980a6();
	self flag::wait_till("flag_player_completed_challenge_3");
	zm_spawner::deregister_zombie_death_event_callback(&function_b3fffcec);
	level.var_471bf3e9 = undefined;
}

/*
	Name: function_b3fffcec
	Namespace: namespace_e0675efb
	Checksum: 0xD1313B18
	Offset: 0x54D8
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_b3fffcec(e_attacker)
{
	if(isdefined(self) && self.damageWeapon === GetWeapon("turret_bo3_germans_zm_stalingrad"))
	{
		if(level.var_ffcc580a.var_3a61625b === level.var_471bf3e9)
		{
			level.var_471bf3e9 notify("hash_ec1ecfdf");
		}
	}
}

/*
	Name: function_c54980a6
	Namespace: namespace_e0675efb
	Checksum: 0xB28919FC
	Offset: 0x5548
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_c54980a6()
{
	self endon("hash_bedd5f8b");
	self waittill("disconnect");
	zm_spawner::deregister_zombie_death_event_callback(&function_b3fffcec);
	level.var_471bf3e9 = undefined;
}

/*
	Name: function_cdeaa5f
	Namespace: namespace_e0675efb
	Checksum: 0xFF8D1DF7
	Offset: 0x5598
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function function_cdeaa5f()
{
	self endon("hash_bedd5f8b");
	self endon("disconnect");
	while(1)
	{
		level waittill("all_sentinel_arms_destroyed", b_same_arms_attacker, e_attacker);
		if(isdefined(b_same_arms_attacker) && b_same_arms_attacker && e_attacker === self)
		{
			self notify("hash_c61c5576");
		}
	}
}

/*
	Name: function_e480fc42
	Namespace: namespace_e0675efb
	Checksum: 0xCC1F2C92
	Offset: 0x5618
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function function_e480fc42()
{
	self endon("hash_bedd5f8b");
	self endon("disconnect");
	while(1)
	{
		level waittill("sentinel_camera_destroyed", e_attacker);
		if(e_attacker === self)
		{
			self notify("hash_a019db0d");
		}
	}
}

/*
	Name: function_2ce855f3
	Namespace: namespace_e0675efb
	Checksum: 0x553A701C
	Offset: 0x5680
	Size: 0x1BB
	Parameters: 1
	Flags: None
*/
function function_2ce855f3(s_challenge)
{
	self endon("disconnect");
	/#
		self endon("hash_f9ff0ae7");
		self endon("Dev Block strings are not supported" + s_challenge.n_index);
	#/
	if(isdefined(s_challenge.var_c0e6cb4e))
	{
		self thread [[s_challenge.var_c0e6cb4e]]();
	}
	if(!isdefined(self.var_873a3e27))
	{
		self.var_873a3e27 = [];
	}
	self.var_873a3e27[s_challenge.n_index] = 0;
	var_80792f67 = s_challenge.n_count;
	var_ea184c3d = s_challenge.n_count;
	while(var_80792f67 > 0)
	{
		self waittill(s_challenge.str_notify);
		var_80792f67--;
		self.var_873a3e27[s_challenge.n_index] = 1 - var_80792f67 / var_ea184c3d;
	}
	self flag::set("flag_player_completed_challenge_" + s_challenge.n_index);
	self thread function_c79e93d1();
	if(s_challenge.n_index > 0 && s_challenge.n_index < 4)
	{
		self function_33e91747(s_challenge.n_index, 1);
	}
}

/*
	Name: function_c79e93d1
	Namespace: namespace_e0675efb
	Checksum: 0x709A35C2
	Offset: 0x5848
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_c79e93d1()
{
	a_flags = Array("flag_player_completed_challenge_1", "flag_player_completed_challenge_2", "flag_player_completed_challenge_3");
	foreach(flag in a_flags)
	{
		if(!self flag::get(flag))
		{
			self playsoundtoplayer("zmb_challenge_complete", self);
			return;
		}
	}
	self playsoundtoplayer("zmb_challenge_complete_all", self);
}

/*
	Name: function_974d5f1d
	Namespace: namespace_e0675efb
	Checksum: 0x22909A3
	Offset: 0x5958
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function function_974d5f1d()
{
	self endon("disconnect");
	a_flags = Array("flag_player_completed_challenge_1", "flag_player_completed_challenge_2", "flag_player_completed_challenge_3");
	self flag::wait_till_all(a_flags);
	self notify("hash_41370469");
}

/*
	Name: function_b2413e04
	Namespace: namespace_e0675efb
	Checksum: 0xC526FE8E
	Offset: 0x59D0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_b2413e04()
{
	var_fbc34b78 = GetEntArray("pr_g", "script_label");
	Array::run_all(var_fbc34b78, &Hide);
	level.var_b766c4a8 = 0;
	zm_spawner::register_zombie_death_event_callback(&function_60e1ca5f);
}

/*
	Name: function_60e1ca5f
	Namespace: namespace_e0675efb
	Checksum: 0xE33EE197
	Offset: 0x5A60
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function function_60e1ca5f(e_attacker)
{
	if(isdefined(self) && (self.damageWeapon === level.weaponZMCymbalMonkey || self.damageWeapon === level.w_cymbal_monkey_upgraded) && isPlayer(e_attacker))
	{
		level.var_b766c4a8++;
		/#
			if(isdefined(level.var_f9c3fe97) && level.var_f9c3fe97)
			{
				level.var_b766c4a8 = 50;
			}
		#/
		if(level.var_b766c4a8 >= 50)
		{
			level thread function_d632a808(self.origin);
			zm_spawner::deregister_zombie_death_event_callback(&function_60e1ca5f);
			level.var_b766c4a8 = undefined;
		}
	}
}

/*
	Name: function_d632a808
	Namespace: namespace_e0675efb
	Checksum: 0x53D41643
	Offset: 0x5B50
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function function_d632a808(var_51a2f105)
{
	var_dbd219ed = util::spawn_model("p7_zm_ctl_canteen", var_51a2f105 + VectorScale((0, 0, 1), 48));
	PlayFXOnTag(level._effect["drop_pod_reward_glow"], var_dbd219ed, "tag_origin");
	var_dbd219ed zm_unitrigger::create_unitrigger("");
	var_dbd219ed waittill("trigger_activated", e_who);
	e_who clientfield::increment_to_player("interact_rumble");
	var_dbd219ed zm_unitrigger::unregister_unitrigger(var_dbd219ed.s_unitrigger);
	var_dbd219ed delete();
	level flag::set("pr_m");
}

/*
	Name: function_4ca86c86
	Namespace: namespace_e0675efb
	Checksum: 0xD49590AC
	Offset: 0x5C88
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function function_4ca86c86()
{
	var_77797571 = struct::get_array("pr_b_spawn", "targetname");
	foreach(var_4af818ae in var_77797571)
	{
		if(var_4af818ae.script_int == self GetEntityNumber())
		{
			var_4af818ae thread function_d5da2be8(self);
		}
	}
	var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
	foreach(var_238c2594 in var_977659a7)
	{
		if(var_238c2594.script_int == self GetEntityNumber())
		{
			var_238c2594 thread function_38091734(self);
		}
	}
	self thread function_1fa81bf0();
}

/*
	Name: function_be89247c
	Namespace: namespace_e0675efb
	Checksum: 0xFEADA3E3
	Offset: 0x5E68
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_be89247c()
{
	if(!(isdefined(self.var_62708302) && self.var_62708302))
	{
		self clientfield::set_to_player("pr_b", self GetEntityNumber());
	}
	else
	{
		self clientfield::set_to_player("pr_b", 4);
	}
	if(!(isdefined(self.var_4aaffb90) && self.var_4aaffb90))
	{
		self clientfield::set_to_player("pr_c", self GetEntityNumber());
	}
	else
	{
		self clientfield::set_to_player("pr_c", 4);
	}
}

/*
	Name: function_d5da2be8
	Namespace: namespace_e0675efb
	Checksum: 0x530D0D5
	Offset: 0x5F58
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function function_d5da2be8(var_7ee6d8e6)
{
	self zm_unitrigger::create_unitrigger("");
	while(1)
	{
		self waittill("trigger_activated", e_who);
		if(e_who == var_7ee6d8e6)
		{
			e_who.var_62708302 = 1;
			e_who clientfield::set_to_player("pr_b", 4);
			e_who playsound("zmb_bouquet_pickup");
			break;
		}
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_38091734
	Namespace: namespace_e0675efb
	Checksum: 0xBF4E7CB9
	Offset: 0x6030
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function function_38091734(var_7ee6d8e6)
{
	level endon("player_disconnected_" + self.script_int);
	var_7ee6d8e6 function_34a8c625(self);
	var_7ee6d8e6 clientfield::set_to_player("pr_l_c", 1);
	self zm_unitrigger::create_unitrigger("");
	while(1)
	{
		self waittill("trigger_activated", e_who);
		if(e_who == var_7ee6d8e6)
		{
			e_who.var_4aaffb90 = 1;
			e_who clientfield::set_to_player("pr_c", 4);
			e_who playsound("zmb_candle_pickup");
			break;
		}
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_34a8c625
	Namespace: namespace_e0675efb
	Checksum: 0x51068890
	Offset: 0x6158
	Size: 0x155
	Parameters: 1
	Flags: None
*/
function function_34a8c625(s_candle)
{
	self endon("death");
	while(1)
	{
		self waittill("hash_10fa975d");
		var_7dda366c = self GetWeaponMuzzlePoint();
		var_9c5bd97c = self GetWeaponForwardDir();
		var_ae93125 = level.zombie_vars["dragonshield_knockdown_range"] * level.zombie_vars["dragonshield_knockdown_range"];
		var_cb78916d = s_candle.origin;
		var_8112eb05 = DistanceSquared(var_7dda366c, var_cb78916d);
		if(var_8112eb05 > var_ae93125)
		{
			continue;
		}
		v_normal = VectorNormalize(var_cb78916d - var_7dda366c);
		n_dot = VectorDot(var_9c5bd97c, v_normal);
		if(0 > n_dot)
		{
			continue;
		}
		return;
	}
}

/*
	Name: function_1fa81bf0
	Namespace: namespace_e0675efb
	Checksum: 0xE675E656
	Offset: 0x62B8
	Size: 0x1F1
	Parameters: 0
	Flags: None
*/
function function_1fa81bf0()
{
	self endon("death");
	self endon("hash_8b3a62f7");
	var_93571595 = struct::get_array("s_challenge_reward", "targetname");
	foreach(var_4bcd3b3a in var_93571595)
	{
		if(var_4bcd3b3a.script_int == self GetEntityNumber())
		{
			break;
		}
	}
	level flag::wait_till("pr_m");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(weapon === level.weaponZMCymbalMonkey || weapon === level.w_cymbal_monkey_upgraded)
		{
			grenade waittill("stationary");
			var_31dc18aa = 40 * 40;
			var_2931dc75 = DistanceSquared(grenade.origin, var_4bcd3b3a.origin);
			if(var_2931dc75 <= var_31dc18aa)
			{
				self.var_621ab6ef = 1;
				self function_14e16a1c(grenade);
				self.var_621ab6ef = undefined;
			}
		}
	}
}

/*
	Name: function_14e16a1c
	Namespace: namespace_e0675efb
	Checksum: 0xEC067B4
	Offset: 0x64B8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_14e16a1c(e_grenade)
{
	self endon("death");
	e_grenade endon("death");
	self waittill("hash_4c1b1a28");
	e_grenade clientfield::set("pr_gm_e_fx", 1);
	util::wait_network_frame();
	e_grenade delete();
}

/*
	Name: function_9ffe5c12
	Namespace: namespace_e0675efb
	Checksum: 0x52A02443
	Offset: 0x6540
	Size: 0x1B9
	Parameters: 0
	Flags: None
*/
function function_9ffe5c12()
{
	if(level flag::get("pr_m") && (isdefined(self.var_62708302) && self.var_62708302) && (isdefined(self.var_4aaffb90) && self.var_4aaffb90) && (isdefined(self.var_621ab6ef) && self.var_621ab6ef) && !self flag::get("flag_player_collected_reward_5"))
	{
		var_36d214f8 = struct::get_array("challenge_fire_struct", "targetname");
		foreach(var_47398c71 in var_36d214f8)
		{
			if(var_47398c71.script_int == self GetEntityNumber())
			{
				if(self function_3f67a723(var_47398c71.origin, 15, 0) && Distance(self.origin, var_47398c71.origin) < 500)
				{
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: function_a231bc42
	Namespace: namespace_e0675efb
	Checksum: 0x91E95A58
	Offset: 0x6708
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function function_a231bc42()
{
	self notify("hash_4c1b1a28");
	n_ent_num = self GetEntityNumber();
	var_32f0d800 = GetEnt("pr_g_b_" + n_ent_num, "targetname");
	var_32f0d800 show();
	var_79f3942a = GetEnt("pr_g_c_" + n_ent_num, "targetname");
	var_79f3942a show();
	var_79f3942a clientfield::set("pr_g_c_fx", 1);
	var_eaad475 = GetEnt("pr_g_cn_" + n_ent_num, "targetname");
	var_eaad475 show();
	self waittill("disconnect");
	var_79f3942a clientfield::set("pr_g_c_fx", 0);
	var_32f0d800 Hide();
	var_79f3942a Hide();
	var_eaad475 Hide();
}

/*
	Name: function_c46e4bfe
	Namespace: namespace_e0675efb
	Checksum: 0xD0E04E7
	Offset: 0x68B0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_c46e4bfe()
{
	self notify("hash_8b3a62f7");
	level.zombie_weapons[level.weaponZMCymbalMonkey].is_in_box = 0;
	level.zombie_weapons[level.w_cymbal_monkey_upgraded].is_in_box = 1;
	self _zm_weap_cymbal_monkey::player_give_cymbal_monkey_upgraded();
}

/*
	Name: function_b9b4ce34
	Namespace: namespace_e0675efb
	Checksum: 0x2A9BBFF5
	Offset: 0x6920
	Size: 0x10B
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
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			AddDebugCommand("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_16ba3a1e
	Namespace: namespace_e0675efb
	Checksum: 0x39C89873
	Offset: 0x6A38
	Size: 0x509
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
				foreach(e_player in level.players)
				{
					e_player flag::set("Dev Block strings are not supported");
					e_player notify("hash_fb393ffe");
					e_player.var_873a3e27[1] = 1;
					e_player function_33e91747(1, 1);
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.players)
				{
					e_player flag::set("Dev Block strings are not supported");
					e_player notify("hash_d536c595");
					e_player.var_873a3e27[2] = 1;
					e_player function_33e91747(2, 1);
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.players)
				{
					e_player flag::set("Dev Block strings are not supported");
					e_player notify("hash_af344b2c");
					e_player.var_873a3e27[3] = 1;
					e_player function_33e91747(3, 1);
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.players)
				{
					e_player flag::set("Dev Block strings are not supported");
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level function_dcfe1b91();
				foreach(e_player in level.players)
				{
					e_player function_224232f4();
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.players)
				{
					e_player function_224232f4();
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.players)
				{
					e_player function_f506b074();
				}
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: function_224232f4
	Namespace: namespace_e0675efb
	Checksum: 0xEB068391
	Offset: 0x6F50
	Size: 0x18D
	Parameters: 0
	Flags: None
*/
function function_224232f4()
{
	/#
		self notify("hash_f9ff0ae7");
		self flag::clear("Dev Block strings are not supported");
		self flag::clear("Dev Block strings are not supported");
		self flag::clear("Dev Block strings are not supported");
		self flag::clear("Dev Block strings are not supported");
		self flag::clear("Dev Block strings are not supported");
		self flag::clear("Dev Block strings are not supported");
		self thread function_2ce855f3(self._challenges.var_4687355c);
		self thread function_2ce855f3(self._challenges.var_b88ea497);
		self thread function_2ce855f3(self._challenges.var_928c2a2e);
		for(i = 1; i <= 3; i++)
		{
			self thread function_a2d25f82(i);
		}
	#/
}

/*
	Name: function_dcfe1b91
	Namespace: namespace_e0675efb
	Checksum: 0xE9B778EB
	Offset: 0x70E8
	Size: 0x451
	Parameters: 0
	Flags: None
*/
function function_dcfe1b91()
{
	/#
		foreach(e_player in level.players)
		{
			if(!isdefined(level._challenges.var_4687355c))
			{
				level._challenges.var_4687355c = [];
			}
			else if(!IsArray(level._challenges.var_4687355c))
			{
				level._challenges.var_4687355c = Array(level._challenges.var_4687355c);
			}
			level._challenges.var_4687355c[level._challenges.var_4687355c.size] = e_player._challenges.var_4687355c;
			if(!isdefined(level._challenges.var_b88ea497))
			{
				level._challenges.var_b88ea497 = [];
			}
			else if(!IsArray(level._challenges.var_b88ea497))
			{
				level._challenges.var_b88ea497 = Array(level._challenges.var_b88ea497);
			}
			level._challenges.var_b88ea497[level._challenges.var_b88ea497.size] = e_player._challenges.var_b88ea497;
			if(!isdefined(level._challenges.var_928c2a2e))
			{
				level._challenges.var_928c2a2e = [];
			}
			else if(!IsArray(level._challenges.var_928c2a2e))
			{
				level._challenges.var_928c2a2e = Array(level._challenges.var_928c2a2e);
			}
			level._challenges.var_928c2a2e[level._challenges.var_928c2a2e.size] = e_player._challenges.var_928c2a2e;
		}
		foreach(e_player in level.players)
		{
			e_player._challenges.var_4687355c = Array::random(level._challenges.var_4687355c);
			e_player._challenges.var_b88ea497 = Array::random(level._challenges.var_b88ea497);
			e_player._challenges.var_928c2a2e = Array::random(level._challenges.var_928c2a2e);
			ArrayRemoveValue(level._challenges.var_4687355c, e_player._challenges.var_4687355c);
			ArrayRemoveValue(level._challenges.var_b88ea497, e_player._challenges.var_b88ea497);
			ArrayRemoveValue(level._challenges.var_928c2a2e, e_player._challenges.var_928c2a2e);
		}
	#/
}

/*
	Name: function_f506b074
	Namespace: namespace_e0675efb
	Checksum: 0xC1F3BBEA
	Offset: 0x7548
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_f506b074()
{
	/#
		level flag::set("Dev Block strings are not supported");
		self.var_62708302 = 1;
		self.var_4aaffb90 = 1;
	#/
}

