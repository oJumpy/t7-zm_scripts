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
	namespace_8e578893::function_2d5dfb29(&function_a4a1ecff);
	namespace_8e578893::function_6681ab86(&zombie_init);
	clientfield::register("vehicle", "train_switch_light", 1, 2, "int");
	clientfield::register("scriptmover", "train_callbox_light", 1, 2, "int");
	clientfield::register("scriptmover", "train_map_light", 1, 2, "int");
	clientfield::register("vehicle", "train_rain_fx_occluder", 1, 1, "int");
	clientfield::register("world", "sndTrainVox", 1, 4, "int");
	level.player_intemission_spawn_callback = &player_intemission_spawn_callback;
	thread function_b8c85e5c();
	thread function_eb0db7bc();
	/#
		thread function_6353976e();
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
		function_aaacaec9();
		function_7eb2583b();
		function_dda9a9d2();
		function_2632b810();
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
	Name: function_b8c85e5c
	Namespace: namespace_835aa2f1
	Checksum: 0xD73D9D57
	Offset: 0x1088
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function function_b8c85e5c()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	var_fcd89369 = GetEnt("zod_train", "targetname");
	var_fcd89369 function_7465f87();
	var_fcd89369.takedamage = 0;
	var_fcd89369 clientfield::set("train_rain_fx_occluder", 1);
	function_9b385ca5();
	level.o_zod_train = var_df2b89fb;
	Initialize(level.o_zod_train);
	level thread function_da8f624d();
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
		self.var_aa192bd2 = trig;
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
	wallbuy = level.o_zod_train.var_36e768e4.var_aa192bd2;
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
				self function_cb2c15eb(player, hint_string);
			}
			else
			{
				hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
				self function_cb2c15eb(player, hint_string);
			}
		}
		else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentWeapon))
		{
			hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL_BGB_SECRET_SHOPPER";
			n_bgb_cost = player zm_weapons::get_ammo_cost_for_weapon(player.currentWeapon);
			self function_cb2c15eb(player, hint_string, cost, n_bgb_cost);
		}
		else
		{
			hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL";
			self function_cb2c15eb(player, hint_string, cost);
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
			self function_cb2c15eb(player, hint_string);
		}
		else
		{
			hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL";
			self function_cb2c15eb(player, hint_string);
		}
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentWeapon))
	{
		hint_string = &"ZOMBIE_WEAPONAMMOONLY_BGB_SECRET_SHOPPER";
		n_bgb_cost = player zm_weapons::get_ammo_cost_for_weapon(player.currentWeapon);
		self function_cb2c15eb(player, hint_string, ammo_cost, n_bgb_cost);
	}
	else
	{
		hint_string = &"ZOMBIE_WEAPONAMMOONLY";
		self function_cb2c15eb(player, hint_string, ammo_cost);
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
	self.var_5823efe0 = self.model;
	self SetModel("wpn_t7_none_world");
	trigger waittill("trigger");
	self SetModel(self.var_5823efe0);
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
	self.var_e0d198e4 = 0;
}

/*
	Name: function_da8f624d
	Namespace: namespace_835aa2f1
	Checksum: 0xDD56E2FA
	Offset: 0x1CA0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_da8f624d()
{
	level flag::wait_till("connect_start_to_junction");
	function_2632b810();
}

#namespace namespace_df2b89fb;

/*
	Name: function_9b385ca5
	Namespace: namespace_df2b89fb
	Checksum: 0x1AA5265D
	Offset: 0x1CE0
	Size: 0x225
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.var_36e768e4 = undefined;
	self.var_d621a979 = undefined;
	self.var_d461052a = undefined;
	self.var_6732a75b = undefined;
	self.var_ece46550 = 1;
	self.var_65323906 = 0;
	self.var_597ffbe8 = 0;
	self.var_c2e30cf8 = [];
	self.var_dfffc7fc = [];
	self.var_5d231abf = undefined;
	self.var_aced8be7 = undefined;
	self.var_27e5d923 = [];
	self.var_a677da96 = 0;
	self.var_9f3b63f6 = [];
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
		self.var_9f3b63f6[str_name] = spawnstruct();
		var_280649c5 = self.var_9f3b63f6[str_name];
		var_280649c5.str_tag = str_name;
		var_280649c5.str_anim = str_anim;
		var_280649c5.occupied = 0;
	}
}

/*
	Name: function_11c8bd7a
	Namespace: namespace_df2b89fb
	Checksum: 0xB1E15503
	Offset: 0x1F10
	Size: 0x40F
	Parameters: 0
	Flags: None
*/
function function_11c8bd7a()
{
	/#
		do
		{
			var_228edad9 = GetDvarInt("Dev Block strings are not supported");
			wait(1);
		}
		while(!(!isdefined(var_228edad9) || var_228edad9 <= 0));
		while(1)
		{
			a_keys = getArrayKeys(self.var_c2e30cf8);
			for(var_6983dc4b = 0; var_6983dc4b < self.var_c2e30cf8.size; var_6983dc4b++)
			{
				j = a_keys[var_6983dc4b];
				var_e44abae0 = self.var_c2e30cf8[j].nodes;
				for(i = 0; i < var_e44abae0.size; i++)
				{
					node = var_e44abae0[i];
					var_dc73cd3e = node.origin + VectorScale((0, 0, -1), 95);
					debugstar(var_dc73cd3e, 1, (1, 0, 0));
					if(isdefined(node.target))
					{
						var_b49e30db = GetVehicleNode(node.target, "Dev Block strings are not supported");
						var_4f71418 = var_b49e30db.origin + VectorScale((0, 0, -1), 70);
						line(var_dc73cd3e, var_4f71418, (0, 1, 0), 0, 1);
						debugstar(var_4f71418, 1, (0, 1, 0));
					}
					if(isdefined(node.target2))
					{
						var_dc338423 = GetVehicleNode(node.target2, "Dev Block strings are not supported");
						var_e9bd3ba0 = var_dc338423.origin + VectorScale((0, 0, -1), 120);
						line(var_dc73cd3e, var_e9bd3ba0, (0, 0, 1), 0, 1);
						debugstar(var_e9bd3ba0, 1, (0, 0, 1));
					}
				}
			}
			a_zombies = GetAITeamArray(level.zombie_team);
			foreach(ai in a_zombies)
			{
				if(isdefined(ai.var_e0d198e4) && ai.var_e0d198e4)
				{
					print3d(ai.origin + VectorScale((0, 0, 1), 100), "Dev Block strings are not supported" + self.var_27e5d923.size + "Dev Block strings are not supported", VectorScale((0, 1, 0), 255), 1);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_35ac589d
	Namespace: namespace_df2b89fb
	Checksum: 0xBBCBF00E
	Offset: 0x2328
	Size: 0x317
	Parameters: 0
	Flags: None
*/
function function_35ac589d()
{
	do
	{
		var_228edad9 = GetDvarInt("train_debug_doors");
		wait(1);
	}
	while(!(!isdefined(var_228edad9) || var_228edad9 <= 0));
	while(1)
	{
		duration = 1;
		var_6ffe9d93 = 240;
		var_4dc5a359 = 12;
		origin = self.var_36e768e4.origin;
		origin = origin + VectorScale((0, 0, -1), 90);
		FORWARD = AnglesToForward(self.var_36e768e4.angles);
		right = AnglesToRight(self.var_36e768e4.angles);
		if(!self.var_ece46550)
		{
			FORWARD = -1 * FORWARD;
		}
		var_bba032ca = origin + var_6ffe9d93 * FORWARD;
		/#
			line(origin, var_bba032ca, (1, 0, 0), 1, 1, duration);
		#/
		/#
			line(var_bba032ca, var_bba032ca - var_4dc5a359 * FORWARD - var_4dc5a359 * right, (1, 0, 0), 1, 1, duration);
		#/
		/#
			line(var_bba032ca, var_bba032ca - var_4dc5a359 * FORWARD + var_4dc5a359 * right, (1, 0, 0), 1, 1, duration);
		#/
		foreach(e_door in self.var_dfffc7fc)
		{
			var_d4280494 = e_door.origin;
			open = function_39fb130f(e_door);
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
	Name: function_f4580b
	Namespace: namespace_df2b89fb
	Checksum: 0x8B0F3DEB
	Offset: 0x2648
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function function_f4580b(all_nodes, direction)
{
	for(i = 0; i < all_nodes.size; i++)
	{
		var_9f0a4f36 = all_nodes[i].target;
		all_nodes[i].target = all_nodes[i].target2;
		all_nodes[i].target2 = var_9f0a4f36;
	}
	return !direction;
}

/*
	Name: function_8c4965de
	Namespace: namespace_df2b89fb
	Checksum: 0xB675E256
	Offset: 0x26F8
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_8c4965de(b_enabled)
{
	if(b_enabled)
	{
		self flag::set("switches_enabled");
		self.var_d461052a setHintString(&"ZM_ZOD_SWITCH_ENABLE");
		function_ca899bfc();
	}
	else
	{
		self flag::clear("switches_enabled");
		self.var_d461052a setHintString(&"ZM_ZOD_SWITCH_DISABLE");
		self.var_36e768e4 notify("hash_51689c0f");
	}
}

/*
	Name: function_8cf8e3a5
	Namespace: namespace_df2b89fb
	Checksum: 0x4B6CC725
	Offset: 0x27B8
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_8cf8e3a5()
{
	return self.var_36e768e4;
}

/*
	Name: function_a8e2d7ff
	Namespace: namespace_df2b89fb
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
	Name: function_ae26c4a8
	Namespace: namespace_df2b89fb
	Checksum: 0x82585757
	Offset: 0x2A00
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_ae26c4a8()
{
	return self.var_5d231abf;
}

/*
	Name: function_d44a15ec
	Namespace: namespace_df2b89fb
	Checksum: 0xB5995F60
	Offset: 0x2A18
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_d44a15ec()
{
	if(self.var_c2e30cf8[self.var_5d231abf].var_bd2282e4)
	{
		return self.var_c2e30cf8[self.var_5d231abf].var_6794c924;
	}
	else
	{
		return self.var_c2e30cf8[self.var_5d231abf].var_13ba8371;
	}
}

/*
	Name: function_4bf9e430
	Namespace: namespace_df2b89fb
	Checksum: 0x320F6EBF
	Offset: 0x2A80
	Size: 0x159
	Parameters: 0
	Flags: None
*/
function function_4bf9e430()
{
	self.var_36e768e4 endon("hash_4e05ac46");
	while(1)
	{
		self.var_36e768e4 waittill("reached_node", nd);
		if(isdefined(nd.script_parameters))
		{
			switch(nd.script_parameters)
			{
				case "arrival_brakes":
				{
					if(self.var_597ffbe8)
					{
						self.var_36e768e4 playsound("evt_train_stop");
						self.var_36e768e4 StopLoopSound(3);
					}
					break;
				}
				case "arrival_bell":
				{
					if(self.var_597ffbe8)
					{
						var_ab09630c = self.var_c2e30cf8[self.var_aced8be7].callbox;
						var_ab09630c playsound("evt_train_station_bell");
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
	Namespace: namespace_df2b89fb
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
	Namespace: namespace_df2b89fb
	Checksum: 0x47B4E91
	Offset: 0x2C48
	Size: 0x603
	Parameters: 0
	Flags: None
*/
function move()
{
	self.var_597ffbe8 = 0;
	var_2ad5d7ab = self.var_5d231abf;
	var_f2b1b376 = self.var_c2e30cf8[var_2ad5d7ab].var_6794c924;
	var_a4cd63cd = self.var_c2e30cf8[var_2ad5d7ab].var_13ba8371;
	if(self.var_c2e30cf8[var_2ad5d7ab].var_a7b7d6cd == 0)
	{
		self.var_36e768e4 function_f6b29255();
		self.var_c2e30cf8[var_2ad5d7ab].var_a7b7d6cd = function_f4580b(self.var_c2e30cf8[var_2ad5d7ab].nodes, self.var_c2e30cf8[var_2ad5d7ab].var_a7b7d6cd);
		self.var_36e768e4 function_c6021eb7(self.var_c2e30cf8[var_2ad5d7ab].start_node, self.var_c2e30cf8[var_2ad5d7ab].var_db628370);
	}
	if(self.var_c2e30cf8[var_f2b1b376].var_a7b7d6cd == 1)
	{
		self.var_c2e30cf8[var_f2b1b376].var_a7b7d6cd = function_f4580b(self.var_c2e30cf8[var_f2b1b376].nodes, self.var_c2e30cf8[var_f2b1b376].var_a7b7d6cd);
		self.var_36e768e4 function_c6021eb7(self.var_c2e30cf8[var_f2b1b376].start_node, self.var_c2e30cf8[var_f2b1b376].var_db628370);
	}
	if(self.var_c2e30cf8[var_a4cd63cd].var_a7b7d6cd == 1)
	{
		self.var_c2e30cf8[var_a4cd63cd].var_a7b7d6cd = function_f4580b(self.var_c2e30cf8[var_a4cd63cd].nodes, self.var_c2e30cf8[var_a4cd63cd].var_a7b7d6cd);
		self.var_36e768e4 function_c6021eb7(self.var_c2e30cf8[var_a4cd63cd].start_node, self.var_c2e30cf8[var_a4cd63cd].var_db628370);
	}
	sndnum = self.var_c2e30cf8[self.var_aced8be7].var_e9a2f13e;
	level clientfield::set("sndTrainVox", sndnum);
	self.var_36e768e4 PlaySoundOnTag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
	thread function_4bf9e430();
	self.var_36e768e4 function_f03481a();
	self.var_36e768e4 AttachPath(self.var_c2e30cf8[var_2ad5d7ab].start_node);
	self.var_36e768e4 StartPath();
	while(Distance2DSquared(self.var_36e768e4.origin, self.var_c2e30cf8[var_2ad5d7ab].var_db628370.origin) > 122500)
	{
		util::wait_network_frame();
	}
	function_8c4965de(0);
	thread function_a377ba46();
	var_7cf5ddc3 = var_f2b1b376;
	if(!self.var_c2e30cf8[var_2ad5d7ab].var_bd2282e4)
	{
		var_7cf5ddc3 = var_a4cd63cd;
	}
	var_aad144f4 = self.var_c2e30cf8[var_7cf5ddc3].var_db628370;
	self.var_36e768e4 setSwitchNode(self.var_c2e30cf8[var_2ad5d7ab].var_db628370, self.var_c2e30cf8[var_7cf5ddc3].var_db628370);
	self.var_597ffbe8 = 1;
	self.var_97fef807 = var_7cf5ddc3;
	level flag::set(self.var_c2e30cf8[var_7cf5ddc3].var_6ac14e0c);
	self.var_36e768e4 waittill("reached_end_node");
	self.var_ece46550 = !self.var_ece46550;
	self.var_5d231abf = var_7cf5ddc3;
	self.var_aced8be7 = function_d44a15ec();
	self.var_36e768e4 notify("hash_4e05ac46", self.var_5d231abf);
	sndnum = self.var_c2e30cf8[self.var_5d231abf].var_b2be6a39;
	level clientfield::set("sndTrainVox", sndnum);
	self.var_36e768e4 PlaySoundOnTag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
}

/*
	Name: function_eb9ee200
	Namespace: namespace_df2b89fb
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
	Namespace: namespace_df2b89fb
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
		if(function_e8e6e4b4(e_player))
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
			e_player.var_e51032ec = GetTime();
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
	self.var_36e768e4 waittill("hash_4e05ac46");
	var_1a8b64d3 = self.var_36e768e4 GetCentroid();
	var_10b9b744 = 0;
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
		if(!isdefined(e_player.var_e51032ec))
		{
			continue;
		}
		if(isdefined(e_player.last_bleed_out_time) && e_player.last_bleed_out_time > e_player.var_e51032ec)
		{
			continue;
		}
		if(!function_e8e6e4b4(e_player))
		{
			fatal = 0;
			do
			{
				spawnPos = var_1a8b64d3;
				switch(var_10b9b744)
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
				var_10b9b744++;
			}
			while(!(!fatal && !function_eb9ee200(spawnPos)));
			e_player SetOrigin(spawnPos);
		}
	}
}

/*
	Name: function_dda9a9d2
	Namespace: namespace_df2b89fb
	Checksum: 0x4FA3ACD0
	Offset: 0x37B0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_dda9a9d2()
{
	self.var_ece46550 = !self.var_ece46550;
}

/*
	Name: function_aaacaec9
	Namespace: namespace_df2b89fb
	Checksum: 0x7762DE6C
	Offset: 0x37D0
	Size: 0x921
	Parameters: 0
	Flags: None
*/
function function_aaacaec9()
{
	self.var_c2e30cf8 = [];
	var_162fdabe = GetNodeArray("train_pathnode", "targetname");
	foreach(nd in var_162fdabe)
	{
		var_c7d3f5b3 = nd.script_string;
		self.var_c2e30cf8[var_c7d3f5b3] = spawnstruct();
		self.var_c2e30cf8[var_c7d3f5b3].path_node = nd;
		self.var_c2e30cf8[var_c7d3f5b3].origin = nd.origin;
		self.var_c2e30cf8[var_c7d3f5b3].angles = nd.angles;
		self.var_c2e30cf8[var_c7d3f5b3].var_19ec4f11 = var_c7d3f5b3;
		self.var_c2e30cf8[var_c7d3f5b3].var_54db6999 = nd.script_parameters;
	}
	self.var_c2e30cf8["slums"].var_6794c924 = "canal";
	self.var_c2e30cf8["slums"].var_13ba8371 = "theater";
	self.var_c2e30cf8["slums"].var_bd2282e4 = 0;
	self.var_c2e30cf8["slums"].var_6ac14e0c = "activate_slums_waterfront";
	self.var_c2e30cf8["slums"].var_1866b220 = 8;
	self.var_c2e30cf8["slums"].var_e9a2f13e = 5;
	self.var_c2e30cf8["slums"].var_b2be6a39 = 1;
	self.var_c2e30cf8["slums"].start_node = GetVehicleNode("a1", "targetname");
	self.var_c2e30cf8["theater"].var_6794c924 = "slums";
	self.var_c2e30cf8["theater"].var_13ba8371 = "canal";
	self.var_c2e30cf8["theater"].var_bd2282e4 = 0;
	self.var_c2e30cf8["theater"].var_6ac14e0c = "activate_theater_square";
	self.var_c2e30cf8["theater"].var_1866b220 = 9;
	self.var_c2e30cf8["theater"].var_e9a2f13e = 6;
	self.var_c2e30cf8["theater"].var_b2be6a39 = 2;
	self.var_c2e30cf8["theater"].start_node = GetVehicleNode("b1", "targetname");
	self.var_c2e30cf8["canal"].var_6794c924 = "theater";
	self.var_c2e30cf8["canal"].var_13ba8371 = "slums";
	self.var_c2e30cf8["canal"].var_bd2282e4 = 0;
	self.var_c2e30cf8["canal"].var_6ac14e0c = "activate_brothel_street";
	self.var_c2e30cf8["canal"].var_1866b220 = 7;
	self.var_c2e30cf8["canal"].var_e9a2f13e = 4;
	self.var_c2e30cf8["canal"].var_b2be6a39 = 3;
	self.var_c2e30cf8["canal"].start_node = GetVehicleNode("c1", "targetname");
	level.var_98f27ad = Array("vox_tanc_board_canal_0", "vox_tanc_board_slums_0", "vox_tanc_board_theater_0", "vox_tanc_depart_canal_0", "vox_tanc_depart_slums_0", "vox_tanc_depart_theater_0", "vox_tanc_divert_canal_0", "vox_tanc_divert_slums_0", "vox_tanc_divert_theater_0");
	a_keys = getArrayKeys(self.var_c2e30cf8);
	for(i = 0; i < a_keys.size; i++)
	{
		str_key = a_keys[i];
		nd_next = self.var_c2e30cf8[str_key].start_node;
		nd_prev = undefined;
		self.var_c2e30cf8[str_key].nodes = [];
		while(isdefined(nd_next))
		{
			if(isdefined(nd_prev))
			{
				nd_next.target2 = nd_prev.targetname;
			}
			if(!isdefined(self.var_c2e30cf8[str_key].nodes))
			{
				self.var_c2e30cf8[str_key].nodes = [];
			}
			else if(!IsArray(self.var_c2e30cf8[str_key].nodes))
			{
				self.var_c2e30cf8[str_key].nodes = Array(self.var_c2e30cf8[str_key].nodes);
			}
			self.var_c2e30cf8[str_key].nodes[self.var_c2e30cf8[str_key].nodes.size] = nd_next;
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
		num_nodes = self.var_c2e30cf8[str_key].nodes.size;
		self.var_c2e30cf8[str_key].var_db628370 = self.var_c2e30cf8[str_key].nodes[num_nodes - 1];
		self.var_c2e30cf8[str_key].var_a7b7d6cd = 1;
	}
	var_8b82fd2c = GetEntArray("train_call_lever", "targetname");
	foreach(var_ab09630c in var_8b82fd2c)
	{
		var_374d0b9b = ArrayGetClosest(var_ab09630c.origin, self.var_c2e30cf8);
		/#
			Assert(isdefined(var_374d0b9b));
		#/
		var_ab09630c.script_string = var_374d0b9b.var_19ec4f11;
		var_374d0b9b.callbox = var_ab09630c;
	}
}

/*
	Name: Initialize
	Namespace: namespace_df2b89fb
	Checksum: 0x5CAA134C
	Offset: 0x4100
	Size: 0x8B1
	Parameters: 1
	Flags: None
*/
function Initialize(var_fcd89369)
{
	/#
		Assert(isdefined(var_fcd89369));
	#/
	self.var_36e768e4 = var_fcd89369;
	self.var_36e768e4.var_619deb2d = 0;
	self.var_36e768e4.var_901503d0 = 0;
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
	self.var_36e768e4.team = "spectator";
	function_aaacaec9();
	/#
		thread function_11c8bd7a();
		thread function_35ac589d();
	#/
	var_3712c214 = GetEntArray(self.var_36e768e4.target, "targetname");
	foreach(e_ent in var_3712c214)
	{
		if(isdefined(e_ent.script_string))
		{
			if(e_ent.script_string == "train_volume")
			{
				if(!isdefined(self.var_6732a75b))
				{
					/#
						Assert(!isdefined(self.var_6732a75b));
					#/
					e_ent EnableLinkTo();
					self.var_6732a75b = e_ent;
				}
			}
			else if(e_ent.script_string == "train_rear_door" || e_ent.script_string == "train_front_door")
			{
				if(!isdefined(e_ent.script_origin))
				{
					e_ent.script_origin = spawn("script_origin", e_ent.origin);
					e_ent.script_origin.angles = self.var_36e768e4.angles;
					e_ent.script_origin LinkTo(self.var_36e768e4);
				}
				if(!isdefined(self.var_dfffc7fc))
				{
					self.var_dfffc7fc = [];
				}
				else if(!IsArray(self.var_dfffc7fc))
				{
					self.var_dfffc7fc = Array(self.var_dfffc7fc);
				}
				self.var_dfffc7fc[self.var_dfffc7fc.size] = e_ent;
			}
			e_ent LinkTo(self.var_36e768e4);
			continue;
		}
		/#
			IPrintLnBold("Dev Block strings are not supported" + namespace_8e578893::function_f7f2ffed(e_ent.origin) + "Dev Block strings are not supported");
		#/
	}
	function_6f6ab7a4();
	/#
		if(!isdefined(self.var_6732a75b))
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + namespace_8e578893::function_f7f2ffed(self.var_36e768e4.origin) + "Dev Block strings are not supported");
			#/
		}
	#/
	self.var_36e768e4 function_a8e2d7ff();
	self.var_d461052a = GetEnt("m_s_switch_trigger", "targetname");
	self.var_d461052a TriggerIgnoreTeam();
	self.var_d461052a SetTeamForTrigger("none");
	self.var_d461052a setHintString(&"ZM_ZOD_SWITCH_DISABLE");
	self.var_d461052a setcursorhint("HINT_NOICON");
	self.var_d461052a EnableLinkTo();
	self.var_d461052a LinkTo(self.var_36e768e4);
	self.var_d461052a.player_used = 0;
	thread main();
	var_8b82fd2c = GetEntArray("train_call_lever", "targetname");
	foreach(var_ab09630c in var_8b82fd2c)
	{
		thread function_265cb762(var_ab09630c.script_string);
	}
	var_b6cf5773 = GetEntArray("train_gate", "targetname");
	foreach(gate in var_b6cf5773)
	{
		station = self.var_c2e30cf8[gate.script_string];
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
		var_38cb7b13 = GetNodeArray(station.path_node.target, "targetname");
		self thread function_805316e6(gate, var_38cb7b13);
	}
}

/*
	Name: function_6f6ab7a4
	Namespace: namespace_df2b89fb
	Checksum: 0x3A33B794
	Offset: 0x49C0
	Size: 0x1A9
	Parameters: 0
	Flags: None
*/
function function_6f6ab7a4()
{
	for(i = 0; i < self.var_dfffc7fc.size; i++)
	{
		e_door = self.var_dfffc7fc[i];
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
			e_origin.angles = self.var_36e768e4.angles;
			e_origin LinkTo(self.var_36e768e4);
			e_door.e_clip.var_b620e1b1 = e_origin;
		}
	}
}

/*
	Name: main
	Namespace: namespace_df2b89fb
	Checksum: 0xC784593D
	Offset: 0x4B78
	Size: 0x7AF
	Parameters: 0
	Flags: None
*/
function main()
{
	var_8518d16d = getArrayKeys(self.var_c2e30cf8);
	var_8518d16d = Array::randomize(var_8518d16d);
	self.var_5d231abf = var_8518d16d[0];
	self.var_97fef807 = self.var_5d231abf;
	self.var_c2e30cf8[self.var_5d231abf].var_bd2282e4 = RandomInt(2);
	self.var_aced8be7 = function_d44a15ec();
	self.var_36e768e4 AttachPath(self.var_c2e30cf8[self.var_5d231abf].start_node);
	b_first_run = 1;
	self thread function_876255();
	self thread function_971a908c();
	self thread function_955e57a7();
	wait(1);
	var_74ff4121 = self.var_36e768e4 GetTagOrigin("tag_button_front");
	self.var_d621a979 = namespace_8e578893::function_d095318(var_74ff4121, 60, 1);
	self.var_36e768e4 PlayLoopSound("evt_train_idle_loop", 4);
	function_8f165eb7();
	thread function_d2e12d33();
	while(1)
	{
		function_712ddcb();
		function_8c4965de(1);
		level thread function_b0af9dac();
		while(1)
		{
			self.var_36e768e4 clientfield::set("train_switch_light", 1);
			self.var_d621a979 waittill("trigger", e_who);
			self.var_36e768e4 clientfield::set("train_switch_light", 0);
			if(self.var_65323906)
			{
				self.var_65323906 = 0;
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
		zm_unitrigger::unregister_unitrigger(self.var_d621a979);
		self.var_d621a979 = undefined;
		function_8fe135e9();
		self.var_36e768e4 playsound("evt_train_start");
		self.var_36e768e4 PlayLoopSound("evt_train_loop", 4);
		var_8d722bd4 = function_ccd778ab();
		if(var_8d722bd4 || b_first_run)
		{
			self.var_36e768e4 SetSpeed(32);
		}
		else
		{
			level.b_host_migration_force_player_respawn = 1;
			thread function_a9acf9e2();
		}
		move();
		self.var_36e768e4 PlayLoopSound("evt_train_idle_loop", 4);
		a_riders = function_be4c98a3(0);
		if(a_riders.size > 0)
		{
			level flag::set(self.var_c2e30cf8[self.var_5d231abf].var_6ac14e0c);
			level flag::set("train_rode_to_" + self.var_5d231abf);
		}
		if(var_8d722bd4 || b_first_run)
		{
			self.var_36e768e4 ResumeSpeed();
		}
		if(b_first_run)
		{
			b_first_run = 0;
		}
		function_8f165eb7();
		a_riders = function_be4c98a3(0);
		if(a_riders.size > 0)
		{
			var_3a349c58 = a_riders[RandomInt(a_riders.size)];
			var_3a349c58 zm_audio::create_and_play_dialog("train", "stop");
		}
		var_a56d6832 = (0, 0, 0);
		if(!self.var_ece46550)
		{
			var_a56d6832 = self.var_36e768e4 GetTagOrigin("tag_button_back");
		}
		else
		{
			var_a56d6832 = self.var_36e768e4 GetTagOrigin("tag_button_front");
		}
		self flag::clear("moving");
		level.b_host_migration_force_player_respawn = 0;
		self function_312bb6e1();
		if(!self.var_65323906 && level.var_33c4ee76 > 0)
		{
			self flag::set("cooldown");
			function_712ddcb();
			n_wait = 40;
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					n_wait = 5;
				}
			#/
			wait(n_wait);
			self.var_d621a979 = namespace_8e578893::function_d095318(var_a56d6832, 60, 1);
			self flag::clear("cooldown");
		}
		else
		{
			self.var_d621a979 = namespace_8e578893::function_d095318(var_a56d6832, 60, 1);
		}
	}
}

/*
	Name: function_a377ba46
	Namespace: namespace_df2b89fb
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
		var_38c97a3b = function_d44a15ec();
	}
	else
	{
		var_38c97a3b = self.var_5d231abf;
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
	Namespace: namespace_df2b89fb
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
	self.var_36e768e4 clientfield::set("train_switch_light", 2);
	function_712ddcb();
	level waittill("between_round_over");
	self flag::clear("offline");
	wait(0.05);
}

/*
	Name: function_955e57a7
	Namespace: namespace_df2b89fb
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
	function_712ddcb();
}

/*
	Name: function_b0af9dac
	Namespace: namespace_df2b89fb
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
	Name: function_4a9e53d9
	Namespace: namespace_df2b89fb
	Checksum: 0x47FC1C3E
	Offset: 0x55D8
	Size: 0x257
	Parameters: 3
	Flags: None
*/
function function_4a9e53d9(var_2ac060e4, t_use, e_light)
{
	while(1)
	{
		if(self.var_5d231abf == var_2ac060e4)
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
		else if(self.var_5d231abf == var_2ac060e4)
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
	Name: function_265cb762
	Namespace: namespace_df2b89fb
	Checksum: 0x83A1C33E
	Offset: 0x5838
	Size: 0x25F
	Parameters: 1
	Flags: None
*/
function function_265cb762(var_2ac060e4)
{
	/#
		Assert(isdefined(self.var_5d231abf));
	#/
	e_lever = self.var_c2e30cf8[var_2ac060e4].callbox;
	t_use = namespace_8e578893::function_d095318(e_lever.origin, 60, 1);
	thread function_4a9e53d9(var_2ac060e4, t_use, GetEnt(e_lever.target, "targetname"));
	while(1)
	{
		t_use waittill("trigger", e_who);
		if(!e_who zm_score::can_player_purchase(500))
		{
			e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			continue;
		}
		if(self.var_5d231abf != var_2ac060e4 && isdefined(self.var_d621a979))
		{
			self.var_65323906 = 0;
			if(var_2ac060e4 != self.var_aced8be7)
			{
				level flag::set("callbox");
				self.var_d461052a notify("trigger");
				level waittill("hash_8939bd21");
			}
			self.var_d621a979 notify("trigger", e_who);
			util::wait_network_frame();
			self.var_65323906 = 1;
			e_lever RotatePitch(180, 0.5);
			self flag::wait_till("moving");
			self flag::wait_till_clear("moving");
			e_lever RotatePitch(-180, 0.5);
		}
	}
}

/*
	Name: function_805316e6
	Namespace: namespace_df2b89fb
	Checksum: 0xF14137D4
	Offset: 0x5AA0
	Size: 0x34F
	Parameters: 2
	Flags: None
*/
function function_805316e6(var_a7c049ac, var_cdaa2ef3)
{
	nd_start = self.var_c2e30cf8[var_a7c049ac.script_string].start_node;
	var_ee4758e4 = var_a7c049ac.origin;
	var_92bda14 = var_ee4758e4 + AnglesToForward(nd_start.angles) * 96;
	if(self.var_c2e30cf8[var_a7c049ac.script_string].var_54db6999 == "right")
	{
		var_92bda14 = var_ee4758e4 - AnglesToForward(nd_start.angles) * 96;
	}
	b_open = 1;
	while(1)
	{
		if(b_open)
		{
			self.var_9e0dc993 = 0;
			var_a7c049ac moveto(var_92bda14, 1);
			b_open = 0;
			foreach(nd in var_cdaa2ef3)
			{
				UnlinkTraversal(nd);
			}
		}
		self flag::wait_till_clear("moving");
		if(self.var_5d231abf == var_a7c049ac.script_string)
		{
			var_a7c049ac moveto(var_ee4758e4, 1);
			b_open = 1;
			var_a7c049ac waittill("movedone");
			foreach(nd in var_cdaa2ef3)
			{
				var_147257fa = nd.script_string === "forward";
				if(self.var_ece46550 && var_147257fa || (!self.var_ece46550 && !var_147257fa))
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
	Name: function_f573c4ae
	Namespace: namespace_df2b89fb
	Checksum: 0x6ED9E238
	Offset: 0x5DF8
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function function_f573c4ae(e_door)
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
	Name: function_93ea71d6
	Namespace: namespace_df2b89fb
	Checksum: 0xD4D64F94
	Offset: 0x5EC0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_93ea71d6(e_door)
{
	return e_door.script_origin.origin;
}

/*
	Name: function_6a48e3bc
	Namespace: namespace_df2b89fb
	Checksum: 0xD2C82C3A
	Offset: 0x5EF0
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_6a48e3bc()
{
	str_side = self.var_c2e30cf8[self.var_5d231abf].var_54db6999;
	if(!self.var_ece46550)
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
	Name: function_39fb130f
	Namespace: namespace_df2b89fb
	Checksum: 0x34141D98
	Offset: 0x5F68
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function function_39fb130f(e_door)
{
	str_side = function_6a48e3bc();
	if(str_side == "left" && e_door.script_string == "train_rear_door" || (str_side == "right" && e_door.script_string == "train_front_door"))
	{
		return self.var_9e0dc993;
	}
	return 0;
}

/*
	Name: function_8f165eb7
	Namespace: namespace_df2b89fb
	Checksum: 0x16F263C8
	Offset: 0x6000
	Size: 0x417
	Parameters: 1
	Flags: None
*/
function function_8f165eb7(str_side)
{
	if(!isdefined(str_side))
	{
		str_side = function_6a48e3bc();
	}
	self.var_36e768e4 function_59722edc(str_side);
	var_7631d55c = VectorScale((0, 0, 1), 300);
	var_cfdb047c = [];
	foreach(e_door in self.var_dfffc7fc)
	{
		if(!isdefined(str_side) || (str_side == "left" && e_door.script_string == "train_rear_door") || (str_side == "right" && e_door.script_string == "train_front_door"))
		{
			v_pos = function_f573c4ae(e_door);
			e_door Unlink();
			e_door moveto(v_pos, 0.3);
			if(!isdefined(var_cfdb047c))
			{
				var_cfdb047c = [];
			}
			else if(!IsArray(var_cfdb047c))
			{
				var_cfdb047c = Array(var_cfdb047c);
			}
			var_cfdb047c[var_cfdb047c.size] = e_door;
			e_door.e_clip Unlink();
			e_door.e_clip moveto(e_door.e_clip.origin + var_7631d55c, 0.3);
		}
	}
	if(var_cfdb047c.size > 0)
	{
		var_cfdb047c[0] waittill("movedone");
		util::wait_network_frame();
	}
	util::wait_network_frame();
	foreach(e_door in var_cfdb047c)
	{
		v_pos = function_f573c4ae(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door LinkTo(self.var_36e768e4);
		e_door.e_clip LinkTo(self.var_36e768e4);
	}
	for(i = self.var_27e5d923.size - 1; i >= 0; i--)
	{
		ai = self.var_27e5d923[i];
		if(isdefined(ai))
		{
			function_cc4166eb(ai);
		}
	}
	self.var_27e5d923 = [];
}

/*
	Name: function_59722edc
	Namespace: namespace_df2b89fb
	Checksum: 0x6EA4B71E
	Offset: 0x6420
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function function_59722edc(str_side)
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
	Name: function_8fe135e9
	Namespace: namespace_df2b89fb
	Checksum: 0x2A64A2CD
	Offset: 0x64B0
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function function_8fe135e9()
{
	self.var_36e768e4 function_285f0f0b();
	foreach(e_door in self.var_dfffc7fc)
	{
		v_pos = function_93ea71d6(e_door);
		e_door Unlink();
		e_door moveto(v_pos, 0.3);
		e_door.e_clip Unlink();
		e_door.e_clip moveto(e_door.e_clip.var_b620e1b1.origin, 0.3);
	}
	self.var_dfffc7fc[0] waittill("movedone");
	util::wait_network_frame();
	foreach(e_door in self.var_dfffc7fc)
	{
		v_pos = function_93ea71d6(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door LinkTo(self.var_36e768e4);
		e_door.e_clip LinkTo(self.var_36e768e4);
	}
	thread function_a3291a93();
}

/*
	Name: function_9211290c
	Namespace: namespace_df2b89fb
	Checksum: 0x870CAA11
	Offset: 0x6738
	Size: 0x251
	Parameters: 0
	Flags: None
*/
function function_9211290c()
{
	foreach(e_door in self.var_dfffc7fc)
	{
		v_pos = function_93ea71d6(e_door);
		e_door Unlink();
		e_door moveto(v_pos, 0.3);
		e_door.e_clip Unlink();
		e_door.e_clip moveto(e_door.e_clip.var_b620e1b1.origin, 0.3);
	}
	self.var_dfffc7fc[0] waittill("movedone");
	util::wait_network_frame();
	foreach(e_door in self.var_dfffc7fc)
	{
		v_pos = function_93ea71d6(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door LinkTo(self.var_36e768e4);
		e_door.e_clip LinkTo(self.var_36e768e4);
	}
}

/*
	Name: function_285f0f0b
	Namespace: namespace_df2b89fb
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
	Name: function_a3291a93
	Namespace: namespace_df2b89fb
	Checksum: 0xE99250E8
	Offset: 0x6A10
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function function_a3291a93()
{
	zombies = GetAITeamArray(level.zombie_team);
	n_counter = 0;
	foreach(zombie in zombies)
	{
		if(!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}
		if(function_406e4ba9(zombie))
		{
			function_2f57e7c2(zombie);
		}
		n_counter++;
		if(n_counter % 3 == 0)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_712ddcb
	Namespace: namespace_df2b89fb
	Checksum: 0x169B5F65
	Offset: 0x6B48
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_712ddcb()
{
	if(!isdefined(self.var_d621a979))
	{
		return;
	}
	if(self.var_65323906)
	{
		self.var_d621a979 namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_USE_FREE");
	}
	else if(function_e7a31329())
	{
		self.var_d621a979 namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_OFFLINE");
	}
	else if(function_b55b4180())
	{
		self.var_d621a979 namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_COOLDOWN");
	}
	else
	{
		self.var_d621a979 namespace_8e578893::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_USE", 500);
	}
}

/*
	Name: function_2632b810
	Namespace: namespace_df2b89fb
	Checksum: 0xB2E91FB7
	Offset: 0x6C28
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_2632b810()
{
	if(isdefined(self.var_d621a979))
	{
		self.var_65323906 = 1;
		self.var_d621a979 notify("trigger");
	}
}

/*
	Name: function_d2e12d33
	Namespace: namespace_df2b89fb
	Checksum: 0xC6967EB0
	Offset: 0x6C60
	Size: 0x21D
	Parameters: 0
	Flags: None
*/
function function_d2e12d33()
{
	while(1)
	{
		function_de6e1f4f(self.var_d461052a);
		var_79623a1d = self.var_aced8be7;
		if(self.var_d461052a.player_used)
		{
			self.var_c2e30cf8[self.var_5d231abf].var_bd2282e4 = !self.var_c2e30cf8[self.var_5d231abf].var_bd2282e4;
			self.var_aced8be7 = function_d44a15ec();
		}
		if(self.var_aced8be7 != var_79623a1d)
		{
			function_ca899bfc();
			if(is_moving() && !level flag::get("callbox"))
			{
				sndnum = self.var_c2e30cf8[self.var_aced8be7].var_1866b220;
				level clientfield::set("sndTrainVox", sndnum);
				self.var_36e768e4 PlaySoundOnTag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
			}
			if(level flag::get("callbox"))
			{
				level flag::clear("callbox");
			}
			self.var_d461052a setHintString(&"ZM_ZOD_SWITCHING_PROGRESS");
			wait(1);
			if(flag::get("switches_enabled"))
			{
				self.var_d461052a setHintString(&"ZM_ZOD_SWITCH_ENABLE");
			}
		}
		level notify("hash_8939bd21");
	}
}

/*
	Name: function_de6e1f4f
	Namespace: namespace_df2b89fb
	Checksum: 0x56F3A46
	Offset: 0x6E88
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_de6e1f4f(var_d461052a)
{
	self.var_36e768e4 endon("hash_51689c0f");
	if(!flag::get("switches_enabled"))
	{
		flag::wait_till("switches_enabled");
	}
	var_d461052a.player_used = 0;
	var_d461052a waittill("trigger");
	var_d461052a.player_used = 1;
}

/*
	Name: function_ca899bfc
	Namespace: namespace_df2b89fb
	Checksum: 0x82EF5413
	Offset: 0x6F10
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function function_ca899bfc()
{
	if(self.var_aced8be7 == "slums")
	{
		self.var_36e768e4 HidePart("tag_sign_footlight");
		self.var_36e768e4 HidePart("tag_sign_canals");
		self.var_36e768e4 ShowPart("tag_sign_waterfront");
		playsoundatposition("evt_train_switch_track_hit", self.var_d461052a.origin);
	}
	else if(self.var_aced8be7 == "theater")
	{
		self.var_36e768e4 HidePart("tag_sign_canals");
		self.var_36e768e4 HidePart("tag_sign_waterfront");
		self.var_36e768e4 ShowPart("tag_sign_footlight");
		playsoundatposition("evt_train_switch_track_hit", self.var_d461052a.origin);
	}
	else if(self.var_aced8be7 == "canal")
	{
		self.var_36e768e4 HidePart("tag_sign_footlight");
		self.var_36e768e4 HidePart("tag_sign_waterfront");
		self.var_36e768e4 ShowPart("tag_sign_canals");
		playsoundatposition("evt_train_switch_track_hit", self.var_d461052a.origin);
	}
}

/*
	Name: function_ccd778ab
	Namespace: namespace_df2b89fb
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
		if(function_e8e6e4b4(e_player))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_971a908c
	Namespace: namespace_df2b89fb
	Checksum: 0x16D9C3ED
	Offset: 0x71A0
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function function_971a908c()
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
			e_player.on_train = function_e8e6e4b4(e_player);
		}
		wait(0.5);
	}
}

/*
	Name: function_e8e6e4b4
	Namespace: namespace_df2b89fb
	Checksum: 0xDF58DF76
	Offset: 0x72F0
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function function_e8e6e4b4(e_ent)
{
	return e_ent istouching(self.var_6732a75b);
}

/*
	Name: function_fb77d587
	Namespace: namespace_df2b89fb
	Checksum: 0xCD16708F
	Offset: 0x7328
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_fb77d587(ai)
{
	ai endon("death");
	ai endon("hash_894172f4");
	zm_net::network_safe_init("train_fall_check", 1);
	while(self zm_net::network_choke_action("train_fall_check", &function_e8e6e4b4, ai))
	{
		wait(2);
	}
	function_cc4166eb(ai);
}

/*
	Name: function_406e4ba9
	Namespace: namespace_df2b89fb
	Checksum: 0x78AAE0B6
	Offset: 0x73D0
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function function_406e4ba9(ent)
{
	return ent istouching(self.var_6732a75b);
}

/*
	Name: function_be4c98a3
	Namespace: namespace_df2b89fb
	Checksum: 0xB9A1FCB3
	Offset: 0x7408
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function function_be4c98a3(var_593a263a)
{
	if(!isdefined(var_593a263a))
	{
		var_593a263a = 0;
	}
	a_players = [];
	foreach(e_player in level.players)
	{
		if(var_593a263a && (e_player.ignoreme || !zm_utility::is_player_valid(e_player)))
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
	Name: function_2f57e7c2
	Namespace: namespace_df2b89fb
	Checksum: 0x7D5F2F11
	Offset: 0x7560
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_2f57e7c2(ai_zombie)
{
	ai_zombie.var_e0d198e4 = 1;
	Array::add(self.var_27e5d923, ai_zombie, 0);
	thread function_fb77d587(ai_zombie);
}

/*
	Name: function_cc4166eb
	Namespace: namespace_df2b89fb
	Checksum: 0x1A0CCCA2
	Offset: 0x75C0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_cc4166eb(ai_zombie)
{
	ai_zombie.var_e0d198e4 = 0;
	ArrayRemoveValue(self.var_27e5d923, ai_zombie);
	ai_zombie notify("hash_894172f4");
}

/*
	Name: function_997bcca8
	Namespace: namespace_df2b89fb
	Checksum: 0x2855851E
	Offset: 0x7618
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_997bcca8()
{
	self.var_27e5d923 = Array::remove_undefined(self.var_27e5d923);
}

/*
	Name: function_f037cd6
	Namespace: namespace_df2b89fb
	Checksum: 0x4E3CC587
	Offset: 0x7648
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_f037cd6()
{
	return self.var_27e5d923;
}

/*
	Name: function_c925ac0d
	Namespace: namespace_df2b89fb
	Checksum: 0x4F33D043
	Offset: 0x7660
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_c925ac0d()
{
	return float(GetTime() - self.var_a677da96) / 1000;
}

/*
	Name: function_c02d34bc
	Namespace: namespace_df2b89fb
	Checksum: 0x6857928C
	Offset: 0x7698
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_c02d34bc()
{
	self.var_a677da96 = GetTime();
}

/*
	Name: function_fc6b1519
	Namespace: namespace_df2b89fb
	Checksum: 0x1C2AC7C1
	Offset: 0x76B0
	Size: 0x18B
	Parameters: 2
	Flags: None
*/
function function_fc6b1519(ai, str_tag)
{
	self endon("death");
	s_tag = self.var_9f3b63f6[str_tag];
	s_tag.occupied = 1;
	v_tag_pos = self.var_36e768e4 GetTagOrigin(str_tag);
	v_tag_angles = self.var_36e768e4 GetTagAngles(str_tag);
	ai teleport(v_tag_pos, v_tag_angles);
	util::wait_network_frame();
	ai LinkTo(self.var_36e768e4, str_tag);
	ai AnimScripted("entered_train", v_tag_pos, v_tag_angles, s_tag.str_anim);
	ai zombie_shared::DoNoteTracks("entered_train");
	ai Unlink();
	s_tag.occupied = 0;
	if(is_moving())
	{
		function_2f57e7c2(ai);
	}
}

/*
	Name: function_e321055b
	Namespace: namespace_df2b89fb
	Checksum: 0xCF2A6F09
	Offset: 0x7848
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function function_e321055b()
{
	v_origin = (0, 0, 0);
	foreach(var_43240065 in self.var_c2e30cf8)
	{
		v_origin = v_origin + var_43240065.var_db628370.origin;
	}
	v_origin = v_origin / float(self.var_c2e30cf8.size);
	return v_origin;
}

/*
	Name: is_moving
	Namespace: namespace_df2b89fb
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
	Name: function_3e62f527
	Namespace: namespace_df2b89fb
	Checksum: 0x55BB8013
	Offset: 0x7958
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_3e62f527()
{
	return self.var_9e0dc993;
}

/*
	Name: function_b55b4180
	Namespace: namespace_df2b89fb
	Checksum: 0x73C29708
	Offset: 0x7970
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_b55b4180()
{
	return self flag::get("cooldown");
}

/*
	Name: function_e7a31329
	Namespace: namespace_df2b89fb
	Checksum: 0x58B6AC15
	Offset: 0x79A0
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_e7a31329()
{
	return self flag::get("offline");
}

/*
	Name: function_7d433c31
	Namespace: namespace_df2b89fb
	Checksum: 0x89FC4974
	Offset: 0x79D0
	Size: 0x127
	Parameters: 1
	Flags: Private
*/
function private function_7d433c31(str_tag)
{
	foreach(e_player in level.players)
	{
		v_pos = self.var_36e768e4 GetTagOrigin(str_tag);
		v_fwd = AnglesToForward(e_player.angles);
		var_f3512a4a = VectorNormalize(v_pos - e_player.origin);
		if(VectorDot(v_fwd, var_f3512a4a) > 0)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_fc1944ae
	Namespace: namespace_df2b89fb
	Checksum: 0xA8D9047B
	Offset: 0x7B00
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function function_fc1944ae()
{
	var_507be64f = [];
	foreach(tag in self.var_9f3b63f6)
	{
		if(tag.occupied)
		{
			continue;
		}
		if(!isdefined(var_507be64f))
		{
			var_507be64f = [];
		}
		else if(!IsArray(var_507be64f))
		{
			var_507be64f = Array(var_507be64f);
		}
		var_507be64f[var_507be64f.size] = tag;
	}
	var_507be64f = Array::randomize(var_507be64f);
	var_9dda59ac = [];
	a_players = function_be4c98a3(0);
	n_roll = RandomInt(100);
	if(n_roll < 80 && a_players.size > 0)
	{
		foreach(s_tag in var_507be64f)
		{
			if(function_7d433c31(s_tag.str_tag))
			{
				if(!isdefined(var_9dda59ac))
				{
					var_9dda59ac = [];
				}
				else if(!IsArray(var_9dda59ac))
				{
					var_9dda59ac = Array(var_9dda59ac);
				}
				var_9dda59ac[var_9dda59ac.size] = s_tag;
			}
		}
	}
	else if(var_9dda59ac.size > 2)
	{
		var_507be64f = var_9dda59ac;
	}
	if(var_507be64f.size == 0)
	{
		return undefined;
	}
	else
	{
		return Array::random(var_507be64f);
	}
}

/*
	Name: function_ea3da1ac
	Namespace: namespace_df2b89fb
	Checksum: 0x94A2A997
	Offset: 0x7DB0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function function_ea3da1ac()
{
	return self.var_36e768e4.origin;
}

/*
	Name: function_876255
	Namespace: namespace_df2b89fb
	Checksum: 0x9BC27727
	Offset: 0x7DD0
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function function_876255()
{
	var_6609d101 = GetEntArray("map_train", "targetname");
	while(1)
	{
		var_c7d3f5b3 = function_ae26c4a8();
		switch(var_c7d3f5b3)
		{
			case "slums":
			{
				var_112666d8 = 1;
				break;
			}
			case "theater":
			{
				var_112666d8 = 2;
				break;
			}
			case "canal":
			{
				var_112666d8 = 3;
				break;
			}
		}
		foreach(var_19166ffe in var_6609d101)
		{
			var_19166ffe clientfield::set("train_map_light", var_112666d8);
		}
		self flag::wait_till("moving");
		foreach(var_19166ffe in var_6609d101)
		{
			var_19166ffe clientfield::set("train_map_light", 0);
		}
		self flag::wait_till_clear("moving");
	}
}

/*
	Name: function_5fba2032
	Namespace: namespace_df2b89fb
	Checksum: 0x99EC1590
	Offset: 0x7FD8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_835aa2f1;

/*
	Name: function_df2b89fb
	Namespace: namespace_835aa2f1
	Checksum: 0xE17A404F
	Offset: 0x7FE8
	Size: 0xC25
	Parameters: 0
	Flags: 6
*/
function private autoexec function_df2b89fb()
{
	classes.var_df2b89fb[0] = spawnstruct();
	classes.var_df2b89fb[0].__vtable[1606033458] = &namespace_df2b89fb::function_5fba2032;
	classes.var_df2b89fb[0].__vtable[8872533] = &namespace_df2b89fb::function_876255;
	classes.var_df2b89fb[0].__vtable[-365059668] = &namespace_df2b89fb::function_ea3da1ac;
	classes.var_df2b89fb[0].__vtable[-65452882] = &namespace_df2b89fb::function_fc1944ae;
	classes.var_df2b89fb[0].__vtable[2101558321] = &namespace_df2b89fb::function_7d433c31;
	classes.var_df2b89fb[0].__vtable[-408743127] = &namespace_df2b89fb::function_e7a31329;
	classes.var_df2b89fb[0].__vtable[-1252310656] = &namespace_df2b89fb::function_b55b4180;
	classes.var_df2b89fb[0].__vtable[1046672679] = &namespace_df2b89fb::function_3e62f527;
	classes.var_df2b89fb[0].__vtable[-643491610] = &namespace_df2b89fb::is_moving;
	classes.var_df2b89fb[0].__vtable[-484375205] = &namespace_df2b89fb::function_e321055b;
	classes.var_df2b89fb[0].__vtable[-60091111] = &namespace_df2b89fb::function_fc6b1519;
	classes.var_df2b89fb[0].__vtable[-1070779204] = &namespace_df2b89fb::function_c02d34bc;
	classes.var_df2b89fb[0].__vtable[-920278003] = &namespace_df2b89fb::function_c925ac0d;
	classes.var_df2b89fb[0].__vtable[251886806] = &namespace_df2b89fb::function_f037cd6;
	classes.var_df2b89fb[0].__vtable[-1719939928] = &namespace_df2b89fb::function_997bcca8;
	classes.var_df2b89fb[0].__vtable[-868129045] = &namespace_df2b89fb::function_cc4166eb;
	classes.var_df2b89fb[0].__vtable[794290114] = &namespace_df2b89fb::function_2f57e7c2;
	classes.var_df2b89fb[0].__vtable[-1102276445] = &namespace_df2b89fb::function_be4c98a3;
	classes.var_df2b89fb[0].__vtable[1080970153] = &namespace_df2b89fb::function_406e4ba9;
	classes.var_df2b89fb[0].__vtable[-76032633] = &namespace_df2b89fb::function_fb77d587;
	classes.var_df2b89fb[0].__vtable[-387521356] = &namespace_df2b89fb::function_e8e6e4b4;
	classes.var_df2b89fb[0].__vtable[-1759866740] = &namespace_df2b89fb::function_971a908c;
	classes.var_df2b89fb[0].__vtable[-858294101] = &namespace_df2b89fb::function_ccd778ab;
	classes.var_df2b89fb[0].__vtable[-896951300] = &namespace_df2b89fb::function_ca899bfc;
	classes.var_df2b89fb[0].__vtable[-563208369] = &namespace_df2b89fb::function_de6e1f4f;
	classes.var_df2b89fb[0].__vtable[-756994765] = &namespace_df2b89fb::function_d2e12d33;
	classes.var_df2b89fb[0].__vtable[640858128] = &namespace_df2b89fb::function_2632b810;
	classes.var_df2b89fb[0].__vtable[118676939] = &namespace_df2b89fb::function_712ddcb;
	classes.var_df2b89fb[0].__vtable[-1557587309] = &namespace_df2b89fb::function_a3291a93;
	classes.var_df2b89fb[0].__vtable[677318411] = &namespace_df2b89fb::function_285f0f0b;
	classes.var_df2b89fb[0].__vtable[-1844369140] = &namespace_df2b89fb::function_9211290c;
	classes.var_df2b89fb[0].__vtable[-1881066007] = &namespace_df2b89fb::function_8fe135e9;
	classes.var_df2b89fb[0].__vtable[1500655324] = &namespace_df2b89fb::function_59722edc;
	classes.var_df2b89fb[0].__vtable[-1894359369] = &namespace_df2b89fb::function_8f165eb7;
	classes.var_df2b89fb[0].__vtable[972755727] = &namespace_df2b89fb::function_39fb130f;
	classes.var_df2b89fb[0].__vtable[1783161788] = &namespace_df2b89fb::function_6a48e3bc;
	classes.var_df2b89fb[0].__vtable[-1813351978] = &namespace_df2b89fb::function_93ea71d6;
	classes.var_df2b89fb[0].__vtable[-176962386] = &namespace_df2b89fb::function_f573c4ae;
	classes.var_df2b89fb[0].__vtable[-2142038298] = &namespace_df2b89fb::function_805316e6;
	classes.var_df2b89fb[0].__vtable[643610466] = &namespace_df2b89fb::function_265cb762;
	classes.var_df2b89fb[0].__vtable[1251890137] = &namespace_df2b89fb::function_4a9e53d9;
	classes.var_df2b89fb[0].__vtable[-1330668116] = &namespace_df2b89fb::function_b0af9dac;
	classes.var_df2b89fb[0].__vtable[-1788979289] = &namespace_df2b89fb::function_955e57a7;
	classes.var_df2b89fb[0].__vtable[824948449] = &namespace_df2b89fb::function_312bb6e1;
	classes.var_df2b89fb[0].__vtable[-1552434618] = &namespace_df2b89fb::function_a377ba46;
	classes.var_df2b89fb[0].__vtable[-762254342] = &namespace_df2b89fb::main;
	classes.var_df2b89fb[0].__vtable[1869264804] = &namespace_df2b89fb::function_6f6ab7a4;
	classes.var_df2b89fb[0].__vtable[-422924033] = &namespace_df2b89fb::Initialize;
	classes.var_df2b89fb[0].__vtable[-1431523639] = &namespace_df2b89fb::function_aaacaec9;
	classes.var_df2b89fb[0].__vtable[-576083502] = &namespace_df2b89fb::function_dda9a9d2;
	classes.var_df2b89fb[0].__vtable[-1448281630] = &namespace_df2b89fb::function_a9acf9e2;
	classes.var_df2b89fb[0].__vtable[-341908992] = &namespace_df2b89fb::function_eb9ee200;
	classes.var_df2b89fb[0].__vtable[1227831890] = &namespace_df2b89fb::move;
	classes.var_df2b89fb[0].__vtable[2125617211] = &namespace_df2b89fb::function_7eb2583b;
	classes.var_df2b89fb[0].__vtable[1274668080] = &namespace_df2b89fb::function_4bf9e430;
	classes.var_df2b89fb[0].__vtable[-733342228] = &namespace_df2b89fb::function_d44a15ec;
	classes.var_df2b89fb[0].__vtable[-1373191000] = &namespace_df2b89fb::function_ae26c4a8;
	classes.var_df2b89fb[0].__vtable[-1461528577] = &namespace_df2b89fb::function_a8e2d7ff;
	classes.var_df2b89fb[0].__vtable[-1929845851] = &namespace_df2b89fb::function_8cf8e3a5;
	classes.var_df2b89fb[0].__vtable[-1941346850] = &namespace_df2b89fb::function_8c4965de;
	classes.var_df2b89fb[0].__vtable[16013323] = &namespace_df2b89fb::function_f4580b;
	classes.var_df2b89fb[0].__vtable[900487325] = &namespace_df2b89fb::function_35ac589d;
	classes.var_df2b89fb[0].__vtable[298368378] = &namespace_df2b89fb::function_11c8bd7a;
	classes.var_df2b89fb[0].__vtable[-1690805083] = &namespace_df2b89fb::function_9b385ca5;
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
	Name: function_be4c98a3
	Namespace: namespace_835aa2f1
	Checksum: 0x7B70A744
	Offset: 0x8CA0
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function function_be4c98a3(var_593a263a)
{
	if(!isdefined(var_593a263a))
	{
		var_593a263a = 0;
	}
	return function_be4c98a3(level.o_zod_train);
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
	Name: function_26fcc525
	Namespace: namespace_835aa2f1
	Checksum: 0x95C19E39
	Offset: 0x8D10
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function function_26fcc525(ai)
{
	function_c02d34bc();
	spot = function_fc1944ae();
	if(isdefined(spot))
	{
		ai.var_3b08716c = spot.str_tag;
		function_fc6b1519(level.o_zod_train, ai);
	}
}

/*
	Name: function_a4a1ecff
	Namespace: namespace_835aa2f1
	Checksum: 0x514BEC09
	Offset: 0x8DA0
	Size: 0xE7
	Parameters: 3
	Flags: None
*/
function function_a4a1ecff(e_attacker, str_means_of_death, weapon)
{
	if(isdefined(self))
	{
		var_41227048 = 0;
		if(is_moving())
		{
			if(self.var_e0d198e4)
			{
				var_41227048 = 1;
			}
		}
		if(var_41227048)
		{
			self clientfield::set("zombie_gut_explosion", 1);
			self ghost();
		}
	}
	if(isdefined(level.o_zod_train))
	{
		if(isdefined(self) && self.var_e0d198e4)
		{
			function_cc4166eb(level.o_zod_train);
		}
		else
		{
			function_997bcca8();
		}
	}
}

/*
	Name: function_2fd24d1f
	Namespace: namespace_835aa2f1
	Checksum: 0xDE13BFA5
	Offset: 0x8E90
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function function_2fd24d1f()
{
	a_zombies = function_f037cd6();
	return a_zombies.size;
}

/*
	Name: function_42f8a1ab
	Namespace: namespace_835aa2f1
	Checksum: 0xDAF9ED5D
	Offset: 0x8EC8
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function function_42f8a1ab()
{
	return function_2fd24d1f() >= 6;
}

/*
	Name: function_c3bc2ffd
	Namespace: namespace_835aa2f1
	Checksum: 0xC4210679
	Offset: 0x8EE8
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function function_c3bc2ffd()
{
	return function_c925ac0d() > 10;
}

/*
	Name: function_1450b47e
	Namespace: namespace_835aa2f1
	Checksum: 0x9185ACAB
	Offset: 0x8F10
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_1450b47e()
{
	/#
		train = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(isdefined(train))
		{
			var_f5aa22ce = train GetOrigin();
			player = level.players[0];
			if(isdefined(player) && isdefined(var_f5aa22ce))
			{
				var_f5aa22ce = (var_f5aa22ce[0], var_f5aa22ce[1], var_f5aa22ce[2] - 100);
				player SetOrigin(var_f5aa22ce);
			}
		}
	#/
}

/*
	Name: function_6353976e
	Namespace: namespace_835aa2f1
	Checksum: 0x5577B68C
	Offset: 0x8FF8
	Size: 0x1EF
	Parameters: 0
	Flags: None
*/
function function_6353976e()
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
						function_8f165eb7();
						break;
					}
					case "Dev Block strings are not supported":
					{
						function_8fe135e9();
						break;
					}
					case "Dev Block strings are not supported":
					{
						function_1450b47e();
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

