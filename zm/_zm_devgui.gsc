#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_rat;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_turned;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_devgui;

/*
	Name: __init__sytem__
	Namespace: zm_devgui
	Checksum: 0x4CE78BC
	Offset: 0x3E0
	Size: 0x43
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("Dev Block strings are not supported", &__init__, &__main__, undefined);
	#/
}

/*
	Name: __init__
	Namespace: zm_devgui
	Checksum: 0xE1065E72
	Offset: 0x430
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		level.devgui_add_weapon = &devgui_add_weapon;
		level.devgui_add_ability = &devgui_add_ability;
		level thread zombie_devgui_think();
		thread zombie_weapon_devgui_think();
		thread function_315fab2d();
		thread devgui_zombie_healthbar();
		thread function_47239612();
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		level thread dev::function_8ed979e4(0);
		thread testscriptruntimeerror();
		callback::on_connect(&player_on_connect);
	#/
}

/*
	Name: __main__
	Namespace: zm_devgui
	Checksum: 0x61E7FD8F
	Offset: 0x620
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
		level thread zombie_devgui_player_commands();
		level thread function_e7616d2f();
		level thread function_40dde582();
		level thread function_1d21f4f();
	#/
}

/*
	Name: zombie_devgui_player_commands
	Namespace: zm_devgui
	Checksum: 0x70C4E3F4
	Offset: 0x690
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function zombie_devgui_player_commands()
{
	/#
	#/
}

/*
	Name: player_on_connect
	Namespace: zm_devgui
	Checksum: 0x42A9C1CD
	Offset: 0x6A0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function player_on_connect()
{
	/#
		level flag::wait_till("Dev Block strings are not supported");
		wait(1);
		if(isdefined(self))
		{
			function_d6624f9e(self);
		}
	#/
}

/*
	Name: function_a9df7ce0
	Namespace: zm_devgui
	Checksum: 0x15A4F6B3
	Offset: 0x6F0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_a9df7ce0(playerName)
{
	/#
		var_dc719734 = "Dev Block strings are not supported" + playerName + "Dev Block strings are not supported";
		AddDebugCommand(var_dc719734);
	#/
}

/*
	Name: function_d6624f9e
	Namespace: zm_devgui
	Checksum: 0xEABBCDC6
	Offset: 0x748
	Size: 0x453
	Parameters: 1
	Flags: None
*/
function function_d6624f9e(player)
{
	/#
		function_a9df7ce0(player.name);
		ip1 = player GetEntityNumber() + 1;
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + player.name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		if(isdefined(level.var_e26adf8d))
		{
			level thread [[level.var_e26adf8d]](player, ip1);
		}
		self thread function_503d8fb1(player);
	#/
}

/*
	Name: function_503d8fb1
	Namespace: zm_devgui
	Checksum: 0x854843D
	Offset: 0xBA8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_503d8fb1(player)
{
	/#
		playerName = player.name;
		player waittill("disconnect");
		function_a9df7ce0(playerName);
	#/
}

/*
	Name: function_e7616d2f
	Namespace: zm_devgui
	Checksum: 0x17ECA99D
	Offset: 0xC08
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function function_e7616d2f()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		while(1)
		{
			cmd = GetDvarString("Dev Block strings are not supported");
			if(cmd != "Dev Block strings are not supported")
			{
				switch(cmd)
				{
					case "Dev Block strings are not supported":
					{
						function_5735dbec();
						break;
					}
					case "Dev Block strings are not supported":
					{
						if(!isdefined(level.var_c0d235a5))
						{
							level.var_c0d235a5 = 1;
						}
						else
						{
							level.var_c0d235a5 = !level.var_c0d235a5;
						}
						thread function_d02d5c2a();
						break;
					}
					case "Dev Block strings are not supported":
					{
						thread function_db177d();
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
	Name: function_5735dbec
	Namespace: zm_devgui
	Checksum: 0x8833465F
	Offset: 0xD90
	Size: 0x3F3
	Parameters: 0
	Flags: None
*/
function function_5735dbec()
{
	/#
		level.var_e9d63ac6 = 0;
		if(!isdefined(level.var_3d3b24de))
		{
			level.var_3d3b24de = 1;
			zombie_devgui_open_sesame();
			spawner = level.zombie_spawners[0];
			enemy = undefined;
			foreach(zone in level.zones)
			{
				foreach(spawn_point in zone.a_loc_types["Dev Block strings are not supported"])
				{
					if(!isdefined(zone.a_loc_types["Dev Block strings are not supported"]) || zone.a_loc_types["Dev Block strings are not supported"].size <= 0)
					{
						level.var_e9d63ac6++;
						thread function_3f7cbd96(spawn_point.origin, spawn_point.zone_name);
						println("Dev Block strings are not supported" + spawn_point.zone_name);
						IPrintLnBold("Dev Block strings are not supported" + spawn_point.zone_name);
						break;
					}
					if(!isdefined(enemy))
					{
						enemy = zombie_utility::spawn_zombie(spawner, spawner.targetname, spawn_point);
					}
					node = undefined;
					var_dcd2015e = spawn_point.origin;
					if(isdefined(spawn_point.script_string) && spawn_point.script_string != "Dev Block strings are not supported")
					{
						var_dcd2015e = enemy function_6d0f4f30(spawn_point, var_dcd2015e);
					}
					var_c856782f = GetClosestPointOnNavMesh(var_dcd2015e, 40, 30);
					if(!isdefined(var_c856782f))
					{
						var_c856782f = GetClosestPointOnNavMesh(var_dcd2015e, 100, 30);
						if(!isdefined(var_c856782f))
						{
							level.var_e9d63ac6++;
							thread function_3f7cbd96(var_dcd2015e);
						}
					}
					var_86c3615c = enemy function_df1875b4(zone, var_c856782f, spawn_point);
				}
			}
			println("Dev Block strings are not supported" + level.var_e9d63ac6);
			IPrintLnBold("Dev Block strings are not supported" + level.var_e9d63ac6);
			level.var_e9d63ac6 = undefined;
		}
		else
		{
			level.var_3d3b24de = !level.var_3d3b24de;
		}
	#/
}

/*
	Name: function_6d0f4f30
	Namespace: zm_devgui
	Checksum: 0x5F62E36B
	Offset: 0x1190
	Size: 0x20B
	Parameters: 2
	Flags: None
*/
function function_6d0f4f30(spawn_point, var_cac5c76f)
{
	/#
		for(j = 0; j < level.exterior_goals.size; j++)
		{
			if(isdefined(level.exterior_goals[j].script_string) && level.exterior_goals[j].script_string == spawn_point.script_string)
			{
				node = level.exterior_goals[j];
				break;
			}
		}
		if(isdefined(node))
		{
			var_86c3615c = self CanPath(spawn_point.origin, node.origin);
			if(!var_86c3615c)
			{
				level.var_e9d63ac6++;
				thread function_3f7cbd96(var_cac5c76f, undefined, undefined, node.origin);
				println("Dev Block strings are not supported" + var_cac5c76f + "Dev Block strings are not supported" + spawn_point.targetname);
				IPrintLnBold("Dev Block strings are not supported" + var_cac5c76f + "Dev Block strings are not supported" + spawn_point.targetname);
			}
			nodeForward = AnglesToForward(node.angles);
			nodeForward = VectorNormalize(nodeForward);
			var_dcd2015e = node.origin + nodeForward * 100;
			return var_dcd2015e;
		}
		return var_cac5c76f;
	#/
}

/*
	Name: function_df1875b4
	Namespace: zm_devgui
	Checksum: 0xAA60C80D
	Offset: 0x13A8
	Size: 0x219
	Parameters: 3
	Flags: None
*/
function function_df1875b4(zone, var_c856782f, spawn_point)
{
	/#
		foreach(loc in zone.a_loc_types["Dev Block strings are not supported"])
		{
			if(isdefined(loc))
			{
				var_1d39909 = loc.origin;
				if(isdefined(var_1d39909))
				{
					var_335d214 = GetClosestPointOnNavMesh(var_1d39909, 40, 30);
					if(!isdefined(var_335d214))
					{
						var_335d214 = GetClosestPointOnNavMesh(var_1d39909, 100, 30);
					}
					if(isdefined(var_c856782f) && isdefined(var_335d214))
					{
						var_86c3615c = self CanPath(var_c856782f, var_335d214);
						if(var_86c3615c)
						{
							return 1;
							continue;
						}
						level.var_e9d63ac6++;
						thread function_3f7cbd96(var_c856782f, undefined, var_335d214);
						println("Dev Block strings are not supported" + var_c856782f + "Dev Block strings are not supported" + spawn_point.targetname);
						IPrintLnBold("Dev Block strings are not supported" + var_c856782f + "Dev Block strings are not supported" + spawn_point.targetname);
						return 0;
					}
				}
			}
		}
		return 0;
	#/
}

/*
	Name: function_3f7cbd96
	Namespace: zm_devgui
	Checksum: 0x7678F58
	Offset: 0x15D0
	Size: 0x30F
	Parameters: 4
	Flags: None
*/
function function_3f7cbd96(origin, zone_name, var_c9c9e21f, var_3cf0ecd5)
{
	/#
		if(!isdefined(zone_name))
		{
			zone_name = undefined;
		}
		if(!isdefined(var_c9c9e21f))
		{
			var_c9c9e21f = undefined;
		}
		if(!isdefined(var_3cf0ecd5))
		{
			var_3cf0ecd5 = undefined;
		}
		while(1)
		{
			if(isdefined(level.var_3d3b24de) && level.var_3d3b24de)
			{
				if(!isdefined(origin))
				{
					break;
				}
				if(isdefined(zone_name))
				{
					circle(origin, 32, (1, 0, 0));
					print3d(origin, "Dev Block strings are not supported" + zone_name, (1, 1, 1), 1, 0.5);
				}
				else if(isdefined(var_c9c9e21f))
				{
					circle(origin, 32, (0, 0, 1));
					print3d(origin, "Dev Block strings are not supported" + origin, (1, 1, 1), 1, 0.5);
					line(origin, var_c9c9e21f, (1, 0, 0));
					circle(var_c9c9e21f, 32, (1, 0, 0));
					print3d(var_c9c9e21f, "Dev Block strings are not supported" + var_c9c9e21f, (1, 1, 1), 1, 0.5);
				}
				else if(isdefined(var_3cf0ecd5))
				{
					circle(origin, 32, (0, 0, 1));
					print3d(origin, "Dev Block strings are not supported" + origin, (1, 1, 1), 1, 0.5);
					line(origin, var_3cf0ecd5, (1, 0, 0));
					circle(var_3cf0ecd5, 32, (1, 0, 0));
					print3d(var_3cf0ecd5, "Dev Block strings are not supported" + var_3cf0ecd5, (1, 1, 1), 1, 0.5);
				}
				else
				{
					circle(origin, 32, (0, 0, 1));
					print3d(origin, "Dev Block strings are not supported" + origin, (1, 1, 1), 1, 0.5);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_d02d5c2a
	Namespace: zm_devgui
	Checksum: 0x5020E431
	Offset: 0x18E8
	Size: 0x25F
	Parameters: 0
	Flags: None
*/
function function_d02d5c2a()
{
	/#
		zombie_devgui_open_sesame();
		while(1)
		{
			if(isdefined(level.var_c0d235a5) && level.var_c0d235a5)
			{
				if(!isdefined(GetPlayers()[0].zone_name))
				{
					wait(0.05);
					continue;
				}
				str_zone = GetPlayers()[0].zone_name;
				keys = getArrayKeys(level.zones);
				offset = 0;
				foreach(key in keys)
				{
					if(key === str_zone)
					{
						function_83c0e2b(level.zones[key], 2, key);
						continue;
					}
					if(isdefined(level.zones[str_zone].adjacent_zones[key]))
					{
						if(level.zones[str_zone].adjacent_zones[key].is_connected)
						{
							offset = offset + 10;
							function_83c0e2b(level.zones[key], 1, key, level.zones[str_zone], offset);
						}
						else
						{
							function_83c0e2b(level.zones[key], 0, key);
						}
						continue;
					}
					function_83c0e2b(level.zones[key], 0, key);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_83c0e2b
	Namespace: zm_devgui
	Checksum: 0x3101DF27
	Offset: 0x1B50
	Size: 0x243
	Parameters: 5
	Flags: None
*/
function function_83c0e2b(zone, status, name, current_zone, offset)
{
	/#
		if(!isdefined(current_zone))
		{
			current_zone = undefined;
		}
		if(!isdefined(offset))
		{
			offset = 0;
		}
		if(!isdefined(zone.Volumes[0]))
		{
			return;
		}
		if(status == 2)
		{
			circle(zone.Volumes[0].origin, 30, (0, 1, 0));
			print3d(zone.Volumes[0].origin, name, (0, 1, 0), 1, 0.5);
		}
		else if(status == 1)
		{
			circle(zone.Volumes[0].origin, 30, (0, 0, 1));
			print3d(zone.Volumes[0].origin, name, (0, 0, 1), 1, 0.5);
			print3d(current_zone.Volumes[0].origin + (0, 20, offset * -1), name, (0, 0, 1), 1, 0.5);
		}
		else
		{
			circle(zone.Volumes[0].origin, 30, (1, 0, 0));
			print3d(zone.Volumes[0].origin, name, (1, 0, 0), 1, 0.5);
		}
	#/
}

/*
	Name: function_db177d
	Namespace: zm_devgui
	Checksum: 0xCAC8D0E0
	Offset: 0x1DA0
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function function_db177d()
{
	/#
		if(!isdefined(level.zombie_spawners[0]))
		{
			return;
		}
		if(!isdefined(level.var_db177d))
		{
			level.var_db177d = 1;
		}
		zombie_devgui_open_sesame();
		SetDvar("Dev Block strings are not supported", 0);
		zombie_devgui_goto_round(20);
		wait(2);
		spawner = level.zombie_spawners[0];
		var_7539800c = (808, -1856, 544);
		enemy = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		wait(1);
		while(isdefined(enemy) && enemy.completed_emerging_into_playable_area !== 1)
		{
			wait(0.05);
		}
		if(isdefined(enemy))
		{
			enemy ForceTeleport(var_7539800c);
			enemy.b_ignore_cleanup = 1;
		}
	#/
}

/*
	Name: function_300fe60f
	Namespace: zm_devgui
	Checksum: 0xC72218BA
	Offset: 0x1EF8
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function function_300fe60f(weapon_name, up, root)
{
	/#
		rootslash = "Dev Block strings are not supported";
		if(isdefined(root) && root.size)
		{
			rootslash = root + "Dev Block strings are not supported";
		}
		uppath = "Dev Block strings are not supported" + up;
		if(up.size < 1)
		{
			uppath = "Dev Block strings are not supported";
		}
		cmd = "Dev Block strings are not supported" + rootslash + weapon_name + uppath + "Dev Block strings are not supported" + weapon_name + "Dev Block strings are not supported";
		AddDebugCommand(cmd);
	#/
}

/*
	Name: devgui_add_weapon_entry
	Namespace: zm_devgui
	Checksum: 0x5055821B
	Offset: 0x1FF0
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function devgui_add_weapon_entry(weapon_name, up, root)
{
	/#
		rootslash = "Dev Block strings are not supported";
		if(isdefined(root) && root.size)
		{
			rootslash = root + "Dev Block strings are not supported";
		}
		uppath = "Dev Block strings are not supported" + up;
		if(up.size < 1)
		{
			uppath = "Dev Block strings are not supported";
		}
		cmd = "Dev Block strings are not supported" + rootslash + weapon_name + uppath + "Dev Block strings are not supported" + weapon_name + "Dev Block strings are not supported";
		AddDebugCommand(cmd);
	#/
}

/*
	Name: devgui_add_weapon_and_attachments
	Namespace: zm_devgui
	Checksum: 0xFB274287
	Offset: 0x20E8
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function devgui_add_weapon_and_attachments(weapon_name, up, root)
{
	/#
		devgui_add_weapon_entry(weapon_name, up, root);
	#/
}

/*
	Name: devgui_add_weapon
	Namespace: zm_devgui
	Checksum: 0x19D2AED5
	Offset: 0x2130
	Size: 0x13B
	Parameters: 7
	Flags: None
*/
function devgui_add_weapon(weapon, upgrade, hint, cost, weaponVO, weaponVOresp, ammo_cost)
{
	/#
		function_300fe60f(weapon.name, "Dev Block strings are not supported", "Dev Block strings are not supported");
		if(zm_utility::is_offhand_weapon(weapon) && !zm_utility::is_melee_weapon(weapon))
		{
			return;
		}
		if(!isdefined(level.devgui_weapons_added))
		{
			level.devgui_weapons_added = 0;
		}
		level.devgui_weapons_added++;
		if(zm_utility::is_melee_weapon(weapon))
		{
			devgui_add_weapon_and_attachments(weapon.name, "Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else
		{
			devgui_add_weapon_and_attachments(weapon.name, "Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_315fab2d
	Namespace: zm_devgui
	Checksum: 0x8B84BA27
	Offset: 0x2278
	Size: 0x2FF
	Parameters: 0
	Flags: None
*/
function function_315fab2d()
{
	/#
		level.zombie_devgui_gun = GetDvarString("Dev Block strings are not supported");
		for(;;)
		{
			wait(0.1);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = GetPlayers();
				if(players.size >= 1)
				{
					players[0] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.1);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = GetPlayers();
				if(players.size >= 2)
				{
					players[1] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.1);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = GetPlayers();
				if(players.size >= 3)
				{
					players[2] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.1);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = GetPlayers();
				if(players.size >= 4)
				{
					players[3] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
		}
	#/
}

/*
	Name: zombie_weapon_devgui_think
	Namespace: zm_devgui
	Checksum: 0x22C61E2A
	Offset: 0x2580
	Size: 0x19F
	Parameters: 0
	Flags: None
*/
function zombie_weapon_devgui_think()
{
	/#
		level.zombie_devgui_gun = GetDvarString("Dev Block strings are not supported");
		level.zombie_devgui_att = GetDvarString("Dev Block strings are not supported");
		for(;;)
		{
			wait(0.25);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				Array::thread_all(GetPlayers(), &zombie_devgui_weapon_give, level.zombie_devgui_gun);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.25);
			att = GetDvarString("Dev Block strings are not supported");
			if(isdefined(att) && att.size > 0)
			{
				level.zombie_devgui_att = att;
				Array::thread_all(GetPlayers(), &zombie_devgui_attachment_give, level.zombie_devgui_att);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
		}
	#/
}

/*
	Name: zombie_devgui_weapon_give
	Namespace: zm_devgui
	Checksum: 0xB9D8DA6D
	Offset: 0x2728
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function zombie_devgui_weapon_give(weapon_name)
{
	/#
		weapon = GetWeapon(weapon_name);
		self zm_weapons::weapon_give(weapon, zm_weapons::is_weapon_upgraded(weapon), 0);
	#/
}

/*
	Name: zombie_devgui_attachment_give
	Namespace: zm_devgui
	Checksum: 0x7EF518A7
	Offset: 0x2798
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function zombie_devgui_attachment_give(attachment)
{
	/#
		weapon = self GetCurrentWeapon();
		weapon = GetWeapon(weapon.rootweapon.name, attachment);
		self zm_weapons::weapon_give(weapon, zm_weapons::is_weapon_upgraded(weapon), 0);
	#/
}

/*
	Name: devgui_add_ability
	Namespace: zm_devgui
	Checksum: 0x48BBE3E2
	Offset: 0x2838
	Size: 0x163
	Parameters: 5
	Flags: None
*/
function devgui_add_ability(name, upgrade_active_func, stat_name, stat_desired_value, game_end_reset_if_not_achieved)
{
	/#
		online_game = SessionModeIsOnlineGame();
		if(!online_game)
		{
			return;
		}
		if(!(isdefined(level.devgui_watch_abilities) && level.devgui_watch_abilities))
		{
			cmd = "Dev Block strings are not supported";
			AddDebugCommand(cmd);
			cmd = "Dev Block strings are not supported";
			AddDebugCommand(cmd);
			level thread zombie_ability_devgui_think();
			level.devgui_watch_abilities = 1;
		}
		cmd = "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + name + "Dev Block strings are not supported";
		AddDebugCommand(cmd);
		cmd = "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + name + "Dev Block strings are not supported";
		AddDebugCommand(cmd);
	#/
}

/*
	Name: zombie_devgui_ability_give
	Namespace: zm_devgui
	Checksum: 0x2F6F8013
	Offset: 0x29A8
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function zombie_devgui_ability_give(name)
{
	/#
		pers_upgrade = level.pers_upgrades[name];
		if(isdefined(pers_upgrade))
		{
			for(i = 0; i < pers_upgrade.stat_names.size; i++)
			{
				stat_name = pers_upgrade.stat_names[i];
				stat_value = pers_upgrade.stat_desired_values[i];
				self zm_stats::set_global_stat(stat_name, stat_value);
				self.pers_upgrade_force_test = 1;
			}
		}
	#/
}

/*
	Name: zombie_devgui_ability_take
	Namespace: zm_devgui
	Checksum: 0xE2044081
	Offset: 0x2A88
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function zombie_devgui_ability_take(name)
{
	/#
		pers_upgrade = level.pers_upgrades[name];
		if(isdefined(pers_upgrade))
		{
			for(i = 0; i < pers_upgrade.stat_names.size; i++)
			{
				stat_name = pers_upgrade.stat_names[i];
				stat_value = 0;
				self zm_stats::set_global_stat(stat_name, stat_value);
				self.pers_upgrade_force_test = 1;
			}
		}
	#/
}

/*
	Name: zombie_ability_devgui_think
	Namespace: zm_devgui
	Checksum: 0xB96A3E57
	Offset: 0x2B58
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function zombie_ability_devgui_think()
{
	/#
		level.zombie_devgui_give_ability = GetDvarString("Dev Block strings are not supported");
		level.zombie_devgui_take_ability = GetDvarString("Dev Block strings are not supported");
		for(;;)
		{
			wait(0.25);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(!isdefined(level.zombie_devgui_give_ability) || level.zombie_devgui_give_ability != cmd)
			{
				if(cmd == "Dev Block strings are not supported")
				{
					level flag::set("Dev Block strings are not supported");
				}
				else if(cmd == "Dev Block strings are not supported")
				{
					level flag::clear("Dev Block strings are not supported");
				}
				else
				{
					level.zombie_devgui_give_ability = cmd;
					Array::thread_all(GetPlayers(), &zombie_devgui_ability_give, level.zombie_devgui_give_ability);
				}
			}
			wait(0.25);
			cmd = GetDvarString("Dev Block strings are not supported");
			if(!isdefined(level.zombie_devgui_take_ability) || level.zombie_devgui_take_ability != cmd)
			{
				level.zombie_devgui_take_ability = cmd;
				Array::thread_all(GetPlayers(), &zombie_devgui_ability_take, level.zombie_devgui_take_ability);
			}
		}
	#/
}

/*
	Name: zombie_healthbar
	Namespace: zm_devgui
	Checksum: 0x2EBCC66C
	Offset: 0x2D28
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function zombie_healthbar(pos, dsquared)
{
	/#
		if(DistanceSquared(pos, self.origin) > dsquared)
		{
			return;
		}
		rate = 1;
		if(isdefined(self.maxhealth))
		{
			rate = self.health / self.maxhealth;
		}
		color = (1 - rate, rate, 0);
		text = "Dev Block strings are not supported" + Int(self.health);
		print3d(self.origin + (0, 0, 0), text, color, 1, 0.5, 1);
	#/
}

/*
	Name: devgui_zombie_healthbar
	Namespace: zm_devgui
	Checksum: 0xD6449724
	Offset: 0x2E30
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function devgui_zombie_healthbar()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") == 1)
			{
				lp = GetPlayers()[0];
				zombies = GetAISpeciesArray("Dev Block strings are not supported", "Dev Block strings are not supported");
				if(isdefined(zombies))
				{
					foreach(zombie in zombies)
					{
						zombie zombie_healthbar(lp.origin, 360000);
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: zombie_devgui_watch_input
	Namespace: zm_devgui
	Checksum: 0x6A616DA9
	Offset: 0x2F70
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function zombie_devgui_watch_input()
{
	/#
		level flag::wait_till("Dev Block strings are not supported");
		wait(1);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			players[i] thread watch_debug_input();
		}
	#/
}

/*
	Name: damage_player
	Namespace: zm_devgui
	Checksum: 0x1E1E5523
	Offset: 0x3008
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function damage_player()
{
	/#
		self DisableInvulnerability();
		self DoDamage(self.health / 2, self.origin);
	#/
}

/*
	Name: kill_player
	Namespace: zm_devgui
	Checksum: 0xDEA01D12
	Offset: 0x3058
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function kill_player()
{
	/#
		self DisableInvulnerability();
		death_from = (RandomFloatRange(-20, 20), RandomFloatRange(-20, 20), RandomFloatRange(-20, 20));
		self DoDamage(self.health + 666, self.origin + death_from);
	#/
}

/*
	Name: force_drink
	Namespace: zm_devgui
	Checksum: 0x750309FF
	Offset: 0x3100
	Size: 0x273
	Parameters: 0
	Flags: None
*/
function force_drink()
{
	/#
		wait(0.01);
		LEAN = self AllowLean(0);
		ADS = self AllowAds(0);
		sprint = self AllowSprint(0);
		crouch = self AllowCrouch(1);
		prone = self AllowProne(0);
		melee = self AllowMelee(0);
		self zm_utility::increment_is_drinking();
		orgweapon = self GetCurrentWeapon();
		build_weapon = GetWeapon("Dev Block strings are not supported");
		self GiveWeapon(build_weapon);
		self SwitchToWeapon(build_weapon);
		self.build_time = self.useTime;
		self.build_start_time = GetTime();
		wait(2);
		self zm_weapons::switch_back_primary_weapon(orgweapon);
		self TakeWeapon(build_weapon);
		if(isdefined(self.IS_DRINKING) && self.IS_DRINKING)
		{
			self zm_utility::decrement_is_drinking();
		}
		self AllowLean(LEAN);
		self AllowAds(ADS);
		self AllowSprint(sprint);
		self AllowProne(prone);
		self AllowCrouch(crouch);
		self AllowMelee(melee);
	#/
}

/*
	Name: zombie_devgui_dpad_none
	Namespace: zm_devgui
	Checksum: 0x934A27F1
	Offset: 0x3380
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_dpad_none()
{
	/#
		self thread watch_debug_input();
	#/
}

/*
	Name: zombie_devgui_dpad_death
	Namespace: zm_devgui
	Checksum: 0x157772C6
	Offset: 0x33A8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_dpad_death()
{
	/#
		self thread watch_debug_input(&kill_player);
	#/
}

/*
	Name: zombie_devgui_dpad_damage
	Namespace: zm_devgui
	Checksum: 0xFBDE5089
	Offset: 0x33E0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_dpad_damage()
{
	/#
		self thread watch_debug_input(&damage_player);
	#/
}

/*
	Name: zombie_devgui_dpad_changeweapon
	Namespace: zm_devgui
	Checksum: 0xDF9F2BC2
	Offset: 0x3418
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_dpad_changeweapon()
{
	/#
		self thread watch_debug_input(&force_drink);
	#/
}

/*
	Name: watch_debug_input
	Namespace: zm_devgui
	Checksum: 0x3F9F83DD
	Offset: 0x3450
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function watch_debug_input(callback)
{
	/#
		self endon("disconnect");
		self notify("watch_debug_input");
		self endon("watch_debug_input");
		level.devgui_dpad_watch = 0;
		if(isdefined(callback))
		{
			level.devgui_dpad_watch = 1;
			while(self ActionSlotTwoButtonPressed())
			{
				self thread [[callback]]();
				while(self ActionSlotTwoButtonPressed())
				{
					wait(0.05);
				}
				wait(0.05);
			}
		}
	#/
}

/*
	Name: zombie_devgui_think
	Namespace: zm_devgui
	Checksum: 0x6FD74E0
	Offset: 0x3508
	Size: 0x221F
	Parameters: 0
	Flags: None
*/
function zombie_devgui_think()
{
	/#
		level notify("zombie_devgui_think");
		level endon("zombie_devgui_think");
		for(;;)
		{
			cmd = GetDvarString("Dev Block strings are not supported");
			switch(cmd)
			{
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					Array::thread_all(players, &zombie_devgui_give_money);
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_give_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_give_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_give_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_give_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					Array::thread_all(players, &zombie_devgui_take_money);
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_take_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_take_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_take_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_take_money();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread function_e14e8c13(1000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread function_e14e8c13(1000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread function_e14e8c13(1000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread function_e14e8c13(1000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread function_e14e8c13(10000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread function_e14e8c13(10000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread function_e14e8c13(10000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread function_e14e8c13(10000);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_give_health);
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_give_health();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_give_health();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_give_health();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_give_health();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &function_6b00a5a8);
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread function_6b00a5a8();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread function_6b00a5a8();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread function_6b00a5a8();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread function_6b00a5a8();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_toggle_ammo);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_toggle_ignore);
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(undefined, 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(undefined, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(0, 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(0, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(1, 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(1, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(2, 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(2, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(3, 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_invulnerable(3, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_revive);
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_revive();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_revive();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_revive();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_revive();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_kill();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_kill();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_kill();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					players = GetPlayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_kill();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					player = util::getHostPlayer();
					team = player.team;
					devgui_bot_spawn(team);
					break;
				}
				case "Dev Block strings are not supported":
				{
					level.solo_lives_given = 0;
				}
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				{
					zombie_devgui_give_perk(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_af69dfbe(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_3df1388a(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_f976401d(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_a888b17c(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_7743668b(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_7d8af9ea(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_7d8af9ea(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_54b2ecf8(cmd);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_turn_player();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_turn_player(0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_turn_player(1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_turn_player(2);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_turn_player(3);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_debug_pers(0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_debug_pers(1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_debug_pers(2);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_debug_pers(3);
					break;
				}
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				{
					zombie_devgui_give_powerup(cmd, 1);
					break;
				}
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				case "Dev Block strings are not supported":
				{
					zombie_devgui_give_powerup(GetSubStr(cmd, 5), 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_goto_round(GetDvarInt("Dev Block strings are not supported"));
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_goto_round(level.round_number + 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_goto_round(level.round_number - 1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &function_4619dfa7);
					break;
				}
				case "Dev Block strings are not supported":
				{
					if(isdefined(level.chest_accessed))
					{
						level notify("devgui_chest_end_monitor");
						level.chest_accessed = 100;
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					if(isdefined(level.chest_accessed))
					{
						level thread zombie_devgui_chest_never_move();
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_preserve_turbines);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_equipment_stays_healthy);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_disown_equipment);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &function_ad4b0372, GetWeapon("Dev Block strings are not supported"));
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &function_ad4b0372, GetWeapon("Dev Block strings are not supported"));
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_give_frags);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_give_sticky);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_give_monkey);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &function_64c58d19);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &function_1e20cc53);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_give_dolls);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_give_emp_bomb);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_dog_round(GetDvarInt("Dev Block strings are not supported"));
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_dog_round_skip();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_dump_zombie_vars();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_pack_current_weapon();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_9e5bfd9d();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_435ea700();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_525facc6();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_935f6cc2();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_d8064278();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_unpack_current_weapon();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_2306f73c();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_5da1c3cd();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_6afc4c2f();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_9b4ea903();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_4d2e8278();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_ce561484();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_reopt_current_weapon();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_take_weapons(1);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_take_weapons(0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_take_weapon();
					break;
				}
				case "Dev Block strings are not supported":
				{
					level flag::set("Dev Block strings are not supported");
					level clientfield::set("Dev Block strings are not supported", 0);
					power_trigs = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
					foreach(trig in power_trigs)
					{
						if(isdefined(trig.script_int))
						{
							level flag::set("Dev Block strings are not supported" + trig.script_int);
							level clientfield::set("Dev Block strings are not supported", trig.script_int);
						}
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					level flag::clear("Dev Block strings are not supported");
					level clientfield::set("Dev Block strings are not supported", 0);
					power_trigs = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
					foreach(trig in power_trigs)
					{
						if(isdefined(trig.script_int))
						{
							level flag::clear("Dev Block strings are not supported" + trig.script_int);
							level clientfield::set("Dev Block strings are not supported", trig.script_int);
						}
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_dpad_none);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_dpad_damage);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_dpad_death);
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &zombie_devgui_dpad_changeweapon);
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_director_easy();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_open_sesame();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_allow_fog();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_disable_kill_thread_toggle();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_check_kill_thread_every_frame_toggle();
					break;
				}
				case "Dev Block strings are not supported":
				{
					zombie_devgui_kill_thread_test_mode_toggle();
					break;
				}
				case "Dev Block strings are not supported":
				{
					level notify("zombie_failsafe_debug_flush", isdefined(level.zombie_weapons[GetWeapon(GetDvarString("Dev Block strings are not supported"))]));
					break;
				}
				case "Dev Block strings are not supported":
				{
					level thread rat::function_1601ebff(0, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					devgui_zombie_spawn();
					break;
				}
				case "Dev Block strings are not supported":
				{
					devgui_all_spawn();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_b7778ea5();
					break;
				}
				case "Dev Block strings are not supported":
				{
					devgui_toggle_show_spawn_locations();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_df684f6();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_46ba1b5d();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_364ed1b9();
					break;
				}
				case "Dev Block strings are not supported":
				{
					Array::thread_all(GetPlayers(), &devgui_debug_hud);
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_39e3e21e();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_13d8ea87();
					break;
				}
				case "Dev Block strings are not supported":
				{
					thread function_1acc8e35();
					break;
				}
				case "Dev Block strings are not supported":
				{
					function_eec2d58b();
					break;
				}
				case "Dev Block strings are not supported":
				{
					break;
				}
				case default:
				{
					if(isdefined(level.custom_devgui))
					{
						if(IsArray(level.custom_devgui))
						{
							foreach(Devgui in level.custom_devgui)
							{
								b_result = [[Devgui]](cmd);
								if(isdefined(b_result) && b_result)
								{
									break;
								}
							}
						}
						else
						{
							[[level.custom_devgui]](cmd);
						}
					}
					break;
				}
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: function_4acecab5
	Namespace: zm_devgui
	Checksum: 0x8076BAF9
	Offset: 0x5730
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function function_4acecab5(callback)
{
	/#
		if(isdefined(level.custom_devgui))
		{
			if(!IsArray(level.custom_devgui))
			{
				var_4f9fbf81 = level.custom_devgui;
				level.custom_devgui = [];
				if(!isdefined(level.custom_devgui))
				{
					level.custom_devgui = [];
				}
				else if(!IsArray(level.custom_devgui))
				{
					level.custom_devgui = Array(level.custom_devgui);
				}
				level.custom_devgui[level.custom_devgui.size] = var_4f9fbf81;
			}
		}
		else
		{
			level.custom_devgui = [];
		}
		if(!isdefined(level.custom_devgui))
		{
			level.custom_devgui = [];
		}
		else if(!IsArray(level.custom_devgui))
		{
			level.custom_devgui = Array(level.custom_devgui);
		}
		level.custom_devgui[level.custom_devgui.size] = callback;
	#/
}

/*
	Name: devgui_all_spawn
	Namespace: zm_devgui
	Checksum: 0x833924A5
	Offset: 0x5878
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function devgui_all_spawn()
{
	/#
		player = util::getHostPlayer();
		devgui_bot_spawn(player.team);
		wait(0.1);
		devgui_bot_spawn(player.team);
		wait(0.1);
		devgui_bot_spawn(player.team);
		wait(0.1);
		zombie_devgui_goto_round(8);
	#/
}

/*
	Name: devgui_toggle_show_spawn_locations
	Namespace: zm_devgui
	Checksum: 0xDDEFFC9
	Offset: 0x5938
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function devgui_toggle_show_spawn_locations()
{
	/#
		if(!isdefined(level.toggle_show_spawn_locations))
		{
			level.toggle_show_spawn_locations = 1;
		}
		else
		{
			level.toggle_show_spawn_locations = !level.toggle_show_spawn_locations;
		}
	#/
}

/*
	Name: function_df684f6
	Namespace: zm_devgui
	Checksum: 0xB4EE3E52
	Offset: 0x5978
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_df684f6()
{
	/#
		if(!isdefined(level.var_2e8ab4b9))
		{
			level.var_2e8ab4b9 = 1;
		}
		else
		{
			level.var_2e8ab4b9 = !level.var_2e8ab4b9;
		}
	#/
}

/*
	Name: devgui_zombie_spawn
	Namespace: zm_devgui
	Checksum: 0x809796AD
	Offset: 0x59B8
	Size: 0x1F9
	Parameters: 0
	Flags: None
*/
function devgui_zombie_spawn()
{
	/#
		player = GetPlayers()[0];
		spawnerName = undefined;
		spawnerName = "Dev Block strings are not supported";
		direction = player getPlayerAngles();
		direction_vec = AnglesToForward(direction);
		eye = player GetEye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		guy = undefined;
		spawners = GetEntArray(spawnerName, "Dev Block strings are not supported");
		spawner = spawners[0];
		guy = zombie_utility::spawn_zombie(spawner);
		if(isdefined(guy))
		{
			guy.script_string = "Dev Block strings are not supported";
			wait(0.5);
			guy ForceTeleport(trace["Dev Block strings are not supported"], player.angles + VectorScale((0, 1, 0), 180));
		}
		return guy;
	#/
}

/*
	Name: function_b7778ea5
	Namespace: zm_devgui
	Checksum: 0x5B569DE
	Offset: 0x5BC0
	Size: 0x1E9
	Parameters: 0
	Flags: None
*/
function function_b7778ea5()
{
	/#
		zombies = zombie_utility::get_round_enemy_array();
		foreach(zombie in zombies)
		{
			gib_style = [];
			gib_style[gib_style.size] = "Dev Block strings are not supported";
			gib_style[gib_style.size] = "Dev Block strings are not supported";
			gib_style[gib_style.size] = "Dev Block strings are not supported";
			gib_style = zombie_death::randomize_array(gib_style);
			zombie.a.gib_ref = gib_style[0];
			zombie.missingLegs = 1;
			zombie AllowedStances("Dev Block strings are not supported");
			zombie setPhysParams(15, 0, 24);
			zombie AllowPitchAngle(1);
			zombie SetPitchOrient();
			health = zombie.health;
			health = health * 0.1;
			zombie thread zombie_death::do_gib();
		}
	#/
}

/*
	Name: devgui_bot_spawn
	Namespace: zm_devgui
	Checksum: 0xA122D596
	Offset: 0x5DB8
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function devgui_bot_spawn(team)
{
	/#
		player = util::getHostPlayer();
		direction = player getPlayerAngles();
		direction_vec = AnglesToForward(direction);
		eye = player GetEye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		direction_vec = player.origin - trace["Dev Block strings are not supported"];
		direction = VectorToAngles(direction_vec);
		bot = AddTestClient();
		if(!isdefined(bot))
		{
			println("Dev Block strings are not supported");
			return;
		}
		bot.pers["Dev Block strings are not supported"] = 1;
		bot.equipment_enabled = 0;
		bot demo::reset_actor_bookmark_kill_times();
		bot.team = "Dev Block strings are not supported";
		bot._player_entnum = bot GetEntityNumber();
		yaw = direction[1];
		bot thread devgui_bot_spawn_think(trace["Dev Block strings are not supported"], yaw);
	#/
}

/*
	Name: devgui_bot_spawn_think
	Namespace: zm_devgui
	Checksum: 0x146C070
	Offset: 0x6010
	Size: 0x7F
	Parameters: 2
	Flags: None
*/
function devgui_bot_spawn_think(origin, yaw)
{
	/#
		self endon("disconnect");
		for(;;)
		{
			self waittill("spawned_player");
			self SetOrigin(origin);
			angles = (0, yaw, 0);
			self SetPlayerAngles(angles);
		}
	#/
}

/*
	Name: zombie_devgui_open_sesame
	Namespace: zm_devgui
	Checksum: 0xF23439C6
	Offset: 0x6098
	Size: 0x38B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_open_sesame()
{
	/#
		SetDvar("Dev Block strings are not supported", 1);
		level flag::set("Dev Block strings are not supported");
		level clientfield::set("Dev Block strings are not supported", 0);
		power_trigs = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		foreach(trig in power_trigs)
		{
			if(isdefined(trig.script_int))
			{
				level flag::set("Dev Block strings are not supported" + trig.script_int);
				level clientfield::set("Dev Block strings are not supported", trig.script_int);
			}
		}
		players = GetPlayers();
		Array::thread_all(players, &zombie_devgui_give_money);
		zombie_doors = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		for(i = 0; i < zombie_doors.size; i++)
		{
			zombie_doors[i] notify("trigger", players[0]);
			if(isdefined(zombie_doors[i].power_door_ignore_flag_wait) && zombie_doors[i].power_door_ignore_flag_wait)
			{
				zombie_doors[i] notify("power_on");
			}
			wait(0.05);
		}
		zombie_airlock_doors = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		for(i = 0; i < zombie_airlock_doors.size; i++)
		{
			zombie_airlock_doors[i] notify("trigger", players[0]);
			wait(0.05);
		}
		zombie_debris = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		for(i = 0; i < zombie_debris.size; i++)
		{
			if(isdefined(zombie_debris[i]))
			{
				zombie_debris[i] notify("trigger", players[0]);
			}
			wait(0.05);
		}
		level notify("open_sesame");
		wait(1);
		SetDvar("Dev Block strings are not supported", 0);
	#/
}

/*
	Name: any_player_in_noclip
	Namespace: zm_devgui
	Checksum: 0x948D7F16
	Offset: 0x6430
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function any_player_in_noclip()
{
	/#
		foreach(player in GetPlayers())
		{
			if(player IsInMoveMode("Dev Block strings are not supported", "Dev Block strings are not supported"))
			{
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: diable_fog_in_noclip
	Namespace: zm_devgui
	Checksum: 0xE69E3A05
	Offset: 0x64F0
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function diable_fog_in_noclip()
{
	/#
		level.fog_disabled_in_noclip = 1;
		level endon("allowfoginnoclip");
		level flag::wait_till("Dev Block strings are not supported");
		while(1)
		{
			while(!any_player_in_noclip())
			{
				wait(1);
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			if(isdefined(level.culldist))
			{
				setculldist(0);
			}
			while(any_player_in_noclip())
			{
				wait(1);
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			if(isdefined(level.culldist))
			{
				setculldist(level.culldist);
			}
		}
	#/
}

/*
	Name: zombie_devgui_allow_fog
	Namespace: zm_devgui
	Checksum: 0x9C47BC0F
	Offset: 0x6648
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_allow_fog()
{
	/#
		if(isdefined(level.fog_disabled_in_noclip) && level.fog_disabled_in_noclip)
		{
			level notify("allowfoginnoclip");
			level.fog_disabled_in_noclip = 0;
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		else
		{
			thread diable_fog_in_noclip();
		}
	#/
}

/*
	Name: zombie_devgui_give_money
	Namespace: zm_devgui
	Checksum: 0xC344FED
	Offset: 0x66E0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_money()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		self zm_score::add_to_player_score(100000);
	#/
}

/*
	Name: zombie_devgui_take_money
	Namespace: zm_devgui
	Checksum: 0x9679E5F
	Offset: 0x6788
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function zombie_devgui_take_money()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		if(self.score > 100)
		{
			self zm_score::player_reduce_points("Dev Block strings are not supported");
		}
		else
		{
			self zm_score::player_reduce_points("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_e14e8c13
	Namespace: zm_devgui
	Checksum: 0x1E3E20C3
	Offset: 0x6858
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_e14e8c13(amount)
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		self AddRankXp("Dev Block strings are not supported", self.currentWeapon, undefined, undefined, 1, amount / 50);
	#/
}

/*
	Name: zombie_devgui_turn_player
	Namespace: zm_devgui
	Checksum: 0x7DB63DC1
	Offset: 0x6918
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function zombie_devgui_turn_player(index)
{
	/#
		players = GetPlayers();
		if(!isdefined(index) || index >= players.size)
		{
			player = players[0];
		}
		else
		{
			player = players[index];
		}
		/#
			Assert(isdefined(player));
		#/
		/#
			Assert(isPlayer(player));
		#/
		/#
			Assert(isalive(player));
		#/
		level.devcheater = 1;
		if(player hasPerk("Dev Block strings are not supported"))
		{
			println("Dev Block strings are not supported");
			player zm_turned::turn_to_human();
		}
		else
		{
			println("Dev Block strings are not supported");
			player zm_turned::turn_to_zombie();
		}
	#/
}

/*
	Name: zombie_devgui_debug_pers
	Namespace: zm_devgui
	Checksum: 0x829C7890
	Offset: 0x6AA8
	Size: 0x383
	Parameters: 1
	Flags: None
*/
function zombie_devgui_debug_pers(index)
{
	/#
		players = GetPlayers();
		if(!isdefined(index) || index >= players.size)
		{
			player = players[0];
		}
		else
		{
			player = players[index];
		}
		/#
			Assert(isdefined(player));
		#/
		/#
			Assert(isPlayer(player));
		#/
		/#
			Assert(isalive(player));
		#/
		level.devcheater = 1;
		println("Dev Block strings are not supported");
		println("Dev Block strings are not supported" + level.pers_upgrades_keys.size + "Dev Block strings are not supported");
		for(pers_upgrade_index = 0; pers_upgrade_index < level.pers_upgrades_keys.size; pers_upgrade_index++)
		{
			name = level.pers_upgrades_keys[pers_upgrade_index];
			println(pers_upgrade_index + "Dev Block strings are not supported" + name);
			pers_upgrade = level.pers_upgrades[name];
			for(i = 0; i < pers_upgrade.stat_names.size; i++)
			{
				stat_name = pers_upgrade.stat_names[i];
				stat_desired_value = pers_upgrade.stat_desired_values[i];
				player_current_stat_value = player zm_stats::get_global_stat(stat_name);
				println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + stat_name);
				println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + stat_desired_value);
				println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + player_current_stat_value);
			}
			if(isdefined(player.pers_upgrades_awarded[name]) && player.pers_upgrades_awarded[name])
			{
				println("Dev Block strings are not supported" + name);
				continue;
			}
			println("Dev Block strings are not supported" + name);
		}
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: function_4619dfa7
	Namespace: zm_devgui
	Checksum: 0xEFAACBE
	Offset: 0x6E38
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function function_4619dfa7()
{
	/#
		entnum = self GetEntityNumber();
		Chest = level.chests[level.chest_index];
		origin = Chest.zbarrier.origin;
		FORWARD = AnglesToForward(Chest.zbarrier.angles);
		right = AnglesToRight(Chest.zbarrier.angles);
		var_d9191ee9 = VectorToAngles(right);
		var_f2857d87 = origin - 48 * right;
		switch(entnum)
		{
			case 0:
			{
				var_f2857d87 = var_f2857d87 + 16 * right;
				break;
			}
			case 1:
			{
				var_f2857d87 = var_f2857d87 + 16 * FORWARD;
				break;
			}
			case 2:
			{
				var_f2857d87 = var_f2857d87 - 16 * right;
				break;
			}
			case 3:
			{
				var_f2857d87 = var_f2857d87 - 16 * FORWARD;
				break;
			}
		}
		self SetOrigin(var_f2857d87);
		self SetPlayerAngles(var_d9191ee9);
	#/
}

/*
	Name: zombie_devgui_cool_jetgun
	Namespace: zm_devgui
	Checksum: 0xE50B7B5C
	Offset: 0x7018
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function zombie_devgui_cool_jetgun()
{
	/#
		if(isdefined(level.zm_devgui_jetgun_never_overheat))
		{
			self thread [[level.zm_devgui_jetgun_never_overheat]]();
		}
	#/
}

/*
	Name: zombie_devgui_preserve_turbines
	Namespace: zm_devgui
	Checksum: 0xE2AA2F6E
	Offset: 0x7048
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function zombie_devgui_preserve_turbines()
{
	/#
		self endon("disconnect");
		self notify("preserve_turbines");
		self endon("preserve_turbines");
		if(!(isdefined(self.preserving_turbines) && self.preserving_turbines))
		{
			self.preserving_turbines = 1;
			while(1)
			{
				self.turbine_health = 1200;
				wait(1);
			}
		}
		self.preserving_turbines = 0;
	#/
}

/*
	Name: zombie_devgui_equipment_stays_healthy
	Namespace: zm_devgui
	Checksum: 0x7C28D7FB
	Offset: 0x70C8
	Size: 0x15F
	Parameters: 0
	Flags: None
*/
function zombie_devgui_equipment_stays_healthy()
{
	/#
		self endon("disconnect");
		self notify("preserve_equipment");
		self endon("preserve_equipment");
		if(!(isdefined(self.preserving_equipment) && self.preserving_equipment))
		{
			self.preserving_equipment = 1;
			while(1)
			{
				self.equipment_damage = [];
				self.shieldDamageTaken = 0;
				if(isdefined(level.destructible_equipment))
				{
					foreach(equip in level.destructible_equipment)
					{
						if(isdefined(equip))
						{
							equip.shieldDamageTaken = 0;
							equip.damage = 0;
							equip.headchopper_kills = 0;
							equip.springpad_kills = 0;
							equip.subwoofer_kills = 0;
						}
					}
				}
				wait(0.1);
			}
		}
		self.preserving_equipment = 0;
	#/
}

/*
	Name: zombie_devgui_disown_equipment
	Namespace: zm_devgui
	Checksum: 0x633C714B
	Offset: 0x7230
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function zombie_devgui_disown_equipment()
{
	/#
		self.deployed_equipment = [];
	#/
}

/*
	Name: zombie_devgui_equipment_give
	Namespace: zm_devgui
	Checksum: 0x329E5679
	Offset: 0x7250
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function zombie_devgui_equipment_give(equipment)
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(zm_equipment::is_included(equipment))
		{
			self zm_equipment::buy(equipment);
		}
	#/
}

/*
	Name: function_ad4b0372
	Namespace: zm_devgui
	Checksum: 0x5E236D4E
	Offset: 0x7310
	Size: 0x13D
	Parameters: 1
	Flags: None
*/
function function_ad4b0372(weapon)
{
	/#
		self endon("disconnect");
		self notify("give_planted_grenade_thread");
		self endon("give_planted_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(!zm_utility::is_placeable_mine(weapon))
		{
			return;
		}
		if(isdefined(self zm_utility::get_player_placeable_mine()))
		{
			self TakeWeapon(self zm_utility::get_player_placeable_mine());
		}
		self thread zm_placeable_mine::setup_for_player(weapon);
		while(1)
		{
			self giveMaxAmmo(weapon);
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_give_claymores
	Namespace: zm_devgui
	Checksum: 0xB131C463
	Offset: 0x7458
	Size: 0x14D
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_claymores()
{
	/#
		self endon("disconnect");
		self notify("give_planted_grenade_thread");
		self endon("give_planted_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_placeable_mine()))
		{
			self TakeWeapon(self zm_utility::get_player_placeable_mine());
		}
		wpn_type = zm_placeable_mine::get_first_available();
		if(wpn_type != level.weaponNone)
		{
			self thread zm_placeable_mine::setup_for_player(wpn_type);
		}
		while(1)
		{
			self giveMaxAmmo(wpn_type);
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_give_lethal
	Namespace: zm_devgui
	Checksum: 0x104F9C84
	Offset: 0x75B0
	Size: 0x13D
	Parameters: 1
	Flags: None
*/
function zombie_devgui_give_lethal(weapon)
{
	/#
		self endon("disconnect");
		self notify("give_lethal_grenade_thread");
		self endon("give_lethal_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_lethal_grenade()))
		{
			self TakeWeapon(self zm_utility::get_player_lethal_grenade());
		}
		self GiveWeapon(weapon);
		self zm_utility::set_player_lethal_grenade(weapon);
		while(1)
		{
			self giveMaxAmmo(weapon);
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_give_frags
	Namespace: zm_devgui
	Checksum: 0x2D088871
	Offset: 0x76F8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_frags()
{
	/#
		zombie_devgui_give_lethal(GetWeapon("Dev Block strings are not supported"));
	#/
}

/*
	Name: zombie_devgui_give_sticky
	Namespace: zm_devgui
	Checksum: 0xC317352D
	Offset: 0x7738
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_sticky()
{
	/#
		zombie_devgui_give_lethal(GetWeapon("Dev Block strings are not supported"));
	#/
}

/*
	Name: zombie_devgui_give_monkey
	Namespace: zm_devgui
	Checksum: 0x99F040AA
	Offset: 0x7778
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_monkey()
{
	/#
		self endon("disconnect");
		self notify("give_tactical_grenade_thread");
		self endon("give_tactical_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self TakeWeapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_cymbal_monkey_give))
		{
			self [[level.zombiemode_devgui_cymbal_monkey_give]]();
			while(1)
			{
				self giveMaxAmmo(GetWeapon("Dev Block strings are not supported"));
				wait(1);
			}
		}
	#/
}

/*
	Name: function_64c58d19
	Namespace: zm_devgui
	Checksum: 0x3FE4DFD1
	Offset: 0x78B8
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function function_64c58d19()
{
	/#
		self endon("disconnect");
		self notify("give_tactical_grenade_thread");
		self endon("give_tactical_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self TakeWeapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_black_hole_bomb_give))
		{
			self [[level.zombiemode_devgui_black_hole_bomb_give]]();
			while(1)
			{
				self giveMaxAmmo(level.var_453e74a0);
				wait(1);
			}
		}
	#/
}

/*
	Name: function_1e20cc53
	Namespace: zm_devgui
	Checksum: 0x44978D04
	Offset: 0x79E8
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function function_1e20cc53()
{
	/#
		self endon("disconnect");
		self notify("give_tactical_grenade_thread");
		self endon("give_tactical_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self TakeWeapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_quantum_bomb_give))
		{
			self [[level.zombiemode_devgui_quantum_bomb_give]]();
			while(1)
			{
				self giveMaxAmmo(level.var_17bac01d);
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_give_dolls
	Namespace: zm_devgui
	Checksum: 0xD7B02818
	Offset: 0x7B18
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_dolls()
{
	/#
		self endon("disconnect");
		self notify("give_tactical_grenade_thread");
		self endon("give_tactical_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self TakeWeapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_nesting_dolls_give))
		{
			self [[level.zombiemode_devgui_nesting_dolls_give]]();
			while(1)
			{
				self giveMaxAmmo(level.var_21ae0b78);
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_give_emp_bomb
	Namespace: zm_devgui
	Checksum: 0x168406C
	Offset: 0x7C48
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_emp_bomb()
{
	/#
		self endon("disconnect");
		self notify("give_tactical_grenade_thread");
		self endon("give_tactical_grenade_thread");
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self TakeWeapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_emp_bomb_give))
		{
			self [[level.zombiemode_devgui_emp_bomb_give]]();
			while(1)
			{
				self giveMaxAmmo(GetWeapon("Dev Block strings are not supported"));
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_invulnerable
	Namespace: zm_devgui
	Checksum: 0xB2667B7F
	Offset: 0x7D88
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function zombie_devgui_invulnerable(playerIndex, onOff)
{
	/#
		players = GetPlayers();
		if(!isdefined(playerIndex))
		{
			for(i = 0; i < players.size; i++)
			{
				zombie_devgui_invulnerable(i, onOff);
			}
		}
		else if(players.size > playerIndex)
		{
			if(onOff)
			{
				players[playerIndex] EnableInvulnerability();
			}
			else
			{
				players[playerIndex] DisableInvulnerability();
			}
		}
	#/
}

/*
	Name: zombie_devgui_kill
	Namespace: zm_devgui
	Checksum: 0xCAA0AC9F
	Offset: 0x7E70
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_kill()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		self DisableInvulnerability();
		death_from = (RandomFloatRange(-20, 20), RandomFloatRange(-20, 20), RandomFloatRange(-20, 20));
		self DoDamage(self.health + 666, self.origin + death_from);
	#/
}

/*
	Name: zombie_devgui_toggle_ammo
	Namespace: zm_devgui
	Checksum: 0xBE8D35A7
	Offset: 0x7F88
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function zombie_devgui_toggle_ammo()
{
System.InvalidOperationException: Stack empty.
   at System.ThrowHelper.ThrowInvalidOperationException(ExceptionResource resource)
   at System.Collections.Generic.Stack`1.Pop()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: zombie_devgui_toggle_ignore
	Namespace: zm_devgui
	Checksum: 0x15CA9588
	Offset: 0x8180
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function zombie_devgui_toggle_ignore()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		if(!isdefined(self.var_b67d35de))
		{
			self.var_b67d35de = 0;
		}
		self.var_b67d35de = !self.var_b67d35de;
		if(self.var_b67d35de)
		{
			self zm_utility::increment_ignoreme();
		}
		else
		{
			self zm_utility::decrement_ignoreme();
		}
		if(self.ignoreme)
		{
			SetDvar("Dev Block strings are not supported", 0);
		}
	#/
}

/*
	Name: zombie_devgui_revive
	Namespace: zm_devgui
	Checksum: 0xBB822371
	Offset: 0x8288
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function zombie_devgui_revive()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		self RevivePlayer();
		self notify("stop_revive_trigger");
		if(isdefined(self.reviveTrigger))
		{
			self.reviveTrigger delete();
			self.reviveTrigger = undefined;
		}
		self AllowJump(1);
		self zm_laststand::set_ignoreme(0);
		self.laststand = undefined;
		self notify("player_revived", self);
	#/
}

/*
	Name: zombie_devgui_give_health
	Namespace: zm_devgui
	Checksum: 0xA745EF8E
	Offset: 0x83A8
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_health()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		self notify("devgui_health");
		self endon("devgui_health");
		self endon("disconnect");
		self endon("death");
		level.devcheater = 1;
		while(1)
		{
			self.maxhealth = 100000;
			self.health = 100000;
			self util::waittill_any("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(2);
		}
	#/
}

/*
	Name: function_6b00a5a8
	Namespace: zm_devgui
	Checksum: 0xD5BF64C4
	Offset: 0x84C8
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function function_6b00a5a8()
{
	/#
		/#
			Assert(isdefined(self));
		#/
		/#
			Assert(isPlayer(self));
		#/
		/#
			Assert(isalive(self));
		#/
		self notify("devgui_health");
		self endon("devgui_health");
		self endon("disconnect");
		self endon("death");
		level.devcheater = 1;
		while(1)
		{
			self.maxhealth = 10;
			self.health = 10;
			self util::waittill_any("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(2);
		}
	#/
}

/*
	Name: zombie_devgui_give_perk
	Namespace: zm_devgui
	Checksum: 0x149C56C3
	Offset: 0x85E0
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function zombie_devgui_give_perk(perk)
{
	/#
		vending_triggers = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		level.devcheater = 1;
		if(vending_triggers.size < 1)
		{
			return;
		}
		foreach(player in GetPlayers())
		{
			for(i = 0; i < vending_triggers.size; i++)
			{
				if(vending_triggers[i].script_noteworthy == perk)
				{
					vending_triggers[i] notify("trigger", player);
					break;
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: function_54b2ecf8
	Namespace: zm_devgui
	Checksum: 0xD64D3F60
	Offset: 0x8730
	Size: 0x1D1
	Parameters: 1
	Flags: None
*/
function function_54b2ecf8(cmd)
{
	/#
		vending_triggers = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		PERKS = [];
		for(i = 0; i < vending_triggers.size; i++)
		{
			perk = vending_triggers[i].script_noteworthy;
			if(isdefined(self.perk_purchased) && self.perk_purchased == perk)
			{
				continue;
			}
			PERKS[PERKS.size] = perk;
		}
		foreach(player in GetPlayers())
		{
			foreach(perk in PERKS)
			{
				perk_str = perk + "Dev Block strings are not supported";
				player notify(perk_str);
			}
		}
	#/
}

/*
	Name: function_af69dfbe
	Namespace: zm_devgui
	Checksum: 0xCB69F9E6
	Offset: 0x8910
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_af69dfbe(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_3df1388a
	Namespace: zm_devgui
	Checksum: 0x704D7A31
	Offset: 0x8948
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_3df1388a(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_f976401d
	Namespace: zm_devgui
	Checksum: 0x6638E0AC
	Offset: 0x8980
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_f976401d(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_a888b17c
	Namespace: zm_devgui
	Checksum: 0xECAB6C91
	Offset: 0x89B8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_a888b17c(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_7743668b
	Namespace: zm_devgui
	Checksum: 0x85C7891E
	Offset: 0x89F0
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_7743668b(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_7d8af9ea
	Namespace: zm_devgui
	Checksum: 0x98232765
	Offset: 0x8A28
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_7d8af9ea(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_c2cda548
	Namespace: zm_devgui
	Checksum: 0x4C5C50AF
	Offset: 0x8A60
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_c2cda548(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: zombie_devgui_give_powerup
	Namespace: zm_devgui
	Checksum: 0xBA0CE416
	Offset: 0x8A98
	Size: 0x233
	Parameters: 3
	Flags: None
*/
function zombie_devgui_give_powerup(powerup_name, now, origin)
{
	/#
		player = GetPlayers()[0];
		found = 0;
		level.devcheater = 1;
		if(isdefined(now) && !now)
		{
			for(i = 0; i < level.zombie_powerup_array.size; i++)
			{
				if(level.zombie_powerup_array[i] == powerup_name)
				{
					level.zombie_powerup_index = i;
					found = 1;
					break;
				}
			}
			if(!found)
			{
				return;
			}
			level.zombie_devgui_power = 1;
			level.zombie_vars["Dev Block strings are not supported"] = 1;
			level.powerup_drop_count = 0;
			return;
		}
		direction = player getPlayerAngles();
		direction_vec = AnglesToForward(direction);
		eye = player GetEye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		if(isdefined(origin))
		{
			level thread zm_powerups::specific_powerup_drop(powerup_name, origin);
		}
		else
		{
			level thread zm_powerups::specific_powerup_drop(powerup_name, trace["Dev Block strings are not supported"]);
		}
	#/
}

/*
	Name: function_9589a11f
	Namespace: zm_devgui
	Checksum: 0x309F0D12
	Offset: 0x8CD8
	Size: 0x1FB
	Parameters: 2
	Flags: None
*/
function function_9589a11f(powerup_name, now)
{
	/#
		player = self;
		found = 0;
		level.devcheater = 1;
		if(isdefined(now) && !now)
		{
			for(i = 0; i < level.zombie_powerup_array.size; i++)
			{
				if(level.zombie_powerup_array[i] == powerup_name)
				{
					level.zombie_powerup_index = i;
					found = 1;
					break;
				}
			}
			if(!found)
			{
				return;
			}
			level.zombie_devgui_power = 1;
			level.zombie_vars["Dev Block strings are not supported"] = 1;
			level.powerup_drop_count = 0;
			return;
		}
		direction = player getPlayerAngles();
		direction_vec = AnglesToForward(direction);
		eye = player GetEye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		level thread zm_powerups::specific_powerup_drop(powerup_name, trace["Dev Block strings are not supported"], undefined, undefined, undefined, player);
	#/
}

/*
	Name: zombie_devgui_goto_round
	Namespace: zm_devgui
	Checksum: 0x6B0A6AA6
	Offset: 0x8EE0
	Size: 0x185
	Parameters: 1
	Flags: None
*/
function zombie_devgui_goto_round(target_round)
{
	/#
		player = GetPlayers()[0];
		if(target_round < 1)
		{
			target_round = 1;
		}
		level.devcheater = 1;
		level.zombie_total = 0;
		zombie_utility::ai_calculate_health(target_round);
		zm::set_round_number(target_round - 1);
		level notify("kill_round");
		wait(1);
		zombies = GetAITeamArray(level.zombie_team);
		if(isdefined(zombies))
		{
			for(i = 0; i < zombies.size; i++)
			{
				if(isdefined(zombies[i].ignore_devgui_death) && zombies[i].ignore_devgui_death)
				{
					continue;
				}
				zombies[i] DoDamage(zombies[i].health + 666, zombies[i].origin);
			}
		}
	#/
}

/*
	Name: zombie_devgui_monkey_round
	Namespace: zm_devgui
	Checksum: 0x55BEAB9F
	Offset: 0x9070
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_monkey_round()
{
	/#
		if(isdefined(level.next_monkey_round))
		{
			zombie_devgui_goto_round(level.next_monkey_round);
		}
	#/
}

/*
	Name: zombie_devgui_thief_round
	Namespace: zm_devgui
	Checksum: 0x1E41250B
	Offset: 0x90A8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_thief_round()
{
	/#
		if(isdefined(level.next_thief_round))
		{
			zombie_devgui_goto_round(level.next_thief_round);
		}
	#/
}

/*
	Name: zombie_devgui_dog_round
	Namespace: zm_devgui
	Checksum: 0x8DE0D88B
	Offset: 0x90E0
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function zombie_devgui_dog_round(num_dogs)
{
	/#
		if(!isdefined(level.dogs_enabled) || !level.dogs_enabled)
		{
			return;
		}
		if(!isdefined(level.dog_rounds_enabled) || !level.dog_rounds_enabled)
		{
			return;
		}
		if(!isdefined(level.enemy_dog_spawns) || level.enemy_dog_spawns.size < 1)
		{
			return;
		}
		if(!level flag::get("Dev Block strings are not supported"))
		{
			SetDvar("Dev Block strings are not supported", num_dogs);
		}
		zombie_devgui_goto_round(level.round_number + 1);
	#/
}

/*
	Name: zombie_devgui_dog_round_skip
	Namespace: zm_devgui
	Checksum: 0x43B82AE4
	Offset: 0x91C8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_dog_round_skip()
{
	/#
		if(isdefined(level.next_dog_round))
		{
			zombie_devgui_goto_round(level.next_dog_round);
		}
	#/
}

/*
	Name: zombie_devgui_dump_zombie_vars
	Namespace: zm_devgui
	Checksum: 0x44B987D5
	Offset: 0x9200
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function zombie_devgui_dump_zombie_vars()
{
	/#
		if(!isdefined(level.zombie_vars))
		{
			return;
		}
		if(level.zombie_vars.size > 0)
		{
			println("Dev Block strings are not supported");
		}
		else
		{
			return;
		}
		var_names = getArrayKeys(level.zombie_vars);
		for(i = 0; i < level.zombie_vars.size; i++)
		{
			key = var_names[i];
			println(key + "Dev Block strings are not supported" + level.zombie_vars[key]);
		}
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: zombie_devgui_pack_current_weapon
	Namespace: zm_devgui
	Checksum: 0x82F9ACB8
	Offset: 0x9300
	Size: 0x195
	Parameters: 0
	Flags: None
*/
function zombie_devgui_pack_current_weapon()
{
	/#
		players = GetPlayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weap = players[i] GetCurrentWeapon();
				weapon = get_upgrade(weap.rootweapon);
				players[i] TakeWeapon(weap);
				weapon = players[i] zm_weapons::give_build_kit_weapon(weapon);
				players[i] thread AAT::remove(weapon);
				players[i] GiveStartAmmo(weapon);
				players[i] SwitchToWeapon(weapon);
			}
		}
	#/
}

/*
	Name: function_d8064278
	Namespace: zm_devgui
	Checksum: 0x7F17B085
	Offset: 0x94A0
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function function_d8064278()
{
	/#
		players = GetPlayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weap = players[i] GetCurrentWeapon();
				if(isdefined(level.aat_in_use) && level.aat_in_use && zm_weapons::weapon_supports_aat(weap))
				{
					players[i] thread AAT::acquire(weap);
				}
			}
		}
	#/
}

/*
	Name: zombie_devgui_unpack_current_weapon
	Namespace: zm_devgui
	Checksum: 0x17D3CF37
	Offset: 0x95B8
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
function zombie_devgui_unpack_current_weapon()
{
	/#
		players = GetPlayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weap = players[i] GetCurrentWeapon();
				weapon = zm_weapons::get_base_weapon(weap);
				players[i] TakeWeapon(weap);
				weapon = players[i] zm_weapons::give_build_kit_weapon(weapon);
				players[i] GiveStartAmmo(weapon);
				players[i] SwitchToWeapon(weapon);
			}
		}
	#/
}

/*
	Name: function_3ec0de8d
	Namespace: zm_devgui
	Checksum: 0xB4FD818F
	Offset: 0x9730
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function function_3ec0de8d(itemIndex, XP)
{
	/#
		if(!itemIndex || !level.onlineGame)
		{
			return;
		}
		if(0 > XP)
		{
			XP = 0;
		}
		self SetDStat("Dev Block strings are not supported", itemIndex, "Dev Block strings are not supported", XP);
	#/
}

/*
	Name: function_949d6013
	Namespace: zm_devgui
	Checksum: 0xE3D71C52
	Offset: 0x97B0
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function function_949d6013(weapon)
{
	/#
		var_1121268 = [];
		table = popups::function_d661ce6();
		weapon_name = weapon.rootweapon.name;
		for(i = 0; i < 15; i++)
		{
			var_d4b6b0ab = tableLookup(table, 2, weapon_name, 0, i, 1);
			if("Dev Block strings are not supported" == var_d4b6b0ab)
			{
				break;
			}
			var_1121268[i] = Int(var_d4b6b0ab);
		}
		return var_1121268;
	#/
}

/*
	Name: function_718c64af
	Namespace: zm_devgui
	Checksum: 0xC8132C5F
	Offset: 0x98B8
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function function_718c64af(weapon, var_2e8a2b5e)
{
	/#
		XP = 0;
		var_1121268 = function_949d6013(weapon);
		if(var_1121268.size)
		{
			XP = var_1121268[var_1121268.size - 1];
			if(var_2e8a2b5e < var_1121268.size)
			{
				XP = var_1121268[var_2e8a2b5e];
			}
		}
		return XP;
	#/
}

/*
	Name: function_e9906f08
	Namespace: zm_devgui
	Checksum: 0x1B99EC5C
	Offset: 0x9950
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_e9906f08(weapon)
{
	/#
		XP = 0;
		var_1121268 = function_949d6013(weapon);
		if(var_1121268.size)
		{
			XP = var_1121268[var_1121268.size - 1];
		}
		return XP;
	#/
}

/*
	Name: function_2306f73c
	Namespace: zm_devgui
	Checksum: 0x6908CF36
	Offset: 0x99C0
	Size: 0x13D
	Parameters: 0
	Flags: None
*/
function function_2306f73c()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player GetCurrentWeapon();
				itemIndex = GetBaseWeaponItemIndex(weapon);
				var_2e8a2b5e = player function_bc8e235e(itemIndex);
				XP = function_718c64af(weapon, var_2e8a2b5e);
				player function_3ec0de8d(itemIndex, XP);
			}
		}
	#/
}

/*
	Name: function_5da1c3cd
	Namespace: zm_devgui
	Checksum: 0x48447650
	Offset: 0x9B08
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function function_5da1c3cd()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player GetCurrentWeapon();
				itemIndex = GetBaseWeaponItemIndex(weapon);
				var_2e8a2b5e = player function_bc8e235e(itemIndex);
				XP = function_718c64af(weapon, var_2e8a2b5e);
				player function_3ec0de8d(itemIndex, XP - 50);
			}
		}
	#/
}

/*
	Name: function_6afc4c2f
	Namespace: zm_devgui
	Checksum: 0x5C269215
	Offset: 0x9C58
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function function_6afc4c2f()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player GetCurrentWeapon();
				itemIndex = GetBaseWeaponItemIndex(weapon);
				XP = function_e9906f08(weapon);
				player function_3ec0de8d(itemIndex, XP);
			}
		}
	#/
}

/*
	Name: function_9b4ea903
	Namespace: zm_devgui
	Checksum: 0xA2F66BF6
	Offset: 0x9D70
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function function_9b4ea903()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player GetCurrentWeapon();
				itemIndex = GetBaseWeaponItemIndex(weapon);
				player function_3ec0de8d(itemIndex, 0);
			}
		}
	#/
}

/*
	Name: function_4d2e8278
	Namespace: zm_devgui
	Checksum: 0x98BD74CD
	Offset: 0x9E68
	Size: 0x15F
	Parameters: 0
	Flags: None
*/
function function_4d2e8278()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		a_weapons = EnumerateWeapons("Dev Block strings are not supported");
		for(weapon_index = 0; weapon_index < a_weapons.size; weapon_index++)
		{
			weapon = a_weapons[weapon_index];
			itemIndex = GetBaseWeaponItemIndex(weapon);
			if(!itemIndex)
			{
				break;
			}
			XP = function_e9906f08(weapon);
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				if(!player laststand::player_is_in_laststand())
				{
					player function_3ec0de8d(itemIndex, XP);
				}
			}
		}
	#/
}

/*
	Name: function_ce561484
	Namespace: zm_devgui
	Checksum: 0x2550312C
	Offset: 0x9FD0
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function function_ce561484()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		a_weapons = EnumerateWeapons("Dev Block strings are not supported");
		for(weapon_index = 0; weapon_index < a_weapons.size; weapon_index++)
		{
			weapon = a_weapons[weapon_index];
			itemIndex = GetBaseWeaponItemIndex(weapon);
			if(!itemIndex)
			{
				break;
			}
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				if(!player laststand::player_is_in_laststand())
				{
					player function_3ec0de8d(itemIndex, 0);
				}
			}
		}
	#/
}

/*
	Name: function_be6b95c4
	Namespace: zm_devgui
	Checksum: 0xF89A404A
	Offset: 0xA118
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function function_be6b95c4(XP)
{
	/#
		if(self.pers["Dev Block strings are not supported"] > XP)
		{
			self.pers["Dev Block strings are not supported"] = 0;
			self setRank(0);
			self SetDStat("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", 0);
		}
		self.pers["Dev Block strings are not supported"] = XP;
		self rank::syncXPStat();
		self rank::updateRank();
		self SetDStat("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", self.pers["Dev Block strings are not supported"]);
	#/
}

/*
	Name: function_1a6e88f7
	Namespace: zm_devgui
	Checksum: 0x43D61E30
	Offset: 0xA228
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_1a6e88f7(var_2e8a2b5e)
{
	/#
		return Int(level.rankTable[var_2e8a2b5e][7]);
	#/
}

/*
	Name: function_b207ef2e
	Namespace: zm_devgui
	Checksum: 0x8A6A9550
	Offset: 0xA268
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_b207ef2e()
{
	/#
		XP = 0;
		XP = function_1a6e88f7(level.rankTable.size - 1);
		return XP;
	#/
}

/*
	Name: function_9e5bfd9d
	Namespace: zm_devgui
	Checksum: 0x2231105C
	Offset: 0xA2B8
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function function_9e5bfd9d()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				var_2e8a2b5e = player rank::getRank();
				XP = function_1a6e88f7(var_2e8a2b5e);
				player function_be6b95c4(XP);
			}
		}
	#/
}

/*
	Name: function_435ea700
	Namespace: zm_devgui
	Checksum: 0xE743155F
	Offset: 0xA3B0
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function function_435ea700()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				var_2e8a2b5e = player rank::getRank();
				XP = function_1a6e88f7(var_2e8a2b5e);
				player function_be6b95c4(XP - 50);
			}
		}
	#/
}

/*
	Name: function_525facc6
	Namespace: zm_devgui
	Checksum: 0x50878941
	Offset: 0xA4B0
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function function_525facc6()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				XP = function_b207ef2e();
				player function_be6b95c4(XP);
			}
		}
	#/
}

/*
	Name: function_935f6cc2
	Namespace: zm_devgui
	Checksum: 0xBA7EF207
	Offset: 0xA588
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function function_935f6cc2()
{
	/#
		players = GetPlayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				player function_be6b95c4(0);
			}
		}
	#/
}

/*
	Name: zombie_devgui_reopt_current_weapon
	Namespace: zm_devgui
	Checksum: 0x16A4B86F
	Offset: 0xA638
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function zombie_devgui_reopt_current_weapon()
{
	/#
		players = GetPlayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weapon = players[i] GetCurrentWeapon();
				if(isdefined(players[i].pack_a_punch_weapon_options))
				{
					players[i].pack_a_punch_weapon_options[weapon] = undefined;
				}
				players[i] TakeWeapon(weapon);
				weapon = players[i] zm_weapons::give_build_kit_weapon(weapon);
				players[i] GiveStartAmmo(weapon);
				players[i] SwitchToWeapon(weapon);
			}
		}
	#/
}

/*
	Name: zombie_devgui_take_weapon
	Namespace: zm_devgui
	Checksum: 0xEA16F241
	Offset: 0xA7C0
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function zombie_devgui_take_weapon()
{
	/#
		players = GetPlayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				players[i] TakeWeapon(players[i] GetCurrentWeapon());
				players[i] zm_weapons::switch_back_primary_weapon(undefined);
			}
		}
	#/
}

/*
	Name: zombie_devgui_take_weapons
	Namespace: zm_devgui
	Checksum: 0x2EE68388
	Offset: 0xA8B8
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function zombie_devgui_take_weapons(give_fallback)
{
	/#
		players = GetPlayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				players[i] TakeAllWeapons();
				if(give_fallback)
				{
					players[i] zm_weapons::give_fallback_weapon();
				}
			}
		}
	#/
}

/*
	Name: get_upgrade
	Namespace: zm_devgui
	Checksum: 0x87747146
	Offset: 0xA9A8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function get_upgrade(weapon)
{
	/#
		if(isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade_name))
		{
			return zm_weapons::get_upgrade_weapon(weapon, 0);
		}
		else
		{
			return zm_weapons::get_upgrade_weapon(weapon, 1);
		}
	#/
}

/*
	Name: zombie_devgui_director_easy
	Namespace: zm_devgui
	Checksum: 0x70CE405D
	Offset: 0xAA30
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function zombie_devgui_director_easy()
{
	/#
		if(isdefined(level.director_devgui_health))
		{
			[[level.director_devgui_health]]();
		}
	#/
}

/*
	Name: zombie_devgui_chest_never_move
	Namespace: zm_devgui
	Checksum: 0xDECE5EDC
	Offset: 0xAA60
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function zombie_devgui_chest_never_move()
{
	/#
		level notify("devgui_chest_end_monitor");
		level endon("devgui_chest_end_monitor");
		for(;;)
		{
			level.chest_accessed = 0;
			wait(5);
		}
	#/
}

/*
	Name: zombie_devgui_disable_kill_thread_toggle
	Namespace: zm_devgui
	Checksum: 0x7E716BAC
	Offset: 0xAAA0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_disable_kill_thread_toggle()
{
	/#
		if(!(isdefined(level.disable_kill_thread) && level.disable_kill_thread))
		{
			level.disable_kill_thread = 1;
		}
		else
		{
			level.disable_kill_thread = 0;
		}
	#/
}

/*
	Name: zombie_devgui_check_kill_thread_every_frame_toggle
	Namespace: zm_devgui
	Checksum: 0x4A9C1E0F
	Offset: 0xAAE8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_check_kill_thread_every_frame_toggle()
{
	/#
		if(!(isdefined(level.check_kill_thread_every_frame) && level.check_kill_thread_every_frame))
		{
			level.check_kill_thread_every_frame = 1;
		}
		else
		{
			level.check_kill_thread_every_frame = 0;
		}
	#/
}

/*
	Name: zombie_devgui_kill_thread_test_mode_toggle
	Namespace: zm_devgui
	Checksum: 0xEBDEC2D6
	Offset: 0xAB30
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function zombie_devgui_kill_thread_test_mode_toggle()
{
	/#
		if(!(isdefined(level.kill_thread_test_mode) && level.kill_thread_test_mode))
		{
			level.kill_thread_test_mode = 1;
		}
		else
		{
			level.kill_thread_test_mode = 0;
		}
	#/
}

/*
	Name: showOneSpawnPoint
	Namespace: zm_devgui
	Checksum: 0x25B235D5
	Offset: 0xAB78
	Size: 0x58D
	Parameters: 5
	Flags: None
*/
function showOneSpawnPoint(spawn_point, color, notification, height, print)
{
	/#
		if(!isdefined(height) || height <= 0)
		{
			height = util::get_player_height();
		}
		if(!isdefined(print))
		{
			print = spawn_point.classname;
		}
		center = spawn_point.origin;
		FORWARD = AnglesToForward(spawn_point.angles);
		right = AnglesToRight(spawn_point.angles);
		FORWARD = VectorScale(FORWARD, 16);
		right = VectorScale(right, 16);
		a = center + FORWARD - right;
		b = center + FORWARD + right;
		c = center - FORWARD + right;
		d = center - FORWARD - right;
		thread lineUntilNotified(a, b, color, 0, notification);
		thread lineUntilNotified(b, c, color, 0, notification);
		thread lineUntilNotified(c, d, color, 0, notification);
		thread lineUntilNotified(d, a, color, 0, notification);
		thread lineUntilNotified(a, a + (0, 0, height), color, 0, notification);
		thread lineUntilNotified(b, b + (0, 0, height), color, 0, notification);
		thread lineUntilNotified(c, c + (0, 0, height), color, 0, notification);
		thread lineUntilNotified(d, d + (0, 0, height), color, 0, notification);
		a = a + (0, 0, height);
		b = b + (0, 0, height);
		c = c + (0, 0, height);
		d = d + (0, 0, height);
		thread lineUntilNotified(a, b, color, 0, notification);
		thread lineUntilNotified(b, c, color, 0, notification);
		thread lineUntilNotified(c, d, color, 0, notification);
		thread lineUntilNotified(d, a, color, 0, notification);
		center = center + (0, 0, height / 2);
		arrow_forward = AnglesToForward(spawn_point.angles);
		arrowhead_forward = AnglesToForward(spawn_point.angles);
		arrowhead_right = AnglesToRight(spawn_point.angles);
		arrow_forward = VectorScale(arrow_forward, 32);
		arrowhead_forward = VectorScale(arrowhead_forward, 24);
		arrowhead_right = VectorScale(arrowhead_right, 8);
		a = center + arrow_forward;
		b = center + arrowhead_forward - arrowhead_right;
		c = center + arrowhead_forward + arrowhead_right;
		thread lineUntilNotified(center, a, color, 0, notification);
		thread lineUntilNotified(a, b, color, 0, notification);
		thread lineUntilNotified(a, c, color, 0, notification);
		thread print3DUntilNotified(spawn_point.origin + (0, 0, height), print, color, 1, 1, notification);
		return;
	#/
}

/*
	Name: print3DUntilNotified
	Namespace: zm_devgui
	Checksum: 0x6BCA5A04
	Offset: 0xB110
	Size: 0x6F
	Parameters: 6
	Flags: None
*/
function print3DUntilNotified(origin, text, color, alpha, scale, notification)
{
	/#
		level endon(notification);
		for(;;)
		{
			print3d(origin, text, color, alpha, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: lineUntilNotified
	Namespace: zm_devgui
	Checksum: 0xCE6240A4
	Offset: 0xB188
	Size: 0x67
	Parameters: 5
	Flags: None
*/
function lineUntilNotified(start, end, color, depthTest, notification)
{
	/#
		level endon(notification);
		for(;;)
		{
			line(start, end, color, depthTest);
			wait(0.05);
		}
	#/
}

/*
	Name: devgui_debug_hud
	Namespace: zm_devgui
	Checksum: 0xADF4520D
	Offset: 0xB1F8
	Size: 0x2DB
	Parameters: 0
	Flags: None
*/
function devgui_debug_hud()
{
	/#
		if(isdefined(self zm_utility::get_player_lethal_grenade()))
		{
			self giveMaxAmmo(self zm_utility::get_player_lethal_grenade());
		}
		wpn_type = zm_placeable_mine::get_first_available();
		if(wpn_type != level.weaponNone)
		{
			self thread zm_placeable_mine::setup_for_player(wpn_type);
		}
		if(isdefined(level.zombiemode_devgui_cymbal_monkey_give))
		{
			if(isdefined(self zm_utility::get_player_tactical_grenade()))
			{
				self TakeWeapon(self zm_utility::get_player_tactical_grenade());
			}
			self [[level.zombiemode_devgui_cymbal_monkey_give]]();
		}
		else if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self giveMaxAmmo(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombie_include_equipment) && !isdefined(self zm_equipment::get_player_equipment()))
		{
			equipment = getArrayKeys(level.zombie_include_equipment);
			if(isdefined(equipment[0]))
			{
				self zombie_devgui_equipment_give(equipment[0]);
			}
		}
		for(i = 0; i < 10; i++)
		{
			zombie_devgui_give_powerup("Dev Block strings are not supported", 1, self.origin);
			wait(0.25);
		}
		zombie_devgui_give_powerup("Dev Block strings are not supported", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("Dev Block strings are not supported", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("Dev Block strings are not supported", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("Dev Block strings are not supported", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("Dev Block strings are not supported", 1, self.origin);
		wait(0.25);
	#/
}

/*
	Name: function_47239612
	Namespace: zm_devgui
	Checksum: 0x515572A3
	Offset: 0xB4E0
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function function_47239612()
{
	/#
		wait(0.05);
		var_bcd2016c = GetDvarInt("Dev Block strings are not supported");
		for(;;)
		{
			VAL = GetDvarInt("Dev Block strings are not supported");
			if(var_bcd2016c != VAL)
			{
				if(isdefined(level.var_315b8892))
				{
					level.var_315b8892 delete();
					level.var_315b8892 = undefined;
				}
				if(VAL)
				{
					player = GetPlayers()[0];
					direction = player getPlayerAngles();
					direction_vec = AnglesToForward((0, direction[1], 0));
					scale = 120;
					direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
					level.var_315b8892 = spawn("Dev Block strings are not supported", player GetEye() + direction_vec);
					level.var_315b8892 SetModel("Dev Block strings are not supported");
					level.var_315b8892.angles = (0, direction[1], 0) + VectorScale((0, 1, 0), 90);
				}
			}
			var_bcd2016c = VAL;
			wait(0.05);
		}
	#/
}

/*
	Name: function_46ba1b5d
	Namespace: zm_devgui
	Checksum: 0xC735CB95
	Offset: 0xB6F8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_46ba1b5d()
{
	/#
		if(!isdefined(level.var_31f0c728))
		{
			level.var_31f0c728 = 1;
		}
		else
		{
			level.var_31f0c728 = !level.var_31f0c728;
		}
	#/
}

/*
	Name: function_39e3e21e
	Namespace: zm_devgui
	Checksum: 0x6C9B94D7
	Offset: 0xB738
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_39e3e21e()
{
	/#
		if(!isdefined(level.toggle_keyline_always))
		{
			level.toggle_keyline_always = 1;
		}
		else
		{
			level.toggle_keyline_always = !level.toggle_keyline_always;
		}
	#/
}

/*
	Name: function_13d8ea87
	Namespace: zm_devgui
	Checksum: 0xBA2FFA47
	Offset: 0xB778
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_13d8ea87()
{
	/#
		if(!isdefined(level.var_c2a01768))
		{
			level.var_c2a01768 = 1;
		}
		else
		{
			level.var_c2a01768 = !level.var_c2a01768;
		}
	#/
}

/*
	Name: function_67e88f63
	Namespace: zm_devgui
	Checksum: 0x528DC1D1
	Offset: 0xB7B8
	Size: 0x2DB
	Parameters: 1
	Flags: None
*/
function function_67e88f63(crawler)
{
	/#
		nodes = GetAllNodes();
		while(1)
		{
			ai = GetActorArray();
			zombie = ai[0];
			if(isdefined(zombie))
			{
				foreach(node in nodes)
				{
					if(node.type == "Dev Block strings are not supported" || node.type == "Dev Block strings are not supported" || node.type == "Dev Block strings are not supported")
					{
						if(isdefined(node.animscript))
						{
							blackboard::SetBlackBoardAttribute(zombie, "Dev Block strings are not supported", "Dev Block strings are not supported");
							blackboard::SetBlackBoardAttribute(zombie, "Dev Block strings are not supported", node.animscript);
							table = istring("Dev Block strings are not supported");
							if(isdefined(crawler) && crawler)
							{
								table = istring("Dev Block strings are not supported");
							}
							if(isdefined(zombie.debug_traversal_ast))
							{
								table = istring(zombie.debug_traversal_ast);
							}
							var_b0b2ea39 = zombie ASTSearch(table);
							if(!isdefined(var_b0b2ea39["Dev Block strings are not supported"]))
							{
								if(isdefined(crawler) && crawler)
								{
									node.var_ec2b8c0c = 1;
								}
								else
								{
									node.var_4fb8ab7f = 1;
								}
								continue;
							}
							if(var_b0b2ea39["Dev Block strings are not supported"] == "Dev Block strings are not supported")
							{
								teleport = 1;
							}
						}
					}
				}
				break;
			}
			wait(0.25);
		}
	#/
}

/*
	Name: function_40dde582
	Namespace: zm_devgui
	Checksum: 0xD1714B48
	Offset: 0xBAA0
	Size: 0x22F
	Parameters: 0
	Flags: None
*/
function function_40dde582()
{
	/#
		level thread function_67e88f63();
		level thread function_67e88f63(1);
		nodes = GetAllNodes();
		while(1)
		{
			if(isdefined(level.var_31f0c728) && level.var_31f0c728)
			{
				foreach(node in nodes)
				{
					if(isdefined(node.animscript))
					{
						var_d0c24eab = (0, 0.8, 0.6);
						var_db44513d = (1, 1, 1);
						if(isdefined(node.var_4fb8ab7f) && node.var_4fb8ab7f)
						{
							var_d0c24eab = (1, 0, 0);
							var_db44513d = (1, 0, 0);
						}
						circle(node.origin, 16, var_db44513d);
						print3d(node.origin, node.animscript, var_d0c24eab, 1, 0.5);
						if(isdefined(node.var_ec2b8c0c) && node.var_ec2b8c0c)
						{
							print3d(node.origin + VectorScale((0, 0, -1), 12), "Dev Block strings are not supported", (1, 0, 0), 1, 0.5);
						}
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_364ed1b9
	Namespace: zm_devgui
	Checksum: 0x362AA267
	Offset: 0xBCD8
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function function_364ed1b9()
{
	/#
		nodes = GetAllNodes();
		var_242e809d = [];
		foreach(node in nodes)
		{
			if(isdefined(node.animscript) && node.animscript != "Dev Block strings are not supported")
			{
				var_242e809d[node.animscript] = 1;
			}
		}
		var_d1e1ebcf = getArrayKeys(var_242e809d);
		var_bbd3b866 = Array::sort_by_value(var_d1e1ebcf, 1);
		println("Dev Block strings are not supported");
		foreach(name in var_bbd3b866)
		{
			println("Dev Block strings are not supported" + name);
		}
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: function_1d21f4f
	Namespace: zm_devgui
	Checksum: 0x6D5E3542
	Offset: 0xBEE0
	Size: 0x21F
	Parameters: 0
	Flags: None
*/
function function_1d21f4f()
{
	/#
		while(1)
		{
			if(isdefined(level.var_c2a01768) && level.var_c2a01768)
			{
				if(!isdefined(level.var_ff15f442))
				{
					level.var_ff15f442 = NewHudElem();
					level.var_ff15f442.alignX = "Dev Block strings are not supported";
					level.var_ff15f442.x = 2;
					level.var_ff15f442.y = 160;
					level.var_ff15f442.fontscale = 1.5;
					level.var_ff15f442.color = (1, 1, 1);
				}
				zombie_count = zombie_utility::get_current_zombie_count();
				zombie_left = level.zombie_total;
				var_e392f9a3 = 0;
				var_8cbe658b = zombie_utility::get_zombie_array();
				foreach(ai_zombie in var_8cbe658b)
				{
					if(ai_zombie.zombie_move_speed == "Dev Block strings are not supported")
					{
						var_e392f9a3++;
					}
				}
				level.var_ff15f442 setText("Dev Block strings are not supported" + zombie_count + "Dev Block strings are not supported" + zombie_left + "Dev Block strings are not supported" + var_e392f9a3);
			}
			else if(isdefined(level.var_ff15f442))
			{
				level.var_ff15f442 destroy();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: testscriptruntimeerrorassert
	Namespace: zm_devgui
	Checksum: 0x4B960277
	Offset: 0xC108
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function testscriptruntimeerrorassert()
{
	/#
		wait(1);
		/#
			Assert(0);
		#/
	#/
}

/*
	Name: testscriptruntimeerror2
	Namespace: zm_devgui
	Checksum: 0xC866F8F9
	Offset: 0xC138
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function testscriptruntimeerror2()
{
	/#
		myundefined = "Dev Block strings are not supported";
		if(myundefined == 1)
		{
			println("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: testscriptruntimeerror1
	Namespace: zm_devgui
	Checksum: 0x901D1CBD
	Offset: 0xC188
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function testscriptruntimeerror1()
{
	/#
		testscriptruntimeerror2();
	#/
}

/*
	Name: testscriptruntimeerror
	Namespace: zm_devgui
	Checksum: 0x92534BC4
	Offset: 0xC1B0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function testscriptruntimeerror()
{
	/#
		wait(5);
		while(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			break;
			wait(1);
		}
		myerror = GetDvarString("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(myerror == "Dev Block strings are not supported")
		{
			testscriptruntimeerrorassert();
		}
		else
		{
			testscriptruntimeerror1();
		}
		thread testscriptruntimeerror();
	#/
}

/*
	Name: function_2fcc56bd
	Namespace: zm_devgui
	Checksum: 0xA7661B2D
	Offset: 0xC288
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_2fcc56bd()
{
	/#
		var_9857308b = GetDvarInt("Dev Block strings are not supported");
		return Array(Array(var_9857308b / 2, 30), Array(var_9857308b - 1, 20));
	#/
}

/*
	Name: function_1acc8e35
	Namespace: zm_devgui
	Checksum: 0x43FAF036
	Offset: 0xC318
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function function_1acc8e35()
{
	/#
		self endon("hash_eec2d58b");
		SetDvar("Dev Block strings are not supported", 1);
		var_9857308b = GetDvarInt("Dev Block strings are not supported");
		timescale = GetDvarInt("Dev Block strings are not supported");
		var_da0f3f6 = function_2fcc56bd();
		SetDvar("Dev Block strings are not supported", timescale);
		while(level.round_number < var_9857308b)
		{
			foreach(var_b16efbf2 in var_da0f3f6)
			{
				if(level.round_number < var_b16efbf2[0])
				{
					wait(var_b16efbf2[1]);
					break;
				}
			}
			ai_enemies = GetAITeamArray("Dev Block strings are not supported");
			foreach(ai in ai_enemies)
			{
				ai kill();
			}
			AddDebugCommand("Dev Block strings are not supported");
			wait(0.2);
		}
		SetDvar("Dev Block strings are not supported", 1);
	#/
}

/*
	Name: function_eec2d58b
	Namespace: zm_devgui
	Checksum: 0x6E03069E
	Offset: 0xC568
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_eec2d58b()
{
	/#
		self notify("hash_eec2d58b");
		SetDvar("Dev Block strings are not supported", 1);
	#/
}

