#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_ai_napalm;
#using scripts\zm\_zm_ai_sonic;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_shrink_ray;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_temple_ai_monkey;
#using scripts\zm\zm_temple_amb;
#using scripts\zm\zm_temple_ffotd;
#using scripts\zm\zm_temple_fx;
#using scripts\zm\zm_temple_geyser;
#using scripts\zm\zm_temple_maze;
#using scripts\zm\zm_temple_sq;

#namespace namespace_3dfeef6;

/*
	Name: level_overrides
	Namespace: namespace_3dfeef6
	Checksum: 0x29D47E65
	Offset: 0xC98
	Size: 0x1B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec level_overrides()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: namespace_3dfeef6
	Checksum: 0x494B97B9
	Offset: 0xCC0
	Size: 0x313
	Parameters: 0
	Flags: None
*/
function main()
{
	zm_temple_ffotd::main_start();
	SetDvar("player_sliding_velocity_cap", 50);
	SetDvar("player_sliding_wishspeed", 600);
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	thread zm_temple_fx::main();
	level._uses_sticky_grenades = 1;
	level._temple_vision_set = "zombie_temple";
	level._temple_vision_set_priority = 1;
	level._temple_caves_vision_set = "zombie_temple_caves";
	level._temple_caves_vision_set_priority = 2;
	level._temple_water_vision_set = "zombie_temple";
	level._temple_eclipse_vision_set = "zombie_temple_eclipse";
	level._temple_eclipse_vision_set_priority = 3;
	level._temple_caves_eclipse_vision_set = "zombie_temple_eclipseCave";
	level._temple_caves_eclipse_vision_set_priority = 3;
	level.riser_fx_on_client = 1;
	level.use_new_riser_water = 1;
	level.use_clientside_rock_tearin_fx = 1;
	level.use_clientside_board_fx = 1;
	level.spinner_state = 0;
	include_weapons();
	init_level_specific_wall_buy_fx();
	visionset_mgr::register_overlay_info_style_blur("zm_ai_screecher_blur", 21000, 15, 0.1, 0.25, 20);
	level thread zm_temple_amb::main();
	register_field_handlers();
	zm_temple_sq::init_clientfields();
	zm_temple_geyser::main();
	load::main();
	_zm_weap_cymbal_monkey::init();
	level thread power_watch();
	callback::on_localclient_connect(&temple_player_connect);
	callback::on_localplayer_spawned(&temple_player_spawned);
	level thread temple_light_model_swap_init();
	level thread sq_std_watcher();
	level._in_eclipse = 0;
	level thread crystal_sauce_monitor();
	util::waitforclient(0);
	level thread init_fog_vol_to_visionset();
	/#
		println("Dev Block strings are not supported");
	#/
	zm_temple_ffotd::main_end();
}

/*
	Name: init_fog_vol_to_visionset
	Namespace: namespace_3dfeef6
	Checksum: 0xABA209C
	Offset: 0xFE0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function init_fog_vol_to_visionset()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zombie_temple", 2);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_temple");
	visionset_mgr::fog_vol_to_visionset_set_info(1, "zombie_temple_caves");
}

/*
	Name: register_field_handlers
	Namespace: namespace_3dfeef6
	Checksum: 0xF327756B
	Offset: 0x1068
	Size: 0x4E3
	Parameters: 0
	Flags: None
*/
function register_field_handlers()
{
	clientfield::register("actor", "ragimpactgib", 21000, 1, "int", &ragdoll_impact_watch_start, 0, 0);
	clientfield::register("scriptmover", "spiketrap", 21000, 1, "int", &spike_trap_move, 0, 0);
	clientfield::register("scriptmover", "mazewall", 21000, 1, "int", &maze_wall_move, 0, 0);
	clientfield::register("scriptmover", "weaksauce", 21000, 1, "int", &crystal_weaksauce_start, 0, 0);
	clientfield::register("scriptmover", "hotsauce", 21000, 1, "int", &crystal_hotsauce_start, 0, 0);
	clientfield::register("scriptmover", "sauceend", 21000, 1, "int", &crystal_sauce_end, 0, 0);
	clientfield::register("scriptmover", "watertrail", 21000, 1, "int", &water_trail_monitor, 0, 0);
	clientfield::register("toplayer", "floorrumble", 21000, 1, "int", &maze_floor_controller_rumble, 0, 0);
	clientfield::register("toplayer", "minecart_rumble", 21000, 1, "int", &function_425904c0, 0, 0);
	clientfield::register("world", "papspinners", 21000, 4, "int", &temple_pap_spinners_flag, 0, 0);
	clientfield::register("world", "water_wheel_right", 21000, 1, "int", &water_wheel_right, 0, 0);
	clientfield::register("world", "water_wheel_left", 21000, 1, "int", &water_wheel_left, 0, 0);
	clientfield::register("world", "waterfall_trap", 21000, 1, "int", &waterfall_watcher, 0, 0);
	clientfield::register("world", "time_transition", 21000, 1, "int", &timetravel_watcher, 0, 1);
	clientfield::register("allplayers", "player_legs_hide", 21000, 1, "int", &player_legs_hide, 0, 0);
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int", &zm::zombie_eyes_clientfield_cb, 0, 0);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_waterfall_postfx", 21000, 32, "pstfx_waterfall_soft", 3);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_temple_eclipse", 21000, 1, "pstfx_temple_eclipse_in", 3);
}

/*
	Name: spike_trap_move
	Namespace: namespace_3dfeef6
	Checksum: 0xFE83413A
	Offset: 0x1558
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function spike_trap_move(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	spike_trap_move_spikes(localClientNum, newVal);
}

/*
	Name: maze_wall_move
	Namespace: namespace_3dfeef6
	Checksum: 0x3CCB0870
	Offset: 0x15B8
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function maze_wall_move(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	zm_temple_maze::maze_trap_move_wall(localClientNum, newVal);
}

/*
	Name: delete_water_trail
	Namespace: namespace_3dfeef6
	Checksum: 0xCECB248
	Offset: 0x1618
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function delete_water_trail()
{
	wait(1.2);
	for(i = 0; i < self.fx_ents.size; i++)
	{
		self.fx_ents[i] delete();
	}
	self.fx_ents = undefined;
}

/*
	Name: water_trail_monitor
	Namespace: namespace_3dfeef6
	Checksum: 0xAF4A88D9
	Offset: 0x1680
	Size: 0x18B
	Parameters: 7
	Flags: None
*/
function water_trail_monitor(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(newVal)
	{
		players = GetLocalPlayers();
		self.fx_ents = [];
		for(i = 0; i < players.size; i++)
		{
			self.fx_ents[i] = spawn(i, (0, 0, 0), "script_model");
			self.fx_ents[i] SetModel("tag_origin");
			self.fx_ents[i] LinkTo(self, "tag_origin");
			PlayFXOnTag(i, level._effect["fx_crystal_water_trail"], self.fx_ents[i], "tag_origin");
		}
	}
	else if(isdefined(self.fx_ents))
	{
		self thread delete_water_trail();
	}
}

/*
	Name: crystal_weaksauce_start
	Namespace: namespace_3dfeef6
	Checksum: 0x91475AB1
	Offset: 0x1818
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function crystal_weaksauce_start(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(!newVal)
	{
		return;
	}
	s = spawnstruct();
	s.FX = "fx_weak_sauce_trail";
	s.origin = self.origin + VectorScale((0, 0, 1), 134);
	level._crystal_sauce_start = s;
}

/*
	Name: crystal_hotsauce_start
	Namespace: namespace_3dfeef6
	Checksum: 0x47BDCB72
	Offset: 0x18D8
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function crystal_hotsauce_start(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(!newVal)
	{
		return;
	}
	s = spawnstruct();
	s.FX = "fx_hot_sauce_trail";
	s.origin = self.origin + VectorScale((0, 0, 1), 134);
	level._crystal_sauce_start = s;
}

/*
	Name: crystal_sauce_end
	Namespace: namespace_3dfeef6
	Checksum: 0x45E97701
	Offset: 0x1998
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function crystal_sauce_end(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(!newVal)
	{
		return;
	}
	level._crystal_sauce_end = self.origin;
	if(self.model == "p7_zm_sha_crystal_holder_full")
	{
		level._crystal_sauce_end = level._crystal_sauce_end + VectorScale((0, 0, 1), 134);
	}
}

/*
	Name: crystal_trail_runner
	Namespace: namespace_3dfeef6
	Checksum: 0x2FBB12BA
	Offset: 0x1A38
	Size: 0xF3
	Parameters: 3
	Flags: None
*/
function crystal_trail_runner(localClientNum, fx_name, dest)
{
	/#
		println("Dev Block strings are not supported" + fx_name + "Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported" + dest);
	#/
	PlayFXOnTag(localClientNum, level._effect[fx_name], self, "tag_origin");
	self PlayLoopSound("evt_sq_bag_crystal_bounce_loop", 0.05);
	self moveto(dest, 0.5);
	self waittill("movedone");
	self delete();
}

/*
	Name: crystal_sauce_monitor
	Namespace: namespace_3dfeef6
	Checksum: 0xC708704
	Offset: 0x1B38
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function crystal_sauce_monitor()
{
	num_players = GetLocalPlayers().size;
	while(1)
	{
		wait(0.016);
		if(!isdefined(level._crystal_sauce_start) || !isdefined(level._crystal_sauce_end))
		{
			continue;
		}
		for(i = 0; i < num_players; i++)
		{
			e = spawn(i, level._crystal_sauce_start.origin, "script_model");
			e SetModel("tag_origin");
			e thread crystal_trail_runner(i, level._crystal_sauce_start.FX, level._crystal_sauce_end);
		}
		level._crystal_sauce_start = undefined;
		level._crystal_sauce_end = undefined;
	}
}

/*
	Name: power_watch
	Namespace: namespace_3dfeef6
	Checksum: 0xC21DB335
	Offset: 0x1C60
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function power_watch()
{
	level.power = 0;
	level waittill("ZPO");
	level.power = 1;
	level thread start_generator_movement();
}

/*
	Name: timetravel_watcher
	Namespace: namespace_3dfeef6
	Checksum: 0xF1CC01F4
	Offset: 0x1CA8
	Size: 0x2D3
	Parameters: 7
	Flags: None
*/
function timetravel_watcher(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		level notify("dB");
		level thread zm_temple_amb::waitfor_return(bNewEnt, bInitialSnap, bWasDemoJump);
		was_in_eclipse = isdefined(level._in_eclipse) && level._in_eclipse;
		level._in_eclipse = 0;
		visionset_mgr::fog_vol_to_visionset_set_suffix("");
		level notify("time_travel", level._in_eclipse);
		exploder::exploder("fxexp_401");
		if(was_in_eclipse)
		{
			exploder::kill_exploder("fxexp_402");
		}
		exploder::kill_exploder("eclipse");
		if(bNewEnt || bInitialSnap || bWasDemoJump)
		{
			SetDvar("r_skyTransition", 0);
		}
		else
		{
			level thread function_bf1b3728(0, 2);
		}
		SetLitFogBank(localClientNum, -1, 0, 0);
		SetWorldFogActiveBank(localClientNum, 1);
	}
	else
	{
		level thread zm_temple_amb::waitfor_ec();
		level._in_eclipse = 1;
		level notify("time_travel", level._in_eclipse);
		visionset_mgr::fog_vol_to_visionset_set_suffix("_eclipse");
		exploder::exploder("eclipse");
		exploder::exploder("fxexp_402");
		exploder::kill_exploder("fxexp_401");
		level thread function_bf1b3728(1, 2.5);
		SetLitFogBank(localClientNum, -1, 1, 1);
		SetWorldFogActiveBank(localClientNum, 2);
	}
	if(!isdefined(level._sidequest_firsttime))
	{
		level._sidequest_firsttime = 0;
		return;
	}
	level thread function_7b0ba395(localClientNum);
}

/*
	Name: function_bf1b3728
	Namespace: namespace_3dfeef6
	Checksum: 0xA71C0B30
	Offset: 0x1F88
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function function_bf1b3728(n_val, n_time)
{
	level notify("hash_47d048e6");
	level endon("hash_47d048e6");
	if(!isdefined(level.var_3766c3d3))
	{
		level.var_3766c3d3 = 0;
	}
	if(level.var_3766c3d3 == n_val)
	{
		return;
	}
	if(n_val > level.var_3766c3d3)
	{
		var_83a6ec14 = n_val - level.var_3766c3d3;
	}
	else
	{
		var_83a6ec14 = level.var_3766c3d3 - n_val * -1;
		wait(0.5);
	}
	n_change = var_83a6ec14 / n_time / 0.1;
	while(level.var_3766c3d3 != n_val)
	{
		level.var_3766c3d3 = level.var_3766c3d3 + n_change;
		SetDvar("r_skyTransition", level.var_3766c3d3);
		wait(0.1);
	}
	SetDvar("r_skyTransition", n_val);
}

/*
	Name: function_7b0ba395
	Namespace: namespace_3dfeef6
	Checksum: 0xCC539365
	Offset: 0x20D8
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function function_7b0ba395(localClientNum)
{
	level endon("end_rumble");
	level endon("end_game");
	player = GetLocalPlayers()[localClientNum];
	var_efeac590 = 0;
	n_end_time = 2;
	player PlayRumbleLoopOnEntity(localClientNum, "tank_rumble");
	while(isdefined(player) && var_efeac590 < n_end_time)
	{
		player Earthquake(0.3, 0.1, player.origin, 100);
		var_efeac590 = var_efeac590 + 0.1;
		wait(0.1);
	}
	if(isdefined(player))
	{
		player StopRumble(localClientNum, "tank_rumble");
	}
}

/*
	Name: start_generator_movement
	Namespace: namespace_3dfeef6
	Checksum: 0x6BEB53E8
	Offset: 0x2210
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function start_generator_movement()
{
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		ent = GetEnt(i, "power_generator", "targetname");
		ent thread generator_move();
	}
}

/*
	Name: generator_move
	Namespace: namespace_3dfeef6
	Checksum: 0xD5041863
	Offset: 0x22A8
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function generator_move()
{
	offsetAngle = 0.25;
	rottime = 0.1;
	Total = 0;
	self RotateRoll(0 - offsetAngle, rottime);
	while(1)
	{
		self waittill("rotatedone");
		self RotateRoll(offsetAngle * 2, rottime);
		self waittill("rotatedone");
		self RotateRoll(0 - offsetAngle * 2, rottime);
	}
}

/*
	Name: player_legs_hide
	Namespace: namespace_3dfeef6
	Checksum: 0x67D9A957
	Offset: 0x2378
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function player_legs_hide(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self hideviewlegs();
	}
	else
	{
		self showviewlegs();
	}
}

/*
	Name: water_wheel_right
	Namespace: namespace_3dfeef6
	Checksum: 0x68376B85
	Offset: 0x23F8
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function water_wheel_right(clientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		wheel = GetEnt(i, "water_wheel_right", "targetname");
		wheel thread rotateWheel(120, 2.2);
	}
}

/*
	Name: water_wheel_left
	Namespace: namespace_3dfeef6
	Checksum: 0x32C227C6
	Offset: 0x24D8
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function water_wheel_left(clientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		wheel = GetEnt(i, "water_wheel_left", "targetname");
		wheel thread rotateWheel(120, 1.8);
	}
}

/*
	Name: rotateWheel
	Namespace: namespace_3dfeef6
	Checksum: 0xAC8F2DF7
	Offset: 0x25B8
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function rotateWheel(rotate, time)
{
	spinUpTime = time - 0.5;
	self RotatePitch(rotate, time, spinUpTime, 0.1);
	self waittill("rotatedone");
	while(1)
	{
		self RotatePitch(rotate, time, 0, 0);
		self waittill("rotatedone");
	}
}

/*
	Name: disable_deadshot
	Namespace: namespace_3dfeef6
	Checksum: 0x3E3F6D46
	Offset: 0x2660
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function disable_deadshot(i_local_client_num)
{
	while(!self hasdobj(i_local_client_num))
	{
		wait(0.05);
	}
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(self == players[i])
		{
			self ClearAlternateAimParams();
		}
	}
}

/*
	Name: water_gush_debug
	Namespace: namespace_3dfeef6
	Checksum: 0xFF476DA2
	Offset: 0x2708
	Size: 0xE5
	Parameters: 0
	Flags: None
*/
function water_gush_debug()
{
	/#
		scale = 0.1;
		offset = (0, 0, 0);
		dir = AnglesToForward(self.angles);
		for(i = 0; i < 5; i++)
		{
			print3d(self.origin + offset, "Dev Block strings are not supported", (60, 60, 255), 1, scale, 10);
			scale = scale * 1.7;
			offset = offset + dir * 6;
		}
	#/
}

/*
	Name: waterfall_watcher
	Namespace: namespace_3dfeef6
	Checksum: 0x7E796D47
	Offset: 0x27F8
	Size: 0xF5
	Parameters: 7
	Flags: None
*/
function waterfall_watcher(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	targets = struct::get_array("sq_sad", "targetname");
	for(i = 0; i < targets.size; i++)
	{
		if(!isdefined(level._sq_std_status) || !isdefined(level._sq_std_status[i]))
		{
			continue;
		}
		if(level._sq_std_status[i] == 0)
		{
			exploder::exploder("fxexp_12" + i);
		}
		wait(0.25);
	}
}

/*
	Name: sq_std_watcher
	Namespace: namespace_3dfeef6
	Checksum: 0x58E4E5D9
	Offset: 0x28F8
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function sq_std_watcher()
{
	/#
		println("Dev Block strings are not supported");
	#/
	/#
		println("Dev Block strings are not supported");
	#/
	level waittill("SR");
	players = GetLocalPlayers();
	/#
		println("Dev Block strings are not supported");
	#/
	targets = struct::get_array("sq_sad", "targetname");
	/#
		println("Dev Block strings are not supported" + targets.size + "Dev Block strings are not supported");
	#/
	for(i = 0; i < targets.size; i++)
	{
		targets[i] thread sq_std_struct_watcher(players.size);
	}
}

/*
	Name: sq_std_watch_for_restart
	Namespace: namespace_3dfeef6
	Checksum: 0xC1F5770E
	Offset: 0x2A38
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function sq_std_watch_for_restart(num_local_players)
{
	level waittill("SR");
	if(isdefined(level._sq_std_array[self.script_int - 1]))
	{
		for(i = 0; i < level._sq_std_array[self.script_int - 1].size; i++)
		{
			if(isdefined(level._sq_std_array[self.script_int - 1][i]))
			{
				level._sq_std_array[self.script_int - 1][i] delete();
			}
		}
		level._sq_std_array[self.script_int - 1] = undefined;
	}
	level._sq_std_status[self.script_int - 1] = 0;
	self thread sq_std_struct_watcher(num_local_players);
}

/*
	Name: sq_struct_debug
	Namespace: namespace_3dfeef6
	Checksum: 0x976AFF67
	Offset: 0x2B48
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function sq_struct_debug()
{
	/#
		level endon("SR");
		level endon("ksd");
		while(1)
		{
			print3d(self.origin, "Dev Block strings are not supported", VectorScale((1, 0, 0), 255), 1);
			wait(0.1);
		}
	#/
}

/*
	Name: sq_std_struct_watcher
	Namespace: namespace_3dfeef6
	Checksum: 0x71E2AD69
	Offset: 0x2BB0
	Size: 0x1ED
	Parameters: 1
	Flags: None
*/
function sq_std_struct_watcher(num_local_players)
{
	if(!isdefined(level._sq_std_array))
	{
		level._sq_std_array = [];
		level._sq_std_status = [];
		for(i = 0; i < 4; i++)
		{
			level._sq_std_status[i] = 0;
		}
	}
	level endon("SR");
	self thread sq_std_watch_for_restart(num_local_players);
	while(1)
	{
		level waittill("S" + self.script_int);
		/#
			println("Dev Block strings are not supported" + self.script_int);
		#/
		self thread sq_struct_debug();
		level._sq_std_status[self.script_int - 1] = 1;
		level._sq_std_array[self.script_int - 1] = [];
		for(i = 0; i < num_local_players; i++)
		{
			e = spawn(i, self.origin, "script_model");
			e.angles = self.angles + VectorScale((1, 0, 0), 270);
			e SetModel("wpn_t7_spider_mine_world");
			level._sq_std_array[self.script_int - 1][level._sq_std_array[self.script_int - 1].size] = e;
		}
	}
}

/*
	Name: temple_player_spawned
	Namespace: namespace_3dfeef6
	Checksum: 0x84259E10
	Offset: 0x2DA8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function temple_player_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	if(isdefined(self.var_1687ae46))
	{
		return;
	}
	self.var_1687ae46 = 1;
	if(localClientNum != 0)
	{
		return;
	}
	self thread disable_deadshot(localClientNum);
}

/*
	Name: temple_player_connect
	Namespace: namespace_3dfeef6
	Checksum: 0x4A6C83B4
	Offset: 0x2E20
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function temple_player_connect(i_local_client_num)
{
	SetSavedDvar("phys_buoyancy", 1);
	level thread _init_pap_indicators();
	thread floating_boards_init();
}

/*
	Name: init_level_specific_wall_buy_fx
	Namespace: namespace_3dfeef6
	Checksum: 0x9A8E1205
	Offset: 0x2E80
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function init_level_specific_wall_buy_fx()
{
	level._effect["sticky_grenade_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_pistol";
	level._effect["frag_grenade_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_pistol";
	level._effect["pdw57_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["870mcs_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["ak74u_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["beretta93r_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_pistol";
	level._effect["bowie_knife_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["claymore_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["m14_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["m16_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["mp5k_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["rottweil72_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
}

/*
	Name: include_weapons
	Namespace: namespace_3dfeef6
	Checksum: 0xF0CF972D
	Offset: 0x2FE0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_temple_weapons.csv", 1);
}

/*
	Name: _init_magic_box
	Namespace: namespace_3dfeef6
	Checksum: 0x9378F69E
	Offset: 0x3010
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function _init_magic_box()
{
	level._custom_box_monitor = &temple_box_monitor;
	level._box_locations = Array("waterfall_upper_chest", "blender_chest", "pressure_chest", "bridge_chest", "caves_water_chest", "power_chest", "caves1_chest", "caves2_chest", "caves3_chest");
	callback::on_localclient_connect(&_init_indicators);
	level.cachedInfo = [];
	level.initialized = [];
}

/*
	Name: _init_indicators
	Namespace: namespace_3dfeef6
	Checksum: 0xCAA523BD
	Offset: 0x30D0
	Size: 0x15D
	Parameters: 1
	Flags: None
*/
function _init_indicators(clientNum)
{
	structs = struct::get_array("magic_box_indicator", "targetname");
	for(i = 0; i < structs.size; i++)
	{
		s = structs[i];
		if(!isdefined(s.viewmodels))
		{
			s.viewmodels = [];
		}
		s.viewmodels[clientNum] = undefined;
	}
	level.initialized[clientNum] = 1;
	keys = getArrayKeys(level.cachedInfo);
	for(i = 0; i < keys.size; i++)
	{
		key = keys[i];
		State = level.cachedInfo[key];
		temple_box_monitor(i, State, "");
	}
}

/*
	Name: temple_box_monitor
	Namespace: namespace_3dfeef6
	Checksum: 0xD035772C
	Offset: 0x3238
	Size: 0xD5
	Parameters: 3
	Flags: None
*/
function temple_box_monitor(clientNum, State, oldState)
{
	if(!isdefined(level.initialized[clientNum]))
	{
		level.cachedInfo[clientNum] = State;
		return;
	}
	switch(State)
	{
		case "fire_sale":
		{
			_all_locations(clientNum);
			break;
		}
		case "moving":
		{
			level thread _random_location(clientNum);
			break;
		}
		case default:
		{
			level notify("location_set" + clientNum);
			_setup_location(clientNum, State);
			break;
		}
	}
}

/*
	Name: _delete_location
	Namespace: namespace_3dfeef6
	Checksum: 0x18D4DB40
	Offset: 0x3318
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function _delete_location(clientNum, location)
{
	structs = struct::get_array(location, "script_noteworthy");
	Array::thread_all(structs, &_setup_view_model, clientNum, undefined);
}

/*
	Name: _delete_all_locations
	Namespace: namespace_3dfeef6
	Checksum: 0x823894BF
	Offset: 0x3388
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function _delete_all_locations(clientNum)
{
	for(i = 0; i < level._box_locations.size; i++)
	{
		location = level._box_locations[i];
		_delete_location(clientNum, location);
	}
}

/*
	Name: _show_location
	Namespace: namespace_3dfeef6
	Checksum: 0xC9175078
	Offset: 0x3400
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function _show_location(clientNum, location)
{
	structs = struct::get_array(location, "script_noteworthy");
	Array::thread_all(structs, &_setup_view_model, clientNum, "zt_map_knife");
}

/*
	Name: _setup_location
	Namespace: namespace_3dfeef6
	Checksum: 0x1BE4A054
	Offset: 0x3478
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function _setup_location(clientNum, location)
{
	_delete_all_locations(clientNum);
	_show_location(clientNum, location);
}

/*
	Name: _setup_view_model
	Namespace: namespace_3dfeef6
	Checksum: 0x9A13C482
	Offset: 0x34C8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function _setup_view_model(clientNum, viewmodel)
{
	if(isdefined(self.viewmodels[clientNum]))
	{
		self.viewmodels[clientNum] delete();
		self.viewmodels[clientNum] = undefined;
	}
	if(isdefined(viewmodel))
	{
		self.viewmodels[clientNum] = spawn(clientNum, self.origin, "script_model");
		self.viewmodels[clientNum].angles = self.angles;
		self.viewmodels[clientNum] SetModel(viewmodel);
	}
}

/*
	Name: _random_location
	Namespace: namespace_3dfeef6
	Checksum: 0x40261E40
	Offset: 0x35A8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function _random_location(clientNum)
{
	level endon("location_set" + clientNum);
	index = 0;
	while(1)
	{
		location = level._box_locations[index];
		_setup_location(clientNum, location);
		index++;
		if(index >= level._box_locations.size)
		{
			index = 0;
		}
		wait(0.25);
	}
}

/*
	Name: _all_locations
	Namespace: namespace_3dfeef6
	Checksum: 0x64276A61
	Offset: 0x3650
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function _all_locations(clientNum)
{
	for(i = 0; i < level._box_locations.size; i++)
	{
		location = level._box_locations[i];
		_show_location(clientNum, location);
	}
}

/*
	Name: _init_pap_indicators
	Namespace: namespace_3dfeef6
	Checksum: 0x3773A9BD
	Offset: 0x36C8
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function _init_pap_indicators()
{
	local_players = GetLocalPlayers();
	for(index = 0; index < local_players.size; index++)
	{
		VAL = clientfield::get("papspinners");
		level _set_num_visible_spinners(index, level.spinner_state);
	}
}

/*
	Name: temple_pap_spinners_flag
	Namespace: namespace_3dfeef6
	Checksum: 0xE40B666B
	Offset: 0x3768
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function temple_pap_spinners_flag(clientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.spinner_state = newVal;
	GetLocalPlayers()[clientNum] _set_num_visible_spinners(clientNum, level.spinner_state);
}

/*
	Name: power
	Namespace: namespace_3dfeef6
	Checksum: 0x42774A11
	Offset: 0x37F0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function power(base, exp)
{
	/#
		Assert(exp >= 0);
	#/
	if(exp == 0)
	{
		return 1;
	}
	return base * power(base, exp - 1);
}

/*
	Name: _set_num_visible_spinners
	Namespace: namespace_3dfeef6
	Checksum: 0x6A849CA1
	Offset: 0x3868
	Size: 0x2B5
	Parameters: 2
	Flags: None
*/
function _set_num_visible_spinners(clientNum, num)
{
	/#
		println("Dev Block strings are not supported" + clientNum + "Dev Block strings are not supported" + num);
	#/
	if(!isdefined(level.spinners))
	{
		level _init_pap_spinners(clientNum);
	}
	else if(!isdefined(level.spinners[clientNum]))
	{
		level _init_pap_spinners(clientNum);
	}
	for(i = 3; i >= 0; i--)
	{
		/#
			println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + clientNum);
		#/
		/#
			Assert(isdefined(level.spinners));
		#/
		/#
			Assert(isdefined(level.spinners[clientNum]));
		#/
		/#
			Assert(isdefined(level.spinners[clientNum][i]));
		#/
		pow = power(2, i);
		if(num >= pow)
		{
			num = num - pow;
			/#
				println("Dev Block strings are not supported" + clientNum + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + level.spinners[clientNum][i].size);
			#/
			Array::thread_all(level.spinners[clientNum][i], &spin_to_start);
			continue;
		}
		/#
			println("Dev Block strings are not supported" + clientNum + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + level.spinners[clientNum][i].size);
		#/
		Array::thread_all(level.spinners[clientNum][i], &spin_forever);
	}
}

/*
	Name: spike_trap_move_spikes
	Namespace: namespace_3dfeef6
	Checksum: 0xA0F8291F
	Offset: 0x3B28
	Size: 0xE5
	Parameters: 2
	Flags: None
*/
function spike_trap_move_spikes(localClientNum, active)
{
	if(!isdefined(self.spears))
	{
		self set_trap_spears(localClientNum);
	}
	spears = self.spears;
	if(isdefined(spears))
	{
		for(i = 0; i < spears.size; i++)
		{
			playsound = i == 0;
			spears[i] thread spear_init(localClientNum);
			spears[i] thread spear_move(localClientNum, active, playsound);
		}
	}
}

/*
	Name: set_trap_spears
	Namespace: namespace_3dfeef6
	Checksum: 0x4953E3BE
	Offset: 0x3C18
	Size: 0x14F
	Parameters: 1
	Flags: None
*/
function set_trap_spears(localClientNum)
{
	allSpears = GetEntArray(localClientNum, "spear_trap_spear", "targetname");
	self.spears = [];
	for(i = 0; i < allSpears.size; i++)
	{
		SPEAR = allSpears[i];
		if(isdefined(SPEAR.assigned) && SPEAR.assigned)
		{
			continue;
		}
		delta = Abs(self.origin[0] - SPEAR.origin[0]);
		if(Abs(self.origin[0] - SPEAR.origin[0]) < 21)
		{
			SPEAR.assigned = 1;
			self.spears[self.spears.size] = SPEAR;
		}
	}
}

/*
	Name: spear_init
	Namespace: namespace_3dfeef6
	Checksum: 0xEA4E7C42
	Offset: 0x3D70
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function spear_init(localClientNum)
{
	if(!isdefined(self.init) || !self.init)
	{
		self.moveDistMin = 90;
		self.moveDistMax = 120;
		self.start = self.origin;
		self.moveDir = -1 * AnglesToRight(self.angles);
		self.init = 1;
	}
}

/*
	Name: spear_move
	Namespace: namespace_3dfeef6
	Checksum: 0x6B491DA0
	Offset: 0x3DF8
	Size: 0x1BB
	Parameters: 3
	Flags: None
*/
function spear_move(localClientNum, active, playsound)
{
	if(active)
	{
		if(playsound)
		{
			sound::play_in_space(0, "evt_spiketrap_warn", self.origin);
		}
		moveDist = RandomFloatRange(self.moveDistMin, self.moveDistMax);
		endPos = self.start + self.moveDir * moveDist;
		playFX(localClientNum, level._effect["punji_dust"], endPos);
		playsound(0, "evt_spiketrap", self.origin);
		moveTime = RandomFloatRange(0.08, 0.22);
		self moveto(endPos, moveTime);
	}
	else if(playsound)
	{
		playsound(0, "evt_spiketrap_retract", self.origin);
	}
	moveTime = RandomFloatRange(0.1, 0.2);
	self moveto(self.start, moveTime);
}

/*
	Name: floating_boards_init
	Namespace: namespace_3dfeef6
	Checksum: 0xF709C5B6
	Offset: 0x3FC0
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function floating_boards_init()
{
	boards = [];
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		boards = ArrayCombine(boards, GetEntArray(i, "plank_water", "targetname"), 1, 0);
	}
	Array::thread_all(boards, &float_board);
}

/*
	Name: float_board
	Namespace: namespace_3dfeef6
	Checksum: 0x8E3D1EA9
	Offset: 0x4088
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function float_board()
{
	wait(RandomFloat(1));
	self.start_origin = self.origin;
	self.start_angles = self.angles;
	self.moment_move = self.origin;
	self thread board_bob();
	self thread board_rotate();
}

/*
	Name: board_bob
	Namespace: namespace_3dfeef6
	Checksum: 0xD75907C5
	Offset: 0x4110
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function board_bob()
{
	dist = RandomFloatRange(2.5, 3);
	moveTime = RandomFloatRange(3.5, 4.5);
	minZ = self.start_origin[2] - dist;
	maxZ = self.start_origin[2] + dist;
	while(1)
	{
		toZ = minZ - self.origin[2];
		self MoveZ(toZ, moveTime);
		self waittill("movedone");
		toZ = maxZ - self.origin[2];
		self MoveZ(toZ, moveTime);
		self waittill("movedone");
	}
}

/*
	Name: board_rotate
	Namespace: namespace_3dfeef6
	Checksum: 0xAFE5CDFC
	Offset: 0x4250
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function board_rotate()
{
	while(1)
	{
		yaw = RandomFloatRange(-360, 360);
		self RotateYaw(yaw, RandomFloatRange(60, 90));
		self waittill("rotatedone");
	}
}

/*
	Name: board_move
	Namespace: namespace_3dfeef6
	Checksum: 0xAA01B0AC
	Offset: 0x42E0
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function board_move()
{
	dist = RandomFloatRange(20, 30);
	moveTime = RandomFloatRange(5, 10);
	while(1)
	{
		yaw = RandomFloatRange(0, 360);
		toVector = AnglesToForward((0, yaw, 0));
		newLoc = self.start_origin + toVector * dist;
		toX = newLoc[0] - self.origin[0];
		self MoveX(toX, moveTime);
		toY = newLoc[1] - self.origin[1];
		self MoveY(toY, moveTime);
	}
}

/*
	Name: _init_pap_spinners
	Namespace: namespace_3dfeef6
	Checksum: 0xF3F1697A
	Offset: 0x4450
	Size: 0x185
	Parameters: 1
	Flags: None
*/
function _init_pap_spinners(cNum)
{
	if(!isdefined(level.spinners))
	{
		level.spinners = [];
	}
	if(level.spinners.size <= cNum)
	{
		level.spinners[level.spinners.size] = Array([], [], [], []);
	}
	/#
		println("Dev Block strings are not supported" + cNum + "Dev Block strings are not supported");
	#/
	for(i = 0; i < level.spinners[cNum].size; i++)
	{
		spinners = GetEntArray(cNum, "pap_spinner" + i + 1, "targetname");
		/#
			println("Dev Block strings are not supported" + cNum + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + spinners.size);
		#/
		Array::thread_all(spinners, &init_spinner, i + 1);
		level.spinners[cNum][i] = spinners;
	}
}

/*
	Name: init_spinner
	Namespace: namespace_3dfeef6
	Checksum: 0x2EDEB659
	Offset: 0x45E0
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function init_spinner(listNum)
{
	self.spinner = listNum;
	self.startAngles = self.angles;
	self.spin_sound = "evt_pap_spinner0" + listNum;
	self.spin_stop_sound = "evt_pap_timer_stop";
	self.angles = (0, 90 * listNum - 1 + RandomFloatRange(10, 80), 0);
}

/*
	Name: spin_forever
	Namespace: namespace_3dfeef6
	Checksum: 0x997DE786
	Offset: 0x4670
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function spin_forever()
{
	if(!level.power)
	{
		return;
	}
	if(isdefined(self.spin_forever) && self.spin_forever)
	{
		return;
	}
	self.spin_forever = 1;
	self.spin_to_start = 0;
	self notify("stop_spinning");
	self endon("death");
	self endon("stop_spinning");
	spinTime = self spinner_get_spin_time();
	self start_spinner_sound();
	self RotateYaw(360, spinTime, 0.25);
	self waittill("rotatedone");
	while(1)
	{
		self RotateYaw(360, spinTime);
		self waittill("rotatedone");
	}
}

/*
	Name: spinner_get_spin_time
	Namespace: namespace_3dfeef6
	Checksum: 0x3FAE0767
	Offset: 0x4780
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function spinner_get_spin_time()
{
	spinTime = 1.7;
	if(self.spinner == 2)
	{
		spinTime = 1.5;
	}
	else if(self.spinner == 3)
	{
		spinTime = 1.2;
	}
	else if(self.spinner == 4)
	{
		spinTime = 0.8;
	}
	return spinTime;
}

/*
	Name: spin_to_start
	Namespace: namespace_3dfeef6
	Checksum: 0x38B2207F
	Offset: 0x4800
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function spin_to_start()
{
	if(!level.power)
	{
		return;
	}
	if(isdefined(self.spin_to_start) && self.spin_to_start)
	{
		return;
	}
	self.spin_forever = 0;
	self.spin_to_start = 1;
	self notify("stop_spinning");
	self endon("death");
	self endon("stop_spinning");
	endYaw = self.startAngles[1];
	currentYaw = self.angles[1];
	for(deltaYaw = endYaw - currentYaw; deltaYaw < 0;  = endYaw - currentYaw)
	{
	}
	spinTime = self spinner_get_spin_time();
	spinTime = spinTime * deltaYaw / 360;
	if(spinTime > 0)
	{
		self RotateYaw(deltaYaw, spinTime, 0);
		self waittill("rotatedone");
	}
	self stop_spinner_sound();
	self.angles = self.startAngles;
}

/*
	Name: start_spinner_sound
	Namespace: namespace_3dfeef6
	Checksum: 0x39EB210F
	Offset: 0x4978
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function start_spinner_sound()
{
	self.var_3539b4ec = self PlayLoopSound(self.spin_sound);
}

/*
	Name: stop_spinner_sound
	Namespace: namespace_3dfeef6
	Checksum: 0xC60F5D95
	Offset: 0x49B0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function stop_spinner_sound()
{
	if(isdefined(self.var_3539b4ec))
	{
		self StopLoopSound(self.var_3539b4ec, 0.1);
	}
	self playsound(0, self.spin_stop_sound);
}

/*
	Name: temple_light_model_swap_init
	Namespace: namespace_3dfeef6
	Checksum: 0x48CF36BD
	Offset: 0x4A10
	Size: 0x1B7
	Parameters: 0
	Flags: None
*/
function temple_light_model_swap_init()
{
	if(!level clientfield::get("zombie_power_on"))
	{
		level waittill("ZPO");
	}
	wait(4.5);
	level notify("pl1");
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		light_models = GetEntArray(i, "model_lights_on", "targetname");
		for(x = 0; x < light_models.size; x++)
		{
			light = light_models[x];
			if(isdefined(light.script_string))
			{
				light SetModel(light.script_string);
				continue;
			}
			if(light.model == "p_ztem_power_hanging_light_off")
			{
				light SetModel("p_ztem_power_hanging_light");
				continue;
			}
			if(light.model == "p_lights_cagelight02_off")
			{
				light SetModel("p_lights_cagelight02_on");
			}
		}
	}
}

/*
	Name: ragdoll_impact_watch_start
	Namespace: namespace_3dfeef6
	Checksum: 0xD7593AC4
	Offset: 0x4BD0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function ragdoll_impact_watch_start(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self thread ragdoll_impact_watch(localClientNum);
	}
}

/*
	Name: ragdoll_impact_watch
	Namespace: namespace_3dfeef6
	Checksum: 0x659FD91E
	Offset: 0x4C38
	Size: 0x1C5
	Parameters: 1
	Flags: None
*/
function ragdoll_impact_watch(localClientNum)
{
	self endon("entityshutdown");
	waitTime = 0.016;
	gibSpeed = 500;
	prevOrigin = self.origin;
	WaitRealTime(waitTime);
	prevVel = self.origin - prevOrigin;
	prevSpeed = length(prevVel);
	prevOrigin = self.origin;
	WaitRealTime(waitTime);
	firstloop = 1;
	while(1)
	{
		vel = self.origin - prevOrigin;
		speed = length(vel);
		if(speed < prevSpeed * 0.5 && prevSpeed > gibSpeed * waitTime)
		{
			dir = VectorNormalize(prevVel);
			self gib_ragdoll(localClientNum, dir);
			break;
		}
		if(prevSpeed < gibSpeed * waitTime && !firstloop)
		{
			break;
		}
		prevOrigin = self.origin;
		prevVel = vel;
		prevSpeed = speed;
		firstloop = 0;
		WaitRealTime(waitTime);
	}
}

/*
	Name: gib_ragdoll
	Namespace: namespace_3dfeef6
	Checksum: 0x124C3F6E
	Offset: 0x4E08
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function gib_ragdoll(localClientNum, hitdir)
{
	if(util::is_mature())
	{
		playFX(localClientNum, level._effect["rag_doll_gib_mini"], self.origin, hitdir * -1);
	}
}

/*
	Name: maze_floor_controller_rumble
	Namespace: namespace_3dfeef6
	Checksum: 0x71AC668E
	Offset: 0x4E78
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function maze_floor_controller_rumble(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	player = GetLocalPlayers()[localClientNum];
	if(player GetEntityNumber() != self GetEntityNumber())
	{
		return;
	}
	if(newVal)
	{
		self thread maze_rumble_while_floor_shakes(localClientNum);
	}
	else
	{
		self notify("stop_maze_rumble");
		self StopRumble(localClientNum, "slide_rumble");
	}
}

/*
	Name: maze_rumble_while_floor_shakes
	Namespace: namespace_3dfeef6
	Checksum: 0x36E38C48
	Offset: 0x4F68
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function maze_rumble_while_floor_shakes(int_client_num)
{
	self endon("stop_maze_rumble");
	while(isdefined(self))
	{
		self PlayRumbleOnEntity(int_client_num, "slide_rumble");
		wait(0.05);
	}
}

/*
	Name: function_425904c0
	Namespace: namespace_3dfeef6
	Checksum: 0x2C7038A1
	Offset: 0x4FB8
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function function_425904c0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		player = GetLocalPlayer(localClientNum);
		if(self == player)
		{
			self PlayRumbleLoopOnEntity(localClientNum, "tank_rumble");
		}
	}
	else
	{
		player = GetLocalPlayer(localClientNum);
		if(self == player)
		{
			self StopRumble(localClientNum, "tank_rumble");
		}
	}
}

