#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_oafc;

/*
	Name: init
	Namespace: zm_temple_sq_oafc
	Checksum: 0x5DAFF6E
	Offset: 0x4E8
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("sq", "OaFC", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "OaFC", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "OaFC", "sq_oafc_switch", &oafc_switch);
	zm_sidequests::declare_stage_asset_from_struct("sq", "OaFC", "sq_oafc_tileset1", &tileset1, &zm_sidequests::radius_trigger_thread);
	zm_sidequests::declare_stage_asset_from_struct("sq", "OaFC", "sq_oafc_tileset2", &tileset2, &zm_sidequests::radius_trigger_thread);
	level flag::init("oafc_switch_pressed");
	level flag::init("oafc_plot_vo_done");
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_oafc
	Checksum: 0x46CD9B37
	Offset: 0x678
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function stage_logic()
{
	/#
		level flag::wait_till("Dev Block strings are not supported");
		if(GetPlayers().size == 1)
		{
			wait(20);
			level notify("raise_crystal_1", 1);
			level waittill("raised_crystal_1");
			wait(5);
			IPrintLnBold("Dev Block strings are not supported");
			zm_sidequests::stage_completed("Dev Block strings are not supported", "Dev Block strings are not supported");
			return;
		}
	#/
}

/*
	Name: oafc_switch
	Namespace: zm_temple_sq_oafc
	Checksum: 0x1347CD25
	Offset: 0x728
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function oafc_switch()
{
	level endon("sq_oafc_over");
	level thread knocking_audio();
	self.on_pos = self.origin;
	self.off_pos = self.on_pos - anglesToUp(self.angles) * 5.5;
	self.trigger TriggerIgnoreTeam();
	self waittill("triggered", who);
	if(isdefined(who))
	{
		level._player_who_pressed_the_switch = who;
	}
	self playsound("evt_sq_gen_button");
	self moveto(self.off_pos, 0.25);
	self waittill("movedone");
	level flag::set("oafc_switch_pressed");
	level thread oafc_story_vox();
}

/*
	Name: knocking_audio
	Namespace: zm_temple_sq_oafc
	Checksum: 0x7115CB3A
	Offset: 0x870
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function knocking_audio()
{
	level endon("sq_oafc_over");
	struct = struct::get("sq_location_oafc", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	while(!level flag::get("oafc_switch_pressed"))
	{
		playsoundatposition("evt_sq_oafc_knock", struct.origin);
		wait(RandomFloatRange(1.5, 4));
	}
}

/*
	Name: tileset1
	Namespace: zm_temple_sq_oafc
	Checksum: 0x1010D11
	Offset: 0x928
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function tileset1()
{
	self.set = 1;
	self.original_origin = self.origin;
}

/*
	Name: tileset2
	Namespace: zm_temple_sq_oafc
	Checksum: 0x78682D73
	Offset: 0x950
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function tileset2()
{
	self.set = 2;
	self.original_origin = self.origin;
}

/*
	Name: tile_cheat
	Namespace: zm_temple_sq_oafc
	Checksum: 0xCB70CDA8
	Offset: 0x978
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function tile_cheat()
{
	/#
		level endon("reset_tiles");
		level endon("sq_oafc_over");
		while(isdefined(self.matched) && !self.matched)
		{
			print3d(self.origin, self.Tile, VectorScale((0, 1, 0), 255));
			wait(0.1);
		}
	#/
}

/*
	Name: tile_debug
	Namespace: zm_temple_sq_oafc
	Checksum: 0x9B45C8D8
	Offset: 0x9F0
	Size: 0x7BF
	Parameters: 0
	Flags: None
*/
function tile_debug()
{
	/#
		level endon("sq_oafc_over");
		if(!isdefined(level._debug_tiles))
		{
			level._debug_tiles = 1;
			level.selected_tile1 = NewDebugHudElem();
			level.selected_tile1.location = 0;
			level.selected_tile1.alignX = "Dev Block strings are not supported";
			level.selected_tile1.alignY = "Dev Block strings are not supported";
			level.selected_tile1.foreground = 1;
			level.selected_tile1.fontscale = 1.3;
			level.selected_tile1.sort = 20;
			level.selected_tile1.x = 10;
			level.selected_tile1.y = 240;
			level.selected_tile1.og_scale = 1;
			level.selected_tile1.color = VectorScale((1, 1, 1), 255);
			level.selected_tile1.alpha = 1;
			level.selected_tile1_text = NewDebugHudElem();
			level.selected_tile1_text.location = 0;
			level.selected_tile1_text.alignX = "Dev Block strings are not supported";
			level.selected_tile1_text.alignY = "Dev Block strings are not supported";
			level.selected_tile1_text.foreground = 1;
			level.selected_tile1_text.fontscale = 1.3;
			level.selected_tile1_text.sort = 20;
			level.selected_tile1_text.x = 0;
			level.selected_tile1_text.y = 240;
			level.selected_tile1_text.og_scale = 1;
			level.selected_tile1_text.color = VectorScale((1, 1, 1), 255);
			level.selected_tile1_text.alpha = 1;
			level.selected_tile1_text setText("Dev Block strings are not supported");
			level.selected_tile2 = NewDebugHudElem();
			level.selected_tile2.location = 0;
			level.selected_tile2.alignX = "Dev Block strings are not supported";
			level.selected_tile2.alignY = "Dev Block strings are not supported";
			level.selected_tile2.foreground = 1;
			level.selected_tile2.fontscale = 1.3;
			level.selected_tile2.sort = 20;
			level.selected_tile2.x = 10;
			level.selected_tile2.y = 270;
			level.selected_tile2.og_scale = 1;
			level.selected_tile2.color = VectorScale((1, 1, 1), 255);
			level.selected_tile2.alpha = 1;
			level.selected_tile2_text = NewDebugHudElem();
			level.selected_tile2_text.location = 0;
			level.selected_tile2_text.alignX = "Dev Block strings are not supported";
			level.selected_tile2_text.alignY = "Dev Block strings are not supported";
			level.selected_tile2_text.foreground = 1;
			level.selected_tile2_text.fontscale = 1.3;
			level.selected_tile2_text.sort = 20;
			level.selected_tile2_text.x = 0;
			level.selected_tile2_text.y = 270;
			level.selected_tile2_text.og_scale = 1;
			level.selected_tile2_text.color = VectorScale((1, 1, 1), 255);
			level.selected_tile2_text.alpha = 1;
			level.selected_tile2_text setText("Dev Block strings are not supported");
			level.num_matched = NewDebugHudElem();
			level.num_matched.location = 0;
			level.num_matched.alignX = "Dev Block strings are not supported";
			level.num_matched.alignY = "Dev Block strings are not supported";
			level.num_matched.foreground = 1;
			level.num_matched.fontscale = 1.3;
			level.num_matched.sort = 20;
			level.num_matched.x = 10;
			level.num_matched.y = 300;
			level.num_matched.og_scale = 1;
			level.num_matched.color = VectorScale((1, 1, 1), 255);
			level.num_matched.alpha = 1;
			level.num_matched_text = NewDebugHudElem();
			level.num_matched_text.location = 0;
			level.num_matched_text.alignX = "Dev Block strings are not supported";
			level.num_matched_text.alignY = "Dev Block strings are not supported";
			level.num_matched_text.foreground = 1;
			level.num_matched_text.fontscale = 1.3;
			level.num_matched_text.sort = 20;
			level.num_matched_text.x = 0;
			level.num_matched_text.y = 300;
			level.num_matched_text.og_scale = 1;
			level.num_matched_text.color = VectorScale((1, 1, 1), 255);
			level.num_matched_text.alpha = 1;
			level.num_matched_text setText("Dev Block strings are not supported");
		}
		while(1)
		{
			if(isdefined(level._picked_tile1))
			{
				level.selected_tile1 setText(level._picked_tile1.Tile);
			}
			else
			{
				level.selected_tile1 setText("Dev Block strings are not supported");
			}
			if(isdefined(level._picked_tile2))
			{
				level.selected_tile2 setText(level._picked_tile2.Tile);
			}
			else
			{
				level.selected_tile2 setText("Dev Block strings are not supported");
			}
			if(isdefined(level._num_matched_tiles))
			{
				level.num_matched setText(level._num_matched_tiles);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: tile_monitor
	Namespace: zm_temple_sq_oafc
	Checksum: 0x86A88A22
	Offset: 0x11B8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function tile_monitor()
{
	level endon("sq_oafc_over");
	self endon("tiles_picked");
	level endon("reset_tiles");
	self.origin = self.original_origin;
	/#
		self thread tile_cheat();
	#/
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_oafc
	Checksum: 0xC4BAB787
	Offset: 0x1218
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init_stage()
{
	/#
		level thread tile_debug();
	#/
	level flag::clear("oafc_switch_pressed");
	level flag::clear("oafc_plot_vo_done");
	reset_tiles();
	zm_temple_sq_brock::delete_radio();
	level thread delayed_start_skit();
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_oafc
	Checksum: 0xAA203D4C
	Offset: 0x12B8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function delayed_start_skit()
{
	wait(0.5);
	level thread zm_temple_sq_skits::start_skit("tt1");
}

/*
	Name: tile_moves_up
	Namespace: zm_temple_sq_oafc
	Checksum: 0x3A581C66
	Offset: 0x12F0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function tile_moves_up(delay)
{
	level endon("sq_oafc_over");
	level flag::wait_till("oafc_switch_pressed");
	for(i = 0; i < delay; i++)
	{
		util::wait_network_frame();
	}
	self moveto(self.original_origin, 0.25);
}

/*
	Name: set_tile_models
	Namespace: zm_temple_sq_oafc
	Checksum: 0xAC4E7C54
	Offset: 0x1390
	Size: 0xFD
	Parameters: 2
	Flags: None
*/
function set_tile_models(tiles, models)
{
	for(i = 0; i < tiles.size; i++)
	{
		tiles[i] SetModel("p7_zm_sha_glyph_stone_blank");
		tiles[i].Tile = models[i];
		tiles[i].matched = 0;
		tiles[i].origin = tiles[i].original_origin - VectorScale((0, 0, 1), 24);
		tiles[i] thread tile_moves_up(i % 4);
	}
}

/*
	Name: player_in_trigger
	Namespace: zm_temple_sq_oafc
	Checksum: 0xE4E3CF9D
	Offset: 0x1498
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function player_in_trigger()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i].sessionstate != "spectator" && self istouching(players[i]))
		{
			return players[i];
		}
	}
	return undefined;
}

/*
	Name: draw_matching_tile_marker
	Namespace: zm_temple_sq_oafc
	Checksum: 0x5690E6C5
	Offset: 0x1538
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function draw_matching_tile_marker(Tile)
{
	level endon("kill_matching_tile_debug");
	other_tiles = [];
	if(Tile.targetname == "sq_oafc_tileset1")
	{
		other_tiles = GetEntArray("sq_oafc_tileset2", "targetname");
		level notify("kill_matching_tile_debug1");
		level endon("kill_matching_tile_debug1");
	}
	else
	{
		other_tiles = GetEntArray("sq_oafc_tileset1", "targetname");
		level notify("kill_matching_tile_debug2");
		level endon("kill_matching_tile_debug2");
	}
	matching_tile = undefined;
	foreach(other_tile in other_tiles)
	{
		if(Tile.Tile == other_tile.Tile)
		{
			matching_tile = other_tile;
		}
	}
	while(isdefined(matching_tile))
	{
		/#
			print3d(matching_tile.origin + VectorScale((0, 0, 1), 32), "Dev Block strings are not supported", VectorScale((1, 0, 0), 255), 1);
		#/
		util::wait_network_frame();
	}
}

/*
	Name: oafc_trigger_thread
	Namespace: zm_temple_sq_oafc
	Checksum: 0x233CB61
	Offset: 0x1710
	Size: 0x84B
	Parameters: 2
	Flags: None
*/
function oafc_trigger_thread(tiles, set)
{
	self endon("death");
	level endon("reset_tiles");
	self TriggerEnable(0);
	level flag::wait_till("oafc_switch_pressed");
	self TriggerEnable(1);
	while(1)
	{
		for(i = 0; i < tiles.size; i++)
		{
			Tile = tiles[i];
			if(isdefined(Tile) && !Tile.matched)
			{
				self.origin = tiles[i].origin;
				touched_player = self player_in_trigger();
				if(isdefined(touched_player))
				{
					/#
						if(set == 1)
						{
							println("Dev Block strings are not supported" + i);
						}
					#/
					Tile SetModel(Tile.Tile);
					Tile playsound("evt_sq_oafc_glyph_activate");
					/#
						level thread draw_matching_tile_marker(Tile);
					#/
					matched = 0;
					if(set == 1)
					{
						level._picked_tile1 = Tile;
						continue;
					}
					level._picked_tile2 = Tile;
					while(isdefined(touched_player) && self istouching(touched_player) && touched_player.sessionstate != "spectator" && !Tile.matched)
					{
						self.touched_player = touched_player;
						if(set == 1)
						{
							if(isdefined(level._picked_tile1) && isdefined(level._picked_tile2))
							{
								if(level._picked_tile1.Tile == level._picked_tile2.Tile)
								{
									level._picked_tile1 playsound("evt_sq_oafc_glyph_correct");
									level._picked_tile2 playsound("evt_sq_oafc_glyph_correct");
									/#
										level notify("kill_matching_tile_debug");
									#/
									matched = 1;
									level._picked_tile1.matched = 1;
									level._picked_tile2.matched = 1;
									level._picked_tile1 moveto(level._picked_tile1.origin - VectorScale((0, 0, 1), 24), 0.5);
									level._picked_tile2 moveto(level._picked_tile2.origin - VectorScale((0, 0, 1), 24), 0.5);
									level._picked_tile1 waittill("movedone");
									level._picked_tile1 = undefined;
									level._picked_tile2 = undefined;
									level._num_matched_tiles++;
									if(level._num_matched_tiles < level._num_tiles_to_match)
									{
										rand = randomIntRange(0, 2);
										if(isdefined(touched_player) && rand == 0)
										{
											touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomIntRange(5, 8));
										}
										else if(isdefined(level._oafc_trigger2.touched_player))
										{
											level._oafc_trigger2.touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomIntRange(5, 8));
										}
									}
									if(level._num_matched_tiles == level._num_tiles_to_match)
									{
										/#
											println("Dev Block strings are not supported");
										#/
										struct = struct::get("sq_location_oafc", "targetname");
										if(isdefined(struct))
										{
											playsoundatposition("evt_sq_oafc_glyph_complete", struct.origin);
											playsoundatposition("evt_sq_oafc_kachunk", struct.origin);
										}
										level notify("suspend_timer");
										level notify("raise_crystal_1", 1);
										level waittill("raised_crystal_1");
										level flag::wait_till("oafc_plot_vo_done");
										wait(5);
										zm_sidequests::stage_completed("sq", "OaFC");
										return;
									}
									/#
										println("Dev Block strings are not supported");
									#/
									break;
								}
								else
								{
									level._picked_tile1 playsound("evt_sq_oafc_glyph_wrong");
									level._picked_tile2 playsound("evt_sq_oafc_glyph_wrong");
									rand = randomIntRange(0, 2);
									if(isdefined(touched_player) && rand == 0)
									{
										touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomIntRange(2, 5));
										continue;
									}
									if(isdefined(level._oafc_trigger2.touched_player))
									{
										level._oafc_trigger2.touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomIntRange(2, 5));
									}
									while(isdefined(touched_player) && self istouching(touched_player) && isdefined(level._picked_tile2))
									{
										wait(0.05);
									}
									/#
										println("Dev Block strings are not supported");
									#/
									level thread reset_tiles();
									break;
								}
							}
						}
						wait(0.05);
					}
					Tile playsound("evt_sq_oafc_glyph_clear");
					if(set == 1)
					{
						level._picked_tile1 = undefined;
					}
					else
					{
						level._picked_tile2 = undefined;
					}
					Tile SetModel("p7_zm_sha_glyph_stone_blank");
				}
			}
		}
		wait(0.05);
	}
	/#
		if(set == 1)
		{
			println("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: reset_tiles
	Namespace: zm_temple_sq_oafc
	Checksum: 0xB1227B31
	Offset: 0x1F68
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function reset_tiles()
{
	tile_models = Array("p7_zm_sha_glyph_stone_01", "p7_zm_sha_glyph_stone_02", "p7_zm_sha_glyph_stone_03", "p7_zm_sha_glyph_stone_04", "p7_zm_sha_glyph_stone_05", "p7_zm_sha_glyph_stone_06", "p7_zm_sha_glyph_stone_07", "p7_zm_sha_glyph_stone_08", "p7_zm_sha_glyph_stone_09", "p7_zm_sha_glyph_stone_10", "p7_zm_sha_glyph_stone_11", "p7_zm_sha_glyph_stone_12");
	level notify("reset_tiles");
	if(!isdefined(level._oafc_trigger1))
	{
		level._oafc_trigger1 = spawn("trigger_radius", (0, 0, 0), 0, 22, 72);
		level._oafc_trigger2 = spawn("trigger_radius", (0, 0, 0), 0, 22, 72);
		level._oafc_trigger1 thread wait_for_first_stepon();
		level._oafc_trigger2 thread wait_for_first_stepon();
	}
	level._num_matched_tiles = 0;
	level._picked_tile1 = undefined;
	level._picked_tile2 = undefined;
	tile_models = Array::randomize(tile_models);
	tileset1 = GetEntArray("sq_oafc_tileset1", "targetname");
	level._num_tiles_to_match = tileset1.size;
	set_tile_models(tileset1, tile_models);
	level._oafc_trigger1 thread oafc_trigger_thread(tileset1, 1);
	tile_models = Array::randomize(tile_models);
	tileset2 = GetEntArray("sq_oafc_tileset2", "targetname");
	set_tile_models(tileset2, tile_models);
	level._oafc_trigger2 thread oafc_trigger_thread(tileset2, 2);
}

/*
	Name: wait_for_first_stepon
	Namespace: zm_temple_sq_oafc
	Checksum: 0xF4B864DF
	Offset: 0x21E0
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function wait_for_first_stepon()
{
	self endon("death");
	level endon("quest1_glyph_line_said");
	while(1)
	{
		self waittill("trigger", who);
		if(isdefined(who) && isPlayer(who))
		{
			who thread zm_audio::create_and_play_dialog("eggs", "quest1", 1);
			break;
		}
	}
	level notify("quest1_glyph_line_said");
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_oafc
	Checksum: 0x8B4CDB49
	Offset: 0x2288
	Size: 0x1AF
	Parameters: 1
	Flags: None
*/
function exit_stage(success)
{
	if(isdefined(level._debug_tiles))
	{
		level._debug_tiles = undefined;
		level.selected_tile1 destroy();
		level.selected_tile1 = undefined;
		level.selected_tile1_text destroy();
		level.selected_tile1_text = undefined;
		level.selected_tile2 destroy();
		level.selected_tile2 = undefined;
		level.selected_tile2_text destroy();
		level.selected_tile2_text = undefined;
		level.num_matched destroy();
		level.num_matched.location = undefined;
		level.num_matched_text destroy();
		level.num_matched_text = undefined;
	}
	if(success)
	{
		zm_temple_sq_brock::create_radio(2, &zm_temple_sq_brock::radio2_override);
	}
	else
	{
		zm_temple_sq_brock::create_radio(1);
		level thread zm_temple_sq_skits::fail_skit(1);
	}
	level._oafc_trigger1 delete();
	level._oafc_trigger2 delete();
	if(isdefined(level._oafc_sound_ent))
	{
		level._oafc_sound_ent delete();
		level._oafc_sound_ent = undefined;
	}
	level.skit_vox_override = 0;
}

/*
	Name: oafc_story_vox
	Namespace: zm_temple_sq_oafc
	Checksum: 0x49C4E88A
	Offset: 0x2440
	Size: 0x365
	Parameters: 0
	Flags: None
*/
function oafc_story_vox()
{
	level endon("sq_oafc_over");
	struct = struct::get("sq_location_oafc", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._oafc_sound_ent = spawn("script_origin", struct.origin);
	level._oafc_sound_ent PlaySoundWithNotify("vox_egg_story_1_0", "sounddone");
	level._oafc_sound_ent waittill("sounddone");
	if(isdefined(level._player_who_pressed_the_switch))
	{
		who = level._player_who_pressed_the_switch;
		level.skit_vox_override = 1;
		who PlaySoundWithNotify("vox_egg_story_1_1" + zm_temple_sq::function_26186755(who.characterindex), "vox_egg_sounddone");
		who waittill("vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level._oafc_sound_ent PlaySoundWithNotify("vox_egg_story_1_2", "sounddone");
	level._oafc_sound_ent waittill("sounddone");
	while(level._num_matched_tiles < 1)
	{
		wait(0.1);
	}
	level._oafc_sound_ent PlaySoundWithNotify("vox_egg_story_1_3", "sounddone");
	level._oafc_sound_ent waittill("sounddone");
	while(level._num_matched_tiles != level._num_tiles_to_match)
	{
		wait(0.1);
	}
	level._oafc_sound_ent PlaySoundWithNotify("vox_egg_story_1_4", "sounddone");
	level._oafc_sound_ent waittill("sounddone");
	if(isdefined(level._player_who_pressed_the_switch))
	{
		who = level._player_who_pressed_the_switch;
		level.skit_vox_override = 1;
		who PlaySoundWithNotify("vox_egg_story_1_5" + zm_temple_sq::function_26186755(who.characterindex), "vox_egg_sounddone");
		who waittill("vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level._oafc_sound_ent PlaySoundWithNotify("vox_egg_story_1_6", "sounddone");
	level._oafc_sound_ent waittill("sounddone");
	level._oafc_sound_ent PlaySoundWithNotify("vox_egg_story_1_7", "sounddone");
	level._oafc_sound_ent waittill("sounddone");
	level flag::set("oafc_plot_vo_done");
	level._oafc_sound_ent delete();
	level._oafc_sound_ent = undefined;
}

