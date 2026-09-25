#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_craftables;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#namespace namespace_f7d4f63b;

/*
	Name: main
	Namespace: namespace_f7d4f63b
	Checksum: 0x1D8A6296
	Offset: 0x9E0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function main()
{
	function_16f0344e();
	function_d0901c34();
	function_f4a071bb();
	function_4fdc8e70();
}

/*
	Name: init
	Namespace: namespace_f7d4f63b
	Checksum: 0xCE15CEEC
	Offset: 0xA30
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("scriptmover", "show_part", 9000, 1, "int");
	clientfield::register("actor", "zombie_splash", 9000, 1, "int");
	clientfield::register("world", "lower_pap_water", 9000, 2, "int");
	/#
		function_7cd896fc();
	#/
}

/*
	Name: function_16f0344e
	Namespace: namespace_f7d4f63b
	Checksum: 0x8D3E8B21
	Offset: 0xAE8
	Size: 0x2F3
	Parameters: 0
	Flags: None
*/
function function_16f0344e()
{
	level flag::init("valve1_found");
	level flag::init("valve2_found");
	level flag::init("valve3_found");
	level flag::init("defend_success");
	level flag::init("pap_water_is_draining");
	level flag::init("pap_water_drained");
	level flag::init("pap_gauge");
	level flag::init("pap_whistle");
	level flag::init("pap_wheel");
	level.var_12542033 = 0;
	foreach(var_3ea1611f in struct::get_array("pap_water_control"))
	{
		var_3ea1611f thread function_dd9ccb8(var_3ea1611f.script_int);
	}
	level thread function_aa37ce2d();
	level scene::add_scene_func("p7_fxanim_zm_island_pap_elements_gauge_bundle", &function_b6d4787d, "init");
	level scene::add_scene_func("p7_fxanim_zm_island_pap_elements_whistle_bundle", &function_e0bc0bdc, "init");
	level scene::add_scene_func("p7_fxanim_zm_island_pap_elements_wheel_bundle", &function_f7c8e279, "init");
	level scene::init("p7_fxanim_zm_island_pap_elements_gauge_bundle");
	level scene::init("p7_fxanim_zm_island_pap_elements_whistle_bundle");
	level scene::init("p7_fxanim_zm_island_pap_elements_wheel_bundle");
	level thread function_851f0b97();
}

/*
	Name: on_player_spawned
	Namespace: namespace_f7d4f63b
	Checksum: 0x88DDB86C
	Offset: 0xDE8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread function_145f4b1a();
}

/*
	Name: function_b6d4787d
	Namespace: namespace_f7d4f63b
	Checksum: 0xEEB98FA5
	Offset: 0xE10
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_b6d4787d(a_ents)
{
	var_71e3d70a = a_ents["fxanim_pap_elements"];
	var_71e3d70a HidePart("p7_zm_isl_pap_elements_gauge_jnt");
	level flag::wait_till("pap_gauge");
	var_71e3d70a ShowPart("p7_zm_isl_pap_elements_gauge_jnt");
	wait(1);
	level scene::Play("p7_fxanim_zm_island_pap_elements_gauge_bundle");
}

/*
	Name: function_e0bc0bdc
	Namespace: namespace_f7d4f63b
	Checksum: 0xB7502AB1
	Offset: 0xEC0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_e0bc0bdc(a_ents)
{
	var_71e3d70a = a_ents["fxanim_pap_elements"];
	var_71e3d70a HidePart("p7_zm_isl_pap_elements_whistle_jnt");
	level flag::wait_till("pap_whistle");
	var_71e3d70a ShowPart("p7_zm_isl_pap_elements_whistle_jnt");
	wait(1);
	level scene::Play("p7_fxanim_zm_island_pap_elements_whistle_bundle");
}

/*
	Name: function_f7c8e279
	Namespace: namespace_f7d4f63b
	Checksum: 0x89649A30
	Offset: 0xF70
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_f7c8e279(a_ents)
{
	var_71e3d70a = a_ents["fxanim_pap_elements"];
	var_71e3d70a HidePart("p7_zm_isl_pap_elements_wheel_jnt");
	level flag::wait_till("pap_wheel");
	var_71e3d70a ShowPart("p7_zm_isl_pap_elements_wheel_jnt");
	wait(1);
	level scene::Play("p7_fxanim_zm_island_pap_elements_wheel_bundle");
}

/*
	Name: function_aa37ce2d
	Namespace: namespace_f7d4f63b
	Checksum: 0x1333E8E
	Offset: 0x1020
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function function_aa37ce2d()
{
	var_b1e70b95 = GetEnt("trigger_pap_hint", "targetname");
	var_b1e70b95 setcursorhint("HINT_NOICON");
	var_b1e70b95 setHintString("");
	var_a36ea22c = GetEnt("pap_gate", "targetname");
	var_a36ea22c.s_pos = struct::get(var_a36ea22c.target);
	level flag::wait_till("pap_water_drained");
	if(zm_utility::is_player_valid(level.var_16e32c2f))
	{
		level.var_16e32c2f notify("hash_7301e8c8");
	}
	var_a36ea22c moveto(var_a36ea22c.s_pos.origin, 3);
	var_a36ea22c playsound("zmb_papquest_gate_move");
	level thread namespace_f333593c::function_3bf2d62a("pap_opens", 0, 1, 0);
	var_a36ea22c waittill("movedone");
	level flag::set("pap_open");
	var_b1e70b95 delete();
	t_door = GetEnt("trigger_pap", "script_noteworthy");
	t_door zm_blockers::door_opened(0);
}

/*
	Name: function_4c046b1b
	Namespace: namespace_f7d4f63b
	Checksum: 0x46C3C586
	Offset: 0x1238
	Size: 0x255
	Parameters: 0
	Flags: None
*/
function function_4c046b1b()
{
	level flag::wait_till_clear("pap_water_is_draining");
	level.var_12542033++;
	switch(level.var_12542033)
	{
		case 1:
		{
			exploder::exploder("fxexp_300");
			break;
		}
		case 2:
		{
			exploder::exploder("fxexp_301");
			break;
		}
		case 3:
		{
			exploder::exploder("fxexp_302");
			level flag::set("pap_water_drained");
			break;
		}
		case default:
		{
			break;
		}
	}
	level.pack_a_punch.triggers[0] playsound("zmb_papquest_drain_oneshot");
	level flag::set("pap_water_is_draining");
	level clientfield::set("lower_pap_water", level.var_12542033);
	wait(3);
	level flag::clear("pap_water_is_draining");
	switch(level.var_12542033)
	{
		case 1:
		{
			exploder::exploder_stop("fxexp_300");
			level thread namespace_f333593c::function_3bf2d62a("drain_pap", 0, 1, 0);
			break;
		}
		case 2:
		{
			exploder::exploder_stop("fxexp_301");
			level thread namespace_f333593c::function_3bf2d62a("drain_pap", 0, 1, 0);
			break;
		}
		case 3:
		{
			exploder::exploder_stop("fxexp_302");
			break;
		}
	}
}

/*
	Name: function_dd9ccb8
	Namespace: namespace_f7d4f63b
	Checksum: 0x90894943
	Offset: 0x1498
	Size: 0x223
	Parameters: 1
	Flags: None
*/
function function_dd9ccb8(n_id)
{
	if(n_id == 1)
	{
		self.trigger = namespace_8aed53c9::function_d095318(self.origin, 50, 1, &function_72a105ff);
		continue;
	}
	if(n_id == 2)
	{
		self.trigger = namespace_8aed53c9::function_d095318(self.origin, 50, 1, &function_e35907c);
		continue;
	}
	self.trigger = namespace_8aed53c9::function_d095318(self.origin, 50, 1, &function_578e801d);
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(zm_utility::is_player_valid(player) && level flag::get(self.script_noteworthy))
		{
			zm_unitrigger::unregister_unitrigger(self.trigger);
			self.trigger = undefined;
			player playsound("zmb_papquest_valve_replace");
			level thread function_4c046b1b();
			level.var_16e32c2f = player;
			if(n_id == 1)
			{
				level flag::set("pap_gauge");
			}
			else if(n_id == 2)
			{
				level flag::set("pap_wheel");
			}
			else
			{
				level flag::set("pap_whistle");
			}
			break;
		}
	}
}

/*
	Name: function_72a105ff
	Namespace: namespace_f7d4f63b
	Checksum: 0xD6F40F17
	Offset: 0x16C8
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_72a105ff(e_player)
{
	if(level flag::get("valve1_found"))
	{
		return &"ZM_ISLAND_DRAIN_WATER";
	}
	else
	{
		return &"ZOMBIE_BUILD_PIECE_MORE";
	}
}

/*
	Name: function_e35907c
	Namespace: namespace_f7d4f63b
	Checksum: 0xEDF00CBE
	Offset: 0x1718
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_e35907c(e_player)
{
	if(level flag::get("valve2_found"))
	{
		return &"ZM_ISLAND_DRAIN_WATER";
	}
	else
	{
		return &"ZOMBIE_BUILD_PIECE_MORE";
	}
}

/*
	Name: function_578e801d
	Namespace: namespace_f7d4f63b
	Checksum: 0x14C0791
	Offset: 0x1768
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_578e801d(e_player)
{
	if(level flag::get("valve3_found"))
	{
		return &"ZM_ISLAND_DRAIN_WATER";
	}
	else
	{
		return &"ZOMBIE_BUILD_PIECE_MORE";
	}
}

/*
	Name: function_1a519eae
	Namespace: namespace_f7d4f63b
	Checksum: 0xAF5617AE
	Offset: 0x17B8
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function function_1a519eae(str_flag)
{
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			player notify("hash_620ff7e");
			zm_unitrigger::unregister_unitrigger(self.trigger);
			player playsound("zmb_valve_pickup");
			level flag::set(str_flag);
			self.trigger = undefined;
			self delete();
			level thread function_90913542(str_flag);
			break;
		}
	}
}

/*
	Name: function_90913542
	Namespace: namespace_f7d4f63b
	Checksum: 0x81644225
	Offset: 0x18B0
	Size: 0x2B5
	Parameters: 1
	Flags: None
*/
function function_90913542(str_flag)
{
	a_players = [];
	if(self == level)
	{
		a_players = level.players;
	}
	else if(isPlayer(self))
	{
		a_players = Array(self);
	}
	else
	{
		return;
	}
	switch(str_flag)
	{
		case "valve1_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("valvethree_part_lever", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.valveone_part_lever", "zmInventory.widget_machinetools_parts", 0);
			}
			break;
		}
		case "valve2_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("valveone_part_lever", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.valvetwo_part_lever", "zmInventory.widget_machinetools_parts", 0);
			}
			break;
		}
		case "valve3_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("valvetwo_part_lever", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.valvethree_part_lever", "zmInventory.widget_machinetools_parts", 0);
			}
			break;
		}
	}
}

/*
	Name: function_d0901c34
	Namespace: namespace_f7d4f63b
	Checksum: 0x539D5C33
	Offset: 0x1B70
	Size: 0x1A1
	Parameters: 0
	Flags: None
*/
function function_d0901c34()
{
	level.var_e1bb72d5 = 0;
	level.var_69ca3c45 = 0;
	var_1daee2f1 = GetEntArray("cocoon_bunker", "targetname");
	foreach(var_e6d966e in var_1daee2f1)
	{
		var_e6d966e.is_open = 0;
		var_e6d966e.clip = GetEnt(var_e6d966e.target, "targetname");
		var_e6d966e.var_aa12511 = struct::get(var_e6d966e.clip.target);
		var_e6d966e.clip SetCanDamage(1);
		var_e6d966e.clip.health = 100000;
		var_e6d966e scene::init("p7_fxanim_zm_island_cocoon_open_bundle", var_e6d966e);
		var_e6d966e thread function_c762197b();
	}
}

/*
	Name: function_c762197b
	Namespace: namespace_f7d4f63b
	Checksum: 0x12AE27A
	Offset: 0x1D20
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function function_c762197b()
{
	self waittill("opened");
	if(isdefined(self.clip))
	{
		self.clip connectpaths();
		self.clip delete();
	}
	self.is_open = 1;
	self thread function_7a0ede5();
	var_aa12511 = self.var_aa12511;
	ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "cocoon_zombie", var_aa12511);
	if(isdefined(ai_zombie))
	{
		ai_zombie.b_ignore_cleanup = 1;
		ai_zombie.no_damage_points = 1;
		ai_zombie.deathpoints_already_given = 1;
		ai_zombie thread namespace_8aed53c9::function_acd04dc9();
		wait(0.1);
		self thread scene::Play("zm_dlc2_zombie_spawn_cocoon_v" + RandomInt(3) + 1, ai_zombie);
	}
}

/*
	Name: function_bd8082d1
	Namespace: namespace_f7d4f63b
	Checksum: 0xDA978203
	Offset: 0x1E88
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_bd8082d1()
{
	var_1daee2f1 = GetEntArray("cocoon_bunker", "targetname");
	var_d43245b8 = [];
	foreach(var_e6d966e in var_1daee2f1)
	{
		if(!var_e6d966e.is_open)
		{
			if(!isdefined(var_d43245b8))
			{
				var_d43245b8 = [];
			}
			else if(!IsArray(var_d43245b8))
			{
				var_d43245b8 = Array(var_d43245b8);
			}
			var_d43245b8[var_d43245b8.size] = var_e6d966e;
		}
	}
	var_696dc555 = Array::random(var_d43245b8);
	var_696dc555.var_166a0518 = 1;
}

/*
	Name: function_7a0ede5
	Namespace: namespace_f7d4f63b
	Checksum: 0x5270CDAF
	Offset: 0x1FE0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_7a0ede5()
{
	self PlayLoopSound("zmb_cocoon_lp", 1);
	playsoundatposition("evt_cocoon_explode", self.origin + VectorScale((0, 0, -1), 100));
	self StopLoopSound();
	if(isdefined(self.var_166a0518))
	{
		self function_14c57bc9();
	}
	level.var_e1bb72d5++;
	if(level.var_e1bb72d5 >= 3 && !level.var_69ca3c45)
	{
		level.var_69ca3c45 = 1;
		function_bd8082d1();
	}
}

/*
	Name: function_b09adc86
	Namespace: namespace_f7d4f63b
	Checksum: 0xB66053A7
	Offset: 0x20B8
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function function_b09adc86(str_mod)
{
	if(str_mod == "MOD_MELEE" || zm_utility::is_explosive_damage(str_mod))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_14c57bc9
	Namespace: namespace_f7d4f63b
	Checksum: 0x43D790DA
	Offset: 0x2100
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_14c57bc9()
{
	var_71e3d70a = util::spawn_model("p7_zm_isl_pap_elements_gauge", self.origin + VectorScale((0, 0, -1), 154));
	var_71e3d70a clientfield::set("show_part", 1);
	var_71e3d70a SetScale(1.5);
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_1a519eae("valve1_found");
}

/*
	Name: function_9bd3096f
	Namespace: namespace_f7d4f63b
	Checksum: 0x37B09B4
	Offset: 0x21E8
	Size: 0x11
	Parameters: 1
	Flags: Private
*/
function private function_9bd3096f(player)
{
	return &"ZOMBIE_BUILD_PIECE_GRAB";
}

/*
	Name: function_f4a071bb
	Namespace: namespace_f7d4f63b
	Checksum: 0x6353BA5
	Offset: 0x2208
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function function_f4a071bb()
{
	level flag::init("defend_over");
	level.var_a36ea22c = GetEnt("defend_gate", "targetname");
	level.var_935a64f = GetEnt("defend_clip", "targetname");
	level.var_935a64f notsolid();
	level.var_935a64f connectpaths();
	var_a2365998 = struct::get("valvethree_part_lever");
	s_pos = struct::get(var_a2365998.target);
	level.var_ced49fc = util::spawn_model("p7_zm_isl_pap_elements_whistle", var_a2365998.origin, var_a2365998.angles);
	level.var_ced49fc SetScale(1.5);
	level.var_ced49fc.v_org = s_pos.origin;
	level.var_ced49fc.v_ang = s_pos.angles;
	level.var_ced49fc clientfield::set("show_part", 1);
	level thread defend_start();
}

/*
	Name: defend_start
	Namespace: namespace_f7d4f63b
	Checksum: 0x95B89443
	Offset: 0x23E0
	Size: 0x397
	Parameters: 0
	Flags: None
*/
function defend_start()
{
	while(!level flag::exists("penstock_debris_cleared"))
	{
		wait(1);
	}
	var_44f2dff7 = struct::get_array("defend_valve_spawnpt");
	level.var_74049442 = 0;
	switch(level.players.size)
	{
		case 1:
		{
			var_4cf30066 = 8;
			break;
		}
		case 2:
		{
			var_4cf30066 = 10;
			break;
		}
		case 3:
		{
			var_4cf30066 = 14;
			break;
		}
		case 4:
		{
			var_4cf30066 = 18;
			break;
		}
	}
	level flag::wait_till("penstock_debris_cleared");
	level.var_a36ea22c.v_org = level.var_a36ea22c.origin;
	level.var_a36ea22c.v_pos = struct::get(level.var_a36ea22c.target).origin;
	level.var_935a64f solid();
	level.var_935a64f disconnectpaths();
	level.var_a36ea22c moveto(level.var_a36ea22c.v_pos, 3);
	level.var_a36ea22c playsound("zmb_papquest_defend_gate_close");
	exploder::exploder("fxexp_202");
	level.disable_nuke_delay_spawning = 1;
	level flag::clear("spawn_zombies");
	level thread function_3d4e00c();
	exploder::exploder("lgt_penstock_event");
	while(level.var_74049442 < 13)
	{
		var_44f2dff7 = Array::randomize(var_44f2dff7);
		for(i = 0; i < var_44f2dff7.size; i++)
		{
			while(GetFreeActorCount() < 1)
			{
				wait(0.05);
			}
			while(function_a3ebebe() >= var_4cf30066)
			{
				wait(0.05);
			}
			ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "defend_zombie", var_44f2dff7[i]);
			if(isdefined(ai_zombie))
			{
				if(isdefined(var_44f2dff7[i].script_int))
				{
					ai_zombie.var_57b55f08 = 1;
				}
				ai_zombie thread function_2392e644();
				level.var_74049442++;
				if(level.var_74049442 >= 13)
				{
					break;
				}
				wait(1.5);
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_3d4e00c
	Namespace: namespace_f7d4f63b
	Checksum: 0x8663754
	Offset: 0x2780
	Size: 0xE5
	Parameters: 0
	Flags: None
*/
function function_3d4e00c()
{
	level endon("hash_9e77115a");
	wait(5);
	while(1)
	{
		n_zombies = function_a3ebebe();
		var_4cba8874 = function_2870b97d();
		if(!n_zombies && level.var_74049442 >= 13 || var_4cba8874.size == 0)
		{
			level thread function_9fcd89f7();
			level.disable_nuke_delay_spawning = 0;
			level flag::set("spawn_zombies");
			level flag::set("defend_over");
		}
		wait(1);
	}
}

/*
	Name: function_9fcd89f7
	Namespace: namespace_f7d4f63b
	Checksum: 0xF0570E49
	Offset: 0x2870
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function function_9fcd89f7()
{
	level notify("hash_d5fa4175");
	exploder::exploder("fxexp_201");
	exploder::exploder_stop("lgt_penstock_event");
	level.var_ced49fc moveto(level.var_ced49fc.v_org, 3);
	level.var_ced49fc RotateTo(level.var_ced49fc.v_ang, 3);
	level.var_ced49fc waittill("movedone");
	level.var_ced49fc.trigger = namespace_8aed53c9::function_d095318(level.var_ced49fc.origin, 50, 1, &function_9bd3096f);
	level.var_ced49fc thread function_1a519eae("valve3_found");
	level flag::set("defend_success");
	level.var_a36ea22c moveto(level.var_a36ea22c.v_org, 3);
	level.var_a36ea22c playsound("zmb_papquest_defend_gate_open");
	exploder::exploder("fxexp_202");
	level.var_a36ea22c waittill("movedone");
	level.var_935a64f delete();
}

/*
	Name: function_a3ebebe
	Namespace: namespace_f7d4f63b
	Checksum: 0xE042DA91
	Offset: 0x2A48
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function function_a3ebebe()
{
	var_ca238230 = 0;
	var_34dc7362 = GetEnt("penstock_defend", "script_noteworthy");
	a_ai_zombies = GetAITeamArray(level.zombie_team);
	foreach(ai_zombie in a_ai_zombies)
	{
		if(ai_zombie istouching(var_34dc7362) && isalive(ai_zombie) && ai_zombie.var_6eb9188d === 1)
		{
			var_ca238230++;
		}
	}
	return var_ca238230;
}

/*
	Name: function_2870b97d
	Namespace: namespace_f7d4f63b
	Checksum: 0xD744BA4B
	Offset: 0x2B80
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function function_2870b97d()
{
	var_4399a34 = [];
	var_34dc7362 = GetEnt("penstock_defend", "script_noteworthy");
	foreach(player in level.players)
	{
		if(player istouching(var_34dc7362) && zm_utility::is_player_valid(player) && !player laststand::player_is_in_laststand())
		{
			if(!isdefined(var_4399a34))
			{
				var_4399a34 = [];
			}
			else if(!IsArray(var_4399a34))
			{
				var_4399a34 = Array(var_4399a34);
			}
			var_4399a34[var_4399a34.size] = player;
		}
	}
	return var_4399a34;
}

/*
	Name: function_55dac330
	Namespace: namespace_f7d4f63b
	Checksum: 0xC19922
	Offset: 0x2CE8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function function_55dac330()
{
	foreach(ai_zombie in GetAITeamArray(level.zombie_team))
	{
		ai_zombie ai::set_ignoreall(0);
	}
	IPrintLnBold("DEFEND FAILED");
	level.var_a36ea22c MoveZ(96, 3);
	level.var_a36ea22c playsound("zmb_papquest_defend_gate_open");
	level.var_a36ea22c waittill("movedone");
	level.var_935a64f MoveZ(96, 3);
	level thread defend_start();
	level flag::set("spawn_zombies");
}

/*
	Name: function_2392e644
	Namespace: namespace_f7d4f63b
	Checksum: 0x1AE44FB1
	Offset: 0x2E50
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_2392e644()
{
	self endon("death");
	self.var_6eb9188d = 1;
	if(isdefined(self.var_57b55f08))
	{
		self thread function_318ec9ba();
	}
	self waittill("completed_emerging_into_playable_area");
	self.no_damage_points = 1;
	self.deathpoints_already_given = 1;
	self.no_powerups = 1;
	self.ignore_enemy_count = 1;
	self.script_string = "find_flesh";
}

/*
	Name: function_318ec9ba
	Namespace: namespace_f7d4f63b
	Checksum: 0x2049C179
	Offset: 0x2EE0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_318ec9ba()
{
	self endon("death");
	trigger::wait_till("trigger_penstock_water", "targetname", self);
	self clientfield::set("zombie_splash", 1);
}

/*
	Name: function_83af0b87
	Namespace: namespace_f7d4f63b
	Checksum: 0xD7D0724A
	Offset: 0x2F40
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function function_83af0b87(t_water)
{
	self endon("death");
	while(1)
	{
		while(!self istouching(t_water))
		{
			wait(0.1);
		}
		if(!self.is_underwater)
		{
			self.is_underwater = 1;
			self ASMSetAnimationRate(0.8);
		}
		while(self istouching(t_water))
		{
			wait(0.1);
		}
		self.is_underwater = 0;
		self ASMSetAnimationRate(1);
		wait(0.1);
	}
}

/*
	Name: function_4fdc8e70
	Namespace: namespace_f7d4f63b
	Checksum: 0x33717E3C
	Offset: 0x3020
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function function_4fdc8e70()
{
	level flag::wait_till("connect_bunker_exterior_to_bunker_interior");
	var_f89319f8 = struct::get_array("valvetwo_part_lever");
	var_71e3d70a = util::spawn_model("p7_zm_isl_pap_elements_wheel", Array::random(var_f89319f8).origin);
	var_71e3d70a clientfield::set("show_part", 1);
	var_71e3d70a SetScale(1.5);
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_1a519eae("valve2_found");
}

/*
	Name: function_851f0b97
	Namespace: namespace_f7d4f63b
	Checksum: 0xDAC05AF1
	Offset: 0x3158
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_851f0b97()
{
	var_1af0fcd8 = GetEnt("bunker_penstock_blue_sign_reveal", "targetname");
	var_1af0fcd8 clientfield::set("do_emissive_material", 0);
}

/*
	Name: function_145f4b1a
	Namespace: namespace_f7d4f63b
	Checksum: 0x1332F842
	Offset: 0x31B0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_145f4b1a()
{
	self endon("disconnect");
	level endon("hash_62f73de6");
	var_1af0fcd8 = GetEnt("bunker_penstock_blue_sign_reveal", "targetname");
	self namespace_8aed53c9::function_7448e472(var_1af0fcd8);
	var_1af0fcd8 thread function_336744d2();
}

/*
	Name: function_336744d2
	Namespace: namespace_f7d4f63b
	Checksum: 0x51C31969
	Offset: 0x3238
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_336744d2()
{
	callback::remove_on_spawned(&on_player_spawned);
	level notify("hash_62f73de6");
	self clientfield::set("do_emissive_material", 1);
}

/*
	Name: function_7cd896fc
	Namespace: namespace_f7d4f63b
	Checksum: 0xBA8B39B2
	Offset: 0x3298
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_7cd896fc()
{
	/#
		zm_devgui::function_4acecab5(&function_9e3140d6);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_9e3140d6
	Namespace: namespace_f7d4f63b
	Checksum: 0x76A27351
	Offset: 0x3318
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function function_9e3140d6(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level thread function_90913542("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level thread function_90913542("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level thread function_90913542("Dev Block strings are not supported");
				return 1;
			}
		}
		return 0;
	#/
}

