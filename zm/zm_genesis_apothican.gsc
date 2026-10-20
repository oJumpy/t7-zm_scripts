#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_parasite;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_ai_margwa_elemental;
#using scripts\zm\_zm_ai_margwa_no_idgun;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_genesis_spiders;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_ee_quest;
#using scripts\zm\zm_genesis_flingers;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_power;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;
#using scripts\zm\zm_genesis_wasp;

#namespace zm_genesis_apothican;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_apothican
	Checksum: 0x75EF2E6A
	Offset: 0xB80
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_apothican", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_apothican
	Checksum: 0x85464193
	Offset: 0xBC8
	Size: 0x40B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "apothicon_player_keyline", 15000, 1, "int");
	clientfield::register("toplayer", "apothicon_entry_postfx", 15000, 1, "int");
	clientfield::register("world", "gas_fog_bank_switch", 15000, 1, "int");
	clientfield::register("scriptmover", "egg_spawn_fx", 15000, 1, "int");
	clientfield::register("scriptmover", "gateworm_mtl", 15000, 1, "int");
	clientfield::register("toplayer", "player_apothicon_egg", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_apothicon_egg", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_apothicon_egg_bg", 15000, 1, "int");
	clientfield::register("toplayer", "player_gate_worm", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_gate_worm", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_gate_worm_bg", 15000, 1, "int");
	level flag::init("player_in_apothicon");
	/#
		level flag::init("Dev Block strings are not supported");
		level thread function_87d7a33f();
	#/
	level thread function_890c450c("prison");
	level thread function_890c450c("sheffield");
	level thread function_890c450c("castle");
	level thread function_890c450c("verrucht");
	level thread function_913ca89b();
	level thread function_d1338047();
	level thread function_6e5d600d();
	level thread function_21a5cf5e();
	zm_spawner::register_zombie_death_event_callback(&function_bfaac59);
	zm_spawner::register_zombie_death_event_callback(&function_6119f23);
	level thread spider_round_spawning();
	level thread function_72e88a5f();
	level thread function_411feb6a();
	level thread function_dd6ccbfc();
	callback::on_spawned(&function_ceb45430);
}

/*
	Name: __main__
	Namespace: zm_genesis_apothican
	Checksum: 0x21FF58D7
	Offset: 0xFE0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread function_2af9e8f2();
	level thread function_9071b894();
}

/*
	Name: function_ceb45430
	Namespace: zm_genesis_apothican
	Checksum: 0xC15C6290
	Offset: 0x1020
	Size: 0x103
	Parameters: 0
	Flags: Private
*/
function private function_ceb45430()
{
	if(!self flag::exists("holding_egg"))
	{
		self flag::init("holding_egg");
	}
	if(!self flag::exists("holding_gateworm"))
	{
		self flag::init("holding_gateworm");
	}
	if(self flag::get("holding_gateworm"))
	{
		self clientfield::set_to_player("player_gate_worm", 1);
	}
	else if(self flag::get("holding_egg"))
	{
		self clientfield::set_to_player("player_apothicon_egg", 1);
	}
}

/*
	Name: function_b67eab19
	Namespace: zm_genesis_apothican
	Checksum: 0xAF960AC8
	Offset: 0x1130
	Size: 0xF3
	Parameters: 3
	Flags: Private
*/
function private function_b67eab19(var_1d640f59, str_widget_clientuimodel, b_acquired)
{
	level notify("widget_ui_override");
	self endon("disconnect");
	if(b_acquired)
	{
		if(isdefined(var_1d640f59))
		{
			self thread clientfield::set_to_player(var_1d640f59, 1);
		}
	}
	else if(isdefined(var_1d640f59))
	{
		self thread clientfield::set_to_player(var_1d640f59, 0);
	}
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 1);
	level util::waittill_any_ex(3.5, "widget_ui_override", self, "disconnect");
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: function_890c450c
	Namespace: zm_genesis_apothican
	Checksum: 0xE1936E2C
	Offset: 0x1230
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_890c450c(str_name)
{
	s_trigger_pos = struct::get("apothican_exit_" + str_name, "targetname");
	var_79ade33c = spawnstruct();
	var_79ade33c.origin = s_trigger_pos.origin;
	var_79ade33c.angles = s_trigger_pos.angles;
	var_79ade33c.radius = 100;
	var_79ade33c.script_unitrigger_type = "unitrigger_radius";
	var_79ade33c.cursor_hint = "HINT_NOICON";
	var_79ade33c.name = str_name;
	var_79ade33c.target = s_trigger_pos.target;
	var_79ade33c.a_s_port_locs = struct::get_array(s_trigger_pos.target, "targetname");
	if(isdefined(s_trigger_pos.script_string))
	{
		var_79ade33c.script_string = s_trigger_pos.script_string;
	}
	var_79ade33c.prompt_and_visibility_func = &zm_genesis_util::function_5ea427bf;
	zm_unitrigger::register_unitrigger(var_79ade33c, &function_ea9e816a);
}

/*
	Name: function_ea9e816a
	Namespace: zm_genesis_apothican
	Checksum: 0x6AE3770E
	Offset: 0x13E0
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_ea9e816a()
{
	if(isdefined(self.script_string))
	{
		str_zone = self.script_string;
	}
	while(1)
	{
		self waittill("trigger", e_portee);
		if(isdefined(e_portee.b_is_flung) && e_portee.b_is_flung)
		{
			continue;
		}
		if(isPlayer(e_portee) && !e_portee laststand::player_is_in_laststand() && !e_portee.IS_DRINKING > 0)
		{
			e_portee thread function_657f1d1(self.stub, str_zone, self.origin);
		}
	}
}

/*
	Name: function_657f1d1
	Namespace: zm_genesis_apothican
	Checksum: 0xCD52D87C
	Offset: 0x14D0
	Size: 0x51B
	Parameters: 4
	Flags: None
*/
function function_657f1d1(s_stub, str_zone, v_portal, var_db6533)
{
	if(!isdefined(var_db6533))
	{
		var_db6533 = 0;
	}
	self endon("disconnect");
	self endon("death");
	if(isdefined(self.b_is_flung) && self.b_is_flung)
	{
		return;
	}
	self.b_is_flung = 1;
	a_s_spots = struct::get_array("apothican_exit_" + s_stub.name + "_pos", "targetname");
	self zm_utility::create_streamer_hint(a_s_spots[0].origin, a_s_spots[0].angles, 1);
	self.b_invulnerable = self EnableInvulnerability();
	self AllowCrouch(0);
	self AllowProne(0);
	self notsolid();
	if(self GetStance() != "stand")
	{
		self SetStance("stand");
	}
	self playsound("zmb_apoth_guts_fling");
	nd_start = GetVehicleNode("apo_exit_spline_" + s_stub.name, "targetname");
	nd_end = GetVehicleNode("apothicon_spline_" + s_stub.name, "targetname");
	var_413ea50f = vehicle::spawn(undefined, "player_vehicle", "flinger_vehicle", self.origin, self.angles);
	self PlayerLinkToDelta(var_413ea50f);
	self PlayRumbleOnEntity("zm_castle_flinger_launch");
	self clientfield::set_to_player("flinger_flying_postfx", 1);
	self thread zm_genesis_flingers::function_c1f1756a();
	var_413ea50f SetIgnorePauseWorld(1);
	self thread function_538e24a(var_413ea50f, s_stub);
	if(!var_db6533)
	{
		var_413ea50f vehicle::get_on_and_go_path(nd_start);
	}
	self DisableWeapons();
	var_413ea50f thread scene::Play("cin_zm_gen_player_fall_loop", self);
	var_413ea50f vehicle::get_on_and_go_path(nd_end);
	self thread ground_slam();
	self function_3298b25f(s_stub);
	self thread zm_genesis_flingers::function_29c06608();
	self solid();
	self thread zm_genesis_flingers::function_9f131b98();
	self AllowCrouch(1);
	self AllowProne(1);
	self playsound("zmb_fling_land");
	var_413ea50f scene::stop("cin_zm_gen_player_fall_loop");
	self enableWeapons();
	self zm_utility::clear_streamer_hint();
	self.b_is_flung = undefined;
	util::wait_network_frame();
	var_413ea50f.delete_on_death = 1;
	var_413ea50f notify("death");
	if(!isalive(var_413ea50f))
	{
		var_413ea50f delete();
	}
}

/*
	Name: ground_slam
	Namespace: zm_genesis_apothican
	Checksum: 0xEBD3C309
	Offset: 0x19F8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function ground_slam()
{
	self PlayRumbleOnEntity("zm_castle_flinger_land");
	self clientfield::set_to_player("flinger_flying_postfx", 0);
	Earthquake(0.5, 1, self.origin, 100);
}

/*
	Name: function_538e24a
	Namespace: zm_genesis_apothican
	Checksum: 0x9D4F645
	Offset: 0x1A70
	Size: 0x173
	Parameters: 2
	Flags: None
*/
function function_538e24a(var_413ea50f, s_stub)
{
	var_413ea50f waittill("start_white_flash");
	switch(s_stub.name)
	{
		case "prison":
		{
			n_hold_time = 1;
			self zm_genesis_portals::function_eec1f014("prison", 4, 1);
			break;
		}
		case "sheffield":
		{
			n_hold_time = 0.7;
			self zm_genesis_portals::function_eec1f014("start", 2, 1);
			break;
		}
		case "castle":
		{
			n_hold_time = 0.7;
			self zm_genesis_portals::function_eec1f014("temple", 8, 1);
			break;
		}
		case "verrucht":
		{
			n_hold_time = 0.7;
			self zm_genesis_portals::function_eec1f014("asylum", 6, 1);
			break;
		}
	}
	self thread LUI::screen_flash(0.1, n_hold_time, 0.8, 1, "white");
}

/*
	Name: function_3298b25f
	Namespace: zm_genesis_apothican
	Checksum: 0x7242F020
	Offset: 0x1BF0
	Size: 0x14B
	Parameters: 1
	Flags: Private
*/
function private function_3298b25f(s_stub)
{
	self endon("death");
	a_s_spots = struct::get_array("apothican_exit_" + s_stub.name + "_pos", "targetname");
	for(var_a05a47c7 = s_stub achievement_none(self); positionWouldTelefrag(var_a05a47c7.origin);  = s_stub achievement_none(self))
	{
		util::wait_network_frame();
	}
	self Unlink();
	self SetOrigin(var_a05a47c7.origin);
	self SetPlayerAngles(var_a05a47c7.angles);
	self clientfield::increment_to_player("flinger_land_smash");
}

/*
	Name: achievement_none
	Namespace: zm_genesis_apothican
	Checksum: 0xD90A2531
	Offset: 0x1D48
	Size: 0x115
	Parameters: 1
	Flags: Private
*/
function private achievement_none(player)
{
	a_s_spots = struct::get_array("apothican_exit_" + self.name + "_pos", "targetname");
	/#
		Assert(a_s_spots.size, "Dev Block strings are not supported" + self.name);
	#/
	foreach(s_spot in a_s_spots)
	{
		if(s_spot.script_int === player.characterindex + 1)
		{
			return s_spot;
		}
	}
}

/*
	Name: function_d1338047
	Namespace: zm_genesis_apothican
	Checksum: 0xCA8EB0C0
	Offset: 0x1E68
	Size: 0x235
	Parameters: 0
	Flags: None
*/
function function_d1338047()
{
	level.var_b8b48a73 = [];
	level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
	while(1)
	{
		a_players = level.activePlayers;
		level.var_b8b48a73 = [];
		foreach(e_player in a_players)
		{
			if(zm_utility::is_player_valid(e_player))
			{
				str_player_zone = e_player zm_zonemgr::get_player_zone();
				if(str_player_zone === "apothicon_interior_zone")
				{
					if(!level flag::get("player_in_apothicon"))
					{
						level flag::set("player_in_apothicon");
					}
					level.var_b8b48a73[level.var_b8b48a73.size] = e_player;
					if(isdefined(level.ai_companion) && level.ai_companion.leader == e_player && (!isdefined(level.var_b3671284) && level.var_b3671284))
					{
						e_player thread function_bb3f566();
					}
				}
			}
		}
		if(level.var_b8b48a73.size == 0 && level flag::get("player_in_apothicon"))
		{
			level flag::clear("player_in_apothicon");
		}
		wait(1);
	}
}

/*
	Name: function_bb3f566
	Namespace: zm_genesis_apothican
	Checksum: 0xB6323560
	Offset: 0x20A8
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_bb3f566()
{
	level.var_b3671284 = 1;
	wait(4);
	var_ed731554 = [];
	for(i = 0; i < 3; i++)
	{
		ai_spider = zm_ai_spiders::special_spider_spawn(1);
		if(isai(ai_spider))
		{
			if(!isdefined(var_ed731554))
			{
				var_ed731554 = [];
			}
			else if(!IsArray(var_ed731554))
			{
				var_ed731554 = Array(var_ed731554);
			}
			var_ed731554[var_ed731554.size] = ai_spider;
		}
	}
	while(var_ed731554.size)
	{
		var_ed731554 = Array::remove_dead(var_ed731554, 0);
		util::wait_network_frame();
	}
	while(isdefined(level.ai_companion))
	{
		util::wait_network_frame();
	}
	level.var_b3671284 = 0;
}

/*
	Name: function_6e5d600d
	Namespace: zm_genesis_apothican
	Checksum: 0x4943377F
	Offset: 0x2200
	Size: 0x277
	Parameters: 0
	Flags: None
*/
function function_6e5d600d()
{
	level waittill("start_zombie_round_logic");
	while(1)
	{
		a_players = level.activePlayers;
		foreach(e_player in a_players)
		{
			if(zm_utility::is_player_valid(e_player))
			{
				if(e_player.island_name === "apothicon_island" && (!isdefined(e_player.var_13102f86) && e_player.var_13102f86))
				{
					e_player.var_13102f86 = 1;
					e_player clientfield::set("apothicon_player_keyline", 1);
					e_player.var_e033e4dc = 1;
					e_player notify("hash_a8c34632");
					continue;
				}
				if(e_player.island_name === "arena_island" && (!isdefined(e_player.var_13102f86) && e_player.var_13102f86))
				{
					e_player.var_13102f86 = 1;
					e_player clientfield::set("apothicon_player_keyline", 1);
					continue;
				}
				if(isdefined(e_player.var_13102f86) && e_player.var_13102f86 && e_player.island_name !== "apothicon_island" && e_player.island_name !== "arena_island")
				{
					self.var_e033e4dc = undefined;
					e_player.var_13102f86 = undefined;
					e_player clientfield::set("apothicon_player_keyline", 0);
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_dd6ccbfc
	Namespace: zm_genesis_apothican
	Checksum: 0x1E2BD621
	Offset: 0x2480
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function function_dd6ccbfc()
{
	level endon("apothicon_trapped");
	level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
	while(1)
	{
		foreach(e_player in level.activePlayers)
		{
			if(isdefined(e_player.var_e033e4dc) && e_player.var_e033e4dc)
			{
				e_player PlayRumbleOnEntity("zm_genesis_apothicon_roar");
			}
		}
		wait(RandomFloatRange(40, 50));
	}
}

/*
	Name: function_913ca89b
	Namespace: zm_genesis_apothican
	Checksum: 0x64B13387
	Offset: 0x25B0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_913ca89b()
{
	level.var_2ac85a6c = struct::get_array("apothican_wasp_spawn_pos", "targetname");
}

/*
	Name: function_21a5cf5e
	Namespace: zm_genesis_apothican
	Checksum: 0x6CA7BBAC
	Offset: 0x25E8
	Size: 0x5FF
	Parameters: 0
	Flags: None
*/
function function_21a5cf5e()
{
	level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
	function_9ccb8410(30);
	level.var_973d41cb = 0;
	while(1)
	{
		var_22c7539e = function_1affd18d();
		if(level.var_973d41cb < var_22c7539e)
		{
			e_player = function_551d8f75();
			if(isdefined(e_player))
			{
				spawn_point = function_2b03ee2a(e_player);
				if(isdefined(spawn_point))
				{
					v_spawn_origin = spawn_point.origin;
					v_ground = bullettrace(spawn_point.origin + VectorScale((0, 0, 1), 40), spawn_point.origin + VectorScale((0, 0, 1), 40) + VectorScale((0, 0, -1), 100000), 0, undefined)["position"];
					if(DistanceSquared(v_ground, spawn_point.origin) < 1600)
					{
						v_spawn_origin = v_ground + VectorScale((0, 0, 1), 40);
					}
					queryResult = PositionQuery_Source_Navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
					a_points = Array::randomize(queryResult.data);
					a_spawn_origins = [];
					n_points_found = 0;
					foreach(point in a_points)
					{
						str_zone = zm_zonemgr::get_zone_from_position(point.origin, 1);
						if(isdefined(str_zone) && str_zone == "apothicon_interior_zone")
						{
							if(BulletTracePassed(point.origin, spawn_point.origin, 0, e_player))
							{
								if(!isdefined(a_spawn_origins))
								{
									a_spawn_origins = [];
								}
								else if(!IsArray(a_spawn_origins))
								{
									a_spawn_origins = Array(a_spawn_origins);
								}
								a_spawn_origins[a_spawn_origins.size] = point.origin;
								n_points_found++;
								if(n_points_found >= 1)
								{
									break;
								}
							}
						}
					}
					if(a_spawn_origins.size >= 1)
					{
						n_spawn = 0;
						while(n_spawn < 1)
						{
							for(i = a_spawn_origins.size - 1; i >= 0; i--)
							{
								v_origin = a_spawn_origins[i];
								level.var_c200ab6[0].origin = v_origin;
								ai = zombie_utility::spawn_zombie(level.var_c200ab6[0]);
								if(isdefined(ai))
								{
									ai parasite::set_parasite_enemy(e_player);
									level thread zm_genesis_wasp::wasp_spawn_init(ai, v_origin);
									ArrayRemoveIndex(a_spawn_origins, i);
									ai.ignore_enemy_count = 1;
									ai.var_95494717 = 1;
									ai.no_damage_points = 1;
									ai.deathpoints_already_given = 1;
									ai thread function_e45363e3();
									if(isdefined(level.zm_wasp_spawn_callback))
									{
										ai thread [[level.zm_wasp_spawn_callback]]();
									}
									level.var_973d41cb++;
									function_9ccb8410(50);
									n_spawn++;
									wait(RandomFloatRange(0.06666666, 0.1333333));
									break;
								}
								wait(RandomFloatRange(0.06666666, 0.1333333));
							}
						}
						b_swarm_spawned = 1;
					}
					util::wait_network_frame();
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_1affd18d
	Namespace: zm_genesis_apothican
	Checksum: 0xE7DB6C5
	Offset: 0x2BF0
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function function_1affd18d()
{
	n_wasps = 0;
	switch(level.var_b8b48a73.size)
	{
		case 1:
		{
			n_wasps = 1;
			break;
		}
		case 2:
		{
			n_wasps = 2;
			break;
		}
		case 3:
		{
			n_wasps = 3;
			break;
		}
		case 4:
		{
			n_wasps = 4;
			break;
		}
		case 0:
		case default:
		{
			n_wasps = 0;
			break;
		}
	}
	return n_wasps;
}

/*
	Name: function_2b03ee2a
	Namespace: zm_genesis_apothican
	Checksum: 0xDFE1DB4B
	Offset: 0x2CA0
	Size: 0x149
	Parameters: 1
	Flags: None
*/
function function_2b03ee2a(e_player)
{
	queryResult = PositionQuery_Source_Navigation(e_player.origin + (0, 0, randomIntRange(40, 100)), 300, 600, 10, 10, "navvolume_small");
	a_points = Array::randomize(queryResult.data);
	foreach(point in a_points)
	{
		if(BulletTracePassed(point.origin, e_player.origin, 0, e_player))
		{
			return point;
		}
	}
	return a_points[0];
}

/*
	Name: function_551d8f75
	Namespace: zm_genesis_apothican
	Checksum: 0xCD6A25C
	Offset: 0x2DF8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_551d8f75()
{
	e_target = undefined;
	n_wait_time = 25;
	n_current_time = GetTime();
	for(i = 0; i < level.var_b8b48a73.size; i++)
	{
		e_player = level.var_b8b48a73[i];
		if(!isdefined(e_player.var_d273f814))
		{
			e_player.var_d273f814 = n_current_time;
			return e_player;
		}
		n_dt = n_current_time - e_player.var_d273f814 / 1000;
		if(n_dt >= n_wait_time)
		{
			n_wait_time = n_dt;
			e_target = e_player;
		}
	}
	if(isdefined(e_target))
	{
		e_target.var_d273f814 = n_current_time;
	}
	return e_target;
}

/*
	Name: function_bfaac59
	Namespace: zm_genesis_apothican
	Checksum: 0x16EBECA9
	Offset: 0x2F18
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_bfaac59(e_attacker)
{
	if(isdefined(self.var_95494717) && self.var_95494717)
	{
		level.var_973d41cb--;
	}
}

/*
	Name: function_6119f23
	Namespace: zm_genesis_apothican
	Checksum: 0xA48D0D2E
	Offset: 0x2F50
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function function_6119f23(e_attacker)
{
	if(isdefined(self.var_9f6fbb95) && self.var_9f6fbb95)
	{
		if(self.b_for_ee === 1)
		{
			level.var_c15eb311--;
			if(level.var_c15eb311 == 0 && level flag::get("acm_wave_in_progress"))
			{
				level flag::clear("acm_wave_in_progress");
				level notify("hash_ee91de1d");
				if(level.var_db16318c == level.var_4bf2a542.size)
				{
					level.var_d29b5881 = self.origin;
					level flag::set("acm_done");
				}
			}
		}
	}
}

/*
	Name: function_e45363e3
	Namespace: zm_genesis_apothican
	Checksum: 0x1EBD65D9
	Offset: 0x3038
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_e45363e3()
{
	self endon("death");
	while(1)
	{
		if(level.var_b8b48a73.size == 0)
		{
			self DoDamage(self.health + 1, self.origin);
			return;
		}
		util::wait_network_frame();
	}
}

/*
	Name: spider_round_spawning
	Namespace: zm_genesis_apothican
	Checksum: 0x81C1AEC6
	Offset: 0x30B0
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function spider_round_spawning()
{
	level.var_a3ad836b = 8;
	level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
	function_9ccb8410(120);
	level.n_next_spider_round = level.round_number + 2;
	while(1)
	{
		level waittill("between_round_over");
		b_spider_round = 0;
		if(level.n_next_spider_round <= level.round_number)
		{
			if(level.var_b8b48a73.size > 0)
			{
				level.var_adca2f3c = 1;
				b_spider_round = 1;
				function_bd0872bb(60);
			}
		}
		if(b_spider_round)
		{
			level waittill("end_of_round");
			level.n_next_spider_round = level.round_number + randomIntRange(4, 6);
		}
	}
}

/*
	Name: function_bd0872bb
	Namespace: zm_genesis_apothican
	Checksum: 0xDD7A2324
	Offset: 0x31F0
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function function_bd0872bb(n_time)
{
	wait(n_time);
	level.var_adca2f3c = 0;
	level.var_7cba7005 = 0;
}

/*
	Name: function_72e88a5f
	Namespace: zm_genesis_apothican
	Checksum: 0xCC7A7EEB
	Offset: 0x3220
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_72e88a5f()
{
	level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
	level flag::init("apothican_random_boss_first_session_completed");
	level.var_2306bf38 = 0;
	level.var_638dde56 = 0;
	level.var_71630d50 = 0;
	level.var_89b9d07e = 0;
	level.var_1a7635e1 = struct::get_array("margwa_pod", "targetname");
	level thread function_e550951a();
}

/*
	Name: function_e550951a
	Namespace: zm_genesis_apothican
	Checksum: 0xB32E66C2
	Offset: 0x3300
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function function_e550951a()
{
	while(1)
	{
		n_delay = RandomFloatRange(360, 480);
		function_9ccb8410(n_delay);
		function_ecd2e6b5();
		while(!function_a6e114bc(self))
		{
			wait(1);
		}
		s_spawn = level.var_1a7635e1[RandomInt(level.var_1a7635e1.size)];
		s_spawn thread function_fd1e5c6c();
	}
}

/*
	Name: function_fd1e5c6c
	Namespace: zm_genesis_apothican
	Checksum: 0xC857BE13
	Offset: 0x33D8
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function function_fd1e5c6c()
{
	function_49a0c182();
	switch(level.var_71630d50)
	{
		case 0:
		{
			self thread spawn_apothican_margwa();
			break;
		}
		case 1:
		{
			if(level flag::get("apothican_random_boss_first_session_completed"))
			{
				if(math::cointoss())
				{
					self thread spawn_apothican_margwa();
				}
				else
				{
					self thread spawn_apothican_mechz();
				}
			}
			else
			{
				self thread spawn_apothican_margwa();
			}
			break;
		}
		case default:
		{
			if(level.var_89b9d07e == 0)
			{
				self thread spawn_apothican_mechz();
			}
			else
			{
				self thread spawn_apothican_margwa();
			}
			break;
		}
	}
}

/*
	Name: spawn_apothican_mechz
	Namespace: zm_genesis_apothican
	Checksum: 0x938BA770
	Offset: 0x34F8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function spawn_apothican_mechz(var_d3c04db8)
{
	if(!isdefined(var_d3c04db8))
	{
		var_d3c04db8 = 0;
	}
	if(var_d3c04db8)
	{
		s_mechz = struct::get("apothican_mechz_spawn", "targetname");
	}
	else
	{
		s_mechz = self;
	}
	ai_mechz = zm_ai_mechz::spawn_mechz(s_mechz, 0);
	if(isdefined(ai_mechz))
	{
		ai_mechz.var_9b31a70d = 1;
		level.var_638dde56++;
		level.var_89b9d07e++;
	}
}

/*
	Name: spawn_apothican_margwa
	Namespace: zm_genesis_apothican
	Checksum: 0xA404292A
	Offset: 0x35B0
	Size: 0x197
	Parameters: 2
	Flags: None
*/
function spawn_apothican_margwa(str_type, b_for_ee)
{
	if(!isdefined(str_type))
	{
		str_type = "random";
	}
	if(!isdefined(b_for_ee))
	{
		b_for_ee = 0;
	}
	if(str_type == "random")
	{
		var_c624cf3b = RandomInt(100);
		if(var_c624cf3b < 50)
		{
			str_type = "plain";
		}
		else if(var_c624cf3b < 75)
		{
			str_type = "fire";
		}
		else
		{
			str_type = "shadow";
		}
	}
	switch(str_type)
	{
		case "fire":
		{
			ai_margwa = level thread zm_ai_margwa_elemental::function_75b161ab(undefined, self);
			break;
		}
		case "shadow":
		{
			ai_margwa = level thread zm_ai_margwa_elemental::function_26efbc37(undefined, self);
			break;
		}
		case default:
		{
			ai_margwa = level thread zm_ai_margwa::spawn_margwa(self);
		}
	}
	if(isdefined(ai_margwa))
	{
		ai_margwa.var_9f6fbb95 = 1;
		level.var_2306bf38++;
		level.var_71630d50++;
		if(b_for_ee)
		{
			ai_margwa.b_for_ee = b_for_ee;
			level.var_c15eb311++;
		}
	}
}

/*
	Name: function_49a0c182
	Namespace: zm_genesis_apothican
	Checksum: 0xBB2A5F6
	Offset: 0x3750
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_49a0c182()
{
	if(level.var_71630d50 >= 2 && level.var_89b9d07e >= 1)
	{
		level.var_71630d50 = 0;
		level.var_89b9d07e = 0;
		level flag::set("apothican_random_boss_first_session_completed");
	}
}

/*
	Name: function_26da4beb
	Namespace: zm_genesis_apothican
	Checksum: 0xBFEF2F9A
	Offset: 0x37B8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_26da4beb(n_stage)
{
	if(isdefined(self.script_int))
	{
		if(self.script_int > n_stage)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_a6e114bc
	Namespace: zm_genesis_apothican
	Checksum: 0x50E83D7
	Offset: 0x37F0
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_a6e114bc(s_pos)
{
	b_can_spawn = 1;
	n_current_time = GetTime();
	if(isdefined(level.var_f77d7372))
	{
		var_47768568 = n_current_time - level.var_f77d7372 / 1000;
		if(var_47768568 < 300)
		{
			b_can_spawn = 0;
		}
	}
	if(level.var_2306bf38 >= 1 || level.var_638dde56 >= 1)
	{
		b_can_spawn = 0;
	}
	if(!b_can_spawn)
	{
		return 0;
	}
	level.var_f77d7372 = n_current_time;
	return 1;
}

/*
	Name: function_ecd2e6b5
	Namespace: zm_genesis_apothican
	Checksum: 0xDD62D84A
	Offset: 0x38B0
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function function_ecd2e6b5()
{
	/#
		if(level flag::get("Dev Block strings are not supported"))
		{
			return;
		}
		level endon("hash_540f913f");
	#/
	if(!isdefined(level.var_f77d7372))
	{
		return;
	}
	n_time = GetTime();
	n_dt = n_time - level.var_f77d7372 / 1000;
	if(n_dt < 240)
	{
		n_delay = 240 - n_dt + randomIntRange(120, 240);
		wait(n_delay);
	}
}

/*
	Name: function_9ccb8410
	Namespace: zm_genesis_apothican
	Checksum: 0xE4E29D7D
	Offset: 0x3970
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function function_9ccb8410(n_delay)
{
	/#
		if(level flag::get("Dev Block strings are not supported"))
		{
			return;
		}
		level endon("hash_540f913f");
	#/
	n_time = GetTime();
	var_47768568 = n_time;
	n_total_time = 0;
	while(1)
	{
		n_time = GetTime();
		if(level.var_b8b48a73.size > 0)
		{
			n_total_time = n_total_time + n_time - var_47768568 / 1000;
		}
		var_47768568 = n_time;
		if(n_total_time >= n_delay)
		{
			return;
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_411feb6a
	Namespace: zm_genesis_apothican
	Checksum: 0x1C675777
	Offset: 0x3A50
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function function_411feb6a()
{
	function_9ccb8410(10);
	s_center = struct::get("apothicon_center", "targetname");
	b_first_time = 1;
	while(1)
	{
		if(b_first_time == 1)
		{
			n_delay = 60;
			b_first_time = 0;
		}
		else
		{
			n_delay = randomIntRange(150, 210);
		}
		function_9ccb8410(n_delay);
		level.var_a5d2ba4 = 1;
		foreach(player in level.var_b8b48a73)
		{
			player PlayRumbleOnEntity("zm_genesis_apothicon_gas");
			Earthquake(0.7, 3, s_center.origin, 2000);
			playsoundatposition("evt_belly_digest", (0, 0, 0));
		}
		level clientfield::set("gas_fog_bank_switch", 1);
		exploder::exploder("fxexp_106");
		wait(155);
		exploder::stop_exploder("fxexp_106");
		level clientfield::set("gas_fog_bank_switch", 0);
		level.var_a5d2ba4 = 0;
	}
}

/*
	Name: function_2af9e8f2
	Namespace: zm_genesis_apothican
	Checksum: 0x4ABBF6D9
	Offset: 0x3C90
	Size: 0x179
	Parameters: 0
	Flags: None
*/
function function_2af9e8f2()
{
	level flag::wait_till("book_placed");
	a_s_eggs = struct::get_array("gateworm_egg", "targetname");
	a_s_eggs = Array::randomize(a_s_eggs);
	level.var_393eea44 = [];
	foreach(s_egg in a_s_eggs)
	{
		if(!isdefined(level.var_393eea44[s_egg.script_int]))
		{
			level.var_393eea44[s_egg.script_int] = s_egg;
			s_egg.v_origin_start = s_egg.origin;
			s_egg.var_c1c6575b = s_egg.origin + VectorScale((0, 0, 1), 1000);
			s_egg thread function_79912fdc();
		}
	}
}

/*
	Name: function_79912fdc
	Namespace: zm_genesis_apothican
	Checksum: 0xBDCAC2BB
	Offset: 0x3E18
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_79912fdc()
{
	self.origin = self.v_origin_start;
	e_egg = util::spawn_model("p7_fxanim_zm_gen_gateworm_egg_mod", self.var_c1c6575b, self.angles);
	e_egg thread egg_update(self);
	e_egg playsound("zmb_main_omelettes_egg_spawn");
	e_egg PlayLoopSound("zmb_main_omelettes_egg_lp", 2);
}

/*
	Name: egg_update
	Namespace: zm_genesis_apothican
	Checksum: 0x97ED6508
	Offset: 0x3EC8
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function egg_update(s_egg)
{
	self EnableLinkTo();
	var_e777b564 = self GetTagOrigin("ovary_egg_tag_jnt");
	var_1436760b = util::spawn_model("tag_origin", self.origin, VectorScale((1, 0, 0), 90));
	var_1436760b LinkTo(self, "ovary_egg_tag_jnt");
	var_1436760b clientfield::set("egg_spawn_fx", 1);
	self MoveZ(-1000, 4);
	wait(4);
	var_1436760b clientfield::set("egg_spawn_fx", 0);
	var_1436760b delete();
	s_egg.origin = s_egg.origin + VectorScale((0, 0, 1), 16);
	s_unitrigger = s_egg zm_unitrigger::create_unitrigger("", 64, &function_e3dd263c);
	s_egg waittill("trigger_activated", e_player);
	if(!e_player flag::get("holding_egg"))
	{
		e_player thread zm_genesis_vo::function_2a22bd54();
		e_player give_egg(s_egg);
		e_player playsound("zmb_main_omelettes_egg_pickup");
		self delete();
		zm_unitrigger::unregister_unitrigger(s_unitrigger);
	}
}

/*
	Name: function_e3dd263c
	Namespace: zm_genesis_apothican
	Checksum: 0x246245E9
	Offset: 0x4120
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_e3dd263c(e_player)
{
	if(e_player flag::get("holding_egg") || e_player flag::get("holding_gateworm"))
	{
		self setHintString("");
		return 0;
	}
	self setHintString("");
	return 1;
}

/*
	Name: function_9071b894
	Namespace: zm_genesis_apothican
	Checksum: 0xACF5FC54
	Offset: 0x41B8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function function_9071b894()
{
	level flag::wait_till("book_placed");
	zm_spawner::register_zombie_death_event_callback(&function_31a6b711);
	level.var_2a7689da = struct::get_array("gateworm_pod", "targetname");
	foreach(var_661a8e9b in level.var_2a7689da)
	{
		var_661a8e9b thread pod_update();
	}
	level flag::wait_till("rift_entrance_open");
	zm_spawner::deregister_zombie_death_event_callback(&function_31a6b711);
}

/*
	Name: pod_update
	Namespace: zm_genesis_apothican
	Checksum: 0x5AF2FAC3
	Offset: 0x42F0
	Size: 0x413
	Parameters: 0
	Flags: None
*/
function pod_update()
{
	mdl_ovary = GetEnt(self.script_string, "targetname");
	self.mdl_ovary = mdl_ovary;
	mdl_ovary thread scene::init("p7_fxanim_zm_gen_gateworm_ovary_egg_deposit_bundle", mdl_ovary);
	var_5e99fdc8 = "lgt_apoth_int_" + self.script_string;
	a_str_loc = StrTok(self.script_string, "_");
	var_b2f4a489 = "lgt_apoth_int_eggworm_" + a_str_loc[1];
	s_unitrigger = self zm_unitrigger::create_unitrigger(&"ZM_GENESIS_PICKUP_EGG", 64, &function_5bd5869a);
	self waittill("trigger_activated", e_player);
	level thread function_88893a6c(var_b2f4a489);
	v_pos = self.mdl_ovary GetTagOrigin("tag_origin");
	mdl_pod = util::spawn_model("p7_fxanim_zm_gen_gateworm_egg_mod", v_pos, mdl_ovary.angles);
	self.mdl_pod = mdl_pod;
	self.var_22ee51d7 = e_player;
	e_player take_egg();
	zm_unitrigger::unregister_unitrigger(s_unitrigger);
	mdl_ovary thread scene::Play("p7_fxanim_zm_gen_gateworm_ovary_egg_deposit_bundle", mdl_ovary);
	mdl_pod scene::Play("p7_fxanim_zm_gen_gateworm_egg_deposit_bundle", mdl_pod);
	exploder::exploder(var_5e99fdc8);
	mdl_pod.var_b99b1b98 = 10;
	mdl_pod waittill("hash_71f0e810");
	mdl_pod playsound("zmb_main_omelettes_ovary_worm_hatch");
	mdl_pod scene::stop("p7_fxanim_zm_gen_gateworm_egg_deposit_bundle");
	mdl_pod delete();
	v_pos = mdl_ovary GetTagOrigin("ovary_gateworm_tag");
	mdl_gateworm = util::spawn_model("p7_zm_dlc4_gateworm", v_pos, mdl_ovary.angles);
	level thread function_88893a6c(var_b2f4a489);
	level thread function_5c65688b(mdl_gateworm);
	mdl_gateworm clientfield::set("gateworm_mtl", 1);
	mdl_gateworm thread scene::Play("zm_dlc4_gateworm_idle_basin", mdl_gateworm);
	mdl_gateworm LinkTo(mdl_ovary, "ovary_gateworm_tag");
	self thread util::delay(6, undefined, &function_7fd5874f, mdl_gateworm);
	mdl_ovary scene::Play("p7_fxanim_zm_gen_gateworm_ovary_worm_birth_bundle", mdl_ovary);
	mdl_ovary thread scene::Play("p7_fxanim_zm_gen_gateworm_ovary_worm_birth_idle_bundle", mdl_ovary);
}

/*
	Name: function_88893a6c
	Namespace: zm_genesis_apothican
	Checksum: 0x2F6498EF
	Offset: 0x4710
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_88893a6c(var_b2f4a489)
{
	exploder::exploder(var_b2f4a489);
	wait(5);
	exploder::exploder_stop(var_b2f4a489);
}

/*
	Name: function_5c65688b
	Namespace: zm_genesis_apothican
	Checksum: 0x89D95491
	Offset: 0x4760
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_5c65688b(mdl_gateworm)
{
	wait(1);
	mdl_gateworm PlayLoopSound("zmb_main_omelettes_worm_lp", 2);
}

/*
	Name: function_7fd5874f
	Namespace: zm_genesis_apothican
	Checksum: 0xBCC8E59F
	Offset: 0x47A0
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function function_7fd5874f(mdl_gateworm)
{
	s_unitrigger = self zm_unitrigger::create_unitrigger("", 64, &function_4661867f);
	self waittill("trigger_activated", e_player);
	self.var_56390601 = mdl_gateworm.origin;
	self.var_5a5b5ecf = mdl_gateworm.angles;
	e_player function_42781615(self);
	e_player playsound("zmb_main_omelettes_worm_pickup");
	zm_unitrigger::unregister_unitrigger(s_unitrigger);
	mdl_gateworm Unlink();
	mdl_gateworm delete();
}

/*
	Name: function_5bd5869a
	Namespace: zm_genesis_apothican
	Checksum: 0x7945A5A1
	Offset: 0x48C0
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function function_5bd5869a(e_player)
{
	if(e_player flag::get("holding_egg"))
	{
		self setHintString("");
		return 1;
	}
	self setHintString("");
	return 0;
}

/*
	Name: function_4661867f
	Namespace: zm_genesis_apothican
	Checksum: 0xD694707C
	Offset: 0x4938
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function function_4661867f(e_player)
{
	if(e_player flag::get("holding_gateworm") || e_player flag::get("holding_egg") || (isdefined(self.stub.related_parent.var_22ee51d7) && self.stub.related_parent.var_22ee51d7 !== e_player))
	{
		self setHintString("");
		return 0;
	}
	self setHintString("");
	return 1;
}

/*
	Name: give_egg
	Namespace: zm_genesis_apothican
	Checksum: 0x8AFB0DDE
	Offset: 0x4A10
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function give_egg(s_egg)
{
	self thread function_b67eab19("player_apothicon_egg", "zmInventory.widget_apothicon_egg", 1);
	self clientfield::set_player_uimodel("zmInventory.player_apothicon_egg_bg", 1);
	self clientfield::set_player_uimodel("zmInventory.player_gate_worm_bg", 0);
	self flag::set("holding_egg");
	self thread function_9b3d1bca(s_egg);
}

/*
	Name: function_9b3d1bca
	Namespace: zm_genesis_apothican
	Checksum: 0x53C1D52B
	Offset: 0x4AC8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_9b3d1bca(s_egg)
{
	self endon("holding_egg");
	self waittill("disconnect");
	s_egg thread function_79912fdc();
}

/*
	Name: take_egg
	Namespace: zm_genesis_apothican
	Checksum: 0x3B23CE25
	Offset: 0x4B10
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function take_egg()
{
	self clientfield::set_to_player("player_apothicon_egg", 0);
	self clientfield::set_player_uimodel("zmInventory.player_apothicon_egg_bg", 0);
	self clientfield::set_player_uimodel("zmInventory.player_gate_worm_bg", 1);
	self flag::clear("holding_egg");
}

/*
	Name: function_42781615
	Namespace: zm_genesis_apothican
	Checksum: 0xFBE8DD2A
	Offset: 0x4BA0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_42781615(s_pod)
{
	self thread function_b67eab19("player_gate_worm", "zmInventory.widget_gate_worm", 1);
	self clientfield::set_player_uimodel("zmInventory.player_apothicon_egg_bg", 0);
	self clientfield::set_player_uimodel("zmInventory.player_gate_worm_bg", 1);
	self flag::set("holding_gateworm");
	s_pod thread function_ed0fe018(self);
	self zm_genesis_vo::function_78d4f20e();
}

/*
	Name: function_ed0fe018
	Namespace: zm_genesis_apothican
	Checksum: 0xD0D6532C
	Offset: 0x4C70
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_ed0fe018(e_player)
{
	e_player endon("holding_gateworm");
	e_player waittill("disconnect");
	mdl_gateworm = util::spawn_model("p7_zm_dlc4_gateworm", self.var_56390601, self.var_5a5b5ecf);
	self thread function_7fd5874f(mdl_gateworm);
}

/*
	Name: function_4aa2c78f
	Namespace: zm_genesis_apothican
	Checksum: 0xCDED3849
	Offset: 0x4CF0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_4aa2c78f()
{
	self clientfield::set_to_player("player_gate_worm", 0);
	self clientfield::set_player_uimodel("zmInventory.player_gate_worm_bg", 0);
	self clientfield::set_player_uimodel("zmInventory.player_apothicon_egg_bg", 1);
	self flag::clear("holding_gateworm");
}

/*
	Name: function_f5260da
	Namespace: zm_genesis_apothican
	Checksum: 0xB53EE573
	Offset: 0x4D80
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_f5260da()
{
	return self flag::get("holding_gateworm");
}

/*
	Name: function_31a6b711
	Namespace: zm_genesis_apothican
	Checksum: 0xD1A51F36
	Offset: 0x4DB0
	Size: 0x20D
	Parameters: 1
	Flags: None
*/
function function_31a6b711(e_attacker)
{
	if(self.archetype != "zombie")
	{
		return;
	}
	var_e6ca3c26 = undefined;
	n_closest_dist = 262144;
	for(i = 0; i < level.var_2a7689da.size; i++)
	{
		var_a799f50 = level.var_2a7689da[i];
		mdl_pod = var_a799f50.mdl_pod;
		if(isdefined(mdl_pod) && isdefined(mdl_pod.var_b99b1b98))
		{
			if(!isdefined(var_a799f50.var_22ee51d7) || var_a799f50.var_22ee51d7 == e_attacker)
			{
				n_dist_sq = DistanceSquared(self.origin, mdl_pod.origin);
				if(n_dist_sq < n_closest_dist)
				{
					n_closest_dist = n_dist_sq;
					var_e6ca3c26 = mdl_pod;
				}
			}
		}
	}
	if(isdefined(var_e6ca3c26))
	{
		v_pos = var_e6ca3c26 GetTagOrigin("ovary_egg_tag_jnt");
		level thread zm_genesis_power::zombie_blood_soul_streak_fx(self.origin + VectorScale((0, 0, 1), 50), self.angles, v_pos, 1);
		var_e6ca3c26.var_b99b1b98--;
		if(var_e6ca3c26.var_b99b1b98 <= 0)
		{
			var_e6ca3c26 notify("hash_71f0e810");
			var_e6ca3c26.var_b99b1b98 = undefined;
			level notify("hash_10ed65db", e_attacker);
		}
	}
}

/*
	Name: function_87d7a33f
	Namespace: zm_genesis_apothican
	Checksum: 0xEDD0F04D
	Offset: 0x4FC8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_87d7a33f()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_540f913f);
	#/
}

/*
	Name: function_540f913f
	Namespace: zm_genesis_apothican
	Checksum: 0xD89004A
	Offset: 0x5018
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_540f913f(n_val)
{
	/#
		if(n_val)
		{
			level flag::set("Dev Block strings are not supported");
			wait(1);
			level flag::clear("Dev Block strings are not supported");
		}
	#/
}

