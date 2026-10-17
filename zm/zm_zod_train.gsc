#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_cleanup_mgr;
#using scripts\zm\zm_zod_util;

#namespace namespace_835aa2f1;

/*
	Name: __init__sytem__
	Namespace: namespace_835aa2f1
	Checksum: 0xBDD9C4EF
	Offset: 0xCE0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_train", &__init__, undefined, undefined);
}

/*
	Name: onPlayerConnect
	Namespace: namespace_835aa2f1
	Checksum: 0x3FA43A3F
	Offset: 0xD20
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	self.on_train = 0;
}

/*
	Name: __init__
	Namespace: namespace_835aa2f1
	Checksum: 0x43133229
	Offset: 0xD38
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&onPlayerConnect);
	callback::on_spawned(&player_on_spawned);
	namespace_8e578893::on_zombie_killed(&remove_dead_zombie);
	namespace_8e578893::add_zod_zombie_spawn_func(&zombie_init);
	clientfield::register("vehicle", "train_switch_light", 1, 2, "int");
	clientfield::register("scriptmover", "train_callbox_light", 1, 2, "int");
	clientfield::register("scriptmover", "train_map_light", 1, 2, "int");
	clientfield::register("vehicle", "train_rain_fx_occluder", 1, 1, "int");
	clientfield::register("world", "sndTrainVox", 1, 4, "int");
	level.player_intemission_spawn_callback = &player_intemission_spawn_callback;
	thread initialize_train();
	thread function_eb0db7bc();
	/#
		thread train_devgui();
	#/
}

/*
	Name: function_eb0db7bc
	Namespace: namespace_835aa2f1
	Checksum: 0x68EA01F1
	Offset: 0xF08
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_eb0db7bc()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	while(1)
	{
		level waittill("host_migration_end");
		initialize_stations();
		function_7eb2583b();
		flip_forward();
		send_train();
	}
}

/*
	Name: player_intemission_spawn_callback
	Namespace: namespace_835aa2f1
	Checksum: 0x49391276
	Offset: 0xFC0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function player_intemission_spawn_callback(origin, angles)
{
	ride_vehicle = undefined;
	self.ground_ent = self GetGroundEnt();
	if(isdefined(self.ground_ent))
	{
		if(isVehicle(self.ground_ent) && !level.zombie_team === self.ground_ent)
		{
			ride_vehicle = self.ground_ent;
		}
	}
	if(isdefined(ride_vehicle))
	{
		self spawn(origin, angles);
	}
}

/*
	Name: initialize_train
	Namespace: namespace_835aa2f1
	Checksum: 0xD73D9D57
	Offset: 0x1088
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function initialize_train()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	e_train = GetEnt("zod_train", "targetname");
	e_train function_7465f87();
	e_train.takedamage = 0;
	e_train clientfield::set("train_rain_fx_occluder", 1);
	__constructor();
	level.o_zod_train = czmtrain;
	Initialize(level.o_zod_train);
	level thread autosend_train();
	level.var_33c4ee76 = 0;
}

/*
	Name: function_f37aa349
	Namespace: namespace_835aa2f1
	Checksum: 0xEC474585
	Offset: 0x1198
	Size: 0xB5
	Parameters: 1
	Flags: None
*/
function function_f37aa349(sn)
{
	ents = GetEntArray();
	foreach(ent in ents)
	{
		if(ent.script_noteworthy === sn)
		{
			return ent;
		}
	}
	return undefined;
}

/*
	Name: function_7465f87
	Namespace: namespace_835aa2f1
	Checksum: 0xF99BFCE4
	Offset: 0x1258
	Size: 0x339
	Parameters: 0
	Flags: None
*/
function function_7465f87()
{
	trigs = GetEntArray("train_buyable_weapon", "script_noteworthy");
	foreach(trig in trigs)
	{
		trig EnableLinkTo();
		trig LinkTo(self, "", self WorldToLocalCoords(trig.origin), (0, 0, 0));
		trig.weapon = GetWeapon(trig.zombie_weapon_upgrade);
		trig setcursorhint("HINT_WEAPON", trig.weapon);
		trig.cost = zm_weapons::get_weapon_cost(trig.weapon);
		trig.hint_string = zm_weapons::get_weapon_hint(trig.weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			trig setHintString(trig.hint_string);
		}
		else
		{
			trig.hint_parm1 = trig.cost;
			trig setHintString(trig.hint_string, trig.hint_parm1);
		}
		self.buyable_weapon = trig;
		level._spawned_wallbuys[level._spawned_wallbuys.size] = trig;
		weapon_model = GetEnt(trig.target, "targetname");
		weapon_model LinkTo(self, "", self WorldToLocalCoords(weapon_model.origin), weapon_model.angles + self.angles);
		weapon_model SetMovingPlatformEnabled(1);
		weapon_model._linked_ent = trig;
		weapon_model show();
		weapon_model thread function_d7993b3d(trig);
	}
}

/*
	Name: player_on_spawned
	Namespace: namespace_835aa2f1
	Checksum: 0xAA3FE45E
	Offset: 0x15A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function player_on_spawned()
{
	self thread function_69c89e00();
}

/*
	Name: function_69c89e00
	Namespace: namespace_835aa2f1
	Checksum: 0x64908CD3
	Offset: 0x15C8
	Size: 0x141
	Parameters: 0
	Flags: None
*/
function function_69c89e00()
{
	self endon("disconnect");
	self notify("hash_69c89e00");
	self endon("hash_69c89e00");
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	wait(1);
	wallbuy = level.o_zod_train.m_vh_train.buyable_weapon;
	self notify("zm_bgb_secret_shopper", wallbuy);
	self.var_316060b3 = 0;
	while(isdefined(self))
	{
		if(isdefined(self.on_train) && self.on_train)
		{
			if(!self.var_316060b3)
			{
				self notify("zm_bgb_secret_shopper", wallbuy);
			}
			wallbuy function_2e9b7fc1(self, wallbuy.weapon);
		}
		else if(self.var_316060b3)
		{
			self notify("hash_a09e2c64");
		}
		self.var_316060b3 = self.on_train;
		wait(1);
	}
}

/*
	Name: function_2e9b7fc1
	Namespace: namespace_835aa2f1
	Checksum: 0x539A5EBF
	Offset: 0x1718
	Size: 0x4F7
	Parameters: 2
	Flags: None
*/
function function_2e9b7fc1(player, weapon)
{
	if(!isdefined(weapon))
	{
		weapon = self.weapon;
	}
	player_has_weapon = player zm_weapons::has_weapon_or_upgrade(weapon);
	if(!player_has_weapon && (isdefined(level.weapons_using_ammo_sharing) && level.weapons_using_ammo_sharing))
	{
		shared_ammo_weapon = player zm_weapons::get_shared_ammo_weapon(self.zombie_weapon_upgrade);
		if(isdefined(shared_ammo_weapon))
		{
			weapon = shared_ammo_weapon;
			player_has_weapon = 1;
		}
	}
	if(!player_has_weapon)
	{
		cursor_hint = "HINT_WEAPON";
		cost = zm_weapons::get_weapon_cost(weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentWeapon))
			{
				hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL_BGB_SECRET_SHOPPER";
				self sethintstringforplayer(player, hint_string);
			}
			else
			{
				hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
				self sethintstringforplayer(player, hint_string);
			}
		}
		else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentWeapon))
		{
			hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL_BGB_SECRET_SHOPPER";
			n_bgb_cost = player zm_weapons::get_ammo_cost_for_weapon(player.currentWeapon);
			self sethintstringforplayer(player, hint_string, cost, n_bgb_cost);
		}
		else
		{
			hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL";
			self sethintstringforplayer(player, hint_string, cost);
		}
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(weapon))
	{
		ammo_cost = player zm_weapons::get_ammo_cost_for_weapon(weapon);
	}
	else if(player zm_weapons::has_upgrade(weapon))
	{
		ammo_cost = zm_weapons::get_upgraded_ammo_cost(weapon);
	}
	else
	{
		ammo_cost = zm_weapons::get_ammo_cost(weapon);
	}
	if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
	{
		if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentWeapon))
		{
			hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL_BGB_SECRET_SHOPPER";
			self sethintstringforplayer(player, hint_string);
		}
		else
		{
			hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL";
			self sethintstringforplayer(player, hint_string);
		}
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentWeapon))
	{
		hint_string = &"ZOMBIE_WEAPONAMMOONLY_BGB_SECRET_SHOPPER";
		n_bgb_cost = player zm_weapons::get_ammo_cost_for_weapon(player.currentWeapon);
		self sethintstringforplayer(player, hint_string, ammo_cost, n_bgb_cost);
	}
	else
	{
		hint_string = &"ZOMBIE_WEAPONAMMOONLY";
		self sethintstringforplayer(player, hint_string, ammo_cost);
	}
	cursor_hint = "HINT_WEAPON";
	cursor_hint_weapon = weapon;
	self setcursorhint(cursor_hint, cursor_hint_weapon);
	return 1;
}

/*
	Name: function_d7993b3d
	Namespace: namespace_835aa2f1
	Checksum: 0x619407B6
	Offset: 0x1C18
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_d7993b3d(trigger)
{
	self.orgmodel = self.model;
	self SetModel("wpn_t7_none_world");
	trigger waittill("trigger");
	self SetModel(self.orgmodel);
}

/*
	Name: zombie_init
	Namespace: namespace_835aa2f1
	Checksum: 0x11518FA2
	Offset: 0x1C88
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function zombie_init()
{
	self.locked_in_train = 0;
}

/*
	Name: autosend_train
	Namespace: namespace_835aa2f1
	Checksum: 0xDD56E2FA
	Offset: 0x1CA0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function autosend_train()
{
	level flag::wait_till("connect_start_to_junction");
	send_train();
}

#namespace czmtrain;

/*
	Name: __constructor
	Namespace: czmtrain
	Checksum: 0x1AA5265D
	Offset: 0x1CE0
	Size: 0x225
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.m_vh_train = undefined;
	self.m_s_trigger = undefined;
	self.m_t_switch = undefined;
	self.m_e_volume = undefined;
	self.m_b_facing_forward = 1;
	self.m_b_free = 0;
	self.m_b_incoming = 0;
	self.m_a_s_stations = [];
	self.m_a_mdl_doors = [];
	self.m_str_station = undefined;
	self.m_str_destination = undefined;
	self.m_a_zombies_locked_in = [];
	self.m_n_last_jumper_time = 0;
	self.m_a_jumptags = [];
	self.var_9e0dc993 = 1;
	a_names = Array("tag_enter_back_top", "tag_enter_front_top", "tag_enter_left_top", "tag_enter_right_top");
	a_anims = Array("ai_zombie_zod_train_win_trav_from_roof_b", "ai_zombie_zod_train_win_trav_from_roof_f", "ai_zombie_zod_train_win_trav_from_roof_l", "ai_zombie_zod_train_win_trav_from_roof_r");
	/#
		Assert(a_names.size == a_anims.size);
	#/
	for(i = 0; i < a_names.size; i++)
	{
		str_name = a_names[i];
		str_anim = a_anims[i];
		self.m_a_jumptags[str_name] = spawnstruct();
		s_entrance = self.m_a_jumptags[str_name];
		s_entrance.str_tag = str_name;
		s_entrance.str_anim = str_anim;
		s_entrance.occupied = 0;
	}
}

/*
	Name: debug_draw_paths
	Namespace: czmtrain
	Checksum: 0xB1E15503
	Offset: 0x1F10
	Size: 0x40F
	Parameters: 0
	Flags: None
*/
function debug_draw_paths()
{
	/#
		do
		{
			n_debug = GetDvarInt("Dev Block strings are not supported");
			wait(1);
		}
		while(!(!isdefined(n_debug) || n_debug <= 0));
		while(1)
		{
			a_keys = getArrayKeys(self.m_a_s_stations);
			for(key_num = 0; key_num < self.m_a_s_stations.size; key_num++)
			{
				j = a_keys[key_num];
				node_set = self.m_a_s_stations[j].nodes;
				for(i = 0; i < node_set.size; i++)
				{
					node = node_set[i];
					node_pos = node.origin + VectorScale((0, 0, -1), 95);
					debugstar(node_pos, 1, (1, 0, 0));
					if(isdefined(node.target))
					{
						node_target = GetVehicleNode(node.target, "Dev Block strings are not supported");
						node_target_pos = node_target.origin + VectorScale((0, 0, -1), 70);
						line(node_pos, node_target_pos, (0, 1, 0), 0, 1);
						debugstar(node_target_pos, 1, (0, 1, 0));
					}
					if(isdefined(node.target2))
					{
						node_target2 = GetVehicleNode(node.target2, "Dev Block strings are not supported");
						node_target2_pos = node_target2.origin + VectorScale((0, 0, -1), 120);
						line(node_pos, node_target2_pos, (0, 0, 1), 0, 1);
						debugstar(node_target2_pos, 1, (0, 0, 1));
					}
				}
			}
			a_zombies = GetAITeamArray(level.zombie_team);
			foreach(ai in a_zombies)
			{
				if(isdefined(ai.locked_in_train) && ai.locked_in_train)
				{
					print3d(ai.origin + VectorScale((0, 0, 1), 100), "Dev Block strings are not supported" + self.m_a_zombies_locked_in.size + "Dev Block strings are not supported", VectorScale((0, 1, 0), 255), 1);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debug_draw_doors
	Namespace: czmtrain
	Checksum: 0xBBCBF00E
	Offset: 0x2328
	Size: 0x317
	Parameters: 0
	Flags: None
*/
function debug_draw_doors()
{
	do
	{
		n_debug = GetDvarInt("train_debug_doors");
		wait(1);
	}
	while(!(!isdefined(n_debug) || n_debug <= 0));
	while(1)
	{
		duration = 1;
		forward_length = 240;
		arrow_width = 12;
		origin = self.m_vh_train.origin;
		origin = origin + VectorScale((0, 0, -1), 90);
		FORWARD = AnglesToForward(self.m_vh_train.angles);
		right = AnglesToRight(self.m_vh_train.angles);
		if(!self.m_b_facing_forward)
		{
			FORWARD = -1 * FORWARD;
		}
		arrow_end = origin + forward_length * FORWARD;
		/#
			line(origin, arrow_end, (1, 0, 0), 1, 1, duration);
		#/
		/#
			line(arrow_end, arrow_end - arrow_width * FORWARD - arrow_width * right, (1, 0, 0), 1, 1, duration);
		#/
		/#
			line(arrow_end, arrow_end - arrow_width * FORWARD + arrow_width * right, (1, 0, 0), 1, 1, duration);
		#/
		foreach(e_door in self.m_a_mdl_doors)
		{
			var_d4280494 = e_door.origin;
			open = is_door_open(e_door);
			str_state = "closed";
			if(open)
			{
				str_state = "open";
			}
			/#
				print3d(var_d4280494, str_state, (0, 0, 1), 1, 1, duration);
			#/
		}
		wait(0.05);
	}
}

/*
	Name: switch_path_direction
	Namespace: czmtrain
	Checksum: 0x8B0F3DEB
	Offset: 0x2648
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function switch_path_direction(all_nodes, direction)
{
	for(i = 0; i < all_nodes.size; i++)
	{
		prev_target = all_nodes[i].target;
		all_nodes[i].target = all_nodes[i].target2;
		all_nodes[i].target2 = prev_target;
	}
	return !direction;
}

/*
	Name: enable_train_switches
	Namespace: czmtrain
	Checksum: 0xB675E256
	Offset: 0x26F8
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function enable_train_switches(b_enabled)
{
	if(b_enabled)
	{
		self flag::set("switches_enabled");
		self.m_t_switch setHintString(&"ZM_ZOD_SWITCH_ENABLE");
		function_ca899bfc();
	}
	else
	{
		self flag::clear("switches_enabled");
		self.m_t_switch setHintString(&"ZM_ZOD_SWITCH_DISABLE");
		self.m_vh_train notify("hash_51689c0f");
	}
}

/*
	Name: get_train_vehicle
	Namespace: czmtrain
	Checksum: 0x4B6CC725
	Offset: 0x27B8
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_train_vehicle()
{
	return self.m_vh_train;
}

/*
	Name: function_a8e2d7ff
	Namespace: czmtrain
	Checksum: 0x99DAB385
	Offset: 0x27D0
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function function_a8e2d7ff()
{
	var_aed9540e = [];
	var_aed9540e["moving"] = GetEntArray("lgt_train_lightrig_veh_placement", "targetname");
	var_aed9540e["canals"] = GetEntArray("lgt_train_lightrig_canals_debug", "targetname");
	var_aed9540e["slums"] = GetEntArray("lgt_train_lightrig_slums_debug", "targetname");
	var_aed9540e["theater"] = GetEntArray("lgt_train_lightrig_theater_debug", "targetname");
	var_105cc375 = VectorScale((0, 1, 0), 45);
	self EnableLinkTo();
	foreach(var_83e6406e in var_aed9540e)
	{
		foreach(var_66fccd7 in var_83e6406e)
		{
			var_66fccd7.origin = self.origin;
			var_66fccd7.angles = self.angles + var_105cc375;
			var_66fccd7 LinkTo(self);
		}
	}
}

/*
	Name: get_current_station
	Namespace: czmtrain
	Checksum: 0x82585757
	Offset: 0x2A00
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_current_station()
{
	return self.m_str_station;
}

/*
	Name: get_current_destination
	Namespace: czmtrain
	Checksum: 0xB5995F60
	Offset: 0x2A18
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function get_current_destination()
{
	if(self.m_a_s_stations[self.m_str_station].b_left_path_active)
	{
		return self.m_a_s_stations[self.m_str_station].left_path;
	}
	else
	{
		return self.m_a_s_stations[self.m_str_station].right_path;
	}
}

/*
	Name: watch_node_parameters
	Namespace: czmtrain
	Checksum: 0x320F6EBF
	Offset: 0x2A80
	Size: 0x159
	Parameters: 0
	Flags: None
*/
function watch_node_parameters()
{
	self.m_vh_train endon("docked_in_station");
	while(1)
	{
		self.m_vh_train waittill("reached_node", nd);
		if(isdefined(nd.script_parameters))
		{
			switch(nd.script_parameters)
			{
				case "arrival_brakes":
				{
					if(self.m_b_incoming)
					{
						self.m_vh_train playsound("evt_train_stop");
						self.m_vh_train StopLoopSound(3);
					}
					break;
				}
				case "arrival_bell":
				{
					if(self.m_b_incoming)
					{
						e_callbox = self.m_a_s_stations[self.m_str_destination].callbox;
						e_callbox playsound("evt_train_station_bell");
					}
					break;
				}
				case default:
				{
					/#
						ASSERTMSG("Dev Block strings are not supported" + nd.script_parameters);
					#/
					break;
				}
			}
		}
	}
}

/*
	Name: function_7eb2583b
	Namespace: czmtrain
	Checksum: 0x8836593C
	Offset: 0x2BE8
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function function_7eb2583b()
{
	timeout = 15;
	while(timeout > 0 && self flag::get("moving"))
	{
		timeout = timeout - 1;
		wait(1);
	}
}

/*
	Name: move
	Namespace: czmtrain
	Checksum: 0x47B4E91
	Offset: 0x2C48
	Size: 0x603
	Parameters: 0
	Flags: None
*/
function move()
{
	self.m_b_incoming = 0;
	str_start = self.m_str_station;
	str_left = self.m_a_s_stations[str_start].left_path;
	str_right = self.m_a_s_stations[str_start].right_path;
	if(self.m_a_s_stations[str_start].path_toward_junction == 0)
	{
		self.m_vh_train flip180();
		self.m_a_s_stations[str_start].path_toward_junction = switch_path_direction(self.m_a_s_stations[str_start].nodes, self.m_a_s_stations[str_start].path_toward_junction);
		self.m_vh_train switchstartnode(self.m_a_s_stations[str_start].start_node, self.m_a_s_stations[str_start].junction_node);
	}
	if(self.m_a_s_stations[str_left].path_toward_junction == 1)
	{
		self.m_a_s_stations[str_left].path_toward_junction = switch_path_direction(self.m_a_s_stations[str_left].nodes, self.m_a_s_stations[str_left].path_toward_junction);
		self.m_vh_train switchstartnode(self.m_a_s_stations[str_left].start_node, self.m_a_s_stations[str_left].junction_node);
	}
	if(self.m_a_s_stations[str_right].path_toward_junction == 1)
	{
		self.m_a_s_stations[str_right].path_toward_junction = switch_path_direction(self.m_a_s_stations[str_right].nodes, self.m_a_s_stations[str_right].path_toward_junction);
		self.m_vh_train switchstartnode(self.m_a_s_stations[str_right].start_node, self.m_a_s_stations[str_right].junction_node);
	}
	sndnum = self.m_a_s_stations[self.m_str_destination].audio_depart;
	level clientfield::set("sndTrainVox", sndnum);
	self.m_vh_train PlaySoundOnTag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
	thread watch_node_parameters();
	self.m_vh_train recalcsplinepaths();
	self.m_vh_train AttachPath(self.m_a_s_stations[str_start].start_node);
	self.m_vh_train StartPath();
	while(Distance2DSquared(self.m_vh_train.origin, self.m_a_s_stations[str_start].junction_node.origin) > 122500)
	{
		util::wait_network_frame();
	}
	enable_train_switches(0);
	thread function_a377ba46();
	str_chosen_path = str_left;
	if(!self.m_a_s_stations[str_start].b_left_path_active)
	{
		str_chosen_path = str_right;
	}
	which_way = self.m_a_s_stations[str_chosen_path].junction_node;
	self.m_vh_train setSwitchNode(self.m_a_s_stations[str_start].junction_node, self.m_a_s_stations[str_chosen_path].junction_node);
	self.m_b_incoming = 1;
	self.var_97fef807 = str_chosen_path;
	level flag::set(self.m_a_s_stations[str_chosen_path].str_zone_flag);
	self.m_vh_train waittill("reached_end_node");
	self.m_b_facing_forward = !self.m_b_facing_forward;
	self.m_str_station = str_chosen_path;
	self.m_str_destination = get_current_destination();
	self.m_vh_train notify("docked_in_station", self.m_str_station);
	sndnum = self.m_a_s_stations[self.m_str_station].audio_arrive;
	level clientfield::set("sndTrainVox", sndnum);
	self.m_vh_train PlaySoundOnTag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
}

/*
	Name: function_eb9ee200
	Namespace: czmtrain
	Checksum: 0x275C672C
	Offset: 0x3258
	Size: 0x13D
	Parameters: 1
	Flags: None
*/
function function_eb9ee200(spawnPos)
{
	foreach(e_player in level.players)
	{
		if(!zm_utility::is_player_valid(e_player, 0, 0))
		{
			continue;
		}
		porigin = e_player.origin;
		if(Abs(porigin[2] - spawnPos[2]) > 60)
		{
			continue;
		}
		distance_apart = Distance2D(porigin, spawnPos);
		if(Abs(distance_apart) > 18)
		{
			continue;
		}
		return 0;
	}
	return 1;
}

/*
	Name: function_a9acf9e2
	Namespace: czmtrain
	Checksum: 0xDBC35E55
	Offset: 0x33A0
	Size: 0x401
	Parameters: 0
	Flags: None
*/
function function_a9acf9e2()
{
	var_e19f73fe = [];
	foreach(e_player in level.players)
	{
		if(is_touching_train(e_player))
		{
			/#
				if(e_player IsInMoveMode("Dev Block strings are not supported", "Dev Block strings are not supported"))
				{
					continue;
				}
			#/
			if(!zm_utility::is_player_valid(e_player, 1, 0))
			{
				continue;
			}
			e_player.train_board_time = GetTime();
			if(!isdefined(var_e19f73fe))
			{
				var_e19f73fe = [];
			}
			else if(!IsArray(var_e19f73fe))
			{
				var_e19f73fe = Array(var_e19f73fe);
			}
			var_e19f73fe[var_e19f73fe.size] = e_player;
		}
	}
	self.m_vh_train waittill("docked_in_station");
	train_center = self.m_vh_train GetCentroid();
	fell_off = 0;
	foreach(e_player in var_e19f73fe)
	{
		/#
			if(e_player IsInMoveMode("Dev Block strings are not supported", "Dev Block strings are not supported"))
			{
				continue;
			}
		#/
		if(!zm_utility::is_player_valid(e_player, 1, 0))
		{
			continue;
		}
		if(!isdefined(e_player.train_board_time))
		{
			continue;
		}
		if(isdefined(e_player.last_bleed_out_time) && e_player.last_bleed_out_time > e_player.train_board_time)
		{
			continue;
		}
		if(!is_touching_train(e_player))
		{
			fatal = 0;
			do
			{
				spawnPos = train_center;
				switch(fell_off)
				{
					case 0:
					{
						spawnPos = spawnPos + VectorScale((1, 1, 0), 36);
						break;
					}
					case 1:
					{
						spawnPos = spawnPos + VectorScale((-1, -1, 0), 36);
						break;
					}
					case 2:
					{
						spawnPos = spawnPos + VectorScale((1, -1, 0), 36);
						break;
					}
					case 3:
					{
						spawnPos = spawnPos + VectorScale((-1, 1, 0), 36);
						break;
					}
					case 4:
					{
						e_player DoDamage(1000, (0, 0, 0));
						fatal = 1;
						continue;
					}
				}
				fell_off++;
			}
			while(!(!fatal && !function_eb9ee200(spawnPos)));
			e_player SetOrigin(spawnPos);
		}
	}
}

/*
	Name: flip_forward
	Namespace: czmtrain
	Checksum: 0x4FA3ACD0
	Offset: 0x37B0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function flip_forward()
{
	self.m_b_facing_forward = !self.m_b_facing_forward;
}

/*
	Name: initialize_stations
	Namespace: czmtrain
	Checksum: 0x7762DE6C
	Offset: 0x37D0
	Size: 0x921
	Parameters: 0
	Flags: None
*/
function initialize_stations()
{
	self.m_a_s_stations = [];
	a_path_nodes = GetNodeArray("train_pathnode", "targetname");
	foreach(nd in a_path_nodes)
	{
		str_station = nd.script_string;
		self.m_a_s_stations[str_station] = spawnstruct();
		self.m_a_s_stations[str_station].path_node = nd;
		self.m_a_s_stations[str_station].origin = nd.origin;
		self.m_a_s_stations[str_station].angles = nd.angles;
		self.m_a_s_stations[str_station].station_id = str_station;
		self.m_a_s_stations[str_station].door_side = nd.script_parameters;
	}
	self.m_a_s_stations["slums"].left_path = "canal";
	self.m_a_s_stations["slums"].right_path = "theater";
	self.m_a_s_stations["slums"].b_left_path_active = 0;
	self.m_a_s_stations["slums"].str_zone_flag = "activate_slums_waterfront";
	self.m_a_s_stations["slums"].audio_divert = 8;
	self.m_a_s_stations["slums"].audio_depart = 5;
	self.m_a_s_stations["slums"].audio_arrive = 1;
	self.m_a_s_stations["slums"].start_node = GetVehicleNode("a1", "targetname");
	self.m_a_s_stations["theater"].left_path = "slums";
	self.m_a_s_stations["theater"].right_path = "canal";
	self.m_a_s_stations["theater"].b_left_path_active = 0;
	self.m_a_s_stations["theater"].str_zone_flag = "activate_theater_square";
	self.m_a_s_stations["theater"].audio_divert = 9;
	self.m_a_s_stations["theater"].audio_depart = 6;
	self.m_a_s_stations["theater"].audio_arrive = 2;
	self.m_a_s_stations["theater"].start_node = GetVehicleNode("b1", "targetname");
	self.m_a_s_stations["canal"].left_path = "theater";
	self.m_a_s_stations["canal"].right_path = "slums";
	self.m_a_s_stations["canal"].b_left_path_active = 0;
	self.m_a_s_stations["canal"].str_zone_flag = "activate_brothel_street";
	self.m_a_s_stations["canal"].audio_divert = 7;
	self.m_a_s_stations["canal"].audio_depart = 4;
	self.m_a_s_stations["canal"].audio_arrive = 3;
	self.m_a_s_stations["canal"].start_node = GetVehicleNode("c1", "targetname");
	level.var_98f27ad = Array("vox_tanc_board_canal_0", "vox_tanc_board_slums_0", "vox_tanc_board_theater_0", "vox_tanc_depart_canal_0", "vox_tanc_depart_slums_0", "vox_tanc_depart_theater_0", "vox_tanc_divert_canal_0", "vox_tanc_divert_slums_0", "vox_tanc_divert_theater_0");
	a_keys = getArrayKeys(self.m_a_s_stations);
	for(i = 0; i < a_keys.size; i++)
	{
		str_key = a_keys[i];
		nd_next = self.m_a_s_stations[str_key].start_node;
		nd_prev = undefined;
		self.m_a_s_stations[str_key].nodes = [];
		while(isdefined(nd_next))
		{
			if(isdefined(nd_prev))
			{
				nd_next.target2 = nd_prev.targetname;
			}
			if(!isdefined(self.m_a_s_stations[str_key].nodes))
			{
				self.m_a_s_stations[str_key].nodes = [];
			}
			else if(!IsArray(self.m_a_s_stations[str_key].nodes))
			{
				self.m_a_s_stations[str_key].nodes = Array(self.m_a_s_stations[str_key].nodes);
			}
			self.m_a_s_stations[str_key].nodes[self.m_a_s_stations[str_key].nodes.size] = nd_next;
			nd_prev = nd_next;
			if(!isdefined(nd_next.target))
			{
				break;
			}
			else
			{
				nd_next = GetVehicleNode(nd_next.target, "targetname");
			}
		}
		num_nodes = self.m_a_s_stations[str_key].nodes.size;
		self.m_a_s_stations[str_key].junction_node = self.m_a_s_stations[str_key].nodes[num_nodes - 1];
		self.m_a_s_stations[str_key].path_toward_junction = 1;
	}
	a_callboxes = GetEntArray("train_call_lever", "targetname");
	foreach(e_callbox in a_callboxes)
	{
		e_station_closest = ArrayGetClosest(e_callbox.origin, self.m_a_s_stations);
		/#
			Assert(isdefined(e_station_closest));
		#/
		e_callbox.script_string = e_station_closest.station_id;
		e_station_closest.callbox = e_callbox;
	}
}

/*
	Name: Initialize
	Namespace: czmtrain
	Checksum: 0x5CAA134C
	Offset: 0x4100
	Size: 0x8B1
	Parameters: 1
	Flags: None
*/
function Initialize(e_train)
{
	/#
		Assert(isdefined(e_train));
	#/
	self.m_vh_train = e_train;
	self.m_vh_train.var_619deb2d = 0;
	self.m_vh_train.var_901503d0 = 0;
	if(!self flag::exists("moving"))
	{
		self flag::init("moving", 0);
	}
	if(!self flag::exists("cooldown"))
	{
		self flag::init("cooldown", 0);
	}
	if(!self flag::exists("offline"))
	{
		self flag::init("offline", 0);
	}
	if(!self flag::exists("switches_enabled"))
	{
		self flag::init("switches_enabled", 1);
	}
	if(!level flag::exists("callbox"))
	{
		level flag::init("callbox");
	}
	self.m_vh_train.team = "spectator";
	initialize_stations();
	/#
		thread debug_draw_paths();
		thread debug_draw_doors();
	#/
	a_e_children = GetEntArray(self.m_vh_train.target, "targetname");
	foreach(e_ent in a_e_children)
	{
		if(isdefined(e_ent.script_string))
		{
			if(e_ent.script_string == "train_volume")
			{
				if(!isdefined(self.m_e_volume))
				{
					/#
						Assert(!isdefined(self.m_e_volume));
					#/
					e_ent EnableLinkTo();
					self.m_e_volume = e_ent;
				}
			}
			else if(e_ent.script_string == "train_rear_door" || e_ent.script_string == "train_front_door")
			{
				if(!isdefined(e_ent.script_origin))
				{
					e_ent.script_origin = spawn("script_origin", e_ent.origin);
					e_ent.script_origin.angles = self.m_vh_train.angles;
					e_ent.script_origin LinkTo(self.m_vh_train);
				}
				if(!isdefined(self.m_a_mdl_doors))
				{
					self.m_a_mdl_doors = [];
				}
				else if(!IsArray(self.m_a_mdl_doors))
				{
					self.m_a_mdl_doors = Array(self.m_a_mdl_doors);
				}
				self.m_a_mdl_doors[self.m_a_mdl_doors.size] = e_ent;
			}
			e_ent LinkTo(self.m_vh_train);
			continue;
		}
		/#
			IPrintLnBold("Dev Block strings are not supported" + namespace_8e578893::vec_to_string(e_ent.origin) + "Dev Block strings are not supported");
		#/
	}
	function_6f6ab7a4();
	/#
		if(!isdefined(self.m_e_volume))
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + namespace_8e578893::vec_to_string(self.m_vh_train.origin) + "Dev Block strings are not supported");
			#/
		}
	#/
	self.m_vh_train function_a8e2d7ff();
	self.m_t_switch = GetEnt("m_s_switch_trigger", "targetname");
	self.m_t_switch TriggerIgnoreTeam();
	self.m_t_switch SetTeamForTrigger("none");
	self.m_t_switch setHintString(&"ZM_ZOD_SWITCH_DISABLE");
	self.m_t_switch setcursorhint("HINT_NOICON");
	self.m_t_switch EnableLinkTo();
	self.m_t_switch LinkTo(self.m_vh_train);
	self.m_t_switch.player_used = 0;
	thread main();
	a_callboxes = GetEntArray("train_call_lever", "targetname");
	foreach(e_callbox in a_callboxes)
	{
		thread run_callbox(e_callbox.script_string);
	}
	a_gates = GetEntArray("train_gate", "targetname");
	foreach(gate in a_gates)
	{
		station = self.m_a_s_stations[gate.script_string];
		if(!isdefined(station.gates))
		{
			station.gates = [];
		}
		if(!isdefined(station.gates))
		{
			station.gates = [];
		}
		else if(!IsArray(station.gates))
		{
			station.gates = Array(station.gates);
		}
		station.gates[station.gates.size] = gate;
		jump_nodes = GetNodeArray(station.path_node.target, "targetname");
		self thread run_gate(gate, jump_nodes);
	}
}

/*
	Name: function_6f6ab7a4
	Namespace: czmtrain
	Checksum: 0x3A33B794
	Offset: 0x49C0
	Size: 0x1A9
	Parameters: 0
	Flags: None
*/
function function_6f6ab7a4()
{
	for(i = 0; i < self.m_a_mdl_doors.size; i++)
	{
		e_door = self.m_a_mdl_doors[i];
		e_door Hide();
		if(e_door.script_string == "train_front_door")
		{
			e_door.e_clip = GetEnt("train_front_clip", "script_string");
		}
		else if(e_door.script_string == "train_rear_door")
		{
			e_door.e_clip = GetEnt("train_rear_clip", "script_string");
		}
		if(isdefined(e_door.e_clip))
		{
			e_origin = spawn("script_origin", e_door.e_clip.origin);
			e_origin.angles = self.m_vh_train.angles;
			e_origin LinkTo(self.m_vh_train);
			e_door.e_clip.var_b620e1b1 = e_origin;
		}
	}
}

/*
	Name: main
	Namespace: czmtrain
	Checksum: 0xC784593D
	Offset: 0x4B78
	Size: 0x7AF
	Parameters: 0
	Flags: None
*/
function main()
{
	a_path_names = getArrayKeys(self.m_a_s_stations);
	a_path_names = Array::randomize(a_path_names);
	self.m_str_station = a_path_names[0];
	self.var_97fef807 = self.m_str_station;
	self.m_a_s_stations[self.m_str_station].b_left_path_active = RandomInt(2);
	self.m_str_destination = get_current_destination();
	self.m_vh_train AttachPath(self.m_a_s_stations[self.m_str_station].start_node);
	b_first_run = 1;
	self thread function_876255();
	self thread watch_players_on_train();
	self thread function_955e57a7();
	wait(1);
	v_front = self.m_vh_train GetTagOrigin("tag_button_front");
	self.m_s_trigger = namespace_8e578893::spawn_trigger_radius(v_front, 60, 1);
	self.m_vh_train PlayLoopSound("evt_train_idle_loop", 4);
	open_doors();
	thread run_switch();
	while(1)
	{
		update_use_trigger();
		enable_train_switches(1);
		level thread function_b0af9dac();
		while(1)
		{
			self.m_vh_train clientfield::set("train_switch_light", 1);
			self.m_s_trigger waittill("trigger", e_who);
			self.m_vh_train clientfield::set("train_switch_light", 0);
			if(self.m_b_free)
			{
				self.m_b_free = 0;
				break;
			}
			else if(!e_who zm_score::can_player_purchase(500))
			{
				e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			}
			else
			{
				e_who zm_score::minus_to_player_score(500);
				e_who zm_audio::create_and_play_dialog("train", "start");
				break;
			}
		}
		level.var_33c4ee76++;
		thread function_a377ba46();
		wait(0.05);
		self flag::set("moving");
		zm_unitrigger::unregister_unitrigger(self.m_s_trigger);
		self.m_s_trigger = undefined;
		close_doors();
		self.m_vh_train playsound("evt_train_start");
		self.m_vh_train PlayLoopSound("evt_train_loop", 4);
		var_8d722bd4 = function_ccd778ab();
		if(var_8d722bd4 || b_first_run)
		{
			self.m_vh_train SetSpeed(32);
		}
		else
		{
			level.b_host_migration_force_player_respawn = 1;
			thread function_a9acf9e2();
		}
		move();
		self.m_vh_train PlayLoopSound("evt_train_idle_loop", 4);
		a_riders = get_players_on_train(0);
		if(a_riders.size > 0)
		{
			level flag::set(self.m_a_s_stations[self.m_str_station].str_zone_flag);
			level flag::set("train_rode_to_" + self.m_str_station);
		}
		if(var_8d722bd4 || b_first_run)
		{
			self.m_vh_train ResumeSpeed();
		}
		if(b_first_run)
		{
			b_first_run = 0;
		}
		open_doors();
		a_riders = get_players_on_train(0);
		if(a_riders.size > 0)
		{
			var_3a349c58 = a_riders[RandomInt(a_riders.size)];
			var_3a349c58 zm_audio::create_and_play_dialog("train", "stop");
		}
		v_trig = (0, 0, 0);
		if(!self.m_b_facing_forward)
		{
			v_trig = self.m_vh_train GetTagOrigin("tag_button_back");
		}
		else
		{
			v_trig = self.m_vh_train GetTagOrigin("tag_button_front");
		}
		self flag::clear("moving");
		level.b_host_migration_force_player_respawn = 0;
		self function_312bb6e1();
		if(!self.m_b_free && level.var_33c4ee76 > 0)
		{
			self flag::set("cooldown");
			update_use_trigger();
			n_wait = 40;
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					n_wait = 5;
				}
			#/
			wait(n_wait);
			self.m_s_trigger = namespace_8e578893::spawn_trigger_radius(v_trig, 60, 1);
			self flag::clear("cooldown");
		}
		else
		{
			self.m_s_trigger = namespace_8e578893::spawn_trigger_radius(v_trig, 60, 1);
		}
	}
}

/*
	Name: function_a377ba46
	Namespace: czmtrain
	Checksum: 0x722C5A18
	Offset: 0x5330
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_a377ba46()
{
	if(flag::get("moving"))
	{
		var_38c97a3b = get_current_destination();
	}
	else
	{
		var_38c97a3b = self.m_str_station;
	}
	switch(var_38c97a3b)
	{
		case "slums":
		{
			var_bddb9113 = "lgt_exp_train_slums_debug";
			break;
		}
		case "canal":
		{
			var_bddb9113 = "lgt_exp_train_canals_debug";
			break;
		}
		case "theater":
		{
			var_bddb9113 = "lgt_exp_train_theater_debug";
			break;
		}
	}
	if(flag::get("moving"))
	{
		exploder::exploder(var_bddb9113);
	}
	else
	{
		wait(2);
		exploder::exploder_stop(var_bddb9113);
	}
}

/*
	Name: function_312bb6e1
	Namespace: czmtrain
	Checksum: 0xFD33D9E3
	Offset: 0x5440
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_312bb6e1()
{
	level endon("hash_12be7dbb");
	if(level flag::get("ee_boss_defeated") && !level flag::get("ee_final_boss_defeated"))
	{
		return;
	}
	if(level.var_33c4ee76 < 5)
	{
		return;
	}
	self flag::set("offline");
	self.m_vh_train clientfield::set("train_switch_light", 2);
	update_use_trigger();
	level waittill("between_round_over");
	self flag::clear("offline");
	wait(0.05);
}

/*
	Name: function_955e57a7
	Namespace: czmtrain
	Checksum: 0xB2896446
	Offset: 0x5538
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_955e57a7()
{
	level flag::wait_till("ee_boss_defeated");
	level notify("hash_12be7dbb");
	self flag::clear("offline");
	update_use_trigger();
}

/*
	Name: function_b0af9dac
	Namespace: czmtrain
	Checksum: 0x6D6EFD06
	Offset: 0x55A0
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_b0af9dac()
{
	while(1)
	{
		level waittill("between_round_over");
		level.var_33c4ee76 = 0;
		wait(0.05);
	}
}

/*
	Name: run_callbox_hintstring
	Namespace: czmtrain
	Checksum: 0x47FC1C3E
	Offset: 0x55D8
	Size: 0x257
	Parameters: 3
	Flags: None
*/
function run_callbox_hintstring(str_callbox, t_use, e_light)
{
	while(1)
	{
		if(self.m_str_station == str_callbox)
		{
			e_light clientfield::set("train_callbox_light", 0);
			t_use namespace_8e578893::set_unitrigger_hint_string(&"");
		}
		else
		{
			e_light clientfield::set("train_callbox_light", 1);
			t_use namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_CALL", 500);
		}
		self flag::wait_till("moving");
		e_light clientfield::set("train_callbox_light", 0);
		t_use namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_MOVING");
		self flag::wait_till_clear("moving");
		wait(0.05);
		if(self flag::get("offline"))
		{
			t_use namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_OFFLINE");
			e_light clientfield::set("train_callbox_light", 2);
			self flag::wait_till_clear("offline");
		}
		else if(self.m_str_station == str_callbox)
		{
			t_use namespace_8e578893::set_unitrigger_hint_string(&"");
			self flag::wait_till_clear("cooldown");
		}
		else
		{
			t_use namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_COOLDOWN");
			self flag::wait_till_clear("cooldown");
		}
	}
}

/*
	Name: run_callbox
	Namespace: czmtrain
	Checksum: 0x83A1C33E
	Offset: 0x5838
	Size: 0x25F
	Parameters: 1
	Flags: None
*/
function run_callbox(str_callbox)
{
	/#
		Assert(isdefined(self.m_str_station));
	#/
	e_lever = self.m_a_s_stations[str_callbox].callbox;
	t_use = namespace_8e578893::spawn_trigger_radius(e_lever.origin, 60, 1);
	thread run_callbox_hintstring(str_callbox, t_use, GetEnt(e_lever.target, "targetname"));
	while(1)
	{
		t_use waittill("trigger", e_who);
		if(!e_who zm_score::can_player_purchase(500))
		{
			e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			continue;
		}
		if(self.m_str_station != str_callbox && isdefined(self.m_s_trigger))
		{
			self.m_b_free = 0;
			if(str_callbox != self.m_str_destination)
			{
				level flag::set("callbox");
				self.m_t_switch notify("trigger");
				level waittill("hash_8939bd21");
			}
			self.m_s_trigger notify("trigger", e_who);
			util::wait_network_frame();
			self.m_b_free = 1;
			e_lever RotatePitch(180, 0.5);
			self flag::wait_till("moving");
			self flag::wait_till_clear("moving");
			e_lever RotatePitch(-180, 0.5);
		}
	}
}

/*
	Name: run_gate
	Namespace: czmtrain
	Checksum: 0xF14137D4
	Offset: 0x5AA0
	Size: 0x34F
	Parameters: 2
	Flags: None
*/
function run_gate(e_gate, a_jump_nodes)
{
	nd_start = self.m_a_s_stations[e_gate.script_string].start_node;
	v_open = e_gate.origin;
	v_closed = v_open + AnglesToForward(nd_start.angles) * 96;
	if(self.m_a_s_stations[e_gate.script_string].door_side == "right")
	{
		v_closed = v_open - AnglesToForward(nd_start.angles) * 96;
	}
	b_open = 1;
	while(1)
	{
		if(b_open)
		{
			self.var_9e0dc993 = 0;
			e_gate moveto(v_closed, 1);
			b_open = 0;
			foreach(nd in a_jump_nodes)
			{
				UnlinkTraversal(nd);
			}
		}
		self flag::wait_till_clear("moving");
		if(self.m_str_station == e_gate.script_string)
		{
			e_gate moveto(v_open, 1);
			b_open = 1;
			e_gate waittill("movedone");
			foreach(nd in a_jump_nodes)
			{
				b_fwd_node = nd.script_string === "forward";
				if(self.m_b_facing_forward && b_fwd_node || (!self.m_b_facing_forward && !b_fwd_node))
				{
					LinkTraversal(nd);
				}
			}
			self.var_9e0dc993 = 1;
		}
		self flag::wait_till("moving");
		wait(1);
	}
}

/*
	Name: get_door_open_pos
	Namespace: czmtrain
	Checksum: 0x6ED9E238
	Offset: 0x5DF8
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function get_door_open_pos(e_door)
{
	if(e_door.script_string == "front_door")
	{
		return e_door.script_origin.origin - AnglesToForward(e_door.script_origin.angles) * 100;
	}
	else
	{
		return e_door.script_origin.origin + AnglesToForward(e_door.script_origin.angles) * 100;
	}
}

/*
	Name: get_door_closed_pos
	Namespace: czmtrain
	Checksum: 0xD4D64F94
	Offset: 0x5EC0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_door_closed_pos(e_door)
{
	return e_door.script_origin.origin;
}

/*
	Name: get_open_side
	Namespace: czmtrain
	Checksum: 0xD2C82C3A
	Offset: 0x5EF0
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function get_open_side()
{
	str_side = self.m_a_s_stations[self.m_str_station].door_side;
	if(!self.m_b_facing_forward)
	{
		if(str_side == "left")
		{
			return "right";
		}
		else if(str_side == "right")
		{
			return "left";
		}
	}
	return str_side;
}

/*
	Name: is_door_open
	Namespace: czmtrain
	Checksum: 0x34141D98
	Offset: 0x5F68
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function is_door_open(e_door)
{
	str_side = get_open_side();
	if(str_side == "left" && e_door.script_string == "train_rear_door" || (str_side == "right" && e_door.script_string == "train_front_door"))
	{
		return self.var_9e0dc993;
	}
	return 0;
}

/*
	Name: open_doors
	Namespace: czmtrain
	Checksum: 0x16F263C8
	Offset: 0x6000
	Size: 0x417
	Parameters: 1
	Flags: None
*/
function open_doors(str_side)
{
	if(!isdefined(str_side))
	{
		str_side = get_open_side();
	}
	self.m_vh_train open_door_anim(str_side);
	var_7631d55c = VectorScale((0, 0, 1), 300);
	a_doors_moved = [];
	foreach(e_door in self.m_a_mdl_doors)
	{
		if(!isdefined(str_side) || (str_side == "left" && e_door.script_string == "train_rear_door") || (str_side == "right" && e_door.script_string == "train_front_door"))
		{
			v_pos = get_door_open_pos(e_door);
			e_door Unlink();
			e_door moveto(v_pos, 0.3);
			if(!isdefined(a_doors_moved))
			{
				a_doors_moved = [];
			}
			else if(!IsArray(a_doors_moved))
			{
				a_doors_moved = Array(a_doors_moved);
			}
			a_doors_moved[a_doors_moved.size] = e_door;
			e_door.e_clip Unlink();
			e_door.e_clip moveto(e_door.e_clip.origin + var_7631d55c, 0.3);
		}
	}
	if(a_doors_moved.size > 0)
	{
		a_doors_moved[0] waittill("movedone");
		util::wait_network_frame();
	}
	util::wait_network_frame();
	foreach(e_door in a_doors_moved)
	{
		v_pos = get_door_open_pos(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door LinkTo(self.m_vh_train);
		e_door.e_clip LinkTo(self.m_vh_train);
	}
	for(i = self.m_a_zombies_locked_in.size - 1; i >= 0; i--)
	{
		ai = self.m_a_zombies_locked_in[i];
		if(isdefined(ai))
		{
			remove_zombie_locked_in(ai);
		}
	}
	self.m_a_zombies_locked_in = [];
}

/*
	Name: open_door_anim
	Namespace: czmtrain
	Checksum: 0x6EA4B71E
	Offset: 0x6420
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function open_door_anim(str_side)
{
	if(str_side == "right")
	{
		if(!self.var_901503d0)
		{
			self thread scene::Play("p7_fxanim_zm_zod_train_door_rt_open_bundle", self);
			self.var_901503d0 = 1;
		}
	}
	else if(!self.var_619deb2d)
	{
		self thread scene::Play("p7_fxanim_zm_zod_train_door_lft_open_bundle", self);
		self.var_619deb2d = 1;
	}
}

/*
	Name: close_doors
	Namespace: czmtrain
	Checksum: 0x2A64A2CD
	Offset: 0x64B0
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function close_doors()
{
	self.m_vh_train function_285f0f0b();
	foreach(e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door Unlink();
		e_door moveto(v_pos, 0.3);
		e_door.e_clip Unlink();
		e_door.e_clip moveto(e_door.e_clip.var_b620e1b1.origin, 0.3);
	}
	self.m_a_mdl_doors[0] waittill("movedone");
	util::wait_network_frame();
	foreach(e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door LinkTo(self.m_vh_train);
		e_door.e_clip LinkTo(self.m_vh_train);
	}
	thread recalc_zombies_locked_in_train();
}

/*
	Name: function_9211290c
	Namespace: czmtrain
	Checksum: 0x870CAA11
	Offset: 0x6738
	Size: 0x251
	Parameters: 0
	Flags: None
*/
function function_9211290c()
{
	foreach(e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door Unlink();
		e_door moveto(v_pos, 0.3);
		e_door.e_clip Unlink();
		e_door.e_clip moveto(e_door.e_clip.var_b620e1b1.origin, 0.3);
	}
	self.m_a_mdl_doors[0] waittill("movedone");
	util::wait_network_frame();
	foreach(e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door LinkTo(self.m_vh_train);
		e_door.e_clip LinkTo(self.m_vh_train);
	}
}

/*
	Name: function_285f0f0b
	Namespace: czmtrain
	Checksum: 0xADD75752
	Offset: 0x6998
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_285f0f0b()
{
	if(self.var_901503d0)
	{
		self scene::Play("p7_fxanim_zm_zod_train_door_rt_close_bundle", self);
		self.var_901503d0 = 0;
	}
	if(self.var_619deb2d)
	{
		self scene::Play("p7_fxanim_zm_zod_train_door_lft_close_bundle", self);
		self.var_619deb2d = 0;
	}
}

/*
	Name: recalc_zombies_locked_in_train
	Namespace: czmtrain
	Checksum: 0xE99250E8
	Offset: 0x6A10
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function recalc_zombies_locked_in_train()
{
	zombies = GetAITeamArray(level.zombie_team);
	n_counter = 0;
	foreach(zombie in zombies)
	{
		if(!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}
		if(is_touching_train_volume(zombie))
		{
			add_zombie_locked_in(zombie);
		}
		n_counter++;
		if(n_counter % 3 == 0)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: update_use_trigger
	Namespace: czmtrain
	Checksum: 0x169B5F65
	Offset: 0x6B48
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function update_use_trigger()
{
	if(!isdefined(self.m_s_trigger))
	{
		return;
	}
	if(self.m_b_free)
	{
		self.m_s_trigger namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_USE_FREE");
	}
	else if(is_offline())
	{
		self.m_s_trigger namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_OFFLINE");
	}
	else if(is_cooling_down())
	{
		self.m_s_trigger namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_COOLDOWN");
	}
	else
	{
		self.m_s_trigger namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_USE", 500);
	}
}

/*
	Name: send_train
	Namespace: czmtrain
	Checksum: 0xB2E91FB7
	Offset: 0x6C28
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function send_train()
{
	if(isdefined(self.m_s_trigger))
	{
		self.m_b_free = 1;
		self.m_s_trigger notify("trigger");
	}
}

/*
	Name: run_switch
	Namespace: czmtrain
	Checksum: 0xC6967EB0
	Offset: 0x6C60
	Size: 0x21D
	Parameters: 0
	Flags: None
*/
function run_switch()
{
	while(1)
	{
		function_de6e1f4f(self.m_t_switch);
		str_prev_dest = self.m_str_destination;
		if(self.m_t_switch.player_used)
		{
			self.m_a_s_stations[self.m_str_station].b_left_path_active = !self.m_a_s_stations[self.m_str_station].b_left_path_active;
			self.m_str_destination = get_current_destination();
		}
		if(self.m_str_destination != str_prev_dest)
		{
			function_ca899bfc();
			if(is_moving() && !level flag::get("callbox"))
			{
				sndnum = self.m_a_s_stations[self.m_str_destination].audio_divert;
				level clientfield::set("sndTrainVox", sndnum);
				self.m_vh_train PlaySoundOnTag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
			}
			if(level flag::get("callbox"))
			{
				level flag::clear("callbox");
			}
			self.m_t_switch setHintString(&"ZM_ZOD_SWITCHING_PROGRESS");
			wait(1);
			if(flag::get("switches_enabled"))
			{
				self.m_t_switch setHintString(&"ZM_ZOD_SWITCH_ENABLE");
			}
		}
		level notify("hash_8939bd21");
	}
}

/*
	Name: function_de6e1f4f
	Namespace: czmtrain
	Checksum: 0x56F3A46
	Offset: 0x6E88
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_de6e1f4f(m_t_switch)
{
	self.m_vh_train endon("hash_51689c0f");
	if(!flag::get("switches_enabled"))
	{
		flag::wait_till("switches_enabled");
	}
	m_t_switch.player_used = 0;
	m_t_switch waittill("trigger");
	m_t_switch.player_used = 1;
}

/*
	Name: function_ca899bfc
	Namespace: czmtrain
	Checksum: 0x82EF5413
	Offset: 0x6F10
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function function_ca899bfc()
{
	if(self.m_str_destination == "slums")
	{
		self.m_vh_train HidePart("tag_sign_footlight");
		self.m_vh_train HidePart("tag_sign_canals");
		self.m_vh_train ShowPart("tag_sign_waterfront");
		playsoundatposition("evt_train_switch_track_hit", self.m_t_switch.origin);
	}
	else if(self.m_str_destination == "theater")
	{
		self.m_vh_train HidePart("tag_sign_canals");
		self.m_vh_train HidePart("tag_sign_waterfront");
		self.m_vh_train ShowPart("tag_sign_footlight");
		playsoundatposition("evt_train_switch_track_hit", self.m_t_switch.origin);
	}
	else if(self.m_str_destination == "canal")
	{
		self.m_vh_train HidePart("tag_sign_footlight");
		self.m_vh_train HidePart("tag_sign_waterfront");
		self.m_vh_train ShowPart("tag_sign_canals");
		playsoundatposition("evt_train_switch_track_hit", self.m_t_switch.origin);
	}
}

/*
	Name: function_ccd778ab
	Namespace: czmtrain
	Checksum: 0x669AB6C6
	Offset: 0x7100
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_ccd778ab()
{
	foreach(e_player in level.players)
	{
		if(is_touching_train(e_player))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: watch_players_on_train
	Namespace: czmtrain
	Checksum: 0x16D9C3ED
	Offset: 0x71A0
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function watch_players_on_train()
{
	/#
		foreach(e_player in level.players)
		{
			/#
				Assert(isdefined(e_player.on_train));
			#/
		}
	#/
	while(1)
	{
		foreach(e_player in level.players)
		{
			e_player.on_train = is_touching_train(e_player);
		}
		wait(0.5);
	}
}

/*
	Name: is_touching_train
	Namespace: czmtrain
	Checksum: 0xDF58DF76
	Offset: 0x72F0
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function is_touching_train(e_ent)
{
	return e_ent istouching(self.m_e_volume);
}

/*
	Name: watch_zombie_fall_off
	Namespace: czmtrain
	Checksum: 0xCD16708F
	Offset: 0x7328
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function watch_zombie_fall_off(ai)
{
	ai endon("death");
	ai endon("released_from_train");
	zm_net::network_safe_init("train_fall_check", 1);
	while(self zm_net::network_choke_action("train_fall_check", &is_touching_train, ai))
	{
		wait(2);
	}
	remove_zombie_locked_in(ai);
}

/*
	Name: is_touching_train_volume
	Namespace: czmtrain
	Checksum: 0x78AAE0B6
	Offset: 0x73D0
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function is_touching_train_volume(ent)
{
	return ent istouching(self.m_e_volume);
}

/*
	Name: get_players_on_train
	Namespace: czmtrain
	Checksum: 0xB9A1FCB3
	Offset: 0x7408
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function get_players_on_train(b_valid_targets_only)
{
	if(!isdefined(b_valid_targets_only))
	{
		b_valid_targets_only = 0;
	}
	a_players = [];
	foreach(e_player in level.players)
	{
		if(b_valid_targets_only && (e_player.ignoreme || !zm_utility::is_player_valid(e_player)))
		{
			continue;
		}
		if(e_player.on_train)
		{
			if(!isdefined(a_players))
			{
				a_players = [];
			}
			else if(!IsArray(a_players))
			{
				a_players = Array(a_players);
			}
			a_players[a_players.size] = e_player;
		}
	}
	return a_players;
}

/*
	Name: add_zombie_locked_in
	Namespace: czmtrain
	Checksum: 0x7D5F2F11
	Offset: 0x7560
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function add_zombie_locked_in(ai_zombie)
{
	ai_zombie.locked_in_train = 1;
	Array::add(self.m_a_zombies_locked_in, ai_zombie, 0);
	thread watch_zombie_fall_off(ai_zombie);
}

/*
	Name: remove_zombie_locked_in
	Namespace: czmtrain
	Checksum: 0x1A0CCCA2
	Offset: 0x75C0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function remove_zombie_locked_in(ai_zombie)
{
	ai_zombie.locked_in_train = 0;
	ArrayRemoveValue(self.m_a_zombies_locked_in, ai_zombie);
	ai_zombie notify("released_from_train");
}

/*
	Name: locked_in_list_remove_undefined
	Namespace: czmtrain
	Checksum: 0x2855851E
	Offset: 0x7618
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function locked_in_list_remove_undefined()
{
	self.m_a_zombies_locked_in = Array::remove_undefined(self.m_a_zombies_locked_in);
}

/*
	Name: get_zombies_locked_in
	Namespace: czmtrain
	Checksum: 0x4E3CC587
	Offset: 0x7648
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_zombies_locked_in()
{
	return self.m_a_zombies_locked_in;
}

/*
	Name: get_time_since_last_jumper
	Namespace: czmtrain
	Checksum: 0x4F33D043
	Offset: 0x7660
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function get_time_since_last_jumper()
{
	return float(GetTime() - self.m_n_last_jumper_time) / 1000;
}

/*
	Name: mark_jumper_time
	Namespace: czmtrain
	Checksum: 0x6857928C
	Offset: 0x7698
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function mark_jumper_time()
{
	self.m_n_last_jumper_time = GetTime();
}

/*
	Name: jump_into_train
	Namespace: czmtrain
	Checksum: 0x1C2AC7C1
	Offset: 0x76B0
	Size: 0x18B
	Parameters: 2
	Flags: None
*/
function jump_into_train(ai, str_tag)
{
	self endon("death");
	s_tag = self.m_a_jumptags[str_tag];
	s_tag.occupied = 1;
	v_tag_pos = self.m_vh_train GetTagOrigin(str_tag);
	v_tag_angles = self.m_vh_train GetTagAngles(str_tag);
	ai teleport(v_tag_pos, v_tag_angles);
	util::wait_network_frame();
	ai LinkTo(self.m_vh_train, str_tag);
	ai AnimScripted("entered_train", v_tag_pos, v_tag_angles, s_tag.str_anim);
	ai zombie_shared::DoNoteTracks("entered_train");
	ai Unlink();
	s_tag.occupied = 0;
	if(is_moving())
	{
		add_zombie_locked_in(ai);
	}
}

/*
	Name: get_junction_origin
	Namespace: czmtrain
	Checksum: 0xCF2A6F09
	Offset: 0x7848
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function get_junction_origin()
{
	v_origin = (0, 0, 0);
	foreach(s_station in self.m_a_s_stations)
	{
		v_origin = v_origin + s_station.junction_node.origin;
	}
	v_origin = v_origin / float(self.m_a_s_stations.size);
	return v_origin;
}

/*
	Name: is_moving
	Namespace: czmtrain
	Checksum: 0x4DB9E472
	Offset: 0x7928
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function is_moving()
{
	return self flag::get("moving");
}

/*
	Name: get_doors_state
	Namespace: czmtrain
	Checksum: 0x55BB8013
	Offset: 0x7958
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_doors_state()
{
	return self.var_9e0dc993;
}

/*
	Name: is_cooling_down
	Namespace: czmtrain
	Checksum: 0x73C29708
	Offset: 0x7970
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function is_cooling_down()
{
	return self flag::get("cooldown");
}

/*
	Name: is_offline
	Namespace: czmtrain
	Checksum: 0x58B6AC15
	Offset: 0x79A0
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function is_offline()
{
	return self flag::get("offline");
}

/*
	Name: any_player_facing_tag
	Namespace: czmtrain
	Checksum: 0x89FC4974
	Offset: 0x79D0
	Size: 0x127
	Parameters: 1
	Flags: Private
*/
function private any_player_facing_tag(str_tag)
{
	foreach(e_player in level.players)
	{
		v_pos = self.m_vh_train GetTagOrigin(str_tag);
		v_fwd = AnglesToForward(e_player.angles);
		v_to_tag = VectorNormalize(v_pos - e_player.origin);
		if(VectorDot(v_fwd, v_to_tag) > 0)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: get_available_jumptag
	Namespace: czmtrain
	Checksum: 0xA8D9047B
	Offset: 0x7B00
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function get_available_jumptag()
{
	a_valid_tags = [];
	foreach(tag in self.m_a_jumptags)
	{
		if(tag.occupied)
		{
			continue;
		}
		if(!isdefined(a_valid_tags))
		{
			a_valid_tags = [];
		}
		else if(!IsArray(a_valid_tags))
		{
			a_valid_tags = Array(a_valid_tags);
		}
		a_valid_tags[a_valid_tags.size] = tag;
	}
	a_valid_tags = Array::randomize(a_valid_tags);
	a_forward_tags = [];
	a_players = get_players_on_train(0);
	n_roll = RandomInt(100);
	if(n_roll < 80 && a_players.size > 0)
	{
		foreach(s_tag in a_valid_tags)
		{
			if(any_player_facing_tag(s_tag.str_tag))
			{
				if(!isdefined(a_forward_tags))
				{
					a_forward_tags = [];
				}
				else if(!IsArray(a_forward_tags))
				{
					a_forward_tags = Array(a_forward_tags);
				}
				a_forward_tags[a_forward_tags.size] = s_tag;
			}
		}
	}
	else if(a_forward_tags.size > 2)
	{
		a_valid_tags = a_forward_tags;
	}
	if(a_valid_tags.size == 0)
	{
		return undefined;
	}
	else
	{
		return Array::random(a_valid_tags);
	}
}

/*
	Name: get_origin
	Namespace: czmtrain
	Checksum: 0x94A2A997
	Offset: 0x7DB0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_origin()
{
	return self.m_vh_train.origin;
}

/*
	Name: function_876255
	Namespace: czmtrain
	Checksum: 0x9BC27727
	Offset: 0x7DD0
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function function_876255()
{
	a_e_train_maps = GetEntArray("map_train", "targetname");
	while(1)
	{
		str_station = get_current_station();
		switch(str_station)
		{
			case "slums":
			{
				n_station = 1;
				break;
			}
			case "theater":
			{
				n_station = 2;
				break;
			}
			case "canal":
			{
				n_station = 3;
				break;
			}
		}
		foreach(e_train_map in a_e_train_maps)
		{
			e_train_map clientfield::set("train_map_light", n_station);
		}
		self flag::wait_till("moving");
		foreach(e_train_map in a_e_train_maps)
		{
			e_train_map clientfield::set("train_map_light", 0);
		}
		self flag::wait_till_clear("moving");
	}
}

/*
	Name: __destructor
	Namespace: czmtrain
	Checksum: 0x99EC1590
	Offset: 0x7FD8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace namespace_835aa2f1;

/*
	Name: czmtrain
	Namespace: namespace_835aa2f1
	Checksum: 0xE17A404F
	Offset: 0x7FE8
	Size: 0xC25
	Parameters: 0
	Flags: 6
*/
function private autoexec czmtrain()
{
	classes.czmtrain[0] = spawnstruct();
	classes.czmtrain[0].__vtable[1606033458] = &czmtrain::__destructor;
	classes.czmtrain[0].__vtable[8872533] = &czmtrain::function_876255;
	classes.czmtrain[0].__vtable[-365059668] = &czmtrain::get_origin;
	classes.czmtrain[0].__vtable[-65452882] = &czmtrain::get_available_jumptag;
	classes.czmtrain[0].__vtable[2101558321] = &czmtrain::any_player_facing_tag;
	classes.czmtrain[0].__vtable[-408743127] = &czmtrain::is_offline;
	classes.czmtrain[0].__vtable[-1252310656] = &czmtrain::is_cooling_down;
	classes.czmtrain[0].__vtable[1046672679] = &czmtrain::get_doors_state;
	classes.czmtrain[0].__vtable[-643491610] = &czmtrain::is_moving;
	classes.czmtrain[0].__vtable[-484375205] = &czmtrain::get_junction_origin;
	classes.czmtrain[0].__vtable[-60091111] = &czmtrain::jump_into_train;
	classes.czmtrain[0].__vtable[-1070779204] = &czmtrain::mark_jumper_time;
	classes.czmtrain[0].__vtable[-920278003] = &czmtrain::get_time_since_last_jumper;
	classes.czmtrain[0].__vtable[251886806] = &czmtrain::get_zombies_locked_in;
	classes.czmtrain[0].__vtable[-1719939928] = &czmtrain::locked_in_list_remove_undefined;
	classes.czmtrain[0].__vtable[-868129045] = &czmtrain::remove_zombie_locked_in;
	classes.czmtrain[0].__vtable[794290114] = &czmtrain::add_zombie_locked_in;
	classes.czmtrain[0].__vtable[-1102276445] = &czmtrain::get_players_on_train;
	classes.czmtrain[0].__vtable[1080970153] = &czmtrain::is_touching_train_volume;
	classes.czmtrain[0].__vtable[-76032633] = &czmtrain::watch_zombie_fall_off;
	classes.czmtrain[0].__vtable[-387521356] = &czmtrain::is_touching_train;
	classes.czmtrain[0].__vtable[-1759866740] = &czmtrain::watch_players_on_train;
	classes.czmtrain[0].__vtable[-858294101] = &czmtrain::function_ccd778ab;
	classes.czmtrain[0].__vtable[-896951300] = &czmtrain::function_ca899bfc;
	classes.czmtrain[0].__vtable[-563208369] = &czmtrain::function_de6e1f4f;
	classes.czmtrain[0].__vtable[-756994765] = &czmtrain::run_switch;
	classes.czmtrain[0].__vtable[640858128] = &czmtrain::send_train;
	classes.czmtrain[0].__vtable[118676939] = &czmtrain::update_use_trigger;
	classes.czmtrain[0].__vtable[-1557587309] = &czmtrain::recalc_zombies_locked_in_train;
	classes.czmtrain[0].__vtable[677318411] = &czmtrain::function_285f0f0b;
	classes.czmtrain[0].__vtable[-1844369140] = &czmtrain::function_9211290c;
	classes.czmtrain[0].__vtable[-1881066007] = &czmtrain::close_doors;
	classes.czmtrain[0].__vtable[1500655324] = &czmtrain::open_door_anim;
	classes.czmtrain[0].__vtable[-1894359369] = &czmtrain::open_doors;
	classes.czmtrain[0].__vtable[972755727] = &czmtrain::is_door_open;
	classes.czmtrain[0].__vtable[1783161788] = &czmtrain::get_open_side;
	classes.czmtrain[0].__vtable[-1813351978] = &czmtrain::get_door_closed_pos;
	classes.czmtrain[0].__vtable[-176962386] = &czmtrain::get_door_open_pos;
	classes.czmtrain[0].__vtable[-2142038298] = &czmtrain::run_gate;
	classes.czmtrain[0].__vtable[643610466] = &czmtrain::run_callbox;
	classes.czmtrain[0].__vtable[1251890137] = &czmtrain::run_callbox_hintstring;
	classes.czmtrain[0].__vtable[-1330668116] = &czmtrain::function_b0af9dac;
	classes.czmtrain[0].__vtable[-1788979289] = &czmtrain::function_955e57a7;
	classes.czmtrain[0].__vtable[824948449] = &czmtrain::function_312bb6e1;
	classes.czmtrain[0].__vtable[-1552434618] = &czmtrain::function_a377ba46;
	classes.czmtrain[0].__vtable[-762254342] = &czmtrain::main;
	classes.czmtrain[0].__vtable[1869264804] = &czmtrain::function_6f6ab7a4;
	classes.czmtrain[0].__vtable[-422924033] = &czmtrain::Initialize;
	classes.czmtrain[0].__vtable[-1431523639] = &czmtrain::initialize_stations;
	classes.czmtrain[0].__vtable[-576083502] = &czmtrain::flip_forward;
	classes.czmtrain[0].__vtable[-1448281630] = &czmtrain::function_a9acf9e2;
	classes.czmtrain[0].__vtable[-341908992] = &czmtrain::function_eb9ee200;
	classes.czmtrain[0].__vtable[1227831890] = &czmtrain::move;
	classes.czmtrain[0].__vtable[2125617211] = &czmtrain::function_7eb2583b;
	classes.czmtrain[0].__vtable[1274668080] = &czmtrain::watch_node_parameters;
	classes.czmtrain[0].__vtable[-733342228] = &czmtrain::get_current_destination;
	classes.czmtrain[0].__vtable[-1373191000] = &czmtrain::get_current_station;
	classes.czmtrain[0].__vtable[-1461528577] = &czmtrain::function_a8e2d7ff;
	classes.czmtrain[0].__vtable[-1929845851] = &czmtrain::get_train_vehicle;
	classes.czmtrain[0].__vtable[-1941346850] = &czmtrain::enable_train_switches;
	classes.czmtrain[0].__vtable[16013323] = &czmtrain::switch_path_direction;
	classes.czmtrain[0].__vtable[900487325] = &czmtrain::debug_draw_doors;
	classes.czmtrain[0].__vtable[298368378] = &czmtrain::debug_draw_paths;
	classes.czmtrain[0].__vtable[-1690805083] = &czmtrain::__constructor;
}

/*
	Name: in_range_2d
	Namespace: namespace_835aa2f1
	Checksum: 0x6822FD88
	Offset: 0x8C18
	Size: 0x7D
	Parameters: 4
	Flags: None
*/
function in_range_2d(v1, v2, range, vert_allowance)
{
	if(Abs(v1[2] - v2[2]) > vert_allowance)
	{
		return 0;
	}
	return Distance2DSquared(v1, v2) < range * range;
}

/*
	Name: get_players_on_train
	Namespace: namespace_835aa2f1
	Checksum: 0x7B70A744
	Offset: 0x8CA0
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function get_players_on_train(b_valid_targets_only)
{
	if(!isdefined(b_valid_targets_only))
	{
		b_valid_targets_only = 0;
	}
	return get_players_on_train(level.o_zod_train);
}

/*
	Name: is_moving
	Namespace: namespace_835aa2f1
	Checksum: 0x9C7B626A
	Offset: 0x8CE0
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function is_moving()
{
	if(!isdefined(level.o_zod_train))
	{
		return 0;
	}
	return is_moving();
}

/*
	Name: zombie_jump_onto_moving_train
	Namespace: namespace_835aa2f1
	Checksum: 0x95C19E39
	Offset: 0x8D10
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function zombie_jump_onto_moving_train(ai)
{
	mark_jumper_time();
	spot = get_available_jumptag();
	if(isdefined(spot))
	{
		ai.str_train_tag = spot.str_tag;
		jump_into_train(level.o_zod_train, ai);
	}
}

/*
	Name: remove_dead_zombie
	Namespace: namespace_835aa2f1
	Checksum: 0x514BEC09
	Offset: 0x8DA0
	Size: 0xE7
	Parameters: 3
	Flags: None
*/
function remove_dead_zombie(e_attacker, str_means_of_death, weapon)
{
	if(isdefined(self))
	{
		b_on_train = 0;
		if(is_moving())
		{
			if(self.locked_in_train)
			{
				b_on_train = 1;
			}
		}
		if(b_on_train)
		{
			self clientfield::set("zombie_gut_explosion", 1);
			self ghost();
		}
	}
	if(isdefined(level.o_zod_train))
	{
		if(isdefined(self) && self.locked_in_train)
		{
			remove_zombie_locked_in(level.o_zod_train);
		}
		else
		{
			locked_in_list_remove_undefined();
		}
	}
}

/*
	Name: get_num_zombies_locked_in
	Namespace: namespace_835aa2f1
	Checksum: 0xDE13BFA5
	Offset: 0x8E90
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function get_num_zombies_locked_in()
{
	a_zombies = get_zombies_locked_in();
	return a_zombies.size;
}

/*
	Name: is_full
	Namespace: namespace_835aa2f1
	Checksum: 0xDAF9ED5D
	Offset: 0x8EC8
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function is_full()
{
	return get_num_zombies_locked_in() >= 6;
}

/*
	Name: is_ready_for_jumper
	Namespace: namespace_835aa2f1
	Checksum: 0xC4210679
	Offset: 0x8EE8
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function is_ready_for_jumper()
{
	return get_time_since_last_jumper() > 10;
}

/*
	Name: debug_go_to_train
	Namespace: namespace_835aa2f1
	Checksum: 0x9185ACAB
	Offset: 0x8F10
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function debug_go_to_train()
{
	/#
		train = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(isdefined(train))
		{
			train_origin = train GetOrigin();
			player = level.players[0];
			if(isdefined(player) && isdefined(train_origin))
			{
				train_origin = (train_origin[0], train_origin[1], train_origin[2] - 100);
				player SetOrigin(train_origin);
			}
		}
	#/
}

/*
	Name: train_devgui
	Namespace: namespace_835aa2f1
	Checksum: 0x5577B68C
	Offset: 0x8FF8
	Size: 0x1EF
	Parameters: 0
	Flags: None
*/
function train_devgui()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
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
					case "Dev Block strings are not supported":
					case "Dev Block strings are not supported":
					{
						break;
					}
					case "Dev Block strings are not supported":
					{
						open_doors();
						break;
					}
					case "Dev Block strings are not supported":
					{
						close_doors();
						break;
					}
					case "Dev Block strings are not supported":
					{
						debug_go_to_train();
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

