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

#namespace namespace_52f9507e;

/*
	Name: __init__sytem__
	Namespace: namespace_52f9507e
	Checksum: 0xACDF62F
	Offset: 0x508
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_52f9507e
	Checksum: 0x28888A75
	Offset: 0x548
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	n_bits = GetMinBitCountForNum(3);
	clientfield::register("toplayer", "player_stargate_fx", 9000, 1, "int");
	clientfield::register("world", "portal_state_ending_0", 9000, 1, "int");
	clientfield::register("world", "portal_state_ending_1", 9000, 1, "int");
	clientfield::register("world", "portal_state_ending_2", 9000, 1, "int");
	clientfield::register("world", "portal_state_ending_3", 9000, 1, "int");
	clientfield::register("world", "pulse_ee_boat_portal_top", 9000, 1, "counter");
	clientfield::register("world", "pulse_ee_boat_portal_bottom", 9000, 1, "counter");
	visionset_mgr::register_info("overlay", "zm_zod_transported", 9000, 20, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
}

/*
	Name: function_16616103
	Namespace: namespace_52f9507e
	Checksum: 0x99EC1590
	Offset: 0x710
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_16616103()
{
}

/*
	Name: function_e4ff383e
	Namespace: namespace_52f9507e
	Checksum: 0xAF8B6022
	Offset: 0x720
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function function_e4ff383e(var_49e3dd2e, var_d16ec704)
{
	level flag::wait_till(var_49e3dd2e);
	level flag::set(var_d16ec704);
}

/*
	Name: create_portal
	Namespace: namespace_52f9507e
	Checksum: 0xF618D29D
	Offset: 0x770
	Size: 0x333
	Parameters: 3
	Flags: None
*/
function create_portal(str_id, var_fc699b20, var_776628b2)
{
	width = 192;
	height = 128;
	length = 192;
	var_d42f02cf = str_id;
	s_loc = struct::get(var_d42f02cf, "targetname");
	var_1693bd2 = GetNodeArray(var_d42f02cf + "_portal_node", "script_noteworthy");
	foreach(var_9110bac3 in var_1693bd2)
	{
		SetEnableNode(var_9110bac3, 0);
	}
	if(isdefined(var_fc699b20) && var_fc699b20)
	{
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
	else if(isdefined(var_776628b2))
	{
		level flag::wait_till(var_776628b2);
		level thread function_e0c93f92(var_d42f02cf);
	}
	else
	{
		level thread function_e0c93f92(var_d42f02cf);
	}
}

/*
	Name: function_16fca6d
	Namespace: namespace_52f9507e
	Checksum: 0xFC02FCA
	Offset: 0xAB0
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function function_16fca6d(player)
{
	var_d42f02cf = self.stub.var_d42f02cf;
	var_8f5050e8 = level clientfield::get("portal_state_" + var_d42f02cf);
	if(var_8f5050e8 !== 1 && (!isdefined(player.beastmode) && player.beastmode))
	{
		self setHintString(&"ZM_GENESIS_PORTAL_OPEN");
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
	Namespace: namespace_52f9507e
	Checksum: 0x6CBB6E6E
	Offset: 0xBA8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_a90ab0d7()
{
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
	Name: function_e0c93f92
	Namespace: namespace_52f9507e
	Checksum: 0xDC85590A
	Offset: 0xC58
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
	Namespace: namespace_52f9507e
	Checksum: 0x3DF17376
	Offset: 0xCB0
	Size: 0x36B
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
}

/*
	Name: portal_think
	Namespace: namespace_52f9507e
	Checksum: 0x42817D02
	Offset: 0x1028
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function portal_think()
{
	if(!isdefined(self.target))
	{
		return;
	}
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
	Namespace: namespace_52f9507e
	Checksum: 0x8D197902
	Offset: 0x11B8
	Size: 0x8CB
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
	level.var_6fe80781 = GetTime();
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
	if(isdefined(self.script_string))
	{
		zm_zonemgr::enable_zone(self.script_string);
	}
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
	Namespace: namespace_52f9507e
	Checksum: 0xAE037F09
	Offset: 0x1A90
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
	Namespace: namespace_52f9507e
	Checksum: 0x514F9DA6
	Offset: 0x1AF8
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

