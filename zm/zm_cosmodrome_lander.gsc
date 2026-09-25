#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\zm_cosmodrome_amb;
#using scripts\zm\zm_cosmodrome_eggs;

#namespace namespace_9d4ce396;

/*
	Name: init
	Namespace: namespace_9d4ce396
	Checksum: 0xC3AAA2F3
	Offset: 0xA38
	Size: 0x4FB
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("lander_power");
	level flag::init("lander_connected");
	level flag::init("lander_grounded");
	level flag::init("lander_takeoff");
	level flag::init("lander_landing");
	level flag::init("lander_cooldown");
	level flag::init("lander_inuse");
	level.zone_connected = 0;
	level.lander_in_use = 0;
	level.lander_ridden = 0;
	lander = GetEnt("lander", "targetname");
	lander.console = GetEnt("lander_console", "targetname");
	lander.console LinkTo(lander);
	lander.door_north = GetEnt("zipline_door_n", "script_noteworthy");
	lander.door_south = GetEnt("zipline_door_s", "script_noteworthy");
	lander SetForceNoCull();
	lander.door_north SetForceNoCull();
	lander.door_south SetForceNoCull();
	lander.station = "lander_station5";
	lander.State = "idle";
	lander.called = 0;
	lander.anchor = spawn("script_origin", lander.origin);
	lander.anchor.angles = lander.angles;
	lander LinkTo(lander.anchor);
	lander link_pieces(undefined, 1);
	lander.door_north link_pieces(undefined, 1);
	lander.door_south link_pieces(undefined, 1);
	lander.zone = [];
	lander.zone["lander_station1"] = "base_entry_zone";
	lander.zone["lander_station3"] = "north_catwalk_zone3";
	lander.zone["lander_station4"] = "storage_lander_zone";
	lander.zone["lander_station5"] = "centrifuge_zone";
	lander.stations_waiting = 3;
	init_call_boxes();
	level thread lander_poi_init();
	level flag::wait_till("start_zombie_round_logic");
	callback::on_connect(&function_7a1aff0c);
	setup_initial_lander_states();
	level notify("lander_launched");
	wait(0.1);
	level flag::wait_till("power_on");
	enable_callboxes();
	open_lander_gate();
	level thread lander_cooldown_think();
	level thread play_launch_unlock_vox();
}

/*
	Name: function_7a1aff0c
	Namespace: namespace_9d4ce396
	Checksum: 0x21100C3D
	Offset: 0xF40
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_7a1aff0c()
{
	if(level flag::get("lander_intro_done"))
	{
		self.lander = 0;
	}
}

/*
	Name: setup_initial_lander_states
	Namespace: namespace_9d4ce396
	Checksum: 0xE3CFF25E
	Offset: 0xF78
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function setup_initial_lander_states()
{
	level clientfield::set("COSMO_LANDER_BASE_ENTRY_BAY", 1);
	level clientfield::set("COSMO_LANDER_CATWALK_BAY", 1);
	level clientfield::set("COSMO_LANDER_STORAGE_BAY", 1);
}

/*
	Name: lander_poi_init
	Namespace: namespace_9d4ce396
	Checksum: 0x106BD433
	Offset: 0xFE8
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function lander_poi_init()
{
	lander_poi = GetEntArray("lander_poi", "targetname");
	for(i = 0; i < lander_poi.size; i++)
	{
		lander_poi[i] zm_utility::create_zombie_point_of_interest(undefined, 30, 0, 0);
		lander_poi[i] thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, 45);
	}
}

/*
	Name: activate_lander_poi
	Namespace: namespace_9d4ce396
	Checksum: 0xB0380FD
	Offset: 0x1098
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function activate_lander_poi(station)
{
	if(!isdefined(station))
	{
		return;
	}
	current_poi = undefined;
	lander_poi = GetEntArray("lander_poi", "targetname");
	for(i = 0; i < lander_poi.size; i++)
	{
		if(lander_poi[i].script_string == station)
		{
			current_poi = lander_poi[i];
			continue;
		}
	}
	current_poi zm_utility::activate_zombie_point_of_interest();
	level flag::wait_till("lander_grounded");
	current_poi zm_utility::deactivate_zombie_point_of_interest();
}

/*
	Name: init_lander_screen
	Namespace: namespace_9d4ce396
	Checksum: 0xBB854883
	Offset: 0x11A8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function init_lander_screen()
{
	self SetModel("p_zom_lunar_control_scrn_on");
}

/*
	Name: link_pieces
	Namespace: namespace_9d4ce396
	Checksum: 0xAEFAD0B3
	Offset: 0x11D8
	Size: 0x135
	Parameters: 2
	Flags: None
*/
function link_pieces(piece, no_cull)
{
	pieces = GetEntArray(self.target, "targetname");
	for(i = 0; i < pieces.size; i++)
	{
		if(isdefined(pieces[i].script_noteworthy) && pieces[i].script_noteworthy == "zip_buy")
		{
			pieces[i] EnableLinkTo();
		}
		if(isdefined(piece))
		{
			pieces[i] LinkTo(piece);
		}
		else
		{
			pieces[i] LinkTo(self);
		}
		if(isdefined(no_cull) && no_cull)
		{
			pieces[i] SetForceNoCull();
		}
	}
}

/*
	Name: close_lander_door
	Namespace: namespace_9d4ce396
	Checksum: 0xAA458ABC
	Offset: 0x1318
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function close_lander_door(time)
{
	open_pos = struct::get(self.target, "targetname");
	start_pos = struct::get(open_pos.target, "targetname");
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "shaft_cap")
	{
	}
	else
	{
		level flag::wait_till("lander_grounded");
	}
}

/*
	Name: open_lander_door
	Namespace: namespace_9d4ce396
	Checksum: 0x818A7461
	Offset: 0x13D0
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function open_lander_door(time)
{
	open_pos = struct::get(self.target, "targetname");
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "shaft_cap")
	{
		level waittill("lander_launched");
	}
}

/*
	Name: open_lander_gate
	Namespace: namespace_9d4ce396
	Checksum: 0xE667ACB7
	Offset: 0x1440
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function open_lander_gate()
{
	lander = GetEnt("lander", "targetname");
	north_pos = GetEnt("zipline_door_n_pos", "script_noteworthy");
	south_pos = GetEnt("zipline_door_s_pos", "script_noteworthy");
	lander.door_north thread move_gate(north_pos, 1);
	lander.door_south thread move_gate(south_pos, 1);
}

/*
	Name: close_lander_gate
	Namespace: namespace_9d4ce396
	Checksum: 0xD4F7C597
	Offset: 0x1528
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function close_lander_gate(time)
{
	lander = GetEnt("lander", "targetname");
	north_pos = GetEnt("zipline_door_n_pos", "script_noteworthy");
	south_pos = GetEnt("zipline_door_s_pos", "script_noteworthy");
	center_pos = GetEnt("zipline_center", "script_noteworthy");
	lander.door_north thread move_gate(north_pos, 0, time);
	lander.door_south thread move_gate(south_pos, 0, time);
}

/*
	Name: move_gate
	Namespace: namespace_9d4ce396
	Checksum: 0xD77989ED
	Offset: 0x1650
	Size: 0x23B
	Parameters: 3
	Flags: None
*/
function move_gate(pos, lower, time)
{
	if(!isdefined(time))
	{
		time = 1;
	}
	lander = GetEnt("lander", "targetname");
	self Unlink();
	if(lower)
	{
		self notsolid();
		if(self.classname == "script_brushmodel")
		{
			self moveto(pos.origin + VectorScale((0, 0, -1), 132), time);
		}
		else
		{
			self playsound("zmb_lander_gate");
			self moveto(pos.origin + VectorScale((0, 0, -1), 44), time);
		}
		self waittill("movedone");
		if(self.classname == "script_brushmodel")
		{
			self notsolid();
		}
	}
	else if(self.classname == "script_brushmodel")
	{
	}
	else
	{
		self playsound("zmb_lander_gate");
	}
	self notsolid();
	self moveto(pos.origin, time);
	self waittill("movedone");
	if(self.classname == "script_brushmodel")
	{
		self solid();
	}
	self LinkTo(lander.anchor);
}

/*
	Name: init_buy
	Namespace: namespace_9d4ce396
	Checksum: 0x5A0DD003
	Offset: 0x1898
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init_buy()
{
	trigger = GetEnt("zip_buy", "script_noteworthy");
	trigger thread lander_buy_think();
}

/*
	Name: init_call_boxes
	Namespace: namespace_9d4ce396
	Checksum: 0xB6D8348
	Offset: 0x18E8
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function init_call_boxes()
{
	level flag::wait_till("zones_initialized");
	trigger = GetEntArray("zip_call_box", "targetname");
	for(i = 0; i < trigger.size; i++)
	{
		trigger[i] thread call_box_think();
		self.destination = "lander_station5";
	}
}

/*
	Name: call_box_think
	Namespace: namespace_9d4ce396
	Checksum: 0x4E4A52C
	Offset: 0x1998
	Size: 0x337
	Parameters: 0
	Flags: None
*/
function call_box_think()
{
	level endon("fake_death");
	lander = GetEnt("lander", "targetname");
	self setHintString(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	level flag::wait_till("power_on");
	self.activated_station = 0;
	if(lander.station != self.script_noteworthy)
	{
		self setHintString(&"ZM_COSMODROME_LANDER_CALL");
		continue;
	}
	self setHintString(&"ZM_COSMODROME_LANDER_AT_STATION");
	self setcursorhint("HINT_NOICON");
	while(1)
	{
		who = undefined;
		self waittill("trigger", who);
		if(who laststand::player_is_in_laststand())
		{
			continue;
		}
		if(level flag::get("lander_cooldown") || level flag::get("lander_inuse"))
		{
			continue;
		}
		if(!self.activated_station)
		{
			self.activated_station = 1;
		}
		if(lander.station != self.script_noteworthy)
		{
			call_destination = self.script_noteworthy;
			lander.called = 1;
			level.lander_in_use = 1;
			self playsound("zmb_push_button");
			self playsound("vox_ann_lander_current_0");
			switch(call_destination)
			{
				case "lander_station5":
				{
					level clientfield::set("COSMO_LANDER_DEST", 4);
					break;
				}
				case "lander_station1":
				{
					level clientfield::set("COSMO_LANDER_DEST", 3);
					break;
				}
				case "lander_station3":
				{
					level clientfield::set("COSMO_LANDER_DEST", 2);
					break;
				}
				case "lander_station4":
				{
					level clientfield::set("COSMO_LANDER_DEST", 1);
					break;
				}
			}
			self thread lander_take_off(call_destination);
		}
		wait(0.05);
	}
}

/*
	Name: lander_buy_think
	Namespace: namespace_9d4ce396
	Checksum: 0xDB5BFFD8
	Offset: 0x1CD8
	Size: 0x77B
	Parameters: 0
	Flags: None
*/
function lander_buy_think()
{
	level endon("fake_death");
	self setHintString(&"ZOMBIE_NEED_POWER");
	level flag::wait_till("power_on");
	lander = GetEnt("lander", "targetname");
	panel = GetEnt("rocket_launch_panel", "targetname");
	self setHintString(&"ZM_COSMODROME_LANDER_NO_CONNECTIONS");
	level clientfield::set("COSMO_LANDER_STATUS_LIGHTS", 1);
	level clientfield::set("COSMO_LANDER_STATION", 4);
	while(!lander.called)
	{
		wait(1);
	}
	level.zone_connected = 1;
	level flag::set("lander_connected");
	self setHintString(&"ZM_COSMODROME_LANDER", 250);
	node = GetNode("goto_centrifuge", "targetname");
	while(1)
	{
		who = undefined;
		self waittill("trigger", who);
		if(level flag::get("lander_cooldown") || level flag::get("lander_inuse"))
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			continue;
		}
		if(who laststand::player_is_in_laststand())
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			continue;
		}
		rider_trigger = GetEnt(lander.station + "_riders", "targetname");
		touching = 0;
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(rider_trigger istouching(players[i]))
			{
				touching = 1;
			}
		}
		if(!touching)
		{
			continue;
		}
		if(zombie_utility::is_player_valid(who) && who zm_score::can_player_purchase(level.lander_cost))
		{
			who zm_score::minus_to_player_score(level.lander_cost);
			zm_utility::play_sound_at_pos("purchase", self.origin);
			self playsound("zmb_push_button");
			self playsound("vox_ann_lander_current_0");
			level.lander_in_use = 1;
			lander.called = 0;
			if(lander.station != "lander_station5")
			{
				lander thread function_bd6e70fe();
			}
			call_box = GetEnt(lander.station, "script_noteworthy");
			if(lander.station == "lander_station5")
			{
				dest = [];
				azkeys = getArrayKeys(lander.zone);
				for(i = 0; i < azkeys.size; i++)
				{
					if(azkeys[i] == lander.station)
					{
						continue;
					}
					zone = level.zones[lander.zone[azkeys[i]]];
					if(isdefined(zone) && zone.is_enabled)
					{
						dest[dest.size] = azkeys[i];
					}
				}
				dest = Array::randomize(dest);
				call_box.destination = dest[0];
			}
			else
			{
				call_box.destination = "lander_station5";
			}
			lander.driver = who;
			lander playsound("zmb_lander_start");
			lander PlayLoopSound("zmb_lander_exhaust_loop", 1);
			switch(call_box.destination)
			{
				case "lander_station5":
				{
					level clientfield::set("COSMO_LANDER_DEST", 4);
					break;
				}
				case "lander_station1":
				{
					level clientfield::set("COSMO_LANDER_DEST", 3);
					break;
				}
				case "lander_station3":
				{
					level clientfield::set("COSMO_LANDER_DEST", 2);
					break;
				}
				case "lander_station4":
				{
					level clientfield::set("COSMO_LANDER_DEST", 1);
					break;
				}
			}
			self lander_take_off(call_box.destination);
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			who zm_audio::create_and_play_dialog("general", "no_money", 0);
			continue;
		}
		wait(0.05);
	}
}

/*
	Name: function_bd6e70fe
	Namespace: namespace_9d4ce396
	Checksum: 0x8C9F29C4
	Offset: 0x2460
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function function_bd6e70fe()
{
	str_flag_name = "";
	var_49df99ed = "";
	switch(self.station)
	{
		case "lander_station1":
		{
			str_flag_name = "lander_a_used";
			var_49df99ed = "COSMO_LAUNCH_PANEL_BASEENTRY_STATUS";
			break;
		}
		case "lander_station3":
		{
			str_flag_name = "lander_b_used";
			var_49df99ed = "COSMO_LAUNCH_PANEL_CATWALK_STATUS";
			break;
		}
		case "lander_station4":
		{
			str_flag_name = "lander_c_used";
			var_49df99ed = "COSMO_LAUNCH_PANEL_STORAGE_STATUS";
			break;
		}
	}
	level notify("new_lander_used");
	level flag::set(str_flag_name);
	wait(2);
	level flag::wait_till("lander_grounded");
	self clientfield::set(var_49df99ed, 1);
}

/*
	Name: enable_callboxes
	Namespace: namespace_9d4ce396
	Checksum: 0xE60414
	Offset: 0x2588
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
function enable_callboxes()
{
	call_boxes = GetEntArray("zip_call_box", "targetname");
	lander = GetEnt("lander", "targetname");
	for(j = 0; j < call_boxes.size; j++)
	{
		if(call_boxes[j].script_noteworthy != lander.station)
		{
			call_boxes[j] TriggerEnable(1);
			call_boxes[j] setHintString(&"ZM_COSMODROME_LANDER_CALL");
			continue;
		}
		call_boxes[j] TriggerEnable(1);
		call_boxes[j] setHintString("");
		call_boxes[j] setcursorhint("HINT_NOICON");
	}
}

/*
	Name: new_lander_intro
	Namespace: namespace_9d4ce396
	Checksum: 0x4B25C1D0
	Offset: 0x2700
	Size: 0x443
	Parameters: 0
	Flags: None
*/
function new_lander_intro()
{
	level.intro_lander = 1;
	level thread lander_intro_think();
	lander = GetEnt("lander", "targetname");
	north_pos = GetEnt("zipline_door_n_pos", "script_noteworthy");
	south_pos = GetEnt("zipline_door_s_pos", "script_noteworthy");
	lander.og_angles = lander.angles;
	north_pos.og_angles = north_pos.angles;
	south_pos.og_angles = south_pos.angles;
	thread close_lander_gate(0.05);
	level flag::wait_till("initial_players_connected");
	while(!AreTexturesLoaded())
	{
		wait(0.05);
	}
	wait(3.5);
	lander = GetEnt("lander", "targetname");
	lander lock_players_intro();
	lander PlayLoopSound("zmb_lander_exhaust_loop");
	lander.sound_ent = spawn("script_origin", lander.origin);
	lander.sound_ent LinkTo(lander);
	lander.sound_ent playsound("zmb_lander_launch");
	lander.sound_ent PlayLoopSound("zmb_lander_flying_low_loop");
	lander_struct = struct::get("lander_station5", "targetname");
	spot1 = lander_struct.origin;
	wait(1.5);
	level thread lander_engine_fx();
	lander.anchor moveto(spot1, 8, 0.1, 7.9);
	level notify("lander_launched");
	util::delay(6, undefined, &flag::set, "lander_intro_done");
	lander.anchor waittill("movedone");
	level.intro_lander = 0;
	level flag::set("lander_grounded");
	level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_startup");
	lander.sound_ent StopLoopSound(3);
	lander StopLoopSound(3);
	playsoundatposition("zmb_lander_land", lander.sound_ent.origin);
	open_lander_gate();
	unlock_players();
	level thread force_wait_for_gersh_line();
}

/*
	Name: lander_intro_think
	Namespace: namespace_9d4ce396
	Checksum: 0xE67263CA
	Offset: 0x2B50
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function lander_intro_think()
{
	trigger = GetEnt("zip_buy", "script_noteworthy");
	trigger setcursorhint("HINT_NOICON");
	level flag::wait_till("lander_grounded");
	wait(15);
	init_buy();
}

/*
	Name: lander_take_off
	Namespace: namespace_9d4ce396
	Checksum: 0x488991A6
	Offset: 0x2BE0
	Size: 0x753
	Parameters: 1
	Flags: None
*/
function lander_take_off(dest)
{
	level flag::clear("lander_grounded");
	level flag::set("lander_takeoff");
	lander = GetEnt("lander", "targetname");
	level clientfield::set("COSMO_LANDER_STATUS_LIGHTS", 1);
	lander thread lock_players(dest);
	level notify("LU", lander.riders, self);
	lander.depart_station = lander.station;
	depart = GetEnt(lander.station, "script_noteworthy");
	if(depart.target == "catwalk_zip_door")
	{
		level clientfield::set("COSMO_LANDER_CATWALK_BAY", 3);
	}
	else if(depart.target == "base_entry_zip_door")
	{
		level clientfield::set("COSMO_LANDER_BASE_ENTRY_BAY", 3);
	}
	else if(depart.target == "centrifuge_zip_door")
	{
		level clientfield::set("COSMO_LANDER_CENTRIFUGE_BAY", 3);
	}
	else if(depart.target == "storage_zip_door")
	{
		level clientfield::set("COSMO_LANDER_STORAGE_BAY", 3);
	}
	depart_door = GetEntArray(depart.target, "targetname");
	for(i = 0; i < depart_door.size; i++)
	{
		depart_door[i] thread open_lander_door();
	}
	close_lander_gate();
	station = struct::get(lander.station, "targetname");
	hub = struct::get(station.target, "targetname");
	level flag::clear("spawn_zombies");
	level thread lander_engine_fx();
	wait(1);
	if(lander.called == 1)
	{
		lander.station = self.script_noteworthy;
	}
	else
	{
		lander.station = dest;
	}
	ARRIVE = GetEnt(lander.station, "script_noteworthy");
	if(isdefined(ARRIVE.target))
	{
		if(ARRIVE.target == "catwalk_zip_door")
		{
			level clientfield::set("COSMO_LANDER_CATWALK_BAY", 2);
			depart thread function_5f5d494f();
		}
		else if(ARRIVE.target == "base_entry_zip_door")
		{
			level clientfield::set("COSMO_LANDER_BASE_ENTRY_BAY", 2);
			depart thread function_5f5d494f();
		}
		else if(ARRIVE.target == "centrifuge_zip_door")
		{
			level clientfield::set("COSMO_LANDER_CENTRIFUGE_BAY", 2);
			depart thread function_5f5d494f();
		}
		else if(ARRIVE.target == "storage_zip_door")
		{
			level clientfield::set("COSMO_LANDER_STORAGE_BAY", 2);
			depart thread function_5f5d494f();
		}
	}
	lander.sound_ent playsound("zmb_lander_launch");
	lander.sound_ent PlayLoopSound("zmb_lander_flying_low_loop");
	lander.anchor moveto(hub.origin, 3, 2, 1);
	lander.anchor thread lander_takeoff_wobble();
	level notify("lander_launched");
	level flag::clear("lander_takeoff");
	wait(3.1);
	lander clientfield::set("COSMO_LANDER_MOVE_FX", 1);
	lander.anchor lander_hover_idle();
	if(isdefined(hub.target))
	{
		extra_dest = struct::get(hub.target, "targetname");
		lander.anchor moveto(extra_dest.origin, 2);
		lander.anchor waittill("movedone");
	}
	call_box = GetEnt(lander.station, "script_noteworthy");
	call_box playsound("vox_ann_lander_current_1");
	lander clientfield::set("COSMO_LANDER_MOVE_FX", 0);
	lander_goto_dest();
}

/*
	Name: function_5f5d494f
	Namespace: namespace_9d4ce396
	Checksum: 0xC6A57975
	Offset: 0x3340
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_5f5d494f()
{
	level flag::wait_till("lander_inuse");
	if(self.target == "catwalk_zip_door")
	{
		level clientfield::set("COSMO_LANDER_CATWALK_BAY", 1);
	}
	else if(self.target == "base_entry_zip_door")
	{
		level clientfield::set("COSMO_LANDER_BASE_ENTRY_BAY", 1);
	}
	else if(self.target == "centrifuge_zip_door")
	{
		level clientfield::set("COSMO_LANDER_CENTRIFUGE_BAY", 1);
	}
	else if(self.target == "storage_zip_door")
	{
		level clientfield::set("COSMO_LANDER_STORAGE_BAY", 1);
	}
}

/*
	Name: lander_hover_idle
	Namespace: namespace_9d4ce396
	Checksum: 0xFD8AF888
	Offset: 0x3450
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function lander_hover_idle()
{
	num = self.angles[0] + randomIntRange(-3, 3);
	num1 = self.angles[1] + randomIntRange(-3, 3);
	self RotateTo((num, num1, RandomFloatRange(0, 5)), 0.5);
	self moveto((self.origin[0], self.origin[1], self.origin[2] + 20), 0.5, 0.1);
	wait(0.5);
}

/*
	Name: player_blocking_lander
	Namespace: namespace_9d4ce396
	Checksum: 0x72609DD6
	Offset: 0x3568
	Size: 0x307
	Parameters: 0
	Flags: None
*/
function player_blocking_lander()
{
	players = GetPlayers();
	lander = GetEnt("lander", "targetname");
	rider_trigger = GetEnt(lander.station + "_riders", "targetname");
	crumb = struct::get(rider_trigger.target, "targetname");
	for(i = 0; i < players.size; i++)
	{
		if(rider_trigger istouching(players[i]))
		{
			players[i] SetOrigin(crumb.origin + (randomIntRange(-20, 20), randomIntRange(-20, 20), 0));
			players[i] DoDamage(players[i].health + 10000, players[i].origin);
		}
	}
	zombies = GetAISpeciesArray("axis");
	for(i = 0; i < zombies.size; i++)
	{
		if(isdefined(zombies[i]))
		{
			if(rider_trigger istouching(zombies[i]))
			{
				level.zombie_total++;
				playsoundatposition("nuked", zombies[i].origin);
				playFX(level._effect["zomb_gib"], zombies[i].origin);
				if(isdefined(zombies[i].lander_death))
				{
					zombies[i] [[zombies[i].lander_death]]();
				}
				zombies[i] delete();
			}
		}
	}
	wait(0.5);
}

/*
	Name: lock_players
	Namespace: namespace_9d4ce396
	Checksum: 0x41D67280
	Offset: 0x3878
	Size: 0x61F
	Parameters: 1
	Flags: None
*/
function lock_players(destination)
{
	lander = GetEnt("lander", "targetname");
	lander.riders = 0;
	spots = GetEntArray("zipline_spots", "script_noteworthy");
	taken = [];
	zipline_door1 = GetEnt("zipline_door_n", "script_noteworthy");
	zipline_door2 = GetEnt("zipline_door_s", "script_noteworthy");
	base = GetEnt("lander_base", "script_noteworthy");
	ls_taken = [];
	rider_trigger = GetEnt(lander.station + "_riders", "targetname");
	crumb = struct::get(rider_trigger.target, "targetname");
	lander thread takeoff_nuke(undefined, 80, 1, rider_trigger);
	lander thread takeoff_knockdown(81, 250);
	players = GetPlayers();
	lander_trig = GetEnt("zip_buy", "script_noteworthy");
	x = 0;
	while(!level flag::get("lander_grounded"))
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(!rider_trigger istouching(players[i]) && !players[i] istouching(zipline_door1) && !players[i] istouching(zipline_door2) && !players[i] istouching(base) && x < 8)
			{
				continue;
			}
			if(!players[i] istouching(lander_trig))
			{
				continue;
			}
			if(isdefined(players[i].lander) && players[i].lander)
			{
				continue;
			}
			max_dist = 10000;
			Grab = -1;
			for(j = 0; j < 4; j++)
			{
				if(isdefined(taken[j]) && taken[j] == 1)
				{
					continue;
				}
				dist = Distance2D(players[i].origin, spots[j].origin);
				if(dist < max_dist)
				{
					max_dist = dist;
					Grab = j;
				}
			}
			taken[Grab] = 1;
			if(players[i] laststand::player_is_in_laststand())
			{
				players[i] thread function_e323fa97();
			}
			players[i] PlayerLinkToDelta(spots[Grab], undefined, 1, 180, 180, 180, 180, 1);
			players[i] EnableInvulnerability();
			players[i] thread zm::store_crumb(crumb.origin);
			players[i].lander = 1;
			players[i].lander_link_spot = spots[Grab];
			players[i] clientfield::set("COSMO_PLAYER_LANDER_FOG", 1);
			lander.riders++;
		}
		wait(0.25);
		x++;
		if(x == 4)
		{
			if(lander.riders == players.size)
			{
				level thread activate_lander_poi(destination);
			}
		}
	}
}

/*
	Name: function_e323fa97
	Namespace: namespace_9d4ce396
	Checksum: 0x238E2495
	Offset: 0x3EA0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_e323fa97()
{
	self endon("bled_out");
	self.on_lander_last_stand = 1;
	self AllowCrouch(0);
	self AllowStand(0);
	self.lander = 1;
	while(self.lander === 1 && self laststand::player_is_in_laststand())
	{
		wait(0.05);
	}
	self.on_lander_last_stand = undefined;
	self AllowCrouch(1);
	self AllowStand(1);
	self SetStance("stand");
}

/*
	Name: lock_players_intro
	Namespace: namespace_9d4ce396
	Checksum: 0xD7A73AB1
	Offset: 0x3F90
	Size: 0x235
	Parameters: 0
	Flags: None
*/
function lock_players_intro()
{
	lander = GetEnt("lander", "targetname");
	lander.riders = 0;
	spots = GetEntArray("zipline_spots", "script_noteworthy");
	players = GetPlayers();
	taken = [];
	rider_trigger = GetEnt("lander_in_sky_riders", "targetname");
	crumb = struct::get(rider_trigger.target, "targetname");
	for(i = 0; i < players.size; i++)
	{
		Grab = -1;
		for(j = 0; j < 4; j++)
		{
			if(isdefined(taken[j]) && taken[j] == 1)
			{
				continue;
			}
			Grab = j;
		}
		taken[Grab] = 1;
		players[i] playerLinkTo(spots[Grab], undefined, 0, 180, 180, 180, 180, 1);
		players[i] EnableInvulnerability();
		players[i].lander = 1;
		lander.riders++;
	}
}

/*
	Name: unlock_players
	Namespace: namespace_9d4ce396
	Checksum: 0x51C79B78
	Offset: 0x41D0
	Size: 0x1D1
	Parameters: 0
	Flags: None
*/
function unlock_players()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] Unlink();
		players[i] DisableInvulnerability();
		players[i].on_lander_last_stand = undefined;
		/#
			if(GetDvarInt("Dev Block strings are not supported") >= 1 && GetDvarInt("Dev Block strings are not supported") <= 3)
			{
				players[i] EnableInvulnerability();
			}
		#/
		players[i] thread zm::store_crumb(players[i].origin);
		players[i].lander = 0;
	}
	lander = GetEnt("lander", "targetname");
	if(isdefined(lander.driver) && lander.driver zombie_utility::is_zombie())
	{
		lander.driver Unlink();
		lander.driver = undefined;
	}
}

/*
	Name: lander_goto_dest
	Namespace: namespace_9d4ce396
	Checksum: 0x637C4718
	Offset: 0x43B0
	Size: 0x9CB
	Parameters: 0
	Flags: None
*/
function lander_goto_dest()
{
	level endon("intermission");
	lander = GetEnt("lander", "targetname");
	final_dest = struct::get(lander.station, "targetname");
	ARRIVE = GetEnt(lander.station, "script_noteworthy");
	if(isdefined(final_dest.target))
	{
		current_dest = struct::get(final_dest.target, "targetname");
		if(isdefined(current_dest.target))
		{
			lander.anchor thread lander_flight_wobble(lander, final_dest);
			extra_dest = struct::get(current_dest.target, "targetname");
			lander.anchor moveto(extra_dest.origin, 5, 1);
			lander.anchor waittill("movedone");
			lander_clean_up_corpses(lander.anchor.origin, 150);
			lander.anchor moveto(current_dest.origin, 2, 0, 2);
			lander.anchor waittill("movedone");
		}
		else
		{
			lander.anchor thread lander_flight_wobble(lander, final_dest);
			lander.anchor moveto(current_dest.origin, 7, 1, 2.75);
			lander.anchor waittill("movedone");
		}
	}
	lander_clean_up_corpses(lander.anchor.origin, 150);
	level flag::wait_till("lander_landing");
	moveTime = 5;
	accelTime = 0.1;
	decelTime = 4.9;
	var_5021702 = "";
	if(isdefined(ARRIVE.target))
	{
		if(ARRIVE.target == "catwalk_zip_door")
		{
			level clientfield::set("COSMO_LANDER_CATWALK_BAY", 3);
			var_5021702 = "lgt_exp_padup_catwalk";
		}
		else if(ARRIVE.target == "base_entry_zip_door")
		{
			moveTime = 6;
			accelTime = 0.1;
			decelTime = 5.9;
			level clientfield::set("COSMO_LANDER_BASE_ENTRY_BAY", 3);
			var_5021702 = "lgt_exp_padup_base_entry";
		}
		else if(ARRIVE.target == "centrifuge_zip_door")
		{
			moveTime = 7;
			accelTime = 0.1;
			decelTime = 6.9;
			level clientfield::set("COSMO_LANDER_CENTRIFUGE_BAY", 3);
			var_5021702 = "lgt_exp_padup_centrifuge";
		}
		else if(ARRIVE.target == "storage_zip_door")
		{
			moveTime = 6;
			accelTime = 0.1;
			decelTime = 5.9;
			level clientfield::set("COSMO_LANDER_STORAGE_BAY", 3);
			var_5021702 = "lgt_exp_padup_storage";
		}
	}
	if(var_5021702 != "")
	{
		exploder::exploder(var_5021702);
	}
	arrive_door = GetEntArray(ARRIVE.target, "targetname");
	for(i = 0; i < arrive_door.size; i++)
	{
		arrive_door[i] thread close_lander_door(1);
	}
	lander.anchor moveto(final_dest.origin, moveTime, accelTime, decelTime);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i].lander)
		{
			players[i] clientfield::set("COSMO_PLAYER_LANDER_FOG", 0);
		}
	}
	lander.anchor thread lander_landing_wobble(moveTime);
	level thread player_blocking_lander();
	lander.anchor waittill("movedone");
	lander.sound_ent StopLoopSound(1);
	lander StopLoopSound(3);
	playsoundatposition("zmb_lander_land", lander.origin);
	put_players_back_on_lander();
	level flag::set("lander_grounded");
	level flag::clear("lander_landing");
	level flag::set("spawn_zombies");
	open_lander_gate();
	unlock_players();
	level.lander_in_use = 0;
	lander.called = 0;
	if(isdefined(ARRIVE.target))
	{
		switch(ARRIVE.target)
		{
			case "catwalk_zip_door":
			{
				level clientfield::set("COSMO_LANDER_STATION", 2);
				level clientfield::set("COSMO_LANDER_CATWALK_BAY", 0);
				break;
			}
			case "base_entry_zip_door":
			{
				level clientfield::set("COSMO_LANDER_STATION", 3);
				level clientfield::set("COSMO_LANDER_BASE_ENTRY_BAY", 0);
				break;
			}
			case "centrifuge_zip_door":
			{
				level clientfield::set("COSMO_LANDER_STATION", 4);
				level clientfield::set("COSMO_LANDER_CENTRIFUGE_BAY", 0);
				break;
			}
			case "storage_zip_door":
			{
				level clientfield::set("COSMO_LANDER_STATION", 1);
				level clientfield::set("COSMO_LANDER_STORAGE_BAY", 0);
				break;
			}
		}
	}
	if(level flag::get("lander_a_used") && level flag::get("lander_b_used") && level flag::get("lander_c_used") && !level flag::get("launch_activated"))
	{
		level flag::set("launch_activated");
	}
	if(var_5021702 != "")
	{
		wait(1);
		exploder::kill_exploder(var_5021702);
	}
}

/*
	Name: lander_engine_fx
	Namespace: namespace_9d4ce396
	Checksum: 0x75D067E9
	Offset: 0x4D88
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function lander_engine_fx()
{
	lander_base = GetEnt("lander_base", "script_noteworthy");
	lander_base clientfield::set("COSMO_LANDER_ENGINE_FX", 1);
	lander_base clientfield::set("COSMO_LANDER_RUMBLE_AND_QUAKE", 1);
	level flag::wait_till("lander_grounded");
	lander_base clientfield::set("COSMO_LANDER_RUMBLE_AND_QUAKE", 0);
	wait(2.5);
	playFX(level._effect["lunar_lander_dust"], lander_base.origin);
	lander_base clientfield::set("COSMO_LANDER_ENGINE_FX", 0);
}

/*
	Name: takeoff_nuke
	Namespace: namespace_9d4ce396
	Checksum: 0x4AB8F159
	Offset: 0x4EA0
	Size: 0x12B
	Parameters: 4
	Flags: None
*/
function takeoff_nuke(max_zombies, range, delay, trig)
{
	if(isdefined(delay))
	{
		wait(delay);
	}
	zombies = GetAISpeciesArray("axis");
	spot = self.origin;
	zombies = util::get_array_of_closest(self.origin, zombies, undefined, max_zombies, range);
	for(i = 0; i < zombies.size; i++)
	{
		if(!zombies[i] istouching(trig))
		{
			continue;
		}
		zombies[i] thread zombie_burst();
	}
	wait(0.5);
	lander_clean_up_corpses(spot, 250);
}

/*
	Name: zombie_burst
	Namespace: namespace_9d4ce396
	Checksum: 0x2B146BC3
	Offset: 0x4FD8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function zombie_burst()
{
	self endon("death");
	wait(RandomFloatRange(0.2, 0.3));
	level.zombie_total++;
	playsoundatposition("nuked", self.origin);
	playFX(level._effect["zomb_gib"], self.origin);
	if(isdefined(self.lander_death))
	{
		self [[self.lander_death]]();
	}
	self delete();
}

/*
	Name: takeoff_knockdown
	Namespace: namespace_9d4ce396
	Checksum: 0x24C74AF2
	Offset: 0x5098
	Size: 0xDD
	Parameters: 2
	Flags: None
*/
function takeoff_knockdown(min_range, max_range)
{
	zombies = GetAISpeciesArray("axis");
	for(i = 0; i < zombies.size; i++)
	{
		dist = DistanceSquared(zombies[i].origin, self.origin);
		if(dist >= min_range * min_range && dist <= max_range * max_range)
		{
			zombies[i] thread zombie_knockdown();
		}
	}
}

/*
	Name: zombie_knockdown
	Namespace: namespace_9d4ce396
	Checksum: 0xB3380A79
	Offset: 0x5180
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function zombie_knockdown()
{
	self endon("death");
	wait(RandomFloatRange(0.2, 0.3));
	self.lander_knockdown = 1;
	if(isdefined(self.thundergun_knockdown_func))
	{
		self [[self.thundergun_knockdown_func]](self, 0);
	}
	self.thundergun_handle_pain_notetracks = &zm_weap_thundergun::handle_thundergun_pain_notetracks;
	self DoDamage(1, self.origin);
}

/*
	Name: lander_clean_up_corpses
	Namespace: namespace_9d4ce396
	Checksum: 0x8459BA80
	Offset: 0x5218
	Size: 0xB5
	Parameters: 2
	Flags: None
*/
function lander_clean_up_corpses(spot, range)
{
	corpses = GetCorpseArray();
	if(isdefined(corpses))
	{
		for(i = 0; i < corpses.size; i++)
		{
			if(DistanceSquared(spot, corpses[i].origin) <= range * range)
			{
				corpses[i] thread lander_remove_corpses();
			}
		}
	}
}

/*
	Name: lander_remove_corpses
	Namespace: namespace_9d4ce396
	Checksum: 0xEFDF9C8F
	Offset: 0x52D8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function lander_remove_corpses()
{
	wait(RandomFloatRange(0.05, 0.25));
	if(!isdefined(self))
	{
		return;
	}
	playFX(level._effect["zomb_gib"], self.origin);
	self delete();
}

/*
	Name: lander_flight_wobble
	Namespace: namespace_9d4ce396
	Checksum: 0x118C00CE
	Offset: 0x5358
	Size: 0x3FD
	Parameters: 2
	Flags: None
*/
function lander_flight_wobble(lander, final_dest)
{
	self thread lander_flight_stop_wobble();
	self endon("movedone");
	self endon("start_approach");
	first_time = 1;
	rot_time = 0.75;
	while(1)
	{
		if(first_time)
		{
			rot_time = 1.75;
		}
		if(lander.depart_station == "lander_station5" && final_dest.targetname == "lander_station1")
		{
			self RotateTo((RandomFloatRange(345, 355), 0, RandomFloatRange(0, 5)), rot_time);
		}
		else if(lander.depart_station == "lander_station1" && final_dest.targetname == "lander_station5")
		{
			self RotateTo((RandomFloatRange(370, 380), 0, RandomFloatRange(-5, 0)), rot_time);
		}
		else if(lander.depart_station == "lander_station5" && final_dest.targetname == "lander_station4")
		{
			self RotateTo((RandomFloatRange(370, 380), 0, RandomFloatRange(-5, 0)), rot_time);
		}
		else if(lander.depart_station == "lander_station4" && final_dest.targetname == "lander_station5")
		{
			self RotateTo((RandomFloatRange(345, 355), 0, RandomFloatRange(0, 5)), rot_time);
		}
		else if(lander.depart_station == "lander_station5" && final_dest.targetname == "lander_station3")
		{
			self RotateTo((RandomFloatRange(5, 10), 0, RandomFloatRange(-15, -10)), rot_time);
		}
		else if(lander.depart_station == "lander_station3" && final_dest.targetname == "lander_station5")
		{
			self RotateTo((RandomFloatRange(-10, -5), 0, RandomFloatRange(10, 15)), rot_time);
		}
		else
		{
			self RotateTo((RandomFloatRange(-5, 5), 0, RandomFloatRange(-5, 5)), rot_time);
		}
		wait(rot_time);
		if(first_time)
		{
			first_time = 0;
		}
	}
}

/*
	Name: lander_takeoff_wobble
	Namespace: namespace_9d4ce396
	Checksum: 0x2510ACE8
	Offset: 0x5760
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function lander_takeoff_wobble()
{
	level endon("lander_launched");
	while(1)
	{
		self RotateTo((RandomFloatRange(-10, 10), 0, RandomFloatRange(-10, 10)), 0.5);
		wait(0.5);
	}
}

/*
	Name: lander_landing_wobble
	Namespace: namespace_9d4ce396
	Checksum: 0x7FB51AD2
	Offset: 0x57D8
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function lander_landing_wobble(moveTime)
{
	time = moveTime - 1;
	timer = GetTime() + time * 1000;
	while(GetTime() < timer)
	{
		self RotateTo((RandomFloatRange(-5, 5), 0, RandomFloatRange(-5, 5)), 0.75);
		wait(0.75);
	}
	self RotateTo((0, 0, 0), 0.75);
}

/*
	Name: lander_flight_stop_wobble
	Namespace: namespace_9d4ce396
	Checksum: 0xBB66EDDB
	Offset: 0x58B0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function lander_flight_stop_wobble()
{
	wait(3);
	self notify("start_approach");
	self.old_angles = self.angles;
	self RotateTo((self.angles[0] * -1, self.angles[1] * -1, self.angles[2] * -1), 2.75);
	wait(3);
	self RotateTo(self.old_angles, 2);
	level flag::set("lander_landing");
}

/*
	Name: lander_cooldown_think
	Namespace: namespace_9d4ce396
	Checksum: 0x8FD287B1
	Offset: 0x5980
	Size: 0x697
	Parameters: 0
	Flags: None
*/
function lander_cooldown_think()
{
	lander_use_trig = GetEnt("zip_buy", "script_noteworthy");
	lander_callboxes = GetEntArray("zip_call_box", "targetname");
	lander = GetEnt("lander", "targetname");
	while(1)
	{
		level waittill("LU", riders, trig);
		level flag::set("lander_inuse");
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			lander_use_trig SetInvisibleToPlayer(players[i], 1);
		}
		for(i = 0; i < lander_callboxes.size; i++)
		{
			if(lander_callboxes[i] == trig)
			{
				lander_callboxes[i] setHintString(&"ZM_COSMODROME_LANDER_ON_WAY");
				lander_callboxes[i] setcursorhint("HINT_NOICON");
				continue;
			}
			lander_callboxes[i] setHintString(&"ZM_COSMODROME_LANDER_IN_USE");
			lander_callboxes[i] setcursorhint("HINT_NOICON");
		}
		while(level.lander_in_use)
		{
			wait(0.1);
		}
		level flag::clear("lander_inuse");
		level flag::set("lander_cooldown");
		Cooldown = 3;
		STR = &"ZM_COSMODROME_LANDER_COOLDOWN";
		if(riders != 0)
		{
			Cooldown = 30;
			STR = &"ZM_COSMODROME_LANDER_REFUEL";
			for(i = 0; i < lander_callboxes.size; i++)
			{
				lander_callboxes[i] playsound("vox_ann_lander_cooldown");
			}
			lander playsound("zmb_lander_pump_start");
			lander PlayLoopSound("zmb_lander_pump_loop", 1);
		}
		lander_use_trig setHintString(STR);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			lander_use_trig SetInvisibleToPlayer(players[i], 0);
		}
		for(i = 0; i < lander_callboxes.size; i++)
		{
			if(lander_callboxes[i].script_noteworthy != lander.station)
			{
				lander_callboxes[i] setHintString(STR);
				continue;
			}
			lander_callboxes[i] setHintString(&"ZM_COSMODROME_LANDER_AT_STATION");
			lander_callboxes[i] setcursorhint("HINT_NOICON");
		}
		if(!isdefined(level.var_a1879e28) || level.var_a1879e28)
		{
			wait(Cooldown);
		}
		else
		{
			wait(1);
		}
		lander StopLoopSound(1.5);
		lander playsound("zmb_lander_pump_end");
		if(Cooldown == 30)
		{
			for(i = 0; i < lander_callboxes.size; i++)
			{
				lander_callboxes[i] playsound("vox_ann_lander_ready");
			}
		}
		level clientfield::set("COSMO_LANDER_STATUS_LIGHTS", 2);
		lander_use_trig setHintString(&"ZM_COSMODROME_LANDER", 250);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			lander_use_trig SetInvisibleToPlayer(players[i], 0);
		}
		for(i = 0; i < lander_callboxes.size; i++)
		{
			if(lander_callboxes[i].script_noteworthy != lander.station)
			{
				lander_callboxes[i] setHintString(&"ZM_COSMODROME_LANDER_CALL");
				continue;
			}
			lander_callboxes[i] setHintString(&"ZM_COSMODROME_LANDER_AT_STATION");
			lander_callboxes[i] setcursorhint("HINT_NOICON");
		}
		level flag::clear("lander_cooldown");
	}
}

/*
	Name: play_launch_unlock_vox
	Namespace: namespace_9d4ce396
	Checksum: 0x54871D5
	Offset: 0x6020
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function play_launch_unlock_vox()
{
	while(1)
	{
		level flag::wait_till("lander_grounded");
		if(level flag::get("lander_a_used") && level flag::get("lander_b_used") && level flag::get("lander_c_used"))
		{
			level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_landers_used");
			return;
		}
		wait(0.05);
	}
}

/*
	Name: force_wait_for_gersh_line
	Namespace: namespace_9d4ce396
	Checksum: 0x72F10BD4
	Offset: 0x60E8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function force_wait_for_gersh_line()
{
	wait(10);
	level thread namespace_f23e8c1a::play_egg_vox(undefined, "vox_gersh_egg_start", 0);
}

/*
	Name: put_players_back_on_lander
	Namespace: namespace_9d4ce396
	Checksum: 0x78712DFD
	Offset: 0x6120
	Size: 0x14D
	Parameters: 0
	Flags: None
*/
function put_players_back_on_lander()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].lander) && players[i].lander && (!isdefined(players[i].on_lander_last_stand) && players[i].on_lander_last_stand))
		{
			continue;
		}
		if(!players[i] is_player_on_lander())
		{
			if(isdefined(players[i].lander_link_spot))
			{
				players[i] SetOrigin(players[i].lander_link_spot.origin);
				players[i] playsound("zmb_laugh_child");
			}
		}
	}
}

/*
	Name: is_player_on_lander
	Namespace: namespace_9d4ce396
	Checksum: 0x5DB606B8
	Offset: 0x6278
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function is_player_on_lander()
{
	lander = GetEnt("lander", "targetname");
	rider_trigger = GetEnt(lander.station + "_riders", "targetname");
	lander_trig = GetEnt("zip_buy", "script_noteworthy");
	base = GetEnt("lander_base", "script_noteworthy");
	if(rider_trigger istouching(self) || self istouching(lander_trig) || Distance(self.origin, base.origin) < 200)
	{
		return 1;
	}
	return 0;
}

