#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_rocketshield;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_shadowman;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#namespace namespace_81256d2f;

/*
	Name: __init__sytem__
	Namespace: namespace_81256d2f
	Checksum: 0xEDEF4CC
	Offset: 0x8C0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_pods", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_81256d2f
	Checksum: 0x827A14BE
	Offset: 0x908
	Size: 0x67B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "ZM_ZOD_UI_POD_SPRAYER_PICKUP", 1, 1, "int");
	clientfield::register("scriptmover", "update_fungus_pod_level", 1, 3, "int");
	clientfield::register("scriptmover", "pod_sprayer_glint", 1, 1, "int");
	clientfield::register("scriptmover", "pod_miasma", 1, 1, "counter");
	clientfield::register("scriptmover", "pod_harvest", 1, 1, "counter");
	clientfield::register("scriptmover", "pod_self_destruct", 1, 1, "counter");
	clientfield::register("toplayer", "pod_sprayer_held", 1, 1, "int");
	clientfield::register("toplayer", "pod_sprayer_hint_range", 1, 1, "int");
	level.var_6fa2f6ca = spawnstruct();
	level.var_6fa2f6ca.var_653c4928 = Array(0, 0, 0, 0.25, 0.25, 0.5, 0.5, 1);
	a_table = table::load("gamedata/tables/zm/zm_zod_pods.csv", "ScriptID");
	level.var_6fa2f6ca.rewards = [];
	level.var_6fa2f6ca.rewards[1] = [];
	level.var_6fa2f6ca.rewards[2] = [];
	level.var_6fa2f6ca.rewards[3] = [];
	level.var_6fa2f6ca.var_568a16f7 = 100;
	level.bonus_points_powerup_override = &function_20affc0e;
	/#
		level.var_6fa2f6ca.var_8d5d5fa7 = [];
	#/
	var_d1a5ae2b = GetWeapon("none");
	a_keys = getArrayKeys(a_table);
	for(i = 0; i < a_keys.size; i++)
	{
		str_key = a_keys[i];
		var_4bcd3b3a = spawnstruct();
		var_4bcd3b3a.var_847eee17 = a_table[str_key]["Level"];
		var_4bcd3b3a.type = a_table[str_key]["Type"];
		if(var_4bcd3b3a.type == "weapon")
		{
			var_4bcd3b3a.item = GetWeapon(a_table[str_key]["Item"]);
			if(var_4bcd3b3a.item == var_d1a5ae2b)
			{
				/#
					/#
						ASSERTMSG("Dev Block strings are not supported" + a_table[str_key]["Dev Block strings are not supported"] + "Dev Block strings are not supported");
					#/
				#/
				continue;
			}
		}
		else
		{
			var_4bcd3b3a.item = a_table[str_key]["Item"];
		}
		var_4bcd3b3a.count = a_table[str_key]["Count"];
		var_4bcd3b3a.chance = a_table[str_key]["Weight"];
		if(!isdefined(level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17]))
		{
			level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17] = [];
		}
		else if(!IsArray(level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17]))
		{
			level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17] = Array(level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17]);
		}
		level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17][level.var_6fa2f6ca.rewards[var_4bcd3b3a.var_847eee17].size] = var_4bcd3b3a;
		/#
			level.var_6fa2f6ca.var_8d5d5fa7[str_key] = var_4bcd3b3a;
		#/
	}
	function_bcc1a076();
	thread function_77d7e068();
	function_956d3c82();
	level flag::init("any_player_has_pod_sprayer");
	level flag::init("hide_pods_for_trailer");
	/#
		level thread function_5c18476f();
	#/
}

/*
	Name: __main__
	Namespace: namespace_81256d2f
	Checksum: 0x5C3C873D
	Offset: 0xF90
	Size: 0x373
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level flag::wait_till("start_zombie_round_logic");
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		return;
	}
	level.var_6fa2f6ca.var_4042b27e = struct::get_array("fungus_pod", "targetname");
	level.var_6fa2f6ca.var_5d8c3695 = [];
	foreach(var_194575a7 in level.var_6fa2f6ca.var_4042b27e)
	{
		var_194575a7.model = util::spawn_model("tag_origin", var_194575a7.origin, var_194575a7.angles);
		if(isdefined(var_194575a7.script_noteworthy) && var_194575a7.script_noteworthy == "active")
		{
			var_194575a7.var_8486ae6a = 1;
		}
		else
		{
			var_194575a7.var_8486ae6a = 0;
		}
		var_194575a7.model clientfield::set("update_fungus_pod_level", 4);
	}
	level.var_6fa2f6ca.var_99e7e50c = [];
	var_9e82592c = struct::get_array("pod_sprayer_location", "targetname");
	var_9e82592c = Array::randomize(var_9e82592c);
	var_60b120ef = [];
	foreach(var_134d595b in var_9e82592c)
	{
		if(isdefined(var_60b120ef[var_134d595b.script_int]))
		{
			continue;
		}
		var_60b120ef[var_134d595b.script_int] = var_134d595b;
	}
	foreach(var_134d595b in var_60b120ef)
	{
		var_134d595b thread function_1ba9c604();
	}
	thread function_ab887f9d();
	level thread function_bf70a1ff();
}

/*
	Name: function_5c18476f
	Namespace: namespace_81256d2f
	Checksum: 0x70F9F283
	Offset: 0x1310
	Size: 0x23F
	Parameters: 0
	Flags: None
*/
function function_5c18476f()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		a_keys = getArrayKeys(level.var_6fa2f6ca.var_8d5d5fa7);
		for(i = 0; i < a_keys.size; i++)
		{
			str_id = a_keys[i];
			AddDebugCommand("Dev Block strings are not supported" + str_id + "Dev Block strings are not supported" + str_id + "Dev Block strings are not supported");
		}
		var_511a9112 = struct::get("Dev Block strings are not supported", "Dev Block strings are not supported");
		while(1)
		{
			cmd = GetDvarString("Dev Block strings are not supported");
			if(cmd != "Dev Block strings are not supported")
			{
				switch(cmd)
				{
					case "Dev Block strings are not supported":
					{
						level notify("hash_c0150ce6");
						break;
					}
					case "Dev Block strings are not supported":
					{
						level.var_7cf7b906 = 1;
						level notify("hash_c0150ce6");
						util::wait_network_frame();
						level.var_7cf7b906 = 0;
						break;
					}
					case default:
					{
						break;
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			util::wait_network_frame();
		}
	#/
}

/*
	Name: function_bcc1a076
	Namespace: namespace_81256d2f
	Checksum: 0x5CDCA32
	Offset: 0x1558
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function function_bcc1a076()
{
	foreach(var_3c1def9d in level.var_6fa2f6ca.rewards)
	{
		foreach(var_4bcd3b3a in var_3c1def9d)
		{
			if(var_4bcd3b3a.type == "shield_recharge")
			{
				var_4bcd3b3a.var_17fcbfca = 1;
			}
		}
	}
}

/*
	Name: function_77d7e068
	Namespace: namespace_81256d2f
	Checksum: 0xB9F25AFC
	Offset: 0x1678
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function function_77d7e068()
{
	level waittill("shield_built");
	foreach(var_3c1def9d in level.var_6fa2f6ca.rewards)
	{
		foreach(var_4bcd3b3a in var_3c1def9d)
		{
			if(var_4bcd3b3a.type == "shield_recharge")
			{
				var_4bcd3b3a.var_17fcbfca = 0;
			}
		}
	}
}

/*
	Name: function_4f94c8ae
	Namespace: namespace_81256d2f
	Checksum: 0x9D2F7099
	Offset: 0x17A0
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_4f94c8ae(e_player)
{
	if(e_player clientfield::get_to_player("pod_sprayer_held"))
	{
		return &"";
	}
	else
	{
		return &"ZM_ZOD_PICKUP_SPRAYER";
	}
}

/*
	Name: function_1ba9c604
	Namespace: namespace_81256d2f
	Checksum: 0x695E38B5
	Offset: 0x17F0
	Size: 0x21D
	Parameters: 0
	Flags: Private
*/
function private function_1ba9c604()
{
	while(1)
	{
		self.model = util::spawn_model("p7_zm_zod_bug_sprayer", self.origin, self.angles);
		self.model clientfield::set("pod_sprayer_glint", 1);
		self.trigger = namespace_8e578893::function_d095318(self.origin, 50, 1, &function_4f94c8ae);
		while(1)
		{
			self.trigger waittill("trigger", e_who);
			if(e_who clientfield::get_to_player("pod_sprayer_held"))
			{
				continue;
			}
			e_who thread zm_audio::create_and_play_dialog("sprayer", "pickup");
			e_who clientfield::set_to_player("pod_sprayer_held", 1);
			e_who thread namespace_8e578893::function_55f114f9("zmInventory.widget_sprayer", 3.5);
			e_who thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_POD_SPRAYER_PICKUP", 3.5);
			e_who.var_abe77dc0 = 1;
			self.model delete();
			playsoundatposition("zmb_zod_sprayer_pickup", self.origin);
			zm_unitrigger::unregister_unitrigger(self.trigger);
			self.trigger = undefined;
			level flag::set("any_player_has_pod_sprayer");
			break;
		}
		e_who waittill("disconnect");
	}
}

/*
	Name: function_5f89f77a
	Namespace: namespace_81256d2f
	Checksum: 0x641C8BFA
	Offset: 0x1A18
	Size: 0x139
	Parameters: 0
	Flags: Private
*/
function private function_5f89f77a()
{
	self waittill("hash_e446a51c");
	self thread function_a7a6257b();
	self thread function_42bd572d();
	while(1)
	{
		self.trigger waittill("trigger", e_who);
		/#
			Assert(self.var_8486ae6a > 0);
		#/
		if(isdefined(level.bzm_worldPaused) && level.bzm_worldPaused)
		{
			continue;
		}
		if(e_who clientfield::get_to_player("pod_sprayer_held") == 0)
		{
			e_who thread function_8d53a342(0);
			continue;
		}
		playsoundatposition("zmb_zod_sprayer_use", self.origin);
		e_who thread function_8d53a342(1);
		self function_7e428fa9(e_who);
		return;
	}
}

/*
	Name: function_8d53a342
	Namespace: namespace_81256d2f
	Checksum: 0x24C8822E
	Offset: 0x1B60
	Size: 0xAB
	Parameters: 1
	Flags: Private
*/
function private function_8d53a342(b_success)
{
	self notify("hash_8d53a342");
	self endon("hash_8d53a342");
	self thread clientfield::set_player_uimodel("zmInventory.player_using_sprayer", b_success);
	self thread clientfield::set_player_uimodel("zmInventory.widget_sprayer", 1);
	wait(2);
	self thread clientfield::set_player_uimodel("zmInventory.widget_sprayer", 0);
	self thread clientfield::set_player_uimodel("zmInventory.player_using_sprayer", 0);
}

/*
	Name: function_ab887f9d
	Namespace: namespace_81256d2f
	Checksum: 0x40180597
	Offset: 0x1C18
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function function_ab887f9d()
{
	var_15c80043 = GetEntArray("fungus_pod_clip", "targetname");
	level.var_6fa2f6ca.var_755232db = Array::sort_by_script_int(var_15c80043, 1);
	foreach(e_clip in level.var_6fa2f6ca.var_755232db)
	{
		e_clip thread function_254faf4d();
	}
}

/*
	Name: function_254faf4d
	Namespace: namespace_81256d2f
	Checksum: 0x3F503035
	Offset: 0x1D10
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_254faf4d()
{
	level endon("_zombie_game_over");
	while(1)
	{
		self.origin = self.origin - VectorScale((0, 0, 1), 5000);
		level waittill("pod_" + self.script_int + "_hatched");
		self.origin = self.origin + VectorScale((0, 0, 1), 5000);
		level waittill("pod_" + self.script_int + "_harvested");
	}
}

/*
	Name: function_cb4c560e
	Namespace: namespace_81256d2f
	Checksum: 0x7FBA9D4
	Offset: 0x1DB8
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private function_cb4c560e(var_8486ae6a)
{
	if(!isdefined(var_8486ae6a))
	{
		var_8486ae6a = undefined;
	}
	if(self.var_8486ae6a < 3)
	{
		if(isdefined(var_8486ae6a))
		{
			self.var_8486ae6a = var_8486ae6a;
		}
		else
		{
			self.var_8486ae6a++;
		}
		self.model clientfield::set("update_fungus_pod_level", self.var_8486ae6a);
	}
}

/*
	Name: function_be2abe
	Namespace: namespace_81256d2f
	Checksum: 0x1EFD0EFE
	Offset: 0x1E40
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_be2abe()
{
	foreach(var_15b740f0 in level.var_6fa2f6ca.var_5d8c3695)
	{
		var_15b740f0 function_cb4c560e(3);
	}
}

/*
	Name: function_a7a6257b
	Namespace: namespace_81256d2f
	Checksum: 0x9DDE99F0
	Offset: 0x1EE8
	Size: 0x181
	Parameters: 0
	Flags: Private
*/
function private function_a7a6257b()
{
	self endon("hash_ed807797");
	var_7df5847c = 0;
	if(isdefined(self.zone))
	{
		zm_zonemgr::zone_wait_till_enabled(self.zone);
	}
	if(level clientfield::get("bm_superbeast"))
	{
		self function_cb4c560e(3);
	}
	while(1)
	{
		level util::waittill_any("between_round_over", "debug_pod_spawn");
		var_7df5847c++;
		var_1e942f25 = level.var_6fa2f6ca.var_653c4928[var_7df5847c];
		if(!isdefined(var_1e942f25))
		{
			var_1e942f25 = 1;
		}
		else if(isdefined(level.var_7cf7b906) && level.var_7cf7b906)
		{
			var_1e942f25 = 1;
		}
		else if(var_1e942f25 == 0)
		{
			continue;
		}
		if(RandomFloat(1) <= var_1e942f25)
		{
			self function_cb4c560e();
			var_7df5847c = 0;
			if(self.var_8486ae6a >= 3)
			{
				return;
			}
		}
	}
}

/*
	Name: function_42bd572d
	Namespace: namespace_81256d2f
	Checksum: 0x38BA8A37
	Offset: 0x2078
	Size: 0x187
	Parameters: 0
	Flags: Private
*/
function private function_42bd572d()
{
	self endon("hash_ed807797");
	level flag::wait_till("all_players_spawned");
	while(1)
	{
		level waittill("kill_round");
		if(self.var_8486ae6a == 3)
		{
			self.model clientfield::increment("pod_harvest");
			wait(0.05);
			zm_unitrigger::unregister_unitrigger(self.trigger);
			ArrayRemoveValue(level.var_6fa2f6ca.var_5d8c3695, self);
			if(!isdefined(level.var_6fa2f6ca.var_4042b27e))
			{
				level.var_6fa2f6ca.var_4042b27e = [];
			}
			else if(!IsArray(level.var_6fa2f6ca.var_4042b27e))
			{
				level.var_6fa2f6ca.var_4042b27e = Array(level.var_6fa2f6ca.var_4042b27e);
			}
			level.var_6fa2f6ca.var_4042b27e[level.var_6fa2f6ca.var_4042b27e.size] = self;
			self notify("hash_ed807797");
			level notify("pod_" + self.script_int + "_harvested");
		}
	}
}

/*
	Name: function_bf70a1ff
	Namespace: namespace_81256d2f
	Checksum: 0x1FA4A4A5
	Offset: 0x2208
	Size: 0x25F
	Parameters: 0
	Flags: Private
*/
function private function_bf70a1ff()
{
	level flag::wait_till("start_zombie_round_logic");
	for(i = 0; i < level.var_6fa2f6ca.var_4042b27e.size; i++)
	{
		var_f64bb476 = level.var_6fa2f6ca.var_4042b27e[i];
		var_f64bb476.zone = zm_zonemgr::get_zone_from_position(var_f64bb476.origin + VectorScale((0, 0, 1), 20), 1);
		if(!isdefined(var_f64bb476.zone))
		{
			/#
				println("Dev Block strings are not supported" + namespace_8e578893::function_f7f2ffed(var_f64bb476.origin) + "Dev Block strings are not supported");
			#/
			ArrayRemoveValue(level.var_6fa2f6ca.var_4042b27e, var_f64bb476);
		}
	}
	var_d23318a4 = Int(0.4 * level.var_6fa2f6ca.var_4042b27e.size);
	function_d6abde0a(var_d23318a4);
	while(1)
	{
		level util::waittill_any("between_round_over", "debug_pod_spawn");
		if(level.round_number < 4 && !level flag::get("any_player_has_pod_sprayer") && (!isdefined(level.var_7cf7b906) && level.var_7cf7b906))
		{
			continue;
		}
		var_d23318a4 = randomIntRange(3, 6);
		if(isdefined(level.var_7cf7b906) && level.var_7cf7b906)
		{
			var_d23318a4 = 1000;
		}
		function_d6abde0a(var_d23318a4);
	}
}

/*
	Name: function_7e428fa9
	Namespace: namespace_81256d2f
	Checksum: 0x30955C65
	Offset: 0x2470
	Size: 0xAC1
	Parameters: 1
	Flags: None
*/
function function_7e428fa9(var_38618a65)
{
	self.model clientfield::increment("pod_harvest");
	var_38618a65 thread zm_audio::create_and_play_dialog("sprayer", "use");
	wait(0.1);
	self.var_6cfbf8d6 = level.round_number;
	zm_unitrigger::unregister_unitrigger(self.trigger);
	self.trigger = undefined;
	self notify("hash_ed807797", var_38618a65);
	var_785a5f87 = self.var_8486ae6a;
	self.var_8486ae6a = 0;
	self.model clientfield::set("update_fungus_pod_level", self.var_8486ae6a);
	wait(getanimlength("p7_fxanim_zm_zod_fungus_pod_stage" + var_785a5f87 + "_death_bundle") - 0.5);
	var_38618a65 RecordMapEvent(24, GetTime(), self.origin, level.round_number, var_785a5f87);
	level notify("pod_" + self.script_int + "_harvested");
	n_roll = RandomInt(100);
	var_cf622a2d = 0;
	var_68a89987 = 0;
	foreach(var_4bcd3b3a in level.var_6fa2f6ca.rewards[var_785a5f87])
	{
		/#
			var_c243efe2 = GetDvarString("Dev Block strings are not supported");
			if(isdefined(var_c243efe2) && var_c243efe2 != "Dev Block strings are not supported")
			{
				var_d82f154a = 1;
				var_4bcd3b3a = level.var_6fa2f6ca.var_8d5d5fa7[var_c243efe2];
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
		#/
		if(var_4bcd3b3a.type == "weapon")
		{
			var_4bcd3b3a.var_17fcbfca = function_b0138b1(var_4bcd3b3a.item);
		}
		if(isdefined(var_4bcd3b3a.var_17fcbfca) && var_4bcd3b3a.var_17fcbfca)
		{
			continue;
		}
		var_cf622a2d = var_cf622a2d + var_4bcd3b3a.chance;
		if(var_cf622a2d >= n_roll || (isdefined(var_d82f154a) && var_d82f154a))
		{
			var_68a89987 = 1;
			switch(var_4bcd3b3a.type)
			{
				case "craftable":
				{
					var_4bcd3b3a.var_17fcbfca = 1;
					function_956d3c82();
					playsoundatposition("evt_zod_pod_open_craftable", self.origin);
					drop_point = self.origin + VectorScale((0, 0, 1), 36);
					zm_zod_idgun_quest::function_f5469e1(drop_point, "part_skeleton");
					if(level flag::get("part_skeleton" + "_found"))
					{
						break;
					}
					else
					{
						var_71e3d70a = level zm_craftables::get_craftable_piece_model("idgun", "part_skeleton");
						var_55d0f940 = struct::get("safe_place_for_items", "targetname");
						var_71e3d70a.origin = var_55d0f940.origin;
						var_4bcd3b3a.var_17fcbfca = 0;
						function_956d3c82();
					}
					break;
				}
				case "grenade":
				{
					v_spawnpt = self.origin;
					grenade = GetWeapon("frag_grenade");
					n_rand = randomIntRange(0, 4);
					var_38618a65 MagicGrenadeType(grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
					playsoundatposition("evt_zod_pod_open_grenade", self.origin);
					if(n_rand)
					{
						wait(0.3);
						if(math::cointoss())
						{
							var_38618a65 MagicGrenadeType(grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
						}
					}
					break;
				}
				case "parasite":
				{
					if(isdefined(var_38618a65))
					{
						Array::add(level.a_wasp_priority_targets, var_38618a65);
					}
					s_temp = spawnstruct();
					s_temp.origin = self.origin + VectorScale((0, 0, 1), 30);
					var_b20468d0 = zm_ai_wasp::special_wasp_spawn(1, s_temp, 32, 32, 1, 1, 1);
					if(!IsPointInNavvolume(var_b20468d0.origin, "navvolume_small"))
					{
						v_nearest_navmesh_point = var_b20468d0 GetClosestPointOnNavVolume(s_temp.origin, 100);
						if(isdefined(v_nearest_navmesh_point))
						{
							var_b20468d0.origin = v_nearest_navmesh_point;
						}
					}
					break;
				}
				case "powerup":
				{
					for(var_e78e30c4 = var_4bcd3b3a.item; !isdefined(var_e78e30c4) || (var_e78e30c4 === "full_ammo" && var_785a5f87 != 3);  = var_4bcd3b3a.item)
					{
					}
					if(isdefined(var_4bcd3b3a.count) && var_e78e30c4 == "bonus_points_team")
					{
						level.var_6fa2f6ca.var_568a16f7 = var_4bcd3b3a.count;
					}
					zm_powerups::specific_powerup_drop(var_e78e30c4, self.origin, undefined, undefined, 1);
					break;
				}
				case "weapon":
				{
					playsoundatposition("evt_zod_pod_open_weapon", self.origin);
					self thread dig_up_weapon(var_38618a65, var_4bcd3b3a.item);
					break;
				}
				case "zombie":
				{
					s_temp = spawnstruct();
					s_temp.origin = function_c9466e61(self.origin, 20);
					if(!isdefined(s_temp.origin))
					{
						s_temp.origin = self.origin;
					}
					s_temp.script_noteworthy = "riser_location";
					s_temp.script_string = "find_flesh";
					zombie_utility::spawn_zombie(level.zombie_spawners[0], "aether_zombie", s_temp);
					break;
				}
				case "shield_recharge":
				{
					v_origin = function_c9466e61(self.origin, 20);
					var_7905adb2 = rocketshield::create_bottle_unitrigger(v_origin, (0, 0, 0));
					var_7905adb2 thread function_92f587b4();
					break;
				}
				case default:
				{
					break;
				}
			}
			break;
		}
	}
	if(!var_68a89987)
	{
		var_e78e30c4 = zm_powerups::get_valid_powerup();
		zm_powerups::specific_powerup_drop(var_e78e30c4, self.origin, undefined, undefined, 1);
	}
	ArrayRemoveValue(level.var_6fa2f6ca.var_5d8c3695, self);
	if(!isdefined(level.var_6fa2f6ca.var_4042b27e))
	{
		level.var_6fa2f6ca.var_4042b27e = [];
	}
	else if(!IsArray(level.var_6fa2f6ca.var_4042b27e))
	{
		level.var_6fa2f6ca.var_4042b27e = Array(level.var_6fa2f6ca.var_4042b27e);
	}
	level.var_6fa2f6ca.var_4042b27e[level.var_6fa2f6ca.var_4042b27e.size] = self;
}

/*
	Name: function_c9466e61
	Namespace: namespace_81256d2f
	Checksum: 0xD0F3167
	Offset: 0x2F40
	Size: 0xA7
	Parameters: 2
	Flags: None
*/
function function_c9466e61(v_pos, radius)
{
	v_origin = GetClosestPointOnNavMesh(v_pos, radius);
	if(!isdefined(v_origin))
	{
		e_player = zm_utility::get_closest_player(v_pos);
		v_origin = GetClosestPointOnNavMesh(e_player.origin, radius);
	}
	if(!isdefined(v_origin))
	{
		v_origin = v_pos;
	}
	return v_origin;
}

/*
	Name: function_92f587b4
	Namespace: namespace_81256d2f
	Checksum: 0x8B5E488D
	Offset: 0x2FF0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_92f587b4()
{
	self endon("bottle_collected");
	wait(15);
	for(i = 0; i < 40; i++)
	{
		if(i % 2)
		{
			self.mdl_shield_recharge ghost();
		}
		else
		{
			self.mdl_shield_recharge show();
		}
		if(i < 15)
		{
			wait(0.5);
			continue;
		}
		if(i < 25)
		{
			wait(0.25);
			continue;
		}
		wait(0.1);
	}
	self.mdl_shield_recharge delete();
	zm_unitrigger::unregister_unitrigger(self);
}

/*
	Name: function_bc9cb328
	Namespace: namespace_81256d2f
	Checksum: 0xD191EF97
	Offset: 0x30F0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_bc9cb328(e_player)
{
	if(e_player clientfield::get_to_player("pod_sprayer_held"))
	{
		return &"ZM_ZOD_POD_HARVEST";
	}
	else if(e_player clientfield::get_to_player("pod_sprayer_hint_range") == 0)
	{
		e_player thread function_3f5779c4();
	}
	return &"";
}

/*
	Name: function_3f5779c4
	Namespace: namespace_81256d2f
	Checksum: 0x6AFB123
	Offset: 0x3180
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_3f5779c4()
{
	self endon("disconnect");
	self clientfield::set_to_player("pod_sprayer_hint_range", 1);
	wait(1);
	self clientfield::set_to_player("pod_sprayer_hint_range", 0);
}

/*
	Name: function_d6abde0a
	Namespace: namespace_81256d2f
	Checksum: 0xEFBAE72F
	Offset: 0x31E0
	Size: 0x507
	Parameters: 1
	Flags: None
*/
function function_d6abde0a(var_d23318a4)
{
	if(level flag::get("hide_pods_for_trailer"))
	{
		return;
	}
	var_a908275a = [];
	foreach(var_f64bb476 in level.var_6fa2f6ca.var_4042b27e)
	{
		if(isdefined(var_f64bb476.var_6cfbf8d6))
		{
			var_3b9e1bb8 = level.round_number - var_f64bb476.var_6cfbf8d6;
			if(var_3b9e1bb8 < 2 && (!isdefined(level.var_7cf7b906) && level.var_7cf7b906))
			{
				continue;
			}
		}
		var_11fb7a41 = 0;
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			if(Distance(player.origin, var_f64bb476.origin) < 200)
			{
				var_11fb7a41 = 1;
				break;
			}
		}
		if(var_11fb7a41)
		{
			continue;
		}
		if(!isdefined(var_a908275a))
		{
			var_a908275a = [];
		}
		else if(!IsArray(var_a908275a))
		{
			var_a908275a = Array(var_a908275a);
		}
		var_a908275a[var_a908275a.size] = var_f64bb476;
	}
	var_a908275a = Array::randomize(var_a908275a);
	var_25d26371 = [];
	for(i = 0; i < var_d23318a4 && var_a908275a.size > 0; i++)
	{
		n_index = var_a908275a.size - 1;
		var_15b740f0 = var_a908275a[n_index];
		if(var_d23318a4 <= 5 && isdefined(var_15b740f0.zone) && isdefined(var_25d26371[var_15b740f0.zone]))
		{
			continue;
		}
		ArrayRemoveValue(level.var_6fa2f6ca.var_4042b27e, var_15b740f0);
		ArrayRemoveIndex(var_a908275a, n_index);
		if(!isdefined(level.var_6fa2f6ca.var_5d8c3695))
		{
			level.var_6fa2f6ca.var_5d8c3695 = [];
		}
		else if(!IsArray(level.var_6fa2f6ca.var_5d8c3695))
		{
			level.var_6fa2f6ca.var_5d8c3695 = Array(level.var_6fa2f6ca.var_5d8c3695);
		}
		level.var_6fa2f6ca.var_5d8c3695[level.var_6fa2f6ca.var_5d8c3695.size] = var_15b740f0;
		var_15b740f0.var_8486ae6a = 1;
		level notify("pod_" + var_15b740f0.script_int + "_hatched");
		var_15b740f0.model clientfield::set("update_fungus_pod_level", var_15b740f0.var_8486ae6a);
		var_15b740f0 thread function_e1065706();
		var_15b740f0 thread function_5f89f77a();
		if(isdefined(var_15b740f0.zone))
		{
			if(!isdefined(var_25d26371[var_15b740f0.zone]))
			{
				var_25d26371[var_15b740f0.zone] = 0;
			}
			var_25d26371[var_15b740f0.zone]++;
		}
	}
}

/*
	Name: function_e1065706
	Namespace: namespace_81256d2f
	Checksum: 0xCBE7DEEC
	Offset: 0x36F0
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function function_e1065706()
{
	wait(getanimlength("p7_fxanim_zm_zod_fungus_pod_base_birth_anim"));
	self.trigger = namespace_8e578893::function_d095318(self.origin + anglesToUp(self.angles) * 8, 50, 1, &function_bc9cb328);
	self notify("hash_e446a51c");
}

/*
	Name: function_3674f451
	Namespace: namespace_81256d2f
	Checksum: 0xB5D1FB0A
	Offset: 0x3780
	Size: 0xE7
	Parameters: 1
	Flags: None
*/
function function_3674f451(player)
{
	if(!zm_utility::is_player_valid(player) || player.IS_DRINKING > 0 || !player zm_magicbox::can_buy_weapon() || player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self setHintString(&"");
		return 0;
	}
	self setcursorhint("HINT_WEAPON", self.stub.var_d2af076);
	self setHintString(&"ZOMBIE_TRADE_WEAPON_FILL");
	return 1;
}

/*
	Name: function_b0138b1
	Namespace: namespace_81256d2f
	Checksum: 0x4AA6DBCC
	Offset: 0x3870
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function function_b0138b1(w_weapon)
{
	var_272e7943 = zm_weapons::get_base_weapon(w_weapon);
	players = GetPlayers();
	foreach(player in players)
	{
		if(!isdefined(player) || !isalive(player))
		{
			continue;
		}
		if(player zm_weapons::has_weapon_or_upgrade(var_272e7943))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: dig_up_weapon
	Namespace: namespace_81256d2f
	Checksum: 0x7E0E5B06
	Offset: 0x3988
	Size: 0x24F
	Parameters: 2
	Flags: None
*/
function dig_up_weapon(var_6413b107, var_c74eff46)
{
	v_spawnpt = self.origin + (0, 0, 40);
	v_spawnang = (0, 0, 0);
	v_angles = var_6413b107 getPlayerAngles();
	v_angles = (0, v_angles[1], 0) + VectorScale((0, 1, 0), 90) + v_spawnang;
	m_weapon = zm_utility::spawn_buildkit_weapon_model(var_6413b107, var_c74eff46, undefined, v_spawnpt, v_angles);
	m_weapon.angles = v_angles;
	m_weapon thread timer_til_despawn(v_spawnpt, 40 * -1);
	m_weapon endon("dig_up_weapon_timed_out");
	m_weapon.trigger = namespace_8e578893::function_d095318(v_spawnpt, 100, 1);
	m_weapon.trigger.var_d2af076 = var_c74eff46;
	m_weapon.trigger.prompt_and_visibility_func = &function_3674f451;
	m_weapon.trigger waittill("trigger", player);
	m_weapon.trigger notify("weapon_grabbed");
	m_weapon.trigger thread swap_weapon(var_c74eff46, player);
	if(isdefined(m_weapon.trigger))
	{
		zm_unitrigger::unregister_unitrigger(m_weapon.trigger);
		m_weapon.trigger = undefined;
	}
	if(isdefined(m_weapon))
	{
		m_weapon delete();
	}
	if(player != var_6413b107)
	{
		var_6413b107 notify("dig_up_weapon_shared");
	}
}

/*
	Name: swap_weapon
	Namespace: namespace_81256d2f
	Checksum: 0x6B29BDBA
	Offset: 0x3BE0
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function swap_weapon(var_9f85aad5, e_player)
{
	var_913ae498 = e_player GetCurrentWeapon();
	if(!zm_utility::is_player_valid(e_player))
	{
		return;
	}
	if(e_player.IS_DRINKING > 0)
	{
		return;
	}
	if(zm_utility::is_placeable_mine(var_913ae498) || zm_equipment::is_equipment(var_913ae498) || var_913ae498 == level.weaponNone)
	{
		return;
	}
	if(!e_player HasWeapon(var_9f85aad5.rootweapon, 1))
	{
		e_player take_old_weapon_and_give_new(var_913ae498, var_9f85aad5);
	}
	else
	{
		e_player giveMaxAmmo(var_9f85aad5);
	}
}

/*
	Name: take_old_weapon_and_give_new
	Namespace: namespace_81256d2f
	Checksum: 0x1F5A90C4
	Offset: 0x3D00
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function take_old_weapon_and_give_new(current_weapon, weapon)
{
	a_weapons = self GetWeaponsListPrimaries();
	if(isdefined(a_weapons) && a_weapons.size >= zm_utility::get_player_weapon_limit(self))
	{
		self TakeWeapon(current_weapon);
	}
	var_7b9ca68 = self zm_weapons::give_build_kit_weapon(weapon);
	self GiveWeapon(var_7b9ca68);
	self SwitchToWeapon(var_7b9ca68);
}

/*
	Name: timer_til_despawn
	Namespace: namespace_81256d2f
	Checksum: 0x42F99C7C
	Offset: 0x3DE0
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function timer_til_despawn(v_float, n_dist)
{
	self endon("weapon_grabbed");
	putBackTime = 12;
	self MoveZ(n_dist, putBackTime, putBackTime * 0.5);
	self waittill("movedone");
	self notify("dig_up_weapon_timed_out");
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
	Name: function_20affc0e
	Namespace: namespace_81256d2f
	Checksum: 0x7821053A
	Offset: 0x3EB0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function function_20affc0e()
{
	return level.var_6fa2f6ca.var_568a16f7;
}

/*
	Name: function_956d3c82
	Namespace: namespace_81256d2f
	Checksum: 0xED998E9F
	Offset: 0x3ED0
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_956d3c82()
{
	for(i = 1; i <= 3; i++)
	{
		n_total = 0;
		foreach(reward in level.var_6fa2f6ca.rewards[i])
		{
			if(!(isdefined(reward.var_17fcbfca) && reward.var_17fcbfca))
			{
				n_total = n_total + float(reward.chance);
			}
		}
		/#
			Assert(reward.chance > 0);
		#/
		foreach(reward in level.var_6fa2f6ca.rewards[i])
		{
			if(!(isdefined(reward.var_17fcbfca) && reward.var_17fcbfca))
			{
				reward.chance = reward.chance / n_total * 100;
			}
		}
	}
}

/*
	Name: function_2947f395
	Namespace: namespace_81256d2f
	Checksum: 0x4C5A526D
	Offset: 0x40D0
	Size: 0x121
	Parameters: 0
	Flags: None
*/
function function_2947f395()
{
	level flag::set("hide_pods_for_trailer");
	foreach(POD in level.var_6fa2f6ca.spawned)
	{
		POD.buff = 0;
		POD.var_70ac16f8 = 0;
		zm_unitrigger::unregister_unitrigger(POD.trigger);
		if(isdefined(self.var_7a88c258))
		{
			POD.var_7a88c258 delete();
		}
		ArrayRemoveValue(level.var_6fa2f6ca.spawned, self);
	}
}

/*
	Name: function_3f95af32
	Namespace: namespace_81256d2f
	Checksum: 0x993E3BFB
	Offset: 0x4200
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function function_3f95af32()
{
	foreach(player in level.activePlayers)
	{
		player clientfield::set_to_player("pod_sprayer_held", 1);
		player thread namespace_8e578893::function_55f114f9("zmInventory.widget_sprayer", 3.5);
		player.var_abe77dc0 = 1;
		level flag::set("any_player_has_pod_sprayer");
	}
}

