#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;

#namespace zm_genesis_radios;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_radios
	Checksum: 0x5850A557
	Offset: 0x5C0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_radios", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_radios
	Checksum: 0x6950C7EB
	Offset: 0x608
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_disconnect(&on_player_disconnect);
}

/*
	Name: __main__
	Namespace: zm_genesis_radios
	Checksum: 0x2EE61A66
	Offset: 0x638
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
		level thread function_9ef4291();
	#/
	level waittill("start_zombie_round_logic");
	level thread function_a999a42a();
}

/*
	Name: on_player_disconnect
	Namespace: zm_genesis_radios
	Checksum: 0x99EC1590
	Offset: 0x680
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
}

/*
	Name: function_a999a42a
	Namespace: zm_genesis_radios
	Checksum: 0xC4040217
	Offset: 0x690
	Size: 0x3B5
	Parameters: 0
	Flags: None
*/
function function_a999a42a()
{
	level.var_66b7ed7e = [];
	level.var_22e09be4 = [];
	level.var_22e09be4["divine_comedy"] = Array("vox_abcd_excerpt_divine_0");
	level.var_22e09be4["theatre"] = Array("vox_abcd_excerpt_tempest_0");
	level.var_22e09be4["asylum"] = Array("vox_sfx_radio_stem_verruckt_0");
	level.var_22e09be4["mob"] = Array("vox_sfx_radio_stem_mob_log_1_0", "vox_sfx_radio_stem_mob_log_2_0", "vox_sfx_radio_stem_mob_log_3_0");
	level.var_22e09be4["trenches"] = Array("vox_sfx_radio_stem_origins_log_0");
	level.var_22e09be4["romeros_assistant"] = Array("vox_sall_shangri_log_1_0", "vox_sall_shangri_log_2_0", "vox_sall_shangri_log_3_0", "vox_sfx_radio_stem_shangri_log_4_0");
	level.var_22e09be4["island"] = Array("vox_sfx_radio_stem_shinonuma_log_0");
	level.var_22e09be4["mcnamara"] = Array("vox_nama_namara_log_0");
	a_s_radios = struct::get_array("s_radio", "targetname");
	level.a_s_radios = Array::sort_by_script_int(a_s_radios, 1);
	var_64dfb3ba = GetEntArray("clip_radio", "targetname");
	var_a399b51e = Array::sort_by_script_int(var_64dfb3ba, 1);
	var_ff34523e = Array(5, 8, 10, 11, 12, 13);
	for(i = 0; i < level.a_s_radios.size; i++)
	{
		level.a_s_radios[i].clip = ArrayGetClosest(level.a_s_radios[i].origin, var_64dfb3ba);
		s_unitrigger = level.a_s_radios[i] zm_unitrigger::create_unitrigger(&"", 64, &function_2c776a2a);
		s_unitrigger.require_look_at = 1;
		s_unitrigger.b_on = 1;
		level.a_s_radios[i] thread function_795f4e6();
		var_32be5a3 = i + 1;
		if(IsInArray(var_ff34523e, var_32be5a3))
		{
			level.a_s_radios[i] thread function_35f4f25f();
		}
	}
}

/*
	Name: function_2c776a2a
	Namespace: zm_genesis_radios
	Checksum: 0x1F2A9CDC
	Offset: 0xA50
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_2c776a2a(e_player)
{
	if(isdefined(self.stub.b_on) && self.stub.b_on)
	{
		/#
			self setHintString("Dev Block strings are not supported");
		#/
		return 1;
	}
	else
	{
		self setHintString("Dev Block strings are not supported");
		return 0;
	}
	/#
	#/
}

/*
	Name: function_795f4e6
	Namespace: zm_genesis_radios
	Checksum: 0xE6879E94
	Offset: 0xAD8
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function function_795f4e6()
{
	self endon("hash_e37d497d");
	while(1)
	{
		self waittill("trigger_activated", e_user);
		if(isPlayer(e_user) && !level flag::get("abcd_speaking") && !level flag::get("sophia_speaking") && !level flag::get("shadowman_speaking") && !self function_94b3b616())
		{
			self thread function_66d50897("trigger");
			return;
		}
	}
}

/*
	Name: function_35f4f25f
	Namespace: zm_genesis_radios
	Checksum: 0x259A6FE9
	Offset: 0xBC8
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function function_35f4f25f()
{
	self endon("hash_e37d497d");
	self endon("hash_27f23694");
	self.clip SetCanDamage(1);
	var_b1c8a081 = 0;
	while(!var_b1c8a081)
	{
		self.clip waittill("damage", n_amount, e_attacker, v_org, v_dir, str_mod);
		if(isPlayer(e_attacker) && !level flag::get("abcd_speaking") && !level flag::get("sophia_speaking") && !level flag::get("shadowman_speaking") && !self function_94b3b616())
		{
			var_b1c8a081 = 1;
			self thread function_66d50897("damage");
		}
		else
		{
			self.clip.health = 100000;
		}
	}
}

/*
	Name: function_66d50897
	Namespace: zm_genesis_radios
	Checksum: 0x81BE40BC
	Offset: 0xD48
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function function_66d50897(str_method)
{
	if(self.s_unitrigger.b_on)
	{
		self notify("hash_e37d497d");
		self.clip SetCanDamage(0);
		self.s_unitrigger.b_on = 0;
		zm_unitrigger::unregister_unitrigger(self);
		str_set = self.script_noteworthy;
		if(level.var_22e09be4[str_set].size)
		{
			str_vo = level.var_22e09be4[str_set][0];
			if(isdefined(str_vo))
			{
				if(str_method == "damage")
				{
					var_c46d7830 = self.clip.origin;
				}
				else
				{
					var_c46d7830 = self.origin;
				}
				Array::add(level.var_66b7ed7e, self, 0);
				ArrayRemoveIndex(level.var_22e09be4[str_set], 0);
				var_5cd02106 = soundgetplaybacktime(str_vo);
				if(var_5cd02106 > 0)
				{
					var_269117b2 = var_5cd02106 / 1000;
					playsoundatposition(str_vo, var_c46d7830);
					wait(var_269117b2);
				}
				ArrayRemoveValue(level.var_66b7ed7e, self);
			}
		}
	}
}

/*
	Name: function_94b3b616
	Namespace: zm_genesis_radios
	Checksum: 0xCC885A81
	Offset: 0xF08
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_94b3b616(n_range)
{
	if(!isdefined(n_range))
	{
		n_range = 800;
	}
	if(level.var_66b7ed7e.size == 0)
	{
		return 0;
	}
	var_f39e4895 = ArrayGetClosest(self.origin, level.var_66b7ed7e);
	if(isdefined(var_f39e4895))
	{
		n_dist = Distance(self.origin, var_f39e4895.origin);
		return n_dist <= n_range;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_9ef4291
	Namespace: zm_genesis_radios
	Checksum: 0x2495D42F
	Offset: 0xFC8
	Size: 0x5BB
	Parameters: 0
	Flags: None
*/
function function_9ef4291()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 2, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 2, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 3, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 3, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 4, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 4, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 5, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 5, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 6, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 6, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 7, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 7, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 8, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 8, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 9, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 9, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 10, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 10, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 11, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 11, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 12, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 12, &function_dda18b8e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 13, &function_418d5e87);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 13, &function_dda18b8e);
	#/
}

/*
	Name: function_dda18b8e
	Namespace: zm_genesis_radios
	Checksum: 0x76A068AE
	Offset: 0x1590
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_dda18b8e(n_val)
{
	/#
		level.a_s_radios[n_val - 1] thread function_66d50897();
	#/
}

/*
	Name: function_418d5e87
	Namespace: zm_genesis_radios
	Checksum: 0xE19EA38B
	Offset: 0x15D0
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function function_418d5e87(n_val)
{
	/#
		str_dest = "Dev Block strings are not supported" + n_val;
		s_dest = struct::get(str_dest);
		if(isdefined(s_dest))
		{
			player = level.activePlayers[0];
			var_5d8a4d6d = util::spawn_model("Dev Block strings are not supported", player.origin, player.angles);
			player LinkTo(var_5d8a4d6d);
			var_5d8a4d6d.origin = s_dest.origin;
			wait(0.5);
			player Unlink();
			var_5d8a4d6d delete();
		}
	#/
}

