#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_weap_shrink_ray;
#using scripts\zm\zm_temple_sq_bag;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_bttp;
#using scripts\zm\zm_temple_sq_bttp2;
#using scripts\zm\zm_temple_sq_dgcwf;
#using scripts\zm\zm_temple_sq_lgs;
#using scripts\zm\zm_temple_sq_oafc;
#using scripts\zm\zm_temple_sq_ptt;
#using scripts\zm\zm_temple_sq_skits;
#using scripts\zm\zm_temple_sq_std;

#namespace zm_temple_sq;

/*
	Name: init
	Namespace: zm_temple_sq
	Checksum: 0x19E9B9E7
	Offset: 0x9B8
	Size: 0x673
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("pap_override");
	level flag::init("radio_9_played");
	level flag::init("gongs_resonating");
	level flag::init("trap_destroyed");
	level flag::init("radio_7_played");
	level flag::init("meteorite_shrunk");
	level flag::init("doing_bounce_around");
	level._crystal_bounce_paths = [];
	level._crystal_bounce_paths[1] = Array(2, 4, 3, 5, 6, "R");
	level._crystal_bounce_paths[2] = Array(1, 2, 3, 4, 1, "R");
	level._crystal_bounce_paths[3] = Array(4, 3, 1, 3, 5, "R");
	level._crystal_bounce_paths[4] = Array(1, 3, 2, 6, 5, "R");
	level._crystal_bounce_paths[5] = Array(6, 5, 6, 1, 3, 5, "R");
	level._crystal_bounce_paths[6] = Array(5, 6, 1, 4, 2, 1, 3, "M");
	a_gongs = GetEntArray("sq_gong", "targetname");
	foreach(e_gong in a_gongs)
	{
		e_gong.script_vector = VectorScale((0, 0, 1), 40);
	}
	zm_temple_sq_brock::init();
	zm_temple_sq_skits::init_skits();
	zm_sidequests::declare_sidequest("sq", &init_sidequest, undefined, &complete_sidequest, &generic_stage_start, &generic_stage_complete);
	zm_sidequests::declare_sidequest_asset("sq", "sq_sundial", &sundial_monitor);
	zm_sidequests::declare_sidequest_asset("sq", "sq_sundial_button", &sundial_button);
	zm_sidequests::declare_sidequest_asset("sq", "sq_ptt_dial", &ptt_dial_handler);
	zm_sidequests::declare_sidequest_asset("sq", "sq_bttp2_dial", &bttp2_dial_handler);
	zm_sidequests::declare_sidequest_asset("sq", "sq_spiketrap");
	zm_sidequests::declare_sidequest_asset_from_struct("sq", "sq_crystals", &crystal_handler);
	zm_sidequests::declare_sidequest_asset("sq", "sq_gong", &gong_handler, &gong_trigger_handler);
	zm_temple_sq_oafc::init();
	zm_temple_sq_dgcwf::init();
	zm_temple_sq_lgs::init();
	zm_temple_sq_ptt::init();
	zm_temple_sq_std::init();
	zm_temple_sq_bttp::init();
	zm_temple_sq_bttp2::init();
	zm_temple_sq_bag::init();
	level._num_gongs = 0;
	randomize_gongs();
	trig = GetEnt("sq_dgcwf_trig", "targetname");
	trig TriggerEnable(0);
	/#
		level thread force_eclipse_watcher();
		level thread raise_all_crystals();
		level thread function_e63287bf();
	#/
	level thread gong_watcher();
	level._sq_perk_array = Array("specialty_armorvest", "specialty_quickrevive", "specialty_fastreload", "specialty_doubletap2", "specialty_staminup", "specialty_widowswine", "specialty_deadshot", "specialty_additionalprimaryweapon");
}

/*
	Name: init_clientfield
	Namespace: zm_temple_sq
	Checksum: 0x5467CFB
	Offset: 0x1038
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init_clientfield()
{
	zm_sidequests::register_sidequest_icon("vril", 21000);
	zm_sidequests::register_sidequest_icon("dynamite", 21000);
	zm_sidequests::register_sidequest_icon("anti115", 21000);
	clientfield::register("scriptmover", "meteor_shrink", 21000, 1, "counter");
}

/*
	Name: randomize_gongs
	Namespace: zm_temple_sq
	Checksum: 0xC902FCCE
	Offset: 0x10D8
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function randomize_gongs()
{
	gongs = GetEntArray("sq_gong", "targetname");
	gongs = Array::randomize(gongs);
	for(i = 0; i < gongs.size; i++)
	{
		if(i < 4)
		{
			gongs[i].right_gong = 1;
			continue;
		}
		gongs[i].right_gong = 0;
	}
}

/*
	Name: watch_for_respawn
	Namespace: zm_temple_sq
	Checksum: 0xF2C35C49
	Offset: 0x1198
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function watch_for_respawn()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("spawned_player");
		waittillframeend;
		self zm_sidequests::add_sidequest_icon("sq", "anti115");
		foreach(perk in level._sq_perk_array)
		{
			if(!self hasPerk(perk))
			{
				if(zm_perks::use_solo_revive() && perk == "specialty_quickrevive")
				{
					continue;
					continue;
				}
				self zm_perks::give_perk(perk);
			}
		}
	}
}

/*
	Name: reward
	Namespace: zm_temple_sq
	Checksum: 0x88DC46DC
	Offset: 0x12C8
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function reward()
{
	level notify("temple_sidequest_achieved");
	self zm_sidequests::add_sidequest_icon("sq", "anti115");
	for(i = 0; i < level._sq_perk_array.size; i++)
	{
		if(!self hasPerk(level._sq_perk_array[i]))
		{
			self playsound("evt_sq_bag_gain_perks");
			self zm_perks::give_perk(level._sq_perk_array[i]);
			wait(0.25);
		}
	}
	self._retain_perks = 1;
	self thread watch_for_respawn();
}

/*
	Name: raise_all_crystals
	Namespace: zm_temple_sq
	Checksum: 0xED6D0BA8
	Offset: 0x13C0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function raise_all_crystals()
{
	while(0 == GetDvarInt("scr_raise_crystals"))
	{
		wait(0.1);
	}
	level notify("raise_crystal_1");
	level notify("raise_crystal_2");
	level notify("raise_crystal_3");
	level notify("raise_crystal_4");
	level notify("raise_crystal_5");
	level notify("raise_crystal_6");
}

/*
	Name: gong_watcher
	Namespace: zm_temple_sq
	Checksum: 0xF069EB71
	Offset: 0x1440
	Size: 0x171
	Parameters: 0
	Flags: None
*/
function gong_watcher()
{
	if(isdefined(level._gong_watcher_running))
	{
		return;
	}
	level._gong_watcher_running = 1;
	level thread watch_for_gongs_gone_bad();
	while(1)
	{
		level flag::wait_till("gongs_resonating");
		for(i = 0; i < level._raised_crystals.size; i++)
		{
			if(level._raised_crystals[i])
			{
				str_exploder = "fxexp_50" + i + 1;
				exploder::exploder(str_exploder);
				util::wait_network_frame();
			}
		}
		while(level flag::get("gongs_resonating"))
		{
			wait(0.1);
		}
		for(i = 0; i < level._raised_crystals.size; i++)
		{
			str_exploder = "fxexp_50" + i + 1;
			exploder::stop_exploder(str_exploder);
			util::wait_network_frame();
		}
	}
}

/*
	Name: watch_for_gongs_gone_bad
	Namespace: zm_temple_sq
	Checksum: 0x20899CAF
	Offset: 0x15C0
	Size: 0x131
	Parameters: 0
	Flags: None
*/
function watch_for_gongs_gone_bad()
{
	while(1)
	{
		level waittill("wrong_gong");
		for(i = 0; i < level._raised_crystals.size; i++)
		{
			if(level._raised_crystals[i])
			{
				str_exploder = "fxexp_51" + i + 1;
				exploder::exploder(str_exploder);
				util::wait_network_frame();
			}
		}
		wait(1);
		level flag::clear("gongs_resonating");
		wait(6);
		for(i = 0; i < level._raised_crystals.size; i++)
		{
			str_exploder = "fxexp_51" + i + 1;
			exploder::stop_exploder(str_exploder);
			util::wait_network_frame();
		}
	}
}

/*
	Name: force_eclipse_watcher
	Namespace: zm_temple_sq
	Checksum: 0xF0E2B83E
	Offset: 0x1700
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function force_eclipse_watcher()
{
	level endon("end_game");
	SetDvar("scr_force_eclipse", 0);
	level waittill("start_zombie_round_logic");
	while(1)
	{
		while(0 == GetDvarInt("scr_force_eclipse"))
		{
			wait(0.1);
		}
		back_to_the_eclipse();
		reveal_meteor();
		while(1 == GetDvarInt("scr_force_eclipse"))
		{
			wait(0.1);
		}
		back_to_the_future();
		hide_meteor();
	}
}

/*
	Name: gong_trigger_handler
	Namespace: zm_temple_sq
	Checksum: 0x775A2632
	Offset: 0x17E8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function gong_trigger_handler()
{
	if(isdefined(self.owner_ent) && isdefined(self.owner_ent.target))
	{
		self.owner_ent.var_4ba5f5f1 = GetEnt(self.owner_ent.target, "targetname");
		self.owner_ent.var_4ba5f5f1.takedamage = 1;
		continue;
	}
	return;
	while(1)
	{
		self.owner_ent.var_4ba5f5f1 waittill("damage", amount, attacker, dir, point, mod);
		if(isPlayer(attacker) && mod == "MOD_MELEE")
		{
			self.owner_ent notify("triggered", attacker);
		}
	}
}

/*
	Name: gong_handler
	Namespace: zm_temple_sq
	Checksum: 0xE290C461
	Offset: 0x1918
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function gong_handler()
{
	self thread zm_temple_sq_bag::dud_gong_handler();
}

/*
	Name: ptt_dial_handler
	Namespace: zm_temple_sq
	Checksum: 0x4421FF6B
	Offset: 0x1940
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function ptt_dial_handler()
{
	self thread zm_temple_sq_ptt::dud_dial_handler();
}

/*
	Name: bttp2_dial_handler
	Namespace: zm_temple_sq
	Checksum: 0xFBD75CDD
	Offset: 0x1968
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function bttp2_dial_handler()
{
	self.trigger TriggerIgnoreTeam();
	self thread zm_temple_sq_bttp2::dud_dial_handler();
}

/*
	Name: start_temple_sidequest
	Namespace: zm_temple_sq
	Checksum: 0x8F7EDD95
	Offset: 0x19A8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function start_temple_sidequest()
{
	hide_meteor();
	level flag::wait_till("initial_players_connected");
	zm_sidequests::sidequest_start("sq");
}

/*
	Name: restart_sundial_monitor
	Namespace: zm_temple_sq
	Checksum: 0x720BCB4E
	Offset: 0x1A00
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function restart_sundial_monitor()
{
	level endon("kill_sundial_monitor");
	level waittill("reset_sundial");
	wait(0.1);
	self thread sundial_monitor();
}

/*
	Name: spin_dial
	Namespace: zm_temple_sq
	Checksum: 0xCA474B14
	Offset: 0x1A48
	Size: 0xE3
	Parameters: 2
	Flags: None
*/
function spin_dial(duration, multiplier)
{
	if(!isdefined(duration))
	{
		duration = 2;
	}
	if(!isdefined(multiplier))
	{
		multiplier = 1.3;
	}
	for(spin_time = 0.1; spin_time < duration;  = 0.1)
	{
		self PlayLoopSound("evt_sq_gen_sundial_spin", 0.5);
		self RotatePitch(180, spin_time);
		wait(spin_time * 0.95);
	}
	self StopLoopSound(2);
}

/*
	Name: short_dial_spin
	Namespace: zm_temple_sq
	Checksum: 0xABB7D52B
	Offset: 0x1B38
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function short_dial_spin()
{
	spin_dial(1, 1.6);
}

/*
	Name: sundial_monitor
	Namespace: zm_temple_sq
	Checksum: 0xB90E20D2
	Offset: 0x1B68
	Size: 0x477
	Parameters: 0
	Flags: None
*/
function sundial_monitor()
{
	level endon("reset_sundial");
	level endon("end_game");
	self.dont_rethread = 1;
	self thread restart_sundial_monitor();
	if(!isdefined(self.original_pos))
	{
		self.original_pos = self.origin - anglesToUp(self.angles);
		self.off_pos = self.original_pos - anglesToUp(self.angles) * 34;
	}
	self.origin = self.off_pos;
	level._sundial_buttons_pressed = 0;
	level._stage_active = 0;
	level._sundial_active = 0;
	level flag::wait_till("power_on");
	level notify("kill_buttons");
	wait(0.05);
	Buttons = GetEntArray("sq_sundial_button", "targetname");
	Array::thread_all(Buttons, &sundial_button);
	while(1)
	{
		while(level._sundial_buttons_pressed < 4)
		{
			wait(0.1);
		}
		level._sundial_active = 1;
		self playsound("evt_sq_gen_transition_start");
		self playsound("evt_sq_gen_sundial_emerge");
		self moveto(self.original_pos, 0.25);
		self waittill("movedone");
		self thread spin_dial();
		wait(0.5);
		stage = zm_sidequests::sidequest_start_next_stage("sq");
		level notify("stage_starting");
		amount = 8.5;
		level waittill("timed_stage_75_percent");
		self playsound("evt_sq_gen_sundial_timer");
		self moveto(self.origin - anglesToUp(self.angles) * amount, 1);
		self thread short_dial_spin();
		level waittill("timed_stage_50_percent");
		self playsound("evt_sq_gen_sundial_timer");
		self moveto(self.origin - anglesToUp(self.angles) * amount, 1);
		self thread short_dial_spin();
		level waittill("timed_stage_25_percent");
		self playsound("evt_sq_gen_sundial_timer");
		self moveto(self.origin - anglesToUp(self.angles) * amount, 1);
		self thread short_dial_spin();
		level waittill("timed_stage_10_seconds_to_go");
		self thread play_one_second_increments();
		self moveto(self.origin - anglesToUp(self.angles) * amount, 10);
		self thread spin_dial();
		self waittill("movedone");
		level._sundial_active = 0;
		wait(0.1);
	}
}

/*
	Name: play_one_second_increments
	Namespace: zm_temple_sq
	Checksum: 0xFD4123C9
	Offset: 0x1FE8
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function play_one_second_increments()
{
	level endon("sidequest_sq_complete");
	level endon("reset_sundial");
	while(level._sundial_active == 1)
	{
		self playsound("evt_sq_gen_sundial_timer");
		wait(1);
	}
}

/*
	Name: sundial_button_already_pressed_by
	Namespace: zm_temple_sq
	Checksum: 0x6401F6FA
	Offset: 0x2048
	Size: 0xA1
	Parameters: 2
	Flags: None
*/
function sundial_button_already_pressed_by(who, Buttons)
{
	/#
		if(GetPlayers().size < 4)
		{
			return 0;
		}
	#/
	for(i = 0; i < Buttons.size; i++)
	{
		if(isdefined(Buttons[i].triggering_player) && Buttons[i].triggering_player == who)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sundial_button
	Namespace: zm_temple_sq
	Checksum: 0x3698EA7D
	Offset: 0x20F8
	Size: 0x3A7
	Parameters: 0
	Flags: None
*/
function sundial_button()
{
	level endon("stage_starting");
	level endon("kill_buttons");
	if(!isdefined(self.dont_rethread))
	{
		self.dont_rethread = 1;
		self.on_pos = self.origin - anglesToUp(self.angles);
		self.off_pos = self.on_pos - anglesToUp(self.angles) * 5.5;
		self moveto(self.off_pos, 0.01);
	}
	if(isdefined(self.trigger))
	{
		self.trigger delete();
		self.trigger = undefined;
	}
	self.triggering_player = undefined;
	level flag::wait_till("power_on");
	self moveto(self.on_pos, 0.25);
	wait(0.25);
	Buttons = GetEntArray("sq_sundial_button", "targetname");
	offset = AnglesToForward(self.angles) * 5 - VectorScale((0, 0, 1), 16);
	self.trigger = spawn("trigger_radius_use", self.on_pos + offset, 0, 48, 32);
	self.trigger TriggerIgnoreTeam();
	self.trigger.radius = 48;
	self.trigger setcursorhint("HINT_NOICON");
	while(1)
	{
		self.trigger waittill("trigger", who);
		if(sundial_button_already_pressed_by(who, Buttons))
		{
			continue;
		}
		if(!level._stage_active && level._buttons_can_reset)
		{
			self.triggering_player = who;
			level._sundial_buttons_pressed++;
			self playsound("evt_sq_gen_button");
			self moveto(self.off_pos, 0.25);
			delay = 1;
			/#
				if(GetPlayers().size == 1 || GetDvarInt("Dev Block strings are not supported") == 2)
				{
					delay = 10;
				}
			#/
			wait(delay);
			while(level._sundial_active)
			{
				wait(0.1);
			}
			self.triggering_player = undefined;
			self moveto(self.on_pos, 0.25);
			if(level._sundial_buttons_pressed > 0)
			{
				level._sundial_buttons_pressed--;
			}
		}
	}
}

/*
	Name: init_gongs
	Namespace: zm_temple_sq
	Checksum: 0xCF997D36
	Offset: 0x24A8
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function init_gongs()
{
	gongs = GetEntArray("sq_gong", "targetname");
	gongs = Array::randomize(gongs);
	for(i = 0; i < gongs.size; i++)
	{
		name = "gong" + i;
		gongs[i].animName = name;
	}
}

/*
	Name: init_sidequest
	Namespace: zm_temple_sq
	Checksum: 0xA1B0B6E4
	Offset: 0x2558
	Size: 0x48B
	Parameters: 0
	Flags: None
*/
function init_sidequest()
{
	level._buttons_can_reset = 1;
	if(!isdefined(level._sidequest_firsttime))
	{
		back_to_the_future();
		level._sidequest_firsttime = 0;
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		n_char_id = players[i].characterindex;
		if(isdefined(players[i].zm_random_char))
		{
			n_char_id = players[i].zm_random_char;
		}
		if(n_char_id == 3 && zm::is_sidequest_previously_completed("COTD"))
		{
			players[i] zm_sidequests::add_sidequest_icon("sq", "vril", 0);
			break;
		}
	}
	zm_temple_sq_brock::create_radio(1);
	init_gongs();
	wall = GetEnt("sq_wall", "targetname");
	wall SetModel("p7_zm_sha_wall_temple_brick_02");
	wall solid();
	crystals = GetEntArray("sq_crystals", "targetname");
	level._raised_crystals = [];
	for(i = 0; i < crystals.size; i++)
	{
		level._raised_crystals[i] = 0;
	}
	a_e_trap = GetEntArray("sq_spiketrap", "targetname");
	foreach(e_trap in a_e_trap)
	{
		e_trap show();
	}
	level flag::clear("radio_4_played");
	level flag::clear("radio_7_played");
	level flag::clear("radio_9_played");
	level flag::clear("meteorite_shrunk");
	meteorite = GetEnt("sq_meteorite", "targetname");
	meteorite SetModel("p7_zm_sha_meteorite");
	meteorite ghost();
	if(!isdefined(meteorite.original_origin))
	{
		meteorite.original_origin = meteorite.origin;
		meteorite.original_angles = meteorite.angles;
	}
	meteorite.origin = meteorite.original_origin;
	meteorite.angles = meteorite.original_angles;
	anti115 = GetEnt("sq_anti_115", "targetname");
	anti115 show();
	level thread pap_watcher();
}

/*
	Name: pap_watcher
	Namespace: zm_temple_sq
	Checksum: 0x7E47D81
	Offset: 0x29F0
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function pap_watcher()
{
	level notify("only_one_pap_watcher");
	level endon("only_one_pap_watcher");
	while(1)
	{
		level flag::wait_till("pap_override");
		while(level flag::get("pack_machine_in_use"))
		{
			wait(0.1);
		}
		level thread pack_a_punch_hide();
		while(level flag::get("pap_override"))
		{
			wait(0.1);
		}
		level thread pack_a_punch_show();
	}
}

/*
	Name: cheat_complete_stage
	Namespace: zm_temple_sq
	Checksum: 0xA42AAE47
	Offset: 0x2AD0
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function cheat_complete_stage()
{
	level endon("reset_sundial");
	while(1)
	{
		if(GetDvarString("cheat_sq") != "")
		{
			if(isdefined(level._last_stage_started))
			{
				SetDvar("cheat_sq", "");
				zm_sidequests::stage_completed("sq", level._last_stage_started);
			}
		}
		wait(0.1);
	}
}

/*
	Name: generic_stage_start
	Namespace: zm_temple_sq
	Checksum: 0xD85097B7
	Offset: 0x2B68
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function generic_stage_start()
{
	/#
		level thread cheat_complete_stage();
	#/
	level._stage_active = 1;
	back_to_the_eclipse();
	reveal_meteor();
}

/*
	Name: generic_stage_complete
	Namespace: zm_temple_sq
	Checksum: 0xF70BE639
	Offset: 0x2BC0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function generic_stage_complete()
{
	level notify("reset_sundial");
	level._stage_active = 0;
	back_to_the_future();
	hide_meteor();
}

/*
	Name: complete_sidequest
	Namespace: zm_temple_sq
	Checksum: 0x701C2270
	Offset: 0x2C08
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function complete_sidequest()
{
	level notify("kill_sundial_monitor");
	level notify("reset_sundial");
	level notify("kill_buttons");
	level thread sidequest_done();
}

/*
	Name: spin_115
	Namespace: zm_temple_sq
	Checksum: 0x9CCB71C3
	Offset: 0x2C50
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function spin_115()
{
	self endon("picked_up");
	while(1)
	{
		self RotateYaw(180, 0.4);
		wait(0.4);
	}
}

/*
	Name: sidequest_done
	Namespace: zm_temple_sq
	Checksum: 0x5976C0A8
	Offset: 0x2C98
	Size: 0x41B
	Parameters: 0
	Flags: None
*/
function sidequest_done()
{
	wall = GetEnt("sq_wall", "targetname");
	wall SetModel("p7_zm_sha_wall_temple_brick_02_dmg");
	wall notsolid();
	anti115 = GetEnt("sq_anti_115", "targetname");
	anti115 thread spin_115();
	anti115 PlayLoopSound("zmb_meteor_loop");
	exploder::exploder("fxexp_520");
	trigger = spawn("trigger_radius_use", anti115.origin, 0, 32, 72);
	trigger TriggerIgnoreTeam();
	trigger setcursorhint("HINT_NOICON");
	trigger.radius = 48;
	trigger.height = 72;
	while(1)
	{
		trigger waittill("trigger", who);
		if(isPlayer(who) && !isdefined(who._has_anti115))
		{
			who._has_anti115 = 1;
			who playsound("zmb_meteor_activate");
			who thread reward();
			who thread zm_audio::create_and_play_dialog("eggs", "quest8", 7);
			who thread delayed_loser_response();
			break;
		}
		else if(isPlayer(who))
		{
			who playsound("zmb_no_cha_ching");
		}
	}
	trigger delete();
	anti115 StopLoopSound(1);
	anti115 notify("picked_up");
	level notify("picked_up");
	anti115 ghost();
	exploder::stop_exploder("fxexp_520");
	players_far = 0;
	for(players = GetPlayers(); players_far < players.size;  = GetPlayers())
	{
		players_far = 0;
		for(i = 0; i < players.size; i++)
		{
			if(Distance2DSquared(players[i].origin, wall.origin) > 129600)
			{
				players_far++;
			}
		}
		wait(0.1);
	}
	level flag::clear("pap_override");
	level thread reset_sidequest();
}

/*
	Name: delayed_loser_response
	Namespace: zm_temple_sq
	Checksum: 0x7ED19A39
	Offset: 0x30C0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function delayed_loser_response()
{
	wait(5);
	losers = GetPlayers();
	ArrayRemoveValue(losers, self);
	if(losers.size >= 1)
	{
		losers[randomIntRange(0, losers.size)] thread zm_audio::create_and_play_dialog("eggs", "quest8", 8);
	}
}

/*
	Name: reset_sidequest
	Namespace: zm_temple_sq
	Checksum: 0x4BBB8A71
	Offset: 0x3168
	Size: 0x37B
	Parameters: 0
	Flags: None
*/
function reset_sidequest()
{
	sidequest = level._zombie_sidequests["sq"];
	if(sidequest.num_reps >= 3)
	{
		return;
	}
	sidequest.num_reps++;
	level flag::wait_till("radio_9_played");
	while(level flag::get("doing_bounce_around"))
	{
		wait(0.1);
	}
	stage_names = getArrayKeys(sidequest.stages);
	for(i = 0; i < stage_names.size; i++)
	{
		sidequest.stages[stage_names[i]].completed = 0;
	}
	sidequest.last_completed_stage = -1;
	sidequest.active_stage = -1;
	level flag::clear("radio_7_played");
	level flag::clear("radio_9_played");
	level flag::clear("trap_destroyed");
	randomize_gongs();
	crystals = GetEntArray("sq_crystals", "targetname");
	for(i = 0; i < crystals.size; i++)
	{
		if(isdefined(crystals[i].trigger))
		{
			crystals[i].trigger delete();
			crystals[i] delete();
		}
	}
	dynamite = GetEnt("dynamite", "targetname");
	dynamite delete();
	Buttons = GetEntArray("sq_sundial_button", "targetname");
	for(i = 0; i < Buttons.size; i++)
	{
		if(isdefined(Buttons[i].trigger))
		{
			Buttons[i].trigger delete();
			Buttons[i].trigger = undefined;
		}
	}
	start_temple_sidequest();
	dial = GetEnt("sq_sundial", "targetname");
	dial thread sundial_monitor();
}

/*
	Name: back_to_the_eclipse
	Namespace: zm_temple_sq
	Checksum: 0x3144F170
	Offset: 0x34F0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function back_to_the_eclipse()
{
	foreach(e_player in level.players)
	{
		e_player thread function_5fdf6353();
	}
	level util::set_lighting_state(1);
	level clientfield::set("time_transition", 0);
	level function_7aca917c(0);
}

/*
	Name: back_to_the_future
	Namespace: zm_temple_sq
	Checksum: 0xB3F6911B
	Offset: 0x35D8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function back_to_the_future()
{
	foreach(e_player in level.players)
	{
		e_player thread function_5fdf6353();
	}
	level util::set_lighting_state(0);
	level clientfield::set("time_transition", 1);
	level function_7aca917c(1);
}

/*
	Name: function_5fdf6353
	Namespace: zm_temple_sq
	Checksum: 0x41D0ECC
	Offset: 0x36C0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_5fdf6353()
{
	level endon("end_game");
	self endon("disconnect");
	visionset_mgr::activate("overlay", "zm_temple_eclipse", self);
	wait(3);
	if(isdefined(self))
	{
		visionset_mgr::deactivate("overlay", "zm_temple_eclipse", self);
	}
}

/*
	Name: rotate_skydome
	Namespace: zm_temple_sq
	Checksum: 0x257D2FD1
	Offset: 0x3738
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function rotate_skydome(n_time)
{
	level notify("hash_89011ead");
	level endon("hash_89011ead");
	if(!isdefined(level.var_9e9e4a20))
	{
		level.var_9e9e4a20 = 0;
	}
	if(level.var_9e9e4a20 > 0)
	{
		var_3557d539 = 360 - level.var_9e9e4a20;
	}
	else
	{
		var_3557d539 = 360;
	}
	n_change = var_3557d539 / n_time / 0.1;
	while(var_3557d539 > 0)
	{
		level.var_9e9e4a20 = level.var_9e9e4a20 + n_change;
		SetDvar("r_skyRotation", level.var_9e9e4a20);
		var_3557d539 = var_3557d539 - n_change;
		wait(0.1);
	}
	level.var_9e9e4a20 = 0;
	SetDvar("r_skyRotation", level.var_9e9e4a20);
}

/*
	Name: function_7aca917c
	Namespace: zm_temple_sq
	Checksum: 0x259A42F7
	Offset: 0x3870
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_7aca917c(var_8182276a)
{
	if(!isdefined(var_8182276a))
	{
		var_8182276a = 0;
	}
	if(isdefined(level.var_1b3f87f7))
	{
		level.var_1b3f87f7 delete();
	}
	level.var_1b3f87f7 = CreateStreamerHint(level.activePlayers[0].origin, 1, var_8182276a);
	level.var_1b3f87f7 setlightingonly(1);
}

/*
	Name: reveal_meteor
	Namespace: zm_temple_sq
	Checksum: 0x42417F6E
	Offset: 0x3918
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function reveal_meteor()
{
	ent = GetEnt("sq_meteorite", "targetname");
	if(isdefined(ent))
	{
		ent show();
		exploder::exploder("fxexp_518");
	}
}

/*
	Name: hide_meteor
	Namespace: zm_temple_sq
	Checksum: 0xB211610A
	Offset: 0x3990
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function hide_meteor()
{
	ent = GetEnt("sq_meteorite", "targetname");
	if(isdefined(ent))
	{
		ent ghost();
		exploder::stop_exploder("fxexp_518");
	}
}

/*
	Name: spawn_skel
	Namespace: zm_temple_sq
	Checksum: 0xA35AF104
	Offset: 0x3A08
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function spawn_skel()
{
	if(!isdefined(level._sq_skel))
	{
		a_e_spikes = GetEntArray("sq_spiketrap", "targetname");
		ent = a_e_spikes[0];
		if(isdefined(ent))
		{
			sb = util::spawn_model("p7_zm_sha_skeleton", ent.origin, ent.angles);
			level._sq_skel = sb;
		}
	}
}

/*
	Name: remove_skel
	Namespace: zm_temple_sq
	Checksum: 0x1294E6BE
	Offset: 0x3AC0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function remove_skel()
{
	if(isdefined(level._sq_skel))
	{
		level._sq_skel delete();
		level._sq_skel = undefined;
	}
}

/*
	Name: reset_dynamite
	Namespace: zm_temple_sq
	Checksum: 0x1B853AD
	Offset: 0x3B00
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function reset_dynamite()
{
	dynamite = GetEnt("dynamite", "targetname");
	dynamite.angles = dynamite.original_angles;
	dynamite.origin = dynamite.original_origin;
	dynamite Unlink();
	dynamite LinkTo(dynamite.owner_ent, "", dynamite.origin - dynamite.owner_ent.origin, dynamite.angles - dynamite.owner_ent.angles);
	dynamite.dropped = undefined;
	dynamite show();
}

/*
	Name: delay_kill_loop_sound_and_delete
	Namespace: zm_temple_sq
	Checksum: 0x6A78E498
	Offset: 0x3C20
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function delay_kill_loop_sound_and_delete()
{
	self StopLoopSound(0.5);
	wait(0.5);
	self delete();
}

/*
	Name: crystal_handler
	Namespace: zm_temple_sq
	Checksum: 0x9E8201FA
	Offset: 0x3C70
	Size: 0x4ED
	Parameters: 0
	Flags: None
*/
function crystal_handler()
{
	if(isdefined(self.trigger))
	{
		zm_weap_shrink_ray::remove_shrinkable_object(self.trigger);
		self.trigger thread delay_kill_loop_sound_and_delete();
		self.trigger = undefined;
	}
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "dynamite" && !isdefined(self.dynamite))
	{
		dyn_pos = struct::get(self.target, "targetname");
		dynamite = spawn("script_model", dyn_pos.origin);
		dynamite.angles = dyn_pos.angles;
		dynamite SetModel("p7_zm_sha_dynamite_wrap_full");
		dynamite.targetname = "dynamite";
		dynamite.target = dyn_pos.target;
		dynamite.original_origin = dynamite.origin;
		dynamite.original_angles = dynamite.angles;
		dynamite.owner_ent = self;
		dynamite LinkTo(self, "", dynamite.origin - self.origin, dynamite.angles - self.angles);
		self.dynamite = dynamite;
	}
	if(!isdefined(self.original_origin))
	{
		self.original_origin = self.origin;
	}
	self DontInterpolate();
	self.origin = self.original_origin - VectorScale((0, 0, 1), 154);
	self ghost();
	level waittill("raise_crystal_" + self.script_int, actual_stage);
	if(isdefined(actual_stage) && actual_stage)
	{
		level notify("suspend_timer");
	}
	self show();
	self playsound("evt_sq_gen_crystal_start");
	self PlayLoopSound("evt_sq_gen_crystal_loop", 2);
	self moveto(self.origin + VectorScale((0, 0, 1), 154), 4, 0.8, 0.4);
	self waittill("movedone");
	self StopLoopSound(1);
	self playsound("evt_sq_gen_crystal_end");
	level notify("raised_crystal_" + self.script_int);
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "empty_holder")
	{
		if(isdefined(actual_stage) && actual_stage)
		{
			level waittill("crystal_dropped");
		}
		self SetModel("p7_zm_sha_crystal_holder_full");
	}
	trigger = spawn("trigger_damage", self.origin + VectorScale((0, 0, 1), 134), 0, 32, 32);
	trigger.radius = 32;
	trigger.height = 32;
	trigger thread crystal_trigger_thread();
	trigger.owner_ent = self;
	zm_weap_shrink_ray::add_shrinkable_object(trigger);
	self.trigger = trigger;
	self thread play_loopsound_while_resonating();
	self thread force_stoploopsound_end();
	level._raised_crystals[self.script_int - 1] = 1;
}

/*
	Name: play_loopsound_while_resonating
	Namespace: zm_temple_sq
	Checksum: 0x4FE8D81F
	Offset: 0x4168
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function play_loopsound_while_resonating()
{
	self.trigger endon("death");
	while(1)
	{
		level flag::wait_till("gongs_resonating");
		self PlayLoopSound("mus_sq_bag_crystal_loop", 2);
		while(level flag::get("gongs_resonating"))
		{
			wait(0.1);
		}
		self StopLoopSound(0.5);
	}
}

/*
	Name: get_crystal_from_script_int
	Namespace: zm_temple_sq
	Checksum: 0x65EDDD90
	Offset: 0x4220
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function get_crystal_from_script_int(num)
{
	SQ = GetEntArray("sq_crystals", "targetname");
	for(i = 0; i < SQ.size; i++)
	{
		if(SQ[i].script_int == num)
		{
			return SQ[i];
		}
	}
}

/*
	Name: is_crystal_raised
	Namespace: zm_temple_sq
	Checksum: 0x1240D4CF
	Offset: 0x42B8
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function is_crystal_raised(i)
{
	if(isdefined(level._raised_crystals[i - 1]) && level._raised_crystals[i - 1] == 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: bounce_from_a_to_b
	Namespace: zm_temple_sq
	Checksum: 0xBB21B894
	Offset: 0x4310
	Size: 0x12B
	Parameters: 3
	Flags: None
*/
function bounce_from_a_to_b(a, b, hotsauce)
{
	if(hotsauce)
	{
		a clientfield::set("hotsauce", 1);
	}
	else
	{
		a clientfield::set("weaksauce", 1);
	}
	b clientfield::set("sauceend", 1);
	util::wait_network_frame();
	util::wait_network_frame();
	util::wait_network_frame();
	if(isdefined(a))
	{
		a clientfield::set("hotsauce", 0);
		a clientfield::set("weaksauce", 0);
	}
	if(isdefined(b))
	{
		b clientfield::set("sauceend", 0);
	}
}

/*
	Name: do_bounce_off
	Namespace: zm_temple_sq
	Checksum: 0x14CF839E
	Offset: 0x4448
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function do_bounce_off(start, hotsauce)
{
	if(!isdefined(level._bounce_off_ent))
	{
		level._bounce_off_ent = spawn("script_model", (0, 0, 0));
		level._bounce_off_ent SetModel("tag_origin");
	}
	yaw = RandomFloat(360);
	r = RandomFloatRange(100, 200);
	amntx = cos(yaw) * r;
	amnty = sin(yaw) * r;
	level._bounce_off_ent.origin = start.origin + (amntx, amnty, RandomInt(60));
	level thread bounce_from_a_to_b(start, level._bounce_off_ent, hotsauce);
}

/*
	Name: shrink_time
	Namespace: zm_temple_sq
	Checksum: 0x8D37B309
	Offset: 0x45B8
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function shrink_time()
{
	wait(1);
	clientfield::increment("meteor_shrink");
	self playsound("evt_sq_bag_shrink_meteor");
	self SetModel("p7_zm_sha_meteorite_small");
	exploder::exploder("fxexp_519");
	wait(0.1);
	exploder::stop_exploder("fxexp_518");
	self ghost();
	wait(0.25);
	level flag::set("meteorite_shrunk");
	level thread shut_off_all_looping_sounds();
	self playsound("evt_sq_bag_meteor_fall");
	self moveto(self.origin - VectorScale((0, 0, 1), 120), 2, 0.5);
	self waittill("movedone");
	players = GetPlayers();
	players[randomIntRange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest8", 4);
}

/*
	Name: crystal_shrink_logic
	Namespace: zm_temple_sq
	Checksum: 0x51A8CBB6
	Offset: 0x4790
	Size: 0x533
	Parameters: 1
	Flags: None
*/
function crystal_shrink_logic(hotsauce)
{
	level._crystal_shrink_logic_running = 1;
	level flag::set("doing_bounce_around");
	bounce_path = level._crystal_bounce_paths[self.script_int];
	start = self;
	end = undefined;
	if(isdefined(bounce_path))
	{
		for(i = 0; i < bounce_path.size; i++)
		{
			if("" + bounce_path[i] == "M")
			{
				if(zm_sidequests::sidequest_stage_active("sq", "BaG") && !level flag::get("meteorite_shrunk"))
				{
					ent = GetEnt("sq_meteorite", "targetname");
					if(hotsauce)
					{
						start playsound("evt_sq_bag_crystal_bounce_correct");
						exploder::exploder("fxexp_509");
						ent thread shrink_time();
					}
					else
					{
						start playsound("evt_sq_bag_crystal_bounce_fail");
						exploder::exploder("fxexp_529");
						players = GetPlayers();
						players[randomIntRange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest8", 3);
					}
				}
				else
				{
					start playsound("evt_sq_bag_crystal_bounce_fail");
					exploder::exploder("fxexp_529");
				}
			}
			else if("" + bounce_path[i] == "R")
			{
				start playsound("evt_sq_bag_crystal_bounce_fail");
				do_bounce_off(start, hotsauce);
				break;
			}
			else if(is_crystal_raised(bounce_path[i]))
			{
				end = get_crystal_from_script_int(bounce_path[i]);
				start playsound("evt_sq_bag_crystal_bounce_correct");
				level thread bounce_from_a_to_b(start, end, hotsauce);
				start = end;
			}
			else
			{
				start playsound("evt_sq_bag_crystal_bounce_fail");
				do_bounce_off(start, hotsauce);
				break;
			}
			wait(0.5);
			if(i == 6)
			{
				end playsound("mus_sq_bag_crystal_final_hit");
			}
			else
			{
				end playsound("evt_sq_bag_crystal_hit_" + i);
			}
			if(hotsauce && isdefined(end) && isdefined(end.dynamite) && !isdefined(end.dynamite.dropped) && zm_sidequests::sidequest_stage_active("sq", "BaG"))
			{
				end.dynamite thread zm_temple_sq_bag::fire_in_the_hole();
			}
			end playsound("evt_sq_bag_crystal_charge");
			if(hotsauce)
			{
				str_exploder = "fxexp_" + end.script_int + 520;
				exploder::exploder(str_exploder);
			}
			else
			{
				str_exploder = "fxexp_" + end.script_int + 530;
				exploder::exploder(str_exploder);
			}
			wait(0.5);
		}
	}
	level._crystal_shrink_logic_running = undefined;
	level flag::clear("doing_bounce_around");
}

/*
	Name: crystal_shrink_thread
	Namespace: zm_temple_sq
	Checksum: 0x15B1B668
	Offset: 0x4CD0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function crystal_shrink_thread()
{
	self endon("death");
	while(1)
	{
		self waittill("shrunk", hotsauce);
		if(!level flag::get("gongs_resonating"))
		{
			hotsauce = 0;
		}
		if(!isdefined(level._crystal_shrink_logic_running))
		{
			self.owner_ent thread crystal_shrink_logic(hotsauce);
		}
	}
}

/*
	Name: crystal_trigger_thread
	Namespace: zm_temple_sq
	Checksum: 0x1F463FDD
	Offset: 0x4D60
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function crystal_trigger_thread()
{
	self endon("death");
	self thread crystal_shrink_thread();
	while(1)
	{
		self waittill("damage", amount, attacker, dir, point, type);
	}
}

/*
	Name: pack_a_punch_hide
	Namespace: zm_temple_sq
	Checksum: 0xF663525D
	Offset: 0x4DE0
	Size: 0x26F
	Parameters: 0
	Flags: None
*/
function pack_a_punch_hide()
{
	if(!isdefined(level._pap_hidden))
	{
		level._pap_hidden = 0;
	}
	if(level._pap_hidden)
	{
		return;
	}
	level._pap_hidden = 1;
	pap_clip = level.pack_a_punch.triggers[0].clip;
	pap_clip notsolid();
	pap_clip connectpaths();
	pap_machine_trig = level.pack_a_punch.triggers[0];
	pap_machine_trig EnableLinkTo();
	pap_machine = pap_machine_trig.pap_machine;
	if(!isdefined(pap_machine_trig.original_origin))
	{
		pap_machine_trig.original_origin = pap_machine_trig.origin;
	}
	link_ent = spawn("script_origin", pap_machine_trig.origin);
	link_ent.angles = pap_machine.angles;
	pap_machine_trig LinkTo(link_ent);
	level._original_pap_spot = pap_machine_trig.origin;
	pap_machine LinkTo(link_ent);
	link_ent moveto(link_ent.origin + VectorScale((0, 0, -1), 350), 5);
	link_ent waittill("movedone");
	pap_machine_trig Unlink();
	pap_machine Unlink();
	pap_machine ghost();
	pap_machine notsolid();
	link_ent delete();
	level._pap_hidden = 2;
}

/*
	Name: pack_a_punch_show
	Namespace: zm_temple_sq
	Checksum: 0xD0A6475B
	Offset: 0x5058
	Size: 0x20F
	Parameters: 0
	Flags: None
*/
function pack_a_punch_show()
{
	if(!isdefined(level._pap_hidden) || level._pap_hidden == 0)
	{
		return;
	}
	if(level._pap_hidden == 1)
	{
		while(level._pap_hidden != 2)
		{
			wait(1);
		}
	}
	pap_clip = level.pack_a_punch.triggers[0].clip;
	pap_clip solid();
	pap_clip connectpaths();
	pap_machine_trig = level.pack_a_punch.triggers[0];
	pap_machine = pap_machine_trig.pap_machine;
	link_ent = spawn("script_origin", pap_machine_trig.origin);
	link_ent.angles = pap_machine.angles;
	pap_machine_trig LinkTo(link_ent);
	pap_machine LinkTo(link_ent);
	pap_machine solid();
	pap_machine show();
	link_ent moveto(level._original_pap_spot, 5);
	link_ent waittill("movedone");
	pap_machine_trig Unlink();
	pap_machine Unlink();
	link_ent delete();
	level._pap_hidden = 0;
}

/*
	Name: function_26186755
	Namespace: zm_temple_sq
	Checksum: 0x20B6F7C
	Offset: 0x5270
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function function_26186755(n_char_id)
{
	if(!isdefined(n_char_id))
	{
		n_char_id = 0;
	}
	var_bc7547cb = "a";
	switch(n_char_id)
	{
		case 0:
		{
			var_bc7547cb = "a";
			break;
		}
		case 1:
		{
			var_bc7547cb = "b";
			break;
		}
		case 2:
		{
			var_bc7547cb = "d";
			break;
		}
		case 3:
		{
			var_bc7547cb = "c";
			break;
		}
	}
	return var_bc7547cb;
}

/*
	Name: shut_off_all_looping_sounds
	Namespace: zm_temple_sq
	Checksum: 0xC3D40144
	Offset: 0x5328
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function shut_off_all_looping_sounds()
{
	gongs = GetEntArray("sq_gong", "targetname");
	for(i = 0; i < gongs.size; i++)
	{
		if(gongs[i].right_gong)
		{
			if(gongs[i].ringing)
			{
				if(level._num_gongs >= 0)
				{
					level._num_gongs--;
				}
				gongs[i] StopLoopSound(0.5);
			}
		}
		gongs[i].ringing = 0;
	}
	level notify("force_stoploopsound_end");
	level notify("kill_resonate");
}

/*
	Name: force_stoploopsound_end
	Namespace: zm_temple_sq
	Checksum: 0x9223FF2F
	Offset: 0x5428
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function force_stoploopsound_end()
{
	self.trigger endon("death");
	level waittill("force_stoploopsound_end");
	self StopLoopSound(0.5);
}

/*
	Name: function_e63287bf
	Namespace: zm_temple_sq
	Checksum: 0x990652D0
	Offset: 0x5470
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_e63287bf()
{
	/#
		level waittill("start_zombie_round_logic");
		zm_devgui::add_custom_devgui_callback(&function_b1064ab3);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_b1064ab3
	Namespace: zm_temple_sq
	Checksum: 0xA45C92D3
	Offset: 0x54E0
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function function_b1064ab3(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				SetDvar("Dev Block strings are not supported", 0);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				SetDvar("Dev Block strings are not supported", 1);
				return 1;
			}
		}
		return 0;
	#/
}

