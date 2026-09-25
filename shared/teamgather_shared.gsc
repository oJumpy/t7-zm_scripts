#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace cTeamGather;

/*
	Name: function_9b385ca5
	Namespace: cTeamGather
	Checksum: 0x582A1C21
	Offset: 0x590
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.e_gameobject = undefined;
	self.n_font_scale = 2;
	self.v_font_color = (1, 1, 1);
	self.m_teamgather_complete = 0;
	self.m_num_players = 0;
	self.m_num_players_ready = 0;
	self.m_gather_fx = undefined;
	self.m_teamgather_complete = 0;
	self.m_success = 0;
}

/*
	Name: function_5fba2032
	Namespace: cTeamGather
	Checksum: 0x99EC1590
	Offset: 0x610
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: CleanUp
	Namespace: cTeamGather
	Checksum: 0xFCAFA201
	Offset: 0x620
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CleanUp()
{
	cleanup_floor_effect();
	self.e_gameobject gameobjects::destroy_object(1, 1);
}

/*
	Name: create_teamgather_event
	Namespace: cTeamGather
	Checksum: 0x88ADEEE4
	Offset: 0x660
	Size: 0x177
	Parameters: 4
	Flags: None
*/
function create_teamgather_event(v_interact_pos, v_interact_angles, v_gather_pos, e_interact_entity)
{
	self.m_v_interact_position = v_interact_pos;
	self.m_v_interact_angles = v_interact_angles;
	self.m_e_interact_entity = e_interact_entity;
	self.m_v_gather_position = v_gather_pos;
	self.e_gameobject = setup_gameobject(v_interact_pos, undefined, &"TEAM_GATHER_HOLD_FOR_TEAM_ENTER", self.m_e_interact_entity);
	self.e_gameobject.c_teamgather = self;
	self.e_gameobject waittill("player_interaction");
	self.e_gameobject gameobjects::disable_object();
	spawn_floor_effect();
	interact_entity_highlight(1);
	b_success = gather_players();
	cleanup_floor_effect();
	interact_entity_highlight(0);
	if(isdefined(b_success) && b_success)
	{
		teamgather_success();
	}
	else
	{
		teamgather_failure();
	}
	return b_success;
}

/*
	Name: teamgather_success
	Namespace: cTeamGather
	Checksum: 0xC0FE96EA
	Offset: 0x7E0
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function teamgather_success()
{
	if(0 > 0)
	{
		x_off = 0;
		y_off = 180;
		a_players = get_players_playing();
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			e_player.success_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, &"TEAM_GATHER_GATHER_SUCCESS");
		}
		wait(0);
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			e_player.success_hud_elem destroy();
		}
	}
}

/*
	Name: teamgather_failure
	Namespace: cTeamGather
	Checksum: 0x577E6D7D
	Offset: 0x930
	Size: 0x13D
	Parameters: 0
	Flags: None
*/
function teamgather_failure()
{
	x_off = 0;
	y_off = 180;
	a_players = get_players_playing();
	for(i = 0; i < a_players.size; i++)
	{
		e_player = a_players[i];
		e_player.failure_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, &"TEAM_GATHER_TEAM_EVENT_ABORTED");
	}
	wait(0);
	for(i = 0; i < a_players.size; i++)
	{
		e_player = a_players[i];
		e_player.failure_hud_elem destroy();
	}
}

/*
	Name: setup_gameobject
	Namespace: cTeamGather
	Checksum: 0xAAAC6CE8
	Offset: 0xA78
	Size: 0x367
	Parameters: 4
	Flags: None
*/
function setup_gameobject(v_pos, STR_MODEL, STR_USE_HINT, e_los_ignore_me)
{
	n_radius = 48;
	e_trigger = spawn("trigger_radius_use", v_pos, 0, n_radius, 30);
	e_trigger TriggerIgnoreTeam();
	e_trigger SetVisibleToAll();
	e_trigger SetTeamForTrigger("none");
	e_trigger UseTriggerRequireLookAt();
	e_trigger setcursorhint("HINT_NOICON");
	gobj_model_offset = (0, 0, 0);
	if(isdefined(STR_MODEL))
	{
		gobj_visuals[0] = spawn("script_model", v_pos + gobj_model_offset);
		gobj_visuals[0] SetModel(STR_MODEL);
	}
	else
	{
		gobj_visuals = [];
	}
	gobj_objective_name = undefined;
	gobj_team = "allies";
	gobj_trigger = e_trigger;
	gobj_offset = VectorScale((0, 0, -1), 5);
	e_object = gameobjects::create_use_object(gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name);
	e_object gameobjects::allow_use("any");
	e_object gameobjects::set_use_time(0);
	e_object gameobjects::set_use_text("");
	e_object gameobjects::set_use_hint_text(STR_USE_HINT);
	e_object gameobjects::set_visible_team("any");
	e_object.onUse = &onUseGameobject;
	e_object gameobjects::set_3d_icon("friendly", "T7_hud_prompt_press_64");
	e_object gameobjects::set_3d_icon("enemy", "T7_hud_prompt_press_64");
	e_object gameobjects::set_2d_icon("friendly", "T7_hud_prompt_press_64");
	e_object gameobjects::set_2d_icon("enemy", "T7_hud_prompt_press_64");
	e_object thread gameobjects::hide_icon_distance_and_los((1, 1, 1), 840, 1, e_los_ignore_me);
	return e_object;
}

/*
	Name: onUseGameobject
	Namespace: cTeamGather
	Checksum: 0xB2FA7DC5
	Offset: 0xDE8
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function onUseGameobject(player)
{
	self.c_teamgather.m_e_player_leader = player;
	self notify("player_interaction");
}

/*
	Name: spawn_floor_effect
	Namespace: cTeamGather
	Checksum: 0xD8E157F3
	Offset: 0xE20
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function spawn_floor_effect()
{
	if(!(isdefined(0) && 0))
	{
		return;
	}
	v_pos = self.m_v_gather_position;
	v_start = (v_pos[0], v_pos[1], v_pos[2] + 20);
	v_end = (v_pos[0], v_pos[1], v_pos[2] - 94);
	trace = bullettrace(v_start, v_end, 0, undefined);
	v_floor_pos = trace["position"];
	self.m_gather_fx = spawnFx("_t6/misc/fx_ui_flagbase_pmc", v_floor_pos);
	triggerFx(self.m_gather_fx);
}

/*
	Name: cleanup_floor_effect
	Namespace: cTeamGather
	Checksum: 0x9AB9BF60
	Offset: 0xF38
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function cleanup_floor_effect()
{
	if(!(isdefined(0) && 0))
	{
		return;
	}
	if(isdefined(self.m_gather_fx))
	{
		self.m_gather_fx delete();
		self.m_gather_fx = undefined;
	}
}

/*
	Name: interact_entity_highlight
	Namespace: cTeamGather
	Checksum: 0xEA81B126
	Offset: 0xF88
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function interact_entity_highlight(highlight_object)
{
	if(isdefined(self.m_e_interact_entity))
	{
		if(isdefined(highlight_object) && highlight_object)
		{
			self.m_e_interact_entity clientfield::set("teamgather_material", 1);
		}
		else
		{
			self.m_e_interact_entity clientfield::set("teamgather_material", 0);
		}
	}
}

/*
	Name: gather_players
	Namespace: cTeamGather
	Checksum: 0x4BC46AF0
	Offset: 0x1008
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function gather_players()
{
	start_player_timer(10);
	create_player_huds();
	b_success = teamgather_main_update();
	return b_success;
}

/*
	Name: create_player_huds
	Namespace: cTeamGather
	Checksum: 0xDE8E0F5F
	Offset: 0x1060
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function create_player_huds()
{
	a_players = get_players_playing();
	if(a_players.size <= 1)
	{
		return;
	}
	for(i = 0; i < a_players.size; i++)
	{
		e_player = a_players[i];
		if(e_player == self.m_e_player_leader)
		{
			self thread display_hud_player_leader(e_player);
			continue;
		}
		self thread display_hud_player_team_member(e_player);
	}
}

/*
	Name: is_teamgather_complete
	Namespace: cTeamGather
	Checksum: 0x6902C4B5
	Offset: 0x1128
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function is_teamgather_complete()
{
	return self.m_teamgather_complete;
}

/*
	Name: set_teamgather_complete
	Namespace: cTeamGather
	Checksum: 0x84696FF8
	Offset: 0x1140
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function set_teamgather_complete(success)
{
	self.m_teamgather_complete = 1;
	self.m_success = success;
}

/*
	Name: teamgather_main_update
	Namespace: cTeamGather
	Checksum: 0xA39F96AF
	Offset: 0x1170
	Size: 0x1F1
	Parameters: 0
	Flags: None
*/
function teamgather_main_update()
{
	while(!is_teamgather_complete())
	{
		update_players_in_radius(0);
		if(self.m_num_players_ready == 0)
		{
			set_teamgather_complete(0);
			break;
		}
		if(self.m_num_players > 0 && self.m_num_players_ready >= self.m_num_players)
		{
			if(players_in_position(1))
			{
				set_teamgather_complete(1);
				break;
			}
		}
		else
		{
			players_in_position(0);
		}
		time_remaining = get_time_remaining();
		if(time_remaining <= 0)
		{
			set_teamgather_complete(1);
			break;
		}
		wait(0.05);
	}
	if(self.m_success == 1)
	{
		update_players_in_radius(1);
	}
	a_players = get_players_playing();
	for(i = 0; i < a_players.size; i++)
	{
		e_player = a_players[i];
		if(isdefined(e_player.in_gather_position) && e_player.in_gather_position)
		{
			e_player util::_enableWeapon();
		}
		e_player.in_gather_position = undefined;
	}
	return self.m_success;
}

/*
	Name: players_in_position
	Namespace: cTeamGather
	Checksum: 0x2F62D74E
	Offset: 0x1370
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function players_in_position(in_position)
{
	if(isdefined(in_position) && in_position)
	{
		if(!isdefined(self.in_position_start_time))
		{
			self.in_position_start_time = GetTime();
		}
		time = GetTime();
		DT = time - self.in_position_start_time / 1000;
		if(DT >= 0)
		{
			return 1;
		}
	}
	else
	{
		self.in_position_start_time = undefined;
	}
	return 0;
}

/*
	Name: update_players_in_radius
	Namespace: cTeamGather
	Checksum: 0x82001D62
	Offset: 0x1408
	Size: 0x1B5
	Parameters: 1
	Flags: None
*/
function update_players_in_radius(force_player_into_position)
{
	a_players = get_players_playing();
	self.m_num_players = a_players.size;
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i].in_gather_position = undefined;
	}
	self.m_num_players_ready = 0;
	for(i = 0; i < a_players.size; i++)
	{
		e_player = a_players[i];
		e_player.in_gather_position = is_player_in_gather_position(e_player);
		if(isdefined(force_player_into_position) && force_player_into_position && (!isdefined(e_player.in_gather_position) && e_player.in_gather_position))
		{
			teleport_player_into_position(e_player);
		}
		if(isdefined(e_player.in_gather_position) && e_player.in_gather_position)
		{
			e_player player_lowready_state(1);
			self.m_num_players_ready++;
			continue;
		}
		e_player player_lowready_state(0);
		if(e_player != self.m_e_player_leader)
		{
			team_member_zoom_button_check(e_player);
		}
	}
}

/*
	Name: is_player_in_gather_position
	Namespace: cTeamGather
	Checksum: 0x7A97BE5A
	Offset: 0x15C8
	Size: 0x1B1
	Parameters: 1
	Flags: None
*/
function is_player_in_gather_position(e_player)
{
	player_valid = 1;
	n_dist = Distance2D(e_player.origin, self.m_v_gather_position);
	if(n_dist > 210)
	{
		player_valid = 0;
	}
	else
	{
		v_start_pos = (e_player.origin[0], e_player.origin[1], e_player.origin[2] + 32);
		v_end_pos = (self.m_v_gather_position[0], self.m_v_gather_position[1], self.m_v_gather_position[2]);
		if(e_player.origin[2] - v_end_pos[2] < -64)
		{
			player_valid = 0;
		}
		v_trace = bullettrace(v_start_pos, v_end_pos, 0, undefined);
		v_trace_pos = v_trace["position"];
		dZ = Abs(v_trace_pos[2] - self.m_v_gather_position[2]);
		if(dZ > 64)
		{
			player_valid = 0;
		}
	}
	return player_valid;
}

/*
	Name: player_lowready_state
	Namespace: cTeamGather
	Checksum: 0x492EC5EA
	Offset: 0x1788
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function player_lowready_state(lower_weapon)
{
	if(lower_weapon)
	{
		if(self util::isWeaponEnabled())
		{
			self util::_disableWeapon();
		}
	}
	else if(!self util::isWeaponEnabled())
	{
		self util::_enableWeapon();
	}
}

/*
	Name: team_member_zoom_button_check
	Namespace: cTeamGather
	Checksum: 0xC6EAAD37
	Offset: 0x1808
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function team_member_zoom_button_check(e_player)
{
	if(e_player useButtonPressed())
	{
		teleport_player_into_position(e_player);
	}
}

/*
	Name: teleport_player_into_position
	Namespace: cTeamGather
	Checksum: 0xD45779A8
	Offset: 0x1850
	Size: 0x353
	Parameters: 1
	Flags: None
*/
function teleport_player_into_position(e_player)
{
	a_players = get_players_playing();
	while(1)
	{
		x_offset = RandomFloatRange(210 - 42 * -1, 210 - 42);
		y_offset = RandomFloatRange(210 - 42 * -1, 210 - 42);
		e_player.zoom_pos = (self.m_v_gather_position[0] + x_offset, self.m_v_gather_position[1] + y_offset, self.m_v_gather_position[2]);
		reject = 0;
		for(i = 0; i < a_players.size; i++)
		{
			if(e_player != a_players[i])
			{
				dist = Distance2D(e_player.origin, a_players[i].origin);
				if(dist < 84)
				{
					reject = 1;
					break;
				}
			}
		}
		if(!reject)
		{
			v_forward = AnglesToForward(self.m_v_interact_angles);
			v_dir = VectorNormalize(e_player.zoom_pos - self.m_v_interact_position);
			dp = VectorDot(v_forward, v_dir);
			if(dp > -0.5)
			{
				reject = 1;
			}
		}
		if(reject)
		{
			break;
		}
		if(!positionWouldTelefrag(e_player.zoom_pos))
		{
			break;
		}
	}
	e_player SetOrigin(e_player.zoom_pos);
	v0 = (self.m_v_interact_position[0], self.m_v_interact_position[1], self.m_v_interact_position[2]);
	v1 = (e_player.zoom_pos[0], e_player.zoom_pos[1], self.m_v_interact_position[2]);
	v_dir = VectorNormalize(v0 - v1);
	v_angles = VectorToAngles(v_dir);
	e_player SetPlayerAngles(v_angles);
}

/*
	Name: display_hud_player_leader
	Namespace: cTeamGather
	Checksum: 0x5A0C539C
	Offset: 0x1BB0
	Size: 0x2EB
	Parameters: 1
	Flags: None
*/
function display_hud_player_leader(e_player)
{
	e_player endon("disconnect");
	y_start = 180;
	x_off = 0;
	y_off = y_start;
	gather_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, &"TEAM_GATHER_TEAM_STEALTH_ENTER");
	x_off = 0;
	y_off = y_start + 100;
	ready_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, "");
	x_off = -45;
	y_off = y_start + 130;
	execute_hud_elem = e_player __create_client_hud_elem("left", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, "");
	a_time_remaining = Array("0", &"TEAM_GATHER_TIME_REMAINING_1", &"TEAM_GATHER_TIME_REMAINING_2", &"TEAM_GATHER_TIME_REMAINING_3", &"TEAM_GATHER_TIME_REMAINING_4", &"TEAM_GATHER_TIME_REMAINING_5", &"TEAM_GATHER_TIME_REMAINING_6", &"TEAM_GATHER_TIME_REMAINING_7", &"TEAM_GATHER_TIME_REMAINING_8", &"TEAM_GATHER_TIME_REMAINING_9", &"TEAM_GATHER_TIME_REMAINING_10");
	while(!is_teamgather_complete())
	{
		ready_hud_elem setText(&"TEAM_GATHER_PLAYERS_READY", self.m_num_players_ready, self.m_num_players);
		time_remaining = get_time_remaining_in_seconds();
		execute_hud_elem setText(a_time_remaining[time_remaining]);
		wait(0.05);
	}
	gather_hud_elem destroy();
	ready_hud_elem destroy();
	execute_hud_elem destroy();
}

/*
	Name: display_hud_player_team_member
	Namespace: cTeamGather
	Checksum: 0x9B300D72
	Offset: 0x1EA8
	Size: 0x423
	Parameters: 1
	Flags: None
*/
function display_hud_player_team_member(e_player)
{
	e_player endon("disconnect");
	y_start = 180;
	x_off = 0;
	y_off = y_start;
	starting_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, "");
	starting_hud_elem setText(&"TEAM_GATHER_PLAYER_STARTING_EVENT", self.m_e_player_leader);
	x_off = -118;
	y_off = y_start + 40;
	gathered_hud_elem = e_player __create_client_hud_elem("left", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, "");
	x_off = 54;
	y_off = y_start + 40;
	start_in_hud_elem = e_player __create_client_hud_elem("left", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, "");
	x_off = 0;
	y_off = y_start + 80;
	go_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, self.n_font_scale, self.v_font_color, "");
	a_start_in = Array("0", &"TEAM_GATHER_START_IN_1", &"TEAM_GATHER_START_IN_2", &"TEAM_GATHER_START_IN_3", &"TEAM_GATHER_START_IN_4", &"TEAM_GATHER_START_IN_5", &"TEAM_GATHER_START_IN_6", &"TEAM_GATHER_START_IN_7", &"TEAM_GATHER_START_IN_8", &"TEAM_GATHER_START_IN_9", &"TEAM_GATHER_START_IN_10");
	while(!is_teamgather_complete())
	{
		gathered_hud_elem setText(&"TEAM_GATHER_NUM_PLAYERS", Int(self.m_num_players_ready), Int(self.m_num_players));
		time_remaining = get_time_remaining_in_seconds();
		start_in_hud_elem setText(a_start_in[time_remaining]);
		if(isdefined(e_player.in_gather_position) && e_player.in_gather_position)
		{
			go_hud_elem setText("");
		}
		else
		{
			go_hud_elem setText(&"TEAM_GATHER_HOLD_TO_GO_NOW");
		}
		wait(0.05);
	}
	starting_hud_elem destroy();
	gathered_hud_elem destroy();
	start_in_hud_elem destroy();
	go_hud_elem destroy();
}

/*
	Name: __create_client_hud_elem
	Namespace: cTeamGather
	Checksum: 0xE2B8F3AE
	Offset: 0x22D8
	Size: 0x1AF
	Parameters: 9
	Flags: None
*/
function __create_client_hud_elem(alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontscale, color, str_text)
{
	hud_elem = newClientHudElem(self);
	hud_elem.elemType = "font";
	hud_elem.font = "objective";
	hud_elem.alignX = alignX;
	hud_elem.alignY = alignY;
	hud_elem.horzAlign = horzAlign;
	hud_elem.vertAlign = vertAlign;
	hud_elem.x = hud_elem.x + xOffset;
	hud_elem.y = hud_elem.y + yOffset;
	hud_elem.foreground = 1;
	hud_elem.fontscale = fontscale;
	hud_elem.alpha = 1;
	hud_elem.color = color;
	hud_elem.hidewheninmenu = 1;
	hud_elem setText(str_text);
	return hud_elem;
}

/*
	Name: start_player_timer
	Namespace: cTeamGather
	Checksum: 0x893D1DFF
	Offset: 0x2490
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function start_player_timer(total_time)
{
	self.e_gameobject.start_time = GetTime();
	self.e_gameobject.total_time = total_time;
}

/*
	Name: get_time_remaining
	Namespace: cTeamGather
	Checksum: 0x6028B0F7
	Offset: 0x24D0
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function get_time_remaining()
{
	time = GetTime();
	DT = time - self.e_gameobject.start_time / 1000;
	time_remaining = self.e_gameobject.total_time - DT;
	return time_remaining;
}

/*
	Name: get_time_remaining_in_seconds
	Namespace: cTeamGather
	Checksum: 0xD67C85D1
	Offset: 0x2540
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function get_time_remaining_in_seconds()
{
	time_remaining = Int(get_time_remaining());
	time_remaining = time_remaining + 1;
	if(time_remaining > 10)
	{
		time_remaining = 10;
	}
	if(time_remaining > 10)
	{
		time_remaining = 10;
	}
	else if(time_remaining < 1)
	{
		time_remaining = 1;
	}
	return time_remaining;
}

/*
	Name: get_players_playing
	Namespace: cTeamGather
	Checksum: 0xEF59DB9B
	Offset: 0x25E0
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function get_players_playing()
{
	a_players = [];
	a_all_players = GetPlayers();
	for(i = 0; i < a_all_players.size; i++)
	{
		e_player = a_all_players[i];
		if(e_player.sessionstate == "playing")
		{
			a_players[a_players.size] = e_player;
		}
	}
	return a_players;
}

#namespace teamgather;

/*
	Name: cTeamGather
	Namespace: teamgather
	Checksum: 0x1030907B
	Offset: 0x2690
	Size: 0x595
	Parameters: 0
	Flags: 6
*/
function private autoexec cTeamGather()
{
	classes.cTeamGather[0] = spawnstruct();
	classes.cTeamGather[0].__vtable[-550701329] = &cTeamGather::get_players_playing;
	classes.cTeamGather[0].__vtable[-956984352] = &cTeamGather::get_time_remaining_in_seconds;
	classes.cTeamGather[0].__vtable[652996112] = &cTeamGather::get_time_remaining;
	classes.cTeamGather[0].__vtable[-1504684133] = &cTeamGather::start_player_timer;
	classes.cTeamGather[0].__vtable[-173426075] = &cTeamGather::__create_client_hud_elem;
	classes.cTeamGather[0].__vtable[-1884502200] = &cTeamGather::display_hud_player_team_member;
	classes.cTeamGather[0].__vtable[1951511439] = &cTeamGather::display_hud_player_leader;
	classes.cTeamGather[0].__vtable[-1554327475] = &cTeamGather::teleport_player_into_position;
	classes.cTeamGather[0].__vtable[80003467] = &cTeamGather::team_member_zoom_button_check;
	classes.cTeamGather[0].__vtable[1102730064] = &cTeamGather::player_lowready_state;
	classes.cTeamGather[0].__vtable[-238569373] = &cTeamGather::is_player_in_gather_position;
	classes.cTeamGather[0].__vtable[-1601510522] = &cTeamGather::update_players_in_radius;
	classes.cTeamGather[0].__vtable[-1077574911] = &cTeamGather::players_in_position;
	classes.cTeamGather[0].__vtable[-659801253] = &cTeamGather::teamgather_main_update;
	classes.cTeamGather[0].__vtable[-1194844174] = &cTeamGather::set_teamgather_complete;
	classes.cTeamGather[0].__vtable[1311732308] = &cTeamGather::is_teamgather_complete;
	classes.cTeamGather[0].__vtable[-1760548792] = &cTeamGather::create_player_huds;
	classes.cTeamGather[0].__vtable[39285143] = &cTeamGather::gather_players;
	classes.cTeamGather[0].__vtable[-489848482] = &cTeamGather::interact_entity_highlight;
	classes.cTeamGather[0].__vtable[314254896] = &cTeamGather::cleanup_floor_effect;
	classes.cTeamGather[0].__vtable[1091200327] = &cTeamGather::spawn_floor_effect;
	classes.cTeamGather[0].__vtable[865886804] = &cTeamGather::onUseGameobject;
	classes.cTeamGather[0].__vtable[1263780804] = &cTeamGather::setup_gameobject;
	classes.cTeamGather[0].__vtable[-347726148] = &cTeamGather::teamgather_failure;
	classes.cTeamGather[0].__vtable[1811269083] = &cTeamGather::teamgather_success;
	classes.cTeamGather[0].__vtable[-1768666429] = &cTeamGather::create_teamgather_event;
	classes.cTeamGather[0].__vtable[853843291] = &cTeamGather::CleanUp;
	classes.cTeamGather[0].__vtable[1606033458] = &cTeamGather::function_5fba2032;
	classes.cTeamGather[0].__vtable[-1690805083] = &cTeamGather::function_9b385ca5;
}

/*
	Name: setup_teamgather
	Namespace: teamgather
	Checksum: 0x1E8F92BA
	Offset: 0x2C30
	Size: 0x1C3
	Parameters: 3
	Flags: None
*/
function setup_teamgather(v_interact_pos, v_interact_angles, e_interact_entity)
{
	v_forward = AnglesToForward(v_interact_angles);
	v_gather_pos = v_interact_pos + v_forward * -100;
	v_start = (v_gather_pos[0], v_gather_pos[1], v_gather_pos[2] + 20);
	v_end = (v_gather_pos[0], v_gather_pos[1], v_gather_pos[2] - 100);
	v_trace = bullettrace(v_start, v_end, 0, undefined);
	v_floor_pos = v_trace["position"];
	v_gather_pos = (v_gather_pos[0], v_gather_pos[1], v_floor_pos[2] + 10);
	function_9b385ca5();
	c_teamgather = cTeamGather;
	success = create_teamgather_event(c_teamgather, v_interact_pos, v_interact_angles, v_gather_pos);
	if(success)
	{
		e_player = c_teamgather.m_e_player_leader;
	}
	else
	{
		e_player = undefined;
	}
	CleanUp();
	return e_player;
}

/*
	Name: function_a8111e80
	Namespace: teamgather
	Checksum: 0xE9E65ECD
	Offset: 0x2E00
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_a8111e80(v1, v2)
{
	level notify("hash_62ab67ff");
	self endon("hash_62ab67ff");
	while(1)
	{
		/#
			line(v1, v2, (0, 0, 1));
		#/
		wait(0.1);
	}
}

