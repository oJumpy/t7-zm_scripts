#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace namespace_8847920b;

/*
	Name: __init__sytem__
	Namespace: namespace_8847920b
	Checksum: 0xBB6D6FBD
	Offset: 0x380
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_theater_teleporter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8847920b
	Checksum: 0xCEECF62E
	Offset: 0x3C0
	Size: 0x1DB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_theater_teleport", 21000, 1, "pstfx_zm_kino_teleport");
	clientfield::register("scriptmover", "extra_screen", 21000, 1, "int", &function_667aa0b4, 0, 0);
	clientfield::register("scriptmover", "teleporter_fx", 21000, 1, "counter", &function_a8255fab, 0, 0);
	clientfield::register("allplayers", "player_teleport_fx", 21000, 1, "counter", &function_2b23adc9, 0, 0);
	clientfield::register("scriptmover", "play_fly_me_to_the_moon_fx", 21000, 1, "int", &function_14c9b6d3, 0, 0);
	clientfield::register("world", "teleporter_initiate_fx", 21000, 1, "counter", &function_6776dea9, 0, 0);
	clientfield::register("scriptmover", "teleporter_link_cable_mtl", 21000, 1, "int", &function_2ae4e56, 0, 0);
}

/*
	Name: main
	Namespace: namespace_8847920b
	Checksum: 0x5F4CCEEC
	Offset: 0x5A8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread setup_teleporter_screen();
	level thread pack_clock_init();
}

/*
	Name: setup_teleporter_screen
	Namespace: namespace_8847920b
	Checksum: 0x463B6E93
	Offset: 0x5E8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function setup_teleporter_screen()
{
	level waittill("power_on");
	for(i = 0; i < level.localPlayers.size; i++)
	{
		level.extraCamActive[i] = 0;
	}
}

/*
	Name: pack_clock_init
	Namespace: namespace_8847920b
	Checksum: 0x56EF38D0
	Offset: 0x640
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function pack_clock_init()
{
	level waittill("pack_clock_start", clientNum);
	curr_time = GetSystemTime();
	hours = curr_time[0];
	if(hours > 12)
	{
		hours = hours - 12;
	}
	if(hours == 0)
	{
		hours = 12;
	}
	minutes = curr_time[1];
	seconds = curr_time[2];
	hour_hand = GetEnt(clientNum, "zom_clock_hour_hand", "targetname");
	hour_values = [];
	hour_values["hand_time"] = hours;
	hour_values["rotate"] = 30;
	hour_values["rotate_bit"] = 0.008333334;
	hour_values["first_rotate"] = minutes * 60 + seconds * hour_values["rotate_bit"];
	minute_hand = GetEnt(clientNum, "zom_clock_minute_hand", "targetname");
	minute_values = [];
	minute_values["hand_time"] = minutes;
	minute_values["rotate"] = 6;
	minute_values["rotate_bit"] = 0.1;
	minute_values["first_rotate"] = seconds * minute_values["rotate_bit"];
	if(isdefined(hour_hand))
	{
		hour_hand thread pack_clock_run(hour_values);
	}
	if(isdefined(minute_hand))
	{
		minute_hand thread pack_clock_run(minute_values);
	}
}

/*
	Name: pack_clock_run
	Namespace: namespace_8847920b
	Checksum: 0x9ECD1A5B
	Offset: 0x898
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function pack_clock_run(time_values)
{
	self endon("entityshutdown");
	self RotatePitch(time_values["hand_time"] * time_values["rotate"] * -1, 0.05);
	self waittill("rotatedone");
	if(isdefined(time_values["first_rotate"]))
	{
		self RotatePitch(time_values["first_rotate"] * -1, 0.05);
		self waittill("rotatedone");
	}
	prev_time = GetSystemTime();
	while(1)
	{
		curr_time = GetSystemTime();
		if(prev_time != curr_time)
		{
			self RotatePitch(time_values["rotate_bit"] * -1, 0.05);
			prev_time = curr_time;
		}
		wait(1);
	}
}

/*
	Name: function_667aa0b4
	Namespace: namespace_8847920b
	Checksum: 0x24325F55
	Offset: 0x9F0
	Size: 0x2E1
	Parameters: 7
	Flags: None
*/
function function_667aa0b4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level.cameraEnt = GetEnt(localClientNum, "theater_extracam_eye", "targetname");
		level.cam_corona = util::spawn_model(localClientNum, "tag_origin", level.cameraEnt.origin, level.cameraEnt.angles);
		level.cam_corona.var_e39fd443 = PlayFXOnTag(localClientNum, level._effect["fx_mp_light_lamp"], level.cam_corona, "tag_origin");
		if(level.extraCamActive[localClientNum] == 0 && level.localPlayers.size < 3)
		{
			if(isdefined(level.var_3cb13a71[localClientNum]))
			{
				KillFX(localClientNum, level.var_3cb13a71[localClientNum]);
			}
			level.extraCamActive[localClientNum] = 1;
			level.cameraEnt SetExtraCam(0, 320, 240);
		}
	}
	else if(isdefined(level.cam_corona))
	{
		stopfx(localClientNum, level.cam_corona.var_e39fd443);
		level.cam_corona delete();
	}
	if(level.extraCamActive[localClientNum] == 1 && isdefined(level.cameraEnt))
	{
		level.extraCamActive[localClientNum] = 0;
		level.cameraEnt ClearExtraCam();
		var_78113405 = struct::get("struct_theater_projector_beam", "targetname");
		if(isdefined(level.var_3cb13a71[localClientNum]) && isdefined(var_78113405.vid[localClientNum]))
		{
			level.var_3cb13a71[localClientNum] = PlayFXOnTag(localClientNum, level._effect[level.var_bcdc3660[localClientNum]], var_78113405.vid[localClientNum], "tag_origin");
		}
	}
}

/*
	Name: function_a8255fab
	Namespace: namespace_8847920b
	Checksum: 0x385109B8
	Offset: 0xCE0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_a8255fab(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		n_fx_id = PlayFXOnTag(localClientNum, level._effect["teleport_player_kino"], self, "tag_fx_wormhole");
		SetFXIgnorePause(localClientNum, n_fx_id, 1);
		var_3d144b40 = PlayFXOnTag(localClientNum, level._effect["teleport_player_kino_cover"], self, "tag_fx_wormhole");
		SetFXIgnorePause(localClientNum, var_3d144b40, 1);
	}
}

/*
	Name: function_2b23adc9
	Namespace: namespace_8847920b
	Checksum: 0x503EDEEF
	Offset: 0xDE8
	Size: 0x139
	Parameters: 7
	Flags: None
*/
function function_2b23adc9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	a_e_players = GetLocalPlayers();
	foreach(e_player in a_e_players)
	{
		e_player.var_5c4ad807 = PlayFXOnTag(e_player.localClientNum, level._effect["teleport_player_flash"], self, "j_spinelower");
		SetFXIgnorePause(e_player.localClientNum, e_player.var_5c4ad807, 1);
	}
}

/*
	Name: function_6776dea9
	Namespace: namespace_8847920b
	Checksum: 0x98CFCE89
	Offset: 0xF30
	Size: 0x279
	Parameters: 7
	Flags: None
*/
function function_6776dea9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_33e4acb6 = (-306.684, 1116.25, 117.056);
	var_a1844610 = (0, 0, 0);
	v_origin = (-306.75, 1116.25, 0.0660095);
	v_angles = VectorScale((1, 0, 0), 270);
	a_e_players = GetLocalPlayers();
	foreach(e_player in a_e_players)
	{
		e_player.var_a0a2d27 = playFX(e_player.localClientNum, level._effect["teleport_initiate"], v_origin, AnglesToForward(v_angles), anglesToUp(v_angles));
		SetFXIgnorePause(e_player.localClientNum, e_player.var_a0a2d27, 1);
		e_player.var_d4770e93 = playFX(e_player.localClientNum, level._effect["teleport_initiate_top"], var_33e4acb6, AnglesToForward(var_a1844610), anglesToUp(var_a1844610));
		SetFXIgnorePause(e_player.localClientNum, e_player.var_d4770e93, 1);
	}
}

/*
	Name: function_14c9b6d3
	Namespace: namespace_8847920b
	Checksum: 0x3FD1E314
	Offset: 0x11B8
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function function_14c9b6d3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.fx_spot = util::spawn_model(localClientNum, "tag_origin", self.origin + VectorScale((0, 0, -1), 19), VectorScale((1, 0, 0), 90));
		self.fx_spot LinkTo(self);
		n_fx_id = PlayFXOnTag(localClientNum, level._effect["fx_mp_pipe_steam"], self.fx_spot, "tag_origin");
		SetFXIgnorePause(localClientNum, n_fx_id, 1);
	}
	else if(isdefined(self) && isdefined(self.fx_spot))
	{
		deletefx(localClientNum, level._effect["fx_mp_pipe_steam"]);
		self.fx_spot Unlink();
		self.fx_spot delete();
	}
}

/*
	Name: function_2ae4e56
	Namespace: namespace_8847920b
	Checksum: 0x70A23F31
	Offset: 0x1338
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_2ae4e56(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 0, 0, 0);
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

