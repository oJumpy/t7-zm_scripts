#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\archetype_genesis_keeper_companion;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;

#namespace zm_genesis_keeper_companion;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xC0E7C7F4
	Offset: 0xA08
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_companion", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xF27793B5
	Offset: 0xA48
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		execdevgui("Dev Block strings are not supported");
		thread function_c90770b6();
	#/
	RegisterClientField("world", "keeper_callbox_head", 15000, 1, "int");
	RegisterClientField("world", "keeper_callbox_totem", 15000, 1, "int");
	RegisterClientField("world", "keeper_callbox_gem", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_keeper_protector_parts", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_keeper_protector", 15000, 1, "int");
}

/*
	Name: function_51dd865c
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x6C4E2307
	Offset: 0xB78
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_51dd865c()
{
	level thread AAT::register_immunity("zm_aat_blast_furnace", "keeper_companion", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "keeper_companion", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "keeper_companion", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "keeper_companion", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "keeper_companion", 1, 1, 1);
}

/*
	Name: main
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x4BA5A1E7
	Offset: 0xC78
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::init("companion_box_in_use");
	level flag::init("companion_box_built");
	level flag::init("companion_box_parts_collected");
	level flag::init("companion_box_building");
	level.ai_companion_remaining_cost = 5000;
	level flag::wait_till("initial_blackscreen_passed");
	level.var_214b85da = GetEnt("keeper_companion_spawner", "script_noteworthy");
	level thread function_2dc24f4b();
	if(!isdefined(level.powerup_grab_get_players_override))
	{
		level.powerup_grab_get_players_override = &powerup_grab_get_players_override;
	}
}

/*
	Name: powerup_grab_get_players_override
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x4D5D8BCA
	Offset: 0xD90
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function powerup_grab_get_players_override()
{
	players = GetPlayers();
	if(isdefined(level.ai_companion))
	{
		players[players.size] = level.ai_companion;
	}
	return players;
}

/*
	Name: function_2dc24f4b
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x30E9813C
	Offset: 0xDE0
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_2dc24f4b()
{
	level.var_d1d9fa3c = 0;
	level thread function_dbc32a6d();
	level.a_companion_areanames = Array("temple", "theater", "origins", "castle");
	foreach(str_areaname in level.a_companion_areanames)
	{
		create_callbox_unitrigger(str_areaname, &function_adb2c149, &function_d6422d13);
	}
	var_991fff06 = struct::get_array("companion_activate_trig", "targetname");
	Array::thread_all(var_991fff06, &function_4347fd68);
	level thread function_63fe1ddd();
}

/*
	Name: function_4347fd68
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x269C03BB
	Offset: 0xF50
	Size: 0x149
	Parameters: 0
	Flags: None
*/
function function_4347fd68()
{
	a_e_parts = GetEntArray(self.target, "targetname");
	foreach(e_part in a_e_parts)
	{
		e_part Hide();
	}
	level flag::wait_till("companion_box_built");
	foreach(e_part in a_e_parts)
	{
		e_part show();
	}
}

/*
	Name: function_dbc32a6d
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x302AE5D0
	Offset: 0x10A8
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function function_dbc32a6d()
{
	var_7db6b6e1 = struct::get_array("companion_totem_part", "targetname");
	var_e5e70941 = Array::random(var_7db6b6e1);
	var_e5e70941.n_scale = 0.75;
	var_e5e70941.str_client = "keeper_callbox_totem";
	var_e5e70941.v_offset = VectorScale((0, 0, 1), 20);
	var_e5e70941 thread function_85555c9();
	var_133619e4 = struct::get_array("companion_head_part", "targetname");
	var_6a2693c4 = Array::random(var_133619e4);
	var_6a2693c4.n_scale = 1.5;
	var_6a2693c4.str_client = "keeper_callbox_head";
	var_6a2693c4 thread function_85555c9();
	var_79d5129b = struct::get_array("companion_gem_part", "targetname");
	var_fb9b76fb = Array::random(var_79d5129b);
	var_fb9b76fb.n_scale = 2;
	var_fb9b76fb.str_client = "keeper_callbox_gem";
	var_fb9b76fb thread function_85555c9();
}

/*
	Name: function_85555c9
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x4D590740
	Offset: 0x1270
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function function_85555c9()
{
	level flag::init(self.str_client + "_found");
	mdl_part = util::spawn_model(self.model, self.origin, self.angles);
	mdl_part SetScale(self.n_scale);
	s_unitrigger = self zm_unitrigger::create_unitrigger(&"ZM_GENESIS_CALLBOX_PICKUP_PART", 64, &function_fe778474);
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger, 1);
	if(isdefined(self.v_offset))
	{
		s_unitrigger.origin = s_unitrigger.origin + self.v_offset;
	}
	s_unitrigger flag::init("part_picked_up");
	self waittill("trigger_activated", e_player);
	self thread function_49da2964(e_player);
	level.var_d1d9fa3c++;
	s_unitrigger flag::set("part_picked_up");
	if(level.var_d1d9fa3c >= 3)
	{
		level flag::set("companion_box_parts_collected");
	}
	zm_unitrigger::unregister_unitrigger(s_unitrigger);
	mdl_part delete();
	self struct::delete();
}

/*
	Name: function_fe778474
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xF2AF5861
	Offset: 0x1470
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function function_fe778474(e_player)
{
	if(self.stub flag::get("part_picked_up"))
	{
		self setHintString(&"");
		return 0;
	}
	if(level flag::get("companion_box_parts_collected"))
	{
		self setHintString(&"");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_GENESIS_CALLBOX_PICKUP_PART");
		return 1;
	}
}

/*
	Name: function_384f884a
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x18FCD0BA
	Offset: 0x1538
	Size: 0xF3
	Parameters: 1
	Flags: Private
*/
function private function_384f884a(e_player)
{
	self thread zm_craftables::craftable_play_craft_fx(e_player);
	self thread function_6ba7e9d6(e_player);
	level flag::set("companion_box_building");
	self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
	str_return = self util::waittill_any_return("craft_succeed", "craft_failed");
	level flag::clear("companion_box_building");
	self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
	if(str_return == "craft_succeed")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_6ba7e9d6
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xE9679CEF
	Offset: 0x1638
	Size: 0x3E9
	Parameters: 1
	Flags: Private
*/
function private function_6ba7e9d6(e_player)
{
	wait(0.01);
	if(!isdefined(self))
	{
		if(isdefined(e_player.craftableAudio))
		{
			e_player.craftableAudio delete();
			e_player.craftableAudio = undefined;
		}
		return;
	}
	n_start_time = GetTime();
	n_total_time = 0;
	var_20c067ae = Int(3 * 1000);
	e_player zm_utility::increment_is_drinking();
	w_current = e_player GetCurrentWeapon();
	w_build = GetWeapon("zombie_builder");
	e_player GiveWeapon(w_build);
	e_player SwitchToWeapon(w_build);
	mdl_anchor = util::spawn_model("tag_origin", e_player.origin, e_player.angles);
	e_player thread anchor_delete_watcher(mdl_anchor);
	e_player zm_utility::disable_player_move_states(1);
	e_player LinkTo(mdl_anchor);
	e_player playsound("zmb_keeper_callbox_build_start");
	e_player PlayLoopSound("zmb_keeper_callbox_build_lp");
	while(isdefined(e_player.useBar))
	{
		util::wait_network_frame();
	}
	e_player thread zm_craftables::player_progress_bar(n_start_time, var_20c067ae);
	while(e_player useButtonPressed() && n_total_time < 3)
	{
		n_current_time = GetTime();
		n_total_time = n_current_time - n_start_time / 1000;
		util::wait_network_frame();
	}
	e_player StopLoopSound(0.5);
	e_player notify("craftable_progress_end");
	e_player zm_weapons::switch_back_primary_weapon(w_current);
	e_player TakeWeapon(w_build);
	if(isdefined(e_player.IS_DRINKING) && e_player.IS_DRINKING)
	{
		e_player zm_utility::decrement_is_drinking();
	}
	e_player zm_utility::enable_player_move_states();
	e_player Unlink();
	if(n_total_time >= 3)
	{
		e_player playsound("zmb_keeper_callbox_build_finish");
		self notify("craft_succeed");
	}
	else
	{
		e_player playsound("zmb_keeper_callbox_build_fail");
		self notify("craft_failed");
	}
}

/*
	Name: anchor_delete_watcher
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x88972507
	Offset: 0x1A30
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function anchor_delete_watcher(mdl_anchor)
{
	self util::waittill_any("death", "craftable_progress_end");
	util::wait_network_frame();
	if(isdefined(mdl_anchor))
	{
		mdl_anchor delete();
	}
}

/*
	Name: function_49da2964
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x668BE6C2
	Offset: 0x1AA0
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function function_49da2964(e_player)
{
	level flag::set(self.str_client + "_found");
	level clientfield::set(self.str_client, 1);
	e_player playsound("zmb_keeper_callbox_pickup");
	level notify("widget_ui_override");
	foreach(e_player in level.players)
	{
		e_player thread function_3ab53b5c("zmInventory.player_keeper_protector", "zmInventory.widget_keeper_protector_parts", 0);
	}
	e_player notify("player_got_keeper_companion_piece");
}

/*
	Name: function_b2ef0035
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x711FE606
	Offset: 0x1BC8
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function function_b2ef0035(e_player)
{
	level notify("widget_ui_override");
	foreach(e_player in level.players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread function_3ab53b5c("zmInventory.player_keeper_protector", "zmInventory.widget_keeper_protector_parts", 1);
		}
	}
}

/*
	Name: function_3ab53b5c
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x593A727C
	Offset: 0x1C98
	Size: 0xD3
	Parameters: 3
	Flags: Private
*/
function private function_3ab53b5c(str_crafted_clientuimodel, str_widget_clientuimodel, b_is_crafted)
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
	Name: create_callbox_unitrigger
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x39F69688
	Offset: 0x1D78
	Size: 0x243
	Parameters: 3
	Flags: None
*/
function create_callbox_unitrigger(str_areaname, func_trigger_visibility, func_trigger_thread)
{
	width = 64;
	height = 90;
	length = 64;
	s_callbox = struct::get("companion_callbox_" + str_areaname, "script_noteworthy");
	/#
		Assert(isdefined(s_callbox), "Dev Block strings are not supported" + str_areaname + "Dev Block strings are not supported");
	#/
	s_callbox.unitrigger_stub = spawnstruct();
	s_callbox.unitrigger_stub.origin = s_callbox.origin;
	s_callbox.unitrigger_stub.angles = s_callbox.angles;
	s_callbox.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_callbox.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_callbox.unitrigger_stub.script_width = width;
	s_callbox.unitrigger_stub.script_height = height;
	s_callbox.unitrigger_stub.script_length = length;
	s_callbox.unitrigger_stub.require_look_at = 0;
	s_callbox.unitrigger_stub.str_areaname = str_areaname;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_callbox.unitrigger_stub, 1);
	s_callbox.unitrigger_stub.prompt_and_visibility_func = func_trigger_visibility;
	zm_unitrigger::register_static_unitrigger(s_callbox.unitrigger_stub, func_trigger_thread);
}

/*
	Name: function_adb2c149
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x98AB0683
	Offset: 0x1FC8
	Size: 0x319
	Parameters: 1
	Flags: None
*/
function function_adb2c149(e_player)
{
	if(!self zm_craftables::anystub_update_prompt(e_player))
	{
		self setHintString(&"");
		return 0;
	}
	if(e_player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self setHintString(&"");
		return 0;
	}
	initial_current_weapon = e_player GetCurrentWeapon();
	current_weapon = zm_weapons::get_nonalternate_weapon(initial_current_weapon);
	if(current_weapon.isHeroWeapon || current_weapon.isgadget)
	{
		self setHintString(&"");
		return 0;
	}
	if(!level flag::get("companion_box_built"))
	{
		if(level flag::get("companion_box_building"))
		{
			self setHintString(&"");
			return 0;
		}
		else if(!level flag::get("companion_box_parts_collected"))
		{
			self setHintString(&"ZM_GENESIS_CALLBOX_MISSING_PARTS");
			return 0;
		}
		else
		{
			self setHintString(&"ZM_GENESIS_CALLBOX_BUILD");
			return 1;
		}
	}
	else if(isdefined(level.ai_companion))
	{
		switch(level.var_eb326880)
		{
			case "castle":
			{
				hintstring_areaname = &"ZM_GENESIS_AREA_NAME_CASTLE";
				break;
			}
			case "origins":
			{
				hintstring_areaname = &"ZM_GENESIS_AREA_NAME_ORIGINS";
				break;
			}
			case "theater":
			{
				hintstring_areaname = &"ZM_GENESIS_AREA_NAME_THEATER";
				break;
			}
			case "temple":
			{
				hintstring_areaname = &"ZM_GENESIS_AREA_NAME_TEMPLE";
				break;
			}
			case default:
			{
				hintstring_areaname = &"";
				break;
			}
		}
		self setHintString(&"ZM_GENESIS_ROBOT_ONCALL_IN", hintstring_areaname);
		return 0;
	}
	else if(e_player.score < level.ai_companion_remaining_cost)
	{
		self setHintString(&"ZM_GENESIS_ROBOT_PAY_TOWARDS", level.ai_companion_remaining_cost);
	}
	else
	{
		self setHintString(&"ZM_GENESIS_ROBOT_SUMMON", level.ai_companion_remaining_cost);
	}
	return 1;
}

/*
	Name: function_d6422d13
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x788437B
	Offset: 0x22F0
	Size: 0x3FF
	Parameters: 0
	Flags: None
*/
function function_d6422d13()
{
	while(!level flag::get("companion_box_built"))
	{
		self waittill("trigger", e_player);
		b_result = self function_384f884a(e_player);
		if(b_result)
		{
			while(e_player useButtonPressed())
			{
				util::wait_network_frame();
			}
			if(isdefined(e_player))
			{
				e_player notify("hash_7e8efe7c");
				e_player thread zm_genesis_vo::function_a5e16a1e();
			}
			level notify("hash_7e8efe7c");
			level flag::set("companion_box_built");
			exploder::exploder("lgtexp_keeper_protector_on");
		}
	}
	while(1)
	{
		self waittill("trigger", e_player);
		if(e_player zm_utility::in_revive_trigger())
		{
			break;
		}
		if(e_player.IS_DRINKING > 0)
		{
			break;
		}
		if(!zm_utility::is_player_valid(e_player))
		{
			break;
		}
		if(isdefined(level.ai_companion))
		{
			break;
		}
		if(level flag::get("companion_box_in_use"))
		{
			break;
		}
		if(!e_player zm_score::can_player_purchase(level.ai_companion_remaining_cost))
		{
			level.ai_companion_remaining_cost = level.ai_companion_remaining_cost - e_player.score;
			e_player zm_score::minus_to_player_score(e_player.score);
			self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
		}
		else
		{
			level flag::set("companion_box_in_use");
			self setHintString("");
			e_player zm_score::minus_to_player_score(level.ai_companion_remaining_cost);
			if(!e_player bgb::is_enabled("zm_bgb_shopping_free"))
			{
				level.ai_companion_remaining_cost = 0;
			}
			a_s_start_pos = struct::get_array("companion_start_pos", "targetname");
			a_s_start_pos = Array::filter(a_s_start_pos, 0, &filter_callbox_name, self.stub.str_areaname);
			s_start_pos = a_s_start_pos[0];
			level thread function_ff7f239d(e_player, self.stub, s_start_pos);
			e_player notify("hash_2098781a");
			e_player thread zm_genesis_vo::function_89b21fad();
			level notify("hash_31220443");
			level thread function_83f1533a(self, "activated");
			self playsound("zmb_keeper_callbox_activate");
			wait(1.5);
			e_player zm_audio::create_and_play_dialog("robot", "activate");
		}
	}
}

/*
	Name: function_63fe1ddd
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x609C0315
	Offset: 0x26F8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_63fe1ddd()
{
	level endon("_zombie_game_over");
	level flag::wait_till("companion_box_built");
	while(1)
	{
		level clientfield::set("kc_callbox_lights", 1);
		level waittill("hash_31220443");
		level clientfield::set("kc_callbox_lights", 2);
		level waittill("hash_5cbd6434");
		while(isdefined(level.ai_companion))
		{
			wait(0.05);
		}
	}
}

/*
	Name: filter_callbox_name
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xE1537923
	Offset: 0x27B0
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function filter_callbox_name(e_entity, str_areaname)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != str_areaname)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_ff7f239d
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x7FEE8E5A
	Offset: 0x2800
	Size: 0x61B
	Parameters: 3
	Flags: None
*/
function function_ff7f239d(e_player, s_stub, s_start_pos)
{
	a_trace = bullettrace(s_start_pos.origin + VectorScale((0, 0, 1), 100), s_start_pos.origin + VectorScale((0, 0, -1), 256), 0, s_start_pos);
	v_ground_position = a_trace["position"];
	s_stub zm_unitrigger::run_visibility_function_for_all_triggers();
	var_7b3e5077 = spawn("script_model", v_ground_position);
	util::wait_network_frame();
	var_7b3e5077 clientfield::set("keeper_ai_spawn_tell", 1);
	wait(1);
	level.ai_companion = level.var_214b85da SpawnFromSpawner("companion_spawner", 1);
	level.ai_companion.maxhealth = level.ai_companion.health;
	level.ai_companion.allow_zombie_to_target_ai = 0;
	level.ai_companion.can_gib_zombies = 1;
	level.ai_companion SetCanDamage(0);
	level.ai_companion.time_expired = 0;
	level.companion_leader = e_player;
	level.var_eb326880 = s_stub.str_areaname;
	level.ai_companion.var_5a513941 = 1;
	level.ai_companion.is_zombie = 1;
	foreach(e_player in level.players)
	{
		e_player setPerk("specialty_pistoldeath");
	}
	level.ai_companion ForceTeleport(v_ground_position);
	level.ai_companion ghost();
	level.ai_companion scene::Play("cin_zm_dlc4_keeper_prtctr_intro", level.ai_companion);
	var_7b3e5077 clientfield::set("keeper_ai_spawn_tell", 0);
	wait(1);
	var_7b3e5077 delete();
	level notify("hash_5cbd6434");
	level.ai_companion.companion_anchor_point = v_ground_position;
	level thread function_83f1533a(level.ai_companion, "active", 2);
	level.ai_companion thread function_91a820f6();
	level.ai_companion thread function_a36616b8();
	level flag::clear("companion_box_in_use");
	level.ai_companion function_f95a072f(e_player);
	if(function_bb9e914f(s_stub))
	{
		return;
	}
	level.ai_companion.time_expired = 1;
	while(isdefined(level.ai_companion) && (isdefined(level.ai_companion.var_57376ff1) && level.ai_companion.var_57376ff1))
	{
		util::wait_network_frame();
	}
	if(function_bb9e914f(s_stub))
	{
		return;
	}
	n_timeout = 0;
	while(level.ai_companion.reviving_a_player)
	{
		if(n_timeout >= 10)
		{
			continue;
		}
		n_timeout = n_timeout + 0.1;
		wait(0.1);
	}
	level.ai_companion keepercompanionbehavior::function_703fda6d();
	foreach(e_player in level.players)
	{
		e_player unsetPerk("specialty_pistoldeath");
	}
	level thread function_1ee7eabb(level.ai_companion);
	if(level.players.size != 1 || !level flag::get("solo_game") || (!isdefined(level.players[0].waiting_to_revive) && level.players[0].waiting_to_revive))
	{
		level zm::checkForAllDead();
	}
	level.ai_companion_remaining_cost = 5000;
	s_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_bb9e914f
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x18F33502
	Offset: 0x2E28
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_bb9e914f(s_stub)
{
	if(!isdefined(level.ai_companion) || !isalive(level.ai_companion))
	{
		level.ai_companion_remaining_cost = 5000;
		s_stub zm_unitrigger::run_visibility_function_for_all_triggers();
		return 1;
	}
	return 0;
}

/*
	Name: function_f95a072f
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xE984FE4D
	Offset: 0x2E98
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function function_f95a072f(e_player)
{
	level endon("hash_2d402338");
	self endon("death");
	if(isdefined(e_player.var_e7f63e2e))
	{
		wait(e_player.var_e7f63e2e);
	}
	wait(120);
	/#
		while(isdefined(level.var_8700c9b1) && level.var_8700c9b1)
		{
			wait(1);
		}
	#/
}

/*
	Name: function_1ee7eabb
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x9E2AEFFB
	Offset: 0x2F10
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function function_1ee7eabb(ai_keeper)
{
	ai_keeper.outro = 1;
	ai_keeper notify("outro");
	ai_keeper scene::Play("cin_zm_dlc4_keeper_prtctr_outtro", ai_keeper);
	if(level flag::get("solo_game"))
	{
		if(!isalive(level.players[0]) || (level.players[0] laststand::player_is_in_laststand() && !level.players[0].lives))
		{
			level notify("end_game");
		}
	}
}

/*
	Name: function_83f1533a
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x9B752A34
	Offset: 0x2FF8
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function function_83f1533a(entity, suffix, delay)
{
	entity endon("death");
	entity endon("disconnect");
	alias = "vox_crbt_robot_" + suffix;
	num_variants = zm_spawner::get_number_variants(alias);
	if(num_variants <= 0)
	{
		return;
	}
	var_4dc11cc = randomIntRange(0, num_variants + 1);
	if(isdefined(delay))
	{
		wait(delay);
	}
	if(isdefined(entity) && (!isdefined(entity.is_speaking) && entity.is_speaking))
	{
		entity.is_speaking = 1;
		entity PlaySoundWithNotify(alias + "_" + var_4dc11cc, "sndDone");
		entity waittill("snddone");
		entity.is_speaking = 0;
	}
}

/*
	Name: function_91a820f6
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x8998AF8
	Offset: 0x3150
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function function_91a820f6()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		level waittill("hash_1fe79fb5", who);
		if(RandomInt(100) <= 30)
		{
			level thread function_83f1533a(level.ai_companion, "kills");
		}
		if(RandomInt(100) <= 30)
		{
			a_e_players = ArrayCopy(level.activePlayers);
			a_e_players = Array::randomize(a_e_players);
			foreach(e_player in a_e_players)
			{
				if(Distance(self.origin, e_player.origin) < 1000 && e_player zm_utility::is_facing(self, 0.5))
				{
					e_player thread zm_genesis_vo::function_92425254();
					break;
				}
			}
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_a36616b8
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x4D561260
	Offset: 0x3330
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function function_a36616b8()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		wait(randomIntRange(15, 25));
		level thread function_83f1533a(level.ai_companion, "active");
	}
}

/*
	Name: function_c90770b6
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x79A4B07A
	Offset: 0x33A0
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function function_c90770b6()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::add_custom_devgui_callback(&function_f2a74fd1);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_2fb1022e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 2, &function_2fb1022e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 3, &function_2fb1022e);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_a4b1c609);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 2, &function_a4b1c609);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 3, &function_a4b1c609);
	#/
}

/*
	Name: function_a4b1c609
	Namespace: zm_genesis_keeper_companion
	Checksum: 0xBDADDED3
	Offset: 0x3540
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function function_a4b1c609(n_val)
{
	/#
		switch(n_val)
		{
			case 1:
			{
				level.activePlayers[0] thread zm_genesis_vo::function_a5e16a1e();
				break;
			}
			case 2:
			{
				level.activePlayers[0] thread zm_genesis_vo::function_89b21fad();
				break;
			}
			case 3:
			{
				level.activePlayers[0] thread zm_genesis_vo::function_92425254();
				break;
			}
		}
	#/
}

/*
	Name: function_f2a74fd1
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x1BBD52A1
	Offset: 0x35E8
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function function_f2a74fd1(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level thread function_4ac4bae7();
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(!isdefined(level.var_8700c9b1))
				{
					level.var_8700c9b1 = 1;
				}
				else if(level.var_8700c9b1)
				{
					level.var_8700c9b1 = 0;
				}
				else
				{
					level.var_8700c9b1 = 1;
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(!isdefined(level.var_c3eaadba))
				{
					level.var_c3eaadba = 1;
				}
				else if(level.var_c3eaadba)
				{
					level.var_c3eaadba = 0;
				}
				else
				{
					level.var_c3eaadba = 1;
				}
				break;
			}
		}
	#/
}

/*
	Name: function_2fb1022e
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x9E1E0952
	Offset: 0x36C8
	Size: 0x251
	Parameters: 1
	Flags: None
*/
function function_2fb1022e(n_val)
{
	/#
		switch(n_val)
		{
			case 1:
			{
				var_133619e4 = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(s_piece in var_133619e4)
				{
					s_piece notify("trigger_activated", level.players[0]);
				}
				break;
			}
			case 2:
			{
				var_7db6b6e1 = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(s_piece in var_7db6b6e1)
				{
					s_piece notify("trigger_activated", level.players[0]);
				}
				break;
			}
			case 3:
			{
				var_79d5129b = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(s_piece in var_79d5129b)
				{
					s_piece notify("trigger_activated", level.players[0]);
				}
				break;
			}
		}
	#/
}

/*
	Name: function_4ac4bae7
	Namespace: zm_genesis_keeper_companion
	Checksum: 0x5AF24940
	Offset: 0x3928
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_4ac4bae7()
{
	/#
		a_s_stubs = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
		s_stub = ArrayGetClosest(level.players[0].origin, a_s_stubs);
		queryResult = PositionQuery_Source_Navigation(level.players[0].origin, 128, 256, 128, 20);
		s_spot = spawnstruct();
		s_spot.origin = level.players[0].origin;
		if(isdefined(queryResult) && queryResult.data.size > 0)
		{
			s_spot.origin = queryResult.data[0].origin;
		}
		level thread function_ff7f239d(level.players[0], s_stub, s_spot);
	#/
}

