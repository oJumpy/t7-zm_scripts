#using scripts\codescripts\struct;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_ptt;

/*
	Name: init
	Namespace: zm_temple_sq_ptt
	Checksum: 0x955F1B6
	Offset: 0x410
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function init()
{
	flag::init("sq_ptt_dial_dialed");
	flag::init("sq_ptt_level_pulled");
	flag::init("ptt_plot_vo_done");
	zm_sidequests::declare_sidequest_stage("sq", "PtT", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "PtT", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "PtT", "sq_ptt_trig", &gas_volume, &napalm_trigger_thread);
}

/*
	Name: debug_jet
	Namespace: zm_temple_sq_ptt
	Checksum: 0x5778C9BD
	Offset: 0x528
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function debug_jet()
{
	/#
		self endon("death");
		struct = struct::get(self.target, "Dev Block strings are not supported");
		dir = AnglesToForward(struct.angles);
		while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
		{
			scale = 0.1;
			offset = (0, 0, 0);
			for(i = 0; i < 5; i++)
			{
				print3d(struct.origin + offset, "Dev Block strings are not supported", self.jet_color, 1, scale, 10);
				scale = scale * 1.7;
				offset = offset + dir * 6;
			}
			wait(1);
		}
	#/
}

/*
	Name: ignite_jet
	Namespace: zm_temple_sq_ptt
	Checksum: 0x5AE3AB01
	Offset: 0x670
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function ignite_jet()
{
	level endon("end_game");
	self playsound("evt_sq_ptt_gas_ignite");
	str_exploder = "fxexp_" + self.script_int + 10;
	exploder::exploder(str_exploder);
	level waittill("sq_PtT_over");
	exploder::stop_exploder(str_exploder);
}

/*
	Name: gas_volume
	Namespace: zm_temple_sq_ptt
	Checksum: 0x211ABEAA
	Offset: 0x700
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function gas_volume()
{
	self endon("death");
	self.jet_color = VectorScale((0, 1, 0), 255);
	level flag::wait_till("sq_ptt_dial_dialed");
	exploder::exploder("fxexp_" + self.script_int);
	while(1)
	{
		level waittill("napalm_death", volume);
		if(volume == self.script_int)
		{
			self.trigger notify("lit");
			level notify("lit");
			self thread ignite_jet();
			self thread play_line_on_nearby_player();
			level._ptt_num_lit++;
			return;
		}
	}
}

/*
	Name: play_line_on_nearby_player
	Namespace: zm_temple_sq_ptt
	Checksum: 0xCFE1FC44
	Offset: 0x808
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function play_line_on_nearby_player()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(DistanceSquared(self.origin, players[i].origin) <= 62500)
		{
			players[i] thread zm_audio::create_and_play_dialog("eggs", "quest4", randomIntRange(2, 5));
			return;
		}
	}
}

/*
	Name: napalm_trigger_think
	Namespace: zm_temple_sq_ptt
	Checksum: 0x5F3B54DA
	Offset: 0x8D8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function napalm_trigger_think()
{
	self endon("death");
	self TriggerIgnoreTeam();
	while(1)
	{
		while(level.active_napalm_zombies.size == 0)
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported") == 2)
				{
					wait(self.owner_ent.script_int - 99 * 2);
					self notify("napalmed");
				}
			#/
			wait(1);
		}
		while(level.active_napalm_zombies.size > 0)
		{
			foreach(zombie in level.active_napalm_zombies)
			{
				if(zombie istouching(self))
				{
					self notify("napalmed");
				}
			}
			util::wait_network_frame();
		}
	}
}

/*
	Name: napalm_trigger_thread
	Namespace: zm_temple_sq_ptt
	Checksum: 0x46903DF9
	Offset: 0xA40
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function napalm_trigger_thread()
{
	self endon("death");
	self endon("lit");
	level flag::wait_till("sq_ptt_dial_dialed");
	self thread player_line_thread();
	self thread napalm_trigger_think();
	while(1)
	{
		self waittill("napalmed");
		level notify("napalm_death", self.owner_ent.script_int);
		return;
	}
}

/*
	Name: player_line_thread
	Namespace: zm_temple_sq_ptt
	Checksum: 0xF05EC056
	Offset: 0xAE8
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function player_line_thread()
{
	self endon("death");
	self endon("lit");
	while(1)
	{
		self waittill("trigger", who);
		if(isPlayer(who))
		{
			who thread zm_audio::create_and_play_dialog("eggs", "quest4", randomIntRange(0, 2));
			return;
		}
	}
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_ptt
	Checksum: 0x925EB882
	Offset: 0xB90
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function init_stage()
{
	level notify("ptt_start");
	level flag::clear("sq_ptt_dial_dialed");
	dial = GetEnt("sq_ptt_dial", "targetname");
	dial thread ptt_dial();
	jets = GetEntArray("sq_ptt_trig", "targetname");
	level._ptt_jets = jets.size;
	level._ptt_num_lit = 0;
	zm_temple_sq_brock::delete_radio();
	if(level flag::get("radio_4_played"))
	{
		level thread delayed_start_skit("tt4a");
	}
	else
	{
		level thread delayed_start_skit("tt4b");
	}
	level thread play_choking_loop();
}

/*
	Name: play_choking_loop
	Namespace: zm_temple_sq_ptt
	Checksum: 0x2BE55A09
	Offset: 0xCD8
	Size: 0x105
	Parameters: 0
	Flags: None
*/
function play_choking_loop()
{
	level endon("sq_PtT_over");
	struct = struct::get("sq_location_ptt", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._ptt_sound_choking_ent = spawn("script_origin", struct.origin);
	level._ptt_sound_choking_ent PlayLoopSound("evt_sq_ptt_choking_loop", 2);
	level flag::wait_till("sq_ptt_dial_dialed");
	level._ptt_sound_choking_ent StopLoopSound(1);
	wait(1);
	level._ptt_sound_choking_ent delete();
	level._ptt_sound_choking_ent = undefined;
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_ptt
	Checksum: 0xCC1251A5
	Offset: 0xDE8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function delayed_start_skit(skit)
{
	level thread zm_temple_sq_skits::start_skit(skit);
}

/*
	Name: ptt_lever
	Namespace: zm_temple_sq_ptt
	Checksum: 0xC8F3653
	Offset: 0xE18
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function ptt_lever()
{
	level endon("sq_PtT_over");
	level flag::clear("sq_ptt_level_pulled");
	if(!isdefined(self.original_angles))
	{
		self.original_angles = self.angles;
	}
	self.angles = self.original_angles;
	while(level._ptt_num_lit < level._ptt_jets)
	{
		level waittill("lit");
		self playsound("evt_sq_ptt_lever_ratchet");
		self RotateRoll(-25, 0.25);
		self waittill("rotatedone");
	}
	use_trigger = spawn("trigger_radius_use", self.origin, 0, 32, 72);
	use_trigger TriggerIgnoreTeam();
	use_trigger setcursorhint("HINT_NOICON");
	use_trigger waittill("trigger");
	use_trigger delete();
	self playsound("evt_sq_ptt_lever_pull");
	self RotateRoll(100, 0.25);
	self waittill("rotatedone");
	level flag::set("sq_ptt_level_pulled");
}

/*
	Name: ptt_story_vox
	Namespace: zm_temple_sq_ptt
	Checksum: 0x4B6553CA
	Offset: 0xFE0
	Size: 0x355
	Parameters: 1
	Flags: None
*/
function ptt_story_vox(player)
{
	level endon("sq_PtT_over");
	struct = struct::get("sq_location_ptt", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._ptt_sound_ent = spawn("script_origin", struct.origin);
	level._ptt_sound_ent_trash = spawn("script_origin", struct.origin);
	level._ptt_sound_ent PlaySoundWithNotify("vox_egg_story_3_0", "sounddone");
	level._ptt_sound_ent waittill("sounddone");
	level._ptt_sound_ent_trash playsound("evt_sq_ptt_trash_start");
	level._ptt_sound_ent_trash PlayLoopSound("evt_sq_ptt_trash_loop");
	level._ptt_sound_ent PlaySoundWithNotify("vox_egg_story_3_1", "sounddone");
	level._ptt_sound_ent waittill("sounddone");
	level._ptt_sound_ent PlaySoundWithNotify("vox_egg_story_3_2", "sounddone");
	level._ptt_sound_ent waittill("sounddone");
	if(isdefined(player))
	{
		level.skit_vox_override = 1;
		player PlaySoundWithNotify("vox_egg_story_3_3" + zm_temple_sq::function_26186755(player.characterindex), "vox_egg_sounddone");
		player waittill("vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level thread ptt_story_reminder_vox(45);
	level flag::wait_till("sq_ptt_level_pulled");
	level._ptt_sound_ent_trash StopLoopSound(2);
	level._ptt_sound_ent_trash playsound("evt_sq_ptt_trash_end");
	level._ptt_sound_ent PlaySoundWithNotify("vox_egg_story_3_8", "sounddone");
	level._ptt_sound_ent waittill("sounddone");
	level._ptt_sound_ent PlaySoundWithNotify("vox_egg_story_3_9", "sounddone");
	level._ptt_sound_ent waittill("sounddone");
	level flag::set("ptt_plot_vo_done");
	level._ptt_sound_ent_trash delete();
	level._ptt_sound_ent_trash = undefined;
	level._ptt_sound_ent delete();
	level._ptt_sound_ent = undefined;
}

/*
	Name: ptt_story_reminder_vox
	Namespace: zm_temple_sq_ptt
	Checksum: 0xBC8AD670
	Offset: 0x1340
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function ptt_story_reminder_vox(waitTime)
{
	level endon("sq_PtT_over");
	wait(waitTime);
	for(count = 4; !level flag::get("sq_ptt_level_pulled") && count <= 7; count++)
	{
		level._ptt_sound_ent PlaySoundWithNotify("vox_egg_story_3_" + count, "sounddone");
		level._ptt_sound_ent waittill("sounddone");
		wait(waitTime);
	}
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_ptt
	Checksum: 0x42ED1BA6
	Offset: 0x13F8
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function stage_logic()
{
	level flag::wait_till("sq_ptt_dial_dialed");
	while(level._ptt_num_lit < level._ptt_jets)
	{
		wait(0.1);
	}
	level flag::wait_till("sq_ptt_level_pulled");
	level notify("suspend_timer");
	wait(5);
	level notify("raise_crystal_1");
	level notify("raise_crystal_2");
	level notify("raise_crystal_3");
	level notify("raise_crystal_4", 1);
	level waittill("raised_crystal_4");
	level flag::wait_till("ptt_plot_vo_done");
	wait(5);
	zm_sidequests::stage_completed("sq", "PtT");
}

/*
	Name: remove_exploders
	Namespace: zm_temple_sq_ptt
	Checksum: 0x114D3DE9
	Offset: 0x1508
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function remove_exploders()
{
	exploder::stop_exploder("fxexp_100");
	exploder::stop_exploder("fxexp_101");
	exploder::stop_exploder("fxexp_102");
	exploder::stop_exploder("fxexp_103");
	util::wait_network_frame();
	exploder::stop_exploder("fxexp_110");
	exploder::stop_exploder("fxexp_111");
	exploder::stop_exploder("fxexp_112");
	exploder::stop_exploder("fxexp_113");
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_ptt
	Checksum: 0xE1713072
	Offset: 0x15E8
	Size: 0x20D
	Parameters: 1
	Flags: None
*/
function exit_stage(success)
{
	level flag::clear("sq_ptt_dial_dialed");
	level flag::clear("ptt_plot_vo_done");
	dial = GetEnt("sq_ptt_dial", "targetname");
	dial thread dud_dial_handler();
	ents = GetAIArray();
	for(i = 0; i < ents.size; i++)
	{
		if(isdefined(ents[i].explosive_volume))
		{
			ents[i].explosive_volume = 0;
		}
	}
	level thread remove_exploders();
	if(success)
	{
		zm_temple_sq_brock::create_radio(5);
	}
	else
	{
		zm_temple_sq_brock::create_radio(4, &zm_temple_sq_brock::radio4_override);
		level thread zm_temple_sq_skits::fail_skit();
	}
	level.skit_vox_override = 0;
	if(isdefined(level._ptt_sound_ent))
	{
		level._ptt_sound_ent delete();
		level._ptt_sound_ent = undefined;
	}
	if(isdefined(level._ptt_sound_ent_trash))
	{
		level._ptt_sound_ent_trash delete();
		level._ptt_sound_ent_trash = undefined;
	}
	if(isdefined(level._ptt_sound_choking_ent))
	{
		level._ptt_sound_choking_ent delete();
		level._ptt_sound_choking_ent = undefined;
	}
}

/*
	Name: dial_trigger
	Namespace: zm_temple_sq_ptt
	Checksum: 0x6529B10F
	Offset: 0x1800
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function dial_trigger()
{
	level endon("ptt_start");
	level endon("sq_PtT_over");
	while(1)
	{
		self waittill("trigger", who);
		self.owner_ent notify("triggered", who);
	}
}

/*
	Name: ptt_dial
	Namespace: zm_temple_sq_ptt
	Checksum: 0xDE5B6EAE
	Offset: 0x1860
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function ptt_dial()
{
	level endon("sq_PtT_over");
	num_turned = 0;
	who = undefined;
	self.trigger TriggerIgnoreTeam();
	self.trigger thread dial_trigger();
	while(num_turned < 4)
	{
		self waittill("triggered", who);
		self playsound("evt_sq_ptt_valve");
		self RotateRoll(90, 0.25);
		self waittill("rotatedone");
		num_turned++;
	}
	level thread ptt_story_vox(who);
	self playsound("evt_sq_ptt_gas_release");
	lever = GetEnt("sq_ptt_lever", "targetname");
	lever thread ptt_lever();
	level flag::set("sq_ptt_dial_dialed");
}

/*
	Name: dud_dial_handler
	Namespace: zm_temple_sq_ptt
	Checksum: 0x76492037
	Offset: 0x19D8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function dud_dial_handler()
{
	level endon("ptt_start");
	self.trigger TriggerIgnoreTeam();
	self.trigger thread dial_trigger();
	while(1)
	{
		self waittill("triggered");
		self playsound("evt_sq_ptt_valve");
		self RotateRoll(90, 0.25);
	}
}

