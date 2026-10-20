#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_ball;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_apothican;
#using scripts\zm\zm_genesis_minor_ee;

#namespace zm_genesis_util;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_util
	Checksum: 0x80A1A79
	Offset: 0xB68
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_util", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_util
	Checksum: 0xFAE56691
	Offset: 0xBB0
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	n_bits = GetMinBitCountForNum(8);
	clientfield::register("toplayer", "player_rumble_and_shake", 15000, n_bits, "int");
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("scriptmover", "emit_smoke", 15000, n_bits, "int");
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("scriptmover", "fire_trap", 15000, n_bits, "int");
	clientfield::register("actor", "fire_trap_ignite_enemy", 15000, 1, "int");
	clientfield::register("scriptmover", "rq_gateworm_magic", 15000, 1, "int");
	clientfield::register("scriptmover", "rq_gateworm_dissolve_finish", 15000, 1, "int");
	clientfield::register("scriptmover", "rq_rune_glow", 15000, 1, "int");
	RegisterClientField("world", "gen_rune_electricity", 15000, 1, "int");
	RegisterClientField("world", "gen_rune_fire", 15000, 1, "int");
	RegisterClientField("world", "gen_rune_light", 15000, 1, "int");
	RegisterClientField("world", "gen_rune_shadow", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_rune_parts", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_rune_quest", 15000, 1, "int");
	level.custom_spawner_entry["crawl"] = &function_48cfc7df;
	level.perk_random_idle_effects_override = &function_555e8704;
	level thread function_828240c9();
}

/*
	Name: __main__
	Namespace: zm_genesis_util
	Checksum: 0x98BCF796
	Offset: 0xEE8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	function_b6faf5c0();
	function_8fb96327();
	/#
		level thread function_30672281();
	#/
	/#
		level thread watch_for_open_sesame();
	#/
	level thread function_5bad746b();
}

/*
	Name: function_1bd652e9
	Namespace: zm_genesis_util
	Checksum: 0x82BD762E
	Offset: 0xF60
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function function_1bd652e9()
{
	a_ai_zombies = GetAITeamArray("axis");
	n_alive = 0;
	foreach(ai_zombie in a_ai_zombies)
	{
		if(isalive(ai_zombie))
		{
			n_alive++;
		}
	}
	return n_alive;
}

/*
	Name: vec_to_string
	Namespace: zm_genesis_util
	Checksum: 0xD9293A49
	Offset: 0x1030
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function vec_to_string(V)
{
	return "<" + V[0] + ", " + V[1] + ", " + V[2] + ">";
}

/*
	Name: function_828240c9
	Namespace: zm_genesis_util
	Checksum: 0x300C7828
	Offset: 0x1088
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_828240c9()
{
	level waittill("start_zombie_round_logic");
	if(isdefined(level._custom_powerups["shield_charge"]))
	{
		ArrayRemoveIndex(level._custom_powerups, "shield_charge", 1);
	}
}

/*
	Name: function_5ea427bf
	Namespace: zm_genesis_util
	Checksum: 0x97B6C6DE
	Offset: 0x10E0
	Size: 0x17F
	Parameters: 1
	Flags: None
*/
function function_5ea427bf(player)
{
	b_visible = 1;
	if(isdefined(player.beastmode) && player.beastmode && (!isdefined(self.allow_beastmode) && self.allow_beastmode))
	{
		b_visible = 0;
	}
	else if(isdefined(self.stub.func_unitrigger_visible))
	{
		b_visible = self [[self.stub.func_unitrigger_visible]](player);
	}
	str_msg = &"";
	param1 = undefined;
	if(b_visible)
	{
		if(isdefined(self.stub.func_unitrigger_message))
		{
			str_msg = self [[self.stub.func_unitrigger_message]](player);
		}
		else
		{
			str_msg = self.stub.hint_string;
			param1 = self.stub.hint_parm1;
		}
	}
	if(isdefined(str_msg))
	{
		if(isdefined(param1))
		{
			self setHintString(str_msg, param1);
		}
		else
		{
			self setHintString(str_msg);
		}
	}
	return b_visible;
}

/*
	Name: unitrigger_refresh_message
	Namespace: zm_genesis_util
	Checksum: 0x26E65965
	Offset: 0x1268
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function unitrigger_refresh_message()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: unitrigger_allow_beastmode
	Namespace: zm_genesis_util
	Checksum: 0xEB5E91D5
	Offset: 0x1290
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function unitrigger_allow_beastmode()
{
	self.allow_beastmode = 1;
}

/*
	Name: unitrigger_think
	Namespace: zm_genesis_util
	Checksum: 0x85F437A3
	Offset: 0x12A8
	Size: 0x9B
	Parameters: 0
	Flags: Private
*/
function private unitrigger_think()
{
	self endon("kill_trigger");
	self.stub thread unitrigger_refresh_message();
	while(1)
	{
		self waittill("trigger", player);
		if(isdefined(self.allow_beastmode) && self.allow_beastmode || (!isdefined(player.beastmode) && player.beastmode))
		{
			self.stub notify("trigger", player);
		}
	}
}

/*
	Name: set_unitrigger_hint_string
	Namespace: zm_genesis_util
	Checksum: 0x530C1173
	Offset: 0x1350
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
	Name: spawn_unitrigger
	Namespace: zm_genesis_util
	Checksum: 0xF93D87C8
	Offset: 0x13C0
	Size: 0x1F7
	Parameters: 5
	Flags: Private
*/
function private spawn_unitrigger(origin, angles, radius_or_dims, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	str_type = "unitrigger_radius";
	if(IsVec(radius_or_dims))
	{
		trigger_stub.script_length = radius_or_dims[0];
		trigger_stub.script_width = radius_or_dims[1];
		trigger_stub.script_height = radius_or_dims[2];
		str_type = "unitrigger_box";
		if(!isdefined(angles))
		{
			angles = (0, 0, 0);
		}
		trigger_stub.angles = angles;
	}
	else
	{
		trigger_stub.radius = radius_or_dims;
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
		trigger_stub.func_unitrigger_message = func_per_player_msg;
		zm_unitrigger::unitrigger_force_per_player_triggers(trigger_stub, 1);
	}
	trigger_stub.prompt_and_visibility_func = &function_5ea427bf;
	zm_unitrigger::register_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: spawn_trigger_radius
	Namespace: zm_genesis_util
	Checksum: 0xC5BEB279
	Offset: 0x15C0
	Size: 0x59
	Parameters: 4
	Flags: None
*/
function spawn_trigger_radius(origin, radius, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	return spawn_unitrigger(origin, undefined, radius, use_trigger, func_per_player_msg);
}

/*
	Name: spawn_trigger_box
	Namespace: zm_genesis_util
	Checksum: 0xFF6C91C4
	Offset: 0x1628
	Size: 0x61
	Parameters: 5
	Flags: None
*/
function spawn_trigger_box(origin, angles, dims, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	return spawn_unitrigger(origin, angles, dims, use_trigger, func_per_player_msg);
}

/*
	Name: function_b6faf5c0
	Namespace: zm_genesis_util
	Checksum: 0xFFAD8A24
	Offset: 0x1698
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_b6faf5c0()
{
	level.var_e17963aa = [];
	level.var_7c6cbc08 = struct::get_array("smoke_emitter", "script_noteworthy");
}

/*
	Name: function_c3266652
	Namespace: zm_genesis_util
	Checksum: 0x4577ED4
	Offset: 0x16E0
	Size: 0x309
	Parameters: 3
	Flags: None
*/
function function_c3266652(str_targetname, n_duration, n_offset)
{
	var_bd7e807d = Array::filter(level.var_7c6cbc08, 0, &function_f889e065, str_targetname);
	/#
		Assert(isdefined(var_bd7e807d), "Dev Block strings are not supported" + str_targetname + "Dev Block strings are not supported");
	#/
	if(!isdefined(level.var_e17963aa[str_targetname]))
	{
		foreach(var_dddfc725 in var_bd7e807d)
		{
			var_a535abab = util::spawn_model("tag_origin", var_dddfc725.origin, var_dddfc725.angles);
			var_a535abab.script_int = var_dddfc725.script_int;
			if(!isdefined(level.var_e17963aa[str_targetname]))
			{
				level.var_e17963aa[str_targetname] = Array(var_a535abab);
				continue;
			}
			if(!isdefined(level.var_e17963aa[str_targetname]))
			{
				level.var_e17963aa[str_targetname] = [];
			}
			else if(!IsArray(level.var_e17963aa[str_targetname]))
			{
				level.var_e17963aa[str_targetname] = Array(level.var_e17963aa[str_targetname]);
			}
			level.var_e17963aa[str_targetname][level.var_e17963aa[str_targetname].size] = var_a535abab;
		}
	}
	/#
		Assert(isdefined(level.var_e17963aa[str_targetname]), "Dev Block strings are not supported" + str_targetname + "Dev Block strings are not supported");
	#/
	foreach(var_a535abab in level.var_e17963aa[str_targetname])
	{
		var_a535abab thread function_92fbd45f(n_duration);
		if(isdefined(n_offset))
		{
			wait(n_offset);
		}
	}
}

/*
	Name: function_7c229e48
	Namespace: zm_genesis_util
	Checksum: 0x471F67FD
	Offset: 0x19F8
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function function_7c229e48(str_targetname)
{
	if(isdefined(level.var_e17963aa[str_targetname]))
	{
		foreach(var_a535abab in level.var_e17963aa[str_targetname])
		{
			var_a535abab thread function_d8dd128a();
		}
		level.var_e17963aa = Array::remove_index(level.var_e17963aa, str_targetname, 1);
	}
}

/*
	Name: function_d8dd128a
	Namespace: zm_genesis_util
	Checksum: 0xA5B76B83
	Offset: 0x1AD8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_d8dd128a()
{
	self clientfield::set("emit_smoke", 0);
	wait(1);
	self delete();
}

/*
	Name: function_92fbd45f
	Namespace: zm_genesis_util
	Checksum: 0x278A8CE5
	Offset: 0x1B20
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_92fbd45f(n_duration)
{
	level endon("hash_306a8062");
	var_34e5a242 = self.script_int;
	if(!isdefined(var_34e5a242))
	{
		var_34e5a242 = 1;
	}
	self clientfield::set("emit_smoke", var_34e5a242);
	if(isdefined(n_duration))
	{
		wait(n_duration);
		self clientfield::set("emit_smoke", 0);
	}
}

/*
	Name: function_f889e065
	Namespace: zm_genesis_util
	Checksum: 0xE7B995D3
	Offset: 0x1BC0
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function function_f889e065(var_dddfc725, str_targetname)
{
	return var_dddfc725.targetname === str_targetname;
}

/*
	Name: function_70f7f8aa
	Namespace: zm_genesis_util
	Checksum: 0xF146EABD
	Offset: 0x1BF0
	Size: 0x6F
	Parameters: 4
	Flags: None
*/
function function_70f7f8aa(v_pos, v_angles, var_216e90fd, var_8a2d164)
{
	var_2804cb89 = util::spawn_model("tag_origin", v_pos, v_angles);
	var_2804cb89 thread function_721925b6(var_216e90fd, var_8a2d164);
	return var_2804cb89;
}

/*
	Name: function_721925b6
	Namespace: zm_genesis_util
	Checksum: 0x40ECF264
	Offset: 0x1C68
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function function_721925b6(var_216e90fd, var_8a2d164)
{
	self endon("death");
	switch(var_216e90fd)
	{
		case 0:
		case 2:
		{
			self clientfield::set("fire_trap", 1);
			self.n_inflame_count = 1;
			break;
		}
		case 1:
		case 3:
		{
			self clientfield::set("fire_trap", 3);
			self.n_inflame_count = 2;
			break;
		}
	}
	self flag::init("deactivate_fire_trap");
	self thread function_1f629fb(var_216e90fd);
	self function_9354534f(var_216e90fd, var_8a2d164);
	self clientfield::set("fire_trap", 0);
	self notify("deactivate_fire_trap");
	self delete();
}

/*
	Name: function_9354534f
	Namespace: zm_genesis_util
	Checksum: 0xCF931E7E
	Offset: 0x1DB8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function function_9354534f(var_216e90fd, var_8a2d164)
{
	if(!self flag::get("deactivate_fire_trap"))
	{
		if(var_8a2d164 > 1)
		{
			self thread function_5d940bdb(var_216e90fd, var_8a2d164);
			if(isdefined(var_8a2d164))
			{
				__s = spawnstruct();
				__s endon("timeout");
				__s util::delay_notify(var_8a2d164, "timeout");
			}
		}
		self waittill("deactivate_fire_trap");
	}
	else
	{
		wait(0.1);
	}
}

/*
	Name: function_5d940bdb
	Namespace: zm_genesis_util
	Checksum: 0xCFDA497D
	Offset: 0x1E98
	Size: 0xC1
	Parameters: 2
	Flags: None
*/
function function_5d940bdb(var_216e90fd, var_8a2d164)
{
	self endon("death");
	self endon("deactivate_fire_trap");
	var_16039327 = var_8a2d164 - 2;
	if(var_16039327 < 1)
	{
		var_16039327 = var_8a2d164 * 0.5;
	}
	wait(var_16039327);
	switch(var_216e90fd)
	{
		case 0:
		case 2:
		{
			self clientfield::set("fire_trap", 2);
			break;
		}
		case 1:
		case 3:
		{
			break;
		}
	}
}

/*
	Name: function_1f629fb
	Namespace: zm_genesis_util
	Checksum: 0xC93C5191
	Offset: 0x1F68
	Size: 0x31F
	Parameters: 1
	Flags: None
*/
function function_1f629fb(var_216e90fd)
{
	self endon("deactivate_fire_trap");
	while(1)
	{
		a_ai_enemies = GetAITeamArray(level.zombie_team);
		var_f7c98a7 = ArraySortClosest(a_ai_enemies, self.origin, a_ai_enemies.size, 0, 96);
		var_f7c98a7 = Array::filter(var_f7c98a7, 0, &function_2179430a);
		var_f7c98a7 = Array::filter(var_f7c98a7, 0, &function_bb218fa3, self, 2304);
		if(var_f7c98a7.size)
		{
			foreach(var_7cb53454 in var_f7c98a7)
			{
				b_result = var_7cb53454 function_c8040935(var_216e90fd);
				if(isdefined(b_result) && b_result)
				{
					self notify("hash_b2a721cd");
					self.n_inflame_count--;
					if(self.n_inflame_count <= 0)
					{
						self flag::set("deactivate_fire_trap");
					}
				}
			}
		}
		a_e_players = ArraySortClosest(level.activePlayers, self.origin, level.activePlayers.size, 0, 64);
		a_e_players = Array::filter(a_e_players, 0, &function_bb218fa3, self, 1024);
		a_e_players = Array::filter(a_e_players, 0, &function_6f7936c1);
		if(a_e_players.size)
		{
			foreach(e_player in a_e_players)
			{
				if(zm_utility::is_player_valid(e_player))
				{
					e_player thread function_28297a11();
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_c8040935
	Namespace: zm_genesis_util
	Checksum: 0xC4FB1753
	Offset: 0x2290
	Size: 0x1AB
	Parameters: 1
	Flags: None
*/
function function_c8040935(var_216e90fd)
{
	ai_zombie = self;
	var_1ca69a28 = zm_elemental_zombie::function_4aeed0a5("napalm");
	if(!isdefined(level.var_bd64e31e) || var_1ca69a28 < level.var_bd64e31e)
	{
		if(!(isdefined(ai_zombie.is_elemental_zombie) && ai_zombie.is_elemental_zombie))
		{
			ai_zombie.is_elemental_zombie = 1;
			ai_zombie.var_9a02a614 = "napalm";
			ai_zombie clientfield::set("fire_trap_ignite_enemy", 1);
			ai_zombie clientfield::set("arch_actor_fire_fx", 1);
			ai_zombie thread zm_elemental_zombie::napalm_zombie_death();
			ai_zombie thread zm_elemental_zombie::function_d070bfba();
			if(var_216e90fd == 2 || var_216e90fd == 3)
			{
				ai_zombie.var_6d2a9142 = 1;
			}
			else
			{
				ai_zombie.health = Int(ai_zombie.health * 0.75);
				ai_zombie zombie_utility::set_zombie_run_cycle("sprint");
			}
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_28297a11
	Namespace: zm_genesis_util
	Checksum: 0x20D52CB8
	Offset: 0x2448
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_28297a11()
{
	self endon("death");
	self.var_c0ad0afe = 1;
	self DoDamage(20, self.origin);
	wait(2);
	self.var_c0ad0afe = 0;
}

/*
	Name: function_bb218fa3
	Namespace: zm_genesis_util
	Checksum: 0x60A8D580
	Offset: 0x24A0
	Size: 0x47
	Parameters: 3
	Flags: None
*/
function function_bb218fa3(var_7cb53454, var_2804cb89, n_dist_2d_sq)
{
	return Distance2DSquared(var_7cb53454.origin, var_2804cb89.origin) < n_dist_2d_sq;
}

/*
	Name: function_2179430a
	Namespace: zm_genesis_util
	Checksum: 0xD62EFE62
	Offset: 0x24F0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_2179430a(var_7cb53454)
{
	return !isdefined(var_7cb53454.is_elemental_zombie) && var_7cb53454.is_elemental_zombie && var_7cb53454.classname != "script_vehicle";
}

/*
	Name: function_6f7936c1
	Namespace: zm_genesis_util
	Checksum: 0x4A1508B6
	Offset: 0x2548
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_6f7936c1(var_7cb53454)
{
	return !isdefined(var_7cb53454.var_c0ad0afe) && var_7cb53454.var_c0ad0afe;
}

/*
	Name: set_rumble_to_player
	Namespace: zm_genesis_util
	Checksum: 0x9BA03673
	Offset: 0x2580
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function set_rumble_to_player(n_rumbletype, var_d00db512)
{
	self notify("set_rumble_to_player");
	self endon("disconnect");
	self endon("set_rumble_to_player");
	self thread clientfield::set_to_player("player_rumble_and_shake", n_rumbletype);
	if(isdefined(var_d00db512))
	{
		wait(var_d00db512);
		self thread set_rumble_to_player(0);
	}
}

/*
	Name: function_3a7a7013
	Namespace: zm_genesis_util
	Checksum: 0x4E59F8B9
	Offset: 0x2610
	Size: 0x101
	Parameters: 4
	Flags: None
*/
function function_3a7a7013(n_rumbletype, n_radius, v_origin, var_d00db512)
{
	var_699d80d5 = n_radius * n_radius;
	foreach(player in level.activePlayers)
	{
		if(isdefined(player) && Distance2DSquared(player.origin, v_origin) <= var_699d80d5)
		{
			player thread set_rumble_to_player(n_rumbletype, var_d00db512);
		}
	}
}

/*
	Name: setup_devgui_func
	Namespace: zm_genesis_util
	Checksum: 0x8B3F3B68
	Offset: 0x2720
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
	AddDebugCommand("devgui_cmd "" + str_devgui_path + "" "" + str_dvar + " " + n_value + "" ");
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

/*
	Name: zombie_is_target_reachable
	Namespace: zm_genesis_util
	Checksum: 0x6E9EB754
	Offset: 0x2848
	Size: 0x2E3
	Parameters: 1
	Flags: None
*/
function zombie_is_target_reachable(player)
{
	zombie_zone = self.zone_name;
	player_zone = player.zone_name;
	if(zombie_zone === player_zone)
	{
		return 1;
	}
	if(!isdefined(zombie_zone) || !isdefined(player_zone))
	{
		return 0;
	}
	zombie_district = level.zones[self.zone_name].district;
	player_district = level.zones[player.zone_name].district;
	var_bb534481 = level.zones[self.zone_name].area;
	var_147beb1e = level.zones[player.zone_name].area;
	if(var_bb534481 == 0 && var_147beb1e == 0)
	{
		return 1;
	}
	if(zombie_district === player_district && var_bb534481 === var_147beb1e)
	{
		return 1;
	}
	if(zombie_district === player_district)
	{
		if(var_bb534481 > var_147beb1e)
		{
			temp = var_bb534481;
			var_bb534481 = var_147beb1e;
			var_147beb1e = temp;
		}
		can_reach = function_17c00a4f(zombie_district, var_bb534481, player_district, var_147beb1e);
		return can_reach;
	}
	if(var_bb534481 == 0 && var_147beb1e != 0)
	{
		can_reach = function_17c00a4f("junction", 0, player_district, var_147beb1e);
		return can_reach;
	}
	if(var_147beb1e == 0 && var_bb534481 != 0)
	{
		can_reach = function_17c00a4f("junction", 0, zombie_district, var_bb534481);
		return can_reach;
	}
	var_92280803 = 1;
	var_58b7daa8 = 1;
	var_92280803 = function_17c00a4f("junction", 0, zombie_district, var_bb534481);
	var_58b7daa8 = function_17c00a4f("junction", 0, player_district, var_147beb1e);
	return var_58b7daa8 && var_92280803;
}

/*
	Name: function_555e8704
	Namespace: zm_genesis_util
	Checksum: 0x99B4BAF8
	Offset: 0x2B38
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_555e8704()
{
	if(!isdefined(self.unitrigger_stub.in_zone))
	{
		/#
			IPrintLnBold("Dev Block strings are not supported");
		#/
		return;
	}
	switch(self.unitrigger_stub.in_zone)
	{
		case "zm_tomb_trench2_zone":
		{
			str_exploder = "fxexp_261";
			break;
		}
		case "zm_tomb_ruins_interior_zone":
		{
			str_exploder = "fxexp_262";
			break;
		}
		case "zm_asylum_kitchen_landing_zone":
		{
			str_exploder = "fxexp_263";
			break;
		}
		case "zm_theater_hallway_zone":
		{
			str_exploder = " fxexp_264";
			break;
		}
	}
	if(!isdefined(str_exploder))
	{
		/#
			IPrintLnBold("Dev Block strings are not supported");
		#/
		return;
	}
	exploder::exploder(str_exploder);
	while(self.State == "idle")
	{
		wait(0.05);
	}
	exploder::exploder_stop(str_exploder);
}

/*
	Name: function_17c00a4f
	Namespace: zm_genesis_util
	Checksum: 0x9C3B2F99
	Offset: 0x2C78
	Size: 0x27
	Parameters: 4
	Flags: None
*/
function function_17c00a4f(zombie_district, zombie_area, player_district, player_area)
{
	return 1;
}

/*
	Name: function_48cfc7df
	Namespace: zm_genesis_util
	Checksum: 0x80C9E93
	Offset: 0x2CA8
	Size: 0x21D
	Parameters: 1
	Flags: None
*/
function function_48cfc7df(s_spot)
{
	self endon("death");
	self.var_2be9fa75 = 1;
	self ghost();
	var_37b7ca78 = "cin_zm_dlc1_zombie_undercroft_spawn_" + randomIntRange(1, 3);
	if(!isdefined(s_spot.angles))
	{
		s_spot.angles = (0, 0, 0);
	}
	mdl_anchor = util::spawn_model("tag_origin", self.origin, self.angles);
	self LinkTo(mdl_anchor);
	self thread anchor_delete_watcher(mdl_anchor);
	mdl_anchor endon("death");
	mdl_anchor.origin = s_spot.origin;
	mdl_anchor.angles = s_spot.angles;
	util::wait_network_frame();
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	self.create_eyes = 1;
	self show();
	if(isalive(self) && self.health > 0)
	{
		mdl_anchor scene::Play(var_37b7ca78, self);
	}
	self.var_2be9fa75 = 0;
	self Unlink();
	self notify("risen", s_spot.script_string);
}

/*
	Name: anchor_delete_watcher
	Namespace: zm_genesis_util
	Checksum: 0x5DE97D0E
	Offset: 0x2ED0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function anchor_delete_watcher(mdl_anchor)
{
	self util::waittill_any("death", "risen");
	util::wait_network_frame();
	if(isdefined(mdl_anchor))
	{
		mdl_anchor delete();
	}
}

/*
	Name: function_42108922
	Namespace: zm_genesis_util
	Checksum: 0xCB5AFC38
	Offset: 0x2F40
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function function_42108922(str_zone, str_flag)
{
	/#
		Assert(isdefined(level.zones[str_zone]), "Dev Block strings are not supported" + str_zone + "Dev Block strings are not supported");
	#/
	level flag::wait_till(str_flag);
	if(zm_zonemgr::zone_is_enabled(str_zone))
	{
		return;
	}
	zm_zonemgr::enable_zone(str_zone);
}

/*
	Name: function_342295d8
	Namespace: zm_genesis_util
	Checksum: 0x290CB1B9
	Offset: 0x2FE0
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function function_342295d8(str_zone, b_enable)
{
	if(!isdefined(b_enable))
	{
		b_enable = 1;
	}
	/#
		Assert(isdefined(level.zones[str_zone]), "Dev Block strings are not supported" + str_zone + "Dev Block strings are not supported");
	#/
	if(b_enable && zm_zonemgr::zone_is_enabled(str_zone))
	{
		return;
	}
	level.zones[str_zone].is_enabled = b_enable;
	level.zones[str_zone].is_spawning_allowed = b_enable;
}

/*
	Name: function_37a5b776
	Namespace: zm_genesis_util
	Checksum: 0xFCC1360
	Offset: 0x30A8
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function function_37a5b776()
{
	a_e_occupied = [];
	a_str_islands = Array("start_island", "apothicon_island", "temple_island", "prototype_island", "asylum_island", "prison_island", "arena_island");
	for(i = 0; i < a_str_islands.size; i++)
	{
		e_island = GetEnt(a_str_islands[i], "targetname");
		for(j = 0; j < level.activePlayers.size; j++)
		{
			if(isdefined(level.activePlayers[j].is_flung) && level.activePlayers[j].is_flung)
			{
				return 1;
			}
			if(level.activePlayers[j] istouching(e_island))
			{
				Array::add(a_e_occupied, e_island, 0);
			}
		}
	}
	if(!a_e_occupied.size)
	{
		return 1;
		break;
	}
	for(K = 0; K < a_e_occupied.size; K++)
	{
		if(self istouching(a_e_occupied[K]))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: monitor_wallrun_trigger
	Namespace: zm_genesis_util
	Checksum: 0x6BED65ED
	Offset: 0x3288
	Size: 0xDF
	Parameters: 2
	Flags: None
*/
function monitor_wallrun_trigger(str_trigger, str_flag)
{
	t_trigger = GetEnt(str_trigger, "targetname");
	level flag::init(str_flag);
	while(1)
	{
		t_trigger waittill("trigger", e_triggerer);
		if(!isdefined(e_triggerer.b_wall_run_enabled) && e_triggerer.b_wall_run_enabled && level flag::get(str_flag))
		{
			e_triggerer thread enable_wallrun(t_trigger, str_flag);
		}
	}
}

/*
	Name: function_88777efd
	Namespace: zm_genesis_util
	Checksum: 0x3D5A6905
	Offset: 0x3370
	Size: 0x10F
	Parameters: 2
	Flags: None
*/
function function_88777efd(str_trigger, str_flag)
{
	t_trigger = GetEnt(str_trigger, "targetname");
	level flag::init(str_flag);
	while(1)
	{
		t_trigger waittill("trigger", e_triggerer);
		if(!isPlayer(e_triggerer))
		{
			wait(0.1);
			continue;
		}
		if(!isdefined(e_triggerer.var_7dd18a0) && e_triggerer.var_7dd18a0 && level flag::get(str_flag))
		{
			e_triggerer thread function_36bd06cd(t_trigger, str_flag);
		}
		wait(0.1);
	}
}

/*
	Name: enable_wallrun
	Namespace: zm_genesis_util
	Checksum: 0x8B8692B2
	Offset: 0x3488
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function enable_wallrun(t_trigger, str_flag)
{
	self endon("death");
	self.b_wall_run_enabled = 1;
	self allowwallrun(1);
	while(self istouching(t_trigger) && level flag::get(str_flag))
	{
		wait(0.05);
	}
	self.b_wall_run_enabled = 0;
	self allowwallrun(0);
}

/*
	Name: function_36bd06cd
	Namespace: zm_genesis_util
	Checksum: 0x7FCD784E
	Offset: 0x3538
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function function_36bd06cd(t_trigger, str_flag)
{
	self endon("death");
	self allowdoublejump(1);
	self setPerk("specialty_lowgravity");
	self.var_7dd18a0 = 1;
	while(self istouching(t_trigger) && level flag::get(str_flag))
	{
		wait(0.05);
	}
	self allowdoublejump(0);
	self unsetPerk("specialty_lowgravity");
	self.var_7dd18a0 = 0;
}

/*
	Name: function_89067abe
	Namespace: zm_genesis_util
	Checksum: 0x85CCABF2
	Offset: 0x3628
	Size: 0x167
	Parameters: 4
	Flags: None
*/
function function_89067abe(e_player, str_text, xpos, ypos)
{
	hudelem = newClientHudElem(e_player);
	if(isdefined(xpos))
	{
		hudelem.alignX = "left";
		hudelem.x = xpos;
	}
	else
	{
		hudelem.alignX = "center";
		hudelem.horzAlign = "center";
		hudelem.alignY = "middle";
		hudelem.vertAlign = "middle";
	}
	hudelem.y = ypos;
	hudelem.foreground = 1;
	hudelem.font = "default";
	hudelem.fontscale = 1.2;
	hudelem.alpha = 1;
	hudelem.color = (1, 1, 1);
	hudelem setText(str_text);
	return hudelem;
}

/*
	Name: function_a1bfa962
	Namespace: zm_genesis_util
	Checksum: 0x76B08C3D
	Offset: 0x3798
	Size: 0x15F
	Parameters: 4
	Flags: None
*/
function function_a1bfa962(e_player, str_text, xpos, ypos)
{
	hudelem = NewHudElem();
	if(isdefined(xpos))
	{
		hudelem.alignX = "left";
		hudelem.x = xpos;
	}
	else
	{
		hudelem.alignX = "center";
		hudelem.horzAlign = "center";
		hudelem.alignY = "middle";
		hudelem.vertAlign = "middle";
	}
	hudelem.y = ypos;
	hudelem.foreground = 1;
	hudelem.font = "default";
	hudelem.fontscale = 1.2;
	hudelem.alpha = 1;
	hudelem.color = (1, 1, 1);
	hudelem setText(str_text);
	return hudelem;
}

/*
	Name: array_remove
	Namespace: zm_genesis_util
	Checksum: 0xFE298400
	Offset: 0x3900
	Size: 0x11B
	Parameters: 2
	Flags: None
*/
function array_remove(Array, object)
{
	if(!isdefined(Array) && !isdefined(object))
	{
		return;
	}
	new_array = [];
	foreach(item in Array)
	{
		if(item != object)
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!IsArray(new_array))
			{
				new_array = Array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: function_adcc0e33
	Namespace: zm_genesis_util
	Checksum: 0xE0C7EA04
	Offset: 0x3A28
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_adcc0e33()
{
	var_91bcd8f1 = 0;
	a_zombies = GetAITeamArray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].is_parasite) && a_zombies[i].is_parasite)
		{
			var_91bcd8f1++;
		}
	}
	return var_91bcd8f1;
}

/*
	Name: function_c6462c91
	Namespace: zm_genesis_util
	Checksum: 0x164147DE
	Offset: 0x3AD0
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_c6462c91()
{
	var_2a3db9af = 0;
	a_zombies = GetAITeamArray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].b_is_spider) && a_zombies[i].b_is_spider)
		{
			var_2a3db9af++;
		}
	}
	return var_2a3db9af;
}

/*
	Name: function_e3e6bdba
	Namespace: zm_genesis_util
	Checksum: 0xCDE33470
	Offset: 0x3B78
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_e3e6bdba()
{
	var_9911df60 = 0;
	a_zombies = GetAITeamArray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].b_is_keeper) && a_zombies[i].b_is_keeper)
		{
			var_9911df60++;
		}
	}
	return var_9911df60;
}

/*
	Name: function_23ee29c0
	Namespace: zm_genesis_util
	Checksum: 0x5947020F
	Offset: 0x3C20
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_23ee29c0()
{
	var_87f7eede = 0;
	a_zombies = GetAITeamArray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].var_1cba9ac3) && a_zombies[i].var_1cba9ac3)
		{
			var_87f7eede++;
		}
	}
	return var_87f7eede;
}

/*
	Name: function_2a0bc326
	Namespace: zm_genesis_util
	Checksum: 0x5B1B8336
	Offset: 0x3CC8
	Size: 0x151
	Parameters: 7
	Flags: None
*/
function function_2a0bc326(v_pos, var_48f82942, var_51fbdea, var_644bf6a7, var_8f4ca4be, str_rumble_type, var_183c13ad)
{
	if(!isdefined(str_rumble_type))
	{
		str_rumble_type = "damage_heavy";
	}
	if(var_48f82942)
	{
		Earthquake(var_48f82942, var_51fbdea, v_pos, var_644bf6a7);
	}
	var_5ca58060 = var_644bf6a7 * var_644bf6a7;
	foreach(player in level.activePlayers)
	{
		if(isdefined(var_183c13ad))
		{
			player shellshock(var_183c13ad, var_51fbdea);
		}
		player thread function_e42cebb6(v_pos, var_5ca58060, var_8f4ca4be, str_rumble_type);
	}
}

/*
	Name: function_e42cebb6
	Namespace: zm_genesis_util
	Checksum: 0x3B0F978
	Offset: 0x3E28
	Size: 0x9D
	Parameters: 4
	Flags: None
*/
function function_e42cebb6(v_pos, var_5ca58060, var_8f4ca4be, str_rumble_type)
{
	self endon("death");
	for(i = 0; i < var_8f4ca4be; i++)
	{
		if(DistanceSquared(v_pos, self.origin) <= var_5ca58060)
		{
			self PlayRumbleOnEntity(str_rumble_type);
		}
		wait(0.1);
	}
}

/*
	Name: function_8fb96327
	Namespace: zm_genesis_util
	Checksum: 0x7CFA3FEE
	Offset: 0x3ED0
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function function_8fb96327()
{
	level.var_d2484e02 = [];
	level.var_94994361 = [];
	level.var_3787c9a = [];
	level flag::init("electricity_rq_started");
	level flag::init("fire_rq_started");
	level flag::init("light_rq_started");
	level flag::init("shadow_rq_started");
	level flag::init("electricity_rq_done");
	level flag::init("fire_rq_done");
	level flag::init("light_rq_done");
	level flag::init("shadow_rq_done");
	level thread electricity_rune_quest_start();
	level thread fire_rune_quest_start();
	level thread light_rune_quest_start();
	level thread shadow_rune_quest_start();
}

/*
	Name: electricity_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0x7EC66C92
	Offset: 0x4060
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function electricity_rune_quest_start()
{
	a_s_start_pos = struct::get_array("electricity_rune_quest_start", "targetname");
	s_start_pos = Array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("electricity_rq_started", &function_2f157912, &function_e889d17c);
}

/*
	Name: function_2f157912
	Namespace: zm_genesis_util
	Checksum: 0x892FF661
	Offset: 0x40F8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_2f157912(e_who)
{
	return function_af60288e(e_who, 0);
}

/*
	Name: function_e889d17c
	Namespace: zm_genesis_util
	Checksum: 0xD751073D
	Offset: 0x4128
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_e889d17c(e_who)
{
	self function_87cb72e4(e_who, 0);
}

/*
	Name: fire_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0x64D47AA1
	Offset: 0x4158
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function fire_rune_quest_start()
{
	a_s_start_pos = struct::get_array("fire_rune_quest_start", "targetname");
	s_start_pos = Array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("fire_rq_started", &function_8164c629, &function_9b7022b5);
}

/*
	Name: function_8164c629
	Namespace: zm_genesis_util
	Checksum: 0x1462DCF0
	Offset: 0x41F0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_8164c629(e_who)
{
	return function_af60288e(e_who, 1);
}

/*
	Name: function_9b7022b5
	Namespace: zm_genesis_util
	Checksum: 0xB73884DB
	Offset: 0x4220
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_9b7022b5(e_who)
{
	self function_87cb72e4(e_who, 1);
}

/*
	Name: light_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0x45879C8E
	Offset: 0x4258
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function light_rune_quest_start()
{
	a_s_start_pos = struct::get_array("light_rune_quest_start", "targetname");
	s_start_pos = Array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("light_rq_started", &function_45c80653, &function_aef2e0a3);
}

/*
	Name: function_45c80653
	Namespace: zm_genesis_util
	Checksum: 0xC1BABAA3
	Offset: 0x42F0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_45c80653(e_who)
{
	return function_af60288e(e_who, 2);
}

/*
	Name: function_aef2e0a3
	Namespace: zm_genesis_util
	Checksum: 0x11627370
	Offset: 0x4320
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_aef2e0a3(e_who)
{
	self function_87cb72e4(e_who, 2);
}

/*
	Name: shadow_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0xEF708087
	Offset: 0x4358
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function shadow_rune_quest_start()
{
	a_s_start_pos = struct::get_array("shadow_rune_quest_start", "targetname");
	s_start_pos = Array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("shadow_rq_started", &function_9944ee4d, &function_6d12ad69);
}

/*
	Name: function_9944ee4d
	Namespace: zm_genesis_util
	Checksum: 0x1F6BD998
	Offset: 0x43F0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_9944ee4d(e_who)
{
	return function_af60288e(e_who, 3);
}

/*
	Name: function_6d12ad69
	Namespace: zm_genesis_util
	Checksum: 0xADD6D0BE
	Offset: 0x4420
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_6d12ad69(e_who)
{
	self function_87cb72e4(e_who, 3);
}

/*
	Name: function_87cb72e4
	Namespace: zm_genesis_util
	Checksum: 0x68BC12F4
	Offset: 0x4458
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function function_87cb72e4(e_who, var_e4342d5d)
{
	level.var_94994361[var_e4342d5d] = e_who;
	function_f3a1c8c5(var_e4342d5d, self);
}

/*
	Name: function_af60288e
	Namespace: zm_genesis_util
	Checksum: 0xF2DB0318
	Offset: 0x44A0
	Size: 0x8D
	Parameters: 2
	Flags: None
*/
function function_af60288e(e_who, var_e4342d5d)
{
	if(zm_utility::is_player_valid(e_who) && !isdefined(level.var_94994361[var_e4342d5d]) && !Array::contains(level.var_94994361, e_who) && e_who flag::get("holding_gateworm"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_5bad746b
	Namespace: zm_genesis_util
	Checksum: 0x13C98F20
	Offset: 0x4538
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_5bad746b()
{
	level flag::wait_till("connect_start_to_left");
	level thread scene::Play("debris_sheffield_prison", "targetname");
}

/*
	Name: function_15e7a0c8
	Namespace: zm_genesis_util
	Checksum: 0x416C9981
	Offset: 0x4590
	Size: 0x203
	Parameters: 3
	Flags: None
*/
function function_15e7a0c8(var_7b429b7d, var_6908e64b, var_4162ae69)
{
	if(!level flag::exists(var_7b429b7d))
	{
		level flag::init(var_7b429b7d);
	}
	v_pos = self.origin;
	v_angles = self.angles;
	level thread function_83fe94ad(v_pos, var_7b429b7d);
	s_unitrigger_stub = spawn_trigger_radius(v_pos, 72, 1, &function_e0596480);
	while(!level flag::get(var_7b429b7d))
	{
		s_unitrigger_stub waittill("trigger", e_who);
		b_eligible = e_who flag::get("holding_gateworm");
		if(isdefined(var_6908e64b))
		{
			b_eligible = [[var_6908e64b]](e_who);
		}
		if(b_eligible)
		{
			level flag::set(var_7b429b7d);
			e_who notify("gateworm_used");
			zm_unitrigger::unregister_unitrigger(s_unitrigger_stub);
			if(e_who flag::get("holding_gateworm"))
			{
				e_who zm_genesis_apothican::function_4aa2c78f();
			}
			e_who function_442d17f2(v_pos, v_angles);
			if(isdefined(var_4162ae69))
			{
				self [[var_4162ae69]](e_who);
			}
		}
	}
}

/*
	Name: function_e0596480
	Namespace: zm_genesis_util
	Checksum: 0xEC88A992
	Offset: 0x47A0
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function function_e0596480(e_who)
{
	return &"";
}

/*
	Name: function_83fe94ad
	Namespace: zm_genesis_util
	Checksum: 0xE4F9D7EE
	Offset: 0x47C0
	Size: 0x217
	Parameters: 2
	Flags: None
*/
function function_83fe94ad(v_start_pos, var_7b429b7d)
{
	while(!level flag::get(var_7b429b7d))
	{
		var_c1dd1728 = Array::get_all_closest(v_start_pos, level.activePlayers, undefined, level.activePlayers.size, 384);
		foreach(var_268f35e1 in var_c1dd1728)
		{
			if(zm_utility::is_player_valid(var_268f35e1))
			{
				if(!isdefined(var_268f35e1.var_46c533bd))
				{
					var_268f35e1.var_46c533bd = [];
				}
				if(var_268f35e1 function_ba3dff48(var_7b429b7d))
				{
					if(!isdefined(var_268f35e1.var_46c533bd))
					{
						var_268f35e1.var_46c533bd = [];
					}
					else if(!IsArray(var_268f35e1.var_46c533bd))
					{
						var_268f35e1.var_46c533bd = Array(var_268f35e1.var_46c533bd);
					}
					var_268f35e1.var_46c533bd[var_268f35e1.var_46c533bd.size] = var_7b429b7d;
					var_268f35e1 thread function_e495c2b6(var_7b429b7d);
					var_268f35e1 thread function_ae4d938c(v_start_pos, 384, 72, "gateworm_used");
				}
			}
		}
		wait(0.2);
	}
}

/*
	Name: function_ba3dff48
	Namespace: zm_genesis_util
	Checksum: 0xB7ACE5BF
	Offset: 0x49E0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function function_ba3dff48(var_7b429b7d)
{
	if(self flag::get("holding_gateworm") && !Array::contains(self.var_46c533bd, var_7b429b7d))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_e495c2b6
	Namespace: zm_genesis_util
	Checksum: 0x20272390
	Offset: 0x4A40
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_e495c2b6(var_7b429b7d)
{
	self endon("disconnect");
	self function_d3845622(var_7b429b7d);
	self.var_46c533bd = Array::exclude(self.var_46c533bd, var_7b429b7d);
}

/*
	Name: function_d3845622
	Namespace: zm_genesis_util
	Checksum: 0xA9F97ADE
	Offset: 0x4AA0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_d3845622(var_7b429b7d)
{
	level endon(var_7b429b7d);
	self flag::wait_till_clear("holding_gateworm");
}

/*
	Name: function_442d17f2
	Namespace: zm_genesis_util
	Checksum: 0xED98CB32
	Offset: 0x4AE0
	Size: 0x21B
	Parameters: 2
	Flags: None
*/
function function_442d17f2(v_start_pos, v_angles)
{
	v_spawn_pos = self GetEye() + AnglesToForward(self getPlayerAngles()) * 64;
	var_7add4736 = util::spawn_model("tag_origin", v_spawn_pos, v_angles);
	mdl_gateworm = util::spawn_model("p7_zm_dlc4_gateworm", v_spawn_pos, v_angles);
	mdl_gateworm LinkTo(var_7add4736);
	mdl_gateworm thread scene::Play("zm_dlc4_gateworm_idle_basin", mdl_gateworm);
	self thread util::delete_on_death(var_7add4736);
	self thread util::delete_on_death(mdl_gateworm);
	mdl_gateworm thread function_9646de9a();
	v_ground_pos = bullettrace(v_start_pos, v_start_pos + VectorScale((0, 0, -1), 100000), 0, mdl_gateworm)["position"];
	var_7add4736 moveto(v_ground_pos, 4);
	var_7add4736 playsound("zmb_main_searchparty_worm_appear");
	var_7add4736 PlayLoopSound("zmb_main_omelettes_worm_lp", 1);
	var_7add4736 waittill("movedone");
	mdl_gateworm thread function_364b1972(var_7add4736);
}

/*
	Name: function_9646de9a
	Namespace: zm_genesis_util
	Checksum: 0x9A8D3182
	Offset: 0x4D08
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_9646de9a()
{
	self clientfield::set("rq_gateworm_magic", 1);
	wait(2);
	self playsound("zmb_main_searchparty_worm_disapparate");
	self StopLoopSound(3);
	self SetModel("p7_zm_dlc4_gateworm_dissolve");
	self clientfield::set("rq_gateworm_dissolve_finish", 1);
	wait(2);
}

/*
	Name: function_364b1972
	Namespace: zm_genesis_util
	Checksum: 0x42E0FF12
	Offset: 0x4DC0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_364b1972(var_7add4736)
{
	self ghost();
	wait(0.8);
	self clientfield::set("rq_gateworm_magic", 0);
	self delete();
	var_7add4736 delete();
}

/*
	Name: function_f3a1c8c5
	Namespace: zm_genesis_util
	Checksum: 0x9D3BDC00
	Offset: 0x4E48
	Size: 0x397
	Parameters: 2
	Flags: None
*/
function function_f3a1c8c5(var_e4342d5d, s_pos)
{
	switch(var_e4342d5d)
	{
		case 0:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_electricity_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_electricity_bundle";
			break;
		}
		case 1:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_fire_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_fire_bundle";
			break;
		}
		case 2:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_light_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_light_bundle";
			break;
		}
		case 3:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_shadow_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_shadow_bundle";
			break;
		}
	}
	level.var_7bddd74e[var_e4342d5d] = util::spawn_model(var_25b51f6b, s_pos.origin, s_pos.angles - VectorScale((0, 1, 0), 90));
	mdl_rune = level.var_7bddd74e[var_e4342d5d];
	mdl_rune thread scene::Play(var_b96024, mdl_rune);
	mdl_rune clientfield::set("rq_rune_glow", 1);
	v_pos = bullettrace(self.origin, self.origin + VectorScale((0, 0, -1), 100000), 0, s_pos)["position"];
	v_pos = v_pos + VectorScale((0, 0, 1), 32);
	s_unitrigger_stub = spawn_trigger_radius(v_pos, 128, 1);
	s_unitrigger_stub.var_e4342d5d = var_e4342d5d;
	s_unitrigger_stub.hint_string = "";
	if(DistanceSquared(mdl_rune.origin, v_pos) > 102400)
	{
		mdl_rune.origin = v_pos;
	}
	if(DistanceSquared(mdl_rune.origin, v_pos) > 102400)
	{
		mdl_rune.origin = v_pos;
	}
	while(1)
	{
		s_unitrigger_stub waittill("trigger", e_who);
		if(zm_utility::is_player_valid(e_who) && (e_who == level.var_94994361[var_e4342d5d] || !isdefined(level.var_94994361[var_e4342d5d])))
		{
			zm_unitrigger::unregister_unitrigger(s_unitrigger_stub);
			mdl_rune delete();
			e_who playsound("zmb_main_searchparty_rune_pickup");
			e_who function_bb26d959(var_e4342d5d);
			if(isdefined(self))
			{
				self notify("hash_22e3a570");
			}
			return;
		}
	}
}

/*
	Name: function_bb26d959
	Namespace: zm_genesis_util
	Checksum: 0x3DF88EBD
	Offset: 0x51E8
	Size: 0x253
	Parameters: 1
	Flags: None
*/
function function_bb26d959(var_e4342d5d)
{
	level.var_94994361[var_e4342d5d] = undefined;
	level.var_3787c9a[var_e4342d5d] = undefined;
	switch(var_e4342d5d)
	{
		case 0:
		{
			level flag::set("electricity_rq_done");
			str_text = "ELECTRICITY RUNE";
			str_tag_name = "electricity";
			n_x_pos = 10;
			n_y_pos = 200;
			break;
		}
		case 1:
		{
			level flag::set("fire_rq_done");
			str_text = "FIRE RUNE";
			str_tag_name = "fire";
			n_x_pos = 10;
			n_y_pos = 220;
			break;
		}
		case 2:
		{
			level flag::set("light_rq_done");
			str_text = "LIGHT RUNE";
			str_tag_name = "light";
			n_x_pos = 10;
			n_y_pos = 240;
			break;
		}
		case 3:
		{
			level flag::set("shadow_rq_done");
			str_text = "SHADOW RUNE";
			str_tag_name = "shadow";
			n_x_pos = 10;
			n_y_pos = 260;
			break;
		}
	}
	if(!isdefined(level.var_b1b99f8d))
	{
		level.var_b1b99f8d = [];
	}
	else if(!IsArray(level.var_b1b99f8d))
	{
		level.var_b1b99f8d = Array(level.var_b1b99f8d);
	}
	level.var_b1b99f8d[level.var_b1b99f8d.size] = var_e4342d5d;
	function_1e620a08(str_tag_name);
	self thread function_e7fa3600(var_e4342d5d);
}

/*
	Name: function_1e620a08
	Namespace: zm_genesis_util
	Checksum: 0x8366C829
	Offset: 0x5448
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_1e620a08(str_tag_name)
{
	var_c0132a00 = GetEnt("rift_entrance_rune_portal", "targetname");
	var_c0132a00 HidePart("tag_" + str_tag_name + "_off");
	var_c0132a00 ShowPart("tag_" + str_tag_name + "_on");
}

/*
	Name: function_e7fa3600
	Namespace: zm_genesis_util
	Checksum: 0x2500A41E
	Offset: 0x54E8
	Size: 0x149
	Parameters: 1
	Flags: None
*/
function function_e7fa3600(var_e4342d5d)
{
	switch(var_e4342d5d)
	{
		case 0:
		{
			str_text = "gen_rune_electricity";
			break;
		}
		case 1:
		{
			str_text = "gen_rune_fire";
			break;
		}
		case 2:
		{
			str_text = "gen_rune_light";
			break;
		}
		case 3:
		{
			str_text = "gen_rune_shadow";
			break;
		}
	}
	level clientfield::set(str_text, 1);
	level notify("widget_ui_override");
	foreach(e_player in level.players)
	{
		e_player thread function_22510e73("zmInventory.widget_rune_parts", "zmInventory.player_rune_quest", 0);
	}
}

/*
	Name: function_22510e73
	Namespace: zm_genesis_util
	Checksum: 0x6FB06C4A
	Offset: 0x5640
	Size: 0xD3
	Parameters: 3
	Flags: Private
*/
function private function_22510e73(str_crafted_clientuimodel, str_widget_clientuimodel, b_is_crafted)
{
	self endon("disconnect");
	if(b_is_crafted)
	{
		if(isdefined(str_crafted_clientuimodel))
		{
			self thread clientfield::set_player_uimodel(str_crafted_clientuimodel, 1);
		}
		n_show_ui_duration = 3.5;
	}
	else
	{
		n_show_ui_duration = 3.5;
	}
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 1);
	level util::waittill_any_ex(n_show_ui_duration, "widget_ui_override", self, "disconnect");
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: function_ae4d938c
	Namespace: zm_genesis_util
	Checksum: 0xE58BEB45
	Offset: 0x5720
	Size: 0x279
	Parameters: 4
	Flags: None
*/
function function_ae4d938c(v_target_pos, var_e57941b7, var_ca841609, str_endon_notify)
{
	self endon("bleed_out");
	self endon("death");
	self endon("disconnect");
	self endon(str_endon_notify);
	n_pulse_delay_range = 2.4;
	var_38a8139 = var_e57941b7 * var_e57941b7;
	var_2b515bba = var_e57941b7 - var_ca841609;
	n_scaled_pulse_delay = undefined;
	n_time_before_next_pulse = undefined;
	n_scale = undefined;
	n_rumble = undefined;
	var_55ae5d19 = 1000;
	while(1)
	{
		n_z_diff = Abs(v_target_pos[2] - self.origin[2]);
		n_dist_sq = Distance2DSquared(self.origin, v_target_pos);
		if(n_dist_sq <= var_38a8139 && n_z_diff < 84)
		{
			n_dist = Distance2D(self.origin, v_target_pos) - var_ca841609;
			if(n_dist < 0)
			{
			}
			else
			{
			}
			n_dist = n_dist;
			n_scale = n_dist / var_2b515bba;
			n_scaled_pulse_delay = n_scale * n_pulse_delay_range;
			n_time_before_next_pulse = 0.2 + n_scaled_pulse_delay;
			if(n_dist < var_2b515bba * 0.25)
			{
			}
			else
			{
			}
			n_rumble = 1;
		}
		else
		{
			n_time_before_next_pulse = undefined;
		}
		if(isdefined(n_time_before_next_pulse) && var_55ae5d19 > n_time_before_next_pulse)
		{
			var_55ae5d19 = 0;
			self thread do_pulse(n_rumble);
		}
		wait(0.05);
		var_55ae5d19 = var_55ae5d19 + 0.05;
	}
}

/*
	Name: do_pulse
	Namespace: zm_genesis_util
	Checksum: 0xFB7BD4C8
	Offset: 0x59A8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function do_pulse(n_rumble)
{
	self playsoundtoplayer("zmb_main_searchparty_ping", self);
	self set_rumble_to_player(n_rumble);
	util::wait_network_frame();
	self set_rumble_to_player(0);
}

/*
	Name: function_32c765c5
	Namespace: zm_genesis_util
	Checksum: 0x2F172E6B
	Offset: 0x5A20
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function function_32c765c5(v_origin)
{
	n_closest_dist = 1E+07;
	a_players = GetPlayers();
	for(i = 0; i < a_players.size; i++)
	{
		n_dist = Distance(a_players[i].origin, v_origin);
		if(n_dist < n_closest_dist)
		{
			n_closest_dist = n_dist;
		}
	}
	return n_closest_dist;
}

/*
	Name: function_a3c6e02f
	Namespace: zm_genesis_util
	Checksum: 0xBEDA4CA6
	Offset: 0x5AE8
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function function_a3c6e02f(e_to_delete, str_notify, n_delay)
{
	e_to_delete endon("death");
	self waittill(str_notify);
	wait(n_delay);
	if(isdefined(e_to_delete))
	{
		e_to_delete delete();
	}
}

/*
	Name: get_lookat_angles
	Namespace: zm_genesis_util
	Checksum: 0xEB8E6EAC
	Offset: 0x5B50
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function get_lookat_angles(v_start, v_end)
{
	v_dir = v_end - v_start;
	v_dir = VectorNormalize(v_dir);
	v_angles = VectorToAngles(v_dir);
	return v_angles;
}

/*
	Name: watch_for_open_sesame
	Namespace: zm_genesis_util
	Checksum: 0x1B60DA99
	Offset: 0x5BC8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function watch_for_open_sesame()
{
	/#
		level waittill("open_sesame");
		a_e_power = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		foreach(e_power in a_e_power)
		{
			e_power.var_98e1d15 = 1;
			n_power_zone = e_power.script_int;
			level thread zm_power::turn_power_on_and_open_doors(n_power_zone);
		}
		zm_zonemgr::enable_zone("Dev Block strings are not supported");
	#/
}

/*
	Name: function_8faf1d24
	Namespace: zm_genesis_util
	Checksum: 0x70F4A824
	Offset: 0x5CE8
	Size: 0x107
	Parameters: 4
	Flags: None
*/
function function_8faf1d24(v_color, str_print, n_scale, str_endon)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = VectorScale((0, 0, 1), 255);
		}
		if(!isdefined(str_print))
		{
			str_print = "Dev Block strings are not supported";
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
			print3d(origin, str_print, v_color, n_scale);
			wait(0.1);
		}
	#/
}

/*
	Name: debug_draw_line
	Namespace: zm_genesis_util
	Checksum: 0x42CC1E75
	Offset: 0x5DF8
	Size: 0xBF
	Parameters: 5
	Flags: None
*/
function debug_draw_line(v_start, v_end, str_endon, v_color, str_endon2)
{
	/#
		if(!isdefined(str_endon))
		{
			str_endon = "Dev Block strings are not supported";
		}
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(str_endon2))
		{
			str_endon2 = "Dev Block strings are not supported";
		}
		self endon(str_endon);
		self endon(str_endon2);
		while(1)
		{
			recordLine(v_start, v_end, v_color, "Dev Block strings are not supported", self);
			wait(0.05);
		}
	#/
}

/*
	Name: function_9ff5370d
	Namespace: zm_genesis_util
	Checksum: 0x1747F9B8
	Offset: 0x5EC0
	Size: 0xA7
	Parameters: 4
	Flags: None
*/
function function_9ff5370d(v_origin, n_radius, v_color, e_owner)
{
	/#
		if(!isdefined(n_radius))
		{
			n_radius = 64;
		}
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(e_owner))
		{
			e_owner = self;
		}
		self endon("hash_dc898c8");
		while(isdefined(self))
		{
			RecordCircle(v_origin, n_radius, v_color, "Dev Block strings are not supported", e_owner);
			wait(0.05);
		}
	#/
}

/*
	Name: function_68a764f6
	Namespace: zm_genesis_util
	Checksum: 0xC23C43C9
	Offset: 0x5F70
	Size: 0xA7
	Parameters: 3
	Flags: None
*/
function function_68a764f6(n_radius, v_color, e_owner)
{
	/#
		if(!isdefined(n_radius))
		{
			n_radius = 64;
		}
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(e_owner))
		{
			e_owner = self;
		}
		self endon("hash_5322c93b");
		while(isdefined(self))
		{
			RecordSphere(self.origin, n_radius, v_color, "Dev Block strings are not supported", e_owner);
			wait(0.05);
		}
	#/
}

/*
	Name: function_ff016910
	Namespace: zm_genesis_util
	Checksum: 0xFEE0C0F1
	Offset: 0x6020
	Size: 0x8F
	Parameters: 3
	Flags: None
*/
function function_ff016910(str_text, v_color, e_owner)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(e_owner))
		{
			e_owner = self;
		}
		self endon("hash_8fba9");
		while(isdefined(self))
		{
			Record3DText(str_text, self.origin, v_color, "Dev Block strings are not supported", e_owner);
			wait(0.05);
		}
	#/
}

/*
	Name: debug_draw_arrow
	Namespace: zm_genesis_util
	Checksum: 0xC3E74598
	Offset: 0x60B8
	Size: 0x1B7
	Parameters: 2
	Flags: None
*/
function debug_draw_arrow(v_color, str_ender)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(str_ender))
		{
			str_ender = "Dev Block strings are not supported";
		}
		self endon("death");
		level endon(str_ender);
		for(;;)
		{
			FORWARD = AnglesToForward(self.angles);
			forwardFar = VectorScale(FORWARD, 30);
			forwardClose = VectorScale(FORWARD, 20);
			right = AnglesToRight(self.angles);
			left = VectorScale(right, -10);
			right = VectorScale(right, 10);
			line(self.origin, self.origin + forwardFar, v_color, 0.9);
			line(self.origin + forwardFar, self.origin + forwardClose + right, v_color, 0.9);
			line(self.origin + forwardFar, self.origin + forwardClose + left, v_color, 0.9);
			wait(0.05);
		}
	#/
}

/*
	Name: function_d8db939b
	Namespace: zm_genesis_util
	Checksum: 0x4528B9BE
	Offset: 0x6278
	Size: 0x143
	Parameters: 3
	Flags: None
*/
function function_d8db939b(str_flag, var_6e86b6bc, str_ender)
{
	/#
		if(!isdefined(var_6e86b6bc))
		{
			var_6e86b6bc = 0;
		}
		if(!isdefined(str_ender))
		{
			str_ender = "Dev Block strings are not supported";
		}
		level endon(str_ender);
		if(level flag::get(str_flag))
		{
			print("Dev Block strings are not supported" + str_flag + "Dev Block strings are not supported" + "Dev Block strings are not supported");
			if(var_6e86b6bc)
			{
				IPrintLnBold("Dev Block strings are not supported" + str_flag + "Dev Block strings are not supported");
			}
			return;
		}
		level flag::wait_till(str_flag);
		print("Dev Block strings are not supported" + str_flag + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		if(var_6e86b6bc)
		{
			IPrintLnBold("Dev Block strings are not supported" + str_flag + "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_1f006e62
	Namespace: zm_genesis_util
	Checksum: 0xD670CBE4
	Offset: 0x63C8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_1f006e62()
{
	/#
		level thread debug_spawn_points();
		level thread function_1953a761();
		level thread function_c0411192();
		level thread function_90c620d8();
	#/
}

/*
	Name: function_c0411192
	Namespace: zm_genesis_util
	Checksum: 0xB066B9D1
	Offset: 0x6438
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_c0411192()
{
	/#
		level notify("hash_7fb84095");
		var_3e38f0ae = struct::get_array("Dev Block strings are not supported");
		a_s_parts = struct::get_array("Dev Block strings are not supported");
		var_3e38f0ae = ArrayCombine(var_3e38f0ae, a_s_parts, 0, 0);
		a_s_parts = struct::get_array("Dev Block strings are not supported");
		var_3e38f0ae = ArrayCombine(var_3e38f0ae, a_s_parts, 0, 0);
		a_s_parts = struct::get_array("Dev Block strings are not supported");
		var_3e38f0ae = ArrayCombine(var_3e38f0ae, a_s_parts, 0, 0);
		Array::thread_all(var_3e38f0ae, &function_b411d2a8);
	#/
}

/*
	Name: function_6c518807
	Namespace: zm_genesis_util
	Checksum: 0xA4C1C8A
	Offset: 0x6568
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_6c518807()
{
	/#
		level notify("hash_6fd18b70");
		var_3e38f0ae = struct::get_array("Dev Block strings are not supported");
		a_s_parts = struct::get_array("Dev Block strings are not supported");
		var_3e38f0ae = ArrayCombine(var_3e38f0ae, a_s_parts, 0, 0);
		a_s_parts = struct::get_array("Dev Block strings are not supported");
		var_3e38f0ae = ArrayCombine(var_3e38f0ae, a_s_parts, 0, 0);
		a_s_parts = struct::get_array("Dev Block strings are not supported");
		var_3e38f0ae = ArrayCombine(var_3e38f0ae, a_s_parts, 0, 0);
		Array::thread_all(var_3e38f0ae, &function_ba547024);
	#/
}

/*
	Name: function_ba547024
	Namespace: zm_genesis_util
	Checksum: 0x2FF79D55
	Offset: 0x6698
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function function_ba547024()
{
	/#
		level endon("hash_6fd18b70");
		v_color = (0, 1, 0);
		n_radius = 32;
		if(self.targetname == "Dev Block strings are not supported")
		{
			v_color = (1, 1, 0);
			n_radius = 16;
		}
		self thread debug_draw_arrow(v_color, "Dev Block strings are not supported");
		while(1)
		{
			circle(self.origin, n_radius, v_color);
			wait(0.05);
		}
	#/
}

/*
	Name: function_b411d2a8
	Namespace: zm_genesis_util
	Checksum: 0x454163C8
	Offset: 0x6758
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function function_b411d2a8()
{
	/#
		level endon("hash_7fb84095");
		if(!IsPointOnNavMesh(self.origin))
		{
			print("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
			while(!IsPointOnNavMesh(self.origin) && function_4086bd17(self.origin))
			{
				sphere(self.origin, 16, (1, 0, 0));
				print3d(self.origin + VectorScale((0, 0, 1), 16), self.origin + "Dev Block strings are not supported", (1, 0, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: debug_spawn_points
	Namespace: zm_genesis_util
	Checksum: 0x25D1C64C
	Offset: 0x6860
	Size: 0x21B
	Parameters: 0
	Flags: None
*/
function debug_spawn_points()
{
	/#
		level notify("hash_79ca2895");
		a_s_points = struct::get_array("Dev Block strings are not supported");
		a_s_respawn_points = [];
		foreach(s_respawn in a_s_points)
		{
			var_c901c998 = struct::get_array(s_respawn.target);
			foreach(s_point in var_c901c998)
			{
				a_s_respawn_points[j] = s_point;
			}
		}
		a_s_spawn_points = ArrayCombine(a_s_points, a_s_respawn_points, 0, 0);
		var_c16df719 = struct::get_array("Dev Block strings are not supported");
		Array::thread_all(var_c16df719, &function_2e9f38b0);
		Array::thread_all(a_s_spawn_points, &function_7129ea51);
		Array::thread_all(level.zones, &function_3d73091f);
	#/
}

/*
	Name: function_f448730a
	Namespace: zm_genesis_util
	Checksum: 0xA81E760C
	Offset: 0x6A88
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_f448730a()
{
	/#
		level notify("hash_3e617e39");
		for(i = 1; i < 4; i++)
		{
			level scene::add_scene_func("Dev Block strings are not supported" + i, &function_871166cb, "Dev Block strings are not supported");
		}
		Array::thread_all(level.zones, &function_a41558a6);
	#/
}

/*
	Name: function_81eb9b35
	Namespace: zm_genesis_util
	Checksum: 0x353F64EA
	Offset: 0x6B30
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_81eb9b35()
{
	/#
		level notify("hash_3e617e39");
		for(i = 1; i < 4; i++)
		{
			level scene::remove_scene_func("Dev Block strings are not supported" + i, &function_871166cb, "Dev Block strings are not supported");
		}
		Array::thread_all(level.zones, &function_141ddc35);
	#/
}

/*
	Name: function_871166cb
	Namespace: zm_genesis_util
	Checksum: 0x7340E962
	Offset: 0x6BD8
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function function_871166cb(a_ents)
{
	/#
		a_ents[0] thread debug_draw_arrow((1, 1, 0), "Dev Block strings are not supported");
		RecordEnt(a_ents[0]);
		if(!IsPointOnNavMesh(a_ents[0].origin))
		{
			for(i = 0; i < 20; i++)
			{
				sphere(a_ents[0].origin, 16, (1, 0, 0));
				print3d(a_ents[0].origin + VectorScale((0, 0, 1), 16), a_ents[0].origin + "Dev Block strings are not supported", (1, 0, 0));
				wait(0.05);
			}
		}
		wait(3);
		if(isai(a_ents[0]))
		{
			return;
		}
		a_ents[0] delete();
	#/
}

/*
	Name: function_a41558a6
	Namespace: zm_genesis_util
	Checksum: 0x12092520
	Offset: 0x6D38
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_a41558a6()
{
	/#
		foreach(a_locs in self.a_loc_types)
		{
			Array::thread_all(a_locs, &function_835d6248);
		}
	#/
}

/*
	Name: function_141ddc35
	Namespace: zm_genesis_util
	Checksum: 0x4698411C
	Offset: 0x6DE0
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_141ddc35()
{
	/#
		foreach(a_locs in self.a_loc_types)
		{
			Array::thread_all(a_locs, &function_3e617e39);
		}
	#/
}

/*
	Name: function_3d73091f
	Namespace: zm_genesis_util
	Checksum: 0x3D2B192C
	Offset: 0x6E88
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function function_3d73091f()
{
	/#
		/#
			Assert(self.a_loc_types["Dev Block strings are not supported"].size > 0, "Dev Block strings are not supported" + self.Volumes[0].targetname + "Dev Block strings are not supported");
		#/
		foreach(a_locs in self.a_loc_types)
		{
			Array::thread_all(a_locs, &function_2e9f38b0);
		}
	#/
}

/*
	Name: function_2e9f38b0
	Namespace: zm_genesis_util
	Checksum: 0x5EB31350
	Offset: 0x6F80
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function function_2e9f38b0()
{
	/#
		level endon("hash_79ca2895");
		if(self.script_noteworthy == "Dev Block strings are not supported")
		{
			return;
		}
		if(!IsPointOnNavMesh(self.origin) && self.script_noteworthy != "Dev Block strings are not supported")
		{
			print("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
			while(!IsPointOnNavMesh(self.origin))
			{
				sphere(self.origin, 32, (1, 0, 0));
				print3d(self.origin + VectorScale((0, 0, 1), 16), self.origin + "Dev Block strings are not supported" + self.script_noteworthy + "Dev Block strings are not supported" + self.zone_name, (1, 0, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_e0a812f0
	Namespace: zm_genesis_util
	Checksum: 0xBF34817E
	Offset: 0x70B0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_e0a812f0()
{
	/#
		if(self.script_noteworthy == "Dev Block strings are not supported")
		{
			if(!isdefined(self.var_640b69b2))
			{
				self.var_640b69b2 = util::spawn_model("Dev Block strings are not supported", self.origin, self.angles);
			}
			self.var_640b69b2 scene::Play("Dev Block strings are not supported" + randomIntRange(1, 3));
			if(isdefined(self.var_969d82a4))
			{
				self.var_969d82a4 delete();
			}
		}
	#/
}

/*
	Name: function_835d6248
	Namespace: zm_genesis_util
	Checksum: 0x540E72A0
	Offset: 0x7180
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_835d6248()
{
	/#
		level endon("hash_3e617e39");
		if(self.script_noteworthy == "Dev Block strings are not supported")
		{
			while(1)
			{
				if(!isdefined(self.var_640b69b2))
				{
					self.var_640b69b2 = util::spawn_model("Dev Block strings are not supported", self.origin, self.angles);
					self.var_640b69b2 thread debug_draw_arrow(undefined, "Dev Block strings are not supported");
				}
				self.var_640b69b2 scene::Play("Dev Block strings are not supported" + randomIntRange(1, 3));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_3e617e39
	Namespace: zm_genesis_util
	Checksum: 0xB2495475
	Offset: 0x7260
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_3e617e39()
{
	/#
		if(self.script_noteworthy == "Dev Block strings are not supported")
		{
			if(isdefined(self.var_640b69b2))
			{
				for(i = 1; i < 4; i++)
				{
					self.var_640b69b2 scene::stop("Dev Block strings are not supported" + i);
				}
				self.var_640b69b2 delete();
			}
		}
	#/
}

/*
	Name: function_7129ea51
	Namespace: zm_genesis_util
	Checksum: 0x359FA1DA
	Offset: 0x72F8
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_7129ea51()
{
	/#
		level endon("hash_79ca2895");
		if(!IsPointOnNavMesh(self.origin))
		{
			print("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
			while(!IsPointOnNavMesh(self.origin))
			{
				sphere(self.origin, 16, (1, 0, 0));
				print3d(self.origin + VectorScale((0, 0, 1), 16), self.origin + "Dev Block strings are not supported" + self.script_noteworthy, (1, 0, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_1953a761
	Namespace: zm_genesis_util
	Checksum: 0xBACC07E6
	Offset: 0x73E8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_1953a761()
{
	/#
		level notify("hash_4a4c33ec");
		a_s_points = struct::get_array("Dev Block strings are not supported");
		Array::thread_all(a_s_points, &function_ed69d7f4);
	#/
}

/*
	Name: function_ed69d7f4
	Namespace: zm_genesis_util
	Checksum: 0x689770ED
	Offset: 0x7450
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function function_ed69d7f4()
{
	/#
		level endon("hash_4a4c33ec");
		if(!IsPointOnNavMesh(self.origin, 61.88) || function_4086bd17(self.origin))
		{
			print("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
			while(1)
			{
				sphere(self.origin, 61.88, (1, 1, 0));
				print3d(self.origin + VectorScale((0, 0, 1), 16), self.origin + "Dev Block strings are not supported", (1, 1, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_4086bd17
	Namespace: zm_genesis_util
	Checksum: 0x6994D320
	Offset: 0x7560
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function function_4086bd17(v_point)
{
	/#
		a_trace = bullettrace(v_point, v_point + VectorScale((0, 0, -1), 2000), 0, undefined, 0);
		if(Distance2DSquared(a_trace["Dev Block strings are not supported"], v_point) > 36)
		{
			return 1;
		}
		return 0;
	#/
}

/*
	Name: function_90c620d8
	Namespace: zm_genesis_util
	Checksum: 0x71323A63
	Offset: 0x75E8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_90c620d8()
{
	/#
		level notify("hash_6aa36145");
		a_t_blockers = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		Array::thread_all(a_t_blockers, &function_7b7eeb90);
	#/
}

/*
	Name: function_5e8cafb9
	Namespace: zm_genesis_util
	Checksum: 0xD5EEDDCD
	Offset: 0x7658
	Size: 0xC1
	Parameters: 0
	Flags: None
*/
function function_5e8cafb9()
{
	/#
		level notify("hash_27118146");
		foreach(t_door in self)
		{
			if(isdefined(t_door.script_flag))
			{
				level thread function_d8db939b(t_door.script_flag, 1, "Dev Block strings are not supported");
			}
		}
	#/
}

/*
	Name: function_7b7eeb90
	Namespace: zm_genesis_util
	Checksum: 0x9FEE3DD9
	Offset: 0x7728
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_7b7eeb90()
{
	/#
		var_3ccf13b = self function_78e15936();
	#/
}

/*
	Name: function_78e15936
	Namespace: zm_genesis_util
	Checksum: 0x12C54CB3
	Offset: 0x7758
	Size: 0x14D
	Parameters: 0
	Flags: None
*/
function function_78e15936()
{
	/#
		var_3ccf13b = [];
		a_e_targets = GetEntArray(self.target, "Dev Block strings are not supported");
		foreach(e_target in a_e_targets)
		{
			if(e_target.classname == "Dev Block strings are not supported" || e_target.script_string === "Dev Block strings are not supported")
			{
				if(!isdefined(var_3ccf13b))
				{
					var_3ccf13b = [];
				}
				else if(!IsArray(var_3ccf13b))
				{
					var_3ccf13b = Array(var_3ccf13b);
				}
				var_3ccf13b[var_3ccf13b.size] = e_target;
			}
		}
		return var_3ccf13b;
	#/
}

/*
	Name: function_bc81bb3b
	Namespace: zm_genesis_util
	Checksum: 0x384C1E32
	Offset: 0x78B0
	Size: 0x327
	Parameters: 0
	Flags: None
*/
function function_bc81bb3b()
{
	/#
		level endon("hash_27118146");
		if(!isdefined(self.script_flag))
		{
			if(isdefined(self.script_noteworthy))
			{
				while(1)
				{
					print3d(self.origin + VectorScale((0, 0, 1), 64), "Dev Block strings are not supported" + self.script_noteworthy, (0, 0, 1), 1, 0.5);
					wait(0.05);
				}
			}
			return;
		}
		while(1)
		{
			n_offset = 0;
			a_n_offsets = [];
			v_color = (1, 1, 0);
			if(level flag::exists(self.script_flag) && level flag::get(self.script_flag))
			{
				v_color = (0, 1, 0);
			}
			print3d(self.origin + VectorScale((0, 0, 1), 64), "Dev Block strings are not supported" + self.script_flag, v_color, 1, 0.5);
			if(isdefined(level.zone_flags[self.script_flag]))
			{
				foreach(str_flag in level.zone_flags[self.script_flag])
				{
					n_offset = n_offset - 16;
					a_n_offsets[i] = n_offset;
				}
				foreach(str_flag in level.zone_flags[self.script_flag])
				{
					var_1adee14a = (1, 1, 0);
					if(level flag::exists(str_flag) && level flag::get(str_flag))
					{
						var_1adee14a = (0, 1, 0);
					}
					print3d(self.origin + (0, 0, 64 + a_n_offsets[j]), "Dev Block strings are not supported" + str_flag, var_1adee14a, 1, 0.5);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_b3db2cea
	Namespace: zm_genesis_util
	Checksum: 0x92BDEFCA
	Offset: 0x7BE0
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_b3db2cea()
{
	/#
		level endon("hash_4a4c33ec");
		if(!IsPointOnNavMesh(self.origin, 96))
		{
			print("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
			while(!IsPointOnNavMesh(self.origin))
			{
				sphere(self.origin, 96, (1, 1, 0), 0.5);
				print3d(self.origin + VectorScale((0, 0, 1), 16), "Dev Block strings are not supported", (1, 1, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: Devgui
	Namespace: zm_genesis_util
	Checksum: 0x76FB0AEA
	Offset: 0x7CD0
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function Devgui()
{
	/#
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		level thread setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &zm_genesis_minor_ee::function_e1963311);
		zm_devgui::add_custom_devgui_callback(&zm_genesis_devgui);
	#/
}

/*
	Name: zm_genesis_devgui
	Namespace: zm_genesis_util
	Checksum: 0x54FA2C87
	Offset: 0x7F08
	Size: 0x53D
	Parameters: 1
	Flags: None
*/
function zm_genesis_devgui(cmd)
{
	/#
		cmd_strings = StrTok(cmd, "Dev Block strings are not supported");
		switch(cmd_strings[0])
		{
			case "Dev Block strings are not supported":
			{
				a_t_blockers = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
				a_t_blockers thread function_5e8cafb9();
				foreach(t_door in a_t_blockers)
				{
					var_3ccf13b = t_door function_78e15936();
					Array::thread_all(var_3ccf13b, &function_bc81bb3b);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				level notify("hash_27118146");
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_712a86f4(1);
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_712a86f4(2);
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_712a86f4(3);
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_712a86f4(4);
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_f448730a();
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_81eb9b35();
				break;
			}
			case "Dev Block strings are not supported":
			{
				function_6c518807();
				break;
			}
			case "Dev Block strings are not supported":
			{
				level notify("hash_6fd18b70");
				break;
			}
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] function_4667bb64();
				break;
			}
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] function_4530c3b2();
				break;
			}
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] function_c78305e0();
				break;
			}
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] function_d5c8a6c2();
				break;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.activePlayers)
				{
					e_player zm_genesis_apothican::give_egg();
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.activePlayers)
				{
					e_player zm_genesis_apothican::function_42781615();
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(level.ball))
				{
					level.ball ball::reset_ball(0);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_76c3e6c4();
				break;
			}
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.activePlayers)
				{
					level thread _zm_weap_octobomb::octobomb_give(e_player);
				}
				break;
			}
			case default:
			{
			}
		}
	#/
}

/*
	Name: function_4667bb64
	Namespace: zm_genesis_util
	Checksum: 0x6BA2EA73
	Offset: 0x8450
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_4667bb64()
{
	/#
		self endon("death");
		ball::function_b4352e6c(self);
	#/
}

/*
	Name: function_4530c3b2
	Namespace: zm_genesis_util
	Checksum: 0x6F029834
	Offset: 0x8480
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_4530c3b2()
{
	/#
		self endon("death");
		ball::function_7eb07bb0(self);
	#/
}

/*
	Name: function_c78305e0
	Namespace: zm_genesis_util
	Checksum: 0x806758AF
	Offset: 0x84B0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_c78305e0()
{
	/#
		self endon("death");
		ball::give_player_ball(self);
	#/
}

/*
	Name: function_d5c8a6c2
	Namespace: zm_genesis_util
	Checksum: 0x546737A9
	Offset: 0x84E0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_d5c8a6c2()
{
	/#
		self endon("death");
		ball::function_257ed160(self, 1);
	#/
}

/*
	Name: function_712a86f4
	Namespace: zm_genesis_util
	Checksum: 0x10308350
	Offset: 0x8518
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function function_712a86f4(n_power_zone)
{
	/#
		a_e_power = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		foreach(e_power in a_e_power)
		{
			if(e_power.script_int == n_power_zone)
			{
				e_power.var_98e1d15 = 1;
				n_power_zone = e_power.script_int;
				level thread zm_power::turn_power_on_and_open_doors(n_power_zone);
			}
		}
	#/
}

/*
	Name: function_30672281
	Namespace: zm_genesis_util
	Checksum: 0x5B82CFD5
	Offset: 0x8630
	Size: 0x1E5
	Parameters: 0
	Flags: None
*/
function function_30672281()
{
	/#
		var_2f06ca53 = 0;
		var_f1ef8e43 = [];
		while(1)
		{
			for(i = 0; i < level.activePlayers.size; i++)
			{
				n_ypos = var_2f06ca53 * 10 + 11;
				if(isdefined(level.activePlayers[i]))
				{
					if(IsGodMode(level.activePlayers[i]) && !isdefined(var_f1ef8e43[level.activePlayers[i].name]))
					{
						var_f1ef8e43[level.activePlayers[i].name] = function_a1bfa962(level.activePlayers[i], level.activePlayers[i].name + "Dev Block strings are not supported", 2, n_ypos);
						var_2f06ca53++;
					}
					if(!IsGodMode(level.activePlayers[i]) && isdefined(var_f1ef8e43[level.activePlayers[i].name]))
					{
						var_f1ef8e43[level.activePlayers[i].name] destroy();
						var_2f06ca53--;
					}
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: function_76c3e6c4
	Namespace: zm_genesis_util
	Checksum: 0xA5DADD54
	Offset: 0x8820
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function function_76c3e6c4()
{
	/#
		foreach(e_player in level.activePlayers)
		{
			e_player.b_wall_run_enabled = 1;
			e_player allowwallrun(1);
			e_player allowdoublejump(1);
			e_player setPerk("Dev Block strings are not supported");
			e_player.var_7dd18a0 = 1;
		}
	#/
}

