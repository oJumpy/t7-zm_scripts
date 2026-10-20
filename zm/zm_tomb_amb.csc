#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_amb;

/*
	Name: main
	Namespace: zm_tomb_amb
	Checksum: 0x670B28C1
	Offset: 0x700
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function main()
{
	audio::snd_set_snapshot("cmn_fade_in");
	level.sndchambermusoverride = undefined;
	level thread function_af7b8418("water");
	level thread function_af7b8418("fire");
	level thread function_af7b8418("air");
	level thread function_af7b8418("lightning");
	setsoundcontext("train", "tunnel");
	level.sndambientcontextonplayer = &sndambientcontextonplayer;
	init_audio_clientfields();
	level thread sndstartambience();
	thread snd_play_loopers();
	level thread sndtombbgsetup();
	level thread function_c9207335();
	level thread function_c052f9b8();
	level thread startzmbspawnersoundloops();
}

/*
	Name: function_af7b8418
	Namespace: zm_tomb_amb
	Checksum: 0x93928687
	Offset: 0x880
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function function_af7b8418(str_name)
{
	if(!isdefined(level.var_c27b47a))
	{
		level.var_c27b47a = [];
	}
	if(!isdefined(level.var_c27b47a[str_name]))
	{
		level.var_c27b47a[str_name] = 1;
	}
	level waittill("snd" + str_name);
	level.var_c27b47a[str_name] = 0;
	if(isdefined(level.var_8f027e99[str_name]))
	{
		stopfx(0, level.var_8f027e99[str_name]);
		level.var_8f027e99[str_name] = undefined;
	}
}

/*
	Name: function_c9207335
	Namespace: zm_tomb_amb
	Checksum: 0x18477A54
	Offset: 0x938
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_c9207335()
{
	wait(3);
	level thread function_d667714e();
	var_13a52dfe = GetEntArray(0, "sndMusicTrig", "targetname");
	Array::thread_all(var_13a52dfe, &function_60a32834);
}

/*
	Name: function_60a32834
	Namespace: zm_tomb_amb
	Checksum: 0x3C7F9978
	Offset: 0x9B8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_60a32834()
{
	while(1)
	{
		self waittill("trigger", trigPlayer);
		if(trigPlayer isLocalPlayer())
		{
			level notify("hash_51d7bc7c", self.script_sound);
			self thread function_89793e8f();
			while(isdefined(trigPlayer) && trigPlayer istouching(self))
			{
				wait(0.016);
			}
			self notify("hash_ae459976");
		}
		else
		{
			wait(0.016);
		}
	}
}

/*
	Name: function_d667714e
	Namespace: zm_tomb_amb
	Checksum: 0x2C09AB09
	Offset: 0xA78
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_tomb_underscore_null";
	level.newmus = "mus_tomb_underscore_null";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(level.var_b6342abd, 2);
	while(1)
	{
		level waittill("hash_51d7bc7c", location);
		level.newmus = "mus_tomb_underscore_" + location;
		if(level.newmus != level.var_b6342abd)
		{
			level thread function_b234849(level.newmus);
			level.var_b6342abd = level.newmus;
		}
	}
}

/*
	Name: function_89793e8f
	Namespace: zm_tomb_amb
	Checksum: 0x4B699896
	Offset: 0xB78
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function function_89793e8f()
{
	self notify("hash_6c4e5e2e");
	self endon("hash_6c4e5e2e");
	level endon("hash_51d7bc7c");
	self waittill("hash_ae459976");
	wait(0.1);
	level notify("hash_51d7bc7c", "null");
}

/*
	Name: function_b234849
	Namespace: zm_tomb_amb
	Checksum: 0x6C78FCB3
	Offset: 0xBD8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_b234849(newmus)
{
	level endon("hash_51d7bc7c");
	level.var_eb526c90 StopAllLoopSounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 PlayLoopSound(newmus, 2);
}

/*
	Name: function_c052f9b8
	Namespace: zm_tomb_amb
	Checksum: 0x3468E135
	Offset: 0xC48
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function function_c052f9b8()
{
	while(1)
	{
		level waittill("sndweatherupdate");
		if(isdefined(level.sndweather.israin) && level.sndweather.israin)
		{
			setsoundcontext("train", "country");
		}
		else if(isdefined(level.sndweather.issnow) && level.sndweather.issnow)
		{
			setsoundcontext("train", "city");
		}
		else
		{
			setsoundcontext("train", "tunnel");
		}
	}
}

/*
	Name: sndweathersetup
	Namespace: zm_tomb_amb
	Checksum: 0x4AD49724
	Offset: 0xD20
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function sndweathersetup()
{
	level.sndweather = spawnstruct();
	level.sndweather.israin = 0;
	level.sndweather.issnow = 0;
}

/*
	Name: sndambientcontextonplayer
	Namespace: zm_tomb_amb
	Checksum: 0xDE974E92
	Offset: 0xD70
	Size: 0x95
	Parameters: 2
	Flags: None
*/
function sndambientcontextonplayer(room, player)
{
	switch(room)
	{
		case "tomb_cave":
		case "tomb_large_chamber":
		case "tomb_robot_head":
		case "tomb_spiral_staircase_bot":
		{
			setsoundcontext("grass", "in_grass");
			break;
		}
		case default:
		{
			setsoundcontext("grass", "no_grass");
			break;
		}
	}
}

/*
	Name: sndcapturezonetrigs
	Namespace: zm_tomb_amb
	Checksum: 0xBEA9063C
	Offset: 0xE10
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function sndcapturezonetrigs()
{
	trigs = GetEntArray(0, "sndCaptureZone", "targetname");
	if(isdefined(trigs))
	{
		foreach(trig in trigs)
		{
			trig.players = 0;
			trig.active = 0;
			trig thread sndcapturezonetrig();
		}
	}
}

/*
	Name: sndcapturezonetrig
	Namespace: zm_tomb_amb
	Checksum: 0xB35220D4
	Offset: 0xF08
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function sndcapturezonetrig()
{
	self thread sndcapturezonetrig_deactivate();
	while(1)
	{
		self waittill("trigger", who);
		if(who isPlayer() && (!isdefined(who.sndincapzone) && who.sndincapzone))
		{
			self.players++;
			who.sndincapzone = 1;
			self thread sndcapturezonetrig_player(who);
			if(!self.active)
			{
				self.active = 1;
				self thread sndcapturezonetrig_activate();
			}
		}
		wait(0.05);
	}
}

/*
	Name: sndcapturezonetrig_player
	Namespace: zm_tomb_amb
	Checksum: 0x14170CF6
	Offset: 0x1000
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function sndcapturezonetrig_player(player)
{
	while(isdefined(self) && isdefined(player) && player istouching(self))
	{
		wait(0.1);
	}
	self.players--;
	if(isdefined(player))
	{
		player.sndincapzone = 0;
	}
	self notify("player_left");
}

/*
	Name: sndcapturezonetrig_activate
	Namespace: zm_tomb_amb
	Checksum: 0x26CD2E68
	Offset: 0x1080
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function sndcapturezonetrig_activate()
{
	playsound(0, "zmb_zone_plate_down", self.origin);
	self.sndloop = self PlayLoopSound("zmb_zone_plate_loop", 2);
	self waittill("zone_deactivate");
	self.active = 0;
	self StopLoopSound(self.sndloop);
	playsound(0, "zmb_zone_plate_up", self.origin);
}

/*
	Name: sndcapturezonetrig_deactivate
	Namespace: zm_tomb_amb
	Checksum: 0xA2CC9AFD
	Offset: 0x1140
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function sndcapturezonetrig_deactivate()
{
	while(1)
	{
		self waittill("player_left");
		if(self.players <= 0)
		{
			self.players = 0;
			self notify("zone_deactivate");
		}
	}
}

/*
	Name: init_audio_clientfields
	Namespace: zm_tomb_amb
	Checksum: 0x4BAC2FD1
	Offset: 0x1190
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function init_audio_clientfields()
{
	level.var_8f027e99 = Array();
	clientfield::register("toplayer", "sndEggElements", 21000, 1, "int", &function_3599b48b, 0, 0);
	level.sndChargeShot_Func = &sndchargeshot;
}

/*
	Name: audio_snapshot_clientfield_callback
	Namespace: zm_tomb_amb
	Checksum: 0xC0C165A3
	Offset: 0x1218
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function audio_snapshot_clientfield_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		audio::playloopat(fieldName, (0, 0, 0));
	}
	else
	{
		audio::stoploopat(fieldName, (0, 0, 0));
	}
}

/*
	Name: function_3599b48b
	Namespace: zm_tomb_amb
	Checksum: 0x5F53CFE8
	Offset: 0x12A0
	Size: 0x2D9
	Parameters: 7
	Flags: None
*/
function function_3599b48b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	a_s_array = struct::get_array("s_zhdegg_elements", "targetname");
	if(!isdefined(level.var_8f027e99))
	{
		level.var_8f027e99 = Array();
	}
	if(newVal)
	{
		foreach(s_struct in a_s_array)
		{
			str_element = s_struct.script_string;
			if(s_struct.script_string == "lightning")
			{
				str_element = "elec";
			}
			if(s_struct.script_string == "water")
			{
				str_element = "ice";
			}
			if(isdefined(level.var_c27b47a[s_struct.script_string]) && level.var_c27b47a[s_struct.script_string])
			{
				if(isdefined(level.var_8f027e99[s_struct.script_string]))
				{
					stopfx(localClientNum, level.var_8f027e99[s_struct.script_string]);
				}
				level.var_8f027e99[s_struct.script_string] = playFX(localClientNum, level._effect[str_element + "_glow"], s_struct.origin);
			}
		}
		break;
	}
	foreach(fxid in level.var_8f027e99)
	{
		stopfx(localClientNum, fxid);
		fxid = undefined;
	}
}

/*
	Name: sndstartambience
	Namespace: zm_tomb_amb
	Checksum: 0x7C01CAE4
	Offset: 0x1588
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function sndstartambience()
{
	thread snd_start_autofx_audio();
	thread flyovers();
	thread function_57a479e1();
}

/*
	Name: snd_start_autofx_audio
	Namespace: zm_tomb_amb
	Checksum: 0x23D0890E
	Offset: 0x15C8
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function snd_start_autofx_audio()
{
	audio::snd_play_auto_fx("fx_tomb_fire_sm", "amb_fire_sm", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_fire_lg", "amb_fire_lg", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_steam_md", "amb_pipe_steam_md", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_light_expensive", "amb_main_light", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_light_lg", "amb_light_lrg", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_light_md", "amb_light_md", 0, 0, 0, 0);
}

/*
	Name: flyovers
	Namespace: zm_tomb_amb
	Checksum: 0xD3F6E262
	Offset: 0x16C8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function flyovers()
{
	while(1)
	{
		playsound(0, "amb_flyover", (1310, 859, 3064));
		wait(randomIntRange(2, 8));
	}
}

/*
	Name: function_57a479e1
	Namespace: zm_tomb_amb
	Checksum: 0x6660265F
	Offset: 0x1720
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_57a479e1()
{
	audio::playloopat("amb_dist_battle_front", (-2492, 1263, 691));
	audio::playloopat("amb_dist_battle_back", (4190, -1050, 910));
}

/*
	Name: sndmudslow
	Namespace: zm_tomb_amb
	Checksum: 0xCE72D353
	Offset: 0x1780
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function sndmudslow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsSpectating(localClientNum, 0))
	{
		if(newVal == 1)
		{
			self thread sndactivatemudloop();
		}
		else
		{
			self thread snddeactivatemudloop();
		}
	}
}

/*
	Name: sndactivatemudloop
	Namespace: zm_tomb_amb
	Checksum: 0xCD801760
	Offset: 0x1820
	Size: 0x15F
	Parameters: 0
	Flags: None
*/
function sndactivatemudloop()
{
	self endon("stop_mud");
	self endon("entityshutdown");
	if(!isdefined(self.sndwadeent))
	{
		self.sndwadeent = spawn(0, self.origin, "script_origin");
		self.sndwadeent LinkTo(self, "tag_origin");
	}
	self.sndwadeent.var_8d8259d3 = self.sndwadeent PlayLoopSound("zmb_tomb_slowed_movement_loop", 1);
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		mud_speed = Abs(self getspeed());
		mud_vol = audio::scale_speed(21, 285, 0.01, 1, mud_speed);
		self.sndwadeent setloopstate("zmb_tomb_slowed_movement_loop", mud_vol, 1);
		wait(0.1);
	}
}

/*
	Name: snddeactivatemudloop
	Namespace: zm_tomb_amb
	Checksum: 0xC12EE60
	Offset: 0x1988
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function snddeactivatemudloop()
{
	self notify("stop_mud");
	self.sndwadeent StopLoopSound(self.sndwadeent.var_8d8259d3, 1.5);
	self.sndwadeent.var_8d8259d3 = undefined;
}

/*
	Name: init
	Namespace: zm_tomb_amb
	Checksum: 0xB07B2D44
	Offset: 0x19E8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function init()
{
	level._entityShutDownCBFunc = &heli_linkto_sound_ents_delete;
	level.heliSoundValues = [];
	init_heli_sound_values("qrdrone", "turbine_idle", 30, 0.8, 0, 16, 0.9, 1.1);
	init_heli_sound_values("qrdrone", "turbine_moving", 30, 0, 0.9, 20, 0.9, 1.1);
	init_heli_sound_values("qrdrone", "turn", 5, 0, 1, 1, 1, 1);
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		level thread command_parser();
	#/
}

/*
	Name: init_heli_sound_values
	Namespace: zm_tomb_amb
	Checksum: 0x71BC7015
	Offset: 0x1B50
	Size: 0x28B
	Parameters: 8
	Flags: None
*/
function init_heli_sound_values(heli_type, part_type, max_speed_vol, min_vol, max_vol, max_speed_pitch, min_pitch, max_pitch)
{
	if(!isdefined(level.heliSoundValues[heli_type]))
	{
		level.heliSoundValues[heli_type] = [];
	}
	if(!isdefined(level.heliSoundValues[heli_type][part_type]))
	{
		level.heliSoundValues[heli_type][part_type] = spawnstruct();
	}
	level.heliSoundValues[heli_type][part_type].speedVolumeMax = max_speed_vol;
	level.heliSoundValues[heli_type][part_type].speedPitchMax = max_speed_pitch;
	level.heliSoundValues[heli_type][part_type].volumeMin = min_vol;
	level.heliSoundValues[heli_type][part_type].volumeMax = max_vol;
	level.heliSoundValues[heli_type][part_type].pitchMin = min_pitch;
	level.heliSoundValues[heli_type][part_type].pitchMax = max_pitch;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + heli_type);
			println("Dev Block strings are not supported" + part_type);
			println("Dev Block strings are not supported" + max_speed_vol);
			println("Dev Block strings are not supported" + min_vol);
			println("Dev Block strings are not supported" + max_vol);
			println("Dev Block strings are not supported" + max_speed_pitch);
			println("Dev Block strings are not supported" + min_pitch);
			println("Dev Block strings are not supported" + max_pitch);
		}
	#/
}

/*
	Name: command_parser
	Namespace: zm_tomb_amb
	Checksum: 0x859507F9
	Offset: 0x1DE8
	Size: 0x557
	Parameters: 0
	Flags: None
*/
function command_parser()
{
	/#
		while(1)
		{
			command = GetDvarString("Dev Block strings are not supported");
			if(command != "Dev Block strings are not supported")
			{
				success = 1;
				tokens = StrTok(command, "Dev Block strings are not supported");
				if(!isdefined(tokens[0]) || !isdefined(level.heliSoundValues[tokens[0]]))
				{
					if(isdefined(tokens[0]))
					{
						println("Dev Block strings are not supported" + tokens[0]);
					}
					else
					{
						println("Dev Block strings are not supported");
					}
					println("Dev Block strings are not supported");
					success = 0;
				}
				else if(!isdefined(tokens[1]))
				{
					if(isdefined(tokens[1]))
					{
						println("Dev Block strings are not supported" + tokens[0] + "Dev Block strings are not supported" + tokens[1]);
					}
					else
					{
						println("Dev Block strings are not supported" + tokens[0]);
					}
					println("Dev Block strings are not supported");
					success = 0;
				}
				else if(!isdefined(tokens[2]))
				{
					println("Dev Block strings are not supported" + tokens[0] + "Dev Block strings are not supported" + tokens[1]);
					println("Dev Block strings are not supported");
					success = 0;
				}
				else if(!isdefined(tokens[3]))
				{
					println("Dev Block strings are not supported" + tokens[0] + "Dev Block strings are not supported" + tokens[1]);
					println("Dev Block strings are not supported");
					success = 0;
				}
				if(success)
				{
					heli_type = tokens[0];
					heli_part = tokens[1];
					value_name = tokens[2];
					value = float(tokens[3]);
					switch(value_name)
					{
						case "Dev Block strings are not supported":
						{
							level.heliSoundValues[heli_type][heli_part].volumeMin = value;
							println("Dev Block strings are not supported" + value);
							break;
						}
						case "Dev Block strings are not supported":
						{
							level.heliSoundValues[heli_type][heli_part].volumeMax = value;
							println("Dev Block strings are not supported" + value);
							break;
						}
						case "Dev Block strings are not supported":
						{
							level.heliSoundValues[heli_type][heli_part].pitchMin = value;
							println("Dev Block strings are not supported" + value);
							break;
						}
						case "Dev Block strings are not supported":
						{
							level.heliSoundValues[heli_type][heli_part].pitchMax = value;
							println("Dev Block strings are not supported" + value);
							break;
						}
						case "Dev Block strings are not supported":
						{
							level.heliSoundValues[heli_type][heli_part].speedVolumeMax = value;
							println("Dev Block strings are not supported" + value);
							break;
						}
						case "Dev Block strings are not supported":
						{
							level.heliSoundValues[heli_type][heli_part].speedPitchMax = value;
							println("Dev Block strings are not supported" + value);
							break;
						}
						case default:
						{
							println("Dev Block strings are not supported");
						}
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.1);
		}
	#/
}

/*
	Name: init_heli_sounds_player_drone
	Namespace: zm_tomb_amb
	Checksum: 0xCAB746F0
	Offset: 0x2348
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function init_heli_sounds_player_drone()
{
	setup_heli_sounds("turbine_idle", "engine", "tag_body", "veh_qrdrone_turbine_idle");
	setup_heli_sounds("turbine_moving", "engine", "tag_body", "veh_qrdrone_turbine_moving");
	setup_heli_sounds("turn", "engine", "tag_body", "veh_qrdrone_idle_rotate");
	self.warning_tag = undefined;
}

/*
	Name: sound_linkto
	Namespace: zm_tomb_amb
	Checksum: 0xFAA1FC99
	Offset: 0x23F0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function sound_linkto(parent, tag)
{
	if(isdefined(tag))
	{
		self LinkTo(parent, tag);
	}
	else
	{
		self LinkTo(parent, "tag_body");
	}
}

/*
	Name: setup_heli_sounds
	Namespace: zm_tomb_amb
	Checksum: 0x3043B00D
	Offset: 0x2460
	Size: 0x38B
	Parameters: 7
	Flags: None
*/
function setup_heli_sounds(bone_location, type, tag, run, dmg1, dmg2, dmg3)
{
	self.HELI[bone_location] = spawnstruct();
	self.HELI[bone_location].sound_type = type;
	self.HELI[bone_location].run = spawn(0, self.origin, "script_origin");
	self.HELI[bone_location].run sound_linkto(self, tag);
	self.HELI[bone_location].run.alias = run;
	self thread heli_loop_sound_delete(self.HELI[bone_location].run);
	if(isdefined(dmg1))
	{
		self.HELI[bone_location].idle = spawn(0, self.origin, "script_origin");
		self.HELI[bone_location].idle sound_linkto(self, tag);
		self.HELI[bone_location].idle.alias = dmg1;
		self thread heli_loop_sound_delete(self.HELI[bone_location].dmg1);
	}
	if(isdefined(dmg2))
	{
		self.HELI[bone_location].idle = spawn(0, self.origin, "script_origin");
		self.HELI[bone_location].idle sound_linkto(self, tag);
		self.HELI[bone_location].idle.alias = dmg2;
		self thread heli_loop_sound_delete(self.HELI[bone_location].dmg2);
	}
	if(isdefined(dmg3))
	{
		self.HELI[bone_location].idle = spawn(0, self.origin, "script_origin");
		self.HELI[bone_location].idle sound_linkto(self, tag);
		self.HELI[bone_location].idle.alias = dmg3;
		self thread heli_loop_sound_delete(self.HELI[bone_location].dmg3);
	}
}

/*
	Name: start_helicopter_sounds
	Namespace: zm_tomb_amb
	Checksum: 0x91A39C03
	Offset: 0x27F8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function start_helicopter_sounds(localClientNum)
{
	if(isdefined(self.vehicleType))
	{
		self.HELI = [];
		self.terrain = [];
		self.sound_ents = [];
		self.cur_speed = 0;
		self.mph_to_inches_per_sec = 17.6;
		self.speed_of_wind = 20;
		self.idle_run_trans_speed = 5;
		self init_heli_sounds_player_drone();
		self play_player_drone_sounds();
	}
}

/*
	Name: heli_loop_sound_delete
	Namespace: zm_tomb_amb
	Checksum: 0xEE5E2368
	Offset: 0x28A0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function heli_loop_sound_delete(real_ent)
{
	self waittill("entityshutdown");
	real_ent Unlink();
	real_ent StopLoopSound(4);
	real_ent delete();
}

/*
	Name: heli_linkto_sound_ents_delete
	Namespace: zm_tomb_amb
	Checksum: 0xE774FAE6
	Offset: 0x2908
	Size: 0x23
	Parameters: 2
	Flags: None
*/
function heli_linkto_sound_ents_delete(localClientNum, entity)
{
	entity notify("entityshutdown");
}

/*
	Name: heli_sound_play
	Namespace: zm_tomb_amb
	Checksum: 0x1D828FD9
	Offset: 0x2938
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function heli_sound_play(heli_bone)
{
	switch(heli_bone.sound_type)
	{
		case "engine":
		{
			heli_bone.run PlayLoopSound(heli_bone.run.alias, 2);
			break;
		}
		case "wind":
		{
			break;
		}
		case default:
		{
			/#
				println("Dev Block strings are not supported" + heli_bone.type + "Dev Block strings are not supported");
			#/
			break;
		}
	}
}

/*
	Name: play_player_drone_sounds
	Namespace: zm_tomb_amb
	Checksum: 0x72CE6F4A
	Offset: 0x2A00
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function play_player_drone_sounds()
{
	self thread heli_idle_run_transition("qrdrone", "turbine_idle", 0.1, 1);
	self thread heli_idle_run_transition("qrdrone", "turbine_moving", 0.1, 1);
	self thread drone_up_down_transition();
	self thread drone_rotate_angle("qrdrone", "turn");
}

/*
	Name: heli_idle_run_transition
	Namespace: zm_tomb_amb
	Checksum: 0xFA93C1E9
	Offset: 0x2AB0
	Size: 0x45D
	Parameters: 4
	Flags: None
*/
function heli_idle_run_transition(heli_type, heli_part, wait_time, updown)
{
	self endon("entityshutdown");
	heli_bone = self.HELI[heli_part];
	run_id = heli_bone.run PlayLoopSound(heli_bone.run.alias, 0.5);
	if(!isdefined(wait_time))
	{
		wait_time = 0.5;
	}
	while(isdefined(self))
	{
		if(!isdefined(level.heliSoundValues[heli_type]) || !isdefined(level.heliSoundValues[heli_type][heli_part]))
		{
			/#
				println("Dev Block strings are not supported");
			#/
			return;
		}
		max_speed_vol = level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol = level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol = level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch = level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch = level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch = level.heliSoundValues[heli_type][heli_part].pitchMax;
		plr_vel = self GetVelocity();
		self.cur_speed = Abs(sqrt(VectorDot(plr_vel, plr_vel))) / self.mph_to_inches_per_sec;
		run_volume = audio::scale_speed(self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed);
		run_pitch = audio::scale_speed(self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed);
		if(isdefined(updown))
		{
			if(!isdefined(self.qrdrone_z_difference))
			{
				self.qrdrone_z_difference = 0;
			}
			run_volume_vertical = audio::scale_speed(5, 50, 0, 1, Abs(self.qrdrone_z_difference));
			run_volume = run_volume - run_volume_vertical;
		}
		if(isdefined(run_volume) && isdefined(run_pitch))
		{
			heli_bone.run setloopstate(heli_bone.run.alias, run_volume, run_pitch, 1, 0.15);
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					println("Dev Block strings are not supported" + self.cur_speed);
					println("Dev Block strings are not supported" + run_pitch);
					println("Dev Block strings are not supported" + self.cur_speed);
					println("Dev Block strings are not supported" + run_volume);
				}
			#/
		}
		wait(wait_time);
	}
}

/*
	Name: get_heli_sound_ent
	Namespace: zm_tomb_amb
	Checksum: 0x52705573
	Offset: 0x2F18
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function get_heli_sound_ent(sound_ent)
{
	if(!isdefined(sound_ent))
	{
		tag = "tag_origin";
		if(isdefined(self.warning_tag))
		{
			tag = self.warning_tag;
		}
		sound_ent = spawn(0, self GetTagOrigin(tag), "script_origin");
		sound_ent LinkTo(self, tag);
		self thread heli_sound_ent_delete(sound_ent);
	}
	return sound_ent;
}

/*
	Name: get_lock_sound_ent
	Namespace: zm_tomb_amb
	Checksum: 0x86EE9B2C
	Offset: 0x2FD0
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function get_lock_sound_ent()
{
	self.lock_sound_ent = get_heli_sound_ent(self.lock_sound_ent);
	return self.lock_sound_ent;
}

/*
	Name: get_leaving_sound_ent
	Namespace: zm_tomb_amb
	Checksum: 0x5BAB6901
	Offset: 0x3008
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function get_leaving_sound_ent()
{
	self.leaving_sound_ent = get_heli_sound_ent(self.leaving_sound_ent);
	return self.leaving_sound_ent;
}

/*
	Name: heli_sound_ent_delete
	Namespace: zm_tomb_amb
	Checksum: 0x89D568E7
	Offset: 0x3040
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function heli_sound_ent_delete(real_ent)
{
	self waittill("entityshutdown");
	real_ent StopLoopSound(0.1);
	real_ent delete();
}

/*
	Name: drone_up_down_transition
	Namespace: zm_tomb_amb
	Checksum: 0xF4BDB435
	Offset: 0x3098
	Size: 0x527
	Parameters: 0
	Flags: None
*/
function drone_up_down_transition()
{
	self endon("entityshutdown");
	volumerate = 1;
	qr_ent_up = spawn(0, self.origin, "script_origin");
	qr_ent_down = spawn(0, self.origin, "script_origin");
	qr_ent_either = spawn(0, self.origin, "script_origin");
	qr_ent_up thread qr_ent_cleanup(self);
	qr_ent_down thread qr_ent_cleanup(self);
	qr_ent_either thread qr_ent_cleanup(self);
	self.qrdrone_z_difference = 0;
	down = qr_ent_down PlayLoopSound("veh_qrdrone_move_down");
	qr_ent_down setloopstate("veh_qrdrone_move_down", 0, 0);
	up = qr_ent_up PlayLoopSound("veh_qrdrone_move_up");
	qr_ent_up setloopstate("veh_qrdrone_move_up", 0, 0);
	either = qr_ent_either PlayLoopSound("veh_qrdrone_vertical");
	qr_ent_either setloopstate("veh_qrdrone_vertical", 0, 0);
	tag = "tag_body";
	qr_ent_up LinkTo(self, tag);
	qr_ent_down LinkTo(self, tag);
	qr_ent_either LinkTo(self, tag);
	self thread drone_button_watch();
	while(1)
	{
		last_pos = self.origin[2];
		wait(0.1);
		self.qrdrone_z_difference = last_pos - self.origin[2];
		if(self.qrdrone_z_difference < 0)
		{
			up_difference = self.qrdrone_z_difference * -1;
			run_volume_up = audio::scale_speed(5, 40, 0, 1, up_difference);
			run_pitch_up = audio::scale_speed(5, 40, 0.9, 1.1, up_difference);
			run_volume_either = audio::scale_speed(5, 50, 0, 1, up_difference);
			run_pitch_either = audio::scale_speed(5, 50, 0.9, 1.1, up_difference);
		}
		else
		{
			run_volume_up = 0;
			run_pitch_up = 1;
			run_volume_either = audio::scale_speed(5, 50, 0, 1, self.qrdrone_z_difference);
			run_pitch_either = audio::scale_speed(5, 50, 0.95, 0.8, self.qrdrone_z_difference);
		}
		run_volume_down = audio::scale_speed(5, 50, 0, 1, self.qrdrone_z_difference);
		run_pitch_down = audio::scale_speed(5, 50, 1, 0.8, self.qrdrone_z_difference);
		qr_ent_down setloopstate("veh_qrdrone_move_down", run_volume_down, run_pitch_down, volumerate);
		qr_ent_up setloopstate("veh_qrdrone_move_up", run_volume_up, run_pitch_up, volumerate);
		qr_ent_either setloopstate("veh_qrdrone_vertical", run_volume_either, run_pitch_either, volumerate);
	}
}

/*
	Name: qr_ent_cleanup
	Namespace: zm_tomb_amb
	Checksum: 0x6100C9D0
	Offset: 0x35C8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function qr_ent_cleanup(veh_ent)
{
	veh_ent waittill("entityshutdown");
	self delete();
}

/*
	Name: drone_rotate_angle
	Namespace: zm_tomb_amb
	Checksum: 0xF0B8915E
	Offset: 0x3600
	Size: 0x22F
	Parameters: 2
	Flags: None
*/
function drone_rotate_angle(heli_type, heli_part)
{
	self endon("entityshutdown");
	level endon("save_restore");
	volumerate = 2.5;
	qr_ent_angle = spawn(0, self.origin, "script_origin");
	qr_ent_angle thread qr_ent_cleanup(self);
	angle = qr_ent_angle PlayLoopSound("veh_qrdrone_idle_rotate");
	setSoundVolume(angle, 0);
	tag = "tag_body";
	qr_ent_angle LinkTo(self, tag);
	while(1)
	{
		last_angle = Abs(self.angles[1]);
		wait(0.1);
		turning_speed = last_angle - Abs(self.angles[1]);
		abs_turning_speed = Abs(turning_speed);
		jet_stick_vol = audio::scale_speed(0, 5, 0, 0.4, abs_turning_speed);
		jet_stick_pitch = audio::scale_speed(0, 4, 0.9, 1.05, abs_turning_speed);
		qr_ent_angle setloopstate("veh_qrdrone_idle_rotate", jet_stick_vol, jet_stick_pitch, volumerate);
	}
}

/*
	Name: drone_button_watch
	Namespace: zm_tomb_amb
	Checksum: 0x951ED9FD
	Offset: 0x3838
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function drone_button_watch()
{
	self endon("entityshutdown");
	player = GetLocalPlayers()[0];
	return_to_zero = 1;
	while(1)
	{
		if(Abs(self.qrdrone_z_difference) > 5 && return_to_zero)
		{
			self playsound(0, "veh_qrdrone_move_start");
			return_to_zero = 0;
		}
		else if(Abs(self.qrdrone_z_difference) < 5 && !return_to_zero)
		{
			return_to_zero = 1;
		}
		wait(0.05);
	}
}

/*
	Name: snd_play_loopers
	Namespace: zm_tomb_amb
	Checksum: 0x18F96593
	Offset: 0x3928
	Size: 0x693
	Parameters: 0
	Flags: None
*/
function snd_play_loopers()
{
	audio::playloopat("amb_cave_enter", (2352, 4138, -278));
	audio::playloopat("amb_cave_enter", (2176, 807, 107));
	audio::playloopat("amb_cave_enter", (-2433, 494, 220));
	audio::playloopat("amb_elemental_corner_air", (11279, -8683, -271));
	audio::playloopat("amb_elemental_corner_fire", (9459, -8564, -283));
	audio::playloopat("amb_elemental_corner_fire_lava", (9904, -8612, -405));
	audio::playloopat("amb_elemental_corner_lightning", (9616, -6973, -252));
	audio::playloopat("amb_elemental_corner_ice", (11252, -7040, -215));
	audio::playloopat("amb_plane_dist_loop", (636, 5382, 453));
	audio::playloopat("amb_plane_dist_loop", (2515, 2411, 377));
	audio::playloopat("amb_plane_dist_loop", (-76, 58, 1035));
	audio::playloopat("amb_plane_dist_loop", (-2452, -690, 818));
	audio::playloopat("amb_plane_dist_loop", (886, -4399, 1051));
	audio::playloopat("amb_plane_dist_loop", (1078, 2266, 744));
	audio::playloopat("amb_spawn_rays", (9514, -8741, -335));
	audio::playloopat("amb_spawn_rays", (9319, -8519, -295));
	audio::playloopat("amb_spawn_rays", (9391, -7986, -258));
	audio::playloopat("amb_spawn_rays", (9322, -7608, -165));
	audio::playloopat("amb_spawn_rays", (9322, -7608, -165));
	audio::playloopat("amb_spawn_rays", (9369, -7021, -269));
	audio::playloopat("amb_spawn_rays", (9730, -6749, -175));
	audio::playloopat("amb_spawn_rays", (9997, -7007, -200));
	audio::playloopat("amb_spawn_rays", (10262, -7362, -341));
	audio::playloopat("amb_spawn_rays", (10985, -6684, -3));
	audio::playloopat("amb_spawn_rays", (11542, -7255, -291));
	audio::playloopat("amb_spawn_rays", (11291, -7653, -235));
	audio::playloopat("amb_spawn_rays", (11327, -8091, -203));
	audio::playloopat("amb_spawn_rays", (11596, -8545, -222));
	audio::playloopat("amb_spawn_rays", (11102, -889, -305));
	audio::playloopat("amb_spawn_rays", (10586, -8794, -225));
	audio::playloopat("amb_spawn_rays", (10117, -8888, -264));
	audio::playloopat("amb_spawn_rays", (10048, -8431, -321));
	audio::playloopat("amb_spawn_rays", (11104, -8896, -300));
	audio::playloopat("amb_spawn_rays", (10416, -7055, -337));
	audio::playloopat("amb_spawn_rays", (11100, -8894, -303));
	audio::playloopat("zmb_sq_electric_pillar", (10091, -7663, -372));
	audio::playloopat("zmb_sq_ice_pillar", (10567, -7657, -372));
	audio::playloopat("zmb_sq_air_pillar", (10581, -8142, -377));
	audio::playloopat("zmb_sq_fire_pillar", (10106, -8147, -382));
	audio::playloopat("amb_robot_fans", (-6252, -6534, 398));
	audio::playloopat("amb_robot_fans", (-6767, -6543, 361));
	audio::playloopat("amb_robot_fans", (-5677, -6501, 405));
}

/*
	Name: sndchargeshot
	Namespace: zm_tomb_amb
	Checksum: 0x46D7A96C
	Offset: 0x3FC8
	Size: 0x193
	Parameters: 3
	Flags: None
*/
function sndchargeshot(localClientNum, weapon, chargeShotLevel)
{
	weaponName = weapon.name;
	self.sndcurrentcharge = chargeShotLevel;
	if(!isdefined(self.sndchargeloopent))
	{
		self.sndchargeloopent = spawn(0, (0, 0, 0), "script_origin");
	}
	self thread sndstoploopent();
	if(!isdefined(self.sndlastcharge) || self.sndcurrentcharge != self.sndlastcharge)
	{
		alias = "wpn_firestaff_charge_";
		if(weaponName == "staff_water_upgraded")
		{
			alias = "wpn_waterstaff_charge_";
		}
		else if(weaponName == "staff_lightning_upgraded")
		{
			alias = "wpn_lightningstaff_charge_";
		}
		else if(weaponName == "staff_air_upgraded")
		{
			alias = "wpn_airstaff_charge_";
		}
		self.var_710dd188 = self.sndchargeloopent PlayLoopSound(alias + "loop", 1.5);
		playsound(localClientNum, alias + self.sndcurrentcharge, (0, 0, 0));
		self.sndlastcharge = self.sndcurrentcharge;
	}
}

/*
	Name: sndstoploopent
	Namespace: zm_tomb_amb
	Checksum: 0xF309F496
	Offset: 0x4168
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function sndstoploopent()
{
	level notify("sndstopthisfunction");
	level endon("sndstopthisfunction");
	wait(0.5);
	self.sndchargeloopent StopLoopSound(self.var_710dd188, 0.1);
	self.sndcurrentcharge = 0;
}

/*
	Name: sndtombbgsetup
	Namespace: zm_tomb_amb
	Checksum: 0x99EC1590
	Offset: 0x41D0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function sndtombbgsetup()
{
}

/*
	Name: sndtombbgplayers
	Namespace: zm_tomb_amb
	Checksum: 0x74EF3744
	Offset: 0x41E0
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function sndtombbgplayers(localClientNum)
{
	self endon("disconnect");
	self.sndent = spawn(0, (0, 0, 0), "script_origin");
	self.sndbgalias = "mus_underscore_default";
	self.sndbgaliaslast = "null";
	while(1)
	{
		if(self.sndbgaliaslast != self.sndbgalias)
		{
			self.sndbgaliaslast = self.sndbgalias;
			self.sndent notify("sndbackgroundchanging");
			self.sndent thread sndtombbgmusic(self.sndbgalias);
		}
		wait(2);
	}
}

/*
	Name: sndtombbgtriggers
	Namespace: zm_tomb_amb
	Checksum: 0x108F668F
	Offset: 0x42B0
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function sndtombbgtriggers(localClientNum)
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self waittill("trigger", who);
		if(isdefined(who) && who isLocalPlayer())
		{
			if(isdefined(level.sndchambermusoverride) && self.script_sound == "mus_underscore_chamber")
			{
				who.sndbgalias = level.sndchambermusoverride;
			}
			else
			{
				who.sndbgalias = self.script_sound;
			}
			who thread sndtombbgtrigger_timeout();
		}
		wait(0.5);
	}
}

/*
	Name: sndtombbgtrigger_timeout
	Namespace: zm_tomb_amb
	Checksum: 0x1C157040
	Offset: 0x4390
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function sndtombbgtrigger_timeout()
{
	self notify("sndbgtimeout");
	self endon("disconnect");
	self endon("sndbgtimeout");
	wait(4);
	if(isdefined(self) && self isLocalPlayer())
	{
		self.sndbgalias = "mus_underscore_default";
	}
}

/*
	Name: sndtombbgmusic
	Namespace: zm_tomb_amb
	Checksum: 0x12C80BC0
	Offset: 0x43F8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function sndtombbgmusic(alias)
{
	self endon("sndbackgroundchanging");
	self endon("death");
	self StopLoopSound(2);
	wait(2);
	self PlayLoopSound(alias, 2);
}

/*
	Name: sndmaelstrom
	Namespace: zm_tomb_amb
	Checksum: 0x10546557
	Offset: 0x4460
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function sndmaelstrom(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level thread function_572d945d();
	if(newVal == 1)
	{
		if(!isdefined(self.sndmaelstrom))
		{
			self.sndmaelstrom = self PlayLoopSound("amb_maelstrom", 3);
		}
	}
	else if(isdefined(self.sndmaelstrom))
	{
		self StopLoopSound(self.sndmaelstrom);
		self.sndmaelstrom = undefined;
	}
}

/*
	Name: function_572d945d
	Namespace: zm_tomb_amb
	Checksum: 0x9694F800
	Offset: 0x4540
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function function_572d945d()
{
	if(!isdefined(level.var_ca141ce8))
	{
		level.var_ca141ce8 = 1;
	}
	while(level.var_ca141ce8 == 1)
	{
		wait(randomIntRange(5, 15));
		playsound(0, "amb_distant_explosion", (0, 0, 0));
	}
}

/*
	Name: startzmbspawnersoundloops
	Namespace: zm_tomb_amb
	Checksum: 0xECB7F1EF
	Offset: 0x45B0
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function startzmbspawnersoundloops()
{
	loopers = struct::get_array("exterior_goal", "targetname");
	if(isdefined(loopers) && loopers.size > 0)
	{
		delay = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + loopers.size + "Dev Block strings are not supported");
			}
		#/
		for(i = 0; i < loopers.size; i++)
		{
			loopers[i] thread soundLoopThink();
			delay = delay + 1;
			if(delay % 20 == 0)
			{
				wait(0.016);
			}
		}
	}
	else
	{
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported");
		}
	}
	/#
	#/
}

/*
	Name: soundLoopThink
	Namespace: zm_tomb_amb
	Checksum: 0xF4B7BF50
	Offset: 0x4718
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function soundLoopThink()
{
	if(!isdefined(self.origin))
	{
		return;
	}
	if(!isdefined(self.script_sound))
	{
		self.script_sound = "zmb_spawn_walla";
	}
	notifyname = "";
	/#
		Assert(isdefined(notifyname));
	#/
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	/#
		Assert(isdefined(notifyname));
	#/
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundloopemitter(self.script_sound, self.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundstoploopemitter(self.script_sound, self.origin);
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

