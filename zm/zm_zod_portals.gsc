#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_quest;

#namespace namespace_8e2647d0;

/*
	Name: __init__sytem__
	Namespace: namespace_8e2647d0
	Checksum: 0xB683972A
	Offset: 0x600
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8e2647d0
	Checksum: 0x54A6FBBE
	Offset: 0x640
	Size: 0x293
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["portal_3p"] = "zombie/fx_quest_portal_trail_zod_zmb";
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("toplayer", "player_stargate_fx", 1, 1, "int");
	clientfield::register("world", "portal_state_canal", 1, n_bits, "int");
	clientfield::register("world", "portal_state_slums", 1, n_bits, "int");
	clientfield::register("world", "portal_state_theater", 1, n_bits, "int");
	clientfield::register("world", "portal_state_ending", 1, 1, "int");
	clientfield::register("world", "pulse_canal_portal_top", 1, 1, "counter");
	clientfield::register("world", "pulse_canal_portal_bottom", 1, 1, "counter");
	clientfield::register("world", "pulse_slums_portal_top", 1, 1, "counter");
	clientfield::register("world", "pulse_slums_portal_bottom", 1, 1, "counter");
	clientfield::register("world", "pulse_theater_portal_top", 1, 1, "counter");
	clientfield::register("world", "pulse_theater_portal_bottom", 1, 1, "counter");
	visionset_mgr::register_info("overlay", "zm_zod_transported", 1, 20, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
}

/*
	Name: function_54ec766b
	Namespace: namespace_8e2647d0
	Checksum: 0x3B736B57
	Offset: 0x8E0
	Size: 0x2BB
	Parameters: 1
	Flags: None
*/
function function_54ec766b(str_id)
{
	width = 192;
	height = 128;
	length = 192;
	var_d42f02cf = function_7679b497(str_id);
	s_loc = function_42ed55f2(var_d42f02cf);
	var_1693bd2 = GetNodeArray(var_d42f02cf + "_portal_node", "script_noteworthy");
	foreach(var_9110bac3 in var_1693bd2)
	{
		SetEnableNode(var_9110bac3, 0);
	}
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.var_d42f02cf = var_d42f02cf;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_16fca6d;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_a90ab0d7);
}

/*
	Name: function_16fca6d
	Namespace: namespace_8e2647d0
	Checksum: 0xE6446812
	Offset: 0xBA8
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function function_16fca6d(player)
{
	level endon("hash_7c61dd0");
	var_d42f02cf = self.stub.var_d42f02cf;
	var_8f5050e8 = level clientfield::get("portal_state_" + var_d42f02cf);
	if(var_8f5050e8 !== 1 && (!isdefined(player.beastmode) && player.beastmode))
	{
		self setHintString(&"ZM_ZOD_PORTAL_OPEN");
		b_is_invis = 0;
	}
	else
	{
		b_is_invis = 1;
	}
	self SetInvisibleToPlayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_a90ab0d7
	Namespace: namespace_8e2647d0
	Checksum: 0x909F3271
	Offset: 0xCA8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_a90ab0d7()
{
	level endon("hash_7c61dd0");
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
		level thread function_e0c93f92(self.stub.var_d42f02cf);
		break;
	}
}

/*
	Name: function_42ed55f2
	Namespace: namespace_8e2647d0
	Checksum: 0xAC2689B9
	Offset: 0xD60
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function function_42ed55f2(var_d42f02cf)
{
	var_3842f06d = struct::get_array("teleport_effect_origin", "targetname");
	var_216e113e = undefined;
	foreach(var_50f27682 in var_3842f06d)
	{
		if(var_50f27682.script_noteworthy === var_d42f02cf + "_portal_top")
		{
			var_216e113e = var_50f27682;
		}
	}
	return var_216e113e;
}

/*
	Name: function_e0c93f92
	Namespace: namespace_8e2647d0
	Checksum: 0x69B35316
	Offset: 0xE50
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_e0c93f92(var_d42f02cf)
{
	level clientfield::set("portal_state_" + var_d42f02cf, 1);
	function_1e956fba(var_d42f02cf);
}

/*
	Name: function_1e956fba
	Namespace: namespace_8e2647d0
	Checksum: 0x36C40FF2
	Offset: 0xEA8
	Size: 0x38B
	Parameters: 2
	Flags: None
*/
function function_1e956fba(var_d42f02cf, var_14429fc9)
{
	if(!isdefined(var_14429fc9))
	{
		var_14429fc9 = 0;
	}
	if(var_14429fc9)
	{
		level clientfield::set("portal_state_" + var_d42f02cf, 2);
	}
	var_1693bd2 = GetNodeArray(var_d42f02cf + "_portal_node", "script_noteworthy");
	foreach(var_9110bac3 in var_1693bd2)
	{
		SetEnableNode(var_9110bac3, 1);
	}
	var_de1f2abc = GetEntArray(var_d42f02cf + "_portal_top", "script_noteworthy");
	var_ebfa395 = function_ca448a30(var_de1f2abc, "teleport_trigger", "targetname");
	var_58afe656 = GetEntArray(var_d42f02cf + "_portal_bottom", "script_noteworthy");
	var_50fc4fb = function_ca448a30(var_58afe656, "teleport_trigger", "targetname");
	var_ebfa395[0].e_dest = var_50fc4fb[0];
	var_50fc4fb[0].e_dest = var_ebfa395[0];
	foreach(var_9110bac3 in var_1693bd2)
	{
		var_e8b9ac31 = DistanceSquared(var_9110bac3.origin, var_ebfa395[0].origin);
		var_6d6d9e09 = DistanceSquared(var_9110bac3.origin, var_50fc4fb[0].origin);
		if(var_e8b9ac31 < var_6d6d9e09)
		{
			var_9110bac3.portal_trig = var_ebfa395[0];
			continue;
		}
		var_9110bac3.portal_trig = var_50fc4fb[0];
	}
	wait(2.5);
	var_ebfa395[0] thread portal_think();
	var_50fc4fb[0] thread portal_think();
	level flag::set("activate_underground");
}

/*
	Name: function_7679b497
	Namespace: namespace_8e2647d0
	Checksum: 0x8EA2C018
	Offset: 0x1240
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function function_7679b497(str_input)
{
	a_str_names = Array("canal", "slums", "theater");
	foreach(str_name in a_str_names)
	{
		if(IsSubStr(str_input, str_name))
		{
			return str_name;
		}
	}
}

/*
	Name: portal_think
	Namespace: namespace_8e2647d0
	Checksum: 0x355A376
	Offset: 0x1320
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function portal_think()
{
	self.var_71abf438 = struct::get_array(self.target, "targetname");
	while(1)
	{
		self waittill("trigger", var_5ee55fde);
		level clientfield::increment("pulse_" + self.script_noteworthy);
		if(isdefined(var_5ee55fde.teleporting) && var_5ee55fde.teleporting)
		{
			continue;
		}
		if(isPlayer(var_5ee55fde))
		{
			if(var_5ee55fde GetStance() != "prone")
			{
				playFX(level._effect["portal_3p"], var_5ee55fde.origin);
				var_5ee55fde playlocalsound("zmb_teleporter_teleport_2d");
				playsoundatposition("zmb_teleporter_teleport_out", var_5ee55fde.origin);
				self thread function_d0ff7e09(var_5ee55fde);
			}
		}
	}
}

/*
	Name: function_d0ff7e09
	Namespace: namespace_8e2647d0
	Checksum: 0x733F4314
	Offset: 0x14A0
	Size: 0x923
	Parameters: 2
	Flags: None
*/
function function_d0ff7e09(player, show_fx)
{
	if(!isdefined(show_fx))
	{
		show_fx = 1;
	}
	player endon("disconnect");
	player.teleporting = 1;
	player.teleport_location = player.origin;
	if(show_fx)
	{
		player clientfield::set_to_player("player_stargate_fx", 1);
	}
	n_pos = player.characterindex;
	prone_offset = VectorScale((0, 0, 1), 49);
	crouch_offset = VectorScale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	a_ai_enemies = GetAITeamArray("axis");
	a_ai_enemies = ArraySort(a_ai_enemies, self.origin, 1, 99, 768);
	Array::thread_all(a_ai_enemies, &function_7807150a);
	level.n_cleanup_manager_restart_time = 2 + 15;
	level.n_cleanup_manager_restart_time = level.n_cleanup_manager_restart_time + GetTime() / 1000;
	image_room = struct::get("teleport_room_" + n_pos, "targetname");
	player disableOffhandWeapons();
	player DisableWeapons();
	player FreezeControls(1);
	util::wait_network_frame();
	if(player GetStance() == "prone")
	{
		desired_origin = image_room.origin + prone_offset;
	}
	else if(player GetStance() == "crouch")
	{
		desired_origin = image_room.origin + crouch_offset;
	}
	else
	{
		desired_origin = image_room.origin + stand_offset;
	}
	player.teleport_origin = spawn("script_model", player.origin);
	player.teleport_origin SetModel("tag_origin");
	player.teleport_origin.angles = player.angles;
	player PlayerLinkToAbsolute(player.teleport_origin, "tag_origin");
	player.teleport_origin.origin = desired_origin;
	player.teleport_origin.angles = image_room.angles;
	util::wait_network_frame();
	player.teleport_origin.angles = image_room.angles;
	wait(2);
	if(show_fx)
	{
		player clientfield::set_to_player("player_stargate_fx", 0);
	}
	a_players = GetPlayers();
	ArrayRemoveValue(a_players, player);
	s_pos = Array::random(self.var_71abf438);
	if(a_players.size > 0)
	{
		var_cefa4b63 = 0;
		while(!var_cefa4b63)
		{
			var_cefa4b63 = 1;
			s_pos = Array::random(self.var_71abf438);
			foreach(var_3bc10d31 in a_players)
			{
				var_f2c93934 = Distance(var_3bc10d31.origin, s_pos.origin);
				if(var_f2c93934 < 32)
				{
					var_cefa4b63 = 0;
				}
			}
			wait(0.05);
		}
	}
	playFX(level._effect["portal_3p"], s_pos.origin);
	player Unlink();
	playsoundatposition("zmb_teleporter_teleport_in", s_pos.origin);
	if(isdefined(player.teleport_origin))
	{
		player.teleport_origin delete();
		player.teleport_origin = undefined;
	}
	player SetOrigin(s_pos.origin);
	player SetPlayerAngles(s_pos.angles);
	level clientfield::increment("pulse_" + self.e_dest.script_noteworthy);
	a_ai = GetAIArray();
	var_aca0d7c7 = ArraySortClosest(a_ai, s_pos.origin, a_ai.size, 0, 200);
	foreach(ai in var_aca0d7c7)
	{
		if(IsActor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playFX(level._effect["beast_return_aoe_kill"], ai GetTagOrigin("j_spineupper"));
			}
			else
			{
				playFX(level._effect["beast_return_aoe_kill"], ai.origin);
			}
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai.deathpoints_already_given = 1;
			ai.no_powerups = 1;
			ai DoDamage(ai.health + 1000, s_pos.origin, player);
		}
	}
	player enableWeapons();
	player EnableOffhandWeapons();
	player FreezeControls(level.intermission);
	player.teleporting = 0;
	player thread zm_audio::create_and_play_dialog("portal", "travel");
}

/*
	Name: function_7807150a
	Namespace: namespace_8e2647d0
	Checksum: 0x7FFAFFFF
	Offset: 0x1DD0
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function function_7807150a()
{
	if(!(isdefined(self.b_ignore_cleanup) && self.b_ignore_cleanup))
	{
		self notify("hash_450c36af");
		self endon("death");
		self endon("hash_450c36af");
		self.b_ignore_cleanup = 1;
		wait(10);
		self.b_ignore_cleanup = undefined;
	}
}

/*
	Name: function_eb1242c8
	Namespace: namespace_8e2647d0
	Checksum: 0xEFF1321
	Offset: 0x1E38
	Size: 0x2C3
	Parameters: 1
	Flags: None
*/
function function_eb1242c8(var_5ee55fde)
{
	var_5ee55fde endon("death");
	var_5ee55fde.teleporting = 1;
	var_5ee55fde PathMode("dont move");
	playFX(level._effect["portal_3p"], var_5ee55fde.origin);
	playsoundatposition("zmb_teleporter_teleport_out", var_5ee55fde.origin);
	util::wait_network_frame();
	image_room = struct::get("teleport_room_zombies", "targetname");
	if(IsActor(var_5ee55fde))
	{
		var_5ee55fde ForceTeleport(image_room.origin, image_room.angles);
	}
	else
	{
		var_5ee55fde.origin = image_room.origin;
		var_5ee55fde.angles = image_room.angles;
	}
	wait(2);
	var_97bf7ab1 = Array::random(self.var_71abf438);
	if(IsActor(var_5ee55fde))
	{
		var_5ee55fde ForceTeleport(var_97bf7ab1.origin, var_97bf7ab1.angles);
	}
	else
	{
		var_5ee55fde.origin = var_97bf7ab1.origin;
		var_5ee55fde.angles = var_97bf7ab1.angles;
	}
	level clientfield::increment("pulse_" + self.e_dest.script_noteworthy);
	playsoundatposition("zmb_teleporter_teleport_in", var_97bf7ab1.origin);
	playFX(level._effect["portal_3p"], var_97bf7ab1.origin);
	wait(1);
	var_5ee55fde PathMode("move allowed");
	var_5ee55fde.teleporting = 0;
}

